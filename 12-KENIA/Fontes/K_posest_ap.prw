#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#Include "TOPCONN.ch"

User Function K_posest()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
SetPrvt("_AARQUIVO,_CARQTRB,_TAM,_CODPROD,_PI,_PF")
SetPrvt("_LO,CQUERY,_SALDO,_NLIN,_NPAG,_NTIPO")
SetPrvt("M_PAG,_SINTETICO,_TCRU,_TESTOQUE,_TTINGINDO,_TPEDIDOS")
SetPrvt("_TEMPENHO,_TSALDO,_TPRO_MES,_TQTD_TEAR,_TGCRU,_TGESTOQUE")
SetPrvt("_TGTINGINDO,_TGPEDIDOS,_TGEMPENHO,_TGSALDO,_TGPRO_MES,_TGQTD_TEAR")
SetPrvt("_GRUPO_ATUAL,_CNOMEDBF,_CGRUPO,_NRECGRUPO,_NRECNEXT,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #Include "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ K_POSEST ³ Autor ³Ricardo Cassolatto     ³ Data ³ 13.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de posicao de estoque - USO Clinte Kenia         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³          ³                                                 ³±±
±±³Analista  ³Data      ³Descricao                                        ³±±
±±³Marllon   ³27-02-2000³Calculo da quantidade em Ordem de Producao       ³±±
±±³Marllon   ³28-02-2000³Alteracao no Layout do relatorio diferenciando   ³±±
±±³          ³          ³tecido CRU do Tingido                            ³±±
±±³Marcos    ³24-04-2000³Inclusao do campo c2_perda no select da Query do ³±±
±±³          ³          ³Arquivo SC2                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Guarda Ambiente                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cAlias  := ALIAS()
_nOrdem  := INDEXORD()
_nRecno  := RECNO()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Variaveis                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho  := "M"
limite   := 132
cDesc1   := PADC("POSICAO DE ESTOQUE",74)
cDesc2   := PADC("Especifico Kenia Tecelagem",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="K_POSEST"
nLastkey := 0
cString  := "SF2"
lContinua:= .F.
wnrel    := "K_POSEST"
cNomePrg := "K_POSEST"
titulo   := "POSICAO DE ESTOQUE"

aOrd     := {}
aDriver  :=ReadDriver()
cPerg    :="K_PEST"
lEnd     := .F.

cbCont   := 00
Cbtxt    := Space( 10 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Produto Inicial                       ³
//³ mv_par02               Produto Final                         ³
//³ mv_par03               Produtos Inativos? (S/N)(saldo zerado)³
//³ mv_par04               Mostra Saldo Zero ?(S/N)              ³
//³ mv_par05               Cor inicial                           ³
//³ mv_par06               Cor Final                             ³
//³ mv_par07               (S)intetico/(A)nalitico               ³
//³ mv_par08               Apenas Tecido Cru?  (S/N)             ³
//³ mv_par09               Local de Estoque                      ³
//³ mv_par10               Nome do arquivo DBF para o Excel      ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{"K_PEST","01","Produto Inicial    ? " ,"mv_ch1","C",15,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_PEST","02","Produto Final      ? " ,"mv_ch2","C",15,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_PEST","03","Produtos Inativos S/N" ,"mv_ch3","N", 1,0,0,"C"," ","mv_par03","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_PEST","04","Saldo Zero  S/N     ?" ,"mv_ch4","N", 1,0,0,"C"," ","mv_par04","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_PEST","05","Cor Inicial        ? " ,"mv_ch5","C",15,0,0,"G"," ","mv_par05","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_PEST","06","Cor Final          ? " ,"mv_ch6","C",15,0,0,"G"," ","mv_par06","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_PEST","07","Sintetico/Analitico? " ,"mv_ch7","N", 1,0,0,"C"," ","mv_par07","Sintetico","","","Analitico","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_PEST","08","Apenas Tecido Cru  ? " ,"mv_ch8","N", 1,0,0,"C"," ","mv_par08","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_PEST","09","Local de Estoque   ?" ,"mv_ch9" ,"C", 2,0,0,"G"," ","mv_par09","01       ","","","         ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_PEST","10","Nome do DBF > Excel?" ,"mv_chA" ,"C",40,0,0,"G"," ","mv_par10","         ","","","         ","","","","","","","","","","","   ",})

dbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
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
NEXT

PERGUNTE(cPerg,.T.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey == 27
	 Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	 Return
Endif

Processa({||CalcRel()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(CalcRel)})
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*³     Processa os dados no temporario para obter e calcular os valores ³*
*³     vindos das TABELAS de SQL                                        ³*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura de Arquivo DBF temporario para armazenar resultado ³
//³ da TCQUERY                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArquivo:={}
AADD(_aArquivo,{"CODIGO"   ,"C",15,0})
AADD(_aArquivo,{"DESCRICAO","C",30,0})
AADD(_aArquivo,{"LOCAL"    ,"C",02,0})
AADD(_aArquivo,{"CRU"      ,"N",16,4})
AADD(_aArquivo,{"ESTOQUE"  ,"N",16,4})
AADD(_aArquivo,{"TINGINDO" ,"N",16,4})
AADD(_aArquivo,{"PEDIDOS"  ,"N",16,4})
AADD(_aArquivo,{"EMPENHO"  ,"N",16,4})
AADD(_aArquivo,{"SALDO"    ,"N",17,4})
AADD(_aArquivo,{"PRO_MES"  ,"N",16,4})
AADD(_aArquivo,{"QTD_TEAR" ,"N",16,4})
AADD(_aArquivo,{"SINT_ANA" ,"C",01,0})// este campo define sintetico/analitico
_cArqTRB:=CriaTrab(_aArquivo,.T.)
dbUseArea( .T.,, _cArqTRB, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",_cArqTRB,"CODIGO",,,"Criando Indice ...")
//ALERT( "Arquivo de trabalho gerado e --> "+_cArqTRB )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arquivo Temporario utilizando TCQUERY                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Onde serao obtidos os produtos "normais"
CriaK1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trabalha os dados do arquivo gerado pela 1a.TcQuery          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("K1")
dbGotop()
ProcRegua(LastRec())
//ALERT(" Nome do alias atual--->"+ALIAS())
////////////////////////////////////////////////////////////
//seleciona os dados vindos do 1o. query do SQL Server... //
////////////////////////////////////////////////////////////
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nao esquecer de calcular o campo saldo no final do processo /³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()

//-> Alterado pelo Marllon em 28/03/2000
// o resultado da query que gerou o K1 deve processar somente os itens 
// cujo codigo seja de 6 (seis) posicoes, ignorando todos os outros
//  _tam:=LEN(ALLTRIM(K1->B1_COD))
//_tam:=LEN(ALLTRIM(K1->B1_COD))
//  IF _tam<6 .OR. _tam>7
//     DBSKIP()
//     LOOP
//  ENDIF
  If Len(AllTrim(K1->B1_COD)) <> 6
	 DBSKIP()
	 LOOP
  EndIf

  IncProc( OemToAnsi("Processando Saldos em Estoque - Produto "+K1->B1_COD) )
  ////////////////////////////////////////////////////////////////////////////
  // a formula do campo saldo e ((ESTOQUE+CRU+TINGINDO)-PEDIDOS)-EMPENHO)//
  ////////////////////////////////////////////////////////////////////////////
  // Grava todos dados vindos do query //
  ///////////////////////////////////////
  DBSELECTAREA("TRB")
  RECLOCK( "TRB" , .t. )
  TRB->CODIGO   := K1->B1_COD
  TRB->DESCRICAO:= K1->B1_DESC
  TRB->LOCAL    := K1->B1_LOCPAD
  // este IF trata a troca da coluna de estoque para o produto CRU
  If RIGHT(AllTrim(K1->B1_COD),3) == '000'
	 TRB->CRU      := K1->B2_QATU
  Else
	 TRB->ESTOQUE  := K1->B2_QATU
  EndIf
  TRB->TINGINDO := 0.00
  //TRB->PEDIDOS  := K1->B2_QPEDVEN
  TRB->EMPENHO  := K1->B2_QEMP
  TRB->SALDO    := 0.00            // sera calculado apos obter todos dados
  TRB->PRO_MES  := 0.00            // definir onde sera fornecido
  TRB->QTD_TEAR := 0.00            // definir onde sera fornecido
  TRB->SINT_ANA := IF(MV_PAR07==1,"S","X")
  MSUNLOCK()
  DBSELECTAREA("K1")
  DBSKIP()
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arquivo Temporario utilizando TCQUERY                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Onde virao os produtos com "1" a mais para serem adidionados
// aos valores de estoque
CriaK2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trabalha os dados do arquivo gerado pela 2a.TcQuery          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("K2")
dbGotop()
ProcRegua(LastRec())
While !Eof()
//-> Alterado pelo Marllon em 28/03/2000
// o resultado da query que gerou o K2 deve processar somente os itens 
// cujo codigo seja de 7 (sete) posicoes, ignorando todos os outros
//  _tam:=LEN(ALLTRIM(K2->B1_COD))
//  IF _tam<6 .OR. _tam>7
//     DBSKIP()
//     LOOP
//  ENDIF
  
  If Len(AllTrim(K2->B1_COD)) <> 7
	 DBSKIP()
	 LOOP
  EndIf
  
  IncProc( OemToAnsi("Processando Saldos em Estoque - Produto "+K2->B1_COD) )
  DBSELECTAREA("TRB")
  ////////////////////////////////////////////////////
  // procura o produto "similar" para juntar saldos //
  ////////////////////////////////////////////////////
  If DBSEEK( SUBSTR(K2->B1_COD,2)+" ") // **procura a partir da segunda posicao **//
//  IF !EOF() .AND.  ALLTRIM(SUBSTR(K2->B1_COD,2))==ALLTRIM(TRB->CODIGO)
	 RECLOCK( "TRB" , .f. )
	 // este IF trata a troca da coluna de estoque para o produto CRU
	 If RIGHT(AllTrim(K2->B1_COD),3) == '000'
	TRB->CRU      := TRB->CRU+K2->B2_QATU
	 Else
	TRB->ESTOQUE  := TRB->ESTOQUE+K2->B2_QATU
	 EndIf
//     TRB->ESTOQUE  := TRB->ESTOQUE+K2->B2_QATU
//     TRB->PEDIDOS  := TRB->PEDIDOS+K2->B2_QPEDVEN
	 TRB->EMPENHO  := TRB->EMPENHO+K2->B2_QEMP
	 MSUNLOCK()
   ENDIF
   dbSelectArea("K2")
   dbSkip()
EndDo
///////////////////////////////////////////////////////////
// fecha os temporarios das query's  e continua processo //
// DEPOIS processa query do PCP                          //
///////////////////////////////////////////////////////////
dbSelectArea("K2")
dbCloseArea()
dbSelectArea("K1")
dbCloseArea()

//////////////////////////////////////////////////////////////////////////
// agora tem de procurar na producao os em tingimento para poder gravar //
//////////////////////////////////////////////////////////////////////////
CRIAK3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trabalha os dados do arquivo gerado pela 3a.TcQuery          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("K3")
dbGotop()
ProcRegua(LastRec())
While !Eof()
  _tam:=LEN(ALLTRIM(K3->C2_PRODUTO))
  IF _tam < 6 .OR. _tam > 7
	 DBSKIP()
	 LOOP
  ENDIF
  IncProc( OemToAnsi("Processando Ordens de Producao - Produto "+K3->C2_PRODUTO) )
//  IF LEN( ALLTRIM(K3->C2_PRODUTO) ) == 7
  IF _tam == 7
	 _codprod:=SUBSTR(K3->C2_PRODUTO,2,6)
  ELSE
	 _codprod:=AllTrim(K3->C2_PRODUTO)
  ENDIF
  DBSELECTAREA("TRB")
  /////////////////////////////////////////////////
  // procura o produto "similar" para juntar PCP //
  /////////////////////////////////////////////////
  If DBSEEK( _codprod  )
//  IF !EOF() .AND. ALLTRIM(_codprod)==ALLTRIM(TRB->CODIGO)
	 RECLOCK( "TRB" , .f. )
	 // TRB->TINGINDO := TRB->TINGINDO+K3->C2_QUANT
	 // Alterado pelo Marllon em 27/03/2000
	 // devo subtrair a quantidade ja produzida (C2_QUJE) para saber
	 // o saldo a produzir
	 // MSG 24/04/00  PARA Q CONSIDERE O CAMPO C2_PERDA
	 TRB->TINGINDO := Iif(TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA) < 0, 0, TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA))  
	 MSUNLOCK()
   ENDIF
   dbSelectArea("K3")
   dbSkip()
EndDo

dbSelectArea("K3")
dbCloseArea("K3")

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

dbSelectArea("SC5")
dbSelectArea("SC6")

cQuery := ''
cQuery := "SELECT C5_NUM, C5_TIPO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_BLQ "
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

//TCQUERY CQUERY NEW ALIAS "K4"
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K4", .F., .T.)

DbSelectArea("K4")
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.
	_tam := Len(Alltrim(K4->C6_PRODUTO))
	If _tam < 6 .Or. _tam > 6
		DbSkip()
		Loop
	EndIf
	 
	IncProc( OemToAnsi("Processando Pedidos de Vendas - Produto "+K4->C6_PRODUTO) )

	_codprod:=AllTrim(K4->C6_PRODUTO)
	
	DbSelectArea("TRB")
	If DbSeek(_codprod)
		RecLock("TRB",.f.)
				  
		  //----> Alterado pelo Ricardo 20/11/2000
		  //----> devo subtrair a quantidade ja entregue para saber
		  //----> o saldo de pedidos em aberto
		  TRB->PEDIDOS := TRB->PEDIDOS + (K4->C6_QTDVEN - K4->C6_QTDENT)
		  MsUnLock()
	EndIf
	DbSelectArea("K4")
	DbSkip()
EndDo

DbCloseArea()

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

dbSelectArea("SC5")
dbSelectArea("SC6")

cQuery := ''
cQuery := "SELECT C5_NUM, C5_TIPO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT "
cQuery := cQuery + "FROM "+RetSQLName("SC5")+" T1, "+RetSQLName("SC6")+" T2 "
cQuery := cQuery + "WHERE T1.C5_FILIAL = T2.C6_FILIAL AND "
cQuery := cQuery + "T1.C5_NUM = T2.C6_NUM AND T1.C5_TIPO = 'N' AND "
cQuery := cQuery + "T2.C6_PRODUTO >= '1"+ _pi+"' AND T2.C6_PRODUTO <= '1"+_pf+"' AND "
cQuery := cQuery + "(T2.C6_QTDVEN - T2.C6_QTDENT) > 0 AND C6_BLQ <> 'R' AND "
cQuery := cQuery + "T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + "T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY T2.C6_PRODUTO "
MEMOWRIT("C:\SQL05.txt",cQuery)
cQuery := ChangeQuery(cQuery)

//TCQUERY CQUERY NEW ALIAS "K5"
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K5", .F., .T.)

DbSelectArea("K5")
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.
	_tam := Len(Alltrim(K5->C6_PRODUTO))
	If _tam < 7 .Or. _tam > 7
		DbSkip()
		Loop
	EndIf
	 
	IncProc( OemToAnsi("Processando Pedidos de Vendas - Produto "+K5->C6_PRODUTO) )

	_codprod:=Subs(K5->C6_PRODUTO,2,6)
	
	DbSelectArea("TRB")
	If DbSeek(_codprod)
		RecLock("TRB",.f.)

				  
		  //----> Alterado pelo Ricardo 20/11/2000
		  //----> devo subtrair a quantidade ja entregue para saber
		  //----> o saldo de pedidos em aberto
		  TRB->PEDIDOS := TRB->PEDIDOS + (K5->C6_QTDVEN - K5->C6_QTDENT)
		  MsUnLock()
	EndIf
	DbSelectArea("K5")
	DbSkip()
EndDo

DbCloseArea()


/////////////////////////////
// ** calcula os saldos ** //
/////////////////////////////
DBSELECTAREA("TRB")
DBGOTOP()
PROCREGUA( RECCOUNT() )
WHILE  !EOF()
//  INCPROC( OEMTOANSI("Aguarde, processando....") )
  INCPROC( OEMTOANSI("Selecionando Dados para Impressao") )
  
  RECLOCK("TRB",.f.)
  
  // calculos incluido em 28/03/2000 (Marllon)
  // recalculo o estoque para o item
  // Diferencio o produto CRU do Tingido
  If RIGHT(AllTrim(TRB->CODIGO),3) == '000'
	 TRB->CRU      := TRB->CRU-TRB->EMPENHO
	 TRB->TINGINDO := 0
	 _saldo:=TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO-TRB->PEDIDOS
	 TRB->SALDO    := _saldo
  Else
	 _saldo:=TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO-TRB->PEDIDOS-TRB->EMPENHO
	 TRB->SALDO := _saldo
  EndIf
  
  MSUNLOCK()
  DBSKIP()
END
////////////////////////////////////////////////////////////////////
// processa os dados baseado nos parametros para filtrar os dados //
////////////////////////////////////////////////////////////////////
DBSELECTAREA("TRB")
DBGOTOP()
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ se for sem inativos ou sem mostrar saldo zero, elimina-os /³
// ³ e se for somente tecido cru tambem                         ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WHILE ! EOF()

   /////////////////////////////////
   // elimina saldo zero/inativos //
   /////////////////////////////////
   IF MV_PAR03==1 .OR. MV_PAR04==1 // elimina saldo zero/inativos
	  IF TRB->SALDO==0
	 RECLOCK("TRB",.f.)
	 DBDELETE()
	 MSUNLOCK()
	  ENDIF
   ENDIF

   ////////////////////////
   // somente tecido cru //
   ////////////////////////
   IF MV_PAR08==1
	  IF !RIGHT(ALLTRIM(TRB->CODIGO),3)=="000"
	 RECLOCK("TRB",.f.)
	 DBDELETE()
	 MSUNLOCK()
	  ENDIF
   ENDIF
   DBSKIP()

END
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿/
// ÃÄÄÄÄÄ acumula os valores se for relatorio sintetico ÄÄÄÄÄÄ´/
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/
IF MV_PAR07==1 //sintetiko
   CALC_SINT()
ENDIF
// agora vai para a impressao do relatorio //

*******************************************************************************
*******************************************************************************
****                           IMPRESSAO DOS DADOS                        *****
*******************************************************************************
*******************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para impressao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nLin      := 60
_nPag      := 0
_nTipo     := IIF(aReturn[4]==1,15,18)
m_pag      := 1
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime os dados do arquivo TRB                              ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| REL_KENIA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(REL_KENIA) })
__RetProc()

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄFUNCAO DE IMPRESSAO RELATORIOÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function REL_KENIA
Static Function REL_KENIA()
dbSelectArea("TRB")
_sintetico := .f.
IF MV_PAR07==1 // sintetiko //
   _sintetico := .t.
   IndRegua("TRB",_cArqTRB,"SINT_ANA+CODIGO",,,"Criando Indice ...")
ENDIF
DBGOTOP()
SetRegua(RecCount())
_tcru      := 0
_testoque  := 0
_ttingindo := 0
_tpedidos  := 0
_tempenho  := 0
_tsaldo    := 0
_tpro_mes  := 0
_tqtd_tear := 0
***************
_tgcru     := 0
_tgestoque := 0
_tgtingindo:= 0
_tgpedidos := 0
_tgempenho := 0
_tgsaldo   := 0
_tgpro_mes := 0
_tgqtd_tear:= 0
_grupo_atual:=" "

While !EOF()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o usuario interrompeu o relatorio                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lAbortPrint
	@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
	Exit
  Endif
  IF TRB->SINT_ANA<>"S" .AND. _sintetico
	 DBSKIP()
	 LOOP
  ENDIF
  /////////////////
  // grupo atual //
  /////////////////
  _grupo_atual := LEFT( TRB->CODIGO , 3 )
  ///////////////////////////////////////////////////////////
  //acumula totais, por grupo, geral p/ final de relatorio //
  ///////////////////////////////////////////////////////////

  ////////////////////////////////////////
  //            do grupo                //
  ////////////////////////////////////////
  _tcru     := _tcru      +  TRB->CRU
  _testoque := _testoque  +  TRB->ESTOQUE
  _ttingindo:= _ttingindo +  TRB->TINGINDO
  _tpedidos := _tpedidos  +  TRB->PEDIDOS
  _tempenho := _tempenho  +  TRB->EMPENHO
  _tsaldo   := _tsaldo    +  TRB->SALDO
  _tpro_mes := _tpro_mes  +  TRB->PRO_MES
  _tqtd_tear:= _tqtd_tear +  TRB->QTD_TEAR
  
  ////////////////////////////////////////
  //               geral                //
  ////////////////////////////////////////
  _tgcru     := _tgcru     + TRB->CRU
  _tgestoque := _tgestoque + TRB->ESTOQUE
  _tgtingindo:= _tgtingindo+ TRB->TINGINDO
  _tgpedidos := _tgpedidos + TRB->PEDIDOS
  _tgempenho := _tgempenho + TRB->EMPENHO
  _tgsaldo   := _tgsaldo   + TRB->SALDO
  _tgpro_mes := _tgpro_mes + TRB->PRO_MES
  _tgqtd_tear:= _tgqtd_tear+ TRB->QTD_TEAR
  
  /////////////////////////////
  // *** imprime DETALHE *** //
  /////////////////////////////
  DETALHE()

  //////////////////////////////////////////////////
  // vai pro proximo e verifica se imprime totais //
  //////////////////////////////////////////////////
  DBSKIP()
  
  IF LEFT(TRB->CODIGO,3) <> _grupo_atual .AND. !_sintetico
	 TOTGRUPO()
  ENDIF
EndDo

//////////////////////////////////////
// TOTAL GERAL APOS IMPRESSAO FINAL //
//////////////////////////////////////
If _nLin >= 57
   IMPCABEC()
EndIf
_nlin:=_nlin+1
@ _nlin,000 PSAY "  T O T A L  G E R A L ----> "
@ _nLin,049 PSAY _tgestoque  PICTURE "@E 999,999.99"
@ _nLin,060 PSAY _tgcru      PICTURE "@E 999,999.99"
@ _nLin,071 PSAY _tgtingindo PICTURE "@E 999,999.99"
@ _nLin,082 PSAY _tgpedidos  PICTURE "@E 999,999.99"
@ _nLin,093 PSAY _tgsaldo    PICTURE "@E 999,999.99"
@ _nLin,104 PSAY _tgpro_mes  PICTURE "@E 999,999.99"
@ _nLin,115 PSAY _tgqtd_tear PICTURE "@E 999,999.99"
_nlin:=_nlin + 2
@ _nlin,000 PSAY REPLICATE( "-", limite )
EJECT


// cria um arquivo DBF para importacao no Excel
If !Empty(MV_PAR10)
   _cNomeDBF := AllTrim(MV_PAR10)
   COPY TO &_cNomeDBF
   
   // seleciono o SX1 para limpar a 10 pergunta para geracao do DBF > Excel
   dbSelectArea('SX1')
   If dbSeek('K_PEST10')
	  RecLock('SX1',.F.)
	 SX1->X1_CNT01 := ''
	  MSUNLOCK()
   EndIf
EndIf

// Fecha e apaga os arquivos temporarios
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

// retorna a area anterior
DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Set device to Screen
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
   Set Printer TO
   Set Device to Screen
   DbCommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
__RetProc()

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ CABECALHOS E LINHAS DE DETALHE DO RELATORIO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpCabec
Static Function ImpCabec()
*****************
/*
	 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
CODIGO     DESCRICAO                      ESTOQUE    CRU        TINGINDO   PEDIDOS    SALDO      PROD.MES   QT.TEARES
---------- ------------------------------ ---------- ---------- ---------- ---------- ---------- ---------- ----------
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
*/
Titulo   := "POSICAO DE ESTOQUE - " + ;
		IF(mv_par07==1," S I N T E T I C O"," A N A L I T I C O" )
_nPag    := _nPag + 1
Cabec(Titulo," "," ",cNomePrg,Tamanho,_nTipo)
@ 004,000 PSAY REPLICATE("-",LIMITE)
@ 005,000 PSAY "CODIGO"
@ 005,018 PSAY "DESCRICAO"
@ 005,049 PSAY "ESTOQUE"
@ 005,060 PSAY "CRU"
@ 005,071 PSAY "TINGINDO"
@ 005,082 PSAY "PEDIDOS"
@ 005,093 PSAY "SALDO"
@ 005,104 PSAY "PROD.MES"
@ 005,115 PSAY "QT.TEARES"
@ 006,001 PSAY REPLICATE("-",LIMITE)
_nLin := 7
__RetProc()
*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Detalhe
Static Function Detalhe()
If _nLin >= 57
   IMPCABEC()
EndIf
If MV_PAR07 == 2    // Analitico
   @ _nLin,000 PSAY TRB->CODIGO
   @ _nLin,018 PSAY TRB->DESCRICAO
   @ _nLin,049 PSAY TRB->ESTOQUE    PICTURE "@E 999,999.99"
   @ _nLin,060 PSAY TRB->CRU        PICTURE "@E 999,999.99"
   @ _nLin,071 PSAY TRB->TINGINDO   PICTURE "@E 999,999.99"
   @ _nLin,082 PSAY TRB->PEDIDOS    PICTURE "@E 999,999.99"
   @ _nLin,093 PSAY TRB->SALDO      PICTURE "@E 999,999.99"
   @ _nLin,104 PSAY TRB->pro_mes    PICTURE "@E 999,999.99"
   @ _nLin,115 PSAY TRB->QTD_TEAR   PICTURE "@E 999,999.99"
  _nlin:=_nlin+1
Else
   If TRB->SINT_ANA == "S"
	  @ _nLin,000 PSAY 'Grupo -> '+SubStr(TRB->CODIGO,1,3)
	  @ _nLin,018 PSAY TRB->DESCRICAO
	  @ _nLin,049 PSAY TRB->ESTOQUE    PICTURE "@E 999,999.99"
	  @ _nLin,060 PSAY TRB->CRU        PICTURE "@E 999,999.99"
	  @ _nLin,071 PSAY TRB->TINGINDO   PICTURE "@E 999,999.99"
	  @ _nLin,082 PSAY TRB->PEDIDOS    PICTURE "@E 999,999.99"
	  @ _nLin,093 PSAY TRB->SALDO      PICTURE "@E 999,999.99"
	  @ _nLin,104 PSAY TRB->pro_mes    PICTURE "@E 999,999.99"
	  @ _nLin,115 PSAY TRB->QTD_TEAR   PICTURE "@E 999,999.99"
	 _nlin:=_nlin+2
  EndIf
EndIf

__RetProc()

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿
*³                       Imprime total do Grupo                              ³³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÙ

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION TOTGRUPO
Static FUNCTION TOTGRUPO()
If _nLin >= 57
   IMPCABEC()
EndIf
//@ _nlin,000 PSAY REPLICATE( "-", limite )
//_nlin:=_nlin+1
@ _nlin,000 PSAY "TOTAIS DO  GRUPO ---> "+_grupo_atual
@ _nLin,049 PSAY _testoque  PICTURE "@E 999,999.99"
@ _nLin,060 PSAY _tcru      PICTURE "@E 999,999.99"
@ _nLin,071 PSAY _ttingindo PICTURE "@E 999,999.99"
@ _nLin,082 PSAY _tpedidos  PICTURE "@E 999,999.99"
@ _nLin,093 PSAY _tsaldo    PICTURE "@E 999,999.99"
@ _nLin,104 PSAY _tpro_mes  PICTURE "@E 999,999.99"
@ _nLin,115 PSAY _tqtd_tear PICTURE "@E 999,999.99"
_nlin:=_nlin + 1
@ _nlin,000 PSAY REPLICATE( "-", limite )
_nLin:= _nLin+1
_tcru      := 0
_testoque  := 0
_ttingindo := 0
_tpedidos  := 0
_tempenho  := 0
_tsaldo    := 0
_tpro_mes  := 0
_tqtd_tear := 0
__RetProc()

*******************************************************************************
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*³ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿³*
*³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  QUERY's do SQL ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´³*
*³ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ³*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
*******************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para retornar arquivo de trabalho atraves de QUERY    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK1
Static Function CriaK1()
_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09
cQuery := ''
cQuery := "SELECT  B1_COD, B1_DESC, B1_LOCPAD, B2_QATU, B2_QPEDVEN, B2_QEMP "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
cQuery := cQuery + " T1.B1_COD>= '"+ _pi+"' AND T1.B1_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T2.B2_COD>= '"+ _pi+"' AND T2.B2_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
cQuery := cQuery + " T1.B1_LOCPAD = '" + _lo + "' AND "
cQuery := cQuery + " T2.B2_LOCAL =  '" + _lo + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
MEMOWRIT("C:\SQL01.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K1", .F., .T.)
__RetProc()

******************************************************************************
****                   Segunda Query, produtos codigo diferente "1"       
****
******************************************************************************

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK2
Static Function CriaK2()
_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09
cQuery := ''
cQuery :="SELECT    B1_COD, B1_DESC, B1_LOCPAD, B2_QATU, B2_QPEDVEN,B2_QEMP "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
cQuery := cQuery + " T1.B1_COD>= '1"+ LEFT(_pi,14)+"' AND T1.B1_COD <= '1"+LEFT(_pf,14)+"' AND "
cQuery := cQuery + " T2.B2_COD>= '1"+ LEFT(_pi,14)+"' AND T2.B2_COD <= '1"+LEFT(_pf,14)+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
cQuery := cQuery + " T1.B1_LOCPAD = '" + _lo + "' AND "
cQuery := cQuery + " T2.B2_LOCAL =  '" + _lo + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
MEMOWRIT("C:\SQL02.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K2", .F., .T.)
__RetProc()

******************************************************************************
****      Terceira Query - Produtos em producao                           
****
******************************************************************************

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK3
Static Function CriaK3()
_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR09

dbSelectArea("SC2")
cQuery := ''
cQuery :="SELECT C2_QUANT, C2_PRODUTO, C2_QUJE , C2_PERDA"
cQuery := cQuery + "FROM  "+RetSQLName("SC2")+" T1 "
cQuery := cQuery + "WHERE T1.C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + " ((T1.C2_PRODUTO>= '1"+ _pi+"' AND T1.C2_PRODUTO <= '1"+_pf+"')  OR "
cQuery := cQuery + " (T1.C2_PRODUTO>= '"+ _pi+"' AND T1.C2_PRODUTO <= '"+_pf+"' )) AND "
cQuery := cQuery + " T1.C2_LOCAL='"+_lo+"' AND "
cQuery := cQuery + " T1.C2_QUJE<>T1.C2_QUANT AND "
cQuery := cQuery + " (T1.C2_TIPO='1' OR T1.C2_ITEM='01') AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.C2_PRODUTO"
MEMOWRIT("C:\SQL03.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K3", .F., .T.)
__RetProc()

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ACUMULA VALORES PARA SINTETICO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´*
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION CALC_SINT
Static FUNCTION CALC_SINT()
DBSELECTAREA("TRB")
DBGOTOP()

// Processamento alterado em 28/03/2000 (Marllon) para tratamento dos 
// grupos de produtos (os 3 primeiros carac. do codigo do produto devem
// ser aglutinados quando forem iguais

// inicializa variavel de comparacao
_cGrupo := SUBSTR(TRB->CODIGO,1,3)

Do WHILE ! EOF()  // pega so o primeiro do grupo e grava para totalizar
   _tcru      := 0
   _testoque  := 0
   _ttingindo := 0
   _tpedidos  := 0
   _tempenho  := 0
   _tsaldo    := 0
   _tpro_mes  := 0
   _tqtd_tear := 0
   _nRecGrupo := Recno()

   Do WHILE SUBSTR(TRB->CODIGO,1,3) == _cGrupo
	  _tcru     := _tcru      + TRB->CRU
	  _testoque := _testoque  + TRB->ESTOQUE
	  _ttingindo:= _ttingindo + TRB->TINGINDO
	  _tpedidos := _tpedidos  + TRB->PEDIDOS
	  _tempenho := _tempenho  + TRB->EMPENHO
	  _tsaldo   := _tsaldo    + TRB->SALDO
	  _tpro_mes := _tpro_mes  + TRB->PRO_MES
	  _tqtd_tear:= _tqtd_tear + TRB->QTD_TEAR
	  RECLOCK("TRB",.f.)
	TRB->SINT_ANA :="X"
	  MSUNLOCK()
	  DBSKIP()
   EndDo
   _nRecNext := Recno()
   
   /////////////////////
   // grava os totais //
   /////////////////////
   dbGoTo(_nRecGrupo)
   IF !EOF()
	  RECLOCK("TRB",.f.)
	  TRB->CRU      := _tcru
	  TRB->ESTOQUE  := _testoque
	  TRB->TINGINDO := _ttingindo
	  TRB->PEDIDOS  := _tpedidos
	  TRB->EMPENHO  := _tempenho
	  TRB->SALDO    := _tsaldo
	  TRB->PRO_MES  := _tpro_mes
	  TRB->QTD_TEAR := _tqtd_tear
	  TRB->SINT_ANA :="S"
	  MSUNLOCK()
   ENDIF
   
   // recupero o proximo grupo
   dbGoTo(_nRecNext)
   _cGrupo := SUBSTR(TRB->CODIGO,1,3)

//   DBSKIP()
   If Eof()
	  Exit
   EndIf
ENDDO

__RetProc()



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

