%mago(Nombre, Status De Sangre, Casa Odiada).
%caracterDe(Nombre, Caracteristica)

mago(harry, mestiza, slytherin).
mago(draco, pura, hufflepuff).
mago(hermione, impura, noOdiaNingunaCasa).

caracterDe(harry, corajudo).
caracterDe(harry, amistoso).
caracterDe(harry, orgulloso).
caracterDe(harry, inteligente).

caracterDe(draco, inteligente).
caracterDe(draco, orgulloso).

caracterDe(hermione, inteligente).
caracterDe(hermione, orgulloso).
caracterDe(hermione, responsable).

%dejaEntrarSi(Casa, TenesQueSer)
dejaEntrarSi(gryffindor, corajudo).
dejaEntrarSi(slytherin, orgulloso).
dejaEntrarSi(slytherin, inteligente).
dejaEntrarSi(ravenclaw, inteligente).
dejaEntrarSi(ravenclaw, responsabilidad).
dejaEntrarSi(hufflepuff, amistoso).

casa(Casa) :-
    dejaEntrarSi(Casa, _).

mago(Mago) :-
    mago(Mago, _, _).

%%%%%%%%%%%%%
%% Punto 1 %%
%%%%%%%%%%%%%

permiteEntrar(Casa, Mago) :-
    casa(Casa),
    mago(Mago),
    not(excepcionDe(Casa, Sangre)).

excepcionDe(slytherin, impura).

%%%%%%%%%%%%%
%% Punto 2 %%
%%%%%%%%%%%%%

tieneElCaracterParaEntrar(Mago, Casa) :-
    casa(Casa),
    mago(Mago),
    forall(dejaEntrarSi(Casa, CaracteristicaBuscada), caracterDe(Mago, CaracteristicaBuscada)).

%%%%%%%%%%%%%
%% Punto 3 %%
%%%%%%%%%%%%%

casaAdecuadaPara(Mago, Casa) :-
    permiteEntrar(Casa, Mago),
    tieneElCaracterParaEntrar(Mago, Casa),
    not(mago(Mago, _, Casa)).

casaAdecuadaPara(hermione, gryffindor).

%%%%%%%%%%%%%
%% Punto 4 %%
%%%%%%%%%%%%%

% No lo pienso hacer, no entra en mi parcial estas cosas raras

%%% PARTE 2 %%%

%%%%%%%%%%%%%
%% Punto 1 %%
%%%%%%%%%%%%%

%malaAccionDe(Persona, Accion).
%buenaAccionDe(Persona, Accion).

accionDe(harry, mala(fueraDeCama)).
accionDe(hermione, mala(seccionRestringidaBiblioteca)).
accionDe(hermione, mala(tercerPiso)).
accionDe(draco, mala(bosque)).
accionDe(harry, buena(salvarAAmigos)).
accionDe(harry, buena(ganarleAVoldemort)).
accionDe(draco, buena(salvarAAmigos)).
accionDe(hermione, respoderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).

accionBenefica(salvarAAmigos, 50).
accionBenefica(ganarleAVoldemort, 1111).

lugarProhibido(tercerPiso, -75).
lugarProhibido(ganarleAVoldemort, 60).
lugarProhibido(seccionRestringidaBiblioteca, -10).

puntajeDe(mala(Lugar), Puntaje) :- lugarProhibido(Lugar, Puntaje).
puntajeDe(mala(fueraDeCama), -50).
puntajeDe(buena(AccionBenefica), Puntaje) :- accionBenefica(AccionBenefica, Puntaje).
puntajeDe(responderPregunta(_, Dificultad, snape), Puntaje) :- Puntaje is Dificultad / 2.
puntajeDe(responderPregunta(_, Dificultad, Profe), Dificultad) :- Profe \= snape. 

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

buenAlumno(Mago) :-
    accionDe(Mago, _),
    not(accionDe(Mago, mala(_))).

accionRecurrente(Accion) :-
    accionDe(Mago, Accion),
    accionDe(OtroMago, Accion),
    Mago \= OtroMago.

%%%%%%%%%%%%%
%% Punto 2 %%
%%%%%%%%%%%%%

puntajeTotalDe(Casa, PuntajeTotal) :-
    casa(Casa),
    findall(Puntaje, puntajeDeUnaAccionEn(Casa, Puntaje), Puntajes),
    sumlist(Puntajes, PuntajeTotal).

    puntajeDeUnaAccionEn(Casa, Puntaje) :-
    esDe(Miembro, Casa),
    accionDe(Miembro, Accion),
    puntajeDe(Accion, Puntaje).

%%%%%%%%%%%%%
%% Punto 3 %%
%%%%%%%%%%%%%

ganadora(Casa) :-
    puntajeTotalDe(Casa, PuntajeMaximo),
    forall(casa(Casa), tieneMayorPuntaje(OtraCasa, PuntajeMaximo)).

tieneMayorPuntaje(OtraCasa, PuntajeMaximo) :-   
    puntajeTotalDe(OtraCasa, OtroPuntaje), 
    OtroPuntaje =< PuntajeMaximo.

%%%%%%%%%%%%%
%% Punto 4 %%
%%%%%%%%%%%%%

% Hecho
