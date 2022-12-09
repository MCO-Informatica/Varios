#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "COMMON.CH"
#include "ap5mail.ch"
#Include "tbicode.ch"
#include 'DIRECTRY.CH'

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³BOLITAU    ºAutor  ³ GUSTAVO GONZALEZ    º Data ³ 22/11/21  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Programa de Impressao de BoletOs c/ Codigo de Barras        º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ Arquivos necessarios:                                      º±±
//±±º          ³ Logo_itau.bmp e Logoempresa.bmp devem estar dentro da pasta º±±
//±±º          ³ system  º±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function BOLITAU(aSe1,aSee,cCart,cDirPDF)// PREFIXO,NUMERO,PARCELA,TIPO
	LOCAL oPrint
	Local cMarca	:= GetMark()
	Local llOk		:= .T.
	Local clMarca	:= "  "
	Local cQuery	:= GetNextAlias()
	LOCAL n			:= 0
	Local aBMP		:= "/SYSTEM/logo_itau.BMP"
	LOCAL aDadosEmp    := {	SM0->M0_NOMECOM              												,; //[1]Nome da Empresa
		SM0->M0_ENDCOB                                                            	,; //[2]Endereço
		AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB 	,; //[3]Complemento
		"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             	,; //[4]CEP
		"PABX/FAX: "+SM0->M0_TEL                                                  	,; //[5]Telefones
		"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	;  //[6]
		Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       	;  //[6]
		Subs(SM0->M0_CGC,13,2)                                                    	,; //[6]CGC
		"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            	;  //[7]
		Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        	,; //[7]I.E
		AllTrim(SM0->M0_CEPENT)+" - "+AllTrim(SM0->M0_ENDENT)+" - "+AllTrim(SM0->M0_CIDENT)+"/"+AllTrim(SM0->M0_ESTENT)} //[8]Endereço
	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatSacado
	LOCAL aBolText  	:= {"APOS O VENCIMENTO COBRAR MORA DIARIA DE R$ ","APOS O VENCIMENTO COBRAR MULTA DE R$ ","DEVOLVER EM ",Upper("Após 3 dias do vencimento e não pago, será incluso no Serasa.")}
	LOCAL i            	:= 0
	LOCAL CB_RN_NN     	:= {}
	LOCAL _nVlrAbat    	:= 0

	Private Exec    	:= .F.
	Private cIndexName 	:= ''
	Private cIndexKey  	:= ''
	Private cFilter   	:= ''
	Private lMarca		:= .F.

	Tamanho  := "M"
	titulo   := "Impressao de Boleto Itau"
	cDesc1   := "Este programa destina-se a impressao do Boleto Itau."
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SE1"
	wnrel    := "BOLETO"
	lEnd     := .F.

	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0

	cBanco  := aSee[1][1]
	cCodAge := aSee[1][2]
	cCodCta := aSee[1][3]
	cSubcta	:= aSee[1][4]
	cDvCta	:= Posicione('SEE',1,xFilial('SEE')+cBanco+cCodAge+cCodCta+cSubcta,'EE_DVCTA')

	DbSelectArea("SE1")
	SE1->(DBSetOrder(1))
	SE1->(dbGoTop())
	If SE1->(DbSeek(xFilial("SE1")+aSe1[1]+aSe1[2]+aSe1[3]+aSe1[4]))
		NNUM341()
	else
		Alert('Título não encontrado.')
		Return nil
	EndIf

	If lMarca
		lMarca := .F.
	Else
		lMarca 	:= .T.
		clMarca := cMarca
	EndIf

	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
	DbSelectArea("SEE")
	SEE->(DbSetOrder(1))

	cData 	:= DtoS(dDatabase)
	cHora 	:= SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2)

	If !SEE->(DbSeek(xFilial("SEE")+cBanco+cCodAge+cCodCta+cSubcta))
		llOk := .F.
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("O banco selecionado nos parâmetros não corresponde ao Banco do ITAU!"),{"OK"})
	EndIf

	nPrintType := 2
	If Empty(SE1->E1_PARCELA).Or. SE1->E1_PARCELA == '   '
		cName      := "Prozyn_"+Alltrim(SE1->E1_PREFIXO)+"_"+Alltrim(SE1->E1_NUM)+".rel"
	Else
		cName      := "Prozyn_"+Alltrim(SE1->E1_PREFIXO)+"_"+Alltrim(SE1->E1_NUM)+"_"+Alltrim(SE1->E1_PARCELA)+".rel"
	EndIf

	//oPrint:= FWMSPrinter():New(cName,6,.F.,,.T.)
	oPrint := FWMSPrinter():New(cName, nPrintType,.F.,cDirPdf,.T.,.F.,,"PDF",.T., .T., .F.,.F.)
	oPrint:cPathPDF:=cDirPDF
	oPrint:SetPortrait()
	oPrint:SetPaperSize(9,876,620)
	oPrint:SetViewPDF(.F.)


	BeginSQL Alias cQuery
		SELECT
			E1_TIPO,
			E1_PREFIXO,
			E1_NUM,
			E1_PARCELA,
			E1_CLIENTE,
			E1_LOJA,
			E1_TIPO,
			E1_EMISSAO EMIS,
			E1_VENCREA VENCREA,
			REPLACE(
				CONVERT(VARCHAR, CONVERT(DATE, E1_EMISSAO, 103), 103),
				'/',
				'/'
			) E1_EMISSAO,
			REPLACE(
				CONVERT(VARCHAR, CONVERT(DATE, E1_VENCREA, 103), 103),
				'/',
				'/'
			) E1_VENCREA,
			E1_VALOR,
			E1_CLIENTE,
			E1_NUMBCO,
			E1_DECRESC,
			E1_ACRESC,
			E1_VLCRUZ,
			E1_JUROS,
			E1_DESCONT,
			E1_ACRESC,
			E1_SALDO,
			E1_CSLL,
			E1_COFINS,
			E1_PIS,
			E1_IRRF,
			E1_INSS,
			E1_DESCFIN,
			E1_SDDECRE,
			E1_SDACRES,
			E1_PORCJUR
		FROM
			%Table:SE1%
		WHERE
			E1_FILIAL = %xFilial:SE1%
			AND E1_PREFIXO = %Exp:aSe1[1]%
			AND E1_NUM = %Exp:aSe1[2]%
			AND E1_PARCELA = %Exp:aSe1[3]%
			AND E1_PORTADO = %Exp:cBanco%
			AND E1_SALDO > 0
			AND D_E_L_E_T_ = ''
		ORDER BY
			E1_NUM,
			E1_PARCELA
	EndSQL

	(cQuery)->(DBGoTop())

	While (cQuery)->(!EOF())

		DbSelectArea("SE1")
		DBSetOrder(1)
		DbSeek(xFilial("SE1")+(cQuery)->(E1_PREFIXO)+(cQuery)->(E1_NUM)+(cQuery)->(E1_PARCELA)+(cQuery)->(E1_TIPO))
		SE1->(dbGoTop())
		IncProc("Imprimindo Boleto do banco Itaú")
		i := i + 1
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+(cQuery)->(E1_CLIENTE)+(cQuery)->(E1_LOJA),.T.)

		aDadosBanco  := {"341-7"                ,; //SA6->A6_COD [1]Numero do Banco
			"BANCO ITAU S/A"   	    ,; // [2]Nome do Banco
			SUBSTR(cCodAge, 1, 4)  	,; // [3]Agência
			SUBSTR(cCodCta,1,5)		,; // [4]Conta Corrente
			ALLTRIM(cDvCta)    		,; // [5]Dígito da conta corrente
			cCart                   }  // [6]Codigo da Carteira

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      // [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      // [2]Código
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      // [3]Endereço
				AllTrim(SA1->A1_MUN )                            ,;      // [4]Cidade
				SA1->A1_EST                                      ,;      // [5]Estado
				SA1->A1_CEP                                      ,;      // [6]CEP
				SA1->A1_CGC										 }       // [7]CGC
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)              ,;   // [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
				AllTrim(SA1->A1_MUNC)	                             ,;   // [4]Cidade
				SA1->A1_ESTC	                                     ,;   // [5]Estado
				SA1->A1_CEPC                                        ,;   // [6]CEP
				SA1->A1_CGC										 }    // [7]CGC
		Endif
		_nVlrAbat := 0
		dbSelectArea("SE5")
		dbSetOrder(7)
		dbSeek(xFilial()+(cQuery)->E1_PREFIXO+(cQuery)->E1_NUM+(cQuery)->E1_PARCELA+(cQuery)->E1_TIPO)
		While !EOF() .And. SE5->E5_PREFIXO == (cQuery)->E1_PREFIXO .And. SE5->E5_NUMERO == (cQuery)->E1_NUM .And.;
				SE5->E5_PARCELA == (cQuery)->E1_PARCELA .And. SE5->E5_TIPO == (cQuery)->E1_TIPO
			If SE5->E5_DTDISPO >= stod((cQuery)->EMIS)
				If SE5->E5_MOTBX == "CMP"
					iF AllTrim(SE5->E5_TIPODOC) == "ES"
						_nVlrAbat -= SE5->E5_VALOR
					Else
						_nVlrAbat += SE5->E5_VALOR
					EndIf
				EndIf
			EndIf
			dbSkip()
		EndDo

		_nVlrAbat   +=  (cQuery)->E1_DECRESC //E1_VALLIQ //SomaAbat((cQuery)->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		IF EMPTY((cQuery)->E1_NUMBCO)
			_cFaixa:= strzero(val(SEE->EE_FAXATU)+1,8)
			DbSelectArea("SEE")
			SEE->(RECLOCK( "SEE", .F. ))
			SEE->EE_FAXATU  := _cFaixa   // CONTA
			SEE->(MSUNLOCK())
			_cNossoNum := Substr(_cFaixa,4,8) //CB_RN_NN[3]+_cFaixa
		Else
			_cNossoNum  := Substr((cQuery)->E1_NUMBCO,4,8)
		ENDIF

		If cCart == '112'
			_CDIGITO := Modulo10(cCart+_cNossoNum)
		Else
			_CDIGITO := Modulo10(aDadosBanco[3]+aDadosBanco[4]+cCart+Substr(_cNossoNum,1,8))
		EndIf
		//Ajuste para descontar impostos - Gustavo Gonzalez - 04/08/2021
		nVlrTit	 := (cQuery)->E1_SALDO + (cQuery)->E1_ACRESC - (cQuery)->E1_DECRESC - ((cQuery)->E1_CSLL + (cQuery)->E1_COFINS + (cQuery)->E1_PIS + (cQuery)->E1_IRRF + (cQuery)->E1_INSS)
		//nVlcrzab :=(cQuery)->E1_VLCRUZ-_nVlrAbat
		nVlcrzab := nVlrTit - _nVlrAbat
		dVenc    := (cQuery)->VENCREA

		//Juros e Multa Prozyn - Gustavo Gonzalez - 03/08/2022
		_nPJurPd	:= 0.0666	//% de Juros Padrão
		If !Empty((cQuery)->E1_PORCJUR)
			//(ALE)	_nJrs := NoRound(SE1->(E1_VLCRUZ-E1_SDDECRE+E1_SDACRES-(SE1->E1_VLCRUZ * (SE1->E1_DESCFIN/100)))*((SE1->E1_PORCJUR/100)),2)
			nJuros := NoRound((cQuery)->(E1_VALOR-E1_SDDECRE+E1_SDACRES-((cQuery)->E1_VALOR * ((cQuery)->E1_DESCFIN/100)))*(((cQuery)->E1_PORCJUR/100)),2)
		ElseIf !Empty(_nPJurPd)
			//(ALE)	_nJrs := NoRound(SE1->(E1_VLCRUZ-E1_SDDECRE+E1_SDACRES-(SE1->E1_VLCRUZ * (SE1->E1_DESCFIN/100)))*((_nPJurPd/100)),2)
			nJuros := NoRound((cQuery)->(E1_VALOR-E1_SDDECRE+E1_SDACRES-((cQuery)->E1_VALOR * ((cQuery)->E1_DESCFIN/100)))*((_nPJurPd/100)),2)
		EndIf

		nMulta 		:= 0
		nTxmulta 	:= 0.02
		//	njuros := (MsgInstr03)
		//(ale) nMulta := Round((SE1->E1_VLCRUZ - (SE1->E1_VLCRUZ*(SE1->E1_DESCFIN/100))) * nTxmulta,2)
		nMulta := Round(((cQuery)->E1_VALOR - ((cQuery)->E1_VALOR*((cQuery)->E1_DESCFIN/100))) * nTxmulta,2)
		//	nMulta := Round((SE1->E1_SALDO - (SE1->E1_SALDO*(SE1->E1_DESCFIN/100))) * nTxmulta,2)

		DbSelectArea("SE1")
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],_cNossoNum,nVlcrzab,stod(dVenc),cCart)     // ANTIGO --> (E1_VLCRUZ-_nVlrAbat)

		aDadosTit    := {AllTrim((cQuery)->E1_NUM)+" "+AllTrim((cQuery)->E1_PARCELA),;  // [1] Número do título
			(cQuery)->E1_EMISSAO                     					,;  // [2] Data da emissão do título
			Date()                                  					,;  // [3] Data da emissão do boleto
			(cQuery)->E1_VENCREA                     					,;  // [4] Data do vencimento
			nVlrTit              		            					,;  // [5] Valor do título
			CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
			(cQuery)->E1_PREFIXO                     					,;  // [7] Prefixo da NF
			(cQuery)->E1_TIPO	                       					,;  // [8] Tipo do Titulo
			_nVlrAbat	                                        		,;  // [9] Valor do Abatimento
			(cQuery)->E1_JUROS											,;	// [10] Valor do Juros
			(cQuery)->E1_DECRESC										,;	// [11] Valor do Desconto
			(cQuery)->E1_ACRESC                              			,;  // [12] Valor do Acrescimo
			(cQuery)->E1_NUM                                 			,;  // [13] Numero do Título
			(cQuery)->E1_PARCELA   										,;  // [14] Parcela
			nJuros														,;  // [15] Juros Prozyn
			nMulta														}   // [16] Juros Prozyn
		If Empty((cQuery)->E1_NUMBCO) // .T. aMarked[i]
			//informacoes do banco
			DbSelectArea("SE1")
			DbSeek(xFilial("SE1")+(cQuery)->(E1_PREFIXO)+(cQuery)->(E1_NUM)+(cQuery)->(E1_PARCELA)+(cQuery)->(E1_TIPO))
			SE1->(RecLock("SE1",.f.))
			//_cNossoNum:=_cNossoNum+ALLTRIM(STR(_CDIGITO))
			//SE1->E1_NUMBCO  :=	_cNossoNum
			SE1->E1_NUMBCO  :=  _cNossoNum //CB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
			SE1->E1_PORTADO :=  cBanco
			SE1->E1_AGEDEP  :=  cCodAge
			SE1->E1_CONTA   :=  cCodCta
			SE1->(MsUnlock())
		Else
			_cNossoNum := Substr(ALLTRIM((cQuery)->E1_NUMBCO),4,8)
		Endif

		Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1

		SE1->(dbSkip())
		(cQuery)->(dbSkip())
	EndDo

	oPrint:EndPage()     // Finaliza a página
	oPrint:Print()
	//oPrint:Preview() //Visualizar

Return nil



Static Function Impress(oPrint,aBmp,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

	LOCAL oFont8
	LOCAL oFont10
	LOCAL oFont16
	LOCAL oFont16n
	LOCAL oFont14n
	LOCAL oFont24
	LOCAL oBrush
	LOCAL nI

	//Parâmetros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)

	oFont1 := TFont():New( "Times New Roman",,08,,.t.,,,,,.f. )
	oFont2 := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
	oFont3 := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
	oFont4 := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	oFont5 := TFont():New( "Times New Roman",,16,,.t.,,,,,.f. )
	oFont6 := TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11:= TFont():New( "Courier New" ,,10,,.t.,,,,,.f. )
	oFont12:= TFont():New( "Courier New" ,,09,,.t.,,,,,.f. )
	oFont13:= TFont():New( "Arial"       ,,06,,.f.,,,,,.f. )
	oFont14:= TFont():New( "Arial"       ,,09,,.F.,,,,,.f. )
	oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15:= TFont():New( "Arial"         ,,09,,.t.,,,,,.f. )
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont17:= TFont():New( "Arial"         ,,14,,.T.,,,,,.f. )
	oFont18:= TFont():New( "Arial"         ,,09,,.T.,,,,,.f. )
	oFont19:= TFont():New( "Arial"         ,,22,,.t.,,,,,.f. )
	oFont20:= TFont():New( "Arial Black"   ,,16,,.t.,,,,,.f. )
	oFont21:= TFont():New( "Arial"         ,,18,,.t.,,,,,.f. )
	oFont22:= TFont():New( "Arial"         ,,13,,.t.,,,,,.f. )
	oFont23:= TFont():New( "Arial Black"   ,,15.7,,.t.,,,,,.f. )
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)


	oBrush := TBrush():New("",4)

	oPrint:StartPage()   // Inicia uma nova página

	XbQuery:=" SELECT MAX(E1_PARCELA) AS E1_PARCELA FROM " +RetSqlName("SE1")+ " WHERE D_E_L_E_T_ = '' AND E1_NUM = '"+aDadosTit[13]+"' AND E1_PREFIXO = '"+aDadosTit[7]+"' "

	If Select("XPAR") > 0
		XPAR->(DbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,XbQuery),"XPAR", .F., .T.)
	XPAR->(DBGOTOP())
	NT_DUP:= XPAR->E1_PARCELA
	If len(alltrim(NT_DUP)) == 0
		NT_DUP := " 1"
		cParcela := " 1"
	Else
		cParcela :=aDadosTit[14]
	Endif
	If  NT_DUP == "A"
		NT_DUP:= "10"
	ElseIF  NT_DUP == "B"
		NT_DUP:= "11"
	ElseIf NT_DUP == "C"
		NT_DUP:= "12"
	ElseIF NT_DUP == "D"
		NT_DUP:= "13"
	ElseIf NT_DUP == "E"
		NT_DUP:= "14"
	ElseIf NT_DUP == "F"
		NT_DUP:= "15"
	ElseIf NT_DUP == "G"
		NT_DUP:= "16"
	ElseIf  NT_DUP == "H"
		NT_DUP:=  "17"
	ElseIf  NT_DUP == "I"
		NT_DUP:=  "18"
	ElseIf  NT_DUP == "J"
		NT_DUP:=  "19"
	ElseIf  NT_DUP == "K"
		NT_DUP:=  "20"
	ElseIf  NT_DUP == "L"
		NT_DUP:=  "21"
	ElseIf  NT_DUP == "M"
		NT_DUP:=  "22"
	ElseIf  NT_DUP == "N"
		NT_DUP:=  "23"
	ElseIf  NT_DUP == "O"
		NT_DUP:=  "24"
	ElseIf  NT_DUP == "P"
		NT_DUP:=  "25"
	ElseIf  NT_DUP == "Q"
		NT_DUP:=  "26"
	ElseIf  NT_DUP == "R"
		NT_DUP:=  "27"
	ElseIf  NT_DUP == "S"
		NT_DUP:=  "28"
	ElseIf  NT_DUP == "T"
		NT_DUP:=  "29"
	ElseIf  NT_DUP == "U"
		NT_DUP:=  "30"
	ElseIf  NT_DUP == "V"
		NT_DUP:=  "31"
	ElseIf  NT_DUP == "W"
		NT_DUP:=  "32"
	ElseIf  NT_DUP == "X"
		NT_DUP:=  "33"
	ElseIf  NT_DUP == "Y"
		NT_DUP:=  "34"
	ElseIf  NT_DUP == "Z"
		NT_DUP:=  "35"
	ElseIf  NT_DUP == "0"
		NT_DUP:=  "36"
	EndIf

	If  cParcela == "A"
		cParcela:= "10"
	ElseIF  cParcela == "B"
		cParcela:= "11"
	ElseIf cParcela == "C"
		cParcela:= "12"
	ElseIF cParcela == "D"
		cParcela:= "13"
	ElseIf cParcela == "E"
		cParcela:= "14"
	ElseIf cParcela == "F"
		cParcela:= "15"
	ElseIf cParcela == "G"
		cParcela:= "16"
	ElseIf  cParcela == "H"
		cParcela:=  "17"
	ElseIf  cParcela == "I"
		cParcela:=  "18"
	ElseIf  cParcela == "J"
		cParcela:=  "19"
	ElseIf  cParcela == "K"
		cParcela:=  "20"
	ElseIf  cParcela == "L"
		cParcela:=  "21"
	ElseIf  cParcela == "M"
		cParcela:=  "22"
	ElseIf  cParcela == "N"
		cParcela:=  "23"
	ElseIf  cParcela == "O"
		cParcela:=  "24"
	ElseIf  cParcela == "P"
		cParcela:=  "25"
	ElseIf  cParcela == "Q"
		cParcela:=  "26"
	ElseIf  cParcela == "R"
		cParcela:=  "27"
	ElseIf  cParcela == "S"
		cParcela:=  "28"
	ElseIf  cParcela == "T"
		cParcela:=  "29"
	ElseIf  cParcela == "U"
		cParcela:=  "30"
	ElseIf  cParcela == "V"
		cParcela:=  "31"
	ElseIf  cParcela == "W"
		cParcela:=  "32"
	ElseIf  cParcela == "X"
		cParcela:=  "33"
	ElseIf  cParcela == "Y"
		cParcela:=  "34"
	ElseIf  cParcela == "Z"
		cParcela:=  "35"
	ElseIf  cParcela == "0"
		cParcela:=  "36"
	EndIf

	clin:=200

	iW := 600 / 100
	iH := 900 / 100

	If File(aBmp)
		oPrint:SayBitmap( iH*3.9,iW*4,aBmp,iH*2.6,iH*2.6 )
	Endif

	oPrint:Line (iH*6.71,iW*2,iH*6.71, iW*98)

	oPrint:Line (iH*3.62,iW*26,iH*6.71, iW*26)
	oPrint:Line (iH*3.62,iW*33.8,iH*6.71, iW*33.8)

	oPrint:Line (iH*9.8,iW*2,iH*9.8, iW*75)
	oPrint:Line (iH*12.9,iW*2,iH*12.9, iW*75)
	oPrint:Line (iH*16,iW*41.72,iH*16, iW*75)
	oPrint:Line (iH*19,iW*2,iH*19, iW*98)


	oPrint:Line (iH*6.71,iW*41.66,iH*19, iW*41.66)
	oPrint:Line (iH*6.71,iW*59.4,iH*12.9, iW*59.4)
	oPrint:Line (iH*12.9,iW*55.3,iH*19, iW*55.3)
	oPrint:Line (iH*6.71,iW*74.9,iH*19, iW*74.9)

	oPrint:Say  (iH*05.70,iW*10.00,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	oPrint:Say  (iH*05.70,iW*26.6,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
	oPrint:Say  (iH*07.52,iW*02.20,"Beneficiário"                                        ,oFont8) // Cedente
	oPrint:Say  (iH*08.62,iW*02.20,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
	oPrint:Say  (iH*07.52,iW*41.86,"Agência/Código do Beneficiário"                         ,oFont8)
	oPrint:Say  (iH*08.62,iW*41.86,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	oPrint:Say  (iH*07.52,iW*59.60,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (iH*08.62,iW*59.60,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (iH*05.72,iW*75.20,"Comprovante de Entrega",oFont10)
	oPrint:Say  (iH*10.62,iW*02.20,"Pagador"                                         ,oFont8) // Sacado
	oPrint:Say  (iH*11.72,iW*02.20,SubStr(aDatSacado[1],1,40)                      ,oFont10)	//Nome
	oPrint:Say  (iH*10.62,iW*41.86,"Vencimento"                                     ,oFont8)
	oPrint:Say  (iH*11.72,iW*41.86,(aDadosTit[4])                               ,oFont10)
	oPrint:Say  (iH*10.62,iW*59.60,"Valor do Documento"                          	,oFont8)
	oPrint:Say  (iH*11.72,iW*59.60,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))   ,oFont10)
	oPrint:Say  (iH*14.82,iW*02.20,"Recebi(emos) o bloqueto/título"                 ,oFont10)
	oPrint:Say  (iH*16.52,iW*02.20,"com as características acima."             		,oFont10)
	oPrint:Say  (iH*13.71,iW*41.86,"Data"                                           ,oFont8)
	oPrint:Say  (iH*13.71,iW*55.52,"Assinatura"                                 	,oFont8)
	oPrint:Say  (iH*16.81,iW*41.86,"Data"                                           ,oFont8)
	oPrint:Say  (iH*16.81,iW*55.52,"Entregador"                                 	,oFont8)

	oPrint:Say  (iH*08.00,iW*75,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (iH*09.22,iW*75,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (iH*10.44,iW*75,"(  )Não existe / indicado"                  	,oFont8)
	oPrint:Say  (iH*11.66,iW*75,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (iH*12.88,iW*75,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (iH*14.10,iW*75,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (iH*15.32,iW*75,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (iH*16.54,iW*75,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (iH*17.76,iW*75,"(  )Outros(anotar no verso)"                  	,oFont8)



	oPrint:Line (iH*20.66,iW*26,iH*23.96, iW*26)
	oPrint:Line (iH*20.66,iW*33.8,iH*23.96, iW*33.8)

	oPrint:Line (iH*20.66,iW*2,iH*20.66, iW*98)
	oPrint:Line (iH*23.96,iW*2,iH*23.96, iW*98)
	oPrint:Line (iH*27.05,iW*2,iH*27.05, iW*98)
	oPrint:Line (iH*30.14,iW*2,iH*30.14, iW*98)
	oPrint:Line (iH*32.27,iW*2,iH*32.27, iW*98)
	oPrint:Line (iH*34.40,iW*2,iH*34.40, iW*98)

	oPrint:Line (iH*30.14,iW*20.15,iH*34.40, iW*20.15)

	oPrint:Line (iH*32.27,iW*29.8,iH*34.40, iW*29.8)

	oPrint:Line (iH*30.14,iW*39.6,iH*34.40, iW*39.6)

	oPrint:Line (iH*30.14,iW*53.3,iH*32.27, iW*53.3)

	oPrint:Line (iH*30.14,iW*61.2,iH*34.40, iW*61.2)

	oPrint:Line (iH*45.26,iW*2,iH*45.26, iW*98)
	oPrint:Line (iH*52.61,iW*2,iH*52.61, iW*98)
	oPrint:Line (iH*23.96,iW*74.9,iH*34.40, iW*74.9)

	If File(aBmp)
		oPrint:SayBitmap( iH*21.2,iW*4,aBmp,iH*2.6,iH*2.6 )
	Endif
	oPrint:Say  (iH*22.8,iW*10.00,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	oPrint:Say  (iH*22.8,iW*26.6,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
	oPrint:Say  (iH*22.8,iW*75.00,"Recibo do Pagador",oFont10)

	oPrint:Say  (iH*25,iW*2 ,"Local de Pagamento"                             ,oFont8)
	oPrint:Say  (iH*26,iW*2 ,"Até o Vencimento, preferencialmente no Itaú, e após o vencimento somente no Itaú"       ,oFont10)

	oPrint:Say  (iH*25,iW*75,"Vencimento"                                     ,oFont8)
	oPrint:Say  (iH*26,iW*75,(aDadosTit[4])                          ,oFont10)

	oPrint:Say  (iH*27.9,iW*2 ,"Beneficiário"                                        ,oFont8) // Cedente
	oPrint:Say  (iH*28.8,iW*2 ,trim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (iH*29.6,iW*2 ,aDadosEmp[8]	,oFont10) //Endereço

	oPrint:Say  (iH*27.9,iW*75,"Agência/Código do Beneficiário"                         ,oFont8) // Agencia/Cedente
	oPrint:Say  (iH*28.8,iW*75,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

	oPrint:Say  (iH*30.8,iW*2 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (iH*31.8,iW*2 ,(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

	oPrint:Say  (iH*30.8,iW*20.6 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (iH*31.8,iW*20.6 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (iH*30.8,iW*40.09,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (iH*31.8,iW*40.09,"DM"										,oFont10) //Tipo do Titulo

	oPrint:Say  (iH*30.8,iW*53.6,"Aceite"                                         ,oFont8)
	oPrint:Say  (iH*31.8,iW*53.6,"N"                                             ,oFont10)

	oPrint:Say  (iH*30.8,iW*61.6,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (iH*31.8,iW*61.6,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

	oPrint:Say  (iH*30.8,iW*75,"Nosso Número"                                   ,oFont8)
	oPrint:Say  (iH*31.8,iW*75,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)),oFont10) // parei aqui nilton dias

	oPrint:Say  (iH*33.1,iW*2 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (iH*33.1,iW*20.6 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (iH*34.1,iW*20.6 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (iH*33.1,iW*30.2 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (iH*34.1,iW*30.2 ,"R$"                                             ,oFont10)

	oPrint:Say  (iH*33.1,iW*40.09,"Quantidade"                                     ,oFont8)
	oPrint:Say  (iH*33.1,iW*61.6,"Valor"                                          ,oFont8)

	oPrint:Say  (iH*33.1,iW*75,"Valor do Documento"                          	,oFont8)
	oPrint:Say  (iH*34.27,iW*75,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (iH*35.5,iW*2 ,"Instruções de responsabilidade do BENEFICIÁRIO.Qualquer Duvida Sobre este boleto Contate o BENEFICIÁRIO.",oFont8)

	oPrint:Say (iH*37.00,iW*2,aBolText[1]+" "+AllTrim(Transform((aDadosTit[15]),"@E 999,999.99")),oFont10)  //MORA DIARIA
	oPrint:Say (iH*38.30,iW*2,aBolText[2]+" "+AllTrim(Transform((aDadosTit[16]),"@E 999,999.99")),oFont10)	//MULTA
	oPrint:Say (iH*39.60,iW*2,aBolText[3]+" "+DTOC(CTOD(aDadosTit[4])+60),oFont10) //DEVOLVER EM
	oPrint:Say (iH*40.90,iW*2,aBolText[4],oFont10)

	oPrint:Line (iH*32,iW*74.9,iH*45.33, iW*74.9)
	oPrint:Line (iH*36.71,iW*74.9,iH*36.71, iW*98)
	oPrint:Line (iH*38.8,iW*74.9,iH*38.8, iW*98)
	oPrint:Line (iH*40.90,iW*74.9,iH*40.90, iW*98)
	oPrint:Line (iH*43.10,iW*74.9,iH*43.10, iW*98)
	oPrint:Line (iH*45.30,iW*02.0,iH*45.30, iW*98)
	oPrint:Line (iH*52.68,iW*02.0,iH*52.68, iW*98)

	oPrint:Say  (iH*35.2,iW*75,"(-)Desconto/Abatimento"                         ,oFont8)
	if aDadosTit[09] > 0.00
		oPrint:Say  (iH*36.2,iW*75,AllTrim(Transform(aDadosTit[09],"@E 999,999,999.99")),oFont10)
	endif
	oPrint:Say  (iH*37.3,iW*75,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (iH*39.4,iW*75,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (iH*41.5,iW*75,"(+)Outros Acréscimos"                           ,oFont8)
	If aDadosTit[12] > 0.00
		oPrint:Say  (iH*42.5,iW*75,AllTrim(Transform(aDadosTit[12],"@E 999,999,999.99"))                        ,oFont8)
	EndIf

	oPrint:Say  (iH*43.7,iW*75,"(=)Valor Cobrado"                               ,oFont8)
	if aDadosTit[09] > 0.00 .Or. aDadosTit[12] > 0.00
		oPrint:Say  (iH*44.7,iW*75,AllTrim(Transform(aDadosTit[5] - aDadosTit[09] + aDadosTit[12],"@E 999,999,999.99")),oFont10)
	endif

	oPrint:Say  (iH*46.50,iW*2 ,"Pagador"                                         ,oFont8) // Sacado
	oPrint:Say  (iH*46.50,iW*16 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (iH*47.50,iW*16 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (iH*48.50,iW*16 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	oPrint:Say  (iH*52,iW*16 ,IIf(Len(Alltrim(aDatSacado[7]))=11,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")),oFont10) // CGC

	oPrint:Say  (iH*52,iW*75,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO))  ,oFont10)
	oPrint:Say  (iH*52,iW*2 ,"Sacador/Avalista"                               ,oFont8) // Sacador/Avalista
	oPrint:Say  (iH*53.6,iW*75,"Autenticação Mecânica -"                        ,oFont8)

	For nI := 0 to 50
		oPrint:Line (iH*55,iW*nI*2,iH*55, (iW*nI*2)+1.7)
	Next nI


	oPrint:Line (iH*58.7,iW*2,iH*58.7, iW*98)
	oPrint:Line (iH*55.40,iW*26,iH*58.7, iW*26)
	oPrint:Line (iH*55.40,iW*33.8,iH*58.7, iW*33.8)

	oPrint:Line (iH*61.9,iW*2,iH*61.9, iW*98)
	oPrint:Line (iH*64.9,iW*2,iH*64.9, iW*98)
	oPrint:Line (iH*66.9,iW*2,iH*66.9, iW*98)
	oPrint:Line (iH*68.9,iW*2,iH*68.9, iW*98)
	oPrint:Line (iH*71.3,iW*74.9,iH*71.3, iW*98)
	oPrint:Line (iH*73.4,iW*74.9,iH*73.4, iW*98)
	oPrint:Line (iH*75.5,iW*74.9,iH*75.5, iW*98)
	oPrint:Line (iH*77.6,iW*74.9,iH*77.6, iW*98)
	oPrint:Line (iH*79.7,iW*2,iH*79.7, iW*98)
	oPrint:Line (iH*87.2,iW*2,iH*87.2, iW*98)

	oPrint:Line (iH*64.9,iW*20,iH*68.9, iW*20)
	oPrint:Line (iH*66.9,iW*29.8,iH*68.9, iW*29.8)
	oPrint:Line (iH*64.9,iW*39.7,iH*68.9, iW*39.7)
	oPrint:Line (iH*64.9,iW*53.4,iH*66.9, iW*53.4)
	oPrint:Line (iH*64.9,iW*61.2,iH*68.9, iW*61.2)

	oPrint:Line (iH*58.7,iW*74.9,iH*79.7, iW*74.9)

	If File(aBmp)
		oPrint:SayBitmap(iH*55.9,iW*4,aBmp,iH*2.6,iH*2.6 )
	Endif
	oPrint:Say  (iH*57.5,iW*10.00,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	oPrint:Say  (iH*57.5,iW*26.6,aDadosBanco[1],oFont16 )	// [1]Numero do Banco
	oPrint:Say  (iH*57.5,iW*36.3,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras


	oPrint:Say  (iH*59.4,iW*2 ,"Local de Pagamento"                             ,oFont8)
	oPrint:Say  (iH*60.4,iW*2 ,"Até o Vencimento, preferencialmente no Itaú, e após o vencimento somente no Itaú"     ,oFont10)

	oPrint:Say  (iH*59.4,iW*75,"Vencimento"                                     ,oFont8)
	oPrint:Say  (iH*60.4,iW*75,(aDadosTit[4])                          ,oFont10)

	oPrint:Say  (iH*62.6,iW*2 ,"Beneficiário"                                        ,oFont8)  // Cedente
	oPrint:Say  (iH*63.6,iW*2 ,trim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (iH*64.3,iW*2 ,aDadosEmp[8]	                              ,oFont10) //Endereço

	oPrint:Say  (iH*62.6,iW*75,"Agência/Código de Beneficiário"                         ,oFont8)  // Agencia / Codigo Cedente
	oPrint:Say  (iH*63.6,iW*75,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

	oPrint:Say  (iH*65.6,iW*2 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (iH*66.6,iW*2 ,(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

	oPrint:Say  (iH*65.6,iW*20.5 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (iH*66.6,iW*20.5 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (iH*65.6,iW*40,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (iH*66.6,iW*40,"DM"   										,oFont10) //Tipo do Titulo
	//oPrint:Say  (2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

	oPrint:Say  (iH*65.6,iW*53.7,"Aceite"                                         ,oFont8)
	oPrint:Say  (iH*66.6,iW*53.7,"N"                                             ,oFont10)

	oPrint:Say  (iH*65.6,iW*61.5,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (iH*66.6,iW*61.5,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

	oPrint:Say  (iH*65.6,iW*75,"Nosso Número"                                   ,oFont8)

	oPrint:Say  (iH*66.6,iW*75,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)), oFont10)

	oPrint:Say  (iH*67.6,iW*2 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (iH*67.6,iW*20.5 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (iH*68.6,iW*20.5 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (iH*67.6,iW*30.3 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (iH*68.6,iW*30.3 ,"R$"                                             ,oFont10)

	oPrint:Say  (iH*67.6,iW*40,"Quantidade"                                     ,oFont8)
	oPrint:Say  (iH*67.6,iW*61.5,"Valor"                                          ,oFont8)

	oPrint:Say  (iH*67.6,iW*75,"Valor do Documento"                          	,oFont8)
	oPrint:Say  (iH*68.6,iW*75,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (iH*70,iW*2 ,"Instruções de responsabilidade do BENEFICIÁRIO.Qualquer dúvida sobre este boleto contate o BENEFICIÁRIO.",oFont8)

	oPrint:Say (iH*71.6,iW*2,aBolText[1]+" "+AllTrim(Transform((aDadosTit[15]),"@E 999,999.99")),oFont10) //MORA DIARIA
	oPrint:Say (iH*72.8,iW*2,aBolText[2]+" "+AllTrim(Transform((aDadosTit[16]),"@E 999,999.99")),oFont10) //MULTA
	oPrint:Say (iH*74.0,iW*2,aBolText[3]+" "+DTOC(CTOD(aDadosTit[4])+60),oFont10) //DEVOLVER EM
	oPrint:Say (iH*75.2,iW*2,aBolText[4],oFont10)


	oPrint:Say  (iH*69.5,iW*75,"(-)Desconto/Abatimento"                         ,oFont8)
	If aDadosTit[09] > 0.00
		oPrint:Say  (iH*70.5,iW*75,AllTrim(Transform(aDadosTit[09],"@E 999,999,999.99")),oFont10)
	EndIf
	oPrint:Say  (iH*72.1,iW*75,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (iH*74.2,iW*75,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (iH*76.3,iW*75,"(+)Outros Acréscimos"                           ,oFont8)
	If aDadosTit[12] > 0.00
		oPrint:Say  (iH*77.4,iW*75,AllTrim(Transform(aDadosTit[12],"@E 999,999,999.99"))                        ,oFont8)
	EndIf
	oPrint:Say  (iH*78.5,iW*75,"(=)Valor Cobrado"                               ,oFont8)

	If aDadosTit[09] > 0.00 .Or. aDadosTit[12] > 0.00
		oPrint:Say  (iH*79.5,iW*75,AllTrim(Transform(aDadosTit[5] - aDadosTit[09] + aDadosTit[12],"@E 999,999,999.99")),oFont10)
	EndIf

	oPrint:Say  (iH*81.0,iW*2 ,"Pagador"                                         ,oFont8)  // Sacado
	oPrint:Say  (iH*81.0,iW*12 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (iH*82.5,iW*12 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (iH*84.0,iW*12 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	oPrint:Say  (iH*86.0,iW*12 ,IIf(Len(Alltrim(aDatSacado[7]))=11,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")),oFont10) // CGC

	oPrint:Say  (iH*86.0,iW*75,Substr(aDadosTit[6],1,3)+"/"+Substr(_cNossoNum,1,8)+"-"+Alltrim(STR(_CDIGITO)), oFont10)

	oPrint:Say  (iH*86.0,iW*2 ,"Sacador/Avalista"                               ,oFont8)  // Sacador / Avalista
	oPrint:Say  (iH*88.0,iW*57.8,"Autenticação Mecânica -"                        ,oFont8)
	oPrint:Say  (iH*88.0,iW*75,"Ficha de Compensação"                           ,oFont10)


	oPrint:FWMSBAR("INT25"  ,68,1,CB_RN_NN[1],oPrint,.F.,,,0.026,0.8,,,,.F.) // POSICIONAMENTO PARA IMPRESSORA HP 4250

	oPrint:EndPage() // Finaliza a página
	//oPrint:preview() // Finaliza a página
	//oPrint:Print()

Return Nil



Static Function Modulo10(cData)

	LOCAL L,D,P := 0
	LOCAL B     := .F.
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



Static Function Modulo11(cData)

	LOCAL L, D, P := 0
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



Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cCart)

	LOCAL bldocnufinal := strzero(val(cNroDoc),8)
	LOCAL blvalorfinal := strzero((nValor*100),10)     // antigo -> strzero(int(nValor*100),10)
	LOCAL dvnn         := 0 //digito do nosso numero
	LOCAL dvcb         := 0 //digito do codigo de barra
	LOCAL dv           := 0 //digito verificador
	LOCAL NN           := '' //nosso numero
	LOCAL RN           := '' //
	LOCAL CB           := '' //codigo de barra
	LOCAL s            := ''
	LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
	LOCAL _cCart	   := cCart

	//-------- Definicao do NOSSO NUMERO
	If cCart == '112'
		s    :=  _cCart + bldocnufinal
		dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
	Else
		s    :=  cAgencia + cConta + _cCart + bldocnufinal
		dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
	EndIf
	NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))

	//	-------- Definicao do CODIGO DE BARRAS
	s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
	dvcb := modulo11(s)
	CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	CCC = Codigo da Carteira de Cobranca
	//	 DD = Dois primeiros digitos no nosso numero
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
	dv   := modulo10(s)
	RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	RN   := RN + AllTrim(Str(dvcb)) + '  '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	RN   := RN + _cfator + StrZero((nValor * 100),14-Len(_cfator))  // antigo --> StrZero(Int(nValor * 100),14-Len(_cfator))

Return({CB,RN,NN})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NNUM341  ºAutor  ³ Gustavo Gonzalez    º Data ³ 03/12/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que retorna o nosso número para as cobranças regis- º±±
±±º          ³ tradas do Banco Itaú.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NNUM341()

	Local _cNum  	:= ""

	If alltrim(SE1->E1_NUMBCO) != ''
		_cNum 	:= Alltrim(SE1->E1_NUMBCO)
	Else
		If SEE->(DbSeek(xFilial("SEE") + cBanco + cCodAge + cCodCta + cSubcta))  //Conta Itaú a Receber
			If Empty(SEE->EE_FAXATU)
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := Substr(SEE->EE_FAXINI,1,8)
				SEE->(MsUnLock())
			EndIf

			x := SEE->EE_FAXATU
			If Val(x) > Val(Substr(SEE->EE_FAXFIM,1,8))
				Alert("O nosso numero atingiu a faixa maxima permitida. A sequencia sera reiniciada.")
				x := SEE->EE_FAXINI
			EndIf

			RecLock("SEE",.F.)
			SEE->EE_FAXATU := StrZero(Val(x)+1,08)
			SEE->(MsUnLock())

			_cNum := StrZero(VAL(SEE->EE_FAXATU),8)

			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO  := _cNum
			SE1->(MsUnLock())
		EndIf
	EndIf

Return(_cNum)
