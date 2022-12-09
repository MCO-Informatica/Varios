#INCLUDE  "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.CH"

User Function Kest01r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDEM,_NRECNO,TAMANHO,LIMITE,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NOMEPROG,NLASTKEY,CSTRING")
SetPrvt("LCONTINUA,WNREL,CNOMEPRG,TITULO,AORD,ADRIVER")
SetPrvt("CPERG,LEND,CBCONT,CBTXT,_APERGUNTAS,_NLACO")
SetPrvt("_AARQUIVO,_CARQTRB,_AESTRPED,_CARQPED,M_PAG,_NLIN")
SetPrvt("_NPAG,_NTIPO,_SINTETICO,_TCRU,_TESTOQUE,_TTINGINDO")
SetPrvt("_TREPROCES,_TPEDIDOS,_TEMPENHO,_TSALDO,_TPRO_MES,_TQTD_TEAR")
SetPrvt("_TVAL_CUST,_TGCRU,_TGESTOQUE,_TGTINGINDO,_TGREPROCES,_TGPEDIDOS")
SetPrvt("_TGEMPENHO,_TGSALDO,_TGPRO_MES,_TGQTD_TEAR,_TGVAL_CUST,_GRUPO_ATUAL")
SetPrvt("_CNOMEDBF,CABEC1,CABEC2,_PI,_PF,_LO")
SetPrvt("CQUERY,_CGRUPO,_NRECGRUPO,_NRECNEXT,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST01R  ³ Autor ³Ricardo Cassolato      ³ Data ³13/03/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Posicao de Estoques                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marllon      ³27/03/00³ Calculo quantidade em Ordem de Producao       ³±±
±±³ Marllon      ³28/03/00³ Separacao tecidos cru e tingido - layout      ³±±
±±³ Marcos       ³24/04/00³ Inclusao do campo C2_PERDA na query do SC2    ³±±
±±³ Ricardo Souza³14/11/00³ Revisao geral dos calculos utilizados         ³±±
±±³ Ricardo Souza³07/12/00³ Calculo pedidos em aberto considerando residuo³±±
±±³ Ricardo Souza³17/05/01³ Mudanca query p/tratamento do codigo produto  ³±±
±±³ Ricardo Souza³28/08/01³ Valorizacao do estoque pelo custo medio       ³±±
±±³ Ricardo Souza³25/10/01³ Acrescentar coluna de reprocesso              ³±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.CH"

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Salva Ambiente
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cAlias  := Alias()
_nOrdem  := IndexOrd()
_nRecno  := Recno()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

tamanho  := "G"
limite   := 220
cDesc1   := PADC("POSICAO DE ESTOQUE",74)
cDesc2   := PADC("Kenia Insdustrias Texteis Ltda",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="KEST01R"
nLastkey := 0
cString  := "SB1"
lContinua:= .F.
wnrel    := "KEST01R"
cNomePrg := "KEST01R"
titulo   := "POSICAO DE ESTOQUE"
aOrd     := {}
aDriver  :=ReadDriver()
cPerg    :="EST02R    "
lEnd     := .F.
cbCont   := 00
Cbtxt    := Space( 10 )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01               Produto Inicial                                    *
* mv_par02               Produto Final                                      *
* mv_par03               Produtos Inativos ?(S/N)                           *
* mv_par04               Mostra Saldo Zero ?(S/N)                           *
* mv_par05               Cor inicial                                        *
* mv_par06               Cor Final                                          *
* mv_par07               (S)intetico/(A)nalitico                            *
* mv_par08               Apenas Tecido Cru?  (S/N)                          *
* mv_par09               Local de Estoque                                   *
* mv_par10               Nome do arquivo DBF para o Excel                   *
* mv_par11               Lista Pedidos ? (S/N)                              *
* mv_par12               Somente Fora de Linha (S/N)                        *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aPerguntas:= {}

AADD(_aPerguntas,{cPerg,"01","Produto Inicial    ? " ,"mv_ch1","C",15,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"02","Produto Final      ? " ,"mv_ch2","C",15,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"03","Produtos Inativos S/N" ,"mv_ch3","N", 1,0,0,"C"," ","mv_par03","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"04","Saldo Zero  S/N     ?" ,"mv_ch4","N", 1,0,0,"C"," ","mv_par04","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"05","Cor Inicial        ? " ,"mv_ch5","C",15,0,0,"G"," ","mv_par05","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"06","Cor Final          ? " ,"mv_ch6","C",15,0,0,"G"," ","mv_par06","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"07","Sintetico/Analitico? " ,"mv_ch7","N", 1,0,0,"C"," ","mv_par07","Sintetico","","","Analitico","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"08","Apenas Tecido Cru  ? " ,"mv_ch8","N", 1,0,0,"C"," ","mv_par08","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"09","Local de Estoque   ?" ,"mv_ch9" ,"C", 2,0,0,"G"," ","mv_par09","01       ","","","         ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"10","Nome do DBF > Excel?" ,"mv_chA" ,"C",40,0,0,"G"," ","mv_par10","         ","","","         ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"11","Lista Pedido Venda ?" ,"mv_chb" ,"N", 1,0,0,"C"," ","mv_par11","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{cPerg,"12","Somente Fora de Linha","mv_chc" ,"N", 1,0,0,"C"," ","mv_par12","Sim      ","","","Nao      ","","","","","","","","","","","   ",})

DbSelectArea("SX1")
For _nLaco:=1 to Len(_aPerguntas)
	If !DbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
		RecLock("SX1",.T.)
		SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
		SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
		SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
		SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
		SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
		SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
		SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
		SX1->X1_Presel    := _aPerguntas[_nLaco,08]
		SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
		SX1->X1_Valid     := _aPerguntas[_nLaco,10]
		SX1->X1_Var01     := _aPerguntas[_nLaco,11]
		SX1->X1_Def01     := _aPerguntas[_nLaco,12]
		SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
		SX1->X1_Var02     := _aPerguntas[_nLaco,14]
		SX1->X1_Def02     := _aPerguntas[_nLaco,15]
		SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
		SX1->X1_Var03     := _aPerguntas[_nLaco,17]
		SX1->X1_Def03     := _aPerguntas[_nLaco,18]
		SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
		SX1->X1_Var04     := _aPerguntas[_nLaco,20]
		SX1->X1_Def04     := _aPerguntas[_nLaco,21]
		SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
		SX1->X1_Var05     := _aPerguntas[_nLaco,23]
		SX1->X1_Def05     := _aPerguntas[_nLaco,24]
		SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
		SX1->X1_F3        := _aPerguntas[_nLaco,26]
		MsUnLock()
	EndIf
Next

Pergunte(cPerg,.T.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||CalcRel()},"Selecionando Dados")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(CalcRel)},"Selecionando Dados")
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05


// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

//----> estrutura do arquivo temporario que recebera o resultado das query's
_aArquivo:={}

AADD(_aArquivo,{"CODIGO"   ,"C",15,0})
AADD(_aArquivo,{"LOCAL"    ,"C",02,0})
AADD(_aArquivo,{"CRU"      ,"N",09,2})
AADD(_aArquivo,{"ESTOQUE"  ,"N",09,2})
AADD(_aArquivo,{"TINGINDO" ,"N",09,2})
AADD(_aArquivo,{"REPROCES" ,"N",09,2})
AADD(_aArquivo,{"PEDCOMP"  ,"N",09,2})
AADD(_aArquivo,{"PEDIDOS"  ,"N",09,2})
AADD(_aArquivo,{"EMPENHO"  ,"N",09,2})
AADD(_aArquivo,{"SALDO"    ,"N",09,2})
AADD(_aArquivo,{"PRO_MES"  ,"N",09,2})
AADD(_aArquivo,{"QTD_TEAR" ,"N",09,2})
AADD(_aArquivo,{"SINT_ANA" ,"C",01,0})
AADD(_aArquivo,{"CUSTO"    ,"N",08,4})
AADD(_aArquivo,{"TOTAL"    ,"N",14,2})
AADD(_aArquivo,{"STATUS"   ,"C",01,0})
AADD(_aArquivo,{"TIPO"     ,"C",02,0})
//AADD(_aArquivo,{"DAT"     ,"D",06,0})
//AADD(_aArquivo,{"CLIENTE"  ,"C",10,0})


_cArqTRB:=CriaTrab(_aArquivo,.T.)
dbUseArea( .T.,, _cArqTRB, "TRB", If(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",_cArqTRB,"CODIGO",,,"Criando Indice ...")

//----> arquivo temporario onde serao obtidos os produtos "normais"
CriaK1()

DbSelectArea("K1")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()
	
	//----> filtrando somente produto acabado E CRU
	If K1->B1_TIPO $"KC KT TC TT"
	Else
		DbSkip()
		Loop
	Endif
	
	IncProc( OemToAnsi("Processando Saldos em Estoque - Produto "+K1->B1_COD) )
	
	//----> a formula do campo saldo e ((ESTOQUE+CRU+TINGINDO)-PEDIDOS)-EMPENHO)
	DbSelectArea("TRB")
	RecLock( "TRB" , .t. )
	TRB->CODIGO   := K1->B1_COD
	TRB->LOCAL    := K1->B2_LOCAL
	
	//----> este If trata a troca da coluna de estoque para o produto cru
	If K1->B1_TIPO $"KC TC"
		TRB->CRU      := K1->B2_QATU
	Else
		TRB->ESTOQUE  := K1->B2_QATU
	EndIf
	
	TRB->TINGINDO := 0.00
	TRB->REPROCES := 0.00
	TRB->PEDCOMP  := K1->B2_SALPEDI
	TRB->EMPENHO  := K1->B2_QEMP+K1->B2_QEMPPRE
	TRB->SALDO    := 0.00
	TRB->PRO_MES  := K1->B1_PRODMES
	TRB->QTD_TEAR := K1->B1_QTEARES
	TRB->SINT_ANA := If(MV_PAR07==1,"S","X")
	TRB->CUSTO    := K1->B1_CUSTD
	TRB->TOTAL    := Round(K1->B2_QATU * K1->B1_CUSTD,2)
	TRB->STATUS   := K1->B1_STATUS
	TRB->TIPO	  := K1->B1_TIPO
	
	
	MsUnLock()
	
	DbSelectArea("K1")
	DbSkip()
EndDo

DbSelectArea("K1")
DbCloseArea("K1")

//----> busca os dados de produtos em tingimento (ordens de producao)
CriaK3()

DbSelectArea("K3")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()
	
	IncProc( OemToAnsi("Processando Ordens de Producao - Produto "+K3->C2_PRODUTO) )
	
	DbSelectArea("TRB")
	If DbSeek(K3->C2_PRODUTO)
		RecLock( "TRB" , .f. )
		If Alltrim(K3->C2_TIPO) $ "01/06"
			TRB->TINGINDO := IIf(TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA) < 0, 0, TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA))
		Else
			TRB->REPROCES := IIf(TRB->REPROCES+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA) < 0, 0, TRB->REPROCES+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA))
		EndIf
		MsUnLock()
	EndIf
	
	DbSelectArea("K3")
	DbSkip()
EndDo

DbSelectArea("K3")
DbCloseArea("K3")

//----> busca dados dos pedidos de venda em aberto produtos "normais"
CriaK4()

DbSelectArea("K4")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()
	
	IncProc( OemToAnsi("Processando Pedidos de Vendas - Produto "+K4->C6_PRODUTO) )
	
	DbSelectArea("TRB")
	If DbSeek(K4->C6_PRODUTO)
		RecLock("TRB",.f.)
		TRB->PEDIDOS := TRB->PEDIDOS + (K4->C6_QTDVEN - K4->C6_QTDENT)
		MsUnLock()
	EndIf
	  /*
	IncProc( OemToAnsi("Processando Cliente - Pedido "+K4->C6_DATFAT) )
	
	DbSelectArea("TRB")
	If DbSeek(K4->C6_DATFAT)
		RecLock("TRB",.f.)
		TRB->DAT := TRB->DAT + (K4->C6_DATFAT - K4->C6_DATFAT)
		MsUnLock()
	EndIf   */
	
	
	DbSelectArea("K4")
	DbSkip()
EndDo

DbSelectArea("K4")
DbCloseArea("K4")


If mv_par11 == 1
	_aEstrPed:={}
	
	AADD(_aEstrPed,{"CODIGO"   ,"C",15,0})
	AADD(_aEstrPed,{"DESCRICAO","C",30,0})
	AADD(_aEstrPed,{"LOCAL"    ,"C",02,0})
	AADD(_aEstrPed,{"PEDIDOS"  ,"N",16,4})
	AADD(_aEstrPed,{"NUMPED"   ,"C",06,0})
	AADD(_aEstrPed,{"ITEMPV"   ,"C",02,0})
	AADD(_aEstrPed,{"DAT"      ,"D",08,0})
	AADD(_aEstrPed,{"CLIENTE"  ,"C",20,0})
	_cArqPed:=CriaTrab(_aEstrPed,.T.)
	DbUseArea( .T.,, _cArqPed, "PED", If(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("PED",_cArqPed,"CODIGO",,,"Criando Indice ...")
	
	CriaK6()
	
	DbSelectArea("K6")
	DbGoTop()
	ProcRegua(LastRec())
	
	Do While Eof() == .f.
		
		IncProc( OemToAnsi("Processando Pedidos de Vendas - Produto "+K6->C6_PRODUTO) )
		
		DbSelectArea("PED")
		RecLock("PED",.t.)
		PED->CODIGO    := K6->C6_PRODUTO
		PED->DESCRICAO := K6->C6_DESCRI
		PED->PEDIDOS   := K6->C6_QTDVEN - K6->C6_QTDENT
		PED->NUMPED    := K6->C6_NUM
		PED->ITEMPV    := K6->C6_ITEM
		PED->DAT       := K6->C6_ENTREG
		PED->CLIENTE   := K6->A1_NREDUZ
		MsUnLock()
		
		DbSelectArea("K6")
		DbSkip()
	EndDo
	
	DbSelectArea("K6")
	DbCloseArea("K6")
EndIf



//----> calcula os saldos finais
DbSelectArea("TRB")
DbGoTop()
ProcRegua(LastRec())
Do While  !Eof()
	
	IncProc(OemToAnsi("Selecionando Dados para Impressao"))
	
	RecLock("TRB",.f.)
	If TRB->TIPO$"KC TC"
		TRB->CRU      := TRB->CRU-TRB->EMPENHO
		TRB->TINGINDO := 0
		TRB->REPROCES := 0
		TRB->SALDO    := TRB->ESTOQUE+TRB->CRU+TRB->PEDCOMP+TRB->TINGINDO-TRB->REPROCES-TRB->PEDIDOS
	Else
		TRB->SALDO    := TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO+TRB->REPROCES-TRB->PEDIDOS-TRB->EMPENHO
	EndIf
	MsUnLock()
	DbSkip()
EndDo

DbSelectArea("TRB")
DbGoTop()
Do While ! EOF()
	//----> filtra somente produtos fora de linha
	If MV_PAR12 == 1
		If TRB->STATUS <> "F"
			RecLock("TRB",.f.)
			DbDelete()
			MsUnLock()
		EndIf
	EndIf
	
	//----> elimina produto inativo
	If MV_PAR03 == 2
		If TRB->STATUS == "I"
			RecLock("TRB",.f.)
			DbDelete()
			MsUnLock()
		EndIf
	EndIf
	
	//----> elimina saldo zero
	If MV_PAR04 == 2
		If TRB->SALDO == 0
			RecLock("TRB",.f.)
			DbDelete()
			MsUnLock()
		EndIf
	EndIf
	
	//----> somente tecidos cru
	If MV_PAR08 == 1
		If !TRB->TIPO$"KC TC"
			RecLock("TRB",.f.)
			DbDelete()
			MsUnLock()
		EndIf
	EndIf

	DbSkip()
EndDo

//----> acumula valores se o relatorio for sintetico
If MV_PAR07 == 1
	Calc_Sint()
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

m_pag      := 1
_nLin      := 60
_nPag      := 0
_nTipo     := IIf(aReturn[4]==1,15,18)
_sintetico := .f.
_tcru      := 0
_testoque  := 0
_ttingindo := 0
_treproces := 0
_tpedcomp  := 0
_tpedidos  := 0
_tempenho  := 0
_tsaldo    := 0
_tpro_mes  := 0
_tqtd_tear := 0
_tval_cust := 0
_tgcru     := 0
_tgestoque := 0
_tgtingindo:= 0
_tgreproces:= 0
_tgpedcomp := 0
_tgpedidos := 0
_tgempenho := 0
_tgsaldo   := 0
_tgpro_mes := 0
_tgqtd_tear:= 0
_tgval_cust:= 0
_grupo_atual:=" "

RptStatus({|| Rel_Kenia() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Rel_Kenia) })
Return()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Rel_Kenia
Static Function Rel_Kenia()

DbSelectArea("TRB")
DbGoTop()
SetRegua(RecCount())
If MV_PAR07 == 1
	_sintetico := .t.
	IndRegua("TRB",_cArqTRB,"SINT_ANA+CODIGO",,,"Criando Indice ...")
EndIf


@ 000,000 PSAY AvalImp(limite)

Do While !Eof()
	If lAbortPrint
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	If TRB->SINT_ANA<>"S" .AND. _sintetico
		DbSkip()
		Loop
	EndIf
	
	_grupo_atual := LEFT( TRB->CODIGO , 3 )
	
	//----> acumula totais do grupo
	_tcru     := _tcru      +  TRB->CRU
	_testoque := _testoque  +  TRB->ESTOQUE
	_ttingindo:= _ttingindo +  TRB->TINGINDO
	_treproces:= _treproces +  TRB->REPROCES
	_tpedcomp := _tpedcomp  +  TRB->PEDCOMP
	_tpedidos := _tpedidos  +  TRB->PEDIDOS
	_tempenho := _tempenho  +  TRB->EMPENHO
	_tsaldo   := _tsaldo    +  TRB->SALDO
	_tpro_mes := _tpro_mes  +  TRB->PRO_MES
	_tqtd_tear:= _tqtd_tear +  TRB->QTD_TEAR
	_tval_cust:= _tval_cust +  TRB->TOTAL
	
	//----> acumula totais geral
	_tgcru     := _tgcru     + TRB->CRU
	_tgestoque := _tgestoque + TRB->ESTOQUE
	_tgtingindo:= _tgtingindo+ TRB->TINGINDO
	_tgreproces:= _tgreproces+ TRB->REPROCES
	_tgpedcomp := _tgpedcomp + TRB->PEDCOMP
	_tgpedidos := _tgpedidos + TRB->PEDIDOS
	_tgempenho := _tgempenho + TRB->EMPENHO
	_tgsaldo   := _tgsaldo   + TRB->SALDO
	_tgpro_mes := _tgpro_mes + TRB->PRO_MES
	_tgqtd_tear:= _tgqtd_tear+ TRB->QTD_TEAR
	_tgval_cust:= _tgval_cust+ TRB->TOTAL
	
	//----> imprime relatorio analitico
	Detalhe()
	
	DbSelectArea("TRB")
	DbSkip()
	If Left(TRB->CODIGO,3) <> _grupo_atual .And. !_sintetico
		//----> imprime totais do grupo
		TotGrupo()
	EndIf
EndDo

If _nLin >= 57
	//----> imprime cabecalho do produto
	ImpCabec()
EndIf

_nlin:=_nlin+1

@ _nlin,000       PSAY "TOTAIS "
@ _nLin,Pcol()+05 PSAY _tgestoque  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+02 PSAY _tgcru      PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _tgtingindo PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _tgreproces PICTURE "@E 999,999.99"
@ _nLin,Pcol()+04 PSAY _tgpedcomp  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+02 PSAY _tgpedidos  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+00 PSAY _tgsaldo    PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _tgpro_mes  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+01 PSAY _tgqtd_tear PICTURE "@E 999,999.99"
@ _nLin,Pcol()+13 PSAY _tgval_cust PICTURE "@E 99,999,999.99"

_nlin:=_nlin + 2

@ _nlin,000 PSAY REPLICATE( "-", limite )
Eject

//----> cria um arquivo dbf para importacao no excel
If !Empty(MV_PAR10)
	_cNomeDbf := AllTrim(MV_PAR10)
	Copy To &_cNomeDbf
	
	//----> seleciono o SX1 para limpar a 10 pergunta para geracao do dbf para excel
	DbSelectArea('SX1')
	If DbSeek('EST01R10')
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := ''
		MsUnLock()
	EndIf
EndIf

//----> fecha e apaga os arquivos temporarios
DbSelectArea("TRB")
DbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

If mv_par11 == 1
	DbSelectArea("PED")
	DbCloseArea()
	Ferase(_cArqPed+".DBF")
	Ferase(_cArqPed+OrdBagExt())
EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	Set Device to Screen
	DbCommitAll()
	OurSpool(wnrel)
EndIf

Ms_Flush()

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpCabec
Static Function ImpCabec()
*---------------------------------------------------------------------------*

/*
1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
CODIGO     DESCRICAO                      ESTOQUE    CRU        TINGINDO   PEDIDOS    SALDO      PROD.MES   QT.TEARES
---------- ------------------------------ ---------- ---------- ---------- ---------- ---------- ---------- ----------
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
*/

cabec1 := "CODIGO       QTD TINTO     QTD CRU     TINGINDO     REPROCES     PEDCOMPRA     PEDIDOS     SALDO     PROD MES     TEARES     CUSTO/UN      VLR EST"
cabec2 := ""
Titulo   := "POSICAO DE ESTOQUE - " + If(mv_par07==1," S I N T E T I C O"," A N A L I T I C O" )
_nPag    := _nPag + 1

Cabec(Titulo,cabec1,cabec2,cNomePrg,Tamanho,_nTipo)

_nLin := 8

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Detalhe
Static Function Detalhe()
*---------------------------------------------------------------------------*

If _nLin >= 57
	ImpCabec()
EndIf

If MV_PAR07 == 2
	@ _nLin,000       PSAY Left(TRB->CODIGO,9)
	@ _nLin,Pcol()+01 PSAY TRB->LOCAL
	@ _nLin,Pcol()+00 PSAY TRB->ESTOQUE    PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+02 PSAY TRB->CRU        PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+03 PSAY TRB->TINGINDO   PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+03 PSAY TRB->REPROCES   PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+04 PSAY TRB->PEDCOMP    PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+02 PSAY TRB->PEDIDOS    PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+00 PSAY TRB->SALDO      PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+03 PSAY TRB->PRO_MES    PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+01 PSAY TRB->QTD_TEAR   PICTURE "@E 999,999.99"
	@ _nLin,Pcol()+05 PSAY TRB->CUSTO      PICTURE "@E 999.9999"
	@ _nLin,Pcol()+03 PSAY TRB->TOTAL      PICTURE "@E 999,999.99"
	
	_nlin:=_nlin+1
	
	//----> detalha os pedidos de vendas de cada produto
	If mv_par11 == 1
		ImpPedVen()
		_nLin:= _nLin+1
	EndIf
Else
	If TRB->SINT_ANA == "S"
		@ _nLin,000       PSAY 'GRUPO '+SubStr(TRB->CODIGO,1,3)
		@ _nLin,Pcol()+03 PSAY  TRB->ESTOQUE    PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+02 PSAY  TRB->CRU        PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+03 PSAY  TRB->TINGINDO   PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+03 PSAY  TRB->REPROCES   PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+02 PSAY  TRB->PEDIDOS    PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+00 PSAY 	TRB->SALDO      PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+03 PSAY  TRB->PRO_MES    PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+01 PSAY  TRB->QTD_TEAR   PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+16 PSAY  TRB->TOTAL      PICTURE "@E 999,999.99"
		
		_nlin:=_nlin+2
	EndIf
EndIf

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function TotGrupo
Static Function TotGrupo()
*---------------------------------------------------------------------------*

If _nLin >= 57
	ImpCabec()
EndIf

_nLin := _nLin + 1

@ _nlin,000       PSAY "GRUPO "+_grupo_atual
@ _nLin,Pcol()+03 PSAY _testoque  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+02 PSAY _tcru      PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _ttingindo PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _treproces PICTURE "@E 999,999.99"
@ _nLin,Pcol()+04 PSAY _tpedcomp  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+02 PSAY _tpedidos  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+00 PSAY _tsaldo    PICTURE "@E 999,999.99"
@ _nLin,Pcol()+03 PSAY _tpro_mes  PICTURE "@E 999,999.99"
@ _nLin,Pcol()+01 PSAY _tqtd_tear PICTURE "@E 999,999.99"
@ _nLin,Pcol()+16 PSAY _tval_cust PICTURE "@E 999,999.99"

_nlin:=_nlin + 1

@ _nlin,000 PSAY REPLICATE( "-", limite )

_nLin:= _nLin+1
_tcru      := 0
_testoque  := 0
_ttingindo := 0
_treproces := 0
_tpedcomp  := 0
_tpedidos  := 0
_tempenho  := 0
_tsaldo    := 0
_tpro_mes  := 0
_tqtd_tear := 0
_tval_cust := 0

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK1
Static Function CriaK1()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09
cQuery := ''
cQuery := "SELECT  B1_COD, B1_DESC, B1_LOCPAD, B1_TIPO, B1_PRODMES, B1_QTEARES, B1_STATUS, B1_UPRC, B1_CUSTD, B2_LOCAL, B2_QATU, B2_QPEDVEN, B2_QEMP, B2_QEMPPRE, B2_CM1, B2_VATU1, B2_SALPEDI "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
//cQuery := cQuery + " T1.B1_TIPO= 'PA' AND "  Jefferson
cQuery := cQuery + " T1.B1_COD>= '"+ _pi+"' AND T1.B1_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T2.B2_COD>= '"+ _pi+"' AND T2.B2_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
//cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
//cQuery := cQuery + " T1.B1_LOCPAD = '" + _lo + "' AND "
//cQuery := cQuery + " T2.B2_LOCAL =  '" + _lo + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
MEMOWRIT("C:\SQL01.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K1", .F., .T.)

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK3
Static Function CriaK3()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

DbSelectArea("SC2")
cQuery := ''
cQuery :="SELECT C2_QUANT, C2_PRODUTO, C2_QUJE , C2_PERDA, C2_TIPO"
cQuery := cQuery + "FROM  "+RetSQLName("SC2")+" T1 "
cQuery := cQuery + "WHERE T1.C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + " ((T1.C2_PRODUTO>= '1"+ _pi+"' AND T1.C2_PRODUTO <= '1"+_pf+"')  OR "
cQuery := cQuery + " (T1.C2_PRODUTO>= '"+ _pi+"' AND T1.C2_PRODUTO <= '"+_pf+"' )) AND "
//cQuery := cQuery + " T1.C2_LOCAL='"+_lo+"' AND "
cQuery := cQuery + " T1.C2_QUJE<>T1.C2_QUANT AND "
cQuery := cQuery + " (T1.C2_TIPO<>'50' OR T1.C2_TIPO<>'60') AND "
cQuery := cQuery + " (T1.C2_DATRF = '') AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.C2_PRODUTO"
MEMOWRIT("C:\SQL03.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K3", .F., .T.)

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK4
Static Function CriaK4()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

DbSelectArea("SC5")
DbSelectArea("SC6")

cQuery := ''
cQuery := "SELECT C5_NUM, C5_TIPO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_BLQ  "
cQuery := cQuery + "FROM "+RetSQLName("SC5")+" T1, "+RetSQLName("SC6")+" T2 "
cQuery := cQuery + "WHERE T1.C5_FILIAL = T2.C6_FILIAL AND "
cQuery := cQuery + "T1.C5_NUM = T2.C6_NUM AND T1.C5_TIPO = 'N' AND "
cQuery := cQuery + "T2.C6_PRODUTO >= '"+ _pi+"' AND T2.C6_PRODUTO <= '"+_pf+"' AND "
cQuery := cQuery + "(T2.C6_QTDVEN - T2.C6_QTDENT) > 0 AND C6_BLQ <> 'R' AND "
cQuery := cQuery + "T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + "T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY T2.C6_PRODUTO "
MEMOWRIT("C:\SQL04.txt",cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K4", .F., .T.)

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK6
Static Function CriaK6()
*---------------------------------------------------------------------------*
_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

DbSelectArea("SC5")
DbSelectArea("SC6")

cQuery := ''
cQuery := " SELECT C5_NUM,C5_TIPO,C5_EMISSAO,C5_CLIENTE,C6_NUM,C6_ITEM,C6_DESCRI,C6_PRODUTO,C6_QTDVEN,C6_QTDENT,C6_BLQ,C6_ENTREG,A1_NREDUZ " 
cQuery := cQuery + " FROM SC5010 "
cQuery := cQuery + " INNER JOIN SC6010 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM "
cQuery := cQuery + " INNER JOIN SA1010 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " 
cQuery := cQuery + " WHERE C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM " 
cQuery := cQuery + " AND C5_TIPO = 'N' AND C6_PRODUTO >= '"+ _pi+"' AND C6_PRODUTO <= '"+_pf+"' " 
cQuery := cQuery + " AND (C6_QTDVEN - C6_QTDENT) > 0 AND C6_BLQ <> 'R' AND SC5010.D_E_L_E_T_ <> '*' AND SC6010.D_E_L_E_T_ <> '*' ORDER BY C6_PRODUTO "

MEMOWRIT("C:\SQL06.txt",cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K6", .F., .T.)

TcSetField("K6","C6_ENTREG","D",TamSX3("C6_ENTREG")[1],TamSX3("C6_ENTREG")[2])



Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Calc_Sint
Static Function Calc_Sint()
*---------------------------------------------------------------------------*

DbSelectArea("TRB")
DbGoTop()

_cGrupo := SUBSTR(TRB->CODIGO,1,3)

Do While ! EOF()
	_tcru      := 0
	_testoque  := 0
	_ttingindo := 0
	_treproces := 0
	_tpedcomp  := 0
	_tpedidos  := 0
	_tempenho  := 0
	_tsaldo    := 0
	_tpro_mes  := 0
	_tqtd_tear := 0
	_nRecGrupo := Recno()
	
	Do While SUBSTR(TRB->CODIGO,1,3) == _cGrupo
		_tcru     := _tcru      + TRB->CRU
		_testoque := _testoque  + TRB->ESTOQUE
		_ttingindo:= _ttingindo + TRB->TINGINDO
		_treproces:= _treproces + TRB->REPROCES
		_tpedcomp := _tpedcomp  + TRB->PEDCOMP
		_tpedidos := _tpedidos  + TRB->PEDIDOS
		_tempenho := _tempenho  + TRB->EMPENHO
		_tsaldo   := _tsaldo    + TRB->SALDO
		_tpro_mes := _tpro_mes  + TRB->PRO_MES
		_tqtd_tear:= _tqtd_tear + TRB->QTD_TEAR
		RecLock("TRB",.f.)
		TRB->SINT_ANA :="X"
		MsUnLock()
		DbSkip()
	EndDo
	_nRecNext := Recno()
	
	DbGoTo(_nRecGrupo)
	If !Eof()
		RecLock("TRB",.f.)
		TRB->CRU      := _tcru
		TRB->ESTOQUE  := _testoque
		TRB->TINGINDO := _ttingindo
		TRB->REPROCES := _treproces
		TRB->PEDCOMP  := _tpedcomp
		TRB->PEDIDOS  := _tpedidos
		TRB->EMPENHO  := _tempenho
		TRB->SALDO    := _tsaldo
		TRB->PRO_MES  := _tpro_mes
		TRB->QTD_TEAR := _tqtd_tear
		TRB->SINT_ANA :="S"
		MsUnLock()
	EndIf
	
	DbGoTo(_nRecNext)
	_cGrupo := SUBSTR(TRB->CODIGO,1,3)
	
	If Eof()
		Exit
	EndIf
EndDo

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpPedVen
Static Function ImpPedVen()
*---------------------------------------------------------------------------*

DbSelectArea("PED")
If DbSeek(TRB->CODIGO)
	@ _nLin,000 PSAY Replicate("-",limite)
	_nLin := _nLin + 1
	@ _nLin,032       PSAY "CLIENTE"
	@ _nLin,062       PSAY "QUANTIDADE"
	@ _nLin,Pcol()+10 PSAY "PEDIDO"
	@ _nLin,Pcol()+08 PSAY "ITEM"
	@ _nLin,Pcol()+13 PSAY "DATA"
	_nlin:=_nlin+1
	
	While PED->CODIGO == TRB->CODIGO
       	@ _nLin,032       PSAY PED->CLIENTE       
		@ _nLin,062       PSAY PED->PEDIDOS    PICTURE "@E 999,999.99"
		@ _nLin,Pcol()+10 PSAY PED->NUMPED
		@ _nLin,Pcol()+08 PSAY PED->ITEMPV           
		@ _nLin,Pcol()+13 PSAY PED->DAT
		_nlin:=_nlin+1
		
		DbSelectArea("PED")
		DbSkip()
	EndDo
EndIf
@ _nLin,000 PSAY Replicate("-",limite)

Return()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05



