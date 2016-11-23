until distance < 100
{
    print "speed up time until distance is growing" + MSGFILL at (0,0).
    set previousDistance to distance.

    set kuniverse:timewarp:mode to "rails".
    if distance > 40000 { set kuniverse:timewarp:rate to 100. }
    else if distance > 1000 { set kuniverse:timewarp:rate to 10. }
    else
    {
        set kuniverse:timewarp:mode to "physics".
        set kuniverse:timewarp:warp to 2.
    }

    until distance - previousDistance > 0
    {
        print distance - previousDistance at (0, 14).
        set previousDistance to distance.
        wait 0.01.
    }
    set kuniverse:timewarp:rate to 1.
    wait until kuniverse:timewarp:rate = 1.


    print "point prograde" + MSGFILL at (0,0).
    reorient(ship:velocity:orbit - target:velocity:orbit).

    print "cancel velocity" + MSGFILL at (0,0).
    set previousSpeed to relativeSpeed.

    set ship:control:fore to -1.

    until previousSpeed - relativeSpeed < 0
    {
        print "relativeSpeed: " + relativeSpeed at (0,13).
        set previousSpeed to relativeSpeed.
        if relativeSpeed > 10
        {
            lock steering to (ship:velocity:orbit -
                              target:velocity:orbit).
        }
        wait 0.1.
    }

    set ship:control:fore to 0.

    print "point at target" + MSGFILL at (0,0).
    reorient(target:orbit:position - ship:orbit:position).

    print "burn to safe speed" + MSGFILL at (0,0).
    set ship:control:fore to 1.
    set goalSpeed to (distance / 1000) * 1.1.
    if goalSpeed > 50 { set goalSpeed to 75. }.
    if distance < 4000 { set goalSpeed to 4. }.
    if distance < 1000 { set goalSpeed to 2. }.
    print "relative speed: " + relativeSpeed at (0,2).
    print "goal speed: " + goalSpeed at (0,3).

    wait until relativeSpeed >= goalSpeed.
    set ship:control:fore to 0.
    wait 1.

}

reorient(target:velocity:orbit - ship:velocity:orbit).
set ship:control:fore to 0.5.
wait until relativeSpeed <= 0.1.
set ship:control:fore to 0.
