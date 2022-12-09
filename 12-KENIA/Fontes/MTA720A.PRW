#INCLUDE "RWMAKE.CH"

User Function MTA720A()

Local _aArea	:=	GetArea()
Local _aAreaSC2

dbSelectArea("SC2")
_aAreaSC2	:=	GetArea()
dbSetOrder(1)
If dbSeek(xFilial("SC2")+TRB->NUMOP,.F.)
	_cNF_TERC	:=	SC2->C2_NF_TERC
	_cPV_TERC	:=	SC2->C2_PV_TERC
	_cTERCEI	:=	SC2->C2_TERCEI
	_cURDUME	:=	SC2->C2_URDUME
	_cLOTURTM	:=	SC2->C2_LOTURTM
	_cTRAMA		:=	SC2->C2_TRAMA
	_cLOTTRAM	:=	SC2->C2_LOTTRAM
	_cCOR		:=	SC2->C2_COR
	_cTEAR		:=	SC2->C2_TEAR
	_cPECAS_1	:=	SC2->C2_PECAS_1
	_nQUANT_1	:=	SC2->C2_QUANT_1
	_cPECAS_2	:=	SC2->C2_PECAS_2
	_nQUANT_2	:=	SC2->C2_QUANT_2
	_cPECAS_3	:=	SC2->C2_PECAS_3
	_nQUANT_3	:=	SC2->C2_QUANT_3	
	_cPECAS_4	:=	SC2->C2_PECAS_4
	_nQUANT_4	:=	SC2->C2_QUANT_4	
	_cPECAS_5	:=	SC2->C2_PECAS_5
	_nQUANT_5	:=	SC2->C2_QUANT_5	
	_cPECAS_6	:=	SC2->C2_PECAS_6
	_nQUANT_6	:=	SC2->C2_QUANT_6	
	_cPECAS_7	:=	SC2->C2_PECAS_7
	_nQUANT_7	:=	SC2->C2_QUANT_7	
	_cPECAS_8	:=	SC2->C2_PECAS_8
	_nQUANT_8	:=	SC2->C2_QUANT_8	
	_cPECAS_9	:=	SC2->C2_PECAS_9
	_nQUANT_9	:=	SC2->C2_QUANT_9	
	_cPECAS_A	:=	SC2->C2_PECAS_A
	_nQUANT_A	:=	SC2->C2_QUANT_A	
	_cPECAS_B	:=	SC2->C2_PECAS_B
	_nQUANT_B	:=	SC2->C2_QUANT_B	
	_cPECAS_C	:=	SC2->C2_PECAS_C
	_nQUANT_C	:=	SC2->C2_QUANT_C	
	_cPECAS_D	:=	SC2->C2_PECAS_D
	_nQUANT_D	:=	SC2->C2_QUANT_D	
	_cPECAS_E	:=	SC2->C2_PECAS_E
	_nQUANT_E	:=	SC2->C2_QUANT_E	
	_cPECAS_F	:=	SC2->C2_PECAS_F
	_nQUANT_F	:=	SC2->C2_QUANT_F	
	_cPECAS_G	:=	SC2->C2_PECAS_G
	_nQUANT_G	:=	SC2->C2_QUANT_G
	_cCP_TERC	:=	SC2->C2_CP_TERC	
	_nPR_TERC	:=	SC2->C2_PR_TERC
	_cOBS		:=	SC2->C2_OBS
EndIf

RestArea(_aAreaSC2)
                   
Replace SC2->C2_NF_AGLU 	With Iif(EMPTY(Alltrim(SC2->C2_NF_AGLU)),_cNF_TERC,Alltrim(SC2->C2_NF_AGLU)+"/"+_cNF_TERC)
Replace SC2->C2_PV_AGLU 	With Iif(EMPTY(Alltrim(SC2->C2_PV_AGLU)),_cPV_TERC,Alltrim(SC2->C2_PV_AGLU)+"/"+_cPV_TERC)
Replace SC2->C2_TERCEI 		With _cTERCEI
Replace SC2->C2_URDUME 		With _cURDUME
Replace SC2->C2_LOTURTM 	With _cLOTURTM
Replace SC2->C2_TRAMA 		With _cTRAMA
Replace SC2->C2_LOTTRAM 	With _cLOTTRAM
Replace SC2->C2_COR 		With _cCOR
Replace SC2->C2_TEAR 		With _cTEAR
Replace SC2->C2_CP_TERC 	With _cCP_TERC
Replace SC2->C2_PR_TERC 	With _nPR_TERC
Replace SC2->C2_OBS			With _cOBS

If empty(SC2->C2_PECAS_1)
	Replace SC2->C2_PECAS_1 	With _cPECAS_1
	Replace SC2->C2_QUANT_1 	With _nQUANT_1
	Replace SC2->C2_PECAS_2 	With _cPECAS_2
	Replace SC2->C2_QUANT_2 	With _nQUANT_2
	Replace SC2->C2_PECAS_3 	With _cPECAS_3
	Replace SC2->C2_QUANT_3 	With _nQUANT_3
	Replace SC2->C2_PECAS_4 	With _cPECAS_4
	Replace SC2->C2_QUANT_4 	With _nQUANT_4
	Replace SC2->C2_PECAS_5 	With _cPECAS_5
	Replace SC2->C2_QUANT_5 	With _nQUANT_5
	Replace SC2->C2_PECAS_6 	With _cPECAS_6
	Replace SC2->C2_QUANT_6 	With _nQUANT_6
	Replace SC2->C2_PECAS_7 	With _cPECAS_7
	Replace SC2->C2_QUANT_7 	With _nQUANT_7
	Replace SC2->C2_PECAS_8 	With _cPECAS_8
	Replace SC2->C2_QUANT_8 	With _nQUANT_8
	Replace SC2->C2_PECAS_9 	With _cPECAS_9
	Replace SC2->C2_QUANT_9 	With _nQUANT_9
	Replace SC2->C2_PECAS_A 	With _cPECAS_A
	Replace SC2->C2_QUANT_A 	With _nQUANT_A
	Replace SC2->C2_PECAS_B 	With _cPECAS_B
	Replace SC2->C2_QUANT_B 	With _nQUANT_B
	Replace SC2->C2_PECAS_C 	With _cPECAS_C
	Replace SC2->C2_QUANT_C 	With _nQUANT_C
	Replace SC2->C2_PECAS_D 	With _cPECAS_D
	Replace SC2->C2_QUANT_D 	With _nQUANT_D
	Replace SC2->C2_PECAS_E 	With _cPECAS_E
	Replace SC2->C2_QUANT_E 	With _nQUANT_E
	Replace SC2->C2_PECAS_F 	With _cPECAS_F
	Replace SC2->C2_QUANT_F 	With _nQUANT_F
	Replace SC2->C2_PECAS_G 	With _cPECAS_G
	Replace SC2->C2_QUANT_G 	With _nQUANT_G
ElseIf empty(SC2->C2_PECAS_2)
	Replace SC2->C2_PECAS_2 	With _cPECAS_1
	Replace SC2->C2_QUANT_2 	With _nQUANT_1
	Replace SC2->C2_PECAS_3 	With _cPECAS_2
	Replace SC2->C2_QUANT_3 	With _nQUANT_2
	Replace SC2->C2_PECAS_4 	With _cPECAS_3
	Replace SC2->C2_QUANT_4 	With _nQUANT_3
	Replace SC2->C2_PECAS_5 	With _cPECAS_4
	Replace SC2->C2_QUANT_5 	With _nQUANT_4
	Replace SC2->C2_PECAS_6 	With _cPECAS_5
	Replace SC2->C2_QUANT_6 	With _nQUANT_5
	Replace SC2->C2_PECAS_7 	With _cPECAS_6
	Replace SC2->C2_QUANT_7 	With _nQUANT_6
	Replace SC2->C2_PECAS_8 	With _cPECAS_7
	Replace SC2->C2_QUANT_8 	With _nQUANT_7
	Replace SC2->C2_PECAS_9 	With _cPECAS_8
	Replace SC2->C2_QUANT_9 	With _nQUANT_8
	Replace SC2->C2_PECAS_A 	With _cPECAS_9
	Replace SC2->C2_QUANT_A 	With _nQUANT_9
	Replace SC2->C2_PECAS_B 	With _cPECAS_A
	Replace SC2->C2_QUANT_B 	With _nQUANT_A
	Replace SC2->C2_PECAS_C 	With _cPECAS_B
	Replace SC2->C2_QUANT_C 	With _nQUANT_B
	Replace SC2->C2_PECAS_D 	With _cPECAS_C
	Replace SC2->C2_QUANT_D 	With _nQUANT_C
	Replace SC2->C2_PECAS_E 	With _cPECAS_D
	Replace SC2->C2_QUANT_E 	With _nQUANT_D
	Replace SC2->C2_PECAS_F 	With _cPECAS_E
	Replace SC2->C2_QUANT_F 	With _nQUANT_E
	Replace SC2->C2_PECAS_G 	With _cPECAS_F
	Replace SC2->C2_QUANT_G 	With _nQUANT_F
ElseIf empty(SC2->C2_PECAS_3)
	Replace SC2->C2_PECAS_3 	With _cPECAS_1
	Replace SC2->C2_QUANT_3 	With _nQUANT_1
	Replace SC2->C2_PECAS_4 	With _cPECAS_2
	Replace SC2->C2_QUANT_4 	With _nQUANT_2
	Replace SC2->C2_PECAS_5 	With _cPECAS_3
	Replace SC2->C2_QUANT_5 	With _nQUANT_3
	Replace SC2->C2_PECAS_6 	With _cPECAS_4
	Replace SC2->C2_QUANT_6 	With _nQUANT_4
	Replace SC2->C2_PECAS_7 	With _cPECAS_5
	Replace SC2->C2_QUANT_7 	With _nQUANT_5
	Replace SC2->C2_PECAS_8 	With _cPECAS_6
	Replace SC2->C2_QUANT_8 	With _nQUANT_6
	Replace SC2->C2_PECAS_9 	With _cPECAS_7
	Replace SC2->C2_QUANT_9 	With _nQUANT_7
	Replace SC2->C2_PECAS_A 	With _cPECAS_8
	Replace SC2->C2_QUANT_A 	With _nQUANT_8
	Replace SC2->C2_PECAS_B 	With _cPECAS_9
	Replace SC2->C2_QUANT_B 	With _nQUANT_9
	Replace SC2->C2_PECAS_C 	With _cPECAS_A
	Replace SC2->C2_QUANT_C 	With _nQUANT_A
	Replace SC2->C2_PECAS_D 	With _cPECAS_B
	Replace SC2->C2_QUANT_D 	With _nQUANT_B
	Replace SC2->C2_PECAS_E 	With _cPECAS_C
	Replace SC2->C2_QUANT_E 	With _nQUANT_C
	Replace SC2->C2_PECAS_F 	With _cPECAS_D
	Replace SC2->C2_QUANT_F 	With _nQUANT_D
	Replace SC2->C2_PECAS_G 	With _cPECAS_E
	Replace SC2->C2_QUANT_G 	With _nQUANT_E
ElseIf empty(SC2->C2_PECAS_4)
	Replace SC2->C2_PECAS_4 	With _cPECAS_1
	Replace SC2->C2_QUANT_4 	With _nQUANT_1
	Replace SC2->C2_PECAS_5 	With _cPECAS_2
	Replace SC2->C2_QUANT_5 	With _nQUANT_2
	Replace SC2->C2_PECAS_6 	With _cPECAS_3
	Replace SC2->C2_QUANT_6 	With _nQUANT_3
	Replace SC2->C2_PECAS_7 	With _cPECAS_4
	Replace SC2->C2_QUANT_7 	With _nQUANT_4
	Replace SC2->C2_PECAS_8 	With _cPECAS_5
	Replace SC2->C2_QUANT_8 	With _nQUANT_5
	Replace SC2->C2_PECAS_9 	With _cPECAS_6
	Replace SC2->C2_QUANT_9 	With _nQUANT_6
	Replace SC2->C2_PECAS_A 	With _cPECAS_7
	Replace SC2->C2_QUANT_A 	With _nQUANT_7
	Replace SC2->C2_PECAS_B 	With _cPECAS_8
	Replace SC2->C2_QUANT_B 	With _nQUANT_8
	Replace SC2->C2_PECAS_C 	With _cPECAS_9
	Replace SC2->C2_QUANT_C 	With _nQUANT_9
	Replace SC2->C2_PECAS_D 	With _cPECAS_A
	Replace SC2->C2_QUANT_D 	With _nQUANT_A
	Replace SC2->C2_PECAS_E 	With _cPECAS_B
	Replace SC2->C2_QUANT_E 	With _nQUANT_B
	Replace SC2->C2_PECAS_F 	With _cPECAS_C
	Replace SC2->C2_QUANT_F 	With _nQUANT_C
	Replace SC2->C2_PECAS_G 	With _cPECAS_D
	Replace SC2->C2_QUANT_G 	With _nQUANT_D
ElseIf empty(SC2->C2_PECAS_5)
	Replace SC2->C2_PECAS_5 	With _cPECAS_1
	Replace SC2->C2_QUANT_5 	With _nQUANT_1
	Replace SC2->C2_PECAS_6 	With _cPECAS_2
	Replace SC2->C2_QUANT_6 	With _nQUANT_2
	Replace SC2->C2_PECAS_7 	With _cPECAS_3
	Replace SC2->C2_QUANT_7 	With _nQUANT_3
	Replace SC2->C2_PECAS_8 	With _cPECAS_4
	Replace SC2->C2_QUANT_8 	With _nQUANT_4
	Replace SC2->C2_PECAS_9 	With _cPECAS_5
	Replace SC2->C2_QUANT_9 	With _nQUANT_5
	Replace SC2->C2_PECAS_A 	With _cPECAS_6
	Replace SC2->C2_QUANT_A 	With _nQUANT_6
	Replace SC2->C2_PECAS_B 	With _cPECAS_7
	Replace SC2->C2_QUANT_B 	With _nQUANT_7
	Replace SC2->C2_PECAS_C 	With _cPECAS_8
	Replace SC2->C2_QUANT_C 	With _nQUANT_8
	Replace SC2->C2_PECAS_D 	With _cPECAS_9
	Replace SC2->C2_QUANT_D 	With _nQUANT_9
	Replace SC2->C2_PECAS_E 	With _cPECAS_A
	Replace SC2->C2_QUANT_E 	With _nQUANT_A
	Replace SC2->C2_PECAS_F 	With _cPECAS_B
	Replace SC2->C2_QUANT_F 	With _nQUANT_B
	Replace SC2->C2_PECAS_G 	With _cPECAS_C
	Replace SC2->C2_QUANT_G 	With _nQUANT_C
ElseIf empty(SC2->C2_PECAS_6)
	Replace SC2->C2_PECAS_6 	With _cPECAS_1
	Replace SC2->C2_QUANT_6 	With _nQUANT_1
	Replace SC2->C2_PECAS_7 	With _cPECAS_2
	Replace SC2->C2_QUANT_7 	With _nQUANT_2
	Replace SC2->C2_PECAS_8 	With _cPECAS_3
	Replace SC2->C2_QUANT_8 	With _nQUANT_3
	Replace SC2->C2_PECAS_9 	With _cPECAS_4
	Replace SC2->C2_QUANT_9 	With _nQUANT_4
	Replace SC2->C2_PECAS_A 	With _cPECAS_5
	Replace SC2->C2_QUANT_A 	With _nQUANT_5
	Replace SC2->C2_PECAS_B 	With _cPECAS_6
	Replace SC2->C2_QUANT_B 	With _nQUANT_6
	Replace SC2->C2_PECAS_C 	With _cPECAS_7
	Replace SC2->C2_QUANT_C 	With _nQUANT_7
	Replace SC2->C2_PECAS_D 	With _cPECAS_8
	Replace SC2->C2_QUANT_D 	With _nQUANT_8
	Replace SC2->C2_PECAS_E 	With _cPECAS_9
	Replace SC2->C2_QUANT_E 	With _nQUANT_9
	Replace SC2->C2_PECAS_F 	With _cPECAS_A
	Replace SC2->C2_QUANT_F 	With _nQUANT_A
	Replace SC2->C2_PECAS_G 	With _cPECAS_B
	Replace SC2->C2_QUANT_G 	With _nQUANT_B
ElseIf empty(SC2->C2_PECAS_7)
	Replace SC2->C2_PECAS_7 	With _cPECAS_1
	Replace SC2->C2_QUANT_7 	With _nQUANT_1
	Replace SC2->C2_PECAS_8 	With _cPECAS_2
	Replace SC2->C2_QUANT_8 	With _nQUANT_2
	Replace SC2->C2_PECAS_9 	With _cPECAS_3
	Replace SC2->C2_QUANT_9 	With _nQUANT_3
	Replace SC2->C2_PECAS_A 	With _cPECAS_4
	Replace SC2->C2_QUANT_A 	With _nQUANT_4
	Replace SC2->C2_PECAS_B 	With _cPECAS_5
	Replace SC2->C2_QUANT_B 	With _nQUANT_5
	Replace SC2->C2_PECAS_C 	With _cPECAS_6
	Replace SC2->C2_QUANT_C 	With _nQUANT_6
	Replace SC2->C2_PECAS_D 	With _cPECAS_7
	Replace SC2->C2_QUANT_D 	With _nQUANT_7
	Replace SC2->C2_PECAS_E 	With _cPECAS_8
	Replace SC2->C2_QUANT_E 	With _nQUANT_8
	Replace SC2->C2_PECAS_F 	With _cPECAS_9
	Replace SC2->C2_QUANT_F 	With _nQUANT_9
	Replace SC2->C2_PECAS_G 	With _cPECAS_A
	Replace SC2->C2_QUANT_G 	With _nQUANT_A
ElseIf empty(SC2->C2_PECAS_8)
	Replace SC2->C2_PECAS_8 	With _cPECAS_1
	Replace SC2->C2_QUANT_8 	With _nQUANT_1
	Replace SC2->C2_PECAS_9 	With _cPECAS_2
	Replace SC2->C2_QUANT_9 	With _nQUANT_2
	Replace SC2->C2_PECAS_A 	With _cPECAS_3
	Replace SC2->C2_QUANT_A 	With _nQUANT_3
	Replace SC2->C2_PECAS_B 	With _cPECAS_4
	Replace SC2->C2_QUANT_B 	With _nQUANT_4
	Replace SC2->C2_PECAS_C 	With _cPECAS_5
	Replace SC2->C2_QUANT_C 	With _nQUANT_5
	Replace SC2->C2_PECAS_D 	With _cPECAS_6
	Replace SC2->C2_QUANT_D 	With _nQUANT_6
	Replace SC2->C2_PECAS_E 	With _cPECAS_7
	Replace SC2->C2_QUANT_E 	With _nQUANT_7
	Replace SC2->C2_PECAS_F 	With _cPECAS_8
	Replace SC2->C2_QUANT_F 	With _nQUANT_8
	Replace SC2->C2_PECAS_G 	With _cPECAS_9
	Replace SC2->C2_QUANT_G 	With _nQUANT_9
ElseIf empty(SC2->C2_PECAS_9)
	Replace SC2->C2_PECAS_9 	With _cPECAS_1
	Replace SC2->C2_QUANT_9 	With _nQUANT_1
	Replace SC2->C2_PECAS_A 	With _cPECAS_2
	Replace SC2->C2_QUANT_A 	With _nQUANT_2 
	Replace SC2->C2_PECAS_B 	With _cPECAS_3
	Replace SC2->C2_QUANT_B 	With _nQUANT_3
	Replace SC2->C2_PECAS_C 	With _cPECAS_4
	Replace SC2->C2_QUANT_C 	With _nQUANT_4
	Replace SC2->C2_PECAS_D 	With _cPECAS_5
	Replace SC2->C2_QUANT_D 	With _nQUANT_5
	Replace SC2->C2_PECAS_E 	With _cPECAS_6
	Replace SC2->C2_QUANT_E 	With _nQUANT_6
	Replace SC2->C2_PECAS_F 	With _cPECAS_7
	Replace SC2->C2_QUANT_F 	With _nQUANT_7
	Replace SC2->C2_PECAS_G 	With _cPECAS_8
	Replace SC2->C2_QUANT_G 	With _nQUANT_8
ElseIf empty(SC2->C2_PECAS_A)
	Replace SC2->C2_PECAS_A 	With _cPECAS_1
	Replace SC2->C2_QUANT_A 	With _nQUANT_1 
	Replace SC2->C2_PECAS_B 	With _cPECAS_2
	Replace SC2->C2_QUANT_B 	With _nQUANT_2
	Replace SC2->C2_PECAS_C 	With _cPECAS_3
	Replace SC2->C2_QUANT_C 	With _nQUANT_3
	Replace SC2->C2_PECAS_D 	With _cPECAS_4
	Replace SC2->C2_QUANT_D 	With _nQUANT_4
	Replace SC2->C2_PECAS_E 	With _cPECAS_5
	Replace SC2->C2_QUANT_E 	With _nQUANT_5
	Replace SC2->C2_PECAS_F 	With _cPECAS_6
	Replace SC2->C2_QUANT_F 	With _nQUANT_6
	Replace SC2->C2_PECAS_G 	With _cPECAS_7
	Replace SC2->C2_QUANT_G 	With _nQUANT_7
ElseIf empty(SC2->C2_PECAS_B)
	Replace SC2->C2_PECAS_B 	With _cPECAS_1
	Replace SC2->C2_QUANT_B 	With _nQUANT_1
	Replace SC2->C2_PECAS_C 	With _cPECAS_2
	Replace SC2->C2_QUANT_C 	With _nQUANT_2
	Replace SC2->C2_PECAS_D 	With _cPECAS_3
	Replace SC2->C2_QUANT_D 	With _nQUANT_3
	Replace SC2->C2_PECAS_E 	With _cPECAS_4
	Replace SC2->C2_QUANT_E 	With _nQUANT_4
	Replace SC2->C2_PECAS_F 	With _cPECAS_5
	Replace SC2->C2_QUANT_F 	With _nQUANT_5
	Replace SC2->C2_PECAS_G 	With _cPECAS_6
	Replace SC2->C2_QUANT_G 	With _nQUANT_6
ElseIf empty(SC2->C2_PECAS_C)
	Replace SC2->C2_PECAS_C 	With _cPECAS_1
	Replace SC2->C2_QUANT_C 	With _nQUANT_1
	Replace SC2->C2_PECAS_D 	With _cPECAS_2
	Replace SC2->C2_QUANT_D 	With _nQUANT_2
	Replace SC2->C2_PECAS_E 	With _cPECAS_3
	Replace SC2->C2_QUANT_E 	With _nQUANT_3
	Replace SC2->C2_PECAS_F 	With _cPECAS_4
	Replace SC2->C2_QUANT_F 	With _nQUANT_4
	Replace SC2->C2_PECAS_G 	With _cPECAS_5
	Replace SC2->C2_QUANT_G 	With _nQUANT_5
ElseIf empty(SC2->C2_PECAS_D)
	Replace SC2->C2_PECAS_D 	With _cPECAS_1
	Replace SC2->C2_QUANT_D 	With _nQUANT_1
	Replace SC2->C2_PECAS_E 	With _cPECAS_2
	Replace SC2->C2_QUANT_E 	With _nQUANT_2
	Replace SC2->C2_PECAS_F 	With _cPECAS_3
	Replace SC2->C2_QUANT_F 	With _nQUANT_3
	Replace SC2->C2_PECAS_G 	With _cPECAS_4
	Replace SC2->C2_QUANT_G 	With _nQUANT_4
ElseIf empty(SC2->C2_PECAS_E)
	Replace SC2->C2_PECAS_E 	With _cPECAS_1
	Replace SC2->C2_QUANT_E 	With _nQUANT_1
	Replace SC2->C2_PECAS_F 	With _cPECAS_2
	Replace SC2->C2_QUANT_F 	With _nQUANT_2
	Replace SC2->C2_PECAS_G 	With _cPECAS_3
	Replace SC2->C2_QUANT_G 	With _nQUANT_3
ElseIf empty(SC2->C2_PECAS_F)
	Replace SC2->C2_PECAS_F 	With _cPECAS_1
	Replace SC2->C2_QUANT_F 	With _nQUANT_1
	Replace SC2->C2_PECAS_G 	With _cPECAS_2
	Replace SC2->C2_QUANT_G 	With _nQUANT_2
ElseIf empty(SC2->C2_PECAS_G)
	Replace SC2->C2_PECAS_G 	With _cPECAS_1
	Replace SC2->C2_QUANT_G 	With _nQUANT_1
EndIf

Return