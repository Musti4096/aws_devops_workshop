FROM python:alpine
COPY . .


ENV MYSQL_DATABASE_HOST database
ENV MYSQL_DATABASE_USER clarusway
ENV MYSQL_DATABASE_PASSWORD Clarusway
ENV MYSQL_DATABASE_DB phonebook
ENV MYSQL_DATABASE_PORT 3306

RUN pip install -r requirements.txt
EXPOSE 80
ENTRYPOINT [ "python" ]
CMD ["src/app.py"]