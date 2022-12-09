#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "GPEM080.CH"
//
/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Funca��o   � GPIMCDFL  � Autor � Junior Carvalho       � Data �   27/02/2018  ���
��������������������������������������������������������������������������������Ĵ��
���Descri��cao� Geracao de Liquidos em disquete                                  ���
��������������������������������������������������������������������������������Ĵ��
���Parametros �                                                                  ���
��������������������������������������������������������������������������������Ĵ��
��� Uso       � feito com base no fonte GPEM080                                  ���
��������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�CAO INICIAL.                   ���
��������������������������������������������������������������������������������Ĵ��
���Programador � Data     �CHAMADO/REQ�  Motivo da Alteracao                     ���
��������������������������������������������������������������������������������Ĵ��
���            �          �           �                                          ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������*/
USER Function GPIMCDFL()
	Local   cPerg		:= ""
	Private cCadastro 	:= OemToAnsi(STR0001) //"Gera��o de liquido em disquete (CNAB/SISPAG)"
	Private nSavRec  	:= RECNO()
	Private cProcessos	:= ""


	//FUNCAO VERIFICA SE EXISTE ALGUMA RESTRICAO DE ACESSO PARA O USUARIO QUE IMPECA A EXECUCA DA ROTINA
	If !(fValidFun({"SRQ","SRC"}))
		Return( nil )
	Endif

	//Verifica se exite o grupo de perguntas GPEM080R1
	DBSelectArea("SX1")
	DBSetOrder(1)
	If DBSeek("GPEM080R1")
		cPerg := "GPEM080R1"
	Else
		cPerg := "GPEM080"
	EndIf

	Pergunte(cPerg, .F.)

	cDescricao := OemToAnsi(STR0002) + CRLF + OemToAnsi(STR0003) + CRLF + OemToAnsi(STR0004)
	//" ESTE PROGRAMA TEM O OBJETIVO DE GERAR O ARQUIVO DE LIQUIDO EM DISCO."
	//" ANTES DE RODAR ESTE PROGRAMA  �  NECESS�RIO CADASTRAR O LAY-OUT DO  "
	//" ARQUIVO. MODULO SIGACFG OP��O CNAB A RECEBER OU SISPAG. "
	bProcesso :=	{|oSelf| GPM080Processa(oSelf)}
	tNewProcess():New( "GPEM080", cCadastro, bProcesso, cDescricao, cPerg, , .T., 20, cDescricao, .T., .T.)

Return

/*
�����������������������������������������������������������������������Ŀ
�Funca��o    �Gpm080processa� Autor � Equipe de RH      � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Processamento da geracao do arquivo                         �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �Gpm080processa()                                            �
�����������������������������������������������������������������������Ĵ
�Parametros�                                                            �
�����������������������������������������������������������������������Ĵ
� Uso      � Gpem080                                                    �
�������������������������������������������������������������������������*/
Static Function Gpm080processa(oSelf)
	Local aCodFol		:={}
	Local lHeader		:= .F.
	Local lFirst		:= .F.
	Local lGrava		:= .F.
	Local lGp410Des 	:= ExistBlock("GP410DES")
	Local lGp450Des 	:= ExistBlock("GP450DES")
	Local lGp450Val 	:= ExistBlock("GP450VAL")
	Local aVerba		:= {}
	Local nCntP
	Local aStruSRA
	Local cAliasSRA		:= "SRA" 	//ALIAS DA QUERY
	Local cLocaBco 		:= cLocaPro := ""
	Local X				:= 0
	Local lAllProc		:= .F.
	Local nTamCod		:= 0
	Local cAuxPrc		:= ""
	Local lCpyS2T		:= .F.
	Local lValidFil		:= .T.

	//VARIAVEIS PARA CRIACAO DE LOG
	Local cLog			:= 	""
	Local aLog			:= {}
	Local aTitle		:= {}
	Local nTotRegs		:= 0
	Local nRegsGrav		:= 0
	LOcal nTotVal		:= 0
	Local nVerba		:= 0
	Local cData			:= ""
	Local cHora			:= ""
	//ARQUIVO MESES ANTERIORES
	Local nS
	Local nX
	Local cTpConta
	Local nPos
	Local aFunBenef := {}
	Local lMod2Ambos:= .F.
	Local cSitQuery := ""
	Local cCatQuery := ""
	Local cProcQuery:= ""
	Local cNomArq	:= ""
	Local cNomDir	:= ""
	Local FilAnt := Replicate("!",FWSIZEFILIAL())
	Local lNewPerg := If (ALLTRIM(oSelf:cPergunte) == "GPEM080R1", .T., .F.)

	Private cStartPath := GetSrvProfString("StartPath","")
	Private cLote	:= Nil
	Private cNome,cBanco,cConta,cCPF
	Private aValBenef 	:= {}
	Private aRoteiros	:= {}
	// VARIAVEIS DE ACESSO DO USUARIO
	Private cAcessaSR1	:= &( " { || " + ChkRH( "GPER080" , "SR1" , "2" ) + " } " )
	Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER080" , "SRA" , "2" ) + " } " )
	Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER080" , "SRC" , "2" ) + " } " )
	Private cAcessaSRD	:= &( " { || " + ChkRH( "GPER080" , "SRD" , "2" ) + " } " )
	Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER080" , "SRG" , "2" ) + " } " )
	Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER080" , "SRH" , "2" ) + " } " )
	Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER080" , "SRR" , "2" ) + " } " )
	// DEFINE VARIAVEIS PRIVADAS BASICAS
	Private aABD := { STR0007,STR0007,STR0006 } //"Drive A"###"Drive B"###"Abandona"
	Private aTA  := { STR0005,STR0006 } //"Tenta Novamente"###"Abandona"
	// DEFINE VARIAVEIS PRIVADAS DO PROGRAMA
	Private nEspaco := nDisco := nGravados := 0
	Private cDrive := " "
	Private nArq, cTipInsc
	// VARIAVEIS USADAS NO ARQUIVO DE CADASTRAMENTO
	Private nSeq		:= 0
	Private nValor		:= 0
	Private nTotal		:= 0
	Private nTotFunc	:= 0
	// VARIAVEIS DISPONIBILIZADAS PARA GERACAO DO ARQUIVO - MOD.2
	Private CIC_ARQ		:= "" //CPF
	Private NOME_ARQ		:= "" //Nome Completo
	Private PRINOME_ARQ	:= "" //Primeiro Nome
	Private SECNOME_ARQ	:= "" //Segundo Nome
	Private PRISOBR_ARQ	:= "" //Primeiro Sobrenome
	Private SECSOBR_ARQ	:= "" //Segundo Sobrenome
	Private BANCO_ARQ	:= "" //Banco
	Private CONTA_ARQ	:= "" //Conta
	Private lRegFun		:= .F.
	Private nHdlBco		:=0,nHdlSaida:=0
	Private xConteudo

	// BLOCO DE VARIAVEIS PARA CONTROLE DOS DADOS BANCARIOS DA EMPRESA
	Private lUsaBanco  := .F.
	Private lGeraDOC   := .F.
	Private lDocCC	   := .F.
	Private lDocPoup   := .F.
	Private cCodBanco  := ""
	Private cCodAgenc  := ""
	Private cDigAgenc  := ""
	Private cCodConta  := ""
	Private cDigConta  := ""
	Private cCodConve  := ""
	Private cCodFilial := ""
	Private cCodCnpj   := ""
	Private cNomeEmpr  := ""
	Private lCCorrent  := .T.
	Private aInfo      := {}
	Private nTipoConta := 0
	Private CTPOARCE   := "" // Tipo Archivo Enviado
	Private nLoteSeq		:= 1 /*Vari�vel guarda a sequ�ncia atual do Lote*/
	Private nLoteTotal	:= 0 /*--------------- o valor total do Lote atual*/
	Private nLoteQtd		:= 0 /*--------------- a quantidade de funcion�rios do Lote Atual*/
	Private nQtdLinLote	:= 0 /*--------------- a quantidade de linhas do Lote Atual*/
	Private cSeq       := ""

	//���������������������������������������������������������������������Ŀ
	//� VARIAVEIS UTILIZADAS PARA PARAMETROS                                �
	//� mv_par01        //  Roteiros                                        �
	//� mv_par02        //  Roteiros                                        �
	//� mv_par03        //  Roteiros                                        �
	//� mv_par04        //  Filial  De                                      �
	//� mv_par05        //  Filial  Ate                                     �
	//� mv_par06        //  Centro de Custo De                              �
	//� mv_par07        //  Centro de Custo Ate                             �
	//� mv_par08        //  Banco /Agencia De                               �
	//� mv_par09        //  Banco /Agencia Ate                              �
	//� mv_par10        //  Matricula De                                    �
	//� mv_par11        //  Matricula Ate                                   �
	//� mv_par12        //  Nome De                                         �
	//� mv_par13        //  Nome Ate                                        �
	//� mv_par14        //  Conta Corrente De                               �
	//� mv_par15        //  Conta Corrente Ate                              �
	//� mv_par16        //  Situacao                                        �
	//� mv_par17        //  Layout                                          �
	//� mv_par18        //  Arquivo de configuracao                         �
	//� mv_par19        //  nome do arquivo de saida                        �
	//� mv_par20        //  data de credito                                 �
	//� mv_par21        //  Data de Pagamento De                            �
	//� mv_par22        //  Data de Pagamento Ate                           �
	//� mv_par23        //  Categorias                                      �
	//� mv_par24        //  Imprimir 1-Funcionarios 2-Beneficiarias 3-Ambos �
	//� mv_par25        //  Data de Referencia                              �
	//� mv_par26        //  Selecao de Processos                            �
	//� mv_par27        //  Selecao de Processos                            �
	//� mv_par28        //  Selecao de Processos                            �
	//� mv_par29        //  Linha Vazia no Fim do Arquivo                   �
	//� mv_par30        //  Processar Banco                                 �
	//� mv_par31        //  Ag�ncia				                            �
	//� mv_par32        //  Conta				                            �
	//� mv_par33        //  Gerar Conta Tipo                                �
	//� mv_par34        //  DOC Outros Bancos                               �
	//�����������������������������������������������������������������������
	cFilDe		:= mv_par04
	cFilAte		:= mv_par05
	cCcDe     	:= mv_par06
	cCcate    	:= mv_par07
	cBcoDe		:= mv_par08
	cBcoAte		:= mv_par09
	cMatDe    	:= mv_par10
	cMatAte		:= mv_par11
	cNomDe		:= mv_par12
	cNomAte		:= mv_par13
	cCtaDe		:= mv_par14
	cCtaAte		:= mv_par15
	cSituacao	:= mv_par16
	nModelo		:= mv_par17
	cArqent		:= mv_par18
	cArqSaida	:= mv_par19
	dDataPgto	:= mv_par20
	dDataDe		:= mv_par21
	dDataAte	:= mv_par22
	cCategoria	:= mv_par23
	nFunBenAmb	:= mv_par24  // 1-FUNCIONARIOS  2-BENEFICIARIAS  3-AMBOS
	dDataRef	:= If (Empty(mv_par25), dDataBase,mv_par25)
	lLnVazia	:= If (mv_par29 == 1,.T.,.F.)

	If cPaisLoc <> "MEX"
		If lNewPerg
			cCodBanco	:= mv_par30
			cCodAgenc	:= mv_par31
			cCodConta	:= mv_par32
			If cPaisLoc == "CHI"
				nTipoConta	:= mv_par34
				lGeraDOC  	:= mv_par35 == 1
			Else
				nTipoConta	:= mv_par33
				lGeraDOC  	:= mv_par34 == 1
			EndIf
		Else
			cCodBanco 	:= mv_par30
			nTipoConta	:= mv_par31
			lGeraDOC  	:= mv_par32 == 1
		EndIf
		lUsaBanco 	:= !Empty(cCodBanco)
		CTPOARCE 	:= IIF(cPaisLoc == "CHI" , mv_par33 , "" ) //Tipo Archivo Enviado
	EndIf

	lMod2Ambos	:= (nModelo == 2 .And. nTipoConta == 3)
	lCCorrent 	:= (nTipoConta == 1) .Or. (lMod2Ambos)

	/*Determina os tipos de contas permitidos*/
	Do Case
		Case (nTipoConta == 1)
		cTpConta := " *1"
		Case (nTipoConta == 3)
		cTpConta := " *1*2"
		OtherWise
		cTpConta := "2"
	EndCase

	// AGRUPA OS PROCESSOS SELECIONADOS
	If !(Empty(MV_PAR26 + MV_PAR27 + MV_PAR28)) //Processos para Impressao
		cProcessos:= AllTrim(MV_PAR26) + AllTrim(MV_PAR27) + AllTrim(MV_PAR28)
	Else
		Help(" ",1,"GPEM80PROC") //P: Nenhum processo foi selecionado. ### S: Selecione ao menos um processo.
		Return()
	EndIf

	if(lMod2Ambos .And. !lUsaBanco)
		/*Para gerar o arquivo para ambos os tipos de contas � necess�rio informar o c�digo do banco da empresa.*/
		Help(,,OemToAnsi(STR0021),, OemToAnsi(STR0036),1,0 )
		Return()
	endIf

	// CARREGANDO ARRAY AROTEIROS COM OS ROTEIROS SELECIONADOS
	If Len(MV_PAR01 + MV_PAR02 + MV_PAR03) > 0
		SelecRoteiros()
	EndIf

	//DEFINE SE DEVERA SER IMPRESSO FUNCIONARIOS OU BENEFICIARIOS
	lImprFunci  := ( nFunBenAmb # 2 )
	lImprBenef  := ( nFunBenAmb # 1 )

	SA6->(dbSetOrder(1))

	/*Trata o nome do arquivo*/
	SetArqNome(@cArqSaida, @lCpyS2T,@cNomArq,@cNomDir)

	if(lUsaBanco)
		/*� necess�rio obter as informa��es sobre o banco antes,
		dessa forma o cliente pode usar os dados no cabe�alho.*/
		GetBankInf( lNewPerg )
	endIf

	/*Valida a exist�ncia do arquivo.*/
	If	!(FILE(cArqEnt))
		Help(" ",1,"NOARQPAR")
		Return
	Endif

	// MODIFICA VARIAVEIS PARA A QUERY
	cSitQuery	:= fSqlIn(StrTran(cSituacao,'*'),1)
	cCatQuery	:= fSqlIn(StrTran(cCategoria,'*'),1)
	lAllProc	:= AllTrim( cProcessos ) == "*"

	If Empty(cSitQuery)
		aAdd( aLog, { OemToAnsi(STR0037) } ) //-- "N�o foi informada nenhuma Situa��o nos par�metros."
		cSitQuery := "''"
	EndIF

	If Empty(cCatQuery)
		aAdd( aLog, { OemToAnsi(STR0038) } ) //-- "N�o foi informada nenhuma Categoria nos par�metros."
		cCatQuery := "''"
	EndIF

	If !lAllProc
		nTamCod := GetSx3Cache("RCJ_CODIGO", "X3_TAMANHO")
		cProcQuery := fSqlIn(cProcessos,nTamCod)
	EndIf

	cQuery := "SELECT R_E_C_N_O_ AS CHAVE, " + RetSqlName("SRA") + ".* "
	cQuery += "FROM "+	RetSqlName("SRA")
	cQuery += " WHERE RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
	cQuery += "AND RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
	cQuery += "AND RA_NOME BETWEEN '" + cNomDe + "' AND '" + cNomAte + "'"
	cQuery += "AND RA_CC between '" + cCcDe  + "' AND '" + cCcate  + "'"
	cQuery += "AND RA_CATFUNC IN (" + Upper(cCatQuery) + ")"
	cQuery += "AND RA_SITFOLH IN (" + Upper(cSitQuery) + ")"

	If !lAllProc
		cQuery += "AND RA_PROCES IN("+ Upper(cProcQuery)+ ")"
	EndIf
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery	+= " ORDER BY RA_FILIAL, RA_MAT"

	aStruSRA := SRA->(dbStruct())
	SRA->( dbCloseArea() )
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)

	DbSelectArea("SRA")
	Count To nTotalQ /*Conta a quantidade de registros retornados pela consulta.*/
	SRA->(DbGoTop()) /*Retorna ao primeiro registro.*/
	oSelf:SetRegua1(nTotalQ) // Total de Elementos da regua

	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX

	While (cAliasSRA)->(!Eof())
		// MOVIMENTA CURSOR
		oSelf:IncRegua1(IIF(cPaisLoc == "CHI", STR0035, STR0012) + "[" + SRA->(RA_FILIAL + '/' + RA_MAT) + "]")

		nValor    	:= 0
		aFunBenef 	:= {}

		If SRA->RA_FILIAL # FilAnt
			If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
				Exit
			Endif
			// Verifica Existencia da Tabela S052 - Bancos para CNAB
			If lUsaBanco
				GetBankInf( lNewPerg )
			EndIf
			FilAnt 	:= SRA->RA_FILIAL
			lValidFil	:= .T.

			// CONSISTE FILIAIS E ACESSOS
			If !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
				SRA->(dbSkip())
				lValidFil := .F.
				Loop
			EndIf
		EndIf

		// CONSISTE FILIAIS E ACESSOS
		If !lValidFil
			SRA->(dbSkip())
			Loop
		EndIf

		// BUSCA OS VALORES DE LIQUIDO E BENEFICIOS
		Gp020BuscaLiq(@nValor,@aFunBenef)

		// CONSISTE PARAMETROS DE BANCO E CONTA DO FUNCIONARIO
		If (SRA->RA_BCDEPSA < cBcoDe) .Or. (SRA->RA_BCDEPSA > cBcoAte) .Or.;
		(SRA->RA_CTDEPSA < cCtaDe) .Or. (SRA->RA_CTDEPSA > cCtaAte)
			nValor := 0
		EndIf

		// FILTRA GERACAO DE DOC'S
		If lUsaBanco
			lDocCc   := Left( SRA->RA_BCDEPSA,3 ) <> cCodBanco .And. lCCorrent
			lDocPoup := Left( SRA->RA_BCDEPSA,3 ) <> cCodBanco .And. !lCCorrent
			If !lGeraDoc .And. ( lDocCc .Or. lDocPoup )
				nValor := 0
			EndIf
		EndIf

		/*Se deve gerar funcion�rios e valor maior que zero, adiciona o funcion�rio no vetor.*/
		If lImprFunci .And. nValor > 0
			aAdd(aFunBenef, {IIF(Empty(SRA->RA_NOMECMP),SRA->RA_NOME,SRA->RA_NOMECMP),;
			SRA->RA_BCDEPSA, SRA->RA_CTDEPSA, "", nValor, SRA->RA_CIC, SRA->CHAVE, "SRA", IIf(cPaisLoc == "BRA",SRA->RA_TPCTSAL, "")})
		EndIf

		// CONSISTE PARAMETROS DE BANCO E CONTA DO BENEFICIARIO
		// AFUNBENEF: 1-NOME  2-BANCO  3-CONTA  4-VERBA  5-VALOR  6-CPF
		If Len(aFunBenef) > 0
			/*Exclui do vetor poss�veis benefici�rios que n�o respeitem ao filtro ou
			funcion�rios que tem o tipo de conta n�o pertinente.*/
			while((nPos := aScan(aFunBenef,{|x|(X[2] < cBcoDe .Or. X[2] > cBcoAte) .Or. ;
			(X[3] < cCtaDe .Or. X[3] > cCtaAte) .Or. (!(X[9] $ cTpConta) .And. (cPaisLoc == "BRA"))})) > 0)
				aDel(aFunBenef,nPos)
				aSize(aFunBenef,Len(aFunBenef)-1)
			EndDo
		else
			SRA->(dbSkip())
			Loop
		EndIf

		// Ponto de Entrada para desprezar somente o funcionario,somente o beneficiario ou ambos, utilizando o array aValBenef.
		// CNAB Modelos 1 e 2
		If lGp410Des
			If !(ExecBlock("GP410DES",.F.,.F.))
				SRA->(dbSkip(1))
				Loop
			EndIf
		EndIf
		// SISPAG
		If lGp450Des
			If !(ExecBlock("GP450DES",.F.,.F.))
				SRA->(dbSkip(1))
				Loop
			EndIf
		EndIf

		for nCntP:= 1 to Len(aFunBenef)
			/*Registros cujo campo TPCONTA estiverem vazios s�o considerados Conta Corrente.*/
			if(Empty(aFunBenef[nCntP,9]))
				aFunBenef[nCntP,9] := '1'
			endIf
			aAdd(aFunBenef[nCntP],IIF((Left(aFunBenef[nCntP,2],3) == cCodBanco),cCodBanco,"DOC"))
		next nCntP

		/*Adiciona ao vetor aFunBenef os registros que forem do pr�prio banco,
		os que n�o forem(ou seja, sejam DOC), s� s�o adicionados se lGeraDoc for .T. e for
		utilizar um layout com m�ltiplos lotes*/
		aEval(aFunBenef,{|x|IIF((lMod2Ambos .And. !lGeraDOC .And. Left(x[2],3) != cCodBanco) .Or. x[5] <= 0,/*N�o faz nada*/,aAdd(aValBenef,x))})
		aSize(aFunBenef,0)

		SRA->( dbSkip( ) )
	Enddo
	/*Como a tabela est� filtrada, fecho a tabela.*/
	SRA->(dbCloseArea())
	ChkFile("SRA")
	dbSelectArea("SRA")/*O dbSelectArea reabre a tabela 'normal'*/
	SRA->(dbSetOrder(1))

	if(nModelo == 2 .And. Len(aValBenef) > 0)
		/*Ordena por forma de pagamento, utilizando o Banco + TpContaSal*/
		aSort(aValBenef,,,{|x,y|x[10] + x[9] > y[10] + y[9]})
		/*cLote � sempre: cCodBanco+TpContaSal OU 'DOC'+TpContaSal, sendo 'DOC' usado
		para qualquer outro banco diferente de cCodBanco.*/
		cLote := aValBenef[1,10] + aValBenef[1,9]
		/*Por padr�o, ao chamar o HeadCnab2(pela fun��o AbrePar), ela j� monta o cabe�alho
		do primeiro lote.*/
		//HeadLote2(nHdlSaida,cArqent)
	endIf

	/*Ap�s conclu�da a consulta, cria o arquivo de sa�da.*/
	AbrePar(@cArqSaida,@cArqEnt)

	If nModelo == 3 //SISPAG
		// ANALISA O TIPO DE BORDERO E DEFINE QUAIS HEADERS,TRAILLERS
		// E DETALHES DE LOTE QUE SER�O UTILIZADOS.
		//IDENTIFICADORES
		// A - HEADER ARQUIVO
		// B - HEADER  LOTE 1   HEADER LOTE CHEQUE/OP/DOC/CRED.CC
		// D - TRAILER LOTE 1   TRAILLER LOTE CHEQUE/OP/DOC/CRED.CC
		// F - TRAILER ARQUIVO
		// G - SEGMENTO A       CHEQUE/OP/DOC/CRED.CC
		// H - SEGMENTO B       INFORMACOES COMPLEMNTARES
		cHeadArq  := "A"
		cTraiArq  := "F"
		cHeadLote := "B"
		cTraiLote := "D"
		cDetaG    := "G"
		cDetaH    := "H"
		// GRAVA OS HEADERS DE ARQUIVO DE LOTE
		// OBSERVACAO: SERA' UM ARQUIVO PARA CADA BORDERO.
		GPM080Empresa( xFilial("SRA"), @cCodCnpj, @cNomeEmpr )
		fm080Linha(cHeadArq)
		fm080Linha(cHeadLote)
	EndIf

	For nCntP := 1 To Len(aValBenef)
		//Indica se o registro atual e o funcionario ou o beneficiario
		lRegFun := (aValBenef[nCntP,8] == 'SRA')

		//Posiciona no registro que esta sendo processado
		(aValBenef[nCntP,8])->(dbGoTo(aValBenef[nCntP,7]))

		if(!lRegFun) /*Se for Benefici�rio, posiciona no Funcion�rio tamb�m.*/
			SRA->(dbSeek(SRQ->(RQ_FILIAL+RQ_MAT)))
		endIf

		cNome  := aValBenef[nCntP,1]
		cBanco := aValBenef[nCntP,2]
		cConta := aValBenef[nCntP,3]
		cCPF	:= aValBenef[nCntP,6]
		// VERIFICA VALOR E BANCO/AGENCIA DOS BENEFICIARIOS
		If aValBenef[nCntP,5] == 0 .Or. Empty(cBanco) .Or. cBanco < cBcoDe .Or. cBanco > cBcoAte
			Loop
		EndIf

		// PONTO DE ENTRADA PARA ALTERAR DADOS CASO NECESSARIO
		If lGp450Val
			If !(ExecBlock("GP450VAL",.F.,.F.))
				Loop
			EndIf
		EndIf
		// IGUALA NAS VARIAVEIS USADAS DO ARQUIVO DE CADASTRAMENTO
		nValor := aValBenef[nCntP,5] * 100
		nTotal 	+= nValor
		nTotFunc++
		nSeq++

		If ( nModelo == 1 )
			// LE ARQUIVO DE PARAMETRIZACAO
			nLidos:=0
			fSeek(nHdlBco,0,0)
			nTamArq:=FSEEK(nHdlBco,0,2)
			fSeek(nHdlBco,0,0)

			While nLidos <= nTamArq
				// VERIFICA O TIPO QUAL REGISTRO FOI LIDO
				xBuffer:=Space(85)
				FREAD(nHdlBco,@xBuffer,85)

				Do case
					Case SubStr(xBuffer,1,1) == CHR(1)
					If lHeader
						nLidos+=85
						Loop
					EndIf
					Case SubStr(xBuffer,1,1) == CHR(2)
					If !lFirst
						lFirst := .T.
						FWRITE(nHdlSaida,CHR(13)+CHR(10))
					EndIf
					Case SubStr(xBuffer,1,1) == CHR(3)
					nLidos+=85
					Loop
					Otherwise
					nLidos+=85
					Loop
				EndCase
				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo:= SubStr(xBuffer,24,60)
				If ( aValBenef[ nCntP, 7 ] != 0 .and. ( SubStr(AllTrim(cConteudo),3,1) == "SRQ" ) )
					SRQ->(dbGoTo(aValBenef[nCntP,7]))
				EndIf
				lGrava := fM080Grava(nTam,nDec,cConteudo)
				If !lGrava
					Exit
				EndIf
				nLidos+=85
			EndDo
			If !lGrava
				Exit
			EndIf
		ElseIf ( nModelo == 2 )
			if(lMod2Ambos)
				if(cLote != aValBenef[nCntP,10] + aValBenef[nCntP,9])
					/*Encerra o Lote atual imprimindo seu Rodap�(Trailer)*/
					RodaLote2(nHdlSaida,cArqent)
					/*Antes de imprimir o Header do Lote subsequente, incrementa o sequencial,
					zera o valor total e a quantidade de linhas do Lote.*/
					nLoteSeq++
					nLoteTotal		:= nValor
					nLoteQtd		:= 1 //N�mero de Funcion�rios
					cLote 			:= aValBenef[nCntP,10] + aValBenef[nCntP,9]
					nQtdLinLote	:= 0 //N�mero de LINHAS, utilizado quando h� m�ltiplos segmentos.
					HeadLote2(nHdlSaida,cArqent)
				else
					nLoteTotal	+= nValor
					nLoteQtd++
				endIf
			else
				nLoteTotal	+= nValor
				nLoteQtd++
			endIf

			lGrava := fM080Grava(,,,)
		ElseIf ( nModelo == 3 )
			// GRAVA AS LINHAS DE DETALHE DE ACORDO COM O TIPO DO BORDERO
			fm080Linha( cDetaG ,@cLocaBco,@cLocaPro)
			fm080Linha( cDetaH ,@cLocaBco,@cLocaPro)
		EndIf
		If lGrava
			If ( nModelo == 1 )
				fWrite(nHdlSaida,CHR(13)+CHR(10))
				If !lHeader
					lHeader := .T.
				EndIf
			EndIf
		EndIf
		//Grava arquivo de log.
		If nTotRegs == 0
			// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
			//"Processo          Filial          Matricula          Funcionario                             L�quido em Arquivo"
			// 12345             XX              123456             123456789012345678901234567890              999,999,999.99
			if cPaisLoc == "CHI"
				cLog := (Alltrim(STR0018)+ Space(03) + Alltrim(STR0019) + Space(FWSIZEFILIAL()) + Alltrim(STR0023) + Space(04) + ;
				Alltrim(STR0017) + Space(Len(cNome)) + STR0035 )
			else
				cLog := (Alltrim(STR0018)+ Space(04) + Alltrim(STR0019) + Space( 12 - FWSIZEFILIAL() ) + Alltrim(STR0023) + Space(05) + ;
				Alltrim(STR0017) + Space(Len(cNome)) + STR0012 )
			endif

			Aadd(aTitle,cLog)
			Aadd(aLog,{})
			nTotRegs := len(aLog)
		EndIf
		if cPaisLoc == "CHI"
			Aadd(aLog[nTotRegs],(PADR(ALLTRIM(SRA->RA_PROCES),len(Alltrim(STR0018))+TAMSX3("RA_PROCES")[1], ) + PADR(ALLTRIM(SRA->RA_FILIAL),len(Alltrim(STR0019))+TAMSX3("RA_FILIAL")[1], ) +;
			PADR(ALLTRIM(SRA->RA_MAT),len(Alltrim(STR0023))+ TAMSX3("RA_MAT")[1], )+ PADR(ALLTRIM(cNome), TAMSX3("RA_NOMECMP")[1] , ) + PADL(alltrim(transform( (nValor / 100), "@E 999,999,999.99")),18, )))
		else
			Aadd(aLog[nTotRegs],(SRA->RA_PROCES + space(7) + SRA->RA_FILIAL + Space( 12 - FWSIZEFILIAL() ) + SRA->RA_MAT + space(8) + cNome + space( 72 - Len(cNome) ) + ;
			Transform( (nValor / 100), "@E 999,999,999.99") ) )
			//"Processo " ### - "Filial " ### - "Matricula " ### - Funcionario " ### " - " + "Valor " ###.##
		endif
		nRegsGrav++
		nTotVal += nValor
		gpm280Reset()
	Next nCntP

	If (nModelo == 1)
		// MONTA REGISTRO TRAILLER
		nSeq++
		nLidos:=0
		FSEEK(nHdlBco,0,0)
		nTamArq:=FSEEK(nHdlBco,0,2)
		FSEEK(nHdlBco,0,0)

		While nLidos <= nTamArq
			If !lGrava
				Exit
			EndIf
			// TIPO QUAL REGISTRO FOI LIDO
			xBuffer:=Space(85)
			fRead(nHdlBco,@xBuffer,85)
			If SubStr(xBuffer,1,1) == CHR(3)
				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo:= SubStr(xBuffer,24,60)
				lGrava:=fM080Grava( nTam,nDec,cConteudo )
				If !lGrava
					Exit
				EndIf
			EndIf
			nLidos+=85
		EndDo
		If lGrava .And. lLnVazia
			fWrite(nHdlSaida,CHR(13)+CHR(10))
		EndIf
	ElseIf ( nModelo == 2 )
		RodaCnab2(nHdlSaida,cArqent,lLnVazia)
	ElseIf ( nModelo == 3 )
		// GRAVA OS TRAILLERS DE LOTE E DE ARQUIVO
		fm080Linha(cTraiLote)
		fm080Linha(cTraiArq)
	EndIf

	// SE UTILIZAR TOTALIZADOR NO CABECALHO, TROCAR STRING POR VALOR
	If ExistBlock("GPM080HDR")
		ExecBlock("GPM080HDR",.F.,.F.)
	EndIf

	//PONTOS DE ENTRADAS UTILIZADOS PARA CRIPTOGRAFIA DE ARQUIVO DE ENVIO
	// CNAB Modelos 1 e 2
	If ExistBlock("GP410CRP")
		ExecBlock("GP410CRP",.F.,.F.)
	EndIf
	// SISPAG
	If ExistBlock("GP450CRP")
		ExecBlock("GP450CRP",.F.,.F.)
	EndIf

	fClose(nHdlSaida)
	fClose(nHdlBco)

	If lCpyS2T
		If CpyS2T( cStartPath + cNomArq, cNomDir)
			fErase( cStartPath + cNomArq )
		EndIf
	EndIf

	//Gera arquivo de log
	//Exibe apenas ap�s o fechamento do arquivo, pois caso contr�rio o arquivo fica preso at�
	//fecharem a tela de Log.
	If nTotRegs > 0
		Aadd(aLog[nTotRegs], Replicate("-",132))
		Aadd(aLog[nTotRegs], ( STR0024 + lTrim(Str(nRegsGrav,6))+ space(23) + STR0025 + Transform((nTotVal/100),"@E 999,999,999.99")) )
		//"Total de Registros Gerados: " ### "Valor Total: "
	Else
		aAdd( aLog, { OemToAnsi(STR0026) } ) //"Nenhum Registro Processado com os Parametros Informados!"
	EndIf

	If MsgYesNo(OemToAnsi( STR0020), OemToAnsi(STR0021))	// "Deseja visualizar movimentos gerados?" ### "Aten��o!"
		cData	:=	DtoS(DDATABASE)
		cHora	:=	Time()
		cArq := "GPM080" + cData
		fMakeLog (aLog,aTitle,,.T.,cArq,IIF(cPaisLoc == "CHI", STR0034 , STR0022),"M","P",,.F.)	//	"Log de Geracao de Liquidos em Arquivo."
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AbrePar   � Autor � Wagner Xavier         � Data � 26/05/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Abre arquivo de Parametros                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �AbrePar()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �GPEM080                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AbrePar(cArqSaida,cArqEnt)

	If ( nModelo == 1 .Or. nModelo == 3 )
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIf

	// PONTOS DE ENTRADAS PARA ALTERAR O NOME DA VARIAVEL CARQSAIDA
	// CNAB MODELOS 1 E 2
	If ExistBlock("GP410ARQ")
		cArqSaida := ExecBlock( "GP410ARQ", .F., .F., {cArqSaida} )
	EndIf
	// SISPAG
	If ExistBlock("GP450ARQ")
		cArqSaida := ExecBlock( "GP450ARQ", .F., .F., {cArqSaida} )
	EndIf

	// CRIA ARQUIVO SAIDA
	If ( nModelo == 1 .or. nModelo == 3 )
		nHdlSaida:=MSFCREATE(cArqSaida,0)
	Else
		nHdlSaida:=HeadCnab2(cArqSaida,cArqent)
	EndIf

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fM080Grava� Autor � Wagner Xavier         � Data � 26/05/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Geracao do Arquivo de Remessa de Comunicacao      ���
���          �Bancaria                                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpL1:=fM080Grava(ExpN1,ExpN2,ExpC1)                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM080                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
STATIC Function fM080Grava( nTam,nDec,cConteudo )
	Local lConteudo := .T., cCampo

	If ( nModelo == 1 .or. nModelo == 3 )
		// ANALISA CONTEUDO
		If Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			If "_ARQ" $ cConteudo
				gpm280Var(cConteudo)
			EndIf
			lConteudo := fM080Orig( cConteudo )
			If !lConteudo
				Return .F.
			Else
				If ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				ElseIf ValType(xConteudo)="N"
					cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo:=Substr(xConteudo,1,nTam)
				EndIf
			EndIf
		EndIf

		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo:=cCampo+Space(nTam-Len(cCampo))
		EndIf

		if !('U_BSCVERBAS' $ cConteudo )
			Fwrite( nHdlSaida,cCampo,nTam )
		Else
			lConteudo  := .f.
		endif

	Else
		DetCnab2(nHdlSaida,cArqent)
	EndIf

Return lConteudo

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fM080Orig � Autor � Wagner Xavier         � Data � 10/11/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se expressao e' valida para Remessa CNAB.          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �GPEM080                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fM080Orig( cForm )
	Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
	Private lRet := .T.

	BEGIN SEQUENCE
		xConteudo := &cForm
	END SEQUENCE

	ErrorBlock(bBlock)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fm080Linha� Autor � Vinicius S.Barreira   � Data � 11.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava linha do Arquivo Remessa SisPag                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fm080Linha( Parametro )                                    ���
���          � Parametro: letra correspondente  � linha do arquivo de     ���
���          � configura��o SisPag.                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM080()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
STATIC Function fm080Linha( cParametro ,cLocaBco , cLocaPro)
	Local nLidos    := 0
	Local nTamArq   := 0
	Local nTam      := 0
	Local nDec      := 0
	local cConteudo := ""
	Local lGerouReg := .F.

	cLocaBco := If(Empty(cLocaBco),"",cLocaBco)
	cLocaPro := If(Empty(cLocaPro),"",cLocaPro)

	If ValType( cParametro ) # "C" .or. Empty( cParametro )
		Return .T.
	EndIf

	// LE ARQUIVO DE PARAMETRIZACAO
	nLidos := 0
	fSeek(nHdlBco,0,0)
	nTamArq := fSeek(nHdlBco,0,2)
	fSeek(nHdlBco,0,0)

	While nLidos <= nTamArq
		// VERIFICA O TIPO QUAL REGISTRO FOI LIDO
		xBuffer := Space(85)
		fRead(nHdlBco,@xBuffer,85)

		If SubStr( xBuffer,1,1) == cParametro
			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo := SubStr(xBuffer,24,60)
			If ( STR0009== SubStr(xBuffer,2,15) .Or.; //"Codigo Banco   "
			STR0010==SubStr(xBuffer,2,15) .Or.;  //"Num. Agencia   "
			STR0011==SubStr(xBuffer,2,15) )      //"Num. C/C.      "
				If (!SubStr(xBuffer,2,15)$cLOCAPRO )
					cLOCABCO += &(ALLTRIM(cConteudo))
					cLOCAPRO += SubStr(xBuffer,2,15)
				EndIf
			EndIf
			If (("CGC"$Upper(SubStr(xBuffer,2,15)) .And.	AllTrim(cConteudo)=='"16670085000155"' ) .Or. cLOCABCO=="34101403000000034594")
				Alert("CONFIGURACAO INVALIDA")
				lGrava := .F.
			Else
				lGrava := fM080Grava(nTam,nDec,cConteudo)
			EndIf
			If !lGrava
				Exit
			EndIf
			lGerouReg := .T.
		EndIf

		nLidos += 85

	EndDo

	If lGerouReg
		FWRITE(nHdlSaida,CHR(13)+CHR(10))
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FDLiqu    � Autor � R.H. -                � Data � 26/01/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � SELECIONAR DIRETORIO PARA GRAVA ARQUIVO CNAB/SISPAG        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FDLiqu()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM080                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
STATIC Function FDLiqu(cLayout)
	Local mvRet		:= Alltrim(ReadVar())
	Local cType 	:= ""
	Local cArq		:= ""
	Local aDir		:= {}
	Local nDir		:= 0

	cType := If(cLayout == 1, ".CPE|*.CPE|.REM|*.REM|", If(cLayout == 2, "" , STR0015)) //" PAG |PAG "

	// COMANDO PARA SELECIONAR UM ARQUIVO.
	// PARAMETRO: GETF_LOCALFLOPPY - INCLUI O FLOPPY DRIVE LOCAL.
	//            GETF_LOCALHARD - INCLUI O HARDDISK LOCAL.
	cArq 	:= cGetFile(cType, OemToAnsi(STR0016), 0,, .T.,GETF_LOCALHARD+GETF_LOCALFLOPPY,,)  // "Selecione arquivo "
	aDir	:= { { cArq } }

	For nDir := 1 To Len(aDir)
		cArq := aDir[nDir][1]

		If !Empty(cArq)
			If !File(cArq)
				MsgAlert(OemToAnsi(STR0030)+ cArq)  // "Arquivo nao encontrado "
				Return .F.
			EndIf
		EndIf
	Next nDir

	&mvRet := cArq

Return (.T.)

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �DetCnab2      � Autor � Marcelo Silveira  � Data �23/11/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Geracao do arquivo na rotina local devido o tratamento das  �
�          �variaveis disponibilizadas para geracao do arquivo liquidos �
�����������������������������������������������������������������������Ĵ
� Uso      � Gpem080                                                    �
�������������������������������������������������������������������������*/
Static Function DetCnab2(nHandle,cLayOut,lIdCnab,cAlias)
	Local nHdlLay	:= 0
	Local lContinua := .T.
	Local cBuffer	:= ""
	Local aLayOut	:= {}
	Local aDetalhe  := {}
	Local nCntFor	:= 0
	Local nCntFor2  := 0
	Local lFormula  := ""
	Local nPosIni	:= 0
	Local nPosFim	:= 0
	Local nTamanho  := 0
	Local nDecimal  := 0
	Local bBlock	:= ErrorBlock()
	Local bErro 	:= ErrorBlock( { |e| ChecErr260(e,xConteudo) } )
	Local aGetArea  := GetArea()
	Local cIdCnab
	Local aArea
	Local nOrdem

	DEFAULT cAlias 	:= ""
	DEFAULT lIdCnab 	:= .F.
	Private xConteudo := ""

	nQtdLinLote := If(Type("nQtdLinLote") != "N",0,nQtdLinLote)

	If ( File(cLayOut) )
		nHdlLay := FOpen(cLayOut,64)
		While ( lContinua )
			cBuffer := FreadStr(nHdlLay,502)
			If ( !Empty(cBuffer) )
				If ( SubStr(cBuffer,1,1)=="1" )
					If ( SubStr(cBuffer,3,1) == "D" )
						aadd(aLayOut,{ SubStr(cBuffer,02,03),;
						SubStr(cBuffer,05,30),;
						SubStr(cBuffer,35,255)})
					EndIf
				Else
					If ( SubStr(cBuffer,3,1) == "D" )
						aadd(aDetalhe,{SubStr(cBuffer,02,03),;
						SubStr(cBuffer,05,15),;
						SubStr(cBuffer,20,03),;
						SubStr(cBuffer,23,03),;
						SubStr(cBuffer,26,01),;
						SubStr(cBuffer,27,255)})
					EndIf
				EndIf
			Else
				lContinua := .F.
			EndIf
		End
		FClose(nHdlLay)
	EndIf
	If nHandle > 0
		For nCntFor := 1 To Len(aLayOut)
			Begin Sequence
				lFormula := &(AllTrim(aLayOut[nCntFor,3]))
				If ( lFormula .And. SubStr(aLayOut[nCntFor,1],2,1)=="D" )
					cBuffer := ""
					// So gera outro identificador, caso o titulo ainda nao o tenha, pois pode ser um re-envio do arquivo
					If !Empty(cAlias) .And. lIdCnab .And. Empty((cAlias)->&(Right(cAlias,2)+"_IDCNAB"))
						// Gera identificador do registro CNAB no titulo enviado
						nOrdem := If(Alltrim(Upper(cAlias))=="SE1",16,11)
						cIdCnab := GetSxENum(cAlias, Right(cAlias,2)+"_IDCNAB",Right(cAlias,2)+"_IDCNAB"+cEmpAnt,nOrdem)
						// Garante que o identificador gerado nao existe na base
						dbSelectArea(cAlias)
						aArea := (cAlias)->(GetArea())
						dbSetOrder(nOrdem)
						While (cAlias)->(MsSeek(xFilial(cAlias)+cIdCnab))
							cMsg := ("Id CNAB " + cIdCnab + " j� existe para o arquivo " + cAlias + ". Gerando novo n�mero ")
							FWLogMsg("INFO", "", "SIGAGPE", "DetCnab2", "", "", cMsg, 0, 0)

							If ( __lSx8 )
								ConfirmSX8()
							EndIf
							cIdCnab := GetSxENum(cAlias, Right(cAlias,2)+"_IDCNAB",Right(cAlias,2)+"_IDCNAB"+cEmpAnt,nOrdem)
						EndDo
						(cAlias)->(RestArea(aArea))
						Reclock(cAlias)
						(cAlias)->&(Right(cAlias,2)+"_IDCNAB") := cIdCnab
						MsUnlock()
						ConfirmSx8()
						lIdCnab := .F. // Gera o identificacao do registro CNAB apenas uma vez no
						// titulo enviado
					EndIf
					For nCntFor2 := 1 To Len(aDetalhe)
						If ( aDetalhe[nCntFor2,1] == aLayOut[nCntFor,1] )
							xConteudo := aDetalhe[nCntFor2,6]
							If ( Empty(xConteudo) )
								xConteudo := ""
							Else
								If "_ARQ" $ xConteudo
									gpm280Var(xConteudo)
								EndIf
								xConteudo := &(AllTrim(xConteudo))
							EndIf
							nPosIni   := Val(aDetalhe[nCntFor2,3])
							nPosFim   := Val(aDetalhe[nCntFor2,4])
							nDecimal  := Val(aDetalhe[nCntFor2,5])
							nTamanho  := nPosFim-nPosIni+1
							Do Case
								Case ValType(xConteudo) == "D"
								xConteudo := GravaData(xConteudo,.F.)
								Case ValType(xConteudo) == "N"
								xConteudo := StrZero(xConteudo,nTamanho,nDecimal)
							EndCase
							xConteudo := SubStr(xConteudo,1,nTamanho)
							xConteudo := PadR(xConteudo,nTamanho)
							cBuffer += xConteudo
						EndIf
					Next nCntFor2
					cBuffer += Chr(13)+Chr(10)
					Fwrite(nHandle,cBuffer,Len(cBuffer))
					nQtdLinLote++
				EndIf
			End Sequence
		Next nCntFor
		ErrorBlock(bBlock)
	EndIf
	RestArea(aGetArea)
Return(.T.)

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �gpm280Var     � Autor � Marcelo Silveira  � Data �26/11/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Atualiza as variaveis disponibilizadas para o arquivo de    �
�          �configuracao                                                �
�����������������������������������������������������������������������Ĵ
� Uso      � Gpem080                                                    �
�������������������������������������������������������������������������*/
Static Function gpm280Var(xConteudo)

	If cPaisLoc == "MEX"
		If( "CIC_ARQ"     $ xConteudo, CIC_ARQ     := If( lRegFun, SRA->RA_CIC, SRQ->RQ_CIC ),     "" )
		If( "NOME_ARQ"    $ xConteudo, NOME_ARQ    := If( lRegFun, SRA->RA_NOME, SRQ->RQ_NOME ),    "" )
		If( "PRINOME_ARQ" $ xConteudo, PRINOME_ARQ := If( lRegFun, SRA->RA_PRINOME, SRQ->RQ_PRINOME ), "" )
		If( "SECNOME_ARQ" $ xConteudo, SECNOME_ARQ := If( lRegFun, SRA->RA_SECNOME, SRQ->RQ_SECNOME ), "" )
		If( "PRISOBR_ARQ" $ xConteudo, PRISOBR_ARQ := If( lRegFun, SRA->RA_PRISOBR, SRQ->RQ_PRISOBR ), "" )
		If( "SECSOBR_ARQ" $ xConteudo, SECSOBR_ARQ := If( lRegFun, SRA->RA_SECSOBR, SRQ->RQ_SECSOBR ), "" )
		If( "BANCO_ARQ"   $ xConteudo, BANCO_ARQ   := If( lRegFun, AllTrim(SRA->RA_BCDEPSA), AllTrim(SRQ->RQ_BCDEPBE)), "" )
		If( "CONTA_ARQ"   $ xConteudo, CONTA_ARQ   := If( lRegFun, AllTrim(SRA->RA_CTDEPSA), AllTrim(SRQ->RQ_CTDEPBE)), "" )
	EndIf

Return()

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �gpm280Reset   � Autor � Marcelo Silveira  � Data �26/11/2012�
�����������������������������������������������������������������������Ĵ
�Descri��o �Limpa o conteudo da variaveis usadas no arquivo de config.  �
�����������������������������������������������������������������������Ĵ
� Uso      � Gpem080                                                    �
�������������������������������������������������������������������������*/
STATIC FUNCTION gpm280Reset()
	CIC_ARQ		:= ""
	NOME_ARQ	:= ""
	PRINOME_ARQ	:= ""
	SECNOME_ARQ	:= ""
	PRISOBR_ARQ	:= ""
	SECSOBR_ARQ	:= ""
	BANCO_ARQ	:= ""
	CONTA_ARQ	:= ""
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ĳ��
���Funcao    �GPM080Empresa� Autor � Adilson Silva      � Data � 05/04/13 ���
�������������������������������������������������������������������������ĳ��
���Descricao �Busca o CNPJ da Empresa com Convenio no Banco para o CNAB.  ���
�������������������������������������������������������������������������ĳ��
��� Uso      � GPEM080()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GPM080Empresa(cFil, cCodCnpj, cNomeEmpr)
	Local aOldAtu := GetArea()
	Local aOldSm0 := SM0->(GetArea())

	DbSelectArea("SM0")
	DbSetOrder(1)
	If dbSeek(cEmpAnt + cFil)
		cCodCnpj  := SM0->M0_CGC
		cNomeEmpr := Upper(Alltrim(SM0->M0_NOMECOM))
		fInfo(@aInfo,cFil)
	EndIf

	RestArea(aOldSm0)
	RestArea(aOldAtu)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CNABSequencia� Autor � Adilson Silva      � Data � 05/04/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Busca o CNPJ da Empresa com Convenio no Banco para o CNAB.  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM450()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
STATIC Function CNABSequencia()

	Local aOldAtu := GetArea()
	Local cChave  := xFilial("RCC") + "S052" + cCodFilial
	Local cRet    := "000000"
	Local cTexto  := ""

	If lUsaBanco
		dbSelectArea( "RCC" )
		dbSetOrder( 1 )		// RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
		dbSeek( cChave )
		Do While !Eof() .And. RCC->(RCC_FILIAL+RCC_CODIGO+RCC_FIL) == cChave
			If SubStr(RCC->RCC_CONTEU,21,3) == cCodBanco .And. SubStr(RCC->RCC_CONTEU,24,5) == cCodAgenc .And. SubStr(RCC->RCC_CONTEU,30,12) == cCodConta
				cRet   := StrZero(Val(SubStr(RCC->RCC_CONTEU,43,6))+1,6)
				cTexto := Stuff(RCC->RCC_CONTEU,43,6,cRet)			// Left(RCC->RCC_CONTEU,40) + cRet
				RecLock("RCC",.F.)
				RCC->RCC_CONTEU := cTexto
				MsUnlock()
				Exit
			EndIf

			dbSkip()
		EndDo
	EndIf

	RestArea( aOldAtu )

Return( cRet )

/*/{Protheus.doc} GetBankInf
Obtem os dados sobre o banco selecionado pelo usu�rio
@author philipe.pompeu
@since 22/06/2016
@version P11
@return ${return}, ${return_description}
/*/
Static Function GetBankInf( lNewPerg )
	Local aTabS052      := {}

	fCarrTab( @aTabS052, "S052", Nil)
	If Len( aTabS052 ) == 0 .Or. ( nPos := aScan(aTabS052,{|x| x[6] == cCodBanco .And. IIf( lNewPerg .And. cPaisLoc <> "MEX",(x[7] == cCodAgenc .And. x[9] == cCodConta),.T. ) .and. (Empty(x[2]) .or. x[2] == If(! Empty(cFilDe), cFilDe, xFilial("SRA")))}) ) == 0
		Aviso(STR0021,STR0031,{STR0032}) //"ATENCAO","Banco e Filial para processamento do CNAB n�o cadastrados na tabela S052! Favor verificar!" ### Sair
		Return .F.
	EndIf
	GPM080Empresa( xFilial("SRA"), @cCodCnpj, @cNomeEmpr )
	cCodFilial := aTabS052[nPos,2]
	cCodConve  := aTabS052[nPos,5]
	cCodAgenc  := aTabS052[nPos,7]
	cDigAgenc  := aTabS052[nPos,8]
	cCodConta  := aTabS052[nPos,9]
	cDigConta  := aTabS052[nPos,10]
	cSeq       := aTabS052[nPos,11]

	SA6->(dbSeek( xFilial("SA6") + cCodBanco + cCodAgenc + cCodConta ))
Return .T.

/*/{Protheus.doc} SetArqNome
Trata o nome do arquivo.
@author philipe.pompeu
@since 22/06/2016
@version P11
@param cArqSaida, character, (Descri��o do par�metro)
@param lCpyS2T, ${param_type}, (Descri��o do par�metro)
@param cNomArq, character, (Descri��o do par�metro)
@param cNomDir, character, (Descri��o do par�metro)
@return ${return}, ${return_description}
/*/
Static Function SetArqNome(cArqSaida,lCpyS2T,cNomArq,cNomDir)
	Local nTpRemote	:= 0
	Local nAt			:= 0
	Local cNewArq		:= ""
	Local cAux			:= ""
	Local nCont		:= 1
	Default cArqSaida := ""
	Default lCpyS2T := .F.
	Default cNomArq := ""
	Default cNomDir := ""
	/*��������������������������������������������������������������������Ŀ
	|VERIFICA SE O USUARIO DEFINIU UM DIRETORIO LOCAL PARA GRAVACAO DO ARQ. |
	|DE SAIDA, POIS NESSE CASO EFETUA A GERACAO DO ARQUIVO NO SERVIDOR E AO |
	|FIM DA GERACAO COPIA PARA O DIRETORIO LOCAL E APAGA DO SERVIDOR.       |
	�����������������������������������������������������������������������*/
	If Substr(cArqSaida, 2, 1) == ":"

		//?-CHECA O SO DO REMOTE (1=WINDOWS, 2=LINUX)
		nTpRemote := (GetRemoteType())

		If nTpRemote = 2
			nAt := RAt("/", cArqSaida)
		Else
			nAt := RAt("\", cArqSaida)
		EndIf

		If nAt = 0
			//"O ENDERECO ESPECIFICADO NO PARAMETRO 'ARQUIVO DE SAIDA' NAO E VALIDO. DIGITE UM ENDERECO VALIDO CONFORME O EXEMPLO:"
			//"UNIDADE:\NOME_DO_ARQUIVO"#"/NOME_DO_ARQUIVO"
			Alert(STR0027 + CRLF + CRLF + If(nTpRemote = 1, STR0028, STR0029))
			Return
		EndIf

		cNewArq := cArqSaida

		If (cAux := Substr(cArqSaida, Len(cArqSaida), 1)) == " "
			While cAux == " "
				cNewArq	:= Substr(cArqSaida, 1, Len(cArqSaida) - nCont)
				cAux	:= Substr(cNewArq, Len(cNewArq), 1)
				nCont++
			EndDo
		EndIf

		cNomArq		:= Right(cNewArq, Len(cNewArq) - nAt)
		cNomDir		:= Left(cNewArq, nAt)

		cArqSaida	:= cStartPath + cNomArq
		lCpyS2T		:= .T.
	Endif
Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BSCVERBAS �Autor  � Junior Carvalho   � Data �  03/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gera Verbas para  folha de pagamento pelo ITAU            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BSCVERBAS( )

	cAlias := GetNextAlias()
	cFil := SRA->RA_FILIAL
	cMat := SRA->RA_MAT
	cLinha := " "

	cQuery := "SELECT RC_FILIAL, RC_MAT, RC_PD, RC_TIPO1, RC_HORAS, RC_VALOR, RC_TIPO2, RV_COD, RV_DESC, RV_TIPOCOD "
	cQuery += "	FROM "+	RetSqlName("SRC") +" ARQMOV, "+RETSQLNAME('SRV')+" SRV "
	cQuery += "	WHERE RV_COD = RC_PD "
	cQuery += "	AND SRV.D_E_L_E_T_<> '*'  "
	cQuery += " AND RC_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
	cQuery += "	AND RC_MAT = '"+cMat+"' "
	cQuery += "	AND RC_FILIAL = '"+cFil+"' "
	cQuery += "	AND ARQMOV.D_E_L_E_T_<> '*'  "
	cQuery += "	ORDER BY SRV.RV_TIPOCOD "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.F.)

	TcSetField(cAlias,'RC_VALOR','N',12,2)
	dbgotop()

	GERASEGD() //SEGMENTO D

	dbSelectArea(cAlias)
	DBGOTOP()
	While !Eof() .AND. (cAlias)->RC_MAT == cMat
		cConteudo := "341"
		cConteudo += "0001"
		cConteudo += "3"
		cConteudo += STRZERO(nTotFunc,5)
		cConteudo += "E"
		cConteudo += SPACE(3)

		cTipo := AllTrim( (cAlias)->RV_TIPOCOD )

		cConteudo += cTipo

		cValor := strzero( NoRound((cAlias)->RC_VALOR * 100 , 0) ,15 )
		cVerba := PADR((cAlias)->RV_COD +" - "+(cAlias)->RV_DESC,30)
		IF cTipo == "1"
			cConteudo += cVerba
			cConteudo += SPACE(05)
			cConteudo +=  cValor
			cConteudo +=  space(150)
		ELSEIF cTipo == "2"
			cConteudo +=  space(50)
			cConteudo += cVerba
			cConteudo += SPACE(05)
			cConteudo +=  cValor
			cConteudo +=  space(100)
		ELSEIF cTipo == "3"
			cConteudo +=  space(100)
			cConteudo += cVerba
			cConteudo += SPACE(05)
			cConteudo +=  cValor
			cConteudo +=  space(50)
		ENDIF
		cConteudo += SPACE(12)
		cConteudo += SPACE(10)

		FWRITE( nHdlSaida,cConteudo,240 )
		FWRITE( nHdlSaida,CRLF )

		M->NSEQ++

		dbSelectArea(cAlias)
		dbSkip()

	Enddo

	dbSelectArea(cAlias)
	dbCloseArea()
	cRet := ""
Return(alltrim(cRet))

STATIC FUNCTION GERASEGD()

	cDataArq := MesAno( If (Empty(mv_par25), dDataBase,mv_par25) )
	nVlrCrd := 0
	nVlrDeb := 0
	nVlrBase := 0
	nBaseIr := 0
	nFgts := 0
	nAteLim := 0
	nBInssPA := 0
	nBaseFgts := 0
	nBaseIrFe := 0
	aCodFol	:={}

	Fp_CodFol(@aCodFol,SRA->RA_FILIAL)

	dbSelectArea(cAlias)
	DBGOTOP()

	While !Eof() .AND. (cAlias)->RC_MAT == cMat


		cTipo := AllTrim( (cAlias)->RV_TIPOCOD )

		IF cTipo == "1"
			nVlrCrd += (cAlias)->RC_VALOR
		ELSEIF cTipo == "2"
			nVlrDeb += (cAlias)->RC_VALOR
		ELSEIF cTipo == "3"
			nVlrBase += (cAlias)->RC_VALOR
		ENDIF
		If (cAlias)->RC_PD == aCodFol[10,1]
			nBaseIr := (cAlias)->RC_VALOR
		ElseIf (cAlias)->RC_PD == aCodFol[13,1]
			nAteLim += (cAlias)->RC_VALOR
		ElseIf (cAlias)->RC_PD == aCodFol[221,1]
			nAteLim += (cAlias)->RC_VALOR
			// BASE FGTS SAL, 13.SAL E DIF DISSIDIO E DIF DISSIDIO 13
		Elseif (cAlias)->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]
			nBaseFgts += (cAlias)->RC_VALOR
			// VALOR FGTS SAL, 13.SAL E DIF DISSIDIO E DIF.DISSIDIO 13
		Elseif (cAlias)->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]
			nFgts += (cAlias)->RC_VALOR
		Elseif (cAlias)->RC_PD == aCodFol[15,1]
			nBaseIr += (cAlias)->RC_VALOR
		Elseif (cAlias)->RC_PD == aCodFol[16,1]
			nBaseIrFe += (cAlias)->RC_VALOR
		Endif
		dbSelectArea(cAlias)
		dbSkip()
	Enddo

	cConteudo := "341"
	cConteudo += "0001"
	cConteudo += "3"
	cConteudo += STRZERO(nTotFunc,5)
	cConteudo += "D"
	cConteudo += SPACE(3)
	cConteudo += substr(cDataArq,5,2)+substr(cDataArq,1,4)
	cConteudo += PADR(SRA->RA_CC,15)
	cConteudo += PADR(SRA->RA_MAT,15)
	cConteudo += PADR( POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC, "RJ_DESC") ,30)
	cConteudo += STRZERO(0,8) // FERIAS de
	cConteudo += STRZERO(0,8) // FERIAS ate
	cConteudo += STRZERO(val(SRA->RA_DEPIR),2)
	cConteudo += STRZERO(val(SRA->RA_DEPSF),2) // DEB SALRIO FAMILIA
	cConteudo += STRZERO(SRA->RA_HRSEMAN,2)
	cConteudo += Strzero(SRA->RA_SALARIO * 100 ,15) // SALARIO CONTRI
	//cConteudo += Strzero(0 ,15) // SALARIO CONTRI
	cConteudo += Strzero(nFgts*100,15) // FGTS
	cConteudo += Strzero(nVlrCrd * 100,15) // CREDITOS
	cConteudo += Strzero(nVlrDeb * 100,15) // DEBITOS
	cConteudo += Strzero(NVALOR  ,15) // LIQUIDOS
	cConteudo += Strzero(SRA->RA_SALARIO * 100 ,15) // SALARIO BASE
	cConteudo += Strzero(nBaseIr * 100 ,15) // BASE IRRF
	cConteudo += Strzero(nBaseFgts * 100,15) // BASE FGTS
	cConteudo += '00' // DATA HOLERITE
	cConteudo += SPACE(03)
	cConteudo += SPACE(10)

	FWRITE( nHdlSaida,cConteudo,240 )
	FWRITE( nHdlSaida,CRLF)
	M->NSEQ++

Return()