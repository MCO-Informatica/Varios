#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TopConn.Ch'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWBROWSE.CH'
#INCLUDE 'FILEIO.CH'
Static nItTpReg		:= 0
Static nTtLinh		:= 0
Static nHdlArq 		:= 0
Static cArqAtu		:= ''
Static cDirArq		:= ''
Static cSeqZ03		:= ''
Static aTabRec		:= {}
Static aCFOsNF		:= {}
Static cRemeten		:= '' //CPF ou CNPJ do rementente caso o registro tipo 4 esteja sendo enviado, caso não deve verificar direto na tabela
Static cAvista		:= ''

//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ${DHME0001}
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 29/08/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)zca
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
User Function DHME0001()

	Local aArea 		:= GetArea()

	Private cCadastro	:= "Exportação de NFs e Log de Execuções"

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z03")
	oBrowse:SetDescription(cCadastro)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetUseCaseFilter(.T.)

	oBrowse:AddLegend("Z03_TPARQ == '0' "	, "GREEN"	, "Todas as Movimentações")
	oBrowse:AddLegend("Z03_TPARQ == '1' "	, "BLUE"	, "Somente Notas Fiscais de Saida")
	oBrowse:AddLegend("Z03_TPARQ == '2' "	, "RED"		, "Somente Notas Fiscais de Entrada")
	oBrowse:AddLegend("Z03_TPARQ == '4' "	, "YELLOW"	, "Somente Produtos")
	oBrowse:AddLegend("Z03_TPARQ == '5' "	, "WHITE"	, "Somente Clientes|Fornecedores")

	oBrowse:Activate()

	RestArea(aArea)

Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} MenuDef
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 29/08/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina 	:= {}

	ADD OPTION aRotina TITLE "&Visualizar" 				ACTION "VIEWDEF.DHME0001"	OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina TITLE "Exportar Reg.&ST"			ACTION "U_DHME00A2"			OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "&Exp. NF Entrada"			ACTION "U_DHME00A1"			OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "&Exp. NF Saida"			ACTION "U_DHME00A5"			OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "&Exp. Fornecedor"			ACTION "U_DHME00A3"			OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "&Exp. Produto"			ACTION "U_DHME00A4"			OPERATION MODEL_OPERATION_INSERT ACCESS 0

Return aRotina
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ModelDef
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 29/08/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function ModelDef()

	Local oStrtZ03	:= FWFormStruct(1, "Z03")
	Local oModel

	oModel	:= MPFormModel():New("MDHME0001")
	oModel:AddFields("DHME0001", ,oStrtZ03)
	oModel:GetModel("DHME0001"):SetDescription('Exportação de NFs e Log de Execuções')

Return oModel
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ViewDef
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 29/08/2016
@version 1.0
@return ${return}, ${return_description}
*///---------------------------------------------------------------------------------------------------------------------------
Static Function ViewDef()

	Local oModel   := FWLoadModel( 'DHME0001' )
	Local oStruZ03 := FWFormStruct( 2, 'Z03' )
	Local oView
	Local cCampos := {}

	oView := FWFormView():New()
	oView:SetModel( oModel )
	oStruZ03:RemoveField("Z03_TPARQ")
	oView:AddField( 'VIEW_Z03', oStruZ03, "DHME0001")
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_Z03', 'TELA' )

Return oView
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DHME00A3
Layout de Fornecedores/Clientes
@type function
@author Cris
@since 15/02/2017
@version 1.0
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
User Function DHME00A3()

	Local	aLayout		:= {}
	Local 	aPergs		:= {}
	Local dDtDgIni		:= lastday((lastday(MsDate(),1))-1,1)
	Local dDtDgFim		:= Lastday(dDtDgIni,2)
	Local cLayoutE		:= '002'
	Local cFilPara		:= cFilAnt
	Local aRetPara		:= {}
	Local cAliaQry		:= ''

	aAdd( aPergs ,{1,"Data da Digitação de",dDtDgIni,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Data da Digitação até",dDtDgFim,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Filial:",cFilPara,"@!",'NAOVAZIO()','SM0','.T.',TamSX3('D1_FILIAL')[1],.F.})
	aAdd( aPergs ,{1,"Layout",cLayoutE,"",'NAOVAZIO()','Z00','.F.',50,.F.})


	U_RFATA99()

	If ParamBox(aPergs ,"Filtros",aRetPara)

		//Efetua a manutenção na tabela de Log
		AtuLog(3,cLayoutE)
		//Seleciona os registros associados ao periodo informado e os tipos de movimentaçoes informadas
		FWMsgRun(,{||  cAliaQry	:= SelFor() },'Aguarde....' ,'Selecionando registros.')

		if !(cAliaQry)->(Eof())

			//Carrega o layout
			FWMsgRun(,{||  aLayout	:= Layout(aLayout,'E',aRetPara[4])},'Aguarde....' ,'Carregando as configurações do código do layout:'+aRetPara[4])


			//Caso exista o layout ativo
			if len(aLayout) > 0

				//Monta o arquivo conforme layout x dados selecionados
				FWMsgRun(,{||  MntArqCF(aLayout,cAliaQry) },'Aguarde....' ,'Aplicando as regras de configurações nos dados selecionados.')

			Else

				HELP("HELP",, 'Não Ativo - Layout',, "O codigo do Layout "+aRetPara[4]+" não esta ativo ou não existe.Operação cancelada.", 1, 0)

			EndIf

		Else

			HELP("HELP",, 'Não existem Dados',, "Para o período informado não existem dados.", 1, 0)

		EndIf

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------				
/*/{Protheus.doc} $DHME00A4
Layout de Produtos
@type function
@author Cris
@since 15/02/2017
@version 1.0
@return ${return}, ${return_description}
/*///--------------------------------------------------------------------------------------------------------------------------- 
User Function DHME00A4()

	Local	aLayout		:= {}
	Local 	aPergs		:= {}
	Local dDtDgIni		:= lastday((lastday(MsDate(),1))-1,1)
	Local dDtDgFim		:= Lastday(dDtDgIni,2)
	Local cLayoutE		:= '001'
	Local cFilPara		:= cFilAnt
	Local aTpMvto		:=  {'E=NF Entrada','S=NF Saída'}
	Local aRetPara		:= {}
	Private cAliaQry	:= ''

	aAdd( aPergs ,{1,"Data da Digitação de",dDtDgIni,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Data da Digitação até",dDtDgFim,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Filial:",cFilPara,"@!",'NAOVAZIO()','SM0','.T.',TamSX3('D1_FILIAL')[1],.F.})
	aAdd( aPergs ,{1,"Layout",cLayoutE,"",'NAOVAZIO()','Z00','.F.',50,.F.})
	aAdd( aPergs ,{3,"Tipo de Movimentação:",1,aTpMvto , 50,'.T.',.T.})


	U_RFATA99()


	If ParamBox(aPergs ,"Filtros",aRetPara)

		cAliaQry	:= GetNextAlias()

		//Efetua a manutenção na tabela de Log
		AtuLog(3,cLayoutE)

		//Seleciona os registros associados ao periodo informado e os tipos de movimentações informadas
		FWMsgRun(,{||  SelProd(aRetPara) },'Aguarde....' ,'Selecionando registros.')

		//Caso existam registros carrega o layout configurado e monta posições com os dados
		if !(cAliaQry)->(Eof())

			//Carrega o layout
			FWMsgRun(,{||  aLayout	:= Layout(aLayout,'E',aRetPara[4])},'Aguarde....' ,'Carregando as configurações do código do layout:'+aRetPara[4])

			//Caso exista o layout ativo
			if len(aLayout) > 0

				//Monta o arquivo conforme layout x dados selecionados
				FWMsgRun(,{||  MntArqPd(aLayout) },'Aguarde....' ,'Aplicando as regras de configurações nos dados selecionados.')

			Else

				HELP("HELP",, 'Não Ativo - Layout',, "O codigo do Layout  "+aRetPara[4]+" não esta ativo ou não existe. Operação cancelada.", 1, 0)

			EndIf

		Else

			("HELP",, 'Não existem Dados',, "Para o período informado não existem dados.", 1, 0)

		EndIf

		AtuLog(4,cLayoutE)
		nTtLinh := 0
		(cAliaQry)->(dbCloseArea())

	EndIf
Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} DHME00A1
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 29/08/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
User Function DHME00A1()

	Local	aLayout		:= {}
	Local 	aPergs		:= {}
	Local dDtDgIni		:= lastday((lastday(MsDate(),1))-1,1)
	Local dDtDgFim		:= Lastday(dDtDgIni,2)
	Local cLayoutE		:= '007'
	Local cFilPara		:= cFilAnt
	Local aRetPara		:= {}
	Private cAliaQry	:= ''

	aAdd( aPergs ,{1,"Data da Digitação de",dDtDgIni,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Data da Digitação até",dDtDgFim,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Filial:",cFilPara,"@!",'NAOVAZIO()','SM0','.T.',TamSX3('D1_FILIAL')[1],.F.})
	aAdd( aPergs ,{1,"Layout",cLayoutE,"",'NAOVAZIO()','Z00','.F.',50,.F.})


	U_RFATA99()

	If ParamBox(aPergs ,"Filtros",aRetPara)

		cAliaQry	:= GetNextAlias()

		//Efetua a manutenção na tabela de Log
		AtuLog(3,cLayoutE)

		//Seleciona os registros associados ao periodo informado e os tipos de movimentaçoes informadas
		FWMsgRun(,{||  SelNFEnt(aRetPara) },'Aguarde....' ,'Selecionando registros.')

		if !(cAliaQry)->(Eof())

			//Carrega o layout
			FWMsgRun(,{||  aLayout	:= Layout(aLayout,'E',aRetPara[4])},'Aguarde....' ,'Carregando as configurações do código do layout:'+aRetPara[4])


			//Caso exista o layout ativo
			if len(aLayout) > 0 .AND. len(aLayout[1]) > 0

				cArqAtu	:= 	"NOTENT_"+Dtos(dDatabase)+'_'+StrTran(Alltrim(Time()),":", "_")+".TXT"

				//Exige informar o diretório de gravação do arquivo, será chamado antes de montar os dados
				//para que em cada nota fiscal sejam gravados seu registros pensando em um arquivo de alto volume
				if SelDirGrv(cArqAtu)

					//Monta o arquivo conforme layout x dados selecionados
					FWMsgRun(,{||  MntArqNF(aLayout,aRetPara) },'Aguarde....' ,'Aplicando as regras de configurações nos dados selecionados.')

				EndIf

			Else

				HELP("HELP",, 'Não Ativo - Layout',, "O codigo do Layout  "+aRetPara[4]+" não esta ativo ou não existe. Operação cancelada.", 1, 0)

			EndIf

		Else

			HELP("HELP",, 'Não existem Dados',, "Para o período informado não existem dados.", 1, 0)

		EndIf

		(cAliaQry)->(dbCloseArea())

		//Efetua a manutenção na tabela de Log
		AtuLog(4)

	Else

		HELP("HELP",, 'Exportação',, "Operação cancelada pelo colaborador.", 1, 0)

	EndIf

	nItTpReg	:= 0
	nHdlArq		:= 0
	nTtLinh		:= 0
	cArqAtu		:= ''
	cDirArq		:= ''
	cSeqZ03		:= ''
	aTabRec		:= {}
	aCFOsNF		:= {}

Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} AtuLog
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 07/09/2016
@version 1.0
@param nOperAtu, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AtuLog(nOperAtu,cCodLay)

	Local 	oModelAtu	:= Nil
	Local 	lRet		:= .T.
	Local 	cParamInf	:= ''
	Local 	cTpArq		:= ''

	Local aErro := {}
	Local cMensag		:= ""

	Default cCodLay		:= ''

	oModelAtu := FWLoadModel("DHME0001")
	oModelAtu:SetOperation(nOperAtu)

	//Se a operação for alteração posiciono no log gravado.
	if nOperAtu == 4

		if !Z03->(dbSeek(xFilial('Z03')+cSeqZ03))

			HELP("HELP",, 'Não localizado Log',, "O Log número  "+cSeqZ03+" não foi localizado. Não será atualizado.", 1, 0)

			lRet	:= .F.
		EndIf

	EndIf

	if lRet

		lRet := oModelAtu:Activate()

	EndIf

	if lRet

		//Se for inclusão, esta iniciando as verificações para a geração do arquivo
		if nOperAtu == 3

			cSeqZ03	:= GetSXeNum("Z03","Z03_SEQUEN")
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_FILIAL" , xFilial("Z03"))
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_FILORI" , MV_PAR03)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_SEQUEN" , cSeqZ03 )
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_DATINI" , dDataBase)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_HORINI" , Time())
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_RESPON" , LogUserName()+' Id Protheus '+__cUserID)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_PERINI" , MV_PAR01)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_PERFIM" , MV_PAR02)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_LAYOUT" , cCodLay)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_OUTPAR" , cParamInf)

		Elseif nOperAtu == 4

			oModelAtu:GetModel('DHME0001'):SetValue("Z03_NOMARQ",cArqAtu)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_CAMARQ",cDirArq)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_HORFIM",Time())
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_DATFIM",dDataBase)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_QTDREG",nTtLinh)

		EndIf

		If oModelAtu:VldData()
			If !oModelAtu:CommitData()

				HELP("HELP",, 'Não gravou o log',, "Erro na gravação do Log.", 1, 0)

			EndIf

		Else

			aErro := oModelAtu:GetErrorMessage()

			cMensag := '{"Retorno":"200"' +;
				'"Id do formulário de origem:":'  + '"' + cValToChar(aErro[01]) + '"'+Chr(10)+Chr(13)+;
				'"Id do campo de origem: "    :'  + '"' + cValToChar(aErro[02]) + '"'+Chr(10)+Chr(13)+;
				'"Id do formulário de erro: " :'  + '"' + cValToChar(aErro[03]) + '"'+Chr(10)+Chr(13)+;
				'"Id do campo de erro: "      :'  + '"' + cValToChar(aErro[04]) + '"'+Chr(10)+Chr(13)+;
				'"Id do erro: "               :'  + '"' + cValToChar(aErro[05]) + '"'+Chr(10)+Chr(13)+;
				'"Mensagem do erro: "         :'  + '"' + cValToChar(aErro[06]) + '"'+Chr(10)+Chr(13)+;
				'"Mensagem da solução: "      :'  + '"' + cValToChar(aErro[07]) + '"'+Chr(10)+Chr(13)+;
				'"Valor atribuído: "          :'  + '"' + cValToChar(aErro[08]) + '"'+Chr(10)+Chr(13)+;
				'"Valor anterior: "           :'  + '"' + cValToChar(aErro[09]) + '"}'

			Alert(cMensag,'Erro')

			HELP("HELP",, 'Não gravou o log',, "Erro na validação dos dados do Log.", 1, 0)

		EndIf

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} SelProd
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SelProd(aRetPara)

	Local 	cQryPrdE	:= ''
	Local	cQryPrdS	:= ''
	Local 	cQryPrdT	:= ''
	Local	cFlNFAtu	:= aRetPara[3]
	Local 	cFlProd		:= Iif(!Empty(Alltrim(xFilial("SB1"))),cFlNFAtu,xFilial("SB1"))
	Local 	cFilCTES	:= Iif(!Empty(Alltrim(xFilial("SF4"))),cFlNFAtu,xFilial("SF4"))

	if aRetPara[5] == 1//1==Somente entrada

		cQryPrdE		:= "	SELECT  'E' MVTO,B1_ORIGEM,B1_COD, B1_UM,B1_SEGUM,B1_CONV, B1_DESC, B1_POSIPI, B1_PESO, "+CRLF
		cQryPrdE		+= "			D1_UM UNIDADE, B1_CEST,"+CRLF
		cQryPrdE		+= "					(CASE B1_TIPO"+CRLF
		cQryPrdE		+= "					  WHEN 'AI' THEN  9 "+CRLF//--ATIVO FIXO
		cQryPrdE		+= "					  WHEN 'BN' THEN  99"+CRLF//--BENEFICIAMENTO
		cQryPrdE		+= "					  WHEN 'EM' THEN  6"+CRLF//--EMBALAGEM
		cQryPrdE		+= "					  WHEN 'GE' THEN  99"+CRLF//--GARANTIA ESTENDIDA
		cQryPrdE		+= "					  WHEN 'GG' THEN  99"+CRLF//--GASTOS GERAIS
		cQryPrdE		+= "					  WHEN 'KT' THEN 99"+CRLF//--KIT
		cQryPrdE		+= "					  WHEN 'MC' THEN 8"+CRLF//--MATERIAL DE CONSUMO
		cQryPrdE		+= "					  WHEN 'ME' THEN 1"+CRLF//--MERCADORIA
		cQryPrdE		+= "					  WHEN 'MO' THEN 99"+CRLF//--MAO DE OBRA
		cQryPrdE		+= "					  WHEN 'MP' THEN 2"+CRLF//--MATERIA PRIMA
		cQryPrdE		+= "					  WHEN 'OI' THEN 11"+CRLF//--OUTROS INSUMOS
		cQryPrdE		+= "					  WHEN 'PA' THEN 5"+CRLF//--PRODUTO ACABADO
		cQryPrdE		+= "					  WHEN 'PI' THEN 3"+CRLF//--PRODUTO INTERMEDIARIO
		cQryPrdE		+= "					  WHEN 'PP' THEN 4"+CRLF//--PRODUTO EM  PROCESSO
		cQryPrdE		+= "					  WHEN 'PV' THEN 99"+CRLF//--PRODUTO VEICULO
		cQryPrdE		+= "					  WHEN 'SL' THEN 99"+CRLF//--SELOD DE CONTROLE
		cQryPrdE		+= "					  WHEN 'SP' THEN 7"+CRLF//--SUBPRODUTO
		cQryPrdE		+= "					  END"+CRLF
		cQryPrdE		+= "					) AS B1_TIPO,"+CRLF
		cQryPrdE		+= "			D1_PICM ALIQUOTA_ICMS, D1_IPI  ALIQUOTA_IPI,"+CRLF
		cQryPrdE		+= "			F4_SITTRIB, F4_CSOSN,F4_CTIPI, F4_CSTPIS, F4_CSTCOF, "+CRLF
		cQryPrdE		+= "			AH_UNIMED,  AH_DESCPO, "+RetSqlName("SB1")+".R_E_C_N_O_ AS SB1RECNO "+CRLF
		cQryPrdE		+= "	FROM "+RetSqlName("SB1")+" "+RetSqlName("SB1")+" (NOLOCK)"+CRLF
		cQryPrdE		+= "	INNER JOIN "+RetSqlName("SD1")+" "+RetSqlName("SD1")+" (NOLOCK)"+CRLF
		cQryPrdE		+= "			ON D1_FILIAL = '"+cFlNFAtu+"'"+CRLF
		cQryPrdE		+= "			AND D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+CRLF
		cQryPrdE		+= "			AND D1_COD = B1_COD "+CRLF
		cQryPrdE		+= "			AND "+RetSqlName("SD1")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdE		+= "			AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdE		+= "	INNER JOIN "+RetSqlName("SF4")+" "+RetSqlName("SF4")+" (NOLOCK)"+CRLF
		cQryPrdE		+= "	        ON F4_FILIAL = '"+cFilCTES+"'"+CRLF
		cQryPrdE		+= "	        AND F4_CODIGO = D1_TES"+CRLF
		cQryPrdE		+= "	        AND "+RetSqlName("SF4")+".D_E_L_E_T_ =  ''"+CRLF
		cQryPrdE		+= "	INNER JOIN "+RetSqlName("SAH")+" "+RetSqlName("SAH")+" (NOLOCK)"+CRLF
		cQryPrdE		+= "	       ON AH_FILIAL = '"+xFilial('SAH')+"'"+CRLF
		cQryPrdE		+= "	       AND  AH_UNIMED = (CASE"+CRLF
		cQryPrdE		+= "								 WHEN LEN(D1_UM) <= 4 THEN D1_UM"+CRLF
		cQryPrdE		+= "							 ELSE D1_SEGUM "+CRLF
		cQryPrdE		+= "							 END ) "+CRLF
		cQryPrdE		+= "	       AND  "+RetSqlName("SAH")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdE		+= "	WHERE B1_FILIAL = '"+cFlProd+"' "+CRLF

		//1 Somente registros não exportados
		/*	if MV_PAR04 == 1
				
				cQryPrdE		+= " AND  B1_XEXPCTB <> '1' "+CRLF			
		
			//3 Somente registros exportados			
			Elseif  MV_PAR04 == 3
						
				cQryPrdE		+= " AND  B1_XEXPCTB = '1' "+CRLF		
							
			EndIf			
			
			cQryPrdT		:= cQryPrdE
			
		EndIf
	
		if MV_PAR05 == 1 //TODOS	
			
			cQryPrdT		+= " UNION "+CRLF
			
		EndIF
		*/
		cQryPrdE := ChangeQuery(cQryPrdE)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPrdE),cAliaQry,.T.,.T.)

	Elseif aRetPara[5] == 2//2=Somente saidas

		cQryPrdS		+= "			SELECT 'S' AS MVTO,B1_ORIGEM,B1_COD, B1_UM, B1_SEGUM,B1_CONV, B1_DESC, B1_POSIPI,  B1_PESO,"+CRLF
		cQryPrdS		+= "			D2_UM UNIDADE, B1_CEST, "+CRLF
		cQryPrdS		+= "					(CASE B1_TIPO"+CRLF
		cQryPrdS		+= "					  WHEN 'AI' THEN  9"+CRLF
		cQryPrdS		+= "					  WHEN 'BN' THEN  99"+CRLF//--BENEFICIAMENTO
		cQryPrdS		+= "					  WHEN 'EM' THEN  6"+CRLF//--EMBALAGEM
		cQryPrdS		+= "					  WHEN 'GE' THEN  99"+CRLF//--GARANTIA ESTENDIDA
		cQryPrdS		+= "					  WHEN 'GG' THEN  99"+CRLF//--GASTOS GERAIS
		cQryPrdS		+= "					  WHEN 'KT' THEN 99"+CRLF//--KIT
		cQryPrdS		+= "					  WHEN 'MC' THEN 8"+CRLF//--MATERIAL DE CONSUMO
		cQryPrdS		+= "					  WHEN 'ME' THEN 1"+CRLF//--MERCADORIA
		cQryPrdS		+= "					  WHEN 'MO' THEN 99"+CRLF//--MAO DE OBRA
		cQryPrdS		+= "					  WHEN 'MP' THEN 2"+CRLF//--MATERIA PRIMA
		cQryPrdS		+= "					  WHEN 'OI' THEN 11"+CRLF//--OUTROS INSUMOS
		cQryPrdS		+= "					  WHEN 'PA' THEN 5"+CRLF//--PRODUTO ACABADO
		cQryPrdS		+= "					  WHEN 'PI' THEN 3"+CRLF//--PRODUTO INTERMEDIARIO
		cQryPrdS		+= "					  WHEN 'PP' THEN 4"+CRLF//--PRODUTO EM  PROCESSO
		cQryPrdS		+= "					  WHEN 'PV' THEN 99"+CRLF//--PRODUTO VEICULO
		cQryPrdS		+= "					  WHEN 'SL' THEN 99"+CRLF//--SELOD DE CONTROLE
		cQryPrdS		+= "					  WHEN 'SP' THEN 7"+CRLF//--SUBPRODUTO
		cQryPrdS		+= "					  END"+CRLF
		cQryPrdS		+= "					) AS B1_TIPO, "+CRLF
		cQryPrdS		+= "					D2_PICM ALIQUOTA_ICMS, D2_IPI  ALIQUOTA_IPI,"+CRLF
		cQryPrdS		+= "			F4_SITTRIB, F4_CSOSN,F4_CTIPI, F4_CSTPIS, F4_CSTCOF, "+CRLF
		cQryPrdS		+= "			AH_UNIMED,  AH_DESCPO, "+RetSqlName("SB1")+".R_E_C_N_O_ AS SB1RECNO "+CRLF
		cQryPrdS		+= "			FROM "+RetSqlName("SB1")+" "+RetSqlName("SB1")+" (NOLOCK)"+CRLF
		cQryPrdS		+= "			INNER JOIN "+RetSqlName("SD2")+" "+RetSqlName("SD2")+"  (NOLOCK)"+CRLF
		cQryPrdS		+= "			        ON D2_FILIAL = '"+cFlNFAtu+"'"+CRLF
		cQryPrdS		+= "			       AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'"+CRLF
		cQryPrdS		+= "			       AND D2_COD = B1_COD"+CRLF
		cQryPrdS		+= "			       AND "+RetSqlName("SD2")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdS		+= "			       AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdS		+= "			INNER JOIN "+RetSqlName("SF4")+" "+RetSqlName("SF4")+" (NOLOCK)"+CRLF
		cQryPrdS		+= "			        ON F4_FILIAL = '"+cFilCTES+"'"+CRLF
		cQryPrdS		+= "			        AND F4_CODIGO = D2_TES"+CRLF
		cQryPrdS		+= "			        AND "+RetSqlName("SF4")+".D_E_L_E_T_ =  ''"+CRLF
		cQryPrdS		+= "			INNER JOIN "+RetSqlName("SAH")+"  "+RetSqlName("SAH")+" (NOLOCK)"+CRLF
		cQryPrdS		+= "			       ON AH_FILIAL = '"+xFilial('SAH')+"'"+CRLF
		cQryPrdS		+= "			       AND  AH_UNIMED = (CASE"+CRLF
		cQryPrdS		+= "										 WHEN LEN(D2_UM) <= 4 THEN D2_UM"+CRLF
		cQryPrdS		+= "										 ELSE D2_SEGUM "+CRLF
		cQryPrdS		+= "										 END ) "+CRLF
		cQryPrdS		+= "			       AND  "+RetSqlName("SAH")+".D_E_L_E_T_ = ''"+CRLF
		cQryPrdS		+= "	WHERE B1_FILIAL = '"+cFlProd+"' "+CRLF

		//1 Somente registros não exportados
		/*	if MV_PAR04 == 1
				
				cQryPrdS		+= " AND  B1_XEXPCTB <> '1' "+CRLF			
		
			//3 Somente registros exportados			
			Elseif  MV_PAR04 == 3
						
				cQryPrdS		+= " AND  B1_XEXPCTB = '1' "+CRLF		
							
			EndIf	
			
	    	cQryPrdT		+= cQryPrdS
	    			
	    EndIf
	    */
		cQryPrdS := ChangeQuery(cQryPrdS)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPrdS),cAliaQry,.T.,.T.)

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ${function_method_class_name}
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 04/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SelClfor(cAliasNF)

	Local 	cQCliFor	:= ''
	Local 	cQFornec	:= ''
	Local 	cQClient	:= ''
	Local 	cFiltro		:= ''
	Local 	lConsCli	:= .F.
	Local 	lConsFor	:= .F.
	Local	cFlNFAtu	:= xFilial("SD1")
	Local 	cFlClien	:= Iif(!Empty(Alltrim(xFilial("SA1"))),cFlNFAtu,xFilial("SA1"))
	Local 	cFlForne	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local 	cFlCnCtb	:= Iif(!Empty(Alltrim(xFilial("CT1"))),cFlNFAtu,xFilial("CT1"))
	Default cAliasNF	:= ''

	//Quando rotina chamada para o layout 003 - Nota Fiscal de Saida/Entrada
	if !Empty(cAliasNF)

		cFiltro		:= (cAliaQry)->CLIEFOR+(cAliaQry)->LOJA

		if ((cAliaQry)->MVTO == 'S' .AND. (cAliaQry)->TIPONF  <> 'D') .OR.  ((cAliaQry)->MVTO == 'E' .AND. (cAliaQry)->TIPONF  == 'D')

			lConsCli	:= .T.

		Elseif  ((cAliaQry)->MVTO == 'S' .AND. (cAliaQry)->TIPONF  == 'D') .OR.  ((cAliaQry)->MVTO == 'E' .AND. (cAliaQry)->TIPONF  <> 'D')

			lConsFor	:= .T.

		EndIf

	EndIf

	cQFornec 	:= "	SELECT 'F' ORIGEM_C_F, A2_COD CODIGO, A2_LOJA LOJA, A2_TIPO TIPO_F_J, A2_NOME NOME, A2_NREDUZ FANTASIA, A2_END ENDERECO,"+CRLF
	cQFornec 	+= "				    '' AS FINALIDADE_NEGOCIO, A2_EST UF,"+CRLF
	cQFornec 	+= "						   	 (CASE "+CRLF
	cQFornec 	+= "								WHEN A2_EST = 'EX' THEN (	SELECT CCH_PAIS"+CRLF
	cQFornec 	+= "															FROM  "+RetSqlName("CCH")+" (NOLOCK)"+CRLF
	cQFornec 	+= "															WHERE CCH_FILIAL  = ''"+CRLF
	cQFornec 	+= "															 AND CCH_CODIGO = A2_CODPAIS"+CRLF
	cQFornec 	+= "															 AND D_E_L_E_T_ = ''"+CRLF
	cQFornec 	+= "														)"+CRLF
	cQFornec 	+= "								ELSE ''"+CRLF
	cQFornec 	+= "								END"+CRLF
	cQFornec 	+= "							)AS PAISEXT"+CRLF
	cQFornec 	+= "					,A2_ESTADO ESTADO, A2_COD_MUN  CMUNIBGE, A2_COMPLEM COMPLEMENTO,"+CRLF
	cQFornec 	+= "					A2_MUN MUNICIPIO, A2_BAIRRO BAIRRO, A2_CEP CEP, A2_DDD DDD,A2_TEL TEL, "+CRLF
	cQFornec 	+= "					A2_INSCR INSCRICAO_ESTADUAL,A2_CGC CPF_CNPJ,A2_INSCRM INSCRICAO_MUNICIPAL,"+CRLF
	cQFornec 	+= "					(CASE "+CRLF
	cQFornec 	+= "						WHEN LEN(RTRIM(A2_CONTA)) > 6  THEN (	SELECT CT1_RES "+CRLF
	cQFornec 	+= "																FROM "+RetSqlName("CT1")+" (NOLOCK)"+CRLF
	cQFornec 	+= "																WHERE CT1_FILIAL = '"+cFlCnCtb+"' "+CRLF
	cQFornec 	+= "																  AND CT1_CONTA = A2_CONTA"+CRLF
	cQFornec 	+= "																  AND D_E_L_E_T_ = '')			"+CRLF
	cQFornec 	+= "						ELSE A2_CONTA"+CRLF
	cQFornec 	+= "					END	 )"+CRLF
	cQFornec 	+= "					AS CONTA_CONTABIL, "+CRLF
	cQFornec 	+= "					'' CODIGO_SUFRAMA, A2_CODMUN CODIGO_MUNICIPIO_SUFRAMA,"+CRLF
	cQFornec 	+= "					A2_CODPAIS CODIGO_PAIS_IBGE,"+CRLF
	cQFornec 	+= "					'' INSCRICAO_RURAL,"+CRLF
	cQFornec 	+= "					A2_RECISS RECOLHE_ISS,A2_RECCSLL RECOLHE_CSLL,A2_RECPIS RECOLHE_PIS, A2_RECCOFI RECOLHE_COFINS, "+CRLF
	cQFornec 	+= "					A2_RECINSS RECOLHE_INSS,A2_MINIRF MINIMO_IRRF,'' MINIMO_IRRF, A2_RECFET RECOLHE_FETB,"+CRLF
	cQFornec 	+= "					'' SIMPLES_NACIONAL,'' IRRF_BAIXA, '' CONTRIBUINTE_ICMS,A2_SIMPNAC OPTANTE_SIMPLES_NACIONAL,"+CRLF
	cQFornec 	+= "					"+RetSqlName("SA2")+".R_E_C_N_O_ AS RECNO "+CRLF
	cQFornec 	+= "	FROM "+RetSqlName("SA2")+" "+RetSqlName("SA2")+" (NOLOCK)"+CRLF
	cQFornec 	+= "	WHERE A2_FILIAL = '"+cFlForne+"'"+CRLF
	cQFornec 	+= "	  AND "+RetSqlName("SA2")+".D_E_L_E_T_ = ''"+CRLF
	cQFornec 	+= "	   AND "+CRLF

	//1=Todos ou 2==Somente entrada
	//if (MV_PAR05 == 1 .OR. MV_PAR05 == 2) .AND. !lConsFor
	if !lConsFor

		if  MV_PAR05 == 1

			cQFornec 	+= "	( "+CRLF

		EndIf

		cQFornec 	+= "	   A2_COD+A2_LOJA IN (SELECT F1_FORNECE+F1_LOJA"+CRLF
		cQFornec 	+= "	  						  FROM "+RetSqlName("SF1")+" (NOLOCK)"+CRLF
		cQFornec 	+= "	  						  WHERE F1_FILIAL = '"+cFlNFAtu+"'"+CRLF
		cQFornec 	+= "	  						     AND F1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+CRLF
		cQFornec 	+= "	  						     AND D_E_L_E_T_ = ''"+CRLF
		cQFornec 	+= "	  						     AND F1_TIPO <> 'D')"+CRLF

	EndIf

	if !lConsFor

		cQFornec 	+= "	  	OR "+CRLF

	EndIf

	//1=Todos ou 3==Somente Saida
	if !lConsFor

		cQFornec 	+= "	  			A2_COD+A2_LOJA IN(SELECT F2_CLIENTE+F2_LOJA"+CRLF
		cQFornec 	+= "	  							  FROM  "+RetSqlName("SF2")+" (NOLOCK)"+CRLF
		cQFornec 	+= "	  							  WHERE F2_FILIAL =  '"+cFlNFAtu+"' "+CRLF
		cQFornec 	+= "	  							     AND F2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+CRLF
		cQFornec 	+= "	  							     AND D_E_L_E_T_ = ''"+CRLF
		cQFornec 	+= "	  							     AND F2_TIPO = 'D')"+CRLF

		if  MV_PAR05 == 1

			cQFornec 	+= "	) "+CRLF

		EndIf

	EndIf

	//1 Somente registros não exportados
	/*	if MV_PAR04 == 1 .AND. !lConsFor
			
			cQFornec		+= "AND  A2_XEXPCTB <> '1' "+CRLF			
		
		//3 Somente registros exportados			
		Elseif  MV_PAR04 == 3 .AND. !lConsFor
					
			cQFornec		+= "AND  A2_XEXPCTB = '1' "+CRLF		
							
		EndIf
		*/
	cQClient 	+= "	SELECT 'C' ORIGEM_C_F, A1_COD CODIGO, A1_LOJA LOJA, A1_PESSOA TIPO_F_J, A1_NOME NOME, A1_NREDUZ FANTASIA, A1_END ENDERECO,"+CRLF
	cQClient 	+= "				 A1_TIPO FINALIDADE_NEGOCIO, A1_EST UF,"+CRLF
	cQClient 	+= "					   	 (CASE "+CRLF
	cQClient 	+= "							WHEN A1_EST = 'EX' THEN (	SELECT CCH_PAIS "+CRLF
	cQClient 	+= "														FROM  "+RetSqlName("CCH")+" (NOLOCK)"+CRLF
	cQClient 	+= "														WHERE CCH_FILIAL  = ''"+CRLF
	cQClient 	+= "														 AND CCH_CODIGO = A1_CODPAIS"+CRLF
	cQClient 	+= "														 AND D_E_L_E_T_ = ''"+CRLF
	cQClient 	+= "													)"+CRLF
	cQClient 	+= "							ELSE ''"+CRLF
	cQClient 	+= "							END"+CRLF
	cQClient 	+= "						)AS PAISEXT"+CRLF
	cQClient 	+= "			   	,A1_ESTADO ESTADO, A1_COD_MUN  CMUNIBGE,A1_COMPLEM COMPLEMENTO,"+CRLF
	cQClient 	+= "				A1_MUN MUNICIPIO, A1_BAIRRO BAIRRO, A1_CEP CEP, A1_DDD DDD,A1_TEL TEL, "+CRLF
	cQClient 	+= "				A1_INSCR INSCRICAO_ESTADUAL,A1_CGC CPF_CNPJ,A1_INSCRM INSCRICAO_MUNICIPAL,"+CRLF
	cQClient 	+= "					(CASE "+CRLF
	cQClient 	+= "						WHEN LEN(RTRIM(A1_CONTA)) > 6  THEN (	SELECT CT1_RES "+CRLF
	cQClient 	+= "																FROM "+RetSqlName("CT1")+" (NOLOCK)"+CRLF
	cQClient 	+= "																WHERE CT1_FILIAL = '"+cFlCnCtb+"' "+CRLF
	cQClient 	+= "																  AND CT1_CONTA = A1_CONTA"+CRLF
	cQClient 	+= "																  AND D_E_L_E_T_ = '')			"+CRLF
	cQClient 	+= "						ELSE A1_CONTA"+CRLF
	cQClient 	+= "					END	 )"+CRLF
	cQClient 	+= "					AS CONTA_CONTABIL, "+CRLF
	cQClient 	+= "				A1_SUFRAMA CODIGO_SUFRAMA, A1_CODMUN CODIGO_MUNICIPIO_SUFRAMA,"+CRLF
	cQClient 	+= "				A1_CODPAIS CODIGO_PAIS_IBGE,"+CRLF
	cQClient 	+= "				A1_INSCRUR INSCRICAO_RURAL,"+CRLF
	cQClient 	+= "				A1_RECISS RECOLHE_ISS,A1_RECCSLL RECOLHE_CSLL,A1_RECPIS RECOLHE_PIS, A1_RECCOFI RECOLHE_COFINS, "+CRLF
	cQClient 	+= "				A1_RECINSS RECOLHE_INSS,A1_MINIRF MINIMO_IRRF,A1_RECIRRF RECOLHE_IRRF,A1_RECFET RECOLHE_FETB,"+CRLF
	cQClient 	+= "				A1_SIMPLES SIMPLES_NACIONAL,A1_IRBAX IRRF_BAIXA, A1_CONTRIB CONTRIBUINTE_ICMS,A1_SIMPNAC OPTANTE_SIMPLES_NACIONAL,"+CRLF
	cQClient 	+= "				"+RetSqlName("SA1")+".R_E_C_N_O_ AS RECNO "+CRLF
	cQClient 	+= "	FROM "+RetSqlName("SA1")+"  "+RetSqlName("SA1")+" (NOLOCK)"+CRLF
	cQClient 	+= "	WHERE A1_FILIAL = '"+cFlClien+"'"+CRLF
	cQClient 	+= "      AND "+RetSqlName("SA1")+".D_E_L_E_T_ = ''"+CRLF
	cQClient 	+= "	  AND  "+CRLF

	//1=Todos ou 3==Somente saida
	if !lConsCli

		if MV_PAR05 == 1

			cQClient 	+= "	( "+CRLF

		EndIf
		cQClient 	+= "	  		A1_COD+A1_LOJA IN(SELECT F2_CLIENTE+F2_LOJA"+CRLF
		cQClient 	+= "	  							  FROM  "+RetSqlName("SF2")+" (NOLOCK)"+CRLF
		cQClient 	+= "	  							  WHERE F2_FILIAL =  '"+cFlNFAtu+"' "+CRLF
		cQClient 	+= "	  							     AND F2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+CRLF
		cQClient 	+= "	  							     AND D_E_L_E_T_ = ''"+CRLF
		cQClient 	+= "	  							     AND F2_TIPO <> 'D')

	EndIf

	if MV_PAR05 == 1  .AND. !lConsCli

		cQClient 	+= "	  			OR"+CRLF

	EndIf

	//1=Todos ou 2==Somente entrada
	if (MV_PAR05 == 1 .OR. MV_PAR05 == 2) .AND. !lConsCli

		cQClient 	+= "		   	A1_COD+A1_LOJA IN (SELECT F1_FORNECE+F1_LOJA"+CRLF
		cQClient 	+= "	  							  FROM "+RetSqlName("SF1")+" (NOLOCK)"+CRLF
		cQClient 	+= "	  							  WHERE F1_FILIAL = '"+cFlNFAtu+"'"+CRLF
		cQClient 	+= "	  							     AND F1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+CRLF
		cQClient 	+= "	  							     AND D_E_L_E_T_ = ''"+CRLF
		cQClient 	+= "	  							     AND F1_TIPO = 'D')"+CRLF

	EndIf

	if MV_PAR05 == 1  .AND. !lConsCli

		cQClient 	+= ")"+CRLF

	EndIf

	//1 Somente registros não exportados
	if MV_PAR04 == 1 .AND. !lConsCli

		cQClient		+= "AND  A1_XEXPCTB <> '1' "+CRLF

		//3 Somente registros exportados
	Elseif  MV_PAR04 == 3 .AND. !lConsCli

		cQClient		+= "AND  A1_XEXPCTB = '1' "+CRLF

	EndIf

	if lConsCli

		cQClient		+= " A1_COD+A1_LOJA = '"+cFiltro+"' "+CRLF
		cQCliFor	:= cQClient

		cQCliFor := ChangeQuery(cQCliFor)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCliFor),cAliasNF,.T.,.T.)

	Elseif lConsFor

		cQFornec		+= " A2_COD+A2_LOJA = '"+cFiltro+"' "+CRLF
		cQCliFor	:= cQFornec

		cQCliFor := ChangeQuery(cQCliFor)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCliFor),cAliasNF,.T.,.T.)

	Elseif MV_PAR03 <> '003'

		if MV_PAR05 == 2

			cQCliFor	:= cQFornec

		Elseif MV_PAR05 == 3

			cQCliFor	:= cQClient

		Elseif MV_PAR05 == 1//1=Todos

			cQCliFor 	:= cQFornec+CRLF+"UNION"+CRLF+cQClient+CRLF

		EndIf

		cQCliFor := ChangeQuery(cQCliFor)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQCliFor),cAliaQry,.T.,.T.)

		Return cAliaQry

	EndIf

Return cAliasNF
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Selfor
(long_description)
@type function
@author Cris
@since 14/02/2017
@version 1.0
@param cAliasNF, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function Selfor(cAliasNF)

	Local 	cQCliFor	:= ''
	Local 	cQFornec	:= ''
	Local 	cQClient	:= ''
	Local 	cFiltro		:= ''
	Local 	lConsCli	:= .F.
	Local 	lConsFor	:= .F.
	Local	cFlNFAtu	:= xFilial("SD1")
	Local 	cFlClien	:= Iif(!Empty(Alltrim(xFilial("SA1"))),cFlNFAtu,xFilial("SA1"))
	Local 	cFlForne	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local 	cFlCnCtb	:= Iif(!Empty(Alltrim(xFilial("CT1"))),cFlNFAtu,xFilial("CT1"))
	Default cAliasNF	:= ''

	if !Empty(cAliasNF)

		cFiltro		:= (cAliaQry)->CLIEFOR+(cAliaQry)->LOJA

		if  ((cAliaQry)->MVTO == 'E' .AND. (cAliaQry)->TIPONF  == 'D') .OR. ((cAliaQry)->MVTO == 'S' .AND. (cAliaQry)->TIPONF  <> 'D')

			lConsCli	:= .T.

		Elseif   ((cAliaQry)->MVTO == 'E' .AND. (cAliaQry)->TIPONF  <> 'D') .OR. ((cAliaQry)->MVTO == 'S' .AND. (cAliaQry)->TIPONF  == 'D')

			lConsFor	:= .T.

		EndIf

	Else

		cAliasNF	:=	GetNextAlias()

	EndIf

	if  lConsFor

		cQFornec 	:= "	SELECT 'F' ORIGEM_C_F, A2_COD CODIGO, A2_LOJA LOJA, A2_TIPO TIPO_F_J, A2_NOME NOME, A2_NREDUZ FANTASIA, A2_END ENDERECO,"+CRLF
		cQFornec 	+= "				    '' AS FINALIDADE_NEGOCIO, A2_EST UF,"+CRLF
		cQFornec 	+= "						   	 (CASE "+CRLF
		cQFornec 	+= "								WHEN A2_EST = 'EX' THEN (	SELECT CCH_PAIS"+CRLF
		cQFornec 	+= "															FROM  "+RetSqlName("CCH")+" (NOLOCK)"+CRLF
		cQFornec 	+= "															WHERE CCH_FILIAL  = ''"+CRLF
		cQFornec 	+= "															 AND CCH_CODIGO = A2_CODPAIS"+CRLF
		cQFornec 	+= "															 AND D_E_L_E_T_ = ''"+CRLF
		cQFornec 	+= "														)"+CRLF
		cQFornec 	+= "								ELSE '' "+CRLF
		cQFornec 	+= "								END"+CRLF
		cQFornec 	+= "							)AS PAISEXT"+CRLF
		cQFornec 	+= "					,(SELECT X5_DESCRI "+CRLF
		cQFornec 	+= "					FROM "+RetSqlName("SX5")+" (NOLOCK)"+CRLF
		cQFornec 	+= "					WHERE X5_FILIAL = '"+xFilial('SX5')+"'"+CRLF
		cQFornec 	+= "					  AND X5_TABELA = '12'"+CRLF
		cQFornec 	+= "					  AND X5_CHAVE = A2_EST) ESTADO,"+CRLF
		cQFornec 	+= "		 			A2_COD_MUN  CMUNIBGE, A2_COMPLEM COMPLEMENTO,"+CRLF
		cQFornec 	+= "					A2_MUN MUNICIPIO, A2_BAIRRO BAIRRO, A2_CEP CEP, A2_DDD DDD,A2_TEL TEL, "+CRLF
		cQFornec 	+= "					A2_INSCR INSCRICAO_ESTADUAL,A2_CGC CPF_CNPJ,A2_INSCRM INSCRICAO_MUNICIPAL,"+CRLF
		cQFornec 	+= "					(CASE "+CRLF
		cQFornec 	+= "						WHEN LEN(RTRIM(A2_CONTA)) > 6  THEN (	SELECT CT1_RES "+CRLF
		cQFornec 	+= "																FROM "+RetSqlName("CT1")+" (NOLOCK)"+CRLF
		cQFornec 	+= "																WHERE CT1_FILIAL = '"+cFlCnCtb+"' "+CRLF
		cQFornec 	+= "																  AND CT1_CONTA = A2_CONTA"+CRLF
		cQFornec 	+= "																  AND D_E_L_E_T_ = '')			"+CRLF
		cQFornec 	+= "						ELSE A2_CONTA"+CRLF
		cQFornec 	+= "					END	 )"+CRLF
		cQFornec 	+= "					AS CONTA_CONTABIL, "+CRLF
		cQFornec 	+= "					'' CODIGO_SUFRAMA, A2_CODMUN CODIGO_MUNICIPIO_SUFRAMA,"+CRLF
		cQFornec 	+= "					A2_CODPAIS CODIGO_PAIS_IBGE,"+CRLF
		cQFornec 	+= "					'' INSCRICAO_RURAL, A2_CODSIAF CODSIAF,"+CRLF
		cQFornec 	+= "					A2_RECISS RECOLHE_ISS,A2_RECCSLL RECOLHE_CSLL,A2_RECPIS RECOLHE_PIS, A2_RECCOFI RECOLHE_COFINS, "+CRLF
		cQFornec 	+= "					A2_RECINSS RECOLHE_INSS,A2_MINIRF MINIMO_IRRF,'' MINIMO_IRRF, A2_RECFET RECOLHE_FETB,"+CRLF
		cQFornec 	+= "					'' SIMPLES_NACIONAL,'' IRRF_BAIXA, '' CONTRIBUINTE_ICMS,A2_SIMPNAC OPTANTE_SIMPLES_NACIONAL,"+CRLF
		cQFornec 	+= "					"+RetSqlName("SA2")+".R_E_C_N_O_ AS RECNO "+CRLF
		cQFornec 	+= "	FROM "+RetSqlName("SA2")+" "+RetSqlName("SA2")+" (NOLOCK)"+CRLF
		cQFornec 	+= "	WHERE A2_FILIAL = '"+cFlForne+"'"+CRLF
		cQFornec 	+= "	  AND "+RetSqlName("SA2")+".D_E_L_E_T_ = ''"+CRLF
		cQFornec	+= " 	  AND A2_COD+A2_LOJA = '"+cFiltro+"' "+CRLF

		cQFornec := ChangeQuery(cQFornec)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQFornec),cAliasNF,.T.,.T.)

	EndIF

	if lConsCli

		cQClient 	+= "	SELECT 'C' ORIGEM_C_F, A1_COD CODIGO, A1_LOJA LOJA, A1_PESSOA TIPO_F_J, A1_NOME NOME, A1_NREDUZ FANTASIA, A1_END ENDERECO,"+CRLF
		cQClient 	+= "				 A1_TIPO FINALIDADE_NEGOCIO, A1_EST UF,"+CRLF
		cQClient 	+= "					   	 (CASE "+CRLF
		cQClient 	+= "							WHEN A1_EST = 'EX' THEN (	SELECT CCH_PAIS "+CRLF
		cQClient 	+= "														FROM  "+RetSqlName("CCH")+" (NOLOCK)"+CRLF
		cQClient 	+= "														WHERE CCH_FILIAL  = ''"+CRLF
		cQClient 	+= "														 AND CCH_CODIGO = A1_CODPAIS"+CRLF
		cQClient 	+= "														 AND D_E_L_E_T_ = ''"+CRLF
		cQClient 	+= "													)"+CRLF
		cQClient 	+= "							ELSE ''"+CRLF
		cQClient 	+= "							END"+CRLF
		cQClient 	+= "						)AS PAISEXT"+CRLF
		cQClient 	+= "					,(SELECT X5_DESCRI "+CRLF
		cQClient 	+= "					FROM "+RetSqlName("SX5")+" (NOLOCK)"+CRLF
		cQClient 	+= "					WHERE X5_FILIAL = '"+xFilial('SX5')+"'"+CRLF
		cQClient 	+= "					  AND X5_TABELA = '12'"+CRLF
		cQClient 	+= "					  AND X5_CHAVE = A1_EST) ESTADO,"+CRLF
		cQClient	+= "				A1_COD_MUN  CMUNIBGE,A1_COMPLEM COMPLEMENTO,"+CRLF
		cQClient 	+= "				A1_MUN MUNICIPIO, A1_BAIRRO BAIRRO, A1_CEP CEP, A1_DDD DDD,A1_TEL TEL, "+CRLF
		cQClient 	+= "				A1_INSCR INSCRICAO_ESTADUAL,A1_CGC CPF_CNPJ,A1_INSCRM INSCRICAO_MUNICIPAL,"+CRLF
		cQClient 	+= "					(CASE "+CRLF
		cQClient 	+= "						WHEN LEN(RTRIM(A1_CONTA)) > 6  THEN (	SELECT CT1_RES "+CRLF
		cQClient 	+= "																FROM "+RetSqlName("CT1")+" (NOLOCK)"+CRLF
		cQClient 	+= "																WHERE CT1_FILIAL = '"+cFlCnCtb+"' "+CRLF
		cQClient 	+= "																  AND CT1_CONTA = A1_CONTA"+CRLF
		cQClient 	+= "																  AND D_E_L_E_T_ = '')			"+CRLF
		cQClient 	+= "						ELSE A1_CONTA"+CRLF
		cQClient 	+= "					END	 )"+CRLF
		cQClient 	+= "					AS CONTA_CONTABIL, "+CRLF
		cQClient 	+= "				A1_SUFRAMA CODIGO_SUFRAMA, A1_CODMUN CODIGO_MUNICIPIO_SUFRAMA,"+CRLF
		cQClient 	+= "				A1_CODPAIS CODIGO_PAIS_IBGE,"+CRLF
		cQClient 	+= "				A1_INSCRUR INSCRICAO_RURAL, '' CODSIAF, "+CRLF
		cQClient 	+= "				A1_RECISS RECOLHE_ISS,A1_RECCSLL RECOLHE_CSLL,A1_RECPIS RECOLHE_PIS, A1_RECCOFI RECOLHE_COFINS, "+CRLF
		cQClient 	+= "				A1_RECINSS RECOLHE_INSS,A1_MINIRF MINIMO_IRRF,A1_RECIRRF RECOLHE_IRRF,A1_RECFET RECOLHE_FETB,"+CRLF
		cQClient 	+= "				A1_SIMPLES SIMPLES_NACIONAL,A1_IRBAX IRRF_BAIXA, A1_CONTRIB CONTRIBUINTE_ICMS,A1_SIMPNAC OPTANTE_SIMPLES_NACIONAL,"+CRLF
		cQClient 	+= "				"+RetSqlName("SA1")+".R_E_C_N_O_ AS RECNO "+CRLF
		cQClient 	+= "	FROM "+RetSqlName("SA1")+"  "+RetSqlName("SA1")+" (NOLOCK)"+CRLF
		cQClient 	+= "	WHERE A1_FILIAL = '"+cFlClien+"'"+CRLF
		cQClient 	+= "      AND "+RetSqlName("SA1")+".D_E_L_E_T_ = ''"+CRLF
		cQClient	+= " 	  AND A1_COD+A1_LOJA = '"+cFiltro+"' "+CRLF

		cQClient := ChangeQuery(cQClient)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQClient),cAliasNF,.T.,.T.)

	EndIf

Return cAliasNF
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SelNFEnt
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SelNFEnt(aRetPara)

	Local cQNfs		:= ''
	Local cTabASF2	:= ''
	Local cTabASD2	:= ''
	Local cTabASF1	:= ''
	Local cTabASD1	:= ''
	Local cTabASA4	:= RetSqlName("SA4")
	Local cTabASB1	:= RetSqlName("SB1")
	Local cTabASF4	:= RetSqlName("SF4")
	Local cTabASA2	:= RetSqlName("SA2")
	Local cTabASA1	:= RetSqlName("SA1")
	Local cFlNFAtu	:= aRetPara[3]
	Local cFlCTES	:= Iif(!Empty(Alltrim(xFilial("SF4"))),cFlNFAtu,xFilial("SF4"))
	Local cFlProd	:= Iif(!Empty(Alltrim(xFilial("SB1"))),cFlNFAtu,xFilial("SB1"))
	Local cFlForne	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local cFlClien	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local cFlTrans	:= Iif(!Empty(Alltrim(xFilial("SA4"))),cFlNFAtu,xFilial("SA4"))

	cTabASF1	:=	RetSqlName("SF1")
	cTabASD1	:= 	RetSqlName("SD1")

	cQNfs	:= SlCpoSF1(cQNfs)
	cQNfs	:= SlCpoSD1(cQNfs)
	cQNfs	+= "			B1_ORIGEM,F4_CTIPI,F4_LFICM,F4_CREDICM, F4_LFIPI, F4_CSTPIS, F4_CSTCOF, F4_TPREG, F4_PISCRED,F4_CSOSN,  "+CRLF
	cQNfs	+= "			(CASE    "+CRLF
	cQNfs	+= "								  WHEN F1_TRANSP = '' THEN ''    "+CRLF
	cQNfs	+= "								  ELSE ISNULL((SELECT A4_CGC    "+CRLF
	cQNfs	+= "								 					FROM  "+cTabASA4+" "+cTabASA4+" (NOLOCK)   "+CRLF
	cQNfs	+= "													WHERE A4_FILIAL = '"+cFlTrans+"'   "+CRLF
	cQNfs	+= "								       				  AND A4_COD = F1_TRANSP    "+CRLF
	cQNfs	+= "								       				  AND "+cTabASA4+".D_E_L_E_T_ = ''    "+CRLF
	cQNfs	+= "									 		),'')	   "+CRLF
	cQNfs	+= "			 END   "+CRLF
	cQNfs	+= "			 )AS CGCTRANSP,   "+CRLF
	cQNfs	+= "		 "+cTabASF1+".R_E_C_N_O_ NFRECNO   "+CRLF
	cQNfs	+= "	FROM "+cTabASD1+" "+cTabASD1+" (NOLOCK) "+CRLF
	cQNfs	+= "	INNER JOIN  "+cTabASF1+" "+cTabASF1+" (NOLOCK) "+CRLF
	cQNfs	+= "			ON F1_FILIAL = '"+cFlNFAtu+"' "+CRLF
	cQNfs	+= "           AND F1_FILIAL = D1_FILIAL "+CRLF
	cQNfs	+= "           AND F1_DOC = D1_DOC "+CRLF
	cQNfs	+= "		   AND F1_SERIE = D1_SERIE "+CRLF
	cQNfs	+= "		   AND F1_FORNECE = D1_FORNECE "+CRLF
	cQNfs	+= "		   AND F1_LOJA = D1_LOJA "+CRLF
	cQNfs	+= "		   AND F1_SERIE = D1_SERIE "+CRLF
	cQNfs	+= "		   AND F1_DTDIGIT BETWEEN  '"+Dtos(aRetPara[1])+"' AND '"+Dtos(aRetPara[2])+"' "+CRLF
	cQNfs	+= "		   AND "+cTabASF1+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= "		   AND "+cTabASD1+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= "   INNER JOIN  "+cTabASB1+" "+cTabASB1+" (NOLOCK)  "+CRLF
	cQNfs	+= "           ON B1_FILIAL = '"+cFlProd+"'  "+CRLF
	cQNfs	+= "          AND B1_COD = D1_COD  "+CRLF
	cQNfs	+= "          AND "+cTabASB1+".D_E_L_E_T_ = ''  "+CRLF
	cQNfs	+= "   INNER JOIN  "+cTabASF4+" "+cTabASF4+" (NOLOCK)  "+CRLF
	cQNfs	+= "           ON F4_FILIAL = '"+cFlCTES+"'  "+CRLF
	cQNfs	+= "          AND F4_CODIGO = D1_TES  "+CRLF
	cQNfs	+= "          AND "+cTabASF4+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= " ORDER BY DTDIGIT,NOTAFISCAL,SERIE,ITEM "+CRLF

	cQNfs := ChangeQuery(cQNfs)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQNfs),cAliaQry,.T.,.T.)

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SlCpoSF2
(long_description)9
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@param cQNfs, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SlCpoSF2(cQNfs)

	cQNfs	+= " SELECT 'S' MVTO, F2_FILIAL FILIAL, F2_TIPO TIPONF, F2_DOC NOTAFISCAL,F2_SERIE SERIE, F2_CLIENTE CLIEFOR, F2_LOJA LOJA, F2_EST UF,"+CRLF
	cQNfs	+= " F2_EMISSAO EMISSAO,F2_DAUTNFE DTDIGIT,F2_FORMUL FORMULARIO, F2_ESPECIE ESPECIE,"+CRLF
	cQNfs	+= " 	(	CASE "+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'SPED'						THEN '55'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CTE'							THEN '57'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CF'							THEN '33'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'SATCE'						THEN '59'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'NTST'						THEN '22'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'NFSC' OR F2_ESPECIE = 'NTSC'	THEN '21'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'RMD'							THEN '18'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CTF'							THEN '11'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CA'							THEN '10'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CTA'							THEN '09'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'CTR'							THEN '08'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'NFST'						THEN '07'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'NFCEE'						THEN '02'"+CRLF
	cQNfs	+= " 		WHEN F2_ESPECIE = 'NF'							THEN '01'"+CRLF
	cQNfs	+= " 		ELSE '01' "+CRLF
	cQNfs	+= " 	END		"+CRLF
	cQNfs	+= " ) AS MODELONF,"+CRLF
	cQNfs	+= " F2_ESPECI1 ESPECI1,F2_CHVNFE CHVNFE,"+CRLF
	cQNfs	+= " F2_COND CONDPGTO, F2_DUPL DUPL,F2_PREFIXO PREFIXO, "+CRLF
	cQNfs	+= " F2_FRETE TVL_FRETE, F2_TRANSP TRANSP,  F2_ICMFRET TICMS_FRETE,'' PLACA, "+CRLF
	cQNfs	+= " 	(CASE F2_TPFRETE "+CRLF
	cQNfs	+= " 		WHEN 'S' THEN '0' "+CRLF
	cQNfs	+= " 		WHEN 'C' THEN '1' "+CRLF
	cQNfs	+= " 		WHEN 'F' THEN '2' "+CRLF
	cQNfs	+= " 		WHEN 'T' THEN '4' "+CRLF
	cQNfs	+= " 		ELSE '0' "+CRLF
	cQNfs	+= " 	END) AS TIPO_FRETE, "+CRLF
	cQNfs	+= " F2_SEGURO TVL_SEGURO,F2_DESCONT TVL_DESCONTO,F2_DESPESA TVL_DESPESA,"+CRLF
	cQNfs	+= " F2_VOLUME1 VOLUME1,F2_PLIQUI TPLIQUIDO,  F2_PBRUTO TPBRUTO, "+CRLF
	cQNfs	+= " F2_ICMSRET TICMS_RET, F2_BRICMS TBS_ICMS_SOL,"+CRLF
	cQNfs	+= " F2_ICMSDIF TICMS_DEFERIDO,"+CRLF
	cQNfs	+= " F2_BASEFUN TBS_FUNRURAL,F2_CONTSOC TVL_FUNRURAL,"+CRLF
	cQNfs	+= " F2_VLSENAR TVL_SENAR,"+CRLF
	cQNfs	+= " F2_DESCZFR TVL_DESC_ZFM,"+CRLF
	cQNfs	+= " F2_VALBRUT TVL_BRUTO, F2_VALMERC TVL_MERCADORIA,"+CRLF
	cQNfs	+= " F2_BASEICM TBS_ICMS,F2_VALICM TVL_ICMS, "+CRLF
	cQNfs	+= " F2_BASEIPI TBS_IPI,F2_VALIPI TVL_IPI, "+CRLF
	cQNfs	+= " F2_BASIMP1 TBS_IMP1,F2_VALIMP1 TVL_IMP1,"+CRLF
	cQNfs	+= " F2_BASIMP2 TBS_IMP2,F2_VALIMP2 TVL_IMP2,"+CRLF
	cQNfs	+= " F2_BASIMP3 TBS_IMP3,F2_VALIMP3 TVL_IMP3,"+CRLF
	cQNfs	+= " F2_BASIMP4 TBS_IMP4,F2_VALIMP4 TVL_IMP4,"+CRLF
	cQNfs	+= " F2_BASIMP5 TBS_COF_A,F2_VALIMP5 TVL_COF_A, F2_BASCOFI TBS_COF_R,F2_VALCOFI TVL_COF_R,F2_BASECF3 TBS_COF_ST, F2_VALCF3 TVL_COF_ST,"+CRLF
	cQNfs	+= " F2_BASIMP6 TBS_PIS_A,F2_VALIMP6 TVL_PIS_A, F2_BASPIS TBS_PIS_R, F2_VALPIS TVL_PIS_R,F2_BASEPS3 TBS_PIS_ST,F2_VALPS3 TVL_PIS_ST,"+CRLF
	cQNfs	+= " F2_BASCSLL TBS_CSLL,F2_VALCSLL TVL_CSLL, "+CRLF
	cQNfs	+= " F2_BASEIRR TBS_IRRF,F2_VALIRRF TVL_IRRF,"+CRLF
	cQNfs	+= " F2_BASEINS TBS_INSS, F2_VALINSS TVL_INSS,"+CRLF
	cQNfs	+= " F2_BASEISS TBS_ISS, F2_VALISS TVL_ISS,"+CRLF

Return cQNfs
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SlCpoSD2
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@param cQNfs, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SlCpoSD2(cQNfs)

	cQNfs	+= "	D2_ITEM ITEM,D2_COD PRODUTO, D2_UM UNIDADE, D2_QUANT QUANTIDADE,D2_TES TES, D2_CF CFOP,D2_TP TIPO_PRODUTO,"+CRLF
	cQNfs	+= "	D2_PRCVEN PRECO_VENDA, D2_PRUNIT PRECO_UNITARIO,"+CRLF
	cQNfs	+= "	D2_TOTAL TOTAL_ITEM,D2_VALBRUT VL_BRUTO,"+CRLF
	cQNfs	+= "	D2_SEGURO VL_SEGURO,D2_DESPESA VL_DESPESA,"+CRLF
	cQNfs	+= "	D2_VALFRE VL_FRETE,D2_ICMFRET ICMS_FRETE,"+CRLF
	cQNfs	+= "	D2_DESC VL_DESCONTO,"+CRLF
	cQNfs	+= "	D2_CLASFIS ORIGEM_CST, "+CRLF
	cQNfs	+= "	D2_NFORI NF_ORIGEM, D2_SERIORI SERIE_ORIGEM,"+CRLF
	cQNfs	+= "	D2_VALICM VL_ICMS, D2_PICM ALQ_ICMS,D2_BASEICM BS_ICMS,"+CRLF
	cQNfs	+= "	D2_BSSENAR BS_SENAR, D2_ALSENAR ALQ_SENAR,D2_VLSENAR VL_SENAR,"+CRLF
	cQNfs	+= "	D2_BASEFUN BS_FUNRURAL,D2_ALIQFUN ALQ_FUNRURAL,D2_VALFUN VL_FUNRURAL,"+CRLF
	cQNfs	+= "	D2_ICMSRET VL_ICMS_ST, D2_ALIQSOL ALIQ_SOLID,D2_BRICMS BS_ICMS_ST,D2_MARGEM MARGEM,"+CRLF
	cQNfs	+= "	D2_DESCZFR VL_DESC_ZFM,D2_DESCZFC VL_D_ZFM_COF, D2_DESCZFP VL_D_ZFM_PIS,"+CRLF
	cQNfs	+= "	D2_BASEIPI BS_IPI,D2_IPI ALQ_IPI,D2_VALIPI VL_IPI,"+CRLF
	cQNfs	+= "	D2_BASECSL BS_CSLL,D2_ALQCSL ALQ_CSLL,D2_VALCSL VL_CSLL,"+CRLF
	cQNfs	+= "	D2_BASIMP1 BS_IMP1,D2_ALQIMP1 ALQ_IMP1,D2_VALIMP1 VL_IMP1,"+CRLF
	cQNfs	+= "	D2_BASIMP2 BS_IMP2,D2_ALQIMP2 ALQ_IMP2,D2_VALIMP2 VL_IMP2,"+CRLF
	cQNfs	+= "	D2_BASIMP3 BS_IMP3,D2_ALQIMP3 ALQ_IMP3,D2_VALIMP3 VL_IMP3,"+CRLF
	cQNfs	+= "	D2_BASIMP4 BS_IMP4,D2_ALQIMP4 ALQ_IMP4,D2_VALIMP4 VL_IMP4,"+CRLF
	cQNfs	+= "	D2_BASIMP5 BS_COF_A,D2_ALQIMP5 ALQ_COF_A,D2_VALIMP5 VL_COF_A,D2_BASECOF BS_COF_R,D2_ALQCOF ALQ_COF_R,D2_VALCOF VL_COF_R,"+CRLF
	cQNfs	+= "	D2_BASECF3 BS_COF_ST,D2_ALIQPS3 ALQ_COF_ST, D2_VALPS3 VL_COF_ST,"+CRLF
	cQNfs	+= "	D2_BASIMP6 BS_PIS_A,D2_ALQIMP6 ALQ_PIS_A,D2_VALIMP6 VL_PIS_A,D2_BASEPIS BS_PIS_R,D2_ALQPIS ALQ_PIS_R,D2_VALPIS VL_PIS_R,"+CRLF
	cQNfs	+= "	D2_BASEPS3 BS_PIS_ST,D2_ALIQPS3 ALQ_PIS_ST, D2_VALPS3 VL_PIS_ST,"+CRLF
	cQNfs	+= "	0 BS_INSS,D2_ALIQINS ALQ_INSS,D2_VALINS VL_INSS,"+CRLF
	cQNfs	+= "	D2_BASEISS BS_ISS,D2_ALIQISS ALQ_ISS,D2_VALISS VL_ISS,"+CRLF
	cQNfs	+= "	D2_BASEIRR BS_IRRF,D2_ALQIRRF ALQ_IRRF,D2_VALIRRF VL_IRRF, "+CRLF
	cQNfs	+= "	D2_VLIMPOR VL_IMPORT, D2_PREEMB PRCEMB,D2_FCICOD CODIGO_FCI, "+CRLF
	cQNfs	+= "	D2_DIFAL VL_DIFAL, D2_PDORI P_DIFAL_ORIG, D2_PDDES P_DIFAL_DEST, D2_BASEDES BS_DIFAL, "+CRLF
	cQNfs	+= "	D2_VFCPDIF VL_DIFAL_FCP, "+CRLF

Return cQNfs
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SlCpoSF1
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@param cQNfs, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SlCpoSF1(cQNfs)

	cQNfs	+=	" SELECT 'E' MVTO, F1_FILIAL FILIAL, F1_TIPO TIPONF, F1_DOC NOTAFISCAL,F1_SERIE SERIE,'000' SUBSER,F1_FORNECE CLIEFOR, F1_LOJA LOJA, F1_EST UF,"+CRLF
	cQNfs	+=	"	 F1_EMISSAO EMISSAO,F1_DTDIGIT DTDIGIT,F1_FORMUL FORMULARIO, F1_ESPECIE ESPECIE,"+CRLF
	cQNfs	+=	"		(	CASE "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'SPED'						THEN '55' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NFE'	AND D1_CF <> '1933'		THEN '55' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'CTE'							THEN '57' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'CF'							THEN '33' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'SATCE'						THEN '59' "+CRLF
	cQNfs	+=	"			WHEN F1_ESPECIE = 'NTST'						THEN '22' "+CRLF
	cQNfs	+=	"			WHEN F1_ESPECIE = 'NFSC' OR F1_ESPECIE = 'NTSC'	THEN '21' "+CRLF
	cQNfs	+=	"			WHEN F1_ESPECIE = 'RMD'							THEN '18' "+CRLF
	cQNfs	+=	"			WHEN F1_ESPECIE = 'CTF'							THEN '11' "+CRLF
	cQNfs	+=	"			WHEN F1_ESPECIE = 'CA'							THEN '10' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'CTA'							THEN '09' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'CTR'							THEN '08' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NFST'						THEN '07' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NFCEE'						THEN '02' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NF'							THEN '01' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NFT'							THEN '22' "+CRLF
	cQNfs	+=	"	 		WHEN F1_ESPECIE = 'NFCE'						THEN '06' "+CRLF
	cQNfs	+=	"	 		ELSE '01'  "+CRLF
	cQNfs	+=	"	 	END		 "+CRLF
	cQNfs	+=	"	 ) AS MODELONF, "+CRLF
	cQNfs	+=	"	 F1_ESPECI1 ESPECI1,F1_CHVNFE CHVNFE, "+CRLF
	cQNfs	+=	"	 F1_COND CONDPGTO, F1_DUPL DUPL,F1_PREFIXO PREFIXO,  "+CRLF
	cQNfs	+=	"	 F1_FRETE TVL_FRETE, F1_TRANSP TRANSP,  0 TICMS_FRETE, F1_PLACA PLACA,  "+CRLF
	cQNfs	+=	"	 	(CASE F1_TPFRETE  "+CRLF
	cQNfs	+=	"	 		WHEN 'S' THEN '0'  "+CRLF
	cQNfs	+=	"			WHEN 'C' THEN '1' "+CRLF
	cQNfs	+=	"	 		WHEN 'F' THEN '2'  "+CRLF
	cQNfs	+=	"			WHEN 'T' THEN '4'  "+CRLF
	cQNfs	+=	"			ELSE '0'  "+CRLF
	cQNfs	+=	"		END) AS TIPO_FRETE,  "+CRLF
	cQNfs	+=	"	 F1_SEGURO TVL_SEGURO,F1_DESCONT TVL_DESCONTO,F1_DESPESA TVL_DESPESA, "+CRLF
	cQNfs	+=	"	 F1_VOLUME1 VOLUME1,F1_PLIQUI TPLIQUIDO,  F1_PBRUTO TPBRUTO,  "+CRLF
	cQNfs	+=	"	 F1_ICMSRET TICMS_RET, F1_BRICMS TBS_ICMS_SOL, "+CRLF
	cQNfs	+=	"	 0 TICMS_DEFERIDO, "+CRLF
	cQNfs	+=	"	 F1_BASEFUN TBS_FUNRURAL,F1_CONTSOC TVL_FUNRURAL, "+CRLF
	cQNfs	+=	"	F1_VLSENAR TVL_SENAR, "+CRLF
	cQNfs	+=	"	0 TVL_DESC_ZFM, "+CRLF
	cQNfs	+=	"	 F1_VALBRUT TVL_BRUTO, F1_VALMERC TVL_MERCADORIA, "+CRLF
	cQNfs	+=	"	 F1_BASEICM TBS_ICMS,F1_VALICM TVL_ICMS,  "+CRLF
	cQNfs	+=	"	 F1_BASEIPI TBS_IPI,F1_VALIPI TVL_IPI,  "+CRLF
	cQNfs	+=	"	 F1_BASIMP1 TBS_IMP1,F1_VALIMP1 TVL_IMP1, "+CRLF
	cQNfs	+=	"	 F1_BASIMP2 TBS_IMP2,F1_VALIMP2 TVL_IMP2, "+CRLF
	cQNfs	+=	"	 F1_BASIMP3 TBS_IMP3,F1_VALIMP3 TVL_IMP3, "+CRLF
	cQNfs	+=	"	 F1_BASIMP4 TBS_IMP4,F1_VALIMP4 TVL_IMP4, "+CRLF
	cQNfs	+=	"	 F1_BASIMP5 TBS_COF_A,F1_VALIMP5 TVL_COF_A, F1_BASCOFI TBS_COF_R,F1_VALCOFI TVL_COF_R,F1_BASECF3 TBS_COF_ST, F1_VALCF3 TVL_COF_ST, "+CRLF
	cQNfs	+=	"	 F1_BASIMP6 TBS_PIS_A,F1_VALIMP6 TVL_PIS_A, F1_BASPIS TBS_PIS_R, F1_VALPIS TVL_PIS_R,F1_BASEPS3 TBS_PIS_ST,F1_VALPS3 TVL_PIS_ST, "+CRLF
	cQNfs	+=	"	 F1_BASCSLL TBS_CSLL,F1_VALCSLL TVL_CSLL,  "+CRLF
	cQNfs	+=	"	 0 TBS_IRRF,0 TVL_IRRF, "+CRLF
	cQNfs	+=	"	 F1_BASEINS TBS_INSS, 0 TVL_INSS, "+CRLF
	cQNfs	+=	"	 0 TBS_ISS, 0 TVL_ISS, "+CRLF

Return cQNfs
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SlCpoSD1
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@param cQNfs, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SlCpoSD1(cQNfs)

	cQNfs	+=	"	 	D1_ITEM ITEM,D1_COD PRODUTO, D1_UM UNIDADE, D1_QUANT QUANTIDADE,D1_TES TES, "+CRLF
	cQNfs	+=	"	 	D1_CF CFOP, "+CRLF
	//cQNfs	+=	"	 	(CASE D1_CF  "+CRLF
	//cQNfs	+=	"	 		WHEN '1933' THEN ''  "+CRLF
	//cQNfs	+=	"			ELSE D1_CF "+CRLF
	//cQNfs	+=	"		END) AS CFOP,  "+CRLF
	cQNfs	+=	"	 	D1_TP TIPO_PRODUTO,D1_VUNIT PRECO_VENDA, 0 PRECO_UNITARIO, "+CRLF
	cQNfs	+=	"	 	D1_TOTAL TOTAL_ITEM,D1_TOTAL VL_BRUTO, "+CRLF
	cQNfs	+=	"	 	D1_SEGURO VL_SEGURO,D1_DESPESA VL_DESPESA, "+CRLF
	cQNfs	+=	"	 	D1_VALFRE VL_FRETE,0 ICMS_FRETE, "+CRLF
	cQNfs	+=	"	 	D1_VALDESC VL_DESCONTO, "+CRLF
	cQNfs	+=	"	 	D1_CLASFIS ORIGEM_CST, "+CRLF
	cQNfs	+=	"	 	D1_NFORI NF_ORIGEM, D1_SERIORI SERIE_ORIGEM, "+CRLF
	cQNfs	+=	"	 	D1_VALICM VL_ICMS, D1_PICM ALQ_ICMS,D1_BASEICM BS_ICMS, "+CRLF
	cQNfs	+=	"	 	D1_BSSENAR BS_SENAR, D1_ALSENAR ALQ_SENAR,D1_VLSENAR VL_SENAR, "+CRLF
	cQNfs	+=	"	 	D1_BASEFUN BS_FUNRURAL,D1_ALIQFUN ALQ_FUNRURAL,D1_VALFUN VL_FUNRURAL, "+CRLF
	cQNfs	+=	"	 	D1_ICMSRET VL_ICMS_ST, D1_ALIQSOL ALIQ_SOLID,D1_BRICMS BS_ICMS_ST,D1_MARGEM MARGEM, "+CRLF
	cQNfs	+=	"	 	0 VL_DESC_ZFM, 0 VL_D_ZFM_COF, 0 VL_D_ZFM_PIS, "+CRLF
	cQNfs	+=	"	 	D1_BASEIPI BS_IPI,D1_IPI ALQ_IPI,D1_VALIPI VL_IPI, "+CRLF
	cQNfs	+=	"	 	D1_BASECSL BS_CSLL,D1_ALQCSL ALQ_CSLL,D1_VALCSL VL_CSLL, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP1 BS_IMP1,D1_ALQIMP1 ALQ_IMP1,D1_VALIMP1 VL_IMP1, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP2 BS_IMP2,D1_ALQIMP2 ALQ_IMP2,D1_VALIMP2 VL_IMP2, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP3 BS_IMP3,D1_ALQIMP3 ALQ_IMP3,D1_VALIMP3 VL_IMP3, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP4 BS_IMP4,D1_ALQIMP4 ALQ_IMP4,D1_VALIMP4 VL_IMP4, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP5 BS_COF_A,D1_ALQIMP5 ALQ_COF_A,D1_VALIMP5 VL_COF_A,D1_BASECOF BS_COF_R,D1_ALQCOF ALQ_COF_R,D1_VALCOF VL_COF_R, "+CRLF
	cQNfs	+=	"	 	D1_BASECF3 BS_COF_ST,D1_ALIQPS3 ALQ_COF_ST, D1_VALPS3 VL_COF_ST, "+CRLF
	cQNfs	+=	"	 	D1_BASIMP6 BS_PIS_A,D1_ALQIMP6 ALQ_PIS_A,D1_VALIMP6 VL_PIS_A,D1_BASEPIS BS_PIS_R,D1_ALQPIS ALQ_PIS_R,D1_VALPIS VL_PIS_R, "+CRLF
	cQNfs	+=	"	 	D1_BASEPS3 BS_PIS_ST,D1_ALIQPS3 ALQ_PIS_ST, D1_VALPS3 VL_PIS_ST, "+CRLF
	cQNfs	+=	"	 	0 BS_INSS,D1_ALIQINS ALQ_INSS,D1_VALINS VL_INSS, "+CRLF
	cQNfs	+=	"	 	D1_BASEISS BS_ISS,D1_ALIQISS ALQ_ISS,D1_VALISS VL_ISS, "+CRLF
	cQNfs	+=	"	 	D1_BASEIRR BS_IRRF,0 ALQ_IRRF,0 VL_IRRF,  "+CRLF
	cQNfs	+=	"	 	0 VL_IMPORT, '' PRCEMB,D1_FCICOD CODIGO_FCI,"+CRLF
	cQNfs	+=  "		D1_DIFAL VL_DIFAL, D1_PDORI P_DIFAL_ORIG, D1_PDDES P_DIFAL_DEST, D1_BASEDES BS_DIFAL, "+CRLF
	cQNfs	+=  "	    D1_VFCPDIF VL_DIFAL_FCP, "+CRLF

Return cQNfs
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} Layout
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function Layout(aLayout,cFin,cCodLay)

	Local cQryZ02	:= ''
	Local cTabZ02	:= GetNextAlias()
	Local aTtTpReg	:= {}
	Local aFuncoes	:= {}
	Local aLayAtu	:= {}
	Local nCpTpReg	:= 1
	Local nOrdExec	:= 0
	Local nOrdMnt	:= 0
	Local nPosZ02	:= 0
	Local cTipoReg	:= ''
	Local cFuncao	:= ''

	cQryZ02	:= 	"	SELECT Z02_TPREG, Z02_POSINI, Z02_POSFIM, Z02_CPODE, Z02_CPTBOG, Z02_TIPO, Z02_TAMANH, Z02_DEC,"+CRLF
	cQryZ02	+=	"			 Z02_CNTFIX,Z02_PREENC, Z02_LADO,Z02_ORDEXE, Z02_ORDMNT,Z02_FUNCAO,Z02_NCPREG,"+CRLF
	cQryZ02	+=	"			 Z02_CARESP, Z02_FORMAT "+CRLF
	cQryZ02	+=	" 	FROM "+RetSqlName('Z02')+" (NOLOCK)"+CRLF
	cQryZ02	+=	"	WHERE Z02_FILIAL = ''"+CRLF
	cQryZ02	+=	"	  AND Z02_FINALI = '"+cFin+"' "+CRLF
	cQryZ02	+=	"	  AND Z02_LAYOUT = '"+cCodLay+"' "+CRLF
	cQryZ02	+=	"	  AND Z02_ATIVO = 'S'"+CRLF
	cQryZ02	+=	"	  AND D_E_L_E_T_ = ''"+CRLF
	cQryZ02	+=	"	ORDER BY  Z02_ORDEXE, Z02_TPREG,Z02_NCPREG "+CRLF

	cQryZ02 := ChangeQuery(cQryZ02)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ02),cTabZ02,.T.,.T.)

	if !(cTabZ02)->(Eof())

		cTipoReg	:= (cTabZ02)->Z02_TPREG
		nOrdExec	:= (cTabZ02)->Z02_ORDEXE
		nOrdMnt		:= (cTabZ02)->Z02_ORDMNT

		if !Empty((cTabZ02)->Z02_FUNCAO)

			cFuncao		:= Alltrim((cTabZ02)->Z02_FUNCAO)
			aAdd(aFuncoes,{cTipoReg,(cTabZ02)->Z02_NCPREG,cFuncao})

		EndIf

		While !(cTabZ02)->(Eof())

			aAdd(aLayAtu,{(cTabZ02)->Z02_TPREG,(cTabZ02)->Z02_POSINI,(cTabZ02)->Z02_POSFIM,(cTabZ02)->Z02_CPODE,(cTabZ02)->Z02_NCPREG,;
				(cTabZ02)->Z02_CPTBOG,(cTabZ02)->Z02_TIPO,(cTabZ02)->Z02_TAMANH,(cTabZ02)->Z02_DEC,(cTabZ02)->Z02_CNTFIX,;
				(cTabZ02)->Z02_PREENC,(cTabZ02)->Z02_LADO,(cTabZ02)->Z02_ORDEXE,(cTabZ02)->Z02_ORDMNT,;
				(cTabZ02)->Z02_FUNCAO, (cTabZ02)->Z02_CARESP, (cTabZ02)->Z02_FORMAT})

			(cTabZ02)->(dbSkip())

			//Adiciona as funçoes que devem ser executadas
			if cFuncao <> Alltrim((cTabZ02)->Z02_FUNCAO) .AND. !Empty((cTabZ02)->Z02_FUNCAO)

				aAdd(aFuncoes,{cTipoReg,(cTabZ02)->Z02_NCPREG,cFuncao})
				cFuncao		:= Alltrim((cTabZ02)->Z02_FUNCAO)

			EndIf

			//Adiciona a quantidade de campos para cada Tipo de Registro
			//Adiciona a ordem de execução da leitura
			//Adiciona a ordem  de montagem
			if (cTabZ02)->Z02_TPREG <> cTipoReg

				aAdd(aTtTpReg,{(cTabZ02)->Z02_TPREG,nCpTpReg,nOrdExec,nOrdMnt})
				aAdd(aLayout,aLayAtu)
				nCpTpReg	:= 1
				cTipoReg	:= (cTabZ02)->Z02_TPREG
				nOrdExec	:= (cTabZ02)->Z02_ORDEXE
				nOrdMnt		:= (cTabZ02)->Z02_ORDMNT
				aLayAtu		:= {}

			Else
				nCpTpReg	:= nCpTpReg + 1

			EndIf

		EndDo

	EndIf

	(cTabZ02)->(dbCloseARea())

Return {aLayout,aTtTpReg,aFuncoes}
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} SelDirGrv
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function SelDirGrv(cNomeArq)

	Local lDirArq  		:= .T.
	Local lNAborta		:= .T.
	Private nLastKey	:= 0

	if Empty(cDirArq)

		cDirArq := cGetFile("","Diretório para gravação",1,,.F.,GETF_LOCALHARD+GETF_RETDIRECTORY )

	EndIf

	If nLastKey == 27

		lDirArq	:= .F.
		HELP("HELP",, 'Seleção do diretório',, "Operação abortada pelo usuário!", 1, 0)

		Return lDirArq
	Endif

	If !ExistDir(cDirArq)

		While !ExistDir(cDirArq) .AND. lNAborta

			if (lNAborta :=	MsgYesNo('Diretório não existe deseja criá-lo?'))

				MakeDir(cDirArq)
				//possibilitar alterar o nome? ou o diretorio? ou o diretorio e a nome?
			EndIf

		EndDo

	EndIf

	if (nHdlArq := FCreate(cDirArq+cNomeArq, FC_NORMAL)) < 0

		lDirArq	:= .F.
		HELP("HELP",, 'Criação do Arquivo',, ("Erro ao criar arquivo: " + Str(Ferror())), 1, 0)

	EndIf

	if FT_FUse(cDirArq+cNomeArq) < 0

		lDirArq	:= .F.
		HELP("HELP",, 'Criação do Arquivo',, "O arquivo criado não pode ser aberto. Operação Abortada. Verifique suas permissões de acesso.", 1, 0)

	EndIf

Return lDirArq
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ${MntArqPd}
(long_description)
@type function
@author CriADMIN
@since 01/09/2016
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/ 
//---------------------------------------------------------------------------------------------------------------------------
Static Function MntArqPd(aConfLay)

	Local aLayout		:= aConfLay[1]
	Local aOrdemExec	:= aConfLay[2]
	Local aCpoXFunc		:= aConfLay[3] //usar o ExecBlock
	Local aTpReg1		:= {array(len(aLayout[1]))}
	Local aTpReg2		:= {array(len(aLayout[2]))}
	Local aTpReg3		:= {array(len(aLayout[3]))}
	Local nLayout		:= 0
	Local lVerOExec		:= .F.
	Local aConteudo		:= {}

	aTpReg1[1][1]	:= ''
	aTpReg2[1][6] 	:= ''
	aTpReg3[1][1]	:= ''

	/*se layout possui:
		  mais que um tipo de registro (Z02_TPREG) e 
		   (exige ordem de execução Z02_ORDEXEC ou 
		   ordem de tipos de registros (Z02_ORDMNT))
	  	  Efetua algumas verificaçoes antes da leitura dos resultados da query
		*/
	//se um tipo de registro for configurado a ordem de execução todos  os demais também deverão ser configurados. Colocar a regra no cadastro.
	if aOrdemExec[1][3] <> 0

		lVerOExec	:= .T.

	EndIf

	(cAliaQry)->(dbGotop())
	While !(cAliaQry)->(Eof())

		if (len(aTabRec) > 0 .AND. (Ascan(aTabRec,{|x| x[2] == (cAliaQry)->SB1RECNO})) == 0) .OR. len(aTabRec) == 0

			aAdd(aTabRec,{'SB1',(cAliaQry)->SB1RECNO})

		EndIf

		aTpReg1	:= 	PrenReg1(aTpReg1,array(len(aLayout[1])))
		aTpReg2	:=  PrenReg2(aTpReg2,array(len(aLayout[2])))
		aTpReg3	:= 	PrenReg3(aTpReg3,array(len(aLayout[3])))

		(cAliaQry)->(dbSkip())

	EndDo

	aTpReg1	:= AjustReg(aTpReg1,aLayout[1])
	aAdd(aConteudo,aTpReg1)
	//nTtLinh		:= nTtLinh+nItTpReg
	//nItTpReg	:= 0
	aTpReg1		:= {}

	aTpReg2		:= AjustReg(aTpReg2,aLayout[2])
	//nTtLinh		:= nTtLinh+nItTpReg
	aAdd(aConteudo,aTpReg2)
	//nItTpReg	:= 0
	aTpReg2		:= {}

	aTpReg3		:= AjustReg(aTpReg3,aLayout[3])
	aAdd(aConteudo,aTpReg3)
	nTtLinh		:= nTtLinh+nItTpReg
	nItTpReg	:= 0
	aTpReg3		:= {}

	cArqAtu	:= 	"ITEM_"+Dtos(dDatabase)+'_'+StrTran(Alltrim(Time()),":", "_")+".TXT"

	if SelDirGrv(cArqAtu)

		FWMsgRun(,{||  DescReg(aConteudo,len(aConteudo)) },'Aguarde....' ,'Gravando linhas no arquivo')

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ${function_method_class_name}
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 07/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AlqInt()

	Local 	cAliqEst	:= GetMV('MV_ESTICM')
	Local 	cFilAtu		:= cFilAnt
	Local   cFilSM0		:= iif(!Empty(MV_PAR10), MV_PAR10, cFilAnt)
	Local   cUFFilAtu	:= ''

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	if SM0->(dbSeek(cEmpAnt+cFilSM0))

		cUFFilAtu := SM0->M0_ESTENT

	EndIf

	SM0->(dbSeek(cEmpAnt+cFilAtu))

Return val(substring(cAliqEst,RAT(cUFFilAtu,cAliqEst)+2,2))
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} PrenReg1
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@param aTpReg1, array, (Descrição do parâmetro)
@param aTpReg1Ax, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function PrenReg1(aTpReg,aTpRegAx)

	Local nPosAtu	:= 1

	if Empty(aTpReg[nPosAtu][1])

		aTpReg[nPosAtu][1] 	:= (cAliaQry)->UNIDADE
		aTpReg[1][2]	:= (cAliaQry)->AH_DESCPO

	Elseif Ascan(aTpReg,{|x| x[1] == (cAliaQry)->UNIDADE}) == 0

		if !Empty(aTpReg[nPosAtu][1])

			aAdd(aTpReg,aTpRegAx)

		EndIf

		nPosAtu	:= len(aTpReg)

		aTpReg[nPosAtu][1]	:= (cAliaQry)->UNIDADE
		aTpReg[nPosAtu][2]	:= (cAliaQry)->AH_DESCPO

	EndIf

Return aTpReg
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} PrenReg2
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 02/09/2016
@version 1.0
@param ${param}, ${param_type}, ${param_descr}
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function PrenReg2(aTpReg,aTpRegAx)

	Local nPosAtu	:= 1
	Local nPosPrd	:= 0
	Local nAliqIcm	:= AlqInt()//MV_ESTICM

	if Empty(aTpReg[nPosAtu][1])

		nPosAtu	:= 1

	Elseif (nPosPrd	:= Ascan(aTpReg,{|x| Alltrim(x[6]) == Alltrim((cAliaQry)->B1_COD) })) == 0

		if !Empty(aTpReg[nPosAtu][1])

			aAdd(aTpReg,aTpRegAx)

		EndIf

	EndIf

	if nPosPrd == 0 .OR. Len(aTpReg) == 1

		nPosAtu	:= len(aTpReg)

		aTpReg[nPosAtu][01] 	:= '0'//(cAliaQry)->B1_CORD// não existe mais
		aTpReg[nPosAtu][02]		:= (cAliaQry)->B1_DESC
		aTpReg[nPosAtu][03]		:= (cAliaQry)->B1_POSIPI

		if len(Alltrim((cAliaQry)->UNIDADE)) <= 4

			aTpReg[nPosAtu][04]		:= (cAliaQry)->UNIDADE

		Else

			aTpReg[nPosAtu][13]		:= (cAliaQry)->UNIDADE

		EndIf
		aTpReg[nPosAtu][05]		:= (cAliaQry)->B1_PESO
		aTpReg[nPosAtu][06] 	:= (cAliaQry)->B1_COD
		aTpReg[nPosAtu][07] 	:= (cAliaQry)->B1_TIPO
		aTpReg[nPosAtu][15]		:= (cAliaQry)->ALIQUOTA_IPI

	EndIf

	//Quando já existir o produto, atualiza somente os campos  conforme o tipo de movimentação
	if nPosPrd <> 0

		nPosAtu	:= nPosPrd

	EndIf
	//Verifica se a movimentação é configurada para o simples Nacional
	If !Empty(Alltrim((cAliaQry)->F4_CSOSN))

		aTpReg[nPosAtu][16]		:= 'S'

		if (cAliaQry)->MVTO == 'E'

			aTpReg[nPosAtu][09]		:= (cAliaQry)->F4_CSOSN //entrada
			aTpReg[nPosAtu][10]		:= (cAliaQry)->F4_CTIPI  //entrada
			aTpReg[nPosAtu][19]		:= (cAliaQry)->F4_CSTPIS
			aTpReg[nPosAtu][20]		:= (cAliaQry)->F4_CSTCOF

		Else

			aTpReg[nPosAtu][11]		:= (cAliaQry)->F4_CSOSN //saida
			aTpReg[nPosAtu][12]		:= (cAliaQry)->F4_CTIPI  //saida
			aTpReg[nPosAtu][14]		:= nAliqIcm//(cAliaQry)->ALIQUOTA_ICMS
			aTpReg[nPosAtu][21]		:= (cAliaQry)->F4_CSTPIS
			aTpReg[nPosAtu][22]		:= (cAliaQry)->F4_CSTCOF

		EndIf

	Else

		aTpReg[nPosAtu][16]		:= 'N'

		if (cAliaQry)->MVTO == 'E'

			aTpReg[nPosAtu][09]		:= (cAliaQry)->F4_SITTRIB //entrada
			aTpReg[nPosAtu][10]		:= (cAliaQry)->F4_CTIPI  //entrada
			aTpReg[nPosAtu][19]		:= (cAliaQry)->F4_CSTPIS
			aTpReg[nPosAtu][20]		:= (cAliaQry)->F4_CSTCOF

		Else

			aTpReg[nPosAtu][11]		:= (cAliaQry)->F4_SITTRIB //saida
			aTpReg[nPosAtu][12]		:= (cAliaQry)->F4_CTIPI  //saida
			aTpReg[nPosAtu][14]		:= nAliqIcm//(cAliaQry)->ALIQUOTA_ICMS
			aTpReg[nPosAtu][21]		:= (cAliaQry)->F4_CSTPIS
			aTpReg[nPosAtu][22]		:= (cAliaQry)->F4_CSTCOF

		EndIf

	EndIf

	//Aliquota de PIS diferenciada
	if (cAliaQry)->F4_CSTPIS $'02|03'

		aTpReg[nPosAtu][24]	:= 0

	EndIf

	//Aliquota da COFINS diferenciada
	if (cAliaQry)->F4_CSTCOF $'02|03'

		aTpReg[nPosAtu][25]	:= 0

	EndIf

	aTpReg[nPosAtu][28]		:= (cAliaQry)->B1_CEST

Return aTpReg
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} PrenReg3
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 02/09/2016
@version 1.0
@param aTpReg, array, (Descrição do parâmetro)
@param aTpRegAx, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function PrenReg3(aTpReg,aTpRegAx)

	Local nPosAtu	:= 1
	Local nPosPrd	:= 0

	if Empty(aTpReg[nPosAtu][1])

		nPosAtu	:= 1

	Elseif (nPosPrd	:= Ascan(aTpReg,{|x| Alltrim(x[2]) == Alltrim((cAliaQry)->B1_COD) })) == 0

		if !Empty(aTpReg[nPosAtu][1])

			aAdd(aTpReg,aTpRegAx)

		EndIf

	EndIf

	if nPosPrd == 0 .OR. (len(aTpReg) == 1)

		nPosAtu	:= len(aTpReg)

		//aTpReg[nPosAtu][01] 	:= (cAliaQry)->B1_CORD
		aTpReg[nPosAtu][02]		:= (cAliaQry)->B1_COD

		if Empty(Alltrim((cAliaQry)->B1_SEGUM))

			aTpReg[nPosAtu][03]		:= (cAliaQry)->UNIDADE

		EndIf

		if (cAliaQry)->B1_CONV == 0

			aTpReg[nPosAtu][04]		:= 1.0

		Else

			aTpReg[nPosAtu][04]		:= 	(cAliaQry)->B1_CONV

		EndIf

	EndIf


Return aTpReg
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} MntArqCF
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 02/09/2016
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MntArqCF(aConfLay,cAliaQry)

	Local aConteudo		:= {}
	Local aLayout		:= aConfLay[1]
	Local aCpoXFunc		:= aConfLay[3]
	Local aTpReg1		:= {}
	Local aEndNum		:= {}
	Local nLayout		:= 0


	(cAliaQry)->(dbGotop())
	While !(cAliaQry)->(Eof())

		aAdd(aTpReg1,array(len(aLayout[1])))

		nPosAtu	:= len(aTpReg1)

		//Caso seja consumidor final chumba CPF/CNPJ
		if  ((cAliaQry)->FINALIDADE_NEGOCIO == 'F' .AND. (cAliaQry)->TIPO_F_J == 'F') .OR. (cAliaQry)->UF = 'EX'

			aTpReg1[nPosAtu][01]	:= '99.999.999/9999-99'
			aTpReg1[nPosAtu][23]	:= 1//1-Pessoa Jurídica de Direito privado

		Else

			If (cAliaQry)->TIPO_F_J == 'J'

				aTpReg1[nPosAtu][01]	:= Transform((cAliaQry)->CPF_CNPJ,'@R 99.999.999/9999-99')
				aTpReg1[nPosAtu][23]	:= 1//1-Pessoa Jurídica de Direito privado

			Elseif  (cAliaQry)->TIPO_F_J == 'F'

				aTpReg1[nPosAtu][01]	:= Transform((cAliaQry)->CPF_CNPJ,'@R 999.999.999-99')
				aTpReg1[nPosAtu][23]	:= 1//1-Pessoa Jurídica de Direito privado
			EndIf

		EndIf
		aTpReg1[nPosAtu][02]	:= (cAliaQry)->NOME
		aTpReg1[nPosAtu][03]	:= (cAliaQry)->FANTASIA
		aTpReg1[nPosAtu][04]	:= (cAliaQry)->UF

		if Empty((cAliaQry)->INSCRICAO_ESTADUAL)

			aTpReg1[nPosAtu][05]	:= 'ISENTO'

		Else

			aTpReg1[nPosAtu][05]	:= (cAliaQry)->INSCRICAO_ESTADUAL

		EndIf

		//Efetuar tratamento para retirar o numero do endereço
		aEndNum	:= AdeqEnd(Alltrim((cAliaQry)->ENDERECO),aEndNum)
		aTpReg1[nPosAtu][06]	:= aEndNum[1]
		aTpReg1[nPosAtu][19]	:= aEndNum[2]
		aTpReg1[nPosAtu][20]	:= aEndNum[3]+' '+Alltrim((cAliaQry)->COMPLEMENTO)
		aEndNum	:= {}

		aTpReg1[nPosAtu][07]	:= (cAliaQry)->BAIRRO
		aTpReg1[nPosAtu][08]	:= (cAliaQry)->ESTADO
		aTpReg1[nPosAtu][09]	:= (cAliaQry)->CEP
		//aTpReg1[nPosAtu][10]	:= (cAliaQry)->CMUNIBGE
		aTpReg1[nPosAtu][11]	:= (cAliaQry)->DDD
		aTpReg1[nPosAtu][12]	:= (cAliaQry)->TEL

		//preenche campo de conta contabil na posição conforme
		//origem da informação ser vinculada ao cliente ou ao
		//fornecedor
		if (cAliaQry)->ORIGEM_C_F == 'C'

			aAdd(aTabRec,{'SA1',(cAliaQry)->RECNO})

			aTpReg1[nPosAtu][13]	:= (cAliaQry)->CONTA_CONTABIL

		else

			aAdd(aTabRec,{'SA2',(cAliaQry)->RECNO})

			aTpReg1[nPosAtu][15]	:= (cAliaQry)->CONTA_CONTABIL

		EndIf

		//Verifica se é produto rural ou não
		if  (cAliaQry)->FINALIDADE_NEGOCIO == 'L'

			aTpReg1[nPosAtu][17]	:= 'S'

		Else

			aTpReg1[nPosAtu][17]	:= 'N'

		EndIf

		//Se  for um cadastro do exterior
		if (cAliaQry)->UF = 'EX'

			aTpReg1[nPosAtu][18]	:= (cAliaQry)->CODIGO

		EndIf

		aTpReg1[nPosAtu][21]	:= (cAliaQry)->CODIGO_SUFRAMA
		aTpReg1[nPosAtu][22]	:= (cAliaQry)->CODIGO_PAIS_IBGE
		aTpReg1[nPosAtu][24]	:= UFMnIBGE((cAliaQry)->UF)+(cAliaQry)->CMUNIBGE

		(cAliaQry)->(dbSkip())

	EndDo

	aTpReg1	:= AjustReg(aTpReg1,aLayout[1])
	aAdd(aConteudo,aTpReg1)
	nTtLinh		:= IIf(ValType(nItTpReg)<>'N',0,nItTpReg)
	nItTpReg	:= 0
	aTpReg1		:= {}

	cArqAtu	:= 	"CLIFOR_"+Dtos(dDatabase)+'_'+StrTran(Alltrim(Time()),":", "_")+".TXT"

	if SelDirGrv(cArqAtu)

		FWMsgRun(,{||  DescReg(aConteudo,len(aConteudo)) },'Aguarde....' ,'Gravando linhas no arquivo')

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} UFMnIBGE
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 13/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function UFMnIBGE(cUFAtu)

	Local cCodIBGE	:= ''

	if cUFAtu == 'AC'
		cCodIBGE	:=	'12'
	Elseif cUFAtu == 'AL'
		cCodIBGE	:=	'27'
	Elseif cUFAtu == 'AP'
		cCodIBGE	:=	'16'
	Elseif cUFAtu == 'AM'
		cCodIBGE	:=	'13'
	Elseif cUFAtu == 'BA'
		cCodIBGE	:=	'29'
	Elseif cUFAtu == 'CE'
		cCodIBGE	:=	'23'
	Elseif cUFAtu == 'DF'
		cCodIBGE	:=	'53'
	Elseif cUFAtu == 'ES'
		cCodIBGE	:=	'32'
	Elseif cUFAtu == 'GO'
		cCodIBGE	:=	'52'
	Elseif cUFAtu == 'MA'
		cCodIBGE	:=	'21'
	Elseif cUFAtu == 'MT'
		cCodIBGE	:=	'51'
	Elseif cUFAtu == 'MS'
		cCodIBGE	:=	'50'
	Elseif cUFAtu == 'MG'
		cCodIBGE	:=	'31'
	Elseif cUFAtu == 'PA'
		cCodIBGE	:=	'15'
	Elseif cUFAtu == 'PB'
		cCodIBGE	:=	'25'
	Elseif cUFAtu == 'PR'
		cCodIBGE	:=	'41'
	Elseif cUFAtu == 'PE'
		cCodIBGE	:=	'26'
	Elseif cUFAtu == 'PI'
		cCodIBGE	:=	'22'
	Elseif cUFAtu == 'RJ'
		cCodIBGE	:=	'33'
	Elseif cUFAtu == 'RN'
		cCodIBGE	:=	'24'
	Elseif cUFAtu == 'RS'
		cCodIBGE	:=	'43'
	Elseif cUFAtu == 'RO'
		cCodIBGE	:=	'11'
	Elseif cUFAtu == 'RR'
		cCodIBGE	:=	'14'
	Elseif cUFAtu == 'SC'
		cCodIBGE	:=	'42'
	Elseif cUFAtu == 'SP'
		cCodIBGE	:=	'35'
	Elseif cUFAtu == 'SE'
		cCodIBGE	:=	'28'
	Elseif cUFAtu == 'TO'
		cCodIBGE	:=	'17'
	Endif

Return cCodIBGE
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AdeqEnd
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 06/09/2016
@version 1.0
@param cEndAtu, character, (Descrição do parâmetro)
@param aEndNum, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AdeqEnd(cEndAtu,aEndNum)

	Local cTrecho	:= ''
	Local cEndTxt	:= ''
	Local cDigAtu	:= ''
	Local lEndTxt	:= .F.
	Local cNumEnd	:= ''
	Local cCompl	:= ''
	Local nEndAtu	:= 0

	For nEndAtu		:= 1 to len(cEndAtu)

		cDigAtu :=  Substring(cEndAtu,nEndAtu,1)

		if cDigAtu == ',' .AND. !lEndTxt

			cTrecho	:= ''
			lEndTxt	:= .T.

		Elseif lEndTxt

			//Considerando que depois da virgula somente será informado o numero  ou S/N ou outros caracteres, e se existir bloco utilizando numero o mesmo
			//deverá ser informado no campo complemento.
			if !Empty(cDigAtu) .AND. (StrZero(val(cDigAtu),1) $ '1|2|3|4|5|6|7|8|9' .OR. cDigAtu == '0') .AND. Empty(cCompl)

				cNumEnd	:= cNumEnd+cDigAtu

			Else

				cCompl	:= cCompl+cDigAtu

			EndIf

		Else

			cEndTxt	:= cEndTxt + cDigAtu

		EndIf

	Next nEndAtu

	//conteudo com o endereço sem o numero e sem complemento
	aAdd(aEndNum,cEndTxt)
	//conteudo com o numero
	aAdd(aEndNum,cNumEnd)
	//conteúdo com o complemento caso exista ou se nao existe numero com conteudo numerico joga a informaçao de S/N (sem numero) no complemento
	if Empty(cNumEnd)

		aAdd(aEndNum,'S/N'+cCompl)

	Else

		aAdd(aEndNum,cCompl)

	EndIf

Return aEndNum
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} AjustReg
(Em troca de arquivo TXT  o conteudo de cada campo sempre será do tipo caracter, porém, na origem e no destino os tipos poderam
ser diferentes e os tamanhos também, para isto a rotina foi desenvolvida para ajustar o conteudo até o formato permitido.
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@param aDdRegA, array, (Descrição do parâmetro)
@param aLayoutA, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AjustReg(aDdRegA,aLayoutA)

	Local nCpoAtu	:= 0
	Local nRegDd	:= 0
	Local aDdLins	:= {}
	Local cDdLinha	:= ''
	Local cCntAtu	:= ''
	Local _CntAtu

	//1.Le a linha de dados ou as linhas  de dados
	For nRegDd	:= 1 to len(aDdRegA)

		//2.Para cada campo (dado)  do registro adequo o preenchimento conforme as configurações do layout do tipo de registro
		For nCpoAtu := 1 to len(aDdRegA[nRegDd])

			//MsgAlert(nCpoAtu)
			//3.Se o campo possui configuração de preenchimento asosciada a uma funçao Z02_FUNCAO a executo
			if !Empty(Alltrim(aLayoutA[nCpoAtu][15]))

				if '()' $ aLayoutA[nCpoAtu][15]

					if aLayoutA[nCpoAtu][7] <> 'D'

						nItTpReg	:= ExecBlock(Substring(aLayoutA[nCpoAtu][15],1,8),.F.,.F.,{nItTpReg,aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][7]})
						aDdRegA[nRegDd][nCpoAtu]	:= nItTpReg

					ElseIf aLayoutA[nCpoAtu][7] == 'D' .AND. Valtype(aDdRegA[nRegDd][nCpoAtu]) <> 'U'

						aDdRegA[nRegDd][nCpoAtu]	:= ExecBlock(Substring(aLayoutA[nCpoAtu][15],1,8),.F.,.F.,{aDdRegA[nRegDd][nCpoAtu],aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][7],aLayoutA[nCpoAtu][17]})

					Elseif  aLayoutA[nCpoAtu][7] == 'D' .AND. Valtype(aDdRegA[nRegDd][nCpoAtu])== 'U'

						aDdRegA[nRegDd][nCpoAtu]	:= ''

					EndIf

				Else

					aDdRegA[nRegDd][nCpoAtu]	:= &(aLayoutA[nCpoAtu][15])

				EndIf

				//4.Verifico se o campo atual no tipo de registro do  layout possui conteudo fixo Z02_CNTFIX
			Elseif !Empty(Alltrim(aLayoutA[nCpoAtu][10]))

				aDdRegA[nRegDd][nCpoAtu] := aLayoutA[nCpoAtu][10]

			EndIf

			//MsgAlert(aDdRegA[nRegDd][nCpoAtu])

			_CntAtu	:= aDdRegA[nRegDd][nCpoAtu]

			//Caso o campo seja do tipo Caracter(Z02_TIPO) tira os espaços vazios
			if aLayoutA[nCpoAtu][7] == 'C'

				if Valtype(_CntAtu) == 'C' .OR. Valtype(_CntAtu) == 'U'

					_CntAtu	:= Alltrim(_CntAtu)

				Elseif Valtype(_CntAtu) == 'N'
					/*
					MsgAlert('Tratamento não previsto para tipo de campo caracter e conteúdo de campo numérico.';								  
							  +'Informe ao departamento de TI seu procedimento para originar esta mensagem e o ';
							  +'Layout tipo de registro '+aLayoutA[nCpoAtu][1]+' numero do campo '+aLayoutA[nCpoAtu][5]+'.')
					*/
					//aLayoutA[nCpoAtu][17]	Z02_FORMAT?

				EndIf

				//caso o campo seja do tipo(Z02_TIPO) numérico
			Elseif aLayoutA[nCpoAtu][7] == 'N'

				//Se não existir formato pré definido(Z02_FORMAT) e o dado(conteúdo) for  numérico, adequa o formato conforme o tamanho
				if Empty(aLayoutA[nCpoAtu][17]) .AND. Valtype(_CntAtu) == 'N'

					_CntAtu	:= AjusCpoN(_CntAtu,aLayoutA[nCpoAtu][9],aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][5], aLayoutA[nCpoAtu][1]	)

					//Se existe formato pré definido e o dado(conteúdo) for tipo caracteres, aplica o formato
				Elseif !Empty(aLayoutA[nCpoAtu][17]) .AND. Valtype(_CntAtu) == 'C'

					_CntAtu	:= Transform(_CntAtu,aLayoutA[nCpoAtu][17])

				Elseif Valtype(_CntAtu) == 'U' .OR. Valtype(_CntAtu) == 'C'

					_CntAtu	:= Alltrim(_CntAtu)

				EndIf

			Elseif  aLayoutA[nCpoAtu][7] <> 'D'

				HELP("HELP",1, 'Incorreta Configuração','DHME0001','O campo '+aLayoutA[nCpoAtu][5]+' do tipo de registro '+aLayoutA[nCpoAtu][1]	+;
					'não possui a configuraçao correta do Tipo (Numerico ou Caracter). Verifique, pois acarreta em erros!', 1, 0)

			EndIf

			//Se o campo não permitir caracter especiais os retira
			if Empty(Alltrim(aLayoutA[nCpoAtu][16]))

				_CntAtu	:= StrTran(Alltrim(_CntAtu),'.','')
				_CntAtu	:= StrTran(Alltrim(_CntAtu),',','')
				_CntAtu	:= StrTran(Alltrim(_CntAtu),'-','')
				_CntAtu	:= StrTran(Alltrim(_CntAtu),'/','')

			EndIf

			//5.Adequo o contéudo do campo para não ultrapassar o tamanho do campo Z02_TAMANH exceto dados(conteúdo) númerico
			if len(_CntAtu) <=  aLayoutA[nCpoAtu][8]

				aDdRegA[nRegDd][nCpoAtu]		:= _CntAtu

			Else

				//Se o dado for maior que o tamanho configurado no campo e o tipo for caracter
				if aLayoutA[nCpoAtu][7] == 'C'

					if Valtype(aDdRegA[nRegDd][nCpoAtu]) == 'C'

						cCntAtu						:= aDdRegA[nRegDd][nCpoAtu]
						aDdRegA[nRegDd][nCpoAtu]	:= Substring(Alltrim(aDdRegA[nRegDd][nCpoAtu]),1,aLayoutA[nCpoAtu][8])

					Elseif Valtype(aDdRegA[nRegDd][nCpoAtu]) == 'N'

						cCntAtu	 := Transform(aDdRegA[nRegDd][nCpoAtu],"@E 999.999,99")

						aDdRegA[nRegDd][nCpoAtu]	:= AjusCpoN(aDdRegA[nRegDd][nCpoAtu],aLayoutA[nCpoAtu][9],aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][5], aLayoutA[nCpoAtu][1]	)

					EndIf

					//Para os campos apresentados como conteudo superior o Rafael informou que não é necessário alertar
					//HELP("HELP",1,'Incompatível tamanho','DHME001','O conteúdo '+cCntAtu+' ultrapassa o tamanho do campo ('+aLayoutA[nCpoAtu][5]+ ')';
						//			+' tipo caracter do tipo de registro '+aLayoutA[nCpoAtu][1]+'. Verifique, pois acarreta em erros no Destino!', 3, 0)

					//Se o dado for maior que o tamanho configurado no campo e o tipo for numérico efetua tratamento, mais alerta erro que será gerado.
				Elseif aLayoutA[nCpoAtu][7] == 'N'

					if Valtype(aDdRegA[nRegDd][nCpoAtu]) =='N'

						cCntAtu						 := Transform(aDdRegA[nRegDd][nCpoAtu],"@E 999.999,99")
						aDdRegA[nRegDd][nCpoAtu]	:= AjusCpoN(aDdRegA[nRegDd][nCpoAtu],aLayoutA[nCpoAtu][9],aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][5], aLayoutA[nCpoAtu][1]	)

					Else

						cCntAtu						:= aDdRegA[nRegDd][nCpoAtu]
						aDdRegA[nRegDd][nCpoAtu]	:= Substring(Alltrim(aDdRegA[nRegDd][nCpoAtu]),1,aLayoutA[nCpoAtu][8])

					EndIf
					/*
					HELP("HELP",1,'Incompativel tamanho','DHME001','O conteúdo '+cCntAtu+' ultrapassa o tamanho do campo ('+aLayoutA[nCpoAtu][5]+') ';
								 +'tipo númerico, do tipo de registro '+aLayoutA[nCpoAtu][1]+'. Verifique, pois acarreta em erros no Destino!', 3, 0)					
					*/
				EndIf

				aDdRegA[nRegDd][nCpoAtu]		:= _CntAtu

			EndIf

			//4.Preencho os espaços que não possuem conteúdo conforme regra de configuração do campo
			if aLayoutA[nCpoAtu][12] == 'D'//Direita

				aDdRegA[nRegDd][nCpoAtu]	:= Padr(aDdRegA[nRegDd][nCpoAtu],aLayoutA[nCpoAtu][8],aLayoutA[nCpoAtu][11])

			Elseif aLayoutA[nCpoAtu][12] == 'E'//Esquerda

				aDdRegA[nRegDd][nCpoAtu]	:= Padl(aDdRegA[nRegDd][nCpoAtu],aLayoutA[nCpoAtu][8],Alltrim(aLayoutA[nCpoAtu][11]))

			Elseif aLayoutA[nCpoAtu][12] <> 'S'

				Help('',1,'AJUSTREG_02',,"Lado de Preenchimento.",1,0,,,,,,{'O campo '+aLayoutA[nCpoAtu][5]+' do tipo de registro '+aLayoutA[nCpoAtu][1]+' ';
					+' não possui a configuração correta de preenchimento dos espaços vazio. Verifique, pois poderá acarretar em erros!'})

			EndIf

			cDdLinha	+= aDdRegA[nRegDd][nCpoAtu]

		Next nCpoAtu

		aAdd(aDdLins,cDdLinha)
		cDdLinha	:= ''

	Next

Return aDdLins
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AjusCpoN
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 06/09/2016
@version 1.0
@param cCnt, character, (Descrição do parâmetro)
@param nDec, numérico, (Descrição do parâmetro)
@param nTam, numérico, (Descrição do parâmetro)
@param nPosCpo, numérico, (Descrição do parâmetro)
@param nTipReg, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AjusCpoN(cCnt,nDec,nTam,nPosCpo,nTipReg)

	Local nTamDec	:= 0
	Local nTamTt	:= 1
	Local cPictAtu	:= ''
	Local nIniDec	:= 0

	if !Empty(cCnt)

		//Verifico se o campo possui decimal Z02_DEC
		if nDec <> 0

			nTamDec	:= nDec

		EndIf

		nIniDec	:= 	nTam-nTamDec

		//Monta a picture a ser aplicada no campo
		While nTamTt <= nTam

			if nTamTt == (nTam-nTamDec+1) .AND. nTamDec <> 0

				cPictAtu	+= '.9'

				nTamDec:= 0

			Else

				cPictAtu	+= '9'

			EndIf

			nTamTt	:= nTamTt+1

		EndDo

		cCnt	:= Transform(cCnt,cPictAtu)

	EndIf

Return cCnt
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ${CNTTPREG}
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
User Function CNTTPREG()

	Local _ItemAtu	:= paramIxb[1]
	Local nTamCpo	:= paramIxb[2]
	Local cTipCpo	:= paramIxb[3]

	if Valtype(_ItemAtu) == 'N'

		_ItemAtu	:= _ItemAtu+1

		if len(Alltrim(Str(_ItemAtu))) >  nTamCpo

			MsgAlert('O número de linhas '+Str(_ItemAtu)+' para o tipo de registro '+cTipCpo+'ultrapa o tamanho configurado. Verifique, pois poderá acarretar em erros!')

		EndIf

	Elseif Valtype(_ItemAtu) == 'C'

		_ItemAtu	:= soma1(_ItemAtu)

	EndIf

Return _ItemAtu
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} FormData
(long_description)
@type function
@author Cris
@since 15/02/2017
@version 1.0
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
User Function FormData()

	Local _DataAt	:= ''
	Local _ItemAtu	:= paramIxb[1]
	Local cTipCpo	:= paramIxb[3]
	Local cFormat	:= ""

	If Len(paramIxb) > 3
		cFormat	:= UPPER(Alltrim(paramIxb[4]))
	EndIf

	if cTipCpo == 'D' .AND. cFormat == 'DDMMAAAA'

		_DataAt	:= Substring(_ItemAtu,7,2)+Substring(_ItemAtu,5,2)+Substring(_ItemAtu,1,4)

	EndIf

Return _DataAt
//---------------------------------------------------------------------------------------------------------------------------
/*{Protheus.doc} DescReg
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 01/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function DescReg(aConteudo,nTpRgTt,lFimGrv)

	Local 	nY		:= 0
	Local	nCnt	:= 0
	Default lFimGrv	:= .T.

	FT_FGoTop()

	For nY := 1 To nTpRgTt

		For nCnt	:= 1 to len (aConteudo[nY])

			FWRITE(nHdlArq, aConteudo[nY][nCnt]+CRLF  )

		Next nCnt

	Next nY

	//Quando final de arquivo
	if lFimGrv

		FT_FUse()

		if FClose(nHdlArq)

			Aviso("Geração do Arquivo", 'Termino da montagem do arquivo '+cArqAtu, {'OK'},3)

			//AtuStReg()

		Else

			Aviso("Não Geração do Arquivo",'Ocorreu um erro no fechamento do arquivo ('+Str(FERROR())+'). Informe ao departamento de TI', {'OK'},3)

		EndIf

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AtuStReg
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 07/09/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function AtuStReg()

	Local nTabRec	:= 0
	Local cUpdAtu	:= ''

	For  nTabRec	:= 1  to  len(aTabRec)

		if aTabRec[nTabRec][1] == 'SB1'

			cUpdAtu	:= " UPDATE "+RetSqlName("SB1")+" "+CRLF
			cUpdAtu	+= " SET B1_XEXPCTB = '1' "+CRLF
			cUpdAtu	+= "  WHERE R_E_C_N_O_ = "+Str(aTabRec[nTabRec][2])+" "+CRLF
			cUpdAtu	+= "    AND  B1_XEXPCTB <> '1' "

		Elseif aTabRec[nTabRec][1] == 'SA1'

			cUpdAtu	:= " UPDATE "+RetSqlName("SA1")+" "+CRLF
			cUpdAtu	+= " SET A1_XEXPCTB = '1' "+CRLF
			cUpdAtu	+= "  WHERE R_E_C_N_O_ = "+Str(aTabRec[nTabRec][2])+" "+CRLF
			cUpdAtu	+= "    AND  A1_XEXPCTB <> '1' "

		Elseif aTabRec[nTabRec][1] == 'SA2'

			cUpdAtu	:= " UPDATE "+RetSqlName("SA2")+" "+CRLF
			cUpdAtu	+= " SET A2_XEXPCTB = '1' "+CRLF
			cUpdAtu	+= "  WHERE R_E_C_N_O_ = "+Str(aTabRec[nTabRec][2])+" "+CRLF
			cUpdAtu	+= "    AND  A2_XEXPCTB <> '1' "+CRLF

		Elseif aTabRec[nTabRec][1] == 'SF1'

			cUpdAtu	:= " UPDATE "+RetSqlName("SF1")+" "+CRLF
			cUpdAtu	+= " SET F1_XEXPCTB = '1' "+CRLF
			cUpdAtu	+= "  WHERE R_E_C_N_O_ = "+Str(aTabRec[nTabRec][2])+" "+CRLF
			cUpdAtu	+= "    AND  F1_XEXPCTB <> '1' "

		Elseif aTabRec[nTabRec][1] == 'SF2'

			cUpdAtu	:= " UPDATE "+RetSqlName("SF2")+" "+CRLF
			cUpdAtu	+= " SET F2_XEXPCTB = '1' "+CRLF
			cUpdAtu	+= "  WHERE R_E_C_N_O_ = "+Str(aTabRec[nTabRec][2])+" "+CRLF
			cUpdAtu	+= "    AND  F2_XEXPCTB <> '1' "

		EndIf

		If TcSQLExec( cUpdAtu ) # 0

			Help(" ",1,"Não atualização",, "Ocorreu um erro durante a atualização do registro da tabela "+aTabRec[nTabRec][1]+" R_E_C_N_O_ "+Str(aTabRec[nTabRec][2])+" " + CRLF + TcSQLError() , 1, 0 )

		Else

			TcSQLExec( 'COMMIT' )

		EndIf

	Next nTabRec
Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MntArqNF
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 08/09/2016
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MntArqNF(aConfLay,aRetPara)

	Local aConteudo		:= {}
	Local aLayout		:= aConfLay[1]
	Local aOrdExec		:= aConfLay[2]
	Local aCpoXFunc		:= aConfLay[3]
	Local aTpReg0		:= {} //Registro Header de Arquivo (obrigatório)
	Local aTpReg4		:= {} //Registro de Emitente/Destinário (condicional)
	Local aTpReg1		:= {} //Registro de Notas Fiscal (obrigatório)
	Local aTpReg2		:= {} //Registro de Itens da Nota (obrigatório)
	Local aItens		:= {} //Acumula os itens aTpReg2
	Local aTpReg5		:= {} //Dados Complementares (obrigatório)
	Local aTpReg9		:= {} //Parcelas na Nota Fiscal	(condicional)
	Local aTpReg3		:= {} //Registro Trailler (obrigatório)
	Local cEspServ		:= SuperGetMv('ES_ESPSERV',,'NFSE|CTR|CTE')
	Local nLayout		:= 0
	Local cChvNFe		:= ''
	Local nPosTpR0		:= ascan(aLayout,{|x| x[1][1] == '0'})
	Local nPosTpR1		:= ascan(aLayout,{|x| x[1][1] == '1'})
	Local nPosTpR2		:= ascan(aLayout,{|x| x[1][1] == '2'})
	Local nPosTpR3		:= ascan(aLayout,{|x| x[1][1] == '3'})
	Local nPosTpR4		:= ascan(aLayout,{|x| x[1][1] == '4'})
	Local nPosTpR5		:= ascan(aLayout,{|x| x[1][1] == '5'})
	Local nPosTpR9		:= ascan(aLayout,{|x| x[1][1] == '9'})
	Local nPosCab		:= 0
	Local iTens			:= 0
	Local nPosCFOP		:= 0

	//1.Registro Header do Arquivo - sempre existirá único registro: Tipo Registro 0
	aAdd(aTpReg0,array(len(aLayout[nPosTpR0])))
	aTpReg0	:= Preench1(aTpReg0,aRetPara[3])
	aTpReg0	:= AjustReg(aTpReg0,aLayout[nPosTpR0])
	aAdd(aConteudo,aTpReg0)

	//Registro Trailler- sempre existirá único registro: Tipo de Registro 3
	aAdd(aTpReg3,{'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',''})

	DescReg(aConteudo,1,.F.)
	aConteudo	:= {}

	(cAliaQry)->(dbGotop())

	cChvNFe	:= (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

	While !(cAliaQry)->(Eof())

		if cChvNFe <> (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

			//Se existir cliente/fornecedor a ser enviado
			if len(aTpReg4) > 0

				aTpReg4	:= AjustReg(aTpReg4,aLayout[nPosTpR4])
				aAdd(aConteudo,aTpReg4)

			EndIf

			//Sempre existirá este registro de nota fiscal,seja de serviço ou produto
			//Trailler: ultima linha - Acumuladora de valores->acumulo antes de tornar a linha tipo 1 em um vetor
			aTpReg3	:= Trailler(aTpReg3,aTpReg1,'E')
			aTpReg1	:= AjustReg(aTpReg1,aLayout[nPosTpR1])
			aAdd(aConteudo,aTpReg1)

			//Poderá existir este registro se a nota fiscal for referente a produto e não serviço
			if len(aItens) > 0

				aAdd(aConteudo,AjustReg(aItens,aLayout[nPosTpR2]))

			EndIf

			//Sempre existirá os Dados Complementares, existindo ou não devido a Chave NF
			aTpReg5	:= AjustReg(aTpReg5,aLayout[nPosTpR5])
			aAdd(aConteudo,aTpReg5)

			//Se existir  pagamento/recebimento
			if len(aTpReg9) > 0

				aAdd(aConteudo,AjustReg(aTpReg9,aLayout[nPosTpR9]))

			EndIf

			DescReg(aConteudo,len(aConteudo),.F.)

			aTpReg4		:= {}
			aTpReg1		:= {}
			aTpReg2		:= {}
			aItens		:= {}
			aTpReg5		:= {}
			aTpReg9		:= {}
			aCFOsNF		:= {}
			aConteudo	:= {}
			cRemeten	:= ''
			cAvista		:= ''
			cChvNFe	:= (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

		EndIf

		//Se o cliente/fornecedor ainda não foi exportado monta arquivo do cliente/fornecedor
		If Len(aTpReg4) == 0

			aAdd(aTpReg4,array(len(aLayout[nPosTpR4])))
			aTpReg4	:= ClieFor(aTpReg4/*,aRetPara*/)

		EndIf

		//Adiciona os Dados Complementares
		if  Len(aTpReg5) == 0

			aAdd(aTpReg5,array(len(aLayout[nPosTpR5])))
			aTpReg5	:= DdCompl(aTpReg5)

		EndIf

		//Se a condição de pagamento estiver informada preencho o tipo de registro 9
		If (cAliaQry)->CONDPGTO	<> '' .AND. Len(aTpReg9) == 0

			aTpReg9	:= TitAtu(aTpReg9,aLayout[nPosTpR9])
		Elseif (cAliaQry)->CONDPGTO	== ''

			cAVista	:= 'X' //sem pagamento
		EndIf

		//Monta cabeçalho  da NF:  Registro Tipo 1
		if (nPosCFOP	:= Ascan(aCFOsNF,{|x| x[1] == (cAliaQry)->CFOP})) == 0

			//Aplico a  quebra do registro tipo 1 Cabeçalho de Notas Fiscais somente para notas fiscais de Entrada
			if (cAliaQry)->MVTO == 'E'

				//Monto o array do tipo de registro 1 Nota Fiscal
				aAdd(aTpReg1,array(len(aLayout[nPosTpR1])))

			Elseif len(aTpReg1) == 0

				//Monto o array do tipo de registro 1 Nota Fiscal
				aAdd(aTpReg1,array(len(aLayout[nPosTpR1])))

			EndIf

			aAdd(aCFOsNF, {(cAliaQry)->CFOP})

			nPosCab	:= len(aTpReg1)

		Else

			//Aplico a  quebra do registro tipo 1 Cabeçalho de Notas Fiscais somente para notas fiscais de Entrada
			if (cAliaQry)->MVTO == 'E'

				nPosCab	:= 	nPosCFOP

			Else

				nPosCab	:= 1

			EndIF

		EndIf

		aTpReg1	:= MtCabNFE(nPosCab,aTpReg1)

		if (len(aTabRec) > 0 .AND. (Ascan(aTabRec,{|x| x[2] == (cAliaQry)->NFRECNO})) == 0) .OR. len(aTabRec) == 0

			if (cAliaQry)->MVTO == 'E'

				aAdd(aTabRec,{'SF1',(cAliaQry)->NFRECNO})

			Else

				aAdd(aTabRec,{'SF2',(cAliaQry)->NFRECNO})

			EndIf

		EndIf

		//Monto os itens caso a  nota fiscal exija: registro  tipo 2
		//Lembrar que notas fiscais de serviço para outros sistemas podem não necessitar da criação de um produto
		If !(cAliaQry)->ESPECIE $ cEspServ

			aAdd(aItens,MntNfPrd(aLayout[nPosTpR2],aTpReg2))

		EndIf

		(cAliaQry)->(dbSkip())

	EndDo

	If Len(aTpReg1)>1
		aTpReg1	:= aSize(aTpReg1,1)
	Endif
	//Se existir cliente/fornecedor a ser enviado
	if len(aTpReg4) > 0

		aTpReg4	:= AjustReg(aTpReg4,aLayout[nPosTpR4])
		aAdd(aConteudo,aTpReg4)

	EndIf

	//Sempre existirá este registro de nota fiscal,seja de serviço ou produto
	//Trailler: ultima linha - Acumuladora de valores->acumulo antes de tornar a linha tipo 1 em um vetor
	aTpReg3	:= Trailler(aTpReg3,aTpReg1,'E')
	aTpReg1	:= AjustReg(aTpReg1,aLayout[nPosTpR1])
	aAdd(aConteudo,aTpReg1)

	//Poderá existir este registro se a nota fiscal for referente a produto e não serviço
	if len(aItens) > 0

		//For iTens	:= 1 to len(aItens)

		//aAdd(aConteudo,AjustReg(aItens[iTens],aLayout[nPosTpR2]))
		aAdd(aConteudo,AjustReg(aItens,aLayout[nPosTpR2]))
		//Next iTens

	EndIf

	//Sempre existirá os Dados Complementares, existindo ou não devido a Chave NF
	aTpReg5	:= AjustReg(aTpReg5,aLayout[nPosTpR5])
	aAdd(aConteudo,aTpReg5)

	//Se existir  pagamento/recebimento
	if len(aTpReg9) > 0

		aAdd(aConteudo,AjustReg(aTpReg9,aLayout[nPosTpR9]))

	EndIf

	//7.Registro Trailler- sempre existirá: Tipo de Registro 3
	aTpReg3	:= AjustReg(aTpReg3,aLayout[nPosTpR3])
	aAdd(aConteudo,aTpReg3)

	nTtLinh		:= IIf(ValType(nItTpReg)<>'N',0,nItTpReg)

	FWMsgRun(,{||  DescReg(aConteudo,len(aConteudo),.T.) },'Aguarde....' ,'Gravando linhas no arquivo')

	aTpReg4		:= {}
	aTpReg1		:= {}
	aTpReg2		:= {}
	aItens		:= {}
	aTpReg5		:= {}
	aTpReg9		:= {}
	aCFOsNF		:= {}
	aConteudo	:= {}
	cRemeten	:= ''
	cAvista		:= ''

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ClieFor
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 12/09/2016
@version 1.0
@param aTpReg4, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function ClieFor(aTpReg4)

	Local cAlCFNF	:= GetNextAlias()
	Local aEndNum	:= {}

	cAlCFNF	:=	SelFor(cAlCFNF)

	(cAlCFNF)->(dbGotop())
	If !(cAlCFNF)->(Eof())

		//Caso seja consumidor final chumba CPF/CNPJ
		if  ((cAlCFNF)->FINALIDADE_NEGOCIO == 'F' .AND. (cAlCFNF)->TIPO_F_J == 'F') .OR. (cAlCFNF)->UF = 'EX'

			aTpReg4[01][02]	:= '99.999.999/9999-99'
			aTpReg4[01][24]	:= 1//1-Pessoa Jurídica de Direito privado

		Else

			If (cAlCFNF)->TIPO_F_J == 'J'

				aTpReg4[01][02]	:= Transform((cAlCFNF)->CPF_CNPJ,'@R 99.999.999/9999-99')
				aTpReg4[01][24]	:= 1//1-Pessoa Jurídica de Direito privado

			Elseif  (cAlCFNF)->TIPO_F_J == 'F'

				aTpReg4[01][02]	:= Transform((cAlCFNF)->CPF_CNPJ,'@R 999.999.999-99')
				aTpReg4[01][24]	:= 1//1-Pessoa Jurídica de Direito privado
			EndIf

		EndIf

		cRemeten	:= aTpReg4[01][02]

		aTpReg4[01][03]	:= (cAlCFNF)->NOME
		aTpReg4[01][04]	:= (cAlCFNF)->FANTASIA
		aTpReg4[01][05]	:= (cAlCFNF)->UF

		If (cAlCFNF)->ORIGEM_C_F == "F"
			cInscr	:= Posicione("SA2",1,xFilial("SA2")+(cAlCFNF)->(CODIGO+LOJA),"A2_INSCR")
		Else
			cInscr	:= Posicione("SA1",1,xFilial("SA1")+(cAlCFNF)->(CODIGO+LOJA),"A1_INSCR")
		Endif
		if Empty(cInscr)

			aTpReg4[01][06]	:= 'ISENTO'

		Else

			aTpReg4[01][06]	:= AllTrim(cInscr)

		EndIf

		//Efetuar tratamento para retirar o numero do endereço
		aEndNum	:= AdeqEnd(Alltrim((cAlCFNF)->ENDERECO),aEndNum)
		aTpReg4[01][07]	:= aEndNum[1]
		aTpReg4[01][20]	:= aEndNum[2]
		aTpReg4[01][21]	:= aEndNum[3]+' '+Alltrim((cAlCFNF)->COMPLEMENTO)
		aEndNum	:= {}

		aTpReg4[01][08]	:= (cAlCFNF)->BAIRRO
		aTpReg4[01][09]	:= (cAlCFNF)->ESTADO
		aTpReg4[01][10]	:= (cAlCFNF)->CEP
		aTpReg4[01][12]	:= (cAlCFNF)->DDD
		aTpReg4[01][13]	:= (cAlCFNF)->TEL

		//preenche campo de conta contabil na posição conforme
		//origem da informação ser vinculada ao cliente ou ao
		//fornecedor
		if (cAlCFNF)->ORIGEM_C_F == 'C'

			aAdd(aTabRec,{'SA1',(cAlCFNF)->RECNO})

			aTpReg4[01][14]	:= (cAlCFNF)->CONTA_CONTABIL

		else

			aAdd(aTabRec,{'SA2',(cAlCFNF)->RECNO})

			aTpReg4[01][16]	:= (cAlCFNF)->CONTA_CONTABIL
			aTpReg4[01][11]	:= (cAlCFNF)->CODSIAF

		EndIf

		//Verifica se é produto rural ou não
		if  (cAlCFNF)->FINALIDADE_NEGOCIO == 'L'

			aTpReg4[01][18]	:= 'S'

		Else

			aTpReg4[01][18]	:= 'N'

		EndIf

		//Se  for um cadastro do exterior
		if (cAlCFNF)->UF = 'EX'
			//ALTERAR PARA BUSCAR O  NOME CERTO
			aTpReg4[01][19]	:= (cAlCFNF)->CODIGO

		EndIf

		aTpReg4[01][22]	:= (cAlCFNF)->CODIGO_SUFRAMA
		aTpReg4[01][23]	:= (cAlCFNF)->CODIGO_PAIS_IBGE
		aTpReg4[01][25]	:= UFMnIBGE((cAlCFNF)->UF)+(cAlCFNF)->CMUNIBGE

	EndIf

	(cAlCFNF)->(dbCloseArea())

Return aTpReg4
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Preench1
(long_description))
@type function
@author Cristiane Thomaz Polli
@since 09/09/2016
@version 1.0
@param aTpReg0, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function Preench1(aTpReg0,cFilRel)

	Local cFilSM0	:= cFilRel
	Local cFilAtu	:= cFilAnt
	Local cDtDMA	:= Dtos(MsDate())

	aTpReg0[1][2] 	:= Substring(cDtDMA,7,2)+Substring(cDtDMA,5,2)+Substring(cDtDMA,1,4)

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	if SM0->(dbSeek(cEmpAnt+cFilSM0))

		aTpReg0[1][3] := SM0->M0_CGC

	EndIf

	SM0->(dbSeek(cEmpAnt+cFilAtu))

Return aTpReg0
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TitAtu
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 11/09/2016
@version 1.0
@param aTpReg9, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function TitAtu(aTpReg9,aLaytReg9)

	Local cTabTit	:= GetNextAlias()
	Local cQryTit	:= ''
	Local nPosTit	:= 0

	if (cAliaQry)->MVTO == 'E'

		cQryTit	:= "	SELECT E2_NUM TITULO, E2_PARCELA PARCELA, E2_TIPO TIPO, E2_NATUREZ NATUREZA, E2_FORNECE CLIEFOR, E2_LOJA LOJA, "+CRLF
		cQryTit	+= "			E2_EMISSAO EMISSAO, E2_VENCTO VENCTO, E2_VENCREA VENCREA, E2_VALOR VALOR, E2_IRRF IRRF , E2_ISS ISS, "+CRLF
		cQryTit	+= "			E2_SALDO SALDO, E2_STATUS TITSTATUS, E2_CSLL CSLL, E2_COFINS COFINS,  "+CRLF
		cQryTit	+= "			E2_PIS PIS, E2_BASEPIS BASEPIS, E2_BASECOF BASECOFINS, E2_BASECSL BASECSLL,E2_VRETISS VLRETISS,E2_TITPAI TITPAI, "+CRLF
		cQryTit	+= "		(	SELECT E4_COND
		cQryTit	+= "	 		FROM "+RetSqlName("SE4")+" "+RetSqlName("SE4")+" (NOLOCK) "+CRLF
		cQryTit	+= "			WHERE E4_FILIAL  = '"+xFilial("SE4")+"' "+CRLF
		cQryTit	+= "			   AND E4_CODIGO = '"+(cAliaQry)->CONDPGTO+"' "+CRLF
		cQryTit	+= "	 		   AND "+RetSqlName("SE4")+".D_E_L_E_T_ = '' "+CRLF
		cQryTit	+= "			) AS COND "+CRLF
		cQryTit	+= "	FROM "+RetSqlName("SE2")+" "+RetSqlName("SE2")+" (NOLOCK) "+CRLF
		cQryTit	+= "	WHERE E2_FILIAL = '"+(cAliaQry)->FILIAL+"' "+CRLF
		cQryTit	+= "	 AND "+RetSqlName("SE2")+".D_E_L_E_T_ = '' "+CRLF
		cQryTit	+= "	 AND E2_PREFIXO = '"+(cAliaQry)->PREFIXO+"'  "+CRLF
		cQryTit	+= "	 AND E2_NUM = '"+(cAliaQry)->DUPL+"' "+CRLF
		cQryTit	+= "	 AND E2_FORNECE = '"+(cAliaQry)->CLIEFOR+"' "+CRLF
		cQryTit	+= "	 AND E2_LOJA = '"+(cAliaQry)->LOJA+"' "+CRLF

	Else

		cQryTit	:= "	SELECT E1_NUM TITULO, E1_PARCELA PARCELA, E1_TIPO TIPO, E1_NATUREZ NATUREZA, E1_CLIENTE CLIEFOR, E1_LOJA LOJA, "+CRLF
		cQryTit	+= "			E1_EMISSAO EMISSAO, E1_VENCTO VENCTO, E1_VENCREA VENCREA, E1_VALOR VALOR, E1_IRRF IRRF , E1_ISS ISS, "+CRLF
		cQryTit	+= "			E1_SALDO SALDO, E1_PEDIDO PEDIDO, E1_SERIE SERIE, E1_STATUS TITSTATUS, E1_CSLL CSLL, E1_COFINS COFINS,  "+CRLF
		cQryTit	+= "			E1_PIS PIS, E1_BASEPIS BASEPIS, E1_BASECOF BASECOFINS, E1_BASECSL BASECSLL,E1_VRETISS VLRETISS,E1_TITPAI TITPAI, "+CRLF
		cQryTit	+= "		(	SELECT E4_COND
		cQryTit	+= "	 		FROM "+RetSqlName("SE4")+" "+RetSqlName("SE4")+" (NOLOCK) "+CRLF
		cQryTit	+= "			WHERE E4_FILIAL  = '"+xFilial("SE4")+"' "+CRLF
		cQryTit	+= "			   AND E4_CODIGO = '"+(cAliaQry)->CONDPGTO+"' "+CRLF
		cQryTit	+= "	 		   AND "+RetSqlName("SE4")+".D_E_L_E_T_ = '' "+CRLF
		cQryTit	+= "			) AS COND "+CRLF
		cQryTit	+= "	FROM "+RetSqlName("SE1")+" "+RetSqlName("SE1")+" (NOLOCK) "+CRLF
		cQryTit	+= "	WHERE E1_FILIAL = '"+(cAliaQry)->FILIAL+"' "+CRLF
		cQryTit	+= "	 AND "+RetSqlName("SE1")+".D_E_L_E_T_ = '' "+CRLF
		cQryTit	+= "	 AND E1_PREFIXO = '"+(cAliaQry)->PREFIXO+"'  "+CRLF
		cQryTit	+= "	 AND E1_NUM = '"+(cAliaQry)->DUPL+"' "+CRLF
		cQryTit	+= "	 AND E1_CLIENTE = '"+(cAliaQry)->CLIEFOR+"' "+CRLF
		cQryTit	+= "	 AND E1_LOJA = '"+(cAliaQry)->LOJA+"' "+CRLF

	EndIf

	cQryTit := ChangeQuery(cQryTit)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryTit),cTabTit,.T.,.T.)

	If !(cTabTit)->(Eof())

		While !(cTabTit)->(Eof())

			if 'NF' $ (cTabTit)->TIPO

				cAvista	:= Alltrim((cTabTit)->COND)

				aAdd(aTpReg9,array(len(aLaytReg9)))

				nPosTit	:= len(aTpReg9)

				if !Empty((cTabTit)->PARCELA)

					aTpReg9[nPosTit][2]	:=  'N'	//Tipo de parcela

				EndIf

				aTpReg9[nPosTit][3]	:=  (cTabTit)->TITULO	// 	Nr Fatura
				aTpReg9[nPosTit][4]	:=  '00'	//4	Tipo titulo 00- duplicata 01- cheque 02- promissória 03- recibo
				aTpReg9[nPosTit][5]	:=  (cTabTit)->VENCREA	//	Dt Vencimento
				aTpReg9[nPosTit][6]	:=  (cTabTit)->VALOR	//	Vl Parcela

			EndIf

			(cTabTit)->(dbSkip())

		EndDo

	EndIf

	if cAvista == '0'

		cAvista	:= 'S'//venda a vista

	Elseif nPosTit == 0

		cAvista	:= 'X'//sem pagamento

	Elseif nPosTit >= 1

		cAvista	:= 'N'// parcelado

	EndIf

	(cTabTit)->(dbCloseArea())

Return aTpReg9
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MntNfPrd
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 09/09/2016
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MntNfPrd(aLayPrd,aTpReg2)

	Local nBsPIS	:= 0
	Local nAlqPIS	:= 0
	Local nVlPIS	:= 0
	Local nBsCOF	:= 0
	Local nAlqCOF	:= 0
	Local nVlCOF	:= 0
	Local nPosPrd	:= 0

	aAdd(aTpReg2,array(len(aLayPrd)))
	nPosPrd	:= len(aTpReg2)

	//PIS NA APURACAO
	if (cAliaQry)->BS_PIS_A <> 0.00

		nBsPIS	:= (cAliaQry)->BS_PIS_A
		nAlqPIS	:= (cAliaQry)->ALQ_PIS_A
		nVlPIS	:= (cAliaQry)->VL_PIS_A

	EndIf

	//PIS NA RETENCAO
	If (cAliaQry)->BS_PIS_R <> 0.00

		nBsPIS	:= (cAliaQry)->BS_PIS_R
		nAlqPIS	:= (cAliaQry)->ALQ_PIS_R
		nVlPIS	:= (cAliaQry)->VL_PIS_R

	EndIf

	//COFINS NA APURACAO
	if (cAliaQry)->BS_COF_A <> 0.00

		nBsCOF	:= (cAliaQry)->BS_COF_A
		nAlqCOF	:= (cAliaQry)->ALQ_COF_A
		nVlCOF	:= (cAliaQry)->VL_COF_A

	EndIf

	//COFINS NA RETENCAO
	If (cAliaQry)->BS_COF_R <> 0.00

		nBsCOF	:= (cAliaQry)->BS_COF_R
		nAlqCOF	:= (cAliaQry)->ALQ_COF_R
		nVlCOF	:= (cAliaQry)->VL_COF_R

	EndIf

	//aTpReg2[nPosPrd][2]	:= (cAliaQry)->B1_CORD
	aTpReg2[nPosPrd][3]	:= (cAliaQry)->QUANTIDADE
	aTpReg2[nPosPrd][4]	:= (cAliaQry)->VL_BRUTO
	//aTpReg2[nPosPrd][5]	:= (cAliaQry)->	Quantidade-2
	aTpReg2[nPosPrd][6]	:= (cAliaQry)->VL_DESCONTO
	aTpReg2[nPosPrd][14]	:= (cAliaQry)->PRODUTO
	aTpReg2[nPosPrd][51]	:= 'N'
	//Se a movimentação for referente a Nota Fiscal de  Entrada
	if (cAliaQry)->MVTO == 'E'

		aTpReg2[nPosPrd][07]	:= (cAliaQry)->BS_ICMS
		aTpReg2[nPosPrd][08]	:= (cAliaQry)->ALQ_ICMS
		aTpReg2[nPosPrd][09]	:= (cAliaQry)->VL_IPI
		aTpReg2[nPosPrd][10]	:= (cAliaQry)->BS_ICMS_ST
		aTpReg2[nPosPrd][11]	:= (cAliaQry)->ALQ_IPI
		//aTpReg2[nPosPrd][12]	:= (cAliaQry)->	Perc.Red.ICMS
		aTpReg2[nPosPrd][13]	:= (cAliaQry)->ORIGEM_CST//Substring((cAliaQry)->ORIGEM_CST,2,2)//ORIGEM_CST2
		aTpReg2[nPosPrd][15]	:= (cAliaQry)->F4_CTIPI
		aTpReg2[nPosPrd][16]	:= (cAliaQry)->BS_IPI

		//fernando carvalho - alterado pois foi solicitado para que não preenche-se
		//Não preencher as bases e valores de PIS/COFINS nos itens, utilizar CST 70 para as entradas.
		aTpReg2[nPosPrd][17]	:= (cAliaQry)->F4_CSTPIS
		if((cAliaQry)->F4_CSTPIS =='70')
			aTpReg2[nPosPrd][18]	:= 0
			aTpReg2[nPosPrd][19]	:= 0
			//aTpReg2[nPosPrd][20]	:= (cAliaQry)->	Quantidade de Base de PIS
			//aTpReg2[nPosPrd][21]	:= (cAliaQry)->	Aliquota de PIS (R$)
			aTpReg2[nPosPrd][22]	:= 0
			aTpReg2[nPosPrd][23]	:= 0
			aTpReg2[nPosPrd][24]	:= 0
			aTpReg2[nPosPrd][25]	:= 0
			//aTpReg2[nPosPrd][26]	:= (cAliaQry)->	Quantidade de  Base de COFINS
			//aTpReg2[nPosPrd][27]	:= (cAliaQry)->	Aliquota de COFINS(R$)
			aTpReg2[nPosPrd][28]	:= 0
		Else
			aTpReg2[nPosPrd][18]	:= nBsPIS
			aTpReg2[nPosPrd][19]	:= nAlqPIS
			//aTpReg2[nPosPrd][20]	:= (cAliaQry)->	Quantidade de Base de PIS
			//aTpReg2[nPosPrd][21]	:= (cAliaQry)->	Aliquota de PIS (R$)
			aTpReg2[nPosPrd][22]	:= nVlPIS
			aTpReg2[nPosPrd][23]	:= (cAliaQry)->F4_CSTCOF
			aTpReg2[nPosPrd][24]	:= nBsCOF
			aTpReg2[nPosPrd][25]	:= nAlqCOF
			//aTpReg2[nPosPrd][26]	:= (cAliaQry)->	Quantidade de  Base de COFINS
			//aTpReg2[nPosPrd][27]	:= (cAliaQry)->	Aliquota de COFINS(R$)
			aTpReg2[nPosPrd][28]	:= nVlCOF
		endif
		aTpReg2[nPosPrd][29]	:= (cAliaQry)->VL_ICMS_ST
		aTpReg2[nPosPrd][30]	:= (cAliaQry)->MARGEM//ALIQ_SOLID //ALIQUOTA DE ICMS ST
		aTpReg2[nPosPrd][31]	:= (cAliaQry)->VL_ICMS
		aTpReg2[nPosPrd][32]	:= (cAliaQry)->CFOP

	EndIf
	aTpReg2[nPosPrd][33]	:= (cAliaQry)->UNIDADE

	if !Empty((cAliaQry)->F4_CSOSN)

		aTpReg2[nPosPrd][48]	:= 'S'

	Else

		aTpReg2[nPosPrd][48]	:= 'N'

	EndIf

	//Valores de credito referente ao PIS e COFINS \\(cAliaQry)->MVTO == 'E'
	If (cAliaQry)->F4_TPREG	== '2' .AND. (cAliaQry)->F4_PISCRED	== '1'

		aTpReg2[nPosPrd][55]	:= (cAliaQry)->VL_PIS
		aTpReg2[nPosPrd][56]	:= (cAliaQry)->VL_COF

	EndIf

	//Se a  movimentação for referente a nota fiscal de saída
	if (cAliaQry)->MVTO == 'S'

		aTpReg2[nPosPrd][57]	:= (cAliaQry)->VL_FRETE
		aTpReg2[nPosPrd][58]	:= (cAliaQry)->VL_SEGURO
		aTpReg2[nPosPrd][59]	:= (cAliaQry)->VL_DESPESA
		aTpReg2[nPosPrd][60]	:= (cAliaQry)->CFOP
		aTpReg2[nPosPrd][61]	:= (cAliaQry)->B1_ORIGEM
		aTpReg2[nPosPrd][62]	:= (cAliaQry)->ORIGEM_CST//Substring((cAliaQry)->ORIGEM_CST,2,2)
		aTpReg2[nPosPrd][63]	:= (cAliaQry)->BS_ICMS
		aTpReg2[nPosPrd][64]	:= (cAliaQry)->ALQ_ICMS
		aTpReg2[nPosPrd][65]	:= (cAliaQry)->VL_ICMS
		aTpReg2[nPosPrd][66]	:= (cAliaQry)->BS_ICMS_ST
		aTpReg2[nPosPrd][67]	:= (cAliaQry)->MARGEM//ALIQ_SOLID
		aTpReg2[nPosPrd][68]	:= (cAliaQry)->VL_ICMS_ST
		aTpReg2[nPosPrd][69]	:= (cAliaQry)->F4_CTIPI
		aTpReg2[nPosPrd][70]	:= (cAliaQry)->BS_IPI
		aTpReg2[nPosPrd][71]	:= (cAliaQry)->ALQ_IPI
		aTpReg2[nPosPrd][72]	:= (cAliaQry)->VL_IPI
		aTpReg2[nPosPrd][73]	:= (cAliaQry)->F4_CSTPIS
		aTpReg2[nPosPrd][74]	:= nBsPIS
		aTpReg2[nPosPrd][75]	:= nAlqPIS
		aTpReg2[nPosPrd][76]	:= nVlPIS
		//aTpReg2[nPosPrd][77]	:= (cAliaQry)->	Saida Qtde Base PIS
		//aTpReg2[nPosPrd][78]	:= (cAliaQry)->	Saida Aliq Valor PIS
		aTpReg2[nPosPrd][79]	:= (cAliaQry)->F4_CSTCOF
		aTpReg2[nPosPrd][80]	:= nBsCOF
		aTpReg2[nPosPrd][81]	:= nAlqCOF
		aTpReg2[nPosPrd][82]	:= nVlCOF
		//aTpReg2[nPosPrd][83]	:= (cAliaQry)->	Saida Qtde Base Cofins
		//aTpReg2[nPosPrd][84	:= (cAliaQry)->	Saida Aliq Valor COFINS

	EndIf

Return aTpReg2[nPosPrd]
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MtCabNFE
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 09/09/2016
@version 1.0
@param aTpReg1, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MtCabNFE(nPosCab,aTpReg1)

	Local nPosAliq	:= 0
	Local aSerieSb	:= {'',''}

	If nPosCab == 1
		if Valtype(aTpReg1[nPosCab][01]) == 'U'

			aTpReg1[nPosCab][01]	:= '1'

			if !Empty((cAliaQry)->DTDIGIT)

				aTpReg1[nPosCab][02]	:=	(cAliaQry)->DTDIGIT//Data Lançamento: inclusão/transmissão

			Else

				aTpReg1[nPosCab][02]	:=	(cAliaQry)->EMISSAO//Data da Emissão da NF

			EndIf

			if (nTamNF := len(Alltrim((cAliaQry)->NOTAFISCAL))) > 6

				aTpReg1[nPosCab][03]	:= Substring((cAliaQry)->NOTAFISCAL,nTamNF-6+1,6)//	Número Nota campo obrigatório
				aTpReg1[nPosCab][69]	:= (cAliaQry)->NOTAFISCAL

			Else

				aTpReg1[nPosCab][03]	:= (cAliaQry)->NOTAFISCAL//	Número Nota

			EndIf

			aTpReg1[nPosCab][04]	:= (cAliaQry)->EMISSAO//	Data Documento
			aTpReg1[nPosCab][05]	:= (cAliaQry)->MODELONF

			//Fazer tratamento para separar o numerico do caracter
			if !Empty((cAliaQry)->SERIE)

				aSerieSb	:= TratSerie(aSerieSb)

				aTpReg1[nPosCab][06]	:= aSerieSb[1] //Série
				aTpReg1[nPosCab][07]	:= aSerieSb[2]//SubSérie

			EndIf

			aTpReg1[nPosCab][09]	:= '01'
			aTpReg1[nPosCab][13]	:= (cAliaQry)->TVL_BRUTO

			aTpReg1[nPosCab][41]	:= (cAliaQry)->ESPECIE
			aTpReg1[nPosCab][39]	:= (cAliaQry)->TICMS_DEFERIDO//Diferidas

			if (cAliaQry)->MVTO == 'S'

				aTpReg1[nPosCab][42]	:= cAvista

			EndIf
			aTpReg1[nPosCab][14]	:= 0
			aTpReg1[nPosCab][15]	:= 0
			aTpReg1[nPosCab][18]	:= (cAliaQry)->BS_ICMS
			aTpReg1[nPosCab][19]	:= (cAliaQry)->ALQ_ICMS
			aTpReg1[nPosCab][20]	:= (cAliaQry)->VL_ICMS
			aTpReg1[nPosCab][21]	:= 0
			aTpReg1[nPosCab][22]	:= 0
			aTpReg1[nPosCab][23]	:= 0
			aTpReg1[nPosCab][24]	:= 0
			aTpReg1[nPosCab][25]	:= 0
			aTpReg1[nPosCab][26]	:= 0
			aTpReg1[nPosCab][27]	:= 0
			aTpReg1[nPosCab][28]	:= 0
			aTpReg1[nPosCab][29]	:= 0
			aTpReg1[nPosCab][77]	:= 0
			aTpReg1[nPosCab][78]	:= 0
			aTpReg1[nPosCab][79]	:= 0
			aTpReg1[nPosCab][80]	:= 0
			aTpReg1[nPosCab][81]	:= 0
			aTpReg1[nPosCab][82]	:= 0
			aTpReg1[nPosCab][30]	:= 0
			aTpReg1[nPosCab][31]	:= 0
			aTpReg1[nPosCab][32]	:= 0
			aTpReg1[nPosCab][33]	:= 0
			aTpReg1[nPosCab][34]	:= 0
			aTpReg1[nPosCab][35]	:= 0
			aTpReg1[nPosCab][36]	:= 0
			aTpReg1[nPosCab][37]	:= 0
			aTpReg1[nPosCab][38]	:= 0
			aTpReg1[nPosCab][44]	:= 0
			aTpReg1[nPosCab][45]	:= 0
			aTpReg1[nPosCab][46]	:= 0
			aTpReg1[nPosCab][47]	:= 0
			aTpReg1[nPosCab][48]	:= 0
			aTpReg1[nPosCab][16]	:= 0
			aTpReg1[nPosCab][17]	:= 0
			aTpReg1[nPosCab][49]	:= 0
			aTpReg1[nPosCab][52]	:= 0
			aTpReg1[nPosCab][50]	:= 0
			aTpReg1[nPosCab][51]	:= 0
			aTpReg1[nPosCab][72]	:= 0
			aTpReg1[nPosCab][74]	:= 0
			aTpReg1[nPosCab][75]	:= 0
			aTpReg1[nPosCab][76]	:= 0
			//aTpReg1[nPosCab][40]	:= (cAliaQry)->	Observações

			if (cAliaQry)->UF == 'EX'

				aTpReg1[nPosCab][56]	:= (cAliaQry)->CLIEFOR //	Identificação Exterior

			EndIf

			if (cAliaQry)->FORMULARIO == 'S'

				aTpReg1[nPosCab][64]	:= 'P'//	Tipo emissão// propria

			Elseif  (cAliaQry)->FORMULARIO == 'N'

				aTpReg1[nPosCab][64]	:= 'T'//	Tipo emissão terceiros

			EndIf

			aTpReg1[nPosCab][65]	:= (cAliaQry)->TIPO_FRETE//	Modalidade do Frete
			//aTpReg1[nPosCab][70]	:= (cAliaQry)->	Observações 2
			//aTpReg1[nPosCab][71]	:= (cAliaQry)->	Centro de Custo

		EndIf

		if (cAliaQry)->F4_LFICM == 'I'

			aTpReg1[nPosCab][30]	:= aTpReg1[nPosCab][30]+(cAliaQry)->TOTAL_ITEM//	Isentas ICMS

		Elseif (cAliaQry)->F4_LFICM == 'O'

			aTpReg1[nPosCab][31]	:= aTpReg1[nPosCab][31]+ (cAliaQry)->TOTAL_ITEM//	Outros ICMS

		EndIf

		if (cAliaQry)->F4_LFIPI == 'T'

			aTpReg1[nPosCab][32]	:= aTpReg1[nPosCab][32]+ (cAliaQry)->BS_IPI//	Base IPI
			aTpReg1[nPosCab][33]	:= aTpReg1[nPosCab][33]+ (cAliaQry)->VL_IPI//Valor IPI

		Elseif (cAliaQry)->F4_LFIPI == 'I'

			aTpReg1[nPosCab][34]	:=  aTpReg1[nPosCab][34]+(cAliaQry)->TOTAL_ITEM//	Isentas IPI

		Elseif (cAliaQry)->F4_LFIPI == 'O'

			aTpReg1[nPosCab][35]	:= aTpReg1[nPosCab][35]+ (cAliaQry)->TOTAL_ITEM//	Outras IPI

		EndIf

		aTpReg1[nPosCab][74]	:= aTpReg1[nPosCab][74]+(cAliaQry)->VL_DIFAL_FCP	//ICMS Relativo ao FCP
		aTpReg1[nPosCab][75]	:= aTpReg1[nPosCab][75]+(cAliaQry)->VL_DIFAL //	ICMS UF de Destino
		aTpReg1[nPosCab][76]	:= aTpReg1[nPosCab][76]+((cAliaQry)->VL_ICMS*(cAliaQry)->P_DIFAL_ORIG)/100//	ICMS UF de Origem

		if (cAliaQry)->MVTO == 'E'

			aTpReg1	:= MntEnt(aTpReg1,nPosCab)

		EndIf
	Else

		//trata quando tem mais de duas naturezas (CFOP)
		If aTpReg1[1][8] <> (cAliaQry)->CFOP
			aTpReg1[1][43] := (cAliaQry)->CFOP
		Endif
		//QUANDO existe mais de uma base, aliquota e valor de ICMS
		If nPosCab == 2
			aTpReg1[1][21] := (cAliaQry)->BS_ICMS
			aTpReg1[1][22] := (cAliaQry)->ALQ_ICMS
			aTpReg1[1][23] := (cAliaQry)->VL_ICMS

		Elseif nPosCab	== 3
			aTpReg1[1][24] := (cAliaQry)->BS_ICMS
			aTpReg1[1][25] := (cAliaQry)->ALQ_ICMS
			aTpReg1[1][26] := (cAliaQry)->VL_ICMS
		Elseif nPosCab	== 4
			aTpReg1[1][27] := (cAliaQry)->BS_ICMS
			aTpReg1[1][28] := (cAliaQry)->ALQ_ICMS
			aTpReg1[1][29] := (cAliaQry)->VL_ICMS
		Endif
	EndIf
Return aTpReg1
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MntEnt
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 13/09/2016
@version 1.0
@param aTpReg1, array, (Descrição do parâmetro)
@param nPosCab, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function MntEnt(aTpReg1,nPosCab)

	Local nPosAliq	:= 0
	Local aAreaSA2	:= {}

	aTpReg1[nPosCab][08]	:= (cAliaQry)->CFOP
	aTpReg1[nPosCab][12]	:= cRemeten	//CNPJ/CPF Emitente

	//Preenche o CNPJ do Remetente/Fornecedor
	/*if	(cAliaQry)->TIPONF <> 'D'
	
		if !Empty(cRemeten)
		
			aTpReg1[nPosCab][12]	:= cRemeten	//CNPJ/CPF Emitente
		
		Else
		
			aAreaSA2	:= SA2->(GetArea())
			
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			if SA2->(dbSeek(xFilial("SA2")+(cAliaQry)->CLIEFOR+(cAliaQry)->LOJA))
			
				aTpReg1[nPosCab][12]	:=	SA2->A2_CGC
			
			EndIf
			
			RestArea(aAreaSA2)
			
		EndIf
	
	EndIf
		*/	
	aTpReg1[nPosCab][14]	:= (cAliaQry)->TBS_PIS_A+(cAliaQry)->TBS_PIS_R//	Base PIS
	aTpReg1[nPosCab][15]	:= (cAliaQry)->TBS_COF_A+(cAliaQry)->TBS_COF_R//Base COFINS

	//Trecho que irá somar os valores de cada item da nota fiscal para gerar o tipo de registro  1 cabeçalho da nota fiscal
	if (cAliaQry)->F4_CREDICM == 'S' .AND. (cAliaQry)->ALQ_ICMS <> 0

		//Unica operação pode ter várias aliquotas conforme origem do produto por exemplo.
		if (nPosAliq	:= Ascan(aCFOsNF[nPosCab],{ |x| x == Transform((cAliaQry)->ALQ_ICMS, "99.99") })) == 0

			aAdd(aCFOsNF[nPosCab],TRansform((cAliaQry)->ALQ_ICMS, "99.99"))

			nPosAliq	:= len(aCFOsNF[nPosCab])

		EndIf

		nPosAliq	:= nPosAliq - 1

		if nPosAliq  == 0 .OR. nPosAliq == 1

			aTpReg1[nPosCab][18]	:= aTpReg1[nPosCab][18]+ (cAliaQry)->BS_ICMS//	Base ICMS A
			aTpReg1[nPosCab][19]	:= (cAliaQry)->ALQ_ICMS//	Aliquota ICMS A
			aTpReg1[nPosCab][20]	:= aTpReg1[nPosCab][20]+(cAliaQry)->VL_ICMS //Valor ICMS A

		EndIf

		if nPosAliq == 2

			aTpReg1[nPosCab][21]	:= aTpReg1[nPosCab][21]+(cAliaQry)->BS_ICMS//	Base ICMS B
			aTpReg1[nPosCab][22]	:= (cAliaQry)->ALQ_ICMS//	Aliquota ICMS B
			aTpReg1[nPosCab][23]	:= aTpReg1[nPosCab][23]+(cAliaQry)->VL_ICMS //	Valor ICMS B

		EndIf

		if nPosAliq == 3

			aTpReg1[nPosCab][24]	:= aTpReg1[nPosCab][24]+(cAliaQry)->BS_ICMS//	Base ICMS C
			aTpReg1[nPosCab][25]	:= (cAliaQry)->ALQ_ICMS//	Aliquota ICMS C
			aTpReg1[nPosCab][26]	:= aTpReg1[nPosCab][26]+(cAliaQry)->VL_ICMS //	Valor ICMS C

		EndIf

		if nPosAliq == 4

			aTpReg1[nPosCab][27]	:= aTpReg1[nPosCab][27]+(cAliaQry)->BS_ICMS//	Base ICMS D
			aTpReg1[nPosCab][28]	:= (cAliaQry)->ALQ_ICMS//	Aliquota ICMS D
			aTpReg1[nPosCab][29]	:= aTpReg1[nPosCab][29]+(cAliaQry)->VL_ICMS //	Valor ICMS D

		EndIf

		if  nPosAliq == 5

			aTpReg1[nPosCab][77]	:= aTpReg1[nPosCab][77]+(cAliaQry)->BS_ICMS//	Base ICMS E
			aTpReg1[nPosCab][78]	:= (cAliaQry)->ALQ_ICMS//	Aliquota de ICMS E
			aTpReg1[nPosCab][79]	:= aTpReg1[nPosCab][79]+(cAliaQry)->VL_ICMS //	Valor ICMS E

		EndIf

		if  nPosAliq == 6

			aTpReg1[nPosCab][80]	:= aTpReg1[nPosCab][80]+(cAliaQry)->BS_ICMS//	Base ICMS F
			aTpReg1[nPosCab][81]	:= (cAliaQry)->ALQ_ICMS//	Aliquota ICMS F
			aTpReg1[nPosCab][82]	:= aTpReg1[nPosCab][82]+(cAliaQry)->VL_ICMS //	Valor ICMS F

		EndIf

	EndIf

	aTpReg1[nPosCab][36]	:= aTpReg1[nPosCab][36]+(cAliaQry)->VL_ICMS_ST// (cAliaQry)->	Mercadoria ST
	aTpReg1[nPosCab][37]	:= aTpReg1[nPosCab][37]+(cAliaQry)->BS_ICMS_ST//	Base ST
	aTpReg1[nPosCab][38]	:= aTpReg1[nPosCab][38]+(cAliaQry)->VL_ICMS_ST//ICMS ST
	aTpReg1[nPosCab][45]	:= aTpReg1[nPosCab][45]+(cAliaQry)->BS_ISS//	Base ISS
	aTpReg1[nPosCab][46]	:= aTpReg1[nPosCab][46]+(cAliaQry)->ALQ_ISS//	Aliquota ISS
	aTpReg1[nPosCab][47]	:= aTpReg1[nPosCab][47]+(cAliaQry)->VL_ISS//	valor ISS

	//aTpReg1[nPosCab][48]	:= (cAliaQry)->Isentas ISS

	aTpReg1[nPosCab][16]	:= aTpReg1[nPosCab][16]+(cAliaQry)->VL_CSLL	//Base CSLL
	aTpReg1[nPosCab][17]	:= aTpReg1[nPosCab][17]+(cAliaQry)->VL_IRRF	//Base IRPJ

	if (cAliaQry)->VL_IRRF <> 0

		aTpReg1[nPosCab][49]	:= aTpReg1[nPosCab][49]+(cAliaQry)->VL_IRRF //	IRRF Retido

	EndIf

	if (cAliaQry)->VL_CSLL <> 0

		aTpReg1[nPosCab][52]	:= aTpReg1[nPosCab][52]+(cAliaQry)->VL_CSLL //	CSLL Retido

	EndIf

	//aTpReg1[nPosCab][43]	:= (cAliaQry)->	Nat. Operação ST TRATAR QDO UMA NF TIVER UM CFOP DE ST + UM CFOP NORMAL
	aTpReg1[nPosCab][44]	:= aTpReg1[nPosCab][44]+(cAliaQry)->BS_COF_ST//Base PIS/COFINS st

	if (cAliaQry)->VL_PIS_R <> 0

		aTpReg1[nPosCab][50]	:= aTpReg1[nPosCab][50]+(cAliaQry)->VL_PIS_R//	PIS Retido

	EndIF

	if  (cAliaQry)->VL_COF_R <> 0

		aTpReg1[nPosCab][51]	:= aTpReg1[nPosCab][51]+(cAliaQry)->VL_COF_R	//COFINS Retido

	EndIf

	//aTpReg1[nPosCab][53]	:= (cAliaQry)->	Data Pagamento
	//aTpReg1[nPosCab][57]	:= (cAliaQry)->	INSS Retido
	//aTpReg1[nPosCab][58]	:= (cAliaQry)->	Funrural Retido
	//aTpReg1[nPosCab][59]	:= (cAliaQry)->	Código Serviço
	//aTpReg1[nPosCab][60]	:= (cAliaQry)->	ISS Retido S/N
	//aTpReg1[nPosCab][61]	:= (cAliaQry)->	ISS Devido  Prestação
	//aTpReg1[nPosCab][62]	:= (cAliaQry)->	UF Prestação
	//aTpReg1[nPosCab][63]	:= (cAliaQry)->	Municipio Prestação
	aTpReg1[nPosCab][72]	:= aTpReg1[nPosCab][72]+(cAliaQry)->BS_COF_ST//	Base de PIS/COFINS/ICMS ST
	//aTpReg1[nPosCab][73]	:= (cAliaQry)->	Data Emissao RPS

Return aTpReg1
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TratSerie
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 12/09/2016
@version 1.0
@param aSerieSb, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function TratSerie(aSerieSb)

	Local iDigSer	:= 0
	Local cDigSer	:= ''
	Local cSerieAt	:= Alltrim((cAliaQry)->SERIE)

	For iDigSer	:= 1 to len(cSerieAt)

		cDigSer	:= Substring(cSerieAt,iDigSer,1)

		if cDigSer $ '0|1|2|3|4|5|6|7|8|9'

			aSerieSb[1] := aSerieSb[2] +cDigSer

		Else

			aSerieSb[2] := aSerieSb[1] +cDigSer

		EndIf

	Next iDigSer

Return aSerieSb
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DdCompl
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 09/09/2016
@version 1.0
@param aTpReg5, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function DdCompl(aTpReg5)

	aTpReg5[1][02]	:= (cAliaQry)->TVL_BRUTO
	aTpReg5[1][03]	:= (cAliaQry)->TVL_DESCONTO
	aTpReg5[1][04]	:= (cAliaQry)->TVL_FRETE
	aTpReg5[1][05]	:= (cAliaQry)->TVL_DESPESA
	aTpReg5[1][06]	:= (cAliaQry)->TVL_SEGURO
	aTpReg5[1][07]	:= (cAliaQry)->TPBRUTO
	aTpReg5[1][08]	:= (cAliaQry)->TPLIQUIDO
	aTpReg5[1][09]	:= (cAliaQry)->CGCTRANSP
	aTpReg5[1][10]	:= 0//TRATAR 0 - Rodoviário 1 - Ferroviário 2 - Aeroviário 3 - Hidroviário 4 - Outros
	aTpReg5[1][11]	:= (cAliaQry)->PLACA
	aTpReg5[1][12]	:= (cAliaQry)->VOLUME1
	aTpReg5[1][13]	:= (cAliaQry)->ESPECI1
	aTpReg5[1][14]	:= (cAliaQry)->CHVNFE

	if (cAliaQry)->TICMS_RET <> 0

		aTpReg5[1][15]	:= 'S'//(cAliaQry)->	ICMS-ST Retido Antecipadamente

	Else

		aTpReg5[1][15]	:= 'N'//(cAliaQry)->	ICMS-ST Retido Antecipadamente

	EndIf

	if (cAliaQry)->MVTO == 'E' .AND. Substring((cAliaQry)->CFOP,1,1) == '3'//.AND. (cAliaQry)->FORMULARIO  == 'S'
		//aTpReg5[1][16]	:= (cAliaQry)->	Inscrição Estadual Remetente
		aTpReg5	:= DdImport(aTpReg5)
		//aTpReg5[1][29]	:= (cAliaQry)->	chave CT-e referencia
		//carregar a CD5 complemento de Importação
		//	aTpReg5[1][40]	:= (cAliaQry)->	vale pedágio
	EndIf

Return aTpReg5


Static Function DdComplS(aTpReg5)

	aTpReg5[1][02]	:= (cAliaQry)->TVL_BRUTO
	aTpReg5[1][03]	:= (cAliaQry)->TVL_DESCONTO
	aTpReg5[1][04]	:= (cAliaQry)->TVL_FRETE
	aTpReg5[1][05]	:= (cAliaQry)->TVL_DESPESA
	aTpReg5[1][06]	:= (cAliaQry)->TVL_SEGURO
	aTpReg5[1][07]	:= (cAliaQry)->TPBRUTO
	aTpReg5[1][08]	:= (cAliaQry)->TPLIQUIDO
	aTpReg5[1][09]	:= (cAliaQry)->CGCTRANSP
	aTpReg5[1][10]	:= (cAliaQry)->TIPO_FRETE//TRATAR 0 - Rodoviário 1 - Ferroviário 2 - Aeroviário 3 - Hidroviário 4 - Outros
	aTpReg5[1][11]	:= (cAliaQry)->PLACA
	aTpReg5[1][12]	:= (cAliaQry)->VOLUME1
	aTpReg5[1][13]	:= (cAliaQry)->ESPECI1
	aTpReg5[1][26]	:= (cAliaQry)->CHVNFE

	if (cAliaQry)->TICMS_RET <> 0

		aTpReg5[1][33]	:= 'S'//(cAliaQry)->	ICMS-ST Retido Antecipadamente

	Else

		aTpReg5[1][33]	:= 'N'//(cAliaQry)->	ICMS-ST Retido Antecipadamente

	EndIf

Return aTpReg5
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DdImport
(long_description)
@type function
@author Cris
@since 14/09/2016
@version 1.0
@param aTpReg5, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function DdImport(aTpReg5)

	Local aAreaCD5	:= CD5->(GetArea())

	dbSelectArea('CD5')
	CD5->(dbSetOrder(1))
	if CD5->(dbSeek((cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE+(cAliaQry)->CLIEFOR+(cAliaQry)->LOJA))

		aTpReg5[1][30]	:= CD5->CD5_LOCAL //Tipo importação
		aTpReg5[1][31]	:= CD5->CD5_TPIMP//Tipo documento importação
		aTpReg5[1][32]	:= CD5->CD5_DOCIMP//número DI siscomex
		//	aTpReg5[1][33]	:= (cAliaQry)->	numero ato Drawback
		aTpReg5[1][34]	:= CD5->CD5_BSPIS//Base PIS importação
		aTpReg5[1][35]	:= CD5->CD5_VLPIS//Valor PIS importação
		aTpReg5[1][36]	:= Dtos(CD5->CD5_DTPPIS)//data pagamento PIS/PASEP
		aTpReg5[1][37]	:= CD5->CD5_BSCOF //base cofins importação
		aTpReg5[1][38]	:= CD5->CD5_VLCOF//valor cofins importação
		aTpReg5[1][39]	:= Dtos(CD5->CD5_DTPCOF) //data pagamento COFINS

	EndIf

	RestArea(aAreaCD5)

Return aTpReg5
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Trailler
(long_description)
@type function
@author Cristiane Thomaz Polli
@since 09/09/2016
@version 1.0
@param aTpReg3, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
//---------------------------------------------------------------------------------------------------------------------------
Static Function Trailler(aTpReg3,aTpReg1,cTipo)

	Local iTpReg1	:= 0

	if 	cTipo == 'E'
		If Len(aTpReg1)>1
			aTpReg1	:= aSize(aTpReg1,1)
		Endif

		For iTpReg1	:= 1 to Len(aTpReg1)


			aTpReg3[1][02]	:= aTpReg3[1][02] + aTpReg1[iTpReg1][13]//Valor contábil
			aTpReg3[1][03]	:= aTpReg3[1][03] + aTpReg1[iTpReg1][14]//Base PIS
			aTpReg3[1][04]	:= aTpReg3[1][04] + aTpReg1[iTpReg1][15]//Base COFINS
			aTpReg3[1][05]	:= aTpReg3[1][05] + aTpReg1[iTpReg1][16]//Base CSLL
			aTpReg3[1][06]	:= aTpReg3[1][06] + aTpReg1[iTpReg1][17]//Base IRPJ
			aTpReg3[1][07]	:= aTpReg3[1][07] + aTpReg1[iTpReg1][18]//Base ICMS A
			aTpReg3[1][08]	:= aTpReg3[1][08] + aTpReg1[iTpReg1][20]//Valor ICMS A
			aTpReg3[1][09]	:= aTpReg3[1][09] + aTpReg1[iTpReg1][21]//Base ICMS B
			aTpReg3[1][10]	:= aTpReg3[1][10] + aTpReg1[iTpReg1][23]//Valor ICMS B
			aTpReg3[1][11]	:= aTpReg3[1][11] + aTpReg1[iTpReg1][24]//Base ICMS C
			aTpReg3[1][12]	:= aTpReg3[1][12] + aTpReg1[iTpReg1][26]//Valor ICMS C
			aTpReg3[1][13]	:= aTpReg3[1][13] + aTpReg1[iTpReg1][27]//Base ICMS D
			aTpReg3[1][14]	:= aTpReg3[1][14] + aTpReg1[iTpReg1][29]//Valor ICMS D
			aTpReg3[1][25]	:= aTpReg3[1][25] + aTpReg1[iTpReg1][77]//Base ICMS E
			aTpReg3[1][26]	:= aTpReg3[1][26] + aTpReg1[iTpReg1][79]//Valor ICMS E
			aTpReg3[1][27]	:= aTpReg3[1][27] + aTpReg1[iTpReg1][80]//Base ICMS F
			aTpReg3[1][28]	:= aTpReg3[1][28] + aTpReg1[iTpReg1][82]//Valor ICMS F*/
			aTpReg3[1][15]	:= aTpReg3[1][15] + aTpReg1[iTpReg1][30]//Isentas ICMS
			aTpReg3[1][16]	:= aTpReg3[1][16] + aTpReg1[iTpReg1][31]//Outras ICMS
			aTpReg3[1][17]	:= aTpReg3[1][17] + aTpReg1[iTpReg1][32]//Base IPI
			aTpReg3[1][18]	:= aTpReg3[1][18] + aTpReg1[iTpReg1][33]//Valor IPI
			aTpReg3[1][19]	:= aTpReg3[1][19] + aTpReg1[iTpReg1][34]//Isentas IPI
			aTpReg3[1][20]	:= aTpReg3[1][20] + aTpReg1[iTpReg1][35]//Outras IPI
			aTpReg3[1][21]	:= aTpReg3[1][21] + aTpReg1[iTpReg1][36]//Mercadorias ST
			aTpReg3[1][22]	:= aTpReg3[1][22] + aTpReg1[iTpReg1][37]//Base ST
			aTpReg3[1][23]	:= aTpReg3[1][23] + aTpReg1[iTpReg1][38]//ICMS ST
			aTpReg3[1][24]	:= aTpReg3[1][24] + aTpReg1[iTpReg1][39]//Diferidas

		Next iTpReg1

	Else

		For iTpReg1	:= 1 to len(aTpReg1)

			aTpReg3[1][02]	:= aTpReg3[1][02] + aTpReg1[iTpReg1][15]//Valor contábil
			aTpReg3[1][03]	:= aTpReg3[1][03] + aTpReg1[iTpReg1][16]//Base PIS
			aTpReg3[1][04]	:= aTpReg3[1][04] + aTpReg1[iTpReg1][17]//Base COFINS
			aTpReg3[1][05]	:= aTpReg3[1][05] + aTpReg1[iTpReg1][18]//Base CSLL
			aTpReg3[1][06]	:= aTpReg3[1][06] + aTpReg1[iTpReg1][19]//Base IRPJ
			aTpReg3[1][07]	:= aTpReg3[1][07] + aTpReg1[iTpReg1][21]//Base ICMS A
			aTpReg3[1][08]	:= aTpReg3[1][08] + aTpReg1[iTpReg1][22]//Valor ICMS A
			aTpReg3[1][15]	:= aTpReg3[1][15] + aTpReg1[iTpReg1][33]//Isentas ICMS
			aTpReg3[1][16]	:= aTpReg3[1][16] + aTpReg1[iTpReg1][34]//Outras ICMS
			aTpReg3[1][17]	:= aTpReg3[1][17] + aTpReg1[iTpReg1][35]//Base IPI
			aTpReg3[1][18]	:= aTpReg3[1][18] + aTpReg1[iTpReg1][36]//Valor IPI
			aTpReg3[1][19]	:= aTpReg3[1][19] + aTpReg1[iTpReg1][37]//Isentas IPI
			aTpReg3[1][20]	:= aTpReg3[1][20] + aTpReg1[iTpReg1][38]//Outras IPI
			aTpReg3[1][21]	:= aTpReg3[1][21] + aTpReg1[iTpReg1][39]//Mercadorias ST
			aTpReg3[1][22]	:= aTpReg3[1][22] + aTpReg1[iTpReg1][40]//Base ST
			aTpReg3[1][23]	:= aTpReg3[1][23] + aTpReg1[iTpReg1][41]//ICMS ST
			aTpReg3[1][24]	:= aTpReg3[1][24] + aTpReg1[iTpReg1][39]//Diferidas

		Next iTpReg1

	EndIF

Return aTpReg3
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DHME00A2
(long_description)
@type function
@author Cris
@since 01/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*///---------------------------------------------------------------------------------------------------------------------------
User Function DHME00A2()

	Local aPergs 	:= {}
	Local dDtDgIni	:= lastday((lastday(MsDate(),1))-1,1)
	Local dDtDgFim	:= Lastday(dDtDgIni,2)
	Local cFilPara	:= '02'
	Local cCSTST	:= SuperGetMV('ES_CSTST',,'00|10|60')
	Local cCFOPST	:=	SuperGetMV('ES_CFOPCST',,'')//'1911|1411|2411|1102|2102|1403|2403|1152|2152|1910|2910')
	Local aRetPara 	:= {}
	Local cAliaQry	:= ''
	Local aLayFor	:= {}
	Local aLayPrd	:= {}
	Local aLayNF	:= {}

	if Empty(Alltrim(cCFOPST))

		cCFOPST	:= 'Todos os CFOPs'

	EndIf

	aAdd( aPergs ,{1,"Data da Digitação de:",dDtDgIni,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Data da Digitação até:",dDtDgFim,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Filial:",cFilPara,"@!",'NAOVAZIO()','SM0','.T.',TamSX3('D1_FILIAL')[1],.F.})
	aAdd( aPergs ,{1,"Considera os CST:",cCSTST,"@!",'NAOVAZIO()','','.F.',len(Alltrim(cCSTST)),.F.})
	aAdd( aPergs ,{1,"Considera os CFOPs:",cCFOPST,"@!",'NAOVAZIO()','','.F.',50,.F.})

	MV_PAR04	:= 3//somente para compatibilidade no momento da gravaçaõ do arquivo

	U_RFATA99()

	If ParamBox(aPergs ,"Filtros",aRetPara)

		//Efetua a manutenção na tabela de Log
		AtuLog1(3,aRetPara)

		cAliaQry	:= GetNextAlias()

		FWMsgRun(,{||  SelEntST(@cAliaQry,aRetPara) },'Aguarde....' ,'Selecionando registros.')

		if !(cAliaQry)->(Eof())

			FWMsgRun(,{||  aLayFor	:= Layout(aLayFor,'E','004')},'Aguarde....' ,'Selecionando Layouts.')
			FWMsgRun(,{||  aLayPrd	:= Layout(aLayPrd,'E','005')},'Aguarde....' ,'Selecionando Layouts.')
			FWMsgRun(,{||  aLayNF	:= Layout(aLayNF,'E','006')},'Aguarde....' ,'Selecionando Layouts.')

			if len(aLayFor) > 0 .OR. Len(aLayPrd) > 0 .OR. Len(aLayNF) > 0

				//Monta o arquivo conforme layout x dados selecionados
				FWMsgRun(,{||  PrepArq(cAliaQry,aLayFor,aLayPrd,aLayNF,aRetPara) },'Aguarde....' ,'Preparando registros.')

			Else

				HELP("HELP",, 'Não Ativo - Layout',, "Não existem códigos de Layouts ativos ou existentes. Operação cancelada.", 1, 0)

			EndIf


		Else

			AtuLog1(4,aRetPara,'Não existem registros para os parametros selecionados!')

		EndIf

	Else

		Alert("Operação abortada pelo usuário. Pressionado Cancel para fechar a tela.")

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} AtuLog1
(long_description)
@type function
@author Cris
@since 01/02/2017
@version 1.0
@param nOperAtu, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function AtuLog1(nOperAtu,aRetPara,cInfOutr)

	Local 	oModelAtu	:= Nil
	Local 	lRet		:= .T.
	Local 	cTpArq		:= ''

	Local aErro   := {}
	Local cMensag := ""

	Default cInfOutr	:= ''

	oModelAtu := FWLoadModel("DHME0001")
	oModelAtu:SetOperation(nOperAtu)

	//Se a operação for alteração posiciono no log gravado.
	if nOperAtu == 4

		if !Z03->(dbSeek(xFilial('Z03')+cSeqZ03))

			HELP("HELP",, 'Não localizado Log',, "O Log número  "+cSeqZ03+" não foi localizado. Não será atualizado.", 1, 0)

			lRet	:= .F.
		EndIf

	EndIf

	if lRet

		lRet := oModelAtu:Activate()

	EndIf

	if lRet

		//Se for inclusão, esta iniciando as verificações para a geração do arquivo
		if nOperAtu == 3

			cSeqZ03	:= GetSXeNum("Z03","Z03_SEQUEN")
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_FILIAL" , xFilial("Z03"))
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_FILORI" , aRetPara[3])
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_SEQUEN" , cSeqZ03 )
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_DATINI" , dDataBase)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_HORINI" , Time())
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_RESPON" , LogUserName()+' Id Protheus '+__cUserID)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_PERINI" , aRetPara[1])
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_PERFIM" , aRetPara[2])
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_LAYOUT" , '*')

		Elseif nOperAtu == 4

			oModelAtu:GetModel('DHME0001'):SetValue("Z03_NOMARQ", "*")
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_CAMARQ", cDirArq)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_HORFIM", Time())
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_DATFIM", dDataBase)
			oModelAtu:GetModel('DHME0001'):SetValue("Z03_OUTPAR", cInfOutr)

		EndIf

		If oModelAtu:VldData()
			If !oModelAtu:CommitData()

				HELP("HELP",, 'Não gravou o log',, "Erro na gravação do Log.", 1, 0)

			EndIf

		Else

			aErro := oModelAtu:GetErrorMessage()

			cMensag := '{"Retorno":"200"' +;
				'"Id do formulário de origem:":'  + '"' + cValToChar(aErro[01]) + '"'+Chr(10)+Chr(13)+;
				'"Id do campo de origem: "    :'  + '"' + cValToChar(aErro[02]) + '"'+Chr(10)+Chr(13)+;
				'"Id do formulário de erro: " :'  + '"' + cValToChar(aErro[03]) + '"'+Chr(10)+Chr(13)+;
				'"Id do campo de erro: "      :'  + '"' + cValToChar(aErro[04]) + '"'+Chr(10)+Chr(13)+;
				'"Id do erro: "               :'  + '"' + cValToChar(aErro[05]) + '"'+Chr(10)+Chr(13)+;
				'"Mensagem do erro: "         :'  + '"' + cValToChar(aErro[06]) + '"'+Chr(10)+Chr(13)+;
				'"Mensagem da solução: "      :'  + '"' + cValToChar(aErro[07]) + '"'+Chr(10)+Chr(13)+;
				'"Valor atribuído: "          :'  + '"' + cValToChar(aErro[08]) + '"'+Chr(10)+Chr(13)+;
				'"Valor anterior: "           :'  + '"' + cValToChar(aErro[09]) + '"}'

			Alert(cMensag,'Erro')

			HELP("HELP",, 'Não gravou o log',, "Erro na validação dos dados do Log.", 1, 0)

		EndIf

	EndIf

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SelEntST
(long_description)
@type function
@author Cris
@since 01/02/2017
@version 1.0
@param cAliaQry, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function SelEntST(cAliaQry,aRetPara)

	Local cQryAtu	:= ''

	cQryAtu	:= "   SELECT D1_FILIAL, D1_DTDIGIT, D1_DOC,D1_SERIE,D1_FORNECE, D1_LOJA, D1_ITEM,D1_COD, D1_QUANT, "+CRLF
	cQryAtu	+= "				D1_VUNIT, D1_CLASFIS, D1_ALIQSOL,D1_PICM,D1_BASEICM, D1_BASEIPI, D1_ICMSRET, D1_BRICMS,   "+CRLF
	cQryAtu	+= "				(CASE   "+CRLF
	cQryAtu	+= "						WHEN D1_BRICMS <> 0  THEN  round((D1_BRICMS/D1_QUANT),2)   "+CRLF
	cQryAtu	+= "						ELSE D1_BRICMS  "+CRLF
	cQryAtu	+= "				END  "+CRLF
	cQryAtu	+= "				) ICSTUNIT,  "+CRLF
	cQryAtu	+= "				(CASE  "+CRLF
	cQryAtu	+= "						WHEN D1_BASEICM <> 0 THEN Round((D1_BASEICM/D1_QUANT),2)  "+CRLF
	cQryAtu	+= "						ELSE D1_BASEICM  "+CRLF
	cQryAtu	+= "				END ) ICUNIT,  "+CRLF
	cQryAtu	+= "				D1_MARGEM, D1_CF, "+CRLF
	cQryAtu	+= "				ISNULL((	SELECT TOP 1 F7_XGNREST "+CRLF
	cQryAtu	+= "							FROM "+RetSqlName("SF7")+" (NOLOCK)  "+CRLF
	cQryAtu	+= "							WHERE F7_FILIAL = '"+xFilial("SF7")+"' "+CRLF
	cQryAtu	+= "			  		 		  AND D_E_L_E_T_ = '' "+CRLF
	cQryAtu	+= "	   						  AND F7_XGNREST = 'S' "+CRLF
	cQryAtu	+= "			 		  		  AND F7_GRTRIB =(	SELECT B1_GRTRIB "+CRLF
	cQryAtu	+= "										FROM "+RetSqlName("SB1")+" (NOLOCK) "+CRLF
	cQryAtu	+= "										WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQryAtu	+= "								 		  AND B1_GRTRIB <> '' "+CRLF
	cQryAtu	+= "								  		  AND B1_COD = D1_COD "+CRLF
	cQryAtu	+= "								  AND D_E_L_E_T_ = '')) ,'') GERAGNREST, "+CRLF
	cQryAtu	+= "	(SELECT ISNULL(A2_XTICMST,'')  "+CRLF
	cQryAtu	+= "	  		FROM "+RetSqlName("SA2")+" (NOLOCK) "+CRLF
	cQryAtu	+= "	  		WHERE A2_FILIAL = '"+xFilial("SA2")+"' "+CRLF
	cQryAtu	+= "	  		  AND A2_COD = D1_FORNECE 	"+CRLF
	cQryAtu	+= "	  		  AND A2_LOJA = D1_LOJA "+CRLF
	cQryAtu	+= "	  		  AND D_E_L_E_T_ = ''	) TPFORNEC	 "+CRLF
	cQryAtu	+= "	FROM "+RetSqlName("SD1")+" (NOLOCK) "+CRLF
	cQryAtu	+= "	WHERE D_E_L_E_T_ = '' "+CRLF
	cQryAtu	+= "	  AND D1_FILIAL  = '"+aRetPara[3]+"' "+CRLF
	cQryAtu	+= "	  AND D1_DTDIGIT BETWEEN '"+Dtos(aRetPara[1])+"' AND '"+Dtos(aRetPara[2])+"' "+CRLF
	cQryAtu	+= "	  AND D1_TES IN (	SELECT F4_CODIGO  "+CRLF
	cQryAtu	+= "	 					FROM "+RetSqlName("SF4")+" (NOLOCK) "+CRLF
	cQryAtu	+= "	 					WHERE F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQryAtu	+= "	 					  AND F4_XCAT158 = 'S' "+CRLF
	cQryAtu	+= "	 					  AND D_E_L_E_T_ = '') "+CRLF
	cQryAtu	+= "	  AND SUBSTRING(D1_CLASFIS,2,2) IN ('"+StrTran(aRetPara[4],'|',"','")+"')  "+CRLF

	if !'TODOS' $ UPPER(aRetPara[5])

		cQryAtu	+= "	AND D1_CF IN ('"+StrTran(aRetPara[5],'|',"','")+"')"+CRLF

	EndIf

	cQryAtu := ChangeQuery(cQryAtu)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryAtu),cAliaQry,.T.,.T.)

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} PrepArq
(long_description)
@type function
@author Cris
@since 01/02/2017
@version 1.0
@param cAliaQry, character, (Descrição do parâmetro)
@param aLayFor, array, (Descrição do parâmetro)
@param aLayPrd, array, (Descrição do parâmetro)
@param aLayNF, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function PrepArq(cAliaQry,aLayFor,aLayPrd,aLayNF,aRetPara)

	Local aConteudo	:= {}
	Local aProdNfs	:= {{},{}}
	Local aFornec	:= {{},{}}
	Local cAnoMes	:= ''
	Local cInfOutr	:= ''
	Local cForAux	:= ''
	Local cParNm	:= aRetPara[3]+'_'+StrZero(Year(aRetPara[1]),4)+StrZero(Month(aRetPara[1]),2)+'_'+Dtos(dDatabase)+'_'+StrTran(Alltrim(Time()),":", "_")
	Local lSelArq	:= .F.

	if len(aLayNF) > 0

		cInfOutr	:= 'Resumo de informações:'+CRLF+CRLF
		cArqAtu		:= 	"VBASECALC_"+cParNm+".TXT"
		cInfOutr	+=	cArqAtu+CRLF

		//if SelDirGrv(cArqAtu)

		While !(cAliaQry)->(Eof())

			if Substring((cAliaQry)->D1_CLASFIS,2,2) == '00' .AND.  (cAliaQry)->GERAGNREST	<> 'S'

				(cAliaQry)->(dbSkip())
				Loop

			EndIf

			if (cAliaQry)->TPFORNEC $ '1|2|3'

				//Garante que somente após um registro válido o arquivo é criado e locado para ser preechido
				if !lSelArq .AND. SelDirGrv(cArqAtu)

					lSelArq	:= .T.

				EndIf

				aAdd(aConteudo,{'|'+Alltrim((cAliaQry)->D1_DOC)+'|'+Alltrim((cAliaQry)->D1_FORNECE)+Alltrim((cAliaQry)->D1_LOJA)+'|'+;
					Substring((cAliaQry)->D1_ITEM,2,3)+'|'+Alltrim((cAliaQry)->D1_COD)+'|'+;
					Alltrim(Transform((cAliaQry)->ICSTUNIT,GetSx3Cache("D1_BRICMS","X3_PICTURE")))+'|'+;
					Alltrim(Transform((cAliaQry)->ICUNIT,GetSx3Cache("D1_BASEICM","X3_PICTURE")))+'|'+;
					Alltrim(Transform((cAliaQry)->D1_ALIQSOL,GetSx3Cache("D1_ALIQSOL","X3_PICTURE")))+'|'+;
					Alltrim(Transform((cAliaQry)->D1_PICM,GetSx3Cache("D1_PICM","X3_PICTURE")))+'|'})

				cAnoMes	:= '|'+Substring((cAliaQry)->D1_DTDIGIT,1,4)+'|'+Substring((cAliaQry)->D1_DTDIGIT,5,2)+'|'

				//Acumula os códigos de produtos
				if len(aProdNfs[1])== 0 .OR. Ascan(aProdNfs[1],{|x| x == (cAliaQry)->D1_COD }) == 0

					aAdd(aProdNfs[1],+(cAliaQry)->D1_COD)
					aAdd(aProdNfs[2],{'|'+(cAliaQry)->D1_COD+cAnoMes})

				EndIf

				//Acumula os codigos dos fornecedores
				if len(aFornec[1])== 0 .OR. Ascan(aFornec[1],{|x| x == (cAliaQry)->D1_FORNECE+(cAliaQry)->D1_LOJA }) == 0

					aAdd(aFornec[1],(cAliaQry)->D1_FORNECE+(cAliaQry)->D1_LOJA)
					aAdd(aFornec[2],{'|'+(cAliaQry)->D1_FORNECE+(cAliaQry)->D1_LOJA+'|'+(cAliaQry)->TPFORNEC+cAnoMes})

				EndIf

				(cAliaQry)->(dbSkip())
				MV_PAR04	:= 3//para compatibilidade da outra função
				//gravar um a um para
				FWMsgRun(,{||  DescReg(aConteudo,len(aConteudo),.F.) },'Aguarde....' ,'Gravando linhas no arquivo de Base de Cálculo(NFs).')
				aConteudo	:= {}
				nTtLinh		:= nTtLinh + 1

			Else

				if cForAux	<> (cAliaQry)->D1_FORNECE+(cAliaQry)->D1_LOJA

					cForAux	:= (cAliaQry)->D1_FORNECE+(cAliaQry)->D1_LOJA
					Aviso("Atenção", "O Fornecedor+Loja "+cForAux+" não possui um tipo informado em seu cadastro. Nota Fiscal não será considerada.")

				EndIf

				(cAliaQry)->(dbSkip())

			EndIf

		EndDo

		if nTtLinh > 0

			MV_PAR04	:= 3//para compatibilidade da outra função

			if lSelArq

				FWMsgRun(,{||  DescReg({},0,.T.) },'Aguarde....' ,'Gravando linhas no arquivo de Base de Cálculo(NFs).')

			EndIF

			cInfOutr	+= 'Total de Linhas:'+StrZero(nTtLinh,20)+CRLF

		Else

			cInfOutr	:= 'Não existem dados a serem gerados para o arquivo.'
			Aviso("Dados não se aplicam", cInfOutr, {'OK'},3)

		EndIf

	EndIf

	//	EndIf

	//Monta TXT relacionado aos produtos
	if len(aLayPrd) > 0 .AND. len(aProdNfs[2]) > 0

		cArqAtu		:= 	"VPRODUTO_"+cParNm+".TXT"
		cInfOutr	+= cArqAtu+CRLF

		if SelDirGrv(cArqAtu)

			MV_PAR04	:= 3//para compatibilidade da outra função
			FWMsgRun(,{||  DescReg(aProdNfs[2],len(aProdNfs[2]),.T.) },'Aguarde....' ,'Gravando linhas no arquivo de produto.')
			cInfOutr	+= 'Total de Linhas:'+StrZero(len(aProdNfs[2]),20)+CRLF

		EndIf

	EndIf

	//Monta TXT relacionado aos Fornecedores
	if len(aLayFor) > 0 .AND. len(aFornec[2]) > 0

		cArqAtu	:= 	"VFORNECEDOR_"+cParNm+".TXT"
		cInfOutr	+= cArqAtu+CRLF

		if SelDirGrv(cArqAtu)

			MV_PAR04	:= 3//para compatibilidade da outra função
			FWMsgRun(,{||  DescReg(aFornec[2],len(aFornec[2]),.T.) },'Aguarde....' ,'Gravando linhas no arquivo de fornecedor.')
			cInfOutr	+= 'Total de Linhas:'+StrZero(len(aFornec[2]),20)+CRLF

		EndIf

	EndIf

	//Atualiza com as informaçoes de finalização
	AtuLog1(4,aRetPara,cInfOutr)

	(cAliaQry)->(dbCloseArea())

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} DHME00A5
(long_description)
@type function
@author Cris
@since 24/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*///---------------------------------------------------------------------------------------------------------------------------
User Function DHME00A5()

	Local	aLayout		:= {}
	Local 	aPergs		:= {}
	Local dDtDgIni		:= lastday((lastday(MsDate(),1))-1,1)
	Local dDtDgFim		:= Lastday(dDtDgIni,2)
	Local cLayoutE		:= '003'
	Local cFilPara		:= cFilAnt
	Local aRetPara		:= {}
	Private cAliaQry	:= ''

	U_RFATA99()

	aAdd( aPergs ,{1,"Data da Digitação de",dDtDgIni,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Data da Digitação até",dDtDgFim,"",'NAOVAZIO()',,'.T.',50,.F.})
	aAdd( aPergs ,{1,"Filial:",cFilPara,"@!",'NAOVAZIO()','SM0','.T.',TamSX3('D1_FILIAL')[1],.F.})
	aAdd( aPergs ,{1,"Layout",cLayoutE,"",'NAOVAZIO()','Z00','.F.',50,.F.})

	If ParamBox(aPergs ,"Filtros",aRetPara)

		cAliaQry	:= GetNextAlias()

		//Efetua a manutenção na tabela de Log
		AtuLog(3,cLayoutE)

		//Seleciona os registros associados ao periodo informado e os tipos de movimentaçoes informadas
		FWMsgRun(,{||  SelNFSai(aRetPara) },'Aguarde....' ,'Selecionando registros.')

		if !(cAliaQry)->(Eof())

			//Carrega o layout
			FWMsgRun(,{||  aLayout	:= Layout(aLayout,'E',aRetPara[4])},'Aguarde....' ,'Carregando as configurações do código do layout:'+aRetPara[4])


			//Caso exista o layout ativo
			if len(aLayout) > 0 .AND. len(aLayout[1]) > 0

				cArqAtu	:= 	"NOTASAI_"+Dtos(dDatabase)+'_'+StrTran(Alltrim(Time()),":", "_")+".TXT"

				//Exige informar o diretório de gravação do arquivo, será chamado antes de montar os dados
				//para que em cada nota fiscal sejam gravados seu registros pensando em um arquivo de alto volume
				if SelDirGrv(cArqAtu)

					//Monta o arquivo conforme layout x dados selecionados
					FWMsgRun(,{||  MntAqNFs(aLayout,aRetPara) },'Aguarde....' ,'Aplicando as regras de configurações nos dados selecionados.')

				EndIf

			Else

				HELP("HELP",, 'Não Ativo - Layout',, "O codigo do Layout  "+aRetPara[4]+" não esta ativo ou não existe. Operação cancelada.", 1, 0)

			EndIf

		Else

			HELP("HELP",, 'Não existem Dados',, "Para o período informado não existem dados.", 1, 0)

		EndIf

		(cAliaQry)->(dbCloseArea())

		//Efetua a manutenção na tabela de Log
		AtuLog(4)

	Else

		HELP("HELP",, 'Exportação',, "Operação cancelada pelo colaborador.", 1, 0)

	EndIf

	nItTpReg	:= 0
	nHdlArq		:= 0
	nTtLinh		:= 0
	cArqAtu		:= ''
	cDirArq		:= ''
	cSeqZ03		:= ''
	aTabRec		:= {}
	aCFOsNF		:= {}

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} SelNFSai
(long_description)
@type function
@author Cris
@since 24/02/2017
@version 1.0
@param aRetPara, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function SelNFSai(aRetPara)

	Local cQNfs		:= ''
	Local cTabASF2	:= ''
	Local cTabASD2	:= ''
	Local cTabASA4	:= RetSqlName("SA4")
	Local cTabASB1	:= RetSqlName("SB1")
	Local cTabASF4	:= RetSqlName("SF4")
	Local cTabASA2	:= RetSqlName("SA2")
	Local cTabASA1	:= RetSqlName("SA1")
	Local cFlNFAtu	:= aRetPara[3]
	Local cFlCTES	:= Iif(!Empty(Alltrim(xFilial("SF4"))),cFlNFAtu,xFilial("SF4"))
	Local cFlProd	:= Iif(!Empty(Alltrim(xFilial("SB1"))),cFlNFAtu,xFilial("SB1"))
	Local cFlForne	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local cFlClien	:= Iif(!Empty(Alltrim(xFilial("SA2"))),cFlNFAtu,xFilial("SA2"))
	Local cFlTrans	:= Iif(!Empty(Alltrim(xFilial("SA4"))),cFlNFAtu,xFilial("SA4"))

	cTabASF2	:=	RetSqlName("SF2")
	cTabASD2	:= 	RetSqlName("SD2")

	cQNfs	:= SlCpoSF2(cQNfs)
	cQNfs	:= SlCpoSD2(cQNfs)
	cQNfs	+= "			B1_ORIGEM,F4_CTIPI,F4_LFICM,F4_CREDICM, F4_LFIPI, F4_CSTPIS, F4_CSTCOF, F4_TPREG, F4_PISCRED,F4_CSOSN,  "+CRLF
	cQNfs	+= "			(CASE    "+CRLF
	cQNfs	+= "								  WHEN F2_TRANSP = '' THEN ''    "+CRLF
	cQNfs	+= "								  ELSE ISNULL((SELECT A4_CGC    "+CRLF
	cQNfs	+= "								 					FROM  "+cTabASA4+" "+cTabASA4+" (NOLOCK)   "+CRLF
	cQNfs	+= "													WHERE A4_FILIAL = '"+cFlTrans+"'   "+CRLF
	cQNfs	+= "								       				  AND A4_COD = F2_TRANSP    "+CRLF
	cQNfs	+= "								       				  AND "+cTabASA4+".D_E_L_E_T_ = ''    "+CRLF
	cQNfs	+= "									 		),'')	   "+CRLF
	cQNfs	+= "			 END   "+CRLF
	cQNfs	+= "			 )AS CGCTRANSP,   "+CRLF
	cQNfs	+= "		 "+cTabASF2+".R_E_C_N_O_ NFRECNO   "+CRLF
	cQNfs	+= "	FROM "+cTabASD2+" "+cTabASD2+" (NOLOCK) "+CRLF
	cQNfs	+= "	INNER JOIN  "+cTabASF2+" "+cTabASF2+" (NOLOCK) "+CRLF
	cQNfs	+= "			ON F2_FILIAL = '"+cFlNFAtu+"' "+CRLF
	cQNfs	+= "           AND F2_FILIAL = D2_FILIAL "+CRLF
	cQNfs	+= "           AND F2_DOC = D2_DOC "+CRLF
	cQNfs	+= "		   AND F2_SERIE = D2_SERIE "+CRLF
	cQNfs	+= "		   AND F2_CLIENTE = D2_CLIENTE "+CRLF
	cQNfs	+= "		   AND F2_LOJA = D2_LOJA "+CRLF
	cQNfs	+= "		   AND F2_SERIE = D2_SERIE "+CRLF
	cQNfs	+= "		   AND F2_DAUTNFE BETWEEN  '"+Dtos(aRetPara[1])+"' AND '"+Dtos(aRetPara[2])+"' "+CRLF
	cQNfs	+= "		   AND "+cTabASF2+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= "		   AND "+cTabASD2+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= "   INNER JOIN  "+cTabASB1+" "+cTabASB1+" (NOLOCK)  "+CRLF
	cQNfs	+= "           ON B1_FILIAL = '"+cFlProd+"'  "+CRLF
	cQNfs	+= "          AND B1_COD = D2_COD  "+CRLF
	cQNfs	+= "          AND "+cTabASB1+".D_E_L_E_T_ = ''  "+CRLF
	cQNfs	+= "   INNER JOIN  "+cTabASF4+" "+cTabASF4+" (NOLOCK)  "+CRLF
	cQNfs	+= "           ON F4_FILIAL = '"+cFlCTES+"'  "+CRLF
	cQNfs	+= "          AND F4_CODIGO = D2_TES  "+CRLF
	cQNfs	+= "          AND "+cTabASF4+".D_E_L_E_T_ = '' "+CRLF
	cQNfs	+= " ORDER BY DTDIGIT,NOTAFISCAL,SERIE,ITEM "+CRLF

	cQNfs := ChangeQuery(cQNfs)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQNfs),cAliaQry,.T.,.T.)

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MntAqNFs
(long_description)
@type function
@author Cris
@since 24/02/2017
@version 1.0
@param aLayout, array, (Descrição do parâmetro)
@param aRetPara, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function MntAqNFs(aConfLay,aRetPara)
	Local aConteudo		:= {}
	Local aLayout		:= aConfLay[1]
	Local aOrdExec		:= aConfLay[2]
	Local aCpoXFunc		:= aConfLay[3]
	Local aTpReg0		:= {} //Registro Header de Arquivo (obrigatório)
	Local aTpReg4		:= {} //Registro de Emitente/Destinário (condicional)
	Local aTpReg1		:= {} //Registro de Notas Fiscal (obrigatório)
	Local aTpReg2		:= {} //Registro de Itens da Nota (obrigatório)
	Local aItens		:= {} //Acumula os itens aTpReg2
	Local aTpReg5		:= {} //Dados Complementares (obrigatório)
	Local aTpReg6		:= {} //CTR (obrigatório somente quando a especie for CTR, senão enviar zerado).
	Local aTpReg9		:= {} //Parcelas na Nota Fiscal	(condicional)
	Local aTpReg3		:= {} //Registro Trailler (obrigatório)
	Local cEspServ		:= SuperGetMv('ES_ESPSERV',,'NFSE|CTR|CTE')
	Local nLayout		:= 0
	Local cChvNFe		:= ''
	Local nPosTpR0		:= ascan(aLayout,{|x| x[1][1] == '0'})
	Local nPosTpR1		:= ascan(aLayout,{|x| x[1][1] == '1'})
	Local nPosTpR2		:= ascan(aLayout,{|x| x[1][1] == '2'})
	Local nPosTpR3		:= ascan(aLayout,{|x| x[1][1] == '3'})
	Local nPosTpR4		:= ascan(aLayout,{|x| x[1][1] == '4'})
	Local nPosTpR5		:= ascan(aLayout,{|x| x[1][1] == '5'})
	Local nPosTpR6		:= ascan(aLayout,{|x| x[1][1] == '6'})
	Local nPosTpR9		:= ascan(aLayout,{|x| x[1][1] == '9'})
	Local nPosCab		:= 0
	Local iTens			:= 0
	Local nPosCFOP		:= 0

	//1.Registro Header do Arquivo - sempre existirá único registro: Tipo Registro 0
	aAdd(aTpReg0,array(len(aLayout[nPosTpR0])))
	aTpReg0	:= Preench1(aTpReg0,aRetPara[3])
	FWMsgRun(,{|| aTpReg0	:= AjustReg(aTpReg0,aLayout[nPosTpR0]) },'Aguarde....' ,'Ajustando tipo de registro 0.')
	aAdd(aConteudo,aTpReg0)

	//Registro Trailler- sempre existirá único registro: Tipo de Registro 3
	aAdd(aTpReg3,{'',0,0,0,0 ,0,0,0,0,0 ,0,0,0,0,0  ,0,0,0,0,0 ,0,0,0,0,0  ,0,0,0,0,0 ,0,0,'',''})
	//  1 2 3 4 5  1 2 3 4 5   1 2 3 4 5  1 2 3 4 5  1 2 3 4 5   1 2 3 4 5  1 2 3 4

	DescReg(aConteudo,1,.F.)
	aConteudo	:= {}

	(cAliaQry)->(dbGotop())

	cChvNFe	:= (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

	While !(cAliaQry)->(Eof())

		if cChvNFe <> (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

			//Se existir cliente
			if len(aTpReg4) > 0

				FWMsgRun(,{|| aTpReg4	:= AjustReg(aTpReg4,aLayout[nPosTpR4]) },'Aguarde....' ,'Ajustando tipo de registro 4.')
				aAdd(aConteudo,aTpReg4)

			EndIf

			//Sempre existirá este registro de nota fiscal,seja de serviço ou produto
			//Trailler: ultima linha - Acumuladora de valores->acumulo antes de tornar a linha tipo 1 em um vetor
			FWMsgRun(,{|| aTpReg3	:= Trailler(aTpReg3,aTpReg1,'S')},'Aguarde....' ,'Acumulando no Trailler, registro tipo 3.')
			FWMsgRun(,{|| aTpReg1	:= AjustReg(aTpReg1,aLayout[nPosTpR1]) },'Aguarde....' ,'Ajustando tipo de registro 1.')
			aAdd(aConteudo,aTpReg1)

			//Poderá existir este registro se a nota fiscal for referente a produto e não serviço
			if len(aItens) > 0

				aAdd(aConteudo,AjustReg(aItens,aLayout[nPosTpR2]))

			EndIf

			//Sempre existirá os Dados Complementares, existindo ou não devido a Chave NF
			aTpReg5	:= AjustReg(aTpReg5,aLayout[nPosTpR5])
			aAdd(aConteudo,aTpReg5)

			//Se existir  pagamento/recebimento
			if len(aTpReg9) > 0

				FWMsgRun(,{|| aAdd(aConteudo,AjustReg(aTpReg9,aLayout[nPosTpR9]))},'Aguarde....' ,'Ajustando tipo de registro 9.')

			EndIf

			DescReg(aConteudo,len(aConteudo),.F.)

			aTpReg4		:= {}
			aTpReg1		:= {}
			aTpReg2		:= {}
			aItens		:= {}
			aTpReg5		:= {}
			aTpReg9		:= {}
			aCFOsNF		:= {}
			aConteudo	:= {}
			cRemeten	:= ''
			cAvista		:= ''
			cChvNFe	:= (cAliaQry)->MVTO+(cAliaQry)->FILIAL+(cAliaQry)->NOTAFISCAL+(cAliaQry)->SERIE

		EndIf

		//Se o cliente/fornecedor ainda não foi exportado monta arquivo do cliente/fornecedor
		If Len(aTpReg4) == 0

			aAdd(aTpReg4,array(len(aLayout[nPosTpR4])))
			aTpReg4	:= ClieFor(aTpReg4/*,aRetPara*/)

		EndIf

		//Adiciona os Dados Complementares
		if  Len(aTpReg5) == 0

			aAdd(aTpReg5,array(len(aLayout[nPosTpR5])))
			aTpReg5	:= DdComplS(aTpReg5)

		EndIf

		//Se a condição de pagamento estiver informada preencho o tipo de registro 9
		If (cAliaQry)->CONDPGTO	<> '' .AND. Len(aTpReg9) == 0

			aTpReg9	:= TitAtu(aTpReg9,aLayout[nPosTpR9])
		Elseif (cAliaQry)->CONDPGTO	== ''

			cAVista	:= 'X' //sem pagamento
		EndIf

		//Monta cabeçalho  da NF:  Registro Tipo 1
		if (nPosCFOP	:= Ascan(aCFOsNF,{|x| x[1] == (cAliaQry)->CFOP})) == 0

			//Aplico a  quebra do registro tipo 1 Cabeçalho de Notas Fiscais somente para notas fiscais de Entrada
			if (cAliaQry)->MVTO == 'E'

				//Monto o array do tipo de registro 1 Nota Fiscal
				aAdd(aTpReg1,array(len(aLayout[nPosTpR1])))

			Elseif len(aTpReg1) == 0

				//Monto o array do tipo de registro 1 Nota Fiscal
				aAdd(aTpReg1,array(len(aLayout[nPosTpR1])))

			EndIf

			aAdd(aCFOsNF, {(cAliaQry)->CFOP})

			nPosCab	:= len(aTpReg1)

		Else

			//Aplico a  quebra do registro tipo 1 Cabeçalho de Notas Fiscais somente para notas fiscais de Entrada
			if (cAliaQry)->MVTO == 'E'

				nPosCab	:= 	nPosCFOP

			Else

				nPosCab	:= 1

			EndIF

		EndIf

		aTpReg1	:= MtCabNFS(nPosCab,aTpReg1)

		if (len(aTabRec) > 0 .AND. (Ascan(aTabRec,{|x| x[2] == (cAliaQry)->NFRECNO})) == 0) .OR. len(aTabRec) == 0

			if (cAliaQry)->MVTO == 'E'

				aAdd(aTabRec,{'SF1',(cAliaQry)->NFRECNO})

			Else

				aAdd(aTabRec,{'SF2',(cAliaQry)->NFRECNO})

			EndIf

		EndIf

		//Monto os itens caso a  nota fiscal exija: registro  tipo 2
		//Lembrar que notas fiscais de serviço para outros sistemas podem não necessitar da criação de um produto
		If !(cAliaQry)->ESPECIE $ cEspServ

			aAdd(aItens,MtNfPrdS(aLayout[nPosTpR2],aTpReg2))

		EndIf

		(cAliaQry)->(dbSkip())

	EndDo

	//Se existir cliente/fornecedor a ser enviado
	if len(aTpReg4) > 0

		aTpReg4	:= AjustReg(aTpReg4,aLayout[nPosTpR4])
		aAdd(aConteudo,aTpReg4)

	EndIf

	//Sempre existirá este registro de nota fiscal,seja de serviço ou produto
	//Trailler: ultima linha - Acumuladora de valores->acumulo antes de tornar a linha tipo 1 em um vetor
	aTpReg3	:= Trailler(aTpReg3,aTpReg1,'S')
	aTpReg1	:= AjustReg(aTpReg1,aLayout[nPosTpR1])
	aAdd(aConteudo,aTpReg1)

	//Poderá existir este registro se a nota fiscal for referente a produto e não serviço
	if len(aItens) > 0

		//For iTens	:= 1 to len(aItens)

		//aAdd(aConteudo,AjustReg(aItens[iTens],aLayout[nPosTpR2]))
		aAdd(aConteudo,AjustReg(aItens,aLayout[nPosTpR2]))
		//Next iTens

	EndIf

	//Sempre existirá os Dados Complementares, existindo ou não devido a Chave NF
	aTpReg5	:= AjustReg(aTpReg5,aLayout[nPosTpR5])
	aAdd(aConteudo,aTpReg5)

	//Se existir  pagamento/recebimento
	if len(aTpReg9) > 0

		aAdd(aConteudo,AjustReg(aTpReg9,aLayout[nPosTpR9]))

	EndIf

	//7.Registro Trailler- sempre existirá: Tipo de Registro 3
	aTpReg3	:= AjustReg(aTpReg3,aLayout[nPosTpR3])
	aAdd(aConteudo,aTpReg3)

	nTtLinh		:= IIf(ValType(nItTpReg)<>'N',0,nItTpReg)

	FWMsgRun(,{||  DescReg(aConteudo,len(aConteudo),.T.) },'Aguarde....' ,'Gravando linhas no arquivo')

	aTpReg4		:= {}
	aTpReg1		:= {}
	aTpReg2		:= {}
	aItens		:= {}
	aTpReg5		:= {}
	aTpReg9		:= {}
	aCFOsNF		:= {}
	aConteudo	:= {}
	cRemeten	:= ''
	cAvista		:= ''

Return
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MtCabNFS
(long_description)
@type function
@author Cris
@since 24/02/2017
@version 1.0
@param nPosCab, numérico, (Descrição do parâmetro)
@param aTpReg1, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function MtCabNFS(nPosCab,aTpReg1)

	Local nPosAliq	:= 0
	Local aSerieSb	:= {'',''}

	if Valtype(aTpReg1[nPosCab][01]) == 'U'

		aTpReg1[nPosCab][01]	:= '1'

		if !Empty((cAliaQry)->DTDIGIT)

			aTpReg1[nPosCab][02]	:=	(cAliaQry)->DTDIGIT//Data Lançamento: inclusão/transmissão

		Else

			aTpReg1[nPosCab][02]	:=	(cAliaQry)->EMISSAO//Data da Emissão da NF

		EndIf

		if (nTamNF := len(Alltrim((cAliaQry)->NOTAFISCAL))) > 6

			aTpReg1[nPosCab][66]	:= (cAliaQry)->NOTAFISCAL
			aTpReg1[nPosCab][67]	:= (cAliaQry)->NOTAFISCAL

		Else

			aTpReg1[nPosCab][03]	:= (cAliaQry)->NOTAFISCAL//	Número Nota inicial
			aTpReg1[nPosCab][04]	:= (cAliaQry)->NOTAFISCAL//	Número Nota	fim

		EndIf

		aTpReg1[nPosCab][05]	:= (cAliaQry)->EMISSAO//	Data Documento
		aTpReg1[nPosCab][07]	:= (cAliaQry)->MODELONF

		if Empty(aTpReg1[nPosCab][05])

			MsgAlert('Aqui')

		EndIf

		//Fazer tratamento para separar o numerico do caracter
		if !Empty((cAliaQry)->SERIE)

			aSerieSb	:= TratSerie(aSerieSb)

			aTpReg1[nPosCab][08]	:= aSerieSb[1] //Série
			aTpReg1[nPosCab][09]	:= aSerieSb[2]//SubSérie

		EndIf

		aTpReg1[nPosCab][10]	:= (cAliaQry)->CFOP
		aTpReg1[nPosCab][14]	:= cRemeten //a variável é utilizada  na entrada, aqui seu conteúdo é sobre oDestinatário
		aTpReg1[nPosCab][15]	:= (cAliaQry)->TVL_BRUTO//Valor contábil

		aTpReg1[nPosCab][16]	:= 0
		aTpReg1[nPosCab][17]	:= 0

		if (cAliaQry)->F4_PISCRED == '1'

			aTpReg1[nPosCab][16]	:= (cAliaQry)->TBS_PIS_A//Base Pis
			aTpReg1[nPosCab][17]	:= (cAliaQry)->TBS_COF_A//Base Cofins

		EndIF

		aTpReg1[nPosCab][18]	:= (cAliaQry)->TBS_CSLL//Base CSLL
		aTpReg1[nPosCab][19]	:= (cAliaQry)->TBS_IRRF//Base  IRPJ

		//ICMS
		//Se a Dayjome possui crédito deste imposto
		if (cAliaQry)->F4_CREDICM	== 'S'

			aTpReg1[nPosCab][21]	:= (cAliaQry)->TBS_ICMS//BASE DE ICMS A SE CREDITAR
			aTpReg1[nPosCab][22]	:= (cAliaQry)->ALQ_ICMS//ALIQUOTA DE ICMS A SE CREDITAR
			aTpReg1[nPosCab][23]	:= (cAliaQry)->TVL_ICMS//VALOR DO ICMS A SE CREDITAR

		Else

			aTpReg1[nPosCab][21]	:= 0
			aTpReg1[nPosCab][22]	:= 0
			aTpReg1[nPosCab][23]	:= 0

		EndIf

		aTpReg1[nPosCab][57]	:= ''//Data do Recebimento
		//Campos acumuladores
		aTpReg1[nPosCab][33]	:= 0
		aTpReg1[nPosCab][34]	:= 0
		aTpReg1[nPosCab][35]	:= 0
		aTpReg1[nPosCab][36]	:= 0
		aTpReg1[nPosCab][37]	:= 0
		aTpReg1[nPosCab][38]	:= 0
		aTpReg1[nPosCab][39]	:= 0
		aTpReg1[nPosCab][74]	:= 0
		aTpReg1[nPosCab][75]	:= 0
		aTpReg1[nPosCab][76]	:= 0

		//ICMS ST
		aTpReg1[nPosCab][40]	:=  (cAliaQry)->TBS_ICMS_SOL//BASE ST
		aTpReg1[nPosCab][41]	:=  (cAliaQry)->TICMS_RET//VALOR ICMST ST
		aTpReg1[nPosCab][41]	:=  (cAliaQry)->TICMS_DEFERIDO

		aTpReg1[nPosCab][49]	:= (cAliaQry)->ESPECIE

		aTpReg1[nPosCab][50]	:= cAvista

		if (cAliaQry)->UF == 'EX'

			aTpReg1[nPosCab][63]	:= (cAliaQry)->CLIEFOR //	Identificação Exterior

		EndIf

		aTpReg1[nPosCab][53]	:= (cAliaQry)->TIPO_FRETE //Modalidade do Frete
		aTpReg1[nPosCab][52]	:= (cAliaQry)->TBS_COF_ST//Base PIS COFINS ST
		aTpReg1[nPosCab][54]	:= (cAliaQry)->TBS_PIS_R//PIS REtido
		aTpReg1[nPosCab][55]	:= (cAliaQry)->TBS_COF_R//COFINS Retido

		if aTpReg1[nPosCab][39] == Nil

		EndIf

	EndIf


	if (cAliaQry)->F4_LFICM == 'I'

		aTpReg1[nPosCab][33]	:= aTpReg1[nPosCab][33]+(cAliaQry)->TOTAL_ITEM//	Isentas ICMS

	Elseif (cAliaQry)->F4_LFICM == 'O'

		aTpReg1[nPosCab][34]	:= aTpReg1[nPosCab][34]+ (cAliaQry)->TOTAL_ITEM//	Outros ICMS

	EndIf

	//IPI
	if (cAliaQry)->F4_LFIPI == 'T'

		aTpReg1[nPosCab][35]	:= aTpReg1[nPosCab][35]+ (cAliaQry)->BS_IPI//	Base IPI
		aTpReg1[nPosCab][36]	:= aTpReg1[nPosCab][36]+ (cAliaQry)->VL_IPI//Valor IPI

	Elseif (cAliaQry)->F4_LFIPI == 'I'

		aTpReg1[nPosCab][37]	:=  aTpReg1[nPosCab][37]+(cAliaQry)->TOTAL_ITEM//	Isentas IPI

	Elseif (cAliaQry)->F4_LFIPI == 'O'

		aTpReg1[nPosCab][38]	:= aTpReg1[nPosCab][38]+ (cAliaQry)->TOTAL_ITEM//	Outras IPI

	EndIf

	//BASE ICMS ST
	if (cAliaQry)->BS_ICMS_ST <> 0

		aTpReg1[nPosCab][39]	:=  aTpReg1[nPosCab][39]+(cAliaQry)->VL_BRUTO//MERCADORIA ST
		aTpReg1[nPosCab][51]	:= (cAliaQry)->CFOP

	EndIf

	aTpReg1[nPosCab][74]	:= aTpReg1[nPosCab][74]+(cAliaQry)->VL_DIFAL_FCP	//ICMS Relativo ao FCP
	aTpReg1[nPosCab][75]	:= aTpReg1[nPosCab][75]+(cAliaQry)->VL_DIFAL //	ICMS UF de Destino
	aTpReg1[nPosCab][76]	:= aTpReg1[nPosCab][76]+((cAliaQry)->VL_ICMS*(cAliaQry)->P_DIFAL_ORIG)/100//	ICMS UF de Origem

Return aTpReg1
//---------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MtNfPrdS
(long_description)
@type function
@author Cris
@since 24/02/2017
@version 1.0
@param ${param}, ${param_type}, ${param_descr}
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*///---------------------------------------------------------------------------------------------------------------------------
Static Function MtNfPrdS(aLayPrd,aTpReg2)

	Local nBsPIS	:= 0
	Local nAlqPIS	:= 0
	Local nVlPIS	:= 0
	Local nBsCOF	:= 0
	Local nAlqCOF	:= 0
	Local nVlCOF	:= 0
	Local nPosPrd	:= 0

	aAdd(aTpReg2,array(len(aLayPrd)))
	nPosPrd	:= len(aTpReg2)

	//PIS NA APURACAO
	if (cAliaQry)->BS_PIS_A <> 0.00

		nBsPIS	:= (cAliaQry)->BS_PIS_A
		nAlqPIS	:= (cAliaQry)->ALQ_PIS_A
		nVlPIS	:= (cAliaQry)->VL_PIS_A

	EndIf

	//PIS NA RETENCAO
	If (cAliaQry)->BS_PIS_R <> 0.00

		nBsPIS	:= (cAliaQry)->BS_PIS_R
		nAlqPIS	:= (cAliaQry)->ALQ_PIS_R
		nVlPIS	:= (cAliaQry)->VL_PIS_R

	EndIf

	//COFINS NA APURACAO
	if (cAliaQry)->BS_COF_A <> 0.00

		nBsCOF	:= (cAliaQry)->BS_COF_A
		nAlqCOF	:= (cAliaQry)->ALQ_COF_A
		nVlCOF	:= (cAliaQry)->VL_COF_A

	EndIf

	//COFINS NA RETENCAO
	If (cAliaQry)->BS_COF_R <> 0.00

		nBsCOF	:= (cAliaQry)->BS_COF_R
		nAlqCOF	:= (cAliaQry)->ALQ_COF_R
		nVlCOF	:= (cAliaQry)->VL_COF_R

	EndIf

	//aTpReg2[nPosPrd][2]	:= (cAliaQry)->B1_CORD
	aTpReg2[nPosPrd][3]		:= (cAliaQry)->QUANTIDADE
	aTpReg2[nPosPrd][4]		:= (cAliaQry)->VL_BRUTO
	aTpReg2[nPosPrd][6]		:= (cAliaQry)->VL_DESCONTO
	aTpReg2[nPosPrd][07]	:= (cAliaQry)->BS_ICMS
	aTpReg2[nPosPrd][08]	:= (cAliaQry)->ALQ_ICMS
	aTpReg2[nPosPrd][09]	:= (cAliaQry)->VL_IPI
	aTpReg2[nPosPrd][10]	:= (cAliaQry)->BS_ICMS_ST
	aTpReg2[nPosPrd][11]	:= (cAliaQry)->ALQ_IPI
	aTpReg2[nPosPrd][13]	:= (cAliaQry)->ORIGEM_CST
	aTpReg2[nPosPrd][14]	:= (cAliaQry)->PRODUTO
	aTpReg2[nPosPrd][15]	:= (cAliaQry)->F4_CTIPI
	aTpReg2[nPosPrd][16]	:= (cAliaQry)->BS_IPI
	aTpReg2[nPosPrd][32]	:= (cAliaQry)->CFOP
	aTpReg2[nPosPrd][33]	:= (cAliaQry)->UNIDADE

	if !Empty((cAliaQry)->F4_CSOSN)

		aTpReg2[nPosPrd][36]	:= 'S'

	Else

		aTpReg2[nPosPrd][36]	:= 'N'

	EndIf

	aTpReg2[nPosPrd][41]	:= (cAliaQry)->VL_FRETE
	aTpReg2[nPosPrd][42]	:= (cAliaQry)->VL_SEGURO
	aTpReg2[nPosPrd][43]	:= (cAliaQry)->VL_DESPESA

Return aTpReg2[nPosPrd]
