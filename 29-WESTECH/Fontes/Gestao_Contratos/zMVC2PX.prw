//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Variáveis Estáticas
Static cTitulo := "Gestao de Contratos - Planejamento"
 
/*/ zMVCVPX
    @return Nil, Função não tem retorno
    @example
    u_zMVCVPX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function zMVC2PX()
    Local aArea   := GetArea()
    Local oBrowse
    Local xCond
    Local xCond2
    Local xCond3
    
     
    xCond := "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. CTD_ITEM<>'OPERACOES' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_DTEXSF < DDATABASE " 
    xCond2 := "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. CTD_ITEM<>'OPERACOES' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_DTEXSF >= DDATABASE "
    xCond3 := "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. CTD_ITEM<>'OPERACOES' .AND. SUBSTR(CTD_ITEM,9,2) >= '15'  "
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a descrição da rotina
    oBrowse:SetAlias("CTD")
    oBrowse:SetFilterDefault( "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' "  ) 
    DbSetOrder(6)
    
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    oBrowse:AddFilter("Contratos Fechados....",xCond)
    oBrowse:AddFilter("Contratos Abertos.....",xCond2,,.T.)
    oBrowse:AddFilter("Todos Contratos.......",xCond3)
    
    //Legendas
    oBrowse:AddLegend( "CTD->CTD_DTEXSF < Date()", "GRAY", "Fechado" )
    oBrowse:AddLegend( "CTD->CTD_DTEXSF >= Date()", "GREEN",   "Aberto" )
  
    DbSetOrder(1)
  
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    //ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'zMVC2Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVC2PX' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
//////////////////////////////////////////////////////////////////////////////
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'CTD')
    Local oStFilho  	:= FWFormStruct(1, 'ZZN')
    Local oStFilho6 	:= FWFormStruct(1, 'ZZM')
    Local oStFilho31 	:= FWFormStruct(1, 'ZZA')
    
    Local aZZNRel       := {}
    Local aZZMRel       := {}
    Local aZZARel       := {}

    

    //Criando o modelo e os relacionamentos
     //oModel := MPFormModel():New('zMVCVPXM',  , { |oMdl| COMP011POS( oMdl ) })
     //oModel := MPFormModel():New('zMVC2PXN', { |oMdl| COMP021BUT( oMdl ) } , { |oMdl| COMP011POS( oMdl )})
     oModel := MPFormModel():New('zMVC2PXN',,)
    	
       
    oModel:AddFields('CTDMASTER',/*cOwner*/,oStPai)
    
    oModel:AddGrid('ZZNDETAIL','CTDMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('ZZNDETAIL', { { 'ZZN_ITEMCT', 'CTD_ITEM' } }, ZZN->(IndexKey(1)) )
    
    oModel:AddGrid('ZZMDETAIL','CTDMASTER',oStFilho6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZMDETAIL', { { 'ZZM_ITEMCT', 'CTD_ITEM' } }, ZZM->(IndexKey(1)) )
	
	oModel:AddGrid('ZZADETAIL','CTDMASTER',oStFilho31,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZADETAIL', { { 'ZZA_ITEMIC', 'CTD_ITEM' } }, ZZA->(IndexKey(1)) )

	
 
    //Fazendo o relacionamento entre o Pai e Filho
	

    aAdd(aZZNRel, {'ZZN_FILIAL', 'CTD_FILIAL'} )
    aAdd(aZZNRel, {'ZZN_ITEMCT',  'CTD_ITEM'})
    
    aAdd(aZZMRel, {'ZZM_FILIAL', 'CTD_FILIAL'} )
    aAdd(aZZMRel, {'ZZM_ITEMCT',  'CTD_ITEM'})
     
    aAdd(aZZARel, {'ZZA_FILIAL', 'CTD_FILIAL'} )
    aAdd(aZZARel, {'ZZA_ITEMIC',  'CTD_ITEM'})
 
    
    
    oModel:GetModel('ZZNDETAIL'):SetOptional( .T. )
    oModel:GetModel('ZZMDETAIL'):SetOptional( .T. )
    
    oModel:GetModel('ZZADETAIL'):SetOptional( .T. )

    
oModel:SetRelation('ZZNDETAIL', { { 'ZZN_ITEMCT', 'CTD_ITEM',  } }, ZZN->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZZNDETAIL'):SetUniqueLine({"ZZN_FILIAL","ZZN_GRUPO"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('ZZMDETAIL', { { 'ZZM_ITEMCT', 'CTD_ITEM' } }, ZZM->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZZMDETAIL'):SetUniqueLine({"ZZM_FILIAL","ZZM_GRUPO"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
 
    //Setando as descrições
    oModel:SetDescription("Gestao de Contratos")
    oModel:GetModel('CTDMASTER'):SetDescription('Contrato')
    oModel:GetModel('ZZNDETAIL'):SetDescription('Custos - Planejado')
    oModel:GetModel('ZZMDETAIL'):SetDescription('Custos - Vendido')
	oModel:GetModel('ZZADETAIL'):SetDescription('Custos Complementares')
	
Return oModel

Static Function COMP011POS( oModel )
	
 	/*
 //***************************** OUTROS CUSTOS PLANEJADO **********************************
	nCusto_CTD := oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' )
	nCusto_CTD2 := oModel:GetValue( 'CTDMASTER', 'CTD_XCUPRP' )
	nCusto_CTD3 := oModel:GetValue( 'CTDMASTER', 'CTD_XCUPRR' )
	
	//***************************** Item Conta ***************************************
	
	For nI200 := 1 To oModelSZC:Length()
		oModelSZC:GoLine( nI200 )
		nITEMIC		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
		oModelSZC:SetValue('ZC_ITEMIC', nITEMIC )

		For nI201 := 1 To oModelSZD:Length()
			oModelSZD:GoLine( nI201 )

			if oModel:GetValue( 'SZDDETAIL', 'ZD_TOTALR' ) > 0
				oModelSZD:SetValue('ZD_ITEMIC', nITEMIC )
			endif

			For nI202 := 1 To oModelSZO:Length()
				oModelSZO:GoLine( nI202 )

				if oModel:GetValue( 'SZODETAIL', 'ZO_TOTALR' ) > 0
				
					oModelSZO:SetValue('ZO_ITEMIC', nITEMIC )
				endif

				For nI203 := 1 To oModelSZU:Length()
					oModelSZU:GoLine( nI203 )
					if oModel:GetValue( 'SZUDETAIL', 'ZU_TOTALR' ) > 0
						oModelSZU:SetValue('ZU_ITEMIC', nITEMIC )
					endif

			   	Next nI203

		   	Next nI202

	   	Next nI201

	Next nI200
	
	
	Begin Transaction
	
	For nI218 := 1 To oModelSZC:Length()
		oModelSZC:GoLine( nI218 )
		zCPRDVD += oModel:GetValue( 'SZCDETAIL', 'ZC_TOTALR' )
	Next nI218
	
	if zCPRDVD > (nXCUSTOVD + nXVBAD)
		msginfo ("Aviso: Planejamento realizado supera verba (Custo de Produção Vendido), solicite verba adicional. "  )
		//+ cValtoChar(nXCUSTOVD) + "  " + cValtoChar(zCPRDVD)
		DisarmTransaction()
		//Break
		lRet := .F.
	ENDIF
			
	End Transaction
	*/

	//FwModelActive( oModel, .T. )
	//EndIf	
	/*
	nSZCTot1 := 0
	nSZCTot2 := 0
	*/
Return lRet


/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView     	:= Nil
    Local oModel        := FWLoadModel('zMVC2PX')
    Local oStPai        := FWFormStruct(2, 'CTD')
    Local oStFilho  	:= FWFormStruct(2, 'ZZN')
    Local oStFilho6  	:= FWFormStruct(2, 'ZZM')
    Local oStFilho31  	:= FWFormStruct(2, 'ZZA')
   
    Local aStruCTD  	:= CTD->(DbStruct())

    Local aStruZZN  	:= ZZN->(DbStruct())
    Local aStruZZM  	:= ZZM->(DbStruct())
    Local aStruZZA  	:= ZZA->(DbStruct())

	
    Local cConsCTD  := "CTD_ITEM;CTD_XTIPO;CTD_XEQUIP;CTD_XCLIEN;CTD_XNREDU;CTD_XDESC;CTD_XVDCID;CTD_XVDSID;CTD_NPROP;CTD_DTEXIS;CTD_DTEXSF;CTD_XCVP;CTD_XPCONT;CTD_XCUSFI;CTD_XFIANC;CTD_XPROVG;CTD_XROYAL;CTD_XPCOM;CTD_XMKPIN;CTD_XAPV;CTD_XIDPM;CTD_XNOMPM;CTD_XDAPCT;CTD_XDTAVC;CTD_XDTAVR;CTD_XDTFAP;CTD_XDTFAR;CTD_XDTEVC;CTD_XDTEVR;CTD_XDTCOC;CTD_XDTCOP;CTD_XDTWK"
    Local cConsZZN  := "ZZN_GRUPO;ZZN_GRUPO;ZZN_QUANT;ZZN_VUNIT;ZZN_TOTAL;ZZN_NPROP;ZZN_ITEMCT"
    Local cConsZZM  := "ZZM_GRUPO;ZZM_GRUPO;ZZM_QUANT;ZZM_VUNIT;ZZM_TOTAL;ZZM_NPROP;ZZM_ITEMCT"
    Local cConsZZA  := "ZZA_FILIAL;ZZA_NUM;ZZA_DATA;ZZA_TIPO;ZZA_DESCR;ZZA_VALOR;ZZA_ITEMIC"
    Local nAtual        := 0
     
    //Criando a View
	 
    oView := FWFormView():New()
    
    oView:SetModel(oModel)
   
    //Adicionando os campos do cabeçalho e o grid dos filhos
    
    oView:AddField('VIEW_CTD3',oStPai,'CTDMASTER')
    
    oView:AddGrid('VIEW_ZZN',oStFilho,'ZZNDETAIL')
    oView:AddGrid('VIEW_ZZM',oStFilho6,'ZZMDETAIL')
    oView:AddGrid('VIEW_ZZA',oStFilho31,'ZZADETAIL')

	
    //Setando o dimensionamento de tamanho
     
    oView:CreateFolder( 'FOLDER1')
    oView:AddSheet('FOLDER1','SHEET9','Resumo')
    oView:AddSheet('FOLDER1','SHEET1','Planejado / Revisado')
    oView:AddSheet('FOLDER1','SHEET4','Vendido') 
	oView:AddSheet('FOLDER1','SHEET22','Custos Diversos 2')
	//oView:AddSheet('FOLDER1','SHEET5','Contas a Receber')
	
	
	oView:CreateHorizontalBox('CABEC3',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
		
	oView:CreateHorizontalBox('GRID2A',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	
	oView:CreateHorizontalBox('GRID7',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido

	oView:CreateHorizontalBox('GRID22',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
 

   	//------------------------------------------------------------------------------------------

	     
    //Amarrando a view com as box
        
    oView:SetOwnerView('VIEW_CTD3','CABEC3')
    oView:SetOwnerView('VIEW_ZZN','GRID2A')
    oView:SetOwnerView('VIEW_ZZM','GRID7')
    oView:SetOwnerView('VIEW_ZZA','GRID22')
    
    /*	
	oView:SetNoUpdateLine('VIEW_SZF')
	oView:SetNoDeleteLine('VIEW_SZF')
	oView:SetNoInsertLine('VIEW_SZF')
	oView:SetViewProperty('VIEW_SZF' , 'ONLYVIEW' )
	oView:SetViewProperty('VIEW_SZF', "ENABLEDCOPYLINE",  {VK_F12} )
	*/
	
    //Habilitando título

    oView:EnableTitleView('VIEW_ZZN','Planejamento')
    oView:EnableTitleView('VIEW_ZZM','Vendido')
    oView:EnableTitleView('VIEW_ZZA','(Empenhado) Custos Complementares' )
	  
	// Criando botao
	//oView:AddUserButton( 'Copia Vend. p/ Planej.', 'CLIPS', {|oView| COMP021BUT()} )  
	//oView:Refresh()  
	  
    //Percorrendo a estrutura da CTD
    For nAtual := 1 To Len(aStruCTD)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruCTD[nAtual][01]) $ cConsCTD
            oStPai:RemoveField(aStruCTD[nAtual][01])
        EndIf
    Next
    

    //Percorrendo a estrutura da ZZN
    For nAtual := 1 To Len(aStruZZN)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZN[nAtual][01]) $ cConsZZN
            oStFilho:RemoveField(aStruZZN[nAtual][01])
        EndIf
    Next
      
    //Percorrendo a estrutura da ZZM
    For nAtual := 1 To Len(aStruZZM)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZM[nAtual][01]) $ cConsZZM
            oStFilho6:RemoveField(aStruZZM[nAtual][01])
        EndIf
    Next
         
       
    //Percorrendo a estrutura da ZZA
    For nAtual := 1 To Len(aStruZZA)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZA[nAtual][01]) $ cConsZZA
            oStFilho31:RemoveField(aStruZZA[nAtual][01])
        EndIf
    Next
    
    oView:SetCloseOnOk({||.F.})
Return oView
//-------------------------------------------------------------------

Static Function COMP021BUT( oModel )
//Local nOperation 	:= oModel:GetOperation() 
	
	/*
	Local oStNeto   	:= FWFormStruct(1, 'SZD')
	Local oModelCTD   	:= oModel:GetModel( 'CTDMASTER' )
	Local oModelSZC   	:= oModel:GetModel( 'SZCDETAIL' )
	Local oModelSZD   	:= oModel:GetModel( 'SZDDETAIL' ) 
	Local lRet 			:= .T.
	Local nI				:= 0
	Local nI2				:= 0
	
	Local oStNeto2   	:= FWFormStruct(1, 'SZG')
	Local oStFilho   	:= FWFormStruct(1, 'SZC')
	Local oModelSZF   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZP  	:= oModel:GetModel( 'SZPDETAIL' )
	Local oModelSZO  	:= oModel:GetModel( 'SZODETAIL' )
	Local oModelSZG   	:= oModel:GetModel( 'SZGDETAIL' ) 
	Local oModelSZU   	:= oModel:GetModel( 'SZUDETAIL' ) 
	
	Local nI3			:= 0
	Local nI4			:= 0
	
	
	Local nQuantSZC		:= oModel:GetValue( 'SZCDETAIL', 'ZC_QUANT' )
	Local nTotalZC 		:= oModel:GetValue( 'SZCDETAIL', 'ZC_TOTAL' )
	Local nTotalZD		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTAL' )
	Local cIDPlanSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_IDPLAN' )
	Local cIDPlanSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLAN' )
	Local nTotalZDF 	:= 0
	
	Local nQuantSZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )
	Local nTotalZF 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
	
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0
		
	 
	Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local cXCVP		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCVP' )
	
	
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
	
	Local nTotalSZF_SZM := 0
	Local nTotalVendido := 0
	Local nMargemBrutaV := 0
	Local nMargemContrV := 0
	
	Local nTotalSZC_RES	:= 0
	
	Local nTotalSZC_SZJ := 0

	Local nTotalPlanej	:= 0
	Local nMargemBrutaP := 0
	Local nMargemContrP := 0
	
	Local nMargemBrutaR := 0
	Local nMargemContrR := 0
	Local nTotalSD1_RES := 0

	Local nITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local nLen 			:= 0
	Local nLen2 		:= 0
	

	
	
	Local cIDPlan_CVPSZC		:= 0
	Local cIDPlan_CVPSZD		:= 0
	
	Local nI44 			:= 0
	Local nI62 			:= 0
	Local nI45 			:= 0
	Local nI63 			:= 0
	Local nI64 			:= 0
	Local nI65 			:= 0
	
	Local cDescri_CVPSZF		:= ""	
	Local cQuant_CVPSZF := 0
	Local cUnit_CVPSZF	:= 0
	Local cTotal_CVPSZF := 0
	
	Local cDescri_CVPSZG		:= ""
	Local cQuant_CVPSZG := 0
	Local cUnit_CVPSZG 	:= 0
	Local cTotal_CVPSZG	:= 0
	
	Local cDescri_CVPSZP := ""
	Local cQuant_CVPSZP	:= 0
	Local cUnit_CVPSZP	:= 0
	Local cTotal_CVPSZP	:= 0
	
	Local cDescri_CVPSZT := ""
	Local cQuant_CVPSZT	:= 0
	Local cUnit_CVPSZT	:= 0
	Local cTotal_CVPSZT	:= 0
	
	Local nTotalZCrev	:= 0
	Local nTotalZCFrev	:= 0
	Local nTotalZOrev	:= 0
	
	Local nICN1 		:= 0 
	Local nICN2 		:= 0 
	Local nICN3 		:= 0 
	Local nICN4 		:= 0
	
	Local nCVSZC_T 		:= 0
	Local nCVSZC_T2		:= 0
	Local nCVSZD_T 		:= 0
	Local nCVSZD_T2 	:= 0
	Local nCVSZD_T3 	:= 0
	Local nCVSZD_T4 	:= 0
	Local nCVSZO_T 		:= 0
	Local nCVSZO_T2		:= 0
	Local nCVSZU_T 		:= 0
	Local nCVSZU_T2 		:= 0
	
	Local nCVSZC_Q 		:= 0
	Local nCVSZD_Q 		:= 0
	Local nCVSZO_Q 		:= 0
	Local nCVSZU_Q 		:= 0
		
	//endif
	nLen := 0

	//
	
	//msginfo (cValtoChar(nCVSZD_T4))
	
	
	
	oModelSZF:GoLine( 1 )
	cDescri_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_DESCRI' )
	
	
	
	if cXCVP = "0" .OR.  EMPTY(cXCVP) 
	
	For nI44 := 1 To oModelSZF:Length()
			
		oModelSZF:GoLine( nI44 )
		cDescri_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_DESCRI' )
		cQuant_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )
		cUnit_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_UNIT' )
		cTotal_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
			
		if ! Empty(cDescri_CVPSZF)
			oModelSZC:AddLine()
		endif
		
		oModelSZC:GoLine( nI44 )
		oModelSZC:SetValue('ZC_DESCRI', cDescri_CVPSZF )		
		oModelSZC:SetValue('ZC_QUANTR', cQuant_CVPSZF )
		oModelSZC:SetValue('ZC_UNITR', cUnit_CVPSZF )
		oModelSZC:SetValue('ZC_TOTALR', cTotal_CVPSZF )
					
		cIDPlan_CVPSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_IDPLAN' )
		//msginfo ( cDescri_CVPSZF ) 

		For nI62	:= 1 To oModelSZG:Length()
			
			oModelSZG:GoLine( nI62 )
			cDescri_CVPSZG 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_DESCRI' )
			cQuant_CVPSZG 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
			cUnit_CVPSZG 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_UNIT' )
			cTotal_CVPSZG 	:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )

			if ! Empty(cIDPlan_CVPSZC)
				oModelSZD:AddLine()
			endif

			oModelSZD:GoLine( nI62 )
			oModelSZD:SetValue('ZD_DESCRI', cDescri_CVPSZG )
			oModelSZD:SetValue('ZD_QUANTR', cQuant_CVPSZG )
			oModelSZD:SetValue('ZD_UNITR', cUnit_CVPSZG )
			oModelSZD:SetValue('ZD_TOTALR', cTotal_CVPSZG )
			cIDPlan_CVPSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLSUB' )
			
			For nI64	:= 1 To oModelSZP:Length()
			
				oModelSZP:GoLine( nI64 )
				cDescri_CVPSZP 	:= oModel:GetValue( 'SZPDETAIL', 'ZP_DESCRI' )
				cQuant_CVPSZP 	:= oModel:GetValue( 'SZPDETAIL', 'ZP_QUANT' )
				cUnit_CVPSZP 	:= oModel:GetValue( 'SZPDETAIL', 'ZP_UNIT' )
				cTotal_CVPSZP 	:= oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' )
	
				
				oModelSZO:GoLine( nI64 )
				oModelSZO:SetValue('ZO_DESCRI', cDescri_CVPSZP )
				oModelSZO:SetValue('ZO_QUANTR', cQuant_CVPSZP )
				oModelSZO:SetValue('ZO_UNITR', cUnit_CVPSZP )
				oModelSZO:SetValue('ZO_TOTALR', cTotal_CVPSZP )
				
				For nI65	:= 1 To oModelSZP:Length()
			
					oModelSZP:GoLine( nI65 )
					cDescri_CVPSZT 	:= oModel:GetValue( 'SZTDETAIL', 'ZT_DESCRI' )
					cQuant_CVPSZT 	:= oModel:GetValue( 'SZTDETAIL', 'ZT_QUANT' )
					cUnit_CVPSZT 	:= oModel:GetValue( 'SZTDETAIL', 'ZT_UNIT' )
					cTotal_CVPSZT 	:= oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' )

					oModelSZO:GoLine( nI65 )
					oModelSZU:SetValue('ZU_DESCRI', cDescri_CVPSZT )
					oModelSZU:SetValue('ZU_QUANTR', cQuant_CVPSZT )
					oModelSZU:SetValue('ZU_UNITR', cUnit_CVPSZT )
					oModelSZU:SetValue('ZU_TOTALR', cTotal_CVPSZT )
						
				Next nI65
						
			Next nI64
			
		Next nI62
					
	Next nI44	
		
	msginfo ( "Transferencia Custo Vendido para Planejado realizado com sucesso." )
	oModelCTD:SetValue('CTD_XCVP', '1' )
	end if 
	
	*/
		
Return lRet

User Function zMVC2Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",   "Aberto"  })      
    AADD(aLegenda,{"BR_CINZA",   "Fechado"})
     
    BrwLegenda("Gestao de Contratos", "Status", aLegenda)
Return


/*
Static Function ViewDef()
Local oView
Local oModel := ModelDef()

oView := FWFormView():New()

oView:SetModel(oModel)

Return oView
*/
