#!/bin/bash
# Create pv and pvc 
read -p 'pvname: ' PVNAME
read -p 'pvsize: ' PVSIZE
read -p 'pvuser: ' PVUSER
read -p 'path: ' PATH


cat >>./pv-pvc.yaml<<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${PVNAME}
  annotations:
    pv.beta.kubernetes.io/gid: "${PVUSER}" 
spec:
  capacity:
    storage: "${PVSIZE}Gi"
  accessModes: 
    - ReadWriteMany
  glusterfs:
    endpoints: glusterfs-cluster 
    path: ${PATH}
    readOnly: false
  persistentVolumeReclaimPolicy: Retain

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${PVNAME}-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
     requests:
       storage: "${PVSIZE}Gi"
  volumeName: "${PVNAME}"
EOF
oc create -f pv-pvc.yaml
rm -rf pv-pvc.yaml
oc get pvc 
