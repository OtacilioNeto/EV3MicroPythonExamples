#include <iostream>

#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h>

#include <pangolin/pangolin.h>

#define PORT        2508 
#define MAXLINE     1024

int main(int argc, char* argv[])
{

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
  if ( bind(sockfd, (const struct sockaddr *)&servaddr, sizeof(servaddr)) < 0 ){ 
    perror("bind failed"); 
    exit(EXIT_FAILURE); 
  } 
      
  int n, contador=-1, acontador; 
  socklen_t len;
  float lr, lg, lb, rr, rg, rb;

  // Create OpenGL window in single line
  pangolin::CreateWindowAndBind("Main",640,480);

  // Data logger object
  pangolin::DataLog logleft, logright;

  // Optionally add named labels
  std::vector<std::string> labels;
  labels.push_back(std::string("red"));
  labels.push_back(std::string("green"));
  labels.push_back(std::string("blue"));
  logleft.SetLabels(labels);
  logright.SetLabels(labels);

  const float tinc = 0.02f;

  // OpenGL 'view' of data. We might have many views of the same data.
  pangolin::Plotter plotterleft(&logleft, 0.0f, 4.0f*(float)M_PI/tinc, 0, 100, (float)M_PI/(4.0f*tinc),0.5f);
  plotterleft.SetBounds(0.0, 1.0, 0.0, 1.0);
  plotterleft.Track("$i");

  pangolin::Plotter plotterright(&logright, 0.0f, 4.0f*(float)M_PI/tinc, 0, 100, (float)M_PI/(4.0f*tinc),0.5f);
  plotterright.SetBounds(0.0, 1.0, 0.0, 1.0);
  plotterright.Track("$i");

  /*pangolin::View& d_cam1 = pangolin::Display("sensor left")
    .SetAspect(640.0f/480.0f)
    .SetHandler(plotter);*/

  pangolin::DisplayBase()
    .SetLayout(pangolin::LayoutEqual)
    .AddDisplay(plotterleft)
    .AddDisplay(plotterright);

  float t = 0;

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  pangolin::FinishFrame();

  // Default hooks for exiting (Esc) and fullscreen (tab).
  while(!pangolin::ShouldQuit()){
    n = recvfrom(sockfd, (char *)buffer, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr, &len); 
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

      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

      logleft.Log(lr, lg, lb);
      logright.Log(rr, rg, rb);
      t += tinc;

      // Render graph, Swap frames and Process Events
      pangolin::FinishFrame();
    }
  }

  return 0;
}
