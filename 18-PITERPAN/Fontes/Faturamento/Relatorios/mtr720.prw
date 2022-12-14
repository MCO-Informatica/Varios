#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function mtr720()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("CABEC1,CABEC2,WNREL,TAMANHO,LIMITE,CSTRING")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,LCONTINUA")
SetPrvt("LCAB,CX,I,NTIPO,LI,M_PAG")
SetPrvt("LIMPR,LNORMAL,CAUX2,UAUX,")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? MATR720  ? Autor ? Paulo Boschetti       ? Data ? 12.05.92 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Minuta de Despacho                                         낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ? MATR720(void)                                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? Generico                                                   낢?
굇쳐컴컴컴컴컵컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴컴컴컴눙?
굇? Rdmake   ? Autor ?  Luiz Carlos Vieira         ? Data 쿘on  16/03/98  낢?
굇읕컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Definicao do cabecalho e tipo de impressao do relatorio      ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
titulo := "RECIBO PARA DESPACHO"

nTipo  := IIF(aReturn[4]==1,15,18)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para Impressao do Cabecalho e Rodape    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte("MTR720",.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01            // Qual Serie De Nota Fiscal ?           ?
//? mv_par02            // Da Nota Fiscal ?                      ?
//? mv_par03            // Ate a Nota Fiscal ?                   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Acesso nota fiscal informada pelo usuario                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇? Fun뇙o   ? ListaMin ? Autor ?                    ? Data ?             볍?
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
굇튒escri뇙o ?                                                            볍?
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
굇튧so       ?                                                            볍?
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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

