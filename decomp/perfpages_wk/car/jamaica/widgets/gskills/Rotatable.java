/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Graphics
 *  com.sun.lwuit.Image
 */
package car.jamaica.widgets.gskills;

import car.jamaica.widgets.gskills.Transformable;
import com.sun.lwuit.Affiner;
import com.sun.lwuit.Graphics;
import com.sun.lwuit.Image;

public class Rotatable
extends Transformable {
    protected int _pivotX;
    protected int _pivotY;
    private static final float PI = (float)Math.PI;
    private float _angle_radians = 6.1086526f;
    protected Affiner _affiner;

    public Rotatable(Image image) {
        super(image);
    }

    public Rotatable(Image image, int pivotX, int pivotY) {
        super(image);
        this._pivotX = pivotX;
        this._pivotY = pivotY;
    }

    public void setAngleDegrees(double angle_degrees) {
        this._angle_radians = (float)Math.toRadians(angle_degrees);
    }

    public void setAngleDegrees_f(float angle_degrees) {
        this._angle_radians = angle_degrees * (float)Math.PI / 180.0f;
    }

    void transform(Graphics g2) {
        this._affiner = Affiner.getInstance(g2);
        this._affiner.rotate(this._angle_radians, this.getAbsoluteX() + this._pivotX, this.getAbsoluteY() + this._pivotY);
    }

    void untransform(Graphics g2) {
        this._affiner.resetAffine();
    }
}

