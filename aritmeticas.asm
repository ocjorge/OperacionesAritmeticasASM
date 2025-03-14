section .data
    num1 db 12                  
    num2 db 5                   
    msg_sum db 'Suma: ', 0
    msg_sub db 'Resta: ', 0
    msg_mul db 'Multiplicación: ', 0
    msg_div db 'División: Cociente= ', 0
    msg_res db ' Residuo= ', 0
    newline db 10, 0            

section .bss
    buffer resb 16               
    resultado resb 1             
    residuo resb 1               

section .text
    global _start

_start:
    ; ------------------------
    ; Suma
    ; ------------------------
    xor rax, rax                 
    mov al, [num1]       
    add al, [num2]         
    mov byte [resultado], al         

    mov rsi, msg_sum             
    call PrintString             
    movzx rax, byte [resultado]  
    call PrintResult             
    call PrintNewline            

    ; ------------------------
    ; Resta
    ; ------------------------
    xor rax, rax                 
    mov al, [num1]       
    sub al, [num2]         
    mov byte [resultado], al         

    mov rsi, msg_sub             
    call PrintString             
    movzx rax, byte [resultado]  
    call PrintResult             
    call PrintNewline            

    ; ------------------------
    ; Multiplicación
    ; ------------------------
    xor rax, rax                 
    xor rdx, rdx                 
    mov al, [num1]       
    mov bl, [num2]       
    mul bl                      ; Multiplica AL * BL, resultado en AX
    mov byte [resultado], al         

    mov rsi, msg_mul             
    call PrintString             
    movzx rax, byte [resultado]  
    call PrintResult             
    call PrintNewline            

    ; ------------------------
    ; División (cociente y residuo)
    ; ------------------------
    xor rax, rax                 
    mov al, [num1]       
    cbw                          ; Convierte AL a AX (Extiende signo)
    div byte [num2]              ; AX / num2 -> Cociente en AL, Residuo en AH

    mov byte [resultado], al          
    mov byte [residuo], ah            

    ; Imprimir Cociente
    mov rsi, msg_div             
    call PrintString             
    movzx rax, byte [resultado]  
    call PrintResult             
    
    ; Imprimir Residuo
    mov rsi, msg_res             
    call PrintString             
    movzx rax, byte [residuo]    
    call PrintResult             
    call PrintNewline            

    ; ------------------------
    ; Salida del programa
    ; ------------------------
    mov rax, 60                 
    xor rdi, rdi                
    syscall                     

; ------------------------
; Función para imprimir un número en RAX
; ------------------------
PrintResult:
    mov rdi, buffer             
    call IntToString            
    mov rsi, buffer             
    call PrintString            
    ret                         

; ------------------------
; Función para convertir número en RAX a string
; ------------------------
IntToString:
    mov rcx, 0                  
    mov rbx, 10                 
.convert:
    xor rdx, rdx                
    div rbx                     
    add dl, '0'                 
    mov [rdi + rcx], dl         
    inc rcx                     
    test rax, rax               
    jnz .convert                
    mov byte [rdi + rcx], 0     

    ; Invertir la cadena en el buffer
    mov rsi, buffer             
    lea rdi, [buffer + rcx - 1] 
.reverse:
    cmp rsi, rdi                
    jge .done_reverse           
    mov al, [rsi]               
    mov bl, [rdi]               
    mov [rsi], bl               
    mov [rdi], al               
    inc rsi                     
    dec rdi                     
    jmp .reverse                

.done_reverse:
    ret

; ------------------------
; Función para imprimir una cadena en RSI
; ------------------------
PrintString:
    mov rdx, 0                  
.calculate_length:
    cmp byte [rsi + rdx], 0     
    je .print                   
    inc rdx                     
    jmp .calculate_length        
.print:
    mov rax, 1                  
    mov rdi, 1                  
    syscall
    ret

; ------------------------
; Función para imprimir un salto de línea
; ------------------------
PrintNewline:
    mov rax, 1                  
    mov rdi, 1                  
    mov rsi, newline            
    mov rdx, 1                  
    syscall
    ret