#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAF010LOK  บAutor  ณ                				25/05/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para validar utilzia็ใo de campo Codigo de บฑฑ
ฑฑ           ณImobilziado em Curso                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AF010LOK()

Local _lRet     := .T.
Local _cTipo    := ''
Local aAlias	:= GetArea()
Local aSN1Alias	:= GetArea('SN1')
Local aSN3Alias := GetArea('SN3')
Local aSN2Alias := GetArea('SN2')

_nPosPIC := Ascan(aHeader,{|x| ALlTrim(x[2]) == "N3_XPROJIM"} )
_nPosTIP := Ascan(aHeader,{|x| ALlTrim(x[2]) == "N3_TIPO"} )

If	aCols[ n,(Len(aHeader)+1) ] // Se for deletado
	RestArea( aSD1Alias )
	RestArea( aAlias )
	Return (_lRet)
EndIf

If !Empty(aCols[n,_nPosPIC]) .AND. aCols[n,_nPosTIP] <> "03"
	DbSelectArea("SX5")
	DbSetOrder(1)
	If MsSeek(xFilial("SX5")+"G1"+aCols[n,_nPosTIP])
		_cTipo := SX5->X5_DESCRI
	EndIf
	
	If !Empty(_cTipo)
		MsgInfo("Este bem ้ um Imobilizado em Curso, seu tipo de classifica็ใo deve ser '03-Imob. em Curso' e estแ tentando classificar como: "+aCols[n,_nPosTIP]+" - "+_cTipo+"!!!")
		_lRet := .F.
	Else
		MsgInfo("Este bem ้ um Imobilizado em Curso, seu tipo de classifica็ใo deve ser '03-Imob. em Curso'!")
		_lRet := .F.
	EndIf
	
EndIf
 
//Adicionado condi็ใo dia 19/06/2015
If Empty(aCols[n,_nPosPIC]) .AND. aCols[n,_nPosTIP] = "03"
	DbSelectArea("SX5")
	DbSetOrder(1)
	If MsSeek(xFilial("SX5")+"G1"+aCols[n,_nPosTIP])
		_cTipo := SX5->X5_DESCRI
	EndIf
	
	If !Empty(_cTipo)
		MsgInfo("Este bem nใo ้ Imobilizado em Curso, seu tipo de classifica็ใo deve ser '01-Fiscal' ou outro tipo e estแ tentando classificar como: "+aCols[n,_nPosTIP]+" - "+_cTipo+"!!!")
		_lRet := .F.
	Else
		MsgInfo("Este bem nใo ้ Imobilizado em Curso, seu tipo de classifica็ใo deve ser '01-Fiscal' ou outro tipo!")
		_lRet := .F.
	EndIf
	
EndIf
//Final da Adi็ใo

RestArea( aSN2Alias )
RestArea( aSN3Alias )
RestArea( aSN1Alias )
RestArea( aAlias )

Return(_lRet)