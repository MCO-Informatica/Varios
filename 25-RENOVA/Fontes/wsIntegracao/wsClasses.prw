#include "protheus.ch"
/* Defini��o Classes Cmms */

class materiaisCmms		/* Classe Contatos */

	data aMateriais
	// Declara��o dos M�todos da Classe
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

	::FLAG_ACAO					:= cOper			//String	1	Sim	I (Inclus�o)	A (Altera��o)	E (Exclus�o)
	::CODG_GRUPO_MATERIAL		:= sb1->b1_grupo	//String	15	N�o	C�digo Grupo Material do sistema origem do cadastro de material
	::DESC_GRUPO_MATERIAL		:= alltrim(sbm->bm_desc)		//String	140	N�o	Descri��o Grupo Material
	::_CODG_CLASSE_MATERIAL		:= sb1->b1_xsubgrp	//String	15	N�o	C�digo Classe Material do sistema origem do cadastro de material
	::DESC_CLASSE_MATERIAL		:= alltrim(sz8->z8_descri)	//String	140	N�o	Descri��o Classe Material
	::CODG_PDM					:= ""				//String	15	N�o	C�digo PDM Material do sistema origem do cadastro de material
	::DESC_PDM					:= ""				//String	60	N�o	Descri��o PDM
	::DESC_PADRONIZADA			:= sb1->b1_desc		//String	60	N�o	Descri��o Material
	::DATA_CADASTRO				:= cDtCad			//Date			N�o	Data cadastro Material
	::_CODG_UNIT_CSN			:= sb1->b1_um		//String	10	Sim	C�digo Unidade Consumo do sistema origem do cadastro de material
	::_DESC_UNIT_CSN			:= ""				//String	60	N�o	Descri��o Unidade de Consumo
	::_FLAG_DECIMAIS_CSN		:= ""				//String	1	N�o	S ou N	Default=S	Indicativo se a qtde do material na Unid Consumo permite casas decimais
	::_FLAG_CTRL_INDIVIDUAL		:= ""				//String	1	N�o	S ou N	Default=N	Indicativo se material � de controle individual
	::NUMR_CLASS_PATRIMONIAL	:= 2				//Integer		N�o	Classe Patrimonial, Default = 2 (COM)	Enviar 2
	::DATA_BLOQUEIO				:= cDtBlq			//Date			N�o	Data de bloqueio do material	Formato DD/MM/YYYY
	::CODG_FABRICANTE			:= ""				//String	15	N�o	C�digo do Fabricante
	::DESC_FABRICANTE			:= ""				//String	60	N�o	Descri��o do fabricante
	::DESC_MODELO				:= ""				//String	50	N�o	Descri��o do Modelo
	::CODG_CLASS_PRECO			:= 1				//Integer		N�o	1 � PMM	2 � Pre�o espec�fico	Enviar 1
	::CODG_TIPO_MATERIAL		:= ""				//String	10	N�o	C�digo Tipo Material do sistema origem do cadastro de material
	::DESC_TIPO_MATERIAL		:= ""				//String	60	N�o	Descri��o Tipo Material
	::_FLAG_CTRL_ESTQ_FAB		:= ""				//String	1	N�o	S ou N	Default=N	Indicativo se � material de controle de estoque Fabricante no EQM
	::_FLAG_CTRL_DT_VENCIMENTO	:= ""				//String	1	N�o	S ou N	Default=N	Indicativo se � material de controle de estoque por :: Vencimento no EQM
	::CODG_UNIT_COMPRA			:= ""				//String	30	N�o	C�digo Unidade Compra do sistema origem do cadastro de material
	::DESC_UNIT_COMPRA			:= ""				//String	60	N�o	Descri��o Unidade de Compra
	::FLAG_DECIMAIS_COMPRA		:= ""				//String	1	N�o	S ou N	Default =S	Indicativo se a qtde do material na Unid Compra permite casas decimais
	::CODG_SIT_MATERIAL			:= ""				//Integer		N�o	Default=0	Enviar 0
	::FLAG_CTRL_PATRIMONIO		:= ""				//String	1	N�o	S ou N	Default N	Indicativo de material � de controle patrimonial no EQM
	::NUMR_MATERIAL_EXTERNO		:= sb1->b1_cod		//String	30	Sim	C�digo material do sistema origem do cadastro de material
	::FLAG_ESTRUTURAMETALICA	:= ""				//String	1	N�o	S ou N	Default=N	Indicativo se material � estrutura met�lica
	::TEXT_OBSERVACAO			:= sb1->b1_xdescl	//String	2000N�o	Observa��o
	::NUMR_MODRESSUPRIMENTO		:= 0				//Integer	1	N�o	Default=0
	::NUMR_TIPORESSUPRIMENTO	:= 0				//Integer	1	N�o	Default=0
	::NUMR_DESIG_MATERIAL		:= 0				//Integer	1	N�o	Default=0

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self


	class ativosCmms		/* Classe Contatos */

		data aAtivos
		// Declara��o dos M�todos da Classe
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

	::___CODG_EQUIPAMENTO		:= sb1->b1_cod		//String	100	Sim	C�digo enviado pelo ERP. � a chave do Ativo no ERP. Este Ativo poder� ser um Equipamento ou a pr�pria Subesta��o ou a Linha de Transmiss�o. 	B1_CODE(?)
	::__DESC_EQUIPAMENTO		:= sb1->b1_desc		//String	120 Sim	� a descri��o do Ativo. Foram identificados dois campos no ERP. Riane ir� avaliar qual dever� ser enviado.	B1_DESC
	::__CODG_EQUIPE				:= ""				//String	15	N�o	C�digo Equipe EQM
	::_DESC_EQUIPE				:= ""				//String	30	N�o	Descri��o Equipe EQM
	::_CODG_ESPECIALIDADE		:= ""				//String	15	N�o	C�digo Especialidade EQM
	::_DESC_ESPECIALIDADE		:= ""				//String	30	N�o	Descri��o especialidade EQM
	::CODG_ESPECIE				:= ""				//String	5	N�o	C�digo Esp�cie	Poder� ser atribu�da uma Esp�cie default, que ser� ajustada diretamente no EQM
	::DESC_ESPECIE				:= ""				//String	60	N�o	Descri��o Esp�cie
	::CODG_FAMILIA				:= ""				//String	15	N�o	C�digo Fam�lia EQM
	::DESC_FAMILIA				:= ""				//String	60	N�o	Descri��o Fam�lia EQM
	::CODG_ESTADO				:= cEstado			//String	30	Sim	Enviar �C�	Estado do Ativo, onde A = 'ATIVO', I - 'INATIVO', D - 'DESCARTADO', C - 'EM AQUISI��O'	Enviar �C�
	::CODG_STATUS_EQUIPAMENTO	:= 0				//Number		N�o	Status Ativo, 1-Transito;2-	Avariado;3-	Perda;4-Disponivel;5-Reservado;6-Fora do Almoxarifado;7-Guardado;8-	Aliena��o;9-Alienado;10-Emprestado;11-Recupera��o;12-Externo (GRT);13-Invent�rio Falta;14-Dep�sito Setorial;15-Tr�nsito GRM
	::DATA_ENT_OPERACAO			:= ""				//Date			N�o	::Entrada Opera��o	Enviar apenas se o Status for �A�
	::NUMR_ANO_MES_FABRICACAO	:= ""				//String	6	N�o	Ano M�s de Fabrica��o (YYYYMM)	Avaliar se existe informa��o no Protheus
	::NUMR_SERIE				:= ""				//String	20	N�o	N�mero S�rie	Avaliar se existe informa��o no Protheus
	::DATA_GARANTIA				:= ""				//Date			N�o	::garantia	Avaliar se existe informa��o no Protheus
	::DATA_AQUISICAO			:= ""				//Date			N�o	::aquisi��o	Avaliar se existe informa��o no Protheus
	::VALR_AQUISICAO			:= nValFat			//String	60	N�o	Valor aquisi��o	Avaliar se existe informa��o no Protheus
	::_CODG_EMPRESA				:= sm0->m0_codfil	//String	15	Sim	C�digo Empresa propriet�ria do Ativo	C�digo Empresa Protheus
	::_DESC_EMPRESA				:= sm0->m0_nomecom	//String	60	Sim	Descri��o Empresa (Obrigat�ria caso n�o informado c�digo)	N�o enviar
	::CODG_INSTALACAO			:= ""				//String	15	N�o	C�digo Instala��o EQM
	::DESC_INSTALACAO			:= ""				//String	60	N�o	Descri��o Instala��o (Default Parametrizado no EQM)	N�o enviar
	::__CODG_TIPO_INSTALACAO	:= ""				//String	15	N�o	C�digo Tipo Instala��o (Mapeamento)
	::SIGL_COD_ALTERNATIVO_INST	:= ""				//String	20	Sim	C�digo que representa Instala��o do Ativo no sistema externo
	::CODG_ADMINGROUP_FK		:= ""				//String	15	N�o	Sistema Organizacional, Default = 'EQM'	Enviar EQM
	::FLAG_SETORIAL				:= ""				//String	1	N�o	Default �N�	N�o Enviar
	::FLAG_POSTOAUTOATENDIMENTO	:= ""				//String	1	N�o	Valor S ou N, Default = 'N'	N�o Enviar
	::DESC_INSC_ESTADUAL		:= ""				//String	20	N�o	Inscri��o Estadual	N�o Enviar
	::DESC_CPFCNPJ				:= ""				//String	18	N�o	CPF/CNPJ da instala��o	N�o Enviar
	::FLAG_ATIVA				:= ""				//String	1	N�o	Default = 'S'	N�o Enviar
	::FLAG_VIRTUAL				:= ""				//String	1	N�o	Valor S ou N, Default = 'N'	N�o Enviar
	::NUMR_PATRIMONIO			:= ""				//String	40	N�o	N�mero Patrim�nio	Avaliar se informa��o existe no Protheus
	::VALR_IMOBILIZACAO			:= 0				//Number		N�o	Valor Imobiliza��o	Avaliar se informa��o existe no Protheus
	::CODG_CENTRO_CUSTO			:= ""				//String	15	N�o C�digo do Centro de Custo de aquisi��o do Ativo (Precisa j� existir no EQM). Ser� identificado a partir da Conta de Despesa do Ativo no ERP	Avaliar se informa��o existe no Protheus. Enviar c�digo do Centro Custo do Protheus que dever� ser previamente cadastrado no EQM
	::DESC_CENTRO_CUSTO			:= ""				//String	60	N�o	Descri��o Centro de custo (Se n�o informado c�digo tenta encontrar pela descri��o)	N�o enviar
	::CODG_LOCALIZACAO			:= ""				//String	15	N�o	C�digo Localiza��o	N�o enviar
	::DESC_LOCALIZACAO			:= ""				//String	30	N�o Descri��o Localiza��o (Se n�o informado codigo tenta encontrar pela descri��o)	Avaliar se existe informa��o no Protheus. Exemplo a posi��o operacional do Ativo
	::SIGL_COD_ALTERNATIVO_LOC	:= ""				//String	30	N�o	C�digo da Localiza��o do Ativo no sistema externo	Enviar c�digo Protheus caso exista um atributo que indique a localiza��o
	::_DESC_COMPL_LOCALIZACAO	:= ""				//String	30	N�o	Complemento Localiza��o	Texto complementar da Localiza��o
	::TEXT_OBSERVACAO			:= ""				//String	200	N�o	Observa��o	Texto
	::ORIGEM					:= "EQP"			//String	10	Sim	Enviar LCI ou EQP Origem, onde LCI - Local de instala��o e  EQP - Equipamento	Enviar EQP
	::_CODG_EQUIPAMENTO_PAI		:= ""				//String	100	N�o	C�digo do Ativo PAI no ERP. � a chave do Ativo PAI	Avaliar a estrutura do Protheus Ou N�o Enviar
	::CODG_FABRICANTE			:= 0				//Number		N�o	C�digo fabricante	N�o Enviar
	::DESC_FABRICANTE			:= ""				//String	60	N�o	Descri��o Fabricante (Se n�o informado c�digo tenta encontrar pela descri��o)	Avaliar se informa��o existe no Protheus. Enviar descri��o do fabricante Ou N�o enviar
	::DESC_MODELO				:= ""				//String	20	N�o	Modelo	Campo descritivo que indique o Modelo Ou N�o Enviar
	::CODG_UAR					:= 0				//Number		N�o C�digo UAR MCPSE	Avaliar se as informa��es relacionadas com a classifica��o patrimonial do Ativo ir�o migrar do Protheus para o EQM Ou N�o Enviar
	::DESC_UAR					:= ""				//String	300	N�o	Descri��o UAR
	::CODG_TUC					:= 0				//Number		N�o	C�digo TUC MCPSE
	::DESC_TUC					:= ""				//String	100	N�o	Descri��o TUC
	::_CODG_TIPO_BEM_FK			:= 0				//Number		N�o	C�digo Tipo Bem MCPSE
	::DESC_TIPO_BEM				:= ""				//String	300	N�o	Descri��o Tipo do Bem
	::CODG_CM_LOCAL_INST		:= ""				//String	15	N�o	Centro Modular Local Instala��o
	::ACODG_CM_ARRANJO_FISICO	:= ""				//String	15	N�o	Centro Modular Arranjo f�sico
	::_CODG_NIVEL_INTERVENCAO	:= 0				//Number		N�o	Nivel Interven��o 0 - Exige Desligamento;1 - N�o exige autoriza��o;2 - Obrigat�rio cria��o do PES	N�o Enviar
	::CODG_NIVEL_AUTORIZACAO	:= 0				//Number		N�o	Nivel Autoriza��o 0- N�o Exige Autoriza��o;1 - Autoriza��o Opera��o Regional;2 - Autoriza��o Opera��o Central	N�o enviar
	::NUMR_MTBF					:= 0				//Number		N�o	Tempo m�dio entre falhas	N�o Enviar
	::NUMR_PEDIDO				:= ""				//String	15	N�o	N�mero de Pedido de Compra	Avaliar se informa��es existem no Protheus Ou N�o Enviar
	::NUMR_ITEM					:= 0				//Number		N�o	N�mero item pedido
	::NUMR_NOTA_FISCAL			:= cDoc				//String	20	N�o	N�mero Nota fiscal
	::DATA_NOTA					:= cDTHr			//Date			N�o	data nota fiscal
	::FLAG_REDE_OPERACAO		:= ""				//String	1	N�o	Rede Opera��o Valores 'S' ou 'N' Default = 'N'	N�o Enviar
	::_CODG_ORGAO_USUARIO		:= ""				//String	20	N�o	Org�o Usuario (Codigo ou Descri��o ou Sigla do EQM)	N�o Enviar
	::CODG_EQUIPAMENTO_REAL		:= ""				//String	100	N�o	Equipamento Real	N�o Enviar
	::FLAG_GERAR_CODIGO			:= "S"				//String	1	N�o	Enviar �S�	Flag Gera Codigo valores 'S' ou 'N', Se 'N' informar OBJECTID	Enviar S
	::CODG_ORGAO_ATIVO			:= ""				//String	20	N�o	Org�o Ativo (C�digo ou Descri��o ou Sigla do EQM)	N�o Enviar
	::CODG_INDIC_CONTABIL_FK	:= ""				//String	15	N�o	Codigo Indicador Contabil	N�o Enviar
	::DESC_INDIC_CONTABIL		:= ""				//String	100	N�o	Descri��o Indicador Contabil	N�o Enviar
	::OBJECTID					:= ""				//String	15	N�o	C�digo Ativo EQM	N�o Enviar
	::PARENTOBJECTID			:= ""				//String	15	N�o	C�digo Ativo Pai EQM	N�o Enviar
	::REAL_OBJECTID				:= ""				//String	15	N�o	C�digo Ativo Real EQM	N�o Enviar
	::DATA_SAIDA_OPERACAO		:= ""				//Date			N�o	Data sa�da opera��o	N�o Enviar
	::CODG_DEPART_PREV			:= ""				//String	15	N�o	Equipe Preventiva EQM	N�o Enviar
	::DESC_VINCULACAO_PREV		:= ""				//String	60	N�o	Vincula��o Preventiva EQM	N�o Enviar
	::CODG_CENTRO_CUSTO_PREV	:= ""				//String	15	N�o	Centro de Custo Preventiva EQM	N�o Enviar
	::DESC_CENTRO_CUSTO_PREV	:= ""				//String	60	N�o	Descri��o centro custo preventiva EQM	N�o Enviar
	::CODG_EMPRESA_PREV			:= ""				//String	15	N�o	C�digo Empresa preventiva EQM	N�o Enviar
	::DESC_EMPRESA_PREV			:= ""				//String	60	N�o	Descri��o Empresa preventiva EQM	N�o Enviar
	::FLAG_DATA_GERACAO			:= ""				//String	2	N�o	para gerar OS Preventiva EQM	N�o Enviar
	::DATA_REFRENCIA_PREV		:= ""				//Date			N�o	data de referencia Preventiva EQM	N�o Enviar
	::DATA_MANUTENCAO_PREV		:= ""				//Date			N�o	data ultima execu��o da Preventiva EQM	N�o Enviar
	::NUMR_MEDIA_PREV			:= 0				//Number		N�o	Media diaria da Preventiva EQM	N�o Enviar
	::NUMR_MAXIMO_PREV			:= 0				//Number		N�o	Valor Maximo (Caracteristicas) Preventiva EQM	N�o Enviar
	::CODG_ODI					:= 0				//Number		N�o	C�digo Ordem curso (ODI)	Avaliar se as informa��es relacionadas com a classifica��o patrimonial do Ativo ir�o migrar do Protheus para o EQM Ou N�o Enviar
	::_SIGL_TIPO_UC				:= ""				//String	5	N�o	Sigla TUC Enviar o novo campo detalhe TUC_COD. Enviar o c�digo. N�o � a descri��o. Exemplo: 575
	::SIGL_TIPO_BEM				:= ""				//String	5	N�o	Sigla Tipo Bem
	::NUMR_ULTIMO_VALOR_PREV	:= 0				//Number		N�o	Ultimo Valor Preventiva EQM	N�o enviar
	::___CODG_EXTERNO_UF		:= ""				//String	30	N�o	Sigla Unidade Federativa	N�o enviar
	::DESC_MAT_UF				:= ""				//String	100	N�o	Descri��o unidade federativa	N�o enviar
	::__CODG_EXTERNO_MUNIC		:= ""				//String 	30	N�o	C�digo externo munic�pio	N�o enviar
	::DESC_MUNICIPIO			:= ""				//String	100	N�o	Descri��o munic�pio	N�o enviar
	::_CODG_EXTERNO_BAIRRO		:= ""				//String	30	N�o	C�digo Bairro externo	N�o enviar
	::DESC_BAIRRO				:= ""				//String	100	N�o	Descri��o bairro	N�o enviar
	::CODG_EXTERNO_LOGRA		:= ""				//String	30	N�o	C�digo externo logradouro	N�o enviar
	::DESC_LOGRADOURO			:= ""				//String	100	N�o	Descri��o logradouro	N�o enviar
	::DESC_COMPL_END			:= ""				//String	100	N�o	Complemento	N�o enviar
	::CODG_NCA					:= ""				//String	60	N�o	C�digo NCA	N�o enviar
	::GPS_X						:= 0				//Number		N�o	GPS X	N�o enviar
	::GPS_Y						:= 0				//Number		N�o	GPS Y	N�o enviar
	::GPS_Z						:= 0				//Number		N�o	GPS Z	N�o enviar
	::CODG_TIPO_INSTALACAO_PAI	:= ""				//String 	15	N�o	Codigo Tipo Instala��o (Patrimonio)	Avaliar se as informa��es relacionadas com a classifica��o patrimonial do Ativo ir�o migrar do Protheus para o EQM Ou N�o Enviar

	aEval( aAreaS, {|x| RestArea(x) } )

Return Self
