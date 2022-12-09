#Include "rwmake.ch"    
//
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: RLCOMIS                              Modulo : SIGAFIN    //
//                                                                          //
//   Autor ......: PAULO R. DE OLIVEIRA                 Data ..: 05/03/03   //
//                                                                          //
//   Descricao ..: Relatorio de Comissoes e Clientes em Atraso              //
//                                                                          //
//   Uso ........: Especifico da Shangri-la                                 //
//                                                                          //
//   Observacao .: Baseado no programa MATR540 (padrao do Microsiga)        //
//                                                                          //
//   Atualizacao : 14/10/03 - PAULO ROBERTO DE OLIVEIRA                     //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//

///////////////////////
User Function Rlcomis()
///////////////////////
//
SetPrvt("CNOMARQ,CARQCLI,CINDCLI1,ACAMPOS,")
//
wnRel     := "RLCOMIS"
Titulo    := "Relatorio de Comissoes"
cDesc1    := "Emissao do Relatorio de Comissoes e de Clientes em Atraso."
Tamanho   := "G"
Limite    := 220
cString   := "SE3"
cExt      := ""
cAliasAnt := Alias()
cOrdemAnt := IndexOrd()
nRegAnt   := Recno()
aReturn   := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Nomeprog  := "RLCOMIS"
aLinha    := {}
nLastKey  := 0
cPerg     := PADR("MTR540",LEN(SX1->X1_GRUPO))
//
Pergunte(cPerg, .F.)
//
wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, "", "",;
         .F., "", .F., Tamanho)
//
If nLastKey == 27
   Set Filter to
   Return (.T.)
Endif
//
SetDefault(aReturn, cString)
//
If nLastKey == 27
   Set Filter to
   Return (.T.)
Endif
//
RptStatus({|lEnd| RelComis()}, Titulo)
//
DbSelectArea(cAliasAnt)
DbSetOrder(cOrdemAnt)
DbGoTo(nRegAnt)
//
Return (.T.)

//////////////////////////
Static Function RelComis()
//////////////////////////
//
aCampos := {{"CODVEN", "C", 06, 0},;        // Codigo do Vendedor
            {"NOMVEN", "C", 30, 0},;        // Nome do Vendedor
            {"CODCLI", "C", 06, 0},;        // Codigo do Cliente
            {"CODLOJ", "C", 02, 0},;        // Loja do Cliente
            {"NOMCLI", "C", 50, 0},;        // Nome do Cliente
            {"TELCLI", "C", 30, 0},;        // Telefone do Cliente
            {"DATVEN", "D", 08, 0},;        // Data de Vencimento
            {"DATEMI", "D", 08, 0},;        // Data de Emissao
            {"CODBAN", "C", 03, 0},;        // Codigo do Banco
            {"PREFIX", "C", 03, 0},;        // Prefixo do Titulo
            {"NUMERO", "C", 06, 0},;        // Numero do Titulo
            {"PARCEL", "C", 01, 0},;        // Parcela do Titulo
            {"TIPDOC", "C", 03, 0},;        // Tipo do Documento
            {"VALTIT", "N", 15, 2},;        // Valor do Titulo
            {"ATRASO", "N", 06, 0}}         // Atraso em Dias
//
cArqCli := CriaTrab(aCampos, .T.)           // Arquivo de Clientes em Atraso
//
DbUseArea(.T.,, cArqCli, "TRB", .F., .F.)
//
cIndCli1 := CriaTrab(Nil, .F.)
IndRegua("TRB", cIndCli1, "CODVEN+CODCLI+CODLOJ+PREFIX+NUMERO+PARCEL+TIPDOC",,, "Selecionando Registros...")
//
DbSelectArea("TRB")
DbSetIndex(cIndCli1 + OrdBagExt())
//
Imprime   := .T.
nCol      := j := nBasePrt := nComPrt := 0
nAc1      := nAc2 := nAg1 := nAg2 := nAc3 := nAg3 := 0
lFirstV   := .T.
lContinua := .T.
cNFiscal  := ""
aCampos   := {}
lImpDev   := .F.
cBase     := ""
nDecs     := GetMv("MV_CENT" + (IIf(Mv_Par08 > 1 , Str(Mv_Par08, 1), "")))
cbtxt     := Space(10)
cbcont    := 0
Li        := 80
m_Pag     := 1
nTipo     := IIf(aReturn[4] == 1, 15, 18)
//
If Mv_Par01 == 1
   Titulo := "Relatorio de Comissoes (Pgto pela Emissao)" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Elseif Mv_Par01 == 2
   Titulo := "Relatorio de Comissoes (Pgto pela Baixa)" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Else
   Titulo := "Relatorio de Comissoes" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Endif
//
Cabec1 := "Prf Numero   Parc. Codigo                 Lj  Nome                                 Dt.Base     Data        Data        Data       Numero          Valor           Valor      %          Valor      Tipo  "
Cabec2 := "    Titulo         Cliente                                                         Comissao    Vencto      Baixa       Pagto      Pedido         Titulo            Base               Comissao   Comissao"
//
cTit   := "*** Clientes em Atraso ***"
cCab   := "Dt.Emissao  Dt.Vencto.   Banco   Nro Dupl.  Parc.  Pref.       Valor 1#         Valor 2#         Valor 3#     Atraso em Dias"
//         99/99/99     99/99/99     999     999999      9     XXX    999.999.999,99   999.999.999,99   999.999.999,99        9999
//
SA1->(DbSetOrder(1))              // Clientes
SA3->(DbSetOrder(1))              // Vendedores
SE1->(DbSetOrder(1))              // Contas a Receber
SE3->(DbSetOrder(2))              // Comissoes
//
DbSelectArea("SE3")
//
cFilialSE3 := xFilial("SE3")
cCondicao  := "SE3->E3_FILIAL == '" + cFilialSE3 + "'"
cCondicao  += " .And. SE3->E3_VEND >= '" + Mv_Par04 + "'"
cCondicao  += " .And. SE3->E3_VEND <= '" + Mv_Par05 + "'"
cCondicao  += " .And. Dtos(SE3->E3_EMISSAO) >= '" + Dtos(Mv_Par02) + "'"
cCondicao  += " .And. Dtos(SE3->E3_EMISSAO) <= '" + Dtos(Mv_Par03) + "'"
//
If Mv_Par01 == 1
   cCondicao += " .And. SE3->E3_BAIEMI != 'B'"   // Baseado pela Emissao da NF
Elseif Mv_Par01 == 2
   cCondicao += " .And. SE3->E3_BAIEMI == 'B'"   // Baseado pela Baixa do Titulo
Endif
//
If Mv_Par06 == 1
   cCondicao += " .And. Dtos(SE3->E3_DATA) == '" + Dtos(Ctod("")) + "'"   // A Pagar
ElseIf Mv_Par06 == 2
   cCondicao += " .And. Dtos(SE3->E3_DATA) != '" + Dtos(Ctod("")) + "'"   // Pagas
Endif
//
If Mv_Par09 == 2
   cCondicao += " .And. SE3->E3_COMIS <> 0"      // Nao Inclui Comissoes Zeradas
Endif
//
If (!Empty(aReturn[7]))
   cFiltroUsu := &("{|| " + aReturn[7] + "}")    // Filtro do Usuario
Else
   cFiltroUsu := {|| .T.}
Endif
//
cChave  := IndexKey()
cNomArq := CriaTrab("", .F.)
//
IndRegua("SE3", cNomArq, cChave,, cCondicao, "Selecionando Registros...")
//
nIndex := RetIndex("SE3")
//
DbSelectArea("SE3")
//
#IFNDEF TOP
        DbSetIndex(cNomArq + OrdBagExT())
#ENDIF
//
DbSetOrder(nIndex + 1)
//
nAg1 := nAg2 := 0
//
DbSelectArea("SA3")
SetRegua(RecCount())
SA3->(DbSeek(xFilial("SA3") + Mv_Par04, .T.))
//
While SA3->(!Eof()) .And. SA3->A3_FILIAL == xFilial("SA3") .And. SA3->A3_COD <= Mv_Par05
      //
      If lEnd
         @ Prow()+1, 001 PSAY "*** CANCELADO PELO OPERADOR ***"
         lContinua := .F.
         Exit
      Endif
      //
      IncRegua()
      //
      nAc1    := nAc2 := nAc3 := 0
      lFirstV := .T.
      //
      DbSelectArea("SE3")
      SE3->(DbSeek(xFilial("SE3") + SA3->A3_COD, .F.))
      //
      While SE3->(!Eof()) .And. SE3->E3_FILIAL == xFilial("SE3") .And. SE3->E3_VEND == SA3->A3_COD
            //
            If !Eval(cFiltroUsu)
               SE3->(DbSkip())
               Loop
            Endif
            //
            If Li > 55
               Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
            Endif
            //
            If lFirstV
               //
               @ Li, 000 PSAY "Vendedor : " + SE3->E3_VEND + " " + SA3->A3_NOME
               Li += 2
               //
               DbSelectArea("SE3")
               lFirstV := .F.
               //
            Endif
            //
            @ Li, 000 PSAY SE3->E3_PREFIXO
            @ Li, 004 PSAY SE3->E3_NUM
            @ Li, 017 PSAY SE3->E3_PARCELA
            @ Li, 019 PSAY SE3->E3_CODCLI
            @ Li, 042 PSAY SE3->E3_LOJA
            //
            SA1->(DbSeek(xFilial("SA1") + SE3->E3_CODCLI + SE3->E3_LOJA, .F.))
            //
            @ Li, 046 PSAY Substr(SA1->A1_NOME, 1, 35)
            @ Li, 083 PSAY SE3->E3_EMISSAO
            //
            DbSelectArea("SE1")
            SE1->(DbSetOrder(1))
            SE1->(DbSeek(xFilial("SE1") + SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA + SE3->E3_TIPO, .F.))
            //
            nVlrTitulo := Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            dVencto    := SE1->E1_VENCTO
            dBaixa     := SE1->E1_BAIXA
            //
            If SE1->(Eof())
               //
               DbSelectArea("SF2")
               SF2->(DbSetOrder(1))
               SF2->(DbSeek(xFilial("SF2") + SE3->E3_NUM + SE3->E3_PREFIXO, .F.))
               //
               If (cPaisLoc == "BRA" )
                  nVlrTitulo := Round(xMoeda(F2_VALMERC + F2_VALIPI + F2_FRETE + F2_SEGURO, 1, Mv_Par08, SF2->F2_EMISSAO, nDecs + 1), nDecs)
               Else
                  nVlrTitulo := Round(xMoeda(F2_VALFAT, SF2->F2_MOEDA, Mv_Par08, SF2->F2_EMISSAO, nDecs + 1, SF2->F2_TXMOEDA), nDecs)
               Endif
               //
               dVencto := " "
               dBaixa  := " "
               //
               If SF2->(Eof())
                  //
                  nVlrTitulo := 0
                  //
                  DbSelectArea("SE1")
                  SE1->(DbSetOrder(1))
                  cFilialSE1 := xFilial("SE1")
                  //
                  SE1->(DbSeek(cFilialSE1 + SE3->E3_PREFIXO + SE3->E3_NUM))
                  //
                  While (SE1->(!Eof()) .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
                        SE3->E3_NUM == SE1->E1_NUM .And. SE3->E3_FILIAL == cFilialSE1)
                        //
                        If (SE1->E1_TIPO == SE3->E3_TIPO .And.;
                           SE1->E1_CLIENTE == SE3->E3_CODCLI .And.;
                           SE1->E1_LOJA == SE3->E3_LOJA)
                           //
                           nVlrTitulo += Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
                           dVencto    := " "
                           dBaixa     := " "
                           //
                        Endif
                        //
                        DbSelectArea("SE1")
                        SE1->(DbSkip())
                        //
                  Enddo
                  //
               Endif
               //
            Endif
            //
            nBasePrt := Round(xMoeda(SE3->E3_BASE, 1, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            nComPrt  := Round(xMoeda(SE3->E3_COMIS, 1, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            //
            @ Li, 095 PSAY dVencto
            @ Li, 107 PSAY dBaixa
            //
            DbSelectArea("SE3")
            //
            @ Li, 119 PSAY SE3->E3_DATA
            @ Li, 130 PSAY SE3->E3_PEDIDO   Picture "@!"
            @ Li, 137 PSAY nVlrTitulo       Picture Tm(nVlrTitulo, 14, nDecs)
            @ Li, 153 PSAY nBasePrt         Picture Tm(nBasePrt, 14, nDecs)
            @ Li, 169 PSAY SE3->E3_PORC     Picture Tm(SE3->E3_PORC, 6)
            @ Li, 176 PSAY nComPrt          Picture Tm(nComPrt, 14, nDecs)
            @ Li, 195 PSAY SE3->E3_BAIEMI
            Li++
            //
            nAc1 += nBasePrt
            nAc2 += nComPrt
            nAc3 += nVlrTitulo
            //
            SE3->(DbSkip())
            //
      Enddo
      //
      DbSelectArea("SE1")
      SE1->(DbSetOrder(22)) // 17 | 21
      SE1->(DbSeek(xFilial("SE1") + SA3->A3_COD, .F.))
      //
      While SE1->(!Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_VEND1 == SA3->A3_COD
            //
            nVlrTitulo := Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            dVencto    := SE1->E1_VENCTO
            dBaixa     := SE1->E1_BAIXA
            //
            SA1->(DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, .F.))
            //
            nDias := dDataBase - SE1->E1_VENCREA    // Verificar Atraso
            //
            
            //----> 28/06/2012 - ALTERADO POR RICARDO CORREA DE SOUZA (MVG CONSULTORIA)
            If nDias > 365
            	dbSelectArea("SE1")
            	dbSkip()
            	Loop
            EndIf
            //----> 28/06/2012 - ALTERADO POR RICARDO CORREA DE SOUZA (MVG CONSULTORIA)
            
            If nDias > 0 .And. SE1->E1_SALDO > 0
               //
               DbSelectArea("TRB")
               DbSeek(SA3->A3_COD + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO +;
                     SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO)
               //
               If Found()         // Gravar o Titulo Se Estiver Em Atraso
                  RecLock("TRB", .F.)
               Else
                  RecLock("TRB", .T.)
               Endif
               //
               TRB->CODVEN := SA3->A3_COD
               TRB->NOMVEN := SA3->A3_NOME
               TRB->CODCLI := SE1->E1_CLIENTE
               TRB->CODLOJ := SE1->E1_LOJA
               TRB->NOMCLI := SA1->A1_NOME
               TRB->TELCLI := SA1->A1_TEL
               TRB->DATVEN := SE1->E1_VENCREA
               TRB->DATEMI := SE1->E1_EMISSAO
               TRB->CODBAN := SE1->E1_PORTADO
               TRB->PREFIX := SE1->E1_PREFIXO
               TRB->NUMERO := SE1->E1_NUM
               TRB->PARCEL := SE1->E1_PARCELA
               TRB->TIPDOC := SE1->E1_TIPO
               TRB->VALTIT := SE1->E1_SALDO
               TRB->ATRASO := nDias
               //
               MsUnlock()
               //
            Endif
            //
            DbSelectArea("SE1")
            SE1->(DbSkip())
            //
      Enddo
      //
      If (nAc1 + nAc2 + nAc3) # 0
         //
         Li++
         //
         If Li > 55
            Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
         Endif
         //
         @ Li, 083 PSAY "Total do Vendedor --------> "
         @ Li, 136 PSAY nAc3  PicTure Tm(nAc3, 15, nDecs)
         @ Li, 152 PSAY nAc1  PicTure Tm(nAc1, 15, nDecs)
         //
         If nAc1 # 0
            @ Li, 169 PSAY (nAc2 / nAc1) * 100  PicTure "999.99"
         Endif
         //
         @ Li, 176 PSAY nAc2  PicTure Tm(nAc2, 14, nDecs)
         Li++
         //
         If Mv_Par10 > 0 .And. (nAc2 * Mv_Par10 / 100) > GetMV("MV_VLRETIR")
            //
            @ Li, 083 PSAY "Total do IR --------------> "
            @ Li, 176 PSAY (nAc2 * Mv_Par10 / 100) PicTure Tm(nAc2 * Mv_Par10 / 100, 14, nDecs)
            Li++
            //
         Endif
         //
         @ Li, 000 PSAY Replicate("-", Limite)
         //
      Endif
      //
      RelAtraso()                 // Relatorio de Titulos Atrasos do Vendedor
      //
      Li := 60
      //
      DbSelectArea("SE3")
      //
      nAg1 += nAc1
      nAg2 += nAc2
      nAg3 += nAc3
      //
      DbSelectArea("SA3")
      SA3->(DbSkip())
      //
Enddo
//
If (nAg1 + nAg2 + nAg3) # 0
   //
   Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
   //
   @ Li, 083 PSAY "Total Geral --------------> "
   @ Li, 136 PSAY nAg3                 Picture Tm(nAg3, 15, nDecs)
   @ Li, 152 PSAY nAg1                 Picture Tm(nAg1, 15, nDecs)
   @ Li, 169 PSAY (nAg2 / nAg1) * 100  Picture "@E 999.99"
   @ Li, 176 PSAY nAg2                 Picture Tm(nAg2, 14, nDecs)
   //
   If Mv_Par10 > 0 .And. (nAg2 * Mv_Par10 / 100) > GetMV("MV_VLRETIR")
      //
      Li ++
      @ Li, 083 PSAY "Total do IR --------------> "
      @ Li, 176 PSAY (nAg2 * Mv_Par10 / 100) PicTure Tm((nAg2 * Mv_Par10 / 100), 15, nDecs)
      //
   Endif
   //
   Roda(cbcont, cbtxt, "G")
   //
EndIF
//
DbSelectArea("SE3")
RetIndex("SE3")
SE3->(DbSetOrder(2))
Set Filter To
//
SE1->(DbSetOrder(1))
SE3->(DbSetOrder(1))
//
cExt := OrdBagExt()
fErase(cNomArq + cExt)
//
DbSelectArea("TRB")          // Deletar Arquivos Temporarios
DbCloseArea()
Delete File (cArqCli + ".DBF")
Delete File (cIndCli1 + OrdBagExt())
//
If aReturn[5] == 1
   Set Printer To
   DbCommitAll()
   OurSpool(wnRel)
Endif
//
MS_FLUSH()
//
Return (.T.)

///////////////////////////
Static Function RelAtraso()
///////////////////////////
//
DbSelectArea("TRB")      // Verificar Se Ha Titulos em Atraso
DbSeek(SA3->A3_COD)
//
cCliente := TRB->CODCLI + TRB->CODLOJ
lPriVez  := .T.
lPriCli  := .T.
nValCli1 := 0       // Valor Total por Cliente da Serie Branco
nValCli2 := 0       // Valor Total por Cliente da Serie UNI
nValCli3 := 0       // Valor Total por Cliente das Demais Series
nValTot1 := 0       // Valor Total do Vendedor da Serie Branco
nValTot2 := 0       // Valor Total do Vendedor da Serie UNI
nValTot3 := 0       // Valor Total do Vendedor das Demais Series
nTotVen  := 0       // Numero Total de Titulos Atrasados do Vendedor
nTotCli  := 0       // Numero Total de Titulos Atrasados do Cliente
//
While TRB->(!Eof()) .And. TRB->CODVEN == SA3->A3_COD
      //
      If Li > 55
         Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
         lPriVez := .T.
      Endif
      //
      If lPriVez
         //
         Li += 2
         @ Li, 000 PSAY "* * *   Clientes em Atraso do Representante : " +;
           SA3->A3_COD + " " + Alltrim(TRB->NOMVEN) + "   * * *"
         Li += 1
         @ Li, 000 PSAY cCab
         Li += 1
         //
         lPriVez := .F.
         //
      Endif
      //
      If lPriCli
         //
         Li += 1
         @ Li, 000 PSAY Alltrim(TRB->NOMCLI) + " (" + TRB->CODCLI + ")" + Space(10) + "Tel. " + TRB->TELCLI
         Li += 2
         //
         lPriCli:= .F.
         //
      Endif
      //
      @ Li, 000 PSAY Dtoc(TRB->DATEMI)
      @ Li, 013 PSAY Dtoc(TRB->DATVEN)
      @ Li, 026 PSAY TRB->CODBAN
      @ Li, 034 PSAY TRB->NUMERO
      @ Li, 046 PSAY TRB->PARCEL
      @ Li, 052 PSAY TRB->PREFIX
      //
      If TRB->PREFIX == "UNI"
         //
         @ Li, 059 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
         //
         nValCli1 += TRB->VALTIT
         nValTot1 += TRB->VALTIT
         //
      Elseif TRB->PREFIX == "   "
         //
         @ Li, 076 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
         //
         nValCli2 += TRB->VALTIT
         nValTot2 += TRB->VALTIT
         //
      Else
         //
         @ Li, 093 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
         //
         nValCli3 += TRB->VALTIT
         nValTot3 += TRB->VALTIT
         //
      Endif
      //
      @ Li, 115 PSAY Transform(TRB->ATRASO, "@E 9999")
      //
      nTotCli += 1
      nTotVen += 1
      Li += 1
      //
      TRB->(DbSkip())
      //
      If TRB->CODVEN # SA3->A3_COD .Or. TRB->(Eof()) .Or.;
         (TRB->CODCLI + TRB->CODLOJ) # cCliente
         //
         Li += 1
         @ Li, 000 PSAY "Total do Cliente ----------> "
         @ Li, 059 PSAY Transform(nValCli1, "@E 999,999,999.99")
         @ Li, 076 PSAY Transform(nValCli2, "@E 999,999,999.99")
         @ Li, 093 PSAY Transform(nValCli3, "@E 999,999,999.99")
         @ Li, 113 PSAY Transform(nTotCli, "@E 999999") + " Titulo(s) Atrasado(s)"
         Li += 2
         //
         cCliente := TRB->CODCLI + TRB->CODLOJ
         lPriCli  := .T.
         nValCli1 := 0
         nValCli2 := 0
         nValCli3 := 0
         nTotCli  := 0
         //
      Endif
      //
Enddo
//
If nValTot1 # 0 .Or. nValTot2 # 0 .Or. nValTot3 # 0
   //
   Li += 1
   @ Li, 000 PSAY "Total do Vendedor ---------> "
   @ Li, 059 PSAY Transform(nValTot1, "@E 999,999,999.99")
   @ Li, 076 PSAY Transform(nValTot2, "@E 999,999,999.99")
   @ Li, 093 PSAY Transform(nValTot3, "@E 999,999,999.99")
   @ Li, 113 PSAY Transform(nTotVen, "@E 999999") + " Titulo(s) Atrasado(s)"
   Li += 1
   //
Endif
//
Return (.T.)