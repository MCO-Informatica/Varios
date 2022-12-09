#INCLUDE "CNTA090.CH"
#INCLUDE "PROTHEUS.CH"

//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido
#DEFINE DEF_SAPRO "04" //Em Aprdovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10"//Revisado

//Transacoes
#DEFINE DEF_TRAINC "003"//Inclusao de caucoes
#DEFINE DEF_TRAEDT "004"//Edicao de caucoes
#DEFINE DEF_TRAEXC "005"//Exclusao de caucoes
#DEFINE DEF_TRAVIS "031"//Visualizacao de caucoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN090VldCon³ Autor ³ Marcelo Custodio      ³ Data ³24.11.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida o contrato selecionado                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CN090VldCon()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSGCT008()
Local aArea     := GetArea()
Local lRet      := .F.
Local cContrato := M->CN8_CONTRA
Local cRevisa   := M->CN8_REVISA
Local lTRevisa  := .F.

Local cEspctr   := !EMPTY(CN9->CN9_CLIENT)

If cRevisa != CN9->CN9_REVISA
	cRevisa := CN9->CN9_REVISA
EndIf

If !Empty(cContrato)
	lRet := CN240VldUsr(cContrato,DEF_TRAINC,.T.)
	
	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+cContrato+cRevisa)
		
		//Seleciona revisao mais recente se houver
		If !Empty(CN9->CN9_REVATU)
			dbSeek(xFilial("CN9")+cContrato+CN9->CN9_REVATU)
		EndIf
		
		//Verifica se o contrato possui revisao ainda nao aprovada
		lTRevisa := (!Empty(CN9->CN9_REVATU) .And. (AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SPARA))
		
		If Empty(CN9->CN9_REVATU) .Or. lTRevisa
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato aceita caucao e a        ³
			//³ situacao atual do mesmo                         ³
			//³ Situacoes que aceitam caucao:                   ³
			//³  - 2 - Elaboracao                               ³
			//³  - 3 - Emitido                                  ³
			//³  - 4 - Em Aprovacao                             ³
			//³  - 9 - Revisao                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CN9->CN9_FLGCAU == "1" .And. If((CN9->( FieldPos("CN9_TPCAUC") ) > 0),(CN9->CN9_TPCAUC == "1"),.T.)
				If (AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SREVS) .Or. lTRevisa
					
					//Preenche Revisa
					M->CN8_REVISA := CN9->CN9_REVISA
					
					//Atualiza data de inicio da caucao
					M->CN8_DTINVI := If(CN9->CN9_DTINIC > dDataBase,CN9->CN9_DTINIC,dDataBase)
					
					//Quando altera o numero do contrato limpa o fornecedor
					If ALTERA .And. M->CN8_CONTRA != CN8->CN8_CONTRA
						M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
						M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
						M->CN8_NOME	  := ""
					EndIf
					
					If cEspctr = .F.		//Verficia se for compra ou Venda
						dbSelectArea("CNC")
						dbSetOrder(1)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Seleciona primeiro fornecedor relacionado       ³
						//³ ao contrato                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If dbSeek(xFilial("CNC")+M->CN8_CONTRA+If(CNC->(FieldPos("CNC_REVISA"))>0,cRevisa,""))
							M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
							M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
							M->CN8_NOMCLI := ""
							M->CN8_FORNEC := CNC->CNC_CODIGO
							M->CN8_LOJA	  := CNC->CNC_LOJA
							M->CN8_NOME   := Posicione("SA2",1,xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA,"A2_NOME")
						Else
							M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
							M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
							M->CN8_NOME	  := ""
						EndIf
					Else
						dbSelectArea("SA1")
						dbSetOrder(1)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Seleciona primeiro client relacionado           ³
						//³ ao contrato                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If dbSeek(xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL)
							M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
							M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
							M->CN8_NOME	  := ""
							M->CN8_CLIENT := SA1->A1_COD
							M->CN8_LOJACL := SA1->A1_LOJA
							M->CN8_NOMCLI := Posicione("SA1",1,xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,"A1_NOME")
						Else
							M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
							M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
							M->CN8_NOMCLI := ""
						EndIf
					EndIf
					lRet := .T.
				Else
					lRet := .F.
					If MsgYesNo("O contrato já está vigente, deseja alterar o status do caução?")
						lRet := .T.
						RecLock("CN9",.F.)
						CN9->CN9_FLGCAU := "1"
						CN9->CN9_TPCAUC := "1"
						CN9->CN9_MINCAU := 5
						CN9->(MsUnlock())
						
						//Preenche Revisa
						M->CN8_REVISA := CN9->CN9_REVISA
						
						//Atualiza data de inicio da caucao
						M->CN8_DTINVI := If(CN9->CN9_DTINIC > dDataBase,CN9->CN9_DTINIC,dDataBase)
						
						//Quando altera o numero do contrato limpa o fornecedor
						If ALTERA .And. M->CN8_CONTRA != CN8->CN8_CONTRA
							M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
							M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
							M->CN8_NOME	  := ""
						EndIf
						
						If cEspctr = .F.		//Verficia se for compra ou Venda
							dbSelectArea("CNC")
							dbSetOrder(1)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro fornecedor relacionado       ³
							//³ ao contrato                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("CNC")+M->CN8_CONTRA+If(CNC->(FieldPos("CNC_REVISA"))>0,cRevisa,""))
								M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
								M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
								M->CN8_NOMCLI := ""
								M->CN8_FORNEC := CNC->CNC_CODIGO
								M->CN8_LOJA	  := CNC->CNC_LOJA
								M->CN8_NOME   := Posicione("SA2",1,xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA,"A2_NOME")
							Else
								M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
								M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
								M->CN8_NOME	  := ""
							EndIf
						Else
							dbSelectArea("SA1")
							dbSetOrder(1)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro client relacionado           ³
							//³ ao contrato                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL)
								M->CN8_FORNEC := Space(TamSX3("CN8_FORNEC")[1])
								M->CN8_LOJA	  := Space(TamSX3("CN8_LOJA")[1])
								M->CN8_NOME	  := ""
								M->CN8_CLIENT := SA1->A1_COD
								M->CN8_LOJACL := SA1->A1_LOJA
								M->CN8_NOMCLI := Posicione("SA1",1,xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,"A1_NOME")
							Else
								M->CN8_CLIENT := Space(TamSX3("CN8_CLIENT")[1])
								M->CN8_LOJACL := Space(TamSX3("CN8_LOJACL")[1])
								M->CN8_NOMCLI := ""
							EndIf
						EndIf
						lRet := .T.
					End
				EndIf
			Else
				lRet := .F.
				MsgInfo("Este contrato está em aberto, altere no contrato o campo caução para 'Sim' para prosseguir nesta rotina.")
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return lRet