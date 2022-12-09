#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VERTAXA   º Autor ³ Giane - ADV Brasil º Data ³  23/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho para pegar a taxa da moeda do dia da emissao do    º±±
±±º          ³ orcamento                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / orcamento e faturamento                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VerTaxa(cTipo)
	Local _aAreas := {SA1->(GetArea()), GetArea()}
	Local nPProd
	Local nPMoe := 0
	Local nTaxa  := 0
	Local cProd
	Local xMedio := ""
	//Local _lRet := .t.
	Local cCond := '0'
	local lExporta := .F.
	local nTes := 0
	local cTes := ""
	local lTesExport := .F.


	if cTipo == Nil
		cTipo := ""
	endif

	if cTipo == "SC6"
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
		nPMoe  := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMOEDA"})
		xMedio := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMEDIO"})
		nTaxa  := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XTAXA"})
		nTes  := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})

		cProd	:= acols[N,nPProd]
		nPmoe	:= aCols[N,nPmoe]
		xMedio	:= aCols[N,xMedio]
		nTaxa	:= aCols[N,nTaxa]
		cTes	:= aCols[N,nTes]
		cCond	:= M->C5_CONDPAG

		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		if SF4->(dbSeek(xFilial("SF4")+cTes))
			lTesExport := alltrim(SF4->F4_CF) $ '7101/7102/7127/7501/7930/7949'
		endif


		lExporta := lTesExport .or. M->C5_TIPOCLI == 'X'

	elseif cTipo == "SCK"

		cProd	:= TMP1->CK_PRODUTO
		nPmoe	:= TMP1->CK_XMOEDA
		xMedio	:= TMP1->CK_XMEDIO
		nTaxa	:= TMP1->CK_XTAXA
		cCond	:= M->CJ_CONDPAG
	else
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
		nPMoe  := Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_XMOEDA"})
		cProd  := acols[N,nPProd]
		nPmoe := aCols[N,nPmoe]
	endif

	If nPmoe > 1
		IF xMedio != 'N'
			//-----------------------------------------------------
			//Caso o pedido seja exportação verifica a taxa PTAX
			//de compra do dia anterior
			//------------------------------------------------------
			if lExporta
				nTaxa := U_PTAXCOMPRA(ALLTRIM(str(nPmoe,1) ))
			else

				nTaxa := U_BSCTAXAPV(nPmoe,xMedio)

			ENDIF

		ENDIF
	ELSE
		nTaxa := 1

	Endif

	aEval(_aAreas, {|_aArea| RestArea(_aArea)})
	aSize(_aAreas,0)

Return nTaxa


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³VLDTaxa   º Autor ³ Giane - ADV Brasil º Data ³  23/11/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Gatilho para pegar a taxa da moeda do dia da emissao do    º±±
	±±º          ³ orcamento                                                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Específico MAKENI / orcamento e faturamento                º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VLDTaxa(cTipo)
	Local _aAreas := {SA1->(GetArea()), GetArea()}
	Local nPProd
	Local nPMoe
	Local nTaxa  := 0
	Local cProd
	Local _lRet := .t.
	local lExporta := .F.
	local nTes := 0
	local cTes := ""
	local lTesExport := .F.

	if cTipo == Nil
		cTipo := ""
	endif

	if cTipo == "SC6"
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
		nPMoe  := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_XMOEDA"})
		nTes  := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
		cTes	:= aCols[N,nTes]

		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		if SF4->(dbSeek(xFilial("SF4")+cTes))
			lTesExport := SF4->F4_CF == '7102'
		endif

		dbSelectArea("SA1")
		if SA1->(dbSeek(xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI)))
			lExporta := SA1->A1_EST == 'EX' .or. lTesExport
		endif

	else
		nPProd := Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_PRODUTO"})
		nPMoe  := Ascan(aHeader,{|x| AllTrim(x[2]) == "UB_XMOEDA"})
	endif

	cProd  := acols[N,nPProd]

	If aCols[N,nPmoe] > 1

		xCampo := 'M2_MOEDA' + ALLTRIM(str(aCols[N,nPmoe],1))

		if lExporta
			nTaxa := u_ptaxCompra(ALLTRIM(str(nPmoe,1) ), .T.)
		else
			DbSelectArea("SM2")
			DbSetOrder(1)
			If DbSeek(dDataBase)
				nTaxa := SM2->(&xCampo)
			endif
		endif

		IF nTaxa == 0
			Alert("Atenção! Taxa da Moeda não informada para o dia " + dtoc(dDataBase) )
			_lRet := .f.
		endif

	Endif

	aEval(_aAreas, {|_aArea| RestArea(_aArea)})
	aSize(_aAreas,0)

Return _lRet


