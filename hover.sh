// takes the rocket to a predefined height, hovers there and takes pilot input

declare parameter height is 500.

declare function hover
{
    declare parameter targetv is 0.
    declare parameter correction is 0.01.

    set mass to ship:mass.
    set accl to ship:sensors:grav:mag.
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

clearscreen.

lock throttle to mythrottle.
lock steering to heading(0,90).

set mythrottle to 0.
wait 0.5.
print "Activating engine...".
stage.

set mythrottle to 1.

until ship:apoapsis >= height
{
    print "apoapsis: " + ship:apoapsis at (0,0).
}

set mythrottle to 0.

until ship:verticalspeed <= 0
{
    print "vertical speed: " + ship:verticalspeed at (0,0).
}

rcs on.

clearscreen.

set mythrottle to 1.

until false
{
    hover().
}
