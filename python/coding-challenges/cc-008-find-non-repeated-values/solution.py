products = ["Pride and Prejudice", "To Kill a Mockingbird", "The Great Gatsby", "One Hundred Years of Solitude", \
            "Pride and Prejudice", "In Cold Blood", "Wide Sargasso Sea", \
            "One Hundred Years of Solitude", "Brave New World",  "The Great Gatsby", "Brave New World", \
            "I Capture The Castle", "Brave New World", "The Great Gatsby", "The Great Gatsby", \
            "One Hundred Years of Solitude", "Pride and Prejudice"]
for product_1 in products:
  count = 0
  for product_2 in products:
    if product_1 == product_2:
      count += 1
      if count > 1:
        break
  if count == 1:
    print(product_1)