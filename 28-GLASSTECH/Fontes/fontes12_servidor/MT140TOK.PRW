
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
Local lRet      := u_TWFUN01F()



Return lRet
