## Apply Manifests

```bash
# Create the namespace
kubectl apply -f .infrastructure/namespace.yml

# Create the busybox pod for testing
kubectl apply -f .infrastructure/busybox.yml

# Create the main todoapp pod
kubectl apply -f .infrastructure/todoapp-pod.yml
```

After applying, you can check the status of the pods in the todoapp namespace:

```bash
kubectl get pods -n todoapp -o wide
```

## Test using BusyBox

This method tests connectivity within the cluster by shelling into the busybox pod and curling the todoapp pod directly.

1) Get the todoapp pod IP address: Run the following command and find the IP listed in the IP column for the todoapp pod.
```bash
kubectl get pods -n todoapp -o wide

# Example output:
# NAME      READY   STATUS    RESTARTS   AGE   IP             NODE      NOMINATED NODE   READINESS GATES
# busybox   1/1     Running   0          64s   10.244.0.5     minikube  <none>           <none>
# todoapp   1/1     Running   0          64s   10.244.0.4     minikube  <none>           <none>
```

In this example, the todoapp IP is 10.244.0.4.

2) Exec into the busybox container: This command opens a shell session inside the running busybox pod.
```bash
kubectl -n todoapp exec -it busybox -- sh
```

3) Test the connection from inside the busybox shell: Once you are in the shell (you'll see a # or $ prompt), use curl to send a request to the todoapp pod's IP at port 8000. Replace <pod-ip> with the IP you found in step 1.
```bash
# Inside the busybox shell:
curl 10.244.0.4:8000
```

You should see the application's HTML or JSON response.

4) Exit the busybox shell: Type exit and press Enter.
```bash
# Inside the busybox shell:
exit
```

## Test using Port Forward

This method allows you to test the application from your local machine (e.g., in your browser or with curl on your own terminal).

1) Start the port forward: Run the following command. It will occupy your terminal until you stop it (with Ctrl+C). This command forwards your local port 8001 to the todoapp pod's port 8000.

```bash
kubectl port-forward pod/todoapp 8001:8000 -n todoapp

# Example output:
# Forwarding from 127.0.0.1:8001 -> 8000
# Forwarding from [::1]:8001 -> 8000
```

2) Test from your local machine: While the port-forward is running, open a new terminal or your web browser and access localhost on the port you specified (e.g., 8001).
Using curl:

```bash
curl localhost:8001
```

Using a browser: Navigate to http://localhost:8001


## Cleanup

Once you are finished, you can delete the pods to clean up the environment.

```bash
kubectl delete pod busybox -n todoapp
kubectl delete pod todoapp -n todoapp
```