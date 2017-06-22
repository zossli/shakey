moveBox(Box, Destination, StartLocation) :-
    findBox(Box, StartLocation, BoxLocation, [], Actions_X, [StartLocation], _),
    findRoom(BoxLocation, Destination, Actions_X, Actions_OUT, [BoxLocation], _),
    printActions(Actions_OUT).




findBox(Box, Location, BoxLocation, Actions_IN, Actions_OUT, _, _) :-
    room_contains_box(Location, Box),
    BoxLocation = Location,
    append(Actions_IN,["Found Box"], Actions_OUT).



findBox(Box, Location, BoxLocation, Actions_IN, Actions_OUT, TravRooms_IN, TravRooms_OUT) :-
    switchRoom(Actions_IN, Actions_X, Location, Location_X, TravRooms_IN, TravRooms_X),
    findBox(Box, Location_X, BoxLocation, Actions_X, Actions_OUT, TravRooms_X, TravRooms_OUT).


findRoom(Location, Destination, Actions_IN, Actions_OUT, _, _) :-
    Location = Destination,
    append(Actions_IN,["Drop Box"], Actions_OUT).

findRoom(Location, Destination, Actions_IN, Actions_OUT, TravRooms_IN, TravRooms_OUT) :-
    switchRoom(Actions_IN, Actions_X, Location, Location_X, TravRooms_IN, TravRooms_X),
    findRoom(Location_X, Destination, Actions_X, Actions_OUT, TravRooms_X, TravRooms_OUT).

switchRoom(Actions_IN, Actions_OUT, Location, NewLocation, TravRooms_IN, TravRooms_OUT) :-
    room(NewLocation),
    not(member(NewLocation, TravRooms_IN)),
    string_concat("changed Room from ", Location, Message1),
    string_concat(Message1, " to ", Message2),
    string_concat(Message2, NewLocation, Message3),
    append(Actions_IN, [Message3], Actions_OUT),
    append(TravRooms_IN, [NewLocation], TravRooms_OUT).

printActions(Actions) :-
    Actions = [].



printActions(Actions) :-
    [Action | Rest] = Actions,
    write(Action),
    write("\n"),
    printActions(Rest).

pickUpBox(Actions_IN, Actions_OUT, HoldingTargetBox) :-
HoldingTargetBox = true,
append(Actions_IN, ["Found Box"], Actions_OUT).


stackMember :- stack(L), member(X, L).

getBox(Box) :- stack(Box),
