#!/bin/sh
# ebal, Sat, 21 Apr 2018 09:53:41 +0300

# Create a temporarily root hint file
/bin/dig . NS @75.127.96.89 | grep -v '^;' | sort -u -V > /tmp/root.hint

# Count lines
LINES=` /bin/grep -c ^ /tmp/root.hint `

# Calculate the CRC checksum of the temp file
TMP_HASH=`/bin/cksum /tmp/root.hint | awk '{print $1}' `

# Calculate the CRC checksum of the root hint file
HINT_HASH=`/bin/cksum /etc/pdns-recursor/root.hint | awk '{print $1}' `

# If temp file is larger than 20 lines && has a different checksum value , then replace root.hint with the new file.
if [ ${LINES} > 20 -a "${TMP_HASH}" != "${HINT_HASH}" ]; then
	echo "New root hint found !"
	/bin/mv -f /tmp/root.hint /etc/pdns-recursor/root.hint
	/bin/rec_control reload-zones --timeout=10
fi
