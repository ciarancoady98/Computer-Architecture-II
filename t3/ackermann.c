#include <stdio.h>

int WUSED = 0;
int NWINDOWS = 0;
int CWP = 0;
int SWP = 0;

//Called before a function call
void overflowCheck(){
    if(WUSED == NWINDOWS){
        //overflowTrapHandler();
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
    }
    else {
        WUSED--;
    }
    CWP--;
}


int ackermann(int x, int y){
    if(x==0){
        return y+1;
    }
    else if(y==0){
        return ackermann(x-1, 1);
    }
    else {
        return ackermann(x-1, ackermann(x,y-1));
    }
}

int main( int argc, const char* argv[] ) {
    //Driver program

    int result = ackermann(3, 6);
    printf("The result is %d",result);
}