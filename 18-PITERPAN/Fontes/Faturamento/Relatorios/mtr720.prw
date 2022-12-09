#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function mtr720()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("CABEC1,CABEC2,WNREL,TAMANHO,LIMITE,CSTRING")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,LCONTINUA")
SetPrvt("LCAB,CX,I,NTIPO,LI,M_PAG")
SetPrvt("LIMPR,LNORMAL,CAUX2,UAUX,")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR720  ³ Autor ³ Paulo Boschetti       ³ Data ³ 12.05.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Minuta de Despacho                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR720(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rdmake   ³ Autor ³  Luiz Carlos Vieira         ³ Data ³Mon  16/03/98  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt     := ""
titulo    := "Minuta de Despacho"
cDesc1    := "Este relatorio ira emitir a relacao de Recibos"
cDesc2    := "de Despacho para as transportadoras."
cDesc3    := ""
CbCont    := 0
cabec1    := ""
cabec2    := ""
wnrel     := ""
tamanho   := "P"
limite    := 80
cString   := "SF2"

aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "MATR720"
aLinha    := { }
nLastKey  := 0
cPerg     := "MTR720"

titulo    := "Minuta de Despacho"
cDesc1    := "Este relatorio ira emitir a relacao de Recibos"
cDesc2    := "de Despacho para as transportadoras."
cDesc3    := ""
CbCont    := 0
cabec1    := ""
cabec2    := ""
tamanho   := "P"
limite    := 80
lContinua := lCab := .T.
cX        := " "
I         := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do cabecalho e tipo de impressao do relatorio      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "RECIBO PARA DESPACHO"

nTipo  := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR720",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Qual Serie De Nota Fiscal ?           ³
//³ mv_par02            // Da Nota Fiscal ?                      ³
//³ mv_par03            // Ate a Nota Fiscal ?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "MATR720"            //Nome Default do relatorio em Disco

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey == 27
	Set filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| C720Imp()},Titulo)// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>     RptStatus({|| Execute(C720Imp)},Titulo)
	Return
	// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>     Function C720Imp
	Static Function C720Imp()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acesso nota fiscal informada pelo usuario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial()+mv_par02+mv_par01,.T.)

SetRegua(RecCount())		// Total de Elementos da regua

Do While !Eof() .and. SF2->F2_FILIAL == xFilial()
	ListaMin()
	dbSKip()
EndDo

roda(cbcont,cbtxt,tamanho)

dbSelectArea("SF2")
Set Filter To
dbSetOrder(1)
Set device to screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Fun‡„o   ³ ListaMin º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> FuncTion ListaMin
Static FuncTion ListaMin()

lImpr   :=.T.
lNormal := .F.

If SF2->F2_SERIE != mv_par01 .Or. SF2->F2_FILIAL != xFilial() .Or. SF2->F2_DOC < mv_par02 .Or. Sf2->F2_DOC > mv_par03
	lImpr:=.F.
EndIf


lNormal := !(SF2->F2_TIPO $ "DB")

IncRegua()

If lImpr
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	@ 10,00 PSAY "Nota Fiscal : "+F2_DOC
	@ 10,25 PSAY "Valor : "
	@ 10,33 PSAY (F2_VALMERC+F2_VALIPI+F2_FRETE+F2_SEGURO+F2_ICMSRET)  PICTURE TM((F2_VALMERC+F2_VALIPI+F2_FRETE+F2_SEGURO+F2_ICMSRET),16)
	
	dbSelectArea( If( lNormal,"SA1","SA2" ) )
	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	@ 12,00 PSAY "Cliente     : "+If( lNormal,SA1->A1_NOME,SA2->A2_NOME )
	
	If lNormal
		If empty( SA1->A1_ENDENT )
			@ 14,00 PSAY "Endereco    : "+SA1->A1_END
		Else
			@ 14,00 PSAY "Endereco    : "+SA1->A1_ENDENT
		EndIf
	Else
		@ 14,00 PSAY "Endereco    : "+SA2->A2_END
	EndIf
	
	@ 16,00 PSAY "Bairro      : "+If( lNormal,Substr(SA1->A1_BAIRRO,1,21),Substr(SA2->A2_BAIRRO,1,21))
	@ 16,37 PSAY "Cidade : "+If( lNormal,SA1->A1_MUN,SA2->A2_MUN )
	@ 16,72 PSAY "UF : "+If( lNormal,SA1->A1_EST,SA2->A2_EST )
	
	dbSelectArea("SA4")
	dbSeek(xFilial()+SF2->F2_TRANSP)
	
	@ 18,00 PSAY "Transportad.: "+A4_NOME
	@ 19,00 PSAY "Tel.: "+A4_TEL
	@ 20,00 PSAY "Endereco    : "+A4_END
	
	xPED_VEND := {}
		
	dbSelectArea("SD2")
	dbSetOrder(03)
	dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
	
	Do While !Eof() .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE
		AADD(xPED_VEND ,SD2->D2_PEDIDO)
		DbSkip()
	EndDo
	
	dbSelectArea("SC5")                  // * Pedidos de Venda
	dbSetOrder(1)
	xPESO_BRUTO := 0
	xPED        := {}
	For I:=1 to Len(xPED_VEND)
		dbSeek(xFilial("SC5")+xPED_VEND[I])
		If ASCAN(xPED,xPED_VEND[I])==0
			dbSeek(xFilial("SC5")+xPED_VEND[I])
			xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
			AADD(xPED,xPED_VEND[I])
		Endif
	Next
	
	@ 22,00 PSAY "Peso Bruto  : "
	@ 22,14 PSAY xPESO_BRUTO Picture "@E@Z 999,999.99" // Peso Bruto
	
	dbSelectArea("SF2")
	
	Li   := 26
	lCab := .T.
	
	FOR I:=1 TO 4
		cX := Str(I,1)
		caux2 :="F2_ESPECI"+cx
		caux2 :=&caux2
		If !empty(caux2)
			If lCab
				@Li ,15 PSAY REPLICATE("-",47)
				li := li + 1
				@Li ,15 PSAY "E S P E C I E"
				@Li ,47 PSAY "V O L U M E (S)"
				li := li + 1
				@Li ,15 PSAY REPLICATE("-",47)
				li := li + 1
				lCab := .F.
				li := li + 1
			EndIf
			uAux := "F2_ESPECI"+cX
			uAux := &uAux
			@Li ,15 PSAY uAux
			uAux := "F2_VOLUME"+cX
			uAux := &uAux
			@Li ,56 PSAY uAux PICTURE "999999"
			li := li + 1
		EndIf
	NEXT I
	
	@ 40,00 PSAY "Numero da Coleta: _________________"
	@ 42,00 PSAY "Data da Coleta  : _________________"
	@ 44,00 PSAY "Hora da Coleta  : _________________"
	@ 46,00 PSAY "Contato         : _________________"
	
	
	
	@ 56,00 PSAY "Data: ___/___/___"+SPACE(32)+"----------------------------"
	@ 57,53 PSAY "CARIMBO E ASSINATURA"
EndIf

Return

