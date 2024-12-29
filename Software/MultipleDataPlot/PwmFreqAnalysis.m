clc
clear

close all

fsw = 1000:1000:10000;

TB_DIV = 2;

TBPRD = 200e6 ./ (fsw * 2* TB_DIV);

plot(TBPRD)