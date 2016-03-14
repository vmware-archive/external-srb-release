#!/bin/sh

TILE_VERSION=0.1
TILE_NAME=Service-Registry-Broker-Experimental
TILE_FILE=`pwd`/*tile-v${TILE_VERSION}.yml
RELEASE_TARFILE=`pwd`/releases/*/*.tgz

#BOSH_STEMCELL_FILE=`cat ${TILE_FILE} | grep "bosh-stemcell" | grep "^ *file:" | awk '{print $2}' `
#BOSH_STEMCELL_LOCATION=https://s3.amazonaws.com/bosh-jenkins-artifacts/bosh-stemcell/vsphere

rm -rf tmp
mkdir -p tmp
pushd tmp
#Dont bundle the stemcell into the .pivotal Tile file as the stemcell must already be available in the Ops Mgr.
mkdir -p metadata releases 
cp $TILE_FILE metadata
cp $RELEASE_TARFILE releases
cp -r ../content_migrations .

# Ignore bundling the stemcell as most often the Ops Mgr carries the stemcell.
# If Ops Mgr complains of missing stemcell, change the version specified inside the tile to the one that Ops mgr knows about

zip -r ${TILE_NAME}-${TILE_VERSION}.pivotal metadata releases content_migrations
#zip -r ${TILE_NAME}-${TILE_VERSION}.pivotal metadata releases 
mv ${TILE_NAME}-${TILE_VERSION}.pivotal ..
popd
