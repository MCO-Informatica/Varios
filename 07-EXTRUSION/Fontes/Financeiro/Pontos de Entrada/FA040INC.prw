//Bibliotecas
#Include "Protheus.ch"
 
/*--------------------------------------------------------------------------------*
 | P.E.:  FA040INC                                                                |
 | Desc:  Função chamada ao incluir título a receber                              |
 | Link:  http://tdn.totvs.com/display/public/mp/FA040INC+-+Valida+dados+--+11845 |
 *--------------------------------------------------------------------------------*/
 
User Function FA040INC()

   Local aArea := GetArea()
    Local lRet  := .T.
     
    //Se for RA
    If Alltrim(M->E1_TIPO) == 'CH' .and. empty(M->E1_PEDIDO) .AND. Alltrim(FunName())$("MATA460","MATA461","MATA410")

        MsgInfo("Inclusão de Tipo Cheque!", "Preencha o No do Pedido de Venda")
    Return .F.        
    EndIf
     
    RestArea(aArea)
Return lRet
