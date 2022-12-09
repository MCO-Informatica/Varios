#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#Include "Protheus.ch"

User Function Mt100agr()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

Local oDlg
Local nX	:=	0
Local nTamSeq	:= 0						// Tamanho do campo de controle de sequencia

Private cProx := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CQUERY,")

// Ponto de Entrada para Ativar o Gatilho do SQL

DbSelectArea("SE1")
DbSetOrder(6)
DbSeek(xFilial("SE1")+DTOS(dDataBase))

Do while !eof() .and. E1_EMISSAO == dDataBase

   if (E1_TIPO <> '12 ')

      _cQuery := "Update SE1010 SET E1_NUMBCO=E1_NUMBCO Where E1_EMISSAO="+DTOS(dDataBase)+" and E1_TIPO='NCC' AND R_E_C_N_O_="+ALLTRIM(STR(RECNO()))

      TCSQLExec(_cQuery)

   endif

   DbSkip()

EndDo
if INCLUI
	cMens := OemToAnsi('Esta  rotina  vai duplicar os itens ')+chr(13)
	cMens := cMens+OemToAnsi('associados ao documento de entrada. ')+chr(13)
	cMens := cMens+OemToAnsi('Para gerar os registros atraves deste ')+chr(13)
	cMens := cMens+OemToAnsi('documento de entrada, sera necessario ')+chr(13)
	cMens := cMens+OemToAnsi('o valor total a ser distribuido.')+chr(13)
	cMens := cMens+OemToAnsi('Obs. Nao utilizar para os produtos QUIMICOS')+chr(13)
	If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
		nOpt := cValor := 0
	
		DEFINE MSDIALOG oDlg FROM	01,300 TO 20,400 TITLE OemToAnsi("Nota Complementar") // PIXEL OF GetWndDefault()
		
		@ 11,5	SAY OemToAnsi("Valor Total") OF oDlg PIXEL 
		@ 11,60 MSGET cValor  picture "@E 999,999,999.99"  SIZE	46, 9 OF oDlg PIXEL
		
		DEFINE SBUTTON FROM 02,246 TYPE 1 ACTION (nOpt := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 16,246 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpt == 1
			if cValor == 0
				Return
			endif
//	        cProx := 1
			if len(aCols) > 0 // aColsD1
		        wAcols := len(aCols)
		        cValor1 := cValor / wAcols
	
				For nX := 1 To Len (aCols)
	/*
					dbSelectArea("SX6")    
					IF dbSeek(xFilial("SX6")+"MV_DOCSEQ")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Obtem o proximo numero a partir do MV_DOCSEQ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cProx := Soma1(PadR(SuperGetMv("MV_DOCSEQ"),nTamSeq),,,.T.)
					ENDIF   
	*/				
	//				U_LjDocSeq()
	
					dbSelectArea("SD1")
					RecLock("SD1",.T.)
					SD1->D1_FILIAL	:= xFilial("SD1")
					SD1->D1_TES		:= ACOLS[nX][01]
					SD1->D1_COD		:= ACOLS[nX][02]
					SD1->D1_UM		:= ACOLS[nX][03]
					SD1->D1_VUNIT	:= cValor1
					SD1->D1_TOTAL	:= cValor1
					SD1->D1_CF		:= ACOLS[nX][11]
					SD1->D1_PICM	:= ACOLS[nX][14]
					SD1->D1_CC		:= ACOLS[nX][17]
					SD1->D1_FORNECE	:= cA100For
					SD1->D1_LOJA	:= cLoja
					SD1->D1_LOCAL	:= ACOLS[nX][22]
					SD1->D1_DOC		:= cNFiscal
					SD1->D1_EMISSAO	:= ACOLS[nX][24]
					SD1->D1_DTDIGIT	:= DDATABASE
					SD1->D1_TIPO	:= "C"
					If cSerie == '001'
						SD1->D1_SERIE	:= '12'
					ElseIf cSerie == '002'
						SD1->D1_SERIE	:= '21'
					ElseIf cSerie == '003'
						SD1->D1_SERIE	:= '33'
					Endif
					SD1->D1_CUSTO	:= cValor1
					SD1->D1_TP		:= ACOLS[nX][03]
					SD1->D1_NFORI	:= cNFiscal
					SD1->D1_SERIORI	:= cSerie
					SD1->D1_ITEMORI	:= ACOLS[nX][32]
					SD1->D1_ITEM	:= ACOLS[nX][32]
					SD1->D1_CLASFIS	:= "000"
					SD1->D1_RATEIO	:= "2"
					SD1->D1_STSERV	:= "1"
	//				SD1->D1_USERLGI	:= "1"
					SD1->D1_ALIQSOL	:= ACOLS[nX][15]
					SD1->D1_GARANTI	:= "N"
					SD1->D1_ALQPIS	:= ACOLS[nX][93]
					SD1->D1_ALQCOF	:= ACOLS[nX][96]
					SD1->D1_NUMSEQ	:= SD1->D1_NUMSEQ
					MsUnlock()
	/*
					dbSelectArea("SX6")    
					IF dbSeek(xFilial("SX6")+"MV_DOCSEQ")
					   RecLock("SX6",.F.)
					   SX6->X6_Conteud := cProx
					   MsUnlock()   
					ENDIF   
	*/
					dbSelectArea("SB1")
					dbsetorder(1)
					if msseek(xFilial() + SD1->D1_COD)
					   RecLock("SB1",.F.)
					   SB1->B1_UPRC:= cValor1
					   SB1->B1_UCOM:= DDATABASE
					   msunlock()
					endif  
					 
				Next (nX)
	
				dbSelectArea("SF1")
				RecLock("SF1",.T.)
				SF1->F1_FILIAL	:= xFilial("SF1")
				SF1->F1_DOC		:= cNFiscal
				If cSerie == '001'
					SF1->F1_SERIE	:= '12'
				ElseIf cSerie == '002'
					SF1->F1_SERIE	:= '21'
				ElseIf cSerie == '003'
					SF1->F1_SERIE	:= '33'
				Endif
				SF1->F1_FORNECE	:= cA100For
				SF1->F1_LOJA	:= cLoja
				SF1->F1_COND	:= cCondicao
				SF1->F1_DUPL	:= cNFiscal
				SF1->F1_EMISSAO	:= dDEmissao
				SF1->F1_EST		:= cUfOrig
				SF1->F1_VALMERC	:= cValor
				SF1->F1_VALBRUT	:= cValor
				SF1->F1_TIPO	:= "C"
				SF1->F1_DTDIGIT	:= DDATABASE
				SF1->F1_ESPECIE	:= cEspecie
				SF1->F1_EST		:= SF1->F1_EST
				SF1->F1_INCISS	:= SF1->F1_INCISS
				SF1->F1_ESTPRES	:= SF1->F1_ESTPRES
				SF1->F1_MOEDA	:= 1
				SF1->F1_PREFIXO	:= SF1->F1_SERIE
				SF1->F1_RECBMTO	:= dDatabase
				SF1->F1_STATUS	:= "A"
				SF1->F1_RECISS	:= "2"
				SF1->F1_NUMTRIB	:= "N"
	//			U_LjDocSeq()
				SF1->F1_MSIDENT	:= SF1->F1_MSIDENT
				SF1->F1_INCISS	:= SF1->F1_INCISS
				SF1->F1_ESTPRES := SF1->F1_ESTPRES
				MsUnlock()    
				
				dbSelectArea("SE2")
				dbsetorder(6)
				dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+cNFiscal)
				wPrefixo	:= SE2->E2_PREFIXO
				wNum		:= SE2->E2_NUM
				wRecno		:= recno()
				wNparc		:= 0
				While SE2->E2_PREFIXO == wPrefixo .and. SE2->E2_NUM == wNum .and. !Eof()
					wNparc	:= wNparc + 1
					dbskip()
				end
				cValor2 := cValor / wNparc
				dbSelectArea("SE2")
				dbGoTo(wRecno)
				While SE2->E2_PREFIXO == wPrefixo .and. SE2->E2_NUM == wNum .and. !Eof()

					cNUM		:= SE2->E2_NUM
					cPARCELA	:= SE2->E2_PARCELA
					cTIPO		:= SE2->E2_TIPO
					cNATUREZ	:= SE2->E2_NATUREZ
					cFORNECE	:= SE2->E2_FORNECE
					cLOJA		:= SE2->E2_LOJA
					cNOMFOR		:= SE2->E2_NOMFOR
					cEMISSAO	:= SE2->E2_EMISSAO
					cVENCTO		:= SE2->E2_VENCTO
					cVENCREA	:= SE2->E2_VENCREA
					cEMIS1		:= SE2->E2_EMIS1
					cLA			:= SE2->E2_LA
					cVENCORI	:= SE2->E2_VENCORI
					cMOEDA		:= SE2->E2_MOEDA
					cORIGEM		:= SE2->E2_ORIGEM
					cFILORIG	:= SE2->E2_FILORIG
					cMDRTISS	:= SE2->E2_MDRTISS
					cFRETISS	:= SE2->E2_FRETISS
					cAPLVLMN	:= SE2->E2_APLVLMN
					cPRETINS	:= SE2->E2_PRETINS
					cMSIDENT	:= SE2->E2_MSIDENT

					RecLock("SE2",.T.)
					SE2->E2_FILIAL	:= xFilial("SE2")
					If cSerie == '001'
						SE2->E2_PREFIXO	:= '12'
					ElseIf cSerie == '002'
						SE2->E2_PREFIXO	:= '21'
					ElseIf cSerie == '003'
						SE2->E2_PREFIXO	:= '33'
					Endif
					SE2->E2_NUM		:= cNUM
					SE2->E2_PARCELA	:= cPARCELA
					SE2->E2_TIPO	:= cTIPO
					SE2->E2_NATUREZ	:= cNATUREZ
					SE2->E2_FORNECE	:= cFORNECE
					SE2->E2_LOJA	:= cLOJA
					SE2->E2_NOMFOR	:= cNOMFOR
					SE2->E2_EMISSAO	:= cEMISSAO
					SE2->E2_VENCTO	:= cVENCTO
					SE2->E2_VENCREA	:= cVENCREA
					SE2->E2_VALOR	:= cValor2
					SE2->E2_EMIS1	:= cEMIS1
					SE2->E2_LA		:= cLA
					SE2->E2_SALDO	:= cValor2
					SE2->E2_VENCORI	:= cVENCORI
					SE2->E2_MOEDA	:= cMOEDA
					SE2->E2_VLCRUZ	:= cValor2
					SE2->E2_ORIGEM	:= cORIGEM
					SE2->E2_FILORIG	:= cFILORIG
					SE2->E2_MDRTISS	:= cMDRTISS
					SE2->E2_FRETISS	:= cFRETISS
					SE2->E2_APLVLMN	:= cAPLVLMN
					SE2->E2_PRETINS	:= cPRETINS
		//			U_LjDocSeq()
					SE2->E2_MSIDENT	:= cMSIDENT
					MsUnlock()
					dbSelectArea("SE2")
					dbGoTo(wRecno)
					dbSkip()
					wRecno		:= recno()
				End
			endif
		Endif
	
	EndIf	
Endif


Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjDocSeq  ºAutor  ³ Vendas Clientes    º Data ³ 09/11/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para verificar a integridade do numero sequencial de º±±
±±º          ³notas fiscais, armazenado no MV_DOCSEQ.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LjDocSeq()
Local aArea		:= GetArea()				// Armazena o posicionamento atual
Local aAlias	:= {"SD1","SD2","SD3"}		// Tabelas que utilizam controle de sequencia de documentos
Local aAreaTmp	:= {}						// Armazenamento temporario das areas utilizadas
Local cBusca	:= ""						// String para busca pelo ultimo sequencial
Local lRet		:= .T.						// Retorno da funcao
Local cMax		:= ""						// Maior documento encontrado entre as tabelas
Local cDoc		:= ""						// Maior documento encontrado para cada tabela
Local nX		:= 0						// Auxiliar de loop
Local nTamSeq	:= 0						// Tamanho do campo de controle de sequencia

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le o tamanho dos campos de sequencial e monta a string      ³
//³com este tamanho para busca pelo ultimo sequencial utilizado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamSeq	:= TamSx3("D3_NUMSEQ")[1]
cBusca := Replicate("z",nTamSeq)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le o maior numero sequencial existente entre os documentos³
//³de entrada (SD1), saida (SD2) e movimentacao de materiais ³
//³(SD3)                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aAlias)
	
	DbSelectArea(aAlias[nX])
	aAreaTmp := GetArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordem do DocSeq nas tabelas SD1, SD2 e SD3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSetOrder(4) 
	DbSeek(xFilial(aAlias[nX])+cBusca,.T.)
	DbSkip(-1)
	
	If &(PrefixoCPO(aAlias[nX]) + "_FILIAL") == xFilial(aAlias[nX])
		cDoc := &(PrefixoCPO(aAlias[nX]) + "_NUMSEQ")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena o maior sequencial entre as tres tabelas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cDoc > cMax
		cMax := cDoc
	EndIf
	
	RestArea(aAreaTmp)   
	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o proximo numero a partir do MV_DOCSEQ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cProx := Soma1(PadR(SuperGetMv("MV_DOCSEQ"),nTamSeq),,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o MV_DOCSEQ esta gravado corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cMax >= cProx
	lRet := .F.
	MsgStop("Problema no conteudo do parametro MV_DOCSEQ. O valor correto deveria ser: " + cMax + ". A Nota Complementar não poderá ser executada até sua correção." ,"MV_DOCSEQ")	//"Problema no conteudo do parametro MV_DOCSEQ. O valor correto deveria ser: "###". A venda assistida não poderá ser executada até sua correção."
EndIf

RestArea(aArea)

Return lRet

**** fim ***
