declare parameter warprate is 100.

set kuniverse:timewarp:rate to warprate.

clearscreen.

set lastv to ship:velocity:orbit:mag.
set acc to false.
set wasAcc to false.
lock dec to not acc.
set atPeriapsis to false.

until atPeriapsis
{
    print "Warping to periaps..." at (0,0).
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

    if wasAcc and not acc
    {
        set atPeriapsis to true.
    }.

    set lastv to ship:velocity:orbit:mag.
    set wasAcc to acc.
}

set kuniverse:timewarp:rate to 1.

clearscreen.
