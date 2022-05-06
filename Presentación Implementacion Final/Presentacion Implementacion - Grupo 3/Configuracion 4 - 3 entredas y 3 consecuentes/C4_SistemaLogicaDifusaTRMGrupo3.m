%Implementacion del sistema de lógica difusa para la predicción de la tasa TRM mensual frente al
%Dolar Estadounidense (Configuracion 4 - 3 entradas y 3 consecuentes)
close all
clear all
warning('off')

%Sistema
a=newfis('Calc. TRM ($COP) - C4');

%Variable de entrada: Precio del Barril Brent en USD
a=addvar(a,'input','Petroleo',[0 150]);
%Funciones de pertenencia
a=addmf(a,'input',1,'P_Bajo','zmf', [30 50]);
a=addmf(a,'input',1,'P_Normal','gaussmf', [10.4 65.9]);
a=addmf(a,'input',1,'P_Alto','smf', [76.8 97.7]);
%plotmf(a,'input',1)

%Variable de entrada: Exportaciones del Petroleo en Ton. Metricas
a=addvar(a,'input','Exportaciones',[0 5000000]);
%Funciones de pertenencia
a=addmf(a,'input',2,'Pocas','zmf',    [3.01e+06 3.76e+06]);
a=addmf(a,'input',2,'Normales','gaussmf',   [2.04e+05 4.03e+06]);
a=addmf(a,'input',2,'Altas','smf',   [4.434e+06 4.897e+06]);
%plotmf(a,'input',2)

%Variable de entrada: Tasa de Cambio PEN-USD ($USD)
a=addvar(a,'input','Sol',[0 4.5]);
%Funciones de pertenencia
a=addmf(a,'input',3,'P_Bajo','zmf', [2.25 2.75]);
a=addmf(a,'input',3,'P_Normal','gaussmf',  [0.2 2.9]);
a=addmf(a,'input',3,'P_Alto','smf',  [3.1 3.5]);
%plotmf(a,'input',3)

%Variable de salida: TRM ($COP)
a=addvar(a,'output','TRM',[0 4000]);
%Funciones de pertenencia
a=addmf(a,'output',1,'P_Bajo','zmf', [1200 1850]);
a=addmf(a,'output',1,'P_Normal','gaussmf', [320 2450]);
a=addmf(a,'output',1,'P_Alto','smf', [3150 3550]);
%plotmf(a,'output',1)

%Reglas de inferencia
%Petroleo Brent: 1. P_Bajo [0 30] / 2. P_Normal [30 120] / 3. P_Alto [120 150]
%Exportaciones: 1. Pocas [0 3.25M] / 2. Normales [3.25M 3.7M] / 3. Altas [3.7M 5M]
%Sol Peruano: 1.  P_Bajo [0 2.8] / 2. P_Normal [2.75 3.5] / 3. P_Alto [3.5 5]
%TRM: 1. P_Bajo [0 1800] / 2. P_Normal [1800 3200] / 3. P_Alto [3200 4000]

ruleList=[
    1 1 3 3 1 2
    2 2 3 3 1 2
    2 1 2 2 1 2
    2 2 2 2 1 2
    3 2 2 2 1 2
    3 2 1 1 1 2
    3 3 1 1 1 2];

a = addrule(a,ruleList);

%Sistema difuso
%fuzzy(a)

%Para evaluar varias entradas
%Recuperacion de los datos del Petroleo Brent
PetroleoExcel = xlsread('C4_Datasets','B139:B268');

%Recuperacion de las Exportaciones de Petroleo
ExportacionesExcel = xlsread('C4_Datasets','E139:E268');

%Recuperacion del Sol Peruano
SolPeruanoExcel = xlsread('C4_Datasets','G139:G268');

% Evaluacion en el sistema de lógica difusa
Evaluacion = [PetroleoExcel ExportacionesExcel SolPeruanoExcel];
Y = evalfis(Evaluacion,a);
xlswrite('C4_DatasetsConResultados',Y,'J3:J132');

