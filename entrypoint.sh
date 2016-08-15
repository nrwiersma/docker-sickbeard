#!/bin/sh

#
# Display settings on standard out.
#

USER="sickbeard"

echo "SickBeard settings"
echo "=================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${SICKBEARD_UID:=666}"
echo "  GID:        ${SICKBEARD_GID:=666}"
echo
echo "  Config:     ${CONFIG:=/datadir/config.ini}"
echo

#
# Change UID / GID of SickBeard user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${SICKBEARD_UID} ]] || usermod  -o -u ${SICKBEARD_UID} ${USER}
[[ $(id -g ${USER}) == ${SICKBEARD_GID} ]] || groupmod -o -g ${SICKBEARD_GID} ${USER}
echo "[DONE]"

#
# Clone sickbeard to get the latest version
#

printf "Installing SickBeard... "
git clone -q git://github.com/midgetspy/Sick-Beard.git .
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions... "
touch ${CONFIG}
chown -R ${USER}: /sickbeard
chown ${USER}: /datadir /download /media $(dirname ${CONFIG}) ${CONFIG}
echo "[DONE]"

#
# Finally, start SickBeard.
#

echo "Starting SickBeard..."
exec su -pc "./SickBeard.py --nolaunch --datadir=$(dirname ${CONFIG}) --config=${CONFIG}" ${USER}
