
# write a function that converts the given milliseconds into hours, minutes, and seconds
def convert(milliseconds):
    # one hour in milliseconds
    hour_in_milliseconds = 60*60*1000
    # calculate the hours within given milliseconds
    hours = milliseconds // hour_in_milliseconds
    # calculate milliseconds left over when hours subtracted
    milliseconds_left = milliseconds % hour_in_milliseconds
    # one minute in milliseconds
    minutes_in_milliseconds = 60*1000
    # calculate the minutes within remainder milliseconds
    minutes = milliseconds_left // minutes_in_milliseconds
    # calculate milliseconds left over when minutes subtracted
    milliseconds_left %= minutes_in_milliseconds
    # calculate the seconds within remainder milliseconds
    seconds = milliseconds_left // 1000
    # format the output string
    return f'{hours} hour/s'*(hours != 0) + f' {minutes} minute/s'*(minutes != 0) + f' {seconds} second/s' *(seconds != 0) or f'just {milliseconds} millisecond/s' * (milliseconds < 1000)
    

# flag to show warning to the user, default is False.
is_invalid = False

# start endless loop to get user input continuously
while True:
    # info text to be shown to the user
    info = """
###  This program converts milliseconds into hours, minutes, and seconds ###
(To exit the program, please type "exit")
Please enter the milliseconds (should be greater than zero) : """

    # get the user input after showing info text.
    # if is_invalid set to True then show additional warning to the user
    # pass the input the alphanum variable after stripping white space characters
    alphanum = input('\nNot Valid Input !!!\n'*is_invalid + info).strip()
    # if the input is not decimal number
    if not alphanum.isdecimal():
        # then check, if it is the "exit" keyword
        if alphanum.lower() == 'exit':
            # if it is "exit", then say goodbye and terminate the program
            print('\nExiting the program... Good Bye')
            break
        # if it is a string other than "exit"
        else:
            # then set to invalid flag to True to show warning and continue with next cycle
            is_invalid = True
            continue
    # convert the given string to the integer
    millisecs = int(alphanum)
    # if the milliseconds is greater than 0
    if 0 < millisecs:
        # then convert milliseconds and print out the user
        print(
            f'\nMilliseconds of "{alphanum}"" is equal to {convert(millisecs)}')
        # and set invalid flag to the False, it might be set the True in previous cycle
        is_invalid = False
    # if the millisecond is out of bounds
    else:
        # then set to invalid flag to True to show warning
        is_invalid = True
