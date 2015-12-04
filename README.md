# external-srb-release
This repo is for creating a bosh release around the external service registry broker application and also for generating its associated Tile.

The bosh release would push the SRB application to CF using deploy-broker bosh errand and register the app as a service broker using register-broker errand. 
destroy-broker errand would deregister the service broker, clean up the services and remove the application.

Steps to creating the release and tile:

1) Use fetch_cf_cli.sh to download and bundle the cf binary.
2) Use addBlob.sh to add the service broker jar file (its under https://github.com/cf-platform-eng/service-registry-broker.git) to srb_broker blob package.
3) Run ./createRelease.sh to generate the bosh release.
4) Run ./createTile.sh to generate the tile.

For more details on the service registry broker, check https://github.com/cf-platform-eng/service-registry-broker/README.md
