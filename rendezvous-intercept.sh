declare function getInterceptAngle
{
    set phaseAngle to
        (target:orbit:trueanomaly + target:orbit:argumentofperiapsis) -
        (ship:orbit:trueanomaly + ship:orbit:argumentofperiapsis).

    set originRadius to
        (ship:orbit:semiminoraxis + ship:orbit:semimajoraxis)/2.
    set targetRadius to
        (target:orbit:semiminoraxis + target:orbit:semimajoraxis)/2.

    set anglet to 180 * (1.0 -
                  ((originRadius + targetRadius) / (2 * targetRadius))^1.5).

    set interceptAngle to phaseAngle - anglet.

    if interceptAngle < 0 { set interceptAngle to 360 + interceptAngle. }.
    if interceptAngle > 360 { set interceptAngle to interceptAngle - 360. }.

    print "interceptAngle: " + interceptAngle at (0, 11).

    return interceptAngle.
}

declare function burnUntil
{
    declare parameter v1.
    declare parameter v2.

    print "Reorienting..." at (0,3).

    if (v2 - v1 > 0)
    {
        lock steering to ship:prograde.
        wait 5.
        print "Burning!" at (0,3).

        until ship:velocity:orbit:mag >= v2
        {
            set ship:control:fore to 1.0.
        }
    }.
    if (v2 - v1 < 0)
    {
        lock steering to ship:retrograde.
        wait 5.
        print "Burning!" at (0,3).

        until ship:velocity:orbit:mag <= v2
        {
            set ship:control:fore to 1.0.
        }
    }.


    set ship:control:fore to 0.

    wait 1.
}

lock originPeriod to 2 * pi * sqrt(ship:orbit:semimajoraxis ^ 3 / ship:body:mu).
lock targetPeriod to 2 * pi * sqrt(target:orbit:semimajoraxis ^ 3 / target:body:mu).

set interceptAngle to 180.

set kuniverse:timewarp:rate to 1000.
wait until kuniverse:timewarp:rate = 1000.
wait 100.
set kuniverse:timewarp:rate to 10000.
wait until kuniverse:timewarp:rate = 10000.

print "Waiting until interceptAngle is 0..." at (0,3).
until getInterceptAngle() <= 10
{
    wait 0.1.
}

set kuniverse:timewarp:rate to 100.

until getInterceptAngle() <= 1
{
    wait 0.1.
}

set kuniverse:timewarp:rate to 1.


set ap1 to ship:apoapsis.

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
set a  to ((ship:altitude + ship:body:radius) +
           (target:orbit:apoapsis + ship:body:radius)) / 2.
set v2 to sqrt(mu * (2/r - 1/a)).

print "Starting first burn." at (0,3).
burnUntil(v1, v2).

set kuniverse:timewarp:rate to 1000.

set previousDistance to distance.

until distance - previousDistance > 0
{
    print distance - previousDistance at (0, 12).
    set previousDistance to distance.
    wait 0.01.
}

set kuniverse:timewarp:rate to 1.
