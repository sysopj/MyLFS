function can_build_c(){
	# Return "true" if multilib
	# Return "false" if not enabled

	local FAIL=false
	local TEST="-1"
	echo 'int main(){}' > dummy.c
	gcc -m32 dummy.c
	if [ -f ./a.out ]; then
		TEST=$(readelf -l a.out | grep '/ld-linux')
		rm -f a.out
	else
		FAIL=true
	fi

	if [[ $TEST == "" ]]; then
		FAIL=true
	fi

	rm -f dummy.c

	if [[ $FAIL == "true" ]]; then
		echo false
	else
		echo true
	fi
}

function can_build_g(){
    echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
    if [ ! -x dummy ]
    then
        echo false
	else
		echo true
    fi
    rm -f dummy.c dummy
}

function is_multilib_compatible(){
	# Return "true" if multilib
	# Return "false" if not enabled

	local FAIL=false
	local TEST="-1"
	echo 'int main(){}' > dummy.c
	gcc -m32 dummy.c
	if [ -f ./a.out ]; then
		TEST=$(readelf -l a.out | grep '/ld-linux')
		rm -f a.out
	else
		FAIL=true
	fi

	if [[ $TEST == "" ]]; then
		FAIL=true
	fi

	gcc -mx32 dummy.c
	if [ -f ./a.out ]; then
		TEST=$(readelf -l a.out | grep '/ld-linux-x32')
		rm -f a.out
	else
		FAIL=true
	fi
	
	if [[ $TEST == "" ]]; then
		FAIL=true
	fi
	
	rm -f dummy.c

	if [[ $FAIL == "true" ]]; then
		echo false
	else
		echo true
	fi
}

echo "can_build_c="$(can_build_c)
echo "can_build_g="$(can_build_g)
is_multilib_compatible=$(is_multilib_compatible)
echo "is_multilib_compatible=$is_multilib_compatible"

echo ""
if [[ $is_multilib_compatible == "true" ]]; then echo "Script Passed"; else echo "Script Failed"; fi
echo ""
if [[ $is_multilib_compatible == "true" ]]; then exit 0; else exit 1; fi
