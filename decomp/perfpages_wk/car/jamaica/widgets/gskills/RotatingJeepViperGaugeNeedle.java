/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Image
 */
package car.jamaica.widgets.gskills;

import car.jamaica.widgets.gskills.RotatingNeedle;
import com.sun.lwuit.Image;

public class RotatingJeepViperGaugeNeedle
extends RotatingNeedle {
    public RotatingJeepViperGaugeNeedle(Image image) {
        super(image);
        this.getStyle().setBgTransparency(1);
    }

    public void setAngleRange() {
        this._a_min_ = -132;
        this._a_max_ = 0;
    }

    public void setPivotPoint() {
        this._pivotX = 100;
        this._pivotY = 105;
    }
}

