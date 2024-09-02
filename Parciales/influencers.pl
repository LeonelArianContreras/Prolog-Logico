%%%%%%%%%%%%%
%% Punto 1 %%
%%%%%%%%%%%%%

% usuario(Nombre, Red Social, Subs)
usuario(ana, youtube, 3000000).
usuario(ana, instagram, 2700000).
usuario(ana, tiktok, 1000000).
usuario(ana, twitch, 2).

usuario(beto, twitch, 120000).
usuario(beto, youtube, 6000000).
usuario(beto, instagram, 1100000).

usuario(cami, tiktok, 2000).
usuario(dani, youtube, 1000000).
usuario(evelyn, instagram, 1).

%%%%%%%%%%%%%
%% Punto 2 %%
%%%%%%%%%%%%%

usuario(Usuario) :-
    usuario(Usuario, _, _).

influencer(Usuario) :-
    usuario(Usuario),
    findall(SuscriptoresDeCadaRed, subsDeUnaRed(Usuario, SuscriptoresDeCadaRed), SuscriptoresTotales),
    sumlist(SuscriptoresTotales, CantidadDeSubs),
    CantidadDeSubs > 10000.

subsDeUnaRed(Usuario, Suscriptores) :-
    usuario(Usuario, _, Suscriptores).

omniprescente(Usuario) :-
    influencer(Usuario),
    forall(usuario(_, Red, _), usuario(Usuario, Red, _)).

exclusivo(Usuario) :-
    usuario(Usuario, Red, _),
    not((usuario(Usuario, OtraRed, _), Red \= OtraRed)).

%%%%%%%%%%%%%
%% Punto 3 %%
%%%%%%%%%%%%%

publico(ana, tiktok, video(1, [beto, evelyn])).
publico(ana, tiktok, video(1, [ana])).
publico(ana, instagram, foto([ana])).
publico(beto, instagram, foto([])).
publico(cami, twitch, stream(leagueOfLegends)).
publico(cami, youtube, video(5, [cami])).
publico(evelyn, instagram, foto([evelyn, cami])).

tematicaDeStream(leagueOfLegends).
tematicaDeStream(minecraft).
tematicaDeStream(aoe).

%%%%%%%%%%%%%
%% Punto 4 %%
%%%%%%%%%%%%%

adictiva(Red) :-
    usuario(_, Red, _),
    forall(publico(_, Red, Contenido), contenidoAdictivo(Contenido)).

contenidoAdictivo(video(Minutos, _)) :- Minutos < 3.
contenidoAdictivo(stream(Tematica)) :- tematicaDeStream(Tematica).
contenidoAdictivo(foto(Participantes)) :- length(Participantes, Cantidad), Cantidad < 4.

%%%%%%%%%%%%%
%% Punto 5 %%
%%%%%%%%%%%%%

colaboran(Usuario, OtroUsuario) :-
    publico(Usuario, _, Contenido), % TODO: REDUCIR LOGICA
    publico(OtroUsuario, _, OtroContenido),
    apareceEn(OtroUsuario, Contenido),
    apareceEn(Usuario, OtroContenido),
    Usuario \= OtroUsuario.

apareceEn(UsuarioX, foto(Participantes)) :- participa(UsuarioX, Participantes).
apareceEn(UsuarioX, video(_, Participantes)) :- participa(UsuarioX, Participantes).

participa(Usuario, Participantes) :-
    member(Usuario, Participantes).

%%%%%%%%%%%%%
%% Punto 6 %%
%%%%%%%%%%%%%

caminoALaFama(Usuario) :-
    usuario(Usuario),
    not(influencer(Usuario)),
    influencer(Influencer),
    publico(Influencer, _, ContenidoInfluencer),
    pasosParaLaFama(Usuario, ContenidoInfluencer).

pasosParaLaFama(Usuario, ContenidoInfluencer) :-
    apareceEn(Usuario, ContenidoInfluencer).

pasosParaLaFama(Usuario, ContenidoInfluencer) :-
    apareceEn(OtroUsuario, ContenidoInfluencer),
    publico(OtroUsuario, _, OtroContenido),
    pasosParaLaFama(Usuario, OtroContenido).


    