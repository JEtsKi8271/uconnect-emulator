/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent;

import java.io.InvalidObjectException;
import java.io.ObjectStreamException;
import java.io.Serializable;

public abstract class TimeUnit
implements Serializable {
    public static final TimeUnit NANOSECONDS = new TimeUnit(0, "NANOSECONDS"){
        private static final long serialVersionUID = 535148490883208361L;

        @Override
        public long toNanos(long l2) {
            return l2;
        }

        @Override
        public long toMicros(long l2) {
            return l2 / 1000L;
        }

        @Override
        public long toMillis(long l2) {
            return l2 / 1000000L;
        }

        @Override
        public long toSeconds(long l2) {
            return l2 / 1000000000L;
        }

        @Override
        public long toMinutes(long l2) {
            return l2 / 60000000000L;
        }

        @Override
        public long toHours(long l2) {
            return l2 / 3600000000000L;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 86400000000000L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toNanos(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return (int)(l2 - l3 * 1000000L);
        }
    };
    public static final TimeUnit MICROSECONDS = new TimeUnit(1, "MICROSECONDS"){
        private static final long serialVersionUID = 2185906575929579108L;

        @Override
        public long toNanos(long l2) {
            return 2.x(l2, 1000L, 9223372036854775L);
        }

        @Override
        public long toMicros(long l2) {
            return l2;
        }

        @Override
        public long toMillis(long l2) {
            return l2 / 1000L;
        }

        @Override
        public long toSeconds(long l2) {
            return l2 / 1000000L;
        }

        @Override
        public long toMinutes(long l2) {
            return l2 / 60000000L;
        }

        @Override
        public long toHours(long l2) {
            return l2 / 3600000000L;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 86400000000L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toMicros(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return (int)(l2 * 1000L - l3 * 1000000L);
        }
    };
    public static final TimeUnit MILLISECONDS = new TimeUnit(2, "MILLISECONDS"){
        private static final long serialVersionUID = 9032047794123325184L;

        @Override
        public long toNanos(long l2) {
            return 3.x(l2, 1000000L, 9223372036854L);
        }

        @Override
        public long toMicros(long l2) {
            return 3.x(l2, 1000L, 9223372036854775L);
        }

        @Override
        public long toMillis(long l2) {
            return l2;
        }

        @Override
        public long toSeconds(long l2) {
            return l2 / 1000L;
        }

        @Override
        public long toMinutes(long l2) {
            return l2 / 60000L;
        }

        @Override
        public long toHours(long l2) {
            return l2 / 3600000L;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 86400000L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toMillis(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return 0;
        }
    };
    public static final TimeUnit SECONDS = new TimeUnit(3, "SECONDS"){
        private static final long serialVersionUID = 227755028449378390L;

        @Override
        public long toNanos(long l2) {
            return 4.x(l2, 1000000000L, 9223372036L);
        }

        @Override
        public long toMicros(long l2) {
            return 4.x(l2, 1000000L, 9223372036854L);
        }

        @Override
        public long toMillis(long l2) {
            return 4.x(l2, 1000L, 9223372036854775L);
        }

        @Override
        public long toSeconds(long l2) {
            return l2;
        }

        @Override
        public long toMinutes(long l2) {
            return l2 / 60L;
        }

        @Override
        public long toHours(long l2) {
            return l2 / 3600L;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 86400L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toSeconds(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return 0;
        }
    };
    public static final TimeUnit MINUTES = new TimeUnit(4, "MINUTES"){
        private static final long serialVersionUID = 1827351566402609187L;

        @Override
        public long toNanos(long l2) {
            return 5.x(l2, 60000000000L, 153722867L);
        }

        @Override
        public long toMicros(long l2) {
            return 5.x(l2, 60000000L, 153722867280L);
        }

        @Override
        public long toMillis(long l2) {
            return 5.x(l2, 60000L, 153722867280912L);
        }

        @Override
        public long toSeconds(long l2) {
            return 5.x(l2, 60L, 0x222222222222222L);
        }

        @Override
        public long toMinutes(long l2) {
            return l2;
        }

        @Override
        public long toHours(long l2) {
            return l2 / 60L;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 1440L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toMinutes(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return 0;
        }
    };
    public static final TimeUnit HOURS = new TimeUnit(5, "HOURS"){
        private static final long serialVersionUID = -6438436134732089810L;

        @Override
        public long toNanos(long l2) {
            return 6.x(l2, 3600000000000L, 2562047L);
        }

        @Override
        public long toMicros(long l2) {
            return 6.x(l2, 3600000000L, 2562047788L);
        }

        @Override
        public long toMillis(long l2) {
            return 6.x(l2, 3600000L, 2562047788015L);
        }

        @Override
        public long toSeconds(long l2) {
            return 6.x(l2, 3600L, 2562047788015215L);
        }

        @Override
        public long toMinutes(long l2) {
            return 6.x(l2, 60L, 0x222222222222222L);
        }

        @Override
        public long toHours(long l2) {
            return l2;
        }

        @Override
        public long toDays(long l2) {
            return l2 / 24L;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toHours(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return 0;
        }
    };
    public static final TimeUnit DAYS = new TimeUnit(6, "DAYS"){
        private static final long serialVersionUID = 567463171959674600L;

        @Override
        public long toNanos(long l2) {
            return 7.x(l2, 86400000000000L, 106751L);
        }

        @Override
        public long toMicros(long l2) {
            return 7.x(l2, 86400000000L, 106751991L);
        }

        @Override
        public long toMillis(long l2) {
            return 7.x(l2, 86400000L, 106751991167L);
        }

        @Override
        public long toSeconds(long l2) {
            return 7.x(l2, 86400L, 106751991167300L);
        }

        @Override
        public long toMinutes(long l2) {
            return 7.x(l2, 1440L, 0x16C16C16C16C16L);
        }

        @Override
        public long toHours(long l2) {
            return 7.x(l2, 24L, 0x555555555555555L);
        }

        @Override
        public long toDays(long l2) {
            return l2;
        }

        @Override
        public long convert(long l2, TimeUnit timeUnit) {
            return timeUnit.toDays(l2);
        }

        @Override
        int excessNanos(long l2, long l3) {
            return 0;
        }
    };
    private static final TimeUnit[] values = new TimeUnit[]{NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS};
    private final int index;
    private final String name;
    static final long C0 = 1L;
    static final long C1 = 1000L;
    static final long C2 = 1000000L;
    static final long C3 = 1000000000L;
    static final long C4 = 60000000000L;
    static final long C5 = 3600000000000L;
    static final long C6 = 86400000000000L;
    static final long MAX = Long.MAX_VALUE;

    public static TimeUnit[] values() {
        return (TimeUnit[])values.clone();
    }

    public static TimeUnit valueOf(String string) {
        for (int i2 = 0; i2 < values.length; ++i2) {
            if (!TimeUnit.values[i2].name.equals(string)) continue;
            return values[i2];
        }
        throw new IllegalArgumentException("No enum const TimeUnit." + string);
    }

    TimeUnit(int n2, String string) {
        this.index = n2;
        this.name = string;
    }

    static long x(long l2, long l3, long l4) {
        if (l2 > l4) {
            return Long.MAX_VALUE;
        }
        if (l2 < -l4) {
            return Long.MIN_VALUE;
        }
        return l2 * l3;
    }

    public abstract long convert(long var1, TimeUnit var3);

    public abstract long toNanos(long var1);

    public abstract long toMicros(long var1);

    public abstract long toMillis(long var1);

    public abstract long toSeconds(long var1);

    public abstract long toMinutes(long var1);

    public abstract long toHours(long var1);

    public abstract long toDays(long var1);

    abstract int excessNanos(long var1, long var3);

    public String name() {
        return this.name;
    }

    public int ordinal() {
        return this.index;
    }

    protected Object readResolve() throws ObjectStreamException {
        try {
            return TimeUnit.valueOf(this.name);
        }
        catch (IllegalArgumentException illegalArgumentException) {
            throw new InvalidObjectException(this.name + " is not a valid enum for TimeUnit");
        }
    }

    public void timedWait(Object object, long l2) throws InterruptedException {
        if (l2 > 0L) {
            long l3 = this.toMillis(l2);
            int n2 = this.excessNanos(l2, l3);
            object.wait(l3, n2);
        }
    }

    public void timedJoin(Thread thread, long l2) throws InterruptedException {
        if (l2 > 0L) {
            long l3 = this.toMillis(l2);
            int n2 = this.excessNanos(l2, l3);
            thread.join(l3, n2);
        }
    }

    public void sleep(long l2) throws InterruptedException {
        if (l2 > 0L) {
            long l3 = this.toMillis(l2);
            int n2 = this.excessNanos(l2, l3);
            Thread.sleep(l3, n2);
        }
    }

    public String toString() {
        return this.name;
    }
}

