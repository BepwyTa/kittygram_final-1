# Kittygram

Сайт для публикации фотографий котиков. Можно регистрироваться, добавлять своих котов с фоткой, именем, цветом и годом рождения, смотреть чужих.

## Стек

Python 3.9 / Django / DRF / Gunicorn / PostgreSQL / React / Docker / Nginx / GitHub Actions

## Локальный запуск

Скопируй `.env.example` → `.env`, заполни переменные, затем:

```bash
docker compose up -d
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py collectstatic --noinput
```

Откроется на `http://localhost:9000`.

## Деплой

При пуше в `main` GitHub Actions прогоняет тесты (flake8, pytest, Django tests, npm test), собирает образы, пушит на Docker Hub и деплоит на сервер через SSH. После успешного деплоя приходит уведомление в Telegram.

Образы на Docker Hub: `bepwyta/kittygram_backend`, `bepwyta/kittygram_frontend`, `bepwyta/kittygram_gateway`.

## Переменные окружения

Смотри `.env.example` — там все нужные переменные с комментариями.

## Автотесты проекта

```bash
# Создай venv, поставь зависимости из backend/requirements.txt, затем:
pytest
```
