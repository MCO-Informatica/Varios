#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTDEF.CH"
/***********************************************
Programa: SW001 							 ***
Autor: André Lanzieri    					 ***
Data:10/09/2013 							 ***
Descrição: Rel. Apuração Cartão Retorno		 ***
************************************************/
User Function SW001()
	
	Private oDlg2 := nil
	Private cPerg  := "SW001"
	Pergunte(cPerg,.F.)
	
	@ 001,001 TO 245,410 DIALOG oDlg2 TITLE OemToAnsi("Apuração Cartão Retorno")
	@ 002,002 TO 005,024
	@ 003,003 SAY OemToAnsi("Apuração Cartão Retorno")
	@ 009,014 BUTTON OemToAnsi("Parametro") SIZE 35,10 ACTION Pergunte(cPerg,.T.)
	@ 009,028 BUTTON OemToAnsi("Cancela") SIZE 35,10 ACTION Close(oDlg2)
	@ 009,040 BUTTON OemToAnsi("OK") SIZE 35,10 ACTION Processa({ || SW001A()},OemToAnsi('Gerando o relatório.'),	OemToAnsi('Aguarde...'),,oDlg2:End())
	
	ACTIVATE DIALOG oDlg2 CENTER
	
Return

Static Function SW001A()
	LOCAL _nTtPed	:= 0
	LOCAL cAlias := GetNextAlias()
	LOCAL cTotal
	LOCAL nValor 	:= 0
	Local _nCntImpr 	:= 0
	Local _nRec     := 0
	LOCAL i			:= 0
	Local cQuery   := ""
	LOCAL _aDados	:= {}
	LOCAL nIncen := 0
	Local nTotal := 0
	Local nX
	PRIVATE oBr_Preto   := TBrush():New("",RGB(0,0,0))
	PRIVATE oBr_Cinza   := TBrush():New("",RGB(170,170,170))
	PRIVATE oBr_Cinza_Claro   := TBrush():New("",RGB(210,210,210))
	PRIVATE oBr_Branco  := TBrush():New("",RGB(255,255,255))
	PRIVATE oFont06		:= TFont():New('Courier New',06,06,,.F.,,,,.T.,.F.)
	PRIVATE oFont06n	:= TFont():New('Courier New',06,06,,.T.,,,,.T.,.F.)
	PRIVATE oFont07 	:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.)
	PRIVATE oFont07n	:= TFont():New('Courier New',07,07,,.T.,,,,.T.,.F.)
	PRIVATE oFont08		:= TFont():New("Cambria",,10,,.F.,,,,,.F.,.F.)
	PRIVATE oFont08n 	:= TFont():New('Courier New',08,10,,.T.,,,,.T.,.F.)
	PRIVATE oFont14n 	:= TFont():New('Courier New',14,14,,.T.,,,,.T.,.F.)
	PRIVATE nLinFim	:= 3200
	PRIVATE nQlin 	:= 50
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contadores de linha e pagina                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE li := 50, nPag := 1
	PRIVATE oPrinter  	:=	tAvPrinter():New("Apuração Cartão Retorno")
	Private aDados := {}
	
	
	oPrinter:Setup()
	oPrinter:SetPortrait()
	oPrinter:StartPage()
	ImpCab()
	
	/*
	cQuery += " SELECT * FROM "+RetSqlName("SC5")+" SC5 "
	cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.D_E_L_E_T_<>'*' AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC = C5_NOTA AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" SA3 ON A3_FILIAL='"+xFilial("SA3")+"' AND SA3.D_E_L_E_T_<>'*' AND A3_COD = C5_VEND2  "
	cQuery += " WHERE C5_FILIAL='"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_<>'*' AND C5_VEND2 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " ORDER BY A3_NOME,F2_EMISSAO,C5_NUM "
	*/
	
	cQuery := " SELECT * FROM "+RetSqlName("SC5")+" SC5 "
	cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.D_E_L_E_T_<>'*' AND F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC = C5_NOTA AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD = C5_VEND2  "
	cQuery += " WHERE C5_FILIAL='"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_<>'*' AND

	cQuery += " C5_REP BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR
	cQuery += " C5_REP2 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR   
	cQuery += " C5_REP3 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR
	cQuery += " C5_REP4 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR "
	cQuery += " C5_CLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR05+"' OR
	cQuery += " C5_CLI2 BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR05+"' OR
	cQuery += " C5_CLI3 BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR05+"' OR"
	cQuery += " C5_CLI4 BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR05+"'  "
	
	cQuery += " ORDER BY A3_NOME,F2_EMISSAO,C5_NUM "

TCQUERY cQuery NEW ALIAS (cAlias)
ProcRegua(_nRec)

WHILE (cAlias)->(!EOF())
	DBSELECTAREA("SA3")
	SA3->(DBSETORDER(1))
	
	DBSELECTAREA("SA1")
	SA1->(DBSETORDER(1))
	//IF DBSEEK(xFilial("Z17")+ALLTRIM(cPar1))
	cNome := ""
	IF((!EMPTY((CALIAS)->C5_REP) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 2)) .OR. !EMPTY((cAlias)->C5_CLI) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 3)) .AND. ;
			ALLTRIM((CALIAS)->C5_REP) >= ALLTRIM(MV_PAR03) .AND. ;
			ALLTRIM((CALIAS)->C5_REP) <= ALLTRIM(MV_PAR04) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI) >= ALLTRIM(MV_PAR05) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI) <= ALLTRIM(MV_PAR06)
		IF !EMPTY((CALIAS)->C5_REP)
			SA3->(DBSEEK(xFilial("SA3")+ALLTRIM((cAlias)->C5_REP)))
			cNome := SA3->A3_NOME
		ELSE
			SA1->(DBSEEK(xFilial("SA1")+ALLTRIM((cAlias)->C5_CLI)))
			cNome := SA1->A1_NOME
		ENDIF
		//EMISSAO                        ,Numero Pedido 	       ,Nome Vendedor             ,Valor Retorno                                   ,Valor Recompra
		aadd(aDados,{DTOC(STOD((cAlias)->F2_EMISSAO)),ALLTRIM((cAlias)->C5_NUM),alltrim(cNome),(cAlias)->C5_RET1,(cAlias)->C5_REC1})
	ENDIF
	cNome:= ""
	IF((!EMPTY((CALIAS)->C5_REP2) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 2)) .OR. !EMPTY((cAlias)->C5_CLI2) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 3)) .AND. ;
			ALLTRIM((CALIAS)->C5_REP2) >= ALLTRIM(MV_PAR03) .AND. ;
			ALLTRIM((CALIAS)->C5_REP2) <= ALLTRIM(MV_PAR04) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI2) >= ALLTRIM(MV_PAR05) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI2) <= ALLTRIM(MV_PAR06)
		IF !EMPTY((CALIAS)->C5_REP2)
			SA3->(DBSEEK(xFilial("SA3")+ALLTRIM((cAlias)->C5_REP2)))
			cNome := SA3->A3_NOME
		ELSE
			cNome := SA1->(DBSEEK(xFilial("SA1")+ALLTRIM((cAlias)->C5_CLI2)))
			cNome := SA1->A1_NOME
		ENDIF
		//EMISSAO                        ,Numero Pedido 	       ,Nome Vendedor             ,Valor Retorno                                   ,Valor Recompra
		aadd(aDados,{DTOC(STOD((cAlias)->F2_EMISSAO)),ALLTRIM((cAlias)->C5_NUM),ALLTRIM(cNome),(cAlias)->C5_RET2,(cAlias)->C5_REC2})
	ENDIF
	cNome := ""
	IF((!EMPTY((CALIAS)->C5_REP3) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 2)) .OR. !EMPTY((cAlias)->C5_CLI3) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 3)) .AND. ;
			ALLTRIM((CALIAS)->C5_REP3) >= ALLTRIM(MV_PAR03) .AND. ;
			ALLTRIM((CALIAS)->C5_REP3) <= ALLTRIM(MV_PAR04) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI3) >= ALLTRIM(MV_PAR05) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI3) <= ALLTRIM(MV_PAR06)
		IF !EMPTY((CALIAS)->C5_REP3)
			SA3->(DBSEEK(xFilial("SA3")+ALLTRIM((cAlias)->C5_REP3)))
			cNome := SA3->A3_NOME
		ELSE
			SA1->(DBSEEK(xFilial("SA1")+ALLTRIM((cAlias)->C5_CLI3)))
			cNome := SA1->A1_NOME
		ENDIF
		//EMISSAO                        ,Numero Pedido 	       ,Nome Vendedor             ,Valor Retorno                                   ,Valor Recompra
		aadd(aDados,{DTOC(STOD((cAlias)->F2_EMISSAO)),ALLTRIM((cAlias)->C5_NUM),ALLTRIM(cNome),(cAlias)->C5_RET3,(cAlias)->C5_REC3})
	ENDIF
		IF((!EMPTY((CALIAS)->C5_REP4) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 2)) .OR. !EMPTY((cAlias)->C5_CLI4) .AND. (MV_PAR07 == 1 .OR. MV_PAR07 == 3)) .AND. ;
			ALLTRIM((CALIAS)->C5_REP4) >= ALLTRIM(MV_PAR03) .AND. ;
			ALLTRIM((CALIAS)->C5_REP4) <= ALLTRIM(MV_PAR04) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI4) >= ALLTRIM(MV_PAR05) .AND. ;
			ALLTRIM((CALIAS)->C5_CLI4) <= ALLTRIM(MV_PAR06)
		IF !EMPTY((CALIAS)->C5_REP4)
			SA3->(DBSEEK(xFilial("SA3")+ALLTRIM((cAlias)->C5_REP4)))
			cNome := SA4->A4_NOME
		ELSE
			SA1->(DBSEEK(xFilial("SA1")+ALLTRIM((cAlias)->C5_CLI4)))
			cNome := SA1->A1_NOME
		ENDIF
		//EMISSAO                        ,Numero Pedido 	       ,Nome Vendedor             ,Valor Retorno                                   ,Valor Recompra
		aadd(aDados,{DTOC(STOD((cAlias)->F2_EMISSAO)),ALLTRIM((cAlias)->C5_NUM),ALLTRIM(cNome),(cAlias)->C5_RET4,(cAlias)->C5_REC4})
	ENDIF
	
	(cAlias)->(DbSkip())
	
ENDDO
li := 0420

FOR nX := 1 to len(aDados)
	
	if nX == 1
		ASORT(aDados, , ,{ | x,y | x[3] < y[3] } )
		oPrinter:Say(li,0350,aDados[nX][3],oFont14n)             //Nome vendedor
		li+=nQlin
		nVendedor := ALLTRIM(aDados[nX][3])
	endif
	IF ALLTRIM(aDados[nX][3]) == nVendedor
		oPrinter:Say(li,0350,ALLTRIM(aDados[nX][1]),oFont08)             //F2_EMISSAO DATA FATURAMENTO
		oPrinter:Say(li,0800,ALLTRIM(aDados[nX][2]),oFont08)             //C5_NUM NUMERO PEDIDO
		oPrinter:Say(li,1300,ALLTRIM(aDados[nX][3]),oFont08)             //A3_NOME NOME VENDENDOR
		oPrinter:Say(li,2000,ALLTRIM(Transform(aDados[nX][4],"@E 999,999,999.99")),oFont08,,,,1)             // VLR RETORNO
		oPrinter:Say(li,2200,ALLTRIM(Transform(aDados[nX][5],"@E 999,999,999.99")),oFont08,,,,1)             // VLR RECOMPRA
		nIncen += aDados[nX][4]+aDados[nX][5]//(cAlias)->C5_INCEN
		nTotal += aDados[nX][4]+aDados[nX][5]
	ELSE
		oPrinter:Say(li,1700,"Total: ",oFont08n,,,,)
		oPrinter:Say(li,2200,Transform(nIncen,"@E 999,999,999.99"),oFont08n,,,,1)
		nIncen := 0
		nVendedor := ALLTRIM(aDados[nX][3])
		li+=nQlin
		oPrinter:Line(li,2280,li,0300)
		li+=nQlin
		oPrinter:Say(li,0350,aDados[nX][3],oFont14n)             //Nome vendedor
		li+=nQlin
		oPrinter:Say(li,0350,aDados[nX][1],oFont08)             //F2_EMISSAO DATA FATURAMENTO
		oPrinter:Say(li,0800,aDados[nX][2],oFont08)             //C5_NUM NUMERO PEDIDO
		oPrinter:Say(li,1300,aDados[nX][3],oFont08)             //A3_NOME NOME VENDENDOR
		oPrinter:Say(li,2000,ALLTRIM(Transform(aDados[nX][4],"@E 999,999,999.99")),oFont08,,,,1)             // VLR RETORNO
		oPrinter:Say(li,2200,ALLTRIM(Transform(aDados[nX][5],"@E 999,999,999.99")),oFont08,,,,1)             // VLR RECOMPRA
		nIncen +=aDados[nX][4]+aDados[nX][5]//(cAlias)->C5_INCEN
		nTotal +=aDados[nX][4]+aDados[nX][5]
	ENDIF
	li:=VerifLinha(li)
	li+=nQlin
	_nCntImpr++
	IncProc()
	//(cAlias)->(DbSkip())
next nX
//enddo

oPrinter:Say(li,1700,"Total: ",oFont08n,,,,)
oPrinter:Say(li,2200,Transform(nIncen,"@E 999,999,999.99"),oFont08n,,,,1)

li+=nQLin                    

oPrinter:Line(li,2280,li,0300)

li+=nQLin

oPrinter:Say(li,1700,"Total Geral: ",oFont08n,,,,)
oPrinter:Say(li,2200,Transform(nTotal,"@E 999,999,999.99"),oFont08n,,,,1)

If _nCntImpr == 0
	MsgBox("Arquivo vazio!","Atenção","ALERT")
return
Endif

SetPgEject(.F.) //CONCLUI A CONTRUCAO DA PAG
oPrinter:Preview() // APRESENTA A PAG
(cAlias)->(dbCloseArea())
Return

Static Function VerifLinha(li)
	Local oCourier8N	:=	TFont():New("Courier New",,8,,.T.,,,,,.F.,.F.)
	Local oCambr9N	:=	TFont():New("Cambria",,9,,.T.,,,,,.F.,.F.)
	If li>=(nLinFim-50)
		oPrinter:Line(3300,2250,3300,280)
		oPrinter:EndPage()
		ImpCab()
		li:=370
		nPag+=1
		//oPrinter:Say(0240,0179,"Pagina",oCambr9N,,0)
		//oPrinter:Say(0280,0179,"Page / Page",oCourier8N,,0)
		//oPrinter:Say(0260,0463,str(nPag),oCambr9N,,0)
		//oPrinter:Line(0250,420,0378,420)
		//ImpImg()
	EndIf
	
Return li

Static Function ImpCab()
	Local oCourier11N	:=	TFont():New("Courier New",,11,,.T.,,,,,.F.,.F.)
	Local oCourier8N	:=	TFont():New("Courier New",,8,,.T.,,,,,.F.,.F.)
	Local oArial11N	:=	TFont():New("Arial Black",,11,,.T.,,,,,.F.,.F.)
	Local oCambr19N	:=	TFont():New("Cambria",,19,,.T.,,,,,.F.,.F.)
	Local oCambr10N	:=	TFont():New("Cambria",,10,,.T.,,,,,.F.,.F.)
	
	oPrinter:SetPortrait()
	
	oPrinter:Say(0298,0850,"Apuração cartão retorno",oCambr19N,,0)
	
	oPrinter:Say(0370,0350,"Dta Emissão",oCambr10N,,0)
	oPrinter:Say(0370,0800,"Pedido",oCambr10N,,0)
	oPrinter:Say(0370,1300,"R.C.",oCambr10N,,0)
	oPrinter:Say(0370,1900,"Vlr. Retorno",oCambr10N,,0)
	oPrinter:Say(0370,2100,"Vlr. Recompra",oCambr10N,,0)
	//ImpRodape()
	
Return

Static Function ImpRodape()
	oPrinter:SetPortrait()
	oPrinter:Line(2250,3344,2250,001)
	oPrinter:Line(2294,3344,2294,001)
	oPrinter:FillRect({2289,3344,2255,001},oBr_Cinza)
	
Return

