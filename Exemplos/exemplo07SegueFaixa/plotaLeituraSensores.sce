exec(get_absolute_file_path('plotaLeituraSensores.sce')+'circuloGiroLeft.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'circuloGiroRight.sce', 0);
exec(get_absolute_file_path('plotaLeituraSensores.sce')+'pistaAngulada.sce', 0);


scf(1001)
clf()
subplot(1,2,1);
plot2d(circuloGiroLeft(1000:2110,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo na pista circular sentido anti-horário"
xgrid(1, 1, 7);

subplot(1,2,2);
plot2d(circuloGiroLeft(1000:2110,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito na pista circular sentido anti-horário"
xgrid(1, 1, 7);

scf(1002)
clf()
subplot(1,2,1);
plot2d(circuloGiroRight(1:1400,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo na pista circular sentido horário"
xgrid(1, 1, 7);

subplot(1,2,2);
plot2d(circuloGiroRight(1:1400,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito na pista circular sentido horário"
xgrid(1, 1, 7);

scf(1003)
clf()
subplot(1,2,1);
plot2d(pistaAngulada(1:630,1:3), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor esquerdo na pista angulada"
xgrid(1, 1, 7);

subplot(1,2,2);
plot2d(pistaAngulada(1:630,4:6), style=[5, 3, 2] )
a=gca(); 
a.data_bounds(3) = 0
a.data_bounds(4) = 100
p = get("hdl")
p.parent.title.text = "Sensor direito na pista angulada"
xgrid(1, 1, 7);
