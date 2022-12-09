#Include "rwmake.ch"
//
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: SHCOMIS                              Modulo : SIGAFIN    //
//                                                                          //
//   Autor ......: PAULO R. DE OLIVEIRA                 Data ..: 07/05/02   //
//                                                                          //
//   Descricao ..: Relatorio de Comissoes e Clientes em Atraso              //
//                                                                          //
//   Uso ........: Especifico da Shangri-la                                 //
//                                                                          //
//   Observacao .: Baseado no programa MATR540 (padrao do Microsiga)        //
//                                                                          //
//   Atualizacao : 07/05/02 - PAULO ROBERTO DE OLIVEIRA                     //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//

///////////////////////
User Function Shcomis()
///////////////////////
//
SetPrvt("CNOMARQ,CARQCLI,CINDCLI1,ACAMPOS,")
//
wnRel     := "SHCOMIS"
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
Nomeprog  := "SHCOMIS"
aLinha    := {}
nLastKey  := 0
cPerg     := PADR("MTR540",LEN(SX1->X1_GRUPO))

Pergunte(cPerg, .F.)

wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, "", "",;
         .F., "", .F., Tamanho)

If nLastKey == 27
   Set Filter to
   Return (.T.)
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
   Set Filter to
   Return (.T.)
Endif

RptStatus({|lEnd| RlComis()}, Titulo)

DbSelectArea(cAliasAnt)
DbSetOrder(cOrdemAnt)
DbGoTo(nRegAnt)

Return (.T.)

/////////////////////////
Static Function RlComis()
/////////////////////////
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

If Mv_Par01 == 1
   Titulo := "Relatorio de Comissoes (Pgto pela Emissao)" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Elseif Mv_Par01 == 2
   Titulo := "Relatorio de Comissoes (Pgto pela Baixa)" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Else
   Titulo := "Relatorio de Comissoes" + " - " + GetMv("MV_MOEDA" + Str(Mv_Par08, 1))
Endif

Cabec1 := "Prf Numero   Parc. Codigo                 Lj  Nome                                 Dt.Base     Data        Data        Data       Numero               Valor           Valor      %          Valor Tipo  "
Cabec2 := "    Titulo         Cliente                                                         Comissao    Vencto      Baixa       Pagto      Pedido              Titulo            Base              Comissao       "

cTit   := "*** Clientes em Atraso ***"
cCab   := "Dt.Vencto   Dt.Emissao   Banco   Nro Dupl.  Parc.  Pref.       Valor 1#         Valor 2#         Valor 3#     Atraso em Dias"
//         99/99/99     99/99/99     999     999999      9     XXX    999.999.999,99   999.999.999,99   999.999.999,99        9999
cVend  := ""

DbSelectArea("SE3")
DbSetOrder(2)

cFilialSE3 := xFilial("SE3")
cCondicao  := "SE3->E3_FILIAL == '" + cFilialSE3 + "'"
cCondicao  += " .And. SE3->E3_VEND >= '" + Mv_Par04 + "'"
cCondicao  += " .And. SE3->E3_VEND <= '" + Mv_Par05 + "'"
cCondicao  += " .And. Dtos(SE3->E3_EMISSAO) >= '" + Dtos(Mv_Par02) + "'"
cCondicao  += " .And. Dtos(SE3->E3_EMISSAO) <= '" + Dtos(Mv_Par03) + "'"

If Mv_Par01 == 1
   cCondicao += " .And. SE3->E3_BAIEMI != 'B'"   // Baseado pela Emissao da NF
Elseif Mv_Par01 == 2
   cCondicao += " .And. SE3->E3_BAIEMI == 'B'"   // Baseado pela Baixa do Titulo
Endif

If Mv_Par06 == 1
   cCondicao += " .And. Dtos(SE3->E3_DATA) == '" + Dtos(Ctod("")) + "'"   // A Pagar
ElseIf Mv_Par06 == 2
   cCondicao += " .And. Dtos(SE3->E3_DATA) != '" + Dtos(Ctod("")) + "'"   // Pagas
Endif

If Mv_Par09 == 2
   cCondicao += " .And. SE3->E3_COMIS <> 0"      // Nao Inclui Comissoes Zeradas
Endif

If (!Empty(aReturn[7]))
   cFiltroUsu := &("{|| " + aReturn[7] + "}")    // Filtro do Usuario
Else
   cFiltroUsu := {|| .T.}
Endif

cChave  := IndexKey()
cNomArq := CriaTrab("", .F.)

IndRegua("SE3", cNomArq, cChave,, cCondicao, "Selecionando Registros...")

nIndex := RetIndex("SE3")

DbSelectArea("SE3")

#IFNDEF TOP
        DbSetIndex(cNomArq + OrdBagExT())
#ENDIF

DbSetOrder(nIndex + 1)

nAg1 := nAg2 := 0

DbSelectArea("SE3")
SetRegua(RecCount())
DbGoTop()

While SE3->(!Eof())
      
      If lEnd
         @ Prow()+1, 001 PSAY "*** CANCELADO PELO OPERADOR ***"
         lContinua := .F.
         Exit
      Endif
      
      IncRegua()
      
      If !Eval(cFiltroUsu)
         SE3->(DbSkip())
         Loop
      Endif
      
      nAc1    := nAc2 := nAc3 := 0
      lFirstV := .T.
      cVend   := SE3->E3_VEND
      
      While SE3->(!Eof()) .And. SE3->E3_VEND == cVend
            
            IncRegua()
            
            If !Eval(cFiltroUsu)
               SE3->(DbSkip())
               Loop
            Endif
            
            If Li > 55
               Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
            Endif
            
            If lFirstV
               //
               SA3->(DbSeek(xFilial("SA3") + SE3->E3_VEND, .F.))
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
            @ Li, Pcol()+001 PSAY SE3->E3_NUM
            @ Li, Pcol()+004 PSAY SE3->E3_PARCELA
            @ Li, Pcol()+001 PSAY SE3->E3_CODCLI
            @ Li, Pcol()+017 PSAY SE3->E3_LOJA
            //
            SA1->(DbSeek(xFilial("SA1") + SE3->E3_CODCLI + SE3->E3_LOJA, .F.))
            //
            @ Li, Pcol()+002 PSAY Substr(SA1->A1_NOME, 1, 35)
            @ Li, Pcol()+002 PSAY SE3->E3_EMISSAO
            //
            DbSelectArea("SE1")
            DbSetOrder(1)
            SE1->(DbSeek(xFilial("SE1") + SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA + SE3->E3_TIPO, .F.))

            nVlrTitulo := Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            dVencto    := SE1->E1_VENCTO
            dBaixa     := SE1->E1_BAIXA

            //
            /*
            //
            nDias := dDataBase - SE1->E1_VENCREA           // Verificar atraso
            //
            If nDias > 0 .And. SE1->E1_SALDO > 0 .And. SE1->(!Eof())
               //
               DbSelectArea("TRB")
               DbSeek(SE3->E3_VEND + SE3->E3_CODCLI + SE3->E3_LOJA + SE3->E3_PREFIXO +;
                      SE3->E3_PARCELA + SE3->E3_TIPO)
               //
               If Found()                   // Gravar o Titulo Se Estiver Em Atraso 
                  RecLock("TRB", .F.)
               Else
                  RecLock("TRB", .T.)
               Endif
               //
               TRB->CODVEN := SE3->E3_VEND
               TRB->NOMVEN := SA3->A3_NOME
               TRB->CODCLI := SE3->E3_CODCLI
               TRB->CODLOJ := SE3->E3_LOJA
               TRB->NOMCLI := SA1->A1_NOME
               TRB->TELCLI := SA1->A1_TEL
               TRB->DATVEN := SE1->E1_VENCREA
               TRB->DATEMI := SE1->E1_EMISSAO
               TRB->CODBAN := SE1->E1_PORTADO
               TRB->PREFIX := SE3->E3_PREFIXO
               TRB->NUMERO := SE3->E3_NUM
               TRB->PARCEL := SE3->E3_PARCELA
               TRB->TIPDOC := SE3->E3_TIPO
               TRB->VALTIT := SE1->E1_SALDO
               TRB->ATRASO := nDias
               //
               MsUnlock()
               //
            Endif
            //
            */
            If SE1->(Eof())
               //
               DbSelectArea("SF2")
               DbSetOrder(1)
               SF2->(DbSeek(xFilial("SF2") + SE3->E3_NUM + SE3->E3_PREFIXO, .F.))
               //
               If (cPaisLoc == "BRA" )
                  nVlrTitulo := Round(xMoeda(F2_VALMERC + F2_VALIPI + F2_FRETE + F2_SEGURO, 1, Mv_Par08, SF2->F2_EMISSAO, nDecs + 1), nDecs)
               Else
                  nVlrTitulo := Round(xMoeda(F2_VALFAT, SF2->F2_MOEDA, Mv_Par08, SF2->F2_EMISSAO, nDecs + 1, SF2->F2_TXMOEDA), nDecs)
               Endif
               //
               dVencto := Ctod("  /  /  ")
               dBaixa  := Ctod("  /  /  ")
               //
               If SF2->(Eof())
                  //
                  nVlrTitulo := 0
                  //
                  DbSelectArea("SE1")
                  DbSetOrder(1)
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
                           dVencto    := Ctod("  /  /  ")
                           dBaixa     := Ctod("  /  /  ")
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
            @ Li, Pcol()+003 PSAY dVencto
            @ Li, Pcol()+003 PSAY dBaixa
            //
            DbSelectArea("SE3")
            //
            @ Li, Pcol()+003 PSAY SE3->E3_DATA
            xPedCli := Space(10)
            DbSelectArea("SC6")
            DbSetOrder(1)
            DbSeek(xFilial("SC6")+SE3->E3_PEDIDO)
          	xPedCli := SC6->C6_PEDCLI
             //
			DbSelectArea("SE3")
            If !Empty(xPedCli)                          
	            @ Li, Pcol()+006 PSAY xPedCli
			Else
	            @ Li, Pcol()+006 PSAY SE3->E3_PEDIDO+"    "   Picture "@!"
            EndIf	  
            
            @ Li, Pcol()+001 PSAY nVlrTitulo       Picture Tm(nVlrTitulo, 15, nDecs)
            @ Li, Pcol()+001 PSAY nBasePrt         Picture Tm(nBasePrt, 15, nDecs)
            @ Li, Pcol()+001 PSAY SE3->E3_PORC     Picture Tm(SE3->E3_PORC, 6)
            @ Li, Pcol()+001 PSAY nComPrt          Picture Tm(nComPrt, 14, nDecs)
            @ Li, Pcol()+001 PSAY SE3->E3_BAIEMI
            Li++
            //
            nAc1 += nBasePrt
            nAc2 += nComPrt
            nAc3 += nVlrTitulo
            //
            SE3->(DbSkip())
            //
      Enddo   
      
      DbSelectArea("SE1")
      DbSetOrder(21)
      SE1->(DbSeek(xFilial("SE1") + cVend, .F.))
//      SE1->(DbSeek(xFilial("SE1") + SE3->E3_PREFIXO + SE3->E3_NUM + SE3->E3_PARCELA + SE3->E3_TIPO, .F.))
      Do While !SE1->(Eof()) .And. SE1->E1_VEND1 == cVend
            //
            nVlrTitulo := Round(xMoeda(SE1->E1_VALOR, SE1->E1_MOEDA, Mv_Par08, SE1->E1_EMISSAO, nDecs + 1), nDecs)
            dVencto    := SE1->E1_VENCTO
            dBaixa     := SE1->E1_BAIXA
            //
            SA1->(DbSeek(xFilial("SA1") + SE1->E1_CLIENTE+ SE1->E1_LOJA, .F.))

            nDias := dDataBase - SE1->E1_VENCREA           // Verificar atraso
            //
            If nDias > 0 .And. SE1->E1_SALDO > 0 .And. SE1->(!Eof())
               //
//             Indice do TRB = CODVEN+CODCLI+CODLOJ+PREFIX+NUMERO+PARCEL+TIPDOC
               DbSelectArea("TRB")
               DbSeek(SE3->E3_VEND + SE1->E1_CLIENTE+ SE1->E1_LOJA + SE1->E1_PREFIXO +;
                      SE1->E1_PARCELA + SE1->E1_NUM + SE1->E1_TIPO)
               //
               If Found()                   // Gravar o Titulo Se Estiver Em Atraso 
                  RecLock("TRB", .F.)
               Else
                  RecLock("TRB", .T.)
               Endif
               //
               TRB->CODVEN := cVend
               TRB->NOMVEN := SA3->A3_NOME
               TRB->CODCLI := SE1->E1_CLIENTE
               TRB->CODLOJ := SE1->E1_LOJA
               TRB->NOMCLI := SA1->A1_NOME
               TRB->TELCLI := IIF(!Empty(SA1->A1_DDD),Alltrim(SA1->A1_DDD)+" "+SA1->A1_TEL,SA1->A1_TEL)
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
            SE1->(DbSkip())
		EndDo
      //
      If (nAc1 + nAc2 + nAc3) # 0
         //
         Li++
         //
         If Li > 55
            Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
         Endif
         //
         @ Li, 112 PSAY "Total do Vendedor --------> "
         @ Li, Pcol()+001 PSAY nAc3  PicTure Tm(nAc3, 15, nDecs)
         @ Li, Pcol()+001 PSAY nAc1  PicTure Tm(nAc1, 15, nDecs)
         //
         If nAc1 # 0
            @ Li, Pcol()+001 PSAY (nAc2 / nAc1) * 100  PicTure "999.99"
         Endif
         //
         @ Li, Pcol()+001 PSAY nAc2  PicTure Tm(nAc2, 14, nDecs)
         Li++
         //
         If Mv_Par10 > 0 .And. (nAc2 * Mv_Par10 / 100) > GetMV("MV_VLRETIR")
            //
            @ Li, 112 PSAY "Total do IR --------------> "
            @ Li, Pcol()+001 PSAY (nAc2 * Mv_Par10 / 100) PicTure Tm(nAc2 * Mv_Par10 / 100, 14, nDecs)
            Li++
            //
         Endif
         //
         @ Li, 000 PSAY Replicate("-", Limite)
         //
         DbSelectArea("TRB")      // Verificar Se Ha Titulos em Atraso
         DbSeek(cVend)
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
         //Li := 60
         While TRB->(!Eof()) .And. TRB->CODVEN == cVend
               //
               If Li > 55
                  Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
                  lPriVez := .T.
               Endif
               //
               If lPriVez
                  //
                  Li += 1
                  @ Li, 000 PSAY "* * *   Clientes em Atraso do Representante : " +;
                    cVend + " " + Alltrim(TRB->NOMVEN) + "   * * *"
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
                  Li += 1
                  //
                  lPriCli:= .F.
                  //
               Endif
               //
               @ Li, 000 PSAY Dtoc(TRB->DATVEN)
               @ Li, Pcol()+001 PSAY Dtoc(TRB->DATEMI)
               @ Li, Pcol()+001 PSAY TRB->CODBAN
               @ Li, Pcol()+001 PSAY TRB->NUMERO
               @ Li, Pcol()+001 PSAY TRB->PARCEL
               @ Li, Pcol()+001 PSAY TRB->PREFIX
               //
               If TRB->PREFIX == "UNI"
                  //
                  @ Li, Pcol()+001 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
                  //
                  nValCli1 += TRB->VALTIT
                  nValTot1 += TRB->VALTIT
                  //
               Elseif TRB->PREFIX == "   "
                  //
                  @ Li, Pcol()+001 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
                  //
                  nValCli2 += TRB->VALTIT
                  nValTot2 += TRB->VALTIT
                  //
               Else
                  //
                  @ Li, Pcol()+001 PSAY Transform(TRB->VALTIT, "@E 999,999,999.99")
                  //
                  nValCli3 += TRB->VALTIT
                  nValTot3 += TRB->VALTIT
                  //
               Endif
               //
               @ Li, Pcol()+001 PSAY Transform(TRB->ATRASO, "@E 9999")
               //
               nTotCli += 1
               nTotVen += 1
               Li += 1
               //
               TRB->(DbSkip())
               //
               If TRB->CODVEN # cVend .Or. TRB->(Eof()) .Or.;
                  (TRB->CODCLI + TRB->CODLOJ) # cCliente
                  //
                  //Li += 1
                  @ Li, 000 PSAY "Total do Cliente ----------> "
                  @ Li, Pcol()+001 PSAY Transform(nValCli1, "@E 999,999,999.99")
                  @ Li, Pcol()+001 PSAY Transform(nValCli2, "@E 999,999,999.99")
                  @ Li, Pcol()+001 PSAY Transform(nValCli3, "@E 999,999,999.99")
                  @ Li, Pcol()+001 PSAY Transform(nTotCli, "@E 999999") + " Titulo(s) Atrasado(s)"
                  Li += 1
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
            @ Li, Pcol()+001 PSAY Transform(nValTot1, "@E 999,999,999.99")
            @ Li, Pcol()+001 PSAY Transform(nValTot2, "@E 999,999,999.99")
            @ Li, Pcol()+001 PSAY Transform(nValTot3, "@E 999,999,999.99")
            @ Li, Pcol()+001 PSAY Transform(nTotVen, "@E 999999") + " Titulo(s) Atrasado(s)"
            Li += 1
            //
         Endif
         //
         Li := 60
         //
      Endif
      //
      DbSelectArea("SE3")
      //
      nAg1 += nAc1
      nAg2 += nAc2
      nAg3 += nAc3
      //
Enddo
//
If (nAg1 + nAg2 + nAg3) # 0
   //
   Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo)
   //
   @ Li, 112 PSAY "Total Geral --------------> "
   @ Li, Pcol()+001 PSAY nAg3  Picture Tm(nAg3, 15, nDecs)
   @ Li, Pcol()+001 PSAY nAg1  Picture Tm(nAg1, 15, nDecs)
   @ Li, Pcol()+001 PSAY (nAg2 / nAg1) * 100                                                                                                           Picture "999.99"
   @ Li, Pcol()+001 PSAY nAg2 Picture Tm(nAg2, 14, nDecs)
   //
   If Mv_Par10 > 0 .And. (nAg2 * Mv_Par10 / 100) > GetMV("MV_VLRETIR")
      //
      Li ++
      @ Li, 112 PSAY "Total do IR --------------> "
      @ Li, Pcol()+001 PSAY (nAg2 * Mv_Par10 / 100) PicTure Tm((nAg2 * Mv_Par10 / 100), 15, nDecs)
      //
   Endif
   //
   Roda(cbcont, cbtxt, "G")
   //
EndIF
//
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
Set Filter To
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