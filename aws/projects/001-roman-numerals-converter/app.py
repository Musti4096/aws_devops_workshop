# Import Flask modules
from flask import Flask, url_for, render_template, request

# Create an object named app
app = Flask(__name__)

def romenconvert(number_decimal):
    zero = {0 : "", 1 : "I" , 2 : "II", 3 : "III", 4 : "IV",
        5 : "V" , 6 : "VI", 7: "VII", 8 : "VIII",
        9 : "IX" }

    one = {0: "", 1 : "X" , 2 : "XX", 3: "XXX", 4 : "XL",
         5 : "L" , 6 : "LX", 7: "LXX", 8 : "LXXX",
         9 : "XC" }


    two = {0: "", 1 : "C" , 2 : "CC", 3: "CCC", 4 : "CD",
         5 : "D" , 6 : "DC", 7: "DCC", 8 : "DCCC",
         9 : "CM" }

    three = {0: "", 1 : "M" , 2 : "MM", 3: "MMM"}

    print("###  This program converts decimal numbers to Roman Numerals ###\n (To exit the program, please type 'exit')")

    while True:
    
        if not number_decimal.isnumeric():
            print("Invalid Entry! Please enter a valid number!")
            continue

        if number_decimal.lower() == "exit" :
            print("Exiting the program... Good Bye")
            break
        
        if  0 > int(number_decimal) or int(number_decimal) > 4000:
            print("Invalid Entry! Please enter a valid number!")
            continue

        num = []
        for i in number_decimal: # 1 5 4 2
            num.append(i)
        
        number_roman = three[int(num[0])] +  two[int(num[1])] + one[int(num[2])] + zero[int(num[3])]

    return   number_roman 



# Write a function named `login` which uses `GET` and `POST` methods,
# and template files named `login.html` and `secure.html` given under `templates` folder
# and assign to the static route of ('login')

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        num = request.form ["number"]
        return render_template("index.html", number= num)
    else:
        return render_template("result.html")
    
    return render_template("index.html")



# Add a statement to run the Flask application which can be reached from any host on port 80.

#    app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    app.run(debug = True)
    #app.run(host="0.0.0.0", port=80)