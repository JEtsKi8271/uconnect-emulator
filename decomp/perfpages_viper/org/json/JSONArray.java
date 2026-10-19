/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import java.io.IOException;
import java.io.Writer;
import java.util.Vector;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class JSONArray {
    private Vector myArrayList;

    public JSONArray() {
        this.myArrayList = new Vector();
    }

    public JSONArray(JSONTokener x2) throws JSONException {
        this();
        if (x2.nextClean() != '[') {
            throw x2.syntaxError("A JSONArray text must start with '['");
        }
        if (x2.nextClean() == ']') {
            return;
        }
        x2.back();
        block4: while (true) {
            if (x2.nextClean() == ',') {
                x2.back();
                this.myArrayList.addElement(null);
            } else {
                x2.back();
                this.myArrayList.addElement(x2.nextValue());
            }
            switch (x2.nextClean()) {
                case ',': 
                case ';': {
                    if (x2.nextClean() == ']') {
                        return;
                    }
                    x2.back();
                    continue block4;
                }
                case ']': {
                    return;
                }
            }
            break;
        }
        throw x2.syntaxError("Expected a ',' or ']'");
    }

    public JSONArray(String string) throws JSONException {
        this(new JSONTokener(string));
    }

    public JSONArray(Vector collection) {
        if (collection == null) {
            this.myArrayList = new Vector();
        } else {
            int size = collection.size();
            this.myArrayList = new Vector(size);
            int i2 = 0;
            while (i2 < size) {
                this.myArrayList.addElement(collection.elementAt(i2));
                ++i2;
            }
        }
    }

    public Object get(int index) throws JSONException {
        Object o2 = this.opt(index);
        if (o2 == null) {
            throw new JSONException("JSONArray[" + index + "] not found.");
        }
        return o2;
    }

    public boolean getBoolean(int index) throws JSONException {
        Object o2 = this.get(index);
        if (o2.equals(JSONObject.FALSE) || o2 instanceof String && ((String)o2).toLowerCase().equals("false")) {
            return false;
        }
        if (o2.equals(JSONObject.TRUE) || o2 instanceof String && ((String)o2).toLowerCase().equals("true")) {
            return true;
        }
        throw new JSONException("JSONArray[" + index + "] is not a Boolean.");
    }

    public JSONArray getJSONArray(int index) throws JSONException {
        Object o2 = this.get(index);
        if (o2 instanceof JSONArray) {
            return (JSONArray)o2;
        }
        throw new JSONException("JSONArray[" + index + "] is not a JSONArray.");
    }

    public JSONObject getJSONObject(int index) throws JSONException {
        Object o2 = this.get(index);
        if (o2 instanceof JSONObject) {
            return (JSONObject)o2;
        }
        throw new JSONException("JSONArray[" + index + "] is not a JSONObject.");
    }

    public String getString(int index) throws JSONException {
        return this.get(index).toString();
    }

    public boolean isNull(int index) {
        return JSONObject.NULL.equals(this.opt(index));
    }

    public String join(String separator) throws JSONException {
        int len = this.length();
        StringBuffer sb = new StringBuffer();
        int i2 = 0;
        while (i2 < len) {
            if (i2 > 0) {
                sb.append(separator);
            }
            sb.append(JSONObject.valueToString(this.myArrayList.elementAt(i2)));
            ++i2;
        }
        return sb.toString();
    }

    public int length() {
        return this.myArrayList.size();
    }

    public Object opt(int index) {
        return index < 0 || index >= this.length() ? null : this.myArrayList.elementAt(index);
    }

    public boolean optBoolean(int index) {
        return this.optBoolean(index, false);
    }

    public boolean optBoolean(int index, boolean defaultValue) {
        try {
            return this.getBoolean(index);
        }
        catch (Exception e2) {
            return defaultValue;
        }
    }

    public JSONArray optJSONArray(int index) {
        Object o2 = this.opt(index);
        return o2 instanceof JSONArray ? (JSONArray)o2 : null;
    }

    public JSONObject optJSONObject(int index) {
        Object o2 = this.opt(index);
        return o2 instanceof JSONObject ? (JSONObject)o2 : null;
    }

    public String optString(int index) {
        return this.optString(index, "");
    }

    public String optString(int index, String defaultValue) {
        Object o2 = this.opt(index);
        return o2 != null ? o2.toString() : defaultValue;
    }

    public JSONArray put(boolean value) {
        this.put(value ? JSONObject.TRUE : JSONObject.FALSE);
        return this;
    }

    public JSONArray put(Vector value) {
        this.put(new JSONArray(value));
        return this;
    }

    public JSONArray put(int value) {
        this.put(new Integer(value));
        return this;
    }

    public JSONArray put(long value) {
        this.put(new Long(value));
        return this;
    }

    public JSONArray put(Object value) {
        this.myArrayList.addElement(value);
        return this;
    }

    public JSONArray put(int index, boolean value) throws JSONException {
        this.put(index, value ? JSONObject.TRUE : JSONObject.FALSE);
        return this;
    }

    public JSONArray put(int index, Vector value) throws JSONException {
        this.put(index, new JSONArray(value));
        return this;
    }

    public JSONArray put(int index, int value) throws JSONException {
        this.put(index, new Integer(value));
        return this;
    }

    public JSONArray put(int index, long value) throws JSONException {
        this.put(index, new Long(value));
        return this;
    }

    /*
     * Unable to fully structure code
     */
    public JSONArray put(int index, Object value) throws JSONException {
        block2: {
            JSONObject.testValidity(value);
            if (index < 0) {
                throw new JSONException("JSONArray[" + index + "] not found.");
            }
            if (index >= this.length()) ** GOTO lbl9
            this.myArrayList.setElementAt(value, index);
            break block2;
lbl-1000:
            // 1 sources

            {
                this.put(JSONObject.NULL);
lbl9:
                // 2 sources

                ** while (index != this.length())
            }
lbl10:
            // 1 sources

            this.put(value);
        }
        return this;
    }

    public JSONObject toJSONObject(JSONArray names) throws JSONException {
        if (names == null || names.length() == 0 || this.length() == 0) {
            return null;
        }
        JSONObject jo = new JSONObject();
        int i2 = 0;
        while (i2 < names.length()) {
            jo.put(names.getString(i2), this.opt(i2));
            ++i2;
        }
        return jo;
    }

    public String toString() {
        try {
            return String.valueOf('[') + this.join(",") + ']';
        }
        catch (Exception e2) {
            return null;
        }
    }

    public String toString(int indentFactor) throws JSONException {
        return this.toString(indentFactor, 0);
    }

    String toString(int indentFactor, int indent) throws JSONException {
        int len = this.length();
        if (len == 0) {
            return "[]";
        }
        StringBuffer sb = new StringBuffer("[");
        if (len == 1) {
            sb.append(JSONObject.valueToString(this.myArrayList.elementAt(0), indentFactor, indent));
        } else {
            int newindent = indent + indentFactor;
            sb.append('\n');
            int i2 = 0;
            while (i2 < len) {
                if (i2 > 0) {
                    sb.append(",\n");
                }
                int j2 = 0;
                while (j2 < newindent) {
                    sb.append(' ');
                    ++j2;
                }
                sb.append(JSONObject.valueToString(this.myArrayList.elementAt(i2), indentFactor, newindent));
                ++i2;
            }
            sb.append('\n');
            i2 = 0;
            while (i2 < indent) {
                sb.append(' ');
                ++i2;
            }
        }
        sb.append(']');
        return sb.toString();
    }

    public Writer write(Writer writer) throws JSONException {
        try {
            boolean b2 = false;
            int len = this.length();
            writer.write(91);
            int i2 = 0;
            while (i2 < len) {
                Object v2;
                if (b2) {
                    writer.write(44);
                }
                if ((v2 = this.myArrayList.elementAt(i2)) instanceof JSONObject) {
                    ((JSONObject)v2).write(writer);
                } else if (v2 instanceof JSONArray) {
                    ((JSONArray)v2).write(writer);
                } else {
                    writer.write(JSONObject.valueToString(v2));
                }
                b2 = true;
                ++i2;
            }
            writer.write(93);
            return writer;
        }
        catch (IOException e2) {
            throw new JSONException(e2);
        }
    }
}

