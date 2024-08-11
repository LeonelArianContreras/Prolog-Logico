linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,pueyrredonB,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,pueyrredonD,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[lasHeras,santaFe,corrientes,once,venezuela,humberto1ro,inclan,caseros]).
combinacion([lima, avMayo]).
combinacion([once, miserere]).
combinacion([pellegrini, diagNorte, nueveJulio]).
combinacion([independenciaC, independenciaE]).
combinacion([jujuy, humberto1ro]).
combinacion([santaFe, pueyrredonD]).
combinacion([corrientes, pueyrredonB]).

%estaEn/2: en qué línea está una estación.
estaEn(Linea, Estacion) :-
    linea(Linea, Estaciones),
    member(Estacion, Estaciones).

%distancia/3: dadas dos estaciones de la misma línea, cuántas estaciones hay entre ellas: por ejemplo, entre Perú y Primera Junta hay 5 estaciones.
numeroEstacion(Indice, UnaEstacion) :-
    estaEn(Linea, UnaEstacion),
    linea(Linea, Estaciones),
    nth1(Indice, Estaciones, UnaEstacion).

mismaLinea(Estacion, OtraEstacion) :-
    estaEn(Linea, Estacion),
    estaEn(Linea, OtraEstacion).

distancia(UnaEstacion, OtraEstacion, Distancia) :-
    mismaLinea(UnaEstacion, OtraEstacion),
    numeroEstacion(Posicion1, UnaEstacion),
    numeroEstacion(Posicion2, OtraEstacion),
    CantidadEstaciones is Posicion1 - Posicion2,
    abs(CantidadEstaciones, Distancia).

%mismaAltura/2: dadas dos estaciones de distintas líneas, si están a la misma altura (o sea, las dos terceras, las dos quintas, etc.), por ejemplo: Pellegrini y Santa Fe están ambas segundas.
mismaAltura(UnaEstacion, OtraEstacion) :-
    estaEn(Linea1, UnaEstacion),
    estaEn(Linea2, OtraEstacion),
    Linea1 \= Linea2,
    numeroEstacion(Posicion, UnaEstacion),
    numeroEstacion(Posicion, OtraEstacion).

%granCombinacion/1: se cumple para una combinación de más de dos estaciones.
granCombinacion(Estaciones) :-
    combinacion(Estaciones),
    length(Estaciones, Cantidad),
    Cantidad > 2.

%cuantasCombinan/2: dada una línea, relaciona esa línea con la cantidad de estaciones de esa línea que tienen alguna combinación. Por ejemplo, la línea C tiene 3 estaciones que combinan (avMayo, diagNorte e independenciaC).
cuantasCombinan(Linea, CantidadCombinaciones) :-
    linea(Linea, _),
    findall(Estacion, estacionesQueCombinan(Estacion, Linea), EstacionesCombinatorias),
    length(EstacionesCombinatorias, CantidadCombinaciones).

estacionesQueCombinan(Estacion, Linea) :-
    estaEn(Linea, Estacion),
    combinacion(Combinaciones),
    member(Estacion, Combinaciones).

%lineaMasLarga/1: es verdadero para la línea con más estaciones.
lineaMasLarga(Linea) :-
    linea(Linea, Estaciones),
    length(Estaciones, CantidadEstaciones),
    forall(linea(_, OtrasEstaciones), masEstaciones(CantidadEstaciones, OtrasEstaciones)).

masEstaciones(CantidadEstaciones, OtrasEstaciones) :-
    length(OtrasEstaciones, OtraCantidadEstaciones),
    CantidadEstaciones >= OtraCantidadEstaciones.

%viajeFacil/2: dadas dos estaciones, si puedo llegar fácil de una a la otra; esto es, si están en la misma línea, o bien puedo llegar con una sola combinación.

viajeFacil(Estacion, OtraEstacion) :-
    mismaLinea(Estacion, OtraEstacion).

viajeFacil(Estacion, OtraEstacion) :-
    estaEn(_, Estacion),
    estaEn(_, OtraEstacion),
    combinacion(Combinaciones),
    member(Estacion, Combinaciones),
    member(OtraEstacion, Combinaciones).




