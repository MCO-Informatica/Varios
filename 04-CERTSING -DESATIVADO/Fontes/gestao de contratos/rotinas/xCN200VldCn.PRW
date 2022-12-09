#Include "Totvs.ch"
#Include "Protheus.ch"

//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido
#DEFINE DEF_SAPRO "04" //Em Aprovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado    
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10"//Revisado

//Transacoes
#DEFINE DEF_TRAINC "007"//Inclusao de Planilhas
#DEFINE DEF_TRAEDT "008"//Edicao de Planilhas
#DEFINE DEF_TRAEXC "009	"//Exclusao de Planilhas
#DEFINE DEF_TRAVIS "032"//Visualizacao de Planilhas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN200VldCon³ Autor ³ Marcelo Custodio      ³ Data ³ 28.11.2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida contrato                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA200                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xCN200VldCn()
Local aArea     := GetArea()
Local lRet      := .T.
Local cContrato := M->CNA_CONTRA
Local cRevisa   := M->CNA_REVISA
Local cCtrFix	:= ""

If !Empty(cContrato)
	
 	If lContrEd
		If cContrato <> M->CN9_NUMERO  
			lRet := .F.
			Help(" ",1,"CNTA200COP")//"Numero do contrato cadastrado na Planilha divergente ao Contrato.
		EndIf 
	Else        
	
		lRet:= ExistCpo("CN9",cContrato+cRevisa) 
	EndIf	
	
	lRet := If(lContrEd,lRet,lRet.And.CN240VldUsr(cContrato,DEF_TRAINC,.T.)) 
	
	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		
		If Empty(cRevisa)
			dbSeek(xFilial("CN9")+cContrato)
			//Seleciona revisao mais recente se houver
			If !Empty(CN9->CN9_REVATU)
				M->CNA_REVISA := cRevisa := CN9->CN9_REVATU
			EndIf
		EndIF   
		
		//Verifica se o edital selecionado pertence a um edital
		If !Empty(CN9->CN9_CODED)
			lRet := .F.
			Help(" ",1,"CNTA200EDT",,"Contrato foi gerado por um edital e por isso nao se pode inserir planilha",4,1)
		EndIf
		
		
		
		If dbSeek(xFilial("CN9")+cContrato+cRevisa) .And. lRet
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o contrato aceita planilha          ³
			//³ Situacoes que aceitam a inclusao de planilha    ³
			//³  - 2 - Elaboracao                               ³
			//³  - 3 - Emitido                                  ³
			//³  - 4 - Em Aprovacao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO .OR. AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE
				//Busca Tipo de Contrato
				If (CN1->(FieldPos("CN1_CTRFIX")) > 0) .And. CN1->(dbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
					cCtrFix := CN1->CN1_CTRFIX
				EndIf
				//Para tipo de contrato fixo nao permite inclusao de planilha				
				If cCtrFix != "2"
					If Empty(CN9->CN9_CLIENT)
						//Quando altera o numero do contrato limpa o fornecedor
						cEspctr:="1"
							
		               	IF !Empty(CN9->CN9_REVATU)=.F.
							If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
								M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
								M->CNA_LOJA	  := Space(TamSX3("CNA_LOJA")[1])
							Endif        
								                                            
							//Retorna numero na sequencia do contrato para a planilha
					       	M->CNA_NUMERO := CN200PlaNum(cContrato,cRevisa)
							//Retorna data inicial do contrato, ou a data atual
				       	   	M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
							//Retorna data final do contrato, ou a data atual
					       	M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)	   		
							
							dbSelectArea("CNC")
							dbSetOrder(1)
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro fornecedor relacionado       ³
							//³ ao contrato                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("CNC")+M->CNA_CONTRA+If(FieldPos("CNC_REVISA")>0,M->CNA_REVISA,""))
								M->CNA_FORNEC := CNC->CNC_CODIGO
								M->CNA_LJFORN := CNC->CNC_LOJA
							Else
								M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
								M->CNA_LJFORN := Space(TamSX3("CNA_LJFORN")[1])
							Endif
							lRet := .T.
						Else
							lRet := .F.
							Help(" ",1,"CNTA200CON") //"Contrato revisado, selecione a versão mais recente."  
						EndIf
					Else 
						//Quando altera o numero do contrato limpa o Vendedor
		    			cEspctr:="2"
		            	IF !Empty(CN9->CN9_REVATU)=.F.
							If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
								M->CNA_CLIENT := Space(TamSX3("CNA_CLIENT")[1])
								M->CNA_LOJACL := Space(TamSX3("CNA_LOJACL")[1])
							Endif        
								                                            
							//Retorna numero na sequencia do contrato para a planilha
					       	M->CNA_NUMERO := CN200PlaNum(cContrato,cRevisa)
							//Retorna data inicial do contrato, ou a data atual
				       		M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
							//Retorna data final do contrato, ou a data atual
				           	M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)	   		
								
							dbSelectArea("SA1")
							dbSetOrder(1)
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Seleciona primeiro cliente relacionado ao contrato  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If dbSeek(xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL)
								M->CNA_CLIENT := SA1->A1_COD
								M->CNA_LOJACL := SA1->A1_LOJA
							Else
								M->CNA_CLIENT := Space(TamSX3("A1_COD")[1])
								M->CNA_LOJACL := Space(TamSX3("A1_LOJA")[1])
							Endif
							lRet := .T.
						Else
							lRet := .F.
							Help(" ",1,"CNTA200CON") //"Contrato revisado, selecione a versão mais recente."  
						EndIf
					Endif	
				Else
					lRet := .F.
					M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
					MsgAlert("O tipo do Contrato selecionado não permite a inclusão de planilhas.")
				EndIf
			Else
				lRet := .F.
				M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
				Help(" ",1,"CNTA200ATU") //"A situação atual do contrato não permite a inclusão de planilhas."
			EndIf
			
		ElseIf Empty(CN9->CN9_CODED)
			//Limpa revisao quando o contrato nao for encontrado
			M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
		Endif
	EndIf  
Else
	lRet  := .F.
Endif

RestArea(aArea)
Return lRet
