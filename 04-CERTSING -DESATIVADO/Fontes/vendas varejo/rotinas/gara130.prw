#INCLUDE "PROTHEUS.CH" 
 
/*/{Protheus.doc} GARA130 
 
Fonte de integracao com o GAR para emissao de nota de entrega de mercadoria. Libera o restante do pedido jah faturado e emite nota de entrega da mercadoria. 
 
@author Totvs SM - Armando Tessarolli 
@since 23/01/2010 
@version P11 
 
/*/ 
User Function GARA130(aDadosSZ5,lhub,cEvento) 
	Local aRet			:= {} 
	Local aStruSZ5		:= SZ5->( DbStruct() ) 
	Local cValCpos		:= "" 
	Local cLog			:= "" 
	//Local cSZGVoucher	:= "" 
	Local cTipVoucher	:= SuperGetMv("MV_TIPVOUC",.F.,"1|3|6|A|G")//???? 
	//Local lSoServico	:= .T. 
	Local lPed			:= .F.      
	Local lVoucher		:= .F.      
	//Local lEstrutura	:= .F.                    
	//Local _ltemValor	:= .F. 
	//Local lValSw		:= .F. 
	//Local lValHw		:= .F. 
	Local lTipVou		:= .T. 
	Local nPZ5_PEDGAR	:= Ascan( aDadosSZ5, { |x| x[1] == "Z5_PEDGAR"}) 
	Local nPZ5_TIPMOV	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_TIPMOV"}) 
	Local nPZ5_TIPVOU	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_TIPVOU"}) 
	Local nPZ5_CODVOU	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_CODVOU"}) 
	Local nPZ5_VALOR	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_VALOR"}) 
	//Local nPZ5_VALSW	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_VALORSW"}) 
	//Local nPZ5_VALHW	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_VALORHW"}) 
	Local nPZ5_CNPJ		:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_CNPJ"}) 
	Local nPZ5_STATUS	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_STATUS"}) 
	//Local nPZ5_GARANT	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_GARANT"}) 
	//Local nPZ5_CODPOS	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_CODPOS"}) 
	//Local nPZ5_EMISSA	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_EMISSAO"}) 
	//Local nPZ5_DATVAL	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_DATVAL"}) 
	Local nPZ5_TABELA	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_TABELA"}) 
	//Local nPZ5_PRODUTO	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_PRODUTO"}) 
	//Local nPZ5_DESPRO	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_DESPRO"}) 
	//Local nPZ5_OBSCOM	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_OBSCOM"}) 
	//Renato Ruy - 15/09/16 
	//Gerar dados da campanha do contador. 
	//Local nPZ5_DATPED	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_DATPED"}) 
	//Local nPZ5_COMSW	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_COMSW"}) 
	//Local nPZ5_DESREDE	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_DESREDE"}) 
	//Local nPZ5_BLQVEN	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_BLQVEN"}) 
	//Local nPZ5_CODPAR	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_CODPAR"}) 
	//Local nPZ5_NOMPAR	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_NOMPAR"}) 
	//Local nPZ5_CODVEND	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_CODVEND"}) 
	//Local nPZ5_NOMVEND	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_NOMVEND"}) 
	
	Local nI			:= 0 
	Local nPos			:= 0 
	//Local nRecSF2Hrd	:= 0 
	//Local nRecSF2Sfw	:= 0 
	Local lNovPtoFat	:= .F. 
	Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62") 
	//Local csql			:= "" 
	Local lSC5			:= .F. 
	
	Private nRecSF1		:= 0 
	Private cTabPrcSZ5	:= "" 
	Private cOperVenS	:= GetNewPar("MV_XOPEVDS", "61") 
	Private cOperVenH	:= GetNewPar("MV_XOPEVDH", "62") 
	Private cOperEntH	:= GetNewPar("MV_XOPENTH", "53") 
	
	Default lhub := .F. // Pode ser chamada de outras rotinas não WEB". 
	
	// Ajusta espaços em branco do Array recebido na chamada da função gara130 
	For nI := 1 To Len(aDadosSZ5) 
		If Valtype(aDadosSZ5[nI][2]) == "C" .AND. aDadosSZ5[nI][1] != "Z5_PEDGAR" 
			aDadosSZ5[nI][2] := AllTrim(aDadosSZ5[nI][2]) 
		Endif 
	Next nI 
	
	If !lHub 
		//Verifica se existe o campo pedido GAR no Array 
		If nPZ5_PEDGAR == 0 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000078" ) 
			Aadd( aRet, "9999999999" ) 
			Aadd( aRet, "Z5_PEDGAR não ENVIADO NO aDadosZ5" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica se existe conteúdo para pedido GAR no Array 
		If Empty(aDadosSZ5[nPZ5_PEDGAR][2]) 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000079" ) 
			Aadd( aRet, "9999999999" ) 
			Aadd( aRet, "Z5_PEDGAR VAZIO" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica tamanho mínimo do conteúdo do pedido GAR no Array 
		If Len(AllTrim(aDadosSZ5[nPZ5_PEDGAR][2])) < 6 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000158" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "TAMANHO DO CONTEUDO DO CAMPO Z5_PEDGAR MENOR QUE 6 " ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		
		// Verifica se a estrutura da tabela SZ5 veio completa 
		cValCpos := "Z5_PROCRET,Z5_DATPAG,Z5_STATUS,Z5_EMISSAO,Z5_RENOVA,Z5_REVOGA,Z5_GARANT,Z5_CERTIF,Z5_GRUPO,Z5_DESGRU,Z5_TIPVOU,Z5_CODVOU,Z5_FILIAL," 
		cValCpos += "Z5_COMISS,Z5_OBSCOM,Z5_CNPJV,Z5_RSVALID,Z5_NTITULA,Z5_CODAC,Z5_DESCAC,Z5_CODARP,Z5_DESCARP,Z5_REDE,Z5_PRODGAR,Z5_NOMECLI,Z5_CNPJFAT," 
		cValCpos += "Z5_EMAIL,Z5_CODVEND,Z5_NOMVEND,Z5_COMSW,Z5_COMHW,Z5_VALORSW,Z5_VALORHW,Z5_TIPO,Z5_FLAGA,Z5_CPFT,Z5_DESCST,Z5_PEDIDO,Z5_CODPAR," 
		cValCpos += "Z5_NOMPAR,Z5_ITEMPV,Z5_TIPODES,Z5_PEDGANT,Z5_ROTINA,Z5_FORNECE,Z5_LOJA,Z5_CODPD,Z5_NFDEV" 
	
		For nI := 1 to Len(aStruSZ5) 
			//Todo novo campo criando na SZ5 e que não é enviado no Array, deve compor o Pertence do IF abaixo	 
			If !(AllTrim(aStruSZ5[nI][1]) $ cValCpos ) 
				nPos := Ascan( aDadosSZ5, { |x| AllTrim(x[1])==AllTrim(aStruSZ5[nI][1]) } ) 
				If nPos == 0 
					aRet := {} 
					Aadd( aRet, .F. ) 
					Aadd( aRet, "000077" ) 
					Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
					Aadd( aRet, "não foi encontrado o Campo "+AllTrim(aStruSZ5[nI][1]) ) 
					U_AddProcStat("E",aRet) 
					Return  
				Else 
					// Verifica se os campos estao todos preenchidos 
					If Empty(aDadosSZ5[nPos][2]) 
						aRet := {} 
						Aadd( aRet, .F. ) 
						Aadd( aRet, "000078" ) 
						Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
						Aadd( aRet, "não foi informado conteúdo para o campo "+AllTrim(aStruSZ5[nI][1]) ) 
						U_AddProcStat("E",aRet) 
						Return  
					Endif 
				Endif 
			Endif 
		Next nI 
		
		//Verifica se existe o campo TIPMOV no Array 
		If nPZ5_TIPMOV == 0 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000080" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "Z5_TIPMOV não ENVIADO NO aDadosZ5" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif                                               
		//Verifica se existe conteúdo e atualiza o campo TIPMOV no Array 
		Iif(Empty(aDadosSZ5[nPZ5_TIPMOV][2]), aDadosSZ5[nPZ5_TIPMOV][2] := "1", aDadosSZ5[nPZ5_TIPMOV][2]) 
	
		//Verifica se existe o campo VALOR no Array 
		If nPZ5_VALOR == 0 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000082" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "Z5_VALOR não ENVIADO NO aDadosZ5" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica se existe conteúdo para o campo valor no Array// TIPO mov Voucher vem em branco 
		If Empty(aDadosSZ5[nPZ5_VALOR][2]) .AND. aDadosSZ5[nPZ5_TIPMOV][2] $ "1,2,3,4,5" // 1=Boleto;2=Cartao Credito;3=Cartao Debito;4=DA;5=DDA	6=Voucher	// 6=Voucher 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000083" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "Z5_VALOR não PODE SER ZERO PARA ESTE TIPO DE MOVIMENTO" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica se existe o campo CNPJ no Array 
		If nPZ5_CNPJ == 0 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000084" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "Z5_CNPJ não ENVIADO NO aDadosZ5" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica se existe conteúdo para o campo cnpj  no Array 
		If Empty(aDadosSZ5[nPZ5_CNPJ][2]) 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000085" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "O CAMPO Z5_CNPJ não PODE SER VAZIO" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
		//Verifica se existe o campo status no Array 
		If nPZ5_STATUS == 0 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000086" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "Z5_STATUS não ENVIADO NO aDadosZ5" )    
			Return 
		Endif 
		//Verifica se existe conteúdo paro campo status no Array 
		If Empty(aDadosSZ5[nPZ5_STATUS][2]) 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "000087" ) 
			Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
			Aadd( aRet, "O CONTEUDO DO CAMPO Z5_STATUS não PODE SER VAZIO" ) 
			U_AddProcStat("E",aRet) 
			Return  
		Endif 
	EndIf                                       
	
	//#TP20130523 - Gravacao dos dados do voucher
	
	//Verifica o movimento do voucher consumido 
	SZG->( DbSetOrder(1) )		// ZG_FILIAL + ZG_NUMPED 
	lVoucher := SZG->(DbSeeK ( xFilial("SZG") + PadR(aDadosSZ5[nPZ5_PEDGAR][2],10," ") ) ) 
	
	If lVoucher // Se existe consumo do Voucher complementa dados do Array para remuneração. 
	
		//Complementa os dados de voucher no array recebido na função 
		SZF->( DbSetOrder(2) ) // ZF_FILIAL + ZF_COD 
		SZF->(DbSeeK(xFilial("SZF") + SZG->ZG_NUMVOUC)) 
		cLog += "Pedido: " +SZG->ZG_NUMPED+ " - Voucher: " +SZG->ZG_NUMVOUC+ " - Tipo Voucher: " + SZF->ZF_TIPOVOU 
	
		lTipVou	:= !SZF->ZF_TIPOVOU $ cTipVoucher//??? 
		aDadosSZ5[nPZ5_CODVOU][2] 	:= SZF->ZF_COD	 
		aDadosSZ5[nPZ5_TIPVOU][2]  	:= SZF->ZF_TIPOVOU 
		
	Endif	 
	
	//Ajustes de código para atender migração versão P12 
	//Uso de DbOrderNickName 
	//OTRS:2017103110001774 
			
	SC5->(DbOrderNickName("NUMPEDGAR"))				 
	//Busca dados do pedido 
	lSC5 := SC5->(DbSeeK( xFilial("SC5")+aDadosSZ5[nPZ5_PEDGAR][2] ) ) 
	
	If !lSC5 
		SC6->(DbOrderNickName("NUMPEDGAR"))	 
		If SC6->(DbSeeK( xFilial("SC5")+aDadosSZ5[nPZ5_PEDGAR][2] ) ) 
			SC5->(DbSetOrder(1)) 
			lSC5 := SC5->(DbSeeK( xFilial("SC5")+SC6->C6_NUM ) ) 
		EndIF 
	EndIf 
	
	If lSC5 
		lPed:=.T. 
	
		aDadosSZ5[nPZ5_TIPMOV][2] 	:= Iif(Empty(aDadosSZ5[nPZ5_TIPMOV][2]),SC5->C5_TIPMOV, aDadosSZ5[nPZ5_TIPMOV][2])	 
		aDadosSZ5[nPZ5_CNPJ][2]	  	:= Iif(Empty(aDadosSZ5[nPZ5_CNPJ][2]),SC5->C5_CNPJ,aDadosSZ5[nPZ5_CNPJ][2]) 
		aDadosSZ5[nPZ5_TABELA][2] 	:= Iif(Empty(aDadosSZ5[nPZ5_TABELA][2]),SC5->C5_TABELA,aDadosSZ5[nPZ5_TABELA][2]) 
	
		SC6->( DbSetOrder(1) ) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO 
		If SC6->( DbSeek( xFilial("SC6")+ SC5->C5_NUM ) ) 
		
			lNovPtoFat := SC6->C6_XOPER $ cOperNPF 
			
		EndIf  
	Endif 
	
	//Força atualização de dados conforme quando voucher 
	if lVoucher 
		//Atualizando Informações pertinentes ao voucher no array recebido pela função	 
		aDadosSZ5[nPZ5_TIPMOV][2] 	:= Iif(Empty(aDadosSZ5[nPZ5_TIPMOV][2]),'6', aDadosSZ5[nPZ5_TIPMOV][2]) 
	ENDIF 
	
	//Atualiza dados da SZ5 
	
	aRet := {} 
	aRet := GAR130GrvSZ5(aDadosSZ5,cEvento) 	// Grava tabela SZ5 de dados adicionais / // #TP20130120 - Levar evento para gravacao Z5_TIPO 
	If !aRet[1] 
		U_AddProcStat("E",aRet) 
	Endif 
	
	
	//Caso se refira a pedido que considera novo ponto de faturamento 
	//realiza anélise apra verificar se deve faturar Hardware ou Software 
	//de acordo o evendo 
	
	aRet := {} 
	aRet := FatPed(cEvento,aDadosSZ5[nPZ5_PEDGAR][2],lNovPtoFat ) 
	If !aRet[1] 
		U_AddProcStat("E",aRet) 
	Endif 
Return  

/*/{Protheus.doc} GAR130GrvSZ5 
 
Rotina de gravação de dados da tabela SZ5 
 
@author Totvs SM - Armando Tessarolli 
@since 23/01/2010 
@version P11 
/*/ 
Static Function GAR130GrvSZ5(aDadosSZ5,cEvento) 
 
	Local aRet			:= {} 
	Local nI			:= 0 
	Local nPZ5_PEDGAR	:= Ascan( aDadosSZ5, { |x| x[1] =="Z5_PEDGAR" } ) 
	//Local nPZ5_TIPMOV	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_TIPMOV" } ) 
	//Local nPZ5_VALOR	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_VALOR" } ) 
	//Local nPZ5_VALSW	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_VALORSW" } ) 
	//Local nPZ5_VALHW	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_VALORHW" } ) 
	//Local nPZ5_CNPJ		:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_CNPJ" } ) 
	//Local nPZ5_TABELA	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1])=="Z5_TABELA" } ) 
	//Local nPZ5_PRODUTO	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_PRODUTO"}) 
	//Local nPZ5_DATVAL	:= Ascan( aDadosSZ5, { |x| AllTrim(x[1]) == "Z5_DATVAL"}) 
	//Local csql			:= "" 
	Local lIncZ5		:= .T. 
	//Local lDatVer		:= .F. 
	//Local cProdGar:= '' 
	
	//Renato Ruy - 21/02/2017 
	//O sistema estava utilizando uma query para validar se existia o pedido 
	//Isto gerou duplicidade nos registros, vou efetuar a validacao atraves do indice. 
	//Tambem faz um sleep antes da gravacao para evitar duplicidade. 
	sleep(Randomize( 1, 1000 )) 
	
	//Renato Ruy - 24/02/17 
	//Criacao de semaforo para evitar a duplicidade 
	If LockByName("GARA130"+aDadosSZ5[nPZ5_PEDGAR][2]) 
		SZ5->(DbSetOrder(1)) 
		If  SZ5->(DbSeek(xFilial("SZ5")+aDadosSZ5[nPZ5_PEDGAR][2])) 
			lIncZ5 := .F. 
		Else 
			lIncZ5 := .T. 
		EndIf 
	Else 
		aRet := {} 
		Aadd( aRet, .T. ) 
		Aadd( aRet, "000103" ) 
		Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
		Aadd( aRet, "SZ5 NAO CONSEGUIU CRIAR O SEMAFORO PARA O PEDIDO DO EVENTO " + cEvento) 
		Return(aRet) 
	Endif 
	
	// Grava a tabela SZ5 
	SZ5->( RecLock( "SZ5", lIncZ5 ) ) 
	SZ5->Z5_FILIAL := xFilial("SZ5") 
	If cEvento == "VALIDA" 
		
		For nI := 1 To Len(aDadosSZ5) 
			
			cCampo := RTrim(aDadosSZ5[nI][1]) 
			If !lIncZ5 .and.  ;
				(	cCampo <> "Z5_VALOR" 	.And. ;
					cCampo <> "Z5_TIPMOV"   .And. ;
					cCampo <> "Z5_PRODUTO"  .And. ;
					cCampo <> "Z5_DESPRO"   .And. ;
					cCampo <> "Z5_VALORSW" 	.And. ;
					cCampo <> "Z5_PEDIDO"   .And. ;
					cCampo <> "Z5_ITEMPV"   .And. ;
					cCampo <> "Z5_PEDGAR"   .And. ;
					cCampo <> "Z5_PRODGAR" ) 
				
				//Retirei as regras criadas aqui pois as mensagens não estão mais apresentando o erros
				//Bruno Nunes - 27/05/2021
				&( "SZ5->"+cCampo ) := Iif( Empty(&("SZ5->" + cCampo)),aDadosSZ5[nI][2],&("SZ5->"+cCampo)) 
			Else 
				&("SZ5->"+cCampo) := Iif(Empty(&("SZ5->" + cCampo)),aDadosSZ5[nI][2],&("SZ5->"+cCampo)) 
			EndIf 
		Next nI 
		SZ5->Z5_TIPO := cEvento 
		SZ5->Z5_TIPODES := "VALIDACAO DE CERTIFICADO" 
	
	ElseIf cEvento == "VERIFI"     
	
		For nI := 1 To Len( aDadosSZ5 )  
			cCampo := RTrim( aDadosSZ5[nI][1] ) 
			//Retirei as regras criadas aqui pois as mensagens não estão mais apresentando o erros
			//Criei uma regra de exceção somente para o campo Z5_DESPOS, esse é para o campo nome de posto 
			//de validação, logo esse campo que vem na mensagem de verificação não deve ser gravado na tabela.
			//Caso seja criado esse campo na SZ5, ai sim deverá gravar na tabela.
			//Bruno Nunes - 27/05/2021
			if cCampo != "Z5_DESPOS" .Or. cCampo != "Z5_CODPOS"
				&("SZ5->"+cCampo) := iif( Empty( &("SZ5->" + cCampo) ), aDadosSZ5[nI][2], &("SZ5->"+cCampo) ) 
			endif
		Next nI 
	
		//Gravando tipo de evento 
		SZ5->Z5_TIPO := cEvento                     
		SZ5->Z5_TIPODES := "VERIFICACAO DE CERTIFICADO" 
	
	ElseIf cEvento == "EMISSA" 
		
		For nI := 1 To Len(aDadosSZ5)     
			cCampo := RTrim(aDadosSZ5[nI][1]) 
			//Retirei as regras criadas aqui pois as mensagens não estão mais apresentando o erros
			//Bruno Nunes - 27/05/2021
			&("SZ5->"+cCampo) := Iif( Empty( &( "SZ5->" + cCampo ) ), aDadosSZ5[ nI ][ 2 ], &( "SZ5->" + cCampo ) ) 
		Next nI 
		//Gravando tipo do evento 
		SZ5->Z5_TIPO := cEvento 
		SZ5->Z5_TIPODES := "EMISSAO DE CERTIFICADO" 
		
	Endif 
	
	If SZ5->(FieldPos("Z5_ROTINA")) > 0 
		SZ5->Z5_ROTINA := "GARA130" 
	EndIf 
	
	SZ5->( MsUnLock() ) 
	
	UnLockByName("GARA130"+aDadosSZ5[nPZ5_PEDGAR][2]) 
	
	//Renato Ruy - 15/09/16 
	//Atualiza valores na rotina AtuValZ5 
	//         Pedido Gar                ,1-não Altera Quando Calculou remuneração - 2-força atualização com novo valor 
	U_AtuValZ5(aDadosSZ5[nPZ5_PEDGAR][2],"1") 
	
	aRet := {} 
	Aadd( aRet, .T. ) 
	Aadd( aRet, "000100" ) 
	Aadd( aRet, aDadosSZ5[nPZ5_PEDGAR][2] ) 
	Aadd( aRet, "SZ5 ATUALIZADA COM SUCESSO" ) 
Return(aRet) 
 
/*/{Protheus.doc} FatPed 
 
Rotina para faturamento do Hardware ou software do Pedido considerando novo ponto de faturamento 
 
@author Totvs SM - David de Oliveira 
@since 02/03/2017 
@version P11 
 
/*/ 
Static Function FatPed(cEvento,cPedGar,lNovPtoFat) 
	Local aRet 		:= {} 
	Local cEventFatH:= GetNewPar("MV_XEVFTHD", "VERIFI") 
	Local cEventFatS:= GetNewPar("MV_XEVFTSW", "EMISSA") 
	Local lFatHard	:= .F. 
	Local lFatSfw	:= .F. 
	Local lCont		:= .F. 
	Local lEntHard  := .F. 
	Local lFat      := .F. 
	Local lSC5		:= .F. 
	Local cPedGarIt := ""	 
	If Alltrim(cEvento) == Alltrim(cEventFatH) 
		 
		If lNovPtoFat 
			lFat      := .T. 
			lFatHard  := .T. 
		Else           
			lFat      := .F.	 
		    lEntHard  := .T. 
	    Endif 
 
		lCont	 := .T. 
	 
	EndIf 
	 
	If Alltrim(cEvento) == Alltrim(cEventFatS) 
		lFat      := .T. 
		lFatSfw   := .T. 
		lCont	  := .T. 
	EndIf 
		 
	If lCont 
	 
		//Ajustes de código para atender migração versão P12 
		//Uso de DbOrderNickName 
		//OTRS:2017103110001774 
		 
		DbSelectArea("SC5") 
		DbOrderNickName("NUMPEDGAR") 
		 
		DbSelectArea("SZF") 
		SZF->( DbSetOrder(2) )		// ZF_FILIAL+ZF_COD 
		DbSelectArea("SZH")                                                                                                                                               
		SZH->( DbSetOrder(1) )		//ZH_FILIAL+ZH_TIPO  
		DbSelectArea("SC6") 
		SC6->(DbSetOrder(1)) 
		 
		lSC5 		:=  SC5->(DbSeeK( xFilial("SC5")+cPedGar ) ) 
		cPedGarIt 	:= "" 
		 
		If !lSC5 
			DbSelectArea("SC6") 
			DbOrderNickName("NUMPEDGAR") 
			 
			If SC6->(DbSeeK( xFilial("SC6")+cPedGar ) ) 
				DbSelectArea("SC5") 
				DbSetOrder(1) 
				 
				lSC5 		:= SC5->(DbSeeK( xFilial("SC5")+SC6->C6_NUM ) ) 
				cPedGarIt	:= SC6->C6_PEDGAR 
			EndIf  
		EndIf 
		 
		If lSC5 
			If !Empty(SC5->C5_XNUMVOU) 
				If SZF->(DbSeeK( xFilial("SZF")+SC5->C5_XNUMVOU ) ) 
					If SZH->(DbSeeK( xFilial("SZH")+SZF->ZF_TIPOVOU  ) ) 
						IF SZH->ZH_EMNTVEN $ "N,P" //S=Servico;P=Produto;A=Ambos;N=Nao Emite  
							//Elimina reséduo                 
							DbSelectArea("SC6") 
							SC6->(DbSetOrder(1)) 
							 
							If DbSeek(xFilial("SC6")+SC5->C5_NUM) 
								IF EMPTY(SC5->C5_NOTA)  
									RecLock("SC5",.F.) 
									SC5->C5_NOTA := "XXXXXX   " 
									SC5->(MsUnlock())      
								ENDIF 
	 
								While SC5->C5_NUM == SC6->C6_NUM 
									If Empty(SC6->C6_NOTA) 
										RecLock("SC6",.F.) 
										SC6->C6_BLQ := "R" 
										SC6->(MsUnlock()) 
									EndIf 
									DbSelectArea("SC6") 
									DbSkip() 
								EndDo 
							EndIf 
							aRet := {} 
							Aadd( aRet, .T. ) 
							Aadd( aRet, "000096" ) // NFS gerada com sucesso... 
							Aadd( aRet, cPedGar ) 
							Aadd( aRet, "Pedido Referente a Voucher" ) 
							lCont := .F.	 
						Endif 
					Endif 
				Endif 
			Endif 
			 
			If lCont  
				IF  ! (SUBSTR(SC5->C5_NOTA,1,6)=="XXXXXX" .AND.; 
				( ALLTRIM(SC5->C5_ARQVTEX)=='CHARGEBACK' .OR. ALLTRIM(SC5->C5_ARQVTEX)=='REEMBOLSO' .OR. ALLTRIM(SC5->C5_ARQVTEX)=='AUDITORIA' ) ) 
					aParamFun := {	SC5->C5_NUM,;			//1- Némero do pedido 
									Val(SC5->C5_XNPSITE),;  //2- Numero de controlo de JOB para log Gtin 
									lFat,;					//3- Fatura venda 
									nil,;					//4- Nosso némero para atualização do tétulo a receber 
									lFatSfw,;				//5- Fatura Serviéo 
									lFatHard,;				//6- Fatura produto 
									0,;						//7- Quantidade a faturar  
									nil,;					//8- Operaééo de venda Hardware 
									nil,;					//9- Operaééo de entrega Hardware 
									nil,;					//10- Operaééo de venda de Serviéo 
									SC5->C5_CHVBPAG,;		//11- Pedido de Log 
									nil,;					//12- data do Crédito Cnab 
									.F.,;					//13- Gera recibo de liberaééo  
									.F.,;					//14- Gera tétulo para recibo  de liberaééo 
									"",;					//15- Tipo do tétulo de recibo de liberaééo 
									lEntHard,;				//16- Fatura entrega de hardware 
									0,;						//17- Valor Tétulo de Recibo 
									"",;					//18- Banco Cnab 
									cPedGarIt}				//19- Pedido Gar Item do Pedido 
					 
					//varinfo("Paramgar130",aParamFun) 
					 
					aRet := U_VNDA190( "" ,aParamFun	) 
				 
				Else 
					aRet := {} 
					Aadd( aRet, .F. ) 
					Aadd( aRet, "M00003" )  
					Aadd( aRet, cPedGar ) 
					Aadd( aRet, "Atenção, solicitação de faturamento para pedido site " + SC5->C5_XNPSITE + " cancelado por " + ALLTRIM(SC5->C5_ARQVTEX) ) 
				EndIf 
			EndIF			 
		Else 
			aRet := {} 
			Aadd( aRet, .F. ) 
			Aadd( aRet, "999999" )  
			Aadd( aRet, cPedGar ) 
			Aadd( aRet, "Pedido GAR não encontrado para Faturamento do Item para Envento "+cEvento ) 
		EndIf 
	Else 
		aRet := {} 
		Aadd( aRet, .T. ) 
		Aadd( aRet, "999999" )  
		Aadd( aRet, cPedGar ) 
		Aadd( aRet, "Evento "+cEvento+" não parametrizado para gerar NF" )	 
	EndIf 
	
Return(aRet)
