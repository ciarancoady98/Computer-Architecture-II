package com.company;

public class Main {

    public static void main(String[] args) {
        testInstructions(new Cache(16,8,1));
        testInstructions(new Cache(16,4,2));
        testInstructions(new Cache(16,2,4));
        testInstructions(new Cache(16,1,8));
    }

    public static void testInstructions(Cache cache){
        cache.inCache(0x0000);
        cache.inCache(0x0004);
        cache.inCache(0x000C);
        cache.inCache(0x2200);
        cache.inCache(0x00D0);
        cache.inCache(0x00E0);
        cache.inCache(0x1130);
        cache.inCache(0x0028);
        cache.inCache(0x113C);
        cache.inCache(0x2204);
        cache.inCache(0x0010);
        cache.inCache(0x0020);
        cache.inCache(0x0004);
        cache.inCache(0x0040);
        cache.inCache(0x2208);
        cache.inCache(0x0008);
        cache.inCache(0x00A0);
        cache.inCache(0x0004);
        cache.inCache(0x1104);
        cache.inCache(0x0028);
        cache.inCache(0x000C);
        cache.inCache(0x0084);
        cache.inCache(0x000C);
        cache.inCache(0x3390);
        cache.inCache(0x00B0);
        cache.inCache(0x1100);
        cache.inCache(0x0028);
        cache.inCache(0x0064);
        cache.inCache(0x0070);
        cache.inCache(0x00D0);
        cache.inCache(0x0008);
        cache.inCache(0x3394);
        System.out.println("----------------------------------------------------------------------");
        System.out.println("Test Results for a Cache with K = " + cache.K + ", N = " + cache.N + ", L = " + cache.L + ":" +
                "\nNumber of Hits: " + cache.numberOfHits + "\nNumber Of Misses: " + cache.numberOfMisses);
        System.out.println("----------------------------------------------------------------------");
    }
}
