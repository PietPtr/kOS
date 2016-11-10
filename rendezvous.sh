// Script to rendezvous with given target.
// Assumes both vessels are in low orbit and that the active vessel uses RCS
// for all mavouvers (as is usual in real rendezvous)

declare parameter targetName is "tgt".

// ----------- INITIALIZATION -----------

clearscreen.

set target to vessel(targetName).
set ship:control:pilotmainthrottle to 0.

rcs on.
sas off.

set ship:control:fore to 0.

// ----------- HOHMANN -----------

until false
{
    set phaseAngle to
        (target:orbit:trueanomaly + target:orbit:argumentofperiapsis) -
        (ship:orbit:trueanomaly + ship:orbit:argumentofperiapsis).

    if phaseAngle < 0 { set phaseAngle to phaseAngle + 360. }.

    print phaseAngle at (0, 15).

}

// ----------- INTERCEPT -----------



// ----------- APPROACH -----------
