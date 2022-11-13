;声明为远端函数 打印结果 
PUBLIC PRINTRES

DATA SEGMENT
    TEN  DW 000AH          ;10
    PMT  DB 'result='      ;前置提示
    RES  DB 6 DUP(0)       ;存储字符答案 寄存器限制 结果十进制不会超过五位
    NL   DB 0DH,0AH,'$'    ;换行符
DATA ENDS

CODE SEGMENT
             ASSUME CS:CODE,DS:DATA
PRINTRES PROC FAR
             MOV    BX,DATA
             MOV    DS,BX
    ;将结果转为字符并存到RES
             MOV    BX,OFFSET NL
    LR:      DEC    BX
             MOV    DX,0000H
             DIV    TEN
             ADD    DL,30H
             MOV    [BX],DL
             CMP    AX,0000H
             JNZ    LR
    ;输出
             MOV    DX,OFFSET PMT
             MOV    AH,09H
             INT    21H
             RETF
PRINTRES ENDP

CODE ENDS
END