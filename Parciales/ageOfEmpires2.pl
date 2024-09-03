% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

%%%%%%%%%%%%%
%% Punto 1 %%
%%%%%%%%%%%%%

esUnAfano(Jugador, OtroJugador) :-
    jugador(Jugador, Rating, _),
    jugador(OtroJugador, OtroRating, _),
    Diferencia is Rating - OtroRating,
    Diferencia > 500.

%%%%%%%%%%%%%
%% Punto 2 %%
%%%%%%%%%%%%%

esEfectivo(Unidad, OtraUnidad) :-
    militar(Unidad, _, Categoria),
    militar(OtraUnidad, _, OtraCategoria),
    leGanaA(Unidad, Categoria, OtraCategoria).

leGanaA(_, caballeria, arqueria).
leGanaA(_, arqueria, infanteria).
leGanaA(_, infanteria, piquero).
leGanaA(_, piquero, caballeria).
leGanaA(samurai, _, unica).

%%%%%%%%%%%%%
%% Punto 3 %%
%%%%%%%%%%%%%

alarico(Jugador) :-
    todaTropaDe(Jugador, infanteria).

%%%%%%%%%%%%%
%% Punto 4 %%
%%%%%%%%%%%%%

leonidas(Jugador) :-
    todaTropaDe(Jugador, piquero).
    
todaTropaDe(Jugador, Categoria) :-
    jugador(Jugador, _, _),
    forall(tiene(Jugador, Unidad), militar(Unidad, _, Categoria)).

%%%%%%%%%%%%%
%% Punto 5 %%
%%%%%%%%%%%%%

nomada(Jugador) :-
    jugador(Jugador, _, _),
    not(tiene(Jugador, edificio(_, _))).

%%%%%%%%%%%%%
%% Punto 6 %%
%%%%%%%%%%%%%

%costeDe(Aldeano, Costo(Madera, Alimento, Oro))
costeDeAldeano(costo(0, 50, 0)).
costeDeCarretaYUrnaMercante(costo(100, 0, 50)).

cuantoCuesta(Tenencia, Costo) :-
    tiene(_, Tenencia),
    costoDe(Tenencia, Costo).

costoDe(unidad(Unidad, _), Costo) :- militar(Unidad, Costo, _).
costoDe(edificio(Construccion, _), Costo) :- edificio(Construccion, Costo).
costoDe(unidad(Unidad, _), Costo) :- aldeano(Unidad, _), costeDeAldeano(Costo).
costoDe(unidad(Unidad, _), Costo) :- unidadEspecial(Unidad), costeDeCarretaYUrnaMercante(Costo).

unidadEspecial(carreta).
unidadEspecial(urnaMercante).

%%%%%%%%%%%%%
%% Punto 7 %%
%%%%%%%%%%%%%

produccionPorMinuto(Unidad, Produccion) :-
    tiene(_, unidad(Unidad, _)),
    cuantoProduce(Unidad, Produccion).

cuantoProduce(Unidad, Produccion) :- aldeano(Unidad, Produccion).
cuantoProduce(keshik, produce(0,0, 10)).
cuantoProduce(Unidad, Produccion) :- unidadEspecial(Unidad), produccionCarretaYUrnaMercante(Produccion).

produccionCarretaYUrnaMercante(produce(0, 0, 32)).

%%%%%%%%%%%%%
%% Punto 8 %%
%%%%%%%%%%%%%
    
recurso(oro).
recurso(madera).
recurso(alimento).

%produccionTotalPorMinuto(pepe, oro, produce(10000,0,0))
produccionTotalPorMinuto(Jugador, Recurso, ProduccionTotal) :-
    jugador(Jugador, _, _),
    recurso(Recurso),
    findall(Produccion, produccionDe(Jugador, Recurso, Produccion), Producciones),
    sumlist(Producciones, ProduccionTotal).

produccionDe(Jugador, Recurso, ProduccionTotal) :-
    tiene(Jugador, unidad(Unidad, CuantasUnidades)),
    produccionPorMinuto(Unidad, Produccion),
    produccionDeRecurso(Produccion, Recurso, Cuanto),
    ProduccionTotal is Cuanto * CuantasUnidades.

produccionDeRecurso(produce(_, _, Oro), oro, Oro).
produccionDeRecurso(produce(_, Alimento, _), alimento, Alimento).
produccionDeRecurso(produce(Madera, _, _), madera, Madera).

%%%%%%%%%%%%%
%% Punto 9 %%
%%%%%%%%%%%%%

estaPeleado(Jugador, OtroJugador) :-
    noSeAfananMutuamente(Jugador, OtroJugador),
    mismaCantidadDeUnidades(Jugador, OtroJugador),
    diferenciaDeProduccionesTotales(Jugador, OtroJugador, Diferencia),
    Diferencia < 100.

totalDeUnidadesDe(Jugador, CantidadTotal) :-
    findall(Cantidad, tiene(Jugador, unidad(_, Cantidad)), Cantidades),
    sumlist(Cantidades, CantidadTotal).

produccionDeTodosLosRecursos(Jugador, TotalDeProducciones) :-
    produccionTotalPorMinuto(Jugador, madera, ProduccionDeMadera),
    produccionTotalPorMinuto(Jugador, alimento, ProduccionDeAlimento),
    produccionTotalPorMinuto(Jugador, oro, ProduccionDeOro),
    TotalDeProducciones is (ProduccionDeMadera * 3) + (ProduccionDeAlimento * 2) + (ProduccionDeOro * 5).

noSeAfananMutuamente(Jugador, OtroJugador) :-
    jugador(Jugador, _, _),
    jugador(OtroJugador, _, _),
    not(esUnAfano(Jugador, OtroJugador)),
    not(esUnAfano(OtroJugador, Jugador)).

mismaCantidadDeUnidades(Jugador, OtroJugador) :-
    totalDeUnidadesDe(Jugador, Cantidad),
    totalDeUnidadesDe(OtroJugador, Cantidad).

diferenciaDeProduccionesTotales(Jugador, OtroJugador, Diferencia) :-
    produccionDeTodosLosRecursos(Jugador, TotalDeProduccion),
    produccionDeTodosLosRecursos(OtroJugador, OtroTotalDeProduccion),
    Diferencia is TotalDeProduccion - OtroTotalDeProduccion,
    abs(Diferencia, Diferencia).

%%%%%%%%%%%%%%
%% Punto 10 %%
%%%%%%%%%%%%%%

avanzaA(Jugador, Edad) :-
    tiene(Jugador, edificio(Construccion, _)),
    seAvanza(Jugador, Edad, Construccion).

seAvanza(_, edadMedia, _).

seAvanza(Jugador, edadFeudal, casa) :- 
    produccionTotalPorMinuto(Jugador, alimento, ProduccionDeAlimentos),
    ProduccionDeAlimentos > 500.

seAvanza(Jugador, edadCastillo, Construccion) :-
    produccionesDeOroYAlimentosSuficientes(Jugador, 800, 200),
    tieneLosRequisitosDeEdadCastillo(Construccion).

seAvanza(Jugador, edadImperial, Construccion) :-
    produccionesDeOroYAlimentosSuficientes(Jugador, 1000, 800),
    tieneLosRequisitosDeEdadImperial(Construccion).
    
tieneLosRequisitosDeEdadCastillo(herreria).
tieneLosRequisitosDeEdadCastillo(establo).
tieneLosRequisitosDeEdadCastillo(galeriaDeTiro).

tieneLosRequisitosDeEdadImperial(castillo).
tieneLosRequisitosDeEdadImperial(universidad).

produccionesDeOroYAlimentosSuficientes(Jugador, SuficienteAlimento, SuficienteOro) :-
    produccionTotalPorMinuto(Jugador, alimento, ProduccionDeAlimentos),
    produccionTotalPorMinuto(Jugador, oro, ProduccionDeOro),
    ProduccionDeAlimentos > SuficienteAlimento,
    ProduccionDeOro > SuficienteOro.