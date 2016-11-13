// Script to rendezvous with given target.
// Assumes both vessels are in low orbit and that the active vessel uses RCS
// Assumes both vessels have nearly the same inclination.
// for all mavouvers (as is usual in real rendezvous)
// DO NOT:
//  - run this script with a target with an orbit under 200km,
//    it might deorbit the spacecraft.

declare parameter targetName is "tgt".

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

    return interceptAngle.
}

declare function reorient
{
    declare parameter direction.

    lock steering to direction.

    wait 0.1.

    wait until ship:angularvel:mag < 0.05.
}

// ----------- TRIGGERS -----------

// ----------- INITIALIZATION -----------

clearscreen.

set target to vessel(targetName).
set ship:control:pilotmainthrottle to 0.

rcs on.
sas off.

set ship:control:fore to 0.

// ----------- HOHMANN -----------

set phaseAngle to
    (target:orbit:trueanomaly + target:orbit:argumentofperiapsis) -
    (ship:orbit:trueanomaly + ship:orbit:argumentofperiapsis).

if phaseAngle < 0 { set phaseAngle to phaseAngle + 360. }.

set catchupHeight to 0.

if phaseAngle < 180 { set catchupHeight to phaseAngle * 1000 + 10000. }.
else { set catchupHeight to (360 - phaseAngle) * 1000 - 10000. }.

if phaseAngle < 180
{
    run hohmann.sh(target:orbit:periapsis - catchupHeight,
                   target:orbit:apoapsis - catchupHeight, true).
}
else
{
    run hohmann.sh(target:orbit:periapsis + catchupHeight,
                   target:orbit:apoapsis + catchupHeight, true).
}.


// ----------- INTERCEPT -----------

lock originPeriod to 2 * pi * sqrt(ship:orbit:semimajoraxis ^ 3 / ship:body:mu).
lock targetPeriod to 2 * pi * sqrt(target:orbit:semimajoraxis ^ 3 / target:body:mu).

set interceptAngle to 180.

set kuniverse:timewarp:rate to 10000.

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

run hohmann.sh(target:orbit:periapsis, target:orbit:apoapsis, true).

// ----------- APPROACH -----------

lock distance to (ship:position - target:position):mag.

until distance < 100
{
    // point retrograde
    reorient(target:velocity:orbit - ship:velocity:orbit).

    // cancel velocity
    set previousSpeed to (ship:velocity:orbit - target:velocity:orbit):mag.

    set ship:control:fore to 0.5.

    until previousSpeed - (ship:velocity:orbit - target:velocity:orbit):mag < 0
    {
        set previousSpeed to (ship:velocity:orbit - target:velocity:orbit):mag.
        wait 0.1.
    }

    set ship:control:fore to 0.1.

    // point at target
    sas on.
    set navmode to "target".


    // burn to safe speed

    // speed up time until distance is growing

    // goto 1
}
