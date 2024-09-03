%rata(Nombre, DeDondeEs)
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).

%chef(Quien, Plato, Experiencia)
platoDe(linguini, ratatouille, 3).
platoDe(linguini, sopa, 5).
platoDe(colette, asado, 9).
platoDe(horst, ensaladaRusa, 8).
platoDe(horst, sopa, 6).

%trabajaEn(Persona, Donde)
trabajaEn(linguini, gusteaus).
trabajaEn(colette, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(skinner, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

%chef(Persona)
persona(linguini).
persona(colette).
persona(horst).
persona(skinner).
persona(amelie).

%restaurante(Resto)
restaurante(gusteaus).
restaurante(cafeDes2Moulins).
restaurante(chezMilleBar).
restaurante(pizzeriaJeSuis).

%%%%%%%%%%%%%
%% Parte 1 %%
%%%%%%%%%%%%%

estaEnMenu(Plato) :-
    platoDe(_, Plato, _).

%%%%%%%%%%%%%
%% Parte 2 %%
%%%%%%%%%%%%%

tutorDe(amelie, skinner).
tutorDe(Rata, linguini) :- trabajaEn(linguini, Donde), rata(Rata, Donde).

cocinaBien(Cocinante, Plato) :- 
    platoDe(Cocinante, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, _).

cocinaBien(Cocinante, Plato) :-
    tutorDe(Tutor, Cocinante),
    cocinaBien(Tutor, Plato). 

%%%%%%%%%%%%%
%% Parte 3 %%
%%%%%%%%%%%%%

chefDe(Persona, Restaurante) :-
    trabajaEn(Persona, Restaurante),
    buenChef(Persona).

buenChef(Persona) :-
    forall(platoDe(Persona, Plato, _), cocinaBien(Persona, Plato)).

buenChef(Persona) :-
    findall(ExperienciaDeUnPlato, platoDe(Persona, _, ExperienciaDeUnPlato), Experiencias),
    sumlist(Experiencias, ExperienciaTotal),
    ExperienciaTotal >= 20.

%%%%%%%%%%%%%
%% Parte 4 %%
%%%%%%%%%%%%%

encargadaDe(Persona, Plato) :-
    platoDe(Persona, Plato, ExperienciaMaxima),
    forall(platoDe(_, Plato, OtraExperiencia), OtraExperiencia =< ExperienciaMaxima).

%%%%%%%%%%%%%
%% Parte 5 %%
%%%%%%%%%%%%%

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).

saludable(Plato) :-
    plato(Plato, TipoDeComida),
    cuantasCaloriasTiene(TipoDeComida, Calorias),
    Calorias < 75.

cuantasCaloriasTiene(postre(Calorias), Calorias).
cuantasCaloriasTiene(principal(ensalada, _), 0).
cuantasCaloriasTiene(postre(Calorias), Calorias).
cuantasCaloriasTiene(principal(pure, MinutoDeCoccion), Calorias) :- 
    sumaDeCalorias(MinutosDeCoccion, 20, Calorias).
cuantasCaloriasTiene(principal(papasFritas, MinutoDeCoccion), Calorias) :-
    sumaDeCalorias(MinutosDeCoccion, 50, Calorias).

sumaDeCalorias(MinutosDeCoccion, CaloriasDeGuarnicion, CaloriasTotales) :-
    CaloriasTotales is (MinutoDeCoccion * 5) + CaloriasDeGuarnicion.

%%%%%%%%%%%%%
%% Parte 6 %%
%%%%%%%%%%%%%

tieneReseniaPositiva(Critico, Restaurante) :-
    restaurante(Restaurante),
    not(rata(_, Restaurante)),
    realizoUnaCritica(Critico, Restaurante).

realizoUnaCritica(antonEgo, Restaurante) :-
    forall(trabajaEn(Persona, Restaurante), crackEnCocinarARatatouille(Persona, Restaurante)).

crackEnCocinarARatatouille(Persona, Restaurante) :-
    chefDe(Persona, Restaurante),
    cocinaBien(Persona, ratatouille).

realizoUnaCritica(cormillot, Restaurante) :-
    trabajaEn(Laburante, Restaurante),
    forall(platoDe(Laburante, Plato, _), saludable(Plato)).

realizoUnaCritica(martiniano, Restaurante) :-
    trabajaEn(Laburante, Restaurante),
    not((trabajaEn(OtroLaburante, Restaurante), OtroLaburante \= Laburante)).