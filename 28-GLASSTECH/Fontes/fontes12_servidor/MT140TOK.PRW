
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
Local lRet      := u_TWFUN01F()



Return lRet
