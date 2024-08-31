% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, littoNebbia], hipodromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%Itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con el mismo nombre y las mismas bandas en el mismo orden.
itinerante(Festival) :-
    festival(Festival, Bandas, Lugar),
    festival(Festival, Bandas, OtroLugar),
    Lugar \= OtroLugar.

%careta/1: Decimos que un festival es careta si no tiene campo o si es el personalFest.
caretaje(personalFest).

careta(Festival) :-
    festival(Festival, _, _),
    not(entradaVendida(Festival, campo)). 

%nacAndPop/1: Un festival es nac&pop si no es careta y todas las bandas que tocan en él son de nacionalidad argentina y tienen popularidad mayor a 1000.
nacionalmentePopulares(UnaBanda) :-
    banda(UnaBanda, argentina, Popularidad),
    Popularidad > 1000.

nacAndPop(Festival) :-
    festival(Festival, Bandas, _),
    not(careta(Festival)),
    forall(member(UnaBanda, Bandas), nacionalmentePopulares(UnaBanda)).

%sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la capacidad del lugar donde se realizan.
%Nota: no hace falta contemplar si es un festival itinerante.
sobrevendido(Festival) :-
    festival(Festival, _, Lugar),
    lugar(Lugar, CantidadMaxima, _),
    findall(Venta, entradaVendida(Festival, Venta), Ventas),
    length(Ventas, CantidadVendida),
    CantidadVendida > CantidadMaxima.

%recaudaciónTotal/2: Relaciona un festival con el total recaudado con la venta de entradas. Cada tipo de entrada se vende a un precio diferente:
%- El precio del campo es el precio base del lugar donde se realiza el festival.
%- La platea general es el precio base del lugar más el plus que se p aplica a la zona. 
%- Las plateas numeradas salen el triple del precio base para las filas de atrás (>10) y 6 veces el precio base para las 10 primeras filas.
%Nota: no hace falta contemplar si es un festival itinerante.
precioPorEntrada(campo, Lugar, PrecioBase) :- lugar(Lugar, _, PrecioBase).

precioPorEntrada(plateaGeneral(Sector), Festival, Venta) :- 
    lugar(Lugar, _, PrecioBase), 
    plusZona(Lugar, Sector, PrecioPlus), 
    Venta is PrecioBase + PrecioPlus.

precioPorEntrada(plateaNumerada(Fila), Lugar, Venta) :-
    lugar(Lugar, _, PrecioBase),
    Fila > 10,
    Venta is PrecioBase * 3.

precioPorEntrada(plateaNumerada(Fila), Lugar, Venta) :-
    lugar(Lugar, _, PrecioBase),
    Fila =< 10,
    Venta is PrecioBase * 6.
    
recaudacionTotal(Festival, TotalRecaudado) :-
    festival(Festival, _, Lugar),
    entradaVendida(Festival, Entrada),
    findall(Venta, precioPorEntrada(Entrada, Lugar, Venta), Ventas),
    sumlist(Ventas, TotalRecaudado).

%delMismoPalo/2: Relaciona dos bandas si tocaron juntas en algún recital o si una de ellas tocó con una banda del mismo palo que la otra, pero más popular.
tocoJuntoA(Banda, OtraBanda) :-
    festival(_, TodasLasBandas, _),
    member(Banda, TodasLasBandas),
    member(OtraBanda, TodasLasBandas).

delMismoPalo(Banda, OtraBanda) :- tocoJuntoA(Banda, OtraBanda).

delMismoPalo(Banda, OtraBanda) :-
    tocoJuntoA(Banda, TercerBanda),
    banda(TercerBanda, _, PopularidadTercerBanda),
    banda(OtraBanda, _, PopularidadOtraBanda),
    PopularidadTercerBanda > PopularidadOtraBanda,
    delMismoPalo(OtraBanda, TercerBanda).

