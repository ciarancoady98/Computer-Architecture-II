//
// t3.cpp
//

#include "stdafx.h"

//
// Ackermann function
//
// Copyright (C) 2012 - 2017 jones@scss.tcd.ie
//
// 10/06/14 Ubuntu/linux version
// 28/11/15 added a second method for calculating overflows and underflows
// 02/06/17 VS2017
//

//
// Intel64 family 6 model 94 stepping 3 Intel(R) Xeon(R) CPU E3-1270 v5 @ 3.60GHz
//
// ackermann(3, 6) = 509, calls = 172233 and depth max = 511 (doesn't include main)
//
// ackermann(3, 6) execution time VS2017        0.13ms
// ackermann(3, 6) execution time gcc 5.2.1     0.07ms
//
// NWINDOWS             overflows/underflows
//
//   6                      84,855
//   8                      83,911
//  16                      80,142
//

#include "stdafx.h"         // pre-compiled headers
#include "time.h"           // clock()
#include <iostream>         // cout
#include <iomanip>          // setprecision

#ifdef _WIN32
#include "windows.h"        // QueryPerfomanceCounter
#include "conio.h"          // _getch()
#endif

using namespace std;        // cout, endl, ...

#define N       100000      //

#define METHOD  0           // method

int nwindows;               // global variables
int calls;                  //
int depth;                  //
int depthMax;               //
int overflows;              //
int underflows;             //

//
// ackermann
//
inline int ackermann(int x, int y) {
    if (x == 0) {
        return y + 1;
    } else if (y == 0) {
        return ackermann(x - 1, 1);
    } else {
        return ackermann(x - 1, ackermann(x, y - 1));
    }
}

//
// instrumented ackermann version
//

int wused;              // valid register windows

void enter() {
    calls++;
    depth++;
    if (depth > depthMax)
        depthMax = depth;
    if (wused == nwindows) {
        overflows++;
    } else {
        wused++;
    }
}

void exit() {
    depth--;
    if (wused == 2) {   // always need 2 valid windows
        underflows++;
    } else {
        wused--;
    }
}

int ackermannX(int x, int y) {
    int r;
    enter();
    if (x == 0) {
        r = y + 1;
    } else if (y == 0) {
        r = ackermannX(x - 1, 1);
    } else {
        r = ackermannX(x - 1, ackermannX(x, y - 1));
    }
    exit();
    return r;
}

//
// run
//
void run(int _nwindows) {
    nwindows = _nwindows;           // set number of register windows
    calls = 0;
    depth = depthMax = 0;
    overflows = underflows = 0;
    wused = 2;                      // ALWAYS need two valid windows
    int v = ackermannX(3, 6);
    cout << "ackerman(3, 6) = " << v << ", calls = " << calls << ", max depth = " << depthMax << endl << "nwindows = " << nwindows << ", overflows = " << overflows << ", underflows = " << underflows << endl;
    if (overflows != underflows)
        cout << "ERROR: overflows = " << overflows << " underflows = " << underflows << " (should be equal)" << endl;
    cout << endl;
}

//
// main
//
int main() {

    run(6);
    run(8);
    run(16);

    //
    // Since the runtime for ackermann(3, 6) is less than one millisecond, which happens to be the granularity
    // of clock(), the strategy is to execute ackermann(3, 6) N times and divide the execution time by N.
    //
    // The problem is that the complier realises that there's no point in executing ackermann(3, 6) N times and
    // optimisesaway the loop.
    //
    // To stop this, a volatile variable three is passed to ackermann() which makes the compiler generate
    // code to execute ackermann(three, 6) N times.
    //
    // There must be an easier way to do this!
    //
    int v = 0;
    volatile int three = 3;         // trickery: see below
    cout << "starting..." << endl;
    int t = clock();                // 1ms accuracy
    for (int i = 0; i < N; i++)
        v = ackermann(three, 6);    // trickery: stop compiler from optimizing this to a single call
    t = clock() - t;
    cout << "ackermann(3, 6) = " << v << endl;
    cout << "execution time per call = " << fixed << setprecision(2) << (double)t * 1000.0 / CLOCKS_PER_SEC / N << "ms" << endl;


#ifdef _WIN32   
    
    __int64 start, end, ticks = 0;

    for (int i = 0; i < N; i++) {
        QueryPerformanceCounter((LARGE_INTEGER*) &start);
        v = ackermann(three, 6);
        QueryPerformanceCounter((LARGE_INTEGER*) &end);
        ticks += end - start;
    }
    _int64 freq;
    QueryPerformanceFrequency((LARGE_INTEGER *)&freq);
    cout << "ackermann(3, 6) = " << v << endl;
    cout << "execution time per call = " << fixed << setprecision(2) << ticks * 1000.0 / freq / N << "ms" << endl;


#endif



#ifdef _WIN32
    _getch();                       // stop DOS window disappearing
#endif

    return 0;

}

// eof
