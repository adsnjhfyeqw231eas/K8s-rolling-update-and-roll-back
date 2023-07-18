# K8s-rolling-update-and-roll-back
Perform Rolling updates and roll backs, and again rolling update on a simple nginx app.

root@controller:~/k8s# kubectl apply -f deployments.yaml --record=true
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/nginxapp created

root@controller:~/k8s# kubectl get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP           NODE    NOMINATED NODE   READINESS GATES
nginxapp-6ff9dbd48-bkncq   1/1     Running   0          2m20s   10.244.1.3   node1   <none>           <none>
nginxapp-6ff9dbd48-q4nqf   1/1     Running   0          2m20s   10.244.2.2   node2   <none>           <none>
nginxapp-6ff9dbd48-t46qj   1/1     Running   0          2m20s   10.244.1.2   node1   <none>           <none>

root@controller:~/k8s# kubectl get deployments -o wide
NAME       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                  SELECTOR
nginxapp   3/3     3            3           2m27s   nginxapp     tridevg/nginx-july:v1   app=nginxapp


root@controller:~/k8s# kubectl rollout status deployments nginxapp
deployment "nginxapp" successfully rolled out


# test: access v1 of the nginxapp from webbrowser
https://stackoverflow.com/questions/48253318/how-to-access-kubernetes-nodeport-service-in-browser
export KUBECONFIG=/etc/kubernetes/admin.conf
access from cluster:
root@controller:~# curl http://node1:30000
Welcome to Nginx from Simplilearn - Kubernetes - <B>Version: v1</B>
root@controller:~# curl http://node2:30000
Welcome to Nginx from Simplilearn - Kubernetes - <B>Version: v1</B>
from webbrowser worked also!

=====================================
# Time to perform Rolling Update:

in deployments.yaml make app version from v1 to v2.
image: tridevg/nginx-july:v2

root@controller:~/k8s# kubectl rollout status deployment nginxapp 
deployment "nginxapp" successfully rolled out

verify:
root@controller:~/k8s# kubectl get deployments -o wide
NAME       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                  SELECTOR
nginxapp   3/3     3            3           31m   nginxapp     tridevg/nginx-july:v2   app=nginxapp


Test:
In browser: http://bothnodeip:port
Should be V2!


====================================
# Q. Check Rollout history of your app?
root@controller:~/k8s# kubectl rollout history deployment nginxapp
deployment.apps/nginxapp
REVISION  CHANGE-CAUSE
1         kubectl apply --filename=deployments.yaml --record=true
2         <none>

# Q. Now Undo rollout changes? or Rollback your appp to v1?
# Rollback?
root@controller:~/k8s# kubectl rollout undo deployment nginxapp
deployment.apps/nginxapp rolled back

verify the same in web browser.
==================================

# Q. Again perform rolling update on the rolled back app?
Just apply deployment.yaml again which has v2.
#kubectl apply --filename=deployments.yaml --record=true
and verify the same with # kiubectl get deployments -o wide and check in webbrowser also.



# ************ THE END ************
