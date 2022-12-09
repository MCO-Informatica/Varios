#include "protheus.ch"
/* Definição Classes Cmms */

class materiaisCmms		/* Classe Contatos */

	data aMateriais
	// Declaração dos Métodos da Classe
	method new() constructor
	method add( oMaterial ) constructor

endclass

method new() class materiaisCmms

	::aMateriais := {}

Return Self

method add( oMaterial ) class materiaisCmms

	aadd(::aMateriais, oMaterial)

Return Self

	class materialCmms /* Classe material CMMS*/

		Data FLAG_ACAO
		Data CODG_GRUPO_MATERIAL
		Data DESC_GRUPO_MATERIAL
		Data _CODG_CLASSE_MATERIAL
		Data DESC_CLASSE_MATERIAL
		Data CODG_PDM
		Data DESC_PDM
		Data DESC_PADRONIZADA
		Data DATA_CADASTRO
		Data _CODG_UNIT_CSN
		Data _DESC_UNIT_CSN
		Data _FLAG_DECIMAIS_CSN
		Data _FLAG_CTRL_INDIVIDUAL
		Data NUMR_CLASS_PATRIMONIAL
		Data DATA_BLOQUEIO
		Data CODG_FABRICANTE
		Data DESC_FABRICANTE
		Data DESC_MODELO
		Data CODG_CLASS_PRECO
		Data CODG_TIPO_MATERIAL
		Data DESC_TIPO_MATERIAL
		Data _FLAG_CTRL_ESTQ_FAB
		Data _FLAG_CTRL_DT_VENCIMENTO
		Data CODG_UNIT_COMPRA
		Data DESC_UNIT_COMPRA
		Data FLAG_DECIMAIS_COMPRA
		Data CODG_SIT_MATERIAL
		Data FLAG_CTRL_PATRIMONIO
		Data NUMR_MATERIAL_EXTERNO
		Data FLAG_ESTRUTURAMETALICA
		Data TEXT_OBSERVACAO
		Data NUMR_MODRESSUPRIMENTO
		Data NUMR_TIPORESSUPRIMENTO
		Data NUMR_DESIG_MATERIAL

		method new() constructor
		method buscar( cCod, cOper ) constructor

	endclass

method new() class materialCmms

	::FLAG_ACAO					:= ""
	::CODG_GRUPO_MATERIAL		:= ""
	::DESC_GRUPO_MATERIAL		:= ""
	::_CODG_CLASSE_MATERIAL		:= ""
	::DESC_CLASSE_MATERIAL		:= ""
	::CODG_PDM					:= ""
	::DESC_PDM					:= ""
	::DESC_PADRONIZADA			:= ""
	::DATA_CADASTRO				:= ""
	::_CODG_UNIT_CSN			:= ""
	::_DESC_UNIT_CSN			:= ""
	::_FLAG_DECIMAIS_CSN		:= ""
	::_FLAG_CTRL_INDIVIDUAL		:= ""
	::NUMR_CLASS_PATRIMONIAL	:= 0
	::DATA_BLOQUEIO				:= ""
	::CODG_FABRICANTE			:= ""
	::DESC_FABRICANTE			:= ""
	::DESC_MODELO				:= ""
	::CODG_CLASS_PRECO			:= 0
	::CODG_TIPO_MATERIAL		:= ""
	::DESC_TIPO_MATERIAL		:= ""
	::_FLAG_CTRL_ESTQ_FAB		:= ""
	::_FLAG_CTRL_DT_VENCIMENTO	:= ""
	::CODG_UNIT_COMPRA			:= ""
	::DESC_UNIT_COMPRA			:= ""
	::FLAG_DECIMAIS_COMPRA		:= ""
	::CODG_SIT_MATERIAL			:= ""
	::FLAG_CTRL_PATRIMONIO		:= ""
	::NUMR_MATERIAL_EXTERNO		:= ""
	::FLAG_ESTRUTURAMETALICA	:= ""
	::TEXT_OBSERVACAO			:= ""
	::NUMR_MODRESSUPRIMENTO		:= 0
	::NUMR_TIPORESSUPRIMENTO	:= 0
	::NUMR_DESIG_MATERIAL		:= 0

Return Self

method buscar( cCod, cOper ) Class materialCmms

	Local aAreaS := { sb1->(GetArea()), sbm->(GetArea()), GetArea() }

	Local cDtCad := iif(cOper=="I",transform(dtos(date()),"@R 9999-99-99")+"T"+time(),"")
	Local cDtBlq := iif(cOper=="B",transform(dtos(date()),"@R 9999-99-99")+"T"+time(),"")

	cOper := iif(cOper=="B","A",cOper)

	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cCod))

	sbm->(DbSetOrder(1))
	sbm->(dbseek(xfilial()+sb1->b1_grupo))

	sz8->(DbSetOrder(1))
	sz8->(dbseek(xfilial()+sb1->b1_xsubgrp))

	::FLAG_ACAO					:= cOper			//String	1	Sim	I (Inclusão)	A (Alteração)	E (Exclusão)
	::CODG_GRUPO_MATERIAL		:= sb1->b1_grupo	//String	15	Não	Código Grupo Material do sistema origem do cadastro de material
	::DESC_GRUPO_MATERIAL		:= alltrim(sbm->bm_desc)		//String	140	Não	Descrição Grupo Material
	::_CODG_CLASSE_MATERIAL		:= sb1->b1_xsubgrp	//String	15	Não	Código Classe Material do sistema origem do cadastro de material
	::DESC_CLASSE_MATERIAL		:= alltrim(sz8->z8_descri)	//String	140	Não	Descrição Classe Material
	::CODG_PDM					:= ""				//String	15	Não	Código PDM Material do sistema origem do cadastro de material
	::DESC_PDM					:= ""				//String	60	Não	Descrição PDM
	::DESC_PADRONIZADA			:= sb1->b1_desc		//String	60	Não	Descrição Material
	::DATA_CADASTRO				:= cDtCad			//Date			Não	Data cadastro Material
	::_CODG_UNIT_CSN			:= sb1->b1_um		//String	10	Sim	Código Unidade Consumo do sistema origem do cadastro de material
	::_DESC_UNIT_CSN			:= ""				//String	60	Não	Descrição Unidade de Consumo
	::_FLAG_DECIMAIS_CSN		:= ""				//String	1	Não	S ou N	Default=S	Indicativo se a qtde do material na Unid Consumo permite casas decimais
	::_FLAG_CTRL_INDIVIDUAL		:= ""				//String	1	Não	S ou N	Default=N	Indicativo se material é de controle individual
	::NUMR_CLASS_PATRIMONIAL	:= 2				//Integer		Não	Classe Patrimonial, Default = 2 (COM)	Enviar 2
	::DATA_BLOQUEIO				:= cDtBlq			//Date			Não	Data de bloqueio do material	Formato DD/MM/YYYY
	::CODG_FABRICANTE			:= ""				//String	15	Não	Código do Fabricante
	::DESC_FABRICANTE			:= ""				//String	60	Não	Descrição do fabricante
	::DESC_MODELO				:= ""				//String	50	Não	Descrição do Modelo
	::CODG_CLASS_PRECO			:= 1				//Integer		Não	1 – PMM	2 – Preço específico	Enviar 1
	::CODG_TIPO_MATERIAL		:= ""				//String	10	Não	Código Tipo Material do sistema origem do cadastro de material
	::DESC_TIPO_MATERIAL		:= ""				//String	60	Não	Descrição Tipo Material
	::_FLAG_CTRL_ESTQ_FAB		:= ""				//String	1	Não	S ou N	Default=N	Indicativo se é material de controle de estoque Fabricante no EQM
	::_FLAG_CTRL_DT_VENCIMENTO	:= ""				//String	1	Não	S ou N	Default=N	Indicativo se é material de controle de estoque por :: Vencimento no EQM
	::CODG_UNIT_COMPRA			:= ""				//String	30	Não	Código Unidade Compra do sistema origem do cadastro de material
	::DESC_UNIT_COMPRA			:= ""				//String	60	Não	Descrição Unidade de Compra
	::FLAG_DECIMAIS_COMPRA		:= ""				//String	1	Não	S ou N	Default =S	Indicativo se a qtde do material na Unid Compra permite casas decimais
	::CODG_SIT_MATERIAL			:= ""				//Integer		Não	Default=0	Enviar 0
	::FLAG_CTRL_PATRIMONIO		:= ""				//String	1	Não	S ou N	Default N	Indicativo de material é de controle patrimonial no EQM
	::NUMR_MATERIAL_EXTERNO		:= sb1->b1_cod		//String	30	Sim	Código material do sistema origem do cadastro de material
	::FLAG_ESTRUTURAMETALICA	:= ""				//String	1	Não	S ou N	Default=N	Indicativo se material é estrutura metálica
	::TEXT_OBSERVACAO			:= sb1->b1_xdescl	//String	2000Não	Observação
	::NUMR_MODRESSUPRIMENTO		:= 0				//Integer	1	Não	Default=0
	::NUMR_TIPORESSUPRIMENTO	:= 0				//Integer	1	Não	Default=0
	::NUMR_DESIG_MATERIAL		:= 0				//Integer	1	Não	Default=0

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class ativosCmms		/* Classe Contatos */

		data aAtivos
		// Declaração dos Métodos da Classe
		method new() constructor
		method add( oMaterial ) constructor

	endclass

method new() class ativosCmms

	::aAtivos := {}

Return Self

method add( oAtivos ) class ativosCmms

	aadd(::aAtivos, oAtivos)

Return Self


	class ativoCmms /* Classe ativos CMMS*/

		Data ___CODG_EQUIPAMENTO
		Data __DESC_EQUIPAMENTO
		Data __CODG_EQUIPE
		Data _DESC_EQUIPE
		Data _CODG_ESPECIALIDADE
		Data _DESC_ESPECIALIDADE
		Data CODG_ESPECIE
		Data DESC_ESPECIE
		Data CODG_FAMILIA
		Data DESC_FAMILIA
		Data CODG_ESTADO
		Data CODG_STATUS_EQUIPAMENTO
		Data DATA_ENT_OPERACAO
		Data NUMR_ANO_MES_FABRICACAO
		Data NUMR_SERIE
		Data DATA_GARANTIA
		Data DATA_AQUISICAO
		Data VALR_AQUISICAO
		Data _CODG_EMPRESA
		Data _DESC_EMPRESA
		Data CODG_INSTALACAO
		Data DESC_INSTALACAO
		Data __CODG_TIPO_INSTALACAO
		Data SIGL_COD_ALTERNATIVO_INST
		Data CODG_ADMINGROUP_FK
		Data FLAG_SETORIAL
		Data FLAG_POSTOAUTOATENDIMENTO
		Data DESC_INSC_ESTADUAL
		Data DESC_CPFCNPJ
		Data FLAG_ATIVA
		Data FLAG_VIRTUAL
		Data NUMR_PATRIMONIO
		Data VALR_IMOBILIZACAO
		Data CODG_CENTRO_CUSTO
		Data DESC_CENTRO_CUSTO
		Data CODG_LOCALIZACAO
		Data DESC_LOCALIZACAO
		Data SIGL_COD_ALTERNATIVO_LOC
		Data _DESC_COMPL_LOCALIZACAO
		Data TEXT_OBSERVACAO
		Data ORIGEM
		Data _CODG_EQUIPAMENTO_PAI
		Data CODG_FABRICANTE
		Data DESC_FABRICANTE
		Data DESC_MODELO
		Data CODG_UAR
		Data DESC_UAR
		Data CODG_TUC
		Data DESC_TUC
		Data _CODG_TIPO_BEM_FK
		Data DESC_TIPO_BEM
		Data CODG_CM_LOCAL_INST
		Data ACODG_CM_ARRANJO_FISICO
		Data _CODG_NIVEL_INTERVENCAO
		Data CODG_NIVEL_AUTORIZACAO
		Data NUMR_MTBF
		Data NUMR_PEDIDO
		Data NUMR_ITEM
		Data NUMR_NOTA_FISCAL
		Data DATA_NOTA
		Data FLAG_REDE_OPERACAO
		Data _CODG_ORGAO_USUARIO
		Data CODG_EQUIPAMENTO_REAL
		Data FLAG_GERAR_CODIGO
		Data CODG_ORGAO_ATIVO
		Data CODG_INDIC_CONTABIL_FK
		Data DESC_INDIC_CONTABIL
		Data OBJECTID
		Data PARENTOBJECTID
		Data REAL_OBJECTID
		Data DATA_SAIDA_OPERACAO
		Data CODG_DEPART_PREV
		Data DESC_VINCULACAO_PREV
		Data CODG_CENTRO_CUSTO_PREV
		Data DESC_CENTRO_CUSTO_PREV
		Data CODG_EMPRESA_PREV
		Data DESC_EMPRESA_PREV
		Data FLAG_DATA_GERACAO
		Data DATA_REFRENCIA_PREV
		Data DATA_MANUTENCAO_PREV
		Data NUMR_MEDIA_PREV
		Data NUMR_MAXIMO_PREV
		Data CODG_ODI
		Data _SIGL_TIPO_UC
		Data SIGL_TIPO_BEM
		Data NUMR_ULTIMO_VALOR_PREV
		Data ___CODG_EXTERNO_UF
		Data DESC_MAT_UF
		Data __CODG_EXTERNO_MUNIC
		Data DESC_MUNICIPIO
		Data _CODG_EXTERNO_BAIRRO
		Data DESC_BAIRRO
		Data CODG_EXTERNO_LOGRA
		Data DESC_LOGRADOURO
		Data DESC_COMPL_END
		Data CODG_NCA
		Data GPS_X
		Data GPS_Y
		Data GPS_Z
		Data CODG_TIPO_INSTALACAO_PAI

		method new() constructor
		method buscar( cCod, cChaNF, cOpc ) constructor

	endclass

method new() class ativoCmms

	::___CODG_EQUIPAMENTO		:= ""
	::__DESC_EQUIPAMENTO		:= ""
	::__CODG_EQUIPE				:= ""
	::_DESC_EQUIPE				:= ""
	::_CODG_ESPECIALIDADE		:= ""
	::_DESC_ESPECIALIDADE		:= ""
	::CODG_ESPECIE				:= ""
	::DESC_ESPECIE				:= ""
	::CODG_FAMILIA				:= ""
	::DESC_FAMILIA				:= ""
	::CODG_ESTADO				:= ""
	::CODG_STATUS_EQUIPAMENTO	:= 0
	::DATA_ENT_OPERACAO			:= ""
	::NUMR_ANO_MES_FABRICACAO	:= ""
	::NUMR_SERIE				:= ""
	::DATA_GARANTIA				:= ""
	::DATA_AQUISICAO			:= ""
	::VALR_AQUISICAO			:= 0
	::_CODG_EMPRESA				:= ""
	::_DESC_EMPRESA				:= ""
	::CODG_INSTALACAO			:= ""
	::DESC_INSTALACAO			:= ""
	::__CODG_TIPO_INSTALACAO	:= ""
	::SIGL_COD_ALTERNATIVO_INST	:= ""
	::CODG_ADMINGROUP_FK		:= ""
	::FLAG_SETORIAL				:= ""
	::FLAG_POSTOAUTOATENDIMENTO	:= ""
	::DESC_INSC_ESTADUAL		:= ""
	::DESC_CPFCNPJ				:= ""
	::FLAG_ATIVA				:= ""
	::FLAG_VIRTUAL				:= ""
	::NUMR_PATRIMONIO			:= ""
	::VALR_IMOBILIZACAO			:= 0
	::CODG_CENTRO_CUSTO			:= ""
	::DESC_CENTRO_CUSTO			:= ""
	::CODG_LOCALIZACAO			:= ""
	::DESC_LOCALIZACAO			:= ""
	::SIGL_COD_ALTERNATIVO_LOC	:= ""
	::_DESC_COMPL_LOCALIZACAO	:= ""
	::TEXT_OBSERVACAO			:= ""
	::ORIGEM					:= ""
	::_CODG_EQUIPAMENTO_PAI		:= ""
	::CODG_FABRICANTE			:= 0
	::DESC_FABRICANTE			:= ""
	::DESC_MODELO				:= ""
	::CODG_UAR					:= 0
	::DESC_UAR					:= ""
	::CODG_TUC					:= 0
	::DESC_TUC					:= ""
	::_CODG_TIPO_BEM_FK			:= 0
	::DESC_TIPO_BEM				:= ""
	::CODG_CM_LOCAL_INST		:= ""
	::ACODG_CM_ARRANJO_FISICO	:= ""
	::_CODG_NIVEL_INTERVENCAO	:= 0
	::CODG_NIVEL_AUTORIZACAO	:= 0
	::NUMR_MTBF					:= 0
	::NUMR_PEDIDO				:= ""
	::NUMR_ITEM					:= 0
	::NUMR_NOTA_FISCAL			:= ""
	::DATA_NOTA					:= ""
	::FLAG_REDE_OPERACAO		:= ""
	::_CODG_ORGAO_USUARIO		:= ""
	::CODG_EQUIPAMENTO_REAL		:= ""
	::FLAG_GERAR_CODIGO			:= ""
	::CODG_ORGAO_ATIVO			:= ""
	::CODG_INDIC_CONTABIL_FK	:= ""
	::DESC_INDIC_CONTABIL		:= ""
	::OBJECTID					:= ""
	::PARENTOBJECTID			:= ""
	::REAL_OBJECTID				:= ""
	::DATA_SAIDA_OPERACAO		:= ""
	::CODG_DEPART_PREV			:= ""
	::DESC_VINCULACAO_PREV		:= ""
	::CODG_CENTRO_CUSTO_PREV	:= ""
	::DESC_CENTRO_CUSTO_PREV	:= ""
	::CODG_EMPRESA_PREV			:= ""
	::DESC_EMPRESA_PREV			:= ""
	::FLAG_DATA_GERACAO			:= ""
	::DATA_REFRENCIA_PREV		:= ""
	::DATA_MANUTENCAO_PREV		:= ""
	::NUMR_MEDIA_PREV			:= 0
	::NUMR_MAXIMO_PREV			:= 0
	::CODG_ODI					:= 0
	::_SIGL_TIPO_UC				:= ""
	::SIGL_TIPO_BEM				:= ""
	::NUMR_ULTIMO_VALOR_PREV	:= 0
	::___CODG_EXTERNO_UF		:= ""
	::DESC_MAT_UF				:= ""
	::__CODG_EXTERNO_MUNIC		:= ""
	::DESC_MUNICIPIO			:= ""
	::_CODG_EXTERNO_BAIRRO		:= ""
	::DESC_BAIRRO				:= ""
	::CODG_EXTERNO_LOGRA		:= ""
	::DESC_LOGRADOURO			:= ""
	::DESC_COMPL_END			:= ""
	::CODG_NCA					:= ""
	::GPS_X						:= 0
	::GPS_Y						:= 0
	::GPS_Z						:= 0
	::CODG_TIPO_INSTALACAO_PAI	:= ""

Return Self

method buscar( cCod, cChaNF, cOpc ) Class ativoCmms

	Local aAreaS := { sf1->(GetArea()), sb1->(GetArea()), GetArea() }

	Local cEstado := ""
	Local cDoc := ""
	Local cDTHr := ""
	Local nValFat := 0

	sb1->(DbSetOrder(1))
	sb1->(dbseek(xfilial()+cCod))

	if cOpc == "E"
		cEstado	:= "D"
	else
		cEstado := "C"
	endif

	if !empty(cChaNF)
		sf1->( dbSetOrder(1) )
		if sf1->( dbSeek(cChaNF) )
			cDoc := sf1->f1_doc
			cDTHr := transform(dtos(sf1->f1_emissao),"@R 9999-99-99")+"T"+iif(empty(sf1->f1_hora),time(),sf1->f1_hora)
			nValFat	:= sf1->f1_valbrut
		endif
	endif

	::___CODG_EQUIPAMENTO		:= sb1->b1_cod		//String	100	Sim	Código enviado pelo ERP. É a chave do Ativo no ERP. Este Ativo poderá ser um Equipamento ou a própria Subestação ou a Linha de Transmissão. 	B1_CODE(?)
	::__DESC_EQUIPAMENTO		:= sb1->b1_desc		//String	120 Sim	É a descrição do Ativo. Foram identificados dois campos no ERP. Riane irá avaliar qual deverá ser enviado.	B1_DESC
	::__CODG_EQUIPE				:= ""				//String	15	Não	Código Equipe EQM
	::_DESC_EQUIPE				:= ""				//String	30	Não	Descrição Equipe EQM
	::_CODG_ESPECIALIDADE		:= ""				//String	15	Não	Código Especialidade EQM
	::_DESC_ESPECIALIDADE		:= ""				//String	30	Não	Descrição especialidade EQM
	::CODG_ESPECIE				:= ""				//String	5	Não	Código Espécie	Poderá ser atribuída uma Espécie default, que será ajustada diretamente no EQM
	::DESC_ESPECIE				:= ""				//String	60	Não	Descrição Espécie
	::CODG_FAMILIA				:= ""				//String	15	Não	Código Família EQM
	::DESC_FAMILIA				:= ""				//String	60	Não	Descrição Família EQM
	::CODG_ESTADO				:= cEstado			//String	30	Sim	Enviar ‘C’	Estado do Ativo, onde A = 'ATIVO', I - 'INATIVO', D - 'DESCARTADO', C - 'EM AQUISIÇÃO'	Enviar “C”
	::CODG_STATUS_EQUIPAMENTO	:= 0				//Number		Não	Status Ativo, 1-Transito;2-	Avariado;3-	Perda;4-Disponivel;5-Reservado;6-Fora do Almoxarifado;7-Guardado;8-	Alienação;9-Alienado;10-Emprestado;11-Recuperação;12-Externo (GRT);13-Inventário Falta;14-Depósito Setorial;15-Trânsito GRM
	::DATA_ENT_OPERACAO			:= ""				//Date			Não	::Entrada Operação	Enviar apenas se o Status for “A”
	::NUMR_ANO_MES_FABRICACAO	:= ""				//String	6	Não	Ano Mês de Fabricação (YYYYMM)	Avaliar se existe informação no Protheus
	::NUMR_SERIE				:= ""				//String	20	Não	Número Série	Avaliar se existe informação no Protheus
	::DATA_GARANTIA				:= ""				//Date			Não	::garantia	Avaliar se existe informação no Protheus
	::DATA_AQUISICAO			:= ""				//Date			Não	::aquisição	Avaliar se existe informação no Protheus
	::VALR_AQUISICAO			:= nValFat			//String	60	Não	Valor aquisição	Avaliar se existe informação no Protheus
	::_CODG_EMPRESA				:= sm0->m0_codfil	//String	15	Sim	Código Empresa proprietária do Ativo	Código Empresa Protheus
	::_DESC_EMPRESA				:= sm0->m0_nomecom	//String	60	Sim	Descrição Empresa (Obrigatória caso não informado código)	Não enviar
	::CODG_INSTALACAO			:= ""				//String	15	Não	Código Instalação EQM
	::DESC_INSTALACAO			:= ""				//String	60	Não	Descrição Instalação (Default Parametrizado no EQM)	Não enviar
	::__CODG_TIPO_INSTALACAO	:= ""				//String	15	Não	Código Tipo Instalação (Mapeamento)
	::SIGL_COD_ALTERNATIVO_INST	:= ""				//String	20	Sim	Código que representa Instalação do Ativo no sistema externo
	::CODG_ADMINGROUP_FK		:= ""				//String	15	Não	Sistema Organizacional, Default = 'EQM'	Enviar EQM
	::FLAG_SETORIAL				:= ""				//String	1	Não	Default “N”	Não Enviar
	::FLAG_POSTOAUTOATENDIMENTO	:= ""				//String	1	Não	Valor S ou N, Default = 'N'	Não Enviar
	::DESC_INSC_ESTADUAL		:= ""				//String	20	Não	Inscrição Estadual	Não Enviar
	::DESC_CPFCNPJ				:= ""				//String	18	Não	CPF/CNPJ da instalação	Não Enviar
	::FLAG_ATIVA				:= ""				//String	1	Não	Default = 'S'	Não Enviar
	::FLAG_VIRTUAL				:= ""				//String	1	Não	Valor S ou N, Default = 'N'	Não Enviar
	::NUMR_PATRIMONIO			:= ""				//String	40	Não	Número Patrimônio	Avaliar se informação existe no Protheus
	::VALR_IMOBILIZACAO			:= 0				//Number		Não	Valor Imobilização	Avaliar se informação existe no Protheus
	::CODG_CENTRO_CUSTO			:= ""				//String	15	Não Código do Centro de Custo de aquisição do Ativo (Precisa já existir no EQM). Será identificado a partir da Conta de Despesa do Ativo no ERP	Avaliar se informação existe no Protheus. Enviar código do Centro Custo do Protheus que deverá ser previamente cadastrado no EQM
	::DESC_CENTRO_CUSTO			:= ""				//String	60	Não	Descrição Centro de custo (Se não informado código tenta encontrar pela descrição)	Não enviar
	::CODG_LOCALIZACAO			:= ""				//String	15	Não	Código Localização	Não enviar
	::DESC_LOCALIZACAO			:= ""				//String	30	Não Descrição Localização (Se não informado codigo tenta encontrar pela descrição)	Avaliar se existe informação no Protheus. Exemplo a posição operacional do Ativo
	::SIGL_COD_ALTERNATIVO_LOC	:= ""				//String	30	Não	Código da Localização do Ativo no sistema externo	Enviar código Protheus caso exista um atributo que indique a localização
	::_DESC_COMPL_LOCALIZACAO	:= ""				//String	30	Não	Complemento Localização	Texto complementar da Localização
	::TEXT_OBSERVACAO			:= ""				//String	200	Não	Observação	Texto
	::ORIGEM					:= "EQP"			//String	10	Sim	Enviar LCI ou EQP Origem, onde LCI - Local de instalação e  EQP - Equipamento	Enviar EQP
	::_CODG_EQUIPAMENTO_PAI		:= ""				//String	100	Não	Código do Ativo PAI no ERP. É a chave do Ativo PAI	Avaliar a estrutura do Protheus Ou Não Enviar
	::CODG_FABRICANTE			:= 0				//Number		Não	Código fabricante	Não Enviar
	::DESC_FABRICANTE			:= ""				//String	60	Não	Descrição Fabricante (Se não informado código tenta encontrar pela descrição)	Avaliar se informação existe no Protheus. Enviar descrição do fabricante Ou Não enviar
	::DESC_MODELO				:= ""				//String	20	Não	Modelo	Campo descritivo que indique o Modelo Ou Não Enviar
	::CODG_UAR					:= 0				//Number		Não Código UAR MCPSE	Avaliar se as informações relacionadas com a classificação patrimonial do Ativo irão migrar do Protheus para o EQM Ou Não Enviar
	::DESC_UAR					:= ""				//String	300	Não	Descrição UAR
	::CODG_TUC					:= 0				//Number		Não	Código TUC MCPSE
	::DESC_TUC					:= ""				//String	100	Não	Descrição TUC
	::_CODG_TIPO_BEM_FK			:= 0				//Number		Não	Código Tipo Bem MCPSE
	::DESC_TIPO_BEM				:= ""				//String	300	Não	Descrição Tipo do Bem
	::CODG_CM_LOCAL_INST		:= ""				//String	15	Não	Centro Modular Local Instalação
	::ACODG_CM_ARRANJO_FISICO	:= ""				//String	15	Não	Centro Modular Arranjo físico
	::_CODG_NIVEL_INTERVENCAO	:= 0				//Number		Não	Nivel Intervenção 0 - Exige Desligamento;1 - Não exige autorização;2 - Obrigatório criação do PES	Não Enviar
	::CODG_NIVEL_AUTORIZACAO	:= 0				//Number		Não	Nivel Autorização 0- Não Exige Autorização;1 - Autorização Operação Regional;2 - Autorização Operação Central	Não enviar
	::NUMR_MTBF					:= 0				//Number		Não	Tempo médio entre falhas	Não Enviar
	::NUMR_PEDIDO				:= ""				//String	15	Não	Número de Pedido de Compra	Avaliar se informações existem no Protheus Ou Não Enviar
	::NUMR_ITEM					:= 0				//Number		Não	Número item pedido
	::NUMR_NOTA_FISCAL			:= cDoc				//String	20	Não	Número Nota fiscal
	::DATA_NOTA					:= cDTHr			//Date			Não	data nota fiscal
	::FLAG_REDE_OPERACAO		:= ""				//String	1	Não	Rede Operação Valores 'S' ou 'N' Default = 'N'	Não Enviar
	::_CODG_ORGAO_USUARIO		:= ""				//String	20	Não	Orgão Usuario (Codigo ou Descrição ou Sigla do EQM)	Não Enviar
	::CODG_EQUIPAMENTO_REAL		:= ""				//String	100	Não	Equipamento Real	Não Enviar
	::FLAG_GERAR_CODIGO			:= "S"				//String	1	Não	Enviar ‘S’	Flag Gera Codigo valores 'S' ou 'N', Se 'N' informar OBJECTID	Enviar S
	::CODG_ORGAO_ATIVO			:= ""				//String	20	Não	Orgão Ativo (Código ou Descrição ou Sigla do EQM)	Não Enviar
	::CODG_INDIC_CONTABIL_FK	:= ""				//String	15	Não	Codigo Indicador Contabil	Não Enviar
	::DESC_INDIC_CONTABIL		:= ""				//String	100	Não	Descrição Indicador Contabil	Não Enviar
	::OBJECTID					:= ""				//String	15	Não	Código Ativo EQM	Não Enviar
	::PARENTOBJECTID			:= ""				//String	15	Não	Código Ativo Pai EQM	Não Enviar
	::REAL_OBJECTID				:= ""				//String	15	Não	Código Ativo Real EQM	Não Enviar
	::DATA_SAIDA_OPERACAO		:= ""				//Date			Não	Data saída operação	Não Enviar
	::CODG_DEPART_PREV			:= ""				//String	15	Não	Equipe Preventiva EQM	Não Enviar
	::DESC_VINCULACAO_PREV		:= ""				//String	60	Não	Vinculação Preventiva EQM	Não Enviar
	::CODG_CENTRO_CUSTO_PREV	:= ""				//String	15	Não	Centro de Custo Preventiva EQM	Não Enviar
	::DESC_CENTRO_CUSTO_PREV	:= ""				//String	60	Não	Descrição centro custo preventiva EQM	Não Enviar
	::CODG_EMPRESA_PREV			:= ""				//String	15	Não	Código Empresa preventiva EQM	Não Enviar
	::DESC_EMPRESA_PREV			:= ""				//String	60	Não	Descrição Empresa preventiva EQM	Não Enviar
	::FLAG_DATA_GERACAO			:= ""				//String	2	Não	para gerar OS Preventiva EQM	Não Enviar
	::DATA_REFRENCIA_PREV		:= ""				//Date			Não	data de referencia Preventiva EQM	Não Enviar
	::DATA_MANUTENCAO_PREV		:= ""				//Date			Não	data ultima execução da Preventiva EQM	Não Enviar
	::NUMR_MEDIA_PREV			:= 0				//Number		Não	Media diaria da Preventiva EQM	Não Enviar
	::NUMR_MAXIMO_PREV			:= 0				//Number		Não	Valor Maximo (Caracteristicas) Preventiva EQM	Não Enviar
	::CODG_ODI					:= 0				//Number		Não	Código Ordem curso (ODI)	Avaliar se as informações relacionadas com a classificação patrimonial do Ativo irão migrar do Protheus para o EQM Ou Não Enviar
	::_SIGL_TIPO_UC				:= ""				//String	5	Não	Sigla TUC Enviar o novo campo detalhe TUC_COD. Enviar o código. Não é a descrição. Exemplo: 575
	::SIGL_TIPO_BEM				:= ""				//String	5	Não	Sigla Tipo Bem
	::NUMR_ULTIMO_VALOR_PREV	:= 0				//Number		Não	Ultimo Valor Preventiva EQM	Não enviar
	::___CODG_EXTERNO_UF		:= ""				//String	30	Não	Sigla Unidade Federativa	Não enviar
	::DESC_MAT_UF				:= ""				//String	100	Não	Descrição unidade federativa	Não enviar
	::__CODG_EXTERNO_MUNIC		:= ""				//String 	30	Não	Código externo município	Não enviar
	::DESC_MUNICIPIO			:= ""				//String	100	Não	Descrição município	Não enviar
	::_CODG_EXTERNO_BAIRRO		:= ""				//String	30	Não	Código Bairro externo	Não enviar
	::DESC_BAIRRO				:= ""				//String	100	Não	Descrição bairro	Não enviar
	::CODG_EXTERNO_LOGRA		:= ""				//String	30	Não	Código externo logradouro	Não enviar
	::DESC_LOGRADOURO			:= ""				//String	100	Não	Descrição logradouro	Não enviar
	::DESC_COMPL_END			:= ""				//String	100	Não	Complemento	Não enviar
	::CODG_NCA					:= ""				//String	60	Não	Código NCA	Não enviar
	::GPS_X						:= 0				//Number		Não	GPS X	Não enviar
	::GPS_Y						:= 0				//Number		Não	GPS Y	Não enviar
	::GPS_Z						:= 0				//Number		Não	GPS Z	Não enviar
	::CODG_TIPO_INSTALACAO_PAI	:= ""				//String 	15	Não	Codigo Tipo Instalação (Patrimonio)	Avaliar se as informações relacionadas com a classificação patrimonial do Ativo irão migrar do Protheus para o EQM Ou Não Enviar

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self
