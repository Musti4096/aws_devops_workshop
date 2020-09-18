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
    number = str(input("Please Enter a number between 1 and 3999 to convert Roman Numerals"))

    if not number.isnumeric():
        print("Invalid Entry! Please enter a valid number!")
        continue

    if number.lower() == "exit" :
        print("Exiting the program... Good Bye")
        break
        
    if  0 > int(number) or int(number) > 4000:
        print("Invalid Entry! Please enter a valid number!")
        continue

    num = []
    for i in number: # 1 5 4 2
        num.append(i)

    roman = three[int(num[0])] +  two[int(num[1])] + one[int(num[2])] + zero[int(num[3])]

    print(roman)






