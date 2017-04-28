; multi-segment executable file template.

data segment
; add your data here!

CIRCULO: 
DW 0000000000000000B;
DW 0001111111111000B;
DW 0010000000000100B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0100000000000010B;
DW 0010000000000100B;
DW 0001111111111000B;
DW 0000000000000000B;
DW "$"

XIS: 
DW 0000000000000000B;
DW 0100000000000010B;
DW 0010000000000100B;
DW 0001000000001000B;
DW 0000100000010000B;
DW 0000010000100000B;
DW 0000001001000000B;
DW 0000000110000000B;
DW 0000000110000000B;
DW 0000001001000000B;
DW 0000010000100000B;
DW 0000100000010000B;
DW 0001000000001000B;
DW 0010000000000100B;
DW 0100000000000010B;
DW 0000000000000000B;

ends

stack segment
dw 128 dup(0)
ends

code segment
start:
    ; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    ; add your code here
    
    MOV AH,0 ;SETA MODO VIDEO
    MOV AL,0DH ;320x200
    INT 10H ;CHAMA BIOS - PLACA VIDEO
    
    MOV SI,0A000H
    MOV ES,SI ; AGORA ES APONTA PARA O SEGMENTO DE VIDEO MODO GRAFICO
    
    MOV AH,1
    MOV AL,1
    LEA SI,CIRCULO 
    CALL WRITE_CHARACTER
    
    ;wait for any key....
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h

WRITE_CHARACTER: ; escreve um caracter na linha e coluna apontada. AH = coluna, AL = linha
    PUSH AX
    MOV BL, 8 ; altura da linha
    MUL BL 
    MOV BL, 40 ;quantidade de offsets que uma linha tem
    MUL BL           
    ; linha * 8 * 40 = offset da linha
    
    ; AX = AL * BL
    
    MOV DI,AX ; DI apontara para o offset do display grafico
    POP AX ; recupera a coluna
    MOV AL,0 ; a coluna esta em AH entao eh necessario zerar o AL.....
    XCHG AH,AL ; para inverter e obter o valor de AH em AX  
    
    ADD DI, AX ; soma a coluna passada. Cada offset eh uma coluna
    
write: ; desenha o caracter no segmento grafico
    MOV AX, [SI] ; SI contem qual o offset inicial do caracter a ser desenhado
    CMP AX, "$"
    JE sai
    XCHG AH,AL
    MOV ES:[DI], AX
    ADD DI, 40
    ADD SI, 2
    JMP write
sai:

RET



ends

end start ; set entry point and stop the assembler.