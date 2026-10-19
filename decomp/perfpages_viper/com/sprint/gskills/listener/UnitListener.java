/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.Data
 *  konax.sensors.DataListener
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.factory.GSkillsProjectFactory;
import com.sprint.gskills.view.common.GSkillsStateManager;
import edu.emory.mathcs.backport.java.util.concurrent.Callable;
import edu.emory.mathcs.backport.java.util.concurrent.ExecutorService;
import konax.sensors.Data;
import konax.sensors.DataListener;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class UnitListener
implements DataListener {
    private Logger logger = LoggerFactory.getLogger(UnitListener.class);
    private static final ExecutorService dataListenerExecutor = GSkillsProjectFactory.getDataListenersExecutor();
    private GSkillsStateManager stateManager = GSkillsStateManager.getInstance();

    public void dataReceived(SensorConnection sensor, Data[] data, boolean bool) {
        this.logger.trace((Object)"UnitListener.dataReceived()");
        try {
            dataListenerExecutor.submit(new NotifyModelDataChange(data));
        }
        catch (Throwable e2) {
            this.logger.trace((Object)"ignoring Harman data ", e2);
        }
    }

    private class NotifyModelDataChange
    implements Callable {
        Data[] data;

        public NotifyModelDataChange(Data[] newData) {
            this.data = newData;
        }

        public Object call() throws Exception {
            try {
                UnitListener.this.logger.trace((Object)"UnitListener.NotifyModelDataChange.call()");
                if (this.data != null) {
                    int curretunit = this.data[0].getIntValues()[0];
                    UnitListener.this.logger.trace((Object)("{} Workaround log - Speed unit = " + curretunit));
                    UnitListener.this.stateManager.setCurrentUnit(curretunit);
                }
            }
            catch (Exception ex) {
                UnitListener.this.logger.error((Object)("get system Unit error:" + ex));
            }
            return null;
        }
    }
}

