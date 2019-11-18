package com.company;

public class Main {

    public static void main(String[] args) {
	// write your code here
        Cache myCache = new Cache(16,8,1);
        myCache.getValue(0x0000);
        myCache.getValue(0x0004);
        myCache.getValue(0x0028);
    }
}
