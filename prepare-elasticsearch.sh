#!/bin/bash

# This script is used to prepare the elasticsearch and configuration

# Get the elasticsearch version from parameter or use default version
if [ -z "$1" ]; then
  echo "No elasticsearch version specified, using default version"
  exit 1
else
  echo "Using elasticsearch version $1"
  ELASTICSEARCH_VERSION=$1
fi

# Check if zip and unzip are installed
if ! [ -x "$(command -v zip)" ]; then
  echo "Error: zip is not installed." >&2
  exit 1
fi

if ! [ -x "$(command -v unzip)" ]; then
  echo "Error: unzip is not installed." >&2
  exit 1
fi

ELASTICSEARCH_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION-no-jdk-windows-x86_64.zip"
ES_FOLDER="elasticsearch-$ELASTICSEARCH_VERSION"

# Delete made zip if exists
rm -rf $ES_FOLDER*

# Download the elasticsearch if zip file does not exist
if [ ! -f "$ES_FOLDER-downloaded.zip" ]; then
  echo "Downloading elasticsearch"
  curl -L -o $ES_FOLDER-downloaded.zip $ELASTICSEARCH_URL
fi

# Unzip the elasticsearch using unzip docker image
unzip $ES_FOLDER-downloaded.zip

# Remove modules
echo "Removing modules"
rm -rf $ES_FOLDER/modules/ingest-geoip
rm -rf $ES_FOLDER/modules/ingest-user-agent
rm -rf $ES_FOLDER/modules/ingest-common

rm -rf $ES_FOLDER/modules/legacy-geo

rm -rf $ES_FOLDER/modules/spatial

mv $ES_FOLDER/modules/x-pack-core $ES_FOLDER/modules/bak-x-pack-core
rm -rf $ES_FOLDER/modules/x-pack-*
mv $ES_FOLDER/modules/bak-x-pack-core $ES_FOLDER/modules/x-pack-core

rm -rf $ES_FOLDER/modules/vectors
rm -rf $ES_FOLDER/modules/vector-tile

# Remove lib/tools
rm -rf $ES_FOLDER/lib/tools

# Remove bin/elasticsearch-sql-cli-*.jar
rm -rf $ES_FOLDER/bin/elasticsearch-sql-cli-$ELASTICSEARCH_VERSION.jar

# Replace log4j2.properties
cp log4j2.properties $ES_FOLDER/config/

# Add options to jvm.options
echo "Adding options to jvm.options"
echo "
-Xms1G
-Xmx1G
" >> $ES_FOLDER/config/jvm.options

# Add options to elasticsearch.yml
echo "Adding options to elasticsearch.yml"
echo "
cluster.routing.allocation.disk.threshold_enabled: true
cluster.routing.allocation.disk.watermark.flood_stage: 1gb
cluster.routing.allocation.disk.watermark.high: 2gb
cluster.routing.allocation.disk.watermark.low: 5gb
" >> $ES_FOLDER/config/elasticsearch.yml


# Zip the elasticsearch using zip docker image
echo "Zipping elasticsearch"
cd $ES_FOLDER
zip -r $ES_FOLDER.zip *
mv $ES_FOLDER.zip ..
cd ..


echo "Done preparing elasticsearch"
