#include <stdio.h>

int WUSED = 0;
int NWINDOWS = 0;
int CWP = 0;
int SWP = 0;

//Called before a function call
void overflowCheck(){
    if(WUSED == NWINDOWS){
        //overflowTrapHandler();
        printf("an overflow has occured");
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
        printf("an underflow has occured");
    }
    else {
        WUSED--;
    }
    CWP--;
}


int ackermann(int x, int y){
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
    //Allocating a register set for the main program
    WUSED = 1;
    //Test ackermann(3,6) with 6 register sets
    NWINDOWS = 6;
    overflowCheck();
    int result = ackermann(3, 6);
    printf("The result is %d",result);
}