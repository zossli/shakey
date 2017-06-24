# shakey AI Projekt
Für den Unterricht vom Frühlingssemester 2017 wurde ein Prolog Programm geschrieben, welches Shakey simuliert.
In diesem Readme.md wird kurz auf die einzelnen Funktionen eingegangen.

## [runShakey.pl](https://github.com/zossli/shakey/blob/master/runShakey.pl)
```Prolog
:- [floorplan, stacking, shakey].

:- initialization(main).

/*moveBox(wichBox, toRoom, startingPlaceFromShakey)*/
main :-
    moveBox(box3, room1, room4).
```
Dieses File muss ausgeführt werden. Es startet automatisch die Main Funktion mithilfe von `:- initialization(main).`
Main ist definiert als `moveBox(box3, room1, room4).`. Der erste Parameter steht für die Box, welche verschoben werden soll. Der zweite Parameter ist der Raum in, welcher die Box verschoben werden soll und der dritte Parameter ist der Startraum von Shakey.

## [floorplan.pl](https://github.com/zossli/shakey/blob/master/floorplan.pl)
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

## [shakey.pl](https://github.com/zossli/shakey/blob/master/shakey.pl)
