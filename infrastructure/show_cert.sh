#! /bin/bash

vote_service_token=`kubectl get secrets | grep vote-service | awk -F " " '{{print $1}}'`

echo "Namespace:"

kubectl get secrets ${vote_service_token} -o template={{.data.namespace}} | base64 --decode

echo ""
echo "Token:"

kubectl get secrets ${vote_service_token} -o template={{.data.token}} | base64 --decode


echo ""
echo "Cert:"
kubectl get secrets vote-service-token-txw9z -o "jsonpath={.data['ca\.crt']}" | base64 --decode

