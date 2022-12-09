#INCLUDE 'PROTHEUS.CH'                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMt100lOk  บAutor  ณ                				16/10/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para validar utilzia็ใo de campo Codigo de บฑฑ
ฑฑ           ณImobilziado em Curso                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT100LOK()

Local _lRet     := .T.   
Local aAlias	:= GetArea()
Local aSD1Alias	:= GetArea('SD1')  
Local aSF4Alias := GetArea('SF4')
Local _lExecuta := ParamIxb[1]

If _lExecuta

	_nPosCON := aScan(aHeader,{|x| ALlTrim(x[2]) == "D1_CONTA"})
	_nPosIMC := aScan(aHeader,{|x| ALlTrim(x[2]) == "D1_XIMCURS"})
	_nPosPIC := aScan(aHeader,{|x| ALlTrim(x[2]) == "D1_XPROJIM"})    
	_nPosTES := aScan(aHeader,{|x| ALlTrim(x[2]) == "D1_TES"})    
	
	If	aCols[ n,(Len(aHeader)+1) ] // Se for deletado
    	RestArea( aSD1Alias )
		RestArea( aAlias )
		Return (_lRet) 
	EndIf
    
	If SUBSTR( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'N'
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" ษ de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a S-SIM!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. Empty(aCols[n,_nPosPIC])
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" ษ de Imobilizado em Cursos. Campo Cod. Proj. C. Nใo pode ser em branco! Por favor, escolha o codigo do projeto de imobilizado em curso.")
		_lRet := .F.
	EndIf
    
	If SUBSTR( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. Alltrim(aCols[n,_nPosIMC]) = 'S'
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" Nใo ้ de Imobilizado em Cursos. Campo Proj. Curso? Deve ser igual a N-NรO!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) <> '1232103' .AND. !Empty(aCols[n,_nPosPIC])
		MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" Nใo ้ de Imobilizado em Cursos. Campo Cod. Proj. C. deve ser deixado em branco!")
		_lRet := .F.
	EndIf

	If Substr( aCols[n,_nPosCON],1,7 ) = '1232103' .AND. !Empty(aCols[n,_nPosTES])

		_cTesAtf := Posicione("SF4",1,xFilial("SF4")+aCols[n,_nPosTES],"F4_ATUATF")
	  	
	  	If Alltrim(_cTesAtf) = 'N'
			MsgInfo("A conta contabil iniciada em "+Substr( aCols[n,_nPosCON],1,7 )+" ษ de Imobilizado em Cursos. A TES que deve ser utilizada ้ de atualiza Ativo Fixo igual S-SIM!")
			_lRet := .F.	  		
	  	EndIf	  
	         
	EndIf
	
EndIf

RestArea( aSF4Alias )
RestArea( aSD1Alias )
RestArea( aAlias )

Return(_lRet)