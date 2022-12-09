#Include "Protheus.ch"
#Include "TopConn.ch"

#Define cPERG	'RHSQL001'

#Define cABA_EXTRATO 'Consulta generica 001'

/*/{Protheus.doc} CSRH200
Relatório com dados de funcionário com algumas informações de rescisão,
centro de custo, função, departamento e diretoria em formato XML.
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH200()
	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

 	AjustaSx1() 			//Criar pergunte caso não exista no SX1
	if pergunte(cPERG, .T.) 	//Exibe para o usuário tela de parâmetros
		if u_Valid200('De') .and. u_Valid200('Ate') //Valida datas de parametros
			Processa( {|| Proc200() }, "Aguarde...", "Gerando consulta genérica.",.F.) //Inicia processamentos do extrato de banco de horas
		endif
	endif
Return

/*/{Protheus.doc} Proc200
Executa o processamento
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Proc200()
	local aLista 		:= {}	//Lista do banco de horas
	local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  		:= '' 	//Query SQL
	local lExeChange 	:= .T. 	//Executa o change Query
	local nRec 			:= 0 	//Numero Total de Registros da consulta SQL
	local cArquivo		:= ''	//Nome do arquivo escolhido pelo usuário para gravação do arquivo XML.
	local aDiret		:= getArrDir() //Array de diretoria
	local lSaltaLin		:= .F. //Salta linha após incluir um registro

	ProcRegua( 0 )

	cArquivo := AjustaArq() //Retorna no do arquivo escolhido pelo usuário.
	//Se o arquivo estiver vazio será finalizada a rotina.
	if empty(cArquivo)
		return //Sai da rotina.
	endif

	cQuery := MontarQry()//Monta consulta SQL para lista banco de horas

	If U_MontarSQL( cAlias, @nRec, cQuery, lExeChange ) 	//Caso a consulta retorno registro faça:
		ProcRegua( nRec )	//Inicia barra de progressão infinita

		oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

		CabExtrato() //Cabeçalho Extrato

		( cAlias )->(dbGoTop()) //Posiciona no primeiro registro
		While ( cAlias )->( !EOF() ) //Enquanto não for fim de arquivo
			IncProc()	//Incrementa a barra de progressão

			aLista  := {}
			aAux 	:= {}

			aAdd( aAux, (cAlias)->FILIAL )						//01 Filial
			aAdd( aAux, (cAlias)->CC )							//02 Centro de custo
			aAdd( aAux, buscaDir(aDiret, (cAlias)->CC) )		//03 Diretoria
			aAdd( aAux, Capital( (cAlias)->CC_DESC ) ) 			//04 Descrição do Centro de custo
			aAdd( aAux, Capital( (cAlias)->NOME_RESP ) )		//05 Gestor
			aAdd( aAux, (cAlias)->MATRICULA )					//06 Matrícula
			aAdd( aAux, (cAlias)->NOME_COMPLETO )				//07 Nome completo
			aAdd( aAux, (cAlias)->DDDFIX )						//08 DDD Fixo
			aAdd( aAux, (cAlias)->TELFIX )						//09 Telefone Fixo
			aAdd( aAux, (cAlias)->DDDCEL )						//10 DDD Celular
			aAdd( aAux, (cAlias)->TELCEL )						//11 Telefone Celular
			aAdd( aAux, STOD( (cAlias)->ADMISSA ) )				//12 Data admissão
			aAdd( aAux, STOD( (cAlias)->DEMISSA ) )				//13 Data demissão
			aAdd( aAux,  MesExtenso(STOD((cAlias)->DEMISSA)))	//14 Mês de demissao
			aAdd( aAux, Capital( (cAlias)->FUNC_DESC) )			//15 Descrição da Função
			aAdd( aAux, "" )									//16 Sem Interesse em responder
			aAdd( aAux, Capital( (cAlias)->DESC_RESC ) )		//17 Descrição da rescisão

			aAdd(aLista, aAux )

			ListarAba( aLista, lSaltaLin, cABA_EXTRATO, cABA_EXTRATO, 10)	//Monta lista no excel do extrato

			(cAlias)->(DbSkip())
		EndDo

		GravaExcel( cArquivo ) //Fecha o componente do excel e abre para o usuário manipular.
		msginfo("Arquivo "+cArquivo+" gerado com sucesso.", "Relatório Criado.")

		(cAlias)->(DbCloseArea()) //Fecha alias temporario da consulta SQL.
	else
		alert("Arquivo não gerado. Verifique parâmetros informados.")
	endif

Return()

/*/{Protheus.doc} MontarQry
Retorna query da busca do relatório em string SQL
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return texto, cRetorno - Query no formato SQL para realizar busca na tabela de banco de horas
/*/
Static Function MontarQry()
	local cRetorno 		:= ''	//Query do retorno
	local cFilialDe		:= ''	//Paramtro Filial De?
	local cFilialAte 	:= ''	//Paramtro Filial Ate?
	local cCcDe 	 	:= ''	//Paramtro Centro de Custo De?
	local cCcAte 		:= ''	//Paramtro Centro de Custo Ate?
	local cMatDe 		:= ''	//Paramtro Matrícula De?
	local cMatAte 		:= ''	//Paramtro Matrícula Ate?
	local cNomeDe		:= ''	//Paramtro Nome De?
	local cNomeAte		:= ''	//Paramtro Nome Ate?
	local cDemisSim		:= ''	//Paramtro Demis Sim?
	local cDataDe 		:= ''	//Paramtro Data De?
	local cDataAte 		:= ''	//Paramtro Data Ate?

	cFilialDe 	:= MV_PAR01
	cFilialAte 	:= MV_PAR02
	cCcDe 		:= MV_PAR03
	cCcAte 		:= MV_PAR04
	cMatDe 		:= MV_PAR05
	cMatAte 	:= MV_PAR06
	cNomeDe		:= MV_PAR07
	cNomeAte	:= MV_PAR08
	cDemisSim	:= MV_PAR09
	cDataDe 	:= dtos(MV_PAR10)
	cDataAte	:= dtos(MV_PAR11)

	cRetorno := " SELECT  "
	cRetorno += " 	SRA.RA_FILIAL FILIAL"
	cRetorno += " 	, SRA.RA_MAT MATRICULA"
	cRetorno += " 	, SRA.RA_NOMECMP NOME_COMPLETO"
	cRetorno += " 	, SRA.RA_CC CC"
	cRetorno += " 	, SRA.RA_DDDFONE DDDFIX"
	cRetorno += " 	, SRA.RA_TELEFON TELFIX"
	cRetorno += " 	, SRA.RA_DDDCELU DDDCEL"
	cRetorno += " 	, SRA.RA_NUMCELU TELCEL"
	cRetorno += " 	, CTT_DESC01 CC_DESC"
	cRetorno += " 	, SRA.RA_CODFUNC FUNCAO"
	cRetorno += " 	, RJ_DESC FUNC_DESC"
	cRetorno += " 	, SRA.RA_DEPTO DEPTO"
	cRetorno += " 	, QB_DESCRIC DEPTO_DESC"
	cRetorno += " 	, QB_MATRESP MAT_RESP"
	cRetorno += " 	, SRADEPTO.RA_NOME NOME_RESP"
	cRetorno += " 	, SRA.RA_ADMISSA ADMISSA"
	cRetorno += " 	, SRA.RA_DEMISSA DEMISSA"
	cRetorno += " 	, RG_DATAHOM DATA_HOM"
	cRetorno += " 	, RG_TIPORES TIPO_RES"
	cRetorno += " 	, SUBSTR(RCC_CONTEU, 3, 30) DESC_RESC "
	cRetorno += " FROM  "
	cRetorno += " 	"+RetSqlName("SRA")+" SRA   "
	cRetorno += " LEFT JOIN "+RetSqlName("CTT")+" CTT ON  "
	cRetorno += " 	CTT.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND CTT_CUSTO = RA_CC "
	cRetorno += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ ON  "
	cRetorno += " 	SRJ.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND SRJ.RJ_FUNCAO = RA_CODFUNC "
	cRetorno += " LEFT JOIN "+RetSqlName("SQB")+" SQB ON  "
	cRetorno += " 	SQB.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND SQB.QB_DEPTO = RA_DEPTO "
	cRetorno += " LEFT JOIN "+RetSqlName("SRA")+" SRADEPTO ON  "
	cRetorno += " 	SRADEPTO.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND SRADEPTO.RA_FILIAL = SQB.QB_FILRESP "
	cRetorno += " 	AND SRADEPTO.RA_MAT = SQB.QB_MATRESP "
	cRetorno += " LEFT JOIN "+RetSqlName("SRG")+" SRG ON  "
	cRetorno += " 	SRG.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND RG_FILIAL  = SRA.RA_FILIAL "
	cRetorno += " 	AND RG_MAT	   = SRA.RA_MAT "
	cRetorno += " LEFT JOIN "+RetSqlName("RCC")+" RCC ON  "
	cRetorno += " 	RCC.D_E_L_E_T_ = ' '  "
	cRetorno += " 	AND SUBSTR(RCC_CONTEU, 1, 2) = RG_TIPORES "
	cRetorno += " 	AND RCC_CODIGO = 'S043' "
	cRetorno += " WHERE "
	cRetorno += " 	SRA.D_E_L_E_T_ = ' ' "
	cRetorno += " 	AND SRA.RA_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"'"
	cRetorno += " 	AND SRA.RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
	cRetorno += " 	AND SRA.RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
	cRetorno += " 	AND SRA.RA_NOME BETWEEN '"+cNomeDe+"' AND '"+cNomeAte+"'"
	if cDemisSim == 1
		cRetorno += " 	AND SRA.RA_DEMISSA BETWEEN '"+cDataDe+"' AND '"+cDataAte+"'"
	endif
	cRetorno += " ORDER BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME "

Return cRetorno

/*/{Protheus.doc} CabExtrato
Monta Planilha, Tabela e Coluna do reatório extrato
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function CabExtrato( )
	//Monta Aba
	//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
	oFWMsExcel:AddworkSheet( cABA_EXTRATO )

	//Criando a Tabela
	//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oFWMsExcel:AddTable( cABA_EXTRATO, cABA_EXTRATO )

	//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Filial"					,1) //01
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Centro de Custo" 		,1) //02
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Diretoria"				,1) //03
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Descrição CCusto"		,1) //04
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Gestor"					,1) //05
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Matrícula"				,1) //06
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Nome completo"			,1) //07
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "DDD"						,1) //08
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Tel. Fixo"				,1) //09
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "DDD"						,1) //10
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Celular"					,1) //11
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Data admissão"			,1) //12
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Data demissão"			,1) //13
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Mês de demissão"			,1) //14
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Des. função"				,1) //15
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, ""						,1) //16
	oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Motivo do desligamento"	,1) //17

Return


/*/{Protheus.doc} GravaExcel
Executa integração com Excel
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function GravaExcel( cArquivo )
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile( cArquivo ) //Cria um arquivo no formato XML do MSExcel 2003 em diante

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open( cArquivo ) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()					//Encerra o processo do gerenciador de tarefas

	FreeObj( oExcel )
	FreeObj( oFWMSExcel )
Return

/*/{Protheus.doc} ListarAba
Monta linha no Excel
@param [ aLista ]	 , lista	, Lista do banco de horas por funcionario
@param [ lVazio ]	 , logico	, Verdareiro, salta linha no final da impressão
@param [ cSheet ]	 , texto	, Nome da aba no excel
@param [ cTable ]	 , cTable	, Nome da tabela no excel
@param [ nTam   ]	 , numerico	, Números de colunas no excel
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function ListarAba( aLista, lVazio, cSheet, cTable, nTam)
	local i := 0	//Variavel de iteração

	default aLista 	:= {}	//Lista de impressão
	default cSheet 	:= ''	//Nome da aba
	default cTable 	:= ''	//Nome da tabela
	default lVazio 	:= .F.	//Salta linha no relatório
	default nTam 	:= 0	//Número de colunas da lista

	if !empty( aLista )
		for i := 1 to len( aLista )
			nTam := len( aLista[i] )
			//Criando as Linhas... Enquanto não for fim da query
			oFWMsExcel:AddRow( cSheet, cTable, aLista[i] )
		next i

		if lVazio
			oFWMsExcel:AddRow( cSheet, cTable, array( nTam ) )
		endif
	endif
Return


/*/{Protheus.doc} AjustaSx1
Cria Pergunte RHSQL001 caso não exista
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function AjustaSx1( )
	xPutSx1( cPERG, "01", "Filial De?"					  , "Filial De?"						, "Filial De?"						,"mv_ch1" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "02", "Filial Até?"					  , "Filial Até?"						, "Filial Até?"						,"mv_ch2" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "03", "Centro de Custo De?"			  , "Centro de Custo De?"				, "Centro de Custo Ate?"			,"mv_ch3" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par03","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "04", "Centro de Custo Até?"		  , "Centro de Custo Ate?"				, "Centro de Custo Ate?"			,"mv_ch4" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par04","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "05", "Matricula De?"				  , "Matricula De?"						, "Matricula De?"					,"mv_ch5" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par05","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "06", "Matricula Até?"				  , "Matricula Até?"					, "Matricula Até?"					,"mv_ch6" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par06","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "07", "Nome De?"					  , "Nome De?"							, "Nome De?"						,"mv_ch7" , "C",20,0,0,"G",""					,""   	,"","","mv_par07","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "08", "Nome Até?"					  , "Nome Até?"							, "Nome Até?"						,"mv_ch8" , "C",20,0,0,"G",""					,""	    ,"","","mv_par08","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "09", "Considera Data Demissão?"	  , "Considera Data Demissão?"			, "Considera Data Demissão?"		,"mv_ch9" , "C",01,0,0,"C",""					,""		,"","","mv_par09","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "10", "Demissão De?"				  , "Demissão De?"						, "Demissão De?"					,"mv_cha" , "D",08,0,0,"G","u_Valid200('De')"	,""		,"","","mv_par10","","","","","","","","","","","","","","","","",,,)
	xPutSx1( cPERG, "11", "Demissão Até?"				  , "Demissão Até?"						, "Demissão Até?"					,"mv_chb" , "D",08,0,0,"G","u_Valid200('Ate')"	,""		,"","","mv_par11","","","","","","","","","","","","","","","","",,,)
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
@author Bruno Nunes
@since 30/07/2018
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
		//PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
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

/*/{Protheus.doc} Valid200
Valida parâmetros de datas quando for relatório.
@param [ cParam ], texto, Parâmetro a ser validado
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return lógico, lRetorno - Verdadeiro, permite o fluxo da escolha dos paâmetros de data.
/*/
User Function Valid200( cParam )
	local lRetorno := .T.	//Retorno da validação das datas

	default cParam := '' //Nome do parâmetro

	if MV_PAR09 == 1
		if cParam == 'De'
			if empty( MV_PAR10 )
				lRetorno :=  .F.
				MsgInfo("Campo 'Demissão de?' não preenchido","Parâmetros")
			endif
		elseif cParam == 'Ate'
			if empty( MV_PAR11 )
				lRetorno :=  .F.
				MsgInfo("Campo 'Demissão Até?' não preenchido","Parâmetros")
			endif
			if MV_PAR11 < MV_PAR10
				lRetorno :=  .F.
				MsgInfo("Campo 'Demissão Até?' menor que campo 'Demissão De?' ","Parâmetros")
			endif
		endif
	endif
Return lRetorno

/*/{Protheus.doc} AjustaArq
Retorna no do arquivo escolhido pelo usuário.
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function AjustaArq()
	local cArquivo := ''
	local lOk := .F.

   	Local cMascara  := "*.xml|*.xml' , 'XML (xml)"
    Local cTitulo   := "Escreva o nome do arquivo"
    Local nMascpad  := 0
    Local cDirini   := "\"
    Local lSalvar   := .F. /*.F. = Salva || .T. = Abre*/
    Local nOpcoes   := nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE )
    Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/

	while !lOk
		cArquivo := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
		if empty(cArquivo)
			lOk := msgYesNo("Nenhum arquivo foi digitado, deseja encerrar o processamento?")
			loop
		endif
		cArquivo += ".xml"
		if file( cArquivo )
			msgInfo("Arquivo já existe, escolha outro nome de arquivo.", "Arquivo existente.")
			loop
		endif
		lOk := .T.
	end
Return cArquivo

/*/{Protheus.doc} getArrDir
Monta array com lista de diretoria
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function getArrDir()
	local aDiret := {}
	//			  Centro Cust   Descrição                                           Gerente/Gestor       Diretor              Diretoria
	aAdd(aDiret, {"010102B",    "AUDITORIA INTERNA                                ","André Nishikawa   ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"030102B",    "SEGURANCA                                        ","Oscar Zucarelli   ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"030106B",    "JURIDICO                                         ","Maria Bortolan    ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"040202G",    "COMPRAS                                          ","Levi Peixoto      ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"040207A",    "DIRETORIA ADMINISTRATIVA                         ","Isaac/Julio       ","        -         ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"040207C",    "ADMINISTRACAO DE PESSOAL                         ","Mário Sampaio     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"040207D",    "R & S / T & D                                    ","Mário Sampaio     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"040207E",    "DESENVOLVIMENTO ORGANIZACIONAL                   ","Mário Sampaio     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060205C",    "ESTOQUE E LOGISITCA                              ","Levi Peixoto      ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060205D",    "FACILITIES - GERAL                               ","Levi Peixoto      ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060205E",    "FACILITIES ADMINISTRATIVO                        ","Levi Peixoto      ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060211C",    "SISTEMAS CORPORATIVOS - INOVACAO                 ","Giovanni Rodrigues","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060211D",    "SISTEMAS CORPORATIVOS - SUSTENTACAO              ","Giovanni Rodrigues","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060213F",    "DESENVOLVIMENTO SOLUCOES PARA INTERNET           ","Gustavo Klein     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"060215B",    "NORMAS E COMPLIANCE                              ","Patrícia Tertulian","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"070103B",    "COMUNICACAO E MARKETING                          ","Gustavo Klein     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"070103C",    "MIDIAS SOCIAIS                                   ","Gustavo Klein     ","Roni              ","Diretoria Administrativa                      "})
	aAdd(aDiret, {"050104A",    "DIRETORIA COMERCIAL                              ","Isaac/Julio       ","        -         ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050104B",    "VENDAS CORPORATIVAS                              ","Erik Rainer       ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050104C",    "COMERCIAL - PRE VENDA                            ","Erik Rainer       ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050104D",    "CANAIS INDIRETOS E WEB                           ","Ronaldo Tardeli   ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050104E",    "MARKETING E NEGOCIOS CORPORATIVOS                ","Karina Del Carlo  ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050105A",    "DIRETORIA DE ALIANCAS ESTRATEGICAS               ","Isaac/Julio       ","        -         ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"050105B",    "NOVOS NEGOCIOS E ALIANCAS ESTRATEGICAS           ","Ana Flavia        ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"060204C",    "CONSULTORIA E PROJETOS - ENTREGAS                ","Thiago Scorza     ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"060208B",    "CONSULTORIA E PROJETOS                           ","Thiago Scorza     ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"070102B",    "VENDAS DIRETAS                                   ","Rodrigo Marsola   ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"070104C",    "LICITACAO (COORDENACAO)                          ","Flavia Forte      ","Henri Sternberg   ","Diretoria de Negócios Corporativos            "})
	aAdd(aDiret, {"030107A",    "DIRETORIA DE CERTIFICADO E VAREJO                ","Isaac/Julio       ","        -         ","Diretoria de Canais e Varejo                  "})
	aAdd(aDiret, {"030107B",    "CANAIS                                           ","Leonardo Gonçalves","Leonardo Gonçalves","Diretoria de Canais e Varejo                  "})
	aAdd(aDiret, {"010130A",    "INTELIGENCIA DE MERCADO                          ","Alexandre Bonfa   ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"030102C",    "VALIDACAO SSL                                    ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"030102E",    "GESTAO  ICP-BRASIL                               ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060202A",    "DIRETORIA DE INFRAESTRUTURA E OPERACOES          ","Isaac/Julio       ","        -         ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060202C",    "OPERACOES DATA CENTER - GERAL                    ","Leonardo Guimarães","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060202D",    "OPERACOES DATA CENTER - PROJETOS                 ","Leonardo Guimarães","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060202E",    "OPERACOES PKI                                    ","Leonardo Guimarães","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060202F",    "OPERACOES DATA CENTER - GERAL - SP               ","Leonardo Guimarães","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060204D",    "QUALIDADE                                        ","José Roberto      ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060204E",    "INFRAESTRUTURA TI                                ","André Veloso      ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060206C",    "ATENDIMENTO AO CLIENTE - RELACIONAMENTO          ","Alline Longati    ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060206D",    "ATENDIMENTO AO CLIENTE - SUPORTE TECNICO         ","Alline Longati    ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060206E",    "ATENDIMENTO AO CLIENTE - QUALIDADE               ","Alline Longati    ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207B",    "OPERACOES                                        ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207C",    "OPERACOES - PROJETOS E SERVICOS                  ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207H",    "OPERACOES – OPERACIONAL DE CANAIS                ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207I",    "DESENVOLVIMENTO DE CONTEUDO                      ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207K",    "AR BELO HORIZONTE                                ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207L",    "AR BRASILIA                                      ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207O",    "AR PASSEIO                                       ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207P",    "AR PORTO ALEGRE                                  ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207Q",    "AR RECIFE                                        ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207R",    "POSTO                                            ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207S",    "AR MANAUS                                        ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207T",    "AR BELA CINTRA                                   ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207U",    "AR BELA CINTRA 2                                 ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060207V",    "IMPLANTACAO DE PROJETOS                          ","Patrícia Abrahão  ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060209C",    "SISTEMAS VAREJO - VERTICAL BIOMETRICA            ","Maurício Silles   ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060212D",    "DESENVOLVIMENTO - ANALISE E PLANEJAMENTO         ","Maurício Silles   ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060213C",    "DESENVOLVIMENTO - BANCO DE DADOS                 ","Maurício Silles   ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060213D",    "DESENVOLVIMENTO - SOLUCOES PARA SERVICOS         ","Maurício Silles   ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"060214B",    "DESENVOLVIMENTO DE SOFTWARES DEDICADOS           ","Ricardo Gobbo     ","Bernardo          ","Diretoria de Infraestrutura e Operações       "})
	aAdd(aDiret, {"050106A",    "DIRETORIA DE INOVACAO EM PRODUTOS E MERCADOS     ","Isaac/Julio       ","        -         ","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"050106C",    "GER DESENVOLVIMENTO E OPERACOES PORTAL           ","Carlos Coelho     ","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"050106D",    "GERENCIA DE PRODUTO E SUPORTE                    ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"050106E",    "GER DE DESENVOLVIMENTO E OPERACOES - ID          ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"050106G",    "SERVICOS AO CLIENTE                              ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"060212C",    "PRODUTOS E SERVICOS - SOL. CORPORATIVAS          ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"060212E",    "DESENVOLVIMENTO - QUALIDADE E SEGURANCA          ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"060213E",    "DESENVOLVIMENTO - SOLUCOES CORPORATIVAS          ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"060213G",    "DESENVOLVIMENTO - ANALISE E PLANEJAMENTO         ","Maria Teresa Aarão","Maria Teresa Aarão","Diretoria de Inovação em Produtos e Mercados  "})
	aAdd(aDiret, {"040202A",    "DIRETORIA FINANCEIRA                             ","Isaac/Julio       ","        -         ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040202B",    "FINANCEIRO                                       ","Edson Tsukamoto   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040202C",    "COBRANCA                                         ","Edson Tsukamoto   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040202D",    "TESOURARIA                                       ","Edson Tsukamoto   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040202E",    "CUSTOS CANAIS                                    ","Edson Tsukamoto   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040202F",    "PLANEJAMENTO FINANCEIRO                          ","Edson Tsukamoto   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040203C",    "FISCAL E TRIBUTARIO                              ","Valdinei Oliveira ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"040203E",    "CONTABILIDADE                                    ","Marcio Carreira   ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"070105C",    "SUPORTE ADMINISTRATIVO DE VENDAS                 ","        -         ","Fábio             ","Diretoria Financeira                          "})
	aAdd(aDiret, {"010120A",    "PROJETOS ESPECIAIS                               ","Igor              ","        -         ","Diretoria Certibio                            "})
	aAdd(aDiret, {"030101A",    "VICE-PRESIDENCIA EXECUTIVA                       ","Isaac             ","        -         ","VICE-PRESIDENCIA EXECUTIVA                    "})
	aAdd(aDiret, {"050101A",    "VICE-PRESIDENCIA COMERCIAL                       ","Conselho          ","        -         ","VICE-PRESIDENCIA EXECUTIVA                    "})
Return aDiret

/*/{Protheus.doc} buscaDir
Retorna a descrição da diretoria conforme código do centro de custo
@type function
@author Bruno Nunes
@since 30/07/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function buscaDir(aDiret, cCc)
	local nPos 		:= 0
	local cDiret	:= ''

	default aDiret 	:= {}
	default cCc 	:= ''

	nPos := aScan(aDiret, { |x| alltrim(x[1]) == alltrim(cCc) } )
	if nPos > 0
		cDiret := aDiret[nPos][5]
	endif
Return cDiret