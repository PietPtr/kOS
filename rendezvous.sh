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
    rcs off.

    declare parameter direction.

    lock steering to direction.

    wait 1.

    wait until ship:angularvel:mag < 0.05.

    rcs on.
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

run "rendezvous-hohmann.sh".


// ----------- INTERCEPT -----------

run "rendezvous-intercept.sh".

// ----------- APPROACH -----------

lock distance to (ship:orbit:position - target:orbit:position):mag.

until distance < 100 {
    run "rendezvous-approach.sh".
}
