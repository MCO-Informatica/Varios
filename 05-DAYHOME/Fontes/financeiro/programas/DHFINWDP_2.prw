#Include "Protheus.Ch" 
#Include "TbiConn.Ch"
#INCLUDE "TOPCONN.CH"

//1818770
/*****************************************************************************/
// Antonio - 14-03-2011 - Dpls a vencer antes de 5 dias 

User function ENVDPLS(aparams)
	Local alMsgs    	:= {"Email enviado com sucesso.",;
    						"N�o encontrado nenhum t�tulo a vencer at� 5 dias ",;
    						"N�o existe a empresa/filial escolhida."}
    Local clMsg			:= ""
    Local nlMsg			:= 0
    Local nlPos			:= 0
    Local nlI			:= 0
    Local dData5		
    Local alItensDpl2	:= {}
	Local cCampos 		:= "E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VENCREA, E1_VALOR, A1_EMAIL, E1_PEDIDO, C5_VEND1, A3_EMAIL "
	Local cQuery 		:= ""  

    Prepare Environment EMPRESA aparams[1] FILIAL aparams[2] MODULO "FIN" 
  	WfPrepENV(aparams[1],aparams[2])  
    
	dData5		:= dDataBase + 6
	DbSelectArea("SE1")                                  
	DbSetOrder(7)
	//If DbSeek(xFilial("SE1")+DTOS(dData5))

		cQuery := "SELECT "                              
		cQuery += "  " + cCampos + " "
		cQuery += "FROM " 
		cQuery += " " + RetSqlName("SE1") + " SE1 "		
		cQuery += "JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
		cQuery += "JOIN " + RetSqlName("SC5") + " SC5 ON C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = E1_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += "JOIN " + RetSqlName("SA3") + " SA3 ON A3_FILIAL = '" + xFilial("SA3") + "' AND A3_COD = C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
		cQuery += "WHERE "	
		cQuery += "  SE1.D_E_L_E_T_     = ' ' "
		cQuery += "  AND E1_FILIAL  = '" + xFilial("SE1")  + "' "
		cQuery += "  AND E1_VENCREA = '" + DtoS(dData5) + "' "
		cQuery += "  AND E1_SALDO  > 0 "
		cQuery += "  AND E1_STATUS = 'A' "
		cQuery += "  AND E1_PORTADO <> '422' "		 	
		cQuery += "  AND E1_XWORK = '' " // CAMPO UTILIZADO PARA IGNORAR WORKFLOW DE ENVIO DE COBRANCA 	
		cQuery += "ORDER BY E1_CLIENTE, E1_LOJA "        
		cQuery := ChangeQuery(cQuery)
		TcQuery cQuery NEW ALIAS "TMPSE1"
	 
		dbSelectArea("TMPSE1")
		TMPSE1->(dbGoTop())

		cCliente := TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA

		While TMPSE1->(!EoF())
            
			
			If TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA <> cCliente
				
				SendDpl_2(alItensDpl2,aparams[2])
				alItensDpl2 := {}
				cCliente := TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA
			EndIf
	        
			aAdd(alItensDpl2,{	TMPSE1->E1_NUM,;			   												// 1
								TMPSE1->E1_PARCELA,;														// 2
								TMPSE1->E1_TIPO,;							// 3
								TMPSE1->E1_CLIENTE+" "+TMPSE1->E1_LOJA,;	// 4
								TMPSE1->E1_NOMCLI,;							// 5
								STOD(TMPSE1->E1_EMISSAO),;					// 6
	   							STOD(TMPSE1->E1_VENCREA),;					// 7
	   							AllTrim(TransForm(TMPSE1->E1_VALOR, PesqPict("SF1", "F1_VALBRUT"))),;							// 8
	   							dDataBase,;									// 9
	   							TMPSE1->A1_EMAIL,;							// 10
								})
			TMPSE1->(DbSkip())
	
		EndDo
        
		If Len(alItensDpl2) > 0
			SendDpl_2(alItensDpl2,aparams[2])
			TMPSE1->( dbCloseArea() )
			clMsg := alMsgs[1]
			//Alert(clMsg)
		EndIf
    
	/*
	Else

		clMsg := alMsgs[2]
		Alert(clMsg)

	EndIf
	*/ 
	
Reset Environment

Return (.T.)	


Static Function SendDpl_2(alItensDpl2,xFILIAL)
                         // GETMV("MV_ENCOTA")= link  
                        // com = empresa ( empfilant)
                        // fil = filial (xFilial())
                        // ord = num Cota��o

//	Local clLink		:= GETMV("MV_ENDCOTA") + "?com=" +clEmpresa +"&fil="+clFil+"&ord="+clNumCot // "http://www.uol.com.br" // parametro criado na SX6
//	Local clLink		:= "http://www.dayhome.com.br"    // + "?com=" +clEmpresa +"&fil="+clFil 
	Local olP           := Nil
	Local olHtml		:= Nil   
	Local clCodProcesso	:= ""
	Local clHtmlModelo	:= ""
	Local clAssunto		:= ""
    Local nlI			:= 1
    
	//Codigo do processo
	clCodProcesso	:= "ENVIO"
	
	//Caminho do template para gerar o relatorio
	clHtmlModelo	:= "\workflow\wFDpls5.html"
	
	//Assunto da mensagem
	clAssunto	:= "FILIAL:"+xFILIAL+", LEMBRETE: Duplicatas a vencer em 05(Cinco) dias."
	
	//Inicializa o processo
	olP := TWFProcess():new(clCodProcesso, clAssunto)
	
	//Cria uma nova tarefa
	olP:newTask("Solicitacao de Duplicatas a vencer daqui a 05(Cinco) Dias", clHtmlModelo)
	
	//Utilizar template html
	olHtml := olP:oHtml
		                                                                     
	//Informa��o dos valores

    //cMail := "robson@proativatecnologia.com.br, thalita@dayhome.com.br, robsonolivesa@gmail.com"//alItensDpl[1,10]  //busca e-mail do cliente e envia
	
	cMail := alItensDpl[1,10]  //busca e-mail do cliente e envia

	cMail += "; contasareceber@dayhomehouseware.com.br; dayhometi@dayhome.com.br; "
	

	aAdd((olHTML:valByName("d.DATA")),alItensDpl2[1,9])

	For nlI := 1 To Len(alItensDpl2)
		aAdd((olHTML:valByName("E1.NUM")),alItensDpl2[nlI,1])
 		aAdd((olHTML:valByName("E1.PARCELA")),alItensDpl2[nlI,2])
//		aAdd((olHTML:valByName("E1.TIPO")),alItensDpl[nlI,3])
		aAdd((olHTML:valByName("E1.CLIENTE")),alItensDpl2[nlI,4])
		aAdd((olHTML:valByName("E1.NOMCLI")),alItensDpl2[nlI,5])
		aAdd((olHTML:valByName("E1.EMISSAO")),alItensDpl2[nlI,6])
		aAdd((olHTML:valByName("E1.VENCREA")),alItensDpl2[nlI,7])
		aAdd((olHTML:valByName("E1.SALDO")),alItensDpl2[nlI,8])
 	Next nlI

// 	olHtml:valByName("LINK"			,clLink)
			
	//Informa assunto
	olP:cSubject := clAssunto

	//Endereco eletronico de envio
	olP:cTo := cMail

	//Gera o processo
	olP:start()
	olP:Free()
	olP:finish()
	
	wfsendmail()
	

Return (Nil)
