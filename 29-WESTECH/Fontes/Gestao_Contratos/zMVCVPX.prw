//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Variáveis Estáticas
Static cTitulo := "Gestao de Contratos - Ativos"
 
/*/ zMVCVPX
    @return Nil, Função não tem retorno
    @example
    u_zMVCVPX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function zMVCVPX()
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
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'zMVC03Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCVPX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
//////////////////////////////////////////////////////////////////////////////
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'CTD')
    Local oStFilho  	:= FWFormStruct(1, 'SZC')
    Local oStNeto   	:= FWFormStruct(1, 'SZD')
    Local oStNeto3   	:= FWFormStruct(1, 'SZO')
    Local oStNeto6   	:= FWFormStruct(1, 'SZU')
        
    Local oStFilho6 	:= FWFormStruct(1, 'SZF')
    Local oStNeto2   	:= FWFormStruct(1, 'SZG')
    Local oStNeto4   	:= FWFormStruct(1, 'SZP')
    Local oStNeto5   	:= FWFormStruct(1, 'SZT')
    
    Local oStFilho31 	:= FWFormStruct(1, 'ZZA')
    
    Local aSZCRel       := {}
    Local aSZDRel       := {}
    Local aSZFRel       := {}
    Local aSZGRel       := {}
    Local aSZORel       := {}
    Local aSZPRel       := {}
    Local aSZTRel       := {}
    Local aZZARel       := {}
    Local aSZURel       := {}
    

    //Criando o modelo e os relacionamentos
     //oModel := MPFormModel():New('zMVCVPXM',  , { |oMdl| COMP011POS( oMdl ) })
     oModel := MPFormModel():New('zMVCVPXM', , { |oMdl| COMP011POS( oMdl )})
     //oModel := MPFormModel():New('zMVCVPXM', { |oMdl| COMP021BUT( oMdl ) } , { |oMdl| COMP011POS( oMdl )})	
       
    oModel:AddFields('CTDMASTER',/*cOwner*/,oStPai)
    
    oModel:AddGrid('SZCDETAIL','CTDMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
    oModel:AddGrid('SZFDETAIL','CTDMASTER',oStFilho6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	
	oModel:AddGrid('ZZADETAIL','CTDMASTER',oStFilho31,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZADETAIL', { { 'ZZA_ITEMIC', 'CTD_ITEM' } }, ZZA->(IndexKey(1)) )

	
  //cOwner é para quem pertence
    oModel:AddGrid('SZDDETAIL','SZCDETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZDDETAIL', { { 'ZD_IDPLAN', 'ZC_IDPLAN' } , { 'ZD_ITEMIC', 'ZC_ITEMIC' } }, SZD->(IndexKey(1)) )
	
    //oModel:AddGrid('SZGDETAIL','SZFDETAIL',oStNeto2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    //oModel:SetRelation('SZGDETAIL', { { 'ZG_IDVEND', 'ZF_IDVEND' } , { 'ZG_NPROP' , 'ZF_NPROP'}  }, SZG->(IndexKey(1)) )
    
    oModel:AddGrid('SZODETAIL','SZDDETAIL',oStNeto3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZODETAIL', { { 'ZO_IDPLSUB', 'ZD_IDPLSUB' } , { 'ZO_ITEMIC', 'ZD_ITEMIC' } }, SZO->(IndexKey(1)) )
    
   
    //oModel:AddGrid('SZPDETAIL','SZGDETAIL',oStNeto4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    //oModel:SetRelation('SZPDETAIL', { { 'ZP_IDVDSUB', 'ZG_IDVDSUB' } , {'ZP_NPROP', 'ZG_NPROP'}  }, SZP->(IndexKey(1)) )
    
    //oModel:AddGrid('SZTDETAIL','SZPDETAIL',oStNeto5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    //oModel:SetRelation('SZTDETAIL', { { 'ZT_IDVDSB2', 'ZP_IDVDSB2' } , {'ZT_NPROP', 'ZP_NPROP'} }, SZT->(IndexKey(1)) )
    
    oModel:AddGrid('SZUDETAIL','SZODETAIL',oStNeto6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZUDETAIL', { { 'ZU_IDPLSB2', 'ZO_IDPLSB2' } , { 'ZU_ITEMIC', 'ZO_ITEMIC' } }, SZU->(IndexKey(1)) )   
    
    oModel:AddGrid('SZGDETAIL','SZFDETAIL',oStNeto2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner Ã© para quem pertence
    oModel:SetRelation('SZGDETAIL', {  {'ZG_ITEMIC', 'CTD_ITEM'} ,{'ZG_NPROP', 'CTD_NPROP'},{ 'ZG_IDVEND', 'ZF_IDVEND' }  }, SZG->(IndexKey(1)) )
    //oModel:SetRelation('SZGDETAIL', {  }, SZG->(IndexKey(1)) )

    oModel:AddGrid('SZPDETAIL','SZGDETAIL',oStNeto4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner Ã© para quem pertence
    oModel:SetRelation('SZPDETAIL', { { 'ZP_IDVDSUB', 'ZG_IDVDSUB' } ,{'ZP_ITEMIC', 'CTD_ITEM'} ,{'ZP_NPROP', 'CTD_NPROP'}   }, SZP->(IndexKey(1)) )
    //oModel:SetRelation('SZPDETAIL', { {'ZP_NPROP', 'ZG_NPROP'}  }, SZP->(IndexKey(1)) )

    oModel:AddGrid('SZTDETAIL','SZPDETAIL',oStNeto5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner Ã© para quem pertence
    oModel:SetRelation('SZTDETAIL', { { 'ZT_IDVDSB2', 'ZP_IDVDSB2' } ,{'ZT_ITEMIC', 'CTD_ITEM'} , {'ZT_NPROP', 'CTD_NPROP'}  }, SZT->(IndexKey(1)) )
    //oModel:SetRelation('SZTDETAIL', {  {'ZT_NPROP', 'ZP_NPROP'} }, SZT->(IndexKey(1)) )
    
      
    //Fazendo o relacionamento entre o Pai e Filho
	

    aAdd(aSZCRel, {'ZC_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZCRel, {'ZC_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZFRel, {'ZF_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZFRel, {'ZF_ITEMIC',  'CTD_ITEM'})
     
  
    aAdd(aZZARel, {'ZZA_FILIAL', 'CTD_FILIAL'} )
    aAdd(aZZARel, {'ZZA_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZDRel, {'ZD_IDPLAN', 'ZC_IDPLAN'}) 
    aAdd(aSZDRel, {'ZD_ITEMIC', 'ZC_ITEMIC'}) 
    
    //aAdd(aSZGRel, {'ZG_FILIAL', 'ZF_FILIAL'} )
    //aAdd(aSZGRel, {'ZG_IDVEND', 'ZF_IDVEND'}) 
    //aAdd(aSZGRel, {'ZG_NPROP', 'ZF_NPROP'} )
    
    aAdd(aSZORel, {'ZO_FILIAL', 'ZD_FILIAL'} )
    aAdd(aSZORel, {'ZO_IDPLSUB', 'ZD_IDPLSUB'})
    aAdd(aSZORel, {'ZO_ITEMIC', 'ZD_ITEMIC'}) 

	  
    //aAdd(aSZPRel, {'ZP_IDVDSUB', 'ZG_IDVDSUB'}) 
    //aAdd(aSZPRel, {'ZP_NPROP', 'CTD_NPROP'})
    
    //aAdd(aSZTRel, {'ZT_FILIAL', 'ZP_FILIAL'} )
    //aAdd(aSZTRel, {'ZT_IDVDSB2', 'ZP_IDVDSB2'})
    //aAdd(aSZTRel, {'ZT_NPROP', 'CTD_NPROP'})
    
    aAdd(aSZURel, {'ZU_FILIAL', 'ZO_FILIAL'} )
    aAdd(aSZURel, {'ZU_IDPLSB2', 'ZO_IDPLSB2'})
    aAdd(aSZURel, {'ZU_ITEMIC', 'ZO_ITEMIC'}) 
    
    aAdd(aSZFRel, {'ZF_FILIAL', 'Z9_FILIAL'} )
    aAdd(aSZGRel, {'ZF_ITEMIC', 'CTD_ITEM'} )
    aAdd(aSZFRel, {'ZF_NPROP',  'CTD_NPROP'})

    //aAdd(aSZJRel, {'ZJ_FILIAL', 'Z9_FILIAL'} )
    //aAdd(aSZJRel, {'ZJ_NPROP',  'CTD_NPROP'})

    //aAdd(aSZGRel, {'ZG_FILIAL', 'ZF_FILIAL'} )
    
    aAdd(aSZGRel, {'ZG_ITEMIC', 'CTD_ITEM'} )
    aAdd(aSZGRel, {'ZG_NPROP', 'CTD_NPROP'} )  
	aAdd(aSZGRel, {'ZG_IDVEND', 'ZF_IDVEND'} )     

   // aAdd(aSZPRel, {'ZP_FILIAL', 'ZG_FILIAL'} )
    aAdd(aSZPRel, {'ZP_IDVDSUB', 'ZG_IDVDSUB'})
    aAdd(aSZGRel, {'ZP_ITEMIC', 'CTD_ITEM'} )
    aAdd(aSZPRel, {'ZP_NPROP', 'CTD_NPROP'})
   

    //aAdd(aSZTRel, {'ZT_FILIAL', 'ZP_FILIAL'} )
    aAdd(aSZTRel, {'ZT_IDVDSB2', 'ZP_IDVDSB2'})  
    aAdd(aSZGRel, {'ZT_ITEMIC', 'CTD_ITEM'} )
    aAdd(aSZTRel, {'ZT_NPROP', 'CTD_NPROP'}) 
    
    
    oModel:GetModel('SZCDETAIL'):SetOptional( .T. )
    
    //oModel:GetModel('CT4DETAILD'):SetOptional( .T. )
 
    oModel:GetModel('SZFDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZDDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZGDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZODETAIL'):SetOptional( .T. )
	oModel:GetModel('SZPDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZTDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZUDETAIL'):SetOptional( .T. )
    oModel:GetModel('ZZADETAIL'):SetOptional( .T. )

    
oModel:SetRelation('SZCDETAIL', { { 'ZC_ITEMIC', 'CTD_ITEM',  } }, SZC->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZCDETAIL'):SetUniqueLine({"ZC_FILIAL","ZC_IDPLAN"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZFDETAIL', { { 'ZF_ITEMIC', 'CTD_ITEM' } }, SZF->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZFDETAIL'):SetUniqueLine({"ZF_FILIAL","ZF_IDVEND"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
 
//oModel:SetRelation('SZMDETAIL', { { 'ZM_ITEMIC', 'CTD_ITEM' } }, SZM->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZMDETAIL'):SetUniqueLine({"ZM_FILIAL","ZM_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
 

oModel:SetRelation('SZDDETAIL', { { 'ZD_IDPLAN', 'ZC_IDPLAN' } }, SZD->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZDDETAIL'):SetUniqueLine({"ZD_IDPLSUB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZODETAIL', { { 'ZO_IDPLSUB', 'ZD_IDPLSUB' } }, SZO->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZODETAIL'):SetUniqueLine({"ZO_IDPLSB2"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    
oModel:SetRelation('SZGDETAIL', { { 'ZG_IDVEND', 'ZF_IDVEND' } }, SZG->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZGDETAIL'):SetUniqueLine({"ZG_IDVDSUB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
  

    //Setando as descrições
    oModel:SetDescription("Gestao de Contratos")
    oModel:GetModel('CTDMASTER'):SetDescription('Contrato')
    oModel:GetModel('SZCDETAIL'):SetDescription('Custos - Planejado')
    oModel:GetModel('SZFDETAIL'):SetDescription('Custos - Vendido')
    
    
    oModel:GetModel('SZDDETAIL'):SetDescription('Destalhes Custos Planejado')
    oModel:GetModel('SZGDETAIL'):SetDescription('Destalhes Custos Vendido')
	oModel:GetModel('SZODETAIL'):SetDescription('Nivel 3 - Detalhes Planejado / Revisado')
	oModel:GetModel('SZPDETAIL'):SetDescription('Nivel 3 - Detalhes Vendido')
	oModel:GetModel('SZTDETAIL'):SetDescription('Nivel 4 - Detalhes Vendido')
	oModel:GetModel('ZZADETAIL'):SetDescription('Custos Complementares')
	oModel:GetModel('SZUDETAIL'):SetDescription('Nivel 4 - Detalhes Planejado / Revisado')
	

    //Adicionando totalizadores
   // oModel:AddCalc('TOT_SALDO', 'SB1DETAIL', 'SB2DETAIL', 'B2_QATU', 'XX_TOTAL', 'SUM', , , "Saldo Total:" )

Return oModel

Static Function COMP011POS( oModel )
	//Local nOperation 	:= oModel:GetOperation() 

	Local oStNeto   	:= FWFormStruct(1, 'SZD')
	Local oModelCTD   	:= oModel:GetModel( 'CTDMASTER' )
	Local oModelSZC   	:= oModel:GetModel( 'SZCDETAIL' )
	Local oModelSZD   	:= oModel:GetModel( 'SZDDETAIL' ) 
	Local oModelSZF   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZG   	:= oModel:GetModel( 'SZGDETAIL' )
	 
	Local lRet 			:= .T.
		
	Local oStNeto2   	:= FWFormStruct(1, 'SZG')
	
	
	Local oModelSZF2   	:= oModel:GetModel( 'SZFDETAIL' )
	Local oModelSZN   	:= oModel:GetModel( 'SZNDETAIL' )
	
	Local oModelSZO   	:= oModel:GetModel( 'SZODETAIL' )
	Local oModelSZP   	:= oModel:GetModel( 'SZPDETAIL' )
	Local oModelSZT   	:= oModel:GetModel( 'SZTDETAIL' )
	Local oModelZZA   	:= oModel:GetModel( 'ZZADETAIL' )
	Local oModelSZU   	:= oModel:GetModel( 'SZUDETAIL' )
		
	Local nQuantSZC		:= oModel:GetValue( 'SZCDETAIL', 'ZC_QUANT' )
	Local nTotalZC 		:= oModel:GetValue( 'SZCDETAIL', 'ZC_TOTAL' )
	Local nTotalZD		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTAL' )
	Local cIDPlanSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_IDPLAN' )
	Local cIDPlanSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLAN' )
	Local cIDPlSUBSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLSUB' )
	Local cIDPlSUBSZO	:= oModel:GetValue( 'SZODETAIL', 'ZO_IDPLSUB' )
	Local cIDVDSUBSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVDSUB' )
	Local cIDVDSUBSZP	:= oModel:GetValue( 'SZPDETAIL', 'ZP_IDVDSUB' )
	Local nTotalZDF 	:= 0
	
	Local nQuantSZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_QUANT' )
	Local nQuantSZD		:= oModel:GetValue( 'SZDDETAIL', 'ZD_QUANT' )
	Local nQuantSZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_QUANT' )
	Local nTotalZO 		:= oModel:GetValue( 'SZODETAIL', 'ZO_TOTAL' )
	Local nTotalZP		:= oModel:GetValue( 'SZPDETAIL', 'ZP_TOTAL' )
	Local nTotalZF 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' )
	
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0
	
	Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local nXSISFV		:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFV' )
	Local nXITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local nXCUSTOVD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' )
	Local nXVBAD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVBAD' )
	Local nXCUTOTVD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCUTOT' )
	
	
	Local nXVDSICTD2		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIP' )
	Local nXSISFP			:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFP' )
	Local nXVDSICTD3		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIR' )
	Local nXSISFR			:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFR' )
	
	Local nCusto_CTD	:= oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' )
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
	Local nI30			:= 0
	Local nI31			:= 0
	Local nI32			:= 0
	Local nI33			:= 0
	Local nI34			:= 0
	Local nI35			:= 0
	Local nI36			:= 0
	Local nI37			:= 0
	Local nI38			:= 0
	Local nI39			:= 0
	Local nI40			:= 0
	Local nI41			:= 0
	Local nI42			:= 0
	Local nI43			:= 0
	Local nI44			:= 0
	Local nI45			:= 0
	Local nI46			:= 0
	Local nI47			:= 0
	Local nI48			:= 0
	Local nI49			:= 0
	Local nI50			:= 0
	Local nI51			:= 0
	Local nI52			:= 0
	Local nI53			:= 0
	Local nI54			:= 0
	Local nI55			:= 0
	Local nI56			:= 0
	Local nI57			:= 0
	Local nI58			:= 0
	Local nI59			:= 0
	Local nI60			:= 0
	Local nI61			:= 0
	Local nI62			:= 0
	Local nI63			:= 0
	Local nI100			:= 0
	Local nI101			:= 0
	Local nI102			:= 0
	Local nI103			:= 0 
	Local nI104			:= 0 
	Local nI105			:= 0
	Local nI210		:= 0
	Local nI211		:= 0
	Local nI212		:= 0
	Local nI213		:= 0
	Local nI214		:= 0
	Local nI215		:= 0
	Local nI216		:= 0
	Local nI217		:= 0
	Local nI218		:= 0

	Local nTotalZOF		:= 0
	Local nTotalZPF		:= 0 

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
	Local nTotalZFContig := 0
	
	Local nTotalZT		:= 0
	Local nTotalZTF		:= 0
	
	Local nTotalZU				:= 0
	Local nTotalZUF				:= 0
	Local nTotalSZFCON_VD 		:= 0
	Local nTotalSZFOCUS_RES_VD 	:= 0 	
	Local nTotalSZFCOM_RES_VD 	:= 0 	 
	Local nTotalSZFROY_RES_VD	:= 0
	Local nTotOCR_VD		 	:= 0 
	Local nTotalZFCOM_VD 		:= 0 
	Local nTotalZFContig_VD		:= 0
	Local nTotalZFOCUS_VD		:= 0
	Local nTotalZFCOM_VD2		:= 0	
	Local nTotalSZFCOM_RES_VD2	:= 0
	
	Local nTotalSZFCOMISSAO1	:= 0
	LocAL nTotalSZFCOMISSAO2	:= 0
	Local nTotalZFROY_VD		:= 0
	Local nVlrComZF				:= 0
	Local nVlrComZF_FIN			:= 0
	Local nVlrOCZF			:= 0
	Local nVlrOCZF_FIN		:= 0
	Local nVlrRoyZF 			:= 0
	Local nVlrRoyZF_FIN			:= 0
	
	Local nXCustoPro			:= 0 
	Local nVerbaRest			:= 0
	
	Local nTOTVSI_RES_ZF 		:= 0
	Local nTOTVSI_RES_FIN_ZF	:= 0
	Local nTOTVSI_RES			:= 0
	Local nTOTVSI_RES_FIN		:= 0
	Local nCCONT_RES 			:= 0
	Local nCCONT_RES_FIN		:= 0
	Local nVlrMargBR_ZF			:= 0
	
	Local nPerMargContr_ZF		:= 0
	Local nVlrMargContr_ZF		:= 0
	Local nPerMargBR_ZF			:= 0
	
	Local nTOTVSI_ZF			:= 0		
	Local nTOTVSI_FIN_ZF		:= 0
	
	Local cTipoOC				:= ""
	Local cTipoOC1				:= ""
	Local cTipoOC2				:= ""
	Local cTipoOC3				:= ""
	Local cTipoOC4				:= ""
	Local cTipoOC5				:= ""
	Local cTipoOC6				:= ""
	Local cTipoOC7				:= ""
	Local nTipoOC_CFI			:= ""
	Local nTipoOC_CTG			:= ""
	Local nTipoOC_FNC			:= ""
	Local nTipoOC_PGT			:= ""
	Local nTipoOC_PIP			:= ""
	Local nTipoOC_RTY			:= ""
	Local nTipoOC_COM			:= ""
	
	Local nVlrFIAZF				:= 0
	Local nVlrFIAZF_FIN			:= 0
	Local nVlrCFINZF			:= 0
	Local nVlrCFINZF_FIN		:= 0
	Local nVlrPIMPZF			:= 0
	Local nVlrPIMPZF_FIN		:= 0
	Local nVlrGARZF				:= 0
	Local nVlrGARZF_FIN			:= 0
	Local nCUT_Plan				:= 0
	Local nTOC_Plan				:= 0
	Local cDescri_CVP			:= ""
	Local nQuant_CVP			:= 0
	Local cUnid_CVP				:= ""
	Local nUnit_CVP				:= 0
	Local nTotal_CVP			:= 0
	Local cDescri_CVR			:= ""
	Local nLenSZF				:= 0
	Local nTotalZX				:= 0
	Local nTotalZXF				:= 0	
	Local nQuantSZV				:= 0	
	Local cIDRevSZV				:= 0
	Local cIDRevSZX				:= 0
	Local nPercentSZH2			:= 0
	Local nTotalSZH2			:= 0
	Local nTotalZV				:= 0
	Local nTotalSZV_RES			:= 0
	Local nTotalSZV_SZM			:= 0
	Local cTipoOC32				:= 0
	Local nTipoOC_COM2			:= 0
	Local nLen					:= 0
	
	Local nTipoOC_comRev		:= 0	
	Local cTipoOC_comRev		:= ""
	
	Local nXComRev				:= 0 
	
	Local nTotalZDrev			:= 0
	Local nTotalZOrev			:= 0
	Local nTotalZOFrev			:= 0
	Local nTotalZDFrev			:= 0
	Local nQuantSZCrev			:= 0
	Local nTotalZM				:= 0
	Local cXCVP		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCVP' )
	
	Local nIX					:= 0
	Local nIX1					:= 0
	
	Local nReceitaCT4R			:= 0
	Local nReceitaCT4			:= 0
	
	Local cTipoOCCTD			:= ""   
	
	Local nI201					:= 0 
	
	Local xt := 0
	
	Local nCusto30T	:= 0
	Local nCusto30R := 0
	
	
	Local nI16B			:= 0
	
	
	Local nTotalZZA 	:= 0
	Local nTotalZZA_RES := 0
	
	Local nTotalZUrev 	:= 0
	Local nTotalZUFrev 	:= 0
	
	Local nCusto_CTD2	:= 0
	Local nCusto_CTD3	:= 0
	
	Local nTotalZCcpp	:= 0	
	Local nTotalSZC_RESccp	:= 0      
	
	Local nITEMIC		:= ""
	
	Local nSZCTot1 := 0
	Local nSZCTot2 := 0
	
	Local nTotalZDrev2 := 0
	Local nTotalZDrev2b	:= 0
	Local nOperation := oModel:GetOperation()
	
	Local zCPRDVD		:= 0
	
	
	
	//// CUSTO PLANEJADO CONJUNTO
	For nI := 1 To oModelSZC:Length()
		oModelSZC:GoLine( nI )
		
		nTotalZDrev		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTALR' )
		
		For nI2 := 1 To oModelSZD:Length()
			oModelSZD:GoLine( nI2 ) 
			
				For nI63 := 1 To oModelSZO:Length()
					oModelSZO:GoLine( nI63 ) 
					
					
					For nI213 := 1 To oModelSZU:Length()
						oModelSZU:GoLine( nI213 ) 
						if nTotalZUF > 0
							oModelSZU:SetValue('ZU_ITEMIC', nXITEMCTA )
						endif
							   	
				   	Next nI213
				   	
				   	if nTotalZOF > 0
						oModelSZO:SetValue('ZO_ITEMIC', nXITEMCTA )
					endif	   	
			   	Next nI63
			   	
			   	nI63 := 0
			   
			   	For nI63 := 1 To oModelSZO:Length()
					oModelSZO:GoLine( nI63 ) 
							
					
					For nI214 := 1 To oModelSZU:Length()
						oModelSZU:GoLine( nI214 ) 
						
						nTotalZUrev		:= oModel:GetValue( 'SZUDETAIL', 'ZU_TOTALR' )	
						nTotalZUFrev += Round( nTotalZURev , 2 )
							   	
				   	Next nI214
				   	
				   	If nTotalZUFrev > 0
				   		oModelSZO:SetValue('ZO_UNITR', nTotalZUFrev )
				   		nTotalZUFrev := 0
				    Endif
				    
				    nTotalZOrev		:= oModel:GetValue( 'SZODETAIL', 'ZO_TOTALR' )	
					nTotalZOFrev += Round( nTotalZOrev , 2 )
		   	
			   	Next nI63
			  
			    If nTotalZOFrev > 0
			   		oModelSZD:SetValue('ZD_UNITR', nTotalZOFrev )
			   		nTotalZOFrev := 0
			    Endif
			
				nTotalZDrev		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTALR' )	
				nTotalZDFrev += Round( nTotalZDrev , 2 )
				
				if nTotalZDFrev > 0
					oModelSZD:SetValue('ZD_ITEMIC', nXITEMCTA )
				endif
	   	Next nI2
	   
	   
	    nQuantSZCrev	:= oModel:GetValue( 'SZCDETAIL', 'ZC_QUANTR' )
	   	oModelSZC:SetValue('ZC_UNITR', nTotalZDFrev )
	   	oModelSZC:SetValue('ZC_TOTALR', nTotalZDFrev*nQuantSZCrev )
	   	
	   	nTotalZDrev2 := nTotalZDFrev*nQuantSZCrev
	   	nTotalZDrev2b += nTotalZDrev2
	      	
		cIDPlanSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_IDPLAN' )
		cIDPlanSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLAN' )
		nTotalZDF 	:= 0
		nTotalZDFrev 	:= 0
		
	Next nI  	
	   	  
 	nTotalZDF 	:= 0
 	nTotalZDFrev := 0
 	
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
    Local oModel        := FWLoadModel('zMVCVPX')
    Local oStPai        := FWFormStruct(2, 'CTD')
    Local oStPai2       := FWFormStruct(2, 'CTD')
    Local oStPai4       := FWFormStruct(2, 'CTD')
    Local oStFilho  	:= FWFormStruct(2, 'SZC')
 
    Local oStFilho6  	:= FWFormStruct(2, 'SZF')
    Local oStNeto       := FWFormStruct(2, 'SZD')
    Local oStNeto2      := FWFormStruct(2, 'SZG')
    Local oStNeto3      := FWFormStruct(2, 'SZO')
    Local oStNeto4      := FWFormStruct(2, 'SZP')
    Local oStNeto5      := FWFormStruct(2, 'SZT')
    Local oStNeto6      := FWFormStruct(2, 'SZU')
    Local oStFilho31  	:= FWFormStruct(2, 'ZZA')
   
    Local aStruCTD  	:= CTD->(DbStruct())
    Local aStruCTD2  	:= CTD->(DbStruct())
    Local aStruCTD4  	:= CTD->(DbStruct())
        
    Local aStruSZC  	:= SZC->(DbStruct())
    Local aStruSZF  	:= SZF->(DbStruct())
    Local aStruSZD  	:= SZD->(DbStruct())
    Local aStruSZG  	:= SZG->(DbStruct())
    Local aStruSZO  	:= SZO->(DbStruct())
    Local aStruSZP  	:= SZP->(DbStruct())
    Local aStruSZT  	:= SZT->(DbStruct())
    Local aStruZZA  	:= ZZA->(DbStruct())
    Local aStruSZU  	:= SZU->(DbStruct())
	
    Local cConsCTD  := "CTD_ITEM;CTD_XTIPO;CTD_XEQUIP;CTD_XCLIEN;CTD_XNREDU;CTD_XDESC;CTD_XVDCID;CTD_XVDSID;CTD_NPROP;CTD_DTEXIS;CTD_DTEXSF;CTD_XCVP;CTD_XPCONT;CTD_XCUSFI;CTD_XFIANC;CTD_XPROVG;CTD_XROYAL;CTD_XPCOM;CTD_XMKPIN;CTD_XAPV;CTD_XIDPM;CTD_XNOMPM;CTD_XDAPCT;CTD_XDTAVC;CTD_XDTAVR;CTD_XDTFAP;CTD_XDTFAR;CTD_XDTEVC;CTD_XDTEVR;CTD_XDTCOC;CTD_XDTCOP;CTD_XDTWK"
    Local cConsCTD2  := "CTD_XCUSTO;CTD_XCUTOT;CTD_XCUPRP;CTD_XCUTOP;CTD_XCUPRR;CTD_XCUTOR"
    Local cConsCTD4  := "CTD_XVDCI;CTD_XVDSI;CTD_XVDCIP;CTD_XVDSIPP;CTD_XVDCIR;CTD_XVDSIR;CTD_XSISFV;CTD_XSISFP;CTD_XSISFR"
    
    Local cConsSZC  := "ZC_IDPLAN;ZC_ITEMIC;ZC_DESCRI;ZC_DTPL;ZC_DTRV;;ZC_QUANTR;ZC_UMR;ZC_UNITR;ZC_TOTALR"
    Local cConsSZF  := "ZF_IDVEND;ZF_ITEMIC;ZF_CODPROD;ZF_DESCRI;ZF_QUANT;ZF_UM;ZF_TOTAL;ZF_MKPINI;ZF_MKPFIN;ZF_UNITVSI;ZF_TOTVSI;ZF_UNITVCI;ZF_TOTVCI;ZF_VLRMKP;ZF_VLRMKPB;ZF_VLRCONT;ZF_CCONT;ZF_VLRPIMP;ZF_VLRFIAN;ZF_VLRCFIN;ZF_VLRGAR;ZF_VLRPVIN;ZF_VLROCUS;ZF_VLRROY;ZF_VLRCOM;ZF_VLRROY;ZF_CALC;ZF_OBS;ZF_NPROP,ZF_ITEMIC"
    Local cConsSZD  := "ZD_FILIAL;ZD_IDPLAN;ZD_IDPLSUB;ZD_ITEM;ZD_GRUPO;ZD_DESCRI;ZD_DTPL;ZD_DTRV;ZD_QUANTR;ZD_UMR;ZD_UNITR;ZD_TOTALR;ZD_ITEMIC"
    Local cConsSZG  := "ZG_FILIAL;ZG_IDVEND;ZG_IDVDSUB;ZG_ITEM;ZG_QUANT;ZG_CODPROD;ZG_DESCRI;ZG_QUANT;ZG_UNIT;ZG_UM;ZG_TOTAL; ZG_PVA;ZG_POC;ZG_PCONT;;ZG_CUSFIN;ZG_FIANCAS;ZG_PROVGR;ZG_PERDIMP;ZG_PROYALT;ZG_PCOMIS;ZG_PDESC;;ZG_PMKP;ZG_UNITVSI;ZG_TOTVSI;ZG_PVA;ZG_PPIS;ZG_PCOF;ZG_PICMS;ZG_PIPI;ZG_PISS;ZG_UNITVCI;ZG_TOTVCI;ZG_MKPFIN;ZG_VLRMKP;ZG_VLRPIS;ZG_VLRCOF;ZG_VLRICM;ZG_VLRIPI;ZG_VLRISS;ZG_VLRCONT;ZG_VLRCONT;ZG_CCONT;ZG_VLRMBRT;ZG_PMBRT;;ZG_VLRPVIN;ZG_VLRPIMP;ZG_VLRFIAN;ZG_VLRCFIN;ZG_VLRGAR;ZG_VLROCUS;ZG_VLRROY;ZG_VLRCOM;ZG_VLRDESC;ZG_VLRPSIP"
    Local cConsSZO  := "ZO_FILIAL;ZO_IDPLSUB;ZO_IDPLSB2;ZO_ITEM;ZO_DESCRI;ZO_DTRV;ZO_QUANTR;ZO_UMR;ZO_UNITR;ZO_TOTALR;ZO_TOTEMP;ZO_SALDO;ZO_ITEMIC;ZO_GRUPO;ZO_GRUSA"
    Local cConsSZU  := "ZU_FILIAL;ZU_IDPLSB3;ZU_IDPLSB2;ZU_ITEM;ZU_DESCRI;ZU_QUANTR;ZU_UMR;ZU_UNITR;ZU_TOTALR;ZU_ITEMIC;ZU_GRUPO;ZU_GRUSA"
    Local cConsSZP  := "ZP_FILIAL;ZP_IDVDSUB;ZP_IDVDSB2;ZP_ITEM;ZP_QUANT;ZP_CODPROD;ZP_DESCRI;ZP_UNIT;ZP_TOTAL;ZP_OBS;ZP_NPROP;ZP_GRUPO;ZP_GRUSA"
    Local cConsSZT  := "ZT_FILIAL;ZT_IDVDSB3;ZT_IDVDSB2;ZT_ITEM;ZT_QUANT;ZT_UM;ZT_CODPROD;ZT_DESCRI;ZT_UNIT;ZT_PESO;ZT_TOTAL;ZT_NPROP"
    Local cConsZZA  := "ZZA_FILIAL;ZZA_NUM;ZZA_DATA;ZZA_TIPO;ZZA_DESCR;ZZA_VALOR;ZZA_ITEMIC"
    Local nAtual        := 0
     
    //Criando a View
	 
    oView := FWFormView():New()
    
    oView:SetModel(oModel)
   
    //Adicionando os campos do cabeçalho e o grid dos filhos
    
    oView:AddField('VIEW_CTD3',oStPai,'CTDMASTER')
    oView:AddField('VIEW_CTD2',oStPai2,'CTDMASTER')
    oView:AddField('VIEW_CTD4',oStPai4,'CTDMASTER')
    
    oView:AddGrid('VIEW_SZC',oStFilho,'SZCDETAIL')
    oView:AddGrid('VIEW_SZF',oStFilho6,'SZFDETAIL')
    oView:AddGrid('VIEW_SZD',oStNeto,'SZDDETAIL')
    oView:AddGrid('VIEW_SZG',oStNeto2,'SZGDETAIL')
    oView:AddGrid('VIEW_SZO',oStNeto3,'SZODETAIL')
    oView:AddGrid('VIEW_SZP',oStNeto4,'SZPDETAIL')
    oView:AddGrid('VIEW_SZT',oStNeto5,'SZTDETAIL')
    oView:AddGrid('VIEW_ZZA',oStFilho31,'ZZADETAIL')
    oView:AddGrid('VIEW_SZU',oStNeto6,'SZUDETAIL')
	
    //Setando o dimensionamento de tamanho
     
    oView:CreateFolder( 'FOLDER1')
    oView:AddSheet('FOLDER1','SHEET9','Resumo')
    oView:AddSheet('FOLDER1','SHEET4','Vendido')
    oView:AddSheet('FOLDER1','SHEET1','Planejado / Revisado')
	oView:AddSheet('FOLDER1','SHEET22','Custos Diversos 2')
	//oView:AddSheet('FOLDER1','SHEET5','Contas a Receber')
	
	
		
	oView:CreateHorizontalBox('GRID2A',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2B',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2C',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2D',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
		
		
	oView:CreateHorizontalBox('CABEC3',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('CABEC2',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('CABEC4',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	//oView:CreateHorizontalBox('BOX56',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Resumo
	//oView:CreateHorizontalBox('BOXPP',0, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Proposta	
 
	oView:CreateHorizontalBox('GRID7',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
	oView:CreateVerticalBox('GRID7A',100, 'GRID7', /*lUsePixel*/, 'FOLDER1', 'SHEET4') 		// Nivel 1 - Vendido

    oView:CreateHorizontalBox('GRID8',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 2 - Vendido
	oView:CreateHorizontalBox('GRID19',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateVerticalBox('GRID19A',100,'GRID19', /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	
	oView:CreateHorizontalBox('GRID24',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateVerticalBox('GRID24B',100,'GRID24', /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido

 	oView:CreateHorizontalBox('GRID22',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID22A',50, 'GRID22', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID22B',50, 'GRID22', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
    oView:CreateHorizontalBox('GRID23',50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID23A',50, 'GRID23', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID23B',50, 'GRID23', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
      
   	//------------------------------------------------------------------------------------------

	     
    //Amarrando a view com as box
        
    oView:SetOwnerView('VIEW_CTD3','CABEC3')
    oView:SetOwnerView('VIEW_CTD2','CABEC2')
    oView:SetOwnerView('VIEW_CTD4','CABEC4')
    
    oView:SetOwnerView('VIEW_SZC','GRID2A')
    oView:SetOwnerView('VIEW_SZD','GRID2B')
    oView:SetOwnerView('VIEW_SZO','GRID2C')
    oView:SetOwnerView('VIEW_SZU','GRID2D')
    oView:SetOwnerView('VIEW_SZF','GRID7A')
    
    oView:SetOwnerView('VIEW_SZG','GRID8')
    oView:SetOwnerView('VIEW_SZP','GRID19A')
    oView:SetOwnerView('VIEW_SZT','GRID24B')
    oView:SetOwnerView('VIEW_ZZA','GRID22A')
    
    	
	oView:AddIncrementField('VIEW_SZD' , 'ZD_ITEM' ) 
	oView:AddIncrementField('VIEW_SZC' , 'ZC_ITEM' )
	oView:AddIncrementField('VIEW_SZO' , 'ZO_ITEM' )
	oView:AddIncrementField('VIEW_SZT' , 'ZT_ITEM' )
	oView:AddIncrementField('VIEW_SZU' , 'ZU_ITEM' )
	oView:SetViewProperty('VIEW_CTD3' , 'ONLYVIEW' )
	oView:SetViewProperty('VIEW_CTD2' , 'ONLYVIEW' )
	
		
	oView:SetNoUpdateLine('VIEW_SZF')
	oView:SetNoDeleteLine('VIEW_SZF')
	oView:SetNoInsertLine('VIEW_SZF')
	oView:SetViewProperty('VIEW_SZF' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SZG')
	oView:SetNoDeleteLine('VIEW_SZG')
	oView:SetNoInsertLine('VIEW_SZG')
	oView:SetViewProperty('VIEW_SZG' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SZP')
	oView:SetNoDeleteLine('VIEW_SZP')
	oView:SetNoInsertLine('VIEW_SZP')
	oView:SetViewProperty('VIEW_SZP' , 'ONLYVIEW' )
	oView:SetViewProperty('VIEW_SZF', "ENABLEDCOPYLINE",  {VK_F12} )
	  
    //Habilitando título
    oView:EnableTitleView('VIEW_CTD2','Totais Custos')
	oView:EnableTitleView('VIEW_CTD4','Totais Venda')
    oView:EnableTitleView('VIEW_SZF','Nivel 1 - Operacao Unitaria')
    oView:EnableTitleView('VIEW_SZG','Nivel 2 - Conjunto')
    oView:EnableTitleView('VIEW_SZP','Nivel 3 - Sub-Conjunto')
    oView:EnableTitleView('VIEW_SZT','Nivel 4 - Sub-Conjunto')
    
    
    oView:EnableTitleView('VIEW_SZC','Nivel 1 - Operacao Unitaria - Custo Planejado') 	// PLanejado 
    oView:EnableTitleView('VIEW_SZD','Nivel 2 - Conjunto - Revisado')					// PLanejado 
	//oView:EnableTitleView('VIEW_SZV','Nivel 1 - Operacao Unitaria - Custo Revisado') 	// Revisao 
	//oView:EnableTitleView('VIEW_SZX','Nivel 2 - Conjunto - Revisado')					// Revisao 
    oView:EnableTitleView('VIEW_SZO','Nivel 3 - Sub-Conjunto')						// PLanejado 
	oView:EnableTitleView('VIEW_SZU','Nivel 4 - Sub-Conjunto')						// PLanejado 
    oView:EnableTitleView('VIEW_SZF','Detalhes Custos Vendido')
    	
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
    
    For nAtual := 1 To Len(aStruCTD2)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruCTD2[nAtual][01]) $ cConsCTD2
            oStPai2:RemoveField(aStruCTD2[nAtual][01])
        EndIf
    Next
    
    For nAtual := 1 To Len(aStruCTD4)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruCTD4[nAtual][01]) $ cConsCTD4
            oStPai4:RemoveField(aStruCTD4[nAtual][01])
        EndIf
    Next
    
     
    //Percorrendo a estrutura da SZC
    For nAtual := 1 To Len(aStruSZC)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZC[nAtual][01]) $ cConsSZC
            oStFilho:RemoveField(aStruSZC[nAtual][01])
        EndIf
    Next
      
    //Percorrendo a estrutura da SZF
    For nAtual := 1 To Len(aStruSZF)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZF[nAtual][01]) $ cConsSZF
            oStFilho:RemoveField(aStruSZF[nAtual][01])
        EndIf
    Next
         
        
    //Percorrendo a estrutura da SZD
    For nAtual := 1 To Len(aStruSZD)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZD[nAtual][01]) $ cConsSZD
            oStNeto:RemoveField(aStruSZD[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SZG
    For nAtual := 1 To Len(aStruSZG)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZG[nAtual][01]) $ cConsSZG
            oStNeto:RemoveField(aStruSZG[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SDO
    For nAtual := 1 To Len(aStruSZO)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZO[nAtual][01]) $ cConsSZO
            oStNeto3:RemoveField(aStruSZO[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SZU
    For nAtual := 1 To Len(aStruSZU)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZU[nAtual][01]) $ cConsSZU
            oStNeto6:RemoveField(aStruSZU[nAtual][01])
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

//Static Function COMP021BUT( oModel )

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
		

	nLen := 0
	
	
	
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
		
//Return lRet

User Function zMVC03Leg()
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
