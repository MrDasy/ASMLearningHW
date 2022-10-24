;hm2 九九乘法表

DATA SEGMENT
      RES  DB 00H,'*',00H,'=', 2 DUP(0),' ','$'      ;结果
      NL   DB 0DH,0AH,'$'                            ;换行
DATA ENDS

STACK SEGMENT
            DB 20 DUP(0)
STACK ENDS

CODE SEGMENT
            ASSUME CS:CODE,DS:DATA,SS:STACK

      BEGIN:MOV    AX,DATA
            MOV    DS,AX
            
      ;外层循环 每行
            MOV    CX,0009H
            MOV    BH,01H
      L1:   MOV    BL,01H                        ;BH存右数 BL存左数
      ;内层循环 每项
      L2:   MOV    AL,BH
            MUL    BL                            ;此时AX为乘法结果
      ;乘法结果转数字字符
            MOV    DL,0AH
            DIV    DL
            ADD    AX,3030H
            MOV    RES[4],AL
            MOV    RES[5],AH
      ;乘法左数右数转数字字符
            MOV    DX,BX
            ADD    DX,3030H
            MOV    RES[0],DL
            MOV    RES[2],DH
      ;输出单项
            MOV    DX,OFFSET RES
            MOV    AH,09H
            INT    21H
      ;判断是否跳出本层循环
            INC    BL
            CMP    BH,BL
            JB     CTN
            JMP    L2
      ;跳出本层循环
      CTN:  MOV    DX,OFFSET NL
            MOV    AH,09H
            INT    21H
            INC    BH
            LOOP   L1
      ;结束程序
            MOV    AH,4CH
            INT    21H
CODE ENDS
END BEGIN