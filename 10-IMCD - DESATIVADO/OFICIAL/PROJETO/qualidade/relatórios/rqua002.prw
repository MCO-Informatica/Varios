#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"   
#INCLUDE "topconn.ch"  
#INCLUDE "AP5MAIL.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RQUA002  ³ Autor ³ Marcelo Pimentel      ³ Data ³ 08.04.98 ³±±
±±³          ³          ³ Adapt ³ Richard Nahas Cabral  ³ Data ³ 07.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Analise.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RQUA002(aDados)

	Private Perg     := "RQUA002"

	If Empty(aDados)

		If ! Pergunte(Perg,.T.)
			Return
		Endif

	EndIf	

	Processa( { || U_RQ2Proc(aDados) }, "Gerando Certificados de Análise..." )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RQ2Proc  ³ Autor ³ Richard Nahas Cabral  ³ Data ³ 11.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Analise.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQie                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RQ2Proc(aDados)

	Local aArea := GetArea()
	Local cEnsaio  :=""
	Local cChave   :=""
	Local cProduto := ""
	Local cRevi    :=""
	Local cFornec  :=""
	Local cLojFor  :=""
	Local dDat     :=Ctod("  /  /  ")
	Local cLote    :=""
	Local cLaborat :=""
	Local aTexto   :={}
	Local aTxtRes  :={}
	Local cVlrMin  :=" "
	Local cVlrMax  :=" "
	Local cVlrUni  :=" "
	Local nV       :=1
	Local nRec	   :=0
	Local nAmostra :=0
	Local nPorcent :=0
	Local lUnic    :=.T.
	Local lImpTxt  := .T.
	Local lMinFora := .F.
	Local cSeek    := ""
	Local cNiseri  := ""
	Local lNtEn    := .F.
	Local aEnsaios	:= {}
	Local aDadosPro	:= {}

	Default aDados := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para montar Get.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private Perg     := "RQUA002"
	Private lNFQEL  := IIF(QEL->(FieldPos('QEL_NISERI')) > 0,.t.,.f.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01           // Fornecedor                             ³
	//³ mv_par02           // Loja do Fornecedor                     ³
	//³ mv_par03           // Produto                                ³
	//³ mv_par04           // Data de Entrada                        ³
	//³ mv_par05           // Lote                                   ³
	//³ mv_par06           // Nota Fiscal                            ³
	//³ mv_par07           // Serie                                  ³
	//³ mv_par08           // Item          						 ³
	//³ mv_par09           // Impr. Ensaio Texto (Primeira/Todas)    ³
	//³ mv_par10           // Cliente	                             ³
	//³ mv_par11           // Loja do Cliente	                     ³
	//³---------- Somente vindo do PE - tirado do pergunte-----------³
	//³ mv_par12           // Nota Fiscal Saida                      ³
	//³ mv_par13           // Serie NF Saida                         ³
	//³ mv_par14           // Lote NF Saida                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(aDados)

		Pergunte(Perg,.F.)

	Else

		//Zerando as variaveis para impressão de dois itens na Nota de Saida
		mv_par06 := ""
		mv_par07 := ""
		mv_par08 := ""

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posições da array para geração do TXT     ³
		//³1 - Codigo do Fornecedor                  ³
		//³2 - Loja do Fornecedor                    ³
		//³3 - Nota Fiscal                           ³
		//³4 - Serie			                     ³
		//³5 - Item                                  ³
		//³6 - TipoNf                                ³
		//³7 - Cliente                               ³
		//³8 - Loja Cliente                          ³
		//³9 - Nota Fiscal Saida                     ³
		//³10 - Serie NF Saida	                     ³
		//³11 - Lote NF Saida	                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("QEK")
		dbSetOrder(11)
		If dbSeek(xFilial("QEK")+aDados[1]+aDados[2]+aDados[3]+aDados[4]+aDados[5]+aDados[6]+aDados[11])
			While QEK->(!EOF()) .AND. ALLTRIM(QEK->(xFilial("QEK")+QEK_FORNEC+QEK->QEK_LOJFOR+QEK_NTFISC+QEK_SERINF+QEK_ITEMNF+QEK_TIPONF+QEK_LOTE)) ==;
			ALLTRIM(xFilial("QEK")+aDados[1]+aDados[2]+aDados[3]+aDados[4]+aDados[5]+aDados[6]+aDados[11])

				If ALLTRIM(aDados[12]) == ALLTRIM(QEK->QEK_PRODUT)

					If !Empty(QEK->QEK_CERQUA)
						mv_par01 := QEK->QEK_FORNEC
						mv_par02 := QEK->QEK_LOJFOR
						mv_par03 := QEK->QEK_PRODUT
						mv_par04 := QEK->QEK_DTENTR
						mv_par05 := SUBSTR(QEK->QEK_LOTE,1,18) // ALTERADO EM 160916 POR SANDRA, INCLUIDO TAMANHO DO LOTE
						If lNFQEL
							mv_par06 := QEK->QEK_NTFISC
							mv_par07 := QEK->QEK_SERINF
							mv_par08 := QEK->QEK_ITEMNF
						Endif
					Else                                                                          
						MsgInfo("RQUA002-3 Não foram encontradas análises para este produto / lote !")
						Return(.F.)
					EndIF 
					Exit
				Else 
					If Empty(mv_par06)
						If !Empty(QEK->QEK_CERQUA)
							mv_par01 := QEK->QEK_FORNEC
							mv_par02 := QEK->QEK_LOJFOR
							mv_par03 := QEK->QEK_PRODUT
							mv_par04 := QEK->QEK_DTENTR
							mv_par05 := SUBSTR(QEK->QEK_LOTE,1,18) // ALTERADO EM 160916 POR SANDRA NISHIDA, INCLUIDO TAMANHO DO LOTE
							If lNFQEL
								mv_par06 := QEK->QEK_NTFISC
								mv_par07 := QEK->QEK_SERINF
								mv_par08 := QEK->QEK_ITEMNF
							Endif
						Else
							MsgInfo("RQUA002-4 Não foram encontradas análises para este produto / lote !")
							Return(.F.)
						EndIF
					EndIf
				EndIf
				QEK->(DbSkip())
			End
		Else
			MsgInfo("RQUA002-5 Não foram encontradas análises para este produto / lote !")
			Return(.F.)
		EndIF
		mv_par09 := 2
		mv_par10 := aDados[7]
		mv_par11 := aDados[8]  
		mv_par12 := aDados[9]
		mv_par13 := aDados[10]
		mv_par14 := aDados[11]

	EndIF

	If lNFQEL .And. !Empty(mv_par06)
		dbSelectArea("QEK")
		dbSetOrder(14)                                                      
		// ????? REVER ESTA PARTE, SE NAO EXISTE PARA QUE DO WHILE
		IF !(dbSeek(xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07))
			While !(Eof()) .and. xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07 ==;
			QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF

				If !lNtEn
					If DTOS(mv_par04) <> DTOS(QEK->QEK_DTENTR) .And. mv_par05 <> SUBSTR(QEK->QEK_LOTE,1,18) .And. mv_par08 <> QEK->QEK_ITEMNF
						lNtEn := .F.
					Else
						lNtEn := .T.
						Exit
					Endif
				Endif

				dbSelectArea("QEK")
				dbSkip()
			Enddo

			If !lNtEn
				MsgInfo("RQUA002-6 Não foram encontradas análises para este produto / lote !")
				dbSelectArea("QER")
				dbSetOrder(1)
				Return
			Endif
		Else
			While !(Eof()) .and. xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07 ==;
			QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF

				// ALTERADO POR SANDRA - O QEK_LOTE, SEGUNDO A TOTVS TEM Q TER O TAMANHO DO LOTE +SUBLOTE. AQUI NAO TEM SUBLOTE
				If DTOS(mv_par04) == DTOS(QEK->QEK_DTENTR) .And. mv_par05 == SUBSTR(QEK->QEK_LOTE,1,18) .And. mv_par08 == QEK->QEK_ITEMNF
					Exit
				Endif
				dbSelectArea("QEK")
				dbSkip()           
				// ALTERADO EM 20/05/2015 POR SANDRA 
				IF xFilial("QEK")+mv_par01+mv_par02+mv_par03+mv_par06+mv_par07 <> QEK->QEK_FILIAL+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_NTFISC+QEK->QEK_SERINF
					MsgInfo("RQUA002-1 Analise do produto da Nota Fiscal de Entrada nao encontrada no CQ(QEK).")	// "Entrada nao cadastrada."
					dbSelectArea("QER")
					dbSetOrder(1)
					Return
				Endif
			Enddo
		EndIf
	Else
		// consertar isto, pois se nao achou a nota na QEK pra que passar por  aqui??????
		dbSelectArea("QEK")
		dbSetOrder(1)
		IF !(dbSeek(xFilial("QEK")+mv_par01+mv_par02+mv_par03+Inverte(mv_par04)+;
		Inverte(mv_par05)))
			MsgInfo("RQUA002-2 Campo QEL_NISERI inexistente ou Analise do produto da Nota Fiscal de Entrada nao encontrada no CQ(QEK).")
			dbSelectArea("QER")
			dbSetOrder(1)
			Return
		EndIf
	EndIF

	cCond := 'QER_FILIAL == "'+xFilial("QER") +'"'
	cCond += '.And. QER_FORNEC=="'+mv_par01+'" .And.QER_LOJFOR=="'+mv_par02+'"'
	cCond += '.And.QER_PRODUT=="'+mv_par03+'"'
	cCond += '.And.DTOS(QER_DTENTR)=="'+DTOS(mv_par04)+'" .And.QER_LOTE=="'+PADR((mv_par05),24)+'"'

	cSeek := xFilial("QER")+mv_par03+QEK->QEK_REVI+mv_par01+mv_par02+DTOS(mv_par04)+mv_par05

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//VALIDAÇÃO DE EXISTENCIA DO FABRICANTE NA ENTRADA DO DOCUMENTO //
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cFabric := Posicione("SD1",1,xFilial("SD1")+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_ITEMNF,"D1_FABRIC")

	If Empty(cFabric)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
		cFornecedor := "Fabricante: "+SA2->A2_NOME
	else
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SD1->D1_FABRIC+SD1->D1_LOJFABR)
		cFornecedor := "Fabricante: "+SA2->A2_NOME
	Endif



	dDtFabB8 := Ctod("  /  /  ")
	dDtValB8 := Ctod("  /  /  ")

	dDtFabQEK := IIF(QEK->(FieldPos('QEK_DTFAB')) > 0,QEK->QEK_DTFAB,Ctod("  /  /  "))
	dDtValQEK := IIF(QEK->(FieldPos('QEK_DTVAL')) > 0,QEK->QEK_DTVAL,Ctod("  /  /  "))

	dbSelectArea("SB8")
	SB8->(DbSetOrder(5))
	SB8->(DbSeek(xFilial("SB8")+QEK->QEK_PRODUT+SUBSTR(QEK->QEK_LOTE,1,18)))

	Do While SB8->(B8_FILIAL + B8_PRODUTO + B8_LOTECTL) = xFilial("SB8")+QEK->QEK_PRODUT+SUBSTR(QEK->QEK_LOTE,1,18) .And. ! SB8->(Eof())
		If ! Empty(SB8->B8_DFABRIC) .And. ! Empty(SB8->B8_DTVALID)
			dDtFabB8 := SB8->B8_DFABRIC
			dDtValB8 := SB8->B8_DTVALID
		EndIf
		If SB8->B8_LOCAL = "01" .And. ! Empty(dDtFabB8) .And. ! Empty(dDtValB8)
			Exit
		Endif
		SB8->(DbSkip())
	EndDo

	dbSelectArea("QE6")
	dbSetOrder(1)
	dbSeek(xFilial("QE6")+QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI))

	SA1->(DbSeek(xFilial("SA1")+mv_par10+mv_par11))
	SB1->(DbSeek(xFilial("SB1")+QEK->QEK_PRODUT))
	SD1->(DbSeek(xFilial("SD1")+QEK->QEK_NTFISC+QEK->QEK_SERINF+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_ITEMNF))
	SA7->(DbSeek(xFilial("SA7")+mv_par10+mv_par11+QEK->QEK_PRODUT))

	cDescProd	:= AllTrim(QEK->QEK_PRODUT)+" - "+AllTrim(QE6->QE6_DESCPO)
	cDCB		:= If(! Empty(Alltrim(SB1->B1_DCB))	, "DCB: "+Alltrim(SB1->B1_DCB)		, "")
	cCAS		:= If(! Empty(Alltrim(SB1->B1_CASNUM))	, "CAS: "+Alltrim(SB1->B1_CASNUM)	, "")
	cLoteForn	:= QEK->QEK_LOTE
	cObsCa		:= ""
	// Observações adicionais farma solicitado por Rafael em 04/07/11, implementado by Daniel
	If SB1->B1_GRUPO $ GetMv("MV_GRUPOCA")
		cObsCa := AllTrim(GetMv("MV_OBSCA"))
	Endif

	//dDataFab	:= If(! Empty(dDtFabQEK),dDtFabQEK,If(! Empty(dDtFabB8),dDtFabB8,SD1->D1_DTFABRI))              
	//dDataVal	:= If(! Empty(dDtValQEK),dDtValQEK,If(! Empty(dDtValB8),dDtValB8,SD1->D1_DTVALID))

	// Alterado em 22/02/11 by Daniel - solicitado pegar as datas de fabricacao e validade PRIMEIRO do SB8 DEPOIS do QEK

	dDataFab	:= If(! Empty(dDtFabB8),dDtFabB8,If(! Empty(dDtFabQEK),dDtFabQEK,SD1->D1_DFABRIC))
	dDataVal	:= If(! Empty(dDtValB8),dDtValB8,If(! Empty(dDtValQEK),dDtValQEK,SD1->D1_DTVALID))

	// Pega lote fornecedor - solicitado por Rafael, implementado por Daniel em 19/09/11
	cLoteInt 	:= QEK->QEK_DOCENT

	cLoteNFS	:= If(Empty(aDados),MV_PAR05,MV_PAR14)

	cObservacoes	:= Alltrim(SA7->A7_OBSCA)
	cCodCliente		:= Alltrim(SA7->(A7_CODCLI+" "+A7_DESCCLI))
	aDocLaudoOri	:= {}
	cNFSaida		:= If(Empty(aDados),"",mv_par12+"/"+mv_par13)

	If ! (SA1->A1_NOMFABL == "1")
		cFornecedor := ""
	EndIf

	SAH->(dbSetOrder(1))
	SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chave de ligacao da medicao com outros arquivos              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cChave := QER->QER_CHAVE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a ImpressÆo dos Ensaios especificado com Encontrado           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("QER")
	DbSetOrder(1)
	dbGoTop()
	cSeek := ALLTRIM(cSeek)
	DbSeek(cSeek)

	While !Eof() .and. &cCond

		If lNFQEL .And. !Empty(mv_par06)  //ALTERADO LUIZ PARA PEGAR A SERIE DA ULTIMA POSIÇÃO DO CAMPO NISERI 
			If !(SubsTr(QER_NISERI,1,TamSX3("D1_DOC")[1]) == mv_par06 .And. ;
			SubsTr(QER_NISERI,TamSX3("D1_DOC")[1]+1,TamSX3("D1_SERIE")[1]) == mv_par07 .And. ;
			SubsTr(QER_NISERI,(TamSX3("D1_DOC")[1]+TamSX3("D1_SERIE")[1])+1,TamSX3("D1_ITEM")[1]) == mv_par08)

				QER->(dbSkip())
				Loop
			Endif
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca documentos anexos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If SA1->A1_LAUDOOR = "1" .Or. Empty(aDados)
			dbSelectArea("QF7")
			QF7->(dbSetOrder(1))
			QF7->(DbSeek(xFilial("QF7")+QER->QER_LABOR+QER->QER_ENSAIO+QER->QER_LOTE))

			Do While xFilial("QF7")+QER->QER_LABOR+QER->QER_ENSAIO+QER->QER_LOTE = QF7->(QF7_FILIAL+QF7_LABOR+QF7_ENSAIO+QF7_LOTE) .And. ! QF7->(Eof())
				Aadd(aDocLaudoOri,QF7->QF7_ANEXO)
				QF7->(DbSkip())
			EndDo
		EndIf

		dbSelectArea("QE1")
		dbSetOrder(1)
		If dbSeek(xFilial("QE1")+QER->QER_ENSAIO)
			Aadd(aEnsaios, Array(4))
			nPosEns := Len(aEnsaios)

			If QE1->QE1_CARTA <> "TXT"

				aEnsaios[nPosEns,1] := QE1->QE1_DESCPO

				dbSelectArea("QE7")
				dbSetOrder(1)
				If dbSeek(xFilial("QE7")+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)

					aEnsaios[nPosEns, 3] := Alltrim(QE7_METODO)

					SAH->(dbSeek(xFilial("SAH")+QE7->QE7_UNIMED))

					If QE7_MINMAX == "1"

						aEnsaios[nPosEns,2] := Alltrim(QE7_LIE) + " - " + Alltrim(QE7_LSE)

					ElseIf QE7_MINMAX == "2"
						aEnsaios[nPosEns,2] := "Mínimo " + Alltrim(QE7_LIE) // + " >"

					ElseIf QE7_MINMAX == "3"
						aEnsaios[nPosEns,2] := "Máximo " + Alltrim(QE7_LSE) // "< " + 

					EndIf
				EndIf
			Else
				aEnsaios[nPosEns,1] := QE1->QE1_DESCPO

				dbSelectArea("QE8")
				dbSetOrder(1)
				dbSeek(xFilial()+QER->QER_PRODUT+QER->QER_REVI+QER->QER_ENSAIO)
				aEnsaios[nPosEns, 3] := QE8_METODO
			EndIf

			cProduto := QER->QER_PRODUT
			cRevi	 := QER->QER_REVI
			cFornec	 := QER->QER_FORNEC
			cLojFor	 := QER->QER_LOJFOR
			dDat	 := QER->QER_DTENTR
			cLote	 := QER->QER_LOTE
			cLaborat := QER->QER_LABOR
			cEnsaio	 := QER->QER_ENSAIO
			qerArea := QER->(GETAREA())
			dbSelectArea("QER")
			QER->(dbSetOrder(1))
			cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE+QER_LABOR+QER_ENSAIO"
			cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+DTOS(dDat)+cLote+cLaborat+cEnsaio

			If lNFQEL
				QER->(dbSetOrder(5))
				cSeekQER    := "QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+QER_NISERI+QER_TIPONF+QER_LOTE+QER_LABOR+QER_ENSAIO"
				cNiseri := QER->QER_NISERI
				cTipNoF := QER->QER_TIPONF
				cCompQER    := xFilial('QER')+cProduto+cRevi+cFornec+cLojFor+cNiseri+cTipNoF+cLote+cLaborat+cEnsaio
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Definicao das vari veis para impressao da Cartas de Controle:     ³
			//³ XBR,XBS,XMR,IND,HIS,C,NP,U,P : cVlrMin,cVlrMax,cVlrUni            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lImpTxt:= .T.
			lMinFora := .F.
			While !Eof() .And. cCompQER == &cSeekQER

				cChave:= QER->QER_CHAVE

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Os tipos de cartas:XBR|XBS|XMR|IND|HIS - Se o param. for "Minimo/  ³
				//³Maximo"-ira considerar o menor e o maior valor. Se o param. for    ³
				//³"Valor Unico-Ser  o maior valor encontrado ou menor fora da espec. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS"
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							/*/
							cVlrMin:=If(SuperVal(QES_MEDICA)<SuperVal(cVlrMin) .Or. SuperVal(cVlrMin)==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)

							If SuperVal(cVlrMin) < SuperVal(QE7->QE7_LIE)
							cVlrUni := cVlrMin
							lMinFora:= .T.
							EndIf
							If !lMinFora
							If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
							cVlrUni := cVlrMax
							EndIf
							EndIf
							/*/
							cVlrUni := Alltrim(QES_MEDICA)
							dbSkip()
						EndDo
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O tipo de Carta:TMP (Tempo).						                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TMP"

					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMin:=If(QA_HTOM(QES_MEDICA)<QA_HTOM(cVlrMin) .Or. Val(QA_HTOM(cVlrMin))==0,QES_MEDICA,cVlrMin)
							cVlrMax:=If(QA_HTOM(QES_MEDICA)>QA_HTOM(cVlrMax),QES_MEDICA,cVlrMax)

							If QA_HTOM(cVlrMin) < QA_HTOM(QE7->QE7_LIE)
								cVlrUni := cVlrMin
								lMinFora:= .T.
							EndIf
							If !lMinFora
								If QA_HTOM(cVlrMax) > QA_HTOM(QE7->QE7_LSE) .Or. QA_HTOM(cVlrMax) > QA_HTOM(cVlrUni) .Or. Val(QA_HTOM(cVlrUni)) == 0
									cVlrUni := cVlrMax
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O tipo de Carta:TXT ir  o 1o. resultado encontrado.              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf QE1->QE1_CARTA == "TXT" .And. ;
				((Len(aTexto) == 0 .And. Len(aTxtRes) == 0) .Or. mv_par09 == 2)  // Imprime Todas Medicoes
                    aEnsaios[nPosEns,2] := ALLTRIM(QE8->QE8_TEXTO) 
					dbSelectArea("QEQ")
					dbSetOrder(1)
					dbSeek(xFilial()+cChave)
					aEnsaios[nPosEns,4] := ALLTRIM(QEQ_MEDICA)
                    /*
					If Len(aTexto) == 0
						aTexto := QJustTxt(QE8->QE8_TEXTO,40)
					EndIf

					If Len(aTxtRes) == 0
						dbSelectArea("QEQ")
						dbSetOrder(1)
						dbSeek(xFilial()+cChave)
						aTxtRes := QJustTxt(QEQ_MEDICA,25)
					EndIf

					nTot:= IIF(Len(aTexto)>Len(aTxtRes),Len(aTexto),Len(aTxtRes))

					For nC := 1 to nTot
						If lImpTxT
							If Len(aTexto) >= nC
								If	!Empty(aTexto[nC])
									aEnsaios[nPosEns,2] += Alltrim(aTexto[nC])
								EndIf
							EndIf
						EndIf
						If  Len(aTxtRes) >= nC
							If	!Empty(aTxtRes[nC])
								aEnsaios[nPosEns,4] := Alltrim(aTxtRes[nC])
							EndIf
						EndIf
					Next nC
					*/
					lImpTxt:= .F.
					aTxtRes:= {}

				ElseIf QE1->QE1_CARTA$"C  /NP "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Os tipos de carta : C / NP -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 1a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 1 medi‡Æo para cada data/hora.      ³
					//³Se param. for "Valor Unico" - Ser  o maior valor do QES.           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And.	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							cVlrMax := If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
							dbSkip()
						EndDo
						If SuperVal(cVlrMax) > SuperVal(QE7->QE7_LSE) .Or. SuperVal(cVlrMax) > SuperVal(cVlrUni) .Or. SuperVal(cVlrUni) == 0
							cVlrUni := cVlrMax
						EndIf
					EndIf

				ElseIf AllTrim(QE1->QE1_CARTA)=="U"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : U      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor da 2a. medicao do QES p/  ³
					//³cada data/hora. Sempre existem 2 regs. medi‡äes para cada data/hora³
					//³Se param. for "Valor Unico" - Ser  a 2a. medi‡Æo do QES para a 1a. ³
					//³data/hora.                                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave
							If nV == 2
								cVlrMax:=If(SuperVal(QES_MEDICA)>SuperVal(cVlrMax),QES_MEDICA,cVlrMax)
								nV:=0
								If lUnic
									cVlrUni := QES_MEDICA
									lUnic:= .F.
								EndIf
							EndIf
							nV++
							dbSkip()
						EndDo
					EndIf

				ElseIf AllTrim(QE1->QE1_CARTA)=="P"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O  tipo  de carta : P      -Se o param. for "Minimo/Maximo", o Mi- ³
					//³nimo ser  0, o M ximo ser  o maior valor de :                      ³
					//³Amostra * (Porcent./100)                                           ³
					//³Se param. for "Valor Unico" - Ser  o maior valor da Amostra:       ³
					//³Amostra * (Porcent./100)                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QES")
					dbSetOrder(1)
					If dbSeek(xFilial("QES")+cChave)
						While !Eof() .And. 	QES_FILIAL == xFilial("QES") .And. QES_CODMED == cChave

							If QES_INDMED == "A"
								nAmostra := SuperVal(QES_MEDICA)
							ElseIf QES_INDMED == "P"
								nPorcent := SuperVal(QES_MEDICA)
							EndIf
							If !Empty(nAmostra) .And. !Empty(nPorcent)
								cVlrMax:= If(nAmostra * (nPorcent / 100 )>SuperVal(cVlrMax),AllTrim(Str(nAmostra*(nPorcent/100))),cVlrMax)
								nAmostra:=0
								nPorcent:=0
								cVlrUni := IIF(ValType(cVlrMax)=="N",STR(cVlrMax),cVlrMax)
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
				dbSelectArea("QER")
				dbSkip()
				nRec:=Recno()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz impressÆo de todas as cartas                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QE1->QE1_CARTA$"XBR/XBS/XMR/IND/HIS/TMP"

				aEnsaios[nPosEns, 4] := AllTrim(cVlrUni)
			ElseIf AllTrim(QE1->QE1_CARTA)$"C/NP/U/P"
				aEnsaios[nPosEns, 4] := AllTrim(cVlrUni)
			EndIf

			If QE1->QE1_CARTA == "TXT"
				aTexto:={}
				aTxtRes:={}
			Else
				cVlrMin := " "
				cVlrMax := " "
				cVlrUni := " "
				lUnic   :=.T.
			EndIf

			dbSelectArea("QER")
			If nRec > 0
				RESTAREA(qerArea)
				QER->(dbSkip())
				//dbGoTo(nRec)
			Else
				QER->(dbSkip())
			Endif
		EndIf
	EndDo


	Aadd(aDadosPro,{cDescProd, cDCB, cCAS, cLoteForn, dDataFab, dDataVal, cFornecedor, cObservacoes, cCodCliente, aDocLaudoOri, cNFSaida, cLoteNFS, cObsca, cLoteInt})

	aEval(aEnsaios,{|x| If(Empty(x[3]),x[3]:="-",Nil)})

	U_RQUA003(aEnsaios, aDadosPro)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a Integridade dos dados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QER")
	Set Filter To
	RetIndex("QER")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura area                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSXB ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 25.04.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Ajusta SXB - Consulta Padrao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIER050                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSXB()

	Local aArea	:= GetArea()
	Local nI	:= 0
	Local aQL4	:= {}

	dbSelectArea("SXB")
	dbSetOrder(1)
	If dbSeek("QEK2  502") .And. Alltrim(Upper(SXB->XB_CONTEM)) <> "QEK->QEK_SERINF"
		RecLock("SXB",.F.)
		SXB->XB_CONTEM := "QEK->QEK_SERINF"
		MsUnlock()
	Endif

	AADD(aQL4,{"QL4","1","01","DB","Entregas"			,"Entregas"				,"Deliveries"			,"QEK"				})
	AADD(aQL4,{"QL4","2","01","01","FornecLojaProduto"	,"ProvTiendaProducto"	,"Suppl.StoreProduct"	,""					})
	AADD(aQL4,{"QL4","2","02","06","Lote"				,"Lote"					,"Lot"					,""					})
	AADD(aQL4,{"QL4","4","01","01","Fornecedor"			,"Proveedor"			,"Supplier"				,"QEK->QEK_FORNEC"	})
	AADD(aQL4,{"QL4","4","01","02","Fornecedor"			,"Loja"					,"Tienda"				,"QEK->QEK_LOJFOR"	})
	AADD(aQL4,{"QL4","4","01","03","Produto"			,"Producto"				,"Product"				,"QEK->QEK_PRODUT"	})
	AADD(aQL4,{"QL4","4","01","04","Lote"				,"Lote"					,"Lot"					,"QEK->QEK_LOTE"	})
	AADD(aQL4,{"QL4","4","01","05","Data de Entrada"	,"Fecha de Entrada"		,"Invoice"				,"QEK->QEK_DTENTR"	})
	AADD(aQL4,{"QL4","4","01","06","Nota Fiscal"		,"Factura"				,"Inflow Date"			,"QEK->QEK_NTFISC"	})
	AADD(aQL4,{"QL4","4","01","07","Serie"				,"Serie"				,"Series"				,"QEK->QEK_SERINF"	})
	AADD(aQL4,{"QL4","4","01","08","Item"				,"Item"					,"Item"					,"QEK->QEK_ITEMNF"	})
	AADD(aQL4,{"QL4","4","02","01","Lote"				,"Lote"					,"Lot"					,"QEK->QEK_LOTE"	})
	AADD(aQL4,{"QL4","4","02","02","Fornecedor"			,"Proveedor"			,"Supplier"				,"QEK->QEK_FORNEC"	})
	AADD(aQL4,{"QL4","4","02","03","Loja"				,"Tienda"				,"Store"				,"QEK->QEK_LOJFOR"	})
	AADD(aQL4,{"QL4","4","02","04","Produto"			,"Producto"				,"Product"				,"QEK->QEK_PRODUT"	})
	AADD(aQL4,{"QL4","4","02","05","Data de Entrega"	,"Fecha de Entrada"		,"Inflow Date"			,"QEK->QEK_DTENTR"	})
	AADD(aQL4,{"QL4","5","01",""  ,""					,""						,""						,"QEK->QEK_FORNEC"	})
	AADD(aQL4,{"QL4","5","02",""  ,""					,""						,""						,"QEK->QEK_LOJFOR"	})
	AADD(aQL4,{"QL4","5","03",""  ,""					,""						,""						,"QEK->QEK_PRODUT"	})
	AADD(aQL4,{"QL4","5","04",""  ,""					,""						,""						,"QEK->QEK_DTENTR"	})
	AADD(aQL4,{"QL4","5","05",""  ,""					,""						,""						,"QEK->QEK_LOTE"	})
	AADD(aQL4,{"QL4","5","06",""  ,""					,""						,""						,"QEK->QEK_NTFISC"	})
	AADD(aQL4,{"QL4","5","07",""  ,""					,""						,""						,"QEK->QEK_SERINF"	})
	AADD(aQL4,{"QL4","5","08",""  ,""					,""						,""						,"QEK->QEK_ITEMNF"	})

	For nI := 1 To Len(aQL4)
		If !dbSeek("QL4   "+aQL4[nI][2]+aQL4[nI][3]+aQL4[nI][4])
			RecLock("SXB",.T.)
		Else
			RecLock("SXB",.F.)
		Endif
		SXB->XB_ALIAS	:= aQL4[nI][1]
		SXB->XB_TIPO	:= aQL4[nI][2]
		SXB->XB_SEQ		:= aQL4[nI][3]
		SXB->XB_COLUNA	:= aQL4[nI][4]
		SXB->XB_DESCRI	:= aQL4[nI][5]
		SXB->XB_DESCSPA	:= aQL4[nI][6]
		SXB->XB_DESCENG	:= aQL4[nI][7]
		SXB->XB_CONTEM	:= aQL4[nI][8]
		MsUnlock()
	Next

	RestArea( aArea )

Return Nil
