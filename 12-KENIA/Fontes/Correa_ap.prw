#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Correa()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AORD,CDESC1,CDESC2,CDESC3,CSTRING,TAMANHO")
SetPrvt("CABEC1,CABEC2,CPERG,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("NLIN,LIMITE,LRODAPE,WNREL,TITULO,CBTXT")
SetPrvt("CBCONT,M_PAG,_AARQ1,_CARQFIN1,_AARQ2,_CARQFIN2")
SetPrvt("_CINDFIN2,_CCHAFIN2,_CINDFIN1,_CCHAFIN1,_CNOMECLI,CQUERY")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN05R  ³ Autor ³Ricardo Correa de Souza³ Data ³23/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Titulos Recebidos via Cheques (Liquidacao)      ³±±
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aOrd := {}
cDesc1  := "Este relatorio tem o objetivo de Imprimir os titulos liquidados" 
cDesc2  := "por cheque" 
cDesc3  := ""           
cString :="SE1"
tamanho := "G"
cabec1  :=""
cabec2  :=""
cPerg   :="FIN05R"
aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="KFIN05R"
nLastKey:= 0
nLin    := 08
limite  := 220
lRodape :=.F.
wnrel   := "KFIN05R"
titulo  := "TITULOS BAIXADOS POR CHEQUE"
cbTxt   := SPACE(10)
cbCont  := 0
m_pag   := 1
cabec1  := "PRF NUMERO P TP  CODIGO LJ NOME       EMISSAO  VENCTO   BAIXA    VALOR        VALOR      SALDO      PRF  NUMERO  P  EMISSAO  VENCTO  BAIXA   VALOR    VALOR      SALDO                                                       "
cabec2  := "                                                                 TITULO       RECEBIDO   RECEBER    CHQ  CHEQUE                              CHEQUE   RECEBIDO   RECEBER                                                     "
//regua1    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//regua2             10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220

ValidPerg()

Pergunte( cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Temporarios                                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||Liquidacao()},"Liquidacao de Titulos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(Liquidacao)},"Liquidacao de Titulos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Liquidacao
Static Function Liquidacao()

_aArq1 := {}    //----> matriz da estrutura do arquivo temporario

AADD(_aArq1,{"PREFIXO"  ,"C",03,0})
AADD(_aArq1,{"NUMERO"   ,"C",06,0})
AADD(_aArq1,{"PARCELA"  ,"C",01,0})
AADD(_aArq1,{"TIPO"     ,"C",03,0})
AADD(_aArq1,{"CODCLI"   ,"C",06,0})
AADD(_aArq1,{"LOJA"     ,"C",02,0})
AADD(_aArq1,{"EMISSAO"  ,"D",08,0})
AADD(_aArq1,{"VENCTO"   ,"D",08,0})
AADD(_aArq1,{"BAIXA"    ,"D",08,0})
AADD(_aArq1,{"VALOR"    ,"N",12,2})
AADD(_aArq1,{"VALIQ"    ,"N",12,2})
AADD(_aArq1,{"SALDO"    ,"N",12,2})
AADD(_aArq1,{"NUMLIQ"   ,"C",06,0})

_cArqFin1 := CriaTrab(_aArq1,.T.)
dbUseArea( .T.,, _cArqFin1, "FIN1", If(.F. .OR. .F., !.F., NIL), .F. )

_aArq2 := {}    //----> matriz da estrutura do arquivo temporario
AADD(_aArq2,{"PREFCHQ"  ,"C",03,0})
AADD(_aArq2,{"NUMCHQ"   ,"C",06,0})
AADD(_aArq2,{"PARCCHQ"  ,"C",01,0})
AADD(_aArq2,{"TIPOCHQ"  ,"C",01,0})
AADD(_aArq2,{"CODCLI"   ,"C",06,0})
AADD(_aArq2,{"LOJA"     ,"C",02,0})
AADD(_aArq2,{"EMISCHQ"  ,"C",08,0})
AADD(_aArq2,{"VENCHQ"   ,"C",08,0})
AADD(_aArq2,{"BAICHQ"   ,"C",08,0})
AADD(_aArq2,{"VALCHQ"   ,"N",12,2})
AADD(_aArq2,{"LIQCHQ"   ,"N",12,2})
AADD(_aArq2,{"SALCHQ"   ,"N",12,2})
AADD(_aArq2,{"NUMLIQ"   ,"C",06,0})

_cArqFin2 := CriaTrab(_aArq2,.T.)
dbUseArea( .T.,, _cArqFin2, "FIN2", If(.F. .OR. .F., !.F., NIL), .F. )

Fin1()
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"Z1", .F., .T. )

DbSelectArea("Z1")
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Processando Titulo "+Z1->E1_PREFIXO+" "+Z1->E1_NUM+" "+Z1->E1_PARCELA)

    DbSelectArea("FIN1")
    RecLock("FIN1",.t.)
      FIN1->NUMLIQ      :=      Z1->E1_NUMLIQ
      FIN1->PREFIXO     :=      Z1->E1_PREFIXO
      FIN1->NUMERO      :=      Z1->E1_NUM   
      FIN1->PARCELA     :=      Z1->E1_PARCELA
      FIN1->TIPO        :=      Z1->E1_TIPO  
      FIN1->CODCLI      :=      Z1->E1_CLIENTE
      FIN1->LOJA        :=      Z1->E1_LOJA  
      FIN1->EMISSAO     :=      Z1->E1_EMISSAO
      FIN1->VENCTO      :=      Z1->E1_VENCTO
      FIN1->BAIXA       :=      Z1->E1_BAIXA
      FIN1->VALOR       :=      Z1->E1_VALOR 
      FIN1->VALIQ       :=      Z1->E1_VALLIQ
      FIN1->SALDO       :=      Z1->E1_SALDO 
    MsUnLock()

    DbSelectArea("Z1")
    DbSkip()

EndDo

//DbSelectArea("Z1")
//DbCloseArea("Z1")

Fin2()
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"Z2", .F., .T. )

DbSelectArea("Z2")
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Processando Cheque "+Z2->E1_PREFIXO+" "+Z2->E1_NUM+" "+Z2->E1_PARCELA)

    DbSelectArea("FIN2")
    RecLock("FIN2",.f.)
      FIN2->PREFCHQ     :=      Z2->E1_PREFIXO
      FIN2->NUMCHQ      :=      Z2->E1_NUM   
      FIN2->PARCCHQ     :=      Z2->E1_PARCELA
      FIN2->TIPOCHQ     :=      Z2->E1_PARCELA
      FIN2->CODCLI      :=      Z2->E1_CLIENTE
      FIN2->LOJA        :=      Z2->E1_LOJA  
      FIN2->EMISCHQ     :=      Z2->E1_EMISSAO
      FIN2->VENCHQ      :=      Z2->E1_VENCTO
      FIN2->BAICHQ      :=      Z2->E1_BAIXA
      FIN2->VALCHQ      :=      Z2->E1_VALOR
      FIN2->LIQCHQ      :=      Z2->E1_VALLIQ
      FIN2->SALCHQ      :=      Z2->E1_SALDO 
      FIN2->NUMLIQ      :=      Z2->E1_NUMLIQ
    MsUnLock()

    DbSelectArea("Z2")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RptStatus({|| Rel_Liquida()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Rel_Liquida)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Rel_Liquida
Static Function Rel_Liquida()

//----> ordena por titulo
If mv_par01 == 1

    DbSelectArea("FIN2")

    _cIndFin2 := CriaTrab(Nil,.f.)
    _cChaFin2 := "NUMLIQ+PREFCHQ+NUMCHQ+PARCCHQ"

    IndRegua("FIN2",_cIndFin2,_cChaFin2,,,"Indice por Cheque ...")
   
    DbSelectArea("FIN1")

    _cIndFin1 := CriaTrab(Nil,.f.)
    _cChaFin1 := "PREFIXO+NUMERO+PARCELA"

    IndRegua("FIN1",_cIndFin1,_cChaFin1,,,"Indice por Titulo ...")

    DbGoTop()
    SetRegua(LastRec())

    @ 000,000 Psay AvalImp(Limite)

    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

    While Eof() == .f.

        IncRegua()

        @ nLin, 000         Psay FIN1->PREFIXO
        @ nLin, Pcol()+01   Psay FIN1->NUMERO
        @ nLin, Pcol()+01   Psay FIN1->PARCELA
        @ nLin, Pcol()+01   Psay FIN1->TIPO
        @ nLin, Pcol()+01   Psay FIN1->CODCLI
        @ nLin, Pcol()+01   Psay FIN1->LOJA  

        _cNomeCli := Posicione("SA1",1,xFilial("SA1")+FIN1->CODCLI+FIN1->LOJA,"A1_NREDUZ")
        @ nLin, Pcol()+01   Psay _cNomeCli
        @ nLin, Pcol()+01   Psay FIN1->EMISSAO
        @ nLin, Pcol()+01   Psay FIN1->VENCTO
        @ nLin, Pcol()+01   Psay FIN1->BAIXA 
        @ nLin, Pcol()+01   Psay FIN1->VALOR 
        @ nLin, Pcol()+01   Psay FIN1->VALIQ 
        @ nLin, Pcol()+01   Psay FIN1->SALDO 

        nLin := nLin +1

        DbSelectArea("FIN2")
        DbSeek(FIN1->NUMLIQ)

        While FIN2->NUMLIQ == FIN1->NUMLIQ

            ALERT("L "+FIN2->NUMLIQ+" T "+FIN2->NUMCHQ)
            @ nLin, 000         Psay FIN2->PREFCHQ
            @ nLin, Pcol()+01   Psay FIN2->NUMCHQ
            @ nLin, Pcol()+01   Psay FIN2->PARCCHQ
            @ nLin, Pcol()+01   Psay FIN2->TIPOCHQ
            @ nLin, Pcol()+01   Psay FIN2->CODCLI
            @ nLin, Pcol()+01   Psay FIN2->LOJA  
    
            _cNomeCli := Posicione("SA1",1,xFilial("SA1")+FIN2->CODCLI+FIN2->LOJA,"A1_NREDUZ")
            @ nLin, Pcol()+01   Psay _cNomeCli
            @ nLin, Pcol()+01   Psay FIN2->EMISCHQ
            @ nLin, Pcol()+01   Psay FIN2->VENCHQ
            @ nLin, Pcol()+01   Psay FIN2->BAICHQ
            @ nLin, Pcol()+01   Psay FIN2->VALCHQ
            @ nLin, Pcol()+01   Psay FIN2->LIQCHQ
            @ nLin, Pcol()+01   Psay FIN2->SALCHQ

            nLin := nLin +1

            DbSelectArea("FIN2")
            DbSkip()

            If nLin > 58
                cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
                nLin := 8
            EndIf
        EndDo

        ALERT("SAI DO WHILE")
        @ nLin, 000    Psay Repl("-",limite)
        nLin := nLin + 1

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf

        DbSelectArea("FIN1")
        DbSkip()
    EndDo

//----> ordena por cheque
Else
    DbSelectArea("FIN2")

    _cIndFin2 := CriaTrab(Nil,.f.)
    _cChaFin2 := "PREFCHQ+NUMCHQ+PARCCHQ"

    IndRegua("FIN2",_cIndFin2,_cChaFin2,,,"Indice por Cheque ...")

    DbGoTop()
    SetRegua(LastRec())

    @ 000,000 Psay AvalImp(Limite)

    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

    While Eof() == .f.

        IncRegua()

        @ nLin, 000         Psay FIN2->PREFCHQ
        @ nLin, Pcol()+01   Psay FIN2->NUMCHQ
        @ nLin, Pcol()+01   Psay FIN2->PARCCHQ
        @ nLin, Pcol()+01   Psay FIN2->TIPOCHQ
        @ nLin, Pcol()+01   Psay FIN2->CODCLI
        @ nLin, Pcol()+01   Psay FIN2->LOJA  

        _cNomeCli := Posicione("SA1",xFilial("SA1")+FIN2->CODCLI+FIN2->LOJA,"A1_NREDUZ")
        @ nLin, Pcol()+01   Psay _cNomeCli
        @ nLin, Pcol()+01   Psay FIN2->EMISCHQ
        @ nLin, Pcol()+01   Psay FIN2->VENCHQ
        @ nLin, Pcol()+01   Psay FIN2->BAICHQ
        @ nLin, Pcol()+01   Psay FIN2->VALCHQ
        @ nLin, Pcol()+01   Psay FIN2->LIQCHQ
        @ nLin, Pcol()+01   Psay FIN2->SALCHQ

        nLin := nLin +1

        DbSelectArea("FIN1")

        _cIndFin1 := CriaTrab(Nil,.f.)
        _cChaFin1 := "NUMLIQ+PREFIXO+NUMERO+PARCELA"

        IndRegua("FIN1",_cIndFin1,_cChaFin1,,,"Indice por Titulo ...")

        DbSeek(FIN2->NUMLIQ)

        While FIN1->NUMLIQ == FIN2->NUMLIQ
            @ nLin, 000         Psay FIN1->PREFIXO
            @ nLin, Pcol()+01   Psay FIN1->NUMERO
            @ nLin, Pcol()+01   Psay FIN1->PARCELA
            @ nLin, Pcol()+01   Psay FIN1->TIPO   
            @ nLin, Pcol()+01   Psay FIN1->CODCLI
            @ nLin, Pcol()+01   Psay FIN1->LOJA  
    
            _cNomeCli := Posicione("SA1",xFilial("SA1")+FIN1->CODCLI+FIN1->LOJA,"A1_NREDUZ")
            @ nLin, Pcol()+01   Psay _cNomeCli
            @ nLin, Pcol()+01   Psay FIN1->EMISSAO
            @ nLin, Pcol()+01   Psay FIN1->VENCTO 
            @ nLin, Pcol()+01   Psay FIN1->BAIXA 
            @ nLin, Pcol()+01   Psay FIN1->VALOR 
            @ nLin, Pcol()+01   Psay FIN1->VALIQ 
            @ nLin, Pcol()+01   Psay FIN1->SALDO 

            nLin := nLin +1

            DbSelectArea("FIN1")
            DbSkip()

            If nLin > 58
                cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
                nLin := 8
            EndIf
        EndDo

        @ nLin, 000    Psay Repl("-",limite)
        nLin := nLin + 1

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf

        DbSelectArea("FIN2")
        DbSkip()
    EndDo

EndIf

Roda(cbCont,"Liquidacao",tamanho)

Set Device to Screen

If aReturn[5] == 1
    Set Printer To
    dbCommitAll()
    ourspool(wnrel)
Endif

DbSelectArea("FIN1")
DbCloseArea("FIN1")

DbSelectArea("FIN2")
DbCloseArea("FIN2")

DbSelectArea("Z1")
DbCloseArea("Z1")

DbSelectArea("Z2")
DbCloseArea("Z2")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fin1
Static Function Fin1()
*---------------------------------------------------------------------------*

cQuery := ''
cQuery := "SELECT E1.E1_NUMLIQ, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_CLIENTE,  "
cQuery := cQuery + " E1.E1_LOJA, E1.E1_EMISSAO, E1.E1_VENCTO, E1.E1_BAIXA, E1.E1_VALOR, E1.E1_VALLIQ, E1.E1_SALDO "
cQuery := cQuery + "FROM "
cQuery := cQuery + RetSQLName("SE1")+ " E1 "
cQuery := cQuery + "WHERE E1.E1_FILIAL  = '"+XFILIAL("SE1")+"'"
cQuery := cQuery + "  AND E1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "  AND E1.E1_PREFIXO >= '"+mv_par02+"' AND E1.E1_PREFIXO <= '"+mv_par03+"'"
cQuery := cQuery + "  AND E1.E1_NUM     >= '"+mv_par04+"' AND E1.E1_NUM     <= '"+mv_par05+"'"
cQuery := cQuery + "  AND E1.E1_PARCELA >= '"+mv_par06+"' AND E1.E1_PARCELA <= '"+mv_par07+"'"
cQuery := cQuery + "  AND E1.E1_TIPO <> 'CH' AND E1.E1_NUMLIQ <> ''"
cQuery := cQuery + "ORDER BY E1.E1_NUMLIQ"

MEMOWRIT("FIN01.SQL",cQuery)
cQuery := ChangeQuery(cQuery)

__RetProc()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fin2
Static Function Fin2()
*---------------------------------------------------------------------------*

cQuery := ''
cQuery := "SELECT E1.E1_NUMLIQ, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_CLIENTE,  "
cQuery := cQuery + " E1.E1_LOJA, E1.E1_EMISSAO, E1.E1_VENCTO, E1.E1_BAIXA, E1.E1_VALOR, E1.E1_VALLIQ, E1.E1_SALDO "
cQuery := cQuery + "FROM "
cQuery := cQuery + RetSQLName("SE1")+ " E1 "
cQuery := cQuery + "WHERE E1.E1_FILIAL  = '"+XFILIAL("SE1")+"'"
cQuery := cQuery + "  AND E1.E1_PREFIXO >= '"+mv_par08+"' AND E1.E1_PREFIXO <= '"+mv_par09+"'"
cQuery := cQuery + "  AND E1.E1_NUM     >= '"+mv_par10+"' AND E1.E1_NUM     <= '"+mv_par11+"'"
cQuery := cQuery + "  AND E1.E1_PARCELA >= '"+mv_par12+"' AND E1.E1_PARCELA <= '"+mv_par13+"'"
cQuery := cQuery + "  AND E1.E1_TIPO = 'CH' AND E1.E1_NUMLIQ <> '' "
cQuery := cQuery + "  AND E1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY E1.E1_NUMLIQ"

MEMOWRIT("FIN02.SQL",cQuery)
cQuery := ChangeQuery(cQuery)

__RetProc()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
*---------------------------------------------------------------------------*

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Busca Por      ? ','mv_ch1','N',01, 0, 2,'C', '', 'mv_par01','Titulo','','','Cheque','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Do Prefixo     ? ','mv_ch2','C',03, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Ate o Prefixo  ? ','mv_ch3','C',03, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Do Titulo      ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Ate o Titulo   ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Da Parcela     ? ','mv_ch6','C',01, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate a Parcela  ? ','mv_ch7','C',01, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Do Pref Cheque ? ','mv_ch8','C',03, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Ate Pref Cheque? ','mv_ch9','C',03, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'10','Do Cheque      ? ','mv_cha','C',06, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Ate o Cheque   ? ','mv_chb','C',06, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'12','Da Parc Cheque ? ','mv_chc','C',01, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'13','Ate Parc Cheque? ','mv_chd','C',01, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})

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

__RetProc()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

