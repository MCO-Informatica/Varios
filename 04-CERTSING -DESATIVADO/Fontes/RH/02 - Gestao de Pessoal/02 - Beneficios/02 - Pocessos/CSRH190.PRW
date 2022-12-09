//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Constantes
#Define cTABELA_GENERICA 		'U00A'
#Define cPERG_BAIXADO	 		'BHBAIXADO'
#Define cPERG_BAIXADO_SIMULA	'BHSIMULA'
#Define cPERG_BAIXADO_EFETUA	'BHEFETUA'
#Define cCAMINHO_SIMULA			'c:\temp\simula_##.xml'
#Define cCAMINHO_EFETUA			'c:\temp\efetua_##.xml'
#Define cABA_SIMULACAO			'Simulação'
#Define cABA_EFETIVACAO			'Efetivado'
#Define cSEMANA					'01'
#Define nPARCELA				1
#Define cTIPO_1					'H'
#Define cTIPO_2					'G'
#Define cSTATUS_BAIXA			'B'
#Define cSELECIONADO			'1'
#Define lFECHAMENTO				.T.
//Variáveis Estáticas
Static cTitulo := "Fechamento do banco de horas PLT-RCH-0008"


/*/{Protheus.doc} CSRH190
Rotina do fechamento de banco horas visando a política PLT-RCH-0008
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return Nil, Função não tem retorno
@example
u_CSRH190()
@obs Não se pode executar função MVC dentro do fórmulas
/*/
User Function CSRH190()
    Local aArea   := GetArea()
    Local oBrowse

    if u_VldU00A(lFECHAMENTO)
	    //Instânciando FWMBrowse - Somente com dicionário de dados
	    oBrowse := FWMBrowse():New()

	    //Setando a tabela de cadastro de Autor/Interprete
	    oBrowse:SetAlias("SRA")

	    //Setando a descrição da rotina
	    oBrowse:SetDescription(cTitulo)

	    //Desabilita detalhes
	    oBrowse:DisableDetails()

	    //Ativa a Browse
	    oBrowse:Activate()

	    RestArea(aArea)
	endif
Return Nil

/*/{Protheus.doc} MenuDef
Lista do menu, podendo visualizar, simular o cálculo e emitir relatório.
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return lista, Lista do menu
@obs Não foi implentando a opção incluir, alterar e excluir, pois se trata de simulação dos dados,
	 mais parecido com um calculo do que com um cadastro
/*/
Static Function MenuDef()
    Local aRot := {}

    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSRH190' 	OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Simular'    ACTION 'u_CSRH191()' 		OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Relatório'  ACTION 'u_CSRH192()' 		OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 8
    ADD OPTION aRot TITLE 'Efetivar'   ACTION 'u_CSRH193()' 		OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 8
    //ADD OPTION aRot TITLE 'Histórico'   ACTION 'u_CSRH160()' 	OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 8

Return aRot

/*/{Protheus.doc} ModelDef
Modelo MVC
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return objeto, Objeto modelo
/*/
Static Function ModelDef()
    Local oModel    := Nil
    Local oStPai    := FWFormStruct(1, 'SRA')
    Local oStFilho  := FWFormStruct(1, 'PBF')
    Local aRel      := {}

    //Monta Gatilho de nome do aprovador no grid
	//aGatilho := FwStruTrigger( 'PBF_APROV' , 'PBF_APRNOM' , 'RD0->RD0_NOME' , .T. , 'RD0' , 1 , 'xFilial("RD0")+M->PBF_APROV' )
	//oStFilho:AddTrigger( aGatilho[1] , aGatilho[2] , aGatilho[3] ,aGatilho[4] )

    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('CSRH190M', , /*{|| validGrupo(oModel)}*/   )
    oModel:AddFields('SRAMASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('PBFDETAIL','SRAMASTER',oStFilho, /*{ |oModelGrid| ValidLin(oModelGrid) }*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence

    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aRel, {'PBF_FILIAL', 'RA_FILIAL'} )
    aAdd(aRel, {'PBF_MAT'	, 'RA_MAT'})

    oModel:SetRelation('PBFDETAIL', aRel, PBF->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('PBFDETAIL'):SetUniqueLine({ 'PBF_BAIXA', 'PBF_EVENTO' })  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    //Setando as descrições
    oModel:SetDescription("Fechamento do banco de horas")
    oModel:GetModel('SRAMASTER'):SetDescription('Colaborador')
    oModel:GetModel('PBFDETAIL'):SetDescription('Eventos de fechamento do banco de horas')
Return oModel

/*/{Protheus.doc} ModelDef
View MVC
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return objeto, Objeto view
/*/
Static Function ViewDef()
    Local oView     := Nil
    Local oModel    := FWLoadModel('CSRH190')
    Local oStPai    := FWFormStruct(2, 'SRA')
    Local oStFilho  := FWFormStruct(2, 'PBF')

    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)

	//Retira campo de relacionamento da tela
    oStFilho:RemoveField( 'PBF_FILIAL' )
    oStFilho:RemoveField( 'PBF_MAT' )
    oStFilho:RemoveField( 'PBF_NOME' )
    oStFilho:RemoveField( 'PBF_CC' )
    oStFilho:RemoveField( 'PBF_CCDESC' )

    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField( 'VIEW_SRA' , oStPai   , 'SRAMASTER' )
    oView:AddGrid(  'VIEW_PBF' , oStFilho , 'PBFDETAIL' )

    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox( 'CABEC', 50 )
    oView:CreateHorizontalBox( 'GRID' , 50 )

    //Amarrando a view com as box
    oView:SetOwnerView( 'VIEW_SRA' , 'CABEC' )
    oView:SetOwnerView( 'VIEW_PBF' , 'GRID' )

    //Habilitando título
    oView:EnableTitleView( 'VIEW_SRA' , 'Colaboradores' )
    oView:EnableTitleView( 'VIEW_PBF' , 'Fechamento Banco de Horas' )
Return oView

/*/{Protheus.doc} RET190PE
Função utilizada no inicializador padrão do campo PB7_PERDES
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return texto, Retorna descrição com periodo do fechamento
/*/
User Function RET190PE()
	local cRetorno := '' //retorno do inicializador padrão PB7_PERDES

	//RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUENbruno
	cRetorno := posicione( "RCC", 1, xFilial('RCC') + cTABELA_GENERICA + space( 8 ) + PBF->PBF_FECHAM, "RCC_CONTEU" )
	cRetorno := dtoc( stod( subStr( cRetorno, 3, 8) ) ) + ' as ' + dtoc( stod( subStr( cRetorno, 11, 8) ) )
Return cRetorno

/*/{Protheus.doc} RET191PE
Função utilizada na consulta padrão RCC_0A
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return texto, Retorna descrição com periodo do fechamento
/*/
User Function RET191PE()
	local cRetorno := '' //retorno do inicializador padrão PB7_PERDES

	cRetorno := POSICIONE("SX5",1,XFILIAL("SX5")+'Z6'+subStr( RCC->RCC_CONTEU, 1, 2 ),"X5_DESCRI")
Return cRetorno

/*/{Protheus.doc} RET192PE
Função utilizada no inicializador padrão do campo PB7_PERDES
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return texto, Retorna descrição com periodo do fechamento
/*/
User Function RET192PE()
	local cRetorno := '' //retorno do inicializador padrão PB7_PERDES

	//RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
	cRetorno := posicione( "RCC", 1, xFilial('RCC') + cTABELA_GENERICA + space( 8 ) + SPI->PI_FECHAM, "RCC_CONTEU" )
	cRetorno := dtoc( stod( subStr( cRetorno, 3, 8) ) ) + ' as ' + dtoc( stod( subStr( cRetorno, 11, 8) ) )
Return cRetorno

/*/{Protheus.doc} RET193PE
Função utilizada no inicializador padrão do campo PB7_PERDES
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return texto, Retorna descrição com periodo do fechamento
/*/
User Function RET193PE()
	local cRetorno := '' //retorno do inicializador padrão PB7_PERDES

	//RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUENbruno
	cRetorno := posicione( "RCC", 1, xFilial('RCC') + cTABELA_GENERICA + space( 8 ) + PBG->PBG_FECHAM, "RCC_CONTEU" )
	cRetorno := dtoc( stod( subStr( cRetorno, 3, 8) ) ) + ' as ' + dtoc( stod( subStr( cRetorno, 11, 8) ) )
Return cRetorno


/*/{Protheus.doc} CSRH191
Simula fechamento do banco de horas e grava calcula na tabela PBF
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return null, Sem retorno
/*/
User Function CSRH191()
	AjustaSx1( cPERG_BAIXADO_SIMULA ) 		//Criar pergunte caso não exista no SX1
	if pergunte( cPERG_BAIXADO_SIMULA, .T.) 	//Exibe para o usuário tela de parâmetros
		Processa( {|| Proc191() }, "Aguarde...", "Simulando Fechamento do Banco de horas",.F.) //Inicia processamentos do extrato de banco de horas
	endif
Return

/*/{Protheus.doc} Proc191
Cria Pergunte BHEXTRATO caso não exista
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 12/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Proc191()
	local aParam := {}
	local aLista := {}
	local i	:= 0
	local j	:= 0
	local cRCC_Conte := ''
	local dDataDe 	 :=	ctod('//')
	local dDataAte   :=	ctod('//')
	local cRegra	 := ''
	local aAux := {}
	local cErro 	 := ''
	local cSeq		 := ''
	local nValor	 := 0

	cSeq := MV_PAR07
	cRCC_Conte := posicione( "RCC", 1, xFilial('RCC') + cTABELA_GENERICA + space( 8 ) + cSeq, "RCC_CONTEU" )
	if !empty(cRCC_Conte)
		cRegra	 := substr( cRCC_Conte, 01, 02 )
		dDataDe  := stod( substr( cRCC_Conte, 03, 08 ) )
		dDataAte := stod( substr( cRCC_Conte, 11, 08 ) )
	else
		cErro := 'Periodo de fechamento de banco de horas'
	endif

	if empty( cErro )

		aAdd( aParam, MV_PAR01 ) //1
		aAdd( aParam, MV_PAR02 ) //2
		aAdd( aParam, MV_PAR03 ) //3
		aAdd( aParam, MV_PAR04 ) //4
		aAdd( aParam, MV_PAR05 ) //5
		aAdd( aParam, MV_PAR06 ) //6
		aAdd( aParam, dDataDe  ) //7
		aAdd( aParam, dDataAte ) //8

		aLista := u_CSRH132( aParam )
		ProcRegua( len(aLista ) )
		PBF->( dbSetOrder( 1 ) )
		for i := 1 to len(aLista )
			IncProc()	//Incrementa a barra de progressão
			for j := 1 to len(aLista[i] )
				aAux := aLista[i][j]
				if !empty(aAux[9])
					nValor := abs( val( replace( aAux[8], ":", "." ) ) )
					//PBF_FILIAL+PBF_MAT+PBF_EVENTO+DTOS(PBF_BAIXA)
					if PBF->( dbSeek(aAux[1]+aAux[4]+aAux[6]+dtos(dDataAte) ) )
						Reclock( "PBF" , .F. )
						PBF->PBF_CC 	:= aAux[2]
						PBF->PBF_HORAEV := nValor
						PBF->PBF_BAIXA  := dDataAte
						PBF->PBF_POLITC  := cRegra
						PBF->PBF_FECHAM := cSeq
						PBF->PBF_PD		:= aAux[9]
						PBF->(MsUnlock())
					else
						Reclock( "PBF" , .T. )
						PBF->PBF_FILIAL := aAux[1]
						PBF->PBF_MAT    := aAux[4]
						PBF->PBF_CC 	:= aAux[2]
						PBF->PBF_EVENTO := aAux[6]
						PBF->PBF_HORAEV := nValor
						PBF->PBF_BAIXA  := dDataAte
						PBF->PBF_POLITC  := cRegra
						PBF->PBF_FECHAM := cSeq
						PBF->PBF_PD		:= aAux[9]
						PBF->(MsUnlock())
					endif
				endif
			next j
		next i

		msgInfo('Simulação finalizada', 'Concluído')
	else
		alert( cErro )
	endif
Return

/*/{Protheus.doc} AjustaSx1
Cria Pergunte BHSIMULA caso não exista
@type function
@author BrunoNunes
@since 12/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function AjustaSx1( cPerg )
	if cPerg == cPERG_BAIXADO_SIMULA
		xPutSx1( cPERG_BAIXADO_SIMULA, "01", "Filial De?"		   	, "Filial De?"		   	, "Filial De?"						,"mv_ch1" , "C",02,0,0,"G",""					,"SM0"		,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "02", "Filial Até?"		   	, "Filial Até?"		   	, "Filial Até?"						,"mv_ch2" , "C",02,0,0,"G",""					,"SM0"		,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "03", "Centro de Custo De?"	, "Centro de Custo De?" , "Centro de Custo Ate?"			,"mv_ch3" , "C",09,0,0,"G",""					,"CTT"		,"","","mv_par03","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "04", "Centro de Custo De?"	, "Centro de Custo Ate?", "Centro de Custo Ate?"			,"mv_ch4" , "C",09,0,0,"G",""					,"CTT"		,"","","mv_par04","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "05", "Matricula De?"	   	, "Matricula De?"		, "Matricula De?"					,"mv_ch5" , "C",06,0,0,"G",""					,"SRA"		,"","","mv_par05","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "06", "Matricula Até?"	   	, "Matricula Até?"		, "Matricula Até?"					,"mv_ch6" , "C",06,0,0,"G",""					,"SRA"		,"","","mv_par06","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_SIMULA, "07", "Fechamento?" 	   		, "Fechamento?"			, "Fechamento?"						,"mv_ch7" , "C",03,0,0,"G",""					,"RCC_0A"	,"","","mv_par07","","","","","","","","","","","","","","","","",,,)
	else
		xPutSx1( cPERG_BAIXADO_EFETUA, "01", "Filial?"		   		, "Filial?"		   		, "Filial?"							,"mv_ch1" , "C",02,0,0,"G",""					,"SM0"		,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_EFETUA, "02", "Centro de Custo De?"	, "Centro de Custo De?" , "Centro de Custo Ate?"			,"mv_ch2" , "C",09,0,0,"G",""					,"CTT"		,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_EFETUA, "03", "Centro de Custo De?"	, "Centro de Custo Ate?", "Centro de Custo Ate?"			,"mv_ch3" , "C",09,0,0,"G",""					,"CTT"		,"","","mv_par03","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_EFETUA, "04", "Matricula De?"	   	, "Matricula De?"		, "Matricula De?"					,"mv_ch4" , "C",06,0,0,"G",""					,"SRA"		,"","","mv_par04","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_EFETUA, "05", "Matricula Até?"	   	, "Matricula Até?"		, "Matricula Até?"					,"mv_ch5" , "C",06,0,0,"G",""					,"SRA"		,"","","mv_par05","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO_EFETUA, "06", "Fechamento?" 	   		, "Fechamento?"			, "Fechamento?"						,"mv_ch6" , "C",03,0,0,"G",""					,"RCC_0A"	,"","","mv_par06","","","","","","","","","","","","","","","","",,,)
	endif
Return

/*/{Protheus.doc} xPutSx1
Função de criada para substituir o PutSX1, pois não esta funcionando na P12.
@param [ cGrupo   ], texto	 , Código chave de identificação da pergunta. Através deste código as perguntas são agrupadas em um conjunto
@param [ cOrdem   ], texto	 , Ordem de apresentação das perguntas. A ordem é importante para a criação das variáveis de escopo PRIVATE MV_PAR??
@param [ cPergunt ], texto	 , Rótulo com a descrição da pergunta no idioma Português
@param [ cPerSpa  ], texto	 , Rótulo com a descrição da pergunta no idioma Espanhol
@param [ cPerEng  ], texto	 , Rótulo com a descrição da pergunta no idioma Inglês
@param [ cVar     ], texto	 , *** Não usado ***
@param [ cTipo 	  ], texto	 , Tipo de dado da pergunta, onde temos: C – Caracter; L- Lógico; D-Data; N-Numérico; M-Memo
@param [ nTamanho ], numerico, Tamanho do Campo
@param [ nDecimal ], numerico, Quantidade de casas decimais, se o tipo for numérico
@param [ nPresel  ], numerico, Quando temos uma Pergunta tipo Combo, podemos deixar o valor padrão selecionado neste campo, deve ser informado qual o número da opção selecionada.
@param [ cGSC     ], texto	 , Tipo de objeto a ser criado para essa pergunta, valores aceitos são:(G) Edit,(S)Text,(C) Combo,(R) Range,File,Expression ou (K)=Check. Caso campo esteja em branco é tratado como Edit. Objetos do tipo combo podem ter no máximo 5 itens
@param [ cValid   ], texto	 , Validação da Pergunta. A função deverá ser Function(para GDPs) ou User Function (Cliente) , Static Function não podem ser utilizadas.
@param [ cF3      ], texto	 , LookUp associado a pergunta
@param [ cGrpSxg  ], texto	 , Código do grupo de campo(SXG) que o campo pertence. Todos os campos que estão associados a um grupo de campo, sofrem as alterações quando alteramos ele.
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
@param [ aHelpPor ], lista	 , Código do HELP para a pergunta.
@param [ aHelpEng ], lista	 , Código do HELP para a pergunta.
@param [ aHelpSpa ], lista	 , Código do HELP para a pergunta.
@param [ cHelp    ], texto	 , Texto do help.

@type function
@author BrunoNunes
@since 12/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
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

	if !( DbSeek( cGrupo + cOrdem ))

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

		if Fieldpos("X1_PYME") > 0
			if cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		if cGSC == "C"               // Mult Escolha
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

		if lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			if lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			Endif
			if lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			Endif
			if lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			Endif
			SX1->(MsUnLock())
		Endif
	Endif

	RestArea( aArea )
Return

User Function CSRH192()
	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

	AjustaSx1(cPERG_BAIXADO_SIMULA) 		//Criar pergunte caso não exista no SX1
	if pergunte(cPERG_BAIXADO_SIMULA, .T.) 	//Exibe para o usuário tela de parâmetros
		Processa( {|| Proc192() }, "Aguarde...", "Relatório Fechamento do Banco de horas",.F.) //Inicia processamentos do extrato de banco de horas
	endif
Return

Static Function Proc192()
	local cAlias := getNextAlias()
	local nRec	 := 0
	local cQuery := ''
	local lExeChange := .T.
	local aLista	:= {}
	local nValor	:= 0
	local lFechament := .F.
	local cArquivo   := ''
	local cDtArquivo := ''
	local cHrArquivo := ''

	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

	cHrArquivo := replace(time(),':','_')
	cDtArquivo := replace(dtoc( date()), '/', '_' )
	cArquivo   := replace( cCAMINHO_SIMULA, '##', cDtArquivo+'_'+cHrArquivo )

	ProcRegua( 0 )

	oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

	//Monta Aba
	//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
	oFWMsExcel:AddworkSheet( cABA_SIMULACAO )

	//Criando a Tabela
	//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oFWMsExcel:AddTable( cABA_SIMULACAO, cABA_SIMULACAO )

	//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Filial"			,1) //01
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Centro de Custo" ,1) //02
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Descrição"		,1) //03
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Matrícula"		,1) //04
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Nome"			,1) //05
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Evento"			,1) //06
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Descrição"		,1) //07
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Horas"			,1) //08
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Baixa"			,1) //09
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Política"		,1) //10
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Período " 		,1) //11
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Cod. Verba"		,1) //12
	oFWMsExcel:AddColumn( cABA_SIMULACAO, cABA_SIMULACAO, "Verba"			,1) //13

	cQuery := QueryRel(lFechament)//Monta consulta SQL para lista banco de horas

	if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange ) 	//Caso a consulta retorno registro faça:
		ProcRegua( nRec )	//Inicia barra de progressão infinita

		While ( cAlias )->( !EOF() ) //Enquanto não for fim de arquivo
			IncProc()	//Incrementa a barra de progressão
			aLista  := {}
			nValor	:= ( cAlias )->PBF_HORAEV
			aAdd( aLista, ( cAlias )->PBF_FILIAL	) //01
			aAdd( aLista, ( cAlias )->PBF_CC        ) //02
			aAdd( aLista, ( cAlias )->CTT_DESC01    ) //03
			aAdd( aLista, ( cAlias )->PBF_MAT       ) //04
			aAdd( aLista, ( cAlias )->RA_NOME       ) //05
			aAdd( aLista, ( cAlias )->PBF_EVENTO    ) //06
			aAdd( aLista, ( cAlias )->P9_DESC       ) //07
			aAdd( aLista, replace(StrZero( nValor, ZeroEsquer(nValor, nValor < 0), 2 ),'.',':') ) //08
			aAdd( aLista, dtoc( stod( ( cAlias )->PBF_BAIXA ) ) ) //09
			aAdd( aLista, ( cAlias )->X5_DESCRI     ) //10
			aAdd( aLista, TextoPer( substr( ( cAlias )->RCC_CONTEU, 3, 16 ) ) ) //11
			aAdd( aLista, ( cAlias )->PBF_PD        ) //12
			aAdd( aLista, ( cAlias )->RV_DESC       ) //13

			oFWMsExcel:AddRow( cABA_SIMULACAO, cABA_SIMULACAO, aLista )
			(cAlias)->(DbSkip())
		EndDo
	endif

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()					//Encerra o processo do gerenciador de tarefas
Return

Static Function QueryRel(lFechament)
	local cQuery := ''

	default lFechament := .F.

	cQuery := " SELECT "
	cQuery += " 	PBF_FILIAL "
	cQuery += " 	,PBF_CC "
	cQuery += " 	,CTT_DESC01 "
	cQuery += " 	,PBF_MAT "
	cQuery += " 	,RA_NOME "
	cQuery += " 	,PBF_EVENTO "
	cQuery += " 	,P9_DESC "
	cQuery += " 	,PBF_HORAEV "
	cQuery += " 	,PBF_BAIXA "
	cQuery += " 	,PBF_POLITC "
	cQuery += " 	,X5_DESCRI "
	cQuery += " 	,PBF_FECHAM "
	cQuery += " 	,RCC_CONTEU "
	cQuery += " 	,RCC_SEQUEN "
	cQuery += " 	,PBF_PD "
	cQuery += " 	,RV_DESC "
	cQuery += "	FROM "
	cQuery += " 	"+RetSqlName("PBF")+" PBF "
	cQuery += " 	LEFT JOIN "+RetSqlName("CTT")+" CTT ON "
	cQuery += " 	CTT.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CTT_CUSTO = PBF_CC "
	cQuery += " LEFT JOIN "+RetSqlName("SRA")+" SRA ON "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RA_FILIAL = PBF_FILIAL "
	cQuery += " 	AND RA_MAT = PBF_MAT "
	cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON "
	cQuery += " 	SP9.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND P9_CODIGO = PBF_EVENTO "
	cQuery += " LEFT JOIN "+RetSqlName("SX5")+" SX5 ON "
	cQuery += " 	SX5.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND X5_FILIAL = PBF_FILIAL "
	cQuery += " 	AND X5_TABELA = 'Z6' "
	cQuery += " 	AND X5_CHAVE = PBF_POLITC "
	cQuery += " LEFT JOIN "+RetSqlName("RCC")+" RCC ON "
	cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RCC_CODIGO = 'U00A' "
	cQuery += " 	AND RCC_SEQUEN = PBF_FECHAM "
	cQuery += " LEFT JOIN "+RetSqlName("SRV")+" SRV ON "
	cQuery += " 	SRV.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RV_COD = PBF_PD "
	cQuery += " WHERE "
	cQuery += " 	PBF.D_E_L_E_T_ = ' ' "
	if lFechament
		cQuery += " 	AND PBF_FILIAL 	= 		'"+MV_PAR01+"'
		cQuery += " 	AND PBF_CC 		BETWEEN	'"+MV_PAR02+"' AND '"+MV_PAR03+"' "
		cQuery += " 	AND PBF_MAT 	BETWEEN	'"+MV_PAR04+"' AND '"+MV_PAR05+"' "
		cQuery += " 	AND PBF_FECHAM 	= 		'"+MV_PAR06+"' "
		cQuery += " ORDER BY PBF_FILIAL, PBF_MAT, RA_NOME, PBF_EVENTO "
	else
		cQuery += " 	AND PBF_FILIAL 	BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += " 	AND PBF_CC 		BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery += " 	AND PBF_MAT 	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		cQuery += " 	AND PBF_FECHAM 	= 		'"+MV_PAR07+"' "
		cQuery += " ORDER BY PBF_FILIAL, PBF_MAT, RA_NOME, PBF_PD, PBF_EVENTO "
	endif
Return cQuery

/*/{Protheus.doc} TextoPer
Ajusta campo de período de banco de horas
@param [ cPeriodo ], texto	, campo de periodo de apuração no formato AAAAMMDDAAAAMMDD
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return texto, cRetorno - Mascará para o campo período de banco de horas 'DD/MM/AAAA as DD/MM/AAAA'
/*/
Static Function TextoPer( cPeriodo )
	local cRetorno := ''	//Periodo formatado

	if !empty(cPeriodo)
		cRetorno := dtoc( stod( left( cPeriodo, 8 ) ) )
		cRetorno += ' as '
		cRetorno += dtoc( stod( right( cPeriodo, 8 ) ) )
	endif
Return cRetorno

/*/{Protheus.doc} ZeroEsquer
Formata o campo hora no formato -HH:MM
@param [ nVal   		] , numerico, Hora a ser analisada
@param [ lTotNegativo 	] , logico	, Verdareiro, adiciona o sinal de negativo no retorno da função
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return númerico, nRetorno - quantidade de espaços para montar mascará -HHH:MM
/*/
Static Function ZeroEsquer( nVal, lTotNegativo )
	local nRetorno := 0	//Quantidade de zero a esquerda
	local nTamanho := len( cValToChar( int( nVal ) ) ) //Quantidade de casas do número inteiro
	local nSinal   := iif( lTotNegativo, 1, 0 )	//Sinal do número

	if nTamanho == 0 .Or. nTamanho == 1 .Or. nTamanho == 2
		nRetorno := 5+nSinal
	else
		nRetorno := nTamanho+3
	endif
Return nRetorno

/*/{Protheus.doc} CSRH193
Efetiva fechamento do banco de horas
@type function
@author BrunoNunes
@since 29/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH193()

	if msgYesNo('Continuar com o fechamento de banco? Após confirmação não será possível reverter fechamento.', 'Fechamento')
		AjustaSx1(cPERG_BAIXADO_EFETUA) 		//Criar pergunte caso não exista no SX1
		if pergunte(cPERG_BAIXADO_EFETUA, .T.) 	//Exibe para o usuário tela de parâmetros
			RCH->(dbSetOrder(1))
			RCH->(dbSeek(MV_PAR01))

			PBF->(dbSetOrder(1))
			PBF->(dbSeek(MV_PAR01))
			Processa( {|| Proc193() }, "Aguarde...", "Fechando Banco de horas",.F.) //Inicia processamentos do extrato de banco de horas
		endif
	endif
Return

/*/{Protheus.doc} Proc193
Rotina de prcossamento da efetivação fechamento do banco de horas
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
@description
28/05/2018 Alterada a rotina para ignorar os eventos que não possuam verba de folha vinculada
/*/
Static Function Proc193()
	local cAlias 	 := getNextAlias()
	local nRec		 := 0
	local cQuery 	 := ''
	local lExeChange := .T.
	local aLista	 := {}
	local nValor	 := 0
	local lFechament := .T.
	local cChaveAnt	 := ''
	local cFuncAnt	 := ''
	local cFilMat 	 := ''
	local cMat    	 := ''
	local cPD  		 := ''
	local cCC   	 := ''
	local cChaveRGB  := ''
	local cChavePBG  := ''
	local cChaveSPI  := ''
	local aPeriodo   := {}
	local dataIni	 := ctod('//')
	local dataFim	 := ctod('//')
	local cPerTab	 := ''
	local cPolitic	 := ''
	local cChavePBF  := ''
	local cArquivo   := ''
	local cDtArquivo := ''
	local cHrArquivo := ''

	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

	cHrArquivo := replace(time(),':','_')
	cDtArquivo := replace(dtoc( date()), '/', '_' )
	cArquivo   := replace( cCAMINHO_EFETUA, '##', cDtArquivo+'_'+cHrArquivo )

	aPeriodo := TelaProc()

	if !empty(aPeriodo)

		ProcRegua( 0 )

		oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

		//Monta Aba
		//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
		oFWMsExcel:AddworkSheet( cABA_EFETIVACAO )

		//Criando a Tabela
		//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
		oFWMsExcel:AddTable( cABA_EFETIVACAO, cABA_EFETIVACAO )

		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Filial"			,1) //01
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Centro de Custo" 	,1) //02
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Descrição"			,1) //03
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Matrícula"			,1) //04
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Nome"				,1) //05
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Evento"			,1) //06
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Descrição"			,1) //07
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Horas"				,1) //08
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Baixa"				,1) //09
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Política"			,1) //10
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Período " 			,1) //11
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Cod. Verba"		,1) //12
		oFWMsExcel:AddColumn( cABA_EFETIVACAO, cABA_EFETIVACAO, "Verba"				,1) //13

		cQuery := QueryRel(lFechament)//Monta consulta SQL para lista banco de horas

		if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange ) 	//Caso a consulta retorno registro faça:
			ProcRegua( nRec )	//Inicia barra de progressão infinita
			cChaveAnt := ( cAlias )->(PBF_FILIAL+PBF_MAT+PBF_PD)
			cFuncAnt  := ( cAlias )->(PBF_FILIAL+PBF_MAT)
			While ( cAlias )->( !EOF() ) //Enquanto não for fim de arquivo
				IncProc()	//Incrementa a barra de progressão

				if cChaveAnt != ( cAlias )->(PBF_FILIAL+PBF_MAT+PBF_PD)
					if nValor > 0 .and. !empty(cPD)
						LancarRGB(  cChaveRGB,  nValor, aPeriodo, cFilMat, cMat, cPD, cCC )
						aLista[8] := replace(StrZero( nValor, ZeroEsquer(nValor, nValor < 0), 2 ),'.',':')
						oFWMsExcel:AddRow( cABA_EFETIVACAO, cABA_EFETIVACAO, aLista)
					endif
					nValor	:= 0
				endif

				if cFuncAnt  != ( cAlias )->(PBF_FILIAL+PBF_MAT)
					BaixarSPI(  cChaveSPI,  aPeriodo, dataIni, dataFim, cPerTab, cPolitic )
					Acumular( cChavePBG )
				endif

				nValor		:= __TimeSum( nValor, ( cAlias )->PBF_HORAEV )
				dataIni 	:= stod( subStr( ( cAlias )->RCC_CONTEU, 03, 8) )
				dataFim 	:= stod( subStr( ( cAlias )->RCC_CONTEU, 11, 8) )
				cPerTab		:= ( cAlias )->RCC_SEQUEN
				cPolitic	:= substr( ( cAlias )->RCC_CONTEU, 1, 2 )
				cFilMat 	:= ( cAlias )->PBF_FILIAL
				cMat    	:= ( cAlias )->PBF_MAT
				cPD  		:= ( cAlias )->PBF_PD
				cCC   		:= ( cAlias )->PBF_CC
				cChaveRGB 	:= ( cAlias )->( PBF_FILIAL+PBF_MAT+PBF_PD+aPeriodo[3]+cSEMANA )

				cChavePBG 	:= ( cAlias )->( PBF_FILIAL+PBF_MAT ) //PBG_FILIAL+PBG_MAT
				cChaveSPI 	:= ( cAlias )->( PBF_FILIAL+PBF_MAT )
				cChavePBF 	:= ( cAlias )->( PBF_FILIAL+PBF_MAT+PBF_EVENTO+PBF_BAIXA )

				aLista  := {}
				aAdd( aLista, ( cAlias )->PBF_FILIAL	) //01
				aAdd( aLista, ( cAlias )->PBF_CC        ) //02
				aAdd( aLista, ( cAlias )->CTT_DESC01    ) //03
				aAdd( aLista, ( cAlias )->PBF_MAT       ) //04
				aAdd( aLista, ( cAlias )->RA_NOME       ) //05
				aAdd( aLista, ( cAlias )->PBF_EVENTO    ) //06
				aAdd( aLista, ( cAlias )->P9_DESC       ) //07
				aAdd( aLista, '' ) //08
				aAdd( aLista, dtoc( stod( ( cAlias )->PBF_BAIXA ) ) ) //09
				aAdd( aLista, ( cAlias )->X5_DESCRI     ) //10
				aAdd( aLista, TextoPer( substr( ( cAlias )->RCC_CONTEU, 3, 16 ) ) ) //11
				aAdd( aLista, ( cAlias )->PBF_PD        ) //12
				aAdd( aLista, ( cAlias )->RV_DESC       ) //13
				cChaveAnt := ( cAlias )->(PBF_FILIAL+PBF_MAT+PBF_PD)
				cFuncAnt  := ( cAlias )->(PBF_FILIAL+PBF_MAT)

				(cAlias)->(DbSkip())
			EndDo
		endif

		if nValor > 0 .and. !empty(cPD)
			BEGIN TRANSACTION
				LancarRGB(  cChaveRGB,  nValor, aPeriodo, cFilMat, cMat, cPD, cCC )
				Acumular( cChavePBG )
				BaixarSPI(  cChaveSPI,  aPeriodo, dataIni, dataFim, cPerTab, cPolitic )
			END TRANSACTION
			aLista[8] := replace(StrZero( nValor, ZeroEsquer(nValor, nValor < 0), 2 ),'.',':')
			oFWMsExcel:AddRow( cABA_EFETIVACAO, cABA_EFETIVACAO, aLista)
		endif

		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
		oExcel:SetVisible(.T.) 				//Visualiza a planilha
		oExcel:Destroy()					//Encerra o processo do gerenciador de tarefas

	endif
Return

/*/{Protheus.doc} LancarRGB
Faz lançamento para folha na tabela RGB
@type function
@author BrunoNunes
@since 29/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function LancarRGB( cChaveRGB, nValor, aPeriodo, cFilMat, cMat, cPD, cCC )
	local cChave := ''

	default cChaveRGB := ''
	default nValor := ''
	default aPeriodo := {}
	default cFilMat := ''
	default cMat := ''
	default cPD := ''
	default cCC := ''

	if !empty( cChaveRGB ) .and. nValor > 0 .and. !empty( aPeriodo )
		cChave := cChaveRGB

		//RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ+RGB_CONVOC
		RGB->( dbSetOrder( 1 ) )
		if RGB->( dbSeek( cChave ) )
			Reclock( "RGB" , .F. )
		else
			Reclock( "RGB" , .T. )
			RGB->RGB_FILIAL	:= cFilMat
			RGB->RGB_MAT    := cMat
			RGB->RGB_PD		:= cPD
		endif
		RGB->RGB_CC		:= cCC
		RGB->RGB_PROCES	:= aPeriodo[1]
		RGB->RGB_ROTORI	:= aPeriodo[2]
		RGB->RGB_ROTEIR	:= aPeriodo[2]
		RGB->RGB_PERIOD	:= aPeriodo[3]
		RGB->RGB_TIPO1	:= cTIPO_1

		//Alterado 28/11/2018 no dia do fechamento - Problema com auditoria. Bruno Nunes
		//Grava na folha em centesimal
		RGB->RGB_HORAS	+= NoRound( (__Hrs2Min(nValor) / 60),2 )

		RGB->RGB_PARCEL	:= nPARCELA
		RGB->RGB_SEMANA := cSEMANA
		RGB->RGB_TIPO2	:= cTIPO_2
		RGB->(MsUnlock())
	endif
Return

/*/{Protheus.doc} Acumular
Faz lançamento para tabela de acumulados na tabela PBG
@type function
@author BrunoNunes
@since 29/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Acumular( cChave )
	default cChave := ''

	if !empty( cChave )

		//PBG_FILIAL+PBG_MAT+PBG_EVENTO+DTOS(PBG_BAIXA)
		PBG->( dbSetOrder( 1 ) )
		PBF->( dbSetOrder( 1 ) )
		if PBF->( dbSeek( cChave ) )
			while PBF->(!EoF()) .and. PBF->(PBF_FILIAL+PBF_MAT) == cChave
				if PBG->( dbSeek( PBF->( PBF_FILIAL+PBF_MAT+PBF_EVENTO+DTOS(PBF_BAIXA) ) ) )
					Reclock( "PBG" , .F. )
				else
					Reclock( "PBG" , .T. )
					PBG->PBG_FILIAL	:= PBF->PBF_FILIAL
					PBG->PBG_MAT    := PBF->PBF_MAT
					PBG->PBG_EVENTO	:= PBF->PBF_EVENTO
					PBG->PBG_BAIXA	:= PBF->PBF_BAIXA
				endif
				PBG->PBG_CC 	:= PBF->PBF_CC
				PBG->PBG_HORAEV := PBF->PBF_HORAEV
				PBG->PBG_FECHAM := PBF->PBF_FECHAM
				PBG->PBG_POLITC := PBF->PBF_POLITC
				PBG->PBG_PD 	:= PBF->PBF_PD
				PBG->(MsUnlock())

				Reclock( "PBF" , .F. )
				PBF->( dbDelete() )
				PBF->(dbSkip())
			end
		endif
	endif
Return

/*/{Protheus.doc} BaixarSPI
Faz baixa do banco de horas
@type function
@author BrunoNunes
@since 29/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function BaixarSPI(  cChave,  aPeriodo, dataIni, dataFim, cPerTab, cPolitic )
	default cChave := ''
	default aPeriodo := {}
	default dataIni := ctod('//')
	default dataFim := ctod('//')
	default cPerTab := ''
	default cPolitic := ''

	if !empty( cChave ) .and. !empty( aPeriodo )
		SPI->( dbSetOrder( 2 ) ) //PI_FILIAL+PI_MAT+Dtos(PI_DATA)+PI_PD
		if SPI->( dbSeek( cChave ) )
			while SPI->(!EoF()) .and. cChave == SPI->( PI_FILIAL+PI_MAT )
			  	if SPI->PI_DATA >= dataIni .and. SPI->PI_DATA <= dataFim .and. SPI->PI_STATUS != cSTATUS_BAIXA
					Reclock( "SPI" , .F. )
					SPI->PI_STATUS	:= cSTATUS_BAIXA
					SPI->PI_DTBAIX	:= dataFim
					SPI->PI_PROCES	:= aPeriodo[1]
					SPI->PI_ROTEIR	:= aPeriodo[2]
					SPI->PI_PERIODO	:= aPeriodo[3]
					SPI->PI_PERIOD	:= cPerTab
					SPI->PI_POLITIC	:= cPolitic
					SPI->(MsUnlock())
				endif
				SPI->(dbSkip())
			end
		endif
	endif
Return

/*/{Protheus.doc} TelaProc
Tela para seleciona o periodo da folha
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function TelaProc()
	local lHasButton := .T.
	local aRetorno := {}
	local oTFont := TFont():New('Tahoma',,24,.T.)

	local cStyle1 := "QFrame{ border-style:solid; border-width:1px; border-color:#d0d4d7;background-color:#E8ECEF }"
  	local cStyle2 := "QFrame{ background-color:#FFF }"
  	local oSay := nil

	local oDlg := TDialog():New(180,180,350,800,'Processo',,,,,,,,,.T.)
 	local oTButton1 := nil
 	local oTButton2 := nil
 	local oTButton3 := nil
 	local oGet1 := nil
 	local oGet2 := nil
 	local oGet3 := nil
 	local cGet1 := space(5) // Variavel do tipo caracter
 	local cGet2 := space(3) // Variavel do tipo caracter
 	local cGet3 := space(8) // Variavel do tipo caracter
 	local lCancelar := .F.
 	local lTudoOk := .F.

	oPanel := TPanelCss():New(20,20,nil,oDlg,nil,nil,nil,nil,nil,020,020,nil,nil)
	oPane2 := TPanelCss():New(20,20,nil,oDlg,nil,nil,nil,nil,nil,020,020,nil,nil)
	oPane3 := TPanelCss():New(20,20,nil,oDlg,nil,nil,nil,nil,nil,025,025,nil,nil)
	oPane4 := TPanelCss():New(20,20,nil,oPane3,nil,nil,nil,nil,nil,015,015,nil,nil)

	oPanel:setCSS( cStyle1 )
	oPane2:setCSS( cStyle2 )
	oPane3:setCSS( cStyle2 )

	oSay:= TSay():New(005,010,{||'Processo para fechamento'},oPanel,,oTFont,,,,.T.,,,300,20)
	oSay:Align := CONTROL_ALIGN_ALLCLIENT

   	oPanel:Align := CONTROL_ALIGN_TOP
   	oPane2:Align := CONTROL_ALIGN_ALLCLIENT
   	oPane3:Align := CONTROL_ALIGN_BOTTOM
   	oPane4:Align := CONTROL_ALIGN_ALLCLIENT

	//TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ], [ lPicturePriority ], [ lFocSel ] )
 	oGet1 := TGet():New( 005, 010, { | | cGet1  },oPane2, 050, 010, "!@",/*[ bValid ]*/,/*[ nClrFore ]*/ ,/*[ nClrBack ]*/ ,/*[ oFont ]*/,.F.,/* [ uParam13 ] */,.T.,/*[ uParam15 ]*/,.F.,{||.F.},.F.,.F.,/*[ bChange ]*/,.F.,.F. ,/*[ uParam23 ]*/,"cGet1",/*[ uParam25 ]*/,/*[ uParam26 ]*/,/*[ uParam27 ]*/,lHasButton,/* [ lNoButton ]*/,/*[ uParam30 ]*/, "Processo"	, 1 )
 	oGet2 := TGet():New( 005, 070, { | | cGet2  },oPane2, 030, 010, "!@",/*[ bValid ]*/,/*[ nClrFore ]*/ ,/*[ nClrBack ]*/ ,/*[ oFont ]*/,.F.,/* [ uParam13 ] */,.T.,/*[ uParam15 ]*/,.F.,{||.F.},.F.,.F.,/*[ bChange ]*/,.F.,.F. ,/*[ uParam23 ]*/,"cGet2",/*[ uParam25 ]*/,/*[ uParam26 ]*/,/*[ uParam27 ]*/,lHasButton,/* [ lNoButton ]*/,/*[ uParam30 ]*/, "Roteiro"  	, 1 )
 	oGet3 := TGet():New( 005, 110, { | | cGet3  },oPane2, 040, 010, "!@",/*[ bValid ]*/,/*[ nClrFore ]*/ ,/*[ nClrBack ]*/ ,/*[ oFont ]*/,.F.,/* [ uParam13 ] */,.T.,/*[ uParam15 ]*/,.F.,{||.F.},.F.,.F.,/*[ bChange ]*/,.F.,.F. ,/*[ uParam23 ]*/,"cGet3",/*[ uParam25 ]*/,/*[ uParam26 ]*/,/*[ uParam27 ]*/,lHasButton,/* [ lNoButton ]*/,/*[ uParam30 ]*/, "Período"  	, 1 )

 	oTButton1 := TButton():New( 005, 230, "Cancelar" 			,oPane4,{|| lTudoOk   := .F., iif( lCancelar := Cancelar()			  	, oDlg:End(), .F.) }, 080,015,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 005, 147, "Confirmar"			,oPane4,{|| lCancelar := .F., iif( lTudoOk 	 := TudOk(@aRetorno, cGet1) , oDlg:End(), .F.) }, 080,015,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3 := TButton():New( 005, 010, "Selecionar Período"	,oPane4,{|| SelPer(@cGet1, @cGet2, @cGet3) }, 080,015,,,.F.,.T.,.F.,,.F.,,,.F. )

	//Ativa diálogo centralizado
	oDlg:Activate(,,,.T.,{|| Fechar(lCancelar, lTudoOk) },,{||} )

Return aRetorno

/*/{Protheus.doc} TudOk
Validação do botão Ok da tela TelaProc()
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function TudOk(aRetorno, cGet1)
	local lRetorno := .F.

	default aRetorno := {}

	if !empty(cGet1)
		aAdd(aRetorno, RCH->RCH_PROCES)
		aAdd(aRetorno, RCH->RCH_ROTEIR)
		aAdd(aRetorno, RCH->RCH_PER)
		lRetorno := .T.
	else
		msginfo("Não foi escolhido nenhum período de processamento", "Período")
		aRetorno := {}
	endif

Return lRetorno

/*/{Protheus.doc} Cancelar
Validação do botão Cancelar da tela TelaProc()
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Cancelar()
	local lRetorno := .T.

	lRetorno := msgYesNo('Cancelar o fechamento?','Cancelar')

Return lRetorno

/*/{Protheus.doc} Fechar
Validação do botão fechar (x na parte superior da tela) da tela TelaProc()
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Fechar(lCancelar, lTudoOk)
	local lRetorno := .T.
	default lCancelar := .F.
	default  lTudoOk := .F.

	if !lCancelar .and. !lTudoOk
		lRetorno := msgYesNo('Cancelar o fechamento?','Cancelar')
	endif

Return  lRetorno

/*/{Protheus.doc} SelPer
Validação do botão selecionar da tela TelaProc()
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function SelPer(cGet1, cGet2, cGet3)
	ConPad1(,,,"RCHPON")
	if !empty( RCH->RCH_PROCES )
		cGet1 := RCH->RCH_PROCES
		cGet2 := RCH->RCH_ROTEIR
		cGet3 := substr(RCH->RCH_PER, 5,2)+'/'+substr(RCH->RCH_PER, 1,4)
	endif
Return

/*/{Protheus.doc} VldU00A
Rotina de bloqueio dos menus de lançamentos do ponto eletronico
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function VldU00A(lCSRH190)
	local cAlias     := getNextAlias()
	local nRec	     := 0
	local cQuery     := ''
	local lExeChange := .T.
	local lRetorno 	 := .F.
	default lCSRH190 := .F.

	cQuery := "	SELECT COUNT(*) QTD FROM ( "
	cQuery += "		SELECT  "
	cQuery += "			RCC_CONTEU "
	cQuery += "		FROM  "
	cQuery += "			"+RetSqlName("RCC")+" RCC "
	cQuery += "		WHERE  "
	cQuery += "			D_E_L_E_T_ = ' ' "
	cQuery += "			AND RCC_CODIGO 				   = '"+cTABELA_GENERICA+"' "
	cQuery += "			AND SUBSTR( RCC_CONTEU, 19, 1) = '"+cSELECIONADO+"' "
	cQuery += "	) TAB

	if U_MontarSQL( cAlias, @nRec, cQuery, lExeChange ) 	//Caso a consulta retorno registro faça:
		While ( cAlias )->( !EOF() ) //Enquanto não for fim de arquivo
			if lCSRH190
				if ( cAlias )->QTD == 1
					lRetorno := .T.
				elseif ( cAlias )->QTD == 0
					Alert('Não existe período de banco de horas selecionado.')
				else
					alert('Existe mais de um período de banco de horas aberto, revise a tabela U00A.')
				endif
			else
				if ( cAlias )->QTD == 0
					lRetorno := .T.
				else
					alert('Existe período de banco de horas aberto, para acessar a rotina revise a tabela U00A e retire a seleção.')
				endif
			endif
			( cAlias )->( dbSkip() )
		end
		( cAlias )->(dbCloseArea())
	endif
Return lRetorno

/*/{Protheus.doc} CSRH194()
Rotina de bloqueio dos lançamento de marcação
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH194()
	if u_VldU00A()
		PONA040()
	endif
Return

/*/{Protheus.doc} CSRH195()
Rotina de bloqueio dos lançamento de apontamento
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH195()
	if u_VldU00A()
		PONA130()
	endif
Return

/*/{Protheus.doc} CSRH196()
Rotina de bloqueio dos lançamento de banco de horas
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH196()
	if u_VldU00A()
		PONA200()
	endif
Return

/*/{Protheus.doc} CSRH197()
Rotina de bloqueio dos lançamentos dos resultados
@type function
@author BrunoNunes
@since 27/05/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH197()
	if u_VldU00A()
		PONA170()
	endif
Return