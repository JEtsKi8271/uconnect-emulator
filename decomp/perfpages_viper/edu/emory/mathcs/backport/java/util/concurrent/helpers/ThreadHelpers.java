/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.helpers;

public class ThreadHelpers {
    private ThreadHelpers() {
    }

    public static Runnable assignExceptionHandler(final Runnable runnable, final UncaughtExceptionHandler uncaughtExceptionHandler) {
        if (runnable == null || uncaughtExceptionHandler == null) {
            throw new NullPointerException();
        }
        return new Runnable(){

            @Override
            public void run() {
                try {
                    runnable.run();
                }
                catch (Throwable throwable) {
                    try {
                        uncaughtExceptionHandler.uncaughtException(Thread.currentThread(), throwable);
                    }
                    catch (Throwable throwable2) {
                        // empty catch block
                    }
                }
            }
        };
    }

    public static interface UncaughtExceptionHandler {
        public void uncaughtException(Thread var1, Throwable var2);
    }
}

