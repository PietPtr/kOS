declare parameter periapsis is 500000.
declare parameter apoapsis is  500000.

if periapsis > apoapsis
{
    print "Periapsis is bigger than apoapsis. Please rerun the program with " +
          "correct arguments." at (0,16).
    wait 1000000.
}

declare function burnUntill
{
    declare parameter v1.
    declare parameter v2.

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
}

// ----------- INITIALIZATION -----------

set ship:control:pilotmainthrottle to 0.

rcs on.

clearscreen.

lock throttle to 0.


// ----------- FIRST BURN -----------

run warppe.sh.

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
set a  to ((ship:altitude + ship:body:radius) +
           (apoapsis + ship:body:radius)) / 2.
set v2 to sqrt(mu * (2/r - 1/a)).

burnUntill(v1, v2).


// ----------- SECOND BURN -----------

set pe1 to ship:altitude.

print "Pe1: " + pe1 at (0,32).
print "Pe2: " + periapsis at (0,33).

if pe1 < periapsis { run warpap.sh. }.
else { run warppe.sh. }

set v1 to ship:velocity:orbit:mag.
set mu to ship:body:mu.
set r  to ship:body:radius + ship:altitude.
if pe1 < periapsis
{
    set a to ((periapsis + ship:body:radius) +
               (ship:altitude + body:radius)) / 2.
}
else
{
    set a to ((ship:altitude + ship:body:radius) +
               (apoapsis + ship:body:radius)) / 2.
}.
set v2 to sqrt(mu * (2/r - 1/a)).

burnUntill(v1, v2).
