#INCLUDE "PROTHEUS.CH"

user function MT110TEL      
Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local nOpcx      := PARAMIXB[3]
Local nReg       := PARAMIXB[4]

Public cGrp		:= Iif(Inclui, Space(TamSx3("C1_GRPPROD")[1]), SC1->C1_GRPPROD)

//Preenche o código do comprador.
cCodCompr 		:= Iif(Inclui, Space(TamSx3("C1_CODCOMP")[1]), SC1->C1_CODCOMP)   

aadd(aPosGet[1],0) 
aadd(aPosGet[1],0)

//Posição do label
aPosGet[1,6] += 30

aPosGet[1,7]:= aPosGet[1,4]+60

//Posição do Get
aPosGet[1,8]:= aPosGet[1,7]+20

@ 50, aPosGet[1,7] SAY 'Grupo'	PIXEL SIZE 60,	09 Of oNewDialog
@ 48, aPosGet[1,8] MSGET cGrp	PIXEL SIZE 30,	09 Of oNewDialog F3 "SBM" VALID !Vazio() .AND. U_TWFUN01A()    

RETURN 
