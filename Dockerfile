ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}

# Set the working directory
WORKDIR /app
COPY src/ .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8000

# Run database migrations and start the Django application
ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
