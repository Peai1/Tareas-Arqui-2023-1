Nombres:
Felipe León 202173598-4 Paralelo 201
Daniel Ligeti 202173513-5 Paralelo 200

Para esta tarea, creamos las siguientes funciones para las siguientes finalidades
1) Identificar error en representacion de base
2) Convertir de decimal a binario
3) Convertir un numero en cierta base a decimal
4) Funcion para identificar si hay overflow en suma a C2

Recorrimos el archivo identificando las bases y numeros de cada fila.
Separamos en cada caso de que el usuario ingrese la base e ingrese un 0.
Si hay error en representacion de base, aumenta el error en 1, pero si no hay, entonces se convierten los numeros a binario
para identificar si existe el error de total numeros que no pueden ser representados con el valor ingresado por el usuario,
para luego realizar la extension de signo, y esto se realizada para cada numero de la fila.
Luego, si no hay ningun error (flag == False en el codigo), se verifica si hay overflow para la suma en C2 y asi se aumentan los
correspondientes errores que existan para luego ir escribiendolos en el archivo "resultados.txt" y tambien hay contador para 
saber el total de numeros en el archivo.