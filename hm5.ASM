;HM5 在指定位置输出文本

DATA SEGMENT
    PROW DB 13                    ;输出行
    PCOL DB 30                   ;输出列
    PCNT DW 00H                   ;输出位置
    PCLR DB 1aH                   ;输出颜色
    PSTR DB 'Hello Tongji','$'    ;输出字符串
DATA ENDS

STACK SEGMENT
          DB 128 DUP(0)
STACK ENDS

CODE SEGMENT
            ASSUME CS:CODE,DS:DATA,SS:STACK

    BEGIN:  MOV    AX,DATA
            MOV    DS,AX

            CALL   VGAINIT                     ;初始化数据并指定参数
            CALL   CALPOS
            CALL   SHOWSTR                     ;显示字符串
            MOV    AH,4CH                      ;结束程序
            INT    21H

    ; 初始化VGA文本模式屏幕
VGAINIT PROC
            MOV    AX,0B800H                   ;文本模式显存起始地址
            MOV    ES,AX
            MOV    CX,2000                     ;一页有2000字符
            MOV    BX,0
    CLSL:   MOV    ES:[BX],0700H
            ADD    BX,2
            LOOP   CLSL
            RET
VGAINIT ENDP

    ;打印字符串
SHOWSTR PROC
            MOV    SI,OFFSET PSTR
            MOV    DI,PCNT
            MOV    AH,PCLR                     ;高位存颜色
            MOV    AL,0
    FL:     MOV    AL,[SI]
            CMP    AL,'$'
            JE     FED                         ;当符号为$表示字符结尾时结束输出循环
            MOV    ES:[DI],AX
            ADD    DI,2
            INC    SI
            JMP    FL
    FED:    RET
SHOWSTR ENDP

    ;计算行列对应一维位置
CALPOS PROC
            MOV    AH,00H
            MOV    AL,PROW
            MOV    BL,160                      ;一行80字符，160字节
            MUL    BL
            MOV    DX,AX

            MOV    AH,00H
            MOV    AL,PCOL
            MOV    BL,2
            MUL    BL
            ADD    DX,AX
            MOV    PCNT,DX
            RET
CALPOS ENDP

CODE ENDS
END BEGIN