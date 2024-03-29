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
exec(get_absolute_file_path('ajuste.sce')+'branco.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'cinza.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'creme.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'preto.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'verde.sce', 0);
exec(get_absolute_file_path('ajuste.sce')+'vermelho.sce', 0);

mamarelo = mean(amarelo,"r");
mazul    = mean(azul,"r");
mbranco  = mean(branco,"r");
mcinza   = mean(cinza,"r");
mcreme   = mean(creme,"r");
mpreto   = mean(preto, "r");
mverde   = mean(verde, "r");
mvermelho= mean(vermelho, "r");

rred = [ mamarelo(1) mazul(1) mbranco(1) mcinza(1) mcreme(1) mpreto(1) mverde(1) mvermelho(1)];
ared = [ mamarelo(4) mazul(4) mbranco(4) mcinza(4) mcreme(4) mpreto(4) mverde(4) mvermelho(4)];

rgreen = [ mamarelo(2) mazul(2) mbranco(2) mcinza(2) mcreme(2) mpreto(2) mverde(2) mvermelho(2)];
agreen = [ mamarelo(5) mazul(5) mbranco(5) mcinza(5) mcreme(5) mpreto(5) mverde(5) mvermelho(5)];

rblue = [ mamarelo(3) mazul(3) mbranco(3) mcinza(3) mcreme(3) mpreto(3) mverde(3) mvermelho(3)];
ablue = [ mamarelo(6) mazul(6) mbranco(6) mcinza(6) mcreme(6) mpreto(6) mverde(6) mvermelho(6)];

scf(1001)
clf();
subplot(3,2,1);
scatter(gca(), rred, rred, 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rred, ared, 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 0 0]);
reixo_red = gca();
reixo_red.data_bounds = [0 0;reixo_red.data_bounds(2,2) reixo_red.data_bounds(2,2)];
subplot(3,2,3);
scatter(gca(), rgreen, rgreen, 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rgreen, agreen, 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [0 1 0]);
reixo_green = gca();
reixo_green.data_bounds = [0 0;reixo_green.data_bounds(2,2) reixo_green.data_bounds(2,2)];
subplot(3,2,5);
scatter(gca(), rblue, rblue, 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [1 1 1]);
scatter(gca(), rblue, ablue, 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [0 0 1]);
reixo_blue = gca();
reixo_blue.data_bounds = [0 0;reixo_blue.data_bounds(2,2) reixo_blue.data_bounds(2,2)];

// Vamos ajustar uma reta aos valores de referência como também aos valores medidos
subplot(3,2,2);
scatter(gca(), rred, ared-rred, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [1 0 0]);
eixo_red = gca();
eixo_red.data_bounds = [0 -reixo_red.data_bounds(2,2); reixo_red.data_bounds(2,2) 0];
subplot(3,2,4);
scatter(gca(), rgreen, agreen-rgreen, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [0 1 0]);
eixo_green = gca();
eixo_green.data_bounds = [0 -reixo_green.data_bounds(2,2);reixo_green.data_bounds(2,2) 0];
subplot(3,2,6);
scatter(gca(), rblue, ablue-rblue, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [0 0 1]);
eixo_blue = gca();
eixo_blue.data_bounds = [0 -reixo_blue.data_bounds(2,2);reixo_blue.data_bounds(2,2) 0];
                                                    // a função de ajuste
tetaI=[1 0]';   // Valores iniciais dos parâmetros
iteracoes=100;   // Numero de iterações

Y=[ared-rred]'; 
X=ared';  
estadoRed=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=[agreen-rgreen]';
X=agreen';
estadoGreen=GaussNewtonI(Y, X, tetaI, iteracoes);

Y=[ablue-rblue]';
X=ablue';
estadoBlue=GaussNewtonI(Y, X, tetaI, iteracoes);

// Vamos plotar o gráfico das funções ajustadas
scf(1002)
clf()
X=[0:reixo_red.data_bounds(2,2)];
Y=estadoRed(1)*X + estadoRed(2);
subplot(2,2,1);
scatter(gca(), ared, ared-rred, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [1 0 0]);
titulo=msprintf("erro(x)=%fx+%f\n", estadoRed(1), estadoRed(2));
plot(X,Y, "red", title(titulo, "fontsize",4));
eixo_red = gca();
eixo_red.data_bounds = [0 -reixo_red.data_bounds(2,2);reixo_red.data_bounds(2,2) 0];

X=[0:reixo_green.data_bounds(2,2)];
Y=estadoGreen(1)*X + estadoGreen(2);
subplot(2,2,2);
scatter(gca(), agreen, agreen-rgreen, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [0 1 0]);
titulo=msprintf("erro(x)=%fx+%f\n", estadoGreen(1), estadoGreen(2));
plot(X,Y, "green", title(titulo, "fontsize",4));
eixo_green = gca();
eixo_green.data_bounds = [0 -reixo_green.data_bounds(2,2);reixo_green.data_bounds(2,2) 0];

X=[0:reixo_blue.data_bounds(2,2)];
Y=estadoBlue(1)*X + estadoBlue(2);
subplot(2,2,3);
scatter(gca(), ablue, ablue-rblue, 100, "markerEdgeColor", [0 0 0], "markerFaceColor", [0 0 1]);
titulo=msprintf("erro(x)=%fx+%f\n", estadoBlue(1), estadoBlue(2));
plot(X,Y, "blue", title(titulo, "fontsize",4));
eixo_blue = gca();
eixo_blue.data_bounds = [0 -reixo_blue.data_bounds(2,2);reixo_blue.data_bounds(2,2) 0];

// Vamos plotar os valores originais depois de corrigidos com as funções encontradas
scf(1003)
clf();
subplot(3,2,1);
scatter(gca(), rred, rred, 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rred, ared, 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 0 0]);
eixo_red = gca();
eixo_red.data_bounds = [0 0;reixo_red.data_bounds(2,2) reixo_red.data_bounds(2,2)];
subplot(3,2,2);
scatter(gca(), rred, rred, 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rred, ared -(estadoRed(1)*ared+estadoRed(2)), 100, "markerEdgeColor", [1 0 0], "markerFaceColor", [1 0 0]);
eixo_red = gca();
eixo_red.data_bounds = [0 0;reixo_red.data_bounds(2,2) reixo_red.data_bounds(2,2)];

subplot(3,2,3);
scatter(gca(), rgreen, rgreen, 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rgreen, agreen, 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [0 1 0]);
eixo_green = gca();
eixo_green.data_bounds = [0 0;reixo_green.data_bounds(2,2) reixo_green.data_bounds(2,2)];
subplot(3,2,4);
scatter(gca(), rgreen, rgreen, 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [1 1 1]);
scatter(gca(), rgreen, agreen -(estadoGreen(1)*agreen+estadoGreen(2)), 100, "markerEdgeColor", [0 1 0], "markerFaceColor", [0 1 0]);
eixo_green = gca();
eixo_green.data_bounds = [0 0;reixo_green.data_bounds(2,2) reixo_green.data_bounds(2,2)];

subplot(3,2,5);
scatter(gca(), rblue, rblue, 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [1 1 1]);
scatter(gca(), rblue, ablue, 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [0 0 1]);
eixo_blue = gca();
eixo_blue.data_bounds = [0 0;reixo_blue.data_bounds(2,2) reixo_blue.data_bounds(2,2)];
subplot(3,2,6);
scatter(gca(), rblue, rblue, 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [1 1 1]);
scatter(gca(), rblue, ablue - (estadoBlue(1)*ablue+estadoBlue(2)), 100, "markerEdgeColor", [0 0 1], "markerFaceColor", [0 0 1]);
eixo_blue = gca();
eixo_blue.data_bounds = [0 0;reixo_blue.data_bounds(2,2) reixo_blue.data_bounds(2,2)];
