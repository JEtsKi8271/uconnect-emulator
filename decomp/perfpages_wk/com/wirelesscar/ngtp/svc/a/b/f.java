/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ae;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.aq;
import com.wirelesscar.ngtp.svc.a.b.av;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.ch;
import com.wirelesscar.ngtp.svc.a.b.g;
import com.wirelesscar.ngtp.svc.a.b.m;

public final class f
extends m {
    public f() {
        this.a_(21);
    }

    public final bf b() throws ai {
        switch (bf2.a) {
            case 0: {
                bf bf2 = new ae();
                break;
            }
            case 1: {
                bf bf2 = new ae();
                break;
            }
            case 2: {
                bf bf2 = new aq();
                break;
            }
            case 3: {
                bf bf2 = new g();
                break;
            }
            case 4: {
                bf bf2 = new av();
                bf2.b(0L, 1024L);
                break;
            }
            case 5: {
                bf bf2 = new bo();
                bf2.b(1L, 1000000L);
                break;
            }
            case 6: {
                bf bf2 = new bo();
                bf2.b(0L, 255L);
                break;
            }
            case 7: {
                bf bf2 = new bo();
                bf2.b(0L, 86400L);
                break;
            }
            case 8: {
                bf bf2 = new ae();
                break;
            }
            case 9: {
                bf bf2 = new ae();
                break;
            }
            case 10: {
                bf bf2 = new ae();
                break;
            }
            case 11: {
                bf bf2 = new ae();
                break;
            }
            case 12: {
                bf bf2 = new ch();
                break;
            }
            case 13: {
                bf bf2 = new ae();
                break;
            }
            case 14: {
                bf bf2 = new ae();
                break;
            }
            case 15: {
                bf bf2 = new bo();
                bf2.b(0L, 100L);
                break;
            }
            case 16: {
                bf bf2 = new bo();
                bf2.b(0L, 100L);
                break;
            }
            case 17: {
                bf bf2 = new bo();
                bf2.b(-100L, 100L);
                break;
            }
            case 18: {
                bf bf2 = new bo();
                bf2.b(-100L, 100L);
                break;
            }
            case 19: {
                bf bf2 = new bo();
                bf2.b(-100L, 100L);
                break;
            }
            case 20: {
                bf bf2 = new bo();
                bf2.b(-100L, 100L);
                break;
            }
            default: {
                throw new ai("Undefined Choice value ( " + bf2.a + " ) in type RemoteOperationTrigger", 0);
            }
        }
        return bf2;
    }

    public final void c() throws ai {
        if (this.a != 0 || this.b == null) {
            this.a(0);
        }
    }

    public final void d() throws ai {
        if (this.a != 1 || this.b == null) {
            this.a(1);
        }
    }

    public final g e() throws ai {
        if (this.a != 3 || this.b == null) {
            throw new ai("The ASNChoice is not of the requested type", 0);
        }
        return (g)this.b;
    }

    public final void a(g g2) {
        this.a = 3;
        this.b = g2;
    }
}

