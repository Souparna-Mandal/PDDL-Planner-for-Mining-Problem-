(define (domain mine-world) ; HOW DO I KEEP TRACK OF THE CURRENT LOC OF THE ROBOT ? 

    (:requirements:adl)                    ; if extending the problem you need to come up with ways to make other objects also holdable and get rid of teleport after ore collection 
    (:types robot holdable obstacle cell)  ; pickaxe,ore are holdable, rocks are obstacle , lift is a cell 
    (: predicates
        
        (Holding ?r -robot) ; robot holding something or not 

        (IsHoldablein ?c -cell ?h -holdable ) ; does the cell have objects like hammer, ore

        (IsObstaclein ?c -cell ?o -obstacle) ; if both isobstaclein and is holdablein true then rocks are blocking ores given holdable are ores and obstacles are rocks 

        (Holdwhat ?r - robot ?h -holdable) ; what holdable is the robot holding 

        ; now for layout of the mine coordidoors
        (Robotloc ?r -robot ?c -cell) ; tells us currect loc of the robot 
        (IsConnected ?c1 -cell ?c2 -cell) ; whether two cells are connecter or not 
        (isOre ?h -holdable) ; is the holdable an ore
        (isLifton ?h - holdable) ; checks if the holdable is ore then is it mined 
    )  
    (:constants Lift - cell Hammer - holdable Rock - obstacle Ore - holdable RM - robot)

    (:action Move
        :parameters (?c1 - cell ?c2-cell)
        :precondition (and  (IsConnected ?c1 ?c2) 
                            (Robotloc RM ?c1)
                            (not(= ?c1 ?c2))    )
        :effect (and (Robotloc RM ?c2)(not (Robotloc RM ?c1)) )
    )

    (:action Pickup
        :parameters (?h - holdable ?c1 - cell)
        :precondition (and  ((Robotloc RM ?c1)
                             (IsHoldablein ?c1 Hammer)
                             (not (Holding RM)))
        )
        :effect (and ( (Holdwhat RM Hammer) (not (IsHoldablein ?c1 Hammer)) (Holding RM)))
    )

    (:action BreakRock
        :parameters (?c1 -cell ?o holdable ) ; a holdable ore is passed in 
        :precondition (and  ((Robotloc RM ?c1)
                             (Holdwhat RM Hammer) 
                             (IsObstaclein ?c1 Rock)
                             (IsHoldablein ?c1 ?o)
                             (isOre ?o)
                             ) 
                      ) 
        :effect (and ((not(IsObstaclein ?c1 Rock)) ) )
    )

    (:action GetOre
        :parameters (?c1 - cell ?o holdable)
        :precondition (and  ((Robotloc RM ?c1)
                             (not(IsObstaclein ?c1 Rock))
                             (IsHoldablein ?c1 ?o)
                             (isOre ?o)
                            )
                      )
        :effect (and ( (not(Holdwhat RM Hammer)) (Holdwhat RM ?o) (not(IsHoldablein ?c1 ?o)) (Robotloc RM Lift)))     ; robot picks up the ore and teleports to the lift and here I have avoide

    )

    (:action LiftOn
        :parameters (?o - holdable)
        :precondition(and ((Robotloc RM Lift) (Holdwhat RM ?o) (not(isLifton ?0)) (isOre ?o)))
        :effect(and ((isLifton ?o) not((Holdwhat RM ?o ))) ; something is mined if lift is on with that ore 
    )



)


; goal is for all the ores to be in the lift 