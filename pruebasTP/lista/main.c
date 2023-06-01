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

    char *a, *b, *c;
    list_t* l1;
    FILE* pfile=fopen("salida.caso.1.txt","w");
    char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};

    // listAdd
    fprintf(pfile,"==> listAdd\n");
    l1 = listNew(TypeString);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]));

    listPrint(l1,pfile); 
    fprintf(pfile,"\n");

    // listDelete(l1);

    l1 = listNew(TypeString);

    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]));
    
    listPrint(l1,pfile); 
    fprintf(pfile,"\n");
    // listDelete(l1);

    listRemove(l1, strings[1]);
    listRemove(l1, strings[2]);

    listPrint(l1,pfile); 
    fprintf(pfile,"\n");
    
    listRemove(l1, "PRIMERO");
    listRemove(l1, "ULTIMO");

    listPrint(l1,pfile); 
    fprintf(pfile,"\n");
    
    fclose(pfile);
    
	return 0;
}