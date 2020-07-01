funcprot(0)
clc

// Calcula Z =[ y - f(x) ]
function z1 = Z(y, x, teta)
    z1 = zeros(size(y,1));
    
    for i=1:size(y, 1)
        z1(i) = y(i) - (teta(1)*x(i)+teta(2));
    end
endfunction

// Calcula o Jacobiano
function [J1] = J(x, teta)
    J1= zeros(size(x, 1), size(teta, 1));    
    // Lembre-se que eh o calculo do Jacobiano da funcao de erro
    for i=1:size(x, 1)
        J1(i, :) = [-x(i) -1];
    end
endfunction

function estado=GaussNewtonI(Y, X, valorInicial, n)
    estado = valorInicial;
    for i=1:n
        Z1 = Z(Y, X, estado);
        J1 = J(X, estado);
        incremento = - inv(J1'*J1)*J1'*Z1;
        estado = estado + incremento;
    end
endfunction

exec(get_absolute_file_path('plotaPotencia.sce')+'datalog.sce', 0);

scf(1001)
clf()
// subplot(3,2,1);
plot2d(datalog(:,1), datalog(:,2:3), leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")

// Vamos ajustar duas retas. Uma para cada motor.

tetaI=[1 1]';   // Valores iniciais dos parâmetros
iteracoes=100;  // Numero de iterações

Y=datalog(:,2); 
X=datalog(:,1);  
motorEsquerdo=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=datalog(:,3); 
X=datalog(:,1);  
motorDireito=GaussNewtonI(Y, X, tetaI, iteracoes);

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
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)@Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";


scf(1003)
clf()
// subplot(3,2,3);
plot2d(datalog(:,1), [yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

scf(1004)
clf()
yDesejadoEsquerdo = datalog(:, 1)*yEsquerdo(size(yEsquerdo)(1))/datalog(size(datalog)(1),1)
yDesejadoDireito  = datalog(:, 1)*yDireito(size(yDireito)(1))/datalog(size(datalog)(1),1)
plot2d(datalog(:,1), [yDesejadoEsquerdo, yDesejadoDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

scf(1005)
clf()
plot2d(datalog(:,1), [yEsquerdo, yDireito, yDesejadoEsquerdo, yDesejadoDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)@Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

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
plot2d(datalog(:,1), datalog(:,2:3), leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")

// Vamos ajustar duas retas. Uma para cada motor.

tetaI=[1 1]';   // Valores iniciais dos parâmetros
iteracoes=100;  // Numero de iterações

Y=datalog(:,2); 
X=datalog(:,1);  
motorEsquerdo=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=datalog(:,3); 
X=datalog(:,1);  
motorDireito=GaussNewtonI(Y, X, tetaI, iteracoes);

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
// subplot(3,2,4);
plot2d(datalog(:,1), [yEsquerdoC, yDireitoC], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

scf(1008)
clf()
// subplot(3,2,6);
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdoC, yDireitoC], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)@Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

