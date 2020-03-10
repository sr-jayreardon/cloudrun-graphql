set -e

env=$1
host=$2

configFileName="$env-openapi-functions.yaml"
tempFileName="temp-openapi-functions.yaml"
finalFileName="openapi-functions.yaml"

sed "s/thisHostWillGetOverWritten/$host/g" ./config/$configFileName | tee ./config/$tempFileName
rm ./src/$finalFileName
cp ./config/$tempFileName ./src/$finalFileName
rm ./config/$tempFileName
