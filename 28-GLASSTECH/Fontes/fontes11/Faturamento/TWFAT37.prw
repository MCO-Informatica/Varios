#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "COLORS.CH"

User Function TWFAT37()
	Local cTpoper  := ''
	Local cChvCli  := M->CJ_CLIENTE + M->CJ_LOJA
	Local cGrpTri  := POSICIONE('SA1',1,xFilial('SA1') + cChvCli ,'A1_GRPTRIB')
	Local cTes     := TMP1->CK_TES

	If Altera
		SFM->(dbOrderNickName('TPOPER'))
		If SFM->(DbSeek(xFilial('SFM') + cTes + cGrpTri))
			cTpoper := SFM->FM_TIPO
			TMP1->CK_OPER := SFM->FM_TIPO
		EndIf
	Else
		If "CK_OPER"$ReadVar()
			cTpoper := M->CK_OPER
		Else
			cTpoper := TMP1->CK_OPER
		EndIF
	EndIf

	Return cTpoper
