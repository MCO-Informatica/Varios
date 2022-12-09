#INCLUDE "protheus.ch"
/*/{Protheus.doc} MT103PN
Inclusão de documento de entrada
Este ponto de entrada pertence à rotina de 
manutenção de documentos de entrada, MATA103.
 É executada em A103NFISCAL, na inclusão de 
 um documento de entrada. Ela permite ao 
 usuário decidir se a inclusão será executada ou não.
@type function
@version 1.0
@author leandro.duarte
@since 08/15/2013
@return logical, validação ok?
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6784333
/*/
user function MT103PN()

	Local lRet := .T.
	Local aAreaQE6	:= QE6->(GETAREA())
	Local nPProduto  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})


	QE6->(DBSETORDER(1))
	if !INCLUI
		if len(aCols)>0
			For nFor := 1 to len(aCols)
				IF !QE6->(DBSEEK(XFILIAL("QE6")+aCols[nFor][nPProduto])) .AND. POSICIONE("SB1",1,XFILIAL("SB1")+aCols[nFor][nPProduto],"ALLTRIM(B1_TIPOCQ)")== 'Q'
					lRet := .F.
					MsgAlert( 'Atenção'+CRLF+'Para o Produto:'+alltrim(aCols[nFor][nPProduto])+' é necessario o cadastro da especificação do Produto' , "INFO")
				ENDIF
				if !validSA5(nFor,nPProduto)
					lRet:= .F.
				endif

			next nFor
		endif


	endif
	restarea(aAreaQE6)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103DNF  ºAutor  ³Leandro Duarte      º Data ³  08/15/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de processo para a validação da inclusão sem a especiº±±
±±º          ³ficacao do produto                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MT103DNF()
	Local lRet := .T.
	Local aAreaQE6	:= QE6->(GETAREA())
	Local nPProduto  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})


	if len(aCols)>0
		For nFor := 1 to len(aCols)
			IF !QE6->(DBSEEK(XFILIAL("QE6")+aCols[nFor][nPProduto])) .AND. POSICIONE("SB1",1,XFILIAL("SB1")+aCols[nFor][nPProduto],"ALLTRIM(B1_TIPOCQ)")== 'Q'
				lRet := .F.
				MsgAlert( 'Atenção'+CRLF+'Para o Produto:'+alltrim(aCols[nFor][nPProduto])+' é necessario o cadastro da especificação do Produto' , "INFO")
			ENDIF

			
			if !validSA5(nFor, nPProduto)
				lRet := .F.
			endif
		next nFor

	endif

	restarea(aAreaQE6)

Return(lRet)

/*/{Protheus.doc} validSA5
Validação SA5 produto x fornecedor x loja, quando
for importação e o CQ for pelo materiais.
@type function
@version 1.0
@author marcio.katsumata
@since 17/08/2020
@param nFor, numeric, param_description
@param nPProduto, numeric, param_description
@return return_type, return_description
/*/
static function validSA5(nFor, nPProduto)

	local nPConhec    as numeric
	local nPFabr      as numeric
	local nPFabLoja   as numeric
	local nPFornece   as numeric
	local nPLoja      as numeric
	local cFabric     as character
	local cFabLoja    as character
	local cProdRef    as character
	local lAchou      as logical
	local lReferencia as logical
	local aAreas      as array
	local nPTes       as numeric
	local cProduto    as character


	aAreas     := {SA5->(getArea()), SF4->(getArea())}
	nPConhec   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONHEC"})
	nPFabr     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_FABRIC"})
	nPFabLoja  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOJFABR"})
	nPTes      := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
	lAchou     :=  .T.

	dbSelectArea("SF4")
	SF4->(DbSetOrder(1))
	if SF4->(MsSeek(xFilial("SF4")+aCols[nFor][nPTes])) .and. SF4->F4_ESTOQUE == 'S'

		if !empty(aCols[nFor][nPConhec]) .And. POSICIONE("SB1",1,XFILIAL("SB1")+aCols[nFor][nPProduto],"ALLTRIM(B1_TIPOCQ)") $ " ,M" .and. SB1->B1_EMB <> "AMO"

			cProdRef	:= aCols[nFor][nPProduto]
			lReferencia	:= MatGrdPrrf(@cProdRef,.T.)
			cFabric  := aCols[nFor][nPFabr]
			cFabLoja := aCols[nFor][nPFabLoja]
			cProduto := aCols[nFor][nPProduto]
			cFornece := CA100FOR

			dbSelectArea("SA5")
			SA5->(dbSetOrder(1))

			If !Empty(cFabric) .And. !Empty(cFabLoja)
				lAchou :=  SA5->(MsSeek(xFilial("SA5")+cFornece+cLoja+cProduto+cFabric+cFabLoja,.F.))
			Else
				lAchou := SA5->(MsSeek(xFilial("SA5")+cFornece+cLoja+cProduto+cProduto,.F.))
			EndIf

			If !lAchou .And. lReferencia
				SA5->(dbSetOrder(9))
				If !Empty(cFabric) .And. !Empty(cFabLoja)
					lAchou :=  SA5->(MsSeek(xFilial("SA5")+cFornece+cLoja+cProdRef+cFabric+cFabLoja,.F.))
				Else
					lAchou :=  SA5->(MsSeek(xFilial("SA5")+cFornece+cLoja+cProdRef,.F.))
				EndIf
			Endif
		endif
	endif

	if !lAchou 
		MsgAlert( 'Atenção'+CRLF+'Não existe amarração de produto x fornecedor x fabricante para : '+CRLF+;
		                         ' produto - '+alltrim(aCols[nFor][nPProduto])+CRLF+;
								 ' fornecedor - '+cFornece+"/"+cLoja+CRLF+;
								 ' fabricante - '+cFabric+"/"+cFabLoja+'.' , "INFO")
	endif

	aEval(aAreas, {|aArea|restArea(aArea)})
	aSize(aAreas,0)

return lAchou 
