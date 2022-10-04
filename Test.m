
[P,p,T]=ISA(10000)

function [P,p,T]=ISA(z)
    
    g=9.81
    r=287.04; %Constante des gaz parfait air (J/Kg/K)
    T0=287.15; %Température au sol A regler avant le lancement (K)
    Tz=-0.0065; %(K)
    P0=101325; %Pression au sol à regler avant le lancement (pa)
    p0=P0/(r*T0); %Densité de l'air (Kg/m3) 
    
    T=double(T0+Tz*z)
    P=double(P0*(1+(Tz/T0)*z)^(-g/(r*Tz)))
    p=double(P/(r*T))
end