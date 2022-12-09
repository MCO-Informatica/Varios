//Bibliotecas
#Include "TOPCONN.CH"
#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M460FIM                                                                                       |
 | Desc:  Gravação dos dados após gerar NF de Saída                                                     |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784180                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M460FIM()
    Local cPedido  := ''
    Local aAreaSF2 := SF2->(GetArea())
    Local aAreaSD2 := SD2->(GetArea())
    Local aAreaSC5 := SC5->(GetArea())
    Local aAreaSE1 := SE1->(GetArea())
    Local aAreaSA1 := SA1->(GetArea())
     
    //Pega o pedido
    DbSelectArea("SD2")
    SD2->(DbSetorder(3))
    If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
        cPedido := SD2->D2_PEDIDO
    Endif          
     
    //Se tiver pedido
    If !Empty(cPedido)
        DbSelectArea("SC5")
        SC5->(DbSetorder(1))
         
        //Se posiciona pega o tipo de pagamento
        If SC5->(DbSeek(FWxFilial('SC5')+cPedido))
            RecLock("SC5",.F.)
            SC5->C5_EMISSAO := dDataBase
            SC5->(MsUnlock())
        Endif
    Endif     
     /*
    //Filtra títulos dessa nota
    cSql := "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SC7")
    cSql += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND D_E_L_E_T_<>'*' "
    cSql += " AND C6_NUM = '"+cPedido+"'"
    TcQuery ChangeQuery(cSql) New Alias "_QRY"
     
    //Enquanto tiver dados na query
    While !_QRY->(eof())
        DbSelectArea("SE1")
        SC6->(DbGoTo(_QRY->REC))
         
        //Se tiver dado, altera o tipo de pagamento
        If !SC6->(EoF())
            RecLock("SC6",.F.)
            Replace C6_EMISSAO WITH dDataBase
            SC6->(MsUnlock())
        EndIf
         
        _QRY->(DbSkip())
    Enddo
    _QRY->(DbCloseArea())
   */  
    RestArea(aAreaSF2)
    RestArea(aAreaSD2)
    RestArea(aAreaSC5)
    RestArea(aAreaSE1)
    RestArea(aAreaSA1)
Return
