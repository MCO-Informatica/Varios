#Include 'Protheus.ch'

/*/{Protheus.doc}  F440COM
Função que altera valor base da comissão, 
onde o valor base deve ser o valor de LUCRO do pedido de venda

@author André Lanzieri
@since 24/02/2014
@version 1.0

/*/
User Function F440COM()
/*Local cPedido := SC5->C5_NUM
Local nValBruto := 0

DBSELECTAREA("SE3")
DbOrderNickName("SW01")

if DBSEEK(xFilial("SE3")+SC5->C5_NUM)
	DBSELECTAREA("SC6")
	SC6->(DBSETORDER(1))
	
	IF DBSEEK(xFilial("SC6")+cPedido)
		WHILE SC6->C6_NUM == cPedido
			nValBruto := SC6->C6_VLRBRT*SC6->C6_QTDVEN
			SC6->(DbSkip())
		enddo
	ENDIF
     
    DBSELECTAREA("SE3")
	DbOrderNickName("SW01")   
	DBSEEK(xFilial("SE3")+cPedido)
	RECLOCK( "SE3", .F. )
		SE3->E3_BASE := SE3->E3_BASE-nValBruto-SC5->C5_FRETE-SC5->C5_RET1-SC5->C5_RET2-SC5->C5_RET3
		SE3->E3_COMIS := SE3->E3_BASE*SE3->E3_PORC/100
	MSUNLOCK()
endif

 */
Return