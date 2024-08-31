%%% PUNTO 1 %%%
/*Punto 1: El destino es así, lo se... (2 puntos)
Sabemos que Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas Doradas. Alf, en cambio, 
se va a Bariloche, San Martín de los Andes y El Bolsón. Nico se va a Mar del Plata, como siempre. Y Vale se va para Calafate y El Bolsón.

-Además Martu se va donde vayan Nico y Alf. 
-Juan no sabe si va a ir a Villa Gesell o a Federación
-Carlos no se va a tomar vacaciones por ahora

Se pide que defina los predicados correspondientes, y justifique sus decisiones en base a conceptos vistos en la cursada.
*/

viajaA(dodein, pehuenia).
viajaA(dodein, sanMartin).
viajaA(dodein, esquel).
viajaA(dodein, sarmiento).
viajaA(dodein, camarones).
viajaA(dodein, playasDoradas).
viajaA(alf, bariloche).
viajaA(alf, sanMartin).
viajaA(alf, elBolson).
viajaA(nico, marDelPlata).
viajaA(vale, calafate).
viajaA(vale, elBolson).

viajaA(martu, Lugar) :-
    viajaA(alf, Lugar).
    
viajaA(martu, Lugar) :-
    viajaA(nico, Lugar).

/* No se consideraria parte de la Base de Conocimiento Juan y Carlos ya que en esta misma se deben poner verdades absolutas, y por principio de
Universo Cerrado, todo lo que no está en la base, se considera falso.*/

%%% PUNTO 2 %%%

/*Punto 2: Vacaciones copadas (4 puntos)
Incorporamos ahora información sobre las atracciones de cada lugar. Las atracciones se dividen en
-un parque nacional, donde sabemos su nombre
-un cerro, sabemos su nombre y la altura
-un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si se puede pescar y la temperatura promedio del agua
-una playa: tenemos la diferencia promedio de marea baja y alta
-una excursión: sabemos su nombre


Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo modelaría las atracciones. 
Por ejemplo: Esquel tiene como atracciones un parque nacional (Los Alerces) y dos excursiones (Trochita y Trevelin). 
Villa Pehuenia tiene como atracciones un cerro (Batea Mahuida de 2.000 m) y dos cuerpos de agua (Moquehue, donde se puede pescar y 
tiene 14 grados de temperatura promedio y Aluminé, donde se puede pescar y tiene 19 grados de temperatura promedio).

Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a visitar tienen por lo menos una atracción copada. 
-un cerro es copado si tiene más de 2000 metros
-un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20
-una playa es copada si la diferencia de mareas es menor a 5
-una excursión que tenga más de 7 letras es copado
-cualquier parque nacional es copado
El predicado debe ser inversible. 
*/

tieneAtracciones(esquel, parqueNacional(losAlerces)).
tieneAtracciones(esquel, excursion(trochitas)).
tieneAtracciones(esquel, excursion(trevelin)).
tieneAtracciones(pehuenia, cerro(bateaMahuida, 2000)).
tieneAtracciones(pehuenia, cuerpoDeAgua(moquehue, pescable, 17)).
tieneAtracciones(pehuenia, cuerpoDeAgua(alumine, pescable, 19)).
tieneAtracciones(elBolson, playa(3)).

atraccionCopada(cerro(_, MetrosDeAlto)) :- MetrosDeAlto > 2000.
atraccionCopada(cuerpoDeAgua(_, pescable, Temperatura)) :- Temperatura > 20.
atraccionCopada(playa(DiferenciaDeMarea)) :- DiferenciaDeMarea < 5.


vacacionesCopadas(Persona) :-
    viajaA(Persona, _),
    forall(viajaA(Persona, Lugar), atraccionCopada(Lugar)).


%Punto 3: Ni se me cruzó por la cabeza (2 puntos)
%Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. 
%Por ejemplo, Dodain no se cruzó con Nico ni con Vale (sí con Alf en San Martín de los Andes). 
%Vale no se cruzó con Dodain ni con Nico (sí con Alf en El Bolsón). El predicado debe ser completamente inversible.

noSeCruzo(Persona, OtraPersona) :-
    viajaA(Persona, _),
    viajaA(OtraPersona, _),
    forall(viajaA(Persona, Destino), not(viajaA(OtraPersona, Destino))),
    Persona \= OtraPersona.


%%% PUNTO 4 %%%
%Queremos saber si unas vacaciones fueron gasoleras para una persona. Esto ocurre si todos los destinos son gasoleros, 
%es decir, tienen un costo de vida menor a 160. Alf, Nico y Martu hicieron vacaciones gasoleras.
%El predicado debe ser inversible.

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartin, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

destinoGasolero(Destino) :-
    costoDeVida(Destino, CostoDeVida),
    CostoDeVida < 160.

tuvoVacacionesGasoleras(Persona) :-
    viajaA(Persona, _),
    forall(viajaA(Persona, Destino), destinoGasolero(Destino)).

%%% PUNTO 5 %%%
%Queremos conocer todas las formas de armar el itinerario de un viaje para una persona sin importar el recorrido. 
%para eso todos los destinos tienen que aparecer en la solución (no pueden quedar destinos sin visitar).

%Por ejemplo, para Alf las opciones son
%[bariloche, sanMartin, elBolson]
%[bariloche, elBolson, sanMartin]
%[sanMartin, bariloche, elBolson]
%[sanMartin, elBolson, bariloche]
%[elBolson, bariloche, sanMartin]
%[elBolson, sanMartin, bariloche]

%(claramente no es lo mismo ir primero a El Bolsón y después a Bariloche que primero a Bariloche y luego a El Bolsón, 
%pero el itinerario tiene que incluir los 3 destinos a los que quiere ir Alf).
permutarDestinos([], []).
permutarDestinos(Viajes, [PrimerDestino | OtrosDestinos]) :-
    
    permutarDestinos(Viajes, OtrosDestinos).

itinerariosDeViajeDe(Persona) :-
    viajaA(Persona, _),
    findall(Viaje, viajaA(Persona, Viaje), Viajes).
    permutarDestinos(Viajes, NuevosViajes).
