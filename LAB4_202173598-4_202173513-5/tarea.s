.data

func: .word 3	@ funcion a ejecutar
@ n y k función 2
valorn: .word 12
valork: .word 6
@ cantidad de numeros y numeros función 3
len_nums: .word 6
nums: .word 2,2,2,2,2,2
@ strings función 1
str1: .asciz "lala"
str2: .asciz "lala"

.text

main:	ldr r0, =func
	ldr r0, [r0]  @ Se carga tipo de función que se ejecuta
	cmp r0, #1	@ r0 - 1
	beq func1	@ func = 1
	cmp r0, #2
	beq func2	@ func = 2
	cmp r0, #3	
	beq func3	@ func = 3

@ FUNCION 1

func1:	ldr r0, =str1	@ r0 = string 1
	mov r1,#0
	
strlen1:ldrb r2, [r0, r1]      
	add r1, r1, #1         
	cmp r2, #0              
	bne strlen1           
	sub r1, r1, #1         

	ldr r2, =str2	
	mov r3, #0     

strlen2:ldrb r4, [r2, r3]    
	add r3, r3, #1         
	cmp r4, #0             
	bne strlen2            
	sub r3, r3, #1          

	cmp r1,r3
	bne noanan	
	mov r5, #0
	
loop1:	cmp r5,r1
	beq verif
	ldrb r4, [r0, r5]
	mov r6, #0
	
loop2:	cmp r6,r1
	beq aux
	ldrb r7, [r2, r6]
	cmp r4,r7
	beq eliminar
	add r6, #1
	b loop2

aux:	add r5,#1
	b loop1

eliminar:mov r3, #0
	strb r3, [r2,r6]
	add r6, #1
	add r5, #1
	b loop1	

@ ver si quedan palabras en el segundo string
verif:	mov r5, #0

loop3:	cmp r5, r1
	beq sianan
	ldrb r4, [r2, r5]
	cmp r4, #0
	bne noanan
	add r5, r5, #1
	b loop3

sianan:	mov r2, #1	
	mov r0, #0
	mov r1, #0
	bl printInt	  
    	b end

noanan:	mov r2, #0	
	mov r0, #0
	mov r1, #0
	bl printInt	  
    	b end

@ FUNCION 2

func2:  ldr r0, =valorn	
    	ldr r0, [r0]  @ valor de n
    	ldr r1, =valork
    	ldr r1, [r1]  @ valor de k
    	bl recursive
	mov r2, r0	
	mov r0, #0
	mov r1, #0
	bl printInt	  
    	b end

recursive:
 	push {r4-r7, lr}           
   	mov r4, r0              
  	mov r5, r1                
   	cmp r5, r4                
   	bgt zero        
   	beq uno          
   	cmp r5, #0                
    	beq uno          

    	sub r4, r4, #1          
    	mov r0, r4                 
    	mov r1, r5                 
    	bl recursive              
    	mov r6, r0                 

    	sub r5, r5, #1         
    	mov r0, r4             
    	mov r1, r5                 
    	bl recursive                
    	mov r7, r0                 

    	add r0, r6, r7              
    	pop {r4-r7, pc}             

zero:   mov r0, #0                
    	pop {r4-r7, pc}             

uno:   	mov r0, #1                
    	pop {r4-r7, pc}            

@ FUNCION 3

func3:	ldr r0, =nums
	ldr r1, =len_nums
	ldr r1, [r1]
	mov r2, #0
	mov r3, #0
	ldr r7, =0x200700C0
	
loop4:	cmp r2,r1
	beq print
	ldr r4, [r0]
	add r0, #4
	b espar

espar:	mov r5, #1
	and r5, r4, r5
	cmp r5, #0
	beq agregar
	add r2, #1
	b loop4	

agregar:str r4, [r7]
	add r7, #4
	add r2, #1
	add r3, #1
	b loop4

print: 	mov r8, r3
	mov r2, r3
	mov r0, #0
	mov r1, #0
	bl printInt
	ldr r5, =0x200700C0
	mov r4, #0
	mov r1, #1	@fila
	mov r0, #0	@columna

ciclo:	cmp r4,r8
	beq end
	ldr r2, [r5]
	add r5, #4	@suma a la direccion 4		
	push {r0, r1}
	bl printInt	@ printear
	pop {r0,r1}
	add r4, #1	@ aumenta 1 al contador
	add r1, #1	@ aumenta 1 la fila
	cmp r1, #6
	beq sumar
	b ciclo

sumar:	add r0, #3
	mov r1, #0
	b ciclo

end:	wfi
	
.end
