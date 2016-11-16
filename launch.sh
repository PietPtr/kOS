declare parameter ap is 240000.
declare parameter margin is 10000.

declare function getPitch
{
    set h to ship:apoapsis.
    set pitch to 90 - (h / 240000 * 90).
    if pitch < 0
    {
        set pitch to pitch * 5.
    }
    print "pitch: " + pitch at (0,16).
    return pitch.
}.

clearscreen.

set ship:control:pilotmainthrottle to 0.

set mythrottle to 1.0.

lock throttle to mythrottle.

wait 0.5.

stage.

when maxthrust = 0 then
{
    print "staging...".
    stage.
    set mythrottle to 1.0.
    preserve.
}.

set mysteer to heading(90,90).
lock steering to mysteer.

until ship:periapsis > 140000
{
    set mysteer to heading(90, getPitch()).

    if ship:sensors:acc:mag > 45
    {
        set mythrottle to mythrottle / 1.1.
        wait 0.5.
    }.

    print "orbital velocity: " + ship:velocity:orbit:mag at (0,15).
    print "acceleration: " + ship:sensors:acc:mag at (0, 17).
}.

lock steering to ship:prograde.
set mythrottle to 0.

wait 1.

run hohmann.sh(ap, ap, false).

set mythrottle to 0.
