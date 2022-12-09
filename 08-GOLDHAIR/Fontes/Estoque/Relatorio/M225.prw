#INCLUDE "MATR225.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR225  ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao simplificada das estruturas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M225()

Local oReport

/*If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else*/
	U_M225R3()
//EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR225R3³ Autor ³ Marcos V. Ferreira    ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao simplificada das estruturas - Release 3            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M225R3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Relacao Simplificada das Estruturas"
LOCAL cDesc1   := STR0002	//"Este programa emite a rela‡„o de estrutura de um determinado produto"
LOCAL cDesc2   := STR0003	//"selecionado pelo usu rio. Esta rela‡„o n„o demonstra custos. Caso o"
LOCAL cDesc3   := STR0004	//"produto use opcionais, ser  listada a estrutura com os opcionais padr„o."
LOCAL cString  := "SG1"
LOCAL wnrel	   := "MATR225"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lNegEstr:=GETMV("MV_NEGESTR")
PRIVATE aReturn := {OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR225"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
//³ mv_par09   // Imprime Ate Nivel ?    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
EndIf

RptStatus({|lEnd| C225Imp(@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C225IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C225Imp(lEnd,WnRel,titulo,Tamanho)

LOCAL cRodaTxt  := STR0007	//"ESTRUTURA(S)"
LOCAL nCntImpr  := 0
LOCAL nTipo     := 0
LOCAL cProduto  := ""
LOCAL nNivel    := 0
LOCAL cPictQuant:=""
LOCAL cPictPerda:=""
LOCAL nX        := 0
LOCAL nPosCnt	:= 0
LOCAL nPosOld	:= 0
LOCAL i 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIf(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1   := STR0008	//"NIVEL                CODIGO          TRT TP GRUP DESCRICAO                          OBSERVACAO                                        QUANTIDADE UM PERDA     QUANTIDADE QTD. BASE  TIPO DE     INICIO      FIM    GRP. ITEM"
cabec2   := STR0009	//"                                                                                                                                      NECESSARIA      %                  ESTRUTURA QUANTIDADE  VALIDADE   VALIDADE OPCI  OPCI"
//                      99999999999999999999 999999999999999 999 99 9999 9999999999999999999999999999999999 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXXXX 9999999.999999 XX 99.99 9999999.999999   9999999  XXXXXXXX  99/99/9999 99/99/9999 XXX  XXXX
//                      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a Picture da quantidade (maximo de 14 posicoes)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("G1_QUANT")
If X3_TAMANHO >= 14
	For nX := 1 To 14
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictQuant := cPictQuant+"."
		Else
			cPictQuant := cPictQuant+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 14
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictQuant := "."+cPictQuant
		Else
			cPictQuant := "9"+cPictQuant
		EndIf
	Next nX
EndIf
dbSeek("G1_PERDA")
If X3_TAMANHO >= 6
	For nX := 1 To 6
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictPerda := cPictPerda+"."
		Else
			cPictPerda := cPictPerda+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 6
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictPerda := "."+cPictPerda
		Else
			cPictPerda := "9"+cPictPerda
		EndIf
	Next nX
EndIf
dbSetOrder(1)
dbSelectArea("SG1")
dbordernickname("SG1001")
SetRegua(LastRec())
Set SoftSeek On
dbSeek(xFilial("SG1")+mv_par01)
Set SoftSeek Off
While !Eof() .And. G1_FILIAL+G1_COD <= xFilial("SG1")+mv_par02
	If lEnd
		@ PROW()+1,001 PSAY STR0010	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()
	cProduto := G1_COD
	nNivel   := 2
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	If EOF() .Or. B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04 .Or.;
		B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
		dbSelectArea("SG1")
		While !EOF() .And. xFilial("SG1")+cProduto == G1_FILIAL+G1_COD
			dbSkip()
			IncRegua()
		EndDo
	Else
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++
		dbSelectArea("SB1")
		@ li,004 PSAY cProduto
		@ li,024 PSAY SB1->B1_TIPO
		@ li,027 PSAY SB1->B1_GRUPO
		@ li,032 PSAY SubStr(SB1->B1_DESC,1,34)
		@ li,105 PSAY SB1->B1_UM
		@ li,129 PSAY If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime grupo de opcionais.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
			@ li,137 PSAY "Opc. "
			@ li,142 PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
		EndIf
		Li += 2
		nPosOld:=nPosCnt
		nPosCnt+=MR225Expl(cProduto,IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,cPictQuant,cPictPerda,RetFldProd(SB1->B1_COD,"B1_OPC"),IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(Empty(mv_par08),SB1->B1_REVATU,mv_par08))
		For i:=nPosOld to nPosCnt
			IncRegua()
		Next I

		//-- Verifica se salta ou nao pagina	
		If mv_par07 == 1
		    Li:= 90
		Else    
	 		@ li,000 PSAY __PrtThinLine()
	 		Li +=2
	 	EndIf	 
	EndIf
	dbSelectArea("SG1")
EndDo
If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
Set Filter To
//dbSetOrder(1)
dbordernickname("SG1001")

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MR225Expl ³ Autor ³ Eveli Morasco         ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MR225Expl(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpC4,ExpN3)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN2 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC2 = Picture da quantidade                              ³±±
±±³          ³ ExpC3 = Picture da perda                                   ³±±
±±³          ³ ExpC4 = Opcionais do produto                               ³±±
±±³          ³ ExpN3 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ As outras 6 variaveis sao utilizadas pela funcao Cabec     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MR225Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,cOpcionais,nQtdBase,Titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,cRevisao)
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nPrintNivel
LOCAL nX        := 0
LOCAL aObserv   := {}
LOCAL aAreaSB1:={}
LOCAL cAteNiv   := If(mv_par09=Space(3),"999",mv_par09)

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
			If li > 58
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				dbSelectArea("SB1")
				aAreaSB1:=GetArea()
				dbSeek(xFilial("SB1")+cProduto)
				@ li,004 PSAY cProduto
				@ li,024 PSAY SB1->B1_TIPO
				@ li,027 PSAY SB1->B1_GRUPO
				@ li,032 PSAY SubStr(SB1->B1_DESC,1,34)
				@ li,105 PSAY SB1->B1_UM
				@ li,129 PSAY If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime grupo de opcionais.                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
					@ li,137 PSAY "Opc. "
					@ li,142 PSAY RetFldProd(SB1->B1_COD,"B1_OPC") Picture PesqPict("SB1","B1_OPC",80)
				EndIf
				RestArea(aAreaSB1)
				Li += 2
				dbSelectArea("SG1")
			EndIf
		
			//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
			aObserv := {}
			For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
				aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
			Next nX
		
			nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			@ li,nPrintNivel PSAY StrZero(nNivel,3)
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
			@ li,21  PSay G1_COMP
			@ li,37  PSay Substr(G1_TRT,1,3)
			@ li,41  PSay SB1->B1_TIPO
			@ li,44  PSay SB1->B1_GRUPO
			@ li,49  PSay SubStr(SB1->B1_DESC,1,34)
			@ li,84  PSay If(Len(aObserv)>0,aObserv[1],Left(G1_OBSERV,45))
	  	    @ li,130 PSay nQuantItem Picture cPictQuant
 			@ li,145 PSay SB1->B1_UM
			@ li,147 PSay G1_PERDA   Picture cPictPerda
			@ li,152 PSay G1_QUANT   Picture cPictQuant
			@ li,168 PSay If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
			@ li,180 PSay If(G1_FIXVAR $' úV',STR0011,STR0012)		//"VARIAVEL"###"FIXA"
			@ li,190 PSay G1_INI	Picture PesqPict("SG1","G1_INI",10)
			@ li,201 PSay G1_FIM	Picture PesqPict("SG1","G1_FIM",10)
			@ li,212 PSay G1_GROPC	Picture PesqPict("SG1","G1_GROPC",3)
			@ li,216 PSay G1_OPC	Picture PesqPict("SG1","G1_OPC",4)
			//-- Caso existam, Imprime as outras linhas da Observa‡„o
			If Len(aObserv) > 1
				For nX := 2 to Len(aObserv)
					Li ++
					@ li,84 PSAY aObserv[nX]
				Next nX
			EndIf
		
			Li++
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+G1_COMP)
			If Found()
				MR225Expl(G1_COD,nQuantItem,nNivel+1,cPictQuant,cPictPerda,cOpcionais,IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08))
			EndIf
			dbGoto(nReg)
		EndIf
	EndIf
	dbSkip()
	nCntItens++
EndDo
nCntItens--
Return nCntItens
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³Felipe Nunes de Toledoº Data ³ 27/07/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR225                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor :={} 
Local aHelpEng :={} 
Local aHelpSpa :={} 
      
/*-----------------------MV_PAR09--------------------------*/
Aadd( aHelpPor, "Informe ate qual nivel da estrutura "     )
Aadd( aHelpPor, "deseja visualizar. Se preenchido como "   )
Aadd( aHelpPor, "(branco), ira exibir todos os niveis."    )

Aadd( aHelpEng, "Enter up to which level of structure "    )
Aadd( aHelpEng, "you want to view. If it left (in blank)"  )
Aadd( aHelpEng, ", all levels will be displayed."          )

Aadd( aHelpSpa, "Informe hasta que nivel de la estructura ")
Aadd( aHelpSpa, "desea visualizar. Si se deja en blanco, " )
Aadd( aHelpSpa, "se mostraran todos los niveles."          )

PutSx1( "MTR225","09","Imprime Ate Nivel ?","¿Imprime hasta Nivel ?","Print To Level ?","mv_ch9",;
"C",3,0,0,"G","","","","S","mv_par09","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

Return Nil