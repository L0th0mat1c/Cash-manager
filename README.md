# T-DEV-700_msc2023_group-24

## Production environment:

```bash
export APP_ENV=prod
docker-compose -f docker-compose.prod.yml up --build
```

## Development environment:

```bash
export APP_ENV=dev
docker-compose up --build
```

## Testing environment:

```bash
export APP_ENV=test
docker-compose up --build
```

### Test Only Java service

```bash
export APP_ENV=test
docker-compose up --build cashmanager-mysql cashmanager-api
```

### Test only GO service

```bash
export APP_ENV=test
docker-compose up --build market-api
```

## Swagger Bank Documentation

Localhost: http://localhost/bank/api/swagger-ui.html

Online: http://138.68.112.53/bank/api/swagger-ui.html

## Swagger Market Documentation

Localhost: http://localhost/market/api/doc/

Online: http://138.68.112.53/market/api/doc/
