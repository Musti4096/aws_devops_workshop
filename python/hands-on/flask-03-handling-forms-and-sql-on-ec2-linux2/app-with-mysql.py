# Import Flask modules
from flask import Flask, render_template, request
from flaskext.mysql import MySQL
# Create an object named app
app = Flask(__name__)
# Configure mysql database
app.config['MYSQL_DATABASE_HOST'] = 'database-eu.c0jpxn16qmtk.us-east-1.rds.amazonaws.com'
app.config['MYSQL_DATABASE_USER'] = 'admin'
app.config['MYSQL_DATABASE_PASSWORD'] = '123456789'
app.config['MYSQL_DATABASE_DB'] = 'clarusway'
app.config['MYSQL_DATABASE_PORT'] = 3306
mysql = MySQL()
mysql.init_app(app)
connection = mysql.connect()
connection.autocommit(True)
cursor = connection.cursor()
# Create users table within MySQL db and populate with sample data
# Execute the code below only once.
# Write sql code for initializing users table..
drop_table = 'DROP TABLE IF EXISTS users;'
users_table = """
CREATE TABLE users (
  username varchar(50) NOT NULL,
  email varchar(50),
  PRIMARY KEY (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
"""  # Bu kullanım aslında sqlite ile aynı şeyi ifade etmekle birlikte bazı mysql convention'dan dolayı küçük farklılıklar ouşmaktadır. Bunlardan biri varchar olarak 50 dememiz gerekiyor burada. Ayrıca en sonda ENGINE tipi belirtmemiz gerekmektedir.
data = """
INSERT INTO clarusway.users 
VALUES 
    ("Levent Akyuz", "levent.akyuz@gmail.com"),
    ("Mustafa Kanat", "mustafa.kanat@yahoo.com"),
	("Hakan Sule", "hakan.sule@clarusway.com");
"""
cursor.execute(drop_table)
cursor.execute(users_table)
cursor.execute(data)
# cursor.close()
# connection.close()
# Write a function named `find_emails` which find emails using keyword from the user table in the db,
# and returns result as tuples `(name, email)`.
def find_emails(keyword):
    query = f"""
    SELECT * FROM users WHERE username like '%{keyword}%';
    """
    cursor.execute(query)  
    result = cursor.fetchall()
    user_emails = [(row[0], row[1]) for row in result]
    # if there is no user with given name in the db, then give warning
    if not any(user_emails):
        user_emails = [('Not found.', 'Not Found.')]
    return user_emails
# Write a function named `insert_email` which adds new email to users table the db.
def insert_email(name, email):
    query = f"""
    SELECT * FROM users WHERE username like '{name}';
    """
    cursor.execute(query)
    result = cursor.fetchall()
    # default text
    response = 'Error occurred..'
    # if user input are None (null) give warning
    if name == None or email == None:
        response = 'Username or email can not be emtpy!!'
    # if there is no same user name in the db, then insert the new one
    elif not any(result):
        insert = f"""
        INSERT INTO users
        VALUES ('{name}', '{email}');
        """
        cursor.execute(insert)
        response = f'User {name} added successfully'
    # if there is user with same name, then give warning
    else:
        response = f'User {name} already exits.'
    return response
# Write a function named `emails` which finds email addresses by keyword using `GET` and `POST` methods,
# using template files named `emails.html` given under `templates` folder
# and assign to the static route of ('/')
@app.route('/', methods=['GET', 'POST'])
def emails():
    if request.method == 'POST':
        user_name = request.form['username']
        user_emails = find_emails(user_name)
        return render_template('emails.html', name_emails=user_emails, keyword=user_name, show_result=True)
    else:
        return render_template('emails.html', show_result=False)
# Write a function named `add_email` which inserts new email to the database using `GET` and `POST` methods,
# using template files named `add-email.html` given under `templates` folder
# and assign to the static route of ('add')
@app.route('/add', methods=['GET', 'POST'])
def add_email():
    if request.method == 'POST':
        user_name = request.form['username']
        user_email = request.form['useremail']
        result = insert_email(user_name, user_email)
        return render_template('add-email.html', result=result, show_result=True)
    else:
        return render_template('add-email.html', show_result=False)
# Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ == '__main__':
   app.run(debug=True)
   #app.run(host='0.0.0.0', port=80)