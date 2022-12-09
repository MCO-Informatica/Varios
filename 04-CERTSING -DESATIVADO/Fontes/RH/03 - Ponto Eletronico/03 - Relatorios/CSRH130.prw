#Include "Protheus.ch"
#Include "TopConn.ch"

#Define cPERG_BANCO_HORAS	'BHEXTRATO'
#Define cPERG_BAIXADO		'BHBAIXADO'
#Define cCAMINHO			'c:\temp\bh.xml'
#Define cABA_EXTRATO 		'Extrato'
#Define cABA_ACUMULADO 		'Acumulado'
#Define cABA_IMPORTACAO 	'Importação de Variáveis'
#Define cABA_COMPOSICAO 	'Composição do acumulado'
#Define cSX5_REGRA			'Z6'
#Define cMASK_TOTAL			'Total - ###: '
#Define cTOT_FUNCIONARIO	'Funcionário'
#Define cTOT_PERIODO		'Período'
#Define cTOT_REGRA			'Regra'
#Define cTOT_CC				'Centro de Custo'
#Define cREGRA_01 			'EXT-CLT-SPD'
#Define cREGRA_02 			'PLT-RCH-0008'
#Define cTABELA_GENERICA 	'U00A'

/*/{Protheus.doc} CSRH130
Extrato de banco de horas Certisign. Gera em CSV uma lista dos banco de horas ordenado por pelas negativas,
depois horas positivas ordenada por ordem de valorização - 55%, 75%, 100%.
Opção de Extrato, Composição de acumulado, Acumulado e todos.
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH130()
	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

 	AjustaSx1(cPERG_BANCO_HORAS) 			//Criar pergunte caso não exista no SX1
	if pergunte(cPERG_BANCO_HORAS, .T.) 	//Exibe para o usuário tela de parâmetros
		if u_Valid130('De') .and. u_Valid130('Ate') //Valida datas de parametros
			Processa( {|| Proc130(cPERG_BANCO_HORAS) }, "Aguarde...", "Gerando extrato do banco de horas.",.F.) //Inicia processamentos do extrato de banco de horas
		endif
	endif
Return

/*/{Protheus.doc} CSRH131
Extrato de banco de horas Certisign. Gera em CSV uma lista dos banco de horas ordenado por pelas negativas,
depois horas positivas ordenada por ordem de valorização - 55%, 75%, 100%.
Opção de Extrato, Composição de acumulado, Acumulado e todos.
@type function
@author BrunoNunes
@since 04/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH131()
	private oFWMsExcel	//Variavel para gerar Excel
	private oExcel		//Variavel para gerar Excel

 	AjustaSx1(cPERG_BAIXADO) 			//Criar pergunte caso não exista no SX1
	if pergunte(cPERG_BAIXADO, .T.) 	//Exibe para o usuário tela de parâmetros
		Processa( {|| Proc130(cPERG_BAIXADO) }, "Aguarde...", "Gerando extrato do banco de horas baixado",.F.) //Inicia processamentos do extrato de banco de horas baixados
	endif
Return

/*/{Protheus.doc} CSRH132
Extrato de banco de horas Certisign. Gera em CSV uma lista dos banco de horas ordenado por pelas negativas,
depois horas positivas ordenada por ordem de valorização - 55%, 75%, 100%.
Opção de Extrato, Composição de acumulado, Acumulado e todos.
@type function
@author BrunoNunes
@since 04/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
User Function CSRH132( aParam )
	local cErro 	 := ''
	local aRetorno 	 := {}
	default aParam   := {}

	if !empty( aParam )
		MV_PAR01 := aParam[1] //Filial De?
		MV_PAR02 := aParam[2] //Filial Ate?
		MV_PAR03 := aParam[3] //Centro de Custo De?
		MV_PAR04 := aParam[4] //Centro de Custo Ate?
		MV_PAR05 := aParam[5] //Matricula De?
		MV_PAR06 := aParam[6] //Matricula Ate?
		MV_PAR07 := 2 		  //Gera Extrato
		MV_PAR08 := 1		  //Gera Acumulado
		MV_PAR09 := 2		  //Gera Comp Acumulado
		MV_PAR10 := 2		  //Gera Importação de Variaveis
		MV_PAR11 := 2 		  //Intervalo = sim
		MV_PAR12 := aParam[7] //Data De?
		MV_PAR13 := aParam[8] //Data Ate?

		Processa( {|| Proc130( cPERG_BANCO_HORAS, .T., @aRetorno ) }, "Aguarde...", "Carregando dados para processamento",.F.) //Inicia processamentos do extrato de banco de horas baixados
	else
		cErro := 'Parametros não definidos, simulação abortada.'
	endif

	if !empty( cErro )
		alert( cErro )
	endif
Return aRetorno

/*/{Protheus.doc} Proc130
Executa o processamento
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Proc130( cTipoRelat, lIsProc, aRetorno )
	local aAnaCC		:= {}	//Total dos valores por evento e centro de custo
	local aAnaFunc		:= {}	//Total dos valores por funcionário - analitico
	local aExtCC		:= {}	//Total dos valores por evento e centro de custo
	local aExtFunc		:= {}	//Total dos valores por funcionário - extrato
	local aLista 		:= {}	//Lista do banco de horas
	local aSinCC		:= {}	//Total dos valores por evento e centro de custo
	local aSinFunc		:= {}	//Total dos valores por funcionário - sintetico
	local aTitulo 		:= {}	//Cabecalho do banco de horas
	local cAlias     	:= GetNextAlias() //Alias resevardo para consulta SQL
	local cBaixa		:= ''	//Chave data da baixa
	local cBaixaAnt		:= ''   //Chave data da baixa anterior
	local cCC			:= ''   //Chave filial + Centro de custo
	local cCCAnter		:= ''   //Chave filial + Centro de custo anterior
	local cFunc			:= ''   //Chave filial + matricula
	local cFuncAnt		:= ''	//Chave Anterior para verificar quebra da lista
	local cPerBH		:= ''   //Chave periodo do banco de horas
	local cPerBHAnt		:= ''	//Chave periodo do banco de horas anterior
	local cQuery  		:= '' 	//Query SQL
	local cRegra		:= ''   //Chave regra do banco de horas
	local cRegraAnt		:= ''	//Chave regra do banco de horas anterior
	local lExeChange 	:= .T. 	//Executa o change Query
	local lSaltaLin 	:= .F. 	//Executa o change Query
	local nColAnatot	:= 0	//Quantidade total de coluna do relatório composição acumulado
	local nColExtTot	:= 0	//Quantidade total de coluna do relatório extrato
	local nColSinTot	:= 0	//Quantidade total de coluna do relatório acumulado
	local nPos			:= 0  	//Posicao do array
	local nRec 			:= 0 	//Numero Total de Registros da consulta SQL
	local nSaldo 		:= 0	//Valor total do banco de horas
	local nSaldoCC 		:= 0	//Valor total do banco de horas
	local cArquivo		:= ''	//Nome do arquivo escolhido pelo usuário para gravação do arquivo XML.

	default cTipoRelat  := ''	//Tipo de relatório
	default lIsProc		:= .F.
	default aRetorno	:= {}

	ProcRegua( 0 )

	if !lIsProc
		cArquivo := AjustaArq() //Retorna no do arquivo escolhido pelo usuário.
		//Se o arquivo estiver vazio será finalizada a rotina.
		if empty(cArquivo)
			return //Sai da rotina.
		endif
	endif
	cQuery := MontarQry( cTipoRelat )//Monta consulta SQL para lista banco de horas

	If U_MontarSQL( cAlias, @nRec, cQuery, lExeChange ) 	//Caso a consulta retorno registro faça:
		ProcRegua( nRec )	//Inicia barra de progressão infinita

		oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

		nColExtTot	:= iif(cTipoRelat == cPERG_BANCO_HORAS, 10, 13) //Quantidade total de coluna do relatório extrato
		nColSinTot	:= iif(cTipoRelat == cPERG_BANCO_HORAS, 08, 10) //Quantidade total de coluna do relatório acumulado
		nColAnatot	:= iif(cTipoRelat == cPERG_BANCO_HORAS, 10, 13) //Quantidade total de coluna do relatório composição acumulado

		CabExtrato(cTipoRelat, lIsProc) //Cabeçalho Extrato
		CabAcumula(cTipoRelat, lIsProc) //Cabeçalho Acumulado
		CabCompAcu(cTipoRelat, lIsProc) //Cabeçalho Composição acumulado
		CabImpVari(cTipoRelat, lIsProc)	//Cabeçalho Importação de variáveis

		( cAlias )->(dbGoTop()) //Posiciona no primeiro registro
		cFuncAnt  := ( cAlias )->(FILIAL+MATRICULA) //Monta chave anterior filial + matricula
		cCCAnter  := ( cAlias )->(FILIAL+COD_CUSTO) //Monta chave anterior filial + centro de custo
		cRegraAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->REGRA ) ) //Monta chave anterior regra de banco de hora
		cPerBHAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->PERBH ) ) //Monta chave anterior periodo do banco de horas
		cBaixaAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', ( cAlias )->BAIXA ) //Monta chave anterior data da baixa
		While ( cAlias )->( !EOF() ) //Enquanto não for fim de arquivo
			IncProc()	//Incrementa a barra de progressão
			cFunc   := ( cAlias )->(FILIAL+MATRICULA) //Monta chave filial + matricula
			cCC		:= ( cAlias )->(FILIAL+COD_CUSTO) //Monta chave filial + centro de custo
			cRegra	:= iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->REGRA ) ) //Monta chave regra de banco de hora
			cPerBH	:= iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->PERBH ) ) //Monta chave periodo do banco de horas
			cBaixa	:= iif( cTipoRelat == cPERG_BANCO_HORAS , '', ( cAlias )->BAIXA ) //Monta chave anterior data da baixa

			//quebra por totalização
			if  cFunc  != cFuncAnt  .or. ;
				cRegra != cRegraAnt .or. ;
				cPerBH != cPerBHAnt .or. ;
				cBaixa != cBaixaAnt

				lSaltaLin := iif ( cRegraAnt == cREGRA_01, .F., .T. )

				ListarAba( GerarExtra( aLista, nSaldo, @aExtFunc, cTipoRelat, lIsProc			)	, lSaltaLin, cABA_EXTRATO	, cABA_EXTRATO	 , nColExtTot, lIsProc)	//Monta lista no excel do extrato
				ListarAba( GerarSinte( aLista, nSaldo, @aSinFunc, cTipoRelat, lIsProc, @aRetorno)	, lSaltaLin, cABA_ACUMULADO	, cABA_ACUMULADO , nColSinTot, lIsProc)	//Monta lista no excel acumulado
				ListarAba( GerarAnali( aLista, nSaldo, @aAnaFunc, cTipoRelat, lIsProc			)	, .T., cABA_COMPOSICAO		, cABA_COMPOSICAO, nColAnatot, lIsProc)	//Monta lista no excel da composição acumulado
				ListarAba( GerarImpVa( aLista, nSaldo, cTipoRelat, lIsProc			 			)	, .F., cABA_IMPORTACAO		, cABA_IMPORTACAO, 11		 , lIsProc)	//Monta lista no excel da importação de variáveis

				Acumular( aExtFunc, @aExtCC , 09, 10)	//Totaliza por centro de custo extrato
				Acumular( aSinFunc, @aSinCC , 00, 08)	//Totaliza por centro de custo sintetico
				Acumular( aAnaFunc, @aAnaCC , 09, 10)	//Totaliza por centro de custo centro de custo

				if  cFunc  != cFuncAnt .or. ;
					cBaixa != cBaixaAnt

					if 	cTipoRelat == cPERG_BAIXADO .and. cRegraAnt != cREGRA_01
						Totalizar( @aExtFunc, 09, 10, 11, cABA_EXTRATO 		, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o extrato
						Totalizar( @aSinFunc, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o acumulado
						Totalizar( @aAnaFunc, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o composicao do acumulado
						ListarAba( aExtFunc, lSaltaLin, cABA_EXTRATO		,cABA_EXTRATO, nColExtTot, lIsProc) //Monta lista no excel do extrato
						ListarAba( aAnaFunc, lSaltaLin, cABA_COMPOSICAO		,cABA_COMPOSICAO , nColAnatot, lIsProc) //Monta lista no excel da composição acumulado
					elseif cTipoRelat == cPERG_BANCO_HORAS
						Totalizar( @aExtFunc, 09, 10, 11, cABA_EXTRATO 		, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o extrato
						Totalizar( @aSinFunc, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o acumulado
						Totalizar( @aAnaFunc, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o composicao do acumulado
						ListarAba( aExtFunc, lSaltaLin, cABA_EXTRATO	,cABA_EXTRATO	, nColExtTot, lIsProc) //Monta lista no excel do extrato
						ListarAba( aSinFunc, lSaltaLin, cABA_ACUMULADO	,cABA_ACUMULADO	, nColSinTot, lIsProc) //Monta lista no excel acumulado
						ListarAba( aAnaFunc, lSaltaLin, cABA_COMPOSICAO	,cABA_COMPOSICAO, nColAnatot, lIsProc) //Monta lista no excel da composição acumulado
					endif

					aExtFunc := {}	//Limpa array do extrato de funcionário
					aSinFunc := {}	//Limpa array do sintetico de funcionário
					aAnaFunc := {}	//Limpa array do analitico de funcionário
				endif

				if 	cCC 	!= cCCAnter  .or. ;
					cRegra 	!= cRegraAnt .or. ;
					cPerBH 	!= cPerBHAnt

					Totalizar(@aExtCC, 09, 10, 11, cABA_EXTRATO 	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o extrato
					Totalizar(@aSinCC, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o acumulado
					Totalizar(@aAnaCC, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o composicao do acumulado
					ListarAba( aExtCC	, .T., cABA_EXTRATO		,cABA_EXTRATO	, nColExtTot, lIsProc )	//Monta lista no excel do extrato
					ListarAba( aSinCC	, .T., cABA_ACUMULADO	,cABA_ACUMULADO	, nColSinTot, lIsProc )	//Monta lista no excel acumulado
					ListarAba( aAnaCC	, .T., cABA_COMPOSICAO	,cABA_COMPOSICAO, nColAnatot, lIsProc )	//Monta lista no excel da composição acumulado

					nSaldoCC := 0  //Zera saldo de centro de custo
					aExtFunc := {}	//Limpa array do extrato de funcionário
					aSinFunc := {}	//Limpa array do sintetico de funcionário
					aAnaFunc := {}	//Limpa array do analitico de funcionário
					aExtCC 	 := {}	//Limpa array do extrato de centro de custo
					aSinCC 	 := {}	//Limpa array do sintetico de centro de custo
					aAnaCC 	 := {}	//Limpa array do analitico de centro de custo
				endif

				nSaldo 	 := 0	//Zera saldo de funcionario
				aLista 	 := {}	//Limpa array do funcionario
				aTitulo  := {}  //Limpa array do cabecalho
			endif

			if (cAlias)->TIPO_EVENTO $ '1*3' //Caso seja provento, soma ao saldo, caso seja desconto, subtrai do saldo
				nSaldo 	 := __TimeSum( nSaldo	, (cAlias)->HORAS ) //Soma horas ao saldo do funcionario
				nSaldoCC := __TimeSum( nSaldoCC	, (cAlias)->HORAS ) //Soma horas ao saldo do centro de custo
			elseif (cAlias)->TIPO_EVENTO $ '2*4'
				nSaldo 	 := __TimeSub( nSaldo	, (cAlias)->HORAS ) //Subtrai horas ao saldo do funcionario
				nSaldoCC := __TimeSub( nSaldoCC	, (cAlias)->HORAS ) //Subtrai horas ao saldo do centro de custo
			endif

			aAux := {}
			aAdd( aAux, (cAlias)->FILIAL )					//01 Filial
			aAdd( aAux, (cAlias)->COD_CUSTO )				//02 Centro de custo
			aAdd( aAux, Capital( (cAlias)->DES_CUSTO ) ) 	//03 Descrição do Centro de custo
			aAdd( aAux, (cAlias)->MATRICULA )				//04 Matrícula
			aAdd( aAux, Capital( (cAlias)->NOME ) )			//05 Nome
			aAdd( aAux, dtoc(stod((cAlias)->DATA)) )		//06 Data em string AAAAMMDD
			aAdd( aAux, (cAlias)->EVENTO )					//07 Código evento
			aAdd( aAux, Capital( (cAlias)->DES_EVENTO ) )	//08 Descrição do evento
			aAdd( aAux, (cAlias)->HORAS )					//09 Horas
			aAdd( aAux, (cAlias)->TIPO_EVENTO )				//10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
			aAdd( aAux, (cAlias)->PERCENTUAL_HORA_EXTRA )	//11 Percentual em horas extras
			aAdd( aAux, (cAlias)->CODIGO_FOLHA )			//12 Código Folha
			aAdd( aAux, (cAlias)->DES_CODIGO_FOLHA )		//13 Descrição Código da Verba
			if cTipoRelat == cPERG_BAIXADO
				aAdd( aAux, allTrim( ( cAlias )->REGRA ) ) 	//14 Regra
				aAdd( aAux, TextoPer( ( cAlias )->PERBH ) ) //15 Periodo banco de horas
				aAdd( aAux, stod( ( cAlias )->BAIXA ) ) 	//16 Data da baixa
			endif
			aAdd( aLista, aAux )

			cFuncAnt  := ( cAlias )->(FILIAL+MATRICULA) //Monta chave anterior filial + matricula
			cCCAnter  := ( cAlias )->(FILIAL+COD_CUSTO) //Monta chave anterior filial + centro de custo
			cRegraAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->REGRA ) ) //Monta chave anterior regra de banco de hora
			cPerBHAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', allTrim( ( cAlias )->PERBH ) ) //Monta chave anterior periodo do banco de horas
			cBaixaAnt := iif( cTipoRelat == cPERG_BANCO_HORAS , '', ( cAlias )->BAIXA ) //Monta chave anterior data da baixa
			(cAlias)->(DbSkip())
		EndDo

		ListarAba( GerarExtra( aLista, nSaldo, @aExtFunc, cTipoRelat, lIsProc			)	, .T., cABA_EXTRATO		, cABA_EXTRATO	 , nColExtTot, lIsProc)	//Monta lista no excel do extrato
		ListarAba( GerarSinte( aLista, nSaldo, @aSinFunc, cTipoRelat, lIsProc, @aRetorno)	, .T., cABA_ACUMULADO	, cABA_ACUMULADO , nColSinTot, lIsProc)	//Monta lista no excel acumulado
		ListarAba( GerarAnali( aLista, nSaldo, @aAnaFunc, cTipoRelat, lIsProc			)	, .T., cABA_COMPOSICAO	, cABA_COMPOSICAO, nColAnatot, lIsProc)	//Monta lista no excel da composição acumulado
		ListarAba( GerarImpVa( aLista, nSaldo, cTipoRelat, lIsProc			 			)	, .F., cABA_IMPORTACAO	, cABA_IMPORTACAO, 11		 , lIsProc)	//Monta lista no excel da importação de variáveis
		Acumular( aExtFunc, @aExtCC , 09, 10)	//Totaliza por centro de custo extrato
		Acumular( aSinFunc, @aSinCC , 00, 08)	//Totaliza por centro de custo sintetico
		Acumular( aAnaFunc, @aAnaCC , 09, 10)	//Totaliza por centro de custo centro de custo

		if 	cTipoRelat == cPERG_BAIXADO .and. cRegraAnt != cREGRA_01
			Totalizar( @aExtFunc, 09, 10, 11, cABA_EXTRATO 		, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o extrato
			Totalizar( @aSinFunc, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o acumulado
			Totalizar( @aAnaFunc, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o composicao do acumulado
			ListarAba( aExtFunc, lSaltaLin, cABA_EXTRATO	,cABA_EXTRATO	, nColExtTot, lIsProc) //Monta lista no excel do extrato
			ListarAba( aAnaFunc, lSaltaLin, cABA_COMPOSICAO	,cABA_COMPOSICAO, nColAnatot, lIsProc) //Monta lista no excel da composição acumulado
		elseif cTipoRelat == cPERG_BANCO_HORAS
			Totalizar( @aExtFunc, 09, 10, 11, cABA_EXTRATO 		, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o extrato
			Totalizar( @aSinFunc, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o acumulado
			Totalizar( @aAnaFunc, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_FUNCIONARIO ) //Totaliza por centro de custo o composicao do acumulado
			ListarAba( aExtFunc, lSaltaLin, cABA_EXTRATO	,cABA_EXTRATO	, nColExtTot, lIsProc) //Monta lista no excel do extrato
			ListarAba( aSinFunc, lSaltaLin, cABA_ACUMULADO	,cABA_ACUMULADO	, nColSinTot, lIsProc) //Monta lista no excel acumulado
			ListarAba( aAnaFunc, lSaltaLin, cABA_COMPOSICAO	,cABA_COMPOSICAO, nColAnatot, lIsProc) //Monta lista no excel da composição acumulado
		endif

		Totalizar(@aExtCC, 09, 10, 11, cABA_EXTRATO 	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o extrato
		Totalizar(@aSinCC, 00, 08, 09, cABA_ACUMULADO 	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o acumulado
		Totalizar(@aAnaCC, 09, 10, 11, cABA_COMPOSICAO	, cTipoRelat, cTOT_CC ) 	//Totaliza por centro de custo o composicao do acumulado
		ListarAba( aExtCC, .T., cABA_EXTRATO	,cABA_EXTRATO	, nColExtTot, lIsProc) 	//Monta lista no excel do extrato
		ListarAba( aSinCC, .T., cABA_ACUMULADO	,cABA_ACUMULADO	, nColSinTot, lIsProc) 	//Monta lista no excel acumulado
		ListarAba( aAnaCC, .T., cABA_COMPOSICAO	,cABA_COMPOSICAO, nColAnatot, lIsProc) 	//Monta lista no excel da composição acumulado

		nSaldoCC := 0   //Zera saldo de centro de custo
		aExtFunc := {}	//Limpa array do extrato de funcionário
		aSinFunc := {}	//Limpa array do sintetico de funcionário
		aAnaFunc := {}	//Limpa array do analitico de funcionário
		aExtCC 	 := {}	//Limpa array do extrato de centro de custo
		aSinCC 	 := {}	//Limpa array do sintetico de centro de custo
		aAnaCC 	 := {}	//Limpa array do analitico de centro de custo
		nSaldo 	 := 0	//Zera saldo de funcionario
		aLista 	 := {}	//Limpa array do funcionario
		aTitulo  := {}  //Limpa array do cabecalho

		if !lIsProc
			GravaExcel( cArquivo ) //Fecha o componente do excel e abre para o usuário manipular.
			msginfo("Arquivo "+cArquivo+" gerado com sucesso.", "Relatório Criado.")
		endif

		(cAlias)->(DbCloseArea()) //Fecha alias temporario da consulta SQL.
	else
		alert("Arquivo não gerado. Verifique parâmetros informados.")
	endif

Return()

/*/{Protheus.doc} GerarExtra
Prepara lista para gerar Excel já formatado e ordernado 1-Data + 2-Evento + 3-Descontos Horas
@param [ aLista ]	 , lista	, Lista do banco de horas por funcionario
@param [ nTotal ]	 , numerico	, Valor total do saldo
@param [ aTotal ]	 , lista	, Lista do banco de horas totalizando
@param [ cTipoRelat ], texto	, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return lista, aRetorno - Lista de banco de horas por funcionário no formato extrato
/*/
Static Function GerarExtra( aLista, nTotal, aTotal, cTipoRelat, lIsProc )
	local aAux 			:= {}	//Array auxiliar
	local aAux2 		:= {}	//Array auxiliar
	local aRetorno 		:= {} 	//Retorno da função com a lista do extrato
	local cTotal 		:= 'Total '	//Descrição da linha de total do funcionário
	local i 			:= 0	//variável de iteração
	local lCalcula 		:= .F.	//verifica se deve calcular registro
	local lTotNegativo 	:= .F.	//verifica se o saldo da lista é negativo
	local lTotPositivo 	:= .F.	//verifica se o saldo da lista é positivo
	local nDif			:= 0	//Valor da diferença para apuração
	local nPos 			:= 0	//posição da busca em lista de centro de custo
	local nSaldo 		:= 0	//Saldo da lista
	local nSaldoCC 		:= 0	//Saldo da lista do centro de custo
	local nSinal 		:= 0	//Sinal do saldo

	default aTotal    	:= {}	//Lista de centro de custo
	default aLista 		:= {}	//Lista do funcionário
	default cTipoRelat  := ''	//Tipo de relatório
	default nTotal 		:= 0	//Saldo total da lista do funcionário
	default lIsProc		:= .F.

	if !empty(aLista) .and. MV_PAR07 == 1 .and. !lIsProc //Escolha Extrato
		for i := 1 to len(aLista)
			lCalcula 		:= .F.
			lTotNegativo 	:= .F.
			if aLista[i][10] $ '1*3' //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
				lCalcula 	:= .T.
				nSinal 		:= 1
				nSaldo 		:= __TimeSum(nSaldo, aLista[i][09] )
			elseif aLista[i][10] $ '2*4' //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
				lCalcula 		:= .T.
				lTotNegativo	:= .T.
				nSinal 			:= -1
				nSaldo 			:= __TimeSub(nSaldo, aLista[i][09] )
			endif

			if lCalcula
				//+--------------------------------------------------+
				//|                   Itens Funcionario              |
				//+--------------------------------------------------+
				aAux := {}
				aAdd(aAux, aLista[i][01]) //01 Filial
				aAdd(aAux, aLista[i][02]) //02 Centro de custo
				aAdd(aAux, aLista[i][03]) //03 Descrição do Centro de custo
				aAdd(aAux, aLista[i][04]) //04 Matrícula
				aAdd(aAux, aLista[i][05]) //05 Nome
				aAdd(aAux, aLista[i][06]) //06 Data em string AAAAMMDD
				aAdd(aAux, aLista[i][07]) //07 Código evento
				aAdd(aAux, aLista[i][08]) //08 Descrição do evento
				aAdd(aAux, replace(StrZero( aLista[i][09]*nSinal, ZeroEsquer(aLista[i][09]*nSinal, lTotNegativo), 2 ),'.',':') ) //09 Horas
				if nSaldo < 0
					lTotNegativo := .T.
					nSinal := -1
				else
					lTotNegativo := .F.
					nSinal := 1
				endif
				aAdd(aAux, replace(StrZero( nSaldo, ZeroEsquer(nSaldo, lTotNegativo), 2 ),'.',':')) //10 - Saldo
				if cTipoRelat == cPERG_BAIXADO
					aAdd(aAux, aLista[i][14]) //14 Regra
					aAdd(aAux, aLista[i][15]) //15 Periodo banco de horas
					aAdd(aAux, aLista[i][16]) //16 Data da baixa
				endif
				aAdd(aRetorno, aAux)

				//+--------------------------------------------------+
				//|                   Totalizar CC                   |
				//+--------------------------------------------------+
				if !empty(aTotal)
					if cTipoRelat == cPERG_BAIXADO
						nPos := aScan(aTotal, {|x| x[07] == aLista[i][07] .and. x[14] == aLista[i][16]})
					else
						nPos := aScan(aTotal, {|x| x[07] == aLista[i][07]})
					endif
				endif
				if nPos == 0
					nSaldoCC := 0
				else
					nSaldoCC := aTotal[nPos][09]
				endif

				if aLista[i][10] $ '1*3' //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					nSaldoCC := __TimeSum(nSaldoCC, aLista[i][09])
				elseif aLista[i][10] $ '2*4' //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					nSaldoCC := __TimeSub(nSaldoCC, aLista[i][09])
				endif

				if nPos == 0
					aAux := {}
					aAdd(aAux, aLista[i][01]	) //01 Filial
					aAdd(aAux, aLista[i][02]	) //02 Centro de custo
					aAdd(aAux, aLista[i][03]	) //03 Descrição do Centro de custo
					aAdd(aAux, aLista[i][04]	) //04 Matrícula
					aAdd(aAux, aLista[i][05]	) //05 Nome
					aAdd(aAux, ''				) //06 Data em string AAAAMMDD
					aAdd(aAux, aLista[i][07]	) //07 Código evento
					aAdd(aAux, cMASK_TOTAL + aLista[i][08]	) //08 Descrição do evento
					aAdd(aAux, nSaldoCC			) //09 Horas
					aAdd(aAux, 0				) //10 - Saldo
					aAdd(aAux, aLista[i][11]	) //11 Percentual em horas extras
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aLista[i][14]) //12 Regra
						aAdd(aAux, aLista[i][15]) //13 Periodo banco de horas
						aAdd(aAux, aLista[i][16]) //14 Data da baixa
					endif
					aAdd(aTotal, aAux)
				else
					aTotal[nPos][09] := nSaldoCC
				endif
			endif
		next i

		if cTipoRelat == cPERG_BAIXADO
			if !empty(aLista)
				if aLista[01][14] == cREGRA_01
					aRetorno := {}
				endif
			endif
		endif

		//+--------------------------------------------------+
		//|                   Totalizar Funcionario          |
		//+--------------------------------------------------+
		aAux := {}
		aAdd(aAux, aLista[01][01]	) //01 Filial
		aAdd(aAux, aLista[01][02]	) //02 Centro de custo
		aAdd(aAux, aLista[01][03]	) //03 Descrição do Centro de custo
		aAdd(aAux, aLista[01][04]	) //04 Matrícula
		aAdd(aAux, aLista[01][05]	) //05 Nome
		aAdd(aAux, ''				) //06 Data em string AAAAMMDD
		aAdd(aAux, ''				) //07 Código evento
		aAdd(aAux, cTotal			) //08 Descrição do evento
		aAdd(aAux, ''				) //09 Horas
		aAdd(aAux, replace(StrZero( nTotal, ZeroEsquer(nTotal, lTotNegativo), 2 ),'.',':')) //10 - Saldo
		if cTipoRelat == cPERG_BAIXADO
			aAdd(aAux, aLista[01][14]) //14 Regra
			aAdd(aAux, aLista[01][15]) //15 Periodo banco de horas
			aAdd(aAux, aLista[01][16]) //16 Data da baixa
		endif
		aAdd(aRetorno, aAux)
	endif

Return(aRetorno)

/*/{Protheus.doc} GerarAnali
Prepara lista para gerar Excel já formatado e ordernado 1-Data + 2-Evento + 3-Descontos, Horas
@param [ aLista ]	 , lista	, Lista do banco de horas por funcionario
@param [ nTotal ]	 , numerico	, Valor total do saldo
@param [ aTotal ]	 , lista	, Lista do banco de horas totalizando
@param [ cTipoRelat ], texto	, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return lista, aRetorno - Lista de banco de horas por funcionário no formato composição acumulado
/*/
Static Function GerarAnali(aLista, nTotal, aTotal, cTipoRelat, lIsProc)
	local aAux 			:= {}	//Array auxiliar
	local aAux2 		:= {}	//Array auxiliar
	local aRetorno 		:= {} 	//Retorno da função com a lista do extrato
	local cTotal 		:= 'Total'	//Descrição da linha de total do funcionário
	local i 			:= 0	//variável de iteração
	local lCalcula 		:= .F.	//verifica se deve calcular registros
	local lTotNegativo 	:= .F.	//verifica se o saldo da lista é negativo
	local lTotPositivo 	:= .F.	//verifica se o saldo da lista é positivo
	local nDif			:= 0	//Valor da diferença para apuração
	local nPos 			:= 0	//posição da busca em lista de centro de custo
	local nSaldo 		:= 0	//Saldo da lista
	local nSaldoAnt 	:= 0	//Saldo da lista anterior
	local nSaldoCC		:= 0	//Saldo da lista de centro de custo
	local nSinal 		:= 0	//Valor do sinal
	local nTam 			:= 0	//Tamanho das casas do campo de valor hora

	default aTotal    	:= {}	//Lista de centro de custo
	default aLista 		:= {}	//Lista do funcionário
	default cTipoRelat	:= ''	//Tipo de relatório
	default nTotal 		:= 0	//Saldo total da lista do funcionário
	default lIsProc		:= .F.

	if !empty(aLista) .and. MV_PAR09 == 1 .and. !lIsProc//Composição acumulado
		if !( cTipoRelat == cPERG_BAIXADO .and. aLista[01][14] == cREGRA_01 )
			if nTotal > 0
				lTotPositivo 	:= .T.
				nSinal 			:= 1
				nTam 			:= 3
			elseif nTotal < 0
				lTotNegativo 	:= .T.
				nSinal 			:= -1
				nTam 			:= 4
			endif
			nSaldo 		:= nTotal
			nSaldoAnt 	:= nSaldo
			for i := len(aLista) to 1 step -1
				lCalcula := .F.

				if aLista[i][10] $ '1*3' .and. lTotPositivo //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSub(nSaldo, aLista[i][09] )
					if nSaldo < 0
						nDif 	:= __TimeSub(nSaldo, nTotal )			// descubro a diferença
						nSaldo 	:= __TimeSum(nSaldo, nDif )				// somo somente a diferença
					endif
				elseif aLista[i][10] $ '2*4'  .and. lTotNegativo
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSum(nSaldo, aLista[i][09] )
					if nSaldo > 0
						nDif 	:= __TimeSub(nSaldo, nTotal )			// descubro a diferença
						nSaldo 	:= __TimeSub(nSaldo, nDif )				// somo somente a diferença
					endif
				endif

				if lCalcula
					//+--------------------------------------------------+
					//|                   Pre - Itens Funcionario        |
					//+--------------------------------------------------+
					aAux := {}
					aAdd(aAux, aLista[i][01]) //01 Filial
					aAdd(aAux, aLista[i][02]) //02 Centro de custo
					aAdd(aAux, aLista[i][03]) //03 Descrição do Centro de custo
					aAdd(aAux, aLista[i][04]) //04 Matrícula
					aAdd(aAux, aLista[i][05]) //05 Nome
					aAdd(aAux, aLista[i][06]) //06 Data em string AAAAMMDD
					aAdd(aAux, aLista[i][07]) //07 Código evento
					aAdd(aAux, aLista[i][08]) //08 Descrição do evento
					if nDif != 0
						aAdd(aAux, replace(StrZero( nSaldoAnt, ZeroEsquer(nSaldoAnt, lTotNegativo), 2 ),'.',':') ) //09 Horas
					else
						aAdd(aAux, replace(StrZero( aLista[i][09]*nSinal, ZeroEsquer(aLista[i][09]*nSinal, lTotNegativo), 2 ),'.',':') ) //09 Horas
					endif
					aAdd(aAux, replace(StrZero( nSaldoAnt, ZeroEsquer(nSaldoAnt, lTotNegativo), 2 ),'.',':')) //10 Saldo
					aAdd(aAux, aLista[i][11]) //11 Percentual em horas extras
					if nDif != 0
						aAdd( aAux, nSaldoAnt ) //12 Horas
					else
						aAdd( aAux, aLista[i][09]*nSinal ) //12 Horas
					endif
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aLista[i][14]) //13 Regra
						aAdd(aAux, aLista[i][15]) //14 Periodo banco de horas
						aAdd(aAux, aLista[i][16]) //15 Data da baixa
					endif
					aAdd(aAux2, aAux)
					nSaldoAnt 		:=	nSaldo
				endif

				if nDif != 0
					exit
				endif
			next i

			aSort(aAux2, , , {|x, y| dtos(ctod(x[6])) + StrZero(x[11],3) < dtos(ctod(y[6]))+ StrZero(y[11],3) })
			for i := 1 to len(aAux2)
				//+--------------------------------------------------+
				//|                   Itens Funcionario              |
				//+--------------------------------------------------+
				aAux := {}
				aAdd(aAux, aAux2[i][01])	//01 Filial
				aAdd(aAux, aAux2[i][02])	//02 Centro de custo
				aAdd(aAux, aAux2[i][03])	//03 Descrição do Centro de custo
				aAdd(aAux, aAux2[i][04])	//04 Matrícula
				aAdd(aAux, aAux2[i][05])	//05 Nome
				aAdd(aAux, aAux2[i][06])	//06 Data em string AAAAMMDD
				aAdd(aAux, aAux2[i][07])	//07 Código evento
				aAdd(aAux, aAux2[i][08])	//08 Descrição do evento
				aAdd(aAux, aAux2[i][09])	//09 Horas
				aAdd(aAux, aAux2[i][10])	//10 Saldo
				if cTipoRelat == cPERG_BAIXADO
					aAdd(aAux, aAux2[i][13]) //11 Regra
					aAdd(aAux, aAux2[i][14]) //12 Periodo banco de horas
					aAdd(aAux, aAux2[i][15]) //13 Data da baixa
				endif
				aAdd(aRetorno, aAux)

				//+--------------------------------------------------+
				//|                   Totalizar CC                   |
				//+--------------------------------------------------+
				nPos := 0
				if !empty(aTotal)
					nPos := aScan(aTotal, {|x| x[7] == aAux2[i][7]})
				endif
				if nPos == 0
					nSaldoCC := 0
				else
					nSaldoCC := aTotal[nPos][9]
				endif
				nSaldoCC := __TimeSum(nSaldoCC, aAux2[i][12])

				if nPos == 0
					aAux := {}
					aAdd(aAux, aAux2[i][1])				//01 Filial
					aAdd(aAux, aAux2[i][2])				//02 Centro de custo
					aAdd(aAux, aAux2[i][3])				//03 Descrição do Centro de custo
					aAdd(aAux, '')						//04 Matrícula
					aAdd(aAux, '')						//05 Nome
					aAdd(aAux, ''		   )			//06 Data em string AAAAMMDD
					aAdd(aAux, aAux2[i][7])				//07 Código evento
					aAdd(aAux, cMASK_TOTAL + aAux2[i][8])	//08 Descrição do evento
					aAdd(aAux, nSaldoCC)				//09 Horas
					aAdd(aAux, 0)						//10 Saldo
					aAdd(aAux, aAux2[i][11])			//11 Percentual em horas extras
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aAux2[i][13]) //12 Regra
						aAdd(aAux, aAux2[i][14]) //13 Periodo banco de horas
						aAdd(aAux, aAux2[i][15]) //14 Data da baixa
					endif
					aAdd(aTotal, aAux)
				else
					aTotal[nPos][9] := nSaldoCC
				endif
			next i

			//+--------------------------------------------------+
			//|                   Totalizar Funcionario          |
			//+--------------------------------------------------+
			aAux := {}
			aAdd(aAux, aLista[01][1]) //01 Filial
			aAdd(aAux, aLista[01][2]) //02 Centro de custo
			aAdd(aAux, aLista[01][3]) //03 Descrição do Centro de custo
			aAdd(aAux, aLista[01][4]) //04 Matrícula
			aAdd(aAux, aLista[01][5]) //05 Nome
			aAdd(aAux, '') 			 //06 Data em string AAAAMMDD
			aAdd(aAux, '') 			 //07 Código evento
			aAdd(aAux, cTotal) 		 //08 Descrição do evento
			aAdd(aAux, '') 			 //09 Horas
			aAdd(aAux, replace(StrZero( nTotal, ZeroEsquer(nTotal, lTotNegativo), 2 ),'.',':')) //10 Saldo
			if cTipoRelat == cPERG_BAIXADO
				aAdd(aAux, aLista[01][14]) //11 Regra
				aAdd(aAux, aLista[01][15]) //12 Periodo banco de horas
				aAdd(aAux, aLista[01][16]) //13 Data da baixa
			endif
			aAdd(aRetorno, aAux)
		endif
	endif
Return(aRetorno)

/*/{Protheus.doc} GerarSinte
Prepara lista para gerar Excel já formatado e ordernado 1-Data + 2-Evento + 3-Descontos, Horas
@param [ aLista ]	 , lista	, Lista do banco de horas por funcionario
@param [ nTotal ]	 , numerico	, Valor total do saldo
@param [ aTotal ]	 , lista	, Lista do banco de horas totalizando
@param [ cTipoRelat ], texto	, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return lista, aRetorno - Lista de banco de horas por funcionário no formato acumulado
/*/
Static Function GerarSinte(aLista, nTotal, aTotal, cTipoRelat, lIsProc, aFechament)
	local aAux 			:= {}	//Array auxiliar
	local aAux2 		:= {}	//Array auxiliar
	local aRetorno 		:= {} 	//Retorno da função com a lista do extrato
	local cTotal		:= 'Total'	//Descrição da linha de total do funcionário
	local i 			:= 0	//variável de iteração
	local lCalcula 		:= .F.	//verifica se deve calcular registros
	local lTotNegativo 	:= .F.	//verifica se o saldo da lista é negativo
	local lTotPositivo 	:= .F.	//verifica se o saldo da lista é positivo
	local nDif			:= 0	//Valor da diferença para apuração
	local nPos 			:= 0	//posição da busca em lista de centro de custo
	local nSaldo 		:= 0	//Saldo da lista
	local nSaldoTotal	:= 0	//Saldo da lista total

	default aTotal		:= {}	//Lista de centro de custo
	default aLista		:= {}	//Lista do funcionário
	default cTipoRelat	:= ''	//Tipo de relatório
	default nTotal 		:= 0	//Saldo total da lista do funcionários
	default lIsProc		:= .F.
	default aFechament	:= {}

	if !empty(aLista) .and. MV_PAR08 == 1
		if nTotal > 0
			lTotPositivo := .T.
		elseif nTotal < 0
			lTotNegativo := .T.
		endif

		for i := len(aLista) to 1 step -1
			aAux := {}
			nPos := aScan(aAux2, {|x| x[06] == aLista[i][07]})
			if nPos == 0
				nSaldo := 0
			else
				nSaldo := aAux2[nPos][08]
			endif

			lCalcula := .F.
			if nSaldoTotal - nTotal != 0
				if aLista[i][10] $ '1*3' .and. lTotPositivo //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSum(nSaldo		, aLista[i][09] )
					nSaldoTotal := __TimeSum(nSaldoTotal, aLista[i][09] )
					if nSaldoTotal > nTotal
						nDif 		:= __TimeSub(nSaldoTotal, nTotal )	// descubro a diferença
						nSaldo 		:= __TimeSub(nSaldo		, nDif   )	// somo somente a diferença
						nSaldoTotal := __TimeSub(nSaldoTotal, nDif   )	// somo somente a diferença
					endif
				elseif aLista[i][10] $ '2*4'  .and. lTotNegativo //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSub(nSaldo		, aLista[i][09] )
					nSaldoTotal := __TimeSub(nSaldoTotal, aLista[i][09] )
					if nSaldoTotal < nTotal
						nDif 		:= __TimeSub(nSaldoTotal, nTotal )	// descubro a diferença
						nSaldo 		:= __TimeSub(nSaldo		, nDif 	 )	// somo somente a diferença
						nSaldoTotal := __TimeSub(nSaldoTotal, nDif 	 )	// somo somente a diferença
					endif
				endif
			endif

			if lCalcula
				//+--------------------------------------------------+
				//|                   Pre - Itens Funcionario        |
				//+--------------------------------------------------+
				if nPos == 0
					aAdd(aAux, aLista[i][01])	//01 Filial
					aAdd(aAux, aLista[i][02])	//02 Centro de custo
					aAdd(aAux, aLista[i][03]) 	//03 Descrição do Centro de custo
					aAdd(aAux, aLista[i][04])	//04 Matrícula
					aAdd(aAux, aLista[i][05])	//05 Nome
					aAdd(aAux, aLista[i][07]) 	//06 Código evento
					aAdd(aAux, aLista[i][08])	//07 Descrição do evento
					aAdd(aAux, nSaldo) 		 	//08 Saldo
					aAdd(aAux, aLista[i][11]) 	//09 Percentual em horas extras
					aAdd(aAux, aLista[i][10]) 	//10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aLista[i][14]) //11 Regra
						aAdd(aAux, aLista[i][15]) //12 Periodo banco de horas
						aAdd(aAux, aLista[i][16]) //13 Data da baixa
					endif
					if lIsProc
						aAdd(aAux, aLista[i][12]) //11 - 14 Verba
					endif
					aAdd(aAux2, aAux)
				else
					aAux2[nPos][8] := nSaldo
				endif
			endif

			if nSaldoTotal == nTotal
				exit
			endif
		next i

		aSort(aAux2, , , {|x, y| x[09] < y[09]})
		for i := 1 to len(aAux2)
			aAux 	:= {}
			nSaldo 	:= aAux2[i][08]
			nPos 	:= 0
			//+--------------------------------------------------+
			//|                   Totalizar CC                   |
			//+--------------------------------------------------+
			if !empty(aTotal)
				nPos := aScan(aTotal, {|x| x[06] == aAux2[i][06]})
			endif
			if nPos == 0
				nSaldoCC := 0
			else
				nSaldoCC := aTotal[nPos][08]
			endif
			nSaldoCC := __TimeSum(nSaldoCC, nSaldo)

			if nPos == 0
				aAux := {}
				aAdd(aAux, aAux2[i][01])	//01 Filial
				aAdd(aAux, aAux2[i][02])	//02 Centro de custo
				aAdd(aAux, aAux2[i][03])	//03 Descrição do Centro de custo
				aAdd(aAux, aAux2[i][04])	//04 Matrícula
				aAdd(aAux, aAux2[i][05])	//05 Nome
				aAdd(aAux, aAux2[i][06])	//06 Código evento
				aAdd(aAux, cMASK_TOTAL + aAux2[i][07])	//07 Descrição do evento
				aAdd(aAux, nSaldoCC)	//08 Saldo
				aAdd(aAux, aAux2[i][09])//09 Percentual em horas extras
				if cTipoRelat == cPERG_BAIXADO
					aAdd(aAux, aAux2[i][11]) //10 Regra
					aAdd(aAux, aAux2[i][12]) //11 Periodo banco de horas
					aAdd(aAux, aAux2[i][13]) //12 Data da baixa
				endif
				aAdd(aTotal, aAux)
			else
				aTotal[nPos][08] := nSaldoCC
			endif

			//+--------------------------------------------------+
			//|                   Itens Funcionario              |
			//+--------------------------------------------------+
			aAux2[i][08] := replace(StrZero( nSaldo, ZeroEsquer(nSaldo, lTotNegativo), 2 ),'.',':')
			aAux := {}
			aAdd(aAux, aAux2[i][01])	//01 Filial
			aAdd(aAux, aAux2[i][02])	//02 Centro de custo
			aAdd(aAux, aAux2[i][03])	//03 Descrição do Centro de custo
			aAdd(aAux, aAux2[i][04])	//04 Matrícula
			aAdd(aAux, aAux2[i][05])	//05 Nome
			aAdd(aAux, aAux2[i][06])	//06 Código evento
			aAdd(aAux, aAux2[i][07])	//07 Descrição do evento
			aAdd(aAux, aAux2[i][08])	//08 Saldo
			if cTipoRelat == cPERG_BAIXADO
				aAdd(aAux, aAux2[i][11]) //11 Regra
				aAdd(aAux, aAux2[i][12]) //12 Periodo banco de horas
				aAdd(aAux, aAux2[i][13]) //13 Data da baixa
			endif
			if lIsProc
				aAdd(aAux, aAux2[i][11]) //09 - 14 Verba
			endif
			aAdd(aRetorno, aAux)
		next i

		if lIsProc
			aAdd( aFechament, aClone( aRetorno ) )
		endif

		if cTipoRelat == cPERG_BAIXADO
			if !empty(aAux2)
				if aAux2[01][11] == cREGRA_01
					aRetorno := {}
				endif
			endif
		endif

		if !empty(aAux2)
			//+--------------------------------------------------+
			//|                   Totalizar Funcionario          |
			//+--------------------------------------------------+
			aAux := {}
			aAdd(aAux, aAux2[01][01]	)	//01 Filial
			aAdd(aAux, aAux2[01][02]	)	//02 Centro de custo
			aAdd(aAux, aAux2[01][03]	)	//03 Descrição do Centro de custo
			aAdd(aAux, aAux2[01][04]	)	//04 Matrícula
			aAdd(aAux, aAux2[01][05]	)	//05 Nome
			aAdd(aAux, ''			)	//06 Código evento
			aAdd(aAux, cTotal		)	//07 Descrição do evento
			aAdd(aAux, replace(StrZero( nTotal, ZeroEsquer(nTotal, lTotNegativo), 2 ),'.',':')) //08 Saldo
			if cTipoRelat == cPERG_BAIXADO
				aAdd(aAux, aAux2[01][11]) //11 Regra
				aAdd(aAux, aAux2[01][12]) //12 Periodo banco de horas
				aAdd(aAux, aAux2[01][13]) //13 Data da baixa
			endif
			aAdd(aRetorno, aAux)
		endif
	endif
Return(aRetorno)

/*/{Protheus.doc} GerarImpVa
Prepara lista para gerar Excel já formatado e ordernado 1-Data + 2-Evento + 3-Descontos, Horas
@param [ aLista ]	 , lista	, Lista do banco de horas por funcionario
@param [ nTotal ]	 , numerico	, Valor total do saldo
@param [ cTipoRelat ], texto	, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return lista, aRetorno - Lista de banco de horas por funcionário no formato importaçãod e variáveis
/*/
Static Function GerarImpVa(aLista, nTotal, cTipoRelat, lIsProc )
	local aAux 			:= {}	//Array auxiliar
	local aAux2 		:= {}	//Array auxiliar
	local aRetorno 		:= {} 	//Retorno da função com a lista do extrato
	local cSaldo		:= ''	//Saldo da lista
	local i 			:= 0	//variável de iteração
	local lCalcula 		:= .F.	//verifica se deve calcular registros
	local lGerarImp		:= .F.
	local lTotNegativo 	:= .F.	//verifica se o saldo da lista é negativos
	local lTotPositivo 	:= .F.	//verifica se o saldo da lista é positivo
	local nDif			:= 0	//Valor da diferença para apuração
	local nPos 			:= 0	//posição da busca em lista de centro de custo
	local nSaldo 		:= 0	//Saldo da lista
	local nSaldoTotal	:= 0	//Saldo da lista total

	default aLista		:= {}	//Lista do funcionários
	default nTotal 		:= 0	//Saldo total da lista do funcionários
	default cTipoRelat	:= '' 	//Tipo de relatório
	default lIsProc		:= .F.

	lGerarImp		:= iif( cTipoRelat == cPERG_BANCO_HORAS, MV_PAR10 == 1, .F. )

	if !empty(aLista) .and. lGerarImp
		if nTotal > 0
			lTotPositivo := .T.
		elseif nTotal < 0
			lTotNegativo := .T.
		endif

		for i := len(aLista) to 1 step -1
			aAux := {}

			nPos := aScan(aAux2, {|x| x[10] == aLista[i][12]})
			if nPos == 0
				nSaldo := 0
			else
				nSaldo := aAux2[nPos][8]
			endif

			lCalcula := .F.
			if nSaldoTotal - nTotal != 0
				if aLista[i][10] $ '1*3' .and. lTotPositivo //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSum(nSaldo, aLista[i][9] )
					nSaldoTotal := __TimeSum(nSaldoTotal, aLista[i][9] )
					if nSaldoTotal > nTotal
						nDif 		:= __TimeSub(nSaldoTotal, nTotal )	// descubro a diferença
						nSaldo 		:= __TimeSub(nSaldo, nDif )			// somo somente a diferença
						nSaldoTotal := __TimeSub(nSaldoTotal, nDif )	// somo somente a diferença
					endif
				elseif aLista[i][10] $ '2*4'  .and. lTotNegativo //10 Tipo do evento 1 e 3 - Provento, 2 e 4 desconto.
					lCalcula 	:= .T.
					nSaldo 		:= __TimeSub(nSaldo, aLista[i][9] )
					nSaldoTotal := __TimeSub(nSaldoTotal, aLista[i][9] )
					if nSaldoTotal < nTotal
						nDif 		:= __TimeSub(nSaldoTotal, nTotal )	// descubro a diferença
						nSaldo 		:= __TimeSub(nSaldo, nDif )			// somo somente a diferença
						nSaldoTotal := __TimeSub(nSaldoTotal, nDif )	// somo somente a diferença
					endif
				endif
			endif

			if lCalcula
				if nPos == 0
					//+--------------------------------------------------+
					//|                   Itens Funcionario              |
					//+--------------------------------------------------+
					aAdd(aAux, aLista[i][01])	//01 Filial
					aAdd(aAux, aLista[i][02])	//02 Centro de custo
					aAdd(aAux, aLista[i][03]) 	//03 Descrição do Centro de custo
					aAdd(aAux, aLista[i][04]) 	//04 Matrícula
					aAdd(aAux, aLista[i][05]) 	//05 Nome
					aAdd(aAux, aLista[i][07]) 	//06 Código evento
					aAdd(aAux, aLista[i][08])	//07 Descrição do evento
					aAdd(aAux, nSaldo		) 	//08 Saldo
					aAdd(aAux, aLista[i][11]) 	//09 Percentual em horas extras
					aAdd(aAux, aLista[i][12]) 	//10 Código Verba
					aAdd(aAux, aLista[i][13]) 	//11 Descrição Código da Verba
					aAdd(aAux2, aAux)
				else
					aAux2[nPos][8] := nSaldo
				endif
			endif
			if nSaldoTotal == nTotal
				exit
			endif
		next i

		aSort(aAux2, , , {|x, y| x[9] < y[9]})
		for i := 1 to len(aAux2)
			aAux 		 := {}
			nSaldo 		 := aAux2[i][8]
			cSaldo 		 := replace(StrZero( nSaldo, ZeroEsquer(nSaldo, lTotNegativo), 2 ),'.',':')

			//+--------------------------------------------------+
			//|                   Totalizar Funcionario          |
			//+--------------------------------------------------+
			aAdd(aAux, aAux2[i][1] + aAux2[i][4] + aAux2[i][10] + strZero( ABS( aAux2[i][8]), 6, 2 ) )//Filial+Matrícula+Verba+Horas
			aAdd(aAux, aAux2[i][01])	//02 Filial
			aAdd(aAux, aAux2[i][02])	//03 Centro de custo
			aAdd(aAux, aAux2[i][03])	//04 Descrição do Centro de custo
			aAdd(aAux, aAux2[i][04])	//05 Matrícula
			aAdd(aAux, aAux2[i][05])	//06 Nome
			aAdd(aAux, aAux2[i][06])	//07 Código evento
			aAdd(aAux, aAux2[i][07])	//08 Descrição do evento
			aAdd(aAux, cSaldo	   )	//09 Saldo
			aAdd(aAux, aAux2[i][10])	//10 Código Verba
			aAdd(aAux, aAux2[i][11])	//11 Descrição Código da Verba

			aAdd(aRetorno, aAux)
		next i
	endif
Return(aRetorno)

/*/{Protheus.doc} MontarQry
Retorna query da busca do relatório em string SQL
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return texto, cRetorno - Query no formato SQL para realizar busca na tabela de banco de horas
/*/
Static Function MontarQry(cTipoRelat)
	local cRetorno 		:= ''	//Query do retorno
	local cFilialDe		:= ''	//Paramtro Filial De?
	local cFilialAte 	:= ''	//Paramtro Filial Ate?
	local cCcDe 	 	:= ''	//Paramtro Centro de Custo De?
	local cCcAte 		:= ''	//Paramtro Centro de Custo Ate?
	local cMatDe 		:= ''	//Paramtro Matrícula De?
	local cMatAte 		:= ''	//Paramtro Matrícula Ate?
	local cDataDe 		:= ''	//Paramtro Data De?
	local cDataAte 		:= ''	//Paramtro Data Ate?
	local cRegraDe 		:= ''
	local cRegraAte 	:= ''
	local cPerioDe 		:= ''
	local cPerioAte 	:= ''

	default cTipoRelat 	:= ''	//Tipo de relatório

	if cTipoRelat == cPERG_BANCO_HORAS
		cFilialDe 	:= MV_PAR01
		cFilialAte 	:= MV_PAR02
		cCcDe 		:= MV_PAR03
		cCcAte 		:= MV_PAR04
		cMatDe 		:= MV_PAR05
		cMatAte 	:= MV_PAR06
		cDataDe 	:= dtos(MV_PAR12)
		cDataAte	:= dtos(MV_PAR13)

		cRetorno := " SELECT PI_FILIAL AS FILIAL , "
		cRetorno += "        RA_CC AS COD_CUSTO , "
		cRetorno += "        CTT_DESC01 AS DES_CUSTO , "
		cRetorno += "        PI_MAT AS MATRICULA , "
		cRetorno += "        RA_NOME AS NOME , "
		cRetorno += "        PI_DATA AS DATA , "
		cRetorno += "        PI_PD AS EVENTO , "
		cRetorno += "        P9_DESC AS DES_EVENTO ,  "
		cRetorno += "        PI_QUANT AS HORAS ,  "
		cRetorno += "        P9_TIPOCOD AS TIPO_EVENTO,  "
		cRetorno += "        P9_CODFOL AS CODIGO_FOLHA,  "
		cRetorno += "        RV_DESC AS DES_CODIGO_FOLHA,  "
		cRetorno += " 	   	 ISNULL(P4_PERCENT, 0) AS PERCENTUAL_HORA_EXTRA  "
		cRetorno += " FROM "+RetSqlName("SPI")+" SPI "
		cRetorno += " INNER JOIN "+RetSqlName("SRA")+" SRA ON "
		cRetorno += " 	PI_FILIAL = RA_FILIAL "
		cRetorno += " 	AND PI_MAT = RA_MAT AND SRA.D_E_L_E_T_ <> '*' "
		cRetorno += " INNER JOIN "+RetSqlName("CTT")+" CTT ON  "
		cRetorno += " 	CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "
		cRetorno += " INNER JOIN "+RetSqlName("SP9")+" SP9 ON  "
		cRetorno += " 	P9_CODIGO = PI_PD AND SP9.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("SP4")+" SP4 ON  "
		cRetorno += " 	P4_FILIAL = PI_FILIAL  "
		cRetorno += " 	AND (P4_CODNAUT = PI_PD OR P4_CODAUT = PI_PD) "
		cRetorno += " 	AND SP4.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("SRV")+" SRV ON  "
		cRetorno += " 	P9_CODFOL = RV_COD  "
		cRetorno += " 	AND SRV.D_E_L_E_T_ <> '*' "
		cRetorno += " WHERE  "
		cRetorno += " 	SPI.D_E_L_E_T_ <> '*' "
		cRetorno += " 	AND PI_STATUS <> 'B' "
		cRetorno += " 	AND PI_DATA >= '20171116' "
		cRetorno += " 	AND PI_FILIAL 	BETWEEN '" + cFilialDe + "' AND '" + cFilialAte + "' "
		cRetorno += " 	AND RA_CC 		BETWEEN '" + cCcDe + "' AND '" + cCcAte + "' "
		cRetorno += " 	AND PI_MAT 		BETWEEN '" + cMatDe + "' AND '" + cMatAte + "' "
		if MV_PAR11 == 2 //1 - Todo o período ; 2 - Intervalo
			cRetorno += " 	AND PI_DATA 	BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' "
		endif
		cRetorno += " GROUP BY "
		cRetorno += " 		PI_FILIAL, "
		cRetorno += "        RA_CC, "
		cRetorno += "        CTT_DESC01, "
		cRetorno += "        PI_MAT, "
		cRetorno += "        RA_NOME, "
		cRetorno += "        PI_DATA, "
		cRetorno += "        PI_PD, "
		cRetorno += "        P9_DESC,  "
		cRetorno += "        PI_QUANT,  "
		cRetorno += "        P9_TIPOCOD,  "
		cRetorno += "        P9_CODFOL, "
		cRetorno += "        RV_DESC, "
		cRetorno += " 	   	 ISNULL(P4_PERCENT, 0) "
		cRetorno += " ORDER BY  "
		cRetorno += " 	PI_FILIAL, "
		cRetorno += " 	RA_CC, "
		cRetorno += " 	PI_MAT, "
		cRetorno += " 	PI_DATA, "
		cRetorno += " 	PERCENTUAL_HORA_EXTRA "
	elseif cTipoRelat == cPERG_BAIXADO
		cFilialDe 	:= MV_PAR01
		cFilialAte 	:= MV_PAR02
		cCcDe 		:= MV_PAR03
		cCcAte 		:= MV_PAR04
		cMatDe 		:= MV_PAR05
		cMatAte 	:= MV_PAR06
		cRegraDe 	:= MV_PAR10
		cRegraAte 	:= MV_PAR11
		cPerioDe 	:= MV_PAR12
		cPerioAte 	:= MV_PAR13

		cRetorno := " SELECT PI_FILIAL 	AS FILIAL , "
		cRetorno += "        RA_CC 		AS COD_CUSTO , "
		cRetorno += "        CTT_DESC01 AS DES_CUSTO , "
		cRetorno += "        PI_MAT 	AS MATRICULA , "
		cRetorno += "        RA_NOME 	AS NOME , "
		cRetorno += "        PI_DATA 	AS DATA , "
		cRetorno += "        PI_PD 		AS EVENTO , "
		cRetorno += "        P9_DESC 	AS DES_EVENTO ,  "
		cRetorno += "        PI_QUANT 	AS HORAS ,  "
		cRetorno += "        P9_TIPOCOD AS TIPO_EVENTO,  "
		cRetorno += "        P9_CODFOL 	AS CODIGO_FOLHA,  "
		cRetorno += "        RV_DESC 	AS DES_CODIGO_FOLHA,  "
		cRetorno += " 	   	 ISNULL(P4_PERCENT, 0) AS PERCENTUAL_HORA_EXTRA,  "
		cRetorno += " 	   	 X5_DESCRI 	AS REGRA,
		cRetorno += " 	   	 SUBSTR( RCC_CONTEU, 3, 16 )  AS PERBH,
		cRetorno += " 	   	 PI_DTBAIX  AS BAIXA
		cRetorno += " FROM "+RetSqlName("SPI")+" SPI "
		cRetorno += " INNER JOIN "+RetSqlName("SRA")+" SRA ON "
		cRetorno += " 	PI_FILIAL = RA_FILIAL "
		cRetorno += " 	AND PI_MAT = RA_MAT AND SRA.D_E_L_E_T_ <> '*' "
		cRetorno += " INNER JOIN "+RetSqlName("CTT")+" CTT ON  "
		cRetorno += " 	CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "
		cRetorno += " INNER JOIN "+RetSqlName("SP9")+" SP9 ON  "
		cRetorno += " 	P9_CODIGO = PI_PD AND SP9.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("SP4")+" SP4 ON  "
		cRetorno += " 	P4_FILIAL = PI_FILIAL  "
		cRetorno += " 	AND (P4_CODNAUT = PI_PD OR P4_CODAUT = PI_PD) "
		cRetorno += " 	AND SP4.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("SRV")+" SRV ON  "
		cRetorno += " 	P9_CODFOL = RV_COD  "
		cRetorno += " 	AND SRV.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("SX5")+" SX5 ON  "
		cRetorno += " 	X5_TABELA = '"+cSX5_REGRA+"' "
		cRetorno += " 	AND X5_FILIAL = PI_FILIAL "
		cRetorno += " 	AND X5_CHAVE = PI_POLITIC "
		cRetorno += " 	AND SX5.D_E_L_E_T_ <> '*' "
		cRetorno += " LEFT JOIN "+RetSqlName("RCC")+" RCC ON "
		cRetorno += " 	RCC.D_E_L_E_T_ = ' ' "
		cRetorno += " 	AND RCC_CODIGO = 'U00A' "
		cRetorno += " 	AND RCC_SEQUEN = PI_PERIOD "
		cRetorno += " WHERE  "
		cRetorno += " 	SPI.D_E_L_E_T_ <> '*' "
		cRetorno += " 	AND PI_STATUS = 'B' "
		cRetorno += " 	AND PI_FILIAL 	BETWEEN '" + cFilialDe 	+ "' AND '" + cFilialAte + "' "
		cRetorno += " 	AND RA_CC 		BETWEEN '" + cCcDe 		+ "' AND '" + cCcAte 	 + "' "
		cRetorno += " 	AND PI_MAT 		BETWEEN '" + cMatDe 	+ "' AND '" + cMatAte 	 + "' "
		cRetorno += " 	AND PI_POLITIC	BETWEEN '" + cRegraDe   + "' AND '" + cRegraAte + "' "
		cRetorno += " 	AND PI_PERIOD 	BETWEEN '" + cPerioDe   + "' AND '" + cPerioAte + "' "
		cRetorno += " GROUP BY "
		cRetorno += " 	PI_FILIAL, "
		cRetorno += "   RA_CC, "
		cRetorno += "   CTT_DESC01, "
		cRetorno += "   PI_MAT, "
		cRetorno += "   RA_NOME, "
		cRetorno += "   PI_DATA, "
		cRetorno += "   PI_PD, "
		cRetorno += "   P9_DESC,  "
		cRetorno += "   PI_QUANT,  "
		cRetorno += "   P9_TIPOCOD,  "
		cRetorno += "   P9_CODFOL, "
		cRetorno += "   RV_DESC, "
		cRetorno += "   ISNULL(P4_PERCENT, 0), "
		cRetorno += " 	X5_DESCRI, "
		cRetorno += " 	SUBSTR( RCC_CONTEU, 3, 16 ), "
		cRetorno += " 	PI_DTBAIX "
		cRetorno += " ORDER BY  "
		cRetorno += " 	PI_DTBAIX, "
		cRetorno += " 	PI_FILIAL, "
		cRetorno += " 	RA_CC, "
		cRetorno += " 	PI_MAT, "
		cRetorno += " 	PI_DATA, "
		cRetorno += " 	PERCENTUAL_HORA_EXTRA "
	endif
Return cRetorno

/*/{Protheus.doc} CabCompAcu
Monta Planilha, Tabela e Coluna do reatório composição do acumulado
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function CabCompAcu( cTipoRelat, lIsProc )
	default cTipoRelat := ''	//Tipo de relatório
	default lIsProc	   := .F.

	if MV_PAR09 == 1 .and. !lIsProc //Composição acumulado
		//Monta Aba
		//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
		oFWMsExcel:AddworkSheet(cABA_COMPOSICAO)

		//Criando a Tabela
		//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
		oFWMsExcel:AddTable( cABA_COMPOSICAO, cABA_COMPOSICAO)

		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Filial"			,1) //1
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Centro de Custo",1) //2
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Descrição"		,1) //3
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Matrícula"		,1) //4
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Nome"			,1)	//5
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Data"			,1)	//6
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Evento"			,1)	//7
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Descrição"		,1)	//8
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Horas"			,1)	//9
		oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Saldo"			,1)	//10
		if cTipoRelat == cPERG_BAIXADO
			oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Regra"					  ,1)	//11
			oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Período do Banco de Horas",1)	//12
			oFWMsExcel:AddColumn(cABA_COMPOSICAO, cABA_COMPOSICAO, "Data Baixa"				  ,1)	//13
		endif
	endif
Return

/*/{Protheus.doc} CabAcumula
Monta Planilha, Tabela e Coluna do reatório acumulado
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function CabAcumula( cTipoRelat, lIsProc )
	default cTipoRelat := ''	//Tipo de relatório
	default lIsProc    := .F.

	if MV_PAR08 == 1 .and. !lIsProc//Acumulado
		//Monta Aba
		//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
		oFWMsExcel:AddworkSheet( cABA_ACUMULADO )

		//Criando a Tabela
		//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
		oFWMsExcel:AddTable( cABA_ACUMULADO, cABA_ACUMULADO )

		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Filial"			,1 ) //1
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Centro de Custo"	,1 ) //2
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Descrição"		,1 ) //3
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Matrícula"		,1 ) //4
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Nome"			,1 ) //5
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Evento"			,1 ) //6
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Descrição"		,1 ) //7
		oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Saldo"			,1 ) //8
		if cTipoRelat == cPERG_BAIXADO
			oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Regra"						,1 ) //09
			oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Período do Banco de Horas"	,1 ) //10
			oFWMsExcel:AddColumn( cABA_ACUMULADO, cABA_ACUMULADO, "Baixa"	,1 ) //11
		endif
	endif
Return

/*/{Protheus.doc} CabExtrato
Monta Planilha, Tabela e Coluna do reatório extrato
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function CabExtrato( cTipoRelat, lIsProc )
 	default cTipoRelat := ''	//Tipo de relatório
 	default lIsProc := .F.

 	if MV_PAR07 == 1 .and. !lIsProc //Extrato
		//Monta Aba
		//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
		oFWMsExcel:AddworkSheet( cABA_EXTRATO )

		//Criando a Tabela
		//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
		oFWMsExcel:AddTable( cABA_EXTRATO, cABA_EXTRATO )

		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Filial"			,1) //01
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Centro de Custo" ,1) //02
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Descrição"		,1) //03
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Matrícula"		,1) //04
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Nome"			,1) //05
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Data"			,1) //06
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Evento"			,1) //07
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Descrição"		,1) //08
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Horas"			,1) //09
		oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Saldo"			,1) //10
		if cTipoRelat == cPERG_BAIXADO
			oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Regra"					  ,1) //11
			oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Período do Banco de Horas" ,1) //12
			oFWMsExcel:AddColumn( cABA_EXTRATO, cABA_EXTRATO, "Data Baixa"				  ,1) //13
		endif
	endif
Return

/*/{Protheus.doc} CabImpVari
Monta Planilha, Tabela e Coluna do reatório importação de variáveis
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function CabImpVari( cTipoRelat, lIsProc )
	local lGerarImp := .F.	//Valida se imprime relatório

	default cTipoRelat := ''	//Tipo de relatório
	default lIsProc	   := .F.

	lGerarImp := iif( cTipoRelat == cPERG_BANCO_HORAS, MV_PAR10 == 1, .F.)

 	if lGerarImp .and. !lIsProc //Importação de Variáveis
 		//Monta Aba
 		//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
		oFWMsExcel:AddworkSheet( cABA_IMPORTACAO )

		//Criando a Tabela
		//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
		oFWMsExcel:AddTable( cABA_IMPORTACAO, cABA_IMPORTACAO )

		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Campo de importação"	,1) //01
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Filial"				,1) //02
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Centro de Custo"		,1) //03
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Descrição"				,1) //04
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Matrícula"				,1) //05
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Nome"					,1)	//06
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Evento"				,1)	//07
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Descrição"				,1)	//08
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Saldo"					,1)	//09
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Verba"					,1)	//10
		oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Descrição"				,1)	//11
		if cTipoRelat == cPERG_BAIXADO
			oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Regra"						,1)	//11
			oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Período do Banco de Horas"	,1)	//12
			oFWMsExcel:AddColumn( cABA_IMPORTACAO, cABA_IMPORTACAO, "Data Baixa"				,1)	//13
		endif
	endif
Return

/*/{Protheus.doc} GravaExcel
Executa integrção com Excel
@type function
@author BrunoNunes
@since 19/01/2018
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
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function ListarAba( aLista, lVazio, cSheet, cTable, nTam, lIsProc)
	local i := 0	//Variavel de iteração

	default aLista 	:= {}	//Lista de impressão
	default cSheet 	:= ''	//Nome da aba
	default cTable 	:= ''	//Nome da tabela
	default lVazio 	:= .F.	//Salta linha no relatório
	default nTam 	:= 0	//Número de colunas da lista
	default lIsProc := .F.

	if !empty( aLista ) .and. !lIsProc
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

/*/{Protheus.doc} AjustaSx1
Cria Pergunte BHEXTRATO caso não exista
@param [ cTipoRelat ], texto, Tipo do relatório baixado ou não baixado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function AjustaSx1( cTipoRelat )
	default cTipoRelat := ''	//Tipo de relatório	s

	if cTipoRelat == cPERG_BANCO_HORAS
		xPutSx1( cPERG_BANCO_HORAS, "01", "Filial De?"					  , "Filial De?"						, "Filial De?"						,"mv_ch1" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "02", "Filial Até?"					  , "Filial Até?"						, "Filial Até?"						,"mv_ch2" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "03", "Centro de Custo De?"			  , "Centro de Custo De?"				, "Centro de Custo Ate?"			,"mv_ch3" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par03","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "04", "Centro de Custo De?"			  , "Centro de Custo Ate?"				, "Centro de Custo Ate?"			,"mv_ch4" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par04","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "05", "Matricula De?"				  , "Matricula De?"						, "Matricula De?"					,"mv_ch5" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par05","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "06", "Matricula Até?"				  , "Matricula Até?"					, "Matricula Até?"					,"mv_ch6" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par06","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "07", "Gera Extrato?"				  , "Gera Extrato?"						, "Gera Extrato?"					,"mv_ch7" , "C",01,0,0,"C",""					,""		,"","","mv_par07","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "08", "Gera Acumulado?"				  , "Gera Acumulado?"					, "Gera Acumulado?"					,"mv_ch8" , "C",01,0,0,"C",""					,""		,"","","mv_par08","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "09", "Gera Composição do Acumulado?" , "Gera Composição do acumulado?"		, "Gera Composição do acumulado?"	,"mv_ch9" , "C",01,0,0,"C",""					,""		,"","","mv_par09","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "10", "Gera Importação de Variáveis?" , "Gera Importação de Variáveis?"		, "Gera Importação de Variáveis?"	,"mv_cha" , "C",01,0,0,"C",""					,""		,"","","mv_par10","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "11", "Período?" 				 	  , "Período?"							, "Período?"						,"mv_chb" , "C",01,0,0,"C",""					,""		,"","","mv_par11","1-Todo período","","","","2-Intervalo","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "12", "Data De?"					  , "Data De?"							, "Data De?"						,"mv_chc" , "D",08,0,0,"G","u_Valid130('De')"	,""		,"","","mv_par12","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BANCO_HORAS, "13", "Data Até?"					  , "Data Até?"							, "Data Até?"						,"mv_chd" , "D",08,0,0,"G","u_Valid130('Ate')"	,""		,"","","mv_par13","","","","","","","","","","","","","","","","",,,)
	elseif cTipoRelat == cPERG_BAIXADO
		xPutSx1( cPERG_BAIXADO, "01", "Filial De?"					  	, "Filial De?"						, "Filial De?"						,"mv_ch1" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par01","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "02", "Filial Até?"					  	, "Filial Até?"						, "Filial Até?"						,"mv_ch2" , "C",02,0,0,"G",""					,"SM0"	,"","","mv_par02","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "03", "Centro de Custo De?"			  	, "Centro de Custo De?"				, "Centro de Custo Ate?"			,"mv_ch3" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par03","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "04", "Centro de Custo De?"			  	, "Centro de Custo Ate?"			, "Centro de Custo Ate?"			,"mv_ch4" , "C",09,0,0,"G",""					,"CTT"	,"","","mv_par04","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "05", "Matricula De?"				  	, "Matricula De?"					, "Matricula De?"					,"mv_ch5" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par05","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "06", "Matricula Até?"				  	, "Matricula Até?"					, "Matricula Até?"					,"mv_ch6" , "C",06,0,0,"G",""					,"SRA"	,"","","mv_par06","","","","","","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "07", "Gera Extrato?"				  	, "Gera Extrato?"					, "Gera Extrato?"					,"mv_ch7" , "C",01,0,0,"C",""					,""		,"","","mv_par07","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "08", "Gera Acumulado?"				  	, "Gera Acumulado?"					, "Gera Acumulado?"					,"mv_ch8" , "C",01,0,0,"C",""					,""		,"","","mv_par08","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "09", "Gera Composição do Acumulado?" 	, "Gera Composição do acumulado?"	, "Gera Composição do acumulado?"	,"mv_ch9" , "C",01,0,0,"C",""					,""		,"","","mv_par09","1-Sim","","","","2-Não","","","","","","","","","","","",,,)
		xPutSx1( cPERG_BAIXADO, "10", "Política De Banco de Horas De?"	, "Política De Banco de Horas De?"	, "Política De Banco de Horas De?"	,"mv_cha" , "C",02,0,0,"G",""					,"Z6"	,"","","mv_par10","","","","","","","","","","","","","","","","",,,,"BHBAIXADO10")
		xPutSx1( cPERG_BAIXADO, "11", "Política De Banco de Horas Até?"	, "Política De Banco de Horas Até?"	, "Política De Banco de Horas Até?"	,"mv_chb" , "C",02,0,0,"G",""					,"Z6"	,"","","mv_par11","","","","","","","","","","","","","","","","",,,,"BHBAIXADO11")
		xPutSx1( cPERG_BAIXADO, "12", "Período De Banco de Horas De?"	, "Período De Banco de Horas De?"	, "Período De Banco de Horas De?"	,"mv_cha" , "C",03,0,0,"G",""					,"U00A"	,"","","mv_par12","","","","","","","","","","","","","","","","",,,,"")
		xPutSx1( cPERG_BAIXADO, "13", "Período De Banco de Horas Até?"	, "Período De Banco de Horas Até?"	, "Período De Banco de Horas Até?"	,"mv_chb" , "C",03,0,0,"G",""					,"U00A"	,"","","mv_par13","","","","","","","","","","","","","","","","",,,,"")
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
@since 19/01/2018
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

/*/{Protheus.doc} Valid130
Valida parâmetros de datas quando for relatório de extrato de banco de horas.
@param [ cParam ], texto, Parâmetro a ser validado
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return lógico, lRetorno - Verdadeiro, permite o fluxo da escolha dos paâmetros de data.
/*/
User Function Valid130( cParam )
	local lRetorno := .T.	//Retorno da validação das datas

	default cParam := '' //Nome do parâmetro

	if MV_PAR11 == 2
		if cParam == 'De'
			if empty( MV_PAR12 )
				lRetorno :=  .F.
				MsgInfo("Campo 'Data de?' não preenchido","Parâmetros")
			endif
		elseif cParam == 'Ate'
			if empty( MV_PAR13 )
				lRetorno :=  .F.
				MsgInfo("Campo 'Data Até?' não preenchido","Parâmetros")
			endif
			if MV_PAR13 < MV_PAR12
				lRetorno :=  .F.
				MsgInfo("Campo 'Data Até?' menor que campo 'Data De?' ","Parâmetros")
			endif
		endif
	endif

Return lRetorno

/*/{Protheus.doc} Totalizar
Ajusta array para impressão dos totais
@param [ aLista 	], lista	, Lista do banco de horas por funcionario
@param [ nPosHora 	], numerico , Coluna na lista para somar hora
@param [ nPosSaldo 	], numerico , Coluna na lista para somar saldo
@param [ nOrdemCol 	], numerico , Coluna na lista ordernar o total
@param [ cAba	 	], texto	, Nome da aba no relatório
@param [ cTipoRelat ], texto	, Tipo do relatório baixado ou não baixado
@param [ cDescTotal ], texto	, Tipo de quebra para totalização
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Totalizar( aLista, nPosHora, nPosSaldo, nOrdemCol, cAba, cTipoRelat, cDescTotal )
	local aAux 			:= {}	//Lista auxiliar
	local aRetorno 		:= {} 	//Retorno da lista totalizada ajustada
	local i 			:= 0	//Varivel de iteração
	local nSaldo		:= 0	//Saldo total da lista
	local nSaldoTotal 	:= 0	//Saldo total da lista de total
	local nSaldoPosi	:= 0 	//Saldo total positivo
	local nSaldoNega	:= 0 	//Saldo total positivo
	local aPositivo		:= {}	//Array de total positivo
	local aNegativo		:= {}	//Array de total negativo
	local lSimplifica   := .F.  //Simplifica total

	default aLista	  	:= {}	//Lista de totais
	default cAba 		:= ''	//Nome da aba
	default cTipoRelat	:= ''	//Tipo de relatório
	default nOrdemCol 	:= 0	//Coluna para ordenação
	default nPosHora	:= 0	//Coluna com as horas
	default nPosSaldo	:= 0	//coluna com o saldo
	default cDescTotal	:= ''

	if nOrdemCol > 0
		aSort(aLista, , , {|x, y| x[nOrdemCol] < y[nOrdemCol]})
	endif

	if !empty(aLista) .and. nPosSaldo > 0
		for i := 1 to len(aLista)
			if nPosHora > 0
				nSaldo 		:= aLista[ i ][ nPosHora ]
				nSaldoTotal := __TimeSum(nSaldoTotal, nSaldo)
				aLista[i][ nPosHora  ] 	:= replace( StrZero( nSaldo	   	, ZeroEsquer(nSaldo	 		, nSaldo 		< 0), 2 ),'.',':')
				aLista[i][ nPosSaldo ] 	:= replace( StrZero( nSaldoTotal, ZeroEsquer(nSaldoTotal	, nSaldoTotal 	< 0), 2 ),'.',':')
			else
				nSaldo 					:= aLista[ i ][ nPosSaldo ]
				nSaldoTotal 			:= __TimeSum(nSaldoTotal, nSaldo)
				aLista[i][ nPosSaldo ] 	:= replace( StrZero( nSaldo, ZeroEsquer( nSaldo, nSaldo < 0 ), 2 ),'.',':' )
			endif

			if nSaldo > 0
				nSaldoPosi  := __TimeSum(nSaldoPosi, nSaldo)
			else
				nSaldoNega  := __TimeSum(nSaldoNega, nSaldo)
			endif

			aAux := {}
			aAdd(aAux, aLista[i][01]) //01
			aAdd(aAux, aLista[i][02]) //02
			aAdd(aAux, aLista[i][03]) //03
			if cDescTotal == cTOT_FUNCIONARIO
				aAdd(aAux, aLista[i][4]) 	//04 Matrícula
				aAdd(aAux, aLista[i][5]) 	//05 Nome
			else
				aAdd(aAux, '') 			 	//04 Matrícula
				aAdd(aAux, '') 			 	//05 Nome
			endif
			aAdd(aAux, aLista[i][06]) //06

			if cAba == cABA_EXTRATO .or. cAba == cABA_COMPOSICAO
				aAdd(aAux, aLista[i][07]) //07
				aAdd(aAux, replace(aLista[i][08], '###', cDescTotal)) //08
				aAdd(aAux, aLista[i][09]) //09
				aAdd(aAux, aLista[i][10]) //10
				if cTipoRelat == cPERG_BAIXADO
					aAdd(aAux, aLista[i][12]) //11
					aAdd(aAux, aLista[i][13]) //12
					aAdd(aAux, aLista[i][14]) //13
				endif
			else
				aAdd(aAux, replace(aLista[i][07], '###', cDescTotal)) //07
				aAdd(aAux, aLista[i][08]) //08
				if cTipoRelat == cPERG_BAIXADO
					aAdd(aAux, aLista[i][10]) //09
					aAdd(aAux, aLista[i][11]) //10
					aAdd(aAux, aLista[i][12]) //11
				endif
			endif
			aAdd( aRetorno, aAux )
		next i

		if cTipoRelat == cPERG_BAIXADO
			if lSimplifica := ( cAba == cABA_EXTRATO .or. cAba == cABA_COMPOSICAO )
				aLista[01][12] == cREGRA_01
			else
				aLista[01][10] == cREGRA_01
			endif

			if lSimplifica
				aRetorno := {}
				aAux := {}
				aAdd(aAux, aLista[01][1]) //01 Filial
				aAdd(aAux, aLista[01][2]) //02 Centro de custo
				aAdd(aAux, aLista[01][3]) //03 Descrição do Centro de custo

				if cDescTotal == cTOT_FUNCIONARIO
					aAdd(aAux, aLista[01][4]) //04 Matrícula
					aAdd(aAux, aLista[01][5]) //05 Nome
				else
					aAdd(aAux, '') //04 Matrícula
					aAdd(aAux, '') //05 Nome
				endif
				if cAba == cABA_EXTRATO .or. cAba == cABA_COMPOSICAO
					aAdd(aAux, '') 		 				//06 Data em string AAAAMMDD
					aAdd(aAux, '') 		 				//07 Código evento
					aAdd(aAux, 'Total - '+cDescTotal) 	//08 Descrição do evento
					aAdd(aAux, '')  	 				//09 Horas
					aAdd(aAux, replace(StrZero( nSaldoTotal, ZeroEsquer(nSaldoTotal, nSaldoTotal < 0), 2 ),'.',':')) //08 - 10 Saldo
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aLista[01][12]) //11
						aAdd(aAux, aLista[01][13]) //12
						aAdd(aAux, aLista[01][14]) //13
					endif
				elseif cAba == cABA_ACUMULADO
					aAdd(aAux, '') 		 				//06 Código evento
					aAdd(aAux, 'Total - '+cDescTotal)	//07 Descrição do evento
					aAdd(aAux, replace(StrZero( nSaldoTotal, ZeroEsquer(nSaldoTotal, nSaldoTotal < 0), 2 ),'.',':')) //08 - 10 Saldo
					if cTipoRelat == cPERG_BAIXADO
						aAdd(aAux, aLista[01][10]) //09
						aAdd(aAux, aLista[01][11]) //10
						aAdd(aAux, aLista[01][12]) //11
					endif
				endif
				aAdd( aRetorno, aAux )
			endif
		endif

		if cDescTotal == cTOT_CC
			if len(aAux) > 0
				aPositivo			 := aClone(aAux)	//Array de total positivo
				aNegativo			 := aClone(aAux)	//Array de total negativo
			endif

			if cAba == cABA_EXTRATO .or. cAba == cABA_COMPOSICAO
				aPositivo[ 07 ] := ''
				aPositivo[ 08 ] := 'Total - Positivo'
				aPositivo[ 09 ] := ''
				aPositivo[ 10 ] := replace( StrZero( nSaldoPosi, ZeroEsquer(nSaldoPosi	, nSaldoPosi 	< 0), 2 ),'.',':')
				aAdd( aRetorno, aPositivo ) //Total Positivo

				aNegativo[ 07 ] := ''
				aNegativo[ 08 ] := 'Total - Negativo'
				aNegativo[ 09 ] := ''
				aNegativo[ 10 ] := replace( StrZero( nSaldoNega, ZeroEsquer(nSaldoNega	, nSaldoNega 	< 0), 2 ),'.',':')
				aAdd( aRetorno, aNegativo ) //Total Negativo
			else
				aPositivo[ 06 ] := ''
				aPositivo[ 07 ] := 'Total - Positivo'
				aPositivo[ 08 ] := replace( StrZero( nSaldoPosi, ZeroEsquer(nSaldoPosi	, nSaldoPosi 	< 0), 2 ),'.',':')
				aAdd( aRetorno, aPositivo ) //Total Positivo

				aNegativo[ 06 ] := ''
				aNegativo[ 07 ] := 'Total - Negativo'
				aNegativo[ 08 ] := replace( StrZero( nSaldoNega, ZeroEsquer(nSaldoNega	, nSaldoNega 	< 0), 2 ),'.',':')
				aAdd( aRetorno, aNegativo ) //Total Negativo
			endif
		endif
	endif

	aLista := aRetorno
Return

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

/*/{Protheus.doc} Acumular
Agrupo os resultados em um unico array
@param [ aLista 	], lista	, Lista do banco de horas por funcionario
@param [ aAcumulado ], lista	, Lista do banco de horas acumulado
@param [ nColHora 	], numerico	, Coluna de hora na lista
@param [ nPosSaldo 	], numerico	, Coluna de saldo na lista
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function Acumular( aLista, aAcumulado, nColHora, nPosSaldo )
	local i 	:= 0 //variavel de iteração
	local nPos 	:= 0 //variavel com a posição de busca na lista

	default aLista 		:= {}  //Lista do banco de horas por funcionario
	default aAcumulado 	:= {}  //Lista do banco de horas acumulado
	default nColHora 	:= {}  //Coluna de hora na lista
	default nPosSaldo 	:= {}  //Coluna de saldo na lista

	for i :=  1 to len( aLista )
		nPos := 0
		if !empty( aAcumulado )
			nPos := aScan(aAcumulado, {|x| x[07] == aLista[i][07]})
		endif
		if nPos == 0
			aAdd( aAcumulado, aClone( aLista[i] ) )
		else
			if nColHora > 0
				aAcumulado[nPos][nColHora]  := __TimeSum( aAcumulado[nPos][nColHora], aLista[i][nColHora])
			endif
			if nPosSaldo > 0
				aAcumulado[nPos][nPosSaldo] := __TimeSum( aAcumulado[nPos][nPosSaldo], aLista[i][nPosSaldo])
			endif
		endif
	next i
Return

/*/{Protheus.doc} AjustaArq
Retorna no do arquivo escolhido pelo usuário.
@type function
@author BrunoNunes
@since 11/06/2018
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