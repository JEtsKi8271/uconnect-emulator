/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.airbiquity.sdp.common.impl;

import com.airbiquity.sdp.common.DsptMessageWrapper;
import com.airbiquity.sdp.common.properties.SDPCommonProperties;
import com.wirelesscar.ngtp.dspt.api.DsptMessage;
import com.wirelesscar.ngtp.dspt.api.MessageCoder;
import com.wirelesscar.ngtp.dspt.api.MessageCoderFactory;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class DsptMessageWrapperImpl
implements DsptMessageWrapper {
    private static final long serialVersionUID = 1L;
    private transient DsptMessage dsptMsg;
    private static Logger logger = LoggerFactory.getLogger(DsptMessageWrapperImpl.class);

    public DsptMessageWrapperImpl(DsptMessage dsptMsg) {
        this.dsptMsg = dsptMsg;
    }

    private void writeObject(ObjectOutputStream s2) throws IOException {
        MessageCoder coder = MessageCoderFactory.getMessageCoder(SDPCommonProperties.getDSPTCoderVersion());
        s2.defaultWriteObject();
        try {
            byte[] bytes = coder.encode(this.dsptMsg);
            s2.writeObject(bytes);
        }
        catch (Throwable e2) {
            logger.error((Object)"Failed writeObject", e2);
            throw new IOException(e2.getMessage());
        }
    }

    private void readObject(ObjectInputStream s2) throws IOException, ClassNotFoundException {
        MessageCoder coder = MessageCoderFactory.getMessageCoder(SDPCommonProperties.getDSPTCoderVersion());
        s2.defaultReadObject();
        byte[] bytes = (byte[])s2.readObject();
        try {
            this.dsptMsg = coder.decode(bytes);
        }
        catch (Throwable e2) {
            logger.error((Object)"Failed readObject", e2);
            throw new IOException(e2.getMessage());
        }
    }

    public DsptMessage getDsptMessage() {
        return this.dsptMsg;
    }
}

