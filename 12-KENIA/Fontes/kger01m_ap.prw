#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function kger01m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CBCONT,CBTXT,ARETURN,NOMEPROG,CPERG,LCONTINUA")
SetPrvt("LI,WNREL,CSTRING,NLASTKEY,M_PAG,LABORTPRINT")
SetPrvt("CABEC1,CABEC2,NTIPO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KGER01M  ³ Autor ³                       ³ Data ³03/09/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Demonstrativo de Apuracao de Resultados                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Testeis Ltda                              ³±±
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
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas nos Parametros                                       *
*                                                                           *
* mv_par01                Da Data           ?                               *
* mv_par02                Ate a Data        ?                               *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho    := "G"
nLimite     := 220
cTitulo     := "Demonstrativo de Apuracao de Resultados"
cDesc1      := "Este Programa Emitira o Demonstrativo de Apuracao de Resultados"
cDesc2      := ""
cDesc3      := "Kenia Industriais Texteis Ltda"
cbCont      := 0
cbTxt       := ""
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "KFAT14R" 
cPerg       := "GER01M"
lContinua   := .t.
li          := 60
wnrel       := "KGER01M"
cString     := "SF2"
nLastKey    := 0
m_Pag       := 1
lAbortPrint := .f.

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()

Pergunte( cPerg, .f. )

wnrel := "KGER01M"
wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
    Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Set Filter To
   Return
Endif

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Imprime)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

cabec1  := "PRF NUMERO    CLIENTE/LJ NOME                                DT. BASE    DATA      DATA       NUMERO    PEDIDO          VALOR        PERC          VALOR  TIPO"
cabec2  := "    TITULO                                                   COMISSAO    VENCTO    BAIXA      PEDIDO    INTERNO          BASE       COMIS          COMIS PAGTO"
nTipo   := Iif(aReturn[4]==1,15,18)

//----> DADOS DE FATURAMENTO

DbSelectArea("SF2")
DbSetOrder(5)   //----> DATA DE EMISSAO
DbSeek(xFilial("SF2")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

Do While !Eof() .and. Dtos(SF2->F2_EMISSAO) <= Dtos(MV_PAR02)

    IncProc("Processando Faturamento de "+Dtoc(SF2->F2_EMISSAO))

    //----> CONSIDERAR APENAS NOTAS FISCAIS QUE GERAM FINANCEIRO
    If SF2->F2_VALFAT <= 0
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    DbSetOrder(3)   //----> NOTA + SERIE
    DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE))

    Do While SD2->(D2_DOC+D2_SERIE) == SF2->(F2_DOC+F2_SERIE)

        DbSelectArea("FAT")
        //----> VERIFICA SE O PRODUTO JA ESTA GRAVADO
        If DbSeek(SD2->D2_COD,.F.)
            RecLock("FAT",.f.)
              FAT->QTDFAT   :=  FAT->QTDFAT + Iif(!Alltrim(SD2->D2_SERIE)$"12",SD2->D2_QUANT,0)
              FAT->VALFAT   :=  FAT->VALFAT + SD2->D2_TOTAL
            MsUnLock()
        Else
            RecLock("FAT",.t.)
              FAT->PRODUTO  :=  SD2->D2_COD
              FAT->QTDFAT   :=  Iif(!Alltrim(SD2->D2_SERIE)$"12",SD2->D2_QUANT,0)
              FAT->VALFAT   :=  SD2->D2_TOTAL
            MsUnLock()
        EndIf

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

//----> DADOS DE DEVOLUCOES

DbSelectArea("SF1")
DbSetOrder(6)   //----> DATA DE ENTRADA
DbSeek(xFilial("SF1")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

Do While !Eof() .And. Dtos(SF1->F1_DTDIGIT) <= Dtos(MV_PAR02)

    IncProc("Processando Devolucoes de "+Dtos(SF1->F1_DTDIGIT))

    //----> CONSIDERA APENAS DEVOLUCOES
    If !SF1->F1_TIPO$"D"
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD1")
    DbSetOrder(1)   //----> NOTA + SERIE + CLIENTE + LOJA
    DbSeek(xFilial("SD1")+SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA),.f.)

    Do While SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)

        DbSelectArea("DEV")
        //----> VERIFICA SE O PRODUTO JA ESTA GRAVADO
        If DbSeek(SD1->D1_COD,.F.)
            RecLock("DEV",.f.)
              DEV->QTDDEV   :=  DEV->QTDDEV + Iif(!Alltrim(SD1->D1_SERIE)$"12",SD1->D1_QUANT,0)
              DEV->VALDEV   :=  DEV->VALDEV + SD1->D1_TOTAL
            MsUnLock()
        Else
            RecLock("DEV",.t.)
              DEV->PRODUTO  :=  SD1->D1_COD
              DEV->QTDDEV   :=  Iif(!Alltrim(SD1->D1_SERIE)$"12",SD1->D1_QUANT,0)
              DEV->VALDEV   :=  SD1->D1_TOTAL
            MsUnLock()
        EndIf

        DbSelectArea("SD1")
        DbSkip()
    EndDo

    DbSelectArea("SF1")
    DbSkip()
EndDo

//----> DADOS DE MATERIA-PRIMA 
DbSelectArea("FAT")
ProcRegua(LastRec())

Do While !Eof()

    IncProc("Processando Materias-Primas do Periodo "+Dtoc(MV_PAR01)+" - "+Dtoc(MV_PAR02)) 

    DbSelectArea("SG1")
    DbSetOrder(1)
    If DbSeek("01"+FAT->PRODUTO,.f.)
        While SG1->G1_COD == FAT->PRODUTO

            DbSelectArea("SB1")
            DbSetOrder(1)
            DbSeek(xFilial("SB1")+SG1->G1_COMP,.f.)

            DbSelectArea("MAT")
            //----> VERIFICA SE O PRODUTO JA ESTA GRAVADO
            If DbSeek(SG1->G1_COMP,.f.)
                RecLock("MAT",.f.)
                  MAT->QTDMAT   :=  MAT->QTDMAT + SG1->G1_QUANT
                  MAT->VALMAT   :=  MAT->QTDMAT * SB1->B1_CUSTD
                MsUnLock()
            Else
                RecLock("MAT",.t.)
                  MAT->PRODUTO  :=  SG1->G1_COMP
                  MAT->QTDMAT   :=  SG1->G1_QUANT
                  MAT->VALMAT   :=  MAT->QTDMAT * SB1->B1_CUSTD
                MsUnLock()
            EndIf
        EndDo

        DbSelectArea("SG1")
        DbSkip()
    EndIf

    DbSelectArea("FAT")
    DbSkip()
EndDo
