#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "MSOLE.CH"

#DEFINE cPERGUNTE_WORD "CSGPWORD"
#DEFINE cPERGUNTE_CERTIFLOW_ABH "CSGPWORDBH" //Aceite banco de horas Certiflow

#DEFINE cNOME_PROGRAMA "CSRH170"
#DEFINE OLESAVEASFILE  405
#DEFINE OLECLOSEFILE   406
#DEFINE WDFORMATPDF    "17"

#DEFINE STR0001 "Integração Com Ms-word", "Integracao com MS-Word"
#DEFINE STR0002 "Impressão de documentos no word. serão impressos de acordo com a"
#DEFINE STR0003 "Selecção Dos Parâmetros."
#DEFINE STR0004 "Impr. _variáveis"
#DEFINE STR0005 "Impr. _documento"
#DEFINE STR0006 "Modelo de documentos(*.dot) |*.dot|"
#DEFINE STR0007 "Selecionar o ficheiro *.dot"
#DEFINE STR0008 "Dot"
#DEFINE STR0009 "Arquivo Selecionado"
#DEFINE STR0010 "Ok"
#DEFINE STR0011 "Arquivo inválido "
#DEFINE STR0012 "Cancelada a Seleção! Você cancelou a seleção do registo."
#DEFINE STR0013 "Filial"
#DEFINE STR0014 "Matrícula"
#DEFINE STR0015 "Centro de Custo"
#DEFINE STR0016 "Descrição do Centro de Custo"
#DEFINE STR0017 "Nome do Funcionário"
#DEFINE STR0018 "Número do Cic/cpf"
#DEFINE STR0019 "Número do Pis"
#DEFINE STR0020 "Número do RG"
#DEFINE STR0021 "Número da CTPS"
#DEFINE STR0022 "Número de Série da CTPS"
#DEFINE STR0023 "Estado Emissor da CTPS"
#DEFINE STR0024 "Número Da Carteira Nacional De Habilitação"
#DEFINE STR0025 "Número da Carteira de Reservista"
#DEFINE STR0026 "Numero do Título de Eleitor"
#DEFINE STR0027 "Número da Zona/Seção do Tíluto de Eleitor"
#DEFINE STR0028 "Endereço"
#DEFINE STR0029 "Complemento de Endereço"
#DEFINE STR0030 "Bairro"
#DEFINE STR0031 "Municipio"
#DEFINE STR0032 "Sigla do Estado"
#DEFINE STR0033 "Descricao do Estado"
#DEFINE STR0034 "Numero do CEP"
#DEFINE STR0035 "Numero do Telefone"
#DEFINE STR0036 "Nome do Pai"
#DEFINE STR0037 "Nome da Mae"
#DEFINE STR0038 "Sexo"
#DEFINE STR0039 "Descricao do Sexo"
#DEFINE STR0040 "Estado Civil"
#DEFINE STR0041 "Codigo da Naturalidade"
#DEFINE STR0042 "Descricao da Naturalidade"
#DEFINE STR0043 "Codigo da Nacionalidade"
#DEFINE STR0044 "Descricao da Nacionalidade"
#DEFINE STR0045 "Ano de Chegada no Pais"
#DEFINE STR0046 "Numero de Dependentes de IR"
#DEFINE STR0047 "Numero de Dependentes de Salario Familia"
#DEFINE STR0048 "Data de Nascimento"
#DEFINE STR0049 "Data de Admissao"
#DEFINE STR0050 "Dia da Data de Admissao"
#DEFINE STR0051 "Mes da Data de Admissao"
#DEFINE STR0052 "Ano da Data de Admissao"
#DEFINE STR0053 "Data da Opcao do FGTS"
#DEFINE STR0054 "Data de Demissao"
#DEFINE STR0055 "Data de Experiencia"
#DEFINE STR0056 "Dia da Data de Experiencia"
#DEFINE STR0057 "Mes da Data de Experiencia"
#DEFINE STR0058 "Ano da Data de Experiencia"
#DEFINE STR0059 "Dias de Experiencia"
#DEFINE STR0060 "Data Vencimento Exame Medico"
#DEFINE STR0061 "Banco/Agencia Deposito de Salario"
#DEFINE STR0062 "Descricao do Banco de Deposito de Salario"
#DEFINE STR0063 "Descricao da Agencia de Deposito de Salario"
#DEFINE STR0064 "Numero da Conta de Deposito de Salario"
#DEFINE STR0065 "Banco/Agencia de Deposito do FGTS"
#DEFINE STR0066 "Descricao da Banco do Deposito de FGTS"
#DEFINE STR0067 "Descricao da Agencia de Deposito do FGTS"
#DEFINE STR0068 "Numero da Conta de Deposito do FGTS"
#DEFINE STR0069 "Situacao na Folha"
#DEFINE STR0070 "Descricao da Situacao na Folha"
#DEFINE STR0071 "Horas Mensais"
#DEFINE STR0072 "Horas Semanais"
#DEFINE STR0073 "Numero da Chapa"
#DEFINE STR0074 "Codigo do Turno de Trabalho"
#DEFINE STR0075 "Descricao do Turno de Trabalho"
#DEFINE STR0076 "Codigo da Funcao"
#DEFINE STR0077 "Descricao da Funcao"
#DEFINE STR0078 "Numero do CBO"
#DEFINE STR0079 "Codigo Pagamento Contribuicao Sindical"
#DEFINE STR0080 "Codigo do Sindicato"
#DEFINE STR0081 "Descricao do Sindicato"
#DEFINE STR0082 "Codigo Assistencia Medica"
#DEFINE STR0083 "Numero de Dependentes para Assistencia Medica"
#DEFINE STR0084 "Codigo do Adicional Por Tempo de Servico"
#DEFINE STR0085 "Codigo da Cesta Basica"
#DEFINE STR0086 "Codigo do Vale Refeicao"
#DEFINE STR0087 "Codigo do Seguro de Vida"
#DEFINE STR0088 "Percentual da Pensao Alimenticia"
#DEFINE STR0089 "Percentual do Adiantamento"
#DEFINE STR0090 "Categoria do Funcionario"
#DEFINE STR0091 "Descricao da Categoria do Funcionario"
#DEFINE STR0092 "Descricao do Tipo de Pagamento (Mes/Hora"
#DEFINE STR0093 "Tipo de Pagamento"
#DEFINE STR0094 "Descricao do Tipo de Pagamento"
#DEFINE STR0095 "Salario"
#DEFINE STR0096 "Salario Dissidio"
#DEFINE STR0097 "Base INSS Outras Empresas"
#DEFINE STR0098 "Inss Outras Empresas"
#DEFINE STR0099 "Horas de Periculosidade"
#DEFINE STR0100 "Horas de Insalubridade Minima"
#DEFINE STR0101 "Horas de Insalubridade Media"
#DEFINE STR0102 "Horas de Insalubridade Maxima"
#DEFINE STR0103 "Tipo de Admissao"
#DEFINE STR0104 "Descricao do Tipo de Admissao"
#DEFINE STR0105 "Codigo de Afastamento do FGTS"
#DEFINE STR0106 "Descricao do Afastamento do FGTS"
#DEFINE STR0107 "Codigo do Vinculo Empregaticio da RAIS"
#DEFINE STR0108 "Descricao do Vinculo Empregaticio da RAIS"
#DEFINE STR0109 "Codigo de Instrucao da RAIS"
#DEFINE STR0110 "Descricao do Codigo de Instrucao da RAIS"
#DEFINE STR0111 "Codigo de Rescisao da RAIS"
#DEFINE STR0112 "Numero do Cracha"
#DEFINE STR0113 "Codigo da Regra de Apontamento"
#DEFINE STR0114 "Foto do Funcionario"
#DEFINE STR0115 "Numero de Registro"
#DEFINE STR0116 "Numero da Ficha"
#DEFINE STR0117 "Codigo do Tipo de Contrato de Trabalho"
#DEFINE STR0118 "Descricao do Tipo de Contrato de Trabalho"
#DEFINE STR0119 "Apelido do Funcionario"
#DEFINE STR0120 "E-mail do Funcionario"
#DEFINE STR0121 "Texto 01 para Livre Digitacao"
#DEFINE STR0122 "Texto 02 para Livre Digitacao"
#DEFINE STR0123 "Texto 03 para Livre Digitacao"
#DEFINE STR0124 "Texto 04 para Livre Digitacao"
#DEFINE STR0125 "Extenso do Salario"
#DEFINE STR0126 "Data Base do Sistema"
#DEFINE STR0127 "Dia da Data Base do Sistema"
#DEFINE STR0128 "Mes da Data Base do Sistema"
#DEFINE STR0129 "Ano da Data Base do Sistema"
#DEFINE STR0130 "Nome da Empresa"
#DEFINE STR0131 "Endereco da Empresa"
#DEFINE STR0132 "Municipio da Empresa"
#DEFINE STR0133 "Numero do CEP da Empresa"
#DEFINE STR0134 "CGC da Empresa"
#DEFINE STR0135 "Numero da Inscricao Estadual da Empresa"
#DEFINE STR0136 "Telefone da Empresa/Fax"
#DEFINE STR0137 "Bairro da Empresa"
#DEFINE STR0138 "Descricao do Tipo de Rescisao da RAIS"
#DEFINE STR0139 "Dia da Data de Demissao"
#DEFINE STR0140 "Mes da Data de Demissao"
#DEFINE STR0141 "Ano da Data de Demissao"
#DEFINE STR0142 "Variavel"
#DEFINE STR0143 "Descricao da Variavel"
#DEFINE STR0144 "Relatorio Variaveis GPE_Word."
#DEFINE STR0145 "Será impresso de acordo com os parametros solicitados pelo"
#DEFINE STR0146 "usuario."
#DEFINE STR0147 "Zebrado"
#DEFINE STR0148 "AdministraçÃ¤o"
#DEFINE STR0149 "Variaveis                      Descricao"
#DEFINE STR0150 "Nome do Dependente"
#DEFINE STR0151 "Data de Nascimento do Dependente De Salario Familia"
#DEFINE STR0152 "Orgao Emissor Doc.Identidade"
#DEFINE STR0153 "Relacao de Dependencia "
#DEFINE STR0154 "Dependente de Imposto de Renda "
#DEFINE STR0155 "Extenso do mes de admissao "
#DEFINE STR0156 "Nome do apoderado "
#DEFINE STR0157 "Atividade da empresa "
#DEFINE STR0158 "Numero do Livro em que foi Registrado"
#DEFINE STR0159 "Numero da Folha do Livro em que foi Registrado"
#DEFINE STR0160 "Data da Entrega dos Documentos"
#DEFINE STR0161 "Data da Baixa dos Documentos"
#DEFINE STR0162 "Selecionando Registros....."
#DEFINE STR0163 "Data de Nascimento do Dependente De Imposto de Renda"
#DEFINE STR0164 "Local de Nascimento"
#DEFINE STR0165 "Numero do Registro de Nascimento"
#DEFINE STR0166 "Municipio de Nascimento"
#DEFINE STR0167 "Integração Word funciona somente com Windows !!!"
#DEFINE STR0168 "Atenção !"
#DEFINE STR0169 "Primeiro Nome"
#DEFINE STR0170 "Segundo Nome"
#DEFINE STR0171 "Primeiro Sobrenome"
#DEFINE STR0172 "Segundo Sobrenome"
#DEFINE STR0173 "Codigo do Processo"
#DEFINE STR0174 "Codigo do Local de Pagamento"
#DEFINE STR0175 "Tipo de Salario IMSS"
#DEFINE STR0176 "Tipo de Empregado IMSS"
#DEFINE STR0177 "Tipo de Jornada IMSS"
#DEFINE STR0178 "Data de Readmissao"
#DEFINE STR0179 "Data de Baixa IMSS"
#DEFINE STR0180 "Codigo do Registro Patronal"
#DEFINE STR0181 "Codigo do Departamento"
#DEFINE STR0182 "Codigo do Posto"
#DEFINE STR0183 "CURP"
#DEFINE STR0184 "Tipo de Infonavit"
#DEFINE STR0185 "Valor do Infonavit"
#DEFINE STR0186 "Nro. de Credito Infonavit"
#DEFINE STR0187 "O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
#DEFINE STR0188 "Dia Inicio Per.Aquis.Ferias"
#DEFINE STR0189 "Mes Inicio Per.Aquis.Ferias"
#DEFINE STR0190 "Ano Inicio Per.Aquis.Ferias"
#DEFINE STR0191 "Dia Fim Per.Aquis.Ferias"
#DEFINE STR0192 "Mes Fim Per.Aquis.Ferias"
#DEFINE STR0193 "Ano Fim Per.Aquis.Ferias"
#DEFINE STR0194 "Descrição do Estado Civil"
#DEFINE STR0195 "Nr. Bilhete Identidade"
#DEFINE STR0196 "Data de Emissão do Bilhete Identidade"
#DEFINE STR0197 "Descrição da primeira tarefa encontrada"
#DEFINE STR0198 "Aulas por semana da primeira tarefa"
#DEFINE STR0199 "Quantidade da primeira tarefa"
#DEFINE STR0200 "Valor unitário da primeira tarefa"
#DEFINE STR0201 "Valor total da primeira tarefa"
#DEFINE STR0202 "Descrição da segunda tarefa"
#DEFINE STR0203 "Aulas por semana da segunda tarefa"
#DEFINE STR0204 "Quantidade da segunda tarefa"
#DEFINE STR0205 "Valor unitário da segunda tarefa"
#DEFINE STR0206 "Valor total da segunda tarefa"

/*{Protheus.doc} CSRH170
Impressao de Documentos tipo Word - RDMAKE
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description Alterado em 07/11/2017 - Opvs (Bruno Nunes) Alteracao: Revisão do fonte para funcionar no P12.
			 Alterado em 18/05/2018 - Bruno Nunes:
			 	1 - Alterar os seus nome do fonte;
				2 - Alterar nome das funçÃµes;
				3 - Alterar nomes dos perguntes SX1;
				4 - Alterar nome do parâmetros SX6.
				5 - Nova chamada para gerar certiflow e documento word em pdf.
			Alterado em 01/02/2019 - Bruno Nunes:
				1 - Revisão da query para somente utilizar a excessão de ponto regra 99 quando for chamada pela rotina CSRH171
*/
user function CSRH170()
	local cCampo  	:= ""
	local oDlg		:= nil
	local oGroup1 	:= nil
	local oPanel1 	:= nil
	local oPanel2 	:= nil
	local oSay1		:= nil
	local oTButton1	:= nil
	local oTButton2	:= nil
	local oTButton3	:= nil
	local oTButton4	:= nil
	local oTFont 	:= TFont():New('Tahoma',,14,,.F.)
	local oTFontBut := TFont():New('Tahoma',,14,,.T.)
	local nTop      := 0
	local nLeft     := 0
	local nBottom   := 270
	local nRight    := 700

	private aDepenIR	:= {}
	private aDepenSF	:= {}
	private aInfo		:= {}
	private aPerSRF 	:= {}
	private cCompendEmp := ''
	private cHoraFim 	:= ''
	private cHoraIni 	:= ''
	private cNomeProces := ''
	private nDepen		:= 0
	private nHrInter    := 0

	AjustaSx1( cPERGUNTE_WORD )
	pergunte( cPERGUNTE_WORD, .F. )

	openProfile()

	//Avalia o conteudo ja existente no profile e o altera se necessario
	//para que o erro nao ocorra apos a atualizacao do sistema.
	if ( ProfAlias->( DbSeek( SM0->M0_CODIGO + Padl( cUserName , 13 ) + cPERGUNTE_WORD ) ) )
		cCompendEmp := SM0->M0_COMPCOB
		cCampo 		:= SubStr( AllTrim( ProfAlias->P_DEFS ), 487, 75 )
		if !( ".Dot" $ UPPER( cCampo ) )
			RecLock( "ProfAlias", .F. )
			ProfAlias->P_DEFS := ""
			ProfAlias->( MsUnLock() )
		endif
	endif

	//Tela Principal
	oDlg := TDialog():New( nTop        , ;//01
						   nLeft       , ;//02
						   nBottom     , ;//03
						   nRight      , ;//04
						   STR0001)
	
	//Painel dos textos
	oPanel1 		:= tPanel():New(01,01,"",oDlg,,.T.,,,,100,100) //Instancio novo painel
	oGroup1			:= TGroup():New(10,02,130,130,'Importante',oPanel1,,,.T.) //Instancio novo grupo
	oSay1			:= TSay():New(12,12,{||OemToAnsi(STR0002)+' '+OemToAnsi(STR0003)},oGroup1,,oTFont,,,,.T.,,,/*200*/,/*20*/)

	oPanel1:Align 	:= CONTROL_ALIGN_ALLCLIENT 	//Alinhamento em tela inteira
	oGroup1:Align 	:= CONTROL_ALIGN_ALLCLIENT 	//Alinhamento em tela inteira
	oSay1:Align 	:= CONTROL_ALIGN_TOP 		//Alinhamento com topo do grupo

	//Painel dos botoes
  	oPanel2 		:= tPanel():New(01,01,"",oDlg,,.T.,,,,20,20)
  	oTButton1 		:= TButton():New( 002, 002, "Parâmetros"		, oPanel2, { || pergunte(cPERGUNTE_WORD,.T.)}, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton2 		:= TButton():New( 002, 002, "Imp. Variáveis"	, oPanel2, { || nDepen := 0, fImpVar()  	}, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton3 		:= TButton():New( 002, 002, "Gerar Word"		, oPanel2, { || iniWord() 					}, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )
  	oTButton4 		:= TButton():New( 002, 002, "Fechar"			, oPanel2, { || Close(oDlg) 				}, 70,10,,oTFontBut,.F.,.T.,.F.,,.F.,,,.F. )

	oPanel2:Align 	:= CONTROL_ALIGN_BOTTOM
	oTButton1:Align := CONTROL_ALIGN_LEFT
	oTButton2:Align := CONTROL_ALIGN_LEFT
	oTButton3:Align := CONTROL_ALIGN_LEFT
	oTButton4:Align := CONTROL_ALIGN_RIGHT

	oDlg:Activate(,,,.T. )
return( NIL )

/*{Protheus.doc} CSRH171
Geração de arquivo pdf com documento do aceite do banco de horas e integração com o Certiflow.
@type function
@author BrunoNunes
@since 21/05/2018
@version P12 1.12.17
@return null, Nulo
*/
User Function CSRH171()
	local aLista 	:= {}
	local lImpress 	:= .F.
	local lPdf 		:= .T.
	local lCrtFlow	:= .T.

	local cFilMatDe  := ""
	local cFilMatAte := ""
	local cCCDe 	 := ""
	local cCCAte 	 := ""
	local cMatDe	 := ""
	local cMatAte	 := ""
	local cSituac 	 := ""
	local cArqOri 	 := ""
	local cArqDes 	 := ""

	private aDepenIR	:= {}
	private aDepenSF	:= {}
	private aInfo		:= {}
	private aPerSRF 	:= {}
	private cCompendEmp := ''
	private cHoraFim 	:= ''
	private cHoraIni 	:= ''
	private cNomeProces := ''
	private nDepen		:= 0
	private nHrInter    := 0

	AjustaSx1( cPERGUNTE_CERTIFLOW_ABH )
	if pergunte( cPERGUNTE_CERTIFLOW_ABH, .T. )
		cFilMatDe 	:= MV_PAR01
		cFilMatAte  := MV_PAR02
		cCCDe 		:= MV_PAR03
		cCCAte 		:= MV_PAR04
		cMatDe		:= MV_PAR05
		cMatAte		:= MV_PAR06
		cSituac 	:= MV_PAR07
		cArqOri 	:= MV_PAR08
		cArqDes 	:= MV_PAR09

		MV_PAR01 :=	cFilMatDe
		MV_PAR02 :=	cFilMatAte
		MV_PAR03 :=	cCCDe
		MV_PAR04 :=	cCCAte
		MV_PAR05 :=	cMatDe
		MV_PAR06 :=	cMatAte
		MV_PAR07 :=	""
		MV_PAR08 :=	replicate('Z',30)
		MV_PAR09 :=	""
		MV_PAR10 :=	replicate('Z',03)
		MV_PAR11 :=	""
		MV_PAR12 :=	replicate('Z',03)
		MV_PAR13 :=	""
		MV_PAR14 :=	replicate('Z',03)
		MV_PAR15 := ctod('01/01/90')
		MV_PAR16 :=	ctod('31/12/20')
		MV_PAR17 :=	cSituac
		MV_PAR18 :=	"ACDEGHIJMP"
		MV_PAR19 := ""
		MV_PAR20 :=	""
		MV_PAR21 :=	""
		MV_PAR22 :=	""
		MV_PAR23 :=	1
		MV_PAR24 :=	1
		MV_PAR25 :=	cArqOri
		MV_PAR26 :=	2
		MV_PAR27 :=	3
		MV_PAR28 :=	2
		MV_PAR29 :=	cArqDes
		MV_PAR30 :=	""

		processa( {|| aLista := procWord( lImpress, lPdf, lCrtFlow ) }, "Aceite Banco de horas", "Gerando arquivo(s) Pdf...",.F.)
		if !empty( aLista )
			U_CSRH180( aLista ) //Executa envio do Certiflow com base nos pdf gerados anteriormentes.
		endif
	endif

Return

/*{Protheus.doc} iniWord
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
*/
static function iniWord()
	local lImpress	:= ( MV_PAR28 == 1 ) //Determina se é impressão ou é arquivo
	local lPdf 		:= .F.

	if	lImpress
		//Se for impressão chama a rotina sem tela de processamento e com o word aberto.
		procWord( lImpress, lPdf )
	else
		//Se for arquivo chama a rotina com tela de processamento e com o word fechado.
		processa( {|| procWord( lImpress, lPdf ) }, "Aguarde...", "Gerando arquivo(s) Word...",.F.)
	endif
Return Nil

/*{Protheus.doc} procWord
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
*/
static function procWord( lImpress, lPdf, lCrtFlow )
	local aCampos		:= {}
	local cAcessaSRA	:= &( " { || " + ChkRH( cNOME_PROGRAMA , "SRA" , "2" ) + " } " )
	local cArqAux		:= ""
	local cArqSaida 	:= AllTrim( MV_PAR29 )
	local cArqWord		:= MV_PAR25
	local cAux			:= ""
	local cCategoria	:= MV_PAR18
	local cCcAte		:= If(!Empty(MV_PAR04),MV_PAR04,Replicate('Z',TamSX3("RA_CC")[1]))
	local cCcDe			:= If(!Empty(MV_PAR03),MV_PAR03,Replicate(' ',TamSX3("RA_CC")[1]))
	local cFilAte		:= If(!Empty(MV_PAR02),MV_PAR02,Replicate('Z',TamSX3("RA_FILIAL")[1]))
	local cFilDe 		:= If(!Empty(MV_PAR01),MV_PAR01,Replicate(' ',TamSX3("RA_FILIAL")[1]))
	local cFunAte		:= If(!Empty(MV_PAR12),MV_PAR12,Replicate('Z',TamSX3("RA_CODFUNC")[1]))
	local cFunDe		:= If(!Empty(MV_PAR11),MV_PAR11,Replicate(' ',TamSX3("RA_CODFUNC")[1]))
	local cListaArq		:= ""
	local cMatAte		:= If(!Empty(MV_PAR06),MV_PAR06,Replicate('Z',TamSX3("RA_MAT")[1]))
	local cMatDe		:= If(!Empty(MV_PAR05),MV_PAR05,Replicate(' ',TamSX3("RA_MAT")[1]))
	local cNomeAte		:= If(!Empty(MV_PAR08),MV_PAR08,Replicate('Z',TamSX3("RA_NOME")[1]))
	local cNomeDe		:= If(!Empty(MV_PAR07),MV_PAR07,Replicate(' ',TamSX3("RA_NOME")[1]))
	local cPath 		:= GETTEMPPATH()
	local cSindAte		:= If(!Empty(MV_PAR14),MV_PAR14,Replicate('Z',TamSX3("RA_SINDICA")[1]))
	local cSindDe		:= If(!Empty(MV_PAR13),MV_PAR13,Replicate(' ',TamSX3("RA_SINDICA")[1]))
	local cSituacao		:= MV_PAR17
	local cTnoAte		:= If(!Empty(MV_PAR10),MV_PAR10,Replicate('Z',TamSX3("RA_TNOTRAB")[1]))
	local cTnoDe		:= If(!Empty(MV_PAR09),MV_PAR09,Replicate(' ',TamSX3("RA_TNOTRAB")[1]))
	local dAdmiAte		:= MV_PAR16
	local dAdmiDe		:= MV_PAR15
	local lDepende		:= if (MV_PAR26 = 1, .T., .F.)
	local nAt			:= 0
	local nCopias		:= if ( Empty(MV_PAR23),1,MV_PAR23 )
	local nDepende  	:= MV_PAR27
	local nOrdem		:= MV_PAR24
	local nSvOrdem		:= 0
	local nSvRecno		:= 0
	local nX			:= 0
	local oWord			:= NIL
	local aLista	 	:= {}
	local calias		:= getNextAlias()
	local nRec			:= 0
	local cQuery		:= ''
	local lExeChange    := .T.
	local cFilialAnt	:= ''

	default lImpress := .F.
	default lPdf 	 := .F.
	default lCrtFlow := .F.

	nDepen	:= if ( ! lDepende, 4,nDepende )

	//Validação de parametros
	if !validSX1(cArqWord, cArqSaida)
		return
	endif

	//Verifica se o usuario escolheu um drive local (A: C: D:) caso contrario
	//busca o nome do arquivo de modelo,  copia para o diretorio temporario
	//do windows e ajusta o caminho completo do arquivo a ser impresso.
	if substr(cArqWord,2,1) <> ":"
		cAux := cArqWord
		nAt	 := 1
		for nx := 1 to len(cArqWord)
			cAux := substr( cAux, if( nx==1, nAt, nAt+1 ),len(cAux))
			nAt  := at("\",cAux)
			if nAt == 0
				Exit
			endif
		next nx
		CpyS2T(cArqWord,cPath, .T.)
		cArqWord	:= cPath+cAux
	endif

	//Monta query SQL com base nos parametros SX1
	cQuery := QuerySRA(nOrdem, cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCCAte, cNomeDe, cNomeAte, cTnoDe, cTnoAte, cFunDe, cFunAte, cSindDe, cSindAte, dAdmiDe, dAdmiAte, cSituacao, cCategoria, lCrtFlow)

	//Ira Executar Enquanto Estiver dentro do Escopo dos Parametros
	if U_MontarSQL( calias, @nRec, cQuery, lExeChange )
		//Inicializa o Ole com o MS-Word 97 ( 8.0 )
		oWord	:= OLE_CreateLink()

		//Se for arquivo, atualiza o procRegua para barra infinita e deixa o word invisivel para o usuário.
		if !lImpress
			procRegua(0)
			OLE_SetProperty( oWord, oleWdVisible,   .F. )       // seto a propriedade de visibilidade do word
		endif

		SRA->(dbSetOrder(1))
		while (calias)->( !Eof() )
			if !( SRA->( dbSeek( (calias)->(RA_FILIAL+RA_MAT) ) ) )
				(calias)->(dbSkip())
				loop
			endif

			//Cria novo arquivo no word
			OLE_NewFile( oWord , cArqWord )

			//Se for arquivo, atualiza a barra de processamento.
			if !lImpress
				incProc()
			endif

			//Consiste Filiais e Acessos
			if !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		    	(calias)->(dbSkip())
		   		Loop
			endif

			//Consiste os dependentes  de Salario Familia
			if lDepende
				if nDepende == 1 //Salario Familia //
					//Consiste os dependentes  de Salario Familia
					if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
				   		fDepSF( )
					else
						(calias)->(dbSkip())
						Loop
					endif
				elseif nDepende == 2 //Imposto de Renda	//
					//Consiste os dependentes  de Imposto de Renda
		   			if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
			    		fDepIR( )
			    	else
						(calias)->(dbSkip())
						Loop
					endif
				elseif nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
					//Consiste todos os tipos de Dependentes
		   			if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
			       		fDepIR( )
			       	else
						(calias)->(dbSkip())
						Loop
					endif
					if SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
			    		fDepSF( )
			    	else
						(calias)->(dbSkip())
						Loop
					endif
				endif

				if (nDepende == 1)
					if  empty(aDepenSF[1,1])
						(calias)->(dbSkip())
						Loop
					endif
				elseif	(nDepende == 2)
					if  empty(aDepenIR[1,1])
						(calias)->(dbSkip())
						Loop
					endif
				elseif	(nDepende == 3)
					if  empty(aDepenIR[1,1])  .and. empty(aDepenSF[1,1])
						(calias)->(dbSkip())
						Loop
					endif
				endif
			endif

			fPesqSRF()//Busca Periodo Aquisitivo

			//Carregando Informacoes da Empresa
			if SRA->RA_FILIAL # cFilialAnt
				if !fInfo(@aInfo,SRA->RA_FILIAL)
					//Encerra o Loop se Nao Carregar Informacoes da Empresa
					Exit
				endif

				//Atualiza a Variavel cFilialAnt
				dbSelectArea("SRA")
				cFilialAnt := SRA->RA_FILIAL
			endif

			//Posicionar RCJ - Cadastro de Processo          RA_PROCES
			RCJ->(dbSetOrder(1))
			if RCJ->(dbSeek(xFilial('RCJ')+SRA->RA_PROCES))
				cNomeProces := RCJ->RCJ_DESCRI
			else
				cNomeProces := ''
			endif

			//Leitura de turno trabalho
			TurnoTrab()

			//Carrega Campos Disponiveis para Edicao
			aCampos := fCpos_Word()

			//Ajustando as Variaveis do Documento
			Aeval(	aCampos,;
						{ |x| OLE_SetDocumentVar( oWord, x[1] ,;
														if( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->" ,;
															Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 ),;
																		Subst( AllTrim( x[3] ), - ( Len( AllTrim( x[3] ) ) - 5 ) ) ) ),;
															Transform( x[2] , x[3] );
						  								);
													);
						};
					 )

			//Atualiza as Variaveis
		    OLE_UpDateFields( oWord )

			//Imprimindo o Documento
			if lImpress
				cArqAux := SRA->RA_MAT+' - '+SRA->RA_NOME
				for nX := 1 To nCopias
					OLE_SetProperty( oWord, '208', .F. )
					OLE_PrintFile( oWord )
				next nX
			else
				cArqAux := cArqSaida+NomeArq( cArqWord )
				//Se for pdf, troca a extensão do arquivo e formato na impressão.
				if lPDF
					cArqAux := replace( cArqAux, '.docx', '.pdf' )
					execInClient( OLESAVEASFILE, { oWord, cArqAux, "", "", "0", WDFORMATPDF } )
				else
					OLE_SaveAsFile( oWord, cArqAux )
				endif
			endif
			cListaArq += cArqAux + CRLF

			//Monta lista de funcionário processados para ser usado fora dessa rotina.
			aAdd( aLista, { SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_EMAIL, cArqAux } )

			(calias)->(dbSkip())
			//Iniciliaza array
			aDepenIR:= {}
			aDepenSF:= {}
			aPerSRF := {}

			//Encerrando o Link com o Documento
			fecharWord(oWord, cArqWord, cAux, .F.) //Fecha somente o documento
		enddo

		//acontece de sair do loop com arquivo aberto
		fecharWord(oWord, cArqWord, cAux, .T.) //Fecha a comunicação com o word.

		if lImpress
			Aviso( 'Documento Word' , 'Arquivo(s) enviados para impressão:'+CRLF+cListaArq	, { 'Ok' }, 3 )
		else
			if !IsInCallStack( 'U_CSRH171' )
				Aviso( 'Documento Word' , 'Arquivo(s) criado(s):'+CRLF+cListaArq			, { 'Ok' }, 3 )
			endif
		endif
	else
		Aviso( 'Documento Word' , 'Não foi encontrado colaboradore(s) com essa parametrização', { 'Ok' }, 3 )
	endif

	//Restaurando dados de Entrada
	dbSelectArea('SRA')
	dbSetOrder( nSvOrdem )
	dbGoTo( nSvRecno )
return( aLista )

/*{Protheus.doc} CSRH170f
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.

Alterado em.: 18/04/2018 - CERTISIGN (Alexandre Alves)
OTRS........: 2018041710004674
Alteracao...: Adequação do nome da user Funciton abaixo, passando de fOpenWrd para o padrão fOpWord.
              Ocorre que a cada atualização de sistema onde o dicionario (SX1) sofre intervenção da TOTVS,
              o pergunte relaciona faz chamada Ã  função fOpWord.
*/
user function CSRH170f() //fOpenWrd
	local cNewPathArq	:= cGetFile( STR0006 , STR0007, 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ),.T., .T. )
	local cSvAlias		:= Alias()

	if !Empty( cNewPathArq )
		if Len( cNewPathArq ) > 75
	    	MsgAlert( STR0187 ) //"O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
	    	return
		else
			if Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( STR0008 ) )
				Aviso( STR0009 , cNewPathArq , { STR0010 } )
		    else
		    	MsgAlert( STR0011 )
		    	return
		    endif
		endif
	else
	    Aviso(STR0012 ,STR0007,{ STR0010 } )//Aviso(STR0012 ,{ STR0010 } )
	    return
	endif

	MV_PAR25 := cNewPathArq

	dbSelectArea( cSvAlias )
return(.T.)

/*{Protheus.doc} CSRH171f
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
user function CSRH171f() //fOpenWrd
	local cNewPathArq	:= cGetFile( "Todos *.*" , "Selecione um diretÃ³rio", 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.T., .T. )
	local cSvAlias		:= Alias()

	if !Empty( cNewPathArq )
		if !ExistDir( cNewPathArq )
	    	MsgAlert( "DiretÃ³rio não existe." )
	    	return
		endif
	else
		if !empty( MV_PAR29 )
			if !ExistDir( MV_PAR29 )
		    	MsgAlert( "DiretÃ³rio não existe." )
		    	MV_PAR29 := ""
		    	return
		    else
		    	cNewPathArq := MV_PAR29
			endif
	    else
	    	Aviso(STR0012 ,"Selecionao um diretÃ³rio válido.",{ STR0010 } )
	    	return
	    endif
	endif

	MV_PAR29 := cNewPathArq

	dbSelectArea( cSvAlias )
return(.T.)

/*{Protheus.doc} CSRH172f
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.

Alterado em.: 18/04/2018 - CERTISIGN (Alexandre Alves)
OTRS........: 2018041710004674
Alteracao...: Adequação do nome da user Funciton abaixo, passando de fOpenWrd para o padrão fOpWord.
              Ocorre que a cada atualização de sistema onde o dicionario (SX1) sofre intervenção da TOTVS,
              o pergunte relaciona faz chamada Ã  função fOpWord.
*/
user function CSRH172f() //fOpenWrd
	local cNewPathArq	:= cGetFile( STR0006 , STR0007, 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ),.T., .T. )
	local cSvAlias		:= Alias()

	if !Empty( cNewPathArq )
		if Len( cNewPathArq ) > 75
	    	MsgAlert( STR0187 ) //"O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
	    	return
		else
			if Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( STR0008 ) )
				Aviso( STR0009 , cNewPathArq , { STR0010 } )
		    else
		    	MsgAlert( STR0011 )
		    	return
		    endif
		endif
	else
	    Aviso(STR0012 ,STR0007,{ STR0010 } )//Aviso(STR0012 ,{ STR0010 } )
	    return
	endif

	MV_PAR08 := cNewPathArq

	dbSelectArea( cSvAlias )
return(.T.)

/*{Protheus.doc} CSRH173f
Processa documento word
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
Alterado em 07/11/2017 - Opvs (Bruno Nunes)
Alteracao: Revisão do fonte para funcionar no P12.
*/
user function CSRH173f() //fOpenWrd
	local cNewPathArq	:= cGetFile( "Todos *.*" , "Selecione um diretÃ³rio", 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.T., .T. )
	local cSvAlias		:= Alias()

	if !Empty( cNewPathArq )
		if !ExistDir( cNewPathArq )
	    	MsgAlert( "DiretÃ³rio não existe." )
	    	return
		endif
	else
		if !empty( MV_PAR09 )
			if !ExistDir( MV_PAR09 )
		    	MsgAlert( "DiretÃ³rio não existe." )
		    	MV_PAR29 := ""
		    	return
		    else
		    	cNewPathArq := MV_PAR09
			endif
	    else
	    	Aviso(STR0012 ,"Selecionao um diretÃ³rio válido.",{ STR0010 } )
	    	return
	    endif
	endif

	MV_PAR09 := cNewPathArq

	dbSelectArea( cSvAlias )
return(.T.)

/*{Protheus.doc} fImpVar
Imprime variaveis de integração. Impressao das Variaveis disponiveis para uso
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function fImpVar()
	local aOrd		:= {STR0142,STR0143}
	local cString	:= 'SRA'
	local cDesc1	:= STR0144
	local cDesc2	:= STR0145
	local cDesc3	:= STR0146

	private AT_PRG		:= cNOME_PROGRAMA
	private areturn		:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
	private ContFl		:= 1
	private cBtxt		:= ""
	private nomeProg	:= cNOME_PROGRAMA
	private nLastKey	:= 0
	private nTamanho	:= "P"
	private lend		:= .F.
	private Li			:= 0
	private Titulo		:= cDesc1
	private wCabec0		:= 1
	private wCabec1		:= STR0149
	private wCabec2		:= ""
	private wCabec3		:= ""

	//Envia controle para a funcao SETPRINT
	WnRel := "WORD_VAR_CERTISIGN"
	WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)

	if nLastKey == 27
		return( NIL )
	endif

	SetDefault(areturn,cString)

	if nLastKey == 27
		return( NIL )
	endif

	//Chamada do Relatorio.
	RptStatus( { |lend| procImpVar() } , Titulo )
return( NIL )

/*{Protheus.doc} procImpVar
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function procImpVar()
	local nOrdem	:= areturn[8]
	local aCampos	:= {}
	local nX		:= 0
	local cDetalhe	:= ""

	//Carregando Informacoes da Empresa
	if !fInfo(@aInfo,xFilial("SRA"))
		return( NIL )
	endif

	//Carregando Variaveis
	aCampos := fCpos_Word()

	//Ordena aCampos de Acordo com a Ordem Selecionada
	if nOrdem = 1
		aSort( aCampos , , , { |x,y| x[1] < y[1] } )
	else
		aSort( aCampos , , , { |x,y| x[4] < y[4] } )
	endif

	//Carrega Regua de Processamento
	SetRegua( Len( aCampos ) )

	//Impressao do Relatorio
	for nX := 1 To Len( aCampos )
		//Movimenta Regua Processamento
		IncRegua()

		//Cancela Impressao
	    if lend
	    	@ Prow()+1,0 PSAY cCancel
			Exit
		endif

		//Mascara do Relatorio
	  	//|        10        20        30        40        50        60        70        80
	  	//|12345678901234567890123456789012345678901234567890123456789012345678901234567890
		//|Variaveis                      Descricao
		//|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

		//Carregando Variavel de Impressao
		cDetalhe := if( Len( AllTrim( aCampos[nX,1] ) ) < 30 , AllTrim( aCampos[nX,1] ) + ( Space( 30 - Len( AllTrim ( aCampos[nX,1] ) ) ) ) , aCampos[nX,1] )
		cDetalhe := cDetalhe + AllTrim( aCampos[nX,4] )

		//Imprimindo Relatorio
	    Impr( cDetalhe )
	next nX

	if areturn[5] == 1
		Set Printer To
		dbCommit()
		OurSpool(WnRel)
	endif

	//Apaga indices temporarios
	if nOrdem == 5
		fErase( cArqNtx + OrdBagExt() )
	endif

	MS_FLUSH()
return( NIL )

/*{Protheus.doc} fDepIR
Carrega Dependentes de Imp. de Renda
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function fDepIR( )
	local Nx 	 := 0
	local nVezes := 0

	//Consiste os dependentes  de I.R.
	aDepenIR:= {}
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		if	(SRB->RB_TipIr == '1') .Or.;
         	(SRB->RB_TipIr == '2' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 21) .Or. ;
       	(SRB->RB_TipIr == '3' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 24)
			//Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,if(SRB->RB_GrauPar=='C','Conjuge   ',if(SRB->RB_GrauPar=='F','Filho     ','Outros    '))   })
       endif
      	SRB->(dbSkip())
	enddo
	if Len(aDepenIR) < 10
		nVezes := (10 - Len(aDepenIR))
		for Nx := 1 to nVezes
			aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		next Nx
	endif
return(aDepenIR)

/*{Protheus.doc} fDepSF
Carrega Dependentes de Salario Familia
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function  fDepSF()
	local Nx 	 := 0
	local nVezes := 0

	//Consiste os dependentes  de I.R.
	aDepenSF:= {}
   	do while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		if (SRB->RB_TipSf == '1') .Or. (SRB->RB_TipSf == '2' .And. ;
			Year(dDataBase) - Year(SRB->RB_DtNasc) <= 14)
			//Nome do Depend., Dta Nascimento,Grau Parent.,local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      		aAdd(aDepenSF,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,if(SRB->RB_GrauPar=='C','Conjuge   ',if(SRB->RB_GrauPar=='F','Filho     ','Outros    ')),;
      						SRB->RB_LOCNASC,SRB->RB_CARTORI,SRB->RB_NREGCAR,SRB->RB_NUMLIVR,SRB->RB_NUMFOLH,SRB->RB_DTENTRA,SRB->RB_DTBAIXA})
		endif
		SRB->(dbSkip())
	enddo
   	if  Len(aDepenSF) < 10
      	nVezes := (10 - Len(aDepenSF))
		for Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		next Nx
	endif
return(aDepenSF)

/*{Protheus.doc} fPesqSRF
Carrega Periodo Aquisitivo SRF
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function  fPesqSRF()
	//local cAliasSRF := "SRF"
	/* Rotina de Busca Periodo Aquisitivo SRF */

	aPerSRF := {}

	/*
	dbSelectArea(cAliasSRF)

	dbSetOrder(RETORDER(cAliasSRF,"RF_FILIAL+RF_MAT+DTOS(RF_DATABAS") )

	if dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)

		while !Eof() .And. SRF->RF_MAT == SRA->RA_MAT         // TRAVEI AKI

			DFIMPAQUI := fCalcFimAq((cAliasSRF)->RF_DATABAS) 	// Monta a data Final do Periodo Aquisitivo
			DPRPAQUI  := fCalcFimAq(DFIMPAQUI+1) 				// Monta a data Limite Maxima
			//cPerAquis	:= DtoC((cAliasSRF)->RF_DATABAS)+Space(2)+DtoC(DFIMPAQUI) 	//-- Periodo aquisitivo
			//cLimideal	:= DtoC(DFIMPAQUI + 30)  					//-- Data limite Ideal
			//cLimMax		:= DtoC(DPRPAQUI - 45 )  					//-- Data Limite Maximo

			aAdd(aPerSRF,{SRF->RF_DATABAS,DFIMPAQUI,DPRPAQUI } )
			SRF->(dbSkip())
		enddo

	endif
	*/
return(aPerSRF)

/*{Protheus.doc} fCpos_Word
Carrega Periodo Aquisitivo SRF
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Desc: Retorna Array com as Variaveis Disponiveis para Impressao
		aExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)
		aExp[x,2] - Conteudo do Campo                (Tam Max. 49)
		aExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture
		aExp[x,4] - Descricao da Variaval
*/
static function fCpos_Word()
	local aExp			:= {}
	local cTexto_01	:= AllTrim( MV_PAR19 )
	local cTexto_02	:= AllTrim( MV_PAR20 )
	local cTexto_03	:= AllTrim( MV_PAR21 )
	local cTexto_04	:= AllTrim( MV_PAR22 )
	local cApoderado	:= ""
	local cRamoAtiv	:= ""

	if cPaisLoc == "ARG"
		if fPHist82(xFilial(),"99","01")
			cApoderado := SubStr(SRX->RX_TXT,1,30)
		endif
		if fPHist82(xFilial(),"99","02")
			cRamoAtiv := SubStr(SRX->RX_TXT,1,50)
		endif
	endif

	aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  				, "SRA->RA_FILIAL"			,STR0013	} )
	aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT															, "SRA->RA_MAT"				,STR0014	} )
	aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC															, "SRA->RA_CC"				,STR0015	} )
	aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 							, "@!"						,STR0016	} )
	aAdd( aExp, {'GPE_NOME'		   			,	SRA->RA_NOME														, "SRA->RA_NOME"			,STR0017	} )
	aAdd( aExp, {'GPE_NOMECMP'           	,   if(SRA->(FieldPos("RA_NOMECMP")) # 0, SRA->RA_NOMECMP, space(40))	, "@!"           			,STR0017 	} )
	aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC															, "SRA->RA_CIC"				,STR0018	} )
	aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS															, "SRA->RA_PIS"				,STR0019	} )
	aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG															, "SRA->RA_RG"				,STR0020	} )
	aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG														, "@!"						,STR0152	} )
	aAdd( aExp, {'GPE_CTPS'					,	SRA->RA_NUMCP							 							, "SRA->RA_NUMCP"			,STR0021	} )
	aAdd( aExp, {'GPE_SERIE_CTPS'			,	SRA->RA_SERCP							 							, "SRA->RA_SERCP"			,STR0022	} )
	aAdd( aExp, {'GPE_UF_CTPS'				,	SRA->RA_UFCP							 							, "SRA->RA_UFCP"			,STR0023	} )
	aAdd( aExp, {'GPE_CNH'   	  			,	SRA->RA_HABILIT							 							, "SRA->RA_HABILIT"			,STR0024	} )
	aAdd( aExp, {'GPE_RESERVISTA'			,	SRA->RA_RESERVI							 							, "SRA->RA_RESERVI"			,STR0025	} )
	aAdd( aExp, {'GPE_TIT_ELEITOR' 			,	SRA->RA_TITULOE							 							, "SRA->RA_TITULOE"			,STR0026	} )
	aAdd( aExp, {'GPE_ZONA_SECAO'  			,	SRA->RA_ZONASEC							 							, "SRA->RA_ZONASEC"			,STR0027	} )
	aAdd( aExp, {'GPE_endERECO'				,	SRA->RA_endEREC							 							, "SRA->RA_endEREC"			,STR0028	} )
	aAdd( aExp, {'GPE_COMP_endER'			,	SRA->RA_COMPLEM							 							, "SRA->RA_COMPLEM"			,STR0029	} )
	aAdd( aExp, {'GPE_BAIRRO'				,	SRA->RA_BAIRRO							 							, "SRA->RA_BAIRRO"			,STR0030	} )
	aAdd( aExp, {'GPE_MUNICIPIO'			,	SRA->RA_MUNICIP							 							, "SRA->RA_MUNICIP"			,STR0031	} )
	aAdd( aExp, {'GPE_ESTADO'				,	SRA->RA_ESTADO														, "SRA->RA_ESTADO"			,STR0032	} )
	aAdd( aExp, {'GPE_DESC_ESTADO'			,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")						, "@!"						,STR0033	} )
	aAdd( aExp, {'GPE_CEP'		   			,	SRA->RA_CEP															, "SRA->RA_CEP"				,STR0034	} )
	aAdd( aExp, {'GPE_TELEFONE'	   			,	SRA->RA_TELEFON														, "SRA->RA_TELEFON"			,STR0035	} )
	aAdd( aExp, {'GPE_NOME_PAI'	   			,	SRA->RA_PAI															, "SRA->RA_PAI"				,STR0036	} )
	aAdd( aExp, {'GPE_NOME_MAE'	   			,	SRA->RA_MAE															, "SRA->RA_MAE"				,STR0037	} )
	aAdd( aExp, {'GPE_COD_SEXO'	   			,	SRA->RA_SEXO														, "SRA->RA_SEXO"			,STR0038	} )
	aAdd( aExp, {'GPE_DESC_SEXO'   			,	SRA->(if(RA_SEXO ="M","Masculino","Feminino"))						, "@!"						,STR0039	} )
	if cPaisLoc <> "ARG"
		aAdd( aExp, {'GPE_EST_CIVIL'  		,	SRA->RA_ESTCIVI														, "SRA->RA_ESTCIVI"			,STR0040	} )
	else
		aAdd( aExp, {'GPE_EST_CIVIL'  		,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")						, "SRA->RA_ESTCIVI"			,STR0040	} )
	endif
	aAdd( aExp, {'GPE_COD_NATURALIDADE'		,	if(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    				, "SRA->RA_NATURAL"			,STR0041	} )
	aAdd( aExp, {'GPE_DESC_NATURALIDADE'	,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")						, "@!"						,STR0042	} )
	aAdd( aExp, {'GPE_COD_NACIONALIDADE'	,	SRA->RA_NACIONA														, "SRA->RA_NACIONA"			,STR0043	} )
	aAdd( aExp, {'GPE_DESC_NACIONALIDADE'	,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")						, "@!"						,STR0044	} )
	aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG														, "SRA->RA_ANOCHEG"			,STR0045	} )
	aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 				, "SRA->RA_DEPIR"			,STR0046	} )
	aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF														, "SRA->RA_DEPSF"			,STR0047 	} )
	aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC														, "SRA->RA_NASC"			,STR0048	} )
	aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA														, "SRA->RA_ADMISSA"			,STR0049	} )
	aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )								, "@!"						,STR0050	} )
	aAdd( aExp, {'GPE_MES_ADMISSAO'			,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )								, "@!"						,STR0051 	} )
	aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )								, "@!"						,STR0052	} )
	aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO														, "SRA->RA_OPCAO"			,STR0053	} )
	aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA														, "SRA->RA_DEMISSA"			,STR0054	} )
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP														, "SRA->RA_VCTOEXP"			,STR0055	} )
	aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )								, "@!"						,STR0056	} )
	aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )								, "@!"						,STR0057	} )
	aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 								, "@!"						,STR0058	} )
	aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)							, "@!"						,STR0059	} )
	aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI														, "SRA->RA_EXAMEDI"			,STR0060	} )
	aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'		, 	SRA->RA_BCDEPSA														, "SRA->RA_BCDEPSA"			,STR0061	} )
	aAdd( aExp, {'GPE_DESC_BCO_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")								, "@!"						,STR0062	} )
	aAdd( aExp, {'GPE_DESC_AGE_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")							, "@!"						,STR0063	} )
	aAdd( aExp, {'GPE_CTA_DEP_SAL'			,	SRA->RA_CTDEPSA														, "SRA->RA_CTDEPSA"			,STR0064	} )
	aAdd( aExp, {'GPE_BCO_AG_FGTS'			,	SRA->RA_BCDPFGT														, "SRA->RA_BCDPFGT"			,STR0065	} )
	aAdd( aExp, {'GPE_DESC_BCO_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")								, "@!"						,STR0066	} )
	aAdd( aExp, {'GPE_DESC_AGE_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")							, "@!"						,STR0067	} )
	aAdd( aExp, {'GPE_CTA_Dep_FGTS'			,	SRA->RA_CTDPFGT														, "SRA->RA_CTDPFGT"			,STR0068	} )
	aAdd( aExp, {'GPE_SIT_FOLHA'	  		,	SRA->RA_SITFOLH														, "SRA->RA_SITFOLH"			,STR0069	} )
	aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  		,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")						, "@!"						,STR0070	} )
	aAdd( aExp, {'GPE_HRS_MENSAIS'			,	SRA->RA_HRSMES														, "SRA->RA_HRSMES"			,STR0071	} )
	aAdd( aExp, {'GPE_HRS_SEMANAIS'			,	SRA->RA_HRSEMAN														, "SRA->RA_HRSEMAN"			,STR0072	} )
	aAdd( aExp, {'GPE_CHAPA'		  		,	SRA->RA_CHAPA														, "SRA->RA_CHAPA"			,STR0073	} )
	aAdd( aExp, {'GPE_TURNO_TRAB'	 		,	SRA->RA_TNOTRAB														, "SRA->RA_TNOTRAB"			,STR0074	} )
	aAdd( aExp, {'GPE_DESC_TURNO'	  		,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC')								, "@!"						,STR0075	} )
	aAdd( aExp, {'GPE_COD_FUNCAO'	 		,	SRA->RA_CODFUNC														, "SRA->RA_CODFUNC"			,STR0076 	} )
	aAdd( aExp, {'GPE_DESC_FUNCAO'			,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC')								, "@!"						,STR0077	} )
	aAdd( aExp, {'GPE_CBO'			   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)					, "@!"				       	,STR0078	} )
	aAdd( aExp, {'GPE_CONT_SINDIC'			,	SRA->RA_PGCTSIN														, "SRA->RA_PGCTSIN"			,STR0079	} )
	aAdd( aExp, {'GPE_COD_SINDICATO'		,	SRA->RA_SINDICA														, "SRA->RA_SINDICA"			,STR0080	} )
	aAdd( aExp, {'GPE_DESC_SINDICATPO'		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) )				, "@!"						,STR0081	} )
	aAdd( aExp, {'GPE_COD_ASS_MEDICA'		,	SRA->RA_ASMEDIC														, "SRA->RA_ASMEDIC"			,STR0082	} )
	aAdd( aExp, {'GPE_DEP_ASS_MEDICA'		,	SRA->RA_DPASSME														, "SRA->RA_DPASSME"			,STR0083	} )
	aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'		,	SRA->RA_ADTPOSE														, "SRA->RA_ADTPOSE"			,STR0084	} )
	aAdd( aExp, {'GPE_COD_CESTA_BASICA'		,	SRA->RA_CESTAB														, "SRA->RA_CESTAB"			,STR0085	} )
	aAdd( aExp, {'GPE_COD_VALE_REF' 		,	SRA->RA_VALEREF														, "SRA->RA_VALEREF"			,STR0086	} )
	aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV														, "SRA->RA_SEGUROV"			,STR0087	} )
	aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT														, "SRA->RA_PERCADT"			,STR0089	} )
	aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC														, "SRA->RA_CATFUNC"			,STR0090	} )
	aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")						, "@!"						,STR0091	} )
	aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(if(RA_CATFUNC$"H","P/Hora",if(RA_CATFUNC$"J","P/Aula","P/Mes"))) , "@!"					,STR0092	} )
	aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 						, "SRA->RA_TIPOPGT"			,STR0093	} )
	aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")						, "@!"						,STR0094	} )
	aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO														, "SRA->RA_SALARIO"			,STR0095	} )
	aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM														, "SRA->RA_ANTEAUM"			,STR0096	} )
	aAdd( aExp, {'GPE_HRS_PERICULO'  		,	SRA->RA_PERICUL														, "SRA->RA_PERICUL"			,STR0099	} )
	aAdd( aExp, {'GPE_HRS_INS_MINIMA'		,	SRA->RA_INSMIN														, "SRA->RA_INSMIN"			,STR0100	} )
	aAdd( aExp, {'GPE_HRS_INS_MEDIA'		,	SRA->RA_INSMED														, "@!"						,STR0101	} )
	aAdd( aExp, {'GPE_HRS_INS_MAXIMA'		,	SRA->RA_INSMAX														, "SRA->RA_INSMAX"			,STR0102	} )
	aAdd( aExp, {'GPE_TIPO_ADMISSAO'		,	SRA->RA_TIPOADM														, "SRA->RA_TIPOADM"			,STR0103	} )
	aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'		,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")						, "@!"						,STR0104	} )
	aAdd( aExp, {'GPE_COD_AFA_FGTS'			,	SRA->RA_AFASFGT														, "SRA->RA_AFASFGT"			,STR0105	} )
	aAdd( aExp, {'GPE_DESC_AFA_FGTS'		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")						, "@!"						,STR0106	} )
	aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI														, "SRA->RA_VIEMRAI"			,STR0107	} )
	//aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+RA_VIEMRAI,"X5_DESCRI")							, "@!"						,STR0108	} )
	aAdd( aExp, {'GPE_COD_INST_RAIS'		,	SRA->RA_GRINRAI														, "SRA->RA_GRINRAI"			,STR0109	} )
	aAdd( aExp, {'GPE_DESC_GRAU_INST'		,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")						, "@!"						,STR0110	} )
	aAdd( aExp, {'GPE_COD_RESC_RAIS'		,	SRA->RA_RESCRAI														, "SRA->RA_RESCRAI"			,STR0111	} )
	aAdd( aExp, {'GPE_CRACHA'		  		,	SRA->RA_CRACHA														, "SRA->RA_CRACHA"			,STR0112	} )
	aAdd( aExp, {'GPE_REGRA_APONTA'			,	SRA->RA_REGRA														, "SRA->RA_REGRA"			,STR0113	} )
	aAdd( aExp, {'GPE_NO_REGISTRO'	 		,	SRA->RA_REGISTR														, "SRA->RA_REGISTR"			,STR0115	} )
	aAdd( aExp, {'GPE_NO_FICHA'	    		,	SRA->RA_FICHA														, "SRA->RA_FICHA"			,STR0116	} )
	aAdd( aExp, {'GPE_TP_CONT_TRAB'			,	SRA->RA_TPCONTR														, "SRA->RA_TPCONTR"			,STR0117	} )
	aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'	,	SRA->(if(RA_TPCONTR="1","Indeterminado","Determinado")) 			, "@!"						,STR0118	} )
	aAdd( aExp, {'GPE_APELIDO'		   		,	SRA->RA_APELIDO														, "SRA->RA_APELIDO"			,STR0119	} )
	aAdd( aExp, {'GPE_E-MAIL'		 		,	SRA->RA_EMAIL														, "SRA->RA_EMAIL"			,STR0120	} )
	aAdd( aExp, {'GPE_TEXTO_01'				,	cTexto_01								   							, "@!"						,STR0121	} )
	aAdd( aExp, {'GPE_TEXTO_02'				,	cTexto_02															, "@!"						,STR0122	} )
	aAdd( aExp, {'GPE_TEXTO_03'				,	cTexto_03															, "@!"						,STR0123	} )
	aAdd( aExp, {'GPE_TEXTO_04'				,	cTexto_04															, "@!"						,STR0124	} )
	aAdd( aExp, {'GPE_EXTENSO_SAL'			,	Extenso( SRA->RA_SALARIO , .F. , 1 )								, "@!"						,STR0125 	} )
	aAdd( aExp, {'GPE_DDATABASE'			,	dDataBase                    	        							, "" 						,STR0126	} )
	aAdd( aExp, {'GPE_DIA_DDATABASE'		,	StrZero( Day( dDataBase ) , 2 )            							, "@!"						,STR0127	} )
	aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 											, "@!"						,STR0128	} )
	aAdd( aExp, {'GPE_ANO_DDATABASE'		,	StrZero( Year( dDataBase ) , 4 )            						, "@!"						,STR0129	} )
	aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	aInfo[03]                              								, "@!"						,STR0130	} )
	aAdd( aExp, {'GPE_end_EMPRESA'			,	aInfo[04]                              								, "@!"						,STR0131	} )
	aAdd( aExp, {'GPE_CID_EMPRESA'			,	aInfo[05]                              								, "@!"						,STR0132	} )
	aAdd( aExp, {'GPE_CEP_EMPRESA'       	,   aInfo[07]                                              				, "!@R #####-###"       	,STR0034 	} )
	aAdd( aExp, {'GPE_EST_EMPRESA'       	,   aInfo[06]															, "@!"						,STR0032 	} )
	aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	aInfo[08]             												, "@R ##.###.###/####-##"	,STR0134	} )
	aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	aInfo[09]                              								, "@!" 						,STR0135	} )
	aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	aInfo[10]                              								, "@!" 						,STR0136	} )
	aAdd( aExp, {'GPE_FAX_EMPRESA'       	,   if(aInfo[11]#nil ,aInfo[11], "        ")              				, "@!"                  	,STR0136 	} )
	aAdd( aExp, {'GPE_BAI_EMPRESA'			,	aInfo[13]                              								, "@!" 						,STR0137	} )
	aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")						, "@!" 						,STR0138	} )
	aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )								, "@!" 						,STR0139	} )
	aAdd( aExp, {'GPE_MES_DEMISSAO'			,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )								, "@!" 						,STR0140 	} )
	aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )								, "@!" 						,STR0141 	} )

	if cPaisLoc == "COL"
	   aAdd( aExp, {'GPE_DIA_INifERIAS'		,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,1] ) , 2 ),space(02))   	, "@!" ,STR0188 	} )
	   aAdd( aExp, {'GPE_MES_INifERIAS'		,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,1] ),space(12)) 				, "@!" ,STR0189 	} )
	   aAdd( aExp, {'GPE_ANO_INifERIAS' 	,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,1] ) , 4 ),space(04))  	, "@!" ,STR0190 	} )

	   aAdd( aExp, {'GPE_DIA_FIMFERIAS'		,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,2] ) , 2 ),space(02))   	, "@!" ,STR0191 	} )
	   aAdd( aExp, {'GPE_MES_FIMFERIAS'		,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,2] ),space(12)) 				, "@!" ,STR0192 	} )
	   aAdd( aExp, {'GPE_ANO_FIMFERIAS'		,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,2] ) , 4 ),space(04))  	, "@!" ,STR0193 	} )
	endif

	//Salario Familia
	aAdd( aExp, {'GPE_CFILHO01'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[01,01],space(30))	, "@!"	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL01'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[01,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO02'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[02,01],space(30))	, "@!"	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL02'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[02,02],space(08))	, ""	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO03'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[03,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL03'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[03,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO04'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[04,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL04'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[04,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO05'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[05,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL05'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[05,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO06'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[06,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL06'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[06,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO07'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[07,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL07'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[07,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO08'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[08,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL08'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[08,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO09'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[09,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL09'             	,   if(nDepen==1 .or. nDepen==3,aDepenSF[09,02],space(08))	, ""   	,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO10'           	,   if(nDepen==1 .or. nDepen==3,aDepenSF[10,01],space(30))	, "@!" 	,STR0150 	} )
	aAdd( aExp, {'GPE_DESC_ESTEMP'        	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      	, "@!" 	,STR0134 	} )
	aAdd( aExp, {'GPE_cGrau01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_local01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[01,10],space(10))	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[02,10],space(10))	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[03,10],space(10))  , "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[04,10],space(10)) 	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[05,10],space(10))	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[06,10],space(10))	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[07,10],space(10)) 	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[08,10],space(10)) 	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[09,10],space(10))	, "@!"	,STR0161 	} )
	aAdd( aExp, {'GPE_local10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,04],space(10))	, "@!"	,STR0164 	} )
	aAdd( aExp, {'GPE_CARTORIO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,05],space(10))	, "@!"	,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,06],space(10))	, "@!"	,STR0165 	} )
	aAdd( aExp, {'GPE_NLIVRO10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,07],space(10))	, "@!"	,STR0158 	} )
	aAdd( aExp, {'GPE_NFOLHA10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,08],space(10))	, "@!"	,STR0159 	} )
	aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,09],space(10))	, "@!"	,STR0160 	} )
	aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,10],space(10))	, "@!"	,STR0161 	} )

	//Imposto de renda
	aAdd( aExp, {'GPE_CDEPE01'           	,	if(nDepen==2 .or. nDepen==3,aDepenIR[01,01],space(30))	, "@!"	,STR0154  	} )
	aAdd( aExp, {'GPE_cGrDp01'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[01,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR01'          	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[01,02],space(08)) 	, ""	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[02,01],space(30))	, "@!" 	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[02,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR02'          	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[02,02],space(08))	, ""	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[03,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[03,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR03'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[03,02],space(08)) 	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[04,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[04,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR04'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[04,02],space(08)) 	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[05,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[05,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR05'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[05,02],space(08))	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[06,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[06,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR06'				,  	if(nDepen==2 .or. nDepen==3,aDepenIR[06,02],space(08)) 	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[07,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[07,03],space(10))	, "@!"	,STR0153	} )
	aAdd( aExp, {'GPE_DTFLIR07'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[07,02],space(08))	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[08,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[08,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR08'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[08,02],space(08)) 	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[09,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[09,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR09'           	,  	if(nDepen==2 .or. nDepen==3,aDepenIR[09,02],space(08)) 	, ""   	,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,01],space(30))	, "@!"	,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,03],space(10))	, "@!"	,STR0153 	} )
	aAdd( aExp, {'GPE_DTFLIR10'           	, 	if(nDepen==2 .or. nDepen==3,aDepenIR[10,02],space(08))	, ""   	,STR0163 	} )

	if cPaisLoc == "ARG"
		aAdd( aExp, {'GPE_MES_ADEXT'		,	MesExtenso( Month( SRA->RA_ADMISSA ) )	, "@!"	,STR0155	} )
		aAdd( aExp, {'GPE_APODERADO'		,	cApoderado								, "@!"	,STR0156	} )
		aAdd( aExp, {'GPE_ATIVIDADE'		,	cRamoAtiv								, "@!"	,STR0157	} )
	endif

	aAdd( aExp, {'GPE_MUNICNASC'          	,   if(SRA->(FieldPos("RA_MUNNASC")) # 0  ,SRA->RA_MUNNASC,space(20)), "@!" ,STR0166 	} )
	if SRA->(FieldPos("RA_PROCES" )) != 0
		aAdd( aExp, {'GPE_PROCES'			,	SRA->RA_PROCES	,	"SRA->RA_PROCES",STR0173 	} )	//Codigo do Processo
	endif

	if SRA->(FieldPos("RA_DEPTO"  )) != 0
		aAdd( aExp, {'GPE_DEPTO'			,	SRA->RA_DEPTO	,	"SRA->RA_DEPTO"	,STR0181 	} )	//Codigo do Departamento
	endif

	if SRA->(FieldPos("RA_POSTO"  )) != 0
		aAdd( aExp, {'GPE_POSTO'			,	SRA->RA_POSTO  	,	"SRA->RA_POSTO"	,STR0182 	} )	//Codigo do Posto
	endif

	if cPaisLoc == "MEX"
		aAdd( aExp, {'GPE_PRINOME'	,	SRA->RA_PRINOME	,	"SRA->RA_PRINOME"	,STR0169	} ) 	//Primeiro Nome
		aAdd( aExp, {'GPE_SECNOME'	,	SRA->RA_SECNOME	,	"SRA->RA_SECNOME"	,STR0170	} ) 	//Segundo Nome
		aAdd( aExp, {'GPE_PRISOBR'	,	SRA->RA_PRISOBR	,	"SRA->RA_PRISOBR"	,STR0171	} ) 	//Primeiro Sobrenome
		aAdd( aExp, {'GPE_SECSOBR'	,	SRA->RA_SECSOBR	,	"SRA->RA_SECSOBR"	,STR0172	} ) 	//Segundo Sobrenome
		aAdd( aExp, {'GPE_KEYLOC'	,	SRA->RA_KEYLOC	,	"SRA->RA_KEYLOC"	,STR0174	} ) 	//Codigo local de Pagamento
		aAdd( aExp, {'GPE_TSIMSS'	,	SRA->RA_TSIMSS	,	"SRA->RA_TSIMSS"	,STR0175	} ) 	//Tipo de Salario IMSS
		aAdd( aExp, {'GPE_TEIMSS'	,	SRA->RA_TEIMSS	,	"SRA->RA_TEIMSS"	,STR0176	} ) 	//Tipo de Empregado IMSS
		aAdd( aExp, {'GPE_TJRNDA'	,	SRA->RA_TJRNDA	,	"SRA->RA_TJRNDA"	,STR0177	} ) 	//Tipo de Jornada IMSS
		aAdd( aExp, {'GPE_FECREI'	,	SRA->RA_FECREI	,	"SRA->RA_FECREI"	,STR0178	} ) 	//Data de Readmissao
		aAdd( aExp, {'GPE_DTBIMSS'	,	SRA->RA_DTBIMSS	,	"SRA->RA_DTBIMSS"	,STR0179	} ) 	//Data de Baixa IMSS
		aAdd( aExp, {'GPE_CODRPAT'	,	SRA->RA_CODRPAT	,	"SRA->RA_CODRPAT"	,STR0180	} ) 	//Codigo do Registro Patronal
		aAdd( aExp, {'GPE_CURP'		,	SRA->RA_CURP		,	"SRA->RA_CURP"	,STR0183	} ) 	//CURP
		aAdd( aExp, {'GPE_TIPINF'	,	SRA->RA_TIPINF	,	"SRA->RA_TIPINF"	,STR0184	} ) 	//Tipo de Infonavit
		aAdd( aExp, {'GPE_VALINF'	,	SRA->RA_VALINF	,	"SRA->RA_VALINF"	,STR0185	} ) 	//Valor do Infonavit
		aAdd( aExp, {'GPE_NUMINF'	,	SRA->RA_NUMINF	,	"SRA->RA_NUMINF"	,STR0186	} ) 	//Nro. de Credito Infonavit
	endif

	if cPaisLoc == "ANG"
		aAdd( aExp, {'GPE_BIDENT'	     ,	SRA->RA_BIDENT 	,	"SRA->RA_BIDENT "								,STR0195	} ) //Nr. Bilhete Identidade
		aAdd( aExp, {'GPE_BIEMISS'	     ,	SRA->RA_BIEMISS	,	"SRA->RA_BIEMISS"								,STR0196	} ) //Data de Emissão do Bilhete Identidade
		aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"	,STR0194	} ) //Descrição do Estado Civil
	endif
	//Periodo Aquisitivo de Ferias

	/*
	aAdd( aExp, {'GPE_DATA_INIPERAQUI'	,	aPerSRF[1][1]				,"@!"		,	"Data Inicial do Periodo Aquisitivo"	})
	aAdd( aExp, {'GPE_DATA_FIMPERAQUI'	,	aPerSRF[1][2]				,"@!"		,	"Data Final do Periodo Aquisitivo"		})
	aAdd( aExp, {'GPE_DATA_INIIDEAL'	,	(aPerSRF[1][2]+30)			,"@!"		,	"Data Limite Ideal"						})
	aAdd( aExp, {'GPE_DATA_MAXIDEAL'	,	(aPerSRF[1][3]-45)			,"@!"		,	"Data Limite Maximo"					})
	*/

	//Customizado
	aAdd( aExp, {'GPE_DATA_ADMISSAOEXT'		,	MesExtenso( SRA->RA_ADMISSA ) 		, "@!"					, 'Mês em extenso'							} )
	aAdd( aExp, {'GPE_COMP_endEMP'			,	cCompendEmp 						, "@!"					, 'Complemento do endereço de entrega' 		} )
	aAdd( aExp, {'GPE_NOME_PROJETO'			,	cNomeProces  						, "@!"					, 'Nome do projeto' 						} )
	aAdd( aExp, {'GPE_DIAS_CONTRAB'			,	SRA->RA_DIACTRB  					, "SRA->RA_DIACTRB"		, 'Dias do contrato de trabalho'			} )
	aAdd( aExp, {'GPE_DTFIM_CONTRB'			,	SRA->RA_DTFIMCT  					, "SRA->RA_DTFIMCT"		, 'Data fim do contrato de trabalho'		} )
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA2'	,	SRA->RA_VCTEXP2						, "SRA->RA_VCTOEXP"		, STR0055									} )
	aAdd( aExp, {'GPE_HRS_ENTRA'			,	cHoraIni  							, "@!"					, 'Hora entrada'							} )
	aAdd( aExp, {'GPE_HRS_SAIDA'			,	cHoraFim  							, "@!"					, 'Hora saída'								} )
	aAdd( aExp, {'GPE_HRS_INTERVALO'		,	nHrInter  							, "@!"  				, 'Hora saída'								} )

return( aExp )

/*{Protheus.doc} NomeArq
Monta nome de arquivo que sera gerado
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function NomeArq(cArquivo)
	local cRetorno := ''

	if !empty(cArquivo)
		aArquivo := strTokArr(cArquivo, '\')
		if len(aArquivo) > 0
			cRetorno := aArquivo[len(aArquivo)]
			cRetorno := SRA->RA_MAT+'_'+replace(cRetorno, '.dot', '.docx')
		endif
	endif
return cRetorno

/*{Protheus.doc} TurnoTrab
Retorna horario de entrada e saida
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
@description
	Alterado em 07/11/2017 - Opvs (Bruno Nunes)
	Alteracao: Revisão do fonte para funcionar no P12.
*/
static function TurnoTrab()
	SPJ->(dbSetOrder(1))
	if SPJ->(dbSeek(xFilial('SPJ')+SRA->RA_TNOTRAB+SRA->RA_SEQTURN ) )
		while SPJ->(!EoF()) .And. SPJ->PJ_TPDIA != 'S'
			SPJ->(dbSkip())
		end

		if SPJ->(!EoF())
			nHrInter := strZero( SPJ->PJ_HRSINT1 * 60, 2)
			cHoraIni := replace(strZero( SPJ->PJ_ENTRA1, 5, 2 ), ',', ':' )
			iif( SPJ->PJ_SAIDA1 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA1, 5, 2 ) , ',', ':' ), nil )

			iif( SPJ->PJ_ENTRA2 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA2, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA2 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA2, 5, 2 ) , ',', ':' ), nil )

			iif( SPJ->PJ_ENTRA3 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA3, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA3 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA3, 5, 2 ) , ',', ':' ), nil )

			iif( SPJ->PJ_ENTRA4 > 0, cHoraFim := replace(strZero(  SPJ->PJ_ENTRA4, 5, 2 ) , ',', ':' ), nil )
			iif( SPJ->PJ_SAIDA4 > 0, cHoraFim := replace(strZero(  SPJ->PJ_SAIDA4, 5, 2 ) , ',', ':' ), nil )
		endif
	endif
return

/*{Protheus.doc} AjustaSx1
Cria Pergunte "cTpPerg" caso não exista
@param [ cTpPerg ], texto, Tipo do relatÃ³rio baixado ou não baixado
@type function
@author BrunoNunes
@since 18/05/2018
@version P12 1.12.17
@return null, Nulo
*/
Static Function AjustaSx1( cTpPerg )
	default cTpPerg := '' //Tipo de pergunte

	if cTpPerg == cPERGUNTE_WORD
 	  //xPutSx1([cGrupo] 	  , [cOrdem], [cPergunt]					  , [cPerSpa]	, [cPerEng]	, [cVar]	,[cTipo	],[nTamanho]	,[nDecimal]	,[nPresel]	,[cGSC]	,[cValid]			, [cF3], [cGrpSxg], [cPyme], [cVar01]  , [cDef01]			,[cDefSpa1]	, [cDefEng1], [cCnt01]				,[cDef02]			,[cDefSpa2]	, [cDefEng2], [cDef03]	,[cDefSpa3] , [cDefEng3], [cDef04], [cDefSpa4], [cDefEng4], [cDef05]	, [cDefSpa5], [cDefEng5], [aHelpPor], [aHelpEng], [aHelpSpa], [cHelp] )
		xPutSx1(cPERGUNTE_WORD, '01' 	, 'Filial De          ?'		  , '' 			, '' 		, 'mv_ch1'	,'C'  	 ,FWGETTAMFILIAL, 0			, 0			,'G'	,''					, 'SM0', ''		  , ''     , 'MV_PAR01', ''  				, ''		, ''		, space(FWGETTAMFILIAL)	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''   	  , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '02' 	, 'Filial Ate         ?'		  , '' 			, '' 		, 'mv_ch2'	,'C'  	 ,FWGETTAMFILIAL, 0			, 0			,'G'	,'naovazio'			, 'SM0', ''		  , ''     , 'MV_PAR02', ''  				, ''		, ''		, replicate('9',02) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	      , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '03' 	, 'Centro de Custo De ?'	  	  , '' 			, '' 		, 'mv_ch3'	,'C'  	 ,09     		, 0			, 0			,'G'	,''					, 'CTT', ''		  , ''     , 'MV_PAR03', ''  				, ''		, ''		, space(09)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''  	  , ''        , ''	      , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '04' 	, 'Centro de Custo Ate?'		  , '' 			, '' 		, 'mv_ch4'	,'C'  	 ,09     		, 0			, 0			,'G'	,'naovazio'			, 'CTT', ''		  , ''     , 'MV_PAR04', ''  				, ''		, ''		, replicate('Z',09) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '05' 	, 'Matricula De       ?'		  , '' 			, '' 		, 'mv_ch5'	,'C'  	 ,06     		, 0			, 0			,'G'	,''					, 'SRA', ''		  , ''     , 'MV_PAR05', ''  				, ''		, ''		, space(06)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '06' 	, 'Matricula Ate      ?'		  , '' 			, '' 		, 'mv_ch6'	,'C'  	 ,06     		, 0			, 0			,'G'	,'naovazio'			, 'SRA', ''		  , ''     , 'MV_PAR06', ''  				, ''		, ''		, replicate('Z',06) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '07' 	, 'Nome De            ?'		  , '' 			, '' 		, 'mv_ch7'	,'C'  	 ,30     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR07', '' 			 	, ''		, ''		, space(30)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '08' 	, 'Nome Ate           ?'		  , '' 			, '' 		, 'mv_ch8'	,'C'  	 ,30     		, 0			, 0			,'G'	,'naovazio'			, ''   , ''		  , ''     , 'MV_PAR08', '' 			 	, ''		, ''		, replicate('Z',30) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '09' 	, 'Turno De           ?'		  , '' 			, '' 		, 'mv_ch9'	,'C'  	 ,03     		, 0			, 0			,'G'	,''					, 'SR6', ''		  , ''     , 'MV_PAR09', ''  				, ''		, ''		, space(03)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '10' 	, 'Turno Ate          ?'		  , '' 			, '' 		, 'mv_cha'	,'C'  	 ,03     		, 0			, 0			,'G'	,'naovazio'			, 'SR6', ''		  , ''     , 'MV_PAR10', ''  				, ''		, ''		, replicate('Z',03) 	, ''				, ''		, ''		, ''		,''   		, '' 		, ''  	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '11' 	, 'Funâ€¡ao De          ?'		  , '' 			, '' 		, 'mv_chb'	,'C'  	 ,05     		, 0			, 0			,'G'	,''					, 'SRJ', ''		  , ''     , 'MV_PAR11', ''  				, ''		, ''		, space(03)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '12' 	, 'Funâ€¡ao Ate         ?'		  , '' 			, '' 		, 'mv_chc'	,'C'  	 ,05     		, 0			, 0			,'G'	,'naovazio'			, 'SRJ', ''		  , ''     , 'MV_PAR12', ''  				, ''		, ''		, replicate('Z',03) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''		  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '13' 	, 'Sindicato De       ?'		  , '' 			, '' 		, 'mv_chd'	,'C'  	 ,02     		, 0			, 0			,'G'	,''					, 'X04', ''		  , ''     , 'MV_PAR13', ''  				, ''		, ''		, space(03)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '14' 	, 'Sindicato Ate      ?'		  , ''			, '' 		, 'mv_che'	,'C'  	 ,02     		, 0			, 0			,'G'	,'naovazio'			, 'X04', ''		  , ''     , 'MV_PAR14', ''  				, ''		, ''		, replicate('Z',03) 	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '15' 	, 'Admissao De        ?'		  , '' 			, '' 		, 'mv_chf'	,'D'  	 ,08     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR15', ''  				, ''		, ''		, ''					, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '16' 	, 'Admissao Ate       ?'	 	  , '' 			, '' 		, 'mv_chg'	,'D'  	 ,08     		, 0			, 0			,'G'	,'naovazio'			, ''   , ''		  , ''     , 'MV_PAR16', ''  			 	, ''		, ''		, ''					, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '17' 	, 'SituaçÃµes  a Impr. ?'		  , '' 			, '' 		, 'mv_chh'	,'C'  	 ,05     		, 0			, 0			,'G'	,'fSituacao'		, ''   , ''		  , ''     , 'MV_PAR17', ''  	 			, ''		, ''		, space(05)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '18' 	, 'Categorias a Impr. ?'		  , '' 			, '' 		, 'mv_chi'	,'C'  	 ,10     		, 0			, 0			,'G'	,'fCategoria'		, ''   , ''		  , ''     , 'MV_PAR18', ''  	 			, ''		, ''		, space(10)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '19' 	, 'Texto Livre 1      ?'		  , '' 			, '' 		, 'mv_chj'	,'C'  	 ,30     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR19', ''  	 			, ''		, ''		, '<Texto Livre 01>'	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '20' 	, 'Texto Livre 2      ?'	  	  , '' 			, '' 		, 'mv_chk'	,'C'  	 ,30     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR20', ''  	 			, ''		, ''		, '<Texto Livre 02>'	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '21' 	, 'Texto Livre 3      ?'		  , '' 			, '' 		, 'mv_chl'	,'C'  	 ,30     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR21', ''  	 			, ''		, ''		, '<Texto Livre 03>'	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '22' 	, 'Texto Livre 4      ?'		  , '' 			, '' 		, 'mv_chm'	,'C'  	 ,30     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR22', ''      			, ''		, ''		, '<Texto Livre 04>'	, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '23' 	, 'Nro. de Copias     ?'		  , '' 			, '' 		, 'mv_chn'	,'N'  	 ,03     		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR23', ''  	 			, ''		, ''		, space(03)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '24' 	, 'Ordem de Impressao ?'		  , '' 			, '' 		, 'mv_cho'	,'N'  	 ,01     		, 0			, 0			,'C'	,''					, ''   , ''		  , ''     , 'MV_PAR24', 'Matricula'  		, ''		, ''		, ''					, 'Centro de Custo'	, ''		, ''		, 'Nome'	,''   		, '' 		, 'Turno' , ''        , ''	 	  , 'Admissao'	, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '25' 	, 'Arquivo do Word .dot?'		  , ''	 		, '' 		, 'mv_chp'	,'C'  	 ,75     		, 0			, 0			,'G'	,'U_CSRH170f()'		, ''   , ''		  , ''     , 'MV_PAR25', ''  				, ''		, ''		, space(75)				, ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '26' 	, 'Verific.Dependente ?'		  , '' 			, '' 		, 'mv_chq'	,'N'	 ,01    		, 0			, 1			,'C'	,''      			, ''   , ''		  , ''     , 'MV_PAR26', 'Sim'              , ''		, ''		, ''					, 'Nao'            	, ''		, ''		, ''     	,''   		, ''      	, ''      , ''        , ''	      , ''	     	, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '27' 	, 'Tipo de Dependente ?'		  , '' 			, '' 		, 'mv_chr'	,'N'  	 ,01    		, 0			, 3			,'C'	,''                	, ''   , ''		  , ''     , 'MV_PAR27', 'Dep.Sal.Familia'  , ''		, ''		, ''					, 'Dep.Imp.Renta'  	, ''		, ''		, 'Ambos'	,'' 		, ''	 	, ''	  , ''	      , ''	      , ''	  		, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '28' 	, 'Impressao          ?'		  , '' 			, '' 		, 'mv_chs'	,'N'  	 ,01    		, 0			, 0			,'C'	,''					, ''   , ''		  , ''     , 'MV_PAR28', 'Impressora' 		, ''		, ''		, ''					, 'Arquivo'			, ''		, ''		, ''     	,''        	, ''		, ''      , ''        , ''        , ''        	, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '29' 	, 'DiretÃ³rio do Arquivo de Saída?', '' 			, '' 		, 'mv_cht'	,'C'  	 ,75    		, 0			, 0			,'G'	,'U_CSRH171f()'		, ''   , ''		  , ''     , 'MV_PAR29', ''  				, ''		, ''		, space(75)				, ''				, ''		, ''		, ''    	,''   		, '' 		, ''      , ''        , ''    	  , ''    		, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_WORD, '30' 	, 'Tipo PIS           ?'		  , '' 			, '' 		, 'mv_chu'	,'C'  	 ,01    		, 0			, 0			,'G'	,''					, ''   , ''		  , ''     , 'MV_PAR30', ''  				, ''		, ''		, ''					, ''				, ''		, ''		, ''    	,''   		, '' 		, ''      , ''        , ''    	  , ''    		, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
	elseif cTpPerg == cPERGUNTE_CERTIFLOW_ABH
 	  //xPutSx1([cGrupo] 	  		   , [cOrdem], [cPergunt]					  , [cPerSpa]	, [cPerEng]	, [cVar]	,[cTipo	],[nTamanho]	     ,[nDecimal]	,[nPresel]	,[cGSC]	,[cValid]			, [cF3], [cGrpSxg], [cPyme], [cVar01]  , [cDef01]			,[cDefSpa1]	, [cDefEng1], [cCnt01]				             ,[cDef02]			,[cDefSpa2]	, [cDefEng2], [cDef03]	,[cDefSpa3] , [cDefEng3], [cDef04], [cDefSpa4], [cDefEng4], [cDef05]	, [cDefSpa5], [cDefEng5], [aHelpPor], [aHelpEng], [aHelpSpa], [cHelp] )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '01' 	, 'Filial De          ?'		  , '' 			, '' 		, 'mv_ch1'	,'C'  	 ,FWGETTAMFILIAL     , 0			, 0			,'G'	,''					, 'SM0', ''		  , ''     , 'MV_PAR01', ''  				, ''		, ''		, space(FWGETTAMFILIAL)	             , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''   	  , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '02' 	, 'Filial Ate         ?'		  , '' 			, '' 		, 'mv_ch2'	,'C'  	 ,FWGETTAMFILIAL     , 0			, 0			,'G'	,'naovazio'			, 'SM0', ''		  , ''     , 'MV_PAR02', ''  				, ''		, ''		, replicate('9',02) 	             , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	      , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '03' 	, 'Centro de Custo De ?'	  	  , '' 			, '' 		, 'mv_ch3'	,'C'  	 ,TamSx3("RA_CC")[1] , 0			, 0			,'G'	,''					, 'CTT', ''		  , ''     , 'MV_PAR03', ''  				, ''		, ''		, space(TamSx3("RA_CC")[1] )		 , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''  	  , ''        , ''	      , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '04' 	, 'Centro de Custo Ate?'		  , '' 			, '' 		, 'mv_ch4'	,'C'  	 ,TamSx3("RA_CC")[1] , 0			, 0			,'G'	,'naovazio'			, 'CTT', ''		  , ''     , 'MV_PAR04', ''  				, ''		, ''		, replicate('Z',TamSx3("RA_CC")[1] ) , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '05' 	, 'Matricula De       ?'		  , '' 			, '' 		, 'mv_ch5'	,'C'  	 ,TamSx3("RA_MAT")[1], 0			, 0			,'G'	,''					, 'SRA', ''		  , ''     , 'MV_PAR05', ''  				, ''		, ''		, space(TamSx3("RA_MAT")[1])         , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '06' 	, 'Matricula Ate      ?'		  , '' 			, '' 		, 'mv_ch6'	,'C'  	 ,TamSx3("RA_MAT")[1], 0			, 0			,'G'	,'naovazio'			, 'SRA', ''		  , ''     , 'MV_PAR06', ''  				, ''		, ''		, replicate('Z',TamSx3("RA_MAT")[1]) , ''				, ''		, ''		, ''	 	,''   		, '' 		, ''   	  , ''        , ''	 	  , ''			, ''		, ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '07' 	, 'SituaçÃµes  a Impr. ?'		  , '' 			, '' 		, 'mv_ch7'	,'C'  	 ,05     		     , 0			, 0			,'G'	,'fSituacao'		, ''   , ''		  , ''     , 'MV_PAR07', ''  	 			, ''		, ''		, space(05)				, ''		 , ''		        , ''		, ''	 	, ''   		,'' 		, ''   	    , ''      , ''	 	  , ''	      , ''		    , ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '08' 	, 'Aceite BH em formato .dot?'	  , ''	 		, '' 		, 'mv_ch8'	,'C'  	 ,75     		     , 0			, 0			,'G'	,'U_CSRH172f()'		, ''   , ''		  , ''     , 'MV_PAR08', ''  				, ''		, ''		, space(75)				, ''		 , ''		        , ''		, ''	 	, ''   		,'' 		, ''   	    , ''      , ''	 	  , ''		  , ''		    , ''  		, {}  	  	, {}	 	, {}		, '' )
		xPutSx1(cPERGUNTE_CERTIFLOW_ABH, '09' 	, 'DiretÃ³rio do Arquivo de Saída?', '' 			, '' 		, 'mv_ch9'	,'C'  	 ,75    		     , 0			, 0			,'G'	,'U_CSRH173f()'		, ''   , ''		  , ''     , 'MV_PAR09', ''  				, ''		, ''		, space(75)				, ''		 , ''		        , ''		, ''    	, ''   		,'' 		, ''        , ''      , ''    	  , ''        , ''		    , ''  		, {}  	  	, {}	 	, {}		, '' )
	endif
Return

/*{Protheus.doc} xPutSx1
Função de criada para substituir o PutSX1, pois não esta funcionando na P12.
@param [ cGrupo   ], texto	 , CÃ³digo chave de identificação da pergunta. Através deste cÃ³digo as perguntas são agrupadas em um conjunto
@param [ cOrdem   ], texto	 , Ordem de apresentação das perguntas. A ordem é importante para a criação das variáveis de escopo PRIVATE MV_PAR??
@param [ cPergunt ], texto	 , RÃ³tulo com a descrição da pergunta no idioma Português
@param [ cPerSpa  ], texto	 , RÃ³tulo com a descrição da pergunta no idioma Espanhol
@param [ cPerEng  ], texto	 , RÃ³tulo com a descrição da pergunta no idioma Inglês
@param [ cVar     ], texto	 , *** Não usado ***
@param [ cTipo 	  ], texto	 , Tipo de dado da pergunta, onde temos: C â€“ Caracter; L- LÃ³gico; D-Data; N-Numérico; M-Memo
@param [ nTamanho ], numerico, Tamanho do Campo
@param [ nDecimal ], numerico, Quantidade de casas decimais, se o tipo for numérico
@param [ nPresel  ], numerico, Quando temos uma Pergunta tipo Combo, podemos deixar o valor padrão selecionado neste campo, deve ser informado qual o número da opção selecionada.
@param [ cGSC     ], texto	 , Tipo de objeto a ser criado para essa pergunta, valores aceitos são:(G) Edit,(S)Text,(C) Combo,(R) Range,File,Expression ou (K)=Check. Caso campo esteja em branco é tratado como Edit. Objetos do tipo combo podem ter no máximo 5 itens
@param [ cValid   ], texto	 , Validação da Pergunta. A função deverá ser Function(para GDPs) ou User Function (Cliente) , Static Function não podem ser utilizadas.
@param [ cF3      ], texto	 , LookUp associado a pergunta
@param [ cGrpSxg  ], texto	 , CÃ³digo do grupo de campo(SXG) que o campo pertence. Todos os campos que estão associados a um grupo de campo, sofrem as alteraçÃµes quando alteramos ele.
@param [ cPyme    ], texto	 , Determina se a pergunta é utilizada pelo Microsiga Protheus Serie 3
@param [ cVar01   ], texto	 , Nome da variável criada para essa pergunta, no modelo MV_PARXXX, onde XXX é um sequencial numérico.
@param [ cDef01   ], texto   , Item 1 do combo Box quando o X1_GSC igual a C. Em Português.
@param [ cDefSpa1 ], texto	 , Item 1 do combo Box quando o X1_GSC igual a C. Em Espanhol.
@param [ cDefEng1 ], texto	 , Item 1 do combo Box quando o X1_GSC igual a C. Em Inglês.
@param [ cCnt01   ], texto	 , Conteúdo inicial da variavel1, usada quando X1_GSC for Text ou Range,
@param [ cDef02   ], texto	 , Item 2 do combo Box quando o X1_GSC igual a C. Em Português.
@param [ cDefSpa2 ], texto	 , Item 2 do combo Box quando o X1_GSC igual a C. Em Espanhol.
@param [ cDefEng2 ], texto	 , Item 2 do combo Box quando o X1_GSC igual a C. Em Inglês.
@param [ cDef03   ], texto	 , Item 3 do combo Box quando o X1_GSC igual a C. Em Português.
@param [ cDefSpa3 ], texto	 , Item 3 do combo Box quando o X1_GSC igual a C. Em Espanhol.
@param [ cDefEng3 ], texto	 , Item 3 do combo Box quando o X1_GSC igual a C. Em Inglês.
@param [ cDef04   ], texto	 , Item 4 do combo Box quando o X1_GSC igual a C. Em Português.
@param [ cDefSpa4 ], texto	 , Item 4 do combo Box quando o X1_GSC igual a C. Em Espanhol.
@param [ cDefEng4 ], texto	 , Item 4 do combo Box quando o X1_GSC igual a C. Em Inglês.
@param [ cDef05   ], texto	 , Item 5 do combo Box quando o X1_GSC igual a C. Em Português.
@param [ cDefSpa5 ], texto	 , Item 5 do combo Box quando o X1_GSC igual a C. Em Espanhol.
@param [ cDefEng5 ], texto	 , Item 5 do combo Box quando o X1_GSC igual a C. Em Inglês.
@param [ aHelpPor ], lista	 , CÃ³digo do HELP para a pergunta.
@param [ aHelpEng ], lista	 , CÃ³digo do HELP para a pergunta.
@param [ aHelpSpa ], lista	 , CÃ³digo do HELP para a pergunta.
@param [ cHelp    ], texto	 , Texto do help.

@type function
@author BrunoNunes
@since 18/05/2018
@version P12 1.12.17
@return null, Nulo
*/
Static Function xPutSx1(	cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
							cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
							cF3, cGrpSxg,cPyme,;
							cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
							cDef02,cDefSpa2,cDefEng2,;
							cDef03,cDefSpa3,cDefEng3,;
							cDef04,cDefSpa4,cDefEng4,;
							cDef05,cDefSpa5,cDefEng5,;
							aHelpPor,aHelpEng,aHelpSpa,cHelp)
	local aArea	:= GetArea()
	local cKey	:= ''
	local lPort	:= .F.
	local lSpa	:= .F.
	local lIngl := .F.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme   	:= Iif( cPyme   	== Nil, " ", cPyme  	)
	cF3     	:= Iif( cF3     	== NIl, " ", cF3   		)
	cGrpSxg		:= Iif( cGrpSxg		== Nil, " ", cGrpSxg	)
	cCnt01  	:= Iif( cCnt01  	== Nil, "" , cCnt01		)
	cHelp    	:= Iif( cHelp   	== Nil, "" , cHelp  	)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt	:= If(! "?" $ cPergunt 	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt	)
	  	cPerSpa  	:= If(! "?" $ cPerSpa 	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa	)
	  	cPerEng   	:= If(! "?" $ cPerEng 	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng	)

	 	Reclock( "SX1" , .T. )

		Replace X1_GRUPO	With cGrupo
		Replace X1_ORDEM   	With cOrdem
		Replace X1_PERGUNT 	With cPergunt
		Replace X1_PERSPA 	With cPerSpa
		Replace X1_PERENG 	With cPerEng
		Replace X1_VARIAVL 	With cVar
		Replace X1_TIPO    	With cTipo
		Replace X1_TAMANHO 	With nTamanho
		Replace X1_DECIMAL 	With nDecimal
		Replace X1_PRESEL 	With nPresel
		Replace X1_GSC    	With cGSC
		Replace X1_VALID   	With cValid
		Replace X1_VAR01   	With cVar01
		Replace X1_F3      	With cF3
		Replace X1_GRPSXG 	With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
		Replace X1_HELP With cHelp
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		MsUnlock()
	Else
		lPort 	:= ! "?" $ X1_PERGUNT	.And. ! Empty(SX1->X1_PERGUNT)
		lSpa 	:= ! "?" $ X1_PERSPA 	.And. ! Empty(SX1->X1_PERSPA)
		lIngl	:= ! "?" $ X1_PERENG 	.And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )
Return

/*{Protheus.doc} validSX1
Validação dos parametros SX1
@param [ cTpPerg ], texto, Tipo do relatÃ³rio baixado ou não baixado
@type function
@author BrunoNunes
@since 18/05/2018
@version P12 1.12.17
@return null, Nulo
*/
static function validSX1(cArqWord, cArqSaida)
	local lRetorno := .T.

	default cArqWord  := ""
	default cArqSaida := ""

	//Checa o SO do Remote (1=Windows, 2=Linux)
	if GetRemoteType() == 2
		MsgAlert(OemToAnsi(STR0167), OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
		lRetorno := .F.
	endif

	if empty(cArqWord)
		MsgAlert("Modelo .dot não selecionado", OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
		lRetorno := .F.
	else
		if !file(cArqWord)
			MsgAlert("Arquivo .dot não encontrado", OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
			lRetorno := .F.
		endif
	endif

	//Verifica se arquivo foi
	if empty(cArqSaida)
		MsgAlert("Arquivo de saída não preenchido", OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
		lRetorno := .F.
	endif
return lRetorno

/*{Protheus.doc} fecharWord
Encerra o Link com o Documento
@param [ oWord ], objeto, documento word
@param [ cArqWord ], texto, arquivo word
@type function
@author BrunoNunes
@since 18/05/2018
@version P12 1.12.17
@return null, Nulo
*/
static function fecharWord(oWord, cArqWord, cAux, lEncerra)
	default oWord 	 := nil
	default cArqWord := ""
	default cAux 	 := ""
	default lEncerra := .F.


	if lEncerra
		OLE_CloseLink( oWord )  //Fecha conexão com Word
	else
		execInClient( OLECLOSEFILE, { oWord } ) //Fecha documento aberto
	endif
	if Len(cAux) > 0
		fErase(cArqWord)
	endif

return

/*{Protheus.doc} QuerySRA
Monta Query SQL com base nos parametros SX1
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
*/
Static Function QuerySRA(nOrdem, cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCCAte, cNomeDe, cNomeAte, cTnoDe, cTnoAte, cFunDe, cFunAte, cSindDe, cSindAte, dAdmiDe, dAdmiAte, cSituacao, cCategoria, lCrtFlow)
	local cQuery 	:= ''
	local cSitQry   := ''
	local cCatQry   := ''

	default nOrdem	  	:= 1
	default cFilDe		:= replicate(' ',TamSx3("RA_FILIAL")[1])
	default cFilAte		:= replicate('Z',TamSx3("RA_FILIAL")[1])
	default cMatDe		:= replicate(' ',TamSx3("RA_MAT")[1])
	default cMatAte 	:= replicate('Z',TamSx3("RA_MAT")[1])
	default cCcDe		:= replicate(' ',TamSx3("RA_CC")[1])
	default cCCAte		:= replicate('Z',TamSx3("RA_CC")[1])
	default cNomeDe		:= replicate(' ',TamSx3("RA_NOME")[1])
	default cNomeAte	:= replicate('Z',TamSx3("RA_NOME")[1])
	default cTnoDe		:= replicate(' ',TamSx3("RA_TNOTRAB")[1])
	default cTnoAte		:= replicate('Z',TamSx3("RA_TNOTRAB")[1])
	default cFunDe		:= replicate(' ',TamSx3("RA_CODFUNC")[1])
	default cFunAte		:= replicate('Z',TamSx3("RA_CODFUNC")[1])
	default cSindDe		:= replicate(' ',TamSx3("RA_SINDICA")[1])
	default cSindAte	:= replicate('Z',TamSx3("RA_SINDICA")[1])
	default dAdmiDe		:= ctod('//')
	default dAdmiAte	:= ctod('//')
	default cSituacao  	:= ' '
	default cCategoria 	:= ' '
	default lCrtFlow    := .F.

	cSitQry := fSitQry(cSituacao)
	cCatQry := fCatQry(cCategoria)

	cQuery := " SELECT "
	cQuery += "   RA_FILIAL "
	cQuery += " , RA_MAT "
	cQuery += " , RA_CC "
	cQuery += " , RA_NOME "
	cQuery += " , RA_TNOTRAB "
	cQuery += " , RA_CODFUNC "
	cQuery += " , RA_SINDICA "
	cQuery += " , RA_TNOTRAB "
	cQuery += " , RA_ADMISSA "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("SRA")+" SRA "
	cQuery += " WHERE "
	cQuery += " 	RA_FILIAL  BETWEEN '"+cFilDe+"'  AND '"+cFilAte+"' "
	cQuery += " AND RA_MAT     BETWEEN '"+cMatDe+"'  AND '"+cMatAte+"' "
	cQuery += " AND RA_CC      BETWEEN '"+cCcDe+"'   AND '"+cCCAte+"' "
	cQuery += " AND RA_NOME    BETWEEN '"+cNomeDe+"' AND '"+cNomeAte+"' "
	cQuery += " AND RA_TNOTRAB BETWEEN '"+cTnoDe+"'  AND '"+cTnoAte+"' "
	cQuery += " AND RA_CODFUNC BETWEEN '"+cFunDe+"'  AND '"+cFunAte+"' "
	cQuery += " AND RA_SINDICA BETWEEN '"+cSindDe+"' AND '"+cSindAte+"' "
	cQuery += " AND RA_ADMISSA BETWEEN '"+dtos(dAdmiDe)+"' AND '"+dtos(dAdmiAte)+"' "
	cQuery += " AND RA_SITFOLH  IN ("+cSitQry+") "
	cQuery += " AND RA_CATFUNC  IN ("+cCatQry+") "

	if lCrtFlow
    	cQuery += " AND RA_REGRA <> '99'  "              //-> Regra 99 = Não marca ponto.
	    cQuery += " AND RA_CATEFD NOT IN('103','901') "  //-> 103 = Menor Aprendiz / 901 = Estagiario, conforme EFD (eSocial).
	endif

	//Posicionando no Primeiro Registro do Parametro
	if nOrdem == 1	   							//Matricula
		cQuery += " ORDER BY "
		cQuery += " RA_FILIAL, RA_MAT "
	elseif nOrdem == 2							//Centro de Custo
		cQuery += " ORDER BY "
		cQuery += " RA_FILIAL, RA_CC, RA_MAT "
	elseif nOrdem == 3							//Nome
		cQuery += " ORDER BY "
		cQuery += " RA_FILIAL, RA_NOME, RA_MAT "
	elseif nOrdem == 4							//Turno
		cQuery += " ORDER BY "
		cQuery += " RA_FILIAL, RA_TNOTRAB "
	elseif nOrdem == 5							//Admissao
		cQuery += " ORDER BY "
		cQuery += " RA_FILIAL, RA_ADMISSA "
	endif

Return cQuery

/*{Protheus.doc} fSitQry
monta condição em SQL da situação do funcionário
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
*/
Static Function fSitQry( cSituacao )
	local cSitQry 	:= ''
	local i			:= 0
	local cAux		:= ''

	default cSituacao := ''

	for i := 1 to len(cSituacao)
		cAux := substr( cSituacao, i, 1 )
		if cAux != '*'
			if !empty(cSitQry)
				cSitQry += ","
			endif
			cSitQry += "'"+cAux+"'"
		endif
	next i
Return cSitQry

/*{Protheus.doc} fCatQry
monta condição em SQL da situação do funcionário
@type function
@author BrunoNunes
@since 28/05/2018
@version P12 1.12.17
@return null, Nulo
*/
Static Function fCatQry( cCategoria )
	local cCatQry :=  ''
	local i		  := 0
	local cAux		:= ''

	default cCategoria := ''

	for i := 1 to len( cCategoria )
		cAux := substr( cCategoria, i, 1 )
		if cAux != '*'
			if !empty(cCatQry)
				cCatQry += ","
			endif
			cCatQry += "'"+cAux+"'"
		endif
	next i
Return cCatQry