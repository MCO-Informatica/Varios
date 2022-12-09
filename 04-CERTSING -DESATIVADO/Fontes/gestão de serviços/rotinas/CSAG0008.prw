#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "TBICONN.CH"

#DEFINE AT_PA1_ITEM   1
#DEFINE AT_PA1_PRODUT 2
#DEFINE AT_PA1_DESCRI 3

#DEFINE AT_FIELDS 4
#DEFINE AT_R_E_C_N_O_ AT_FIELDS		//-- Deixar AT_R_E_C_N_O_ sempre como ultimo campo do aListBox


//+----------+-----------+------+------------------------+-----+-----------+
//|PROGRAMA  |CSAG0008   |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+-----------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Finalização de OS. Rotina chamada atravez CSAG0001           |
//+----------+-------------------------------------------------------------+
//|USO       |Especifico CertiSign                                         |
//+----------+-------------------------------------------------------------+
User Function CSAG0008(recno, oBrowse)

	Local oDlg
	Local aAdvSize     := {}
	Local aObjSize     := {}
	Local aObjCoords   := {}
	Local aInfoAdvSize := {}
	Local bBloqComboBoxSetGet
	
	Private dDtFec     := CriaVar("PA0_DTFECH")
	Private cHorFec    := CriaVar("PA0_HORFEC")
	Private cCusto     := CriaVar("PA0_CUSTRA")
	Private cTipo      := "T"
	Private cCaminho   := Space(100)
	Private nATListBox := 0
	Private aTipo      := {}
	Private aBloqBox   := {"SIM","NAO"}
	Private aBloqBox2  := {	"",;
								"1=Responsável Ausente",;
								"2=Dossiê Original/ Cópia Autenticada Ausente",;
								"3=Dossiê Incompleto",;
								"4=Dossiê Ilegível",;
								"5=Documento de Identificação Ilegível/ Cortado"}
	Private cBloqCBox := ""
	Private aPa1      := {}
	Private oLista            
	Private aHeader   := {}        
	Private aCols     := {}
	Private cNomeUser := Alltrim(UsrRetName(__CUSERID))
	Private nUsado    := 0 
	Private lRefresh  := .T.
	Private _NumOS    := ""
	Private _OldOs    := PA0->PA0_OS
	Private nResult   := 0
	Private oLbe      := NIL    
	Private ALTERA    := .F.

	bBloqComboBoxSetGet := { |cSetGet| IF( PCount() > 0 , cBloqCBox := SubStr( cSetGet , 30 , 1 ), cBloqCBox ) }
	
	aAdvSize		:= MsAdvSize( .F. , .F. )
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	
	aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
	aAdd( aObjCoords , { 015 , 035 , .T. , .F. } )
	
	aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )
	
	IF PA0->PA0_STATUS == "3"
		
		//-- Seleciona a tabela de pedidos de venda.
	    /*
	    Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
		*/
		
		DbSelectArea("SC5")
		DbOrderNickName("SC5_10")    //-- C5_FILIAL + C5_NUMATEX
		
		//+-------------------------------------------------------------------------+
		//| Caso exista pedido de venda para a OS, o sistema nao deixará finalizar. |
		//+-------------------------------------------------------------------------+
		If SC5->(DbSeek(xFilial("SC5") + PA0->PA0_OS))
			MsgStop("Erro ao finalizar a ordem de serviço. O atendimento: " + PA0->PA0_OS + " esta vinculado ao pedido de venda: " + SC5->C5_NUM, "ERRO-001 | CSAG0008")
		Else
		
			//+------------------------------------------------------------+
			//| Alimenta opções de transporte com base no SX5 - Tabela ZG. |
			//+------------------------------------------------------------+
			DbSelectArea("SX5")
			DbSetOrder(1)
			If DbSeek(xFilial("SX5")+"ZG")
				While SX5->(!Eof()) .And. SX5->X5_TABELA == "ZG"
					AAdd(aTipo,AllTrim(SX5->X5_DESCRI))
					SX5->(DbSkip())
				EndDo
			EndIf
			
			//+---------------------------------------+
			//| Definição da janela e seus conteúdos. |
			//+---------------------------------------+
			DEFINE MSDIALOG oDlg TITLE "Retorno OS" FROM 0,0 TO 320,800 OF oDlg PIXEL
				@ 06,06 TO 60,397 LABEL "Cabeçalho de OS" OF oDlg PIXEL
			
				@ 15, 15 SAY "Numero de OS" SIZE 45,8 PIXEL OF oDlg
				@ 25, 15 SAY PA0->PA0_OS SIZE 80,10 PIXEL OF oDlg
				
				@ 15,60 SAY "Cliente" SIZE 45,8 PIXEL OF oDlg
				@ 25,60 SAY PA0->PA0_CLLCNO SIZE 120,10 PIXEL OF oDlg
				
				@ 15,200 SAY "Data Abertura" SIZE 35,8 PIXEL OF oDlg
				@ 25,200 SAY PA0->PA0_DTABER SIZE 76,10 PIXEL OF oDlg
				
				@ 15,250 SAY "Data Fechamento" SIZE 45,8 PIXEL OF oDlg
				@ 25,250 MSGET dDtFec SIZE 35,8 PIXEL OF oDlg PICTURE "@D 99/99/9999"
				
				@ 15,320 SAY "Hora Fechamento" SIZE 45,8 PIXEL OF oDlg 
				@ 25,320 MSGET cHorFec SIZE 20,8 PIXEL OF oDlg PICTURE "@! 99:99"
				
				@ 35,60 SAY "Usuario Logado" SIZE 45,8 PIXEL OF oDlg 
				@ 45,60 SAY cNomeUser SIZE 120,10 PIXEL OF oDlg
				
				@ 35,200 Say "Transporte" of oDlg Pixel
				@ 45,200 ComboBox cTipo Items aTipo Size 45,8 PIXEL OF oDlg
				
				@ 35,250 SAY "Custo Desl." SIZE 45,8 PIXEL OF oDlg 
				@ 45,250 MSGET cCusto SIZE 20,8 PIXEL OF oDlg PICTURE "@E 999.99"
			 	
				@ 45,320 BUTTON "Anexar OS" SIZE 45,8 PIXEL OF oDlg ACTION cCaminho := cGetFile('Arquivo *|*.*|Arquivo PDF|*.pdf','Selecione a Ordem de Serviço',1,'C:\',.F.,GETF_LOCALHARD,.F.)
			
				@ 70,06 TO 135,397 LABEL "Detalhes OS" OF oDlg PIXEL
			
				If Select("_PA1") > 0
					DbSelectArea("_PA1")
					DbCloseArea("_PA1")
				End If 
				
				cQRYPA1 := " SELECT * "
				cQRYPA1 += " FROM "+ RETSQLNAME("PA1")
				cQRYPA1 += " WHERE D_E_L_E_T_ = '' "
				cQRYPA1 += " AND PA1_FILIAL = '" + xFilial("PA1") + "' "
				cQRYPA1 += " AND PA1_OS = '" + PA0->PA0_OS + "' "
				cQRYPA1 += " AND PA1_FATURA ='F' "
				
				cQRYPA1 := changequery(cQRYPA1)
				   	
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQRYPA1),"_PA1",.F.,.T.)
		  
				//-- Array com as informações carregadas no Listbox - Detalhes 				   
				While !Eof("_PA1")
			
					++nATListBox
					aAdd(aPa1, { 	_PA1->PA1_ITEM 	,;
									_PA1->PA1_PRODUT 	,;
									_PA1->PA1_DESCRI	,;	 		
									"   "				,;
									"   "				}) 
	    			dbSkip()  				  
				End
				
				IF Len(aPa1) == 0
			
					MsgAlert("Não ha dados para montar a consulta","ALRT-001 | CSAG0008")
					Return
				
				End If
		
				@ 80,15 LISTBOX oLbe FIELDS HEADER "Item", "Produto", "Descricao", "Realizado?", "Motivo" SIZE 375, 50 OF oDlg PIXEL
			
				oLbe:bLDblClick := { |nRow,nCol,nFlags| EditBox(@nRow,@nCol,@nFlags) }
				oLbe:SetArray(aPa1)
				oLbe:bLine := {|| {	aPa1[oLbe:nAt,1] ,;
										aPa1[oLbe:nAt,2] ,;
										aPa1[oLbe:nAt,3] ,;
										aPa1[oLbe:nAt,4] ,;
										aPa1[oLbe:nAt,5] }}
				
				oBloqCBox := TComboBox():New(;
													aObjSize[2,1]+15,;					//-- <nRow>
													(((aObjSize[2,4]/100 )*30)+10),;	//-- <nCol>
													bBloqComboBoxSetGet,;				//-- bSETGET(<cVar>)
													aBloqBox,;								//-- <aItems>
													80,;									//-- <nWidth>
													50,;									//-- <nHeight>
													oLbe,;									//-- <oWnd>
													NIL,;									//-- <nHelpId>
													NIL,;									//-- [{|Self|<uChange>}]
													NIL,;									//-- <{uValid}>
													NIL,;									//-- <nClrText>
													NIL,;									//-- <nClrBack>
													.T.,;									//-- <.pixel.>
													NIL,;									//-- <oFont>
													NIL,;									//-- <cMsg>
													.T.,;									//-- <.update.>
													NIL,;									//-- <{uWhen}>
													.T.,;									//-- <.design.>
													NIL,;									//-- <acBitmaps>
													NIL,;									//-- [{|nItem|<uBmpSelect>}]
													NIL,;									//-- ???
													cBloqCBox;								//-- <(cVar)>
													)								
						                               		
				//-- Botoes da MSDialog	  
				@ 140,320 BUTTON "&Ok"       SIZE 36,12 PIXEL ACTION IIF(lRet := CSAGVALID(),IIF(lRet := CSAGGRAVA(),oDlg:End(),.F.),.F.)
				@ 140,360 BUTTON "&Cancelar" SIZE 36,12 PIXEL ACTION oDlg:End()
				
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( oLbe:SetFocus() )
			
		EndIf
			
	ELSE
	
		MsgAlert("Não é possivel finalizar esta ordem de serviço, pois a mesma não se encontra liberada.","ALRT-002 | CSAG0008")
		
	END IF
	
	oBrowse:Refresh()

Return


//+----------+-----------+------+------------------------+-----+-----------+
//|PROGRAMA  |EditBox    |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+-----------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Edição da listbox.                                           |
//+----------+-------------------------------------------------------------+
//|USO       |Especifico CertiSign                                         |
//+----------+-------------------------------------------------------------+
Static Function EditBox(nRow,nCol,nFlags) 

	Local lEdit	:= .F.

	IF ( ( nATListBox > 0 ) .and. ( oLbe:ColPos == 4  ) )
		EditLBoxCBox(@oLbe,@aBloqBox,@oLbe:ColPos)
		Eval( oLbe:bLine )
	ELSE 
	
		IF aPa1[ oLbe:nAT,4] == "NAO"
			IF	( ( nATListBox > 0 ) .and. ( oLbe:ColPos == 5  ) )
				EditLBoxCBox(@oLbe,@aBloqBox2,@oLbe:ColPos)
				Eval( oLbe:bLine )
			ENDIF
		END IF	
		
	ENDIF

Return( lEdit )


//+----------+-------------+------+------------------------+-----+-----------+
//|PROGRAMA  |EditLBoxCBox |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+-------------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Edição.                                                        |
//+----------+---------------------------------------------------------------+
//|USO       |Especifico CertiSign                                           |
//+----------+---------------------------------------------------------------+
Static Function EditLBoxCBox( oLbe , aBloqBox , nColPos )

	Local aDim
	Local bSetGet		:= { |u| IF( nATListBox > 0,													;
										IF( PCount() == 0,												;
											oLbe:aArray[oLbe:nAT][nColPos],								;
											oLbe:aArray[oLbe:nAT][nColPos] := SubStr( u , 1 , 3 )	;
										),																	;
									NIL																		;
								 )																			;
							}
	Local oDlg
	Local oComboBox


	GetCellRect( @oLbe , @aDim )	//Obtenho as Coordenadas da Celula
	DEFINE MSDIALOG oDlg FROM 0,0 TO 0,0 STYLE nOR( WS_VISIBLE , WS_POPUP ) PIXEL WINDOW oLbe:oWnd
		oComboBox	:= TComboBox():New(;
											0,;																				//-- <nRow>
											0,;																				//-- <nCol>
											bSetGet,;																		//-- bSETGET(<cVar>)
											aBloqBox,;																		//-- <aItems>
											80,;																			//-- <nWidth>
											50,;																			//-- <nHeight>
											oDlg,;																			//-- <oWnd>
											NIL,;																			//-- <nHelpId>
											NIL,;																			//-- [{|Self|<uChange>}]
											{ ||IIF(oLbe:aArray[oLbe:nAT][nColPos] == oLbe:aArray[oLbe:nAT,5],;
											IIF(oLbe:aArray[oLbe:nAT,4]=="NAO",.T.,.F.),.T.)},;						//-- <{uValid}>
											NIL,;																			//-- <nClrText>
											NIL,;																			//-- <nClrBack>
											.T.,;																			//-- <.pixel.>
											NIL,;																			//-- <oFont>
											NIL,;																			//-- <cMsg>
											.T.,;																			//-- <.update.>
											NIL,;																			//-- <{uWhen}>
											.F.,;																			//-- <.design.>
											NIL,;																			//-- <acBitmaps>
											NIL,;																			//-- [{|nItem|<uBmpSelect>}]
											NIL,;																			//-- ???
											oLbe:aArray[oLbe:nAT][nColPos];												//-- <(cVar)>
										)
										
		oComboBox:Move( -2 , -2 , ( ( aDim[ 4 ] - aDim[ 2 ] ) + 4 ) , ( ( aDim[ 3 ] - aDim[ 1 ] ) + 4 ) )
		oDlg:Move( aDim[1] , aDim[2] , ( aDim[4]-aDim[2] ) , ( aDim[3]-aDim[1] ) )
		@ 0, 0 BUTTON oBtn PROMPT "" SIZE 0,0 OF oDlg
		oBtn:bGotFocus := { || oDlg:nLastKey := VK_RETURN , oDlg:End(0) }
		
	ACTIVATE MSDIALOG oDlg

Return( NIL )


//+----------+-----------+------+------------------------+-----+-----------+
//|PROGRAMA  |CSAGVALID  |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+-----------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Validação do botão OK.                                       |
//+----------+-------------------------------------------------------------+
//|USO       |Especifico CertiSign                                         |
//+----------+-------------------------------------------------------------+
Static Function CSAGVALID()

	Local lRet    := .F.
	Local dDataAt := dDataBase
	Local cHoraAb := PA0->PA0_HORABR
	Local cHoraAt := TIME()
	Local aPa1Val := {}
	Local aErro   := {}

	If !Empty(cCaminho) //Tratamento para não permitir o fechamento da OS sem anexo
	
		//Valida existencia de itens que não foram atendidos e se existe motivo informado
		For nConta := 1 To Len(oLbe:aArray)
		
			If !Empty(oLbe:aArray[nConta][4])
		
				aAdd(aPa1Val,{oLbe:aArray[nConta][4]})
			
				IF oLbe:aArray[nConta][4] == "NAO" .and. Empty(oLbe:aArray[nConta][5])
			
					aAdd(aErro,{aPa1})
				
				END IF
				
			Else
			
				aAdd(aErro,{aPa1})
				
			End If
			
		
		Next nConta
		//Valida data do fechamento da OS
		IF dDataAt < dDtFec .or. cHorFec > cHoraAt
					
			MsgAlert("A Data e ou hora de fechamento não pode ser superior a data e hora atual.","ALRT-003 | CSAG0008")
			lRet := .F.
				
		ELSE
				
			IF dDtFec < PA0->PA0_DTABER
				
				lRet := .F.
				MsgAlert("A Data de Fechamento não pode ser menor que a data de Abertura da OS.","ALRT-004 | CSAG0008")
					
			ELSE
				
				IF dDtFec == PA0->PA0_DTABER
					
					IF cHoraAb > cHorFec
						
						MsgAlert("A Hora de Fechamento não pode ser inferior a hora e data de abertura da OS.","ALRT-005 | CSAG0008")
						lRet := .F.
							
					ELSEIF Len(aErro) > 0	
					
						MsgAlert("É necessario o preenchimento se o atendimento foi realizado e se não, é obrigatorio o preenchimento de todos os motivos de produtos com atendimento não realizado.","ALRT-006 | CSAG0008")
						lRet := .F.
						
					ELSE
						
						lRet := .T.
							
					END IF
						
				ELSE
				
					lRet := .T.
					
				End If
					
			END IF
			
		End If
		
		//Renato Ruy -30/01/17
		//Informar o valor para taxi e o tipo do transporte na finalização.
		IF cTipo == "T" .And. round(cCusto,2) <= 0.00
					
			MsgAlert("Quando o transporte informado é um Táxi, o custo de deslocamento é obrigatório.","ALRT-007 | CSAG0008")
			lRet := .F.
	
		EndIf
		
		If Len(aErro) > 0	
					
			MsgAlert("É necessario o preenchimento se o atendimento foi realizado, e se não é obrigatorio o preenchimento de todos os motivos de produtos com atendimento não realizado.","ALRT-008 | CSAG0008")			
			lRet := .F.
						
		End If
	
	Else
	
		MsgAlert("É obrigatorio a inclusão da ordem de serviço digitalizada no fechamento da OS!","ALRT-009 | CSAG0008")
		lRet := .F.
		
	End If

Return( lRet )


//+----------+-----------+------+------------------------+-----+-----------+
//|PROGRAMA  |CSAGGRAVA  |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+-----------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Gravação dos dados.                                          |
//+----------+-------------------------------------------------------------+
//|USO       |Especifico CertiSign                                         |
//+----------+-------------------------------------------------------------+
Static Function CSAGGRAVA()

	Local aBotoes   := {}
	Local cAltera   := ""
	Local nI
	Local oDlg
	Local oGetDados
	Local cLinOk    := "AllwaysTrue"
	Local cTudoOk   := "AllwaysTrue"
	Local lMemoria  := .T.
	Local cFieldOk  := "AllwaysTrue"
	Local cSuperDel := ""
	Local cDelOk    := "AllwaysFalse"
	Local lOk       := .F.
	Local lRet      := .T.
	
	//Modificação para geração do pedido antes da gravaçãos dos demais dados e assim evitar a perca de referencia necessaria.
	lRet := U_CSFSGERP(IIF(Empty(_NumOs),_OldOs, _NumOs))

	if !lRet
	
	 	Aviso("Solicitação de Atendimento", "Pedido não foi gerado e nem a OS finalizada, favor verificar os dados da OS e tentar novamente!", {"Ok"})
	 	Return lRet
	
	End If 

	//Verifica novamente se existem pedencias para os.
	For nConta := 1 To Len(oLbe:aArray)
		
		IF oLbe:aArray[nConta][4] == "NAO"
		
			nResult++
			
		END IF	
		
	Next nConta
	
	// Atualiza status da agenda. Finaliza o Status na Agenda.
	dBSelectArea("PAW")
	dbSetOrder(4)
	dbSeek(xFilial("PAW")+PA0->PA0_OS)
	
	WHILE PAW->(!EOF()).AND. PAW->PAW_OS == PA0->PA0_OS
	
		BEGIN TRANSACTION                         
			RecLock("PAW",.F.)
				PAW->PAW_STATUS		:= "F"
			MsUnlock()
		END TRANSACTION
		
		PAW->(dbSKIP())
		
	END DO

	n := 0
	
	dBSelectArea("PA1")
	dbSetOrder(1)
	dbSeek(xFilial("PA1")+PA0->PA0_OS)
	//identifica os itens pendentes da OS e atualiza status de finalização dos itens
	While PA1->(!EOF()) .AND. PA1->PA1_OS == PA0->PA0_OS
	
		If PA1->PA1_FATURA =='F'  
	
			For n := 1 To Len(oLbe:aArray)
			
				cItem := oLbe:aArray[n][1]
		
				If cItem == PA1->PA1_ITEM
			
					BEGIN TRANSACTION                         
						RecLock("PA1",.F.)
							PA1->PA1_REALIZ		:= oLbe:aArray[n][4]
							PA1->PA1_MOTIVO		:= oLbe:aArray[n][5]
						MsUnlock()
					END TRANSACTION
				
				End If
			
			Next n
		
		End If
		
		PA1->(dBSkip())
			
	End Do

	aAuto := {}
	aPA1M := {}
	aPA0M := {}
	cTime := Time()

	cHour := SubStr( cTime, 1, 2 ) // Resultado: 10
	cMin  := SubStr( cTime, 4, 2 ) // Resultado: 37
	cSecs := SubStr( cTime, 7, 2 ) // Resultado: 17
	cTime := cHour +":"+ cMin      // Resultado: 10:37

	dBSelectArea("PA1")
	dbSetOrder(1)
	dbSeek(xFilial("PA1")+PA0->PA0_OS)
	//verifica se existem itens não atendidos na OS e armazena os itens para geração de uma nova OS para os itens pendentes
	While PA1->(!EOF()) .AND. PA1->PA1_OS == PA0->PA0_OS
		
			If PA1->PA1_REALIZ == "NAO"
			
				aAdd( aPA1M ,{"PA1_FILIAL" ,PA1->PA1_FILIAL })
				aAdd( aPA1M ,{"PA1_OS"     ,PA1->PA1_OS     })
				aAdd( aPA1M ,{"PA1_ITEM"   ,PA1->PA1_ITEM   })
				aAdd( aPA1M ,{"PA1_PRODUT" ,PA1->PA1_PRODUT })
				aAdd( aPA1M ,{"PA1_DESCRI" ,PA1->PA1_DESCRI })
				aAdd( aPA1M ,{"PA1_QUANT"  ,PA1->PA1_QUANT  })
				aAdd( aPA1M ,{"PA1_PRCUNI" ,PA1->PA1_PRCUNI })
				aAdd( aPA1M ,{"PA1_VALOR"  ,PA1->PA1_VALOR  })
				aAdd( aPA1M ,{"PA1_CLADHR" ,PA1->PA1_CLADHR })
				aAdd( aPA1M ,{"PA1_CNPJ"   ,PA1->PA1_CNPJ   })
				aAdd( aPA1M ,{"PA1_TES"    ,PA1->PA1_TES    })
				aAdd( aPA1M ,{"PA1_FATURA" ,PA1->PA1_FATURA })
				aAdd( aPA1M ,{"PA1_VOUCHE" ,PA1->PA1_VOUCHE })
				aAdd( aPA1M ,{"PA1_PEDIDO" ,PA1->PA1_PEDIDO })
				aAdd( aPA1M ,{"PA1_MSPED"  ,PA1->PA1_MSPED  })
				aAdd( aPA1M ,{"PA1_REALIZ" ,PA1->PA1_REALIZ })
				aAdd( aPA1M ,{"PA1_MOTIVO" ,PA1->PA1_MOTIVO })
				aAdd( aPA1M ,{"PA1_NPSITE" ,PA1->PA1_NPSITE })
			
			End If		
	
		PA1->(dBSkip())
	
	End Do

	cTexto := "Esta OS esta sendo finalizada e possui pendencias de atendimento, será gerado uma nova OS com os atendimentos pendentes." + CRLF
	cTexto += "Deseja abrir esta OS?"
				
	aButtons := {}

	If nResult > 0
	
		_NumOS := GETSXENUM("PA0","PA0_OS")
			
		If lOk := MSGYESNO( cTexto, "Abertura de OS" )
					
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("PA1")
						
			While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
						
				If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
						 	
					nUsado++
								
					Aadd(aHeader,{ TRIM(X3Titulo()),;
									 SX3->X3_CAMPO,;
									 SX3->X3_PICTURE,;
									 SX3->X3_TAMANHO,;
									 SX3->X3_DECIMAL,;
									 SX3->X3_VALID,;
									 SX3->X3_USADO,;
									 SX3->X3_TIPO,;
									 SX3->X3_F3,;
									 SX3->X3_CONTEXT })
								
				EndIf
							
				dbSkip()
							
			End Do
					
			Aadd(aCols,Array(nUsado+1))
			
			nItemPA1 := Val(PA1->PA1_ITEM)
						
			For nI	:= 1 To nUsado
							
				aCols[1][nI] := CriaVar(aHeader[nI][2])
			
				If ( AllTrim(aHeader[nI][2]) == "PA1_ITEM" )
				
					nItemPA1++
					aCols[1][nI] := STRZERO(nItemPA1, 4, 0)
					cInicio      := aCols[1][nI]
			
				End If
			
			Next nI
		
			aCols[1][nUsado+1] := .F.
					
			DEFINE MSDIALOG oDlg TITLE "Produtos para Atendimento Externo" FROM 00,00 TO 200,600 PIXEL
					 	
			oGetDados := MsNewGetDados():New(05,05,80,290,3,cLinOk,cTudoOk,,,1,10,cFieldOk,cSuperDel,cDelOk, oDlg, aHeader, aCols)
			oGetDados:Acols[1][1] := "0099"
		
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||oDlg:End()}, {||oDlg:End()},,aBotoes)
			
			aCols:=aClone(oGetDados:Acols)
					 	
			For n := 1 To Len(aCols)
			 	///???????????		 
				aAdd( aPA1M ,{"PA1_FILIAL" ,PA1->PA1_FILIAL													})
				aAdd( aPA1M ,{"PA1_OS"     ,PA1->PA1_OS														})
				aAdd( aPA1M ,{"PA1_ITEM"   ,aCols[n][1]														})
				aAdd( aPA1M ,{"PA1_PRODUT" ,aCols[n][2]														})
				aAdd( aPA1M ,{"PA1_DESCRI" ,POSICIONE("SB1",1,xFilial("SB1")+aCols[n][2], "B1_DESC")	})
				aAdd( aPA1M ,{"PA1_QUANT"  ,aCols[n][4]														})
				aAdd( aPA1M ,{"PA1_PRCUNI" ,aCols[n][5]														})
				aAdd( aPA1M ,{"PA1_VALOR"  ,aCols[n][6]														})
				aAdd( aPA1M ,{"PA1_CLADHR" ,aCols[n][7]														})
				aAdd( aPA1M ,{"PA1_CNPJ"   ,aCols[n][8]														})
				aAdd( aPA1M ,{"PA1_TES"    ,PA1->PA1_TES														})
				aAdd( aPA1M ,{"PA1_FATURA" ,aCols[n][9]														})
				aAdd( aPA1M ,{"PA1_VOUCHE" ,aCols[n][10]														})
				aAdd( aPA1M ,{"PA1_PEDIDO" ,aCols[n][11]														})
				aAdd( aPA1M ,{"PA1_MSPED"  ,aCols[n][12]														})
				aAdd( aPA1M ,{"PA1_REALIZ" ,""																	})
				aAdd( aPA1M ,{"PA1_MOTIVO" ,""																	})
				aAdd( aPA1M ,{"PA1_NPSITE" ,aCols[n][13]														})
					 		
			Next n
					 	
		Else
		
			aPA1M := {}
		
		End If
		
		lRet := .T.
		
	Else
	
		aPA1M := {}
		lRet  := .T.
		
	End If
	// Captura os dados do cabeçalho da OS de origem para geração de uma nova OS com as pendências
	If Len(aPA1M) > 0
	
		aAdd( aPA0M ,{"PA0_FILIAL" ,PA0->PA0_FILIAL											})
		aAdd( aPA0M ,{"PA0_OS"     ,_NumOs														})
		aAdd( aPA0M ,{"PA0_OLDNUM" ,_OldOs														})
		aAdd( aPA0M ,{"PA0_CLILOC" ,PA0->PA0_CLILOC											})
		aAdd( aPA0M ,{"PA0_LOJLOC" ,PA0->PA0_LOJLOC											})
		aAdd( aPA0M ,{"PA0_CLLCNO" ,PA0->PA0_CLLCNO											})
		aAdd( aPA0M ,{"PA0_CLIFAT" ,PA0->PA0_CLIFAT											})
		aAdd( aPA0M ,{"PA0_LOJAFA" ,PA0->PA0_LOJAFA											})
		aAdd( aPA0M ,{"PA0_CLFTNM" ,PA0->PA0_CLFTNM											})
		aAdd( aPA0M ,{"PA0_END"    ,PA0->PA0_END												})
		aAdd( aPA0M ,{"PA0_BAIRRO" ,PA0->PA0_BAIRRO											})
		aAdd( aPA0M ,{"PA0_CEP"    ,PA0->PA0_CEP												})
		aAdd( aPA0M ,{"PA0_CIDADE" ,PA0->PA0_CIDADE											})
		aAdd( aPA0M ,{"PA0_ESTADO" ,PA0->PA0_ESTADO											})
		aAdd( aPA0M ,{"PA0_CONTAT" ,PA0->PA0_CONTAT											})
		aAdd( aPA0M ,{"PA0_DDD"    ,PA0->PA0_DDD												})
		aAdd( aPA0M ,{"PA0_TEL"    ,PA0->PA0_TEL												})
		aAdd( aPA0M ,{"PA0_RAMAL"  ,PA0->PA0_RAMAL											})
		aAdd( aPA0M ,{"PA0_REGIAO" ,PA0->PA0_REGIAO											})
		aAdd( aPA0M ,{"PA0_CONDPA" ,PA0->PA0_CONDPA											})
		aAdd( aPA0M ,{"PA0_TRANSP" ,PA0->PA0_TRANSP											})
		aAdd( aPA0M ,{"PA0_CUSTRA" ,PA0->PA0_CUSTRA											})
		aAdd( aPA0M ,{"PA0_DTAGEN" ,dDataBase													})
		aAdd( aPA0M ,{"PA0_HRAGEN" ,cTime														})
		aAdd( aPA0M ,{"PA0_OBS"    ,"OS GERADA AUTOMATICAMENTO POR CONTER PENDENCIAS"	})
		aAdd( aPA0M ,{"PA0_STATUS" ,"6"															})
		aAdd( aPA0M ,{"PA0_DTINC"  ,dDataBase													})
		aAdd( aPA0M ,{"PA0_ENDFAT" ,PA0->PA0_ENDFAT											})
		aAdd( aPA0M ,{"PA0_CGCFAT" ,PA0->PA0_CGCFAT											})
		aAdd( aPA0M ,{"PA0_BAIFAT" ,PA0->PA0_BAIFAT											})
		aAdd( aPA0M ,{"PA0_CEPFAT" ,PA0->PA0_CEPFAT											})
		aAdd( aPA0M ,{"PA0_CIDFAT" ,PA0->PA0_CIDFAT											})
		aAdd( aPA0M ,{"PA0_ESTFAT" ,PA0->PA0_ESTFAT											})
		aAdd( aPA0M ,{"PA0_EMAIL"  ,PA0->PA0_EMAIL											})
		aAdd( aPA0M ,{"PA0_DTABER" ,dDataBase													})
		aAdd( aPA0M ,{"PA0_HORABR" ,cTime														})
		aAdd( aPA0M ,{"PA0_TIPATE" ,PA0->PA0_TIPATE											})
		aAdd( aPA0M ,{"PA0_COMPLE" ,PA0->PA0_COMPLE											})
		aAdd( aPA0M ,{"PA0_FATCOM" ,PA0->PA0_FATCOM											})
		aAdd( aPA0M ,{"PA0_CONAGE" ,PA0->PA0_CONAGE											})		
	
		aAdd( aAuto ,{'PA0MASTER' ,aPA0M })
		aAdd( aAuto ,{'PA1DETAIL' ,aPA1M })
		
		lOk := U_CSAGEROS(aAuto)
	
	End If
	
	//reposiciona a OS de Origem
	dBSelectArea("PA0")
	dbSetOrder(1)
	dbSeek(xFilial("PA0")+_OldOs)
	// Atualiza OS com data de fechamento/hora e custo de delocamento
	If !empty(_OldOs).and. PA0->(Found())     
	
		cProtocolo := PA0->PA0_PROTOC  //?????  mudei para este ponto porque estava pegando dado de fianl de arquivo 
	
		BEGIN TRANSACTION
	                         	
			RecLock("PA0",.F.)
			PA0->PA0_STATUS := IIF(nResult > 0, "7", "5")
			PA0->PA0_DTFECH := dDtFec
			PA0->PA0_HORFEC := cHorFec
			PA0->PA0_CUSTRA := cCusto
			PA0->PA0_USER   := cNomeUser
			PA0->PA0_TRANSP := cTipo
			MsUnlock()
			
		END TRANSACTION
		
	End If
	
	//Posiciona na nova OS gerada   e atualiza status para "6" Porque????
	dBSelectArea("PA0")
	dbSetOrder(1)
	dbSeek(xFilial("PA0")+_NumOs)
	
	If !empty(_NumOs).and. PA0->(Found())
	                                      	
   		cProtocolo := PA0->PA0_PROTOC         //?????

		If !Empty(_NumOS)
	
			BEGIN TRANSACTION 
		                        	
				RecLock("PA0",.F.)
				PA0->PA0_STATUS		:= "6"
				MsUnlock()
				
			END TRANSACTION
			
		End If
		
	End If
	
	//Prepara gravação do anexo na Ordem de serviço. 
	cAnexo    := IIF(Empty(_NumOs),_OldOs,_NumOs)
	cFileName := cCaminho
	cNumAtend := cProtocolo //Protocolo da OS de Origem
	cFilent   := xFilial( 'PA0' )	
	cAliasb   := "PA0"
	
	//ações e ocorrências para finalização da ordem de serviço
	cOcor := '006448'
	cAcao := '000267'
	
	//Posiciona no atendimento para gravação da interação	//?? validar se existe numero de protocolo
	dbSelectArea("ADE")
	dbSetOrder(1)
	dbSeek(xFilial("ADE")+cNumAtend)
		
	If !Empty(cNumAtend) .and. ADE->(Found()) 
	
		codChama := ADE->ADE_CODIGO
				
		BEGIN TRANSACTION                         
		
			RecLock("ADE",.F.)	
			ADE->ADE_STATUS := "3"				
			MsUnlock()
	
		END TRANSACTION
				
		dbSelectArea("ADF")
		dbSetOrder(1)
		dbSeek(xFilial("ADF")+cNumAtend)		
				
		BEGIN TRANSACTION                         
		
			RecLock("ADF",.T.)
			ADF->ADF_CODIGO := codChama
			ADF->ADF_ITEM   := NextNumero("ADF",1,"ADF_ITEM",.T.,)
			ADF->ADF_CODSU9 := cOcor
			ADF->ADF_CODSUQ := cAcao
			ADF->ADF_CODSU7 := "000001"
			ADF->ADF_CODSU0 := "9G"
			ADF->ADF_DATA   := dDataBase
			ADF->ADF_HORA   := Time()	
			ADF->ADF_HORAF  := Time()
			ADF->ADF_OS     := _NumOs	
			MsUnlock()
		
		END TRANSACTION
				
		ConOut("Chamado finalizado com sucesso! Codigo=" + codChama)		
	
		lRet := .T.
				
	End If
	//anexa o PDF da OS assinada no banco de conhecimento da OS e do Protocolo de atendimento do Service Desk	
	if lRet := FAT30Anexar(cAnexo, cFileName, IIF(Empty(_NumOs),_OldOs,_NumOs))
		
		cFilent := xFilial( 'ADE' )
		
		cAliasb := "ADE"
			
		cNumAtend := cFilent+cProtocolo
		//Não é necessário subir duas vezes. deve-se apenas referenciar o objeto gravado na OS. //??? 
		if lRet := FAT30Anexar(cAnexo, cFileName, cNumAtend)
			
		Endif
			
	Else
		MsgAlert("Não foi possivel anexar o documento ao banco de conhecimento","ALRT-010 | CSAG0008")
		lRet := .F.
			
	Endif 
	//reposiciona OS. Seja nova ou de origem
	dbSelectArea("PA0")
	dbSetOrder(1)
	dbSeek(xFilial("PA0")+IIF(Empty(_NumOs),_OldOs, _NumOs))
									
	cMail      := PA0->PA0_EMAIL
	cAssuntoEm := 'Solicitação de atendimento - Finalização'   //Verificar se o assunto está de acordo com a ação. Neste caso é para finalziação
	cCase      := "FINALIZA"		
	//----------------------------------------------------------
	// Validacao para envio de Anexo no e-mail 
	//----------------------------------------------------------
	if csMVEnvEmail()
		cFileName  := MsDocPath() +  "\" + "OS" + cAnexo + ".PDF"	
	else
		cFileName := ""
	endif
	
	U_CSFSEmail(IIF(Empty(_NumOs),_OldOs, _NumOs), cFileName, cMail, cAssuntoEm, cCase)
	
	If lOk == .T.
		
		Aviso( "Solicitação de Atendimento", "OS finalizada com sucesso", {"Ok"} )
		
	Else 
		
		Aviso( "Solicitação de Atendimento", "OS finalizada com sucesso", {"Ok"} )
			
	End If
	
	//FreeObj(olbe)


Return( lRet )


//+----------+------------+------+------------------------+-----+-----------+
//|PROGRAMA  |FAT30Anexar |AUTOR |Claudio Henrique Corrêa |DATA |29/10/2015 |
//+----------+------------+------+------------------------+-----+-----------+
//|DESCRIÇÃO |Anexar arquivo.                                               |
//+----------+--------------------------------------------------------------+
//|USO       |Especifico CertiSign                                          |
//+----------+--------------------------------------------------------------+
Static Function FAT30Anexar(cAnexo, cFileName, cCodOp) 

	Local aArea       := GetArea()
	Local cDirDoc     := MsDocPath()
	Local cFile       := "OS"+cAnexo+".PDF"
	Local cACB_CODOBJ := ''
	Local lRet        := .F.	
	
	lRet := __CopyFile(cFileName,cDirDoc + "\" + cFile )
		
	If lRet
	
		DbSelectArea("ACB")
		DbSetOrder(1)
		DbSeek(xFilial("ACB")+cFile)
	
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')
		
		//-- Gravação na tabela: Bancos de Conhecimentos
		ACB->( RecLock( 'ACB', .T. ) )
			ACB->ACB_FILIAL := xFilial( 'ACB' )
			ACB->ACB_CODOBJ := cACB_CODOBJ
			ACB->ACB_OBJETO := cFile
			ACB->ACB_DESCRI := cAnexo
		ACB->( MsUnLock() )	
		ACB->( ConfirmSX8() )
		
		//-- Gravação na tabela: Relacao de Objetos x Entidades	
		AC9->( RecLock( 'AC9', .T. ) )
			AC9->AC9_FILIAL := xFilial( 'AC9' )
			AC9->AC9_FILENT := cFilent
			AC9->AC9_ENTIDA := cAliasb
			AC9->AC9_CODENT := cCodOp
			AC9->AC9_CODOBJ := cACB_CODOBJ
			AC9->AC9_DTGER  := dDataBase
		AC9->( MsUnLock() )

		//-- Gravação na tabela: Palavras-Chave                
		ACC->( RecLock( 'ACC', .T. ) )
			ACC->ACC_FILIAL := xFilial( 'ACC' ) 
			ACC->ACC_CODOBJ := cACB_CODOBJ
			ACC->ACC_KEYWRD := cCodOp + ' ' + cAnexo
		ACC->( MsUnLock() )
			
	EndIf
	
	RestArea(aArea)
	
Return( lRet )

//-------------------------------------------------------------------
/*{Protheus.doc} csMVEnvEmail
Funcao responsavel por verificar qual informacao esta o parametro
e atraves do parametro retorna se pode enviar o Anexo no email.

**********************
Solicitacao abaixo:

OTRS 2017032410001541 - Cancelamento do Envia automático de OS
Solicito configuração no protehus - módulo agendamento online - 
etapa de finalização de OS. 
Hoje ao finalizarmos uma OS o protheus envia automaticamente a OS 
anexada neste fechamento ao cliente, este envio automático deve 
ser cancelado. 

Obrigada. 
Atenciosamente, 
Dayane Mota 
**********************

@author  Douglas Parreja
@since   07/07/2017
@version 11.8
/*/
//-------------------------------------------------------------------	

static function csMVEnvEmail()

	local lMVRet	:= .F.
	local cMVEmail	:= 'MV_AGVMAIL'	
	local cExec		:= "Service-Desk x Checkout"

	//-------------------------------------------------------------------
	// MV_AGVMAIL - Define se podera enviar e-mail ou nao.
	//-------------------------------------------------------------------	
	if !GetMV( cMVEmail, .T. )
		CriarSX6( cMVEmail, 'L', 'Controle envia Anexo email Agend Externo -Finaliza', '.F.' )
		u_autoMsg(cExec, , "criado parametro MV_AGVMAIL - Envia e-mail Agend Externo (Finaliza)")
	endif
	
	lMVRet := getMv("MV_AGVMAIL")

return ( lMVRet )

