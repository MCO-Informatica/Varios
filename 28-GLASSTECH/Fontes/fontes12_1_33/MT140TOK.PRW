#include "Protheus.ch"
#INCLUDE "TBICONN.CH"
/*/{Protheus.doc} User Function MT140TOK
     Respons?vel por validar todos os itens do pr?-documento  
     Finalidade..: Este ponto ? executado ap?s verificar se 
     existem itens a serem gravados e tem como objetivo validar 
     todos os itens do pr?-documento.
    @type  Function
    @author Bruno Pirolo
    @since 11/01/2021
    @version version
    @returnlRet, L?gico, Informar se o Pr? Documento foi validado
    @see (https://tdn.totvs.com/pages/releaseview.action?pageId=6085513)
    /*/
User Function MT140TOK()
	Local lRetorno  := PARAMIXB[1]
	Local lRet      := .T.
	Local nPedido   := aCols[n,Ascan(aHeader, {|x|, Upper(Alltrim(x[2])) == "D1_PEDIDO" })]
	Local cUser     := UsrRetName(RetCodUsr())

	if procname(10) != 'U_PRENOTAIMP'
		IF (cUser $ "Renata/esequiel/Renato/renato.paula/renato.depaula/Administrador")
			lRet    := .T.
		ELSE
			IF EMPTY(nPedido)
                lRet    := .F.
				//msginfo("Pedido n?o vinculado na Pr? Nota! Favor vincular!","ATEN??O")
                ShowHelpDlg("Aten??o", {"Pedido n?o vinculado na Pr? Nota!"},3, {"Favor vincular antes de Salvar!"},3)
			ELSE
				lRet    := .T.
			ENDIF
		ENDIF
	endif
RETURN lRet
