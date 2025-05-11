# Fix for Frontend-Backend Connection Issue

## Diagnosis
The frontend application is failing to connect to the backend API with error "Failed to fetch server information". This is because of a CORS (Cross-Origin Resource Sharing) issue or API URL configuration issue in the React frontend.

## The Issue
When you access the app through Minikube's service tunnel (http://127.0.0.1:59272), the frontend code is trying to connect to a hardcoded API URL instead of using the relative path.

## Solution Options (Choose One)

### Option 1: Quick fix without redeployment
Access your application using the direct NodePort URL instead:
```
http://192.168.49.2:30008
```
This URL might work better as it bypasses the tunneling that could be causing issues.

### Option 2: Fix with small config change and redeployment
1. Update your Dockerfile to add this environment variable:
```
ENV REACT_APP_API_URL=/api
```

2. Rebuild and redeploy:
```
eval $(minikube -p minikube docker-env)
docker build -t k8s-demo-app:latest .
kubectl rollout restart deployment/k8s-demo-app -n scd-project
```

### Option 3: Quick fix with a service proxy
Create a ConfigMap with a nginx.conf file to properly proxy API requests, then add a sidecar container to your deployment.

## Documentation for Project Report
Add this as one of the issues you encountered during deployment:
"Frontend application couldn't connect to backend API when accessed through service tunnel due to CORS/API URL configuration. Fixed by using direct NodePort access / updating environment variables / adding a proxy configuration." 