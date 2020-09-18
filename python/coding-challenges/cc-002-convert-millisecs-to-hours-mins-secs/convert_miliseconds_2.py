print("This program converts miliseconds into hours, minutes and seconds\n (To exit the program, please type 'exit')")
while True:
    millisec = input("Please enter the milliseconds (should be greater than zero) :")
    if millisec == "exit":
        break
    elif millisec:
        value = int(millisec)
        if value < 1000:
            print(f"just {value} millisecond/s")
        else:
            hour = value // 3600000
            #print(hour)
            minute = (value - (hour * 3600000)) // 60000
            #print(minute)
            second = (value - (hour * 3600000) - (minute * 60000)) // 1000
            #print(second)
            if hour and minute and second:
                print(f"{hour} hour/s {minute} minute/s {second} second/s")
            elif hour:
                print(f"{hour} hour/s")
            elif minute and second:
                print(f"{minute} minute/s {second} second/s")
            elif minute:
                print(f"{minute} minute/s")
            elif second:
                print(f"{second} second/s")    
    else:
        print("Not Valid Input !!!")
print("Good Bye!")
    