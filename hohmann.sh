declare parameter periapsis is 500000.
declare parameter apoapsis  is 500000.
declare parameter mainIsRCS is false.

if periapsis > apoapsis
{
    print "Periapsis is bigger than apoapsis. Please rerun the program with " +
          "correct arguments." at (0,16).
    wait 1000000.
}

declare function burnUntil
{
    declare parameter v1.
    declare parameter v2.

    print "Reorienting...".

    if (v2 - v1 > 0)
    {
        lock steering to ship:prograde.
        wait 5.
        print "Burning!".

        until ship:velocity:orbit:mag >= v2
        {
            set mythrottle to 0.1.
        }
    }.
    if (v2 - v1 < 0)
    {
        lock steering to ship:retrograde.
        wait 5.
        print "Burning!".

        until ship:velocity:orbit:mag <= v2
        {
            set mythrottle to 0.1.
        }
    }.


    set mythrottle to 0.

    until mythrottle = 0 { wait 0.1. }

    wait 1.
}

// ----------- INITIALIZATION -----------

set ship:control:pilotmainthrottle to 0.

rcs on.

sas off.

clearscreen.

set mythrottle to 0.

if mainIsRCS
{
    print "Main engine is the RCS.".
    set previousThrottle to mythrottle.

    when previousThrottle <> mythrottle then
    {
        print "Adjusting RCS...".
        print "mythrottle: " + mythrottle.
        print "prevthortt: " + previousThrottle.
        if mythrottle > 0 { set ship:control:fore to 1. }
        else { set ship:control:fore to 0. }.

        set previousThrottle to mythrottle.
        return true.
    }
}
else
{
    lock throttle to mythrottle.
}


// ----------- FIRST BURN -----------

set circularOrbitVelocity to
    sqrt(ship:body:mu / (ship:altitude + ship:body:radius)).

if abs(circularOrbitVelocity - ship:velocity:orbit:mag) > 30
{
    run warppe.sh.
}

set ap1 to ship:apoapsis.

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
set a  to ((ship:altitude + ship:body:radius) +
           (apoapsis + ship:body:radius)) / 2.
set v2 to sqrt(mu * (2/r - 1/a)).

print "Starting first burn.".
burnUntil(v1, v2).


// ----------- SECOND BURN -----------

set pe1 to ship:altitude.

print "Pe1: " + pe1 at (0,32).
print "Pe2: " + periapsis at (0,33).

if pe1 > periapsis and ap1 > apoapsis { run warppe.sh. }.
else { run warpap.sh. }

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
set a to ((periapsis + ship:body:radius) +
          (apoapsis  + ship:body:radius)) / 2.
set v2 to sqrt(mu * (2/r - 1/a)).

print "Starting second burn.".
burnUntil(v1, v2).
