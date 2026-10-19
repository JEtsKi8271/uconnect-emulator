"""SiriusXM satellite radio (XMApp, XMPresets, XMFavorites, XMGameZone, XMTrafficJump,
XMInstantReplay) and SiriusXM Travel Link (XMFuel, XMLandWeather, XMSports, XMMovies).

Shapes come from MainSupplement com/nfuzion/moduleLink/SatelliteRadio*.as,
PresetPersistencyManager.as and TravelLink*.as.
"""
import os, sqlite3, threading, time

import handlers as H
from handlers import on

# SatelliteRadio.isAvailable / TravelLink.isAvailable need VARIANT_SDARS "YES", VARIANT_MODEL
# "VP4" and VehConfig destination "2" (USA). RA4 = VP4 NAFTA head unit.
VARIANT = {"VARIANT_DAB": "NO", "VARIANT_ECELL": "NO", "VARIANT_HWTYPE": "B", "VARIANT_MARKET": "NA",
           "VARIANT_MODEL": "VP4", "VARIANT_MODELYEAR": "15", "VARIANT_PRODUCT": "VP4",
           "VARIANT_REVISION": "1", "VARIANT_SDARS": "YES", "VARIANT_TMCPRO": "NO"}


@on("platform", "get_variantinfo")
def platform_variant(dest, args, conn):
    H.B.send("platform", {"get_variantinfo": VARIANT}, conn)


# ---------------------------------------------------------------- channel lineup
CATS = {"Pop": 1, "Rock": 2, "Hip-Hop/R&B": 3, "Dance/Electronic": 4, "Country": 5,
        "Jazz/Standards": 6, "Classical": 7, "Sports": 8, "Howard Stern": 9, "Comedy": 10,
        "News/Public Radio": 11, "Politics/Issues": 12, "Traffic/Weather": 13}
# (number, name, category, [(artist, title), ...]); talk channels use show / topic.
LINEUP = [
    (1, "SiriusXM Preview", "Pop", [("SiriusXM", "Channel Guide"), ("SiriusXM", "Free Preview Weekend")]),
    (2, "SiriusXM Hits 1", "Pop", [("Taylor Swift", "Blank Space"), ("Mark Ronson", "Uptown Funk"),
                                   ("Ed Sheeran", "Thinking Out Loud"), ("Maroon 5", "Sugar")]),
    (3, "Venus", "Pop", [("Jason Derulo", "Want To Want Me"), ("Rihanna", "FourFiveSeconds"), ("Ariana Grande", "One Last Time")]),
    (5, "'50s on 5", "Pop", [("Elvis Presley", "Jailhouse Rock"), ("Buddy Holly", "Peggy Sue"), ("Chuck Berry", "Johnny B. Goode")]),
    (6, "'60s on 6", "Pop", [("The Beatles", "Help!"), ("The Supremes", "Stop! In The Name Of Love"), ("The Beach Boys", "Good Vibrations")]),
    (7, "'70s on 7", "Pop", [("Fleetwood Mac", "Dreams"), ("ABBA", "Dancing Queen"), ("Elton John", "Tiny Dancer")]),
    (8, "'80s on 8", "Pop", [("Michael Jackson", "Billie Jean"), ("a-ha", "Take On Me"),
                             ("Madonna", "Like A Virgin"), ("Duran Duran", "Hungry Like The Wolf")]),
    (9, "'90s on 9", "Pop", [("Nirvana", "Smells Like Teen Spirit"), ("TLC", "Waterfalls"), ("Spice Girls", "Wannabe")]),
    (10, "Pop2K", "Pop", [("OutKast", "Hey Ya!"), ("Britney Spears", "Toxic"), ("Kelly Clarkson", "Since U Been Gone")]),
    (15, "The Pulse", "Pop", [("Coldplay", "Viva La Vida"), ("Adele", "Rolling In The Deep"), ("OneRepublic", "Counting Stars")]),
    (16, "The Blend", "Pop", [("Train", "Hey, Soul Sister"), ("Sara Bareilles", "Love Song"), ("Phil Collins", "Easy Lover")]),
    (20, "Elvis Radio", "Rock", [("Elvis Presley", "Suspicious Minds"), ("Elvis Presley", "Burning Love"), ("Elvis Presley", "Hound Dog")]),
    (24, "Radio Margaritaville", "Rock", [("Jimmy Buffett", "Margaritaville"), ("Kenny Chesney", "No Shoes, No Shirt, No Problems")]),
    (25, "Classic Rewind", "Rock", [("Bon Jovi", "Livin' On A Prayer"), ("Def Leppard", "Pour Some Sugar On Me"), ("Journey", "Separate Ways")]),
    (26, "Classic Vinyl", "Rock", [("Led Zeppelin", "Black Dog"), ("The Who", "Baba O'Riley"), ("Lynyrd Skynyrd", "Free Bird")]),
    (27, "Deep Tracks", "Rock", [("Pink Floyd", "Echoes"), ("The Allman Brothers Band", "Whipping Post"), ("Neil Young", "Cortez The Killer")]),
    (32, "The Bridge", "Rock", [("James Taylor", "Fire And Rain"), ("Eagles", "Peaceful Easy Feeling"), ("Jackson Browne", "Running On Empty")]),
    (34, "Lithium", "Rock", [("Pearl Jam", "Alive"), ("Soundgarden", "Black Hole Sun"), ("Stone Temple Pilots", "Plush")]),
    (36, "Alt Nation", "Rock", [("Imagine Dragons", "Shots"), ("Walk The Moon", "Shut Up And Dance"), ("Twenty One Pilots", "Tear In My Heart")]),
    (37, "Octane", "Rock", [("Shinedown", "Cut The Cord"), ("Disturbed", "The Vengeful One"), ("Breaking Benjamin", "Failure")]),
    (39, "Hair Nation", "Rock", [("Motley Crue", "Dr. Feelgood"), ("Poison", "Talk Dirty To Me"), ("Whitesnake", "Here I Go Again")]),
    (40, "Liquid Metal", "Rock", [("Metallica", "Master Of Puppets"), ("Slayer", "Raining Blood"), ("Pantera", "Walk")]),
    (44, "Hip-Hop Nation", "Hip-Hop/R&B", [("Drake", "Energy"), ("Kendrick Lamar", "King Kunta"), ("Big Sean", "Blessings")]),
    (45, "Shade 45", "Hip-Hop/R&B", [("Eminem", "Lose Yourself"), ("50 Cent", "In Da Club"), ("Dr. Dre", "Still D.R.E.")]),
    (46, "The Heat", "Hip-Hop/R&B", [("The Weeknd", "Earned It"), ("Chris Brown", "Ayo"), ("Usher", "I Don't Mind")]),
    (48, "Heart & Soul", "Hip-Hop/R&B", [("Alicia Keys", "No One"), ("John Legend", "All Of Me"), ("Mary J. Blige", "Be Without You")]),
    (51, "BPM", "Dance/Electronic", [("Calvin Harris", "Summer"), ("David Guetta", "Titanium"), ("Avicii", "Wake Me Up")]),
    (52, "Electric Area", "Dance/Electronic", [("Hardwell", "Spaceman"), ("Tiesto", "Red Lights"), ("Armin van Buuren", "Ping Pong")]),
    (56, "The Highway", "Country", [("Luke Bryan", "Kick The Dust Up"), ("Florida Georgia Line", "Sun Daze"),
                                    ("Carrie Underwood", "Smoke Break"), ("Sam Hunt", "Take Your Time")]),
    (58, "Prime Country", "Country", [("George Strait", "Check Yes Or No"), ("Alan Jackson", "Chattahoochee"), ("Brooks & Dunn", "Neon Moon")]),
    (59, "Willie's Roadhouse", "Country", [("Willie Nelson", "On The Road Again"), ("Patsy Cline", "Crazy"), ("Merle Haggard", "Mama Tried")]),
    (60, "Outlaw Country", "Country", [("Johnny Cash", "Folsom Prison Blues"), ("Waylon Jennings", "Luckenbach, Texas"), ("Steve Earle", "Copperhead Road")]),
    (67, "Real Jazz", "Jazz/Standards", [("Miles Davis", "So What"), ("John Coltrane", "Naima"), ("Dave Brubeck", "Take Five")]),
    (71, "Siriusly Sinatra", "Jazz/Standards", [("Frank Sinatra", "Fly Me To The Moon"), ("Tony Bennett", "The Way You Look Tonight"), ("Dean Martin", "That's Amore")]),
    (76, "Symphony Hall", "Classical", [("Beethoven", "Symphony No. 5"), ("Mozart", "Eine kleine Nachtmusik"), ("Dvorak", "New World Symphony")]),
    (80, "ESPN Radio", "Sports", [("Mike & Mike", "NFL Week 6 Preview"), ("SportsCenter", "Top Headlines")]),
    (83, "FOX Sports Radio", "Sports", [("The Herd", "Playoff Picture"), ("Fox Sports Update", "Scores And Highlights")]),
    (88, "SiriusXM NFL Radio", "Sports", [("Movin' The Chains", "Week 6 Breakdown"), ("Opening Drive", "Injury Report")]),
    (89, "MLB Network Radio", "Sports", [("Inside Pitch", "ALCS Game 3"), ("Power Alley", "Postseason Talk")]),
    (94, "Comedy Greats", "Comedy", [("George Carlin", "Stuff"), ("Richard Pryor", "Live On The Sunset Strip")]),
    (96, "Laugh USA", "Comedy", [("Jim Gaffigan", "Hot Pockets"), ("Brian Regan", "Stupid In School")]),
    (99, "Raw Dog Comedy", "Comedy", [("Louis C.K.", "Hilarious"), ("Bill Burr", "Why Do I Do This?")]),
    (100, "Howard 100", "Howard Stern", [("The Howard Stern Show", "Live"), ("Howard 100 News", "Wrap-Up")]),
    (101, "Howard 101", "Howard Stern", [("Howard Stern Show", "Replay"), ("Bad Boy Hour", "Special")]),
    (114, "FOX News Channel", "News/Public Radio", [("FOX News", "America's Newsroom"), ("FOX News", "The Five")]),
    (116, "CNN", "News/Public Radio", [("CNN", "Newsroom"), ("CNN", "The Situation Room")]),
    (124, "POTUS", "Politics/Issues", [("POTUS", "Morning Briefing"), ("POTUS", "Campaign 2016")]),
    (134, "Chicago Traffic/Weather", "Traffic/Weather", [("Traffic & Weather", "Chicago Area Report")]),
    (136, "Detroit Traffic/Weather", "Traffic/Weather", [("Traffic & Weather", "Detroit Area Report")]),
    (138, "New York Traffic/Weather", "Traffic/Weather", [("Traffic & Weather", "New York Area Report")]),
]
CH = {c[0]: c for c in LINEUP}
NUMS = [c[0] for c in LINEUP]
XM = {"channel": 2, "previous": 8, "presets": [2, 8, 26, 36, 44, 51, 56, 67, 88, 100, 114, 0],
      "skipped": [], "favorites": [], "fav_id": 0, "market": 0, "jump_from": None}
ESN = "0R7X9C2KQ4"


def now_playing(num):
    songs = CH[num][3]
    length = 170 + (num * 37) % 100  # each channel has its own song length -> changes are staggered
    return songs[(int(time.time()) + num * 53) // length % len(songs)]


SHORT = {1: "Preview", 2: "Hits 1", 3: "Venus", 5: "50s on 5", 6: "60s on 6", 7: "70s on 7", 8: "80s on 8",
         9: "90s on 9", 10: "Pop2K", 15: "Pulse", 16: "Blend", 20: "Elvis", 24: "Margvlle", 25: "Rewind",
         26: "Vinyl", 27: "DeepTrks", 32: "Bridge", 34: "Lithium", 36: "AltNation", 37: "Octane", 39: "HairNatn",
         40: "LiqMetal", 44: "HipHopNtn", 45: "Shade 45", 46: "The Heat", 48: "HrtSoul", 51: "BPM", 52: "Electric",
         56: "Highway", 58: "PrimeCtry", 59: "Willie's", 60: "Outlaw", 67: "RealJazz", 71: "Sinatra",
         76: "Symphony", 80: "ESPN", 83: "FOXSports", 88: "NFL", 89: "MLB", 94: "ComedyGr", 96: "LaughUSA",
         99: "Raw Dog", 100: "Howard100", 101: "Howard101", 114: "FOX News", 116: "CNN", 124: "POTUS",
         134: "CHI T/W", 136: "DET T/W", 138: "NYC T/W"}


# Stock channel logos (sdars/channelart from the head unit's SiriusXM data, channelart.db): stored per SiriusXM
# service ID, which is not the channel number; SID of each lineup channel's logo, read off the art itself.
ART_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "sdars", "channelart")
LOGO_SID = {1: 1, 2: 13, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 30, 15: 26, 16: 155, 20: 18, 24: 91, 25: 49, 26: 46,
            27: 40, 32: 25, 34: 54, 36: 34, 37: 48, 39: 41, 40: 42, 44: 65, 45: 66, 46: 67, 48: 62, 51: 81, 52: 80,
            56: 16, 58: 17, 59: 10, 60: 12, 67: 70, 71: 73, 76: 110, 80: 140, 83: 142, 88: 55, 89: 175, 96: 151,
            99: 150, 100: 33, 101: 36, 114: 122, 116: 134, 124: 130, 134: 148, 136: 148, 138: 148}


def _logo_files():
    """{service id: native path of its logo} from channelart.db (image type 0 = logo, I<id>T00.png)."""
    try:
        db = sqlite3.connect(os.path.join(ART_DIR, "channelart.db"))
        rows = db.execute("select source, imageId from image_assoc where srcType=0 and imageType=0").fetchall()
        db.close()
    except sqlite3.Error:
        return {}
    files = {sid: os.path.join(ART_DIR, f"I{img:05d}T00.png") for sid, img in rows}
    return {sid: f for sid, f in files.items() if os.path.exists(f)}


LOGOS = _logo_files()


def logo_url(num):
    # SatHomeScreen loads logoLocation as given when it contains "channelart" and does not start with "/"
    f = LOGOS.get(LOGO_SID.get(num))
    return "file:///" + f.replace("\\", "/") if f else "channelart/none.png"


def _short(num):
    return SHORT.get(num, CH[num][1][:9])


def station(num, full=False):
    n, name, cat, _ = CH[num]
    artist, title = now_playing(num)
    favs = XM["favorites"]
    st = {"channelID": n, "sid": 1000 + n, "channelName": name, "shortName": _short(n), "catName": cat,
          "catNum": CATS[cat], "artist": artist, "program": title, "isSubscribed": True,
          "isSongFavorite": any(f["favoriteType"] == "song" and f["song"] == title for f in favs),
          "isArtistFavorite": any(f["favoriteType"] == "artist" and f["artist"] == artist for f in favs),
          "logoLocation": logo_url(n)}
    if full:
        st["info"] = ""
        st["presetNum"] = XM["presets"].index(n) if n in XM["presets"] else 255
    return st


def xm_set(module, key, value, conn=None):
    H.B.mod(module)[key] = value
    H.B.send(module, {key: value}, conn)


def publish_current():
    xm_set("XMApp", "currentStationInfo", station(XM["channel"], True))


def publish_lineup():
    xm_set("XMApp", "stationInfoList", [station(n) for n in NUMS])


def presets_payload():
    # PresetPersistencyManager.decodeLocalPresets: 65535 marks an empty slot.
    return [{"channelID": n or 65535, "text": _short(n) if n in CH else ""} for n in XM["presets"]]


def tune(num):
    if num not in CH or num == XM["channel"]:
        return publish_current()
    XM["previous"], XM["channel"] = XM["channel"], num
    IR.update(fill=0, behind=0, paused=False)
    publish_current()
    ir_publish()


def _step(up):
    order = [n for n in NUMS if n not in XM["skipped"] and n != 1]
    i = order.index(XM["channel"]) if XM["channel"] in order else 0
    return order[(i + (1 if up else -1)) % len(order)]


@on("XMApp", "channelSelect")
def xm_select(dest, args, conn):
    tune(int(args.get("station", XM["channel"])))


@on("XMApp", "tunePreviousChannel")
def xm_prev(dest, args, conn):
    tune(XM["previous"])


@on("XMApp", "seekUpPress")
def xm_seek_up(dest, args, conn):
    tune(_step(True))


@on("XMApp", "seekDownPress")
def xm_seek_down(dest, args, conn):
    tune(_step(False))


@on("XMApp", "presetRecall")
def xm_preset_recall(dest, args, conn):
    p = int(args.get("presetNum", -1))
    if 0 <= p < 12 and XM["presets"][p]:
        tune(XM["presets"][p])


def _preset_step(up):
    filled = [n for n in XM["presets"] if n in CH]
    if filled:
        i = filled.index(XM["channel"]) if XM["channel"] in filled else -1
        tune(filled[(i + (1 if up else -1)) % len(filled)])


@on("XMApp", "presetSeekUp")
def xm_preset_up(dest, args, conn):
    _preset_step(True)


@on("XMApp", "presetSeekDown")
def xm_preset_down(dest, args, conn):
    _preset_step(False)


@on("XMPresets", "presetStore")
def xm_preset_store(dest, args, conn):
    p, ch = int(args.get("presetNum", -1)), int(args.get("channelNum", 65535))
    if 0 <= p < 12:
        XM["presets"][p] = ch if ch in CH else 0
        xm_set("XMPresets", "localXMPresetList", presets_payload())
        publish_current()


def _channel_list(args):
    v = args.get("channelList", [])
    return [int(x) for x in (v if isinstance(v, list) else str(v).strip("[]").split(",") if str(v).strip("[]") else [])]


@on("XMApp", "skipChannel")
def xm_skip(dest, args, conn):
    XM["skipped"] = sorted(set(XM["skipped"]) | set(_channel_list(args)))
    xm_set("XMApp", "skippedChannelList", XM["skipped"])


@on("XMApp", "clearSkipChannel")
def xm_unskip(dest, args, conn):
    XM["skipped"] = [n for n in XM["skipped"] if n not in _channel_list(args)]
    xm_set("XMApp", "skippedChannelList", XM["skipped"])


@on("XMApp", "getFeaturedFavoritesList")
def xm_featured_list(dest, args, conn):
    H.B.emit("XMApp", "featuredFavoritesList", conn)


FEATURED = {1: [2, 8, 26, 56], 2: [80, 88, 89, 83]}


@on("XMApp", "getFeaturedFav")
def xm_featured(dest, args, conn):
    chans = FEATURED.get(int(args.get("bandID", 0)), [])
    H.B.send("XMApp", {"featureFavorite": {"list": [{"channelID": n, "name": CH[n][1]} for n in chans]}}, conn)


for _cmd in ("seekRelease", "scanUp", "scanDown", "scanCancel", "setCategoryFilter", "setTimeZoneOffset",
             "requestEnableICSTuning", "requestDisableICSTuning", "enableSmartFavs", "disableSmartFavs",
             "lockChannel", "clearLockChannel"):
    H._pending.append(("XMApp", _cmd, lambda dest, args, conn: None))  # accepted, nothing to report


# ---------------------------------------------------------------- favorites (XMFavorites)
def favorites_publish():
    xm_set("XMFavorites", "allFavorites", XM["favorites"])
    active = []
    for n in NUMS:
        artist, title = now_playing(n)
        for f in XM["favorites"]:
            if (f["favoriteType"] == "song" and f["song"] == title) or (f["favoriteType"] == "artist" and f["artist"] == artist):
                active.append({"channel": n, "artist": artist, "song": title,
                               "isActiveArtist": f["favoriteType"] == "artist", "isActiveSong": f["favoriteType"] == "song"})
                break
    xm_set("XMFavorites", "activeFavorites", active)
    publish_current()


def _add_favorite(kind, args):
    num = int(args.get("newFavorite", XM["channel"]))
    artist, title = now_playing(num if num in CH else XM["channel"])
    if not any(f["favoriteType"] == kind and f["song" if kind == "song" else "artist"] == (title if kind == "song" else artist)
               for f in XM["favorites"]):
        XM["fav_id"] += 1
        XM["favorites"].append({"id": XM["fav_id"], "favoriteType": kind, "artist": artist,
                                "song": title if kind == "song" else ""})
    favorites_publish()


@on("XMFavorites", "setFavoriteSong")
def fav_song(dest, args, conn):
    _add_favorite("song", args)


@on("XMFavorites", "setFavoriteArtist")
def fav_artist(dest, args, conn):
    _add_favorite("artist", args)


@on("XMFavorites", "removeFavorite")
def fav_remove(dest, args, conn):
    XM["favorites"] = [f for f in XM["favorites"] if f["id"] != int(args.get("id", -1))]
    favorites_publish()


@on("XMFavorites", "removeAllFavorites")
def fav_remove_all(dest, args, conn):
    XM["favorites"] = []
    favorites_publish()


for _cmd in ("enableGlobalSongArtistSeek", "enableArtist", "enableSong"):
    H._pending.append(("XMFavorites", _cmd, lambda dest, args, conn: None))


# ---------------------------------------------------------------- Traffic & Weather jump (XMTrafficJump)
MARKETS = [{"uniqueID": 1, "marketID": "CHI", "marketName": "Chicago", "channel": 134},
           {"uniqueID": 2, "marketID": "DET", "marketName": "Detroit", "channel": 136},
           {"uniqueID": 3, "marketID": "NYC", "marketName": "New York", "channel": 138}]


@on("XMTrafficJump", "selectTrafficMarket")
def tj_select(dest, args, conn):
    XM["market"] = int(args.get("marketID", 0))
    xm_set("XMTrafficJump", "selectedMarket", XM["market"])
    xm_set("XMTrafficJump", "jumpStatus", "JUMP_IDLE")


@on("XMTrafficJump", "clearTrafficMarkets")
def tj_clear(dest, args, conn):
    XM["market"] = 0
    xm_set("XMTrafficJump", "selectedMarket", 0)
    xm_set("XMTrafficJump", "jumpStatus", "JUMP_MARKET_NOT_SELECTED")


@on("XMTrafficJump", "trafficJumpPress")
def tj_press(dest, args, conn):
    m = next((m for m in MARKETS if m["uniqueID"] == XM["market"]), None)
    if not m:
        return H.B.send("XMTrafficJump", {"trafficJumpPress": {"CmdResponse": {"errCode": "eNoMarketSelected"}}}, conn)
    H.B.send("XMTrafficJump", {"trafficJumpPress": {"CmdResponse": {"errCode": "eSuccess"}}}, conn)
    if XM["jump_from"] is None:
        XM["jump_from"] = XM["channel"]
        xm_set("XMTrafficJump", "jumpStatus", "JUMP_IN_PROGRESS")
        tune(m["channel"])
    else:
        tj_cancel(dest, args, conn)


@on("XMTrafficJump", "cancelJump")
def tj_cancel(dest, args, conn):
    H.B.send("XMTrafficJump", {"cancelJump": {"CmdResponse": {"errCode": "eSuccess"}}}, conn)
    if XM["jump_from"] is not None:
        back, XM["jump_from"] = XM["jump_from"], None
        tune(back)
        xm_set("XMTrafficJump", "jumpStatus", "JUMP_COMPLETED")
    xm_set("XMTrafficJump", "jumpStatus", "JUMP_IDLE" if XM["market"] else "JUMP_MARKET_NOT_SELECTED")


# ---------------------------------------------------------------- Game Zone (XMGameZone)
LEAGUES = [{"abbrev": "MLB", "name": "Major League Baseball", "contentDescriptor": 1},
           {"abbrev": "NBA", "name": "National Basketball Association", "contentDescriptor": 2},
           {"abbrev": "NFL", "name": "National Football League", "contentDescriptor": 3},
           {"abbrev": "NHL", "name": "National Hockey League", "contentDescriptor": 4}]
TEAMS = {1: [("Detroit", "Tigers"), ("Chicago", "Cubs"), ("New York", "Yankees"), ("Kansas City", "Royals")],
         2: [("Detroit", "Pistons"), ("Chicago", "Bulls"), ("Golden State", "Warriors"), ("Cleveland", "Cavaliers")],
         3: [("Detroit", "Lions"), ("Chicago", "Bears"), ("Green Bay", "Packers"), ("New England", "Patriots")],
         4: [("Detroit", "Red Wings"), ("Chicago", "Blackhawks"), ("New York", "Rangers"), ("Boston", "Bruins")]}
GZ = {"favorites": []}  # (league, teamID, alertType)


def gz_favorites_payload():
    out = [{"leagueDescriptor": lg, "teamDescriptor": tid, "alertType": at, "teamName": TEAMS[lg][tid][0],
            "teamNick": TEAMS[lg][tid][1]} for lg, tid, at in GZ["favorites"]]
    return {"currentTeamFavorites": out}


@on("XMGameZone", "requestLeagueList")
def gz_leagues(dest, args, conn):
    H.B.send("XMGameZone", {"leagueList": LEAGUES}, conn)


@on("XMGameZone", "requestTeamList")
def gz_teams(dest, args, conn):
    lg = int(args.get("contentDescriptor", 1))
    favs = {(l, t): a for l, t, a in GZ["favorites"]}
    teams = [{"league": lg, "teamID": i, "teamName": c, "teamNick": n, "alertType": favs.get((lg, i), "NONE")}
             for i, (c, n) in enumerate(TEAMS.get(lg, []))]
    H.B.send("XMGameZone", {"teamList": teams}, conn)


GZ_CHANNEL = {1: 89, 2: 80, 3: 88, 4: 83}  # play-by-play channel per league


def gz_scores():
    # One live game per favorite team (opponent = next team in the league list).
    out = []
    for lg, tid, _ in GZ["favorites"]:
        home, away = TEAMS[lg][tid], TEAMS[lg][(tid + 1) % len(TEAMS[lg])]
        out.append({"channel": GZ_CHANNEL[lg], "teams": f"{away[1]} at {home[1]}",
                    "scores": f"{(tid * 3 + lg) % 6} - {(tid + 2 * lg) % 5}"})
    return out


def _gz_publish():
    xm_set("XMGameZone", "currentTeamFavorites", gz_favorites_payload())
    xm_set("XMGameZone", "activeScores", gz_scores())


@on("XMGameZone", "setFavoriteTeam")
def gz_add(dest, args, conn):
    key = (int(args["leagueDescriptor"]), int(args["teamDescriptor"]))
    if key[0] in TEAMS and key[1] < len(TEAMS[key[0]]) and key not in [(l, t) for l, t, _ in GZ["favorites"]]:
        GZ["favorites"].append(key + (args.get("alertType", "GAME_SCORE"),))
    _gz_publish()


@on("XMGameZone", "removeFavTeam")
def gz_remove(dest, args, conn):
    key = (int(args["leagueDescriptor"]), int(args["teamDescriptor"]))
    GZ["favorites"] = [f for f in GZ["favorites"] if f[:2] != key]
    _gz_publish()


@on("XMGameZone", "removeAllTeams")
def gz_remove_all(dest, args, conn):
    GZ["favorites"] = []
    _gz_publish()


@on("XMGameZone", "enableGlobalGameAlert")
def gz_game_alert(dest, args, conn):
    xm_set("XMGameZone", "globalGameAlertStatus", {"Status": args.get("Status") in (True, "true")})


@on("XMGameZone", "enableGlobalScoreAlert")
def gz_score_alert(dest, args, conn):
    xm_set("XMGameZone", "globalScoreAlertStatus", {"Status": args.get("Status") in (True, "true")})


# ---------------------------------------------------------------- Instant Replay (XMInstantReplay)
# Model: a 44-minute buffer of the tuned channel that fills while listening; "behind" = seconds behind live.
# playbackPct is 100 at live, the scroller's left limit is 100 - fillPct (SatHomeScreen).
BUFFER = 44 * 60
IR = {"fill": 0, "behind": 0, "paused": False, "ff": 0}


def ir_publish():
    fill_pct = min(100, IR["fill"] * 100 // BUFFER)
    play_pct = max(0, 100 - IR["behind"] * 100 // BUFFER)
    b = IR["behind"]
    xm_set("XMInstantReplay", "replayBufferStatus", {"fillPct": fill_pct, "playbackPct": play_pct,
                                                     "hours": b // 3600, "minutes": b // 60 % 60, "seconds": b % 60})
    xm_set("XMInstantReplay", "replayPlayStatus", {"pauseStatus": "PAUSE" if IR["paused"] else "PLAY",
                                                   "isLive": b == 0 and not IR["paused"], "fastForwardActive": IR["ff"] > 0,
                                                   "rewindActive": IR["ff"] < 0, "scanActive": False})


def _ir_move(delta):
    IR["behind"] = max(0, min(IR["fill"], IR["behind"] - delta))
    ir_publish()


for _cmd, _fn in {
    "live": lambda a: IR.update(behind=0, paused=False, ff=0),
    "pausePlayRelease": lambda a: IR.update(paused=not IR["paused"]),
    "seekPrevious": lambda a: IR.update(behind=min(IR["fill"], IR["behind"] + 30)),
    "seekForward": lambda a: IR.update(behind=max(0, IR["behind"] - 30)),
    "rewindPress": lambda a: IR.update(ff=-1),
    "fastForwardPress": lambda a: IR.update(ff=1),
    "rewindRelease": lambda a: IR.update(ff=0),
    "fastForwardRelease": lambda a: IR.update(ff=0),
    "seekToPosition": lambda a: IR.update(behind=min(IR["fill"], max(0, (100 - int(a.get("percent", 100))) * BUFFER // 100))),
}.items():
    H._pending.append(("XMInstantReplay", _cmd, (lambda f: lambda d, a, c: (f(a), ir_publish()))(_fn)))
for _cmd in ("pausePlayPress", "scanPressed", "setIRMode", "requestPlaylist", "playFromPlaylist"):
    H._pending.append(("XMInstantReplay", _cmd, lambda dest, args, conn: None))


# ---------------------------------------------------------------- periodic: song changes, replay buffer
def _sxm_ticker():
    last_songs = {}
    last_lineup = 0
    while True:
        time.sleep(1)
        try:
            songs = {n: now_playing(n) for n in NUMS}
            changed = songs != last_songs
            if changed and songs.get(XM["channel"]) != last_songs.get(XM["channel"]) and last_songs:
                publish_current()
            # Browse lists read the cached lineup; refresh it at most once a minute.
            if changed and time.time() - last_lineup > 60 and last_songs:
                last_lineup = time.time()
                publish_lineup()
                if XM["favorites"]:
                    favorites_publish()
            last_songs = songs
            if H.B.mod("Audio").get("audioSource", {}).get("source") == "sat":
                IR["fill"] = min(BUFFER, IR["fill"] + 1)
                if IR["paused"]:
                    IR["behind"] = min(IR["fill"], IR["behind"] + 1)
                elif IR["ff"]:
                    _ir_move(IR["ff"] * 10)
                    continue
                elif IR["behind"] == 0 and IR["fill"] % 5:
                    continue  # live: only refresh the fill bar every 5 s
                ir_publish()
        except Exception as e:  # a bad tick must not kill the thread
            H.B.log("!!", f"sxm ticker {e!r}")


def init(B):
    # state.json has destination "1"; the HMI's own constants say USA is "2" (SatelliteRadio, TravelLink).
    B.prop_store("VehicleConfig")["destination"] = "2"
    x = B.mod("XMApp")
    x.update({
        "appStatus": {"appStatus": "READY"},
        "advisoryMsg": {"advisoryMsg": "NO ERROR"},
        "signalStrength": {"signalStrength": 3},
        "ESN": {"ESN": ESN},
        "xmAppVersion": "SXV300 07.01.15",
        "audioSubscriptionStatus": {"subStatus": 1},
        "dataServicesSubscriptionStatus": {s: 1 for s in (
            "channelArtSubStatus", "fuelSubStatus", "graphicalWeatherSubStatus", "landWeatherSubStatus",
            "moviesSubStatus", "securityAlertsSubStatus", "sportsSubStatus", "trafficSubStatus")},
        "dataServicesState": [{"service": s, "state": "READY"} for s in ("fuel", "movies", "sports", "weather")],
        "availableChannelList": NUMS,
        "skippedChannelList": [],
        "lockedChannelList": [],
        "smartFavoritesStatus": {"smartFavoritesStatus": 1},
        "featuredFavoritesList": {"list": [
            {"bandID": 1, "name": "SXM Picks", "longName": "SiriusXM Picks", "verboseName": "SiriusXM Picks",
             "description": "Channels picked for you"},
            {"bandID": 2, "name": "Sports", "longName": "Sports Talk", "verboseName": "Sports Talk & Play-by-Play",
             "description": "Live sports talk"}]},
        "stationInfoList": [station(n) for n in NUMS],
        "currentStationInfo": station(XM["channel"], True),
    })
    B.mod("XMPresets")["localXMPresetList"] = presets_payload()
    B.mod("XMFavorites").update({"allFavorites": [], "activeFavorites": [],
                                 "favAllowed": {"isArtistAllowed": True, "isSongAllowed": True}})
    B.mod("XMGameZone").update({"globalGameAlertStatus": {"Status": True}, "globalScoreAlertStatus": {"Status": True},
                                "currentTeamFavorites": gz_favorites_payload(), "leagueList": LEAGUES,
                                "activeScores": []})
    B.mod("XMTrafficJump").update({"trafficList": MARKETS, "jumpStatus": "JUMP_MARKET_NOT_SELECTED", "selectedMarket": 0})
    B.mod("XMInstantReplay").update({"replayBufferStatus": {"fillPct": 0, "playbackPct": 100, "hours": 0, "minutes": 0, "seconds": 0},
                                     "replayPlayStatus": {"pauseStatus": "PLAY", "isLive": True, "fastForwardActive": False,
                                                          "rewindActive": False, "scanActive": False},
                                     "numPlaylistItems": 0, "currentOffset": 0})
    threading.Thread(target=_sxm_ticker, daemon=True).start()
