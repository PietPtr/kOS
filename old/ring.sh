set MSGFILL to "                                                              ".

print "Launching ring module..." + MSGFILL at (0,0).

run launch.sh.

print "Launched!" + MSGFILL at (0,0).

wait 10.

print "Starting orbital rendezvous." + MSGFILL at (0,0).

run rendezvous.sh.
