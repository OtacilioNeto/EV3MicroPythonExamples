
// Server side implementation of UDP client-server model 
#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 
  
#define PORT        2508 
#define MAXLINE     1024 
  
// Driver code 
int main() { 
    int sockfd; 
    char buffer[MAXLINE]; 
    struct sockaddr_in servaddr, cliaddr; 
      
    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) { 
        perror("socket creation failed"); 
        exit(EXIT_FAILURE); 
    } 
      
    memset(&servaddr, 0, sizeof(servaddr)); 
    memset(&cliaddr, 0, sizeof(cliaddr)); 
      
    // Filling server information 
    servaddr.sin_family    = AF_INET; // IPv4 
    servaddr.sin_addr.s_addr = INADDR_ANY; 
    servaddr.sin_port = htons(PORT); 
      
    // Bind the socket with the server address 
    if ( bind(sockfd, (const struct sockaddr *)&servaddr,  
            sizeof(servaddr)) < 0 ) 
    { 
        perror("bind failed"); 
        exit(EXIT_FAILURE); 
    } 
      
    int len, n, contador=-1, acontador; 
    float lr, lg, lb, rr, rg, rb;
    while(1){
        n = recvfrom(sockfd, (char *)buffer, MAXLINE,  
                MSG_WAITALL, ( struct sockaddr *) &cliaddr, 
                &len); 
        buffer[n] = '\0'; 
        char* token = strtok(buffer, " "); 
        acontador = strtol(token, NULL, 10);
        if(acontador>contador){
            contador = acontador;
            token = strtok(NULL, " "); 
         
            lr    = strtof(token, NULL);
            token = strtok(NULL, " "); 
            lg    = strtof(token, NULL);
            token = strtok(NULL, " "); 
            lb    = strtof(token, NULL);

            token = strtok(NULL, " "); 
            rr    = strtof(token, NULL);
            token = strtok(NULL, " "); 
            rg    = strtof(token, NULL);
            token = strtok(NULL, " "); 
            rb    = strtof(token, NULL);

            printf("%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f\n", lr, lg, lb, rr, rg, rb);
        }
    }
      
    return 0; 
} 

