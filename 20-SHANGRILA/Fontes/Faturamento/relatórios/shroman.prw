#include "rwmake.ch"
//
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: SHROMAN                            Modulo : SIGAFAT      //
//                                                                          //
//   Autor ......: PAULO ROBERTO DE OLIVEIRA          Data ..: 13/08/01     //
//                                                                          //
//   Objetivo ...: Emissao de Romaneios de Pedidos de Venda                 //
//                                                                          //
//   Uso ........: Especifico da Shangri-la                                 //
//                                                                          //
//   Observacoes : A impressao sera por pedido de venda e seus itens        //
//                                                                          //
//   Atualizacao : 13/08/01 - PAULO ROBERTO DE OLIVEIRA                     //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//

///////////////////////
User Function Shroman()                     
///////////////////////
//
SetPrvt("CALIAS,NRECORD,CORDER,WNREL,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,LABORTPRINT,LIMITE,TAMANHO,NOMEPROG")
SetPrvt("NTIPO,ARETURN,NLASTKEY,TITULO,LI,CABEC1")
SetPrvt("CABEC2,M_PAG,CPERG,SALIAS,AREGS,I,J")
SetPrvt("CNOMARQ,ACAMPOS,CIND,")
//
cAlias      := Alias()            // Salvar Contexto em Utilizacao
nRecord     := Recno()
cOrder      := IndexOrd()
//
wnRel       := "SHROMAN"          // Definir Variaveis
cString     := "SC5"
cDesc1      := "Este programa tem como objetivo gerar uma Relacao de"
cDesc2      := "Pedidos de Venda referente ao Romaneio para separacao"
cDesc3      := "dos mesmos."
lAbortPrint := .F.
Limite      := 132
Tamanho     := "P"
Nomeprog    := "SHROMAN"
nTipo       := 18
//aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey    := 0
Titulo      := "Romaneio de Pedidos de Venda"
Li          := 66
Cabec1      := ""
Cabec2      := ""
m_Pag       := 1
cPerg       := PADR("SHROMA",LEN(SX1->X1_GRUPO))
aDriver     := ReadDriver()
//
PgShroman()
//
Pergunte(cPerg, .F.)
//
wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3,;
         .T., {}, .T., Tamanho)
//
If nLastKey == 27
   Return (.T.)
Endif
//
SetDefault(aReturn, cString)
//
If nLastKey == 27
   Return (.T.)
Endif
//
RptStatus({|AbortPrint| RlShroman()}, Titulo)
//
Return (.T.)

///////////////////////////
Static Function RlShroman()
///////////////////////////
//
cNomArq := ""                // Arquivo Temporario de Itens de Pedidos de Venda
aCampos := {}
//
Aadd(aCampos, {"CODPRO", "C", 15, 0})       // Codigo do Produto
Aadd(aCampos, {"DESPRO", "C", 30, 0})       // Descricao do Produto
Aadd(aCampos, {"ENTREG", "D", 08, 0})       // Data Entrega                 
Aadd(aCampos, {"OBSERV", "C", 50, 0})       // Observacao do Item do Pedido
Aadd(aCampos, {"UNIPRO", "C", 02, 0})       // Unidade do Produto
Aadd(aCampos, {"QTDVEN", "N", 10, 3})       // Quantidade do Item do Pedido
Aadd(aCampos, {"ALM   ", "C", 02, 0})       // Almoxarifado
Aadd(aCampos, {"TES   ", "C", 07, 0})       // TES
//
cNomArq := Criatrab(aCampos, .T.)
DbUseArea(.T.,, cNomArq, "TRB", .F., .F.)
//
cInd := Criatrab(Nil, .F.)
IndRegua("TRB", cInd, "DESPRO+CODPRO+OBSERV",,, "Selecionando Registros...")
DbSetIndex(cInd + OrdBagExt())
//
SA4->(DbSetOrder(1))         // Transportadoras
SA1->(DbSetOrder(1))         // Clientes
SB1->(DbSetOrder(1))         // Produtos
SC5->(DbSetOrder(1))         // Pedidos de Venda
SC6->(DbSetOrder(1))         // Itens de Pedidos de Venda
//
Li := 66
xCont := 0
//
DbSelectArea("SC5")
SetRegua(Reccount())
DbSeek(xFilial("SC5") + Mv_Par01, .T.)
//                       
nPed := C5_NUM
While SC5->(!Eof()) .And. SC5->C5_FILIAL == xFilial("SC5") .And.;
      SC5->C5_NUM <= Mv_Par02
      //
      IncRegua()
      //
      If lAbortPrint
         @ 00, 001 PSAY "*** CANCELADO PELO OPERADOR ***"
         Exit
      Endif
      //
      If Dtos(SC5->C5_EMISSAO) < Dtos(Mv_Par03) .Or.;
         Dtos(SC5->C5_EMISSAO) > Dtos(Mv_Par04)
         //
         DbSelectArea("SC5")
         SC5->(DbSkip())
         Loop
         //
      Endif
      //             
      If nPed <> C5_NUM // Akron 12/11/06
		nPed := C5_NUM
      	ShSaltaPag()
      Endif
      
      If xCont = 2 .Or. Li > 51
         ShSaltaPag()  
         xCont := 0
      Else
         xCont++
      EndIf            
      //
      DbSelectArea("SA4")
      DbSeek(xFilial("SA4") + SC5->C5_TRANSP, .F.)
      //
      DbSelectArea("SA1")
      DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .F.)
      //
      cCab1 := SM0->M0_NOMECOM //Replicate("=", Limite)
      cCab2 := "Cliente : " + SC5->C5_CLIENTE + " - " + Substr(SA1->A1_NOME,1,40) +;
               Space(4) + "Emissao : " + Dtoc(SC5->C5_EMISSAO) + Space(3) +;
               "Pedido : " + SC5->C5_NUM
      cCab3 := "Transportadora : "+Substr(SA4->A4_NOME, 1, 40) //+" Endereço : "+Substr(SA4->A4_END, 1, 40)
      cCab4 := "Qtdade UN Descricao                                Dt.Entrg Observacao                                         Codigo-Al TES"
//    cCab4 := "Qtdade UN Descricao                                Dt.Entrg Observacao                                         Codigo-Al TES    "      
      //        999999 XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999-99 999/999
      //        123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
      //        0        1         2         3         4         5         6         7         8         9         0         1         2         3 3
      //        0        0         0         0         0         0         0         0         0         0         1         1         1         1 1
      cCab5 := Replicate("-", Limite)
      //
      cRod1 := IIf(!Empty(SC5->C5_MENNOTA), "Obs. Ped.: " + Substr(SC5->C5_MENNOTA, 1, 100), "")
      cRod2 := Replicate("-", Limite)
      cRod3 := IIf(!Empty(SA1->A1_OBSPED), "Obs. Cliente: " + Substr(SA1->A1_OBSPED, 1, 80), "")
      //
      ShCabPedid()                // Imprimir o Cabecalho do Pedido
      //
      DbSelectArea("TRB")         // Zerar o Arquivo Temporario
      Zap
      //
      DbSelectArea("SC6")
      DbSeek(xFilial("SC6") + SC5->C5_NUM, .T.)
      //
      While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
            SC6->C6_NUM == SC5->C5_NUM
            //
            lAglutina := F_Aglutina()  // Itens C/ Mesma Qtde Nao Devem Ser Aglutinados
            //
            DbSelectArea("SB1")
            DbSeek(xFilial("SB1") + SC6->C6_PRODUTO, .F.)
            //
            DbSelectArea("TRB")
            DbSeek(SC6->C6_DESCRI + SC6->C6_PRODUTO + SC6->C6_OBSERV, .F.)
            //
            If Found()
            //
               If ! lAglutina
                  RecLock("TRB", .F.)
               Else
                  RecLock("TRB", .T.)
               Endif
               //
            Else
               RecLock("TRB", .T.)
            Endif
             //                         
            TRB->CODPRO := SB1->B1_COD
            //TRB->DESPRO := Substr(SB1->B1_DESC, 1, 40) 
            TRB->DESPRO := Substr(SC6->C6_DESCRI, 1, 40) 
            TRB->ENTREG := SC6->C6_ENTREG
            TRB->OBSERV := Substr(SC6->C6_OBSERV, 1, 50)
            TRB->UNIPRO := SB1->B1_UM
            TRB->QTDVEN := SC6->C6_QTDVEN-SC6->C6_QTDENT
            TRB->ALM    := SC6->C6_LOCAL 
            TRB->TES    := SC6->C6_TES 
            If ( TRB->TES = "601" )
               TRB->TES := "501/601"
            End if
            //
            MsUnlock()
         //
         DbSelectArea("SC6")
         SC6->(DbSkip())
         //
      Enddo
      //
      // Verifica a quantidade de itens para imprimir
      
      
      //
      DbSelectArea("TRB")         // Impressao dos Itens do Pedido pelo TRB
      DbGoTop()
      //
      While TRB->(!Eof())
            //

            cLindet := Transform(TRB->QTDVEN,IF((TRB->QTDVEN-INT(TRB->QTDVEN))>0,"@E 9999.999","@E 999999")) + Space(1) +;
                       TRB->UNIPRO + Space(1) + Substr(Posicione("SB1",1,xFilial("SB1")+TRB->CODPRO,"B1_DESC"),1,40) + Space(1) + DTOC(TRB->ENTREG) + Space(1) +;
                       TRB->OBSERV + Space(1) + Alltrim(TRB->CODPRO)+"-"+ TRB->ALM + Space(1) + TRB->TES
/*
            cLindet := Transform(TRB->QTDVEN,IF((TRB->QTDVEN-INT(TRB->QTDVEN))>0,"@E 9999.999","@E 999999")) + Space(1) +;
                       TRB->UNIPRO + Space(1) + TRB->DESPRO + Space(1) + DTOC(TRB->ENTREG) + Space(1) +;
                       TRB->OBSERV + Space(1) + Alltrim(TRB->CODPRO)+"-"+ TRB->ALM  
*/                       
            //
            If Li > 51
               //
               ShRodPedid()
               ShSaltaPag()
               ShCabPedid()
               //
            Endif
            //
            ShDetPedid()          // Imprimir a Linha de Detalhe do Pedido (Item)
            //
            DbSelectArea("TRB")
            TRB->(DbSkip())
            //
      Enddo
      //
      ShRodPedid()                // Imprimir o Rodape do Pedido de Venda (Mensagem)
      //
      DbSelectArea("SC5")
      SC5->(DbSkip())
      //
Enddo
//
If Li # 66
   @ 66, 000 PSAY " "             // Posicionar no Inicio da Proxima Folha
Endif
//
SA4->(DbSetOrder(1))
SA1->(DbSetOrder(1))
SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
//
DbSelectArea("TRB")
DbCloseArea()
Delete File (cNomarq + ".DBF")
Delete file (cInd + OrdBagExt())
//
DbSelectArea(cAlias)
DbSetOrder(cOrder)
DbGoTo(nRecord)
//
Set Device To Screen
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

////////////////////////////
Static Function F_Aglutina()
////////////////////////////
//
DbSelectArea("SC6")          // Verificar Se o Item Corrente Pode Ser Aglutinado
//
lStatus     := .T.           // Pode Aglutinar
//
cAliasSC6   := Alias()       // Salvar Contexto em Utilizacao do SC6
nRecordSC6  := Recno()
cOrderSC6   := IndexOrd()
//
xC6_PRODUTO := SC6->C6_PRODUTO         // Dados do Item Corrente
xC6_QTDVEN  := SC6->C6_QTDVEN
xC6_OBSERV  := SC6->C6_OBSERV
xC6_ITEM    := SC6->C6_ITEM
xC6_TES     := SC6->C6_TES
//
DbSelectArea("SC6")
DbSeek(xFilial("SC6") + SC5->C5_NUM, .T.)
//
While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And.;
      SC6->C6_NUM == SC5->C5_NUM
      //
      If SC6->C6_ITEM # xC6_ITEM .And. SC6->C6_PRODUTO == xC6_PRODUTO;
         .And. SC6->C6_OBSERV == xC6_OBSERV;
         .And. SC6->C6_QTDVEN == xC6_QTDVEN      // Se For a Mesma Qtde
         //
         lStatus := .F.                          // Pular
         Exit
         //
      Endif
      //
      DbSelectArea("SC6")
      SC6->(DbSkip())
      //
Enddo
//
DbSelectArea(cAliasSC6)
DbSetOrder(cOrderSC6)
DbGoTo(nRecordSC6)
//
Return (lStatus)

////////////////////////////
Static Function ShSaltaPag()
////////////////////////////
//          
Li := 0   
@ Li, 000 PSAY AvalImp(Limite)
//
Return (.T.)

////////////////////////////
Static Function ShCabPedid()
////////////////////////////
//
Li := Li + 5
//Li := 0
//
If Li > 51
   ShSaltaPag()
Endif
//
Li := Li + 1
@ Li, 000 PSAY cCab1
Li := Li + 1
@ Li, 000 PSAY cCab2
Li := Li + 1
@ Li, 000 PSAY cCab3
Li := Li + 1
@ Li, 000 PSAY cCab4
Li := Li + 1
@ Li, 000 PSAY cCab5
//
Return (.T.)

////////////////////////////
Static Function ShDetPedid()
////////////////////////////
//
If Li > 56
   ShSaltaPag()
Endif
//
Li := Li + 2
@ Li, 000 PSAY cLindet
//
Return (.T.)

////////////////////////////
Static Function ShRodPedid()
////////////////////////////
//
If Li > 56
   ShSaltaPag()
Endif
//
Li := Li + 5
@ Li, 000 PSAY cRod1
// @ Li, 000 PSAY " "   // cRod1
Li := Li + 1
@ Li, 000 PSAY cRod2
Li := Li + 1
@ Li, 000 PSAY cRod3
Li := Li + 1
//
Return (.T.)

///////////////////////////
Static Function PgShroman()
///////////////////////////
//
sAlias := Alias()                      // Preparacao das Perguntas
cPerg  := Padr(cPerg, 6)
aRegs  := {}
//
Aadd(aRegs,{cPerg,"01","Do Pedido de Venda ?","","","mv_ch1","C",06,0,0,"G","",;
    "Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate o Pedido Venda ?","","","mv_ch2","C",06,0,0,"G","",;
    "Mv_Par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Da Data de Emissao ?","","","mv_ch3","D",08,0,0,"G","",;
    "Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Ate a Data Emissao ?","","","mv_ch4","D",08,0,0,"G","",;
    "Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//
DbSelectArea("SX1")
DbSetOrder(1)
//
For i := 1 To Len(aRegs)               // Pesquisa e Gravacao Eventual das Perguntas
    //
    If !DbSeek(cPerg + aRegs[i, 2])
       //
       Reclock("SX1", .T.)
       For j := 1 To FCount()
           FieldPut(j, aRegs[i, j])
       Next
       MsUnlock()
       //
    Endif
    //
Next
//
DbSelectArea(sAlias)
//
Return (.T.)