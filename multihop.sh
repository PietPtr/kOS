declare parameter startheight is 100.

set counter to startheight.
until False
{
    run hop.sh(100,0).
    set counter to counter + 100.
    print "Relaunching to " + counter + " meters in a few secs".
}
