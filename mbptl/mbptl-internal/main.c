#include<stdio.h>
#include<stdlib.h>
#include<string.h>

// gcc main.c -o main -no-pie -fno-pic -fno-stack-protector -z execstack

void __secret(){
        system("/bin/bash");
}

void __init__(){
        setvbuf(stdin,0,2,0);
        setvbuf(stdout,0,2,0);
}

int main(){
        __init__();

        char buff[128];

        printf("=== [ MBPTL INTERNAL SERVICE ] ===\n");
        printf("[>] Name: ");
        gets(buff);
        printf("[*] Welcome, %s!\n", &buff);
        return 0;
}
