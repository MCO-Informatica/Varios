#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat13r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CGRUPO,CDESC,NQTDTOT,NVALTOT,NTAMANHO,NLIMITE")
SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,CBCONT,ARETURN")
SetPrvt("NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL,CSTRING")
SetPrvt("NLASTKEY,M_PAG,LABORTPRINT,AESTRUT,CNOMEARQ,CINDEX")
SetPrvt("CCHAVE,DINICIAL,CDESCR,CCABECAUX,CABEC1,CABEC2")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT13R  ³ Autor ³                       ³ Data ³22/06/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Curva ABC de Vendas e Faturamento por Grupo de Produtos    ³±±
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
* mv_par03                Do Cliente        ?                               *
* mv_par04                Ate o Cliente     ?                               *
* mv_par05                Do Vendedor       ?                               *
* mv_par06                Ate o Vendedor    ?                               *
* mv_par07                Tes de Vendas     ?                               *
* mv_par08                Lay Out           ? (Vendas/Faturamento)          *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cGrupo      := Space(03)       
cDesc       := Space(30)       
nQtdTot     := 0
nValTot     := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho    := "M"
nLimite     := 132
cTitulo     := "Curva ABC de Produtos por Grupo"
cDesc1      := "Este Programa Emitira o Relatorio da Curva A B C"
cDesc2      := "de Produtos por Grupo (Vendas/Faturamento/Ambos)"
cDesc3      := ""
cbCont      := 0
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "KFAT13R" 
cPerg       := "FAT13R    "
lContinua   := .t.
nLin        := 7
wnrel       := "KFAT13R"
cString     := "SC5"
nLastKey    := 0
m_Pag       := 1
lAbortPrint := .f.

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstrut  := {{"TMP_GRUPO"  ,"C",03,0},; 
             {"TMP_DESC"   ,"C",30,0},;
             {"TMP_QTD"    ,"N",12,2},;
             {"TMP_VAL"    ,"N",12,2},;
             {"TMP_LAY"    ,"C",01,0}}

cNomeArq := CriaTrab( aEstrut, .t. )
DbUseArea( .T., , cNomeArq, "TRB", .T., .F. )   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SC5")                 //----> Pedidos de Venda
DbSetOrder(2)                       //----> Data Emissao + Numero Pedido

DbSelectArea("SC6")                 //----> Itens dos Pedidos
DbSetOrder(1)                       //----> Produto + Pedido + Item

DbSelectArea("SD2")                 //----> Itens das Notas de Saida
DbSetOrder(3)                       //----> Produto + Local + Sequencia

DbSelectArea("SF2")                 //----> Cabe‡alho de Notas Fiscais Saida
DbSetOrder(5)                       //----> Emissao + Nota + Serie


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()

Pergunte( cPerg, .f. )

wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Imprime)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

//----> Curva ABC de Vendas

If mv_par08 == 1

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "" )

DbSelectArea("SC5")
DbSetOrder(2)

dInicial := mv_par01

If !DbSeek(xFilial("SC5")+Dtos(dInicial))
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek(xFilial("SC5") + Dtos(dInicial))
            Exit
        EndIf
    EndDo
EndIf

SetRegua(LastRec())

Do While !Eof() .And. SC5->C5_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SC5->C5_CLIENTE < mv_par03 .OR. SC5->C5_CLIENTE > mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SC5->C5_VEND1 < mv_par05 .OR. SC5->C5_VEND1 > mv_par06
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSeek( xFilial("SC6") + SC5->C5_NUM )

    Do While SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando apenas os tes selecionado nos parametros
        If !SC6->C6_TES $Alltrim(mv_par07)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)

        If !Empty(SB1->B1_X_ARTG)
            cGrupo := SUBS(SC6->C6_PRODUTO,1,3)
            cDescr := SB1->B1_X_ARTG
        Else
            cGrupo := Subs(SC6->C6_PRODUTO,1,3)
            cDescr := "*** NAO CADASTRADO ***"
        EndIf

        DbSelectArea("TRB")
        If DbSeek(cGrupo,.f.)
            RecLock( "TRB",.f. )
              TRB->TMP_QTD   :=   TRB->TMP_QTD + SC6->C6_QTDVEN
              TRB->TMP_VAL   :=   TRB->TMP_VAL + Iif(!SC5->C5_PAPELET$"O",SC6->C6_VALOR,(SC6->C6_VALOR * 2))
            MsUnLock()
        Else
            RecLock( "TRB", .t. )
              TRB->TMP_GRUPO :=   cGrupo
              TRB->TMP_DESC  :=   cDescr        
              TRB->TMP_QTD   :=   SC6->C6_QTDVEN
              TRB->TMP_LAY   :=   "V"
              TRB->TMP_VAL   :=   Iif(!SC5->C5_PAPELET$"O",SC6->C6_VALOL,(SC6->C6_VALOR * 2))
            MsUnLock()
        EndIf

        DbSelectArea("SC6")
        DbSkip()
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

//----> Curva ABC de Faturamento

ElseIf mv_par08 == 2

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "" )

DbSelectArea("SF2")
DbSetOrder(5)

dInicial := mv_par01

If !DbSeek(xFilial("SF2")+Dtos(dInicial))
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek(xFilial("SF2") + Dtos(dInicial))
            Exit
        EndIf
    EndDo
EndIf

SetRegua(LastRec())

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SF2->F2_CLIENTE < mv_par03 .OR. SF2->F2_CLIENTE > mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SF2->F2_VEND1 < mv_par05 .OR. SF2->F2_VEND1 > mv_par06
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )

    Do While SD2->D2_DOC == SF2->F2_DOC
      
        //----> filtrando apenas os tes selecionado nos parametros
        If !SD2->D2_TES $Alltrim(mv_par07)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)

        If !Empty(SB1->B1_X_ARTG)
            cGrupo := SUBS(SC6->C6_PRODUTO,1,3)
            cDescr := SB1->B1_X_ARTG
        Else
            cGrupo := Subs(SC6->C6_PRODUTO,1,3)
            cDescr := "*** NAO CADASTRADO ***"
        EndIf

        DbSelectArea("TRB")
        If DbSeek(cGrupo,.f.)
            RecLock( "TRB",.f. )
              TRB->TMP_QTD    :=   IIF(!ALLTRIM(SD2->D2_SERIE)$"12",TRB->TMP_QTD + SD2->D2_QUANT,TRB->TMP_QTD)
              TRB->TMP_VAL    :=   TRB->TMP_VAL + SD2->D2_TOTAL
            MsUnLock()
        Else
            RecLock( "TRB", .t. )
              TRB->TMP_GRUPO  :=   cGrupo
              TRB->TMP_DESC   :=   cDescr       
              TRB->TMP_QTD    :=   IIF(!ALLTRIM(SD2->D2_SERIE)$"12",SD2->D2_QUANT,0)
              TRB->TMP_LAY    :=   "F"
              TRB->TMP_VAL    :=   SD2->D2_TOTAL
            MsUnLock()
        EndIf

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

EndIf

//----> Impressao do Relatorio
cCabecAux   := Iif(mv_par08 == 1, " QUANTIDADE VENDIDA", "QUANTIDADE FATURADA")
cabec1      := "ARTIGO   DESCRICAO                    "+cCabecAux+"   % PARTIC     PRC MEDIO"
cabec2      := ""
cTitulo     := cTitulo+Iif(mv_par08 == 1, " - VENDAS", " - FATURAMENTO")
DbSelectArea("TRB")

cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_QTD"

IndRegua( "TRB", cIndex, cChave, , , "Preparando para Imprimir..." )

@ nLin, 000 PSAY AvalImp( nLimite )

Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)

DbGoBottom()
Do While !Bof()

    nQtdTot := nQtdTot + TRB->TMP_QTD
    nValTot := nValTot + TRB->TMP_VAL

    DbSkip(-1)
EndDo

SetRegua( LastRec() )
DbGoBottom()

Do While !Bof()

    @ nLin, 000         PSAY TRB->TMP_GRUPO
    @ nLin, Pcol()+05   PSAY TRB->TMP_DESC 
    @ nLin, Pcol()+03   PSAY TRB->TMP_QTD                   Picture"@E 999,999,999.99"
    @ nLin, Pcol()+04   PSAY ((TRB->TMP_QTD/nQtdTot)*100)   Picture"@E 999.99"
    @ nLin, Pcol()+02   PSAY TRB->TMP_VAL/TRB->TMP_QTD      Picture"@E 999,999,999.99"

    nLin := nLin + 1

    @ nLin , 000  PSAY Replicate( "-", nLimite )

    nLin := nLin + 1

    DbSkip(-1)

    If nLin > 60
        Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)
        nLin := 7
    EndIf

EndDo

nLin := nLin + 2

@ nLin, 000         PSAY "TOTAL"       
@ nLin, Pcol()+03   PSAY Space(30)       
@ nLin, Pcol()+03   PSAY nQtdTot            Picture"@E 999,999,999.99"
@ nLin, Pcol()+04   PSAY 100                Picture"@E 999.99"
@ nLin, Pcol()+02   PSAY nValTot/nQtdTot    Picture"@E 999,999,999.99"

Roda(CbCont,"Estatistica","M")

DbSelectArea("TRB")     
DbCloseArea("TRB")

fErase( cNomeArq+".dbf" )
fErase( cNomeArq+".idx" )
fErase( cNomeArq+".mem" )

If aReturn[5] == 1
   Set Printer To
   OurSpool(wnrel)
EndIf

Ms_Flush()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do Grupo de Perguntas                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Da Emissao              ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate a Emissao           ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Do Cliente              ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Ate o Cliente           ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Do Vendedor             ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Ate o Vendedor          ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Tes de Vendas           ?","mv_ch7","C",30,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Lay Out                 ?","mv_ch8","N",01,0,2,"C","","mv_par08","","Vendas","","","Faturamento","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !DbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    EndIf
Next

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
