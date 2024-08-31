%atencion(quien, dia, hora inicial, hora final)
atencion(dodain, lunes, 9, 15).
atencion(dodain, miercoles, 9, 15).
atencion(dodain, viernes, 9, 15).
atencion(leoC, lunes, 14, 18).
atencion(leoC, viernes, 14, 18).
atencion(lucas, martes, 10, 20).
atencion(juanC, sabado, 18, 22).
atencion(juanC, domingo, 18, 22).
atencion(juanFdS, jueves, 10, 20).
atencion(juanFdS, viernes, 12, 20).
atencion(martu, miercoles, 23, 24).

%%% Punto 1 %%%
atencion(vale, Dia, HorarioInicial, HorarioFinal) :- atencion(juanC, Dia, HorarioInicial, HorarioFinal).
atencion(vale, Dia, HorarioInicial, HorarioFinal) :- atencion(dodain, Dia, HorarioInicial, HorarioFinal).

%%% Punto 2 %%%
atiendeEl(Laburante, Dia, Horario) :-
    atencion(Laburante, Dia, HorarioInicial, HorarioFinal),
    between(HorarioInicial, HorarioFinal, Horario).

%%% Punto 3 %%%
foreverAlone(Laburante, Dia, Horario) :-
    atiendeEl(Laburante, Dia, Horario),
    not((atiendeEl(OtroLaburante, Dia, Horario), Laburante \= OtroLaburante)).

%%% Punto 4 %%%
quienAtiendeEl(Laburante, Dia) :-
    atencion(Laburante, _, _, _),
    atencion(_, Dia, _, _),
    forall(atencion(Laburante, Dia, _, _), atiendeEl(Laburante, Dia, _)).

%%% Punto 5 %%%
venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebidas(conAlcohol, 8), bebidas(sinAlcohol, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(sinAlcohol, 2), cigarrillos([derby])]).

personaSuertuda(Persona):-
    vendedora(Persona),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).
  
  vendedora(Persona):-venta(Persona, _, _).
  
  ventaImportante(golosinas(Precio)):-Precio > 100.
  ventaImportante(cigarrillos(Marcas)):-length(Marcas, Cantidad), Cantidad > 2.
  ventaImportante(bebidas(true, _)).
  ventaImportante(bebidas(_, Cantidad)):-Cantidad > 5.