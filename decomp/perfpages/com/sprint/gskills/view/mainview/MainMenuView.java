/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Component
 *  com.sun.lwuit.Container
 *  com.sun.lwuit.Font
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.events.ActionEvent
 *  com.sun.lwuit.events.ActionListener
 *  com.sun.lwuit.geom.Dimension
 *  com.sun.lwuit.layouts.BoxLayout
 *  com.sun.lwuit.layouts.CoordinateLayout
 *  com.sun.lwuit.layouts.Layout
 *  net.sf.microlog.core.Logger
 *  net.sf.microlog.core.LoggerFactory
 */
package com.sprint.gskills.view.mainview;

import com.sprint.gskills.constants.VehicleLineEnum;
import com.sprint.gskills.constants.ViewEnum;
import com.sprint.gskills.controller.GSkillsViewController;
import com.sprint.gskills.factory.GSkillsFontsStyleFactory;
import com.sprint.gskills.util.CommonUtils;
import com.sprint.gskills.view.common.CommonButtonContainer;
import com.sprint.gskills.view.common.GSkillsResourceManager;
import com.sprint.gskills.view.common.GSkillsStateManager;
import com.sprint.gskills.view.common.GSkillsView;
import com.sun.lwuit.Component;
import com.sun.lwuit.Container;
import com.sun.lwuit.Font;
import com.sun.lwuit.Image;
import com.sun.lwuit.events.ActionEvent;
import com.sun.lwuit.events.ActionListener;
import com.sun.lwuit.geom.Dimension;
import com.sun.lwuit.layouts.BoxLayout;
import com.sun.lwuit.layouts.CoordinateLayout;
import com.sun.lwuit.layouts.Layout;
import net.sf.microlog.core.Logger;
import net.sf.microlog.core.LoggerFactory;

public class MainMenuView
extends GSkillsView {
    private Logger _logger = LoggerFactory.getLogger((String)((Object)((Object)this)).getClass().getName());
    private GSkillsViewController _viewController = null;
    private GSkillsStateManager _stateManager = null;
    private static final MainMenuView INSTANCE = new MainMenuView();
    private Container _mainMenuViewContainer = null;
    private CommonButtonContainer _homeButton = null;
    private CommonButtonContainer _timersButton = null;
    private CommonButtonContainer _gforceButton = null;
    private CommonButtonContainer _gaugeOneButton = null;
    private CommonButtonContainer _gaugeTwoButton = null;
    private CommonButtonContainer _engineButton = null;
    private final Image _homeBtnActiveImage;
    private final Image _homeBtnPressedImage;
    private final Image _midBtnsActiveImage;
    private final Image _midBtnsPressedImage;
    private final Image _engineBtnPressedImage;
    private final Image _engineBtnActiveImage;
    private long _keyPressTimeStamp = System.currentTimeMillis();

    public static MainMenuView getInstance() {
        return INSTANCE;
    }

    private MainMenuView() {
        this.setLayout((Layout)new CoordinateLayout(new Dimension(85, 282)));
        this.setPreferredSize(new Dimension(85, 282));
        this._mainMenuViewContainer = new Container((Layout)new BoxLayout(2));
        this._mainMenuViewContainer.setY(1);
        this._stateManager = GSkillsStateManager.getInstance();
        Font f14 = GSkillsFontsStyleFactory.getInstance().getFontSize14();
        this._homeButton = new CommonButtonContainer(f14, new Dimension(85, 47));
        this._homeButton.addActionListener(new ButtonActionListener(ViewEnum.HOME_VIEW));
        this._timersButton = new CommonButtonContainer(f14, new Dimension(85, 48));
        this._timersButton.addActionListener(new ButtonActionListener(ViewEnum.TIMERS_VIEW));
        this._gforceButton = new CommonButtonContainer(f14, new Dimension(85, 48));
        this._gforceButton.addActionListener(new ButtonActionListener(ViewEnum.GFORCE_VIEW));
        this._gaugeOneButton = new CommonButtonContainer(f14, new Dimension(85, 47));
        this._gaugeOneButton.addActionListener(new ButtonActionListener(ViewEnum.GAUGESONE_VIEW));
        this._gaugeTwoButton = new CommonButtonContainer(f14, new Dimension(85, 47));
        this._gaugeTwoButton.addActionListener(new ButtonActionListener(ViewEnum.GAUGESTWO_VIEW));
        this._engineButton = new CommonButtonContainer(f14, new Dimension(85, 48));
        this._engineButton.addActionListener(new ButtonActionListener(ViewEnum.ENGINE_VIEW));
        this._viewController = GSkillsViewController.getInstance();
        String imageSuffix = ".png";
        this._homeBtnActiveImage = GSkillsResourceManager.getInstance().getCommonImage("btn-top-off" + imageSuffix);
        this._midBtnsActiveImage = GSkillsResourceManager.getInstance().getCommonImage("btn-mid-off" + imageSuffix);
        this._engineBtnActiveImage = GSkillsResourceManager.getInstance().getCommonImage("btn-bottom-off" + imageSuffix);
        if (VehicleLineEnum.LX == this._stateManager.getVehicleLine()) {
            imageSuffix = "-lx.png";
        }
        this._homeBtnPressedImage = GSkillsResourceManager.getInstance().getCommonImage("btn-top-on" + imageSuffix);
        this._midBtnsPressedImage = GSkillsResourceManager.getInstance().getCommonImage("btn-mid-on" + imageSuffix);
        this._engineBtnPressedImage = GSkillsResourceManager.getInstance().getCommonImage("btn-bottom-on" + imageSuffix);
        this.initLayout();
        this.updateOnLanguageChanged();
    }

    private void initLayout() {
        this.updateOnLanguageChanged();
        this.setDefaultMenuStyle();
        if (this._homeBtnPressedImage != null) {
            this._homeButton.getStyle().setBgImage(this._homeBtnPressedImage);
        }
        this._mainMenuViewContainer.addComponent((Component)this._homeButton);
        this._mainMenuViewContainer.addComponent((Component)this._timersButton);
        this._mainMenuViewContainer.addComponent((Component)this._gaugeOneButton);
        this._mainMenuViewContainer.addComponent((Component)this._gaugeTwoButton);
        this._mainMenuViewContainer.addComponent((Component)this._gforceButton);
        this._mainMenuViewContainer.addComponent((Component)this._engineButton);
        this.addComponent((Component)this._mainMenuViewContainer);
    }

    public void updateOnLanguageChanged() {
        this.resetMenuLabText();
    }

    private void resetMenuLabText() {
        this._homeButton.setText("menu_Home");
        this._timersButton.setText("menu_Timers");
        this._gforceButton.setText("menu_Gforce");
        this._gaugeOneButton.setText("menu_GaugesOne");
        this._gaugeTwoButton.setText("menu_GaugesTwo");
        this._engineButton.setText("menu_Engine");
    }

    private void setDefaultMenuStyle() {
        if (this._homeBtnActiveImage != null) {
            this._homeButton.getStyle().setBgImage(this._homeBtnActiveImage);
        }
        if (this._midBtnsActiveImage != null) {
            this._timersButton.getStyle().setBgImage(this._midBtnsActiveImage);
            this._gforceButton.getStyle().setBgImage(this._midBtnsActiveImage);
            this._gaugeOneButton.getStyle().setBgImage(this._midBtnsActiveImage);
            this._gaugeTwoButton.getStyle().setBgImage(this._midBtnsActiveImage);
        }
        if (this._engineBtnActiveImage != null) {
            this._engineButton.getStyle().setBgImage(this._engineBtnActiveImage);
        }
        try {
            this._homeButton.getPressedStyle().setBgImage(this._homeBtnPressedImage);
            this._timersButton.getPressedStyle().setBgImage(this._midBtnsPressedImage);
            this._gforceButton.getPressedStyle().setBgImage(this._midBtnsPressedImage);
            this._gaugeOneButton.getPressedStyle().setBgImage(this._midBtnsPressedImage);
            this._gaugeTwoButton.getPressedStyle().setBgImage(this._midBtnsPressedImage);
            this._engineButton.getPressedStyle().setBgImage(this._engineBtnPressedImage);
            this._homeButton.getSelectedStyle().setBgImage(this._homeBtnPressedImage);
            this._timersButton.getSelectedStyle().setBgImage(this._midBtnsPressedImage);
            this._gforceButton.getSelectedStyle().setBgImage(this._midBtnsPressedImage);
            this._gaugeOneButton.getSelectedStyle().setBgImage(this._midBtnsPressedImage);
            this._gaugeTwoButton.getSelectedStyle().setBgImage(this._midBtnsPressedImage);
            this._engineButton.getSelectedStyle().setBgImage(this._engineBtnPressedImage);
        }
        catch (Exception ex) {
            this._logger.error((Object)"", (Throwable)ex);
        }
    }

    private void notifySelectedMenuChanged(ViewEnum intViewType) {
        this._viewController.notifyDisplayViewChanged(intViewType);
    }

    private void cancelMenuPressedStyle(ViewEnum oldView) {
        switch (oldView.getViewID()) {
            case 0: {
                this._homeButton.getStyle().setBgImage(this._homeBtnActiveImage);
                this._homeButton.repaint();
                break;
            }
            case 1: {
                this._timersButton.getStyle().setBgImage(this._midBtnsActiveImage);
                this._timersButton.repaint();
                break;
            }
            case 4: {
                this._gforceButton.getStyle().setBgImage(this._midBtnsActiveImage);
                this._gforceButton.repaint();
                break;
            }
            case 2: {
                this._gaugeOneButton.getStyle().setBgImage(this._midBtnsActiveImage);
                this._gaugeOneButton.repaint();
                break;
            }
            case 3: {
                this._gaugeTwoButton.getStyle().setBgImage(this._midBtnsActiveImage);
                this._gaugeTwoButton.repaint();
                break;
            }
            case 5: {
                this._engineButton.getStyle().setBgImage(this._engineBtnActiveImage);
                this._engineButton.repaint();
                break;
            }
            default: {
                this._logger.debug((Object)("***VPS*** - cancelMenuPressedStyle() - Unknown view " + oldView));
            }
        }
    }

    private void setMenuPressedStyle(ViewEnum currentView) {
        switch (currentView.getViewID()) {
            case 0: {
                this._homeButton.getStyle().setBgImage(this._homeBtnPressedImage);
                this._homeButton.repaint();
                break;
            }
            case 1: {
                this._timersButton.getStyle().setBgImage(this._midBtnsPressedImage);
                this._timersButton.repaint();
                break;
            }
            case 4: {
                this._gforceButton.getStyle().setBgImage(this._midBtnsPressedImage);
                this._gforceButton.repaint();
                break;
            }
            case 2: {
                this._gaugeOneButton.getStyle().setBgImage(this._midBtnsPressedImage);
                this._gaugeOneButton.repaint();
                break;
            }
            case 3: {
                this._gaugeTwoButton.getStyle().setBgImage(this._midBtnsPressedImage);
                this._gaugeTwoButton.repaint();
                break;
            }
            case 5: {
                this._engineButton.getStyle().setBgImage(this._engineBtnPressedImage);
                this._engineButton.repaint();
                break;
            }
            default: {
                this._logger.debug((Object)("***VPS*** - resetMenuLabBackground() - Unknown view " + currentView));
            }
        }
    }

    public long getKeyPressTimeStamp() {
        return this._keyPressTimeStamp;
    }

    private class ButtonActionListener
    implements ActionListener {
        ViewEnum _viewConstant;

        public ButtonActionListener(ViewEnum viewConstant) {
            this._viewConstant = viewConstant;
        }

        public void actionPerformed(ActionEvent arg0) {
            CommonUtils.getInstance().beepOnClick();
            if (MainMenuView.this._stateManager.getCurrentView() != this._viewConstant) {
                MainMenuView.this.setMenuPressedStyle(this._viewConstant);
                MainMenuView.this.cancelMenuPressedStyle(MainMenuView.this._stateManager.getCurrentView());
                MainMenuView.this.notifySelectedMenuChanged(this._viewConstant);
            }
        }
    }
}

