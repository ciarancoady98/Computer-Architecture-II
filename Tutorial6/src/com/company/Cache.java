package com.company;

public class Cache {
    /*
    This object represents a cache where:
    L = the line size of the cache
    N = the number of sets (rows) in the cache
    K = how many tags there are per cache line (k-way associative)
     */

    int L;
    int N;
    int K;
    int[][] cache;

    Cache(int L, int N, int K){
        this.L = L;
        this.N = N;
        this.K = K;
        this.cache = new int[N][K+L];
    }

    /*
    Takes a memory address and maps it onto a set
     */
    int map(){
        return -1;
    }

    void insert(){

    }

    void evict(){

    }
}
