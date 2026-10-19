/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import java.io.IOException;
import java.io.Writer;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONString;
import org.json.JSONTokener;

public class JSONObject {
    public static final Boolean TRUE = new Boolean(true);
    public static final Boolean FALSE = new Boolean(false);
    private Hashtable myHashMap = new Hashtable();
    public static final Object NULL = new Null();

    public JSONObject() {
    }

    public JSONObject(JSONTokener x2) throws JSONException {
        this();
        if (x2.nextClean() != '{') {
            throw x2.syntaxError("A JSONObject text must begin with '{'");
        }
        block8: while (true) {
            char c2 = x2.nextClean();
            switch (c2) {
                case '\u0000': {
                    throw x2.syntaxError("A JSONObject text must end with '}'");
                }
                case '}': {
                    return;
                }
            }
            x2.back();
            String key = x2.nextValue().toString();
            c2 = x2.nextClean();
            if (c2 == '=') {
                if (x2.next() != '>') {
                    x2.back();
                }
            } else if (c2 != ':') {
                throw x2.syntaxError("Expected a ':' after a key");
            }
            this.put(key, x2.nextValue());
            switch (x2.nextClean()) {
                case ',': 
                case ';': {
                    if (x2.nextClean() == '}') {
                        return;
                    }
                    x2.back();
                    continue block8;
                }
                case '}': {
                    return;
                }
            }
            break;
        }
        throw x2.syntaxError("Expected a ',' or '}'");
    }

    public JSONObject(String string) throws JSONException {
        this(new JSONTokener(string));
    }

    public JSONObject accumulate(String key, Object value) throws JSONException {
        JSONObject.testValidity(value);
        Object o2 = this.opt(key);
        if (o2 == null) {
            this.put(key, value);
        } else if (o2 instanceof JSONArray) {
            ((JSONArray)o2).put(value);
        } else {
            this.put(key, new JSONArray().put(o2).put(value));
        }
        return this;
    }

    public Object get(String key) throws JSONException {
        Object o2 = this.opt(key);
        if (o2 == null) {
            throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] not found.");
        }
        return o2;
    }

    public boolean getBoolean(String key) throws JSONException {
        Object o2 = this.get(key);
        if (o2.equals(FALSE) || o2 instanceof String && ((String)o2).toLowerCase().equals("false")) {
            return false;
        }
        if (o2.equals(TRUE) || o2 instanceof String && ((String)o2).toLowerCase().equals("true")) {
            return true;
        }
        throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] is not a Boolean.");
    }

    public int getInt(String key) throws JSONException {
        Object o2 = this.get(key);
        if (o2 instanceof Byte) {
            return ((Byte)o2).byteValue();
        }
        if (o2 instanceof Short) {
            return ((Short)o2).shortValue();
        }
        if (o2 instanceof Integer) {
            return (Integer)o2;
        }
        if (o2 instanceof Long) {
            return (int)((Long)o2).longValue();
        }
        throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] is not a number.");
    }

    public JSONArray getJSONArray(String key) throws JSONException {
        Object o2 = this.get(key);
        if (o2 instanceof JSONArray) {
            return (JSONArray)o2;
        }
        throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] is not a JSONArray.");
    }

    public JSONObject getJSONObject(String key) throws JSONException {
        Object o2 = this.get(key);
        if (o2 instanceof JSONObject) {
            return (JSONObject)o2;
        }
        throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] is not a JSONObject.");
    }

    public long getLong(String key) throws JSONException {
        Object o2 = this.get(key);
        if (o2 instanceof Byte) {
            return ((Byte)o2).byteValue();
        }
        if (o2 instanceof Short) {
            return ((Short)o2).shortValue();
        }
        if (o2 instanceof Integer) {
            return ((Integer)o2).intValue();
        }
        if (o2 instanceof Long) {
            return (Long)o2;
        }
        throw new JSONException("JSONObject[" + JSONObject.quote(key) + "] is not a number.");
    }

    public String getString(String key) throws JSONException {
        return this.get(key).toString();
    }

    public boolean has(String key) {
        return this.myHashMap.containsKey(key);
    }

    public boolean isNull(String key) {
        return NULL.equals(this.opt(key));
    }

    public Enumeration keys() {
        return this.myHashMap.keys();
    }

    public int length() {
        return this.myHashMap.size();
    }

    public JSONArray names() {
        JSONArray ja = new JSONArray();
        Enumeration keys = this.keys();
        while (keys.hasMoreElements()) {
            ja.put(keys.nextElement());
        }
        return ja.length() == 0 ? null : ja;
    }

    public static String trimNumber(String s2) {
        if (s2.indexOf(46) > 0 && s2.indexOf(101) < 0 && s2.indexOf(69) < 0) {
            while (s2.endsWith("0")) {
                s2 = s2.substring(0, s2.length() - 1);
            }
            if (s2.endsWith(".")) {
                s2 = s2.substring(0, s2.length() - 1);
            }
        }
        return s2;
    }

    public static String numberToString(Object n2) throws JSONException {
        if (n2 == null) {
            throw new JSONException("Null pointer");
        }
        JSONObject.testValidity(n2);
        return JSONObject.trimNumber(n2.toString());
    }

    public Object opt(String key) {
        return key == null ? null : this.myHashMap.get(key);
    }

    public boolean optBoolean(String key) {
        return this.optBoolean(key, false);
    }

    public boolean optBoolean(String key, boolean defaultValue) {
        try {
            return this.getBoolean(key);
        }
        catch (Exception e2) {
            return defaultValue;
        }
    }

    public JSONObject put(String key, Vector value) throws JSONException {
        this.put(key, new JSONArray(value));
        return this;
    }

    public int optInt(String key) {
        return this.optInt(key, 0);
    }

    public int optInt(String key, int defaultValue) {
        try {
            return this.getInt(key);
        }
        catch (Exception e2) {
            return defaultValue;
        }
    }

    public JSONArray optJSONArray(String key) {
        Object o2 = this.opt(key);
        return o2 instanceof JSONArray ? (JSONArray)o2 : null;
    }

    public JSONObject optJSONObject(String key) {
        Object o2 = this.opt(key);
        return o2 instanceof JSONObject ? (JSONObject)o2 : null;
    }

    public long optLong(String key) {
        return this.optLong(key, 0L);
    }

    public long optLong(String key, long defaultValue) {
        try {
            return this.getLong(key);
        }
        catch (Exception e2) {
            return defaultValue;
        }
    }

    public String optString(String key) {
        return this.optString(key, "");
    }

    public String optString(String key, String defaultValue) {
        Object o2 = this.opt(key);
        return o2 != null ? o2.toString() : defaultValue;
    }

    public JSONObject put(String key, boolean value) throws JSONException {
        this.put(key, value ? TRUE : FALSE);
        return this;
    }

    public JSONObject put(String key, int value) throws JSONException {
        this.put(key, new Integer(value));
        return this;
    }

    public JSONObject put(String key, long value) throws JSONException {
        this.put(key, new Long(value));
        return this;
    }

    public JSONObject put(String key, Object value) throws JSONException {
        if (key == null) {
            throw new JSONException("Null key.");
        }
        if (value != null) {
            JSONObject.testValidity(value);
            this.myHashMap.put(key, value);
        } else {
            this.remove(key);
        }
        return this;
    }

    public JSONObject putOpt(String key, Object value) throws JSONException {
        if (key != null && value != null) {
            this.put(key, value);
        }
        return this;
    }

    public static String quote(String string) {
        if (string == null || string.length() == 0) {
            return "\"\"";
        }
        char c2 = '\u0000';
        int len = string.length();
        StringBuffer sb = new StringBuffer(len + 4);
        sb.append('\"');
        int i2 = 0;
        while (i2 < len) {
            char b2 = c2;
            c2 = string.charAt(i2);
            switch (c2) {
                case '\"': 
                case '\\': {
                    sb.append('\\');
                    sb.append(c2);
                    break;
                }
                case '/': {
                    if (b2 == '<') {
                        sb.append('\\');
                    }
                    sb.append(c2);
                    break;
                }
                case '\b': {
                    sb.append("\\b");
                    break;
                }
                case '\t': {
                    sb.append("\\t");
                    break;
                }
                case '\n': {
                    sb.append("\\n");
                    break;
                }
                case '\f': {
                    sb.append("\\f");
                    break;
                }
                case '\r': {
                    sb.append("\\r");
                    break;
                }
                default: {
                    if (c2 < ' ') {
                        String t2 = "000" + Integer.toHexString(c2);
                        sb.append("\\u" + t2.substring(t2.length() - 4));
                        break;
                    }
                    sb.append(c2);
                }
            }
            ++i2;
        }
        sb.append('\"');
        return sb.toString();
    }

    public Object remove(String key) {
        return this.myHashMap.remove(key);
    }

    static void testValidity(Object o2) throws JSONException {
    }

    public JSONArray toJSONArray(JSONArray names) throws JSONException {
        if (names == null || names.length() == 0) {
            return null;
        }
        JSONArray ja = new JSONArray();
        int i2 = 0;
        while (i2 < names.length()) {
            ja.put(this.opt(names.getString(i2)));
            ++i2;
        }
        return ja;
    }

    public String toString() {
        try {
            Enumeration keys = this.keys();
            StringBuffer sb = new StringBuffer("{");
            while (keys.hasMoreElements()) {
                if (sb.length() > 1) {
                    sb.append(',');
                }
                Object o2 = keys.nextElement();
                sb.append(JSONObject.quote(o2.toString()));
                sb.append(':');
                sb.append(JSONObject.valueToString(this.myHashMap.get(o2)));
            }
            sb.append('}');
            return sb.toString();
        }
        catch (Exception e2) {
            return null;
        }
    }

    public String toString(int indentFactor) throws JSONException {
        return this.toString(indentFactor, 0);
    }

    /*
     * Unable to fully structure code
     */
    String toString(int indentFactor, int indent) throws JSONException {
        block7: {
            n = this.length();
            if (n == 0) {
                return "{}";
            }
            keys = this.keys();
            sb = new StringBuffer("{");
            newindent = indent + indentFactor;
            if (n != 1) ** GOTO lbl35
            o = keys.nextElement();
            sb.append(JSONObject.quote(o.toString()));
            sb.append(": ");
            sb.append(JSONObject.valueToString(this.myHashMap.get(o), indentFactor, indent));
            break block7;
lbl-1000:
            // 1 sources

            {
                o = keys.nextElement();
                if (sb.length() > 1) {
                    sb.append(",\n");
                } else {
                    sb.append('\n');
                }
                i = 0;
                while (i < newindent) {
                    sb.append(' ');
                    ++i;
                }
                sb.append(JSONObject.quote(o.toString()));
                sb.append(": ");
                sb.append(JSONObject.valueToString(this.myHashMap.get(o), indentFactor, newindent));
lbl35:
                // 2 sources

                ** while (keys.hasMoreElements())
            }
lbl36:
            // 1 sources

            if (sb.length() > 1) {
                sb.append('\n');
                i = 0;
                while (i < indent) {
                    sb.append(' ');
                    ++i;
                }
            }
        }
        sb.append('}');
        return sb.toString();
    }

    static String valueToString(Object value) throws JSONException {
        if (value == null || value.equals(null)) {
            return "null";
        }
        if (value instanceof JSONString) {
            String o2;
            try {
                o2 = ((JSONString)value).toJSONString();
            }
            catch (Exception e2) {
                throw new JSONException(e2);
            }
            if (o2 instanceof String) {
                return o2;
            }
            throw new JSONException("Bad value from toJSONString: " + o2);
        }
        if (value instanceof Byte || value instanceof Short || value instanceof Integer || value instanceof Long) {
            return JSONObject.numberToString(value);
        }
        if (value instanceof Boolean || value instanceof JSONObject || value instanceof JSONArray) {
            return value.toString();
        }
        return JSONObject.quote(value.toString());
    }

    static String valueToString(Object value, int indentFactor, int indent) throws JSONException {
        if (value == null || value.equals(null)) {
            return "null";
        }
        try {
            String o2;
            if (value instanceof JSONString && (o2 = ((JSONString)value).toJSONString()) instanceof String) {
                return o2;
            }
        }
        catch (Exception exception) {
            // empty catch block
        }
        if (value instanceof Byte || value instanceof Short || value instanceof Integer || value instanceof Long) {
            return JSONObject.numberToString(value);
        }
        if (value instanceof Boolean) {
            return value.toString();
        }
        if (value instanceof JSONObject) {
            return ((JSONObject)value).toString(indentFactor, indent);
        }
        if (value instanceof JSONArray) {
            return ((JSONArray)value).toString(indentFactor, indent);
        }
        return JSONObject.quote(value.toString());
    }

    public Writer write(Writer writer) throws JSONException {
        try {
            boolean b2 = false;
            Enumeration keys = this.keys();
            writer.write(123);
            while (keys.hasMoreElements()) {
                if (b2) {
                    writer.write(44);
                }
                Object k2 = keys.nextElement();
                writer.write(JSONObject.quote(k2.toString()));
                writer.write(58);
                Object v2 = this.myHashMap.get(k2);
                if (v2 instanceof JSONObject) {
                    ((JSONObject)v2).write(writer);
                } else if (v2 instanceof JSONArray) {
                    ((JSONArray)v2).write(writer);
                } else {
                    writer.write(JSONObject.valueToString(v2));
                }
                b2 = true;
            }
            writer.write(125);
            return writer;
        }
        catch (IOException e2) {
            throw new JSONException(e2);
        }
    }

    private static final class Null {
        private Null() {
        }

        public boolean equals(Object object) {
            return object == null || object == this;
        }

        public String toString() {
            return "null";
        }
    }
}

