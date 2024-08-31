comida(hamburguesa, 2000).
comida(panchitoConPapa, 1500).
comida(lomitoCompleto, 2500).
comida(caramelos, 0).

atraccion(autitosChocadores, tranquila(chicosYAdultos)).
atraccion(casaEmbrujada, tranquila(chicosYAdultos)).
atraccion(laberinto, tranquila(chicosYAdultos)).

atraccion(tobogan, tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

atraccion(barcoPirata, intensa(15)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorBosque, montaniaRusa(0, 45)).

atraccion(torpedoSalpicon, acuatica([9, 10, 11, 12, 1, 2, 3])).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, acuatica([9, 10, 11, 12, 1, 2, 3])).

%grupo(Grupo, Persona)
%visitante(Nombre, Edad, Dinero).
%sentimiento(Nombre, Hambre, Aburrimiento).

grupo(viejitos, eusebio).
visitante(eusebio, 80, 3000).
sentimiento(eusebio, 50, 0).

grupo(viejitos, carmela).
visitante(carmela, 80, 0).
sentimiento(carmela, 0, 25).

visitante(leo, 19, 0).
sentimiento(leo, 100, 0).

visitante(matiOchoPuntas, 19, 10000000000).
sentimiento(matiOchoPuntas, 100000000, 0).

%%%%%%%%%%%
% Punto 2 %
%%%%%%%%%%%

solitario(Visitante) :-
    visitante(Visitante, _, _),
    not(grupo(_, Visitante)).

bienestarDe(Visitante, felicidadPlena) :-
    cuanNecesitadoEsta(Visitante, 0),
    not(solitario(Visitante)).

cuanNecesitadoEsta(Visitante, CantidadDeNecesidad) :-
    sentimiento(Visitante, Hambruna, Aburrimiento),
    CuanNecesitadoEsta is Hambruna + Aburrimiento.

tieneUnaNecesidadEntre(Visitante, MoodMinimo, MoodMaximo) :-
    cuanNecesitadoEsta(Visitante, NecesidadActual),
    between(MoodMinimo, MoodMaximo, NecesidadActual).

bienestarDe(Visitante, podriaMejorar) :-
    tieneUnaNecesidadEntre(Visitante, 1, 50).

bienestarDe(Visitante, podriaMejorar) :-
    solitario(Visitante),
    cuanNecesitadoEsta(Visitante, 0).

bienestarDe(Visitante, necesitaEntretenerse) :-
    tieneUnaNecesidadEntre(Visitante, 51, 99).

bienestarDe(Visitante, irseACasa) :-
    cuanNecesitadoEsta(Visitante, CantidadDeNecesidad),
    CantidadDeNecesidad >= 100.

%%%%%%%%%%%
% Punto 3 %
%%%%%%%%%%%

satisfacerSuHambre(Grupo) :-
    grupo(Grupo, _),
    forall(grupo(Grupo, Integrante), tieneDineroParaAlimentarse(Integrante)).

tieneDineroParaAlimentarse(Persona) :-
    visitante(Persona, _, Guita),
    comidaSatisfactoria(Comida, Persona),
    comida(Comida, CuantoCuesta),
    Guita > CuantoCuesta.

comidaSatisfactoria(lomitoCompleto, _).
comidaSatisfactoria(hamburguesa, Persona) :- sentimiento(Persona, Hambruna, _), Hambruna < 50.
comidaSatisfactoria(panchitoConPapa, Persona) :- esChico(Persona).
comidaSatisfactoria(caramelos, Persona) :-
    forall(comida(_, CuantoDuele), not(puedeComprar(Persona, CuantoDuele))).

puedeComprar(Visitante, CuantoDuele) :-
    comida(Comida, CuantoCuesta),
    Guita > CuantoCuesta.

esChico(Persona) :-
    visitante(Persona, Edad, _),
    Edad < 13.

%%%%%%%%%%%
% Punto 4 %
%%%%%%%%%%%

hayLluviaDeHamburguesa(Visitante, Atraccion) :-
    puedeComprarseUnaBurga(Visitante),
    seSubeA(Visitante, Atraccion).

puedeComprarseUnaBurga(Visitante) :-
    visitante(Visitante, _, Guita),
    comida(hamburguesa, CuantoCuesta),
    Guita > CuantoCuesta.

seSubeA(_, tobogan).
seSubeA(Persona, Atraccion) :- atraccion(Atraccion, TipoAtraccion), atraccionLoca(Visitante, TipoAtraccion).

atraccionLoca(_, intensa(Coeficiente)) :-
    Coeficiente > 10.

atraccionLoca(Visitante, MontaniaRusa) :-
    peligrosidadDeLasMontaniasRusas(Persona, MontaniaRusa).

peligrosidadDeLasMontaniasRusas(Persona, montaniaRusa(GiroMaximo, _)) :-
    not(esChico(Persona)),
    not(bienestarDe(Persona, necesitaEntretenerse)),
    forall(atraccion(_, montaniaRusa(OtroGiro, _)), OtroGiro =< GiroMaximo).

peligrosidadDeLasMontaniasRusas(Persona, montaniaRusa(_, Duracion)) :-
    esChico(Persona),
    Duracion >= 60.

%%%%%%%%%%%
% Punto 5 %
%%%%%%%%%%%
