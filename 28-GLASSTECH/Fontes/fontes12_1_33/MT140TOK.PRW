#include "Protheus.ch"
#INCLUDE "TBICONN.CH"
/*/{Protheus.doc} User Function MT140TOK
     Responsável por validar todos os itens do pré-documento  
     Finalidade..: Este ponto é executado após verificar se 
     existem itens a serem gravados e tem como objetivo validar 
     todos os itens do pré-documento.
    @type  Function
    @author Bruno Pirolo
    @since 11/01/2021
    @version version
    @returnlRet, Lógico, Informar se o Pré Documento foi validado
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
				//msginfo("Pedido não vinculado na Pré Nota! Favor vincular!","ATENÇÃO")
                ShowHelpDlg("Atenção", {"Pedido não vinculado na Pré Nota!"},3, {"Favor vincular antes de Salvar!"},3)
			ELSE
				lRet    := .T.
			ENDIF
		ENDIF
	endif
RETURN lRet
