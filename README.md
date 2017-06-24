# shakey AI Projekt
Für den Unterricht vom Frühlingssemester 2017 wurde ein Prolog Programm geschrieben, welches Shakey simuliert.
In diesem Readme.md wird kurz auf die einzelnen Funktionen eingegangen.

Um das Program auszuführen, müssen alle Prolog Files (runShakey.pl, floorplan.pl, shakey.pl, stacking.pl) im selben Ordner liegen. Es muss lediglich das File runShakey ausgeführt werden. Alle anderen werden durch runShakey selbst aufgerufen. 

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
Die erste Überprüft, ob die Box im gleichen Raum ist wie Shakey und ob die Box auf einem Stack gelagert wird. Danach wird mithilfe der `firstInStack()` Funktion der Stack abgebaut, bis die Box als oberste auf dem Stack liegt und somit für Shakey griffbereit ist. Der Parameter BoxLocation wird angepasst um der nächsten Funktion weiterzugeben. Im 'Log' wird mithilfe des `append` wird FoundBox geschrieben.

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
Die Switch Room Funktion sieht wie folgt aus:
Die NewLocation wird definiert. Danach wird überprüft, ob der Raum bereits besucht wurde, dies wird mit der Zeile `not(member(NewLocation, TravRooms_IN))` überprüft. Die String Concat kleben die verschiedenen Satzfregmente aneinander um am Ende mithilfe des `append(Actions_IN, [Message3], Actions_OUT)` das Logfile zu ergänzen. Das Array der traversierten Räume wird in der letzten Zeile ergänzt.
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
Nachdem die Box gefunden und gepackt wurde, muss der Raum gefunden werden, in welchem die Box am Ende deponiert werden soll. Auch diese Funktion gibt es doppelt. 
```Prolog
findRoom(Location, Destination, Actions_IN, Actions_OUT, _, _) :-
    Location = Destination,
    append(Actions_IN,["Drop Box"], Actions_OUT).
```
Falls Shakey bereits im richtigen Raum ist, wird die Box einfach wieder abgesetzt. Dies wird in Log geschrieben.
Falls nicht, muss die folgende Funktion aufgerufen werden.
```Prolog
findRoom(Location, Destination, Actions_IN, Actions_OUT, TravRooms_IN, TravRooms_OUT) :-
    switchRoom(Actions_IN, Actions_X, Location, Location_X, TravRooms_IN, TravRooms_X),
    findRoom(Location_X, Destination, Actions_X, Actions_OUT, TravRooms_X, TravRooms_OUT).
```
Es wird mit derselben Funktion wie zuvor der Raum gewechselt und `findRoom` erneut aufgerufen.

## [stacking.pl](stacking.pl)
Mithilfe der Funktion `stackMember` wird überprüft ob die Box bereits aufgenommen werden kann, oder ob sie allenfalls unter anderen Boxen liegt:
```Prolog
stackMember(Box, Stack, Actions_IN, Actions_OUT) :- 
	stack(Stack), 
	member(Box, Stack),
    append(Actions_IN,["Box is a Stack Member"], Actions_OUT). 
```
Mit `stack(Stack)` wird ein Stack ausgewählt, bei dem die Box enthalten ist. Was mit `member(Box, Stack)` vorgegeben wird. Dies wird ebenfalls im Log ausgegeben.
```Prolog
firstInStack(Box, Actions_IN, Actions_OUT) :-
	stack([Box|_]),
	append(Actions_IN,["Box is at first Position pickable"], Actions_OUT).	
```
```Prolog
firstInStack(Box, Actions_IN, Actions_OUT) :-
	stack([_|RestOfStack]),
	member(Box, RestOfStack),
	unstack(Box,RestOfStack,Actions_IN,Actions_OUT).
```
Die First in Stack wird verwendet, sobald bekannt ist, dass die Box auf einem Stapel gelagert wird. Auch diese Funktion ist in zwei verschiedenen Varianten vorhanden. Zum einen (oben), falls die Box gleich zuoberst auf dem Stapel liegt und somit einfach aufgenommen werden kann. Die andere Version der Funktion `firstInStack()` wird verwendet, um den Stapel abbau zu initialisieren. `stack([_|RestOfStack])` sagt, das wir den RestOfStack wollen und uns das erste Element egal ist. In der zweiten Zeile schauen wir dann, dass die gesuchte Box wirklich noch im RestOfStack vorhanden ist, falls dies zutrifft beginnen wir mit dem Abbau des Stapels.

```Prolog
unstack(Box,Stack,Actions_IN,Actions_OUT) :-
	[First | Others] = Stack,
	First = Box,
	append(Actions_IN,["Unstack top Box"], Actions_1),
	append(Actions_1,["Box is now pickable"], Actions_OUT).
```
Die obere `unstack()` Funktion wird verwendet, falls die gesuchte Box bereits an der zweiten Stelle liegt. Da `firstInStack` bereits eine Box abgebaut hat, wird hier noch einmal überprüft ob die Box nun bereits an der ersten Position liegt. Falls ja wird der Abbau Schritt vermerkt und ebenfalls ins Log geschrieben, dass die Box nun bereit ist zum aufnehmen.
Falls die Box nicht an der zweiten Stelle des Stapels liegt, wird erneut ein Element abgebaut und überprüft, dass die gesuchte Box noch in den Others liegt. Der Abbau wird im Log vermerkt und die unstacking Funktion erneut aufgerufen.
```Prolog
unstack(Box,Stack, Actions_IN, Actions_OUT) :-
	[First | Others] = Stack,
	member(Box, Others),
	append(Actions_IN,["Unstack top Box"], Actions_1),
	unstack(Box,Others, Actions_1, Actions_OUT).
```

## Weiteres
Bei diesem Beispiel sind alle Räume durch einen Gang miteinander verbunden. Der Gang wurde vereinfacht und weggelassen.
Beim Abbau der Boxen wird kein neuer Stapel generiert. Sondern die Boxen irgendwo im Raum verteilt. Auch werden alle Aufgaben immer auf dem initialen Raumplan ausgeführt. Es können nicht mehrere Box moves nacheinander durchgeführt werden.
