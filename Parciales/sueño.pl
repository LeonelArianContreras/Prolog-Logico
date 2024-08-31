%%%%%%%%%%%%%
%% Punto 1 %%
%%%%%%%%%%%%%

%suenio(Persona, Suenio).
suenio(gabriel, campanita).
suenio(gabriel, magoDeOz).
suenio(gabriel, cavenaghi).
suenio(juan, conejoDePascua).
suenio(macarena, reyesMagos).
suenio(macarena, magoCapria).
suenio(macarena, campanita).

%tipoDeSuenio(Nombre, TipoDeSueño).
tipoDeSuenio(gabriel, loteria(2)).
tipoDeSuenio(gabriel, futbolista(arsenal)).
tipoDeSuenio(juan, cantante(100000)).
tipoDeSuenio(macarena, cantante(10000)).

%%%%%%%%%%%%%
%% Punto 2 %%
%%%%%%%%%%%%%

ambiciosa(Persona) :-
    suenio(Persona, _),
    findall(Dificultad, dificultadDeUnSuenio(Persona, Dificultad), Dificultades),
    sumlist(Dificultades, TotalDeDificultades),
    TotalDeDificultades > 20.

dificultadDeUnSuenio(Persona, Dificultad) :-
    tipoDeSuenio(Persona, TipoDeSuenio),
    cuanDificilEsElSuenio(TipoDeSuenio, Dificultad).

cuanDificilEsElSuenio(cantante(Discos), 6) :- Discos > 500000.
cuanDificilEsElSuenio(cantante(Discos), 4) :- Discos < 500000.
cuanDificilEsElSuenio(loteria(NumerosApostados), Dificultad) :- Dificultad is NumerosApostados * 10.
cuanDificilEsElSuenio(futbolista(Equipo), 3) :- equipoChico(Equipo).
cuanDificilEsElSuenio(futbolista(Equipo), 16) :- not(equipoChico(Equipo)).

equipoChico(aldosivi).
equipoChico(arsenal).

%%%%%%%%%%%%%
%% Punto 3 %%
%%%%%%%%%%%%%

tieneQuimicaCon(Personaje, Persona) :-
    suenio(Persona, Personaje),
    condicionDeQuimica(Personaje, Persona).

condicionDeQuimica(campanita, Persona) :-
    dificultadDeUnSuenio(Persona, Dificultad),
    Dificultad < 5.

condicionDeQuimica(Personaje, Persona) :-
    Personaje \= campanita,
    tipoDeSuenio(Persona, TipoDeSuenio),
    suenioPuro(TipoDeSuenio),
    not(ambiciosa(Persona)).

suenioPuro(futbolista(_)).
suenioPuro(cantante(Discos)) :- Discos < 200000.

%%%%%%%%%%%%%
%% Punto 4 %%
%%%%%%%%%%%%%

amigueDe(campanita, reyesMagos).
amigueDe(campanita, conejoDePascua).
amigueDe(conejoDePascua, cavenaghi).

puedeAlegrarA(Personaje, Persona) :-
    suenio(Persona, Personaje).

puedeAlegrarA(Personaje, Persona) :-
    tieneQuimicaCon(Personaje, Persona),
    condicionesDeAlegria(Personaje).

condicionesDeAlegria(Personaje) :-
    not(estaEnfermo(Personaje)).

condicionesDeAlegria(Personaje) :-
    amigueDe(Personaje, OtroPersonaje),
    condicionesDeAlegria(OtroPersonaje).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).