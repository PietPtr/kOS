declare parameter height is 30000.
declare parameter hoverTime is 10.
declare parameter countdown is false.

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

set MSGFILL to "".

set ship:control:pilotmainthrottle to 0.

set margin to 1.

clearscreen.

lock throttle to mythrottle.
lock steering to up + R(0, 0, 180).

set mythrottle to 0.
wait 0.5.
print "Activating engine...".

list engines in eng.
eng[0]:activate.

set shipheight to 12.3.

if countdown
{
    from {local count is 10.} until count = 0 step
         {set count to count - 1.} do
    {
        print "..." + count.
        wait 1.
    }
}



rcs on.

clearscreen.

set mythrottle to 1.
set descentspeed to 0.5.
set fuel to 10000.

when false then // abs(ship:groundspeed) > 0.01 then
{
    set sinYaw to sin(ship:up:yaw).
    set cosYaw to cos(ship:up:yaw).
    set sinPitch to sin(ship:up:pitch).
    set cosPitch to cos(ship:up:pitch).

    set unitVectorEast to V(-cosYaw, 0, sinYaw).
    set unitVectorNorth to V(-sinYaw*sinPitch, cosPitch, -cosYaw*sinPitch).

    set shipVelocitySurface to ship:velocity:surface.
    set speedEast to vdot(shipVelocitySurface, unitVectorEast).
    set speedNorth to vdot(shipVelocitySurface, unitVectorNorth).

    print "east:  " + speedEast at (0,31).
    print "north: " + speedNorth at (0,32).


    set pitch to -speedNorth * 0.1.
    set yaw to -speedEast * 0.1.

    lock steering to up + R(pitch, yaw, 180).

    return true.
}

until ship:apoapsis >= height
{
    print "apoapsis: " + ship:apoapsis + MSGFILL at (0,0).
}

set mythrottle to 0.

until ship:verticalspeed <= 0
{
    print "vertical speed: " + ship:verticalspeed + MSGFILL at (0,0).
}

set hoverStart to time:seconds.

// brakes on.

until time:seconds - hoverStart >= hoverTime
{
    print "landing in:   " + (hoverTime - (time:seconds - hoverStart)) at (0,0).
    hover().
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
clearscreen.

rcs on.
lock descent to -alt:radar / 5.


until ship:verticalspeed >= -2
{
    set mythrottle to 1.0.
    print "SUICIDE BURN" at (0,0).
}

clearscreen.


until alt:radar <= shipheight
{
    hover(descent, 0.2).

    print "radar altitude: " + alt:radar at (0,0).
    print "throttle:       " + mythrottle at (0,1).
    print "descent speed:  " + descent at (0,2).
}

print "Engine shutdown.".

set mythrottle to 0.

rcs off.
brakes off.
wait 5.
clearscreen.
