#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ JobCiclos   บAutor  ณ Luiz Alberto   บ Data ณ  Nov/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Job Responsแvel pelo calculo de Datas de Ciclos de Clientes
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JobCiclo(cCliente,cLoja)
Local aArea := GetArea()
Local aEmpresa := {{'01','01'}}

DEFAULT cCliente := Space(06)
DEFAULT cLoja := Space(02)

ConOut(OemToAnsi("Inํcio Calculo de Ciclos Clientes " + Dtoc(date()) +" - " + Time()))
	
If !Select("SX2")<>0 
	For nI := 1 To Len(aEmpresa)
		RpcSetType( 3 )
		RpcSetEnv( aEmpresa[nI,1], aEmpresa[nI,2] )
	
		Processa( {|| RunProc('','') } )			
	
		RpcClearEnv()
	Next                               
Else
	Processa( {|| RunProc(cCliente,cLoja) } )			
Endif
RestArea(aArea)
Return .t.

Static Function RunProc(cCliente,cLoja)
Local aArea := GetArea()

Default cCliente := ''
Default cLoja := ''

If Dow(Date()) = 1 .Or. Dow(Date()) = 7                                                                                          
/*	If Empty(cCliente)
		ConOut(OemToAnsi("O Ciclo so e executado em dias uteis entre as 04:00 e 04:30 da manha ! - " + Dtoc(date()) +" - " + Time()))
	Endif
	Reset Environment */
	Return .t.
Endif
  
nQtdVendas	:= GetNewPar("MV_CLQTVEN",6)	// Quantidade de Vendas a COnsiderar Padrใo 6
nTiraLido	:= GetNewPar("MV_CLTLIDO",10)	// Prazo para Retirada do Flag Lidos do Clientes
cCfopVal	:= GetNewPar("MV_CLCFOP","5102/6102/7102")	// CFOPดss Validos para o Processo

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()
ProcRegua(0)                          

//cCliente := '000962'
//cLoja := '17'

cTexto := ''
SA1->(dbGoTop())

If !Empty(cCliente)                             
	SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))
Endif

While SA1->(!Eof())  
	IncProc('Processando Ciclo Cliente ' + SA1->A1_COD)
	
	If SA1->A1_MSBLQL == '1' .Or. SA1->A1_PESSOA <> 'J' // Cliente Inativo Nao Processa Ciclo
		SA1->(dbSkip(1));Loop
	Endif        
	
	cQuery := 	 " SELECT DISTINCT TOP " + AllTrim(Str(nQtdVendas)) + " C5_EMISSAO C5_EMISSAO, C5_CLIENTE, C5_LOJACLI " 
	cQuery +=	 " FROM " + RetSqlName("SC5") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SF4") + " SF4 "
	cQuery +=	 " WHERE SC5.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SC6.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SF4.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
	cQuery +=	 " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' "
	cQuery +=	 " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
	cQuery +=	 " AND SC5.C5_CLIENTE = '" + SA1->A1_COD + "' "
	cQuery +=	 " AND SC5.C5_LOJACLI = '" + SA1->A1_LOJA + "' "
	cQuery +=	 " AND SC5.C5_TIPO = 'N' "
	cQuery +=	 " AND SC6.C6_NUM = SC5.C5_NUM "
	cQuery +=	 " AND SF4.F4_CODIGO = SC6.C6_TES "
	cQuery +=	 " AND SF4.F4_DUPLIC = 'S' "
	cQuery +=	 " AND SC6.C6_PRODUTO NOT LIKE '%SEALB%' "
	cQuery +=	 " GROUP BY C5_EMISSAO, C5_CLIENTE, C5_LOJACLI "
	cQuery +=	 " ORDER BY C5_EMISSAO DESC "
	
	TCQUERY cQuery NEW ALIAS "CHK1"
	
	Count To nReg

	CHK1->(dbGoTop())
	aDataCiclo := {}
	While CHK1->(!Eof())                 
		dEmissao	:=	StoD(CHK1->C5_EMISSAO)
		AAdd(aDataCiclo,dEmissao)
		
		CHK1->(dbSkip(1))
	Enddo
	
	If Len(aDataCiclo) > 1 
		nDias := 0
		dData	:= aDataCiclo[1]
		For nCiclo := 2 To Len(aDataCiclo)
			nDias += dData-aDataCiclo[nCiclo]
			dData := aDataCiclo[nCiclo]
		Next
		dData	:= aDataCiclo[1]		
		nCiclo 	:= Int((nDias/(Len(aDataCiclo)-1)))
		
		
		nCiclo  := Iif(nCiclo>365,365,nCiclo)		// Ciclo nใo poderแ ter mais que 1 ano


	Else
		dData	:= dDataBase
		nCiclo	:= 0
	Endif     

	dData	:=	DataValida(dData,.T.)
		
	CHK1->(dbCloseArea())

	ConOut('Processando Ciclo de ' + SA1->A1_COD + '/' + SA1->A1_LOJA + ' - ' + SA1->A1_NOME + ' Media Dias: ' + Str(nCiclo) + ' - Proximo: ' + DtoC(dData+nCiclo))
	
	cTexto += "<br>"+'Processando Ciclo de ' + SA1->A1_COD + '/' + SA1->A1_LOJA + ' - ' + SA1->A1_NOME + ' Media Dias: ' + Str(nCiclo) + ' - Proximo: ' + DtoC(dData+nCiclo)

	lGrava	:= !Empty(nReg)

	cQuery := 	 " SELECT TOP 1 R_E_C_N_O_ REG  "
	cQuery +=	 " FROM " + RetSqlName("SZ4") + " Z4 (NOLOCK) "
	cQuery +=	 " WHERE  "
	cQuery +=	 " Z4_FILIAL = '" + xFilial("SZ4") + "' "
	cQuery +=	 " AND Z4.D_E_L_E_T_ = '' "      
	cQuery +=	 " AND Z4.Z4_CLIENTE = '" + SA1->A1_COD + "' "
	cQuery +=	 " AND Z4.Z4_LOJA = '" + SA1->A1_LOJA+ "' "
	cQuery +=	 " AND Z4.Z4_ATIVO = 'S' "
	cQuery +=	 " ORDER BY R_E_C_N_O_ DESC "      
		
	TCQUERY cQuery NEW ALIAS "CHK2"
	
	If !Empty(CHK2->REG)
		SZ4->(dbGoTo(CHK2->REG))
		
		If RecLock("SZ4", .F.)
			SZ4->Z4_TVLFAT	:=	fFaturado(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,1)
			SZ4->Z4_UVLFAT	:=	fFaturado(SZ4->Z4_CLIENTE,SZ4->Z4_LOJA,2)
			SZ4->(MsUnlock())
		Endif
		
		lGrava := .f.
	Endif
	CHK2->(dbCloseArea())
	
	If lGrava
		If RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL	:= xFilial("SZ4")
			SZ4->Z4_CLIENTE	:= SA1->A1_COD
			SZ4->Z4_LOJA	:= SA1->A1_LOJA
			SZ4->Z4_NOME	:= SA1->A1_NOME
			SZ4->Z4_ATIVO	:=  'S'
			SZ4->Z4_CICLO	:=	dData+nCiclo
			SZ4->Z4_VENCICL	:=	(dData+nCiclo)-10
			SZ4->Z4_VEND	:=	SA1->A1_VEND
			SZ4->Z4_MCICLO	:=	nCiclo               
			If !Empty(Len(aDataCiclo))
				SZ4->Z4_ZULTFAT := aDataCiclo[1]
				SZ4->Z4_ZNDIAS	:= (dDataBase-aDataCiclo[1])
			Endif
			SZ4->(MsUnlock())
		Endif                                       
	ElseIf !lGrava .And. nCiclo > 0 .And. dData+nCiclo>SZ4->Z4_DCLANT .And. nReg > 0
		If RecLock("SZ4",.f.)
			SZ4->Z4_CICLO	:=	dData+nCiclo
			SZ4->Z4_VENCICL	:=	(dData+nCiclo)-10
			SZ4->Z4_MCICLO	:=	nCiclo               
			If !Empty(Len(aDataCiclo))
				SZ4->Z4_ZULTFAT := aDataCiclo[1]
				SZ4->Z4_ZNDIAS	:= (dDataBase-aDataCiclo[1])
			Endif                                                    
			SZ4->Z4_CODMOT	:=	''
			SZ4->Z4_DCLANT	:=	CtoD('')
			SZ4->(MsUnlock())
		Endif                                       
	Endif
	SA1->(dbSkip(1))
	
	If !Empty(cCliente) .And. SA1->A1_COD <> cCliente
		Exit
	Endif
Enddo    
                       
If Empty(cCliente)
	cNomRespo := 'Automatico'
	cEmaRespo := 'lalberto@3lsystems.com.br'
	
	LogMailCiclo(cNomRespo,cEmaRespo,'Job Ciclo de Vendas','Ciclo de Vendas Executado com Sucesso em ' + DtoC(Date()) + ' as ' + Time() +"<br>"+"<br>"+ cTexto,.f.)

//	Reset Environment
Endif

RestArea(aArea)
Return .t.




Static Function LogMailCiclo(cNomRespo,cEmaRespo,cAssunto,mCorpo,lContrato)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
DEFAULT lContrato := .f.

	For nTenta := 1 To 5
	
		CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
		
		// Se a conexao com o SMPT esta ok
		If lResult
		
			// Se existe autenticacao para envio valida pela funcao MAILAUTH
			If lRelauth
				lRet := Mailauth(cConta,cSenhaTK)	
			Else
				lRet := .T.	
		    Endif    
			
			If lRet
				SEND MAIL FROM cFrom ;
				TO      	cPara;
				SUBJECT 	cAssunto;
				BODY    	mCorpo;
				RESULT lResult
		
				If !lResult
					//Erro no envio do email
					GET MAIL ERROR cError
						Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Aten็ใo
					Loop
				Endif
		 		nTenta := 10	// Em Caso de Sucesso sai do Loop
		 		Loop
			Else
				GET MAIL ERROR cError
				Help(" ",1,'Autentica็ใo',,cError,4,5)  //"Autenticacao"
				MsgStop('Erro de Autentica็ใo','Verifique a conta e a senha para envio') 		 //"Erro de autentica็ใo","Verifique a conta e a senha para envio"
			Endif
				
			DISCONNECT SMTP SERVER
			
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
		Endif
	Next
Return .t.



Static Function fFaturado(cCodigo,cLoja,nTipo)
Local aArea := GetArea()
Local dDataDe	 	:= FirstDate(MonthSub(dDataBase,12))
Local dDataAte		:= LastDate(dDataBase)

If nTipo == 1	// Ultimos 12 Meses
	cQuery := 	 " SELECT SUM(D2_TOTAL) FATURADO " 
	cQuery +=	 " FROM " + RetSqlName("SF2") + " SF2 (NOLOCK), " + RetSqlName("SD2") + " SD2 (NOLOCK), " + RetSqlName("SF4") + " SF4 (NOLOCK) "
	cQuery +=	 " WHERE SF2.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SD2.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SF4.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery +=	 " AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' "
	cQuery +=	 " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery +=	 " AND SF2.F2_CLIENTE = '" + cCodigo + "' "
	cQuery +=	 " AND SF2.F2_LOJA = '" + cLoja + "' "
	cQuery +=	 " AND SF2.F2_TIPO = 'N' "
	cQuery +=	 " AND SF2.F2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
	cQuery +=	 " AND SF2.F2_DOC = SD2.D2_DOC "
	cQuery +=	 " AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQuery +=	 " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
	cQuery +=	 " AND SF2.F2_LOJA = SD2.D2_LOJA "
	cQuery +=	 " AND SF4.F4_CODIGO = SD2.D2_TES "
	cQuery +=	 " AND SF4.F4_DUPLIC = 'S' "
Else
	cQuery := 	 " SELECT TOP 1 F2_VALBRUT FATURADO " 
	cQuery +=	 " FROM " + RetSqlName("SF2") + " SF2 (NOLOCK) "
	cQuery +=	 " WHERE SF2.D_E_L_E_T_ = '' "
	cQuery +=	 " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery +=	 " AND SF2.F2_CLIENTE = '" + cCodigo + "' "
	cQuery +=	 " AND SF2.F2_LOJA = '" + cLoja + "' "
	cQuery +=	 " AND SF2.F2_TIPO = 'N' "
	cQuery +=	 " AND SF2.F2_DUPL <> '' "
	cQuery +=	 " ORDER BY F2_EMISSAO DESC "
Endif
TCQUERY cQuery NEW ALIAS "CHKF"

nFaturado	:=	CHKF->FATURADO

CHKF->(dbCloseArea())

RestArea(aArea)
Return nFaturado


