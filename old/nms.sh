declare parameter height is 500.
declare parameter hoverTime is 10.
declare parameter countdown is false.

declare function hover
{
    declare parameter targetv is 0.
    declare parameter correction is 0.01.

    set mass to ship:mass.
    set accl to 1.62.
    set maxt to ship:maxthrust.
    set mythrottle to (mass * accl) / maxt.

    set reslist to stage:resources.
    for res in reslist
    {
        if res:name = "LiquidFuel"
        {
            set fuel to res:amount.
        }
    }.

    if ship:verticalspeed < targetv
    {
        set mythrottle to mythrottle + correction.
    }
    else if ship:verticalspeed > targetv
    {
        set mythrottle to mythrottle - correction.
    }.

    print "throttle:   " + mythrottle at (0,10).
    print "vertical:   " + ship:verticalspeed at (0,11).
    print "fuel left:  " + fuel at (0,12).

}

set ship:control:pilotmainthrottle to 0.

set margin to 1.

clearscreen.

lock throttle to mythrottle.
lock steering to up + R(90, 0, 180).

set mythrottle to 0.
wait 0.5.
print "Activating engine...".

list engines in eng.
eng[0]:activate.
eng[1]:activate.
eng[2]:activate.
eng[3]:shutdown.

rcs on.

clearscreen.

set mythrottle to 1.

wait 0.2.

until false
{
    hover(0).
}
