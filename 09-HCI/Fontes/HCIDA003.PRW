#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

User Function HCIDA003()

	Local _aCores		:= {}
	Local cUserAdmin	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")
	
	Private cCadastro	:= OEMTOANSI("Pré Cadastro de Clientes")
	Private _cTexto		:= ""
	Private aRotina		:= {}
	
	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar"		,"AxPesqui"			,0,1})
	Aadd(aRotina,{"Visualizar"		,"u_fHCIDA03(4)"	,0,2})
	Aadd(aRotina,{"Incluir"			,"u_fHCIDA03(3)"	,0,3})
	Aadd(aRotina,{"Aprov.Cad."		,"u_fHCIDA03(2)"	,0,3})
	Aadd(aRotina,{"Aprov.Cont."		,"u_fHCIDA03(6)"	,0,3})
	Aadd(aRotina,{"Aprov.Amarra."	,"u_fHCIDA03(10)"	,0,3})
	Aadd(aRotina,{"Reprov.Cad."		,"u_fHCIDA03(7)"	,0,3})
	Aadd(aRotina,{"Reprov.Cont."	,"u_fHCIDA03(8)"	,0,3})
	Aadd(aRotina,{"Reprov.Amarra."	,"u_fHCIDA03(9)"	,0,3})
	Aadd(aRotina,{"Viz.Cliente"		,"u_fHCIDA03(1)"	,0,2})
	Aadd(aRotina,{"Legenda"			,"U_fLegSZ0"		,0,2})
	
	Aadd(_aCores,{'Z0_CADCON = "O" .And. Z0_CADCLI = "O" .And. Z0_CADARM = "O" ','BR_VERDE'			})	// Cliente cadastrado.
	Aadd(_aCores,{'Z0_CADCON = "P" .Or. Z0_CADCLI = "P" .Or. Z0_CADARM = "P" ','BR_AMARELO'		})	// Cliente cadastrado.
	Aadd(_aCores,{'Z0_CADCON = "R" .Or. Z0_CADCLI = "R" .Or. Z0_CADARM = "R" ','DISABLE'		})	// Cancelado
	
	If !(__cUserID $ cUserAdmin)			
		_cTexto	:= U_HCIDM010("PRECLI")
		_cFiltro := Iif(!Empty(_cTexto),"Z0_CONTATO IN ("+_cTexto+") OR Z0_USERID = '"+__cUserId+"'","Z0_USERID = '"+__cUserId+"'")
		MBrowse(6, 1,22,75,"SZ0",,,,,,_aCores,,,,,,,,_cFiltro)						
	Else		
		MBrowse(6, 1,22,75,"SZ0",,,,,,_aCores)		
	EndIf
	
Return()

User Function fHCIDA03(_nOpc)
	
	Local _aArea	:= GetArea()
	Local _nOpcA	:= 0
	Local _aEncho	:= {}
	Local _aEmail	:= Separa(GetMv("ES_HWCMAIL",,"000271,000318,000408"),",")
	Local _cRecno	:= SZ0->(Recno())
	Local _cRecnZ0	:= ""
	Local _cRecZ03	:= ""
	Local _cRecSU5	:= ""
	Local _cUsers	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")
	Local _cObs 	:= ""
	Local _oDlgRObs := Nil
	Local _lOk		:= .T.
	Local _cMsgAv	:= ""

	Do Case
		Case _nOpc == 1
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
				AxVisual( 'SA1', SA1->( Recno() ), 2 )
			Else
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Cliente ainda não cadastrado. Favor verificar com o responsável!"),{"Ok"},2)
			EndIf
		Case _nOpc == 2
			If !Empty(SZ0->Z0_CODIGO)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Cliente já cadastrado no sistema Codigo/Loja: [" + SZ0->Z0_CODIGO + "/" + SZ0->Z0_LOJA +"]."),{"Ok"},2)
			Else
				If SZ0->Z0_CADCLI == "P"
					dbSelectArea("SA1")
					SA1->(dbGoBottom())
					_nOpcA := AxInclui( "SA1", SA1->(Recno()), 3,,"u__fDA03M",,,,,,,,.T.)
					MBrChgLoop(.F.)
					If _nOpcA == 1
						For _nI	:= 1 To Len(_aEmail)
							Begin Transaction 
								_cMsg := "<html>"
								_cMsg += "<head>"
								_cMsg += "<title>Untitled Document</title>"
								_cMsg += "</head> "
								_cMsg += "<body> "
								_cMsg += "  <p>&nbsp;</p>"
								_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
								_cMsg += "  <p>Favor realizar analise dos campos contábeis para o cliente cadastrado: </p>" 
								_cMsg += "	<p>Cliente:" + SA1->A1_COD
								_cMsg += "	<p>Loja:" + SA1->A1_LOJA
								_cMsg += "	<p>Nome:" + SA1->A1_NOME
								_cMsg += "	<p>Grato(a),"
								_cMsg += "</body>"
								_cMsg += "</html>"
								
								_cAssunto	:= "Cadastro de Cliente"
								_cPara		:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
								
								MailDSC(_cPara, _cAssunto, _cMsg, "")
							End Transaction
						Next _nI
					
						If RecLock("SZ0",.F.)
							SZ0->Z0_CODIGO	:= SA1->A1_COD
							SZ0->Z0_LOJA	:= SA1->A1_LOJA
							SZ0->Z0_CADCLI	:= "O"
							SZ0->Z0_USRAPV	:= __cUserID
							SZ0->(MsUnLock())
						EndIf
						If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
							If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
								Begin Transaction 
									dbSelectArea("AC8")
									AC8->(dbSetORder(1))
									If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
										If RecLock("AC8",.T.)
											AC8->AC8_FILIAL	:= xFilial("AC8")
											AC8->AC8_FILENT	:= xFilial("SA1")
											AC8->AC8_ENTIDA	:= "SA1"
											AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
											AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
											AC8->(MsUnLock())
										EndIf
									EndIf
									
									If RecLock("SZ0",.F.)		
										SZ0->Z0_CADARM	:= "O"
										SZ0->(MsUnLock())
									EndIF
								End Transaction 
							EndIf
	//						_fEnvEAp(3)
						EndIf
					EndIf
				Else
					Aviso(OEMTOANSI("Atenção"),OEMTOANSI("O Cadastro de Cliente foi rejeitado."),{"Ok"},2)
				EndIf
			EndIf
		Case _nOpc == 3			
			aadd(_aEncho,"Z0_CODPRC")
			aadd(_aEncho,"Z0_NOME")
			aadd(_aEncho,"Z0_DDD")
			aadd(_aEncho,"Z0_TEL")
			aadd(_aEncho,"Z0_CNPJ")
			aadd(_aEncho,"Z0_CEP")
			aadd(_aEncho,"Z0_END")
			aadd(_aEncho,"Z0_BAIRRO")
			aadd(_aEncho,"Z0_EST")
			aadd(_aEncho,"Z0_MUN")
			aadd(_aEncho,"Z0_COD_MUN")
			aadd(_aEncho,"Z0_CONTATO")
			aadd(_aEncho,"Z0_NOMCONT")
			aadd(_aEncho,"Z0_EMAIL")
			aadd(_aEncho,"Z0_DDDC")
			aadd(_aEncho,"Z0_TELC")
			aadd(_aEncho,"Z0_OBS")
			aadd(_aEncho,"Z0_IE")
			aadd(_aEncho,"Z0_TIPO")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxInclui( "SZ0", SZ0->(Recno()), 3,_aEncho,,,,,,,,,.T.)
			MBrChgLoop(.F.)
			If _nOpcA == 1
				_cRecno	:= SZ0->(Recno())
				SZ0->(CONFIRMSX8())
				If RecLock("SZ0",.F.)
					SZ0->Z0_STATUS	:= "E"
					SZ0->Z0_USERID	:= __cUserID
					SZ0->Z0_CADCLI	:= Iif(Empty(SZ0->Z0_CODIGO),"P","O")
					SZ0->Z0_CADCON	:= Iif(Empty(SZ0->Z0_CONTATO),"P","O")
					SZ0->Z0_CADARM	:= "P"
					SZ0->(MsUnLock())
				EndIf 
/*				If Empty(SZ0->Z0_CODIGO)
					_fEnvEAp(1)
				EndIf */
				If Empty(SZ0->Z0_CONTATO) .And. _fTotEmC(SZ0->Z0_EMAIL) <= 1
					dbSelectArea("Z03")
					Z03->(dbSetOrder(2))
					If Z03->(!dbSeek(xFilial("Z03")+PadR(AllTrim(SZ0->Z0_EMAIL),TamSX3("Z03_EMAIL")[1])))
						cCadastro	:= OEMTOANSI("Pré Cadastro de Contatos")
						_aEncho := {}
						Aadd(_aEncho,"Z03_NOME")
						Aadd(_aEncho,"Z03_DDD")
						Aadd(_aEncho,"Z03_TEL")
						Aadd(_aEncho,"Z03_EMAIL")
						Aadd(_aEncho,"Z03_EMPRES")
						Aadd(_aEncho,"Z03_FUNCAO")
						Aadd(_aEncho,"Z03_OBS")
						Aadd(_aEncho,"NOUSER")
						_nOpcA := AxInclui( "Z03", Z03->(Recno()), 3,_aEncho,"u__fDA03M1",,,,,,,,.T.)
						MBrChgLoop(.F.)
						If _nOpcA == 1
							If RecLock("Z03",.F.)
								Z03->Z03_STATUS	:= "E"
	//							Z03->Z03_USERID	:= __cUserID
								Z03->(MsUnLock())
							EndIf 
//							_fEnvEAp(2)
							_cRecZ03	:= Z03->(Recno())
						EndIf				
						cCadastro	:= OEMTOANSI("Pré Cadastro de Clientes")
					Else
						_cRecZ03	:= Z03->(Recno())
					EndIf
				Else
					dbSelectArea("SU5")
					SU5->(dbSetOrder(1))
					If SU5->(dbSeek(xFilial("SU5") + SZ0->Z0_CONTATO))
						_cRecSU5	:= SU5->(Recno())
					EndIf
				EndIf
				
				_cRecnZ0	:= SZ0->(Recno())
				_fEnvEM(_cRecnZ0,_cRecZ03,_cRecSU5)
				
				If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
					If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
						Begin Transaction 
							dbSelectArea("AC8")
							AC8->(dbSetORder(1))
							If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
								If RecLock("AC8",.T.)
									AC8->AC8_FILIAL	:= xFilial("AC8")
									AC8->AC8_FILENT	:= xFilial("SA1")
									AC8->AC8_ENTIDA	:= "SA1"
									AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
									AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
									AC8->(MsUnLock())
								EndIf
							EndIf
							
							If RecLock("SZ0",.F.)		
								SZ0->Z0_CADARM	:= "O"
								SZ0->(MsUnLock())
							EndIF
						End Transaction 
					EndIf
//					_fEnvEAp(3)
				EndIf
			EndIf
		Case _nOpc == 4
			aadd(_aEncho,"Z0_CODPRC")
			aadd(_aEncho,"Z0_NOME")
			aadd(_aEncho,"Z0_DDD")
			aadd(_aEncho,"Z0_TEL")
			aadd(_aEncho,"Z0_CNPJ")
			aadd(_aEncho,"Z0_CEP")
			aadd(_aEncho,"Z0_END")
			aadd(_aEncho,"Z0_BAIRRO")
			aadd(_aEncho,"Z0_EST")
			aadd(_aEncho,"Z0_MUN")
			aadd(_aEncho,"Z0_COD_MUN")
			aadd(_aEncho,"Z0_CONTATO")
			aadd(_aEncho,"Z0_NOMCONT")
			aadd(_aEncho,"Z0_EMAIL")
			aadd(_aEncho,"Z0_DDDC")
			aadd(_aEncho,"Z0_TELC")
			aadd(_aEncho,"Z0_OBS")
			aadd(_aEncho,"Z0_IE")
			aadd(_aEncho,"Z0_TIPO")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxVisual( "SZ0", SZ0->(Recno()), 2,_aEncho,,,,,,,,,.T.)			
			
		Case _nOpc == 5
			aadd(_aEncho,"Z0_CODPRC")
			aadd(_aEncho,"Z0_NOME")
			aadd(_aEncho,"Z0_DDD")
			aadd(_aEncho,"Z0_TEL")
			aadd(_aEncho,"Z0_CNPJ")
			aadd(_aEncho,"Z0_CEP")
			aadd(_aEncho,"Z0_END")
			aadd(_aEncho,"Z0_BAIRRO")
			aadd(_aEncho,"Z0_EST")
			aadd(_aEncho,"Z0_MUN")
			aadd(_aEncho,"Z0_COD_MUN")
			aadd(_aEncho,"Z0_CONTATO")
			aadd(_aEncho,"Z0_NOMCONT")
			aadd(_aEncho,"Z0_EMAIL")
			aadd(_aEncho,"Z0_DDDC")
			aadd(_aEncho,"Z0_TELC")
			aadd(_aEncho,"Z0_OBS")
			aadd(_aEncho,"Z0_IE")
			aadd(_aEncho,"Z0_TIPO")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxAltera( "SZ0", SZ0->(Recno()), 4,_aEncho,,,,,,,,,.T.)
			
		Case _nOpc == 6
		
			If !Empty(SZ0->Z0_CONTATO)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Contato já cadastrado no sistema." + CRLF + "Codigo: " + SZ0->Z0_CONTATO + "."),{"Ok"},2)
			Else
				If SZ0->Z0_CADCON == "P"
					If _fTotEmC(SZ0->Z0_EMAIL) > 1
						_fSelCon(SZ0->Z0_EMAIL)
					Else
						dbSelectArea("Z03")
						Z03->(dbSetOrder(2))
						Z03->(dbSeek(xFilial("Z03")+PadR(AllTrim(SZ0->Z0_EMAIL),TamSX3("Z03_EMAIL")[1])))
						
						dbSelectArea("SU5")
						SU5->(dbGoBottom())
						_nOpcA := AxInclui( "SU5", SU5->(Recno()), 3,,"u__fDA03M2",,,,,,,,.T.)
						MBrChgLoop(.F.)
						If _nOpcA == 1
							If RecLock("SZ0",.F.)
								SZ0->Z0_CONTATO	:= SU5->U5_CODCONT
								SZ0->Z0_NOMCONT	:= SU5->U5_CONTAT
								SZ0->Z0_CADCON	:= "O"
								SZ0->(MsUnLock())
							EndIf
							
							dbSelectArea("Z03")
							Z03->(dbSetOrder(2))
							If Z03->(dbSeek(xFilial("Z03")+PadR(AllTrim(SZ0->Z0_EMAIL),TamSX3("Z03_EMAIL")[1])))
								If RecLock("Z03",.F.)
									Z03->Z03_CODIGO	:= SU5->U5_CODCONT
									Z03->Z03_APROV 	:= __cUserID
									Z03->(MsUnLock())
								EndIf
							EndIf
							
							If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
								If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
									Begin Transaction 
										dbSelectArea("AC8")
										AC8->(dbSetORder(1))
										If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
											If RecLock("AC8",.T.)
												AC8->AC8_FILIAL	:= xFilial("AC8")
												AC8->AC8_FILENT	:= xFilial("SA1")
												AC8->AC8_ENTIDA	:= "SA1"
												AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
												AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
												AC8->(MsUnLock())
											EndIf
										EndIf
										
										If RecLock("SZ0",.F.)		
											SZ0->Z0_CADARM	:= "O"
											SZ0->(MsUnLock())
										EndIF
									End Transaction 
								EndIf
		//						_fEnvEAp(3)
							EndIf
							_fConCli(SZ0->Z0_EMAIL,SU5->U5_CODCONT,SU5->U5_CONTAT)
						EndIf					
					EndIf
				Else
					Aviso(OEMTOANSI("Atenção"),OEMTOANSI("O Cadastro de Contato foi rejeitado."),{"Ok"},2)
				EndIf
			EndIf
			
		Case _nOpc == 7 .Or. _nOpc == 8 .Or. _nOpc == 9
			
			Do Case
				Case _nOpc == 7
					_lOk	:= SZ0->Z0_CADCLI == 'P'
					_cMsgAv	:= "O Cliente não pode ser rejeitado. Cadastro do Cliente no sistema foi " + Iif(SZ0->Z0_CADCLI=="O","aprovado.",Iif(SZ0->Z0_CADCLI=="R"," reprovado.",""))
				Case _nOpc == 8
					_lOk	:= SZ0->Z0_CADCON == 'P'
					_cMsgAv	:= "O Contato não pode ser rejeitado. Cadastro do Contato no sistema foi " + Iif(SZ0->Z0_CADCON=="O","aprovado.",Iif(SZ0->Z0_CADCON=="R"," reprovado.",""))
				Case _nOpc == 9
					_lOk	:= SZ0->Z0_CADARM == 'P'
					_cMsgAv	:= "A Amarração não pode ser rejeitada. Cadastro da Amarração no sistema foi " + Iif(SZ0->Z0_CADARM=="O","aprovada.",Iif(SZ0->Z0_CADARM=="R"," reprovada.",""))
			End Case
			
			If _lOk
				@ 067,020 To 269,412 Dialog _oDlgRObs Title OemToAnsi("Rejeição Cadastro") + Iif(_nOpc==7," Cliente",Iif(_nOpc==8," Contato"," Amarração"))
					@ 005,005 Say OemToAnsi("Observação:") Size 80,8
					@ 015,005 Get _cObs MEMO SIZE 189,068  Pixel Of _oDlgRObs 
					@ 087,126 BmpButton Type 1 Action (_fRCad3(_cObs,_nOpc),Close(_oDlgRObs))
					@ 087,166 BmpButton Type 2 Action (Close(_oDlgRObs))
				Activate Dialog _oDlgRObs CENTERED
			Else
				Aviso(OemToAnsi("Atenção"),_cMsgAv,{"Ok"},2)
			EndIf
			
		Case _nOpc == 10
			
			If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
				If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
					Begin Transaction 
						dbSelectArea("AC8")
						AC8->(dbSetORder(1))
						If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
							If RecLock("AC8",.T.)
								AC8->AC8_FILIAL	:= xFilial("AC8")
								AC8->AC8_FILENT	:= xFilial("SA1")
								AC8->AC8_ENTIDA	:= "SA1"
								AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
								AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
								AC8->(MsUnLock())
							EndIf
						EndIf
						
						If RecLock("SZ0",.F.)		
							SZ0->Z0_CADARM	:= "O"
							SZ0->(MsUnLock())
						EndIF
					End Transaction 
				EndIf
			EndIf
	EndCase
	
	RestArea(_aArea)
	SZ0->(dbGoTo(_cRecno))

Return()

Static Function _fRCad3(_cObs, _nOpc)
	
	Local _cHist	:= ""
	
	_cHist	:= "===========================================" +CRLF
	_cHist += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cHist += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF

	Do Case
		Case _nOpc == 7
			If RecLock("SZ0",.F.)
				SZ0->Z0_CADCLI	:= "R"
				SZ0->Z0_OBS		:= SZ0->Z0_OBS + CRLF + _cHist + CRLF + _cObs
				SZ0->(MsUnLock())
			EndIf
		Case _nOpc == 8
			If RecLock("SZ0",.F.)
				SZ0->Z0_CADCON	:= "R"
				SZ0->Z0_OBS		:= SZ0->Z0_OBS + CRLF + _cHist + CRLF + _cObs
				SZ0->Z0_OBSCONT	:= SZ0->Z0_OBSCONT + CRLF + _cHist + CRLF + _cObs
				SZ0->(MsUnLock())
			EndIf
		Case _nOpc == 9
			If RecLock("SZ0",.F.)
				SZ0->Z0_CADARM	:= "R"
				SZ0->Z0_OBS		:= SZ0->Z0_OBS + CRLF + _cHist + CRLF + _cObs
				SZ0->Z0_OBSAMAR	:= SZ0->Z0_OBSAMAR + CRLF + _cHist + CRLF + _cObs
				SZ0->(MsUnLock())
			EndIf
	End Case

Return()


Static Function _fSelCon(_cEmail)

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olMark		:= Nil
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc			:= 0
	Local _cUsers		:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")
	
	Private _cAliasECC	:= GetNextAlias()
	
	aAdd(alCampos,{"CODCON"	,,"Codigo"		,"@!"})	
	aAdd(alCampos,{"CONTAT"	,,"Nome"		,"@!"})
	aAdd(alCampos,{"EMAIL"	,,"E-mail"		,"@!"})	
	
	aAdd(alEstrut,{"CODCON"	,"C",TamSX3("U5_CODCONT")[1],0})
	aAdd(alEstrut,{"CONTAT"	,"C",TamSX3("U5_CONTAT")[1],0})
	aAdd(alEstrut,{"EMAIL"	,"C",TamSX3("U5_EMAIL")[1],0})
	
	clNomTmp	:= CriaTrab(alEstrut,.T.)
	dbUseArea(.T.,,clNomTmp,_cAliasECC,.F.)
	
	_FGTMPEC(_cEmail)

	(_cAliasECC)->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE AllTRim(SZ0->Z0_NOMCONT) + " - Contatos"
	
		olMark	:= MsSelect():New((_cAliasECC),"",,alCampos,,@clMarca,{05,04,200,250})
		
		@ 205,110 BUTTON olBtn1		PROMPT "Incluir" 	SIZE 40,12 ACTION (_fIncCon(), olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 		SIZE 40,12 ACTION (_nOpc := 1, olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  	SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip
	
	ACTIVATE DIALOG olDlgTip CENTERED

	If _nOpc == 1
		If RecLock("SZ0",.F.)
			SZ0->Z0_CONTATO	:= (_cAliasECC)->CODCON
			SZ0->Z0_NOMCONT	:= (_cAliasECC)->CONTAT
			SZ0->Z0_CADCON	:= "O"
			SZ0->(MsUnLock())
		EndIf
		
		dbSelectArea("Z03")
		Z03->(dbSetOrder(2))
		If Z03->(dbSeek(xFilial("Z03")+PadR(AllTrim(_cEmail),TamSX3("Z03_EMAIL")[1])))
			If RecLock("Z03",.F.)
				Z03->Z03_CODIGO	:= (_cAliasECC)->CODCON
				Z03->Z03_APROV 	:= __cUserID
				Z03->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
			If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
				Begin Transaction 
					dbSelectArea("AC8")
					AC8->(dbSetORder(1))
					If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
						If RecLock("AC8",.T.)
							AC8->AC8_FILIAL	:= xFilial("AC8")
							AC8->AC8_FILENT	:= xFilial("SA1")
							AC8->AC8_ENTIDA	:= "SA1"
							AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
							AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
							AC8->(MsUnLock())
						EndIf
					EndIf
					
					If RecLock("SZ0",.F.)		
						SZ0->Z0_CADARM	:= "O"
						SZ0->(MsUnLock())
					EndIF
				End Transaction 
			EndIf
//						_fEnvEAp(3)
		EndIf
	EndIf
	
Return()

Static Function _fIncCon()

	Local _nOpcA 	:= 0
	Local _cUsers	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")

	dbSelectArea("SU5")
	SU5->(dbGoBottom())
	_nOpcA := AxInclui( "SU5", SU5->(Recno()), 3,,"u__fDA03M3",,,,,,,,.T.)
	MBrChgLoop(.F.)
	If _nOpcA == 1
		If RecLock("SZ0",.F.)
			SZ0->Z0_CONTATO	:= SU5->U5_CODCONT
			SZ0->Z0_NOMCONT	:= SU5->U5_CONTAT
			SZ0->Z0_CADCON	:= "O"
			SZ0->(MsUnLock())
		EndIf
		
		If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
			If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?', {"SIM", "NAO"}, 1) == 1
				Begin Transaction 
					dbSelectArea("AC8")
					AC8->(dbSetORder(1))
					If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
						If RecLock("AC8",.T.)
							AC8->AC8_FILIAL	:= xFilial("AC8")
							AC8->AC8_FILENT	:= xFilial("SA1")
							AC8->AC8_ENTIDA	:= "SA1"
							AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
							AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
							AC8->(MsUnLock())
						EndIf
					EndIf
					
					If RecLock("SZ0",.F.)		
						SZ0->Z0_CADARM	:= "O"
						SZ0->(MsUnLock())
					EndIF
				End Transaction 
			EndIf
		EndIf
		_fConCli(SZ0->Z0_EMAIL,SU5->U5_CODCONT,SU5->U5_CONTAT)
	EndIf					

Return()

Static Function _FGTMPEC(_cEmail)

	Local _cQuery		:= ""
	Local _cAliasTEC	:= GetNextAlias()

	_cQuery	:= "SELECT U5_EMAIL, U5_CODCONT, U5_CONTAT "
	_cQuery += " FROM " + RetSqlName("SU5")
	_cQuery += " WHERE U5_FILIAL = '" + xFilial("SU5") + "'"
	_cQuery += " AND U5_EMAIL = '" + AllTrim(_cEmail) + "'"
	_cQuery += " AND D_E_L_E_T_ = ' ' ""
	TcQuery _cQuery New Alias &(_cAliasTEC)
	
	If (_cAliasTEC)->(!EOF())
		While (_cAliasTEC)->(!EOF())
			If RecLock((_cAliasECC),.T.)
				(_cAliasECC)->CODCON 	:= (_cAliasTEC)->U5_CODCONT
				(_cAliasECC)->CONTAT   	:= (_cAliasTEC)->U5_CONTAT
				(_cAliasECC)->EMAIL   	:= (_cAliasTEC)->U5_EMAIL				
				(_cAliasTEC)->(MsUnLock())
			EndIf		
			(_cAliasTEC)->(dbSkip())
		EndDO
	EndIf
	(_cAliasTEC)->(dbCloseArea())

Return(Nil)


Static Function _fTotEmC(_cEmail)

	Local _nCount	:= 0
	Local _cQuery		:= ""
	Local _cAliasEU5	:= GetNextAlias()
	
	_cQuery := "SELECT COUNT(*) AS CONTA"
	_cQuery += " FROM " + RetSqlName("SU5")
	_cQuery += " WHERE U5_FILIAL = '" + xFilial("SU5") + "'"
	_cQuery += " AND U5_EMAIL = '" + AllTrim(_cEmail) + "'"
	_cQuery += " AND D_E_L_E_T_ = ' ' " 
	TcQuery _cQuery New Alias &(_cAliasEU5)
	
	If (_cAliasEU5)->(!Eof())
		_nCount	:= (_cAliasEU5)->CONTA
	EndIf

	(_cAliasEU5)->(dbCloseArea())

Return(_nCount)

Static Function _fConCli(_cEmail,_cContato,_cContNom)

    Local _cQuery	:= ""
    Local _cAliasCC	:= GetNextAlias()
    Local _aArea	:= GetArea()
    Local _cUsers	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")
    
    _cQuery := "SELECT SZ0.R_E_C_N_O_ AS CRECNO"
    _cQuery += " FROM " + RetSqlName("SZ0") + " SZ0 "
    _cQuery += " WHERE Z0_FILIAL = '" + xFilial("SZ0") + "' "
    _cQuery	+= " AND Z0_EMAIL = '" + _cEmail + "' "
    _cQuery += " AND Z0_CONTATO	= '" + Space(TAMSX3("Z0_CONTATO")[1]) + "' "
    _cQuery	+= " AND D_E_L_E_T_ = ' ' "
    TcQuery _cQuery New Alias &(_cAliasCC) 
    
    If (_cAliasCC)->(!EOF())
    	While (_cAliasCC)->(!EOF())
    		SZ0->(dbGoTo((_cAliasCC)->CRECNO))
    		If RecLock("SZ0",.F.)
    			SZ0->Z0_CONTATO	:= _cContato
    			SZ0->Z0_NOMCONT	:= _cContNom
    			SZ0->Z0_CADCON	:= "O"
    			SZ0->(MsUnLock())
    			
    			If !Empty(SZ0->Z0_CODIGO) .And. !Empty(SZ0->Z0_CONTATO) .And. __cUserId $ _cUsers
					If AVISO(OEMTOANSI("Atenção"), 'Deseja realizar a amarração do Cliente com o Contato?' + CRLF + "Cliente: " + SZ0->Z0_NOME + CRLF + "Contato: " + SZ0->Z0_NOMCONT , {"SIM", "NAO"}, 2) == 1
						Begin Transaction 
							dbSelectArea("AC8")
							AC8->(dbSetORder(1))
							If AC8->(!dbSeek(xFilial("AC8") + SZ0->Z0_CONTATO + "SA1" + xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
								If RecLock("AC8",.T.)
									AC8->AC8_FILIAL	:= xFilial("AC8")
									AC8->AC8_FILENT	:= xFilial("SA1")
									AC8->AC8_ENTIDA	:= "SA1"
									AC8->AC8_CODENT	:= SZ0->Z0_CODIGO + SZ0->Z0_LOJA
									AC8->AC8_CODCON	:= SZ0->Z0_CONTATO
									AC8->(MsUnLock())
								EndIf
							EndIf
							
							If RecLock("SZ0",.F.)		
								SZ0->Z0_CADARM	:= "O"
								SZ0->(MsUnLock())
							EndIF
						End Transaction 
					EndIf
//					_fEnvEAp(3)
				EndIf
				    			
    		EndIf
    		(_cAliasCC)->(dbSkip())
    	EndDo
    EndIf
	
	RestArea(_aArea)
	
Return()

User Function _fDA03M1()

	M->Z03_NOME		:= SZ0->Z0_NOMCONT
	M->Z03_EMAIL	:= SZ0->Z0_EMAIL
	M->Z03_EMPRES	:= SZ0->Z0_NOME
	M->Z03_DDD		:= SZ0->Z0_DDDC
	M->Z03_TEL		:= SZ0->Z0_TELC
	M->Z03_OBS		:= SZ0->Z0_OBS

Return(.T.)

User Function _fDA03M2()

	M->U5_CONTAT	:= Z03->Z03_NOME
	M->U5_DDD		:= Z03->Z03_DDD
	M->U5_FONE		:= Z03->Z03_TEL
	M->U5_EMAIL		:= Z03->Z03_EMAIL
	M->U5_FUNCAO	:= Z03->Z03_FUNCAO
	M->U5_VEND		:= Z03->Z03_VEND

Return(.T.)

User Function _fDA03M3()

	M->U5_CONTAT	:= SZ0->Z0_NOMCONT
	M->U5_EMAIL		:= SZ0->Z0_EMAIL
	M->U5_VEND		:= SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + SZ0->Z0_USERID,7))

Return(.T.)

User Function _fDA03M()

	Local _cVendPad	:= GetMv("ES_PRTVEPD",,"000001")

	M->A1_NOME		:= SZ0->Z0_NOME
	M->A1_END		:= SZ0->Z0_END
	M->A1_TEL		:= SZ0->Z0_TEL
	M->A1_CGC		:= SZ0->Z0_CNPJ
	M->A1_CEP		:= SZ0->Z0_CEP
	M->A1_DDD		:= SZ0->Z0_DDD
	M->A1_BAIRRO	:= SZ0->Z0_BAIRRO
	M->A1_EST		:= SZ0->Z0_EST
	M->A1_COD_MUN	:= SZ0->Z0_COD_MUN
	M->A1_MUN		:= SZ0->Z0_MUN
	M->A1_CONTATO	:= SZ0->Z0_CONTATO
	M->A1_TIPO		:= SZ0->Z0_TIPO
	M->A1_VEND		:= _cVendPad
	M->A1_CODMARC	:= ""

Return(.t.)

User Function _fDA3CGC()

	Local _cQuery		:= ""
	Local _cAlias1		:= ""
	Local _cAlias2		:= ""
	Local _lOk			:= .T.
	Local _aArea		:= GetArea()
	
	_cAlias1    := GetNextAlias()
	
	_cQuery := "SELECT R_E_C_N_O_ AS CRECNO "
	_cQuery += " FROM " + RetSqlName("SZ0")
	_cQuery += " WHERE Z0_FILIAL = '" + xFilial("SZ0") + "' "
	_cQuery += " AND Z0_CNPJ = '" + M->Z0_CNPJ + "' "
	_cQuery += " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAlias1)
    
	If (_cAlias1)->(!EOF())
		_lOk	:= .F.
		dbSelectArea("SZ0")
		SZ0->(dbSetOrder(1))
		SZ0->(dbGoTo((_cAlias1)->CRECNO))
		If !Empty(SZ0->Z0_CODIGO)
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1") + SZ0->Z0_CODIGO + SZ0->Z0_LOJA))
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("O CNPJ informado está cadastrado para outro cliente." + CRLF + "[" + SA1->A1_COD + "/" + SA1->A1_LOJA+ "] - " + SA1->A1_NOME),{"OK"},3)
				M->Z0_CODIGO 	:= SA1->A1_COD
				M->Z0_LOJA		:= SA1->A1_LOJA
				M->Z0_NOME		:= SA1->A1_NOME
				M->Z0_CEP		:= SA1->A1_CEP
				M->Z0_END		:= SA1->A1_END
				M->Z0_BAIRRO	:= SA1->A1_BAIRRO
				M->Z0_EST		:= SA1->A1_EST
				M->Z0_MUN		:= SA1->A1_MUN
				M->Z0_COD_MUN	:= SA1->A1_COD_MUN
				M->Z0_DDD		:= SA1->A1_DDD
				M->Z0_TEL		:= SA1->A1_TEL
				M->Z0_TIPO		:= SA1->A1_TIPO
			EndIf
		Else
			Aviso(OEMTOANSI("Atenção"),OEMTOANSI("O CNPJ informado está cadastrado para outro cliente (em pré cadastro)." + CRLF + "[Status] - " + Iif(SZ0->Z0_STATUS=="E","Pendente de aprovação",Iif(SZ0->Z0_STATUS=="R","Cadastro rejeitado.",""))),{"OK"},3)
		EndIf
	Else
		_cAlias2    := GetNextAlias()
		
		_cQuery := "SELECT R_E_C_N_O_ AS CRECNO "
		_cQuery += " FROM " + RetSqlName("SA1")
		_cQuery += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' "
		_cQuery += " AND A1_CGC = '" + M->Z0_CNPJ + "' "
		_cQuery += " AND D_E_L_E_T_ = ' ' "
		TcQuery _cQuery New Alias &(_cAlias2)
		
		If (_cAlias2)->(!EOF())
			_lOk	:= .F.
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTo((_cAlias2)->CRECNO))
			Aviso(OEMTOANSI("Atenção"),OEMTOANSI("O CNPJ informado está cadastrado para outro cliente." + CRLF + "[" + SA1->A1_COD + "/" + SA1->A1_LOJA+ "] - " + SA1->A1_NOME),{"OK"},3)
			M->Z0_CODIGO 	:= SA1->A1_COD
			M->Z0_LOJA		:= SA1->A1_LOJA
			M->Z0_NOME		:= SA1->A1_NOME
			M->Z0_CEP		:= SA1->A1_CEP
			M->Z0_END		:= SA1->A1_END
			M->Z0_BAIRRO	:= SA1->A1_BAIRRO
			M->Z0_EST		:= SA1->A1_EST
			M->Z0_MUN		:= SA1->A1_MUN
			M->Z0_COD_MUN	:= SA1->A1_COD_MUN
			M->Z0_DDD		:= SA1->A1_DDD
			M->Z0_TEL		:= SA1->A1_TEL
		EndIf
		(_cAlias2)->(dbCloseArea())
	EndIf

	(_cAlias1)->(dbCloseArea())
	RestArea(_aArea)

Return(.T.)

User Function fLegSZ0()

	BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE"  		, "Cadastro aprovado."		},;
									{"BR_VERMELHO"		, "Cadastro rejeitado."		},; 
									{"BR_AMARELO"		, "Cadastro pendente."		}}) 
Return(.T.)

Static Function _fEnvEM(_cRecnZ0,_cRecZ03,_cRecSU5)

	Local _aEmail	:= Separa(GetMv("ES_DTFMAIL",,"000335,000148"),",")
	Local _cSend	:= ""
	Local _cAssunto	:= "Pré Cadastro Cliente/Contato"
	Local _cMsg		:= ""
	Local _cFuncao	:= SU5->(GetAdvFVal("SU5","U5_FUNCAO",xFilial("SU5") + SZ0->Z0_CONTATO,1))
	Local _cVend	:= SU5->(GetAdvFVal("SU5","U5_VEND",xFilial("SU5") + SZ0->Z0_CONTATO,1))
	Local cHostWF	:= GetMv("ES_HWFHOST",,"http://201.28.59.194:8088/WF")
	Local _nI		:= 0

	For _nI	:= 1 To Len(_aEmail)
		Begin Transaction 
			_oProcess	:= TWFProcess():New('000001','Aprovacao - Cad Clientes')
			_oProcess:NewTask( '000002',  "\Workflow\ACliente.html" )
		
			_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
			_oHTML   			:= _oProcess:oHTML

			SZ0->(dbGoTo(_cRecnZ0))			
			
			_oHTML:ValByName( "CSOLICIT"  	,AllTrim(UsrRetName(__cUserId)) )
			_oHTML:ValByName( "CAPROV"  	,_aEmail[_nI] + " - " + AllTrim(UsrRetName(_aEmail[_nI])) )
			
			_oHTML:ValByName( "CCODCLI"		,SZ0->Z0_CODPRC )
			_oHTML:ValByName( "CCADCLI"		,Iif(Empty(SZ0->Z0_CODIGO),"Cliente não Cadastrado no sistema","Cliente cadastrado - " + SZ0->Z0_CODIGO +"/"+ SZ0->Z0_LOJA) )
			_oHTML:ValByName( "CNOME"  		,SZ0->Z0_NOME )
			_oHTML:ValByName( "CCNPJ"  		,Iif(Len(SZ0->Z0_CNPJ)<14,Transform(SZ0->Z0_CNPJ,"@R 99.999.999-!"),Transform(SZ0->Z0_CNPJ,"@R 99.999.999/9999-99")) )
			_oHTML:ValByName( "CTEL"  		,"(" + SZ0->Z0_DDD + ") - " + SZ0->Z0_TEL)
			_oHTML:ValByName( "CIE"			,SZ0->Z0_IE)
			_oHTML:ValByName( "COBSCLI"		,AllTrim(SZ0->Z0_OBS))			
			_oHTML:ValByName( "CCEP"  		,SZ0->Z0_CEP )
			_oHTML:ValByName( "CEND"  		,SZ0->Z0_END )
			_oHTML:ValByName( "CBAIRRO"		,SZ0->Z0_BAIRRO)
			_oHTML:ValByName( "CMUN"		,SZ0->Z0_MUN)
			_oHTML:ValByName( "CCODMUN"		,SZ0->Z0_COD_MUN)
			_oHTML:ValByName( "CESTADO"		,SZ0->Z0_EST)
			_oHTML:ValByName( "CTIPOCLI"	,Iif(SZ0->Z0_TIPO=="F","F=Cons.Final",Iif(SZ0->Z0_TIPO=="L","L=Produtor Rural",Iif(SZ0->Z0_TIPO=="R","R=Revendedor",Iif(SZ0->Z0_TIPO=="S","S=Solidario","X=Exportacao")))) )
			
			If Empty(_cRecZ03)
				If !Empty(_cRecSU5)
					SU5->(dbGoTo(_cRecSU5))
					_oHTML:ValByName( "CCADASTRO"	,"Contato cadastrado - " + SU5->U5_CODCONT)
					_oHTML:ValByName( "CNOMCON"		,SU5->U5_CONTAT)
					_oHTML:ValByName( "CDDD"   		,SU5->U5_DDD)
					_oHTML:ValByName( "CTELCON"		,SU5->U5_FONE)
					_oHTML:ValByName( "CEMCON"		,SU5->U5_EMAIL)
					_oHTML:ValByName( "CFUNCON"		,SU5->U5_FUNCAO + " - " + Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC"))
					_oHTML:ValByName( "CVENDCON"	,SU5->U5_VEND + " - " + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + SU5->U5_VEND,1)))
				Else
					_oHTML:ValByName( "CCADASTRO"	,"Contato possui mais de um cadastro atrelado ao e-mail.")
					_oHTML:ValByName( "CEMCON"		,SZ0->Z0_EMAIL)
				EndIf
				
			Else
				Z03->(dbGoTo(_cRecZ03))
				_oHTML:ValByName( "CCADASTRO"	,"Contato não Cadastrado no sistema")
				_oHTML:ValByName( "CNOMCON"		,Z03->Z03_NOME)
				_oHTML:ValByName( "CDDD"   		,Z03->Z03_DDD)
				_oHTML:ValByName( "CTELCON"		,Z03->Z03_TEL)
				_oHTML:ValByName( "CEMCON"		,Z03->Z03_EMAIL)
				_oHTML:ValByName( "CFUNCON"		,Z03->Z03_FUNCAO)
				_oHTML:ValByName( "CVENDCON"	,Z03->Z03_VEND)
				_oHTML:ValByName( "COBSCON"		,ALLTRIM(Z03->Z03_OBS))
			EndIf
	
			_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
			
			_oProcess:cTo 		:= _cPara   
			_oProcess:cSubject	:= _cAssunto
			_oProcess:Start()
			
/*			If MailDSC(_cPara, _cAssunto, _cMsg, "")
				If RecLock("SZ0",.F.)
					SZ0->Z0_MAILID	:= AllTrim(Iif(!Empty(SZ0->Z0_MAILID),AllTrim(SZ0->Z0_MAILID)+",","") + cMailID)
					SZ0->(MsUnLock())
				EndIf
			EndIf  
*/
		End Transaction
	Next _nI

Return()

Static Function _fEnvEAp(_nOpc)

	Local _aEmail	:= Separa(GetMv("ES_DTFMAIL",,"000335,000148"),",")
	Local _cSend	:= ""
	Local _cAssunto	:= Iif(_nOpc==1,"APROVAÇÃO CADASTRO CLIENTE",Iif(_nOpc==2,"Aprovação de Cadastro de Contato","Aprovação de Amarração"))
	Local _cMsg		:= ""
	Local _cFuncao	:= SU5->(GetAdvFVal("SU5","U5_FUNCAO",xFilial("SU5") + SZ0->Z0_CONTATO,1))
	Local _cVend	:= SU5->(GetAdvFVal("SU5","U5_VEND",xFilial("SU5") + SZ0->Z0_CONTATO,1))
	Local cHostWF	:= GetMv("ES_HWFHOST",,"http://201.28.59.194:8088/WF")
	Local _aBloq	:= {"1=Sim","2=Não"}
	Local _aOptSimp	:= {"1=Sim","2=Não"}
	Local _aPessoa	:= {"F=Fisica","J=Juridica"}
	Local _aTpCli	:= {"F=Cons.Final","L=Produtor Rural","R=Revendedor","S=Solidario","X=Exportacao" }
	Local _aNaturez	:= {}
	Local _aConta	:= {}
	Local _aPais	:= {}
	Local _aPaisB	:= {}
	Local _aSeg1	:= {}
	Local _aClVl	:= {}
	Local _aCNAE	:= {}
	Local _nI		:= 0
	Local _cVendPad	:= GetMv("ES_PRTVEPD",,"000001")

	Do Case	
		Case _nOpc == 1
		
			dbSelectArea("SED")
			SED->(dbSetOrder(1))
			SED->(dbGoTop())
			While SED->(!EOF())
				aAdd(_aNaturez,ALLTRIM(SED->ED_CODIGO) + "-" + ALLTRIM(SED->ED_DESCRIC))
				SED->(dbSkip())
			EndDo
			
			dbSelectArea("CT1")
			CT1->(dbSetOrder(1))
			CT1->(dbGoTop())
			While CT1->(!EOF())
				aAdd(_aConta,ALLTRIM(CT1->CT1_CONTA) + "-" + ALLTRIM(CT1->CT1_DESC01))
				CT1->(dbSkip())
			EndDo
			
			dbSelectArea("CCH")
			CCH->(dbSetOrder(1))
			CCH->(dbGoTop())
			While CCH->(!EOF())
				aAdd(_aPaisB,ALLTRIM(CCH->CCH_CODIGO) + "-" + ALLTRIM(CCH->CCH_PAIS))
				CCH->(dbSkip())
			EndDo
			
			dbSelectArea("SYA")
			SYA->(dbSetOrder(1))
			SYA->(dbGoTop())
			While SYA->(!EOF())
				aAdd(_aPais,ALLTRIM(SYA->YA_CODGI) + "-" + ALLTRIM(SYA->YA_DESCR))
				SYA->(dbSkip())
			EndDo
			
			dbSelectArea("CTH")
			CTH->(dbSetOrder(1))
			CTH->(dbGoTop())
			While CTH->(!EOF())
				aAdd(_aClVl,ALLTRIM(CTH->CTH_CLVL) + "-" + ALLTRIM(CTH->CTH_DESC01))
				CTH->(dbSkip())
			EndDo
			
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbGoTop())
			If SX5->(dbSeek(xFilial("SX5")+PadR("T3",TamSX3("X5_TABELA")[1])))
				While SX5->(!EOF()) .And. AllTrim(SX5->X5_TABELA) == "T3"
					aAdd(_aSeg1,ALLTRIM(SX5->X5_CHAVE) + "-" + ALLTRIM(SX5->X5_DESCRI))
					SX5->(dbSkip())
				EndDo
			EndIf
			
			For _nI	:= 1 To Len(_aEmail)
				Begin Transaction 
					_oProcess	:= TWFProcess():New('000001','Aprovacao - Cad Clientes')
					_oProcess:NewTask( '000002',  "\Workflow\ACliente.html" )
				
					_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
					_oProcess:bReturn	:= "U__fRHDA03()"
					_oHTML   			:= _oProcess:oHTML
					
					_oHTML:ValByName( "CSOLICIT"  	,AllTrim(UsrRetName(__cUserId)) )
					_oHTML:ValByName( "CAPROV"  	,_aEmail[_nI] + " - " + AllTrim(UsrRetName(_aEmail[_nI])) )
					_oHTML:ValByName( "CNOMCLI"  	,SZ0->Z0_NOME )
					_oHTML:ValByName( "CCGC"  		,SZ0->Z0_CNPJ )
					_oHTML:ValByName( "CDDD"  		,SZ0->Z0_DDD)
					_oHTML:ValByName( "CTEL"  		,SZ0->Z0_TEL)
					_oHTML:ValByName( "CINSEST"		,SZ0->Z0_IE)
					_oHTML:ValByName( "COBSINC"		,AllTrim(SZ0->Z0_OBS))
					
					_oHTML:ValByName( "CCONTATO"	,"["+SZ0->Z0_CONTATO+"]-" + SZ0->Z0_NOMCONT + "(" + SUM->(GetAdvFVal("SUM","UM_DESC",xFilial("SUM") + _cFuncao,1)) + ")")
					_oHTML:ValByName( "CEMAILCON"	,SZ0->Z0_EMAIL)
					_oHTML:ValByName( "CTELCON"		,"("+SZ0->Z0_DDDC + ")" + SZ0->Z0_TELC)
					
					_oHTML:ValByName( "CCODIGO"		,SPACE(TAMSX3("A1_COD")[1]))
					_oHTML:ValByName( "CLOJA"		,SPACE(TAMSX3("A1_LOJA")[1]))
					_oHTML:ValByName( "CCEP"  		,SZ0->Z0_CEP )
					_oHTML:ValByName( "CEND"  		,SZ0->Z0_END )
					_oHTML:ValByName( "CBAIRRO"		,SZ0->Z0_BAIRRO)
					_oHTML:ValByName( "CMUN"		,SZ0->Z0_MUN)
					_oHTML:ValByName( "CCODMUN"		,SZ0->Z0_COD_MUN)
					_oHTML:ValByName( "CEST"		,SZ0->Z0_EST)
//					_oHTML:ValByName( "CNATUREZ"	,_aNaturez )
					_oHTML:ValByName( "CVEND"		,_cVendPad + " - " + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + _cVendPad,1)))
//					_oHTML:ValByName( "CCONTAB"		,_aConta )
//					_oHTML:ValByName( "CVALOR"		,_aClVl )
					_oHTML:ValByName( "CSEG1"		,_aSeg1 )
					_oHTML:ValByName( "CCNAE"		,Space(TAMSX3("CC3_COD")[1]) )
					_oHTML:ValByName( "PESSOA"		,_aPessoa )
					_oHTML:ValByName( "BLOQUEIO"	,_aBloq )
					_oHTML:ValByName( "TIPOCLI"		,Iif(SZ0->Z0_TIPO=="F","F=Cons.Final",Iif(SZ0->Z0_TIPO=="L","L=Produtor Rural",Iif(SZ0->Z0_TIPO=="R","R=Revendedor",Iif(SZ0->Z0_TIPO=="S","S=Solidario","X=Exportacao")))) )
					_oHTML:ValByName( "CPAIS"		,_aPais )
					_oHTML:ValByName( "CPAISB"		,_aPaisB )
					_oHTML:ValByName( "COptSimp"	,_aOptSimp )					
					_oHTML:ValByName( "CHAVE"		,SZ0->(Recno()))
			
					_oProcess:cTo := "APVCLIENTE"
					cMailID := _oProcess:Start("\web\messenger\emp"+cEmpAnt+"\APVCLIENTE\")
	
					_cMsg := "<html>"
					_cMsg += "<head>"
					_cMsg += "<title>Untitled Document</title>"
					_cMsg += "</head> "
					_cMsg += "<body> "
					_cMsg += "  <p>&nbsp;</p>"
					_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
					_cMsg += "  <p>Favor acessar o <a href='"+Alltrim(cHostWF)+"/WEB/messenger/emp" + cEmpAnt + "/APVCLIENTE/" + cMailID + ".htm'" +">link</a>" 
					_cMsg += "    para analise de solicitação do cadastro de Cliente. </p>"
					_cMsg += "	<p>Grato(a),"
					_cMsg += "</body>"
					_cMsg += "</html>"
			
					_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
					If MailDSC(_cPara, _cAssunto, _cMsg, "")
						If RecLock("SZ0",.F.)
							SZ0->Z0_MAILID	:= AllTrim(Iif(!Empty(SZ0->Z0_MAILID),AllTrim(SZ0->Z0_MAILID)+",","") + cMailID)
							SZ0->(MsUnLock())
						EndIf
					EndIf  
				End Transaction
			Next _nI
			
		Case _nOpc == 2
			For _nI	:= 1 To Len(_aEmail)
				Begin Transaction 
					_oProcess	:= TWFProcess():New('000001','Aprovacao - Cad Contatos')
					_oProcess:NewTask( '000002',  "\Workflow\AContato.html" )
				
					_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
					_oProcess:bReturn	:= "U__fRHDA3C()"
					_oHTML   			:= _oProcess:oHTML
					
					If !Empty(_cVend)
						_cVend	:= SA3->(GetAdvFVal("SA3","A3_COD",xFilial("SA3") + __cUserID,7))
					EndIf
					
					_oHTML:ValByName( "CSOLICIT"  	,AllTrim(UsrRetName(__cUserId)) )
					_oHTML:ValByName( "CAPROV"  	,_aEmail[_nI] + " - " + AllTrim(UsrRetName(_aEmail[_nI])) )
					_oHTML:ValByName( "CNOMCONT"  	,Z03->Z03_NOME )
					_oHTML:ValByName( "CTEL"  		,"("+Z03->Z03_DDD + ")" + Z03->Z03_TEL)
					_oHTML:ValByName( "CFUNCAO"		,Z03->Z03_FUNCAO + SUM->(GetAdvFVal("SUM","UM_DESC",xFilial("SUM") + Z03->Z03_FUNCAO,1)))
					_oHTML:ValByName( "CEMAIL"		,Z03->Z03_EMAIL)					
					_oHTML:ValByName( "CEMPCONT"	,Z03->Z03_EMPRES)
					_oHTML:ValByName( "CVEND"		,_cVend + " - " + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + _cVend,1)))				
					_oHTML:ValByName( "COBSCON"		,AllTrim(Z03->Z03_OBS))
					_oHTML:ValByName( "CHAVE"		,alltrim(STR(Z03->(Recno()))) + "|" + alltrim(str(SZ0->(Recno()))))
					
					_oProcess:cTo := "APVCONTATO"
					cMailID := _oProcess:Start("\web\messenger\emp"+cEmpAnt+"\APVCONTATO\")
	
					_cMsg := "<html>"
					_cMsg += "<head>"
					_cMsg += "<title>Untitled Document</title>"
					_cMsg += "</head> "
					_cMsg += "<body> "
					_cMsg += "  <p>&nbsp;</p>"
					_cMsg += "  <p>Prezados(as) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
					_cMsg += "  <p>Favor acessar o <a href='"+Alltrim(cHostWF)+"/WEB/messenger/emp" + cEmpAnt + "/APVCONTATO/" + cMailID + ".htm'" +">link</a>" 
					_cMsg += "    para analise de solicitação do cadastro de Contato. </p>"
					_cMsg += "	<p>Grato(a),"
					_cMsg += "</body>"
					_cMsg += "</html>"
			
					_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
					If MailDSC(_cPara, _cAssunto, _cMsg, "")
						If RecLock("SZ0",.F.)
							SZ0->Z0_WFIDCON	:= AllTrim(Iif(!Empty(SZ0->Z0_WFIDCON),AllTrim(SZ0->Z0_WFIDCON)+",","") + cMailID)
							SZ0->(MsUnLock())
						EndIF
						If RecLock("Z03",.F.)
							Z03->Z03_WFID  	:= AllTrim(Iif(!Empty(Z03->Z03_WFID),AllTrim(Z03->Z03_WFID)+",","") + cMailID)
							Z03->(MsUnLock())
						EndIf
					EndIf  
				End Transaction
			Next _nI
	
		Case _nOpc == 3
			For _nI	:= 1 To Len(_aEmail)
				Begin Transaction 
					_oProcess	:= TWFProcess():New('000001','Aprovacao - Amarrcao')
					_oProcess:NewTask( '000002',  "\Workflow\AAmarracao.html" )
				
					_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
					_oProcess:bReturn	:= "U__fRHDA3A()"
					_oHTML   			:= _oProcess:oHTML
					
					_oHTML:ValByName( "CSOLICIT"  	,AllTrim(UsrRetName(SZ0->Z0_USERID)) )
					_oHTML:ValByName( "CAPROV"  	,_aEmail[_nI] + " - " + AllTrim(UsrRetName(_aEmail[_nI])) )
					
					_oHTML:ValByName( "CNOMCONT"  	,"[" + SZ0->Z0_CONTATO+ "]" + SZ0->Z0_NOMCONT )
					_oHTML:ValByName( "CTEL"  		,"("+SZ0->Z0_DDDC + ")" + SZ0->Z0_TELC)
					_oHTML:ValByName( "CEMAIL"		,SZ0->Z0_EMAIL)
					_oHTML:ValByName( "CEMPCONT"	,SZ0->Z0_NOME)
					_oHTML:ValByName( "CVEND"		,_cVend + " - " + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + _cVend,1)))				
					
					_oHTML:ValByName( "CNOMCLI"  	,"[" + SZ0->Z0_CODIGO + "/" + SZ0->Z0_LOJA + "]" + SZ0->Z0_NOME )
					_oHTML:ValByName( "CTELCLI"		,"("+SZ0->Z0_DDD + ")" + SZ0->Z0_TEL)
					_oHTML:ValByName( "CCNPJ"		,SZ0->Z0_CNPJ)					
					_oHTML:ValByName( "CHAVE"		,SZ0->(Recno()) )
					
					_oProcess:cTo := "APVAMARRAC"
					cMailID := _oProcess:Start("\web\messenger\emp"+cEmpAnt+"\APVAMRCC\")
	
					_cMsg := "<html>"
					_cMsg += "<head>"
					_cMsg += "<title>Untitled Document</title>"
					_cMsg += "</head> "
					_cMsg += "<body> "
					_cMsg += "  <p>&nbsp;</p>"
					_cMsg += "  <p>Prezados(as) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
					_cMsg += "  <p>Favor acessar o <a href='"+Alltrim(cHostWF)+"/WEB/messenger/emp" + cEmpAnt + "/APVAMRCC/" + cMailID + ".htm'" +">link</a>" 
					_cMsg += "    para analise de solicitação de amarração de Contato e Cliente. </p>"
					_cMsg += "	<p>Grato(a),"
					_cMsg += "</body>"
					_cMsg += "</html>"
			
					_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
					If MailDSC(_cPara, _cAssunto, _cMsg, "")
						If RecLock("SZ0",.F.)
							SZ0->Z0_WFIDAMR	:= AllTrim(Iif(!Empty(SZ0->Z0_WFIDAMR),AllTrim(SZ0->Z0_WFIDAMR)+",","") + cMailID)
							SZ0->Z0_CADARM	:= "P"
							SZ0->(MsUnLock())
						EndIF
					EndIf  
				End Transaction
			Next _nI
	End Case

Return()

User Function _fRHDA3C(poProcess)

	Local _cNumCont	:= ""
	Local _cOpc		:= alltrim(poProcess:oHtml:RetByName("OPC"))
	Local _cObs		:= alltrim(poProcess:oHtml:RetByName("OBS"))
	Local _cChaveZ1	:= SEPARA(alltrim(poProcess:oHtml:RetByName("CHAVE")),"|")[1]
	Local _cChaveZ0	:= SEPARA(alltrim(poProcess:oHtml:RetByName("CHAVE")),"|")[2]
	Local _cEmail	:= alltrim(poProcess:oHtml:RetByName("CEMAIL"))
	Local _cNome	:= alltrim(poProcess:oHtml:RetByName("CNOMCONT"))
	Local _cTel		:= alltrim(poProcess:oHtml:RetByName("CTEL"))
	Local _cFuncao	:= alltrim(poProcess:oHtml:RetByName("CFUNCAO"))
	Local _cVend	:= Separa(alltrim(poProcess:oHtml:RetByName("CVEND")),"-")[1]
	Local _cEmpCont	:= alltrim(poProcess:oHtml:RetByName("CEMPCONT"))
	
	If _cOpc == "APROVAR"
		Begin Transaction
			_cNumCont	:= NewNumCont()
			
			If RecLock("SU5",.T.)
				SU5->U5_FILIAL	:= xFilial("SU5")
				SU5->U5_CODCONT	:= _cNumCont
				SU5->U5_CONTAT	:= _cNome
				SU5->U5_DDD		:= SubStr(_cTel,2,3)
				SU5->U5_FONE	:= SubStr(_cTel,6,TAMSX3("Z03_TEL")[1])
				SU5->U5_EMAIL	:= _cEmail
				SU5->U5_VEND	:= _cVend
				SU5->U5_FUNCAO	:= _cFuncao
				SU5->(MsUnLock())
			EndIf
		
			dbSelectArea("Z03")
			Z03->(dbSetORder(1))
			Z03->(DbGoTo(Val(_cChaveZ1)))
			If Z03->Z03_FILIAL == xFilial("Z03") .And. AllTrim(Z03->Z03_EMAIL) == AllTrim(_cEmail)
				If RecLock("Z03",.F.)		
					Z03->Z03_STATUS		:= "L"
					Z03->Z03_CODIGO		:= _cNumCont
					Z03->Z03_OBS		:= AllTrim(Z03->Z03_OBS) + " " + _cOBS
					Z03->(MsUnLock())
				EndIF
			EndIf
		
			dbSelectArea("SZ0")
			SZ0->(dbSetORder(1))
			SZ0->(DbGoTo(Val(_cChaveZ0)))
			If SZ0->Z0_FILIAL == xFilial("SZ0") .And. AllTrim(SZ0->Z0_EMAIL) == AllTrim(_cEmail)
				If RecLock("SZ0",.F.)		
					SZ0->Z0_CADCON		:= "O"
					SZ0->Z0_CONTATO		:= _cNumCont
					SZ0->Z0_NOMCONT		:= _cNome
					SZ0->Z0_OBSCONT		:= AllTrim(SZ0->Z0_OBSCONT) + " " + _cOBS
					SZ0->(MsUnLock())
				EndIF
				If SZ0->Z0_CADARM == "P" .And. Empty(Z0_WFIDAMR) .And. !Empty(SZ0->Z0_CONTATO)
					_fEnvEAp(3)
				EndIf
			EndIf		
		End Transaction

	Else
		dbSelectArea("Z03")
		Z03->(dbSetORder(1))
		Z03->(DbGoTo(Val(_cChaveZ1)))
		If Z03->Z03_FILIAL == xFilial("Z03") .And. Z03->Z03_EMAIL == _cEmail
			If RecLock("Z03",.F.)		
				Z03->Z03_STATUS		:= "R"
				Z03->Z03_OBS		:= AllTrim(Z03->Z03_OBS) + " " + _cOBS
				Z03->(MsUnLock())
			EndIF
		EndIf
		
		dbSelectArea("SZ0")
		SZ0->(dbSetORder(1))
		SZ0->(DbGoTo(Val(_cChaveZ0)))
		If SZ0->Z0_FILIAL == xFilial("SZ0") .And. SZ0->Z0_EMAIL == _cEmail
			If RecLock("SZ0",.F.)		
				SZ0->Z0_CADCON		:= "R"
				SZ0->Z0_OBSCONT		:= AllTrim(SZ0->Z0_OBSCONT) + " " + _cOBS
				SZ0->(MsUnLock())
			EndIF
		EndIf
	EndIf

Return()

User Function _fRHDA3A(poProcess)

	_cOpc		:= alltrim(poProcess:oHtml:RetByName("OPC"))
	_cObs		:= alltrim(poProcess:oHtml:RetByName("OBS"))
	_cChaveZ0	:= alltrim(poProcess:oHtml:RetByName("CHAVE"))
	_cCliente	:= SubStr(alltrim(poProcess:oHtml:RetByName("CNOMCLI")),2,TamSX3("A1_COD")[1]+TamSX3("A1_LOJA")[1]+1)
	_cCliente	:= StrTran(_cCliente,"/")
	_cContato	:= SubStr(AllTrim(poProcess:oHtml:RetByName("CNOMCONT")),2,TamSX3("Z0_CONTATO")[1])	
	
	If _cOpc == "APROVAR"
		Begin Transaction 
			dbSelectArea("AC8")
			AC8->(dbSetORder(1))
			If AC8->(!dbSeek(xFilial("AC8") + _cContato + "SA1" + xFilial("SA1") + _cCliente))
				If RecLock("AC8",.T.)
					AC8->AC8_FILIAL	:= xFilial("AC8")
					AC8->AC8_FILENT	:= xFilial("SA1")
					AC8->AC8_ENTIDA	:= "SA1"
					AC8->AC8_CODENT	:= _cCliente
					AC8->AC8_CODCON	:= _cContato
					AC8->(MsUnLock())
				EndIf
			EndIf
			
			dbSelectArea("SZ0")
			SZ0->(dbSetORder(1))
			SZ0->(DbGoTo(Val(_cChaveZ0)))
			If SZ0->Z0_FILIAL == xFilial("SZ0") .And. SZ0->Z0_CNPJ == _cCNPJ
				If RecLock("SZ0",.F.)		
					SZ0->Z0_CADARM	:= "O"
					SZ0->Z0_OBSAMAR	:= AllTrim(SZ0->Z0_OBSAMAR) + " " + _cOBS
					SZ0->(MsUnLock())
				EndIF
			EndIf
		End Transaction 
	Else
		dbSelectArea("SZ0")
		SZ0->(dbSetORder(1))
		SZ0->(DbGoTo(Val(_cChaveZ0)))
		If SZ0->Z0_FILIAL == xFilial("SZ0") .And. SZ0->Z0_CNPJ == _cCNPJ
			If RecLock("SZ0",.F.)		
				SZ0->Z0_CADARM	:= "R"
				SZ0->Z0_OBSAMAR	:= AllTrim(SZ0->Z0_OBSAMAR) + " " + _cOBS
				SZ0->(MsUnLock())
			EndIF
		EndIf
	EndIf

Return()

User Function _fRHDA03(poProcess)

	Local _aClientes	:= {}
	Local _cCodMun		:= ""
	Local _cMensagem	:= ""
	Local _cPara		:= ""
	Local _cAssunto		:= "ERRO - APROVAÇÃO CADASTRO CLIENTE"
	Local _cObsApv		:= ""
	Local _cRecno		:= ""
	Local _aEmail		:= Separa(GetMv("ES_HWCMAIL",,"000271,000318,000408"),",")
	Local _aEmailE		:= Separa(GetMv("ES_DTFMAIL",,"000335,000148"),",")
	Local _nI			:= 0 
	Local _cOpc			:= alltrim(poProcess:oHtml:RetByName("OPC"))
	Local _cObs			:= alltrim(poProcess:oHtml:RetByName("OBS"))
	Local _cCodigo		:= alltrim(poProcess:oHtml:RetByName("CCODIGO"))
	Local _cLoja		:= alltrim(poProcess:oHtml:RetByName("CLOJA"))
	Local _cPessoa		:= SubStr(alltrim(poProcess:oHtml:RetByName("PESSOA")),1,1)
	Local _cNome		:= alltrim(poProcess:oHtml:RetByName("CNOMCLI"))	
	Local _cNReduz		:= alltrim(poProcess:oHtml:RetByName("CNOMRCLI"))	
	Local _cTipoCli		:= SubStr(alltrim(poProcess:oHtml:RetByName("TIPOCLI")),1,1)
	Local _cEnd			:= alltrim(poProcess:oHtml:RetByName("CEND"))
	Local _cCEP			:= alltrim(poProcess:oHtml:RetByName("CCEP"))
	Local _cBairro		:= alltrim(poProcess:oHtml:RetByName("CBAIRRO"))
	Local _cEstado		:= alltrim(poProcess:oHtml:RetByName("CEST"))   
	Local _cCNPJ		:= AllTrim(poProcess:oHtml:RetByName("CCGC"))
	Local _cMun			:= alltrim(poProcess:oHtml:RetByName("CMUN"))
	Local _cCodMun		:= alltrim(poProcess:oHtml:RetByName("CCODMUN"))
	Local _cEst			:= alltrim(poProcess:oHtml:RetByName("CEST"))
	Local _cDDD			:= alltrim(poProcess:oHtml:RetByName("CDDD"))
	Local _cTEL			:= alltrim(poProcess:oHtml:RetByName("CTEL"))
	Local _cInsEst		:= alltrim(poProcess:oHtml:RetByName("CINSEST"))
	Local _cBloq		:= SubStr(alltrim(poProcess:oHtml:RetByName("BLOQUEIO")),1,1)
	Local _cCNAE		:= alltrim(poProcess:oHtml:RetByName("CCNAE"))
	Local _cVend		:= SubStr(alltrim(poProcess:oHtml:RetByName("CVEND")),1,TamSX3("A3_COD")[1])
	Local _cPaisB		:= Separa(alltrim(poProcess:oHtml:RetByName("CPAISB")),"-")[1]
	Local _cSeg1		:= Separa(alltrim(poProcess:oHtml:RetByName("CSEG1")),"-")[1]
	Local _cPais		:= Separa(alltrim(poProcess:oHtml:RetByName("CPAIS")),"-")[1]
	Local _cSolicit		:= alltrim(poProcess:oHtml:RetByName("CSOLICIT"))
	Local _cWFUser		:= Separa(alltrim(poProcess:oHtml:RetByName("CAPROV")),"-")[1]
	Local _cContato		:= alltrim(poProcess:oHtml:RetByName("CCONTATO"))
	Local _cEmailCon	:= alltrim(poProcess:oHtml:RetByName("CEMAILCON"))
	Local _cTelCont		:= alltrim(poProcess:oHtml:RetByName("CTELCON"))
	Local _cGrpCli		:= alltrim(poProcess:oHtml:RetByName("CGrpCli"))
	Local _cOptSimp		:= SubStr(alltrim(poProcess:oHtml:RetByName("COptSimp")),1,1)
	Local _cObsInc		:= alltrim(poProcess:oHtml:RetByName("COBSINC"))
	Local _cProcesso	:= alltrim(poProcess:fProcessID)
	Local _cRecno		:= alltrim(poProcess:oHtml:RetByName("CHAVE"))
	Local _cNaturez		:= GetMv("ES_HWNATUR",,"1002")
	Local _cConta		:= GetMv("ES_HWCONTA",,"1.1.2.01.01")
	
	Private lMsErroAuto	:= .F.
	
	poProcess:Finish()	

	If _cOpc	== "APROVAR"	
	
		_aCliente:={{"A1_FILIAL"    ,XFILIAL("SA1")           				,Nil},;
					{"A1_COD"       ,_cCodigo           					,Nil},;
					{"A1_LOJA"      ,_cLoja             					,Nil},;
					{"A1_PESSOA"    ,_cPessoa								,Nil},;
					{"A1_XVAL1"		,"N"									,Nil},;
				 	{"A1_NOME"      ,_cNome  								,Nil},;
				 	{"A1_NREDUZ"    ,_cNReduz	 							,Nil},;
				 	{"A1_TIPO"      ,_cTipoCli								,Nil},;
				 	{"A1_CEP"		,_cCEP									,Nil},;
				 	{"A1_END"       ,_cEnd									,Nil},;
				 	{"A1_BAIRRO"	,_cBairro								,Nil},;
				 	{"A1_EST"		,_cEst									,Nil},;
				 	{"A1_CGC"		,_cCNPJ									,Nil},;
					{"A1_MUN"       ,_cMun									,Nil},;
					{"A1_COD_MUN"	,_cCodMun								,Nil},;
					{"A1_DDD"		,_cDDD									,Nil},;
					{"A1_INSCR"		,_cInsEst								,Nil},;
					{"A1_TEL"		,_cTEL									,Nil},;
					{"A1_PAIS"		,_cPais									,Nil},;
					{"A1_XVAL2"		,"N"									,Nil},;
					{"A1_NATUREZ"	,_cNaturez								,Nil},;
					{"A1_XVAL3"		,"N"									,Nil},;
					{"A1_XVAL4"		,"N"									,Nil},;
					{"A1_VEND"		,_cVend									,Nil},;
					{"A1_CONTA"		,_cConta								,Nil},;
					{"A1_ATIVIDA"	,_cCNAE									,Nil},;
					{"A1_GRPTRIB"	,_cGrpCli								,Nil},;
					{"A1_SATIV1"	,_cSeg1									,Nil},;
					{"A1_CODPAIS"	,_cPaisB 								,Nil},;
					{"A1_MSBLQL"	,_cBloq  								,Nil},;
					{"A1_SIMPLES"	,_cObsInc  								,Nil},;//					
					{"A1_CLVL"		,"C"+_cCodigo							,Nil},;
					{"A1_CODCNAE"	,_cCNAE									,Nil},;
					{"A1_CNAE"		,_cCNAE									,Nil},;
					{"A1_SOLICIT"	,_cSolicit								,Nil},;
					{"A1_DTCADAS"	,DATE()									,Nil},;
					{"A1_USERLGI"	,"PORTAL - " + _cWFUser					,Nil}}
					
		lMsErroAuto	:= .F.
		MSExecAuto({|x,y| Mata030(x,y)},_aCliente,3)
		
		If !lMsErroAuto
			dbSelectArea("SZ0")
			SZ0->(dbSetORder(1))
			SZ0->(dbGoTo(Val(_cRecno)))
			If SZ0->Z0_FILIAL == xFilial("SZ0") .And. AllTrim(SZ0->Z0_CNPJ) == AllTrim(_cCNPJ)
				_cObsApv := "[" + SubStr(DtoS(DATE()),7,2) + "/" + SubStr(DtoS(DATE()),5,2) + "/" + SubStr(DtoS(DATE()),1,4) + " - " + time() + "]"+CRLF
				_cObsApv += "[ Usuario - " + UsrFullName(_cWFUser) + " ]" +CRLF
				_cObsApv += AllTrim(_cObs)
				_cObsApv += "===========================================" +CRLF
				_cObsApv += AllTrim(MsMM(SZ0->Z0_OBS))
				If RecLock("SZ0",.F.)		
					SZ0->Z0_CODIGO	:= SA1->A1_COD
					SZ0->Z0_LOJA	:= SA1->A1_LOJA
					SZ0->Z0_STATUS	:= "L"
					SZ0->Z0_OBS		:= _cObsApv
					SZ0->Z0_CADCLI	:= "O"
					SZ0->(MsUnLock())
				EndIF
				If SZ0->Z0_CADARM == "P" .And. Empty(Z0_WFIDAMR) .And. !Empty(SZ0->Z0_CONTATO)
					_fEnvEAp(3)
				ElseIf SZ0->Z0_CADCON == "P" .And. Empty(Z0_WFIDCON) .And. Empty(SZ0->Z0_CONTATO)
					_fEnvEAp(2)
				EndIf
				For _nI	:= 1 To Len(_aEmail)
					Begin Transaction 
						_cMsg := "<html>"
						_cMsg += "<head>"
						_cMsg += "<title>Untitled Document</title>"
						_cMsg += "</head> "
						_cMsg += "<body> "
						_cMsg += "  <p>&nbsp;</p>"
						_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
						_cMsg += "  <p>Favor realizar analise dos campos contábeis para o cliente cadastrado: </p>" 
						_cMsg += "	<p>Cliente:" + SA1->A1_COD
						_cMsg += "	<p>Loja:" + SA1->A1_LOJA
						_cMsg += "	<p>Nome:" + SA1->A1_NOME
						_cMsg += "	<p>Grato(a),"
						_cMsg += "</body>"
						_cMsg += "</html>"
						
						_cAssunto	:= "Cadastro de Cliente"
						_cPara		:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
						
						MailDSC(_cPara, _cAssunto, _cMsg, "")
					End Transaction
				Next _nI
			EndIf
		Else	
			_cMensagem	:= AllTrim(MemoRead(NomeAutoLog()))
			
			_cMsg := "<html>"
			_cMsg += "<head>"
			_cMsg += "<title>Untitled Document</title>"
			_cMsg += "</head> "
			_cMsg += "<body> "
			_cMsg += "  <p>&nbsp;</p>"
			_cMsg += "  <p>Prezados(as) Senhores(as), </p>"
			_cMsg += "  <p> Houve erro na confirmação do cadastro de Clientes. Favor realizar a confirmação do cadastro via sistema [Rotina: Pré Cadastro de Clientes].  </p>" 
			_cMsg += "  <p> Cliente: " + _cCNPJ+ "</p>"
			_cMsg += "  <p> Contato: " + _cEmailCon + "</p>"
			_cMsg += "  <p> Registro: " + _cRecno + "</p>"
			_cMsg += "  <p> Erro: </p>"
			_cMsg += "  <p> " + _cMensagem + "</p>"
			_cMsg += "	<p>Grato(a),"
			_cMsg += "</body>"
			_cMsg += "</html>"
	
			For _nI	:= 1 To Len(_aEmailE)
				_cPara	+= Iif(!Empty(_cPara),";","") + AllTrim(UsrRetMail(_aEmailE[_nI]))
			Next
			_cAssunto	:= "ERRO - APROVAÇÃO CADASTRO CLIENTE"
			_cPara		+= ";bzechetti@totalitsolutions.com.br"
			MailDSC(_cPara, _cAssunto, _cMsg, "")
		EndIf			
	Else
		dbSelectArea("SZ0")
		SZ0->(dbSetORder(1))
		If SZ0->(dbSeek(xFilial("SZ0")+_cCNPJ))
			If RecLock("SZ0",.F.)		
				SZ0->Z0_STATUS	:= "C"
				SZ0->Z0_CADCLI	:= "R"
				SZ0->Z0_OBS		:= AllTrim(SZ0->Z0_OBS) + " " + _cOBS
				SZ0->(MsUnLock())
			EndIF
		EndIf
	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet

User Function _fFTCCLI()

	Local _cFilter	:= ""
	Local _aArea	:= GetArea()
	Local _cCliente	:= U_HCIDM010("FILTRO")
	
	If !Empty(_cCliente)
		_cFilter	+= "@#"
		_cFilter	+= "SA1->("            
		_cFilter	+= "SA1->A1_FILIAL == '"+xFilial("SA1")+"'"
		_cFilter	+= " .AND. "
		_cFilter	+= "(SA1->A1_COD $ '"
		_cFilter 	+= _cCliente 
		_cFilter	+= "') "
		_cFilter	+= ")@#"
	EndIf
	RestArea(_aArea)
	
Return _cFilter

//-------------------------------------------------------------------
/*/{Protheus.doc} _fSA1XB
Rotina para criação da consulta padrão de Clientes.

@author 	Bruna Zechetti de Oliveira
@since 		09/09/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function _fSA1XB()

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local olBtn3		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc			:= 0
	Local _cBusca		:= Space(TamSX3("A1_COD")[1])
	Local _nIndice		:= 1
	Local _oIndice		:= Nil
	Local _aBusca		:= {"Codigo","Nome","N.Reduzido","CNPJ/CPF"}
	Local _aArea		:= GetArea()
	
	Private olMark		:= Nil
	Private _cAliasSA1	:= GetNextAlias()
	
	aAdd(alCampos,{"COD"	,,"Codigo"			,"@!"})
	aAdd(alCampos,{"LOJA"	,,"Loja"			,"@!"})
	aAdd(alCampos,{"NOME"	,,"Nome"			,"@!"})	
	aAdd(alCampos,{"NREDUZ"	,,"Nome Reduzido"	,"@!"})	
	aAdd(alCampos,{"CGC"	,,"CNPJ/CPF"		,PesqPict("SA1","A1_CGC")})	

	aAdd(alEstrut,{"COD"	,"C",TamSX3("A1_COD")[1]	,TamSX3("A1_COD")[2]})
	aAdd(alEstrut,{"LOJA"	,"C",TamSX3("A1_LOJA")[1]	,TamSX3("A1_LOJA")[2]})	
	aAdd(alEstrut,{"NOME"	,"C",TamSX3("A1_NOME")[1]	,TamSX3("A1_NOME")[2]})	
	aAdd(alEstrut,{"NREDUZ"	,"C",TamSX3("A1_NREDUZ")[1]	,TamSX3("A1_NREDUZ")[2]})	
	aAdd(alEstrut,{"CGC"	,"C",TamSX3("A1_CGC")[1]	,TamSX3("A1_CGC")[2]})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select((_cAliasSA1)) > 0
		(_cAliasSA1)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,_cAliasSA1,.F.)
	
	INDEX ON COD 	TAG IND1 TO &clNomTmp
	INDEX ON NOME 	TAG IND2 TO &clNomTmp
	INDEX ON NREDUZ	TAG IND3 TO &clNomTmp
	INDEX ON CGC 	TAG IND4 TO &clNomTmp

	FGrvTMP(1)

	(_cAliasSA1)->(dbSetOrder(1))
	(_cAliasSA1)->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE "Cadastro de Clientes"
	
		olMark	:= MsSelect():New((_cAliasSA1),"",,alCampos,,@clMarca,{35,04,200,250})
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP(_nIndice),(_cAliasSA1)->(dbGoTop()),olMark:oBrowse:Refresh(),;
																												_cBusca	:= Iif(ValType(_nIndice)=="C",Iif(SubStr(_nIndice,1,2)=="Co",Space(TAMSX3("A1_COD")[1]),Iif(SubStr(_nIndice,1,2)=="No",Space(TAMSX3("A1_NOME")[1]),Space(TAMSX3("A1_CGC")[1]))),Space(100)),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,210 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqDSP(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,210 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP(_nIndice), _cBusca	:= Iif(ValType(_nIndice)=="C",Iif(SubStr(_nIndice,1,2)=="Co",Space(TAMSX3("A1_COD")[1]),Iif(SubStr(_nIndice,1,2)=="No",Space(TAMSX3("A1_NOME")[1]),Space(TAMSX3("A1_CGC")[1]))),Space(100)),olDlgTip:Refresh())				PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 			SIZE 40,12 ACTION (_nOpc:=1,olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
	
	If _nOpc == 1
		Do Case
			Case FUNNAME() == "MATA415"
				M->CJ_CLIENTE	:= (_cAliasSA1)->COD
				M->CJ_LOJA		:= (_cAliasSA1)->LOJA
				
			Case FUNNAME() == "HCIDA011"
				M->US_COD		:= (_cAliasSA1)->COD
				M->US_LOJA		:= (_cAliasSA1)->LOJA
				M->US_CODCLI	:= (_cAliasSA1)->COD
				M->US_LOJACLI	:= (_cAliasSA1)->LOJA
				M->US_DESCCLI	:= (_cAliasSA1)->NOME
				
			Case FUNNAME() == "HCIDA019"
			    M->AD5_CODCLI	:= (_cAliasSA1)->COD
			    M->AD5_LOJA		:= (_cAliasSA1)->LOJA
			    				
		EndCase
		
		dbSelectArea("SA1")
		SA1->(dbSetORder(1))
		SA1->(dbSeek(xFIlial("SA1") + (_cAliasSA1)->COD + (_cAliasSA1)->LOJA))
		Return((_cAliasSA1)->COD)

	EndIF
	
	RestArea(_aArea)
	
Return("")

//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqDSP
Função para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqDSP(_nOpc,_cBusca)

	If ValType(_nOpc) == "C"
		_nOpc	:= Iif(SubStr(_nOpc,1,2)=="Co",1,Iif(SubStr(_nOpc,1,2)=="No",2,Iif(SubStr(_nOpc,1,2)=="N.",3,4)))
	EndIf

    (_cAliasSA1)->(dbSetOrder(_nOpc))
    (_cAliasSA1)->(dbSeek(AllTrim(_cBusca)))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP
Função para gravação dos dados da consulta padrão de Despesas.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP(_nOpc)

	Local _cQuery	:= ""
	Local _cCodCli	:= U_HCIDM010("CLIENTE")
	Local _cAlias02	:= GetNextAlias()
	Local _nI		:= 0

	If Select((_cAliasSA1)) > 0
		(_cAliasSA1)->(dbGoTop())
		If (_cAliasSA1)->(!Eof())
			While (_cAliasSA1)->(!Eof())
				If RecLock((_cAliasSA1), .F., .T.)
					(_cAliasSA1)->( dbDelete() )
					(_cAliasSA1)->( MsUnLock() )
				EndIf
				(_cAliasSA1)->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_NREDUZ "
	_cQuery	+= " FROM " + RetSqlName("SA1") 
	_cQuery	+= " WHERE A1_FILIAL = '" + xFilial("SA1") + "' "
	If !Empty(_cCodCli)
		_cQuery	+= " AND A1_COD||A1_LOJA IN (" + _cCodCli + ") "
	EndIf
	_cQuery	+= " AND A1_MSBLQL <> '1' "
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY A1_COD, A1_LOJA "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock((_cAliasSA1),.T.)
				(_cAliasSA1)->COD	:= (_cAlias02)->A1_COD
				(_cAliasSA1)->LOJA	:= (_cAlias02)->A1_LOJA
				(_cAliasSA1)->NOME	:= (_cAlias02)->A1_NOME
				(_cAliasSA1)->NREDUZ:= (_cAlias02)->A1_NREDUZ
				(_cAliasSA1)->CGC	:= (_cAlias02)->A1_CGC
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    (_cAliasSA1)->(dbSetOrder(1))

Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fSU5XB
Rotina para criação da consulta padrão de Contatos.

@author 	Bruna Zechetti de Oliveira
@since 		30/09/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function _fSU5XB()

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local olBtn3		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc			:= 0
	Local _cBusca		:= Space(TamSX3("U5_CODCONT")[1])
	Local _nIndice		:= 1
	Local _oIndice		:= Nil
	Local _aBusca		:= {"Codigo","Nome"}
	Private olMark		:= Nil
	Private _cAliasSU5	:= GetNextAlias()
	
	aAdd(alCampos,{"COD"	,,"Codigo"			,"@!"})
	aAdd(alCampos,{"NOME"	,,"Nome"			,"@!"})	

	aAdd(alEstrut,{"COD"	,"C",TamSX3("U5_CODCONT")[1]	,TamSX3("U5_CODCONT")[2]})
	aAdd(alEstrut,{"NOME"	,"C",TamSX3("U5_CONTAT")[1]		,TamSX3("U5_CONTAT")[2]})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select((_cAliasSU5)) > 0
		(_cAliasSU5)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,_cAliasSU5,.F.)
	
	INDEX ON COD 	TAG IND1 TO &clNomTmp
	INDEX ON NOME 	TAG IND2 TO &clNomTmp

	FGrvTMP2(1)

	(_cAliasSU5)->(dbSetOrder(1))
	(_cAliasSU5)->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE "Cadastro de Contatos"
	
		olMark	:= MsSelect():New((_cAliasSU5),"",,alCampos,,@clMarca,{35,04,200,250})
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP2(_nIndice),(_cAliasSU5)->(dbGoTop()),olMark:oBrowse:Refresh(),;
																												_cBusca	:= Iif(ValType(_nIndice)=="C",Iif(SubStr(_nIndice,1,1)=="C",Space(TAMSX3("U5_CODCONT")[1]),Space(TAMSX3("U5_CONTAT")[1])),Space(100)),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,210 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqCON(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,210 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP2(_nIndice), _cBusca	:= Iif(ValType(_nIndice)=="C",if(SubStr(_nIndice,1,1)=="C",Space(TAMSX3("U5_CODCONT")[1]),Space(TAMSX3("U5_CONTAT")[1])),Space(100)),olDlgTip:Refresh())				PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 			SIZE 40,12 ACTION (_nOpc:=1,olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
	
	If _nOpc == 1
		dbSelectArea("SU5")		
		SU5->(dbSetORder(1))
		SU5->(dbSeek(xFilial("SU5")+(_cAliasSU5)->COD))
		Return((_cAliasSU5)->COD)

	EndIF
	
Return("")

//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqCON
Função para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqCON(_nOpc,_cBusca)

	If ValType(_nOpc) == "C"
		_nOpc	:= Iif(SubStr(_nOpc,1,2)=="C",1,2)
	EndIf

    (_cAliasSU5)->(dbSetOrder(_nOpc))
    (_cAliasSU5)->(dbSeek(AllTrim(_cBusca)))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP2
Função para gravação dos dados da consulta padrão de Contatos.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP2(_nOpc)

	Local _cQuery	:= ""
	Local _cCodCon	:= Iif(ALLTRIM(UPPER(FunName())) ==	"HCIA017" .OR. ALLTRIM(UPPER(FunName())) ==	"RFATA014",U_HCIDM010("FOLLOW"),U_HCIDM010("PRECLI"))
	Local _cAlias02	:= GetNextAlias()
	Local _cFunNome	:= FunName()
	Local _cCliente	:= ""
	Local _nI		:= 0
	
	Do Case
		Case ALLTRIM(UPPER(_cFunNome)) ==	"HCIDA011"
			_cCliente	:= M->US_COD+M->US_LOJA
		Case ALLTRIM(UPPER(_cFunNome)) ==	"HCIDA018"
			_cCliente	:= M->Z02_CLIENT+M->Z02_LOJAC
	End Case

	If Select((_cAliasSU5)) > 0
		(_cAliasSU5)->(dbGoTop())
		If (_cAliasSU5)->(!Eof())
			While (_cAliasSU5)->(!Eof())
				If RecLock((_cAliasSU5), .F., .T.)
					(_cAliasSU5)->( dbDelete() )
					(_cAliasSU5)->( MsUnLock() )
				EndIf
				(_cAliasSU5)->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	U5_CODCONT, U5_CONTAT  "
	_cQuery	+= " FROM " + RetSqlName("SU5") + " SU5 "
	
	If !Empty(_cCliente)
		_cQuery	+= " INNER JOIN " + RetSqlName("AC8") + " AC8 "
		_cQuery	+= " ON AC8_FILIAL = '" + xFilial("AC8") + "' "
		_cQuery	+= " AND AC8_ENTIDA = 'SA1' "
		_cQuery	+= " AND AC8_CODENT = '" + _cCliente + "' "
		_cQuery	+= " AND AC8_CODCON = U5_CODCONT " 
		_cQuery	+= " AND AC8.D_E_L_E_T_ = ' ' "
	EndIf
	
	_cQuery	+= " WHERE U5_FILIAL = '" + xFilial("SU5") + "' "
	If !Empty(_cCodCon)
		_cQuery	+= " AND U5_CODCONT IN (" + _cCodCon + ") "
	EndIf
	_cQuery	+= " AND SU5.D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY U5_CODCONT, U5_CONTAT "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock((_cAliasSU5),.T.)
				(_cAliasSU5)->COD	:= (_cAlias02)->U5_CODCONT
				(_cAliasSU5)->NOME	:= (_cAlias02)->U5_CONTAT
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    (_cAliasSU5)->(dbSetOrder(1))

Return(Nil)