#Include "Protheus.ch"
#Include "FWPrintSetup.ch"
#Include "RptDef.ch"
#include "TopConn.ch"

#define CODCLI	1
#define LOJA	2
#define EMAIL	3
#define NOMPDF	4

User Function bolCobr(aParams)

	Local cFiltro := ""
	Local cPerg	 := "BOLETOBCO"
	Local lJob := (select("SX6") == 0)
	Local cprefix := ""
	Local lClient := .t.
	Local cPathInServer	:= "\spool\"	//"\spool\boleto\"
	Local cPasta	:= "c:\temp\boleto\"
	Local aEnvEmail := {}
	Local aEnvDupl  := {}

	Default aParams := {'01','0101',"XX","XX"}

	If lJob

		RpcSetType( 3 )
		RpcSetEnv( aParams[1], aParams[2])

		conout("Job: bolCobr grupo: "+aParams[1]+" Filial: "+aParams[2]+" Cód.Uusário: "+aParams[3]+" ID Task: "+aParams[4])

		lClient := .f.

		if aParams[2] == "0101"
			cprefix := "101"
		elseif aParams[2] == "0102"
			cprefix := "102"
		endif

		cFiltro := "WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND "
		cFiltro += "E1_DATABOR = '"+DtoS(dDatabase)+"' AND E1.D_E_L_E_T_ = ' ' "
		//cFiltro += "E1_DATABOR = '"+DtoS(DataValida(dDatabase-1,.f.))+"' AND E1.D_E_L_E_T_ = ' ' "
		cFiltro += "AND E1_PREFIXO = '"+cprefix+"' "

	Else
		PutSx1(cPerg,"01","Prefixo            ?","","","mv_ch1","C",  3,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Prefixo do titulo "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"02","Do titulo          ?","","","mv_ch2","C",  9,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Titulo Inicial "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"03","Ate Titulo         ?","","","mv_ch3","C",  9,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",{{"titulo Final     "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"04","Parcela de         ?","","","mv_ch4","C",  3,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",{{"Parcela Inicial "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"05","Parcela Ate        ?","","","mv_ch5","C",  3,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{{"Parcela Final   "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"06","Bordero de         ?","","","mv_ch6","C",  6,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{{"Parcela Inicial "}},{{" "}},{{" "}},"")
		PutSx1(cPerg,"07","Bordero Ate        ?","","","mv_ch7","C",  6,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",{{"Parcela Final   "}},{{" "}},{{" "}},"")
		If !Pergunte(cPerg,.t.)
			Return
		EndIf

		cFiltro := "WHERE E1_FILIAL = '"+se1->(xfilial())+"' AND "
		cFiltro += "E1_PREFIXO = '"+MV_PAR01+"' AND "
		cFiltro += "E1_NUM BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND "
		cFiltro += "E1_PARCELA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' AND "
		cFiltro += "E1_NUMBOR BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' AND "
		cFiltro += "E1.D_E_L_E_T_ = ' ' "
	EndIf

	cFiltro += "AND E1_SALDO > 0"

	if !verPasta(cPathInServer)
		return
	endif
	if lClient
		if !verPasta(cPasta)
			return
		endif
	endif

	Processa( {|| EmiBol(cFiltro, lClient, cPasta, cPathInServer, @aEnvEmail, @aEnvDupl, lJob) },"Imprimindo os Boletos...")

	If len(aEnvEmail) > 0 .and. ( lJob .or. MsgYesNo("Deseja Enviar Boletos gerados, por email ?" ) )
		Processa( {|| envBolMail(aEnvEmail, aEnvDupl, lClient, cPasta, cPathInServer, !lJob) },"Enviando os Boletos por E-mail...")
	endif

Return

Static Function EmiBol(cFiltro, lClient, cPasta, cPathInServer, aEnvEmail, aEnvDupl, lJob)
	Local cQuery := ""

	Local cFilename       := ""
	Local nDevice         := IMP_PDF  	//Força a impressão em PDF outra opção é IMP_SPOOL
	Local lAdjustToLegacy := .t.   		//.f.
	Local lDisableSetup   := .t.
	Local nResol          := 74

	Local oBoleto
	Local aBitmap 		  := "BANCO.BMP"

	Local n		   := 0
	Local cCliente := ""
	Local cLoja    := ""

	Local aDadosEmp := {;
		AllTrim(SM0->M0_NOMECOM)													,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                      						,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB 	,; //[3]Complemento
	"CEP: "+transform(SM0->M0_CEPCOB,"@R 99999-999")   							,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                            						,; //[5]Telefones
	"C.N.P.J.: "+transform(SM0->M0_CGC,"@R 99.999.999/9999-99") 				,; //[6]CGC
	"I.E.: "+transform(SM0->M0_INSC,"@R 999.999.999.999")						 ; //[7]I.E
	}
	Local aSacado	:= {}
	Local aDadosTit
	Local aDadosBanco  := {}
	Local aBolText     := {	"Apos o vencimento cobrar multa de 3%",;
		"Mora Diaria de R$ "                  ,;
		"Sujeito a Protesto apos 5 (cinco) dias do vencimento"}
	Local CB_RN_NN     := {}

	Local cBcoCorres := ""
	Local lBcoCorres := .f.

	Private cTrb   := ""

	Private nCB1Linha	:= 12.8
	Private nCB2Linha	:= 23.2
	Private nCBColuna	:= 1.3

	Private nCBLargura	:= 0.081
	Private nCBAltura	:= 4.05

	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMISSAO,E1_VENCREA,E1_CLIENTE,E1_LOJA,E1_SALDO,E1_DECRESC,E1_DESCFIN,"
	cQuery += "E1_NUMBOR,E1_DATABOR,E1_PORTADO,E1_AGEDEP,E1_NUMCON,E1_CONTA,E1_NUMBCO,R_E_C_N_O_ RECSE1 "
	cQuery += "FROM "+RetSQLName("SE1")+" E1 "
	cQuery += cFiltro
	cQuery += "ORDER BY E1_CLIENTE,E1_LOJA,E1_PORTADO,E1_PREFIXO,E1_NUM,E1_PARCELA "

	cQuery := ChangeQuery( cQuery )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrb,.f.,.t.)
	if (cTrb)->( Eof() )
		if !lJob
			MsgStop("Não foram encontrados títulos com os parametros atuais. Favor revisar!")
		endif
		Return
	endif

	sa1->(DbSetOrder(1))
	sa6->(DbSetOrder(1))
	see->(DbSetOrder(1))

	ProcRegua( Contar(cTrb,"!Eof()") )
	(cTrb)->(DbGoTop())

	while !(cTrb)->( Eof() )

		if !sa1->(DbSeek(xFilial()+(cTrb)->e1_cliente+(cTrb)->e1_loja))
			MsgStop("O cliente "+(cTrb)->e1_cliente+"/"+(cTrb)->e1_loja+", não esta cadastrado, não será gerado Boleto" )
			(cTrb)->(DbSkip())
			loop
		else
			if Empty(SA1->A1_ENDCOB)
				aSacado   := {AllTrim(SA1->A1_NOME)           	,;     	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;     	// [2]Código
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;     	// [3]Endereço
				AllTrim(SA1->A1_MUN )                             	,;     	// [4]Cidade
				SA1->A1_EST                                       	,;     	// [5]Estado
				SA1->A1_CEP                                       	,;     	// [6]CEP
				SA1->A1_CGC									  	  	,;     	// [7]CGC
				iif(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
				Alltrim(SA1->A1_EMAIL)						  	  	}      	// [9]EMAIL
			else
				aSacado   := {AllTrim(SA1->A1_NOME)              ,;   	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
				AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
				SA1->A1_ESTC	                                    ,;   	// [5]Estado
				SA1->A1_CEPC                                        ,;   	// [6]CEP
				SA1->A1_CGC									  	  	,;     	// [7]CGC
				iif(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
				Alltrim(SA1->A1_EMAIL)						  	  	}      	// [9]EMAIL
			endif
		endif

		cCliente := (cTrb)->e1_cliente
		cLoja	 := (cTrb)->e1_loja

		cFilename := cCliente+cLoja+DtoS(Date())+StrTran(Time(),":","")
		aadd( aEnvEmail, { sa1->a1_cod, sa1->a1_loja, sa1->a1_email, cFilename } )

		//Criar o Boleto
		oBoleto:=FwMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, cPathInServer, lDisableSetup,,,,lClient/*lServer*/, /*lPDFAsPNG*/, /*lRaw*/, !lJob/*lViewPDF*/ )
		//Propriedades da impressão
		if nResol > 0
			oBoleto:SetResolution(nResol)
		endif
		//oBoleto:SetLandscape()	//paisagem
		oBoleto:SetPortrait()	//retrato
		oBoleto:SetPaperSize(DMPAPER_A4) // papel tamanho A4
		//oBoleto:SetMargin(0,0,0,0)	// nEsquerda, nSuperior, nDireita, nInferior
		if lClient
			oBoleto:cPathPDF := cPasta
		else
			oBoleto:cPathPDF := cPathInServer
		endif
		oBoleto:SetParm( "-RFS")

		while !(cTrb)->( Eof() ) .and. (cTrb)->e1_cliente+(cTrb)->e1_loja == cCliente+cLoja

			IncProc()

			cBanco   := (cTrb)->e1_portado
			cAgencia := (cTrb)->e1_agedep
			cNumCon  := (cTrb)->e1_conta

			//Posiciona o SA6 (Bancos)
			if !sa6->( DbSeek(xFilial()+cBanco+cAgencia+cNumCon ) )
				MsgStop("Banco não esta cadastrado, não será gerado Boleto" )
				(cTrb)->(DbSkip())
				loop
			endif
			//Posiciona na Arq de Parametros CNAB
			if !see->( DbSeek(xFilial()+cBanco+cAgencia+cNumCon+"REC" ))
				MsgStop("Banco nao existe nos parametros Bancarios, não será gerado Boleto" )
				(cTrb)->(DbSkip())
				loop
			EndIf

			if aScan( aEnvDupl, {|x| x[3] == (cTrb)->e1_num }) == 0
				aadd( aEnvDupl, { sa1->a1_cod, sa1->a1_loja, (cTrb)->e1_num } )
			endif

			If SEE->EE_CODIGO == "033"
				cBcoAg := Substr(SEE->EE_AGENCIA,1,4)
			ElseIf SEE->EE_CODIGO == "237"
				cBcoAg := Substr(SEE->EE_AGENCIA,1,4)
			Else
				cBcoAg  := StrTran(SEE->EE_AGENCIA,"-","")
			EndIf
			cBcoCon := Alltrim(SEE->EE_CODEMP)

			//if empty(SEE->EE_BCOCORR)
			cBcoCorres := ""
			lBcoCorres := .f.
			//else
			//	lBcoCorres := .t.
			//	cBcoCorres := SEE->EE_BCOCORR
			//endif

			If cBanco == "237"
				cNumCon  := Substr(cNumCon,1,6)
			Else
				cNumCon  := iif(cBanco=="341",Substr(cNumCon,1,5),cNumCon)
			EndIf

			If !lBcoCorres
				If cBanco == "237"
					aDadosBanco  := {;
						cBanco		,;	// [1]Numero do Banco
					"Bradesco"     	,;	// [2]Nome do Banco (LOGO)
					cBcoAg 		   	,;	// [3]Agência
					cNumCon		   	,;	// [4]Conta Corrente
					SEE->EE_DVCTA  	,;  // [5]Digito da conta correte
					Substr(SEE->EE_CODCART,2,2) ,; // [6]Codigo da Carteira
					Substr(SEE->EE_CODCART,2,2) }
					cDigBco := "2"

				ElseIf cBanco == "341"
					aDadosBanco  := {;
						cBanco  	,;	// [1]Numero do Banco
					"Banco Itau S/A",;	// [2]Nome do Banco (LOGO)
					cBcoAg 		  	,;	// [3]Agência
					Alltrim(cNumCon),;	// [4]Conta Corrente
					SEE->EE_DVCTA   ,;	// [5]Digito da conta correte
					SEE->EE_CODCART ,;  // [6]Codigo da Carteira
					SEE->EE_CODCART}
					cDigBco := "7"

				ElseIf cBanco == "033"
					aDadosBanco  := {;
						cBanco		 ,;  	//1-Numero do Banco
					"Banco Santander",;  	//2-Nome do Banco
					cBcoAg 			,;   	//3-Agência
					Conta(cBanco, SEE->EE_CONTA),;//4-Conta Corrente
					SEE->EE_DVCTA  	,;    	//5-Dígito da conta corrente
					SEE->EE_CODCART ,;		//6-Codigo da Carteira
					SEE->EE_CODCART ,;
						"" }
					cDigBco := "7"

				ElseIf cBanco == "001"
					aDadosBanco  := {;
						cBanco  	,;	//1-Numero do Banco
					"Banco do Brasil",; //2-Nome do Banco
					cBcoAg 			,;  //3-Agência
					SEE->EE_CONTA	,;  //4-Conta Corrente
					SEE->EE_DVCTA  	,;  //5-Dígito da conta corrente
					SEE->EE_CODCART ,;	//6-Codigo da Carteira
					SEE->EE_CODCART ,;
						"" }
					cDigBco := "9"

				ElseIf cBanco == "422"
					aDadosBanco  := {;
						cBanco  	,;   //1-Numero do Banco
					"Banco Safra SA",;   //2-Nome do Banco
					cBcoAg 			,;   //3-Agência
					SEE->EE_CONTA	,;   //4-Conta Corrente
					SEE->EE_DVCTA  	,;   //5-Dígito da conta corrente
					SEE->EE_CODCART ,; 	 //6-Codigo da Carteira
					SEE->EE_CODCART ,;
						"" }
					cDigBco := "7"
				EndIf
			EndIf

			If Empty((cTrb)->E1_PARCELA)
				cParcela:= "000"
			Else
				cParcela:= StrZero(Val(Trim((cTrb)->E1_PARCELA)),3)
			EndIf

			If cBanco == "237" .Or. cBcoCorres == "237"
				_cNossoNum := U_nossonr(lBcoCorres)
			ElseIf cBanco == "341" .Or. cBcoCorres == "341"
				If !Empty((cTrb)->E1_NUMBCO)
					if len(Alltrim((cTrb)->E1_NUMBCO)) == 9
						_cNossoNum := StrZero(Val((cTrb)->E1_NUMBCO),8)
					else
						_cNossoNum := Alltrim((cTrb)->E1_NUMBCO)
					endif
				Else
					_cNossoNum := StrZero(Val(NumIta()),8) //Gera o sequencial do Banco Itau..
				EndIf
			ElseIf cBanco == "033"
				_cNossoNum := NumSan()
			ElseIf cBanco == "001"
				_cNossoNum := U_NumBcoBrasil()
			ElseIf cBanco == "422"
				If !Empty((cTrb)->E1_NUMBCO)
					_cNossoNum := Alltrim((cTrb)->E1_NUMBCO)
				Else
					_cNossoNum := NumSafr()
				EndIf
			Else
				_cNossoNum := strzero(Val(Alltrim((cTrb)->E1_NUM)),9) + cParcela //Composicao Filial + Titulo + Parcela
			EndIf

			_nVlrAbat :=  SomaAbat((cTrb)->E1_PREFIXO,(cTrb)->E1_NUM,(cTrb)->E1_PARCELA,"R",1,,(cTrb)->E1_CLIENTE,(cTrb)->E1_LOJA)
			_nVlrDesc := (cTrb)->E1_SALDO*((cTrb)->E1_DESCFIN/100)

			If cBanco == "237" .Or. cBcoCorres == "237"
				CB_RN_NN := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),((cTrb)->E1_SALDO ),Datavalida(StoD((cTrb)->E1_VENCREA),.T.),aDadosBanco[7])
			ElseIf cBanco == "341" .Or. cBcoCorres == "341"
				CB_RN_NN := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),Alltrim(aDadosBanco[4]),aDadosBanco[5],AllTrim(_cNossoNum),((cTrb)->E1_SALDO - (cTrb)->E1_DECRESC ),Datavalida(StoD((cTrb)->E1_VENCREA),.T.),aDadosBanco[6])
			ElseIf cBanco == "033"
				CB_RN_NN := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),Alltrim(aDadosBanco[4]),aDadosBanco[5],AllTrim(_cNossoNum),((cTrb)->E1_SALDO - (cTrb)->E1_DECRESC ),Datavalida(StoD((cTrb)->E1_VENCREA),.T.),aDadosBanco[6])
			ElseIf cBanco == "001"
				CB_RN_NN := Ret_Bar001(aDadosBanco[1] , Alltrim(_cNossoNum) , ((cTrb)->E1_SALDO-_nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon )
			ElseIf cBanco == "422"
				CB_RN_NN := Ret_Bar422(aDadosBanco[1] , Alltrim(_cNossoNum) , ((cTrb)->E1_SALDO-_nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon, SEE->EE_TPCOBR )
			Else
				CB_RN_NN := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(cTrb)->E1_SALDO ,Datavalida(StoD((cTrb)->E1_VENCREA),.T.),aDadosBanco[6])
			EndIf

			aDadosTit := { ;
				iif(Len(Alltrim((cTrb)->E1_NUM)) > 6,Substr(Alltrim((cTrb)->E1_NUM),4),Alltrim((cTrb)->E1_NUM))+cParcela	,;  // [1] Número do título
			ArrumaAno(StoD((cTrb)->E1_EMISSAO))   		,;  // [2] Data da emissão do título
			ArrumaAno(Date())                   		,;  // [3] Data da emissão do boleto
			ArrumaAno(StoD((cTrb)->E1_VENCREA))  		,;  // [4] Data do vencimento
			((cTrb)->E1_SALDO - (cTrb)->E1_DECRESC )   	,;  // [5] Valor do título //- _nVlrAbat - _nVlrDesc
			CB_RN_NN[3]		                        	,;  // [6] Nosso número (Ver fórmula para calculo)
			(cTrb)->E1_PREFIXO                          ,;  // [7] Prefixo da NF
			"DM"	                               		}   // [8] Tipo do Titulo

			Impress(oBoleto,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aSacado,aBolText,CB_RN_NN,lBcoCorres)
			n := n + 1

			se1->(dbgoto((cTrb)->recse1))

			if !se1->( Eof() )
				SE1->(RecLock("SE1",.f.))
				If Empty(SE1->E1_NUMBCO)
					//SE1->E1_NUMBCO  := "00000"+_cNossoNum  // Nosso número (Ver fórmula para calculo)
					SE1->E1_NUMBCO  := _cNossoNum  // Nosso número (Ver fórmula para calculo)
				EndIf
				SE1->E1_PORTADO	:= cBanco
				SE1->E1_AGEDEP 	:= cAgencia
				SE1->E1_CONTA   := cNumCon
				SE1->(MsUnlock())
			endif

			(cTrb)->(DbSkip())

		end

		if lJob
			oBoleto:Print()
		else
			oBoleto:Preview()
		endif
		FreeObj(oBoleto)
		oBoleto := Nil

	end

Return

Static Function Impress(oBoleto,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aSacado,aBolText,CB_RN_NN,lBcoCorres)
	//Local _nTxper := GETMV("MV_TXPER")
	Local nDacNN
	Local oFont8
	Local oFont9
	Local oFont10
	Local oFont15n
	Local oFont16
	Local oFont16n
	Local oFont14n
	Local oFont24
	Local i := 0

	If Valtype(aBitmap) == "C" .And. Len(aBitmap) > 0
		aBmp := aBitMap
	Else
		aBmp := "BANCO.BMP"
	EndIf

	oFont8  := TFont():New("Arial" ,,10,,.F.,,,,,.F.)
	oFont9  := TFont():New("Arial" ,,10,,.F.,,,,,.F.)
	oFont10 := TFont():New("Arial" ,,11,,.T.,,,,,.F.)
	oFont14n:= TFont():New("Arial" ,,15,,.F.,,,,,.F.)
	oFont15n:= TFont():New("Arial" ,,16,,.T.,,,,,.F.)
	oFont16 := TFont():New("Arial" ,,17,,.T.,,,,,.F.)
	oFont16n:= TFont():New("Arial" ,,17,,.T.,,,,,.F.)
	oFont24 := TFont():New("Arial" ,,25,,.T.,,,,,.F.)
//
	If !lBcoCorres
		cAgCC := LEFT(aDadosBanco[3],4)
		If !Empty(SA6->A6_DVAGE)
			cAgCC += "-"+SA6->A6_DVAGE
		EndIf
	Else
		If cBanco == "341"
			cAgCC := LEFT(aDadosBanco[3],4)
		Else
			cAgCC := LEFT(aDadosBanco[3],4)+"-"+SEE->EE_DGAGCOR
		EndIf
	EndIf

	If cBanco == "341"
		cConta := Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5]
	ElseIf cBanco == "033"
		cConta := SEE->EE_CODEMP //cBcoCon //StrZero(Val(aDadosBanco[4]),8)+"-"+aDadosBanco[5] //If(cBanco#"033","-"+aDadosBanco[5],"")
	Else
		cConta := StrZero(Val(aDadosBanco[4]),8)+"-"+aDadosBanco[5] //If(cBanco#"033","-"+aDadosBanco[5],"")
	EndIf

	oBoleto:StartPage()   // Inicia uma nova página
	oBoleto:Say(0094,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
	oBoleto:Say(0094,1860,"Comprovante de Entrega"					,oFont10)

	oBoleto:Line(0110,100,0110,2300)

	oBoleto:Say(0140,100 ,"Beneficiario"          					,oFont8)
	If !lBcoCorres
		oBoleto:Say(0180,100 ,aDadosEmp[1]        				,oFont8)
	Else
		oBoleto:Say(0180,100 ,SA6->A6_NOME        				,oFont10)
	EndIf
	oBoleto:Say(0140,1080,"Agência/Código do Beneficiario"			,oFont8)
	oBoleto:Say(0180,1080,cAgCC+"/"+cConta							,oFont10)
	oBoleto:Say(0140,1510,"Nro.Documento"         					,oFont8)
	oBoleto:Say(0180,1510,Transform(aDadosTit[1],"@R 999999999/999")	,oFont10) //Numero+Parcela

	oBoleto:Say(0230,100 ,"Pagador"               					,oFont8)
	oBoleto:Say(0270,100 ,aSacado[1]              					,oFont10)	//Nome
	oBoleto:Say(0230,1080,"Vencimento"            					,oFont8)
	oBoleto:Say(0270,1080,aDadosTit[4]								,oFont10)
	oBoleto:Say(0230,1510,"Valor do Documento"    					,oFont8)
	oBoleto:Say(0270,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oBoleto:Say(0365,0100,"Recebi(emos) o bloqueto/título"			,oFont10)
	oBoleto:Say(0405,0100,"com as características acima."             ,oFont10)

	oBoleto:Say(0320,1080,"Data"                                      ,oFont8)
	oBoleto:Say(0320,1410,"Assinatura"                                ,oFont8)

	oBoleto:Say(0410,1080,"Data"                                      ,oFont8)
	oBoleto:Say(0410,1410,"Entregador"                                ,oFont8)
//	Linhas
	oBoleto:Line(0200, 100,0200,1900 )
	oBoleto:Line(0290, 100,0290,1900 )
	oBoleto:Line(0375,1070,0375,1900 )
	oBoleto:Line(0465, 100,0465,2300 )
//	Colunas
	oBoleto:Line(0465,1070,0110,1070 )
	oBoleto:Line(0465,1400,0290,1400 )
	oBoleto:Line(0290,1500,0110,1500 )
	oBoleto:Line(0465,1900,0110,1900 )
//
	oBoleto:Say(0150,1910,"(  ) Mudou-se"                             ,oFont8)
	oBoleto:Say(0185,1910,"(  ) Ausente"                              ,oFont8)
	oBoleto:Say(0220,1910,"(  ) Não existe nº indicado"               ,oFont8)
	oBoleto:Say(0255,1910,"(  ) Recusado"                             ,oFont8)
	oBoleto:Say(0290,1910,"(  ) Não procurado"                        ,oFont8)
	oBoleto:Say(0325,1910,"(  ) Endereço insuficiente"                ,oFont8)
	oBoleto:Say(0360,1910,"(  ) Desconhecido"                         ,oFont8)
	oBoleto:Say(0395,1910,"(  ) Falecido"                             ,oFont8)
	oBoleto:Say(0430,1910,"(  ) Outros(anotar no verso)"              ,oFont8)
	//
	For i := 100 to 2300 step 50
		oBoleto:Line( 0490, i, 0490, i+30)
	Next i
	//
	// Inicia o Recido do Sacado
	If cBanco # "341"
		oBoleto:Line(0590,100,0590,2300)  // Linha 1
		oBoleto:Line(0590,550,0505, 550)  // Coluna 1
		oBoleto:Line(0590,800,0505, 800)  // Coluna 2 da linha 1

		If File(alltrim(aDadosBanco[1])+aBmp).And. aSacado[8] <> "1"
			oBoleto:SayBitmap( 0550,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
			//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
			Case Len(aDadosBanco[2]) < 17
				oBoleto:Say(0560,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
			Case Len(aDadosBanco[2]) < 19
				oBoleto:Say(0560,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
			OtherWise
				oBoleto:Say(0560,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
			EndCase
		Else
			//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
			Case Len(aDadosBanco[2]) < 13
				oBoleto:Say(0560,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
			Case Len(aDadosBanco[2]) < 17
				oBoleto:Say(0560,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
			OtherWise
				If Len(aDadosBanco[2]) > 25
					oBoleto:Say(0560,100,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco
				Else
					oBoleto:Say(0560,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
				EndIf
			EndCase
			// EndIf
		EndIf
		//
		oBoleto:Say(0580,565,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco
		oBoleto:Say(0560,820,CB_RN_NN[2],oFont14n)					// Linha Digitavel do Codigo de Barras   1934
		//
		oBoleto:Say(0620,100 ,"Local de Pagamento"                             					,oFont8)

		If cBanco == "341"
			oBoleto:Say(0630,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont9)
			oBoleto:Say(0660,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco
		ElseIf cBanco == "237"
			oBoleto:Say(0630,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso"        			,oFont9)
		Else
			oBoleto:Say(0630,400 ,"Pagável em qualquer Banco até o Vencimento."        		   		,oFont9)
			oBoleto:Say(0660,400 ,"Após o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+"."   ,oFont9) //Nome do banco
		EndIf
		//
		oBoleto:Say(0620,1910,"Vencimento"   ,oFont8)
		oBoleto:Say(0660,2010,aDadosTit[4]   ,oFont10)
		//
		If cBanco = "341"
			oBoleto:Say(0700,100 ,"Beneficiario"                         ,oFont8)
		Else
			oBoleto:Say(0700,100 ,"Cedente"                              ,oFont8)
		EndIf
		If !lBcoCorres
			If cBanco == "237"
				oBoleto:Say(0735,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC+"-"+Alltrim(aDadosEmp[2])+"-"+Alltrim(aDadosEmp[3])  	,oFont8) //Nome + CNPJ
			Else
				oBoleto:Say(0735,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC  		,oFont10) //Nome + CNPJ
			EndIf
		Else
			oBoleto:Say(0735,100 ,SA6->A6_NOME               				,oFont10) //Nome + CNPJ
		EndIf

		//oBoleto:Say(0850,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
		//
		oBoleto:Say(0700,1910,"Agência/Código Beneficiario"              ,oFont8)
		oBoleto:Say(0735,2010,cAgCC+"/"+cConta,oFont10)
		//
		oBoleto:Line(0670,100,0670,2300 )  // linha 2
		oBoleto:Line(0745,100,0745,2300 )
		oBoleto:Line(0815,100,0815,2300 )
		oBoleto:Line(0880,100,0880,2300 )
		//
		oBoleto:Say(0770,100 ,"Data do Documento"                        ,oFont8)
		oBoleto:Say(0805,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
		//
		oBoleto:Say(0770,505 ,"Nro.Documento"                                  ,oFont8)
		If cBanco == "001"
			oBoleto:Say(0805,605 ,Transform(aDadosTit[1],"@R 999999999/999")   ,oFont10) //Numero+Parcela
		Else
			oBoleto:Say(0805,605 ,Transform(aDadosTit[1],"@R 999999999/999")   ,oFont10) //Numero+Parcela
		EndIf
		//
		oBoleto:Say(0770,1005,"Espécie Doc."                                  ,oFont8)
		oBoleto:Say(0805,1050,aDadosTit[8]									,oFont10) //Tipo do Titulo
		//
		oBoleto:Say(0770,1355,"Aceite"                                        ,oFont8)
		oBoleto:Say(0805,1455,"N"                                             ,oFont10)
		//
		oBoleto:Say(0770,1555,"Data do Processamento"                    ,oFont8)
		oBoleto:Say(0805,1655,aDadosTit[3]                               ,oFont10) // Data impressao
		//
		nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
		nDacNN:= iif(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
		oBoleto:Say(0770,1910,"Nosso Número"                                   ,oFont8)
		If cBanco == "033"
			oBoleto:Say(0805,1970,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		ElseIf cBanco == "001"
			oBoleto:Say(0805,1970,cBcoCon+_cNossoNum	,oFont10) //+"-"+Alltrim( nDacNN
		ElseIf cBanco == "341"
			oBoleto:Say(0805,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 9999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
		Else
			If Len(Alltrim(aDadosTit[6])) < 10
				oBoleto:Say(0805,2000,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			ElseIf Len(Alltrim(aDadosTit[6])) > 12
				oBoleto:Say(0805,1970,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 999999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			Else
				oBoleto:Say(0805,1990,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			EndIf
		EndIf
		//
		oBoleto:Say(0840,100 ,"Uso do Banco"                                   ,oFont8)
		//
		oBoleto:Say(0840,505 ,"Carteira"                                       ,oFont8)
		oBoleto:Say(0870,555 ,If(cBanco=="033","RCR",aDadosBanco[7])           ,oFont10)
		//
		oBoleto:Say(0840,755 ,"Espécie"                                        ,oFont8)
		oBoleto:Say(0870,805 ,"R$"                                             ,oFont10)
		//
		oBoleto:Say(0840,1005,"Quantidade"                                     ,oFont8)
		oBoleto:Say(0840,1555,"Valor"                                          ,oFont8)
		//
		oBoleto:Say(0840,1910,"Valor do Documento"                          	,oFont8)
		oBoleto:Say(0870,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
		//
		If cBanco == "341"
			oBoleto:Say(0915,100 ,"Instrucoes de responsabilidade do beneficiário. qualquer dúvida sobre este boleto, contate o benefifiário.",ofont8)
		Else
			oBoleto:Say(0915,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		EndIf
		oBoleto:Say(1030,100 ,aBolText[1]                                        ,oFont10)
		//
		oBoleto:Say(0910,1910,"(-)Desconto/Abatimento"                         ,oFont8)
		oBoleto:Say(0980,1910,"(-)Outras Deduções"                             ,oFont8)
		oBoleto:Say(1050,1910,"(+)Mora/Multa"                                  ,oFont8)
		oBoleto:Say(1120,1910,"(+)Outros Acréscimos"                           ,oFont8)
		oBoleto:Say(1190,1910,"(=)Valor Cobrado"                               ,oFont8)
		//
		oBoleto:Say(1260,100 ,"Pagador"                                         ,oFont8)
		If cBanco == "001"
			oBoleto:Say(1280,400 ,aSacado[1]+" ("+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99")+")"             ,oFont10)
		Else
			oBoleto:Say(1280,400 ,aSacado[1]+" ("+aSacado[2]+")"             ,oFont10)
		EndIf
		oBoleto:Say(1333,400 ,aSacado[3]                                    ,oFont10)
		oBoleto:Say(1376,400 ,aSacado[6]+"    "+aSacado[4]+" - "+aSacado[5],oFont10) // CEP+Cidade+Estado
		if Len(Alltrim(aSacado[7])) == 14
			If cBanco == "001"
				//		oBoleto:Say(1410,1850 ,"C.N.P.J.: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
			Else
				oBoleto:Say(1419,400 ,"C.N.P.J.: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
			EndIf
		else
			oBoleto:Say(1419,400 ,"C.P.F.: "+TRANSFORM(aSacado[7],"@R 999.999.999-99"),oFont10) // CPF
		endif
		oBoleto:Say(1429,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
		//
		oBoleto:Say(1465,100 ,"Sacador/Avalista"                               ,oFont8)
		If lBcocorres
			oBoleto:Say(1495,400 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont8) //Nome + CNPJ
		EndIf
		oBoleto:Say(1500,1500,"Autenticação Mecânica -"                        ,oFont8)
		oBoleto:Say(1505,1850,"Recibo do Sacado"								,oFont10)
		//
		oBoleto:Line(0750,500,0880,500)  // colunas
		oBoleto:Line(0830,750,0880,750)
		oBoleto:Line(0750,1000,0880,1000)
		oBoleto:Line(0750,1350,0820,1350)
		oBoleto:Line(0750,1550,0880,1550)
		//
		oBoleto:Line(0950,1900,0950,2300 )  // linhas
		oBoleto:Line(1020,1900,1020,2300 )
		oBoleto:Line(1090,1900,1090,2300 )
		oBoleto:Line(1160,1900,1160,2300 )
		oBoleto:Line(1230,100 ,1230,2300 )
		oBoleto:Line(1470,100 ,1470,2300 )
		//
		oBoleto:Line(0590,1900,1230,1900 )  //Coluna grande
		//
		For i := 100 to 2300 step 50
			oBoleto:Line( 1725, i, 1725, i+30)                 // 1850
		Next i
		//
		oBoleto:Line(1830,100,1830,2300)                                                       //   2000
		oBoleto:Line(1830,550,1750, 550)                                                       //   2000 - 1900
		oBoleto:Line(1830,800,1750, 800)                                                       //   2000 - 1900

	Else // Recibo do Itau

		oBoleto:Line(0610,100,0610,2300)
		oBoleto:Line(0610,550,0510, 550)
		oBoleto:Line(0610,800,0510, 800)

		// LOGOTIPO
		If File(alltrim(aDadosBanco[1])+aBmp).And. aSacado[8] <> "1"
			oBoleto:SayBitmap( 5600,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
			//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
			Case Len(aDadosBanco[2]) < 17
				oBoleto:Say(0580,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
			Case Len(aDadosBanco[2]) < 19
				oBoleto:Say(0580,240,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
			OtherWise
				oBoleto:Say(0580,240,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
			EndCase
		Else
			//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
			Case Len(aDadosBanco[2]) < 13
				oBoleto:Say(0580,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
			Case Len(aDadosBanco[2]) < 17
				oBoleto:Say(0580,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
			OtherWise
				If Len(aDadosBanco[2]) > 25
					oBoleto:Say(0580,100,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco
				Else
					oBoleto:Say(0580,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
				EndIf
			EndCase
		EndIf

		//
		oBoleto:Say(0600,560,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco
		oBoleto:Say(0580,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
		//
		oBoleto:Line(0700,100,0700,2300 )	//Linha 2
		oBoleto:Line(0770,100,0770,2300 )
		oBoleto:Line(0840,100,0840,2300 )
		oBoleto:Line(0910,100,0910,2300 )
		oBoleto:Line(0980,100,0980,2300 )
		//
		oBoleto:Line(0700,1370,0770,1370)
		oBoleto:Line(0700,1900,0930,1900)
		//
		oBoleto:Line(0840, 500,0980,500 )
		oBoleto:Line(0910, 750,0980,750 )
		oBoleto:Line(0840,1000,0980,1000)
		oBoleto:Line(0840,1350,0910,1350)
		oBoleto:Line(0840,1550,0980,1550)
		oBoleto:Line(0840,1900,0980,1900)
		//
		oBoleto:Say(0640,100 ,"Local de Pagamento"                             					,oFont8)

		oBoleto:Say(0660,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont10)
		oBoleto:Say(0690,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont10) //Nome do Banco
		//
		oBoleto:Say(0640,1910,"Vencimento"                                     ,oFont8)
		oBoleto:Say(0680,2010,aDadosTit[4]                               ,oFont10)
		//
		oBoleto:Say(0730,100  ,"Beneficiario"                                        ,oFont8)
		oBoleto:Say(0735,1100 ,"CNPJ"                                        ,oFont8)
		If !lBcoCorres
			oBoleto:Say(0765,100 ,aDadosEmp[1]  	,oFont8) //Nome + CNPJ
			oBoleto:Say(0765,1105 ,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")  	,oFont8) //Nome + CNPJ
		Else
			oBoleto:Say(0765,100 ,SA6->A6_NOME                   	,oFont10) //Nome + CNPJ
		EndIf

		oBoleto:Say(0730,1375 ,"Sacador/Avalista"                                        ,oFont8)

		oBoleto:Say(0730,1910,"Agência/Código Beneficiario"                         ,oFont8)
		oBoleto:Say(0765,2010,cAgCC+"/"+cConta,oFont10)
		//

		oBoleto:Say(0800,100 ,"Endereço Beneficiario"                              ,oFont8)
		cEndBene := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_BAIRCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+Alltrim(SM0->M0_ESTCOB)
		oBoleto:Say(0830,100 ,cEndBene                             ,oFont10)

		oBoleto:Say(0870,100 ,"Data do Documento"                              ,oFont8)
		oBoleto:Say(0900,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
		//
		oBoleto:Say(0870,505 ,"Nro.Documento"                                  ,oFont8)
		oBoleto:Say(0900,605 ,Transform(aDadosTit[1],"@R 999999999/999")         ,oFont10) //Numero+Parcela

		//
		oBoleto:Say(0870,1005,"Espécie Doc."                                   ,oFont8)
		oBoleto:Say(0900,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
		//
		oBoleto:Say(0870,1355,"Aceite"                                         ,oFont8)
		oBoleto:Say(0900,1455,"N"                                             ,oFont10)
		//
		oBoleto:Say(0870,1555,"Data do Processamento"                          ,oFont8)
		oBoleto:Say(0900,1655,aDadosTit[3]                                     ,oFont10) // Data impressao
		//
		nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
		nDacNN:= iif(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
		oBoleto:Say(0870,1910,"Nosso Número"                                   ,oFont8)
		oBoleto:Say(0900,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 9999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
		//
		oBoleto:Say(0940,100 ,"Uso do Banco"                                   ,oFont8)
		//
		oBoleto:Say(0940,505 ,"Carteira"                                       ,oFont8)
		oBoleto:Say(0970,555 ,aDadosBanco[7]                       	,oFont10)
		//
		oBoleto:Say(0940,755 ,"Espécie"                                        ,oFont8)
		oBoleto:Say(0970,805 ,"R$"                                             ,oFont10)
		//
		oBoleto:Say(0940,1005,"Quantidade"                                     ,oFont8)
		oBoleto:Say(0940,1555,"Valor"                                          ,oFont8)
		//
		oBoleto:Say(0940,1910,"Valor do Documento"                          	,oFont8)
		oBoleto:Say(0970,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
		//

		oBoleto:Say(1035,1450,"Autenticação Mecânica -"                        ,oFont8)
		oBoleto:Say(1500,1850,"Recibo do Pagador"								,oFont10)
		//
		//oBoleto:Line(1120,1900,1120,2300 )
		oBoleto:Line(1000,1200,1000,2100 )
		oBoleto:Line(1000,1200,1030,1200 )
		oBoleto:Line(1000,2100,1030,2100 )

		For i := 100 to 2300 step 40
			oBoleto:Line( 1730, i, 1730, i+30)                 // 1850
		Next i
		//
		//oBoleto:Line(1790,100,1790,2300)                                                       //   2000
		//oBoleto:Line(1790,550,1690, 550)                                                       //   2000 - 1900
		//oBoleto:Line(1790,800,1690, 800)                                                       //    2000 - 1900

		oBoleto:Line(1830,100,1830,2300)                                                       //   2000
		oBoleto:Line(1830,550,1750, 550)                                                       //   2000 - 1900
		oBoleto:Line(1830,800,1750, 800)

	EndIf
	//
	//Ficha de compensacao
	// LOGOTIPO
	If File(alltrim(aDadosBanco[1])+aBmp).And. aSacado[8] <> "1"
		oBoleto:SayBitmap( 1910,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
		//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
		Do Case
		Case Len(aDadosBanco[2]) < 17
			oBoleto:Say(1810,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
		Case Len(aDadosBanco[2]) < 19
			oBoleto:Say(1810,240,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
		OtherWise
			oBoleto:Say(1810,240,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
		EndCase
	Else
		//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
		Do Case
		Case Len(aDadosBanco[2]) < 13
			oBoleto:Say(1810,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
		Case Len(aDadosBanco[2]) < 17
			oBoleto:Say(1810,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco                     1934
		OtherWise
			If Len(aDadosBanco[2]) > 25
				oBoleto:Say(1810,100,Subs(aDadosBanco[2],1,25),oFont9 ) 		// [2]Nome do Banco                     1934
			Else
				oBoleto:Say(1810,100,aDadosBanco[2],oFont9 ) 					// [2]Nome do Banco                     1934
			EndIf
		EndCase
	EndIf
	//EndIf
	//
	oBoleto:Say(1820,565,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco                       1912
	oBoleto:Say(1810,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
	//
	oBoleto:Line(1920,100,1920,2300 )
	oBoleto:Line(2000,100,2000,2300 )
	oBoleto:Line(2070,100,2070,2300 )  // 4ª linha
	oBoleto:Line(2140,100,2140,2300 )
	//
	oBoleto:Line(2000, 500,2140,500)
	oBoleto:Line(2070, 750,2140,750)
	oBoleto:Line(2000,1000,2140,1000)
	oBoleto:Line(2000,1350,2070,1350)
	oBoleto:Line(2000,1550,2140,1550)
	//
	oBoleto:Say(1860,100 ,"Local de Pagamento"                             				,oFont8)
	If cBanco = "341"
		oBoleto:Say(1865,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont9)
		oBoleto:Say(1900,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco

	ElseIf cBanco = "237"
		oBoleto:Say(1865,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso"        			,oFont9)

	Else
		oBoleto:Say(1865,400 ,"Pagável em qualquer Banco até o Vencimento."        			,oFont9)
		oBoleto:Say(1900,400 ,"Após o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco
	EndIf
	//
	oBoleto:Say(1860,1910,"Vencimento"                                     ,oFont8)
	oBoleto:Say(1900,2010,aDadosTit[4]                               ,oFont10)
	//
	oBoleto:Say(1945,100 ,"Beneficiario"                                        ,oFont8)
	If !lBcoCorres
		If cBanco == "237"
			oBoleto:Say(1985,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC+"-"+Alltrim(aDadosEmp[2])+"-"+Alltrim(aDadosEmp[3])  	,oFont8) //Nome + CNPJ
		Else
			oBoleto:Say(1985,100 ,aDadosEmp[1]+"- "+SM0->M0_CGC        	,oFont10) //Nome + CNPJ
		EndIf
	Else
		oBoleto:Say(1985,100 ,SA6->A6_NOME               	,oFont10) //Nome + CNPJ
	EndIf
	//
	oBoleto:Say(1945,1905,"Agência/Código do Beneficiario"                         ,oFont8)
	oBoleto:Say(1985,2005,cAgCC+"/"+cConta,oFont10)
	//
	oBoleto:Say(2030,100 ,"Data do Documento"                              ,oFont8)
	oBoleto:Say(2060,100 ,aDadosTit[2]                               	   ,oFont10) // Emissao do Titulo (E1_EMISSAO)
	//
	oBoleto:Say(2030,505 ,"Nro.Documento"                                  ,oFont8)
	If cBanco == "001"
		oBoleto:Say(2060,605 , Transform(aDadosTit[1],"@R 999999999/999") 		,oFont10) // Numero+Parcela _cNossoNum
	Else
		oBoleto:Say(2060,605 ,Transform(aDadosTit[1],"@R 999999999/999")		,oFont10) // Numero+Parcela
	EndIf
	//
	oBoleto:Say(2030,1005,"Espécie Doc."                                   ,oFont8)
	oBoleto:Say(2060,1050,aDadosTit[8]										,oFont10) // Tipo do Titulo
	//
	oBoleto:Say(2030,1355,"Aceite"                                         ,oFont8)  // 2200
	oBoleto:Say(2060,1455,"N"                                             ,oFont10)  // 2230
	//
	oBoleto:Say(2030,1555,"Data do Processamento"                          ,oFont8)       // 2200
	oBoleto:Say(2060,1655,aDadosTit[3]                                     ,oFont10) // Data impressao  2230
	//
	oBoleto:Say(2030,1910,"Nosso Número"                                   ,oFont8)       // 2200
	If cBanco == "033"
		//oBoleto:Say(2310,2000,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		oBoleto:Say(2060,1970,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
	ElseIf cBanco == "001"
		oBoleto:Say(2060,1970,cBcoCon+_cNossoNum	,oFont10) //+"-"+Alltrim( nDacNN
	ElseIf cBanco == "341"
		oBoleto:Say(2060,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 9999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
	Else
		If Len(Alltrim(aDadosTit[6])) < 10
			oBoleto:Say(2060,2000,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999-X") ,oFont10)  // 2230 +aDadosTit[6]+"-"+Alltrim( nDacNN )
		ElseIf Len(Alltrim(aDadosTit[6])) > 12
			oBoleto:Say(2060,1970,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 999999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		Else
			oBoleto:Say(2060,1990,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999999-X") ,oFont10)  // 2230 +aDadosTit[6]+"-"+Alltrim( nDacNN )
		EndIf
	EndIf
	//
	oBoleto:Say(2100,100 ,"Uso do Banco"                                   ,oFont8)       // 2270
	//
	oBoleto:Say(2100,505 ,"Carteira"                                       ,oFont8)       // 2270
	oBoleto:Say(2130,555 ,If(cBanco=="033","RCR",aDadosBanco[7])         	,oFont10)      //  2300
	//
	oBoleto:Say(2100,755 ,"Espécie"                                        ,oFont8)       //  2270
	oBoleto:Say(2130,805 ,"R$"                                             ,oFont10)      //  2300
	//
	oBoleto:Say(2100,1005,"Quantidade"                                     ,oFont8)       //  2270
	oBoleto:Say(2100,1555,"Valor"                                          ,oFont8)       //  2270
	//
	oBoleto:Say(2100,1910,"Valor do Documento"                          	,oFont8)        //  2270
	oBoleto:Say(2130,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300
	//
	If cBanco == "341"
		oBoleto:Say(2170,100 ,"INSTRUÇÕES DE RESPONSABILIDADE DO BENEFICIÁRIO. QUALQUER DÚVIDA SOBRE ESTE BOLETO, CONTATE O BENEFICIÁRIO.",ofont8)
	Else
		oBoleto:Say(2170,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8) // 2340
	EndIf

	oBoleto:Say(2300,100 ,aBolText[1]                                        ,oFont10)
	//oBoleto:Say(2570,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)  // 2490  // *0.05)/30)
	//oBoleto:Say(2620,100 ,aBolText[3]                                        ,oFont10)    //2540
	//
	oBoleto:Say(2165,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
	oBoleto:Say(2235,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
	oBoleto:Say(2305,1910,"(+)/Multa"                                  ,oFont8)      //  2480
	oBoleto:Say(2375,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
	oBoleto:Say(2445,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620
	//
	oBoleto:Say(2520,100 ,"Pagador"                                         ,oFont8)
	If cBanco == "001"
		oBoleto:Say(2530,400 ,aSacado[1]+" ("+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99")+")"             ,oFont10)
	Else
		oBoleto:Say(2530,400 ,aSacado[1]+" ("+aSacado[2]+")"             ,oFont10)
	EndIf
	oBoleto:Say(2573,400 ,aSacado[3]                                    ,oFont10)       // 2773
	oBoleto:Say(2610,400 ,aSacado[6]+"    "+aSacado[4]+" - "+aSacado[5],oFont10) // CEP+Cidade+Estado  2826
	IF LEN(Alltrim(aSacado[7])) == 14
		If cBanco == "001"
			//		oBoleto:Say(2790,1850 ,"C.N.P.J.: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
		Else
			oBoleto:Say(2649,400 ,"C.N.P.J.: "+TRANSFORM(aSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
		EndIf
	ELSE
		oBoleto:Say(2649,400 ,"C.P.F.: "+TRANSFORM(aSacado[7],"@R 999.999.999-99"),oFont10) // CPF        2879
	ENDIF
	//oBoleto:Say(2939,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)         //  2879
	//
	oBoleto:Say(2685,100 ,"Sacador/Avalista"                               ,oFont8)
	oBoleto:Say(2685,1355,"CNPJ"                               ,oFont8)
	If lBcocorres
		oBoleto:Say(2695,400 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont8) //Nome + CNPJ
	EndIf

	oBoleto:Say(2725,1500,"Autenticação Mecânica -"                        ,oFont8)
	oBoleto:Say(2725,1850,"Ficha de Compensação"                           ,oFont10)      // 2935 + 280      = 3215
	//
	oBoleto:Line(2210,1900,2210,2300 )
	oBoleto:Line(2280,1900,2280,2300 )
	oBoleto:Line(2350,1900,2350,2300 )
	oBoleto:Line(2420,1900,2420,2300 )
	//
	oBoleto:Line(2490,100 ,2490 ,2300 )  // penultima linha
	//
	oBoleto:Line(1835,1900,2490,1900 )   //coluna grande direita
	//
	oBoleto:Line(2695,100 ,2695,2300 )   // ultima linha
	//
	If cBanco # "341"
		MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oBoleto,.F.,,,nCBLargura,nCBAltura,,,,.F.)
	EndIf
	MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oBoleto,.F.,,,nCBLargura,nCBAltura,,,,.F.)
	//
	oBoleto:EndPage() // Finaliza a página

Return Nil
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
	±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	Local L,D,P := 0
	Local B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
	±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
	Local L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ DACNN       ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
	±±³          ³             ³         ³to Verificador no Modulo 11 para NN.³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DACNN(cData)
	Local L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		End
		L := L - 1
	End

	Do Case
	Case mod(D,11) == 1  // Se o Resto for 1 a subtracao sera 11 - 1 e resultara 10 - despresa-se o 0 e para 1 sempre considera P como DAC
		D := "P"
	Case mod(D,11) == 0  // Se o Resto for 0 nao efetua subtracao e atribui 0 ao DAC
		D := 0
	OtherWise   // Para as demais situacoes efetua a subtracao normalmente
		D := 11 - (mod(D,11))
	EndCase

Return(D)
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
	±±³          ³             ³         ³gerando o codigo de barras.         ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto, cCarteira)
//
	Local bldocnufinal := cNroDoc//strzero(val(cNroDoc),8)
	Local blvalorfinal := iif(TamSx3("E1_SALDO")[2] == 2, strzero((nValor*100),10), strzero(int(nValor*100),10) )
	Local dvnn         := 0
	Local dvcb         := 0
	Local dv           := 0
	Local NN           := ''
	Local RN           := ''
	Local CB           := ''
	Local s            := ''
	Local _cfator      := strzero(dVencto - ctod("07/10/97"),4)

	If Substr(cBanco,1,3)  == "237"

		//
		//-------- Definicao do NOSSO NUMERO
		NN	 := bldocnufinal
		s    := cCarteira + bldocnufinal
		dvnn := DACNN(s)// digito verifacador Carteira + Nosso Num
		DACNN:= AllTrim(iif(ValType(dvnn) == "N",Str(dvnn),dvnn))
		//
		//	-------- Definicao do CODIGO DE BARRAS
		s    := cBanco + _cfator + blvalorfinal + SubS(cAgencia,1,4) + cCarteira + Substr(NN,1,11) + StrZero(Val(cConta),7) + "0"
		dvcb := modulo11(s)
		CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
		//
		//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
		//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		//
		// 	CAMPO 1:
		//	AAA	= Codigo do ban-co na Camara de Compensacao
		//	  B = Codigo da moeda, sempre 9
		//	CCC = Codigo da Carteira de Cobranca
		//	 DD = Dois primeiros digitos no nosso numero
		//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := cBanco + SubS(cAgencia,1,4) + SubS(cCarteira,1,1)
		dv   := modulo10(s)
		RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 2:
		//	DDDDDD = Restante do Nosso Numero
		//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		//	   FFF = Tres primeiros numeros que identificam a agencia
		//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := SubStr(cCarteira, 2, 1) + SubStr(NN,1,4) + SubStr(NN, 5, 5)
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 3:
		//	     F = Restante do numero que identifica a agencia
		//	GGGGGG = Numero da Conta + DAC da mesma
		//	   HHH = Zeros (Nao utilizado)
		//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		s    := SubStr(NN, 10, 2) + StrZero(Val(cConta),7) + "0"
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 4:
		//	     K = DAC do Codigo de Barras
		RN   := RN + AllTrim(Str(dvcb)) + '  '
		//
		// 	CAMPO 5:
		//	      UUUU = Fator de Vencimento
		//	VVVVVVVVVV = Valor do Titulo
		RN   := RN + _cfator + blvalorfinal
		//
	ElseIf Substr(cBanco,1,3)  == "033"

		//
		//-------- Definicao do NOSSO NUMERO
		NN	 := bldocnufinal
		s    := cCarteira + bldocnufinal
		dvnn := DACNN(s)// digito verifacador Carteira + Nosso Num
		DACNN:= AllTrim(iif(ValType(dvnn) == "N",Str(dvnn),dvnn))
		//
		//	-------- Definicao do CODIGO DE BARRAS
		s    := cBanco + _cfator + blvalorfinal + "9" + cBcoCon +  Substr(NN,1,13) + "0" + cCarteira
		dvcb := modulo11(s)
		CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
		//
		//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
		//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		//
		// 	CAMPO 1:
		//	AAA	= Codigo do ban-co na Camara de Compensacao
		//	  B = Codigo da moeda, sempre 9
		//	CCC = Codigo da Carteira de Cobranca
		//	 DD = Dois primeiros digitos no nosso numero
		//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := cBanco + "9" + SubS(cBcoCon,1,4)
		dv   := modulo10(s)
		RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 2:
		//	DDDDDD = Restante do Nosso Numero
		//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		//	   FFF = Tres primeiros numeros que identificam a agencia
		//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := SubS(cBcoCon,5,3) + SubStr(NN,1,7)
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 3:
		//	     F = Restante do numero que identifica a agencia
		//	GGGGGG = Numero da Conta + DAC da mesma
		//	   HHH = Zeros (Nao utilizado)
		//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		s    := SubStr(NN, 8, 6) + "0"+cCarteira
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 4:
		//	     K = DAC do Codigo de Barras
		RN   := RN + AllTrim(Str(dvcb)) + '  '
		//
		// 	CAMPO 5:
		//	      UUUU = Fator de Vencimento
		//	VVVVVVVVVV = Valor do Titulo
		RN   := RN + _cfator + blvalorfinal
		//


	ElseIf Substr(cBanco,1,3) == "341"

		//
		//-------- Definicao do NOSSO NUMERO
		If cCarteira # "112"
			s    :=  cAgencia + Alltrim(cConta) + cCarteira + Substr(bldocnufinal,1,8)
			dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
		Else
			s    :=  cAgencia + Alltrim(cConta) + cCarteira + Substr(bldocnufinal,1,8)
			s1   := cCarteira + Substr(bldocnufinal,1,8)
			dvnn := modulo10(s1) // digito verifacador Agencia + Conta + Carteira + Nosso Num
		EndIf

		NN   := cNroDoc //cCarteira + bldocnufinal + '-' + AllTrim(Str(dvnn))

		//
		//	-------- Definicao do CODIGO DE BARRAS
		//      4      		4     	10      		3		   8   				 1	   				4   		 5         1      3
		s    := cBanco + _cfator + blvalorfinal + cCarteira + Substr(bldocnufinal,1,8) + AllTrim(Str(dvnn)) + cAgencia + AllTrim(cConta) + cDacCC + '000'
		dvcb := modulo11(s)
		CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
		//
		//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
		//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		//
		// 	CAMPO 1:
		//	AAA	= Codigo do banco na Camara de Compensacao
		//	  B = Codigo da moeda, sempre 9
		//	CCC = Codigo da Carteira de Cobranca
		//	 DD = Dois primeiros digitos no nosso numero
		//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := cBanco + cCarteira + SubStr(bldocnufinal,1,2)
		dv   := modulo10(s)
		RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 2:
		//	DDDDDD = Restante do Nosso Numero
		//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		//	   FFF = Tres primeiros numeros que identificam a agencia
		//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 3:
		//	     F = Restante do numero que identifica a agencia
		//	GGGGGG = Numero da Conta + DAC da mesma
		//	   HHH = Zeros (Nao utilizado)
		//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		s    := SubStr(cAgencia, 4, 1) + Alltrim(cConta) + cDacCC + '000'
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 4:
		//	     K = DAC do Codigo de Barras
		RN   := RN + AllTrim(Str(dvcb)) + '  '
		//
		// 	CAMPO 5:
		//	      UUUU = Fator de Vencimento
		//	VVVVVVVVVV = Valor do Titulo
		RN   := RN + _cfator + blvalorfinal //StrZero(Int(nValor * 100),14-Len(_cfator))

	Else

		cCampoL := "9"+cBcoCon+cNroDoc+"0"+cCarteira

		cMoeda := "9"
		// ALERT(cCampoL)

		//Fator de Vencimento + Valor do titulo
		nFator := (cTrb)->E1_VENCTO - CtoD("07/10/1997")
		cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

		cLivre := cBanco+cMoeda+cFatorValor+cCampoL

		// campo do codigo de barra
		cDigBarra := CALC_DB( cLivre )
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

		// composicao da linha digitavel
		cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
		cDig1    := DIGITO( cParte1 )
		cParte2  := Substr(cBarra,25,10)
		cDig2    := DIGITO( cParte2 )
		cParte3  := Substr(cBarra,35,10)
		cDig3    := DIGITO( cParte3 )
		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
			Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
			Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
			cParte4+" "+cParte5

		CB := cBarra
		RN := cDigital
		NN := cNroDoc
		//	Aadd(aRet,cBarra)
		//	Aadd(aRet,cDigital)
		//	Aadd(aRet,cNroDoc)

	EndIf

Return({CB,RN,NN})

Static Function ArrumaAno(_dDataValida)

	Local _cDataAno := year(_dDataValida)
	Local _cDataDia := Day(_dDataValida)
	Local _cDataMes := Month(_dDataValida)
	if len(CVALTOCHAR(_cDataMes)) == 1
		_cDataMes := "0"+CVALTOCHAR(_cDataMes)
	else
		_cDataMes := CVALTOCHAR(_cDataMes)
	endif

	if len(CVALTOCHAR(_cDataDia)) == 1
		_cDataDia := "0"+CVALTOCHAR(_cDataDia)
	else
		_cDataDia := CVALTOCHAR(_cDataDia)
	endif

	if len(CVALTOCHAR(_cDataAno)) == 2
		_cDataAno := "20"+CVALTOCHAR(_cDataAno)
	else
		_cDataAno := CVALTOCHAR(_cDataAno)
	endif
	_dDataValida := _cDataDia+"/"+_cDataMes+"/"+_cDataAno

return _dDataValida


Static Function NumIta()
	Local cNum := see->ee_faxatu
	Local cNosso

	cNum := StrZero(Val(cNum)+1,7)    // see->ee_faxatu,1,8))+1,8)
	cNosso := AllTrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+SEE->EE_CODCART+cNum
	cDig := Str(Modulo10( cNosso ),1)
	cNum += cDig

	//SE1->(RecLock("SE1",.F.))
	//SE1->E1_NUMBCO := Substr(cNum,1,8)
	//SE1->(MsUnlock())

	see->(RecLock("SEE",.F.))
	see->ee_faxatu := StrZero(Val(Substr(cNum,1,7)),8)
	see->(MsUnlock())

Return cNum


Static Function NumSafr()
	Local cNum := StrZero(Val(Substr(see->ee_faxatu,1,8))+1,8)
	Local cDig := Str(Modulo11( cNum ),1)

	cNum += cDig

	see->(RecLock("SEE",.F.))
	see->ee_faxatu := Substr(cNum,1,8)
	see->(MsUnlock())

Return cNum


Static Function NumSan()

	Local cNroDoc := Replicate("0",12)
	Local cDig

	cNroDoc := "0"+ StrZero(Val((cTrb)->E1_NUM),9)+StrZero(Val((cTrb)->E1_PARCELA),2)
	cDig    := Modulo11(cNroDoc)
	cNroDoc := cNroDoc + Alltrim(Str(cDig))

	//se1->(RecLock("SE1",.F.))
	//se1->e1_numbco := cNroDoc
	//se1->(MsUnlock())
	//cNroDoc  := Right(Alltrim((cTrb)->e1_numbco),13)

Return cNroDoc


Static Function CALC_DB(cVariavel)
	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	base   := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		If base >= 10
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base + 1
		iDig   := iDig-1
	EndDo
	auxi := mod(sumdig,11)
	If auxi == 0 .or. auxi == 1 .or. auxi >= 10
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf

Return(str(auxi,1,0))


Static Function DIGITO(cVariavel)

	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	umdois := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		auxi   := Val(SubStr(cBase, idig, 1)) * umdois
		sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
		umdois := 3 - umdois
		iDig:=iDig-1
	EndDo
	cResultDiv := sumdig / 10
	cRestoDiv  := sumdig - (INT(cResultDiv)*10)

	if cRestoDiv = 0
		auxi := 0
	else
		auxi := 10 - cRestoDiv
	EndIf

Return(str(auxi,1,0))

Static Function Conta(_cBanco,_cConta)
	Local _cRet := ""
	If _cBanco $ "479/389"
		_cRet := AllTrim(SEE->EE_CODEMP)
	ElseIf _cBanco == "341"
		_cRet := StrZero(Val(SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)),5)
	Else
		_cRet := StrTran(_cConta,"-","")
		_cRet := SubStr(AllTrim(_cRet),1,Len(AllTrim(_cRet))-1)
	Endif
Return(_cRet)


Static Function Ret_Bar001(cBanco,cNosso,nValor,cCart,cMoeda,cBcoCon)

	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra		:= ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local aRet			:= {}

// campo livre
	cCampoL := Replicate("0",6)+cBcoCon+cNosso+Alltrim(cCart)

//Fator de Vencimento + Valor do titulo
	nFator := StoD((cTrb)->E1_VENCREA) - CtoD("07/10/1997")
	cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

	cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
	cDigBarra := CALC_DB( cLivre )
	cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

// composicao da linha digitavel
	cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
	cDig1    := DIGITO( cParte1 )
	cParte2  := Substr(cBarra,25,10)
	cDig2    := DIGITO( cParte2 )
	cParte3  := Substr(cBarra,35,10)
	cDig3    := DIGITO( cParte3 )
	cParte4  := cDigBarra
	cParte5  := cFatorValor

	cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
		Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
		Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
		cParte4+" "+cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

Static Function Ret_Bar422(cBanco,cNosso,nValor,cCart,cMoeda,cBcoCon,cTpCob)

	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra		:= ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local aRet			:= {}

// campo livre
	cCampoL := "7"+cBcoCon+cNosso+Alltrim(cTpCob)

//Fator de Vencimento + Valor do titulo
	nFator := StoD((cTrb)->E1_VENCREA) - CtoD("07/10/1997")
	cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

	cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
	cDigBarra := CALC_DB( cLivre )
	cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

// composicao da linha digitavel
	cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
	cDig1    := DIGITO( cParte1 )
	cParte2  := Substr(cBarra,25,10)
	cDig2    := DIGITO( cParte2 )
	cParte3  := Substr(cBarra,35,10)
	cDig3    := DIGITO( cParte3 )
	cParte4  := cDigBarra
	cParte5  := cFatorValor

	cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
		Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
		Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
		cParte4+" "+cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet


static function verPasta(cPasta)
	Local lRet := .t.
	Local nI   := 0
	Local cParte := ""

	for nI := 1 to len(cPasta)
		if substr(cPasta,nI,1) == "\" .and. nI > 1
			if !ExistDir(cParte)
				if MakeDir(cParte) != 0
					lRet := .f.
					conout( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
					If lMostra
						msginfo("Não foi possível criar o diretório. Erro: " + cValToChar( FError() ),"Advertência")
					EndIf
				endif
			endif
		endif
		cParte += substr(cPasta,nI,1)
	next

return(lRet)

Static Function	envBolMail(aEnvEmail, aEnvDupl, lClient, cPasta, cPastaSrv, lMostra)
	Local cProbmail := getNewPar("MV_XEMABOL","financeiro@hgrextrusoras.com.br")
	Local cEmailCc  := cProbmail
	Local cAssinatu := getNewPar("MV_XASSBOL","assinaaline.png")	//O arquivo assinatura deve estar na pasta system
	Local cEmailTo  := ""
	Local cAssunto  := "Emissão de Boletos"
	Local cMensagem := ""
	Local cCompl	:= ""
	Local aAnexos	:= {}
	Local nI 		:= 0
	Local nIx		:= 0
	Local cError	:= ""
	Local lError	:= .f.
	Local cHora		:= time()
	Local cCumprime := ""

	if substr(cHora,1,2) >= "18"
		cCumprime := "Boa Noite!"
	elseif substr(cHora,1,2) >= "12"
		cCumprime := "Boa Tarde!"
	elseif substr(cHora,1,2) < "12"
		cCumprime := "Bom Dia!"
	endif

	//CpyT2S( cPasta+cAssinatu, cPastaSrv,.f./*lCompress*/,/*lChangeCase*/)
	//__CopyFile(cPasta+cAssinatu, cPastaSrv+cAssinatu)

	ProcRegua(len(aEnvEmail))
	for nI := 1 to len(aEnvEmail)

		IncProc()
		cError := ""
		lError := .f.
		cCompl := ""
		cEmailCc:= cProbmail
		aAnexos := {cPastaSrv+aEnvEmail[nI,NOMPDF]+".pdf"}

		if lClient
			//__CopyFile(cNomPdf, cPastaSrv+aEnvEmail[nI,NOMPDF]+".pdf")
			//lError := !file(cPastaSrv+aEnvEmail[nI,NOMPDF]+".pdf")
			lError := !CpyT2S( cPasta+aEnvEmail[nI,NOMPDF]+".pdf", cPastaSrv,.f./*lCompress*/,/*lChangeCase*/)
			if lError
				cEmailTo  := cProbmail
				cEmailCc  := ""
				cMensagem := "Não foi possível copiar o Arquivo "+cPasta+aEnvEmail[nI,NOMPDF]+".pdf referente ao(s) Boleto(s) do Cliente "+aEnvEmail[nI,CODCLI]+"/"+aEnvEmail[nI,LOJA]+" para o servidor. Email não encaminhado!"
				cMensagem += '<center>'
				cMensagem += '<img src="cid:'+cAssinatu+'" width="200" height="150" alt="">'
				cMensagem += '</center>'
				If lMostra
					msginfo(cMensagem,"Advertência")
				EndIf
				aAnexos := {}
			endif
		endif

		if !lError
			if empty(aEnvEmail[nI,EMAIL])  //Se tem email ou não
				cEmailTo  := cProbmail
				cEmailCc  := ""
				cMensagem := "O cliente "+aEnvEmail[nI,CODCLI]+"/"+aEnvEmail[nI,LOJA]+" não possui email cadastrado. Email não encaminhado!"
				cMensagem += '<center>'
				cMensagem += '<img src="cid:'+cAssinatu+'" width="200" height="150" alt="">'
				cMensagem += '</center>'
				If lMostra
					msginfo(cMensagem,"Advertência")
				EndIf
			else
				for nIx := 1 to len(aEnvDupl)
					if aEnvDupl[nIx,CODCLI]+aEnvDupl[nIx,LOJA] == aEnvEmail[nI,CODCLI]+aEnvEmail[nI,LOJA]
						cCompl += aEnvDupl[nIx,3]+","
					endif
				next
				cCompl := Left(cCompl,Len(cCompl)-1)

				cEmailTo := aEnvEmail[nI,EMAIL]
				cMensagem := '<html>'
				cMensagem += '<body>'
				cMensagem += '<p>Senhores, '+cCumprime+'</p>'
				cMensagem += '<p>Segue em anexo o(s) boleto(s) referente(s) a(s) Nossa(s) Nota(s) Fiscai(s): '+cCompl+'.</p>'
				cMensagem += '<p>Favor confirmar o recebimento.</p>'
				cMensagem += '<p>Em caso de dúvidas entrar em contato com financeiro@hgrextrusoras.com.br.</p>'
				cMensagem += '<p>Att.</p>'
				cMensagem += '<center>'
				cMensagem += '<img src="cid:'+cAssinatu+'" width="200" height="150" alt="">'
				cMensagem += '</center>'
				cMensagem += '</body>'
				cMensagem += '</html>'
			endif
		endif

		if !u_envMail(cEmailTo ,cEmailCc ,cAssunto ,cMensagem ,aAnexos , cAssinatu, @cError, .f.)
			cEmailTo := cProbmail
			cEmailCc := ""
			cMensagem := '<html>'
			cMensagem += '<body>'
			cMensagem += '<p>'+cCumprime+'</p>'
			cMensagem += '<p>Não conseguiu enviar o Boleto do cliente '+aEnvEmail[nI,CODCLI]+'/'+aEnvEmail[nI,LOJA]+' para o email '+cEmailTo+'.</p>'
			cMensagem += '<p>Erro: '+cError+'</p>'
			cMensagem += '<p>Favor Verificar</p>'
			cMensagem += '<center>'
			cMensagem += '<img src="cid:'+cAssinatu+'" width="200" height="150" alt="">'
			cMensagem += '</center>'
			cMensagem += '</body>'
			cMensagem += '</html>'
			If lMostra
				msginfo(cMensagem,"Advertência")
			EndIf
			if !u_envMail(cEmailTo ,cEmailCc ,cAssunto ,cMensagem ,iif(substr(cError,1,6)=="ANEXO:",{},aAnexos), cAssinatu, @cError, .f.)
				cMensagem := "Job bolCobr não conseguiu enviar o email para: "+cEmailTo+chr(10)+chr(13)+"Assunto: "+cAssunto+chr(10)+chr(13)+"Mensagem: "+cMensagem+chr(10)+chr(13)+"Erro: "+cError
				conout(cMensagem)
				If lMostra
					msginfo(cMensagem,"Advertência")
				EndIf
			endif
		endif
		if !lClient
			//for nIx := 1 to len(aAnexos)
			if len(aAnexos) > 0
				FErase(aAnexos[1])
			endif
			//next
		endif
	next
	//FErase(cPastaSrv+cAssinatu)

Return
