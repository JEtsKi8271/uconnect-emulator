/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.a.b;

import com.wirelesscar.ngtp.svc.a.b.ab;
import com.wirelesscar.ngtp.svc.a.b.ae;
import com.wirelesscar.ngtp.svc.a.b.af;
import com.wirelesscar.ngtp.svc.a.b.ai;
import com.wirelesscar.ngtp.svc.a.b.ap;
import com.wirelesscar.ngtp.svc.a.b.av;
import com.wirelesscar.ngtp.svc.a.b.bf;
import com.wirelesscar.ngtp.svc.a.b.bo;
import com.wirelesscar.ngtp.svc.a.b.cf;
import com.wirelesscar.ngtp.svc.a.b.ck;
import com.wirelesscar.ngtp.svc.a.b.g;
import com.wirelesscar.ngtp.svc.a.b.k;
import com.wirelesscar.ngtp.svc.a.b.m;

public final class ca
extends m {
    public ca() {
        this.a_(12);
    }

    public final bf b() throws ai {
        switch (bf2.a) {
            case 0: {
                bf bf2 = new cf();
                break;
            }
            case 1: {
                bf bf2 = new av();
                bf2.b(0L, 65535L);
                break;
            }
            case 2: {
                bf bf2 = new ck();
                bf2.b(0L, 65535L);
                break;
            }
            case 3: {
                bf bf2 = new bo();
                bf2.b(0L, 0xFFFFFFFFL);
                break;
            }
            case 4: {
                bf bf2 = new bo();
                bf2.b(0L, 65535L);
                break;
            }
            case 5: {
                bf bf2 = new bo();
                bf2.b(0L, 255L);
                break;
            }
            case 6: {
                bf bf2 = new g();
                break;
            }
            case 7: {
                bf bf2 = new af();
                break;
            }
            case 8: {
                bf bf2 = new ab();
                break;
            }
            case 9: {
                bf bf2 = new k();
                break;
            }
            case 10: {
                bf bf2 = new ap();
                bf2.b(1L, 32L);
                break;
            }
            case 11: {
                bf bf2 = new ae();
                break;
            }
            default: {
                throw new ai("Undefined Choice value ( " + bf2.a + " ) in type GenericParameterValue", 0);
            }
        }
        return bf2;
    }
}

