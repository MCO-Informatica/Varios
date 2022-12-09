#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuscaCEP  �Autor  �Anderson Zanni      � Data �  04/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca endere�o baseado no CEP digitado. Caso o CEP tenha   ���
���          � mais de um logradouro, apresenta listbox para escolha.     ���
�������������������������������������������������������������������������͹��
���Uso       �Version 2.0                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CEPTLV(_cCep)      

Local oDlgCEP
Local _cCep    	:= &(ReadVar())
Local _cAreaCEP	:= GetArea()
Local _nPos    	:= 1
Local _cVar    	:= ReadVar()
Local _nTamCEP 	:= Len(AllTrim(_cCep))
Local _aCEP    	:= {}
Local _aRET    	:= {}
Local lChoice	:= .f. 

_cQuery 	:= "Select PA7_CODCEP, PA7_LOGRA, PA7_BAIRRO, PA7_MUNIC, PA7_ESTADO, PA7_CODMUN, PA7_CODUF, PA7_CODPAI From "+RetSqlName('PA7')
_cQuery 	+= "	Where D_E_L_E_T_ = ' ' And"
_cQuery 	+= "	      SUBSTR(PA7_CODCEP,1,"+AllTrim(Str(_nTamCEP))+") = '"+_cCep+"'"      

If select("TMPCEP") > 0
	TMPCEP->(DbCloseArea())				
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TMPCEP",.F.,.T.)					

TMPCEP->(DbEval({||	aAdd(_aCEP, TMPCEP->(PA7_CODCEP+' - '+AllTrim(PA7_LOGRA) + ' - '+AllTrim(PA7_BAIRRO)+ ' - '+AllTrim(PA7_MUNIC)+ ' - '+AllTrim(PA7_ESTADO))),;
   					aAdd(_aRet, TMPCEP->({PA7_CODCEP, PA7_LOGRA, PA7_BAIRRO, PA7_MUNIC, PA7_ESTADO, PA7_CODMUN, PA7_CODUF, PA7_CODPAI})) }))

TMPCEP->(DbCloseArea())

If Len(_aCep) == 0
   Aviso('Erro no campo CEP','CEP Nao encontrado na base de dados',{'Ok'})
   RestArea(_cAreaCEP)
   Return .f.
EndIf

lChoice := iif(Len(_aCEP) > 1 .or. _nTamCEP < 8, .t., .f.) 

If lChoice
	lChoice := !IsBlind()
Endif

If lChoice
	lChoice := !SubStr( FunName(), 1, 3) == "GAR"
Endif

If lChoice
	oDlgCEP:= MSDIALOG():Create()
	oDlgCEP:cName := "oDlgCEP"
	oDlgCEP:cCaption := "Busca por CEP"
	oDlgCEP:nLeft := 0
	oDlgCEP:nTop := 0
	oDlgCEP:nWidth := 733
	oDlgCEP:nHeight := 282
	oDlgCEP:lShowHint := .F.
	oDlgCEP:lCentered := .T.
	
	oLbCEP := TSAY():Create(oDlgCEP)
	oLbCEP:cCaption := "O CEP digitado possui mais de um logradouro."
	oLbCEP:nLeft := 6
	oLbCEP:nTop := 8
	oLbCEP:nWidth := 344
	oLbCEP:nHeight := 17
	
	oListCEP := TLISTBOX():Create(oDlgCEP)
	oListCEP:nLeft := 4
	oListCEP:nTop := 29
	oListCEP:nWidth := 716
	oListCEP:nHeight := 185
	oListCEP:nAt := 0
	oListCEP:aItems := _aCEP
	oListCEP:cVariable := '_nPos'
	oListCEP:bSetGet := {|u| If(PCount()>0,_npos:=u,_npos) }
	
	oOk := SBUTTON():Create(oDlgCEP)
	oOk:cName := "oOk"
	oOk:cCaption := "Seleciona"
	oOk:nLeft := 660
	oOk:nTop := 227
	oOk:nWidth := 56
	oOk:nHeight := 22
	oOk:nType := 1            
	oOk:bAction := {|| Fecha(@oDlgCEP) }
    
	oDlgCEP:Activate()
	
Else
   _nPos := 1
Endif    
   
If 'CEPC' $ _cVar
   M->UA_CEPC     := _aRet[_nPos, 1]
   M->UA_ENDCOB   := _aRet[_nPos, 2]
   M->UA_BAIRROC  := _aRet[_nPos, 3]
   M->UA_MUNC     := _aRet[_nPos, 4]
   M->UA_ESTC     := _aRet[_nPos, 5]
ElseIf 'CEPE' $ _cVar 
   M->UA_CEPE     := _aRet[_nPos, 1]
   M->UA_ENDENT   := _aRet[_nPos, 2]
   M->UA_BAIRROE  := _aRet[_nPos, 3]
   M->UA_MUNE     := _aRet[_nPos, 4]
   M->UA_ESTE     := _aRet[_nPos, 5]
Else
   M->UA_CEP     := _aRet[_nPos, 1]
   M->UA_END   	 := _aRet[_nPos, 2]
   M->UA_BAIRRO  := _aRet[_nPos, 3]
   M->UA_MUN     := _aRet[_nPos, 4]
   M->UA_EST     := _aRet[_nPos, 5]
EndIf

RestArea(_cAreaCEP)

Return(.T.)


Static Function Fecha(oDlgCEP)
oDlgCEP:End()
Return(.T.)
