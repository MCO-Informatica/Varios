#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTDEF.CH"

/***********************************************
Programa: SW002								 ***
Autor: André Lanzieri    					 ***
Data:10/09/2013 							 ***
Descrição: Rel. Valor comissões				 ***
************************************************/
User Function SW002()

Private oDlg2 := nil
Private cPerg  := "SW002"
Pergunte(cPerg,.F.)

@ 001,001 TO 245,410 DIALOG oDlg2 TITLE OemToAnsi("Valor Comissões")
@ 002,002 TO 005,024
@ 003,003 SAY OemToAnsi("Valor Comissões")
@ 009,014 BUTTON OemToAnsi("Parametro") SIZE 35,10 ACTION Pergunte(cPerg,.T.)
@ 009,028 BUTTON OemToAnsi("Cancela") SIZE 35,10 ACTION Close(oDlg2)
@ 009,040 BUTTON OemToAnsi("OK") SIZE 35,10 ACTION Processa({ || SW002A()},OemToAnsi('Gerando Relatório.'),	OemToAnsi('Aguarde...'),,oDlg2:End())

ACTIVATE DIALOG oDlg2 CENTER

Return

Static Function SW002A()
LOCAL _nTtPed	:= 0
LOCAL cAlias := GetNextAlias()
Local cOrc	:= GetNextAlias()
LOCAL cTotal
LOCAL nValor 	:= 0
Local _nRec     := 0
LOCAL i			:= 0
Local cQuery   := ""
LOCAL _aDados	:= {}
LOCAL nIncen := 0
PRIVATE oBr_Preto   := TBrush():New("",RGB(0,0,0))
PRIVATE _nCntImpr 	:= 0
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
PRIVATE oCambr16N	:= TFont():New("Cambria",,16,,.T.,,,,,.F.,.F.)

PRIVATE nLinFim	:= 3200
PRIVATE nQlin 	:= 50
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 50
PRIVATE oPrinter  	:=	tAvPrinter():New("Valor Comissões")
PRIVATE nPedido := 0
PRIVATE nComis := 0
PRIVATE nTPedido := 0
PRIVATE nTComis := 0
Private cVendedor := ""
Private cCodVend := ""

IF MV_PAR05 == 1 .OR. MV_PAR05 == 2
	cQuery += " SELECT DISTINCT A3_COD, A3_NOME, E3_EMISSAO, C6_NOTA, C6_SERIE,E3_PEDIDO,A1_NOME,E3_BASE, E3_COMIS FROM SE3010 SE3 "
	cQuery += " LEFT JOIN SC5010 SC5 ON SC5.D_E_L_E_T_<>'*' AND C5_NUM = E3_PEDIDO "
	cQuery += " LEFT JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_COD = E3_VEND"
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD = E3_CODCLI AND A1_LOJA = E3_LOJA "
	cQuery += " LEFT JOIN SC6010 SC6 ON SC6.D_E_L_E_T_<>'*' AND C6_NUM = C5_NUM "
	cQuery += " WHERE SE3.D_E_L_E_T_<>'*' AND E3_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'AND E3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
EndIf

IF MV_PAR05 == 1
	cQuery += " UNION ALL "
ENDIF

IF MV_PAR05 == 1 .OR. MV_PAR05 == 3
	cQuery += " SELECT DISTINCT A3_COD, A3_NOME, E3_EMISSAO, C6_NOTA, C6_SERIE,E3_PEDIDO,A1_NOME,E3_BASE, E3_COMIS FROM SE3020 SE3 "
	cQuery += " LEFT JOIN SC5020 SC5 ON SC5.D_E_L_E_T_<>'*' AND C5_NUM = E3_PEDIDO "
	cQuery += " LEFT JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_COD = E3_VEND"
	cQuery += " LEFT JOIN SA1010 SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD = E3_CODCLI AND A1_LOJA = E3_LOJA "
	cQuery += " LEFT JOIN SC6020 SC6 ON SC6.D_E_L_E_T_<>'*' AND C6_NUM = C5_NUM "
	cQuery += " WHERE SE3.D_E_L_E_T_<>'*' AND E3_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'AND E3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
ENDIF
cQuery += " ORDER BY A3_NOME,E3_EMISSAO,E3_PEDIDO "

TCQUERY cQuery NEW ALIAS (cAlias)
ProcRegua(_nRec)
          
oPrinter:Setup()
oPrinter:SetPortrait()

WHILE (cAlias)->(!EOF())

	cVendedor := ALLTRIM((cAlias)->A3_NOME)
	cCodVend  := ALLTRIM((cAlias)->A3_COD)
	
	oPrinter:EndPage()
    
	li := 0540
	
	ImpCab()
	li+=nQlin
	
	/*IMPRIME TOTAIS CREDITO COMISSÕES*/
	WHILE (cAlias)->(!EOF()) .AND. Alltrim((cAlias)->A3_NOME) == Alltrim(cVendedor) //_nCntImpr < 100
		oPrinter:Say(li,0150,DTOC(STOD((cAlias)->E3_EMISSAO)),oFont08)             				//E3_EMISSAO DATA FATURAMENTO
		oPrinter:Say(li,0350,ALLTRIM((cAlias)->C6_NOTA)+ALLTRIM((cAlias)->C6_SERIE),oFont08)    //C5_NOTA Numero Nota C5_SERIE Serie Nota
		oPrinter:Say(li,0650,ALLTRIM((cAlias)->E3_PEDIDO),oFont08)             					//C5_NUM NUMERO PEDIDO
		
		If Subs((cAlias)->E3_PEDIDO,1,1)$"ABCD"
			cQry := " SELECT DISTINCT SUBSTRING(C6_NUMORC,1,6) C6_NUMORC FROM SC6020 WHERE C6_NUM = '"+(cAlias)->E3_PEDIDO+"' AND D_E_L_E_T_ = '' "
			TCQUERY cQry NEW ALIAS (cOrc)
		Else
			cQry := " SELECT DISTINCT SUBSTRING(C6_NUMORC,1,6) C6_NUMORC FROM SC6010 WHERE C6_NUM = '"+(cAlias)->E3_PEDIDO+"' AND D_E_L_E_T_ = '' "
			TCQUERY cQry NEW ALIAS (cOrc)
		EndIf
		
		If (cORC)->(Eof()) == .f.
			oPrinter:Say(li,0850,ALLTRIM((cORC)->C6_NUMORC),oFont08)             	    				//C5_NUM NUMERO PEDIDO
		EndIf
		
		(cORC)->(dbCloseArea())

		oPrinter:Say(li,1050,ALLTRIM((cAlias)->A1_NOME),oFont08)             					//C5_NUM NUMERO PEDIDO
		oPrinter:Say(li,1950,Transform((cAlias)->E3_BASE,"@E 999,999,999.99"),oFont08,,,,1) 	//Valor pedido E3_BASE
		oPrinter:Say(li,2150,Transform((cAlias)->E3_COMIS,"@E 999,999,999.99"),oFont08,,,,1)	//Valor comissão
		
		nPedido += (cAlias)->E3_BASE
		nComis += (cAlias)->E3_COMIS
		
		nTPedido += (cAlias)->E3_BASE
		nTComis += (cAlias)->E3_COMIS

		li:=VerifLinha(li)
		li+=nQlin
		_nCntImpr++
		IncProc()
		(cAlias)->(DbSkip())
	Enddo
	
	If _nCntImpr > 0
		oPrinter:Line(li,2200,li,100)
		
		li:=VerifLinha(li)
		li+=nQlin

		oPrinter:Say(li,1360,"Totais",oFont08,,,,1) //Valor pedido E3_BASE
		oPrinter:Say(li,1950,"R$"+Transform(nPedido,"@E 999,999,999.99"),oFont08,,,,1) //Valor total pedido
		oPrinter:Say(li,2150,"R$"+Transform(nComis,"@E 999,999,999.99"),oFont08,,,,1) //Valor total comissão

		li:=VerifLinha(li)
		li+=nQlin

		oPrinter:Line(li,2200,li,100)

		li:=VerifLinha(li)
		li+=nQlin
		
	endif

	li+=nQlin
	li+=nQlin
	li+=nQlin

	ImpCab2(li)
	
EndDo


oPrinter:EndPage()
    
oPrinter:StartPage()

li := 0540

oPrinter:Line(li,2200,li,100)

oPrinter:Say(li,0150,"Total (Vendas e Comissões):",oCambr16N,,0) //Valor pedido E3_BASE

li:=VerifLinha(li)
li+=nQlin

oPrinter:Say(li,1950,"R$"+Transform(nTPedido,"@E 999,999,999.99"),oFont08,,,,1) //Valor total pedido
oPrinter:Say(li,2150,"R$"+Transform(nTComis,"@E 999,999,999.99"),oFont08,,,,1) //Valor total comissão

li:=VerifLinha(li)
li+=nQlin

oPrinter:Say(li,0150,"Referente a data "+DTOC(MV_PAR03)+" - "+DTOC(MV_PAR04),oCambr16N,,0)

li:=VerifLinha(li)
li+=nQlin

oPrinter:Line(li,2200,li,100)

SetPgEject(.F.) //CONCLUI A CONTRUCAO DA PAG
oPrinter:Preview() // APRESENTA A PAG

(cAlias)->(dbCloseArea())

Return

Static Function VerifLinha(li)

Local oCourier8N	:=	TFont():New("Courier New",,8,,.T.,,,,,.F.,.F.)
Local oCambr9N	:=	TFont():New("Cambria",,9,,.T.,,,,,.F.,.F.)

If li>=(nLinFim-50)
	oPrinter:Line(3300,2200,3300,100)
	oPrinter:EndPage()
    
	li := 0540

	ImpCab()

EndIf

Return li


Static Function ImpCab()

Local oCourier11N	:=	TFont():New("Courier New",,11,,.T.,,,,,.F.,.F.)
Local oCourier8N	:=	TFont():New("Courier New",,8,,.T.,,,,,.F.,.F.)
Local oArial11N	:=	TFont():New("Arial Black",,11,,.T.,,,,,.F.,.F.)
Local oCambr19N	:=	TFont():New("Cambria",,19,,.T.,,,,,.F.,.F.)
Local oCambr16N	:=	TFont():New("Cambria",,16,,.T.,,,,,.F.,.F.)
Local oCambr10N	:=	TFont():New("Cambria",,10,,.T.,,,,,.F.,.F.)

oPrinter:StartPage()	
	
oPrinter:Say(0240,0650,"Valor Comissões Vendedor: "+cVendedor,oCambr19N,,0)
oPrinter:Say(0290,0650,"Referente a data "+DTOC(MV_PAR03)+" - "+DTOC(MV_PAR04),oCambr16N,,0)
oPrinter:Say(0390,0150,"Crédito Comissões ",oCambr16N,,0)

oPrinter:Say(0490,0150,"Data"			,oCambr10N,,0)
oPrinter:Say(0490,0350,"NFiscal"		,oCambr10N,,0)
oPrinter:Say(0490,0650,"Pedido"			,oCambr10N,,0)
oPrinter:Say(0490,0850,"Orcamento"		,oCambr10N,,0)
oPrinter:Say(0490,1050,"Razão Social"	,oCambr10N,,0)
oPrinter:Say(0490,1815,"Vlr. Pedido"	,oCambr10N,,0)
oPrinter:Say(0490,2030,"Comissão"		,oCambr10N,,0)

Return


Static Function ImpCab2(li)

Local cQuery2 := ""
LOCAL cAlias2 := GetNextAlias()
Local oCourier11N	:=	TFont():New("Courier New",,11,,.T.,,,,,.F.,.F.)
Local oCourier8N	:=	TFont():New("Courier New",,8,,.T.,,,,,.F.,.F.)
Local oArial11N	:=	TFont():New("Arial Black",,11,,.T.,,,,,.F.,.F.)
Local oCambr19N	:=	TFont():New("Cambria",,19,,.T.,,,,,.F.,.F.)
Local oCambr16N	:=	TFont():New("Cambria",,16,,.T.,,,,,.F.,.F.)
Local oCambr10N	:=	TFont():New("Cambria",,10,,.T.,,,,,.F.,.F.)
Local _nRec     := 0
PRIVATE _nCntImpr2 := 0
Private nE2Valor := 0

oPrinter:SetPortrait()

oPrinter:Say(li,0150,"Créditos:",oCambr16N,,0)

li:=VerifLinha(li)
li+=nQlin+nQlin

oPrinter:Say(li,0150,"Data",oCambr10N,,0)
oPrinter:Say(li,0350,"Duplicata",oCambr10N,,0)
oPrinter:Say(li,0550,"Descrição",oCambr10N,,0)
oPrinter:Say(li,2075,"Valor",oCambr10N,,0)

//----> IMPRIME TODAS OU SOMENTE SW
IF MV_PAR05 == 1 .OR. MV_PAR05 == 2
	cQuery2 += " SELECT E2_EMISSAO, E2_NUM, X5_DESCRI, E2_VALOR FROM SE2010 SE2 "
	cQuery2 += " INNER JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_FORNECE = E2_FORNECE AND A3_LOJA = E2_LOJA AND A3_COD = '"+cCodVend+"' "
	cQuery2 += " LEFT JOIN SX5010 SX5 ON SX5.D_E_L_E_T_<>'*' AND X5_CHAVE = E2_TIPO AND X5_TABELA = '05' "
	cQuery2 += " WHERE SE2.D_E_L_E_T_<>'*' AND E2_PREFIXO <> 'COM' AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND E2_TIPO <> 'PA' "
ENDIF

//----> IMPRIME TODAS (UNIAO DAS SELECTS)
IF MV_PAR05 == 1
	cQuery2 += " UNION ALL
ENDIF

//----> IMPRIME TODAS OU SOMENTE WOLKE
IF MV_PAR05 == 1 .OR. MV_PAR05 == 3
	cQuery2 += " SELECT E2_EMISSAO, E2_NUM, X5_DESCRI, E2_VALOR FROM SE2020 SE2 "
	cQuery2 += " INNER JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_FORNECE = E2_FORNECE AND A3_LOJA = E2_LOJA AND A3_COD = '"+cCodVend+"' "
	cQuery2 += " LEFT JOIN SX5010 SX5 ON SX5.D_E_L_E_T_<>'*' AND X5_CHAVE = E2_TIPO AND X5_TABELA = '05' "
	cQuery2 += " WHERE SE2.D_E_L_E_T_<>'*' AND E2_PREFIXO <> 'COM' AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND E2_TIPO <> 'PA' "
ENDIF
cQuery2 += " ORDER BY E2_EMISSAO,E2_NUM "

TCQUERY cQuery2 NEW ALIAS (cAlias2)
ProcRegua(_nRec)

li:=VerifLinha(li)
li+=nQlin

WHILE (cAlias2)->(!EOF())
	oPrinter:Say(li,0150,DTOC(STOD((cAlias2)->E2_EMISSAO)),oFont08)             //E3_EMISSAO
	oPrinter:Say(li,0350,ALLTRIM((cAlias2)->E2_NUM),oFont08)             //NUMERO DUPLICATA
	oPrinter:Say(li,0550,ALLTRIM((cAlias2)->X5_DESCRI),oFont08)             //DESCRIÇÃO
	oPrinter:Say(li,2150,Transform((cAlias2)->E2_VALOR,"@E 999,999,999.99"),oFont08,,,,1) //Valor
	
	nE2Valor += (cAlias2)->E2_VALOR
	
	li:=VerifLinha(li)
	li+=nQlin
	_nCntImpr2++

	IncProc()
	(cAlias2)->(DbSkip())
Enddo

li+=nQlin

(cAlias2)->(dbCloseArea())

IF _nCntImpr2 > 0
	oPrinter:Line(li,2200,li,100)

	li:=VerifLinha(li)
	li+=nQlin

	oPrinter:Say(li,1300,"Totais",oFont08,,,,1) //Valor pedido E3_BASE
	oPrinter:Say(li,2150,"R$"+Transform(nE2Valor,"@E 999,999,999.99"),oFont08,,,,1) //Valor total pedido

	li:=VerifLinha(li)
	li+=nQlin

	oPrinter:Line(li,2200,li,100)

	li:=VerifLinha(li)
	li+=nQlin
ENDIF

ImpCab3(li)

nPedido := 0
nComis  := 0

Return


Static Function ImpCab3(li)

Local cQuery3 := ""
LOCAL cAlias3 := GetNextAlias()
Local oCourier11N	:=	TFont():New("Courier New",,11,,.T.,,,,,.F.,.F.)
Local oCourier8N	:=	TFont():New("Courier New",,9,,.T.,,,,,.F.,.F.)
Local oArial11N	:=	TFont():New("Arial Black",,11,,.T.,,,,,.F.,.F.)
Local oCambr19N	:=	TFont():New("Cambria",,19,,.T.,,,,,.F.,.F.)
Local oCambr16N	:=	TFont():New("Cambria",,16,,.T.,,,,,.F.,.F.)
Local oCambr10N	:=	TFont():New("Cambria",,10,,.T.,,,,,.F.,.F.)
Local _nRec     := 0
Private nDebito := 0
PRIVATE _nCntImpr3 := 0

oPrinter:SetPortrait()

oPrinter:Say(li,0150,"Débitos:",oCambr16N,,0)
li:=VerifLinha(li)
li+=nQlin+nQlin
oPrinter:Say(li,0150,"Data",oCambr10N,,0)
oPrinter:Say(li,0350,"Duplicata",oCambr10N,,0)
oPrinter:Say(li,0550,"Descrição",oCambr10N,,0)
oPrinter:Say(li,2075,"Valor",oCambr10N,,0)

IF MV_PAR05 == 1 .OR. MV_PAR05 == 2
	cQuery3 += " SELECT E2_BAIXA, E2_NUM, X5_DESCRI, E2_VALOR, E2_SALDO FROM SE2010 SE2 "
	cQuery3 += " INNER JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_FORNECE = E2_FORNECE AND A3_LOJA = E2_LOJA AND A3_COD = '"+cCodVend+"' "
	cQuery3 += " LEFT JOIN SX5010 SX5 ON SX5.D_E_L_E_T_<>'*' AND X5_CHAVE = E2_TIPO AND X5_TABELA = '05' "
	cQuery3 += " WHERE SE2.D_E_L_E_T_<>'*' AND E2_BAIXA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "//AND E2_TIPO <> 'PA'
ENDIF

IF MV_PAR05 == 1
	cQuery3 += " UNION ALL "
ENDIF

IF MV_PAR05 == 1 .OR. MV_PAR05 == 3
	cQuery3 += " SELECT E2_BAIXA, E2_NUM, X5_DESCRI, E2_VALOR, E2_SALDO FROM SE2020 SE2 "
	cQuery3 += " INNER JOIN SA3010 SA3 ON SA3.D_E_L_E_T_<>'*' AND A3_FORNECE = E2_FORNECE AND A3_LOJA = E2_LOJA AND A3_COD = '"+cCodVend+"' "
	cQuery3 += " LEFT JOIN SX5020 SX5 ON SX5.D_E_L_E_T_<>'*' AND X5_CHAVE = E2_TIPO AND X5_TABELA = '05' "
	cQuery3 += " WHERE SE2.D_E_L_E_T_<>'*' AND E2_BAIXA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " //AND E2_TIPO <> 'PA'
ENDIF
cQuery3 += " ORDER BY E2_BAIXA,E2_NUM "

TCQUERY cQuery3 NEW ALIAS (cAlias3)
ProcRegua(_nRec)

li:=VerifLinha(li)
li+=nQlin

WHILE (cAlias3)->(!EOF())
	oPrinter:Say(li,0150,DTOC(STOD((cAlias3)->E2_BAIXA)),oFont08)             //E3_EMISSAO
	oPrinter:Say(li,0350,ALLTRIM((cAlias3)->E2_NUM),oFont08)             //NUMERO DUPLICATA
	oPrinter:Say(li,0550,ALLTRIM((cAlias3)->X5_DESCRI),oFont08)             //DESCRIÇÃO
	oPrinter:Say(li,2150,Transform(((cAlias3)->E2_VALOR-(cAlias3)->E2_SALDO),"@E 999,999,999.99"),oFont08,,,,1) //Valor
	
	nDebito += (cAlias3)->E2_VALOR-(cAlias3)->E2_SALDO
	
	li:=VerifLinha(li)
	li+=nQlin

	_nCntImpr3++

	IncProc()
	(cAlias3)->(DbSkip())
Enddo

li:=VerifLinha(li)
li+=nQlin
(cAlias3)->(dbCloseArea())

IF _nCntImpr3 > 0
	oPrinter:Line(li,2200,li,100)

	li:=VerifLinha(li)
	li+=nQlin

	oPrinter:Say(li,1300,"Totais",oFont08,,,,1) //Valor pedido E3_BASE
	oPrinter:Say(li,2150,"R$"+Transform(nDebito,"@E 999,999,999.99"),oFont08,,,,1) //Valor total debito

	li:=VerifLinha(li)
	li+=nQlin

	oPrinter:Line(li,2200,li,100)

	li:=VerifLinha(li)
	li+=nQlin
ENDIF

IF (_nCntImpr3+_nCntImpr2+_nCntImpr) == 0
	MsgBox("Arquivo vazio!","Atenção","ALERT")
	return
ENDIF

li:=VerifLinha(li)
li+=nQlin

nCredito := nE2Valor+nComis

oPrinter:Say(li,0150,"Total Geral: ",oCambr16N,,0)
oPrinter:Say(li,1300,"Total Créditos:",oFont08) //Valor pedido E3_BASE
oPrinter:Say(li,2150,"R$"+Transform(nCredito,"@E 999,999,999.99"),oFont08,,,,1) //Valor total debito

li:=VerifLinha(li)
li+=nQlin

oPrinter:Say(li,1300,"Total Débitos:",oFont08) //Valor pedido E3_BASE
oPrinter:Say(li,2150,"R$"+Transform(nDebito,"@E 999,999,999.99"),oFont08,,,,1) //Valor total debito

li:=VerifLinha(li)
li+=nQlin

oPrinter:Say(li,1300,"Líquido:",oFont08) //Valor pedido E3_BASE
oPrinter:Say(li,2150,"R$"+Transform((nCredito-nDebito),"@E 999,999,999.99"),oFont08,,,,1) //Valor total debito

li:=VerifLinha(li)
li+=nQlin

oPrinter:Line(li,2200,li,100)

Return                 

