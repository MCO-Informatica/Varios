#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

User Function RCRMR003()               

Local _aSavArea		:= GetArea()
Local _aSavSCJ		:= SZL->(GetArea())
Private _cRotina	:= "RCRMR003"
Private cPerg		:= _cRotina    
Private oFont1		:= TFont():New("Arial",,040,,.T.,,,,,.F. ) //Tํtulo at้ 11 caracteres
Private oFont2		:= TFont():New("Arial",,014,,.F.,,,,,.F. ) //Tํtulo at้ 11 caracteres(endere็o)
Private oFont3		:= TFont():New("Arial",,014,,.T.,,,,,.F. ) //Tํtulo at้ 11 caracteres(endere็o)
Private oFont4		:= TFont():New("Arial",,020,,.F.,,,,,.F. ) //Sub-tํtulo
Private oFont5		:= TFont():New("Arial",,024,,.T.,,,,,.F. ) //Descritivo (Negrito)
Private oFont6		:= TFont():New("Arial",,024,,.T.,,,,,.F. ) //Descritivo (Comum)
Private oFont7		:= TFont():New("Arial",,046,,.T.,,,,,.F. ) //Tํtulo acima de 14 caracteres
Private oPrinter                                                                   

/*
ValidPerg() //Chamada da fun็ใo para inclusใo dos parโmetros da rotina

While !Pergunte(cPerg,.T.)
	If MsgYesNo("Deseja cancelar a emissใo do relat๓rio?",_cRotina+"_01")
		Return()
	EndIf
EndDo
*/
Processa({ |lEnd| CallPDF(@lEnd) },_cRotina,"Gerando relat๓rio... Por favor aguarde!",.T.)

Return()

Static Function CallPDF()

Local nXi		:= 0
Local _cFile	:= _cRotina
Local _nTipoImp	:= IMP_PDF
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1
Local _nLin := 20

Private oPrinter	
If oPrinter == Nil
	lPreview := .T.
	oPrinter := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
//	oPrinter:Setup()  //Abre tela para defini็ใo da impressora
	oPrinter:SetLandScape()
	oPrinter:SetPaperSize(9)
//    oPrinter:cPrinter := "Argox X-2300E series PPLZ"
EndIf
//	If !oPrinter:IsFirstPage
//		oPrinter:EndPage()
//	EndIf

//_cData   := Dtos(M->ZL_DATA)
//_cGere   := M->ZL_VEND
//_cCodCli := M->ZL_CODCLI
//_cCodLoj := M->ZL_LOJA

_cCliente := Alltrim(Posicione("SA1",1,xFilial("SA1") + SZL->ZL_CODCLI + SZL->ZL_LOJA ,"A1_NREDUZ"))
         
oPrinter:StartPage()

//DbSelectArea("SZL")
//DbSetOrder(2)             
//If Dbseek(xFilial("SZL") + _cData + _cGere + _cOpor)//filial + data + gerente + oportunidade

oPrinter:SayAlign(_nLin, 0000, ("CALL REPORT " + _cCliente)						,oFont4, 0800,0060,,2,1)
_nLin += 20                                         

//oPrinter:SayAlign(_nLin, 0000, ALLTRIM(SZL->ZL_DESCRI)  						,oFont3, 0800,0060,,2,1)
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Data:")							,oFont3, 0800,0060,,3,1) 
_nLin += 20
oPrinter:SayAlign(_nLin, 0015, Dtoc(SZL->ZL_DATA)	 					,oFont2, 0800,0060,,3,1) 
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Participantes:")					,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_PART,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_PART,140,nXi),oFont2)
	_nLin += 10
Next nXi
_nLin += 10

oPrinter:SayAlign(_nLin, 0010, RTrim("Status:")							,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_STATUS,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_STATUS,140,nXi),oFont2)
	_nLin += 10
Next nXi
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Maiores Oportunidades na conta:")	,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_OPORT,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_OPORT,140,nXi),oFont2)
	_nLin += 10
Next nXi
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Objetivos:")						,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_OBJETI,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_OBJETI,140,nXi),oFont2)
	_nLin += 10
Next nXi
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Resultados:")						,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_RESULT,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_RESULT,140,nXi),oFont2)
	_nLin += 10
Next nXi
_nLin += 20

oPrinter:SayAlign(_nLin, 0010, RTrim("Pr๓ximos Passos:")				,oFont3, 0800,0060,,3,1) 
_nLin += 30
For nXi := 1 To MLCount(SZL->ZL_PASSOS,140)
	oPrinter:Say(_nLin,0015,MemoLine(SZL->ZL_PASSOS,140,nXi),oFont2)
	_nLin += 10
Next nXi

//EndIf

oPrinter:EndPage() 

	If lPreview
		oPrinter:Preview()
	EndIf
FreeObj(oPrinter)
oPrinter := Nil

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ ValidPerg   บ Autor ณ Derik Santos     บ Data ณ 26/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo responsแvel pela inclusใo dos parโmetros da rotina. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn                			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
/*
Static Function ValidPerg()

Local _sAlias	:= GetArea()
Local aRegs		:= {}
Local j
Local i
cPerg			:= PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","Data:"			,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Gerente:"		,"","","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SZL","","","",""})
AADD(aRegs,{cPerg,"03","Oportunidade:"	,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SZL","","","",""})


For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next

RestArea(_sAlias)

Return()
*/