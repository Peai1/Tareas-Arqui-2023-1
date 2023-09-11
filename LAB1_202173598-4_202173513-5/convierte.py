def representacionBase(base, numero):

    base = int(base)
    hexadecimal = '0123456789ABCDEF'

    for digito in str(numero):
        if digito not in hexadecimal[:base]:
            return False
        
    return True
'''
Función que verifica si el número esta representado correctamente por la base, si todos los dígitos estan
dentro del rango de la base, retorna True, en caso contrario, False. Toma como parámetros la
base y el número a evaluar.
Parametros:
            base (str): base a verificar
            numero (str): numero a verificar si puede ser representado por la base
'''
def decimalABinario(decimal):

    bin = ""
    while decimal > 0:

        resto = decimal % 2
        bin = str(resto) + bin
        decimal = decimal // 2
    
    return int(bin)
'''
Función que toma un número decimal para despues hacer la conversión de este a binario, retornando el número
en binario.
Parametros:
            decimal (str): numero decimal a ser transformado a binario 
'''
def numeroADecimal(numero,base):

    base = int(base)

    diccionario = {"A":10,"B":11,"C":12,"D":13,"E":14,"F":15}

    numeroEnLista = []
    decimal = 0

    for digito in str(numero):
        numeroEnLista.append(digito)

    numeroEnLista.reverse()

    for i in range(len(numeroEnLista)):
        if numeroEnLista[i] in diccionario:
            decimal += diccionario[numeroEnLista[i]] * (base)**i
        else:
            decimal += int(numeroEnLista[i]) * (base)**i

    return decimal
'''
Función que convierte un número en una base específica a base decimal, asigna valor numérico a los digitos de A-F
para las operaciones necesarias y retorna su valor numerico decimal. Toma como parámetro el número
a convertir junto a su base.
Parametros:
            numero (str): numero en la base indicada a ser transformado a decimal   
            base (str): base del numero
'''
def sumaBinariosC2(bin1,bin2):

    carry = 0
    resultado = ""
    bin1Aux = bin1

    # overflow puede ocurrir solo cuando son del mismo signo

    # si son de diferente signo retorna false ya que no puede haber overflow
    if bin1[0] == "1" and bin2[0] == "0":
        return False
    if bin1[0] == "0" and bin2[0] == "1":
        return False
    
    # si son del mismo signo, se realiza la suma de los binarios

    while len(bin1) > 0 and len(bin2) > 0:

        bin1lsb = int(bin1[-1])  # bit menos significativo
        bin2lsb = int(bin2[-1])

        suma = bin1lsb + bin2lsb + carry

        if suma > 1:
            carry = 1
        else:
            carry = 0

        if suma == 1 or suma == 3:
            resultado = "1" + resultado
        elif suma == 0 or suma == 2:
            resultado = "0" + resultado

        bin1 = bin1[:-1]   # remueve el ultimo digito
        bin2 = bin2[:-1] 
  
    # si es diferente el signo de los numeros iniciales del resultado que dió la suma -> hay overflow

    if bin1Aux[0] != resultado[0]:
        return True

    return False
'''
Función que etecta si se genera un overflow entre la suma de dos números binarios en complemento 2, si son de 
distinto signo, retorna False, en caso contrario, se verifica la suma y si el signo de los numeros
iniciales resulta diferente del resultado de la suma, hay overflow y retorna True, caso contrario,
retorna False. Toma como parámetros los dos números binarios a sumar.
Parametros:
            bin1 (str): primer operando en binario de la suma
            bin2 (str): segundo numero en binario operando de la suma

'''   
escritura = open('resultados.txt','w')
total_errores = 0
x = True

while x:

    arch = open('numeros.txt','r')
    total_numeros = 0
    error_representacion = 0
    error_bits = 0
    error_overflow = 0

    registro = int(input("Ingrese un numero por pantalla entre 1 y 32: "))

    if registro == 0:

        for linea in arch:
            total_numeros += 2

        print("Total numeros en el archivo:",total_numeros)
        print("Total errores hasta este punto:",total_errores)

        if total_errores > total_numeros:
            x = False
            print("Total de numeros en el archivo menor que el total de errores por lo que el programa termina")
        else:
            print("Total de numeros en el archivo mayor que el total de errores por lo que el programa continua")
    
    else:

        for linea in arch:

            num1BinarioString = num2BinarioString = ""
            flag = False
            linea = linea.strip().split("-")

            base1 = linea[0].split(";")[0]
            num1 = linea[0].split(";")[1]
            base2 = linea[1].split(";")[0]
            num2 = linea[1].split(";")[1]

            # Si no hay representacion de error en la base, se va al "else", donde se verifica si se puede guardar en el registro
            # y se realiza la extension de signo en caso de ser necesario

            if representacionBase(base1,num1) == False:
                error_representacion += 1
                flag = True

            else:
                num1Decimal = numeroADecimal(num1,base1)
                num1Binario = decimalABinario(num1Decimal)

                if len(str(num1Binario)) > registro:
                    error_bits += 1
                    flag = True

                # Extensión de signo

                if len(str(num1Binario)) < registro:
                    bms = str(num1Binario)[0]
                    num1BinarioString = bms * (registro - len(str(num1Binario))) + str(num1Binario)            
                else:
                    num1BinarioString = str(num1Binario)

            if representacionBase(base2,num2) == False:
                error_representacion += 1
                flag = True

            else:
                num2Decimal = numeroADecimal(num2,base2)
                num2Binario = decimalABinario(num2Decimal)

                if len(str(num2Binario)) > registro:
                    error_bits += 1
                    flag = True

                # Extensión de signo

                if len(str(num2Binario)) < registro:
                    bms = str(num2Binario)[0]
                    num2BinarioString = bms * (registro - len(str(num2Binario))) + str(num2Binario)
                else:
                    num2BinarioString = str(num2Binario)

            # Si es que no hubo ningun otro error, Flag == False y se realiza la suma en C2 para ver si hay overflow

            if flag == False:
                if sumaBinariosC2(num1BinarioString,num2BinarioString) == True:
                    error_overflow += 1

            total_numeros += 2

        print("Total numeros: ",total_numeros)
        print("Total con error en representacion numerica:",error_representacion)
        print("Total numeros que no pueden ser representados con el valor ingresado:",error_bits)
        print("Total errores de suma con overflow:",error_overflow)
        escritura.write(str(total_numeros) + ";" + str(error_representacion) + ";" + str(error_bits) + ";" + str(error_overflow) + "\n")

    total_errores += error_representacion + error_bits + error_overflow
    arch.close()

escritura.close()