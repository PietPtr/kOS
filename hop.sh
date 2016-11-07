declare parameter height is 500.
declare parameter hoverTime is 30.

set margin to 1.

clearscreen.

lock throttle to mythrottle.
lock steering to heading(0,90).

set mythrottle to 0.
wait 0.5.
print "Activating engine...".
stage.

rcs on.

clearscreen.

set mythrottle to 1.
set descentspeed to 0.5.
set fuel to 10000.

until ship:apoapsis >= height
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

brakes on.

until time:seconds - hoverStart >= hoverTime
{
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

    if ship:verticalspeed < 0
    {
        set mythrottle to mythrottle + 0.01.
    }
    else if ship:verticalspeed > 0
    {
        set mythrottle to mythrottle - 0.01.
    }.

    clearscreen.
    print "throttle:     " + mythrottle at (0,0).
    print "vertical:     " + ship:verticalspeed at (0,1).
    print "fuel left:    " + fuel at (0,2).
    print "landing in:   " + (hoverTime - (time:seconds - hoverStart)) at (0,5).
}

clearscreen.
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
brakes off.
clearscreen.
wait 3
.
