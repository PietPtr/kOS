lock originPeriod to 2 * pi * sqrt(ship:orbit:semimajoraxis ^ 3 / ship:body:mu).
lock targetPeriod to 2 * pi * sqrt(target:orbit:semimajoraxis ^ 3 / target:body:mu).

set interceptAngle to 180.

set kuniverse:timewarp:rate to 10000.

until getInterceptAngle() <= 10
{
    wait 0.1.
}

set kuniverse:timewarp:rate to 100.

until getInterceptAngle() <= 1
{
    wait 0.1.
}

set kuniverse:timewarp:rate to 1.

run hohmann.sh(target:orbit:periapsis, target:orbit:apoapsis, true).
