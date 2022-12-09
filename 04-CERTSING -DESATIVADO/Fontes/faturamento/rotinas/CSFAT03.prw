#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} CSFAT03
Função para alteração do código do vendedor no(s) pedido(s) de venda(s) selecionado(s)
@author Luciano A Oliveira
@since 27/08/2020
@version 1.0
	@return Nil, Função não tem retorno
	@example
	@teste
	u_CSFAT03()
	@obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function CSFAT03()
    Local aSAY  := {'Rotina para ALTERAR o vendedor no Pedido de Vendas','Pesquisa efetuada pelo número Pedido de Vendas','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local aRET  := {}
    Local nOpc  := 0
    Local cPedDe  := Space(TamSX3('C5_NUM')[01])
    //Local cPedAt  := Space(TamSX3('C5_NUM')[01])
    Local cCodVd  := Space(TamSX3('A3_COD')[01])
    Local lAlter  := .F.
    Local lCancel := .F.
    Local nCont   := 0

    Private cTitulo := '[CSFAT03] - Alteração do Vendedor no Pedido de Vendas'
    
    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch( cTitulo, aSAY, aBTN )

    if nOpc == 1
        aAdd( aPAR, {1, "Nro Pedido?",cPedDe,"","","SC5","",50,.T.})
        //aAdd( aPAR, {1, "Até o Pedido?",cPedAt,"",".T.","SC5",".T.",50,.T.})
	    aAdd( aPAR, {1, "Vendedor?",cCodVd,"","","SA3","",50,.T.})

        if ParamBox( aPAR, cTitulo, @aRET )
            if ApMsgYesNo("Tem certeza que deseja continuar?", cTitulo)
                DbSelectArea("SC5")
			    SC5->(dbSetOrder(1))
			    if SC5->( DbSeek( xFilial("SC5") + aRET[1] ) )
                    BEGIN TRANSACTION 
                        //while SC5->(!eof()) .AND. SC5->C5_NUM >= aRET[1] .AND. SC5->C5_NUM <= aRET[2]
                        if SC5->C5_NUM == aRET[1]
                            RecLock("SC5", .F.)
                            //SC5->C5_VEND1 := aRet[3]
                            SC5->C5_VEND1 := aRet[2]
                            MsUnlock()
                            lAlter := .T.
                            nCont++
                         //   SC5->(dbSkip())
                        endif
                    END TRANSACTION
                endif
            else
                lCancel := .T.    
            endif
        else
            lCancel := .T.
        endIF

        if lAlter .AND. !lCancel
            ApMsgInfo("Processo finalizado com sucesso. Alterado(s): " + alltrim(str(nCont)) + " pedido(s).", cTitulo )
        elseif !lAlter .AND. !lCancel
            ApMsgInfo("Nenhum Pedido de Vendas alterado, favor checar os parâmetros!!!", cTitulo )                
        endif

        if lCancel
            MsgInfo('Processo cancelado',cTitulo)
        endif
    endIF
return
