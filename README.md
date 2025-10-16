# Cow wisdom web server

This repository now includes production-ready artifacts to containerize, deploy, automate, and secure the Wisecow app.

## Prerequisites (local run)

```
sudo apt install fortune-mod cowsay -y
```

## How to use (local)

1. Run `./wisecow.sh`
2. Open `http://localhost:4499`

## Docker

```
docker build -t YOUR_DOCKERHUB/wisecow:latest .
docker run --rm -p 4499:4499 YOUR_DOCKERHUB/wisecow:latest
```

## Kubernetes

Manifests are in `k8s/`:
- `k8s/deployment.yaml`
- `k8s/service.yaml`
- `k8s/ingress.yaml` (optional TLS)

Deploy:
```
kubectl apply -f k8s/deployment.yaml -f k8s/service.yaml
kubectl port-forward svc/wisecow-service 8080:80
# open http://localhost:8080
```

Ingress + TLS (requires Ingress controller and cert-manager):
```
kubectl apply -f k8s/ingress.yaml
```

## CI/CD (GitHub Actions)

Workflow: `.github/workflows/cicd.yml`

Repository secrets required:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- Optional `KUBECONFIG` (base64 of `kubectl config view --raw`)

On push to `main`, the workflow builds and pushes:
- `DOCKERHUB_USERNAME/wisecow:latest`
- `DOCKERHUB_USERNAME/wisecow:${GITHUB_SHA}`

If `KUBECONFIG` is provided, it deploys manifests and waits for rollout.

## Scripts (PS2)

- `scripts/health_monitor.sh`: Logs CPU/MEM/DISK and alerts when thresholds are exceeded.
  - Env vars: `CPU_THRESHOLD` (80), `MEM_THRESHOLD` (80), `DISK_THRESHOLD` (90), `LOG_FILE` (/var/log/health_monitor.log)
- `scripts/app_health_check.py`: Checks HTTP status of an app URL (default `http://localhost:4499`).

## KubeArmor Policy (optional bonus)

Apply after installing KubeArmor:
```
kubectl apply -f k8s/kubearmor-policy.yaml
```

## Notes

- Replace `DOCKERHUB_USERNAME` in `k8s/deployment.yaml` or rely on CI replacement step during deploy.
- Service is `ClusterIP`; port-forward or switch to NodePort/LoadBalancer for external access.
