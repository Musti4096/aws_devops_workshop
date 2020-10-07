from flask import Flask, render_template, request

app = Flask(__name__)
developer_name = "E2426 - Mustafa"
def millisecond_converter(millisec):
    value = int(millisec)
    if value < 1000:
        return f"just {value} millisecond/s"
    else:
        hour = value // 3600000
        #print(hour)
        minute = (value - (hour * 3600000)) // 60000
            #print(minute)
        second = (value - (hour * 3600000) - (minute * 60000)) // 1000
            #print(second)
        if hour and minute and second:
            return f"{hour} hour/s {minute} minute/s {second} second/s"
        elif hour:
            return f"{hour} hour/s"
        elif minute and second:
            return f"{minute} minute/s {second} second/s"
        elif minute:
            return f"{minute} minute/s"
        elif second:
            return f"{second} second/s" 

@app.route("/", methods=["GET"])
def main_get():
    return render_template("index.html", developer_name= developer_name, not_valid= False)

@app.route("/", methods=["POST"])
def main_post():
    second = request.form["number"]
    if not second.isdecimal():         return render_template("index.html", developer_name= developer_name, not_valid=True)
    
    second_int = int(second)
    if not second_int > 0:
        return render_template("index.html", developer_name= developer_name, not_valid=True)
    
    return render_template("result.html", developer_name= developer_name, milliseconds=second, result=millisecond_converter(second))

#    app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    app.run(debug = True)
    #app.run(host="0.0.0.0", port=80)