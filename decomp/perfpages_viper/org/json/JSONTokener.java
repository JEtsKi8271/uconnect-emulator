/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JSONTokener {
    private int myIndex = 0;
    private String mySource;

    public JSONTokener(String s2) {
        this.mySource = s2;
    }

    public void back() {
        if (this.myIndex > 0) {
            --this.myIndex;
        }
    }

    public static int dehexchar(char c2) {
        if (c2 >= '0' && c2 <= '9') {
            return c2 - 48;
        }
        if (c2 >= 'A' && c2 <= 'F') {
            return c2 - 55;
        }
        if (c2 >= 'a' && c2 <= 'f') {
            return c2 - 87;
        }
        return -1;
    }

    public boolean more() {
        return this.myIndex < this.mySource.length();
    }

    public char next() {
        if (this.more()) {
            char c2 = this.mySource.charAt(this.myIndex);
            ++this.myIndex;
            return c2;
        }
        return '\u0000';
    }

    public char next(char c2) throws JSONException {
        char n2 = this.next();
        if (n2 != c2) {
            throw this.syntaxError("Expected '" + c2 + "' and instead saw '" + n2 + "'.");
        }
        return n2;
    }

    public String next(int n2) throws JSONException {
        int i2 = this.myIndex;
        int j2 = i2 + n2;
        if (j2 >= this.mySource.length()) {
            throw this.syntaxError("Substring bounds error");
        }
        this.myIndex += n2;
        return this.mySource.substring(i2, j2);
    }

    public char nextClean() throws JSONException {
        char c2;
        block4: while (true) {
            if ((c2 = this.next()) == '/') {
                switch (this.next()) {
                    case '/': {
                        while ((c2 = this.next()) != '\n' && c2 != '\r' && c2 != '\u0000') {
                        }
                        continue block4;
                    }
                    case '*': {
                        while (true) {
                            if ((c2 = this.next()) == '\u0000') {
                                throw this.syntaxError("Unclosed comment.");
                            }
                            if (c2 != '*') continue;
                            if (this.next() == '/') continue block4;
                            this.back();
                        }
                    }
                }
                this.back();
                return '/';
            }
            if (c2 == '#') {
                while ((c2 = this.next()) != '\n' && c2 != '\r' && c2 != '\u0000') {
                }
                continue;
            }
            if (c2 == '\u0000' || c2 > ' ') break;
        }
        return c2;
    }

    public String nextString(char quote) throws JSONException {
        StringBuffer sb = new StringBuffer();
        block13: while (true) {
            char c2 = this.next();
            switch (c2) {
                case '\u0000': 
                case '\n': 
                case '\r': {
                    throw this.syntaxError("Unterminated string");
                }
                case '\\': {
                    c2 = this.next();
                    switch (c2) {
                        case 'b': {
                            sb.append('\b');
                            continue block13;
                        }
                        case 't': {
                            sb.append('\t');
                            continue block13;
                        }
                        case 'n': {
                            sb.append('\n');
                            continue block13;
                        }
                        case 'f': {
                            sb.append('\f');
                            continue block13;
                        }
                        case 'r': {
                            sb.append('\r');
                            continue block13;
                        }
                        case 'u': {
                            sb.append((char)Integer.parseInt(this.next(4), 16));
                            continue block13;
                        }
                        case 'x': {
                            sb.append((char)Integer.parseInt(this.next(2), 16));
                            continue block13;
                        }
                    }
                    sb.append(c2);
                    continue block13;
                }
            }
            if (c2 == quote) {
                return sb.toString();
            }
            sb.append(c2);
        }
    }

    public String nextTo(char d2) {
        StringBuffer sb = new StringBuffer();
        while (true) {
            char c2;
            if ((c2 = this.next()) == d2 || c2 == '\u0000' || c2 == '\n' || c2 == '\r') {
                if (c2 != '\u0000') {
                    this.back();
                }
                return sb.toString().trim();
            }
            sb.append(c2);
        }
    }

    public String nextTo(String delimiters) {
        StringBuffer sb = new StringBuffer();
        while (true) {
            char c2;
            if (delimiters.indexOf(c2 = this.next()) >= 0 || c2 == '\u0000' || c2 == '\n' || c2 == '\r') {
                if (c2 != '\u0000') {
                    this.back();
                }
                return sb.toString().trim();
            }
            sb.append(c2);
        }
    }

    public Object nextValue() throws JSONException {
        char c2 = this.nextClean();
        switch (c2) {
            case '\"': 
            case '\'': {
                return this.nextString(c2);
            }
            case '{': {
                this.back();
                return new JSONObject(this);
            }
            case '[': {
                this.back();
                return new JSONArray(this);
            }
        }
        StringBuffer sb = new StringBuffer();
        char b2 = c2;
        while (c2 >= ' ' && ",:]}/\\\"[{;=#".indexOf(c2) < 0) {
            sb.append(c2);
            c2 = this.next();
        }
        this.back();
        String s2 = sb.toString().trim();
        if (s2.equals("")) {
            throw this.syntaxError("Missing value.");
        }
        if (s2.toLowerCase().equals("true")) {
            return JSONObject.TRUE;
        }
        if (s2.toLowerCase().equals("false")) {
            return JSONObject.FALSE;
        }
        if (s2.toLowerCase().equals("null")) {
            return JSONObject.NULL;
        }
        if (b2 >= '0' && b2 <= '9' || b2 == '.' || b2 == '-' || b2 == '+') {
            if (b2 == '0') {
                if (s2.length() > 2 && (s2.charAt(1) == 'x' || s2.charAt(1) == 'X')) {
                    try {
                        return new Integer(Integer.parseInt(s2.substring(2), 16));
                    }
                    catch (Exception exception) {
                    }
                } else {
                    try {
                        return new Integer(Integer.parseInt(s2, 8));
                    }
                    catch (Exception exception) {
                        // empty catch block
                    }
                }
            }
            try {
                return Integer.valueOf(s2);
            }
            catch (Exception e2) {
                try {
                    return new Long(Long.parseLong(s2));
                }
                catch (Exception f2) {
                    return s2;
                }
            }
        }
        return s2;
    }

    public char skipTo(char to) {
        char c2;
        int index = this.myIndex;
        do {
            if ((c2 = this.next()) != '\u0000') continue;
            this.myIndex = index;
            return c2;
        } while (c2 != to);
        this.back();
        return c2;
    }

    public void skipPast(String to) {
        this.myIndex = this.mySource.indexOf(to, this.myIndex);
        this.myIndex = this.myIndex < 0 ? this.mySource.length() : (this.myIndex += to.length());
    }

    public JSONException syntaxError(String message) {
        return new JSONException(String.valueOf(message) + this.toString());
    }

    public String toString() {
        return " at character " + this.myIndex + " of " + this.mySource;
    }
}

