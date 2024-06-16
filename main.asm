global _start

section .data
    rqs db "Your name: ", 0
    rspns db "Hey! How is it going on, ", 0
    rspns_end:
    mark db "?", 0x0A

section .bss
    msg resb 129  ; Increase buffer size to accommodate the question mark and null terminator

section .text
    global _start

_start: 
    ; Output the request message
    mov eax, 4               ; sys_write
    mov ebx, 1               ; file descriptor (stdout)
    mov ecx, rqs             ; message to write
    mov edx, 12              ; length of the message "Your name: "
    int 0x80

    ; Get user input
    mov eax, 3               ; sys_read
    mov ebx, 0               ; file descriptor (stdin)
    mov ecx, msg             ; buffer to store the input
    mov edx, 128             ; maximum number of bytes to read
    int 0x80

    ; Store the number of bytes read in edx
    mov esi, eax             ; store the number of bytes read in esi (excluding the null terminator)

    ; Output the response message
    mov eax, 4               ; sys_write
    mov ebx, 1               ; file descriptor (stdout)
    mov ecx, rspns           ; message to write
    mov edx, rspns_end - rspns  ; calculate length of rspns
    int 0x80

    ; Concatenate the question mark to the user's input
    mov eax, esi             ; eax contains the number of bytes read from stdin
    add eax, msg             ; eax points to the end of the input in the buffer
    mov byte [eax], '?'      ; store the question mark at the end
    inc eax                  ; move to the next byte
    mov byte [eax], 0        ; null-terminate the string

    ; Output the user's input with the question mark
    mov eax, 4               ; sys_write
    mov ebx, 1               ; file descriptor (stdout)
    mov ecx, msg             ; buffer to output
    mov edx, esi             ; length of the input string (excluding the null terminator)
    inc edx                  ; include the question mark
    int 0x80

    ; Exit the program
    mov eax, 1               ; sys_exit
    xor ebx, ebx             ; status 0
    int 0x80
