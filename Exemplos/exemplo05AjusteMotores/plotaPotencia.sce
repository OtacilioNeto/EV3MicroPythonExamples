funcprot(0)
clc

function ret=MinimosQuadrados(Y, X)
    n = size(X)(1)
    
    ret(1) = (n*X'*Y - sum(X)*sum(Y)) / (n*sum(X^2) - sum(X)^2)
    ret(2) = mean(Y) - ret(1)*mean(X)
    
endfunction

exec(get_absolute_file_path('plotaPotencia.sce')+'datalog.sce', 0);

scf(1001)
clf()
// subplot(3,2,1);
plot2d(datalog(:,1), datalog(:,2:3), leg="Motor Esquerdo@Motor Direito", style=[-3, -2])
p = get("hdl")
p.children(1).mark_size=3;
p.children(2).mark_size=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs. Percentual da potência máxima"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

// Vamos fazer a regressão linear pelo método dos mínimos quadrados

Y=datalog(:,2); 
X=datalog(:,1);  
motorEsquerdo = MinimosQuadrados(Y, X)

Y=datalog(:,3); 
X=datalog(:,1);  
motorDireito = MinimosQuadrados(Y, X)

// Vamos calcular os gráficos
yEsquerdo = motorEsquerdo(1)*datalog(:,1) + motorEsquerdo(2);
yDireito  = motorDireito(1)*datalog(:,1)  + motorDireito(2);

// Eh preciso retirar a área negativa porque na prática o motor nunca gira para trás no experimento
for i=1:size(yEsquerdo)(1)
    if(yEsquerdo(i, 1)<0) then
        yEsquerdo(i, 1) = 0;
    end
end
for i=1:size(yDireito)(1)
    if(yDireito(i, 1)<0) then
        yDireito(i, 1) = 0;
    end
end

scf(1002)
clf()
// subplot(3,2,5);
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdo, yDireito], leg="Motor esquerdo@Motor direito@Função ajustada (motor esquerdo)@Função ajustada (motor direito)", style=[-3, -2, 2, 13])
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.children(3).mark_size=3;
p.children(4).mark_size=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs. Percentual da potência máxima"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

scf(1003)
clf()
// subplot(3,2,3);
plot2d(datalog(:,1), [yEsquerdo, yDireito], leg="Função ajustada (motor esquerdo)@Função ajustada (motor direito)", style=[2, 13])
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs. Percentual da potência máxima"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);


scf(1004)
clf()
yDesejadoEsquerdo = datalog(:, 1)*yEsquerdo(size(yEsquerdo)(1))/datalog(size(datalog)(1),1)
yDesejadoDireito  = datalog(:, 1)*yDireito(size(yDireito)(1))/datalog(size(datalog)(1),1)
plot2d(datalog(:,1), [yDesejadoEsquerdo, yDesejadoDireito], leg="Motor esquerdo@Motor direito", style=[2, 13])
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Resposta desejada dos motores"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

scf(1005)
clf()
plot2d(datalog(:,1), [yEsquerdo, yDireito, yDesejadoEsquerdo], leg="Função ajustada (motor esquerdo)@Função ajustada (motor direito)@Função desejada")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.children(3).thickness=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Funçõs desejadas vs.funções obtidas"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

// A funcao de correção é  potr = pot*100/(100-zona morta) + zona morta
B = - motorEsquerdo(2)/motorEsquerdo(1);
A = (yEsquerdo(size(yEsquerdo)(1)) - B) / yEsquerdo(size(yEsquerdo)(1));

printf("Potência Esquerda(x) = %.4f(x) + %.4f\n", A, B);

B = - motorDireito(2)/motorDireito(1);
A = (yDireito(size(yDireito)(1)) - B) / yDireito(size(yDireito)(1));

printf("Potência Direita(x) = %.4f(x) + %.4f\n", A, B);

printf("VOCÊ JÁ MEDIU OS VALORES CORRIGIDOS [S/N]?");

// Carregar os valores corrigidos
exec(get_absolute_file_path('plotaPotencia.sce')+'datalog2.sce', 0);

// Vamos ajustar duas retas. Uma para cada motor.

scf(1006)
clf()
// subplot(3,2,2);
plot2d(datalog(:,1), datalog(:,2:3), leg="Motor esquerdo@Motor direito", style=[-3, -2])
p = get("hdl")
p.children(1).mark_size=3;
p.children(2).mark_size=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs. Percentual da potência máxima após correção"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

// Vamos fazer uma regressão linear para ajustar duas retas. Uma para cada motor.

Y=datalog(:,2); 
X=datalog(:,1);  
motorEsquerdo=MinimosQuadrados(Y, X);

Y=datalog(:,3); 
X=datalog(:,1);  
motorDireito=MinimosQuadrados(Y, X);

// Vamos calcular os gráficos
yEsquerdoC = motorEsquerdo(1)*datalog(:,1) + motorEsquerdo(2);
yDireitoC  = motorDireito(1)*datalog(:,1)  + motorDireito(2);

for i=1:size(yEsquerdoC)(1)
    if(yEsquerdoC(i, 1)<0) then
        yEsquerdoC(i, 1) = 0;
    end
end
for i=1:size(yDireitoC)(1)
    if(yDireitoC(i, 1)<0) then
        yDireitoC(i, 1) = 0;
    end
end

scf(1007)
clf()
// subplot(3,2,6);
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdoC, yDireitoC], leg="Motor esquerdo@Motor direito@Função ajustada (motor esquerdo)@Função ajustada (motor direito)", style=[-3, -2, 2, 13])
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.children(3).mark_size=3;
p.children(4).mark_size=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs.Percentual da potência máxima após correção"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);


scf(1008)
clf()
// subplot(3,2,4);
plot2d(datalog(:,1), [yEsquerdoC, yDireitoC], leg="Função ajustada (motor esquerdo)@Função ajustada (motor direito)", style=[2, 13])
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
p = get("hdl")
p.children(1).thickness=3;
p.children(2).thickness=3;
p.parent.x_label.text = "Potência (%)"
p.parent.x_label.font_size = 4;
p.parent.y_label.text = "Graus/%S"
p.parent.y_label.font_size = 4;
p.parent.title.text = "Giro dos motores vs.Percentual da potência máxima após correção"
p.parent.title.font_size = 4;
p.parent.font_size = 4;
p.parent.box = "on"; 
p.parent.children(2).font_size = 4;
p.parent.children(2).legend_location="in_lower_right";
p.parent.children(2).fill_mode = "on";
xgrid(5, 1, 7);

