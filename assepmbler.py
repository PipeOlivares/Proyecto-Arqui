import io
import sys
import re
from iic2343 import Basys3
with open('r.txt', 'w+') as file:
	cont = 0

	cache = []
	encoding = {
		'h': 6,
		'b': 2,
		'd': 10,
		'o': 8,
		'': 10
	}

	dict_op={   
	           #IMPORTANTE PONER LOS DICTS DE LOS OPCODES}
			}
	jumps = [
	'JMP',
	'JEQ',
	'JNE',
	'JGT',
	'JGE',
	'JLT',
	'JLE',
	'JCR',
	'CALL']
	with open("opcodes.tsv","r") as f:
		for line in f:
		    line = line.strip('\n')
		    (key, val) = line.split("	")
		    val = val.split(';')
		    dict_op[key] = val

	rom_programmer = Basys3()
	rom_programmer.begin()

	if __name__ == '__main__':

		def op_coder(op):     #Funcion que pasa los op codes '110100101' al formato de [hexa,hexa,hexa,hexa,hexa]
			hexas=[]
			a=op[0:4]
			b =int(a, 2)
			c =hex(b)
			hexas.append(c)

			for i in range(4):
				a=op[(i*8)+4:(i*8)+12]
				b =int(a, 2)
				c =hex(b)
				hexas.append(c)
			return hexas
		
		instrucciones = (sys.argv[1])         #Sacamos las lineas de codigo del archivo
		arch = open(f"{instrucciones}",'r')
		lines=arch.readlines()
		ops_code=[]

		for i in lines:
			i=i.strip('\n').replace('\t','')            
			op=i.split('//')
			ops_code.append(op[0])

		contador=0              #Este seria el contador para saber en que instruccion vamos
		ops_code.pop(0)
		data=[]
		while ops_code[0].strip()!='CODE:':
			data.append(ops_code.pop(0))   #Esto es para sacar todos los posibles valores en Data, funciona aunque no tenga ninguno
                                                          
		# rom_programmer.begin(port_number = 0)   #Con esto parte el write (creo)

		dict_registros={}

		for i in range(len(data)):
			
			var=data[i].strip()
			var = var.replace('\t','').split(' ')

			
			if len(var) >=  2:
				dict_registros[var[0]]= format(i,'b').zfill(16)
				if 'b' in var[1]:
					lit=var[1][:len(var[1])-1].zfill(16)
				elif 'h' in var[1]:
					lit=str(format(int(var[1][:len(var[1])-1], 16),'b')).zfill(16)
				else:
					if 'd' in var[1]:
						var[1]=var[1][:len(var[1])-1]

					lit=str(format(int(var[1]), "b")).zfill(16)
				
														#Esta parte esta media dudosa, pero es la de que tenemos que guardar los valores en los reg, 
														#el tema es que no se si hay que crear los reg antes o no, pero asi es como lo hicimos en la entrega 1
				
										
				op=lit+'00000000010001000000'			#Esto es --MOV A,LIT
				hexas=op_coder(op)
				hexi = bytearray([int(a.replace("0x", ''), 16) for a in hexas])
				contador +=1
				file.write('"'+op+'",\n')
				print(contador)
				print("Exit status " + str(rom_programmer.write(contador, hexi)))
				contador+=1
				op=	dict_registros[var[0]] +'00000000000010000001' #Esto es --MOV REG,A      
				hexas=op_coder(op)
				file.write('"'+op+'",\n')
				contador +=1 
				print(contador)
				hexi = bytearray([int(a.replace("0x", ''), 16) for a in hexas])
				print("Exit status " + str(rom_programmer.write(contador, hexi)))

																#Lo hice con los opcodes del excel, pero si lo revisan god igual
		ops_code.pop(0)
		dict_labels= {}
		print(ops_code)
		for i in range(len(ops_code)):
			if ':' in ops_code[i]:                       #Guardar los labels
					var= ops_code[i][:-1].strip().replace(':','')
					dict_labels[var.replace(':','')] = str(format(int(contador+ i+1), "b")).zfill(16) 
					print(var)
					print(contador)
					ops_code[i] = "NOP"
		for i in range(len(ops_code)):         #Aqui parte el CODE
			if ops_code[i]=='' or ':' in ops_code[i] or ops_code[i] == '\n':    #Ignorar lineas vacias y los labels
				pass

			else:			
											 #Lineas de codigo
				var= ops_code[i]
				
				var = var.replace(' ','')
				var = var.replace('\t','')
				print(var)
				if '(' in var:
					if not '(B)' in var:
						lab = var[var.index('(')+1:var.index(')')]	# lab -> variable o número
						var = var[0:var.index('(')+1]+'REG'+var[var.index(')'):]
						num = ''
						print(lab[-1])
						if lab[-1] in "0123456789":
							try:
								num =  str(format(int(lab, 10),'b')).zfill(16)
								op = [num+ opi for opi in dict_op[var]]
							except KeyError as e:
								raise ValueError(f'''
	Encoding no aceptado: {lab[-1]},
	Se pueden usar los siguientes encodings:
	{[x for x in encoding.keys()]}''')
						else:
							print(lab)
							value = dict_registros.get(lab)
							if value:
								op = [value+ opi for opi in dict_op[var]]
							else:
								raise ValueError(f'Registro no identificado: {lab}, {dict_registros}')
					else:
						op = [opi.zfill(36) for opi in dict_op[var]]
				
				elif any(x in var for x in jumps):
					print('hola')
					if 'CALL' in var:
						lab = var[4:]
					else:
						lab = var[3:]
					value = dict_labels.get(lab)
					if value:
						op = [value+ opi for opi in dict_op[var.replace(lab,'INS')]]
					else:
						raise ValueError(f'Label no identificado: {lab}, {dict_labels}')
				elif var[-1] in encoding.keys():									#Literales
					
					if var[-1] == 'h':
						num = var[-3:-1]
					else:
						num = re.search(r'\d+', var).group()
					ind = var.index(num)
					num = var[ind:-1]
					num = str(format(int(num, encoding[var[-1]]),'b')).zfill(16)
					op = [num + opi for opi in dict_op[var[:ind]+'L']]
				elif "DECA" in var:
					op = ['100000000010011000010'.zfill(36)]
				elif "INCA" in var:
					op = ['100000000010011000000'.zfill(36)]
				elif var[-1] in '0123456789':									#Literales
					var = var.split(',')
					num = var[1]
					num = str(format(int(num, 10),'b')).zfill(16)
					op = [num + opi for opi in dict_op[var[0]+',L']]
				else:
					op = [opi.zfill(36) for opi in dict_op[var]]

				for line in op:
					hexas = op_coder(line)
					hexi = bytearray([int(a.replace("0x", ''), 16) for a in hexas])
					contador += 1
					print(contador)
					file.write('"'+line+'",\n')
					print("Exit status " + str(rom_programmer.write(contador, hexi)))
												  #Dependee como guardemos el dict con los opcodes es como tendremos que escribir esta parte


	rom_programmer.end()