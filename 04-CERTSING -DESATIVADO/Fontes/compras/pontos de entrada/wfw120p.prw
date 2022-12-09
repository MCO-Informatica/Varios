#include "protheus.ch" 
#include "ap5mail.ch"

STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )

/*
Ponto de entrada acionado ao Salvar Pedido de compras.
A Rotina é reapconsroveitada para chamda de tratamento de Retorno e Time Wait 
de processamento WF
*/
User Function WFW120P(__nOpWF,oProcess,cPedido)
Local cCodPC := cPedido
Local aArea	:= ''
Local cEnableWF := ''
Default __nOpWF   := 0

If .NOT. lNewCP610
	aArea	:= GetArea()
	cEnableWF := GetNewPar("MV_XWFCENB", "1")
	
	If ValType(__nOpWF) = "A" 
		__nOpWF := __nOpWF[1]
	Endif  
	
	If Type("ParamIxb") == "C" .and. __nOpWF = 0 
		cCodPC := ParamIxb	
	EndIf
	                                         
	// Inicia Processo de WF
	If !Empty(cCodPC)
		If cEnableWF = "1"
			Begin Sequence
				Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] I - Envio de email ")
				WF120Env(cCodPC)
				Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] F - Envio de email ")
			End Sequence
		Else
			Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] I - Envio de email desativado através do parâmetro MV_XWFCENB")
		EndIf 
	
	// Processa Retorno de WF
	ElseIf __nOpWF = 1
		Begin Sequence
			Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] I - Processa Retorno ")
			WF120Ret(oProcess)
			Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] F - Processa Retorno ")
		End Sequence
	
	// Verifica Time Wait
	ElseIf __nOpWF = 2   
		Begin Sequence
			Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] I - Processa TimeWait ")
			WF120Tim(oProcess)                                                  
			Conout("[WF]["+DtoC(dDatabase)+"]["+Time()+"] F - Processa TimeWait ")
		End Sequence
	
	EndIf  
	RestArea(aArea)
Endif
Return

/*
Rotina para geração do processo de envio de WF
*/
Static Function WF120Env(cCodPC)
Local oWFenv	:= nil
Local oHTML		:= nil
Local aCond		:= {}
Local nTotal 	:= 0
Local cAprov	:= ""
Local aAprov	:= {}
Local aGrpAprov:= {}
Local cCond		:= ""
Local cNum		:= ""
Local nTotal	:= 0
Local nFrete	:= 0
Local _cUser	:= StrTran(StrTran(Alltrim(UsrRetName(SC7->C7_USER)),".",""),"\","")
Local cMailId	:= ""
Local cModWF1	:= GetNewPar("MV_XMODWF1", "\WORKFLOW\EVENTO\WFW120P1.HTM") 
Local nDiasTW	:= GetNewPar("MV_XTIWWFD", 5) 
Local nHoraTW	:= GetNewPar("MV_XTIWWFH", 0)
Local nMinuTW	:= GetNewPar("MV_XTIWWFM", 0)
Local aCBoxRe	:= RetSX3Box(Posicione("SX3",2,"C7_XRECORR","X3CBox()"),,,1)	
Local aCBoxCt	:= RetSX3Box(Posicione("SX3",2,"C7_XCONTRA","X3CBox()"),,,1)

// Identifica os emails dos aprovadores
aAprov			:= WF120Apv(SC7->C7_NUM)
cAprov			:= aAprov[2][1][2]
aGrpAprov		:= aAprov[2][1][4]

If !Empty(cAprov)
	// cria processo de workflow
	Sleep(Randomize( 1 , 3000 ))
	//oWFenv := TWFProcess():New( "PEDCOM", "Pedido de Compras", "C"+Alltrim( StrZero( Randomize( 1 , 100 ), 3 ) )+Alltrim( StrTran( StrZero( Seconds(), 9, 3 ), '.', '' ) )+DtoS( Date() ) )
	oWFenv := TWFProcess():New( "PEDCOM", "Pedido de Compras")
	oWFenv:NewTask( "PEDCOM", cModWF1 )
	oWFenv:cSubject := "Solicitação de Liberação para Pedido de Compra"
	oWFenv:bReturn := "U_WFW120P(1)"
	oWFenv:bTimeOut := {{"U_WFW120P(2)", nDiasTW ,nHoraTW ,nMinuTW }}
	
	// Carrega modelo HTML
	oHTML := oWFenv:oHTML
	
	// Preenche os dados do cabecalho	
	oHtml:ValByName( "EMISSAO"	 , SC7->C7_EMISSAO 	)
	oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE 	)
	oHtml:ValByName( "APROV"	 , aAprov[2][1][3] 	)
	
	dbSelectArea('SA2')
	dbSetOrder(1)
	dbSeek(xFilial('SA2')+SC7->C7_FORNECE)
	oHtml:ValByName( "lb_nome", SA2->A2_NREDUZ )
	
	oWFenv:cTo	:= _cUser
		
	// Busca descrição da Forma de Pagamento
	dbSelectArea('SE4')
	DBSETORDER(1)
	dbSeek(xFilial('SE4') + SC7->C7_COND)
	cCond := SE4->E4_DESCRI
	oHtml:ValByName( "lb_cond", CCOND )
	
	//Mosta dados para listar os produtos	
	dbSelectArea('SC7')
	oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
	cNum := SC7->C7_NUM
	oWFenv:fDesc := "Pedido de Compras No "+ cNum
	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial('SC7')+cNum))
	
	oHtml:ValByName( "ccusto", 	Alltrim(SC7->C7_CC)+"-"+Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01") )
	oHtml:ValByName( "itemctb", Alltrim(SC7->C7_ITEMCTA)+"-"+Posicione("CTD",1,xFilial("CTD")+SC7->C7_ITEMCTA,"CTD_DESC01") )
	oHtml:ValByName( "recorr",	Iif(SC7->C7_XRECORR=="0","0=Nenhuma",aCBoxRe[Ascan(aCBoxRe,{|x| x[2] == SC7->C7_XRECORR }),1]) )
	oHtml:ValByName( "referen", SC7->C7_XREFERE )
	oHtml:ValByName( "clasval", Alltrim(SC7->C7_CLVL)+"-"+Posicione("CTH",1,xFilial("CTH")+SC7->C7_CLVL,"CTH_DESC01") )
	oHtml:ValByName( "justific",StrTran(SC7->C7_XJUST,CRLF,"<br>") )
	oHtml:ValByName( "objetivo",StrTran(SC7->C7_XOBJ,CRLF,"<br>") )
	oHtml:ValByName( "contrato",Iif(SC7->C7_XCONTRA=="0","0=Sem Contrato",aCBoxCt[Ascan(aCBoxCt,{|x| x[2] == SC7->C7_XCONTRA }),1]) ) 
	oHtml:ValByName( "infadic",	StrTran(SC7->C7_XADICON,CRLF,"<br>") )
	oHtml:ValByName( "vencto",	DtoC(SC7->C7_XVENCTO) )
		
	While SC7->(!Eof()) .and. SC7->C7_NUM = cNum
		nTotal += SC7->C7_TOTAL
		nFrete += SC7->C7_FRETE
		 
		AAdd( (oHtml:ValByName( "it.item" )),C7_ITEM )
		AAdd( (oHtml:ValByName( "it.codigo" )),C7_PRODUTO )
		
		dbSelectArea('SB1')
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1')+SC7->C7_PRODUTO))
		
		AAdd( (oHtml:ValByName( "it.descricao" )),SB1->B1_DESC )
		AAdd( (oHtml:ValByName( "it.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 999,999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.total" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.unid" )),SB1->B1_UM )
		
		RecLock('SC7')
		SC7->C7_FILENT := SC7->C7_FILIAL
		SC7->(MsUnlock())
		
		SC7->(dbSkip())
	Enddo
	
	// Grava as informações do Rodapé	
	oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
	oHtml:ValByName( "lbFrete" ,TRANSFORM( nFrete,'@E 999,999,999.99' ) )
	oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
	
	oWFenv:ClientName( Subs(cUsuario,7,15) )
	
	oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')
	
	// Envia o email
	cMailId := oWFenv:Start()
	
	WF120Lin(_cUser,cAprov,@oWFenv,cNum,cMailId)
	
	oWFenv:Free()
EndIf

Return
	
/*
Rotina de processamento de retorno para WF
*/
Static Function WF120Ret(oWFret)
Local cStatus		:= "01" // Status de autorizacao parcial do Pedido
Local lLast			:= .T.
Local cAprovador  	:= ""
Local cNumPC		:= Alltrim(oWFret:oHtml:RetByName('PEDIDO'))
Local cStatApv		:= oWFret:oHtml:RetByName("APROVACAO")
Local lLiber		:= .f.
Local cMotivo		:= oWFret:oHtml:RetByName("LBMOTIVO")
Local cAprov		:= ""
Local aAprov		:= {}
Local aGrpAprov		:= {}
Local nRecC7		:= 0
Local cMsg			:= ""
Local cAssunt		:= ""
Local cEmailC7		:= ""
Local aRetSaldo		:= {}
Local nSalDif		:= 0
Local nTotal		:= 0
Local cProxNiv		:= ""

ConOut("Entrou no processo de retorno do WorkFlow")

SC7->(DbSetOrder(1))
If SC7->(DbSeek(xFilial("SC7")+cNumPC)) 
ConOut("Efetuei o posicionamento no Pedido de Compra")

cAprov	:= Padr(oWFret:oHtml:RetByName("Aprov"),6)
ConOut("Recebe o aprovador: " + cAprov)
	
	nRecC7 := SC7->(Recno())
	
	cMsg := "Solicitante, "+CRLF+CRLF
	cMsg += "A análise do Pedido de Compras código "+SC7->C7_NUM 
		
	If cStatApv = "S" 
		
		SCR->(dbsetorder(2))
		ConOut("Tenta se Posicionar na SCR: "+xFilial("SCR")+"PC"+PadR(cNumPC,50," ")+cAprov)
		If SCR->(dbseek(xFilial("SCR")+"PC"+PadR(cNumPC,50," ")+cAprov))
			//Alteração para validação de alçada - Renato Ruy - 16/07
			//lLiber := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,"WF-"+cMotivo},ddatabase,4) 
			aRetSaldo 	:= MaSalAlc(SCR->CR_APROV,dDataBase)// Funcao do protheus
			nTotal   	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA) // Funcao do protheus
			nSalDif 	:= aRetSaldo[1] - nTotal			 
			lLiber := nSalDif > 0
			//Fim da alteração para controle da alçada.
			If lLiber
				MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,"WF-"+cMotivo},ddatabase,4)
				ConOut("Usuário Tem Saldo! Usuário/Nivel" + SCR->CR_APROV + "/" + SCR->CR_NIVEL  )
				SC7->(DbSetOrder(1))
				SC7->(DbSeek(xFilial("SC7")+cNumPC))
				
				while !SC7->(EOF()) .and. SC7->C7_NUM == cNumPC
					SC7->(RecLock("SC7",.F.))
					SC7->C7_CONAPRO := "L"
					SC7->(MsUnLock())
					SC7->(DBSkip())
				enddo
				
				//Marca como aprovado na alçada.
				SCR->(RecLock("SCR",.F.))
					SCR->CR_STATUS := "03"
				SCR->(MsUnLock())
				
				cAssunt	:=  "Pedido de Compras "+SC7->C7_NUM+" APROVADO" 
				cMsg 	+= " APROVOU a compra"			
			Else
				cProxNiv := Soma1(SCR->CR_NIVEL)
			    //Libera somente o nível atual.
				SCR->(RecLock("SCR",.F.))
					SCR->CR_STATUS 	:= "05"
					SCR->CR_OBS 	:= SubStr(cMotivo,1,Iif(Len(cMotivo)<=30,Len(cMotivo),30))
				SCR->(MsUnLock()) 
				
				//Envio Para o Próximo Nível da Aprovação
				SCR->(DbSetOrder(1))
				If SCR->(dbseek(xFilial("SCR")+"PC"+PadR(cNumPC,50," ")+cProxNiv))
					SCR->(RecLock("SCR",.F.))
						SCR->CR_STATUS := "02"
					SCR->(MsUnLock()) 
				EndIf  
				
		 	ConOut("Usuário Sem Saldo!" + SCR->CR_APROV + "/" + SCR->CR_NIVEL)
			EndIf 
		 Else
		 ConOut("Não Conseguiu se posicionar")
		endif	
	Else
		SCR->(dbsetorder(2))
		If SCR->(dbseek(xFilial("SCR")+"PC"+PadR(cNumPC,50," ")+cAprov))
			//lLiber := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,"WF-"+cMotivo},ddatabase,6)
			lLiber := .T. //Libero bloqueio para qualquer usuário da alçada
			If lLiber
				SC7->(DbSetOrder(1))
				SC7->(DbSeek(xFilial("SC7")+cNumPC))
				
				SCR->(RecLock("SCR",.F.))
					SCR->CR_STATUS 	:= "04"
					SCR->CR_OBS 	:= SubStr(cMotivo,1,Iif(Len(cMotivo)<=30,Len(cMotivo),30))
				SCR->(MsUnLock())
				
				while !SC7->(EOF()) .and. SC7->C7_NUM == cNumPC
					SC7->(RecLock("SC7",.F.))
					SC7->C7_CONAPRO := "B"
					SC7->(MsUnLock())
					SC7->(DBSkip())
				enddo
			EndIf
			cAssunt	:=  "Pedido de Compras "+SC7->C7_NUM+" REPROVADO"
			cMsg 	+= " REPROVOU a compra"
		endif
		
	endif
	
	cMsg += " na data de "+DtoC(dDatabase)+" as "+Time()+"."
	
	If !Empty(cMotivo)
		cMsg += " Com a seguinte observação: "+CRLF+cMotivo+CRLF+CRLF
	EndIf
	
	cMsg += "Qualquer dúvida verifique o pedido de compras no sistema Protheus." 
	
	//Me posiciono novamente para enviar o e-mail para o usuário correto
	SC7->(DbSetOrder(1)) 
	If SC7->(DbSeek(xFilial("SC7")+cNumPC))
		cEmailC7 := Alltrim(USRRETMAIL(SC7->C7_USER))
		ConOut("Mandou e-mail para: " + cEmailC7 )
	EndIf	MandEmail(cMsg, cEmailC7 , cAssunt, nil, nil, nil, nil)
	
EndIf

If !lLiber
	
	SC7->(DbGoTo(nRecC7))
	
	oWFret:Finish()
	oWFret:Free()
	
	aAprov			:= WF120Apv(SC7->C7_NUM)
	cAprov			:= aAprov[1]
	
	If !Empty(cAprov)
		WF120Env(SC7->C7_NUM)
	EndIf
	
EndIf

Return

/*
Rotina de controle de time wait
*/
User Function WF120Tim(oWFtim)
Local cNumPC	:= Alltrim(oWFtim:oHtml:RetByName('PEDIDO'))
Local lLiber	:= .F.
Local cAprov	:= ""
Local aAprov	:= {}
Local aGrpAprov	:= {}

oWFtim:Finish()
oWFtim:Free()

SC7->(DbSetOrder(1))
If SC7->(DbSeek(xFilial("SC7")+cNumPC))
	SCR->(dbsetorder(2))
	SAK->(DbSetOrder(1))
	
	If SCR->(dbseek(xFilial("SCR")+"PC"+cNumPC))  
		While !SCR->(EOF()) .and. xFilial("SCR")==SCR->CR_FILIAL .and. SCR->CR_TIPO == "PC" .and. Alltrim(SCR->CR_NUM) == cNumPC
			If SCR->CR_STATUS == "02" .and. SAK->(dbseek(xFilial("SAK")+SCR->CR_APROV)) .and. !Empty(SAK->AK_APROSUP)
				lLiber := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SAK->AK_APROSUP,,,,,,,"WF-Alter. aprov. timewait"},ddatabase,2)
			EndIf
			SCR->(dbskip())
		enddo
	EndIf
	If lLiber
		WF120Env(SC7->C7_NUM)
	EndIf
EndIf

Return(.T.)

/*
Rotina de processamento de envio de email do link
*/
Static Function WF120Lin(_cUser,cAprov,oWFlin,cNum,cMailId)
Local oHTML
Local cLink	:= GetNewPar("MV_XLINKWF", "http://192.168.16.10:1804/wf/")
Local cModWF2	:= GetNewPar("MV_XMODWF2", "\WORKFLOW\EVENTO\WFW120P2.HTM")
Local aCBoxRe	:= RetSX3Box(Posicione("SX3",2,"C7_XRECORR","X3CBox()"),,,1)	
Local aCBoxCt	:= RetSX3Box(Posicione("SX3",2,"C7_XCONTRA","X3CBox()"),,,1)
Local nTotal	:= 0

cLink += "emp"+ cEmpAnt +"/" 

oWFlin:NewTask( "LKPEDC", cModWF2 )
oWFlin:cSubject := "Solicitação de Liberação para Pedido de Compra "+cNum
oWFlin:cTo := cAprov

// Cria objeto Html de acordo modelo
oHTML := oWFlin:oHTML

// Preenche os dados do cabecalho	
oHtml:ValByName( "pedido", cNum )
oHtml:ValByName( "usuario", Alltrim(UsrFullName(__CUSERID)) )
oHtml:ValByName( "data", DtoC(dDatabase) )
oHtml:ValByName( "proc_link", cLink+_cUser+"/"+cMailId+".htm" )
oHtml:ValByName( "titulo", cMailId )

SC7->(DbSetOrder(1))
If SC7->(DbSeek(xFilial("SC7")+cNum))
	oHtml:ValByName( "ccusto", 	Alltrim(SC7->C7_CC)+"-"+Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01") )
	oHtml:ValByName( "itemctb", Alltrim(SC7->C7_ITEMCTA)+"-"+Posicione("CTD",1,xFilial("CTD")+SC7->C7_ITEMCTA,"CTD_DESC01") )
	oHtml:ValByName( "recorr",	Iif(SC7->C7_XRECORR=="0","0=Nenhuma",aCBoxRe[Ascan(aCBoxRe,{|x| x[2] == SC7->C7_XRECORR }),1]) )
	oHtml:ValByName( "referen", SC7->C7_XREFERE )
	oHtml:ValByName( "clasval", Alltrim(SC7->C7_CLVL)+"-"+Posicione("CTH",1,xFilial("CTH")+SC7->C7_CLVL,"CTH_DESC01") )
	oHtml:ValByName( "justific",StrTran(SC7->C7_XJUST,CRLF,"<br>") )
	oHtml:ValByName( "objetivo",StrTran(SC7->C7_XOBJ,CRLF,"<br>") )
	oHtml:ValByName( "contrato",Iif(SC7->C7_XCONTRA=="0","0=Sem Contrato",aCBoxCt[Ascan(aCBoxCt,{|x| x[2] == SC7->C7_XCONTRA }),1]) ) 
	oHtml:ValByName( "infadic",	StrTran(SC7->C7_XADICON,CRLF,"<br>") )
	oHtml:ValByName( "vencto",	DtoC(SC7->C7_XVENCTO) )
	
	While SC7->(!Eof()) .and. SC7->C7_NUM = cNum
		nTotal += SC7->C7_TOTAL
		AAdd( (oHtml:ValByName( "it.codigo" )),SC7->C7_PRODUTO )
		
		dbSelectArea('SB1')
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1')+SC7->C7_PRODUTO))
		
		AAdd( (oHtml:ValByName( "it.descricao" )),SB1->B1_DESC )
		AAdd( (oHtml:ValByName( "it.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.total" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999.99' ) )
				
		SC7->(dbSkip())
	Enddo
	//oHtml:ValByName( "total",TRANSFORM( nTotal,'@E 999,999,999.99' ))
	
Else
	oHtml:ValByName( "ccusto", "" )
	oHtml:ValByName( "itemctb", "" )
	oHtml:ValByName( "recorr", "" )
	oHtml:ValByName( "referen", "" )
	oHtml:ValByName( "clasval", "" )
	oHtml:ValByName( "justific", "" )
	oHtml:ValByName( "objetivo", "" )
	oHtml:ValByName( "contrato", "" )
	oHtml:ValByName( "infadic", "" )
	oHtml:ValByName( "vencto", "" )
EndIf

oWFlin:Start()

oWFlin:Free()

Return

/*                                                                 
Rotina de controle de email de aprovadores
*/
Static Function WF120Apv(cNumPedC)
Local cEmail		:= ""
Local cEmailGrp		:= ""
Local cGrupoAprv  	:= ""
Local aAprov		:= {}

ConOut("Entra no processo para buscar aprovador")

SCR->(DbSetOrder(1))
If SCR->(DbSeek(xFilial("SCR")+"PC"+PadR(cNumPedC,50," ")))
	While !SCR->(EOF()) .and. xFilial("SCR")==SCR->CR_FILIAL .and. SCR->CR_TIPO == "PC" .and. Alltrim(SCR->CR_NUM) == cNumPedC
		If SCR->CR_STATUS == "02"
			cEmail	:= Alltrim(USRRETMAIL(SCR->CR_USER))+";"
			cEmailGrp+= cEmail
			
			ConOut("Encontrei o aprovador " + SCR->CR_USER)
			
			If Select("TMP1")>0
				TMP1->(DbCloseArea())
			EndIf
			BeginSql Alias "TMP1"
				SELECT AL_NOME,AL_APROV,AL_USER FROM %Table:SAL% SAL
				WHERE
				AL_FILIAL = ' ' AND
				AL_USER = %Exp:SCR->CR_USER% AND
				AL_COD = %Exp:SC7->C7_APROV% AND
				SAL.%NotDel%
			EndSql
			
			aadd(aAprov,{Alltrim(TMP1->AL_NOME),Alltrim(USRRETMAIL(SCR->CR_USER)),SCR->CR_USER,SC7->C7_APROV})
		EndIf
		DbSelectArea("SCR")
		DbSkip()
	enddo
endif

cEmail:=substr(cEmail,1,len(cEmail)-1) //retirar o último ;

If Len( aAprov ) == 0
	AAdd( aAprov, { "","","","" } )
Endif

Return({cEmail,aAprov})

/*
Rotina para envio de email de notificação de status da liberação do pedido de compras 
*/
Static Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," ")) 
Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuário para Autenticação no Servidor de Email
Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autenticação no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexão
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
Local   lRet      := .T. 

Default xDest     := ""
Default xCC		  := ""
Default xBCC      := ""
Default xCorpo	  := ""
Default xAnexo    := ""
Default xAssunto  := "<< Mensagem sem assunto >>"  

If Empty(xDest+xCC+xBCC)
	Return(lRet)
EndIf

_cMsg := "Conectando a " + cServer + CRLF +;
"Conta: " + cAccount + CRLF +;
"Senha: " + cPassword

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

If ( lOk )

    // Realiza autenticacao caso o servidor seja autenticado.
	If lAutentica
		If !MailAuth(cUserAut,cPassAut)
			DISCONNECT SMTP SERVER RESULT lOk
			IF !lOk
				GET MAIL ERROR cErrorMsg
			ENDIF
			Return .F.
		EndIf
	EndIf

	SEND MAIL FROM cAccount TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk

	If !lOk
		GET MAIL ERROR cErro
		cErro := "Erro durante o envio - destinatário: " + xDest + CRLF + CRLF + cErro
		lRet:= .F.
	Endif
	
	DISCONNECT SMTP SERVER RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
	Endif
Else
	GET MAIL ERROR cErro
	lRet:= .F.
EndIf

Return(lRet)