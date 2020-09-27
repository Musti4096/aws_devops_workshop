# Import Flask modules
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy
# Create an object named app
app = Flask(__name__)
# Configure sqlite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./email.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS']= False
db = SQLAlchemy(app)
# Execute the code below only once.
# Write sql code for initializing users table..
drop_table= """
DROP TABLE IF EXISTS users;
"""
users_table = """    
CREATE TABLE users(
username VARCHAR NOT NULL PRIMARY KEY,
email VARCHAR);
"""
data = """
INSERT INTO users
VALUES
    ("Levent Akyuz", "levent.akyuz@gmail.com"),
    ("Mustafa Kanat", "mustafa.kanat@yahoo.com"),
    ("Hakan Sule", "hakan.sule@clarusway.com");
"""
db.session.execute(drop_table)
db.session.execute(users_table)
db.session.execute(data)
db.session.commit()
# Write a function named `find_emails` which find emails using keyword from the users table in the db,
# and returns result as tuples `(name, email)`.
def find_emails(keyword):
    query=f"""
    SELECT * FROM users WHERE username like '%{keyword}%';
    """
    result = db.session.execute(query)
    user_emails = [(row[0], row[1]) for row in result]
    if not any(user_emails):
        user_emails = [('Not Found', 'Not Found')]
    return user_emails
# Write a function named `insert_email` which adds new email to users table the db.
def insert_email(name, email):
    query = f"""
    SELECT * FROM users WHERE username LIKE '{name}';
    """
    result = db.session.execute(query)
    if name == None or email == None:
        response = 'Username or email can not be empty'
    elif not any(result):
        insert = f"""
        INSERT INTO users 
        VALUES ('{name}', '{email}');
        """
        result = db.session.execute(insert)
        db.session.commit()
        response =f'User {name} added successfully'
    else:
        response = f'User {name} already exist.'
    return response


# Write a function named `emails` which finds email addresses by keyword using `GET` and `POST` methods,
#using template files named `emails.html` given under `templates` folder
# and assign to the static route of ('/')
@app.route("/", methods =["GET", "POST"])
def emails():
    if request.method == "POST":
        user_name = request.form["username"]
        user_emails = find_emails(user_name)
        return render_template("emails.html", name_emails = user_emails, keyword = user_name, show_result=True )
    else:
        return render_template("emails.html", show_result= False)

#Write a function named `add_email` which inserts new email to the database using `GET` and `POST` methods,
# using template files named `add-email.html` given under `templates` folder
# and assign to the static route of ('add')
@app.route("/add", methods=["GET", "POST"])
def add_emails():
    if request.method == "POST":
        user_name = request.form["username"]
        user_email = request.form["useremail"]
        result = insert_email(user_name, user_email)
        return render_template("add-email.html", result = result, show_result = True)
    else:
        return render_template("add-email.html", show_result=False)

# Add a statement to run the Flask application which can be reached from any host on port 80.
#app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    #app.run(debug=True)
    app.run(host=0.0.0.0/0, port=80)