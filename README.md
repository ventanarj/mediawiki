# MediaWiki on OpenShift

Este repositório fornece uma solução completa para executar o MediaWiki no OpenShift com quatro instâncias cooperando entre si:

1. **Front-end** (PHP + Apache) exposto publicamente por Route/Service.
2. **Back-end** (PHP + Apache) para tarefas internas e integrações.
3. **Database** (MySQL 8) com PVC dedicado.
4. **Redis** usado como cache/memcached do MediaWiki.

Todos esses componentes são provisionados pelo chart Helm em `helm/mediawiki` e compartilham as configurações básicas (`url` e `environment`) informadas pelo usuário.

## Build da imagem

```bash
docker build -t mediawiki-custom .
```

Variáveis suportadas pelo entrypoint:

- `MEDIAWIKI_CONFIG_PATH`: caminho de montagem do `LocalSettings.php` (default `/config/LocalSettings.php`).
- `MEDIAWIKI_CUSTOM_COMMAND`: comando customizado executado antes do Apache (ex.: `php maintenance/update.php`).

## Parâmetros essenciais

Antes do deploy, ajuste `helm/mediawiki/values.yaml` (ou passe um arquivo customizado) preenchendo ao menos:

- `global.url`: endereço público. Ex.: `mediawiki.trf2.jus.br`.
- `global.environment`: identificador do ambiente (ex.: `dev`).
- Credenciais em `secrets.mediawiki` e `database.auth` (mantenha os valores alinhados) se desejar algo diferente dos padrões.

Essas informações são usadas para montar o `LocalSettings.php`, configurar as variáveis de ambiente dos pods e expor a rota correta.

## Deploy via Helm

```bash
./scripts/deploy.sh <release> <namespace> <values.yaml>
```

O chart cria Deployment/Service/Route/PVC para cada componente (front-end, back-end, database e redis). Ajuste réplicas, tamanhos de PVC e imagens conforme necessário.
