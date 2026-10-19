/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import java.io.IOException;
import java.io.Writer;
import org.json.JSONException;
import org.json.JSONObject;

public class JSONWriter {
    private static final int maxdepth = 20;
    private boolean comma = false;
    protected char mode = (char)105;
    private char[] stack = new char[20];
    private int top = 0;
    protected Writer writer;

    public JSONWriter(Writer w2) {
        this.writer = w2;
    }

    private JSONWriter append(String s2) throws JSONException {
        if (s2 == null) {
            throw new JSONException("Null pointer");
        }
        if (this.mode == 'o' || this.mode == 'a') {
            try {
                if (this.comma && this.mode == 'a') {
                    this.writer.write(44);
                }
                this.writer.write(s2);
            }
            catch (IOException e2) {
                throw new JSONException(e2);
            }
            if (this.mode == 'o') {
                this.mode = (char)107;
            }
            this.comma = true;
            return this;
        }
        throw new JSONException("Value out of sequence.");
    }

    public JSONWriter array() throws JSONException {
        if (this.mode == 'i' || this.mode == 'o' || this.mode == 'a') {
            this.push('a');
            this.append("[");
            this.comma = false;
            return this;
        }
        throw new JSONException("Misplaced array.");
    }

    private JSONWriter end(char m2, char c2) throws JSONException {
        if (this.mode != m2) {
            throw new JSONException(m2 == 'o' ? "Misplaced endObject." : "Misplaced endArray.");
        }
        this.pop(m2);
        try {
            this.writer.write(c2);
        }
        catch (IOException e2) {
            throw new JSONException(e2);
        }
        this.comma = true;
        return this;
    }

    public JSONWriter endArray() throws JSONException {
        return this.end('a', ']');
    }

    public JSONWriter endObject() throws JSONException {
        return this.end('k', '}');
    }

    public JSONWriter key(String s2) throws JSONException {
        if (s2 == null) {
            throw new JSONException("Null key.");
        }
        if (this.mode == 'k') {
            try {
                if (this.comma) {
                    this.writer.write(44);
                }
                this.writer.write(JSONObject.quote(s2));
                this.writer.write(58);
                this.comma = false;
                this.mode = (char)111;
                return this;
            }
            catch (IOException e2) {
                throw new JSONException(e2);
            }
        }
        throw new JSONException("Misplaced key.");
    }

    public JSONWriter object() throws JSONException {
        if (this.mode == 'i') {
            this.mode = (char)111;
        }
        if (this.mode == 'o' || this.mode == 'a') {
            this.append("{");
            this.push('k');
            this.comma = false;
            return this;
        }
        throw new JSONException("Misplaced object.");
    }

    private void pop(char c2) throws JSONException {
        if (this.top <= 0 || this.stack[this.top - 1] != c2) {
            throw new JSONException("Nesting error.");
        }
        --this.top;
        this.mode = (char)(this.top == 0 ? 100 : this.stack[this.top - 1]);
    }

    private void push(char c2) throws JSONException {
        if (this.top >= 20) {
            throw new JSONException("Nesting too deep.");
        }
        this.stack[this.top] = c2;
        this.mode = c2;
        ++this.top;
    }

    public JSONWriter value(boolean b2) throws JSONException {
        return this.append(b2 ? "true" : "false");
    }

    public JSONWriter value(long l2) throws JSONException {
        return this.append(Long.toString(l2));
    }

    public JSONWriter value(Object o2) throws JSONException {
        return this.append(JSONObject.valueToString(o2));
    }
}

