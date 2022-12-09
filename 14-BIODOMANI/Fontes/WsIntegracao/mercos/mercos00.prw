#include "protheus.ch"
/* Definição Classes Mercos */

class emailMercos	/* Classe e-mails */

	//data id
	//data tipo
	data email
	// Declaração dos Métodos da Classe
	method new() constructor

endclass

method new() class emailMercos

	//::id := nil
	//::tipo := nil
	::email := ""

Return Self


	class telMercos	/* Classe telefones */

		//data id
		//data tipo
		data numero
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass

method new() class telMercos

	//::id := nil
	//::tipo := nil
	::numero := ""

Return Self


	class contMercos		/* Classe Contatos */

		data id
		data telefones
		data cargo
		data nome
		data emails
		data excluido
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass

method new() class contMercos

	::id := nil
	::telefones := {}
	::cargo := ""
	::nome := ""
	::emails := {}
	::excluido := .f.

Return Self


	class segMercos	/* Classe segmento de clientes */

		Data id
		Data nome
		Data ultima_alteracao
		Data excluido
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cSeg ) constructor

	endclass

method new() class segMercos

	::id := nil
	::nome := ""
	::ultima_alteracao := nil
	::excluido := .f.

Return Self


method busca( cSeg ) Class segMercos

	Local aAreaS := { sx5->(GetArea()), GetArea() }

	sx5->(DbSetOrder(1))
	sx5->(dbseek(xfilial()+"T3"+cSeg))

	::id	:= nil
	::nome	:= sx5->x5_descri
	::ultima_alteracao := nil
	::excluido	:= .f.

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class cliMercos	/* Classe Clientes */

		data id
		data razao_social
		data nome_fantasia
		data tipo
		data cnpj
		data inscricao_estadual
		data suframa
		data rua
		data numero
		data complemento
		data cep
		data bairro
		data cidade
		data estado
		data observacao
		data emails
		data telefones
		data contatos
		data nome_excecao_fiscal
		data segmento_id
		//data rede_id
		data bloqueado_b2b
		data enderecos_adicionais
		data criador_id
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cCliente, cLoja ) constructor

	endclass

method new() class cliMercos

	::id				:= nil
	::razao_social		:= ""
	::nome_fantasia   	:= ""
	::tipo				:= ""	//J para pessoa jurídica, F para pessoa física.                                                                                                                                                                                                          |
	::cnpj				:= ""   // sem pontuação
	::inscricao_estadual:= ""
	::suframa           := ""
	::rua               := ""
	::numero            := ""
	::complemento       := ""
	::cep               := ""	//com ou sem hífen
	::bairro            := ""
	::cidade            := ""
	::estado            := ""
	::observacao        := ""
	::emails            := {}
	::telefones         := {}
	::contatos          := {}
	::nome_excecao_fiscal:= ""
	::segmento_id       := 0
	//::rede_id           := 0
	::bloqueado_b2b     := .f.
	::enderecos_adicionais:= {} // Cep (String: 9) Pode ser informado com ou sem hífen. - endereco (String: 200) - numero (String: 100) - complemento (String: 200) - bairro (String: 200) - cidade (String: 200) - estado (String: 2)
	::criador_id		:= 0
	::excluido			:= .f.
	::ultima_alteracao  := nil

Return Self

method busca( cCliente, cLoja ) Class cliMercos

	Local aAreaS := { sa1->(GetArea()), GetArea() }
	Local oMail
	Local oTel
	Local oCont
	Local cidTab := ""

	sa1->(DbSetOrder(1))
	sa1->(dbseek(xfilial()+cCliente+cLoja))

	szb->(DbSetOrder(1))
	szb->(dbseek(xfilial()+cFilAnt+"G"+sa1->a1_sativ1))
	cidTab := alltrim(szb->zb_idreg)

	::id				:= nil
	::razao_social		:= alltrim(sa1->a1_nome)
	::nome_fantasia   	:= alltrim(sa1->a1_nreduz)
	::tipo				:= sa1->a1_pessoa		//J para pessoa jurídica, F para pessoa física.                                                                                                                                                                                                          |
	::cnpj				:= alltrim(sa1->a1_cgc) // sem pontuação
	::inscricao_estadual:= alltrim(sa1->a1_inscr)
	::suframa           := ""
	::rua               := iif(sa1->a1_est=="DF", sa1->a1_end,FisGetEnd(sa1->a1_end)[1])
	::numero            := iif(sa1->a1_est=="DF", "SN"       ,FisGetEnd(sa1->a1_end)[3])
	::complemento       := iif(sa1->a1_est=="DF", ""         ,FisGetEnd(sa1->a1_end)[4])
	::cep               := sa1->a1_cep			//com ou sem hífen
	::bairro            := alltrim(sa1->a1_bairro)
	::cidade            := alltrim(sa1->a1_mun)
	::estado            := sa1->a1_est
	::observacao        := ""

	oMail:=emailMercos():new()
	oMail:email := alltrim(sa1->a1_email)
	::emails            := { {oMail} }

	oTel:=telMercos():new()
	oTel:Numero := alltrim(sa1->a1_tel)
	::telefones         := { {oTel} }

	if !empty(sa1->a1_contato)
		oCont:=contMercos():new()
		oCont:telefones := {}
		oCont:cargo := ""
		oCont:nome := alltrim(sa1->a1_contato)
		oCont:emails := {}
		oCont:excluido := .f.
		::contatos		:= { {oCont} }
	else
		::contatos		:= { }
	endif

	::nome_excecao_fiscal:= ""
	::segmento_id       := cidTab
	//::rede_id           := 0
	::bloqueado_b2b     := .f.
	::enderecos_adicionais:= {} // Cep (String: 9) Pode ser informado com ou sem hífen. - endereco (String: 200) - numero (String: 100) - complemento (String: 200) - bairro (String: 200) - cidade (String: 200) - estado (String: 2)
	::criador_id		:= nil
	::excluido			:= .f.
	::ultima_alteracao  := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class catMercos			/* Classe Categorias de produtos */

		data id
		data nome
		data categoria_pai_id
		data excluido
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cCat ) constructor

	endclass


method new() class catMercos

	::id := nil
	::nome := ""
	::categoria_pai_id := nil
	::excluido := .f.

Return Self

method busca( cCat ) Class catMercos

	Local aAreaS := { acu->(GetArea()), szb->(GetArea()), GetArea() }
	Local nId := nil

	acu->(DbSetOrder(1))
	acu->(dbseek(xfilial()+cCat))
	if !empty(acu->acu_codpai)
		szb->(DbSetOrder(1))
		szb->(dbseek(xfilial()+cFilAnt+'T'+acu->acu_codpai))
		nId := val(alltrim(szb->zb_idreg))
	endif

	::id := nil
	::nome := acu->acu_desc
	::categoria_pai_id := nId
	::excluido := .f.

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class preMercos			/* Classe tabela de preço - Cabeçalho */

		data id
		data nome
		data tipo
		data acrescimo
		data desconto
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cPre ) constructor

	endclass


method new() class preMercos

	::id := nil
	::nome := ""
	::tipo := ""
	::acrescimo := 0
	::desconto := 0
	::excluido := .f.
	::ultima_alteracao := nil

Return Self

method busca( cPre ) Class preMercos

	Local aAreaS := { da0->(GetArea()), GetArea() }

	da0->(DbSetOrder(1))
	da0->(dbseek(xfilial()+cPre))

	::id := nil
	::nome := da0->da0_descri
	::tipo := "P"			//P (preço livre) - A (acrescimo) - D (desconto)
	::acrescimo := 0
	::desconto := 0
	::excluido := .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class prePrdMercos			/* Classe tabela de preço - Itens */

		data id
		data preco
		data tabela_id
		data produto_id
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cPre,cItem ) constructor

	endclass


method new() class prePrdMercos

	::id := nil
	::preco := 0
	::tabela_id :=0
	::produto_id := 0
	::excluido := .f.
	::ultima_alteracao := nil

Return Self

method busca( cPre,cProd ) Class prePrdMercos

	Local aAreaS := { da0->(GetArea()), da1->(GetArea()), szb->(GetArea()), GetArea() }
	Local nPreco := 0
	Local cidTab := ""
	Local cidProd := ""

	da0->(DbSetOrder(1))
	da0->(dbseek(xfilial()+cPre))

	da1->(DbSetOrder(1))
	if da1->(dbseek(xfilial()+cPre+cProd))
		nPreco := da1->da1_prcven
	endif
	szb->(DbSetOrder(1))
	szb->(dbseek(xfilial()+cFilAnt+"B"+cPre))
	cidTab := alltrim(szb->zb_idreg)
	szb->(dbseek(xfilial()+cFilAnt+"P"+cProd))
	cidProd := alltrim(szb->zb_idreg)

	::id := nil
	::preco := nPreco
	::tabela_id := cidTab
	::produto_id := cidProd
	::excluido := .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class prodMercos	/* Classe produtos */

		data id
		data codigo
		data nome
		data comissao
		data preco_tabela
		data preco_minimo
		data ipi
		data tipo_ipi
		data st
		data grade_cores
		data grade_tamanhos
		data moeda
		data unidade
		data saldo_estoque
		data observacoes
		data excluido
		data ativo
		data categoria_id
		data codigo_ncm
		data multiplo
		data peso_bruto
		data largura
		data altura
		data comprimento
		data peso_dimensoes_unitario
		data exibir_no_b2b
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cProd, cLocal ) constructor

	endclass

method new() class prodMercos

	::id := nil
	::codigo := ""
	::nome := ""
	::comissao := 0
	::preco_tabela := 0
	::preco_minimo := nil
	::ipi = nil
	::tipo_ipi := ""	//"P" para percentual, "V" para valor fixo em Reais.
	::st := nil
	::grade_cores := {}
	::grade_tamanhos := {}
	::moeda := 0		//Real ("0"), DÃ³lar ("1") ou Euro ("2").
	::unidade := ""
	::saldo_estoque := 0
	::observacoes := ""
	::excluido := .f.
	::ativo := .t.
	::categoria_id := 0
	::codigo_ncm := ""
	::multiplo := ""
	::peso_bruto := 0
	::largura := 0
	::altura := 0
	::comprimento := 0
	::peso_dimensoes_unitario := .t.
	::exibir_no_b2b := .f.

Return Self

method busca( cProd, cLocal ) Class prodMercos

	Local aAreaS := { sb1->(GetArea()), sb2->(GetArea()), da1->(GetArea()), acv->(GetArea()), szb->(GetArea()), GetArea() }
	//005 - TABELA SAMANA CONSUMIDOR FINAL e 201 - TABELA CONSUMIDOR COSMOBEAUTY
	Local cTabela := iif(substr(cProd,1,4) == "0900","005",iif(substr(cProd,1,4) == "0100","201","999"))
	Local nPreco := 0
	Local nSDisp := 0

	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cProd))
	if empty(cLocal)
		cLocal := sb1->b1_locpad
	endif

	sb2->(DbSetOrder(1))
	sb2->(dbseek(xfilial()+cProd+cLocal))
	nSDisp := SaldoSB2()	//sb2->b2_qatu-sb2->b2_qpedven-sb2->b2_qemp-sb2->b2_reserva

	da1->(DbSetOrder(1))
	if da1->(dbseek(xfilial()+cTabela+cProd))
		nPreco := da1->da1_prcven
	endif

	acv->(DbSetOrder(5))
	acv->(dbseek(xfilial()+cProd))

	szb->(DbSetOrder(1))
	szb->(dbseek(xfilial()+cFilAnt+"T"+acv->acv_catego))

	::id		:= nil
	::codigo	:= sb1->b1_cod
	::nome		:= sb1->b1_desc
	::comissao 	:= 0			//sb1->b1_comis
	::preco_tabela := nPreco
	::preco_minimo := nil
	::ipi 		:= sb1->b1_ipi	//nil
	::tipo_ipi 	:= "P"			//"P" para percentual, "V" para valor fixo em Reais.
	::st 		:= nil			//sb1->b1_picmret
	::grade_cores 	:= {}
	::grade_tamanhos := {}
	::moeda 	:= 0			//Real ("0"), Dólar ("1") ou Euro ("2").
	::unidade 	:= sb1->b1_um
	::saldo_estoque := nSDisp
	::observacoes 	:= ""
	::excluido 	:= .f.
	::ativo 	:= .t.
	::categoria_id 	:= iif(empty(szb->zb_idreg),nil,alltrim(szb->zb_idreg))
	::codigo_ncm:= sb1->b1_posipi
	::multiplo 	:= ""
	::peso_bruto:= 0
	::largura 	:= 0
	::altura 	:= 0
	::comprimento := 0
	::peso_dimensoes_unitario := .t.
	::exibir_no_b2b := .f.

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class EstoqMercos			/* Classe Ajuste de estoque */

		data produto_id
		data novo_saldo
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cProd, cLocal ) constructor

	endclass

method new() class EstoqMercos

	::produto_id := 0
	::novo_saldo := 0

Return Self

method busca( cProd, cLocal ) Class EstoqMercos

	Local aAreaS := { sb1->(GetArea()), sb2->(GetArea()), szb->(GetArea()), GetArea() }

	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cProd))
	if empty(cLocal)
		cLocal := sb1->b1_locpad
	endif

	sb2->(DbSetOrder(1))
	sb2->(dbseek(xfilial()+cProd+cLocal))

	szb->(DbSetOrder(1))
	szb->(dbseek(xfilial()+cFilAnt+"P"+cProd))

	::produto_id := alltrim(szb->zb_idreg)
	::novo_saldo := sb2->b2_qatu-sb2->b2_qpedven-sb2->b2_qemp-sb2->b2_reserva

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class transMercos			/* Classe transportadoras */

		data id
		data nome
		data cidade
		data estado
		data informacoes_adicionais
		data telefones
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cTrans ) constructor

	endclass


method new() class transMercos

	::id	:= nil
	::nome	:= ""
	::cidade:= ""
	::estado:= ""
	::informacoes_adicionais := ""
	::telefones := {}
	::excluido	:= .f.
	::ultima_alteracao := nil

Return Self

method busca( cTrans ) Class transMercos

	Local aAreaS := { sa4->(GetArea()), GetArea() }

	sa4->(DbSetOrder(1))
	sa4->(dbseek(xfilial()+cTrans))

	::id	:= nil
	::nome	:= sa4->a4_nome
	::cidade:= sa4->a4_mun
	::estado:= sa4->a4_est
	::informacoes_adicionais := ""

	oTel:=telMercos():new()
	oTel:Numero := alltrim(sa4->a4_ddd+sa4->a4_tel)
	::telefones := { {oTel} }

	::excluido	:= .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class condMercos			/* Classe Condições de Pagamento */

		data id
		data nome
		data valor_minimo
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cCond ) constructor

	endclass


method new() class condMercos

	::id	:= nil
	::nome	:= ""
	::valor_minimo := 0
	::excluido	:= .f.
	::ultima_alteracao := nil

Return Self

method busca( cCond ) Class condMercos

	Local aAreaS := { se4->(GetArea()), GetArea() }

	se4->(DbSetOrder(1))
	se4->(dbseek(xfilial()+cCond))

	::id	:= nil
	::nome	:= se4->e4_descri
	::valor_minimo := 0
	::excluido	:= .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class formMercos			/* Classe Formas de Pagamento */

		data id
		data nome
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca( cForm ) constructor

	endclass

method new() class formMercos

	::id	:= nil
	::nome	:= ""
	::excluido	:= .f.
	::ultima_alteracao := nil

Return Self

method busca( cForm ) Class formMercos

	Local aAreaS := { sx5->(GetArea()), GetArea() }

	sx5->(DbSetOrder(1))
	sx5->(dbseek(xfilial()+"24"+cForm))

	::id	:= nil
	::nome	:= sx5->x5_descri
	::excluido	:= .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class cExtPedMercos			/* Classe campos extras do pedido */

		data campo_extra_id
		data nome
		data tipo
		data valor_texto
		data valor_data
		data valor_decimal
		data valor_hora
		data valor_lista
		data valor
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass

method new() class cExtPedMercos

	::campo_extra_id := 0
	::nome := ""
	::tipo := ""	//(“0”) Texto livre, (“1”) data, ("2") numérico, ("3") hora, ("4") Lista e ("5") Somente leitura. |
	::valor_texto := ""
	::valor_data := ""
	::valor_decimal := 0
	::valor_hora := ""
	::valor_lista := {}
	::valor := ""

Return Self


	class ipedMercos			/* Classe itens de pedido */

		data id
		data produto_id
		data produto_codigo
		data produto_nome
		data tabela_preco_id
		data quantidade
		data preco_bruto
		data preco_liquido
		data cotacao_moeda
		data quantidade_grades
		data descontos_do_vendedor
		data descontos_de_promocoes
		data descontos_de_politicas
		data descontos
		data observacoes
		data excluido
		data ipi
		data tipo_ipi
		data st
		data subtotal
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass

method new() class ipedMercos

	::id	:= nil
	::produto_id := 0
	::produto_codigo := ""		//Código do Produto na Mercos.                                                                                                                                                                                                                                                      |
	::produto_nome := ""		//Nome do Produto na Mercos.                                                                                                                                                                                                                                                        |
	::tabela_preco_id := 0
	::quantidade := 0
	::preco_bruto := 0
	::preco_liquido := 0
	::cotacao_moeda := 0
	::quantidade_grades := {}
	::descontos_do_vendedor := {}
	::descontos_de_promocoes := {}
	::descontos_de_politicas := {}
	::descontos := {}
	::observacoes := ""
	::excluido := .f.
	::ipi := 0
	::tipo_ipi := 0
	::st := 0					//Valor da ST (Substituição Tributária)                                                                                                                                                                                                                                             |
	::subtotal := 0

Return Self


	class pedMercos			/* Classe pedidos */

		data id
		data cliente_id
		data cliente_razao_social
		data cliente_nome_fantasia
		data cliente_cnpj
		data cliente_inscricao_estadual
		data cliente_rua
		data cliente_numero
		data cliente_complemento
		data cliente_cep
		data cliente_bairro
		data cliente_cidade
		data cliente_estado
		data cliente_suframa
		data cliente_telefone
		data cliente_email
		data representada_id
		data representada_nome_fantasia
		data representada_razao_social
		data transportadora_id
		data transportadora_nome
		data criador_id					//vendedor
		data nome_contato
		data status
		data numero
		data rastreamento
		data valor_frete
		data total
		data condicao_pagamento
		data condicao_pagamento_id
		data tipo_pedido_id
		data forma_pagamento_id
		data endereco_entrega
		data data_emissao
		data observacoes
		data contato_nome
		data status_faturamento
		data status_custom_id
		data status_b2b
		data data_criacao
		data ultima_alteracao
		data itens
		data extras
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass

method new() class pedMercos

	::id	:= nil
	::cliente_id := 0
	::cliente_razao_social := ""
	::cliente_nome_fantasia := ""
	::cliente_cnpj := ""
	::cliente_inscricao_estadual := ""
	::cliente_rua := ""
	::cliente_numero := ""
	::cliente_complemento := ""
	::cliente_cep := ""
	::cliente_bairro := ""
	::cliente_cidade := ""
	::cliente_estado := ""
	::cliente_suframa := ""
	::cliente_telefone := {}
	::cliente_email := {}
	::representada_id := 0
	::representada_nome_fantasia := ""
	::representada_razao_social := ""
	::transportadora_id := 0
	::transportadora_nome:= ""
	::criador_id := 0
	::nome_contato := ""
	::status := ""			//Status atual do pedido. 0 = Cancelado, 1 = Orçamento, 2 = Pedido.                                                                                                   |
	::numero := 0			//Número auto-incremental do pedido.                                                                                                                                  |
	::rastreamento := ""	//Código ou link para rastreamento de envio do pedido.                                                                                                                |
	::valor_frete := 0
	::total := 0			//Valor total do pedido.                                                                                                                                              |
	::condicao_pagamento := ""
	::condicao_pagamento_id := 0
	::tipo_pedido_id  := 0
	::forma_pagamento_id := 0
	::endereco_entrega := ""
	::data_emissao := ""
	::observacoes := ""
	::contato_nome := ""
	::status_faturamento := 0	//Não faturado = 0, Parcialmente faturado = 1, Faturado = 2.                                                                                                          |
	::status_custom_id := 0
	::status_b2b := 0			//Status atual do pedido no B2b. null = Pedido não foi gerado com o B2B, 1 = Em aberto, 2 = Concluído.
	::data_criacao := ""
	::ultima_alteracao := nil
	::itens := {}
	::extras := {}

Return Self


	class usuMercos			/* Classe usuários Mercos */

		data id
		data nome
		data email
		data telefone
		data administrador
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor

	endclass


method new() class usuMercos

	::id := nil
	::nome := ""
	::email := ""
	::telefone := ""
	::administrador := .f.
	::excluido := .f.
	::ultima_alteracao := nil

Return Self


	class icmsStMercos			/* Classe configuração ST Mercos */

		data id
		data codigo_ncm
		data nome_excecao_fiscal
		data estado_destino
		data tipo_st
		data valor_mva
		data valor_pmc
		data icms_credito
		data icms_destino
		data excluido
		data ultima_alteracao
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca(cGrTrib,cSequen) constructor

	endclass


method new() class icmsStMercos

	::id := nil
	::codigo_ncm := ""
	::nome_excecao_fiscal := ""
	::estado_destino := ""
	::tipo_st := ""
	::valor_mva := 0
	::valor_pmc := 0
	::icms_credito := 0
	::icms_destino := 0
	::excluido := .f.
	::ultima_alteracao := nil

Return Self


method busca( cGrTrib, cSequen ) Class icmsStMercos

	Local aAreaS := { sf7->(GetArea()), GetArea() }
	Local cTemp := ""
	Local cNcm := ""
	Local cNomExc := ""
	Local nF := 0

	sf7->(DbSetOrder(3))
	sf7->(dbseek(xfilial()+cGrtrib+cSequen))

	sx5->(DbSetOrder(1))
	sx5->(dbseek(xfilial()+"21"+cGrtrib))

	cTemp := replace(sx5->x5_descri,"NCM","")
	nF := at("-",cTemp)
	cNcm := alltrim(substr(cTemp,1,(nF-1)))
	cNomExc := alltrim(substr(cTemp,(nF+1)))+"-"+sf7->f7_est

	::id := nil
	::codigo_ncm := cNcm
	::nome_excecao_fiscal := cNomExc
	::estado_destino := sf7->f7_est
	::tipo_st := "MVA"
	::valor_mva := sf7->f7_margem
	::valor_pmc := 0
	::icms_credito := sf7->f7_aliqext
	::icms_destino := sf7->f7_aliqdst
	::excluido := .f.
	::ultima_alteracao := nil

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class fatMercos			/* Classe faturamento Mercos */

		data pedido_id
		data valor_faturado
		data data_faturamento
		data numero_nf
		data informacoes_adicionais
		// Declaração dos Métodos da Classe
		method new() constructor
		method busca(cDoc,cSer) constructor

	endclass


method new() class fatMercos

	::pedido_id := 0
	::valor_faturado := 0
	::data_faturamento := ""		//String: “AAAA-MM-DD”
	::numero_nf := ""
	::informacoes_adicionais := ""

Return Self


method busca( cDoc,cSer,cPedido ) Class fatMercos

	Local aAreaS := { sf2->(GetArea()),szb->(GetArea()), GetArea() }
	Local cidPed := ""
	Local nVlrFat := 0

	sf2->(DbSetOrder(1))
	sf2->(dbseek(xfilial()+cDoc+cSer))

	szb->(DbSetOrder(1))
	szb->(dbseek(xfilial()+cFilAnt+"O"+cPedido))
	cidPed := alltrim(szb->zb_idreg)

	nVlrFat	:= sf2->f2_valfat
	If nVlrFat == 0
		nVlrFat := sf2->f2_valmerc+sf2->f2_valipi+sf2->f2_icmsret+sf2->f2_seguro+sf2->f2_despesa+sf2->f2_frete
	endif

	::pedido_id := cidPed
	::valor_faturado := nVlrFat
	::data_faturamento := transform(sf2->f2_emissao,"9999-99-99")	//String: “AAAA-MM-DD”
	::numero_nf := sf2->f2_doc
	::informacoes_adicionais := "Pedido Protheus: "+cPedido

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self
