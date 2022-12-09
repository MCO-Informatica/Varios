#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410LIOK ºAutor  ³ Fernando Salvatori º Data ³ 12/05/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da Linha do Getdados                             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/	
User Function M410LIOK()
	Local _lRet := .T.

	Local nMaxArray     := Len(aCols) //luiz
	local cProduto  as character
	local cLoteCtl  as character
	local cCodFCI   as character

	IF IsInCallStack("MATA311")

		RETURN(.T.)

	Endif

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "M410LIOK" , __cUserID )
	IF !(M->C5_TIPO $ "DB" )
		IF SuperGetMV("ES_VLIMPPV", ,.F.) .AND. SA1->A1_EST <> "EX"

			cProduto := aCols[N,GDFieldPos("C6_PRODUTO")]
			cTipoPrd 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto , "B1_TIPO" )

			If (aCols[N,GDFieldPos("C6_XICMEST")] <=0 )
				MsgInfo("O Campo Aliq. ICMS, está zerado!","Atenção")
			Endif
			IF (cTipoPrd $ 'MR|PA')
				if (aCols[N,GDFieldPos("C6_XPISCOF")] <=0 )
					MsgInfo("O Campo Aliq. Pis/Cof, está zerado!","Atenção")
				EndIf
			EndIf
		EndIf
	EndIf

	If aCols[N,GDFieldPos("C6_PRUNIT")] <> aCols[N,GDFieldPos("C6_PRCVEN")]
		aCols[N,GDFieldPos("C6_PRUNIT")] := aCols[N,GDFieldPos("C6_PRCVEN")]
	EndIf
//luiz validação de produtos incompativeis
/*  verificar deletados
	For nP := 1 To Len(aCols)
		If aCols[nP][Len(aHeader)+1] //Se Retornar Verdadeiro .t. Esta Deletada
Vdel := .T.
		Endif
	Next nP
*/
	Cont:= nMaxArray
	While Cont > 1
		IF !GDDeleted( Cont ) .AND. !GDDeleted( Cont -1 )
			cProduto1 := aCols[nMaxArray,GDFieldPos("C6_PRODUTO")]
			cProduto2 := aCols[(Cont-1),GDFieldPos("C6_PRODUTO")]

			cONU1 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1__CODONU" )
			cLinha1 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1_SEGMENT" )

			cONU2 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1__CODONU" )
			cLinha2 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1_SEGMENT" )

			If cLinha1 $ "000005|000006|000007" .and. !Empty( cONU2 ) .and. cLinha1 <> cLinha2
				MSGSTOP(" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 ,"Atenção")
				_lRet := .F.
			Endif

			If cLinha2 $ "000005|000006|000007" .and. !Empty( cONU1 ) .and. cLinha1 <> cLinha2 .AND. _lRet == .T.
				MSGSTOP ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 ,"Atenção")
				_lRet := .F.
			Endif

			ZAA->( dbSetOrder( 1 ) )
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
				MSGSTOP ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 ,"Atenção")
				_lRet := .F.
			Endif

			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
				MSGSTOP ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 ,"Atenção")
				_lRet := .F.
			Endif

			ZAA->( dbSetOrder( 2 ) )
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
				MSGSTOP ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 ,"Atenção")
				_lRet := .F.
			Endif

			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
				MSGSTOP ("Produto: " + cProduto1 + " Incompativel Produto: " ,"Atenção")
				_lRet := .F.
			Endif
		ENDIF

		Cont := Cont-1
	enddo

//--------------------------------------------------
//Verifica o código FCI de produtos que originados
//do processo de envase
//--------------------------------------------------
	cProduto := aCols[N,GDFieldPos("C6_PRODUTO")]
	cLoteCtl := aCols[N,GDFieldPos("C6_LOTECTL")]

	if !empty(cLoteCtl) .and. empty(aCols[N,GDFieldPos("C6_FCICOD")])
		cCodFCI := FCIUTILS():getFciCode(cProduto,cLoteCtl)
		if !empty(cCodFci)
			aCols[N,GDFieldPos("C6_FCICOD")] := cCodFci
		endif
	endif
/*
	if  !EMPTY(GDFIELDGET("C6_NUMORC",N))
Alert("Não é Permitido incluir itens em Pedido gerado via orçamento.")
_lRet := .F.
	endif
*/

	if  !EMPTY(GDFIELDGET("C6_NFORI",N))
		IF EMPTY(GDFIELDGET("C6_SERIORI",N))
			MSGSTOP("Se referenciar a [ N.F Original ] , Deverá preencher o Campo [Serie Ori.] ","Atenção")
			_lRet := .F.
			IF EMPTY(GDFIELDGET("C6_ITEMORI",N))

				MSGSTOP("Se referenciar a [ N.F. Original ] , Deverá preencher o Campo [Item Ori.]","Atenção")
				_lRet := .F.
			endif
		endif
	endif

	cTes := aCols[N,GDFieldPos("C6_TES")]
	nQTDVEN := aCols[N,GDFieldPos("C6_QTDVEN")]
	nPRCVEN := aCols[N,GDFieldPos("C6_PRCVEN")]
	
	IF CEMPANT <> '04'
		TESTEIMP(N, cProduto, cTes, nQTDVEN, nPRCVEN)
	ENDIF

Return _lRet

/*/{Protheus.doc} TESTEIMP
	(on)
	
	@since 05/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function TESTEIMP(nLin , cPrd,cTES,nQTD,nPrcUni)

	Local nAliqICMS	:= (aCOLS[nLin , GDFieldPos( 'C6_XICMEST', aHeader)] )
	Local nAliqPCC	:= (aCOLS[nLin , GDFieldPos( 'C6_XPISCOF', aHeader)])

	// Calculo ST e Outros Impostos
	MaFisIni(M->C5_CLIENTE,M->C5_LOJACLI,"C","N",M->C5_TIPOCLI,MaFisRelImp("MATA410",{"SC5","SC6"}),,,"SB1","MATA410")
	MaFisAdd( cPrd,;
		cTES,;
		nQTD,;
		nPrcUni,;
		0,;
		"",;
		"",;
		0,;
		0,;
		0,;
		0,;
		0,;
		(nQTD*nPrcUni),;
		0,;
		0,;
		0)
	_nAliqPCC 	:= MaFisRet(nLin,"IT_ALIQPS2") + MaFisRet(nLin,"IT_ALIQCF2")
	_nAliqIcm	:= MaFisRet(nLin,"IT_ALIQICM")
	_nValIcm	:= MaFisRet(nLin,"IT_VALICM" )
	_nAliqIpi	:= MaFisRet(nLin,"IT_ALIQIPI")
	_nValIpi	:= MaFisRet(nLin,"IT_VALIPI")
	_nValPis	:= MaFisRet(nLin,"IT_VALPS2")
	_nValCof	:= MaFisRet(nLin,"IT_VALCF2")
	
	IF _nAliqIcm <> nAliqICMS
		MSGALERT("Aliquota de ICMS Informada "+TRANSFORM(nAliqICMS,"@E 99.99") +;
			" É Diferente do Calculado "+TRANSFORM(_nAliqIcm,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
	ENDIF

	IF _nAliqPCC <> nAliqPCC
		MSGALERT("Aliquota de PIS / COFINS Informada "+TRANSFORM(nAliqPCC,"@E 99.99") +;
			" É Diferente do Calculado "+TRANSFORM(_nAliqPCC,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
	ENDIF

RETURN()
