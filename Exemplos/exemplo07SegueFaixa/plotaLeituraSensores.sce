exec(get_absolute_file_path('plotaLeituraSensores.sce')+'circuloGiroLeft.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'circuloGiroRight.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'pistaAngulada.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'turnRight.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'turnLeft.sce', 0);

MAXNUMBER=780

scf(1001)
clf()
subplot(2,2,1);
plot2d(circuloGiroLeft(1:MAXNUMBER,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0;
a.data_bounds(4) = 100;
p = get("hdl");
p.parent.title.text = "Sensor esquerdo na pista circular sentido anti-horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red   = abs(fft(circuloGiroLeft(1:MAXNUMBER, 1)))(2:MAXNUMBER/2);
green = abs(fft(circuloGiroLeft(1:MAXNUMBER, 2)))(2:MAXNUMBER/2);
blue  = abs(fft(circuloGiroLeft(1:MAXNUMBER, 3)))(2:MAXNUMBER/2);
subplot(2,2,3);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor esquerdo na pista circular sentido anti-horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

subplot(2,2,2);
plot2d(circuloGiroLeft(1:MAXNUMBER,4:6), style=[5, 3, 2] );
a=gca(); 
a.data_bounds(3) = 0;
a.data_bounds(4) = 100;
p = get("hdl");
p.parent.title.text = "Sensor direito na pista circular sentido anti-horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(circuloGiroLeft(1:MAXNUMBER, 4)))(2:MAXNUMBER/2);
green=abs(fft(circuloGiroLeft(1:MAXNUMBER, 5)))(2:MAXNUMBER/2);
blue=abs(fft(circuloGiroLeft(1:MAXNUMBER, 6)))(2:MAXNUMBER/2);
subplot(2,2,4);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor direito na pista circular sentido anti-horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

//#################################################################

scf(1002);
clf();
subplot(2,2,1);
plot2d(circuloGiroRight(1:MAXNUMBER,1:3), style=[5, 3, 2] );
a=gca(); 
a.data_bounds(3) = 0;
a.data_bounds(4) = 100;
p = get("hdl");
p.parent.title.text = "Sensor esquerdo na pista circular sentido horário";
xgrid(1, 1, 7);

red=abs(fft(circuloGiroRight(1:MAXNUMBER, 1)))(2:MAXNUMBER/2);
green=abs(fft(circuloGiroRight(1:MAXNUMBER, 2)))(2:MAXNUMBER/2);
blue=abs(fft(circuloGiroRight(1:MAXNUMBER, 3)))(2:MAXNUMBER/2);
subplot(2,2,3);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor esquerdo na pista circular sentido horário";
xgrid(1, 1, 7);

subplot(2,2,2);
plot2d(circuloGiroRight(1:MAXNUMBER,4:6), style=[5, 3, 2] );
a=gca(); 
a.data_bounds(3) = 0;
a.data_bounds(4) = 100;
p = get("hdl");
p.parent.title.text = "Sensor direito na pista circular sentido horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(circuloGiroRight(1:MAXNUMBER, 4)))(2:MAXNUMBER/2);
green=abs(fft(circuloGiroRight(1:MAXNUMBER, 5)))(2:MAXNUMBER/2);
blue=abs(fft(circuloGiroRight(1:MAXNUMBER, 6)))(2:MAXNUMBER/2);
subplot(2,2,4);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor direito na pista circular sentido horário";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);


//###########################################################################


scf(1003)
clf()
subplot(2,2,1);
plot2d(pistaAngulada(1:MAXNUMBER,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo na pista angulada"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(pistaAngulada(1:MAXNUMBER, 1)))(2:MAXNUMBER/2);
green=abs(fft(pistaAngulada(1:MAXNUMBER, 2)))(2:MAXNUMBER/2);
blue=abs(fft(pistaAngulada(1:MAXNUMBER, 3)))(2:MAXNUMBER/2);
subplot(2,2,3);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor esquerdo na pista angulada";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);


subplot(2,2,2);
plot2d(pistaAngulada(1:MAXNUMBER,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito na pista angulada";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(pistaAngulada(1:MAXNUMBER, 4)))(2:MAXNUMBER/2);
green=abs(fft(pistaAngulada(1:MAXNUMBER, 5)))(2:MAXNUMBER/2);
blue=abs(fft(pistaAngulada(1:MAXNUMBER, 6)))(2:MAXNUMBER/2);
subplot(2,2,4);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor direito na pista angulada";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

//##############################################################################

scf(1004)
clf()
subplot(2,2,1);
plot2d(turnRight(1:MAXNUMBER,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo vira direita";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(turnRight(1:MAXNUMBER, 1)))(2:MAXNUMBER/2);
green=abs(fft(turnRight(1:MAXNUMBER, 2)))(2:MAXNUMBER/2);
blue=abs(fft(turnRight(1:MAXNUMBER, 3)))(2:MAXNUMBER/2);
subplot(2,2,3);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor esquerdo vira direita";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);


subplot(2,2,2);
plot2d(turnRight(1:MAXNUMBER,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito vira direita";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(turnRight(1:MAXNUMBER, 4)))(2:MAXNUMBER/2);
green=abs(fft(turnRight(1:MAXNUMBER, 5)))(2:MAXNUMBER/2);
blue=abs(fft(turnRight(1:MAXNUMBER, 6)))(2:MAXNUMBER/2);
subplot(2,2,4);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor direito vira direita";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

//##############################################################################

scf(1005)
clf()
subplot(2,2,1);
plot2d(turnLeft(1:MAXNUMBER,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo vira esquerda";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(turnLeft(1:MAXNUMBER, 1)))(2:MAXNUMBER/2);
green=abs(fft(turnLeft(1:MAXNUMBER, 2)))(2:MAXNUMBER/2);
blue=abs(fft(turnLeft(1:MAXNUMBER, 3)))(2:MAXNUMBER/2);
subplot(2,2,3);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor esquerdo vira esquerda";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);


subplot(2,2,2);
plot2d(turnLeft(1:MAXNUMBER,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito vira esquerda";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);

red=abs(fft(turnLeft(1:MAXNUMBER, 4)))(2:MAXNUMBER/2);
green=abs(fft(turnLeft(1:MAXNUMBER, 5)))(2:MAXNUMBER/2);
blue=abs(fft(turnLeft(1:MAXNUMBER, 6)))(2:MAXNUMBER/2);
subplot(2,2,4);
plot2d([red, green, blue], style=[5, 3, 2] );
a=gca();
a.data_bounds(3) = 0;
a.data_bounds(4) = 1600;
p = get("hdl");
p.parent.title.text = "FFT-Sensor direito vira esquerda";
p.parent.title.font_size = 4;
p.parent.font_size = 4;
xgrid(1, 1, 7);
