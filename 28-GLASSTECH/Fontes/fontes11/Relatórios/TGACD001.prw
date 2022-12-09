#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

&& Constantes de Margem das Páginas
#DEFINE HMARGEM   050
#DEFINE VMARGEM   050
#DEFINE MAXLINHA  015

&& Constantes para Alinhamento de Texto
#define PAD_LEFT		0
#define PAD_RIGHT		1
#define PAD_CENTER	2

#define CB7ORDSEP   	1
#define CB7PEDIDO		2
#define CB7CLIENT		3
#define CB7LOJA		4
#define CB7STATUS		5
#define SC5EMISSAO	6
	
#define A1NOME			1
#define A1END			2
#define A1EST			3
#define A1MUN			4
#define A1BAIRRO		5

#define A4COD			1
#define A4NOME			2
#define A4DDD			3
#define A4TEL			4

#define A3COD			1
#define A3NOME			2

User Function TGACD001()
Private aBitmap  	:="" 
Private cString  	:=""
Private cPerg		:="TGACD001"
Private nI 	   	:=0
Private nRow1		:=0
Private nRow2	   	:=0
Private nRow3	   	:=0
Private nHPage   	:=0
Private nVPage   	:=0
Private nLinha 	:=0
Private nX			:=0
Private nY			:=1
Private nQtdOri	:=0
Private nSalLinha	:=0
Private nSalItem	:=0
Private nLinAss	:=0
Private aCabecCB7	:={}
Private aCabecSA1	:={}
Private aCabecSA4	:={}
Private aCabecSA3	:={}
Private aItens		:={}
Private oReport 	:=Nil	
Private PixelX 
Private PixelY 
Private cEof		:= char(13)+char(10)
Private nOrdem      := '' 
	&& Inicializa a Classe TMSPrinter (Relatório Gráfico) e Define Propriedades Gerais
	
	oReport:=TMSPrinter():new("Ordem de Separação")
	oReport:StartPage()     		&& Inicia uma nova página
	//oReport:SetPage(9) 	  		&& Define como Tamanho A4
	oReport:setSize(210,297)
	oReport:SetPortrait()   		&& ou SetLandscape()
	oReport:SetLoMetricMode() 	&& Each logical unit is converted to 0.1 millimeter. Positive x is to the right; positive y is up.
	
	lPreview := .T.

	PixelX := oReport:nLogPixelX()
	PixelY := oReport:nLogPixelY()
	
	//if Perg()
	oReport:Setup()
	//if Pergunte(cPerg,.t.)
	if Perg(cPerg)
		RptStatus({|lEnd| MontaRel()},"Imprimindo Ordem de Separação...")
		
		oReport:Preview()
		
	Endif
	
Return(.T.)

/*
* Data			:16/04/2012
* Especifico 	:Twinglas
*/
Static Function MontaRel()
Local aRet 		:= {}
Local cQuery 		:= ""

Private oFont8   	:=TFont():new("Arial"		,9,08,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10  	:=TFont():new("Arial"		,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11c	:=TFont():new("Courier New"	,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11  	:=TFont():new("Arial"		,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12  	:=TFont():new("Arial"		,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14  	:=TFont():new("Arial"		,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont20  	:=TFont():new("Arial"		,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont21  	:=TFont():new("Arial"		,9,21,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16n 	:=TFont():new("Arial"		,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont15  	:=TFont():new("Arial"		,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont15n 	:=TFont():new("Arial"		,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14n 	:=TFont():new("Arial"		,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24  	:=TFont():new("Arial"		,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

/*
&& Obtem os dados para compor o cabeçalho do relatorio.
cQuery := "SELECT	 CB7.CB7_ORDSEP,CB7.CB7_PEDIDO,CB7.CB7_CLIENT,CB7.CB7_LOJA,CB7.CB7_STATUS,"+cEof
cQuery += "        SA1.A1_NOME, SA1.A1_END,SA1.A1_EST,SA1.A1_MUN,SA1.A1_BAIRRO,"+cEof
cQuery += "        SA4.A4_COD,SA4.A4_NOME,SA4.A4_DDD,SA4.A4_TEL,"+cEof
cQuery += "        SC5.C5_EMISSAO,"+cEof
cQuery += "        SA3.A3_COD, SA3.A3_NOME"+cEof
cQuery += " 	FROM	"+RetSqlTab("CB7")+","+RetSqlTab("SA1")+","+RetSqlTab("SA4")+","+RetSqlTab("SC5")+","+RetSqlTab("SA3")+" "+cEof
cQuery += " 		WHERE	CB7.D_E_L_E_T_ = ''"+cEof
cQuery += " 		AND    SA1.D_E_L_E_T_ = ''"+cEof
cQuery += " 		AND    SA4.D_E_L_E_T_ = ''"+cEof
cQuery += " 		AND    SC5.D_E_L_E_T_ = ''"+cEof
cQuery += " 		AND    CB7.CB7_PEDIDO = SC5.C5_NUM"+cEof
cQuery += " 		AND    CB7.CB7_CLIENT = SA1.A1_COD"+cEof
cQuery += " 		AND    CB7.CB7_LOJA   = SA1.A1_LOJA"+cEof
cQuery += " 		AND		SC5.C5_TRANSP  = SA4.A4_COD"+cEof
cQuery += " 		AND    SC5.C5_VEND1   = SA3.A3_COD"+cEof
cQuery += " 		AND		CB7.CB7_PEDIDO >= '"+MV_PAR01+"' AND CB7.CB7_PEDIDO <= '"+MV_PAR02+"'"+cEof
cQuery += " 		AND		CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"+cEof
cQuery += " 		AND		SA1.A1_FILIAL  = '"+xFilial("SA1")+"'"+cEof
cQuery += "		AND		SA4.A4_FILIAL  = '"+xFilial("SA4")+"'"+cEof
cQuery += " 		AND		SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
*/

cQuery := "SELECT	CB7.CB7_ORDSEP,CB7.CB7_PEDIDO,CB7.CB7_CLIENT,CB7.CB7_LOJA,CB7.CB7_STATUS,"+cEof
cQuery += "        SA1.A1_NOME, SA1.A1_END,SA1.A1_EST,SA1.A1_MUN,SA1.A1_BAIRRO,"+cEof
cQuery += "        SA4.A4_COD,SA4.A4_NOME,SA4.A4_DDD,SA4.A4_TEL,"+cEof
cQuery += "        SC5.C5_EMISSAO,"+cEof
cQuery += "        SA3.A3_COD, SA3.A3_NOME"+cEof
cQuery += " 	FROM "+RetSqlTab("CB7")+" "+cEof
cQuery += " 		INNER JOIN "+RetSqlTab("SC5")+" ON CB7.CB7_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = '' AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"+cEof
cQuery += " 		LEFT  JOIN "+RetSqlTab("SA1")+" ON CB7.CB7_CLIENT = SA1.A1_COD AND "+cEof
cQuery += " 		                                   CB7.CB7_LOJA   = SA1.A1_LOJA AND"+cEof
cQuery += " 		                                   SA1.D_E_L_E_T_ = '' AND"+cEof
cQuery += "												SA1.A1_FILIAL = '"+xFilial("SA1")+"'"+cEof
cQuery += " 		LEFT  JOIN "+RetSqlTab("SA4")+" ON SC5.C5_TRANSP  = SA4.A4_COD AND SA4.D_E_L_E_T_ = '' AND SA4.A4_FILIAL = '"+xFilial("SA4")+"'"+cEof
cQuery += " 		LEFT  JOIN "+RetSqlTab("SA3")+" ON SC5.C5_VEND1   = SA3.A3_COD AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '"+xFilial("SA3")+"'"+cEof
cQuery += "	WHERE"+cEof
cQuery += "	    CB7.D_E_L_E_T_  = ''"+cEof
cQuery += " 		AND	   CB7.CB7_PEDIDO >= '"+MV_PAR01+"' AND CB7.CB7_PEDIDO <= '"+MV_PAR02+"'"+cEof  
cQuery += " 		AND	   CB7.CB7_ORDSEP >= '"+MV_PAR03+"' AND CB7.CB7_ORDSEP <= '"+MV_PAR04+"'"+cEof  
cQuery += " 		AND	   CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"+cEof

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"qTmp",.T.,.T.)

While !qTmp->(Eof())

	aAdd(aCabecCB7, {qTmp->CB7_ORDSEP,qTmp->CB7_PEDIDO,qTmp->CB7_CLIENT,qTmp->CB7_LOJA,qTmp->CB7_STATUS,qTmp->C5_EMISSAO})
	aAdd(aCabecSA1, {qTmp->A1_NOME,qTmp->A1_END,qTmp->A1_EST,qTmp->A1_MUN,qTmp->A1_BAIRRO})
	aAdd(aCabecSA4, {qTmp->A4_COD,qTmp->A4_NOME,qTmp->A4_DDD,qTmp->A4_TEL})
	aAdd(aCabecSA3, {qTmp->A3_COD,qTmp->A3_NOME})
	qTmp->(DbSkip())
End
qTmp->(DbCloseArea())		

	For nX := 1 to Len(aCabecCB7)
		aItens := {}
		If !Empty(aCabecCB7[nX][1])
			&&Obtem os dados para compor os itens do relatorio.
			cQuery := "SELECT CASE WHEN SB1.B1_LOCALIZ = 'N' OR SB1.B1_LOCALIZ = '' THEN SB1.B1_ZZENDPR ELSE CB8.CB8_LCALIZ END AS LOCALIZ, " 
			cQuery += " CB8.*, SB1.B1_ZZCATAL, SB1.B1_ZZEMB "
			cQuery += " 	FROM	"+RetSqlTab("CB8")+", "+RetSqlTab("SB1")+" "
			cQuery += " 		WHERE  CB8.D_E_L_E_T_ = ''"
			cQuery += " 		AND    SB1.D_E_L_E_T_ = ''"
			cQuery += " 		AND    CB8.CB8_PROD   = SB1.B1_COD"
			cQuery += " 		AND    CB8.CB8_ORDSEP = '"+aCabecCB7[nX][CB7ORDSEP]+"'"
			cQuery += " 		AND	   CB8.CB8_FILIAL = '"+xFilial("CB8")+"'"
			cQuery += " 		AND	   SB1.B1_FILIAL  = '"+xFilial("SB1")+"'"
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"qTmp",.T.,.T.)
			
			While !qTmp->(Eof())
			
				aAdd(aItens, {qTmp->CB8_ITEM,qTmp->B1_ZZCATAL,qTmp->CB8_LOCAL,qTmp->LOCALIZ,qTmp->CB8_LOTECT,qTmp->CB8_QTDORI,qTmp->CB8_SALDOS,qTmp->CB8_SALDOE,qTmp->B1_ZZEMB})
				qTmp->(DbSkip())
			End
			qTmp->(DbCloseArea())		
		EndIf
	
	
		&&Calcula o numero de paginas
		lNumPag 	:= .T.
		nNumPag 	:= 1
		nTotReg	:= Len(aItens)-MAXLINHA
		While lNumPag
		
			if nTotReg > 0
				nNumPag += 1
				nTotReg := nTotReg-MAXLINHA
			Else
				lNumPag := .f.	
			Endif	
			
		End
		
		If nNumPag > 1
			
			For nZ := 1 to nNumPag
				&&Monta o quadro do cabeçalho
				Cabecalho()
				
				&&Monta o quadro de itens
				Detalhes()
				
				&&Monta o quadro do rodapé
				RodapeRel()
			Next nZ
			
		Else
			nZ := 1
			nY := 1
			
			&&Monta o quadro do cabeçalho
			Cabecalho()
						
			&&Monta o quadro de itens
			Detalhes()
			
			&&Monta o quadro do rodapé
			RodapeRel()
		EndIf
			
	Next nX
	
Return()



Static Function Cabecalho()
Local nTit := 1
	
	nOrdem 	:= Alltrim(aCabecCB7[nX][CB7ORDSEP])
	
	nLinha 		:= 0
	nColuna	:= 0
	nSalLinha	:= 078
	nSalItem	:= 060
	nLinAss	:= 2700
	
	oReport:StartPage()
	&& Configuração de Posicionamento da Página	
	nHPage := oReport:nHorzRes()
	nHPage *= (300/oReport:nLogPixelX())
	nHPage -= HMARGEM  
	
	nVPage := oReport:nVertRes() 
	nVPage *= (300/oReport:nLogPixelY())
	nVPage -= VMARGEM
	cStatus := ""
	If 	aCabecCB7[nX][CB7STATUS] == "0"
		cStatus := "Inicio"
	ElseIf aCabecCB7[nX][CB7STATUS] == "1"
		cStatus := "Separando"
	ElseIf aCabecCB7[nX][CB7STATUS] == "2"
		cStatus := "Sep.Final"
	ElseIf aCabecCB7[nX][CB7STATUS] == "3"
		cStatus := "Embalando"
	ElseIf aCabecCB7[nX][CB7STATUS] == "4"
		cStatus := "Emb.Final"
	ElseIf aCabecCB7[nX][CB7STATUS] == "5"
		cStatus := "Gera Nota"
	ElseIf aCabecCB7[nX][CB7STATUS] == "6"
		cStatus := "Imp.nota"
	ElseIf aCabecCB7[nX][CB7STATUS] == "7"
		cStatus := "Imp.Vol"
	ElseIf aCabecCB7[nX][CB7STATUS] == "8"
		cStatus := "Embarcado"
	ElseIf aCabecCB7[nX][CB7STATUS] == "9"
		cStatus := "Embarque Finalizado"
	EndIf	
	
	nLinha := 090
	cEndereco := Alltrim(aCabecSA1[nX][A1END])
	&&Box do cabeçalho do relatorio.
	oReport:Box(050,050,600,2350)
	oReport:say(nLinha,1120,"Ordem de separação No. "+Alltrim(aCabecCB7[nX][CB7ORDSEP])	,oFont12)
	oReport:say(nLinha,1820,"Status da ordem: "+Alltrim(cStatus)		,oFont12)
	
	nLinha += nSalLinha
	oReport:say(nLinha,500,"Pedido de venda: "+Alltrim(aCabecCB7[nX][CB7PEDIDO])+"  "+dtoc(stod(aCabecCB7[nX][6])),oFont12)
	oReport:say(nLinha,1470,"Vendedor: "+Alltrim(aCabecSA3[nX][A3COD])+"-"+Alltrim(aCabecSA3[nX][A3NOME]),oFont12)	
	
	&&Logo
	cLogoD	:= GetSrvProfString("Startpath","")+"ORDSEP"+cEmpAnt+".BMP"
	oReport:SayBitmap(nLinha,120,cLogoD,342,220)
	
	nLinha += nSalLinha
	oReport:say(nLinha,500, Alltrim(aCabecCB7[nX][CB7CLIENT])+"/"+Alltrim(aCabecCB7[nX][CB7LOJA])+" - "+Alltrim(aCabecSA1[nX][A1NOME]),oFont12)
	oReport:say(nLinha,1470,"UF: "+ Alltrim(aCabecSA1[nX][A1EST]),oFont12)
	
	nLinha += nSalLinha
	oReport:say(nLinha,500,"Rua: "+SubStr(cEndereco,1,30),oFont12)
	oReport:say(nLinha,1470,"BAIRRO: "+ Alltrim(aCabecSA1[nX][A1BAIRRO]),oFont12)
	
	nLinha += nSalLinha
	If !Empty(SubStr(cEndereco,31,30))
		oReport:say(nLinha,500,"Cont. Rua: "+SubStr(cEndereco,31,30),oFont12)
	EndIf
	oReport:say(nLinha,1470,"CIDADE: "+ Alltrim(aCabecSA1[nX][A1MUN]),oFont12)
	

	nLinha += nSalLinha
	oReport:say(nLinha,500,"Transportadora: "+Alltrim(aCabecSA4[nX][A4NOME]),oFont12)

	nLinha += nSalLinha-20
	oReport:say(nLinha,1900,"Paginas "+StrZero(nZ,2)+"/"+StrZero(nNumPag,2),oFont12)
	
Return()

Static Function Detalhes(nIniCont)	
	&&Box do cabeçalho dos itens
	oReport:Box(620,050,660,2350)

	nLinha 		+= nSalLinha
	oReport:say(nLinha,0055,"Item"				,oFont11) 	&& CARACTER 	02
	//oReport:say(nLinha,0190,"Catálogo"			,oFont11) 	&& VERIFICAR
	oReport:say(nLinha,0150,"Arm."				,oFont11) 	&& CARACTER 	02
	oReport:say(nLinha,0250,"Catalogo"			,oFont11) 	&&CARACTER 	15
	//oReport:say(nLinha,0970,"Lote"				,oFont11)	&&CARACTER 	10
	oReport:say(nLinha,1550,"Qtd.Original"		,oFont11) 	&&NUMERO 		12,2
	//oReport:say(nLinha,1550,"Qtd. A Separar"	,oFont11) 	&&NUMERO 		12,2
	oReport:say(nLinha,1850,"Qtd A Embalar"	,oFont11)	&&NUMERO 		12,2
	oReport:say(nLinha,2200,"Embal."			,oFont11)	&&VERIFICAR
	
	nLinha += nSalLinha-5
	nQtdOri := 0
	nIniCont := nY
	
	If nNumPag > 1
		if nZ == 1
			nTotReg := MAXLINHA
		Elseif nZ > 1
			nTotReg += iif((Len(aItens)-nTotReg) > MAXLINHA,MAXLINHA,(Len(aItens)-nTotReg))
		EndIf
	Else
		nTotReg := Len(aItens)
	EndIf
		
	For nY := nIniCont To nTotReg
		oReport:say(nLinha,0055,aItens[nY][1]										,oFont11) 	&& CARACTER 	02
		//oReport:say(nLinha,0190,aItens[nY][2]										,oFont11) 	&& CARACTER   50
		oReport:say(nLinha,0150,aItens[nY][3]										,oFont11) 	&& CARACTER 	02
		oReport:say(nLinha,0250,aItens[nY][2]/*Catalogo*/						,oFont11) 	&& CARACTER 	15
		//oReport:say(nLinha,0970,aItens[nY][5]										,oFont11)	&& CARACTER 	10
		oReport:say(nLinha,1550,Transform(aItens[nY][6],"@E 999,999,999.99")	,oFont11) 	&& NUMERO 		12,2
		//oReport:say(nLinha,1550,Transform(aItens[nY][7],"@E 999,999,999.99")	,oFont11) 	&& NUMERO 		12,2
		oReport:say(nLinha,1850,Transform(aItens[nY][8],"@E 999,999,999.99")	,oFont11)	&& NUMERO 		12,2
		oReport:say(nLinha,2200,aItens[nY][9]										,oFont11)	&& CARACTER   02 OU 04
		nLinha += nSalItem
		oReport:say(nLinha,0055,"End.: " + aItens[nY][4]	/*Endereço*/					,oFont11) 	&& CARACTER   50
		nLinha += nSalItem
		oReport:line(nLinha,0055,nLinha,2350) 								&& Linha Horizontal
		nQtdOri += aItens[nY][6]
		
	Next nY
	
Return()

Static Function RodapeRel()		
	&&Ultima Parte do Relatorio
	//nLinha += nSalLinha+1680
	nLinha := 2580
	
	oReport:say(nLinha,055,"Total de peças: "+Transform(nQtdOri,"@E 999,999,999.99")	,oFont12)
	
	&&Box das quantidades de caixas
	oReport:Box(2550,1580,2750,2300)
	oReport:line(2650,1580,2650,2300) 								&& Linha Horizontal
	oReport:line(2550,1830,2750,1830) 								&& Linha Vertical
	oReport:say(nLinha-10,1350,"Qtd. Caixa: "		,oFont12)
	
	//oReport:Box()
	nLinha += nSalLinha
	oReport:say(nLinha+10,1350,"Qtd. Caixa: "		,oFont12)

	nLinha += nSalLinha+50
	oReport:line(nLinAss,0055,nLinAss,0600) 								&& Linha Horizontal
	oReport:say(nLinha,055,"Aprovado Por ___/___/___",oFont12)
	
	oReport:line(nLinAss,0650,nLinAss,1400) 								&& Linha Horizontal
	oReport:say(nLinha,650,"Autorizado Embalar/faturar Por ___/___/___",oFont12)
	
	&& BOX observaçao
	oReport:Box(2960,050,3080,2350)	
	
	&& BOX Reservado para coleta.
	oReport:Box(3090,1580,3400,2350)	
	
	nLinAss += 180
	nLinha += nSalLinha+133
	oReport:say(nLinha,0055,"Faturar somente com autorização Embalar/Faturar",oFont12)
	
	nLinAss += 165
	nLinha += 145
	oReport:line(nLinAss,0055,nLinAss,0600) 								&& Linha Horizontal
	oReport:say(nLinha,055,"Expedição ___/___/___"	,oFont12)
	
	oReport:line(nLinAss,0650,nLinAss,1400) 								&& Linha Horizontal
	oReport:say(nLinha,650,"Conferente ___/___/___"	,oFont12)
	nLinha+= 1
	MSBAR('CODE128',nLinha,0.8,nOrdem,oReport,.F.,,.T.,0.013,0.7,,,,.F.)
		
	oReport:EndPage()     && Finaliza a página	

Return(.T.)


Static Function Perg()
Local aParBox 	:= {}
                                           `
AADD(aParBox,{1,"Pedido Venda De"	,Space(6),"","","SC5","",10,.f.})	&& MV_PAR01
AADD(aParBox,{1,"Pedido Venda Até"	,Space(6),"","","SC5","",10,.f.})	&& MV_PAR02  
AADD(aParBox,{1,"Ordem De"	       ,Space(6),"","","CB7","",10,.f.})	&& MV_PAR03
AADD(aParBox,{1,"Ordem Até"	       ,Space(6),"","","CB7","",10,.f.})	&& MV_PAR04

Return ParamBox(aParBox,cPerg,,,,,,,,cPerg,.T.,.T.)


Static Function Mm2Pix(oPrint, nMm)
Local nValor := (nMm * 300) / 25.4
Return nValor