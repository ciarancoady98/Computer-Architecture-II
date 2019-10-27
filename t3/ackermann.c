#include <stdio.h>

int WUSED;
int NWINDOWS;
int CWP;
int SWP;
int proceedureCalls;
int numberOfOverflows;
int numberOfUnderflows;

void resetGlobalVars(){
    WUSED = 2;
    NWINDOWS = 0;
    CWP = 0;
    SWP = 0;
    proceedureCalls = 0;
    numberOfOverflows = 0;
    numberOfUnderflows = 0;
}

//Called before a function call
void overflowCheck(){
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

//Driver program
int main( int argc, const char* argv[] ) {
    //Test ackermann(3,6) with 6 register sets
    printf("--------------------------------------------------------------\n");
    resetGlobalVars();
    NWINDOWS = 6;
    overflowCheck();
    int result = ackermann(3, 6);
    printf( "The result from ackermann(3,6) is %d\n"
            "Given a RISC-I processor with %d register sets\n"
            "Maximum register window depth %d\n"
            "Number of register window Overflows %d\n"
            "Number of register window Underflows %d\n"
            , result, NWINDOWS, proceedureCalls, numberOfOverflows, numberOfUnderflows);

    //Test ackermann(3,6) with 8 register sets
    printf("--------------------------------------------------------------\n");
    resetGlobalVars();
    NWINDOWS = 8;
    overflowCheck();
    result = ackermann(3, 6);
    printf( "The result from ackermann(3,6) is %d\n"
            "Given a RISC-I processor with %d register sets\n"
            "Maximum register window depth %d\n"
            "Number of register window Overflows %d\n"
            "Number of register window Underflows %d\n"
            , result, NWINDOWS, proceedureCalls, numberOfOverflows, numberOfUnderflows);

    //Test ackermann(3,6) with 16 register sets
    printf("--------------------------------------------------------------\n");
    resetGlobalVars();
    NWINDOWS = 16;
    overflowCheck();
    result = ackermann(3, 6);
    printf( "The result from ackermann(3,6) is %d\n"
            "Given a RISC-I processor with %d register sets\n"
            "Maximum register window depth %d\n"
            "Number of register window Overflows %d\n"
            "Number of register window Underflows %d\n"
            , result, NWINDOWS, proceedureCalls, numberOfOverflows, numberOfUnderflows);
    printf("--------------------------------------------------------------\n");
}