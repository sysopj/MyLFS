#!/bin/bash
function fTIME {
	local START_TIME=$1
	
	END_TIME=$(date +%s)

	local D_SECOND=$((END_TIME-START_TIME))
	
	local D_HOURS=$(awk "BEGIN {printf \"%i\n\", $D_SECOND / 3600 }")
	local LESS_SECONDS=$(awk "BEGIN {printf \"%i\n\", $D_HOURS * 3600 }")
	local D_SECOND=$((D_SECOND - LESS_SECONDS))

	local D_MINUETS=$(awk "BEGIN {printf \"%i\n\", $D_SECOND / 60 }")
	local LESS_SECONDS=$(awk "BEGIN {printf \"%i\n\", $D_MINUETS * 60 }")
	local D_SECOND=$((D_SECOND - LESS_SECONDS))

	local D_SECONDS=$D_SECOND

	#echo "$D_HOURS:$D_MINUETS:$D_SECONDS"
}

echo "Loading config.sh"
source ./config.sh

cp batch_build.sh current_build.sh

if [[ $MULTILIB == "true" ]]; then
	BUILD_COMMAND=run_build_"$LFS_VERSION"_"$LFSINIT"_multilib
else
	BUILD_COMMAND=run_build_"$LFS_VERSION"_"$LFSINIT"
fi

echo $BUILD_COMMAND

sed -i "s/batch_build_main #/$BUILD_COMMAND/g" current_build.sh

START_TIME=$(date +%s)
./current_build.sh
time fTIME $START_TIME

rm current_build.sh
