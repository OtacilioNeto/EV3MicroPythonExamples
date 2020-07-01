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
yEsquerdo = motorEsquerdo(1)*datalog(:,1)+motorEsquerdo(2);
yDireito  = motorDireito(1)*datalog(:,1)+motorDireito(2);

scf(1002)
clf()
// subplot(3,2,3);
plot2d(datalog(:,1), [yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

scf(1003)
clf()
// subplot(3,2,5);
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)@Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

// Carregar os valores corrigidos
exec(get_absolute_file_path('plotaPotencia.sce')+'datalog2.sce', 0);

// Vamos ajustar duas retas. Uma para cada motor.

scf(1004)
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
yEsquerdo = motorEsquerdo(1)*datalog(:,1)+motorEsquerdo(2);
yDireito  = motorDireito(1)*datalog(:,1)+motorDireito(2);

scf(1005)
clf()
// subplot(3,2,4);
plot2d(datalog(:,1), [yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";

scf(1006)
clf()
// subplot(3,2,6);
plot2d(datalog(:,1), [datalog(:,2), datalog(:,3), yEsquerdo, yDireito], leg="Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)@Motor Esquerdo (graus/%S)@Motor Direito (graus/%S)")
a=gca(); // Handle on axes entity
a.x_location = "origin";
a.y_location = "origin";
