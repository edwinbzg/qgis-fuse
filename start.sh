#!/usr/bin/env bash

./gfuse.sh

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
exec xpra start --start=qgis --bind-tcp=0.0.0.0:$PORT --html=on && tail -f /dev/null &

# Exit immediately when one of the background processes terminate.
wait -n
