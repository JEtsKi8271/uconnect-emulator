/*
 * Decompiled with CFR 0.152.
 */
package org.json;

import java.io.IOException;
import java.io.Writer;

public class StringWriter
extends Writer {
    private final StringBuffer buf;

    public StringWriter() {
        this.buf = new StringBuffer();
    }

    public StringWriter(int initialSize) {
        this.buf = new StringBuffer(initialSize);
    }

    @Override
    public void write(char[] cbuf, int off, int len) throws IOException {
        this.buf.append(cbuf, off, len);
    }

    @Override
    public void write(String str) throws IOException {
        this.buf.append(str);
    }

    @Override
    public void write(String str, int off, int len) throws IOException {
        this.buf.append(str.substring(off, len));
    }

    @Override
    public void flush() throws IOException {
    }

    @Override
    public void close() throws IOException {
    }
}

