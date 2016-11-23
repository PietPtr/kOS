declare function runHohmann
{
    declare parameter periapsis.
    declare parameter apoapsis.

    run hohmann.sh(periapsis, apoapsis, true).
}

set phaseAngle to
    (target:orbit:trueanomaly + target:orbit:argumentofperiapsis) -
    (ship:orbit:trueanomaly + ship:orbit:argumentofperiapsis).

if phaseAngle < 0 { set phaseAngle to phaseAngle + 360. }.

set catchupHeight to 0.

if phaseAngle < 180 { set catchupHeight to phaseAngle * 1000 + 10000. }.
else { set catchupHeight to (360 - phaseAngle) * 1000 - 10000. }.

if phaseAngle < 180
{
    run hohmann.sh(target:orbit:periapsis - catchupHeight,
                   target:orbit:apoapsis - catchupHeight, true).

}
else
{
    run hohmann.sh(target:orbit:periapsis + catchupHeight,
                   target:orbit:apoapsis + catchupHeight, true).
}.
