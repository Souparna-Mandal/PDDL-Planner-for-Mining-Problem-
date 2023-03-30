(define (domain mine-world4) ; HOW DO I KEEP TRACK OF THE CURRENT LOC OF THE ROBOT ? 

    (:requirements:adl)                    ; if extending the problem you need to come up with ways to make other objects also holdable and get rid of teleport after ore collection 
    (:types robot holdable obstacle cell )  ; pickaxe,ore are holdable, rocks are obstacle , lift is a cell 
    (:predicates
        
        (Holding ?r -robot) ; robot holding something or not 

        (IsHoldablein ?c -cell ?h -holdable ) ; does the cell have objects like hammer, ore

        (IsObstaclein ?c -cell ?o -obstacle) ; does the cell have an obstacle like Rock 

        (Holdwhat ?r - robot ?h -holdable) ; what item is the robot holding 

        ; now for layout of the mine coordidoors
        (Robotloc ?r -robot ?c -cell) ; tells us currect loc of the robot 
        (IsConnected ?x -cell ?y-cell) ; whether two cells are connecter or not 
        (isOre ?h -holdable) ; is the holdable an ore
        (isbigOre ?h - holdable)
        (isLifton ?h - holdable) ; has the ore been mined? if yes then lift for that ore should be 1 
        
        (isFire ?x - cell)
        (Chargeron ?x - cell); checks if the charger is on the cell 
        ; looks at the battery of the robot 
        (travel_tandem) ; true or false means should robot travel together 
    ) 

    (:functions
        (battery-level ?r - robot) ; this maintains a battery level for the robot 
        (battery-used ?r - robot)
    )

    


    (:constants Lift - cell Hammer - holdable Rock - obstacle RM - robot Extinguisher - holdable)

    

    
 ; #############################################################################################


    (:action Move
        :parameters (?x -cell ?y -cell ?r -robot)
        :precondition (and (IsConnected ?x ?y) 
                     (>= (battery-level ?r) 3 )
                     (Robotloc ?r ?x)
                     (not(travel_tandem))  ; robots do not have to move together 
                     (not(isFire ?y)) ; there should not be fire in the next cell to 
                     (not (= ?x ?y))
                      )
                     
        :effect (and (Robotloc ?r ?y) (not (Robotloc ?r ?x)) (decrease (battery-level ?r) (battery-used ?r) ))
    )

    (:action MoveTogether
        :parameters (?x -cell ?y -cell ?r -robot ?k -robot)
        :precondition (and (IsConnected ?x ?y) 
                     (>= (battery-level ?r) 3 )
                     (>= (battery-level ?k) 3 ) 
                     (Robotloc ?r ?x)
                     (travel_tandem)
                     (not(isFire ?y)) ; there should not be fire in the next cell to 
                     (not (= ?x ?y))
                     (not (= ?r ?k))
                      )
                     
        :effect (and (Robotloc ?r ?y) (Robotloc ?k ?y) (not (Robotloc ?r ?x))(not (Robotloc ?k ?x)) (decrease (battery-level ?r) 3 ) (decrease (battery-level ?k) 3 ) ) ; they move together only when carrying an ore  ; hardcoded the decrease values 
    )

    (:action Pickup
        :parameters (?x - cell ?o - holdable ?r -robot)
        :precondition (and  (Robotloc ?r ?x)
                             (IsHoldablein ?x ?o) ; cell , item 
                             (not (Holding ?r)) ; changed to make it hold any item 
                             (not(isOre ?o))
                      )
        :effect (and  (Holdwhat ?r ?o)(not (IsHoldablein ?x ?o)) (Holding ?r) (assign (battery-used ?r) 3))
    )

    (:action BreakRock
        :parameters (?x -cell ?o - holdable ?r -robot ) ; a holdable ore is passed in 
        :precondition (and  (Robotloc ?r ?x)
                             (Holdwhat ?r Hammer) ; holding the hammer 
                             (IsObstaclein ?x Rock)
                             (IsHoldablein ?x ?o) ; is there an ore in that cell 
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
                             (not(isbigOre ?o))  ; should not be a big ore 
                             (IsHoldablein ?x ?o) ; breaks rocks only if ore is there 
                      )
        :effect (and (Holdwhat ?r ?o) (not(IsHoldablein ?x ?o)) (assign (battery-used ?r) 3) (Holding ?r))     ; robot picks up the ore and teleports to the lift and here I have avoide
    ; teleports after getting ore to the lift for now 
    )



    ; (:action GetBigOre
    ;     :parameters (?x - cell ?o - holdable ?r -robot ?k - robot)
    ;     :precondition (and  (Robotloc ?r ?x)
    ;                         (Robotloc ?k ?x)
    ;                          (not(IsObstaclein ?x Rock))
    ;                          (not(Holding ?r))
    ;                          (not(Holding ?k))
    ;                          (isOre ?o)
    ;                          (isbigOre ?o)  ; should not be a big ore 
    ;                          (IsHoldablein ?x ?o) ; breaks rocks only if ore is there 
    ;                          (not (= ?r ?k))
    ;                   )
    ;     :effect (and (Holdwhat ?r ?o) (Holdwhat ?k ?o) (not(IsHoldablein ?x ?o)) (assign (battery-used ?r) 3) (travel_tandem) (assign (battery-used ?k) 3) (Holding ?r) (Holding ?k))     ; robot picks up the ore and teleports to the lift and here I have avoide
    ; ; teleports after getting ore to the lift for now 
    ; )




    (:action DropHoldable
        :parameters (?x - cell ?h - holdable ?r -robot)
        :precondition (and 
            (Robotloc ?r ?x)
            (not(isOre ?h)) ; cannot drop an ore down unless its lift 
            (Holding ?r)
            (Holdwhat ?r ?h)
        )
        :effect (and  (not(Holding ?r ))(not(Holdwhat ?r ?h))(assign (battery-used ?r) 1) (IsHoldablein ?x ?h))
    )   

    (:action Lift_on_and_Mining_done
        :parameters (?o - holdable ?r - robot)
        :precondition(and (Robotloc ?r Lift) (Holdwhat ?r ?o) (not(isLifton ?o)) (isOre ?o))
        :effect(and (isLifton ?o) (not(Holdwhat ?r ?o )) (assign (battery-used ?r) 1) (not(Holding ?r))) ; something is mined if lift is on with that ore 
    )

    ; (:action LiftOnTogether
    ;     :parameters (?o - holdable ?r - robot ?k - robot)
    ;     :precondition(and (Robotloc ?r Lift) (Robotloc ?k Lift) (Holdwhat ?r ?o) (Holdwhat ?k ?o) (travel_tandem) (not(isLifton ?o)) (isOre ?o)); (not (= ?r ?k)
    ;     :effect(and (isLifton ?o) (not(travel_tandem)) (not(Holdwhat ?r ?o )) (not(Holdwhat ?k ?o )) (assign (battery-used ?r) 1) (assign (battery-used ?k) 1) (not(Holding ?r)) (not(Holding ?k))) ; something is mined if lift is on with that ore 
    ; )


    (:action Battery_Recharge
        :parameters (?x -cell ?r -robot)
        :precondition  (and (Robotloc ?r ?x)  (Chargeron ?x))  ; removed last constraint on battery recharge only if more than 20                    
        :effect (assign (battery-level ?r) 40) 
    
    )

    (:action Extinguish
        :parameters (?x -cell ?y -cell ?r -robot)
        :precondition  (and (Robotloc ?r ?x)  
                        (IsConnected ?x ?y)
                        (isFire ?y) 
                        (Holdwhat ?r Extinguisher ))  ; last condition is to reduce recharges                        
        :effect (not(isFire ?y))
    
    ) 
    
    


)
    

    
    





; goal is for all the ores to be in the lift 