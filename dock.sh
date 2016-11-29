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

declare function cvp
{
    declare parameter sv.
    set v to ((vdot(relativeVelocity, sv) / sv:mag^2) * sv).
    if vang(v, relativeVelocity) > 90 and vang(v, relativeVelocity) < 270
    {
        set v to v * -1.
    }
    return v:mag.
}

rcs off.

clearscreen.

ship:partstagged("straight")[0]:controlfrom().

set target to vessel(targetName).
set targetShip to vessel(targetName).

for port in target:dockingports
{
    if port:tag = "angled" and port:state = "Ready"
    {
        set target to port.
        reorient(R(180, 0, 0) + port:portfacing).
    }
}

lock dx to ship:controlpart:position:x - target:position:x.
lock dy to ship:controlpart:position:y - target:position:y.
lock dz to ship:controlpart:position:z - target:position:z.

lock relativeVelocity to ship:orbit:velocity:orbit -
                         targetShip:orbit:velocity:orbit.

// lock vx to ship:orbit:velocity:orbit:x - targetShip:orbit:velocity:orbit:x.
// lock vy to ship:orbit:velocity:orbit:y - targetShip:orbit:velocity:orbit:y.
// lock vz to ship:orbit:velocity:orbit:z - targetShip:orbit:velocity:orbit:z.

lock fore_sv to ship:facing:vector.
lock starboard_sv to (ship:facing + R(0, 90, 0)):vector.
lock top_sv to (ship:facing + R(90, 0, 0)):vector.

lock vx to cvp(fore_sv).
lock vy to cvp(starboard_sv).
lock vz to cvp(top_sv).

until false
{
    print "dx: " + dx at (0, 16).
    print "dy: " + dy at (0, 17).
    print "dz: " + dz at (0, 18).
    print "vx: " + vx at (0, 19).
    print "vy: " + vy at (0, 20).
    print "vz: " + vz at (0, 21).
    print "rv: " + relativeVelocity at (0, 22).
    wait(0.01).
}

// make sure dx is negative.
until dx <= 0
{
    set ship:control:fore to 0.2.
    wait until vx > 1.
    set ship:control:fore to 0.
}


// fire thrusters until vz is 1 m/s.

// wait until dz nears zero.

// fire thrusters until vz is 0 m/s.

// fire thrusters until vy is 1 m/s.

// wait until dy nears zero.

// fire thrusters until vy is 0 m/s.

// fire fore thrusters to dock.
