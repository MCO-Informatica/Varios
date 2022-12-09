#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#Include "Tbicode.ch"
#Include "Tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
User Function RECEMAIL()

 Processa({||ProcRecMail()},cCadastro,"Lendo E-mail, aguarde...")

Return

Static FuncTion	ProcRecMail()
Local oServer   := NIL
Local oMessage  := NIL
Local nNumMsg   := 0
Local nTam      := 0
Local nI        := 0
Local nAttach   := 0, nI := 0
Local nMessages := 0
Local aAttInfo  := {}
Local cBaseName := "", cName := ""
Local xRet
Local nIndex := 1
a_Xml :={}
oServer := TMailManager():New()
// Cria sessão o INI automatico se preferir crie manualmente no appserver.ini
 writePProString( "Mail", "Protocol", "POP3", getsrvininame() )
// Se conexão eh autenticada  descomentar a linha abaixo
 oServer:SetUseSSL( .T. )
// oMail:Init( EMAIL_POPSERVER, EMAIL_SMTPSERVER, EMAIL_ACCOUNT, EMAIL_PASSWORD )
// xRet := oServer:Init( "smtplw.com.br", "", "agrozootec", "CNlYvjIz4807", 0, 587 )
// xRet := oServer:Init( "mail.agrozootec.com.br", "smtplw.com.br", "fiscal@agrozootec.com.br", "agrozootec@123", 0, 587 )
// xRet := oServer:Init( "mail.agrozootec.com.br", "mail.agrozootec.com.br", "fiscal@agrozootec.com.br", "agrozootec@123", 0, 587 )
// xRet := oServer:Init( "email-ssl.com.br", "email-ssl.com.br", "fiscal@agrozootec.com.br", "Agro241183@", 0, 587 )
// smtp.gruposhangrila.com.br:587
// xRet := oServer:Init( "pop.gruposhangrila.com.br", "pop.gruposhangrila.com.br", "nfe@gruposhangrila.com.br", "Shan1819", 0, 587 )

xRet := oServer:Init( "pop.gmail.com", "", "nfe.shangrila@gmail.com", "Nfe010105", 995, 465 ) 
//xRet := oServer:Init( "pop.kinghost.com.br", "", "nfe@gruposhangrila.com.br", "Shan2021", 0, 587 )

if xRet <> 0
	conout( "Could not initialize mail server: " + oServer:GetErrorString( xRet ) )
	return
endif

If oServer:SetPopTimeOut( 300 ) != 0
    Conout( "Falha ao setar o time out" )
    Return .F.
 EndIf

xRet := oServer:POPConnect()

if xRet <> 0                                  
	conout( "Could not connect on POP3 server: " + oServer:GetErrorString( xRet ) )
	return
endif

oServer:GetNumMsgs( @nMessages )

conout( "Number of messages: " + cValToChar( nMessages ) )
nTam := nMessages
cBaseName := GetSrvProfString( "RootPath", "" )
if Right( cBaseName, 1 ) <> '\'
	cBaseName += '\'
endif
cBaseName += "mail\pop3\"
xBaseName := "\mail\pop3\"
cDirErro  := xBaseName+"invalidos\"
cDirOk    := xBaseName+"processados\"

MakeDir(cDirErro)
MakeDir(cDirOk)
Procregua(nMessages)
oMessage := TMailMessage():New()
//Verifica todas mensagens no servidor
For nMessage := 1 To nMessages
	IncProc()
	oMessage:Clear()
	nPopResult := oMessage:Receive( oServer, nMessage)
	l_GrvZZS := .F.
	if (nPopResult == 0 ) //Recebido com sucesso?
		nCount := 0
		lMessageDown := .F.
		n_TotMsg := oMessage:getAttachCount()
		//If n_TotMsg > 5
		//	n_TotMsg := 5
		//EndIf	
		//Verifica todos anexos da mensagem e os salva
		x_ChvPDF := ""
		For nAtach := 1 to n_TotMsg // oMessage:getAttachCount()
			aAttInfo:= oMessage:getAttachInfo(nAtach)
				If Upper(Right(aAttInfo[1],3)) == "XML"
					lSave := oMessage:SaveAttach(nAtach, cBaseName+aAttInfo[1])
					If lSave
						cXMLFile := xBaseName+aAttInfo[1]
						cNewArq  := Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))
						cXML     := MEMOREAD( cXMLFile )
						oXml     := XmlParser ( cXML, "_", @errStr, @warnStr )
						cTag1    := "<cteProc"
						cTag2    := "<CTe"
						cTag3    := "<infCte"
						nPosTag1 := At(cTag1,cXML)
						nPosTag2 := At(cTag2,cXML)
						nPosTag3 := At(cTag3,cXML)
						cChaveNfe:= ""
						// NFE
						cNfeTag1 := "<nfeProc"
						cNfeTag2 := "<NFe"
						cNfeTag3 := "CNPJ"
						cNfeTag4 := "<dEmi"
						cNfeTag5 := "<protNFe"
						nPosNfe1 := At(cNfeTag1,cXML)
						nPosNfe2 := At(cNfeTag2,cXML)
						nPosNfe3 := At(cNfeTag3,cXML)
						nPosNfe4 := At(cNfeTag4,cXML)
						nPosNfe5 := At(cNfeTag5,cXML)
						l_Cte := .T.
						l_Nfe := .F.
						
						If nPosNfe1 > 0 .And. nPosNfe5 > 0 .And. nPosNfe2 > 0
							l_Nfe := .T.
						EndIf
						
						If ! l_Nfe
			
							l_Ok := .T.
							If (nPosTag1 = 0 .And. nPosTag3 = 0 ) .Or. nPosTag2 = 0  // .Or. nPosTag5 = 0 // .Or. nPosTag6 = 0
								l_Ok := .F.
								aadd(a_Xml,cNewArq + " - XML nao e de CTe"  )
								__CopyFile(cXMLFile,cDirErro+cNewArq)
								Ferase(cXMLFile)
								Loop
							EndIf
							
							lCteproc := .F.
							If nPosTag1 > 0                       
								lCteproc := .T.
							EndIf
							If lCteproc
								cChave  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
								cChave  := Substr(cChave,4,45)
								If cChave == "43180918233211000482570010000619271863414487"
									xx:= '1'
								EndIf
								oDest   :=oXML:_CTEPROC:_CTE:_INFCTE:_DEST
								If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ") <> "U"
									c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
								Else
								    c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CPF:TEXT
								EndIf	
								If Type("oDest:_CPF") <> "U"
									c_DestCNPJ := oDest:_CPF:TEXT
								Else
									c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
								EndIf
								dEmissao   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
								//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
								nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
								nDia    := Substr(dEmissao,9,2)
								nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
								
							Else
								cChave  := oXml:_CTE:_INFCTE:_ID:TEXT
								cChave  := Substr(cChave,4,45)
								oDest   := oXML:_CTE:_INFCTE:_DEST
								If Type("oDest:_CPF") <> "U"
									c_DestCNPJ := oDest:_CPF:TEXT
								Else
									c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
								EndIf
								c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
								dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
								nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
								nDia    := Substr(dEmissao,9,2)
								nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
							EndIf
							cChave  := StrTran(cChave,'-','')
							cChave  := StrTran(cChave,'.','')
							cChave  := StrTran(cChave,'/','')+Space(10)
							cChave  := Substr(cChave,1,45)
							
							dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
							
							If lCteproc
								cCnpj := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
							Else
								cCnpj := oXml:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
							EndIf
							// Tag do XML: toma3 -> toma
							//	Indicador do "papel" do tomador do serviço no CT-e.
							//	0 - Remetente;
							//	1 - Expedidor;
							//	2 - Recebedor;
							//	3 - Destinatário.
							c_Tomador := ""
							l_toma3 := .F.
							If Type("oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA") <> "U"
								l_toma3 := .T.
								c_Toma := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
								If c_Toma == "0"	// Remetente
									c_Tomador := c_RemCNPJ
								ElseIf c_Toma == "1"// Expedidor
									If Type("oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ") <> "U"
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT
									Else
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CPF:TEXT
									EndIf
								ElseIf c_Toma == "2" // Recebedor
									If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT
									Else
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CPF:TEXT
									EndIf
								ElseIf c_Toma == "3"  // Destinatario
									If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
									Else
										c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT
									EndIf
								EndIf
							EndIf
							cCnpj    := StrTran(cCnpj,'.','')
							cCnpj    := StrTran(cCnpj,'/','')
							cCnpj    := StrTran(cCnpj,'-','')
							cCliFor  := "S"
							cCodCF   := ""
							cLoj     := ""
							a_Cnpj    := {}
							l_Agro    := .F.
							l_Entrada := .F.
							l_Saida   := .F.
							l_Tomador := .F.
							dbSelectArea("SM0")
							nRegSM0 := SM0->(Recno())
							dbSetOrder(1)
							SM0->(DbGoTop())
							While SM0->(!Eof())
								If c_RemCNPJ == SM0->M0_CGC
									l_Agro  := .T.
									aadd(a_Cnpj,{SM0->M0_CODFIL,"R"})
								EndIf
								If c_DestCNPJ == SM0->M0_CGC
									l_Agro  := .T.
									aadd(a_Cnpj,{SM0->M0_CODFIL,"D"})
								EndIf
								If c_Tomador == SM0->M0_CGC
									l_Tomador := .T.	
								EndIf
								SM0->(dbSkip())
							Enddo
							SM0->(DbGoTo(nRegSM0))
							If ! l_Tomador .And. l_toma3
								aadd(a_Xml,cChaveNfe+ " - Tomador não é a Shangrila" )
								__CopyFile(cXMLFile,cDirErro+cNewArq)
								Ferase(cXMLFile)
								Return .F.
							EndIf
							If Len(a_Cnpj) > 1
								for i = 1 to len(a_Cnpj)
									// Pega filial do remetente
									if a_Cnpj[i][2] == "R"
										_cFil := a_Cnpj[i][1]
									endif
								next
							EndIf
	
							If  ! l_Agro //  ! l_Entrada .And. !l_Saida
								aadd(a_Xml,cChaveNfe+ " - CNPJ Remetente/Destinatario nao e da Agrozootec" )
								
								__CopyFile(cXMLFile,cDirErro+cNewArq)
								
								Ferase(cXMLFile)
								Return .F.
							EndIf
							cStatus := "0"
							DbSelectArea("SA2")
							DbSetOrder(3)
							If DbSeek(xFilial("SA2") + cCnpj )
								cCliFor := "F"
								cCodCF  := SA2->A2_COD
								cLoj    := SA2->A2_LOJA
								If SA2->A2_MSBLQL == "1"
									cStatus := "5"
									aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " Bloqueado no Cadastro de Fornecedor." )
								EndIf
							Else
								aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " nao encontrado no Cadastro de Fornecedor." )
								cStatus := "5"
							EndIf
							CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
							cDoc     := Substr(cChave,26,9)
							// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota  8= Regra ZZQ/ZZP nao localizada
							DbSelectArea("ZZS")
							DbSetOrder(1)
							IF  DbSeek(xFilial("ZZS") + cChave )
								Reclock("ZZS",.F.)
									ZZS->ZZS_CGC     := cCnpj
									ZZS->ZZS_EMISSA  := dEmissao
									ZZS->ZZS_DOC     := StrZero(Val(cDoc),9)
									ZZS->ZZS_SERIE   := CSERIE
									ZZS->ZZS_CLIFOR  := cCodCF
									ZZS->ZZS_LOJA    := cLoj
									ZZS->ZZS_XML     := cXML
									// ZZS->ZZS_STATUS  := cStatus
									ZZS->ZZS_ESPECI  := "CTE"
								MsUnlock()
								n_RegXML := ZZS->(Recno())
								l_GrvZZS := .T.
							Else
								Reclock("ZZS",.T.)
									ZZS->ZZS_FILIAL := xFilial("ZZS") // _cFil
									ZZS->ZZS_CHAVE  := cChave
									ZZS->ZZS_CGC    := cCnpj
									ZZS->ZZS_EMISSA := dEmissao
									ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
									ZZS->ZZS_SERIE  := CSERIE
									ZZS->ZZS_XML    := cXML
									ZZS->ZZS_STATUS := cStatus
									ZZS->ZZS_ESPECI := "CTE"
									ZZS->ZZS_CLIFOR := cCodCF
									ZZS->ZZS_LOJA   := cLoj
								MsUnlock()
								n_RegXML := ZZS->(Recno())
								DbSelectArea("ZZT")
								RecLock("ZZT",.T.)
									ZZT->ZZT_FILIAL := xFilial("ZZT") //
									ZZT->ZZT_CHAVE  := cChave
									ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
									ZZT->ZZT_CLIFOR := cCodCF
									ZZT->ZZT_LOJA   := cLoj
									ZZT->ZZT_OCORRE := "Carga Inicial. "
								MsUnlock()
								l_GrvZZS := .T.
							EndIf
							x_ChvPDF := cChave
							_nPosIniICM	:=At("<pICMS",cXML)
							_nPosFimICM :=At("</pICMS",cXML)
							_nPosIniICM += 7
							nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Copia o arquivo para a pasta processados e apaga arquivo lido      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							__CopyFile(cXMLFile,cDirOk+cNewArq)
							Ferase(cXMLFile)
							//conout("Retorno do Erase: "+Str(Ferror(),10))
							oXml := Nil
							DelClassIntf()
						Else
							// NF-e
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Le as Tags necessarias para a tabela SZX  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//<dhEmi>2018-06-29T00:00:00-03:00</dhEmi>
							dEmissao   := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
							nDia    := Substr(dEmissao,9,2) // RAt("-",dEmissao)+1,2)
							nMes    := Substr(dEmissao,6,2) // At("-",dEmissao)+1,2)
							nAno    := Substr(dEmissao,1,4) // ,At("-",dEmissao)-1)
							
							dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
							If  '38908778000176' $ oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
								// Nfe de saida
								__CopyFile(cXMLFile,cDirErro+cNewArq)
								Ferase(cXMLFile)
								Return .F.
							EndIf
							c_DestCNPJ   := oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
							lNota := .F.
							_cNotaXml := "2"
							
							l_SM0 := .F.
							
							dbSelectArea("SM0")
							nRegSM0 := SM0->(Recno())
							dbSetOrder(1)
							SM0->(DbGoTop())
							While SM0->(!Eof())
								If c_DestCNPJ == SM0->M0_CGC // Se Destino do Frete for Golden frete s/ Compra
									l_SM0 := .T.
									_cEmp := SM0->M0_CODIGO
									_cFil := SM0->M0_CODFIL
									Exit
									// aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
								EndIf
								SM0->(dbSkip())
							Enddo
							SM0->(DbGoTo(nRegSM0))
							l_SM0 := .T.
							If  ! l_SM0
								aadd(a_Xml,cChaveNfe+ " - CNPJ Destinatario nao e a Shangrila" )
								
								__CopyFile(cXMLFile,cDirErro+cNewArq)
								
								Ferase(cXMLFile)
								Return .F.
							EndIf
							
							cCnpj       := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
							cCnpj    := StrTran(cCnpj,'.','')
							cCnpj    := StrTran(cCnpj,'/','')
							cCnpj    := StrTran(cCnpj,'-','')
							cCliFor  := "S"
							cCodCF   := ""
							cLoj     := ""
							_CtipoNF := "N"
							cStatus  := "X"
							DbSelectArea("SA2")
							DbSetOrder(3)
							If DbSeek(xFilial("SA2") + cCnpj )
								cCliFor := "F"
								cCodCF  := SA2->A2_COD
								cLoj    := SA2->A2_LOJA
								_CtipoNF := "N"
								If SA2->A2_MSBLQL == "1"
									cStatus := "5"
								EndIf
								//	_cNotaXml := Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XXML")
								//	_cTes     := Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XTES")
								// Verifica se gera Nota fiscal
								If _cNotaXml == "1"  // 1=Sim 2-Nao
									lNota := .T.
								EndIf
							Else
								cStatus := "9"
							EndIf
							cChave  := oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT
							cChave  := Substr(cChave,4,45)
							cChave  := StrTran(cChave,'-','')
							cChave  := StrTran(cChave,'.','')
							cChave  := StrTran(cChave,'/','')+Space(10)
							cChave  := Substr(cChave,1,45)
							
							CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
							cDoc     := Substr(cChave,26,9)
							conout("Chave NFE: "+cChave)
							
							// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota
							DbSelectArea("ZZS")
							DbSetOrder(1)
							IF ! DbSeek(xFilial("ZZS")+ cChave )
								Reclock("ZZS",.T.)
								ZZS->ZZS_FILIAL := xFilial("ZZS")
								ZZS->ZZS_CHAVE  := cChave
								ZZS->ZZS_CGC    := cCnpj
								ZZS->ZZS_EMISSA := dEmissao
								//	cDoc     := Substr(SZX->ZX_CHAVE,26,9)
								//	cDoc     := Right(cDoc,6)
								ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
								ZZS->ZZS_SERIE  := CSERIE
								ZZS->ZZS_XML     := cXML
								ZZS->ZZS_STATUS := "0"
								ZZS->ZZS_ESPECI := "SPED"
								ZZS->ZZS_CLIFOR  := cCodCF
								ZZS->ZZS_LOJA    := cLoj
	
								MsUnlock()
								//	_nPosIniICM	:=At("<pICMS",cXML)
								//	_nPosFimICM :=At("</pICMS",cXML)
								//	_nPosIniICM += 7
								//	nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
								l_GrvZZS := .T.
								DbSelectArea("ZZT")
								RecLock("ZZT",.T.)
								ZZT->ZZT_FILIAL := xFilial("ZZT")
								ZZT->ZZT_CHAVE  := cChave
								ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
								ZZT->ZZT_CLIFOR := cCodCF
								ZZT->ZZT_LOJA   := cLoj
								ZZT->ZZT_OCORRE := "Carga Inicial.  NF-e"
								MsUnlock()
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Copia o arquivo para a pasta processados e apaga arquivo lido      ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								__CopyFile(cXMLFile,cDirOk+cNewArq)
								Ferase(cXMLFile)
								
							EndIf
						EndIf
						
					Else
						conout( "Saving attachment " + cValToChar( nI ) + ": " + aAttInfo[1] )
					ENdIf
			ENdIf
		Next

		For nAtach := 1 to n_TotMsg // oMessage:getAttachCount()
			aAttInfo:= oMessage:getAttachInfo(nAtach)
			If Upper(Right(aAttInfo[1],3)) == "PDF" .And. ( Upper(Left(aAttInfo[1],2)) == "CT" .Or. Upper(Left(aAttInfo[1],1)) $ "1,2,3,4,5,6,7,8,9,0" ) 
 				lSave := oMessage:SaveAttach(nAtach, cBaseName+aAttInfo[1])
				If lSave 
					cPDFFile := xBaseName+aAttInfo[1]
					cNewArq  := Substr(cPDFFile,Rat("\",cPDFFile)+1,Len(Alltrim(cPDFFile)))
					If ! EmpTy(x_ChvPDF)
					
						_xSqlExec := "UPDATE ZZS010 SET ZZS_DANFE = ( SELECT " 
						_xSqlExec += "* FROM OPENROWSET (BULK '" + cPDFFile +"',SINGLE_BLOB) as arquivo ) "
						_xSqlExec += "WHERE ZZS_CHAVE = '" + x_ChvPDF + "' "
						TcSqlExec(_xSqlExec)
						dbcommit()
						MsUnLockAll()
						__CopyFile(cPDFFile,cDirOk+cNewArq)
						
					EndIf
					Ferase(cPDFFile)
				Else
					conout( "Saving attachment " + cValToChar( nI ) + ": " + aAttInfo[1] )
				EndIf
			EndIf
		Next
		If l_GrvZZS 
			// Deleta mensagem
			// oMessage:SetConfirmRead(.T.)
			oServer:DeleteMsg(nMessage)
		EndIf
	EndIf
Next

xRet := oServer:POPDisconnect()

if xRet <> 0
	
	conout( "Could not disconnect from POP3 server: " + oServer:GetErrorString( xRet ) )
	
endif

return

User FUNCTION YOleContainer()
Local cDirDanf := "C:\danfes\"
MakeDir(cDirDanf)
c_File := "C:\danfes\" + ZZS->ZZS_CHAVE+ ".pdf"
If EmpTy(ZZS->ZZS_DANFE)
	Alert("Danfe não anexada... Utilize consulta resumida.")
	Return
EndIf	

If Select(c_File) == 0 
	/* Executar uma vez no banco de dados
	xQry := "sp_configure 'show advanced options', 1; " + CRLF
	xQry += "GO "+ CRLF
	xQry += "RECONFIGURE; "+ CRLF
	xQry += "GO "+ CRLF
	xQry += "sp_configure 'Ole Automation Procedures', 1; "+ CRLF
	xQry += "GO "+ CRLF
	xQry += "RECONFIGURE; "+ CRLF
	xQry += "GO "+ CRLF
	*/
	xQry := "DECLARE @pctStr INT "+ CRLF
	xQry += "DECLARE @image VARBINARY(MAX) "+ CRLF
	// --- aqui você substitui pela tabela e faz a query. Você também pode criar uma proc que exporte tudo
	xQry += "SET @image = (SELECT ZZS_DANFE FROM "+ RetSqlName("ZZS")+" WHERE ZZS_CHAVE= '" + ZZS->ZZS_CHAVE + "') "+ CRLF
	xQry += "DECLARE @filePath VARCHAR(8000)"+ CRLF
	xQry += "SET @filePath = 'C:\Sistema\Totvs12\protheus_data\danfes\" + ZZS->ZZS_CHAVE + ".pdf' "+ CRLF
	xQry += "EXEC sp_OACreate 'ADODB.Stream', @pctStr OUTPUT "+ CRLF
	xQry += "EXEC sp_OASetProperty @pctStr, 'Type', 1 "+ CRLF
	xQry += "EXEC sp_OAMethod @pctStr, 'Open' "+ CRLF
	xQry += "EXEC sp_OAMethod @pctStr,  'Write', NULL, @image "+ CRLF
	xQry += "EXEC sp_OAMethod @pctStr, 'SaveToFile', NULL,@filePath, 2 "+ CRLF
	xQry += "EXEC sp_OAMethod @pctStr, 'Close' "+ CRLF
	xQry += "EXEC sp_OADestroy @pctStr "+ CRLF
	
	TcSqlExec(xQry)
EndiF
cArqPdf  := ZZS->ZZS_CHAVE + ".pdf"
cDirLocal := "\danfes\" //  "C:\Sistema\Totvs12\protheus_data\danfes\"
xx :="1"
 // __CopyFile(cDirLocal+cArqPdf,cDirDanf+cArqPdf)
CpyS2T(cDirLocal+cArqPdf, cDirDanf)

Ferase(cDirLocal+cArqPdf)

U_yAbreArq(cDirDanf, cArqPdf)

Return


User Function yAbreArq(cDirP, cNomeArqP)
    Local aArea:= GetArea()
     
    //Tentando abrir o objeto
    nRet := ShellExecute("open", cNomeArqP, "", cDirP, 1)
     
    //Se houver algum erro
    If nRet <= 32
        MsgStop("Não foi possível abrir o arquivo " +cDirP+cNomeArqP+ "!", "Atenção")
    EndIf
     
    RestArea(aArea)
Return

//	  oTOleContainer := TOleContainer():New(01, 01, 260, 184, oDlg, .T., "C:\danfes\" + cArqPdf) 
//	  oTOleContainer:OpenFromFile("C:\danfes\" + cArqPdf,.F.,.F.)
//	  oTOleContainer:DoVerbDefault()

/*
  DEFINE DIALOG oDlg TITLE "DANFE" FROM 180,180 TO 550,700 PIXEL
	  //oTOleContainer := TOleContainer():New(01, 01, 260, 184, oDlg, .T., "C:\danfes\" + ZZS->ZZS_CHAVE+ ".pdf")
	  //oTOleContainer := TOleContainer():DoVerbDefault()
	  
	  oTOleContainer := TOleContainer():New(01, 01, 260, 184, oDlg, .T., "C:\danfes\" + cArqPdf) 
	  oTOleContainer:OpenFromFile("C:\danfes\" + cArqPdf,.F.,.F.)
	  oTOleContainer:DoVerbDefault()
	  
  ACTIVATE DIALOG oDlg CENTERED
*/ 
//RETURN