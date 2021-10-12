#!/bin/bash

set -ex


CSI_ATTACHER_VERSION=v3.2.1
CSI_NODE_DRIVER_REGISTRAR_VERSION=v2.3.0
CSI_SNAPSHOTTER_VERSION=v3.0.3
CSI_PROVISIONER_VERSION=v2.1.2
CSI_RESIZER_VERSION=v1.2.0

GCR_URL=k8s.gcr.io/sig-storage
REGISTRAR_URL=longhornio

# get images
images=(
    csi-attacher:${CSI_ATTACHER_VERSION}
    csi-node-driver-registrar:${CSI_NODE_DRIVER_REGISTRAR_VERSION}
    csi-snapshotter:${CSI_SNAPSHOTTER_VERSION}
    csi-provisioner:${CSI_PROVISIONER_VERSION}
    csi-resizer:${CSI_RESIZER_VERSION}
    )


for imageName in ${images[@]} ; do
    docker pull $REGISTRAR_URL/$imageName
    docker tag $REGISTRAR_URL/$imageName $GCR_URL/$imageName
    docker rmi $REGISTRAR_URL/$imageName
done

# show images
docker images
