#include "rwmake.ch"        
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿ 
³Funcao	   ³ VRD301   ³ Autor ³ Silverio Bastos       ³ Data ³ 16/03/10 ³ 
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´ 
³Descricao ³ Impressao do Boleto                                        ³ 
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ 
³ Uso	   ³ Verion               `                                     ³ 
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
/*/
User Function VRD301(cNumBorde)
     Private nCont    := 1
     Private cPerg
     Private aTitulos := {}
     Private nDigbar  := "1"
     Private cNum     := ""
     Private cFiltro  := ""
     Private cAlias   := "" 
     Private cBarra  := SPACE(44)
     Private nPosHor := 0
     Private nLinha  := 0
     Private nEspLin := 0
     Private nTxtBox := 0
     Private nPosVer := 0
     Private cTexto01 := "Cobrar multa de 2% apos o Vencimento" 
     Private cTexto02 := "Juros 3,6% ao mes" 
     Private cTexto03 := "Protestar apos 10 dias do Vencimento" 
     Private cTexto04 := " " 
     Private cCedente := SM0->M0_NOMECOM
     Private cLogoBan := "BRADESCO2.BMP"
     Private dFator   := CTOD("07/10/1997")
     Private cLinha   :=""                 
     // aTitulos => array que contem as informacoes
     // que serao impressas no boleto
     // [n,01] = Prefixo+Numero+Parcela do Titulo
     // [n,02] = Vencimento
     // [n,03] = Valor do Titulo
     // [n,04] = Nosso Numero
     // [n,05] = Agencia
     // [n,06] = Codigo do Cedente
     // [n,07] = Carteira
     // [n,08] = Nome do CLiente
     // [n,09] = Emissao do titulo
     // [n,10] = Endereco do Cliente
     // [n,11] = Cidade do Cliente
     // [n,12] = Estado do Cliente
     // [n,13] = CEP do Cliente
     // [n,14] = CNPJ do Cliente
     // [n,15] = Data do Processamento
     // [n,16] = Conta do Cedente
     cPerg := "VRD301"
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Variaveis utilizadas para parametros                         ³
     //³ mv_par01             // Da Nota                              ³
     //³ mv_par02             // Ate a Nota                           ³
     //³ mv_par03             // Serie                                ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//     SetGlobal()
     // Retira filtro
     dbSelectArea("SE1")
     cFiltro := DbFilter()
     Set Filter to        
     // Inicializa array de titulos
     If Valtype(cNumBorde) == "U" .or. Len(cNumBorde) == 0
     	nCont:= 1
     	If Pergunte(cPerg,.T.)
	       DbSelectArea("SE1")
     	   DbSetOrder(1)
		   DbSeek(xFilial("SE1")+mv_par03+mv_par01)
		   While !Eof() .and. SE1->E1_NUM >= mv_par01 .and. SE1->E1_NUM <= mv_par02 .and. SE1->E1_PREFIXO == mv_par03
			     if /*SE1->E1_SALDO > 0 .and. */SE1->E1_PARCELA >= MV_PAR07 .and. SE1->E1_PARCELA <= MV_PAR08
				    Aadd(aTitulos,{"","",0,"","","","","","","","","","","","",""})
				    cNum := SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
				    aTitulos[nCont][01] := cNum            // Prexifo+Numero+Parcela do Titulo
				    aTitulos[nCont][02] := SE1->E1_VENCTO   // Vencimento
				    aTitulos[nCont][03] := SE1->E1_SALDO  // saldo
				    cDigAgen := Posicione("SA6",1,xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,"A6_DIGAGE")
				    aTitulos[nCont][05] := MV_PAR05 + cDigAgen  //SE1->E1_AGEDEP+cDigAgen   // Agencia
				    aTitulos[nCont][08] := StrZero(Day(SE1->E1_EMISSAO),2)+"/"+StrZero(Month(SE1->E1_EMISSAO),2)+"/"+StrZero(Year(SE1->E1_EMISSAO),4)
				    aTitulos[nCont][16] := MV_PAR06   // Numero da Conta Corrente
				    DbSelectArea("SEE")
					DbSetOrder(1)
					If DbSeek(xFilial("SEE")+MV_PAR04 + MV_PAR05 + MV_PAR06 + "000")  
					   aTitulos[nCont][06] := "0"  + SUBSTR(SEE->EE_IDEMP,9,08)  
					   aTitulos[nCont][07] := SEE->EE_CODCAR   // Carteira     
					   //Caso o Nosso Numero ja esteja preechido sempre uso o mesmo numero do SE1
					   IF EMPTY(SE1->E1_NOSNUM)
					      cFaixa1  := Left(SEE->EE_FAXATU,11)  
					      cFaixa2  := Val(Left(SEE->EE_FAXATU,11)) + 1                
					      cFaixa3  := StrZero(cFaixa2,11)
					      //cFaixa4  := cFaixa3 + Modulo11(SEE->EE_CODCAR + cFaixa3) 
					      cFaixa4  := cFaixa3 + NNumDV(SEE->EE_CODCAR + cFaixa3)
 		               cFaixaAtu:=cFaixa4
  				         RecLock("SEE",.F.)                                  
 	  				         SEE->EE_FAXATU:=cFaixaAtu 
 	  				      MsUnlock()
 	  				      aTitulos[nCont][04] := cFaixaAtu  
 	  				   Else
 	  				      aTitulos[nCont][04] := SE1->E1_NOSNUM
 	  				   Endif     
			      Else
					   MsgAlert("Nao encontrou Parametros Banco !")
					Endif
				    DbSelectArea("SA1")
				    DbSetOrder(1)
				    If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					   aTitulos[nCont][09] := SA1->A1_NOME
					   aTitulos[nCont][10] := SA1->A1_END
					   aTitulos[nCont][11] := SA1->A1_MUN
					   aTitulos[nCont][12] := SA1->A1_EST
					   aTitulos[nCont][13] := SA1->A1_CEP
					   aTitulos[nCont][14] := SA1->A1_CGC
					   aTitulos[nCont][15] := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
				    Endif         
			        Reclock("SE1",.F.)
			           IF SE1->(FieldPos("E1_NOSNUM")) > 0      
			              Reclock("SE1",.F.)
   			                 SE1->E1_NOSNUM:=aTitulos[nCont][04]
   			              MsUnlock()   
			           Endif
			        MsUnlock()
				    nCont += 1
			     Endif
			     DbSelectArea("SE1")
			     DbSkip()
	       End
	    EndIf
        Else
	       nCont := 1
	       DbSelectArea("SEA")
	       DbSetOrder(1)
	       If DbSeek(xFilial("SEA")+cNumBorde)
		      While !Eof() .and. SEA->EA_NUMBOR == cNumBorde
			        DbSelectArea("SE1")
			        DbSetOrder(1)
			        If DbSeek(xFilial("SE1")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO)
				       If SE1->E1_PORTADO $ "237" .and. SE1->E1_NUMBCO <> "" .and. SE1->E1_AGEDEP <> "" .and. SE1->E1_CONTA <> "" .and. SE1->E1_CONTA <> ""
					      Aadd(aTitulos,{"","",0,"","","","","","","","","","","","",""})
					      cNum := SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
					      aTitulos[nCont][01] := cNum            // Prexifo+Numero+Parcela do Titulo
					      aTitulos[nCont][02] := SE1->E1_VENCTO   // Vencimento
					      aTitulos[nCont][03] := U_FATRD006() // saldo     
					      aTitulos[nCont][04] := SE1->E1_NUMBCO 
					      //aTitulos[nCont][04] := Left(SE1->E1_NUMBCO,11)   // xxxxxxxxxxxxxxxxxxxxxxxxx
					      cDigAgen := Posicione("SA6",1,xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,"A6_DIGAGEN")
					      aTitulos[nCont][05] := SE1->E1_AGEDEP+cDigAgen   // Agencia
					      aTitulos[nCont][08] :=StrZero(Day(SE1->E1_EMISSAO),2)+"/"+StrZero(Month(SE1->E1_EMISSAO),2)+"/"+StrZero(Year(SE1->E1_EMISSAO),4)
					      aTitulos[nCont][16] := SE1->E1_CONTA 	  // Numero da Conta Corrente
					      // Obtem Carteira e Codigo do Cedente
					      // Posiciona no SEE que e o arquivo que tem
					      // a informacao da carteira e o codigo do cedente
					      DbSelectArea("SEE")
					      DbSetOrder(1)
					      If DbSeek(xFilial("SEE")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON+SEA->EA_SUBCTA)
						     aTitulos[nCont][06] := Right(Alltrim(SEE->EE_CODEMP),9)   // Codigo do Cedente
						     aTitulos[nCont][07] := SEE->EE_CART      // Carteira
					         Else
						      MsgAlert("Nao encontrou Parametros Banco !")
					      Endif
					      // Obtem dados do cliente
					      DbSelectArea("SA1")
					      DbSetOrder(1)
					      If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
						     aTitulos[nCont][09] := SA1->A1_NOME
						     aTitulos[nCont][10] := SA1->A1_END
						     aTitulos[nCont][11] := SA1->A1_MUN
						     aTitulos[nCont][12] := SA1->A1_EST
						     aTitulos[nCont][13] := SA1->A1_CEP
						     aTitulos[nCont][14] := SA1->A1_CGC
						     aTitulos[nCont][15] := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
					      Endif
					      nCont += 1
				      Endif
			      Endif
			      DbSelectArea("SEA")
			      DbSkip()
		      EndDo
	          Else
	     	    MsgAlert("Nao Localizou Bordero, entre em contato com a Informatica !")
		        Return
	       Endif
     Endif
     nDigbar    := SPACE(1)
     oFont06  := TFont():New( "Arial",,06,,.F.,,,,,.F. )
     oFont06B := TFont():New( "Arial",,06,,.T.,,,,,.F. )
     oFont07  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
     oFont07B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
     oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
     oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
     oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F. )
     oFont09B := TFont():New( "Arial",,09,,.T.,,,,,.F. )
     oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F. )
     oFont10B := TFont():New( "Arial",,10,,.T.,,,,,.F. )
     oFont11  := TFont():New( "Arial",,11,,.F.,,,,,.F. )
     oFont11B := TFont():New( "Arial",,11,,.T.,,,,,.F. )
     oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )
     oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )
     oFont13  := TFont():New( "Arial",,13,,.F.,,,,,.F. )
     oFont13B := TFont():New( "Arial",,13,,.T.,,,,,.F. )
     oFont14  := TFont():New( "Arial",,14,,.F.,,,,,.F. )
     oFont14B := TFont():New( "Arial",,14,,.T.,,,,,.F. )
     oFont15  := TFont():New( "Arial",,15,,.F.,,,,,.F. )
     oFont15B := TFont():New( "Arial",,15,,.T.,,,,,.F. )
     oFont16  := TFont():New( "Arial",,16,,.F.,,,,,.F. )
     oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
     oFont17  := TFont():New( "Arial",,17,,.F.,,,,,.F. )
     oFont17B := TFont():New( "Arial",,17,,.T.,,,,,.F. )
     oFont18  := TFont():New( "Arial",,18,,.F.,,,,,.F. )
     oFont18B := TFont():New( "Arial",,18,,.T.,,,,,.F. )
     oFont19  := TFont():New( "Arial",,19,,.F.,,,,,.F. )
     oFont19B := TFont():New( "Arial",,19,,.T.,,,,,.F. )
     oFont20  := TFont():New( "Arial",,20,,.F.,,,,,.F. )
     oFont20B := TFont():New( "Arial",,20,,.T.,,,,,.F. )
     oFont21  := TFont():New( "Arial",,21,,.F.,,,,,.F. )
     oFont21B := TFont():New( "Arial",,21,,.T.,,,,,.F. )
     oFont22  := TFont():New( "Arial",,22,,.F.,,,,,.F. )
     oFont22B := TFont():New( "Arial",,22,,.T.,,,,,.F. )
     oFont23  := TFont():New( "Arial",,23,,.F.,,,,,.F. )
     oFont23B := TFont():New( "Arial",,23,,.T.,,,,,.F. )
     oFont24  := TFont():New( "Arial",,24,,.F.,,,,,.F. )
     oFont24B := TFont():New( "Arial",,24,,.T.,,,,,.F. )
     oFont25  := TFont():New( "Arial",,25,,.F.,,,,,.F. )
     oFont25B := TFont():New( "Arial",,25,,.T.,,,,,.F. )
     oFont26  := TFont():New( "Arial",,26,,.F.,,,,,.F. )
     oFont26B := TFont():New( "Arial",,26,,.T.,,,,,.F. )
     oFont27  := TFont():New( "Arial",,27,,.F.,,,,,.F. )
     oFont27B := TFont():New( "Arial",,27,,.T.,,,,,.F. )
     oFont28  := TFont():New( "Arial",,28,,.F.,,,,,.F. )
     oFont28B := TFont():New( "Arial",,28,,.T.,,,,,.F. )
     oFont29  := TFont():New( "Arial",,29,,.F.,,,,,.F. )
     oFont29B := TFont():New( "Arial",,29,,.T.,,,,,.F. )
     oFont30  := TFont():New( "Arial",,30,,.F.,,,,,.F. )
     oFont30B := TFont():New( "Arial",,30,,.T.,,,,,.F. )
     oprn     := TMSPrinter():New()
     oprn:setup()
     npag  :=1
     For nCont := 1 to len(aTitulos)
	     nPosHor := 01
	     nLinha  := 01
	     nEspLin := 84
	     nPosVer := 10
	     nTxtBox := 05
	     oprn:SETPAPERSIZE(9) // <==== ajuste para papel A4
	     oprn:StartPage()
	     ImpBol()
  	     oprn:EndPage()
	     npag:= npag + 1
     Next nCont
     oprn:Preview()
     ms_flush()
     DbSelectArea("SE1")
     Set Filter To &cFiltro
Return (.T.)


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿ 
³Funcao	   ³ ImpBol	  ³ Autor ³ Helio                 ³ Data ³ 05/05/03 ³ 
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´ 
³Descricao ³ Impressao do Boleto                                        ³ 
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ 
³ Uso	   ³                                                            ³ 
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
/*/
Static Function ImpBol()
       // Monta codigo de barras do titulo
       MtCodBar()
       // Monta Linha digitavel
       MtLinDig()
       //oprn:StartPage()
       //-----------------------------------------------------------------------------------------------------------------------------------------
       //                               C o m p r o v a n t e    d e   E n t r e g a
       //-----------------------------------------------------------------------------------------------------------------------------------------
       // Imprime Logotipo do Banco
       nLinha  := nLinha + 1
       oPrn:Saybitmap(0090,0030,cLogoBan,0090,0070)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+25,nTxtBox+0140              ,"Bradesco" ,ofont14B,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)             ,nTxtBox+0366             ,"|237-2|"  ,ofont22B,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+10,nPosVer+1650              ,"Comprovante de Entrega",ofont14B,100)
       // Box Cedente
       nLinha  := nLinha + 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin)            ,nPosVer   ,nPosHor+(nLinha*nEspLin),nPosVer+0830)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox   ,nPosVer+0010               ,"Cedente",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+0010               ,cCedente ,ofont08,100)
       // Box Agencia/Codigo Cedente
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0830,nPosHor+(nLinha*nEspLin),nPosVer+1180)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0840                  ,"Agência/Código Cedente",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+0850               ,transform(aTitulos[nCont][05],"@R 9999-9")+"/"+transform(aTitulos[nCont][06],"@R 99999999-9"),ofont08B,100)
       // Box Motivos nao entrega
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1180,nPosHor+(nLinha*nEspLin)+(2*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1290,"Motivos de não entrega(para uso da empresa entregadora)",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0050)+nTxtBox,nPosVer+1210,"( )Mudou-se",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0050)+nTxtBox,nPosVer+1490,"( )Ausente",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0050)+nTxtBox,nPosVer+1820,"( )Não existe n. indicado",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0100)+nTxtBox+0025,nPosVer+1210,"( )Recusado",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0100)+nTxtBox+0025,nPosVer+1490,"( )Não Procurado",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0100)+nTxtBox+0025,nPosVer+1820,"( )Falecido",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0150)+nTxtBox+0050,nPosVer+1210,"( )Desconhecido",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0150)+nTxtBox+0050,nPosVer+1490,"( )Endereço Insuficiente",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin+0150)+nTxtBox+0050,nPosVer+1820,"( )Outros (anotar no verso)",ofont08,100)
       // Box Sacado
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0830)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Sacado",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0010,aTitulos[nCont][09],ofont08,100)
       // Box Nosso Numero
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0830,nPosHor+(nLinha*nEspLin),nPosVer+1180)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0840,"Nosso Número",ofont08,100)                                                               
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0860,aTitulos[nCont][07]+"/"+Left(aTitulos[nCont][04],11) +"-" + Right(aTitulos[nCont][4],1),ofont08B,120)
       //oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0860,aTitulos[nCont][07]+"/"+transform(aTitulos[nCont][04],"@R 99999999999-X"),ofont08B,100)
       // Box Vencimento
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0200)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Vencimento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0030,StrZero(Day(aTitulos[nCont][02]),2)+"/"+StrZero(Month(aTitulos[nCont][02]),2)+"/"+StrZero(Year(aTitulos[nCont][02]),4),ofont08B,100)
       // Box Numero do Documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0200,nPosHor+(nLinha*nEspLin),nPosVer+0520)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0210,"N. do Documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0300,aTitulos[nCont][01],ofont08,100)
       // Box Especie Moeda
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0520,nPosHor+(nLinha*nEspLin),nPosVer+0830)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0530,"Espécie Moeda",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0650,"R$",ofont08,100)
       // Box Valor do Documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0830,nPosHor+(nLinha*nEspLin),nPosVer+1180)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0840,"Valor do Documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0940,transform(aTitulos[nCont][03],"@E 999,999,999.99"),ofont08B,100)
       // Box Recebimento bloqueto
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0340)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Recebi(emos) o bloqueto",ofont08,100)
       // Box Data
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0340,nPosHor+(nLinha*nEspLin),nPosVer+560)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0350,"Data",ofont08,100)
       // Box Assinatura
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0560,nPosHor+(nLinha*nEspLin),nPosVer+1180)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0570,"Assinatura",ofont08,100)
       // Box Data
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1180,nPosHor+(nLinha*nEspLin),nPosVer+1520)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1190,"Data",ofont08,100)
       // Box Entregador
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1520,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1530,"Entregador",ofont08,100)
       // Box Local de Pagamento
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer    ,nPosHor+(nLinha*nEspLin),nPosVer+1910)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox    ,nPosVer+0010,"Local de Pagamento",ofont08,100)
       //oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox    ,nPosVer+0275,"BANCO BRADESCO S.A.",ofont09B,150)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+33 ,nPosVer+0275,"PAGÁVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO ",ofont09B,150)
       // Box Data de Processamento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1910,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1920,"Data de Processamento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1980,aTitulos[nCont][15],ofont08,100)
//----------------------------------------------------------------------------------------------------------------------------------------------       
//                           R e c i b o   d o   S a c a d o 
//----------------------------------------------------------------------------------------------------------------------------------------------
       nLinha  += 3
       //oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Saybitmap(0770,0030,cLogoBan,0090,0070)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+25,nTxtBox+0140,"Bradesco",ofont14B,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nTxtBox+0366,"|237-2|",ofont22B,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1720,"Recibo do Sacado",ofont14B,100)
       // Box Local de Pagamento
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer    ,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox    ,nPosVer+0010,"Local de Pagamento",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+33 ,nPosVer+0275,"PAGÁVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO ",ofont09B,150)`

       //Box Vencimento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Vencimento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+2060,StrZero(Day(aTitulos[nCont][02]),2)+"/"+StrZero(Month(aTitulos[nCont][02]),2)+"/"+StrZero(Year(aTitulos[nCont][02]),4),ofont08B,100)

       // Box Cedente
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Cedente"  ,ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+0010,cCedente,ofont08,100)
       //Box Agencia e Codigo do Cedente
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Agência/Código Cedente",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+1940,transform(aTitulos[nCont][05],"@R 9999-9")+"/"+transform(aTitulos[nCont][06],"@R 99999999-9"),ofont08B,100)
     
       // Box Data do documento
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0420)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Data do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0100,aTitulos[nCont][08],ofont08,100)
       // Box Numero do Documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0420,nPosHor+(nLinha*nEspLin),nPosVer+0790)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0430,"N° do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0530,aTitulos[nCont][01],ofont08,100)
       // Box Especie Doc
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0790,nPosHor+(nLinha*nEspLin),nPosVer+1050)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0800,"Espécie Doc",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0900,"DM",ofont08,100)
       // Box Aceite
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1050,nPosHor+(nLinha*nEspLin),nPosVer+1170)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1060,"Aceite",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1080,"Não",ofont08,100)
       // Box Data do Processamento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1170,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1180,"Data do Processamento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1280,aTitulos[nCont][15],ofont08,100)
       // Box Cart./nosso numero
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Cart./nosso número",ofont08,100)                              
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1960,aTitulos[nCont][07]+"/"+Left(aTitulos[nCont][04],11) +"-" + Right(aTitulos[nCont][4],1),ofont08B,100)

       // Box Uso do Banco
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0300)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Uso do Banco",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0050,"08650",ofont08,100)
       // Box Cip
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0300,nPosHor+(nLinha*nEspLin),nPosVer+0420)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0310,"Cip",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0315,"000",ofont08,100)
       // Box Carteira
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0420,nPosHor+(nLinha*nEspLin),nPosVer+0552)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0430,"Carteira",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0480,aTitulos[nCont][07],ofont08,100)
       // Box Especie Moeda
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0552,nPosHor+(nLinha*nEspLin),nPosVer+0790)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0562,"Espécie moeda",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0652,"R$",ofont08,100)
       // Box Quantidade
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0790,nPosHor+(nLinha*nEspLin),nPosVer+1170)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0800,"Quantidade",ofont08,100)
       // Box Valor
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1170,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1180,"Valor",ofont08,100)   
       //Box Valor do Documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"1(=) Valor do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+2000,transform(aTitulos[nCont][03],"@E 999,999,999.99"),ofont08B,100)

      // Box Logotipo
       //oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1700,"Bradesco",ofont30B,100)
       // Box Instrucoes
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin)+4*nEspLin,nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+10,nPosVer+0010,"Instruções de responsabilidade do cedente.",ofont09B,100)
       // Box Desconto / Abatimento                                
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)

       // Box Vencimento
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer+0010,cTexto01,ofont09B,100)
              // Box Outras deducoes.
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"3(-) Outras deduções",ofont08,100)

       // Box Agencia/Codigo Cedente
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer+0010,cTexto02,ofont09B,100)
       //Box Mora/Multa
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer+0010,cTexto03,ofont08,100)
       // Box Outros acrescimos
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"5(+) Outros Acréscimos",ofont08,100)
       
      // Box Valor do documento
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer+0010,cTexto04,ofont09B,100)
       // Box Valor cobrado
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"6(=) Valor cobrado",ofont08,100)
       // Box Valor cobrado
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin)+nEspLin,nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Sacado:",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0150,aTitulos[nCont][09],ofont08,100) // Nome Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1400,Transform(aTitulos[nCont][14],"@R 99.999.999/9999-99"),ofont08,100) // CNPJ Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0030,nPosVer+0150,aTitulos[nCont][10],ofont08,100) // End. Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+0150,Transform(aTitulos[nCont][13],"@R 99999-999"),ofont08,100) // CEP Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+0550,aTitulos[nCont][11],ofont08,100) // Cidade Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+1000,aTitulos[nCont][12],ofont08,100) // Estado Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0120,nPosVer+0010,"Sacador/Avalista:",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0170,nPosVer+1750,"Autenticação Mecânica",ofont08,100)
//------------------------------------------------------------------------------------------------------------------------------------------------------
//                  F I C H A     D E    C O M P E N S A C A O
//------------------------------------------------------------------------------------------------------------------------------------------------------       
       // Ficha de compensacao
       nLinha  += 4
              // Imprime Logotipo do Banco
       oPrn:Saybitmap(2020,0030,cLogoBan,0080,0070)

       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer,Replicate("-",190),ofont12,100)
       // Linha Digitavel
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+25,nTxtBox+0140,"Bradesco",ofont14B,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nTxtBox+0366,"|237-2|",ofont22B,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+0010,nTxtBox+0700,clinha,oFont14,100)
       // Box Local de Pagto
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer    ,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox    ,nPosVer+0010,"Local de Pagamento",ofont08,100)
       //oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox    ,nPosVer+0275,"BANCO BRADESCO S.A.",ofont09B,150)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+33 ,nPosVer+0275,"PAGÁVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO ",ofont09B,150)
       // Box Vencimento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Vencimento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+2060,StrZero(Day(aTitulos[nCont][02]),2)+"/"+StrZero(Month(aTitulos[nCont][02]),2)+"/"+StrZero(Year(aTitulos[nCont][02]),4),ofont08B,100)
       // Box Cedente
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Cedente",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+0010,cCedente,ofont08,100)
       // Box Agencia/Codigo Cedente
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Agência/Código Cedente",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin+30)+nTxtBox,nPosVer+1940,transform(aTitulos[nCont][05],"@R 9999-9")+"/"+transform(aTitulos[nCont][06],"@R 99999999-9"),ofont08B,100)
       // Box Data do documento
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0420)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Data do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0100,aTitulos[nCont][08],ofont08,100)
       // Box Numero do Documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0420,nPosHor+(nLinha*nEspLin),nPosVer+0790)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0430,"N° do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0530,aTitulos[nCont][01],ofont08,100)
       // Box Especie Doc
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0790,nPosHor+(nLinha*nEspLin),nPosVer+1050)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0800,"Espécie Doc",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0900,"DM",ofont08,100)
       // Box Aceite
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1050,nPosHor+(nLinha*nEspLin),nPosVer+1170)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1060,"Aceite",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1080,"Não",ofont08,100)
       // Box Data do Processamento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1170,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1180,"Data do Processamento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1280,aTitulos[nCont][15],ofont08,100)
       // Box Cart./nosso numero
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"Cart./nosso número",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+1960,aTitulos[nCont][07]+"/"+Left(aTitulos[nCont][04],11) +"-" + Right(aTitulos[nCont][4],1),ofont08B,100)
       // Box Uso do Banco
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin),nPosVer+0300)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Uso do Banco",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0050,"08650",ofont08,100)
       // Box Cip
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0300,nPosHor+(nLinha*nEspLin),nPosVer+0420)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0310,"Cip",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0315,"000",ofont08,100)
       // Box Carteira
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0420,nPosHor+(nLinha*nEspLin),nPosVer+0552)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0430,"Carteira",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0480,aTitulos[nCont][07],ofont08,100)
       // Box Espécie Moeda
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0552,nPosHor+(nLinha*nEspLin),nPosVer+0790)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0562,"Espécie moeda",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+0662,"R$",ofont08,100)
       // Box Quantidade
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+0790,nPosHor+(nLinha*nEspLin),nPosVer+1170)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0800,"Quantidade",ofont08,100)
       // Box Valor
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1170,nPosHor+(nLinha*nEspLin),nPosVer+1650)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1180,"Valor",ofont08,100)
       // Box Valor do documento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"1(=) Valor do documento",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+30,nPosVer+2000,transform(aTitulos[nCont][03],"@E 999,999,999.99"),ofont08B,100)
       nLinha  += 1
       // Box Desconto / Abatimento
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)
       // Box Instrucoes
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin)+4*nEspLin,nPosVer+1650)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+20,nPosVer+0010,"Instruções de responsabilidade do cedente.",ofont09B,100)
       // Box Outras deducoes
       nLinha  += 1
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,cTexto01,ofont09B,100)
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"3(-) Outras deduções",ofont08,100)
       // Box Mora / Multa
       nLinha  += 1                                                                               
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,cTexto02,ofont09B,100)
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin),nPosVer+0010,"  ",ofont08,100)
       // Box Outros acrescimos
       nLinha  += 1                                                        
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,cTexto03,ofont09B,100)
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"5(+) Outros Acréscimos",ofont08,100)
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+10,nPosVer+0010,"   ",ofont09B,100)
       // Box Valor cobrado
       nLinha  += 1                                                        
       oprn:say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,cTexto04,ofont09B,100)
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer+1650,nPosHor+(nLinha*nEspLin),nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1660,"6(=) Valor cobrado",ofont08,100)
       // Box Sacado
       nLinha  += 1
       oPrn:Box(nPosHor+((nLinha-1)*nEspLin),nPosVer,nPosHor+(nLinha*nEspLin)+nEspLin,nPosVer+2230)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0010,"Sacado:",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+0150,aTitulos[nCont][09],ofont08,100) // Nome Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox,nPosVer+1400,Transform(aTitulos[nCont][14],"@R 99.999.999/9999-99"),ofont08,100) // CNPJ Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0030,nPosVer+0150,aTitulos[nCont][10],ofont08,100) // End. Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+0150,Transform(aTitulos[nCont][13],"@R 99999-999"),ofont08,100) // CEP Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+0550,aTitulos[nCont][11],ofont08,100) // Cidade Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0060,nPosVer+1000,aTitulos[nCont][12],ofont08,100) // Estado Sacado
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0120,nPosVer+0010,"Sacador/Avalista:",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0170,nPosVer+1530,"Autenticação Mecânica",ofont08,100)
       oPrn:Say(nPosHor+((nLinha-1)*nEspLin)+nTxtBox+0170,nPosVer+1860,"Ficha de Compensação",ofont09,100)
       MSBAR("INT25",13.65,0.7,cBarra,oprn,.F.,,.T.,0.0135,0.65,NIL,NIL,NIL,.F.)
Return (.T.)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºFuncao    ³ MtCodBar º Autor ³                    º Data ³  11/05/03   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDescricao ³ Monta codigo de barras que sera impresso.                  º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºUso       ³                                                            º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
/*/
Static Function MtCodBar()
       Local nAgen   := ""
       Local nCntCor := ""
       Local nI      := 0
       /*
       - Posicoes fixas padrao Banco Central
       Posicao  Tam       Descricao
       01 a 03   03   Codigo de Compensacao do Banco (237)
       04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
       05 a 05   01   Digito verificador do codigo de barras
       06 a 19   14   Valor Nominal do Documento sem ponto
       - Campo Livre Padrao Bradesco
       Posicao  Tam       Descricao
       20 a 23   03   Agencia Cedente sem digito verificador
       24 a 25   02   Carteira
       25 A 36   11   Nosso Numero sem digito verificador
       37 A 43   07   Conta Cedente sem digiro verificador
       44 A 44   01   Zero
       */
       // Monta numero da Agencia sem dv e com 4 caracteres
       // Retira separador de digito se houver
       For nI := 1 To Len(aTitulos[nCont][05])
       	   If Subs(aTitulos[nCont][05],nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
		      nAgen += Subs(aTitulos[nCont][05],nI,1)
	       Endif
       Next nI
       // retira o digito verificador
       nAgen := Left(nAgen,4) //StrZero(Val(Subs(Alltrim(nAgen),1,Len(nAgen)-1)),4)
       // Monta numero da Conta Corrente sem dv e com 7 caracteres
       // Retira separador de digito se houver
       For nI := 1 To Len(aTitulos[nCont][16])
	       If Subs(aTitulos[nCont][16],nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
		      nCntCor += Subs(aTitulos[nCont][16],nI,1)
	       Endif
       Next nI
       // retira o digito verificador
       nCntCor := StrZero(Val(Subs(Alltrim(nCntCor),1,Len(nCntCor)-1)),7)
       cCampo := ""
       // Pos 01 a 03 - Identificacao do Banco
       cCampo += "237"
       // Pos 04 a 04 - Moeda
       cCampo += "9"
       // Pos 06 a 09 - Fator de vencimento
       cCampo += Str((aTitulos[nCont][02] - dFator),4)
       // Pos 10 a 19 - Valor
       cCampo += StrZero(Int(aTitulos[nCont][03]*100),10)
       // Pos 20 a 23 - Agencia
       cCampo += nAgen
       //Pos 24 a 25 - Carteira
       cCampo += aTitulos[nCont][07]
       // Pos 26 a 36 - Nosso Numero
       cCampo += Subs(aTitulos[nCont][04],1,11)
       // Pos 37 a 43 - Conta do Cedente
       cCampo += nCntCor
       // Pos 44 a 44 - Zero
       cCampo += "0"
       cDigitbar := CalcDig()
       // Monta codigo de barras com digito verificador
       cBarra := Subs(cCampo,1,4)+cDigitbar+Subs(cCampo,5,43)
Return()

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºFuncao    ³ CalcDig  º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Calculo do Digito Verificador Codigo de Barras - MOD(11)   º 
º          ³ Pesos (2 a 9)                                              º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static Function CalcDig()
       Local nCnt   := 0
       Local nPeso  := 2
       Local nJ     := 1
       Local nResto := 0
       For nJ := Len(cCampo) To 1 Step -1
	       nCnt:= nCnt + Val(SUBSTR(cCampo,nJ,1))*nPeso
	       nPeso :=nPeso+1
	       if nPeso > 9
		      nPeso := 2
	       endif
       Next nJ
       nResto:=(ncnt%11)
       nResto:=11 - nResto
       if nResto == 0 .or. nResto==1 .or. nResto > 9
	      nDigBar:='1'
          else
	        nDigBar:=Str(nResto,1)
       endif
Return(nDigBar)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» 
ºFuncao    ³ MtLinDig º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Monta da Linha Digitavel                                   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static FUNCTION MtLinDig()
       Local nI   := 1
       Local nAux := 0
       cLinha     := ""
       nDigito    := 0
       cCampo     := ""
       /*
       Primeiro Campo
       Posicao  Tam       Descricao
       01 a 03   03   Codigo de Compensacao do Banco (237)
       04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
       05 a 09   05   Pos 1 a 5 do campo Livre(Pos 1 a 4 Dig Agencia + Pos 1 Dig Carteira)
       10 a 10   01   Digito Auto Correcao (DAC) do primeiro campo
       Segundo Campo
       11 a 20   10   Pos 6 a 15 do campo Livre(Pos 2 Dig Carteira + Pos 1 a 9 Nosso Num)
       21 a 21   01   Digito Auto Correcao (DAC) do segundo campo
       Terceiro Campo
       22 a 31   10   Pos 16 a 25 do campo Livre(Pos 10 a 11 Nosso Num + Pos 1 a 8 Conta Corrente + "0")
       32 a 32   01   Digito Auto Correcao (DAC) do terceiro campo
       Quarto Campo
       33 a 33   01   Digito Verificador do codigo de barras
       Quinto Campo
       34 a 37   04   Fator de Vencimento
       38 a 47   10   Valor
       */
       // Calculo do Primeiro Campo
       cCampo := ""
       cCampo := Subs(cBarra,1,4)+Subs(cBarra,20,5)
       // Calculo do digito do Primeiro Campo
       CalDig1(2)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,4)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Segundo Campo
       cCampo := ""
       cCampo := Subs(cBarra,25,10)
       // Calculo do digito do Segundo Campo
       CalDig1(1)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,5)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Terceiro Campo
       cCampo := ""
       cCampo := Subs(cBarra,35,10)
       // Calculo do digito do Terceiro Campo
       CalDig1(1)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,5)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Quarto Campo
       cCampo := ""
       cCampo := Subs(cBarra,5,1)
       cLinha += cCampo
       // Insere espaco
       cLinha += " "
       // Calculo do Quinto Campo
       cCampo := ""
       cCampo := Subs(cBarra,6,4)+Subs(cBarra,10,10)
       cLinha += cCampo
Return(.T.)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» 
ºFuncao    ³ CISTF07E º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Calculo do Digito Verificador da Linha Digitavel - Mod(10) º 
º          ³ Pesos (1 e 2)                                              º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static Function CalDig1 (nCnt)
       Local nI   := 1
       Local nAux := 0
       Local nInt := 0
       nDigito    := 0
       For nI := 1 to Len(cCampo)
	       nAux := Val(Substr(cCampo,nI,1)) * nCnt
	       If nAux >= 10
		      nAux:= (Val(Substr(Str(nAux,2),1,1))+Val(Substr(Str(nAux,2),2,1)))
	       Endif
	       nCnt += 1
	       If nCnt > 2
		      nCnt := 1
	       Endif
	       nDigito += nAux
       Next nI
       If (nDigito%10) > 0
	      nInt    := Int(nDigito/10) + 1
          Else
	       nInt    := Int(nDigito/10)
       Endif
       nInt    := nInt * 10
       nDigito := nInt - nDigito
Return()


/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» 
ºFuncao    ³ Modulo11 º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Calculo do Digito Verificador da Linha Digitavel - Mod(10) º 
º          ³ Pesos (1 e 2)                                              º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static Function Modulo11(cData)
       LOCAL L, D, P := 0
       L := Len(cdata)
       D := 0
       P := 1
       While L > 0
	         P := P + 1
	         D := D + (Val(SubStr(cData, L, 1)) * P)
	         If P = 7
		        P := 1
	         End
	         L := L - 1
       End
       D := 11 - (mod(D,11))
       If (D == 1 .Or. D == 10 .Or. D == 11)
	      D := 1
       End
Return(Str(D,1))

Static Function NNumDV(NumBoleta)
   Local i
	Local nCont   := 0
	Local cPeso   := 2
	Local nBoleta := NumBoleta
	Local Resto   := 0
	Local nDVNum  := 0
		
	For i := 13 To 1 Step -1
			
		nCont := nCont + (Val(SUBSTR(nBoleta,i,1))) * cPeso
			
	   cPeso := cPeso + 1
			
		If cPeso == 8
			cPeso := 2
		Endif
			
	Next
		
	Resto := ( nCont % 11 )
		
	Do Case
		Case Resto == 1
			nDVNum := "P"
		Case Resto == 0
			nDVNum := "0"
		OtherWise
			Resto   := ( 11 - Resto )
			nDVNum := AllTrim(Str(Resto))
	EndCase
	
Return(nDVNum)



/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»  
ºFun‡„o    ³SetGlobal º Autor ³ Helio              º Data ³  02/07/09   º  
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹  
ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º   
º          ³ necessario (caso nao existam).                             º  
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹  
ºUso       ³ Programa principal                                         º  
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼  
/*/
Static Function SetGlobal()
       _cPerg        := "VRD301"
       _aRegs        := {}
       dbSelectArea("SX1")
       dbSetOrder(1)
       //-> Criando Array com Perguntas
       //          Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/X1_F3                                          
       aAdd(_aRegs,{_cPerg,"01","Da Nota            ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       aAdd(_aRegs,{_cPerg,"02","Ate a Nota         ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       aAdd(_aRegs,{_cPerg,"03","Serie              ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       aAdd(_aRegs,{_cPerg,"04","Codigo do Banco    ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
       aAdd(_aRegs,{_cPerg,"05","Agencia            ?","","","mv_ch5","C",05,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})       
       aAdd(_aRegs,{_cPerg,"06","Conta              ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       aAdd(_aRegs,{_cPerg,"07","Da    Parcela      ?","","","mv_ch7","C",01,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       aAdd(_aRegs,{_cPerg,"08","Ate a Parcela      ?","","","mv_ch8","C",01,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
       
       For i:= 1 to Len(_aRegs)
           If !dbSeek(_cPerg+_aRegs[i,2])
              RecLock("SX1",.T.)
              For j := 1 to FCount()
                  FieldPut(j,_aRegs[i,j])
              Next
             MsUnlock()
          Endif
       Next
Return
