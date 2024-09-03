padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).
madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge, maggie).
madreDe(selma, ling).

tieneHijo(Padre) :-
    padreDe(Padre, _).

tieneHijo(Madre) :-
    madreDe(Madre, _).

hermanos(Uno, Otro) :-
    mismoPapa(Uno, Otro),
    mismaMamucha(Uno, Otro).

mismoPapa(Uno, Otro) :-
    padreDe(Papa, Uno),
    padreDe(Papa, Otro),
    Uno \= Otro.

mismaMamucha(Uno, Otro) :-
    madreDe(Mama, Uno),
    madreDe(Mama, Otro),
    Uno \= Otro.

medioHermanos(Uno, Otro) :-
    mismaMamucha(Uno, Otro),
    not(mismoPapa(Uno, Otro)).

medioHermanos(Uno, Otro) :-
    mismoPapa(Uno, Otro),
    not(mismaMamucha(Uno, Otro)).

tioDe(Tio, Sobrino) :-
    hermanos(Tio, Chabon),
    progenitor(Chabon, Sobrino).

progenitor(Padre, Hijo) :-
    padreDe(Padre, Hijo).

progenitor(Madre, Hijo) :-
    madreDe(Madre, Hijo).

abueloMultiple(Abuelardo) :-
    progenitor(Abuelardo, Hijo),
    progenitor(Hijo, Nietardo1),
    progenitor(Hijo, Nietardo2),
    Nietardo1 \= Nietardo2.

abueloMultiple(Abuelardo) :-
    progenitor(Abuelardo, Hijo1),
    progenitor(Abuelardo, Hijo2),
    progenitor(Hijo1, _),
    progenitor(Hijo2, _),
    Hijo1 \= Hijo2.

descendiente(Descendiente, Antecesor) :-
    progenitor(Descendiente, Antecesor).

descendiente(Descendiente, Antecesor) :-
    progenitor(Descendiente, Hijo),
    descendiente(Hijo, Antecesor).


