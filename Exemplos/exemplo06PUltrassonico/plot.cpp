#include <iostream>

#include <cstdio> 
#include <cstdlib> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h>
#include <getopt.h>

#include <pangolin/pangolin.h>

#define PORT        2508 
#define MAXLINE     1024

#define MAXDIST     500 // Escala máxima da distância (mm)
#define MAXPOT      100 // Escala máxima da potência (%)

using namespace std;

static const char short_options[] = "f:p";
static const struct option long_options[] = {
	{ "file",           required_argument,  0, 'f' },
  { "print",            0,                0,  0  },
  {       0,            0,                0,  0  }
};

static void usage(char **argv)
{
        cerr << "Uso: "<<argv[0]<<" <options>"<<endl<<endl<<
                "Options:"<<endl<<
                "-f | --file nome do arquivo para guardar os valores lidos"<<endl<<
                "-p | --print imprime os valores recebidos"<<endl<<endl;

}

int main(int argc, char* argv[])
{
  int sockfd; 
  char buffer[MAXLINE]; 
  struct sockaddr_in servaddr, cliaddr; 
  bool print = false;
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
        case 'p':
          print = true;
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
      
  int n, acontador; 
  socklen_t len;
  float lsensor, lpotencia, lproporci;

  // Create OpenGL window in single line
  pangolin::CreateWindowAndBind("Main",640,480);

  // Data logger object
  pangolin::DataLog sensor, potencia;

  // Optionally add named labels
  std::vector<std::string> labelSensor;
  labelSensor.push_back(std::string("distancia (mm)"));
  std::vector<std::string> labelPotencia;
  labelPotencia.push_back(std::string("potencia (%)"));

  
  sensor.SetLabels(labelSensor);
  potencia.SetLabels(labelPotencia);

  const float tinc = 0.02f;

  // OpenGL 'view' of data. We might have many views of the same data.
  pangolin::Plotter plotterleft(&sensor, 0.0f, 4.0f*(float)M_PI/tinc, 0, MAXDIST , 
    (float)M_PI/(4.0f*tinc),0.5f);
  plotterleft.SetBounds(0.0, 1.0, 0.0, 1.0);
  plotterleft.Track("$i");

  pangolin::Plotter plotterright(&potencia, 0.0f, 4.0f*(float)M_PI/tinc, -MAXPOT, MAXPOT, 
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
    meuarquivo << "// Contador Distancia Potencia Proporcional" << endl;
    meuarquivo << arquivoPontos << " = [" << endl;
  }

  // Default hooks for exiting (ESC) and fullscreen (TAB).
  while(!pangolin::ShouldQuit()){
    n = recvfrom(sockfd, (char *)buffer, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr, &len); 
    buffer[n] = '\0';
    
    if(print){
      printf("%s\n", buffer);
    }
    
    char* token = strtok(buffer, " "); 
    acontador   = strtol(token, NULL, 10);
    token       = strtok(NULL, " "); 
    lsensor     = strtof(token, NULL);
    token       = strtok(NULL, " "); 
    lpotencia   = strtof(token, NULL);
    token       = strtok(NULL, " ");
    lproporci   = strtof(token, NULL);
      
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    sensor.Log(lsensor);
    potencia.Log(lpotencia);
    t += tinc;

    meuarquivo << acontador << " " << lsensor << " " << lpotencia << " " << lproporci << ";" << endl;

    // Render graph, Swap frames and Process Events
    pangolin::FinishFrame();
  }

  if(meuarquivo.is_open()){
    meuarquivo << "];" << endl;
    meuarquivo.close();
  }
  
  return 0;
}
