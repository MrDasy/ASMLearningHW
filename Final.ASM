;期末作业 贪吃蛇
DATA SEGMENT
    FOODX   DB 00H                 ;食物行
    FOODY   DB 00H                 ;食物列
    SDIREC  DW 0                   ;蛇的方向
    SBODY   DW 400 DUP(0)          ;存放蛇身体的位置
    SLEN    DW 0                   ;蛇长度

    CHEAD   DB 0a0H                ;头颜色
    CBODY   DB 020H                ;身体颜色
    CFOOD   DB 0e0H                ;食物颜色
    CBORDER DB 070H                ;边框颜色

    PSTR    DB 'Game Over!','$'
DATA ENDS

STACK SEGMENT
          DW 128 DUP(0)
STACK ENDS

; 清屏宏 利用重置显示模式清屏
CLS MACRO
         MOV AX, 3H
         INT 10H
ENDM

CODE SEGMENT
             ASSUME CS:CODE,DS:DATA,SS:STACK
    BEGIN:   
             MOV    AX, DATA
             MOV    DS, AX
             MOV    AX, 0B800H
             MOV    ES, AX
                
             CALL   GSNAKE
    
             MOV    AX, 4D00H                   ;右方向键
             MOV    SDIREC, AX                  ;初始化方向为右

             CLS
             CALL   PBORDER                     ;画出边框
             CALL   PSNAKE                      ;画出整条蛇
             CALL   GFOOD                       ;生成食物
             
    ;主游戏循环
    GL:      CALL   UDBODY
             MOV    CX, 0FH
    TL1:     PUSH   CX
             MOV    CX, 0FFFH
    TL2:     CALL   GINPUT
             LOOP   TL2
             POP    CX
             LOOP   TL1
             JMP    GL

    GAMEOVER:CLS
             CALL   PRTOVER
             MOV    AH, 4CH
             INT    21H
PRTOVER PROC
             MOV    SI,OFFSET PSTR
             MOV    DI,2100
             MOV    AH,0cH                      ;高位存颜色
             MOV    AL,0
    FL:      MOV    AL,[SI]
             CMP    AL,'$'
             JE     FED                         ;当符号为$表示字符结尾时结束输出循环
             MOV    ES:[DI],AX
             ADD    DI,2
             INC    SI
             JMP    FL
    FED:     RET
PRTOVER ENDP
    ; 更新身体
UDBODY PROC
             MOV    DI, SI
             SUB    DI, 2
             MOV    BX, [DI]                    ;蛇头位置

             MOV    AX, SDIREC                  ;当前面朝方向
             CMP    AX, 4800H
             JE     UDUP
             CMP    AX, 5000H
             JE     UDDOWN
             CMP    AX, 4B00H
             JE     UDLEFT
             CMP    AX, 4D00H
             JE     UDRIGHT
    UDUP:    SUB    BH, 1
             JMP    CKBODY
    UDDOWN:  ADD    BH, 1
             JMP    CKBODY
    UDLEFT:  SUB    BL, 1
             JMP    CKBODY
    UDRIGHT: ADD    BL, 1
    CKBODY:  CMP    BH, 0                       ;判断蛇头是否碰到地图边界
             JE     GAMEOVER
             CMP    BH, 20
             JE     GAMEOVER
             CMP    BL, 0
             JE     GAMEOVER
             CMP    BL, 20
             JE     GAMEOVER
    ;判断蛇头是否碰到蛇身
             MOV    CX, SI
             SUB    CX, 6
             MOV    DI, OFFSET SBODY
    CMPB:    MOV    AX, [DI]
             CMP    AX, BX
             JE     GAMEOVER
             ADD    DI, 2
             SUB    CX, 1
             LOOP   CMPB
    ;判断蛇头是否吃到食物
             MOV    AH, FOODX
             MOV    AL, FOODY
             PUSH   BX
             CMP    AX, BX
             JE     ABODY

             MOV    DI, OFFSET SBODY
             
             MOV    BX, [DI]
             MOV    DH, 0                       ;隐去蛇尾
             CALL   PCHR
             MOV    CX, SI
             SUB    CX, 6
    SMV:     MOV    DX, [DI+2]
             MOV    [DI], DX
             ADD    DI, 2
             SUB    CX, 1
             LOOP   SMV
             JMP    PSNKE

    ABODY:   ADD    SI,2
             CALL   GFOOD

    PSNKE:   POP    BX
             MOV    DL, ' '                     ;字符
             MOV    [SI-2], BX
             MOV    DH, CHEAD                   ;颜色
             CALL   PCHR
             MOV    DH, CBODY                   ;颜色
             MOV    BX, [SI-4]
             CALL   PCHR
             RET
UDBODY ENDP
    ;初始化蛇
GSNAKE PROC
             MOV    SI, OFFSET SBODY
             MOV    AX, 0A04H                   ;中心点
             MOV    SLEN,4                      ;初始蛇长度
             MOV    CX,SLEN
    GSL:     MOV    [SI], AX
             ADD    SI, 2
             INC    AL
             LOOP   GSL

             RET
GSNAKE ENDP

    ;获取键盘输入
GINPUT PROC
             MOV    AH, 1
             INT    16H                         ;接收键盘
             CMP    AH, 1
             JE     IED
             MOV    AH, 0                       ;16中断获取缓冲区按键
             INT    16H
    ;判断输入是否为方向键
             CMP    AX, 4800H                   ;上方向键
             JE     IFX
             CMP    AX, 5000H                   ;下方向键
             JE     IFX
             CMP    AX, 4B00H                   ;左方向键
             JE     IFX
             CMP    AX, 4D00H                   ;右方向键
             JE     IFX
             JMP    IED
    IFX:     MOV    SDIREC, AX                  ;更改方向标志
    IED:     RET                                ;返回

GINPUT ENDP

    ;打印蛇
PSNAKE PROC
             MOV    CX, SI
             SUB    CX, 6
             MOV    DI, OFFSET SBODY
    PSL:     MOV    DL, ' '                     ;字符
             MOV    DH, CBODY                   ;颜色
             MOV    BX,[DI]
             CALL   PCHR
             ADD    DI, 2
             SUB    CX, 1
             LOOP   PSL
                    
             MOV    DH, CHEAD
             MOV    BX,[DI]
             CALL   PCHR
             RET

PSNAKE ENDP

    ; 输出边框
PBORDER PROC
             MOV    DL, ' '                     ;字符
             MOV    DH, 71H                     ;颜色
                    
             MOV    BX, 0                       ;打印横条
             MOV    CX, 20
    PROW:    CALL   PCHR                        ;上边界
             PUSH   BX
             ADD    BH, 20
             CALL   PCHR                        ;下边界
             POP    BX
             INC    BL                          ;列加1
             LOOP   PROW

             MOV    BX, 0                       ;打印竖条
             MOV    CX, 21
    PCOL:    CALL   PCHR                        ;左边界
             PUSH   BX
             ADD    BL, 20
             CALL   PCHR                        ;右边界
             POP    BX
             INC    BH                          ;行加1
             LOOP   PCOL
                    
             RET
PBORDER ENDP
    ;在指定位置输出字符
    ;BH行 BL列 DH颜色 DL字符
PCHR PROC
             PUSH   BX                          ;计算偏移量
             MOV    AL, 80
             MUL    BH                          ;行乘80
             MOV    BH, 0
             SHL    BL,1                        ;列乘2
             ADD    AX, BX                      ;加上列即为偏移量
             POP    BX

             PUSH   SI                          ;填充到显存
             MOV    SI, AX
             SHL    SI, 1                       ;每次打印两个字符
             MOV    ES:[SI], DL
             MOV    ES:[SI+2], DL
             MOV    ES:[SI+1], DH
             MOV    ES:[SI+3], DH
             POP    SI
             RET
PCHR ENDP
    ;生成食物
GFOOD PROC                                      ;生成食物
             CALL   GFOODPOS
             MOV    DL, ' '
             MOV    DH, CFOOD
             MOV    BH, FOODX
             MOV    BL, FOODY
             CALL   PCHR
             RET
GFOOD ENDP
    ;生成食物位置
GFOODPOS PROC
    RFG:     
             CALL   RAND
             MOV    FOODX, AL
             CALL   RAND
             MOV    FOODY, AL
             MOV    CX, SI
             SUB    CX, 4
             MOV    DI, OFFSET SBODY
             MOV    BP, OFFSET FOODX
    FDCPL:   MOV    AX, [DI]                    ;校验生成位置是否与蛇身体重合
             CMP    AX, [BP]
             JE     RFG                         ;重新生成
             ADD    DI, 2
             SUB    CX, 1
             LOOP   FDCPL

             RET
GFOODPOS ENDP

    ;随机数 范围1~19
RAND PROC
             PUSH   CX
             PUSH   DX
             MOV    AH,2CH                      ;使用21中断的2C功能 获取时间 白分秒在DL 秒在DH
             INT    21H
             MOV    AX,DX
             MOV    DX,0
             MOV    CX, 18
             DIV    CX
             MOV    AX,DX
             INC    AX
             POP    DX
             POP    CX
             RET
RAND ENDP

CODE ENDS
END BEGIN