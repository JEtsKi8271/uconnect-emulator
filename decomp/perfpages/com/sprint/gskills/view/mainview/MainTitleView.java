/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Button
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.appManager.AppManager
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.concurrency.GSkillsRunnableWithErrorHandler;
import com.sprint.gskills.concurrency.GSkillsThreadManager;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sun.lwuit.Button;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.Layout;
import kona.appManager.AppManager;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainTitleView
extends Container {
    private Logger _logger = LoggerFactory.getLogger((String)((Object)((Object)this)).getClass().getName());
    private final int CONTAINER_WIDTH = 637;
    private final int CONTAINER_HEIGHT = 72;
    private static final MainTitleView INSTANCE = new MainTitleView();

    public static MainTitleView getInstance() {
        return INSTANCE;
    }

    private MainTitleView() {
        Container mainTitleImageContainer = new Container();
        this.setPreferredSize(new Dimension(637, 72));
        this.setLayout((Layout)new BoxLayout(2));
        String performanceModeBtnSuffix = "-srt.png";
        String topBorderSuffix = "-srt.png";
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        if (VehicleTrimEnum.RT == stateManager.getVehicleTrim()) {
            performanceModeBtnSuffix = "-rt.png";
            topBorderSuffix = "-rt.png";
        }
        Button performanceModesButton = new Button(GSkillsResourceManager.getInstance().getCommonImage("btn-performance-modes" + performanceModeBtnSuffix));
        this.setButtonProperties(performanceModesButton);
        performanceModesButton.setPreferredH(41);
        String topBorderImage = "border-top-" + stateManager.getVehicleLine().toString() + topBorderSuffix;
        mainTitleImageContainer.getStyle().setBgImage(GSkillsResourceManager.getInstance().getCommonImage(topBorderImage));
        mainTitleImageContainer.getStyle().setBackgroundAlignment((byte)5);
        mainTitleImageContainer.getStyle().setBackgroundAlignment((byte)-92);
        mainTitleImageContainer.setPreferredH(72);
        mainTitleImageContainer.addComponent((Component)performanceModesButton);
        performanceModesButton.addActionListener(new ActionListener(){

            public void actionPerformed(ActionEvent arg0) {
                MainTitleView.this._logger.debug((Object)"Starting the Drive Modes application");
                GSkillsThreadManager.getInstance().execute(new GSkillsRunnableWithErrorHandler(new GSkillsRunnable("SwitchToDriveModesThread"){

                    public void run() {
                        try {
                            CommonUtils.getInstance().beepOnClick();
                            AppManager.getInstance().switchToDriveMode();
                        }
                        catch (Throwable e2) {
                            MainTitleView.this._logger.debug((Object)"Tried switching to Drive Modes on an unsupported version of the firmware");
                            e2.printStackTrace();
                        }
                    }
                }));
            }
        });
        this.addComponent((Component)mainTitleImageContainer);
        this.getStyle().setBgTransparency(0);
    }

    private void setButtonProperties(Button button) {
        button.getStyle().setBorder(null);
        button.getPressedStyle().setBorder(null);
        button.getSelectedStyle().setBorder(null);
        button.getStyle().setMargin(0, 0, 0, 0);
        button.getSelectedStyle().setMargin(0, 0, 0, 0);
        button.getPressedStyle().setMargin(0, 0, 0, 0);
        button.getStyle().setBgTransparency(0);
        button.getSelectedStyle().setBgTransparency(0);
        button.getPressedStyle().setBgTransparency(0);
    }
}

