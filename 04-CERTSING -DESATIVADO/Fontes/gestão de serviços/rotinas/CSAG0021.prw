#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function CSAG0021(recno,oBrowse)

Local cOrdem 	:= PA0->PA0_OS
Local lRet		:= .F.
Local aModel	:= {"","","","","","","","","","","",""}
Local aOk		:= {}
Local cHora		:= {}
Local dDataV	:= NIL
Local aRet		:= {}
Local cCliFat	:= IIF(Empty(PA0->PA0_CLIFAT),PA0->PA0_CLILOC,PA0->PA0_CLIFAT)
Local cCliLoj	:= POSICIONE("SA1",1,xFILIAL("SA1")+cClifat, "A1_LOJA")
Local nSoma		:= 0
Local lPag		:= .F.

dbSelectArea("PA0")
dbSetOrder(1)
dbSeek(xFilial("PA0")+cOrdem)

If PA0->(Found())

	If PA0->PA0_STATUS == '4'
	
		If lRet := MSGYESNO( "Este atendimento encontrasse suspenso, deseja retirar a suspensão?", "Suspensão de Atendimento" )
		
			dbSelectArea("PA1")
			dbSetOrder(1)
			dbSeek(xFilial("PA1")+cOrdem)
			
			If PA1->(Found())
			
				While PA1->(!EOF()) .And. PA1->PA1_OS == cOrdem
				
					If PA1->PA1_OS == cOrdem
				
						aAdd(aModel,{"","","","","","","","","","","",PA1->PA1_FATURA})
						
						If PA1->PA1_FATURA $ "S"
						
							nSoma := nSoma + PA1->PA1_VALOR
							
							lPag := .T.
							
						End If
						
					End If
		
					PA1->(dbSkip())
				
				End
				
			End If 
			
			aOk		:= U_CSAG0010(cOrdem, aModel, PA0->PA0_REGIAO, PA0->PA0_AR)
			
			If aOk[1] == .T.
		
				cHoraAgenda := aOk[2]
				
				dbSelectArea("PAW")
				dbSetOrder(4)
				dbSeek(xFilial("PAW")+cOrdem)
				
				If PAW->(Found())
				
					dDataV := DataValida(DaySub(PAW->PAW_DATA , 2 ) ,.F.)
					
					If lPag == .T.
					
						/*
					
						cQrySE1 := " SELECT E1_OS "
						cQrySE1 += " FROM " + RetSqlName("SE1")
						cQrySE1 += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
						cQrySE1 += " AND D_E_L_E_T_ = '' "
						cQrySE1 += " AND E1_OS = '" + cOrdem + "'"
						
						cQrySE1 := changequery(cQrySE1)
	 							
	 					if Select("_SE1") > 0
	 							
	 						dbSelectArea("_SE1")
	 						dbCloseArea("_SE1")
	 								
	 					End If	
	 							
	 					dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQrySE1),"_SE1", .T., .F.)
	 					
	 					*/
	 					
	 					dbSelectArea("SE1")
	 					DbOrderNickName("ORD_SERV")
	 					dbSeek(xFilial("SE1")+cOrdem)
	 					
	 					If SE1->(Found())
		
							aRet := U_CSFSGBOL(cClifat,cOrdem,cCliloj,nSoma,dDataV)
							
							If aRet[1][1] == .T.
							
								cRN := aRet[1][3]
								dDataVen := aRet[1][2]
							
								BEGIN TRANSACTION   
				                      
									RecLock("PA0",.F.)
									PA0->PA0_DTAGEN := dDataV
									PA0->PA0_HRAGEN	:= cHoraAgenda
									PA0->PA0_STATUS := "1"
									PA0->PA0_LINDIG := cRN
									PA0->PA0_DTEBOL := Date()
									PA0->PA0_DTVBOL := dDataVen
									MsUnlock()
				
								END TRANSACTION
							
							End If
							
						Else
								
							BEGIN TRANSACTION   
				                      
								RecLock("PA0",.F.)
								PA0->PA0_DTAGEN := dDataV
								PA0->PA0_HRAGEN	:= cHoraAgenda
								PA0->PA0_STATUS := "2"
								MsUnlock()
				
							END TRANSACTION
						
						End If
						
					Else
					
						BEGIN TRANSACTION 
							
							RecLock("PA0",.F.)
							PA0->PA0_DTAGEN := dDataV
							PA0->PA0_HRAGEN	:= cHoraAgenda
							PA0->PA0_STATUS := "2"
							PA0->PA0_LINDIG := ""
							PA0->PA0_DTEBOL := Date()
							PA0->PA0_DTVBOL := dDataV
							MsUnlock()
					
						END TRANSACTION
					
					End If
					
				End If
		
			End If
			
		Else
		
			Return lRet
		
		End If
		
	ElseIf PA0->PA0_STATUS $ "2/3/6"
	
		If lRet := MSGYESNO( "Deseja suspender esta Ordem de Serviço?", "Suspensão de Atendimento" )
		
			BEGIN TRANSACTION   
			                      
				RecLock("PA0",.F.)
				PA0->PA0_DTAGEN := Date()
				PA0->PA0_HRAGEN	:= ""
				PA0->PA0_STATUS := "4"
				PA0->PA0_LINDIG := ""
				PA0->PA0_DTEBOL := Date()
				PA0->PA0_DTVBOL := Date()
				MsUnlock()
			
			END TRANSACTION
			
			dbSelectArea("PAW")
			dbSetOrder(4)
			dbSeek(xFilial("PAW")+cOrdem)
			
			If PAW->(Found())
			
				BEGIN TRANSACTION
	
					RecLock("PAW",.F.)
					DbDelete()
					MsUnlock()
	
				END TRANSACTION
			
			End If
			
			dbSelectArea("PA2")
			dbSetOrder(1)
			dbSeek(xFilial("PA2")+PAW->PAW_COD)
			
			If PA2->(Found())
			
				While PA2->(!EOF()) .AND. ALLTRIM(PA2->PA2_CODAGE)==ALLTRIM(PAW->PAW_COD) 
				
					BEGIN TRANSACTION
	
						RecLock("PA2",.F.)
						DbDelete()
						MsUnlock()
	
					END TRANSACTION
				
					PA2->(dbSkip())
				
				End			
			
			End If
			
			Aviso( "Suspensão de OS", "OS suspensa com sucesso", {"Ok"} )
			
		Else
		
			Return lRet
		
		End If
	
	Else
	
		MsgAlert("Não é possivel realizar a suspensão desta OS. Por favor verifique o status da mesma.")
		
		lRet := .F.
		
	End If
	
Else

	MsgAlert("Ordem de serviço não encontrada.")
	
End If

oBrowse:Refresh()
	
Return lRet
