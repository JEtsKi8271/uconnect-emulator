/*
 * Decompiled with CFR 0.152.
 */
package com.wirelesscar.ngtp.svc.api;

import com.wirelesscar.ngtp.svc.api.PersonName;
import com.wirelesscar.ngtp.svc.api.Phone;
import com.wirelesscar.ngtp.svc.api.PostalAddress;
import com.wirelesscar.ngtp.svc.api.StringAttribute;
import com.wirelesscar.ngtp.svc.api.Waypoint;
import java.util.Vector;

public class PointOfInterest {
    private String a;
    private String b;
    private String c;
    private PersonName d;
    private String e;
    private PostalAddress f;
    private Phone g;
    private Phone h;
    private Phone i;
    private Phone j;
    private String k;
    private String l;
    private Waypoint m;
    private Boolean n;
    private String o;
    private Vector p;

    public PointOfInterest(String string, String string2, String string3, PersonName personName, String string4, PostalAddress postalAddress, Phone phone, Phone phone2, Phone phone3, Phone phone4, String string5, String string6, Waypoint waypoint, Boolean bl2, String string7) {
        this.a = string;
        this.b = string2;
        this.c = string3;
        this.d = personName;
        this.e = string4;
        this.f = postalAddress;
        this.g = phone;
        this.h = phone2;
        this.i = phone3;
        this.j = phone4;
        this.k = string5;
        this.l = string6;
        this.m = waypoint;
        this.n = bl2;
        this.o = string7;
    }

    public String getSubject() {
        return this.a;
    }

    public String getCategory() {
        return this.b;
    }

    public String getFreetext() {
        return this.c;
    }

    public PersonName getName() {
        return this.d;
    }

    public String getOrganization() {
        return this.e;
    }

    public PostalAddress getAddress() {
        return this.f;
    }

    public Phone getPhone1() {
        return this.g;
    }

    public Phone getPhone2() {
        return this.h;
    }

    public Phone getPhone3() {
        return this.i;
    }

    public Phone getPhone4() {
        return this.j;
    }

    public String getUrl() {
        return this.k;
    }

    public String getEmail() {
        return this.l;
    }

    public Waypoint getGeoCoordinates() {
        return this.m;
    }

    public Boolean getUseAsDestination() {
        return this.n;
    }

    public String getEnhPOIurl() {
        return this.o;
    }

    public StringAttribute[] getPOIAttributes() {
        Object[] objectArray = null;
        if (this.p != null) {
            objectArray = new StringAttribute[this.p.size()];
            this.p.copyInto(objectArray);
        }
        return objectArray;
    }

    public void addPOIAttribute(String string, String string2) {
        if (this.p == null) {
            this.p = new Vector();
        }
        this.p.addElement(new StringAttribute(string, string2));
    }

    public String toString() {
        return "PointOfInterestImpl [subject=" + this.a + ", category=" + this.b + ", freetext=" + this.c + ", name=" + this.d + ", organization=" + this.e + ", address=" + this.f + ", phone1=" + this.g + ", phone2=" + this.h + ", phone3=" + this.i + ", phone4=" + this.j + ", url=" + this.k + ", email=" + this.l + ", geoCoordinates=" + this.m + ", useAsDestination=" + this.n + ", enhPOIurl=" + this.o + "]";
    }
}

