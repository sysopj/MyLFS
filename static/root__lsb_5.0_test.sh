#export LFS=/mnt/smb/D/MyLFS/mnt/lfs

# LSB Core

EXIT_CODE=0
FAIL=""

function 5_0_2_2_x86_64 {
	if [ ! -f $LFS/lib/libc.so.6 ];				then FAIL=libcl,$FAIL;			fi
	if [ ! -f $LFS/lib/libm.so.6 ];				then FAIL=filibm,$FAIL;			fi
	if [ ! -f $LFS/lib64/ld-lsb-x86-64.so.3 ];	then FAIL=fiproginterp,$FAIL;	fi
}

# Table 2-1 LSB Core Module Library Names
if [ ! -f $LFS/lib/libcrypt.so.1 ];			then FAIL=libcrypt,$FAIL;			fi
if [ ! -f $LFS/lib/libdl.so.2 ];			then FAIL=libdl,$FAIL;				fi
if [ ! -f $LFS/lib/libgcc_s.so.1 ];			then FAIL=libgcc_s,$FAIL;			fi
if [ ! -f $LFS/lib/libncurses.so.5 ];		then FAIL=libncurses,$FAIL;			fi
if [ ! -f $LFS/lib/libncursesw.so.5 ];		then FAIL=libncursesw,$FAIL;		fi #
if [ ! -f $LFS/lib/libnspr4.so ];			then FAIL=libnspr4,$FAIL;			fi
if [ ! -f $LFS/lib/libnss3.so ];			then FAIL=libnss3,$FAIL;			fi
if [ ! -f $LFS/lib/libpam.so.0 ];			then FAIL=libpam,$FAIL;				fi
if [ ! -f $LFS/lib/libpthread.so.0 ];		then FAIL=libpthread,$FAIL;			fi
if [ ! -f $LFS/lib/librt.so.1 ];			then FAIL=librt,$FAIL;				fi
if [ ! -f $LFS/lib/libssl3.so ];			then FAIL=libssl3,$FAIL;			fi
if [ ! -f $LFS/lib/libstdc++.so.6 ];		then FAIL=libstdcxx,$FAIL;			fi
if [ ! -f $LFS/lib/libutil.so.1 ];			then FAIL=libutil,$FAIL;			fi
if [ ! -f $LFS/lib/libz.so.1 ]; 			then FAIL=libz,$FAIL;				fi

ARCH=$(uname -m)

# Table 2-2 LSB Core Module Library Names which vary by architecture
case $ARCH in
	"x86_64")
		5_0_2_2_x86_64
		;;
	*)
		echo "ERROR: Unsupported Architecture by script"
		exit 255
		;;
esac

if [[ ! $FAIL ]]; then
	echo ""
	echo "LSB Core = Pass"
else
	echo ""
	echo "LSB Core = Failed"
	echo "	Failed = "$FAIL
	EXIT_CODE=$((EXIT_CODE+1))
fi

FAIL=""

# Table 2-3 LSB Desktop Module Library Names
if [ ! -f $LFS/lib/libGL.so.1 ];					then FAIL=libG,$FAIL;						fi
if [ ! -f $LFS/lib/libGLU.so.1 ];					then FAIL=libGLU,$FAIL;						fi
if [ ! -f $LFS/lib/libICE.so.6 ];					then FAIL=libICE,$FAIL;						fi
if [ ! -f $LFS/lib/libQtCore.so.4 ];				then FAIL=libQtCore,$FAIL;					fi
if [ ! -f $LFS/lib/libQtGui.so.4 ];					then FAIL=libQtGui,$FAIL;  					fi
if [ ! -f $LFS/lib/libQtNetwork.so.4 ];				then FAIL=libQtNetwork,$FAIL;				fi
if [ ! -f $LFS/lib/libQtOpenGL.so.4 ];				then FAIL=libQtOpenGL,$FAIL;				fi
if [ ! -f $LFS/lib/libQtSql.so.4 ];					then FAIL=libQtSql,$FAIL;					fi
if [ ! -f $LFS/lib/libQtSvg.so.4 ];					then FAIL=libQtSvg,$FAIL;					fi
if [ ! -f $LFS/lib/libQtXml.so.4 ];					then FAIL=libQtXml,$FAIL;					fi
if [ ! -f $LFS/lib/libSM.so.6 ];					then FAIL=libSM,$FAIL;						fi
if [ ! -f $LFS/lib/libX11.so.6 ];					then FAIL=libX11,$FAIL;						fi
if [ ! -f $LFS/lib/libXext.so.6 ];					then FAIL=libXext,$FAIL;					fi
if [ ! -f $LFS/lib/libXft.so.2 ];					then FAIL=libXft,$FAIL;						fi
if [ ! -f $LFS/lib/libXi.so.6 ];					then FAIL=libXi,$FAIL;						fi
if [ ! -f $LFS/lib/libXrender.so.1 ];				then FAIL=libXrender,$FAIL;					fi
if [ ! -f $LFS/lib/libXt.so.6 ];					then FAIL=libXt,$FAIL;						fi
if [ ! -f $LFS/lib/libXtst.so.6 ];					then FAIL=libXtst,$FAIL;					fi
if [ ! -f $LFS/lib/libasound.so.2 ];				then FAIL=libasound,$FAIL;					fi
if [ ! -f $LFS/lib/libatk-1.0.so.0 ];				then FAIL=libatk-1.0,$FAIL;					fi
if [ ! -f $LFS/lib/libcairo.so.2 ];					then FAIL=libcairo,$FAIL;					fi
if [ ! -f $LFS/lib/libcairo-gobject.so.2 ];			then FAIL=libcairo-gobject,$FAIL;			fi
if [ ! -f $LFS/lib/libcairo-script-interpreter.so.2 ];then FAIL=libcairo-script-interprete,$FAIL;fi
if [ ! -f $LFS/lib/libfontconfig.so.1 ];			then FAIL=libfontconfig,$FAIL;				fi
if [ ! -f $LFS/lib/libfreetype.so.6 ];				then FAIL=libfreetype,$FAIL;				fi
if [ ! -f $LFS/lib/libgdk-x11-2.0.so.0 ];			then FAIL=libgdk-x11-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libgdk_pixbuf-2.0.so.0 ];		then FAIL=libgdk_pixbuf-2.0,$FAIL;			fi
if [ ! -f $LFS/lib/libgdk_pixbuf_xlib-2.0.so.0 ];	then FAIL=libgdk_pixbuf_xlib-2.0,$FAIL;		fi
if [ ! -f $LFS/lib/libgio-2.0.so.0 ];				then FAIL=libgio-2.0,$FAIL;					fi
if [ ! -f $LFS/lib/libglib-2.0.so.0 ];				then FAIL=libglib-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libgmodule-2.0.so.0 ];			then FAIL=libgmodule-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libgobject-2.0.so.0 ];			then FAIL=libgobject-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libgthread-2.0.so.0 ];			then FAIL=libgthread-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libgtk-x11-2.0.so.0 ];			then FAIL=libgtk-x11-2.0,$FAIL;				fi
if [ ! -f $LFS/lib/libjpeg.so.62 ];					then FAIL=libjpeg,$FAIL;					fi
if [ ! -f $LFS/lib/libpango-1.0.so.0 ];				then FAIL=libpango-1.0,$FAIL;				fi
if [ ! -f $LFS/lib/libpangocairo-1.0.so.0 ];		then FAIL=libpangocairo-1.0,$FAIL;			fi
if [ ! -f $LFS/lib/libpangoft2-1.0.so.0 ];			then FAIL=libpangoft2-1.0,$FAIL;			fi
if [ ! -f $LFS/lib/libpangoxft-1.0.so.0 ];			then FAIL=libpangoxft-1.0,$FAIL;			fi
if [ ! -f $LFS/lib/libpng12.so.0 ];					then FAIL=libpng12,$FAIL;					fi
if [ ! -f $LFS/lib/libtiff.so.5 ];					then FAIL=libtiff,$FAIL;					fi
if [ ! -f $LFS/lib/libxcb.so.1 ];					then FAIL=libxcb,$FAIL;						fi #

if [[ ! $FAIL ]]; then
	echo ""
	echo "LSB Desktop = Pass"
else
	echo ""
	echo "LSB Desktop = Failed"
	echo "	Failed = "$FAIL
	EXIT_CODE=$((EXIT_CODE+1))
fi

FAIL=""

# Table 2-4 LSB Imaging Module Library Names
if [ ! -f $LFS/lib/libcups.so.2 ];			then FAIL=libcups,$FAIL;		fi
if [ ! -f $LFS/lib/libcupsimage.so.2 ];		then FAIL=libcupsimage,$FAIL;	fi
if [ ! -f $LFS/lib/libsane.so.1 ];			then FAIL=libsane,$FAIL;		fi

if [[ ! $FAIL ]]; then
	echo ""
	echo "LSB Imaging = Pass"
else
	echo ""
	echo "LSB Imaging = Failed"
	echo "	Failed = "$FAIL
	EXIT_CODE=$((EXIT_CODE+1))
fi

FAIL=""

# Table 2-5 LSB Languages Module Library Names
if [ ! -f $LFS/lib/libxml2.so.2 ];			then FAIL=libxml2,$FAIL;		fi
if [ ! -f $LFS/lib/libxslt.so.1 ];			then FAIL=libxslt,$FAIL;		fi

if [[ ! $FAIL ]]; then
	echo ""
	echo "LSB Languages = Pass"
else
	echo ""
	echo "LSB Languages = Failed"
	echo "	Failed = "$FAIL
	echo ""
	EXIT_CODE=$(($EXIT_CODE+1))
fi

exit $EXIT_CODE
