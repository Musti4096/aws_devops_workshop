# Import Flask modules
from flask import Flask, url_for, render_template, request

# Create an object named app
app = Flask(__name__)

# Create a function named `home` which uses template file named `index.html` given under `templates` folder,
# send your name as template variable, and assign route of no path ('/')
@app.route("/")
def home():
    return render_template("index.html", name = "Mustafa")


# Write a function named `greet` which uses template file named `greet.html` given under `templates` folder
@app.route("/greet", methods= ["GET"])
def greet():
    if "user" in request.args:
        usr = request.args["user"]
        return render_template("greet.html", user=usr)
    else:
        return render_template("greet.html", user="Send your user name with user parameter query string")


# Write a function named `login` which uses `GET` and `POST` methods,
# and template files named `login.html` and `secure.html` given under `templates` folder
# and assign to the static route of ('login')

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user_name = request.form ["username"]
        return render_template("secure.html", user= user_name)
    else:
        return render_template("login.html")

    return render_template("login.html")



# Add a statement to run the Flask application which can be reached from any host on port 80.

#    app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    app.run(debug = True)
    #app.run(host="0.0.0.0", port=80)