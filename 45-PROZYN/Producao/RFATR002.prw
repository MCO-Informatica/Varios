#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ RFATR002    บ Autor ณ Adriano Leonardo บ Data ณ 07/06/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de confirma็ใo do pedido de venda                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RFATR002()

	Local _aSavArea		:= GetArea()
	Local _aSavSC5		:= SC5->(GetArea())
	Local _aSavSM2		:= SM2->(GetArea())
	Private _cRotina	:= "RFATR002"
	Private oPrn
	Private cPerg		:= _cRotina
	Private oBrush		:= TBrush():New(,CLR_HGRAY)
	Private oFont01		:= TFont():New( "Arial",,18,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
	Private oFont02		:= TFont():New( "Arial",,15,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
	Private oFont03		:= TFont():New( "Arial",,11,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
	Private oFont04		:= TFont():New( "Arial",,11,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private _nLin		:= 050 //Linha inicial para impressใo
	Private _nLinFin	:= 570 //Linha final para impressใo
	Private _nEspPad	:= 020 //Espa็amento padrใo entre linhas
	Private _cEnter		:= CHR(13) + CHR(10)
	Private aRelImp		:= MaFisRelImp("MT100",{"SF2","SD2"})
	Private _nMaxDesc	:= 32  
	Private _cPedido	:= ""  
	Private _aCab		:= {} 
	Private _cArq 		:=""
	Private _cAnexo		:= ""
	
	//Emissใo do relatorio apenas para pedido de venda
	If !Empty(M->C5_TIPO) .And. Upper(Alltrim(M->C5_TIPO)) != 'N'
		Aviso("Aten็ใo","Nใo ้ permitida a emissใo do relat๓rio para pedidos com o “Tipo de Pedido“ diferente de “N=Normal” ",{"Ok"},2)
		Return
	ElseIf !Empty(SC5->C5_TIPO) .And. Upper(Alltrim(SC5->C5_TIPO)) != 'N'
		Aviso("Aten็ใo","Nใo ้ permitida a emissใo do relat๓rio para pedidos com o Tipo de Pedido diferente de “N=Normal” ",{"Ok"},2)
		Return
	EndIf

	ValidPerg() //Chamada da fun็ใo para inclusใo dos parโmetros da rotina

	If IsInCallStack("U_MTA410I") 
		Dbselectarea("SX1")
		DbsetOrder(1)
		IF Dbseek(cPerg+"01")
			Reclock("SX1",.F.)
			D_E_L_E_T_ := '*'
			SX1->(MsUnlock())
		EndIf

	Endif

	While !Pergunte(cPerg,.T.)
		If MsgNoYES("Deseja cancelar a emissใo do relat๓rio?",_cRotina+"_01")
			Return()
		EndIf
	EndDo



	Dbselectarea("SX1")
	DbsetOrder(1)
	IF Dbseek(cPerg+"01")
		Reclock("SX1",.F.)
		D_E_L_E_T_ := ' '
		SX1->(MsUnlock())
	EndIf    


	//Chamada da fun็ใo para gera็ใo do relat๓rio
	Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relat๓rio... Por favor aguarde!",.T.)

	RestArea(_aSavSC5)
	RestArea(_aSavSM2)
	RestArea(_aSavArea)

Return()

Static Function GeraPDF()

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

	If !Empty(M->C5_NUM)
		_cArq	:= M->C5_NUM
	Else
		_cArq	:= SC5->C5_NUM
	EndIf
	
	If Empty(_cArq)
		Aviso("Aten็ใo","Nใo serแ possํvel o envio do pedido. Por gentileza, acessar o menu "+CRLF+;
							"'Outras A็๕es->Confirma็ใo do Pedido' para nova tentativa.",{"Ok"},2)
		return
	EndIf
	
	oPrn := FWMsPrinter():New(_cArq,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)

	oPrn:SetResolution(72)
	oPrn:SetLandScape()	// Orienta็ใo do Papel (Paisagem)
	oPrn:SetPaperSize(9)
	oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

	Selecao()

	oPrn:EndPage()   

	oPrn:Preview()   

	_cAnexo := (oPrn:cPathPDF+AllTrim(_cArq)+".pdf")

	If MV_PAR01 == 1
		SendMail()
	EndIf

Return()

Static Function ImpCab()

	//Verifico se ้ a primeira pแgina
	If !oPrn:IsFirstPage
		oPrn:EndPage()
	EndIf

	oPrn:StartPage()

	_nLin := 0040

	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0800, "-4")

	oPrn:Say( _nLin, 0005, "" ,oFont01, 0800) //Imprimo uma linha em branco pela fun็ใo say, para que a fun็ใo sayalign passe a funcionar, bug interno ADVPL

	oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirma็ใo do Pedido " + AllTrim(_cPedido), oFont01, 0800-0005,0060,,2,0)

	_nLin +=  _nEspPad * 2

	//Box do logotipo
	oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*6), 0800, "-4")

	ImpLogo()

	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Emissใo:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[01], oFont03, 0400-0205,0060,,0,0)
	_nLin += _nEspPad

	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Empresa:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[02], oFont04, 0400-0205,0060,,0,0)
	_nLin += _nEspPad

	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Razใo Social:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[03], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad

	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " CNPJ:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[04], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad


	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Ordem de Compra:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[06], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad

	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Previsใo de Faturamento:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:SayAlign( _nLin+5 , 0205, IIF(Len(_aDtEntr)==1,DTOC(STOD(_aDtEntr[1])),"Vide Observa็ใo"), oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad

Return()

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	Local cLogoD	    := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLogotipo                                     						   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	lMv_Logod	:= .T.
	cLogoD		:= GetSrvProfString("Startpath","") + "logoped.BMP"

	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "logoped.BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf

	If lMv_Logod               
		oPrn:SayBitmap(90,535,cLogoD ,0110,100) 
	Else  
		oPrn:SayBitmap(90,535,cLogo ,0110,100)
	EndIf

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ ValidPerg   บ Autor ณ Adriano Leonardo บ Data ณ 07/06/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo responsแvel pela inclusใo dos parโmetros da rotina. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn                			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()

	Local _sAlias	:= GetArea()
	Local aRegs		:= {}
	Local _x		:= 1
	Local _y		:= 1
	cPerg			:= PADR(cPerg,10)

	AADD(aRegs,{cPerg,"02","Enviar por e-mail?:"	,"","","mv_ch2","C",01,0,0,"C","","MV_PAR02","Sim","","","","","Nใo","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Email a Enviar ?  :"	,"","","mv_ch3","C",40,0,0,"C","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For _x := 1 To Len(aRegs)
		dbSelectArea("SX1")
		SX1->(dbSetOrder(1))
		If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
			RecLock("SX1",.T.)		
			For _y := 1 To FCount()
				If _y <= Len(aRegs[_x])
					FieldPut(_y,aRegs[_x,_y])
				Else
					Exit
				EndIf
			Next
			SX1->(MsUnlock())
		EndIf
	Next

	RestArea(_sAlias)

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ Selecao     บ Autor ณ Adriano Leonardo บ Data ณ 07/06/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo responsแvel pela consulta dos registros via banco deบฑฑ
ฑฑบ          ณ dados.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn                			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Selecao()

	Local _cAliasTmp:= GetNextAlias()
	Local _aItem	:= {}  
	Local _cMoeda	:= ""
	Local _cTaxa	:= ""
	Local _nAliICM 	:= 0
	Local _nAliPIS 	:= 0
	Local _nAliCOF 	:= 0
	Local _nAliIPI 	:= 0
	Local _nValIPI 	:= 0

	Private _aItens	:= {}
	Private _aCond	:= {}
	Private _aObs	:= {}
	Private _aDtEntr:= {}                                          
	Private _aDtExpe:= {}
	Private _nVlbrut:= 0


	//Montagem da consulta a ser realizada no banco de dados
	_cQry := "SELECT  " + _cEnter
	_cQry += "ISNULL((SELECT U5_CONTAT FROM " + RetSqlName("AC8") + " AC8 INNER JOIN " + RetSqlName("SU5") + " SU5 ON AC8.D_E_L_E_T_='' AND AC8.AC8_FILIAL='" + xFilial("AC8") + "' AND AC8_ENTIDA='SA1' AND AC8_CODENT='00000101' AND SU5.D_E_L_E_T_='' AND SU5.U5_FILIAL='" + xFilial("SU5") + "' AND SU5.U5_CODCONT=AC8.AC8_CODCON AND U5_DEPTO=(SELECT TOP 1 QB_DEPTO FROM " + RetSqlName("SQB") + " SQB WHERE SQB.D_E_L_E_T_='' AND SQB.QB_FILIAL='" + xFilial("SQB") + "' AND Upper(SQB.QB_DESCRIC) LIKE '%COMPRA%')),'') AS [COMPRADOR], " + _cEnter
	_cQry += "SC5.R_E_C_N_O_ [C5_RECNO], "
	_cQry += "* " + _cEnter
	_cQry += "FROM " + RetSqlName("SC5") + " SC5 " + _cEnter
	_cQry += "INNER JOIN " + RetSqlName("SC6") + " SC6 " + _cEnter
	_cQry += "ON SC5.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SC5.C5_FILIAL='" + xFilial("SC5") + "' " + _cEnter
	_cQry += "AND SC6.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SC6.C6_FILIAL='" + xFilial("SC6") + "' " + _cEnter
	_cQry += "AND SC5.C5_NUM=SC6.C6_NUM " + _cEnter
	_cQry += "AND SC5.C5_NUM='" + _cArq + "' " + _cEnter
	_cQry += "AND SC5.C5_TIPO NOT IN ('D','B') " + _cEnter
	_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 " + _cEnter
	_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
	_cQry += "AND SA1.A1_COD=SC5.C5_CLIENT " + _cEnter
	_cQry += "AND SA1.A1_LOJA=SC5.C5_LOJACLI " + _cEnter	
	_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1  "
	_cQry += "ON SB1.D_E_L_E_T_='' "
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQry += "AND SB1.B1_COD=SC6.C6_PRODUTO "
	_cQry += "LEFT JOIN " + RetSqlName("SA4") + " SA4 " + _cEnter
	_cQry += "ON SA4.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SA4.A4_FILIAL='" + xFilial("SA4") + "' " + _cEnter
	_cQry += "AND SA4.A4_COD=SC5.C5_TRANSP " + _cEnter	
	_cQry += "LEFT JOIN " + RetSqlName("SE4") + " SE4 " + _cEnter
	_cQry += "ON SE4.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SE4.E4_FILIAL='" + xFilial("SE4") + "' " + _cEnter
	_cQry += "AND SE4.E4_CODIGO=SC5.C5_CONDPAG " + _cEnter
	_cQry += "ORDER BY C6_ITEM " + _cEnter    

	MEMOWRITE("RONALDO",_cQry)

	//Cria tabela temporแria com base no resultado da query 7
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)



	dbSelectArea(_cAliasTmp)
	While (_cAliasTmp)->(!EOF()) 
		If (_cAliasTmp)->C5_MOEDA < 6
			_cMoeda := "MV_MOEDA" + AllTrim(Str((_cAliasTmp)->C5_MOEDA))
		ElseIf (_cAliasTmp)->C5_MOEDA < 10
			_cMoeda := "MV_MOEDAP" + AllTrim(Str((_cAliasTmp)->C5_MOEDA))
		Else
			_cMoeda := "MV_MOEDP" + AllTrim(Str((_cAliasTmp)->C5_MOEDA))
		EndIf

		_cMoeda := SuperGetMV(_cMoeda,,"")

		If (_cAliasTmp)->C5_MOEDA==1
			_cTaxa := "Nใo se aplica"
		Else
			If !Empty((_cAliasTmp)->C5_TXREF)
				_cTaxa := Transform((_cAliasTmp)->C5_TXREF,PesqPict("SM2","M2_MOEDA"+AllTrim(Str((_cAliasTmp)->C5_MOEDA))))
			Else
				_cTaxa := "Taxa do dia da fatura"
			EndIf
		EndIf

		//Caso seja o primeiro item, preencho array com informa็๕es que deverใo ser impressas no cabe็alho do relat๓rio
		If Empty(_aCab)
			AAdd(_aCab,DTOC(STOD((_cAliasTmp)->C5_EMISSAO)))
			AAdd(_aCab,(_cAliasTmp)->A1_NREDUZ)
			AAdd(_aCab,(_cAliasTmp)->A1_NOME)
			AAdd(_aCab,Transform((_cAliasTmp)->A1_CGC,IIF(Len(AllTrim((_cAliasTmp)->A1_CGC))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")))
			AAdd(_aCab,(_cAliasTmp)->COMPRADOR)
			AAdd(_aCab,(_cAliasTmp)->C5_NUMPCOM)
			AAdd(_aCab,(_cAliasTmp)->C5_NUM)

			_cPedido := (_cAliasTmp)->C5_NUM
		EndIf

		//Calculo dos impostos
		CalcTrb((_cAliasTmp)->C5_NUM, (_cAliasTmp)->C6_ITEM,@_nAliICM, @_nAliPIS, @_nAliCOF, @_nAliIPI, @_nValIPI)

		//Verifico se a data de entrega do item ้ igual ao anterior ou nใo

		If aScan(_aDtEntr,(_cAliasTmp)->C5_FECENT)==0
			AAdd(_aDtEntr,(_cAliasTmp)->C5_FECENT)
		EndIf

		//Verifico se a data de expedi็ใo do item ้ igual ao anterior ou nใo
		If aScan(_aDtExpe,(_cAliasTmp)->C6_DTEXPED)==0
			AAdd(_aDtExpe,(_cAliasTmp)->C6_DTEXPED)
		EndIf 

		_nVlbrut := (_cAliasTmp)->C6_VALOR / (_cAliasTmp)->C6_QTDVEN

		_aItem := {}  

		_nAliquota 	:= 0
		_nFator 	:= 0 		

		//Populo array com informa็๕es a serem impressas nos itens do relat๓rio    
		AAdd(_aItem,(_cAliasTmp)->C6_ITEM)
		AAdd(_aItem,AllTrim((_cAliasTmp)->B1_DESC))
		AAdd(_aItem,Transform((_cAliasTmp)->C6_QTDVEN,PesqPict("SC6","C6_QTDVEN")))
		AAdd(_aItem,(_cAliasTmp)->C6_UM)
		AAdd(_aItem,Transform((_cAliasTmp)->C6_PRCVEN/*-MaFisRet(Len(_aItens)+1,"IT_VALICM")-MaFisRet(Len(_aItens)+1,"IT_VALPIS")-MaFisRet(Len(_aItens)+1,"IT_VALCOF")*/,PesqPict("SC6","C6_PRCVEN")))
		AAdd(_aItem,_cMoeda)
		AAdd(_aItem,AllTrim(Str(_nAliICM))+ "%")  //ICMS
		AAdd(_aItem,AllTrim(Str(_nAliPIS+_nAliCOF))+ "%")  //PIS+COFINS

		_nFator := ((_nAliICM + _nAliPIS + _nAliCOF) - 100) * (-1)
		_nFator := _nFator/100

		AAdd(_aItem,Transform((_cAliasTmp)->C6_PRCVEN / _nFator,PesqPict("SC6","C6_PRCVEN"))) //Pre็o unitแrio com impostos
		AAdd(_aItem,AllTrim(Str(_nAliIPI))+ "%")  //IPI
		AAdd(_aItem,(_cAliasTmp)->B1_EMBALAG)
		AAdd(_aItem,DTOC(STOD((_cAliasTmp)->C6_ENTREG)))
		AAdd(_aItem,DTOC(STOD((_cAliasTmp)->C6_DTEXPED)))         
		AAdd(_aItem,Str(_nValIPI))		

		AAdd(_aItens,_aItem)

		//Preencho informa็๕es sobre a transportadora e condi็ใo de pagamento
		If Empty(_aCond)
			AAdd(_aCond,_cTaxa)
			AAdd(_aCond,(_cAliasTmp)->E4_DESCRI)
			AAdd(_aCond,(_cAliasTmp)->A4_NREDUZ)
			AAdd(_aCond, iif(ALLTRIM((_cAliasTmp)->C5_TPFRETE) == 'C','CIF','FOB'))			
		EndIf

		dbSelectArea("SC5")
		dbGoTo((_cAliasTmp)->C5_RECNO)

		//Preencho informa็ใo com a observa็ใo do pedido, por se tratar de um campo memo, posiciono na pr๓pria SC5, via query haveria uma limita็ใo de 1024 caracteres
		_aObs := {SC5->C5_OBS}

		dbSelectArea(_cAliasTmp)
		(_cAliasTmp)->(dbSkip())

	EndDo

	dbSelectArea(_cAliasTmp)
	(_cAliasTmp)->(dbCloseArea())

	If Len(_aCab) <= 0
		Aviso("Aten็ใo","Nใo serแ possํvel o envio do pedido. Por gentileza, acessar o menu "+CRLF+;
							"'Outras A็๕es->	 do Pedido' para nova tentativa.",{"Ok"},2)
		return
	EndIf

	ImpCab() 	//Imprime cabecalho do relat๓rio
	ImpItens() 	//Imprime os itens do pedido
	ImpCond()	//Imprime as condi็๕es comerciais

Return()

Static Function ImpItens()

	Local _nItem	:= 1	
	Local _nQuebLin := 1
	Local _nNumCar	:= 0
	Local _nPalavra	:= 0

	_nLin += _nEspPad

	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0030, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, "Item", oFont03, 0030-0005,0060,,2,0)

	oPrn:Box( _nLin, 0030, _nLin + (_nEspPad*2), 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0030, "Produto", oFont03, 0200-0030,0060,,2,0)

	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*2), 0270, "-4")
	oPrn:SayAlign( _nLin+5 , 0200, "Quantidade", oFont03, 0270-0200,0060,,2,0)

	oPrn:Box( _nLin, 0270, _nLin + (_nEspPad*2), 0300, "-4")
	oPrn:SayAlign( _nLin+5 , 0270, "Unid", oFont03, 0300-0270,0060,,2,0)

	oPrn:Box( _nLin, 0300, _nLin + (_nEspPad*2), 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0300, "Pre็o unitแrio com impostos (bruto)", oFont03, 0400-0300,0060,,2,0)

	oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*2), 0440, "-4")
	oPrn:SayAlign( _nLin+5 , 0400, "Moeda", oFont03, 0440-0400,0060,,2,0)

	oPrn:Box( _nLin, 0440, _nLin + (_nEspPad*2), 0475, "-4")
	oPrn:SayAlign( _nLin+5 , 0440, "ICMS", oFont03, 0475-0440,0060,,2,0)

	oPrn:Box( _nLin, 0475, _nLin + (_nEspPad*2), 0535, "-4")
	oPrn:SayAlign( _nLin+5 , 0475, "PIS+COFINS", oFont03, 0535-0475,0060,,2,0)

	oPrn:Box( _nLin, 0535, _nLin + (_nEspPad*2), 0640, "-4")
	//	oPrn:SayAlign( _nLin+5 , 0535, "Pre็o unitแrio com impostos (bruto)", oFont03, 0605-0535,0060,,2,0)

	//	oPrn:Box( _nLin, 0605, _nLin + (_nEspPad*3), 0640+50, "-4")
	oPrn:SayAlign( _nLin+5 , 0545, "IPI", oFont03, 0610-0535,0060,,2,0)

	oPrn:Box( _nLin, 0640, _nLin + (_nEspPad*2), 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0630, "Embalagem", oFont03, 0800-0630,0060,,2,0)

	_nLin += _nEspPad*3

	For _nItem := 1 To Len(_aItens)

		_aPalavras := Separa(AllTrim(_aItens[_nItem,02])," ")

		_nNumCar := 0
		_nQuebLin:= 1

		For _nPalavra := 1 To Len(_aPalavras)
			_nNumCar += Len(_aPalavras[_nPalavra]) + 1

			If _nPalavra + 1 <= Len(_aPalavras)
				If _nNumCar + Len(_aPalavras[_nPalavra+1]) + 1 >= _nMaxDesc
					_nQuebLin++
					_nNumCar := 0
				EndIf
			ElseIf _nNumCar >= _nMaxDesc
				_nQuebLin++
			EndIf
		Next

		oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*_nQuebLin), 0030, "-4")
		oPrn:Box( _nLin, 0030, _nLin + (_nEspPad*_nQuebLin), 0200, "-4")
		oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*_nQuebLin), 0270, "-4")
		oPrn:Box( _nLin, 0270, _nLin + (_nEspPad*_nQuebLin), 0300, "-4")
		oPrn:Box( _nLin, 0300, _nLin + (_nEspPad*_nQuebLin), 0400, "-4")
		oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*_nQuebLin), 0440, "-4")
		oPrn:Box( _nLin, 0440, _nLin + (_nEspPad*_nQuebLin), 0475, "-4")
		oPrn:Box( _nLin, 0475, _nLin + (_nEspPad*_nQuebLin), 0535, "-4")
		oPrn:Box( _nLin, 0535, _nLin + (_nEspPad*_nQuebLin), 0640, "-4")
		oPrn:Box( _nLin, 0640, _nLin + (_nEspPad*_nQuebLin), 0800, "-4")
		//		oPrn:Box( _nLin, 0640+50, _nLin + (_nEspPad*_nQuebLin), 0800, "-4")

		oPrn:SayAlign( _nLin+5 , 0005, Space(1) + _aItens[_nItem,01] + Space(1)	, oFont04, 0030-0005,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0035, _aItens[_nItem,02]						, oFont04, 0200-0035,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0200, Space(1) + _aItens[_nItem,03] + Space(1)	, oFont04, 0270-0200,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0270, Space(1) + _aItens[_nItem,04] + Space(1)	, oFont04, 0300-0270,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0300, Space(1) + _aItens[_nItem,05] + Space(1)	, oFont04, 0400-0300,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0400, Space(1) + _aItens[_nItem,06] + Space(1)	, oFont04, 0440-0400,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0440, Space(1) + _aItens[_nItem,07] + Space(1)	, oFont04, 0475-0440,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0475, Space(1) + _aItens[_nItem,08] + Space(1)	, oFont04, 0535-0475,0060,,0,0)
		//		oPrn:SayAlign( _nLin+5 , 0535, Space(1) + _aItens[_nItem,09] + Space(1)	, oFont04, 0605-0535,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0535, Space(1) + _aItens[_nItem,10] + Space(1)	, oFont04, 0605-0535,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0535, Space(1) + _aItens[_nItem,14] + Space(1)	, oFont04, 0640-0535,0060,,1,0)
		//		oPrn:SayAlign( _nLin+5 , 0535, Space(1) + Transform(_nValIPI,"@E 999,999,999.99") + Space(1)	, oFont04, 0640-0535,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0640, Space(1) + _aItens[_nItem,11] + Space(1)	, oFont04, 0800-0640,0060,,0,0)

		_nLin += (_nEspPad*_nQuebLin)

		QuebraPag()
	Next

Return()

Static Function ImpCond()

	_nLin += _nEspPad		
	QuebraPag()
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0800, "-4")
	oPrn:SayAlign( _nLin+2 , 0005, " Condi็๕es Comerciais:", oFont02, 0800-0005,0060,,0,0)
	_nLin += _nEspPad
	QuebraPag()	
	//oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4") 
	//oPrn:SayAlign( _nLin+5 , 0005, " Taxa de cโmbio:", oFont04, 0200-0005,0060,,0,0)
	//oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	//oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[1], oFont04, 0800-0205,0060,,0,0)
	//_nLin += _nEspPad
	//QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Prazo de pagamento:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[2], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Transportadora:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[3], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Frete:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[4], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	     
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Obs:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) +"Sujeito a altera็ใo de ICMS conforme resolu็ใo SF nบ 13/2012 do Senado Federal publicado em 26 de Abril de 2012.", oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	
Return()

//Static Function ImpObs()

//	Local _nItem := 1

//	_nLin += _nEspPad

//	QuebraPag()
//	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0800, "-4")
//	oPrn:SayAlign( _nLin+5 , 0005, " Observa็๕es:", oFont02, 0800-0005,0060,,0,0)
//	_nLin += _nEspPad
//	QuebraPag()

//	If Len(_aDtEntr)>1 .Or. Len(_aDtExpe)>1
//		For _nItem := 1 To Len(_aItens)
//			oPrn:SayAlign( _nLin+5 , 0005, "Item: " + AllTrim(_aItens[_nItem,01]) + " - Dt. Faturamento: " + _aItens[_nItem,12] + " - Dt. Expedi็ใo: " + _aItens[_nItem,13], oFont04, 0800-0005,0060,,0,0)
//			_nLin += (_nEspPad-5)
//			QuebraPag()
//		Next

//		_nLin += 5
//		QuebraPag()
//	EndIf

//	oPrn:SayAlign( _nLin+5 , 0005, AllTrim(_aObs[1]), oFont04, 0800-0005,0060,,0,0)
//Return()

Static Function QuebraPag()

	If _nLin >= _nLinFin
		oPrn:EndPage()
		oPrn:StartPage()

		_nLin := 0040

		oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0800, "-4")

		oPrn:Say( _nLin, 0005, "" ,oFont01, 0800) //Imprimo uma linha em branco pela fun็ใo say, para que a fun็ใo sayalign passe a funcionar, bug interno ADVPL

		oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirma็ใo do Pedido " + AllTrim(_aCab[07]), oFont01, 0800-0005,0060,,2,0)

		_nLin +=  _nEspPad * 2
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail  บAutor  ณMicrosiga           บ Data ณ  19/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnviar pedido por email                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SendMail()
	Local cMsgErr	:= ""
	
	_cMailCli  		:= MV_PAR02
	//_cLogo 		:= "\system\logo"+cFilAnt+".bmp"

	lOk			:= .T.
	cAccount	:=  GetMv("MV_RELACNT")
	cPassword	:=  GetMv("MV_RELPSW")
	cServer		:=  GetMv("MV_RELSERV")
	cCC			:= ''

	cFrom		:= "protheus@prozyn.com.br" //Rtrim(_cMailCli)
	cTo			:= Rtrim(_cMailCli)
	cBCC		:= ''
	cSubject	:= "PROZYN - Confirma็ใo do Pedido"
	_cBody		:= "<P>Prezado(a) Cliente,</P>"
	_cBody		+= "<BR>"
	_cBody		+= "<P>Segue anexo a confirma็ใo do pedido " + _cPedido + ", conforme sua solicita็ใo.</P>"

	_cNewArq := ""

	_cNewArq := "\cp\"+AllTrim(_cArq)+".pdf"
	CpyT2S(_cAnexo, "\cp\", .F.)
	_cAnexo  := _cNewArq

	U_RCFGM001("Confirma็ใo do Pedido!",_cBody,_cMailCli,_cAnexo)
	
	/*EnvMail(_cMailCli,"Confirma็ใo do Pedido!",_cBody,"", _cAnexo, @cMsgErr)
	
	If !Empty(cMsgErr)
		Aviso("Aten็ใo","Erro ao enviar e-mail: "+cMsgErr,{"Ok"},2)
	EndIf*/

Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVlBrt  บAutor  ณMicrosiga			 บ Data ณ  13/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o valor do total do pedido, considerando os       บฑฑ
ฑฑบ          ณ impostos													  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcTrb(cPedido, cItem, nAliICM, nAliPIS, nAliCOF, nAliIPI, nValIPI)

	Local aArea 	:= GetArea() 
	Local cCliEnt	:= ""
	Local aRelImp   := MaFisRelImp("MT100",{"SF2","SD2"})
	Local cKey 	     := ""
	Local aFisGet    := Nil
	Local aFisGetSC5 := Nil
	Local nFrete	:= 0
	Local nSeguro	:= 0
	Local nFretAut	:= 0
	Local nDespesa	:= 0
	Local nDescCab	:= 0
	Local nPDesCab	:= 0
	Local aItemPed	:= {}
	Local aCabPed	:= {}
	Local nTotQtd 	:= 0
	Local nTotVal 	:= 0
	Local nPesBru	:= 0
	Local nPesLiq	:= 0
	Local aPedCli	:= {}
	Local aC5Rodape	:= {}
	Local nValMerc  := 0
	Local nPrcLista := 0
	Local nAcresFin := 0
	Local nDesconto := 0
	Local nRecnoSD1	:= 0
	Local nItem		:= 0
	Local nY		:= 0

	Default cPedido		:= ""
	Default cItem		:= ""
	Default nAliICM		:= 0 
	Default nAliPIS		:= 0 
	Default nAliCOF		:= 0 
	Default nAliIPI		:= 0 
	Default nValIPI		:= 0 

	DbSelectArea("SC5")
	DbSetOrder(1)
	If SC5->(DbSeek(xFilial("SC5") + cPedido ) )

		FisGetInit(@aFisGet,@aFisGetSC5)

		cCliEnt := IIf(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE)

		MaFisIni(cCliEnt,;							// 1-Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
		If(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
		SC5->C5_TIPO,;				// 4-Tipo da NF
		SC5->C5_TIPOCLI,;			// 5-Tipo do Cliente/Fornecedor
		aRelImp,;							// 6-Relacao de Impostos que suportados no arquivo
		,;						   			// 7-Tipo de complemento
		,;									// 8-Permite Incluir Impostos no Rodape .T./.F.
		"SB1",;								// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461")							// 10-Nome da rotina que esta utilizando a funcao

		nFrete		:= SC5->C5_FRETE
		nSeguro		:= SC5->C5_SEGURO
		nFretAut	:= SC5->C5_FRETAUT
		nDespesa	:= SC5->C5_DESPESA
		nDescCab	:= SC5->C5_DESCONT
		nPDesCab	:= SC5->C5_PDESCAB			

		aItemPed:= {}
		aCabPed := {SC5->C5_TIPO	,;
		SC5->C5_CLIENTE				,;
		SC5->C5_LOJACLI				,;
		SC5->C5_TRANSP				,;
		SC5->C5_CONDPAG				,;
		SC5->C5_EMISSAO				,;
		SC5->C5_NUM					,;
		SC5->C5_VEND1				,;
		SC5->C5_VEND2				,;
		SC5->C5_VEND3				,;
		SC5->C5_VEND4				,;
		SC5->C5_VEND5				,;
		SC5->C5_COMIS1				,;
		SC5->C5_COMIS2				,;
		SC5->C5_COMIS3				,;
		SC5->C5_COMIS4				,;
		SC5->C5_COMIS5				,;
		SC5->C5_FRETE				,;
		SC5->C5_TPFRETE				,;
		SC5->C5_SEGURO				,;
		SC5->C5_TABELA				,;
		SC5->C5_VOLUME1				,;
		SC5->C5_ESPECI1				,;
		SC5->C5_MOEDA				,;
		SC5->C5_REAJUST				,;
		SC5->C5_BANCO				,;
		SC5->C5_ACRSFIN				 ;
		}

		nTotQtd 	:= 0
		nTotVal 	:= 0
		nPesBru		:= 0
		nPesLiq		:= 0
		aPedCli		:= {}
		cPedido		:= SC5->C5_NUM
		aC5Rodape	:= {}

		aadd(aC5Rodape,{SC5->C5_PBRUTO,SC5->C5_PESOL,SC5->C5_DESC1,SC5->C5_DESC2,;
		SC5->C5_DESC3,SC5->C5_DESC4,SC5->C5_MENNOTA})					

		dbSelectArea("SC5")
		For nY := 1 to Len(aFisGetSC5)
			If !Empty(&(aFisGetSC5[ny][2]))
				If aFisGetSC5[ny][1] == "NF_SUFRAMA"
					MaFisAlt(aFisGetSC5[ny][1],Iif(&(aFisGetSC5[ny][2]) == "1",.T.,.F.),Len(aItemPed),.T.)		
				Else
					MaFisAlt(aFisGetSC5[ny][1],&(aFisGetSC5[ny][2]),Len(aItemPed),.T.)
				Endif	
			EndIf
		Next nY

		DbSelectArea("SC6")
		DbSetOrder(1)
		If SC6->(DbSeek( xFilial("SC6"); 
						+PADR(SC5->C5_NUM, TAMSX3("C6_NUM")[1]);
						) )

			While SC6->(!Eof()) .And. SC6->C6_FILIAL == SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM
				++nItem
				cNfOri     := Nil
				cSeriOri   := Nil
				nRecnoSD1  := Nil
				nDesconto  := 0

				If !Empty(SC6->C6_NFORI)
					dbSelectArea("SD1")
					dbSetOrder(1)
					dbSeek(xFilial("SC6")+SC6->C6_NFORI+SC6->C6_SERIORI+SC6->C6_CLI+SC6->C6_LOJA+;
						SC6->C6_PRODUTO+SC6->C6_ITEMORI)
					cNfOri     := SC6->C6_NFORI
					cSeriOri   := SC6->C6_SERIORI
					nRecnoSD1  := SD1->(RECNO())
				EndIf
				
				
				nValMerc  := SC6->C6_VALOR
				nPrcLista := SC6->C6_PRUNIT
				
				If ( nPrcLista == 0 )
					nPrcLista := NoRound(nValMerc/SC6->C6_QTDVEN,TamSX3("C6_PRCVEN")[2])
				EndIf
				
				nAcresFin := A410Arred(SC6->C6_PRCVEN*SC5->C5_ACRSFIN/100,"D2_PRCVEN")
				nValMerc  += A410Arred(SC6->C6_QTDVEN*nAcresFin,"D2_TOTAL")		
				nDesconto := a410Arred(nPrcLista*SC6->C6_QTDVEN,"D2_DESCON")-nValMerc
				nDesconto := IIf(nDesconto==0,SC6->C6_VALDESC,nDesconto)
				nDesconto := Max(0,nDesconto)
				nPrcLista += nAcresFin
				
				If cPaisLoc=="BRA"
					nValMerc  += nDesconto
				EndIf						

				MaFisAdd(SC6->C6_PRODUTO	,;	// 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES				,;	// 2-Codigo do TES ( Opcional )
					SC6->C6_QTDVEN			,;	// 3-Quantidade ( Obrigatorio )
					nPrcLista						,;	// 4-Preco Unitario ( Obrigatorio )
					nDesconto						,;	// 5-Valor do Desconto ( Opcional )
					cNfOri							,;	// 6-Numero da NF Original ( Devolucao/Benef )
					cSeriOri						,;	// 7-Serie da NF Original ( Devolucao/Benef )
					nRecnoSD1						,;	// 8-RecNo da NF Original no arq SD1/SD2
					0								,;	// 9-Valor do Frete do Item ( Opcional )
					0								,;	// 10-Valor da Despesa do item ( Opcional )
					0								,;	// 11-Valor do Seguro do item ( Opcional )
					0								,;	// 12-Valor do Frete Autonomo ( Opcional )
					nValMerc						,;	// 13-Valor da Mercadoria ( Obrigatorio )
					0								,;	// 14-Valor da Embalagem ( Opiconal )
					0								,;	// 15-RecNo do SB1
					0								)	// 16-RecNo do SF4

				aadd(aItemPed,	{	SC6->C6_ITEM	,;
					SC6->C6_PRODUTO					,;
					SC6->C6_DESCRI					,;
					SC6->C6_TES						,;
					SC6->C6_CF						,;
					SC6->C6_UM						,;
					SC6->C6_QTDVEN					,;
					SC6->C6_PRCVEN					,;
					SC6->C6_NOTA					,;
					SC6->C6_SERIE					,;
					SC6->C6_CLI						,;
					SC6->C6_LOJA					,;
					SC6->C6_VALOR					,;
					SC6->C6_ENTREG					,;
					SC6->C6_DESCONT					,;
					SC6->C6_LOCAL					,;
					SC6->C6_QTDEMP					,;
					SC6->C6_QTDLIB					,;
					SC6->C6_QTDENT					,;
					})							
				
				DbSelectArea("SC6")
				For nY := 1 to Len(aFisGet)
					If !Empty(&(aFisGet[ny][2]))
						MaFisAlt(aFisGet[ny][1],&(aFisGet[ny][2]),Len(aItemPed))
					EndIf
				Next nY
				
				DbSelectArea("SF4")
				
				SF4->(dbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
				If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
					If ( SF4->F4_ISS=="S" )
						nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
						nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(Len(aItemPed))/100)),"D2_PRCVEN")
						MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
						MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))
					EndIf
				EndIf	
				
				DbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))			
				MaFisAlt("IT_PESO",SC6->C6_QTDVEN*SB1->B1_PESO,Len(aItemPed))
				MaFisAlt("IT_PRCUNI",nPrcLista,Len(aItemPed))
				MaFisAlt("IT_VALMERC",nValMerc,Len(aItemPed))				
				
				If Alltrim(SC6->C6_ITEM) == Alltrim(cItem)
					nAliICM 	:= MaFisRet(nItem,"IT_ALIQICM")
					nAliPIS 	:= MaFisRet(nItem,"IT_ALIQPS2") //Aliquota de Impostos Variaveis 6 pis 
					nAliCOF 	:= MaFisRet(nItem,"IT_ALIQCF2") //Aliquota de Impostos Variaveis 5 Cofins 
					nAliIPI 	:= MaFisRet(nItem,"IT_ALIQIPI") 
					nValIPI 	:= MaFisRet(nItem,"IT_VALIPI")
				EndIf
				
				SC6->(DbSkip())
			EndDo
			
			MaFisEnd()
		EndIf
	EndIf

	RestArea(aArea)
Return 


Static Function FisGetInit(aFisGet,aFisGetSC5)

Local cValid      := ""
Local cReferencia := ""
Local nPosIni     := 0
Local nLen        := 0

If aFisGet == Nil
	aFisGet	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6")
	While !Eof().And.X3_ARQUIVO=="SC6"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGet,,,{|x,y| x[3]<y[3]})
EndIf

If aFisGetSC5 == Nil
	aFisGetSC5	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")
	While !Eof().And.X3_ARQUIVO=="SC5"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})
EndIf
MaFisEnd()
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail  บAutor  ณMicrosiga	          บ Data ณ  25/03/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

Local aArea 		:= GetArea()
Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
Local lSSL			:= .T.
Local lTLS			:= .T.
									
Local oServer       := Nil
Local oMessage		:= Nil 
Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
Local nX			:= 1
Local nErro			:= 0

Default cMsgErr 	:= ""

//Crio a conexใo com o server STMP ( Envio de e-mail )
oServer := TMailManager():New()

If lSSL
	oServer:SetUseSSL(lSSL)
EndIf

If lTLS
	oServer:SetUseTLS(lTLS)
EndIf

oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

//realizo a conexใo SMTP
nErro := oServer:SmtpConnect() 
If nErro != 0  
	cMsgErr := "Falha na conexใo SMTP. "
	Return .F.
EndIf

//seto um tempo de time out com servidor de 1min
If oServer:SetSmtpTimeOut( 60 ) != 0
	cMsgErr := "Falha ao setar o time out com o servidor. "
	Return .F.
EndIf

// Autentica็ใo
If lAutentic
	If oServer:SMTPAuth ( cAccount,cPwd ) != 0
		cMsgErr := "Falha ao autenticar. "
		Return .F.
	EndIf
EndIf

//Apos a conexใo, crio o objeto da mensagem
oMessage := TMailMessage():New()

//Limpo o objeto
oMessage:Clear()

//Populo com os dados de envio
oMessage:cFrom		:= 	cAccount
oMessage:cTo		:=	cEmailTo
oMessage:cSubject	:= 	cAssunto
oMessage:cBody		:= 	cMensagem
oMessage:MsgBodyType( "text/html" )

For nX := 1 To Len(aAnexos)
	If File(aAnexos[nX])
	
		//Adiciono um attach
		If oMessage:AttachFile( aAnexos[nX] ) < 0
			cMsgErr := "Erro ao anexar o arquivo. "
			Return .F.
		EndIf
	EndIf     
Next

//Envio o e-mail
If oMessage:Send( oServer ) != 0
	cMsgErr := "Erro ao enviar o e-mail. "
	Return .F.
EndIf

//Disconecto do servidor
If oServer:SmtpDisconnect() != 0
	cMsgErr := "Erro ao disconectar do servidor SMTP. "
	Return .F.
EndIf
                    
RestArea(aArea)
Return                            