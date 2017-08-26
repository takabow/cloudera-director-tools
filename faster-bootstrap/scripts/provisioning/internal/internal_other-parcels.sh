#!/bin/sh

sudo yum -y install jq
sudo yum -y install wget 


KUDU_PARCEL_URL="http://archive.cloudera.com/kudu/parcels/5.12/KUDU-1.4.0-1.cdh5.12.0.p0.25-el7.parcel"
SPARK2_PARCEL_URL="http://archive.cloudera.com/spark2/parcels/2.2/SPARK2-2.2.0.cloudera1-1.cdh5.12.0.p0.142354-el7.parcel"
SPARK2_CSD_URL="http://archive.cloudera.com/spark2/csd/SPARK2_ON_YARN-2.2.0.cloudera1.jar"
KAFKA_PARCEL_URL="http://archive.cloudera.com/kafka/parcels/2.2/KAFKA-2.2.0-1.2.2.0.p0.68-el7.parcel"
ANACONDA_PARCEL_URL="https://repo.continuum.io/pkgs/misc/parcels/Anaconda-4.2.0-el7.parcel"

CLOUDERA_PARCEL_URLS=(
    ${KUDU_PARCEL_URL}
    ${SPARK2_PARCEL_URL}
    ${KAFKA_PARCEL_URL}
)

sudo useradd -r cloudera-scm
sudo mkdir -p /opt/cloudera/parcels /opt/cloudera/parcel-repo /opt/cloudera/parcel-cache /opt/cloudera/csd

for PARCEL_URL in ${CLOUDERA_PARCEL_URLS[@]} ; do
    PARCEL_NAME="${PARCEL_URL##*/}"
    PARCEL_BASE_NAME="${PARCEL_NAME%%-*}"


    echo $PARCEL_URL       # e.g.) http://archive.cloudera.com/kudu/parcels/5.12/KUDU-1.4.0-1.cdh5.12.0.p0.25-el7.parcel
    echo $PARCEL_NAME      # e.g.) KUDU-1.4.0-1.cdh5.12.0.p0.25-el7.parcel
    echo $PARCEL_BASE_NAME # e.g.) KUDU

    echo "Downloading parcel from $PARCEL_URL"
    sudo curl -s -S "${PARCEL_URL}" -o "/opt/cloudera/parcel-repo/${PARCEL_NAME}"
    sudo curl -s -S "${PARCEL_URL}.sha1" -o "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1"
    sudo cp "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha"
    
    echo "Verifying parcel checksum"
    sudo sed "s/$/  ${PARCEL_NAME}/" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1" |
      sudo tee "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck" > /dev/null
    if ! eval "cd /opt/cloudera/parcel-repo && sha1sum -c \"${PARCEL_NAME}.shacheck\""; then
      echo "Checksum verification failed"
      #exit 1
    fi
    sudo rm "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck"
    sudo ln "/opt/cloudera/parcel-repo/${PARCEL_NAME}" "/opt/cloudera/parcel-cache/${PARCEL_NAME}"

    sudo chown -R cloudera-scm:cloudera-scm /opt/cloudera

    echo "Preextracting parcels..."
    sudo tar zxf "/opt/cloudera/parcel-repo/${PARCEL_NAME}" -C "/opt/cloudera/parcels"
    sudo ln -s "/opt/cloudera/parcels/${PARCEL_NAME%-*}" "/opt/cloudera/parcels/${PARCEL_BASE_NAME}"
    sudo touch "/opt/cloudera/parcels/${PARCEL_BASE_NAME}/.dont_delete"
    echo "Done"
done

### Spark 2 CSD
sudo wget -q -P "/opt/cloudera/csd" "${SPARK2_CSD_URL}" 


### Anaconda
PARCEL_URL=$ANACONDA_PARCEL_URL
PARCEL_NAME="${PARCEL_URL##*/}"
PARCEL_BASE_NAME="${PARCEL_NAME%%-*}"

echo $PARCEL_URL       #http://archive.cloudera.com/kudu/parcels/5.12/KUDU-1.4.0-1.cdh5.12.0.p0.25-el7.parcel
echo $PARCEL_NAME      #KUDU-1.4.0-1.cdh5.12.0.p0.25-el7.parcel
echo $PARCEL_BASE_NAME #KUDU

echo "Downloading parcel from $PARCEL_URL"
sudo curl -s -S "${PARCEL_URL}" -o "/opt/cloudera/parcel-repo/${PARCEL_NAME}"
sudo curl -s -S "${PARCEL_URL}.sha" -o "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1"
sudo cp "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha"

echo "Verifying parcel checksum"
sudo sed "s/$/  ${PARCEL_NAME}/" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha" |
  sudo tee "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck" > /dev/null
if ! eval "cd /opt/cloudera/parcel-repo && sha1sum -c \"${PARCEL_NAME}.shacheck\""; then
  echo "Checksum verification failed"
  #exit 1
fi
sudo rm "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck"
sudo ln "/opt/cloudera/parcel-repo/${PARCEL_NAME}" "/opt/cloudera/parcel-cache/${PARCEL_NAME}"
sudo chown -R cloudera-scm:cloudera-scm /opt/cloudera
echo "Preextracting parcels..."
sudo tar zxf "/opt/cloudera/parcel-repo/${PARCEL_NAME}" -C "/opt/cloudera/parcels"
sudo ln -s "/opt/cloudera/parcels/${PARCEL_NAME%-*}" "/opt/cloudera/parcels/${PARCEL_BASE_NAME}"
sudo touch "/opt/cloudera/parcels/${PARCEL_BASE_NAME}/.dont_delete"
echo "Done"
###########


### CondaR
PARCEL_URL="https://bintray.com/chezou/Parcels/download_file?file_path=CONDAR-3.4.1.p0.1.2-el7.parcel"
PARCEL_MANIFEST_URL="https://bintray.com/chezou/Parcels/download_file?file_path=manifest.json"
PARCEL_NAME="CONDAR-3.4.1.p0.1.2-el7.parcel"
PARCEL_BASE_NAME="CONDAR"

echo "Downloading parcel from $PARCEL_URL"
sudo wget -q -O "/opt/cloudera/parcel-repo/${PARCEL_NAME}" "${PARCEL_URL}" 
sudo wget -q -O "/tmp/condar-manifest.json" "${PARCEL_MANIFEST_URL}" 
sudo cat /tmp/condar-manifest.json | jq '.parcels[]' | jq 'select(.parcelName == "CONDAR-3.4.1.p0.1.2-el7.parcel")' | jq -r '.hash' | 
  sudo tee "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1" > /dev/null
sudo cp "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha1" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha"

echo "Verifying parcel checksum"
sudo sed "s/$/  ${PARCEL_NAME}/" "/opt/cloudera/parcel-repo/${PARCEL_NAME}.sha" |
  sudo tee "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck" > /dev/null
if ! eval "cd /opt/cloudera/parcel-repo && sha1sum -c \"${PARCEL_NAME}.shacheck\""; then
  echo "Checksum verification failed"
  #exit 1
fi
sudo rm "/opt/cloudera/parcel-repo/${PARCEL_NAME}.shacheck"
sudo ln "/opt/cloudera/parcel-repo/${PARCEL_NAME}" "/opt/cloudera/parcel-cache/${PARCEL_NAME}"
sudo chown -R cloudera-scm:cloudera-scm /opt/cloudera
echo "Preextracting parcels..."
sudo tar zxf "/opt/cloudera/parcel-repo/${PARCEL_NAME}" -C "/opt/cloudera/parcels"
sudo ln -s "/opt/cloudera/parcels/${PARCEL_NAME%-*}" "/opt/cloudera/parcels/${PARCEL_BASE_NAME}"
sudo touch "/opt/cloudera/parcels/${PARCEL_BASE_NAME}/.dont_delete"
echo "Done"
###########



echo "Sync Linux volumes with EBS."
sudo sync
sleep 5
