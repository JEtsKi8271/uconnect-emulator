/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.xlet.Xlet
 *  javax.microedition.xlet.XletContext
 *  javax.microedition.xlet.XletStateChangeException
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.xlet;

import com.sprint.gskills.xlet.GSkillsModule;
import javax.microedition.xlet.Xlet;
import javax.microedition.xlet.XletContext;
import javax.microedition.xlet.XletStateChangeException;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class GSkillsXlet
implements Xlet {
    private Logger _logger = Log.createLogger((String)this.getClass().getName());

    public void initXlet(XletContext xletContext) throws XletStateChangeException {
        try {
            this._logger.debug((Object)"In initXlet()");
            GSkillsModule.getInstance().initModule(xletContext);
        }
        catch (Throwable e2) {
            this._logger.error((Object)" init ", e2);
        }
    }

    public void startXlet() throws XletStateChangeException {
        try {
            this._logger.debug((Object)"In startXlet()");
            GSkillsModule.getInstance().startModule();
        }
        catch (Throwable e2) {
            this._logger.error((Object)" start ", e2);
        }
    }

    public void pauseXlet() {
        try {
            this._logger.debug((Object)"pauseXlet()");
            GSkillsModule.getInstance().pauseModule();
        }
        catch (Throwable e2) {
            this._logger.error((Object)" pause ", e2);
        }
    }

    public void destroyXlet(boolean arg0) throws XletStateChangeException {
        try {
            this._logger.debug((Object)"destroyXlet()");
            GSkillsModule.getInstance().destroyModule();
        }
        catch (Throwable e2) {
            this._logger.error((Object)" destroy ", e2);
        }
    }
}

