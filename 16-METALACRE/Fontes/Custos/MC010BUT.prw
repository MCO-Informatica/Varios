#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'
#INCLUDE "FIVEWIN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MC010BUT Autor ³ Luiz Alberto        ³ Data ³ 03/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Botao Exporta Excel na Formacao de Precos         ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

User Function MC010BUT()
Local oDlg        := ParamIxb[1]  // Obj da planilha
Local aPosObj     := ParamIxb[2]  // Obj das posicoes p/ os botões na tela
Local aProd       := ParamIxb[3]  // Estrutura utilizada p/ a Planilha
Local aFormulas   := ParamIxb[4]  // Array das Formulas da Planilha
Local aTot        := ParamIxb[5]  // Array dos Totais da Planilha
Local lRet        := .F.          // Define se desabilita o botão 'PLANILHA'

Public nSimulados	:=	GetNewPar("MV_XFPSIM",1.00)
Public _dDataCtb	:=	GetNewPar("MV_XFPDTC",dDataBase)
Public _nIcmsSP		:=	GetNewPar("MV_XFPISP",18.00)
Public _nIcmsSE		:=	GetNewPar("MV_XFPISE",12.00)
Public _nIcmsNE		:=	GetNewPar("MV_XFPINE",07.00)
Public _nComis		:=	GetNewPar("MV_XFPCOM",00.00)
Public _nMargem		:=	GetNewPar("MV_XFPMRG",10.00)
Public _nMargem		:=	GetNewPar("MV_XFPMRG",10.00)
Public _nPlanilha	:=  GetNewPar("MV_XFPPLN",1)		// Tipo Planilha 1- Simulado, 2-Faturado, 3-Produzido
Public _nRescisao	:=	GetNewPar("MV_XFPRES",1)		// Abate Rescisão? 1 - Sim, 2 - Não
Public nProduzido	:= U_RESTA012()	
Public nFaturados	:= U_RESTA013()
Public nVlrFatura	:= U_RESTA018()	
Public nQuantidade  := Iif(_nPlanilha==1,nSimulados,Iif(_nPlanilha==2,U_RESTA013(),Iif(_nPlanilha==3,U_RESTA012(),nQuantidade)) )
Public cTit			:= ''
Public _nLinha       := Iif(Type("n")<>"U",n,1)

_nPlanilha := Iif(FunName()$"MATA410",4,1)

If _nPlanilha == 1
	cTit := 'SIMULADO'
ElseIf _nPlanilha == 2
	cTit := 'FATURADO'
ElseIf _nPlanilha == 3
	cTit := 'PRODUZIDO'
ElseIf _nPlanilha == 4
	cTit := 'PEDIDO VENDA'
	nQuantidade := aCols[_nLinha,6]
Endif

Public aCustos		:= {{'004','1.1',"1.1.999.999",0.00000000},;
						{'005','2.1',"2.1.999.999",0.00000000},;
						{'006','3.1',"3.1.999.999",0.00000000},;
						{'007','1.2.013',"1.2.013.000",0.00000000},;
						{'008','1.2.015',"1.2.015.000",0.00000000},;
						{'009','1.2.016',"1.2.016.000",0.00000000},;
						{'010','1.2.028',"1.2.028.000",0.00000000},;
						{'011','1.2.029',"1.2.029.000",0.00000000},;
						{'014','1.1',"1.1.999.999",0.00000000},;
						{'015',"2.1","2.1.999.999",0.00000000},;
						{'016',"3.1","3.1.999.999",0.00000000},;
						{'017',"4.2.000.999","4.2.000.999",0.00000000}}

cTitulo := cTit 
aCustos := U_RESTATTT(@aCustos)

@ aPosObj[1,4]-95,aPosObj[1,3]-33 BUTTON oBtn1 Prompt 'Variáveis' SIZE 30, 11 OF oDlg PIXEL Action U_FVlrSimul() //-- No ex.acima, o botão IMPRIME ('TYPE 6') foi criado p/ a Impressão da planilha, utilizando função de usuário customizada U_IMPRIME(), por exemplo.//-- Obs.: OUTRO USO PARA O PONTO DE ENTRADA://--       Ao retornar .T. o botão 'PLANILHA' será DESABILITADO.
@ aPosObj[1,4]-80,aPosObj[1,3]-33 BUTTON oBtn2 Prompt 'Imprimir' SIZE 30, 11 OF oDlg PIXEL Action U_ImpFPreco(aProd,aFormulas,aTot,cTit)

Return (lRet)


User Function ImpFPreco(aProd,aFormulas,aTot,cTitulo)
Local aArea := GetArea()    

// atualiza valores

For nArray := 1 To Len(aArray)
	nAchou := Ascan(aTot,{|x| AllTrim(x[1])==AllTrim(Str(aArray[nArray,1]))})
	If !Empty(nAchou)
		aTot[nAchou,4]	:= TransForm(aArray[nArray,6],"@E 9,999,999.99999999")
		aTot[nAchou,5]	:= TransForm(aArray[nArray,7],"@E 9,999.99")
	Endif
Next

cTitulo := 'FORMACAO DE PRECO - ' + AllTrim(cTitulo) + " - Ref: " + DtoC(_dDataCtb)

oPrn  := TMSPrinter():New()
oPrn:SetPortrait()
If !oPrn:Setup()
	Return
Endif

cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")

oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,14,,.T.,,,,,.f. )
oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont3b := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont4b := TFont():New( "Arial",,10,,.T.,,,,,.f. )
oFont5 := TFont():New( "Arial",,06,,.t.,,,,,.f. )
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont6b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont7b := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont18:= TFont():New( "Arial",,18,,.t.,,,,,.f. )
oFont18S:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
oFont24:= TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont14:= TFont():New( "Arial",,14,,.t.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,08,,.t.,,,,,.f. )
oFont6c := TFont():New( "Courier New",,08,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
oFont8c := TFont():New( "Courier New",,09,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,11,,.t.,,,,,.f. )
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
oBrush  := TBrush():NEW("",CLR_HGRAY)          

nLin := 5000 

For nIt := 1 To Len(AARRAY)
	If '--'$AARRAY[nIt,2]
		Loop
	Endif

	If nLin > 3000
		If nLin <> 5000
			oPrn:EndPage()
		Endif	
		Cabec(aProd,.T.,cTitulo)
	Endif
	
	oPrn:Say( nLin, 0022, AllTrim(Str(AARRAY[nIt,1])),oFont6c,100 )
	oPrn:Say( nLin, 0080, AllTrim(AARRAY[nIt,2]),oFont6c,100 )
	oPrn:Say( nLin, 0150, AARRAY[nIt,3],oFont5,100 )
	oPrn:Say( nLin, 0700, AARRAY[nIt,4],oFont8c,100 )
	oPrn:Say( nLin, 1000, TransForm(AARRAY[nIt,5],'@E 9,999.999999'),oFont8c,100 )
	oPrn:Say( nLin, 1400, TransForm(AARRAY[nIt,6],'@E 9,999.9999999'),oFont8c,100 )
	oPrn:Say( nLin, 2000, TransForm(AARRAY[nIt,7],'@E 9,999.99'),oFont8c,100 )
	
	nLin += 50
Next

Cabec2()

For nIt := 1 To Len(aTot)
	If nLin > 3000
		If nLin <> 5000
			oPrn:EndPage()
			Cabec(aProd,.F.,cTitulo)
			nLin := 420
		Endif
		Cabec2()
	Endif

	oPrn:Say( nLin, 0022, AllTrim(aTot[nIt,1]),oFont6c,100 )
	oPrn:Say( nLin, 0100, aTot[nIt,2],oFont8c,100 )
	oPrn:Say( nLin, 0600, aTot[nIt,4],oFont8c,100 )
	oPrn:Say( nLin, 1200, aTot[nIt,5],oFont8c,100 )
	oPrn:Say( nLin, 1450, aTot[nIt,3],oFont5,100 )
	
	nLin += 50
Next
oPrn:EndPage()
oPrn:Print()
Return

Static Function Cabec(aProd,lTitCol,cTitulo)
oPrn:StartPage()
oPrn:Say( 0050, 0020, " ",oFont1,100 ) // startando a impressora

oPrn:Box( 0050, 0020, 3200, 2300) // Box Total  
oPrn:Box( 0050, 0020, 0400, 2300) // Box Divisao Cabecalho
oPrn:Box( 0500, 0020, 0500, 2300) // Box Divisao Cabecalho

cLogo      	:= FisxLogo("1")

oPrn:SayBitmap( 0080,030,cLogo,0200,0200)

oPrn:Say( 0050, 0500, cTitulo,oFont14,100 )//'FORMAÇÃO DE PREÇO ' 

//SGA->(dbGoTo(_nRecSGA))
// + ' (' + AllTrim(SGA->GA_OPC)+' - '+AllTrim(Capital(SGA->GA_DESCOPC))+') '
oPrn:Say( 0100, 0400, 'Produto: ' + AllTrim(aProd[1,4]) + ' - ' + AllTrim(Capital(aProd[1,3])),oFont7b,100 )

oPrn:Say( 0015, 1800, 'Emissao/Hora: ' + DtoC(dDataBase)+' / '+Time(),oFont6,100 )

oPrn:Say( 0170, 0400, SM0->M0_NOMECOM,oFont14,100 )
oPrn:Say( 0250, 0400, SM0->M0_ENDENT,oFont9,100 )
oPrn:Say( 0300, 0400, TransForm(SM0->M0_CEPENT,cCepPict) + ' - ' + AllTrim(SM0->M0_CIDENT) + ' - ' + AllTrim(SM0->M0_ESTENT),oFont9,100 )
oPrn:Say( 0350, 0400, 'CNPJ: ' + TransForm(SM0->M0_CGC,cCGCPict) + ' IE.: ' + SM0->M0_INSC,oFont9,100 )

oPrn:Say( 0350, 1500, 'Qtde: ' + TransForm(nQuantidade,'@E 9,999,999.9'),oFont14,100 )
/*If 'FATURADO'$cTitulo .Or. 'FAT_SPEED'$cTitulo
	oPrn:Say( 0350, 1500, 'Qtde: ' + TransForm(nFaturados,'@E 9,999,999.9'),oFont14,100 )
ElseIf 'PRODUZIDO'$cTitulo .Or. 'PRD_SPEED'$cTitulo
	oPrn:Say( 0350, 1500, 'Qtde: ' + TransForm(nProduzido,'@E 9,999,999.9'),oFont14,100 )
ElseIf 'SIMULA'$cTitulo
	oPrn:Say( 0350, 1500, 'Qtde: ' + TransForm(nSimulados,'@E 9,999,999.9'),oFont14,100 )
Endif
  */                                 
If lTitCol
	oPrn:Say( 0420, 0022, 'Cel' ,oFont6c,100 )
	oPrn:Say( 0420, 0080, 'Niv' ,oFont6c,100 )
	oPrn:Say( 0420, 0150, 'Descricao' ,oFont9c,100 )
	oPrn:Say( 0420, 0700, 'Codigo' ,oFont9c,100 )
	oPrn:Say( 0420, 1000, 'Quantidade' ,oFont9c,100 )
	oPrn:Say( 0420, 1500, 'Valor Total' ,oFont9c,100 )
	oPrn:Say( 0420, 1980, '(%) Partic' ,oFont9c,100 )
	
	nLin := 520
Else
	nLin := 420
Endif

Return


Static Function Cabec2()
oPrn:Box( nLin, 0020, nLin+100, 2300) // Box Total  

oPrn:Say( nLin+20, 0022, 'Cel' ,oFont6c,100 )
oPrn:Say( nLin+20, 0100, 'Descricao' ,oFont9c,100 )
oPrn:Say( nLin+20, 0750, 'Valor Total' ,oFont9c,100 )
oPrn:Say( nLin+20, 1150, '(%) Part' ,oFont9c,100 )
oPrn:Say( nLin+20, 1450, 'Formula' ,oFont9c,100 )

nLin += 120


Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ AtuMailCli Autor   ³ Luiz Alberto ³ Data ³ 11/11/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Atualização Campo Email Depto Financeiro do Cliente³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FVlrSimul(lProcessa)
Local aArea 	:= GetArea()
Local nVlrSim 	:= nSimulados
Local dDataCtb	:= _dDataCtb
Local nIcmsSP	:= _nIcmsSP
Local nIcmsSE	:= _nIcmsSE
Local nIcmsNE	:= _nIcmsNE
Local nComis	:= _nComis
Local nMargem	:= _nMargem
Local nPlanilha	:= _nPlanilha
Local nRescisao	:= _nRescisao
Local aPlanilha := {'1 - Simulado','2 - Faturado','3 - Produzido','4 - Pedido Vendas'}
Local aRescisao	:= {'1 - Sim','2 - Não'}
Local oEdit1, oEdit2, oEdit3, oEdit4, oEdit5, oEdit6, oEdit7
Local _oDlgDt	// Dialog Principal

DEFAULT lProcessa := .T.

//DEFINE MSDIALOG _oDlgDt TITLE "Valor da Silumação" FROM C(266),C(315) TO C(339),C(600) PIXEL //Style DS_MODALFRAME 
DEFINE MSDIALOG _oDlgDt TITLE "Parâmetros Custos" FROM C(266),C(315) TO C(580),C(600) PIXEL //Style DS_MODALFRAME 
//_oDlgDt:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC
// Cria Componentes Padroes do Sistema
@ C(005),C(045) MsGet oEdit1 Var dDataCTB Valid(!Empty(dDataCtb)) Picture "@R 99/99/9999" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(006),C(007) Say "Data Contabil: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(015),C(045) MsGet oEdit2 Var nVlrSim Valid(!Empty(nVlrSim)) Picture "@E 9,999,999.9" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(016),C(007) Say "Qtde Simulação: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(025),C(045) MsGet oEdit3 Var nIcmsSP Picture "@E 99.99" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(026),C(007) Say "% ICMS SP: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(035),C(045) MsGet oEdit4 Var nICMSSE  Picture "@E 99.99" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(036),C(007) Say "% ICMS S/SE: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(045),C(045) MsGet oEdit5 Var nICMSNE Picture "@E 99.99" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(046),C(007) Say "% ICMS N/NE: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(055),C(045) MsGet oEdit6 Var nComis Picture "@E 99.99" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(056),C(007) Say "% Comissão Ext: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(065),C(045) MsGet oEdit7 Var nMargem  Picture "@E 99.99" Size C(50),C(009) COLOR CLR_BLACK PIXEL OF _oDlgDt
@ C(066),C(007) Say "% Margem Contrib: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(075),C(045) MsComboBox oPlanilha Var nPlanilha Items aPlanilha Size 100, 010 Of _oDlgDt Pixel On Change (nPlanilha := oPlanilha:nAt)
@ C(076),C(007) Say "Tipo Planilha: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(085),C(045) MsComboBox oRescisao Var nRescisao Items aRescisao Size 100, 010 Of _oDlgDt Pixel On Change (nRescisao := oRescisao:nAt)
@ C(086),C(007) Say "Anula Rescisão: " Size C(037),C(006) COLOR CLR_BLACK PIXEL OF _oDlgDt

@ C(102),C(025) Button "&Confirme" Size C(037),C(012) ACTION (_oDlgDt:End()) PIXEL OF _oDlgDt

ACTIVATE MSDIALOG _oDlgDt CENTERED

nSimulados	:=	nVlrSim
_dDataCtb	:=	dDataCtb
_nIcmsSP	:= 	nIcmsSP
_nIcmsSE	:= 	nIcmsSE
_nIcmsNE	:=  nIcmsNE
_nComis		:= 	nComis
_nMargem	:= 	nMargem
_nPlanilha	:= 	nPlanilha
_nRescisao	:=	nRescisao

PutMV("MV_XFPSIM",nSimulados)
PutMV("MV_XFPDTC",_dDataCtb)
PutMV("MV_XFPISP",_nIcmsSP)
PutMV("MV_XFPISE",_nIcmsSE)
PutMV("MV_XFPINE",_nIcmsNE)
PutMV("MV_XFPCOM",_nComis)
PutMV("MV_XFPMRG",_nMargem)
PutMV("MV_XFPPLN",_nPlanilha)
PutMV("MV_XFPRES",_nRescisao)

nQuantidade  := Iif(_nPlanilha==1,nSimulados,Iif(_nPlanilha==2,U_RESTA013(),U_RESTA012()) )

If _nPlanilha == 4 .And. !FunName()$"MATA410"
 	_nPlanilha := 1
 	MsgStop("Planilha Tipo Pedido de Vendas, Apenas na Tela de Pedidos !")
Endif

If _nPlanilha == 1
	cTit := 'SIMULADO'
ElseIf _nPlanilha == 2
	cTit := 'FATURADO'
ElseIf _nPlanilha == 3
	cTit := 'PRODUZIDO'
ElseIf _nPlanilha == 4
	cTit := 'PEDIDO VENDA'
	nQuantidade := aCols[_nLinha,6]
Endif

If lProcessa
	aCustos := U_RESTATTT(@aCustos,.F.)
Endif

RestArea(aArea)
Return .T.

User Function MC010ARR()
Local aPlanilha   := PARAMIXB[1]
Local cArquivo    := PARAMIXB[2]

//-- Tratamento especifico

 /*Public aCustos		:= {{'003','4.2',"4.2.000.999",0.00000000},;
						{'004','1.1',"1.1.000.998",0.00000000},;
						{'005','2.1',"2.1.000.998",0.00000000},;
						{'006','3.1',"3.1.000.998",0.00000000},;
						{'007','1.2.013',"1.2.013.000",0.00000000},;
						{'008','1.2.015',"1.2.015.000",0.00000000},;
						{'009','1.2.016',"1.2.016.000",0.00000000},;
						{'010','1.2.028',"1.2.028.000",0.00000000},;
						{'011','1.2.029',"1.2.029.000",0.00000000},;
						{'014','1.1.000.999',"1.1.000.999",0.00000000},;
						{'015',"2.1.000.999","2.1.000.999",0.00000000},;
						{'016',"3.1.000.999","3.1.000.999",0.00000000}}*/

Public aCustos		:= {{'004','1.1',"1.1.999.999",0.00000000},;
						{'005','2.1',"2.1.999.999",0.00000000},;
						{'006','3.1',"3.1.999.999",0.00000000},;
						{'007','1.2.013',"1.2.013.000",0.00000000},;
						{'008','1.2.015',"1.2.015.000",0.00000000},;
						{'009','1.2.016',"1.2.016.000",0.00000000},;
						{'010','1.2.028',"1.2.028.000",0.00000000},;
						{'011','1.2.029',"1.2.029.000",0.00000000},;
						{'014','1.1',"1.1.999.999",0.00000000},;
						{'015',"2.1","2.1.999.999",0.00000000},;
						{'016',"3.1","3.1.999.999",0.00000000},;
						{'017',"4.2.000.999","4.2.000.999",0.00000000}}

aCustos := U_RESTATTT(@aCustos)

Return Nil