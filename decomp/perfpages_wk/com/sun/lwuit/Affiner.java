/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.sun.lwuit.Graphics
 *  java.awt.GLESGraphics2D
 *  java.awt.GLESRenderTarget
 */
package com.sun.lwuit;

import com.aicas.GLESAffiner;
import com.sun.lwuit.Graphics;
import java.awt.GLESGraphics2D;
import java.awt.GLESRenderTarget;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

public class Affiner {
    private static final int BUFFER_SIZE = 4096;
    private static boolean _lib_loaded_ = false;
    GLESRenderTarget target_;
    long nativeHandler_;
    private static HashMap<Graphics, Affiner> createdAffiners = new HashMap();

    public static Affiner getInstance(Graphics g2) {
        Affiner result = createdAffiners.get(g2);
        if (result == null) {
            result = new Affiner(g2);
            createdAffiners.put(g2, result);
        }
        return result;
    }

    private void loadLibrary(String name) {
        String mappedName = System.mapLibraryName(name);
        String tmpDir = System.getProperty("java.io.tmpdir", "/tmp");
        File f2 = new File(tmpDir + File.separator + mappedName);
        InputStream inStream = Affiner.class.getClassLoader().getResourceAsStream(mappedName);
        FileOutputStream outStream = null;
        try {
            outStream = new FileOutputStream(f2);
            int read = 0;
            byte[] buffer = new byte[4096];
            while ((read = inStream.read(buffer)) != -1) {
                ((OutputStream)outStream).write(buffer, 0, read);
            }
            ((OutputStream)outStream).close();
        }
        catch (FileNotFoundException e2) {
            e2.printStackTrace();
        }
        catch (IOException e3) {
            e3.printStackTrace();
        }
        System.load(f2.getAbsolutePath());
    }

    public Affiner(Graphics g2) {
        if (!_lib_loaded_) {
            this.loadLibrary("Affiner");
            _lib_loaded_ = true;
        }
        GLESAffiner.initSinCosLookupTable();
        GLESGraphics2D nativeGraphics = (GLESGraphics2D)g2.getGraphics();
        try {
            Field field = GLESGraphics2D.class.getDeclaredField("target");
            field.setAccessible(true);
            Object object = field.get(nativeGraphics);
            this.target_ = (GLESRenderTarget)object;
            Class[] noArgsClass = new Class[]{};
            Method m2 = GLESRenderTarget.class.getDeclaredMethod("getNativeHandler", noArgsClass);
            m2.setAccessible(true);
            Object[] noArgsObject = new Object[]{};
            this.nativeHandler_ = (Long)m2.invoke(object, noArgsObject);
        }
        catch (SecurityException e2) {
            e2.printStackTrace();
        }
        catch (NoSuchFieldException e3) {
            e3.printStackTrace();
        }
        catch (IllegalArgumentException e4) {
            e4.printStackTrace();
        }
        catch (IllegalAccessException e5) {
            e5.printStackTrace();
        }
        catch (InvocationTargetException e6) {
            e6.printStackTrace();
        }
        catch (NoSuchMethodException e7) {
            e7.printStackTrace();
        }
    }

    public void translate(int x2, int y2) {
        GLESAffiner.translate(this.target_, this.nativeHandler_, x2, y2);
    }

    public void rotate(float angle) {
        GLESAffiner.rotate(this.target_, this.nativeHandler_, angle);
    }

    public void rotate(float angle, int x2, int y2) {
        GLESAffiner.rotate(this.target_, this.nativeHandler_, angle, x2, y2);
    }

    public void resetAffine() {
        GLESAffiner.resetAffine(this.target_, this.nativeHandler_);
    }
}

