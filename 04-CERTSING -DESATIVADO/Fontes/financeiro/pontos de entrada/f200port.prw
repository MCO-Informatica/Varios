#INCLUDE "PROTHEUS.CH"

/*
---------------------------------------------------------------------------
Funcao:	F200PORT
Autor :	Gildesio Campos										Data: 31/05/10
---------------------------------------------------------------------------
Descricao: Ler arquivo de retorno Cnab Bradesco e com base nesse arquivo
gerar um novo com as informacoes necessarias para viabilizar a
baixa dos titulos relativos ao GAR e consequentemente ao Boleto
emitido no Site.
---------------------------------------------------------------------------
*/
User Function F200PORT()

//Processa( { || F200Proc() } ) //passa a ser executado pela rotina GerFTCnab

Return(.T.)


/*
---------------------------------------------------------------------------
Aqui comeca o processamento com barra de progracao para acompanhamdento do
usuario, Assim ele nao acha que travou e tenta derrubar a aplicacao.
---------------------------------------------------------------------------
*/
Static Function F200Proc()

Local cArqEnt	:= Alltrim(Mv_Par04)
Local nLidos	:= 0
Local nTamDet	:= Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES + 2)
Local xReg		:= ""
Local xBuffer	:= ""
Local aTitulos	:= {}
Local _aArea	:= GetArea()
Local nQtdRec	:= 0
Local cNosso	:= ""
Local dDataMovFin	:= GetMv("MV_DATAFIN")
Local dDatabx 		:= GetMv("MV_DATAFIN")+1
/*
------------------------------------------
Abre arquivo enviado pelo banco
------------------------------------------*/
If !File(cArqEnt)
	ApMsgAlert("Arquivo "+cArqEnt+" n�o localizado. O sistema ser� abortado.")
	UserException("Arquivo "+cArqEnt+" n�o localizado. O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
Else
	dbSelectArea("SC5")
	//dbSetOrder(5)
	SC5->(DbOrderNickName("NUMPEDGAR"))//Alterado por LMS em 03-01-2013 para virada
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSelectArea("SF2")  	//F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE
	dbSetOrder(2)
	dbSelectArea("SE1")  	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	dbSetOrder(2)
	/*
	-----------------------------------------
	Renomeio o arquivo informado para leitura
	-----------------------------------------*/
	cArqEntNew := FileNoExt(cArqEnt)+".ORI" //Retorna a string sem a extensao do arquivo
	
	If !File(cArqEntNew)
		nHdlRen := FRENAME(cArqEnt,cArqEntNew)
		If nHdlRen < 0
			ApMsgAlert("Erro ao renomear arquivo "+cArqEnt+" O sistema ser� abortado.")
			UserException("Erro ao renomear arquivo "+cArqEnt+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
	Endif
	
	/*
	---------------------------------------
	Abre arquivo para leitura
	---------------------------------------*/
	nHdlBco:=FOPEN(cArqEntNew)
	
	/*
	---------------------------------------
	Cria novo arquivo com as altera��es
	---------------------------------------*/
	nHdlNew := FCREATE(cArqEnt)
	If nHdlNew < 0
		ApMsgAlert("Erro ao criar arquivo "+cArqEnt+" O sistema ser� abortado.")
		UserException("Erro ao renomear arquivo "+cArqEnt+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
	EndIf
Endif


/*
------------------------------------------
Le arquivo enviado pelo Banco
------------------------------------------*/
FSeek(nHdlBco,0,0)
nTamArq:=FSeek(nHdlBco,0,2)
FSeek(nHdlBco,0,0)

nNumSeq:= 0	//Val(Substr(xBuffer,395,400))		//Pos.395 a 400	 ---> Numero sequencial

ProcRegua( Int(nTamArq/400) )

While .T.
	
	nQtdRec++
	IncProc( "Procesando registro "+Alltrim(Str(nQtdRec)) )
	ProcessMessage()
	
	xBuffer:=Space(nTamDet)
	FREAD(nHdlBco,@xBuffer,nTamDet)
	
	If Empty(xBuffer)		//Fim do arquivo
		Exit
	EndIf
	
	nNumSeq++
	
	/*	-------------------------------------------------------
	Verifica tipo de registro 0-header 1-detalhe 9-trailer
	-------------------------------------------------------*/
	IF SubStr(xBuffer,1,1) $ "0|9"
		cLinDet := Substr(xBuffer,1,394)
		cLinDet += StrZero(nNumSeq,6)
		cLinDet += CRLF
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos+=nTamDet
		Loop
	EndIF
	
	/*	-------------------------------------
	Verifica se eh um pagamento
	-------------------------------------*/
	IF	((MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU' ) .and.  (SubStr(xBuffer,109,2) <> "06" .or. SubStr(xBuffer,83,3) <> "175") ) .or.;
		((MV_PAR06 == '237' .OR. alltrim(MV_PAR08) == 'COBBRAD' ) .and. !SubStr(xBuffer,109,2) $ "06|16" )     //06-Liquida��o//16-BAIXA POR FALTA DE PAGAMEMTO
		
		cLinDet := Substr(xBuffer,1,394)
		cLinDet += StrZero(nNumSeq,6)
		cLinDet += CRLF
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos += nTamDet
		Loop
	EndIF
	
	If !Empty(Substr(xBuffer,38,25))
		
		If (MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU')
			
			
			dDatabx:=ctod(Substr(xBuffer,296,02)+'/'+Substr(xBuffer,298,02)+'/'+Substr(xBuffer,300,02))
			If dtos(dDatabx) <= dtos(dDataMovFin)
				dDatabx:=dDataMovFin+1
			Endif
			
			cLinDet := Substr(xBuffer,1,295)  //Pos.1 a 295
			cLinDet += Substr(dtos(dDatabx),7,2)+Substr(dtos(dDatabx),5,2)+Substr(dtos(dDatabx),3,2)   				//Pos.296 a 301
			cLinDet += Substr(xBuffer,302,93)   				//Pos.302 a 394
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			
		else
			cLinDet := Substr(xBuffer,1,394)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			
		Endif
		
		If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
			ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
			FCLOSE(nHdlNew)
			FCLOSE(nHdlBco)
			UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
		EndIf
		nLidos+=nTamDet
		Loop
	Else
		cNosso := IIF( (MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU' ) ,Substr(xBuffer,63,08),Substr(xBuffer,71,12))	//Num do boleto no Banco
		
		//������������������������������������������������������������������������������������������Ŀ
		//�Chamo a funcao que faz o sistema procurar o titulo provisorio gerado pela venda no site,  �
		//�pega as informacoes do mesmo, exclui para gerar o faturamento do pedido, para que seja    �
		//�gerado o novo titulo conforme faturamento, e baixado o mesmo via processo normal do Cnab. �
		//��������������������������������������������������������������������������������������������
		U_MntCnab(cNosso)
		
		xReg   := xBuffer
		If MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU'
			cIdPed := Substr(xBuffer,63,08)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
		ElseIf MV_PAR06 == '237' .OR. alltrim(MV_PAR08) == 'COBBRAD'
			cIdPed := Substr(xBuffer,71,11)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
		EndIf
		cIdPed := Alltrim(Str(Val(cIdPed)))
		dDatabx:=ctod(Substr(xBuffer,296,02)+'/'+Substr(xBuffer,298,02)+'/'+Substr(xBuffer,300,02))
		If dtos(dDatabx) <= dtos(dDataMovFin)
			dDatabx:=dDataMovFin+1
		Endif
		
		nValTit:= Val(Substr(xBuffer,153, 13))/100		//Pos. 153 a 165  ---> Valor do titulo no arquivo
		nValTax:= Val(Substr(xBuffer,176, 13))/100		//Pos. 176 a 188  ---> TAXA
		nValPag:= Val(Substr(xBuffer,254, 13))/100		//Pos. 254 a 266  ---> VALOR PAGO (RECEBIDO)
		nDesc  := Val(Substr(xBuffer,241, 13))/100		//Pos. 241 a 253  ---> DESCONTO
		nJuros := Val(Substr(xBuffer,267, 13))/100		//Pos. 267 a 279  ---> JUROS
		
		/*	---------------------------------------
		Pesquisa Numero do Pedido de Venda
		---------------------------------------*/
		SC5->( MsSeek(xFilial("SC5")+cIdPed) )			//Ordem 5 // com erro
		//		If SC5->( !Found() ) .OR. AllTrim(cIdPed) <> AllTrim(SC5->C5_CHVBPAG)
		If SC5->( !Found() ) .OR. Alltrim(Str(Val(cIdPed))) <> AllTrim(SC5->C5_CHVBPAG)
			
			
			/*
			cLinDet := Substr(xBuffer,1,394)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			*/
			
			cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
			cLinDet += "         PED NAO LOCALIZ"+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
			cLinDet += Substr(xBuffer,63,332)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			
			If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
				ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
				FCLOSE(nHdlNew)
				FCLOSE(nHdlBco)
				UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
			EndIf
			nLidos+=nTamDet
			Loop
		EndIF
		
		/*	--------------------------------------------------
		Pesquisa Numero do Documento Fiscal do Item
		--------------------------------------------------*/
		If SC6->( !MsSeek(xFilial("SC6")+SC5->C5_NUM) )
			cLinDet := Substr(xBuffer,1,394)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			
			If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
				ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
				FCLOSE(nHdlNew)
				FCLOSE(nHdlBco)
				UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
			EndIf
			nLidos+=nTamDet
			Loop
		EndIF
		
		cQuery	:=	" SELECT    SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_NOTA, SC6.C6_SERIE, SUM(SC6.C6_PRCVEN) C6_PRCVEN " +;
		" FROM      " + RetSqlName("SC6") + " SC6 " +;
		" WHERE     SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND  " +;
		"           SC6.C6_NUM = '" + SC5->C5_NUM + "' AND " +;
		"           SC6.C6_XOPER <> '53' AND " +;
		"           SC6.D_E_L_E_T_ = ' ' " +;
		" GROUP BY  SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_NOTA, SC6.C6_SERIE "
		
		PLSQuery( cQuery, "SC6TMP" )
		
		aTitulos := {}
		While SC6TMP->( !Eof() )
			
			If SF2->(MsSeek(xFilial("SF2")+SC6TMP->(C6_CLI+C6_LOJA+C6_NOTA+C6_SERIE)))
				If !Empty(SF2->F2_DUPL)		//Gerou titulo a receber
					SE1->(MsSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)))        ////E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					
					While	SE1->(!Eof()) .AND.;
						SE1->E1_CLIENTE == SF2->F2_CLIENTE .AND.;
						SE1->E1_LOJA == SF2->F2_LOJA .AND.;
						SE1->E1_PREFIXO == SF2->F2_PREFIXO .AND.;
						SE1->E1_NUM == SF2->F2_DUPL
						
						//If SE1->E1_SALDO == 0
						//	SE1->(dbSkip())
						//	Loop
						//Endif
						
						If SE1->E1_TIPMOV <> "1"	// Boleto
							SE1->(dbSkip())
							Loop
						Endif
						
						SE1->( RecLock("SE1",.F.) )
						SE1->E1_NUMBCO := IIF( (MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU' ) ,Substr(xBuffer,63,08),Substr(xBuffer,71,12))	//Num do boleto no Banco
						If Empty(SE1->E1_IDCNAB)
							SE1->E1_IDCNAB := GetSxeNum("SE1","E1_IDCNAB"); ConfirmSx8()
							SE1->E1_HIST   := FileNoExt(Right(cArqEnt,12))
						EndIf
						SE1->( MsUnlock() )
						
						aAdd(aTitulos,{SE1->E1_IDCNAB,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_VALOR,SE1->E1_SALDO,SE1->E1_BAIXA,SE1->E1_PEDGAR})
						
						
						SE1->(dbSkip())
					End
				EndIf
			EndIf
			SC6TMP->(  DbSkip() )
		End
		SC6TMP->( DbCloseArea() )
		
		
		/*	--------------------------------------------
		Grava linha de detalhe atualizada
		--------------------------------------------*/
		If Len(aTitulos) > 0
			/*	-----------------------------------------
			Mais de um titulo encontrado para o PV
			-----------------------------------------*/
			cPedGarAnt := ""
			nSldTitCnab	:= nValPag+nValTax
			For nCt := 1 To Len(aTitulos)
				nSldTitCnab :=  nSldTitCnab - aTitulos[nCt,6]
				cLinDet 	:= Substr(xBuffer,  1, 37)					//Pos.  1 a 37
				
				IF SubStr(xBuffer,109,2) =="16"      //16-BAIXA POR NAO RECEBIMENTO
					cLinDet +="          16 "+aTitulos[nCt,2]+aTitulos[nCt,3]
				ELSEIF aTitulos[nCt,7]==0
					cLinDet +="          BX "+DTOS(aTitulos[nCt,8])+Space(4)
				ELSE
					cLinDet += aTitulos[nCt,1]+Space(15)
				ENDIF
				
				If MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU'
					cLinDet += PadR(aTitulos[nCt,2]+aTitulos[nCt,3]+aTitulos[nCt,4], 15)					//Pos. 63 a 77
					cLinDet += Substr(xBuffer, 78, 75)					//Pos. 78 a 152
				Else
					cLinDet += Substr(xBuffer, 63, 90)					//Pos. 63 a 152
				EndIf
				
				cLinDet += STRZERO(aTitulos[nCt,6]* 100,13)		//Pos.153 a 165	---> E1_VALOR
				If (MV_PAR06 == '341' .OR. alltrim(MV_PAR08) == 'COBITAU') //.and. aTitulos[nCt,9] == cPedGarAnt
					cLinDet += Substr(xBuffer,166, 10)	       			//Pos.166 a 175
					cLinDet += Replicate("0",13) 						//Pos.176 a 188 - zera Taxa para 2o titulo
					cLinDet += Substr(xBuffer,189, 52)					//Pos.189 a 240
					//nValTax := 0
				Else
					cLinDet += Substr(xBuffer,166, 75)	       			//Pos.166 a 240
				EndIF
				
				/* Valor recebido com abatimento ou juros */
				nValPag := IIF(nSldTitCnab >= 0 ,aTitulos[nCt,6],(aTitulos[nCt,6]-nValTax)+nSldTitCnab )
				If nCt < Len(aTitulos)
					cLinDet += StrZero(nDesc * 100,13)   			//Pos.241 a 253 ---> Desconto/Abat.
					cLinDet += STRZERO(nValPag * 100,13)	//Pos.254 a 266 ---> VALOR PAGO (RECEBIDO)
					cLinDet += StrZero(nJuros * 100,13)   			//Pos.267 a 279 ---> Juros
				Else
					nValPag := (nValPag + nJuros - nDesc )
					
					cLinDet += StrZero(nDesc * 100,13)   			//Pos.241 a 253 ---> Desconto/Abat.
					cLinDet += STRZERO(nValPag * 100,13)			//Pos.254 a 266 ---> VALOR PAGO (a maior ou a menor)
					cLinDet += StrZero(nJuros * 100,13)   			//Pos.267 a 279 ---> Juros
				EndIf
				cLinDet += Substr(xBuffer,280,16)   				//Pos.280 a 295
				cLinDet += Substr(dtos(dDatabx),7,2)+Substr(dtos(dDatabx),5,2)+Substr(dtos(dDatabx),3,2)   				//Pos.296 a 301
				cLinDet += Substr(xBuffer,302,93)   				//Pos.302 a 394
				
				cLinDet += StrZero(nNumSeq,6)  			   			//Pos.395 a 400
				cLinDet += CRLF
				/*
				------------------------------------------
				Grava o registro no arquivo texto
				------------------------------------------*/
				If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
					ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
					FCLOSE(nHdlNew)
					FCLOSE(nHdlBco)
					UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
				EndIf
				If nCt < Len(aTitulos)
					nNumSeq++
				EndIf
				cPedGarAnt := aTitulos[nCt,9]
			Next
		Else
			/*
			cLinDet := Substr(xBuffer,1,394)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			*/
			cLinDet := Substr(xBuffer,  1, 37)					//Pos.  1 a 37
			cLinDet += 	"         TIT NAO LOCALIZ"+Space(1)			//Pos. 38 a 62  ---> E1_IDCNAB
			cLinDet += Substr(xBuffer,63,332)
			cLinDet += StrZero(nNumSeq,6)
			cLinDet += CRLF
			
			If FWRITE(nHdlNew,cLinDet,nTamDet) != nTamDet
				ApMsgAlert("Erro ao tentar gravar arquivo. O sistema ser� abortado.","INFO","ATENCAO")
				FCLOSE(nHdlNew)
				FCLOSE(nHdlBco)
				UserException("Erro ao tentar gravar arquivo "+" O sistema foi abortado propositalmente no ponto de entrada F200PORT. "+CRLF)
			EndIf
			nLidos+=nTamDet
		Endif
	Endif
	nLidos+=nTamDet
End

Fclose(nHdlBco)
Fclose(nHdlNew)

RestArea(_aArea)

If !MsgYesNo("Arquivo preparado, deseja baixar titulos agora?")
	UserException("Interrompido volunt�riamente pelo usu�rio...")
Endif

Return(.T.)
