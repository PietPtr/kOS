lock distance to (ship:orbit:position - target:orbit:position):mag.
lock relativeSpeed to (ship:velocity:orbit - target:velocity:orbit):mag.

until distance < 100
{
    print (time:seconds) + ": point retrograde".
    reorient(target:velocity:orbit - ship:velocity:orbit).

    print (time:seconds) + ": cancel velocity".
    print (time:seconds) + ": relativeSpeed: " + relativeSpeed.
    set previousSpeed to relativeSpeed.

    set ship:control:fore to 0.5.

    until previousSpeed - relativeSpeed < 0
    {
        set previousSpeed to relativeSpeed.
        wait 0.1.
    }

    set ship:control:fore to 0.

    print (time:seconds) + ": point at target".
    reorient(target:orbit:position - ship:orbit:position).

    print (time:seconds) + ": burn to safe speed".
    set ship:control:fore to 0.5.
    set goalSpeed to distance / 1000.
    if goalSpeed > 50 { set goalSpeed to 50. }.
    if distance < 1200 { set goalSpeed to 4. }.

    wait until relativeSpeed >= goalSpeed.
    set ship:control:fore to 0.
    wait 1.

    print (time:seconds) + ": speed up time until distance is growing".
    set previousDistance to distance.

    set kuniverse:timewarp:mode to "rails".
    if distance > 40000 { set kuniverse:timewarp:rate to 100. }
    else if distance > 1000 { set kuniverse:timewarp:rate to 10. }
    else
    {
        set kuniverse:timewarp:mode to "physics".
        set kuniverse:timewarp:warp to 0.
    }

    until distance - previousDistance > 0
    {
        print distance - previousDistance.
        set previousDistance to distance.
        wait 0.01.
    }
    set kuniverse:timewarp:rate to 1.
    wait until kuniverse:timewarp:rate = 1.

    print (time:seconds) + ": goto 1".
}

reorient(target:velocity:orbit - ship:velocity:orbit).
set ship:control:fore to 0.5.
wait until relativeSpeed <= 0.1.
set ship:control:fore to 0.
