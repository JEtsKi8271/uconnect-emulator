/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Graphics
 *  com.sun.lwuit.Image
 *  com.sun.lwuit.Label
 *  com.sun.lwuit.geom.Dimension
 */
package car.jamaica.widgets.gskills;

import com.sun.lwuit.Graphics;
import com.sun.lwuit.Image;
import com.sun.lwuit.Label;
import com.sun.lwuit.geom.Dimension;

public abstract class Transformable
extends Label {
    protected Image _image;

    abstract void transform(Graphics var1);

    abstract void untransform(Graphics var1);

    protected Transformable(Image image) {
        this._image = image;
        this.setPreferredSize(new Dimension(image.getWidth(), image.getHeight()));
    }

    public void paint(Graphics g2) {
        int x2 = this.getAbsoluteX();
        int y2 = this.getAbsoluteY();
        int tx = g2.getTranslateX();
        int ty = g2.getTranslateY();
        g2.translate(x2, y2);
        g2.translate(-tx, -ty);
        this.transform(g2);
        g2.drawImage(this._image, 0, 0);
        this.untransform(g2);
        g2.translate(tx, ty);
        g2.translate(-x2, -y2);
    }
}

