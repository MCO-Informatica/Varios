#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Restat1  ³ Autor ³ Luiz Alberto V Alves ³ Data ³ Abril/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Estatisticas de Venda SealBag  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Metalacre                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function REstat1()
Local cDescri       := " "
LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RESTAT1"
LOCAL cDesc1	    := "Relatorio de Estatisca Vendas SealBag"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico Metalacre"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RESTAT1",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RESTAT1"
PRIVATE lEnd        := .F.
PRIVATE nLastKey	:= 0
PRIVATE nBegin		:= 0
PRIVATE nDifColCC   := 0
PRIVATE aLinha		:= {}
PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE M_PAG	    := 1
Private lEnd        := .F.
Private oPrint
PRIVATE nSalto      := 50
PRIVATE lFirstPage  := .T.
Private oBrush  := TBrush():NEW("",CLR_HGRAY)          
Private oBrushG  := TBrush():NEW("",CLR_YELLOW)          
Private oPen		:= TPen():New(0,5,CLR_BLACK)
PRIVATE oCouNew08	:= TFont():New("Courier New"	,08,08,,.F.,,,,.T.,.F.)
PRIVATE oCouNew08N	:= TFont():New("Courier New"	,08,08,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew09N	:= TFont():New("Courier New"	,09,09,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12N	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11N	:= TFont():New("Courier New"	,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11 	:= TFont():New("Courier New"	,11,11,,.F.,,,,.T.,.F.)                 
PRIVATE oArial08N	:= TFont():New("Arial"			,08,08,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial10N	:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial11N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial12N	:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial14N	:= TFont():New("Arial"			,14,14,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12S	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		// SubLinhado
PRIVATE cContato    := ""
PRIVATE cNomFor     := ""
Private nReg 			:= 0


AjustaSx1(cPerg)
Pergunte(cPerg,.f.)
//IF ! Pergunte(cPerg,.T.)
//	Return
//Endif

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Estatistica SealBag")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)
@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)

@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )
ACTIVATE DIALOG oDlg CENTERED



IF nOpcRel == 1 
	Processa({ |lEnd| COMR01Cfg("Impressao Relatório de Estatistica SealBag")},"Imprimindo , aguarde...")
	Processa({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³COMR01Cfg ³ Autor ³ Luiz Alberto    ³ Data ³20/02/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria os objetos para relat. grafico.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function COMR01Cfg(Titulo)
Local cFilename := 'RelEst'
Local i 	 := 1
Local x 	 := 0

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetLandsCape()
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
cDiretorio := oPrint:cPathPDF

If	MAKEDIR('C:\TEMP')!= 0
	//		Aviso(STR0001,STR0026+cPathOri+STR0027,{"OK"}) //"Inconsistencia"###"Nao foi possivel criar diretorio "###".Finalizando ..."
	return nil
EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Luiz Alberto     ³ Data ³ 20.02.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110	    		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C110PC(lEnd,WnRel,cString,nReg)
Private cCGCPict, cCepPict

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQueryCad := "	SELECT DISTINCT C5_EMISSAO, A1_COD, A1_LOJA, A1_NOME, A1_ESTADO, A1_MUNE, A1_ESTE, A1_SEXO, C5_WBHORA, C5_DESCONT, C5_PEDWEB, D2_PEDIDO, D2_DOC, D2_SERIE, D2_COD, D2_QUANT, D2_PRCVEN, D2_VALFRE, D2_TOTAL "
cQueryCad += "  FROM " + RetSqlName("SD2") + " D2, " + RetSqlName("SA1") + " A1, " + RetSqlName("SC5") + " C5 "
cQueryCad += "  WHERE C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
cQueryCad += "  AND D2_CLIENTE = A1_COD "
cQueryCad += "  AND D2_LOJA = A1_LOJA "
cQueryCad += "  AND D2_PEDIDO = C5_NUM "
cQueryCad += "  AND C5_PEDWEB <> '' "
cQueryCad += "  AND D2_FILIAL = '" + xFilial("SD2") + "' "
cQueryCad += "  AND C5_FILIAL = '" + xFilial("SC5") + "' "
cQueryCad += "  AND D2.D_E_L_E_T_ = '' "
cQueryCad += "  AND C5.D_E_L_E_T_ = '' "
cQueryCad += "  AND A1.D_E_L_E_T_ = '' "
cQueryCad += "  AND C5.C5_CLIENTE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR05 + "' "
cQueryCad += "  AND C5.C5_LOJACLI BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' "
cQueryCad += "  AND A1.A1_ESTE    BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
If !Empty(MV_PAR10)
	cQueryCad += "  AND D2.D2_COD = '" + MV_PAR10 + "' "
Endif
If MV_PAR11 == 1
	cQueryCad += "  AND C5.C5_DESCONT > 0 "
ElseIf MV_PAR11 == 2
	cQueryCad += "  AND C5.C5_DESCONT = 0 "
Endif
cQueryCad += "  ORDER BY C5_EMISSAO "

TCQUERY cQueryCad NEW ALIAS "CADTMP"

TcSetField('CADTMP','C5_EMISSAO','D')

Count To nReg

CADTMP->(dbGoTop())

If Empty(nReg)	
	MsgAlert("Atenção Não Foram Encontrados Dados no Filtro Gerado !","Atenção !")
	CADTMP->(dbCloseArea())
	Return .f.
Endif 

aCabExcel := {}
aIteExcel := {}
//aDt[59] := CHR(160)+aDt[59] //ToXlsFormat(aDt[1])
If MV_PAR09 == 1 // Gera Excel SIM
	AAdd(aCabExcel,"Data")
	AAdd(aCabExcel,"Nome Cliente")
	AAdd(aCabExcel,"Qtd")
	AAdd(aCabExcel,"Emb")
	AAdd(aCabExcel,"Lacres")
	AAdd(aCabExcel,"Vlr+Frete")
	AAdd(aCabExcel,"Desc(%)")
	AAdd(aCabExcel,"Cidade")
	AAdd(aCabExcel,"Estado")
	AAdd(aCabExcel,"Sexo")
	AAdd(aCabExcel,"Pedido Web")
	AAdd(aCabExcel,"Hora Compra")
Endif


li       := 5000
nPg		  := 0
aTotais := {{0,0,0,0},;
		  {0,0,0,0}}

aClientes	:= {}
aResumo1 := {}	// Quadro Regioes
aResumo2 := {{'Masculino',0},;
				{'Feminino',0},;
				{'N.Ident',0}}	// Quadro Publico
aResumo3 := { {'Clientes',0},;
			   {'Lacres',0},;
			   {'Valor c/ Frete',0},;
			   {'Ticket Medio',0}}	// Quadro Total

dEmissao := CtoD('')

ProcRegua(nReg,"Aguarde a Impressao")
While CADTMP->(!Eof())
	IncProc()

	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+CADTMP->A1_COD+CADTMP->A1_LOJA))
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+CADTMP->D2_PEDIDO))
	SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+CADTMP->D2_DOC+CADTMP->D2_SERIE))
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+CADTMP->D2_COD))
	
	If Empty(SB1->B1_SKUMAG)
		CADTMP->(dbSkip(1));Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 1900 .And. MV_PAR09 == 2
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
		dEmissao := CtoD('')
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif
			
	If Empty(dEmissao) .And. MV_PAR09 == 2
		oPrint:Say(li,0040,DtoC(CADTMP->C5_EMISSAO),oArial09N)
		dEmissao := CADTMP->C5_EMISSAO
	ElseIf Empty(dEmissao) .And. MV_PAR09 == 1
		dEmissao := CADTMP->C5_EMISSAO
	Endif             
		
	If  MV_PAR09 == 2
		oPrint:Say(li,0200,CADTMP->A1_COD+'/'+CADTMP->A1_LOJA,oArial09N)
		oPrint:Say(li,0350,Capital(CADTMP->A1_NOME),oArial09N)
		oPrint:Say(li,0900,TransForm((CADTMP->D2_QUANT/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1)),"99999"),oArial09N,,,,1)
		oPrint:Say(li,1000,TransForm(CADTMP->D2_QUANT,"@E 999.9"),oArial09N,,,,1)
		oPrint:Say(li,1100,TransForm(CADTMP->D2_TOTAL+CADTMP->D2_VALFRE,"@E 9,999.99"),oArial09N,,,,1)
		oPrint:Say(li,1200,TransForm(CADTMP->C5_DESCONT,"@E 99.9"),oArial09N,,,,1)
		oPrint:Say(li,1300,Capital(Iif(Empty(CADTMP->A1_MUNE),SA1->A1_MUN,SA1->A1_MUNE)),oArial09N,,,,1)
		oPrint:Say(li,1650,Iif(Empty(CADTMP->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE),oArial09N,,,,1)
		oPrint:Say(li,1800,CADTMP->A1_SEXO,oArial09N,,,,1)
		oPrint:Say(li,2000,CADTMP->C5_PEDWEB,oArial09N,,,,1)
		oPrint:Say(li,2200,CADTMP->C5_WBHORA,oArial09N,,,,1)
	ElseIf  MV_PAR09 == 1
		AAdd(aIteExcel,{DtoC(dEmissao),;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						''})
		
		aIteExcel[Len(aIteExcel),2] := 	CADTMP->A1_COD+'/'+CADTMP->A1_LOJA
		aIteExcel[Len(aIteExcel),3] := 	Capital(CADTMP->A1_NOME)
		aIteExcel[Len(aIteExcel),4] := 	TransForm((CADTMP->D2_QUANT/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1)),"999999")
		aIteExcel[Len(aIteExcel),5] := 	TransForm(CADTMP->D2_QUANT,"@E 99999")
		aIteExcel[Len(aIteExcel),6] := 	TransForm(CADTMP->D2_TOTAL+CADTMP->D2_VALFRE,"@E 99,999,999.99")
		aIteExcel[Len(aIteExcel),7] := 	TransForm(CADTMP->C5_DESCONT,"@E 999.9")
		aIteExcel[Len(aIteExcel),8] := 	Capital(Iif(Empty(CADTMP->A1_MUNE),SA1->A1_MUN,SA1->A1_MUNE))
		aIteExcel[Len(aIteExcel),9] := 	Iif(Empty(CADTMP->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE)
		aIteExcel[Len(aIteExcel),10] := 	CADTMP->A1_SEXO
		aIteExcel[Len(aIteExcel),11] := CADTMP->C5_PEDWEB
		aIteExcel[Len(aIteExcel),12] := CADTMP->C5_WBHORA
    Endif
	
	// Resumo de Regioes
	nAchou := Ascan(aResumo1,{|x| AllTrim(x[5]) == AllTrim(Iif(Empty(CADTMP->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE))} )
	If Empty(nAchou)        
		cEstado := AchEstado(Iif(Empty(CADTMP->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE))
		AAdd(aResumo1,{AllTrim(cEstado),1,0,CADTMP->D2_QUANT,Iif(Empty(CADTMP->A1_ESTE),SA1->A1_EST,SA1->A1_ESTE)})
	Else
		aResumo1[nAchou,2] := aResumo1[nAchou,2] + 1
		aResumo1[nAchou,4] := aResumo1[nAchou,4] + CADTMP->D2_QUANT
	Endif
		 
	// Resumo de Publico	
	nAchou := Ascan(aResumo2,{|x| AllTrim(x[1]) == Iif(CADTMP->A1_SEXO='F','Feminino',Iif(CADTMP->A1_SEXO='M','Masculino','N.Ident'))} )
	aResumo2[nAchou,2] := aResumo2[nAchou,2] + 1
		
	nAchou := Ascan(aClientes, CADTMP->A1_COD+CADTMP->A1_LOJA )
	If Empty(nAchou)
		AAdd(aClientes,CADTMP->A1_COD+CADTMP->A1_LOJA)
	Endif

	// Resumo de Totais
	aResumo3[1,2] := Len(aClientes)
	aResumo3[2,2] := aResumo3[2,2] + CADTMP->D2_QUANT
	aResumo3[3,2] := aResumo3[3,2] + Round(CADTMP->D2_TOTAL+CADTMP->D2_VALFRE,2)
	aResumo3[4,2] := TransForm(Round(aTotais[2,3]/aTotais[2,4],2),"@E 99,999.9")

	aTotais[1,1]	+= (CADTMP->D2_QUANT/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1))
	aTotais[2,1]	+= (CADTMP->D2_QUANT/Iif(SB1->B1_CONV>0,SB1->B1_CONV,1))
	aTotais[1,2]	+= CADTMP->D2_QUANT
	aTotais[2,2]	+= CADTMP->D2_QUANT
	aTotais[1,3]	+= Round(CADTMP->D2_TOTAL+CADTMP->D2_VALFRE,2)
	aTotais[2,3]	+= Round(CADTMP->D2_TOTAL+CADTMP->D2_VALFRE,2)
	aTotais[1,4]++
	aTotais[2,4]++

	li+=50
	
	CADTMP->(DbSkip(1))
	
	If dEmissao <> CADTMP->C5_EMISSAO .Or. CADTMP->(Eof())  .And. MV_PAR09 == 2
		If li <> 5000
			li+=050

			oPrint:Box(li,0030,li+050,2500)
			oPrint:FillRect({li+1,031,li+049,2499},oBrush)
			
			li+=30

			oPrint:Say(li,0300,'Total do Dia ' + DtoC(dEmissao),oArial09N,,,,1)
			
			oPrint:Say(li,0900,TransForm(aTotais[1,1],"999999"),oArial09N,,,,1)
			oPrint:Say(li,1000,TransForm(aTotais[1,2],"@E 99999"),oArial09N,,,,1)
			oPrint:Say(li,1100,TransForm(aTotais[1,3],"@E 99,999,999.99"),oArial09N,,,,1)
			oPrint:Say(li,1500,'Qtd Registros: '+TransForm(aTotais[1,4],"9999"),oArial09N,,,,1)
			
			aTotais[1,1] := 0
			aTotais[1,2] := 0
			aTotais[1,3] := 0
			aTotais[1,4] := 0

			li+=070
		Endif
		dEmissao := CtoD('')                                                       
		Li := 2500
	ElseIf dEmissao <> CADTMP->C5_EMISSAO .Or. CADTMP->(Eof())  .And. MV_PAR09 == 1
		AAdd(aIteExcel,{'',;
						'',;
						'Total do Dia '+DtoC(dEmissao)+': ',;
						TransForm(aTotais[1,1],"999999"),;
						TransForm(aTotais[1,2],"@E 99999"),;
						TransForm(aTotais[1,3],"@E 99,999,999.99"),;
						'Qtd Registros: '+TransForm(aTotais[1,4],"9999"),;
						'',;
						'',;
						'',;
						'',;
						''})

		aTotais[1,1] := 0
		aTotais[1,2] := 0
		aTotais[1,3] := 0
		aTotais[1,4] := 0
		dEmissao := CtoD('')
	Endif
EndDo
If li <> 5000  .And. MV_PAR09 == 2
	li+=050

	oPrint:Box(li,0030,li+050,2500)
	oPrint:FillRect({li+1,031,li+049,2499},oBrush)
			
	li+=30
	oPrint:Say(li,0300,'Total Geral ',oArial09N,,,,1)
			
	oPrint:Say(li,0900,TransForm(aTotais[2,1],"999999"),oArial09N,,,,1)
	oPrint:Say(li,1000,TransForm(aTotais[2,2],"@E 99999"),oArial09N,,,,1)
	oPrint:Say(li,1100,TransForm(aTotais[2,3],"@E 99,999,999.99"),oArial09N,,,,1)
	oPrint:Say(li,1500,'Qtd Registros: '+TransForm(aTotais[2,4],"9999"),oArial09N,,,,1)

	oPrint:EndPage()  				// Visualiza antes de imprimir
	

	ASort( aResumo1,,, { | x, y | x[4] > y[4] } )
	ImpResumo()
	
	For nI := 1 To Iif(Len(aResumo1)<4,4,Len(aResumo1))
		If Li > 2500
			oPrint:EndPage()
			nPg++
			ImpResumo()
		Endif          

		If Len(aResumo1) >= nI
			oPrint:Say(li,0050,Capital(aResumo1[nI,1]),oArial09N,,,,1)
			oPrint:Say(li,0620,TransForm(aResumo1[nI,2],"99999"),oArial09N,,,,1)
			nPerc := Round((aResumo1[nI,2]/Len(aClientes))*100,2)
			oPrint:Say(li,0850,TransForm(nPerc,"@E 9,999.9")+' %',oArial09N,,,,1)
			oPrint:Say(li,1000,TransForm(aResumo1[nI,4],"99999"),oArial09N,,,,1)
		Endif

		If Len(aResumo2) >= nI
			oPrint:Say(li,1300,aResumo2[nI,1],oArial09N,,,,1)
			oPrint:Say(li,1500,TransForm(aResumo2[nI,2],"99999"),oArial09N,,,,1)
			nPerc := Round((aResumo2[nI,2]/Len(aClientes))*100,2)
			oPrint:Say(li,1600,TransForm(nPerc,"@E 9,999.9")+' %',oArial09N,,,,1)
		Endif

		If Len(aResumo3) >= nI
			oPrint:Say(li,1900,aResumo3[nI,1],oArial09N,,,,1)
			If nI == 4
				oPrint:Say(li,2150,aResumo3[nI,2],oArial09N,,,,1)
			ElseIf nI == 2 .Or. nI == 1
				oPrint:Say(li,2100,TransForm(aResumo3[nI,2],"@E 99,999,999.9"),oArial09N,,,,1)
			Else
				oPrint:Say(li,2100,TransForm(aResumo3[nI,2],"@E 99,999,999.99"),oArial09N,,,,1)
			Endif
		Endif  
		
		Li+=50
	Next
	oPrint:Preview()  				// Visualiza antes de imprimir

ElseIf li <> 5000  .And. MV_PAR09 == 1
	AAdd(aIteExcel,{'',;
					'',;
					'Total Geral: ',;
					TransForm(aTotais[2,1],"999999"),;
					TransForm(aTotais[2,2],"@E 99999"),;
					TransForm(aTotais[2,3],"@E 99,999,999.99"),;
					'Qtd Registros: '+TransForm(aTotais[2,4],"9999"),;
					'',;
					'',;
					'',;
					'',;
					''})


	ASort( aResumo1,,, { | x, y | x[4] > y[4] } )

	AAdd(aIteExcel,{'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					''})

	AAdd(aIteExcel,{'',;						// 1
					'Regiões',;					// 2
					'Clientes',;                // 3
					'(%)',;                     // 4
					'Qtde de Lacres',;          // 5
					'Publico',;                 // 6
					'Qtde',;                    // 7
					'(%)',;                     // 8
					'',;                        // 9
					'Tipo',;                    // 10
					'Totais',;
					''})                  // 12
	
	For nI := 1 To Iif(Len(aResumo1)<4,4,Len(aResumo1))
		AAdd(aIteExcel,{'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						'',;
						''})

		If Len(aResumo1) >= nI
			aIteExcel[Len(aIteExcel),2] := Capital(aResumo1[nI,1])
			aIteExcel[Len(aIteExcel),3] := TransForm(aResumo1[nI,2],"99999")
			nPerc := Round((aResumo1[nI,2]/Len(aClientes))*100,2)
			aIteExcel[Len(aIteExcel),4] := TransForm(nPerc,"@E 9,999.9")+' %'
			aIteExcel[Len(aIteExcel),5] := TransForm(aResumo1[nI,4],"99999")
		Endif

		If Len(aResumo2) >= nI
			aIteExcel[Len(aIteExcel),6] := aResumo2[nI,1]
			aIteExcel[Len(aIteExcel),7] := TransForm(aResumo2[nI,2],"9999")
			nPerc := Round((aResumo2[nI,2]/Len(aClientes))*100,2)
			aIteExcel[Len(aIteExcel),8] := TransForm(nPerc,"@E 9,999.9")+' %'
		Endif

		If Len(aResumo3) >= nI
			aIteExcel[Len(aIteExcel),10] := aResumo3[nI,1]
			If nI == 4
				aIteExcel[Len(aIteExcel),11] := aResumo3[nI,2]
			ElseIf nI == 2 .Or. nI == 1
				aIteExcel[Len(aIteExcel),11] := TransForm(aResumo3[nI,2],"@E 99,999,999.9")
			Else
				aIteExcel[Len(aIteExcel),11] := TransForm(aResumo3[nI,2],"@E 99,999,999.99")
			Endif
		Endif  
		
		Li+=50
	Next
Endif
CADTMP->(dbCloseArea())	
If MV_PAR09 == 1	// Gera Planilha
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel", {||DlgToExcel({{"ARRAY","Relatorio Estatistica Vendas SealBag " + OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)),aCabExcel,aIteExcel}})})
Endif
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
Local cMoeda := "1"  

oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(0130,0030,2000,2500 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(nPg,3)),oCouNew08)

oPrint:Say(180,0040,OemToAnsi(SM0->M0_NOME),oArial14N)  

cLacres := ' Todos '
If !Empty(MV_PAR10)
	cLacres := Capital(Posicione("SB1",1,xFilial("SB1")+MV_PAR10,"B1_DESC"))
Endif

oPrint:Say(180,0850,OemToAnsi("Relatório de Estatisticas SEALBAG"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)) + ' Lacre(s): ' + cLacres,oArial11N)  

oPrint:Box(0290,0030,0380,2500)

oPrint:Say(0320,0040,"Data",oArial09N)
oPrint:Say(0320,0200,"Nome Cliente",oArial09N)
oPrint:Say(0320,0900,"Qtd",oArial09N)
oPrint:Say(0350,0900,"Emb",oArial09N)
oPrint:Say(0320,1000,"Lacres",oArial09N)
oPrint:Say(0320,1100,"Vlr+Fr",oArial09N)
oPrint:Say(0320,1200,"Dsc(%)",oArial09N)
oPrint:Say(0320,1300,"Cidade",oArial09N)
oPrint:Say(0320,1650,"Estado",oArial09N)
oPrint:Say(0320,1800,"Sexo",oArial09N)
oPrint:Say(0320,2000,"Pedido Web",oArial09N)
oPrint:Say(0320,2200,"Hora Compra",oArial09N)

li := 420
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpResumo()
Local cMoeda := "1"  

oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(0130,0030,3100,2500 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(080,0030,OemToAnsi("Emitido em " + DtoC(dDataBase) + " as " + Time()),oCouNew08)
oPrint:Say(080,2100,OemToAnsi("Página No. "+Str(nPg,3)),oCouNew08)

oPrint:Say(180,0040,OemToAnsi(SM0->M0_NOME),oArial14N)  

cLacres := ' Todos '
If !Empty(MV_PAR10)
	cLacres := Capital(Posicione("SB1",1,xFilial("SB1")+MV_PAR10,"B1_DESC"))
Endif

oPrint:Say(180,0850,OemToAnsi("Relatório de Estatisticas SEALBAG"),oArial14N)  
oPrint:Say(240,0850,OemToAnsi("Periodo de " + DtoC(MV_PAR01) + ' Até ' + DtoC(MV_PAR02)) + ' Lacre(s): ' + cLacres,oArial11N)  

oPrint:Box(0290,0030,0380,2500)

oPrint:Say(0320,0050,'Regiões',oArial09N,,,,1)
oPrint:Say(0320,0600,'Clientes',oArial09N,,,,1)
oPrint:Say(0320,0850,'(%)',oArial09N,,,,1)
oPrint:Say(0320,0950,'Qtde de Lacres',oArial09N,,,,1)
oPrint:Say(0320,1300,'Publico',oArial09N,,,,1)
oPrint:Say(0320,1500,'Qtde',oArial09N,,,,1)
oPrint:Say(0320,1600,'(%)',oArial09N,,,,1)
oPrint:Say(0320,1900,'Tipo',oArial09N,,,,1)
oPrint:Say(0320,2100,'Totais',oArial09N,,,,1)
		
li := 420
Return 


Static Function AjustaSx1(cPerg)
Local	_nx		:= 0,;
		_nh		:= 0,;
		_nlh	:= 0,;
		_aHelp	:= Array(8,1),;
		_aRegs  := {},;
		_sAlias := Alias(),;
		_aHead	:= {"X1_GRUPO","X1_ORDEM","X1_PERGUNTE","X1_PERSPA","X1_PERENG	",;
					"X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
					"X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEF02",;
					"X1_DEF03","X1_DEF04","X1_DEF05","X1_F3"}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria uma array, contendo todos os valores...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(_aRegs,{cPerg,'01',"Emissao Inicial ?" ,"Emissao Inicial ?" ,"Emissao Inicial ?" ,'mv_ch1','D',08,0,0,'G','','mv_par01','','','','',"",""})
		aAdd(_aRegs,{cPerg,'02',"Emissao Final? "   ,"Emissao Final? "   ,"Emissao Final? "   ,'mv_ch2','D',08,0,0,'G','','mv_par02','','','','',"",""})
		aAdd(_aRegs,{cPerg,'03',"Cliente de?","","",'mv_ch3','C', 6,0,0,'G','','mv_par03','','','','',"","SA1"})
		aAdd(_aRegs,{cPerg,'04',"Loja  de?","","",'mv_ch4','C', 2,0,0,'G','','mv_par04','','','','',"",""})
		aAdd(_aRegs,{cPerg,'05',"Cliente Ate?","","",'mv_ch5','C', 6,0,0,'G','','mv_par05','','','','',"","SA1"})
		aAdd(_aRegs,{cPerg,'06',"Loja  Ate?","","",'mv_ch6','C', 2,0,0,'G','','mv_par06','','','','',"",""})
		aAdd(_aRegs,{cPerg,'07',"UF  de?","","",'mv_ch7','C', 2,0,0,'G','','mv_par07','','','','',"","12"})
		aAdd(_aRegs,{cPerg,'08',"UF  Ate?","","",'mv_ch8','C', 2,0,0,'G','','mv_par08','','','','',"","12"})
		aAdd(_aRegs,{cPerg,'09',"Gera Excel?","","",'mv_ch9','N', 1,0,2,'C','','mv_par09','Sim','Nao','','',"",""})
		aAdd(_aRegs,{cPerg,'10',"Prod. Sealbag?","","",'mv_ch0','C', 15,0,0,'G','','mv_par10','','','','',"","SB1SKU"})
		aAdd(_aRegs,{cPerg,'11',"Com Desconto?","","",'mv_chA','N', 01,0,0,'C','','mv_par11','Sim','Nao','Ambos','',"",""})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For _nx:=1 to Len(_aRegs)
			If	RecLock('SX1',Iif(!SX1->(DbSeek(_aRegs[_nx][01]+_aRegs[_nx][02])),.t.,.f.))
				For nlh:=1 to Len(_aHead)
				If	( nlh <> 10 )
						Replace &(_aHead[nlh]) With _aRegs[_nx][nlh]
					EndIf
				Next nlh
				MsUnlock()
			Else
				Help('',1,'REGNOIS')
			Endif
	
		Next _nx
Return Nil
                        
                        
Static Function AchEstado(cEstado)
Local aEstados := {}
Local nAchou := 0

// Lista de Estados Brasileiros para Identificacao da Sigla UF

AAdd(aEstados,{'ACRE','AC'})
AAdd(aEstados,{'ALAGOAS','AL'})
AAdd(aEstados,{'AMAPA','AP'})
AAdd(aEstados,{'AMAZONAS','AM'})
AAdd(aEstados,{'BAHIA','BA'})
AAdd(aEstados,{'CEARA','CE'})
AAdd(aEstados,{'DISTRITO FEDERAL','DF'})
AAdd(aEstados,{'ESPIRITO SANTO','ES'})
AAdd(aEstados,{'GOIAS','GO'})
AAdd(aEstados,{'MARANHAO','MA'})
AAdd(aEstados,{'MATO GROSSO','MT'})
AAdd(aEstados,{'MATO GROSSO DO SUL','MS'})
AAdd(aEstados,{'MINAS GERAIS','MG'})
AAdd(aEstados,{'PARA','PA'})
AAdd(aEstados,{'PARAIBA','PB'})
AAdd(aEstados,{'PARANA','PR'})
AAdd(aEstados,{'PERNAMBUCO','PE'})
AAdd(aEstados,{'PIAUI','PI'})
AAdd(aEstados,{'RIO DE JANEIRO','RJ'})
AAdd(aEstados,{'RIO GRANDE DO NORTE','RN'})
AAdd(aEstados,{'RIO GRANDE DO SUL','RS'})
AAdd(aEstados,{'RONDONIA','RO'})
AAdd(aEstados,{'RORAIMA','RR'})
AAdd(aEstados,{'SANTA CATARINA','SC'})
AAdd(aEstados,{'SAO PAULO','SP'})
AAdd(aEstados,{'SERGIPE','SE'})
AAdd(aEstados,{'TOCANTINS','TO'})


nAchou := Ascan(aEstados,{|x| AllTrim(x[2]) == AllTrim(Upper(cEstado))} )
If !Empty(nAchou)
	cEstado := aEstados[nAchou,1]
Else
	cEstado	:= ''
Endif
Return cEstado
