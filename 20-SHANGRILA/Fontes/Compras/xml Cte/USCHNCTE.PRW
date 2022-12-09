#INCLUDE "Protheus.CH"
#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUSCHNCTE  บAutor  ณFrancisco Godinho   บ Data ณ  07/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Schedule Gera็ใo automatica da Nota de Entrada - CT-e      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shangrila                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FuncTion USCHNCTE(aParam)

	Private errStr  := ""
	Private warnStr := ""
	Private nTotMerc := 0
	Private lChkSefaz := .F. // SuperGetMv("GO_CHKSEFA",.T.,.F.)
	Private oXml    := Nil
	Private a_Xml := {}
	Default aParam := {"01","01",.T.}
	If aParam[3]
		private yFil := aParam[2]
		//xEmp := If(xEmp==Nil, "01",xEmp)
		//xFil := If(xFil==Nil, "01",xFil)
		xx:="1"
		IF FindFunction("WFPREPENV")
			//	CONOUT("aparam USCHNCTE "+aParam[1]+"tipo"+valtype(aParam[1]))
			WFPREPENV(aParam[1], aParam[2])
		ELSE
			PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		ENDIF
		x_ProcCte()
	Else
		private yFil := cFilAnt
		MsAguarde({|| x_ProcCte()},"Gerando CT-e ...")
	EndIf


Static FuncTion x_ProcCte()
// Checa se o xml e referente a CTRC
	cTag1 := "<cteProc"
	cTag2 := "<CTe"
	cTag3 := "<infCte"
	cTag4 := "<infNF"

	xcodTransp  := "" //Codigo da Transportadora
	xcodRedesp  := "" //Codigo do Redespacho
	xcodClient  := "" //Codigo do Cliente
	xtpFrt 		:= "" //Tipo do Frete
	xtpfrtrd 	:= "" //Tipo do Redespacho

	c_DocRef	:= 0 //Add 09022021
	c_SerRef	:= 0 //Add 09022021

	cQuery := "Select R_E_C_N_O_ AS NREG From "+RetSqlName("ZZS")
	cQuery += " Where D_E_L_E_T_ = '' AND "
	cQuery += "  ZZS_FILIAL = '" + xFilial("ZZS") + "' AND "
	cQuery += "  ZZS_ESPECI = 'CTE' "
	cQuery += " AND  ZZS_STATUS NOT IN ('6','1','F') " // Gerado // ('0','1','5')" //09.02.2021 Adicionado a op็ใo F - Divergencia do Fiscal.
//cQuery += " AND   ZZS_CGC = '20147617002276'"
//35120642934489000208570020000344371008144330-cte
	cQuery := ChangeQuery( cQuery )
	xx:= "1"
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )
	xx:= "1"
	DbSelectArea("TRB")
	If ! TRB->(Eof())
		TRB->(DbGoTop())
		While ! TRB->(Eof())
			n_Reg := TRB->NREG
			DbSelectArea("ZZS")
			DbGoTo(n_Reg)
			cXMLFile   := ZZS->ZZS_XML
			_cFilial   := ZZS->ZZS_FILIAL
			_cDoc      := ZZS->ZZS_DOC
			_cSerie    := ZZS->ZZS_SERIE
			_cFilial   := ZZS->ZZS_FILIAL
			cNomeFor   := ""
			_cProduto  := SuperGetMv("AG_PRODCTE",,"60010021")
			cProdFret  := _cProduto
			cChaveNfe  := ZZS->ZZS_CHAVE

			dDEmissao  := ZZS->ZZS_EMISSAO
			_cCnpj     := ZZS->ZZS_CGC
		/*
		// CTE - Importacao
			IF _cCnpj $ "01777936000196|69151595000506"  // Processo de Importacao EAD AURORA - TSA  -
			_cProduto := "60010032"
			cProdFret := _cProduto
			EndIf
			If _cCnpj $ "07369632000176"      // TRANSCR
			_cProduto := "60010033"
			cProdFret := _cProduto
			EndIf
		*/
			cXML := ZZS->ZZS_XML
			cXML := StrTran(cXML,CHR(13),'')
			cXML := StrTran(cXML,CHR(10),'')

			If '>' # Substr(cXML,Len(cXML),1)
				cXML := cXML +">"
			EndIf
			Conout("Processando Chave: " + cChaveNfe )
			lCteproc := .F.
			l_Saida   := .F.
			l_Entrada := .F.

			cTag1 := "<cteProc"
			nPosTag1 := At(cTag1,cXML)

			oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

			x_NomeXml := ""
			If nPosTag1 > 0
				lCteproc := .T.
			EndIf

			If lCteproc
				x_NomeXml := oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
				cCodMIni :=	oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT
				cMuniIni := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT
				cUfIni   := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT

				cCodMFim := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT
				cMuniFim := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
				cUfFim   := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT
			Else
				x_NomeXml := oXml:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
				cCodMIni :=	oXml:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT
				cMuniIni := oXml:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT
				cUfIni   := oXml:_CTE:_INFCTE:_IDE:_UFINI:TEXT

				cCodMFim := oXml:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT
				cMuniFim := oXml:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
				cUfFim   := oXml:_CTE:_INFCTE:_IDE:_UFFIM:TEXT
			EndIf
//		aMuni := {"","","",""}
			//        Muni INI          UF INI MUN FIM          UF FIM
			aMuni := {Right(cCodMIni,5),cUfIni,Right(cCodMFim,5),cUfFim}
		/*
		<cMunEnv>3550308</cMunEnv>   -- >
		<xMunEnv>SAO PAULO</xMunEnv> -- >
		<UFEnv>SP</UFEnv>            -- >
		<modal>01</modal>
		<tpServ>0</tpServ>
		<cMunIni>3550308</cMunIni>
		<xMunIni>SAO PAULO</xMunIni>
		<UFIni>SP</UFIni>
		<cMunFim>3304557</cMunFim>          -- >
		<xMunFim>RIO DE JANEIRO</xMunFim>   -- >
		<UFFim>RJ</UFFim>		            -- >
		*/
			DbSelectArea("SA2") // Fornecedor
			DbSetOrder(3)       // CNPJ
			If DbSeek(xFilial("SA2") + _cCnpj )
				cFornec := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_COD")
				cLoja   := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_LOJA")
				c_UFEmit:= Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_EST")
				cNomeFor:= Alltrim(SA2->A2_NOME)
				_cCPgto := Posicione("SA2",3,xFilial("SA2") + _cCnpj , "A2_COND")    // pegar da transportadora fornecedor

				DbSelectArea("ZZS")
				RecLock("ZZS",.F.)
				ZZS->ZZS_CLIFOR := cFornec
				ZZS->ZZS_LOJA   := cLoja
				MsUnlock()
			Else
				// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota; 8=Sem regra
				DbSelectArea("ZZS")
				RecLock("ZZS",.F.)
				ZZS->ZZS_STATUS := "5"
				MsUnlock()
				DbSelectArea("ZZT")
				RecLock("ZZT",.T.)
				ZZT->ZZT_FILIAL := _cFilial
				ZZT->ZZT_CHAVE  := cChaveNfe
				ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
				ZZT->ZZT_OCORRE := "Fornecedor Nใo Cadastrado. CNPJ: "+_cCnpj + " -  " + Alltrim(x_NomeXml)
				MsUnlock()
				CONOUT("[ USCHNCTE ] - " + ZZT->ZZT_OCORRE)
				aadd(a_Xml,{cChaveNfe,ZZT->ZZT_OCORRE,"5"})
				DbSelectArea("TRB")
				TRB->(DbSkip())
				Loop
			EndIf
			l_UFTra := If(c_UFEmit == SM0->M0_ESTCOB,.T.,.F.) // UF da Transportadora

			_nBaseIcms := _nAliqIcm := _nValIcm := 0

			If lCteproc
				oDest   :=oXML:_CTEPROC:_CTE:_INFCTE:_DEST
				If Type("oDest:_CPF") <> "U"
					c_DestCNPJ := oDest:_CPF:TEXT
				Else
					c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
				EndIf
				c_RemCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
				nVlrFrete := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT
				dEmissao  := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
				_xDtEmiss := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
				If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
					_nValIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
					_nAliqIcm := Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
					_nBaseIcms:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
				EndIf
			Else
				oDest   :=oXML:_CTE:_INFCTE:_DEST
				If Type("oDest:_CPF") <> "U"
					c_DestCNPJ := oDest:_CPF:TEXT
				Else
					c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
				EndIf
				c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT

				nVlrFrete  := oXml:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT
				_xDtEmiss  := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
				dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
				If Type("oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00") <> "U"
					_nValIcm   := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
					_nAliqIcm  := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
					_nBaseIcms := Val(oXml:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
				EndIf
			EndIf
			nVlUnit   := nVlrFrete
			nValMerc  := nVlrFrete
			__xDtXml := Ctod(Substr(_xDtEmiss,9,2)+"/"+Substr(_xDtEmiss,6,2) +"/"+Left(_xDtEmiss,4))
			dbSelectArea("SM0")
			nRegSM0 := SM0->(Recno())
			dbSetOrder(1)
			SM0->(DbGoTop())
			While SM0->(!Eof())
				If c_RemCNPJ == SM0->M0_CGC // Se remetente do Frete for Shangrila frete s/ Venda
					l_Saida := .T.
					_cEmp := SM0->M0_CODIGO
					_cFil := SM0->M0_CODFIL
					Exit
					//aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
				EndIf
				If c_DestCNPJ == SM0->M0_CGC // Se Destino do Frete for Shangrila frete s/ Compra
					l_Entrada := .T.
					_cEmp := SM0->M0_CODIGO
					_cFil := SM0->M0_CODFIL
					Exit
					// aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
				EndIf
				SM0->(dbSkip())
			Enddo
			SM0->(DbGoTo(nRegSM0))
			nQtd := 1
			If !l_Entrada .And. ! l_Saida
				aadd(a_Xml,{cChaveNfe," Destino/Remetente nao e a AgroZootec","2"})
				TRB->(DbSkip())
				Loop
			EndIf
			DbSelectArea("TRB")
			// Pega documento de Origem
			aDocOrigem :=  NFORIG(oXml,cXML,lCteproc)
			l_DocOrig := .F.
			c_LogDocO := "Documento Original ja lancado na NF: "
			For nD:= 1 To Len(aDocOrigem)
				c_DocRef := StrZero(Val(aDocOrigem[nD][1]),9)
				c_SerRef := StrZero(Val(aDocOrigem[nD][2]),3)
				cQuery := "Select * from " + RetSqlName("SD1")
				cQuery += " where D1_DOC = '"+_cDoc+"' AND D1_NFORI ='" + c_DocRef + "' and D1_SERIORI = '" + c_SerRef + "' AND D_E_L_E_T_ = ''"

				cQuery := changequery(cQuery)

				If Select("QRY") <> 0
					dbSelectArea("QRY")
					dbCloseArea("QRY")
				EndIf

				TCQUERY cQuery NEW ALIAS "QRY"

				dbSelectArea("QRY")
				dbGoTop()
				do While !EOF()
					l_DocOrig := .T.
					aadd(a_Xml,{cChaveNfe,"Documento Original " + c_DocRef + "-" + c_SerRef + " ja lancado na NF: " + QRY->D1_DOC +"/"+QRY->D1_SERIE ,"9"})
					c_LogDocO +=  "Documento Origem Frete: " + c_DocRef + "/" + c_SerRef + " NF.: " + QRY->D1_DOC + "/" + QRY->D1_SERIE + " "
					QRY->(DbSkip())
				EndDo
			Next
			xx := "1"
			If l_DocOrig
				DbSelectArea("ZZT")
				RecLock("ZZT",.T.)
				ZZT->ZZT_FILIAL := _cFilial
				ZZT->ZZT_CHAVE  := cChaveNfe
				ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
				ZZT->ZZT_OCORRE := c_LogDocO
				MsUnlock()
			EndIf
			_cNFCli:= ""
			cQry3 := ""

			//Valida็ใo do Fiscal 09.02.2021
			/*
			If cValtochar(c_DocRef) <> ''

				_cNFCli:= SUBSTR(cValtochar(c_DocRef),4,6)

				cQry3:= "SELECT F2_DOC, D2_SERIE, F2_CLIENTE, A1_NOME, F2_TPFRETE,F2_TRANSP, F2_REDESP  "
				cQry3+= "LEFT JOIN SA1010 ON A1_COD = F2_CLIENTE AND SA1010.D_E_L_E_T_ = '' "
				cQry3+= "FROM SF2010 "
				cQry3+= "WHERE SF2010.D_E_L_E_T_ = '' AND F2_TIPO = 'N' AND D2_DOC = '"+_cNFCli+"' AND F2_SERIE = '0' "

				cQry3	:=	ChangeQuery(cQry3)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry3),"SF2QRY",.T.,.T.)

				DbSelectArea("SF2QRY")
				While SF2QRY->(!Eof())

					_cCFOP := LISTCFOP->D2_CF + _cCFOP
					LISTCFOP->(DbSkip())

				EndDo
				dbSelectArea("SF2QRY")
				dbCloseArea("SF2QRY")

				Alert ("NF"+cValtochar(c_DocRef)+"-Serie-"+cValtochar(c_SerRef) )
				// Alert (cValtochar(c_SerRef))



				DbSelectArea("ZZS")
				DbGoTo(n_Reg)
				RecLock("ZZS",.F.)
				ZZS->ZZS_STATUS := 'F'
				//ZZS->ZZS_DTHORA := DTOC(Date()) +" "+ Substr(Time(),1,5)
				MsUnlock()

				Exit
				//TRB->(DbSkip())
				//Enddo


			Endif
			*/
			dbSelectArea( "SB1" )
			SB1->( dbSetOrder( 01 ) )
			SB1->( dbSeek( xFilial( "SB1" ) + _cProduto ) )

			_cTes		 := SB1->B1_TE
			_cCC      := ""
			_cNat     := ""
			_cItemCtb := ""
			xx := "1"
			//		If l_Saida

			CONOUT("Origem Vendas...")
			xx := "1"

			_aItens    := {}
			nVlrNF     := Val(nValMerc) / Len(aDocOrigem)
			_nBaseIcms := _nBaseIcms   / Len(aDocOrigem)
			_nValIcm   := _nValIcm     / Len(aDocOrigem)
			nVlUnit    := nVlrNF
			nValMerc   := nVlrNF
			For nD:= 1 To Len(aDocOrigem)
				cDocRef := StrZero(Val(aDocOrigem[nD][1]),9)
				cSerRef := aDocOrigem[nD][2]
				Aadd(_aItens,{"N",cFornec,cLoja,cProdFret,_cNat,_cTes,_cCC,_cItemCtb,nQtd,nVlUnit,nValMerc,cDocRef,cSerRef,"",nQtd,"","", _nAliqIcm , _nBaseIcms,_nValIcm})
			Next
			xx:= "1"
			lGeraReg :=  ProcDocE("N",_cFil, cFornec, cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,aMuni,nValMerc)
			DbSelectArea("ZZS")
			DbGoTo(n_Reg)
			RecLock("ZZS",.F.)
			ZZS->ZZS_STATUS := If(lGeraReg,'6','7')
			ZZS->ZZS_DTHORA := DTOC(Date()) +" "+ Substr(Time(),1,5)
			MsUnlock()
			If lGeraReg
				// aadd(a_Xml,{cChaveNfe,"Gerada a Nota de entrada ","3"})
			Else
				aadd(a_Xml,{cChaveNfe,"Nota de entrada nao Gerada na execucao automatica ","7"})
			EndIf
			DbSelectArea("TRB")
		/*
		Else
		//		9 - Xml CT-e de Compra
		DbSelectArea("ZZS")
		RecLock("ZZS",.F.)
		ZZS->ZZS_STATUS := "9"
		MsUnlock()
		DbSelectArea("ZZT")
		RecLock("ZZT",.T.)
		ZZT->ZZT_FILIAL := _cFilial
		ZZT->ZZT_CHAVE  := cChaveNfe
		ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
		ZZT->ZZT_OCORRE := "Xml CT-e de Compra	"
		MsUnlock()
		aadd(a_Xml,{cChaveNfe,"Xml CT-e de Compra ","9"})
		
		EndIf
		*/
		xx:= "1"
		oXml := Nil
		DelClassIntf()
		TRB->(DbSkip())
	EndDo
EndIf
If Len(a_Xml) > 0
	// Envia notificacao
	aImpLog:= {}
	For nI:= 1 To Len(a_Xml)
		nPosIm:= aScan(aImpLog,{|x| x[1] == a_Xml[nI][3]})
		If nPosIm == 0 .Or. val(a_Xml[nI][3]) == 9
			aadd(aImpLog,{a_Xml[nI][3],a_Xml[nI][2],1})
		Else
			aImpLog[nPosIm][3] += 1
		EndIf
	Next

	aSort(aImpLog,,,{|x,y| x[1]<y[1]})

	AIMSGENV(aImpLog)
EndIf
Return

/*******************************************************************************/
Static FuncTion ProcDocE(_cTipoNf,_cFilial,_cFornece,_cLoja,_cDoc,_cSerie,cChaveNfe,_aItens,__xDtXml,aMuni,nValMerc)
/*******************************************************************************/
	Local _lRet := .T.
	Local nI := 1
	PRIVATE aRotina := MenuDef2()
	XX:= "1"
//If Len(_aItens) == 0
//	CONOUT("Nota - " + _cDoc + " Nao foi gerada!")
//	_lRet := .F.
//Else
//	If _cTipoNf $ "N,C" // Nota Fiscal ou Conhecimento
// _cSerie   := If(Val(_cSerie) == 0," ",_cSerie)
	_cDoc     := StrZero(Val(_cDoc),9)
	_cNFiscal := _cDoc
	__xDtXml := __xDtXml
	_cTipoNf := "N"
	iF nValMerc = 0
		_cTipoNf := "I" // icms
	EndiF

	_aCab := {}
	AAdd( _aCab, { "F1_TIPO"	 	, _cTipoNf   	, nil } )   // 	Tipo da NF				: Obrigatorio
	AAdd( _aCab, { "F1_FORMUL"	 	, "N"        	, nil } )   // 	Formulario Proprio	: Obrigatorio
	AAdd( _aCab, { "F1_DOC"      	, _cDoc	  		, nil } )   // 	Numero da NF			: Obrigatorio
	AAdd( _aCab, { "F1_SERIE"	 	, _cSerie    	, nil } )   // 	Serie da NF		    	: Obrigatorio
	AAdd( _aCab, { "F1_FORNECE"  	, _cFornece  	, nil } )   // 	Codigo do Fornecedor	: Obrigatorio
	AAdd( _aCab, { "F1_LOJA"	 	, _cLoja     	, nil } )   // 	Loja do Fornecedor	: Obrigatorio
	AAdd( _aCab, { "F1_EMISSAO"  	, __xDtXml   	, nil } )   //	Emissao da NF			: Obrigatorio
	AAdd( _aCab, { "F1_ESPECIE"  	, "CTE  "    	, nil } )   // 	Especie
	AAdd( _aCab, { "F1_FILIAL"   	, _cFilial   	, nil } )   // 	Filial
	AAdd( _aCab, { "F1_CHVNFE"   	, cChaveNfe  	, nil } ) 	//	Chave Nfe
	AAdd( _aCab, { "F1_COND"	 	, _cCPgto    	, nil } )   // 	Condicao
	AAdd( _aCab, { "F1_MUORITR"	 	, aMuni[1]  	, nil } )   // Municipio Original Transp
	AAdd( _aCab, { "F1_UFORITR"	 	, aMuni[2]   , nil } )   // Uf Origem do transporte
	AAdd( _aCab, { "F1_MUDESTR"	 	, aMuni[3]   , nil } )   // Municipio Destino Transpo
	AAdd( _aCab, { "F1_UFDESTR"	 	, aMuni[4]   , nil } )   // UF Destino do Transporte
	AAdd( _aCab, { "F1_TPCTE"       , "N"        , nil } )   // Tipo de CT-e
	AAdd( _aCab, { "F1_MODAL"       ,"01=Rodoviario", nil } )   // Modal
//         Muni INI           UF INI MUN FIM           UF FIM
//aMuni := {Right(cCodMIni,5),cUfIni,Right(cCodMFim,5),cUfFim}
//aMuni := {Right(cCodMIni,5),cUfIni,Right(cCodMFim,5),cUfFim}
	If Len(_aItens) > 0
		_cNFOri   := _aItens[1][12]
		_cSerOri  := _aItens[1][13] // iif(len(ALLTRIM(_aItens[nI][13])) > 1, iif(right(_aItens[nI][13],1)!="0",right(_aItens[nI][13],1),_aItens[nI][13]),ALLTRIM(_aItens[nI][13]))
//	AAdd( _aCab, { "F1_NFCFRT"	 	, _cNFOri    	, nil } )   // 	Nota de Origem
//	AAdd( _aCab, { "F1_SRCFRT"	 	, _cSerOri    	, nil } )   // 	Serie de Origem
	EndIf


	nTotMerc := 0
	aItens := {}
	For nI:=1 To Len(_aItens)
		//                 1      2       3     4         5     6     7    8     9    10      11       12      13      14 15    16 17
		// 	Aadd(_aItens,{"N",cFornec,cLoja,cProdFret,_cNat,_cTes,_cCC,_cItemCtb,nQtd,nVlUnit,nValMerc,cDocRef,cSerRef,"" ,nQtd,"",""})
		//  Aadd(_aItens,{"N",cFornec,cLoja,cProdFret,_cNat,_cTes,_cCC,_cItemCtb,nQtd,nVlUnit,nValMerc,cDocRef,cSerRef,"",nQtd,"","",nAliqICM})
		_cNumItem := StrZero(nI,4)
		_cProd    := _aItens[nI][4]
		_cNat     := _aItens[nI][5]
		_cTes     := _aItens[nI][6]
		_cCC      := _aItens[nI][7]
		_cItemCtb := _aItens[nI][8]
		_nQtd     := _aItens[nI][9]
		_nValUni  := _aItens[nI][10]
		_nValMer  := _aItens[nI][11]
		_cNFOri   := _aItens[nI][12]
		_cSerOri  := _aItens[nI][13] // iif(len(ALLTRIM(_aItens[nI][13])) > 1, iif(right(_aItens[nI][13],1)!="0",right(_aItens[nI][13],1),_aItens[nI][13]),ALLTRIM(_aItens[nI][13]))
		_nAliqIcm := _aItens[nI][18]
		_nBaseIcms:= _aItens[nI][19]
		_nValIcm  := _aItens[nI][20]
		If _nValMer == 0
			_nValMer := _nValIcm
			_nValUni := _nValIcm
			_nQtd    := 0
		EndIf
		_cLocal   := Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_LOCPAD")
		_cContab  := Posicione("SB1",1, xFilial("SB1") + _cProd,"B1_CONTA")
		_cDescPrd := Upper(Posicione("SB1",1,xFilial("SB1") + _cProd , "B1_DESC") )

		_aLinha   := {}
		AAdd(_aLinha, {"D1_FILIAL"  , _cFilial   ,nil } ) // filial
		AAdd(_aLinha, {"D1_ITEM"	, _cNumItem  ,nil } ) // Item  			: Obrigatorio
		AAdd(_aLinha, {"D1_DOC"		, _cDoc      ,nil } ) // Docto			 	: Obrigatorio
		AAdd(_aLinha, {"D1_SERIE"	, _cSerie    ,nil } ) // Serie			 	: Obrigatorio
		AAdd(_aLinha, {"D1_FORNECE" , _cFornece  ,nil } ) // Fornece			: Obrigatorio
		AAdd(_aLinha, {"D1_LOJA"	, _cLoja     ,nil } ) // loja			 	: Obrigatorio
		AAdd(_aLinha, {"D1_TIPO"	, _cTipoNf   ,nil } ) // loja			 	: Obrigatorio
		AAdd(_aLinha, {"D1_COD"		, _cProd     ,nil } ) // Produto			: Obrigatorio
		AAdd(_aLinha, {"D1_QUANT"	, _nQtd      ,nil } ) // Quantidade		: Obrigatorio
		AAdd(_aLinha, {"D1_VUNIT"	, _nValUni   ,nil } ) // Valor Unitario	: Obrigatorio
		AAdd(_aLinha, {"D1_TOTAL"	, _nValMer   ,nil } ) // Valor Total		: Obrigatorio
// 	AAdd(_aLinha, {"D1_TES"    , _cTes      ,NIL } ) // Tes
		AAdd(_aLinha, {"D1_LOCAL"	, _cLocal    ,nil } ) // Local   		 	: Obrigatorio
		//	AAdd(_aLinha, {"D1_CC"	    , _cCC       ,nil } ) // C.Custos 		 	: Obrigatorio
		AAdd(_aLinha, {"D1_NFORI"   , _cNFOri    ,nil } ) // Pedido Compras   	: Obrigatorio
		AAdd(_aLinha, {"D1_SERIORI" , _cSerOri   ,nil } ) // Item do P.Compra 	: Obrigatorio
		AAdd(_aLinha, {"D1_CONTA"   , _cContab   ,nil } ) // Conta Contabil   	: Obrigatorio
		//			AAdd(_aLinha, {"D1_ITEMCTA" , _cItemCtb  ,nil } ) // Item Contabil   : Obrigatorio
		//			AAdd(_aLinha, {"D1_NATFIN"  , _cNat      ,nil } ) // Natureza Financ. 	: Obrigatorio
		AAdd(_aLinha, {"D1_BASEICM"	, _nBaseIcms ,nil } ) // Percentual Base ICMS
		AAdd(_aLinha, {"D1_PICM"	, _nAliqIcm  ,nil } ) // Percentual Perc. ICMS
		AAdd(_aLinha, {"D1_VALICM"	, _nValIcm   ,nil } ) // Valor ICMS
		//			AAdd(_aLinha, {"D1_XPERC"	, 0          ,nil } ) // Percentual NCC
		aadd(_aLinha, {"AUTDELETA"  ,"N"         ,Nil } ) // Incluir sempre no ultimo elemento do array de cada item

		AAdd( aItens, AClone(_aLinha) )
	Next

	lMsErroAuto := .f.

	DbSelectArea("SF1")
	DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
	If ! DbSeek(xFilial("SF1") + _cFornece + _cLoja + _cDoc )
//	MsExecAuto({|w,x,y,z|MATA103(w,x,y,z)},_aCab,aItens,3,Nil)
		MsExecAuto({|w,x,y,z|MATA140(w,x,y,z)},_aCab,aItens,3,Nil)
		xx:="1"
		IF !lMSErroAuto
			_cMsg := "Pre-Nota de Entrada gerada com sucesso!"
			_lRet := .T.
			_cMsg += " Nf " +_cNFiscal
			DbSelectArea("SF1")
			DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
			If DbSeek(xFilial("SF1") + _cFornece + _cLoja + _cDoc )
				_cMsg := "<SEEK> Nota de Entrada gerada com sucesso!"
				_lRet := .T.
				_cMsg += " Nf " +_cDoc
				RecLock("SF1",.F.)
				SF1->F1_TPCTE:="N"
				MsUnlock()
			EndIf
			CONOUT(_cMsg)
		Else
			DbSelectArea("SF1")
			DbSetOrder(2)  // F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC
			If DbSeek(xFilial("SF1") + _cFornece + _cLoja + _cDoc )
				_cMsg := "<SEEK> Nota de Entrada gerada com sucesso!"
				_lRet := .T.
				_cMsg += " Nf " +_cDoc
				RecLock("SF1",.F.)
				SF1->F1_TPCTE:="N"
				MsUnlock()

				CONOUT(_cMsg)
			Else
				cMemo 	:= MemoRead(NomeAutoLog())  // Le o conteudo do arquivo de LOG e grava na variavel cMemo
				// Mostraerro()
				CONOUT(cMemo)
				DisarmTransaction()
				_lRet := .F.
			EndIf
		EndIf
	Else
		_cMsg := "Nota de Entrada ja se encontra na base!"
		_lRet := .T.
		_cMsg += " Nf " +_cNFiscal
		CONOUT(_cMsg)
	EndIf


	xx:= "1"
Return(_lRet)

/*******************************************************************************/
Static Function MenuDef2()
/*******************************************************************************/
	PRIVATE aRotina	:= {	{ "Pesquisar"	,"AxPesqui"		, 0 , 1, 0, .F.},; //
	{ "Visualizar"	,"A140NFiscal"	, 0 , 2, 0, nil},; //
	{ "Incluir"	,"A140NFiscal"	, 0 , 3, 0, nil},; //
	{ "Alterar"	,"A140NFiscal"	, 0 , 4, 0, nil},; //
	{ "Excluir"	,"A140NFiscal"	, 0 , 5, 0, nil},; //
	{ "Imprimir"	,"A140Impri"  	, 0 , 4, 0, nil},; //
	{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, nil},; //
	{ "Legenda"		,"A103Legenda"	, 0 , 2, 0, .F.}} 	//

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ExistBlock("MTA140MNU")
		ExecBlock("MTA140MNU",.F.,.F.)
	EndIf
Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NFORIG   บAutor  ณMicrosiga           บ Data ณ     08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pega as Origens do Frete no xml                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ USCHNCTE                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static FuncTion NFORIG(oXml,cXML,lCteproc)
	Local a_Docs := {}
	Local cError := ""
	Local cWarning := ""
	oFullXML := XmlParser(cXML,"_",@cError,@cWarning)

	oAuxXml := XmlChildEx(oFullXML:_CTEPROC,"_CTE")
	oAuxInf := XmlChildEx(oAuxXml,"_INFCTE")
	oAuxRem := XmlChildEx(oAuxInf,"_INFCTEANU")
	
	If XmlChildEx(oAuxRem,"_CHCTE") # NIL
		oAuxCtAnu :=  XmlChildEx(oAuxRem,"_CHCTE")
		cXMLNFRef := oAuxCtAnu:TEXT
		cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
		cSerRef   := Substr(cXMLNfRef,23,3)
		cSerRef   := STRTRAN(cSerRef,"0","")
		cSerRef   := Substr(cSerRef+Space(3),1,3)
		aadd(a_Docs,{cDocRef,cSerRef})
		Return(a_Docs)
	EndIf
	If lCteproc
		CONOUT(" NFORIG CteProc...")
		n_Chave := AT("<infNFe><chave>",cXML) // Verifica se foi informado a chave da NF-e na Origem
		If n_Chave > 0
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE") <> "U"
				aRef := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE
				If ValType(aRef) == "A"
					For nI := 1 To Len(aRef)
						cXMLNFRef := aRef[nI]:_CHAVE:TEXT // oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNFE[nI]:_CHAVE:TEXT
						cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
						cSerRef   := Substr(cXMLNfRef,23,3)
						cSerRef   := STRTRAN(cSerRef,"0","")
						cSerRef   := Substr(cSerRef+Space(3),1,3)
						aadd(a_Docs,{cDocRef,cSerRef})
					Next
				Else
					cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					//				cSerRef   := STRTRAN(cSerRef,"0","")
					//				cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				EndIf
			EndIf
		Else
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF	") <> "U"
				aRef := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF
				If ValType(aRef) == "A"
					For nI := 1 To Len(aRef)
						cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
						cSerRef   := aRef[nI]:_SERIE:TEXT
						cSerRef   := STRTRAN(cSerRef,"0","")
						cSerRef   := Substr(cSerRef+Space(3),1,3)
						aadd(a_Docs,{cDocRef,cSerRef})
					Next
				Else
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				EndIf
			EndIf
		EndIf
	Else
		If Type("oXml:_CTE:_INFCTE:_REM:_INFNF:_NDOC") <> "U"
			aRef := oXml:_CTE:_INFCTE:_REM:_INFNF
			If ValType(aRef) == "A"
				For nI := 1 To Len(aRef)
					cDocRef   := Substr(Alltrim(StrZero(Val(aRef[nI]:_NDOC:TEXT),6,0))+Space(9),1,9)
					cSerRef   := aRef[nI]:_SERIE:TEXT
					cSerRef   := STRTRAN(cSerRef,"0","")
					cSerRef   := Substr(cSerRef+Space(3),1,3)
					aadd(a_Docs,{cDocRef,cSerRef})
				Next
			Else
				cDocRef   := Substr(Alltrim(StrZero(Val(aRef:_NDOC:TEXT),6,0))+Space(9),1,9)
				cSerRef   := aRef:_SERIE:TEXT
				cSerRef   := STRTRAN(cSerRef,"0","")
				cSerRef   := Substr(Alltrim(aRef:_SERIE:TEXT)+Space(3),1,3)
				aadd(a_Docs,{cDocRef,cSerRef})
			EndIf
		Else
			If Type("oXML:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE") <> "U"
				c_ChaveRef := oXML:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
				cSerRef     := Alltrim(Str(Val(Substr(c_ChaveRef,23,3)),3,0))
				cDocRef     := Substr(c_ChaveRef,26,9)

				aadd(a_Docs,{cDocRef,cSerRef})

			Else
				Conout(" NFORIG infCte...")
			EndIf
		EndIf
	EndIf
	xx := "'"
	If Len(a_Docs) == 0 // Se nao achou
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHCTE") <> "U" // Existe tag INFCTENORM
			a_Ref := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHCTE
			If ValType(a_Ref) = "A"
				For nA := 1 To Len(a_Ref)
					cXMLNfRef := a_Ref[nA]:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cDocRef   := StrZero(Val(cDocRef),9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
				Next
			Else
				cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHCTE:TEXT
				cDocRef   := Substr(cXMLNfRef,26,9)
				cDocRef   := StrZero(Val(cDocRef),9)
				cSerRef   := Substr(cXMLNfRef,23,3)
				//aadd(a_Docs,{cDocRef,cSerRef})
				aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
			EndIf
		Else
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE") <> "U" // Existe tag INFCTENORM
				a_Ref := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
				If ValType(a_Ref) = "A"
					If Len(a_Ref) > 0
						For nA := 1 To Len(a_Ref)
							cXMLNfRef := a_Ref[nA]:_CHAVE:TEXT
							cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
							cDocRef   := StrZero(Val(cDocRef),9)
							cSerRef   := Substr(cXMLNfRef,23,3)
							aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
						Next
					Else
						cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
						cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
						cDocRef   := StrZero(Val(cDocRef),9)
						cSerRef   := Substr(cXMLNfRef,23,3)
						//aadd(a_Docs,{cDocRef,cSerRef})
						aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
					EndIf
				Else
					cXMLNfRef := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
					cDocRef   := Substr(Alltrim(StrZero(Val(Substr(cXMLNfRef,26,9)),6,0))+Space(9),1,9)
					cDocRef   := StrZero(Val(cDocRef),9)
					cSerRef   := Substr(cXMLNfRef,23,3)
					//aadd(a_Docs,{cDocRef,cSerRef})
					aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
				EndIf
			Else
				xx := "1"
				If Type("oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF") <> "U"
					a_Ref := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF
					If ValType(a_Ref) = "A"
						If Len(a_Ref) > 0
							For nA := 1 To Len(a_Ref)
								cDocRef   := a_Ref[nA]:_NDOC:TEXT
								cSerRef   := a_Ref[nA]:_SERIE:TEXT
								cDocRef   := StrZero(Val(cDocRef),9)
								cSerRef   := StrZero(Val(cSerRef),3)
								aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
							Next
						Else
							cDocRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT
							cDocRef   := StrZero(Val(cDocRef),9)
							cSerRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT
							aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
						EndIf
					Else
						cDocRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT
						cDocRef   := StrZero(Val(cDocRef),9)
						cSerRef   := oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT
						aadd(a_Docs,{cDocRef,cSerRef,"","","",Ctod("")})
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	xx:="1"
Return(a_Docs)


Static FuncTion xGeraSF8(aRecSF1Ori,nRecSF1)

	dbSelectArea("SF1")
	MsGoto(nRecSF1)
	cNfFrete := SF1->F1_DOC
	cSeFrete := SF1->F1_SERIE
	cForFrete:= SF1->F1_FORNECE
	cLojFrete:= SF1->F1_LOJA
	For nX := 1 to Len(aRecSF1Ori)
		dbSelectArea("SF1")
		MsGoto(aRecSF1Ori[nX])
		dbSelectArea("SF8")
		RecLock("SF8",.T.)
		SF8->F8_FILIAL	:= xFilial("SF8")
		SF8->F8_DTDIGIT := SF1->F1_DTDIGIT
		SF8->F8_NFDIFRE	:= cNfFrete
		SF8->F8_SEDIFRE	:= cSeFrete
		SF8->F8_TRANSP	:= cForFrete
		SF8->F8_LOJTRAN	:= cLojFrete
		SF8->F8_NFORIG	:= SF1->F1_DOC
		SF8->F8_SERORIG	:= SF1->F1_SERIE
		SF8->F8_FORNECE	:= SF1->F1_FORNECE
		SF8->F8_LOJA	:= SF1->F1_LOJA
		SF8->F8_TIPO	:= "F"
		MsUnlock()

	Next nX

	dbSelectArea("SF1")
	MsGoto(nRecSF1)
	RecLock("SF1",.F.)
	SF1->F1_ORIGLAN	:= If(SF1->F1_ORIGLAN==" D","FD","F ")
	SF1->F1_OK      := ""
	SF1->F1_TIPO    := "C"
	MsUnlock()

	nSD1Qtd   := 0
	dbSelectArea("SD1")
	dbClearFilter()
	dbSetOrder(1)
	MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	While ( !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
			SD1->D1_DOC    == SF1->F1_DOC    .And.;
			SD1->D1_SERIE  == SF1->F1_SERIE  .And.;
			SD1->D1_FORNECE== SF1->F1_FORNECE.And.;
			SD1->D1_LOJA   == SF1->F1_LOJA )
		RecLock("SD1",.F.,.T.)
		SD1->D1_ORIGLAN   := If(SD1->D1_ORIGLAN==" D","FD","F ")
		SD1->D1_TIPO    := "C"
		MsUnlock()

		dbSelectArea("SD1")
		dbSkip()
	EndDo

Return



Static Function AIMSGENV(aImpLog)
	Local cSubject		:= ""
	Local cxDes			:= ""
	Local cxNomDes		:= ""
	Local cEmailXml		:= AllTrim(SuperGetMv("AG_MAILXML",,"administrativo@agrozootec.com.br")) //
	Local cMail			:= ""
	Local cSMTP			:= ""
	Local cOBS			:= 'e-Mail Enviado automaticamente atrav้s do Schedule Geracao Nota XML Cte - Protheus'
	LOCAL xArea			:= GetArea() //Area atual utilizada
	Local nRegistro		:= ""
	nRegistro:=Recno()

	_cFrom   :=GetMv("MV_RELFROM")

// Autentica Servidor
	_cServer :=GetMv("MV_RELSERV")
	_cUser   :=GetMv("MV_RELACNT")
	_cPass   :=GetMv("MV_RELAPSW")

	mMensagem := "<BODY>"
	mMensagem := mMensagem + "<DIV><FONT face=Arial size=2>O processo de inclusao automatica via xml nao gerou alguns Documento de entrada VERIFICAR: <BR></FONT></DIV>"
	mMensagem+= "<BR>"  //</STRONG>

	For nP:= 1 To Len(aImpLog)
		_cXml 	 := aImpLog[nP][1]
		cOBS 	 := aImpLog[nP][2]
		nQtd 	 := aImpLog[nP][3]
		if !Empty(_cXml)
			mMensagem+= "<BR><STRONG><DIV><FONT face=Arial size=2>&nbsp;&nbsp;&nbsp;Ocorrencia :&nbsp;" + ALLTRIM(_cXml)+" "+cOBS +"<STRONG><BR>Qtd: </STRONG>"+Str(nQtd,8,0)+"&nbsp; </DIV>"
		Endif
	Next

//mMensagem := mMensagem + "<BR><STRONG>OBS: </STRONG>"+cOBS+"<BR>&nbsp; </DIV>"
	mMensagem := mMensagem + "<DIV>&nbsp;</DIV></BODY>"

	cSubject := "Aviso Xml Ct-e Schedule.Filial: "+ yFil

	CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cPass RESULT _lResult

	If _lResult

		lAutentica    := GetMV("MV_RELAUTH")

		If lAutentica
			MailAuth(GetMV("MV_RELAUSR"),GetMV("MV_RELPSW"))
		Endif

		nroTenta := 3
		For nTenta := 1 To nroTenta

			SEND MAIL FROM _cFrom to cEmailXml SUBJECT cSubject  BODY mMensagem RESULT _lFoi

			If _lFoi
				ConOut("E-mail enviado com sucesso.")
				Exit
			Else
				GET MAIL ERROR cErrorMsg
				ConOut("E-mail nao enviado. Erro: "+cErrorMsg+". Tentativa no: "+StrZero(nTenta,2))
			Endif
		Next

		DISCONNECT SMTP SERVER

	EndIf
	RestArea(xArea)
Return
