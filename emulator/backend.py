"""Fake Uconnect service layer for the stock HMI.

The HMI (main.swf) opens an XMLSocket to 127.0.0.1:4400 (ModuleLink.xml) and speaks
NUL-terminated JSON. Outgoing frames look like
    {"Length":00085, "Type":"Subscribe"|"Command"|..., "Dest":"<Module>", ...}
and every frame we send back is {"<Module>": {<signal or reply>: ...}}.

Module state lives in state.json (defaults) and is mutated by commands; the HMI is
answered from that state, so most screens work without per-module code.
"""
import json, re, socket, sys, threading, time, os, copy, queue, http.server

HERE = os.path.dirname(os.path.abspath(__file__))
# Dev instances (dev/launch.py) run side by side: own port, own HMI copy, own logs/settings.
INSTANCE = os.environ.get("UC_INSTANCE_DIR", HERE)
HOST, PORT = "127.0.0.1", int(os.environ.get("UC_PORT", 4400))
PANEL_PORT = PORT + 1
LOG = open(os.path.join(INSTANCE, "backend.log"), "w", encoding="utf-8")
STATE = json.load(open(os.path.join(HERE, "state.json"), encoding="utf-8"))
PERSIST_FILE = os.path.join(INSTANCE, "persistency.json")
# Factory defaults from state.json "_persist", overlaid with what the HMI wrote last run.
PERSIST = copy.deepcopy(STATE.get("_persist", {}))
if os.path.exists(PERSIST_FILE):
    for _dest, _kv in json.load(open(PERSIST_FILE, encoding="utf-8")).items():
        PERSIST.setdefault(_dest, {}).update(_kv)

clients = {}  # conn -> outgoing frame queue
lock = threading.Lock()
sent_bytes = 0


def log(direction, text):
    LOG.write(f"{time.strftime('%H:%M:%S')} {direction} {text}\n")
    LOG.flush()


def send(module, payload, conn=None):
    global sent_bytes
    frame = json.dumps({module: payload}, separators=(",", ":"))
    data = frame.encode("utf-8") + b"\0"
    with lock:
        log(">>", f"@{sent_bytes} {frame[:400]}")
        sent_bytes += len(data)
        for c in ([conn] if conn else list(clients)):
            if c in clients:
                clients[c].put(data)


def writer(conn, q):
    # AIR's XMLSocket drops data when several KB of frames land in one burst
    # (frames get truncated/merged), so frames go out one at a time with a gap.
    while True:
        data = q.get()
        if data is None:
            return
        try:
            conn.sendall(data)
        except OSError:
            return
        time.sleep(0.004 if not q.empty() else 0)


def mod(name):
    return STATE.setdefault(name, {})


# The HMI pads Length with leading zeros, which is not valid JSON.
LEN_RE = re.compile(r'^\{"Length":\d+,\s*')


def parse(raw):
    return json.loads("{" + LEN_RE.sub("", raw, count=1))


def props_of(module):
    """Property values for get(All)Properties; "_props" overrides when a module's
    property replies are shaped differently from its signals."""
    return STATE.get("_props", {}).get(module) or mod(module)


def prop_store(module):
    """Writable get(All)Properties store for a module (created on first use)."""
    return STATE.setdefault("_props", {}).setdefault(module, {})


# Modules whose change signals wrap the value in its own name: {"keyUnlock": {"keyUnlock": v}}.
# Everything else signals the raw value: {"heatSeatFrontLeft": v}.
NESTED = {"PersonalConfig", "Clock"}


def set_property(module, key, value, conn=None):
    """Store a property and emit its change signal in the module's style."""
    prop_store(module)[key] = value
    sig = {key: value} if module in NESTED else value
    mod(module)[key] = sig
    send(module, {key: sig}, conn)


def emit(module, signal, conn=None):
    if signal in mod(module):
        send(module, {signal: mod(module)[signal]}, conn)


def set_props(module, props, conn=None):
    for k, v in props.items():
        mod(module)[k] = v
        send(module, {k: v}, conn)


def handle_persistency(dest, packet, conn):
    """read/write key-value store shared by Persistency, *Persistency and *PersistenceManager."""
    store = PERSIST.setdefault(dest, {})
    if "read" in packet:
        key = packet["read"]["key"]
        if key in store:
            send(dest, {"read": {"res": {"key": key, "value": store[key]}}}, conn)
        else:
            send(dest, {"read": {"key": key, "err": "notFound"}}, conn)
    elif "write" in packet:
        for key, item in packet["write"].items():
            store[key] = item.get("value") if isinstance(item, dict) else item
        json.dump(PERSIST, open(PERSIST_FILE, "w", encoding="utf-8"), indent=1)
        send(dest, {"write": {"res": "success"}}, conn)


# Per-module hooks: (module, command) -> fn(packet_args, conn). Generic logic covers the rest.
HOOKS = {}
API = {}  # panel GET path -> fn() returning JSON-able data (e.g. "/api/perf")


def hook(module, command):
    def deco(fn):
        HOOKS[(module, command)] = fn
        return fn
    return deco


import handlers  # noqa: E402  registers HOOKS, needs send/mod/set_props above
handlers.init(sys.modules[__name__])


def handle_command(dest, packet, conn):
    if ("read" in packet or "write" in packet) and (dest, next(iter(packet))) not in HOOKS:
        return handle_persistency(dest, packet, conn)
    replies = STATE.get("_replies", {}).get(dest, {})
    for cmd, args in packet.items():
        fn = HOOKS.get((dest, cmd)) or HOOKS.get(("*", cmd))
        if fn:
            fn(dest, args if isinstance(args, dict) else {"value": args}, conn)
        elif cmd in replies:
            # Canned reply table: {"_replies": {Dest: {command: payload}}}
            send(dest, {cmd: replies[cmd]}, conn)
        elif cmd == "getProperties":
            src = props_of(dest)
            props = {p: src[p] for p in args.get("props", []) if isinstance(p, str) and p in src}
            send(dest, {"getProperties": props}, conn)
        elif cmd == "getAllProperties":
            send(dest, {"getAllProperties": props_of(dest)}, conn)
        elif cmd == "setProperties" and isinstance(args, dict):
            for k, v in (args.get("props") if isinstance(args.get("props"), dict) else args).items():
                set_property(dest, k, v, conn)
        elif cmd.startswith("set") and isinstance(args, dict) and args:
            # Generic setter: setFoo {"foo": v} -> state + signal echo.
            set_props(dest, args, conn)
        else:
            log("??", f"unhandled {dest}.{cmd} {json.dumps(args)[:200]}")


def handle(msg, conn):
    t, dest = msg.get("Type"), msg.get("Dest", "")
    if t == "subscribeNameHasOwnerNotification":
        if dest not in STATE.get("_unavailable", []):
            send(dest, {"dBusServiceAvailable": "true"}, conn)
    elif t == "Subscribe":
        for s in msg.get("Signals") or [msg.get("Signal")]:
            emit(dest, s, conn)
    elif t == "EmitSignal":
        handlers.on_emit_signal(msg.get("packet", {}))
    elif t == "Unsubscribe":
        pass
    elif t == "Command":
        handle_command(dest, msg.get("packet", {}), conn)
    else:
        log("??", f"unknown type {t} {dest}")


def serve_client(conn):
    q = queue.Queue()
    with lock:
        clients[conn] = q
    handlers.hmi_connected(True)
    threading.Thread(target=writer, args=(conn, q), daemon=True).start()
    buf = b""
    try:
        while True:
            data = conn.recv(65536)
            if not data:
                break
            buf += data
            *frames, buf = buf.split(b"\0")
            for f in frames:
                raw = f.decode("utf-8", "replace").strip()
                if not raw:
                    continue
                log("<<", raw[:400])
                try:
                    handle(parse(raw), conn)
                except Exception as e:  # keep serving; a bad frame must not kill the car
                    log("!!", f"{e!r} on {raw[:200]}")
    except OSError:
        pass  # HMI closed/restarted; it reconnects on its own
    finally:
        with lock:
            clients.pop(conn, None)
            if not clients:
                handlers.hmi_connected(False)
        q.put(None)
        conn.close()


class Panel(http.server.BaseHTTPRequestHandler):
    """Hardware control panel: GET / serves panel.html, GET /status, POST /act {action, value}."""

    def reply(self, code, body=b"", ctype="text/plain; charset=utf-8"):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/status":
            self.reply(200, json.dumps(handlers.panel_status()).encode(), "application/json")
        elif self.path in API:  # data endpoints registered by feature modules
            self.reply(200, json.dumps(API[self.path]()).encode(), "application/json")
        else:
            self.reply(200, open(os.path.join(HERE, "panel.html"), "rb").read(), "text/html; charset=utf-8")

    def do_POST(self):
        try:
            req = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
            log("PANEL", json.dumps(req))
            handlers.panel_action(req.get("action"), req.get("value"))
            self.reply(204)
        except Exception as e:
            log("!!", f"panel {e!r}")
            self.reply(400, str(e).encode())

    def log_message(self, *a):
        pass


def main():
    srv = socket.socket()
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind((HOST, PORT))
    srv.listen(4)
    print(f"backend listening on {HOST}:{PORT}", flush=True)
    threading.Thread(target=handlers.ticker, daemon=True).start()
    panel = http.server.ThreadingHTTPServer((HOST, PANEL_PORT), Panel)
    threading.Thread(target=panel.serve_forever, daemon=True).start()
    print(f"control panel on http://{HOST}:{PANEL_PORT}/", flush=True)
    if "--hmi" in sys.argv:
        threading.Thread(target=handlers.run_hmi, daemon=True).start()
    while True:
        conn, _ = srv.accept()
        conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        threading.Thread(target=serve_client, args=(conn,), daemon=True).start()


if __name__ == "__main__":
    main()
