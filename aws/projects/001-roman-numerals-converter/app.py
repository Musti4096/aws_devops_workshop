# Import Flask modules
from flask import Flask, url_for, render_template, request

# Create an object named app
app = Flask(__name__)

def romenconvert(num):
    num_map = [(1000, 'M'), (900, 'CM'), (500, 'D'), (400, 'CD'), (100, 'C'), (90, 'XC'),
           (50, 'L'), (40, 'XL'), (10, 'X'), (9, 'IX'), (5, 'V'), (4, 'IV'), (1, 'I')]
    num=int(num)
    if num>4000 or num<1:
        return ("Not Valid Input !!!")
    else :
        roman = ''
        while num > 0:
            for i, r in num_map:
                while num >= i:
                    roman += r
                    num -= i
        return roman


# Write a function named `login` which uses `GET` and `POST` methods,
# and template files named `login.html` and `secure.html` given under `templates` folder
# and assign to the static route of ('login')

@app.route("/", methods = ["POST", "GET"])
def index():
    developer_name = "E2426 Mustafa"
    if request.method == "POST":
        number_decimal = request.form.get("number")
        number_roman = romenconvert(number_decimal)
        return render_template("result.html", number_decimal = number_decimal, number_roman = number_roman, developer_name = developer_name )
    else:
        return render_template("index.html", developer_name = developer_name)

    

# Add a statement to run the Flask application which can be reached from any host on port 80.

#    app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    app.run(debug = True)
    #app.run(host="0.0.0.0", port=80)