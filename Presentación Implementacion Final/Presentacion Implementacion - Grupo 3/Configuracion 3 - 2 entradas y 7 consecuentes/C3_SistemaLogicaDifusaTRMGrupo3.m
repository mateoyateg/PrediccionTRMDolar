%Implementacion del sistema de lógica difusa para la predicción de la tasa TRM mensual frente al
%Dolar Estadounidense (Configuracion 3 - 2 entradas y 7 consecuentes)
close all
clear all
warning('off')

%Sistema
a=newfis('Calc. TRM ($COP) C3');

%Variable de entrada: Precio del Barril Brent en USD
a=addvar(a,'input','Petroleo',[0 150]);
%Funciones de pertenencia
a=addmf(a,'input',1,'P_Bajo','zmf', [30 50]);
a=addmf(a,'input',1,'P_Normal','gaussmf', [10.4 65.9]);
a=addmf(a,'input',1,'P_Alto','smf', [76.8 97.7]);
%plotmf(a,'input',1)

%Se suprimió la entrada de Exportaciones del petroleo por mes del país

%Variable de entrada: Tasa de Cambio PEN-USD ($USD)
a=addvar(a,'input','Sol',[0 4.5]);
%Funciones de pertenencia
a=addmf(a,'input',2,'P_Bajo','zmf', [2.25 2.75]);
a=addmf(a,'input',2,'P_Normal','gaussmf',  [0.2 2.9]);
a=addmf(a,'input',2,'P_Alto','smf',  [3.1 3.5]);
%plotmf(a,'input',2)

%Variable de salida: TRM ($COP)
a=addvar(a,'output','TRM',[0 4000]);
%Funciones de pertenencia
a=addmf(a,'output',1,'P_MuyBajo','zmf', [1160 1600]);
a=addmf(a,'output',1,'P_Bajo','gaussmf', [112 1700]);
a=addmf(a,'output',1,'P_BajoIdeal','gaussmf', [93.8 2180]);
a=addmf(a,'output',1,'P_Ideal','gaussmf', [148 2700]);
a=addmf(a,'output',1,'P_Medio','gaussmf', [66.96 3100]);
a=addmf(a,'output',1,'P_MedioAlto','gaussmf', [75.7 3400]);
a=addmf(a,'output',1,'P_Alto','smf', [3.54e+03 3.85e+03]);
%plotmf(a,'output',1)

%Reglas de inferencia
%Petroleo Brent: 1. P_Bajo [0 30] / 2. P_Normal [30 120] / 3. P_Alto [120 150]
%Sol Peruano: 1.  P_Bajo [0 2.8] / 2. P_Normal [2.75 3.5] / 3. P_Alto [3.5 5]
%TRM: 1. P_Bajo [0 1450] / 2. P_Bajo [1450 1900]
% 3. P_BajoIdeal [1900 2300] / 4. P_Ideal [2300 2700]
% 5. P_Medio [2700 3200] / 6. P_MedioAlto [3200 3500]
% 7. P_Alto [3500 4000]
% Primera entrada, segunda entrada, tercera entrada, 1ra salida, relevancia
% (1), and (2) o or (1)
ruleList=[
    1 3 7 1 2
    2 3 6 1 2
    2 2 5 1 2
    2 2 4 1 2
    3 2 3 1 2
    3 1 2 1 2
    3 1 1 1 2];

a = addrule(a,ruleList);

%Sistema difuso
fuzzy(a)

%Para evaluar varias entradas
%Recuperacion de los datos del Petroleo Brent
PetroleoExcel = xlsread('C3_Datasets','B139:B268');

%Recuperacion del Sol Peruano
SolPeruanoExcel = xlsread('C3_Datasets','G139:G268');

% Evaluacion en el sistema de lógica difusa
Evaluacion = [PetroleoExcel SolPeruanoExcel];
Y = evalfis(Evaluacion,a);
xlswrite('C3_DatasetsConResultados',Y,'J3:J132');


