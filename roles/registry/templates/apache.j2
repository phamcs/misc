#!/bin/bash
apache="docker.io/apache"
superasian="registry.superasian.net/apache"
apps=("activemq-artemis" "kafka" "hertzbeat" "amoro" "sedona" "apisix" "seatunnel" "hop" "iotdb" "devlake" "devlake-config-ui" "devlake-dashboard" "sling" "answer" "bookkeeper" "drill" "couchdb" "iggy" "ozone"
      "nutch" "apisix-ingress-controller" "flink-kubernetes-operator" "streampark" "spark" "tika" "eventmesh" )
tag=latest
    for app in ${apps[@]}; do
        docker pull $apache/$app:$tag
        docker tag $apache/$app:$tag $superasian/$app:$tag
        docker push $superasian/$app:$tag
        docker rmi $apache/$app:$tag
    done
exit 0;
