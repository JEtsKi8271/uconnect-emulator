/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.util;

import java.io.File;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class GSkillsLogger {
    private static Logger _logger = LoggerFactory.getLogger((String)GSkillsLogger.class.getName());
    private static boolean _isLoggingEnabled = false;

    public static void debug(String message) {
        if (_isLoggingEnabled) {
            _logger.debug((Object)message);
        }
    }

    static {
        File f2 = new File("/fs/etfs/enableGSkillsLogging");
        if (f2.exists()) {
            _isLoggingEnabled = true;
            _logger.debug((Object)"Additional logging enabled");
        } else {
            _logger.debug((Object)"Additional logging enabler not found");
        }
    }
}

