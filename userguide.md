Gimbal Controller Guide

Step 1 - Testing Variables:
'''export DNS_NAME=thecloudymind.com \
export S3_BUCKET=cloudymind-k8s-config \
export KOPS_STATE_STORE=s3://${S3_BUCKET} \
export ZONES="us-west-2a" 
'''
              OR
'''
export DNS_NAME=thebrianhammons.com \
export S3_BUCKET=brianhammons-k8s-config \
export KOPS_STATE_STORE=s3://${S3_BUCKET} \
export ZONES="us-west-2c"
'''

Global Settings
'''
export MASTER_COUNT=1 \
export NODE_COUNT=1 \
export NODE_SIZE=${NODE_SIZE:-t2.micro} \
export MASTER_SIZE=${MASTER_SIZE:-t2.micro} \
export IMAGE=ami-db710fa3
'''

Step 2 - Setup Clusters:
'''
kops create cluster \
  --name $DNS_NAME \
  --master-count $MASTER_COUNT \
  --node-count $NODE_COUNT \
  --master-size $MASTER_SIZE \
  --node-size $NODE_SIZE \
  --cloud aws \
  --zones $ZONES \
  --cloud-labels $DNS_NAME=owned \
  --yes
'''
Step 3 - Install Gimbal Components:
'''
git clone https://github.com/heptio/gimbal.git
cd deployments
kubectl create -f contour/
kubectl create -f gimbal-discoverer/01-common.yaml
kubectl -n gimbal-discovery create secret generic remote-discover-kubecfg --from-file=config=$HOME/.kube/config --from-literal=backend-name=thecloudymind.com
kubectl apply -f gimbal-discoverer/02-kubernetes-discoverer.yaml
kubectl apply -f prometheus
git clone https://github.com/kubernetes/kube-state-metrics.git
cd kube-state-metrics
kubectl apply -f kubernetes/
cd ..
kubectl apply -f grafana/
kubectl create secret generic grafana -n gimbal-monitoring --from-literal=grafana-admin-password=admin --from-literal=grafana-admin-user=admin 
cd ..
kubectl apply -f example-workload/deployment.yaml
'''
Cleanup:

'''kops delete cluster --name $DNS_NAME --yes