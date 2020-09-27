from flask import Flask, render_template, request

app = Flask(__name__)

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

@app.route("/", methods=["POST", "GET"])
def index():
    developer_name = "E2426 Mustafa"
    if request.method == "POST":
        millisec = request.form.get("number")
        result = millisecond_converter(millisec)
        return render_template("result.html",milliseconds= millisec, result = result, developer_name = developer_name)
    else:
        return render_template("index.html", developer_name = developer_name)

#    app.run(host='0.0.0.0', port=80)
if __name__ == "__main__":
    #app.run(debug = True)
    app.run(host="0.0.0.0", port=80)