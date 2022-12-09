#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat14r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CBCONT,CBTXT,ARETURN,NOMEPROG,CPERG,LCONTINUA")
SetPrvt("LI,WNREL,CSTRING,NLASTKEY,M_PAG,LABORTPRINT")
SetPrvt("CABEC1,CABEC2,NTIPO,NVLRTITULO,NBASEPRT,NCOMPRT")
SetPrvt("NAC1,NAC2,NAC3,NAC4,NAC5,NAC6")
SetPrvt("NAG1,NAG2,NAG3,NAG4,NAG5,NAG6")
SetPrvt("CCONDICAO,CCHAVE,CNOMARQ,LFIRSTV,CVEND,DVENCTO")
SetPrvt("DBAIXA,CEXT,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT14R  ³ Autor ³                       ³ Data ³27/07/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Comissoes dos Vendedores                      ³±±
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
* mv_par01                Lista Pela        ?                               *
* mv_par02                Da Data           ?                               *
* mv_par03                Ate a Data        ?                               *
* mv_par04                Do Vendedor       ?                               *
* mv_par05                Ate o Vendedor    ?                               *
* mv_par06                Considera Quais   ?                               *
* mv_par07                Comissoes Zeradas ?                               *
* mv_par08                Aliq IRRF Empresa ?                               *
* mv_par08                Base Isencao IRRF ?                               *
* mv_par09                Base 15,0 %  IRRF ?                              *
* mv_par10                Base 27,5 %  IRRF ?                               *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho    := "G"
nLimite     := 220
cTitulo     := "Relatorio de Comissoes"
cDesc1      := "Este Programa Emitira o Relatorio de Comissoes"
cDesc2      := ""
cDesc3      := ""
cbCont      := 0
cbTxt       := ""
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "KFAT14R" 
cPerg       := "FAT14R    "
lContinua   := .t.
li          := 60
wnrel       := "KFAT14R"
cString     := "SE3"
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

wnrel := "KFAT14R"
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

nVlrTitulo  :=  0
nBasePrt    :=  0
nComPrt     :=  0
nAc1        :=  0
nAc2        :=  0
nAc3        :=  0
nAc4        :=  0
nAc5        :=  0
nAc6        :=  0
nAg1        :=  0
nAg2        :=  0
nAg3        :=  0
nAg4        :=  0
nAg5        :=  0
nAg6        :=  0

//----> IMPRIME PELA EMISSAO
If mv_par01 == 1
    cTitulo := cTitulo+" - PAGAMENTO PELA EMISSAO"

//----> IMPRIME PELA BAIXA
ElseIf mv_par01 == 2
    cTitulo := cTitulo+" - PAGAMENTO PELA BAIXA"

Else
    cTitulo := cTitulo
EndIf

DbSelectArea("SE3")

cCondicao :=             "SE3->E3_FILIAL == '00' .And. "
cCondicao := cCondicao + "SE3->E3_VEND >= '"+MV_PAR04+"' .And. "
cCondicao := cCondicao + "SE3->E3_VEND <= '"+MV_PAR05+"' .And. "
cCondicao := cCondicao + "Dtos(SE3->E3_EMISSAO) >= '"+Dtos(MV_PAR02)+"' .And. "
cCondicao := cCondicao + "Dtos(SE3->E3_EMISSAO) <= '"+Dtos(MV_PAR03)+"'"

//----> PELA EMISSAO
If mv_par01 == 1
    cCondicao := cCondicao + " .And. SE3->E3_BAIEMI != 'B'"

//----> PELA BAIXA
ElseIf mv_par01 == 2
    cCondicao := cCondicao + " .And. SE3->E3_BAIEMI == 'B'"
EndIf

//----> COMISSOES A PAGAR
If mv_par06 == 1
    cCondicao := cCondicao + " .And. Dtos(SE3->E3_DATA) == '"+Dtos(Ctod(""))+"'"

//----> COMISSOES PAGAS
ElseIf mv_par06 == 2
    cCondicao := cCondicao + " .And. Dtos(SE3->E3_DATA) != '"+Dtos(Ctod(""))+"'"
EndIf

//----> NAO INCLUI COMISSOES ZERADAS
If mv_par07 == 2
    cCondicao := cCondicao + " .And. SE3->E3_COMIS <> 0"
EndIf

cChave  :=  "SE3->E3_FILIAL+SE3->E3_VEND+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_SEQ"
cNomArq :=  CriaTrab(Nil,.f.)
IndRegua("SE3",cNomArq,cChave,,cCondicao,"Selecionando Registros...")

SetRegua(RecCount())
DbGoTop()


@ 000, 000           PSAY Chr(15)

While Eof() == .f.

    If lEnd
        @ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
        lContinua   :=  .f.
        Exit
    EndIf

    IncRegua()

    lFirstV :=  .t.
    cVend   :=  SE3->E3_VEND

    While Eof() == .f. .And. SE3->E3_VEND == cVend

        IncRegua()

        If Li > 55
            Cabec(cTitulo,cabec1,cabec2,nomeprog,nTamanho,nTipo)
        EndIf

        If lFirstV
            DbSelectArea("SA3")
            DbSetOrder(1)
            DbSeek(xFilial("SA3")+SE3->E3_VEND)

            @ li, 000           PSAY "Vendedor : "+SE3->E3_VEND
            @ li, Pcol() + 001  PSAY Iif(SUBS(SA3->A3_NOME,1,3) $"NAO",SA3->A3_NREDUZ,SA3->A3_NOME)

            li := li + 2

            DbSelectArea("SE3")
            lFirstV := .f.
        EndIf

        @ li, 000           PSAY SE3->E3_PREFIXO
        @ li, Pcol() + 001  PSAY SE3->E3_NUM
        @ li, Pcol() + 001  PSAY SE3->E3_PARCELA
        @ li, Pcol() + 002  PSAY SE3->E3_CODCLI 
        @ li, Pcol() + 002  PSAY SE3->E3_LOJA   

        DbSelectArea("SA1")
        DbSetOrder(1)
        DbSeek(xFilial("SA1")+SE3->E3_CODCLI+SE3->E3_LOJA)

        @ li, Pcol() + 001  PSAY Subs(SA1->A1_NOME,1,35)

        DbSelectArea("SE3")

        @ li, Pcol() + 001  PSAY Dtoc(SE3->E3_EMISSAO)  

        DbSelectArea("SE1")
        DbSetOrder(1)
        DbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)

        nVlrTitulo  :=  Round(SE1->E1_VALOR,2)
        dVencto     :=  SE1->E1_VENCTO
        dBaixa      :=  SE1->E1_BAIXA

        If Eof()
            DbSelectArea("SF2")
            DbSetOrder(1)
            DbSeek(xFilial("SF2")+SE3->E3_NUM+SE3->E3_PREFIXO)

            nVlrTitulo  :=  Round(SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_FRETE+SF2->F2_SEGURO,2)
            dVencto     :=  Ctod("  /  /  ")
            dBaixa      :=  Ctod("  /  /  ")

            If Eof()
                nVlrTitulo  :=  0

                DbSelectArea("SE1")
                DbSetOrder(1)
                DbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM)

                While Eof() == .f. .And. SE1->E1_PREFIXO == SE3->E3_PREFIXO .And.;
                                         SE1->E1_NUM == SE3->E3_NUM .And.;
                                         SE1->E1_FILIAL == SE3->E3_FILIAL

                    If (SE1->E1_TIPO == SE3->E3_TIPO .And. SE1->E1_CLIENTE == SE3->E3_CODCLI .and. SE1->E1_LOJA == SE3->E3_LOJA)

                        nVlrTitulo  := Round(SE1->E1_VALOR,2)
                        dVencto     :=  Ctod("  /  /  ")
                        dBaixa      :=  Ctod("  /  /  ")
                    EndIf

                    DbSelectArea("SE1")
                    DbSkip()
                EndDo
            EndIf
        EndIf

        nBasePrt    :=  Round(SE3->E3_BASE,2)
        nComPrt     :=  Round(SE3->E3_COMIS,2)

        @ li, Pcol() + 003  PSAY Dtoc(dVencto)
        @ li, Pcol() + 003  PSAY Dtoc(dBaixa)

        DbSelectArea("SC5")
        DbSetOrder(1)
        DbSeek(xFilial("SC5")+SE3->E3_PEDIDO)

        @ li, Pcol() + 003  PSAY SC5->C5_PEDCLI

        DbSelectArea("SE3")

        @ li, Pcol() + 004  PSAY SE3->E3_PEDIDO
        @ li, Pcol() + 001  PSAY nBasePrt      Picture tm(nVlrTitulo,14,2)
        @ li, Pcol() + 006  PSAY SE3->E3_PORC  Picture tm(SE3->E3_PORC,6)
        @ li, Pcol() + 001  PSAY nComPrt       Picture tm(nComPrt,14,2)
        @ li, Pcol() + 005  PSAY SE3->E3_BAIEMI

        nAc1    :=  nAc1 + nBasePrt
        nAc2    :=  nAc2 + nComPrt
        nAc3    :=  nAc3 + nVlrTitulo

        If !SE3->E3_PREFIXO $"1  12 "
            nAc5    :=  nAc5 + nComPrt
        EndIf

        li := li + 1

        DbSkip()
    EndDo

    If (nAc1+nAc2+nAc3) != 0
        li := li +1

        If li > 55
            Cabec(cTitulo,cabec1,cabec2,nomeprog,nTamanho,nTipo)
        EndIf

        @ li, 000           PSAY "TOTAL BRUTO VEND   --> "
        @ li, Pcol() + 087  PSAY nAc1   Picture tm(nAc1,15,2)                   

        If nAc1 != 0
            @ li, Pcol() + 006  PSAY (nAc2/nAc1)*100   Picture "999.99"
        EndIf

        @ li, Pcol() + 000  PSAY nAc2   Picture tm(nAc2,15,2)

        li := li + 1

        //----> CALCULA IRRF ? (SIM/NAO)
        If mv_par08 == 1
            If SA3->A3_TIPO == "E"
                If mv_par09 > 0

                    If (nAc5 * mv_par09 / 100) < 10.00
                        @ li, 000           PSAY "TOTAL IRRF 00,00 % --> "
                        @ li, Pcol() + 115  PSAY  (nAc5 * 0.00 / 100)  Picture tm((nAc5 * mv_par09 / 100) ,14,2)
                        nAc4    :=  nAc2 - (nAc5 * 0.00 / 100)
                        nAc6    := (nAc5 * 0.00 / 100)
                    Else
                        @ li, 000           PSAY "TOTAL IRRF 01,50 % --> "
                        @ li, Pcol() + 115  PSAY (nAc5 * mv_par09 / 100)  Picture tm((nAc5 * mv_par09 / 100) ,14,2)
                        nAc4    :=  nAc2 - (nAc5 * mv_par09 / 100)
                        nAc6    := (nAc5 * mv_par09 / 100)
                    EndIf

                    li := li + 1
                EndIf
            ElseIf nAc5 >= mv_par10 .And. nAc5 < mv_par11
                @ li, 000           PSAY "TOTAL IRRF 00,00 % --> "
                @ li, Pcol() + 115  PSAY (nAc5 * 0.00 / 100)  Picture tm((nAc5 * mv_par09 / 100) ,14,2)

                nAc4    :=  nAc2 - (nAc5 * 0.00 / 100)
                nAc6    := (nAc5 * 0.00 / 100)
                li := li + 1
            ElseIf nAc5 >= mv_par11 .And. nAc5 < mv_par12
                @ li, 000           PSAY "TOTAL IRRF 15,00 % --> "
                @ li, Pcol() + 115  PSAY ((nAc5 * 15.00 / 100) - 174.60)  Picture tm((nAc5 * mv_par09 / 100) ,14,2)

                nAc4    :=  nAc2 - ((nAc5 * 15.00 / 100) - 174.60)
                nAc6    :=  ((nAc5 * 15.00 / 100) - 174.60)
                li := li + 1
            ElseIf nAc5 >= mv_par12
                @ li, 000           PSAY "TOTAL IRRF 27,50 % --> "

                @ li, Pcol() + 115  PSAY ((nAc5 * 27.50 / 100) - 465.35)  Picture tm((nAc5 * mv_par09 / 100) ,14,2)

                nAc4    :=  nAc2 - ((nAc5 * 27.50 / 100) - 465.35)
                nAc6    :=  ((nAc5 * 27.50 / 100) - 465.35)
                li := li + 1
            EndIf
        Else
            nAc4    :=  nAc2 
            nAc6    :=  0
            nAc5    :=  0
        EndIf

        @ li, 000   PSAY Replicate("-",nLimite)

        li := li + 1

        @ li, 000           PSAY "TOTAL LIQUIDO VEND --> "
        @ li, Pcol() + 114  PSAY nAc4     Picture tm(nAc4,15,2)

        li := 60
    EndIf

    DbSelectArea("SE3")

    nAg1 := nAg1 + nAc1
    nAg2 := nAg2 + nAc2
    nAg3 := nAg3 + nAc3
    nAg5 := nAg5 + nAc5
    nAg4 := nAg4 + nAc4
    nAg6 := nAg6 + nAc6

    nAc1 := 0
    nAc2 := 0
    nAc3 := 0
    nAc4 := 0
    nAc5 := 0
    nAc6 := 0
EndDo

If (nAg1+nAg2+nAg3) != 0
    Cabec(cTitulo,cabec1,cabec2,nomeprog,nTamanho,nTipo)
    @ li, 000           PSAY "TOTAL BRUTO GERAL  --> "
    @ li, Pcol() + 087  PSAY nAg1   Picture tm(nAg1,15,2)
    @ li, Pcol() + 006  PSAY (nAg2/nAg1)*100   Picture "999.99"
    @ li, Pcol() + 000  PSAY nAg2   Picture tm(nAc2,15,2)

    If mv_par09 > 0
        li := li + 1
        @ li, 000           PSAY "TOTAL IRRF GERAL   --> "
        @ li, Pcol() + 115  PSAY nAg6       Picture tm(nAg4,14,2)
    EndIf

    li := li + 1

    @ li, 000   PSAY Replicate("-",nLimite)

    li := li + 1

    @ li, 000           PSAY "TOTAL LIQUIDO GERAL--> "
    @ li, Pcol() + 114  PSAY nAg4     Picture tm(nAc4,15,2)

    Roda(cbCont,cbTxt,nTamanho)

EndIf

DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)

Set Filter To

cExt    :=  OrdBagExt()
fErase(cNomArq+cExt)

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   DbCommitAll()
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

Aadd(aRegs,{cPerg,"01","Lista Pela              ?","mv_ch1","N",01,0,3,"C","","mv_par01","Emissao","","","Baixa","","","Ambas","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Da Data                 ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Ate a Data              ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Do Vendedor             ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Ate o Vendedor          ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Considera Quais         ?","mv_ch6","N",01,0,3,"C","","mv_par06","A Pagar","","","Pagas","","","Ambas","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Comissoes Zeradas       ?","mv_ch7","N",01,0,2,"C","","mv_par07","","Sim","","","Nao","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Calcula IRRF            ?","mv_ch8","N",01,0,2,"C","","mv_par08","","Sim","","","Nao","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Aliq Empresa IRRF       ?","mv_ch9","N",04,2,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Base Isencao IRRF       ?","mv_cha","N",04,2,0,"G","","mv_par10","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Base 15,0 %  IRRF       ?","mv_chb","N",04,2,0,"G","","mv_par11","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"12","Base 27,5 %  IRRF       ?","mv_chc","N",04,2,0,"G","","mv_par12","","","","","","","","","","","","","","",""})

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
