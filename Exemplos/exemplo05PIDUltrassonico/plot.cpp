#include <iostream>

#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h>
#include <getopt.h>

#include <pangolin/pangolin.h>

#define PORT        2508 
#define MAXLINE     1024

using namespace std;

static const char short_options[] = "f:";
static const struct option long_options[] = {
	{ "file",           required_argument,  NULL, 'f' },
  { 0, 	                              0,	   0,  0  }
};

static void usage(char **argv)
{
        cerr << "Uso: "<<argv[0]<<" <options>"<<endl<<endl<<
                "Options:"<<endl<<
                "-f | --file nome do arquivo para guardar os valores lidos"<<endl<<endl;
}

int main(int argc, char* argv[])
{
  int sockfd; 
  char buffer[MAXLINE]; 
  struct sockaddr_in servaddr, cliaddr; 
  string  arquivoPontos;
  std::ofstream meuarquivo;
      
  for (;;) {
        int idx;
        int c;

        c = getopt_long(argc, argv, short_options, long_options, &idx);

        if (-1 == c)
            break;

        switch (c) {
        case 0: // getopt_long() flag
            break;
        case 'f':
            arquivoPontos = optarg;
            break;
		    default:
			    usage(argv);
			    exit(EXIT_FAILURE);
		}
	}

  // Creating socket file descriptor 
  if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) { 
      perror("socket creation failed"); 
      exit(EXIT_FAILURE); 
  } 
      
  memset(&servaddr, 0, sizeof(servaddr)); 
  memset(&cliaddr, 0, sizeof(cliaddr)); 
      
  // Filling server information 
  servaddr.sin_family       = AF_INET; // IPv4 
  servaddr.sin_addr.s_addr  = INADDR_ANY; 
  servaddr.sin_port         = htons(PORT); 
      
  // Bind the socket with the server address 
  if ( bind(sockfd, (const struct sockaddr *)&servaddr, sizeof(servaddr)) < 0 ){ 
    perror("bind failed"); 
    exit(EXIT_FAILURE); 
  } 
      
  int n, contador=-1, acontador; 
  socklen_t len;
  float ltop, lbotton;

  // Create OpenGL window in single line
  pangolin::CreateWindowAndBind("Main",640,480);

  // Data logger object
  pangolin::DataLog logtop, logbotton;

  // Optionally add named labels
  std::vector<std::string> labels;
  labels.push_back(std::string("distancia"));
  
  logtop.SetLabels(labels);
  logbotton.SetLabels(labels);

  const float tinc = 0.02f;

  // OpenGL 'view' of data. We might have many views of the same data.
  pangolin::Plotter plotterleft(&logtop, 0.0f, 4.0f*(float)M_PI/tinc, 0, 1000, 
    (float)M_PI/(4.0f*tinc),0.5f);
  plotterleft.SetBounds(0.0, 1.0, 0.0, 1.0);
  plotterleft.Track("$i");

  pangolin::Plotter plotterright(&logbotton, 0.0f, 4.0f*(float)M_PI/tinc, 0, 1000, 
    (float)M_PI/(4.0f*tinc),0.5f);
  plotterright.SetBounds(0.0, 1.0, 0.0, 1.0);
  plotterright.Track("$i");

  pangolin::DisplayBase()
    .SetLayout(pangolin::LayoutEqual)
    .AddDisplay(plotterleft)
    .AddDisplay(plotterright);

  float t = 0;

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  pangolin::FinishFrame();

  if(!arquivoPontos.empty()){    
    meuarquivo.open(arquivoPontos+".sce");
    meuarquivo << "// Top Botton" << endl;
    meuarquivo << arquivoPontos << " = [" << endl;
  }

  // Default hooks for exiting (Esc) and fullscreen (tab).
  while(!pangolin::ShouldQuit()){
    n = recvfrom(sockfd, (char *)buffer, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr, &len); 
    buffer[n] = '\0'; 
    char* token = strtok(buffer, " "); 
    acontador = strtol(token, NULL, 10);
    if(acontador>contador){
      contador = acontador;
      token   = strtok(NULL, " "); 
         
      ltop    = strtof(token, NULL);
      
      token   = strtok(NULL, " "); 
      lbotton = strtof(token, NULL);
      
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

      logtop.Log(ltop);
      logbotton.Log(lbotton);
      t += tinc;

      meuarquivo << ltop << " " << lbotton << ";" << endl;

      // Render graph, Swap frames and Process Events
      pangolin::FinishFrame();
    }
  }

  if(meuarquivo.is_open()){
    meuarquivo << "];" << endl;
    meuarquivo.close();
  }
  return 0;
}
