#!/usr/bin/env bash

# Compare 2 software versions of Major.Minor.REVIN.Build.Patch (M.m.r.b+px)
# Compare 2 software versions of Major.Minor.REVIN.Build.Patch (M.m.r.b+letter)
# -cmp	is default
# -gt	return is 1 / 0
# -ge	return is 1 / 0
# -eq	return is 1 / 0
# -ne	return is 1 / 0
# -le	return is 1 / 0
# -lt	return is 1 / 0
# -cmp	return -1 for INPUT_A is larger
#		return  0 for equal
#		return  1 for INPUT_B is larger
# Usage	compare.sh 2025a 2025b
# Usage	compare.sh 2025a -gt 2025b
# Usage	compare.sh 4.2.8p18 -gt 4.2.8p17
# Usage	compare.sh 4.2.8.0 -gt 4.2.8.1

# Function Library

function letter_to_number() {
	local letter="$1"
	if [[ ! $letter =~ ^[a-zA-Z]$ ]]; then
		echo "letter_to_number: Invalid input"
		return 1
	fi
	local letter_lower=$(echo "$letter" | tr '[:upper:]' '[:lower:]')
	VAL=$(printf "%d" $(( $(printf '%d' "'$letter_lower") - 96 )))
	echo $VAL
}

function input_parse {
	INPUT_A=$1
	OP_CODE=$2
	INPUT_B=$3

	# If no op_code, set default of "-cmp"
	[[ ! $INPUT_B ]] && INPUT_B=$2 && OP_CODE="-cmp"

	# Parse INPUT_A
	FEILD_COUNT=$(echo "$INPUT_A" | grep -o '\.' | wc -l)
	HAS_LETTER=false
	TEMP=$(echo "$INPUT_A" | grep -oP '[a-zA-Z]+')
	[[ $TEMP != "" ]] && HAS_LETTER=true && LETTER=$TEMP

	#Major.Minor.REVIN.Build.Patch
	MAJOR_A=0
	MINOR_A=0
	REVIN_A=0
	BUILD_A=0
	PATCH_A=0
	[ $HAS_LETTER ] && PATCH_A=$(letter_to_number $LETTER)

	[ $FEILD_COUNT -ge 0 ] && MAJOR_A=$(echo $INPUT_A | cut -d "." -f 1)
	# MAJOR_A could have a letter from tzdata2025a.tar.gz
	[ $FEILD_COUNT -ge 1 ] && MINOR_A=$(echo $INPUT_A | cut -d "." -f 2)
	[ $FEILD_COUNT -ge 2 ] && REVIN_A=$(echo $INPUT_A | cut -d "." -f 3)
	[ $FEILD_COUNT -ge 3 ] && BUILD_A=$(echo $INPUT_A | cut -d "." -f 4)
	[[ $(echo $INPUT_A | grep "p") != "" ]] && PATCH_A=$(echo $INPUT_A | cut -d "p" -f 2)
	[[ $(echo $INPUT_A | grep "P") != "" ]] && PATCH_A=$(echo $INPUT_A | cut -d "P" -f 2)

	MAJOR_A=${MAJOR_A%%[!0-9]*}
	MINOR_A=${MINOR_A%%[!0-9]*} #$(echo "$MINOR_A" | grep -oP '\d+')
	REVIN_A=${REVIN_A%%[!0-9]*} #$(echo "$REVIN_A" | grep -oP '\d+')
	BUILD_A=${BUILD_A%%[!0-9]*} #$(echo "$BUILD_A" | grep -oP '\d+')

	# Parse INPUT_B
	FEILD_COUNT=$(echo "$INPUT_B" | grep -o '\.' | wc -l)
	HAS_LETTER=false
	TEMP=$(echo "$INPUT_B" | grep -oP '[a-zA-Z]+')
	[[ $TEMP != "" ]] && HAS_LETTER=true && LETTER=$TEMP

	#Major.Minor.REVIN.Build.Patch
	MAJOR_B=0
	MINOR_B=0
	REVIN_B=0
	BUILD_B=0
	PATCH_B=0
	[ $HAS_LETTER ] && PATCH_B=$(letter_to_number $LETTER)

	[ $FEILD_COUNT -ge 0 ] && MAJOR_B=$(echo $INPUT_B | cut -d "." -f 1)
	# MAJOR_B could have a letter from tzdata2025a.tar.gz
	[ $FEILD_COUNT -ge 1 ] && MINOR_B=$(echo $INPUT_B | cut -d "." -f 2)
	[ $FEILD_COUNT -ge 2 ] && REVIN_B=$(echo $INPUT_B | cut -d "." -f 3)
	[ $FEILD_COUNT -ge 3 ] && BUILD_B=$(echo $INPUT_B | cut -d "." -f 4)
	[[ $(echo $INPUT_B | grep "p") != "" ]] && PATCH_B=$(echo $INPUT_B | cut -d "p" -f 2)
	[[ $(echo $INPUT_B | grep "P") != "" ]] && PATCH_B=$(echo $INPUT_B | cut -d "P" -f 2)

	MAJOR_B=${MAJOR_B%%[!0-9]*}
	MINOR_B=${MINOR_B%%[!0-9]*} #$(echo "$MINOR_B" | grep -oP '\d+')
	REVIN_B=${REVIN_B%%[!0-9]*} #$(echo "$REVIN_B" | grep -oP '\d+')
	BUILD_B=${BUILD_B%%[!0-9]*} #$(echo "$BUILD_B" | grep -oP '\d+')
}

function op_code_cmp {
	OP_FINISHED=false
	[[ $MAJOR_A -gt $MAJOR_B ]] && OP_FINISHED=true && RETURN=-1
	[[ $MAJOR_A -lt $MAJOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -gt $MINOR_B ]] && OP_FINISHED=true && RETURN=-1
	[[ $MINOR_A -lt $MINOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -gt $REVIN_B ]] && OP_FINISHED=true && RETURN=-1
	[[ $REVIN_A -lt $REVIN_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -gt $BUILD_B ]] && OP_FINISHED=true && RETURN=-1
	[[ $BUILD_A -lt $BUILD_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -gt $PATCH_B ]] && OP_FINISHED=true && RETURN=-1
	[[ $PATCH_A -eq $PATCH_B ]] && OP_FINISHED=true && RETURN=0
	[[ $PATCH_A -lt $PATCH_B ]] && OP_FINISHED=true && RETURN=1
	echo $RETURN && return
}

function op_code_gt {
	OP_FINISHED=false
	RETURN=0
	[[ $MAJOR_A -gt $MAJOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -gt $MINOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -gt $REVIN_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -gt $BUILD_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -gt $PATCH_B ]] && OP_FINISHED=true && RETURN=1
	echo $RETURN && return
}

function op_code_ge {
	OP_FINISHED=false
	RETURN=1
	[[ $MAJOR_A -lt $MAJOR_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -lt $MINOR_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -lt $REVIN_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -lt $BUILD_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -lt $PATCH_B ]] && OP_FINISHED=true && RETURN=0
	echo $RETURN && return
}

function op_code_eq {
	OP_FINISHED=false
	RETURN=1
	[[ $MAJOR_A -ne $MAJOR_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -ne $MINOR_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -ne $REVIN_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -ne $BUILD_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -ne $PATCH_B ]] && OP_FINISHED=true && RETURN=0
	echo $RETURN && return
}

function op_code_ne {
	OP_FINISHED=false
	RETURN=0
	[[ $MAJOR_A -ne $MAJOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -ne $MINOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -ne $REVIN_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -ne $BUILD_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -ne $PATCH_B ]] && OP_FINISHED=true && RETURN=1
	echo $RETURN && return
}

function op_code_le {
	OP_FINISHED=false
	RETURN=1
	[[ $MAJOR_A -gt $MAJOR_B ]] && OP_FINISHED=true && RETURN=0 && echo hit
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -gt $MINOR_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -gt $REVIN_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -gt $BUILD_B ]] && OP_FINISHED=true && RETURN=0
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -gt $PATCH_B ]] && OP_FINISHED=true && RETURN=0
	echo $RETURN && return
}

function op_code_lt {
	OP_FINISHED=false
	RETURN=0
	[[ $MAJOR_A -lt $MAJOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $MINOR_A -lt $MINOR_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $REVIN_A -lt $REVIN_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $BUILD_A -lt $BUILD_B ]] && OP_FINISHED=true && RETURN=1
	[[ $OP_FINISHED == true ]] && echo $RETURN && return
	[[ $PATCH_A -lt $PATCH_B ]] && OP_FINISHED=true && RETURN=1
	echo $RETURN && return
}

function op_code_test {
	INPUT_A=$1
	OP_CODE=$2
	INPUT_B=$3
	CANSWER=$4
	
	input_parse $INPUT_A $OP_CODE $INPUT_B
	
	[[ $OP_CODE == "-cmp" ]] && RANSWER=$(op_code_cmp)
	[[ $OP_CODE == "-gt" ]] && RANSWER=$(op_code_gt)
	[[ $OP_CODE == "-ge" ]] && RANSWER=$(op_code_ge)
	[[ $OP_CODE == "-eq" ]] && RANSWER=$(op_code_eq)
	[[ $OP_CODE == "-ne" ]] && RANSWER=$(op_code_ne)
	[[ $OP_CODE == "-le" ]] && RANSWER=$(op_code_le)
	[[ $OP_CODE == "-lt" ]] && RANSWER=$(op_code_lt)
	
	
	if [[ $CANSWER == $RANSWER ]]; then
		echo "[[ $INPUT_A $OP_CODE $INPUT_B ]] => $RANSWER == $CANSWER : PASS"
	else
		echo "[[ $INPUT_A $OP_CODE $INPUT_B ]] => $RANSWER == $CANSWER : FAIL"
	fi
}

function op_code_unit_test {
	# Input_A OP_Code Input_B Correct_Answer
	op_code_test 2021a -gt 2022b 0
	op_code_test 2021b -gt 2022b 0
	op_code_test 2021c -gt 2022b 0
	op_code_test 2021a -ge 2022b 0
	op_code_test 2021b -ge 2022b 1
	op_code_test 2021c -ge 2022b 1
	op_code_test 2021a -eq 2022b 0
	op_code_test 2021b -eq 2022b 1
	op_code_test 2021c -eq 2022b 0
	op_code_test 2021a -le 2022b 0
	op_code_test 2021b -le 2022b 1
	op_code_test 2021c -le 2022b 0
	op_code_test 2021a -lt 2022b 0
	op_code_test 2021b -lt 2022b 1
	op_code_test 2021c -lt 2022b 0
}

# Main Script

# if not --test, and there are 2 inputs then normal run, else do --test
[[ $1 != "--test" ]] && [[ $2 != "" ]] && input_parse $1 $2 $3 || OP_CODE=$1

[[ $OP_CODE == "-cmp" ]] && op_code_cmp
[[ $OP_CODE == "-gt" ]] && op_code_gt
[[ $OP_CODE == "-ge" ]] && op_code_ge
[[ $OP_CODE == "-eq" ]] && op_code_eq
[[ $OP_CODE == "-ne" ]] && op_code_ne
[[ $OP_CODE == "-le" ]] && op_code_le
[[ $OP_CODE == "-lt" ]] && op_code_lt
[[ $OP_CODE == "--test" ]] && op_code_unit_test
