declare parameter height is 500.
declare parameter hoverTime is 30.

set margin to 1.

clearscreen.

lock throttle to mythrottle.
lock steering to heading(0,90).

rcs on.

set mythrottle to 0.
wait 0.5.
print "Activating engine...".
stage.

clearscreen.

print "Lifting off in 1 second...". wait 1.

set mythrottle to 1.
set descentspeed to 0.5.
set fuel to 10000.

until ship:apoapsis >= height - 10
{
    print "apoapsis: " + ship:apoapsis at (0,0).
    wait 0.1.
}

set mythrottle to 0.

until ship:verticalspeed <= 0
{
    print "vertical speed: " + ship:verticalspeed at (0,0).
}

set hoverStart to time:seconds.

until time:seconds - hoverStart >= hoverTime
{
    set mass to ship:mass.
    set accl to ship:sensors:grav:mag.
    set maxt to ship:maxthrust.
    set mythrottle to (mass * accl) / maxt.

    set targetv to 0.
    if ship:altitude < height - margin
    {
        set targetv to descentspeed.
    }
    else if ship:altitude > height + margin
    {
        set targetv to -1 * descentspeed.
    }

    if ship:verticalspeed < targetv
    {
        set mythrottle to mythrottle + 0.01.
    }
    else if ship:verticalspeed > targetv
    {
        set mythrottle to mythrottle - 0.01.
    }.

    set reslist to stage:resources.
    for res in reslist
    {
        if res:name = "LiquidFuel"
        {
            set fuel to res:amount.
        }
    }.


    clearscreen.
    print "throttle:     " + mythrottle at (0,0).
    print "vertical:     " + ship:verticalspeed at (0,1).
    print "target speed: " + targetv at (0,2).
    print "fuel left:    " + fuel at (0,3).
    print "landing in:   " + (hoverTime - (time:seconds - hoverStart)) at (0,4).
}

set mythrottle to 0.

lock TWR to (ship:maxthrust) / (mass * ship:sensors:grav:mag).
lock maxAcc to TWR * ship:sensors:grav:mag.
lock impactSpeed to sqrt(ship:verticalspeed^2 +
                         2*ship:sensors:grav:mag * alt:radar).
lock burnTime to impactSpeed / maxAcc.
lock burnAlt to 0.5 * maxAcc * burnTime^2.

until alt:radar <= burnAlt + 12
{
    print "burn altitude:    " + burnAlt at (0,0).
    print "TWR:              " + TWR at (0,1).
    print "max acceleration: " + maxAcc at (0,2).
    print "radar altitude:   " + alt:radar at (0,3).
    print "impact speed:     " + impactSpeed at (0,4).
}

until ship:verticalspeed >= -1
{
    set mythrottle to 1.0.
}
set mythrottle to 0.0.
rcs off.

wait 10000.
