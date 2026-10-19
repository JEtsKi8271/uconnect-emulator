/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import org.json.JSONWriter;
import org.json.StringWriter;

public class JSONStringer
extends JSONWriter {
    public JSONStringer() {
        super(new StringWriter());
    }

    public String toString() {
        return this.mode == 'd' ? this.writer.toString() : null;
    }
}

