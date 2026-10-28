% p3.pl
% Jack Hunter: max_two/3, max_lst/2, count_occurrences/3,
% reverse_unique/2, getCommon/3, and their example tests.

% ------------------- PART ONE ---------------------
% #1 (Undergraduate/Graduate) (5/5 pts)
% Determine the maximum of two integer numbers.
% max_two(A, B, M).

% max_two(1, 12, M). -> M = 12
% max_two(11232, 92674, M). -> M = 92674

% Equal inputs use the first rule.
max_two(A, B, A) :- A >= B.
max_two(A, B, B) :- A < B.

% ------------------------------------------------
% #2 (Undergraduate/Graduate) (5/5 pts)
% Using the max_two predicate from the previous problem,
% determine the maximum value in a list of integers
% (the list will always have length >= 1).
% max_lst(Lst, Max).

% max_lst([1, 2, 3, 4], Max). -> Max = 4
% max_lst([1, 13, 2], Max). -> Max = 13

% Compare the head with the maximum of the remaining list.
max_lst([Value], Value).
max_lst([Head, Next|Tail], Max) :-
    max_lst([Next|Tail], TailMax),
    max_two(Head, TailMax, Max).

% ------------------------------------------------
% #3 (Undergraduate/Graduate) (5/5 pts)
% Count how many times a number appears in a list of integers.
% count_occurrences(Lst, Num, Count).

% count_occurrences([1, 2, 3, 2, 2, 4], 2, Count). -> Count = 3
% count_occurrences([5, 5, 5], 5, Count). -> Count = 3

% Add one for a match and keep the tail count otherwise.
count_occurrences([], _, 0).
count_occurrences([Head|Tail], Num, Count) :-
    Head =:= Num,
    count_occurrences(Tail, Num, RestCount),
    Count is RestCount + 1.
count_occurrences([Head|Tail], Num, Count) :-
    Head =\= Num,
    count_occurrences(Tail, Num, Count).

% ------------------------------------------------
% #4 (Undergraduate/Graduate) (5/5 pts)
% Determine the summation of a list of integer numbers.
% sum_lst(Lst, Sum).

% sum_lst([1, 2, 3, 4], Sum). -> Sum = 10
% sum_lst([10, 10], Sum). -> Sum = 20

sum_lst([], 0).
sum_lst([H|T], Sum) :-
    sum_lst(T, Rest),
    Sum is H + Rest.
% ------------------------------------------------
% #5 (Undergraduate/Graduate) (5/5 pts)
% Using the sum_lst predicate from the previous problem,
% determine whether a list of integers can be split into two sublists
% whose sums are equal
% (the list will always have length >= 1).
% partitionable(Lst).
 
% partitionable([1, 2, 3, 4, 10]). -> true. because of [1, 2, 3, 4] and [10]
% partitionable([2, 1, 1]). -> true. because of [2] and [1, 2]

partitionable(Lst) :-
    sum_lst(Lst, Total),
    Total mod 2=:= 0,
    Half is Total // 2,
    subset_sum(Lst, Sub),
    sum_lst(Sub, Half), !.

% Helper to get any subset of the list (Keep or skip each element)
% AI-assisted for this segment
subset_sum([], []).
subset_sum([H|T], [H|Sub]) :- subset_sum(T, Sub).
subset_sum([_|T], Sub) :- subset_sum(T, Sub).


% ------------------------------------------------
% #6 (Undergraduate/Graduate) (5/5 pts)
% Using the count_occurrences predicate from Problem 3,
% determine the reversed list of integers without duplicate values.
% reverse_unique(Lst, RevLst).

% reverse_unique([4, 0, -4, 6, 0], RevLst). -> RevLst = [0, 6, -4, 4]
% reverse_unique([6, 18, 41, 6, 18, 10, 6], RevLst). -> RevLst = [6, 10, 18, 41]

% Keep only the last occurrence of each value, in reverse order.
reverse_unique([], []).
reverse_unique([Head|Tail], RevLst) :-
    count_occurrences(Tail, Head, Count),
    reverse_unique(Tail, RevTail),
    (Count =:= 0 -> append(RevTail, [Head], RevLst)
    ; RevLst = RevTail).

% ------------------------------------------------
% #7 (Undergraduate/Graduate) (10/5 pts)
% Return a list of numbers that have an even number of digits.
% collectEvenDigitCount(Lst, NewLst).

% collectEvenDigitCount([3, 12, 9999, 123], NewLst). -> NewLst = [12, 9999] 
% collectEvenDigitCount([22, 3333, 0, 444444], NewLst). -> NewLst = [22, 3333, 444444] 

num_digits(N, D) :-
    A is abs(N),
    number_codes(A, Codes),
    length(Codes, D).

collectEvenDigitCount([], []).
collectEvenDigitCount([H|T], [H|R]) :-
    num_digits(H, D),
    D mod 2 =:= 0, !,
    collectEvenDigitCount(T, R).
collectEvenDigitCount([_|T], R) :-
    collectEvenDigitCount(T, R).

% ------------------- PART TWO ---------------------
% Put the 'zipcodes.pl' file, in the same folder as this file.
% This file contains facts about the US zipcodes in the following format:
% location(Zipcode, Place, State, Location, Latitude, Longitude).
% Example: 
% for getting all the Zipcodes and States you can use the following query: 
% location(Z, _, S, _, _, _). 

% The following line will compile and load all zipcodes, 
% so you don't have to manually consult the file.
:- consult('zipcodes.pl').

% #8 (Undergraduate/Graduate) (3/3 pts)
% Determine all places, states, and zipcodes that are related.
% getStateInfo(PLACE, STATE, ZIPCODE).

% getStateInfo('Oxford', State, 45056). -> State = 'OH'
% findall(State, getStateInfo('Oxford', State, _), StList), writeln(StList).
% -> StList = [AL,AR,CT,FL,GA,GA,IA,IN,KS,MA,MD,ME,MI,MI,MS,NC,NE,NJ,NY,OH,PA,WI]
% ------------------------------------------------
% #9 (Undergrad/Grad) (17/7 pts)
% Gets place names that are common between STATE1 and STATE2, 
% where STATE1 and STATE2 differ.
% ** The order of places is not important
% ** Duplicate values should be removed 
% getCommon(STATE1, STATE2, PLACELST).

% getCommon('OH','MI',PLACELST). -> *Should be 131 unique places* 
% ['Manchester','Unionville','Athens','Saint
% Johns','Belmont','Bellaire','Bridgeport','Lansing','Flushing','D
% ecatur','Hamilton','Oxford','Trenton','Monroe','Augusta','Carrol
% lton','Milford','Moscow','New
% Richmond','Williamsburg','Clarksville','Midland','Elkton','Salem
% ','Blissfield','Bedford','Greenville','North Star','Union
% City','Sherwood','Ashley','Birmingham','Milan','Sandusky','Colum
% bus','Lyons','Metamora','Burton','Alpha','Cedarville','Jamestown
% ','Fairview','Harrison','Arcadia','Kenton','Ridgeway','Ada','Alg
% er','Freeport','Harrisville','Napoleon','Highland','Lakeville','
% Millersburg','Nashville','Bellevue','New
% Haven','Jackson','Wellston','Bloomingdale','Empire','Mount
% Pleasant','Richmond','Perry','Eastlake','Homer','Utica','Lakevie
% w','Quincy','Holland','Ellsworth','Petersburg','Marion','Caledon
% ia','Brunswick','Chippewa
% Lake','Litchfield','Portland','Coldwater','Mendon','Rockford','C
% ovington','Troy','Clayton','Vandalia','Fulton','Sparta','Rosevil
% le','Martin','Somerset','Jasper','Wakefield','Ravenna','Wayland'
% ,'Deerfield','Camden','Cloverdale','Plymouth','Shelby','Frankfor
% t','Kingston','Fremont','Adrian','Attica','Flat
% Rock','Fostoria','Republic','Sidney','Paris','Canton','Bath','Cl
% inton','Hudson','Akron','Fowler','Hartford','Niles','Warren','Du
% ndee','Marysville','Ray','Franklin','Mason','Lowell','Newport',
% 'Waterford', 'Sterling', 'Portage', 'Wayne', 'Grand Rapids', 'Weston']

% Collect shared place names and remove duplicates.
getCommon(State1, State2, Places) :-
    State1 \= State2,
    findall(Place,
        (location(_, Place, State1, _, _, _),
         location(_, Place, State2, _, _, _)),
        Matches),
    sort(Matches, Places).

% ------------------------------------------------
% #10 (Undergrad/Grad) (20/15 pts)
% Determine the place that is geographically closest to a given place 
% within the same state (based on latitude and longitude).
% Study the distance formula in the following link to learn how you should
% calculate distances based on Lats and Longs:
% https://www.movable-type.co.uk/scripts/latlong.html?
% closestPlaceInState(Place, State, ClosestPlace).
% 
% closestPlaceInState('Oxford', 'OH', ClosestPlace). -> 'Hamilton'

distance_km(Lat1, Lon1, Lat2, Lon2, D) :-
    deg2rad(Lat1, RLat1),
    deg2rad(Lon1, RLon1),
    deg2rad(Lat2, RLat2),
    deg2rad(Lon2, RLon2),
    DLat is RLat2 - RLat1,
    DLon is RLon2 - RLon1,
    A is sin(DLat/2)*sin(DLat/2)
       + cos(RLat1)*cos(RLat2)*sin(DLon/2)*sin(DLon/2),
    C is 2 * atan2(sqrt(A), sqrt(1 - A)),
    R is 6371.0,              % Earth radius in km
    D is R * C.

deg2rad(Deg, Rad) :-
    Rad is Deg * pi / 180.

% ?- max_two(1, 12, 12).
% ?- max_lst([1, 13, 2], 13).
% ?- count_occurrences([1, 2, 3, 2, 2, 4], 2, 3).
% ?- reverse_unique([4, 0, -4, 6, 0], [0, 6, -4, 4]).
% ?- getCommon('OH', 'MI', Places), length(Places, 131).
