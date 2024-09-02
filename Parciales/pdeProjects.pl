miembro(juani, devSenior).
miembro(emi, devOps).
miembro(lucas, devJunior).
miembro(tomi, devSemiSenior).
miembro(dante, devSemiSenior).
miembro(manu, administradorDeBBD).
miembro(gus, administradorDeBBD).

desarrollador(devSenior).
desarrollador(devOps).
desarrollador(devJunior).
desarrollador(devSemiSenior).

%tareaAsignada(Developer, NombreDeTarea).
%tarea(NombreDeTarea, Estado, Tipo).

tareaAsignada(lucas, comoAlumnoQuieroProgramarEnHaskell).
tareaAsignada(juani, comoDocenteQuieroActualizarAWollokTS).
tareaAsignada(emi, reescribirLinuxEnProlog).
tareaAsignada(gus, parciales).
tareaAsignada(tomi, comoAlumnoQuieroRendirElParcialDeFuncional).
tareaAsignada(dante, comoDocenteQuieroCambiarElTP4DeLogico).
tareaAsignada(juani, pensarConsignasParaElDesafioCafeConLeche).
tareaAsignada(emi, comoDocenteQuieroTenerUnRepoParaDesafios).
tareaAsignada(juani, pensarConsignasParaElDesafioCafeConLeche).

tarea(comoAlumnoQuieroProgramarEnHaskell, progreso, historiaDeUsuario(5)).
tarea(comoDocenteQuieroActualizarAWollokTS, terminada, historiaDeUsuario(3)).
tarea(chatGPTSePresentoARendirElParcial, paraHacer, bug).
tarea(reescribirLinuxEnProlog, paraHacer, spike(infraestructura)).
tarea(estudiarElLibroGamma, paraHacer, spike(biblioteca)).
tarea(parciales, progreso, epica).
tarea(comoAlumnoQuieroRendirElParcialDeFuncional, terminada, historiaDeUsuario(4)).
tarea(comoAlumnoQuieroRendirElParcialDeLogico, progreso, historiaDeUsuario(3)).
tarea(comoAlumnoQuieroRendirElParcialDeObjetos, porHacer, historiaDeUsuario(6)).
tarea(elegirUnDominioParaElParcialDeObjetos, paraHacer, spike(biblioteca)).
tarea(comoDocenteQuieroCambiarElTP4DeLogico, progreso, historiaDeUsuario(2)).
tarea(pensarConsignasParaElDesafioCafeConLeche, progreso, spike(biblioteca)).
tarea(comoDocenteQuieroTenerUnRepoParaDesafios, paraHacer, historiaDeUsuario(1)).


%%%%%%%%%%%%%
%% Parte 1 %%
%%%%%%%%%%%%%

estaDisponible(Tarea) :-
    tarea(Tarea, paraHacer, _),
    not(tareaAsignada(_, Tarea)).

dificultadDe(Tarea, Persona, Dificultad) :-
    tareaAsignada(Persona, Tarea),
    tarea(Tarea, _, TipoDeTarea),
    cuanDificilEs(TipoDeTarea, Dificultad, Persona).

cuanDificilEs(historiaDeUsuario(Horas), facil, _) :- between(1, 3, Horas).
cuanDificilEs(historiaDeUsuario(4), normal, _).
cuanDificilEs(historiaDeUsuario(Horas), dificil, _) :- Horas >= 5.
cuanDificilEs(bug, normal, Persona) :- esDevSenior(Persona).
cuanDificilEs(bug, dificil, Persona) :- not(esDevSenior(Persona)).
cuanDificilEs(spike(Area), facil, Persona) :- spikeEsFacilPara(Persona, Area).
cuanDificilEs(spike(Area), dificil, Persona) :- not(spikeEsFacilPara(Persona, Area)).
cuanDificilEs(epica, dificil, _).

spikeEsFacilPara(Persona, Area) :-
    miembro(Persona, Rol),
    laburaDe(Rol, Area).

laburaDe(devOps, infraestructura).
laburaDe(Rol, biblioteca) :- desarrollador(Rol).
laburaDe(administradorDeBBD, triggers).

esDevSenior(Persona) :-
    miembro(Persona, devSenior).

puedeTomar(Persona, Tarea) :-
    estaDisponible(Tarea),
    miembro(Persona, _),
    not(dificultadDe(Tarea, Persona, dificil)).

%%%%%%%%%%%%%
%% Parte 2 %%
%%%%%%%%%%%%%

squad(hooligans, juani).
squad(hooligans, emi).
squad(hooligans, tomi).
squad(isotopos, dante).
squad(isotopos, manu).
squad(cools, lucas).
squad(cools, gus).

puntosDe(Squad, Puntos) :-
    squad(Squad, Miembro),
    findall(Horas, horasDe(Miembro, Horas), TodasLasHoras),
    sumlist(TodasLasHoras, Puntos).

horasDe(Miembro, Horas) :-
    tareaAsignada(Miembro, Tarea),
    tarea(Tarea, terminada, historiaDeUsuario(Horas)).

tienenLaburoLosDe(Squad) :-
    squad(Squad, _),
    forall(squad(Squad, Miembro), estaLaburando(Miembro)).

estaLaburando(Miembro) :-
    tareaAsignada(Miembro, _).

elMasLaburador(Squad) :-
    puntosDe(Squad, PuntajeMaximo),
    forall(squad(OtraSquad, _), menorPuntaje(OtraSquad, PuntajeMaximo)).

menorPuntaje(OtraSquad, PuntajeMaximo) :-
    puntosDe(OtraSquad, OtroPuntaje),
    OtroPuntaje =< PuntajeMaximo.

%%%%%%%%%%%%%
%% Parte 3 %%
%%%%%%%%%%%%%

%subtareaDe(NombreDeTareaMadre, NombreDeSubtarea).
subtareaDe(parciales, comoAlumnoQuieroRendirElParcialDeFuncional).
subtareaDe(parciales, comoAlumnoQuieroRendirElParcialDeLogico).
subtareaDe(parciales, comoAlumnoQuieroRendirElParcialDeObjetos).
subtareaDe(comoAlumnoQuieroRendirElParcialDeObjetos, elegirUnDominioParaElParcialDeObjetos).
subtareaDe(comoAlumnoQuieroRendirElParcialDeObjetos, estudiarElLibroGamma).
subtareaDe(pensarConsignasParaElDesafioCafeConLeche, comoDocenteQuieroTenerUnRepoParaDesafios).

numeroDeSubtareasDe(TareaMadre, TotalDeSubtareas) :-
    tarea(TareaMadre, _, _),
    findall(Subtarea, tareaMadreDe(TareaMadre, Subtarea), Subtareas),
    length(Subtareas, TotalDeSubtareas).

tareaMadreDe(Tarea, Subtarea) :-
    subtareaDe(Tarea, Subtarea).

tareaMadreDe(Tarea, Subtarea) :-
    subtareaDe(Tarea, OtraSubtarea),
    tareaMadreDe(OtraSubtarea, Subtarea).

%%% Redacten mejor el ultimo punto, por favor! No entiendo una gominola %%%