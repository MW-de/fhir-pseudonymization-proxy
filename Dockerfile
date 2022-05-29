ARG IMAGE=intersystemsdc/irishealth-community
FROM $IMAGE

USER root

RUN mkdir -p /opt/irisbuild && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/irisbuild
COPY src src
COPY module.xml module.xml
COPY iris.script iris.script

COPY example-data example-data

# Run iris once and execute iris.script 
RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
