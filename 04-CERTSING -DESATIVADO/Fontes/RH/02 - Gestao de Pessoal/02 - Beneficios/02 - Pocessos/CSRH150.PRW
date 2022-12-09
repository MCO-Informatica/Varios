#INCLUDE "protheus.ch"
#INCLUDE "BenefArq.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "fileio.ch"

#Define CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} CSRH150
INTEGRACAO DE BENEFICIOS COM EMPRESA SE SERVICOS

@author Bruno Nunes
@since 06/02/2013
@version 1.0
/*/
user function CSRH150()
	private cVBPerg   := "ARQBENEF"
	private lNovoCalc := NovoCalcBEN()

	if lNovoCalc
		cVBPerg := "BENFARQ"
	endif

	Pergunte(cVBPerg,.F.)

	TNewProcess():New("BENEFARQ", STR0001, {|oSelf| ProcessBnf(oSelf)}, STR0002, cVBPerg, NIL, NIL, NIL, NIL, .T., .T.) // "Exportacao dos arquivos de beneficios" - "Esta rotina processa e gera arquivo de beneficios para integracao"
	return
	//eu sei que esta errado, coloquei para burlar o compilador, não retirar
	//essa função é macro-executada, por isso aparece na mensagem do IDE 
	//funcao nunca u
	VBValida()
return

/*/{Protheus.doc} ProcessBnf
@since 06/02/2013
@version 1.0
/*/
Static function ProcessBnf(oProcess)
	local nCount
	local nOldSet   := SetVarNamelen(255)
	local aArea     := GetArea()
	local aItems    := {}

	private nTotal     := 0
	private nVlr       := 0
	private nHdl       := 0
	private nLin       := 0
	private cQryFech   := ""
	private cReprocess := iif( MV_PAR03 == 2, "1", "2" )  //*Reprocessamento - selecionar RG2_Pedido==2
	private lImpLis    := MV_PAR15 == 1 //Impressao Relatorio
	private nOrd       := MV_PAR16 //Ordem Relatorio
	private aItens	   := {}
	private cArqOut    := ""
	private lErrorImp  := .F.
	private aOrdem     := {}
	private cRGC_CIDADE := ""

	if lNovoCalc
		dbSelectArea( "SR0" )
	else
		dbSelectArea( "RG2" )
	endif
	dbSetOrder(1)

	aAdd(aItems, { STR0003, { || ProcINI( oProcess ) } } ) //"lEndo arquivo INI"

	//oProcess:SetRegua1( len( aItems ) ) //Total de elementos da regua
	oProcess:SaveLog( STR0004 ) //"Inicio de processamento"

	For nCount:= 1 to len( aItems )
		if ( oProcess:lEnd )
			Break
		endif

		//oProcess:IncRegua1( aItems[ nCount, 1 ] )
		Eval( aItems[ nCount, 2 ])
	Next

	SetVarNamelen( nOldSet )

	//Fecha Arquivo
	if nHdl > 0
		if !fClose( nHdl )
			MsgAlert( STR0005 ) //'Ocorreram problemas no fechamento do arquivo.'
		endif
	endif

	//Encerra o processamento
	if !oProcess:lEnd
		oProcess:SaveLog( STR0006 ) //"Fim do processamento"

		if lErrorImp
			fErase( cArqOut )
			Alert( STR0028 )  //"Existe dados inválidos. Verifique o Log de Processos desta rotina!"
		elseif nLin > 0
			Aviso(STR0007, STR0006, {STR0008}) //"Exportacao de arquivos de beneficios" - "Fim do processamento" - "Ok"

			//Imprime Listagem
			if lImpLis
				fImpLis()
			endif

			//Atualizacao do status do historico RG2 
			if cReprocess == "1"
				if lNovoCalc
					fAtuSR0()
				else
					fAtuRG2()
				endif
			endif
		else
			Aviso(STR0009, STR0010 ,{STR0008}) //"Aviso" - "Não existem registros a serem gravados." - "Ok"
		endif
	else
		nLin := 0
		Aviso(STR0007, STR0011 , {STR0008}) //"Exportacao de arquivos de beneficios" - "Processamento cancelado pelo usuario!" - "Ok"
		oProcess:SaveLog(STR0011)
	endif
	RestArea(aArea)
return .T.

/*/{Protheus.doc} ProcIni

@since 06/02/2013
@version 1.0
/*/
Static function ProcINI(oProcess)
	local cQuery    := ""
	local cPeriodo  := ""
	local cNumPag   := ""
	local cFilDe    := ""
	local cFilAte   := ""
	local cCcDe     := ""
	local cCcAte    := ""
	local cMatDe    := ""
	local cMatAte   := ""
	local cPedDe    := ""
	local cPedAte   := ""
	local cArqIni   := ""
	local cFuncVal  := ""
	local nCount    := 0
	local nPos      := 0
	local cMyChave  := ""
	local nAux      := 0
	local nTp		:= 0
	local aForn410  := {}
	local nLinha
	local cQryAux
	local aTemp		:= {}
	local cSelect	:= ""
	local cFrom		:= ""
	local i 		:= 0
	local nRec      := 0

	private cForn410   := {}
	private cCodCli    := ""
	private cSRA_end   := ""
	private cSRA_Num   := ""
	private cRGC_end   := ""
	private cRGC_Num   := ""
	private cItemCod   := ""
	private cItemNome  := ""
	private cValItem   := ""
	private nReg       := 0
	private nSeq       := 0
	private dCred      := cTod(" / / ")
	private aStruct    := {}
	private nTotReg    := 0	//-Qtd.Registros - no arquivo
	private nTotRegTP1 := 0	//-Qtd.Registros - Tipo 1
	private nTotRegTP2 := 0	//-Qtd.Registros - Tipo 2
	private nTotRegTP3 := 0	//-Qtd.Registros - Tipo 3
	private nTotRegTP4 := 0	//-Qtd.Registros - Tipo 4
	private nTotRegTP5 := 0	//-Qtd.Registros - Tipo 5
	private nQtdTotIte := 0
	private nvlrTotIte := 0
	private nPosend    := 0
	private nSeqend    := 0
	private aSeqend    := {}

	//Carrega Perguntas
	cFornecedor := MV_PAR01                     //Fornecedor selecionado
	cTiposSel   := MV_PAR02                     //Tipos Selecionados
	cPeriodo    := MV_PAR05                     //Periodo
	cNumPag     := MV_PAR06                     //Nro Pagamento
	cFilDe      := MV_PAR07                     //Da Filial
	cFilAte     := MV_PAR08                     //Ate a Filial
	cCcDe       := MV_PAR09                     //Do Centro Custo
	cCcAte      := MV_PAR10                     //Ate Centro de Custo
	cMatDe      := MV_PAR11                     //Da Matricula
	cMatAte     := MV_PAR12                     //Ate Matricula
	dCred       := MV_PAR13                     //Data Credito
	cAdm        := dToS(MV_PAR14)               //Consid.Admitido Ate
	if lNovoCalc
		cPedDe      := MV_PAR17                     //Do Pedido
		cPedAte     := MV_PAR18                     //Ate o Pedido
	endif

	//Verifica parametros
	if empty(cFornecedor)
		Alert(STR0051) //"Parâmetro sobre fornecedor não preenchido!"
		return
	endif
	if empty(cAdm)
		Alert(STR0052) //"Parâmetro sobre data de admissão não preenchido!"
		return
	endif
	if empty(cTiposSel)
		Alert(STR0053) //"Parâmetro sobre tipos de beneficio não preenchido!"
		return
	endif

	//Verifica se foi informado os Arquivos .INI e de Saida
	nLinha  := FPOSTAB("S018", Alltrim(cFornecedor), "==", 4)
	if empty( cArqIni := Alltrim(FTABELA("S018", nLinha, 08)) )
		Alert(STR0029) //"Arquivo .INI não informado na Tabela Auxiliar S018!"
		return
	endif
	if empty( cArqOut := Alltrim(FTABELA("S018", nLinha, 09)) )
		Alert(STR0030) //"Arquivo de Saída não informado na Tabela Auxiliar S018"
		return
	endif
	if empty( cFuncVal := Alltrim(FTABELA("S018", nLinha, 10)) )
		Alert(STR0031) //"Função de Validação não informada na Tabela Auxiliar S018"
		return
	else
		if At("(", cFuncVal ) > 0
			Alert(STR0056) //"Função validadora com caracter -()- invalido, na tabela S018"
			return
		endif   
	endif

	if !file( cArqIni )
		Alert(STR0047 +' - ' +cArqIni) //"Arquivo de inicialização não localizado: "
		return
	endif
	if File( cArqOut )
		if Aviso(STR0013 , cArqOut +" - " +STR0048 ,{STR0049,STR0050}) == 1  //"ATENCAO" - "Arquivo Já Existe. Sobrepor?" - "Não","Sim"
			return
		endif
	endif

	//Executa funcao padrao para processar arquivo INI
	aStruct := RHProcessaIni(cArqIni)
	/* Estrutura do array de retorno
	aStruct[1] - Header
	aStruct[2] - Detalhes
	aStruct[3] - Trailler

	aStruct[1][1][1] - Header / Primeiro Campo / (1 campo: tipo do registro header)
	aStruct[1][1][2] - Header / Primeiro Campo / (2 campo: descricao do campo)
	aStruct[1][1][3] - Header / Primeiro Campo / (3 campo: tipo do dado)
	aStruct[1][1][4] - Header / Primeiro Campo / (4 campo: tamanho do campo)
	aStruct[1][1][5] - Header / Primeiro Campo / (5 campo: decimais campo numerico)
	aStruct[1][1][6] - Header / Primeiro Campo / (6 campo: valor e conteudo  para o campo)
	*/

	//Cria Arquivo de saida
	nHdl := fCreate(cArqOut)
	if nHdl == -1
		MsgAlert(STR0012,STR0013) //'O arquivo não pode ser criado! Verifique os parametros.' - 'Atenção!'
		return
	endif

	//-------------------------------------------------------------------------------------//
	// Codigo 0 - Header do Arquivo					                                       //
	//-------------------------------------------------------------------------------------//
	nSeq += 1
	fWrite( nHdl, RHGeraLinhas( aStruct[1] ) )

	//-------------------------------------------------------------------------------------//
	// Codigo 1 - Empresas							                                       //
	//-------------------------------------------------------------------------------------//
	/*
	nTotRegTP1 := 1

	nSeq += 1
	fWrite( nHdl, RHGeraLinhas( aStruct[2], "01" ) )
	*/
	//-------------------------------------------------------------------------------------//
	// Codigo 2 - enderecos de Entrega				                                       //
	//-------------------------------------------------------------------------------------//
	nTotRegTP2 := 0

	//-Ajusta o conteudo da cTiposSel pra usar na Query
	cQryAux := ""
	cTiposSel := Alltrim(cTiposSel)
	For nTp := 1 to len(cTiposSel) Step 2
		cQryAux += "'"+SubStr(cTiposSel, nTp, 2)+"'"
		if (nTp + 2) < len(cTiposSel)
			cQryAux += ","
		endif
	Next nTp

	if lNovoCalc
		cSelect  := "SELECT DISTINCT RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_LOCBNF, RA_RGUF, RA_NUMendE,"
		cSelect  += " RA_endEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_ESTADO,RA_CEP,RA_TELEFON, "
		cSelect  += " RA_NASC,RA_CIC,RA_RG,RA_MAE,RA_EMAIL,RA_ESTCIVI,RA_SEXO,RA_PAI, R0_QDIACAL, R0_DUTILM, R0_FALTAS "

		cFrom  := " FROM " + RetSqlName("SR0") + " SR0 "
		cFrom  += " INNER JOIN " + RetSqlName("SRA") + " SRA "
		cFrom  += " ON SRA.RA_MAT = SR0.R0_MAT AND SRA.RA_FILIAL = SR0.R0_FILIAL "
		cFrom  += " WHERE "
		if TcSrvType() != "AS/400"
			cFrom += " SR0.D_E_L_E_T_ = ' ' AND SRA.D_E_L_E_T_ = ' ' "
		else
			cFrom += " SR0.@DELETED@ = ' ' AND SRA.@DELETED@ = ' ' "
		endif
		cFrom  += " AND RA_FILIAL >= '" + cFilDe + "' AND RA_FILIAL <= '" + cFilAte + "' "
		cFrom  += " AND RA_CC >= '" + cCcDe + "' AND RA_CC <= '" + cCcAte + "' "
		cFrom  += " AND RA_MAT >= '" + cMatDe + "' AND RA_MAT <= '" + cMatAte + "' "
		cFrom  += " AND RA_ADMISSA <= '" + cAdm + "' "
		cFrom  += " AND R0_TPBEN IN(" + cQryAux + ") "
		cFrom  += " AND R0_PEDIDO = '" + cReprocess +"'"
		cFrom  += " AND R0_PERIOD = '" + cPeriodo  +"'"
		cFrom  += " AND R0_NROPED >= '" + cPedDe + "' AND R0_NROPED <= '" + cPedAte + "' "
		cFrom  += " AND R0_VALCAL > 0"
		cFrom  += iif (!empty(cNumPag), " AND R0_NROPGT = '" + cNumPag + "' ", " ")

		if nOrd == 1
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		elseif nOrd == 2
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_CC "
		elseif nOrd == 3
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_NOME "
		else
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		endif
		cQryFech := cFrom
		cQuery  := cSelect + cFrom
	else
		cQuery  := "SELECT RG2.*, RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_LOCBNF, RA_RGUF, RA_NUMendE,"
		cQuery  += " RA_endEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_ESTADO,RA_CEP,RA_TELEFON,  "
		cQuery  += " RA_NASC,RA_CIC,RA_RG,RA_MAE,RA_EMAIL,RA_ESTCIVI,RA_SEXO,RA_PAI "
		cQuery  += " FROM " + RetSqlName("RG2") + " RG2 "
		cQuery  += " INNER JOIN " + RetSqlName("SRA") + " SRA "
		cQuery  += " ON SRA.RA_MAT = RG2.RG2_MAT AND SRA.RA_FILIAL = RG2.RG2_FILIAL "
		cQuery  += " WHERE "
		if TcSrvType() != "AS/400"
			cQuery += " RG2.D_E_L_E_T_ = ' ' AND SRA.D_E_L_E_T_ = ' ' "
		else
			cQuery += " RG2.@DELETED@ = ' ' AND SRA.@DELETED@ = ' ' "
		endif
		cQuery  += " AND RA_FILIAL >= '" + cFilDe + "' AND RA_FILIAL <= '" + cFilAte + "' "
		cQuery  += " AND RA_CC >= '" + cCcDe + "' AND RA_CC <= '" + cCcAte + "' "
		cQuery  += " AND RA_MAT >= '" + cMatDe + "' AND RA_MAT <= '" + cMatAte + "' "
		cQuery  += " AND RA_ADMISSA <= '" + cAdm + "' "
		cQuery  += " AND RG2_TPBEN IN(" + cQryAux + ") "
		cQuery  += " AND RG2_PEDIDO = " + cReprocess 
		cQuery  += " AND RG2_PERIOD = " + cPeriodo 
		cQuery  += iif (!empty(cNumPag), " AND RG2_NROPGT = " + cNumPag + " ", " ")

		if nOrd == 1
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		elseif nOrd == 2
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_CC "
		elseif nOrd == 3
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_NOME "
		else
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		endif
	endif

	//Verifica Tabela Aberta
	if Select("QD02VB") > 0
		dbSelectArea("QD02VB")
		DbCloseArea()
	endif

	//Abrir Tabela
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), "QD02VB", .T., .F.)
	QD02VB->(DbGoTop())

	nSeqend := 0
	aSeqend := {}
	cMyChave := ""
	while QD02VB->(!Eof())

		//-Gera apenas 1 linha por Loc.Entrega

		if QD02VB->(RA_FILIAL+RA_MAT) == cMyChave
			QD02VB->(dbSkip())
			Loop
		else
			cMyChave := QD02VB->(RA_FILIAL+RA_MAT)
		endif

		if QD02VB->(R0_DUTILM) == 0
			QD02VB->(dbSkip())
			Loop
		endif

		/*	
		dbSelectArea("RGC")
		dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
		dbSeek(xFilial("RGC")+QD02VB->RA_LOCBNF,.F.)
		*/

		dbSelectArea("RGC")
		RGC->(dbSetOrder(1))	
		RGC->(dbSeek(xFilial("RGC")+QD02VB->(RA_LOCBNF),.F.))

		//Separa Numero do endereco
		cRGC_end := RGC->(RGC_ENDER)
		cRGC_Num := RGC->(RGC_NUMERO) 

		//-Cria sequencia de enderecos
		//nSeqend += 1
		//aAdd(aSeqend, {QD02VB->RA_LOCBNF, nSeqend})

		nTotRegTP1 := 1

		nSeq += 1

		nPosend := aScan(aOrdem, {|x| x[1]==QD02VB->RA_LOCBNF+SPACE(8)+'01' })
		cRGC_CIDADE := Posicione("CC2",1,xFilial('CC2')+RGC->RGC_ESTADO+RGC->RGC_CODMUN,"CC2_MUN")
		//fWrite( nHdl, RHGeraLinhas( aStruct[2], "01" ) )
		if nPosend == 0
			aAdd( aOrdem, {QD02VB->RA_LOCBNF+SPACE(8)+'01', RHGeraLinhas( aStruct[2], "01" ) } )
		endif

		//Grava Detalhes
		nTotRegTP2 += 1
		nSeq += 1
		//fWrite( nHdl, RHGeraLinhas( aStruct[2], "02" ) )
		aAdd( aOrdem, {QD02VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'02', RHGeraLinhas( aStruct[2], "02" ) } )

		QD02VB->(dbSkip())
	enddo

	//-Ajusta o conteudo da cTiposSel pra usar na Query
	cQryAux := ""
	cTiposSel := Alltrim(cTiposSel)
	For nTp := 1 to len(cTiposSel) Step 2
		cQryAux += "'"+SubStr(cTiposSel, nTp, 2)+"'"
		if (nTp + 2) < len(cTiposSel)
			cQryAux += ","
		endif
	Next nTp

	//---------------------------------------------------------------------------------//
	// Codigo 3 - Funcionarios						                                                //
	//--------------------------------------------------------------------------------//
	nTotRegTP3 := 0
	if lNovoCalc
		cSelect  := "SELECT DISTINCT RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_LOCBNF, RA_RGUF, RA_NUMendE,"
		cSelect  += " RA_endEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_ESTADO,RA_CEP,RA_TELEFON, "
		cSelect  += " RA_NASC,RA_CIC,RA_RG,RA_MAE,RA_EMAIL,RA_ESTCIVI,RA_SEXO,RA_PAI, "
		cSelect  += " R0_QDIAINF, R0_DUTILM, R0_FALTAS "

		cFrom  := " FROM " + RetSqlName("SR0") + " SR0 "
		cFrom  += " INNER JOIN " + RetSqlName("SRA") + " SRA "
		cFrom  += " ON SRA.RA_MAT = SR0.R0_MAT AND SRA.RA_FILIAL = SR0.R0_FILIAL "
		cFrom  += " WHERE "
		if TcSrvType() != "AS/400"
			cFrom += " SR0.D_E_L_E_T_ = ' ' AND SRA.D_E_L_E_T_ = ' ' "
		else
			cFrom += " SR0.@DELETED@ = ' ' AND SRA.@DELETED@ = ' ' "
		endif
		cFrom  += " AND RA_FILIAL >= '" + cFilDe + "' AND RA_FILIAL <= '" + cFilAte + "' "
		cFrom  += " AND RA_CC >= '" + cCcDe + "' AND RA_CC <= '" + cCcAte + "' "
		cFrom  += " AND RA_MAT >= '" + cMatDe + "' AND RA_MAT <= '" + cMatAte + "' "
		cFrom  += " AND RA_ADMISSA <= '" + cAdm + "' "
		cFrom  += " AND R0_TPBEN IN(" + cQryAux + ") "
		cFrom  += " AND R0_PEDIDO = '" + cReprocess +"'"
		cFrom  += " AND R0_PERIOD = '" + cPeriodo  +"'"
		cFrom  += " AND R0_NROPED >= '" + cPedDe + "' AND R0_NROPED <= '" + cPedAte + "' "
		cFrom  += " AND R0_VALCAL > 0"
		cFrom  += iif (!empty(cNumPag), " AND R0_NROPGT = '" + cNumPag + "' ", " ")

		if nOrd == 1
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		elseif nOrd == 2
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_CC "
		elseif nOrd == 3
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_NOME "
		else
			cFrom  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		endif
		cQryFech := cFrom
		cQuery  := cSelect + cFrom
	else
		cQuery  := "SELECT RG2.*, RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_LOCBNF, RA_RGUF, RA_NUMendE,"
		cQuery  += " RA_endEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_ESTADO,RA_CEP,RA_TELEFON, "
		cQuery  += " RA_NASC,RA_CIC,RA_RG,RA_MAE,RA_EMAIL,RA_ESTCIVI,RA_SEXO,RA_PAI "
		cQuery  += " FROM " + RetSqlName("RG2") + " RG2 "
		cQuery  += " INNER JOIN " + RetSqlName("SRA") + " SRA "
		cQuery  += " ON SRA.RA_MAT = RG2.RG2_MAT AND SRA.RA_FILIAL = RG2.RG2_FILIAL "
		cQuery  += " WHERE "
		if TcSrvType() != "AS/400"
			cQuery += " RG2.D_E_L_E_T_ = ' ' AND SRA.D_E_L_E_T_ = ' ' "
		else
			cQuery += " RG2.@DELETED@ = ' ' AND SRA.@DELETED@ = ' ' "
		endif
		cQuery  += " AND RA_FILIAL >= '" + cFilDe + "' AND RA_FILIAL <= '" + cFilAte + "' "
		cQuery  += " AND RA_CC >= '" + cCcDe + "' AND RA_CC <= '" + cCcAte + "' "
		cQuery  += " AND RA_MAT >= '" + cMatDe + "' AND RA_MAT <= '" + cMatAte + "' "
		cQuery  += " AND RA_ADMISSA <= '" + cAdm + "' "
		cQuery  += " AND RG2_TPBEN IN(" + cQryAux + ") "
		cQuery  += " AND RG2_PEDIDO = " + cReprocess 
		cQuery  += " AND RG2_PERIOD = " + cPeriodo 
		cQuery  += iif (!empty(cNumPag), " AND RG2_NROPGT = " + cNumPag + " ", " ")

		if nOrd == 1
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		elseif nOrd == 2
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_CC "
		elseif nOrd == 3
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_NOME "
		else
			cQuery  += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "
		endif
	endif

	//Verifica Tabela Aberta
	if Select("QD03VB") > 0
		dbSelectArea("QD03VB")
		DbCloseArea()
	endif

	//Abrir Tabela
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), "QD03VB", .T., .F.)

	//Atualiza regua
	Count To nRec
	oProcess:SetRegua1( nRec )
	oProcess:IncRegua1("")
	QD03VB->(DbGoTop())

	//-Transforma campos em Numerico e/ou Data
	aSraStruct := SRA->(dbStruct())
	For nAux := 1 To len(aSraStruct)
		if ( aSraStruct[nAux][2] <> "C" )
			TcSetField("QD03VB",aSraStruct[nAux][1],aSraStruct[nAux][2],aSraStruct[nAux][3],aSraStruct[nAux][4])
		endif
	Next nAux
	QD03VB->(DbGoTop())

	cMyChave := ""
	nCount   := 0
	while QD03VB->(!Eof())

		//-Gera apenas 1 linha por funcionario
		if QD03VB->(RA_FILIAL+RA_MAT) == cMyChave
			QD03VB->(dbSkip())
			Loop
		else
			cMyChave := QD03VB->(RA_FILIAL+RA_MAT)
		endif

		if QD03VB->(R0_DUTILM) == 0
			QD03VB->(dbSkip())
			Loop
		endif

		//Separa Numero do endereco
		//Caso nao tenha sido possivel separar o numero do endereco
		//os conteudos serão preenchidos por serem obrigatorios no layout
		cSRA_end := ""
		cSRA_Num := ""
		if ( nPos := Rat(",", QD03VB->RA_endEREC ) ) > 0
			cSRA_end := Substr(QD03VB->RA_endEREC,1,nPos - 1)
			cSRA_Num := Substr(QD03VB->RA_endEREC,nPos + 1)
		endif
		if empty(cSRA_end)
			cSRA_end := QD03VB->RA_endEREC
			cSRA_Num := "0"
		endif

		//-Busca a Sequencia do endereco
		//-aAdd(aSeqend, {QD02VB->RA_LOCBNF, nSeqend})
		//nPosend := aScan(aSeqend, {|x| x[1]==QD03VB->RA_LOCBNF })
		//nSeqend := aSeqend[nPosend,02]
		if lNovoCalc

			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)

			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			oProcess:IncRegua1("Linha 3: "+Capital(QD03VB->RA_NOME))
			//--??fValidVB(oProcess, "QD03VB")
			bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
			EVal( bAux )

			//monta query dos itens
			cQuery  := "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN, SUM(R0_QDIACAL) AS R0_QDIACAL"
			cQuery  += ",SUM(R0_VALCAL) AS R0_VALCAL,MAX(R0_VLRVALE) AS R0_VLRVALE,SUM(R0_VLRFUNC) AS R0_VLRFUNC,SUM(R0_VLREMP) AS R0_VLREMP"
			cQuery  += ",SUM(R0_QDIAINF) R0_QDIAINF "
			cQuery  += " FROM " + RetSqlName("SR0") + " SR0 "
			cQuery  += " WHERE "
			if TcSrvType() != "AS/400"
				cQuery += " SR0.D_E_L_E_T_ = ' ' "
			else
				cQuery += " SR0.@DELETED@ = ' ' "
			endif
			cQuery  += " AND R0_FILIAL = '" + QD03VB->RA_FILIAL + "'"
			cQuery  += " AND R0_CC =  '" + QD03VB->RA_CC + "'"
			cQuery  += " AND R0_MAT =  '" + QD03VB->RA_MAT + "'"
			cQuery  += " AND R0_TPBEN IN(" + cQryAux + ") "
			cQuery  += " AND R0_PEDIDO = '" + cReprocess +"'"
			cQuery  += " AND R0_PERIOD = '" + cPeriodo  +"'"
			cQuery  += " AND R0_NROPED >= '" + cPedDe + "' AND R0_NROPED <= '" + cPedAte + "' "
			cQuery  += " AND R0_VALCAL > 0"
			cQuery  += iif (!empty(cNumPag), " AND R0_NROPGT = '" + cNumPag + "' ", " ")
			cQuery  += " GROUP BY R0_FILIAL,R0_MAT,R0_CODIGO ,R0_TPVALE,R0_TPBEN"
			cQuery  += " ORDER BY R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN"

			//Verifica Tabela Aberta
			if Select("QD05VB") > 0
				QD05VB->(DbCloseArea())
			endif

			//Abrir Tabela
			DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), "QD05VB", .T., .F.)
			while !QD05VB->(Eof())

				//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
				cItemCod  := ''
				cItemNome := ''

				if QD05VB->R0_TPVALE = "0"
					dbSelectArea("SRN")
					dbSetOrder(1)	//-RN_FILIAL+RN_COD
					dbSeek(QD05VB->R0_FILIAL+QD05VB->R0_CODIGO,.F.)

					//cItemCod  := RN_BNFFOR
					cItemCod  := strzero(val(RN_ITEMPED), 6)
					cItemNome := NOACENTO(RN_DESC)
					cValItem := cValToChar(RN_VUNIATU * 100)
				else
					dbSelectArea("RFO")
					dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
					dbSeek(xFilial("RFO")+QD05VB->R0_TPVALE+QD05VB->R0_CODIGO,.F.)

					cItemCod  := RFO_BNFFOR
					cItemNome := RFO_DESCR
				endif
				nPos := 0

				if val(cItemCod) > 0 
					nTotRegTP3 += 1
					nSeq += 1			
					//fWrite( nHdl, RHGeraLinhas( aStruct[2], "03" ) )
					aAdd( aOrdem, {QD03VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'03', RHGeraLinhas( aStruct[2], "03" ) } )

					nLin += 1	//-Indica que pode imprimir o Relatorio Final
				endif
				//Totaliza Registros
				nTotal += nVlr
				//IncProc("Processando...")	

				QD05VB->(dbSkip())
			enddo
		else
			//-Executa a Validacao dos Funcionarios ( 1x por funcionario )
			if QD03VB->(RA_FILIAL+RA_MAT) <> cMyChave
				oProcess:IncRegua1("Linha 3: "+Capital(QD03VB->RA_NOME))
				cMyChave := QD03VB->(RA_FILIAL+RA_MAT)

				//--??fValidVB(oProcess, "QD03VB")
				bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
				EVal( bAux )
			endif

			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)
			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
			cItemCod  := ''
			cItemNome := ''

			if QD03VB->RG2_TPVALE = "0"
				dbSelectArea("SRN")
				dbSetOrder(1)	//-RN_FILIAL+RN_COD
				dbSeek(xFilial("SRN")+QD03VB->RG2_CODIGO,.F.)

				//cItemCod  := RN_BNFFOR
				cItemCod  := strzero(val(RN_ITEMPED), 6)
				cItemNome := NOACENTO(RN_DESC)
				cValItem := cValToChar(RN_VUNIATU * 100)
			else
				dbSelectArea("RFO")
				dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
				dbSeek(xFilial("RFO")+QD03VB->RG2_TPVALE+QD03VB->RG2_CODIGO,.F.)\

				cItemCod  := RFO_BNFFOR
				cItemNome := RFO_DESCR
			endif

			if val(cItemCod) > 0 
				nTotRegTP3 += 1
				nSeq += 1			
				//fWrite( nHdl, RHGeraLinhas( aStruct[2], "03" ) )
				aAdd( aOrdem, {QD03VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'03', RHGeraLinhas( aStruct[2], "03" ) } )

				nLin += 1	//-Indica que pode imprimir o Relatorio Final
			endif
			//Totaliza Registros
			nTotal += nVlr
			//IncProc("Processando...")	
		endif
		//Grava Detalhes Funcionario
		QD03VB->(dbSkip())
	enddo

	//-------------------------------------------------------------------------------------//
	// Codigo 4 - Beneficiarios	dos Funcionarios	                                       //
	//-------------------------------------------------------------------------------------//
	//-- ==============================================================================
	//-- NAO EXISTE TRATAMENTO PARA ESTE TIPO DE BENEFICIARIO NO MICROSIGA PROTHEUS !!!
	//-- ==============================================================================
	//nTotRegTP4 := 0
	//nSeq += 1
	//fWrite( nHdl, RHGeraLinhas( aStruct[2], "04" ) )

	//-------------------------------------------------------------------------------------//
	// Codigo 5 - Insumos - Itens dos Funcionarios	                                       //
	//-------------------------------------------------------------------------------------//
	nTotRegTP5 := 0
	nQtdTotIte := 0
	nvlrTotIte := 0

	aForn410 := {}
	aAdd( aForn410, {"SE", "30"})
	aAdd( aForn410, {"PA", "26"})
	aAdd( aForn410, {"RR", "33"})
	aAdd( aForn410, {"DF", "11"})
	aAdd( aForn410, {"MS", "21"})
	aAdd( aForn410, {"MT", "22"})
	aAdd( aForn410, {"PR", "08"})
	aAdd( aForn410, {"SC", "23"})
	aAdd( aForn410, {"CE", "20"})
	aAdd( aForn410, {"GO", "06"})
	aAdd( aForn410, {"PB", "28"})
	aAdd( aForn410, {"AP", "35"})
	aAdd( aForn410, {"AL", "29"})
	aAdd( aForn410, {"AM", "25"})
	aAdd( aForn410, {"MG", "19"})
	aAdd( aForn410, {"RN", "18"})
	aAdd( aForn410, {"TO", "27"})
	aAdd( aForn410, {"RS", "09"})
	aAdd( aForn410, {"RO", "32"})
	aAdd( aForn410, {"PE", "13"})
	aAdd( aForn410, {"AC", "34"})
	aAdd( aForn410, {"RJ", "04"})
	aAdd( aForn410, {"ES", "07"})
	aAdd( aForn410, {"MA", "24"})
	aAdd( aForn410, {"SP", "01"})
	aAdd( aForn410, {"PI", "31"})

	aSort( aForn410,,,{ |x,y| x < y } )

	dbSelectArea("QD03VB")
	cMyChave := ""
	Count To nRec
	oProcess:SetRegua1( nRec )
	oProcess:IncRegua1("")
	QD03VB->(DbGoTop())
	
	while QD03VB->(!Eof())
		//-Gera apenas 1 linha por funcionario
		if QD03VB->(RA_FILIAL+RA_MAT) == cMyChave
			QD03VB->(dbSkip())
			Loop
		else
			cMyChave := QD03VB->(RA_FILIAL+RA_MAT)
		endif

		if QD03VB->(R0_DUTILM) == 0
			QD03VB->(dbSkip())
			Loop
		endif

		if lNovoCalc
			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)

			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			oProcess:IncRegua1("Linha : "+ Capital( QD03VB->RA_NOME ) )
			//--??fValidVB(oProcess, "QD03VB")
			bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
			EVal( bAux )

			//monta query dos itens
			cQuery  := "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN, SUM(R0_QDIACAL) AS R0_QDIACAL,SUM(R0_VALCAL) AS R0_VALCAL,MAX(R0_VLRVALE) AS R0_VLRVALE,SUM(R0_VLRFUNC) AS R0_VLRFUNC,SUM(R0_VLREMP) AS R0_VLREMP"
			cQuery  += " FROM " + RetSqlName("SR0") + " SR0 "
			cQuery  += " WHERE "
			if TcSrvType() != "AS/400"
				cQuery += " SR0.D_E_L_E_T_ = ' ' "
			else
				cQuery += " SR0.@DELETED@ = ' ' "
			endif
			cQuery  += " AND R0_FILIAL = '" + QD03VB->RA_FILIAL + "'"
			cQuery  += " AND R0_CC =  '" + QD03VB->RA_CC + "'"
			cQuery  += " AND R0_MAT =  '" + QD03VB->RA_MAT + "'"
			cQuery  += " AND R0_TPBEN IN(" + cQryAux + ") "
			cQuery  += " AND R0_PEDIDO = '" + cReprocess +"'"
			cQuery  += " AND R0_PERIOD = '" + cPeriodo  +"'"
			cQuery  += " AND R0_NROPED >= '" + cPedDe + "' AND R0_NROPED <= '" + cPedAte + "' "
			cQuery  += " AND R0_VALCAL > 0 " 
			cQuery  += iif (!empty(cNumPag), " AND R0_NROPGT = '" + cNumPag + "' ", " ")
			cQuery  += " GROUP BY R0_FILIAL,R0_MAT,R0_CODIGO ,R0_TPVALE,R0_TPBEN"
			cQuery  += " ORDER BY R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN"

			//Verifica Tabela Aberta
			if Select("QD05VB") > 0
				QD05VB->(DbCloseArea())
			endif

			//Abrir Tabela
			DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), "QD05VB", .T., .F.)

			aTemp := {}
			while !QD05VB->(Eof())
				//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
				cItemCod  := ''
				cItemNome := ''
				if QD05VB->R0_TPVALE = "0"
					dbSelectArea("SRN")
					dbSetOrder(1)	//-RN_FILIAL+RN_COD
					dbSeek(xFilial("SRN")+QD05VB->R0_CODIGO,.F.)

					cItemCod  := strzero(val(RN_ITEMPED), 6)
					cItemNome := NOACENTO(RN_DESC)
					cValItem := cValToChar(RN_VUNIATU * 100)
				else
					dbSelectArea("RFO")
					dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
					dbSeek(xFilial("RFO")+QD05VB->R0_TPVALE+QD05VB->R0_CODIGO,.F.)

					cItemCod  := RFO_BNFFOR
					cItemNome := RFO_DESCR
				endif
				nPos := 0
				if len(aTemp) != 0
					nPos := aScan(aTemp,{|x| x[1]==QD05VB->R0_TPBEN})
				endif
				if nPos == 0
					aAdd(aTemp,{QD05VB->R0_TPBEN,QD05VB->R0_VALCAL})
				else
					aTemp[nPos][2] := aTemp[nPos][2]  + QD05VB->R0_VALCAL
				endif
				//Totaliza Registros
				nTotal += nVlr

				QD05VB->(dbSkip())
			enddo

			nTotRegTP4 += 1
			nSeq += 1
			//fWrite( nHdl, RHGeraLinhas( aStruct[2], "04" ) )
			aAdd( aOrdem, {QD03VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'04', RHGeraLinhas( aStruct[2], "04" ) } )
			QD05VB->(DbCloseArea())
			aAdd(aItens,{QD03VB->RA_FILIAL+QD03VB->RA_MAT,aTemp})
		else
			//-Executa a Validacao dos Funcionarios ( 1x por funcionario )
			if QD03VB->(RA_FILIAL+RA_MAT) <> cMyChave
				oProcess:IncRegua1(Capital( QD03VB->RA_NOME ) )
				cMyChave := QD03VB->(RA_FILIAL+RA_MAT)

				//--??fValidVB(oProcess, "QD03VB")
				bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
				EVal( bAux )
			endif

			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)

			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
			cItemCod  := ''
			cItemNome := ''

			if QD03VB->RG2_TPVALE == "0"
				dbSelectArea("SRN")
				dbSetOrder(1)	//-RN_FILIAL+RN_COD
				dbSeek(xFilial("SRN")+QD03VB->RG2_CODIGO,.F.)

				cItemCod  := strzero(val(RN_ITEMPED), 6)
				cItemNome := NOACENTO(RN_DESC)
				cValItem := cValToChar(RN_VUNIATU * 100)
			else
				dbSelectArea("RFO")
				dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
				dbSeek(xFilial("RFO")+QD03VB->RG2_TPVALE+QD03VB->RG2_CODIGO,.F.)\

				cItemCod  := RFO_BNFFOR
				cItemNome := RFO_DESCR
			endif

			nTotRegTP4 += 1
			nSeq += 1
			//fWrite( nHdl, RHGeraLinhas( aStruct[2], "04" ) )
			aAdd( aOrdem, {QD03VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'04', RHGeraLinhas( aStruct[2], "04" ) } )

			//Totaliza Registros
			nTotal += nVlr
		endif	

		//IncProc("Processando...")
		QD03VB->(dbSkip())
	enddo

	//-------------------------------------------------------------------------------------//
	// Codigo 4 - Beneficiarios	dos Funcionarios	                                       //
	//-------------------------------------------------------------------------------------//
	//-- ==============================================================================
	//-- NAO EXISTE TRATAMENTO PARA ESTE TIPO DE BENEFICIARIO NO MICROSIGA PROTHEUS !!!
	//-- ==============================================================================
	//nTotRegTP4 := 0
	//nSeq += 1
	//fWrite( nHdl, RHGeraLinhas( aStruct[2], "04" ) )

	//-------------------------------------------------------------------------------------//
	// Codigo 5 - Insumos - Itens dos Funcionarios	                                       //
	//-------------------------------------------------------------------------------------//
	nTotRegTP5 := 0
	nQtdTotIte := 0
	nvlrTotIte := 0

	aForn410 := {}
	aAdd( aForn410, {"SE", "30"})
	aAdd( aForn410, {"PA", "26"})
	aAdd( aForn410, {"RR", "33"})
	aAdd( aForn410, {"DF", "11"})
	aAdd( aForn410, {"MS", "21"})
	aAdd( aForn410, {"MT", "22"})
	aAdd( aForn410, {"PR", "08"})
	aAdd( aForn410, {"SC", "23"})
	aAdd( aForn410, {"CE", "20"})
	aAdd( aForn410, {"GO", "06"})
	aAdd( aForn410, {"PB", "28"})
	aAdd( aForn410, {"AP", "35"})
	aAdd( aForn410, {"AL", "29"})
	aAdd( aForn410, {"AM", "25"})
	aAdd( aForn410, {"MG", "19"})
	aAdd( aForn410, {"RN", "18"})
	aAdd( aForn410, {"TO", "27"})
	aAdd( aForn410, {"RS", "09"})
	aAdd( aForn410, {"RO", "32"})
	aAdd( aForn410, {"PE", "13"})
	aAdd( aForn410, {"AC", "34"})
	aAdd( aForn410, {"RJ", "04"})
	aAdd( aForn410, {"ES", "07"})
	aAdd( aForn410, {"MA", "24"})
	aAdd( aForn410, {"SP", "01"})
	aAdd( aForn410, {"PI", "31"})

	aSort( aForn410,,,{ |x,y| x < y } )

	dbSelectArea("QD03VB")
	cMyChave := ""
	Count To nRec
	oProcess:SetRegua1( nRec )
	oProcess:IncRegua1("")
	QD03VB->(DbGoTop())
	while QD03VB->(!Eof())

		//-Gera apenas 1 linha por funcionario
		if QD03VB->(RA_FILIAL+RA_MAT) == cMyChave
			QD03VB->(dbSkip())
			Loop
		else
			cMyChave := QD03VB->(RA_FILIAL+RA_MAT)
		endif

		if QD03VB->(R0_DUTILM) == 0
			QD03VB->(dbSkip())
			Loop
		endif

		if lNovoCalc
			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)

			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			oProcess:IncRegua1( Capital( QD03VB->RA_NOME) )
			//--??fValidVB(oProcess, "QD03VB")
			bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
			EVal( bAux )

			//monta query dos itens
			cQuery  := "SELECT R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN, SUM(R0_QDIACAL) AS R0_QDIACAL,SUM(R0_VALCAL) AS R0_VALCAL,MAX(R0_VLRVALE) AS R0_VLRVALE,SUM(R0_VLRFUNC) AS R0_VLRFUNC,SUM(R0_VLREMP) AS R0_VLREMP"
			cQuery  += " FROM " + RetSqlName("SR0") + " SR0 "
			cQuery  += " WHERE "
			if TcSrvType() != "AS/400"
				cQuery += " SR0.D_E_L_E_T_ = ' ' "
			else
				cQuery += " SR0.@DELETED@ = ' ' "
			endif
			cQuery  += " AND R0_FILIAL = '" + QD03VB->RA_FILIAL + "'"
			cQuery  += " AND R0_CC =  '" + QD03VB->RA_CC + "'"
			cQuery  += " AND R0_MAT =  '" + QD03VB->RA_MAT + "'"
			cQuery  += " AND R0_TPBEN IN(" + cQryAux + ") "
			cQuery  += " AND R0_PEDIDO = '" + cReprocess +"'"
			cQuery  += " AND R0_PERIOD = '" + cPeriodo  +"'"
			cQuery  += " AND R0_NROPED >= '" + cPedDe + "' AND R0_NROPED <= '" + cPedAte + "' "
			cQuery  += " AND R0_VALCAL > 0 "
			cQuery  += iif (!empty(cNumPag), " AND R0_NROPGT = '" + cNumPag + "' ", " ")
			cQuery  += " GROUP BY R0_FILIAL,R0_MAT,R0_CODIGO ,R0_TPVALE,R0_TPBEN"
			cQuery  += " ORDER BY R0_FILIAL,R0_MAT,R0_CODIGO,R0_TPVALE,R0_TPBEN"

			//Verifica Tabela Aberta
			if Select("QD05VB") > 0
				QD05VB->(DbCloseArea())
			endif

			//Abrir Tabela
			DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), "QD05VB", .T., .F.)

			aTemp := {}
			while !QD05VB->(Eof())
				//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
				cItemCod  := ''
				cItemNome := ''

				if QD05VB->R0_TPVALE = "0"
					dbSelectArea("SRN")
					dbSetOrder(1)	//-RN_FILIAL+RN_COD
					dbSeek(xFilial("SRN")+QD05VB->R0_CODIGO,.F.)

					cItemCod  := strzero(val(RN_ITEMPED), 6)
					cItemNome := NOACENTO(RN_DESC)
					cValItem := cValToChar(RN_VUNIATU * 100)
				else
					dbSelectArea("RFO")
					dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
					dbSeek(xFilial("RFO")+QD05VB->R0_TPVALE+QD05VB->R0_CODIGO,.F.)

					cItemCod  := RFO_BNFFOR
					cItemNome := RFO_DESCR
				endif
				nPos := 0
				if len(aTemp) != 0
					nPos := aScan(aTemp,{|x| x[1]==QD05VB->R0_TPBEN})
				endif
				if nPos == 0
					aAdd(aTemp,{QD05VB->R0_TPBEN,QD05VB->R0_VALCAL})
				else
					aTemp[nPos][2] := aTemp[nPos][2]  + QD05VB->R0_VALCAL
				endif

				//Totaliza Registros
				nTotal += nVlr

				QD05VB->(dbSkip())
			enddo
			QD05VB->(DbCloseArea())
			aAdd(aItens,{QD03VB->RA_FILIAL+QD03VB->RA_MAT,aTemp})
		else
			//-Executa a Validacao dos Funcionarios ( 1x por funcionario )
			if QD03VB->(RA_FILIAL+RA_MAT) <> cMyChave
				oProcess:IncRegua1(Capital( QD03VB->RA_NOME ) )

				cMyChave := QD03VB->(RA_FILIAL+RA_MAT)

				//--??fValidVB(oProcess, "QD03VB")
				bAux := &( '{ || ' + Alltrim(cFuncVal) + '(oProcess, "QD03VB") } ' )
				EVal( bAux )
			endif

			//-Busca ESTADO do local de Entrega
			dbSelectArea("RGC")
			dbSetOrder(1)	//-RGC_FILIAL+RGC_KEYLOC
			dbSeek(xFilial("RGC")+QD03VB->RA_LOCBNF,.F.)

			if ( nPos := aScan(aForn410 , { |x| x[1] == RGC_ESTADO }) ) > 0
				cForn410 := aForn410[nPos, 2]
			else
				cForn410 := "0"
			endif

			//Posiciona o SRN / RFO para pegar o Cod.Beneficio do Fornecedor
			cItemCod  := ""
			cItemNome := ""

			if QD03VB->RG2_TPVALE = "0"
				dbSelectArea("SRN")
				dbSetOrder(1)	//-RN_FILIAL+RN_COD
				dbSeek(xFilial("SRN")+QD03VB->RG2_CODIGO,.F.)

				cItemCod  := strzero(val(RN_ITEMPED), 6)
				cItemNome := NOACENTO(RN_DESC)
				cValItem := cValToChar(RN_VUNIATU * 100)
			else
				dbSelectArea("RFO")
				dbSetOrder(1)	//-RFO_FILIAL+RFO_TPVALE+RFO_CODIGO
				dbSeek(xFilial("RFO")+QD03VB->RG2_TPVALE+QD03VB->RG2_CODIGO,.F.)\

				cItemCod  := RFO_BNFFOR
				cItemNome := RFO_DESCR
			endif

			//Totaliza Registros
			nTotal += nVlr
		endif	

		nTotRegTP5 += 1
		nSeq += 1
		//fWrite( nHdl, RHGeraLinhas( aStruct[2], "04" ) )
		aAdd( aOrdem, {QD03VB->(RA_LOCBNF+RA_FILIAL+RA_MAT)+'05', RHGeraLinhas( aStruct[2], "05" ) } )		

		//IncProc("Processando...")
		QD03VB->(dbSkip())
	enddo

	aSort(aOrdem, , , {|x, y| x[1] < y[1]})
	for i := 1 to len(aOrdem)
		fWrite( nHdl, aOrdem[i][2] )
	next i

	//-------------------------------------------------------------------------------------//
	// Codigo 9 - Trailler do Arquivo				                                       //
	//-------------------------------------------------------------------------------------//
	nTotReg := nSeq+1

	nSeq    += 1
	fWrite( nHdl, RHGeraLinhas( aStruct[3] ) )

	return

	//-------------------------------------------------------------------
	/*/{Protheus.doc} Funcoes diversas relatorio /*/
//-------------------------------------------------------------------
Static function fImpLis()
	//Inicia Variaveis
	private cString  := "" // Alias do Arquivo Principal
	private aOrd     := {""}
	private areturn  := { STR0015, 1, STR0016, 1, 2, 2,"",1 } //"Especial" - "Administra‡„o"
	private nTamanho := "P"
	private cPerg    := ""
	private wCabec0  := 2
	private wCabec1  := STR0042 +space(02) +STR0043 +space(04) +STR0044 +space(30) +STR0045 +space(5) +STR0046
	// "Filial  Matricula  Nome                  TP Benef.  Valor Benef."
	private wCabec2  := ""
	private NomeProg := "BENEFARQ"
	private nLastKey := 0
	private m_pag    := 0
	private Li       := 0
	private ContFl   := 1
	private nOrdem   := 0
	private nChar    := 0
	private lEnd     := .F.
	private wnrel    := "BENEFARQ"

	//Envia controle para a funcao SETPRINT
	wnrel := SetPrint(cString,wnrel,"",STR0017,STR0018,STR0019,,.F.,aOrd,.F.,nTamanho) //'LISTAGEM DE BENEFICIOS' - 'Emissao de Relatorio para avaliacao de Benefícios. ' - 'Sera impresso de acordo com os parametros solicitados. '

	if nLastKey == 27
		return
	endif

	Setdefault(areturn,cString)

	if nLastKey == 27
		return
	endif

	//Processa Impressao
	RptStatus({|lEnd| fImpNota() },STR0021) //'Imprimindo...'
return

Static function fImpNota()
	//Inicia Variaveis
	local cFilialAnt := ""
	local cCcAnt     := ""
	local nTfunc     := 0
	local nTccFunc   := 0
	local nTFlFunc   := 0
	local nTBen      := 0
	local nTccBen    := 0
	local nTFlBen    := 0
	local nI		 := 1
	local nPos		 := 0
	local cFilReg	 := ""
	local nRec       := 0

	// Posiciona Regitro
	dbSelectArea("QD03VB")
	//Set Regua
	Count To nRec
	SetRegua( nRec )
	QD03VB->(DbGoTop())
	//Se Ordem Centro de Custo Imprime Nome Centro de Custo
	if nOrd == 2
		dbSelectArea("CTT")
		dbSetOrder(1)	//-CTT_FILIAL+CTT_CUSTO
		dbSeek(xFilial("CTT")+QD03VB->RA_CC,.F.)

		cDet := Space(5) + AllTrim(QD03VB->RA_CC) + " - " + CTT->CTT_DESC01
		Impr(cDet,"C")
	endif

	//Carrega Filial
	if lNovoCalc
		cFilialAnt := QD03VB->RA_FILIAL
	else
		cFilialAnt := QD03VB->RG2_FILIAL
	endif

	while !QD03VB->(Eof())
		if QD03VB->(R0_DUTILM) == 0
			QD03VB->(dbSkip())
			Loop
		endif

		if lNovoCalc
			cFilReg := QD03VB->RA_FILIAL
		else
			cFilReg := QD03VB->RG2_FILIAL
		endif	

		//Abortado Pelo Operador
		if lAbortPrint
			cDet := STR0020 //ABORTADO PELO OPERADOR
			Impr(cDet,'C')
			Exit
		endif

		if lNovoCalc
			nPos := Ascan( aItens, {|x| x[1] == QD03VB->( RA_FILIAL+RA_MAT ) } )
			For nI := 1 To len(aItens[nPos][2])
				//	aItens == QD05VB->R0_TPVALE,QD05VB->R0_CODIGO,QD05VB->R0_QDIACAL,QD05VB->R0_VALCAL,
				//QD05VB->R0_VLRVALE,QD05VB->R0_VLRFUNC,QD05VB->R0_VLREMP,cItemCod,cItemNome

				nVlr := aItens[nPos][2][nI][2]
				cDet := QD03VB->RA_FILIAL      + Space(02) 
				cDet += QD03VB->RA_MAT         + Space(02) 
				cDet += QD03VB->RA_NOME        + Space(10) 
				cDet += aItens[nPos][2][nI][1] + Space(09) 
				cDet += Transform(nVlr,'@E 999,999.99')
				Impr(cDet,'C')
			Next nI
		else
			nVlr := QD03VB->RG2_VALCAL
			cDet := QD03VB->RG2_FILIAL + Space(02) 
			cDet += QD03VB->RG2_MAT    + Space(02) 
			cDet += QD03VB->RA_NOME    + Space(10) 
			cDet += QD03VB->RG2_TPBEN  + Space(09) 
			cDet += Transform(nVlr,'@E 999,999.99')
			Impr(cDet,'C')
		endif
		QD03VB->(dbSkip())

		IncRegua(capital(cDet))

		//Totaliza
		nTfunc   += 1
		nTccFunc += 1
		nTFlFunc += 1
		nTBen    += nVlr
		nTccBen  += nVlr
		nTFlBen  += nVlr

		if nOrd == 2
			if cCcAnt != QD03VB->RA_CC .Or. cFilialAnt != cFilReg
				cCcAnt := QD03VB->RA_CC

				cDet := STR0022 + Space(10) + Transform(nTccBen,"@E 999,999,999.99") //"Valores Totais Centro de Custo: "
				Impr(cDet,"C")

				cDet := STR0023 + Space(10)  + Transform(nTccFunc, "@E 9,999") //"Quantidade de lançamentos Centro Custo: "
				Impr(cDet,"C")
				cDet := ""
				Impr(cDet,"C")

				nTccFunc := 0
				nTccBen  := 0

				if !QD03VB->(Eof()) .And. cFilialAnt == cFilReg
					dbSelectArea("CTT")
					dbSetOrder(1)	//-CTT_FILIAL+CTT_CUSTO
					dbSeek(xFilial("CTT")+QD03VB->RA_CC,.F.)

					cDet := Space(5) + AllTrim(QD03VB->RA_CC) + " - " + CTT->CTT_DESC01
					Impr(cDet,"C")
				endif
			endif
		endif

		if cFilialAnt != cFilReg
			cFilialAnt := cFilReg

			//Imprime Totais
			Impr( "", "C" )

			cDet := STR0024 + Space(10) + Transform(nTFlBen,"@E 999,999,999.99") //"Valores Totais da Filial: "
			Impr(cDet,"C")

			cDet := STR0025 + Transform(nTFlFunc, "@E 9,999") //"Quantidade de lancamentos da Filial: "
			Impr(cDet,"C")

			//Salta Página
			cDet := ""
			Impr(cDet,"F")

			nTFlFunc := 0
			nTFlBen  := 0

			if !QD03VB->(Eof())
				dbSelectArea("CTT")
				dbSetOrder(1)	//-CTT_FILIAL+CTT_CUSTO
				dbSeek(xFilial("CTT")+QD03VB->RA_CC,.F.)

				cDet := Space(5) + AllTrim(QD03VB->RA_CC) + " - " + CTT->CTT_DESC01
				Impr(cDet,"C")
			endif
		endif
	end

	//Totaliza
	Impr("","C")

	cDet := STR0026 + Space(30) + Transform(nTBen,"@E 999,999,999.99") //"Valores Totais da Empresa: "
	Impr(cDet,"C")

	cDet := STR0027 + Transform(nTfunc, "@E 9,999") //"Quantidade de lançamentos da Empresa: "
	Impr(cDet,"C")

	cDet := ""
	Impr(cDet,"F")

	if areturn[5] == 1
		Set Printer to
		Ourspool(wnrel)
	endif

	MS_FLUSH()
return

/*{Protheus.doc} Funcoes diversas configuracao */
user function BENEFOp2()
	local MvPar
	local MvParDef := ""
	local aItens   := {}
	local aArea    := GetArea()

	MvPar := &(Alltrim(ReadVar()))       // Carrega Nome da Variavel do Get em Questao
	MvRet := Alltrim(ReadVar())          // Iguala Nome da Variavel ao Nome variavel de Retorno

	dbSelectArea("RCC")
	dbSetOrder(RetOrder("RCC","RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN"))
	dbSeek(xFilial("RCC")+"S011")
	while !Eof() .And. RCC->RCC_FILIAL + RCC->RCC_CODIGO == xFilial("RCC")+"S011"

		if Substr(RCC->RCC_CONTEU,33,3) == alltrim(MV_PAR01)
			aAdd(aItens, Substr(RCC->RCC_CONTEU,3,30))
			MvParDef += Substr(RCC->RCC_CONTEU,1,2)
		endif

		("RCC")->(dbSkip())
	end

	//         Retorno,Titulo,opcoes,Strin Ret,lin,col, Tipo Sel,tam chave , n. ele ret, Botao
	if f_Opcoes(@MvPar, STR0017, aItens, MvParDef, 12, 49, .F., 2)  // "Opções"
		&MvRet := MvPar                                      // Devolve Resultado
	endif

	RestArea(aArea)                                  // Retorna Alias
return MvParDef

/*{Protheus.doc} Funcoes diversas configuracao */
/*Static function fFormatDat(dData)
local cRet:= Day2Str(dData) + "/" + Month2Str(dData) + "/" + Year2Str(dData)
return cRet
*/

/*{Protheus.doc} Funcao de Validacao dos Funcionarios*/
Static function VBValida(oProcess, cMyAlias)

	local lRetErr := .T.
	default cMyAlias := "SRA"

	if empty( (cMyAlias)->RA_CEP )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0034 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_CEP em branco."  
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0034 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_CEP em branco."
	endif
	if empty( (cMyAlias)->RA_CIC )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0035 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_CIC em branco."
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0035 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_CIC em branco."
	endif
	if empty( (cMyAlias)->RA_RG )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0036 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_RG em branco."
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0036 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_RG em branco."
	endif
	if empty( (cMyAlias)->RA_MAE )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0037 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_MAE em branco."
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0037 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_MAE em branco."
	endif
	if empty( (cMyAlias)->RA_endEREC )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0038 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_endEREC em branco." 
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0038 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_endEREC em branco."
	endif
	/*
	if empty( (cMyAlias)->RA_COMPLEM )
	lRetErr := .F.
	//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0039 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_COMPLEM em branco."
	alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0039 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_COMPLEM em branco."
	endif
	*/
	if empty( (cMyAlias)->RA_MUNICIP )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0040 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_MUNICIP em branco." 
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0040 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_MUNICIP em branco."
	endif
	if empty( (cMyAlias)->RA_ESTADO )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0041 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_ESTADO em branco."
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0041 ) //"Filial: ", " - Matricula: ", " - Funcionário com campo RA_ESTADO em branco."
	endif

	if empty( (cMyAlias)->RA_LOCBNF )
		lRetErr := .F.
		//oProcess:SaveLog( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0055 ) //"Filial: ", " - Matricula: ", " - Funcionário com o Codigo do local de Entrega (RA_LOCBNF) em branco."
		alert( STR0032 +(cMyAlias)->RA_FILIAL + STR0033 +(cMyAlias)->RA_MAT + STR0055 ) //"Filial: ", " - Matricula: ", " - Funcionário com o Codigo do local de Entrega (RA_LOCBNF) em branco."
	endif

	if !lRetErr
		lImpLis   := .F.
		lErrorImp := .T.

	endif

return

/*{Protheus.doc} Atualiza status RG2*/
Static function fAtuRG2()
	// Posiciona Regitro
	dbSelectArea("QD03VB")
	QD03VB->(DbGoTop())

	while QD03VB->(!Eof())
		//  Atualizar arquivo de histórico de benefícios
		dbSelectArea("RG2")
		dbSetOrder ( RetOrder ("RG2", "RG2_FILIAL+RG2_PERIOD+RG2_NROPGT+RG2_TPVALE+RG2_CODIGO" ))
		if dbSeek( QD03VB->RG2_FILIAL + QD03VB->RG2_MAT + QD03VB->RG2_ANOMES + QD03VB->RG2_TPVALE + QD03VB->RG2_CODIGO )
			RecLock("RG2",.F.)
			RG2->RG2_PEDIDO := 2
			MsUnlock()
		endif

		QD03VB->(dbSkip())
	enddo

return

/*{Protheus.doc} Atualiza status SR0                            */
Static function fAtuSR0()
	local cQuery := " SELECT SR0.R_E_C_N_O_ AS RECSR0 " + cQryFech
	local cTmp	:= GetNextAlias()
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), cTmp, .T., .F.)

	while (cTmp)->(!Eof())
		SR0->(dbGoto((cTmp)->RECSR0))
		RecLock("SR0",.F.)
		SR0->R0_PEDIDO := '2'
		SR0->(MsUnlock())

		(cTmp)->(dbSkip())
	enddo
	(cTmp)->(dbCloseArea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	    ³ BenefVal³ Autor ³ Tatiane Matias        ³ Data ³01/12/04³±±
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida os campos periodo e numero de	pagamento da pergunte.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cChave 	- Chave de pesquisa (RCH)  						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Pergunte ARQBENEF - campos Processo (MV_PAR04), 			  ³±±
±±³    		 ³                   Periodo (MV_PAR05) e ³±±
±±³    		 ³                   Numero de Pagamento (MV_PAR06).          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
user function BenefVal(cChave)

	local cReadVar	:= Upper( AllTrim( ReadVar() ) )
	local cRoteiro 
	local lTipoAut
	local lRet 		:= .T.                   
	local nPerNumPg
	local nFilProces
	local nTamRoteiro

	if Substr(cReadVar, 1, 3) == "M->"
		cReadVar := Substr(cReadVar,4)
	endif

	if cReadVar == "MV_PAR04"
		lRet 	   := ExistCpo("RCJ", cChave)
		cProcesso := (cReadVar == "MV_PAR06" .AND. mv_par06 == "99")
		cRoteiro := fGetRotOrdinar()
		if cRoteiro <> "EXT"	       
			dbSelectArea( "RCH" )
			dbSetOrder( 4 ) // RCH_FILIAL + RCH_PROCESSO + RCH_ROTEIRO + RCH_PERIODO + RCH_NUMPAG
			cChave:=(MV_PAR04+Space(5-len(MV_PAR04))+cRoteiro+MV_PAR05+MV_PAR06)
			cChave := xFilial( "RCH" ) + cChave
			dbSeek( cChave, .F. ) 
			if Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento de Autonomos - Permite Nro. Pagto nao cadastrado  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nFilProces 	:= GetSx3Cache( "RCH_FILIAL", "X3_TAMANHO" ) + GetSx3Cache( "RCH_PROCES", "X3_TAMANHO" )
				nTamRoteiro	:= GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" )
				//cRoteiro 	:= Substr(cChave, nFilProces+1, nTamRoteiro)
				nPerNumPg 	:= nFilProces + len( cRoteiro ) + 1
				lTipoAut 	:= ( fGetTipoRot( cRoteiro ) == "9" )
				dbSelectArea("RCH")
				if lTipoAut
					dbSeek( Substr( cChave, 1, nFilProces ) + cRoteiro + Substr( cChave, nPerNumPg ) , .F. )
				endif
				if Eof()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pesquisar Periodo sem roteiro de calculo.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cRoteiro := Space( nTamRoteiro )
					cChave := Substr( cChave, 1, nFilProces ) + cRoteiro + Substr( cChave, nPerNumPg )
					dbSeek( cChave, .F. )
					if Eof()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Tratamento de Autonomos - Permite Nro. Pagto nao cadastrado  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						if lTipoAut
							cChave := Substr( cChave, 1, nFilProces ) + cRoteiro
							dbSeek( cChave, .F. )
							if Eof()
								lTipoAut := .F.
							endif
						endif
						if !lTipoAut
							Help( " ", 1, "REGNOIS" )
							lRet 	 := .F.
						endif
					endif
				endif
			endif
		endif
	endif

return ( lRet )


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³gRCHCS  ³Autor³Cecilia Carvalho          ³Data³30/10/2013³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Filtro da Consulta Padrao								 	³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                             				³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Consulta Padrao (SXB)				                  	   	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

user function gRCHCS()
	local cFiltro		:= "(RCH->RCH_FILIAL == '" + xFilial("RCH") + "')"
	local cRotFiltro	:= ""

	dbSelectArea("SRY")
	dbSetOrder(1)  
	dbSeek(xFilial("SRY"))
	while (!Eof()) .And. (SRY->RY_FILIAL == xFilial("SRY") )
		if 	!empty(SRY->RY_TIPO) .AND. 	(SRY->RY_TIPO == '8' .OR. SRY->RY_TIPO == 'D' .OR. SRY->RY_TIPO == 'E') 
			if len(cRotFiltro)= 0
				cRotFiltro += " .AND. (RCH->RCH_ROTEIR == '" + SRY->RY_CALCULO + "'"
			else
				cRotFiltro += " .OR. RCH->RCH_ROTEIR == '" + SRY->RY_CALCULO + "'"
			endif
		endif
		dbSkip()
	enddo
	cRotFiltro	:= iif( len(cRotFiltro) > 0,cRotFiltro + ")","") 

	cFiltro	+= cRotFiltro 	
	cFiltro := "@#" + cFiltro + "@#"

return ( cFiltro )

user function TrataAce(cTexto)
	local cRetorno := cTexto

	cRetorno := NOACENTO(cRetorno)
	cRetorno := REPLACE(cRetorno, ",", "")
	cRetorno := REPLACE(cRetorno, ".", "")
	cRetorno := REPLACE(cRetorno, ":", "")
	cRetorno := REPLACE(cRetorno, "-", "")

return cRetorno