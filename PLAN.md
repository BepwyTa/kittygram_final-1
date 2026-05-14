# Kittygram: план работ и статус

## Уже сделано в репозитории (код и конфиги)

- **Backend:** `backend/Dockerfile`, Gunicorn, `requirements.txt` (в т.ч. gunicorn, psycopg2-binary, Pillow), `.dockerignore`.
- **Django:** `settings.py` — PostgreSQL при наличии `POSTGRES_DB`, иначе SQLite для тестов; `STATIC_ROOT`/`MEDIA_ROOT` для контейнера.
- **Nginx (gateway):** `nginx/Dockerfile`, `nginx.conf` — прокси `/api/`, `/admin/` на backend, `/media/`, SPA из `/static`.
- **Docker Compose (dev):** сервисы `db`, `backend`, `frontend`, `gateway`; тома `pg_data`, `static`, `media`; порты **9000:80**; healthcheck Postgres; `env_file: .env` где нужно.
- **Production:** `docker-compose.production.yml` — только `image` (без `build`), подстановка `${DOCKERHUB_USERNAME}`.
- **CI/CD:** `.github/workflows/main.yml` — flake8, pytest структуры, Django tests, npm test → build/push трёх образов → scp compose → ssh pull/up/migrate/collectstatic → Telegram (curl).
- **Линтер:** корневой `setup.cfg` для flake8 (исключены migrations, длинные строки в `settings.py`).
- **Compose:** `gateway` ждёт успешного завершения контейнера `frontend` (одноразовое копирование статики), затем стартует.
- **Копия workflow:** `kittygram_workflow.yml` в корне (для ревьюеров).
- **Шаблоны:** `.env.example`, `tests.yml` (ключи для автопроверки), пример хостового nginx: `deploy/host-nginx-one-ip.conf.example`.

## Что нужно сделать тебе (без доступа к твоим аккаунтам и серверу)

1. **GitHub:** форк/свой репозиторий, запушить этот проект в ветку **main**.
2. **Secrets (Settings → Actions):** `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `HOST`, `USER`, `SSH_KEY`, при необходимости `SSH_PASSPHRASE`, опционально `TELEGRAM_TOKEN`, `TELEGRAM_TO`.
3. **На сервере:** Docker + compose plugin; каталог `~/kittygram/`; файл **`.env`** (скопировать с `.env.example`, задать свои пароль/SECRET_KEY/`ALLOWED_HOSTS`/`DOCKERHUB_USERNAME` = логин Docker Hub); один раз вручную `docker compose ... up` при необходимости.
4. **Системный Nginx:** для домена Kittygram — весь трафик на `http://127.0.0.1:9000`; HTTPS (certbot). Taski и Kittygram на **одном IP** (требование тестов).
5. **Docker Hub:** три **публичных** репозитория образов: `логин/kittygram_backend`, `логин/kittygram_frontend`, `логин/kittygram_gateway`.
6. **`tests.yml`:** подставить свой `repo_owner`, реальные `https://...` для Kittygram и Taski, `dockerhub_username`.
7. После правок **`main.yml`** снова скопировать его в **`kittygram_workflow.yml`** (или держать их одинаковыми).

## Артефакт для загрузки на платформу

- Архив **`kittygram_final_submit.zip`** в каталоге `c:\Dev\newneww\` (пересобирается после изменений).
