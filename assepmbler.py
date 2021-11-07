import sys

from iic2343 import Basys3


dict_op={
	"movA,Lit": ""
}

rom_programmer = Basys3()
if __name__ == '__main__':

	# Begin serial proggraming (stops the CPU and enables proggraming)
	rom_programmer.begin(port_number = 0)
	# print(rom_programmer.write(0, bytearray([0x0, 0x0, 0x0, 0x6, 0x0,0x0, 0x4, 0x4, 0x0])))
	print(rom_programmer.write(1, bytearray([0x0, 0x00, 0x60, 0x04, 0x40])))
	# 12 bits address: 2, 36 bits word: 0x000201803
	rom_programmer.write(2, bytearray([0x0, 0x00, 0x20, 0x18, 0x03]))
	# 12 bits address: 3, 36 bits word: 0x000002000
	rom_programmer.write(3, bytearray([0x0, 0x00, 0x00, 0x20, 0x00]))
	# End serial proggraming