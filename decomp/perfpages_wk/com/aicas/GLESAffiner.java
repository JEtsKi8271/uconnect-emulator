/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  java.awt.GLESRenderTarget
 *  java.awt.GLESRenderer$RendererTask
 */
package com.aicas;

import java.awt.GLESRenderTarget;
import java.awt.GLESRenderer;

public class GLESAffiner {
    static final double bestAngleForEnginePage = 3.2142857142857144;
    static final double resolution = 0.05609986881410345;
    static float[] sinLU = new float[113];
    static float[] cosLU = new float[113];

    public static void translate(GLESRenderTarget target, final long nativeHandler, int x2, int y2) {
        if (x2 != 0 || y2 != 0) {
            final float[] m2 = new float[6];
            m2[0] = 1.0f;
            m2[3] = 1.0f;
            m2[4] = x2;
            m2[5] = y2;
            new GLESRenderer.RendererTask(target, "multMatrix"){

                public void render() {
                    GLESAffiner.nativeMultMatrix(nativeHandler, m2);
                }
            };
        }
    }

    public static void rotate(GLESRenderTarget target, final long nativeHandler, float radianAngle) {
        if ((double)radianAngle != 0.0) {
            while (radianAngle < 0.0f) {
                radianAngle = (float)((double)radianAngle + Math.PI * 2);
            }
            while ((double)radianAngle > Math.PI * 2) {
                radianAngle = (float)((double)radianAngle - Math.PI * 2);
            }
            final float[] m2 = new float[6];
            float cos = cosLU[(int)((double)radianAngle / 0.05609986881410345)];
            float sin = sinLU[(int)((double)radianAngle / 0.05609986881410345)];
            m2[0] = cos;
            m2[1] = sin;
            m2[2] = -sin;
            m2[3] = cos;
            new GLESRenderer.RendererTask(target, "multMatrix"){

                public void render() {
                    GLESAffiner.nativeMultMatrix(nativeHandler, m2);
                }
            };
        }
    }

    public static void rotate(GLESRenderTarget target, final long nativeHandler, float radianAngle, int x2, int y2) {
        if (radianAngle != 0.0f) {
            while (radianAngle < 0.0f) {
                radianAngle = (float)((double)radianAngle + Math.PI * 2);
            }
            while ((double)radianAngle > Math.PI * 2) {
                radianAngle = (float)((double)radianAngle - Math.PI * 2);
            }
            final float[] m2 = new float[6];
            float fx = -x2;
            float fy = -y2;
            float cos = cosLU[(int)((double)radianAngle / 0.05609986881410345)];
            float cos1 = cos - 1.0f;
            float sin = sinLU[(int)((double)radianAngle / 0.05609986881410345)];
            m2[0] = cos;
            m2[1] = sin;
            m2[2] = -sin;
            m2[3] = cos;
            m2[4] = cos1 * fx - sin * fy;
            m2[5] = sin * fx + cos1 * fy;
            new GLESRenderer.RendererTask(target, "multMatrix"){

                public void render() {
                    GLESAffiner.nativeMultMatrix(nativeHandler, m2);
                }
            };
        }
    }

    public static void resetAffine(GLESRenderTarget target, final long nativeHandler) {
        new GLESRenderer.RendererTask(target, "loadIdentityMatrix"){

            public void render() {
                GLESAffiner.nativeLoadIdentityMatrix(nativeHandler);
            }
        };
    }

    private static final native void nativePrintln(long var0);

    private static final native void nativeMultMatrix(long var0, float[] var2);

    private static final native void nativeLoadIdentityMatrix(long var0);

    public static void initSinCosLookupTable() {
        double angleRadians = 0.0;
        while ((int)(17.82535362629228 * angleRadians) < sinLU.length) {
            int i2 = (int)(angleRadians / 0.05609986881410345);
            float cos = (float)Math.cos(angleRadians);
            float sin = (float)Math.sin(angleRadians);
            GLESAffiner.cosLU[i2] = cos;
            GLESAffiner.sinLU[i2] = sin;
            angleRadians += 0.05609986881410345;
        }
    }
}

