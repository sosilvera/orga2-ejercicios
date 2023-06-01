#include "lib.h"

int dummy(){ return 0; }

funcCmp_t* getCompareFunction(type_t t) {
    switch (t) {
        case TypeNone:     return (funcCmp_t*)&dummy; break;
        case TypeInt:      return (funcCmp_t*)&intCmp; break;
        case TypeFloat:    return (funcCmp_t*)&floatCmp; break;
        case TypeString:   return (funcCmp_t*)&strCmp; break;
        case TypeDocument: return 0; break;
        default: break;
    }
    return 0;
}

funcClone_t* getCloneFunction(type_t t) {
    switch (t) {
        case TypeNone:     return (funcClone_t*)&dummy; break;
        case TypeInt:      return (funcClone_t*)&intClone; break;
        case TypeFloat:    return (funcClone_t*)&floatClone; break;
        case TypeString:   return (funcClone_t*)&strClone; break;
        case TypeDocument: return 0; break;
        default: break;
    }
    return 0;
}

funcDelete_t* getDeleteFunction(type_t t) {
    switch (t) {
        case TypeNone:     return (funcDelete_t*)&dummy; break;
        case TypeInt:      return (funcDelete_t*)&intDelete; break;
        case TypeFloat:    return (funcDelete_t*)&floatDelete; break;
        case TypeString:   return (funcDelete_t*)&strDelete; break;
        case TypeDocument: return 0; break;
        default: break;
    }
    return 0;
}

funcPrint_t* getPrintFunction(type_t t) {
    switch (t) {
        case TypeNone:     return (funcPrint_t*)&dummy; break;
        case TypeInt:      return (funcPrint_t*)&intPrint; break;
        case TypeFloat:    return (funcPrint_t*)&floatPrint; break;
        case TypeString:   return (funcPrint_t*)&strPrint; break;
        case TypeDocument: return 0; break;
        default: break;
    }
    return 0;
}

/** Int **/

int32_t intCmp(int32_t* a, int32_t* b){
    if(*a < *b) return 1;
    if(*a > *b) return -1;
    return 0;
}
int32_t* intClone(int32_t* a){
    int32_t* n = (int32_t*)malloc(sizeof(int32_t));
    *n = *a;
    return n;
}
void intDelete(int32_t* a){
    free(a);
}
void intPrint(int32_t* a, FILE *pFile){
    fprintf(pFile, "%i", *a);
}

/** Lista **/

list_t* listNew(type_t t){
    list_t* l = malloc(sizeof(list_t));
    l->type = t;
    l->first = 0;
    l->last = 0;
    l->size = 0;
    return l;
}
void listAddLast(list_t* l, void* data){
    listElem_t* n = malloc(sizeof(listElem_t));
    l->size = l->size + 1;
    n->data = data;
    n->next = 0;
    n->prev = l->last;
    if(l->last == 0)
        l->first = n;
    else
        l->last->next = n;
    l->last = n;
}

void listRemove(list_t* l, void* data){
    listElem_t* n = malloc(sizeof(listElem_t));
    n = l->first;
    funcCmp_t* lcompare = getCompareFunction(l->type);

    while(n->next != NULL){
        if(lcompare(n->data, data) == 0){
            listElem_t* aux = malloc(sizeof(listElem_t));
            aux = n->next;
            aux->prev = n->prev;
            aux = n->prev;
            aux->next = n->next;
            free(n);
            n = aux->next;
        }else{
            n = n->next;
        }
    }
}

list_t* listClone(list_t* l) {
    funcClone_t* fn = getCloneFunction(l->type);
    list_t* lclone = listNew(l->type);
    listElem_t* current = l->first;
    while(current!=0) {
        void* dclone = fn(current->data);
        listAddLast(lclone, dclone);
        current = current->next;
    }
    return lclone;
}
void listDelete(list_t* l){
    funcDelete_t* fd = getDeleteFunction(l->type);
    listElem_t* current = l->first;
    while(current!=0) {
        listElem_t* tmp = current;
        current =  current->next;
        if(fd!=0) fd(tmp->data);
        free(tmp);
    }
    free(l);
}
void listPrint(list_t* l, FILE *pFile) {
    funcPrint_t* fp = getPrintFunction(l->type);
    fprintf(pFile, "[");
    listElem_t* current = l->first;
    if(current==0) {
        fprintf(pFile, "]");
        return;
    }
    while(current!=0) {
        if(fp!=0)
            fp(current->data, pFile);
        else
            fprintf(pFile, "%p",current->data);
        current = current->next;
        if(current==0)
            fprintf(pFile, "]");
        else
            fprintf(pFile, ",");
    }
}
