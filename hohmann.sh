declare parameter periapsis is 500000.
declare parameter apoapsis is  500000.

set ship:control:pilotmainthrottle to 0.

rcs on.

clearscreen.

lock throttle to 0.
lock steering to ship:prograde.

run warppe.sh.

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
set a  to ((ship:altitude + ship:body:radius) +
           (apoapsis + ship:body:radius)) / 2.
set v2 to sqrt(mu * (2/r - 1/a)).

if (v2 - v1 > 0)
{
    lock steering to ship:prograde.
    wait 5.

    until ship:velocity:orbit:mag >= v2
    {
        lock throttle to 0.1.
    }
}.
if (v2 - v1 < 0)
{
    lock steering to ship:retrograde.
    wait 5.

    until ship:velocity:orbit:mag <= v2
    {
        lock throttle to 0.1.
    }
}.

lock throttle to 0.

until throttle = 0 { wait 0.1. }

wait 1.

if ship:altitude < periapsis { run warpap.sh. }.
else { run warppe.sh. }

wait 5.

until ship:periapsis >= periapsis - 20000
{
    lock throttle to 0.2.
}
