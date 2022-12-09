#include 'protheus.ch'
#include 'parmtype.ch'

/*
+-------------+----------+--------+---------------------------------+-------+-------------+
| Programa:   | AjuPerg  | Autor: | Rubens Cruz - Anadi	     	    | Data: | Junho/2017 |
+-------------+----------+--------+---------------------------------+-------+-------------+
| Descrição:  | Funcao para verificar se as perguntas existem na SX1 e, caso não exista	  |
| 			  | grava na SX1														      |
+-------------+---------------------------------------------------------------------------+
| Uso:        | Luft							                                          |
+-------------+------------------------------------+--------------------------------------+
*/

User Function AjuPerg(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
						cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
						cF3, cGrpSxg,cPyme,;
						cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
						cDef02,cDefSpa2,cDefEng2,;
						cDef03,cDefSpa3,cDefEng3,;
						cDef04,cDefSpa4,cDefEng4,;
						cDef05,cDefSpa5,cDefEng5,;
						aHelpPor,aHelpEng,aHelpSpa,cHelp)
						
Local aArea := GetArea()
Local cPerg, cKey

Default cPerSpa := ""
Default cPerEng := ""
Default cVar 	:= ""
Default nPresel := 0
Default cValid 	:= ""
Default cF3		:= ""
Default cGrpSxg := ""
Default cPyme 	:= ""
Default cDef01 	:= ""
Default cDefSpa1:= ""
Default cDefEng1:= ""
Default cCnt01	:= ""
Default cDef02	:= ""
Default cDefSpa2:= ""
Default cDefEng2:= ""
Default cDef03	:= ""
Default cDefSpa3:= ""
Default cDefEng3:= ""
Default cDef04	:= ""
Default cDefSpa4:= ""
Default cDefEng4:= ""
Default cDef05	:= ""
Default cDefSpa5:= ""
Default cDefEng5:= ""

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(Alltrim(cGrupo),Len(SX1->X1_GRUPO))
cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

If !DbSeek( cPerg + cOrdem )
	RecLock("SX1",.T.)
		SX1->X1_GRUPO		:= cGrupo
		SX1->X1_ORDEM		:= cOrdem
		SX1->X1_PERGUNT		:= cPergunt
		SX1->X1_PERSPA		:= cPerSpa
		SX1->X1_PERENG		:= cPerEng
		SX1->X1_VARIAVL 	:= cVar
		SX1->X1_TIPO		:= cTipo
		SX1->X1_TAMANHO 	:= nTamanho
		SX1->X1_DECIMAL 	:= nDecimal
		SX1->X1_PRESEL  	:= nPresel
		SX1->X1_GSC     	:= cGSC
		SX1->X1_VALID   	:= cValid
		SX1->X1_VAR01   	:= cVar01
		SX1->X1_F3      	:= cF3
		SX1->X1_GRPSXG  	:= cGrpSxg
		SX1->X1_PYME		:= cPyme
		SX1->X1_CNT01     	:= cCnt01
		SX1->X1_DEF01      	:= cDef01
		SX1->X1_DEFSPA1    	:= cDefSpa1
		SX1->X1_DEFENG1    	:= cDefEng1
		SX1->X1_DEF02   	:= cDef02
		SX1->X1_DEFSPA2 	:= cDefSpa2
		SX1->X1_DEFENG2 	:= cDefEng2
		SX1->X1_DEF03   	:= cDef03
		SX1->X1_DEFSPA3 	:= cDefSpa3
		SX1->X1_DEFENG3 	:= cDefEng3
		SX1->X1_DEF04   	:= cDef04
		SX1->X1_DEFSPA4 	:= cDefSpa4
		SX1->X1_DEFENG4 	:= cDefEng4
		SX1->X1_DEF05   	:= cDef05
		SX1->X1_DEFSPA5 	:= cDefSpa5
		SX1->X1_DEFENG5 	:= cDefEng5
		SX1->X1_HELP		:= cHelp
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	SX1->( MsUnlock() )

EndIf

RestArea(aArea)
	
Return

Static Function PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdate,cStatus)
Local cFilePor := "SIGAHLP.HLP"
Local cFileEng := "SIGAHLE.HLE"
Local cFileSpa := "SIGAHLS.HLS"
Local nRet
Local nT
Local nI
Local cLast
Local cNewMemo
Local cAlterPath := ''
Local nPos	

If ( ExistBlock('HLPALTERPATH') )
	cAlterPath := Upper(AllTrim(ExecBlock('HLPALTERPATH', .F., .F.)))
	If ( ValType(cAlterPath) != 'C' )
        cAlterPath := ''
	ElseIf ( (nPos:=Rat('\', cAlterPath)) == 1 )
		cAlterPath += '\'
	ElseIf ( nPos == 0	)
		cAlterPath := '\' + cAlterPath + '\'
	EndIf
	
	cFilePor := cAlterPath + cFilePor
	cFileEng := cAlterPath + cFileEng
	cFileSpa := cAlterPath + cFileSpa
	
EndIf

Default aHelpPor := {}
Default aHelpEng := {}
Default aHelpSpa := {}
Default lUpdate  := .T.
Default cStatus  := ""

If Empty(cKey)
	Return
EndIf

If !(cStatus $ "USER|MODIFIED|TEMPLATE")
	cStatus := NIL
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpPor)

For nI:= 1 to nT
   cLast := Padr(aHelpPor[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFilePor, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFilePor, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFilePor, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpEng)

For nI:= 1 to nT
   cLast := Padr(aHelpEng[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileEng, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileEng, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileEng, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpSpa)

For nI:= 1 to nT
   cLast := Padr(aHelpSpa[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileSpa, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileSpa, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileSpa, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

Return


