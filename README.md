

### Deploy Traefik Ingress Controller
``` shell
helm repo add traefik https://traefik.github.io/charts
helm repo update
kubectl create namespace traefik

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=*.docker.localhost"

kubectl create secret tls local-selfsigned-tls \
  --cert=traefik/tls/tls.crt --key=traefik/tls/tls.key \
  --namespace traefik

helm install traefik traefik/traefik `
  --namespace traefik `
  --values traefik/values.yaml
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

