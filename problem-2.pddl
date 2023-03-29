(define (problem mine-problem1)
    (:domain mine-world)

        (:objects 
        A - holdable
        B - holdable
        C - holdable
        c1 - cell
        c2 - cell
        c3 - cell
        c4 - cell
        c5 - cell
        c6 - cell
        c7 - cell
        c8 - cell
        c9 - cell
        c10 - cell
        c11 - cell
        c12 - cell
        c13 - cell
        c14 - cell
        c15 - cell
        c16 - cell
        c17 - cell
        c18 - cell
        c19 - cell
        c20 - cell
        c21 - cell
        c22 - cell
        )
            



    (:init
        (isOre A)
        (isOre B)
        (isOre C)
        (isobstaclein c10 Rock)
        (isobstaclein c8 Rock)
        (isobstaclein c3 Rock)
        (IsHoldablein c8 Hammer)
        (IsHoldablein c1 A)
        (IsHoldablein c10 C)
        (IsHoldablein c3 B)

        (Robotloc RM c17)

        (IsConnected c1 c5)
        (IsConnected c4 c5)
        (IsConnected c6 c5)
        (IsConnected c4 c9)
        (IsConnected c6 c10)
        (IsConnected c8 c9)
        (IsConnected c9 c13)
        (IsConnected c10 c15)
        (IsConnected c13 c14)
        (IsConnected c14 c15)
        (IsConnected c15 c16)
        (IsConnected c16 c17)
        (IsConnected c17 c19)
        (IsConnected c19 c22)
        (IsConnected c21 Lift)
        (IsConnected c21 c22)
        (IsConnected c21 c20)
        (IsConnected c20 c18)
        (IsConnected c18 c15)
        (IsConnected c11 c17)
        (IsConnected c11 c12)
        (IsConnected c11 c7)
        (IsConnected c7 c2)
        (IsConnected c2 c3)

        

        (IsConnected c5 c1)
        (IsConnected c5 c4)
        (IsConnected c5 c6)
        (IsConnected c9 c4)
        (IsConnected c10 c6)
        (IsConnected c9 c8)
        (IsConnected c13 c9)
        (IsConnected c15 c10)
        (IsConnected c14 c13)
        (IsConnected c15 c14)
        (IsConnected c16 c15)
        (IsConnected c17 c16)
        (IsConnected c19 c18)
        (IsConnected c22 c19)
        (IsConnected Lift c21)
        (IsConnected c22 c21)
        (IsConnected c20 c21)
        (IsConnected c18 c20)
        (IsConnected c15 c18)
        (IsConnected c17 c11)
        (IsConnected c12 c11)
        (IsConnected c7 c11)
        (IsConnected c2 c7)
        (IsConnected c3 c2)

        (= (battery-level RM) 40)
        (= (battery-used) 1)
    )
    
    (:goal (and (isLiftOn A) (isLifton B) (isLifton C)))

)