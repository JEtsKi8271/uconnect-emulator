/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  konax.sensors.ChannelInfo
 *  konax.sensors.Data
 *  konax.sensors.DataListener
 *  konax.sensors.SensorConnection
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.listener;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.model.UnitConversionUtility;
import com.sprint.gskills.view.common.GSkillsStateManager;
import konax.sensors.ChannelInfo;
import konax.sensors.Data;
import konax.sensors.DataListener;
import konax.sensors.SensorConnection;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class UnitListener
implements DataListener {
    private Logger _logger = LoggerFactory.getLogger((String)this.getClass().getName());
    private static final UnitListener INSTANCE = new UnitListener();

    private UnitListener() {
    }

    public static UnitListener getInstance() {
        return INSTANCE;
    }

    public void dataReceived(SensorConnection sensor, Data[] data, boolean bool) {
        try {
            this._logger.debug((Object)"Received unit change callback");
            GSkillsThreadManager.getInstance().submit(new GSkillsRunnableWithErrorHandler(new NotifyUnitChange("UpdateOnUnitChangeThread", sensor, data)));
        }
        catch (Throwable e2) {
            this._logger.trace((Object)"ignoring Harman data ", e2);
        }
    }

    private class NotifyUnitChange
    extends GSkillsRunnable {
        SensorConnection sensor;
        Data[] data;

        public NotifyUnitChange(String name, SensorConnection sensor, Data[] newData) {
            super(name);
            this.sensor = null;
            this.sensor = sensor;
            this.data = newData;
        }

        public void run() {
            int currentUnit = 0;
            try {
                if (this.data != null) {
                    currentUnit = this.data[0].getIntValues()[0];
                }
                ChannelInfo[] ch2 = this.sensor.getSensorInfo().getChannelInfos();
                String chName = ch2[0].getName();
                UnitListener.this._logger.debug((Object)("Sensor name is " + ch2[0].getName()));
                if (chName.equals("PressureUnit")) {
                    GSkillsStateManager.getInstance().setPressureUnit(UnitConversionUtility.getInstance().getPressureUnitEnum(currentUnit));
                } else if (chName.equals("PowerUnit")) {
                    GSkillsStateManager.getInstance().setPowerUnit(UnitConversionUtility.getInstance().getPowerUnitEnum(currentUnit));
                } else if (chName.equals("TemperatureUnit")) {
                    GSkillsStateManager.getInstance().setTempUnit(UnitConversionUtility.getInstance().getTempUnitEnum(currentUnit));
                } else if (chName.equals("SpeedUnit")) {
                    GSkillsStateManager.getInstance().setSpeedUnit(UnitConversionUtility.getInstance().getSpeedUnitEnum(currentUnit));
                } else if (chName.equals("TorqueUnit")) {
                    GSkillsStateManager.getInstance().setTorqueUnit(UnitConversionUtility.getInstance().getTorqueUnitEnum(currentUnit));
                }
                GSkillsViewController.getInstance().notifyUnitChanged();
            }
            catch (Exception ex) {
                UnitListener.this._logger.error((Object)("get system Unit error:" + ex));
            }
        }
    }
}

