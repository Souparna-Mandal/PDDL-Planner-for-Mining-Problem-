(define (domain mine-world1) ; HOW DO I KEEP TRACK OF THE CURRENT LOC OF THE ROBOT ? 

    (:requirements:adl)                    ; if extending the problem you need to come up with ways to make other objects also holdable and get rid of teleport after ore collection 
    (:types robot holdable obstacle cell)  ; pickaxe,ore are holdable, rocks are obstacle , lift is a cell 
    (:predicates
        
        (Holding ?r -robot) ; robot holding something or not 

        (IsHoldablein ?c -cell ?h -holdable ) ; does the cell have objects like hammer, ore

        (IsObstaclein ?c -cell ?o -obstacle) ; does the cell have an obstacle like Rock 

        (Holdwhat ?r - robot ?h -holdable) ; what item is the robot holding 

        ; now for layout of the mine coordidoors
        (Robotloc ?r -robot ?c -cell) ; tells us currect loc of the robot 
        (IsConnected ?x -cell ?y-cell) ; whether two cells are connecter or not 
        (isOre ?h -holdable) ; is the holdable an ore
        (isLifton ?h - holdable) ; has the ore been mined? if yes then lift for that ore should be 1 
    )


    (:constants Lift - cell Hammer - holdable Rock - obstacle RM - robot)

    



    (:action Move
        :parameters (?x -cell ?y -cell ?r -robot)
        :precondition (and (IsConnected ?x ?y) 
                     (Robotloc ?r ?x)
                     (not (= ?x ?y))
                       )
                     
        :effect (and (Robotloc ?r ?y) (not (Robotloc ?r ?x)))
    )
    

    

    (:action Pickup
        :parameters (?x - cell ?r -robot)
        :precondition (and  (Robotloc ?r ?x)
                             (IsHoldablein ?x Hammer) ; cell , item 
                             (not (Holding ?r))
                      )
        :effect (and  (Holdwhat ?r Hammer) (not (IsHoldablein ?x Hammer)) (Holding ?r))
    )

    (:action BreakRock
        :parameters (?x -cell ?o - holdable ?r -robot) ; a holdable ore is passed in 
        :precondition (and  (Robotloc ?r ?x)
                             (Holdwhat ?r Hammer) 
                             (IsObstaclein ?x Rock)
                             (IsHoldablein ?x ?o)
                             (isOre ?o)
                             ) 
                       
        :effect ( not(IsObstaclein ?x Rock) )
    )

    (:action GetOre
        :parameters (?x - cell ?o - holdable ?r -robot)
        :precondition (and  (Robotloc ?r ?x)
                             (not(IsObstaclein ?x Rock))
                             (not(Holding ?r))
                             (isOre ?o)  
                             (IsHoldablein ?x ?o) 
                      )
        :effect (and (Holdwhat ?r ?o) (not(IsHoldablein ?x ?o)) (Holding ?r))     ; robot picks up the ore and teleports to the lift and here I have avoide
    ; teleports after getting ore to the lift for now 
    )

    (:action DropHoldable
        :parameters (?x - cell ?h - holdable ?r -robot)
        :precondition (and 
            (Robotloc ?r ?x)
            (not(isOre ?h)) ; cannot drop an ore down unless its lift 
            (Holding ?r)
            (Holdwhat ?r ?h)
        )
        :effect (and  (not(Holding ?r ))(not(Holdwhat ?r ?h)) (IsHoldablein ?x ?h))
    )   

    (:action LiftOn
        :parameters (?o - holdable ?r - robot)
        :precondition(and (Robotloc ?r Lift) (Holdwhat ?r ?o) (not(isLifton ?o)) (isOre ?o))
        :effect(and (isLifton ?o) (not(Holdwhat ?r ?o )) (not(Holding ?r))) ; something is mined if lift is on with that ore 
    )
    


)


; goal is for all the ores to be in the lift 