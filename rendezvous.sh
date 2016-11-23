// Script to rendezvous with given target.
// Assumes both vessels are in low orbit and that the active vessel uses RCS
// Assumes both vessels have nearly the same inclination.
// for all mavouvers (as is usual in real rendezvous)
// DO NOT:
//  - run this script with a target with an orbit under 200km,
//    it might deorbit the spacecraft.

declare parameter targetName is "tgt".

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

ship:partstagged("cpu")[0]:controlfrom().

lock distance to (ship:orbit:position - target:orbit:position):mag.
lock relativeSpeed to (ship:velocity:orbit - target:velocity:orbit):mag.

// ----------- HOHMANN -----------

run "rendezvous-hohmann.sh".

// ----------- INTERCEPT -----------

run "rendezvous-intercept.sh".

// ----------- APPROACH -----------

run "rendezvous-approach.sh".
