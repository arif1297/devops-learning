FROM python:3.11-alpine

WORKDIR /app

COPY app.py .
RUN pip install flask redis

EXPOSE 5001

CMD ["python", "app.py"]
