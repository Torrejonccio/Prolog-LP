% Hechos
arco(a, b).
arco(a, c).
arco(a, e).
arco(b, c).
arco(c, d).
arco(c, e).
arco(e, b).
arco(f, b).
arco(f, e).
arco(f, g).
arco(g, e).
arco(h, g).
arco(h, i).
arco(h, j).
arco(i, g).
arco(j, g).
arco(j, i).

% Reglas

% Divide una lista dada en cabeza y cola.
dividirlista([Cabeza|Cola], Cabeza, Cola).


% Entrega una lista de los nodos alcanzables desde un nodo X dado.
listanodosalcanzables(X, L2):-
    aux([X], [], L),
    reverse(L, L2).


% Entrega una lista de los nodos que llegan a un nodo X dado.
listanodosquellegan(Y, L2):-
    aux2([Y], [], L),
    reverse(L, L2).


% Función auxiliar que crea la lista de nodos alcanzables
aux([Nodo|RestoNodos], NodosAlcanzables, L):-
    findall(Vecino, (arco(Nodo, Vecino), not(member(Vecino, NodosAlcanzables)), not(member(Vecino, RestoNodos))), NuevoNodos),
    append(RestoNodos, NuevoNodos, NodosFinal),
    aux(NodosFinal, [Nodo|NodosAlcanzables], L).

aux([], [Nodo|NodosAlcanzables], [Nodo|NodosAlcanzables]).


% % Función auxiliar que crea la lista de nodos que llegan
aux2([Nodo|RestoNodos], NodosAlcanzables, L):-
    findall(Vecino, (arco(Vecino, Nodo), not(member(Vecino, NodosAlcanzables)), not(member(Vecino, RestoNodos))), NuevoNodos),
    append(RestoNodos, NuevoNodos, NodosFinal),
    aux2(NodosFinal, [Nodo|NodosAlcanzables], L).

aux2([], [Nodo|NodosAlcanzables], [Nodo|NodosAlcanzables]).


% Función que recorre una lista dada y entrega cada elemento como X.
recorrerlista(X, [X|_]).

recorrerlista(X, [_|RestoLista]) :-
    recorrerlista(X, RestoLista).



% Función puedellegar en caso de que se entregue solo el X.
puedellegar(X, Y):-
    var(Y),
    listanodosalcanzables(X, L),
    dividirlista(L, _, Cola),
    recorrerlista(Y, Cola).

% Función puedellegar en caso de que se entregue solo el Y.
puedellegar(X, Y):-
    var(X),
    listanodosquellegan(Y, L),
    dividirlista(L, _, Cola),
    recorrerlista(X, Cola).

% Función puedellegar en caso de que se entreguen ambos nodos.
puedellegar(X, Y):-
    not(var(X)),
    not(var(Y)),
    listanodosalcanzables(X, L),
	member(Y, L),
	!.
    


% Función vecinos que entrega una lista L con todos los vecinos del nodo X.
vecinos(X, L) :- findall(Y, arco(X, Y), L).



% Función caminovalido que valida si un camino dado existe.
caminovalido([_]).

caminovalido([]).

caminovalido(L):- 
    dividirlista(L, Cabeza, Cola), 
    dividirlista(Cola, Cabeza2, _), 
    arco(Cabeza, Cabeza2),
    caminovalido(Cola),
    !.



% Función que entrega el camino más corto entre dos nodos X e Y
caminomascorto(X, Y, L):-
    bfs([[X]], Y, CaminoMasCorto),
    reverse(CaminoMasCorto, L),
    !.

% Función auxiliar que implementa una busqueda en anchura para conseguir el camino más corto
bfs([[Y|RestoCamino]|_], Y, [Y|RestoCamino]).

bfs([[Nodo|RestoCamino]|ColaCaminos], Y, CaminoMasCorto):-
    findall([Vecino, Nodo|RestoCamino], (arco(Nodo, Vecino), not(member(Vecino, [Nodo|RestoCamino]))), NuevosCaminos),
    append(ColaCaminos, NuevosCaminos, NuevaCola),
    bfs(NuevaCola, Y, CaminoMasCorto).


