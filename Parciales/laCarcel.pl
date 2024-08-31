% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

%%% PUNTO 1 %%%
% controla(Controlador, Controlado)
%controla(piper, alex).
%controla(bennett, dayanara).
%controla(Guardia, Otro):- 
    %prisionero(Otro,_), 
    %not(controla(Otro, Guardia)).
%%% No es inversible en su primer parametro ya que Guardia no está previamente ligado. Esto se debe a que "not" no es inversible.
%%% Si realizo la siguiente consulta, en la terminal habra un error por stack limit siempre: controla(Quienes, suzanne).

controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    prisionero(Otro,_),
    guardia(Guardia), 
    not(controla(Otro, Guardia)).


%%% PUNTO 2 %%%
%conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros) si no se controlan mutuamente y 
%existe algún tercero al cual ambos controlan.

conflictoDeIntereses(Persona, OtraPersona) :-
    controla(Persona, Tercero),
    controla(OtraPersona, Tercero),
    not(controla(Persona, OtraPersona)), 
    not(controla(OtraPersona, Persona)),
    Persona \= OtraPersona.

%%% PUNTO 3 %%%
%peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
%Un robo nunca es grave.
%Un homicidio siempre es grave.
%Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o incluye metanfetaminas.

delitosGraves(homicidio(_)).
delitosGraves(narcotrafico(Drogas)) :-
    length(Drogas, Cantidad),
    Cantidad >= 5.
delitosGraves(narcotrafico(Drogas)) :-
    member(metanfetaminas, Drogas).

peligroso(Preso) :-
    prisionero(Preso, _),
    forall(prisionero(Preso, Crimen), delitosGraves(Crimen)).

%%% PUNTO 4 %%%
%ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.

robosImportantes(robo(MontoChoreado)) :-
    MontoChoreado > 100000.

ladronDeGuanteBlanco(Preso) :-
    prisionero(Preso, _),
    forall(prisionero(Preso, Crimen), robosImportantes(Crimen)).
    
%%% PUNTO 5 %%%
%condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir. 
%Esto se calcula como la suma de los años que le aporte cada crimen cometido, que se obtienen de la siguiente forma:
%La cantidad de dinero robado dividido 10.000.
%7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
%2 años por cada droga que haya traficado.
cadaCondenaPorCrimen(robo(Monto), Anios) :- Anios is Monto / 10000.
cadaCondenaPorCrimen(homicidio(Matado), 7) :- guardia(Matado).
cadaCondenaPorCrimen(homicidio(Matado), 5) :- not(guardia(Matado)).
cadaCondenaPorCrimen(narcotrafico(Drogas), Anios) :- length(Drogas, Cantidad), Anios is Cantidad * 2.

condena(Preso, Condena) :-
    prisionero(Preso, _),
    findall(Anios, criminales(Preso, Anios), Condenas),
    sumlist(Condenas, Condena).

criminales(Preso, Anios) :-
    prisionero(Preso, Crimen),
    cadaCondenaPorCrimen(Crimen, Anios).

%%% PUNTO 6 %%%
%capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla, 
%pero todas las personas de la cárcel (guardias o prisioneros) son controlados por él, o por alguien 
%a quien él controla (directa o indirectamente).

personasDeLaCarcel(Persona) :-
    prisionero(Persona, _).

personasDeLaCarcel(Persona) :-
    guardia(Persona).

controlSupremo(Preso, Persona) :-
    controla(Preso, Persona).

controlSupremo(Preso, Persona) :-
    controla(Preso, Controlado),
    controlSupremo(Controlado, Persona).

capoDiTutiLiCapi(Preso) :-
    prisionero(Preso, _),
    not(controla(_, Preso)),
    forall((personasDeLaCarcel(Persona), Preso \= Persona), controlSupremo(Preso, Persona)).
