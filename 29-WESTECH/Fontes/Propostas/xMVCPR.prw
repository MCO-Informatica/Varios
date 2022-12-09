//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"

//Variáveis Estáticas
Static cTitulo := "Gestao de Propostas"

User Function xMVCPR()
    Local aArea   := GetArea()
    Local oBrowse

    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()

    //Setando a descrição da rotina
    oBrowse:SetAlias("SZ9")
    //oBrowse:SetFilterDefault( "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. CTD_DTEXSF = '' .OR. CTD_DTEXSF >= dDatabase "  )

    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)

    //Legendas
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '1'", "BR_VERDE", "Ativa" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '2'", "BR_CINZA", "Cancelada" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '3'", "BR_LARANJA", "Declinada" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '4'", "BR_AMARELO", "Nao Enviada" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '5'", "BR_BRANCO", "Perdida" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '6'", "BR_MARROM", "SLC" )
    oBrowse:AddLegend( "SZ9->Z9_STATUS = '7'", "BR_AZUL", "Vendida" )

    //Ativa a Browse
    oBrowse:Activate()

    RestArea(aArea)
Return Nil

/////////////////////////////////////////////////////////////////////////////

Static Function MenuDef()
    Local aRot := {}

    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.xMVCPR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC10Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.xMVCPR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.xMVCPR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.xMVCPR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

//////////////////////////////////////////////////////////////////////////////

Static Function ModelDef()

    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'SZ9')
    Local oStFilho6 	:= FWFormStruct(1, 'SZF')
    Local oStFilho30 	:= FWFormStruct(1, 'ZZM')
    Local oStNeto2   	:= FWFormStruct(1, 'SZG')
    Local oStNeto4   	:= FWFormStruct(1, 'SZP')
    Local oStNeto5   	:= FWFormStruct(1, 'SZT')
    Local aSZFRel       := {}
    Local aSZGRel       := {}
    Local aSZPRel       := {}
    Local aSZTRel       := {}
    Local aZZMRel       := {}

    //Criando o modelo e os relacionamentos
    //oModel := MPFormModel():New("xMVCPRM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)
    oModel := MPFormModel():New('xMVCPRM',  , { |oMdl| COMP011POS( oMdl ) })

    oModel:AddFields('SZ9MASTER',/*cOwner*/,oStPai)

    oModel:AddGrid('SZFDETAIL','SZ9MASTER',oStFilho6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZFDETAIL', { { 'ZF_NPROP', 'Z9_NPROP' } }, SZF->(IndexKey(1)) )

	oModel:AddGrid('ZZMDETAIL','SZ9MASTER',oStFilho30,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZMDETAIL', { { 'ZZM_NPROP', 'Z9_NPROP' } }, ZZM->(IndexKey(1)) )

	oModel:AddGrid('SZGDETAIL','SZFDETAIL',oStNeto2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZGDETAIL', { { 'ZG_IDVEND', 'ZF_IDVEND' } ,{'ZG_NPROP', 'Z9_NPROP'}  }, SZG->(IndexKey(1)) )
    //oModel:SetRelation('SZGDETAIL', {  }, SZG->(IndexKey(1)) )

    oModel:AddGrid('SZPDETAIL','SZGDETAIL',oStNeto4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZPDETAIL', { { 'ZP_IDVDSUB', 'ZG_IDVDSUB' } ,{'ZP_NPROP', 'Z9_NPROP'}   }, SZP->(IndexKey(1)) )
    //oModel:SetRelation('SZPDETAIL', { {'ZP_NPROP', 'ZG_NPROP'}  }, SZP->(IndexKey(1)) )

    oModel:AddGrid('SZTDETAIL','SZPDETAIL',oStNeto5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZTDETAIL', { { 'ZT_IDVDSB2', 'ZP_IDVDSB2' } , {'ZT_NPROP', 'Z9_NPROP'}  }, SZT->(IndexKey(1)) )
    //oModel:SetRelation('SZTDETAIL', {  {'ZT_NPROP', 'ZP_NPROP'} }, SZT->(IndexKey(1)) )

    //Fazendo o relacionamento entre o Pai e Filho
   //aAdd(aSZFRel, {'ZF_FILIAL', 'Z9_FILIAL'} )
    aAdd(aSZFRel, {'ZF_NPROP',  'Z9_NPROP'})
    //aAdd(aSZJRel, {'ZJ_FILIAL', 'Z9_FILIAL'} )
    aAdd(aZZMRel, {'ZZM_NPROP',  'Z9_NPROP'})
    //aAdd(aSZGRel, {'ZG_FILIAL', 'ZF_FILIAL'} )
    //aAdd(aSZGRel, {'ZG_IDVEND', 'ZF_IDVEND'} )
    aAdd(aSZGRel, {'ZG_NPROP', 'Z9_NPROP'} )
   // aAdd(aSZPRel, {'ZP_FILIAL', 'ZG_FILIAL'} )
    aAdd(aSZPRel, {'ZP_IDVDSUB', 'ZG_IDVDSUB'})
    aAdd(aSZPRel, {'ZP_NPROP', 'Z9_NPROP'})
    //aAdd(aSZTRel, {'ZT_FILIAL', 'ZP_FILIAL'} )
    aAdd(aSZTRel, {'ZT_IDVDSB2', 'ZP_IDVDSB2'})
    aAdd(aSZTRel, {'ZT_NPROP', 'Z9_NPROP'})

    oModel:GetModel('SZFDETAIL'):SetOptional( .T. )
    oModel:GetModel('ZZMDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZGDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZPDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZTDETAIL'):SetOptional( .T. )

oModel:SetRelation('SZFDETAIL', { { 'ZF_NPROP', 'Z9_NPROP' } }, SZF->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZFDETAIL'):SetUniqueLine({"ZF_IDVEND"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

     //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('ZZMDETAIL'):SetUniqueLine({"ZZM_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})

     //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZGDETAIL'):SetUniqueLine({"ZG_IDVDSUB"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

     //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZPDETAIL'):SetUniqueLine({"ZP_IDVDSB2"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZTDETAIL'):SetUniqueLine({"ZT_IDVDSB3"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    //Setando as descrições
    oModel:SetDescription("Propostas")
    oModel:GetModel('SZ9MASTER'):SetDescription('Proposta')
    oModel:GetModel('SZFDETAIL'):SetDescription('Custos - Vendido')
    oModel:GetModel('ZZMDETAIL'):SetDescription('Detalhamento - Custos (Novo)')
    oModel:GetModel('SZGDETAIL'):SetDescription('Destalhes Custos Vendido')
	oModel:GetModel('SZPDETAIL'):SetDescription('Nivel 3 - Detalhes Vendido')
	oModel:GetModel('SZTDETAIL'):SetDescription('Nivel 4 - Detalhes Vendido')

	//oModel:AddCalc( 'calcSZC', 'CTDMASTER', 'SZCDETAIL', 'ZC_TOTAL', 'calcPla', 'SUM', /*bCondition*/, /*bInitValue*/,'Plajejado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTAL', 'calcVD', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTVSI', 'calcVDsi', 'SUM', /*bCondition*/, /*bInitValue*/,'Venda s/ Tributos' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTVCI', 'calcVDci', 'SUM', /*bCondition*/, /*bInitValue*/,'Venda c/ Tributos' /*cTitle*/, /*bFormula*/)

Return oModel

Static Function COMP011POS( oModel )
	//Local nOperation 	:= oModel:GetOperation()
	Local lRet 			:= .T.
	Local oStNeto2   	:= FWFormStruct(1, 'SZG')
	Local oModelSZF   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZF2   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZG   	:= oModel:GetModel( 'SZGDETAIL' )
	Local oModelSZP   	:= oModel:GetModel( 'SZPDETAIL' )
	Local oModelSZ9   	:= oModel:GetModel( 'SZ9MASTER' )
	Local oModelSZT   	:= oModel:GetModel( 'SZTDETAIL' )
	Local cZ9CLASS		:= oModel:GetValue( 'SZ9MASTER', 'Z9_CLASS' )
	Local cZ9MERC		:= oModel:GetValue( 'SZ9MASTER', 'Z9_MERCADO' )
	Local cZ9TIPO		:= oModel:GetValue( 'SZ9MASTER', 'Z9_TIPO' )
	Local cZ9DTREG		:= oModel:GetValue( 'SZ9MASTER', 'Z9_DTREG' )
	Local nNPROPOSTA	:= oModel:GetValue( 'SZ9MASTER', 'Z9_NPROP' )
	Local nPCONT_Z9		:= oModel:GetValue( 'SZ9MASTER', 'Z9_PCONT' )
	Local nCUSFIN_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_CUSFIN' )
	Local nFIANCAS_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_FIANCAS' )
	Local nPROVGAR_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_PROVGAR' )
	Local nPERDIMP_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_PERDIMP' )
	Local nPROYALT_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_PROYALT' )
	Local nPCOMIS_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_PCOMIS' )
	Local nPMKPINI_Z9	:= oModel:GetValue( 'SZ9MASTER', 'Z9_MKPINI' )
	Local cIDVDSUBSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVDSUB' )
	Local cIDVDSUBSZP	:= oModel:GetValue( 'SZPDETAIL', 'ZP_IDVDSUB' )
	Local nTotalZDF 	:= 0
	Local nQuantSZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )
	Local nQuantSZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
	Local nTotalZP		:= oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' )
	Local nTotalZF 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0
	//Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local nI			:= 0
	Local nI1			:= 0
	Local nI2			:= 0
	Local nI3			:= 0
	Local nI4			:= 0
	Local nI5			:= 0
	Local nI6			:= 0
	Local nI7			:= 0
	Local nI8			:= 0
	Local nI9			:= 0
	Local nI10			:= 0
	Local nI11			:= 0
	Local nI12			:= 0
	Local nI13			:= 0
	Local nI14			:= 0
	Local nI15			:= 0
	Local nI16			:= 0
	Local nI17			:= 0
	Local nI18			:= 0
	Local nI19			:= 0
	Local nI20			:= 0
	Local nI21			:= 0
	Local nI22			:= 0
	Local nI23			:= 0
	Local nI24			:= 0
	Local nI25			:= 0
	Local nI26			:= 0
	Local nI27			:= 0
	Local nI99			:= 0
	Local nP01			:= 0
	Local nP02			:= 0
	Local nP03			:= 0
	Local nP04			:= 0  
	Local nI200			:= 0
	Local nI201			:= 0
	Local nI202			:= 0
	Local nI203			:= 0
	Local nICPROP		:= ""
	Local nTotalZOF		:= 0
	Local nTotalZPF		:= 0
	Local nLinha		:= 0
	Local nTotalSZF_RES := 0
	Local nTotalSZF_SZM := 0
	Local nTotalVendido := 0
	Local nMargemBrutaV := 0
	Local nMargemContrV := 0
	Local nVLRCONT		:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCONT' )
	Local nPContig		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCONT' )
	Local nPMKPINI		:= oModel:GetValue( 'SZFDETAIL', 'ZF_MKPINI' )
	Local nVConting 	:= 0
	Local nVCustoCont	:= 0
	Local nPMargemBruta := 0
	Local nPCusFin 		:= 0
	Local nPFiancas		:= 0
	Local nPProvGR		:= 0
	Local nPPerdIMP		:= 0
	Local nPRoyalt		:= 0
	Local nPComis		:= 0
	Local nVComis		:= 0
	Local nPMGBruta		:= 0
	Local nVMargemBruta	:= 0
	Local nVPrecoVendaInicial := 0
	Local nPPIS			:= 0
	Local nPCOF			:= 0
	Local nPICMS		:= 0
	Local nPIPI			:= 0
	Local nPISS			:= 0
	Local nVPIS			:= 0
	Local nVCOF			:= 0
	Local nVICMS		:= 0
	Local nVIPI			:= 0
	Local nVISS			:= 0
	Local nPDESC		:= 0
	Local nVDESC		:= 0
	Local nPrecoVDSITot	:= 0
	Local nPrecoVDSIUni := 0
	Local nVRoyalt		:= 0
	Local nPOCUST		:= 0
	Local nVOCUST		:= 0
	Local nPrecoVDCITot	:= 0
	Local nPrecoVDCIUni := 0
	Local nTotSI		:= 0
	Local nVlrOU		:= 0
	Local nVlrROY		:= 0
	Local nVlrCom		:= 0
	Local nVlrCusCont	:= 0
	Local nVlrMKP		:= 0
	Local nPMKPFIN		:= 0
	Local nTotVCI_SZG	:= 0
	Local nUniVCI_SZG	:= 0
	Local nTotVSI_SZG	:= 0
	Local nUniVSI_SZG	:= 0
	Local nTotSI_SZG	:= 0
	Local nVlrOU_SZG	:= 0
	Local nVlrROY_SZG	:= 0
	Local nVlrCom_SZG	:= 0
	Local nVlrCusCont_SZG := 0
	Local nVlrMKP_SZG	:= 0
	Local nVlrCont_SZG	:= 0
	Local nPrcVDINI		:= 0
	Local nPrcVDINI_SZG := 0
	Local nPrecoVDCIUnit2 := 0
	Local nZG_PVA		:=	"1"
	Local nPUNITSIP		:= 0
	Local nVMargem		:= 0
	Local nTotalZFOCUS	:= 0
	Local nTotalSZFOCUS_RES := 0
	Local nTotalZFCOM	:= 0
	Local nTotalZFROY	:= 0
	Local nTotalSZFCOM_RES := 0
	Local nTotalSZFROY_RES := 0
	Local nTotOCR		:= 0
	Local nTotalSZFMB	:= 0
	Local nTotalSZF_MB  := 0
	Local nTotalSZF_VSI := 0
	Local nTotVSI 		:= 0
	Local nTotVSI_FIN	:= 0
	Local nVlrCusCont2	:= 0
	Local nVlrCusCont2_SZG	:= 0
	Local nVCustoCont1	:= 0
	Local nCusCont2		:= 0
	Local nCusCont2_SZG	:= 0
	Local nTotVSI2 		:= 0
	Local nTotVSI2_FIN	:= 0
	Local nVlrCont2 	:= 0
	Local nVlrCont2_FIN	:= 0
	Local nVlrMKP2		:= 0
	Local nVlrMKP2_FIN	:= 0
	Local nPMKPFIN2		:= 0
	Local nVlrMBRT		:= 0
	Local nVlrMBRT_SZG 	:= 0
	Local nVlrMKPB2		:= 0
	Local nVlrMKPB2_FIN	:= 0
	Local nPMKPBFIN2	:= 0
	Local nTotVCI2 		:= 0
	Local nTotVCI2_FIN	:= 0
	Local nZG_POC		:= "1"
	Local nTotalZFCONT	:= 0
	Local nTotalZT		:= 0
	Local nTotalZTF		:= 0
	Local varQuant   	:= 0
	Local varPeso		:= 0
	Local varUnit 		:= 0
	Local varTotal		:= 0
	Local nTotReg
	Local nSequencia
	Local _cQuery
	Local nNumReg		:= RECCOUNT() + 1
	Local nProp			:= substr(dtos(cZ9DTREG),3,2)
	Local nPrecoVDAlt	:= 0
	Local B1PIS := 0
	Local B2PIS := 0
	Local B3PIS := 0
	Local nVPerdIMP 	:= 0
	Local nVFiancas 	:= 0
	Local nVCusFin		:= 0
	Local nVProvGR		:= 0
	Local nVlrPIMP		:= 0
	Local nVlrPIMP_SZG	:= 0
	Local nVlrFIAN 		:= 0
	Local nVlrFIAN_SZG 	:= 0
	Local nVlrCFIN		:= 0
	Local nVlrCFIN_SZG 	:= 0
	Local nVlrGAR 		:= 0
	Local nVlrGAR_SZG	:= 0
	Local nTotalZFFIAN2 := 0
	Local nTotalZFCFIN2 := 0
	Local nTotalZFGAR2 := 0
	Local nTotalZFPIMP2 := 0
	Local nTotalSZFFIAN_RES2 := 0
	Local nTotalSZFCFIN_RES2 := 0
	Local nTotalSZFGAR_RES2 := 0
	Local nTotalSZFPIMP_RES2 := 0

	BEGINSQL ALIAS "TR1"
	     SELECT * FROM SZ9010 WHERE Z9_NPROP LIKE substring(CONVERT(VARCHAR, GetDate(), 120), 3,2) + '%' AND  D_E_L_E_T_ <> '*'
	ENDSQL

	nTotReg := Contar("TR1","!Eof()") +1
 	nSequencia := cValToChar(STRZERO(nTotReg,3))

	//////////////////////////// NUMERO DE PROPOSTA
	//oModelSZ9:SetValue('Z9_NPROP', cZ9CLASS + cZ9MERC + cZ9TIPO  )
	IF !EMPTY(nNPROPOSTA)
		nNPROPOSTA := SUBSTR(nNPROPOSTA,1,5) +  "-" + cZ9CLASS + cZ9MERC + cZ9TIPO
		oModelSZ9:SetValue('Z9_NPROP', nNPROPOSTA )
	ELSE
		oModelSZ9:SetValue('Z9_NPROP', nProp + nSequencia + "-" + cZ9CLASS + cZ9MERC + cZ9TIPO )
		nNPROPOSTA := nProp + nSequencia + "-" + cZ9CLASS + cZ9MERC + cZ9TIPO
	ENDIF

	//msginfo( nTotReg )

	TR1->( DbCloseArea() )

 	//////////////////////////// Custo Vendido ///////////////////////////////////////////
	For nI23 := 1 To oModelSZP:Length()
		oModelSZP:GoLine( nI23 )
		nTotalZT		:= oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' )

		For nI24 := 1 To oModelSZT:Length()
			oModelSZT:GoLine( nI24 )
			nTotalZT		:= oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' )
			nTotalZTF += Round( nTotalZT , 2 )

	   	Next nI24

	   	If nTotalZTF > 0
	   		oModelSZP:SetValue('ZP_UNIT', nTotalZTF )
	   		oModelSZP:SetValue('ZP_NPROP', nNPROPOSTA )
	   		nTotalZTF := 0
	    Endif
	   	//oModelSZP:SetValue('ZP_UNIT', nTotalZTF )
	 Next nI23

	//// CUSTO VENDIDO SUB-CONJUNTO NIVEL 3
 	For nI25 := 1 To oModelSZG:Length()
		oModelSZG:GoLine( nI25 )

		nTotalZP		:= oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' )

		For nI21 := 1 To oModelSZP:Length()
			oModelSZP:GoLine( nI21 )

			varQuant   		:=  oModel:GetValue( 'SZPDETAIL', 'ZP_QUANT' )
			varUnit 		:=  oModel:GetValue( 'SZPDETAIL', 'ZP_UNIT' )
			varTotal 		:=  Round( varQuant * varUnit , 2 )

			oModelSZP:SetValue('ZP_TOTAL', varTotal )

			nTotalZP		:= oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' )
			nTotalZPF += Round( nTotalZP , 2 )

	   	Next nI21

	    If nTotalZPF > 0
	   		oModelSZG:SetValue('ZG_UNIT', nTotalZPF )
	   		nTotalZPF := 0
	    Endif

	    nZG_POC		  := oModel:GetValue( 'SZGDETAIL', 'ZG_POC' )

		if nZG_POC	= "1"
		    oModelSZG:SetValue('ZG_PCONT', nPCONT_Z9 )
		    oModelSZG:SetValue('ZG_CUSFIN', nCUSFIN_Z9 )
		    oModelSZG:SetValue('ZG_FIANCAS', nFIANCAS_Z9 )
		    oModelSZG:SetValue('ZG_PROVGR', nPROVGAR_Z9 )
		    oModelSZG:SetValue('ZG_PERDIMP', nPERDIMP_Z9 )
		    oModelSZG:SetValue('ZG_PROYALT', nPROYALT_Z9 )
		    oModelSZG:SetValue('ZG_PCOMIS', nPCOMIS_Z9 )
		    oModelSZG:SetValue('ZG_NPROP', nNPROPOSTA )
		endif

	    ///////////////////////////////////////////////////////////////////////////////
	   	//VConting = (CustoSITotal / ((100 - PConting) / 100)) - CustoSITotal
	   	nPContig 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCONT' )
	   	nTotalZG 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	   	nQuantSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
	   	nVLRCONT 	:=  Round( ((nTotalZG/((100-nPContig)/100))-nTotalZG) , 2 )
	   	oModelSZG:SetValue('ZG_VLRCONT', nVLRCONT )
	   	//oModelSZG:SetValue('ZG_PDESC', 0 )
	   	//oModelSZG:SetValue('ZG_DESC', 0 )

	   	//VCustoConting = CustoSITotal + VConting
		nQuantSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
		nVCustoCont	:= Round((nTotalZG + nVLRCONT),2)
		oModelSZG:SetValue('ZG_CCONT', nVCustoCont )

		// PMargemBruta = MB_OutrosCustos + MB_Royalty + MB_Comissao + Form_PP_CustosPrecos_CadSecao.MarkUpInicial
		nPCusFin 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_CUSFIN' )
		nPFiancas	:= oModel:GetValue( 'SZGDETAIL', 'ZG_FIANCAS' )
		nPProvGR	:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROVGR' )
		nPPerdIMP	:= oModel:GetValue( 'SZGDETAIL', 'ZG_PERDIMP' )
		nPRoyalt	:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROYALT' )
		nPComis		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOMIS' )
		nPMKPINI	:= oModel:GetValue( 'SZFDETAIL', 'ZF_MKPINI' )
		nPMGBruta 	:= Round(nPCusFin + nPFiancas + nPProvGR + nPPerdIMP + nPRoyalt + nPComis + nPMKPINI,2)
		oModelSZG:SetValue('ZG_PMKP', nPMGBruta )

		//VMargemBruta = (VCustoConting / ((100 - PMargemBruta) / 100)) - VCustoConting
		nVMargemBruta := Round((nVCustoCont / ((100 - nPMGBruta) / 100 )) - nVCustoCont,2)
		oModelSZG:SetValue('ZG_VLRMBRT', nVMargemBruta )

		//VPrecoVendaInicial = VCustoConting + VMargemBruta
		nVPrecoVendaInicial := Round(nVCustoCont + nVMargemBruta ,2 )
		oModelSZG:SetValue('ZG_VLRPVIN', nVPrecoVendaInicial )

		//VPisCofins = VPrecoVendaInicial / ((100 - PPisCofins) / 100) - VPrecoVendaInicial
		nPPIS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PPIS' )
		nVPIS		:= Round(nVPrecoVendaInicial / ((100 - nPPIS) / 100) - nVPrecoVendaInicial,2)
		oModelSZG:SetValue('ZG_VLRPIS', nVPIS )

		nPCOF 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOF' )
		nVCOF		:= Round(nVPrecoVendaInicial / ((100 - nPCOF) / 100) - nVPrecoVendaInicial,2)
		oModelSZG:SetValue('ZG_VLRCOF', nVCOF )

		//VIPI = (VPrecoVendaInicial + VPisCofins + VIcms + VIss) / ((100 - PIPI) / 100) - (VPrecoVendaInicial + VPisCofins + VIcms + VIss)
		nPIPI		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PIPI' )
		nVIPI		:= (( nVPrecoVendaInicial / (1 -(( 1 - ( nPICMS * ( 1 + nPIPI)))) + nPPIS + nPCOF )) * nPIPI)
		oModelSZG:SetValue('ZG_VLRIPI', nVIPI )

		//VIcms = VPrecoVendaInicial / ((100 - PIcms) / 100) - VPrecoVendaInicial
		nPICMS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PICMS' )
		nVICMS		:= Round(nVPrecoVendaInicial / ((100 - nPICMS) / 100) - nVPrecoVendaInicial,2)
		oModelSZG:SetValue('ZG_VLRICM', nVICMS )

		//VIss = VPrecoVendaInicial / ((100 - PIss) / 100) - VPrecoVendaInicial
		nPISS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PISS' )
		nVISS		:= Round(nVPrecoVendaInicial / ((100 - nPISS) / 100) - nVPrecoVendaInicial,2)
		oModelSZG:SetValue('ZG_VLRISS', nVISS )

		//Round((nVPrecoVendaInicial + nVPIS + nVCOF + nVICMS + nVISS) / ((100 - nPIPI) / 100) - (nVPrecoVendaInicial + nVPIS + nVCOF + nVICMS + nVISS),2)
/*
		//VDesconto = VPrecoVendaInicial - VPrecoVendaInicial * ((100 - PDesconto) / 100)
		nPDESC		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PDESC' )
		nVDESC		:= Round(nVPrecoVendaInicial / ((100 - nPDESC) / 100) - nVPrecoVendaInicial,2)
		oModelSZG:SetValue('ZG_DESC', nVDESC )
*/
		//VPrecoUnitarioSIP = VPrecoVendaInicial * ((100 - PDesconto) / 100)
		nPrecoVDSITot	:= Round(nVPrecoVendaInicial ,2)
		oModelSZG:SetValue('ZG_TOTVSI', nPrecoVDSITot )

		nPrecoVDSIUni	:= Round((nVPrecoVendaInicial ) / nQuantSZG,2)
		oModelSZG:SetValue('ZG_UNITVSI', nPrecoVDSIUni )

		//VCustFin = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - PCustFin) / 100))
		nPCusFin		:= oModel:GetValue( 'SZGDETAIL', 'ZG_CUSFIN' )
		nVCusFin		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPCusFin) / 100)),2)
		oModelSZG:SetValue('ZG_VLRCFIN', nVCusFin )

		//VGarantia = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - PGarantia) / 100))
		nPProvGR		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROVGR' )
		nVProvGR		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPProvGR) / 100)),2)
		oModelSZG:SetValue('ZG_VLRGAR', nVProvGR )

		//VFiancas = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - PFiancas) / 100))
		nPFiancas		:= oModel:GetValue( 'SZGDETAIL', 'ZG_FIANCAS' )
		nVFiancas		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPFiancas) / 100)),2)
		oModelSZG:SetValue('ZG_VLRFIAN', nVFiancas )

		//VPerdImp = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - PPerdImp) / 100))
		nPPerdImp		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PERDIMP' )
		nVPerdIMP		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPPerdIMP) / 100)),2)
		oModelSZG:SetValue('ZG_VLRPIMP', nVPerdIMP )

		//VRoyalty = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - PRoyalty) / 100))
		nPRoyalt		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROYALT' )
		nVRoyalt		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPRoyalt) / 100)),2)
		oModelSZG:SetValue('ZG_VLRROY', nVRoyalt )

		//VComissaoVenda = VPrecoUnitarioSIP - VPrecoUnitarioSIP * ((100 - PComissaoVenda) / 100)
		nPComis			:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOMIS' )
		nVComis			:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPComis) / 100)),2)
		oModelSZG:SetValue('ZG_VLRCOM', nVComis )

		//VOutrosCustos = VPrecoUnitarioSIP - (VPrecoUnitarioSIP * ((100 - POutrosCustos) / 100))
		nPOCUST			:= Round(nPCusFin + nPFiancas + nPProvGR + nPPerdIMP,2)
		nVOCUST			:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPOCUST) / 100)),2)
		oModelSZG:SetValue('ZG_VLROCUS', nVOCUST )

		//VPrecoUnitarioCIP = (VPrecoUnitarioSIP / ((100 - (PPisCofins + PIcms + PIss)) / 100))
		nZG_PVA		  := oModel:GetValue( 'SZGDETAIL', 'ZG_PVA' )

		if nZG_PVA	= "1"

			oModelSZG:GoLine( nI25 )

			nPrecoVDCITot	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nQuantSZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
			nPrecoVDCITot	:= Round((nPrecoVDCITot / ((100 - (nPPIS + nPCOF + nPICMS + nPISS )) / 100)),2)

			//oModelSZG:SetValue('ZG_TOTVCI', nPrecoVDCITot + nVIPI ) ///***********
			//oModelSZG:SetValue('ZG_VLRPSIP', nPrecoVDCITot )
			//nPrecoVDCIUni	:= Round( (nPrecoVDCITot + nVIPI) / nQuantSZG,2)
			//oModelSZG:SetValue('ZG_UNITVCI', nPrecoVDCIUni )
			/////////////////////////////////////////
			//VPisCofins = VPrecoVendaInicial / ((100 - PPisCofins) / 100) - VPrecoVendaInicial
			nVPrecoVendaInicial := Round(nVCustoCont + nVMargemBruta ,2 )

			nPPIS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PPIS' )
			nVPIS		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))) * (nPPIS/100)
			oModelSZG:SetValue('ZG_VLRPIS', nVPIS )
			//nVPIS		:= Round((nPrecoVDCIUnit2 - nPrecoVDCIUnit2 *((100 - nPPIS) / 100))*nQuantSZG,2)

			nPCOF 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOF' )
			nVCOF		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))) * (nPCOF/100)
			oModelSZG:SetValue('ZG_VLRCOF', nVCOF )

			nPIPI 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PIPI' )
			nVIPI		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))) * (nPIPI/100)
			oModelSZG:SetValue('ZG_VLRIPI', nVIPI )

			nPICMS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PICMS' )
			nVICMS		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))+nVIPI ) * (nPICMS/100)
			oModelSZG:SetValue('ZG_VLRICM', nVICMS )

			nPISS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PISS' )
			nVISS		:= Round((nPrecoVDCITot - nPrecoVDCITot *((100 - nPISS) / 100)),2)
			oModelSZG:SetValue('ZG_VLRISS', nVISS )

			nPrecoVDSITot	:= Round( nPrecoVDCITot  - (nVPIS + nVCOF + nVISS + nVICMS + nVIPI),2)
			oModelSZG:SetValue('ZG_TOTVSI', nPrecoVDSITot )
			oModelSZG:SetValue('ZG_UNITVSI', nPrecoVDSITot / nQuantSZG )

			nPrecoVDCITot   := Round( nVPrecoVendaInicial  + nVPIS + nVCOF + nVISS + nVICMS + nVIPI,2)
			oModelSZG:SetValue('ZG_TOTVCI', nPrecoVDCITot )
			oModelSZG:SetValue('ZG_UNITVCI', nPrecoVDCITot / nQuantSZG )

			//nPrecoVDSITot		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nPRoyalt		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROYALT' )
			nVRoyalt		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPRoyalt) / 100)),2)
			oModelSZG:SetValue('ZG_VLRROY', nVRoyalt )

			nPComis			:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOMIS' )
			nVComis			:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPComis) / 100)),2)
			oModelSZG:SetValue('ZG_VLRCOM', nVComis )

			nPOCUST			:= nPCusFin + nPFiancas + nPProvGR + nPPerdIMP
			nVOCUST			:= Round((nPOCUST/100)* nPrecoVDSITot,2)
			oModelSZG:SetValue('ZG_VLROCUS', nVOCUST )

			//VMarkup = VPrecoUnitarioSIP - (VCustoConting + VOutrosCusto☺s + VRoyalty + VComissaoVenda)
			nTotSI			:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nVlrOU			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLROCUS' )
			nVlrROY			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRROY' )
			nVlrCom			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCOM' )
			nVlrCusCont		:= oModel:GetValue( 'SZGDETAIL', 'ZG_CCONT' )
			nVlrMKP			:= Round(nPrecoVDSITot - (nVlrOU + nVlrROY + nVlrCom) - nVlrCusCont,2)
			oModelSZG:SetValue('ZG_VLRMKP', 0 )
			oModelSZG:SetValue('ZG_PDESC', 0 )
			oModelSZG:SetValue('ZG_DESC', 0 )
			oModelSZG:SetValue('ZG_NPROP', nNPROPOSTA )

		else

			nPrecoVDAlt	:= oModel:GetValue( 'SZGDETAIL', 'ZG_UNITVCI' )

			oModelSZG:SetValue('ZG_TOTVCI', (nPrecoVDAlt ) * nQuantSZG ) //*******
			//oModelSZG:SetValue('ZG_VLRPSIP', nPrecoVDCIUnit2 + nVIPI ) // *********
			/////////////////////////////////////////
			//VPisCofins = VPrecoVendaInicial / ((100 - PPisCofins) / 100) - VPrecoVendaInicial
			nVPrecoVendaInicial := Round(nVCustoCont + nVMargemBruta ,2 )

			nPIPI 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PIPI' )
			nVIPI		:=  (nPrecoVDAlt - ( nPrecoVDAlt / ( 1 +  (nPIPI/100) ))) * nQuantSZG //( nPrecoVDAlt - (nPrecoVDAlt * ( 1- ( nPIPI / 100  )) ) )
			oModelSZG:SetValue('ZG_VLRIPI', nVIPI  )

			nPrecoVDCITot	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nPPIS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PPIS' )
			//nVPIS		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))) * (nPPIS/100)
			nVPIS		:= ( (nPrecoVDAlt - ( nVIPI/ nQuantSZG ) ) - ( (nPrecoVDAlt- ( nVIPI/ nQuantSZG )) * ( 1- ( nPPIS / 100  )) ) ) * nQuantSZG

			oModelSZG:SetValue('ZG_VLRPIS', nVPIS )
			//nVPIS		:= Round((nPrecoVDCIUnit2 - nPrecoVDCIUnit2 *((100 - nPPIS) / 100))*nQuantSZG,2)

			nPrecoVDCITot	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nPCOF 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOF' )
			nVCOF		:= ( (nPrecoVDAlt-( nVIPI/ nQuantSZG )) - ( (nPrecoVDAlt-( nVIPI/ nQuantSZG )) * ( 1- ( nPCOF / 100  )) ) ) * nQuantSZG
			//nVCOF		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))) * (nPCOF/100)
			oModelSZG:SetValue('ZG_VLRCOF', nVCOF )

			nPICMS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PICMS' )
			//nVICMS		:= (nVPrecoVendaInicial / ( 1- (( 1- (1- ( (nPICMS/100) * ( 1 + (nPIPI/100) )))) + (nPPIS/100) + (nPCOF/100) ))+nVIPI ) * (nPICMS/100)
			nVICMS		:= ( nPrecoVDAlt - (nPrecoVDAlt * ( 1- ( nPICMS / 100  )) ) ) * nQuantSZG
			oModelSZG:SetValue('ZG_VLRICM',nVICMS)

			nPISS 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PISS' )
			nVISS		:= ( nPrecoVDAlt - (nPrecoVDAlt * ( 1- ( nPISS / 100  )) ) ) * nQuantSZG
			oModelSZG:SetValue('ZG_VLRISS', nVISS )

			nPUNITSIP 		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVCI' )
			nPrecoVDSITot	:= Round( ( nPUNITSIP) - (nVPIS + nVCOF + nVISS + nVICMS + nVIPI),2)
			oModelSZG:SetValue('ZG_TOTVSI', nPrecoVDSITot )
			oModelSZG:SetValue('ZG_UNITVSI', nPrecoVDSITot/nQuantSZG )


			nPRoyalt		:= oModel:GetValue( 'SZGDETAIL', 'ZG_PROYALT' )
			nVRoyalt		:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPRoyalt) / 100)),2)
			oModelSZG:SetValue('ZG_VLRROY', nVRoyalt )

			nPComis			:= oModel:GetValue( 'SZGDETAIL', 'ZG_PCOMIS' )
			nVComis			:= Round(nPrecoVDSITot - (nPrecoVDSITot * ((100 - nPComis) / 100)),2)
			oModelSZG:SetValue('ZG_VLRCOM', nVComis )

			nPOCUST			:= nPCusFin + nPFiancas + nPProvGR + nPPerdIMP
			nVOCUST			:= Round((nPOCUST/100)* nPrecoVDSITot,2)
			oModelSZG:SetValue('ZG_VLROCUS', nVOCUST )

			oModelSZG:SetValue('ZG_NPROP', nNPROPOSTA )

		endif

		//VMarkup = VPrecoUnitarioSIP - (VCustoConting + VOutrosCusto☺s + VRoyalty + VComissaoVenda)
		nTotSI			:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
		nVlrOU			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLROCUS' )
		nVlrROY			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRROY' )
		nVlrCom			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCOM' )
		nVlrCusCont		:= oModel:GetValue( 'SZGDETAIL', 'ZG_CCONT' )
		nVlrMKP			:= Round(nTotSI - (nVlrOU + nVlrROY + nVlrCom) - nVlrCusCont,2)
		oModelSZG:SetValue('ZG_VLRMKP', nVlrMKP )

		//PMarkup = (valMarkup / VPrecoUnitarioSIP) * 100

		nTotSI			:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
		nPMKPFIN		:= Round(( nVlrMKP / nTotSI) * 100 ,2)
		oModelSZG:SetValue('ZG_MKPFIN', nPMKPFIN )

			//VDesconto = VPrecoVendaInicial - VPrecoVendaInicial * ((100 - PDesconto) / 100)
			nPrecoVDSITot		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )

			nVPrecoVendaInicial := oModel:GetValue( 'SZGDETAIL', 'ZG_VLRPVIN' )
			nVCustoCont			:= oModel:GetValue( 'SZGDETAIL', 'ZG_CCONT' )
			nVMargem 			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRMKP' )
			//mValDesconto = mValPrecoVendaInicial - (mValContigCustoTotal + mValMarkUp + mValOutrosCustos + mValRoyalty + mValComissaoVenda)

			nVDesc				:= Round(nVPrecoVendaInicial - (nVlrCusCont + nVlrMKP + nVlrOU + nVlrROY + nVlrCom) ,2)
			if nVDesc > 0
				oModelSZG:SetValue('ZG_DESC', nVDesc )
				nPDesc				:= Round((nVDesc/nVPrecoVendaInicial)*100,2)
				oModelSZG:SetValue('ZG_PDESC', nPDesc )
			endif

		/*
	   	///////////////////////////////////////////////////////////////////////////////
	   	nQuantSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
		cIDVDSUBSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVDSUB' )
		cIDVDSUBSZP	:= oModel:GetValue( 'SZPDETAIL', 'ZP_IDVDSUB' )
		nTotalZPF 	:= 0
	*/
	Next nI25

 	nTotalZFF 	:= 0

	//// CUSTO VENDIDO CONJUNTO
 	For nI26 := 1 To oModelSZF:Length()

		oModelSZF:GoLine( nI26 )
		nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
		nTotSI			:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
		nQuantSZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )

		For nI27 := 1 To oModelSZG:Length()

			oModelSZG:GoLine( nI27 )

			varQuant   		:=  oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
			varUnit 		:=  oModel:GetValue( 'SZGDETAIL', 'ZG_UNIT' )
			varTotal 		:=  Round(varQuant * varUnit,2)
			oModelSZG:SetValue('ZG_TOTAL', varTotal )

			nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
			nTotalZFF += Round( nTotalZG , 2 )

			nPrecoVDSITot 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVSI' )
			nPrecoVDCITot 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTVCI' )

			nTotVSI_SZG	  	+= Round( nPrecoVDSITot , 2 )
			nTotVCI_SZG	  	+= Round( nPrecoVDCITot , 2 )

			nVlrPIMP	  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRPIMP' )
			nVlrPIMP_SZG	  	+= Round( nVlrPIMP , 2 )

			nVlrFIAN	  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRFIAN' )
			nVlrFIAN_SZG	  	+= Round( nVlrFIAN , 2 )

			nVlrCFIN	  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCFIN' )
			nVlrCFIN_SZG	  	+= Round( nVlrCFIN , 2 )

			nVlrGAR	  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRGAR' )
			nVlrGAR_SZG	  	+= Round( nVlrGAR , 2 )

			nVlrOU		  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLROCUS' )
			nVlrOU_SZG	  	+= Round( nVlrOU , 2 )

			nVlrCOM		  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCOM' )
			nVlrCOM_SZG	  	+= Round( nVlrCOM , 2 )

			nVlrROY		  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRROY' )
			nVlrROY_SZG	  	+= Round( nVlrROY , 2 )

			nVlrMKP		  	:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRMKP' )
			nVlrMKP_SZG	  	+= Round( nVlrMKP , 2 )

			nVlrCont		:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRCONT' )
			nVlrCont_SZG	+= Round( nVlrCont , 2 )

			nCusCont2		:= oModel:GetValue( 'SZGDETAIL', 'ZG_CCONT' )
			nCusCont2_SZG	+= Round( nCusCont2 , 2 )

			nPrcVDINI		:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRPVIN' )
			nPrcVDINI_SZG 	+= Round( nPrcVDINI , 2 )

			nVlrMBRT		:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRMBRT' )
			nVlrMBRT_SZG 	+= Round( nVlrMBRT , 2 )
	   	Next nI27

	    oModelSZF:SetValue('ZF_UNIT', nTotalZFF )

	    if nTotalZFF > 0
	    	oModelSZF:SetValue('ZF_TOTAL', nTotalZFF*nQuantSZF )
	    endif

	   	oModelSZF:SetValue('ZF_UNITVSI', nTotVSI_SZG )
	   	
	   	if nTotVSI_SZG	> 0
	   		oModelSZF:SetValue('ZF_TOTVSI', nTotVSI_SZG*nQuantSZF )
	   	endif

	   	oModelSZF:SetValue('ZF_UNITVCI', nTotVCI_SZG )	   	
	   	oModelSZF:SetValue('ZF_TOTVCI', nTotVCI_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRPIMP', nVlrPIMP_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRFIAN', nVlrFIAN_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRCFIN', nVlrCFIN_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRGAR', nVlrGAR_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLROCUS', nVlrOU_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRCOM', nVlrCOM_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRROY', nVlrROY_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRMKP', nVlrMKP_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRCONT', nVlrCont_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_CCONT', nCusCont2_SZG*nQuantSZF ) // nVlrCusCont_SZG*nQuantSZF
	   	oModelSZF:SetValue('ZF_VLRPVIN', nPrcVDINI_SZG*nQuantSZF )
	   	oModelSZF:SetValue('ZF_VLRMKPB', nVlrMBRT_SZG*nQuantSZF )

	   	nVlrMKP			:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRMKP' )
		nTotSI			:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVSI' )
		//nTotCI			:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVCI' ú)
		nPMKPFIN		:= Round((nVlrMKP / nTotSI) * 100,2)
		if nVlrMKP > 0
			oModelSZF:SetValue('ZF_MKPFIN', nPMKPFIN )
		endif
		nVlrMKP			:= 0
		nTotalZFF 		:= 0
		nTotVSI_SZG 	:= 0
		nTotVCI_SZG 	:= 0

		nVlrPIMP_SZG	:= 0
		nVlrFIAN_SZG	:= 0
		nVlrCFIN_SZG	:= 0
		nVlrGAR_SZG		:= 0

		nVlrOU_SZG		:= 0
		nVlrCOM_SZG		:= 0
		nVlrROY_SZG		:= 0
		nVlrMKP_SZG		:= 0
		nVlrMBRT_SZG	:= 0
		nVlrCont_SZG	:= 0
		nVlrCusCont_SZG	:= 0
		nPrcVDINI_SZG	:= 0

	Next nI26

	////////////////////////////////RESUMO CUSTOS //////////////////////////////////////////////////
	// CUSTO PRODUCAO VENDIDO
	For nI7 := 1 To oModelSZF:Length()
			oModelSZF:GoLine( nI7 )
			// Custo
			nTotalZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
			nTotalSZF_RES += Round( nTotalZF , 2 )

			nVlrMKP2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRMKP' )
			nVlrMKP2_FIN	+= Round(nVlrMKP2,2)

			nVlrMKPB2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRMKPB' )
			nVlrMKPB2_FIN	+= Round(nVlrMKPB2,2)

			nTotVSI2 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVSI' )
	   		nTotVSI2_FIN	+= nTotVSI2

	   		nTotVCI2 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVCI' )
	   		nTotVCI2_FIN	+= Round(nTotVCI2,2)

	   		nVlrCont2 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCONT' )
	   		nVlrCont2_FIN	+= Round(nVlrCont2,2)

	   		nVlrMKP			:= oModel:GetValue( 'SZGDETAIL', 'ZG_VLRMKP' )

	Next nI7

	nPMKPFIN2		:= Round((nVlrMKP2_FIN / nTotVSI2_FIN) * 100,2)
	nPMKPBFIN2		:= Round((nVlrMKPB2_FIN / nTotVSI2_FIN) * 100,2)

	// ATRIBUICAO DE VALORES CUSTO DE PRODUCAO
	//oModelSZN:AddLine()
	// OUTROS CUSTOS VENDIDO
	For nI9 := 1 To oModelSZF:Length()

			nTotalZFCONT		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCONT' )
			//nTotalZFOCUS		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLROCUS' )
			nTotalZFFIAN2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRFIAN' )
			nTotalZFCFIN2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCFIN' )

			nTotalZFGAR2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRGAR' )
			nTotalZFPIMP2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRPIMP' )

			nTotalZFCOM2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCOM' )
			nTotalZFROY2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRROY' )
			//nTotalSZFOCUS_RES 	+= Round( nTotalZFOCUS , 2 )

			nTotalSZFFIAN_RES2 	+= Round( nTotalZFFIAN , 2 )
			nTotalSZFCFIN_RES2 	+= Round( nTotalZFCFIN , 2 )

			nTotalSZFGAR_RES2 	+= Round( nTotalZFGAR , 2 )
			nTotalSZFPIMP_RES2 	+= Round( nTotalZFPIMP , 2 )

			nTotalSZFCOM_RES2 	+= Round( nTotalZFCOM2 , 2 )
			nTotalSZFROY_RES2 	+= Round( nTotalZFROY2 , 2 )

	Next nI9

	nTotOCR	:= 0
	//nTotOCR	:= Round(nTotalSZFOCUS_RES + nTotalSZFCOM_RES + nTotalSZFROY_RES + nTotalZFCont,2)
	nTotOCR2	:= Round(nTotalSZFCFIN_RES2 + nTotalSZFFIAN_RES2 + nTotalSZFGAR_RES2  +  nTotalSZFPIMP_RES2 + (nVlrCOM_SZG*nQuantSZF) + nTotalSZFROY_RES2 +  nVlrCont2_FINt ,2)
	/*
	if nTotVSI2_FIN > 0 .AND. nTotVCI2_FIN > 0 .AND. nTotalSZF_RES > 0 .AND. (nTotalSZF_RES + nTotOCR2) > 0
		oModelSZ9:SetValue('Z9_TOTSI', nTotVSI2_FIN )
		oModelSZ9:SetValue('Z9_TOTCI', nTotVCI2_FIN )
		oModelSZ9:SetValue('Z9_CUSTPR', nTotalSZF_RES )
		oModelSZ9:SetValue('Z9_CUSTOT', nTotalSZF_RES + nTotOCR2 ) 
	endif
	*/
For nI200 := 1 To oModelSZF:Length()
		oModelSZF:GoLine( nI200 )
		nICPROP		:= oModel:GetValue( 'SZFDETAIL', 'ZF_ITEMIC' )
		oModelSZF:SetValue('ZF_NPROP', nNPROPOSTA )

		For nI201 := 1 To oModelSZG:Length()
			oModelSZG:GoLine( nI201 )

			if oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' ) > 0
				oModelSZG:SetValue('ZG_ITEMIC', nICPROP )
				oModelSZG:SetValue('ZG_NPROP', nNPROPOSTA )
			endif

			For nI202 := 1 To oModelSZP:Length()
				oModelSZP:GoLine( nI202 )

				if oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' ) > 0
					oModelSZP:SetValue('ZP_ITEMIC', nICPROP )
					oModelSZP:SetValue('ZP_NPROP', nNPROPOSTA )
				endif

				For nI203 := 1 To oModelSZT:Length()
					oModelSZT:GoLine( nI203 )
					if oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' ) > 0
						oModelSZT:SetValue('ZT_ITEMIC', nICPROP )
						oModelSZT:SetValue('ZT_NPROP', nNPROPOSTA )
					endif

			   	Next nI203

		   	Next nI202

	   	Next nI201

	Next nI200

Return lRet

Static Function ViewDef()
    Local oView     := Nil
    Local oModel        := FWLoadModel('xMVCPR')
    Local oStPai        := FWFormStruct(2, 'SZ9')
    Local oStFilho6  	:= FWFormStruct(2, 'SZF')
    Local oStFilho30  	:= FWFormStruct(2, 'ZZM')
    Local oStNeto2      := FWFormStruct(2, 'SZG')
    Local oStNeto4      := FWFormStruct(2, 'SZP')
    Local oStNeto5      := FWFormStruct(2, 'SZT')
    //Local oStTot        := FWCalcStruct(oModel:GetModel('TOT_SALDO'))
    //Estruturas das tabelas e campos a serem considerados
    Local aStruSZ9  := SZ9->(DbStruct())
    Local aStruSZF  := SZF->(DbStruct())
    Local aStruZZM  := ZZM->(DbStruct())
    Local aStruSZG  := SZG->(DbStruct())
	Local aStruSZP  := SZP->(DbStruct())
	Local aStruSZT  := SZT->(DbStruct())
    Local cConsSZ9  := "Z9_FILIAL;Z9_CLASS;Z9_MERCADO;Z9_TIPO;Z9_NPROP;Z9_IDCONTR;Z9_CONTR;Z9_IDCLFIN;Z9_CLIFIN;Z9_IDENG;Z9_ENG;Z9_DTREG;Z9_DTEPROP;Z9_DTEREAL;Z9_DTPREV;Z9_IDELAB;Z9_RESPELA;Z9_IDRESP;Z9_RESP;Z9_CODREP;Z9_REPRE;Z9_CODPAIS;Z9_PAIS;Z9_LOCAL;Z9_PROJETO;Z9_STATUS;Z9_FILIAL;Z9_PCONT;Z9_CUSFIN;Z9_FIANCAS;Z9_PROVGAR;Z9_PERDIMP;Z9_PERDIMP;Z9_PROYALT;Z9_MKPINI;Z9_PCOMIS,Z9_TOTSI,Z9_TOTCI,Z9_CUSTPR;Z9_CUSTOT;Z9_XCOEQ;Z9_XEQUIP;Z9_INDUSTR;Z9_BOOK;Z9_VIAEXEC;Z9_DIMENS;Z9_CUSPRD;Z9_CUSTOD;Z9_TOTSID;Z9_TOTCID;Z9_DCAMBIO;Z9_CAMBIO,Z9_CONTATO,Z9_SETCONT,Z9_DDICONT,Z9_DDDCONT,Z9_FONCONT,Z9_EMAILCO,Z9_REFEREN,Z9_ESCOPO,Z9_TIPOPRO,Z9_REV"
    Local cConsSZF  := "ZF_IDVEND;ZF_ITEMIC;ZF_CODPROD;ZF_DESCRI;ZF_QUANT;ZF_UM;ZF_TOTAL;ZF_MKPINI;ZF_MKPFIN;ZF_UNITVSI;ZF_TOTVSI;ZF_UNITVCI;ZF_TOTVCI;ZF_VLRMKP;ZF_VLRMKPB;ZF_VLRCONT;ZF_CCONT;ZF_VLRPIMP;ZF_VLRFIAN;ZF_VLRCFIN;ZF_VLRGAR;ZF_VLRPVIN;ZF_VLROCUS;ZF_VLRROY;ZF_VLRCOM;ZF_VLRROY;ZF_CALC;ZF_OBS;ZF_NPROP;ZF_DIMENS"
    Local cConsSZG  := "ZG_FILIAL;ZG_IDVEND;ZG_IDVDSUB;ZG_ITEM;ZG_QUANT;ZG_CODPROD;ZG_DESCRI;ZG_QUANT;ZG_UNIT;ZG_UM;ZG_TOTAL; ZG_PVA;ZG_POC;ZG_PCONT;;ZG_CUSFIN;ZG_FIANCAS;ZG_PROVGR;ZG_PERDIMP;ZG_PROYALT;ZG_PCOMIS;ZG_PDESC;;ZG_PMKP;ZG_UNITVSI;ZG_TOTVSI;ZG_PVA;ZG_PPIS;ZG_PCOF;ZG_PICMS;ZG_PIPI;ZG_PISS;ZG_UNITVCI;ZG_TOTVCI;ZG_MKPFIN;ZG_VLRMKP;ZG_VLRPIS;ZG_VLRCOF;ZG_VLRICM;ZG_VLRIPI;ZG_VLRISS;ZG_VLRCONT;ZG_VLRCONT;ZG_CCONT;ZG_VLRMBRT;ZG_PMBRT;;ZG_VLRPVIN;ZG_VLRPIMP;ZG_VLRFIAN;ZG_VLRCFIN;ZG_VLRGAR;ZG_VLROCUS;ZG_VLRROY;ZG_VLRCOM;ZG_VLRDESC;ZG_VLRPSIP;ZG_NPROP;ZG_GRUPO;ZG_ITEMIC"
    Local cConsSZP  := "ZP_FILIAL;ZP_IDVDSUB;ZP_IDVDSB2;ZP_ITEM;ZP_QUANT;ZP_UM;ZP_CODPROD;ZP_DESCRI;ZP_UNIT;ZP_TOTAL;ZP_OBS;ZP_NPROP;ZP_GRUPO;ZP_ITEMIC;ZP_GRUPO;ZP_GRUSA"
    Local cConsSZT  := "ZT_FILIAL;ZT_IDVDSB3;ZT_IDVDSB2;ZT_ITEM;ZT_QUANT;ZT_UM;ZT_CODPROD;ZT_DESCRI;ZT_UNIT;ZT_PESO;ZT_TOTAL;ZT_NPROP;ZT_ITEMIC"
	Local cConsZZM  := "ZZM_GRUPO;ZZM_ITEM;ZZM_QUANT;ZZM_VUNIT;ZZM_TOTAL;ZZM_NPROP;ZZM_ITEMCT;ZZM_GS"
    Local nAtual        := 0

    //Criando a View
	//Local oStrSZF:= FWCalcStruct( oModel:GetModel('calcSZF') )
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField('VIEW_SZ9',oStPai,'SZ9MASTER')
    oView:AddGrid('VIEW_SZF',oStFilho6,'SZFDETAIL')
    oView:AddGrid('VIEW_ZZM',oStFilho30,'ZZMDETAIL')
    oView:AddGrid('VIEW_SZG',oStNeto2,'SZGDETAIL')
    oView:AddGrid('VIEW_SZP',oStNeto4,'SZPDETAIL')
    oView:AddGrid('VIEW_SZT',oStNeto5,'SZTDETAIL')

    oView:CreateFolder( 'FOLDER1')
    oView:AddSheet('FOLDER1','SHEET9','Proposta')
	oView:AddSheet('FOLDER1','SHEET5','Detalhamento Proposta (Novo)')
    oView:AddSheet('FOLDER1','SHEET4','Detalhes Proposta')
    
	oView:CreateHorizontalBox('CABEC3',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	//View:CreateHorizontalBox('BOX56',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Resumo
	oView:CreateHorizontalBox('GRID30',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET5')
	oView:CreateHorizontalBox('GRID7',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
	//oView:CreateVerticalBox('GRID7A',20, 'GRID7', /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
	//oView:CreateVerticalBox('GRID7B',20, 'GRID7', /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
    oView:CreateHorizontalBox('GRID8',25, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 2 - Vendido
	oView:CreateHorizontalBox('GRID19',25,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateVerticalBox('GRID19A',100,'GRID19', /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateHorizontalBox('GRID19B',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido

    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_SZ9','CABEC3')
    oView:SetOwnerView('VIEW_SZF','GRID7')
    oView:SetOwnerView('VIEW_ZZM','GRID30')
    oView:SetOwnerView('VIEW_SZG','GRID8')
    oView:SetOwnerView('VIEW_SZP','GRID19A')
    oView:SetOwnerView('VIEW_SZT','GRID19B')

	oView:AddIncrementField('VIEW_SZG' , 'ZG_ITEM' )
	oView:AddIncrementField('VIEW_SZF' , 'ZF_ITEM' )
	oView:AddIncrementField('VIEW_SZP' , 'ZP_ITEM' )
	oView:AddIncrementField('VIEW_SZT' , 'ZT_ITEM' )
	oView:AddIncrementField('VIEW_ZZM' , 'ZJ_ITEM' )

	oView:EnableTitleView('VIEW_SZF','Nivel 1 - Operacao Unitaria')
    oView:EnableTitleView('VIEW_SZG','Nivel 2 - Conjunto')
    oView:EnableTitleView('VIEW_SZP','Nivel 3 - Sub-Conjunto')
    oView:EnableTitleView('VIEW_SZT','Nivel 4 - Sub-Conjunto')
    oView:EnableTitleView('VIEW_ZZM','Detalhamento Custos (Novo)')

    oView:SetNoUpdateLine('VIEW_ZZM')
	oView:SetNoDeleteLine('VIEW_ZZM')
	oView:SetNoInsertLine('VIEW_ZZM')
	oView:SetViewProperty('VIEW_ZZM' , 'ONLYVIEW' )

	oView:AddUserButton( 'Word', '', {|oView| U_zProp01() } )  

    //Percorrendo a estrutura da CTD
    For nAtual := 1 To Len(aStruSZ9)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ9[nAtual][01]) $ cConsSZ9
            oStPai:RemoveField(aStruSZ9[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SZF
    For nAtual := 1 To Len(aStruSZF)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZF[nAtual][01]) $ cConsSZF
            oStFilho6:RemoveField(aStruSZF[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SZG
    For nAtual := 1 To Len(aStruSZG)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZG[nAtual][01]) $ cConsSZG
            oStNeto2:RemoveField(aStruSZG[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SDP
    For nAtual := 1 To Len(aStruSZP)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZP[nAtual][01]) $ cConsSZP
            oStNeto4:RemoveField(aStruSZP[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SDT
    For nAtual := 1 To Len(aStruSZT)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZT[nAtual][01]) $ cConsSZT
            oStNeto5:RemoveField(aStruSZT[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SZJ
    For nAtual := 1 To Len(aStruZZM)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZM[nAtual][01]) $ cConsZZM
            oStFilho30:RemoveField(aStruZZM[nAtual][01])
        EndIf
    Next

	oView:SetCloseOnOk( { ||.F. } )

Return oView
//-------------------------------------------------------------------

Static Function COMP021BUT( oModel )
	//Local nOperation 	:= oModel:GetOperation()
	Local nI				:= 0
	Local nI2				:= 0

	Local oStPai        := FWFormStruct(2, 'SZ9')
	Local oStNeto2   	:= FWFormStruct(1, 'SZG')
	Local oModelSZF   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZG   	:= oModel:GetModel( 'SZGDETAIL' )
	Local nI3			:= 0
	Local nI4			:= 0

	Local nTotalZDF 	:= 0
	Local nQuantSZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )
	Local nTotalZF 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0

	//Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	//Local nITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local nI5			:= 0
	Local nI6			:= 0
	Local nI7			:= 0
	Local nI8			:= 0
	Local nI9			:= 0
	Local nI10			:= 0
	Local nI11			:= 0
	Local nI12			:= 0
	Local nI13			:= 0
	Local nI14			:= 0
	Local nI15			:= 0
	Local nI16			:= 0

	Local nLinha		:= 0
	Local nTotalSZF_RES := 0
	Local nTotalSZI_RES := 0
	Local nTotalSZM_RES := 0
	Local nTotalSZF_SZM := 0
	Local nTotalVendido := 0
	Local nMargemBrutaV := 0
	Local nMargemContrV := 0

	

Return

user Function zMVC10Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",   "1 - Ativa"  })      
    AADD(aLegenda,{"BR_CINZA",   "2 - Cancelada"})
    AADD(aLegenda,{"BR_LARANJA", "3 - Declinada"})
    AADD(aLegenda,{"BR_AMARELO", "4 - Nao Enviada"})
    AADD(aLegenda,{"BR_BRANCO",  "5 - Perdida"})
    AADD(aLegenda,{"BR_MARROM",  "6 - SLC"})
    AADD(aLegenda,{"BR_AZUL",    "7 - Vendida"})

    BrwLegenda("Propostas", "Status", aLegenda)
Return
