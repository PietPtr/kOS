declare parameter ap is 240000.
declare parameter margin is 10000.

declare function getPitch
{
    set h to ship:apoapsis.
    set pitch to 90 - (h / ap * 90).
    if pitch < 0
    {
        set pitch to pitch * 35.
    }
    print "pitch: " + pitch at (0,16).
    return pitch.
}.

set targetSpeed to sqrt(ship:body:mu / (ap + ship:body:radius)).

clearscreen.

set mythrottle to 1.0.

lock throttle to mythrottle.

wait 0.5.

stage.

when maxthrust = 0 then
{
    print "staging...".
    stage.
    preserve.
    wait 1.
}.

set mysteer to heading(90,90).
lock steering to mysteer.

until ship:periapsis > 140000 and ship:apoapsis < (ap + margin)
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

print "waiting for apoaps..." at (0,0).
until ship:altitude > ship:apoapsis - (margin / 50)
{
    print "vertical speed: " + ship:verticalspeed at (0,1).
    wait 0.5.
}

clearscreen.

until ship:periapsis > (ap - margin)
{
    print "circularizing, pe = " + ship:periapsis + " of " + (ap - margin)
         at (0,0).
    set mythrottle to 0.1.
}.

set mythrottle to 0.

wait 10000.
