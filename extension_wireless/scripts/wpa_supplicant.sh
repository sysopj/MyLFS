# wpa_supplicant

cat > /sbin/wpa-connect << "EOF"
#!/bin/bash

TEST=false
#TEST=true

# Dependency check
[[ $(command -v iw) == "" ]] && echo "Dependancy 'iw' is not found" && exit -1

# WLAN NIC Selection
if $TEST; then
	IFACE_LIST=("wlan0" "wlan1" "wlan2")
else
	IFACE_LIST=($(iw dev | grep 'Interface' | cut -d' ' -f2))
	# 4: wlp0s12u1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
		# link/ether 0c:0e:76:70:17:e3 brd ff:ff:ff:ff:ff:ff
		# altname wlx0c0e767017e3
fi
IFACE_LIST_COUNT=${#IFACE_LIST[@]}

[[ $IFACE_LIST_COUNT -eq 0 ]] && echo -e "\nNo Wireless Adapters found.\nTry installing the latest"\
								"linux_firmware and rebuild the linux kernel.\n" && exit -1
[[ $IFACE_LIST_COUNT -eq 1 ]] && WLAN=${IFACE_LIST[0]}
function LIST_INTERFACES {
	echo -e "\nPlease select and adapter by number:"
	for i in "${!IFACE_LIST[@]}"; do
		echo "$((i+1)). ${IFACE_LIST[$i]}"
	done
	read -p "iface number: " INTERFACE
	export INTERFACE
}

if [[ $IFACE_LIST_COUNT -gt 1 ]]; then
	while true; do
		LIST_INTERFACES

		# Check if the input is a valid integer and within the range
		if [[ "$INTERFACE" =~ ^[1-$IFACE_LIST_COUNT]$ ]]; then
			#echo "You entered a valid number: $input_number"
			break # Exit the loop if input is valid
		else
			echo "Invalid input."
		fi
	done

	# Numbers start at 0 not 1
	INTERFACE=$(($INTERFACE - 1))
	WLAN=${IFACE_LIST[$INTERFACE]}
fi

[[ ! $TEST ]] && ip link set $WLAN up

# SSID Selection
# Initial array with potential duplicates
if $TEST; then
	my_array=("SSID:" "SkyNetHome" "SSID:" "SkyNetHome" "SSID:" "Rakuten-Casa-6280E" "SSID:" "SkyNetHome")
else
	my_array=($(iw dev $WLAN scan | grep SSID:))
fi
#echo "Original array:"
#printf "%s\n" "${my_array[@]}"

# Remove duplicates using sort -u and store in a new array
# The printf "%s\n" "${my_array[@]}" outputs each element on a new line,
# sort -u then filters out duplicates, and mapfile reads the output back into an array.
mapfile -t unique_array < <(printf "%s\n" "${my_array[@]}" | sort -u)

# Define the string to remove
string_to_remove="SSID:"

# Initialize an empty array to store the filtered elements
filtered_array=()

# Iterate through the original array
for element in "${unique_array[@]}"; do
  # Check if the current element does NOT match the string to remove
  if [[ "$element" != "$string_to_remove" ]]; then
    # If it doesn't match, add it to the filtered array
    filtered_array+=("$element")
  fi
done

echo -e "\nSelect Your SSID:"
# List the unique elements with numbers for selection
while true; do
	for i in "${!filtered_array[@]}"; do
		echo "$((i+1)). ${filtered_array[$i]}"
	done
	
	# Prompt user for selection
	read -p "SSID number: " selection_number

	# Check if the input is a valid integer and within the range
	if [[ "$selection_number" =~ ^[0-9]+$ ]] && (( selection_number > 0 && selection_number <= ${#filtered_array[@]} )); then
		#echo "You entered a valid number: $input_number"
		break # Exit the loop if input is valid
	else
		echo -e "\nInvalid input."
	fi
done
SSID="${unique_array[$((selection_number-1))]}"

# Get Passphrase
echo " "
read -p "WIFI Passphrase: " WPA_PASSPHRASE

# Connect
mkdir -p /etc/wpa_supplicant
if $TEST; then
	wpa_passphrase $SSID $WPA_PASSPHRASE
else
	wpa_passphrase $SSID $WPA_PASSPHRASE | tee -a /etc/wpa_supplicant/wpa_supplicant-$WLAN.conf
	ip link set $WLAN up
	systemctl enable wpa_supplicant@$WLAN
	systemctl start wpa_supplicant@$WLAN
	systemctl enable dhcpcd@$WLAN
	systemctl start dhcpcd@$WLAN
fi

EOF
chmod +x /sbin/wpa-connect

cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF

# cat >> wpa_supplicant/.config << "EOF"
# CONFIG_CTRL_IFACE_DBUS=y
# CONFIG_CTRL_IFACE_DBUS_NEW=y
# CONFIG_CTRL_IFACE_DBUS_INTRO=y
# EOF

cd wpa_supplicant
make BINDIR=/usr/sbin LIBDIR=/usr/lib

install -v -m755 wpa_{cli,passphrase,supplicant} /usr/sbin/
install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/

install -v -m644 systemd/*.service /usr/lib/systemd/system/

# install -v -m644 dbus/fi.w1.wpa_supplicant1.service \
                 # /usr/share/dbus-1/system-services/
# install -v -d -m755 /etc/dbus-1/system.d
# install -v -m644 dbus/dbus-wpa_supplicant.conf \
                 # /etc/dbus-1/system.d/wpa_supplicant.conf
