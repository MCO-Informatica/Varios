//Bibliotecas
#Include "Protheus.ch"

/*---------------------------------------------------------------------------------*
 | P.E.:  A415LIOK                                                                 |
 | Desc.: Ponto de entrada para validar o preço na linha de digitação do orçamento |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6784038             |
 *---------------------------------------------------------------------------------*/
 
User Function A415LIOK()
    Local aArea := GetArea()
    Local aAreaCJ := SCJ->(GetArea())
    Local aAreaCK := SCK->(GetArea())
    Local lRet := .T.   
    Local cProduto1 := " "  
    Local cProduto2 := " "

	Local aAreaTMP1 := {}
	Local xDitrib := " " 
	
	
	xDistrib :=  Posicione( "SA1", 1, xFilial( "SA1" ) + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA , "A1_XDISTR" )

	If ( TMP1->CK_FLAG )
		cProduto1 := " "  
	    cProduto2 := " " 
	    lRet := .T.   
	Else


		cProduto1 :=	TMP1->CK_PRODUTO
		
		aAreaTMP1 := GetArea()
		TMP1->(Dbgotop())
		
		nCont := TMP1->(LASTREC())
		nInicia := 1
			
		While TMP1->(!EOF())
		
			If ( !TMP1->CK_FLAG )
		
				cProduto2 := TMP1->CK_PRODUTO
				
				cONU1 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1__CODONU" )
				cLinha1 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1_SEGMENT" )

				cONU2 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1__CODONU" )
				cLinha2 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2, "B1_SEGMENT" )

				cGrupo1 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto1 , "B1_GRUPO" )
				cGrupo2 := Posicione( "SB1", 1, xFilial( "SB1" ) + cProduto2 , "B1_GRUPO" )
				
				If cGrupo1 == "0298" .and. xDitrib =="1"
					Alert (" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif

				If cGrupo2 == "0298" .and. xDitrib =="1"
					Alert (" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif

				If cLinha1 $ "000005|000006|000007" .and. !Empty( cONU2 ) .and. cLinha1 <> cLinha2 .AND. lRet == .T.
					Alert (" Produto: " + cProduto1 + " Incompativel Com Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif
			
				If cLinha2 $ "000005|000006|000007" .and. !Empty( cONU1 ) .and. cLinha1 <> cLinha2 .AND. lRet == .T.
					Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif
			
				ZAA->( dbSetOrder( 1 ) )
				If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )   .AND. lRet == .T.
					Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))  
					lRet := .F.
				Endif

				If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )   .AND. lRet == .T.
					Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif

				ZAA->( dbSetOrder( 2 ) )
				If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) ) .AND. lRet == .T.
					Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif
			
				If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) ) .AND. lRet == .T.
					Alert ("Produto: " + cProduto1 + " Incompativel Produto: " + cProduto2 + Chr( 13 ) + Chr( 10 ))
					lRet := .F.
				Endif

			Endif
		
			TESTEIMP( M->CJ_CLIENTE,M->CJ_LOJA, M->CJ_TIPOCLI,TMP1->CK_ITEM , cProduto1,TMP1->CK_TES,;
				TMP1->CK_QTDVEN,TMP1->CK_PRCVEN,TMP1->CK_XICMEST,TMP1->CK_XPISCOF,.T.)

			TMP1->(dbskip()) 
		Enddo


		RestArea(aAreaTMP1)  
		  
		if !l415Auto .and. !isInCallStack("U_SFINRCTL")
  			oGetDad:Refresh() 
  			oGetDad:ForceRefresh()  
  			oGetDad:oBrowse:Refresh()
			
  			GetDRefresh() 
		endif
		
    	Restarea(aAreaCK)
    	RestArea(aAreaCJ)
    	RestArea(aArea)
	Endif

Return lRet

Static Function TESTEIMP(cCli, cLoja, cTpCli, nLin,cPrd,cTES,nQTD,nPrcUni,nAliqICMS, nAliqPCC, lValid)

	DEFAULT nAliqICMS	:= 0
	DEFAULT nAliqPCC	:= 0

MaFisSave()
MaFisEnd()
IF IsInCallStack("MATA415")

	MaFisIni(cCli,;// 1-Codigo Cliente/Fornecedor
			cLoja,;	// 2-Loja do Cliente/Fornecedor
			"C",;	// 3-C:Cliente , F:Fornecedor
			"N",;	// 4-Tipo da NF
			cTpCli,;// 5-Tipo do Cliente/Fornecedor
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461",;
			Nil,;
			Nil,;
			"")
	MaFisAdd( cPrd,	cTES, nQTD,	nPrcUni,0,"","",0,0,0,0,0,(nQTD*nPrcUni),0,0,0)

	_BASEICM    := MaFisRet(1,"IT_BASEICM")
	_ALIQICM    := MaFisRet(1,"IT_ALIQICM")
	_QUANTIDADE := MaFisRet(1,"IT_QUANT")
	_VALICM     := MaFisRet(1,"IT_VALICM")
	_FRETE      := MaFisRet(1,"IT_FRETE")
	_VALICMFRETE:= MaFisRet(1,"IT_ICMFRETE")
	_DESCONTO   := MaFisRet(1,"IT_DESCONTO")
	_nValPis	:= MaFisRet(1,"IT_VALPS2")
	_nValCof	:= MaFisRet(1,"IT_VALCF2")				
	_nAliqPCC 	:= MaFisRet(1,"IT_ALIQPS2") + MaFisRet(1,"IT_ALIQCF2")
				
ELSE
	// Calculo ST e Outros Impostos
	MaFisIni(cCli, cLoja, "C","N",cTpCli,MaFisRelImp("MATA410",{"SC5","SC6"}),,,"SB1","MATA410")
	MaFisAdd( cPrd,	cTES, nQTD,	nPrcUni,0,"","",0,0,0,0,0,(nQTD*nPrcUni),0,0,0)

	_nAliqPCC 	:= MaFisRet(1,"IT_ALIQPS2") + MaFisRet(1,"IT_ALIQCF2")
	_nAliqIcm	:= MaFisRet(1,"IT_ALIQICM")
	_nValIcm	:= MaFisRet(1,"IT_VALICM" )
	_nAliqIpi	:= MaFisRet(1,"IT_ALIQIPI")
	_nValIpi	:= MaFisRet(1,"IT_VALIPI")
	_nValPis	:= MaFisRet(1,"IT_VALPS2")
	_nValCof	:= MaFisRet(1,"IT_VALCF2")
ENDIF

MaFisEndLoad(1,1)
if lValid
	IF _ALIQICM <> nAliqICMS 
		MSGALERT("Aliquota de ICMS Informada "+TRANSFORM(nAliqICMS,"@E 99.99") +;
			" É Diferente do Calculado (Planilha) "+TRANSFORM(_ALIQICM,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
	ENDIF

	IF _nAliqPCC <> nAliqPCC
		MSGALERT("Aliquota de PIS / COFINS Informada "+TRANSFORM(nAliqPCC,"@E 99.99") +;
			" É Diferente do Calculado (Planilha) "+TRANSFORM(_nAliqPCC,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
	ENDIF

ELSE

	IF !(EMPTY(SA1->A1_SUFRAMA))
		_ALIQICM := 0
	ENDIF

	IF SB1->B1_TIPO == 'MA'
		_ALIQICM := 0
	ENDIF

	TMP1->CK_XICMEST := _ALIQICM
	TMP1->CK_XPISCOF := _nAliqPCC

ENDIF

RETURN()
