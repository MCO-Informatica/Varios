#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณMTA416PV บAutor ณJonas Abrigo - Totalsiga บ Data ณ 02/28/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada utilizado para atualizacao do Pedido de Venบฑฑ
ฑฑบ          ณdas com os dados do Orcamento.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ METALACRE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MTA416PV()

Local _AreaOrc 	:= GetArea()

If cEmpAnt <> '01'
	Return
Endif

        
//Busca e Atualiza Resgistro do SCK
_aCols[Len(_aCols)][AScan(aHeadC6, {|x| AllTrim(x[2]) == AllTrim('C6_XLACRE')})]   := SCK->CK_XLACRE
_aCols[Len(_aCols)][AScan(aHeadC6, {|x| AllTrim(x[2]) == AllTrim('C6_XAPLICA')})]  := SCK->CK_XAPLICA

//Atualiza Cabe็alho do Pedido
M->C5_VEND1		:=	SCJ->CJ_XVEND1
nRecSA3			:= SA3->(Recno())

If !Empty(SCJ->CJ_XVEND1)
	// Registra Comissoes e Codigo de Supervisor e Gerente
	// 3L Systems - Luiz Alberto - 07-05-14

	// Comissao Vendedor do Or็amento	
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