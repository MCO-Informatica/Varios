#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#INCLUDE "TOPCONN.CH"

User Function Kpcp04r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,CSTRING,LCONTINUA,WNREL,TITULO")
SetPrvt("AORD,ADRIVER,CPERG,LEND,CBCONT,CBTXT")
SetPrvt("NLIN,NTIPO,M_PAG,CABEC1,CABEC2,_APERGUNTAS")
SetPrvt("_NLACO,_AARQUIVO,_CARQTRB,_CINDEX,_CORDEM,CNUMOP")
SetPrvt("CTIPO,CDESCRTIPO,CQUERY,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KPCP04R  ³ Autor ³                       ³ Data ³09/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao Estatistica de Producao pela Emissao das Op's      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.CH"

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados no Relatorio                                        *
* mv_par01      //----> Da Data        ?                                    *
* mv_par02      //----> Ate a Data     ?                                    *
* mv_par03      //----> Contem os Tipos?                                    *
* mv_par04      //----> Contem os Tipos?                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

tamanho  := "P"
limite	 := 080
cDesc1   := PADC("Estatistica das Producoes pela Emissao",74)
cDesc2   := PADC("Kenia Industrias Texteis Ltda",74)
cDesc3	 := ""
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1,"",0 }
nomeprog := "KPCP04R"
nLastkey := 0
cString  := "SC2"
lContinua:= .F.
wnrel    := "KPCP04R"
titulo   := "Estatistica Producao - Pela Emissao"
aOrd     := {}
aDriver  := ReadDriver()
cPerg    := "PCP04R    "
lEnd     := .F.
cbCont   := 00
Cbtxt    := Space( 10 )
nLin     := 8
nTipo    := Iif(aReturn[4]==1,15,18)
m_pag    := 1
// regua1  012345678901234567890123456789012345678901234567890123456789012345678901234567890
// regua2           10        20        30        40        50        60        70        80
cabec1   :="TIPO DE PRODUCAO       OCORRENCIAS       TOTAL KGS      TOTAL MTS"
cabec2   :=""

_aPerguntas:= {}

AADD(_aPerguntas,{cPerg,"01","Da Data             ?" ,"mv_ch1","D",08,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"02","Ate Data            ?" ,"mv_ch2","D",08,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"03","Contem os Tipos     ?" ,"mv_ch3","C",30,0,0,"G"," ","mv_par03","         ","","","         ","","","","","","","","","","","",})
AADD(_aPerguntas,{cPerg,"04","Contem os Tipos     ?" ,"mv_ch4","C",30,0,0,"G"," ","mv_par04","         ","","","         ","","","","","","","","","","","",})

DbSelectArea("SX1")
For _nLaco:=1 to LEN(_aPerguntas)

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
Next

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey == 27
     Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
     Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento das Informacoes                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||CalcRel()},"Selecionando os Dados para Estatistica")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(CalcRel)},"Selecionando os Dados para Estatistica")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

CriaSql()

_aArquivo:={}

AADD(_aArquivo,{"TIPO"     ,"C",02,0})
AADD(_aArquivo,{"DESCRI"   ,"C",22,0})
AADD(_aArquivo,{"OCORRE"   ,"N",06,0})
AADD(_aArquivo,{"QUANT"    ,"N",12,2})
AADD(_aArquivo,{"QUANTSEG" ,"N",12,2})

_cArqTrb    := CriaTrab(_aArquivo,.T.)

DbUseArea( .T.,, _cArqTrb, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )

_cIndex     := CriaTrab(Nil,.f.)
_cOrdem     := "TIPO"

IndRegua("TRB",_cIndex,_cOrdem,,,"Criando Indice ...")

DbSelectArea("SQL")
DbGoTop()
ProcRegua(RecCount())

Do While !Eof()

    IncProc("Selecionado Producoes - Op "+SQL->C2_NUM)

    cNumOp := SQL->C2_NUM
    cTipo  := SQL->C2_TIPO

    If !Empty(mv_par03) 
            //----> filtra somente os tipos selecionados no parametro
            If ! cTipo $ Alltrim(mv_par03)
                DbSelectArea("SQL")
                DbSkip()
                Loop
            EndIf
    EndIf

    If !Empty(mv_par04)
            //----> filtra somente os tipos selecionados no parametro
            If ! cTipo $ Alltrim(mv_par04)
                DbSelectArea("SQL")
                DbSkip()
                Loop
            EndIf
    EndIf

    DbSelectArea("SX5")
    DbSetOrder(1)
    DbSeek(xFilial("SX5")+"Z5"+cTipo)

    cDescrTipo := SX5->X5_DESCRI

    DbSelectArea("TRB")
    If DbSeek(cTipo)
        RecLock("TRB",.f.)
          TRB->QUANT    :=  TRB->QUANT    + Iif(SQL->C2_UM == "KG",SQL->C2_QTSEGUM,SQL->C2_QUANT)
          TRB->QUANTSEG :=  TRB->QUANTSEG + Iif(SQL->C2_UM == "KG",SQL->C2_QUANT,SQL->C2_QTSEGUM)
          TRB->OCORRE   :=  TRB->OCORRE + 1
        MsUnLock()
    Else
        RecLock("TRB",.t.)
          TRB->TIPO     :=  cTipo
          TRB->DESCRI   :=  cDescrTipo
          TRB->QUANT    :=  Iif(SQL->C2_UM == "KG",SQL->C2_QTSEGUM,SQL->C2_QUANT)
          TRB->QUANTSEG :=  Iif(SQL->C2_UM == "KG",SQL->C2_QUANT,SQL->C2_QTSEGUM)
          TRB->OCORRE   :=  1
        MsUnLock()
    EndIf

    DbSelectArea("SQL")
    DbSkip()

EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RptStatus({|| Rel_Kenia() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Rel_Kenia) })
Return   

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Rel_Kenia
Static Function Rel_Kenia()

DbSelectArea("TRB")
DbGoTop()

SetRegua(RecCount())

@ nLin, 000 Psay AvalImp(Limite)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

While !Eof()

    IncRegua()

    @ nLin, 000         PSAY    TRB->TIPO
    @ nLin, Pcol()      PSAY    " - "+TRB->DESCRI
    @ nLin, Pcol()+04   PSAY    TRB->OCORRE     Picture "@E 999"
    @ nLin, Pcol()+02   PSAY    TRB->QUANTSEG   Picture "@E 999,999,999.99"
    @ nLin, Pcol()+01   PSAY    TRB->QUANT      Picture "@E 999,999,999.99"

    nLin := nLin + 1

    @ nLin, 000         PSAY    Repli("-",limite)

    nLin := nLin + 1

    DbSkip()

EndDo

nLin := nLin + 3

@ nLin, 000     PSAY PADC("Os dados acima referem-se as Ordens de Producao emitidas no periodo de ",limite)
nLin := nLin + 2
@ nLin, 000     PSAY PADC(Dtoc(mv_par01)+" ate "+Dtoc(mv_par02),limite)

Roda(cbcont,cbtxt,tamanho)

DbSelectarea("TRB")
DbCloseArea()

Ferase(_cArqTrb+".DBF")
Ferase(_cArqTrb+OrdBagExt())

DbSelectarea("SQL")
DbCloseArea()

Set device to Screen

If aReturn[5] == 1    
   Set Printer TO

   Set Device to Screen
   DbCommitAll()
   ourspool(wnrel)
Endif

Ms_Flush()

Return   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaSql
Static Function CriaSql()

DbSelectArea("SC2")

cQuery := ''
cQuery :="SELECT C2_EMISSAO, C2_QUANT, C2_QTSEGUM , C2_UM, C2_SEGUM, "
cQuery := cQuery + "  C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN , C2_TIPO "
cQuery := cQuery + "  FROM  "+ RetSQLName("SC2")
cQuery := cQuery + "  WHERE C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + "        C2_EMISSAO >= '"+DTOS(MV_PAR01) +"' AND "
cQuery := cQuery + "        C2_EMISSAO <= '"+DTOS(MV_PAR02) +"' AND "
cQuery := cQuery + "        D_E_L_E_T_ <> '*' "

MemoWrit("C:\SQL.txt",cQuery)
cQuery := ChangeQuery(cQuery)

DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL", .F., .T.)

Return
