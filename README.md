# Standard Dataiku DSS Dockerfile

This directory contains the Dockerfile which is used by Dataiku to build the standard docker images for DSS.

To rebuild :

- check/edit DSS_VERSION in Dockerfile
- run: docker build .


 docker run --name dataiku -p 10000:10000 -d gcr.io/xyz123/dataiku:4.1.0
