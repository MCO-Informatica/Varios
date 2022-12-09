#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ NBCOM001   บ Autor ณ Denis Varella      Data ณ 09/08/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de 1.	Pedido de compra internacional            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Especํfico para a empresa Prozyn  			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿P฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function NBCOM001()

Private _cRotina	:= "PCompra"
Private oPrn
Private cPerg		:= _cRotina
Private oBrush		:= TBrush():New(,CLR_HGRAY)
Private oFont01N	:= TFont():New( "Arial",,20,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont01		:= TFont():New( "Arial",,20,,.F.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private _nLin		:= 080 //Linha inicial para impressใo
Private _nLinFin	:= 770 //Linha final para impressใo
Private _nEspPad	:= 020 //Espa็amento padrใo entre linhas
Private _cEnter		:= CHR(13) + CHR(10)
Private _nMaxDesc	:= 32
Private _lPreview	:= .T.
Private _nPag       := 0

//Chamada da fun็ใo para gera็ใo do relat๓rio
Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relat๓rio... Por favor aguarde!",.T.)

//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.F.)

Return()
    

Static Function GeraPDF()

Local _cFile	:= _cRotina
Local _nTipoImp	:= IMP_PDF //IMP_SPOOL //
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1
Local _ObsExp   := ""
Local _nLObs    := 0
Local _nFObs    := 0
Local aItens := Array(8, 8)
Local nItem		:= 0

Local aArea := GetArea()
Local _cAliasTmp:= GetNextAlias()

dbSelectArea("SC7")
dbSetOrder(1)

_cArq	:= SC7->C7_NUM


//Montagem da consulta a ser realizada no banco de dados

_cQry := " SELECT A2_NEMPR NOMEFOR,A2_LOGEX ENDERECO,A2_NUMEX NUM,A2_COMPLR COMPLE,A2_BAIEX BAIRRO, A2_ESTEX ESTADO,A2_CIDEX MUNICIPIO,A2_POSEX CEP, "
_cQry += " isnull(YA_DESCR,'') PAIS,C7_CONTATO CONTATO,C7_EMISSAO DATA,A2_DDD DDD,A2_TELRE TEL,A2_FAX FAX, "
_cQry += " A2_EMAIL EMAIL,A2_NIFEX TAX_ID,C7_ITEM ITEM,C7_PRODUTO PRODUTO,C7_DESCRI DESC_PRODUTO, C7_QUANT QUANTIDADE,C7_UM UM,C7_INCOT INCOTERM,C7_DESTFIM DFINAL,C7_DTEMBAR DEMBAR, C7_OBSEMB OBSERV, C7_ACCOD ACCOD, C7_ACLOJA ACLOJA, C7_DESPCOD DESPCOD, C7_LOJADES DESPLOJA, "
_cQry += " C7_INCOT INCOTERM,C7_MOEDA MOEDA,C7_TOTAL TOTAL,C7_OBSEMB PACKING,E4_XDESCRI CONDPAGTO "
_cQry += " FROM " + RetSqlName("SC7") + " C7 "
_cQry += " LEFT JOIN " + RetSqlName("SA2") + "  A2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA"
_cQry += " LEFT JOIN " + RetSqlName("SYA") + " YA ON YA_CODGI = A2_PAIS	 "
_cQry += " LEFT JOIN " + RetSqlName("SE4") + " E4 ON E4_CODIGO = C7_COND "
_cQry += " WHERE C7.C7_NUM = '" + SC7->C7_NUM + "' AND "
_cQry += " C7_FILIAL = '"+xFilial("SC7")+"' AND "
_cQry += " A2_FILIAL = '"+xFilial("SA2")+"' AND "
_cQry += " C7.D_E_L_E_T_ <> '*' AND "
_cQry += " A2.D_E_L_E_T_ <> '*' "

_cQry += " Order by C7_NUM,C7_ITEM"


If Select(_cAliasTmp) >0 
(_cAliasTmp)->(DBCLOSEAREA())
Endif

//Cria tabela temporแria com base no resultado da query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)
	
dbSelectArea(_cAliasTmp)
DbGotop()

oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
oPrn:SetResolution(72)
oPrn:SetPortrait()	// Orienta็ใo do Papel (Paisagem)
oPrn:SetPaperSize(9)
//oPrn:cPathInServer(GetTempPath())
oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
 
	
While !EOF()
	nItem++
	//Adiciona os itens em um array
	nVKG := (_cAliasTmp)->TOTAL / (_cAliasTmp)->QUANTIDADE
		aItens[nItem] := {(_cAliasTmp)->ITEM,trim((_cAliasTmp)->PRODUTO) + " - " + trim((_cAliasTmp)->DESC_PRODUTO),(_cAliasTmp)->QUANTIDADE,(_cAliasTmp)->UM,(_cAliasTmp)->INCOTERM,nVKG,Iif((_cAliasTmp)->MOEDA == 2,'USD',IIf((_cAliasTmp)->MOEDA == 4,'EUR',Iif((_cAliasTmp)->MOEDA == 3,'GBP',Iif((_cAliasTmp)->MOEDA == 5,'JPY','BRL')))),(_cAliasTmp)->TOTAL}
	dbskip()
EndDo	
	
corpo(_cQry,nItem,aItens)
	        
oPrn:EndPage()
oPrn:Preview()

Return()


Static Function corpo(_cQry,nItem,aItens)

Local aArea := GetArea()
Local _cAliasTmp:= GetNextAlias()  
Local nTotal := 0        
Local cMoeda := ''
Local nNum	:= 0

dbSelectArea("SC7")
dbSetOrder(1)

If Select(_cAliasTmp) >0 
(_cAliasTmp)->(DBCLOSEAREA())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)
	
dbSelectArea(_cAliasTmp)
DbGotop()

//Pแgina 01
oPrn:StartPage()   

_nLin := 80

	ImpLogo() 
 

	oPrn:SayAlign(  _nLin+70 , 0005, "PURCHASE ORDER # " + SC7->C7_NUMPO, oFont01, 0535,0060,,2,0)
	oPrn:Box(_nLin+100, 0005, _nLin+101, 0535, "-2")//Linha

	oPrn:SayAlign(  _nLin+110 , 0005, "Please consider this P.O. as Shipping Instructions also. We kindly ask you to follow it in order" , oFont02, 0535,0030,,0,0)
	oPrn:SayAlign(  _nLin+130 , 0005, "to avoid unnecessary delay in clearing of goods. " , oFont02, 0535,0060,,0,0)
	_nLin += 150
	//Tabela 01
	oPrn:Box(_nLin, 0005, _nLin+20, 0100, "-4")//Supplier
	oPrn:SayAlign(_nLin,0009, "Supplier:",        oFont02, 0550,0030,,0,1)
	oPrn:Box(_nLin+20, 0005, _nLin+60, 0100, "-4")//Address
	oPrn:SayAlign(_nLin+20,0009, "Address:",        oFont02, 0550,0030,,0,1)
	oPrn:Box(_nLin+60, 0005, _nLin+80, 0100, "-4")//Contact Person
	oPrn:SayAlign(_nLin+60,0009, "Contact Person:",        oFont02, 0550,0030,,0,1)
	
	oPrn:Box(_nLin, 0090, _nLin+80, 0340, "-4")//Dados do Cadastro do Fornecedor
	oPrn:SayAlign(_nLin+2,0095, alltrim((_cAliasTmp)->NOMEFOR),        oFont04, 0340,0400,,0,1)
	oPrn:SayAlign(_nLin+22,0095, alltrim((_cAliasTmp)->ENDERECO) + ", " + alltrim((_cAliasTmp)->NUM) + " - " + alltrim((_cAliasTmp)->COMPLE),        oFont04, 0340,0400,,0,1)
	oPrn:SayAlign(_nLin+42,0095, alltrim((_cAliasTmp)->MUNICIPIO) + ", " + alltrim((_cAliasTmp)->ESTADO) + " " + alltrim((_cAliasTmp)->CEP) + " - " + alltrim((_cAliasTmp)->PAIS),        oFont04, 0340,0400,,0,1)
	oPrn:SayAlign(_nLin+62,0095, alltrim((_cAliasTmp)->CONTATO),        oFont04, 0340,0400,,0,1)
	
	oPrn:Box(_nLin, 0340, _nLin+20, 0400, "-4")//Date
	oPrn:SayAlign(_nLin,0344, "Date:",        oFont02, 0440,0030,,0,1)
	oPrn:Box(_nLin, 0400, _nLin+80, 0550, "-4")//Date
	oPrn:SayAlign(_nLin,0404, cMonth(StoD((_cAliasTmp)->DATA)) + ", " + Day2Str(StoD((_cAliasTmp)->DATA)) + Iif(right(Day2Str(StoD((_cAliasTmp)->DATA)),1) == '1','st',Iif(right(Day2Str(StoD((_cAliasTmp)->DATA)),1) == '2','nd',Iif(right(Day2Str(StoD((_cAliasTmp)->DATA)),1) == '3','rd','th'))) + " " +  Year2Str(StoD((_cAliasTmp)->DATA)),        oFont04, 0550,0030,,0,1)
	
	oPrn:Box(_nLin+20, 0340, _nLin+40, 0400, "-4")//Phone/Fax
	oPrn:SayAlign(_nLin+20,0344, "Phone/Fax:",        oFont02, 0440,0030,,0,2)
	cDDD := ""
	cTel := ""
	cFax := ""
	If trim((_cAliasTmp)->TEL) != ''
		cTel += " " + trim((_cAliasTmp)->TEL)
	EndIf
	If trim((_cAliasTmp)->FAX) != '' 
		cFax += " | " + trim((_cAliasTmp)->FAX) 
	EndIf
	oPrn:SayAlign(_nLin+20,0404, cTel + cFax,        oFont04, 0550,0030,,0,2)
	
	oPrn:Box(_nLin+40, 0340, _nLin+60, 0400, "-4")//Phone/Fax
	oPrn:SayAlign(_nLin+40,0344, "E-mail:",        oFont02, 0440,0030,,0,2)
	oPrn:SayAlign(_nLin+40,0404, trim((_cAliasTmp)->EMAIL),        oFont04, 0550,0030,,0,2)
	
	oPrn:Box(_nLin+60, 0340, _nLin+80, 0400, "-4")//Phone/Fax
	oPrn:SayAlign(_nLin+60,0344, "TAX_ID:",        oFont02, 0440,0030,,0,2)
	oPrn:SayAlign(_nLin+60,0404, cValtoChar((_cAliasTmp)->TAX_ID),        oFont04, 0550,0030,,0,2)
	
	_nLin := _nLin+100
	
	
	//Tabela 02
	oPrn:Box(_nLin, 0005, _nLin+12, 0060, "-4")//IT
	oPrn:Box(_nLin, 0060, _nLin+12, 0270, "-4")//Product
	oPrn:Box(_nLin, 0270, _nLin+12, 0320, "-4")//Quantity
	oPrn:Box(_nLin, 0320, _nLin+12, 0345, "-4")//UM
	oPrn:Box(_nLin, 0345, _nLin+12, 0400, "-4")//Incoterm
	oPrn:Box(_nLin, 0400, _nLin+12, 0450, "-4")//Value KG
	oPrn:Box(_nLin, 0450, _nLin+12, 0490, "-4")//Moeda
	oPrn:Box(_nLin, 0490, _nLin+12, 0550, "-4")//Total Cost
	oPrn:SayAlign(_nLin,0009, "IT",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0064, "Product",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0274, "Quantity",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0324, "UM",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0349, "Incoterm",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0404, "Value KG",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0454, "Moeda",        oFont02, 0550,0100,,0,0)
	oPrn:SayAlign(_nLin,0494, "Total Cost",        oFont02, 0550,0100,,0,0)
	
	For nNum := 1 to nItem
	_nLin += 12
		oPrn:Box(_nLin, 0005, _nLin+12, 0060, "-4")//IT
		oPrn:Box(_nLin, 0060, _nLin+12, 0270, "-4")//Product
		oPrn:Box(_nLin, 0270, _nLin+12, 0320, "-4")//Quantity
		oPrn:Box(_nLin, 0320, _nLin+12, 0345, "-4")//UM
		oPrn:Box(_nLin, 0345, _nLin+12, 0400, "-4")//Incoterm
		oPrn:Box(_nLin, 0400, _nLin+12, 0450, "-4")//Value KG
		oPrn:Box(_nLin, 0450, _nLin+12, 0490, "-4")//Moeda
		oPrn:Box(_nLin, 0490, _nLin+12, 0550, "-4")//Total Cost
		oPrn:SayAlign(_nLin,0009, aItens[nNum][1],     oFont04, 0050,0015,,0,0)
		oPrn:SayAlign(_nLin,0064, aItens[nNum][2],        oFont04, 0210,0015,,0,0)
		oPrn:SayAlign(_nLin,0270, Transform(aItens[nNum][3],"@E 999,999,999.99"),        oFont04, 0050,0015,,0,0)
		oPrn:SayAlign(_nLin,0324, aItens[nNum][4],        oFont04, 0050,0015,,0,0)
		oPrn:SayAlign(_nLin,0349, aItens[nNum][5],        oFont04, 0055,0015,,0,0)
		oPrn:SayAlign(_nLin,0404, Transform(aItens[nNum][6],"@E 999,999.99"),        oFont04, 0042,0015,,1,0)
		oPrn:SayAlign(_nLin,0450, aItens[nNum][7],        oFont04, 0040,0015,,2,0)
		oPrn:SayAlign(_nLin,0494, Transform(aItens[nNum][8],"@E 999,999,999.99"),        oFont04, 0050,0015,,1,0)
		nTotal += aItens[nNum][8]  
		cMoeda := aItens[nNum][7]
	Next
	_nLin += 12
		oPrn:Box(_nLin, 0345, _nLin+12, 0400, "-4")//Total Cost
		oPrn:Box(_nLin, 0400, _nLin+12, 0450, "-4")//Value KG
		oPrn:Box(_nLin, 0450, _nLin+12, 0490, "-4")//Moeda
		oPrn:Box(_nLin, 0490, _nLin+12, 0550, "-4")//Total Cost
		oPrn:SayAlign(_nLin,0347, "Total Cost:",        oFont02, 0050,0015,,1,0)
		oPrn:SayAlign(_nLin,0450, cMoeda,        oFont04, 0040,0015,,2,0)
		oPrn:SayAlign(_nLin,0494, Transform(nTotal,"@E 999,999,999.99"),        oFont04, 0050,0015,,1,0)
                                 
	_nLin += 25
		//Tabela 03  
		oPrn:Box(_nLin, 0005, _nLin+15, 0120, "-4")//Packing
		oPrn:SayAlign(_nLin,0009, "Packing:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+15, 0550, "-4")//Packing
		oPrn:SayAlign(_nLin,0125, UPPER((_cAliasTmp)->PACKING),        oFont02, 0550,_nLin+15,,0,2)
	_nLin += 15
		oPrn:Box(_nLin, 0005, _nLin+15, 0120, "-4")//Insurance
		oPrn:SayAlign(_nLin,0009, "Insurance:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+15, 0550, "-4")//Insurance
		oPrn:SayAlign(_nLin,0125, "Covered by us in Brazil",        oFont02, 0550,_nLin+15,,0,2)
	_nLin += 15
		oPrn:Box(_nLin, 0005, _nLin+15, 0120, "-4")//Final Destination
		oPrn:SayAlign(_nLin,0009, "Final Destination:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+15, 0550, "-4")//Final Destination
		oPrn:SayAlign(_nLin,0125, (_cAliasTmp)->DFINAL,        oFont02, 0550,_nLin+15,,0,2)
	_nLin += 15
		oPrn:Box(_nLin, 0005, _nLin+15, 0120, "-4")//E.T.D.
		oPrn:SayAlign(_nLin,0009, "E.T.D.:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+15, 0550, "-4")//E.T.D.
		oPrn:SayAlign(_nLin,0125, (_cAliasTmp)->DEMBAR,        oFont02, 0550,_nLin+15,,0,2)
	_nLin += 15
		oPrn:Box(_nLin, 0005, _nLin+30, 0120, "-4")//Invoicing
		oPrn:SayAlign(_nLin,0009, "Invoicing:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+30, 0550, "-4")//Invoicing   
		/*
		cInco := ""
		If trim((_cAliasTmp)->INCOTERM) != ''
			cInco += (_cAliasTmp)->INCOTERM
		EndIf                     
		*/
		oPrn:SayAlign(_nLin,0125, "No discrepancies will be accepted on unit value, net weight or technical description",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+15,0125, "of goods.",        oFont02, 0550,_nLin+30,,0,2)
	_nLin += 30
		oPrn:Box(_nLin, 0005, _nLin+60, 0120, "-4")//Payment Terms
		oPrn:SayAlign(_nLin,0009, "Payment Terms:",        oFont02, 0120,0100,,0,2)
		oPrn:Box(_nLin, 0120, _nLin+60, 0550, "-4")//Payment Terms
		oPrn:SayAlign(_nLin,0125, (_cAliasTmp)->CONDPAGTO,        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+15,0125, "You must send to our office the original signed documents:",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+30,0125, "Commercial Invoice, Certificate of Analysis and Packing List.",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+45,0125, "Please send by e-mail, one copy of all documents before loading, for our analysis/approval.",        oFont02, 0550,_nLin+15,,0,2)
		
		_nLin += 75
		
		//Tabela 04  
		oPrn:Box(_nLin, 0005, _nLin+90, 0120, "-4")//Payment Terms
		oPrn:SayAlign(_nLin,0005,    "The Packing label",        oFont02, 0100,_nLin+20,,1,2)
		oPrn:SayAlign(_nLin+20,0005, "must mention:",            oFont02, 0100,_nLin+40,,1,2)
		oPrn:Box(_nLin, 0120, _nLin+90, 0550, "-4")//Payment Terms
		oPrn:SayAlign(_nLin,0125, "1) Name of supplier;",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+15,0125, "2) Commercial name of the product;",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+30,0125, "3) Lot number;",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+45,0125, "4) Net weight;",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+60,0125, "5) Date of production;",        oFont02, 0550,_nLin+15,,0,2)
		oPrn:SayAlign(_nLin+75,0125, "6) Date of expiration.",        oFont02, 0550,_nLin+15,,0,2)
		
		_nLin += 100
		
		If trim((_cAliasTmp)->ACCOD) != ''
		cPais := POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_PAISEX")
		oPrn:SayAlign(_nLin,0005, "OUR AGENT WILL BE:",        oFont01, 0550,0100,,0,2)
		oPrn:SayAlign(_nLin+30,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_NOME")),        oFont02, 0550,0600,,0,2)  
		oPrn:SayAlign(_nLin+45,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_CONTATO"))+ " - " +ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_EMAILEX")),        oFont02, 0550,0600,,0,2)  
		oPrn:SayAlign(_nLin+60,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_TELRE")),        oFont02, 0550,0600,,0,2) 
		oPrn:SayAlign(_nLin+75,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_LOGEX")) + ", " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_NUMEX")) + " - " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_BAIEX")),        oFont02, 0550,0600,,0,2) 
		oPrn:SayAlign(_nLin+90,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_POSEX")) + " - " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_ESTEX")) + ", " + ALLTRIM(POSICIONE("SYA",1,xFilial("SYA")+cPais,"YA_DESCR")),        oFont02, 0550,0600,,0,2) 
			If ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_CGCEX")) != ''
				oPrn:SayAlign(_nLin+105,0005, TRANSFORM(ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->ACCOD+(_cAliasTmp)->ACLOJA,"A2_CGCEX")),"@R 99.999.999/9999-99"),        oFont02, 0550,0600,,0,2)  
	    	EndIf
		Endif
		
		
oPrn:EndPage()  


//Pแgina 02
oPrn:StartPage()
		_nLin := 80
		
		If trim((_cAliasTmp)->DESPCOD) != ''                
		cPais := POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_PAIS")
		oPrn:SayAlign(_nLin,0005, "NOTIFY WILL BE:",        oFont01, 0550,0100,,0,2)
		//oPrn:SayAlign(_nLin+20,0005, (_cAliasTmp)->NOMEFOR,        oFont01N, 0550,0100,,0,2)
		oPrn:SayAlign(_nLin+20,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_NOME")),        oFont02, 0550,0100,,0,2)  
		oPrn:SayAlign(_nLin+35,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_CONTATO")) + " - " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_EMAIL")),        oFont02, 0550,0100,,0,2) 
		oPrn:SayAlign(_nLin+50,0005, "Tel: +" + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_DDI")) + " (" + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_DDD")) + ") " + TRANSFORM(ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_TEL")),"@R 99999-9999"),        oFont02, 0550,0100,,0,2) 
		oPrn:SayAlign(_nLin+65,0005, ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_END")) + ", " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_NR_END")) + " - " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_BAIRRO")),        oFont02, 0550,0100,,0,2) 
		oPrn:SayAlign(_nLin+80,0005, "CEP: " + TRANSFORM(ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_CEP")),"@R 99999-999") + " - " + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_EST")) + ", " + ALLTRIM(POSICIONE("SYA",1,xFilial("SYA")+cPais,"YA_DESCR")),        oFont02, 0550,0100,,0,2) 
		oPrn:SayAlign(_nLin+95,0005, "CNPJ: " + TRANSFORM(ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+(_cAliasTmp)->DESPCOD+(_cAliasTmp)->DESPLOJA,"A2_CGC")),"@R 99.999.999/9999-99"),        oFont02, 0550,0100,,0,2) 
		
		_nLin += 125   
		Endif
			oPrn:SayAlign(_nLin,0005, "IMPORTANTE NOTICE",        oFont01, 0550,0010,,0,2)
		_nLin += 20 
			oPrn:SayAlign(_nLin,0005,     "Due to new regulations from Brazilian customs, starting from shipments arriving from 01st Feb 2016",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+15,0005,  "onwards at all Brazilian seaports and airports, wooden pallets must be declared on Bill-of-lading / Air",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+30,0005,  "Way bill about their treatment, as per below:",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+45,0005,  "ท Wooden Packing: Processed Wood; (in this case, certificate or equivalent must be sent with",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+60,0005,  "shipping documents)",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+75,0005,  "ท Wooden Packing: Treated and Certified; (in this case, certificate or equivalent must be sent",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+90,0005,  "with shipping documents)",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+105,0005,  "ท Wooden Packing: Not Treated and not Certified;",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+120,0005,  "ท Wooden Packing: Not Applicable;",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+135,0005,  "If not declared by yours, Customs system will consider as NA (Not Applicable), but in case of stop for",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+150,0005, "formal clearance, and attested that goods are on wooden pallets, penalties/fines will occur and we'll",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+165,0005, "be obligated to revert to exporter/supplier.",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+180,0005, "Our suggestion to avoid this kind of trouble is: change to plastic pallet or send only by Treated and",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+195,0005, "Certified (fumignewbriated/treated/certified) - linked with our FSSC 22000 Certification.",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+210,0005, "For those who are using IBC's, plastic pallets or no pallets, please insert on BL/AWB: Wooden",        oFont05, 0550,0010,,0,2)
			oPrn:SayAlign(_nLin+225,0005, "Packing: Not Applicable.",        oFont05, 0550,0010,,0,2) 
			
			_nLin := 760      
			oPrn:SayAlign(_nLin,0005, TRIM(SM0->M0_NOMECOM)			,oFont02, 0550,_nLin+17,,2,2)
			_nLin += 17
			oPrn:SayAlign(_nLin,0005, "CNPJ: " + TRANSFORM(TRIM(SM0->M0_CGC),"@R 99.999.999/9999-99") + " - IE: " + TRIM(SM0->M0_INSC)			,oFont02, 0550,_nLin+17,,2,2)
			_nLin += 17
			oPrn:SayAlign(_nLin,0005, RTRIM(SM0->M0_ENDCOB) + " - " + RTRIM(SM0->M0_BAIRCOB) + " - " + RTRIM(SM0->M0_CIDCOB) + " - " + RTRIM(SM0->M0_ESTCOB) + " - CEP " + TRANSFORM(TRIM(SM0->M0_CEPCOB),"@R 99999-999")			,oFont02, 0550,_nLin+17,,2,2)
			_nLin += 17  
			xFone := RTRIM(SM0->M0_TEL)
			xFone := STRTRAN(xFone,"(","")
			xFone := STRTRAN(xFone,")","")
			xFone := STRTRAN(xFone,"-","")
			xFone := STRTRAN(xFone," ","")
			
			xFax := RTRIM(SM0->M0_FAX)
			xFax := STRTRAN(xFax,"(","")
			xFax := STRTRAN(xFax,")","")
			xFax := STRTRAN(xFax,"-","")
			xFax := STRTRAN(xFax," ","")
			oPrn:SayAlign(_nLin,0005, "TEL: +55 " + TRANSFORM(xFone,"@R (99) 9999-9999") ,oFont02, 0550,_nLin+17,,2,2)
			_nLin += 17
			oPrn:SayAlign(_nLin,0005, "Email: " + trim(UsrRetMail(RetCodUsr())),oFont02, 0550,_nLin+17,,2,2)
oPrn:EndPage()
Return()

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLogotipo                                     						   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	cLogo := GetSrvProfString("Startpath","") + "Logoret.BMP"
	
	oPrn:SayBitmap(030,202,cLogo ,157,105)

Return()