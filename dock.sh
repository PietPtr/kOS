rcs off.



for port in target:dockingports
{
    if port:tag = "angled" and port:state = "Ready"
    {
        lock steering to R(-1, -1, -1) * port:portfacing.
    }
}

wait(100).
