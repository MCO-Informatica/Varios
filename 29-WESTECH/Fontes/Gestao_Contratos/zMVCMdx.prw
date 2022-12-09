/*
// Para dado igual a
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "'000500'" } } )

// Para dado igual a um ou outro valor
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "'000500'" }, { 'ZA2_AUTOR', "'000600'",, MVC_LOADFILTER_OR } } )

// Para dado diferente
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "'000500'", MVC_LOADFILTER_NOT_EQUAL } } )

// Para dado maior que valor
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_VALOR', "0", MVC_LOADFILTER_GREATER } } )

// Para dado entre um valor e outro
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_VALOR', "0", MVC_LOADFILTER_GREATER_EQUAL }, { 'ZA2_VALOR', "100", MVC_LOADFILTER_LESS_EQUAL } } )

// Para dado que contém um valor
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "'0005'", MVC_LOADFILTER_CONTAINS } } )

// Para dado que está contido
oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "{'000500','000501'}", MVC_LOADFILTER_IS_CONTAINED } } )

// Usando uma expressão
oModel:GetModel( 'IDGRID' ):SetLoadFilter( , " ( ZA2_AUTOR >= '000500' .AND. ZA2_AUTOR < '000600' ) .OR. ZA2_VALOR > 0 " )

*/
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Variáveis Estáticas
Static cTitulo := "Gestao de Contratos - Ativos"
 
/*/ zMVCMdX
    @return Nil, Função não tem retorno
    @example
    u_zMVCMdX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function zMVCMdX()
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
    //ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'zMVC02Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
//////////////////////////////////////////////////////////////////////////////
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'CTD')
    Local oStFilho  	:= FWFormStruct(1, 'SZC')
    Local oStFilho30 := FWFormStruct(1, 'CT4')
    Local oStFilhoCV4 := FWFormStruct(1, 'CV4')
    //Local oStFilhoCT4D   := FWFormStruct(1, 'CT4')
    //Local oStFilhoCT4RC 	:= FWFormStruct(1, 'CT4')
    Local oStFilhoCT4RD 	:= FWFormStruct(1, 'CT4')
    Local oStFilhoCT4CM 	:= FWFormStruct(1, 'CT4')
    Local oStFilho13  	:= FWFormStruct(1, 'SZV') 
    Local oStNeto14  	:= FWFormStruct(1, 'SZX') 
    Local oStFilho2 	:= FWFormStruct(1, 'SC7', { |x| ALLTRIM(x) $ 'C7_FILIAL,C7_ITEMCTA, C7_XOC, C7_XIDFORN, C7_XDESCF,C7_ITEM, C7_PRODUTO, C7_DESCRI,C7_UM,C7_QUANT,C7_PRECO,C7_TOTAL,C7_XTOTSI,C7_ENCER' } )
    Local oStFilho3 	:= FWFormStruct(1, 'SE2')
    Local oStFilho3B 	:= FWFormStruct(1, 'SE2')
    
    Local oStFilho3C 	:= FWFormStruct(1, 'SE2')
    Local oStFilho3D 	:= FWFormStruct(1, 'SE2')
    Local oStFilho3E 	:= FWFormStruct(1, 'SE2')
    Local oStFilho3F 	:= FWFormStruct(1, 'SE2')
    //Local oStFilho3G 	:= FWFormStruct(1, 'SD1') //------
    Local oStFilho4 	:= FWFormStruct(1, 'SE1')
    Local oStFilho4B 	:= FWFormStruct(1, 'SE1')
    Local oStFilho4C 	:= FWFormStruct(1, 'SE1')
    Local oStFilho5 	:= FWFormStruct(1, 'SZ4')
    Local oStFilho6A 	:= FWFormStruct(1, 'SZ9')
    Local oStFilho6 	:= FWFormStruct(1, 'SZF')
    Local oStFilho7 	:= FWFormStruct(1, 'SZH')
    Local oStFilho8 	:= FWFormStruct(1, 'SZI')
    Local oStFilho9 	:= FWFormStruct(1, 'SZJ')
    Local oStFilho31 	:= FWFormStruct(1, 'ZZA')
    //Local oStFilho10 	:= FWFormStruct(1, 'SZM')
    Local oStFilho11 	:= FWFormStruct(1, 'SZN')
    Local oStFilho12 	:= FWFormStruct(1, 'SD1')
    Local oStFilho12B 	:= FWFormStruct(1, 'SD1')
    Local oStNeto   	:= FWFormStruct(1, 'SZD')
    Local oStNeto2   	:= FWFormStruct(1, 'SZG')
    Local oStNeto3   	:= FWFormStruct(1, 'SZO')
    Local oStNeto4   	:= FWFormStruct(1, 'SZP')
    Local oStNeto5   	:= FWFormStruct(1, 'SZT')
    Local oStNeto6   	:= FWFormStruct(1, 'SZU')
    //Local oStNeto6   	:= FWFormStruct(1, 'SZU')
    Local aSZCRel       := {}
    Local aCT4Rel30     := {}
    Local aCV4Rel     := {}
    //Local aCT4RelD       := {}
    //Local aCT4RelRC      := {}
    Local aCT4RelRD      := {}
    Local aCT4RelCM      := {}
    Local aSC7Rel       := {}
    Local aSE2Rel       := {}
    Local aSE2RelB      := {}
    Local aSE2RelC      := {}
    Local aSE2RelD      := {}
    Local aSE2RelE      := {}
    Local aSE2RelF      := {}
    //Local aSD1RelG      := {}
    Local aSE1Rel       := {}
    Local aSE1RelB      := {}
    Local aSE1RelC      := {}
    Local aSZ4Rel       := {}
    Local aSZDRel       := {}
    Local aSZFRel       := {}
    Local aSZGRel       := {}
    Local aSZHRel       := {}
    Local aSZIRel       := {}
    Local aSZJRel       := {}
    //Local aSZMRel       := {}
    Local aSZNRel       := {}
    Local aSD1Rel       := {}
    Local aSD1RelB      := {}
    Local aSZORel       := {}
    Local aSZPRel       := {}
    Local aSZ9Rel       := {}
    Local aSZTRel       := {}
    Local aSZVRel       := {}
    Local aSZXRel       := {}
    Local aZZARel       := {}
    Local aSZURel       := {}
    
	

        
    //Criando o modelo e os relacionamentos
     //oModel := MPFormModel():New('zMVCMdXM',  , { |oMdl| COMP011POS( oMdl ) })
     oModel := MPFormModel():New('zMVCMdXM', { |oMdl| COMP021BUT( oMdl ) } , { |oMdl| COMP011POS( oMdl ) })
    	
       
    oModel:AddFields('CTDMASTER',/*cOwner*/,oStPai)
    
    oModel:AddGrid('SZ9DETAIL','CTDMASTER',oStFilho6A,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZ9DETAIL', { { 'Z9_NPROP', 'CTD_NPROP' } }, SZ9->(IndexKey(1)) )
	
	//oModel:AddGrid('CT4DETAILCC','CTDMASTER',oStFilhoCT4CC,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'CT4DETAILCC' ):SetLoadFilter( { { 'CT4_CONTA', "500000000", MVC_LOADFILTER_GREATER_EQUAL }, { 'CT4_CONTA', "599999999", MVC_LOADFILTER_LESS_EQUAL } ,{ 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:SetRelation('CT4DETAILCC', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	//oModel:AddGrid('CT4DETAILD','CTDMASTER',oStFilhoCT4D,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'CT4DETAILD' ):SetLoadFilter( { { 'CT4_CONTA', "500000000", MVC_LOADFILTER_GREATER_EQUAL }, { 'CT4_CONTA', "599999999", MVC_LOADFILTER_LESS_EQUAL } ,{ 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:SetRelation('CT4DETAILD', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	
	//oModel:AddGrid('CT4DETAILD','CTDMASTER',oStFilhoCT4D,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'CT4DETAILD' ):SetLoadFilter( { { 'CT4_CONTA', "500000000", MVC_LOADFILTER_GREATER_EQUAL }, { 'CT4_CONTA', "599999999", MVC_LOADFILTER_LESS_EQUAL } ,{ 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:SetRelation('CT4DETAILD', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	oModel:AddGrid('CT4DETAIL30','CTDMASTER',oStFilho30,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'CT4DETAIL30' ):SetLoadFilter( { { 'CT4_CONTA', "500000000", MVC_LOADFILTER_GREATER_EQUAL }, { 'CT4_CONTA', "599999999", MVC_LOADFILTER_LESS_EQUAL } ,{ 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:SetRelation('CT4DETAIL30', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	oModel:AddGrid('CT4DETAILRD','CTDMASTER',oStFilhoCT4RD,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'CT4DETAILRD' ):SetLoadFilter( { { 'CT4_CONTA', "400000000", MVC_LOADFILTER_GREATER_EQUAL }, { 'CT4_CONTA', "499999999", MVC_LOADFILTER_LESS_EQUAL } ,{ 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:SetRelation('CT4DETAILRD', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	oModel:AddGrid('CT4DETAILCM','CTDMASTER',oStFilhoCT4CM,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'CT4DETAILCM' ):SetLoadFilter( { { 'CT4_CONTA', "621020001" }, { 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:SetRelation('CT4DETAILCM', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	
	oModel:AddGrid('CV4DETAIL','CTDMASTER',oStFilhoCV4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'CT4DETAILCM' ):SetLoadFilter( { { 'CT4_CONTA', "621020001" }, { 'CT4_MOEDA', "01" } , { 'CT4_LP', "'Z'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:SetRelation('CV4DETAIL', { { 'CV4_ITEMD', 'CTD_ITEM' } }, CV4->(IndexKey(1)) )
	 
    oModel:AddGrid('SZCDETAIL','CTDMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:AddGrid('SZFDETAIL','CTDMASTER',oStFilho6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	oModel:AddGrid('SZVDETAIL','CTDMASTER',oStFilho13,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZVDETAIL', { { 'ZV_ITEMIC', 'CTD_ITEM' } }, SZV->(IndexKey(1)) )
	
	oModel:AddGrid('ZZADETAIL','CTDMASTER',oStFilho31,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('ZZADETAIL', { { 'ZZA_ITEMIC', 'CTD_ITEM' } }, ZZA->(IndexKey(1)) )
	
	//oModel:AddGrid('SZXDETAIL','CTDMASTER',oStNeto14,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	
	oModel:AddGrid('SZHDETAIL','CTDMASTER',oStFilho7,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:AddGrid('SZIDETAIL','CTDMASTER',oStFilho8,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:AddGrid('SZJDETAIL','CTDMASTER',oStFilho9,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:AddGrid('SZMDETAIL','CTDMASTER',oStFilho10,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:AddGrid('SZNDETAIL','CTDMASTER',oStFilho11,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	oModel:AddGrid('SC7DETAIL','CTDMASTER',oStFilho2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'SC7DETAIL' ):SetLoadFilter( { { 'C7_ENCER', "'E'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:SetRelation('SC7DETAIL', { { 'C7_ITEMCTA', 'CTD_ITEM' } }, SC7->(IndexKey(1)) )

	oModel:AddGrid('SE2DETAIL'	,'CTDMASTER',	oStFilho3,	/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE2DETAIL' ):SetLoadFilter( { { 'E2_TIPO', "'PR'", MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'PA'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'NF'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'TX'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'ISS'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'INS'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_TIPO', "'INV'",MVC_LOADFILTER_NOT_EQUAL }, { 'E2_RATEIO', "'S'",MVC_LOADFILTER_NOT_EQUAL }   } )
	oModel:SetRelation('SE2DETAIL', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	//oModel:AddGrid('SE2DETAILB','CTDMASTER',oStFilho3B,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	//oModel:GetModel( 'SE2DETAILB' ):SetLoadFilter( { { 'E2_TIPO', "'PR'" } } )
	//oModel:SetRelation('SE2DETAILB', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	oModel:AddGrid('SD1DETAIL','CTDMASTER',oStFilho12,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	
	//oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( { { 'D1_CF', "{'1201','1554','1902 ','1903','1903','1906','1911','1912','1913','1913','1915','1916','1920','1921','1922','1924','1925','1925','1949','2201','2554','2902','2903','2906','2911','2912','2913','2915','2916','2920','2921','2922','2924','2925','2949'}", MVC_LOADFILTER_NOT_EQUAL  } } )
	
	//oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( { { 'D1_CF', "'1912/1924/1921/1920/1916/1915/1913/1912/1906/1921/1903
	///1902/1949/2925/2924/2921/2920/2916/2915/2913/2912/2906/2903/2902/2949'", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( { { 'D1_CF', "'1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2922/2924/2925/2949'" , MVC_LOADFILTER_IS_NOT_CONTAINED  } } )
	//{'1201','1554','1902','1903','1903','1906','1911','1912','1913','1913','1915','1916','1920','1921','1922','1924','1925','1925','1949','2201','2554','2902','2903','2906','2911','2912','2913','2915','2916','2920','2921','2922','2924','2925','2949'}
	//"'1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2922/2924/2925/2949'"
	//('1201', '1554','1902','1903''1906','1911','1912','1913','1915','1916','1920','1921','1922','1924','1925','1949','2201','2554','2902','2903',
	//'2906','2911','2912','2913','2916','2920','2921','2924','2925','2949')
	
	oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( { { 'D1_CF', "'1201'", MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1554'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1902'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1903'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1906'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1911'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1912'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1913'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1915'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1916'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1920'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1921'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1922'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1924'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'1925'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'1949'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2201'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2554'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2902'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2903'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2906'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2911'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2912'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2913'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2916'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2920'",MVC_LOADFILTER_NOT_EQUAL },  ;
												 { 'D1_CF', "'2921'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2915'",MVC_LOADFILTER_NOT_EQUAL }, ;
												 { 'D1_CF', "'2924'",MVC_LOADFILTER_NOT_EQUAL }, { 'D1_CF', "'2925'",MVC_LOADFILTER_NOT_EQUAL }, ;
												 { 'D1_CF', "'2949'",MVC_LOADFILTER_NOT_EQUAL } } )
												 
	//oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( { { 'D1_CF',"{'1201','1554','1902','1903','1906','1911','1912','1913','1915','1916','1920','1921','1922','1924', " +  ;
	  //												  "'1925','1949','2201','2554','2902','2903','2906','2911','2912','2913','2916','2920','2921', " + ;
		//											  "'2924','2925','2949'}",MVC_LOADFILTER_NOT_CONTAINS } } )										 
	
	oModel:SetRelation('SD1DETAIL', { { 'D1_ITEMCTA', 'CTD_ITEM' } }, SD1->(IndexKey(1)) )

	// RECEBIMENTO
	oModel:AddGrid('SE1DETAILC','CTDMASTER',oStFilho4C,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE1DETAILC' ):SetLoadFilter( { { 'E1_BAIXA', "''" }, { 'E1_TIPO', "'RA'" } } )
	oModel:GetModel( 'SE1DETAILC' ):SetLoadFilter( { { 'E1_BAIXA', "''", MVC_LOADFILTER_NOT_EQUAL }, { 'E1_TIPO', "'NF'" } } )
	oModel:SetRelation('SE1DETAILC', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )
	
	// A RECEBER
	oModel:AddGrid('SE1DETAIL','CTDMASTER',oStFilho4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE1DETAIL' ):SetLoadFilter( { { 'E1_TIPO', "'PR'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:GetModel( 'SE1DETAIL' ):SetLoadFilter( { { 'E1_TIPO', "'RA'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:GetModel( 'SE1DETAIL' ):SetLoadFilter( { { 'E1_BAIXA', "''"}, { 'E1_TIPO', "'NF'" } } )
	oModel:SetRelation('SE1DETAIL', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )
	
	// PROVISOES
	oModel:AddGrid('SE1DETAILB','CTDMASTER',oStFilho4B,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE1DETAILB' ):SetLoadFilter( { { 'E1_TIPO', "'PR'" } } )
	oModel:SetRelation('SE1DETAILB', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )
	
	oModel:AddGrid('SZ4DETAIL','CTDMASTER',oStFilho5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetRelation('SZ4DETAIL', { { 'Z4_ITEMCTA', 'CTD_ITEM' } }, SZ4->(IndexKey(1)) )
	
	
	//*********************************************************************************************
	// Pagos
	oModel:AddGrid('SE2DETAILC','CTDMASTER',oStFilho3C,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE2DETAILC' ):SetLoadFilter( { { 'E2_BAIXA', "''", MVC_LOADFILTER_NOT_EQUAL } , {  'E2_TIPO', "'PA'", MVC_LOADFILTER_NOT_EQUAL }  } )
	oModel:GetModel( 'SE2DETAILC' ):SetLoadFilter( { { 'E2_BAIXA', "''", MVC_LOADFILTER_NOT_EQUAL } , {  'E2_TIPO', "'PR'", MVC_LOADFILTER_NOT_EQUAL }  } )

	
	//oModel:GetModel( 'SE2DETAILC' ):SetLoadFilter( { { 'E2_BAIXA', "''" }, { 'E2_TIPO', "'PA'" } } )
	//oModel:GetModel( 'SE2DETAILC' ):SetLoadFilter( {  { 'E2_BAIXA', "''" } ,  { 'E2_TIPO', "'PA'" } } )
	oModel:SetRelation('SE2DETAILC', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	// A Pagar
	oModel:AddGrid('SE2DETAILD','CTDMASTER',oStFilho3D,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE2DETAILD' ):SetLoadFilter( { { 'E2_TIPO', "'PR'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:GetModel( 'SE2DETAILD' ):SetLoadFilter( { { 'E2_TIPO', "'PA'", MVC_LOADFILTER_NOT_EQUAL } } )
	oModel:GetModel( 'SE2DETAILD' ):SetLoadFilter( { { 'E2_BAIXA', "''"}, { 'E2_TIPO', "'NF'" } } )
	oModel:SetRelation('SE2DETAILD', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	// PROVISOES
	oModel:AddGrid('SE2DETAILE','CTDMASTER',oStFilho3E,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE2DETAILE' ):SetLoadFilter( { { 'E2_BAIXA', "''" } , {  'E2_TIPO', "'PR'" }  } )
	oModel:SetRelation('SE2DETAILE', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	// Pagos ANTECIPADOS
	oModel:AddGrid('SE2DETAILF','CTDMASTER',oStFilho3F,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SE2DETAILF' ):SetLoadFilter( { { 'E2_BAIXA', "''" }, {  'E2_TIPO', "'PA'" }  } )
	oModel:SetRelation('SE2DETAILF', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
	
	// COMISSAO
	oModel:AddGrid('SD1DETAILB','CTDMASTER',oStFilho12B,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:GetModel( 'SD1DETAILB' ):SetLoadFilter( { { 'D1_XNATURE', "'6.21.00'" } } )
	oModel:SetRelation('SD1DETAILB', { { 'D1_ITEMCTA', 'CTD_ITEM' } }, SD1->(IndexKey(1)) )
	
	//*********************************************************************************************
	
  //cOwner é para quem pertence
    oModel:AddGrid('SZDDETAIL','SZCDETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZDDETAIL', { { 'ZD_IDPLAN', 'ZC_IDPLAN' } , { 'ZD_ITEMIC', 'ZC_ITEMIC' } }, SZD->(IndexKey(1)) )
	
    //oModel:SetRelation('SZDDETAIL', { { 'ZD_IDPLAN', 'ZC_IDPLAN' } }, SZD->(IndexKey(1)) )
    
    oModel:AddGrid('SZGDETAIL','SZFDETAIL',oStNeto2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZGDETAIL', { { 'ZG_IDVEND', 'ZF_IDVEND' } , { 'ZG_NPROP' , 'ZF_NPROP'}  , {'ZF_ITEMIC', 'CTD_ITEM'}  }, SZF->(IndexKey(1)) )
    
    oModel:AddGrid('SZODETAIL','SZDDETAIL',oStNeto3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZODETAIL', { { 'ZO_IDPLSUB', 'ZD_IDPLSUB' } , { 'ZO_ITEMIC', 'ZD_ITEMIC' } }, SZO->(IndexKey(1)) )
    
    oModel:AddGrid('SZXDETAIL','SZVDETAIL',oStNeto14,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZXDETAIL', { { 'ZX_IDREV', 'ZV_IDREV' } }, SZX->(IndexKey(1)) )
    
    
    oModel:AddGrid('SZPDETAIL','SZGDETAIL',oStNeto4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZPDETAIL', { { 'ZP_IDVDSUB', 'ZG_IDVDSUB' } , {'ZP_NPROP', 'ZG_NPROP'}  }, SZP->(IndexKey(1)) )
    
    oModel:AddGrid('SZTDETAIL','SZPDETAIL',oStNeto5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZTDETAIL', { { 'ZT_IDVDSB2', 'ZP_IDVDSB2' } , {'ZT_NPROP', 'ZP_NPROP'} }, SZT->(IndexKey(1)) )
    
    oModel:AddGrid('SZUDETAIL','SZODETAIL',oStNeto6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    oModel:SetRelation('SZUDETAIL', { { 'ZU_IDPLSB2', 'ZO_IDPLSB2' } , { 'ZU_ITEMIC', 'ZO_ITEMIC' } }, SZU->(IndexKey(1)) )
    
      
    //Fazendo o relacionamento entre o Pai e Filho
	aAdd(aSZ9Rel, {'Z9_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZ9Rel, {'Z9_NPROP',  'CTD_NPROP'})
    
    aAdd(aCT4Rel30, {'CT4_FILIAL', 'CTD_FILIAL'} )
    aAdd(aCT4Rel30, {'CT4_ITEM',  'CTD_ITEM'})
    
    //aAdd(aCT4RelD, {'CT4_FILIAL', 'CTD_FILIAL'} )
    //aAdd(aCT4RelD, {'CT4_ITEM',  'CTD_ITEM'})
    
    //aAdd(aCT4RelRC, {'CT4_FILIAL', 'CTD_FILIAL'} )
    //aAdd(aCT4RelRC, {'CT4_ITEM',  'CTD_ITEM'})
    
    aAdd(aCT4RelRD, {'CT4_FILIAL', 'CTD_FILIAL'} )
    aAdd(aCT4RelRD, {'CT4_ITEM',  'CTD_ITEM'})
    
    aAdd(aCV4Rel, {'CV4_FILIAL', 'CTD_FILIAL'} )
    aAdd(aCV4Rel, {'CV4_ITEMD',  'CTD_ITEM'})
    
    aAdd(aCT4RelCM, {'CT4_FILIAL', 'CTD_FILIAL'} )
    aAdd(aCT4RelCM, {'CT4_ITEM',  'CTD_ITEM'})

    aAdd(aSZCRel, {'ZC_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZCRel, {'ZC_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZVRel, {'ZV_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZVRel, {'ZV_ITEMIC',  'CTD_ITEM'})
    
    //aAdd(aSZFRel, {'ZF_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZFRel, {'ZF_ITEMIC',  'CTD_ITEM'})
     
    aAdd(aSZHRel, {'ZH_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZHRel, {'ZH_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZIRel, {'ZI_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZIRel, {'ZI_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZJRel, {'ZJ_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZJRel, {'ZJ_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aZZARel, {'ZZA_FILIAL', 'CTD_FILIAL'} )
    aAdd(aZZARel, {'ZZA_ITEMIC',  'CTD_ITEM'})
    
    //aAdd(aSZMRel, {'ZM_FILIAL', 'CTD_FILIAL'} )
    //aAdd(aSZMRel, {'ZM_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZNRel, {'ZN_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZNRel, {'ZN_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSC7Rel, {'C7_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSC7Rel, {'C7_ITEMCTA', 'CTD_ITEM'})
    
    aAdd(aSE2Rel, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2Rel, {'E2_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE2RelB, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2RelB, {'E2_XXIC', 'CTD_ITEM'})
    
    //******************************************
    aAdd(aSE2RelC, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2RelC, {'E2_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE2RelD, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2RelD, {'E2_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE2RelE, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2RelE, {'E2_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE2RelF, {'E2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE2RelF, {'E2_XXIC', 'CTD_ITEM'})
    
    //aAdd(aSD1RelG, {'D1_FILIAL', 'CTD_FILIAL'} )
    //aAdd(aSD1RelG, {'D1_ITEMCTA', 'CTD_ITEM'})
    //******************************************
         
    aAdd(aSE1Rel, {'E1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE1Rel, {'E1_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE1RelB, {'E1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE1RelB, {'E1_XXIC', 'CTD_ITEM'})
    
    aAdd(aSE1RelC, {'E1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE1RelC, {'E1_XXIC', 'CTD_ITEM'})
    
    aAdd(aSZ4Rel, {'Z4_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZ4Rel, {'Z4_ITEMCTA', 'CTD_ITEM'})
    
    aAdd(aSD1Rel, {'D1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSD1Rel, {'D1_ITEMCTA', 'CTD_ITEM'})
    
    aAdd(aSD1RelB, {'D1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSD1RelB, {'D1_ITEMCTA', 'CTD_ITEM'})
     
    //Fazendo o relacionamento entre o Filho e Neto
    //aAdd(aSZDRel, {'ZD_FILIAL', 'ZC_FILIAL'} )
    aAdd(aSZDRel, {'ZD_IDPLAN', 'ZC_IDPLAN'}) 
    aAdd(aSZDRel, {'ZD_ITEMIC', 'ZC_ITEMIC'}) 
    
    //aAdd(aSZGRel, {'ZG_FILIAL', 'ZF_FILIAL'} )
    aAdd(aSZGRel, {'ZG_IDVEND', 'ZF_IDVEND'}) 
    aAdd(aSZGRel, {'ZG_NPROP', 'CTD_NPROP'} )
    
    aAdd(aSZORel, {'ZO_FILIAL', 'ZD_FILIAL'} )
    aAdd(aSZORel, {'ZO_IDPLSUB', 'ZD_IDPLSUB'})
    aAdd(aSZORel, {'ZO_ITEMIC', 'ZD_ITEMIC'}) 

	aAdd(aSZXRel, {'ZX_FILIAL', 'ZV_FILIAL'} )
    aAdd(aSZXRel, {'ZX_IDREV', 'ZV_IDREV'}) 
    
    //aAdd(aSZPRel, {'ZP_FILIAL', 'ZG_FILIAL'} )
    aAdd(aSZPRel, {'ZP_IDVDSUB', 'ZG_IDVDSUB'}) 
    aAdd(aSZPRel, {'ZP_NPROP', 'CTD_NPROP'})
    
    //aAdd(aSZTRel, {'ZT_FILIAL', 'ZP_FILIAL'} )
    aAdd(aSZTRel, {'ZT_IDVDSB2', 'ZP_IDVDSB2'})
    aAdd(aSZTRel, {'ZT_NPROP', 'CTD_NPROP'})
    
    aAdd(aSZURel, {'ZU_FILIAL', 'ZO_FILIAL'} )
    aAdd(aSZURel, {'ZU_IDPLSB2', 'ZO_IDPLSB2'})
    aAdd(aSZURel, {'ZU_ITEMIC', 'ZO_ITEMIC'})
    
    oModel:GetModel('SZCDETAIL'):SetOptional( .T. )
    
    //oModel:GetModel('CT4DETAILD'):SetOptional( .T. )
 
 	
    oModel:GetModel('SZVDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZXDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZFDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZHDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZIDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZJDETAIL'):SetOptional( .T. )
    //oModel:GetModel('SZMDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZNDETAIL'):SetOptional( .T. )
    oModel:GetModel('SC7DETAIL'):SetOptional( .T. )
    oModel:GetModel('SZDDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZGDETAIL'):SetOptional( .T. )
	oModel:GetModel('SE2DETAIL'):SetOptional( .T. )
	//oModel:GetModel('SE2DETAILB'):SetOptional( .T. )
	oModel:GetModel('SE2DETAILC'):SetOptional( .T. )
	oModel:GetModel('SE2DETAILD'):SetOptional( .T. )
	oModel:GetModel('SE2DETAILE'):SetOptional( .T. )
	oModel:GetModel('SE2DETAILF'):SetOptional( .T. )
	//oModel:GetModel('SD1DETAILG'):SetOptional( .T. )
	oModel:GetModel('SE1DETAIL'):SetOptional( .T. )
	oModel:GetModel('SE1DETAILB'):SetOptional( .T. )
	oModel:GetModel('SE1DETAILC'):SetOptional( .T. )
	oModel:GetModel('SZ4DETAIL'):SetOptional( .T. )
	oModel:GetModel('SD1DETAIL'):SetOptional( .T. )
	oModel:GetModel('SD1DETAILB'):SetOptional( .T. )
	oModel:GetModel('SZODETAIL'):SetOptional( .T. )
	oModel:GetModel('SZPDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZ9DETAIL'):SetOptional( .T. )
	oModel:GetModel('SZTDETAIL'):SetOptional( .T. )
	oModel:GetModel('SZUDETAIL'):SetOptional( .T. )
	oModel:GetModel('CT4DETAIL30'):SetOptional(.T. )
 	//oModel:GetModel('CT4DETAILD'):SetOptional( .T. )
    //oModel:GetModel('CT4DETAILRC'):SetOptional( .T. )
    oModel:GetModel('CT4DETAILRD'):SetOptional( .T. )
    oModel:GetModel('CT4DETAILCM'):SetOptional( .T. )
    oModel:GetModel('CV4DETAIL'):SetOptional( .T. )
    oModel:GetModel('ZZADETAIL'):SetOptional( .T. )
//IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZ9DETAIL'):SetUniqueLine({"Z9_FILIAL","Z9_NPROP"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
    
    
oModel:SetRelation('SZCDETAIL', { { 'ZC_ITEMIC', 'CTD_ITEM',  } }, SZC->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZCDETAIL'):SetUniqueLine({"ZC_FILIAL","ZC_IDPLAN"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZFDETAIL', { { 'ZF_ITEMIC', 'CTD_ITEM' } }, SZF->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZFDETAIL'):SetUniqueLine({"ZF_FILIAL","ZF_IDVEND"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZHDETAIL', { { 'ZH_ITEMIC', 'CTD_ITEM' } }, SZH->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZHDETAIL'):SetUniqueLine({"ZH_FILIAL","ZH_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZIDETAIL', { { 'ZI_ITEMIC', 'CTD_ITEM' } }, SZI->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZIDETAIL'):SetUniqueLine({"ZI_FILIAL","ZI_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZJDETAIL', { { 'ZJ_ITEMIC', 'CTD_ITEM' } }, SZJ->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZJDETAIL'):SetUniqueLine({"ZJ_FILIAL","ZJ_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
//oModel:SetRelation('SZMDETAIL', { { 'ZM_ITEMIC', 'CTD_ITEM' } }, SZM->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZMDETAIL'):SetUniqueLine({"ZM_FILIAL","ZM_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
   
oModel:SetRelation('SZNDETAIL', { { 'ZN_ITEMIC', 'CTD_ITEM' } }, SZN->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZNDETAIL'):SetUniqueLine({"ZN_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
 
oModel:SetRelation('SC7DETAIL', { { 'C7_ITEMCTA', 'CTD_ITEM' }, { 'C7_ITEMCTA', 'CTD_ITEM' } }, SC7->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SC7DETAIL'):SetUniqueLine({"C7_FILIAL"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

oModel:SetRelation('SE2DETAIL', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )

//**********************************************************************************    
oModel:SetRelation('SE2DETAILC', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )
    
oModel:SetRelation('SE2DETAILD', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )

oModel:SetRelation('SE2DETAILE', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )

oModel:SetRelation('SE2DETAILF', { { 'E2_XXIC', 'CTD_ITEM' } }, SE2->(IndexKey(1)) )

//oModel:SetRelation('SD1DETAILG', { { 'D1_ITEMCTA', 'CTD_ITEM' } }, SD1->(IndexKey(1)) )	
//**********************************************************************************
     
oModel:SetRelation('SE1DETAIL', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )

oModel:SetRelation('SE1DETAILB', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )

oModel:SetRelation('SE1DETAILC', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )

oModel:SetRelation('SZ4DETAIL', { { 'Z4_ITEMCTA', 'CTD_ITEM' } }, SZ4->(IndexKey(1)) )


oModel:SetRelation('SZDDETAIL', { { 'ZD_IDPLAN', 'ZC_IDPLAN' } }, SZD->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZDDETAIL'):SetUniqueLine({"ZD_IDPLSUB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZODETAIL', { { 'ZO_IDPLSUB', 'ZD_IDPLSUB' } }, SZO->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZODETAIL'):SetUniqueLine({"ZO_IDPLSB2"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

/*
oModel:SetRelation('SZUDETAIL', { { 'ZU_IDPLSB2', 'ZD_IDPLSBN' } }, SZO->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZUDETAIL'):SetUniqueLine({"ZO_IDPLSB3"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
*/

//oModel:SetRelation('SZXDETAIL', { { 'ZX_IDREV', 'ZV_IDREV' } }, SZX->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZXDETAIL'):SetUniqueLine({"ZX_IDRVSUB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SZGDETAIL', { { 'ZG_IDVEND', 'ZF_IDVEND' } }, SZG->(IndexKey(1)) )
 //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('SZGDETAIL'):SetUniqueLine({"ZG_IDVDSUB"}) //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
    
oModel:SetRelation('SD1DETAIL', { { 'D1_ITEMCTA', 'CTD_ITEM' } }, SD1->(IndexKey(1)) )
	oModel:SetPrimaryKey({})
	
oModel:SetRelation('CT4DETAIL30', { { 'CT4_ITEM', 'CTD_ITEM' } }, CT4->(IndexKey(1)) )
	oModel:SetPrimaryKey({})
 

    //Setando as descrições
    oModel:SetDescription("Gestao de Contratos")
    oModel:GetModel('CTDMASTER'):SetDescription('Contrato')
    oModel:GetModel('SZCDETAIL'):SetDescription('Custos - Planejado')
    oModel:GetModel('CT4DETAIL30'):SetDescription('Contabilizado Custo ')
    
    //oModel:GetModel('CT4DETAILD'):SetDescription('Contabilizado Custo ')
 
    //oModel:GetModel('CT4DETAILRC'):SetDescription('Contabilizado Custo')
    oModel:GetModel('CT4DETAILRD'):SetDescription('Contabilizado Receita')
    oModel:GetModel('CT4DETAILCM'):SetDescription('Contabilizado Custo - Comissao')
    oModel:GetModel('SZVDETAIL'):SetDescription('Custos - Revisado')
    oModel:GetModel('SZ9DETAIL'):SetDescription('Proposta')
    oModel:GetModel('SZFDETAIL'):SetDescription('Custos - Vendido')
    
    oModel:GetModel('SZHDETAIL'):SetDescription('Outros Custos - Planejado')
    oModel:GetModel('SZIDETAIL'):SetDescription('Outros Custos - Vendido')
    oModel:GetModel('SZJDETAIL'):SetDescription('Apontamento Horas Planejado')
    //oModel:GetModel('SZMDETAIL'):SetDescription('Apontamento Horas Vendido')
    oModel:GetModel('SZNDETAIL'):SetDescription('Resumo Custo Vendido')
    oModel:GetModel('SC7DETAIL'):SetDescription('Compras')
    oModel:GetModel('SZDDETAIL'):SetDescription('Destalhes Custos Planejado')
    oModel:GetModel('SZGDETAIL'):SetDescription('Destalhes Custos Vendido')
	oModel:GetModel('SE2DETAIL'):SetDescription('Outros Custos Real (Contas a Pagar)')
	oModel:GetModel('SE2DETAILC'):SetDescription('Pagos')
	oModel:GetModel('SE2DETAILD'):SetDescription('A Pagar')
	oModel:GetModel('SE2DETAILE'):SetDescription('Provisoes')
	oModel:GetModel('SE2DETAILF'):SetDescription('Pagamento Antecipado')
	//oModel:GetModel('SD1DETAILG'):SetDescription('Comissao')
	//oModel:GetModel('SE2DETAILB'):SetDescription('Contas a Pagar - Provisões')
	oModel:GetModel('SE1DETAIL'):SetDescription('Contas a Receber - Efetivo')
	oModel:GetModel('SE1DETAILB'):SetDescription('Contas a Receber - Provisoes')
	oModel:GetModel('SE1DETAILC'):SetDescription('Contas a Receber - Recebimento Antecipado')
	
	oModel:GetModel('SZ4DETAIL'):SetDescription('Apontamento de Horas')
	oModel:GetModel('SD1DETAIL'):SetDescription('Custo Real (Docs de Entrada')
	oModel:GetModel('SD1DETAILB'):SetDescription('Comissao')
	oModel:GetModel('SZODETAIL'):SetDescription('Nivel 3 - Detalhes Planejado / Revisado')
	oModel:GetModel('SZPDETAIL'):SetDescription('Nivel 3 - Detalhes Vendido')
	oModel:GetModel('SZTDETAIL'):SetDescription('Nivel 4 - Detalhes Vendido')
	oModel:GetModel('ZZADETAIL'):SetDescription('Custos Complementares')
	oModel:GetModel('SZUDETAIL'):SetDescription('Nivel 4 - Detalhes Planejado / Revisado')
	
	
	oModel:getModel('SZNDETAIL'):SetMaxLine(6)
	//oModel:getModel('SZHDETAIL'):SetMaxLine(7)
	oModel:getModel('SC7DETAIL'):SetOnlyQuery(.T.)
	
	//oModel:AddCalc( 'calcSZC', 'CTDMASTER', 'SZCDETAIL', 'ZC_TOTAL', 'calcPla', 'SUM', /*bCondition*/, /*bInitValue*/,'Plajejado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZC', 'CTDMASTER', 'SZCDETAIL', 'ZC_TOTALR', 'calcRev', 'SUM', /*bCondition*/, /*bInitValue*/,'Revisado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTAL', 'calcVD', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTVSI', 'calcVDsi', 'SUM', /*bCondition*/, /*bInitValue*/,'Venda s/ Tributos' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTVCI', 'calcVDci', 'SUM', /*bCondition*/, /*bInitValue*/,'Venda c/ Tributos' /*cTitle*/, /*bFormula*/)
	
	oModel:AddCalc( 'calcSC7', 'CTDMASTER', 'SC7DETAIL', 'C7_TOTAL', 'calcCom', 'SUM', /*bCondition*/, /*bInitValue*/,'Compras c/ Tributos' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSC7', 'CTDMASTER', 'SC7DETAIL', 'C7_XTOTSI', 'calcCom_SI', 'SUM', /*bCondition*/, /*bInitValue*/,'Compras s/ Tributos' /*cTitle*/, /*bFormula*/) 
	oModel:AddCalc( 'calcSC7', 'CTDMASTER', 'SD1DETAIL', 'D1_CUSTO', 'calcCDOC', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo (Doc. Entrada)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSC7', 'CTDMASTER', 'SD1DETAIL', 'D1_CUSTO', 'calcNDOC', 'COUNT', /*bCondition*/, /*bInitValue*/,'No. Docs. Entrada' /*cTitle*/, /*bFormula*/)  
	oModel:AddCalc( 'calcSC7', 'CTDMASTER', 'SC7DETAIL', 'C7_XTOTSI', 'calcNOCS', 'COUNT', /*bCondition*/, /*bInitValue*/,'No. OCs' /*cTitle*/, /*bFormula*/)
	
	//oModel:AddCalc( 'calcSE2', 'CTDMASTER', 'SE2DETAILB', 'E2_VALOR', 'calcPagar_PR', 'SUM', /*bCondition*/, /*bInitValue*/,'Pagar Provisoes' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE2', 'CTDMASTER', 'SE1DETAIL', 'E1_VALOR', 'calcREC2', 'SUM', /*bCondition*/, /*bInitValue*/,'Receber Efetivo' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE2', 'CTDMASTER', 'SE1DETAILB', 'E1_VALOR', 'calcSE1_PR2', 'SUM', /*bCondition*/, /*bInitValue*/,'Provisoes' /*cTitle*/, /*bFormula*/)
	
	//oModel:AddCalc( 'calcSE2P', 'CTDMASTER', 'SE2DETAILC', 'E2_VALOR;', 'calcSE2PG', 'SUM', /*bCondition*/, /*bInitValue*/,'Pago' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE2P', 'CTDMASTER', 'SE2DETAILF', 'E2_VALOR;', 'calcSE2PA', 'SUM', /*bCondition*/, /*bInitValue*/,'Antecipado' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE2P', 'CTDMASTER', 'SE2DETAILD', 'E2_VALOR;', 'calcSE2AP', 'SUM', /*bCondition*/, /*bInitValue*/,'A Pagar' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE2P', 'CTDMASTER', 'SE2DETAILE', 'E2_VALOR;', 'calcSE2PR', 'SUM', /*bCondition*/, /*bInitValue*/,'Provisoes' /*cTitle*/, /*bFormula*/)
	
	
	//oModel:AddCalc( 'calcSE1', 'CTDMASTER', 'SE1DETAILC', 'E1_VALOR;', 'calcREC_R', 'SUM', /*bCondition*/, /*bInitValue*/,'Recebimento' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE1', 'CTDMASTER', 'SE1DETAIL', 'E1_VALOR;', 'calcREC', 'SUM', /*bCondition*/, /*bInitValue*/,'A Receber' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSE1', 'CTDMASTER', 'SE1DETAILB', 'E1_VALOR;', 'calcSE1_PR', 'SUM', /*bCondition*/, /*bInitValue*/,'Provisoes' /*cTitle*/, /*bFormula*/)
	
	//oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZMDETAIL', 'ZM_TOTAL', 'calcVHV', 'SUM', /*bCondition*/, /*bInitValue*/,'Vlr. Total (Revisado)' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZMDETAIL', 'ZM_HORAS', 'calcTHV', 'SUM', /*bCondition*/, /*bInitValue*/,'Horas (Revisado)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_TOTAL', 'calcVHP', 'SUM', /*bCondition*/, /*bInitValue*/,'Vlr. Total (Planejado)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_HORAS', 'calcTHP', 'SUM', /*bCondition*/, /*bInitValue*/,'Horas (Planejado)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_TOTALR', 'calcVHPR', 'SUM', /*bCondition*/, /*bInitValue*/,'Vlr. Total (Revisado)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_HORASR', 'calcTHPR', 'SUM', /*bCondition*/, /*bInitValue*/,'Horas (Revisado)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_TOTALV', 'calcVHPV', 'SUM', /*bCondition*/, /*bInitValue*/,'Vlr. Total (Vendido)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZJDETAIL', 'ZJ_HORASV', 'calcTHPV', 'SUM', /*bCondition*/, /*bInitValue*/,'Horas (Vendido)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZ4DETAIL', 'Z4_TOTVLR', 'calcValHR', 'SUM', /*bCondition*/, /*bInitValue*/,'Valor Hora (Real)' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZM', 'CTDMASTER', 'SZ4DETAIL', 'Z4_QTDHRS', 'calcHoras', 'SUM', /*bCondition*/, /*bInitValue*/,'Horas (Real)' /*cTitle*/, /*bFormula*/)
	
	
	//oModel:AddCalc( 'calcSZH', 'CTDMASTER', 'SZHDETAIL', 'ZH_CUSPLA', 'calcCPL', 'SUM', /*bCondition*/, /*bInitValue*/,'Outros Custos Planejado' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZI', 'CTDMASTER', 'SZIDETAIL', 'ZI_CUSVEN', 'calcCVD', 'SUM', /*bCondition*/, /*bInitValue*/,'Outros Custos Vendido' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZI', 'CTDMASTER', 'SZHDETAIL', 'ZH_CUSPLA', 'calcCPL', 'SUM', /*bCondition*/, /*bInitValue*/,'Outros Custos Planejado' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZI', 'CTDMASTER', 'SD1DETAILB', 'D1_TOTAL', 'calcCom', 'SUM', /*bCondition*/, /*bInitValue*/,'Comissao' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZI', 'CTDMASTER', 'SE2DETAIL', 'E2_XCUSTII', 'calcPagar', 'SUM', /*bCondition*/, /*bInitValue*/,'Outros Custos - Contas a Pagar' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcSZI', 'CTDMASTER', 'CV4DETAIL', 'CV4_VALOR', 'calcCV4', 'SUM', /*bCondition*/, /*bInitValue*/,'Outros Custos - Rateio' /*cTitle*/, /*bFormula*/)
	
	
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAILRD', 'CT4_DEBITO', 'calcDEBB', 'SUM', /*bCondition*/, /*bInitValue*/,'Receita Debito' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAILRD', 'CT4_CREDIT', 'calcCRDB', 'SUM', /*bCondition*/, /*bInitValue*/,'Receita Credito' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAIL30', 'CT4_DEBITO', 'calcDEB', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo Debito' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAIL30', 'CT4_CREDIT', 'calcCRD', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo Credito' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAILCM', 'CT4_DEBITO', 'calcDEBCM', 'SUM', /*bCondition*/, /*bInitValue*/,'Comisao Debito' /*cTitle*/, /*bFormula*/)
	oModel:AddCalc( 'calcCT4', 'CTDMASTER', 'CT4DETAILCM', 'CT4_CREDIT', 'calcCRDCM', 'SUM', /*bCondition*/, /*bInitValue*/,'Comissao Credito' /*cTitle*/, /*bFormula*/)
	
	
	
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
	
	//Local oModelCT4D   	:= oModel:GetModel( 'CT4DETAILD' )
	Local oModelCT430   	:= oModel:GetModel( 'CT4DETAIL30' )
	
	//Local oModelCT4RC   	:= oModel:GetModel( 'CT4DETAILRC' )
	Local oModelCT4RD   	:= oModel:GetModel( 'CT4DETAILRD' )
	Local oModelCT4CM   	:= oModel:GetModel( 'CT4DETAILCM' )
	 
	Local lRet 			:= .T.
		
	Local oStNeto2   	:= FWFormStruct(1, 'SZG')
	
	Local oModelSZV   	:= oModel:GetModel( 'SZVDETAIL' )
	Local oModelSZX   	:= oModel:GetModel( 'SZXDETAIL' )
	Local oModelSZF2   	:= oModel:GetModel( 'SZFDETAIL' )
	
	Local oModelCV4   	:= oModel:GetModel( 'CV4DETAIL' )
		 
	Local oModelSZN   	:= oModel:GetModel( 'SZNDETAIL' )
	//Local oModelSZM   	:= oModel:GetModel( 'SZMDETAIL' )
	Local oModelSZJ   	:= oModel:GetModel( 'SZJDETAIL' )
	Local oModelSC7   	:= oModel:GetModel( 'SC7DETAIL' )
	Local oModelSE2   	:= oModel:GetModel( 'SE2DETAIL' )
	//Local oModelSD1G   	:= oModel:GetModel( 'SD1DETAILG' )
	Local oModelSZ4   	:= oModel:GetModel( 'SZ4DETAIL' )
	Local oModelSD1   	:= oModel:GetModel( 'SD1DETAIL' )
	Local oModelSD1B   	:= oModel:GetModel( 'SD1DETAILB' )
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
	Local nTotalZI 		:= oModel:GetValue( 'SZIDETAIL', 'ZI_CUSVEN' )
	//Local nTotalZM 		:= oModel:GetValue( 'SZMDETAIL', 'ZM_TOTAL' )
	Local nTotalZJ 		:= oModel:GetValue( 'SZJDETAIL', 'ZJ_TOTAL' )
	Local nTotalZH 		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
	Local nTotalC7 		:= oModel:GetValue( 'SC7DETAIL', 'C7_XTOTSI' )
	Local nTotalE2 		:= oModel:GetValue( 'SE2DETAIL', 'E2_VLCRUZ' )
	Local nTotalZ4 		:= oModel:GetValue( 'SZ4DETAIL', 'Z4_TOTVLR' )
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local nTotalD1		:= oModel:GetValue( 'SD1DETAIL', 'D1_CUSTO' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0
	
	Local oModelSZH   	:= oModel:GetModel( 'SZHDETAIL' )
	Local oModelSZI   	:= oModel:GetModel( 'SZIDETAIL' ) 
	Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local nXSISFV		:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFV' )
	Local nXITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	
	Local nXVDSICTD2		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIP' )
	Local nXSISFP			:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFP' )
	Local nXVDSICTD3		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIR' )
	Local nXSISFR			:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFR' )
	
	Local nCusto_CTD	:= oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' )
	Local nPercentSZH	:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROC' )
	Local nPercentSZI	:= oModel:GetValue( 'SZIDETAIL', 'ZI_PERCENT' )
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
	
	Local nTotalSZH 	:= 0
	Local nTotalSZI 	:= 0
	Local nTotalZOF		:= 0
	Local nTotalZPF		:= 0 
	
	Local nDesCusProdSZI	:= oModel:GetValue( 'SZNDETAIL', 'ZN_DESCRI' )
	Local nLinha		:= 0
	Local nTotalSZF_RES := 0
	Local nTotalSZI_RES := 0
	Local nTotalSZM_RES := 0
	Local nTotalSZF_SZM := 0
	Local nTotalVendido := 0
	Local nMargemBrutaV := 0
	Local nMargemContrV := 0
	
	Local nTotalSZC_RES	:= 0
	Local nTotalSZJ_RES	:= 0
	Local nTotalSZC_SZJ := 0
	Local nTotalSZH_RES := 0
	Local nTotalPlanej	:= 0
	Local nMargemBrutaP := 0
	Local nMargemContrP := 0
	
	Local nTotalSC7_RES := 0
	Local nTotalSZ4_RES := 0 
	Local nTotalSC7_SZ4 := 0
	Local nTotalSE2_RES := 0
	Local nTotalReal	:= 0
	Local nMargemBrutaR := 0
	Local nMargemContrR := 0
	Local nTotalSD1_RES := 0
	
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
	
	Local nTotalZH_COM			:= 0	
	Local nTotalSZH_COM			:= 0
	Local nTotalSZH_CTG			:= 0
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
	Local nZN_CUSTO_REV			:= 0
	Local nZN_CONTIG_REV		:= 0
	Local nZN_CUPRD_REV			:= 0
	Local nZN_OCFIA_REV			:= 0
	Local nZN_OCFIN_REV			:= 0
	Local nZN_OCGAR_REV			:= 0
	Local nZN_OCPIP_REV			:= 0
	Local nZN_OCCOM_REV			:= 0
	Local nZN_OCROY_REV			:= 0
	Local nZN_OUOUT_REV			:= 0
	Local nZN_CUSTOT_REV		:= 0
	Local nZN_VLRMB_REV			:= 0
	Local nZN_PERMB_REV			:= 0
	Local nZN_VLRCTB_REV		:= 0
	Local nZN_PERCTB_REV		:= 0
	
	Local nZN_CUSTO_EMP			:= 0
	Local nZN_CONTIG_EMP		:= 0
	Local nZN_CUPRD_EMP			:= 0
	Local nZN_OCFIA_EMP			:= 0
	Local nZN_OCFIN_EMP			:= 0
	Local nZN_OCGAR_EMP			:= 0
	Local nZN_OCPIP_EMP			:= 0
	Local nZN_OCCOM_EMP			:= 0
	Local nZN_OCROY_EMP			:= 0
	Local nZN_OUOUT_EMP			:= 0
	Local nZN_CUSTOT_EMP		:= 0
	Local nZN_VLRMB_EMP			:= 0
	Local nZN_PERMB_EMP			:= 0
	Local nZN_VLRCTB_EMP		:= 0
	Local nZN_PERCTB_EMP		:= 0
	Local cTipoOC_comReal		:= ""
	Local nTipoOC_comReal		:= 0
	
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
	
	Local nTotalCT4D			:= 0	
	Local nTotalCT4RESD			:= 0
	Local nTotalCT4C			:= 0
	Local nTotalCT4RESC			:= 0
	Local nTotCT4				:= 0
	
	Local nTotalCT4RD			:= 0	
	Local nTotalCT4RRESD		:= 0
	Local nTotalCT4RC			:= 0
	Local nTotalCT4RRESC		:= 0
	Local nTotalCT4R			:= 0
	Local nTotCT4R				:= 0
	Local nIX					:= 0
	Local nIX1					:= 0
	
	Local nReceitaCT4R			:= 0
	Local nReceitaCT4			:= 0
	
	Local cTipoOCCTD			:= ""   
	
	Local nI201					:= 0 
	Local nTotalCT4RDcom  		:= 0
	Local nReceitaCT4Rcom		:=  0  
	Local nCT4Conta				:= ""
	Local nTotalCT4CM			:= 0
	Local nReceitaCT4CM			:= 0
	Local nComissaoTotalCT4CM	:= 0
	Local nComissaoCT4CM		:= 0
	
	Local nCustoCT4C	:= 0
	Local nCustoCT4D	:= 0
	Local nCustoCT4RESC	:= 0
	Local nCustoCT4		:= 0
	
	Local nCustoCT4RESCCT	:= 0
	Local nCustoCT4CT		:= 0
	
	Local nReceitaCT4RC	:= 0 
	//Local nTotalCT4RC	:= 0	
	Local xt := 0
	
	Local nCusto30T	:= 0
	Local nCusto30R := 0
	
	
	Local nI16B			:= 0
	Local nTotalCV4		:= 0
	Local nTotalCV4_RES	:= 0
	
	Local nTotalZZA 	:= 0
	Local nTotalZZA_RES := 0
	
	Local nTotalZUrev 	:= 0
	Local nTotalZUFrev 	:= 0
	
	Local nCusto_CTD2	:= 0
	Local nCusto_CTD3	:= 0
	
	Local nTotalZCcpp	:= 0	
	Local nTotalSZC_RESccp	:= 0
	Local nTotalZJccp := 0
	Local nTotalSZJ_RESccp := 0

	/*
	if oModelSZF:Length() <> oModelSZV:Length()
		
		For nI48 := 1 To oModelSZF:Length()
			oModelSZV:AddLine()
		Next nI48
		
		For nI47 := 1 To oModelSZC:Length()
				
			oModelSZF:GoLine( nI47 )
			cDescri_CVR 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_DESCRI' )
					
			oModelSZV:GoLine( nI47 )
			oModelSZV:SetValue('ZV_DESCRI', cDescri_CVR )	
		Next nI47
	endif
	*/
	//// CUSTO PLANEJADO CONJUNTO
	For nI := 1 To oModelSZC:Length()
		oModelSZC:GoLine( nI )
		nTotalZD		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTAL' )
		nTotalZDrev		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTALR' )
		
		For nI2 := 1 To oModelSZD:Length()
			oModelSZD:GoLine( nI2 ) 
			
				For nI63 := 1 To oModelSZO:Length()
					oModelSZO:GoLine( nI63 ) 
					
					
					For nI213 := 1 To oModelSZU:Length()
						oModelSZU:GoLine( nI213 ) 
						
						nTotalZU		:= oModel:GetValue( 'SZUDETAIL', 'ZU_TOTAL' )	
						nTotalZUF += Round( nTotalZU , 2 )
						
						if nTotalZUF > 0
							oModelSZU:SetValue('ZU_ITEMIC', nXITEMCTA )
						endif
							   	
				   	Next nI213
				   	
				   	If nTotalZUF > 0
				   		oModelSZO:SetValue('ZO_UNIT', nTotalZUF )
				   		nTotalZUF := 0
				    Endif
				    
				    nTotalZO		:= oModel:GetValue( 'SZODETAIL', 'ZO_TOTAL' )	
					nTotalZOF += Round( nTotalZO , 2 )
					
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
			   	
			   	If nTotalZOF > 0
			   		oModelSZD:SetValue('ZD_UNIT', nTotalZOF )
			   		nTotalZOF := 0
			    Endif
			    
			    If nTotalZOFrev > 0
			   		oModelSZD:SetValue('ZD_UNITR', nTotalZOFrev )
			   		nTotalZOFrev := 0
			    Endif
			
			
				nTotalZD		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTAL' )	
				nTotalZDF += Round( nTotalZD , 2 )
				
				nTotalZDrev		:= oModel:GetValue( 'SZDDETAIL', 'ZD_TOTALR' )	
				nTotalZDFrev += Round( nTotalZDrev , 2 )
				
				if nTotalZDFrev > 0
					oModelSZD:SetValue('ZD_ITEMIC', nXITEMCTA )
				endif
	   	Next nI2
	   
	    nQuantSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_QUANT' )
	    nQuantSZCrev	:= oModel:GetValue( 'SZCDETAIL', 'ZC_QUANTR' )
	   
	   	oModelSZC:SetValue('ZC_UNIT', nTotalZDF )
	   	oModelSZC:SetValue('ZC_TOTAL', nTotalZDF*nQuantSZC )
	   	
	   	oModelSZC:SetValue('ZC_UNITR', nTotalZDFrev )
	   	oModelSZC:SetValue('ZC_TOTALR', nTotalZDFrev*nQuantSZCrev )
	   	
	      	
		cIDPlanSZC	:= oModel:GetValue( 'SZCDETAIL', 'ZC_IDPLAN' )
		cIDPlanSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLAN' )
		nTotalZDF 	:= 0
		nTotalZDFrev 	:= 0
		
	Next nI  	
	   	  
 	nTotalZDF 	:= 0
 	nTotalZDFrev := 0
 	
 	//// CUSTO REVISADO CONJUNTO
	For nI49 := 1 To oModelSZC:Length()
		oModelSZV:GoLine( nI49 )
		nTotalZX		:= oModel:GetValue( 'SZXDETAIL', 'ZX_TOTAL' )
		
		For nI50 := 1 To oModelSZX:Length()
			oModelSZX:GoLine( nI50 ) 
			nTotalZX		:= oModel:GetValue( 'SZXDETAIL', 'ZX_TOTAL' )	
			nTotalZXF += Round( nTotalZX , 2 )
	   	Next nI50
	   
	    nQuantSZV	:= oModel:GetValue( 'SZVDETAIL', 'ZV_QUANT' )
	   
	   	oModelSZV:SetValue('ZV_UNIT', nTotalZXF )
	   	oModelSZV:SetValue('ZV_TOTAL', nTotalZXF*nQuantSZV )
		cIDRevSZV	:= oModel:GetValue( 'SZVDETAIL', 'ZV_IDREV' )
		cIDRevSZX	:= oModel:GetValue( 'SZXDETAIL', 'ZX_IDREV' )
		nTotalZXF 	:= 0
		
	Next nI49  	
	   	  
 	nTotalZXF 	:= 0
 	//////////////////////////// Custo Vendido ///////////////////////////////////////////
	For nI23 := 1 To oModelSZP:Length()
		oModelSZP:GoLine( nI23 )
		nTotalZT		:= oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' )
		
		For nI24 := 1 To oModelSZT:Length()
			oModelSZT:GoLine( nI24 ) 
			nTotalZT		:= oModel:GetValue( 'SZTDETAIL', 'ZT_TOTAL' )	
			nTotalZTF += Round( nTotalZT , 2 )
	   	
	   	Next nI24
	   	
	 Next nI23  	
	 
	 //***************************** OUTROS CUSTOS PLANEJADO **********************************
	nCusto_CTD := oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' )
	nCusto_CTD2 := oModel:GetValue( 'CTDMASTER', 'CTD_XCUPRP' )
	nCusto_CTD3 := oModel:GetValue( 'CTDMASTER', 'CTD_XCUPRR' )
	
	
	
	////
	
	For nI6 := 1 To oModelSZH:Length()
		oModelSZH:GoLine( nI6 ) 
			nPercentSZH		:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROC' )
			cTipoOCCTD			:= ALLTRIM(oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' ))
			if  cTipoOCCTD = 'PGT' .OR.  cTipoOCCTD = 'CFI' .OR.  cTipoOCCTD = 'RTY' .OR.  cTipoOCCTD = 'PIP' .OR.  cTipoOCCTD = 'FNC'
			//nCuTot_CTD
				nTotalSZH := Round( nXVDSICTD , 2 ) * (Round( nPercentSZH , 2 )/100)
				oModelSZH:SetValue('ZH_CUSPLA', nTotalSZH )
				
				nPercentSZH2		:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROCR' )
				nTotalSZH2 := Round( nXVDSICTD3 , 2 ) * (Round( nPercentSZH2 , 2 )/100)
				
				oModelSZH:SetValue('ZH_CUREV', nTotalSZH2)
			ELSEif  cTipoOCCTD = 'COM' 
			//nCuTot_CTD
				nTotalSZH := Round( nXSISFP , 2 ) * (Round( nPercentSZH , 2 )/100)
				oModelSZH:SetValue('ZH_CUSPLA', nTotalSZH )
				
				nPercentSZH2		:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROCR' )
				nTotalSZH2 := Round( nXSISFR , 2 ) * (Round( nPercentSZH2 , 2 )/100)
				
				oModelSZH:SetValue('ZH_CUREV', nTotalSZH2)
			ELSE
				nTotalSZH := Round( nCusto_CTD2 , 2 ) * (Round( nPercentSZH , 2 )/100)
				oModelSZH:SetValue('ZH_CUSPLA', nTotalSZH )
				
				nPercentSZH2		:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROCR' )
				nTotalSZH2 := Round( nCusto_CTD3, 2 ) * (Round( nPercentSZH2 , 2 )/100)
				
				oModelSZH:SetValue('ZH_CUREV', nTotalSZH2)
			ENDIF
	Next nI6
	
	///////////////////////////////Custo Planejado //////////////////////////////////////////////////////
	
	////////////////////////////////RESUMO CUSTOS //////////////////////////////////////////////////
	// CUSTO PRODUCAO VENDIDO
	/*
	For nI33 := 1 To oModelSZF:Length()
			oModelSZF:GoLine( nI33 ) 
									
			nTOTVSI_ZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVSI' ) // Preco de Venda s/ Tributos
			nTOTVSI_FIN_ZF  += Round( nTOTVSI_ZF , 2 )
			
			nTotalZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTAL' ) // Custo de Producao
			nTotalSZF_RES += Round( nTotalZF , 2 )
			
			nVlrCont2 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCONT' ) // Contingencias
	   		nVlrCont2_FIN	+= nVlrCont2	
					
			nCCONT_RES		:= oModel:GetValue( 'SZFDETAIL', 'ZF_CCONT' ) // Custo de Producao + Contingencias
			nCCONT_RES_FIN += Round( nTOTVSI_RES , 2 )
			
			nVlrComZF	   := oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCOM' ) // Comissao
	   		nVlrComZF_FIN  	+=  nVlrComZF
	   		  		
	   		nVlrFIAZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRFIAN' ) // FIANCAS
	   		nVlrFIAZF_FIN 	+= nVlrFIAZF
	   		
	   		nVlrCFINZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCFIN' ) // CUSTO FINANCEIRO
	   		nVlrCFINZF_FIN 	+= nVlrCFINZF
	   		
	   		nVlrPIMPZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCFIN' ) // PERDA DE IMPOSTOS
	   		nVlrPIMPZF_FIN 	+= nVlrPIMPZF
	   		
	   		nVlrGARZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRCFIN' ) // GARANTIA
	   		nVlrGARZF_FIN 	+= nVlrGARZF
	   		
	   		nVlrRoyZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRROY' ) // ROYALTY
	   		nVlrRoyZF_FIN	+= nVlrRoyZF
	   		
	   		nVlrOCZF		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLROCUS' ) // Outro Custos
	   		nVlrOCZF_FIN 	+= nVlrOCZF
			
			nVlrMKP2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRMKP' )
			nVlrMKP2_FIN	+= nVlrMKP2
			
			nVlrMKPB2		:= oModel:GetValue( 'SZFDETAIL', 'ZF_VLRMKPB' )
			nVlrMKPB2_FIN	+= nVlrMKPB2
			
			nTotVSI2 		:= oModel:GetValue( 'SZFDETAIL', 'ZF_TOTVSI' )
	   		nTotVSI2_FIN	+= nTotVSI2		
				   								
	Next nI33
	
	nTotOCR_VD	:=  nVlrComZF_FIN + nVlrFIAZF_FIN + nVlrCFINZF_FIN + nVlrPIMPZF_FIN + nVlrGARZF_FIN + nVlrRoyZF_FIN//+ nTotalZFContig_VD + nTotalZFOCUS_VD + nTotalZFROY_VD

	nPMKPFIN2		:= (nVlrMKP2_FIN / nTotVSI2_FIN) * 100
	nPMKPBFIN2		:= (nVlrMKPB2_FIN / nTotVSI2_FIN) * 100
	
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_DESCRI', "VENDIDO" )
	oModelSZN:SetValue('ZN_PVSFRT', nXVDSICTD)	
	oModelSZN:SetValue('ZN_PVCFRT', nXVDSICTD )
	oModelSZN:SetValue('ZN_CUSTO', nTotalSZF_RES )
	oModelSZN:SetValue('ZN_CONTIG', nVlrCont2_FIN )
	oModelSZN:SetValue('ZN_CUPRD', nCCONT_RES_FIN )
	oModelSZN:SetValue('ZN_OCFIA', nVlrFIAZF_FIN )
	oModelSZN:SetValue('ZN_OCFIN', nVlrCFINZF_FIN )
	oModelSZN:SetValue('ZN_OCPIP', nVlrPIMPZF_FIN )
	oModelSZN:SetValue('ZN_OCGAR', nVlrGARZF_FIN )
	oModelSZN:SetValue('ZN_OCCOM', nVlrComZF_FIN )
	oModelSZN:SetValue('ZN_OCROY', nVlrRoyZF_FIN )
	oModelSZN:SetValue('ZN_OUOUT', nVlrOCZF_FIN )
	
	nTotalVendido := nTotalSZF_RES + nTotOCR_VD 
	oModelSZN:SetValue('ZN_CUSTOT', nTotalVendido ) 
	
	if (nXVDSICTD - nCCONT_RES_FIN) = nXVDSICTD
		oModelSZN:SetValue('ZN_VLRMB', 0 )
	else
		nVlrMargBR_ZF		:= nXVDSICTD - nCCONT_RES_FIN
		oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	endif
	
	if ((nVlrMargBR_ZF / nXVDSICTD) * 100)  = 100
		oModelSZN:SetValue('ZN_PERMB', 0 )
	else
		nPerMargBR_ZF		:= (nVlrMargBR_ZF / nXVDSICTD) * 100 
		oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	endif
	
	if ( nXVDSICTD - nTotalVendido ) = nXVDSICTD
		oModelSZN:SetValue('ZN_VLRCTB', 0 )
	else
		nVlrMargContr_ZF		:= ( nXVDSICTD - nTotalVendido ) 
		oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	endif
	
	if ( nVlrMargContr_ZF / nXVDSICTD )* 100 = 100
		oModelSZN:SetValue('ZN_PERCTB', 0 )
	else
		nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nXVDSICTD )* 100
		oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	endif
	*/
	//***************************** CUSTO PLANEJADO ***************************************
		
	For nI35 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI35 ) 
			cTipoOC1			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )
			if cTipoOC1 == "CFI"
				nTipoOC_CFI		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_CFI)
				nTipoOC_CFI := 0
			endif
	Next nI35
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCFIN', nTipoOC_CFI )
	
	For nI36 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI36 ) 
			cTipoOC2			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC2 == "CTG"
				nTipoOC_CTG		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_CTG)
				nTipoOC_CTG := 0
			endif
	Next nI36
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_CONTIG', nTipoOC_CTG )
		
	For nI37 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI37 ) 
			cTipoOC3			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )	
			if cTipoOC3 == "COM"		
				nTipoOC_COM		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_COM)
				nTipoOC_COM := 0
			endif
	Next nI37
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCCOM', nTipoOC_COM )
		
	For nI38 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI38 ) 
			cTipoOC4			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )			
			if cTipoOC4 == "FNC"			
				nTipoOC_FNC		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )			
			endif
			if Empty(nTipoOC_FNC)
				nTipoOC_FNC := 0
			endif
	Next nI38	
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCFIA', nTipoOC_FNC )
			
	For nI39 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI39 ) 
			cTipoOC5			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )	
			if cTipoOC5 == "PGT"			
				nTipoOC_PGT		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_PGT)
				nTipoOC_PGT := 0
			endif
	Next nI39
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCGAR', nTipoOC_PGT )
	
	For nI40 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI40 ) 
			cTipoOC6			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC6 == "PIP"			
				nTipoOC_PIP		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_PIP)
				nTipoOC_PIP := 0
			endif
	Next nI40
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCPIP', nTipoOC_PIP )
	
	For nI41 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI41 ) 
			cTipoOC7			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC7 == "RTY"	
				nTipoOC_RTY		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
			endif
			if Empty(nTipoOC_RTY)
				nTipoOC_RTY := 0
			endif	
	Next nI41
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_OCROY', nTipoOC_RTY )
	
	For nI10 := 1 To oModelSZC:Length()
			oModelSZC:GoLine( nI10 ) 
			nTotalZC		:= oModel:GetValue( 'SZCDETAIL', 'ZC_TOTAL' )	
			nTotalSZC_RES += Round( nTotalZC , 2 ) 
				   	
	Next nI10
	
	For nI11 := 1 To oModelSZJ:Length()
			oModelSZJ:GoLine( nI11 ) 
			nTotalZJ		:= oModel:GetValue( 'SZJDETAIL', 'ZJ_TOTAL' )	
			nTotalSZJ_RES += Round( nTotalZJ , 2 ) 
				   	
	Next nI11
	
	nTotalSZC_SZJ := nTotalSZC_RES + nTotalSZJ_RES
			
	//oModelSZN:AddLine() 
	oModelSZN:GoLine( 1 )
	oModelSZN:SetValue('ZN_DESCRI', "PLANEJADO" )
	oModelSZN:SetValue('ZN_PVSFRT', nXSISFP)	
	oModelSZN:SetValue('ZN_PVCFRT', nXVDSICTD2 )
	oModelSZN:SetValue('ZN_CUSTO', nTotalSZC_SZJ )
	
	oModelSZN:SetValue('ZN_CUPRD', nTotalSZC_SZJ + nTipoOC_CTG   ) // + nTipoOC_CTG
	
	oModelSZN:SetValue('ZN_OUOUT', nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY )
	
	oModelSZN:SetValue('ZN_CUSTOT', nTotalSZC_SZJ +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG   ) //
	
	if (nXVDSICTD2 - (nTotalSZC_SZJ + nTipoOC_CTG)) = nXVDSICTD2
		oModelSZN:SetValue('ZN_VLRMB', 0 )
	else
		nVlrMargBR_ZF		:= nXVDSICTD2 - (nTotalSZC_SZJ + nTipoOC_CTG)
		oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	endif
	
	if ((nVlrMargBR_ZF / nXVDSICTD2) * 100 ) = 100
		oModelSZN:SetValue('ZN_PERMB', 0 )
	else
		nPerMargBR_ZF		:= (nVlrMargBR_ZF / nXVDSICTD2) * 100 
		oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	endif
	
	if ( nXVDSICTD2 - (nTotalSZC_SZJ +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) ) = nXVDSICTD2
		oModelSZN:SetValue('ZN_VLRCTB', 0 )
	else
		nVlrMargContr_ZF		:= ( nXVDSICTD2 - (nTotalSZC_SZJ +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) ) 
		oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	endif
	
	if (( nVlrMargContr_ZF / nXVDSICTD2 )* 100) = 100
		oModelSZN:SetValue('ZN_PERCTB', 0 )
	else
		nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nXVDSICTD2 )* 100
		oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	endif
	
	IF nTotalSZC_SZJ > oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' ) 
		msgalert ( "Custo de Producao Planejado maior que Custo Vendido." )
	Endif
	
	if (nTotalSZC_SZJ +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) > oModel:GetValue( 'CTDMASTER', 'CTD_XCUTOT' )
		msgalert ( "Custo de Total Planejado maior que Custo Vendido." )
	endif
	
	
	oModelCTD:SetValue('CTD_XCUPRP', nTotalSZC_SZJ )
	oModelCTD:SetValue('CTD_XCUTOP', nTotalSZC_SZJ +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG   )
	//***************************** CUSTO REVISADO ***************************************

	For nI53 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI53 ) 
			cTipoOC1			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )
			if cTipoOC1 == "CFI"
				nTipoOC_CFI		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(nTipoOC_CFI)
				nTipoOC_CFI := 0
			endif
	Next nI53
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCFIN', nTipoOC_CFI )
	
	For nI54 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI54 ) 
			cTipoOC2			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC2 == "CTG"
				nTipoOC_CTG		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(nTipoOC_CTG)
				nTipoOC_CTG := 0
			endif
	Next nI54
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_CONTIG', nTipoOC_CTG )
	
	
		
	For nI61 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI61 ) 
			cTipoOC_comRev			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )	
			if cTipoOC_comRev = "COM"		
				nTipoOC_comRev		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(cTipoOC_comRev)
				nTipoOC_comRev := 0
			endif
	Next nI61
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCCOM', nTipoOC_comRev )
		
	For nI55 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI55 ) 
			cTipoOC4			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )			
			if cTipoOC4 == "FNC"			
				nTipoOC_FNC		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )			
			endif
			if Empty(nTipoOC_FNC)
				nTipoOC_FNC := 0
			endif
	Next nI55	
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCFIA', nTipoOC_FNC )
			
	For nI56 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI56 ) 
			cTipoOC5			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )	
			if cTipoOC5 == "PGT"			
				nTipoOC_PGT		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(nTipoOC_PGT)
				nTipoOC_PGT := 0
			endif
	Next nI56
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCGAR', nTipoOC_PGT )
	
	For nI57 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI57 ) 
			cTipoOC6			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC6 == "PIP"			
				nTipoOC_PIP		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(nTipoOC_PIP)
				nTipoOC_PIP := 0
			endif
	Next nI57
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCPIP', nTipoOC_PIP )
	
	For nI58 := 1 To oModelSZH:Length()
			oModelSZH:GoLine( nI58 ) 
			cTipoOC7			:= oModel:GetValue( 'SZHDETAIL', 'ZH_TIPO' )		
			if cTipoOC7 == "RTY"	
				nTipoOC_RTY		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUREV' )
			endif
			if Empty(nTipoOC_RTY)
				nTipoOC_RTY := 0
			endif	
	Next nI58
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_OCROY', nTipoOC_RTY )

	
	For nI51 := 1 To oModelSZC:Length()
			oModelSZC:GoLine( nI51 ) 
			nTotalZV		:= oModel:GetValue( 'SZCDETAIL', 'ZC_TOTALR' )	
			nTotalSZV_RES += Round( nTotalZV , 2 ) 
				   	
	Next nI51
	
	
	For nI52 := 1 To oModelSZJ:Length()
			oModelSZJ:GoLine( nI52 ) 
			nTotalZM		:= oModel:GetValue( 'SZJDETAIL', 'ZJ_TOTALR' )	
			nTotalSZM_RES += Round( nTotalZM , 2 ) 
				   	
	Next nI52
	
	nXComRev := nTipoOC_comRev
	
	nTotalSZV_SZM := nTotalSZV_RES + nTotalSZM_RES
	
	oModelSZN:GoLine( 2 )
	oModelSZN:SetValue('ZN_DESCRI', "REVISADO" )
	
	//if Alltrim(cXCVP) <> "1"
		oModelSZN:SetValue('ZN_PVSFRT', nXSISFR)	
		oModelSZN:SetValue('ZN_PVCFRT', nXVDSICTD3 )
	//endif 
	
	oModelSZN:SetValue('ZN_CUSTO', nTotalSZV_SZM )
	
	oModelSZN:SetValue('ZN_CUPRD', nTotalSZV_SZM + nTipoOC_CTG   ) // + nTipoOC_CTG

	oModelSZN:SetValue('ZN_OUOUT',  nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY )
	
	
	oModelSZN:SetValue('ZN_CUSTOT', nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG   ) //
	
	if (nXVDSICTD3 - (nTotalSZV_SZM + nTipoOC_CTG)) = nXVDSICTD3
		oModelSZN:SetValue('ZN_VLRMB', 0 )
	else
		nVlrMargBR_ZF		:= nXVDSICTD3 - (nTotalSZV_SZM + nTipoOC_CTG)
		oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	endif
	
	if ((nVlrMargBR_ZF / nXVDSICTD3) * 100 ) = 100
		oModelSZN:SetValue('ZN_PERMB', 0 )
	else
		nPerMargBR_ZF		:= (nVlrMargBR_ZF / nXVDSICTD3) * 100 
		oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	endif
	
	if ( nXVDSICTD3 - (nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) ) = nXVDSICTD3
		oModelSZN:SetValue('ZN_VLRCTB', 0 )
	else
		nVlrMargContr_ZF		:= ( nXVDSICTD3 - (nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) ) 
		oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	endif
	
	if (( nVlrMargContr_ZF / nXVDSICTD )* 100) = 100
		oModelSZN:SetValue('ZN_PERCTB', 0 )
	else
		nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nXVDSICTD )* 100
		oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	endif
	
	IF nTotalSZV_SZM > oModel:GetValue( 'CTDMASTER', 'CTD_XCUSTO' ) 
		msginfo ( "Custo de Producao Revisado maior que Custo Vendido." )
	Endif
	
	if (nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) > oModel:GetValue( 'CTDMASTER', 'CTD_XCUTOT' )
		msginfo ( "Custo de Total R·evisado maior que Custo Vendido." )
	endif
		
	oModelCTD:SetValue('CTD_XCUPRR', nTotalSZV_SZM + nTipoOC_CTG   ) // + nTipoOC_CTG
	oModelCTD:SetValue('CTD_XCUTOR', nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG   ) //

		
	//***************************** CUSTO REAL ***************************************
	
	nTipoOC_comReal := 0
	For nI60 := 1 To oModelSD1B:Length()
			oModelSD1B:GoLine( nI60 ) 
			cTipoOC_comReal	:= alltrim(oModel:GetValue( 'SD1DETAILB', 'D1_XNATURE' ))	
			if cTipoOC_comReal = "6.21.00"		
				nTipoOC_comReal += oModel:GetValue( 'SD1DETAILB', 'D1_TOTAL' )	
			endif
			if Empty(nTipoOC_comReal)
				nTipoOC_comReal += 0
			endif
	Next nI60
	oModelSZN:GoLine( 3 )
	oModelSZN:SetValue('ZN_OCCOM', nTipoOC_comReal )
	
	
	For nI13 := 1 To oModelSC7:Length()
			oModelSC7:GoLine( nI13 ) 
			nTotalC7		:= oModel:GetValue( 'SC7DETAIL', 'C7_XTOTSI' )	
			nTotalSC7_RES += Round( nTotalC7 , 2 ) 
				   	
	Next nI13
	
	For nI14 := 1 To oModelSZ4:Length()
			oModelSZ4:GoLine( nI14 ) 
			nTotalZ4		:= oModel:GetValue( 'SZ4DETAIL', 'Z4_TOTVLR' )	
			nTotalSZ4_RES += Round( nTotalZ4 , 2 ) 
				   	
	Next nI14
	
	For nI104 := 1 To oModelSD1:Length()
			oModelSD1:GoLine( nI104 ) 
			nTotalD1		:= oModel:GetValue( 'SD1DETAIL', 'D1_CUSTO' )	
			nTotalSD1_RES += Round( nTotalD1 , 2 ) 
				   	
	Next nI104
	
	For nI16 := 1 To oModelSE2:Length()
			oModelSE2:GoLine( nI16 ) 
			nTotalE2		:= oModel:GetValue( 'SE2DETAIL', 'E2_VLCRUZ' )	
			nTotalSE2_RES += Round( nTotalE2 , 2 ) 
				   	
	Next nI16
	
	
	For nI16B := 1 To oModelCV4:Length()
			oModelCV4:GoLine( nI16B ) 
			nTotalCV4		:= oModel:GetValue( 'CV4DETAIL', 'CV4_VALOR' )	
			nTotalCV4_RES += Round( nTotalCV4 , 2 ) 
				   	
	Next nI16B
	
	
	For nI212 := 1 To oModelZZA:Length()
			oModelZZA:GoLine( nI212 ) 
			nTotalZZA		:= oModel:GetValue( 'ZZADETAIL', 'ZZA_VALOR' )	
			nTotalZZA_RES += Round( nTotalZZA , 2 ) 
				   	
	Next nI212

	nTotalSC7_SZ4 := nTotalSC7_RES + nTotalSZ4_RES + nTotalSD1_RES + nTotalSE2_RES + nTotalCV4_RES + nTotalZZA_RES
	
	
	oModelSZN:GoLine( 3 )
	
	oModelSZN:SetValue('ZN_DESCRI', "EMPENHADO" )
	
	oModelSZN:SetValue('ZN_PVSFRT', nXSISFR)	
	oModelSZN:SetValue('ZN_PVCFRT', nXVDSICTD3 )
	oModelSZN:SetValue('ZN_CUSTO', nTotalSC7_SZ4 - nTipoOC_comReal )
	
	oModelSZN:SetValue('ZN_CUPRD', nTotalSC7_SZ4  - nTipoOC_comReal   ) // + nTipoOC_CTG
	
	oModelSZN:SetValue('ZN_OUOUT', 0  )
	
	oModelSZN:SetValue('ZN_CUSTOT', nTotalSC7_SZ4   )
	
	nVlrMargBR_ZF		:= ( nXVDSICTD3 - (nTotalSC7_SZ4 - nTipoOC_comReal  ) )
	oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	
	nPerMargBR_ZF		:= (nVlrMargBR_ZF / nXVDSICTD3) * 100 
	oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	
	nVlrMargContr_ZF		:= ( nXVDSICTD3 - (nTotalSC7_SZ4 ) ) 
	oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	
	nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nXVDSICTD3 )* 100
	oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	
	
	
	//***************************** CUSTO SALDO ***************************************
		
	oModelSZN:GoLine( 4 )
	
	oModelSZN:SetValue('ZN_PVSFRT', 0)	
	oModelSZN:SetValue('ZN_PVCFRT', 0 )
	
	if nTotalSZV_SZM = 0
		oModelSZN:SetValue('ZN_CUSTO', 0   )
	else 
		oModelSZN:SetValue('ZN_CUSTO', nTotalSZV_SZM - (nTotalSC7_SZ4 - nTipoOC_comReal)   ) //nTotalSZV_SZM - (nTotalSC7_SZ4 - nTipoOC_comReal) 
	endif
	
	if nTipoOC_CTG = 0
		oModelSZN:SetValue('ZN_CONTIG', 0  ) //
	else
		oModelSZN:SetValue('ZN_CONTIG', nTipoOC_CTG - 0  ) //
	endif
	
	if (nTotalSZV_SZM + nTipoOC_CTG) = 0
		oModelSZN:SetValue('ZN_CUPRD', 0 )
	else
		oModelSZN:SetValue('ZN_CUPRD', (nTotalSZV_SZM + nTipoOC_CTG)  - (nTotalSC7_SZ4 - nTipoOC_comReal) ) //
	endif
	
	if nTipoOC_FNC = 0
		oModelSZN:SetValue('ZN_OCFIA', 0 )
	else
		oModelSZN:SetValue('ZN_OCFIA', nTipoOC_FNC - 0 ) // nTipoOC_FNC - 0
	endif
	
	if nTipoOC_CFI = 0
		oModelSZN:SetValue('ZN_OCFIN',0 ) //nTipoOC_CFI - 0
	else
		oModelSZN:SetValue('ZN_OCFIN', nTipoOC_CFI - 0 ) //nTipoOC_CFI - 0
	endif
	
	if nTipoOC_PGT = 0
		oModelSZN:SetValue('ZN_OCGAR', 0 ) //nTipoOC_PGT - 0 
	else
		oModelSZN:SetValue('ZN_OCGAR', nTipoOC_PGT - 0 ) //nTipoOC_PGT - 0
	endif
	
	if nTipoOC_PIP = 0
		oModelSZN:SetValue('ZN_OCPIP', 0 ) //nTipoOC_PIP - 0
	else
		oModelSZN:SetValue('ZN_OCPIP', nTipoOC_PIP - 0 ) //nTipoOC_PIP - 0
	endif
	
	if nXComRev = 0
		oModelSZN:SetValue('ZN_OCCOM', 0  ) //(nTipoOC_COM - nTipoOC_comReal)
	else
		oModelSZN:SetValue('ZN_OCCOM', ( nXComRev  - nTipoOC_comReal  )) //nTipoOC_RTY - 0 
	endif
	
	if  ( nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY) = 0
		oModelSZN:SetValue('ZN_OUOUT', 0 ) //(nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY) - nTipoOC_comReal
	else
		oModelSZN:SetValue('ZN_OUOUT', ( nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY) ) //(nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY) - nTipoOC_comReal
	end
	
	if (nTotalSZV_SZM +  nXComRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) = 0
		oModelSZN:SetValue('ZN_CUSTOT', 0) //(nTotalSZV_SZM +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) - nTotalSC7_SZ4
	else
		oModelSZN:SetValue('ZN_CUSTOT', (nTotalSZV_SZM +  nXComRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) - nTotalSC7_SZ4 ) //(nTotalSZV_SZM +  nTipoOC_COM + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG) - nTotalSC7_SZ4
	endif
	
	if (nTotalSZV_SZM + nTipoOC_CTG) - (nTotalSC7_SZ4 ) = 0
		oModelSZN:SetValue('ZN_VLRMB', 0 )
	else
		nVlrMargBR_ZF		:= ( (nTotalSZV_SZM + nTipoOC_CTG) - (nTotalSC7_SZ4 ) )
		oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	endif
	
	/*
	if (nVlrMargBR_ZF / nXVDSICTD) * 100  = 100
		oModelSZN:SetValue('ZN_PERMB', 0 )
	else
		nPerMargBR_ZF		:= (nVlrMargBR_ZF / nXVDSICTD) * 100 
		oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	endif
	
	if ((nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG ) - (nTotalSC7_SZ4 + nTipoOC_comReal))	 = 0	
		oModelSZN:SetValue('ZN_VLRCTB', 0 )
	else
		nVlrMargContr_ZF		:= ( (nTotalSZV_SZM +  nTipoOC_comRev + nTipoOC_CFI + nTipoOC_FNC + nTipoOC_PIP + nTipoOC_PGT + nTipoOC_RTY + nTipoOC_CTG ) - (nTotalSC7_SZ4 + nTipoOC_comReal) ) 
		oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	endif
	
	if (( nVlrMargContr_ZF / nXVDSICTD )* 100) = 100
		oModelSZN:SetValue('ZN_PERCTB', 0 )
	else
		nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nXVDSICTD )* 100
		oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	endif
*/
	//---------------------------- CUSTO CONTABILIZADO --------------------------------------
	
	xt := oModelCT430:Length() 
	
	//msginfo ( xt )

	For nI211 := 1 To oModelCT430:Length()
			oModelCT430:GoLine( nI211 ) 
			nCusto30T		:=  oModel:GetValue( 'CT4DETAIL30', 'CT4_DEBITO' ) - oModel:GetValue( 'CT4DETAIL30', 'CT4_CREDIT' )  
			//msginfo( nCusto30T ) 
						//nReceitaCT4 	:= Round(  nTotalCT4RD  , 2 ) 
			nCusto30R  += nCusto30T
			//msginfo( nCusto30R )
	Next nI211  

	/*
	nI210 := 0
	For nI210 := 1 To oModelCT4RC:Length()
			oModelCT4RC:GoLine( nI210 ) 
			//nCustoCT4D		:= oModel:GetValue( 'CT4DETAILRC', 'CT4_DEBITO' )  
			//nCustoCT4C		:= oModel:GetValue( 'CT4DETAILRC', 'CT4_CREDIT' )	
			//nCustoCT4RESC 	:= Round( nCustoCT4D - nCustoCT4C  , 2 ) 
			nCustoCT4RESC 	:= oModel:GetValue( 'CT4DETAILRC', 'CT4_DEBITO' )   - oModel:GetValue( 'CT4DETAILRCC', 'CT4_CREDIT' )
			nCustoCT4			+= nCustoCT4RESC
			
	Next nI210
*/
	
	nIX1 := 0

	
	For nIX1 := 1 To oModelCT4RD:Length()
			oModelCT4RD:GoLine( nIX1 ) 
			nTotalCT4RD		:= oModel:GetValue( 'CT4DETAILRD', 'CT4_CREDIT' ) - oModel:GetValue( 'CT4DETAILRD', 'CT4_DEBITO' ) 
			//msginfo( nTotalCT4RD )
			
			//nReceitaCT4 	:= Round(  nTotalCT4RD  , 2 ) 
			nReceitaCT4R += nTotalCT4RD
			 
	Next nIX1   


    
	For nI105 := 1 To oModelCT4CM:Length()
			oModelCT4CM:GoLine( nI105 )    
			nCT4Conta := ALLTRIM(oModel:GetValue( 'CT4DETAILCM', 'CT4_CONTA' ))
			if nCT4Conta = '621020001'
					nComissaoTotalCT4CM		:= oModel:GetValue( 'CT4DETAILCM', 'CT4_DEBITO' ) -  oModel:GetValue( 'CT4DETAILCM', 'CT4_CREDIT' )
				//msginfo( nTotalCT4RD )
				
				//nReceitaCT4 	:= Round(  nTotalCT4RD  , 2 ) 
				nComissaoCT4CM += nComissaoTotalCT4CM
			endif
				 
	Next nI105
	
	

	oModelSZN:GoLine( 5 )
	oModelSZN:SetValue('ZN_PVSFRT', nReceitaCT4R)	
	oModelSZN:SetValue('ZN_PVCFRT', nReceitaCT4R )
	
	oModelSZN:SetValue('ZN_CUSTO', nCusto30R ) 
	oModelSZN:SetValue('ZN_OCCOM', ( nComissaoCT4CM  )) //nTipoOC_RTY - 0 
	oModelSZN:SetValue('ZN_CUPRD', nCusto30R ) 
	
	oModelSZN:SetValue('ZN_CUSTOT', nCusto30R + nComissaoCT4CM)
	
	nVlrMargBR_ZF		:= ( nReceitaCT4R - nCusto30R  )
	oModelSZN:SetValue('ZN_VLRMB', nVlrMargBR_ZF )
	
	nPerMargBR_ZF		:= (nVlrMargBR_ZF / nReceitaCT4R) * 100 
	oModelSZN:SetValue('ZN_PERMB', nPerMargBR_ZF )
	
	nVlrMargContr_ZF		:= ( nReceitaCT4R - (nCusto30R + nComissaoCT4CM ) ) 
	oModelSZN:SetValue('ZN_VLRCTB', nVlrMargContr_ZF )
	
	nPerMargContr_ZF		:= ( nVlrMargContr_ZF / nReceitaCT4R )* 100
	oModelSZN:SetValue('ZN_PERCTB', nPerMargContr_ZF )
	
	
		

	msginfo ( "Atualizacao Gestao de Contratos realizada com sucesso." )
	 //Help( ,, 'Help',, 'Registro salvo com sucesso.', 2, 0 ) 
Return lRet


/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView     := Nil
    Local oModel        := FWLoadModel('zMVCMdX')
    Local oStPai        := FWFormStruct(2, 'CTD')
    Local oStPai2        := FWFormStruct(2, 'CTD')
    Local oStPai4        := FWFormStruct(2, 'CTD')
    Local oStFilho  	:= FWFormStruct(2, 'SZC')
    
    Local oStFilho30  := FWFormStruct(2, 'CT4')
    //Local oStFilhoCT4D  := FWFormStruct(2, 'CT4')
  
    //Local oStFilhoCT4RC 	:= FWFormStruct(2, 'CT4')
    Local oStFilhoCT4RD 	:= FWFormStruct(2, 'CT4')
    Local oStFilhoCT4CM 	:= FWFormStruct(2, 'CT4')
    Local oStFilho13  	:= FWFormStruct(2, 'SZV')
    Local oStFilho2  	:= FWFormStruct(2, 'SC7',{ |x| ALLTRIM(x) $ 'C7_FILIAL,C7_ITEMCTA, C7_XOC, C7_XIDFORN, C7_XDESCF,C7_ITEM, C7_PRODUTO, C7_DESCRI,C7_UM,C7_QUANT,C7_PRECO,C7_TOTAL,C7_XTOTSI,C7_ENCER'})
    Local oStFilho3  	:= FWFormStruct(2, 'SE2')
    //Local oStFilho3B  	:= FWFormStruct(2, 'SE2')
	Local oStFilho3C  	:= FWFormStruct(2, 'SE2')
    Local oStFilho3D  	:= FWFormStruct(2, 'SE2')
    Local oStFilho3E  	:= FWFormStruct(2, 'SE2')
    Local oStFilho15  	:= FWFormStruct(2, 'SE2')
    Local oStFilho3F  	:= FWFormStruct(2, 'SE2')
    //Local oStFilho3G  	:= FWFormStruct(2, 'SE2')
    //Local oStFilho4  	:= FWFormStruct(2, 'SE1')
    //Local oStFilho4B  	:= FWFormStruct(2, 'SE1')
    //Local oStFilho4C  	:= FWFormStruct(2, 'SE1')
    Local oStFilho5  	:= FWFormStruct(2, 'SZ4')
    Local oStFilho6A  	:= FWFormStruct(2, 'SZ9')
    Local oStFilho6  	:= FWFormStruct(2, 'SZF')
    Local oStFilho7  	:= FWFormStruct(2, 'SZH')
    Local oStFilho8  	:= FWFormStruct(2, 'SZI')
    Local oStFilho9  	:= FWFormStruct(2, 'SZJ')
    //Local oStFilho10  	:= FWFormStruct(2, 'SZM')
    Local oStFilho11  	:= FWFormStruct(2, 'SZN')
    Local oStFilho12  	:= FWFormStruct(2, 'SD1')
    Local oStFilho12B  	:= FWFormStruct(2, 'SD1')
    Local oStNeto       := FWFormStruct(2, 'SZD')
    Local oStNeto2      := FWFormStruct(2, 'SZG')
    Local oStNeto3      := FWFormStruct(2, 'SZO')
    Local oStNeto4      := FWFormStruct(2, 'SZP')
    Local oStNeto14      := FWFormStruct(2, 'SZX')
    Local oStNeto5      := FWFormStruct(2, 'SZT')
    Local oStNeto6      := FWFormStruct(2, 'SZU')
    Local oStFilhoCV4  	:= FWFormStruct(2, 'CV4')
    Local oStFilho31  	:= FWFormStruct(2, 'ZZA')
    //Local oStNeto6      := FWFormStruct(2, 'SZU')
      
    //Local oStTot        := FWCalcStruct(oModel:GetModel('TOT_SALDO'))
    //Estruturas das tabelas e campos a serem considerados
    Local aStruCTD  := CTD->(DbStruct())
    Local aStruCTD2  := CTD->(DbStruct())
    Local aStruCTD4  := CTD->(DbStruct())
    
   //Local aStruCT4CC  := CT4->(DbStruct())
    //Local aStruCT4D  := CT4->(DbStruct())
  
    Local aStru30 := CT4->(DbStruct())
    Local aStruCT4RD := CT4->(DbStruct())
    Local aStruCT4CM := CT4->(DbStruct())
    Local aStruSZC  := SZC->(DbStruct())
    Local aStruSZV  := SZV->(DbStruct())
    Local aStruSZX  := SZX->(DbStruct())
    Local aStruSZ9  := SZ9->(DbStruct())
    Local aStruSZF  := SZF->(DbStruct())
    Local aStruSZH  := SZH->(DbStruct())
    //Local aStruSZI  := SZI->(DbStruct())
    Local aStruSZJ  := SZJ->(DbStruct())
    //Local aStruSZM  := SZM->(DbStruct())
    Local aStruSZN  := SZN->(DbStruct())
    Local aStruSC7  := SC7->(DbStruct())
    Local aStruSE2  := SE2->(DbStruct())
    Local aStruSE2C  := SE2->(DbStruct())
    Local aStruSE2D  := SE2->(DbStruct())
    Local aStruSE2E  := SE2->(DbStruct())
    Local aStruSE2F  := SE2->(DbStruct())
    //Local aStruSD1G  := SE2->(DbStruct())
   
    //Local aStruSE2B := SE2->(DbStruct())
    //Local aStruSE1  := SE1->(DbStruct())
    //Local aStruSE1B := SE1->(DbStruct())
    //Local aStruSE1C := SE1->(DbStruct())
    Local aStruSZ4  := SZ4->(DbStruct())
    Local aStruSZD  := SZD->(DbStruct())
    Local aStruSZG  := SZG->(DbStruct())
    Local aStruSD1  := SD1->(DbStruct())
    Local aStruSD1B  := SD1->(DbStruct())
    Local aStruSZO  := SZO->(DbStruct())
    Local aStruSZP  := SZP->(DbStruct())
    Local aStruSZT  := SZT->(DbStruct())
    Local aStruZZA  := ZZA->(DbStruct())
    Local aStruSZU  := SZU->(DbStruct())
	Local aStruCV4	:= CV4->(DbStruct())
    Local cConsCTD  := "CTD_ITEM;CTD_XTIPO;CTD_XEQUIP;CTD_XCLIEN;CTD_XNREDU;CTD_XDESC;CTD_XVDCID;CTD_XVDSID;CTD_NPROP;CTD_DTEXIS;CTD_DTEXSF;CTD_XCVP;CTD_XPCONT;CTD_XCUSFI;CTD_XFIANC;CTD_XPROVG;CTD_XROYAL;CTD_XPCOM;CTD_XMKPIN;CTD_XAPV;CTD_XIDPM;CTD_XNOMPM;CTD_XDAPCT;CTD_XDTAVC;CTD_XDTAVR;CTD_XDTFAP;CTD_XDTFAR;CTD_XDTEVC;CTD_XDTEVR;CTD_XDTCOC;CTD_XDTCOP;CTD_XDTWK"
    Local cConsCTD2  := "CTD_XCUSTO;CTD_XCUTOT;CTD_XCUPRP;CTD_XCUTOP;CTD_XCUPRR;CTD_XCUTOR"
    Local cConsCTD4  := "CTD_XVDCI;CTD_XVDSI;CTD_XVDCIP;CTD_XVDSIPP;CTD_XVDCIR;CTD_XVDSIR;CTD_XSISFV;CTD_XSISFP;CTD_XSISFR"
    Local cCons30  := "CT4_FILIAL;CT4_ITEM;CT4_CONTA;CT4_MOEDA;CT4_DATA;CT4_DEBITO;CT4_CREDIT;CT4_LP;CT4_ATUDEB;CT4_ATUCRD;CT4_ANTDEB;CT4_ANTCRD"
    //Local cConsCT4D  := "CT4_FILIAL;CT4_ITEM;CT4_CONTA;CT4_MOEDA;CT4_DATA;CT4_DEBITO;CT4_CREDIT;CT4_LP;CT4_ATUDEB;CT4_ATUCRD;CT4_ANTDEB;CT4_ANTCRD"
    //Local cConsCT4RC := "CT4_FILIAL;CT4_ITEM;CT4_CONTA;CT4_MOEDA;CT4_DATA;CT4_DEBITO;CT4_CREDIT;CT4_LP;CT4_ATUDEB;CT4_ATUCRD;CT4_ANTDEB;CT4_ANTCRD"
    Local cConsCT4RD := "CT4_FILIAL;CT4_ITEM;CT4_CONTA;CT4_MOEDA;CT4_DATA;CT4_DEBITO;CT4_CREDIT;CT4_LP;CT4_ATUDEB;CT4_ATUCRD;CT4_ANTDEB;CT4_ANTCRD"
    Local cConsCT4CM := "CT4_FILIAL;CT4_ITEM;CT4_CONTA;CT4_MOEDA;CT4_DATA;CT4_DEBITO;CT4_CREDIT;CT4_LP;CT4_ATUDEB;CT4_ATUCRD;CT4_ANTDEB;CT4_ANTCRD"
    Local cConsSZC  := "ZC_IDPLAN;ZC_ITEMIC;ZC_CODPROD;ZC_DESCRI;ZC_DTPL;ZC_QUANT;ZC_UM;ZC_UNIT;ZC_TOTAL;ZC_DTRV;;ZC_QUANTR;ZC_UMR;ZC_UNITR;ZC_TOTALR;ZC_TOTEMP;ZC_SALDO"
    Local cConsSZV  := "ZV_IDREV;ZV_ITEMIC;ZV_DESCRI;ZV_QUANT;ZV_UM;ZV_UNIT;ZV_TOTAL"
    Local cConsSZ9  := "Z9_FILIAL;Z9_NPROP;Z9_IDCONTR;Z9_CONTR;Z9_IDCLFIN;Z9_CLIFIN;Z9_IDRESP;Z9_RESP;Z9_LOCAL;Z9_PROJETO"
    Local cConsSZF  := "ZF_IDVEND;ZF_ITEMIC;ZF_CODPROD;ZF_DESCRI;ZF_QUANT;ZF_UM;ZF_TOTAL;ZF_MKPINI;ZF_MKPFIN;ZF_UNITVSI;ZF_TOTVSI;ZF_UNITVCI;ZF_TOTVCI;ZF_VLRMKP;ZF_VLRMKPB;ZF_VLRCONT;ZF_CCONT;ZF_VLRPIMP;ZF_VLRFIAN;ZF_VLRCFIN;ZF_VLRGAR;ZF_VLRPVIN;ZF_VLROCUS;ZF_VLRROY;ZF_VLRCOM;ZF_VLRROY;ZF_CALC;ZF_OBS;ZF_NPROP,ZF_ITEMIC"
    Local cConsSZH  := "ZH_FILIAL;ZH_ITEMIC;ZH_ITEM;ZH_TIPO;ZH_DESCRI;ZH_PEROC;ZH_CUSPLA;ZH_PEROCR;ZH_CUREV"
    //Local cConsSZI  := "ZI_FILIAL;ZI_ITEMIC;ZI_ITEM;ZI_TIPO;ZI_DESCRI;ZI_PERCENT;ZI_CUSVEN"
    Local cConsSZJ  := "ZJ_ITEMIC;ZJ_ITEM;ZJ_TPSERV;ZJ_SERVICO;ZJ_HORAS;ZJ_VLRHR;ZJ_TOTAL;ZJ_HORASR;ZJ_VLRHRR;ZJ_TOTALR;ZJ_HORASV;ZJ_VLRHRV;ZJ_TOTALV"
    //Local cConsSZM  := "ZM_ITEMIC;ZM_ITEM;ZM_TPSERV;ZM_SERVICO;ZM_HORAS;ZM_VLRHR;ZM_TOTAL"
    Local cConsSZN  := "ZN_ITEMIC;ZN_ITEM;ZN_DESCRI;ZN_STATUS;ZN_PVSFRT;ZN_PVCFRT;ZN_CUSTO;ZN_CONTIG;ZN_CUPRD;ZN_OCFIN;ZN_OCFIA;ZN_OCPIP;ZN_OCGAR;ZN_OUOUT;ZN_OCCOM;;ZN_OCROY;ZN_CUSTOT;ZN_VLRMB;ZN_PERMB;ZN_VLRCTB;ZN_PERCTB"
    Local cConsSC7  := "C7_FILIAL;C7_ITEMCTA;C7_XOC;C7_XIDFORN;C7_XDESCF;C7_ITEM;C7_PRODUTO;C7_DESCRI;C7_UM;C7_QUANT;C7_PRECO;C7_TOTAL;C7_XTOTSI;C7_ENCER"
    Local cConsSZD  := "ZD_FILIAL;ZD_IDPLAN;ZD_IDPLSUB;ZD_ITEM;ZD_QUANT;ZD_CODPROD;ZD_GRUPO;ZD_DESCRI;ZF_QUANT;ZD_UM;ZD_UNIT;ZD_TOTAL;ZD_DTPL;ZD_DTRV;ZD_QUANTR;ZD_UMR;ZD_UNITR;ZD_TOTALR;ZD_TOTEMP;ZD_SALDO;ZD_ITEMIC;ZD_GRUPO"
    Local cConsSZX  := "ZX_FILIAL;ZX_IDREV;ZX_IDRVSUB;ZX_ITEM;ZX_QUANT;ZX_GRUPO;ZX_DESCRI;ZX_QUANT;ZX_UM;ZX_UNIT;ZX_TOTAL"
    Local cConsSZG  := "ZG_FILIAL;ZG_IDVEND;ZG_IDVDSUB;ZG_ITEM;ZG_QUANT;ZG_CODPROD;ZG_DESCRI;ZG_QUANT;ZG_UNIT;ZG_UM;ZG_TOTAL; ZG_PVA;ZG_POC;ZG_PCONT;;ZG_CUSFIN;ZG_FIANCAS;ZG_PROVGR;ZG_PERDIMP;ZG_PROYALT;ZG_PCOMIS;ZG_PDESC;;ZG_PMKP;ZG_UNITVSI;ZG_TOTVSI;ZG_PVA;ZG_PPIS;ZG_PCOF;ZG_PICMS;ZG_PIPI;ZG_PISS;ZG_UNITVCI;ZG_TOTVCI;ZG_MKPFIN;ZG_VLRMKP;ZG_VLRPIS;ZG_VLRCOF;ZG_VLRICM;ZG_VLRIPI;ZG_VLRISS;ZG_VLRCONT;ZG_VLRCONT;ZG_CCONT;ZG_VLRMBRT;ZG_PMBRT;;ZG_VLRPVIN;ZG_VLRPIMP;ZG_VLRFIAN;ZG_VLRCFIN;ZG_VLRGAR;ZG_VLROCUS;ZG_VLRROY;ZG_VLRCOM;ZG_VLRDESC;ZG_VLRPSIP"
    Local cConsSZO  := "ZO_FILIAL;ZO_IDPLSUB;ZO_IDPLSB2;ZO_ITEM;ZO_QUANT;ZO_UM;ZO_CODPROD;ZO_DESCRI;ZO_UNIT;ZO_TOTAL;ZO_DTPL;ZO_DTRV;ZO_QUANTR;ZO_UMR;ZO_UNITR;ZO_TOTALR;ZO_TOTEMP;ZO_SALDO;ZO_ITEMIC;ZO_GRUPO"
    Local cConsSZU  := "ZU_FILIAL;ZU_IDPLSB3;ZU_IDPLSB2;ZU_ITEM;ZU_QUANT;ZU_UM;ZU_DESCRI;ZU_UNIT;ZU_TOTAL;ZU_QUANTR;ZU_UMR;ZU_UNITR;ZU_TOTALR;ZU_TOTEMP;ZU_SALDO;ZU_ITEMIC"
    Local cConsSZP  := "ZP_FILIAL;ZP_IDVDSUB;ZP_IDVDSB2;ZP_ITEM;ZP_QUANT;ZP_CODPROD;ZP_DESCRI;ZP_UNIT;ZP_TOTAL;ZP_OBS;ZP_NPROP"
    Local cConsSZT  := "ZT_FILIAL;ZT_IDVDSB3;ZT_IDVDSB2;ZT_ITEM;ZT_QUANT;ZT_UM;ZT_CODPROD;ZT_DESCRI;ZT_UNIT;ZT_PESO;ZT_TOTAL;ZT_NPROP"
    Local cConsSE2  := "E2_FILIAL;E2_NUM;E2_TIPO;E2_NATUREZ;E2_VENCTO;E2_VENCREA;E2_BAIXA;E2_VLCRUZ;E2_VALOR;E2_XCUSTII,E2_SALDO;E2_FORNECE;E2_NOMFOR;"
    Local cConsSE2C := "E2_FILIAL;E2_NUM;E2_TIPO;E2_NATUREZ;E2_VENCTO;E2_VENCREA;E2_BAIXA;E2_VLCRUZ;E2_VALOR;E2_SALDO;E2_FORNECE;E2_NOMFOR;"
    Local cConsSE2D := "E2_FILIAL;E2_NUM;E2_TIPO;E2_NATUREZ;;E2_VENCTO;E2_VENCREA;E2_BAIXA;E2_VLCRUZ;E2_VALOR;E2_SALDO;E2_FORNECE;E2_NOMFOR;"
    Local cConsSE2E := "E2_FILIAL;E2_NUM;E2_TIPO;E2_NATUREZ;E2_VENCTO;E2_VENCREA;E2_BAIXA;E2_VLCRUZ;E2_VALOR;E2_SALDO;E2_FORNECE;E2_NOMFOR;"
    Local cConsSE2F := "E2_FILIAL;E2_NUM;E2_TIPO;E2_NATUREZ;E2_VENCTO;E2_VENCREA;E2_BAIXA;E2_VLCRUZ;E2_VALOR;E2_SALDO;E2_FORNECE;E2_NOMFOR;"
    Local cConsSD1B := "D1_ITEMCTA,D1_DOC;D1_EMISSAO;D1_FORNECE;áD1_TOTAL;D1_CF;D1_XTIPO;D1_XNATURE"
    //Local cConsSE1  := "E1_FILIAL;E1_NUM;E1_TIPO;E1_VENCTO;E1_VENCREA;E1_BAIXA;E1_VLCRUZ;E1_VALOR;E1_SALDO" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
    //Local cConsSE1B := "E1_FILIAL;E1_NUM;E1_TIPO;E1_VENCTO;E1_VENCREA;E1_BAIXA;E1_VLCRUZ;E1_VALOR;E1_SALDO"
    //Local cConsSE1C := "E1_FILIAL;E1_NUM;E1_TIPO;E1_VENCTO;E1_VENCREA;E1_BAIXA;E1_VLCRUZ;E1_VALOR;E1_SALDO"
    Local cConsSZ4  := "Z4_FILIAL;Z4_DATA;Z4_COLAB;Z4_ITEMCTA;Z4_QTDHRS;Z4_TOTVLR;Z4_TAREFA"
    //Local cConsSZ4  := "Z4_FILIAL;Z4_IDAPTHR;Z4_COLAB;Z4_COLAB;Z4_ITEM;Z4_ITEMCTA;Z4_QTDHRS;Z4_TOTVLR;Z4_TAREFA;Z4_DESCR"
    Local cConsSD1  := "D1_FILIAL;D1_ITEMCTA;D1_DOC;D1_EMISSAO;D1_FORNECE;D1_XNFORN;D1_TOTAL;D1_CUSTO;D1_CF;D1_PEDIDO;D1_XTIPO"
    Local cConsZZA  := "ZZA_FILIAL;ZZA_NUM;ZZA_DATA;ZZA_TIPO;ZZA_DESCR;ZZA_VALOR;ZZA_ITEMIC"
    Local nAtual        := 0
     
    //Criando a View
	
	//Local oStrSZC:= FWCalcStruct( oModel:GetModel('calcSZC') )
	//Local oStrSZF:= FWCalcStruct( oModel:GetModel('calcSZF') )
	Local oStrSZI:= FWCalcStruct( oModel:GetModel('calcSZI') )
	Local oStrSZM:= FWCalcStruct( oModel:GetModel('calcSZM') )
	Local oStrSC7:= FWCalcStruct( oModel:GetModel('calcSC7') )
	Local oStrCT4:= FWCalcStruct( oModel:GetModel('calcCT4') )
	
	
	
	//Local oStrSE1:= FWCalcStruct( oModel:GetModel('calcSE1') )
	//Local oStrSE2:= FWCalcStruct( oModel:GetModel('calcSE2P') )
	//Local oStrSD1:= FWCalcStruct( oModel:GetModel('calcSD1') )
	 
    oView := FWFormView():New()
    
    oView:SetModel(oModel)
   
    //Adicionando os campos do cabeçalho e o grid dos filhos
    //oView:AddField('VIEW_CTD',oStPai,'CTDMASTER')
    
    
    oView:AddField('VIEW_CTD3',oStPai,'CTDMASTER')
    oView:AddField('VIEW_CTD2',oStPai2,'CTDMASTER')
    oView:AddField('VIEW_CTD4',oStPai4,'CTDMASTER')
    oView:AddGrid('VIEW_SZ9',oStFilho6A,'SZ9DETAIL')
    oView:AddGrid('VIEW_CT430',oStFilho30,'CT4DETAIL30')
    //oView:AddGrid('VIEW_CT4D',oStFilhoCT4D,'CT4DETAILD')
  
   // oView:AddGrid('VIEW_CT4RC',oStFilhoCT4RC,'CT4DETAILRC')
    oView:AddGrid('VIEW_CT4RD',oStFilhoCT4RD,'CT4DETAILRD')
    oView:AddGrid('VIEW_CT4CM',oStFilhoCT4CM,'CT4DETAILCM')
    //oView:AddField('VIEW_CTD4',oStPai,'CTDMASTER')
    oView:AddGrid('VIEW_SZC',oStFilho,'SZCDETAIL')
    //oView:AddGrid('VIEW_SZV',oStFilho13,'SZVDETAIL')
    oView:AddGrid('VIEW_SZF',oStFilho6,'SZFDETAIL')
    oView:AddGrid('VIEW_SZH',oStFilho7,'SZHDETAIL')
    //oView:AddGrid('VIEW_SZI',oStFilho8,'SZIDETAIL')
    oView:AddGrid('VIEW_SZJ',oStFilho9,'SZJDETAIL')
    //oView:AddGrid('VIEW_SZM',oStFilho10,'SZMDETAIL')
    oView:AddGrid('VIEW_SZN',oStFilho11,'SZNDETAIL')
    oView:AddGrid('VIEW_SC7',oStFilho2,'SC7DETAIL')
    oView:AddGrid('VIEW_SE2',oStFilho3,'SE2DETAIL')
    oView:AddGrid('VIEW_SE2C',oStFilho3C,'SE2DETAILC')
    oView:AddGrid('VIEW_SE2D',oStFilho3D,'SE2DETAILD')
    oView:AddGrid('VIEW_SE2E',oStFilho3E,'SE2DETAILE')
    oView:AddGrid('VIEW_SE2F',oStFilho3F,'SE2DETAILF')
    oView:AddGrid('VIEW_SD1B',oStFilho12B,'SD1DETAILB')
    //oView:AddGrid('VIEW_SE1',oStFilho4,'SE1DETAIL')
    //oView:AddGrid('VIEW_SE1B',oStFilho4B,'SE1DETAILB')
    //oView:AddGrid('VIEW_SE1C',oStFilho4C,'SE1DETAILC')
    oView:AddGrid('VIEW_SZ4',oStFilho5,'SZ4DETAIL')
    oView:AddGrid('VIEW_SZD',oStNeto,'SZDDETAIL')
    //oView:AddGrid('VIEW_SZX',oStNeto14,'SZXDETAIL')
    oView:AddGrid('VIEW_SZG',oStNeto2,'SZGDETAIL')
    oView:AddGrid('VIEW_SD1',oStFilho12,'SD1DETAIL')
    oView:AddGrid('VIEW_SZO',oStNeto3,'SZODETAIL')
    oView:AddGrid('VIEW_SZP',oStNeto4,'SZPDETAIL')
    oView:AddGrid('VIEW_SZT',oStNeto5,'SZTDETAIL')
    oView:AddGrid('VIEW_CV4',oStFilhoCV4,'CV4DETAIL')
    oView:AddGrid('VIEW_ZZA',oStFilho31,'ZZADETAIL')
    oView:AddGrid('VIEW_SZU',oStNeto6,'SZUDETAIL')
	
	//oView:AddField('formCalcPla', oStrSZC,'calcSZC')
	//oView:AddField('formCalcVen', oStrSZF,'calcSZF')
	oView:AddField('formCalcOCV', oStrSZI,'calcSZI')
	oView:AddField('formCalcHRV', oStrSZM,'calcSZM')
	oView:AddField('formCalcCom', oStrSC7,'calcSC7')
	oView:AddField('formCalcCT4', oStrCT4,'calcCT4')
	//oView:AddField('formCalcRec', oStrSE1,'calcSE1')
	//oView:AddField('formCalcPag', oStrSE2,'calcSE2P')
	
    //oView:AddField('VIEW_TOT', oStTot,'TOT_SALDO')
    //Setando o dimensionamento de tamanho
     
    oView:CreateFolder( 'FOLDER1')
    oView:AddSheet('FOLDER1','SHEET9','Resumo')
    oView:AddSheet('FOLDER1','SHEET4','Vendido')
    oView:AddSheet('FOLDER1','SHEET1','Planejado / Revisado')
	oView:AddSheet('FOLDER1','SHEET2','Custo Real')
	oView:AddSheet('FOLDER1','SHEET13','Controle de Horas')
	oView:AddSheet('FOLDER1','SHEET11','Custos Diversos')
	oView:AddSheet('FOLDER1','SHEET22','Custos Diversos 2')
	//oView:AddSheet('FOLDER1','SHEET5','Contas a Receber')
	oView:AddSheet('FOLDER1','SHEET20','Contas a Pagar')
	oView:AddSheet('FOLDER1','SHEET21','Contabil')
	
	
		
	oView:CreateHorizontalBox('GRID2A',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2B',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2C',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	oView:CreateHorizontalBox('GRID2D',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 1 - Planejado
	//oView:CreateVerticalBox('GRIDA',50, 'GRID', /*lUsePixel*/, 'FOLDER1', 'SHEET1') 		// Nivel 1 - Planejado
	//oView:CreateVerticalBox('GRIDB',50, 'GRID', /*lUsePixel*/, 'FOLDER1', 'SHEET1') 		// Nivel 1 - Planejado
	
	//oView:CreateHorizontalBox('GRID2',100,  /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 		// Nivel 1 - Planejado
    //oView:CreateVerticalBox('GRID2A',25, 'GRID2', /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 2 - Planejado 
	//oView:CreateVerticalBox('GRID2B',25, 'GRID2', /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 2 - Planejado
		
	//oView:CreateHorizontalBox('GRID2A1',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 3 - Planejado 
	//oView:CreateHorizontalBox('GRID19',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	//oView:CreateVerticalBox('GRID2A1A',50,'GRID2A1', /*lUsePixel*/, 'FOLDER1', 'SHEET1')	// Nivel 3 - Vendido
	//oView:CreateVerticalBox('GRID2A1B',50,'GRID2A1', /*lUsePixel*/, 'FOLDER1', 'SHEET1')	// Nivel 3 - Vendido
		
	//oView:CreateHorizontalBox('GRID18',35, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1') 	// Nivel 3 - Planejado 
        
	oView:CreateHorizontalBox('GRID3',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')	// Custo Real Compras
 	oView:CreateHorizontalBox('GRID14',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')	// Custo Real Doc. Entrada

	
	//oView:CreateHorizontalBox('GRID5',80, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET5') 	// Contas a Receber
	//oView:CreateHorizontalBox('GRID17',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET5')	// Contas a Receber
	//oView:CreateVerticalBox('GRID5C',34, 'GRID5', /*lUsePixel*/, 'FOLDER1', 'SHEET5')	// Contas a Receber Antecipado
	//oView:CreateVerticalBox('GRID5A',33, 'GRID5', /*lUsePixel*/, 'FOLDER1', 'SHEET5')	// Contas a Receber
	//oView:CreateVerticalBox('GRID5B',33, 'GRID5', /*lUsePixel*/, 'FOLDER1', 'SHEET5')	// Contas a Receber
	
	oView:CreateHorizontalBox('GRID20',50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET20') 	// Contas a Pagar
	oView:CreateVerticalBox('GRID20C',34, 'GRID20', /*lUsePixel*/, 'FOLDER1', 'SHEET20')	// Contas a Pagar
	oView:CreateVerticalBox('GRID20D',33, 'GRID20', /*lUsePixel*/, 'FOLDER1', 'SHEET20')	// Contas a Pagar
	oView:CreateVerticalBox('GRID20E',33, 'GRID20', /*lUsePixel*/, 'FOLDER1', 'SHEET20')	// Contas a Pagar
	oView:CreateHorizontalBox('GRID21',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET20') 	// Contas a Pagar
		
	oView:CreateHorizontalBox('CABEC3',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('CABEC2',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('CABEC4',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	oView:CreateHorizontalBox('BOX56',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Resumo
	oView:CreateHorizontalBox('BOXPP',0, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Proposta	
 
    oView:CreateHorizontalBox('GRID11',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Vendido
	oView:CreateVerticalBox('GRID11A',50, 'GRID11', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRID11B',50, 'GRID11', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
    oView:CreateHorizontalBox('GRID4',50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos /Real
	oView:CreateVerticalBox('GRID4A',50, 'GRID4', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRID4B',50, 'GRID4', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado

    //oView:CreateHorizontalBox('GRID13',25, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET13') 	// Horas Vendido
	oView:CreateHorizontalBox('GRID12',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET13')	// Horas Planejado/Revisado
	oView:CreateVerticalBox('GRID12B',100, 'GRID12', /*lUsePixel*/, 'FOLDER1', 'SHEET13')	// Horas Vendido 
	//oView:CreateVerticalBox('GRID12A',50, 'GRID12', /*lUsePixel*/, 'FOLDER1', 'SHEET13')	// Horas Revisaod 
    oView:CreateHorizontalBox('GRID6',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET13')	// Horas Real 

	oView:CreateHorizontalBox('GRID7',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
	oView:CreateVerticalBox('GRID7A',100, 'GRID7', /*lUsePixel*/, 'FOLDER1', 'SHEET4') 		// Nivel 1 - Vendido

	//oView:CreateVerticalBox('GRID7B',20, 'GRID7', /*lUsePixel*/, 'FOLDER1', 'SHEET4') 	// Nivel 1 - Vendido
    oView:CreateHorizontalBox('GRID8',20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 2 - Vendido
	oView:CreateHorizontalBox('GRID19',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateVerticalBox('GRID19A',100,'GRID19', /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	
	oView:CreateHorizontalBox('GRID24',30,/*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido
	oView:CreateVerticalBox('GRID24B',100,'GRID24', /*lUsePixel*/, 'FOLDER1', 'SHEET4')	// Nivel 3 - Vendido

	oView:CreateHorizontalBox('GRIDCT4_1',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Vendido
	
	oView:CreateVerticalBox('GRIDCT4RD',50, 'GRIDCT4_1', /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRIDCT4CT',50, 'GRIDCT4_1', /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Planejado
	//oView:CreateVerticalBox('GRIDCT4RC',50, 'GRIDCT4_1', /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Planejado

	//oView:CreateHorizontalBox('GRIDCT4_2',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Vendido
	//oView:CreateVerticalBox('GRIDCT4AD',50, 'GRIDCT4_2', /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Planejado
	//oView:CreateVerticalBox('GRIDCT4RD',40, 'GRIDCT4_2', /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Planejado

	oView:CreateHorizontalBox('GRIDCT4CM',40, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET21')	// Outros Custos Vendido

 	oView:CreateHorizontalBox('GRID22',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID22A',50, 'GRID22', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID22B',50, 'GRID22', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
    oView:CreateHorizontalBox('GRID23',50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID23A',50, 'GRID23', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
	oView:CreateVerticalBox('GRID23B',50, 'GRID23', /*lUsePixel*/, 'FOLDER1', 'SHEET22')	// Custo Diversos 2
      
   	//------------------------------------------------------------------------------------------

	//oView:CreateHorizontalBox( 'boxCalcPla', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET1')
	//oView:SetOwnerView('formCalcPla','boxCalcPla')
	
		//------------------------------------------------------------------------------------------

	oView:CreateHorizontalBox( 'boxCalcCT4', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET21')
	oView:SetOwnerView('formCalcCT4','boxCalcCT4')
	
	//------------------------------------------------------------------------------------------

	//oView:CreateHorizontalBox( 'boxCalcVen', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET4')
	//oView:SetOwnerView('formCalcVen','boxCalcVen')
	
	//------------------------------------------------------------------------------------------

	oView:CreateHorizontalBox( 'boxCalcOCV', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')
	oView:SetOwnerView('formCalcOCV','boxCalcOCV')
	
	//------------------------------------------------------------------------------------------

	oView:CreateHorizontalBox( 'boxCalcHRV', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET13')
	oView:SetOwnerView('formCalcHRV','boxCalcHRV')
	
	//------------------------------------------------------------------------------------------

	oView:CreateHorizontalBox( 'boxCalcCom', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET2')
	oView:SetOwnerView('formCalcCom','boxCalcCom')
	
	//------------------------------------------------------------------------------------------
	
	//oView:CreateHorizontalBox( 'boxCalcRec', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET5')
	//oView:SetOwnerView('formCalcRec','boxCalcRec')
	
	//oView:CreateHorizontalBox( 'boxCalcPag', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET20')
	//oView:SetOwnerView('formCalcPag','boxCalcPag')
	

    //oView:CreateHorizontalBox('TOTAL',13)
     
    //Amarrando a view com as box
        
    oView:SetOwnerView('VIEW_CTD3','CABEC3')
    oView:SetOwnerView('VIEW_CTD2','CABEC2')
    oView:SetOwnerView('VIEW_CTD4','CABEC4')
    
    oView:SetOwnerView('VIEW_SZC','GRID2A')
    //oView:SetOwnerView('VIEW_SZV','GRIDB')
    oView:SetOwnerView('VIEW_SZD','GRID2B')
    //oView:SetOwnerView('VIEW_SZX','GRID2B')
    oView:SetOwnerView('VIEW_SZO','GRID2C')
    oView:SetOwnerView('VIEW_SZU','GRID2D')
    
    oView:SetOwnerView('VIEW_SZ9','BOXPP')
    oView:SetOwnerView('VIEW_SZF','GRID7A')
    
    oView:SetOwnerView('VIEW_SZG','GRID8')
    oView:SetOwnerView('VIEW_SC7','GRID3')
    oView:SetOwnerView('VIEW_SE2','GRID4A')
    oView:SetOwnerView('VIEW_CV4','GRID4B')
    
    oView:SetOwnerView('VIEW_SE2C','GRID20C')
    oView:SetOwnerView('VIEW_SE2D','GRID20D')
    oView:SetOwnerView('VIEW_SE2E','GRID20E')
    oView:SetOwnerView('VIEW_SE2F','GRID21')
    //oView:SetOwnerView('VIEW_SE1','GRID5A')
    //oView:SetOwnerView('VIEW_SE1B','GRID5B')
    //oView:SetOwnerView('VIEW_SE1C','GRID5C')
    oView:SetOwnerView('VIEW_SZ4','GRID6')
    oView:SetOwnerView('VIEW_SZH','GRID11A')
    oView:SetOwnerView('VIEW_SD1B','GRID11B')
    //oView:SetOwnerView('VIEW_SZI','GRID11B')
    oView:SetOwnerView('VIEW_SZJ','GRID12B')
    //oView:SetOwnerView('VIEW_SZM','GRID12A')
    oView:SetOwnerView('VIEW_SD1','GRID14')
    oView:SetOwnerView('VIEW_SZN','BOX56')
    oView:SetOwnerView('VIEW_SZP','GRID19A')
    oView:SetOwnerView('VIEW_SZT','GRID24B')
    oView:SetOwnerView('VIEW_CT430','GRIDCT4CT')
    //oView:SetOwnerView('VIEW_CT4D','GRIDCT4AD')
    oView:SetOwnerView('VIEW_CT4RD','GRIDCT4RD')
    oView:SetOwnerView('VIEW_CT4CM','GRIDCT4CM')
    oView:SetOwnerView('VIEW_ZZA','GRID22A')
    
    //oView:SetOwnerView('VIEW_CT4RD','GRIDCT4RC')
    
    
    
    //oView:SetOwnerView('VIEW_CT4R','GRIDCT4R')
    
	//oView:EnableTitleView('VIEW_SZ9' , 'Detalhes Venda' ) 

	//oView:EnableTitleView('formCalcPla' , 'Total Planejado' )
	//oView:EnableTitleView('formCalcVen' , 'Total Vendido' )
	oView:EnableTitleView('formCalcOCV' , 'Total Custos Diversos' )
	//oView:EnableTitleView('formCalcHRV' , 'Total Controle Horas' )
	oView:EnableTitleView('formCalcCom' , 'Total Custo Real' ) 
	//oView:EnableTitleView('formCalcRec' , 'Total' ) // Receber
	
	oView:AddIncrementField('VIEW_SZD' , 'ZD_ITEM' ) 
	//oView:AddIncrementField('VIEW_SZD' , 'ZD_IDPLSUB' ) 
	
	//oView:AddIncrementField('VIEW_SZV' , 'ZV_ITEM' ) 
	//oView:AddIncrementField('VIEW_SZX' , 'ZX_ITEM' ) 
	oView:AddIncrementField('VIEW_SZC' , 'ZC_ITEM' )
	//oView:AddIncrementField('VIEW_SZC' , 'ZC_IDPLAN' ) 
	oView:AddIncrementField('VIEW_SZN' , 'ZN_ITEM' )
	oView:AddIncrementField('VIEW_SZH' , 'ZH_ITEM' )
	//oView:AddIncrementField('VIEW_SZI' , 'ZI_ITEM' )
	oView:AddIncrementField('VIEW_SZJ' , 'ZJ_ITEM' )
	//oView:AddIncrementField('VIEW_SZM' , 'ZM_ITEM' )
	oView:AddIncrementField('VIEW_SZO' , 'ZO_ITEM' )
	//oView:AddIncrementField('VIEW_SZO' , 'ZO_IDPLSB2' )
	oView:AddIncrementField('VIEW_SZT' , 'ZT_ITEM' )
	oView:AddIncrementField('VIEW_SZU' , 'ZU_ITEM' )
	//oView:AddIncrementField('VIEW_SZU' , 'ZU_IDPLSB3' )
		
	oView:SetViewProperty('VIEW_CTD3' , 'ONLYVIEW' )
	oView:SetViewProperty('VIEW_SZN' , 'ONLYVIEW' )
	
	oView:SetViewProperty('VIEW_CTD2' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SC7')
	oView:SetNoDeleteLine('VIEW_SC7')
	oView:SetNoInsertLine('VIEW_SC7')
	oView:SetViewProperty('VIEW_SC7' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_CT430')
	oView:SetNoDeleteLine('VIEW_CT430')
	oView:SetNoInsertLine('VIEW_CT430')
	oView:SetViewProperty('VIEW_CT430' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_CT4D')
	//oView:SetNoDeleteLine('VIEW_CT4D')
	//oView:SetNoInsertLine('VIEW_CT4D')
	//oView:SetViewProperty('VIEW_CT4D' , 'ONLYVIEW' )
	
	
	oView:SetNoUpdateLine('VIEW_CT4RD')
	oView:SetNoDeleteLine('VIEW_CT4RD')
	oView:SetNoInsertLine('VIEW_CT4RD')
	oView:SetViewProperty('VIEW_CT4RD' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_CV4')
	oView:SetNoDeleteLine('VIEW_CV4')
	oView:SetNoInsertLine('VIEW_CV4')
	oView:SetViewProperty('VIEW_CV4' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_CT4RC')
	//oView:SetNoDeleteLine('VIEW_CT4RC')
	//oView:SetNoInsertLine('VIEW_CT4RC')
	//oView:SetViewProperty('VIEW_CT4RC' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_CT4CM')
	//oView:SetNoDeleteLine('VIEW_CT4CM')
	//oView:SetNoInsertLine('VIEW_CT4CM')
	oView:SetViewProperty('VIEW_CT4CM' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE2')
	oView:SetNoDeleteLine('VIEW_SE2')
	oView:SetNoInsertLine('VIEW_SE2')
	oView:SetViewProperty('VIEW_SE2' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE2C')
	oView:SetNoDeleteLine('VIEW_SE2C')
	oView:SetNoInsertLine('VIEW_SE2C')
	oView:SetViewProperty('VIEW_SE2C' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE2D')
	oView:SetNoDeleteLine('VIEW_SE2D')
	oView:SetNoInsertLine('VIEW_SE2D')
	oView:SetViewProperty('VIEW_SE2D' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE2E')
	oView:SetNoDeleteLine('VIEW_SE2E')
	oView:SetNoInsertLine('VIEW_SE2E')
	oView:SetViewProperty('VIEW_SE2E' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SD1B')
	oView:SetNoDeleteLine('VIEW_SD1B')
	oView:SetNoInsertLine('VIEW_SD1B')
	oView:SetViewProperty('VIEW_SD1B' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE2F')
	oView:SetNoDeleteLine('VIEW_SE2E')
	oView:SetNoInsertLine('VIEW_SE2F')
	oView:SetViewProperty('VIEW_SE2F' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_SE1')
	//oView:SetNoDeleteLine('VIEW_SE1')
	//oView:SetNoInsertLine('VIEW_SE1')
	//oView:SetViewProperty('VIEW_SE1' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SZ4')
	oView:SetNoDeleteLine('VIEW_SZ4')
	oView:SetNoInsertLine('VIEW_SZ4')
	oView:SetViewProperty('VIEW_SZ4' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SD1')
	oView:SetNoDeleteLine('VIEW_SD1')
	oView:SetNoInsertLine('VIEW_SD1')
	oView:SetViewProperty('VIEW_SD1' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_SE1B')
	//oView:SetNoDeleteLine('VIEW_SE1B')
	//oView:SetNoInsertLine('VIEW_SE1B')
	//oView:SetViewProperty('VIEW_SE1B' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_SE1C')
	//oView:SetNoDeleteLine('VIEW_SE1C')
	//oView:SetNoInsertLine('VIEW_SE1C')
	//oView:SetViewProperty('VIEW_SE1C' , 'ONLYVIEW' )

	oView:SetViewProperty('VIEW_SZ9' , 'ONLYVIEW' )
	
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
    //oView:EnableTitleView('VIEW_CTD','Contrato')
    //oView:EnableTitleView('VIEW_CTD2','Contrato')
    //oView:EnableTitleView('VIEW_CTD3','Contrato')
    //oView:EnableTitleView('VIEW_SZC','Custo Planejado')
	oView:EnableTitleView('VIEW_CTD2','Totais Custos')
	oView:EnableTitleView('VIEW_CTD4','Totais Venda')
    oView:EnableTitleView('VIEW_SZF','Nivel 1 - Operacao Unitaria')
    oView:EnableTitleView('VIEW_SZG','Nivel 2 - Conjunto')
    oView:EnableTitleView('VIEW_SZP','Nivel 3 - Sub-Conjunto')
    oView:EnableTitleView('VIEW_SZT','Nivel 4 - Sub-Conjunto')
    
    oView:EnableTitleView('VIEW_SC7','(Empenhado) Compras')
    oView:EnableTitleView('VIEW_SD1','(Empenhado) Documento Entrada')
    
    oView:EnableTitleView('VIEW_SZC','Nivel 1 - Operacao Unitaria - Custo Planejado') 	// PLanejado 
    oView:EnableTitleView('VIEW_SZD','Nivel 2 - Conjunto - Revisado')					// PLanejado 
	//oView:EnableTitleView('VIEW_SZV','Nivel 1 - Operacao Unitaria - Custo Revisado') 	// Revisao 
	//oView:EnableTitleView('VIEW_SZX','Nivel 2 - Conjunto - Revisado')					// Revisao 
    oView:EnableTitleView('VIEW_SZO','Nivel 3 - Sub-Conjunto')						// PLanejado 
	oView:EnableTitleView('VIEW_SZU','Nivel 4 - Sub-Conjunto')						// PLanejado 
    oView:EnableTitleView('VIEW_SZF','Detalhes Custos Vendido')
    oView:EnableTitleView('VIEW_SE2','Contas a Pagar')
    //oView:EnableTitleView('VIEW_SE1','A Receber')										// Receber
	//oView:EnableTitleView('VIEW_SE1B','Provisoes')	
	//oView:EnableTitleView('VIEW_SE1C','Recebimento ')									// Receber
	
	oView:EnableTitleView('VIEW_SE2','(Empenhado) Real (Financeiro)') 	// Outros Custos Real
	oView:EnableTitleView('VIEW_CV4','(Empenhado) Rateio (Financeiro)') 	// Outros Custos Real
	oView:EnableTitleView('VIEW_SE2C','Pagos') 				// Contas a Pagar
	oView:EnableTitleView('VIEW_SE2D','A Pagar') 			// Contas a Pagar
	oView:EnableTitleView('VIEW_SE2E','Provisoes') 			// Contas a Pagar
	oView:EnableTitleView('VIEW_SE2F','Pagamento Antecipado') 			// Contas a Pagar

    oView:EnableTitleView('VIEW_SZH','Planejado/Revisado') 	// Outros Custos PLanejado
	oView:EnableTitleView('VIEW_SD1B','(Empenhado) Comissao ') 			// Contas a Pagar
	
    //oView:EnableTitleView('VIEW_SZI','Vendido') 	// Outros Custos Vendido

    oView:EnableTitleView('VIEW_SZ4','(Empenhado) Real') 		// Horas Real
    oView:EnableTitleView('VIEW_SZJ','Planejado / Revisado / Vendido') 	// Horas PLanejado
    //oView:EnableTitleView('VIEW_SZM','Revisado') 	// Horas Vendido
	oView:EnableTitleView('VIEW_SZN','Resumo Custos' )
	
	oView:EnableTitleView('VIEW_CT430','(Contabilizado) Custo Contabil ' )
	//oView:EnableTitleView('VIEW_CT4D','Custo Contabil - D ' )

	//oView:EnableTitleView('VIEW_CT4RC','Receita Contabil' )
	oView:EnableTitleView('VIEW_CT4RD','(Contabilizado) Receita Contabil' )
	oView:EnableTitleView('VIEW_CT4CM','(Contabilizado) Comissao Contabil' )
	
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
    
    //Percorrendo a estrutura da CT4
    //For nAtual := 1 To Len(aStruCT4RC)
    //    //Se o campo atual não estiver nos que forem considerados
    //    If ! Alltrim(aStruCT4RC[nAtual][01]) $ cConsCT4RC
    //        oStFilhoCT4RC:RemoveField(aStruCT4RC[nAtual][01])
    //    EndIf
    //Next
    
      //Percorrendo a estrutura da CT4
    //For nAtual := 1 To Len(aStruCT4D)
        //Se o campo atual não estiver nos que forem considerados
       // If ! Alltrim(aStruCT4D[nAtual][01]) $ cConsCT4D
        //    oStFilhoCT4D:RemoveField(aStruCT4D[nAtual][01])
        //EndIf
    //Next
    
      
    //Percorrendo a estrutura da CT4
    For nAtual := 1 To Len(aStru30)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStru30[nAtual][01]) $ cCons30
            oStFilho30:RemoveField(aStru30[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da CT4
    For nAtual := 1 To Len(aStruCT4RD)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruCT4RD[nAtual][01]) $ cConsCT4RD
            oStFilhoCT4RD:RemoveField(aStruCT4RD[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da CT4
    For nAtual := 1 To Len(aStruCT4CM)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruCT4CM[nAtual][01]) $ cConsCT4CM
            oStFilhoCT4CM:RemoveField(aStruCT4CM[nAtual][01])
        EndIf
    Next
     
    //Percorrendo a estrutura da SZC
    For nAtual := 1 To Len(aStruSZC)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZC[nAtual][01]) $ cConsSZC
            oStFilho:RemoveField(aStruSZC[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SZ9
    For nAtual := 1 To Len(aStruSZ9)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ9[nAtual][01]) $ cConsSZ9
            oStFilho6A:RemoveField(aStruSZ9[nAtual][01])
        EndIf
    Next
      
    //Percorrendo a estrutura da SZF
    For nAtual := 1 To Len(aStruSZF)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZF[nAtual][01]) $ cConsSZF
            oStFilho:RemoveField(aStruSZF[nAtual][01])
        EndIf
    Next
       
    //Percorrendo a estrutura da SZH
    For nAtual := 1 To Len(aStruSZH)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZH[nAtual][01]) $ cConsSZH
            oStFilho7:RemoveField(aStruSZH[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SZI
/*
    For nAtual := 1 To Len(aStruSZI)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZI[nAtual][01]) $ cConsSZI
            oStFilho8:RemoveField(aStruSZI[nAtual][01])
        EndIf
    Next
*/
    
    //Percorrendo a estrutura da SZJ
    For nAtual := 1 To Len(aStruSZJ)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZJ[nAtual][01]) $ cConsSZJ
            oStFilho9:RemoveField(aStruSZJ[nAtual][01])
        EndIf
    Next
    /*
    //Percorrendo a estrutura da SZM
    For nAtual := 1 To Len(aStruSZM)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZM[nAtual][01]) $ cConsSZM
            oStFilho10:RemoveField(aStruSZM[nAtual][01])
        EndIf
    Next
    */
    //Percorrendo a estrutura da SZN
    For nAtual := 1 To Len(aStruSZN)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZN[nAtual][01]) $ cConsSZN
            oStFilho11:RemoveField(aStruSZN[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SC7

    For nAtual := 1 To Len(aStruSC7)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSC7[nAtual][01]) $ cConsSC7
            oStFilho2:RemoveField(aStruSC7[nAtual][01])
        EndIf
    Next
	   
    //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSE2)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE2[nAtual][01]) $ cConsSE2
            oStFilho3:RemoveField(aStruSE2[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSE2C)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE2C[nAtual][01]) $ cConsSE2C
            oStFilho3C:RemoveField(aStruSE2C[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSE2D)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE2D[nAtual][01]) $ cConsSE2D
            oStFilho3D:RemoveField(aStruSE2D[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSE2E)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE2E[nAtual][01]) $ cConsSE2E
            oStFilho3E:RemoveField(aStruSE2E[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSE2F)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE2F[nAtual][01]) $ cConsSE2F
            oStFilho3F:RemoveField(aStruSE2F[nAtual][01])
        EndIf
    Next
    
      //Percorrendo a estrutura da SE2
    For nAtual := 1 To Len(aStruSD1B)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSD1B[nAtual][01]) $ cConsSD1B
            oStFilho12B:RemoveField(aStruSD1B[nAtual][01])
        EndIf
    Next
        
     //Percorrendo a estrutura da SE1
    //For nAtual := 1 To Len(aStruSE1)
        //Se o campo atual não estiver nos que forem considerados
     //   If ! Alltrim(aStruSE1[nAtual][01]) $ cConsSE1
     //       oStFilho4:RemoveField(aStruSE1[nAtual][01])
     //   EndIf
    //Next
    
     //Percorrendo a estrutura da SE1
    //For nAtual := 1 To Len(aStruSE1B)
    //    //Se o campo atual não estiver nos que forem considerados
    //    If ! Alltrim(aStruSE1B[nAtual][01]) $ cConsSE1B
    //        oStFilho4B:RemoveField(aStruSE1B[nAtual][01])
    //    EndIf
    //Next
    
    //Percorrendo a estrutura da SE1
    //For nAtual := 1 To Len(aStruSE1C)
        //Se o campo atual não estiver nos que forem considerados
     //   If ! Alltrim(aStruSE1C[nAtual][01]) $ cConsSE1C
     //       oStFilho4C:RemoveField(aStruSE1C[nAtual][01])
     //   EndIf
    //Next
    
     //Percorrendo a estrutura da SZ4
    For nAtual := 1 To Len(aStruSZ4)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZ4[nAtual][01]) $ cConsSZ4
            oStFilho5:RemoveField(aStruSZ4[nAtual][01])
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
    
    //Percorrendo a estrutura da SD1
    For nAtual := 1 To Len(aStruSD1)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSD1[nAtual][01]) $ cConsSD1
            oStFilho12:RemoveField(aStruSD1[nAtual][01])
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
    /*
    //Percorrendo a estrutura da SDT
    For nAtual := 1 To Len(aStruSZU)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZU[nAtual][01]) $ cConsSZU
            oStNeto6:RemoveField(aStruSZU[nAtual][01])
        EndIf
    Next
    */
    //Percorrendo a estrutura da SZV
	/*
    For nAtual := 1 To Len(aStruSZV)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZV[nAtual][01]) $ cConsSZV
            oStFilho13:RemoveField(aStruSZV[nAtual][01])
        EndIf
    Next
     //Percorrendo a estrutura da SDX
    For nAtual := 1 To Len(aStruSZX)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZX[nAtual][01]) $ cConsSZX
            oStNeto14:RemoveField(aStruSZX[nAtual][01])
        EndIf
    Next
*/

	 //Percorrendo a estrutura da ZZA
    For nAtual := 1 To Len(aStruZZA)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruZZA[nAtual][01]) $ cConsZZA
            oStFilho31:RemoveField(aStruZZA[nAtual][01])
        EndIf
    Next
Return oView
//-------------------------------------------------------------------

Static Function COMP021BUT( oModel )
	//Local nOperation 	:= oModel:GetOperation() 
	
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
	Local oModelSZN   	:= oModel:GetModel( 'SZNDETAIL' )
	//Local oModelSZM   	:= oModel:GetModel( 'SZMDETAIL' )
	Local oModelSZJ   	:= oModel:GetModel( 'SZJDETAIL' )
	Local oModelSC7   	:= oModel:GetModel( 'SC7DETAIL' )
	Local oModelSE2   	:= oModel:GetModel( 'SE2DETAIL' )
	Local oModelSZ4   	:= oModel:GetModel( 'SZ4DETAIL' )
	Local oModelSD1   	:= oModel:GetModel( 'SD1DETAIL' )
	Local oModelSZH   	:= oModel:GetModel( 'SZHDETAIL' )
	Local oModelSZV   	:= oModel:GetModel( 'SZVDETAIL' )
	Local oModelSZX   	:= oModel:GetModel( 'SZXDETAIL' )
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
	Local nTotalZI 		:= oModel:GetValue( 'SZIDETAIL', 'ZI_CUSVEN' )
	//Local nTotalZM 		:= oModel:GetValue( 'SZMDETAIL', 'ZM_TOTAL' )
	Local nTotalZJ 		:= oModel:GetValue( 'SZJDETAIL', 'ZJ_TOTAL' )
	Local nTotalZH 		:= oModel:GetValue( 'SZHDETAIL', 'ZH_CUSPLA' )
	Local nTotalC7 		:= oModel:GetValue( 'SC7DETAIL', 'C7_XTOTSI' )
	Local nTotalE2 		:= oModel:GetValue( 'SE2DETAIL', 'E2_VALOR' )
	Local nTotalZ4 		:= oModel:GetValue( 'SZ4DETAIL', 'Z4_TOTVLR' )
	Local nTotalZG		:= oModel:GetValue( 'SZGDETAIL', 'ZG_TOTAL' )
	Local nTotalD1		:= oModel:GetValue( 'SD1DETAIL', 'D1_CUSTO' )
	Local cIDVendSZF	:= oModel:GetValue( 'SZFDETAIL', 'ZF_IDVEND' )
	Local cIDVendSZG	:= oModel:GetValue( 'SZGDETAIL', 'ZG_IDVEND' )
	Local nTotalZFF 	:= 0
		
	Local oModelSZI   	:= oModel:GetModel( 'SZIDETAIL' ) 
	Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local cXCVP		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCVP' )
	
	Local nDESCRI		:= oModel:GetValue( 'SZNDETAIL', 'ZN_DESCRI' )
	Local nPercentSZH	:= oModel:GetValue( 'SZHDETAIL', 'ZH_PEROC' )
	Local nPercentSZI	:= oModel:GetValue( 'SZIDETAIL', 'ZI_PERCENT' )
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
	Local nTotalSZH 	:= 0
	Local nTotalSZI 	:= 0
	
	Local nDesCusProdSZI	:= oModel:GetValue( 'SZNDETAIL', 'ZN_DESCRI' )
	Local nLinha		:= 0
	Local nTotalSZF_RES := 0
	Local nTotalSZI_RES := 0
	Local nTotalSZM_RES := 0
	Local nTotalSZF_SZM := 0
	Local nTotalVendido := 0
	Local nMargemBrutaV := 0
	Local nMargemContrV := 0
	
	Local nTotalSZC_RES	:= 0
	Local nTotalSZJ_RES	:= 0
	Local nTotalSZC_SZJ := 0
	Local nTotalSZH_RES := 0
	Local nTotalPlanej	:= 0
	Local nMargemBrutaP := 0
	Local nMargemContrP := 0
	
	Local nTotalSC7_RES := 0
	Local nTotalSZ4_RES := 0 
	Local nTotalSC7_SZ4 := 0
	Local nTotalSE2_RES := 0
	Local nTotalReal	:= 0
	Local nMargemBrutaR := 0
	Local nMargemContrR := 0
	Local nTotalSD1_RES := 0

	Local nITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local nLen 			:= 0
	Local nLen2 		:= 0
	

	Local cDescri_CVPSZF		:= ""
	Local cDescri_CVPSZG		:= ""
	Local cIDPlan_CVPSZC		:= 0
	Local cIDPlan_CVPSZD		:= 0
	
	Local nI44 			:= 0
	Local nI62 			:= 0
	Local nI45 			:= 0
	Local nI63 			:= 0	
	Local cQuant_CVPSZF := 0
	Local cUnit_CVPSZF	:= 0
	Local cTotal_CVPSZF := 0
	
	Local cQuant_CVPSZG := 0
	Local cUnit_CVPSZG 	:= 0
	Local cTotal_CVPSZG	:= 0
	
	Local cDescri_CVPSZP := ""
	Local cQuant_CVPSZP	:= 0
	Local cUnit_CVPSZP	:= 0
	Local cTotal_CVPSZP	:= 0
	
	
		/////////////////////////////////////////////////////////
	nLen := 0
		//oModelSZH:GoLine( 1 )

	//MargemBrutaPJ = (ValorVendaContrato - CustoProducaoPJ) / ValorVendaContrato * 100
    //MargemContribuicaoCV = (ValorVendaContrato - CustoTotalCV) / ValorVendaContrato * 100
		nLen 	:= oModelSZN:Length(.T.) 
	
	
		
	if nLen >= 7
	
		//oModelSZN:GoLine( 1 )
		//oModelSZN:SetValue('ZN_DESCRI', "VENDIDO" )
		
		oModelSZN:GoLine( 1 )
		oModelSZN:SetValue('ZN_DESCRI', "PLANEJADO" )
		
		oModelSZN:GoLine( 2 )
		oModelSZN:SetValue('ZN_DESCRI', "REVISADO" )
		
		oModelSZN:GoLine( 3 )
		oModelSZN:SetValue('ZN_DESCRI', "EMPRENHADO" )
		
		oModelSZN:GoLine( 4 )
		oModelSZN:SetValue('ZN_DESCRI', "SALDO" )
		
		oModelSZN:GoLine( 5 )
		oModelSZN:SetValue('ZN_DESCRI', "REALIZADO" )
				
	Endif
	
	if nLen = 1
	
		oModelSZN:GoLine( 1 )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
		
	endif 	
	
	if 	nLen < 2	
		oModelSZN:AddLine()
		nLen 	:= oModelSZN:Length(.T.) 
		oModelSZN:GoLine( nLen )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
		
	endif	
		
	if nLen < 3	
		oModelSZN:AddLine()
		nLen 	:= oModelSZN:Length(.T.)
		oModelSZN:GoLine( nLen )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
	endif
		
	if nLen < 4
		oModelSZN:AddLine()
		nLen 	:= oModelSZN:Length(.T.)
		oModelSZN:GoLine( nLen )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
	endif	
	if nLen < 5	
		oModelSZN:AddLine()
		nLen 	:= oModelSZN:Length(.T.)
		oModelSZN:GoLine( nLen )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
	endif
	/*
	if nLen < 6	
		oModelSZN:AddLine()
		nLen 	:= oModelSZN:Length(.T.)
		oModelSZN:GoLine( nLen )
		oModelSZN:SetValue('ZN_ITEMIC', nITEMCTA )
	endif	
	*/			
		//oModelSZN:GoLine( 1 )
		//oModelSZN:SetValue('ZN_DESCRI', "VENDIDO" )
    
   
 
	
		oModelSZN:GoLine( 1)
		oModelSZN:SetValue('ZN_DESCRI', "PLANEJADO" )
		
		oModelSZN:GoLine( 2 )
		oModelSZN:SetValue('ZN_DESCRI', "REVISADO" )
		
		oModelSZN:GoLine( 3 )
		oModelSZN:SetValue('ZN_DESCRI', "EMPENHADO" )
		
		oModelSZN:GoLine( 4 )
		oModelSZN:SetValue('ZN_DESCRI', "SALDO" )
		
		oModelSZN:GoLine( 5 )
		oModelSZN:SetValue('ZN_DESCRI', "CONTABILIZADO" )
	
	
	//endif
	nLen := 0
	
	oModelSZF:GoLine( 1 )
	cDescri_CVPSZF 	:= oModel:GetValue( 'SZFDETAIL', 'ZF_DESCRI' )
	
	if ! Empty(cDescri_CVPSZF) .AND. cXCVP = "0" .OR. ! Empty(cDescri_CVPSZF) .AND. EMPTY(cXCVP) 
	
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
		oModelSZC:SetValue('ZC_QUANT', cQuant_CVPSZF )
		oModelSZC:SetValue('ZC_UNIT', cUnit_CVPSZF )
		oModelSZC:SetValue('ZC_TOTAL', cTotal_CVPSZF )
		
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
			oModelSZD:SetValue('ZD_IDPLAN', cIDPlan_CVPSZC )
			oModelSZD:SetValue('ZD_DESCRI', cDescri_CVPSZG )
			oModelSZD:SetValue('ZD_QUANT', cQuant_CVPSZG )
			oModelSZD:SetValue('ZD_UNIT', cUnit_CVPSZG )
			oModelSZD:SetValue('ZD_TOTAL', cTotal_CVPSZG )
			
			oModelSZD:SetValue('ZD_QUANTR', cQuant_CVPSZG )
			oModelSZD:SetValue('ZD_UNITR', cUnit_CVPSZG )
			oModelSZD:SetValue('ZD_TOTALR', cTotal_CVPSZG )
			cIDPlan_CVPSZD	:= oModel:GetValue( 'SZDDETAIL', 'ZD_IDPLSUB' )
			
			
		Next nI62
					
	Next nI44	
		
	msginfo ( "Transferencia Custo Vendido para Planejado realizado com sucesso." )
	oModelCTD:SetValue('CTD_XCVP', '1' )
	end if 
	
	
	////////////////////////////////////////////////////////////////////
	
Return lRet

User Function zMVC02Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Aberto"  })      
    AADD(aLegenda,{"BR_CINZA",   "Fechado"})
     
    BrwLegenda("Gestao de Contratos", "Status", aLegenda)
Return