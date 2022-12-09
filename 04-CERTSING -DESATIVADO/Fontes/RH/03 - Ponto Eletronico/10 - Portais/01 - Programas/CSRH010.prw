#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "PONM010.CH"
#INCLUDE "AP5MAIL.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "PONCALEN.CH"
#INCLUDE "HEADERGD.CH"

#DEFINE cNOME_FONTE 	 "CSRH010.PRW"
#DEFINE cMOTIVO_INCLUSAO "INCLUSAO MANUAL"
#DEFINE cMOTIVO_EXCLUSAO "EXCLUSAO MANUAL"
#DEFINE cMOTIVO_REJEICAO "REJEICAO AUTOMATICA"
#DEFINE ELEMENTOS_AMARC  7 //Numero de Elementos do Array aMarcacoes

#DEFINE AMARC_DATA				01 //Data da Marcacao
#DEFINE AMARC_HORA      		02 //Hora da Marcacao
#DEFINE AMARC_ORDEM     		03 //Ordem da Marcacao
#DEFINE AMARC_FLAG      		04 //Flag (Origem) da Marcacao
#DEFINE AMARC_RECNO     		05 //Recno ou Logico Alterar Ordem/Turno
#DEFINE AMARC_TURNO     		06 //Turno da Marcacao
#DEFINE AMARC_FUNCAO    		07 //Funcao do Relogio
#DEFINE AMARC_GIRO      		08 //Giro do Relogio
#DEFINE AMARC_CC        		09 //Centro de Custo da Marcacao
#DEFINE AMARC_APONTA    		10 //Flag de Marcacao Apontada
#DEFINE AMARC_RELOGIO   		11 //Relogio da Marcacao
#DEFINE AMARC_TIPOMARC  		12 //Flag de Tipo de Marcacao
#DEFINE AMARC_L_ORIGEM  		13 //Define Se a Marcacao Pode ou Nao ser (Re)Ordenada
#DEFINE AMARC_DTHR2STR  		14 //String de Data/Hora para aSort
#DEFINE AMARC_PERAPONTA 		15 //String de Data com o Periodo de Apontamento
#DEFINE AMARC_SEQ       		16 //String de Sequencia da Tabela Padrao
#DEFINE AMARC_DIA       		17 //String de Dia da Semana da Tabela de Horario Padrao
#DEFINE AMARC_PROCESSO  		18 //Processo
#DEFINE AMARC_ROTEIRO   		19 //Roteiro
#DEFINE AMARC_PERIODO   		20 //Periodo
#DEFINE AMARC_NUM_PAGTO 		21 //Num. pagto
#DEFINE AMARC_DEPTO     		22 //Depto
#DEFINE AMARC_POSTO     		23 //Posto
#DEFINE AMARC_CODFUNC   		24 //C?. FUnc
#DEFINE AMARC_DATAAPO   		25 //Data de Apontamento
#DEFINE AMARC_NUMREP    		26 //N?ero do REP
#DEFINE AMARC_TPMCREP   		27 //Tipo de Marca?o no REP
#DEFINE AMARC_TIPOREG   		28 //Tipo de Registro
#DEFINE AMARC_MOTIVRG   		29 //Motivo Modifica?o do Registro
#DEFINE AMARC_TNOPC     		30 //Flag para controlar turno opcional
#DEFINE AMARC_EMPORG    		31 //Empresa Origem da marcacao
#DEFINE AMARC_FILORG    		32 //Filial Origem da marcacao
#DEFINE AMARC_MATORG    		33 //Matricula Origem da marcacao
#DEFINE AMARC_DHORG     		34 //Data/Hora Origem da marcacao
#DEFINE AMARC_IDORG     		35 //Identificacao da Origem da marcacao

#DEFINE CALEND_POS_DATA         01 // Data
#DEFINE CALEND_POS_ORDEM        02 // Ordem
#DEFINE CALEND_POS_HORA         03 // Hora
#DEFINE CALEND_POS_TIPO_MARC    04 // Tipo Marc
#DEFINE CALEND_POS_NUM_MARC     05 // No Marc.
#DEFINE CALEND_POS_TIPO_DIA     06 // Tipo Dia
#DEFINE CALEND_POS_HRS_TRABA    07 // Horas Trabalhada no Periodo
#DEFINE CALEND_POS_SEQ_TURNO    08 // Sequˆncia de Turno
#DEFINE CALEND_POS_HRS_INTER    09 // Horas de Intervalo
#DEFINE CALEND_POS_EXCECAO      10 // Excecao ( E-Excecao, # E - nao e excecao )
#DEFINE CALEND_POS_MOT_EXECAO   11 // Motivo da Excecao
#DEFINE CALEND_POS_TIPO_HE_NOR  12 // Tipo de hora extra normal
#DEFINE CALEND_POS_TIPO_HE_NOT  13 // Tipo de hora extra noturna
#DEFINE CALEND_POS_TURNO        14 // Turno de Trabalho
#DEFINE CALEND_POS_CC           15 // Centro de Custo do Periodo
#DEFINE CALEND_POS_PG_NONA_HORA	16 // Pagamento de Nona Hora
#DEFINE CALEND_POS_LIM_MARCACAO 17 // Limite de Marcacao Inicial/Final
#DEFINE CALEND_POS_COD_REFEICAO 18 // Codigo da Refeicao
#DEFINE CALEND_POS_FERIADO      19 // Dia e Feriado
#DEFINE CALEND_POS_TP_HE_FER_NR 20 // Tipo de Hora Extra Feriado Normal
#DEFINE CALEND_POS_TP_HE_FER_NT 21 // Tipo de Hora Extra Feriado Noturna
#DEFINE CALEND_POS_DESC_FERIADO 22 // Descricao do Feriado
#DEFINE CALEND_POS_REGRA        23 // Regra de Apontamento
#DEFINE CALEND_POS_AFAST        24 // Funcionario Afastado
#DEFINE CALEND_POS_TIP_AFAST    25 // Tipo do Afastamento
#DEFINE CALEND_POS_INI_AFAST    26 // Data Inicial do Afastamento
#DEFINE CALEND_POS_FIM_AFAST    27 // Data Final   do Afastamento

#DEFINE cPARAM_CAMINHO    "PARAM_CAMINHO"
#DEFINE cPARAM_MODO_DEBUG "PARAM_MODO_DEBUG"

#DEFINE cMSG1 "Prezado(a) analista, a carga para Portal do Ponto Eletrônico não foi feita para os colaboradores "+;
"na lista abaixo pois não esta cadastrado o grupo de aprovação no cadastro "+;
"de participantes."
#DEFINE cTITULO_EMAIL 	"Processo - Liberação do Portal do Ponto Eletrônico"
#DEFINE aTITULO_TABELA 	{'Filial','Colaborador','Centro de Custo','Departamento'}
#DEFINE aTYPE_COL 		{'T', 'T', 'T', 'T'}
#DEFINE aALIGN_COL 		{'left', 'left', 'left', 'left'}

#DEFINE cTIT_SEM_GRUPO_APROVACA0 "Atenção. Colaboradores sem grupo de aprovação"
#DEFINE cMSG_SEM_GRUPO_APROVACA0 "Alguns colaboradores estão sem grupo de aprovação, foi enviado um email "+;
"com a lista dos colaboradores que estão sem grupo de aprovação no "+;
"cadastro de participante."

#DEFINE cSTATUS_SEM_MARCACAO   		 "0"
#DEFINE cSTATUS_EM_MANUTENCAO		 "1"
#DEFINE cSTATUS_AGUARDANDO_APROVACAO "2"
#DEFINE cSTATUS_APROVADO			 "3"
#DEFINE cSTATUS_REPROVADO			 "4"
#DEFINE cSTATUS_AFASTAMENTO			 "5"
#DEFINE cSTATUS_NAO_JUSTIFICADO		 "6"
#DEFINE cSTATUS_APROVACAO_CONCLUIDA	 "7"
#DEFINE cSTATUS_PROCESSO_CONCLUIDO	 "8"

#DEFINE cSTATUS_APROV_EXECUTANDO   	 "1"
#DEFINE cSTATUS_APROV_AGUARDANDO	 "2"
#DEFINE cSTATUS_APROV_FINALIZADO 	 "3"

Static lSR6McImpJc
Static __LastParam__ := {}

/*
{Protheus.doc} CSRH010
Abre rotina de cadastro das marcacoes do portal - nao liberado para o usuario
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH010()
	axCadastro('PB7')
Return()

/*
{Protheus.doc} CSRH011
Faz gravacao inicial das marcacoes no portal do ponto
@Param cCC - Se preenchido, processa por Centro de custo informado
@Param cFil - Se preenchido,  processo por filial informada
@Param cMat - Se preenchido, process por matricula informada
@Param cIdLog - complemento do nome do arquivo do log
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH011(cCC, cFil, cMat, cIdLog, cPeriodo)
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local cQuery 	 := "" 	//Consulta SQL
	local calias 	 := "" 	// alias resevardo para consulta SQL
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL
	local cPonMes	 := ""
	local aAltera 	 := {}

	default cCC      := ""
	default cFil     := ""
	default cMat 	 := ""
	default cIdLog 	 := "000000"
	default cPeriodo := ""

	conout("CSRH011 iniciado em: " + dtoc(date()) + ' - ' + time())

	calias 	 := GetNextalias() 	// alias resevardo para consulta SQL

	cQuery := " SELECT "
	cQuery += " P8_FILIAL, "
	cQuery += " P8_MAT, "
	cQuery += " P8_PAPONTA "
	cQuery += " FROM  "
	cQuery += " "+RetSQLName("SP8")+" "
	cQuery += " WHERE  "
	cQuery += " D_E_L_E_T_ = ' ' "
	if !Empty(cCC)
		cQuery += " AND P8_CC = '"+cCC+"'"
	endif
	if !Empty(cFil)
		cQuery += " AND P8_FILIAL = '"+cFil+"'"
	endif

	if !Empty(cMat)
		cQuery += " AND P8_MAT = '"+cMat+"'"
	endif

	if !Empty(cPeriodo)
		cQuery += " AND P8_PAPONTA = '"+cPeriodo+"'"
	endif

	cQuery += " GROUP BY "
	cQuery += " P8_FILIAL, "
	cQuery += " P8_MAT, "
	cQuery += " P8_PAPONTA "

	PB7->(dbSetOrder(1))
	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		(calias)->(dbGoTop())
		while (calias)->(!EoF())
			SRA->(dbSetOrder(1))
			SRA->(dbSeek((calias)->(P8_FILIAL+P8_MAT)))
			cPonMes	 := GetMv('MV_PONMES')
			cFilAnt	:= SRA->RA_FILIAL
			U_CSRH012((calias)->P8_FILIAL, (calias)->P8_MAT, (calias)->P8_PAPONTA, cIdLog )
			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	else
		aAdd( aAltera, {"Query vazia", cQuery } )
	endif

	conout("CSRH011 finalizado em: " + dtoc(date()) + ' - ' + time())
Return ()

/*
{Protheus.doc} CSRH012
Monta array de marcacoes
@Return String
@author Bruno Nunes
@since 22/08/2012
@version 2.01
*/
User Function CSRH012(cFil, cMatricula, cPonMes, cIdLog, dDiaDe, dDiaAte, lAltRH )
	local cOrdem     		:= ""
	local cPerAponta		:= ""
	local dDataOk    		:= Ctod("//")
	local dPerIGeA			:= Ctod("//")
	local dPerFGeA			:= Ctod("//")
	local dPerIni     		:= Ctod("//")
	local dPerFim     		:= Ctod("//")
	local nX		 		:= 0
	local nY				:= 0
	local nDiasPer		 	:= 0
	local nPos		 		:= 0
	local nOpcx             := 2
	local nColMarc    		:= SuperGetmv( "MV_COLMARC" , NIL , 2 , cFilAnt )
	local aMarcacoes		:= {}   //Marcacoes do funcionario
	local aCloneMarc		:= {}	//Guarda as marcacoes originais
	local aRecsMarcAutDele	:= {}
	local aTabCalend  		:= {}
	local aCampos    		:= {}
	local aTabPadrao  		:= {}
	local aMarc				:= {}
	local aMarcAux			:= {}
	local cFlag 			:= {} 	//-- 11 Flag de Apontamento
	local cPerAux 			:= ''
	local lReprocessa 		:= .F.
	local cCCtAccs          := Getmv("MV_PTOCCT") //Centros de custos com acesso ao portal no momento.
	local lProcFun          := .F.
	local lCSRH012 			:= .T.
	local dLimite       	:= u_ponDLimL()

	Private __lCpoDataAlt 	:= .F.
	Private __lCpoUsuaAlt 	:= .T.
	Private cApoCla := SuperGetMV( "MV_APOCLA" , NIL , "S" , cFilAnt )//Inicializa Variaveis Private para o Apontamento

	default cFil			:= ""
	default cMatricula		:= ""
	default cPonMes       	:= ""
	default cIdLog 			:= ""
	default dDiaDe          := ""
	default dDiaAte			:= ""
	default lAltRH			:= .F.


	//Carregar o Conteudo do Periodo de Apontamento que sera Gravado no  Campo ??_PAPONTA
	cPerAponta :=  MontaPApon(cPonMes, cIdLog)

	if empty(dDiaDe)
		dDiaDe := stod(left(cPerAponta, 8))
	endif

	if empty(dDiaAte)
		dDiaAte := stod(right(cPerAponta, 8))
	endif

	dDatabase := iif( dDiaAte > dLimite, dLimite, dDiaAte)

	cCCtAccs := AllTrim(cCCtAccs)
	lProcFun := .F.

	if !empty(cFil) .and. !empty(cMatricula) .and. !empty(cPerAponta)
		aAreaAux    := SP8->( GetArea() )
		nColMarc    *= 2

		dPerIni := stod( left(cPerAponta, 8)) //dDiaDe
		dPerFim := stod(right(cPerAponta, 8)) //dDiaAte

		//Posiciona no funcionario
		/*+--------------------------------------------------------------------------------------------------------+
		| Caso a rotina de carga de marcações do portal tenha sido invocada pela rotina de Leitura e Apontamento |
		| das marcações, não realiza reposicionamento da tabela de funcionarios SRA.                             |
		| Devido ao processamento em MultiThreads, a rotina faz "copias" do SRA uma para cada Thread e já mantem |
		| a tabela posicionada.                                                                                  |
		| Na tentativa de reposicionar a tabela SRA, ocorrerá erro "Index not found".                            |
		+--------------------------------------------------------------------------------------------------------+
		*/
		if !Isincallstack("PONM010")
			SRA->(dbSelectArea("SRA"))
			SRA->(dbSetOrder(1))
			SRA->(dbSeek(cFil+Alltrim(cMatricula)))
		endif

		if Empty(cCCtAccs)
			lProcFun := .T.
		Elseif SRA->(AllTrim(RA_CC)) $ AllTrim(cCCtAccs)
			lProcFun := .T.
		endif

		if regra99(cFil, cMatricula)
			conout("CSRH012 regra 99 - ignorado")
			return aMarc
		endif

		if lProcFun
			//Inicializa Variaveis
			cSpaceMotiVrg 	:= Space( Len( SP8->P8_MOTIVRG))
			dPerIGeA		:= dPerIni
			dPerFGeA		:= Min( dPerFim , dDataBase )

			//Cria Tabela de Horario Padrao do Funcionario
			if SRA->( !CriaCalend(	dPerIni			,;	//01 -> Data Inicial do Periodo
			dPerFim  	    ,;	//02 -> Data Final do Periodo
			SRA->RA_TNOTRAB	,;	//03 -> Turno
			SRA->RA_SEQTURN	,;	//04 -> Sequencia de Turno
			@aTabPadrao		,;	//05 -> Array Tabela de Horario Padrao
			@aTabCalend		,;	//06 -> Array com o Calendario de Marcacoes
			SRA->RA_FILIAL	,;	//07 -> Filial
			SRA->RA_MAT		,;	//08 -> Matricula
			SRA->RA_CC		,;	//09 -> Centro de Custo
			NIL     		,;	//10 -> Array com as Trocas de Turno
			NIL				,;	//11 -> Array com Todas as Excecoes do Periodo
			NIL				,;	//12 -> Se executa Query para a Montagem da Tabela Padrao
			.T.				,;	//13 -> Se executa a funcao se sincronismo do calendario
			NIL				 ;	//14 -> Se Forca a Criacao de Novo Calendario
			);
			)
			endif

			//Carrega o Marcacoes do Funcionario
			if !GetMarcacoes(	@aMarcacoes			,;	//01 -> Marcacoes dos Funcionarios
			@aTabCalend			,;	//02 -> Calendario de Marcacoes
			@aTabPadrao			,;	//03 -> Tabela Padrao
			NIL     			,;	//04 -> Turnos de Trabalho
			dDiaDe 	     		,;	//05 -> Periodo Inicial
			dDiaAte				,;	//06 -> Periodo Final
			SRA->RA_FILIAL		,;	//07 -> Filial
			SRA->RA_MAT			,;	//08 -> Matricula
			SRA->RA_TNOTRAB		,;	//09 -> Turno
			SRA->RA_SEQTURN		,;	//10 -> Sequencia de Turno
			SRA->RA_CC			,;	//11 -> Centro de Custo
			'SP8'				,;	//12 -> Alias para Carga das Marcacoes
			.T.					,;	//13 -> Se carrega Recno em aMarcacoes
			.T.		 			,;	//14 -> Se considera Apenas Ordenadas
			NIL					,;  //15 -> Verifica as Folgas Automaticas
			NIL  				,;  //16 -> Se Grava Evento de Folga Mes Anterior
			.T.					,;	//17 -> Se Carrega as Marcacoes Automaticas
			@aRecsMarcAutDele	 ;	//18 -> Registros de Marcacoes Automaticas que deverao ser Deletados
			)
				break
			endif

			//Apenas Quando nao For Exclusao/Visualizacao
			if !( ( nOpcX == 3 ) .or. ( nOpcX == 4 ) )
				//Define o Periodo para a Geracao das Marcacoes Automaticas
				if SRA->( RA_ADMISSA > dPerIni .and. RA_ADMISSA <= dPerFim )
					dPerIGeA := SRA->RA_ADMISSA
				endif
				if SRA->( RA_DEMISSA < dPerFim .and. !Empty( RA_DEMISSA ) )
					dPerFGeA := SRA->RA_DEMISSA
				endif
				dPerIGeA	:= Max( dPerIGeA , dPerIni )
				dPerFGeA	:= Min( dPerFGeA , Min(dDataBase, dPerFim ) )

				//Salva Conteudo de aMarcacoes para Verificar Havera  Reaponta
				aCloneMarc	:= aClone( aMarcacoes )
			endif

			//Cria array filtrando as marcacoes desconcideradas e dentro do calendario do colaborador
			aCampos := {}
			For nX := 1 To Len( aMarcacoes )
				//ignora marcacao desconcideradas
				if aMarcacoes[ nX , AMARC_TPMCREP ] == "D"
					Loop
				endif

				//ignora marcacao rejeitada
				if aMarcacoes[ nX , 29 ] == cMOTIVO_REJEICAO
					Loop
				endif

				//ignora marcacao igual a marcacao anterior do mesmo dia
				if nX > 1
					if 	aMarcacoes[ nX , 01 ] == aMarcacoes[ nX-1 , 01 ] .AND. ;
					aMarcacoes[ nX , 02 ] == aMarcacoes[ nX-1 , 02 ] .AND. ;
					aMarcacoes[ nX , 30 ] == aMarcacoes[ nX-1 , 30 ]
						Loop
					endif
				endif


				//ignora marcacao fora do calendario do colaborador
				if ( nPos := aScan( aTabCalend , { |x| x[ CALEND_POS_ORDEM ] == aMarcacoes[ nX , 03 ]  } ) ) > 0
					dDataOk := aTabCalend[ nPos , CALEND_POS_DATA ]
				Else
					Loop
				endif

				//referencias dos campos marcacoes estao em constates no inicio do fonte
				aAdd(aCampos, Array( 7 ) ) //Cria Array aCampos com qtd de posicoes definidas na constante
				nLenCampos := Len( aCampos ) //Ultima posicao do array
				aCampos[ nLenCampos, 01] := aMarcacoes[ nX , AMARC_ORDEM		] 	//-- 01 Ordem da Marcacao
				aCampos[ nLenCampos, 02] := dDataOk									//-- 02 Data de Referencia
				aCampos[ nLenCampos, 03] := aMarcacoes[ nX , AMARC_DATA			]	//-- 03 Data Real
				aCampos[ nLenCampos, 04] := aMarcacoes[ nX , AMARC_HORA			]	//-- 04 Hora da Ocorroncia
				aCampos[ nLenCampos, 05] := aMarcacoes[ nX , AMARC_APONTA		]	//-- 11 Flag de Apontamento
				aCampos[ nLenCampos, 06] := aMarcacoes[ nX , AMARC_PERAPONTA	]	//-- 15 String de Data com o Periodo de Apontamento
				aCampos[ nLenCampos, 07] := aMarcacoes[ nX , AMARC_TIPOMARC 	]	//-- 12 Flag de Tipo de Marcacao
			Next nX

			//Monta os Arrays aCols e aCols1 ( Conteudo )
			nDiasPer := ( dPerFim-dPerIni ) + 1
			For nX := 0 to nDiasPer
				dDataRefe := (dPerIni + nX )
				dDataReal := (dPerIni + nX )

				//Define a Ordem da Data Atual
				cOrdem := ""
				if ( nPos := aScan(aTabCalend, {|x| x[CALEND_POS_DATA] == dDataRefe .and. x[CALEND_POS_TIPO_MARC] == "1E" } ) ) > 0
					cOrdem   := aTabCalend[ nPos , CALEND_POS_ORDEM ]
				Else
					Loop
				endif

				//Define a 1a Marcacao pertencente a Ordem corrente
				if ( nPos := aScan(aCampos, { |x| x[1] == cOrdem } ) ) > 0
					dDataReal := aCampos[nPos, 3]
				endif

				if dDataReal < dDiaDe .Or. dDataReal > dDiaAte
					loop
				endif

				aMarcAux := {}
				aAdd(aMarcAux, dDataReal)

				cFlag := '' 	//-- 11 Flag de Apontamento
				cPerAux := '' 	//-- 15 String de Data com o Periodo de Apontamento

				lReprocessa := .F.
				For nY := 1 to 8
					if nPos > 0 .and. nPos <= Len(aCampos) .and. aCampos[ nPos, 01 ] == cOrdem

						if (nY == 1 .or. nY == 2) .and. aCampos[ nPos, 07 ] == 'A' //Tratamento para não gerar marc automatica na primeira entrada e primeira saida
							loop
						endif
						aAdd( aMarcAux, Replace( StrZero( aCampos[ nPos, 4 ], 5, 2 ), '.', ':' ) ) 				//-- 01 Hora da Marcacao
						cFlag 	:= aCampos[ nPos, 05 ] 											   				//-- 11 Flag de Apontamento
						cPerAux := iif( len( alltrim( aCampos[ nPos, 06 ] ) ) == 16, aCampos[ nPos, 06 ] , '' )	//-- 15 String de Data com o Periodo de Apontamento

						//Ajusta apontamento caso seja a horario de saida seja no outro dia

						if aCampos[ nPos, 3 ] != dDataReal
							lReprocessa := .T.
						endif
					Else
						aAdd( aMarcAux, Space(5) ) //01 - Hora da Marcacao
					endif
					nPos ++
				Next nY

				aAdd( aMarcAux, HorasNega( SRA->RA_FILIAL, SRA->RA_MAT, dDataReal, cIdLog ) )	//-- Horas Negativas
				aAdd( aMarcAux, HorasPosi( SRA->RA_FILIAL, SRA->RA_MAT, dDataReal, cIdLog ) )	//-- Horas Positivas
				aAdd( aMarcAux, cOrdem ) 	//-- 01 Ordem da Marcacao
				aAdd( aMarcAux, cFlag ) 	//-- 11 Flag de Apontamento
				aAdd( aMarcAux, iif( !empty( cPerAux ), cPerAux, cPerAponta) ) 	//-- 15 String de Data com o Periodo de Apontamento
				aAdd( aMarcAux, SRA->RA_TNOTRAB )
				aAdd( aMarc, aMarcAux )
			Next nX

			//verifica se o array de marcacoes foi preenchida
			if len(aMarc) > 0
				//Grava marcacoes na tabela PB7
				if !GravaPB7(aMarc, SRA->RA_FILIAL, SRA->RA_MAT, /*lForcaVersao*/, /*aMarcMan*/ , /*aApon*/ ,aTabCalend , .T.    ,cPerAponta , cIdLog, /*cStatus*/, /*cStaAtr*/, /*cStaHe*/, lAltRH, lCSRH012)
					conout("[PP] 0001 - erro no retorno da rotina GRAVAPB7()")
				endif

				//Carrega marcacoes da tabela PB7
				aMarc := {}
				if !LoadPB7(@aMarc, SRA->RA_FILIAL, SRA->RA_MAT, cPerAponta, cIdLog)
					conout("[PP] 0002 - Erro ao carregar a PB7")
				endif
			endif

			dbSelectArea("SRA")

		endif
	endif

Return(aMarc)

/*
{Protheus.doc} HorasNega
Total de horas negativas por dia de marcacao
@Param cFilMat - Filial do funcionario
@Param cMatricula - Matricula do funcionario
@Param dData - Data para filtro
@Param cIdLog - complemento do nome do arquivo do log
@Return Numerico - Total de horas negativa por dia
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function HorasNega(cFilMat, cMatricula, dData, cIdLog )
	local calias  	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cQuery 	 := "" 				//Consulta SQL
	local lExeChange := .T. 			//Executa o change Query
	local lTotaliza  := .F.
	local nAux 		 := 0
	local nQuantc    := 0
	local nRec 		 := 0 				//Numero Total de Registros da consulta SQL

	default cFilMat    	:= ""
	default cMatricula 	:= ""
	default dData      	:= ctod('  /  /  ')
	default cIdLog	 	:= ""

	if !empty(cFilMat) .And. !empty(cMatricula) .And. !empty(dtos(dData))
		cQuery := " SELECT "
		cQuery += "     PC_QUANTC , "
		cQuery += "		PC_QTABONO , "
		cQuery += "     ISNULL(SP6.P6_PORTAL, 'A') P6_PORTAL "
		cQuery += " FROM "
		cQuery += "     "+RetSQLName("SPC")+" SPC "
		cQuery += " INNER JOIN "+RetSQLName("SP9")+" SP9 ON "
		cQuery += "     SP9.P9_CODIGO      = SPC.PC_PD"
		cQuery += "     AND  SP9.P9_CLASEV IN ('02', '03', '04', '05') "
		cQuery += "     AND SP9.D_E_L_E_T_ <> '*'"
		cQuery += " LEFT JOIN "+RetSQLName("SP6")+" SP6 ON "
		cQuery += "     SP6.P6_FILIAL = '"+xFilial('SP6')+"' "
		cQuery += "     AND SP6.P6_CODIGO = SPC.PC_ABONO "
		cQuery += "     AND SP6.D_E_L_E_T_ <> '*'"
		cQuery += " WHERE "
		cQuery += "     SPC.PC_DATA ='"+DTOS(dData)+"' "
		cQuery += "     AND SPC.PC_MAT ='"+cMatricula+"'"
		cQuery += "     AND SPC.D_E_L_E_T_ <> '*'"
		cQuery += "     AND SPC.PC_USUARIO = '' "

		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			(calias)->(dbGoTop())
			while (calias)->(!EoF())
				nAux := 0
				if (calias)->PC_QTABONO == 0 .or. (cAlias)->P6_PORTAL == "2" 
					nAux := __TimeSum(nAux, (cAlias)->PC_QUANTC)
				else
					nAux := __TimeSub((cAlias)->PC_QUANTC, (cAlias)->PC_QTABONO )
				endif
				nQuantc   := __TimeSum(nQuantc, nAux)
				(calias)->(dbSkip())
			end
			(calias)->(dbCloseArea())
		endif
	endif

Return nQuantc

/*
{Protheus.doc} HorasPosi
Total de horas positivas por dia de marcacao
@Param cFilMat - Filial do funcionario
@Param cMatricula - Matricula do funcionario
@Param dData - Data para filtro
@Param cIdLog - complemento do nome do arquivo do log
@Return Numerico - Total de horas positivas por dia
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function HorasPosi(cFilMat, cMatricula, dData, cIdLog)
	local calias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cQuery 	 := "" 				//Consulta SQL
	local lExeChange := .T. 				//Executa o change Query
	local lTotaliza  := .F.
	local nQuantc    := 0
	local nRec 		 := 0 				//Numero Total de Registros da consulta SQL

	default cFilMat    := ""
	default cMatricula := ""
	default dData      := ctod('  /  /  ')
	default cIdLog     := ""

	if !empty(cFilMat) .And. !empty(cMatricula) .And. !empty(dtos(dData))
		cQuery := " SELECT "
		cQuery += "     PC_QUANTC "
		cQuery += " FROM "
		cQuery += "     "+RetSQLName("SPC")+" SPC "
		cQuery += " INNER JOIN "+RetSQLName("SP9")+" SP9 ON "
		cQuery += "     SP9.P9_CODIGO       =  SPC.PC_PD "
		cQuery += "     AND SP9.P9_TIPOCOD  =  '1' "
		cQuery += "     AND SP9.P9_CLASEV   IN ('01') "
		cQuery += "     AND SP9.D_E_L_E_T_  <> '*' "
		cQuery += " WHERE "
		cQuery += "     SPC.PC_DATA        =  '"+DTOS(dData)+"' "
		cQuery += "     AND SPC.PC_MAT      =  '"+cMatricula+ "' "
		cQuery += "     AND SPC.D_E_L_E_T_  <> '*' "
		cQuery += "     AND SPC.PC_USUARIO  = '' "

		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			while (calias)->(!EoF())
				nQuantc    := __TimeSum(nQuantc, (cAlias)->PC_QUANTC)
				(calias)->(dbSkip())
			end
			(calias)->(dbCloseArea())
		endif
	endif

Return nQuantc

/*
{Protheus.doc} GravaPB7
Grava marcacoes no portal do ponto
@Param aMarc - Array com marcacoes
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param lForcaVersao - Forca nova versao na tabela PB7
@Param aMarcMan - Array de marcacoes alteradas manualmentes
@Param aApon - Array com valores das justificativas
@Param aTabCalend - Array com calendario de apontamento
@Param lUltVer - Mantenho a ultima versao do registro
@Param cStatus - Codigo do novo status da marcacao
@Param cStatus - Status de alteracacao
0 - Nao tem alteracao,
1 - Aguardando aprovacao,
2 - Aguardando aprovacao,
3 - Aprovado, 4-Reprovado,
5 - Bloqueado pelo RH,
6 - Nao ha justificativa
@Param cPerAponta - Periodo de apontamento
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. Gravou as marcacoes do portal, .F. Nao gravou as marcacoes do portal
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function GravaPB7(aMarc, cFilFunc, cMatFunc, lForcaVersao, aMarcMan, aApon, aTabCalend, lUltVer, cPerAponta, cIdLog, cStatus, cStaAtr, cStaHe, lAltRH, lCSRH012)
	local aAnt			 := {}
	local aAux 		 	 := {}
	local aLinha     	 := {}
	local calias 	 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cQuery 	 	 := ""
	local cStaAlt        := ""
	local lExeChange 	 := .T. 			//Executa o change Query
	local lTotaliza      := .F.
	local lRetorno   	 := .F.
	local lVersaoNEW  	 := .F.
	local lVersaoARH 	 := .F.
	local lVersaoRF0 	 := .F.
	local lVersaoAFA	 := .F.
	local nPos 		 	 := 0
	local nRec 		 	 := 0 				//Numero Total de Registros da consulta SQL
	local nVersao    	 := 0
	local lAtraso 		 := .F.
	local lHE			 := .F.
	local dIni			 := ctod("//")
	local dFim			 := ctod("//")
	local lAponNLidas 	:= .T. 			//06 -> Apontar quando nao leu as marcacoes para a filial
	local lForceR 		:= .T. 			//07 - > Se deve forcçar o Reapotamento
	local lLimita 		:= .F. 			//03 -> Se deve limitar a Data Final de Apontamento a Data Base
	local lProcFil 		:= .T. 			//05 -> Processo por Filial
	local lUserDef 		:= .T. 			//02 -> Se deve considerar as configurações dos parametros do usuario
	local lWork 		:= .T. 			//01 -> Se o Start foi via Workflow
	local aMarcAlt		:= {}
	local cCcFunc		:= ""
	local cGrupoApv		:= ""
	local dAltRH		:= ctod("//")
	local cHrAltRH		:= ""
	local lPona040      := FWIsInCallStack('PONA040')
	local lPona130      := FWIsInCallStack('PONA130')
	local cLog          := ""
	local lRosa 	    := .F. 
	local lReaponta     := .F.
	local dLimite       := u_ponDLimL()
	local cAtual 		:= ""

	default lForcaVersao := .F.
	default aMarcMan 	 := {}
	default aApon 		 := {}
	default aTabCalend   := {}
	default cStatus      := ""
	default cStaAtr 	 := ""
	default cStaHe 		 := ""
	default cPerAponta 	 := ""
	default lUltVer  	 := .F.
	default cIdLog 		 := ""
	default lAltRH		 := .F. //Alteração oriunda de ponto entrada em rotina padrão do protheus.
	default lCSRH012 	 := .F.

	//Se esta na regra99 nao deve ter PB7
	if regra99(cFilFunc, cMatFunc)
		conout("	grava PB7 funcionario dentro da regra 99 - ignorado")
		return(.F.)
	endif

	//Para a execucao na rotina se não existir periodo de apontamento
	if empty(cPerAponta)
		conout("	gravaPB7 sem periodo de ponto")
		return(.F.)
	endif

	//Para a execução da rotina se não encontrar o funcionario e grupo de aprovacao
	if !getCCGrupo(cFilFunc, cMatFunc, @cCcFunc, @cGrupoApv)
		conout("	gravaPB7 parametros de func ou aprov invalidos")
		return(.F.)
	endif

	//Gera versao 0 na PB7
	u_geraVer0(cFilFunc, cMatFunc, cPerAponta, cCcFunc, cGrupoApv, dLimite)

	//Não executa rotina se não existir array com marcacoes
	if Len(aMarc) == 0
		return(.F.)
		conout("	gravaPB7 a aMarc vazio")
	endif

	//Monta qurey do participantes
	cQuery := QryPB7Ver(cFilFunc, cMatFunc, aMarc, cPerAponta)
	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		conout("	gravaPB7 - leitura dados - matricula: "+cMatFunc)
		while (calias)->(!Eof())
			cStaAlt    := cStatus
			cCodAlt    := ""	  //Zera variavel
			cAfasta    := ""	  //Zera variavel
			lRosa 	   := .F. //Zera variavel
			lVersaoARH := .F. //Zera variavel
			lVersaoRF0 := .F. //Zera variavel
			lVersaoAFA := .F. //Zera variavel
			lVersaoNEW := .F. //Zera variavel
			nVersao    := 0	  //Zera variavel
			cStaAtr    := ""
			cStaHe     := ""
			dAltRH     := ctod("//")
			cHrAltRH   := ""
			cLog 	   := ""

			//Procura pela ordem e data
			nPos := aScan(aMarc, {|x| x[12] == (calias)->PB7_ORDEM .And. x[1] == stod((calias)->PB7_DATA)})

			//Se encontra faça:
			if nPos > 0
				aLinha 	:= aMarc[nPos] //Pega dados do dia em processamento
				marcVazio(@aLinha)	//Ajusta marcação vazia
				
				cAtual  := dToS( aLinha[01] )
				lAtraso := aLinha[10] > 0 //.T. se existir hora positiva
				lHE		:= aLinha[11] > 0 //.T. se existir hora negativa

				nVersao := (calias)->PB7_VERSAO +1 //Soma mais 1 na nova versao
				cAfasta := (calias)->PB7_AFASTA //Descrição do afastamento
				cCodAlt := (calias)->PB7_ALTERH //Codigo do usuario do RH que alterou o registro

				//Verifica se o registro foi alterado pelo RH
				lVersaoARH := .F. //alteradoRH(@cStaAlt, calias, cFilFunc+cMatFunc+DTOS(aLinha[01]), cIdLog, @cCodAlt, lAltRH, @cStaAtr, @cStaHe, @dAltRH, @cHrAltRH )

				//Verifica se foi incluido atestado médico na rotina de pre-abono
				lVersaoRF0 := existeRF0( cFilFunc, cMatFunc, cPerAponta, cAtual )

				//Verifica se foi incluido afastamento na rotina de ausencia
				lVersaoAFA := funcAfas(cFilFunc, cMatFunc, cAtual, @cAfasta )

				//Verifica a necessidade de cria uma nova versao na PB7
				lVersaoNEW := NovaVersao(calias, aLinha, cCodAlt, cAfasta, cIdLog, lVersaoARH, lVersaoRF0, lVersaoAFA, lForcaVersao, @cLog, aApon, @lReaponta)  //Verifica se cria uma nova versao

				//Tratamento para quando o sistema estiver duplicando registro na PB7
				//##TODO: Analisar a necessidade dessa rotina existir
				if !TrataDupli(aLinha, aAnt, cFilFunc, cMatFunc, cIdLog)
					nVersao 	:= 0
					lVersaoNEW 	:= .F.
				endif
			endif

			//Verifica se grava nova versao da marcao
			if lVersaoNEW
				conout("	gravaPB7 - inserindo nova versao...")
				aAdd( aMarcAlt, aLinha ) //Cria array marcações editadas
				if empty( dIni )
					dIni := aLinha[01]
				elseif aLinha[01] < dIni
					dIni := aLinha[01]
				endif

				if empty( dFim )
					dFim := aLinha[01]
				elseif aLinha[01] > dFim
					dFim := aLinha[01]
				endif

				RecLock('PB7', .T.)
				PB7->PB7_FILIAL  	:= cFilFunc
				PB7->PB7_MAT 	 	:= cMatFunc
				PB7->PB7_DATA 		:= aLinha[01] //data
				PB7->PB7_VERSAO  	:= nVersao
				PB7->PB7_1E 	 	:= aLinha[02] //1E
				PB7->PB7_1S 	 	:= aLinha[03] //1S
				PB7->PB7_2E 	 	:= aLinha[04] //2E
				PB7->PB7_2S 	 	:= aLinha[05] //2S
				PB7->PB7_3E 	 	:= aLinha[06] //3E
				PB7->PB7_3S 	 	:= aLinha[07] //3S
				PB7->PB7_4E 	 	:= aLinha[08] //4E
				PB7->PB7_4S 	 	:= aLinha[09] //4S
				PB7->PB7_HRNEGV  	:= aLinha[10] //horaNeg
				PB7->PB7_HRPOSV  	:= aLinha[11] //horaPos
				PB7->PB7_ORDEM   	:= aLinha[12] //Ordem da Marcacao - Nunca alterar a ordem original
				PB7->PB7_APONTA  	:= aLinha[13] //Flag de Apontamento
				PB7->PB7_PAPONT 	:= aLinha[14] //String de Data com o Periodo de Apontamento
				PB7->PB7_TURNO   	:= aLinha[15] //SRA->RA_TNOTRAB
				PB7->PB7_AFASTA  	:= cAfasta
				PB7->PB7_CC			:= cCcFunc
				PB7->PB7_GRPAPV  	:= cGrupoApv
				PB7->PB7_ALTERH  	:= iif( empty(cCodAlt)	,       (calias)->PB7_ALTERH , cCodAlt )
				PB7->PB7_DALTRH 	:= iif( empty(dAltRH)	, sToD( (calias)->PB7_DALTRH), dAltRH  )
				PB7->PB7_HALTRH 	:= iif( empty(cHrAltRH)	,       (calias)->PB7_HALTRH , cHrAltRH )

				lRosa := lVersaoARH .or. lVersaoRF0 .or. lVersaoAFA 

				if lUltVer
					PB7->PB7_HRPOSE := (calias)->PB7_HRPOSE
					PB7->PB7_HRPOSJ := FwCutOff( (calias)->PB7_HRPOSJ, .T.)
					PB7->PB7_HRNEGE	:= (calias)->PB7_HRNEGE
					PB7->PB7_HRNEGJ := FwCutOff( (calias)->PB7_HRNEGJ, .T.)

					PB7->PB7_1ECMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[02], aLinha[14], cIdLog, (calias)->PB7_1ECATP )
					PB7->PB7_1SCMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[03], aLinha[14], cIdLog, (calias)->PB7_1SCATP )
					PB7->PB7_2ECMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[04], aLinha[14], cIdLog, (calias)->PB7_2ECATP )
					PB7->PB7_2SCMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[05], aLinha[14], cIdLog, (calias)->PB7_2SCATP )
					PB7->PB7_3ECMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[06], aLinha[14], cIdLog, (calias)->PB7_3ECATP )
					PB7->PB7_3SCMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[07], aLinha[14], cIdLog, (calias)->PB7_3SCATP )
					PB7->PB7_4ECMAN	:= TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[08], aLinha[14], cIdLog, (calias)->PB7_4ECATP )
					PB7->PB7_4SCMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[09], aLinha[14], cIdLog, (calias)->PB7_4SCATP )
					PB7->PB7_JUSMAR := (calias)->PB7_JUSMAR
				else
					if len(aMarcMan ) > 0
						PB7->PB7_1ECMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[02], aLinha[14], cIdLog, (calias)->PB7_1ECATP )
						PB7->PB7_1SCMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[03], aLinha[14], cIdLog, (calias)->PB7_1SCATP )
						PB7->PB7_2ECMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[04], aLinha[14], cIdLog, (calias)->PB7_2ECATP )
						PB7->PB7_2SCMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[05], aLinha[14], cIdLog, (calias)->PB7_2SCATP )
						PB7->PB7_3ECMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[06], aLinha[14], cIdLog, (calias)->PB7_3ECATP )
						PB7->PB7_3SCMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[07], aLinha[14], cIdLog, (calias)->PB7_3SCATP )
						PB7->PB7_4ECMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[08], aLinha[14], cIdLog, (calias)->PB7_4ECATP )
						PB7->PB7_4SCMAN := TemMarcOri(cFilFunc+cMatFunc+aLinha[12], aLinha[09], aLinha[14], cIdLog, (calias)->PB7_4SCATP )
					endif

					if len(aApon) > 0
						PB7->PB7_HRNEGE	:= aApon[1]
						PB7->PB7_HRNEGJ	:= aApon[2]
						PB7->PB7_HRPOSE := aApon[3]
						PB7->PB7_HRPOSJ := aApon[4]
						PB7->PB7_JUSMAR := aApon[5]
					endif
				endif

				if len(aTabCalend) > 0
					aAux := {}
					aAddCalen(@aAux, aLinha[01], aTabCalend)

					PB7->PB7_1ECAHR := aAux[1]
					PB7->PB7_1ECATP := aAux[2]
					PB7->PB7_1SCAHR := aAux[3]
					PB7->PB7_1SCATP := aAux[4]
					PB7->PB7_2ECAHR := aAux[5]
					PB7->PB7_2ECATP := aAux[6]
					PB7->PB7_2SCAHR := aAux[7]
					PB7->PB7_2SCATP := aAux[8]
					PB7->PB7_3ECAHR := aAux[9]
					PB7->PB7_3ECATP := aAux[10]
					PB7->PB7_3SCAHR := aAux[11]
					PB7->PB7_3SCATP := aAux[12]
					PB7->PB7_4ECAHR := aAux[13]
					PB7->PB7_4ECATP := aAux[14]
					PB7->PB7_4SCAHR := aAux[15]
					PB7->PB7_4SCATP := aAux[16]
				endif
				PB7->PB7_LOG := cLog

				if !atuPBB( lRosa )
					if lRosa

						if lAltRH
							PB7->PB7_STATUS := iif( empty(cStaAlt), cSTATUS_AFASTAMENTO, cStaAlt )
							PB7->PB7_STAATR := iif( empty(cStaAtr), cSTATUS_AFASTAMENTO, cStaAtr )
							PB7->PB7_STAHE  := iif( empty(cStaHe ), cSTATUS_AFASTAMENTO, cStaHe  )
						else
							PB7->PB7_STATUS := cSTATUS_AFASTAMENTO
							PB7->PB7_STAATR := iif( (calias)->PB7_STAATR $ "3/4", (calias)->PB7_STAATR, cSTATUS_AFASTAMENTO ) 
							PB7->PB7_STAHE  := iif( (calias)->PB7_STAHE  $ "3/4", (calias)->PB7_STAHE , cSTATUS_AFASTAMENTO )
						endif

					else

						PB7->PB7_STATUS := iif( lAtraso .or. lHE, cSTATUS_EM_MANUTENCAO, cSTATUS_SEM_MARCACAO )
						PB7->PB7_STAATR := iif( lAtraso			, cSTATUS_EM_MANUTENCAO, cSTATUS_SEM_MARCACAO )
						PB7->PB7_STAHE  := iif( lHE				, cSTATUS_EM_MANUTENCAO, cSTATUS_SEM_MARCACAO )
					endif
				endif				

				PB7->(MsUnLock())
				delVerAnt(cFilFunc, cMatFunc, aLinha[01], nVersao)
			endif

			if lVersaoNEW
				conout( "	PB7 motivo alter: " + cLog )
				conout( "	PB7 matricula...: " + cMatFunc )
				conout( "	PB7 data........: " + dtoc(aLinha[01]) )
				conout( "	PB7 marcacao....: " + PB7->PB7_1E + " - " + ;
				PB7->PB7_1S + " - " + ;
				PB7->PB7_2E + " - " + ;
				PB7->PB7_2S + " - " + ;
				PB7->PB7_3E + " - " + ;
				PB7->PB7_3S + " - " + ;
				PB7->PB7_4E + " - " + ;
				PB7->PB7_4S )				
				conout( "	PB7 versao......: " + cValTochar(nVersao) )
				conout( "	PB7 status......: " + PB7->PB7_STATUS )
				conout( "	PB7 status atr..: " + PB7->PB7_STAATR )
				conout( "	PB7 horas  atr..: " + cValToChar( aLinha[10] ) ) //horaNeg
				conout( "	PB7 status he...: " + PB7->PB7_STAHE )
				conout( "	PB7 horas  he...: " + cValToChar( aLinha[11] ) ) //horaPos
				conout( "	PB7 Afastamento.: " + PB7->PB7_AFASTA )
				conout( "	PB7 Centro Custo: " + PB7->PB7_CC )
				conout( "	PB7 Grupo Aprov.: " + PB7->PB7_GRPAPV )  
				conout( "	PB7 Alterado RH.: " + PB7->PB7_ALTERH + CRLF )
			endif

			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())

		if (!empty(dIni) .and. !empty(dFim) .and. !lCSRH012) .or. lReaponta
			if !( lPona040 .or. lPona130 )
				dIni := stod(left ( cPerAponta ,8))
				dFim := stod(right( cPerAponta ,8))
				dFim := iif( dLimite > dFim, dFim, dLimite) //se data limite maior que o fim de periodo, que seja o fim de periodo o parametro
				AjustaSX1(cFilFunc, cMatFunc, dIni, dFim, cIdLog) // Ajusta parametros na pergunta PONM010
				U_CSRH019(cPerAponta, lWork, lUserDef, lLimita, cFilFunc, lProcFil, lAponNLidas, lForceR, cIdLog) //Reaponta dia da marcacao
				U_CSRH012(cFilFunc, cMatFunc, cPerAponta, cIdLog)
			endif
		endif
		lRetorno := .T.
		conout("	gravaPB7 - finalizado")
	endif
Return(lRetorno)

/*
{Protheus.doc} NovaVersao
Verifica se houve motivo para gerar nova versao no portal do ponto
@Param calias - Alias da tabela temporaria aberta
@Param aMarc - Array com marcacoes do ponto
@Param cStatus - Status da marcacao
@Param cStatus - Status de alteracacao
0 - Nao tem alteracao,
1 - Aguardando aprovacao,
2 - Aguardando aprovacao,
3 - Aprovado, 4-Reprovado,
5 - Bloqueado pelo RH,
6 - Nao ha justificativa
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. Deve gerar nova versao, .F. Nao gera nova versao
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function NovaVersao( calias, aMarc, cCodAlt, cAfasta, cIdLog, lVersaoARH, lVersaoRF0, lVersaoAFA, lForcaVersao, cLog, aApon, lReaponta )
	local lRetorno := .F.

	default calias       := ""
	default aMarc	     := {}
	default cCodAlt      := ""
	default cAfasta      := ""
	default cIdLog       := ""
	default lVersaoARH 	 := .F.
	default lVersaoRF0 	 := .F.
	default lVersaoAFA 	 := .F.
	default lForcaVersao := .F.
	default cLog 		 := ""
	default aApon 		 := {}
	default lReaponta    := .F.

	cLog += iif((calias)->PB7_1E	 			!= aMarc[02], "Dif. PB7_1E |", "") //1E
	cLog += iif((calias)->PB7_1S 				!= aMarc[03], "Dif. PB7_1S |", "") //1S
	cLog += iif((calias)->PB7_2E 				!= aMarc[04], "Dif. PB7_2E |", "") //2E
	cLog += iif((calias)->PB7_2S 				!= aMarc[05], "Dif. PB7_2S |", "") //2S
	cLog += iif((calias)->PB7_3E 				!= aMarc[06], "Dif. PB7_3E |", "") //3E
	cLog += iif((calias)->PB7_3S 				!= aMarc[07], "Dif. PB7_3S |", "") //3S
	cLog += iif((calias)->PB7_4E 				!= aMarc[08], "Dif. PB7_4E |", "") //4E
	cLog += iif((calias)->PB7_4S 				!= aMarc[09], "Dif. PB7_4S |", "") //4S
	cLog += iif((calias)->PB7_HRNEGV 			!= aMarc[10], "Dif. PB7_HRNEGV |", "") //horaNeg
	cLog += iif((calias)->PB7_HRPOSV 			!= aMarc[11], "Dif. PB7_HRPOSV |", "") //horaPos
	if len(aApon) > 0
		cLog += iif(allTrim((calias)->PB7_HRNEGE) != allTrim(aApon[1]), "Dif. PB7_HRNEGE |", "") //eventoNeg
		cLog += iif(allTrim((calias)->PB7_HRNEGJ) != allTrim(aApon[2]), "Dif. PB7_HRNEGJ |", "") //eventoPos
		cLog += iif(allTrim((calias)->PB7_HRPOSE) != allTrim(aApon[3]), "Dif. PB7_HRPOSE |", "") //justificativaNeg
		cLog += iif(allTrim((calias)->PB7_HRPOSJ) != allTrim(aApon[4]), "Dif. PB7_HRPOSJ |", "") //justificativaPos
		cLog += iif(allTrim((calias)->PB7_JUSMAR) != allTrim(aApon[5]), "Dif. PB7_JUSMAR |", "") //justificativaMarcacao
	endif
	cLog += iif(allTrim((calias)->PB7_AFASTA) 	!= allTrim(cAfasta)  , "Afastamento |", "") //afastamento
	cLog += iif(allTrim((calias)->PB7_ALTERH) 	!= allTrim(cCodAlt)  , "Alterado RH |", "") //alterado pelo RH

	//iif(empty((calias)->PB7_STATUS), lRetorno := .T., nil) //Status
	//iif(empty((calias)->PB7_STAATR), lRetorno := .T., nil) //Status Atraso vazio
	//iif(empty((calias)->PB7_STAHE) , lRetorno := .T., nil) //Status HE vazio

	lRetorno := !empty(cLog)

	if !lRetorno
		if lVersaoARH
			lRetorno := .T.
			cLog += "Alterado RH |"
			lReaponta := .T.
		endif
		if (calias)->PB7_STATUS $ ('/0/1/2/6/7') .or. empty((calias)->PB7_STATUS)
			if lVersaoRF0 .or. lVersaoAFA
				lRetorno := .T.
				cLog += iif(lVersaoRF0, "Pre Abono +|", "Afastamento +|" )
				lReaponta := .T.
			endif
		endif
		//Status como alteracao 5 mas sem evento sistemico para tal
		if (calias)->PB7_STATUS == "5" 
			if !lVersaoARH .and. !lVersaoRF0 .and. !lVersaoAFA
				lRetorno := .T.
				cLog += "Reversao de status 5 |"
				lReaponta := .T.
			endif
		endif
	else
		lReaponta := .T.
	endif

	if lForcaVersao
		lRetorno := .T.
		cLog += "Forcando nova versao |"
	endif

Return(lRetorno)

/*
{Protheus.doc} LoadPB7
Carraga marcacoes do portal do periodo do funcionario
@Param @aMarc - Array que carregara marcacoes do ponto
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param cPerAponta - Periodo de apontamento
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. carregou marcacoes, .F. Nao carregou marcacoes
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function LoadPB7(aMarc, cFilFunc, cMatFunc, cPerAponta, cIdLog)
	local cAfast	  := ""
	local calias 	  := GetNextalias() 	// alias resevardo para consulta SQL
	local cDataExt    := ""
	local cQuery 	  := "" 				//Consulta SQL
	local dLimite     := u_ponDLimL()
	local dDateMarc   := ctod('  /  /  ')
	local lExeChange  := .T. 			//Executa o change Query
	local lTotaliza   := .F.
	local lRetorno 	  := .F. 			//Retorno da funcao - .T. Carregou tabela, .F. - Não carregou tabela
	local nRec 		  := 0 				//Numero Total de Registros da consulta SQL

	default aMarc		:= {}
	default cFilFunc	:= ""
	default cMatFunc	:= ""
	default cPerAponta  := MontaPApon("", cIdLog)
	default cIdLog      := ""

	//Verifica parametros passados
	if !Empty(cFilFunc) .and. !Empty(cMatFunc)
		//Monta qurey do participantes
		cQuery := QryPB7Ver(cFilFunc, cMatFunc, , cPerAponta)


		//Executa consultar
		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			aMarc := {}
			(calias)->(dbGoTop())
			while (calias)->(!Eof())
				aAux := {}
				dDateMarc := DtoC(StoD((calias)->PB7_DATA))
				//Não carregar data que não foi lida pelo portal
				if dLimite < StoD((calias)->PB7_DATA)
					(calias)->(dbSkip())
					loop
				endif

				if !empty(aLLTRIM(Capital((calias)->AFASTAMENTO)))
					cAfast := Alltrim( Capital((calias)->AFASTAMENTO) )
				elseif !empty( (calias)->PB7_ALTERH )
					cAfast := 'Justificado pelo RH'
				else
					cAfast := ''
				endif
				cDataExt  := (calias)->PB7_DATA
				cDataExt  := substr(cDataExt, 7, 2)+'/'+substr(cDataExt, 5, 2)+'/'+substr(cDataExt, 1, 4) +" - " + DiaSemana( StoD((calias)->PB7_DATA) , 3 )

				aAdd(aAux, Encode64((calias)->(PB7_FILIAL+','+PB7_MAT+','+PB7_DATA+','+cValToChar(PB7_VERSAO)))) //1 - Id do registro em base 64
				aAdd(aAux, (calias)->PB7_FILIAL	) //2 - filial
				aAdd(aAux, (calias)->PB7_MAT 	) //3 - matricula
				aAdd(aAux, dDateMarc        	) //4 - data
				aAdd(aAux, alltrim((calias)->PB7_1E) 	) //5 - 1E
				aAdd(aAux, alltrim((calias)->PB7_1S) 	) //6 - 1S
				aAdd(aAux, alltrim((calias)->PB7_2E) 	) //7 - 2E
				aAdd(aAux, alltrim((calias)->PB7_2S) 	) //8 - 2S
				aAdd(aAux, alltrim((calias)->PB7_3E) 	) //9 - 3E
				aAdd(aAux, alltrim((calias)->PB7_3S) 	) //10 - 3S
				aAdd(aAux, alltrim((calias)->PB7_4E) 	) //11 - 4E
				aAdd(aAux, alltrim((calias)->PB7_4S) 	) //12 - 4S
				aAdd(aAux, replace(STRZERO((calias)->PB7_HRPOSV, 5, 2), '.', ':') ) //13 - horaPos valor
				aAdd(aAux, Capital((calias)->PB7_HRPOSE )) //14 - hora positiva evento
				aAdd(aAux, alltrim(Capital( FwCutOff( (calias)->PB7_HRPOSJ, .T. )))) //15 - hora positiva evento
				aAdd(aAux, replace(STRZERO((calias)->PB7_HRNEGV, 5, 2), '.', ':') ) //16 - horaPos valor
				aAdd(aAux, Capital((calias)->PB7_HRNEGE	)) //17 - hora negativa evento
				aAdd(aAux, alltrim(Capital( FwCutOff( (calias)->PB7_HRNEGJ, .T.	)))) //18 - hora negativa evento
				aAdd(aAux, (calias)->PB7_VERSAO ) //19 - Versao
				aAdd(aAux, (calias)->PB7_STATUS) //20 - Status
				aAdd(aAux, cValToChar((calias)->PB7_1ECAHR))
				aAdd(aAux, (calias)->PB7_1ECATP)
				aAdd(aAux, cValToChar((calias)->PB7_1SCAHR))
				aAdd(aAux, (calias)->PB7_1SCATP)
				aAdd(aAux, cValToChar((calias)->PB7_2ECAHR))
				aAdd(aAux, (calias)->PB7_2ECATP)
				aAdd(aAux, cValToChar((calias)->PB7_2SCAHR))
				aAdd(aAux, (calias)->PB7_2SCATP)
				aAdd(aAux, cValToChar((calias)->PB7_3ECAHR))
				aAdd(aAux, (calias)->PB7_3ECATP)
				aAdd(aAux, cValToChar((calias)->PB7_3SCAHR))
				aAdd(aAux, (calias)->PB7_3SCATP)
				aAdd(aAux, cValToChar((calias)->PB7_4ECAHR))
				aAdd(aAux, (calias)->PB7_4ECATP)
				aAdd(aAux, cValToChar((calias)->PB7_4SCAHR))
				aAdd(aAux, (calias)->PB7_4SCATP)
				aAdd(aAux, cDataExt) //20 - Data por extenso
				aAdd(aAux, (calias)->PB7_ORDEM 	 ) //
				aAdd(aAux, (calias)->PB7_APONTA  ) //
				aAdd(aAux, (calias)->PB7_PAPONT ) //
				aAdd(aAux, alltrim((calias)->PB7_TURNO 	 )) //
				aAdd(aAux, (calias)->PB7_JUSMAR)
				aAdd(aAux, (calias)->PB7_1ECMAN)
				aAdd(aAux, (calias)->PB7_1SCMAN)
				aAdd(aAux, (calias)->PB7_2ECMAN)
				aAdd(aAux, (calias)->PB7_2SCMAN)
				aAdd(aAux, (calias)->PB7_3ECMAN)
				aAdd(aAux, (calias)->PB7_3SCMAN)
				aAdd(aAux, (calias)->PB7_4ECMAN)
				aAdd(aAux, (calias)->PB7_4SCMAN)
				aAdd(aAux, Capital((calias)->DESCEVEPOS))
				aAdd(aAux, Capital((calias)->DESCEVENEG))
				aAdd(aAux, cAfast )
				aAdd(aAux, (calias)->PB7_1ECMAN )
				aAdd(aAux, (calias)->PB7_1SCMAN )
				aAdd(aAux, (calias)->PB7_2ECMAN )
				aAdd(aAux, (calias)->PB7_2SCMAN )
				aAdd(aAux, (calias)->PB7_3ECMAN )
				aAdd(aAux, (calias)->PB7_3SCMAN )
				aAdd(aAux, (calias)->PB7_4ECMAN )
				aAdd(aAux, (calias)->PB7_4SCMAN )
				aAdd(aAux, (calias)->PB7_STAATR )
				aAdd(aAux, (calias)->PB7_STAHE  )

				aAdd(aMarc, aAux)
				(calias)->(dbSkip())
			end
			(calias)->(dbCloseArea())
			lRetorno := .T.
		endif
	endif
Return(lRetorno)

/*
{Protheus.doc} QryPB7Ver
Monta string SQL com dados da tabela de marcacoes do ponto
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param aMarc - Array que carregara marcacoes do ponto
@Param cPerAponta - Periodo de apontamento
@Return String - String SQL
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function QryPB7Ver(cFilFunc, cMatFunc, aMarc, cPerAponta)
	local cData 	 := ""
	local cPerApoAux := ""
	local cRetorno 	 := ""
	local nLinha 	 := 1

	default cFilFunc   := ""
	default cMatFunc   := ""
	default aMarc 	   := {}
	default cPerAponta := ""

	if len(aMarc) > 0
		cData += "AND PB7_DATA IN ("
		for nLinha := 1 to len(aMarc)
			iif (nLinha != 1, cData += ", ", nil)
			cData += "'"+dtos(aMarc[nLinha][1])+"'"
		next nLinha
		cData += ")"
	endif

	if !empty(cPerAponta)
		cPerApoAux := "  AND PB7_PAPONT = '" + cPerAponta + "'"
	endif

	cRetorno := " SELECT  "
	cRetorno += " PB7.PB7_FILIAL "
	cRetorno += " , PB7.PB7_MAT  "
	cRetorno += " , PB7.PB7_DATA "
	cRetorno += " , PB7.PB7_1E   "
	cRetorno += " , PB7.PB7_1S 	 "
	cRetorno += " , PB7.PB7_2E 	 "
	cRetorno += " , PB7.PB7_2S 	 "
	cRetorno += " , PB7.PB7_3E 	 "
	cRetorno += " , PB7.PB7_3S 	 "
	cRetorno += " , PB7.PB7_4E 	 "
	cRetorno += " , PB7.PB7_4S 	 "
	cRetorno += " , PB7.PB7_HRPOSV "
	cRetorno += " , PB7.PB7_HRPOSE "
	cRetorno += " , PB7.PB7_HRPOSJ "
	cRetorno += " , PB7.PB7_HRNEGV "
	cRetorno += " , PB7.PB7_HRNEGE "
	cRetorno += " , PB7.PB7_HRNEGJ "
	cRetorno += " , PB7.PB7_VERSAO "
	cRetorno += " , PB7.PB7_1ECAHR "
	cRetorno += " , PB7.PB7_1ECATP "
	cRetorno += " , PB7.PB7_1SCAHR "
	cRetorno += " , PB7.PB7_1SCATP "
	cRetorno += " , PB7.PB7_2ECAHR "
	cRetorno += " , PB7.PB7_2ECATP "
	cRetorno += " , PB7.PB7_2SCAHR "
	cRetorno += " , PB7.PB7_2SCATP "
	cRetorno += " , PB7.PB7_3ECAHR "
	cRetorno += " , PB7.PB7_3ECATP "
	cRetorno += " , PB7.PB7_3SCAHR "
	cRetorno += " , PB7.PB7_3SCATP "
	cRetorno += " , PB7.PB7_4ECAHR "
	cRetorno += " , PB7.PB7_4ECATP "
	cRetorno += " , PB7.PB7_4SCAHR "
	cRetorno += " , PB7.PB7_4SCATP "
	cRetorno += " , PB7.PB7_ORDEM  "
	cRetorno += " , PB7.PB7_APONTA "
	cRetorno += " , PB7.PB7_PAPONT "
	cRetorno += " , PB7.PB7_TURNO  "
	cRetorno += " , PB7.PB7_JUSMAR "
	cRetorno += " , PB7.PB7_1ECMAN "
	cRetorno += " , PB7.PB7_1SCMAN "
	cRetorno += " , PB7.PB7_2ECMAN "
	cRetorno += " , PB7.PB7_2SCMAN "
	cRetorno += " , PB7.PB7_3ECMAN "
	cRetorno += " , PB7.PB7_3SCMAN "
	cRetorno += " , PB7.PB7_4ECMAN "
	cRetorno += " , PB7.PB7_4SCMAN "
	cRetorno += " , SP9.P9_DPORTAL DESCEVEPOS "
	cRetorno += " , SP6.P6_DPORTAL DESCEVENEG "
	cRetorno += " , PB7.PB7_STATUS "
	cRetorno += " , isnull(RCM.RCM_DESCRI, '')  AFASTAMENTO "
	cRetorno += " , PB7.PB7_STAATR "
	cRetorno += " , PB7.PB7_STAHE  "
	cRetorno += " , PB7.PB7_AFASTA "
	cRetorno += " , PB7.PB7_ALTERH "
	cRetorno += " , PB7.PB7_DALTRH "
	cRetorno += " , PB7.PB7_HALTRH "
	cRetorno += " , PB7.PB7_CC "
	cRetorno += " , PB7.PB7_GRPAPV "
	cRetorno += " FROM  ( "
	cRetorno += "        SELECT PB7_FILIAL "
	cRetorno += "             , PB7_MAT    "
	cRetorno += "             , PB7_DATA   "
	cRetorno += "             , MAX(PB7_VERSAO) VERSAO   "
	cRetorno += "        FROM  "+RetSqlName("PB7")+" "
	cRetorno += "        WHERE PB7_FILIAL = '" + cFilFunc + "'"
	cRetorno += "          AND PB7_MAT    = '" + cMatFunc + "'"
	cRetorno += "          "+cPerApoAux+" "
	cRetorno += "          "+cData+" "
	cRetorno += "          AND D_E_L_E_T_ = ' ' "
	cRetorno += "        GROUP BY PB7_FILIAL, PB7_MAT, PB7_DATA "
	cRetorno += "       ) PB7FIL "
	cRetorno += " INNER JOIN "+RetSqlName("PB7")+" PB7 ON PB7FIL.PB7_FILIAL = PB7.PB7_FILIAL "
	cRetorno += "                                    AND  PB7FIL.PB7_MAT    = PB7.PB7_MAT    "
	cRetorno += "                                    AND  PB7FIL.PB7_DATA   = PB7.PB7_DATA   "
	cRetorno += "                                    AND  PB7FIL.VERSAO     = PB7.PB7_VERSAO "
	cRetorno += "                                    AND PB7.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SP9")+" SP9 ON PB7.PB7_HRPOSE = P9_CODIGO AND SP9.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SP6")+" SP6 ON PB7.PB7_HRNEGE = P6_CODIGO AND SP6.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SR8")+" SR8 ON SR8.D_E_L_E_T_ = ' ' "
	cRetorno += "                                     AND SR8.R8_FILIAL = PB7.PB7_FILIAL "
	cRetorno += "                                     AND SR8.R8_MAT    = PB7.PB7_MAT "
	cRetorno += "                                     AND PB7.PB7_DATA  BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM "
	cRetorno += " LEFT  JOIN "+RetSqlName("RCM")+" RCM ON RCM.D_E_L_E_T_ = ' ' "
	cRetorno += "                                     AND RCM.RCM_TIPO   = SR8.R8_TIPOAFA "
	cRetorno += " GROUP BY "
	cRetorno += " PB7.PB7_FILIAL "
	cRetorno += " , PB7.PB7_MAT  "
	cRetorno += " , PB7.PB7_DATA "
	cRetorno += " , PB7.PB7_1E   "
	cRetorno += " , PB7.PB7_1S 	 "
	cRetorno += " , PB7.PB7_2E 	 "
	cRetorno += " , PB7.PB7_2S 	 "
	cRetorno += " , PB7.PB7_3E 	 "
	cRetorno += " , PB7.PB7_3S 	 "
	cRetorno += " , PB7.PB7_4E 	 "
	cRetorno += " , PB7.PB7_4S 	 "
	cRetorno += " , PB7.PB7_HRPOSV "
	cRetorno += " , PB7.PB7_HRPOSE "
	cRetorno += " , PB7.PB7_HRPOSJ "
	cRetorno += " , PB7.PB7_HRNEGV "
	cRetorno += " , PB7.PB7_HRNEGE "
	cRetorno += " , PB7.PB7_HRNEGJ "
	cRetorno += " , PB7.PB7_VERSAO "
	cRetorno += " , PB7.PB7_1ECAHR "
	cRetorno += " , PB7.PB7_1ECATP "
	cRetorno += " , PB7.PB7_1SCAHR "
	cRetorno += " , PB7.PB7_1SCATP "
	cRetorno += " , PB7.PB7_2ECAHR "
	cRetorno += " , PB7.PB7_2ECATP "
	cRetorno += " , PB7.PB7_2SCAHR "
	cRetorno += " , PB7.PB7_2SCATP "
	cRetorno += " , PB7.PB7_3ECAHR "
	cRetorno += " , PB7.PB7_3ECATP "
	cRetorno += " , PB7.PB7_3SCAHR "
	cRetorno += " , PB7.PB7_3SCATP "
	cRetorno += " , PB7.PB7_4ECAHR "
	cRetorno += " , PB7.PB7_4ECATP "
	cRetorno += " , PB7.PB7_4SCAHR "
	cRetorno += " , PB7.PB7_4SCATP "
	cRetorno += " , PB7.PB7_ORDEM  "
	cRetorno += " , PB7.PB7_APONTA "
	cRetorno += " , PB7.PB7_PAPONT "
	cRetorno += " , PB7.PB7_TURNO  "
	cRetorno += " , PB7.PB7_JUSMAR "
	cRetorno += " , PB7.PB7_1ECMAN "
	cRetorno += " , PB7.PB7_1SCMAN "
	cRetorno += " , PB7.PB7_2ECMAN "
	cRetorno += " , PB7.PB7_2SCMAN "
	cRetorno += " , PB7.PB7_3ECMAN "
	cRetorno += " , PB7.PB7_3SCMAN "
	cRetorno += " , PB7.PB7_4ECMAN "
	cRetorno += " , PB7.PB7_4SCMAN "
	cRetorno += " , SP9.P9_DPORTAL "
	cRetorno += " , SP6.P6_DPORTAL "
	cRetorno += " , PB7.PB7_STATUS "
	cRetorno += " , isnull(RCM.RCM_DESCRI, '')  "
	cRetorno += " , PB7.PB7_STAATR "
	cRetorno += " , PB7.PB7_STAHE "
	cRetorno += " , PB7.PB7_AFASTA "
	cRetorno += " , PB7.PB7_ALTERH "
	cRetorno += " , PB7.PB7_DALTRH "
	cRetorno += " , PB7.PB7_HALTRH "
	cRetorno += " , PB7.PB7_CC "
	cRetorno += " , PB7.PB7_GRPAPV "
	cRetorno += " ORDER BY PB7.PB7_DATA "
Return(cRetorno)

/*
{Protheus.doc} aAddCalen
Adiciona em array auxiliar o calendario caso nao encontre o dia
@Param aAux - Array para receber calendario adicionado
@Param dDateMarc - Data da marcacao
@Param aTabCalend - Array com calendario padrao
@Return boolean - .T. Adicionou calendario auxiliar, .F. Nao adicionou calendario auxiliar
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function aAddCalen(aAux, dDateMarc, aTabCalend)
	local lRetorno  := .F.
	local nConta    := 0
	local nLinha    := 0
	local nPos      := 0

	default aAux       := {}
	default dDateMarc  := ctod("//")
	default aTabCalend := {}

	if len(aTabCalend) > 0
		nPos := aScan(aTabCalend, {|x| dtos(x[1])==dtos(dDateMarc) })
		if nPos > 0
			for nLinha := nPos To len(aTabCalend)
				if 	dtos(dDateMarc) != dtos(aTabCalend[nLinha][1])
					exit
				endif
				aAdd(aAux, aTabCalend[nLinha][3])
				aAdd(aAux, aTabCalend[nLinha][4])
				nConta++
			next nLinha
		endif
	endif
	while nConta < 8
		nConta++
		aAdd(aAux, 0)
		aAdd(aAux, '')
	end while

Return(lRetorno)

/*
{Protheus.doc} CSRH013
Altera marcacoes do portal do ponto
@Param aMarcDia - Array com marcacoes do dia
@Param cIdLog - complemento do nome do arquivo do log
@Return Array - Marcacoes do periodo
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH013(aMarcDia, cIdLog)
	local aApon			:= {}
	local aHora			:= {}
	local aMarcMan		:= {}
	local aPB7 			:= {}
	local aRetorno 		:= {}
	local aTabCalend 	:= {}
	local dataAte 		:= ctod('  /  /  ')
	local dataDe 		:= ctod('  /  /  ')

	default aMarcDia    := {}
	default cIdLog 		:= ""

	aAdd(aHora, "")

	aAdd(aHora, aMarcDia[04] )
	aAdd(aHora, aMarcDia[05] )
	aAdd(aHora, aMarcDia[06] )
	aAdd(aHora, aMarcDia[07] )
	aAdd(aHora, aMarcDia[08] )
	aAdd(aHora, aMarcDia[09] )
	aAdd(aHora, aMarcDia[10] )
	aAdd(aHora, aMarcDia[11] )

	marcVazio(@aHora)
	aAdd(aPB7, aMarcDia[03]) //aPB7 Coluna 01 - data
	aAdd(aPB7, aHora[2]) 	 //aPB7	Coluna 02 - 1E
	aAdd(aPB7, aHora[3]) 	 //aPB7	Coluna 03 - 1S
	aAdd(aPB7, aHora[4]) 	 //aPB7	Coluna 04 - 2E
	aAdd(aPB7, aHora[5]) 	 //aPB7	Coluna 05 - 2S
	aAdd(aPB7, aHora[6]) 	 //aPB7	Coluna 06 - 3E
	aAdd(aPB7, aHora[7]) 	 //aPB7	Coluna 07 - 3S
	aAdd(aPB7, aHora[8]) 	 //aPB7	Coluna 08 - 4E
	aAdd(aPB7, aHora[9]) 	 //aPB7	Coluna 09 - 4S
	aAdd(aPB7, aMarcDia[12]) //aPB7	Coluna 10 - horaNeg
	aAdd(aPB7, aMarcDia[15]) //aPB7	Coluna 11 - horaPos

	aAdd(aPB7, aMarcDia[34]) //aPB7	Coluna 12 - Ordem da Marcacao
	aAdd(aPB7, aMarcDia[35]) //aPB7	Coluna 13 - Flag de Apontamento
	aAdd(aPB7, aMarcDia[36]) //aPB7	Coluna 14 - String de Data com o Periodo de Apontamento
	aAdd(aPB7, aMarcDia[37]) //aPB7	Coluna 15 - Turno

	aAdd(aApon, aMarcDia[13]) //aPB7	Coluna 24
	aAdd(aApon, aMarcDia[14]) //aPB7	Coluna 25
	aAdd(aApon, replace( aMarcDia[16], "\", "" )) //aPB7	Coluna 26
	aAdd(aApon, replace( aMarcDia[17], "\", "" )) //aPB7	Coluna 27
	aAdd(aApon, aMarcDia[38]) //aPB7	Coluna 28

	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[18], aMarcDia[19]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[20], aMarcDia[21]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[22], aMarcDia[23]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[24], aMarcDia[25]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[26], aMarcDia[27]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[28], aMarcDia[29]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[30], aMarcDia[31]} )
	aAdd(aTabCalend, { aMarcDia[03], nil, aMarcDia[32], aMarcDia[33]} )

	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)
	aAdd(aMarcMan, cMOTIVO_INCLUSAO)

	//Posiciona no funcionario
	SRA->(dbSelectArea("SRA"))
	SRA->(dbSetOrder(1))
	if SRA->(dbSeek( aMarcDia[1]+aMarcDia[2] ))
		//Ajusta as gravacoes da SP8 de acordo com alteracoes feita pelo portal do ponto.
		if GravaSP8(aMarcDia, cIdLog)
			ReverteRF0( aMarcDia[1]+aMarcDia[2], dataDe, dataAte)
			DelApro(xFilial('PBB')+aMarcDia[1]+aMarcDia[2]+DTOS(aMarcDia[03]), cIdLog) //Apaga PBB caso exista

			//Grava as ultima alteracoes feitas pelo usuario do portal antes de o sistema agir  // aMarcDia[47]
			if GravaPB7({aPB7}, aMarcDia[1], aMarcDia[2], .T., aMarcMan, aApon, aTabCalend, /*lUltVer*/, aMarcDia[36], cIdLog, aMarcDia[47], aMarcDia[49], aMarcDia[50])
				//AjustaSX1(aMarcDia[01], aMarcDia[02], dataDe, dataAte, cIdLog) // Ajusta parametros na pergunta PONM010
				//U_CSRH019(aMarcDia[36], lWork, lUserDef, lLimita, cProcFil, lProcFil, lAponNLidas, lForceR, cIdLog) //Reaponta dia da marcacao
				//U_CSRH017(aMarcDia[01], aMarcDia[02], aMarcDia[03], '1,2,3,5', cIdLog, aMarcDia[36]) //Ajusta SPC com base na PB7
				aRetorno := U_CSRH012(aMarcDia[1], aMarcDia[2], aMarcDia[36], cIdLog, dataDe, dataAte )
			endif
		endif
	endif
Return(aRetorno)

/*
{Protheus.doc} GravaSP8
Grava marcacacoes no rotina padrao de marcacao
@Param aMarcDia - Array com marcacoes do dia
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. Gravou marcacoes, .F. Nao gravou marcacoes
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function GravaSP8(aMarcDia, cIdLog)
	local aHrMarc	 := {}
	local cChaveSP8  := ""
	local cPerAponta := ""
	local lMeiaNoite := .F.
	local lRetorno 	 := .F.
	local nHoraAnt   := 0
	local nHrMarc 	 := 0
	local nLinha 	 := 0
	local lGrava     := .T.

	default aMarcDia := {}
	default cIdLog 	 := ""

	if len(aMarcDia) > 0
		cChaveSP8  := aMarcDia[1]+aMarcDia[2]+aMarcDia[34]

		cPerAponta := MontaPApon(aMarcDia[36], cIdLog)

		iif(!empty(aMarcDia[04]), aAdd(aHrMarc, aMarcDia[04]), nil)
		iif(!empty(aMarcDia[05]), aAdd(aHrMarc, aMarcDia[05]), nil)
		iif(!empty(aMarcDia[06]), aAdd(aHrMarc, aMarcDia[06]), nil)
		iif(!empty(aMarcDia[07]), aAdd(aHrMarc, aMarcDia[07]), nil)
		iif(!empty(aMarcDia[08]), aAdd(aHrMarc, aMarcDia[08]), nil)
		iif(!empty(aMarcDia[09]), aAdd(aHrMarc, aMarcDia[09]), nil)
		iif(!empty(aMarcDia[10]), aAdd(aHrMarc, aMarcDia[10]), nil)
		iif(!empty(aMarcDia[11]), aAdd(aHrMarc, aMarcDia[11]), nil)

		//Executa delecao dos registro do dia de alteracao da marcacao
		SP8->(dbSetOrder(1))
		if SP8->(dbSeek(cChaveSP8))
			while SP8->(!EoF()) .And. cChaveSP8 == SP8->(P8_FILIAL+P8_MAT+P8_ORDEM)
				if SP8->P8_PAPONTA == cPerAponta
					if SP8->P8_FLAG $ 'E/A' .AND. SP8->P8_MOTIVRG != cMOTIVO_REJEICAO
						RecLock('SP8',.F.)
						//SP8->P8_TPMCREP	:= 'D'
						//SP8->P8_MOTIVRG	:= cMOTIVO_EXCLUSAO
						SP8->P8_APONTA = ''
						SP8->P8_TPMARCA = ''
						//SP8->P8_LOG := "cMOTIVO_EXCLUSAO GravaSP8 Participante: "+cIdLog
						SP8->(MsUnLock())
					else
						RecLock('SP8',.F.)
						//SP8->P8_LOG := 'Del GravaSP8 Participante: '+cIdLog
						SP8->(dbDelete())
						SP8->(MsUnLock())
					endif
				endif
				SP8->(dbSkip())
			end
		endif

		//inclui novas marcacoes
		for nLinha := 1 to len(aHrMarc)
			if aHrMarc[nLinha] == '00:00'
				lMeiaNoite := .T.
			endif
			nHrMarc := val(replace(aHrMarc[nLinha], ':', '.'))
			if ( nHrMarc > 0 .or. lMeiaNoite )
				lGrava     := .T.
				SP8->(dbSetOrder(1))

				if !marcRelogi( aMarcDia, nHrMarc )
					RecLock('SP8',.T.)
					SP8->P8_FILIAL 	:= aMarcDia[1]
					SP8->P8_MAT 	:= aMarcDia[2]
					SP8->P8_CC		:= posicione( 'SRA', 1, aMarcDia[1]+aMarcDia[2], 'RA_CC' )
					SP8->P8_DATA 	:= iif(nHoraAnt > nHrMarc, aMarcDia[3]+1, aMarcDia[3])
					SP8->P8_HORA    := nHrMarc
					SP8->P8_ORDEM   := aMarcDia[34] //OK
					SP8->P8_FLAG	:= 'I'
					SP8->P8_APONTA 	:= 'N'
					SP8->P8_TURNO 	:= aMarcDia[37]
					SP8->P8_PAPONTA := iif(!empty(aMarcDia[36]), aMarcDia[36], cPerAponta) //OK
					SP8->P8_DATAAPO := aMarcDia[3] //ok
					SP8->P8_TIPOREG := 'I'
					SP8->P8_DATAALT := MsDate()
					SP8->P8_HORAALT := replace(Time(), ':', '')
					SP8->P8_MOTIVRG	:= cMOTIVO_INCLUSAO
					SP8->P8_USUARIO := __cUserId
					SP8->P8_TPMARCA := ''//aTPMARCA[nLinha]
					//SP8->P8_LOG     := "NewVer GravaSP8 Participante: "+cIdLog
					SP8->(MsUnLock())
				endif
			endif
			nHoraAnt := nHrMarc
			lMeiaNoite := .F.
		next nLinha
		lRetorno := .T.
	endif
Return(lRetorno)

/*
{Protheus.doc} CSRH014
Grava aprovacoes realizadas pelo gestor
@Param cFilMat - Filial do funcionario
@Param cMatricula - Matricula do funcionario
@Param cPonMes - Periodo de apontamento
@Param cDia - Dia de processamento
@Param cStatus - Status de alteracacao
0 - Nao tem alteracao,
1 - Aguardando aprovacao,
2 - Aguardando aprovacao,
3 - Aprovado, 4-Reprovado,
5 - Bloqueado pelo RH,
6 - Nao ha justificativa
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. Gravou marcacoes, .F. Nao gravou marcacoes
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH014(cFilMat, cMatricula, cPonMes, cDia, cStatus, cIdLog, statusAtraso, statusHe, aprovador, cCriaAprov)
	local calias 	  := GetNextalias()
	local cAprovEspe  := "" //Aprovador esperado
	local chavePBB 	  := ""
	local cPerAponta  := ""
	local cQuery      := ""
	local lExeChange  := .T.
	local lTotaliza   := .F.
	local lMudouNivel := .F.
	local lPrimeiro   := .T.
	local lProcessa   := .F.
	local nNivelAprov := 0
	local nRec        := 0
	local cFilMatApr  := ""
	local lAprovHe	  := .F.
	local lAprovAtr	  := .F.
	local lAprovRH	  := .F.

	default cFilMat 	 := ""
	default cMatricula   := ""
	default cPonMes 	 := ""
	default cDia 		 := ""
	default cStatus 	 := ""
	default cIdLog 		 := ""
	default statusAtraso := ""
	default statusHe 	 := ""
	default aprovador    := ""
	default cCriaAprov   := "N"

	conout("CSRH014 - inicio")

	if !empty(cFilMat) .and. !empty(cMatricula) .and. !empty(cPonMes) .and. !empty(cDia) .and. !empty(cStatus)

		SRA->( dbSelectArea("SRA") )
		SRA->( dbSetOrder(1) )
		SRA->( dbSeek(cFilMat+Alltrim(cMatricula)) )

		cPerAponta := MontaPApon(cPonMes, cIdLog)

		conout("CSRH014 - chave: "+cFilMat+Alltrim(cMatricula)+" cria aprovacao: "+cCriaAprov)

		//verifica se a alteração é de aprovação
		if cCriaAprov == "N"
			//Verifica se o autor da alteração pode alterar
			if aprovador == cIdLog
				PB9->(dbSetOrder(1))
				if PB9->( dbSeek( xFilial('PB9')+cIdLog ) )
					lProcessa  := .T.
					cAprovEspe := cIdLog
				else
					lProcessa  := .F.
					cAprovEspe := ''
				endif
			else
				//Verifica se é substituto e esta na vigência
				PB9->(dbSetOrder(1))
				if PB9->( dbSeek( xFilial('PB9')+aprovador ) )
					if msDate() >= PB9->PB9_DTAUI .and.  msDate() <= PB9->PB9_DTAUF .and. PB9->PB9_RECES == '1' .and. cIdLog == PB9->PB9_SUBAU
						lProcessa  := .T.
						cAprovEspe := aprovador
					endif
				else
					lProcessa  := .F.
					cAprovEspe := ''
				endif
			endif
		else
			lProcessa := .T.
		endif

		if lProcessa
			cQuery := QryPB7Ver(SRA->RA_FILIAL, cMatricula, {{ctod(cDia)}}, cPerAponta)
			//Executa consultar
			if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
				while (calias)->(!Eof())
					dbSelectArea('PB7')
					PB7->(dbSetOrder(1))
					if PB7->( dbSeek(    (calias)->(PB7_FILIAL+PB7_MAT+PB7_DATA+cValToChar(PB7_VERSAO)  )) )
						while PB7->(!EoF()) .AND. (calias)->(PB7_FILIAL+PB7_MAT+PB7_DATA) == PB7->(PB7_FILIAL+PB7_MAT+DTOS( PB7_DATA ))
							if PB7->PB7_VERSAO == (calias)->PB7_VERSAO
								exit
							endif
							PB7->(dbSkip())
						end

						if (calias)->(PB7_FILIAL+PB7_MAT+PB7_DATA) == PB7->(PB7_FILIAL+PB7_MAT+DTOS( PB7_DATA ))

							lAprovAtr := !empty( PB7->PB7_HRNEGE ) .and. PB7->PB7_HRNEGV > 0
							lAprovHe  := !empty( PB7->PB7_HRPOSE ) .and. PB7->PB7_HRPOSV > 0
							lAprovRH  := cStatus == "5" .and. ( lAprovHe .or. lAprovAtr )

							//release 2 - aprovação por grupo de aprovações
							//-> Indice 1 = PBA_FILIAL+PBA_COD.
							PBA->(dbSetOrder(1))
							if ( PBA->( dbSeek( xFilial('PBA')+(calias)->PB7_GRPAPV ) ) )
								if cCriaAprov == "S" //-> Carregando PBB pela primeira vez.
									nNivelAprov	:= retNAprov( PBA->(PBA_FILIAL+PBA_COD)+cIdLog )
									PBD->( dbSetOrder(2) )
									if PBD->( dbSeek( PBA->(PBA_FILIAL+PBA_COD) ) )
										while PBD->(!EoF()) .AND. PBD->( PBD_FILIAL+PBD_GRUPO ) == PBA->(PBA_FILIAL+PBA_COD)
											if  PBD->PBD_NIVEL > nNivelAprov .or. lPrimeiro //alterado 07/11/2018 - Bruno Nunes - Não fazia quando havia somente 1 nivel
												PBB->(dbSetOrder(1))
												if !PBB->( dbSeek( PBD->( PBD_FILIAL+PBD_GRUPO+PBD_APROV )+SRA->(RA_FILIAL+RA_MAT)+dtos( ctod( cDia ) ) ) ) .AND. PBD->PBD_STATUS == '1'
													if lAprovRH .or. cStatus == "2"
														retMatApro( PBD->PBD_APROV, @cFilMatApr )
														if SRA->(RA_FILIAL+RA_MAT) != cFilMatApr
															RecLock('PBB',.T.)
															PBB->PBB_GRUPO 	:= PBD->PBD_GRUPO
															PBB->PBB_APROV 	:= PBD->PBD_APROV
															PBB->PBB_FILMAT := SRA->RA_FILIAL
															PBB->PBB_MAT 	:= SRA->RA_MAT
															PBB->PBB_DTAPON := ctod(cDia)
															PBB->PBB_PAPONT := cPerAponta
															if lPrimeiro
																if PBD->PBD_STATUS  == cSTATUS_APROV_EXECUTANDO
																	PBB->PBB_STATUS := cSTATUS_APROV_EXECUTANDO
																	lPrimeiro       := .F.																	
																else
																	PBB->PBB_STATUS := cSTATUS_APROV_FINALIZADO
																endif
																PBB->PBB_STAATR := iif( lAprovAtr, iif(lAprovRH, "5", "2" ), "6"  ) 
																PBB->PBB_STAHE  := iif( lAprovHe , iif(lAprovRH, "5", "2" ), "6"  )		
																statusAtraso    := PBB->PBB_STAATR
																statusHe 	    := PBB->PBB_STAHE																
															else
																PBB->PBB_STATUS := cSTATUS_APROV_AGUARDANDO
															endif

															PBB->PBB_NIVEL 		:= PBD->PBD_NIVEL
															PBB->PBB_LOG 		:= 'Registro criado pelo sistema'
															conout("Criando PBB")
															conout("	PBB Grupo.....: " + PBB->PBB_GRUPO)
															conout("	PBB Aprovador.: " + PBB->PBB_APROV)
															conout("	PBB Matricula.: " + PBB->PBB_MAT)
															conout("	PBB Data......: " + dtoc(PBB->PBB_DTAPON))
															conout("	PBB Status....: " + PBB->PBB_STATUS)
															conout("	PBB Status HE.: " + PBB->PBB_STAHE)
															conout("	PBB Status Atr: " + PBB->PBB_STAATR+CRLF)																
															PBB->(MsUnLock())
														endif	
													endif
												endif
												lMudouNivel := .T.
											endif
											PBD->( dbSkip() )
										end
									endif
								else

									if cStatus $ '2/5' 
										PBB->(dbSetOrder(3)) //PBB_FILIAL + PBB_GRUPO+DTOS(PBB_DTAPON)     + PBB_STATUS+PBB_FILMAT+PBB_MAT        + STR( PBB_NIVEL, 2, 0 )
										if PBB->( dbSeek( PBA->(  PBA_FILIAL + PBA_COD )+dtos( ctod( cDia ) ) +'1'+SRA->( RA_FILIAL+RA_MAT ) ) )
											if cAprovEspe == PBB->PBB_APROV
												/*
												//-> Ajusta variaveis de Status, conforme o perfil do Aprovador. (Alexandre Alves)
												Exemplo.:  Caso o colaborador possua apenas justioficativas para Horas Extras e o Aprovador em execução
												NÃO possui perfil de aprovação de Horas Extras.
												Nesse caso, no registro de aprovação na PBB para o aprovador em questão, ficará com o status que esta na PB7.
												*/
												/*
												posicione("PB9",1,xFilial("PB9")+PBB->PBB_APROV,"PB9_TIPO")
												if     PB9->PB9_TIPO  == '1' //-> Aprova Somente Atrasos.
												statusHe     := (calias)->(PB7_STAHE)
												Elseif PB9->PB9_TIPO  == '2' //-> Aprova Somente Hora Extras.
												statusAtraso := (calias)->(PB7_STAATR)
												endif
												*/
												//-> Se for PB9_TIPO = 3, significa que aprova tudo e nesse caso, mantenho as variaveis como sairam da pagina.

												RecLock('PBB',.F.)
												PBB->PBB_STATUS := cSTATUS_APROV_FINALIZADO
												PBB->PBB_LOG 	:= "Executou a aprovação e mudou para Finalizado"
												PBB->PBB_DTAVAL := msDate()

												if lAprovAtr
													PBB->PBB_STAATR := iif (statusAtraso $ "2/3/4/5/6", statusAtraso, "9")
													statusAtraso    := PBB->PBB_STAATR
												endif

												if lAprovHe
													PBB->PBB_STAHE  := iif (statusHe     $ "2/3/4/5/6", statusHe    , "9")
													statusHe        := PBB->PBB_STAHE
												endif

												conout("Executou a aprovação e mudou para Finalizado")
												conout("	PBB Grupo.....: " + PBB->PBB_GRUPO)
												conout("	PBB Aprovador.: " + PBB->PBB_APROV)
												conout("	PBB Matricula.: " + PBB->PBB_MAT)
												conout("	PBB Data......: " + dtoc(PBB->PBB_DTAPON))
												conout("	PBB Status....: " + PBB->PBB_STATUS)
												conout("	PBB Status Atr: " + PBB->PBB_STAATR)
												conout("	PBB Status HE.: " + PBB->PBB_STAHE+CRLF)

												chavePBB := PBB->( PBB_FILIAL+PBB_GRUPO+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+STR( PBB_NIVEL+1, 2, 0 ) )

												PBB->(MsUnLock())
												lMudouNivel := .T.

												PBB->(dbSetOrder(4))
												if PBB->(dbSeek(chavePBB))
													while ( PBB->(!EoF()) .and. PBB->( PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON) ) == SRA->(RA_FILIAL+RA_MAT)+dtos( ctod( cDia ) ) )
														aprovAtivo := retStaPBB( PBA->(PBA_FILIAL+PBA_COD)+PBB->PBB_APROV )
														if aprovAtivo == '1'
															RecLock('PBB',.F.)
															PBB->PBB_STATUS := cSTATUS_APROV_EXECUTANDO
															PBB->PBB_STAATR := statusAtraso //Atualiza com a ultima versao aprovada
															PBB->PBB_STAHE  := statusHe     //Atualiza com a ultima versao aprovada												
															PBB->PBB_LOG 	:= 'Mudou para executando'
															PBB->(MsUnLock())

															conout("Mudou para executando PBB")
															conout("	PBB Grupo.....: " + PBB->PBB_GRUPO)
															conout("	PBB Aprovador.: " + PBB->PBB_APROV)
															conout("	PBB Matricula.: " + PBB->PBB_MAT)
															conout("	PBB Data......: " + dtoc(PBB->PBB_DTAPON))
															conout("	PBB Status....: " + PBB->PBB_STATUS)
															conout("	PBB Status Atr: " + PBB->PBB_STAATR)
															conout("	PBB Status HE.: " + PBB->PBB_STAHE+CRLF)

															exit
														else
															RecLock('PBB',.F.)
															PBB->PBB_STATUS := cSTATUS_APROV_FINALIZADO
															PBB->PBB_STAATR := statusAtraso //Atualiza com a ultima versao aprovada
															PBB->PBB_STAHE  := statusHe     //Atualiza com a ultima versao aprovada															
															PBB->PBB_LOG 	:= 'Inativo'
															//Não muda para o status de calculado porque ainda esta no processo de aprovação
														endif

														if PBB->PBB_NIVEL == nNivelAprov .and. cAprovEspe != PBB->PBB_APROV
															RecLock('PBB',.F.)
															PBB->PBB_STATUS := cSTATUS_APROV_FINALIZADO
															PBB->PBB_LOG 	:= 'Aprovado nesse nivel por outro gestor'
															PBB->PBB_DTAVAL := msDate()
															PBB->PBB_STAATR := statusAtraso //Atualiza com a ultima versao aprovada
															PBB->PBB_STAHE  := statusHe     //Atualiza com a ultima versao aprovada		
															PBB->(MsUnLock())

															conout("Aprovado nesse nivel por outro gestor finalizado PBB")
															conout("	PBB Grupo.....: " + PBB->PBB_GRUPO)
															conout("	PBB Aprovador.: " + PBB->PBB_APROV)
															conout("	PBB Matricula.: " + PBB->PBB_MAT)
															conout("	PBB Data......: " + dtoc(PBB->PBB_DTAPON))
															conout("	PBB Status....: " + PBB->PBB_STATUS)
															conout("	PBB Status Atr: " + PBB->PBB_STAATR)
															conout("	PBB Status HE.: " + PBB->PBB_STAHE+CRLF)
														endif
														PBB->(dbSkip())
													end
												endif
											endif
										endif
									elseif cStatus == '7'
										PBB->(dbSetOrder(3)) //PBB_FILIAL + PBB_GRUPO+DTOS(PBB_DTAPON)     + PBB_STATUS+PBB_FILMAT+PBB_MAT        + STR( PBB_NIVEL, 2, 0 )
										if PBB->( dbSeek( PBA->(  PBA_FILIAL + PBA_COD )+dtos( ctod( cDia ) ) +'3'+SRA->( RA_FILIAL+RA_MAT ) ) )
											RecLock('PBB',.F.)
	
											PBB->PBB_LOG 	:= 'Reaprovado pelo o ultimo nivel'
											PBB->PBB_DTAVAL := msDate()
											PBB->PBB_STAATR := statusAtraso //Atualiza com a ultima versao aprovada
											PBB->PBB_STAHE  := statusHe     //Atualiza com a ultima versao aprovada		
											PBB->(MsUnLock())
	
											conout("Reaprovado pelo o ultimo nivel")
											conout("	PBB Grupo.....: " + PBB->PBB_GRUPO)
											conout("	PBB Aprovador.: " + PBB->PBB_APROV)
											conout("	PBB Matricula.: " + PBB->PBB_MAT)
											conout("	PBB Data......: " + dtoc(PBB->PBB_DTAPON))
											conout("	PBB Status....: " + PBB->PBB_STATUS)
											conout("	PBB Status Atr: " + PBB->PBB_STAATR)
											conout("	PBB Status HE.: " + PBB->PBB_STAHE+CRLF)
										endif
									endif
								endif

								if cStatus == '6' //-> Bolinha preta, sem ação. Passa para o proximo nivel.
									statusAtraso := "6"
									statusHe 	 := "6"
								endif								

								//Atualiza PB7
								if lMudouNivel
									RecLock('PB7',.F.)

									if aprovFim( PB7->PB7_MAT, DTOS(PB7->PB7_DATA )) .and. cCriaAprov == "N"
										PB7->PB7_STATUS := "7"
									else
										PB7->PB7_STATUS := cStatus
									endif
									PB7->PB7_LOG    := "Mudou Nivel PBB: "+cIdLog
									PB7->PB7_STAATR := statusAtraso
									PB7->PB7_STAHE  := statusHe
									PB7->(MsUnLock())

									conout("Mudou Nivel PBB: "+cIdLog)
									conout("	PB7 Grupo.....: " + PB7->PB7_GRPAPV)
									conout("	PB7 Matricula.: " + PB7->PB7_MAT)
									conout("	PB7 Data......: " + dtoc(PB7->PB7_DATA))
									conout("	PB7 Status....: " + PB7->PB7_STATUS)
									conout("	PB7 Status Atr: " + PB7->PB7_STAATR)
									conout("	PB7 Status HE.: " + PB7->PB7_STAHE+CRLF)
								else
									if 	PB7->PB7_STATUS != cStatus 		.or. ;
										PB7->PB7_STAATR != statusAtraso .or. ;
										PB7->PB7_STAHE  != statusHe
										if PB7->PB7_STATUS != "7"
											RecLock('PB7',.F.)
	
											if cStatus != "5"
												PB7->PB7_STATUS := cStatus
											endif
											PB7->PB7_LOG    := "Status diferente PB7"
											PB7->PB7_STAATR := statusAtraso
											PB7->PB7_STAHE  := statusHe
											PB7->(MsUnLock())
	
											conout("Status diferente PB7 - Participante: "+cIdLog)
											conout("	PB7 Grupo.....: " + PB7->PB7_GRPAPV)
											conout("	PB7 Matricula.: " + PB7->PB7_MAT)
											conout("	PB7 Data......: " + dtoc(PB7->PB7_DATA))
											conout("	PB7 Status....: " + PB7->PB7_STATUS)
											conout("	PB7 Status Atr: " + PB7->PB7_STAATR)
											conout("	PB7 Status HE.: " + PB7->PB7_STAHE+CRLF)
										endif	
									endif
								endif
							endif
						endif 
					endif
					(calias)->(dbSkip())
				end
				(calias)->(dbCloseArea())
			endif
		endif
	endif
	conout("CSRH014 - fim"+CRLF)
Return

static function aprovFim(cMatFunc, cData)
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local lFinal := .F.

	default cMatFunc := ""
	default cData := ""

	cQuery := "SELECT COUNT(*) TOT FROM "+RetSQLName("PBB")+" PBB WHERE D_E_L_E_T_ = ' ' AND PBB_MAT = '"+cMatFunc+"'  AND PBB_STATUS <> '3' AND PBB_DTAPON = '"+cData+"' "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		while (calias)->(!Eof())
			lFinal := (calias)->TOT == 0
			//varinfo("lFinal", lFinal)
			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif
return lFinal

/*
{Protheus.doc} MontaPApon
Monta string com perido de apontamento
@Param cPonMes - Periodo de apontamento
@Param cIdLog - complemento do nome do arquivo do log
@Return String - Periodo de apontamento
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function MontaPApon( cPonMes, cIdLog )
	local dPerFim := Ctod("//")
	local dPerIni := Ctod("//")

	default cPonMes := ""
	default cIdLog  := ""

	if Empty(cPonMes)
		dPerIni := STOD(SubStr(GetMv("MV_PONMES"),1,8))
		dPerFim := STOD(SubStr(GetMv("MV_PONMES"),10,8))
	Else
		dPerIni := STOD(left(cPonMes,8))
		dPerFim := STOD(right(cPonMes,8))
	endif

	//Carregar o Conteudo do Periodo de Apontamento que sera Gravado no  Campo ??_PAPONTA
	cPerAponta := ( Dtos( dPerIni ) + Dtos( dPerFim ) )
Return(cPerAponta)

/*
{Protheus.doc} AjustaSX1
Muda os parametros do pergunte PNM010 para que quando executar a rotina de reapontamento, reaponte somente o dia especificado
@Param cFilMat - Filial do funcionario
@Param cmatricula - Matricula do funcionario
@Param dData - Data de parametros
@Param lMarcOuroDia - .T. reapontanta o proximo dia?
@Param cIdLog - complemento do nome do arquivo do log
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function AjustaSX1(cFilMat, cmatricula, dDataIni, dDataFim, cIdLog)
	local aPerg   := {}
	local nlinha  := 0

	default cFilMat     := ""
	default cmatricula  := ""
	default dDataIni    := ctod("//")
	default dDataFim    := ctod("//")
	default cIdLog      := ""

	aAdd(aPerg, cFilMat) 		//01 - Filial De ?
	aAdd(aPerg, cFilMat)		//02 - Filial Ate ?
	aAdd(aPerg, '')				//03 - Centro de Custo De ?
	aAdd(aPerg, 'ZZZZZZZZZ')	//04 - Centro de Custo Ate ?
	aAdd(aPerg, '') 			//05 - Turno De ?
	aAdd(aPerg, 'ZZZ') 			//06 - Turno Ate ?
	aAdd(aPerg, cmatricula)		//07 - Matricula De ?
	aAdd(aPerg, cmatricula)		//08 - Matricula Ate ?
	aAdd(aPerg, '')				//09 - Nome De ?
	aAdd(aPerg, 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ')	//10 - Nome Ate ?
	aAdd(aPerg, '')				//11 - Relogio De ?
	aAdd(aPerg, 'ZZZ')			//12 - Relogio Ate ?
	aAdd(aPerg, dtoc(dDataIni))	//13 - Periodo Inicial ?
	aAdd(aPerg, dtoc(dDataFim))	//14 - Periodo Final ?
	aAdd(aPerg, '')				//15 - Regra de Apont.De ?
	aAdd(aPerg, 'ZZ')			//16 - Regra de Apont.Ate ?
	aAdd(aPerg, '2' )			//17 - Processamento ?
	aAdd(aPerg, '1')	   		//18 - Leitura/Apontamento ?
	aAdd(aPerg, '1')			//19 - Reapontar ?
	aAdd(aPerg, '1')			//20 - Ler a partir do ?
	aAdd(aPerg, 'ACDEGHMPST')	//21 - Categorias ?
	aAdd(aPerg, ' ADFT')		//22 - Reclassificar ?

	SX1->(dbSetOrder(1))
	SX1->(dbSeek('PNM010    '))
	while SX1->(!EoF()) .And. SX1->X1_GRUPO == 'PNM010    '
		nlinha++
		RecLock('SX1', .F.)
		SX1->X1_CNT01 := aPerg[nlinha]
		if SX1->X1_GSC == 'C'
			SX1->X1_PRESEL	:=  val(aPerg[nlinha])
		endif
		SX1->(MsUnLock())

		SX1->(dbSkip())
	end
Return()

/*
{Protheus.doc} CSRH015
Retorna as marcacoes para as marcacoes iniciais do relogio
@Param cFilMat - Filial do funcionario
@Param cmatricula - Matricula do funcionario
@Param cDia - Data para processamento
@Param cPonMes - Periodo em aberto
@Param cOrdem - Numero da ordem que é usado no campo P8_ORDEM no cadastro de marcacoes do padrao.
Controla quais marcacoes pertence aquela ordem especifica.
@Param cIdLog - complemento do nome do arquivo do log
@Return Array - Lista das marcacoes do funcionarios
@author Bruno Nunes
@since 12/07/2016
@version 1.2
@history 24/07/2017, Bruno Nunes, Não estava revertendo horas postivas. Alterado a deleção na SPC.
*/
User Function CSRH015(cFilMat, cMatricula, cDia, cPonMes, cOrdem, cIdLog)
	local aMarc 		:= {}
	local cChavePB7 	:= ""
	local cChaveSP8 	:= ""
	local cChaveSPC 	:= ""
	local cChaveSPK 	:= ""
	local dAnt			:= ctod('  /  /  ')
	local dataAte 		:= ctod('  /  /  ')
	local dataDe  		:= ctod('  /  /  ')
	local lMarcOuroDia  := .F.
	local lReaponta     := .T.

	default cFilMat		:= ""
	default cMatricula	:= ""
	default cDia		:= ""
	default cPonMes		:= ""
	default cOrdem		:= ""
	default cIdLog	    := ""

	if  ValParam( cFilMat	, 'C') .and. ;
	ValParam( cMatricula, 'C') .and. ;
	ValParam( ctod(cDia), 'D') .and. ;
	ValParam( cPonMes	, 'C') .and. ;
	ValParam( cOrdem	, 'C') .and. ;
	ValParam( cIdLog	, 'C')

		SRA->(dbSelectArea("SRA"))
		SRA->(dbSetOrder(1))
		SRA->(dbSeek(cFilMat+Alltrim(cMatricula)))

		cChaveSP8 := SRA->(RA_FILIAL+RA_MAT)+cOrdem

		dAnt := ctod(cDia)
		//Retorna marcacao original
		SP8->(dbSetOrder(1))
		if SP8->(dbSeek(cChaveSP8))
			while SP8->(!EoF()) .And. cChaveSP8 == SP8->(P8_FILIAL+P8_MAT+P8_ORDEM)
				if cPonMes == SP8->P8_PAPONTA
					if SP8->P8_TIPOREG == "I" .or. SP8->P8_FLAG == 'A'
						RecLock("SP8", .F.)
						if SP8->P8_DATA > dAnt
							lMarcOuroDia := .T.
						endif
						dAnt := SP8->P8_DATA
						//SP8->P8_LOG := 'Del CSRH015 Participante: '+cIdLog
						SP8->(dbDelete())
						SP8->(MsUnLock())
					else
						if SP8->P8_MOTIVRG != cMOTIVO_REJEICAO
							RecLock("SP8", .F.)
							SP8->P8_TPMCREP := ''
							SP8->P8_MOTIVRG := ''
							if SP8->P8_DATA > dAnt
								lMarcOuroDia := .T.
							endif
							dAnt := SP8->P8_DATA
							//SP8->P8_APONTA := 'S'
							//SP8->P8_LOG     := "cMOTIVO_REJEICAO CSRH015 Participante: "+cIdLog
							SP8->(MsUnLock())
						endif
					endif
				endif
				SP8->(dbSkip())
			end
		endif

		//Retorna marcacao inicial ponto
		cChavePB7 := SRA->(RA_FILIAL+RA_MAT)+DTOS(CTOD(cDia))

		PB7->(dbSetOrder(1))
		if PB7->(dbSeek(cChavePB7))
			while PB7->(!EoF()) .And. cChavePB7 == PB7->(PB7_FILIAL+PB7_MAT+DTOS(PB7_DATA))
				RecLock("PB7", .F.)
				if PB7->PB7_VERSAO != 0
					//PB7->PB7_LOG := 'Del CSRH015 Participante: '+cIdLog
					PB7->(dbDelete())
				else
					PB7->PB7_HRPOSE := ''
					PB7->PB7_HRPOSJ := ''
					PB7->PB7_HRPOSV := 0
					PB7->PB7_HRNEGE := ''
					PB7->PB7_HRNEGJ := ''
					PB7->PB7_HRNEGV := 0
					PB7->PB7_1E := ''
					PB7->PB7_1S := ''
					PB7->PB7_2E := ''
					PB7->PB7_2S := ''
					PB7->PB7_3E := ''
					PB7->PB7_3S := ''
					PB7->PB7_4E := ''
					PB7->PB7_4S := ''
					//PB7->PB7_LOG     := "Revertido CSRH015 Participante: "+cIdLog
				endif
				PB7->(MsUnLock())
				PB7->(dbSkip())
			end
		endif

		//Atualiza SPC
		cChaveSPC := SRA->(RA_FILIAL+RA_MAT)+DTOS(CTOD(cDia))

		SPC->(dbSetOrder(2))
		if SPC->(dbSeek(cChaveSPC))
			while SPC->(!EoF()) .and. cChaveSPC == SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA))
				if !SPCBlock()
					if posicione( 'SP9', 1, xFilial('SP9')+SPC->PC_PD, 'P9_CLASEV' ) $ '02/03/04/05'
						SP6->(dbSetOrder(1))
						if SP6->(dbSeek(xFilial('SP6')+SPC->PC_ABONO))
							if SP6->P6_PORTAL == '2'
								RecLock("SPC", .F.)
								//SPC->PC_LOG := 'Del CSRH015 Participante: '+cIdLog
								SPC->(dbDelete())
								SPC->(MsUnLock())
								cChaveSPK := SRA->(RA_FILIAL+RA_MAT)+DTOS(CTOD(cDia))+SPC->PC_ABONO
								SPK->(dbSetOrder(1))
								if SPK->(dbSeek(cChaveSPK))
									while SPK->(!EoF()) .And. cChaveSPK == SPK->(PK_FILIAL+PK_MAT+DTOS(PK_DATA)+SPK->PK_CODABO)
										RecLock("SPK", .F.)
										//SPK->SPK_LOG := 'Del CSRH015 Participante: '+cIdLog
										SPK->(dbDelete())
										SPK->(MsUnLock())
										SPK->(dbSkip())
									end
								endif
							endif
						else
							RecLock("SPC", .F.)
							//SPC->PC_LOG := 'Del CSRH015 Participante: '+cIdLog
							SPC->(dbDelete())
							SPC->(MsUnLock())
						endif
					elseif posicione( 'SP9', 1, xFilial('SP9')+SPC->PC_PD, 'P9_CLASEV' ) == '01'
						SP9->(dbSetOrder(1))
						if SP9->(dbSeek(xFilial('SP9')+SPC->PC_PDI)) .AND. !empty(SPC->PC_PDI) //alterado bruno nunes 24/07/2017
							//if SP9->P9_PORTAL == '2'
							RecLock("SPC", .F.)
							//SPC->PC_LOG := 'Del CSRH015 Participante: '+cIdLog
							SPC->(dbDelete())
							SPC->(MsUnLock())
							//endif
						else
							RecLock("SPC", .F.)
							//SPC->PC_LOG := 'Del CSRH015 Participante: '+cIdLog
							SPC->(dbDelete())
							SPC->(MsUnLock())
						endif
					else
						RecLock("SPC", .F.)
						//SPC->PC_LOG := 'Del CSRH015 Participante: '+cIdLog
						SPC->(dbDelete())
						SPC->(MsUnLock())
					endif
				endif
				SPC->(dbSkip())
			end
		endif

		if lMarcOuroDia
			dataDe	:= sToD( left(  allTrim( cPonMes ), 8))
			dataAte := sToD( right( allTrim( cPonMes ), 8))
		else
			dataDe  := CTOD(cDia)
			dataAte := CTOD(cDia)
		endif

		ReverteRF0(SRA->(RA_FILIAL+RA_MAT), dataDe, dataAte)
		DelApro(xFilial('PBB')+SRA->(RA_FILIAL+RA_MAT)+DTOS(CTOD(cDia)), cIdLog)

		aMarc := U_CSRH012(SRA->RA_FILIAL, SRA->RA_MAT, cPonMes, cIdLog, dataDe , dataAte   , /*lVersaoRF0*/, /*lVersaoAFA*/, /*lForcaVersao*/, /*cLog*/, /*aApon*/, /*lReaponta*/ )
	endif
Return(aMarc)

/*
{Protheus.doc} marcVazio
Retira as marcacoes vazias do arrau de marcacao
@Param aLinha - Marcacoes em array
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function marcVazio(aLinha)
	local aAux    := {}
	local nConta  := 1
	local nLinha  := 0

	for nLinha := 2 to 9
		if !empty(aLinha[nLinha])
			aAdd(aAux, aLinha[nLinha])
		endif
	next nLinha

	for nLinha := 2 to 9
		if nLinha <= len(aAux)
			aLinha[nLinha] := aAux[nConta]
		endif
		nConta++
	next nLinha
Return

/*
{Protheus.doc} TemMarcOri
Verifica se a marcacao é uma marcacao feita pelo relogio ou foi digitada manualmente
@Param cChaveSP8 - Chave para leitura da SP8
@Param cHora - Hora da marcacao
@Param cPerAponta - Periodo de apontametno
@Param cIdLog - complemento do nome do arquivo do log
@Return String - N-Marcacao manual, S-Marcacao do relogio, A-Automatica
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function TemMarcOri(cChaveSP8, cHora, cPerAponta, cIdLog, tipoMarc)
	local cRetorno := 'N'

	if !empty(cHora)
		cHora := STR(VAL(replace(cHora, ':', '.')), 5, 2)
		SP8->(dbSetOrder(1))
		if SP8->(dbSeek(cChaveSP8))
			while SP8->(!EoF()) .And. SP8->(P8_FILIAL+P8_MAT+P8_ORDEM) == cChaveSP8
				if SP8->P8_PAPONTA == cPerAponta
					if SP8->P8_FLAG == 'E' .or. SP8->P8_FLAG == 'A'
						if STR(SP8->P8_HORA, 5, 2) == cHora
							cRetorno := 'S'
							exit
						endif
					endif
				endif
				SP8->(dbSkip())
			end
		endif
	endif
Return cRetorno

/*
{Protheus.doc} funcAfas
Verifica se o funcionario esta afastado
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param cDataFunc - Data para verifcar se esta afastado nesta data
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. Esta Afastado, .F. Não esta afastado
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function funcAfas(cFilFunc, cMatFunc, cDataFunc, cAfasta)
	local calias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cQuery 	 := "" 				//Consulta SQL
	local lExeChange := .T. 			//Executa o change Query
	local lTotaliza  := .F.
	local lRetorno   := .F.
	local nRec 		 := 0 				//Numero Total de Registros da consulta SQL

	default cFilFunc  := ""
	default cMatFunc  := ""
	default cDataFunc := ""
	default cIdLog    := ""
	default cAfasta   := ""

	cQuery := " SELECT "
	cQuery += " COUNT(*) TOT, SR8.R8_TIPO "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("SR8")+" SR8 "
	cQuery += " WHERE "
	cQuery += " SR8.D_E_L_E_T_    = ' ' "
	cQuery += " AND SR8.R8_FILIAL = '"+cFilFunc+"' "
	cQuery += " AND SR8.R8_MAT 	  = '"+cMatFunc+"' "
	cQuery += " AND '"+cDataFunc+"' BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM "
	cQuery += " GROUP BY SR8.R8_TIPO "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		while (calias)->(!EoF())
			lRetorno := (calias)->TOT > 0
			cAfasta  := (calias)->R8_TIPO
			conout("	funcAfas: "+cMatFunc+" - data: "+cDataFunc)
			if lRetorno
				exit
			endif
			(calias)->(dbSkip())
		end
		(calias)->(dbCloseArea())
	endif
Return(lRetorno)

/*
{Protheus.doc} SPCBlock
Verifica se o apontamento foi alterado pela equipe do RH, se sim, retorna que registro esta bloqueado.
@Return Booleana - .T. Apontamento bloqueado pela equipe do RH, .F. Apontamento nao bloqueado pela equipe do RH
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function SPCBlock()
	local lRetorno := .F.

	if !empty(SPC->PC_USUARIO)
		lRetorno := .T.
	endif
Return lRetorno

/*
{Protheus.doc} alteradoRH
Verifica se a marcacao do portal esta com status = 5-Bloqueado pelo RH
@Param cStatus - Status passado pelo Web Service
@Param cAlias - Status lido da tabela de marcacoes do ponto PB7
@Param cChaveSPC - Chave para leitura da tabela apontamento SPC
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. - Registro com status alterado pelo RH, .F. - Registro com status que não alterado pelo RH
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
static function alteradoRH(cStatus, cAlias, cChaveSPC,cIdLog, cCodAlt, lAltRH, cStaAtr, cStaHe, dAltRH, cHrAltRH )
	local lRetorno := .F. //Retorna .T. se houve alteração e precisa de uma nova versão

	default cStatus     := "" //Utilizado para gravar o campo PB7_STATUS
	default cAlias 		:= "" //Status atual do registro
	default cChaveSPC   := "" //Chave de consulta da tabela SPC - Apontamentos
	default cIdLog 		:= "" //Codigo RD0 de quem mecheu no registro
	default cCodAlt 	:= "" //Código do usuário RH que alterou a tabela SPC - Apontamentos
	default dAltRH		:= ctod("//")
	default cHrAltRH	:= ""

	SPC->(dbSetOrder(2)) //Posiciono na ordem 2
	if SPC->(dbSeek( cChaveSPC ) ) //Busco pela chave passada pelo parametro
		while SPC->(!EoF()) .And. SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)) == cChaveSPC //Enquanto não muda o dia de apontamento do funcionario faça:
			if 	allTrim(SPC->PC_USUARIO) != allTrim((cAlias)->PB7_ALTERH) .Or. ;
			allTrim(SPC->PC_HORAALT) != allTrim((cAlias)->PB7_HALTRH) .Or. ;
			SPC->PC_DATAALT != stod((cAlias)->PB7_DALTRH)

				if lAltRH //Verifico se esta rodando dentro de um ponto de entrada
					SP9->(dbSetOrder(1)) //Posiciono na ordem 1
					if SP9->(dbSeek(xFilial('SP9')+SPC->PC_PD)) //Busco pelo evento na tabela SP9 - Eventos
						if SP9->P9_CLASEV == "01" //Verifico se o evento é hora positiva
							if !empty( SPC->PC_PDI ) //Verifico se o usuario RH apontou um evento, aprovando ou reprovando
								lRetorno := .T. //Indico que deve criar uma nova versão na PB7
								cStatus  := "5" //Atribuo bolinha rosa
								cStaHe   := "4" //Atribuo bolinha vermelha - reprovado, caso não identifique que o evento é de HE autorizada, ficara reprovado
								cCodAlt  := allTrim(SPC->PC_USUARIO) //Campo para gravar na PB7 o usuário RH que alterou o evento.
								dAltRH   := SPC->PC_DATAALT //Data da alteração
								cHrAltRH := allTrim(SPC->PC_HORAALT) //Hora da alteração
								if SP9->(dbSeek(xFilial('SP9')+SPC->PC_PDI)) //Busco pelo evento na tabela SP9 - Eventos
									if !empty(SP9->P9_CODFOL) .or. SP9->P9_BHORAS == "S" //Verifico se a hora positiva foi autoriazada.
										cStaHe := "3" //Atribuo bolinha azul - aprovado.
									endif
								endif
								conout("	alteradoRH - encontrou alteracao evento he pelo RH: "+cChaveSPC)
							endif
						elseif SP9->P9_CLASEV $ "02/03/04/05" //Verifico se é uma hora negativa
							lRetorno := .T. //Indico que deve criar uma nova versão na PB7
							cStatus  := "5" //Atribuo bolinha rosa
							cStaAtr  := "4" //Atribuo bolinha vermelha - reprovado, caso não identifique que o evento não foi abonado, ficara reprovado
							cCodAlt  := allTrim(SPC->PC_USUARIO) //Campo para gravar na PB7 o usuário RH que alterou o evento.
							dAltRH   := SPC->PC_DATAALT //Data da alteração
							cHrAltRH := allTrim(SPC->PC_HORAALT) //Hora da alteração
							if !empty(SPC->PC_ABONO) .and. SPC->PC_QTABONO > 0 //Verifico se o evento esta abonado.
								cStaAtr := "3" //Atribuo bolinha azul - aprovado.
							endif
							conout("	alteradoRH - encontrou alteracao evento atr pelo RH: "+cChaveSPC)
						endif
					endif
				endif
				/*
				if !lRetorno //Caso não haja alteração do RH, volto para verificação padrão
				if (cAlias)->PB7_STATUS == '2' //Verifico se o evento já não considerado como afastamento ou já foi enviado para aprovação
				lRetorno := .T. //Indico que deve criar uma nova versão na PB7
				cStatus  := '5' //Atribuo bolinha rosa
				cCodAlt  := SPC->PC_USUARIO //Campo para gravar na PB7 o usuário RH que alterou o evento.
				dAltRH   := SPC->PC_DATAALT //Data da alteração
				cHrAltRH := SPC->PC_HORAALT //Hora da alteração
				endif
				exit
				endif
				*/
			endif
			SPC->(dbSkip())
		end
	endif
	cCodAlt := allTrim(cCodAlt)
return lRetorno

/*
{Protheus.doc} existeRF0
Verifica se para a marcacao possui preabono
@Param cStatus - Status passado pelo Web Service
@Param cChaveRF0 - Chave para leitura da tabela de pre abono
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. - Registro com status alterado pelo RH, .F. - Registro com status que não alterado pelo RH
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
static function existeRF0( cFilMat, cmatricula, cPerAponta, cAtual )
	local lRetorno   := .F.
	local calias     := getNextAlias()
	local nRec       := 0
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	
	default cFilMat 	:= "" // Filial do funcionario
	default cmatricula 	:= "" // Matricula do funcionario
	default cPerAponta 	:= "" //- Periodo do apontamento
	default cAtual := ""

	/*
	RF0->(dbSetOrder(1))
	if RF0->(dbSeek( cChavaRF0 ) )
		lRetorno := .T.
		cStatus := '5'
		
	endif
	*/

	if !empty(cPerAponta)
		cQuery := " SELECT "
		cQuery += " 	RF0_DTPREI, RF0_DTPREF "
		cQuery += " FROM "
		cQuery += " 	" + RetSqlName( 'RF0' ) + " RF0 "		
		cQuery += " WHERE D_E_L_E_T_     = ' ' " 
		cQuery += " 	AND RF0_FILIAL   = '"+cFilMat+"' "
		cQuery += " 	AND RF0_MAT      = '"+cmatricula+"' "
		cQuery += " 	AND '"+cAtual+"' BETWEEN RF0_DTPREI AND RF0_DTPREF "
		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			lRetorno := .T.
			conout("	existeRF0: "+cmatricula+" Pre-abono: "+(calias)->RF0_DTPREI +" - "+(calias)->RF0_DTPREF)
			(calias)->(dbCloseArea())
		endif
	endif
return lRetorno

/*
{Protheus.doc} TrataDupli
Verifica se a marcacao do portal esta com status = 5-Bloqueado pelo RH
@Param aLinha - Array com marcacoes
@Param aAnt - Array com marcacoes para comparacao (no caso seria a marcacao do dia anterior)
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. - Registro Correto, .F. - Registro duplicado
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function TrataDupli(aLinha, aAnt, cFilFunc, cMatFunc, cIdLog)
	local lRetorno := .T.

	default aLinha := {}
	default aAnt   := {}

	if len(aAnt) > 0
		if aAnt[1] == aLinha[1]
			lRetorno  := .F.
			conout("[PP] 0003 - PB7 Duplicada, adicionada nova versao para retirar duplicidade")
		endif
	endif
Return(lRetorno)

/*
{Protheus.doc} CSRH016
Rotina que devera ser executa no ponto de entrada de fechamento do portal do ponto eletronico
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH016(oSelf)
	local aArea      := GetArea()
	local aStruPB7   := PB7->(dbStruct())
	local aStruPBB   := PBB->(dbStruct())
	local cAlsPB7    := GetNextAlias()
	local cAlsPBB    := GetNextAlias()
	local cPeriodo   := replace(GetMv("MV_CSRH016"), "/", "")
	local cPonMes    := replace(GetMv("MV_PONMES"), "/", "")
	local cQuery     := ""
	local cTFimPer   := Substr(cPeriodo,9,8)
	local cTIniPer   := Substr(cPeriodo,1,8)
	local nRecPrc    := 0
	local nX         := 0

	//Resgatando dados da PB7, referente ao ultimo periodo processado, conforme o parametro MV_CSRH016.
	cQuery := "SELECT * FROM "+RetSQLName("PB7")+" PB7 "
	cQuery += "WHERE D_E_L_E_T_ <> '*' "
	cQuery += "  AND PB7_PAPONT = '"+cPeriodo+"' "
	cQuery += "ORDER BY PB7_FILIAL, PB7_MAT, PB7_DATA, PB7_VERSAO "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsPB7)

	For nX := 1 To Len(aStruPB7)
		if aStruPB7[nX][2] <> "C"
			TcSetField(cAlsPB7, aStruPB7[nX][1], aStruPB7[nX][2], aStruPB7[nX][3], aStruPB7[nX][4])
		endif
	Next nX

	dbSelectArea(cAlsPB7)
	dbGoTop()

	ProcRegua( (cAlsPB7)->( Reccount() ) )

	While !Eof()
		nRecPrc ++

		IncProc(OemToAnsi("Resguardando Marcações...> ")+": "+AllTrim(Str(nRecPrc))+" ...Aguarde.")
		//IncProc(OemToAnsi("Resguardando Marcações..."))

		PB8->(RecLock('PB8',.T.))
		For nX := 1 To Len(aStruPB7)
			PB8->(FieldPut(nX, (cAlsPB7)->(&(aStruPB7[nX][1])) ))
		Next nX
		PB8->(MsUnLock())

		dbSkip()
	EndDo
	(cAlsPB7)->(dbCloseArea())

	//Resguardando registros de aprovações.
	cQuery := "SELECT * FROM "+RetSqlName("PBB")+" "
	cQuery += "WHERE PBB_DTAPON BETWEEN '"+cTIniPer+"' AND '"+cTFimPer+"' "
	cQuery += "ORDER BY PBB_FILMAT, PBB_MAT, PBB_DTAPON "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsPBB)

	For nX := 1 To Len(aStruPBB)
		if aStruPBB[nX][2] <> "C"
			TcSetField(cAlsPBB, aStruPBB[nX][1], aStruPBB[nX][2], aStruPBB[nX][3], aStruPBB[nX][4])
		endif
	Next nX

	dbSelectArea(cAlsPBB)
	dbGoTop()

	ProcRegua( (cAlsPBB)->( Reccount() ) )
	nRecPrc := 0

	While !Eof()

		nRecPrc ++

		IncProc(OemToAnsi("Resguardando Aprovações...> ")+": "+AllTrim(Str(nRecPrc))+" ...Aguarde.")
		//IncProc(OemToAnsi("Resguardando Aprovações..."))

		PBE->(RecLock('PBE',.T.))
		For nX := 1 To Len(aStruPBB)
			PBE->(FieldPut(nX, (cAlsPBB)->(&(aStruPBB[nX][1])) ))
		Next nX
		PBE->(MsUnLock())


		dbSkip()
	EndDo

	//Excluindo registros que foram resguardados.
	BEGIN Transaction

		cQuery := "DELETE FROM "+RetSqlName("PAL")+" "
		TcSqlExec(cQuery)

		cQuery := "DELETE FROM "+RetSqlName("PB7")+" WHERE PB7_PAPONT = '"+cPeriodo+"' "
		TcSqlExec(cQuery)

		cQuery := "DELETE FROM "+RetSqlName("PBB")+" WHERE PBB_DTAPON BETWEEN '"+cTIniPer+"' AND '"+cTFimPer+"' "
		TcSqlExec(cQuery)

	END Transaction

	//Atualizando o parametro exclusivo para periodo de fechamento do portal.
	PutMV('MV_CSRH016',cPonMes)

	RestArea(aArea)
Return()

/*
{Protheus.doc} CSRH017
Chama rotina a CSRH017 para atualizar a tabela de apontamento SPC, com dados da tabela do portal PB7
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cParam - Quais status deverao ser aprovados - default - 3
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH017(cFil, cMat, dDia, cParam, cIdLog, cPerAponta)
	local calias     := getnextalias()
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local nRec       := 0

	default cFil 		:= ""
	default cMat 		:= ""
	default dDia 		:= ctod('  /  /  ')
	default cParam 		:= ""
	default cIdLog 		:= ""
	default cPerAponta 	:= ""

	if  !empty(cFil) .and. !empty(cMat)
		U_CSRH018(cFil, cMat, dDia, cParam, cIdLog, cPerAponta)
	else
		cQuery := " SELECT PB7_FILIAL, PB7_MAT "
		cQuery += " FROM "
		cQuery += "  "+RetSqlName("PB7")+"  PB7"
		cQuery += " WHERE "
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY "
		cQuery += " PB7_FILIAL, PB7_MAT "

		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			(calias)->(dbGoTop())
			while (calias)->(!Eof())
				SRA->(dbSetOrder(1))
				if SRA->(dbSeek((calias)->(PB7_FILIAL+PB7_MAT)))
					U_CSRH018((calias)->PB7_FILIAL, (calias)->PB7_MAT, dDia, cParam, cIdLog, cPerAponta)
				endif
				(calias)->(dbSkip())
			end
			(calias)->(dbCloseArea())
		endif
	endif
Return()

/*
{Protheus.doc} CSRH018
Atualizar a tabela de apontamento SPC, com dados da tabela do portal PB7
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cParam - Quais status deverao ser aprovados - default - 3
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH018(cFil, cMat, dDia, cParam, cIdLog, cPerAponta, lCalculo)
	local calias     := getnextalias()
	local cClaSev	 := ""
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local nRec       := 0

	Private nMltThd  := 0 //SuperGetmv( "MV_PONMULT", NIL , 1 , cFilAnt ) //Indica se esta trabalhando com o ponto em multithread.

	default cFil 	   := ""
	default cMat 	   := ""
	default dDia       := ctod('  /  /  ')
	default cParam     := '3'
	default cIdLog     := ""
	default cPerAponta := ""
	default lCalculo   := .F.

	if  !empty(cFil) .and. !empty(cMat)
		SRA->(dbSetOrder(1))
		SRA->(dbSeek(cFil+cMat))
	endif

	cPerAponta :=  MontaPApon(cPerAponta, cIdLog)

	PB7->(dbSetOrder(1))
	cQuery := QryPB7Ver(SRA->RA_FILIAL, SRA->RA_MAT, {{dDia}}, cPerAponta)

	//Executa consultar
	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		(calias)->(dbGoTop())
		While (calias)->(!Eof())
			if PB7->(dbSeek((calias)->(PB7_FILIAL+PB7_MAT+PB7_DATA+cValToChar(PB7_VERSAO))))
				if lCalculo
					RecLock('PB7',.F.)
					PB7->PB7_STATUS := '8'
					//PB7->PB7_LOG     := "Status 8 CSRH018 Participante: "+cIdLog
					PB7->(MsUnLock())

					SPC->(dbSetOrder(2))
					if SPC->(dbSeek(SRA->(RA_FILIAL+RA_MAT)+DTOS(PB7->PB7_DATA  )))
						While SPC->(!EoF()) .And. SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)) == SRA->(RA_FILIAL+RA_MAT)+DTOS(PB7->PB7_DATA)

							if !SPCBlock()
								cClaSev := posicione( 'SP9', 1, xFilial('SP9')+SPC->PC_PD, 'P9_CLASEV' )
								if cClaSev $ '02/03/04/05' //-> Classificaão para Eventos de Descontos.
									//Verifica se possui atraso reprovado
									if PB7->PB7_STAATR != '3' //Não foi autorizado não faz
										SP6->(dbSetOrder(1))
										if SP6->(dbSeek(xFilial('SP6')+SPC->PC_ABONO))
											if SP6->P6_PORTAL == '2'

												//Não mexer na ordem - por causa do código do abono
												cChaveSPK := SRA->(RA_FILIAL+RA_MAT)+DTOS(PB7->PB7_DATA)+SPC->PC_ABONO

												RecLock('SPC', .F.)
												SPC->PC_ABONO 	:= ''
												SPC->PC_QTABONO := 0
												//SPC->PC_CC 		:= SRA->RA_CC
												//SPC->PC_LOG     := "Atualiza CSRH018 Participante: "+cIdLog
												SPC->(MsUnLock())

												SPK->(dbSetOrder(1))
												if SPK->(dbSeek(cChaveSPK))
													while cChaveSPK == SPK->(PK_FILIAL+PK_MAT+DTOS(PK_DATA)+PK_CODABO)
														RecLock("SPK", .F.)
														//SPK->PK_LOG := 'Del CSRH018 Participante: '+cIdLog
														SPK->(dbDelete())
														SPK->(dbSkip())
													EndDo
												endif
											endif
										endif
									endif
								Elseif cClaSev == '01'	//-> Classificaão para Eventos de Proventos.
									if PB7->PB7_STAHE != '3'
										if posicione( 'SP9', 1, xFilial('SP9')+SPC->PC_PD, 'P9_CLASEV' ) == '01'
											RecLock('SPC', .F.)
											SPC->PC_PDI 	:= ''
											SPC->PC_QUANTI 	:= 0
											//SPC->PC_CC 		:= SRA->RA_CC
											//SPC->PC_LOG     := "Atualiza CSRH018 Participante: "+cIdLog
											SPC->(MsUnLock())
										endif
									endif
								endif
							endif
							SPC->(dbSkip())
						EndDo
					endif
				endif
			endif
			(calias)->(dbSkip())
		EndDo
		(calias)->(dbCloseArea())
	endif
Return()

/*
{Protheus.doc} CSRH019
Funcao que reaponta as marcações
@Param cPerAponta - Periodo do apontamento
@Param lWork - Se o "Start" foi via WorkFlow
@Param lUserDef - Se deve considerar as configuracoes dos parametros do usuario
@Param lLimita - Se deve limitar a Data Final de Apontamento a Data Base
@Param cProcFil - Filial a Ser Processada
@Param lProcFil - Processo por Filial
@Param lApoNLidas - Apontar quando nao Leu as Marcacoes para a Filial
@Param lForceR - Se deve Forcar o Reapontamento
@Param cIdLog - Complemento do nome do arquivo de log
@Return boolean - .T. a Rotina processou os apontamentos, .F. a Rotina não processou o registro
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH019(	cPerAponta , lWork, lUserDef, lLimita, cProcFil, lProcFil, lApoNLidas, lForceR, cIdLog )
	local aArea		:= GetArea()
	local aChkAlias	:= {}
	local cArqTrab	:= ""
	local cChar		:= "Z"
	local cSvFilAnt	:= cFilAnt
	local lRetorno 	:= .F.

	default cPerAponta	:= ""
	default lWork		:= .F.
	default lUserDef	:= .F.
	default lLimita		:= .T.
	default cProcFil	:= .F.
	default lProcFil	:= .F.
	default lApoNLidas	:= .F.
	default lForceR		:= .F.
	default lSR6McImpJc	:= !Empty( SR6->( FieldPos("R6_MCIMPJC") ) )
	default cIdLog 		:= ""

	Static cCadastro   	:= OemToAnsi('Leitura/Apontamento Marcacoes' ) // 'Leitura/Apontamento Marcacoes'
	Static lAbortPrint 	:= .F.
	Static lFiltRel		:= .F. //Filtra Relogios
	Static lMultThread	:= .F. //Somente é verdadeiro se ambiente for TOP e parametro MV_PONMULT for maior que zero
	Static nMultThread	:= 0

	//Variaves do Processo WorkFlow
	Private lWorkFlow		:= lWork
	Private lUserDefParam	:= lUserDef
	Private lLimitaDataFim	:= lLimita
	Private cFilProc		:= cProcFil
	Private lProcFilial		:= lProcFil
	Private lApontaNaoLidas := lApoNLidas
	Private lForceReaponta	:= lForceR
	Private dPerDe 			:= Ctod("//")
	Private dPerAte 		:= Ctod("//")
	Private dPerIni			:= Ctod("//")
	Private dPerFim			:= Ctod("//")
	Private dData   		:= Ctod("//")
	Private aLogFile		:= {}
	Private nDiasExtA 		:= 0
	Private nDiasExtP 		:= 0
	Private lChkPonMesAnt	:= .F.
	Private nGravadas	 	:= 0
	Private cFunMat			:= ""
	Private nAponta 		:= 1

	lFiltRel := ( SuperGetMv("MV_FILTREL",NIL,"N") == "S" )
	//Carrega a Filial a Ser Processada Quando WorkFlow
	cFilAnt := IF( ( ValType( cFilProc ) == "C" ) .and. Len(Alltrim(cFilProc)) > 0 , cFilProc , cFilAnt )

	aAdd( aChkAlias , "SI3" )
	aAdd( aChkAlias , "SP0" )
	aAdd( aChkAlias , "SP1" )
	aAdd( aChkAlias , "SP2" )
	aAdd( aChkAlias , "SP3" )
	aAdd( aChkAlias , "SP4" )
	aAdd( aChkAlias , "SP5" )
	aAdd( aChkAlias , "SP6" )
	aAdd( aChkAlias , "SP8" )
	aAdd( aChkAlias , "SP9" )
	aAdd( aChkAlias , "SPA" )
	aAdd( aChkAlias , "SPC" )
	aAdd( aChkAlias , "SPD" )
	aAdd( aChkAlias , "SPE" )
	aAdd( aChkAlias , "SPF" )
	aAdd( aChkAlias , "SPJ" )
	aAdd( aChkAlias , "SPK" )
	aAdd( aChkAlias , "SPM" )
	aAdd( aChkAlias , "SPW" )
	aAdd( aChkAlias , "SPY" )
	aAdd( aChkAlias , "SPZ" )
	aAdd( aChkAlias , "SR6" )
	aAdd( aChkAlias , "SR8" )
	aAdd( aChkAlias , "SRA" )
	aAdd( aChkAlias , "SRW" )
	aAdd( aChkAlias , "SX5" )

	GetParam(cChar) //Recupera Valores dos Parametros para Filtragem de Arquivos de Relogios.
	PonDestroyStatic() //Inicializa as Static do SIGAPON
	lRetorno := Ponm010Pro(cChar, cPerAponta, cIdLog) //Executa o Processo de Leitura/Apontamento

	//Elimina Arquivo Temporario e Indice
	if !Empty(Select('TRB'))
		dbSelectArea('TRB')
		dbCloseArea()
		Ferase(cArqTrab+GetDBExtension())
		Ferase(cArqTrab+OrdBagExt())
	endif

	cFilAnt := cSvFilAnt

	RestArea( aArea )
Return( lRetorno )

/*
{Protheus.doc} Ponm010Pro
Funcao que Realizar a Leitura e Classifica‡„o das Marca‡oes.
@Param cChar - Caractere de parametro para ultimo registro do parametro "Z"
@Param cPerAponta - Periodo do apontamento
@Param cIdLog - Complemento do nome do arquivo de log
@Return boolean - .T. a Rotina processou os apontamentos, .F. a Rotina não processou o registro
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function Ponm010Pro(cChar, cPerAponta, cIdLog)
	local aAreaSP0			:= SP0->( GetArea() )
	local aAreaSP2			:= SP2->( GetArea() )
	local aAreaSP8			:= SP8->( GetArea() )
	local aAreaSPE			:= SPE->( GetArea() )
	local aAreaSRA			:= SRA->( GetArea() )
	local lRetorno			:= .F.
	local lGetMrBySra		:= .F.
	local nGetMrBySra		:= 0

	default cChar        := ""
	default cPerAponta 		:= ""
	default cIdLog 			:= ""

	Static aSp8Fields
	Static nSp8Fields
	Static aRfeFields
	Static nRfeFields
	Static aMarcFields
	Static nMarcFields

	Private aTabCalend 		:= {}
	Private aCalendFunc		:= {}
	Private aTabPadrao		:= {}
	Private aLogFile   		:= {}
	Private aCodigos   		:= {}
	Private aRecsBarG		:= {}
	Private aSemCracha 		:= {}
	Private aVisitante 		:= {}
	Private aTabRef			:= {}
	Private aMarcNoGer		:= {}
	Private bSraScope  		:= { || .F. }
	Private bAcessaSRA 		:= &("{ || " + ChkRH(FunName(),"SRA","2") + "}")
	Private bCondDelAut		:= { || .T. }
	Private cTxtAlias  		:= ""
	Private cCracha    		:= ""
	Private cMatricula 		:= ""
	Private cFuncao    		:= ""
	Private cGiro      		:= ""
	Private cCusto	   		:= ""
	Private cRelogio   		:= ""
	Private cCCDe	   		:= ""
	Private cCCAte     		:= ""
	Private cTurnoDe   		:= ""
	Private cTurnoAte  		:= ""
	Private cMatDe     		:= ""
	Private cMatAte    		:= ""
	Private cNomeDe    		:= ""
	Private cNomeAte   		:= ""
	Private cFilOld    		:= "__cFilOld__"
	Private __cSvFilAnt		:= cFilAnt
	Private cFilDe	   		:= ""
	Private cFilAte    		:= Space(3)
	Private cRelDe     		:= ""
	Private cRelAte    		:= Space(3)
	Private cTimeIni		:= Time()
	Private cFilTnoDe	 	:= ""
	Private cFilTnoAte 		:= ""
	Private cCategoria		:= ""
	Private cFilTnoSRA 		:= ""
	Private cFilSRA	 		:= ""
	Private cAliasSP8	 	:= "SP8"
	Private cQrySp8Alias	:= cAliasSP8
	Private cSpaceRegra		:= Space( GetSx3Cache( "RA_REGRA  "	, "X3_TAMANHO" ) )
	Private cP8TpMarca		:= Space( GetSx3Cache( "P8_TPMARCA" , "X3_TAMANHO" ) )
	Private cP8Turno		:= Space( GetSx3Cache( "P8_TURNO  " , "X3_TAMANHO" ) )
	Private cP8Ordem		:= Space( GetSx3Cache( "P8_ORDEM  " , "X3_TAMANHO" ) )
	Private cSpCracha	 	:= ""
	Private cSpPIS	 		:= ""
	Private cSpyCracha	 	:= ""
	Private cSpyVisita	 	:= ""
	Private cSpyNumero	 	:= ""
	Private cSpMatPrv	 	:= ""
	Private cFilSP0    		:= ""
	Private cFilSP9    		:= ""
	Private cFilSPZ			:= ""
	Private cLastFil		:= "__cLastFil__"
	Private cFilTnoOld		:= "__cFilTnoOld__"
	Private cFilTnoSeqOld	:= "__cFilTnoSeqOld__"
	Private cFilSPE	 		:= ""
	Private cFilRefAnt		:= ""
	Private cDurLeitura		:= "00:00:00"
	Private cDurApoClas		:= "00:00:00"
	Private cIniVisita		:= ""
	Private cFimVisita		:= ""
	Private cDeAte     		:= ""
	Private cMsgBarG1		:= ""
	Private cLogFile		:= ""
	Private cMsgLog			:= ""
	Private cAliasCc		:= IF( SuperGetMv("MV_MCONTAB") == "CTB" , "CTT" , "SI3" )
	Private cCampoCc		:= ( PrefixoCpo( cAliasCc ) + "_CUSTO" )
	Private cFilRelLid		:= ""
	Private cFilRelUti		:= ""
	Private cAliasRfe	 	:= "RFE"
	Private cQryRfeAlias	:= cAliasRFE
	Private cSituacoes 		:= ""
	Private dPerDeVis		:= Ctod("//")
	Private dPerAteVis		:= Ctod("//")
	Private nSerIniVis
	Private nSerFimVis
	Private dPerIni			:= Ctod("//")
	Private dPerFim			:= Ctod("//")
	Private dData      		:= Ctod("//")
	Private lSP1Relogio		:= !Empty( SP1->( FieldPos( "P1_RELOGIO" ) ) )
	Private lChkPonMesAnt	:= .F.
	Private lSR6Comp		:= Empty( xFilial( "SR6" ) )
	Private lIncProcG1		:= .T.
	Private lSraQryOpened	:= .F.
	Private lTSREP			:= SuperGetMv( "MV_TSREP" , NIL , .F. )
	Private nOrdemCc		:= RetOrdem( cAliasCc , ( PrefixoCpo( cAliasCc ) + "_FILIAL" ) + "+" + cCampoCc )
	Private nHora      		:= 0
	Private nCountTime		:= 0
	Private nCount1Time		:= 0
	Private nIncPercG1		:= 0
	Private nIncPercG2		:= 0
	Private nLidas	 		:= 0
	Private nSraLstRec	 	:= 0
	Private nGravadas	 	:= 0
	Private nLenPIS 		:= 0
	Private nLenCracha 		:= TamSX3("RA_CRACHA")[1]
	Private nLenSPYCracha 	:= TamSX3("PY_CRACHA")[1]
	Private nLenSPYNumero 	:= TamSX3("PY_NUMERO")[1]
	Private nLenSPYVisita 	:= TamSX3("PY_VISITA")[1]
	Private nLenMatPrv 		:= Len( SPE->PE_MATPROV )
	Private nReaponta	 	:= 0
	Private nFuncProc		:= 0
	Private nTipo      	  	:= 0
	Private nRecsBarG	    := 0
	Private nDiasExtA	    := 0
	Private nDiasExtP	    := 0
	Private nRecnoSRA	    := 0
	Private cPerg		    := ""
	Private lSp8QryOpened   := .F.

	nLenPIS	:= TamSX3("RFE_PIS")[1]
	//variavel utilizar nas funcoes do ponto padrao, 
	//so fiz isso para parar o warning na compilacao
	nMarcFields := nil 

	//Conteudo padrao para array de Arquivos de Marcacoes Filtrados//
	//conforme parametro MV_FiltRel. Nao eh valido para WorkFlow   //
	//default aArqSel				:= {}
	default aSp8Fields		:= ( cAliasSP8 )->( dbStruct() )
	default nSp8Fields 		:= Len( aSp8Fields )

	//Carrega os MV_'s do SX6 para Variaveis do Sistema
	cIniVisita	:= SuperGetMv("MV_VISIINI")
	cFimVisita	:= SuperGetMv("MV_VISIFIM")
	cIniVisita	:= IF( cIniVisita==NIL, Replicate("Z",nLenCracha), Substr(Alltrim(cIniVisita),1,nLenCracha)  )
	cFimVisita	:= IF( cFimVisita==NIL, Replicate("Z",nLenCracha), Substr(Alltrim(cFimVisita),1,nLenCracha) )
	cSpCracha	:= Space( nLenCracha )
	cSpPIS 		:= Space( nLenPIS )
	cSpyCracha	:= Space( nLenSPYCracha )
	cSpyNumero	:= Space( nLenSPYNumero )
	cSpyVisita	:= Space( nLenSPYVisita )
	cSpMatPrv	:= Space( nLenMatPrv )

	nDiasExtA 	:= Min(Abs( SuperGetMv( "MV_GETDIAA" , NIL , 2  , cFilAnt ) ), 7)	//-- Quantidade de Dias a ser considerada antes do inicio do Periodo de  Apontamento a ser considerada na Leitura/Apontamento
	nDiasExtP 	:= Min(Abs( SuperGetMv( "MV_GETDIAP" , NIL , 2  , cFilAnt ) ), 7)	//-- Quantidade de Dias a ser considerada apos  o fim do Periodo de  Apontamento a ser considerada na Leitura/Apontamento
	cFilRelUti	:= If( !Empty( SuperGetMv("MV_PM010LA",,"N") ), SuperGetMv("MV_PM010LA"), "N" )

	//Setando as Perguntas que serao utilizadas no Programa
	Pergunte( "PNM010" , .F. )

	//Carregando as Perguntas
	cFilDe     := mv_par01 //Filial De
	cFilAte    := mv_par02 //Filial Ate
	cCCDe      := mv_par03 //Centro de Custo De
	cCCAte     := mv_par04 //Centro de Custo Ate
	cTurnoDe   := mv_par05 //Turno De
	cTurnoAte  := mv_par06 //Turno Ate
	cMatDe     := mv_par07 //Matricula De
	cMatAte    := mv_par08 //Matricula Ate
	cNomeDe    := mv_par09 //Nome De
	cNomeAte   := mv_par10 //Nome Ate
	cRelDe     := mv_par11 //Relogio De
	cRelAte    := mv_par12 //Relogio Ate
	dPerDe 	   := mv_par13 //Periodo De
	dPerAte	   := mv_par14 //Periodo Ate
	cRegDe 	   := mv_par15 //Regra De
	cRegAte	   := mv_par16 //Regra Ate
	nTipo      := mv_par17 //Tipo de Processamento 1=Leitura 2=Apontamento 3=Ambos
	nAponta	   := mv_par18 //Leitura/Apontamento 1=Marcacoes 2=Refeicoes 3=Acesso 4=Marcacoes e Refeicoes 5=Todos
	nReaponta  := mv_par19 //Reapontar 1= Marcacoes 2=Refeicoes 3=Ambos 4=Nenhum
	nGetMrBySra:= mv_par20 //Reapontar 1= Marcacoes 2=Refeicoes 3=Ambos 4=Nenhum
	cCategoria := mv_par21 //Categorias
	cSituacoes := mv_par22 //Situações

	if empty(cPerAponta)
		cPerAponta :=  MontaPApon('')
	endif

	dPerIni := dPerDe
	dPerFim := dPerAte

	//Verifica o Tipo de Controle
	lGetMrBySra := If( nGetMrBySra == 1, .T., .F. )

	//Inicializa Filial/Turno De/Ate
	cFilTnoDe	:= ( cFilDe + cTurnoDe )
	cFilTnoAte	:= ( cFilAte + cTurnoAte )

	//Cria o Bloco dos Funcionarios que atendam ao Scopo
	bSraScope := { || (;
	( RA_TNOTRAB	>= cTurnoDe	) .and. ( RA_TNOTRAB	<= cTurnoAte	) .and. ;
	( RA_FILIAL		>= cFilde	) .and. ( RA_FILIAL		<= cFilAte		) .and. ;
	( RA_NOME		>= cNomeDe	) .and. ( RA_NOME		<= cNomeAte		) .and. ;
	( RA_MAT		>= cMatDe	) .and. ( RA_MAT		<= cMatAte		) .and. ;
	( RA_CC			>= cCCDe	) .and. ( RA_CC			<= cCCAte		) .and. ;
	( RA_REGRA		>= cRegDe	) .and. ( RA_REGRA		<= cRegAte		) .and. ;
	( RA_REGRA <> cSpaceRegra	) .and. ( RA_CATFUNC $ cCategoria ) .and. ;
	( RA_SITFOLH $ cSituacoes );
	);
	}

	//Inicializa as Ordens para a Classifica‡„o/Apontamento
	SP8->( dbSetOrder( RetOrdem( "SP8" , "P8_FILIAL+P8_MAT+DTOS(P8_DATA)+STR(P8_HORA,5,2)" ) ) )	//-- Marca‡”es
	SPF->( dbSetOrder( RetOrdem( "SPF" , "PF_FILIAL+PF_MAT+DtoS(PF_DATA)" ) ) )						//-- Altera‡”es de Turno

	/*+-----------------------------------------------------------------------------------------------------------+
	| Caso a chama à função tenha sido invocada pela rotina de Leitura e Apontamento das marcações, não realiza |
	| reposicionamento da tabela de funcionarios SRA.                                                           |
	| Devido ao processamento em MultiThreads, a rotina faz "copias" do SRA uma para cada Thread e já mantem    |
	| a tabela posicionada.                                                                                     |
	| Na tentativa de reposicionar a tabela SRA, ocorrerá erro "Index not found".                               |
	+-----------------------------------------------------------------------------------------------------------+
	*/
	if !Isincallstack("PONM010")
		SRA->(dbSetOrder(1))
		SRA->(dbSeek(cFilAte+cMatAte))
	endif

	//Reinicializa cFilOld
	cFilOld := "__cFilOld__"

	//Processa o Apontamento de Marcacoes/Refeicoes
	if !Ponm010Apo( cPerAponta, cIdLog )
		conout("[PP] 0004 - Erro na função: Ponm010Apo")
	endif

	//##Conferir possivel erro de apagar SPC, linha comenteada 01/07/2016
	//Exclui fisicamente os registros deletados na SPC
	//Chk_Pack( "SPC" , -1 , 1 ) //"Preparando arquivo de apontamentos"###"Aguarde..."

	//Fecha as Querys e Restaura os Padros
	if ( lSp8QryOpened )
		if ( ( Select( cQrySp8Alias ) > 0 ) .and. !( cQrySp8Alias == cAliasSP8 ) )
			( cQrySp8Alias )->( dbCloseArea() )
			dbSelectArea( "SP8" )
		endif
	endif
	if ( lSraQryOpened )
		SRA->( dbCloseArea() )
		ChkFile( "SRA" )
	endif
	lSraQryOpened := .F.

	//Restaura os Dados de Entrada
	RestArea( aAreaSP0 )
	RestArea( aAreaSP2 )
	RestArea( aAreaSP8 )
	RestArea( aAreaSPE )
	RestArea( aAreaSRA )
Return( lRetorno )

/*
{Protheus.doc} Ponm010Apo
Classificacao e Apontamento das Marcacoes
@Param cPerAponta - Periodo de apontamento
@Param cIdLog - Complemento do nome do arquivo de log
@Return boolean - .T. Periodo liberado, .F. Periodo rejeitado
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function Ponm010Apo( cPerAponta, cIdLog )
	local aAreaSP8		:= SP8->( GetArea("SP8") )
	local aAbonosPer	:= {}
	local cSvFilAnt		:= cFilAnt
	local lApHeDtm	 	:= .F.
	local lGetMarcAuto	:= .T.
	local aMarcacoes
	local aMarcTot
	local aMarcDel
	local aMarcClone
	local aRecsMarcAutDele
	local aResult
	local cDsrAutPa
	local cPd
	local cPdEmpr
	local cFil
	local cTno
	local cMat
	local cSeq
	local cCc
	local cNome
	local dPerIGeA
	local dPerFGeA
	local lAjustMarc
	local nX
	local nMinSize
	local nSizeaMcClo
	local nSizeaMarca
	local nMarc
	local uPerIniDel
	local uPerFimDel
	local lRetorno		:= .F.
	local aCaleAux 		:= {}
	local nPos 			:= 0
	local dConta		:= ctod('  /  /  ')
	local lMenor 		:= .F.
	local lMaior 		:= .F.

	default cPerAponta  := ""
	default cIdLog 		:= ""

	//Redefine variaveis.
	cFil 	:= SRA->RA_FILIAL
	cTno 	:= SRA->RA_TNOTRAB
	cMat 	:= SRA->RA_MAT
	cSeq	:= SRA->RA_SEQTURN
	cCC		:= SRA->RA_CC
	cNome	:= SRA->RA_NOME

	lAjustMarc	:= ( lSR6McImpJc .and. ( PosSR6( cTno , cFil , "R6_MCIMPJC" , 01 ) == "2" ) )

	//Reinicializa a Tabela de Horario Padrao
	if xRetModo("SRA","SPJ",.F.)
		aTabPadrao := {}
	endif

	//Verifica se Devera Carregar as Marcacoes Automaticas em GetMarcacoes
	lGetMarcAuto := ( SuperGetMv( "MV_GETMAUT" , NIL , "S" , cFil ) == "S" )

	//Verifica se o funcionario foi demitido antes do Per¡odo
	if SRA->( RA_SITFOLH == "D"  .and. !Empty( RA_DEMISSA ) .and.  RA_DEMISSA < dPerIni )
		//SEM TRATATIVA
	endif

	//Define o Periodo para a Geracao das Marcacoes Automaticas e
	//Para a Montagem do Calendario e Para o Apontamento das  Marcacoes
	dPerIGeA		:= dPerDe
	dPerFGeA		:= dPerAte
	if SRA->( RA_ADMISSA > dPerDe .and. RA_ADMISSA <= dPerAte )
		dPerIGeA	:= SRA->RA_ADMISSA
	endif
	if SRA->( RA_DEMISSA < dPerAte .and. !Empty( RA_DEMISSA ) )
		dPerFGeA	:= SRA->RA_DEMISSA
	endif
	dPerIGeA	:= Max( dPerIGeA , dPerDe  )
	dPerFGeA	:= Min( dPerFGeA , dPerAte )
	if ( dPerFGeA < dPerIGeA )
		//SEM TRATATIVA
	endif

	aTabPadrao := {}
	dPerIGeA	:= STOD(LEFT(cPerAponta , 8))
	dPerFGeA	:= STOD(RIGHT(cPerAponta, 8))

	//Cria Tabela de Horario Padrao do Funcionario
	if SRA->( !CriaCalend(	dPerIGeA		,;	//01 -> Data Inicial do Periodo
	dPerFGeA     ,;	//02 -> Data Final do Periodo
	cTno		,;	//03 -> Turno Para a Montagem do Calendario
	cSeq		,;	//04 -> Sequencia Inicial para a Montagem Calendario
	@aTabPadrao	,;	//05 -> Array Tabela de Horario Padrao
	@aTabCalend	,;	//06 -> Array com o Calendario de Marcacoes
	cFil		,;	//07 -> Filial para a Montagem da Tabela de Horario
	cMat		,;	//08 -> Matricula para a Montagem da Tabela de Horario
	cCc			,;	//09 -> Centro de Custo para a Montagem da Tabela
	NIL     	,;	//10 -> Array com as Trocas de Turno
	NIL			,;	//11 -> Array com Todas as Excecoes do Periodo
	NIL			,;	//12 -> Se executa Query para a Montagem da Tabela Padrao
	.T.			,;	//13 -> Se executa a funcao se sincronismo do calendario
	NIL			 ;	//14 -> Se Forca a Criacao de Novo Calendario
	);
	)
	endif

	//Monta Condicoes para verificacao das Marcacoes Automaticas que devera ser Desprezadas
	if !( lGetMarcAuto )
		//Periodo Incicial
		uPerIniDel	:= GetInfoPosTab( CALEND_POS_LIM_MARCACAO , "1E" , dPerIGeA , aTabCalend )
		uPerIniDel	:= DataHora2Str( uPerIniDel[1] , uPerIniDel[2] )

		//Periodo Final
		uPerFimDel	:= GetInfoPosTab( CALEND_POS_LIM_MARCACAO , "__LASTMARC__" , dPerFGeA , aTabCalend )
		uPerFimDel	:= DataHora2Str( uPerFimDel[1] , uPerFimDel[2] )

		//Condicao
		bCondDelAut	:= { |cDataHora| cDataHora := DataHora2Str( P8_DATA , P8_HORA ) , ( ( cDataHora >= uPerIniDel ) .and. ( cDataHora <= uPerFimDel ) ) }
	endif

	//Verifica a Troca de Filial
	if !( cFil == cFilOld )
		//Atualiza cFilOld
		cFilOld := cFil //A Atribuicao deve ser Feita Aqui pois eh a ultima comparacao

		//Carrega Codigos de Eventos.
		if ( ( nTipo == 2 ) .or. ( nTipo == 3 ) ) //2=Apontamento;3=Ambos
			lApHeDtm	:= ( SuperGetMv( "MV_APHEDTM" , NIL , "N" , cFil ) == "S" )
			cFilSP9		:= fFilFunc("SP9") //-- Obtem a Filial de Eventos
			//-- Nao carregar novamente o cadastro de eventos qdo o mesmo for compartilhado
			if ( !Empty( cFilSP9 ) .or. ( Len( aCodigos ) == 0 ) )
				aCodigos := {}
				if !( fCargaId( @aCodigos , cFilSP9 , .F. ) )
				endif
				cDsrAutPa	:= PosSP9( "036N" , cFilOld , "P9_CODIGO" , 2 ) //Evento DSR Mes Anterior
				cPd			:= PosSP9( "016A" , cFilOld , "P9_CODIGO" , 2 ) //Evento Desc. Ref.Parte Func.
				cPdEmpr		:= PosSP9( "015A" , cFilOld , "P9_CODIGO" , 2 ) //Evento Desc. Ref.Parte Empresa
			endif
		endif
	endif

	fAbonosPer(@aAbonosPer, dPerDe, dPerAte, SRA->RA_FILIAL, SRA->RA_MAT )

	//Cria array com as marca‡”es do Periodo para o funcionario.
	if !GetMarcacoes(	@aMarcacoes         ,;	//01 -> Marcacoes dos Funcionarios
	@aTabCalend         ,;  //02 -> Calendario de Marcacoes
	NIL         		,;  //03 -> Tabela Padrao
	NIL                 ,;  //04 -> Turnos de Trabalho
	dPerDe           	,;	//05 -> Periodo Inicial
	dPerAte         	,;  //06 -> Periodo Final
	cFil                ,;  //07 -> Filial
	cMat                ,;  //08 -> Matricula
	cTno                ,;  //09 -> Turno
	SRA->RA_SEQTURN     ,;  //10 -> Sequencia de Turno
	SRA->RA_CC          ,;  //11 -> Centro de Custo
	'SP8'               ,;  //12 -> Alias para Carga das Marcacoes
	.T.                 ,;  //13 -> Se carrega Recno em aMarcacoes
	.T.         	    ,;  //14 -> Se considera Apenas Ordenadas
	NIL                 ,;  //15 -> Verifica as Folgas Automaticas
	NIL                 ,;  //16 -> Se Grava Evento de Folga Mes Anterior
	lGetMarcAuto        ,;  //17 -> Se Carrega as Marcacoes Automaticas
	NIL					,;  //18 -> Registros de Marcacoes Automaticas que deverao ser Deletados
	bCondDelAut         ,;  //19 -> Bloco para avaliar as Marcacoes Automaticas que deverao ser Desprezadas
	.T.                 ,;  //20 -> Se Considera o Periodo de Apontamento das Marcacoes
	.F.                 ,;  //21 -> Se Efetua o Sincronismo dos Horarios na Criacao do Calendario
	.F.                 ,;  //22 -> Se Considera a data de apontamento
	.F.                 ;   //23 -> Se Deve verificar se a data de apontamento da marcacao eh maior ou igual a data inicial do periodo (somente se Considera a data de apontamento)
	)
	endif

	//Copia de aMarcacoes para Comparacao na Saida
	aMarcClone := aClone( aMarcacoes )
	//aMarcacoes := {}
	//aMarcDel   := {}

	//aScan( aMarcTot, { |x| iif (x[AMARC_TPMCREP] == "D",aAdd(aMarcDel,aClone(x)), iif(aAdd(aMarcacoes,aClone(x))) } )
	/*
	dConta := dPerDe
	while dConta <= dPerAte
	if empty(cOrdem)
	nPos := aScan( aMarcTot, { |x| x[1] == dConta } )
	if nPos > 0
	for nMarc := 1 To Len(aMarcTot)
	if 	aMarcTot[nMarc][3] == aMarcTot[nPos][3]
	if aMarcTot[nMarc][AMARC_TPMCREP] == "D"
	aAdd(aMarcacoes, aMarcDel[nMarc] )
	else
	cOrdem := aMarcTot[nMarc][3]
	aAdd(aMarcDel, aMarcTot[nMarc])
	endif
	endif
	next
	endif
	else
	cOrdem := soma1(cOrdem)
	nPos := aScan( aMarcTot, { |x| x[3] == cOrdem } )
	if nPos > 0
	for nMarc := 1 To Len(aMarcTot)
	if 	aMarcTot[nMarc][3] == aMarcTot[nPos][3]
	if aMarcTot[nMarc][AMARC_TPMCREP] == "D"
	aAdd(aMarcacoes, aMarcDel[nMarc] )
	else
	cOrdem := aMarcTot[nMarc][3]
	aAdd(aMarcDel, aMarcTot[nMarc])
	endif
	endif
	next
	endif
	endif
	dConta += 1
	end


	if !Empty(aMarcDel)
	For nMarc := 1 to Len(aMarcDel)
	aAdd( aMarcacoes , aClone(aMarcDel[nMarc]) )
	Next nMarc
	endif
	*/

	dConta := dPerDe
	while dConta <= dPerAte
		nPos := aScan( aTabCalend, { |x| x[1] == dConta } )
		if nPos > 0
			for nMarc := 1 To len(aTabCalend) //Len(aTabCalend)
				if aTabCalend[nPos][2] == aTabCalend[nMarc][2]
					aAdd(aCaleAux, aTabCalend[nMarc])
				endif
			next
		endif
		dConta += 1
	end

	/*
	if !Empty(aMarcDel)
	aMarcTot   := aMarcacoes
	aMarcacoes := {}
	aMarcDel   := {}
	aScan( aMarcTot, { |x| if (x[AMARC_TPMCREP] == "D",aAdd(aMarcDel,aClone(x)),aAdd(aMarcacoes,aClone(x))) } )
	endif
	*/

	//Gera marca‡oes Autom ticas.
	//aMarcAux:={}
	cMarcAut := REPLACE( SPA->PA_MARCAUT, '*','')
	//PutMarcAuto( aTabCalend , @aMarcacoes ,  dPerDe,  dPerAte, cFil, nil, nil, @aMarcAux )
	//PutMarcAuto( aTabCalend , @aMarcacoes ,  dPerDe,  dPerAte, cFil )

	if len(aMarcacoes) > 0
		for nMarc := 1 To len(aMarcacoes)
			nPos := aScan( aCaleAux, { |x| x[1] == aMarcacoes[nMarc][1] } )
			if nPos > 0
				dCalend  := aCaleAux[nPos][1] //Data do calendario padrao
				cOdCalen := aCaleAux[nPos][2] //Hora do calendario padrao
				nHrCalen := aCaleAux[nPos][3] //Hora do calendario padrao
				cTpMarc  := aCaleAux[nPos][4] //Tipo de marcacao do calendario padrao

				dMarc    := aMarcacoes[nMarc][1] //Data da marcacao
				nHrMarc  := aMarcacoes[nMarc][2] //Hora da marcacao
				cOdMarc  := aMarcacoes[nMarc][3] //Ordem da marcacao
				if cOdCalen != cOdMarc
					lMenor := .F.
					lMaior := .F.
				endif

				while dCalend == dMarc
					if nHrMarc < nHrCalen .and. cOdCalen == cOdMarc
						lMenor := .T.
					endif

					if nHrMarc > nHrCalen .and. cOdCalen == cOdMarc
						lMaior := .T.
					endif

					if !empty( cMarcAut )
						if lMenor .and. lMaior
							PutMarcAuto( aTabCalend , @aMarcacoes ,  aCaleAux[nPos][1] ,  aCaleAux[nPos][1] , cFil, nil, nil,  )
							exit
						endif
					endif
					nPos++
					if len(aCaleAux) <= nPos
						exit
					endif
					dCalend  := aCaleAux[nPos][1] //Data do calendario padrao
					cOdCalen := aCaleAux[nPos][2] //Hora do calendario padrao
					nHrCalen := aCaleAux[nPos][3] //Hora do calendario padrao
					cTpMarc  := aCaleAux[nPos][4] //Tipo de marcacao do calendario padrao
				end
			endif
		next
	endif

	//-- Inclui ocorrencias de marcacoes não geradas
	//if !Empty(aMarcAux)
	//	AADD(aMarcNoGer,{cMat + "-" + cNome, aMarcAux})
	//endif

	//Troca Filiais para Integridade
	cFilAnt := IF( !Empty( cFil ) , cFil , cFilAnt )

	aResult := {}

	//Ta dando erro quando lê proximo periodo.
	//PutOrdMarc( @aMarcacoes , aTabCalend , .t., .t., dPerDe, dPerAte, SRA->RA_FILIAL, SRA->RA_MAT )

	/*
	nMarc := 1
	while nMarc < len(aMarcacoes)
	nMarc++
	if aMarcacoes[nMarc][1] > dPerAte
	ADel( aMarcacoes, nMarc )
	ASize( aMarcacoes, len(aMarcacoes)-1 )
	nMarc := 1
	endif
	end
	*/

	if len(aMarcacoes) > 0
		for nMarc := 1 To len(aMarcacoes)
			aMarcacoes[nMarc][10] := 'N' //Força o reapontamento
		next nMarc
	endif

	//Verifica param.Turno se a 1a.Falta ‚ DSR e Verifica as datas de Excecoes quando for 1a.Falta=Folga
	dDataBase := dPerAte //Libera para o Pré Abono - Não mecher, procurar por Alexandre Silva ou Bruno Nunes 07/08/2017

	//Efetua o apontamento das marca‡”es
	if !Aponta(	dPerDe	,;	//01 - Periodo Inicial do Apontamento
	dPerAte			,;	//02 - Periodo Final do Apontamento
	@aMarcacoes		,;	//03 - Array com as Marcacoes dos Funcionarios
	aCaleAux		,;	//04 - Array com o Calendario de Marcacoes
	cFil			,;	//05 - Filial do Funcionario
	cMat			,;	//06 - Matricula do Funcionario
	aCodigos		,;	//07 - Array com os Eventos do Ponto
	@aResult		,;	//08 - Array com os Resultados Dia a Dia
	.T.				,;	//09 - Gravar Apontamento
	.F.				,;	//10 - Se Permite interrupcao durante o Processamento (HELP)
	@aLogFile		,;	//11 - Array com os Logs de Apontamento
	@aAbonosPer	 	 ;	//12 - Array com Todos os Abonos do Periodo (Por Referencia)
	)
	endif

	GravaSPC(aResult, SRA->RA_FILIAL, SRA->RA_MAT, '', dPerDe, dPerAte, aAbonosPer )

	if !Empty(aMarcDel)
		For nMarc := 1 to Len(aMarcDel)
			aAdd( aMarcacoes , aClone(aMarcDel[nMarc]) )
		Next nMarc
	endif

	//Verifica se Houve alteracao para efetuar a gravacao
	if !( ArrayCompare( aMarcClone , aMarcacoes ) ) .and. !empty(aMarcClone) .and. !empty(aMarcacoes)

		//Deleta os Registros de Marcacoes Automaticas que foram  recarregadas
		if !( lGetMarcAuto )
			PonDelRecnos( "SP8" , aRecsMarcAutDele , bCondDelAut )
		endif

		//Procura o Elemento inicial para a Gravacao das Marcacoes
		nSizeaMcClo		:= Len( aMarcClone )
		nSizeaMarca		:= Len( aMarcacoes )
		nMinSize		:= Min( nSizeaMcClo , nSizeaMarca )

		//Grava as Marcacoes no SP8
		if ( nMinSize > 0 )
			For nX := 1 To nMinSize
				if !( ArrayCompare( aMarcClone[ nX ] , aMarcacoes[ nX ] ) )

					//Grava Apenas o que foi Alterado
					PutMarcacoes( { aMarcacoes[ nX ] } , cFil , cMat , "SP8" , .F., Nil, Nil, Nil, .T. )
				endif
			Next nX

			//Grava as Novas informacoes
			if ( ( nX > nMinSize ) .and. ( nMinSize < nSizeaMarca ) )
				PutMarcacoes( aMarcacoes , cFil , cMat , "SP8" , .F. , NIL , nX, Nil, .T. )
			endif
		Else
			//Grava Todas as Marcacoes
			PutMarcacoes( aMarcacoes , cFil , cMat , "SP8" , .F., Nil, Nil, Nil, .T. )
		endif

		//Reinicializa aMarcClone
		aMarcClone := {}
	endif

	if !Empty(aMarcacoes)
		aMarcTot   := aMarcacoes
		aMarcacoes := {}
		aMarcDel   := {}
		aScan( aMarcTot, { |x| if (x[AMARC_TPMCREP] == "D",aAdd(aMarcDel,x),aAdd(aMarcacoes,x)) } )
	endif
	lRetorno := .T.

	//Final do Processo de Classificacao das Refeicoes

	cFilAnt := cSvFilAnt
	RestArea( aAreaSP8 )
Return( lRetorno )

/*
{Protheus.doc} fGeraRef
Classificar as marcacoes de refeicoes
@Param aTabCalend - Array com calendario
@Param cFil - filial do funcionario
@Param cMat - Matricula do funcionario
@Param nSerIni -
@Param nSerFim -
@Param lReaponta - Reaponto
@Param cPdPar - Apontamento parametro
@Param cPdEmprPar - Apontamento de paramatro de empresa
@Return boolean - .T. Refeicao processado, .F. Refeicao não processado
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function RfGeraRe( aTabCalend , cFil , cMat , nSerIni , nSerFim , lReaponta , cPdPar , cPdEmprPar )
	local aArea			:= GetArea()
	local aStruSP5		:= SP5->( dbStruct() )       //Colocar no Inicio do Programa
	local cAliasSP5		:= 'SP5'
	local cFilMat		:= ""
	local cSvFilAnt		:= cFilAnt
	local aCampos		:=	{}
	local nContField	:=	0
	local cQuery		:= ""
	local nX			:=	0
	local nPosCalend	:=	0
	local cCodRef		:= ""
	local cSeqRef		:= ""
	local cTipoRef		:= ""
	local cGeraFol		:= ""
	local cPD			:= ""
	local cPDEmpr		:= ""
	local nSeqMarc		:=	0
	local nValref		:=	0
	local nDescFun		:=	0
	local nSerMarc		:=  0
	local cRelogio		:= ""
	local cData			:= ""
	local cHora			:= ""
	local cHoraAux		:= ""
	local aTabRef		:= {}   //Tabela com as Informacoes de Identificacao de Refeicao
	local aContSeq		:= {}   //Array contador de Seq de Marcacao por Data/Tipo
	local nPosTipo		:= 0
	local lRet			:= .T.
	local lSp5QryOpened	:= .F.

	//Troca Filial para Integridade
	cFilAnt	:= IF( !Empty( cFil ) , cFil , cFilAnt )

	////Cria array com as marca‡”es do Periodo para o funcion rio.
	aMarcRef := {}
	SP5->( dbSetOrder( RetOrdem( "SP5" , "P5_FILIAL+P5_MAT+DTOS(P5_DATA)+STR(P5_HORA,5,2)" ) ) )
	cInicio		:= Dtos( aTabCalend[ 01 , 01 ] - 7 )
	cFinal		:= Dtos( aTabCalend[ Len(aTabCalend) , 01 ] + 7 )
	cAliasSP5	:= "QSP5"
	nContField	:= Len(aStruSP5)
	cQuery := "SELECT "
	For nX := 1 To nContField
		cQuery += aStruSP5[ nX , 01 ] + ", "
	Next nX
	cQuery += "R_E_C_N_O_ RECNO "
	cQuery += "FROM "+InitSqlName("SP5")+" SP5 "
	cQuery += "WHERE SP5.P5_FILIAL='"+SRA->RA_FILIAL+"' AND "
	cQuery += "SP5.P5_MAT='"+SRA->RA_MAT+"' AND "
	cQuery += "SP5.P5_DATA>='"+cInicio+"' AND "
	cQuery += "SP5.P5_DATA<='"+cFinal+"' AND "
	cQuery += "SP5.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder( SP5->( IndexKey() ) )
	cQuery := ChangeQuery(cQuery)
	if ( lSp5QryOpened := MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSP5,.T.,.T.,.F.,.F.))
		For nX := 1 To nContField
			if ( aStruSP5[nX][2] <> "C" )
				TcSetField(cAliasSP5,aStruSP5[nX][1],aStruSP5[nX][2],aStruSP5[nX][3],aStruSP5[nX][4])
			endif
		Next nX
	endif

	if !( lSp5QryOpened )
		cAliasSP5 := "SP5"
	endif

	cFilMat := ( cFil + cMat )

	if (cAliasSP5)->( MsSeek( cFilMat , .F. ) )
		//--Carrega as Marcacoes de Refeicao do Filial + Mat para o Array aCampos
		While (cAliasSP5)->( !Eof() .and. ( cFilMat == P5_FILIAL + P5_MAT ) )

			////Aborta o processamento caso seja pressionado Alt + A
			if ( lAbortPrint )
				Exit
			endif

			//-- Ignora marca‡”es fora do Per¡odo
			if (cAliasSP5)->( nSerMarc := __fDhtoNS(P5_DATA,P5_HORA) ) < nSerIni .or. nSerMarc > nSerFim
				(cAliasSP5)->( dbSkip() )
				Loop
			endif
			aAdd(aCampos, Array( 15 ) )             					//-- ** Array aCampos **
			nLenCampos := Len( aCampos )
			(cAliasSP5)->(aCampos[nLenCampos,01] := P5_DATA			)	//-- 01 Data
			(cAliasSP5)->(aCampos[nLenCampos,02] := P5_HORA			)	//-- 02 Hora
			#IFNDEF TOP
			(cAliasSP5)->(aCampos[nLenCampos,03] := Recno()    	)	//-- 03 Recno em SP5
			#ELSE
			if !( lSp5QryOpened )
				(cAliasSP5)->(aCampos[nLenCampos,03] := Recno() )	//-- 03 Recno em SP5
			Else
				(cAliasSP5)->(aCampos[nLenCampos,03] := RECNO	)	//-- 03 Recno em SP5
			endif
			#endif
			(cAliasSP5)->(aCampos[nLenCampos,04] := P5_CC  			)	//-- 04 Centro de Custo
			(cAliasSP5)->(aCampos[nLenCampos,05] := P5_RELOGIO 		)	//-- 05 Relogio
			(cAliasSP5)->(aCampos[nLenCampos,06] := P5_FLAG    		)	//-- 06 Flag Origem Marc
			(cAliasSP5)->(aCampos[nLenCampos,07] := P5_SEQ    	   	)	//-- 07 Seq. Refeicao
			(cAliasSP5)->(aCampos[nLenCampos,08] := P5_TIPOREF    	)	//-- 08 Tipo Refeicao
			(cAliasSP5)->(aCampos[nLenCampos,09] := P5_GERAFOL   	)	//-- 09 Gerar p/folha
			(cAliasSP5)->(aCampos[nLenCampos,10] := P5_PD   		)	//-- 10 Cod. Desc. Ref. Func.
			(cAliasSP5)->(aCampos[nLenCampos,11] := P5_VALREF   	)	//-- 11 Valor da Refeicao
			(cAliasSP5)->(aCampos[nLenCampos,12] := P5_APONTA   	)	//-- 12 Flag de Apontamento
			(cAliasSP5)->(aCampos[nLenCampos,13] := P5_CODREF  		)	//-- 13 Cod. da Refeicao
			(cAliasSP5)->(aCampos[nLenCampos,14] := P5_PDEMPR 		)	//-- 14 Cod. Desc. Ref. Empresa
			(cAliasSP5)->(aCampos[nLenCampos,15] := P5_DESCFUN		)	//-- 15 Desc. Ref. Funcionario
			(cAliasSP5)->( dbSkip() )

		End While
	endif

	//-- Indexa as Marcacoes de Refeicao  por Data + Hora
	aSort(@aCampos,,,{|x,y| DtoS(x[1])+StrTran(StrZero(x[2],5,2),'.','') < DtoS(y[1])+StrTran(StrZero(y[2],5,2),'.','')})

	//-- Inicia a Gravacao das Informacoes de Identificacao das Refeicoes
	SP5->( dbSetOrder( RetOrdem( "SP5" , "P5_FILIAL+P5_MAT+DTOS(P5_DATA)+STR(P5_HORA,5,2)" ) ) )

	//-- Inicializa as variavies auxiliares
	nLenCampos 	:= 	Len( aCampos )  	//-- Total de Marcacoes de Refeicoes
	cData		:= 	''               	//-- Variavel para verificacao de quebra de Data
	cHora       := 	'' 					//-- Variavel para verificacao de quebra de Hora
	cHoraAux	:= 	''

	//-- Corre Todas as Marcacoes de Refeicoes para Identificar o Tipo de Refeicao
	For nX := 1 to nLenCampos

		//-- Se Nao Reaponta e Aponta ='S' desconsidera para efeito de classificacao
		//-- da refeicao
		if !lReaponta .and. aCampos[ nX , 12 ] == "S"
			Loop
		endif

		//-- Se quebra de Data
		if cData <> Dtos( aCampos[ nX,1 ] )
			//-- Posiciona na Tabela Calendario (Data)  para obter o Codigo de Ref. da Data
			if ( nPosCalend := aScan( aTabCalend, {|x| x[1] == aCampos[nX,1] .and. x[4] == "1E" } ) ) > 0
				//-- Obtem o Codigo de Refeicao da Data da Marcacao lida na TabCalend
				cCodRef	:=	aTabCalend[nPosCalend][18]
			endif
		endif

		//Inicializa variavel auxiliar para conter a Hora da Refeicao
		cHoraaux :=	Str( aCampos[ nX,2 ],5,2 )

		//-- Se Codigo de Refeicao em Branco Nao houve controle sobre a Marcacao da Refeicao
		//-- gera Valores Padrao  ("ZZ" - Outros)
		if Empty(cCodRef)
			cSeqRef		:=	''
			cTipoRef		:=	'ZZ'
			cGeraFol		:=	'S'
			cPD			:=	cPdPar
			cPDEmpr		:=	cPdEmprPar
			nValRef		:=	0
			nDescFun		:=	0
		Else
			//Se marcacao gerada pela Leitura do Relogio
			if aCampos[nX,6] == 'E'
				cRelogio:=	aCampos[nX,5]
				//Identifica a Refeicao na Data/Hora marcada (Somente Checa Refeicoes Geradas)
				if Empty(Len(aTabRef:=Aclone(u_fIdentRe(aTabCalend,cHoraAux,cCodRef,Dtoc( aCampos[ nX,1 ] ), cRelogio  ))))
					//Nao Encontrou a Tabela de Refeicao /Tipo de Refeicao de Acordo com o Codigo passado
					lRet:= .F.
					Exit
				endif

				//-- Iguala Conteudo de Variaveis utilizadas para atualizacao de campos
				//-- Conteudo de aTabRef
				//----	{P1_Seq, P1_TipoRef, P1_Horaini, P1_HoraFim, P1_GeraFol, P1_PD, PM_ValRef, PM_PDEMPR, PM_DESCFUN}
				cSeqRef		:=	aTabRef[1]
				cTipoRef	:=	aTabRef[2]
				cPD			:=	aTabRef[6]
				nValRef		:=	aTabRef[7]
				cPDEmpr		:=	aTabRef[8]
				nDescFun	:=	aTabRef[9]

				//-- Se o Valor da Refeicao Nao For Nulo e Nao Houver Desconto do Funcionario
				//-- Flag serah setado para Nao descontar o valor da refeicao na Folha de Pagto.
				if !Empty(nValRef) .and. Empty(nDescFun)
					cGeraFol	:="N"
				Else
					cGeraFol	:=	aTabRef[5]
				endif

			Else
				//-- Marcacoes Cadastradas pelo Usuario sao Regravadas
				cSeqRef		:=	aCampos[nX,07]
				cTipoRef	:=	aCampos[nX,08]
				cGeraFol	:=	aCampos[nX,09]
				cPD	   		:=	aCampos[nX,10]
				nValRef		:=	aCampos[nX,11]
				cCodRef		:=  aCampos[nX,13]
				cPDEmpr		:=	aCampos[nX,14]
				nDescFun	:=	aCampos[nX,15]
			endif
		endif
		//--Iguala Variaveis verificadoras de quebra Data/Hora
		cData 	:= Dtos( aCampos[ nX,1 ] )
		cHora 	:= Str( aCampos[ nX,2 ],5,2 )

		aCampos[nX,07]	:= cSeqRef
		aCampos[nX,08]	:= cTipoRef
		aCampos[nX,09]	:= cGeraFol
		aCampos[nX,10]	:= cPD
		aCampos[nX,11]	:= nValRef
		aCampos[nX,12]	:= "S"
		aCampos[nX,13]	:= cCodRef
		aCampos[nX,14]	:= cPDEmpr
		aCampos[nX,15]	:= nDescFun
		//Pega Proxima Marcacao de Refeicao
	Next nX

	//Se Nao foi encontrada inconformidade na rotina de classificacao gera as seq ref
	if lRet
		//-- Indexa as Marcacoes de Refeicao  por Data + Tippo
		aSort(@aCampos,,,{|x,y| DtoS(x[1])+ x[8] < DtoS(y[1])+ y[8]})

		//-- Inicializa as variavies auxiliares
		nSeqMarc 	:=	0 		//-- Sequencia da Marcacao da Refeicao
		cData		:= ''       //-- Variavel para verificacao de quebra de Data
		cTipoRef	:=	'' 		//-- Variavel para verificacao de Tipo de Refeicao

		//-- Corre Todas as Marcacoes de Refeicoes
		For nX := 1 to nLenCampos

			//--Verifica a Quebra de Data/Tipo da Marcacao
			if (cData + cTipoRef ) <>	;
			( Dtos( aCampos[ nX,1 ] ) + aCampos[ nX,8 ] )


				//-- Se quebra de Data
				if cData <> Dtos( aCampos[ nX,1 ] )
					cData 		:= 	Dtos( aCampos[ nX,1 ] )
					//-- Inicializa array contador de seq de tipo ref por Tipo
					aContSeq := {}
					nPosTipo := 0
					//-- Se ocorreu quebra de data, zera contador de Sequencia de Refeicao
					nSeqMarc :=	0
				endif

				//Se Houve Quebra de Tipo de Refeicao na Data Lida
				if cTipoRef  <> aCampos[ nX,8 ]

					cTipoRef	:=	aCampos[ nX,8 ]

					//--Inicializa a Sequencia de Marcacoes de Refeicao
					//-- Se aContSeq nao Vazia
					if nPosTipo > 0
						aContSeq[ nPosTipo , 2 ] := nSeqMarc
						nSeqMarc := 0
					endif

					if ( nPosTipo := aScan( aContSeq,{ |xtipo| xtipo[1] == cTipoRef } ) ) == 0
						aAdd( aContSeq , { cTipoRef , 0 } )
						nPosTipo := Len( aContSeq )
					endif

					//-- Iguala a variavel contador de seq com o valor anterior da seq
					nSeqMarc := aContSeq[ nPosTipo , 2 ]

				endif

			endif

			//--Posiciona no Registro do SP5  conforme numero de registro armazenado anteriormente
			SP5->(DbGoto(aCampos[nX][3]))

			if SP5->( RecLock( "SP5" , .F. ) )
				SP5->P5_CODREF		:= aCampos[nX][13]
				SP5->P5_SEQ			:= aCampos[nX][07]
				SP5->P5_TIPOREF		:= aCampos[nX][08]
				SP5->P5_SEQMARC		:= StrZero(++nSeqMarc,2)
				SP5->P5_GERAFOL 	:= aCampos[nX][09]
				SP5->P5_PD			:= aCampos[nX][10]
				SP5->P5_VALREF		:= aCampos[nX][11]
				SP5->P5_APONTA		:= aCampos[nX][12]
				SP5->P5_PDEMPR		:= aCampos[nX][14]
				SP5->P5_DESCFUN		:= aCampos[nX][15]
				SP5->( MsUnLock() )
			endif
			//Pega Proxima Marcacao de Refeicao
		Next nX
	endif

	RestArea(aArea)

	cFilAnt	:= cSvFilAnt
Return( lRet )

/*
{Protheus.doc} fIdentRe
Funcao Identifica as Refeicao da Marcacao
@Param aTabCalend - Array com calendario
@Param pHora - Quantidade de horas
@Param cCodRef - Codigo da refeicao
@Param cData - Data de processamento
@Param cRelogio - Codigo do relogio
@Return array com refeicoes
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function fIdentRe(aTabCalend,pHora,cCodRef,cData, cRelogio)
	local aRet			:=	{}
	local nPosTabRef	:=	0
	local nPosTipoRef	:=	0
	local cHoraOrig		:=	""

	cHoraOrig	:= pHora
	pHora		:= Val(pHora)

	//--Procura a Tabela de Refeicao
	nPosTabRef:=Ascan(aTabRef,{|xRef| xRef[1] == cCodRef})

	//--Se Encontrou
	if !EMPTY(nPosTabRef)

		//-- Procura o Tipo de Refeicao de acordo com o horario da marcacao
		//-- Verifica se Hora ini e Hora fim forem zeradas o Tipo Ref  eh "ZZ" e por
		//-- isso nao  considera esse horario para enquadramento da hora a ser classificada
		nPosTipoRef:=Ascan(aTabRef[nPosTabRef][2],;
		{|xTabTipoRef|Iif(	!Empty(xTabTipoRef[3]) .or. !Empty(xTabTipoRef[4]) 			,;
		( Pna150Hor(,xTabTipoRef[3] , xTabTipoRef[4], pHora) 	.AND.   ;
		(xTabTipoRef[10] == cRelogio)								;
		)		,;
		.F.		 ;
		) 			 ;
		})

		//-- Procura pelo Horario para Relogio em Branco se Nao encontrou para o relogio especifico
		if Empty(nPosTipoRef)
			nPosTipoRef:=Ascan(aTabRef[nPosTabRef][2],;
			{|xTabTipoRef|Iif(	!Empty(xTabTipoRef[3]) .or. !Empty(xTabTipoRef[4]) 			,;
			( Pna150Hor(,xTabTipoRef[3] , xTabTipoRef[4], pHora) 	.AND.   ;
			(xTabTipoRef[10] == SPACE(LEN(xTabTipoRef[10])) )			;
			)		,;
			.F.		 ;
			) 			 ;
			})
		endif

		//--Se Encontrou
		if !EMPTY(nPosTipoRef)

			//Obtem as informacoes sobre a refeicao
			// nSeqRef, cTipoRef ,  nSeqMarc	, cGeraFol	,  cPD
			aRet:=aTabRef[nPosTabRef][2][nPosTipoRef]

		Else

			//--Registra Inconsistencia Sem Abortar Operacao

			//Prenche array com conteudo para tipo de refeicao -> "Outros"
			//--	{P1_Seq, P1_TipoRef, P1_Horaini, P1_HoraFim, P1_GeraFol, P1_PD, PM_ValRef}
			//-- Procura o Tipo de Refeicao "ZZ"
			nPosTipoRef:=Ascan(aTabRef[nPosTabRef][2],{|xTipoRef| xTipoRef[2] == "ZZ" })

			//--Se Encontrou Tipo "ZZ"
			if !EMPTY(nPosTipoRef)

				//Obtem as informacoes sobre a refeicao
				// nSeqRef, cTipoRef ,  nSeqMarc	, cGeraFol	,  cPD
				aRet:=aTabRef[nPosTabRef][2][nPosTipoRef]

			Else

				//--Registra Inconsistencia Sem Abortar Operacao
				aRet	:=	{'' , 'ZZ' ,,,'','', 0 }
			endif
		endif
	Else
		//--Aborta Operacao
		aRet	:= {}
	endif
Return( aRet )

/*
{Protheus.doc} fIdentRe
Funcao carregar Array com os Dados das Refeicoes para uma Filial
@Param aTabRef - Array com os Dados das Refeicoes
@Param cFil - Filial a ser Pesquisada
@Return array com refeicoes
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function FTABREFB( aTabRef, cFil )
	local aArea			:= GetArea()
	local aAreaSP1		:= {}
	local aAreaSPM		:= {}
	local aTabTipoRef	:= {}
	local cCodRefAnt	:= ""
	local cPD			:= ""
	local cPDEmpr		:= ""
	local cTipoRefAnt	:= ""
	local lRet      	:= .T.
	local nDescFun      := 0
	local nElem			:= 0
	local nValRef		:= 0

	//-- Carrega Tabela de Tipos de Refeicao
	dbSelectArea('SPM')
	aAreaSPM	:= GetArea()
	SPM->(MsSeek(cFil))
	While SPM->( !Eof() .and. PM_FILIAL == cFil )
		aAdd(aTabTipoRef, {	SPM->PM_TIPOREF,SPM->PM_VALREF, SPM->PM_PD, SPM->PM_PDEMPR,;
		Round(SPM->PM_VALREF	* (SPM->PM_PERCFUN / 100),2) })

		SPM->(dbSkip())
	End While

	//-- Deve Haver pelo menos o Tipo de Refeicao ZZ
	if Empty(Len( aTabTipoRef ) )
		lRet :=	.F.
	endif

	//-- Corre Refeicoes se Houver Tipos Cadastrados
	if LRet
		dbSelectArea('SP1')
		aAreaSP1	:= GetArea()

		// |--aTabRef  (ESTRUTURA)    (Nivel 01) ----------------------------------------------
		//	 |--CodRef                (Nivel 02)
		//   	|-------P1_Seq
		//		|-------P1_TipoRef
		//		|-------P1_Horaini
		//		|-------P1_HoraFim    (Nivel 03)
		//		|-------P1_GeraFol
		//		|-------P1_PD
		//		|-------PM_ValRef
		//		|-------PM_PDEmpr
		//		|-------PM_DescFun
		//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		SP1->(MsSeek(cFil))
		While SP1->( !Eof() .and. P1_FILIAL == cFil )

			if SP1->P1_CODREF <> cCodRefAnt
				cCodRefAnt	:=	SP1->P1_CODREF
				AAdd(aTabRef , {SP1->P1_CODREF,{}} )

			endif

			//-- Verifica a Existencia do TipoRef na Tabela de Refeicoes
			if cTipoRefAnt# SP1->P1_TipoRef
				cTipoRefAnt:=SP1->P1_TipoRef
				nElem:=Ascan(aTabTipoRef,{|x| x[1] == SP1->P1_TIPOREF })
				if Empty(nElem)
					aTabRef:={}
					//--Registra Inconsistencia Aborta Operacao

					Exit
				endif
				//-- Atualiza o Valor da Refeicao de acordo com o seu tipo
				nValref	:=	aTabTipoRef[nElem,2]
				//-- Atualiza o Cod.Evento Desc. Refeicao Parte Funcionario
				cPD		:=	aTabTipoRef[nElem,3]
				//-- Atualiza o Cod.Evento Desc. Refeicao Parte Empresa
				cPDEmpr	:=	aTabTipoRef[nElem,4]
				//-- Atualiza o Valor Desconto da Refeicao Parte Funcionario
				nDescFun	:=	aTabTipoRef[nElem,5]

			endif

			aAdd(aTabRef[Len(aTabRef)][2] , {	SP1->P1_SEQ			,;
			SP1->P1_TIPOREF 	,;
			SP1->P1_HORAINI 	,;
			SP1->P1_HORAFIM  	,;
			SP1->P1_GERAFOL   	,;
			cPD 		    	,;
			nValRef 		    ,;
			cPDEmpr		    	,;
			nDescFun			})

			//-- Se Existir o campo Relogio na Tabela de Refeicoes adiciona-o
			aAdd(aTabRef[Len(aTabRef)][2][Len(aTabRef[Len(aTabRef)][2])] , SP1->P1_RELOGIO			)

			SP1->(dbSkip())
		End While
		RestArea( aAreaSP1 )
	endif

	RestArea( aArea )
Return( lRet )

/*
{Protheus.doc} GetParam
Funcao que obtem os conteudos dos parametros
@Param cChar - Caractere de parametro para ultimo registro do parametro "Z"
@Return Nulo
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function GetParam(cChar)
	local nAponta
	local cFilDe
	local cFilAte
	local cRelDe
	local cRelAte

	Pergunte( "PNM010" , .F. )

	cFilDe    := IF( lWorkFlow .and. lUserDefParam .and. !lProcFilial , mv_par01 , IF( !lWorkFlow , mv_par01 , IF( lProcFilial , cFilAnt , "" ) ) )		//Filial De
	cFilAte   := IF( lWorkFlow .and. lUserDefParam .and. !lProcFilial , mv_par02 , IF( !lWorkFlow , mv_par02 , IF( lProcFilial , cFilAnt , Replicate(cChar,Len(SRA->RA_FILIAL) ) ) ) )								//Filial Ate
	cRelDe    := IF( lWorkFlow .and. lUserDefParam , mv_par11 , IF( !lWorkFlow , mv_par11 , ""	) )										  // Relogio De
	cRelAte   := IF( lWorkFlow .and. lUserDefParam , mv_par12 , IF( !lWorkFlow , mv_par12 , Replicate(cChar,Len(SP0->P0_RELOGIO) ) ) ) // Relogio Ate
	nAponta	  := IF( lWorkFlow .and. lUserDefParam , mv_par18 , IF( !lWorkFlow , mv_par18 , 3	) )																													//Leitura/Apontamento 1=Marcacoes 2=Refeicoes 3=Acesso 4=Marcacoes e Refeicoes 5=Todos

	__LastParam__:= {cFilDe,cFilAte,cRelDe,cRelAte, nAponta}
Return

/*
{Protheus.doc} CSRH020
Verifica se apontamento é de dia anterior
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function CSRH020(cFil, cMat, dDia, cIdLog, cPerAponta, cOrdem)
	local cChaveSP8 := cFil+cMat+tira1( cOrdem )
	local dRetorno  := dDia
	local lOrdemAnt := .T.

	while lOrdemAnt
		lOrdemAnt := .F.
		SP8->(dbSetOrder(1))
		if SP8->(dbSeek(cChaveSP8))
			while SP8->(!EoF()) .And. cChaveSP8 == SP8->(P8_FILIAL+P8_MAT+P8_ORDEM)
				if cPerAponta == SP8->P8_PAPONTA
					if SP8->P8_DATA == dRetorno
						dRetorno := dRetorno -1
						cChaveSP8 := cFil+cMat+tira1( SP8->P8_ORDEM )
						lOrdemAnt := .T.
						exit
					endif
				endif
				SP8->(dbSkip())
			end
		endif
	end
Return dRetorno

/*
{Protheus.doc} ValParam
Valida tipo de objeto
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function ValParam(oObj, cTipo)
	local lRetorno := .t.

	default cTipo  := ""

	if valtype(oObj) != cTipo
		conout("[PP] 0005 - Parametro invalido ou diferente do esperado")
		lRetorno := .f.
	endif
return lRetorno

/*
{Protheus.doc} leituraPon
Controle de leitura dos dias, conforme data do sistema.
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
user function ponDLimL()
	local dRetorno := ctod('  /  /  ')
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := "" 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F. //Conta quantidade de registros da query executada
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	cQuery := " SELECT "
	cQuery += " 	SUBSTRING(RCC_CONTEU, 01, 16) CODIGO, "
	cQuery += " 	SUBSTRING(RCC_CONTEU, 01, 08) DATA_INI, "
	cQuery += " 	SUBSTRING(RCC_CONTEU, 09, 08) DATA_FIM, "
	cQuery += " 	SUBSTRING(RCC_CONTEU, 42, 08) ULT_LEITURA "
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName('RCC')+" RCC "
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RCC_CODIGO = 'U007' "
	cQuery += " 	AND SUBSTRING(RTRIM(RCC_CONTEU), 17, 1) = '1' "
	cQuery += " ORDER BY 1 DESC "

	//Executa consulta SQL
	if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
		( cAlias )->( dbGoTop() ) //Posiciona no primeiro registro
		while ( cAlias )->(!EoF())
			dRetorno := sToD( ( cAlias )->ULT_LEITURA )
			exit
			( cAlias )->( dbSkip() )
		end
		( cAlias )->( dbCloseArea() )
	endif

	if empty(dRetorno)
		dRetorno := msDate() -1
	endif
Return(dRetorno)

/*
{Protheus.doc} retNAprov
Retorna nivel do aprovador
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function retNAprov( cChavePBD )
	local nNivel  := 0

	default cChavePBD := ""

	PBD->(dbSetOrder(3))
	if PBD->(dbSeek( cChavePBD ))
		nNivel := PBD->PBD_NIVEL
	endif
Return( nNivel )

/*
{Protheus.doc} retStaPBB
Retorna status do aprovador - ativo ou inativo
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function retStaPBB( cChavePBD )
	local nNivel  := 0

	default cChavePBD := ""

	PBD->(dbSetOrder(3))
	if PBD->(dbSeek( cChavePBD ))
		nNivel := PBD->PBD_STATUS
	endif
Return nNivel

/*
{Protheus.doc} RBPorPon
Reverte aprovação e apontamentos feitos pelo usuário
@Param cFil - Filial do funcionario
@Param cMat - Matricula do funcionario
@Param dDia - Data de processamento
@Param cIdLog - complemento do nome do arquivo do log
@Param cPerAponta - Periodo de apontamento
@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
User Function RBPorPon(cPerAponx, lVisual)
	local cChavePB7 := ""
	local cChavePBB := ""
	local cChaveSP8 := ""
	local cMsg 		:= ""
	local dDia		:= ctod('  /  /  ')
	local lPB7 		:= .F.
	local lPBB 		:= .F.
	local nLinha 	:= 1

	default cPerAponx :=  GetPeriodo()
	default lVisual := .F.

	for nLinha := 1 to len(aCols)

		dbSelectArea('SPC')
		SPC->(dbGoto(aCols[nLinha][21]))

		if 	aCols[nLinha][4] != aColsAnt[nLinha][4] ;
		.OR. aCols[nLinha][5] != aColsAnt[nLinha][5] ;
		.OR. aCols[nLinha][6] != aColsAnt[nLinha][6] ;
		.OR. aCols[nLinha][7] != aColsAnt[nLinha][7] ;
		.OR. aCols[nLinha][8] != aColsAnt[nLinha][8]

			cChavePB7 :=  SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA))
			cChavePBB :=  xFilial('PBB')+SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA))
			cChaveSP8 :=  SPC->(PC_FILIAL+PC_MAT+DTOS(PC_DATA)) //2 - P8_FILIAL+P8_MAT+DTOS(P8_DATA)+STR(P8_HORA,5,2)
			cPerAponx :=  U_fRetPerP(cPerAponx, SPC->PC_DATA)

			dDia := SPC->PC_DATA
			lPB7 := .F.
			PBB := .F.

			//Rollback na PB7
			PB7->(dbSetOrder(1))
			if PB7->(dbSeek( cChavePB7 ) )
				while PB7->(!EoF()) .and. PB7->(PB7_FILIAL+PB7_MAT+DTOS(PB7_DATA)) == cChavePB7
					RecLock('PB7',.F.)
					//PB7->PB7_LOG := 'Del RBPorPon User Protheus: '+RetCodUsr()+" - "+usrFullName(RetCodUsr())
					PB7->(dbDelete())
					PB7->(MsUnLock())
					lPB7 := .T.
					PB7->(dbSkip())
				end
			endif

			//Rollback na PBB
			PBB->(dbSetOrder(2))
			if PBB->(dbSeek( cChavePBB ) )
				while PBB->(!EoF()) .and. PBB->(xFilial('PBB')+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)) == cChavePBB
					RecLock('PBB',.F.)
					PBB->PBB_LOG := 'Del RBPorPon User Protheus: '+RetCodUsr()+" - "+usrFullName(RetCodUsr())
					PBB->(dbDelete())
					PBB->(MsUnLock())
					lPBB := .T.
					PBB->(dbSkip())
				end
			endif

			u_CSRH012(SPC->PC_FILIAL, SPC->PC_MAT, cPerAponx, '000000', dDia, dDia)

			if lPBB .and. lPB7
				cMsg := 'Foram desfeitos os apontamentos e aprovaçõs realizados pelo usuário e gestor. Data: '+DTOC(dDia)
			elseif !lPBB .and. lPB7
				cMsg := 'Foram desfeitos os apontamentos realizados pelo usuário. Data: '+DTOC(dDia)
			elseif lPBB .and. !lPB7
				cMsg := 'Foram desfeitas as aprovaçõs realizados pelo gestor. Data: '+DTOC(dDia)
			endif
		endif
	next nLinha
Return

/*
{Protheus.doc} fRetPerP
Ajusta o periodo do ponto em execução, conforme a data em manutençã passada pelo parametro.
cPeriodo = Periodo de apontamento existente no MV_PONMES para comparação.
dDia     = Data da Marcação / Apontamento em manutenção.
@Return cPeriodo
@author Alexandre Alves
@since 01/03/2016
@version 2.01
*/
User Function fRetPerP(cPeriodo, dDia)
	local cAPFim   := " "
	local cAPIni   := " "
	local cDPFim   := " "
	local cDPIni   := " "
	local cMPFim   := " "
	local cMPIni   := " "
	local dDPerFim := CToD("  /  /  ")
	local nPosBar  := 0

	cPeriodo := AllTrim(cPeriodo)

	nPosBar := Rat("/",cPeriodo)
	if nPosBar > 0
		cPeriodo := Substr(cPeriodo,1,(nPosBar-1)) + Substr(cPeriodo,(nPosBar+1), Len(cPeriodo) - nPosBar  )
	endif

	dDPerFim := SToD( Substr(cPeriodo,9,8)    )

	if dDia > dDPerFim

		cDPIni := (   Day(dDPerFim) + 1)
		cMPIni :=   Month(dDPerFim)
		cAPIni :=    Year(dDPerFim)

		if cMPIni = 12
			cDPFim := StrZero(Day(dDPerFim),2)
			cMPFim := "01"
			cAPFim := StrZero((cAPIni + 1),4)
		Else
			cDPFim := StrZero(Day(dDPerFim) ,2)
			cMPFim := StrZero((cMPIni + 1)  ,2)
			cAPFim := StrZero(Year(dDPerFim),4)
		endif

		cDPIni := StrZero(cDPIni,2)
		cMPIni := StrZero(cMPIni,2)
		cAPIni := StrZero(cAPIni,4)

		cPeriodo :=  (cAPIni + cMPIni + cDPIni) + (cAPFim + cMPFim + cDPFim)
	endif
Return(cPeriodo)

/*
{Protheus.doc} fGrpApv
Resgata o codigo do Grupo de Aprovação que passou a ser gravado na RD0.
cFilial = Filial do colaborador em processamento.
cMat    = Filial do colaborador em processamento.
@Return cQuery
@author Alexandre Alves
@since 13/04/2017
@version 2.01
*/
User Function  fGrpApv(cFil, cMat)
	local cQuery  := ""

	default cFil := ""
	default cMat := ""

	cQuery := "SELECT DISTINCT RA_FILIAL, RA_CC, RA_MAT, RD0_GRPAPV "
	cQuery += "FROM "+RetSqlName("SRA")+" SRA       "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("RDZ")+" RDZ ON RA_FILIAL = SUBSTR(RDZ_CODENT,1,2) AND "
	cQuery += "                                             RA_MAT    = SUBSTR(RDZ_CODENT,3,6) AND "
	cQuery += "                                             RDZ.D_E_L_E_T_ <> '*' AND "
	cQuery += " 													SRA.RA_DEMISSA = '' "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = RDZ_CODRD0 AND RD0.D_E_L_E_T_ <> '*' "
	cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' "
	cQuery += "  AND RA_FILIAL = '"+AllTRim(cFil)+"' "
	cQuery += "  AND RA_MAT    = '"+AllTRim(cMat)+"' "
Return(cQuery)

/*
{Protheus.doc} DelApro
Exclui registros PBB, relacionados à data em manutenção.
@type function
@Param cChavePBB - Chave do índice 2 da tabela de aprovações PBB - Filial+Filial da Matricula +Matrícula+Data do apontamento
@author Bruno Nunes.
@since 28/07/2017
@version 2.01
@return nulo
*/
Static Function DelApro(cChavePBB, cIdLog)
	default cChavePBB := ""
	default cIdLog    := ""

	PBB->(dbSetOrder(2))
	if PBB->(dbSeek(cChavePBB))
		while PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)) == cChavePBB
			RecLock('PBB',.F.)
			PBB->PBB_LOG := 'Del DelApro Participante: '+cIdLog
			PBB->(dbDelete())
			PBB->(MsUnLock())
			PBB->(dbSkip())
		end
	endif
Return

/*
{Protheus.doc} ReverteRF0
Reverter os registros de Pré Abono para a situação de não apontado.
@type function
@Param cChaveRF0 - Chave do índice 1 da tabela de pré abono RF0 - Filial+Matricula
@Param dIni - Data inicial para reverção do pré abono
@Param dFim - Data final para reverção do pré abono
@author Bruno Nunes.
@since 07/08/2017
@version 2.01
@return nulo
*/
Static Function ReverteRF0(cChaveRF0, dIni, dFim)
	default cChaveRF0 := ""
	default dIni 	  := ctod("//")
	default dFim 	  := ctod("//")

	RF0->(dbSetOrder(1))
	if RF0->(dbSeek(cChaveRF0+dtos(dIni)))
		while RF0->(RF0_FILIAL+RF0_MAT) == cChaveRF0
			if RF0->RF0_DTPREI >= dIni .AND. RF0->RF0_DTPREF <= dFim
				RecLock('RF0',.F.)
				RF0->RF0_ABONA := 'N'
				RF0->(MsUnLock())
			endif
			RF0->(dbSkip())
		end
	endif
Return

/*
{Protheus.doc} GetPeriodo
Monta periodo do ponto eletrônico conforme tabela SPO e dDatabase
@type function
@author Bruno Nunes.
@since 07/08/2017
@version 2.01
@return cPeriodo - periodo do ponto
*/
Static Function GetPeriodo()
	local cAlias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cPeriodo 	 := ""
	local cQuery 	 := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local nRec 		 := 0

	cQuery := " SELECT "
	cQuery += " 	PO_DATAINI, "
	cQuery += " 	PO_DATAFIM  "
	cQuery += " FROM  "
	cQuery += " "+RetSQLName("SPO")+" "
	cQuery += " WHERE  "
	cQuery += " 	D_E_L_E_T_ = ' ' "
	cQuery += " 	AND PO_DATAINI <= '"+DTOS(dDataBase)+"'"
	cQuery += " 	AND PO_DATAINI >= '"+DTOS(dDataBase)+"'"
	cQuery += " 	AND PO_FILIAL =   '"+xFilial('SPO')+"'"

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		(calias)->(dbGoTop())
		cPeriodo := (calias)->(PO_DATAINI+PO_DATAFIM)
		(calias)->(dbCloseArea())
	endif
Return cPeriodo

/*
{Protheus.doc} MaNgAprv
Verifica se as horas negativas foram aprovadas e retorna essa informação
@type function
@author Bruno Nunes.
@since 07/08/2017
@version 2.01
@return lRetorno - .T. Horas negativas aprovadas, .F. horas negativas não aprovadas.
*/
user function MaNgAprv(cFilFunc, cMatFunc, dDia)
	local cAlias 	 := GetNextalias() 	// alias resevardo para consulta SQL
	local cQuery 	 := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local lRetorno 	 := .F.
	local nRec 		 := 0

	default cFilFunc := ""
	default cMatFunc := ""
	default dDia     := ctod('//')

	if !empty(cFilFunc) .and. !empty(cMatFunc) .and. dDia != ctod('//')
		cQuery :=  QryPB7Ver(cFilFunc, cMatFunc, {{dDia}})
		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			(calias)->(dbGoTop())
			lRetorno 	:= ( (calias)->PB7_STAATR == '3' )
			(calias)->(dbCloseArea())
		endif
	endif
Return lRetorno

/*
{Protheus.doc} GetPeriodo
Retornar query da ultima versão da PB7
@type function
@author Bruno Nunes
@since 07/08/2017
@version 2.01
*/
user function QryPB7(cFilFunc, cMatFunc, dDia)
	default cFilFunc := ""
	default cMatFunc := ""
	default dDia     := ctod("//")
return QryPB7Ver(cFilFunc, cMatFunc, {{dDia}})

/*
{Protheus.doc} valPerTa
Retornar query da ultima versão da PB7
@type function
@author Bruno Nunes
@since 07/08/2017
@version 2.01
*/
user function valPerTa( nLibera )
	local aListaFunc := {}
	local lValido    := .F.

	default nLibera := 0

	if nLibera == 1
		lValido := valSemGrp(@aListaFunc)
		if !lValido
			geraEmail(aListaFunc)
			msgInfo( cMSG_SEM_GRUPO_APROVACA0, cTIT_SEM_GRUPO_APROVACA0 )
		endif
	elseif nLibera == 0
		lValido   := .T.
	endif
return lValido

/*
{Protheus.doc} valSemGrp
Retornar query da ultima versão da PB7
@type function
@author Bruno Nunes
@since 07/08/2017
@version 2.01
*/
static function valSemGrp(aLista)
	local cAlias     := getNextAlias()
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local lRetorno   := .T.
	local nRec       := 0

	default aLista := {}

	cQuery := " SELECT "
	cQuery += "    RA_FILIAL, "
	cQuery += "    RA_MAT, "
	cQuery += "    RA_NOME, "
	cQuery += "    RA_CC, "
	cQuery += "    RA_DEPTO "
	cQuery += " FROM "
	cQuery += "    "+RetSqlName('SRA')+" SRA "
	cQuery += "    INNER JOIN "
	cQuery += "       "+RetSqlName('RDZ')+" RDZ "
	cQuery += "       ON RDZ.D_E_L_E_T_ = ' ' "
	cQuery += "       AND RDZ.RDZ_ENTIDA = 'SRA' "
	cQuery += "       AND RDZ.RDZ_CODENT = RA_FILIAL || RA_MAT "
	cQuery += "    INNER JOIN "
	cQuery += "       "+RetSqlName('RD0')+" RD0 "
	cQuery += "       ON RD0.D_E_L_E_T_ = ' ' "
	cQuery += "       AND RDZ.RDZ_CODRD0 = RD0_CODIGO "
	cQuery += "       AND RD0.RD0_GRPAPV = '' "

	//Executa consulta SQL
	if u_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		lRetorno := .F.
		while (cAlias)->(!EoF())
			aAux := {}
			aAdd( aAux, alltrim( (cAlias)->RA_FILIAL ) )
			aAdd( aAux, alltrim( (cAlias)->RA_MAT )   + " - " + alltrim( (cAlias)->RA_NOME ) )
			aAdd( aAux, alltrim( (cAlias)->RA_CC )    + " - " + alltrim( posicione( "CTT", 1, xFilial("CTT") + (cAlias)->RA_CC, "CTT_DESC01" )))
			aAdd( aAux, alltrim( (cAlias)->RA_DEPTO ) + " - " + alltrim( posicione( "SQB", 1, xFilial("SQB") + (cAlias)->RA_DEPTO, "QB_DESCRIC" )))
			aAdd( aLista, aAux )

			(cAlias)->(dbSkip())
		end
	endif
return lRetorno

/*
{Protheus.doc} geraEmail
Retornar query da ultima versão da PB7
@type function
@author Bruno Nunes
@since 07/08/2017
@version 2.01
*/
static function geraEmail( aListaFunc )
	local aArea     := GetArea()
	local aHeader	:= {}  	//Dados que irao compor o envio do email
	local cEmail    := usrRetMail(RetCodUsr())
	local nTempo    := 0
	local nTempoFim := 0

	private lModoDebug := .F.

	default aListaFunc := {}

	if empty(aListaFunc)
		return
	endif

	if empty(cEmail)
		alert("Usuário do Protheus sem email cadastro. Contate o departamento Sistemas Corporativo para cadastramento do email.")
		return
	endif

	//Configura caminho do portal GCH
	if empty( GetGlbValue( cPARAM_CAMINHO ) ) .or. empty( GetGlbValue( cPARAM_MODO_DEBUG ) )
		u_ParamPtE()
	endif

	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	valPerTa iniciado em: " + dtoc( msDate() ) + " as " + time() )
	endif

	if !empty( aListaFunc )
		aAdd( aHeader, cEmail  )
		aAdd( aHeader, cMSG1 )

		envEmail( aHeader, cTITULO_EMAIL, aListaFunc )
	endif

	if lModoDebug
		nTempoFim := seconds()
		conout("	Tempo de execucao: " + cValToChar( nTempoFim - nTempo ) + " segundos" )
		conout("	valPerTa encerrado em: " + dtoc( msDate() ) + " as " + time() )
	endif
	RestArea(aArea)
Return

/*
{Protheus.doc} EnvEmail
Envia email conforme parametros
@type function
@author Bruno Nunes
@since 23/02/2016
@version 2.01
@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email
@return nulo
*/
Static Function envEmail(aHeader, cTituloEmail, aListaFunc )
	local aLinha      := {}
	local cClassLin   := ""
	local cEmailAprov := "" //Email do aprovador
	local chtml 	  := "" //Strinf com html
	local cMsgHTML 	  := "" //Mensagem do email
	local nColuna 	  := 0
	local nLinha      := 0

	default aHeader 	 := {}
	default cTituloEmail := 'Email enviado pelo Protheus'
	default aListaFunc   := {}

	cEmailAprov := aHeader[1] //email do usuario aprovador
	cMsgHTML 	:= aHeader[2]

	//Inicia construcao do html
	chtml += '<!DOCTYPE HTML>'
	chtml += '<html>'
	chtml += '	<head>'
	chtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	chtml += '	</head>'
	chtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	chtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	chtml += '		<tr>'
	chtml += '			<td valign="top" align="center">'
	chtml += '				<table width="627">'
	chtml += '					<tr>'
	chtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<h2>'
	chtml += '								<span style="color:#FE5000" ><strong>'+cTituloEmail+'</strong></span>'
	chtml += '								<br />'
	chtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	chtml += '							</h2>'
	chtml += '						</td>'
	chtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	chtml += '						</td>'
	chtml += '					</tr>'
	chtml += '				</table>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>Lista de colaboradores sem grupo de aprovação: <br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'

	//Lista do grupo de aprovção
	if len(aListaFunc) > 0
		chtml += '		<tr>'
		chtml += '			<td valign="top"  align="center" >'
		chtml += '				<table border="0" cellpadding="0" cellspacing="0" style="width:90%;">'
		chtml += '					<thead  >'
		chtml += '						<tr>'
		for nLinha := 1 to len(aTITULO_TABELA)
			chtml += '						<th align="'+aALIGN_COL[nLinha]+'" style="border-bottom:1px solid ; margin-right:5px; " >'+alltrim(aTITULO_TABELA[nLinha])+'</th>' //Monta cabecalho da tabela
		next nLinha
		chtml += '						</tr>'
		chtml += '					</thead>'
		for nLinha := 1 to len(aListaFunc)
			aLinha := aListaFunc[nLinha]
			iif (cClassLin == 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF')
			chtml += '				<tbody>'
			chtml += '					<tr>'
			for nColuna := 1 to len(aLinha)
				if aTYPE_COL[nColuna] == 'T'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+alltrim(left(Capital(aLinha[nColuna]),75))+'</span></div></td>' //insere coluna
				elseif aTYPE_COL[nColuna] == 'N'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+cValToChar(aLinha[nColuna])+'</span></div></td>' //insere coluna
				elseif aTYPE_COL[nColuna] == 'A'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></span></div></td>'  //insere coluna
				endif
			next nColuna
			chtml += '					</tr>'
		next nLinha
		chtml += '					</tbody>'
		chtml += '				</table>'
		chtml += '			</td>'
		chtml += '		</tr>'
	endif
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="border-bottom:2px solid #003087; " >'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	chtml += '				<p align="left">'
	chtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	chtml += '				</p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '	</table>'
	chtml += '	</body>'
	chtml += '</html>'

	//Rotina de envio de email
	FsSendMail(cEmailAprov, cTituloEmail, chtml)

	if lModoDebug
		conout("	|")
		conout("	+---> Enviado para: "+cEmailAprov + " Titulo: "+cTituloEmail )
		conout("	|")
		conout("	+---> Processado em: "+dtoc(msDate()) + " Por: " + RetCodUsr() + " - "+ usrFullName(RetCodUsr()) )
		conout("")
	endif
Return

static function marcRelogi( aMarcDia, nHrMarc )
	local cAlias     := getNextAlias()
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local nRec       := 0
	local lRetorno   := .F.

	default aMarcDia := {}
	default nHrMarc   := 0

	cQuery := " SELECT "
	cQuery += " 	P8_FILIAL, "
	cQuery += "  	P8_MAT,  "
	cQuery += " 	P8_ORDEM, "
	cQuery += " 	P8_DATA,  "
	cQuery += " 	P8_FLAG "
	cQuery += " FROM  "
	cQuery += " 	"+RetSQLName("SP8")
	cQuery += " WHERE  "
	cQuery += " 	D_E_L_E_T_ = ' ' "
	cQuery += " 	AND P8_FILIAL   = '" + aMarcDia[01] + "' "
	cQuery += " 	AND P8_MAT      = '" + aMarcDia[02] + "' "
	cQuery += " 	AND P8_ORDEM    = '" + aMarcDia[34] + "' "
	cQuery += " 	AND P8_PAPONTA  = '" + aMarcDia[36] + "' "
	cQuery += " 	AND P8_HORA     = " + cValToChar( nHrMarc )+" "
	cQuery += " 	AND P8_FLAG IN ('E','A') "

	if u_montarSQ( cAlias, nRec, cQuery, lExeChange, lTotaliza )
		lRetorno   := .T.
		(cAlias)->(dbCloseArea())
	endif
return lRetorno

static function retMatApro( cAprovador, cFilMatApr )
	local cAlias     := getNextAlias()
	local cQuery     := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local nRec       := 0
	local lRetorno   := .F.

	default cAprovador := ""
	default cFilMatApr := ""

	//Monta qurey do participantes
	cQuery := " SELECT SRA.RA_FILIAL, SRA.RA_MAT"
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName("RD0")+" RD0, "
	cQuery += " 	"+RetSqlName("RDZ")+" RDZ, "
	cQuery += " 	"+RetSqlName("SRA")+" SRA  "
	cQuery += " WHERE "
	cQuery += " 		SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RD0.D_E_L_E_T_ = ' '"
	cQuery += " 	AND RDZ.D_E_L_E_T_ = ' '"
	cQuery += " 	AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
	cQuery += " 	AND RDZ.RDZ_CODENT = SRA.RA_FILIAL || SRA.RA_MAT "
	cQuery += " 	AND RDZ.RDZ_ENTIDA = 'SRA' "
	cQuery += " 	AND SRA.RA_SITFOLH <> 'D' "
	cQuery += " 	AND RD0.RD0_CODIGO = '" + cAprovador + "'

	//Executa consultar
	if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza)
		cFilMatApr := (cAlias)->( RA_FILIAL + RA_MAT )
		lRetorno   := .T.
		(cAlias)->( dbCloseArea() )
	endif
return lRetorno

/*
{Protheus.doc} geraVers0
Insere PB7 versão 0 quando não existir.
@type function
@author Bruno Nunes
@since 13/08/2019
@version 2.01
@param cFilFunc, string, Filial do funcionario
@param cMatFunc, string, Matricula do funcionario
@param cPerAponta, string, Periodo de apontamento
@return nulo
*/
user function geraVer0(cFilFunc, cMatFunc, cPerAponta, cCcFunc, cGrupoApv, dLimite)
	local dIniPer	 := stod( left(  cPerAponta, 8) )
	local dFimPer	 := stod( right( cPerAponta, 8) )
	local cOrdem 	 := '00'

	default cFilFunc	:= ""
	default cMatFunc	:= ""
	default cPerAponta	:= ""
	default cCcFunc		:= ""
	default cGrupoApv	:= ""
	default dLimite		:= ctod("//")

	//Valido os parametros
	if !empty( cPerAponta ) .and. len( cPerAponta ) >= 16 .and. !empty(cFilFunc) .and. !empty(cMatFunc) .and. !empty(cCcFunc) .and. !empty(cGrupoApv)

		//Garanto que tera 1 PB7 para todos os dias no periodo
		dIniPer	:= stod( left(  cPerAponta, 8) ) //Data inicial do periodo
		dFimPer	:= stod( right( cPerAponta, 8) ) //Data final do periodo
		dFimPer	:= iif( dFimPer > dLimite, dLimite ,dFimPer) 
		cOrdem 	:= '00' //Ordem inicial da PB7

		//Posiciona na ordem 1 da PB7
		PB7->(dbSetOrder(1))

		//Enquanto não for o ultimo dia do periodo faça:
		while dIniPer <= dFimPer
			cOrdem := soma1( cOrdem )//Adiciona +1 na ordem
			//Senão existir PB7 para o dia pesquisado cria registro
			if !PB7->( dbSeek( cFilFunc+cMatFunc+dtos( dIniPer ) ) )
				RecLock('PB7', .T.) //Incluir registro na PB7
				PB7->PB7_FILIAL := cFilFunc
				PB7->PB7_MAT 	:= cMatFunc
				PB7->PB7_DATA 	:= dIniPer
				PB7->PB7_VERSAO := 0
				PB7->PB7_ORDEM  := cOrdem
				PB7->PB7_PAPONT := cPerAponta //String de Data com o Periodo de Apontamento
				PB7->PB7_CC		:= cCcFunc
				PB7->PB7_GRPAPV := cGrupoApv
				PB7->( MsUnLock() )
			endif
			dIniPer++
		end
	endif
return

/*
{Protheus.doc} getCCGrupo
Pega dados do participante
@type function
@author Bruno Nunes
@since 13/08/2019
@version 2.01
@param cFilFunc, string, Filial do funcionario
@param cMatFunc, string, Matricula do funcionario
@param cCcFunc, string, Centro de custo do funcionario
@param cGrupoApv, string, Grupo de aprovacao do funcionario
@return nulo
*/
static function getCCGrupo(cFilFunc, cMatFunc, cCcFunc, cGrupoApv)
	local cAlias 	 := getNextAlias()
	local nRec 		 := 0
	local cQuery 	 := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local lRetorno   := .F.

	default := cFilFunc
	default := cMatFunc
	default := cCcFunc
	default := cGrupoApv

	//Valido os parametros
	if !empty(cFilFunc) .and. !empty(cMatFunc)
		//Pesquiso dados para gerar PB7 zerada
		cQuery := u_fGrpApv(cFilFunc,cMatFunc)
		if U_MontarSQ(cAlias, @nRec, cQuery, lExeChange, lTotaliza )
			//Garanto que tera 1 PB7 para todos os dias no periodo
			cCcFunc   := (calias)->RA_CC   //Centro de custo do funcionario
			cGrupoApv := (calias)->RD0_GRPAPV  //Grupo de aprovadores do funcionario
			lRetorno  := .T. //Retorna que achou dados
			(calias)->(dbCloseArea())
		endif
	endif
return lRetorno

static function delVerAnt(cFilFunc, cMatFunc, dMarc, nVersao)
	local cChave := ""
	local i := 0

	default cFilFunc := ""
	default cMatFunc := ""
	default dMarc := ""
	default nVersao := ""

	if empty(cFilFunc) .or.  empty(cMatFunc) .or. empty(dMarc) .or.  nVersao <= 1
		return
	endif

	for i := 0 to nVersao-1
		cChave := cFilFunc+cMatFunc+dtos( dMarc)+str( i,3,0 )
		PB7->( dbSetOrder(1) )
		if PB7->(dbSeek( cChave ) )
			recLock("PB7",.F.)
			PB7->(dbDelete())
			PB7->( msUnlock() )
		endif
	next i
return

static function atuPBB(lAprovRH)
	local cChavePBB := PB7->(xFilial("PBB")+PB7_FILIAL+PB7_MAT+DTOS(PB7_DATA))
	local lAprovAtr := .F.
	local lAprovHe  := .F.
	local cStaAprv := ""
	local cStaIgnN := ""
	local cStaIgnP := ""
	local cAprRep := ""
	local cStaAtr := ""
	local cStaHe := ""
	local lProcessa := .F.
	local cAtrAnt := ""
	local cAtrHe := ""

	default lAprovRH := .F.

	PBB->(dbSetOrder(2))
	if PBB->( dbSeek( cChavePBB ) )
		while PBB->(!EoF()) .and. cChavePBB == PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON))
			lProcessa := .T.
			lAprovAtr := !empty( PB7->PB7_HRNEGE ) .and. PB7->PB7_HRNEGV > 0
			lAprovHe  := !empty( PB7->PB7_HRPOSE ) .and. PB7->PB7_HRPOSV > 0

			cStaAprv := iif( lAprovRH			, "5"		, "2" )
			cStaIgnN := iif( lAprovAtr			, iif( PBB->PBB_STATUS == "3", iif(lAprovAtr, "3","5"), cStaAprv) 	,   iif(lAprovRH, "5", "6") )
			cStaIgnP := iif( lAprovHe			, iif( PBB->PBB_STATUS == "3", iif(lAprovHe , "3","5"), cStaAprv)	,   iif(lAprovRH, "5", "6") )
			cAprRep  := iif( PBB->PBB_STATUS == "3"	, "3/4"		, "" )
			cStaAtr  := iif( lAprovAtr .and. !(PBB->PBB_STAATR $ cAprRep+cStaAprv), cStaAprv, cStaIgnN )
			cStaHe   := iif( lAprovHe  .and. !(PBB->PBB_STAHE  $ cAprRep+cStaAprv), cStaAprv, cStaIgnP )

			PB7->PB7_STATUS := iif( !lAprovAtr .and. !lAprovHe, iif( lAprovRH, "5", "6" ), cStaAprv  )
			if PBB->PBB_STATUS == "3"
				PB7->PB7_STAATR := cStaAtr
				PB7->PB7_STAHE  := cStaHe
			else
				PB7->PB7_STAATR := iif(PB7->PB7_STAATR == "3", iif(lAprovAtr, "3","5"),  iif(!empty(cAtrAnt), cAtrAnt, cStaAtr))
				PB7->PB7_STAHE  := iif(PB7->PB7_STAHE  == "3", iif(lAprovHe , "3","5"),  iif(!empty(cAtrHe ), cAtrHe , cStaHe))
			endif

			conout("Status atualizados...: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
			if PBB->PBB_STATUS == "1"
				conout( "Nao aprovado.....: " + posicione("RD0", 1, xFilial("RD0")+PBB->PBB_APROV , "RD0_NOME" ) )
			endif
			conout("	PB7 Status ......: " + PB7->PB7_STATUS)
			conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
			conout("	PB7 Status He....: " + PB7->PB7_STAHE)	
			conout("	PBB Status Atraso: " + PBB->PBB_STAATR)
			conout("	PBB Status He....: " + PBB->PBB_STAHE)

			cChvPBBAnt := PBB->(PBB_FILIAL+PBB_FILMAT+PBB_MAT)
			cAtrAnt:= PBB->PBB_STAATR
			cStaHe := PBB->PBB_STAHE
			PBB->(dbSkip())
		end
		aprovFinal(PB7->PB7_FILIAL, PB7->PB7_MAT, PB7->PB7_DATA)
	endif
return lProcessa

static function aprovFinal(cFilFunc, cFuncMat, dApon)
	local calias := getNextAlias()
	local nRec := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza := .F.
	local lProcessado := .F.


	default cFuncFil := ""
	default cFuncMat := ""
	default dApon := ctod("//")	

	if empty(cFilFunc) .or. empty(cFuncMat) .or. empty(dApon)
		return lProcessado
	endif 



	cQuery := " SELECT "
	cQuery += " COUNT(*) QTD "
	cQuery += " FROM "
	cQuery += " "+RetSqlName("PBB")+" PBB "
	cQuery += " WHERE "
	cQuery += " PBB.D_E_L_E_T_ = ' ' "
	cQuery += " AND PBB.PBB_STATUS IN ('1','2') "
	cQuery += " AND PBB.PBB_FILMAT = '"+cFilFunc+"' "
	cQuery += " AND PBB.PBB_MAT	   = '"+cFuncMat+"' "
	cQuery += " AND PBB.PBB_DTAPON = '"+DTOS(dApon)+"' "

	if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
		if (calias)->QTD == 0


			lProcessado := .T.
			if PB7->PB7_STATUS != "5"
				PB7->PB7_STATUS := "7"
			endif

			conout("Status calculado.....: " + PB7->PB7_FILIAL+" | "+PB7->PB7_MAT+" | "+DTOC(PB7->PB7_DATA)+" | "+cvalToChar(PB7->PB7_VERSAO))
			conout("	PB7 Status ......: " + PB7->PB7_STATUS)
			conout("	PB7 Status Atraso: " + PB7->PB7_STAATR)
			conout("	PB7 Status He....: " + PB7->PB7_STAHE)	
			conout("	PBB Status Atraso: " + PBB->PBB_STAATR)
			conout("	PBB Status He....: " + PBB->PBB_STAHE)

		endif

		(calias)->(dbCloseArea())
	endif
return lProcessado

static function regra99(cFilFunc, cMatFunc)
	local aAreaSRA := SRA->(GetArea())
	local lRegra99 := .F.

	lRegra99 := posicione("SRA", 1, cFilFunc+cMatFunc,"RA_REGRA" ) == "99" 		

	restArea( aAreaSRA )	
return

/*
{Protheus.doc} LoadPB8
Carraga marcacoes do portal do periodo do funcionario
@Param @aMarc - Array que carregara marcacoes do ponto
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param cPerAponta - Periodo de apontamento
@Param cIdLog - complemento do nome do arquivo do log
@Return Boolean - .T. carregou marcacoes, .F. Nao carregou marcacoes
@author Bruno Nunes
@since 09/01/2020
@version 2.01
*/
user Function LoadPB8(aMarc, cFilFunc, cMatFunc, cPerAponta, cIdLog)
	local cAfast	  := ""
	local calias 	  := GetNextalias() 	// alias resevardo para consulta SQL
	local cDataExt    := ""
	local cQuery 	  := "" 				//Consulta SQL
	//local dLimite     := u_ponDLimL()
	local dDateMarc   := ctod('  /  /  ')
	local lExeChange  := .T. 			//Executa o change Query
	local lTotaliza   := .F.
	local lRetorno 	  := .F. 			//Retorno da funcao - .T. Carregou tabela, .F. - Não carregou tabela
	local nRec 		  := 0 				//Numero Total de Registros da consulta SQL

	default aMarc		:= {}
	default cFilFunc	:= ""
	default cMatFunc	:= ""
	default cPerAponta  := MontaPApon("", cIdLog)
	default cIdLog      := ""

	//Verifica parametros passados
	if !Empty(cFilFunc) .and. !Empty(cMatFunc)
		//Monta qurey do participantes
		cQuery := QryPB8Ver(cFilFunc, cMatFunc, , cPerAponta)
		CONOUT( cQuery )
		//Executa consultar
		if U_MontarSQ(calias, @nRec, cQuery, lExeChange, lTotaliza )
			aMarc := {}
			while (calias)->(!Eof())
				aAux := {}
				dDateMarc := DtoC(StoD((calias)->PB8_DATA))
				//Não carregar data que não foi lida pelo portal
				//if dLimite < StoD((calias)->PB8_DATA)
				//	(calias)->(dbSkip())
				//	loop
				//endif

				if !empty(aLLTRIM(Capital((calias)->AFASTAMENTO)))
					cAfast := Alltrim( Capital((calias)->AFASTAMENTO) )
				elseif !empty( (calias)->PB8_ALTERH )
					cAfast := 'Justificado pelo RH'
				else
					cAfast := ''
				endif
				cDataExt  := (calias)->PB8_DATA
				cDataExt  := substr(cDataExt, 7, 2)+'/'+substr(cDataExt, 5, 2)+'/'+substr(cDataExt, 1, 4) +" - " + DiaSemana( StoD((calias)->PB8_DATA) , 3 )

				aAdd(aAux, Encode64((calias)->(PB8_FILIAL+','+PB8_MAT+','+PB8_DATA+','+cValToChar(PB8_VERSAO)))) //1 - Id do registro em base 64
				aAdd(aAux, (calias)->PB8_FILIAL	) //2 - filial
				aAdd(aAux, (calias)->PB8_MAT 	) //3 - matricula
				aAdd(aAux, dDateMarc        	) //4 - data
				aAdd(aAux, alltrim((calias)->PB8_1E) 	) //5 - 1E
				aAdd(aAux, alltrim((calias)->PB8_1S) 	) //6 - 1S
				aAdd(aAux, alltrim((calias)->PB8_2E) 	) //7 - 2E
				aAdd(aAux, alltrim((calias)->PB8_2S) 	) //8 - 2S
				aAdd(aAux, alltrim((calias)->PB8_3E) 	) //9 - 3E
				aAdd(aAux, alltrim((calias)->PB8_3S) 	) //10 - 3S
				aAdd(aAux, alltrim((calias)->PB8_4E) 	) //11 - 4E
				aAdd(aAux, alltrim((calias)->PB8_4S) 	) //12 - 4S
				aAdd(aAux, replace(STRZERO((calias)->PB8_HRPOSV, 5, 2), '.', ':') ) //13 - horaPos valor
				aAdd(aAux, Capital((calias)->PB8_HRPOSE )) //14 - hora positiva evento
				aAdd(aAux, alltrim(Capital( FwCutOff( (calias)->PB8_HRPOSJ, .T. )))) //15 - hora positiva evento
				aAdd(aAux, replace(STRZERO((calias)->PB8_HRNEGV, 5, 2), '.', ':') ) //16 - horaPos valor
				aAdd(aAux, Capital((calias)->PB8_HRNEGE	)) //17 - hora negativa evento
				aAdd(aAux, alltrim(Capital( FwCutOff( (calias)->PB8_HRNEGJ, .T.	)))) //18 - hora negativa evento
				aAdd(aAux, (calias)->PB8_VERSAO ) //19 - Versao
				aAdd(aAux, (calias)->PB8_STATUS) //20 - Status
				aAdd(aAux, cValToChar((calias)->PB8_1ECAHR))
				aAdd(aAux, (calias)->PB8_1ECATP)
				aAdd(aAux, cValToChar((calias)->PB8_1SCAHR))
				aAdd(aAux, (calias)->PB8_1SCATP)
				aAdd(aAux, cValToChar((calias)->PB8_2ECAHR))
				aAdd(aAux, (calias)->PB8_2ECATP)
				aAdd(aAux, cValToChar((calias)->PB8_2SCAHR))
				aAdd(aAux, (calias)->PB8_2SCATP)
				aAdd(aAux, cValToChar((calias)->PB8_3ECAHR))
				aAdd(aAux, (calias)->PB8_3ECATP)
				aAdd(aAux, cValToChar((calias)->PB8_3SCAHR))
				aAdd(aAux, (calias)->PB8_3SCATP)
				aAdd(aAux, cValToChar((calias)->PB8_4ECAHR))
				aAdd(aAux, (calias)->PB8_4ECATP)
				aAdd(aAux, cValToChar((calias)->PB8_4SCAHR))
				aAdd(aAux, (calias)->PB8_4SCATP)
				aAdd(aAux, cDataExt) //20 - Data por extenso
				aAdd(aAux, (calias)->PB8_ORDEM 	 ) //
				aAdd(aAux, (calias)->PB8_APONTA  ) //
				aAdd(aAux, (calias)->PB8_PAPONT ) //
				aAdd(aAux, alltrim((calias)->PB8_TURNO 	 )) //
				aAdd(aAux, (calias)->PB8_JUSMAR)
				aAdd(aAux, (calias)->PB8_1ECMAN)
				aAdd(aAux, (calias)->PB8_1SCMAN)
				aAdd(aAux, (calias)->PB8_2ECMAN)
				aAdd(aAux, (calias)->PB8_2SCMAN)
				aAdd(aAux, (calias)->PB8_3ECMAN)
				aAdd(aAux, (calias)->PB8_3SCMAN)
				aAdd(aAux, (calias)->PB8_4ECMAN)
				aAdd(aAux, (calias)->PB8_4SCMAN)
				aAdd(aAux, Capital((calias)->DESCEVEPOS))
				aAdd(aAux, Capital((calias)->DESCEVENEG))
				aAdd(aAux, cAfast )
				aAdd(aAux, (calias)->PB8_1ECMAN )
				aAdd(aAux, (calias)->PB8_1SCMAN )
				aAdd(aAux, (calias)->PB8_2ECMAN )
				aAdd(aAux, (calias)->PB8_2SCMAN )
				aAdd(aAux, (calias)->PB8_3ECMAN )
				aAdd(aAux, (calias)->PB8_3SCMAN )
				aAdd(aAux, (calias)->PB8_4ECMAN )
				aAdd(aAux, (calias)->PB8_4SCMAN )
				aAdd(aAux, (calias)->PB8_STAATR )
				aAdd(aAux, (calias)->PB8_STAHE  )

				aAdd(aMarc, aAux)
				(calias)->(dbSkip())
			end
			(calias)->(dbCloseArea())
			lRetorno := .T.
		endif
	endif
Return(lRetorno)

/*
{Protheus.doc} QryPB8Ver
Monta string SQL com dados da tabela de marcacoes do ponto
@Param cFilFunc - Filial do funcionario
@Param cMatFunc - Matricula do funcionario
@Param aMarc - Array que carregara marcacoes do ponto
@Param cPerAponta - Periodo de apontamento
@Return String - String SQL
@author Bruno Nunes
@since 12/07/2016
@version 2.01
*/
Static Function QryPB8Ver(cFilFunc, cMatFunc, aMarc, cPerAponta)
	local cData 	 := ""
	local cPerApoAux := ""
	local cRetorno 	 := ""
	local nLinha 	 := 1

	default cFilFunc   := ""
	default cMatFunc   := ""
	default aMarc 	   := {}
	default cPerAponta := ""

	if len(aMarc) > 0
		cData += "AND PB8_DATA IN ("
		for nLinha := 1 to len(aMarc)
			iif (nLinha != 1, cData += ", ", nil)
			cData += "'"+dtos(aMarc[nLinha][1])+"'"
		next nLinha
		cData += ")"
	endif

	if !empty(cPerAponta)
		cPerApoAux := "  AND PB8_PAPONT = '" + cPerAponta + "'"
	endif

	cRetorno := " SELECT  "
	cRetorno += " PB8.PB8_FILIAL "
	cRetorno += " , PB8.PB8_MAT  "
	cRetorno += " , PB8.PB8_DATA "
	cRetorno += " , PB8.PB8_1E   "
	cRetorno += " , PB8.PB8_1S 	 "
	cRetorno += " , PB8.PB8_2E 	 "
	cRetorno += " , PB8.PB8_2S 	 "
	cRetorno += " , PB8.PB8_3E 	 "
	cRetorno += " , PB8.PB8_3S 	 "
	cRetorno += " , PB8.PB8_4E 	 "
	cRetorno += " , PB8.PB8_4S 	 "
	cRetorno += " , PB8.PB8_HRPOSV "
	cRetorno += " , PB8.PB8_HRPOSE "
	cRetorno += " , PB8.PB8_HRPOSJ "
	cRetorno += " , PB8.PB8_HRNEGV "
	cRetorno += " , PB8.PB8_HRNEGE "
	cRetorno += " , PB8.PB8_HRNEGJ "
	cRetorno += " , PB8.PB8_VERSAO "
	cRetorno += " , PB8.PB8_1ECAHR "
	cRetorno += " , PB8.PB8_1ECATP "
	cRetorno += " , PB8.PB8_1SCAHR "
	cRetorno += " , PB8.PB8_1SCATP "
	cRetorno += " , PB8.PB8_2ECAHR "
	cRetorno += " , PB8.PB8_2ECATP "
	cRetorno += " , PB8.PB8_2SCAHR "
	cRetorno += " , PB8.PB8_2SCATP "
	cRetorno += " , PB8.PB8_3ECAHR "
	cRetorno += " , PB8.PB8_3ECATP "
	cRetorno += " , PB8.PB8_3SCAHR "
	cRetorno += " , PB8.PB8_3SCATP "
	cRetorno += " , PB8.PB8_4ECAHR "
	cRetorno += " , PB8.PB8_4ECATP "
	cRetorno += " , PB8.PB8_4SCAHR "
	cRetorno += " , PB8.PB8_4SCATP "
	cRetorno += " , PB8.PB8_ORDEM  "
	cRetorno += " , PB8.PB8_APONTA "
	cRetorno += " , PB8.PB8_PAPONT "
	cRetorno += " , PB8.PB8_TURNO  "
	cRetorno += " , PB8.PB8_JUSMAR "
	cRetorno += " , PB8.PB8_1ECMAN "
	cRetorno += " , PB8.PB8_1SCMAN "
	cRetorno += " , PB8.PB8_2ECMAN "
	cRetorno += " , PB8.PB8_2SCMAN "
	cRetorno += " , PB8.PB8_3ECMAN "
	cRetorno += " , PB8.PB8_3SCMAN "
	cRetorno += " , PB8.PB8_4ECMAN "
	cRetorno += " , PB8.PB8_4SCMAN "
	cRetorno += " , SP9.P9_DPORTAL DESCEVEPOS "
	cRetorno += " , SP6.P6_DPORTAL DESCEVENEG "
	cRetorno += " , PB8.PB8_STATUS "
	cRetorno += " , isnull(RCM.RCM_DESCRI, '')  AFASTAMENTO "
	cRetorno += " , PB8.PB8_STAATR "
	cRetorno += " , PB8.PB8_STAHE  "
	cRetorno += " , PB8.PB8_AFASTA "
	cRetorno += " , PB8.PB8_ALTERH "
	//cRetorno += " , PB8.PB8_DALTRH "
	//cRetorno += " , PB8.PB8_HALTRH "
	cRetorno += " , PB8.PB8_CC "
	cRetorno += " , PB8.PB8_GRPAPV "
	cRetorno += " FROM  ( "
	cRetorno += "        SELECT PB8_FILIAL "
	cRetorno += "             , PB8_MAT    "
	cRetorno += "             , PB8_DATA   "
	cRetorno += "             , MAX(PB8_VERSAO) VERSAO   "
	cRetorno += "        FROM  "+RetSqlName("PB8")+" "
	cRetorno += "        WHERE PB8_FILIAL = '" + cFilFunc + "'"
	cRetorno += "          AND PB8_MAT    = '" + cMatFunc + "'"
	cRetorno += "          "+cPerApoAux+" "
	cRetorno += "          "+cData+" "
	cRetorno += "          AND D_E_L_E_T_ = ' ' "
	cRetorno += "        GROUP BY PB8_FILIAL, PB8_MAT, PB8_DATA "
	cRetorno += "       ) PB8FIL "
	cRetorno += " INNER JOIN "+RetSqlName("PB8")+" PB8 ON PB8FIL.PB8_FILIAL = PB8.PB8_FILIAL "
	cRetorno += "                                    AND  PB8FIL.PB8_MAT    = PB8.PB8_MAT    "
	cRetorno += "                                    AND  PB8FIL.PB8_DATA   = PB8.PB8_DATA   "
	cRetorno += "                                    AND  PB8FIL.VERSAO     = PB8.PB8_VERSAO "
	cRetorno += "                                    AND PB8.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SP9")+" SP9 ON PB8.PB8_HRPOSE = P9_CODIGO AND SP9.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SP6")+" SP6 ON PB8.PB8_HRNEGE = P6_CODIGO AND SP6.D_E_L_E_T_ = ' ' "
	cRetorno += " LEFT  JOIN "+RetSqlName("SR8")+" SR8 ON SR8.D_E_L_E_T_ = ' ' "
	cRetorno += "                                     AND SR8.R8_FILIAL = PB8.PB8_FILIAL "
	cRetorno += "                                     AND SR8.R8_MAT    = PB8.PB8_MAT "
	cRetorno += "                                     AND PB8.PB8_DATA  BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM "
	cRetorno += " LEFT  JOIN "+RetSqlName("RCM")+" RCM ON RCM.D_E_L_E_T_ = ' ' "
	cRetorno += "                                     AND RCM.RCM_TIPO   = SR8.R8_TIPOAFA "
	cRetorno += " GROUP BY "
	cRetorno += " PB8.PB8_FILIAL "
	cRetorno += " , PB8.PB8_MAT  "
	cRetorno += " , PB8.PB8_DATA "
	cRetorno += " , PB8.PB8_1E   "
	cRetorno += " , PB8.PB8_1S 	 "
	cRetorno += " , PB8.PB8_2E 	 "
	cRetorno += " , PB8.PB8_2S 	 "
	cRetorno += " , PB8.PB8_3E 	 "
	cRetorno += " , PB8.PB8_3S 	 "
	cRetorno += " , PB8.PB8_4E 	 "
	cRetorno += " , PB8.PB8_4S 	 "
	cRetorno += " , PB8.PB8_HRPOSV "
	cRetorno += " , PB8.PB8_HRPOSE "
	cRetorno += " , PB8.PB8_HRPOSJ "
	cRetorno += " , PB8.PB8_HRNEGV "
	cRetorno += " , PB8.PB8_HRNEGE "
	cRetorno += " , PB8.PB8_HRNEGJ "
	cRetorno += " , PB8.PB8_VERSAO "
	cRetorno += " , PB8.PB8_1ECAHR "
	cRetorno += " , PB8.PB8_1ECATP "
	cRetorno += " , PB8.PB8_1SCAHR "
	cRetorno += " , PB8.PB8_1SCATP "
	cRetorno += " , PB8.PB8_2ECAHR "
	cRetorno += " , PB8.PB8_2ECATP "
	cRetorno += " , PB8.PB8_2SCAHR "
	cRetorno += " , PB8.PB8_2SCATP "
	cRetorno += " , PB8.PB8_3ECAHR "
	cRetorno += " , PB8.PB8_3ECATP "
	cRetorno += " , PB8.PB8_3SCAHR "
	cRetorno += " , PB8.PB8_3SCATP "
	cRetorno += " , PB8.PB8_4ECAHR "
	cRetorno += " , PB8.PB8_4ECATP "
	cRetorno += " , PB8.PB8_4SCAHR "
	cRetorno += " , PB8.PB8_4SCATP "
	cRetorno += " , PB8.PB8_ORDEM  "
	cRetorno += " , PB8.PB8_APONTA "
	cRetorno += " , PB8.PB8_PAPONT "
	cRetorno += " , PB8.PB8_TURNO  "
	cRetorno += " , PB8.PB8_JUSMAR "
	cRetorno += " , PB8.PB8_1ECMAN "
	cRetorno += " , PB8.PB8_1SCMAN "
	cRetorno += " , PB8.PB8_2ECMAN "
	cRetorno += " , PB8.PB8_2SCMAN "
	cRetorno += " , PB8.PB8_3ECMAN "
	cRetorno += " , PB8.PB8_3SCMAN "
	cRetorno += " , PB8.PB8_4ECMAN "
	cRetorno += " , PB8.PB8_4SCMAN "
	cRetorno += " , SP9.P9_DPORTAL "
	cRetorno += " , SP6.P6_DPORTAL "
	cRetorno += " , PB8.PB8_STATUS "
	cRetorno += " , isnull(RCM.RCM_DESCRI, '')  "
	cRetorno += " , PB8.PB8_STAATR "
	cRetorno += " , PB8.PB8_STAHE "
	cRetorno += " , PB8.PB8_AFASTA "
	cRetorno += " , PB8.PB8_ALTERH "
	//cRetorno += " , PB8.PB8_DALTRH "
	//cRetorno += " , PB8.PB8_HALTRH "
	cRetorno += " , PB8.PB8_CC "
	cRetorno += " , PB8.PB8_GRPAPV "
	cRetorno += " ORDER BY PB8.PB8_DATA "
Return(cRetorno)

user function perFecha( cPeriodo )
	local lFechado 	:= .F.
	local cQuery 	:= ""
	local calias 	:= getNextAlias()
	local nRec 		:= 0 
	local lExeChange:= .T.
	local lTotaliza := .F.

	default cPeriodo := ""

	if !empty( cPeriodo )
		cQuery := " SELECT " 
		cQuery += " 	*  "
		cQuery += " FROM  "
		cQuery += " 	"+RetSqlName("SPO")+" SPO " 
		cQuery += " WHERE  "
		cQuery += " 	D_E_L_E_T_ = ' ' "
		cQuery += " 	AND PO_DATAINI = '" + left(  cPeriodo, 8 ) + "' "
		cQuery += " 	AND PO_DATAFIM = '" + right( cPeriodo, 8 ) + "' "
		cQuery += " 	AND PO_FLAGFEC = '0' "

		if u_montarSQ( calias, @nRec, cQuery, lExeChange, lTotaliza )
			lFechado 	:= .T.
			(calias)->(dbCloseArea())
		endif
	endif
return lFechado