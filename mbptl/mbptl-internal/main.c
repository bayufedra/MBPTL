#include<stdio.h>
#include<stdlib.h>
#include<string.h>

// gcc main.c -o main -no-pie -fno-pic -fno-stack-protector -z execstack

void __secret(){
        system("/bin/sh");
}

void __init__(){
        setvbuf(stdin,0,2,0);
        setvbuf(stdout,0,2,0);
}

int main(){
        __init__();

        char flag15[128];
        char buff[128];

        flag15 = "MBPTL-15{cb4ca713115bfa8691b8577187a747e0}";

        printf("=== [ MBPTL INTERNAL SERVICE ] ===\n");
        printf("[!] Flag 16: MBPTL-16{1fb837a73ba131c382cc9bc53d4442f0}\n");
        printf("[>] Name: ");
        gets(buff);
        printf("[*] Welcome, %s!\n", &buff);
        return 0;
}
