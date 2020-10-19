word = input("Please enter a string: ")
word = word.lower()
vowels = ["a", "e", "i", "o", "u"]
exist = False
for i in range(len(word)-1):
  if word[i] in vowels:
    if word[i+1] in vowels:
      exist = True
      break
if exist:
  print("Positive")
else:
  print("Negative")