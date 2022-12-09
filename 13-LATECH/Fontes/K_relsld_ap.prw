#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.ch"

User Function K_relsld()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
SetPrvt("_AARQUIVO,_CARQTRB,_TAM,_CODPROD,_SALDO,_NLIN")
SetPrvt("_NPAG,_NTIPO,M_PAG,_SINTETICO,_GRUPO_ATUAL,I")
SetPrvt("CQUERY,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ K_RELSLD ³ Autor ³Ricardo Cassolatto 	³ Data ³ 13.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Relacao de Saldos - USO Clinte Kenia		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
tamanho  := "P"
limite	 := 080
cDesc1	 := PADC("RELACAO DE SALDOS DE ESTOQUE",74)
cDesc2   := PADC("Especifico Kenia Tecelagem",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="K_RELSLD"
nLastkey := 0
cString  := "SF2"
lContinua:= .F.
wnrel	 := "K_RELSLD"
cNomePrg := "K_RELSLD"
titulo	 := "RELACAO DE SALDOS"

aOrd     := {}
aDriver  :=ReadDriver()
cPerg	 :="K_RSLD"
lEnd     := .F.

cbCont   := 00
Cbtxt    := Space( 10 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Produto Inicial                       ³
//³ mv_par02               Produto Final                         ³
//³ mv_par03			   Mostra Saldo Zero ?(S/N) 			 ³
//³ mv_par04			   Local de Estoque 					 ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{"K_RSLD","01","Produto Inicial     ?" ,"mv_ch1","C",15,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_RSLD","02","Produto Final       ?" ,"mv_ch2","C",15,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_RSLD","03","Saldo Zero  S/N     ?" ,"mv_ch3","N", 1,0,0,"C"," ","mv_par03","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_RSLD","04","Local de Estoque    ?" ,"mv_ch4","C", 2,0,0,"G"," ","mv_par04","01       ","","","         ","","","","","","","","","","","   ",})


//dbSelectArea("SX1")
//dbSeek(cPerg)
//Do While cPerg == SX1->X1_GRUPO
//	 RecLock("SX1",.F.)
//	 dbDelete()
//	 MsUnlock()
//	 dbSkip()
//EndDo


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

PERGUNTE(cPerg,.F.)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Arquivo Temporario utilizando TCQUERY                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CriaK1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trabalha os dados do arquivo gerado pela 1a.TcQuery          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("K1")
dbGotop()
ProcRegua(RecCount())
////////////////////////////////////////////////////////////
//seleciona os dados vindos do 1o. query do SQL Server... //
////////////////////////////////////////////////////////////
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nao esquecer de calcular o campo saldo no final do processo /³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()

  If Len(AllTrim(K1->B1_COD)) <> 6
     DBSKIP()
     LOOP
  EndIf

  If Substr(AllTrim(K1->B1_COD),4,3) == "000"
     DBSKIP()
     LOOP
  EndIf

  If Substr(AllTrim(K1->B1_COD),4,3) >= "900"
     DBSKIP()
     LOOP
  EndIf

  IncProc( OemToAnsi("Aguarde, processando Matriz....") )
  ////////////////////////////////////////////////////////////////////////////
  // a formula do campo saldo e ((ESTOQUE+CRU+TINGINDO)-PEDIDOS)-EMPENHO)//
  ////////////////////////////////////////////////////////////////////////////
  // Grava todos dados vindos do query //
  ///////////////////////////////////////
  DBSELECTAREA("TRB")
  RECLOCK( "TRB" , .t. )
  TRB->CODIGO   := K1->B1_COD
  TRB->ESTOQUE	:= K1->B2_QATU
  TRB->TINGINDO := 0.00
  TRB->PEDIDOS  := K1->B2_QPEDVEN
  TRB->EMPENHO  := K1->B2_QEMP
  TRB->SALDO    := 0.00            // sera calculado apos obter todos dados
  TRB->PRO_MES  := 0.00            // definir onde sera fornecido
  TRB->QTD_TEAR := 0.00            // definir onde sera fornecido
  TRB->SINT_ANA := "S"
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
ProcRegua(RecCount())
While !Eof()

  If Len(AllTrim(K2->B1_COD)) <> 7
     DBSKIP()
     LOOP
  EndIf
  
  If Substr(AllTrim(K1->B1_COD),5,3) == "000"
     DBSKIP()
     LOOP
  EndIf

  If Substr(AllTrim(K1->B1_COD),5,3) >= "900"
     DBSKIP()
     LOOP
  EndIf

  IncProc( OemToAnsi("Aguarde, processando Filial....") )
  DBSELECTAREA("TRB")
  ////////////////////////////////////////////////////
  // procura o produto "similar" para juntar saldos //
  ////////////////////////////////////////////////////
  If DBSEEK( SUBSTR(K2->B1_COD,2)+" ") // **procura a partir da segunda posicao **//
     RECLOCK( "TRB" , .f. )
	 TRB->ESTOQUE  := TRB->ESTOQUE+K2->B2_QATU
     TRB->PEDIDOS  := TRB->PEDIDOS+K2->B2_QPEDVEN
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
ProcRegua(RecCount())
While !Eof()

  _tam:=LEN(ALLTRIM(K3->C2_PRODUTO))
  IF _tam < 6 .OR. _tam > 7
     DBSKIP()
     LOOP
  ENDIF

  IncProc( OemToAnsi("Aguarde, analisando material em processo....") )

  IF _tam == 7
     _codprod:=SUBSTR(K3->C2_PRODUTO,2,6)
  ELSE
     _codprod:=AllTrim(K3->C2_PRODUTO)
  ENDIF

  If Substr(AllTrim(_CodProd),4,3) == "000"
     DBSKIP()
     LOOP
  EndIf

  If Substr(AllTrim(_CodProd),4,3) >= "900"
     DBSKIP()
     LOOP
  EndIf

  DBSELECTAREA("TRB")
  /////////////////////////////////////////////////
  // procura o produto "similar" para juntar PCP //
  /////////////////////////////////////////////////
  If DBSEEK( _codprod  )
     RECLOCK( "TRB" , .f. )
       TRB->TINGINDO := IIf(TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA) < 0, 0, TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA))  
     MSUNLOCK()
   ENDIF
   dbSelectArea("K3")
   dbSkip()

EndDo

dbSelectArea("K3")
dbCloseArea()

/////////////////////////////
// ** calcula os saldos ** //
/////////////////////////////
DBSELECTAREA("TRB")
DBGOTOP()
PROCREGUA( RECCOUNT() )

WHILE  !EOF()
  INCPROC( OEMTOANSI("Aguarde, processando....") )
  
  RECLOCK("TRB",.f.)
  
  // Recalcula o estoque para o item
  _saldo:=TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO-TRB->PEDIDOS-TRB->EMPENHO
  TRB->SALDO := _saldo

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
   IF MV_PAR03 == 2  // saldo zero
      IF TRB->SALDO == 0
		 RECLOCK("TRB",.f.)
           DBDELETE()
		 MSUNLOCK()
      ENDIF
   ENDIF

   DBSKIP()

END

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
_sintetico := .t.
IndRegua("TRB",_cArqTRB,"SINT_ANA+CODIGO",,,"Criando Indice ...")
DBGOTOP()
SetRegua(RecCount())
_grupo_atual:=" "

While !EOF()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o usuario interrompeu o relatorio                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lAbortPrint
    @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
    Exit
  Endif
  If TRB->SALDO <= 0.1
    DBSKIP()
    LOOP
  ENDIF

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

EJECT


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
Titulo	 := "RELACAO DE SALDOS"
_nPag    := _nPag + 1
Cabec(Titulo," "," ",cNomePrg,Tamanho,_nTipo)
@ 004,000 PSAY REPLICATE("-",LIMITE)
@ 005,000 PSAY "CODIGO       SALDO | CODIGO       SALDO | CODIGO       SALDO | CODIGO       SALDO "
//				XXXXXX	999,999.99	 XXXXXX  999,999.99   XXXXXX  999,999.99   XXXXXX  999,999.99
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
If TRB->SINT_ANA == "S"
   For i:= 0 to 3
	  If !Eof()
		 @ _nLin,000+(i*20)+i  PSAY SubStr(TRB->CODIGO,1,6)
         @ _nLin,008+(i*20)+i  PSAY TRB->SALDO     PICTURE "@E 999,999.99"
		 If i<3
			@ _nLin,019+(i*20)+i PSAY "|"
		 EndIf
		 dbSkip()
	  EndIf
   Next
   _nlin:=_nlin+1
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
_nLin:= _nLin+1
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
cQuery := ''
cQuery := "SELECT  B1_COD, B1_DESC, B1_LOCPAD, B2_QATU, B2_QPEDVEN, B2_QEMP "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
cQuery := cQuery + " T1.B1_COD>= '"+ mv_par01 +"' AND T1.B1_COD <= '"+MV_PAR02+"' AND "
cQuery := cQuery + " T2.B2_COD>= '"+ mv_par01 +"' AND T2.B2_COD <= '"+MV_PAR02+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
cQuery := cQuery + " T1.B1_LOCPAD = '" + MV_PAR04 + "' AND "
cQuery := cQuery + " T2.B2_LOCAL =  '" + MV_PAR04 + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
//MEMOWRIT("C:\SQL01.txt",cQuery)
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
cQuery := ''
cQuery :="SELECT    B1_COD, B1_DESC, B1_LOCPAD, B2_QATU, B2_QPEDVEN,B2_QEMP "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
cQuery := cQuery + " T1.B1_COD>= '1"+ LEFT(MV_PAR01,14)+"' AND T1.B1_COD <= '1"+LEFT(MV_PAR02,14)+"' AND "
cQuery := cQuery + " T2.B2_COD>= '1"+ LEFT(MV_PAR01,14)+"' AND T2.B2_COD <= '1"+LEFT(MV_PAR02,14)+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
cQuery := cQuery + " T1.B1_LOCPAD = '" + MV_PAR04 + "' AND "
cQuery := cQuery + " T2.B2_LOCAL =  '" + MV_PAR04 + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
//MEMOWRIT("C:\SQL02.txt",cQuery)
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
dbSelectArea("SC2")
cQuery := ''
cQuery :="SELECT C2_QUANT, C2_PRODUTO, C2_QUJE , C2_PERDA"
cQuery := cQuery + "FROM  "+RetSQLName("SC2")+" T1 "
cQuery := cQuery + "WHERE T1.C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + " ((T1.C2_PRODUTO>= '1"+ MV_PAR01+"' AND T1.C2_PRODUTO <= '1"+MV_PAR02+"')  OR "
cQuery := cQuery + " (T1.C2_PRODUTO>= '"+ MV_PAR01+"' AND T1.C2_PRODUTO <= '"+MV_PAR02+"' )) AND "
cQuery := cQuery + " T1.C2_LOCAL='"+MV_PAR04+"' AND "
cQuery := cQuery + " T1.C2_QUJE<>T1.C2_QUANT AND "
cQuery := cQuery + " (T1.C2_TIPO='1' OR T1.C2_ITEM='01') AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.C2_PRODUTO"
//MEMOWRIT("C:\SQL03.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K3", .F., .T.)
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

