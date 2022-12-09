//#Include "Ctbc400.ch"
#Include "PROTHEUS.Ch"
#Include "TCBrowse.ch"
#INCLUDE "DBINFO.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MayorURU ³ Autor ³ Urudata		        ³ Data ³ 19/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funci'on que genera el mayor de la cuenta contable en la   ³±±
±±³          ³ que el usuario se encuentra posicionado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBC400                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MayorURU()   

LOCAL nAlias
Local aArea		:= GetArea()	
Local oDlg,oBrw,oCOl,aBrowse:={},ni, aCpos, nCpo
Local aSize		:= MsAdvSize(,.F.,430)
Local aSizeAut 	:= MsAdvSize(), cArqTmp
Local aEntCtb	:= {	{ "", "", nil, .F. },;	// Conta	
					 	{ "", "", nil, .T. },;	// Contra Partida
						{ "", "", nil, .T. },;	// Centro de Custo
						{ "", "", nil, .T. },;	// Item Contabil
						{ "", "", nil, .T. } }	// Classe de Valor
Local aObjects	:= {	{ 375,  70, .T., .T. },;
						{ 100, 750, .T., .T., .T. },;
						{ 100, 100, .T., .T. },;
						{ 100, 200, .T., .T. } }
Local aInfo   		:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
Local aPosObj 		:= MsObjSize( aInfo, aObjects, .T. ) , nSaldoAnterior := 0
Local nTotalDebito	:= nTotalCredito := nTotalSaldo := 0
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local aSetOfBook 	:= {}
Local aButtons		:= {}
Local nDecimais 	:= 0
Local lCusto 		:= .T.
Local lItem			:= .T.
Local lCLVL			:= .T.
Local nTamanho        
Local cPictVal  	:= PesqPict("CT2","CT2_VALOR")
Local nX
Local cArq
Local aArea			:= GetArea()
Local cChave := ""  
Local cCuenta := ""
///datos contables para filtrar en mayor
Local cCCIni := mv_par06
Local cCCFin := mv_par07
Local cItemCIni := mv_par10
Local cItemCFin := mv_par11
Local cCLVLIni := mv_par08
Local cCLVLFin := mv_par09


aadd(aButtons,{"S4WB005N",     {|| U_IniAsien() }					    ,"Visualizar Asiento","Asiento"})

//Pergunte( "CTC400" , .F.)

//aSetOfBook 	:= CTBSetOf(mv_par05)
nDecimais 	:= CTbMoeda(mv_par05)[5]	// Recarrego as perguntas
lCusto 		:= .F.
lItem		:= .F.
lCLVL		:= .F.

//Mensaje que valida si la cuenta es sintetica o analitica
If ( CT1->CT1_CLASSE == "1" )
   Help ( " ", 1, "CC010SINTE" )
   Return ( .F. )
End

nSaldoAnterior := 0
// Soma o saldo anterior da conta de todas as filiais
nSaldoAnterior := SaldoCT7Fil(CT1->CT1_CONTA,mv_par01,mv_par05,"1",,,,)[6]	 

// Mascara da Conta
cMascara1 := GetMv("MV_MASCARA")
cMascara2 := GetMv("MV_MASCCUS")
dbSelectArea("CTD")
cMascara3 := ALLTRIM(STR(Len(CTD->CTD_ITEM)))
dbSelectArea("CTH")
cMascara4 := ALLTRIM(STR(Len(CTH->CTH_CLVL)))


/*TBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,.t.,"2",lAnalitico,,,aReturn[7],,aSelFil)},;*/

/*Local cCCIni := mv_par07
Local cCCFin := mv_par08
Local cItemCIni := mv_par11
Local cItemCIni := mv_par12
Local cCLVLIni := mv_par09
Local cCLVLFin := mv_par10*/   

MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,CT1->CT1_CONTA,CT1->CT1_CONTA,;
								 cCCIni,cCCFin,cItemCIni,cItemCFin,cCLVLIni,cCLVLFin,mv_par05,mv_par01,mv_par02,;
							 CTBSetOf(""),.F.,"1",.F.,"1",.T.,,,,,) },;
			"Generando Mayor Contable",;		// "Criando Arquivo Tempor rio..."
			"Mayor Contable")		// "Emissao do Razao"

If (cArqTmp->(Reccount())) == 0
	//Si el temporal esta vazio, o sea, si no hay ningun asiento para mostrar en el mayor, no hace nada
	Help(" ", 1, "CC010SEMMO")
Else

	aCpos := (cArqTmp->(DbStruct()))
	
	CTGerCplHis(@nSaldoAnterior, @nTotalSaldo, @nTotalDebito, @nTotalCredito)
	
	nAlias 	:= Select("cArqTmp")
	aBrowse := {	{"Fecha","DATAL"},;
					{"Asiento",	{ || cArqTmp->LOTE + cArqTmp->SUBLOTE + cArqTmp->DOC +;
								'/' + cArqTmp->LINHA } },;
					{"Historico","HISTORICO"},;
					{"Partida",{ || MascaraCTB(cArqTmp->XPARTIDA,cMascara1,,cSepara1) } },;
					{"Asiento Debito","LANCDEB"},;
					{"Asiento Credito","LANCCRD"},;
	   				{"Saldo","SALDOSCR"},;
	   				{"Fecha","TPSLDATU"},;
	   				{"Filial","FILORI"}}    				
	
	If lCusto
		Aadd(aBrowse, {CtbSayAPro("CTT"),{ || MascaraCTB(cArqTmp->CCUSTO,cMascara2,,cSepara2) } })
	Endif
	If lItem
		Aadd(aBrowse, {CtbSayAPro("CTD"),{ || MascaraCTB(cArqTmp->ITEM,cMascara3,,cSepara3) } })
	Endif
	If lCLVL
		Aadd(aBrowse, {CtbSayAPro("CTH"),{ || MascaraCTB(cArqTmp->CLVL,cMascara4,,cSepara4) } })
	Endif
	
	DEFINE 	MSDIALOG oDlg TITLE cCadastro;
			From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
	SX3->(DbSetOrder(2))
	SX3->(DbSeek("CT1_NORMAL"))
	cCondA := Iif(nSaldoAnterior<0,"D","C")
	@ 18, 04  SAY "Cuenta - " + MascaraCTB(CT1->CT1_CONTA,cMascara1,,cSepara1) + " - " +;
	AllTrim(Substr(&("CT1->CT1_DESC" + mv_par05),1,45)) +;
	" - " + X3Titulo() + " - " + CT1->CT1_NORMAL PIXEL //"Conta - " 
@ 18,aPosObj[1][4] - 100 Say "" +;
	Transform(Abs(nSaldoAnterior),cPictVal) + " " + cCondA PIXEL //"Saldo Anterior "
	SX3->(DbSetOrder(1))
	@ 30,4 COLUMN BROWSE oBrw SIZE 	aPosObj[2][3],aPosObj[2][4] PIXEL OF oDlg
	oBrw:lColDrag := .T.  // Permite a mudanca das ordens das colunas
	oBrw:lMChange := .T.  // Permitir o ajuste do tamanho dos campos
	For ni := 1 to Len(aBrowse)
		uCpo := aBrowse[ni][2]
		If ValType(uCpo) <> "B"
			nCpo := Ascan(aCpos, { |x| x[1] = aBrowse[ni][2]})
		Else
			nCpo := 0
		Endif
		If Len(aBrowse[ni]) > 2
			nTamanho := aBrowse[ni][3]
		Else
			If nCpo > 0
				nTamanho := aCpos[nCpo][3]
			Else
				nTamanho := 0
			Endif
		Endif
		If nCpo = 0
			DEFINE COLUMN oCol DATA { || "" };
			HEADER aBrowse[ni][1];
			SIZE CalcFieldSize("C",	If(nTamanho = 0, Len(Eval(uCpo)), nTamanho), 0,"",aBrowse[ni][1])
			oCol:bData := uCpo
		ElseIf ValType(&(aBrowse[ni][2])) != "N"
			DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2], nAlias);
			HEADER aBrowse[ni][1];
			SIZE CalcFieldSize(aCpos[nCpo][2],nTamanho,aCpos[nCpo][4],"",aBrowse[ni][1]) -; 
			If(ValType(&(aBrowse[ni][2])) = "D", 7, 0)
		Else
			uCpo := aBrowse[ni][2]
			DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2], nAlias);
			PICTURE cPictVal;
			HEADER aBrowse[ni][1] SIZE CalcFieldSize(aCpos[nCpo][2],aCpos[nCpo][3],aCpos[nCpo][4],cPictVal,aBrowse[ni][1]) RIGHT
		Endif
		oBrw:ADDCOLUMN(oCol)
	Next ni
	DEFINE COLUMN oCol DATA { || Space(10) } HEADER " " SIZE 10 RIGHT
	oBrw:ADDCOLUMN(oCol)
	oBrw:bChange := { || C400ChgBrw( mv_par05, @aEntCtb ) }
	
	@ aPosObj[3][1], 002 TO aPosObj[3][3], aPosObj[3][4] LABEL "" PIXEL
	@aPosObj[3][1] + 8,005  Say "Débito" + Trans(nTotalDebito,tm(nTotalDebito,17,nDecimais)) PIXEL		//"D‚bito "
	@aPosObj[3][1] + 8,170  Say "Crédito" + Trans(nTotalCredito,tm(nTotalCredito,17,nDecimais)) PIXEL  	//"Cr‚dito "
	cCondF := Iif(nTotalSaldo<0,"D","C")			
	@ aPosObj[3][1] + 8,aPosObj[3][4] - 80 Say "Saldo"+ Transform(ABS(nTotalSaldo),cPictVal) + " " + cCondF Pixel //"Saldo "
	                               
	@ aPosObj[4][1], 002 TO aPosObj[4][3], aPosObj[4][4] LABEL "Descripciones" PIXEL	// "Descrições"
	
	@ aPosObj[4][1]+8,005 SAY "Contra Partida" PIXEL	// "Contra Partida"
	@ aPosObj[4][1]+8,045 MSGET aEntCtb[2,3] VAR aEntCtb[2,2] WHEN .F. SIZE 150,08 PIXEL
	
	@ aPosObj[4][1]+8,aPosObj[4][4] -185 SAY CtbSayAPro("CTT") PIXEL	// "Centro de Custo"
	@ aPosObj[4][1]+8,aPosObj[4][4] -152 MSGET aEntCtb[3,3] VAR aEntCtb[3,2] WHEN .F. SIZE 150,08 PIXEL
	
	@ aPosObj[4][1]+19,005 SAY CtbSayAPro("CTD") PIXEL	// Item Contabil
	@ aPosObj[4][1]+19,045 MSGET aEntCtb[4,3] VAR aEntCtb[4,2] WHEN .F. SIZE 150,08 PIXEL
	                     
	@ aPosObj[4][1]+19,aPosObj[4][4] -185 SAY CtbSayAPro("CTH") PIXEL	// Classe de Valor
	@ aPosObj[4][1]+19,aPosObj[4][4] -152 MSGET aEntCtb[5,3] VAR aEntCtb[5,2] WHEN .F. SIZE 150,08 PIXEL
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)

EndIf

//Me quedo con la cuenta a la cual debo retornar
cCuenta := cArqTmp->(Conta)
//Elimina la tabla temporal del mayor
dbSelectArea("cArqTmp")
cArq := DbInfo(DBI_FULLPATH)
cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
DbCloseArea()
FErase(cArq)

//Reabre la tabla temporal del balance
//dbUseArea( .T.,, cArqTmpBal, "cArqTmp", .F., .F. )  
//cChave := "Conta"
//IndRegua("cArqTmp",cArqTmpBal,cChave,,,STR0021)  //"Selecionando Registros..." 
//dbSelectArea("cArqTmp")
//dbSetIndex(cIndTMP1+OrdBagExt())
//dbSetIndex(cIndTMP2+OrdBagExt())
//dbSetOrder(1)
//DBSeek(cCuenta)

RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Balance  ³ Autor ³ Urudata SA				   ³ Data ³ 20/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Función que muestra el asiento contable.                          ³±±
±±³          ³                          										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IniAsien()

If CT2->(dbSeek(xFilial("CT2")+dtos(cArqTmp->DATAL)+cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC))

	PRIVATE dDataLanc	:= CT2->CT2_DATA
	PRIVATE cLote		:= CT2->CT2_LOTE
	PRIVATE cSubLote	:= CT2->CT2_SBLOTE
	Private lSubLote 	:= Empty(cSubLote)
	PRIVATE cDoc		:= CT2->CT2_DOC
	Private cLoteSub 	:= GetMv("MV_SUBLOTE")
	Private __lCusto	:= .F.
	Private __lItem 	:= .F.
	Private __lCLVL		:= .F.
	Private aRotina		:= {}
	
	aRotina := { 	{	"" ,"AxPesqui"  , 0 , 1,,.F.},; // "Pesquisar"
							 	{"" ,"Ctba102Cal", 0 , 2},; // "Visualizar"
								{"" ,"Ctba102Cal", 0 , 3},; // "Incluir"
								{"" ,"Ctba102Cal", 0 , 4},; // "Alterar"
								{"" ,"Ctba102Cal", 0 , 5},;  // "Excluir"
								{"","Ctba102Cal", 0 , 4} ,;  //"Estornar"
								{"","Ctba102Cal", 0 , 3} ,;  //"Copiar"
								{"","CtbLegenda", 0 , 5, ,.F.} ,;  //"Legenda"
		   	    				{"","CtbC010Rot"	, 0 , 2} }  // "Rastrear"
	
	Ctba102Cal("CT2",CT2->(Recno()),2)
Else
	MsgAlert("Asiento no encontrado")
EndIf

Return NIL
