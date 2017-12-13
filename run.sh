#!/bin/bash -e

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"

if [ ! -f "$DSS_DATADIR"/bin/env-default.sh ]; then
	echo "Changing the owner of $DSS_DATADIR"
	chown dataiku:dataiku "$DSS_DATADIR"
	# Initialize new data directory
	su dataiku -c "$DSS_INSTALLDIR/installer.sh -d $DSS_DATADIR -p $DSS_PORT"
	su dataiku -c "$DSS_DATADIR/bin/dssadmin install-R-integration"
	echo "Reached here.."
	su dataiku -c 'echo "dku.registration.channel=docker-image" >>"$DSS_DATADIR"/config/dip.properties'

elif [ $(bash -c 'source "$DSS_DATADIR"/bin/env-default.sh && echo "$DKUINSTALLDIR"') != "$DSS_INSTALLDIR" ]; then
	# Upgrade existing data directory
	"$DSS_INSTALLDIR"/installer.sh -d "$DSS_DATADIR" -u -y
	"$DSS_DATADIR"/bin/dssadmin install-R-integration

fi

mkdir -p /home/dataiku/dss/lib/jdbc
curl 'https://storage.googleapis.com/simba-bq-release/jdbc/SimbaJDBCDriverforGoogleBigQuery42_1.1.4.1004.zip' -o /home/dataiku/dss/lib/jdbc/driver.zip
cd /home/dataiku/dss/lib/jdbc && unzip -o driver.zip 
curl 'https://storage.googleapis.com/jdbc-drivers/sqljdbc42.jar' -o /home/dataiku/dss/lib/jdbc/sqljdbc42.jar

chown dataiku:dataiku /home/dataiku/dss/lib/jdbc

su dataiku -c 'exec "$DSS_DATADIR"/bin/dss run'
