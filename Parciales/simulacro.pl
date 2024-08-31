% De los juegos de ACCION -> nombre y precio
% De los juegos de rol -> nombre y cantidad de usuarios ACTIVOS y precio
% De los de puzzle -> nombre, cantidad de niveles, dificultad y precio

% Precio -> Con descuento o sin descuento
% tieneBuenDescuento si % de dto >= 50

% esPopular -> los de accion siempre
% esPopular -> los de rol si tienen > 1 000 000 de usuarios
% esPopular -> los de puzzle cuando tienen dificultad FACIL || tiene exactamente 25 niveles
% esPopular -> Minecraft
% esPopular -> Counter Strike

%usuario -> nombre, juegos que posee, juegos deseados
%futuraAdquisicion -> para él mismo || para otro
%usuarioConAdiccionDeDescuento -> TODO lo que quiere adquirir tiene dcto >= 50 (REPE DE LOGICA CON UNO DE LOS PRIMEROS PUNTOS)
%fanaticoDelGenero -> tiene >= 2 juegos de ese genero
%monotematicoDelGenero -> TODOS los juegos que posee son de ese genero

%buenosAmigos -> las futuras adquisiciones de cada uno son para regalos entre ellos dos
%cuantoDuele -> lo que cuesten las futuras compras para él o de regalo o ambas

%juego(Nombre, rol(Usuarios)).
juego(losSims, rol(100000)).
%juego(Nombre, puzzle(Niveles, Dificultad)).
juego(rompecabezas, puzzle(8, dificil)).
%juego(Nombre, accion(Precio)).
juego(rainbowSixSiege, accion).

%precio(Nombre, Guita).
precio(losSims, 12000).
precio(rompecabezas, 5000).
precio(rainbowSixSiege, 21000).

%descuentoDe(Nombre, PorcentajeDcto).
descuentoDe(rainbowSixSiege, 50).
descuentoDe(losSims, 15).

precioConDcto(Juego, CuantoDuele) :- %REPE DE LOGICA EN JUEGO Y DESCUENTO DE, TODO
    juego(Juego, _),
    precio(Juego, Precio),
    descuentoDe(Juego, PorcentajeDeDcto),
    CuantoDuele is Precio / PorcentajeDeDcto.

tieneBuenDescuento(Juego) :-
    juego(Juego, _),
    descuentoDe(Juego, PorcentajeDeDcto),
    PorcentajeDcto >= 50.

popular(Juego) :-
    juego(Juego, Caracteristicas),
    laPopularidad(Juego, Caracteristicas).

laPopularidad(_, accion).
laPopularidad(_, rol(CantidadUsuarios)) :- CantidadUsuarios > 1000000.
laPopularidad(_, puzzle(_, facil)).
laPopularidad(_, puzzle(25, _)).
laPopularidad(minecraft, _).
laPopularidad(counterStrike, _).

%usuarioTiene(Nombre, JuegoQuePosee, juegoParaAdquirir).
usuarioTiene(nico, minecraft).
usuarioTiene(nico, counterStrike).
usuarioTiene(mati, leagueOfLegends).

%juegoParaAdquirir(Quien, Juego, ParaQuien).
juegoParaAdquirir(nico, losSims, mati).
juegoParaAdquirir(nico, furry, mati).
juegoParaAdquirir(mati, ochoPuntas, paraSiMismo).
juegoParaAdquirir(mati, ageOfEmpires, nico).
juegoParaAdquirir(leo, colaDeJoaco, matiYNico).

adictoALosDctos(Usuario) :-
    juegoParaAdquirir(Usuario, _, _),
    forall(juegoParaAdquirir(Usuario, Juego, _), tieneBuenDescuento(Juego)).

adictoALosGeneros(Usuario, Genero) :-
    usuarioTiene(Usuario, Juego),
    mismoGenero(Usuario, Juego, Genero).

mismoGenero(Usuario, Juego, Genero) :-
    usuarioTiene(Usuario, OtroJuego),
    juego(Juego, Genero),
    juego(OtroJuego, Genero),
    Juego \= OtroJuego.

monotematico(Usuario, Genero) :-
    usuarioTiene(Usuario, _),
    usuarioTiene(_, Juego),
    forall(usuarioTiene(Usuario, Juego), mismoGenero(Usuario, Juego, Genero)).

buenosAmigos(Amigazo, OtroAmigazo) :-
    juegoParaAdquirir(Amigazo, Juego, OtroAmigazo),
    juegoParaAdquirir(OtroAmigazo, OtroJuego, Amigazo),
    popular(Juego),
    popular(OtroJuego).

% Finalmente, queremos saber cuánto gastará un usuario en función de sus futuras compras, regalos, o ambas %
cuantoDolera(Usuario, CuantoDoleraTodo) :-
    usuarioTiene(Usuario, _),
    findall(CuantoDueleUnJuego, precioDeUnaCompra(Usuario, CuantoDueleUnJuego), Dolores),
    sumlist(Dolores, CuantoDoleraTodo).

precioDeUnaCompra(Usuario, CuantoCuesta) :-
    juegoParaAdquirir(Usuario, Juego, _),
    cuantoCuestaActualmente(Juego, CuantoCuesta).

cuantoCuestaActualmente(Juego, CuantoDuele) :-
    precioConDcto(Juego, CuantoDuele).

cuantoCuestaActualmente(Juego, CuantoDuele) :-
    not(descuentoDe(Juego, _)),
    precio(Juego, CuantoDuele).