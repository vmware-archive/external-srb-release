# Service Registry Broker
A quick and easy way to expose pre-built, custom, existing or legacy services on the Cloud Foundry Marketplace without wrapping each service with its own service broker.
This repo is for creating a bosh release around the external Service Registry Broker application and also for generating its associated Tile.

# Overview

Most applications don't run in a vacuum or isolated mode. They are dependent on other applications and services running on the same or different platforms. Applications running on Cloud Foundry use the service bindings to associate service metadata with the consumer application in form of environment variables to relay information about the service, its endpoint, credentials or any other information relevant to invoke or consume a service. 
Application developers can either use Cloud Foundry’s user provided services to bind a service metadata to an application (and repeat this for each space the service needs to be made available) or build a service broker that would expose the same information in Cloud Foundry Marketplace and let the user bind the consuming application to the service. 
The service broker approach to encapsulate the service metadata becomes a bit too tedious when there are large number of services, with each service requiring a service broker interface to be exposed in the Marketplace.

The Spring Cloud Service Registry is meant for microservices built using Spring Cloud connectors that use Netflix OSS Eureka service registry to control and manage client side load balancing calls to other associated services and does not solve the problem of exposing existing services via a service broker interface to any consuming application.
Lets look into an external Service Registry with Broker interface that can help Cloud Foundry customers address this specific problem.

# Service Registry Broker
Service Registry Broker is a prototype Cloud Foundry Service Broker exposing external service registry functionality to applications running on Cloud Foundry.

The Service Registry acts as a central repository to publish and consume information about pre-existing services like legacy SOAP Services or other user managed services like Databases, Custom Integration layers, etc. It does not manage, provision or monitor the services, only acts as a placeholder of information about services.

The registry exposes the registered services to Cloud Foundry via the Service Broker interface. A Cloud Foundry application bound to the underlying service would be able to consume information about the underlying service (like endpoint and any credentials information) in the form of a `VCAP_SERVICES` environment variable when pushed to CF. The client/consumer app needs to parse the VCAP_SERVICES env variable and use the appropriate spring cloud connectors or other methods to use the endpoint configuration and invoke the related service.

The Service Registry Broker would automatically update its catalog and change the service access against the Cloud Controller whenever a user adds or updates existing services or marks a service as public or private.
* Design Model

&nbsp;&nbsp;&nbsp;&nbsp; <img src="./docs/SRB-Model.png" alt="Service Registry Broker" width="500" height="280" border="3" />


* Using the Service Registry Broker

&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://github.com/cf-platform-eng/external-srb-release/blob/master/docs/SRB.mp4?raw=true" target="_blank"><img src="./docs/SRB-Video.png" 
alt="Service Registry Broker" width="500" height="280" border="3" /></a>

For more details on building or using the Service Registry Broker, please refer to the [documentation] (docs/ServiceRegistryBroker.pdf) and [Service Registry Broker Repo](https://github.com/cf-platform-eng/service-registry-broker.git)


# SRB Release

The bosh release would push the SRB application to CF using deploy-broker bosh errand and register the app as a service broker using register-broker errand. 
destroy-broker errand would deregister the service broker, clean up the services and remove the application.

Steps to creating the release and tile:

* Use fetch_cf_cli.sh to download and bundle the cf binary.
* Use addBlob.sh to add the service broker jar file (its under https://github.com/cf-platform-eng/service-registry-broker.git) to srb_broker blob package.
* Run ./createRelease.sh to generate the bosh release.
* Run ./createTile.sh to generate the tile.

