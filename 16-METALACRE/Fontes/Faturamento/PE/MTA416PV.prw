#Include "PROTHEUS.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �MTA416PV �Autor �Jonas Abrigo - Totalsiga � Data � 02/28/12  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizado para atualizacao do Pedido de Ven���
���          �das com os dados do Orcamento.                              ���
�������������������������������������������������������������������������͹��
���Uso       � METALACRE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MTA416PV()

Local _AreaOrc 	:= GetArea()

If cEmpAnt <> '01'
	Return
Endif

        
//Busca e Atualiza Resgistro do SCK
_aCols[Len(_aCols)][AScan(aHeadC6, {|x| AllTrim(x[2]) == AllTrim('C6_XLACRE')})]   := SCK->CK_XLACRE
_aCols[Len(_aCols)][AScan(aHeadC6, {|x| AllTrim(x[2]) == AllTrim('C6_XAPLICA')})]  := SCK->CK_XAPLICA

//Atualiza Cabe�alho do Pedido
M->C5_VEND1		:=	SCJ->CJ_XVEND1
nRecSA3			:= SA3->(Recno())

If !Empty(SCJ->CJ_XVEND1)
	// Registra Comissoes e Codigo de Supervisor e Gerente
	// 3L Systems - Luiz Alberto - 07-05-14

	// Comissao Vendedor do Or�amento	
	If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SCJ->CJ_XVEND1))
		M->C5_COMIS1:= SA3->A3_COMIS
	Endif                            
	
	// Codigo e Comissao Supervisor
	If !Empty(SA3->A3_SUPER)
		If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SA3->A3_SUPER))
			M->C5_VEND2 := SA3->A3_SUPER
			M->C5_COMIS2:= SA3->A3_COMIS
		Endif
	Endif

	// Codigo e Comissao Gerente
	If !Empty(SA3->A3_GEREN)
		If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SA3->A3_GEREN))
			M->C5_VEND3 := SA3->A3_GEREN
			M->C5_COMIS3:= SA3->A3_COMIS
		Endif
	Endif
Endif
SA3->(dbGoTo(nRecSA3))                        
                        
M->C5_TPFRETE	:=	SCJ->CJ_XFRETE
M->C5_TRANSP	:=	SCJ->CJ_XTRANSP
M->C5_NOMECLI	:=	SCJ->CJ_XNOMCLI

RestArea(_AreaOrc)

Return 