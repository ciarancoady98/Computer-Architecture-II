package com.company;

import java.util.Date;
import java.util.HashMap;

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
    int offsetBits;
    int numberOfSetsBits;
    int offsetMask;
    int setMask;
    HashMap[] cache;

    Cache(int L, int N, int K){
        this.L = L;
        this.N = N;
        this.K = K;
        this.cache = new HashMap[N];
        for(int i = 0; i < N; i++) {
            this.cache[i] = new HashMap<Integer, Date>();
        }
        this.offsetBits = (int) (Math.log(L) / Math.log(2));
        this.numberOfSetsBits = (int) (Math.log(N) / Math.log(2));
        this.offsetMask = getMask(0, offsetBits);
        this.setMask = getMask(offsetBits, (numberOfSetsBits+offsetBits));
    }

    /*
    Creates masks that can be used to isolate the desired portion of a passed address
     */
    int getMask(int startBit, int endBit){
        int numberOfBitsToSet = endBit - startBit;
        int mask = 0;
        for(int i = 0; i < endBit; i++){
            mask = mask << 1;
            if(numberOfBitsToSet > 0) {
                mask = mask | 1;
                numberOfBitsToSet--;
            }
        }
        return mask;
    }

    /*
    Takes a memory address and if it is in the cache returns its value
    otherwise it returns -1 to signify a miss
     */
    int getValue(int address){
        //Addresses are 16bit hex representations
        int offset = address & this.offsetMask;
        int setNumber = (address & this.setMask) >> this.offsetBits;
        System.out.println("offset: " + offset + " setNumber: " + setNumber);
        //bit shift offset out of addr
        //bit shift setNumber out of addr
        //result is addr in hash map as int
        return -1;
    }

    /*
    Takes a memory address and maps it onto a set
     */
    int mapToSet(){
        return -1;
    }

    /*
    Takes an address and a set and inserts that address
    in the set
     */
    void insert(int tag){

    }

    /*
    Removes the least recently used tag from a specific set
     */
    void evict(int set){

    }
}
