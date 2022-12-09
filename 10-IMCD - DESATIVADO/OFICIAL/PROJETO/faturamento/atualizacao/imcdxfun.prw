#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"
#Include "AP5Mail.ch"
#INCLUDE "TBIConn.CH"
#Include "MSOLE.ch"
#Include "FILEIO.ch"

#DEFINE CDPGTO  1
#DEFINE MGVENDA 2
#DEFINE LIC_CLI 3
#DEFINE LIC_TRA 4
#DEFINE QTD_EST 5
#DEFINE DPAVIST 6


/* **************************************************************************
***Programa  *AFAT020   * Autor * Eneovaldo Roveri Jr.  * Data *18/11/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Rotina geral de validação da liberação do pedido de venda  ***
*****************************************************************************
***Parametros* _cNumPed   - Número do Pedido de Venda                     ***
***          * _lExibeMsg - Exibe mensagens quando não satisfaz           ***
*****************************************************************************
***Retorno   * _aRet[5,3] - COLUNA 1                                      ***
***          *            - 1 - Condição de Pagamento                     ***
***          *            - 2 - Margem de Venda                           ***
***          *            - 3 - Licença do Cliente                        ***
***          *            - 4 - Licença da Transportadora                 ***
***          *            - 5 - Qtd em estoque                            ***
***          *            - 6 - Deposito A Vista para carga seca          ***
***          ************** COLUNA 2                                      ***
***          *            - n - .T. Liberado                              ***
***          *            - n - .F. Não Liberado                          ***
***          ************** COLUNA 3                                      ***
***          *            - n - .T. Trava liberação                       ***
***          *            - n - .F. Permite o usuário forçar a Liberação  ***
*****************************************************************************
***Aplicacao *  imcdxfun                                                   ***
*****************************************************************************
***Uso       *                                                            ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */


User Function A440CKPD( _cNumPed, _lExibeMsg, _lMargem )
Local _aArea := GetArea()
Local _aRet[8,3]
Local _lContinua := .T.
Local _nTotPed   := 0
Local _lMgVenda  := .T.
Local _lExercito := .f.
Local _lPolFed   := .f.
Local _lPolCiv   := .f.
Local _lProdAc   := .f.
Local _lCargaSeca:= .f.
Local _lEstPro   := .T.
Local _nReg5     := SC5->( recno() )
Local _nReg6     := SC6->( recno() )
Local _aPed := {}
Local lSintegra  := .t.
Local lSimpNac   := .t.
Local lRecFed    := .t.

Private _aMrg := {} //array para guardar os itens com valor abaixo do preco de seguranca
Private _lMetanol := .F.  // para verificar se algum produto pertence ao grupo do Metanol

	IF IsInCallStack("MATA311")
	_aRet := {}
	
	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )
	
	RestArea(_aArea)
	
	Return( .T. )
	
	Endif

	if _lMargem == NIL
	_lMargem := .f.
	endif

SC5->( dbsetorder(1) )
SC6->( dbsetorder(1) )


	if .not. SC5->( dbSeek( xFilial("SC5") + _cNumPed ) )
	afill( _aRet, {"",.F.,.T.} )
	_lContinua := .F.
	ExibirMsg( "Pedido " + _cNumPed + " não Encontrado...", _lExibeMsg )
	endif


	if  SC5->C5_X_CANC == "C" .or.  SC5->C5_X_REP == "R"  //nao liberar se o pedido esta cancelado ou reprovado
	_lContinua := .f.
	endif


//afill( _aRet, {"",.T.} )
_aRet[ CDPGTO ,1 ] := "Condição de Pagamento"
_aRet[ MGVENDA,1 ] := "Margem de Venda"
	if SC5->C5_TIPO == "B" .or. SC5->C5_TIPO == "D"
	_aRet[ LIC_CLI,1 ] := "Licença do Fornecedor"
	else
	_aRet[ LIC_CLI,1 ] := "Licença do Cliente"
	endif
_aRet[ LIC_TRA,1 ] := "Licença da Transportadora"
_aRet[ QTD_EST,1 ] := "Estoque de produtos"
_aRet[ DPAVIST,1 ] := "Deposito por Carga Seca"
//_aRet[ 7, 1      ] := "Frete CIF e Interior SP e Valor < 2.000" // Alterada para atender a Solicitação da Daisy - 22-08-2012 -Renan - TOTVS
_aRet[ 7, 1      ] := "Frete CIF e Interior SP e Valor < 3.000"
_aRet[ 8, 1      ] := "Pedido de Metanol: Cliente necessita declaração metanol, mas a mesma não está assinada"

//Esta terceira coluna foi criada para ver quando for falsa o usuário
//poderá forçar a liberação, porém se for true o pedido não será
//liberado de nenhuma forma. Este caso é para as licenças.
_aRet[ CDPGTO ,3 ] 	:= .F.
_aRet[ MGVENDA,3 ] 	:= .F.
_aRet[ LIC_CLI,3 ] 	:= .T.
_aRet[ LIC_TRA,3 ] 	:= .T.
_aRet[ QTD_EST,3 ] 	:= .F.
_aRet[ DPAVIST,3 ]	:= .F.
_aRet[ 7,3 ] 	  	:= .F.
_aRet[ 8,3 ]		:= .T.


	if _lContinua
	
	_lContinua := U_TPdLicCT( @_nTotPed,;
	@_lExercito,;
	@_lPolFed,;
	@_lPolCiv,;
	@_lProdAc,;
	@_lMgVenda,;
	@_lEstPro,;
	@_lCargaSeca,;
	_lExibeMsg,;
	_lMargem )//Checar itens e somar o total do pedido
	
	endif

	if _lContinua
	
	_aRet[ CDPGTO ,2 ] 	:= CkCondPag( _nTotPed, _lExibeMsg )
	_aRet[ MGVENDA,2 ] 	:= _lMgVenda
	
	_aRet[ LIC_CLI,2 ] 	:= U_CKLICCLI( _lExercito, _lPolFed, _lPolCiv, _lProdAc, _lExibeMsg,nil,@lSintegra,@lSimpNac,@lRecFed,@_lMetanol )
	
		If ! lSintegra .or. ! lSimpNac .or. ! lRecFed
		_aRet[ LIC_CLI,1 ] 	:= " Consulta Sintegra/Simples Nacional/Rec.Federal Obrigatoria para Cliente"
		Endif
	
	lSintegra  := .t.
	lSimpNac   := .t.
	lRecFed    := .t.
	
	_aRet[ LIC_TRA,2 ] 	:= U_CkLicTra( _lExercito, _lPolFed, _lPolCiv, _lProdAc, _lExibeMsg,nil,@lSintegra,@lSimpNac,@lRecFed )
	
		If ! lSintegra .or. ! lSimpNac .or. ! lRecFed
		_aRet[ LIC_TRA,1 ] 	:= " Consulta Sintegra/Simples Nacional/Rec.Federal - Obrigatoria para Transportadora"
		Endif
	
	_aRet[ QTD_EST,2 ] 	:= _lEstPro
	_aRet[ DPAVIST,2 ] 	:= .T. //CkDeposito( _lCargaSeca, _nTotPed, _lExibeMsg )
	//Carga seca com deposito avista sera checado na tela do financeiro. Em 08/01/2010 - Samantha
	
	_aRet[7,2 ] 	:= .T.	// Pedidos CIF com valor inferior a R$ 2.000,00
	_aRet[8,2 ]		:= .T.  // Declaração do Metanol
	
	endif

/* Validacao nova: Bloquear pedidos na modalidade CIF, com valor total inferior a R$ 3.000,00 para clientes do interior de SP, fora as cidades abaixo relacionadas:*/
/* retirado em 29/01/2018 - Junior. Solicitado por Carla Albino.

_cCidades += "/SAO PAULO      "
_cCidades += "/DIADEMA        "
_cCidades += "/SANTO ANDRE    "
_cCidades += "/SAO BERNARDO DO"
_cCidades += "/SAO CAETANO DO "
_cCidades += "/MAUA           "
_cCidades += "/RIBEIRAO PIRES "
_cCidades += "/GUARULHOS      "
_cCidades += "/OSASCO         "
_cCidades += "/BARUERI        "
_cCidades += "/TABOAO DA SERRA"
_cCidades += "/EMBU           "
_cCidades += "/SUZANO         "
_cCidades += "/MOGI DAS CRUZES"
_cCidades += "/COTIA          "
_cCidades += "/CARAPICUIBA    "
_cCidades += "/JANDIRA        "
_cCidades += "/CAIEIRAS       "
_cCidades += "/SANTANA DE PARN"
_cCidades += "/ITAPECERICA DA "
_cCidades += "/ITAQUAQUECETUBA"
_cCidades += "/POA            "
_cCidades += "/FERRAZ DE VASCO"


//If _nTotPed < 2000  //ALTERADO PARA 3000 NO DI 22.08.2012 POR RENAN GOMES - TOTVS PARA ATENDER A SOLICITAÇÃO DA DAISY DIAS
	If _nTotPed < 3000
		If SC5->C5_TPFRETE == "C"
_cEst := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_EST")
_cMun := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_MUN")
			If _cEst == "SP"
				If !(_cMun $ _cCidades)
_aRet[7,2] := .F.
_aRet[7,3] := .F.
				Endif
			Endif
		Endif
	Endif
*/

// Validação nova: Declaração do Metanol (Daniel, 10/08/11)
	_lMetanol := .F.
	_cMVTANOL := GetMv("MV_METANOL")
	dbselectarea( "SC6" )
	SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
	while .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
		if SB1->( dbSeek( xFilial("SB1") + SC6->C6_PRODUTO ) )
			If SB1->B1_GRUPO $ _cMVTANOL
				_lMetanol := .T.
			Endif
		Endif
		dbSelectArea("SC6")
		dbSkip()
	Enddo

	If _lMetanol
		If  Posicione("SA1",1,xFilial("SA1") + If(Inclui,M->C5_CLIENTE+ M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI),"A1_PDM") == "S" .and. ;
				Posicione("SA1",1,xFilial("SA1") + If(Inclui,M->C5_CLIENTE+ M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI),"A1_DMA") <> "S"
			_aRet[8,2] := .F.
		Endif
	Endif

	If _lMargem
		//gravar os itens com preco abaixo da margem de seguranca, na liberacao do pedido MT440STTS
		aadd(_aPed, _aRet)
		aadd(_aPed, _aMrg)
	Endif


	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )

	RestArea(_aArea)

	if _lMargem
		_aRet := _aPed
	Endif

Return( _aRet )
/*
Rotina para exibir mensagens caso o parametro seja para exibir
*/
Static Function ExibirMsg( _cMsg, _lExibe )

	if _lExibe
		MSGBOX(_cMsg,"Atenção","ALERT")
	endif

return( .T. )

/*
Verificar se a condição de pagamento esta correta
*/
Static Function CkCondPag( _nTotPed, _lExibeMsg )
	Local _lRet    := .T.

	dbselectarea( "SE4" )
	if SE4->( dbSeek( xfilial("SE4") + SC5->C5_CONDPAG ) )

		if SE4->E4_X_VRMIN > 0 .or. SE4->E4_X_VRMAX > 0

			if SE4->E4_X_VRMIN > _nTotPed .or. SE4->E4_X_VRMAX < _nTotPed
				_lRet := .f.
				ExibirMsg( "Total do Pedido " + alltrim(transf( _nTotPed, "@E 999,999,999,999,999.99" )) +;
					" Condição de Pagto com faixa de "+;
					alltrim(transf( SE4->E4_X_VRMIN, "@E 999,999,999,999,999.99" ))+;
					" Até " + alltrim(transf( SE4->E4_X_VRMAX, "@E 999,999,999,999,999.99" )) + "!", _lExibeMsg )
			endif

		endif

	endif
	dbselectarea( "SC5" )

return( _lRet )


/*
Verificar se a licença do cliente/fornecedor esta de acordo com os itens
*/
User Function CKLICCLI( _lExercito, _lPolFed, _lPolCiv, _lProdAc, _lExibeMsg, _cAlias, lSintegra, lSimpNac, lRecFed,_lMetanol )
	Local _lRet := .T.
	//Local _nDias:= GetMv( "MV_AVISOLI" )
	Local _cMVTANOL := GETMV("MV_METANOL")
	Local cChave := ""
	local cMensagem := ""

	if _cAlias == Nil
		_cAlias := "SC5"
	Endif

	If lSintegra == Nil
		lSintegra := .t.
	Endif

	If lSimpNac  == Nil
		lSimpNac  := .t.
	Endif

	If lRecFed  == Nil
		lRecFed   := .t.
	Endif

//Validacao somente no Pedido de Vendas para as Consultas Periodicas
	If _cAlias == "SC5" .and. U_IsSintegra() .and. ( !(SC5->C5_TIPO $ "DB" ) )
		//If _cAlias == "SC5" .and. .f. .and. (SC5->C5_TIPO <> "B" .or. SC5->C5_TIPO <> "D")

		//Clientes
		IF !INCLUI
			RegToMemory("SC5",.F.)
		ENDIF
		SA1->( dbSeek( xFilial( "SA1" ) + If(Inclui,M->C5_CLIENTE+ M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI)))

		//Se o Estado do Cliente for "EX", nao validar em nenhuma consulta Periodica
		If Left(SA1->A1_EST,2) == "EX"
			lSintegra := .t.
			lSimpNac  := .t.
			lRecFed   := .t.
		Else
			// Se nao tiver Inscricao Estadual, nao validar sintegra
			If "ISENT" $ UPPER(SA1->A1_INSCR)
				lSintegra := .t.
			Endif

			// Validacao na Receita Federal
			If Empty(SA1->A1_STATRF)
				//          cMsg:="Consulta a este Cliente nao foi realizada na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]"
				ExibirMsg("Consulta a este Cliente nao foi realizada na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]" , _lExibeMsg )
				_lRet    := .f.
				lRecFed  := .f.
			Else
				If Alltrim(SA1->A1_STATRF) == "I"  // Receita Federal
					//             cMsg:= "Cliente esta Inativo na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]"
					ExibirMsg("Cliente esta Inativo na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]" , _lExibeMsg )
					_lRet    := .f.
					lRecFed  := .f.
				Endif
			Endif

			If Empty( sa1->a1_validrf )
				//          cMsg:="Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]"
				ExibirMsg("Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]" , _lExibeMsg )
				_lRet    := .f.
				lRecFed  := .f.
			Else
				If sa1->a1_validrf < dDataBase
					// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]"
					ExibirMsg("Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]" , _lExibeMsg )
					_lRet    := .f.
					lRecFed  := .f.
				Endif
			Endif

			// Validacao no Simples Nacional
			If Empty(SA1->A1_STATJ)
				//          cMsg:="Consulta a este Cliente nao foi realizada no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]"
				ExibirMsg("Consulta a este Cliente nao foi realizada no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]" , _lExibeMsg )
				_lRet    := .f.
				lSimpNac := .f.
			Else
			/*
				If Alltrim(SA1->A1_STATJ) == "I"  // Simples Nacional
			//             cMsg:="Cliente esta Inativo no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]"
			ExibirMsg("Cliente esta Inativo no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]" , _lExibeMsg )
			_lRet    := .f.
			lSimpNac := .f.
				Endif
			*/
			Endif

			If Empty( sa1->a1_validj )
				//          cMsg:="Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]"
				ExibirMsg("Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]" , _lExibeMsg )
				_lRet    := .f.
				lSimpNac := .f.
			Else
				If sa1->a1_validj < dDataBase
					// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]"
					ExibirMsg("Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]" , _lExibeMsg )
					_lRet    := .f.
					lSimpNac := .f.
				Endif
			Endif

			// Validacao no Sintegra
			If Empty(SA1->A1_STATSI)
				//          cMsg:="Consulta a este Cliente nao foi realizada no Sintegra - Verifique o Cadastro de Clientes [Sintegra]"
				ExibirMsg("Consulta a este Cliente nao foi realizada no Sintegra - Verifique o Cadastro de Clientes [Sintegra]" , _lExibeMsg )
				_lRet    := .f.
				lSintegra := .f.
			Else
				If Alltrim(SA1->A1_STATSI) == "I"  // Sintegra
					//             cMsg:="Cliente esta Inativo no Sintegra - Verifique o Cadastro de Clientes [Sintegra]"
					ExibirMsg("Cliente esta Inativo no Sintegra - Verifique o Cadastro de Clientes [Sintegra]" , _lExibeMsg )
					_lRet    := .f.
					lSintegra := .f.
				Endif
			Endif

			If Empty( sa1->a1_validsi )
				//          cMsg:= "Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Sintegra]"
				ExibirMsg("Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Sintegra]" , _lExibeMsg )
				_lRet     := .f.
				lSintegra := .f.
			Else
				If sa1->a1_validsi < dDataBase
					// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Sintegra]"
					ExibirMsg("Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Sintegra]" , _lExibeMsg )
					_lRet     := .f.
					lSintegra := .f.
				Endif
			Endif
		Endif
	Endif

	cTipo := ""

	If _cAlias == "SC5"
		If INCLUI .and. TYPE ("aCols") <> "U"
			cTipo := SC5->C5_TIPO
			cChave := M->C5_CLIENTE + M->C5_LOJACLI
		Else
			cTipo := SC5->C5_TIPO
			cChave := SC5->C5_CLIENTE + SC5->C5_LOJACLI
		Endif
	Else
		If INCLUI .and. TYPE ("aCols") <> "U"
			cChave := M->UA_CLIENTE + M->UA_LOJA
		Else
			cChave := SUA->UA_CLIENTE + SUA->UA_LOJA
		Endif
	Endif

	if cEmpAnt <> '04'
		if _cAlias == "SC5" .and. (cTipo == "B" .or. cTipo == "D")

			dbselectarea( "SA2" )
			if SA2->( dbSeek( xFilial( "SA2" ) + cChave ))

				if _lExercito
					cMsg := iif( cEmpAnt == '02',"CRT ","do Ministério do Exercito!" )
					if SA2->A2_MINEXE != "S"
						ExibirMsg( "Fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui Licença "+cMsg , _lExibeMsg )
						_lRet := .f.
					else
						if !(U_validalicenca(cMsg,"SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_MELIC, SA2->A2_MEVALID,;
								SA2->A2_MEPROT ,SA2->A2_MEVALPR, @cMensagem))
							_lRet := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif

				if _lPolFed
					if SA2->A2_POLFED != "S"
						ExibirMsg( "fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui Licença da Policia Federal!", _lExibeMsg )
						_lRet := .f.
					else
						if !(U_validalicenca("Policia Federal","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_PFLIC, SA2->A2_PFVALID,;
								SA2->A2_PFPROT,SA2->A2_PFVALPR, @cMensagem))
							_lRet := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif

				if _lPolCiv
					if SA2->A2_POLCIV != "S"
						ExibirMsg( "fornecedor "+alltrim(SA2->A2_NREDUZ)+" não possui Licença da Policia Civil!", _lExibeMsg )
						_lRet := .f.
					else
						if !(U_validalicenca("Policia Civil","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_PCLIC, SA2->A2_PCVALID,;
								SA2->A2_PCPROT  ,SA2->A2_PCVALPR, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif

				if _lProdAc
					if SA2->A2_VISALF == "S"
						if !(U_validalicenca("VISA LF","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_VLFLIC , SA2->A2_VLFVLD ,;
								SA2->A2_VLFPROT ,SA2->A2_VLFVALP, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if SA2->A2_ANVISA1 == "S"
						if !(U_validalicenca("VISA AFE","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_AFELIC , SA2->A2_AFEVLD ,;
								SA2->A2_AFEPROT ,SA2->A2_AFEVALP, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if SA2->A2_ANVISA2 == "S"
						if !(U_validalicenca("VISA AE","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_AELIC, SA2->A2_AEVLD ,;
								SA2->A2_AEPROT ,SA2->A2_AEVALPR, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if SA2->A2_MAPA == "S"
						if !(U_validalicenca("MAPA","SA2",alltrim(SA2->A2_NREDUZ) ,SA2->A2_MAPALIC , SA2->A2_MAPAVLD ,;
								SA2->A2_MAPAPRO ,SA2->A2_MAPAVLP, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

				endif
			endif

		else

			If _cAlias == "SC5"
				If INCLUI .and. TYPE ("aCols") <> "U"
					cChave := M->C5_CLIENTE + M->C5_LOJACLI
				Else
					cChave := SC5->C5_CLIENTE + SC5->C5_LOJACLI
				Endif
			Else
				If INCLUI .and. TYPE ("aCols") <> "U"
					cChave := M->UA_CLIENTE + M->UA_LOJA
				Else
					cChave := SUA->UA_CLIENTE + SUA->UA_LOJA
				Endif
			Endif

			//Clientes
			dbselectarea( "SA1" )
			if SA1->( dbSeek( xFilial( "SA1" ) + cChave ) )

				if _lExercito
					cMsg := iif( cEmpAnt == '02',"CRT ","Ministério do Exercito" )
					if SA1->A1_MINEXE != "S"

						ExibirMsg( "Cliente "+alltrim(SA1->A1_NREDUZ)+ "não possui Licença "+cMsg , _lExibeMsg )

					else
						if !(U_validalicenca(cMsg,"SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_MELIC , SA1->A1_MEVALID,;
								SA1->A1_MEPROT ,SA1->A1_MEVALPR, @cMensagem))
							_lRet    := .f.

						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif

				if _lPolFed
					if SA1->A1_POLFED != "S"
						ExibirMsg( "Cliente "+alltrim(SA1->A1_NREDUZ)+" não possui Licença da Policia Federal!", _lExibeMsg )
						_lRet := .f.
					else
						if !(U_validalicenca("Policia Federal","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_PFLIC , SA1->A1_PFVALID,;
								SA1->A1_PFPROT  ,SA1->A1_PFVALPR, @cMensagem))
							_lRet    := .f.

						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

						// Verificar amarracao cli x prod control by Daniel em 19/11/10----------------------------------
						if !( cEmpAnt == '02')
							If _lRet .AND. dDataBase > getmv("MV_DTLIC") // Se passou pelo teste da licenca vai verificar a tabela de amarracao ZX5
								dbselectarea( "SC6" )
								SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
								while .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
									if SB1->( dbSeek( xFilial("SB1") + SC6->C6_PRODUTO ) )
										If SB1->B1_POLFED == "S"
											dbSelectAre("ZX5")
											ZX5->(dbSetOrder(1))
											If dbSeek(xFilial("ZX5") + SA1->A1_COD + SA1->A1_LOJA)  // Soh eventualmente bloqueia se o cliente estiver na tabela... era assim na validacao parcial
												If !dbSeek(xFilial("ZX5") + SA1->A1_COD + SA1->A1_LOJA + SB1->B1_POSIPI)       // E o NCM do produto nao esta!
													ExibirMsg( "Licença da Policia Federal do Cliente " + AllTrim(SA1->A1_NREDUZ) + " OK, mas o NCM do produto " + AllTrim(SB1->B1_DESC) +;
														"(" + AllTrim(SB1->B1_POSIPI) + ") não consta na tabela de amarração Cliente x Produtos Controlados!", _lExibeMsg )
													_lRet := .F.
												Endif
											Else					// Na validacao completa, se o cliente nao estiver cadastrado na tabela, nao deixa liberar
												ExibirMsg( "Licença da Policia Federal do Cliente " + AllTrim(SA1->A1_NREDUZ) + " OK, mas o mesmo não consta na tabela de amarração Cliente x Produtos Controlados!", _lExibeMsg )
												_lRet := .F.
											Endif
										Endif
										If SB1->B1_GRUPO $ _cMVTANOL
											_lMetanol := .T.
										Endif
									Endif
									dbSelectArea("SC6")
									dbSkip()
								Enddo
							Endif
						Endif
						//-----------------------------------------------------------------------------------------------
					endif
				endif


				if ( !(cEmpAnt == '02') .and. _lPolCiv) .OR.;
						(cEmpAnt == '02' .and. _lPolCiv  .and. Alltrim(SA1->A1_EST) = "SP")
					if SA1->A1_POLCIV != "S"
						ExibirMsg( "Cliente "+alltrim(SA1->A1_NREDUZ)+" não possui Licença da Policia Civil!", _lExibeMsg )
						_lRet := .f.
					else
						if !(U_validalicenca("Policia Civil","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_PCLIC   , SA1->A1_PCVALID,;
								SA1->A1_PCPROT,SA1->A1_PCVALPR, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif


				if _lProdAc
					if SA1->A1_VISALF == "S"
						if !(U_validalicenca("VISA LF","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_VLFLIC , SA1->A1_VLFVLD ,;
								SA1->A1_VLFPROT  ,SA1->A1_VLFVALP, @cMensagem))
							_lRet    := .f.
						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif

					if SA1->A1_ANVISA1 == "S"
						if !(U_validalicenca("ANVISA AFE","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_AFELIC  , SA1->A1_AFEVLD ,;
								SA1->A1_AFEPROT,SA1->A1_AFEVALP, @cMensagem))
							_lRet    := .f.
						endif
						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if (cEmpAnt == '01' .AND. SA1->A1_ANVISA2 == "S") .OR. ( cEmpAnt $ '02' .AND.  _lExercito )
						if !(U_validalicenca("ANVISA AE","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_AELIC , SA1->A1_AEVLD  ,;
								SA1->A1_AEPROT,SA1->A1_AEVALPR, @cMensagem))
							_lRet    := .f.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if SA1->A1_MAPA == "S"
						if !(U_validalicenca("MAPA","SA1",alltrim(SA1->A1_NREDUZ) ,SA1->A1_MAPALIC , SA1->A1_MAPAVLD,;
								SA1->A1_MAPAPRO  ,SA1->A1_MAPAVLP, @cMensagem))
							_lRet    := .f.
						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif
				endif
			endif

		endif

	endif

// E obrigatorio o preenchimento das Consultas Periodicas
	If !lSintegra .or.  ! lSimpNac .or. ! lRecFed
		_lRet := .F.
	Endif

return( _lRet )


/*
Verificar se a licença da transportadora esta de acordo com os itens
*/
User Function CkLicTra( _lExercito, _lPolFed, _lPolCiv, _lProdAc, _lExibeMsg, _cAlias, lSintegra, lSimpNac, lRecFed )
	Local _lRet := .T.
	//Local _nDias:= GetMv( "MV_AVISOLI" )
	Local aChave := {}
	local cMensagem := ""
	local cChave  := ""
	local nIndChv := 0

	If Empty(M->C5_TRANSP)
		ExibirMsg("A Transportadora não foi informada!" , .T. )
		Return .T.
	Endif

	IF !INCLUI
		RegToMemory("SC5",.F.)
	ENDIF

	if _cAlias == NIL
		_cAlias := "SC5"
		If INCLUI .and. TYPE ("aCols") <> "U"
			aadd(aChave, M->C5_TRANSP)
			if !empty(M->C5_REDESP)
				aadd(aChave, M->C5_REDESP)
			endif
		Else
			aadd(aChave, SC5->C5_TRANSP)
			if !empty(SC5->C5_REDESP)
				aadd(aChave, SC5->C5_REDESP)
			endif
		Endif
	Endif

	If lSintegra == Nil
		lSintegra := .t.
	Endif

	If lSimpNac  == Nil
		lSimpNac  := .t.
	Endif

	If lRecFed  == Nil
		lRecFed   := .t.
	Endif

	for nIndChv:=1 to len(aChave)

		cChave := aChave[nIndChv]

		//Validacao somente no Pedido de Vendas para as Consultas Periodicas
		If _cAlias == "SC5" .and. U_IsSintegra() .AND. M->C5_TIPO <> "BD"
			//If _cAlias == "SC5" .and. .f.

			//Transportadoras
			SA4->( dbSeek( xFilial( "SA4" ) + cChave ) )

			//Se o Estado do Cliente for "EX", nao validar em nenhuma consulta Periodica
			If Left(SA4->A4_EST,2) == "EX"
				lSintegra := .t.
				lSimpNac  := .t.
				lRecFed   := .t.
			Else
				// Se nao tiver Inscricao Estadual, nao validar sintegra
				If "ISENT" $ Upper(SA4->A4_INSEST)
					lSintegra := .t.
				Endif

				// Validacao na Receita Federal
				If Empty(SA4->A4_STATRF)
					//          cMsg:="Consulta a este Cliente nao foi realizada na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]"
					ExibirMsg("Consulta a esta Transp nao foi realizada na Receita Federal - Verifique a Transportadora [Receita Federal]" , _lExibeMsg )
					_lRet    := .f.
					lRecFed  := .f.
				Else
					If Alltrim(SA4->A4_STATRF) == "I"  // Receita Federal
						//             cMsg:= "Cliente esta Inativo na Receita Federal - Verifique o Cadastro de Clientes [Receita Federal]"
						ExibirMsg("Transp. esta Inativa na Receita Federal - Verifique a Transportadora [Receita Federal]" , _lExibeMsg )
						_lRet    := .f.
						lRecFed  := .f.
					Endif
				Endif

				If Empty( sa4->a4_validrf )
					//          cMsg:="Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]"
					ExibirMsg("Data de Validade nao preenchida para esta Transp. - Verifique a Transportadora [Receita Federal]" , _lExibeMsg )
					_lRet    := .f.
					lRecFed  := .f.
				Else
					If sa4->a4_validrf < dDataBase
						// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Receita Federal]"
						ExibirMsg("Data de Validade Expirada para esta Transp. - Verifique a Transportadora [Receita Federal]" , _lExibeMsg )
						_lRet    := .f.
						lRecFed  := .f.
					Endif
				Endif

				// Validacao no Simples Nacional
				If Empty(SA4->A4_STATJ)
					//          cMsg:="Consulta a este Cliente nao foi realizada no Simples Nacional - Verifique o Cadastro de Clientes [Simples Nacional]"
					ExibirMsg("Consulta a Transportadora nao foi realizada no Simples Nacional - Verifique a Transportadora [Simples Nacional]" , _lExibeMsg )
					_lRet    := .f.
					lSimpNac := .f.
				Endif

				If Empty( sa4->a4_validj )
					//          cMsg:="Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]"
					ExibirMsg("Data de Validade nao preenchida para esta Transp. - Verifique a Transportadora [Simples Nacional]" , _lExibeMsg )
					_lRet    := .f.
					lSimpNac := .f.
				Else
					If sa4->a4_validj < dDataBase
						// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Simples Nacional]"
						ExibirMsg("Data de Validade Expirada para esta Transp. - Verifique a Transportadora [Simples Nacional]" , _lExibeMsg )
						_lRet    := .f.
						lSimpNac := .f.
					Endif
				Endif

				// Validacao no Sintegra
				If Empty(SA4->A4_STATSI)
					//          cMsg:="Consulta a este Cliente nao foi realizada no Sintegra - Verifique o Cadastro de Clientes [Sintegra]"
					ExibirMsg("Consulta a este Transp. nao foi realizada no Sintegra - Verifique a Transportadora [Sintegra]" , _lExibeMsg )
					_lRet    := .f.
					lSintegra := .f.
				Else
					If Alltrim(SA4->A4_STATSI) == "I"  // Sintegra
						//             cMsg:="Cliente esta Inativo no Sintegra - Verifique o Cadastro de Clientes [Sintegra]"
						ExibirMsg("Cliente esta Inativo no Sintegra - Verifique a Transportadora [Sintegra]" , _lExibeMsg )
						_lRet    := .f.
						lSintegra := .f.
					Endif
				Endif

				If Empty( SA4->A4_VALIDSI )
					//          cMsg:= "Data de Validade nao preenchida para este Cliente - Verifique o Cadastro de Clientes [Sintegra]"
					ExibirMsg("Data de Validade nao preenchida para este Cliente - Verifique a Transportadora [Sintegra]" , _lExibeMsg )
					_lRet     := .f.
					lSintegra := .f.
				Else
					If SA4->A4_VALIDSI < dDataBase
						// 	         cMsg:="Data de Validade Expirada para este Cliente - Verifique o Cadastro de Clientes [Sintegra]"
						ExibirMsg("Data de Validade Expirada para este Cliente - Verifique a Transportadora [Sintegra]" , _lExibeMsg )
						_lRet     := .f.
						lSintegra := .f.
					Endif
				Endif
			Endif
		Endif

		if cEmpAnt <> "04"

			dbselectarea( "SA4" )
			if SA4->( dbSeek( xFilial( "SA4" ) + cChave ) )

				if _lExercito
					
					cMsg := iif( cEmpAnt == '02',"CRT ","do Ministério do Exercito!" )
					
					if SA4->A4_MINEXE != "S"
						ExibirMsg( "Transportadora "+alltrim(SA4->A4_NREDUZ)+" não possui "+cMsg+"!", _lExibeMsg )
						_lRet := .F.
					else
						if !(U_validalicenca(  cMsg ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_MELIC  , SA4->A4_MEVALID ,;
								SA4->A4_MEPROT,SA4->A4_MEVALPR, @cMensagem))
							_lRet    := .F.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif
				endif

				if _lPolFed
					if SA4->A4_POLFED != "S"
						ExibirMsg( "Transportadora "+alltrim(SA4->A4_NREDUZ)+" não possui Licença da Policia Federal!", _lExibeMsg )
						_lRet := .f.
					else

						if !(U_validalicenca("Policia Federal" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_PFLIC  , SA4->A4_PFVALID ,;
								SA4->A4_PFPROT,SA4->A4_PFVALPR, @cMensagem))
							_lRet    := .f.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif
				endif

				if _lPolCiv
					if SA4->A4_POLCIV != "S"
						ExibirMsg( "Transportadora "+alltrim(SA4->A4_NREDUZ)+" não possui Licença da Policia Civil!", _lExibeMsg )
						_lRet := .f.
					else

						if !(U_validalicenca("Policia Civil" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_PCLIC  , SA4->A4_PCVALID ,;
								SA4->A4_PCPROT,SA4->A4_PCVALPR, @cMensagem))
							_lRet    := .f.
						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif
				endif

				if _lProdAc

					if SA4->A4_VISALF == "S"

						if !(U_validalicenca("VISA LF" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_VLFLIC  , SA4->A4_VLFVLD ,;
								SA4->A4_VLFPROT,SA4->A4_VLFVALP, @cMensagem))
							_lRet    := .f.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif
					endif

					if SA4->A4_ANVISA1 == "S"

						if !(U_validalicenca("ANVISA AFE" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_AFELIC  , SA4->A4_AFEVLD ,;
								SA4->A4_AFEPROT,SA4->A4_AFEVALP, @cMensagem))
							_lRet    := .f.
						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif

					if  (cEmpAnt == '01' .AND. SA4->A4_ANVISA2== "S") .OR. ( cEmpAnt == '02' .AND.  _lExercito )

						if !(U_validalicenca("ANVISA AE" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_AELIC  , SA4->A4_AEVLD ,;
								SA4->A4_AEPROT,SA4->A4_AEVALPR, @cMensagem))
							_lRet    := .f.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif

					if SA4->A4_MAPA == "S"

						if !(U_validalicenca("MAPA" ,"SA4",alltrim(SA4->A4_NREDUZ) ,SA4->A4_MAPALIC  , SA4->A4_MAPAVLD ,;
								SA4->A4_MAPAPRO,SA4->A4_MAPAVLP, @cMensagem))
							_lRet    := .f.

						endif

						if !empty(cMensagem)
							ExibirMsg( cMensagem, _lExibeMsg )
						endif

					endif

				endif

			endif
		endif

		// E obrigatorio o preenchimento das Consultas Periodicas
		If !lSintegra .or.  ! lSimpNac .or. ! lRecFed
			_lRet := .F.
		Endif

	next nIndChv

return( _lRet )


/*
Rotina para somar e retornar o total do pedido corrente
Verificar as licenças dos clientes e das
transportadoras
*/
User Function TPdLicCT( nTotPed, _lExercito, _lPolFed, _lPolCiv, _lProdAc, _lMgVenda, _lEstPro, _lCargaSeca, _lExibeMsg, _lMargem )
	Local nCotacao:= 0
	Local nTotDes := 0
	Local nPrcUni := 0
	Local nPrcMin := 0
	Local nPrcSeg := 0
	Local _cCidades:= ""
	Local _cMun	  := ""
	Local _cEst	  := ""
	Local cUserLib	:= GetMV("MV_XLIBPED")
	Local cCodUser := __cUserId
	Local nX := 0

	_cCidades += "/SAO PAULO      "
	_cCidades += "/DIADEMA        "
	_cCidades += "/SANTO ANDRE    "
	_cCidades += "/SAO BERNARDO DO"
	_cCidades += "/SAO CAETANO DO "
	_cCidades += "/MAUA           "
	_cCidades += "/RIBEIRAO PIRES "
	_cCidades += "/GUARULHOS      "
	_cCidades += "/OSASCO         "
	_cCidades += "/BARUERI        "
	_cCidades += "/TABOAO DA SERRA"
	_cCidades += "/EMBU           "
	_cCidades += "/SUZANO         "
	_cCidades += "/MOGI DAS CRUZES"
	_cCidades += "/COTIA          "
	_cCidades += "/CARAPICUIBA    "
	_cCidades += "/JANDIRA        "
	_cCidades += "/CAIEIRAS       "
	_cCidades += "/SANTANA DE PARN"
	_cCidades += "/ITAPECERICA DA "
	_cCidades += "/ITAQUAQUECETUBA"
	_cCidades += "/POA            "
	_cCidades += "/FERRAZ DE VASCO"

	nTotPed := 0

	dbselectarea( "DA1" )
	dbsetorder(2)

	dbselectarea( "SB1" )
	dbsetorder(1)

	If INCLUI .and. TYPE ("aCols") <> "U"

		For nX :=1 to len(aCols)

			if SB1->( dbSeek( xFilial("SB1") + aCols[nX,GDFieldPos("C6_PRODUTO")] ) )
				if SB1->B1_MINEXEC == "S"  // Valida o CRT na empresa 02 FARMA
					_lExercito := .T.
				endif
				if SB1->B1_POLFED == "S"
					_lPolFed := .T.
				endif
				//luiz
				iF INCLUI
					_cEst := Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST") //ESTADO DO CLIENTE
				eLSE
					_cEst := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_EST") //ESTADO DO CLIENTE
				eNDIF
				if cEmpAnt == '01'
					If  (SB1->B1_XPCESTA == "1" .And. _cEst == "AC") .or. (SB1->B1_XPCESTB == "1" .And. _cEst == "AL") .or. ;
							(SB1->B1_XPCESTC == "1" .And. _cEst == "AP") .or. (SB1->B1_XPCESTD == "1" .And. _cEst == "AM") .or. ;
							(SB1->B1_XPCESTE == "1" .And. _cEst == "BA") .or. (SB1->B1_XPCESTF == "1" .And. _cEst == "CE") .or. ;
							(SB1->B1_XPCESTG == "1" .And. _cEst == "DF") .or. (SB1->B1_XPCESTH == "1" .And. _cEst == "ES") .or. ;
							(SB1->B1_XPCESTI == "1" .And. _cEst == "GO") .or. (SB1->B1_XPCESTJ == "1" .And. _cEst == "MA") .or. ;
							(SB1->B1_XPCESTL == "1" .And. _cEst == "MT") .or. (SB1->B1_XPCESTM == "1" .And. _cEst == "MS") .or. ;
							(SB1->B1_XPCESTN == "1" .And. _cEst == "MG") .or. (SB1->B1_XPCESTO == "1" .And. _cEst == "PA") .or. ;
							(SB1->B1_XPCESTP == "1" .And. _cEst == "PB") .or. (SB1->B1_XPCESTQ == "1" .And. _cEst == "PR") .or. ;
							(SB1->B1_XPCESTR == "1" .And. _cEst == "PE") .or. (SB1->B1_XPCESTS == "1" .And. _cEst == "PI") .or. ;
							(SB1->B1_XPCESTT == "1" .And. _cEst == "RJ") .or. (SB1->B1_XPCESTU == "1" .And. _cEst == "RN") .or. ;
							(SB1->B1_XPCESTV == "1" .And. _cEst == "RS") .or. (SB1->B1_XPCESTX == "1" .And. _cEst == "RO") .or. ;
							(SB1->B1_XPCESTZ == "1" .And. _cEst == "RR") .or. (SB1->B1_XPCEST0 == "1" .And. _cEst == "SC") .or. ;
							(SB1->B1_XPCEST1 == "1" .And. _cEst == "SP") .or. (SB1->B1_XPCEST2 == "1" .And. _cEst == "SE") .or. ;
							(SB1->B1_XPCEST3 == "1" .And. _cEst == "TO") .and. cUserLib <> cCodUser
						_lPolCiv := .T.
					endif
				ElseIF cEmpAnt == '02'
					if SB1->B1_POLCIV == "S"
						_lPolCiv := .T.
					endif
				ELSE
					_lPolCiv := .F.
				Endif


				if SB1->B1_TIPO $ "PA/MR"
					_lProdAc := .T.
				endif

				if DB0->( dbSeek( xFilial( "DB0" ) + SB1->B1_TIPCAR ) ) .and. DB0->DB0_TIPCAR == "003"
					_lCargaSeca := .T.
				endif

			endif

			nTotPed	+= aCols[nX,GDFieldPos("C6_VALOR")]
			If ( aCols[nX,GDFieldPos("C6_PRUNIT")] = 0 )
				nTotDes	+= aCols[nX,GDFieldPos("C6_VALDESC")]
			Else
				nTotDes += A410Arred((aCols[nX,GDFieldPos("C6_PRUNIT")]*aCols[nX,GDFieldPos("C6_QTDVEN")]),"C6_VALOR")-A410Arred((aCols[nX,GDFieldPos("C6_PRCVEN")]*aCols[nX,GDFieldPos("C6_QTDVEN")]),"C6_VALOR")
			EndIf

		Next

		nTotPed  -= M->C5_DESCONT
		nTotDes  += M->C5_DESCONT
		nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
		nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")

		SA4->(dbSetOrder(1))
		If SA4->(dbSeek(xFilial("SA4")+M->C5_TRANSP)) .And. M->C5_TPFRETE == "F"
			nTotPed += IIF(SA4->(FieldPos("A4_COLIG")) > 0 .And. SA4->A4_COLIG=="S",0,M->C5_FRETE)
		Else
			nTotPed += M->C5_FRETE
		Endif

		nTotPed += M->C5_SEGURO
		nTotPed += M->C5_DESPESA
		nTotPed += M->C5_FRETAUT
		If cPaisLoc == "PTG"
			nTotPed += M->C5_DESNTRB
			nTotPed += M->C5_TARA
		Endif


	Else

		dbselectarea( "SC6" )
		SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ) )
		while .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM

			if SB1->( dbSeek( xFilial("SB1") + SC6->C6_PRODUTO ) )

				if cEmpAnt <> "04"
					if SB1->B1_MINEXEC == "S"
						_lExercito := .T.
					endif
					if SB1->B1_POLFED == "S"
						_lPolFed := .T.
					endif
					//luiz
					_cEst := Posicione("SA1",1,xFilial("SA1") + if(inclui,M->C5_CLIENTE + M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI),"A1_EST") //ESTADO DO CLIENTE

					If cEmpAnt == '01'

						If  (SB1->B1_XPCESTA == "1" .And. _cEst == "AC") .or. (SB1->B1_XPCESTB == "1" .And. _cEst == "AL") .or. ;
								(SB1->B1_XPCESTC == "1" .And. _cEst == "AP") .or. (SB1->B1_XPCESTD == "1" .And. _cEst == "AM") .or. ;
								(SB1->B1_XPCESTE == "1" .And. _cEst == "BA") .or. (SB1->B1_XPCESTF == "1" .And. _cEst == "CE") .or. ;
								(SB1->B1_XPCESTG == "1" .And. _cEst == "DF") .or. (SB1->B1_XPCESTH == "1" .And. _cEst == "ES") .or. ;
								(SB1->B1_XPCESTI == "1" .And. _cEst == "GO") .or. (SB1->B1_XPCESTJ == "1" .And. _cEst == "MA") .or. ;
								(SB1->B1_XPCESTL == "1" .And. _cEst == "MT") .or. (SB1->B1_XPCESTM == "1" .And. _cEst == "MS") .or. ;
								(SB1->B1_XPCESTN == "1" .And. _cEst == "MG") .or. (SB1->B1_XPCESTO == "1" .And. _cEst == "PA") .or. ;
								(SB1->B1_XPCESTP == "1" .And. _cEst == "PB") .or. (SB1->B1_XPCESTQ == "1" .And. _cEst == "PR") .or. ;
								(SB1->B1_XPCESTR == "1" .And. _cEst == "PE") .or. (SB1->B1_XPCESTS == "1" .And. _cEst == "PI") .or. ;
								(SB1->B1_XPCESTT == "1" .And. _cEst == "RJ") .or. (SB1->B1_XPCESTU == "1" .And. _cEst == "RN") .or. ;
								(SB1->B1_XPCESTV == "1" .And. _cEst == "RS") .or. (SB1->B1_XPCESTX == "1" .And. _cEst == "RO") .or. ;
								(SB1->B1_XPCESTZ == "1" .And. _cEst == "RR") .or. (SB1->B1_XPCEST0 == "1" .And. _cEst == "SC") .or. ;
								(SB1->B1_XPCEST1 == "1" .And. _cEst == "SP") .or. (SB1->B1_XPCEST2 == "1" .And. _cEst == "SE") .or. ;
								(SB1->B1_XPCEST3 == "1" .And. _cEst == "TO") .and. cUserLib <> cCodUser
							_lPolCiv := .T.
						endif
					elseif cEmpAnt == '02'
						if SB1->B1_POLCIV == "S"
							_lPolCiv := .T.
						endif
					endif

					if SB1->B1_TIPO $ "PA/MR"
						_lProdAc := .T.
					endif

					if DB0->( dbSeek( xFilial( "DB0" ) + SB1->B1_TIPCAR ) ) .and. DB0->DB0_TIPCAR == "003"
						_lCargaSeca := .T.
					endif

				endif

				//verificar preços mínimo e preço de segurança
				if DA1->( dbseek( xFilial( "DA1" ) + SC6->C6_PRODUTO + SC5->C5_TABELA ) )

					nCotacao := SC6->C6_XTAXA
					if nCotacao == 0
						nCotacao := VerCota( DA1->DA1_MOEDA )
					endif

					if SC6->C6_XMOEDA == 1   //REAIS
						nPrcUni := SC6->C6_PRCVEN
						nPrcSeg := DA1->DA1_VMSEG
					else                     //Outras Moedas
						nPrcUni := SC6->C6_XPRUNIT
						nPrcSeg := DA1->DA1_VMSEG
						if nCotacao > 0
							nPrcSeg := (nPrcSeg/nCotacao)
						endif
					endif

					if SC6->C6_XMOEDA != DA1->DA1_MOEDA .and. nCotacao > 0
						nPrcUni := (nPrcUni/nCotacao)
					endif

					if SC6->C6_XMOEDA == DA1->DA1_MOEDA .or. nCotacao > 0
						//Este bicho aqui convelte o preço se for vendido pela seguda umildade
						nPrcMin := DA1->DA1_VMMIN
						nPrcMin := U_Conv2Um( SC6->C6_UM, nPrcMin, SC6->C6_PRODUTO )
						//				if NoRound(nPrcMin,2) > Round(nPrcUni,2)  //SC6->C6_PRCVEN
						if (NoRound(nPrcMin,2) > Round(nPrcUni,2)) .AND. (SC6->C6_QTDVEN > 200)
							ExibirMsg( "Preço do Item ("+alltrim(SC6->C6_PRODUTO)+") "+verMoeda( DA1->DA1_MOEDA )+" "+AllTrim(Transf(nPrcUni,"999,999,999.99"))+;
								", preço mínimo é "+verMoeda( DA1->DA1_MOEDA )+" "+AllTrim(Transf(nPrcMin,"999,999,999.99")), _lExibeMsg )
							_lMgVenda := .f.

						ElseIf (NoRound(nPrcMin,2) > Round(nPrcUni,2)) .AND. (SC6->C6_QTDVEN < 200)
							If SC5->C5_TPFRETE == "C"
								_cEst := Posicione("SA1",1,xFilial("SA1") + if(inclui,M->C5_CLIENTE + M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI),"A1_EST")
								_cMun := Posicione("SA1",1,xFilial("SA1") + if(inclui,M->C5_CLIENTE + M->C5_LOJACLI,SC5->C5_CLIENTE + SC5->C5_LOJACLI),"A1_MUN")
								If _cEst == "SP"
									If !(_cMun $ _cCidades)
										ExibirMsg("Quantidade inferior a 200 Kg, na modalidade CIF devem ser acrescidos "+verMoeda( DA1->DA1_MOEDA );
											+" 0,25/Kg ao preço unitário", _lExibeMsg )
										_lMgVenda := .f.

									Endif
								Endif
							Endif
						endif

						//Este cara aqui converte o preço se for vendido pela seguda umidade
						nPrcSeg := U_Conv2Um( SC6->C6_UM, nPrcSeg, SC6->C6_PRODUTO )
						if nPrcSeg > nPrcUni  //SC6->C6_PRCVEN
							ExibirMsg( "Preço do Item ("+alltrim(SC6->C6_PRODUTO)+") "+verMoeda( DA1->DA1_MOEDA )+" "+AllTrim(Transf(nPrcUni,"999,999,999.99"))+;
								", preço de segurança é "+verMoeda( DA1->DA1_MOEDA )+" "+AllTrim(Transf(nPrcSeg,"999,999,999.99")), _lExibeMsg )
							_lMgVenda := .f.
							//guarda o item que possui preço abaixo da margem para gravar na tab ZA4 e emitir relatorio de margem
							if _lMargem
								aadd(_aMrg, {SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM, SC6->C6_PRODUTO,nPrcUni,DA1->DA1_MSEG,nPrcSeg} )
							endif
						endif
					else
						ExibirMsg( "Moeda da Tabela ("+verMoeda( DA1->DA1_MOEDA )+") difere do pedido ("+verMoeda( SC6->C6_XMOEDA )+") e não tem cotação.", _lExibeMsg )
						//_lMgVenda := .f.
					endif

				endif

			endif

			nTotPed	+= SC6->C6_VALOR
			If ( SC6->C6_PRUNIT = 0 )
				nTotDes	+= SC6->C6_VALDESC
			Else
				nTotDes += A410Arred((SC6->C6_PRUNIT*SC6->C6_QTDVEN),"C6_VALOR")-A410Arred((SC6->C6_PRCVEN*SC6->C6_QTDVEN),"C6_VALOR")
			EndIf
			SC6->( dbskip() )
		EndDo

		nTotPed  -= SC5->C5_DESCONT
		nTotDes  += SC5->C5_DESCONT
		nTotDes  += A410Arred(nTotPed*SC5->C5_PDESCAB/100,"C6_VALOR")
		nTotPed  -= A410Arred(nTotPed*SC5->C5_PDESCAB/100,"C6_VALOR")

		SA4->(dbSetOrder(1))
		If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP)) .And. SC5->C5_TPFRETE == "F"
			nTotPed += IIF(SA4->(FieldPos("A4_COLIG")) > 0 .And. SA4->A4_COLIG=="S",0,SC5->C5_FRETE)
		Else
			nTotPed += SC5->C5_FRETE
		Endif

		nTotPed += SC5->C5_SEGURO
		nTotPed += SC5->C5_DESPESA
		nTotPed += SC5->C5_FRETAUT
		If cPaisLoc == "PTG"
			nTotPed += SC5->C5_DESNTRB
			nTotPed += SC5->C5_TARA
		Endif

	Endif
return( .T. )

/*
Verificar se a condição de pagamento for a vista e a carga for seca, se existe depósito do tipo RA
*/
Static Function CkDeposito( _lCargaSeca, _nTotPed, _lExibeMsg )
	Local _lRet    := .T.
	Local _nDepRa  := 0

//Se a carga não for seca, não precisa checar o deposito
	if .NOT. _lCargaSeca
		Return( _lRet )
	endif

	dbselectarea("SE1")  //Contas a Receber
	dbSetOrder( 22 )

	dbselectarea( "SE4" )
	if SE4->( dbSeek( xfilial("SE4") + SC5->C5_CONDPAG ) )
		if (SE4->E4_TIPO = "1" .and. alltrim(SE4->E4_COND) = "0")  //identifica que a condição é A Vista

			if SE1->( dbSeek( xFilial( "SE1" ) + SC5->C5_NUM ) )
				_nDepRa := 0
				Do While .not. SE1->( Eof() ) .and. SE1->E1_PEDIDO == SC5->C5_NUM
					if SE1->E1_TIPO == "RA "
						_nDepRa += SE1->E1_VALOR
					endif
					SE1->( dbSkip() )
				EndDo
				if _nDepRa != _nTotPed
					_lRet := .f.
					ExibirMsg( "Total do Pedido " + alltrim(transf( _nTotPed, "@E 999,999,999,999,999.99" )) +;
						" é diferente do Deposito Antecipado "+;
						alltrim(transf( _nDepRa, "@E 999,999,999,999,999.99" ))+"!", _lExibeMsg )
				endif
			else
				_lRet := .f.
				ExibirMsg( "Não foi encontrado um Deposito Antecipado (RA) exigido para o pedido " + SC5->C5_NUM+;
					" por ter Carga Seca.", _lExibeMsg )
			endif

		endif
	endif
	dbselectarea( "SC5" )

return( _lRet )

/*
Descrição da Moeda
*/
Static Function verMoeda( nMoeda )
	Local _cRet := "R$"

	if nMoeda == 1
		_cRet := "R$ "
	elseif nMoeda == 2
		_cRet := "US$"
	elseif nMoeda == 3
		_cRet := "UFI"
	elseif nMoeda == 4
		_cRet := "EUR"
	elseif nMoeda == 5
		_cRet := "YEN"
	elseif nMoeda >= 6
		_cRet := "   "
	endif

Return ( _cRet )


/*
Retornar o valor da Cotação da data do pedido
*/
Static Function VerCota( nMoeda )
	Local _nRet := 0

	if SM2->( dbSeek( DTOS(SC5->C5_EMISSAO) ) )

		if nMoeda == 1
			_nRet := SM2->M2_MOEDA1
		elseif nMoeda == 2
			_nRet := SM2->M2_MOEDA2
		elseif nMoeda == 3
			_nRet := SM2->M2_MOEDA3
		elseif nMoeda == 4
			_nRet := SM2->M2_MOEDA4
		elseif nMoeda == 5
			_nRet := SM2->M2_MOEDA5
		endif

	endif

return( _nRet )


/*
Converter o preço pela segunda unidade
*/
User Function Conv2Um( cUm, nPreco, cProd )
	Local aArea:= GetArea()
	Local _nRet := 0
	Local _cUm2Sb1 := ""
	Local _nConv := 0
	Local _cTpCo := " "

	_nRet := nPreco

	_cUm2Sb1:= Posicione("SB1",1,xfilial("SB1")+cProd,"B1_SEGUM")
	_nConv  := Posicione("SB1",1,xfilial("SB1")+cProd,"B1_CONV")
	_cTpCo  := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPCONV")

	if cUm == _cUm2Sb1 .and. _nConv > 0
		if _cTpCo == "D" //inverter o preço
			_nRet := Round(_nRet * _nConv, 6)
		else
			_nRet := Round(_nRet / _nConv, 6)
		endif
	endif

	RestArea(aArea)
return _nRet

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³ChkConfig ³ Autor ³ Giane                 ³ Data ³ 02/08/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Funcao traz regra de confidencialiade do usuario logado    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Relatorios e consultas regras de confidencialidade    	  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// Criado esta user funcion pois nao foi encontrado o mesmo no projeto. O fonte encontrado e que tb
// esta sendo chamado e o chkconfid.


/*/
User Function ChkConfig(cCodUser)
	Local cGrupos := ""
	Local cSql    := ""
	Local cAdmVnds	:= GetMv("MV_TABPR94")
	Local cSegResp := ""
	Local aRet := {}
	Local _lGer := .f.
	Local lVendedor := .f.

	If (cCodUser $ cAdmVnds) //é da admn.de vendas
		// Administracao Vendas
		cGrupos:="TODOS"
		//Return cGrupo
	Else
		//pega todos os segmentos que o usuário tem acesso
		cSql := "SELECT A3_GRPVEN "
		cSql += "FROM "
		cSql += "  " + RetSqlName("SA3") + " SA3 "
		cSql += "WHERE "
		cSql += "  A3_CODUSR = '" + cCodUser + "' "
		cSql += "UNION ALL "
		cSql += "SELECT VEN.A3_GRPVEN "
		cSql += "FROM "
		cSql += "  " + RetSqlName("SA3") + " GER JOIN " + RetSqlName("SA3") + " VEN ON "
		cSql += "    GER.A3_FILIAL = VEN.A3_FILIAL   AND "
		cSql += "    GER.D_E_L_E_T_ = ' '      AND "
		cSql += "    VEN.D_E_L_E_T_ = ' '      AND "
		cSql += "    GER.A3_COD = VEN.A3_GEREN "
		cSql += "WHERE "
		cSql += "  GER.A3_CODUSR = '" + cCodUser + "' "
		cSql += "GROUP BY "
		cSql += "  VEN.A3_GRPVEN "
		TcQuery cSql New Alias "GRPS"
		cGrupos += GRPS->A3_GRPVEN
		GRPS->(DbSkip())
		GRPS->(DbEval({|| cGrupos += "/" + A3_GRPVEN },,,,,.T.))
		GRPS->(DBCLOSEAREA())

		//verifica se é gerente:
		cCodVend := Posicione("SA3",7, xFilial("SA3") + cCodUser, "A3_COD")

		cSql := "SELECT COUNT(*) NGERENTE "
		cSql += "FROM "
		cSql += "  " + RetSqlName("SA3") + " SA3 "
		cSql += "WHERE "
		cSql += "  A3_GEREN = '" + cCodVend + "' "
		TcQuery cSql New Alias "XGER"

		IF XGER->NGERENTE > 0
			_lGer := .t.
			cSegResp := alltrim(cGrupos) //Posicione("SA3",7, xFilial("SA3") + cCodUser, "A3_GRPVEN")
		Else
			lVendedor := .t.
		Endif

		XGER->(DBCLOSEAREA())
	Endif

// retorna segmentos de vendas, se é gerente, segmento responsavel do gerente, se é vendedor ou nao
	aadd( aRet, alltrim(cGrupos) )
	aadd( aRet, _lGer )
	aadd( aRet, cSegResp)
	aadd( aRet, lVendedor )

Return aRet


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ MKSendMail³ Autor ³ Giane                ³ Data ³ 18/11/09   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
	±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
	±±³          ³ ExpC3 : Servidor de SMTP                                     ³±±
	±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
	±±³          ³         de conexao com o servidor SMTP.                      ³±±
	±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
	±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
	±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
	±±³          | ExpC8 : Patch com o arquivo que serah enviado                |±±
	±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
	±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio  |±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ SIGAGAC                                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MKENVMAIL(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach,lMsg,cLog, cCopia)

	Local cEmailTo := ""
	Local cEmailCc := ""
	Local lResult  := .F.
	Local cError   := ""
	Local cUser
	Local nAt
	Local cFromGe  := GetNewPar("MV_ACEMAIL", "")
	local lDispMail := superGetMv("ES_DISMAIL", .F., .T.)

	Default lMsg := .T.
	Default cLog := ""
	Default cCopia := ""

	if lDispMail
		// Verifica se serao utilizados os valores padrao.
		cAccount	:= Iif( cAccount  == NIL, GetMV( "MV_RELACNT" ), cAccount  )
		cPassword	:= Iif( cPassword == NIL, GetMV( "MV_RELPSW"  ), cPassword )
		cServer		:= Iif( cServer   == NIL, GetMV( "MV_RELSERV" ), cServer   )
		cAttach 	:= Iif( cAttach == NIL, "", cAttach )
		cFrom		:= Iif( cFrom == NIL, Iif( Empty(GetMV( "MV_RELFROM" )), GetMV( "MV_RELACNT" ), GetMV( "MV_RELFROM" ) ), cFrom )

		If  !EMPTY(cFromGe)
			If Alltrim(cFrom) == Alltrim( GetMV( "MV_RELACNT" ) ) .or. Alltrim(cFrom) == Alltrim( GetMV( "MV_RELFROM" ) ) // verifica se está utilizando o email do parametro global
				cFrom := cFromGe
			EndIf
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cEmailTo := SubStr(cEmail,1,At(Chr(59),cEmail)-1)
		if !empty(cCopia)
			cEmailCC := cCopia
		else
			cEmailCC := SubStr(cEmail,At(Chr(59),cEmail)+1,Len(cEmail))
		endif

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if lResult .and. GetMv("MV_RELAUTH")

			//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
			lResult := MailAuth(cAccount, cPassword)
			//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
			if !lResult
				nAt 	:= At("@",cAccount)
				cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
				lResult := MailAuth(cUser, cPassword)
			endif
		endif


		If lResult

			SEND MAIL FROM cFrom ;
				TO      	cEmailTo;
				CC     		cEmailCc;
				SUBJECT 	ACTxt2Htm( cAssunto );  //if( GetNewPar("MV_ACEMLAC", "1")$"1", ACTxt2Htm( cAssunto ), cAssunto );
				BODY    	ACTxt2Htm( cMensagem ); //if( GetNewPar("MV_ACEMLAC", "1")$"12", ACTxt2Htm( cMensagem ), cMensagem );
				ATTACHMENT  cAttach  ;
				RESULT lResult

			If !lResult
				//Erro no envio do email

				GET MAIL ERROR cError
				//	alert(cError)

				If lMsg
					Help(" ",1,"ATENCAO",,'Erro no envio do email para: '+ cEmailTo +" .",4,5)
				EndIf
				cLog := 'Erro no envio do email para: ' + cEmailTo
			EndIf

			DISCONNECT SMTP SERVER

		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			If lMsg
				Help(" ",1,"ATENCAO",,"Erro na conexão com o SMTP Server.  "+cError,4,5)
			EndIf
			cLog := "Erro na conexão com o SMTP Server " +cError
		EndIf
	endif
Return(lResult)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ GRVLOGPD º Autor ³ Giane - ADV Brasil º Data ³  25/11/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Funcao para gravar o log do pedido na tabela SZ4           º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Específico MAKENI / televendas/orcamento                   º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GrvLogPd(cNum, cCli, cLoja, cEvento, cMotivo, cItem, cAltera )
	Local _aArea := GetArea()

	if cItem == NIl
		cItem := ""
	endif

	DbSelectArea("SZ4")
	Reclock("SZ4",.t.)
	SZ4->Z4_FILIAL  := xFilial("SZ4")
	SZ4->Z4_PEDIDO  := cNum
	SZ4->Z4_ITEPED  := cItem
	SZ4->Z4_CLIENTE := cCli
	SZ4->Z4_LOJA    := cLoja
	SZ4->Z4_DATA    := date()
	SZ4->Z4_HORA    := time()
	SZ4->Z4_USUARIO := __cUserId
	SZ4->Z4_EVENTO  := cEvento

	if cMotivo != Nil
		SZ4->Z4_MOTIVO := cMotivo
	endif

	if cAltera != NIl
		MSMM( , TamSx3("Z4_ALTERA")[1], , cAltera, 1, , , "SZ4", "Z4_CODALTE" )
	endif

	MsUnlock()

	RestArea(_aArea)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OutLook   ºAutor  ³Ivan Morelatto Tore º Data ³  11/25/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para abrir um e-mail no outlook com endereco e      º±±
±±º          ³ e anexo preenchidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ABRENOTES( cEmail, aAnexo, cCopia, cAssunto )

	Local cExecute 	:= "outlook.exe"
	Local cParam	:= "/c ipm.note"
	Local cAnexo    := ""
	Local nI        := 0
	Local cCompl    := ""

	If cCopia == Nil
		cCopia := ""
	Endif

	If cAssunto == Nil
		cAssunto := ""
	Endif

	if ValType( aAnexo ) == "C"
		cAnexo := aAnexo
	elseif ValType( aAnexo ) == "A"
		For nI := 1 to len( aAnexo )
			cAnexo += iif(empty(cAnexo), " ", " /a ")+aAnexo[nI]
		Next nI
	endif


	cCompl := alltrim(cEmail) //+ '?cc='+alltrim(cCopia)+'&subject='+ cAssunto

	if !empty(cCopia)
		cCompl += '?cc=' + alltrim(cCopia)
	endif

	if !empty(cAssunto)
		cCompl += '&subject=' + cAssunto
	endif

	cParam += ' /m  " ' + cCompl +' "'

	If !Empty( cAnexo )
		cParam += " /a " + AllTrim( cAnexo ) + ""
	Endif

	ShellExecute('open',cExecute, cParam,'',1);
//ShellExecute('open',cExecute,'','',1);

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SOMAC9    ºAutor  ³  Daniel   Gondran  º Data ³  29/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para somar valor total de pedidos no SC9            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IniBrw em campo do SC9                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SOMAC9(_cFilial,_cPedido)

Local nRet := 0.00
Local cQuery := ''
Local cAlias := GetNextAlias()
Local aArea := GetArea()

cQuery := "Select Sum(C9_QTDLIB * C9_PRCVEN) TOTAL "
cQuery += " From " + RetSqlName('SC9') + " SC9 "
cQuerY += " Where C9_PEDIDO = '" + _cPedido + "'"
cQuery += " AND C9_FILIAL = '" + _cFilial + "'"
cQuery += " AND SC9.D_E_L_E_T_ = ' ' "

	If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
	EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlias, .F., .T.)
TcSetField(cAlias,'TOTAL','N',14,2)
nRet := (cAlias)->TOTAL
(cAlias)->(DbCloseArea())

RestArea(aArea)

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GAVGACOLS ³Autor  ³Fernando Salvatori  ³ Data ³ 08/03/2005  º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±ºDesc.     ³Funcao utilizada para gravar aCols                          º±±
±±º          ³(Baseado na funcao que grava aCols a610GravaCols)           º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±ºUso       ³ GAV-Interno                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function GAVGACOLS(aCols, aHeader, aRegCol, cAlias, bBloco, cCampos, nOpc)

	Local nFilial := 0
	Local j, z, lEmpty := .F.
	Local nLoop := 0
	Local cCodMemo, cTextMemo, cAliasMemo
	Local i
	Local nLenRecno	:= 0
	Local cType := Type("aMemosGGAV")

	Default cAlias := Alias()
	Default bBloco := {|| .T. }

//Tratamento para utilizar o recno nulo da funcao GAVMACOLS
	If Len(aRegCol) > 0 .And. Empty(aRegCol[1])
		aRegCol := {}
	EndIf

	nLenRecno := Len(aRegCol)

	If nOpc != 5

		nFilial := aScan((cAlias)->(dbStruct()), {|x| "_FILIAL" $ x[1]})

		For i := 1 to Len(aCols)

			If i <= Len(aRegCol)

				(cAlias)->(dbGoto(aRegCol[i]))
				(cAlias)->(RecLock(cAlias, .f.))

			Else

				If ValType(cCampos) == "C"
					For j := 1 to Len(aHeader)
						If AllTrim(aHeader[j, 2]) $ Upper(cCampos)
							If Empty(aCols[i, j])
								lEmpty := .T.
								Loop
							Endif
						Endif
					Next j
				Endif

				If ! aCols[i, Len(aHeader)+1] .And. ! lEmpty

					(cAlias)->(RecLock(cAlias, .T.))

				Else

					Loop

				Endif

			Endif

			If aTail(aCols[i])

				(cAlias)->(dbDelete())
				(cAlias)->(WriteSx2( cAlias ))
				(cAlias)->(MsUnlock())

			Else

				For z := 1 to Len(aHeader)

					If !"MSIDEN"$aHeader[z,2] .and. (nFieldPos := (cAlias)->(FieldPos(aHeader[z, 2]))) > 0
						(cAlias)->(FieldPut(nFieldPos, aCols[i, z]))
					Endif

				Next z

				If nFilial > 0

					(cAlias)->(FieldPut(nFilial, xFilial(cAlias)))

				Endif

				Eval(bBloco, i)

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava os campos Memos Virtuais					 				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cType == "A"

				For nLoop := 1 to Len( aMemosGGAV )

					cTextMemo := aCols[i][GDFieldPos(aMemosGGAV[nLoop][2],aHeader)]

					If i <= nLenRecno

						cCodMemo := aMemosGGAV[nLoop][1]

					Else

						cCodMemo := Nil

					EndIf

					cAliasMemo := If( Len( aMemosGGAV[nLoop] ) == 3, aMemosGGAV[nLoop][3] , Nil )

					If !aTail(aCols[i]) // Linha não deletada

						MSMM( If( nOpc != 3 .And. cCodMemo != NIL, (cAlias)->&cCodMemo , Nil ),TamSx3( aMemosGGAV[nLoop][2])[1] ,,cTextMemo,1,,,cAlias,aMemosGGAV[nLoop][1],cAliasMemo)

					ElseIf i <= nLenRecno // Linha deletada

						MSMM( (cAlias)->&cCodMemo,,,,2,,,,,cAliasMemo )

					EndIf

				Next nLoop

			EndIf

			(cAlias)->(MsUnlock())

			(cAlias)->(FkCommit())

		Next i
	Else

		For nLoop := 1 to Len( aRegCol )
			(cAlias)->( dbGoto( aRegCol[ nLoop ] ) )
			(cAlias)->( RecLock(cAlias, .F.) )

			If cType == "A"

				For j := 1 To Len( aMemosGGAV )

					cAliasMemo := IIf( Len( aMemosGGAV[j] ) == 3, aMemosGGAV[j][3] , Nil )
					MSMM( (cAlias)->&(aMemosGGAV[j][1]),,,,2,,,,,cAliasMemo )

				Next j

			EndIf

			(cAlias)->( dbDelete() )
			(cAlias)->( WriteSx2( cAlias ) )
			(cAlias)->( MsUnlock() )
			(cAlias)->(FkCommit())

		Next nLoop

	EndIf

Return .T.


User Function GavGrvEnc( cAlias, nOpc, bBloco )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parâmetros da função:                                                   ³
//³   cAlias  -> Ordem do índice de cAlias                                  ³
//³   nOpc    -> Opção selecionada (Inclusão [3] ou Alteração [?])          ³
//³   bBloco  -> Executa macroexecucao de instrucoes parametrizadas         ³
//³                                                                         ³
//³ Retorno da funcao                                                       ³
//³   .T. Gravou / .F. Não Gravou                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local lRet 		:= .T.

	Local lIncAlt   := nOpc == 3
	Local aArea		:= GetArea()
	Local nLoop
	Local cField
	Local cAliasMemo, cCodMemo, cTextMemo
	Local aSX3 := {}

	Default bBloco  := {|| Nil }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta o índice do SX3 para 2 (X3_CAMPO)                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSX3 := FWSX3Util():GetAllFields( cAlias , .F. )

	(cAlias)->( RecLock( cAlias, lIncAlt ) )

	If ! nOpc==5

		For nLoop := 1 to LEN(aSX3)

			cField := aSX3[nLoop]

			If "FILIAL" $ cField

				(cAlias)-> ( FieldPut( nLoop, xFilial(cAlias) ) )

			ElseIf !("MSIDEN" $ cField) .and. !(GetSx3Cache(aSX3[nLoop],"X3_CONTEXT") == "V")

				cField := "M->" + cField
				(cAlias)->( FieldPut( nLoop, &(cField) ) )

			EndIf

		Next nLoop

		Eval(bBloco)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava os campos Memos Virtuais					 				  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Type( "aMemosGAV" ) == "A"
			For nLoop := 1 to Len( aMemosGAV )
				cTextMemo := "M->"+aMemosGAV[nLoop][2]

				If nOpc != 3
					cCodMemo := aMemosGAV[nLoop][1]
					If Empty( &cCodMemo )
						cCodMemo := Nil
					EndIf
				EndIf

				cAliasMemo := If( Len( aMemosGAV[nLoop] ) == 3, aMemosGAV[nLoop][3] , Nil )
				MSMM( If( nOpc != 3 .And. cCodMemo != NIL, &cCodMemo , Nil ),TamSx3( aMemosGAV[nLoop][2])[1] ,,;
					&cTextMemo,1,,,cAlias,aMemosGAV[nLoop][1],cAliasMemo)

			Next nLoop
		EndIf

	Else

		Eval(bBloco)

		If Type( "aMemosGAV" )=="A"
			For nLoop := 1 To Len( aMemosGAV )
				cAliasMemo := IIf( Len( aMemosGAV[nLoop] ) == 3, aMemosGAV[nLoop][3] , Nil )
				MSMM( &(aMemosGAV[nLoop][1]),,,,2,,,,,cAliasMemo )
			Next nLoop
		EndIf

		(cAlias)->( dbDelete() )
		(cAlias)->( WriteSx2( cAlias ) )

	EndIf

	(cAlias)->( MsUnLock() )

	(cAlias)->( FKCommit() )

	RestArea( aArea )

Return lRet

Static Function ACTxt2Htm( cText, cEmail )

// ::: CRASE
// aA (acento crase)
	cText := STRTRAN(cText,CHR(224), "&agrave;")
	cText := STRTRAN(cText,CHR(192), "&Agrave;")

// ::: ACENTO CIRCUNFLEXO
// aA (acento circunflexo)
	cText := STRTRAN(cText,CHR(226), "&acirc;")
	cText := STRTRAN(cText,CHR(194), "&Acirc;")
// eE (acento circunflexo)
	cText := STRTRAN(cText,CHR(234), "&ecirc;")
	cText := STRTRAN(cText,CHR(202), "&Ecirc;")
// oO (acento circunflexo)
	cText := STRTRAN(cText,CHR(244), "&ocirc;")
	cText := STRTRAN(cText,CHR(212), "&Ocirc;")

// ::: TIL
// aA (til)
	cText := STRTRAN(cText,CHR(227), "&atilde;")
	cText := STRTRAN(cText,CHR(195), "&Atilde;")
// oO (til)
	cText := STRTRAN(cText,CHR(245), "&otilde;")
	cText := STRTRAN(cText,CHR(213), "&Otilde;")

// ::: CEDILHA
	cText := STRTRAN(cText,CHR(231), "&ccedil;")
	cText := STRTRAN(cText,CHR(199), "&Ccedil;")

// ::: ACENTO AGUDO
// aA (acento agudo)
	cText := STRTRAN(cText,CHR(225), "&aacute;")
	cText := STRTRAN(cText,CHR(193), "&Aacute;")

// eE (acento agudo)
	cText := STRTRAN(cText,CHR(233), "&eacute;")
	cText := STRTRAN(cText,CHR(201), "&Eacute;")

// iI (acento agudo)
	cText := STRTRAN(cText,CHR(237), "&iacute;")
	cText := STRTRAN(cText,CHR(205), "&Iacute;")

// oO (acento agudo)
	cText := STRTRAN(cText,CHR(243), "&oacute;")
	cText := STRTRAN(cText,CHR(211), "&Oacute;")

// uU (acento agudo)
	cText := STRTRAN(cText,CHR(250), "&uacute;")
	cText := STRTRAN(cText,CHR(218), "&Uacute;")

// ::: ENTER
	cText := STRTRAN(cText,CHR(13)+CHR(10), "<br>")
	cText := STRTRAN(cText,CHR(13), "<br>")
	cText := STRTRAN(cText,CHR(10), "<br>")

Return cText
