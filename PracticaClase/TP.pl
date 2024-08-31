/* Civilizaciones y tecnologías

Parte 1:

1) Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías, de la forma más conveniente para resolver los siguientes puntos. 
Incluir los siguientes ejemplos:
-Ana, que juega con los romanos y ya desarrolló las tecnologías de herrería, forja, fundición y láminas.
-Beto, que juega con los incas y ya desarrolló herrería, forja y fundición.
-Carola, que juega con los romanos y sólo desarrolló la herrería.
-Dimitri, que juega con los romanos y ya desarrolló herrería y emplumado.
-Elsa no juega esta partida.

2) Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, forja y 
o bien desarrolló fundición o bien juega con los romanos. 
En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.

3) Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno). 
En los ejemplos, los romanos son una  civilización popular, pero los incas no.

4) Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla. 
En los ejemplos, la herrería tiene alcance global,  pues Ana, Beto, Carola y Dimitri la desarrollaron.

5) Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las tecnologías que alcanzaron las demás. 
Una civilización alcanzó una tecnología cuando algún jugador de esa civilización la desarrolló.
En los ejemplos, los romanos son una civilización líder pues entre Ana y Dimitri, que juegan con romanos, ya tienen todas las tecnologías que se alcanzaron.
*/

%%% 1 %%%
jugador(ana, imperioRomano).
jugador(ana, imperioRomano).
jugador(ana, imperioRomano).
jugador(ana, imperioRomano).
jugador(beto, inca).
jugador(beto, inca).
jugador(beto, inca).
jugador(carola, imperioRomano).
jugador(dimitri, imperioRomano).
jugador(dimitri, imperioRomano).

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, fundicion).
desarrollo(ana, laminas).
desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).
desarrollo(carola, herreria).
desarrollo(dimitri, herreria).
desarrollo(dimitri, emplumado).

%%% 2 %%%
plusDeExperto(Jugador) :- jugador(Jugador, imperioRomano).
plusDeExperto(Jugador) :- desarrollo(Jugador, fundicion).

esExpertoEnMetales(Jugador) :-
    laburante(Jugador),
    plusDeExperto(Jugador).

laburante(Jugador) :-
    desarrollo(Jugador, herreria),
    desarrollo(Jugador, forja).

%%% 3 %%%
civilizacionPopular(Civilizacion) :- 
    jugador(Jugador, Civilizacion),
    jugador(OtroJugador, Civilizacion),
    Jugador \= OtroJugador.

%%% 4 %%%
tieneAlcanceGlobal(Tecnologia) :-
    desarrollo(_, Tecnologia),
    forall(jugador(Jugador, _), jugador(Jugador, Tecnologia)).

%%% 5 %%%
tieneCadaTecnologia(Civilizacion, Tecnologia) :-
    jugador(Jugador, Civilizacion),
    desarrollo(Jugador, Tecnologia).

civilizacionLider(Civilizacion) :-
    jugador(_, Civilizacion),
    forall(desarrollo(_, Tecnologia), tieneCadaTecnologia(Civilizacion, Tecnologia)).

/* Parte 2:

No se puede ganar la guerra sin soldados. Las unidades que existen son los campeones (con vida de 1 a 100), los jinetes 
(que los puede haber a caballo o a camello) y los piqueros, que tienen un nivel de 1 a 3, y pueden o no tener escudo.

1) Modelar lo necesario para representar las distintas unidades de cada jugador de la forma más conveniente para resolver los siguientes puntos. Incluir los siguientes ejemplos:
- Ana tiene un jinete a caballo, un piquero con escudo de nivel 1, y un piquero sin escudo de nivel 2.
- Beto tiene un campeón de 100 de vida, otro de 80 de vida, un piquero con escudo nivel 1 y un jinete a camello.
- Carola tiene un piquero sin escudo de nivel 3 y uno con escudo de nivel 2.
- Dimitri no tiene unidades.

2) Conocer la unidad con más vida que tiene un jugador, teniendo en cuenta que:
- Los jinetes a camello tienen 80 de vida y los jinetes a caballo tienen 90.
- Cada campeón tiene una vida distinta.
- Los piqueros sin escudo de nivel 1 tienen vida 50, los de nivel 2 tienen vida 65 y los de nivel 3 tienen 70 de vida.
- Los piqueros con escudo tienen 10% más de vida que los piqueros sin escudo.
	En los ejemplos, la unidad más “viva” de Ana es el jinete a caballo, pues tiene 90 de vida, y ninguno de sus dos piqueros tiene tanta vida.

3) Queremos saber si una unidad le gana a otra. Las unidades tienen una ventaja por tipo sobre otras. Cualquier jinete le gana a cualquier campeón, cualquier campeón le gana a cualquier piquero y cualquier piquero le gana a cualquier jinete, pero los jinetes a camello le ganan a los a caballo. En caso de que no exista ventaja entre las unidades, se compara la vida (el de mayor vida gana). 
Este punto no necesita ser inversible.
    Por ejemplo, un campeón con 95 de vida le gana a otro con 50, pero un campeón con 100 de vida no le gana a un jinete a caballo.

4) Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más piqueros con escudo que sin escudo.
    En los ejemplos, Beto es el único que puede sobrevivir a un asedio, pues tiene 1 piquero con escudo y 0 sin escudo.

5) Árbol de tecnologías
A. Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. Hasta no desarrollar una, no se puede desarrollar la siguiente. 
B. Saber si un jugador puede desarrollar una tecnología, que se cumple cuando ya desarrolló todas sus dependencias (las directas y las indirectas). 
Considerar que pueden existir árboles de cualquier tamaño.
    En el ejemplo, beto puede desarrollar el molino (pues no tiene dependencias) pero no la herrería (porque ya la tiene), y 
    ana puede desarrollar horno (pues tiene herrería, forja y fundición).
*/

%%% PUNTO 1 %%%
%tropa(Persona, Unidad).
tropa(ana, jinete(caballo)).
tropa(ana, piquero(1, conEscudo)).
tropa(ana, piquero(2, sinEscudo)).
tropa(beto, campeon(100)).
tropa(beto, campeon(80)).
tropa(beto, piquero(1, conEscudo)).
tropa(beto, jinete(camello)).
tropa(carola, piquero(3, sinEscudo)).
tropa(carola, piquero(2, conEscudo)).

%%% PUNTO 2 %%%
%vidaDeTropa(Unidad, Vida)
vidaDeTropa(jinete(caballo), 90).
vidaDeTropa(jinete(camello), 80).
vidaDeTropa(piquero(1, conEscudo), 55).
vidaDeTropa(piquero(1, sinEscudo), 50).
vidaDeTropa(piquero(2, conEscudo), 71.5).
vidaDeTropa(piquero(2, sinEscudo), 65).
vidaDeTropa(piquero(3, conEscudo), 77).
vidaDeTropa(piquero(3, sinEscudo), 70).
vidaDeTropa(campeon(Salud), Salud).

masVidaQueOtraTropa(OtraUnidad, Vida) :-
    vidaDeTropa(OtraUnidad, OtraVida),
    OtraVida =< Vida.

tropaConMasVida(Persona, UnidadMaxDeVida) :-
    tropa(Persona, UnidadMaxDeVida),
    vidaDeTropa(UnidadMaxDeVida, Vida),
    forall(tropa(Persona, OtraUnidad), masVidaQueOtraTropa(OtraUnidad, Vida)).

%%% PUNTO 3 %%%
ventajaSobre(jinete(_), campeon(_)).
ventajaSobre(campeon(_), piquero(_, _)).
ventajaSobre(piquero(_, _), jinete(_)).
ventajaSobre(jinete(camello), jinete(caballo)).

leGanaA(Tropa, OtraTropa) :- ventajaSobre(Tropa, OtraTropa).

leGanaA(Tropa, OtraTropa) :-
    not(ventajaSobre(Tropa, OtraTropa)),
    vidaDeTropa(Tropa, Vida),
    masVidaQueOtraTropa(OtraTropa, Vida).

%%% PUNTO 4 %%%
piquero(CantidadDePiquero, TipoDeEscudero) :-
    findall(_, TipoDeEscudero, Piqueros),
    length(Piqueros, CantidadDePiquero).

sobreviveAsedio(Jugador) :-
    tropa(Jugador, _),
    piquero(CantidadDeEscuderos, tropa(Jugador, piquero(_, conEscudo))),
    piquero(CantidadDeDesnudos, tropa(Jugador, piquero(_, sinEscudo))),
    CantidadDeEscuderos > CantidadDeDesnudos.

%%% PUNTO 5.A %%%
%dependeDe(TecnologiaHija, TecnologiaMadre)
dependeDe(emplumado, herreria).
dependeDe(forja, herreria).
dependeDe(laminas, herreria).
dependeDe(punzon, emplumado).
dependeDe(fundicion, forja).
dependeDe(horno, forja).
dependeDe(malla, laminas).
dependeDe(placas, laminas).
dependeDe(collera, molino).
dependeDe(arado, collera).

tecnologia(herreria).
tecnologia(emplumado).
tecnologia(laminas).
tecnologia(punzon).
tecnologia(forja).
tecnologia(horno).
tecnologia(fundicion).
tecnologia(placas).
tecnologia(collera).
tecnologia(molino).
tecnologia(arado).
tecnologia(malla).

dependencia(Tecnologia, OtraTecnologia) :-
    dependeDe(Tecnologia, OtraTecnologia).

dependencia(Tecnologia, OtraTecnologia) :-
    dependeDe(Tecnologia, TercerTecnologia),
    dependencia(TercerTecnologia, OtraTecnologia).

%%% PUNTO 5.B %%%
desarrollaTecnologia(Jugador, TecnologiaADesarrollar) :-
    jugador(Jugador, _),
    tecnologia(TecnologiaADesarrollar),
    not(desarrollo(Jugador, TecnologiaADesarrollar)),
    forall(dependencia(TecnologiaADesarrollar, TecnologiasDesarrolladas), desarrollo(Jugador, TecnologiasDesarrolladas)).
    