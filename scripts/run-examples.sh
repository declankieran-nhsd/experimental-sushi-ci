#!/bin/bash

# TODO Document how to organise the examples and queries in the IG
# Probably makes more sense just to describe the queries and add output in statically, rather trying to combine integrations testing
# into the build of the IG.  See if it serves as a useful example... 

# TODO - Make the script runnable from any path, currently needs to be ran from root of repo
SCRIPT_ROOT=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P );

# Use SUSHI to generate resources from fsh
sushi .

SERVER_BASE="http://localhost:8080/fhir/"
HEADERS="Content-type:application/fhir+json;fhirVersion=4.0"

# SearchParameters need to be loaded first, otherwise its likely they'll not have been indexed by the HAPI server
SEARCHPARAMETERS_DIR=fsh-generated/resources/SearchParameter*

for file in $SEARCHPARAMETERS_DIR; do
  curl -X POST -H $HEADERS -d @$file $SERVER_BASE/SearchParameter;
done

# TODO Parameterise this to make it general for sushi and standalone hl7 publisher, few other things would need tweaked as well...
FSH_EXAMPLES_DIR=input/fsh/examples
FSH_GENERATED_DIR=fsh-generated/resources
QUERIES_DIR=input/ci/queries

# Make resources folder if it doesn't already exist
mkdir -p ./input/resources

for file in $(find {$FSH_EXAMPLES_DIR,$QUERIES_DIR} -type f | sort -t\/ -k4); do 
  case $(dirname $file) in

    $FSH_EXAMPLES_DIR)
      # Get the example ID from the filename
      EXAMPLE_ID=$(basename ${file%.*} | awk -F '-' '{print $2}');

      # Construct path to generated JSON resource - TODO this implies the id will be unique and not a subset of another...
      GENERATED=$(echo ./$FSH_GENERATED_DIR/*$EXAMPLE_ID*);
      echo "---------------------";
      echo $GENERATED;
      echo "---------------------";
      
      # Sushi will prepend the name of the Resource, which will be used in the server calls.
      RESOURCE_NAME=$(echo $GENERATED | awk -F '/' '{print $4}' | awk -F '-' '{print $1}');

      # Assumption here that Bundle examples will be transactions, guessing it'll fail if not...
      # Set RESOURCE_NAME to empty string so post is made to the base server url.
      if [ "$RESOURCE_NAME" == "Bundle" ]; then
        RESOURCE_NAME=""
      fi;

      curl -X POST -H $HEADERS -d @$GENERATED $SERVER_BASE$RESOURCE_NAME;
      ;;

    $QUERIES_DIR)
      # Get HTTP verb and Query path
      QUERY=$(cat $file);

      # Tokinise the query string, ReST verb and path separated by space
      QUERY_TOKENS=(${QUERY// / })

      # Strip the path and the extension
      QUERY_FILE=$(basename $file | awk -F '.' '{print $1}');

      # Run the query and output the result
      curl -X ${QUERY_TOKENS[0]} $SERVER_BASE${QUERY_TOKENS[1]}  | jq '.id = "QUERY-OUTPUT--'$QUERY_FILE'"' > ./input/resources/QUERY-OUTPUT--$QUERY_FILE.json
      ;;

    *)
      echo "Unknown directory: $(dirname $file)"
      exit 1
      ;;
  esac
done
