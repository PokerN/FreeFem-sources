#!/bin/sh
# Runs all regression tests on all compiled FreeFem++ versions
# ------------------------------------------------------------

# Antoine Le Hyaric - LJLL Paris 6 - lehyaric@ann.jussieu.fr - 19/5/04
# $Id$

# To run one set of tests on one executable
# $1=program to run
# $2=tag for trace file
# $3=EDP script to run
function dotest(){

    # Running FreeFem++ on regtests.edp (specific to regression
    # tests), otherwise on all.edp.

    ffcmd="$1 $3|tee regtests-$2.log"
    echo $ffcmd
    eval $ffcmd
    if test $? != 0
	then
	exit 1
    fi
}

# For the example++-load tests
export LD_LIBRARY_PATH=.

# In visual checks, we can run even the most invasive programs
script=$REGEDP
if test "$VISUALCHECK" = yes -a "$REGEDP" = regtests.edp
then
    script=all.edp
fi

# Do not test windowed programs by default, because their windows are
# too invasive.

if test "$VISUALCHECK" = yes
then
    dotest ${PROGLOC}/std/FreeFem++${EXEEXT} std $script
fi

dotest ${PROGLOC}/nw/FreeFem++-nw${EXEEXT} nw $script

if test "${X11PROG}" != "" -a "${VISUALCHECK}" = "yes"
then
    dotest ${PROGLOC}/x11/FreeFem++-x11${EXEEXT} x11 $script
fi

if test "${GLXPROG}" != "" -a "${VISUALCHECK}" = "yes"
then
    dotest ${PROGLOC}/glx/FreeFem++-glx${EXEEXT} glx $script
fi

if test "${AGLPROG}" != "" -a "${VISUALCHECK}" = "yes"
then
    dotest ${PROGLOC}/agl/FreeFem++-agl${EXEEXT} agl $script
fi

if test "${MPIPROG}" != ""
then
    dotest ${PROGLOC}/mpi/FreeFem++-mpi${EXEEXT} mpi $script
fi