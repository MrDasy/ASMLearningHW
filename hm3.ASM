;HM3 过程调用-输入输出年月日

DATA SEGMENT
    IPP     DW 0000H                                      ;IP
    NL      DB 0DH,0AH,'$'                                ;换行符
    OUTPRPT DB ' Result:'                                 ;不留终止符 直接输出结果
    OUTPUT  DB 2 DUP(0),'-',2 DUP(0),'-', 2 DUP(0),'$'    ;输出结果
    OUTOFF  DB 3,4,6,7,0,1                                ;输入输出转换偏移量
    PRPT    DB ' Enter the date (MM/DD/YY):','$'          ;输入提示
DATA ENDS

STACK SEGMENT
          DB 20 DUP(0)
STACK ENDS

CODE SEGMENT
            ASSUME CS:CODE,DS:DATA,SS:STACK

    BEGIN:  MOV    AX,DATA
            MOV    DS,AX
    ;输出提示信息
            MOV    DX,OFFSET PRPT
            MOV    AH,9H
            INT    21H

    ;获取输入日期
            MOV    CX,6H
    L1:     CALL   GETC
            POP    AX
            MOV    BX,6H
            SUB    BX,CX
            MOV    BL,OUTOFF[BX]               ;获取偏移量
            MOV    BH,0
            MOV    OUTPUT[BX],AL               ;写结果
            LOOP   L1
    ;结束输入循环，输出结果
            CALL   PRINTNL
            MOV    AH,09H
            MOV    DX,OFFSET OUTPRPT
            INT    21H
            CALL   PRINTNL

            MOV    AH,4CH                      ;结束程序
            INT    21H

    ;输入数字 过程
GETC PROC
            POP    IPP                         ;主函数地址
    INPUT:  MOV    AH,01H                      ;输入字符
            INT    21H
            CMP    AL,'0'                      ;验证输入合法
            JB     INPUT
            CMP    AL,'9'
            JA     INPUT
            PUSH   AX
            PUSH   IPP
            RET
GETC ENDP
    ;打印换行符 过程
PRINTNL PROC
            MOV    AH,09H
            MOV    DX,OFFSET NL
            INT    21H
            RET
PRINTNL ENDP

CODE ENDS
END BEGIN