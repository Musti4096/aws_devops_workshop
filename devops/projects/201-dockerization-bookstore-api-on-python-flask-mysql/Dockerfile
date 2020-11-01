FROM python:3.7-alpine
WORKDIR /code
ENV FLASK_APP bookstore-api.py
ENV FLASK_RUN_HOST 0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt /code/
RUN pip install -r requirements.txt
EXPOSE 80
COPY . /code/
CMD ["flask", "run"]