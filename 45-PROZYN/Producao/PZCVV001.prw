#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVV001		บAutor  ณMicrosiga	     บ Data ณ  16/01/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo da restri็ใo de armazens em movimentos internos   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVV001(cLocal)

Local aArea 	:= GetArea()
Local cArmzRest	:= U_MyNewSX6("CV_RESTLOC", "00|92"	,"C","Restri็ใo do armazem para movimentos internos", "", "", .F. )
Local cUserAut	:= U_MyNewSX6("CV_UAUTLOC", ""	,"C","Usuแrios autorizados a utilizar os armazens", "", "", .F. )
Local cRotRest	:= U_MyNewSX6("CV_ROTRLOC", "MATA240|MATA241"	,"C","Rotinas restritas na utiliza็ใo do armaz้m", "", "", .F. )
Local lRet		:= .T.	
Local cCodUser  := Alltrim(RetCodUsr()) 

Default cLocal := ""

If (FunName() $ Alltrim(cRotRest)) .And. Alltrim(cLocal) $ Alltrim(cArmzRest) .And. !(Alltrim(cCodUser) $ Alltrim(cUserAut))
	Aviso("Aten็ใo-PZCVV001","Usuแrio nใo autorizado a utilizar o armaz้m: "+Alltrim(cLocal),{"Ok"},2)
	lRet	:= .F.
EndIf

RestArea(aArea)	
Return lRet