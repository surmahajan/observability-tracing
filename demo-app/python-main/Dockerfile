FROM python:3.7.7-slim

WORKDIR /
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py /opt/microservices/
COPY requirements.txt /opt/microservices/

EXPOSE 9080
WORKDIR /opt/microservices

CMD ["python", "main.py", "9080"]