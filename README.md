

# Claw Cloud Hysteria2 Docker Image

This repository provides a lightweight Docker image that automatically installs and configures [Hysteria 2](https://github.com/jewgh/claw-hy) for Claw Cloud deployments. The image intentionally tracks the upstream "latest" release and periodically rebuilds to stay in sync. Images are published to GitHub Container Registry (`ghcr.io`).

---

## Features

- Alpine Linux base image for minimal footprint
- Self-signed TLS certificate bootstrapped during build (replace with a valid cert for production)
- Hysteria configuration rendered from environment variables at container startup
- Quick setup for Claw Cloud environments and other platforms

---

## Environment Variables

| Variable        | Description                                      | Example                                    |
| --------------- | ------------------------------------------------ | ------------------------------------------ |
| `SERVER_DOMAIN` | Public domain assigned by Claw Cloud             | `abc.eu-central-1.clawcloudrun.com`        |
| `UDP_PORT`      | Internal UDP listening port                      | `5678`                                     |
| `PASSWORD`      | Client connection password (UUID recommended)    | `3fa85f64-5717-4562-b3fc-2c963f66afa6`     |

All variables can be overridden with `docker run -e` or platform-specific environment settings.

---

## Quick Start

```bash
docker run `
  --name claw-hy `
  -e SERVER_DOMAIN=abc.eu-central-1.clawcloudrun.com `
  -e UDP_PORT=5678 `
  -e PASSWORD=$(New-Guid) `
  -p 5678:5678/udp `
  ghcr.io/<your-gh-org-or-user>/claw-hy:latest
```

- Replace the `UDP_PORT` mapping with the actual public UDP port you need to expose.
- The image uses a self-signed certificate; swap in a trusted certificate/key pair for production workloads.
- Because the image follows upstream `latest`, rebuilds are scheduled to keep binaries current. Pin to a digest if you require reproducible builds.

---

## Deploying on Claw Cloud

1. **Application Name** – choose any identifier.
2. **Image** – `jewgh/claw-hy`.
3. **Resources** – CPU: 0.1, Memory: 64 MB (adjust as needed).
4. **Network** – expose the HTTP/GRPCS port if required and the UDP port (select `udp://`, set to Public for external access).
5. **Environment Variables** – example:

   ```env
   SERVER_DOMAIN=abc.eu-central-1.clawcloudrun.com
   UDP_PORT=5678
   PASSWORD=3fa85f64-5717-4562-b3fc-2c963f66afa6
   ```

6. **Logs & Client Configuration** – check container logs for the generated `hy2://` URI.

---

## Automated Builds

The included GitHub Actions workflow (`.github/workflows/docker-build.yml`) builds the image on a schedule and pushes `ghcr.io/<owner>/claw-hy:latest`. GHCR publishing relies on the repository `GITHUB_TOKEN`, which must have `packages: write` permission (enabled by default for public repos).



---

## Disclaimer

- Provided for educational and testing purposes. Do not use for illegal or commercial activities.
- Ensure compliance with local laws for both server and client regions. The authors are not liable for misuse.



---


