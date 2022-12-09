//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"

//Variáveis Estáticas
Static cTitulo := "Gestao de Propostas"


/*/ zMVCMdX
    @return Nil, Função não tem retorno
    @example
    u_zMVCMdX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function zMVC2PR()
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
    //ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVC2PR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVC2PR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVC2PR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_zMVC01Leg'     OPERATION 4                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.xMVCPR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    

Return aRot

//////////////////////////////////////////////////////////////////////////////

Static Function ModelDef()

    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'SZ9')
    Local oStFilho 		:= FWFormStruct(1, 'ZZM')

    Local aZZMRel       := {}

    //Criando o modelo e os relacionamentos
    //oModel := MPFormModel():New("xMVCPRM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)
    oModel := MPFormModel():New('xMVC2PRM',  , { |oMdl| COMP011POS( oMdl ) })

    oModel:AddFields('SZ9MASTER',/*cOwner*/,oStPai)
    oModel:SetPrimaryKey({})
    
    oModel:AddGrid('ZZMDETAIL','SZ9MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZMDETAIL', { { 'ZZM_NPROP', 'Z9_NPROP' } }, ZZM->(IndexKey(1)) )
    
    //oModel:GetModel('SZ9MASTER'):SetUniqueLine({"Z9_NPROP"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
     //aAdd(aSZFRel, {'ZF_FILIAL', 'Z9_FILIAL'} )
    aAdd(aZZMRel, {'ZZM_NPROP',  'Z9_NPROP'})
    
    oModel:GetModel('ZZMDETAIL'):SetOptional( .T. )
    
    oModel:SetRelation('ZZMDETAIL', { { 'ZZM_NPROP', 'Z9_NPROP' } }, ZZM->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZZMDETAIL'):SetUniqueLine({"ZZM_GRUPO"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
 
    //Setando as descrições
    oModel:SetDescription("Propostas")
    oModel:GetModel('SZ9MASTER'):SetDescription('Proposta')
    oModel:GetModel('ZZMDETAIL'):SetDescription('Custos - Vendido')

Return oModel


Static Function COMP011POS( oModel )
	//Local nOperation 	:= oModel:GetOperation()


	Local lRet 			:= .T.


	Local oModelSZ9   	:= oModel:GetModel( 'SZ9MASTER' )


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

 
Return lRet

Static Function ViewDef()
    Local oView     := Nil
    Local oModel        := FWLoadModel('zMVC2PR')
    Local oStPai        := FWFormStruct(2, 'SZ9')
    Local oStFilho  	:= FWFormStruct(2, 'ZZM')

    //Estruturas das tabelas e campos a serem considerados
    Local aStruSZ9  := SZ9->(DbStruct())
    Local aStruZZM  := ZZM->(DbStruct())

    Local cConsSZ9  := "Z9_FILIAL;Z9_CLASS;Z9_MERCADO;Z9_TIPO;Z9_NPROP;Z9_IDCONTR;Z9_CONTR;Z9_IDCLFIN;Z9_CLIFIN;Z9_IDENG;Z9_ENG;Z9_DTREG;Z9_DTEPROP;Z9_DTEREAL;Z9_DTPREV;Z9_IDELAB;Z9_RESPELA;Z9_IDRESP;Z9_RESP;Z9_CODREP;Z9_REPRE;Z9_CODPAIS;Z9_PAIS;Z9_LOCAL;Z9_PROJETO;Z9_STATUS;Z9_FILIAL;Z9_PCONT;Z9_CUSFIN;Z9_FIANCAS;Z9_PROVGAR;Z9_PERDIMP;Z9_PERDIMP;Z9_PROYALT;Z9_MKPINI;Z9_PCOMIS,Z9_TOTSI,Z9_TOTCI,Z9_CUSTPR;Z9_CUSTOT;Z9_XCOEQ;Z9_XEQUIP;Z9_INDUSTR;Z9_BOOK;Z9_VIAEXEC;Z9_DIMENS;Z9_CUSPRD;Z9_CUSTOD;Z9_TOTSID;Z9_TOTCID;Z9_DCAMBIO;Z9_CAMBIO"
    Local cConsZZM  := "ZZM_GRUPO;ZZM_GRUPO;ZZM_QUANT;ZZM_VUNIT;ZZM_TOTAL;ZZM_NPROP;ZZM_ITEMCT"

    Local nAtual        := 0

    //Criando a View

	//Local oStrSZF:= FWCalcStruct( oModel:GetModel('calcSZF') )

    oView := FWFormView():New()
    oView:SetModel(oModel)


    oView:AddField('VIEW_SZ9',oStPai,'SZ9MASTER')
    oView:AddGrid('VIEW_ZZM',oStFilho,'ZZMDETAIL')

    oView:CreateFolder( 'FOLDER1')
    oView:AddSheet('FOLDER1','SHEET9','Proposta')
    oView:AddSheet('FOLDER1','SHEET4','Detalhes Proposta')


	oView:CreateHorizontalBox('CABEC3',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('GRID7',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido


    //Amarrando a view com as box

    oView:SetOwnerView('VIEW_SZ9','CABEC3')
    oView:SetOwnerView('VIEW_ZZM','GRID7')
    
    oView:EnableTitleView('VIEW_ZZM','Custos')

    //Percorrendo a estrutura da CTD
    For nAtual := 1 To Len(aStruSZ9)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ9[nAtual][01]) $ cConsSZ9
            oStPai:RemoveField(aStruSZ9[nAtual][01])
        EndIf
    Next

    //Percorrendo a estrutura da SZF
    For nAtual := 1 To Len(aStruZZM)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZM[nAtual][01]) $ cConsZZM
            oStFilho:RemoveField(aStruZZM[nAtual][01])
        EndIf
    Next

	oView:SetCloseOnOk( { ||.T. } )

Return oView

user Function zMVC01Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",   "1	- Ativa"  })      
    AADD(aLegenda,{"BR_CINZA",   "2 - Cancelada"})
    AADD(aLegenda,{"BR_LARANJA", "3 - Declinada"})
    AADD(aLegenda,{"BR_AMARELO", "4 - Nao Enviada"})
    AADD(aLegenda,{"BR_BRANCO",  "5 - Perdida"})
    AADD(aLegenda,{"BR_MARROM",  "6 - SLC"})
    AADD(aLegenda,{"BR_AZUL",    "7 - Vendida"})

    BrwLegenda("Propostas", "Status", aLegenda)
Return
