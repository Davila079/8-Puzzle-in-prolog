% ---------------------------
% Representación de estados
% ---------------------------

% Estado inicial del 8-Puzzle
estado_inicial([
    [0, 1, 3],
    [4, 2, 5],
    [7, 8, 6]
]).

% Estado objetivo del 8-Puzzle
estado_objetivo([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
]).

% -------------------------------------
% Generación de movimientos adyacentes
% -------------------------------------

% Se generan los movimientos (arriba, abajo, izquierda, derecha)
movimiento([X, Y], [X1, Y]) :-
    X1 is X + 1,
    X1 < 3.
movimiento([X, Y], [X1, Y]) :-
    X1 is X - 1,
    X1 >= 0.
movimiento([X, Y], [X, Y1]) :-
    Y1 is Y + 1,
    Y1 < 3.
movimiento([X, Y], [X, Y1]) :-
    Y1 is Y - 1,
    Y1 >= 0.

% -------------------------------------------
% Búsqueda de la posición del espacio vacío
% -------------------------------------------

buscar_espacio(Tablero, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, 0).

% -------------------------------------------------
% Predicados auxiliares para reemplazar en una lista
% -------------------------------------------------

% Reemplaza el elemento en la posición 0 de la lista.
replace_in_list([_|T], 0, X, [X|T]).
% Reemplaza el elemento en la posición I (I > 0).
replace_in_list([H|T], I, X, [H|R]) :-
    I > 0,
    I1 is I - 1,
    replace_in_list(T, I1, X, R).

% Reemplaza el valor en la posición [X, Y] del tablero.
reemplazar(Tablero, [X, Y], Valor, NuevoTablero) :-
    nth0(X, Tablero, Fila),
    replace_in_list(Fila, Y, Valor, NuevaFila),
    replace_in_list(Tablero, X, NuevaFila, NuevoTablero).

% --------------------------------------------------------
% Movimiento de la ficha: intercambio (swap) correcto
% --------------------------------------------------------

% Se intercambia la ficha en la posición adyacente con el espacio vacío.
mover_pieza(Tablero, [X, Y], [NX, NY], NuevoTablero) :-
    % Se obtiene la ficha de la posición adyacente.
    nth0(NX, Tablero, FilaNueva),
    nth0(NY, FilaNueva, Ficha),
    % Se coloca la ficha en la posición donde estaba el espacio vacío.
    reemplazar(Tablero, [X, Y], Ficha, TempTablero),
    % Se coloca el 0 (espacio vacío) en la posición de la ficha.
    reemplazar(TempTablero, [NX, NY], 0, NuevoTablero).

% --------------------------------------------------------
% Generación de un nuevo estado moviendo el espacio vacío
% --------------------------------------------------------

desplazar(Tablero, NuevoTablero) :-
    buscar_espacio(Tablero, X, Y),
    movimiento([X, Y], [NX, NY]),
    mover_pieza(Tablero, [X, Y], [NX, NY], NuevoTablero).

% --------------------------------------------------------
% Algoritmo de búsqueda recursiva (DFS)
% --------------------------------------------------------

resolver :-
    estado_inicial(EstadoInicial),
    estado_objetivo(EstadoObjetivo),
    resolver_recursivo(EstadoInicial, EstadoObjetivo, []).

resolver_recursivo(Estado, Estado, _) :-
    write('¡Solución encontrada!'), nl,
    imprimir_tablero(Estado).

resolver_recursivo(Estado, EstadoObjetivo, Visitados) :-
    \+ member(Estado, Visitados),  % Evita ciclos revisando estados ya visitados
    imprimir_tablero(Estado), nl,
    desplazar(Estado, NuevoEstado),
    resolver_recursivo(NuevoEstado, EstadoObjetivo, [Estado|Visitados]).

% --------------------------------------------------------
% Impresión del tablero en formato legible
% --------------------------------------------------------

imprimir_tablero([]) :- nl.
imprimir_tablero([Fila|Resto]) :-
    write(Fila), nl,
    imprimir_tablero(Resto).