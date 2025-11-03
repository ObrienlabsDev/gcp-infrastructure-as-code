#
#

kubectl delete -f managed-certificate.yaml
# remove reserve static IP
# remove NS A record (domain to IP)
# wait for propagation
kubectl delete -f ingress.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml