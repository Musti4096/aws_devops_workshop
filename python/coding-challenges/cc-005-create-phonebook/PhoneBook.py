def print_menu():
    print('1. Find a Phone Number')
    print('2. Insert a Phone Number')
    print('3. Delete a Person From the Phonebook')
    print('4. Terminate')
    print()

numbers = {}
menu_choice = 0
print_menu()
while menu_choice != 4:
    menu_choice = int(input("Type in a number (1-4): "))
    if menu_choice == 1:
        print("Find a Phone Number")
        name = input("Name: ")
        if name in numbers:
            print("The number is", numbers[name])
        else:
            print(name, "was not found")
    elif menu_choice == 2:
        print("Insert a Phone Number")
        name = input("Name: ")
        phone = input("Number: ")
        numbers[name] = phone
    elif menu_choice == 3:
        print("Delete a Person From the Phonebook")
        name = input("Name: ")
        if name in numbers:
            del numbers[name]
        else:
            print(name, "was not found")
    elif menu_choice != 4:
        print_menu()