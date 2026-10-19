/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Display
 *  com.sun.lwuit.Form
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.animations.Animation
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BorderLayout
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  kona.platform.PlatformInfo
 *  kona.utils.Resource
 *  kona.utils.ResourceException
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.concurrency.GSkillsRunnable;
import com.sprint.gskills.constants.TimerSaveOptionsEnum;
import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.VehicleTrimEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.factory.ResKeyPropertiesFactory;
import com.sprint.gskills.util.GSkillsXletProperties;
import com.sprint.gskills.view.GSkillsViewBuildFactory;
import com.sprint.gskills.view.common.CommonLabel;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.mainview.MainMenuView;
import com.sprint.gskills.view.mainview.MainTitleView;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Display;
import com.sun.lwuit.Form;
import com.sun.lwuit.Image;
import com.sun.lwuit.animations.Animation;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BorderLayout;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import java.io.IOException;
import java.io.InputStream;
import kona.platform.PlatformInfo;
import kona.utils.Resource;
import kona.utils.ResourceException;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainView
extends Form {
    private Logger _logger = LoggerFactory.getLogger((String)((Object)((Object)this)).getClass().getName());
    private Container _mainViewContainer = null;
    private Container _superViewContainer = null;
    private Container _mainTitleContainer = null;
    private final GSkillsViewBuildFactory _viewFactory = GSkillsViewBuildFactory.getInstance();
    private Form _form = new Form();
    private final int MAIN_PAGE_COMPONENT_INDEX = 0;
    private final int CENTER_SCREEN_COMPONENT_INDEX = 1;
    private final String SPLASH_SCREEN_FOLDER = "/splash/";
    private static final MainView INSTANCE = new MainView();

    private MainView() {
        this._form.getStyle().setPadding(40, 0, 11, 6);
        this._form.setLayout((Layout)new CoordinateLayout(624, 333));
        this._form.getStyle().setBgColor(0);
        this._form.setScrollable(false);
    }

    public static MainView getInstance() {
        return INSTANCE;
    }

    public void showSplashScreen() {
        Display.getInstance().callSerially((Runnable)new GSkillsRunnable(){

            public void run() {
                MainView.this._logger.debug((Object)"INIT:Entering splash screen edt thread");
                MainView.this._form.addComponent(0, (Component)MainView.this.getSplashContainer());
                MainView.this._logger.debug((Object)"INIT:Exiting splash screen edt thread");
                MainView.this.showUI();
            }
        });
    }

    private Container getSplashContainer() {
        Container splashContainer = new Container();
        splashContainer.setPreferredSize(new Dimension(617, 275));
        splashContainer.setLayout((Layout)new CoordinateLayout(new Dimension(617, 273)));
        splashContainer.getStyle().setMargin(0, 5);
        try {
            if (ResKeyPropertiesFactory.useSharedResources() && !PlatformInfo.isRunningInEmulator()) {
                String splashImagePath = ResKeyPropertiesFactory.getSharedResourcesPath() + "/splash/" + this.getSplashScreenImage();
                splashContainer.getStyle().setBgImage(Image.createImage((InputStream)Resource.getInstance().getResourcesAsInputStream(splashImagePath)));
            } else {
                splashContainer.getStyle().setBgImage(Image.createImage((String)("/splash/" + this.getSplashScreenImage())));
            }
        }
        catch (IOException e2) {
            e2.printStackTrace();
        }
        catch (ResourceException e3) {
            e3.printStackTrace();
        }
        CommonLabel swVersionLabel = new CommonLabel();
        swVersionLabel.setAlignment(3);
        swVersionLabel.setPreferredSize(new Dimension(450, 25));
        swVersionLabel.setX(165);
        swVersionLabel.setY(250);
        if (ResKeyPropertiesFactory.useTestValues()) {
            this._logger.debug((Object)"Using test values in /fs/etfs/gskills.properties");
            swVersionLabel.setText("TestVersion!");
        } else {
            this._logger.debug((Object)"Displaying version number");
            swVersionLabel.setText("v" + GSkillsXletProperties.getXletVersion());
        }
        splashContainer.addComponent((Component)swVersionLabel);
        return splashContainer;
    }

    private String getSplashScreenImage() {
        String splashScreenImage = "splash_SRT.png";
        GSkillsStateManager stateManager = GSkillsStateManager.getInstance();
        VehicleLineEnum vehicleLine = stateManager.getVehicleLine();
        VehicleTrimEnum vehicleTrim = stateManager.getVehicleTrim();
        if (VehicleTrimEnum.RT == vehicleTrim) {
            if (VehicleLineEnum.LA == vehicleLine || VehicleLineEnum.LD == vehicleLine) {
                splashScreenImage = "splash_dodge.png";
            } else if (VehicleLineEnum.LX == vehicleLine) {
                splashScreenImage = "splash_chrysler.png";
            }
        }
        return splashScreenImage;
    }

    public void showUI() {
        this._form.show();
    }

    private Container intializeLineContainer() {
        Container lineContainer = new Container();
        lineContainer = new Container((Layout)new BorderLayout());
        lineContainer.setPreferredSize(new Dimension(624, 290));
        lineContainer.getStyle().setBgTransparency(0);
        lineContainer.setX(0);
        Container bottomLineImageContainer = new Container();
        Image bottomLineImage = GSkillsResourceManager.getInstance().getCommonImage("border-bottom-" + GSkillsStateManager.getInstance().getVehicleLine().toString() + ".png");
        bottomLineImageContainer.getStyle().setBgImage(bottomLineImage);
        bottomLineImageContainer.setPreferredSize(new Dimension(bottomLineImage.getWidth(), bottomLineImage.getHeight()));
        lineContainer.addComponent((Object)"South", (Component)bottomLineImageContainer);
        lineContainer.setVisible(true);
        return lineContainer;
    }

    public void updateViewOnSelectedMenuChanged(final ViewEnum currentView) {
        try {
            if (!Display.getInstance().isEdt()) {
                Display.getInstance().callSerially(new Runnable(){

                    public void run() {
                        MainView.this.updateRightScreen(currentView);
                    }
                });
            } else {
                this.updateRightScreen(currentView);
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            this._logger.error((Object)"update View On Selected Menu Changed error : ", (Throwable)ex);
        }
    }

    public void updateRightScreen() {
        this.updateScreen(this._viewFactory.getTimerContainer());
    }

    public void updateRightScreen(ViewEnum currentView) {
        this.updateScreen(this._viewFactory.getViewByCode(currentView));
    }

    public void updateRightScreen(TimerSaveOptionsEnum timerSaveOption) {
        this.updateScreen(this._viewFactory.getTimerContainer(timerSaveOption));
    }

    private void updateScreen(final Container newScreen) {
        if (!Display.getInstance().isEdt()) {
            Display.getInstance().callSerially(new Runnable(){

                public void run() {
                    MainView.this.updateForm(newScreen);
                }
            });
        } else {
            this.updateForm(newScreen);
        }
    }

    private void updateForm(Container newScreen) {
        this._form.deregisterAnimated((Animation)this._mainViewContainer.getComponentAt(1));
        this._mainViewContainer.replaceAndWait(this._mainViewContainer.getComponentAt(1), (Component)newScreen, null);
        this._form.registerAnimated((Animation)newScreen);
        this.showUI();
    }

    public void initializeHomePage() {
        this._superViewContainer = new Container();
        this._superViewContainer.setLayout((Layout)new CoordinateLayout(new Dimension(624, 290)));
        this._superViewContainer.setPreferredSize(new Dimension(624, 290));
        this._superViewContainer.getStyle().setBgTransparency(0);
        this._superViewContainer.setY(43);
        this._superViewContainer.addComponent((Component)this.intializeLineContainer());
        this._mainViewContainer = new Container();
        this._mainViewContainer.setLayout((Layout)new BoxLayout(1));
        this._mainViewContainer.getStyle().setBgTransparency(0);
        this._mainViewContainer.setX(5);
        this._mainViewContainer.setY(0);
        this._mainViewContainer.addComponent((Component)MainMenuView.getInstance());
        this._mainViewContainer.addComponent(1, (Component)this._viewFactory.getViewByCode(GSkillsStateManager.getInstance().getCurrentView()));
        this._superViewContainer.addComponent((Component)this._mainViewContainer);
        this._mainTitleContainer = new Container();
        this._mainTitleContainer.setPreferredSize(new Dimension(624, 72));
        this._mainTitleContainer.addComponent((Component)MainTitleView.getInstance());
        this._mainTitleContainer.setX(0);
        this._mainTitleContainer.setY(0);
    }

    public void displayHomePage() {
        Display.getInstance().callSerially((Runnable)new GSkillsRunnable(){

            public void run() {
                Container formContent = MainView.this._form.getContentPane();
                MainView.this._form.replace(formContent.getComponentAt(0), (Component)MainView.this._superViewContainer, null);
                MainView.this._form.registerAnimated((Animation)MainView.this._viewFactory.getViewByCode(GSkillsStateManager.getInstance().getCurrentView()));
                MainView.this._form.addComponent((Component)MainView.this._mainTitleContainer);
                MainView.this.showUI();
            }
        });
    }

    protected void onShowCompleted() {
        this._logger.debug((Object)"======================================");
        this._logger.debug((Object)("New screen displayed at " + System.currentTimeMillis()));
        this._logger.debug((Object)"======================================");
    }
}

