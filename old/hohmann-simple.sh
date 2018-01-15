declare parameter periapsis is 500000.
declare parameter apoapsis is  500000.

set ship:control:pilotmainthrottle to 0.

rcs on.

clearscreen.

lock throttle to 0.
lock steering to ship:prograde.

run warppe.sh.

until kuniverse:timewarp:rate = 1 { wait 0.1. }

wait 5.

until ship:apoapsis >= apoapsis
{
    lock throttle to 0.2.
}

lock throttle to 0.

until throttle = 0 { wait 0.1. }

wait 1.

run warpap.sh.

until kuniverse:timewarp:rate = 1 { wait 0.1. }

wait 5.

until ship:periapsis >= periapsis - 20000
{
    lock throttle to 0.2.
}

