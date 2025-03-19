#!/bin/bash
# A script to list version numbers of critical development tools

# If you have tools installed in other directories, adjust PATH here AND
# in ~lfs/.bashrc (section 4.4) as well.

LC_ALL=C 
POPPATH=$PATH
PATH=/usr/bin:/bin
ERROR=false

bail() { echo "FATAL: $1"; exit 1; }

grep --version > /dev/null 2> /dev/null || bail "grep does not work"
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

sed '' /dev/null || bail "sed does not work"
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

sort   /dev/null || bail "sort does not work"
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

ver_check()
{
   if ! type -p $2 &>/dev/null
   then 
     echo "ERROR: Cannot find $2 ($1)"; return 1; 
   fi
   v=$($2 --version 2>&1 | grep -E -o '[0-9]+\.[0-9\.]+[a-z]*' | head -n1)
   if printf '%s\n' $3 $v | sort --version-sort --check &>/dev/null
	   then 
		 printf "OK:    %-9s %-6s >= $3\n" "$1" "$v"; return 0;
	   else 
		 printf "ERROR: %-9s is TOO OLD ($3 or later required)\n" "$1"; 
		 return 1; 
   fi
}

ver_kernel()
{
   kver=$(uname -r | grep -E -o '^[0-9\.]+')
   if printf '%s\n' $1 $kver | sort --version-sort --check &>/dev/null
   then 
     printf "OK:    Linux Kernel $kver >= $1\n"; return 0;
   else 
     printf "ERROR: Linux Kernel ($kver) is TOO OLD ($1 or later required)\n" "$kver"; 
     return 1; 
   fi
}

# Coreutils first because-sort needs Coreutils >= 7.0
ver_check Coreutils      sort     7.0 || bail "--version-sort unsupported"
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Bash           bash     3.2
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Binutils       ld       2.13.1
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Bison          bison    2.7
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Diffutils      diff     2.8.1
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Findutils      find     4.2.31
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Gawk           gawk     4.0.1
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check GCC            gcc      5.1
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check "GCC (C++)"    g++      5.1
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Grep           grep     2.5.1a
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Gzip           gzip     1.3.12
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check M4             m4       1.4.10
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Make           make     4.0
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Patch          patch    2.5.4
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Perl           perl     5.8.8
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Python         python3  3.4
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Sed            sed      4.1.5
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Tar            tar      1.22
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Texinfo        texi2any 4.7
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_check Xz             xz       5.0.0
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi
ver_kernel 4.14
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]
then echo "OK:    Linux Kernel supports UNIX 98 PTY";
else echo "ERROR: Linux Kernel does NOT support UNIX 98 PTY"; ERROR=true; fi

alias_check() {
   if $1 --version 2>&1 | grep -qi $2
   then printf "OK:    %-4s is $2\n" "$1"; return 0;
   else printf "ERROR: %-4s is NOT $2\n" "$1"; return 1; fi
}
echo "Aliases:"
alias_check awk GNU
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

alias_check yacc Bison
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

alias_check sh Bash
retVal=$?
if [ $retVal -ne 0 ]; then ERROR=true; fi

echo "Compiler check:"
if [ -x "$(command -v g++)" ];
	then 
		if printf "int main(){}" | g++ -x c++ -
		then echo "OK:    g++ works";
		else echo "ERROR: g++ does NOT work"; ERROR=true; fi
		rm -f a.out
	else echo "ERROR: g++ does NOT work"; ERROR=true; 
fi


PATH=$POPPATH

echo ""
if [ $ERROR == true ]; then echo "Script Failed"; else echo "Script Passed"; fi
echo ""

if [ $ERROR == true ]; then	exit 1; else exit 0; fi