#INCLUDE "Protheus.ch"
#INCLUDE "PARMTYPE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA010   ºAutor  ³Darcio R. Sporl     º Data ³  29/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer a atualizacao dos Postos no sistemaº±±
±±º          ³Protheus, trazendo as informacoes do sistema GAR.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ #TP20130218 - Restricao de Postos  / Inclusao do campo de  º±±
±±º          ³ rede.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA010( aParam )
	Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )
	Local aArea		:= {}
	Local aPosErro	:= {}
	Local nI		:= 0
	Local nJ		:= 0
	Local cCodAR	:= ""
	Local cDesAR	:= ""
	Local cCodPO	:= ""
	Local oObj	

	Private aAR		:= {}
	Private aPosto	:= {}

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	Conout( "[ VNDA010 (Importação Postos) - " + Dtoc( Date() ) + " - " + Time() + " ] INICIO" )
	aArea := GetArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama o WebService do sistema GAR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWSObj := WSIntegracaoGARERPImplService():New()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama a lista de AR's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWSObj:listaARs( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
					eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }) )

	aAR := aClone(oWSObj:CAR)

	Begin Transaction

		For nI := 1 To Len(aAR)

			Conout( "[ VNDA010 - " + Dtoc( Date() ) + " - " + Time() + " ] AR: " +  AllTrim(aAR[nI]:CID) )
			
			DbSelectArea("SZ3")
			DbSetOrder(4)
			//Renato Ruy - 02/08/2018
			//2018080110003554 ] Ajuste fonte VNDA010
			//Ajuste para nao travar a rotina se existir registro em lock
			If DbSeek(xFilial("SZ3") + AllTrim(aAR[nI]:CID)) .And. SZ3->(RLock())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se achar a AR, a mesma sera atualizada com as informacoes do GAR³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cCodAR := SZ3->Z3_CODENT
				cDesAR := SZ3->Z3_DESENT
				RecLock("SZ3", .F.)
					If ValType(aAR[nI]:CDESCRICAO) == "U"
						SZ3->Z3_DESENT	:= ""				//Descricao
					Else
						SZ3->Z3_DESENT	:= AllTrim(aAR[nI]:CDESCRICAO)	//Descricao
					EndIf
					SZ3->Z3_TIPENT	:= "3"					//Tipo
					If ValType(aAR[nI]:LATENDIMENTO) == "U"
						SZ3->Z3_ATENDIM	:= "N"				//Atendimento
					Else
						If aAR[nI]:LATENDIMENTO
							SZ3->Z3_ATENDIM	:= "S"				//Atendimento
						Else
							SZ3->Z3_ATENDIM	:= "N"				//Atendimento
						EndIf
					EndIf
					If ValType(aAR[nI]:LATIVO) == "U"
						SZ3->Z3_ATIVO	:= "N"				//Ativo
					Else
						If aAR[nI]:LATIVO
							SZ3->Z3_ATIVO	:= "S"				//Ativo
						Else
							SZ3->Z3_ATIVO	:= "N"				//Ativo
						EndIf
					EndIf
					If Empty(SZ3->Z3_ENTREGA)
						SZ3->Z3_ENTREGA		:= "N"				//Entrega
					EndIf				
				SZ3->(MsUnLock())
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso o sistema nao ache a AR, a mesma sera incluida³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cCodAR := GetSXENum('SZ3','Z3_CODENT')
				cDesAR := AllTrim(aAR[nI]:CDESCRICAO)
						
				RecLock("SZ3", .T.)
					SZ3->Z3_FILIAL	:= xFilial("SZ3")		//Filial Protheus
					SZ3->Z3_CODENT	:= cCodAR				//Codigo Protheus
					If ValType(aAR[nI]:CID) == "U"
						SZ3->Z3_CODGAR	:= ""				//Codigo GAR
					Else
						SZ3->Z3_CODGAR	:= AllTrim(aAR[nI]:CID)	//Codigo GAR
					EndIf
					If ValType(aAR[nI]:CDESCRICAO) == "U"
						SZ3->Z3_DESENT	:= ""				//Descricao
					Else
						SZ3->Z3_DESENT	:= AllTrim(aAR[nI]:CDESCRICAO)	//Descricao
					EndIf
					SZ3->Z3_TIPENT	:= "3"					//Tipo
					If ValType(aAR[nI]:LATENDIMENTO) == "U"
						SZ3->Z3_ATENDIM	:= "N"				//Atendimento
					Else
						If aAR[nI]:LATENDIMENTO
							SZ3->Z3_ATENDIM	:= "S"				//Atendimento
						Else
							SZ3->Z3_ATENDIM	:= "N"				//Atendimento
						EndIf
					EndIf
					If ValType(aAR[nI]:LATIVO) == "U"
						SZ3->Z3_ATIVO	:= "N"					//Ativo
					Else
						If aAR[nI]:LATIVO
							SZ3->Z3_ATIVO	:= "S"				//Ativo
						Else
							SZ3->Z3_ATIVO	:= "N"				//Ativo
						EndIf
					EndIf
					SZ3->Z3_ENTREGA		:= "N"					//Entrega
				SZ3->(MsUnLock())
				
				If __lSx8
					ConfirmSX8()
				Else
					RollBackSX8()
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Traz os postos referente a AR posicionada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oWSObj:postosParaIdAR( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
								eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
								aAR[nI]:CID )
			
			aPosto := aClone(oWSObj:OWSPOSTO)
			
			For nJ := 1 To Len(aPosto)
			
				DbSelectArea("SZ3")
				DbSetOrder(4)
				If ValType(aPosto[nJ]:NID) <> "U"
					Conout( "[ VNDA010 - " + Dtoc( Date() ) + " - " + Time() + " ] Posto: " +  AllTrim(Str(aPosto[nJ]:NID)) )
					
					//Renato Ruy - 02/08/2018
					//2018080110003554 ] Ajuste fonte VNDA010
					//Ajuste para nao travar a rotina se existir registro em lock
					If DbSeek(xFilial("SZ3") + AllTrim(Str(aPosto[nJ]:NID))) .And. SZ3->(RLock())
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Caso o sistema ache o Posto, o mesmo sera atualizado com as informacoes do GAR³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						RecLock("SZ3", .F.)

							If ValType(aPosto[nJ]:NID) == "U"
								SZ3->Z3_CODGAR	:= ""								//Codigo GAR
							Else
								SZ3->Z3_CODGAR	:= AllTrim(Str(aPosto[nJ]:NID))		//Codigo GAR
							EndIf
							If ValType(aPosto[nJ]:LATENDIMENTO) == "U"
								SZ3->Z3_ATENDIM	:= "N"								//Atendimento
							Else
								If aPosto[nJ]:LATENDIMENTO
									SZ3->Z3_ATENDIM	:= "S"							//Atendimento
								Else
									SZ3->Z3_ATENDIM	:= "N"							//Atendimento
								EndIf
							EndIf
							If ValType(aPosto[nJ]:LATIVO) == "U"
								SZ3->Z3_ATIVO	:= "N"								//Ativo
							Else
								If aPosto[nJ]:LATIVO
									SZ3->Z3_ATIVO	:= "S"							//Ativo
								Else
									SZ3->Z3_ATIVO	:= "N"							//Ativo
								EndIf                    
							EndIf
							
							If ValType(aPosto[nJ]:NCEP) == "U"
								SZ3->Z3_CEP		:= ""								//CEP
							Else
								SZ3->Z3_CEP		:= AllTrim(StrZero(aPosto[nJ]:NCEP,8))	//CEP
								DbSelectArea("PA7")
								DbSetOrder(1)
								If PA7->(DbSeek(xFilial("PA7")+AllTrim(StrZero(aPosto[nJ]:NCEP,8))))
									lPa7 := .t.
								Else
									lPa7 := .f.							
								EndIf
							EndIf
							
							If ValType(aPosto[nJ]:CBAIRRO) == "U"
								SZ3->Z3_BAIRRO	:= ""								//Bairro
							Else
								SZ3->Z3_BAIRRO	:= iif(lPa7 .AND. !Empty(PA7->PA7_BAIRRO), PA7->PA7_BAIRRO ,AllTrim(aPosto[nJ]:CBAIRRO))		//Bairro
							EndIf
							
							If ValType(aPosto[nJ]:CCIDADE) == "U"
								SZ3->Z3_MUNICI	:= ""								//Cidade
							Else
								SZ3->Z3_MUNICI	:= iif(lPa7 .AND. !Empty(PA7->PA7_MUNIC) , PA7->PA7_MUNIC ,AllTrim(UPPER(aPosto[nJ]:CCIDADE)))	//Cidade
							EndIf
							
							If ValType(aPosto[nJ]:CENDERECO) == "U"
								SZ3->Z3_LOGRAD	:= ""								//Endereço
							Else
								SZ3->Z3_LOGRAD	:= aPosto[nJ]:CENDERECO				//Endereço
							EndIf
							
							If ValType(aPosto[nJ]:CUF) == "U"
								SZ3->Z3_ESTADO	:= ""								//UF
							Else
								SZ3->Z3_ESTADO	:= iif(lPa7 .AND. !Empty(PA7->PA7_ESTADO) , PA7->PA7_ESTADO ,aPosto[nJ]:CUF)						//UF
							EndIf
							
							SZ3->Z3_NUMLOG	:= "s/n"
							
							If ValType(aPosto[nJ]:CCNPJ) == "U"
								SZ3->Z3_CGC		:= ""								//CNPJ
							Else
								SZ3->Z3_CGC		:= IIf(CGC(aPosto[nJ]:CCNPJ),aPosto[nJ]:CCNPJ,"")					//CNPJ
							EndIf
							
							If ValType(aPosto[nJ]:CDESCRICAO) == "U"
								SZ3->Z3_DESENT	:= aPosto[nJ]:CDESCRICAO			//Descricao
							Else
								SZ3->Z3_DESENT	:= aPosto[nJ]:CDESCRICAO			//Descricao
							EndIf

							If ValType(aPosto[nJ]:CNOMEFANTASIA) == "U"
								SZ3->Z3_NMFANT	:= ""								//Nome Fantasia
							Else
								SZ3->Z3_NMFANT	:= aPosto[nJ]:CNOMEFANTASIA			//Nome Fantasia
							EndIf

							If ValType(aPosto[nJ]:CRAZAOSOCIAL) == "U"
								SZ3->Z3_RAZSOC	:= ""								//Razão Social
							Else
								SZ3->Z3_RAZSOC	:= aPosto[nJ]:CRAZAOSOCIAL			//Razão Social
							EndIf
							
							SZ3->Z3_CODAR	:= cCodAR								//Codigo Protheus da AR
							SZ3->Z3_DESAR	:= cDesAR								//Descricao da AR
							
							If ValType(aPosto[nJ]:NTELEFONE) == "U"
								SZ3->Z3_TEL		:= ""								//Telefone
							Else
								SZ3->Z3_TEL		:= iif(Empty(Alltrim(Str(aPosto[nJ]:NTELEFONE))) .OR. aPosto[nJ]:NTELEFONE == 0 ,"1134789444",Alltrim(Str(aPosto[nJ]:NTELEFONE)))	//Telefone
							EndIf
							SZ3->Z3_TIPENT	:= "4"									//Tipo
							
												
							If ValType(aPosto[nJ]:LVISIBILIDADE) == "U"
								SZ3->Z3_VISIBIL	:= "N"								//Visibilidade
							Else
								If aPosto[nJ]:LVISIBILIDADE 
									SZ3->Z3_VISIBIL	:= "S"							//Visibilidade
								Else
									SZ3->Z3_VISIBIL	:= "N"							//Visibilidade
								EndIf
							EndIf
							
							If ValType(aPosto[nJ]:LVENDASHW) == "U"
								SZ3->Z3_ENTREGA		:= "N"							//Entrega
							Else
								If aPosto[nJ]:LVENDASHW 
									SZ3->Z3_ENTREGA		:= "S"							//Entrega
								Else
									SZ3->Z3_ENTREGA		:= "N"							//Entrega
								EndIf
							EndIf
							
							// #TP20130218 - Restricao de Postos / Inclusao do campo de rede
							If ValType(aPosto[nJ]:CREDE) == "U"
								SZ3->Z3_REDE	:= Alltrim(aPosto[nJ]:CREDE)					//Rede
							Else
								SZ3->Z3_REDE	:= Alltrim(aPosto[nJ]:CREDE)					//Rede
							EndIf

							SZ3->Z3_LATITUD	:= IIF( ValType(aPosto[nJ]:CLATITUDE)=='U'	, "", Alltrim(cValToChar(aPosto[nJ]:CLATITUDE))  )
							SZ3->Z3_LONGITU	:= IIF( ValType(aPosto[nJ]:CLONGITUDE)=='U'	, "", Alltrim(cValToChar(aPosto[nJ]:CLONGITUDE)) )

						SZ3->(MsUnLock())
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿\¿
						//³Caso o sistema nao ache o posto, o mesmo sera incluido e vincluado a sua AR, ³
						//³a qual foi incluida ou alterada no primeiro laco.                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿\Ù
					
						cCodPO := GetSXENum('SZ3','Z3_CODENT')
									
						RecLock("SZ3", .T.)

							SZ3->Z3_FILIAL	:= xFilial("SZ3")						//Filial Protheus
							SZ3->Z3_CODENT	:= cCodPO								//Codigo da Entidade
							If ValType(aPosto[nJ]:NID) == "U"
								SZ3->Z3_CODGAR	:= ""								//Codigo GAR
							Else
								SZ3->Z3_CODGAR	:= AllTrim(Str(aPosto[nJ]:NID))		//Codigo GAR
							EndIf
							If ValType(aPosto[nJ]:LATENDIMENTO) == "U"
								SZ3->Z3_ATENDIM	:= "N"								//Atendimento
							Else
								If aPosto[nJ]:LATENDIMENTO
									SZ3->Z3_ATENDIM	:= "S"							//Atendimento
								Else
									SZ3->Z3_ATENDIM	:= "N"							//Atendimento
								EndIf
							EndIf
							If ValType(aPosto[nJ]:LATIVO) == "U"
								SZ3->Z3_ATIVO	:= "N"								//Ativo
							Else
								If aPosto[nJ]:LATIVO
									SZ3->Z3_ATIVO	:= "S"							//Ativo
								Else
									SZ3->Z3_ATIVO	:= "N"							//Ativo
								EndIf
							EndIf
							If ValType(aPosto[nJ]:NCEP) == "U"
								SZ3->Z3_CEP		:= ""								//CEP
							Else
								SZ3->Z3_CEP		:= AllTrim(StrZero(aPosto[nJ]:NCEP,8))	//CEP
								DbSelectArea("PA7")
								DbSetOrder(1)
								If PA7->(DbSeek(xFilial("PA7")+AllTrim(StrZero(aPosto[nJ]:NCEP,8))))
									lPa7 := .t.
								Else
									lPa7 := .f.							
								EndIf
							EndIf
							
							If ValType(aPosto[nJ]:CBAIRRO) == "U"
								SZ3->Z3_BAIRRO	:= ""								//Bairro
							Else
								SZ3->Z3_BAIRRO	:= iif(lPa7 .AND. !Empty(PA7->PA7_BAIRRO) , PA7->PA7_BAIRRO ,AllTrim(aPosto[nJ]:CBAIRRO))		//Bairro
							EndIf
							
							If ValType(aPosto[nJ]:CCIDADE) == "U"
								SZ3->Z3_MUNICI	:= ""								//Cidade
							Else
								SZ3->Z3_MUNICI	:= iif(lPa7 .AND. !Empty(PA7->PA7_MUNIC) , PA7->PA7_MUNIC ,AllTrim(UPPER(aPosto[nJ]:CCIDADE)))	//Cidade
							EndIf
							
							If ValType(aPosto[nJ]:CENDERECO) == "U"
								SZ3->Z3_LOGRAD	:= ""								//Endereço
							Else
								SZ3->Z3_LOGRAD	:= aPosto[nJ]:CENDERECO				//Endereço
							EndIf
							
							If ValType(aPosto[nJ]:CUF) == "U"
								SZ3->Z3_ESTADO	:= ""								//UF
							Else
								SZ3->Z3_ESTADO	:= iif(lPa7 .AND. !Empty(PA7->PA7_ESTADO) , PA7->PA7_ESTADO ,aPosto[nJ]:CUF)						//UF
							EndIf
							
							SZ3->Z3_NUMLOG	:= "s/n"
							
							If ValType(aPosto[nJ]:CCNPJ) == "U"
								SZ3->Z3_CGC		:= ""								//CNPJ
							Else
								SZ3->Z3_CGC		:= IIf(CGC(aPosto[nJ]:CCNPJ),aPosto[nJ]:CCNPJ,"")					//CNPJ
							EndIf
							If ValType(aPosto[nJ]:CDESCRICAO) == "U"
								SZ3->Z3_DESENT	:= aPosto[nJ]:CDESCRICAO			//Descricao
							Else
								SZ3->Z3_DESENT	:= aPosto[nJ]:CDESCRICAO			//Descricao
							EndIf

							If ValType(aPosto[nJ]:CNOMEFANTASIA) == "U"
								SZ3->Z3_NMFANT	:= ""								//Nome Fantasia
							Else
								SZ3->Z3_NMFANT	:= aPosto[nJ]:CNOMEFANTASIA			//Nome Fantasia
							EndIf

							If ValType(aPosto[nJ]:CRAZAOSOCIAL) == "U"
								SZ3->Z3_RAZSOC	:= ""								//Razão Social
							Else
								SZ3->Z3_RAZSOC	:= aPosto[nJ]:CRAZAOSOCIAL			//Razão Social
							EndIf
							SZ3->Z3_CODAR	:= cCodAR								//Codigo Protheus da AR
							SZ3->Z3_DESAR	:= cDesAR								//Descricao da AR
							If ValType(aPosto[nJ]:NTELEFONE) == "U"
								SZ3->Z3_TEL		:= ""								//Telefone
							Else
								SZ3->Z3_TEL		:= iif(Empty(Alltrim(Str(aPosto[nJ]:NTELEFONE))) .OR. aPosto[nJ]:NTELEFONE == 0,"1134789444",Alltrim(Str(aPosto[nJ]:NTELEFONE)))	//Telefone
							EndIf
							SZ3->Z3_TIPENT	:= "4"									//Tipo
							If ValType(aPosto[nJ]:LVISIBILIDADE) == "U"
								SZ3->Z3_VISIBIL	:= "N"								//Visibilidade
							Else
								If aPosto[nJ]:LVISIBILIDADE 
									SZ3->Z3_VISIBIL	:= "N"							//Visibilidade
								Else
									SZ3->Z3_VISIBIL	:= "S"							//Visibilidade
								EndIf
							EndIf
							
							If ValType(aPosto[nJ]:LVENDASHW) == "U"
								SZ3->Z3_ENTREGA		:= "N"							//Entrega
							Else
								If aPosto[nJ]:LVENDASHW 
									SZ3->Z3_ENTREGA		:= "S"							//Entrega
								Else
									SZ3->Z3_ENTREGA		:= "N"							//Entrega
								EndIf
							EndIf
						
							// #TP20130218 - Restricao de Postos / Inclusao do campo de rede
							If ValType(aPosto[nJ]:CREDE) == "U"
								SZ3->Z3_REDE	:= Alltrim(aPosto[nJ]:CREDE)					//Rede
							Else
								SZ3->Z3_REDE	:= Alltrim(aPosto[nJ]:CREDE)					//Rede
							EndIf

							SZ3->Z3_LATITUD	:= IIF( ValType(aPosto[nJ]:CLATITUDE)=='U'	, "", Alltrim(cValToChar(aPosto[nJ]:CLATITUDE))  )
							SZ3->Z3_LONGITU	:= IIF( ValType(aPosto[nJ]:CLONGITUDE)=='U'	, "", Alltrim(cValToChar(aPosto[nJ]:CLONGITUDE)) )
						
						SZ3->(MsUnLock())
						
						If __lSx8
							ConfirmSX8()
						Else
							RollBackSX8()
						EndIf
					EndIf
				Else
					aADD(aPosErro, {aPosto[nJ]:CDESCRICAO})
				EndIf
			Next nJ
		Next nI
		Varinfo("[VNDA010] Postos S/ ID", aPosErro)
	End Transaction

	Conout( "[ VNDA010 (Importação Postos) - " + Dtoc( Date() ) + " - " + Time() + " ] FINAL" )

	RestArea(aArea)
Return
