/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Image
 */
package car.jamaica.widgets.gskills;

import car.jamaica.widgets.gskills.Rotatable;
import com.sun.lwuit.Image;

public abstract class RotatingNeedle
extends Rotatable {
    protected int _a_min_;
    protected int _a_max_;
    protected int _a_span_;

    public abstract void setAngleRange();

    public abstract void setPivotPoint();

    public RotatingNeedle(Image image) {
        super(image);
        this.setAngleRange();
        this.setPivotPoint();
        this._a_span_ = this._a_max_ - this._a_min_;
    }

    public boolean isAnimated() {
        return true;
    }

    public boolean animate() {
        return true;
    }

    public void set(double v_uni) {
        double a2 = (double)this._a_min_ + v_uni * (double)this._a_span_;
        this.setAngleDegrees(a2);
    }

    public void set(double value, double v_min, double v_max) {
        double v_span = v_max - v_min;
        double v_uni = (value - v_min) / v_span;
        this.set(v_uni);
    }
}

