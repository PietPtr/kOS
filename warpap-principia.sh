declare parameter warprate is 100.

set kuniverse:timewarp:rate to warprate.

clearscreen.

set lastv to ship:velocity:orbit:mag.
set acc to true.
set wasAcc to true.
lock dec to not acc.
set atApoapsis to false.

until atApoapsis
{
    print "Warping to apoaps..." at (0,0).
    print "Accelerating: " + acc at (0,1).
    print "lastv - v:    " + (lastv - ship:velocity:orbit:mag) at (0,2).

    if lastv - ship:velocity:orbit:mag > 0          // Decelerating
    {
        set acc to false.
    }.
    if lastv - ship:velocity:orbit:mag < 0
    {
        set acc to true.
    }.

    if not wasAcc and acc
    {
        set atApoapsis to true.
    }.

    set lastv to ship:velocity:orbit:mag.
    set wasAcc to acc.
}

set kuniverse:timewarp:rate to 1.

until kuniverse:timewarp:rate = 1 { wait 0.1. }

clearscreen.
