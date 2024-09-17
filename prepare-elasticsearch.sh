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

ELASTICSEARCH_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION-windows-x86_64.zip"
ES_FOLDER="elasticsearch-$ELASTICSEARCH_VERSION"
ZIP="$ES_FOLDER.zip"

# Delete made zip if exists
rm -rf $ES_FOLDER*

# Download the elasticsearch if zip file does not exist
if [ ! -f "$PWD/$ZIP" ]; then
  echo "Downloading elasticsearch $ELASTICSEARCH_URL"
  curl -L -o $ZIP $ELASTICSEARCH_URL
fi

# Unzip the elasticsearch using unzip docker image
unzip $ZIP -x "**/jdk/*"

# Remove modules
##echo "Remove jdk"
##rm -rf $ES_FOLDER/jdk

echo "Removing modules"
rm -rf $ES_FOLDER/modules/repository-azure
rm -rf $ES_FOLDER/modules/repository-s3
rm -rf $ES_FOLDER/modules/repository-gcs

# seems to be needed at startup
#rm -rf $ES_FOLDER/modules/ingest-attachment
#rm -rf $ES_FOLDER/modules/ingest-geoip
#rm -rf $ES_FOLDER/modules/ingest-user-agent
#rm -rf $ES_FOLDER/modules/ingest-common

# needed for spatial
#rm -rf $ES_FOLDER/modules/legacy-geo

# needed for vector-tile
#rm -rf $ES_FOLDER/modules/spatial

rm -rf $ES_FOLDER/modules/x-pack-ml

# seems to be needed at startup
#rm -rf $ES_FOLDER/modules/x-pack-inference
# rm -rf $ES_FOLDER/modules/x-pack-text-structure
rm -rf $ES_FOLDER/modules/x-pack-esql
rm -rf $ES_FOLDER/modules/x-pack-identity-provider
rm -rf $ES_FOLDER/modules/x-pack-monitoring
rm -rf $ES_FOLDER/modules/x-pack-sql
rm -rf $ES_FOLDER/modules/blob-cache
rm -rf $ES_FOLDER/modules/searchable-snapshots
rm -rf $ES_FOLDER/modules/search-business-rules
rm -rf $ES_FOLDER/modules/ml-package-loader
rm -rf $ES_FOLDER/modules/x-pack-downsample
rm -rf $ES_FOLDER/modules/x-pack-profiling
rm -rf $ES_FOLDER/modules/x-pack-ccr

rm -rf $ES_FOLDER/modules/x-pack-inference
rm -rf $ES_FOLDER/modules/x-pack-logstash
rm -rf $ES_FOLDER/modules/x-pack-ent-search
rm -rf $ES_FOLDER/modules/x-pack-rollup
rm -rf $ES_FOLDER/modules/x-pack-autoscaling

rm -rf $ES_FOLDER/modules/x-pack-geoip-enterprise-downloader
rm -rf $ES_FOLDER/modules/x-pack-enrich

rm -rf $ES_FOLDER/modules/x-pack-aggregate-metric
rm -rf $ES_FOLDER/modules/x-pack-analytics

rm -rf $ES_FOLDER/modules/x-pack-apm-data
rm -rf $ES_FOLDER/modules/x-pack-async
rm -rf $ES_FOLDER/modules/x-pack-async-search
rm -rf $ES_FOLDER/modules/x-pack-deprecation
rm -rf $ES_FOLDER/modules/x-pack-eql
rm -rf $ES_FOLDER/modules/x-pack-esql-core
rm -rf $ES_FOLDER/modules/x-pack-fleet
rm -rf $ES_FOLDER/modules/x-pack-graph
rm -rf $ES_FOLDER/modules/x-pack-ilm
rm -rf $ES_FOLDER/modules/x-pack-ql
rm -rf $ES_FOLDER/modules/x-pack-redact
rm -rf $ES_FOLDER/modules/x-pack-shutdown
rm -rf $ES_FOLDER/modules/x-pack-slm
rm -rf $ES_FOLDER/modules/x-pack-stack
rm -rf $ES_FOLDER/modules/x-pack-text-structure
rm -rf $ES_FOLDER/modules/x-pack-voting-only-node
rm -rf $ES_FOLDER/modules/x-pack-watcher
rm -rf $ES_FOLDER/modules/x-pack-write-load-forecaster
rm -rf $ES_FOLDER/modules/old-lucene-versions
rm -rf $ES_FOLDER/modules/snapshot-based-recoveries
rm -rf $ES_FOLDER/modules/snapshot-repo-test-kit
rm -rf $ES_FOLDER/modules/lang-mustache
rm -rf $ES_FOLDER/modules/ingest-user-agent
rm -rf $ES_FOLDER/modules/spatial
rm -rf $ES_FOLDER/modules/vector-tile
rm -rf $ES_FOLDER/modules/legacy-geo
rm -rf $ES_FOLDER/modules/ingest-geoip
rm -rf $ES_FOLDER/modules/ingest-attachment
rm -rf $ES_FOLDER/modules/repositories-metering-api
rm -rf $ES_FOLDER/modules/repository-url
rm -rf $ES_FOLDER/modules/reindex
rm -rf $ES_FOLDER/modules/data-streams
rm -rf $ES_FOLDER/modules/percolator
rm -rf $ES_FOLDER/modules/parent-join
rm -rf $ES_FOLDER/modules/frozen-indices
rm -rf $ES_FOLDER/modules/rank-eval
rm -rf $ES_FOLDER/modules/rank-rrf

# Remove lib
rm -rf $ES_FOLDER/lib/tools/windows-service-cli
rm -rf $ES_FOLDER/lib/tools/keystore-cli
rm -rf $ES_FOLDER/lib/tools/geoip-cli
rm -rf $ES_FOLDER/lib/tools/security-cli/bc*
rm -rf $ES_FOLDER/lib/tools/plugin-cli/asm*.jar
rm -rf $ES_FOLDER/lib/tools/plugin-cli/bc*.jar
rm -rf $ES_FOLDER/lib/tools/plugin-cli/elasticsearch-core*.jar
rm -rf $ES_FOLDER/lib/tools/plugin-cli/elasticsearch-plugin-api*.jar
rm -rf $ES_FOLDER/lib/tools/plugin-cli/elasticsearch-plugin-scanner*.jar
rm -rf $ES_FOLDER/lib/tools/plugin-cli/elasticsearch-x-content*.jar
rm -rf $ES_FOLDER/lib/platform

# Remove unecessary files
rm -rf $ES_FOLDER/NOTICE.txt
rm -rf $ES_FOLDER/README.asciidoc

# Remove bin
rm -rf $ES_FOLDER/bin/elasticsearch-sql-cli*
rm -rf $ES_FOLDER/bin/elasticsearch-users*
rm -rf $ES_FOLDER/bin/elasticsearch-shard*
rm -rf $ES_FOLDER/bin/elasticsearch-service*
rm -rf $ES_FOLDER/bin/elasticsearch-saml*
rm -rf $ES_FOLDER/bin/elasticsearch-reset-password*
rm -rf $ES_FOLDER/bin/elasticsearch-reconfigure-node*
rm -rf $ES_FOLDER/bin/elasticsearch-plugin*
rm -rf $ES_FOLDER/bin/elasticsearch-syskeygen*
rm -rf $ES_FOLDER/bin/elasticsearch-setup-passwords*
rm -rf $ES_FOLDER/bin/elasticsearch-node*
rm -rf $ES_FOLDER/bin/elasticsearch-geoip*
rm -rf $ES_FOLDER/bin/elasticsearch-croneval*
rm -rf $ES_FOLDER/bin/elasticsearch-create-enrollment-token*
rm -rf $ES_FOLDER/bin/elasticsearch-certgen*
rm -rf $ES_FOLDER/bin/elasticsearch-certutil*
rm -rf $ES_FOLDER/bin/elasticsearch-keystore*

#Remove config
rm -rf $ES_FOLDER/config/users
rm -rf $ES_FOLDER/config/users_roles
rm -rf $ES_FOLDER/config/elasticsearch-plugins.example.yml
rm -rf $ES_FOLDER/config/role_mapping.yml
rm -rf $ES_FOLDER/config/roles.yml
rm -rf $ES_FOLDER/config/jvm.options.d

# Replace log4j2.properties
cp log4j2.properties $ES_FOLDER/config/

# Add options to jvm.options
echo "Adding options to jvm.options"
echo "
-Xms1G
-Xmx1G
" >> $ES_FOLDER/config/jvm.options

# Comment out -Xlog:gc. Stops elasticsearch from logging garbage collection
sed -i '/-Xlog:gc/ s/^/# /' $ES_FOLDER/config/jvm.options

# Add options to elasticsearch.yml
echo "Adding options to elasticsearch.yml"
echo "

xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
xpack.security.http.ssl.enabled: false

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
