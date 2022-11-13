;声明为远端函数 计算和
PUBLIC CALSUM

CODE SEGMENT
           ASSUME CS:CODE
    ;累加和
CALSUM PROC
           MOV    AX,0000H
           MOV    CX,100
    L1:    ADD    AX,CX
           LOOP   L1
           RETF
CALSUM ENDP
CODE ENDS
END