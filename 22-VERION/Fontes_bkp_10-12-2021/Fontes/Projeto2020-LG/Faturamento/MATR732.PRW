#INCLUDE "rwmake.CH"
/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR732  ³ Autor ³                       ³ Data ³ 17.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao do Orçamento                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function Matr732()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := "Emissao do Orcamento"
Local cDesc1  := "Emissao do Orcamento de pedidos de venda, de acordo com"
Local cDesc2  := "intervalo informado na opcao Parametros."
Local cDesc3  := " "
Local cString := "SCJ"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .T. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "MATR732" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "MATR732"
Local Tamanho := "M" // P/M/G
Local cPerg   := "MTR732    "

//Private Limite  := 220 // 80/132/220
Private Limite  := 132 //80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 2, 1, 1, "",0 } 
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

_cNrVrOrc := ""
_cObs     := ""

If Empty(MV_PAR01)
   _cNrVrOrc := SCJ->CJ_NUM
   _cNrVrOrf := SCJ->CJ_NUM
Else     
   _cNrVrOrc := MV_PAR01
   _cNrVrOrf := MV_PAR02
Endif

dbSelectArea("SCJ")
dbSetOrder(1)
//dbSeek(xFilial()+mv_par01)
//Do While !Eof() .and. xFilial("SCJ") == SCJ->CJ_FILIAL .and. SCJ->CJ_NUM <= mv_par02

If Empty(MV_PAR01)
   dbSeek(xFilial()+_cNrVrOrc)
Else  
   dbSeek(xFilial()+mv_par01)
Endif
//oPrn := TAvPrinter():New()
//cBitMap:= "lgrl01.Bmp"
//oPrn:SayBitmap( 000,000,cBitMap,1300,900 )

While !Eof() .and. xFilial("SCJ") == SCJ->CJ_FILIAL .and. SCJ->CJ_NUM <= _cNrVrOrf

   _cObs := ALLTRIM(SCJ->CJ_VEROBS)

   // cad de cliente
   dbSelectArea("SA1")
   dbSetOrder(1)
   dbSeek(xFilial()+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)

   // cad de vendedor
   dbSelectArea("SA3")
   dbSetOrder(1)
   dbSeek(xFilial()+SA1->A1_VEND)
                                   
   If     Month(SCJ->CJ_EMISSAO) == 01
          _cDMes := "Janeiro"
   ElseIf Month(SCJ->CJ_EMISSAO) == 02
          _cDMes := "Fevereiro"
   ElseIf Month(SCJ->CJ_EMISSAO) == 03
          _cDMes := "Marco"   
   ElseIf Month(SCJ->CJ_EMISSAO) == 04
          _cDMes := "Abril"
   ElseIf Month(SCJ->CJ_EMISSAO) == 05
          _cDMes := "Maio"     
   ElseIf Month(SCJ->CJ_EMISSAO) == 06
          _cDMes := "Junho"   
   ElseIf Month(SCJ->CJ_EMISSAO) == 07
          _cDMes := "Julho"  
   ElseIf Month(SCJ->CJ_EMISSAO) == 08
          _cDMes := "Agosto"  
   ElseIf Month(SCJ->CJ_EMISSAO) == 09
          _cDMes := "Setembro"
   ElseIf Month(SCJ->CJ_EMISSAO) == 10
          _cDMes := "Outubro"
   ElseIf Month(SCJ->CJ_EMISSAO) == 11
          _cDMes := "Novembro"
   ElseIf Month(SCJ->CJ_EMISSAO) == 12
          _cDMes := "Dezembro"
   EndIf          

//   @ 01, 70 psay Strzero(Day(dDataBase),2)+"/"+Strzero(Month(dDataBase),2)+"/"+Str(Year(dDataBase),4)
   @ 03, 46 psay "Sao Paulo, "+Strzero(Day(SCJ->CJ_EMISSAO),2)+" de "+ _cDMes +" de "+Str(Year(SCJ->CJ_EMISSAO),4)
   @ 04, 46 psay "N. Cotacao ==> " + SCJ->CJ_NUM
   @ 05, 01 psay "A"
   @ 06, 01 psay SA1->A1_NOME
   @ 08, 01 psay "A/C: " + SCJ->CJ_CONTATO
   @ 09, 01 psay "FONE: " + SA1->A1_DDD + " " + SA1->A1_TEL
   @ 09, 40 psay "FAX: " + SA1->A1_DDD + " " + SA1->A1_FAX
//   @ 12, 01 psay "VENDEDOR: " + SA1->A1_VEND + " - " + SA3->A3_NOME
   @ 11, 01 psay "VALORES EM REAIS"
   @ 13, 16 psay "CONFORME SOLICITACAO DE V.Sas. PASSAMOS ABAIXO PRECOS E DEMAIS"
   @ 14, 01 psay "CONDICOES PARA FORNECIMENTO."
//   @ 18, 01 psay "ITEM  QTD UN CODIGO          DESCRICAO                             ENTREGA IPI %  R$ UNIT   CM "
   @ 15, 01 psay Replicate("-",94)
//                          1         2         3         4         5         6         7         8         9
//                1234564789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   @ 16, 01 psay "|IT| QTD|UN|CODIGO         |DESCRICAO                               |ENTR |IPI%|CM|R$ UNIT   |"
   @ 17, 01 psay Replicate("-",94)

   lin    := 18
   _nTIPI := 0  // Total IPI
   _nTIICMSST := 0  // Total ICMS ST
   _nTPcv := 0  // Total Preço de Venda
   _nTPR  := 0  // Total Preço em Reais
   _nTPD  := 0  // Total Preço em Dolar
   _nTPE  := 0  // Total Preço em Euros


   dbSelectArea("SCK")
   dbSetOrder(1)
   dbSeek(xFilial()+SCJ->CJ_NUM)

   While !Eof() .and. xFilial("SCK") == SCK->CK_FILIAL .and. SCJ->CJ_NUM == SCK->CK_NUM
      
      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial()+SCK->CK_PRODUTO)
      dbSelectArea("SCK")

      @ lin, 01 psay "|"+SCK->CK_ITEM+"|"
      @ lin, 04 psay SCK->CK_QTDVEN Picture "@e 9,999"
      @ lin, 09 psay "|"+SCK->CK_UM
      @ lin, 12 psay "|"+SCK->CK_PRODUTO
      @ lin, 28 psay "|"+Substr(SCK->CK_DESCRI,1,40)   // 1,25
//      _cObs := _cObs+ALLTRIM(SCK->CK_OBS)

      If mv_par03=1
		@ lin, 69 psay "|"
        IF UPPER(ALLTRIM(SCK->CK_VERDDL)) == "IME"
		   @ lin, 70 psay ALLTRIM(SCK->CK_VERDDL)
		ELSE   
		   @ lin, 70 psay ALLTRIM(SCK->CK_VERDDL)+"DD"		   
        ENDIF
		@ lin, 75 psay "|"
		@ lin, 76 psay SB1->B1_IPI    Picture "@e 99.9"
// 		@ lin, 66 psay SCK->CK_PRCVEN Picture "@e 99,999.99"  
	  Endif	
	
	  If SB1->B1_TPMOEDA <> " "
			If SB1->B1_TPMOEDA == "D"
	  	       If mv_par03=1	
//			      @ lin, 76 psay "US$"
              	  @ lin, 80 psay "|"
			      @ lin, 82 psay "1"
	           Endif
				_nTPD := _nTPD + (SCK->CK_PRCVEN * SCK->CK_QTDVEN)
			Elseif SB1->B1_TPMOEDA == "E"
	  	       If mv_par03=1		
//				  @ lin, 76 psay "EURO"
              	  @ lin, 80 psay "|"
				  @ lin, 82 psay "2"
	           Endif
				_nTPE := _nTPE + (SCK->CK_PRCVEN * SCK->CK_QTDVEN)
			EndIf
	  Else
			dbSelectArea("SBM")
			dbSetOrder(1)
			dbSeek(xFilial()+SB1->B1_GRUPO)
			dbSelectArea("SCK")
		
			If     SBM->BM_MOEDA == "R"
	  	       If mv_par03=1		
//				  @ lin, 76 psay "R$"
              	  @ lin, 80 psay "|"
				  @ lin, 82 psay "3"
	           Endif
				_nTPR := _nTPR + (SCK->CK_PRCVEN * SCK->CK_QTDVEN)
			ElseIf SBM->BM_MOEDA == "D"
	  	       If mv_par03=1			
//				  @ lin, 76 psay "US$"
              	  @ lin, 80 psay "|"
				  @ lin, 82 psay "1"
	           Endif
				_nTPD := _nTPD + (SCK->CK_PRCVEN * SCK->CK_QTDVEN)
			ElseIf SBM->BM_MOEDA == "E"
	  	       If mv_par03=1				
//				  @ lin, 76 psay "EURO"
              	  @ lin, 80 psay "|"
				  @ lin, 82 psay "2"
	           Endif
				_nTPE := _nTPE + (SCK->CK_PRCVEN * SCK->CK_QTDVEN)
			EndIf
	  EndIf
	
      If mv_par03=1
 		@ lin, 83 psay "|"
 		@ lin, 84 psay SCK->CK_PRCVEN Picture "@e 99,999.99"  
 		@ lin, 94 psay "|"
	  Endif	

      If Len(Alltrim(SB1->B1_DESC)) > 20
         lin := lin + 1
         @ lin, 01 psay "|"
         @ lin, 04 psay "|"
         @ lin, 09 psay "|"
         @ lin, 12 psay "|"
         @ lin, 28 psay "|" // +Substr(SCK->CK_DESCRI,26,25)
         @ lin, 69 psay "|"
         @ lin, 75 psay "|"
         @ lin, 80 psay "|"
 		 @ lin, 83 psay "|"
 		 @ lin, 94 psay "|"
      EndIf

//      If Len(Alltrim(SCK->CK_DESCRI)) > 40
//         lin := lin + 1
//         @ lin, 28 psay "|"+Substr(SCK->CK_DESCRI,43,10)
//      EndIf
      lin := lin + 1
      
      _nTIPI := _nTIPI + ((SCK->CK_PRCVEN * SCK->CK_QTDVEN) * (SB1->B1_IPI / 100))   
    //  iF SCK->CK_TES $ GETMV(MV_TESST)    
	//      _nTIICMSST :=  _nTIICMSST + 

      _nTPcv := _nTPcv + ( SCK->CK_PRCVEN * SCK->CK_QTDVEN)

      dbSkip()
   End  

   @ lin, 01 psay Replicate("-",79)    
   lin := lin + 1

   dbSelectArea("SE4")
   dbSetOrder(1)
   dbSeek(xFilial()+SCJ->CJ_CONDPAG)
   
   dbSelectArea("SM2")
   dbSetOrder(1)
   dbSeek(SCJ->CJ_EMISSAO)

   lin := lin + 2
   @ lin, 01 psay "COND. DE PAGTO........: " + SE4->E4_DESCRI   
   lin := lin + 1
   @ lin, 01 psay "VALIDADE DA PROPOSTA..:"
   lin := lin + 1
   @ lin, 01 psay "I.P.I.................:"
   @ lin, 30 psay _nTIPI Picture "@ez 99,999.99"
   lin := lin + 1
   @ lin, 01 psay "I.C.M.S...............:"
   lin := lin + 1
   @ lin, 01 psay "VLR. REAIS............:"
   @ lin, 26 psay _nTPR Picture "@ez 99,999,999.99"   
   lin := lin + 1
   @ lin, 01 psay "VLR. R$ X TX DOLAR....:"
   @ lin, 26 psay _nTPD Picture "@ez 99,999,999.99"
   If _nTPD > 0
      @ lin, 42 psay "("
      @ lin, 43 psay SM2->M2_MOEDA2 Picture "@ez 99.9999"
      @ lin, 50 psay ")  =  "
      @ lin, 59 psay (_nTPD/SM2->M2_MOEDA2) Picture "@ez 99,999,999.99"
   EndIf
   lin := lin + 1
   @ lin, 01 psay "VLR. R$ X TX EURO.....:"
   @ lin, 26 psay _nTPE Picture "@ez 99,999,999.99"
   If _nTPE > 0   
      @ lin, 42 psay "("
      @ lin, 43 psay SM2->M2_MOEDA4 Picture "@ez 99.9999"
      @ lin, 50 psay ")  =  "
      @ lin, 59 psay (_nTPE/SM2->M2_MOEDA4) Picture "@ez 99,999,999.99"
   EndIf   
   lin := lin + 2
   @ lin, 01 psay "VLR.TOTAL + IPI + ICMS ST EM R$.:"
   @ lin, 26 psay (_nTPcv+_nTIPI) Picture "@ez 99,999,999.99"   
   lin := lin + 2

   If Len(_cObs) > 0
      @ lin,01 psay "OBSERVACAO: "
      @ lin,13 PSAY SUBSTR(_cObs,1,60)
      lin := lin + 1
      @ lin,01 PSAY SUBSTR(_cObs,61,70)
      lin := lin + 2
   Else
      @ lin, 01 psay "OBSERVACAO: "
      lin := lin + 2
   Endif

   @ lin, 01 psay "- Conversao de Moeda (CM) => 1 = Dolar ; 2 = Euro ; 3 = Reais"
   lin := lin + 1
   @ lin, 01 psay "- Preco unitario a VISTA + ICMS(INCLUSO), IPI e ICMS ST(NAO INCLUSO),posto VERION-SP (FOB)."
   lin := lin + 1
   @ lin, 01 psay "- O preco e em REAIS, BASEADO no DOLAR/EURO DE VENDA e que sera CONVERTIDO"
   lin := lin + 1
   @ lin, 01 psay "  de acordo c/ VARIACAO da moeda do dia anterior efetivo ao faturamento."
   lin := lin + 1
   @ lin, 01 psay "- COND. PAGTO: Acima + Custo Financeiro**PARCELADO = IMPOSTOS 1 VENCIMENTO."
   lin := lin + 1
   @ lin, 01 psay "- CUSTO FINANCEIRO: Taxa de mercado vigente na data do efetivo faturamento."
   lin := lin + 1
   @ lin, 01 psay "- PRAZO ENTREGA:Conf.acima, salvo eventuais vendas ate a colocacao do pedido."
   lin := lin + 1
   @ lin, 01 psay "- FATURAMENTO MINIMO: R$ 250,00 (DUZENTOS E CINQUENTA REAIS), A VISTA."
   lin := lin + 1
   @ lin, 01 psay "- REMESSAS PARA IDENTIFICACAO, CONSERTO E GARANTIA: SOMENTE COM NOTA FISCAL."
   lin := lin + 1
   @ lin, 01 psay "Estamos a sua disposicao para quaisquer esclarecimentos. Sem mais."
   lin := lin + 2
   @ lin, 01 psay "ATENCIOSAMENTE,"
   lin := lin + 1
   @ lin, 01 psay SA3->A3_NOME
   lin := lin + 1
   @ lin, 01 psay "VERION LTDA."

   dbSelectArea("SCJ")
   dbSkip()
   
End   

/*
         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
ITEM   QTD UN CODIGO          DESCRIÇÃO             ENTREGA IPI %  R$ UNIT MOEDA
 99  9.999 XX 123456789012345 12345678901234567890 99/99/99 99,99 9.999,99  EURO
                              12345678901234567890  
                              1234567890   

         1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890

- Preço acima e a VISTA, ICMS INCLUSO + IPI(NÃO INCLUSO), posto VERION - SP.
- O preço é em REAIS, BASEADO no DOLAR COMERCIAL DE VENDA e que será CONVERTIDO
  de acordo c/ VARIAÇÃO DO DOLAR do dia anterior efetivo ao faturamento.
- COND. PAGTO: Acima + Custo Financeiro**PARCELADO = IMPOSTOS 1º VENCIMENTO.
- CUSTO FINANCEIRO: Taxa de mercado vigente na data do efetivo faturamento.
- PRAZO ENTREGA: Conf. acima, salvo eventuais vendas até a colocação do pedido.
- PEDIDO MÍNIMO: R$ 100,00 (CEM REAIS), A VISTA.
- REMESSAS PARA IDENTIFICAÇÃO, CONSERTO E GARANTIA: SOMENTE COM NOTA FISCAL.
Estamos a sua disposição para quaisquer esclarecimentos. Sem mais.

ATENCIOSAMENTE,
VERION LTDA.
*/

Set Device To Screen
Set Printer To

RetIndex("SCJ")   
dbSelectArea("SCJ")
Set Filter to

dbSelectArea("SCK")
Set Filter To
dbSetOrder(1)
dbGotop()

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)
