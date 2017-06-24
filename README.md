# shakey AI Projekt
Für den Unterricht vom Frühlingssemester 2017 wurde ein Prolog Programm geschrieben, welches Shakey simuliert.
In diesem Readme.md wird kurz auf die einzelnen Funktionen eingegangen.

## [runShakey.pl](runShakey.pl)
```Prolog
:- [floorplan, stacking, shakey].

:- initialization(main).

/*moveBox(wichBox, toRoom, startingPlaceFromShakey)*/
main :-
    moveBox(box3, room1, room4).
```
Dieses File muss ausgeführt werden. Es startet automatisch die Main Funktion mithilfe von `:- initialization(main).`
Main ist definiert als `moveBox(box3, room1, room4).`. Der erste Parameter steht für die Box, welche verschoben werden soll. Der zweite Parameter ist der Raum, in welcher die Box verschoben werden soll und der dritte Parameter ist der Startraum von Shakey.

## [floorplan.pl](floorplan.pl)
```Prolog
room(room1).
room(room2).
room(room3).
room(room4).

room_contains_box(room3, box1).
room_contains_box(room3, box2).
room_contains_box(room3, box3).
room_contains_box(room3, box4).

stack([box1, box2, box3]).
```
Mit `room(room1)`, werden die verschiedenen Räume definiert. Mithilfe des `room_contains_box()` Facts wird festgehalten, in welchem Raum welche Box verstaut ist.
Die Boxen können auf einem Stapel gelagert werden. Dies wird mithilfe des `stack` Facts definiert.

## [shakey.pl](shakey.pl)
```Prolog
moveBox(Box, Destination, StartLocation) :-
    findBox(Box, StartLocation, BoxLocation, [], Actions_X, [StartLocation], _),
    findRoom(BoxLocation, Destination, Actions_X, Actions_OUT, [BoxLocation], _),
    printActions(Actions_OUT).
```
Diese Funktion wird zum Start aufgerufen. Als erstes wird die Box gesucht, danach der Raum, in welchem die Box am Ende liegen soll. Zum Schluss werden die einzelnen Schritte ausgegeben, welche von Shakey ausgeführt werden müssen.

Die `findBox()` Funktion gibt es in drei verschiedenen Varianten.

```Prolog
findBox(Box, Location, BoxLocation, Actions_IN, Actions_OUT, _, _) :-
    room_contains_box(Location, Box),
	stackMember(Box, Stack, Actions_IN, Actions_1),
	firstInStack(Box,Actions_1,Actions_2),
    BoxLocation = Location,
    append(Actions_2,["Found Box"], Actions_OUT).
```
Die erste Überprüft, ob die Box im gleichen Raum ist wie Shakey und ob die Box auf einem Stack gelagert wird. Danach wird mithilfe der `firstInStack()` Funktion der Stack abgebaut, bis die Box als oberste auf dem Stack liegt und somit für Shakey griffbereit ist. Der Parameter BoxLocation wird angepasst um der nächsten Funktion weiterzugeben. Im 'Log' wird FoundBox geschrieben.

```Prolog
findBox(Box, Location, BoxLocation, Actions_IN, Actions_OUT, _, _) :-
    room_contains_box(Location, Box),
    BoxLocation = Location,
    append(Actions_IN,["Found Box"], Actions_OUT).
```
Nun gibt es aber auch die Möglichkeit, dass sich Shakey im selben Raum befindet, wie die Box und die Box nicht auf einem Stapel gelagert wird. Dies wird mithilfe des oberen Codes gelöst. 
```Prolog
findBox(Box, Location, BoxLocation, Actions_IN, Actions_OUT, TravRooms_IN, TravRooms_OUT) :-
    switchRoom(Actions_IN, Actions_X, Location, Location_X, TravRooms_IN, TravRooms_X),
    findBox(Box, Location_X, BoxLocation, Actions_X, Actions_OUT, TravRooms_X, TravRooms_OUT).
```
Falls sich Shakey nicht im selben Raum befindet wie die Box, wird mithilfe der `switchRoom()` Funktion der Raum gewechselt und die Funktion `findBox()` rekursiv mit dem neuen Shakey Standort aufgerufen.

```Prolog
switchRoom(Actions_IN, Actions_OUT, Location, NewLocation, TravRooms_IN, TravRooms_OUT) :-
    room(NewLocation),
    not(member(NewLocation, TravRooms_IN)),
    string_concat("changed Room from ", Location, Message1),
    string_concat(Message1, " to ", Message2),
    string_concat(Message2, NewLocation, Message3),
    append(Actions_IN, [Message3], Actions_OUT),
    append(TravRooms_IN, [NewLocation], TravRooms_OUT).
```
