/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  kona.logger.Log
 *  net.sf.microlog.core.Logger
 */
package com.sprint.gskills.controller.savetimerrun;

import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.io.Writer;
import kona.logger.Log;
import net.sf.microlog.core.Logger;

public class TimerSavingData
implements Serializable {
    private static final long serialVersionUID = 1L;
    private Logger logger = Log.createLogger((String)this.getClass().getName());

    public int saveDataTo(TimerSaveOptionsEnum timerSaveOption, String dataInHtmlFormat, String fileName) {
        try {
            String devicePath = timerSaveOption.getDevicePath();
            if (!this.isDeviceAvailable(devicePath)) {
                this.logger.error((Object)(timerSaveOption.getTitleName() + " device not found"));
                return 23;
            }
            File downloadFolder = new File(devicePath, ResKeyPropertiesFactory.getSaveFolder());
            if (!downloadFolder.exists() && !downloadFolder.mkdir()) {
                return 24;
            }
            this.createUpdateDownloadFile(downloadFolder, dataInHtmlFormat, fileName);
            return 13;
        }
        catch (FileNotFoundException e2) {
            return 23;
        }
        catch (IOException e3) {
            return 24;
        }
    }

    private File createUpdateDownloadFile(File downloadFolder, String dataInHtmlFormat, String fileName) throws IOException {
        File downloadTimerFile;
        if (!downloadFolder.exists()) {
            downloadFolder.mkdirs();
        }
        if ((downloadTimerFile = new File(downloadFolder.getAbsolutePath() + "/" + fileName + this.getSuffix())).createNewFile()) {
            this.updateHTML(downloadTimerFile, dataInHtmlFormat);
        }
        return downloadTimerFile;
    }

    private void updateHTML(File file, String dataInHtmlFormat) throws IOException {
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            OutputStreamWriter out = new OutputStreamWriter((OutputStream)fos, "UTF8");
            out.write(dataInHtmlFormat);
            ((Writer)out).flush();
        }
        catch (FileNotFoundException e2) {
            this.logger.error((Object)(file.getAbsolutePath() + " not found " + e2));
            throw e2;
        }
        catch (IOException e3) {
            this.logger.error((Object)("error updating file " + file.getAbsolutePath()), (Throwable)e3);
            throw e3;
        }
        finally {
            if (fos != null) {
                try {
                    fos.close();
                }
                catch (IOException e4) {
                    this.logger.error((Object)"error closing file stream ", (Throwable)e4);
                }
            }
        }
    }

    private String getSuffix() {
        return ".html";
    }

    private boolean isDeviceAvailable(String dieviceDefaultPath) {
        File file = new File(dieviceDefaultPath);
        return file.exists();
    }
}

