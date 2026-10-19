/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.microedition.location.LocationException
 *  kona.onoffcontrol.OnOffControlException
 *  konax.automotive.PollingDurationFive
 *  konax.automotive.PollingDurationFour
 *  konax.automotive.PollingDurationOne
 *  konax.automotive.PollingDurationSeven
 *  konax.automotive.PollingDurationSix
 *  konax.automotive.PollingDurationThree
 *  konax.automotive.PollingDurationTwo
 *  konax.automotive.PollingIntervalFive
 *  konax.automotive.PollingIntervalFour
 *  konax.automotive.PollingIntervalOne
 *  konax.automotive.PollingIntervalSeven
 *  konax.automotive.PollingIntervalSix
 *  konax.automotive.PollingIntervalThree
 *  konax.automotive.PollingIntervalTwo
 *  konax.automotive.PowerMode
 *  konax.automotive.TheftAlarm
 *  konax.automotive.UnsupportedComponentException
 */
package com.airbiquity.sdp.common.factory;

import com.airbiquity.sdp.interfaces.AqComponentManager;
import com.airbiquity.sdp.interfaces.AqConnectivityManager;
import com.airbiquity.sdp.interfaces.AqConnector;
import com.airbiquity.sdp.interfaces.AqLocationProvider;
import com.airbiquity.sdp.interfaces.AqOnOffControl;
import com.airbiquity.sdp.interfaces.AqRecordStore;
import com.airbiquity.sdp.interfaces.AqTelematicManager;
import javax.microedition.location.LocationException;
import kona.onoffcontrol.OnOffControlException;
import konax.automotive.PollingDurationFive;
import konax.automotive.PollingDurationFour;
import konax.automotive.PollingDurationOne;
import konax.automotive.PollingDurationSeven;
import konax.automotive.PollingDurationSix;
import konax.automotive.PollingDurationThree;
import konax.automotive.PollingDurationTwo;
import konax.automotive.PollingIntervalFive;
import konax.automotive.PollingIntervalFour;
import konax.automotive.PollingIntervalOne;
import konax.automotive.PollingIntervalSeven;
import konax.automotive.PollingIntervalSix;
import konax.automotive.PollingIntervalThree;
import konax.automotive.PollingIntervalTwo;
import konax.automotive.PowerMode;
import konax.automotive.TheftAlarm;
import konax.automotive.UnsupportedComponentException;

public interface SDPFactory {
    public AqRecordStore getRecordStore(String var1);

    public AqLocationProvider getLocationProvider() throws LocationException;

    public AqTelematicManager getTelematicManager();

    public AqComponentManager getComponentManager();

    public AqConnectivityManager getConnectivityManager();

    public AqConnector getConnector();

    public TheftAlarm getTheftAlarmComponent() throws UnsupportedComponentException;

    public PowerMode getPowerModeSensor();

    public PollingDurationOne getPollingDurationOne() throws UnsupportedComponentException;

    public PollingDurationTwo getPollingDurationTwo() throws UnsupportedComponentException;

    public PollingDurationThree getPollingDurationThree() throws UnsupportedComponentException;

    public PollingDurationFour getPollingDurationFour() throws UnsupportedComponentException;

    public PollingDurationFive getPollingDurationFive() throws UnsupportedComponentException;

    public PollingDurationSix getPollingDurationSix() throws UnsupportedComponentException;

    public PollingDurationSeven getPollingDurationSeven() throws UnsupportedComponentException;

    public PollingIntervalOne getPollingIntervalOne() throws UnsupportedComponentException;

    public PollingIntervalTwo getPollingIntervalTwo() throws UnsupportedComponentException;

    public PollingIntervalThree getPollingIntervalThree() throws UnsupportedComponentException;

    public PollingIntervalFour getPollingIntervalFour() throws UnsupportedComponentException;

    public PollingIntervalFive getPollingIntervalFive() throws UnsupportedComponentException;

    public PollingIntervalSix getPollingIntervalSix() throws UnsupportedComponentException;

    public PollingIntervalSeven getPollingIntervalSeven() throws UnsupportedComponentException;

    public String getPollingDurationName(int var1);

    public String getPollingIntervalName(int var1);

    public String getStartTimeName(int var1);

    public int getHMILanguage();

    public AqOnOffControl getAqOnOffControl() throws OnOffControlException;
}

