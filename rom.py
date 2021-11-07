with open('rom.txt', 'w') as file:
	for _ in range(16,4096):
		file.write("\"000000000000000000000000000000000000\",\n")