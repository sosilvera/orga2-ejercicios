#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>

#include "lib.h"


int main(int argc, char const *argv[]){

    FILE* pfile=fopen("salida.caso.1.txt","w");
    // fprintf(pfile,"===== Tree\n");
   
    tree_t* t;
    
    int intA;
    int intB;
    int intC;
    float floatA;
    float floatB;
    float floatC;
    float floatD;
    float floatE;

    t = treeNew(TypeInt, TypeFloat, 1);
    intA = 12; 
    floatA=6.2f; 
    printf("%d ", treeInsert(t, &intA, &floatA));

    intB = 28; 
    floatB=4.4f; 
    printf("%d ", treeInsert(t, &intB, &floatB)); 
    
    floatC=1.4f; 
    printf("%d ", treeInsert(t, &intA, &floatC));
    
    intC = 83; 
    floatD=1.2f; 
    printf("%d ", treeInsert(t, &intC, &floatD)); 
    
    floatE=5.4f; 
    printf("%d ", treeInsert(t, &intC, &floatE));

    treePrint(t, pfile);
    fclose(pfile);

	return 0;
}