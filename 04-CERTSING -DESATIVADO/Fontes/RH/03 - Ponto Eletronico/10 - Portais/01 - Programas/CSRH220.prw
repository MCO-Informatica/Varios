#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE cABA_AREA 		"BH - Funcionário"
#DEFINE cABA_DIR_SIN 	"BH - Diretoria"
#DEFINE cABA_SIN_AREA 	"BH - Area"
#DEFINE cTABELA_GERAL 	"Relatório de Custo de Banco de Horas - "
#DEFINE cDIRETOR 		"989/1286/1149/1222/1257/990/1148/1219"
#DEFINE nENCARGOS 		1.64
#DEFINE cSEM_DIRETORIA 	"Sem Diretoria"

user function CSRH220()
	local aParam     := {}

	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "07"

	aAdd( aParam, "\web\pp\ponto_eletronico\relatorios\grupo\diretoria\custoBH.xml")//1 - arquivo
	aAdd( aParam, "" )			//2 - cGrupo
	aAdd( aParam, "" ) 			//3 - cc
	aAdd( aParam, "" ) 			//4 - filial
	aAdd( aParam, "" ) 			//5 - matricula
	aAdd( aParam, .T. ) 		//6 - envia para diretoria

	if dow( DATE() ) == 6  
		proc220( aParam )
	endif

	RESET ENVIRONMENT
return

user function CSRH221( idParticipante, cGrupo, cCC, cColaborador )
	local aLista   := {}
	local aProp    := {"nomeArquivo", "status"}
	local aFunc    := {}
	local aLinha   := {}
	local aParam   := {}
	local cRetorno := ""
	local cArquivo := ""
	local cFilMat  := ""
	local cMat     := ""
	local i 	   := 0
	local nomeArq  := ""
	local cPasta   := ""

	if !empty( idParticipante ) .and. ( !empty( cGrupo ) .and. !empty( cCC )  .and. !empty( cColaborador ) )
		cPasta := "\web\pp\ponto_eletronico\relatorios\"+idParticipante+"\"
		U_CriarDir( cPasta )
		nomeArq := "bh_custo_"+dtos(dDataBase)+"_"+replace(time(),":","_")+".xml"
		cArquivo := cPasta+nomeArq
		aLinha := StrTokArr( cColaborador, "," )
		if len(aLinha) > 0
			for i := 1 to len(aLinha)
				aFunc   := StrTokArr( aLinha[i], "-" )
				if !empty(cFilMat)
					cFilMat += ","
				endif
				if !empty(cMat)
					cMat += ","
				endif

				cFilMat += "'"+aFunc[1]+"'"
				cMat 	+= "'"+aFunc[2]+"'"
			next i
		endif

		aAdd( aParam, cArquivo )
		aAdd( aParam, cGrupo )
		aAdd( aParam, cCC )
		aAdd( aParam, cFilMat )
		aAdd( aParam, cMat )
		aAdd( aParam, .F. )

		if proc220( aParam )
			aAdd( aLista, {nomeArq, "ok"} )
			delRelat( cPasta )
		else
			aAdd( aLista, {nomeArq, "erro"} )
		endif
	endif
	U_json( @cRetorno, aLista, aProp, "relatorio" )
return cRetorno

//Chamada via menu - 30/04/20 - Marco - primainfo
user function CSRH222()
	local aParam     := {}
	Local cFileName := "custoBH_"+dtos(date())+ SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xml"
	Local cPath       := AllTrim( GetTempPath() )
	aAdd( aParam, cPath+cFileName)//1 - arquivo
	aAdd( aParam, "" )			//2 - cGrupo
	aAdd( aParam, "" ) 			//3 - cc
	aAdd( aParam, "" ) 			//4 - filial
	aAdd( aParam, "" ) 			//5 - matricula
	aAdd( aParam, .F. ) 		//6 - envia para diretoria

	MsgRun("Gerando Dados para Planilha","Aguarde...",{|| proc220( aParam ) }) //" Preparando Arquivos para o Proximo Mes "###"Aguarde..."

return

/*/{Protheus.doc} proc220
Extrato de banco de horas Certisign. Gera em CSV uma lista dos banco de horas ordenado por pelas negativas,
depois horas positivas ordenada por ordem de valorização - 55%, 75%, 100%.
Opção de Extrato, Composição de acumulado, Acumulado e todos.
@type function
@author BrunoNunes
@since 04/04/2018
@version P12 1.12.17
@return null, Nulo
/*/
static Function proc220( aParam )
	local aAberto 	 := {}
	local aFechado 	 := {}
	local aDados     := {}
	local aLstDirAre := {}
	local aLstAreSin := {}
	local aLstDirSin := {}
	local cTitulo    := ""
	local cAnexo 	 := ""
	local lEmail 	 := .F.
	local lProcessou := .F.

	private oFWMsExcel := nil

	if len( aParam ) == 0
		conout("## Relatorio de Custo BH - sem parametros")
		return .F.
	endif
	lEmail := aParam[6]

	if u_CSRH134( aParam, @aAberto, @aFechado )
		if len(aAberto) > 0 .or. len(aFechado) > 0
			aDados := aglutinaBH(aAberto, aFechado, @cTitulo)
			oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá gerar o conteúdo do Excel

			ajustaDado(aDados, @aLstDirAre, @aLstAreSin, @aLstDirSin ) //Ajusta dados para gerar o Excel

			cabDiret( cTitulo ) //Gera cabecalho Geral
			montarLin( aLstDirSin, cABA_DIR_SIN, cTABELA_GERAL+cTitulo ) //Gera dados no Excel

			cabSintAre( cTitulo ) //Gera cabecalho Geral
			montarLin( aLstAreSin, cABA_SIN_AREA, cTABELA_GERAL+cTitulo ) //Gera dados no Excel

			cabArea( cTitulo ) //Gera cabecalho Geral
			montarLin( aLstDirAre, cABA_AREA, cTABELA_GERAL+cTitulo ) //Gera dados no Excel

			//Grava Excel em arquivo fisico
			cAnexo := gravaExcel( aParam[1] )

			//Envia email
			if lEmail
				enviaMail( cAnexo )
			endif
			lProcessou := .T.
		endif
	endif
return lProcessou

static function cabSintAre(cTitulo)
	default cTitulo := ""

	//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
	oFWMsExcel:AddworkSheet( cABA_SIN_AREA )

	//Criando a Tabela
	//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oFWMsExcel:AddTable( cABA_SIN_AREA, cTABELA_GERAL+cTitulo )

	//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
	oFWMsExcel:AddColumn( cABA_SIN_AREA, cTABELA_GERAL+cTitulo, "Diretoria"			,1, /*nFormat*/, .F. ) //01
	oFWMsExcel:AddColumn( cABA_SIN_AREA, cTABELA_GERAL+cTitulo, "Departamento"		,1, /*nFormat*/, .F. ) //02
	oFWMsExcel:AddColumn( cABA_SIN_AREA, cTABELA_GERAL+cTitulo, "Horas"				,3, /*nFormat*/, .F. ) //08
	oFWMsExcel:AddColumn( cABA_SIN_AREA, cTABELA_GERAL+cTitulo, "Custo HE"			,3, /*nFormat*/, .F. ) //09
return

static function cabDiret( cTitulo )
	default cTitulo := ""

	//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
	oFWMsExcel:AddworkSheet( cABA_DIR_SIN )

	//Criando a Tabela
	//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oFWMsExcel:AddTable( cABA_DIR_SIN, cTABELA_GERAL+cTitulo )

	//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
	oFWMsExcel:AddColumn( cABA_DIR_SIN, cTABELA_GERAL+cTitulo, "Diretoria"	,1, /*nFormat*/, .F. ) //01
	oFWMsExcel:AddColumn( cABA_DIR_SIN, cTABELA_GERAL+cTitulo, "Horas"		,3, /*nFormat*/, .F. ) //02
	oFWMsExcel:AddColumn( cABA_DIR_SIN, cTABELA_GERAL+cTitulo, "Custo HE"	,3, /*nFormat*/, .F. ) //03
return

static function cabArea(cTitulo)
	default cTitulo := ""

	//FWMsExcel():AddWorkSheet(< cWorkSheet >)-> NIL
	oFWMsExcel:AddworkSheet( cABA_AREA )

	//Criando a Tabela
	//FWMsExcel():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oFWMsExcel:AddTable( cABA_AREA, cTABELA_GERAL+cTitulo )

	//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Diretoria"			,1, /*nFormat*/, .F. ) //01
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Departamento"		,1, /*nFormat*/, .F. ) //02
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Matricula"			,2, /*nFormat*/, .F. ) //03
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Nome"				,1, /*nFormat*/, .F. ) //04
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Cargo"				,1, /*nFormat*/, .F. ) //05
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Gestor Imediato"	,1, /*nFormat*/, .F. ) //06
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Períodos"			,2, /*nFormat*/, .F. ) //07
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Horas"				,3, /*nFormat*/, .F. ) //08
	oFWMsExcel:AddColumn( cABA_AREA, cTABELA_GERAL+cTitulo, "Custo HE"			,3, /*nFormat*/, .F. ) //09
return

/*/{Protheus.doc} montarLin
Monta linha no Excel
@param [ aLstAux ]	 , lista	, Lista do banco de horas por funcionario
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
Static Function montarLin( aLstAux, cSheet, cTable )
	local i := 0	//Variavel de iteração

	default aLstAux 	:= {}	//Lista de impressão
	default cSheet 	:= ''	//Nome da aba
	default cTable 	:= ''	//Nome da tabela

	for i := 1 to len( aLstAux )
		//Criando as Linhas... Enquanto não for fim da query
		oFWMsExcel:AddRow( cSheet, cTable, aLstAux[i] )
	next i
Return

/*/{Protheus.doc} gravaExcel
Executa integrção com Excel
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return null, Nulo
/*/
Static Function gravaExcel( cArquivo )
	local cRel := cArquivo

	default cArquivo := ""

	U_CriarDir( cRel )
	if file( cRel )
		fErase( cRel )
	endif

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile( cRel ) //Cria um arquivo no formato XML do MSExcel 2003 em diante

	//Abrindo o excel e abrindo o arquivo xml
	oFWMsExcel := MsExcel():New() 		//Abre uma nova conexão com Excel
	oFWMsExcel:WorkBooks:Open( cRel ) 	//Abre uma planilha
	oFWMsExcel:SetVisible( .T. ) 		//Visualiza a planilha
	oFWMsExcel:Destroy()				//Encerra o processo do gerenciador de tarefas

	FreeObj( oFWMsExcel )
Return cRel

static function ajustaDado( aDados, aLstDirAre, aLstAreSin, aLstDirSin )
	local aLstAux 	 := {}
	local aAux 	 	 := {}
	local aDiretoria := loadDireto()
	local cChaveSRA  := ""
	local cChaveSup  := ""
	local cFilMatSp	 := ""
	local cChaveSRJ  := ""
	local cCcAnt     := ""
	local cNomDirAnt := ""
	local cNomDir    := ""
	local cPeriodAnt := ""
	local i 		 := 0
	local nTotValCc  := 0
	local nTotValDir := 0
	local nTotValGer := 0
	local nTotHorCc  := 0
	local nTotHorDir := 0
	local nTotHorGer := 0
	local cNomeSup   :="" 

	default aDados     := {}
	default aLstDirAre := {}
	default aLstAreSin := {}
	default aLstDirSin := {}

	SRA->( dbSetOrder(1) )
	for i := 1 to len( aDados )
		cChaveSRA := aDados[i][1][1] + aDados[i][1][4]
		if SRA->( dbSeek( cChaveSRA ) )
			nQtdHora := calcTotHor( aDados[i] )
			if nQtdHora <= 0
				loop
			endif
			nValor := calcTotVal( aDados[i] )

			cChaveSup := SRA->RA_XCGEST
			cChaveSRJ := xFilial("SRJ")+SRA->RA_CODFUNC
			cNomDir   := findDireto( aDiretoria, allTrim( SRA->RA_CC ) )
			cFilMatSp := fChaveSup( cChaveSup )
			If Empty(cFilMatSp)
				cNomeSup := "Superior Imediato não cadastrado."
			Else
				cNomeSup := allTrim( capital( posicione("SRA", 1, cFilMatSp, "RA_NOME" ) ) )
			Endif

			aAux := {}

			aAdd( aAux, allTrim( cNomDir ) )
			aAdd( aAux, allTrim( aDados[i][1][3] ) )
			aAdd( aAux, allTrim( aDados[i][1][4] ) )
			aAdd( aAux, allTrim( aDados[i][1][5] ) )
			aAdd( aAux, allTrim( capital( posicione("SRJ", 1, cChaveSRJ				 , "RJ_DESC" ) ) ) )
			aAdd( aAux, cNomeSup )
			aAdd( aAux, allTrim( aDados[i][1][9] ) )
			aAdd( aAux, nQtdHora )
			aAdd( aAux, nValor )
			aAdd( aAux, allTrim( aDados[i][1][10] ) )

			aAdd( aLstAux, aAux )
		endif
	next i

	aSort(aLstAux, , , {|x, y| x[1] + x[2] + x[4] + x[10] < y[1] + y[2]+ y[4] + y[10] })

	for i := 1 to len( aLstAux )
		if i == 1
			cCcAnt     := aLstAux[i][2]
			cNomDirAnt := aLstAux[i][1]
		endif

		if !( aLstAux[i][2] == cCcAnt )
			arrayAreSi( @aLstAreSin, cNomDirAnt, cCcAnt, fHHMM( nTotHorCc, .F. ), transform( nTotValCc, "@E 999,999,999.99") )

			arrayArea( @aLstDirAre, "", "Total "+cCcAnt, "", "", "", "", "", fHHMM( nTotHorCc, .F. ), transform( nTotValCc, "@E 999,999,999.99") )
			if aLstAux[i][1] == cNomDirAnt
				arrayArea( @aLstDirAre, "", "", "", "", "", "", "", "", "" )
			endif
			nTotHorCc := 0
			nTotValCc := 0
		endif
		if !( aLstAux[i][1] == cNomDirAnt )
			arrayArea( @aLstDirAre, "Total "+cNomDirAnt, "", "", "", "", "", "", fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )
			arrayArea( @aLstDirAre, "", "", "", "", "", "", "", "", "")

			arrayAreSi( @aLstAreSin, "Total "+cNomDirAnt, "", fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )
			arrayAreSi( @aLstAreSin, "", "", "", "")

			arrayDirSi( @aLstDirSin, cNomDirAnt, fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )

			nTotHorDir := 0
			nTotValDir := 0
		endif

		arrayArea(  @aLstDirAre, aLstAux[i][1], aLstAux[i][2], aLstAux[i][3], aLstAux[i][4], aLstAux[i][5], aLstAux[i][6], aLstAux[i][7], fHHMM( aLstAux[i][8], .F. ), transform( aLstAux[i][9], "@E 999,999,999.99") )

		nTotHorCc  := __TimeSum( nTotHorCc , aLstAux[i][8] )
		nTotHorDir := __TimeSum( nTotHorDir, aLstAux[i][8] )
		nTotHorGer := __TimeSum( nTotHorGer, aLstAux[i][8] )
		nTotValCc  += aLstAux[i][9]
		nTotValDir += aLstAux[i][9]
		nTotValGer += aLstAux[i][9]
		cCcAnt     := aLstAux[i][2]
		cNomDirAnt := aLstAux[i][1]
		cPeriodAnt := aLstAux[i][7]
	next i
	if len( aLstAux ) > 0
		arrayAreSi( @aLstAreSin, cNomDirAnt, cCcAnt, fHHMM( nTotHorCc, .F. ), transform( nTotValCc, "@E 999,999,999.99") )

		arrayArea( @aLstDirAre, "", "Total "+cCcAnt    , "", "", "", "", "", fHHMM( nTotHorCc , .F. ), transform( nTotValCc , "@E 999,999,999.99") )
		arrayArea( @aLstDirAre, "Total "+cNomDirAnt, "", "", "", "", "", "", fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )
		arrayArea( @aLstDirAre, "Total ", "", "", "", "", "", "", fHHMM( nTotHorGer, .F. ), transform( nTotValGer, "@E 999,999,999.99") )

		arrayAreSi( @aLstAreSin, "Total "+cNomDirAnt, "", fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )
		arrayAreSi( @aLstAreSin, "", "", "", "")

		arrayDirSi( @aLstDirSin, cNomDirAnt, fHHMM( nTotHorDir, .F. ), transform( nTotValDir, "@E 999,999,999.99") )
		arrayDirSi( @aLstDirSin, "Total"   , fHHMM( nTotHorGer, .F. ), transform( nTotValGer, "@E 999,999,999.99") )
	endif
return

/*/{Protheus.doc} findDireto
Carrega lista de cargos do superiores
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
/*
static function findDireto( cChaveSRA )
	default cChaveSRA := ""

	if empty(cChaveSRA)
		return cSEM_DIRETORIA
	endif

	SRA->(dbSetOrder(1))
	if SRA->( dbSeek( cChaveSRA ) )
		if allTrim( SRA->RA_CODFUNC ) $ cDIRETOR
			return capital( SRA->RA_NOME )
		endif

		if empty( SRA->RA_XCGEST )
			return cSEM_DIRETORIA
		else
			return findDireto( fChaveSup( SRA->RA_XCGEST ) )
		endif
	endif
return cSEM_DIRETORIA
*/
static function fChaveSup( cMat )
	local cQuery 	 := "" 	//Consulta SQL
	local cRetorno   := ""
	local cAlias 	 := getNextAlias() 	// alias resevardo para consulta SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	default cMat := ""

	cQuery := " SELECT "
	cQuery += " 	RA_FILIAL || RA_MAT CHAVE "
	cQuery += " FROM
	cQuery += " 	"+RetSQLName("SRA")+" SRA "
	cQuery += " WHERE "
	cQuery += " 	SRA.D_E_L_E_T_ = ' '"
	cQuery += " 	AND RA_MAT = '"+cMat+"' "
	cQuery += " 	AND RA_DEMISSA = '' "

	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		cRetorno := (cAlias)->CHAVE
		(cAlias)->(dbCloseArea())
	endif
return cRetorno


/*/{Protheus.doc} findDireto
Carrega lista de cargos do superiores
@type function
@author Renato Bernardo
@since 17/03/2015
@version P12 1.12.17
@return null, Nulo
/*/
static function findDireto( aDiretoria, cCC )
	local cDiretoria := ""
	local nPos := 0

	default cCC := ""

	if empty(cCC) .and. len(aDiretoria) == 0
		return cSEM_DIRETORIA
	endif

	nPos := aScan(aDiretoria, {|x| cCC $ x[2]})
	if nPos > 0
		cDiretoria := aDiretoria[nPos][1]
	else
		cDiretoria := cSEM_DIRETORIA
	endif
return cDiretoria

static function calcTotHor( aHoras )
	local i := 0
	local nTotal := 0

	default aHoras := {}

	for i := 1 to len( aHoras )
		nTotal := __TimeSum( nTotal, aHoras[i][8] )
	next i
return nTotal


static function calcTotVal( aValor )
	local nTotal 	:= 0
	local i 		:= 0
	local nPerHE 	:= 0
	local nHoraSex 	:= 0
	local nHoraDec 	:= 0
	local nSalHor	:= 0

	default aValor := {}

	for i := 1 to len( aValor )
		nPerHE   := findPerHE( aValor[i][6] )
 		nHoraSex := val( replace( aValor[i][8], ":", "." ) )
 		nHoraDec := fConvHr( nHoraSex, 'D' )
 		nSalHor  := findSalHor()
		nTotal   += ( ( ( nHoraDec * nPerHE )/100 ) * nSalHor ) * nENCARGOS //1.64
	next i
return nTotal

static function findPerHE( cEvento )
	local nPerc := 0

	default cEvento := ""

	SP9->(dbSetOrder(1))
	if SP9->(dbSeek(xFilial('SP9')+cEvento))
		SRV->( dbSetOrder(1) )
		if SRV->( dbSeek( xFilial('SRV')+SP9->P9_CODFOL ) )
			nPerc := SRV->RV_PERC
		endif
	endif
return nPerc

static function findSalHor()
	local nSalHora := 0
	nSalHora := SRA->RA_SALARIO / SRA->RA_HRSMES
return nSalHora

/*/{Protheus.doc} fHHMM
Formata o campo hora no formato -HH:MM
@param [ nVal   		] , numerico, Hora a ser analisada
@param [ lTotNegativo 	] , logico	, Verdareiro, adiciona o sinal de negativo no retorno da função
@type function
@author BrunoNunes
@since 19/01/2018
@version P12 1.12.17
@return númerico, nRetorno - quantidade de espaços para montar mascará -HHH:MM
/*/
Static Function fHHMM( nVal, lTotNegativo )
	local cRetorno := ""	//Quantidade de zero a esquerda
	local nTamanho := len( cValToChar( int( nVal ) ) ) //Quantidade de casas do número inteiro
	local nSinal   := iif( lTotNegativo, 1, 0 )	//Sinal do número

	if nTamanho == 0 .Or. nTamanho == 1 .Or. nTamanho == 2
		nTamanho := 5+nSinal
	else
		nTamanho := nTamanho+3
	endif

	cRetorno := replace( StrZero( nVal, nTamanho, 2), '.', ':' )
Return cRetorno

static function arrayArea( aLinha, cNmDiretor, cCc, cMatFunc, cNomeFunc, cCargo, cSupImed, cHora, cValor, cPeriodo )
	local aAux := {}

	default aLinha 		:= {}
	default cNmDiretor 	:= ""
	default cCc 		:= ""
	default cMatFunc 	:= ""
	default cNomeFunc 	:= ""
	default cCargo 		:= ""
	default cSupImed 	:= ""
	default cHora 		:= ""
	default cValor 		:= ""
	default cPeriodo    := ""

	aAdd( aAux, cNmDiretor ) //01
	aAdd( aAux, cCc 	   ) //02
	aAdd( aAux, cMatFunc   ) //03
	aAdd( aAux, cNomeFunc  ) //04
	aAdd( aAux, cCargo     ) //05
	aAdd( aAux, cSupImed   ) //06
	aAdd( aAux, cHora 	   ) //07
	aAdd( aAux, cValor 	   ) //08
	aAdd( aAux, cPeriodo   ) //09

	aAdd( aLinha, aAux )
return

static function arrayDirSi( aLinha, cNmDiretor, cHora, cValor )
	local aAux := {}

	default aLinha 		:= {}
	default cNmDiretor 	:= ""
	default cHora 		:= ""
	default cValor 		:= ""

	aAdd( aAux, cNmDiretor ) //01
	aAdd( aAux, cHora 	   ) //02
	aAdd( aAux, cValor 	   ) //03

	aAdd( aLinha, aAux )
return

static function arrayAreSi( aLinha, cNmDiretor, cCc, cHora, cValor )
	local aAux := {}

	default aLinha 		:= {}
	default cNmDiretor 	:= ""
	default cCc 	    := ""
	default cHora 		:= ""
	default cValor 		:= ""

	aAdd( aAux, cNmDiretor ) //01
	aAdd( aAux, cCc 	   ) //02
	aAdd( aAux, cHora 	   ) //03
	aAdd( aAux, cValor 	   ) //04

	aAdd( aLinha, aAux )
return

static function loadDireto()
	local aDiretoria := {}
	local cDiretoria := ""
	local cDiretNome := ""
	local cDiretAnt  := ""
	local cCc 		 := "/"

	dbSelectArea("PBC")
	PBC->(dbSetOrder(1))
	cDiretAnt  := PBC->PBC_CODIGO
	while PBC->(!EoF())
		cDiretoria := PBC->PBC_CODIGO
		if cDiretoria != cDiretAnt
			cDiretNome := posicione("SX5", 1, xFilial("SX5")+"X7"+cDiretAnt, "SX5->X5_DESCRI" )
			aAdd( aDiretoria, { cDiretNome, cCc } )
			cCc := "/"
		endif
		cCc += PBC->PBC_CC+"/"
		cDiretAnt  := PBC->PBC_CODIGO
		PBC->(dbSkip())
	end

	if !empty( cCc )
		aAdd( aDiretoria, { cDiretNome, cCc } )
	endif

	//atualizado 25/10/2019
	/*
	aAdd( aDiretoria, { "Diretoria de Assuntos Instituicionais", "/050104D/010140A/010140B/" } )
	aAdd( aDiretoria, { "Diretoria de Canais e Negócios Corporativos", "/050104C/050104B/" } )
	aAdd( aDiretoria, { "Diretoria de Marketing", "/050104E/070103A/070103B/070103C/070103E/070103F/070103G/" } )
	aAdd( aDiretoria, { "Diretoria Financeira"  , "/040202B/040202C/040202D/040202E/040202F/040202A/060205B/040202G/060205C/060205E/070105C/040203E/040203C/" } )
	aAdd( aDiretoria, { "Unidade Administrativa", "/091102A/010102B/030106C/030106B/040207B/040207C/040207D/040207E/031102C/030102H/031102D/030102B/030102F/030102G/030106D/031102E/" } )
	aAdd( aDiretoria, { "Unidade de Negócios Certificação Digital", +;
							"/030107B/060211B/050106E/050106C/091101A/091101B/010130A/060206C/060206D/060206E"+;
							"/060206F/060206G/060206H/060206I/060206J/060206K/060206O/060206P/060204B/060204E"+;
							"/060204I/060204H/070104C/060204D/060202B/060202C/060202D/060202E/060202F/060202G"+;
							"/010130B/060209H/060209I/060209B/060209E/060212D/060213C/060213D/060213F/030102E"+;
							"/060207B/060207C/060207U/060207V/061207E/061207H/061207I/060203B/070102B/070102C"+;
							"/070102E/060204C/060208B/080203H/080203F/080203B/080203C/080203E/080203G/080203D"+;
							"/010130D/010130E/030102I/030102J/030107E/030107G/030107I/030107J/030107K/030107L"+;
							"/030107M/050104A/050104I/050104J/050104K/050104L/050104M/060203C/060206B/060206S"+;
							"/060207E/060207Y/061206E/061206F/061207C/061207D/061207F/061207G/" } )
	aAdd( aDiretoria, { "Vice-Presidência Executiva", "/030101A/" } )
	*/
return aDiretoria

static function aglutinaBH( aAberto, aFechado, cTitulo )
	local aRetorno 	 := {}
	local aPeriodo 	 := {}
	local aFunc 	 := {}
	local aAux 		 := {}
	local cPeriodAnt := ""
	local i 		 := 0
	local j 		 := 0
	local cBaixaPrev := ""

	default aAberto  := {}
	default aFechado := {}
	default cTitulo  := ""

	cPeriodAnt := perAberto(@cBaixaPrev)
	cTitulo :=  cPeriodAnt
	for i := 1 to len(aAberto)
		aFunc := aAberto[i]
		for j := 1 to len(aFunc)
			aAux := {}
			aAdd( aAux, aFunc[j][01] )
			aAdd( aAux, aFunc[j][02] )
			aAdd( aAux, aFunc[j][03] )
			aAdd( aAux, aFunc[j][04] )
			aAdd( aAux, aFunc[j][05] )
			aAdd( aAux, aFunc[j][06] )
			aAdd( aAux, aFunc[j][07] )
			aAdd( aAux, aFunc[j][08] )
			aAdd( aAux, cPeriodAnt )
			aAdd( aAux, cBaixaPrev )

			aAdd( aPeriodo, aAux )
		next j
		if len(aPeriodo) > 0
			aAdd( aRetorno, aPeriodo )
			aPeriodo := {}
		endif
	next i

	for i := 1 to len(aFechado)
		aFunc := aFechado[i]
		cPeriodAnt := aFunc[1][10] //primeiro registro carga
		for j := 1 to len(aFunc)
			if !(cPeriodAnt == aFunc[j][10])
				aAdd( aRetorno, aPeriodo )
				aPeriodo := {}
			endif

			aAux := {}
			aAdd( aAux, aFunc[j][01] )
			aAdd( aAux, aFunc[j][02] )
			aAdd( aAux, aFunc[j][03] )
			aAdd( aAux, aFunc[j][04] )
			aAdd( aAux, aFunc[j][05] )
			aAdd( aAux, aFunc[j][06] )
			aAdd( aAux, aFunc[j][07] )
			aAdd( aAux, aFunc[j][08] )
			aAdd( aAux, aFunc[j][10] )
			aAdd( aAux, dtos( aFunc[j][11] ) )

			aAdd( aPeriodo, aAux )

			cPeriodAnt := aFunc[j][10]
		next j
		if len(aPeriodo) > 0
			aAdd( aRetorno, aPeriodo )
			aPeriodo := {}
		endif
	next i
return aRetorno

static function perAberto(cBaixaPrev)
	local cAlias := getNextAlias()
	local nRec   := 0
	local cQuery := ""
	local lExeChange := .T.
	local lTotaliza  := .F.
	local cRetorno := ""

	default cBaixaPrev := ""

	cQuery := " SELECT "
	cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 03, 08 ) DTINI, "
	cQuery += " 	SUBSTRING(RCC.RCC_CONTEU, 11, 08 ) DTFIM "
	cQuery += " FROM "
	cQuery += " 	"+RetSqlName("RCC")+" RCC,"
	cQuery += " WHERE "
	cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RCC.RCC_CODIGO = 'U00A' "
	cQuery += " 	AND SUBSTRING( RCC.RCC_CONTEU, 19, 1 ) = '1' " //Periodo de Banco de Horas Aberto
	cQuery += " 	AND SUBSTRING( RCC.RCC_CONTEU, 20, 1 ) = '1' " //Periodo de Banco de Horas e nao rescisao

	if u_montarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza ) 	//Caso a consulta retorno registro faça:
		cRetorno := dtoc(stod( (cAlias)->DTINI)) + " as " + dtoc(stod( (cAlias)->DTFIM))
		cBaixaPrev := (cAlias)->DTFIM
		(cAlias)->(dbCloseArea())
	endif

return cRetorno

//Envia email
static function enviaMail( cAnexo )
	local cHtml    := ""
 	local cTitulo  := "Relatório Semanal de Prévia do Banco de Horas."
 	local cMsgHTML := "Você está recebendo o relatório semanal da prévia do banco de horas para em conjunto com sua liderança controlar a "+;
 					  "realização de horas extras e planejar a redução do saldo existente."+CRLF+;
 					  "Em casos de dúvidas estamos a disposição para os esclarecimentos necessários."+CRLF+CRLF+;
 					  "Atenciosamente,"+CRLF+CRLF+;
 					  "Luciano Cardoso - Adm. De Pessoal."+CRLF
 	//local cEmail   := superGetMv( "MV_RH220ML", .F., "sistemascorporativos@certisign.com.br" )
 	 //Local cEmail   := "sistemascorporativos@certisign.com.br"
	 Local cEmail	 += f_Emails()


	default cAnexo := ""

	//Inicia construcao do html
	cHtml += '<!DOCTYPE HTML>'
	cHtml += '<html>'
	cHtml += '	<head>'
	cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	cHtml += '	</head>'
	cHtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	cHtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" align="center">'
	cHtml += '				<table width="627">'
	cHtml += '					<tr>'
	cHtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<h2>'
	cHtml += '								<span style="color:#FE5000" ><strong>'+cTitulo+'</strong></span>'
	cHtml += '								<br />'
	cHtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	cHtml += '							</h2>'
	cHtml += '						</td>'
	cHtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	cHtml += '				<p align="left">'
	cHtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	cHtml += '				</p>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '	</table>'
	cHtml += '	</body>'
	cHtml += '</html>'

	//1 - destinatario
	//2 - assunto
	//3 - html
	//4 - anexo (separados por ;
	fsSendMail( cEmail, cTitulo, cHtml, cAnexo )
	conout( "##Email enviado com sucesso" )
	conout( "##Titulo ......: " + cTitulo )
	conout( "##Destinatario : " + cEmail  )
return

static function delRelat( cPasta )
	local aDirectory := {}
	local i := 0
	default cPasta := ""

	if !empty( cPasta )
		aDirectory := Directory(cPasta+'\*.*')
		aSort(aDirectory, , , {|x, y| dtos(x[3])+replace(x[4],":","") > dtos(y[3])+replace(y[4],":","") })
		for i := 4 to len(aDirectory)
			if fErase( cPasta+aDirectory[i][1] ) == -1
				conout("##CSRH221 nao deletou arquivo Excel: "+cPasta+aDirectory[i][1])
			endif
		next i
	endif
return

Static Function f_Emails()

Local a_Area := GetArea()
Local c_Ret	 := ""

dbSelectArea("RCC")
dbSetOrder(1)
If dbSeek(xFilial("RCC")+"U00E")
	While !RCC->(Eof()) .And. RCC->RCC_CODIGO = "U00E"
		If Empty(c_Ret) 
			c_Ret := LOWER(Alltrim(RCC->RCC_CONTEU))
		Else
			c_Ret += ";" + LOWER(Alltrim(RCC->RCC_CONTEU))
		Endif
		RCC->(dbskip())
	Enddo
Endif

RestArea(a_Area)

Return(c_Ret)	 