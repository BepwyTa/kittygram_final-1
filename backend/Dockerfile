FROM python:3.9-slim

WORKDIR /app

RUN pip install --upgrade pip --root-user-action=ignore

COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir --root-user-action=ignore

COPY . .

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "kittygram_backend.wsgi"]
