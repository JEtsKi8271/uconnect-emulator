/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.helpers;

import edu.emory.mathcs.backport.java.util.Arrays;
import edu.emory.mathcs.backport.java.util.concurrent.TimeUnit;
import edu.emory.mathcs.backport.java.util.concurrent.helpers.NanoTimer;
import edu.emory.mathcs.backport.java.util.concurrent.locks.Condition;
import java.lang.reflect.Array;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.Collection;
import java.util.Iterator;

public final class Utils {
    private static final NanoTimer nanoTimer;
    private static final String providerProp = "edu.emory.mathcs.backport.java.util.concurrent.NanoTimerProvider";

    private Utils() {
    }

    public static long nanoTime() {
        return nanoTimer.nanoTime();
    }

    public static long awaitNanos(Condition condition, long l2) throws InterruptedException {
        if (l2 <= 0L) {
            return l2;
        }
        long l3 = Utils.nanoTime();
        condition.await(l2, TimeUnit.NANOSECONDS);
        return l2 - (Utils.nanoTime() - l3);
    }

    private static long gcd(long l2, long l3) {
        while (l3 > 0L) {
            long l4 = l2 % l3;
            l2 = l3;
            l3 = l4;
        }
        return l2;
    }

    public static Object[] collectionToArray(Collection collection) {
        int n2 = collection.size();
        Object[] objectArray = new Object[n2];
        Iterator iterator = collection.iterator();
        int n3 = 0;
        while (true) {
            if (n3 < n2 && iterator.hasNext()) {
                objectArray[n3++] = iterator.next();
                continue;
            }
            if (!iterator.hasNext()) {
                if (n3 == n2) {
                    return objectArray;
                }
                return Arrays.copyOf(objectArray, n3, Object[].class);
            }
            int n4 = (objectArray.length / 2 + 1) * 3;
            if (n4 < objectArray.length) {
                if (objectArray.length < Integer.MAX_VALUE) {
                    n4 = Integer.MAX_VALUE;
                } else {
                    throw new OutOfMemoryError("required array size too large");
                }
            }
            objectArray = Arrays.copyOf(objectArray, n4, Object[].class);
            n2 = n4;
        }
    }

    public static Object[] collectionToArray(Collection collection, Object[] objectArray) {
        Class<?> clazz = objectArray.getClass();
        int n2 = collection.size();
        Object[] objectArray2 = objectArray.length >= n2 ? objectArray : (Object[])Array.newInstance(clazz.getComponentType(), n2);
        Iterator iterator = collection.iterator();
        int n3 = 0;
        while (true) {
            if (n3 < n2 && iterator.hasNext()) {
                objectArray2[n3++] = iterator.next();
                continue;
            }
            if (!iterator.hasNext()) {
                if (n3 == n2) {
                    return objectArray2;
                }
                if (objectArray2 == objectArray) {
                    objectArray[n3] = null;
                    return objectArray;
                }
                return Arrays.copyOf(objectArray2, n3, clazz);
            }
            int n4 = (objectArray2.length / 2 + 1) * 3;
            if (n4 < objectArray2.length) {
                if (objectArray2.length < Integer.MAX_VALUE) {
                    n4 = Integer.MAX_VALUE;
                } else {
                    throw new OutOfMemoryError("required array size too large");
                }
            }
            objectArray2 = Arrays.copyOf(objectArray2, n4, clazz);
            n2 = n4;
        }
    }

    static {
        NanoTimer nanoTimer = null;
        try {
            String string = (String)AccessController.doPrivileged(new PrivilegedAction(){

                public Object run() {
                    return System.getProperty(Utils.providerProp);
                }
            });
            if (string != null) {
                Class<?> clazz = Class.forName(string);
                nanoTimer = (NanoTimer)clazz.newInstance();
            }
        }
        catch (Exception exception) {
            System.err.println("WARNING: unable to load the system-property-defined nanotime provider; switching to the default");
            exception.printStackTrace();
        }
        if (nanoTimer == null) {
            nanoTimer = new MillisProvider();
        }
        Utils.nanoTimer = nanoTimer;
    }

    private static final class MillisProvider
    implements NanoTimer {
        MillisProvider() {
        }

        @Override
        public long nanoTime() {
            return System.currentTimeMillis() * 1000000L;
        }
    }
}

