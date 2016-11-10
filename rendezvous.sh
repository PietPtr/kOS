// Script to rendezvous with given target.
// Assumes both vessels are in low orbit and that the active vessel uses RCS
// for all mavouvers (as is usual in real rendezvous)
// DO NOT:
//  - run this script with a target with an orbit under 200km,
//    it might deorbit the spacecraft.

declare parameter targetName is "tgt".

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

set catchupHeight to 50 * 1000.

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



// ----------- APPROACH -----------
