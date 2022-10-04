clear all
close all
clc

%----------Model Terrestre----------%
g=9.81; % HYP : On est bien sur la Terre
r=287.04; %Constante des gaz parfait air (J/Kg/K)
T0=287.15; %Température au sol A regler avant le lancement (K)
Tz=-0.0065; %(K)
P0=101325; %Pression au sol à regler avant le lancement (pa)
p0=P0/(r*T0); %Densité de l'air (Kg/m3) 

% HYP : Fusée reste dans la Trauposphere

%----------Model Simulation----------%
tsimu=4;

%----------Model AeroDynamique----------%

%---Model Vent---%
%Model Bruit
TBruitVent=0.2;
VarianceBruitVent=2;
KVarianceBruiVent=10; %La bruit teta doit etre centré sur 0
%Model Rafale
TDebutRafale=2; %(s)
TempsRafale=0.7;  %(s)
Rafale=5; %(m/s)
PhiRafale=pi/4; %angle de la rafale (rad)

%Model Géometrique
for d=1
    %----------Aileron arrière (quantitée:4)----------%
    CemplentureAA=0.2; %Corde à l'emplenture (m)
    CsaumonAA=0.13;   %Corde au saumon (m)
    LongueurAA=0.17;   %Longueur aile (m)
    DeltaCAA=0.05;     %Décalage entre le bord d'attack à l'emplenture et saumon (m)
    SrefAA=LongueurAA*(CsaumonAA+CemplentureAA)/2; %(m2)
    ZAA=2;           %Distance du haut de Cemplenture au nez  (m)
    OFAA=ZAA+4;      %Distance nez au foyer  (m)
    
    %----------Aileron de Corréction (quantitée:4)----------%
    CemplentureAC=0.05; %Corde à l'emplenture (m)
    CsaumonAC=0.03;   %Corde au saumon (m)
    LongueurAC=0.05;   %Longueur aile (m)
    DeltaCAC=0.02;     %Décalage entre le bord d'attack à l'emplenture et saumon (m)
    SrefAC=LongueurAC*(CsaumonAC+CemplentureAC)/2; %(m2)
    ZAC=0.5;      %Distance du haut de Cemplenture au nez  (m)
    OFAC=ZAC+4;      %Distance nez au foyer  (m)
    
    %----------Corp Cylindrique (quantitée:1)----------%
    RayonCC=0.1; %Diamètre (m)
    LongueurCC=2;   %Corde au saumon (m)
    SrefCC= LongueurCC*pi*2*RayonCC; %(m2)
    ZCC=0.24;      %Distance du haut de Cemplenture au nez  (m)
    OFCC=ZCC+LongueurCC/2;      %Distance nez au foyer  (m)
    
    %----------Cone (quantitée:1)----------%
    OFC=ZCC*2/3;      %Distance nez au foyer  (m)
    SrefC=1/3*ZCC*2*pi*RayonCC
    
    %----------Afficher Fusée----------%
    figure(1);
    set(gcf,'Position',[100 100 400 800])
    view(3);
    grid;
    axis equal
    %axis([-1 1 -1 1 -3 3])
    %Corp
    [X,Y,Z] = cylinder(RayonCC);
    fill3(X,Y,-Z*LongueurCC-ZCC,[1 0 0]);
    hold on
    %Aileron Arriere
    XXAA=[RayonCC (RayonCC+LongueurAA) (RayonCC+LongueurAA) RayonCC RayonCC];
    YYAA=[0 0 0 0 0];
    ZZAA=-[ZAA (ZAA+DeltaCAA) (ZAA+DeltaCAA+CsaumonAA) (ZAA+CemplentureAA) ZAA];
    fill3(XXAA,YYAA,ZZAA,[0 0 1])
    fill3(-XXAA,YYAA,ZZAA,[0 0 1])
    fill3(YYAA,XXAA,ZZAA,[1 0 0])
    fill3(YYAA,-XXAA,ZZAA,[1 0 0])
    axis equal
    %Aileron Controle
    XXAA=[RayonCC (RayonCC+LongueurAC) (RayonCC+LongueurAC) RayonCC RayonCC];
    YYAA=[0 0 0 0 0];
    ZZAA=-[ZAC (ZAC+DeltaCAC) (ZAC+DeltaCAC+CsaumonAC) (ZAC+CemplentureAC) ZAC];
    fill3(XXAA,YYAA,ZZAA,[0 1 1])
    fill3(-XXAA,YYAA,ZZAA,[0 1 1])
    fill3(YYAA,XXAA,ZZAA,[1 1 0])
    fill3(YYAA,-XXAA,ZZAA,[1 1 0])
    axis equal
    %Cone
    [X,Y,Z] = cylinder([0 RayonCC],50 );
    fill3(X,Y,-Z*ZCC,[1 0 0]);
    
    
end
Srefa=1; %(m2)
Srefn=1; %(m2)
Ca=0.12*Srefa;
Cd=0.0001*Srefn;
OF=2; %centre de poussée(m)


%----------Model Poussée----------%
%Model échelon
Tpropultion=2; %Temps de propultion (s)
Fp=100; %Force de propultion
%Model Bruit
TBruitP=0.1;
VarianceBruitP=1;
KVarianceBruit=10; %La bruit teta doit etre centré sur 0

%----------Model Mécanique----------%
mi=7; %Masse initial (Kg)
mc=1; %Masse Carburent (Kg)
Ip=Fp*Tpropultion;  %Intégrale de la poussée (Ns)
Kpm=mc/Ip; %Constante multi-Domaine Poussée masse (Kg/N)
%Hypotèse : poussée propotionnel au debit massique
Ixx=12; %Inertie Ixx (Kg/m2)
Iyy=Ixx; %Inerti (Kg/m2)
Izz=5; %Inerti (Kg/m2)
If=[Ixx 0 0;0 Iyy 0;0 0 Izz];
OG=1; %Position du centre de gravité (m)


AffichePropulsif=false;
AffichePosition=false;
AfficheAeroDynamique=false;


out=sim('Simulation1',tsimu);
NS=size(out.m.data(:));
NS=NS(1)

%----------Affichage Propulsif----------%
for d=1
    if AffichePropulsif
        figure(2)
        subplot(2,2,1);
        plot(out.P)
        xlabel('Temps (s)')
        ylabel('Force (N)')
        title('3 composantes de la poussée')
        grid
        hold on

        subplot(2,2,2);
        plot(out.m)
        xlabel('Temps (s)')
        ylabel('Masse (Kg)')
        title('Masse fusée')
        grid
        hold on

        subplot(2,2,3);
        plot(out.tetaP)
        hold on
        plot(out.phiP)
        xlabel('Temps (s)')
        ylabel('Angle (rad)')
        legend('teta','phi')
        title('Bruit propulsif')
        grid

        set(gcf, 'WindowState', 'maximized');
        
    end
end

%----------Affichage Position----------%
for d=1
    if AffichePosition
        figure(3);
        set(gcf, 'WindowState', 'maximized');
        grid;
        view(3);
        r = 0.1;
        [X,Y,Z] = cylinder(r);
        Cyl=surf(X+2,Y+2,Z*3+5);
        hold on
        axis equal
        axis([-10 10 -10 10 0 (max(out.x.data(:,3))+5)])

        h = animatedline;
        for k=1:NS-1
            figure(3);
            addpoints(h,out.x.data(k,1),out.x.data(k,2),out.x.data(k,3));
            drawnow;
            delete(Cyl);
            Cyl=surf(X+out.x.data(k,1),Y+out.x.data(k,2),Z*3+X+out.x.data(k,3));
            pause(0.0001);
        end
    end
end

%----------Affichage Aerodynamique----------%
for d=1
    if AfficheAeroDynamique
        figure(4)
        subplot(3,1,1)
        set(gcf, 'WindowState', 'maximized');
        plot(out.V)
        xlabel('Temps (s)')
        ylabel('Vitesse (m/s)')
        title('3 composantes de la vitesse dans R0')
        grid
        hold on
        
        subplot(3,1,2)
        plot(out.Vent)
        xlabel('Temps (s)')
        ylabel('Force (m/s)')
        title('3 composantes du vent dans R0')
        grid
        hold on
        
        subplot(3,1,3)
        plot(out.Vent)
        xlabel('Temps (s)')
        ylabel('Vitesse (m/s)')
        title('3 composantes de la poussée')
        grid
        hold on
    end
end

%---------Affichage Forces ----------%
