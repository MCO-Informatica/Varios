#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kpcp01r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,CBCONT,CBTXT")
SetPrvt("NLASTKEY,LCONTINUA,M_PAG,NLIN,WNREL,CSTRING")
SetPrvt("CABEC1,CABEC2,NQTDAPO,NQTDTOT,NQTDPER,NQTDENC")
SetPrvt("NQTDSAL,NQTDRET,NQTDKG,NPERAPO,NPERTOT,NPERPER")
SetPrvt("NPERENC,NPERSAL,NPERRET,NQTDAPOT,NQTDTOTT,NQTDPERT")
SetPrvt("NQTDENCT,NQTDSALT,NQTDRETT,NQTDKGT,NPERAPOT,NPERTOTT")
SetPrvt("NPERPERT,NPERENCT,NPERSALT,NPERRETT,NQTDPART,AESTRU1")
SetPrvt("_CTEMP1,CPROD,CNUMOP,NQUANT,CTIPOPROD,NQTDOP")
SetPrvt("NPERPART,AREGS,I,J,CQUERY,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KPCP01R  ³ Autor ³Ricardo Correa de Souza³ Data ³26/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao Estatistica de Perda e Encolhimento das Op's       ³±±
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados no Relatorio                                        *
* mv_par01      //----> Do Produto    ?                                     *
* mv_par02      //----> Ate o Produto ?                                     *
* mv_par03      //----> Da Data       ?                                     *
* mv_par04      //----> Ate a Data    ?                                     *
* mv_par05      //----> Da OP         ?                                     *
* mv_par06      //----> Ate a OP      ?                                     *
* mv_par07      //----> Sint/Analit   ?                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

tamanho:= "G"
Limite := 220 
titulo := "Estatistica de Perdas (Reprocesso/Encolhimento/Retalho)"
cDesc1 := PADC("Este programa ira emitir a Estatistica de Perdas",74)
cDesc2 := PADC("das Ordens de Producao Tinturaria",74)
cDesc3 := PADC("Kenia Industrias Texteis Ltda",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "KPCP01R"
cPerg     := "PCP01R    "
cbCont    := 00
Cbtxt     := Space( 10 )
nLastKey  := 0 
lContinua := .T.
m_pag     := 1
nLin      := 8
wnrel     := "KPCP01R"
cString   := "SD3"
cabec1    := "NUMERO OP   PRODUTO           QUANT     %        DATA DO      QUANT         %         QUANT        %         QUANT         %         QUANT         %         QUANT          %         QUANT        %         QTDKG           "
cabec2    := "                              PARTI   PARTI      APONTAM      PRODU       PRODU       PERDA      PERDA       REPRO       REPRO       ENCOL       ENCOL       RETAL        RETAL       SALDO      SALDO       RETAL           "
//           "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//           "         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220"

nQtdApo :=  0
nQtdTot :=  0
nQtdPer :=  0
nQtdEnc :=  0
nQtdSal :=  0
nQtdRet :=  0
nQtdKg  :=  0

nPerApo :=  0
nPerTot :=  0
nPerPer :=  0
nPerEnc :=  0
nPerSal :=  0
nPerRet :=  0

nQtdApot :=  0
nQtdTott :=  0
nQtdPert :=  0
nQtdEnct :=  0
nQtdSalt :=  0
nQtdRett :=  0
nQtdKgt  :=  0

nPerApot :=  0
nPerTott :=  0
nPerPert :=  0
nPerEnct :=  0
nPerSalt :=  0
nPerRett :=  0

nQtdPart :=  0

ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

Pergunte( cPerg, .F. )

wnrel := SetPrint( cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .T. )

If nLastKey == 27
   Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"C",08,0})
AADD(aEstru1,{"PRODUTO" ,"C",15,0})
AADD(aEstru1,{"DOCUMEN" ,"C",06,0})
AADD(aEstru1,{"NUMOP"   ,"C",11,0})
AADD(aEstru1,{"QTDPAR"  ,"N",14,5})
AADD(aEstru1,{"QTDAPO"  ,"N",14,5})
AADD(aEstru1,{"QTDTOT"  ,"N",14,5})
AADD(aEstru1,{"QTDPER"  ,"N",14,5})
AADD(aEstru1,{"QTDENC"  ,"N",14,5})
AADD(aEstru1,{"QTDRET"  ,"N",14,5})
AADD(aEstru1,{"QTDSAL"  ,"N",14,5})
AADD(aEstru1,{"QTDKG "  ,"N",14,5})
AADD(aEstru1,{"PERPAR"  ,"N",06,2})
AADD(aEstru1,{"PERAPO"  ,"N",06,2})
AADD(aEstru1,{"PERTOT"  ,"N",06,2})
AADD(aEstru1,{"PERPER"  ,"N",06,2})
AADD(aEstru1,{"PERENC"  ,"N",06,2})
AADD(aEstru1,{"PERRET"  ,"N",06,2})
AADD(aEstru1,{"PERSAL"  ,"N",06,2})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SC2")         //----> Ordens de Producao
DbSetOrder(1)               //----> Numero da OP

DbSelectArea("SD3")         //----> Movimentacoes Internas
DbSetOrder(3)               //----> Produto + Numero da OP + Data do Apontamento

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||ApontaOp()},"Selecionando Dados Apontamento Producao")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(ApontaOp)},"Selecionando Dados Apontamento Producao")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ApontaOp
Static Function ApontaOp()

CriaD3()        //----> filtra dados da tabela SD3

DbSelectArea("D3")
ProcRegua(RecCount())

While Eof() == .f. 

    IncProc("Selecionando Dados da OP "+D3->D3_OP)

    cProd  := D3->D3_COD
    cNumOp := D3->D3_OP
    nQuant := 0

    DbSelectArea("SC2")
    DbSeek(xFilial("SC2")+cNumOp)

    cTipoProd := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_TIPO")

    //----> filtrando somente produtos acabados
    If ! cTipoProd $ "KT/TT"
        DbSelectArea("D3")
        DbSkip()
        Loop
    EndIf

    While D3->D3_COD == cProd .And. D3->D3_OP == cNumOp

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->PRODUTO      :=      D3->D3_COD
          TRB->NUMOP        :=      D3->D3_OP
          TRB->QTDPAR       :=      SC2->C2_QUANT
          TRB->QTDAPO       :=      D3->D3_QUANT
          TRB->QTDTOT       :=      D3->D3_PERDA
          TRB->QTDPER       :=      D3->D3_QTDPER
          TRB->QTDENC       :=      D3->D3_QTDENC
          TRB->QTDRET       :=      D3->D3_QTDRET
          TRB->QTDSAL       :=      (SC2->C2_QUANT - D3->D3_QUANT - D3->D3_PERDA) - nQuant
          TRB->QTDKG        :=      D3->D3_QTDKG
          TRB->EMISSAO      :=      D3->D3_EMISSAO
          TRB->PERPAR       :=      100.00
          TRB->PERAPO       :=      Round(((D3->D3_QUANT  / SC2->C2_QUANT) * 100),2)
          TRB->PERTOT       :=      Round(((D3->D3_PERDA  / SC2->C2_QUANT) * 100),2)
          TRB->PERPER       :=      Round(((D3->D3_QTDPER / SC2->C2_QUANT) * 100),2)
          TRB->PERENC       :=      Round(((D3->D3_QTDENC / SC2->C2_QUANT) * 100),2)
          TRB->PERRET       :=      Round(((D3->D3_QTDRET / SC2->C2_QUANT) * 100),2)
          TRB->PERSAL       :=      Round(((TRB->QTDSAL   / SC2->C2_QUANT) * 100),2)
          TRB->DOCUMEN      :=      D3->D3_DOC
        MsUnLock()

        nQuant := nQuant + D3->D3_QUANT + D3->D3_PERDA
        DbSelectArea("D3")
        DbSkip()
    EndDo
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RptStatus({|| RunProc()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(RunProc)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("TRB")
DbGoTop()

SetRegua(LastRec())

@ nLin, 000 Psay AvalImp(Limite)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

While Eof() == .f.

    IncRegua()

    cProd  := TRB->PRODUTO
    cNumOp := TRB->NUMOP

    @ nLin, 000      Psay cNumOp
    @ nLin, Pcol()+1 Psay cProd
    @ nLin, Pcol()+0 Psay TRB->QTDPAR           Picture "@E 9,999.99"
    @ nLin, Pcol()+2 Psay TRB->PERPAR           Picture "@E 999.99"

    nQtdPart := nQtdPart + TRB->QTDPAR

    While TRB->PRODUTO == cProd .And. TRB->NUMOP == cNumOp
        //----> impressao do relatorio analitico
        If mv_par07 == 2
            @ nLin, 049      Psay Subs(TRB->EMISSAO,7,2)+"/"+Subs(TRB->EMISSAO,5,2)+"/"+Subs(TRB->EMISSAO,3,2)
            @ nLin, Pcol()   Psay TRB->QTDAPO       Picture "@E 999,999.99"
            @ nLin, Pcol()+6 Psay TRB->PERAPO       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDTOT       Picture "@E 999,999.99"
            @ nLin, Pcol()+5 Psay TRB->PERTOT       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDPER       Picture "@E 999,999.99"
            @ nLin, Pcol()+6 Psay TRB->PERPER       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDENC       Picture "@E 999,999.99"
            @ nLin, Pcol()+6 Psay TRB->PERENC       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDRET       Picture "@E 999,999.99"
            @ nLin, Pcol()+7 Psay TRB->PERRET       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDSAL       Picture "@E 999,999.99"
            @ nLin, Pcol()+5 Psay TRB->PERSAL       Picture "@E 999.99"
            @ nLin, Pcol()+2 Psay TRB->QTDKG        Picture "@E 999,999.99"
        EndIf

        //----> totalizando as quantidades do produto
        nQtdApo :=  nQtdApo + TRB->QTDAPO
        nQtdTot :=  nQtdTot + TRB->QTDTOT
        nQtdPer :=  nQtdPer + TRB->QTDPER
        nQtdEnc :=  nQtdEnc + TRB->QTDENC
        nQtdRet :=  nQtdRet + TRB->QTDRET
        nQtdSal :=  Round(TRB->QTDPAR - nQtdApo - nQtdTot,2)
        nQtdKg  :=  nQtdKg  + TRB->QTDKG 

        //----> totalizando as quantidades geral
        nQtdApot :=  nQtdApot + TRB->QTDAPO
        nQtdTott :=  nQtdTott + TRB->QTDTOT
        nQtdPert :=  nQtdPert + TRB->QTDPER
        nQtdEnct :=  nQtdEnct + TRB->QTDENC
        nQtdRett :=  nQtdRett + TRB->QTDRET
        nQtdSalt :=  nQtdSal 
        nQtdKgt  :=  nQtdKgt  + TRB->QTDKG

        //----> totalizando os percentuais do produto
        nPerApo :=  nPerApo + TRB->PERAPO 
        nPerTot :=  nPerTot + TRB->PERTOT 
        nPerPer :=  nPerPer + TRB->PERPER 
        nPerEnc :=  nPerEnc + TRB->PERENC 
        nPerRet :=  nPerRet + TRB->PERRET 
        nPerSal :=  Int(TRB->PERPAR - nPerApo - nPerTot)

        nQtdOp := TRB->QTDPAR

        DbSkip()

        If mv_par07 == 2
            nLin := nLin + 1
        EndIf

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf
    EndDo

    If mv_par07 == 2
        //----> impressao dos totais e media ponderada em percentual
        nLin := nLin + 1
        @ nLin, 000        Psay "Total (Qtd /  % )"
        @ nLin, Pcol()+08  Psay nQtdOp                 Picture "@E 999,999.99"
        @ nLin, Pcol()+02  Psay 100.00                 Picture "@E 999.99"
        @ nLin, Pcol()+14  Psay nQtdApo                Picture "@E 999,999.99"
        @ nLin, Pcol()+06  Psay nPerApo                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdTot                Picture "@E 999,999.99"
        @ nLin, Pcol()+05  Psay nPerTot                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdPer                Picture "@E 999,999.99"
        @ nLin, Pcol()+06  Psay nPerPer                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdEnc                Picture "@E 999,999.99"
        @ nLin, Pcol()+06  Psay nPerEnc                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdRet                Picture "@E 999,999.99"
        @ nLin, Pcol()+07  Psay nPerRet                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdSal                Picture "@E 999,999.99"
        @ nLin, Pcol()+05  Psay nPerSal                Picture "@E 999.99"
        @ nLin, Pcol()+02  Psay nQtdKg                 Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Repli("-",Limite)
        nLin := nLin + 1

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf
    Else
        @ nLin, Pcol()+14  Psay nQtdApo                Picture "@E 999,999.99"
        @ nLin, Pcol()+6   Psay nPerApo                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdTot                Picture "@E 999,999.99"
        @ nLin, Pcol()+5   Psay nPerTot                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdPer                Picture "@E 999,999.99"
        @ nLin, Pcol()+6   Psay nPerPer                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdEnc                Picture "@E 999,999.99"
        @ nLin, Pcol()+6   Psay nPerEnc                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdRet                Picture "@E 999,999.99"
        @ nLin, Pcol()+7   Psay nPerRet                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdSal                Picture "@E 999,999.99"
        @ nLin, Pcol()+5   Psay nPerSal                Picture "@E 999.99"
        @ nLin, Pcol()+2   Psay nQtdKg                 Picture "@E 999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Repli("-",Limite)
        nLin := nLin + 1

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf
    EndIf

    //---> zerando variaveis totalizadoras - quantidade
    nQtdApo :=  0
    nQtdTot :=  0
    nQtdPer :=  0
    nQtdEnc :=  0
    nQtdRet :=  0
    nQtdSal :=  0
    nQtdKg  :=  0

    //---> zerando variaveis totalizadoras - percentual
    nPerApo :=  0
    nPerTot :=  0
    nPerPer :=  0
    nPerEnc :=  0
    nPerRet :=  0
    nPerSal :=  0

EndDo

nPerPart := 100.00
nPerApot := Round(((nQtdApot / nQtdPart) * 100),2)
nPerTott := Round(((nQtdTott / nQtdPart) * 100),2)
nPerPert := Round(((nQtdPert / nQtdPart) * 100),2)
nPerEnct := Round(((nQtdEnct / nQtdPart) * 100),2)
nPerRett := Round(((nQtdRett / nQtdPart) * 100),2)
nPerSalt := Round(((nQtdSalt / nQtdPart) * 100),2)


nLin := nLin + 1
@ nLin, 000        Psay "Total Geral      "
@ nLin, Pcol()+08  Psay nQtdPart               Picture "@E 999,999.99"
@ nLin, Pcol()+02  Psay nPerPart               Picture "@E 999.99"
@ nLin, Pcol()+14  Psay nQtdApot               Picture "@E 999,999.99"
@ nLin, Pcol()+06  Psay nPerApot               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdTott               Picture "@E 999,999.99"
@ nLin, Pcol()+05  Psay nPerTott               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdPert               Picture "@E 999,999.99"
@ nLin, Pcol()+06  Psay nPerPert               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdEnct               Picture "@E 999,999.99"
@ nLin, Pcol()+06  Psay nPerEnct               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdRett               Picture "@E 999,999.99"
@ nLin, Pcol()+07  Psay nPerRett               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdSalt               Picture "@E 999,999.99"
@ nLin, Pcol()+05  Psay nPerSalt               Picture "@E 999.99"
@ nLin, Pcol()+02  Psay nQtdKgt                Picture "@E 999,999.99"
nLin := nLin + 1
@ nLin, 000 Psay Repli("-",Limite)
nLin := nLin + 1

Roda(cbCont,"Estatistica",tamanho)

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

DbSelectArea("TRB")
DbCloseArea("TRB")

DbSelectArea("D3")
DbCloseArea("D3")

Ferase(_cTemp1+".dbf")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'03','Da Data        ? ','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','   '})
    aadd(aRegs,{cPerg,'04','Ate a Data     ? ','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','   '})
    aadd(aRegs,{cPerg,'05','Da OP          ? ','mv_ch5','C',11, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SD3'})
    aadd(aRegs,{cPerg,'06','Ate a OP       ? ','mv_ch6','C',11, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','SD3'})
    aadd(aRegs,{cPerg,'07','Sint/Analit    ? ','mv_ch7','N',01, 0, 0,'C', '', 'mv_par07','Sintetico','','','Analitico','','','','','','','','','','','   '})

    For i:=1 to Len(aRegs)
        Dbseek(cPerg+StrZero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to Fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaD3
Static Function CriaD3()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cQuery := ''
cQuery := "SELECT D3_COD, D3_OP, D3_EMISSAO, D3_QUANT, D3_PERDA, D3_QTDPER, D3_QTDENC, D3_QTDRET, D3_QTDKG, D3_DOC, D3_ESTORNO "
cQuery := cQuery + "FROM  "+RetSQLName("SD3")+" T1 "
cQuery := cQuery + "WHERE T1.D3_FILIAL = '"+xfilial("SD3")+"' AND "
cQuery := cQuery + "T1.D3_COD >= '"+mv_par01+"' AND T1.D3_COD <= '"+mv_par02+"' AND "
cQuery := cQuery + "T1.D3_EMISSAO >= '"+Dtos(mv_par03)+"' AND T1.D3_EMISSAO <= '"+Dtos(mv_par04)+"' AND "
cQuery := cQuery + "T1.D3_OP >= '"+mv_par05+"' AND T1.D3_OP <= '"+mv_par06+"' AND "
cQuery := cQuery + "SubString(T1.D3_CF,1,2) = 'PR' AND "
cQuery := cQuery + "T1.D3_ESTORNO = ' ' AND "
cQuery := cQuery + "T1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY T1.D3_COD, T1.D3_OP, T1.D3_EMISSAO"
MEMOWRIT("C:\SQL01.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"D3", .F., .T.)

Return()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

