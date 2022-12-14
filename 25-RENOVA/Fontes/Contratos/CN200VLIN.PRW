#Include "PROTHEUS.ch"
User Function CN200VLIN()

Local aAlias	:= GetArea()
Local aCNBAlias	:= GetArea('CNB')
Local _lRet   	:= .T.
Local nPosCmp   := aScan(aHeader,{|x| AllTrim(x[2])=="CNB_NUMSC"}) // pego posi??o do campo no aHeader para depois buscar essa posi??o no array
Local cTpCtr := CN1->CN1_ESPCTR // 1-Compra  2-Venda
//Inclu?do Ronaldo Bicudo - 27/11/2015
Local _nPosCON := aScan(aHeader,{|x| ALlTrim(x[2]) == "CNB_CONTA"} )
Local _nPosIMC := aScan(aHeader,{|x| ALlTrim(x[2]) == "CNB_XIMCUR"} )
Local _nPosPIC := aScan(aHeader,{|x| ALlTrim(x[2]) == "CNB_XPROJI"} )

If	aCols[ n,(Len(aHeader)+1) ] // Se for deletado
	RestArea( aCNBAlias )
	RestArea( aAlias )
	Return (_lRet)
EndIf
//Final da Inclus?o



// Valida SC apenas se for contrato de compra
if cTpCtr = '1'
	//Exige SC na inclus?o da planilha do contrato
	If Empty(aCols[n,nPosCmp])
		Alert("Favor informar o numero da SC para a Planilha !!!")
		_lRet:= .F.
	EndIf
Endif

//Inclu?do Ronaldo Bicudo - 27/11/2015
If SUBSTR( aCols[1,_nPosCON],1,7 ) = '1232103' .AND. Alltrim(aCols[1,_nPosIMC]) = 'N'
	MsgInfo("A conta contabil iniciada em "+Substr( aCols[1,_nPosCON],1,7 )+" ? de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a S-SIM!")
	_lRet := .F.
EndIf

If Substr( aCols[1,_nPosCON],1,7 ) = '1232103' .AND. Empty(aCols[n,_nPosPIC])
	MsgInfo("A conta contabil iniciada em "+Substr( aCols[1,_nPosCON],1,7 )+" ? de Imobilizado em Cursos. Campo Cod. Proj. C. N?o pode ser em branco! Por favor, escolha o codigo do projeto de imobilizado em curso.")
	_lRet := .F.
EndIf

If SUBSTR( aCols[1,_nPosCON],1,7 ) <> '1232103' .AND. Alltrim(aCols[1,_nPosIMC]) = 'S'
	MsgInfo("A conta contabil iniciada em "+Substr( aCols[1,_nPosCON],1,7 )+" N?o ? de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a N-N?O!")
	_lRet := .F.
EndIf

If Substr( aCols[1,_nPosCON],1,7 ) <> '1232103' .AND. !Empty(aCols[n,_nPosPIC])
	MsgInfo("A conta contabil iniciada em "+Substr( aCols[1,_nPosCON],1,7 )+" N?o ? de Imobilizado em Cursos. Campo Cod. Proj. C. deve ser deixado em branco!")
	_lRet := .F.
EndIf
//Final da Inclus?o

Return _lRet
