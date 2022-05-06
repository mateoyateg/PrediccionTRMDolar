%Implementacion del sistema de lógica difusa para la predicción de la tasa TRM mensual frente al
%Dolar Estadounidense (Configuracion 2 - 4 entradas y 7 consecuentes)
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

%Variable de entrada: Inflación
a=addvar(a,'input','Inflación',[0.0 10.0]);
%Funciones de pertenencia
a=addmf(a,'input',4,'I_Bajo','zmf', [1.8 2.8]);
a=addmf(a,'input',4,'I_Normal','gaussmf',  [1.2 3.8]);
a=addmf(a,'input',4,'I_Alto','smf',  [4.5 9.0]);
%plotmf(a,'input',4)

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
%Exportaciones: 1. Pocas [0 3.25M] / 2. Normales [3.25M 3.7M] / 3. Altas [3.7M 5M]
%Sol Peruano: 1.  P_Bajo [0 2.8] / 2. P_Normal [2.75 3.5] / 3. P_Alto [3.5 5]
%Inflación: 1.  I_Bajo [1.8 2.8] / 2. P_Normal [1.2 3.8] / 3. P_Alto [4.5 9.0]
%TRM: 1. P_Bajo [0 1450] / 2. P_Bajo [1450 1900]
% 3. P_BajoIdeal [1900 2300] / 4. P_Ideal [2300 2700]
% 5. P_Medio [2700 3200] / 6. P_MedioAlto [3200 3500]
% 7. P_Alto [3500 4000]

ruleList=[
    1 1 3 1 7 1 2
    2 2 3 2 6 1 2
    2 1 2 1 5 1 2
    2 2 2 1 4 1 2
    3 2 2 2 3 1 2
    3 2 1 3 2 1 2
    3 3 1 3 1 1 2];

a = addrule(a,ruleList);

%Sistema difuso
%fuzzy(a)

%Para evaluar varias entradas
%Recuperacion de los datos del Petroleo Brent
PetroleoExcel = xlsread('C2_Datasets','B139:B268');

%Recuperacion de las Exportaciones de Petroleo
ExportacionesExcel = xlsread('C2_Datasets','E139:E268');

%Recuperacion del Sol Peruano
SolPeruanoExcel = xlsread('C2_Datasets','G139:G268');

%Recuperacion de la Inflación
InflacionExcel = xlsread('C2_Datasets','H3:H132');

% Evaluacion en el sistema de lógica difusa
Evaluacion = [PetroleoExcel ExportacionesExcel SolPeruanoExcel InflacionExcel];
Y = evalfis(Evaluacion,a);
xlswrite('C2_DatasetsConResultados',Y,'J3:J132');


