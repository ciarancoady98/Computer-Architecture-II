package com.company;
import java.util.LinkedList;

public class Cache {

    int L; //the line size of the cache
    int N; //the number of sets (rows) in the cache
    int K; //how many tags there are per cache line (k-way associative)
    int offsetBits; //how many bits are being used as the offset
    int numberOfSetsBits; //how many bits are being used to identify sets
    int offsetMask; //the mask used to extract the offset into the cache line
    int setMask; //the mask used to extract the set number from address
    LinkedList[] cache; //datastructure used to store the cache
    int numberOfHits;
    int numberOfMisses;

    Cache(int L, int N, int K){
        this.L = L;
        this.N = N;
        this.K = K;
        this.cache = new LinkedList[N];
        for(int i = 0; i < N; i++) {
            this.cache[i] = new LinkedList<Integer>();
        }
        this.offsetBits = (int) (Math.log(L) / Math.log(2));
        this.numberOfSetsBits = (int) (Math.log(N) / Math.log(2));
        this.offsetMask = getMask(0, offsetBits);
        this.setMask = getMask(offsetBits, (numberOfSetsBits+offsetBits));
        this.numberOfHits = 0;
        this.numberOfMisses = 0;
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
    boolean inCache(int address){
        //Addresses are 16bit hex representations
        int offset = address & this.offsetMask;
        int setNumber = (address & this.setMask) >> this.offsetBits;
        int addressTag = address >>> (this.offsetBits+this.numberOfSetsBits);
        //System.out.println("addressTag: " + addressTag + " setNumber: " + setNumber + " offset: " + offset);
        if(this.cache[setNumber].contains(addressTag)){
            this.cache[setNumber].remove((Object)addressTag);
            this.cache[setNumber].addFirst(addressTag);
            this.numberOfHits++;
            return true;
        }
        else {
            insert(addressTag,setNumber);
            this.numberOfMisses++;
            return false;
        }
    }

    /*
    Takes an address and a set and inserts that address
    in the set
     */
    void insert(int tag, int set){
        if(this.cache[set].size() == this.K){
            evict(set);
        }
        this.cache[set].addFirst(tag);
    }

    /*
    Removes the least recently used tag from a specific set
     */
    void evict(int set){
        this.cache[set].removeLast();
    }
}
