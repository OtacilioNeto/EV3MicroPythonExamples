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


exec(get_absolute_file_path('ajuste.sce')+'amarelo.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'azul.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'cinza.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'creme.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'preto.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'verde.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'vermelho.sce', 0);

mamarelo = mean(amarelo,"r");
mazul    = mean(azul,"r");
mcinza   = mean(cinza,"r");
mcreme   = mean(creme,"r");
mpreto   = mean(preto, "r");
mverde   = mean(verde, "r");
mvermelho= mean(vermelho, "r");

rred = [ mamarelo(1) mazul(1) mcinza(1) mcreme(1) mpreto(1) mverde(1) mvermelho(1)];
ared = [ mamarelo(4) mazul(4) mcinza(4) mcreme(4) mpreto(4) mverde(4) mvermelho(4)];

rgreen = [ mamarelo(2) mazul(2) mcinza(2) mcreme(2) mpreto(2) mverde(2) mvermelho(2)];
agreen = [ mamarelo(5) mazul(5) mcinza(5) mcreme(5) mpreto(5) mverde(5) mvermelho(5)];

rblue = [ mamarelo(3) mazul(3) mcinza(3) mcreme(3) mpreto(3) mverde(3) mvermelho(3)];
ablue = [ mamarelo(6) mazul(6) mcinza(6) mcreme(6) mpreto(6) mverde(6) mvermelho(6)];

scf(1001)
clf();
subplot(2,2,1);
scatter(gca(), rred, rred, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rred, ared, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 0 0]);
subplot(2,2,2);
scatter(gca(), rgreen, rgreen, "markerEdgeColor", [0 1 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rgreen, agreen, "markerEdgeColor", [0 1 0], "markerFaceColor", [0 1 0]);
subplot(2,2,3);
scatter(gca(), rblue, rblue, "markerEdgeColor", [0 0 1], "markerFaceColor", [1 1 1]);
scatter(gca(), rblue, ablue, "markerEdgeColor", [0 0 1], "markerFaceColor", [0 0 1]);

// Vamos ajustar uma reta aos valores de referência como também aos valores medidos
scf(1002)
clf();
subplot(2,2,1);
scatter(gca(), ared, rred-ared, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 0 0]);
subplot(2,2,2);
scatter(gca(), agreen, rgreen-agreen, "markerEdgeColor", [0 1 0], "markerFaceColor", [0 1 0]);
subplot(2,2,3);
scatter(gca(), ablue, rblue-ablue, "markerEdgeColor", [0 0 1], "markerFaceColor", [0 0 1]);
                                                    // a função de ajuste
tetaI=[1 0]';   // Valores iniciais dos parâmetros
iteracoes=100;   // Numero de iterações

Y=[rred-ared]'; 
X=ared';  
estadoRed=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=[rgreen-agreen]';
X=agreen';
estadoGreen=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=[rblue-ablue]';
X=ablue';
estadoBlue=GaussNewtonI(Y, X, tetaI, iteracoes);


// Vamos plotar o gráfico das funções ajustadas
scf(1002)
X=[0:35];
Y=estadoRed(1)*X + estadoRed(2);
subplot(2,2,1);
titulo=msprintf("erro(x)=%fx+%f\n", estadoRed(1), estadoRed(2));
plot(X,Y, "red", title(titulo, "fontsize",4));


Y=estadoGreen(1)*X + estadoGreen(2);
subplot(2,2,2);
titulo=msprintf("erro(x)=%fx+%f\n", estadoGreen(1), estadoGreen(2));
plot(X,Y, "green", title(titulo, "fontsize",4));

Y=estadoBlue(1)*X + estadoBlue(2);
subplot(2,2,3);
titulo=msprintf("erro(x)=%fx+%f\n", estadoBlue(1), estadoBlue(2));
plot(X,Y, "blue", title(titulo, "fontsize",4));

