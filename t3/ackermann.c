#include <stdio.h>
#include <time.h>

int WUSED;
int NWINDOWS;
int CWP;
int SWP;
int proceedureCalls;
int numberOfOverflows;
int numberOfUnderflows;
int registerWindowDepth;
int maxRegisterWindowDepth;

void resetGlobalVars(){
    WUSED = 2; //there is always 2 valid register windows in the register file
    NWINDOWS = 0;
    CWP = 0;
    SWP = 0;
    proceedureCalls = 0;
    numberOfOverflows = 0;
    numberOfUnderflows = 0;
    registerWindowDepth = 0;
    maxRegisterWindowDepth = 0;
}

//Called before a function call
void overflowCheck(){
    registerWindowDepth++;
    if(registerWindowDepth > maxRegisterWindowDepth)
        maxRegisterWindowDepth = registerWindowDepth;
    if(WUSED == NWINDOWS){
        //overflowTrapHandler();
        numberOfOverflows++;
        SWP++;
    }
    else {
        WUSED++;
    }
    CWP++;
}

//Called before a function return
void underflowCheck(){
    registerWindowDepth--;
    if(WUSED == 2){
        SWP--;
        //underflowTrapHandler();
        numberOfUnderflows++;
    }
    else {
        WUSED--;
    }
    CWP--;
}


int ackermann(int x, int y){
    proceedureCalls++;
    if(x==0){
        underflowCheck();
        return y+1;
    }
    else if(y==0){
        overflowCheck();
        int result = ackermann(x-1, 1);
        underflowCheck();
        return result;
    }
    else {
        overflowCheck();
        int result1 = ackermann(x,y-1);
        overflowCheck();
        int result2 = ackermann(x-1, result1);
        underflowCheck();
        return result2;
    }
}

void testAckermann(int a, int b, int numberOfWindows){
    printf("--------------------------------------------------------------\n");
    resetGlobalVars();
    NWINDOWS = numberOfWindows;
    overflowCheck();
    clock_t begin = clock();
    int result = ackermann(a, b);
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf( "The result from ackermann(%d,%d) is %d\n"
            "Given a RISC-I processor with %d register sets\n"
            "Number of proceedure calls %d\n"
            "Maximum register window depth %d\n"
            "Number of register window Overflows %d\n"
            "Number of register window Underflows %d\n"
            "Execution time %fs\n"
            , a, b, result, numberOfWindows, proceedureCalls, maxRegisterWindowDepth, numberOfOverflows, numberOfUnderflows, time_spent);
    printf("--------------------------------------------------------------\n");
}

void timeAckerman(int numberOfRuns, int a, int b){
    printf("--------------------------------------------------------------\n");
    if(numberOfRuns > 0){
        double totalTimeSpent = 0;
        for(int i = 0; i < numberOfRuns; i++){
            clock_t begin = clock();
            ackermann(a, b);
            clock_t end = clock();
            double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
            totalTimeSpent += time_spent;
        }
        double averageTimeSpent  = totalTimeSpent / numberOfRuns;
        printf("The average run time of ackermann(3,6) is : %fs\n", averageTimeSpent);
    }
    else 
        printf("please enter a positive number of runs, higher numbers yield more accurate results\n");
    printf("--------------------------------------------------------------\n");
}

//Driver program
int main( int argc, const char* argv[] ) {
    //Test ackermann(3,6) with 6 register sets
    testAckermann(3, 6, 6);
    //Test ackermann(3,6) with 8 register sets
    testAckermann(3, 6, 8);
    //Test ackermann(3,6) with 16 register sets
    testAckermann(3, 6, 16);
    //Get the average time it takes for ackerman(3,6) to run
    timeAckerman(10000, 3, 6);
}