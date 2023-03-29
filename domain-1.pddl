(define (domain mine-world) ; HOW DO I KEEP TRACK OF THE CURRENT LOC OF THE ROBOT ? 

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
        :parameters (?x -cell ?y -cell)
        :precondition (and (IsConnected ?x ?y) 
                     (Robotloc RM ?x)
                     (not (= ?x ?y))
                       )
                     
        :effect (and (Robotloc RM ?y) (not (Robotloc RM ?x)))
    )
    

    

    (:action Pickup
        :parameters (?x - cell)
        :precondition (and  (Robotloc RM ?x)
                             (IsHoldablein ?x Hammer) ; cell , item 
                             (not (Holding RM))
                      )
        :effect (and  (Holdwhat RM Hammer) (not (IsHoldablein ?x Hammer)) (Holding RM))
    )

    (:action BreakRock
        :parameters (?x -cell ?o - holdable ) ; a holdable ore is passed in 
        :precondition (and  (Robotloc RM ?x)
                             (Holdwhat RM Hammer) 
                             (IsObstaclein ?x Rock)
                             (IsHoldablein ?x ?o)
                             (isOre ?o)
                             ) 
                       
        :effect ( not(IsObstaclein ?x Rock) )
    )

    (:action GetOre
        :parameters (?x - cell ?o - holdable)
        :precondition (and  (Robotloc RM ?x)
                             (not(IsObstaclein ?x Rock))
                             (not(Holding RM))
                             (isOre ?o)  
                             (IsHoldablein ?x ?o) 
                      )
        :effect (and (Holdwhat RM ?o) (not(IsHoldablein ?x ?o)) (Holding RM))     ; robot picks up the ore and teleports to the lift and here I have avoide
    ; teleports after getting ore to the lift for now 
    )

    (:action DropHoldable
        :parameters (?x - cell ?h - holdable)
        :precondition (and 
            (Robotloc RM ?x)
            (not(isOre ?h)) ; cannot drop an ore down unless its lift 
            (Holding RM)
            (Holdwhat RM ?h)
        )
        :effect (and  (not(Holding RM ))(not(Holdwhat RM ?h)) (IsHoldablein ?x ?h))
    )   

    (:action LiftOn
        :parameters (?o - holdable)
        :precondition(and (Robotloc RM Lift) (Holdwhat RM ?o) (not(isLifton ?o)) (isOre ?o))
        :effect(and (isLifton ?o) (not(Holdwhat RM ?o )) (not(Holding RM))) ; something is mined if lift is on with that ore 
    )
    


)


; goal is for all the ores to be in the lift 