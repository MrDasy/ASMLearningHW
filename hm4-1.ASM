;HM4 多文件汇编-输入输出年月日

EXTRN CALSUM:FAR
EXTRN PRINTRES:FAR

CODE SEGMENT
             ASSUME CS:CODE
    BEGIN:   
             CALL   FAR PTR CALSUM
             CALL   FAR PTR PRINTRES
             MOV    AH,4CH
             INT    21H
CODE ENDS
END BEGIN