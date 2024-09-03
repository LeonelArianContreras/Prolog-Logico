member(Elemento, Lista).
forall(Universo, Consecuente).
%findall(Elemento_De_La_Lista, Universo(Elemento_De_La_Lista, BlaBlaBla), Lista_Generada).
length(Lista, Cantidad).
not(Consulta).
nombreFunctor(Componente1, Componente2, Componente3, ...).
% Manejo de Listas% 
[Cabeza|Cola].
[Cabeza,Segundo|Cola].
%-----------------%
between(Min, Max, Nro).
max_member(Maximo, Lista).
min_member(Minimo, Lista).
flatten(Lista, Lista_Concatenada). %Aplana la lista, es decir, si hay sublistas, hace todo una misma lista al estilo concat
sumlist(Lista, Cantidad).
nth1(Indice, Lista, Elemento). % Devuelve el elemento en la posición dada (indexación comenzando desde 1) de una lista.



