FROM --platform=linux/amd64 python:3.11-bookworm
ENV PYTHONUNBUFFERED=1
WORKDIR /django
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
CMD gunicorn simply.wsgi:application --bind 0.0.0.0:8000
EXPOSE 8000