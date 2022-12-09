#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TK273PT2 º Autor ³ Luiz Alberto       º Data ³ 24/06/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE na Conversao de Prospects para Clientes   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TK273PT2()
Local aArea := GetArea()
Local cCodCli := SA1->A1_COD
Local cLojCli := SA1->A1_LOJA

If SUS->(FieldPos("US_FILREL")) > 0 .And. !Empty(SUS->US_FILREL)	// Se Houver Relação com Outro Cliente (Filial) Então Irá Alterar o Código do Cliente

	cQuery := "SELECT MAX(A1_LOJA) as RESULT "
	cQuery += "FROM "+RetSqlName('SA1')+" WHERE A1_COD = '"+SUS->US_FILREL+"' AND D_E_L_E_T_ = '' "
	TcQuery cQuery NEW ALIAS 'RES'

	cCodCli := SUS->US_FILREL
	cLojCli	:= Soma1(RES->RESULT,2)
	
	RES->(dbCloseArea())
	RestArea(aArea)
	
	While AC8->(dbSetOrder(2), dbSeek(xFilial("AC8")+"SA1"+xFilial("SUS")+(SA1->A1_COD+SA1->A1_LOJA)))
		If Reclock("AC8",.F.)
			AC8->AC8_CODENT := cCodCli+cLojCli
			MsUnlock()
			DbCommit()               
		Endif
	EndDo

	While AC9->(dbSetOrder(2), dbSeek(xFilial("AC9")+"SA1"+xFilial("SUS")+(SA1->A1_COD+SA1->A1_LOJA)))
		If Reclock("AC9",.F.)
			AC9->AC9_CODENT := cCodCli+cLojCli
			MsUnlock()
			DbCommit()               
		Endif
	EndDo
	
	//?????????????????
		//?tualiza o STATUS do prospect  ?
		//?????????????????
	DbSelectArea("SUS")
	If Reclock( "SUS" ,.F.)
		SUS->US_CODCLI := cCodCli
		SUS->US_LOJACLI := cLojCli
		SUS->(MsUnlock())
	Endif

	// Atualização de Campos extras do Cadastro do Cliente Gerado
	
	If RecLock("SA1",.f.)                         
		SA1->A1_COD	   := cCodCli
		SA1->A1_LOJA   := cLojCli
		SA1->A1_PESSOA := SUS->US_PESSOA
		SA1->A1_CONTRIB:= SUS->US_CONTRIB
		SA1->(MsUnlock())
	Endif
Endif

If Type("UA_NUM") <> "U"
	If RecLock("SA1",.f.)                         
		SA1->A1_ESTADO 	:= Tabela('12',SA1->A1_EST)
		SA1->A1_PESSOA 	:= Iif(Len(AllTrim(SA1->A1_CGC))<14,'F','J')
		SA1->A1_RISCO	:= 'E'	// RISCO E PARA TODOS OS PROSPECTS CONVERTIDOS EM CLIENTES, INDEPENDENTE DO GRUPO DE EMPRESA.
		
		// Se o Orçamento Já foi gravado e esta posicionado com o mesmo que esta em memória
		// então atualiza os principais campos no cadastro do novo cliente
		
		If M->UA_NUM == SUA->UA_NUM
			SA1->A1_NREDUZ	:= SA1->A1_NOME
			SA1->A1_TPFRET	:= SUA->UA_TPFRETE
			SA1->A1_VEND	:= SUA->UA_VEND
			SA1->A1_TRANSP	:= SUA->UA_TRANSP
			SA1->A1_COND	:= SUA->UA_CONDPG
			SA1->A1_ENDCOB	:= SUA->UA_ENDCOB
			SA1->A1_BAIRROC := SUA->UA_BAIRROC
			SA1->A1_ESTC	:= SUA->UA_ESTC
			SA1->A1_CEPC	:= SUA->UA_CEPC
			SA1->A1_MUNC	:= SUA->UA_MUNC
			SA1->A1_ENDENT	:= SUA->UA_ENDENT
			SA1->A1_BAIRROE	:= SUA->UA_BAIRROE
			SA1->A1_ESTE	:= SUA->UA_ESTE
			SA1->A1_CEPE	:= SUA->UA_CEPE
			SA1->A1_MUNE	:= SUA->UA_MUNE
			SA1->A1_OBSERV 	:= SUA->UA_OBSCLI 
		Endif
		SA1->(MsUnlock())
	Endif
	
	// Efetua a Replica do Cadastro do Novo Cliente para as Demais Empreas
		
	aArea := GetArea()
	U_ReplCliente()   
	RestArea(aArea)


	// Atualiza o Cliente Entrega para o Novo codigo do Cliente Gerado 
	M->UA_CLIENTE := SA1->A1_COD
	M->UA_LOJA    := SA1->A1_LOJA
	M->UA_XCLIENT := SA1->A1_COD
	M->UA_XLOJAEN := SA1->A1_LOJA
		
	If SUB->(dbSetOrder(1), dbSeek(xFilial("SUB")+SUA->UA_NUM)) .And. M->UA_CLIPROS == '2'	// Orçamento Era de Prospect
		While SUB->(!Eof()) .And. SUB->UB_FILIAL == xFilial("SUB") .And. SUB->UB_NUM == SUA->UA_NUM
		
			// Atualiza o Cadastro de Personalizacao de Lacres Prospect com o Novo Codigo do Cliente Gerado
		
			If Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+SUB->UB_XLACRE))
				If Empty(Z00->Z00_CLI)
					If RecLock("Z00",.f.)
						Z00->Z00_CLI	:= SA1->A1_COD
						Z00->Z00_LOJA	:= SA1->A1_LOJA
						Z00->(MsUnlock())
					Endif
				Endif
			Endif
	
			// Atualiza o Cadastro de Personalizacao de Lacres x Prospect com o Novo Codigo do Cliente Gerado
			
			If Z02->(dbSetOrder(4), dbSeek(xFilial("Z02")+SUB->UB_XLACRE+SUS->US_COD+SUS->US_LOJA)) .And. Empty(Z02->Z02_CODCLI)
				If RecLock("Z02",.f.)
					Z02->Z02_CODCLI	:= SA1->A1_COD
					Z02->Z02_LOJACL	:= SA1->A1_LOJA
					Z02->(MsUnlock())
				Endif
			Endif
			
			SUB->(dbSkip(1))
		Enddo
	Endif
	M->UA_CLIPROS := '1'    
	
	// Verifica se existem Orçamentos em Aberto com o Cliente ainda com Status de Prospect e Converte todos para o Novo
	// Codigo de Cliente.

	c_UPDQry  := "  UPDATE "+RETSQLNAME("SUA")"
	c_UPDQry  += "  SET UA_CLIENTE  = '"+SA1->A1_COD+"', "
	c_UPDQry  += "      UA_LOJA     = '"+SA1->A1_LOJA+"', "
	c_UPDQry  += "      UA_XCLIENT  = '"+SA1->A1_COD+"', "
	c_UPDQry  += "      UA_XLOJAEN  = '"+SA1->A1_LOJA+"', "
	c_UPDQry  += "      UA_CLIPROS  = '1', "
	c_UPDQry  += "      UA_PROSPEC  = 'F' "
	c_UPDQry  += "	WHERE UA_CLIPROS = '2' "                                                         
	c_UPDQry  += "  AND UA_CLIENTE = '"+SUS->US_COD+"'"
	c_UPDQry  += "  AND UA_LOJA = '"+SUS->US_LOJA+"'"
	c_UPDQry  += "  AND D_E_L_E_T_='' "
	
	TcSqlExec(c_UPDQry)
	
	MsgInfo("Orçamentos Antigos do Prospect Convertidos em Cliente")
Else
	// Efetua a Replica do Cadastro do Novo Cliente para as Demais Empreas

	aArea := GetArea()
	U_ReplCliente()   
	RestArea(aArea)
Endif
Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReplCliente()  º Autor ³ Luiz Alberto    º Data ³ 10/06/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Replica Clientes Novos para Outras Empresas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ReplCliente()
Local aArea := GetArea()

// Joga todos os dados da Empresa atual nas demais empresas

aDados := {}
For nI := 1 To SA1->(FCount())
	AAdd(aDados, {SA1->(FieldName(nI)),SA1->(FieldGet(nI))} )
Next

cCodigo := SA1->A1_COD
cLoja	:= SA1->A1_LOJA

If cEmpAnt == '01'
	cModo := 'C'
	EmpOpenFile("SA102","SA1",1,.T.,'02',@cModo)
	EmpOpenFile("SA104","SA1",1,.T.,'04',@cModo)

	If SA102->(dbSetOrder(1), dbSeek(xFilial("SA102")+cCodigo+cLoja))
		SA102->(dbGoBottom())
		
		cCodigo := Soma1(SA102->A1_COD,6)
	Endif

	If !SA102->(dbSetOrder(1), dbSeek(xFilial("SA102")+cCodigo+cLoja))
		If RecLock("SA102",.t.)
			For nI := 1 To Len(aDados)
	    		If aDados[nI,1]=='A1_FILIAL'
	    			SA102->A1_FILIAL := xFilial("SA102")
	    		ElseIf aDados[nI,1]=='A1_COD'
	    			SA102->A1_COD := cCodigo
	    		ElseIf aDados[nI,1]=='A1_LOJA'
	    			SA102->A1_LOJA := cLoja
	    		Else
					nPos := SA102->(FieldPos(aDados[nI,1]))
					SA102->(FieldPut(nPos,aDados[nI,2]))
				Endif
			Next
			SA102->(MsUnlock())
		Endif
    Endif

	If SA104->(dbSetOrder(1), dbSeek(xFilial("SA104")+cCodigo+cLoja))
		SA104->(dbGoBottom())
		
		cCodigo := Soma1(SA104->A1_COD,6)
	Endif

	If !SA104->(dbSetOrder(1), dbSeek(xFilial("SA104")+cCodigo+cLoja))
		If RecLock("SA104",.t.)
			For nI := 1 To Len(aDados)
	    		If aDados[nI,1]=='A1_FILIAL'
	    			SA104->A1_FILIAL := xFilial("SA104")
	    		ElseIf aDados[nI,1]=='A1_COD'
	    			SA104->A1_COD := cCodigo
	    		ElseIf aDados[nI,1]=='A1_LOJA'
	    			SA104->A1_LOJA := cLoja
	    		Else
					nPos := SA104->(FieldPos(aDados[nI,1]))
					SA104->(FieldPut(nPos,aDados[nI,2]))
				Endif
			Next
			SA104->(MsUnlock())
		Endif
	Endif
	SA102->(dbCloseArea())
	SA104->(dbCloseArea())
Endif
RestArea(aArea)
Return .t.