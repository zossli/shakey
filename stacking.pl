stackMember(Box, Stack, Actions_IN, Actions_OUT) :- 
	stack(Stack), 
	member(Box, Stack),
    append(Actions_IN,["Box is a Stack Member"], Actions_OUT). 
	
firstInStack(Box, Actions_IN, Actions_OUT) :-
	stack([Box|_]),
	append(Actions_IN,["Box is at first Position pickable"], Actions_OUT).	
	
firstInStack(Box, Actions_IN, Actions_OUT) :-
	stack([_|RestOfStack]),
	member(Box, RestOfStack),
	unstack(Box,RestOfStack,Actions_IN,Actions_OUT).

unstack(Box,Stack,Actions_IN,Actions_OUT) :-
	[First | Others] = Stack,
	First = Box,
	append(Actions_IN,["Unstack top Box"], Actions_1),
	append(Actions_1,["Box is now pickable"], Actions_OUT).
		
unstack(Box,Stack, Actions_IN, Actions_OUT) :-
	[First | Others] = Stack,
	member(Box, Others),
	append(Actions_IN,["Unstack top Box"], Actions_1),
	unstack(Box,Others, Actions_1, Actions_OUT).

pickUpBox(Actions_IN, Actions_OUT, HoldingTargetBox) :-
	HoldingTargetBox = true,
	append(Actions_IN, ["Found Box"], Actions_OUT).
