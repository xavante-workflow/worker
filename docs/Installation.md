# Installation

In dev environment, with different core location:
```
cd /app/lib
ln -s ../../../lib/core ./core
docker compose exec xavante-worker ls -la /app/lib/core
```


