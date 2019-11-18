package com.company;

public class Main {

    public static void main(String[] args) {
	// write your code here
        Cache myCache = new Cache(16,8,1);
        myCache.inCache(0x0000);
        myCache.inCache(0x0004);
        myCache.inCache(0x000C);
        myCache.inCache(0x2200);
        myCache.inCache(0x00D0);
        myCache.inCache(0x00E0);
        myCache.inCache(0x1130);
        myCache.inCache(0x0028);
        myCache.inCache(0x113C);
        myCache.inCache(0x2204);
        myCache.inCache(0x0010);
        myCache.inCache(0x0020);
        myCache.inCache(0x0004);
        myCache.inCache(0x0040);
        myCache.inCache(0x2208);
        myCache.inCache(0x0008);
        myCache.inCache(0x00A0);
        myCache.inCache(0x0004);
        myCache.inCache(0x1104);
        myCache.inCache(0x0028);
        myCache.inCache(0x000C);
        myCache.inCache(0x0084);
        myCache.inCache(0x000C);
        myCache.inCache(0x3390);
        myCache.inCache(0x00B0);
        myCache.inCache(0x1100);
        myCache.inCache(0x0028);
        myCache.inCache(0x0064);
        myCache.inCache(0x0070);
        myCache.inCache(0x00D0);
        myCache.inCache(0x0008);
        myCache.inCache(0x3394);
        System.out.println("Number Of Misses: " + myCache.numberOfMisses + " Number of Hits: " + myCache.numberOfHits);
    }
}
