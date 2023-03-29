(define (problem mine-problem1)
    (:domain mine-world)

        (:objects 
        A - holdable
        B - holdable
        C - holdable
        1 - cell
        2 - cell
        3 - cell
        4 - cell
        5 - cell
        6 - cell
        7 - cell
        8 - cell
        9 - cell
        10 - cell
        11 - cell
        12 - cell
        13 - cell
        14 - cell
        15 - cell
        16 - cell
        17 - cell
        18 - cell
        19 - cell
        20 - cell
        21 - cell
        22 - cell
        )
            



    (:init
        (isOre A)
        (isOre B)
        (isOre C)
        (isobstaclein 10 Rock)
        (isobstaclein 8 Rock)
        (isobstaclein 3 Rock)
        (IsHoldablein 8 Hammer)
        (IsHoldablein 1 A)
        (IsHoldablein 10 C)
        (IsHoldablein 3 B)

        (Robotloc RM 17)

        (IsConnected 1 5)
        (IsConnected 4 5)
        (IsConnected 6 5)
        (IsConnected 4 9)
        (IsConnected 6 10)
        (IsConnected 8 9)
        (IsConnected 9 13)
        (IsConnected 10 15)
        (IsConnected 13 14)
        (IsConnected 14 15)
        (IsConnected 15 16)
        (IsConnected 16 17)
        (IsConnected 17 19)
        (IsConnected 19 22)
        (IsConnected 21 Lift)
        (IsConnected 21 22)
        (IsConnected 21 20)
        (IsConnected 20 18)
        (IsConnected 18 15)
        (IsConnected 11 17)
        (IsConnected 11 12)
        (IsConnected 11 7)
        (IsConnected 7 2)
        (IsConnected 2 3)

    )
    (:goal (and
        (isLifton A)
        (isLifton B)
        (isLifton C)
    ))

)