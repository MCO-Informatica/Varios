#include "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "XMLXFUN.CH" 
#INCLUDE "mata140.ch"

#DEFINE IMP_PDF 6
#DEFINE VALMERC	 01	// Valor total do mercadoria
#DEFINE VALDESC	 02	// Valor total do desconto
#DEFINE TOTPED	 03	// Total do Pedido
#DEFINE FRETE    04	// Valor total do Frete
#DEFINE VALDESP  05	// Valor total da despesa
#DEFINE SEGURO	 07	// Valor total do seguro

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HFXML020  ºAutor  ³Eneovaldo Roveri Jr º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotinas Complementares HFXML02                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HFXML02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HFXMLPED ºAutor  ³Eneovaldo Roveri Jr º Data ³  06/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar aItens a partir do pedido e confrontar valores totaisº±±
±±º          ³ com o XML.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HFXML02                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HFXMLPED(xCod,xLoj,xTip)
Local aArea   := GetArea()
Local lRet    := .T.
Local aHeadSEV:= {}
Local aColsSEV:= {}
Private cA100For := xCod
Private cLoja    := xLoj
Private cTipo    := xTip
Private lConsLoja:= .T.
Private aCols    := {}
Private aHeader  := {}
Private N        := 1
PRIVATE lVldHead := GetNewPar( "MV_VLDHEAD",.F. )// O parametro MV_VLDHEAD e' usado para validar ou nao o aCols (uma linha ou todo), a partir das validacoes do aHeader -> VldHead()

lRet := U_AMAPC(,,,,,aHeadSEV,aColsSEV)

RestArea(aArea)
Return(lRet)

User Function AMAPC(aGets,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV)
Local lRet       := .T.
Local nSldPed    := 0
Local nOpc       := 0
Local nx         := 0
Local cQuery     := ""
Local cAliasSC7  := "SC7"
Local lQuery     := .F.
Local bSavSetKey := SetKey(VK_F4,Nil)
Local bSavKeyF5  := SetKey(VK_F5,Nil)
Local bSavKeyF6  := SetKey(VK_F6,Nil)
Local bSavKeyF7  := SetKey(VK_F7,Nil)
Local bSavKeyF8  := SetKey(VK_F8,Nil)
Local bSavKeyF9  := SetKey(VK_F9,Nil)
Local bSavKeyF10 := SetKey(VK_F10,Nil)
Local bSavKeyF11 := SetKey(VK_F11,Nil)
Local cChave     := ""
Local cCadastro  := ""
Local aArea      := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSC7   := SC7->(GetArea())
Local nF4For     := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons   := { {'PESQUISA',{||U_H20VisuPC(aRecSC7[oListBox:nAt])},OemToAnsi("Visualiza Pedido")} } //"Visualiza Pedido"
Local oDlg,oListBox
Local cNomeFor   := ''
Local aTitCampos := {}
Local aConteudos := {}
Local aUsCont    := {}
Local aUsTitu    := {}
Local bLine      := { || .T. }
Local cLine      := ""
Local lMa103F4I  := ExistBlock( "MA103F4I" )
Local nLoop      := 0
Local lMt103Vpc  := ExistBlock("MT103VPC")
Local lRet103Vpc := .T.
Local lContinua  := .T.
Local oPanel
Local nNumCampos := 0
Local nPosCC     := 0 //aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"})         //HF
Local nPosPRD	 := 0 //aScan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})        //HF

PRIVATE aF4For     := {}
PRIVATE aRecSC7    := {}

DEFAULT aGets      := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}

If lContinua

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o aCols esta vazio, se o Tipo da Nota e'     ³
		//³ normal e se a rotina foi disparada pelo campo correto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "N"
			DbSelectArea("SA2")
			DbSetOrder(1)
			MsSeek(xFilial("SA2")+cA100For+cLoja)
			cNomeFor	:= SA2->A2_NOME

			#IFDEF TOP
				DbSelectArea("SC7")
				If TcSrvType() <> "AS/400"
					SC7->( DbSetOrder( 9 ) ) 				
					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery := "SELECT R_E_C_N_O_ RECSC7 FROM "
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "
					If HasTemplate( "DRO" ) .AND. FunName() == "MATA103" .AND. MV_PAR15 == 1
						cQuery += "C7_FORNECE IN ( " + T_DrogForn( cA100For ) + " ) AND "
					Else
					cQuery += "C7_FORNECE = '"+cA100For+"' AND "		    		
					EndIf
					cQuery += "(C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "
					cQuery += "C7_RESIDUO=' ' AND "
					cQuery += "C7_TPOP<>'P' AND "

					If SuperGetMV("MV_RESTNFE")=="S"
						cQuery += "C7_CONAPRO<>'B' AND "
					EndIf 										

					If ( lConsLoja )		    		
						cQuery += "C7_LOJA = '"+cLoja+"' AND "		    							
					Endif		

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os pedidos de compras de acordo com os contratos             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If lConsMedic

						If lNfMedic

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos oriundos de medicoes                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		

						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos que nao possuem medicoes                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		

						EndIf

					EndIf 					

					if nAmarris == 2
						if .not. empty( cPedidis )
							cQuery += "SC7.C7_NUM in ("+cPedidis+") AND "
						else
							cQuery += "SC7.C7_NUM = '"+cPedidis+"' AND "  //Alterei aqui
						endif
					endif
					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY " + SqlOrder( SC7->( IndexKey() ) )

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
				Else
			#ENDIF
				DbSelectArea("SC7")
				DbSetOrder(9)
				If ( lConsLoja )
					cChave := cA100For+CLOJA
				Else
					cChave := cA100For
				EndIf
				MsSeek(xFilEnt(xFilial("SC7"))+cChave,.T.)
				#IFDEF TOP
				Endif
				#ENDIF
			Do While If(lQuery, ;
					(cAliasSC7)->(!Eof()), ;
					(cAliasSC7)->(!Eof()) .And. xFilEnt(xFilial('SC7'))+cA100For==(cAliasSC7)->C7_FILENT+(cAliasSC7)->C7_FORNECE .And. If(lConsLoja, CLOJA==(cAliasSC7)->C7_LOJA, .T.))

				If lQuery
					('SC7')->(dbGoto((cAliasSC7)->RECSC7))
				EndIf

				lRet103Vpc := .T.

				If lMt103Vpc
					lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
				Endif

				If lRet103Vpc
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o Saldo do Pedido de Compra                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSldPed := ('SC7')->C7_QUANT-('SC7')->C7_QUJE-('SC7')->C7_QTDACLA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se nao h  residuos, se possui saldo em abto e   ³
					//³ se esta liberado por alcadas se houver controle.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( Empty(('SC7')->C7_RESIDUO) .And. nSldPed > 0 .And.;
							If(SuperGetMV("MV_RESTNFE")=="S",('SC7')->C7_CONAPRO <> "B",.T.).And.;
							('SC7')->C7_TPOP <> "P" )

						If lConsMedic .And. lNfMedic
							nF4For := aScan(aF4For,{|x|x[5]==('SC7')->C7_LOJA .And. x[6]==('SC7')->C7_NUM})							
						Else							
							nF4For := aScan(aF4For,{|x|x[2]==('SC7')->C7_LOJA .And. x[3]==('SC7')->C7_NUM})
						EndIf 							

						If ( nF4For == 0 )

							If lConsMedic .And. lNfMedic
								aConteudos := {iif(nAmarris == 2,.T.,.F.),('SC7')->C7_MEDICAO,('SC7')->C7_CONTRA,('SC7')->C7_PLANILHA,('SC7')->C7_LOJA,('SC7')->C7_NUM,DTOC(('SC7')->C7_EMISSAO),If(('SC7')->C7_TIPO==2,'AE', 'PC') }
							Else
								aConteudos := {iif(nAmarris == 2,.T.,.F.),('SC7')->C7_LOJA,('SC7')->C7_NUM,DTOC(('SC7')->C7_EMISSAO),If(('SC7')->C7_TIPO==2,'AE', 'PC') }
							EndIf 															

							If lMa103F4I
								If ValType( aUsCont := ExecBlock( "MA103F4I", .F., .F. ) ) == "A"
									AEval( aUsCont, { |x| AAdd( aConteudos, x ) } )
								EndIf
							EndIf

							aAdd(aF4For , aConteudos )
							aAdd(aRecSC7, ('SC7')->(Recno()))
						EndIf
					EndIf
				Endif
				(cAliasSC7)->(dbSkip())
			EndDo

			If ExistBlock("MA103F4L")
				ExecBlock("MA103F4L", .F., .F., { aF4For, aRecSC7 } )
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os dados na Tela                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !Empty(aF4For) )

				If lConsMedic .And. lNfMedic
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Exibe os campos de medicao do contrato                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					aTitCampos := {" ",RetTitle("C7_MEDICAO"),RetTitle("C7_CONTRA"),RetTitle("C7_PLANILH"),OemToAnsi("Loja"),OemToAnsi("Pedido"),OemToAnsi("Emissao"),OemToAnsi("Origem")} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
					cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
				Else

					aTitCampos := {" ",OemToAnsi("Loja"),OemToAnsi("Pedido"),OemToAnsi("Emissao"),OemToAnsi("Origem")} //"Loja"###"Pedido"###"Emissao"###"Origem"

					cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5]"

				EndIf 					

				If ExistBlock( "MA103F4H" )
					If ValType( aUsTitu := ExecBlock( "MA103F4H", .F., .F. ) ) == "A"
						nNumCampos := Len(aTitCampos)
						For nLoop := 1 To Len( aUsTitu )
							AAdd( aTitCampos, aUsTitu[ nLoop ] )
							cLine += ",aF4For[oListBox:nAT][" + AllTrim( Str( nLoop + nNumCampos ) ) + "]"
						Next nLoop
					EndIf
				EndIf

				cLine += " } "

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta dinamicamente o bline do CodeBlock                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				bLine := &( "{ || " + cLine + " }" )

				if nAmarris == 1
					DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi("Selecionar Pedido de Compra - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

					@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
					oPanel:Align := CONTROL_ALIGN_TOP

					oListBox := TWBrowse():New( 27,4,243,86,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oListBox:SetArray(aF4For)
					oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
					oListBox:bLine := bLine

					oListBox:Align := CONTROL_ALIGN_ALLCLIENT

					@ 6  ,4   SAY OemToAnsi("Fornecedor") Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
					@ 4  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oPanel PIXEL SIZE 120,9

					ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)
				Else
					nOpc := 1
				Endif
				If nOpc == 1
					Processa({|| U_aXMLprPC(aF4For,nOpc,cA100For,cLoja,@lRet103Vpc,@lMt103Vpc,@nSldPed,.F.,aGets,( lConsMedic .And. lNfMedic ),aHeadSDE,@aColsSDE,aHeadSEV, aColsSEV)})
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			Else
				//Help(" ",1,"A103F4")
				U_MYAVISO("A103F4","Não existem pedidos relacionados com este fornecedor",{"Ok"},2)
				lRet := .F.
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integrida dos dados de Entrada                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	DbSelectArea(cAliasSC7)
	dbCloseArea()
	DbSelectArea("SC7")
Endif
SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)

RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aArea)
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ProcPC| Autor ³ Alex Lemes            ³ Data ³09/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o carregamento do pedido de compras para a NFE    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os itens do pedido de compras            ³±±
±±³          ³ ExpN1 = Opcao valida                                       ³±±
±±³          ³ ExpC1 = Fornecedor                                         ³±±
±±³          ³ ExpC2 = loja fornecedor                                    ³±±
±±³          ³ ExpL1 = retorno do ponto de entrada                        ³±±
±±³          ³ ExpL2 = Uso do ponto de entrada                            ³±±
±±³          ³ ExpN2 = Saldo do pedido                                    ³±±
±±³          ³ ExpL3 = Usa funcao fiscal                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function aXMLprPC(aF4For,nOpc,cA100For,cLoja,lRet103Vpc,lMt103Vpc,nSldPed,lUsaFiscal,aGets,lNfMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV)
Local nx         := 0
Local cSeek      := ""
Local cFilialOri :=""
Local cItem		 := StrZero(1,Len(SD1->D1_ITEM))
Local lZeraCols  := .T.
Local aRateio    := {0,0,0} 
Local aMT103NPC  := {}
Local aColsBkp   := Aclone(Acols)
Local cPrdNCad   := ""
Local nSavNF  	 := MaFisSave()
Local aRatFin	 := {}
Local lPrjCni    := FindFunction("ValidaCNI") .And. ValidaCNI()
Local nPosIpi    := 0       //HF
Private l103Auto   := .F.

DEFAULT lUsaFiscal := .F.
DEFAULT aGets      := {}
DEFAULT lNfMedic   := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}

If ( nOpc == 1 )
	If lPrjCni
   		U_COMA120(@aF4For,lNfMedic,lUsaFiscal)	   
	EndIf   
	For nx	:= 1 to Len(aF4For)
		If aF4For[nx][1]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Fornecedor                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SA2")
			DbSetOrder(1)
			MsSeek(xFilial("SA2")+cA100For+cLoja)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Pedido de Compra                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SC7")
			DbSetOrder(9)
			cSeek := ""
			cSeek += xFilEnt(xFilial("SC7"))+cA100For
			cSeek += If( lNfMedic, aF4For[nx,5]+aF4For[nx,6], aF4For[nx][2]+aF4For[nx][3] )
			MsSeek(cSeek)
			If lZeraCols
				aCols		:= {}
				lZeraCols	:= .F.
				MaFisClear()
			EndIf

			// Muda ordem para trazer ordenado por item
			If !Eof()
				cSeek      :=xFilEnt(xFilial("SC7")) + If( lNfMedic, aF4For[nx,6], aF4For[nx][3] )
				cFilialOri :=C7_FILIAL
				DbSetOrder(14)
				dbSeek(cSeek)
			EndIf
			
			While ( !Eof() .And. SC7->C7_FILENT+SC7->C7_NUM==cSeek )
				// Verifica se o fornecedor esta correto
				If C7_FILIAL+C7_FORNECE+C7_LOJA == cFilialOri+cA100For+ If( lNfMedic, aF4For[nx,5], aF4For[nx][2] )
				    // Verifica se o Produto existe Cadastrado na Filial de Entrada
				    DbSelectArea("SB1")
					DbSetOrder(1)
					MsSeek(xFilial("SB1") + SC7->C7_PRODUTO)
					IF !Eof()
					    DbSelectArea("SC7")
						lRet103Vpc := .T.
						If lMt103Vpc
							lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
						Endif
						If lRet103Vpc
							nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
							If (nSldPed > 0 .And. Empty(SC7->C7_RESIDUO) )
								if nAmarris == 2
									NfePC2Acol(SC7->(RecNo()),,nSlDPed,cItem,,@aRateio,aHeadSDE,@aColsSDE)
									If SC7->C7_VALIPI > 0
										nPosIpi := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALIPI"})         //HF
										if nPosIpi > 0
											aCols[Len(aCols)][nPosIpi] := SC7->C7_VALIPI
										endif
									EndIf
								else
									aLinha := {}
									aadd(aLinha,{"D1_ITEM"  ,cItem				             ,Nil})
									aadd(aLinha,{"D1_COD"   ,SC7->C7_PRODUTO           		 ,Nil})
									aadd(aLinha,{"D1_QUANT" ,nSlDPed						 ,Nil})
									aadd(aLinha,{"D1_VUNIT" ,SC7->C7_PRECO					 ,Nil})
									aadd(aLinha,{"D1_TOTAL" ,SC7->C7_TOTAL					 ,Nil})
									aadd(aLinha,{"D1_PEDIDO",SC7->C7_NUM					 ,Nil})
									aadd(aLinha,{"D1_ITEMPC",SC7->C7_ITEM					 ,Nil})
									aadd(aLinha,{"D1_IPI"   ,SC7->C7_IPI					 ,Nil})
									aadd(aLinha,{"D1_VALIPI",SC7->C7_VALIPI					 ,Nil})
						 			aadd(aItens,aLinha)
						 			if Empty(cPedidis) .or. ! (SC7->C7_NUM $ cPedidis)
						 				cPedidis += iif(! Empty(cPedidis),",","" )+"'"+SC7->C7_NUM+"'"
						 			endif
						 		endif
								cItem := SomaIt(cItem)
							EndIf
						Endif
					Else
					   cPrdNCad += "Pedido"+": "+SC7->C7_NUM+"  "+"Produto"+": "+SC7->C7_PRODUTO+CHR(10)
			   		EndIf
				EndIf    
				
				If lPrjCni       
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Controle do Rateio Financeiro                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SC7->C7_RATFIN == "1"
						cChaveRat := "SC7"+SC7->C7_FILIAL+SC7->C7_NUM
						F641TrfRat(cChaveRat,@aRatFin,SC7->C7_TOTAL)
			   		EndIf
				EndIf

				DbSelectArea("SC7")         
				dbSkip()             
			EndDo
		EndIf
	Next   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe Lista dos Produtos não Cadastrados na Filial de Entrega |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if Len(cPrdNCad)>0 .And. !l103Auto
	   Aviso("A103ProcPC","Produtos não Cadastrados na Filial de Entrega"+CHR(10)+cPrdNCad,{"Ok"})
	EndIf
         
	If lPrjCni
		//Grava rateio financeiro
		If Len(aRatFin) > 0
			cChaveRat := "SF1"+xFilial("SF1")+cTipo+cNFiscal+cSerie+cA100For+cLoja
			F641GrvRat(cChaveRat,aRatFin)
			aRatFin := {}
		EndIf
	EndIf
         
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura o Acols caso o mesmo estiver vazio |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(Acols)=0
	    aCols:= aColsBKP
	    MaFisRestore(nSavNF)
	EndIf
         
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para manipular o array de multiplas naturezas por titulo no Pedido de Compras .  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistBlock("MT103NPC"))
		aMT103NPC := ExecBlock("MT103NPC",.F.,.F.,{aHeadSEV,aColsSEV})
	 	If (ValType(aMT103NPC) == "A")
	   		aColsSEV := aClone(aMT103NPC)
		EndIf
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type( "oGetDados" ) == "O" 	
		oGetDados:lNewLine:=.F.  
		oGetDados:oBrowse:Refresh()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rateio do valores de Frete/Seguro/Despesa do PC            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nAmarris == 2
		aGets[SEGURO] := aRateio[1]
		aGets[VALDESP]:= aRateio[2]
		aGets[FRETE]  := aRateio[3]
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_HFXMLCPS| Autor ³ Eneovaldo Roveri Jr.  ³ Data ³25/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para Comparar XML recebido com a SEFAZ.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HFXML02                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HFXMLCPS(cFileCfg,cXml,cOcorr,lInvalid,cModelo )
Local nRet    := 0
Local aTag    := {}
Local aErr    := {}
Local cTags   := ""
Local cChave  := ""
Local cXmlSef := ""
Private oXml, oXmlSef

If nRet >= 0
	nRet := HFLerTags( cFileCfg, @aTag )
Endif

If nRet >= 0
	cChave := HFChaveXml( cXml )
	If EMpty( cChave )
		nRet := -2
	Endif
EndIf

//Baixar o XML da SEFAZ
If nRet >= 0
	nRet := HFBXXml( cChave, @cXmlSef )
	if nRet == -4
		nRet := HFMFXml( cChave, "210210" )
		if nRet >= 0
			nRet := HFBXXml( cChave, @cXmlSef )
		endif
	endif
Endif

//For em aTag para comparar as TAGs
If nRet >= 0
	nRet := HFCompTag( aTag, @aErr, cXml, cXmlSef )
	If nRet == 1 .or. nRet == 3
		cXml := cXmlSef
		cMsgTag := "["+cCHave+"] Assumido XML da SEFAZ. XML do fornecedor mau formado ou protocolo inválido."+CRLF
		if lInvalid
			lInvalid := .F.
		Endif
		if .Not. Empty( cOcorr )
			cOcorr := ""
		EndIf
	Endif
Endif

//Adicionar Mensagens e envio de e-mail
If nRet > 0
	HFTagEmail( aTag, aErr, cChave, nRet )
Endif

Return nRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ler Arquivo de TAGs e montar matriz aTag com as TAGs que deverão ser Comparadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function HFLerTags( cFileCfg, aTag )
Local nHandle  := 0
Local nRet     := 0
Local cBuf     := space(1200)
Local aBuf     := {}
Local nLin     := 0
Private cObj     := "oXml"
Private nObj     := 0

If .NOT. File(cFileCfg)  //isso não pode existir pois foi visto antes
	Return( -9 )
EndIf

nHandle := FT_FUse( cFileCfg )

if nHandle <= 0
	Return( -1 )
endif

FT_FGoTop()

While !FT_FEOF()   
   cBuf := FT_FReadLn() // Retorna a linha corrente
   cBuf := allTrim( cBuf )
   nLin++
   aBuf := Destrincha( cBuf, nLin )
   Aadd( aTag, aBuf )

   FT_FSKIP()
End

Return nRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Destrincha Linha do arquivo, com a TAG constante para adicionar em aTag.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Destrincha( cBuf, nLin )
Local aRet := {}
Local nI   := 0
Local cTag := ""
Local nPos1:= 0
Local nPos2:= 0
Local cLin := upper(cBuf)
Local cAcao:= "COMPARAR"
Local lTag := .T.

If Substr(cLin,1,2) == "{}"
	if "/" $ cLin
		aadd( aRet, cObj )
		nObj := nObj - 1
		cObj := "oDet["+AllTrim(Str(nObj))+"]"
		if nObj == 0
			cObj := "oXml"
		endif
		cAcao:= "DESTRUIR"
	Else
		aadd( aRet, cObj )
		nObj := nObj + 1
		cObj := "oDet["+AllTrim(Str(nObj))+"]"
		cAcao:= "CRIAR"
	EndIf
	cLin := StrTran(cLin,"{}","")
	cLin := StrTran(cLin,"/","")
Else
	aadd( aRet, cObj )
	cAcao:= "COMPARAR"
EndIf

Do While .T.
	if len(cLin) <= 1
		Exit
	endif
	nPos1 := AT("<",cLin )+1
	nPos2 := AT(">",cLin )-1
	if nPos2 > nPos1
		if "<" $ SubsTR(cLin,nPos1,(nPos2-1))
			cTag := "Erro TAG Linha "+AllTrim( Str(nLin) )
			lTag := .F.
			Exit
		else
			cTag := cTag + ":_" +SubsTR(cLin,nPos1,(nPos2-1))
		endif
	else
		cTag := "Erro TAG Linha "+AllTrim( Str(nLin) )
		lTag := .F.
		Exit
	endif
	cLin := SubsTR(cLin,nPos2+2,len(cLin))
EndDo

If lTag .And. cAcao == "COMPARAR"
	cTag := cTag + ":TEXT"
EndIf

aadd( aRet, lTag )
aadd( aRet, cTag )
aadd( aRet, cAcao )
aadd( aRet, cBuf )

Return( aRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a CHAVE do XML para poder fazer o Download da SEFAZ.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function HFChaveXml( cXml )
Local cError   := ""
Local cWarning := ""
Local nAt3     := 0
Local nAt4     := 0
Local cChaveXml:= ""
Private oXmlTeste, cTAG, cTagCHId, cTagKey

If "<CTE" $ Upper(cXml)
	cTAG := "CTE"
Else
	cTAG := "NFE"
EndIf

oXmlTeste := XmlParser( cXml, "_", @cError, @cWarning )

If Empty(cError) .And. Empty(cWarning) .And. oXmlTeste <> Nil

	cTagCHId  := "oXmlTeste:_"+cTAG+"PROC:_"+cTAG+":_INF"+cTAG+":_ID:TEXT"
	cTagKey   := "oXmlTeste:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_CH"+cTAG+":TEXT"

	If Empty( cChaveXml ) .Or. Len(cChaveXml) != 44
		If type(cTagKey) <> "U"
			cChaveXml := &(cTagKey)
		EndIf
	EndIf

	If Empty( cChaveXml ) .Or. Len(cChaveXml) != 44
		If type(cTagCHId) <> "U"
			cChaveXml := Substr(&(cTagCHId),4,44)
		EndIf
	EndIf

EndIf

If Empty( cChaveXml ) .Or. Len(cChaveXml) != 44
	nAt3:= At(Upper('<ch'+cTAG),Upper(cXml)) + 7
	nAt4:= At(Upper('</ch'+cTAG+'>'),Upper(cXml))
	If nAt3 > 7 .And. nAt4 > nAt3
		cChaveXml := Substr(cXml,nAt3,nAt4-nAt3)
	EndIf
EndIf

If Empty( cChaveXml ) .Or. Len(cChaveXml) != 44
	nAt3:= At(Upper('<inf'+cTAG+' Id="'),Upper(cXml)) + 15
	If nAt3 > 15
		cChaveXml := Substr(cXml,nAt3,44)
	EndIf
EndIF

If Len(cChaveXml) != 44
	cChaveXml := ""
EndIf

Return( cChaveXml )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Download da SEFAZ.                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function HFBXXml( cChave, cXmlSef )
Local nRet   := 0
Local nI     := 0
Local cURL   := ""
Local cAmb   := ""
Local cNfe   := ""
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local nHandle:= 0
Local lOk    := .T.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWs,oWsrNfe,oWsdNfe,cErro,cWarning

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1)
EndIf

cCnpj  := SM0->M0_CGC
cAmb   := "1"

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLDOWLOAD():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "AN"
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave

if oWSdNfe:HFBAIXAXML()
	cXmlSef := oWSdNfe:cHFBAIXAXMLRESULT
	nAt1:= At('<RETDOWNLOADNFE ',Upper(cXmlSef))
	nAt2:= At('</RETDOWNLOADNFE>',Upper(cXmlSef))+ 17
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETDOWNLOADNFE>',Upper(cXmlSef))
	EndIf
	If nAt1 > 0 .And. nAt2 > 17
		cNfe := Substr(cXmlSef,nAt1,nAt2-nAt1)

		cXmlSef:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXmlSef+= cNfe
		cXmlSef := NoAcento(cXmlSef)
		cXmlSef := EncodeUTF8(cXmlSef)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXmlSef, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			nRet   := -3
			cMsgTag += "(Download) Erro Parser do XML Resposta da Sefaz" + CRLF
		elseIf oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT <> "139"
			nRet   := -3
			cMsgTag += "(Download) Retorno do Sefaz "+oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT + CRLF
		Else
			oDet := oWSrNfe:_RETDOWNLOADNFE:_RETNFE
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				if oDet[nI]:_CSTAT:TEXT <> "140"
					if oDet[nI]:_CSTAT:TEXT == "633"
						nRet  := -4
					Else
						nRet  := -3
						cMsgTag += "(Download) "+oDet[nI]:_XMOTIVO:TEXT + "(" +oDet[nI]:_CSTAT:TEXT + ")" + CRLF
					EndIf
				else
					//cChave := cDir + alltrim( oDet[nI]:_CHNFE:TEXT ) + "-Sefaz.xml"
					oXmlSef := oDet[nI]:_PROCNFE:_NFEPROC

					SAVE oXmlSef XMLSTRING cXmlSef
					nAt1:= At('<NFE ',Upper(cXmlSef))
					nAt2:= At('</NFE>',Upper(cXmlSef))+ 6
					//Corpo da Nfe
					If nAt1 <=0
						nAt1:= At('<NFE>',Upper(cXmlSef))
					EndIf
					If nAt1 > 0 .And. nAt2 > 6
						cNfe := Substr(cXmlSef,nAt1,nAt2-nAt1)
					Else
						nRet  := -3
						cMsgTag += "(Download) XML "+oDet[nI]:_CHNFE:TEXT+" sem TAG <NFE>" + CRLF
					EndIf
					nAt3:= At('<PROTNFE ',Upper(cXmlSef))
					nAt4:= At('</PROTNFE>',Upper(cXmlSef))+ 10
					//Protocolo
					If nAt3 > 0 .And. nAt4 > 10
						cProt := Substr(cXmlSef,nAt3,nAt4-nAt3)
					Else
						nRet  := -3
						cMsgTag += "(Download) XML "+oDet[nI]:_CHNFE:TEXT+" sem Protocolo, falta TAG <PROTNFE>" + CRLF
					EndIf

					if nRet >= 0
						//cXml:= '<?xml version="1.0"?>'
						cXmlSef:= '<?xml version="1.0" encoding="UTF-8"?>'
						cXmlSef+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
						cXmlSef+= cNfe
						cXmlSef+= cProt
						cXmlSef+= '</nfeProc>'
						cXmlSef := NoAcento(cXmlSef)
						cXmlSef := EncodeUTF8(cXmlSef)
						oXmlSef := XmlParser( cXmlSef, "_", @cErro, @cWarning )

						if oXmlSef == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
							nRet  := -3
							cMsgTag += "(Download) Erro Parser do XML" + CRLF
						Else
							//SAVE oXmlSef XMLFILE cChave
							//nHandle := FT_FUse( cChave )
							//if nHandle == -1
							//	cStt  := "0"
							//	cMsg  := "Erro Gravação"
							//	cInfo := "Erro de Gravação XML no Diretório "+cChave
							//else
							//	cStt  := "1"
							//	cMsg  := "Download Efetuado"
							//	cInfo := "Download Efetuado do XML "+cChave
							//endif
							//FT_FUSE()
						EndIf
					Endif

				Endif
				Exit
			Next nI
		Endif
	Else
		nRet  := -3
		cMsgTag += "(Download) Erro de retorno do Sefaz. XML de retorno não contém a TAG <RETDOWNLOADNFE>" + CRLF
	EndIf	
else
	nRet  := -3
	cMsgTag += "(Download) Erro TSS ou WS" + CRLF
endif

Return( nRet )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Manifesta como Ciencia da Operação para o Download da SEFAZ.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function HFMFXml( cChave, cEve, cRej, cJus ) //GETESB2
Local nI     := 0
Local nRet   := 0
Local cEvent := cEve
Local nLote  := 1
Local nChv   := 0
Local cCnpj  := SM0->M0_CGC  //"61135471000100"
Local cURL   := ""
Local cXml   := ""
Local cNfe   := ""
Local cAmb   := "1"
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local lTemPr := .F.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWS,oWsrNfe,oWsdNfe,cErro,cWarning
Default cRej := ""
Default cJus := " " //GETESB2

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1)
EndIf

// Tratamento da numeracao do lote
nLote := ( GetNewPar("XM_LOTEMAN",0) + 1 )
If !PutMv("XM_LOTEMAN",nLote)
	SX6->(RecLock("SX6",.T.))
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "XM_LOTEMAN"
	SX6->X6_TIPO    := "N"
	SX6->X6_DESCRIC := "Lote do Evento de Manifestacao"
	SX6->(MsUnLock())
	PutMv("XM_LOTEMAN",nLote)
EndIf

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLMANIFESTO():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
oWsdNfe:cCLOTE        := strzero(nLote,15,0)
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "91"
oWSdNfe:cCHORAVERAO   := cHrVerao
oWSdNfe:cCHORARIO     := cHorario
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave
oWSdNfe:cCEVSTR       := cEvent
oWSdNfe:cCXJUST       := cJus  //GETESB2

if oWSdNfe:HFMANISFESTO()
	cXml := oWSdNfe:cHFMANISFESTORESULT
	nAt1:= At('<RETENVEVENTO ',Upper(cXml))
	nAt2:= At('</RETENVEVENTO>',Upper(cXml))+ 15
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETENVEVENTO>',Upper(cXml))
	EndIf
	If nAt1 > 0 .And. nAt2 > 15
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			nRet := -4
			cMsgTag += "(Manifestação) Erro Parser do XML" + CRLF
		elseIf oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT <> "128"
			nRet := -4
			cMsgTag += oWSrNfe:_RETENVEVENTO:_XMOTIVO:TEXT + "(" + oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT + ")" + CRLF
		Else
			oDet := oWSrNfe:_RETENVEVENTO:_RETEVENTO
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cMsg  := ""
				cInfo := ""
				cRej  := oDet[nI]:_INFEVENTO:_CSTAT:TEXT
				if oDet[nI]:_INFEVENTO:_CSTAT:TEXT <> "135"
					nRet := -4
					cMsgTag += cChave + " " +oDet[nI]:_INFEVENTO:_XMOTIVO:TEXT+ CRLF
				else
					nRet := 0
				Endif
			Next nI
		Endif
	Else
		nRet := -4
		cMsgTag += "(Manifestação) Erro de retorno do Sefaz. XML de retorno não contém a TAG <RETENVEVENTO>"+ CRLF
	EndIf
else
	//Erro TSS ou WS não instalado.
	nRet := -4
	cMsgTag += "(Manifestação) Erro TSS ou WS"+ CRLF
endif

Return( nRet )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Manifesta como Ciencia da Operação para o Download da SEFAZ.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function HFCompTag( aTag, aErr, cXml, xXmlSef )
Local nRet := 0
Local nI   := 0
Local nJ   := 0
Local nK   := 0
Local aDet := {}
Local cErro:= "", cWarning:=""

Private cTagAux1 := "", cValAux1 := ""
Private cTagAux2 := "", cValAux2 := ""
Private oDet     := {}, SefoDet  := {}, oDetAux, cTAG

If "<CTE" $ Upper(cXml)
	cTAG := "CTE"
Else
	cTAG := "NFE"
EndIf

oXml := XmlParser( cXml, "_", @cErro, @cWarning )
If oXml == NIL .or. .NOT. Empty(cErro)
	Aadd( aErr, {"oXml","XML Fornecedor Mau Formado","","" } )
	nRet := 1
Endif

if nRet == 0
	For nI := 1 to len( aTag )
		If aTag[nI][2]
			cTagAux1 := aTag[nI][1]+aTag[nI][3]
			cTagAux2 := iif(aTag[nI][1]=="oXml", "oXmlSef", "Sef"+aTag[nI][1] ) +aTag[nI][3]
			cValAux1 := "NULA"
			cValAux2 := "NULA"
			If aTag[nI][4] == "CRIAR"
				nJ++

				Do While Len( oDet ) < nJ
					aadd( oDet, NIL )
					aadd( SefoDet, NIL )
					aadd( aDet, .T. )
				EndDo

				If Type(cTagAux1) <> "U"
					oDetAux := &(cTagAux1)
					oDetAux := if(ValType(oDetAux)=="O",{oDetAux},oDetAux)
					oDet[nJ] := oDetAux
					cValAux1 := "DETALHE"
				Else
					aDet[nJ] := .F.
				EndIf

				If Type(cTagAux2) <> "U"
					oDetAux := &(cTagAux2)
					oDetAux := if(ValType(oDetAux)=="O",{oDetAux},oDetAux)
					SefoDet[nJ] := oDetAux
					cValAux2 := "DETALHE"
				Else
					aDet[nJ] := .F.
				EndIf
				If cValAux1 <> cValAux2
					Aadd( aErr, {aTag[nI][3],cValAux1,cValAux2,aTag[nI][5]} )
				EndIf

			ElseIf aTag[nI][4] == "DESTRUIR"
				oDet[nJ]    := NIL
				SefoDet[nJ] := NIL
				aDet[nJ]    := .T.
				nJ--

			ElseIf aTag[nI][4] == "COMPARAR"
				if nJ == 0
					if type(cTagAux1) <> "U"
						cValAux1 := &(cTagAux1)
					endif
					if type(cTagAux2) <> "U"
						cValAux2 := &(cTagAux2)
					endif

					If cValAux1 <> cValAux2
						Aadd( aErr, {aTag[nI][3],cValAux1,cValAux2,aTag[nI][5]} )
					EndIf
				ElseIf nJ > 0
					if aDet[nJ]
						For nK := 1 To Len(oDet[nJ])  //Ver Cada Tag de Todos os Itens
							cTagAux1 := aTag[nI][1]+"["+AllTrim(Str(nK))+"]"+aTag[nI][3]
							cTagAux2 := iif(aTag[nI][1]=="oXml", "oXmlSef", "Sef"+aTag[nI][1] )+"["+AllTrim(Str(nK))+"]"+aTag[nI][3]
							cValAux1 := "NULA"
							cValAux2 := "NULA"
							if type(cTagAux1) <> "U"
								cValAux1 := &(cTagAux1)
							endif
							if type(cTagAux2) <> "U"
								cValAux2 := &(cTagAux2)
							endif

							If cValAux1 <> cValAux2
								Aadd( aErr, {aTag[nI][3],cValAux1,cValAux2,"Item "+AllTrim(Str(nK))+"-"+aTag[nI][5]} )
							EndIf
						Next nK
					endif
				EndIF

			EndIf

		Else
			Aadd( aErr, {aTag[nI][3],cValAux1,cValAux2,aTag[nI][5]} )
		EndIf
	Next nI

	if Len( aErr ) > 0
		nRet := 2
	EndIf

	cTagAux1 := "oXml:_"   +cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
	cTagAux2 := "oXmlSef:_"+cTAG+"PROC:_PROT"+cTAG+":_INFPROT:_NPROT:TEXT"
	cValAux1 := "NULA"
	cValAux2 := "NULA"
	if type(cTagAux1) <> "U"
		cValAux1 := &(cTagAux1)
	endif
	if type(cTagAux2) <> "U"
		cValAux2 := &(cTagAux2)
	endif
	If cValAux1 <> cValAux2 .And. cValAux2 <> "NULA" .and. !Empty(cValAux2)
		Aadd( aErr, {cTagAux1,"Protocolo Invalido","Assumido XML baixado da SEFAZ","" } )
		nRet := 3 //Protocolo Diferente assume o Sefaz
	EndIf

EndIf

Return( nRet )


Static Function HFTagEmail( aTag, aErr, cChave, nAdMen )
Local cAnexo  := ""
Local cError  := ""
Local cMsg    := ""
Local cCap    := "DIVERGENCIA TAG XML FORNECEDOR x SEFAZ"
Local cHea    := ""
Local cInfo   := ""
Local nI      := 0
Local aTo     := {} 
Local cTag    := ""

cInfo += cChave + CRLF
if nAdMen == 3
	cInfo += "Protocolo XML Fornecedor Inválido. Assumido XML da SEFAZ." + CRLF
elseIf nAdMen == 1
	cInfo += "XML Fornecedor mal formado. Assumido XML da SEFAZ." + CRLF
endif

cMsg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMsg += '<html xmlns="http://www.w3.org/1999/xhtml">'
messagePadron( "",@cHea,"" )
cMsg += cHea
cMsg += '<body>'
cMsg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">'
cMsg += '<caption>'+cCap+' EMPRESA '+cEmpAnt+' FILIAL '+cFilAnt+' '+'</caption>'
cMsg += '	<tr>'
cMsg += '		<td colspan="3">'
cMsg += '			<hr>'
cMsg += '				<p class="style1">'+cInfo + CRLF +'</p>'
cMsg += '			</hr>'
cMsg += '		</td>'
cMsg += '	</tr>'

cMsg += '	<tr>'
cMsg += '		<th id="col_tag">TAG</th>'
cMsg += '		<th id="col_for">XML Fornecedor</th>'
cMsg += '		<th id="col_sef">XML SEFAZ</th>'
cMsg += '	</tr>'

For nI := 1 To Len(aErr)
	cMsg += '	<tr>'
	cTag := aErr[nI][4]
	cTag := StrTran(cTag,"<","[")
	cTag := StrTran(cTag,">","]")
	cMsg += '		<td headers="col_tag">' + cTag + '</td>'
	if "ERRO" $ Upper( aErr[nI][1] )
		cMsg += '		<td headers="col_for">' + aErr[nI][1] + '</td>'
		cMsg += '		<td headers="col_sef">' + 'Verifique o Arquivo ..\CFG\TAGNFE.CFG' + '</td>'
	Else
		cMsg += '		<td headers="col_for">' + aErr[nI][2] + '</td>'
		cMsg += '		<td headers="col_sef">' + aErr[nI][3] + '</td>'
	Endif
	cMsg += '	</tr>'
Next nI
cMsg += '</table>'
cMsg += '</body>'
cMsg += '</html>'

cEmailErr := AllTrim(SuperGetMv("XM_MAIL01")) // Conta de Email cancelamento de XML, recebe a priori o comparativo

If !Empty(cEmailErr)
    cAssunto:= "Aviso IMP.XML. Divergência de TAGs."
	aTo 	:= Separa(cEmailErr,";")
	U_MAILSEND(aTo,cAssunto,cMsg,@cError,cAnexo,"",cEmailErr,"","")
EndIf

Return( NIL )



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ HF Consulting                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³messagePad ³ Autor ³ Eneovaldo Roveri Jr                  ³ Data ³ 28/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que retorno um mensagem padrão em html para envio no corpo do e-mail³±±
±±³          ³ utilizada pelo fsendmail e tambem pela fNotific.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³ Voce pode passar os parametros cHead e cBody como referencia para utiliza- ³±±
±±³          ³ los em seu programa, como eh feito no FNotific.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ messagePadron( cCc, cHead, cBody )                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCc   : Mensagem padrao para ir no corpo do e-mail                         ³±±
±±³          ³ cHead : Mandar como referencia para ele retornar o cabecalho padrao        ³±±
±±³          ³ cBody : Mandar como referencia para ele retornar o corpo do e-mail padrao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE CONSTRUCAO                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      ³ Programador      ³ Manutencao efetuada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  /  /    ³                  ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Comparação de TAGs XML                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function messagePadron( cCc, cHead, cBody )
Local cMsgCfg := ""

cHead := ""
cHead += '<head>'
cHead += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cHead += '<title>Integração ACPJ X Protheus</title>'
cHead += '  <style type="text/css"> '
cHead += '	<!-- '
cHead += '	body {background-color: rgb(37, 64, 97);} '
cHead += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} '
cHead += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} '
cHead += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} '
cHead += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} '
cHead += '	.style5 {font-size: 10pt} '
cHead += '	-->'
cHead += '  </style>'
cHead += '</head>'

cBody := ""
cBody += '<body>'
cBody += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">'
cBody += '  <tbody>'
cBody += '    <tr>'
cBody += '      <td colspan="2">'
cBody += '    	<Center>'
cBody += '      <img src="http://extranet.helpfacil.com.br/images/cabecalho.jpg">'
cBody += '      </Center><hr>'
cBody += '      <p class="style1">'+cCc+'</p>'
cBody += '      <hr></td>'
cBody += '    </tr>'
cBody += '  </tbody>'
cBody += '</table>'
cBody += '<p class="style1">&nbsp;</p>'
cBody += '</body>'

cMsgCfg := ""
cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMsgCfg += cHead
cMsgCfg += cBody
cMsgCfg += '</html>'

Return cMsgCfg



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_HFXMLTAG| Autor ³ Eneovaldo Roveri Jr.  ³ Data ³24/03/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ TAGs padrões para arquivo de comparação XML com SEFAZ.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HFXML02                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HFXMLTAG()
Local cRet := ""

cRet += "<NfeProc><Nfe><InfNfe><Ide><cUF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><cNF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><natOp>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><indPag>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><mod>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><serie>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><dhEmi>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><dhSaiEnt>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><tpNF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><idDest>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><cMunFG>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><tpImp>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><tpEmis>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><cDV>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><tpAmb>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><finNFe>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><indFinal>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><indPres>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><procEmi>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Ide><verProc>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><Emit><CNPJ>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><xNome>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><xFant>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><xLgr>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><nro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><xCpl>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><xBairro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><cMun>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><xMun>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><UF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><CEP>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><cPais>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><xPais>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><enderEmit><fone>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><IE>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><email>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><Emit><CRT>"+CRLF


cRet += "<NfeProc><Nfe><InfNfe><dest><CNPJ>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><xNome>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><xFant>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><xLgr>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><nro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><xCpl>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><xBairro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><cMun>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><xMun>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><UF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><CEP>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><cPais>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><xPais>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><enderDest><fone>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><IE>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><email>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><dest><CRT>"+CRLF

cRet += "{}<NfeProc><Nfe><InfNfe><det>"+CRLF  //Inicio dos itens, por isso as TAGs não devem ser informados inteiras
	cRet += "<prod><cProd>"+CRLF
	cRet += "<prod><cEAN>"+CRLF
	cRet += "<prod><xProd>"+CRLF
	cRet += "<prod><NCM>"+CRLF
	cRet += "<prod><CFOP>"+CRLF
	cRet += "<prod><uCom>"+CRLF
	cRet += "<prod><qCom>"+CRLF
	cRet += "<prod><vUnCom>"+CRLF
	cRet += "<prod><vProd>"+CRLF
	cRet += "<prod><cEANTrib>"+CRLF
	cRet += "<prod><uTrib>"+CRLF
	cRet += "<prod><qTrib>"+CRLF
	cRet += "<prod><vUnTrib>"+CRLF
	cRet += "<prod><indTot>"+CRLF
	cRet += "<prod><nItemPed>"+CRLF

	cRet += "<imposto><ICMS><ICMS00><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS00><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS00><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS00><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS00><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS00><vICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS10><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><vICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMS10><vICMSST>"+CRLF

	cRet += "<imposto><ICMS><ICMS20><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS20><vICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS30><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS30><vICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS40><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS40><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS40><vICMSDeson>"+CRLF
	cRet += "<imposto><ICMS><ICMS40><motDesICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS41><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS41><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS41><vICMSDeson>"+CRLF
	cRet += "<imposto><ICMS><ICMS41><motDesICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS50><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS50><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS50><vICMSDeson>"+CRLF
	cRet += "<imposto><ICMS><ICMS50><motDesICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS51><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><vICMSOp>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><pDif>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><vlICMSDif>"+CRLF
	cRet += "<imposto><ICMS><ICMS51><vlICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS60><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS60><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS60><vBCSTRet>"+CRLF
	cRet += "<imposto><ICMS><ICMS60><vICMSSTRet>"+CRLF

	cRet += "<imposto><ICMS><ICMS70><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><vICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><vICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><vICMSDeson>"+CRLF
	cRet += "<imposto><ICMS><ICMS70><motDesICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMS90><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><vICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><vICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><vICMSDeson>"+CRLF
	cRet += "<imposto><ICMS><ICMS90><motDesICMS>"+CRLF

	cRet += "<imposto><ICMS><ICMSPART><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><vICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><vICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><pBCOp>"+CRLF
	cRet += "<imposto><ICMS><ICMSPART><UFST>"+CRLF

	cRet += "<imposto><ICMS><ICMSST><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSST><CST>"+CRLF
	cRet += "<imposto><ICMS><ICMSST><vBCSTRet>"+CRLF
	cRet += "<imposto><ICMS><ICMSST><vICMSSTRet>"+CRLF
	cRet += "<imposto><ICMS><ICMSST><vBCSTDest>"+CRLF
	cRet += "<imposto><ICMS><ICMSST><vICMSSTDest>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN101><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN101><CSOSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN101><pCredSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN101><vCredICMSSN>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN102><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN102><CSOSN>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN201><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><CSOSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><vICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><pCredSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN201><vCredICMSSN>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN202><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><CSOSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN202><vICMSST>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN500><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN500><CSOSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN500><vBCSTRet>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN500><vICMSSTRet>"+CRLF

	cRet += "<imposto><ICMS><ICMSSN900><orig>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><CSOSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><modBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><vBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pRedBC>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><vICMS>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><modBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pMVAST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pRedBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><vBCST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><vICMSST>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><pCredSN>"+CRLF
	cRet += "<imposto><ICMS><ICMSSN900><vCredICMSSN>"+CRLF

	cRet += "<imposto><IPI><clEnq>"+CRLF
	cRet += "<imposto><IPI><CNPJProd>"+CRLF
	cRet += "<imposto><IPI><cSelo>"+CRLF
	cRet += "<imposto><IPI><qSelo>"+CRLF
	cRet += "<imposto><IPI><cEnq>"+CRLF

	cRet += "<imposto><IPI><IPITrib><CST>"+CRLF
	cRet += "<imposto><IPI><IPITrib><vBC>"+CRLF
	cRet += "<imposto><IPI><IPITrib><pIPI>"+CRLF
	cRet += "<imposto><IPI><IPITrib><qUnid>"+CRLF
	cRet += "<imposto><IPI><IPITrib><vUnid>"+CRLF
	cRet += "<imposto><IPI><IPITrib><vIPI>"+CRLF

	cRet += "<imposto><IPI><IPINT><CST>"+CRLF

	cRet += "<imposto><PIS><PISAliq><CST>"+CRLF
	cRet += "<imposto><PIS><PISAliq><vBC>"+CRLF
	cRet += "<imposto><PIS><PISAliq><pPIS>"+CRLF
	cRet += "<imposto><PIS><PISAliq><vPIS>"+CRLF

	cRet += "<imposto><PIS><PISQtde><CST>"+CRLF
	cRet += "<imposto><PIS><PISQtde><qBCProd>"+CRLF
	cRet += "<imposto><PIS><PISQtde><vAliqProd>"+CRLF
	cRet += "<imposto><PIS><PISQtde><vPIS>"+CRLF

	cRet += "<imposto><PIS><PISNT><CST>"+CRLF

	cRet += "<imposto><PIS><PISOutr><CST>"+CRLF
	cRet += "<imposto><PIS><PISOutr><vBC>"+CRLF
	cRet += "<imposto><PIS><PISOutr><pPIS>"+CRLF
	cRet += "<imposto><PIS><PISOutr><qBCProd>"+CRLF
	cRet += "<imposto><PIS><PISOutr><vAliqProd>"+CRLF
	cRet += "<imposto><PIS><PISOutr><vPIS>"+CRLF

	cRet += "<imposto><PISST><vBC>"+CRLF
	cRet += "<imposto><PISST><pPIS>"+CRLF
	cRet += "<imposto><PISST><qBCProd>"+CRLF
	cRet += "<imposto><PISST><vAliqProd>"+CRLF
	cRet += "<imposto><PISST><vPIS>"+CRLF

	cRet += "<imposto><COFINS><COFINSAliq><CST>"+CRLF
	cRet += "<imposto><COFINS><COFINSAliq><vBC>"+CRLF
	cRet += "<imposto><COFINS><COFINSAliq><pCOFINS>"+CRLF
	cRet += "<imposto><COFINS><COFINSAliq><vCOFINS>"+CRLF

	cRet += "<imposto><COFINS><COFINSQtde><CST>"+CRLF
	cRet += "<imposto><COFINS><COFINSQtde><qBCProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSQtde><vAliqProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSQtde><vCOFINS>"+CRLF

	cRet += "<imposto><COFINS><COFINSNT><CST>"+CRLF

	cRet += "<imposto><COFINS><COFINSOutr><CST>"+CRLF
	cRet += "<imposto><COFINS><COFINSOutr><vBC>"+CRLF
	cRet += "<imposto><COFINS><COFINSOutr><pCOFINS>"+CRLF
	cRet += "<imposto><COFINS><COFINSOutr><qBCProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSOutr><vAliqProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSOutr><vCOFINS>"+CRLF

	cRet += "<imposto><COFINS><COFINSST><vBC>"+CRLF
	cRet += "<imposto><COFINS><COFINSST><pCOFINS>"+CRLF
	cRet += "<imposto><COFINS><COFINSST><qBCProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSST><vAliqProd>"+CRLF
	cRet += "<imposto><COFINS><COFINSST><vCOFINS>"+CRLF

	cRet += "<imposto><COFINS><ISSQN><vBC>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vAliq>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vISSQN>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><cMunFG>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><cListServ>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vDeducao>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vOutro>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vDescIncond>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vDescCond>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><vISSRet>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><indISS>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><cServico>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><cMun>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><cPais>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><nProcesso>"+CRLF
	cRet += "<imposto><COFINS><ISSQN><indIncentivo>"+CRLF

	cRet += "<imposto><impostoDevol>"+CRLF
	cRet += "<imposto><pDevol>"+CRLF
	cRet += "<imposto><IPI>"+CRLF
	cRet += "<imposto><vIPIDevol>"+CRLF

	cRet += "<infAdProd>"+CRLF

cRet += "{}<NfeProc><Nfe><InfNfe></det>"+CRLF //Finais dos itens

cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vBC>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vICMS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vICMSDeson>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vBCST>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vST>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vProd>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vFrete>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vSeg>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vDesc>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vII>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vIPI>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vPIS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vCOFINS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vOutro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vNF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ICMSTot><vTotTrib>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vServ>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vBC>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vISS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vPIS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vCOFINS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><dCompet>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vDeducao>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vOutro>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vDescIncond>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vDescCond>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><vISSRet>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><ISSQNtot><cRegTrib>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vRetPIS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vRetCOFINS>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vRetCSLL>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vBCIRRF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vIRRF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vBCRetPrev>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><total><retTrib><vRetPrev>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><modFrete>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><CNPJ>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><CPF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><xNome>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><IE>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><xEnder>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><xMun>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><UF>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><vServ>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><vBCRet>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><pICMSRet>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><vICMSRet>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><CFOP>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><retTransp><cMunFG>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><veicTransp><placa>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><veicTransp><UF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><veicTransp><RNTC>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><reboque><placa>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><reboque><UF>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><reboque><RNTC>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><reboque><vagao>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><reboque><balsa>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol>qVol>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol><esp>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol><marca>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol><nVol>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol><pesoL>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><vol><pesoB>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><transp><transporta><lacres><nLacre>"+CRLF

cRet += "{}<NfeProc><Nfe><InfNfe><transp><vol>"+CRLF     //inicio itens de volume
	cRet += "<qVol>"+CRLF
	cRet += "<esp>"+CRLF
	cRet += "<marca>"+CRLF
	cRet += "<nVol>"+CRLF
	cRet += "<pesoL>"+CRLF
	cRet += "<pesoB>"+CRLF
cRet += "{}<NfeProc><Nfe><InfNfe><transp></vol>"+CRLF    //fim itens de volume

cRet += "{}<NfeProc><Nfe><InfNfe><transp><lacres>"+CRLF     //inicio itens de lacres
	cRet += "<nLacre>"+CRLF
cRet += "{}<NfeProc><Nfe><InfNfe><transp></lacres>"+CRLF    //fim itens de lacres

cRet += "<NfeProc><Nfe><InfNfe><cobr><fat><nFat>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><cobr><fat><vOrig>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><cobr><fat><vDesc>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><cobr><fat><vLiq>"+CRLF

cRet += "{}<NfeProc><Nfe><InfNfe><dup>"+CRLF     //inicio itens de Duplicatisw
	cRet += "<nDup>"+CRLF
	cRet += "<dVenc>"+CRLF
	cRet += "<vDup>"+CRLF
cRet += "{}<NfeProc><Nfe><InfNfe></dup>"+CRLF    //fim itens de Duplicatisw

cRet += "<NfeProc><Nfe><InfNfe><infAdic><infAdFisco>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><infAdic><infCpl>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><infAdic><obsCont><xCampo>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><infAdic><obsCont><xTexto>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><infAdic><obsFisco><xCampo>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><infAdic><obsFisco><xTexto>"+CRLF

cRet += "<NfeProc><Nfe><InfNfe><infAdic><procRef><nProc>"+CRLF
cRet += "<NfeProc><Nfe><InfNfe><infAdic><procRef><indProc>"+CRLF

Return(cRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ HF Consulting                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³messagePad ³ Autor ³ Eneovaldo Roveri Jr                  ³ Data ³ 28/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao que retorno um mensagem padrão em html para envio no corpo do e-mail³±±
±±³          ³ utilizada pelo fsendmail e tambem pela fNotific.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³ Voce pode passar os parametros cHead e cBody como referencia para utiliza- ³±±
±±³          ³ los em seu programa, como eh feito no FNotific.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ messagePadron( cCc, cHead, cBody )                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCc   : Mensagem padrao para ir no corpo do e-mail                         ³±±
±±³          ³ cHead : Mandar como referencia para ele retornar o cabecalho padrao        ³±±
±±³          ³ cBody : Mandar como referencia para ele retornar o corpo do e-mail padrao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE CONSTRUCAO                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      ³ Programador      ³ Manutencao efetuada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  /  /    ³                  ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Comparação de TAGs XML                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MANIFXML( cChave, lShow )
Local cRet := ZBZ->ZBZ_MANIF
Local nRet := 0
Local cEve := ""
Local cRej := ""
Local cManPre   := GetNewPar("XM_MANPRE","N")
Default lShow   := .T.

Private cMsgTag := ""

If cManPre <> "N" .and. ZBZ->ZBZ_MODELO == "55" .and. empty(ZBZ->ZBZ_MANIF)
	if cManPre == "1"
		nRet := HFMFXml( cChave, "210200", @cRej )
	Elseif cManPre == "2"
		nRet := HFMFXml( cChave, "210210", @cRej )
	Else
		nRet := -9
	EndIf
	if nRet >= 0
		cRet := iif( cManPre == "2", "4", cManPre )
	elseif nRet <> -9 
		if cRej == "573"  //aqui já foi manifestado com o mesmo evento
			cRet := iif( cManPre == "2", "4", cManPre )
		Else
			if lShow
		    	U_MyAviso("Aviso","Não foi possivel Manifestar."+CRLF+cMsgTag,{"OK"},3)
	 		endif
		endif
	endif
EndIf

Return( cRet )





User Function H20VisuPC(nRecSC7)

Local aArea			:= GetArea()
Local aAreaSC7		:= SC7->(GetArea())
Local nSavNF		:= MaFisSave()
Local cSavCadastro	:= cCadastro
Local cFilBak		:= cFilAnt
Local nBack       	:= n
Local aCroneRot     := aClone(aRotina)
PRIVATE nTipoPed	:= 1
PRIVATE cCadastro	:= OemToAnsi("Consulta ao Pedido de Compra") //STR0066
PRIVATE l120Auto	:= .F.
PRIVATE l123Auto	:= .F.
PRIVATE aBackSC7	:= {}  //Sera utilizada na visualizacao do pedido - MATA120
Private aRotina     := {}
	aAdd(aRotina,{"Pesquisar","PesqBrw"   , 0, 1, 0, .F. }) //"Pesquisar"
	aAdd(aRotina,{"Visualizar","A120Pedido", 0, 2, 0, Nil }) //"Visualizar"
	aAdd(aRotina,{"Incluir","A120Pedido", 0, 3, 0, Nil }) //"Incluir"
	aAdd(aRotina,{"Alterar","A120Pedido", 0, 4, 6, Nil }) //"Alterar"
	aAdd(aRotina,{"Excluir","A120Pedido", 0, 5, 7, Nil }) //"Excluir"
	aAdd(aRotina,{"Copia","A120Copia" , 0, 4, 0, Nil }) //"Copia"
	aAdd(aRotina,{"Imprimir","A120Impri" , 0, 2, 0, Nil }) //"Imprimir"
	aAdd(aRotina,{"Legenda","A120Legend", 0, 1, 0, .F. }) //"Legenda"
	aAdd(aRotina,{"Conhecimento","MsDocument", 0, 4, 0, Nil }) //"Conhecimento"	

MaFisEnd()

DbSelectArea("SC7")
MsGoto(nRecSC7)

cFilAnt := IIf(!Empty(SC7->C7_FILIAL),SC7->C7_FILIAL,cFilAnt)

If SC7->C7_TIPO <> 3
	A120Pedido(Alias(),RecNo(),2)
Else
    nTipoPed := 3  
	A123Pedido(Alias(),RecNo(),2)
EndIf

cFilant := cFilBak

n := nBack
cCadastro	:= cSavCadastro
aRotina     := aClone(aCroneRot)
MaFisRestore(nSavNF)
RestArea(aAreaSC7)
RestArea(aArea)

Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Empresa   ³ HF Consulting                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³ HFMANCHV  ³ Autor ³ Eneovaldo Roveri Jr                  ³ Data ³ 07/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Manifestação da chave.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³ Manifestação da chave pela tela principal, irá atualizar o campo ZBZ_MANIF ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_HFMANCHV()                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE CONSTRUCAO                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      ³ Programador      ³ Manutencao efetuada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  /  /    ³                  ³                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Importa XML                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HFMANCHV() //GETESB2
Local aArea  := GetArea()
Local cChave := AllTrim( ZBZ->ZBZ_CHAVE )
Local nRet   := 0
Local nEve   := 0
Local cEve   := ""
Local cRej   := ""
Local cJust  := " "
Private lShow := .T.
Private cMsgTag := ""

nEve := U_TELMAN("Manifestação do Destinatário","Manifestação do Destinatário",{"Confirmação da operação","Desconhecimento da operação","Operação não Realizada","Ciência da operação"},3)

if nEve == 1
	cEve := "210200"
elseif nEve == 2
	cEve := "210220"
elseif nEve == 3
	cEve  := "210240"
	cJust := space( 255 )
	cJust := U_TelaJust( cChave, cJust )  //GETESB2
	if cJust == "-1"
		Return( NIL )
	endif
elseif nEve == 4
	cEve := "210210"
else
	Return( NIL )
endif

nRet := HFMFXml( cChave, cEve, @cRej, cJust )

if nRet < 0
	if cRej == "573"  //aqui já foi manifestado com o mesmo evento
		nRet := 0
	endif
	if lShow
    	U_MyAviso("Aviso","Não foi possivel Manifestar."+CRLF+cMsgTag,{"OK"},3)
	endif
Endif
if nRet >= 0
	DbSelectArea("ZBZ")
	Reclock("ZBZ",.F.)
	ZBZ->ZBZ_MANIF := AllTrim(str(nEve))
	MsUnlock()
EndIf

RestArea(aArea)
Return( NIL )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MyAviso   ºAutor  ³ Eneo               º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface/Dialog de Aviso.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TELMAN(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
Local ny        := 0
Local nx        := 0
Local aSize  := {  {134,304,35,155,35,113,51},;  // Tamanho 1
				{134,450,35,155,35,185,51},; // Tamanho 2
				{227,450,35,210,65,185,99} } // Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet 
Local nPass := 0
Private oDlgAviso
Private nOpcAviso := 0

DEFAULT lEdit := .F.
If lEdit
	nSize := 3
EndIf

lMsHelpAuto := .F.

cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)
cMensagem := "1-Confirmação da operação: Operação conclusiva, o emissor não poderá cancelar o XML"+CRLF
cMensagem += "2-Desconhecimento da operação"+CRLF
cMensagem += "3-Operação não Realizada"+CRLF
cMensagem += "4-Ciência da operação: Deverá Confirmar operação posteriormente, o emissor não poderá cancelar o XML"+CRLF
//"Confirmação da operação","Desconhecimento da operação","Operação não Realizada","Ciência da operação"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando for rotina automatica, envia o aviso ao Log.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('lMsHelpAuto') == 'U'
	lMsHelpAuto := .F.
EndIf

If !lMsHelpAuto
	If nSize == Nil
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o numero de botoes Max. 5 e o tamanho da Msg.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  Len(aBotoes) > 3
			nSize := 3
		Else
			Do Case
				Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
					nSize := 2
				Case Len(cMensagem) >= 250
					nSize := 3
				OtherWise
					nSize := 1
			EndCase
		EndIf
	EndIf
	If nSize <= 3
		nLinha := nSize
	Else
		nLinha := 3
	EndIf
	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption OF oDlgAviso PIXEL
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgAviso SIZE aSize[nSize][3],aSize[nSize][4] NOBORDER WHEN .F. PIXEL ADJUST 
	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
	If cBitmap <> Nil
		@ 2, 37 BITMAP RESNAME cBitmap oF oDlgAviso SIZE 18,18 NOBORDER WHEN .F. PIXEL
		@ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	Else
		@ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	EndIf
	If nSize < 3
		@ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
	Else
		If !lEdit
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
		Else
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] MEMO
		EndIf
	EndIf
	If Len(aBotoes) > 1 .Or. nTimer <> Nil
		TButton():New(1000,1000," ",oDlgAviso,{||Nil},82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	EndIf
	ny := 38
	l1 := .T.
	For nx:=1 to Len(aBotoes)
		cAction:="{||nOpcAviso:="+Str(nx)+",oDlgAviso:End()}"
		bAction:=&(cAction)
		cMsgButton:= OemToAnsi(AllTrim(aBotoes[nx]))
		cMsgButton:= IF(  "&" $ Alltrim(cMsgButton), cMsgButton ,  "&"+cMsgButton )
		if l1
			TButton():New(aSize[nLinha][7]-15,ny,cMsgButton, oDlgAviso,bAction,82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		Else
			TButton():New(aSize[nLinha][7]   ,ny,cMsgButton, oDlgAviso,bAction,82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		Endif
		ny += 85
		if ny > 150
			ny := 38
			l1 := .F.
		endif
	Next nx
	If nTimer <> Nil
		oTimer := TTimer():New(nTimer,{|| nOpcAviso := nOpcPadrao,IIf(nPass==0,nPass++,oDlgAviso:End()) },oDlgAviso)
		oTimer:Activate()
		bAction:= {|| oTimer:DeActivate() }
		TButton():New(aSize[nLinha][7],ny,"Timer off", oDlgAviso,bAction,52,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Endif
	ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
	If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
		cMensagem += " " + aBotoes[nRotAutDefault]
		nOpcAviso := nRotAutDefault
	Endif
	ConOut(Repl("*",40))
	ConOut(cCaption)
	ConOut(cMensagem)
	ConOut(Repl("*",40))
	AutoGrLog(cCaption)
	AutoGrLog(cMensagem)
EndIf

Return (nOpcAviso)



Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_AMAPC()
        U_H20VISUPC()
        U_HFXMLTAG()
        U_HFXMLPED()
        U_MANIFXML()
        U_HFXMLCPS()
        U_TELMAN()
        U_HFMANCHV()
        U_AXMLPRPC()
	EndIF
Return(lRecursa)
