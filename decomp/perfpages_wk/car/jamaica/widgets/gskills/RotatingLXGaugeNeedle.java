/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Image
 */
package car.jamaica.widgets.gskills;

import car.jamaica.widgets.gskills.RotatingNeedle;
import com.sun.lwuit.Image;

public class RotatingLXGaugeNeedle
extends RotatingNeedle {
    public RotatingLXGaugeNeedle(Image image) {
        super(image);
        this.getStyle().setBgTransparency(1);
    }

    public void setAngleRange() {
        this._a_min_ = -85;
        this._a_max_ = 175;
    }

    public void setPivotPoint() {
        this._pivotX = 32;
        this._pivotY = 32;
    }
}

