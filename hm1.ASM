;hm1 百内累加

DATA SEGMENT
    CNT  DW 99             ;累加目标 可更改为其他数字
    TEN  DW 000AH          ;10

    PMT  DB 'result='      ;前置提示
    RES  DB 6 DUP(0)       ;存储字符答案 寄存器限制 结果十进制不会超过五位
    NL   DB 0DH,0AH,'$'    ;换行符
DATA ENDS

CODE SEGMENT
          ASSUME CS:CODE,DS:DATA

    BEGIN:MOV    AX,DATA
          MOV    DS,AX
    ;赋初值
          MOV    AX,0000H
    ;累加和
          MOV    CX,CNT
    L1:   ADD    AX,CX
          LOOP   L1
    ;将结果转为字符并存到RES
          MOV    BX,OFFSET NL
    LR:   DEC    BX
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
    ;结束程序
          MOV    AH,4CH
          INT    21H
CODE ENDS
END BEGIN