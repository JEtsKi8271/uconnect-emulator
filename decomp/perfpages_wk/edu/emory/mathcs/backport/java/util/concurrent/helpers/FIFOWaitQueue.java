/*
 * Decompiled with CFR 0.152.
 */
package edu.emory.mathcs.backport.java.util.concurrent.helpers;

import edu.emory.mathcs.backport.java.util.concurrent.helpers.WaitQueue;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

public class FIFOWaitQueue
extends WaitQueue
implements Serializable {
    private static final long serialVersionUID = 2416444691925378811L;
    protected transient WaitQueue.WaitNode head_ = null;
    protected transient WaitQueue.WaitNode tail_ = null;

    @Override
    public void insert(WaitQueue.WaitNode waitNode) {
        if (this.tail_ == null) {
            this.head_ = this.tail_ = waitNode;
        } else {
            this.tail_.next = waitNode;
            this.tail_ = waitNode;
        }
    }

    @Override
    public WaitQueue.WaitNode extract() {
        if (this.head_ == null) {
            return null;
        }
        WaitQueue.WaitNode waitNode = this.head_;
        this.head_ = waitNode.next;
        if (this.head_ == null) {
            this.tail_ = null;
        }
        waitNode.next = null;
        return waitNode;
    }

    @Override
    public void putBack(WaitQueue.WaitNode waitNode) {
        waitNode.next = this.head_;
        this.head_ = waitNode;
        if (this.tail_ == null) {
            this.tail_ = waitNode;
        }
    }

    @Override
    public boolean hasNodes() {
        return this.head_ != null;
    }

    @Override
    public int getLength() {
        int n2 = 0;
        WaitQueue.WaitNode waitNode = this.head_;
        while (waitNode != null) {
            if (waitNode.waiting) {
                ++n2;
            }
            waitNode = waitNode.next;
        }
        return n2;
    }

    @Override
    public Collection getWaitingThreads() {
        ArrayList<Thread> arrayList = new ArrayList<Thread>();
        boolean bl2 = false;
        WaitQueue.WaitNode waitNode = this.head_;
        while (waitNode != null) {
            if (waitNode.waiting) {
                arrayList.add(waitNode.owner);
            }
            waitNode = waitNode.next;
        }
        return arrayList;
    }

    @Override
    public boolean isWaiting(Thread thread) {
        if (thread == null) {
            throw new NullPointerException();
        }
        WaitQueue.WaitNode waitNode = this.head_;
        while (waitNode != null) {
            if (waitNode.waiting && waitNode.owner == thread) {
                return true;
            }
            waitNode = waitNode.next;
        }
        return false;
    }
}

