

### Deploy Traefik Ingress Controller
``` shell
helm repo add traefik https://traefik.github.io/charts
helm repo update
kubectl create namespace traefik

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=*.docker.localhost"

kubectl create secret tls wildcard-k8s-localhost-tls \
  --cert=traefik/tls/wildcard-k8s-localhost.crt --key=traefik/tls/wildcard-k8s-localhost.key \
  --namespace traefik

kubectl create secret tls traefik-k8s-localhost-tls \
  --cert=traefik/tls/traefik-k8s-localhost.crt --key=traefik/tls/traefik-k8s-localhost.key \
  --namespace traefik

helm install traefik traefik/traefik \
  --namespace traefik \
  --values traefik/values.yaml
```

#### Configure traefik with step-ca (external)
``` shell
step ca root ./traefik/tls/root_ca.crt

kubectl create configmap step-ca-root \
  --from-file=./traefik/tls/root_ca.crt \
  -n traefik

helm upgrade traefik traefik/traefik -f traefik/values.yaml -n traefik
```



### Deploy whoami
``` shell
kubectl apply -f traefik/whoami.yaml
kubectl apply -f traefik/whoami-ingress.yaml
```

### Deploy echo-server
``` shell
kubectl apply -f https://raw.githubusercontent.com/Ealenn/Echo-Server/master/docs/examples/echo.kube.yaml
kubectl port-forward -n echoserver deployment/echoserver 8080:80

iwr http://localhost:8080
```


