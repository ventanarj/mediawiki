# MediaWiki on OpenShift

Este repositório fornece:

1. **Imagem Docker personalizada** (`Dockerfile`) com PHP + Apache, dependências do MediaWiki e um entrypoint configurável via variáveis de ambiente.
2. **Chart Helm** (`helm/mediawiki`) contendo Deployment, Service, Route e PVC adaptados ao OpenShift, além de ConfigMap/Secrets para `LocalSettings.php` e credenciais do banco.
3. **Script de deploy** (`scripts/deploy.sh`) para instalar/atualizar o release no cluster.

## Build da imagem

```bash
docker build -t mediawiki-custom .
```

Variáveis suportadas pelo entrypoint:

- `MEDIAWIKI_CONFIG_PATH`: caminho de montagem do `LocalSettings.php` (default `/config/LocalSettings.php`).
- `MEDIAWIKI_CUSTOM_COMMAND`: comando customizado executado antes do Apache (ex.: `php maintenance/update.php`).

## Deploy via Helm

```bash
./scripts/deploy.sh <release> <namespace> <values.yaml>
```

Personalize `helm/mediawiki/values.yaml` para apontar o host, credenciais e parâmetros do PVC.
