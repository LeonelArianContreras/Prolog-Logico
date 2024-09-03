% Se cumple para los jugadores.
jugador(Jugador).
% Ejemplo:
% jugador(rojo).

% Relaciona un país con el continente en el que está ubicado,
ubicadoEn(Pais, Continente).
% Ejemplo:
% ubicadoEn(argentina, américaDelSur).

% Relaciona dos jugadores si son aliados.
aliados(UnJugador, OtroJugador).
% Ejemplo:
% aliados(rojo, amarillo).

% Relaciona un jugador con un país en el que tiene ejércitos.
ocupa(Jugador, Pais).
% Ejemplo:
% ocupa(rojo, argentina).

% Relaciona dos países si son limítrofes.
limitrofes(UnPais, OtroPais).
% Ejemplo:
% limítrofes(argentina, brasil).

%tienePresenciaEn/2: Relaciona un jugador con un continente del cual ocupa, al menos, un país.
tienePresencia(Jugador, Continente) :-
    ubicadoEn(Pais, Continente),
    ocupa(Jugador, Pais).

%puedenAtacarse/2: Relaciona dos jugadores si uno ocupa al menos un país limítrofe a algún país ocupado por el otro.
puedenAtacarse(Jugador, OtroJugador) :-
    ocupa(Jugador, Pais),
    limitrofes(Pais, OtroPais),
    ocupa(OtroJugador, OtroPais).

%sinTensiones/2: Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.
sinTensiones(Jugador, OtroJugador) :-
    jugador(Jugador), jugador(OtroJugador),
    not(puedenAtacarse(Jugador, OtroJugador)).

sinTensiones(Jugador, OtroJugador) :-
    aliados(Jugador, OtroJugador).

%perdió/1: Se cumple para un jugador que no ocupa ningún país.
perdio(Jugador) :-
    jugador(Jugador),
    not(ocupa(Jugador, _)).

%controla/2: Relaciona un jugador con un continente si ocupa todos los países del mismo.
controla(Jugador, Continente) :-
    continente(Continente), jugador(Jugador),
    forall(ubicadoEn(Pais, Continente), ocupa(Jugador, Pais)).

continente(Continente):-
    ubicadoEn(_, Continente).

%reñido/1: Se cumple para los continentes donde todos los jugadores ocupan algún país.
renido(Continente) :-
    ubicadoEn(_, Continente),
    forall(jugador(Jugador), (ocupa(Jugador, Pais), ubicadoEn(Pais, Continente))).

%atrincherado/1: Se cumple para los jugadores que ocupan países en un único continente.
atrincherado(Jugador) :-
    tienePresencia(Jugador, Continente),
    not(tienePresencia(Jugador, OtroContinente)),
    Continente \= OtroContinente.

%puedeConquistar/2: Relaciona un jugador con un continente si no lo controla, pero todos los países del continente que le 
%falta ocupar son limítrofes a alguno que sí ocupa y pertenecen a alguien que no es su aliado
puedeConquistar(Jugador, Continente) :-
    jugador(Jugador), continente(Continente),
    not(controla(Jugador, Continente)),
    forall(ubicadoEn(Pais, Continente), esConquistable(Jugador, Pais)).

esConquistable(Jugador, Pais) :-
    not(ocupa(Jugador, Pais)),
    limitrofes(Pais, OtroPais),
    not(aliados(Jugador, OtroJugador)),
    ocupa(OtroJugador, OtroPais).
