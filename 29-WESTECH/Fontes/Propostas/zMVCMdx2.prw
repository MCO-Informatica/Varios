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
oModel:GetModel( 'IDGRID' ):SetLoadFilter( , " ( ZA2_AUTOR >= '000500' .AND. ZA2_AUTOR < '000600' ) " )

*/
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Variáveis Estáticas
Static cTitulo := "Recebimento / Faturamentos - Contratos"
 
/*/ zMVCMdX
    @return Nil, Função não tem retorno
    @example
    u_zMVCMdX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function zMVCMdX2()
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
    oBrowse:SetFilterDefault( "SUBSTR(CTD_ITEM,9,2) >= '15' .AND. CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM <> 'PROPOSTA' .AND. CTD_ITEM <> 'QUALIDADE' .AND. CTD_ITEM <> 'ATIVO' .AND. CTD_ITEM <> 'ENGENHARIA' .AND. CTD_ITEM <> 'ZZZZZZZZZZZZZ' .AND. CTD_ITEM <> 'XXXXXX'  "  ) //.AND. CTD_DTEXSF = '' .OR. CTD_DTEXSF >= dDatabase
    DbSetOrder(6)
    
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    oBrowse:AddFilter("Contratos Fechados....",xCond)
    oBrowse:AddFilter("Contratos Abertos.....",xCond2,,.T.)
    oBrowse:AddFilter("Todos Contratos.......",xCond3)
    
    DbSetOrder(1)
    
    oBrowse:AddLegend( "CTD->CTD_DTEXSF < Date()", "GRAY", "Fechado" )
    oBrowse:AddLegend( "CTD->CTD_DTEXSF >= Date()", "GREEN",   "Aberto" )
  
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/////////////////////////////////////////////////////////////////////////////
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    //ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'MPFormModel'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMdX2' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
//////////////////////////////////////////////////////////////////////////////
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStPai        := FWFormStruct(1, 'CTD')
    Local oStFilho1  	:= FWFormStruct(1, 'SZZ')
    Local oStFilho1A  	:= FWFormStruct(1, 'SZZ')
    Local oStFilho1C  	:= FWFormStruct(1, 'SZZ')
    Local oStFilho2   	:= FWFormStruct(1, 'SZK')
    Local oStFilho3 	:= FWFormStruct(1, 'SZW')
    Local oStFilho4 	:= FWFormStruct(1, 'SD2')
    Local oStFilho5 	:= FWFormStruct(1, 'SE1')
    Local oStFilho5A 	:= FWFormStruct(1, 'SE1')
    Local oStFilho6 	:= FWFormStruct(1, 'SE5')
    Local oStFilho6B 	:= FWFormStruct(1, 'SE5')
    Local oStFilho7 	:= FWFormStruct(1, 'SZQ')
    Local oStFilho8 	:= FWFormStruct(1, 'SD1')
    
    Local aSZZRel       := {}
    Local aSZZRelA      := {}
    Local aSZZRelC      := {}
    Local aSZKRel       := {}
    Local aSZWRel       := {}
    Local aSD2Rel       := {}
    Local aSE1Rel       := {}
    Local aSE1RelA       := {}
    Local aSE5Rel       := {}
    Local aSE5RelA       := {}
    Local aSE5RelB       := {}
    Local aSZQRel       := {}
    Local aSD1Rel       := {}

        
    //Criando o modelo e os relacionamentos
     //oModel := MPFormModel():New('zMVCMdXM',  , { |oMdl| COMP011POS( oMdl ) })
     oModel := MPFormModel():New('zMVCMdXM2', { |oMdl| COMP021BUT( oMdl ) } , { |oMdl| COMP011POS( oMdl ) })
    	
       
    oModel:AddFields('CTDMASTER',/*cOwner*/,oStPai)
    
 
	oModel:AddGrid('SZZDETAIL','CTDMASTER',oStFilho1,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZZDETAIL', { { 'ZZ_ITEMIC', 'CTD_ITEM' } }, SZZ->(IndexKey(1)) )
	
	oModel:AddGrid('SZZDETAILA','CTDMASTER',oStFilho1A,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZZDETAILA', { { 'ZZ_ITEMIC', 'CTD_ITEM' } }, SZZ->(IndexKey(1)) )
	
	oModel:AddGrid('SZZDETAILC','CTDMASTER',oStFilho1C,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZZDETAILC', { { 'ZZ_ITEMIC', 'CTD_ITEM' } }, SZZ->(IndexKey(1)) )
	
	oModel:AddGrid('SZKDETAIL','CTDMASTER',oStFilho2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZKDETAIL', { { 'ZK_ITEMIC', 'CTD_ITEM' } }, SZK->(IndexKey(1)) )
	
	oModel:AddGrid('SZWDETAIL','CTDMASTER',oStFilho3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZWDETAIL', { { 'ZW_ITEMCTA', 'CTD_ITEM' } }, SZW->(IndexKey(1)) )
	
	oModel:AddGrid('SD2DETAIL','CTDMASTER',oStFilho4,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'SD2DETAIL' ):SetLoadFilter( , " ( D2_CF >= '5101' AND D2_CF <= '5125' OR D2_CF >= '5551' AND D2_CF <= '5551' OR D2_CF >= '5922' AND D2_CF <= '5922' OR D2_CF >= '5933' AND D2_CF <= '5933' OR D2_CF >= '6101' AND D2_CF <= '6106' OR D2_CF >= '6109' AND D2_CF <= '6120' OR D2_CF >= '6122' AND D2_CF <= '6125' OR D2_CF >= '6551' AND D2_CF <= '6551' OR D2_CF >= '6933' AND D2_CF <= '6933' OR D2_CF >= '7101' AND D2_CF <= '7933' OR D2_CF = '7949' AND SUBSTRING(D2_ITEMCC,1,2) = 'AT' OR D2_CF = '7949' AND SUBSTRING(D2_ITEMCC,1,2) = 'CM' OR D2_CF = '7949' AND SUBSTRING(D2_ITEMCC,1,2) = 'EN' ) " )
	oModel:SetRelation('SD2DETAIL', { { 'D2_ITEMCC', 'CTD_ITEM' } }, SD2->(IndexKey(4)) )
	//1201 2201
	oModel:AddGrid('SD1DETAIL','CTDMASTER',oStFilho8,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'SD1DETAIL' ):SetLoadFilter( , " ( D1_CF = '1201' OR D1_CF = '2201' OR D1_CF = '5201' ) " )
	oModel:SetRelation('SD1DETAIL', { { 'D1_ITEMCTA', 'CTD_ITEM' } }, SD1->(IndexKey(1)) )
	
	oModel:AddGrid('SE1DETAIL','CTDMASTER',oStFilho5,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'SE1DETAIL' ):SetLoadFilter( {  {  'E1_TIPO', "'PR'" }  } ) // { 'E2_BAIXA', "''" } ,
	oModel:SetRelation('SE1DETAIL', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )
	
	oModel:AddGrid('SE1DETAILA','CTDMASTER',oStFilho5A,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:GetModel( 'SE1DETAILA' ):SetLoadFilter( {  {  'E1_TIPO', "'INV'" }  } ) // { 'E2_BAIXA', "''" } ,
	oModel:SetRelation('SE1DETAILA', { { 'E1_XXIC', 'CTD_ITEM' } }, SE1->(IndexKey(1)) )
	
	
	oModel:AddGrid('SE5DETAIL','CTDMASTER',oStFilho6,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'SE5DETAIL' ):SetLoadFilter( {  {  'E5_CLIENTE', "''" , MVC_LOADFILTER_NOT_EQUAL} , {  'E5_TIPODOC', "{'RA','VL','ES'}" , MVC_LOADFILTER_IS_CONTAINED  }  } ) 
	oModel:GetModel( 'SE5DETAIL' ):SetLoadFilter( {  {  'E5_RECPAG', "{'R','P'}" , MVC_LOADFILTER_IS_CONTAINED}  , {  'E5_TIPODOC', "{'RA','VL','ES'}" , MVC_LOADFILTER_IS_CONTAINED  } , {  'E5_BANCO', "''", MVC_LOADFILTER_NOT_EQUAL },  {  'E5_BANCO', "'CX1'", MVC_LOADFILTER_NOT_EQUAL },  {  'E5_CLIENTE', "''", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:GetModel( 'SE5DETAIL' ):SetLoadFilter( {  {  'E5_RECPAG', "'P'" }  , {  'E5_TIPODOC', "{'ES'}" , MVC_LOADFILTER_IS_CONTAINED  }  } )  
	oModel:SetRelation('SE5DETAIL', { { 'E5_XXIC', 'CTD_ITEM' } }, SE5->(IndexKey(1)) )
	
	oModel:AddGrid('SE5DETAILB','CTDMASTER',oStFilho6B,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	//oModel:GetModel( 'SE5DETAIL' ):SetLoadFilter( {  {  'E5_CLIENTE', "''" , MVC_LOADFILTER_NOT_EQUAL} , {  'E5_TIPODOC', "{'RA','VL','ES'}" , MVC_LOADFILTER_IS_CONTAINED  }  } ) 
	oModel:GetModel( 'SE5DETAILB' ):SetLoadFilter( {  {  'E5_RECPAG', "{'R'}" , MVC_LOADFILTER_IS_CONTAINED}  , {  'E5_TIPODOC', "{'CP'}" , MVC_LOADFILTER_IS_CONTAINED  } ,  {  'E5_BANCO', "'CX1'", MVC_LOADFILTER_NOT_EQUAL },  {  'E5_CLIENTE', "''", MVC_LOADFILTER_NOT_EQUAL } } )
	//oModel:GetModel( 'SE5DETAIL' ):SetLoadFilter( {  {  'E5_RECPAG', "'P'" }  , {  'E5_TIPODOC', "{'ES'}" , MVC_LOADFILTER_IS_CONTAINED  }  } )  
	oModel:SetRelation('SE5DETAILB', { { 'E5_XXIC', 'CTD_ITEM' } }, SE5->(IndexKey(1)) )
	
	
	oModel:AddGrid('SZQDETAIL','CTDMASTER',oStFilho7,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:SetRelation('SZQDETAIL', { { 'ZQ_ITEMIC', 'CTD_ITEM' } }, SZQ->(IndexKey(1)) )
	
	//oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "{'000500','000501'}", MVC_LOADFILTER_IS_CONTAINED } } )
	//oModel:GetModel( 'IDGRID' ):SetLoadFilter( { { 'ZA2_AUTOR', "{'000500','000501'}", MVC_LOADFILTER_IS_CONTAINED } } )
	//MVC_LOADFILTER_CONTAINS
	//Fazendo o relacionamento entre o Pai e Filho
	
    aAdd(aSZZRel, {'ZZ_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZZRel, {'ZZ_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZZRelA, {'ZZ_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZZRelA, {'ZZ_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZZRelC, {'ZZ_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZZRelC, {'ZZ_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZKRel, {'ZK_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZKRel, {'ZK_ITEMIC',  'CTD_ITEM'})
    
    aAdd(aSZWRel, {'ZW_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZWRel, {'ZW_ITEMCTA',  'CTD_ITEM'})
    
    aAdd(aSD2Rel, {'D2_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSD2Rel, {'D2_ITEMCC',  'CTD_ITEM'})
    
    aAdd(aSZWRel, {'D1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZWRel, {'D1_ITEMCTA',  'CTD_ITEM'})
    
    aAdd(aSE1Rel, {'E1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE1Rel, {'E1_XXIC',  'CTD_ITEM'})
    
    aAdd(aSE1RelA, {'E1_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE1RelA, {'E1_XXIC',  'CTD_ITEM'})
	
	aAdd(aSE5Rel, {'E5_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE5Rel, {'E5_XXIC',  'CTD_ITEM'})
    
    aAdd(aSE5RelB, {'E5_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSE5RelB, {'E5_XXIC',  'CTD_ITEM'})
    
    aAdd(aSZQRel, {'ZQ_FILIAL', 'CTD_FILIAL'} )
    aAdd(aSZQRel, {'ZQ_ITEMIC',  'CTD_ITEM'})
        
    oModel:GetModel('SZZDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZZDETAILA'):SetOptional( .T. )
    oModel:GetModel('SZZDETAILC'):SetOptional( .T. )
    oModel:GetModel('SZKDETAIL'):SetOptional( .T. )
    oModel:GetModel('SZWDETAIL'):SetOptional( .T. )
    oModel:GetModel('SD2DETAIL'):SetOptional( .T. )
    oModel:GetModel('SE1DETAIL'):SetOptional( .T. )
    oModel:GetModel('SE1DETAILA'):SetOptional( .T. )
    oModel:GetModel('SE5DETAIL'):SetOptional( .T. )
    oModel:GetModel('SE5DETAILB'):SetOptional( .T. )
    oModel:GetModel('SZQDETAIL'):SetOptional( .T. )
    oModel:GetModel('SD1DETAIL'):SetOptional( .T. )
   
//IndexKey -> quero a ordenação e depois filtrado
    //oModel:SetRelation('SE5DETAIL', { { 'E5_XXIC', 'CTD_ITEM' } }, SE5->(IndexKey(1)) )
   
 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SE5DETAIL'):SetUniqueLine({"E5_NUMERO"})
    //oModel:SetPrimaryKey({})
    
    
    
    
//oModel:SetRelation('SZZDETAIL', { { 'ZZ_ITEMIC', 'CTD_ITEM' } }, SZZ->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZNDETAIL'):SetUniqueLine({"ZN_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
    
//oModel:SetRelation('SZKDETAIL', { { 'ZK_ITEMIC', 'CTD_ITEM' } }, SZK->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZNDETAIL'):SetUniqueLine({"ZN_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
    
//oModel:SetRelation('SZWDETAIL', { { 'ZW_ITEMCTA', 'CTD_ITEM' } }, SZW->(IndexKey(1)) )

 //IndexKey -> quero a ordenação e depois filtrado
    //oModel:GetModel('SZNDETAIL'):SetUniqueLine({"ZN_ITEM"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    //oModel:SetPrimaryKey({})
 

    //Setando as descrições
    oModel:SetDescription("Gestao de Contratos")
    oModel:GetModel('CTDMASTER'):SetDescription('Contrato')
    oModel:GetModel('SZZDETAIL'):SetDescription('Resumo')
    oModel:GetModel('SZKDETAIL'):SetDescription('Faturamento')
    
    oModel:GetModel('SZQDETAIL'):SetDescription('Faturamento Revisado')
    oModel:GetModel('SZWDETAIL'):SetDescription('Recebimento ')
    
    oModel:GetModel('SD2DETAIL'):SetDescription('Nfs Emitidas - Faturamento ')
    oModel:GetModel('SE1DETAIL'):SetDescription('Faturamento Revisado ')
    oModel:GetModel('SE5DETAIL'):SetDescription('Recebimento Efetivo')
    oModel:GetModel('SE5DETAILB'):SetDescription('Compensacao')
    oModel:GetModel('SD1DETAIL'):SetDescription('NF Devolucao')
    
    oModel:getModel('SZZDETAIL'):SetMaxLine(4)	
	
	//oModel:getModel('SZNDETAIL'):SetMaxLine(6)
	
	//oModel:AddCalc( 'calcREAL', 'CTDMASTER', 'SD2DETAIL', 'D2_VALBRUT', 'calcSD2', 'SUM', /*bCondition*/, /*bInitValue*/,'Faturamento ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcREAL', 'CTDMASTER', 'SE5DETAIL', 'E5_VALOR', 'calcSE5', 'SUM', /*bCondition*/, /*bInitValue*/,'Recebimento Efetivo ' /*cTitle*/, /*bFormula*/)
	
	//oModel:AddCalc( 'calcPLRV', 'CTDMASTER', 'SZKDETAIL', 'ZK_VLRPL', 'calcSZK', 'SUM', /*bCondition*/, /*bInitValue*/,'Faturamento Planejado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcPLRV', 'CTDMASTER', 'SZWDETAIL', 'ZW_VLRREC', 'calcSZW', 'SUM', /*bCondition*/, /*bInitValue*/,'Recebimento Planejado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcPLRV', 'CTDMASTER', 'SZQDETAIL', 'ZQ_FATREV', 'calcSZQ', 'SUM', /*bCondition*/, /*bInitValue*/,'Faturamento Revisado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcPLRV', 'CTDMASTER', 'SE1DETAIL', 'E1_VLCRUZ', 'calcSE1', 'SUM', /*bCondition*/, /*bInitValue*/,'Recebimento Revisado ' /*cTitle*/, /*bFormula*/)
	
	//oModel:AddCalc( 'calcSZC', 'CTDMASTER', 'SZCDETAIL', 'ZC_TOTAL', 'calcPla', 'SUM', /*bCondition*/, /*bInitValue*/,'Plajejado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZC', 'CTDMASTER', 'SZCDETAIL', 'ZC_TOTALR', 'calcRev', 'SUM', /*bCondition*/, /*bInitValue*/,'Revisado ' /*cTitle*/, /*bFormula*/)
	//oModel:AddCalc( 'calcSZF', 'CTDMASTER', 'SZFDETAIL', 'ZF_TOTAL', 'calcVD', 'SUM', /*bCondition*/, /*bInitValue*/,'Custo' /*cTitle*/, /*bFormula*/)
		
    //Adicionando totalizadores
   // oModel:AddCalc('TOT_SALDO', 'SB1DETAIL', 'SB2DETAIL', 'B2_QATU', 'XX_TOTAL', 'SUM', , , "Saldo Total:" )

Return oModel

Static Function COMP011POS( oModel )
	//Local nOperation 	:= oModel:GetOperation() 

	
	Local lRet 			:= .T.
	Local oModelSZZ   	:= oModel:GetModel( 'SZZDETAIL' )
	//Local oModelSZK   	:= oModel:GetModel( 'SZKDETAIL' )
	//Local oModelSZW   	:= oModel:GetModel( 'SZWDETAIL' )
	Local oModelSZQ   	:= oModel:GetModel( 'SZQDETAIL' )
	Local oModelSE1   	:= oModel:GetModel( 'SE1DETAIL' )
	Local oModelSE1A   	:= oModel:GetModel( 'SE1DETAILA' )
	Local oModelSD2   	:= oModel:GetModel( 'SD2DETAIL' )
	Local oModelSE5   	:= oModel:GetModel( 'SE5DETAIL' )
	Local oModelSE5B   	:= oModel:GetModel( 'SE5DETAILB' )
	Local oModelSD1   	:= oModel:GetModel( 'SD1DETAIL' )
	
	Local nXVDSICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSI' )
	Local nXSISFV		:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFV' )
	Local nXVDCICTD		:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDCI' )
	Local nXIMPRE		:= oModel:GetValue( 'CTDMASTER', 'CTD_XIMPRE' )
	Local nXCAMB		:= oModel:GetValue( 'CTDMASTER', 'CTD_XCAMB' )
	
	Local nXVDSICTD2	:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIP' )
	Local nXVDCICTD2	:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDCIP' )
	Local nXSISFP		:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFP' )
	
	Local nXVDSICTD3	:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDSIR' )
	Local nXVDCICTD3	:= oModel:GetValue( 'CTDMASTER', 'CTD_XVDCIR' )
	Local nXSISFR		:= oModel:GetValue( 'CTDMASTER', 'CTD_XSISFR' )
	
	
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
	
	
	Local nTotalD2		:= 0
	Local nTotalSD2_RES := 0
	Local nTotalE5		:= 0
	Local nTotalSE5_RES := 0
	Local nSaldoReal	:= 0
	
	Local nTotalZK		:= 0
	Local nTotalSZK_RES := 0
	Local nTotalZW		:= 0
	Local nTotalSZW_RES := 0
	Local nSaldoPla	:= 0
	
	Local nTotalZQ		:= 0
	Local nTotalSZQ_RES := 0
	Local nTotalE1		:= 0
	Local nTotalSE1_RES := 0
	Local nSaldoREV	:= 0
	Local nTotalE1A		:= 0
	Local nTotalSE1A_RES := 0
	Local dData1	:= ""	
	Local dData2	:= ""
	Local dData3	:= ""
	Local dData4	:= ""
	Local dData5	:= ""
	Local dData6	:= ""
	
	Local nTotalD1 := 0
	Local nTotalSD1_RES := 0
	Local nLen 		:= 0
	
	
	Local nNumSE5 			:= ""
	Local nTotalE5a 		:= 0
	Local nTotalSE5_RESa 	:= 0
	Local nNumSE5B 			:= ""
	Local nTotalE5b 		:= 0
	Local nTotalSE5_RESb 	:= 0
	
	Local nNumSD2			:= ""
	Local nTotalD2a			:= 0
	Local nNumSE1Ab			:= ""
	Local nTotalE1Ab		:= 0 
	
	Local nDataMovA
	Local nDataMovB
	
	///Local nRegSZK	:= oModelSZK:Length()
	Local nRegSZQ	:= oModelSZQ:Length()
	Local nVlrTribP	:= CTD_XVDCIP - CTD_XVDSIP
	Local nVlrTribR	:= CTD_XVDCIR - CTD_XVDSIR
	Local nVLRFATP  := 0
	Local nVLRFATR  := 0
	Local nVlrSIFATP := 0
	Local nVlrSIFATR := 0
	
	//----------------------- PLANEJADO -------------------------------------
	/*
	For nI2 := 1 To oModelSZK:Length()
			oModelSZK:GoLine( nI2 ) 
			nTotalZK		:= oModel:GetValue( 'SZKDETAIL', 'ZK_VLRPL' )	
			nTotalSZK_RES += Round( nTotalZK , 2 ) 
				   	
	Next nI2
	
	
	For nI22 := 1 To oModelSZK:Length()
		oModelSZK:GoLine( nI22 ) 
		nVLRFATP		:= oModel:GetValue( 'SZKDETAIL', 'ZK_VLRPL' )	
		nVlrSIFATP := 	nVLRFATP - (nVlrTribP * (nVLRFATP / CTD_XVDCIP))	
		oModelSZK:SetValue('ZK_VLRPLSI', nVlrSIFATP)
		
		nVLRFATP := 0
		nVlrSIFATP := 0
	Next nI22
	
	
	
	For nI3 := 1 To oModelSZW:Length()
			oModelSZW:GoLine( nI3) 
			nTotalZW		:= oModel:GetValue( 'SZWDETAIL', 'ZW_VLRREC' )	
			nTotalSZW_RES += Round( nTotalZW , 2 ) 
				   	
	Next nI3
	
	oModelSZK:GoLine( 1 )
	dData3		:= oModel:GetValue( 'SZKDETAIL', 'ZK_DATA' ) 
	dData4		:= oModel:GetValue( 'SZKDETAIL', 'ZK_DATA' )
	
	For nI11 := 1 To oModelSZK:Length()
			oModelSZK:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SZKDETAIL', 'ZK_DATA' )
			
			For nI12 := 1 To oModelSZK:Length()
				oModelSZK:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SZKDETAIL', 'ZK_DATA' )
				
				IF dData2 > dData1
					dData3 := dData2
				endif
				
				IF dData2 < dData1
					dData3 := dData1
				endif
													
			Next nI12
			
			if dData3 > dData4
				dData4 := dData3
			else
				dData4 := dData4
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0
	
	/*
	oModelSZW:GoLine( 1 )
	dData5		:= oModel:GetValue( 'SZWDETAIL', 'ZW_DATA' ) 
	dData6		:= oModel:GetValue( 'SZWDETAIL', 'ZW_DATA' )
	
	For nI11 := 1 To oModelSZW:Length()
			oModelSZW:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SZWDETAIL', 'ZW_DATA' )
			
			For nI12 := 1 To oModelSZW:Length()
				oModelSZW:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SZWDETAIL', 'ZW_DATA' )
				
				IF dData2 > dData1
					dData5 := dData2
				endif
				
				IF dData2 < dData1
					dData5 := dData1
				endif
													
			Next nI12
			
			if dData5 > dData6
				dData6 := dData5
			else
				dData6 := dData6
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0

	//msginfo ( nData3 )
	
	oModelSZZ:GoLine( 1 )
	
	oModelSZZ:SetValue('ZZ_PVSI', nXVDSICTD2 )
	oModelSZZ:SetValue('ZZ_PVCI', nXVDCICTD2 )
	oModelSZZ:SetValue('ZZ_DTFAT', dData4 )
	oModelSZZ:SetValue('ZZ_FATCTR', nTotalSZK_RES )
	oModelSZZ:SetValue('ZZ_DTREC', dData6 )
	oModelSZZ:SetValue('ZZ_RECCTR', nTotalSZW_RES )
	oModelSZZ:SetValue('ZZ_SALDO', nXVDCICTD2 - nTotalSZK_RES )
	oModelSZZ:SetValue('ZZ_SLDREC', nXVDCICTD2 - nTotalSZW_RES )
	
	*/
	
	//----------------------- REVISADO -------------------------------------
	
	For nI4 := 1 To oModelSZQ:Length()
			oModelSZQ:GoLine( nI4 ) 
			nTotalZQ		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_FATREV' )	
			nTotalSZQ_RES += Round( nTotalZQ , 2 ) 
				   	
	Next nI4
	
	For nI23 := 1 To oModelSZQ:Length()
		oModelSZQ:GoLine( nI23 ) 
		nVLRFATR		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_FATREV' )	
		nVlrSIFATR := 	nVLRFATR- (nVlrTribR * (nVLRFATR / CTD_XVDCIR))	
		oModelSZQ:SetValue('ZQ_FATRVSI', nVlrSIFATR)
		
		nVLRFATR := 0
		nVlrSIFATR := 0
	Next nI23
	
	For nI5 := 1 To oModelSE1:Length()
			oModelSE1:GoLine( nI5) 
			nTotalE1		:= oModel:GetValue( 'SE1DETAIL', 'E1_VLCRUZ' )	
			nTotalSE1_RES += Round( nTotalE1 , 2 ) 
				   	
	Next nI5
	
	oModelSZQ:GoLine( 1 )
	dData3		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_DATA' ) 
	dData4		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_DATA' )
	
	For nI11 := 1 To oModelSZQ:Length()
			oModelSZQ:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_DATA' )
			
			For nI12 := 1 To oModelSZQ:Length()
				oModelSZQ:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SZQDETAIL', 'ZQ_DATA' )
				
				IF dData2 > dData1
					dData3 := dData2
				endif
				
				IF dData2 < dData1
					dData3 := dData1
				endif
													
			Next nI12
			
			if dData3 > dData4
				dData4 := dData3
			else
				dData4 := dData4
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0
	
	oModelSE1:GoLine( 1 )
	dData5		:= oModel:GetValue( 'SE1DETAIL', 'E1_VENCREA' ) 
	dData6		:= oModel:GetValue( 'SE1DETAIL', 'E1_VENCREA' )
	
	For nI11 := 1 To oModelSE1:Length()
			oModelSE1:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SE1DETAIL', 'E1_VENCREA' )
			
			For nI12 := 1 To oModelSE1:Length()
				oModelSE1:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SE1DETAIL', 'E1_VENCREA' )
				
				IF dData2 > dData1
					dData5 := dData2
				endif
				
				IF dData2 < dData1
					dData5 := dData1
				endif
													
			Next nI12
			
			if dData5 > dData6
				dData6 := dData5
			else
				dData6 := dData6
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0
	
	oModelSZZ:GoLine( 2 )
	
	oModelSZZ:SetValue('ZZ_PVSI', nXVDSICTD3 )
	oModelSZZ:SetValue('ZZ_PVCI', nXVDCICTD3 )
	oModelSZZ:SetValue('ZZ_DTFAT', dData4 )
	oModelSZZ:SetValue('ZZ_FATCTR', nTotalSZQ_RES )
	oModelSZZ:SetValue('ZZ_DTREC', dData6 )
	oModelSZZ:SetValue('ZZ_RECCTR', nTotalSE1_RES )
	
	oModelSZZ:SetValue('ZZ_SALDO', nXVDCICTD3 - nTotalSZQ_RES )
	oModelSZZ:SetValue('ZZ_SLDREC', nXVDCICTD3 - nTotalSE1_RES )
	
	//----------------------- REALIZADO -------------------------------------
	
	
	//************
	
	If oModelSD2:Length() > 0 .AND. oModelSE1A:Length() > 0
	
		For nI := 1 To oModelSD2:Length()
		
			oModelSD2:GoLine( nI) 
			nNumSD2 := oModel:GetValue( 'SD2DETAIL', 'D2_DOC' )
			
			oModelSD2:GoLine( nI ) 
			nTotalD2a		:= oModel:GetValue( 'SD2DETAIL', 'D2_VALBRUT' )	
			
			For nI15 := 1 To oModelSE1A:Length()
			
				oModelSE1A:GoLine( nI15 ) 
				nNumSE1Ab := oModel:GetValue( 'SE1DETAILA', 'E1_NUM' )
				
				if nNumSD2 <> nNumSE1Ab
					
					oModelSE1A:GoLine( nI15 ) 
					nTotalE1Ab		:= oModel:GetValue( 'SE1DETAILA', 'E1_VLCRUZ' )	
				
				endif
					   	
			Next nI15
			
			nTotalSD2_RES += nTotalD2a + nTotalE1Ab
			   	
		Next nI
	
	else
	
		For nI := 1 To oModelSD2:Length()
			oModelSD2:GoLine( nI ) 
			nTotalD2		:= oModel:GetValue( 'SD2DETAIL', 'D2_VALBRUT' )	
			nTotalSD2_RES += Round( nTotalD2 , 2 ) 
				   	
		Next nI
		
		If nTotalSD2_RES = 0
	
			For nI15 := 1 To oModelSE1A:Length()
					oModelSE1A:GoLine( nI15 ) 
					nTotalE1A		:= oModel:GetValue( 'SE1DETAILA', 'E1_VLCRUZ' )	
					//nTotalSE1A_RES += Round( nTotalE1A , 2 ) 
					nTotalSD2_RES += Round( nTotalE1A , 2 )  	   	
			Next nI15
		
		endif
	
	Endif
	
	For nI19 := 1 To oModelSD1:Length()
			oModelSD1:GoLine( nI19 ) 
			nTotalD1		:= oModel:GetValue( 'SD1DETAIL', 'D1_TOTAL' ) + oModel:GetValue( 'SD1DETAIL', 'D1_VALIPI' )
			nTotalSD1_RES += Round( nTotalD1 , 2 ) 
				   	
	Next nI19
		
	//************
/*
	If oModelSE5:Length() > 0 .AND. oModelSE5B:Length() > 0 
		
		For nI21 := 1 To oModelSE5:Length()
	
			oModelSE5:GoLine( nI21) 
			nNumSE5 := oModel:GetValue( 'SE5DETAIL', 'E5_NUMERO' )
			nDataMovA		:= oModel:GetValue( 'SE5DETAILB', 'E5_DATA' )
			
			IF oModel:GetValue( 'SE5DETAIL', 'E5_TIPO' ) <> 'RA'
				IF oModel:GetValue( 'SE5DETAIL', 'E5_TIPODOC' ) = 'ES'
					nTotalE5a		+= -oModel:GetValue( 'SE5DETAIL', 'E5_VALOR' )
				ELSE
					nTotalE5a		+= oModel:GetValue( 'SE5DETAIL', 'E5_VALOR' )
				ENDIF
			ENDIF
			
		
		Next nI21
		
		For nI20 := 1 To oModelSE5B:Length()
					
					oModelSE5B:GoLine( nI20)
					nNumSE5B := oModel:GetValue( 'SE5DETAILB', 'E5_NUMERO' )
										
					//if nNumSE5 == nNumSE5B .AND. nTotalE5a <> nTotalE5b .AND. nDataMovA <> nDataMovB
					
						//oModelSE5B:GoLine( nI20) 
						nTotalE5b		+= oModel:GetValue( 'SE5DETAILB', 'E5_VALOR' )
		
					//endif
					
		Next nI20
		
		nTotalSE5_RES += nTotalE5a + nTotalE5b
		
	Else
	
*/		
/*
		For nI1 := 1 To oModelSE5:Length()
			oModelSE5:GoLine( nI1) 
			IF oModel:GetValue( 'SE5DETAIL', 'E5_TIPODOC' ) = 'ES'
				nTotalE5		:= -oModel:GetValue( 'SE5DETAIL', 'E5_VALOR' )
			ELSE
				nTotalE5		:= oModel:GetValue( 'SE5DETAIL', 'E5_VALOR' )
			ENDIF
			
			nTotalSE5_RES += Round( nTotalE5 , 2 ) 
				   	
		Next nI1
		
		if nTotalSE5_RES = 0
		
			For nI18 := 1 To oModelSE5B:Length()
					oModelSE5B:GoLine( nI18) 
					nTotalE5		:= oModel:GetValue( 'SE5DETAILB', 'E5_VALOR' )
					nTotalSE5_RES += Round( nTotalE5 , 2 ) 
						   	
			Next nI18
	
		endif
		
//	endif
	
	oModelSD2:GoLine( 1 )
	dData3		:= oModel:GetValue( 'SD2DETAIL', 'D2_EMISSAO' ) 
	dData4		:= oModel:GetValue( 'SD2DETAIL', 'D2_EMISSAO' )
	
	For nI11 := 1 To oModelSD2:Length()
			oModelSD2:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SD2DETAIL', 'D2_EMISSAO' )
			
			For nI12 := 1 To oModelSD2:Length()
				oModelSD2:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SD2DETAIL', 'D2_EMISSAO' )
				
				IF dData2 > dData1
					dData3 := dData2
				endif
				
				IF dData2 < dData1
					dData3 := dData1
				endif
													
			Next nI12
			
			if dData3 > dData4
				dData4 := dData3
			else
				dData4 := dData4
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0
	
	If nTotalSD2_RES = 0
	
		oModelSE1A:GoLine( 1 )
		dData3		:= oModel:GetValue( 'SE1DETAILA', 'E1_VENCREA' ) 
		dData4		:= oModel:GetValue( 'SE1DETAILA', 'E1_VENCREA' )
	
		For nI16 := 1 To oModelSE1A:Length()
				oModelSE1A:GoLine( nI16) 
				dData1		:= oModel:GetValue( 'SE1DETAILA', 'E1_VENCREA' )
				
				For nI17 := 1 To oModelSE1A:Length()
					oModelSE1A:GoLine( nI17)
					dData2		:= oModel:GetValue( 'SE1DETAILA', 'E1_VENCREA' )
					
					IF dData2 > dData1
						dData3 := dData2
					endif
					
					IF dData2 < dData1
						dData3 := dData1
					endif
														
				Next nI12
				
				if dData3 > dData4
					dData4 := dData3
				else
					dData4 := dData4
				endif
				
				nI17 := 0
				   	
		Next nI16
		nI16 := 0
		nI17 := 0
	
	Endif
	
	oModelSE5:GoLine( 1 )
	dData5		:= oModel:GetValue( 'SE5DETAIL', 'E5_DATA' ) 
	dData6		:= oModel:GetValue( 'SE5DETAIL', 'E5_DATA' )
	
	For nI11 := 1 To oModelSE5:Length()
			oModelSE5:GoLine( nI11) 
			dData1		:= oModel:GetValue( 'SE5DETAIL', 'E5_DATA' )
			
			For nI12 := 1 To oModelSE5:Length()
				oModelSE5:GoLine( nI12)
				dData2		:= oModel:GetValue( 'SE5DETAIL', 'E5_DATA' )
				
				IF dData2 > dData1
					dData5 := dData2
				endif
				
				IF dData2 < dData1
					dData5 := dData1
				endif
													
			Next nI12
			
			if dData5 > dData6
				dData6 := dData5
			else
				dData6 := dData6
			endif
			
			nI12 := 0
			   	
	Next nI11
	nI11 := 0
	nI12 := 0
	
	if Empty(dData5)
		
		oModelSE5B:GoLine( 1 )
		dData5		:= oModel:GetValue( 'SE5DETAILB', 'E5_DATA' ) 
		dData6		:= oModel:GetValue( 'SE5DETAILB', 'E5_DATA' )
		
		For nI11 := 1 To oModelSE5B:Length()
				oModelSE5B:GoLine( nI11) 
				dData1		:= oModel:GetValue( 'SE5DETAILB', 'E5_DATA' )
				
				For nI12 := 1 To oModelSE5B:Length()
					oModelSE5B:GoLine( nI12)
					dData2		:= oModel:GetValue( 'SE5DETAILB', 'E5_DATA' )
					
					IF dData2 > dData1
						dData5 := dData2
					endif
					
					IF dData2 < dData1
						dData5 := dData1
					endif
														
				Next nI12
				
				if dData5 > dData6
					dData6 := dData5
				else
					dData6 := dData6
				endif
				
				nI12 := 0
				   	
		Next nI11
		nI11 := 0
		nI12 := 0
	
	endif
	
	oModelSZZ:GoLine( 3 )
	
	oModelSZZ:SetValue('ZZ_PVSI', nXVDSICTD3 )
	oModelSZZ:SetValue('ZZ_PVCI', nXVDCICTD3 )
	oModelSZZ:SetValue('ZZ_DTFAT', dData4 )
	If nTotalSD2_RES > 0
		oModelSZZ:SetValue('ZZ_FATCTR', nTotalSD2_RES - nTotalSD1_RES  )
	Else
		oModelSZZ:SetValue('ZZ_FATCTR', nTotalSE1A_RES )
	Endif
	oModelSZZ:SetValue('ZZ_DTREC', dData6 )
	oModelSZZ:SetValue('ZZ_RECCTR', nTotalSE5_RES + nXIMPRE + nXCAMB )
	
	oModelSZZ:SetValue('ZZ_SALDO', nXVDCICTD3 - (nTotalSD2_RES - nTotalSD1_RES) )
	oModelSZZ:SetValue('ZZ_SLDREC', nXVDCICTD3 - (nTotalSE5_RES + nXIMPRE + nXCAMB) )
	
	//----------------------- SALDO -------------------------------------
	oModelSZZ:GoLine( 4 )
	nLen 	:= oModelSZQ:Length(.T.)
	
	
	oModelSZZ:SetValue('ZZ_PVSI', 0 )
	oModelSZZ:SetValue('ZZ_PVCI', 0 )
	
	IF nTotalSZQ_RES  = 0 
		oModelSZZ:SetValue('ZZ_FATCTR', 0 )
	ELSE
		oModelSZZ:SetValue('ZZ_FATCTR', nTotalSZQ_RES - nTotalSD2_RES )
	ENDIF
	
	nLen 	:= oModelSE1:Length(.T.)
	
	IF nTotalSE1_RES = 0 
		oModelSZZ:SetValue('ZZ_RECCTR', 0 )
	ELSE
		oModelSZZ:SetValue('ZZ_RECCTR', nTotalSE1_RES - (nTotalSE5_RES + nXIMPRE)  )
	ENDIF
	
	IF  (nXVDCICTD3 - (nTotalSD2_RES - nTotalSD1_RES)) = 0
		oModelSZZ:SetValue('ZZ_SALDO', 0 )
	ELSE
		oModelSZZ:SetValue('ZZ_SALDO',  (nXVDCICTD3 - nTotalSZQ_RES) - (nXVDCICTD3 - (nTotalSD2_RES - nTotalSD1_RES)) )
	ENDIF
	
	IF  (nXVDCICTD3 - (nTotalSE5_RES +  nXIMPRE + nXCAMB)) = 0
		oModelSZZ:SetValue('ZZ_SLDREC', 0 )
	ELSE
		oModelSZZ:SetValue('ZZ_SLDREC',  (nXVDCICTD3 - nTotalSE1_RES) - (nXVDCICTD3 - (nTotalSE5_RES + nXIMPRE + nXCAMB)) )
	ENDIF
	
	//-------------------------------------------------------------------------------------------
	
	*/
		
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
    Local oModel        := FWLoadModel('zMVCMdX2')
    Local oStPai        := FWFormStruct(2, 'CTD')
    Local oStPai2       := FWFormStruct(2, 'CTD')
    //Local oStFilho1  	:= FWFormStruct(2, 'SZZ')
    //Local oStFilho1A  	:= FWFormStruct(2, 'SZZ')
    // Local oStFilho1C  	:= FWFormStruct(2, 'SZZ')
    //Local oStFilho2  	:= FWFormStruct(2, 'SZK')
    //Local oStFilho3  	:= FWFormStruct(2, 'SZW')
    Local oStFilho4  	:= FWFormStruct(2, 'SD2')
    Local oStFilho5  	:= FWFormStruct(2, 'SE1')
    Local oStFilho5A  	:= FWFormStruct(2, 'SE1')
    Local oStFilho6  	:= FWFormStruct(2, 'SE5')
    Local oStFilho6B  	:= FWFormStruct(2, 'SE5')
    Local oStFilho7  	:= FWFormStruct(2, 'SZQ')
    Local oStFilho8  	:= FWFormStruct(2, 'SD1')
    
      
    //Local oStTot        := FWCalcStruct(oModel:GetModel('TOT_SALDO'))
    //Estruturas das tabelas e campos a serem considerados
    Local aStruCTD  := CTD->(DbStruct())
    Local aStruCTD2  := CTD->(DbStruct())
    
    //Local aStruSZZ  := SZZ->(DbStruct())
    //Local aStruSZZA  := SZZ->(DbStruct())
    //Local aStruSZZC  := SZZ->(DbStruct())
    //Local aStruSZK  := SZK->(DbStruct())
    //Local aStruSZW  := SZW->(DbStruct())
    Local aStruSD2  := SD2->(DbStruct())
    Local aStruSE1  := SE1->(DbStruct())
    Local aStruSE1A  := SE1->(DbStruct())
    Local aStruSE5  := SE5->(DbStruct())
    Local aStruSE5B  := SE5->(DbStruct())
    Local aStruSZQ  := SZQ->(DbStruct())
    Local aStruSD1  := SD1->(DbStruct())
     //Local aStruSZU  := SZU->(DbStruct())
    //Local cConsCTD  := "CTD_ITEM;CTD_XTIPO;CTD_XEQUIP;CTD_XCLIEN;CTD_XNREDU;CTD_XDESC;CTD_XCUSTO;CTD_XCUTOT;CTD_XVDCI;CTD_XVDSI;CTD_XVDCID;CTD_XVDSID;CTD_NPROP;CTD_DTEXIS;CTD_DTEXSF;CTD_XCVP;CTD_XSISFV;CTD_XSISFP;CTD_SISFR"
    //Local cConsCTD2  := "CTD_XVDCIP;CTD_XVDSIP;CTD_XVDCIR;CTD_XVDSIR;CTD_XIMPRE;CTD_XCAMB"
    //Local cConsSZZ  := "ZZ_FILIAL;ZZ_ITEM;ZZ_DESCRI;ZZ_PVSI;ZZ_PVCI;ZZ_DTFAT;ZZ_FATCTR;ZZ_DTREC;ZZ_RECCTR;ZZ_SALDO;ZZ_SLDREC;ZZ_ITEMIC"
    //Local cConsSZZA  := "ZZ_FILIAL;ZZ_ITEM;ZZ_DESCRI;ZZ_PVSI;ZZ_PVCI;ZZ_DTFAT;ZZ_FATCTR;ZZ_DTREC;ZZ_RECCTR;ZZ_SALDO;ZZ_SLDREC;ZZ_ITEMIC"
    //Local cConsSZZC  := "ZZ_FILIAL;ZZ_ITEM;ZZ_DESCRI;ZZ_PVSI;ZZ_PVCI;ZZ_DTFAT;ZZ_FATCTR;ZZ_DTREC;ZZ_RECCTR;ZZ_SALDO;ZZ_SLDREC;ZZ_ITEMIC"
    //Local cConsSZK  := "ZK_FILIAL;ZK_ITEM;ZK_DATA;ZK_DESCRI;ZK_VLRPL;ZK_VLRPLSI;ZK_ITEMIC"
    //Local cConsSZW  := "ZW_FILIAL;ZW_ITEM;ZW_DATA;ZW_DESCRI;ZW_VLRREC;ZW_ITEMCTA"
    Local cConsSD2  := "D2_FILIAL;D2_ITEMCC;D2_DOC;D2_SERIE;D2_CF;D2_EMISSAO;D2_VALBRUT"
    Local cConsSE1  := "E1_FILIAL;E1_NUM;E1_TIPO;E1_VENCREA;E1_BAIXA;E1_VLCRUZ;E1_XXIC;E1_HIST" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
    Local cConsSE1A  := "E1_FILIAL;E1_NUM;E1_TIPO;E1_VENCREA;E1_BAIXA;E1_VLCRUZ;E1_XXIC" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
    Local cConsSE5  := "E5_RECPAG;E5_XXIC;E5_NUMERO;E5_DATA;E5_VALOR;E5_BENEF;E5_HISTOR;E5_DOCUME;E5_TIPO;E5_BANCO;E5_AGENCIA;E5_CONTA;E5_TIPODOC;E5_NUMERO" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
	Local cConsSE5B  := "E5_RECPAG;E5_XXIC;E5_NUMERO;E5_DATA;E5_VALOR;E5_BENEF;E5_HISTOR;E5_DOCUME;E5_TIPO;E5_BANCO;E5_AGENCIA;E5_CONTA;E5_TIPODOC;E5_NUMERO" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
    Local cConsSZQ  := "ZQ_FILIAL;ZQ_ITEM;ZQ_DATA;ZQ_DESCRI;ZQ_FATREV;ZQ_FATRVSI;ZQ_ITEMIC" //;E1_CLIENTE;E1_NOMCLI;E2_XXIC
	Local cConsSD1  := "D1_FILIAL;D1_ITEMCTA;D1_DOC;D1_EMISSAO;D1_FORNECE;D1_TOTAL;D1_VALIPI;D1_CUSTO;D1_CF;D1_PEDIDO;D1_XTIPO"
    Local nAtual        := 0
     
     
     
    //Criando a View
	
	//Local oStrSD2:= FWCalcStruct( oModel:GetModel('calcREAL') )
	//Local oStrSZQ:= FWCalcStruct( oModel:GetModel('calcPLRV') )
	//Local oStrSZF:= FWCalcStruct( oModel:GetModel('calcSZF') )
	 
    oView := FWFormView():New()
    
    oView:SetModel(oModel)
      
    //Adicionando os campos do cabeçalho e o grid dos filhos
     
    
    oView:AddField('VIEW_CTD3',oStPai,'CTDMASTER')
    //oView:AddField('VIEW_CTD2',oStPai2,'CTDMASTER')
    //oView:AddGrid('VIEW_SZZ',oStFilho1,'SZZDETAIL')
    //oView:AddGrid('VIEW_SZZA',oStFilho1A,'SZZDETAILA')
    //oView:AddGrid('VIEW_SZZC',oStFilho1C,'SZZDETAILC')
    //oView:AddGrid('VIEW_SZK',oStFilho2,'SZKDETAIL')
    //oView:AddGrid('VIEW_SZW',oStFilho3,'SZWDETAIL')
    oView:AddGrid('VIEW_SD2',oStFilho4,'SD2DETAIL')
    oView:AddGrid('VIEW_SE1',oStFilho5,'SE1DETAIL')
    oView:AddGrid('VIEW_SE1A',oStFilho5A,'SE1DETAILA')
    oView:AddGrid('VIEW_SE5',oStFilho6,'SE5DETAIL')
    oView:AddGrid('VIEW_SE5B',oStFilho6B,'SE5DETAILB')
    oView:AddGrid('VIEW_SZQ',oStFilho7,'SZQDETAIL')
    oView:AddGrid('VIEW_SD1',oStFilho8,'SD1DETAIL')
  
    
	//oView:AddField('formCalcSD2', oStrSD2,'calcREAL')
	//oView:AddField('formCalcSZQ', oStrSZQ,'calcPLRV')
	
	
    //oView:AddField('VIEW_TOT', oStTot,'TOT_SALDO')
    //Setando o dimensionamento de tamanho
     
    oView:CreateFolder( 'FOLDER1')
    
   	oView:AddSheet('FOLDER1','SHEET11','Faturamento / Recebimento Realizado ')
   	oView:AddSheet('FOLDER1','SHEET12','Faturamento / Recebimento Revisado / Planejedo')
   	oView:AddSheet('FOLDER1','SHEET9','Destalhes Contrato ')
   
   	//oView:AddSheet('FOLDER1','SHEET13','Faturamento / Recebimento Realizado')
	
	//oView:CreateHorizontalBox('CABEC4',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo	
	oView:CreateHorizontalBox('CABEC3',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	//oView:CreateHorizontalBox('CABEC2',50, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET9')	// Detalhes Contrato - Resumo
	
	//oView:CreateHorizontalBox('BOX56A',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Resumo
	
    //oView:CreateHorizontalBox('GRID11',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Vendido
	//oView:CreateVerticalBox('GRID11A',50, 'GRID11', /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Planejado
	//oView:CreateVerticalBox('GRID11B',50, 'GRID11', /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Planejado
	
	oView:CreateHorizontalBox('GRID12',100, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Vendido
	oView:CreateVerticalBox('GRID12A',50, 'GRID12', /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRID12B',50, 'GRID12', /*lUsePixel*/, 'FOLDER1', 'SHEET12')	// Outros Custos Planejado
	
	
	//oView:CreateHorizontalBox('BOX56',30, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Resumo
	
	oView:CreateHorizontalBox('GRID13',33, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Vendido
	oView:CreateVerticalBox('GRID13A',50, 'GRID13', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRID13B',50, 'GRID13', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	
	oView:CreateHorizontalBox('GRID14',33, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Vendido
	oView:CreateVerticalBox('GRID14A',50, 'GRID14', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	oView:CreateVerticalBox('GRID14B',50, 'GRID14', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado

	oView:CreateHorizontalBox('GRID16',34, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Vendido
	oView:CreateVerticalBox('GRID16A',50, 'GRID16', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
	//oView:CreateVerticalBox('GRID14B',50, 'GRID14', /*lUsePixel*/, 'FOLDER1', 'SHEET11')	// Outros Custos Planejado
 
   
   	//------------------------------------------------------------------------------------------
	//oView:CreateHorizontalBox( 'boxCalcReal', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET13')
	//oView:SetOwnerView('formCalcSD2','boxCalcReal')
	//------------------------------------------------------------------------------------------
	//------------------------------------------------------------------------------------------
	//oView:CreateHorizontalBox( 'boxCalcPLVL', 20, /*owner*/, /*lUsePixel*/, 'FOLDER1', 'SHEET11')
	//oView:SetOwnerView('formCalcSZQ','boxCalcPLVL')
	//------------------------------------------------------------------------------------------

    //Amarrando a view com as box
        
    oView:SetOwnerView('VIEW_CTD3','CABEC3')
    //oView:SetOwnerView('VIEW_CTD2','CABEC2')
   // oView:SetOwnerView('VIEW_SZZC','CABEC4')
   // oView:SetOwnerView('VIEW_SZZ','BOX56')
   // oView:SetOwnerView('VIEW_SZZA','BOX56A')
    
    //oView:SetOwnerView('VIEW_SZK','GRID11A')
    //oView:SetOwnerView('VIEW_SZW','GRID11B')
    
    oView:SetOwnerView('VIEW_SZQ','GRID12A')
    oView:SetOwnerView('VIEW_SE1','GRID12B')
    
    oView:SetOwnerView('VIEW_SD2','GRID13A')
    oView:SetOwnerView('VIEW_SE5','GRID13B')
    
    oView:SetOwnerView('VIEW_SE1A','GRID14A')
    oView:SetOwnerView('VIEW_SE5B','GRID14B')
    
    oView:SetOwnerView('VIEW_SD1','GRID16A')
    

	//oView:EnableTitleView('formCalcSD2' , 'Total' )
	//oView:EnableTitleView('formCalcSZQ' , 'Total' )
	
	//oView:AddIncrementField('VIEW_SZZ' , 'ZZ_ITEM' ) 
	//oView:AddIncrementField('VIEW_SZK' , 'ZK_ITEM' ) 
	//oView:AddIncrementField('VIEW_SZW' , 'ZW_ITEM' )
	oView:AddIncrementField('VIEW_SZQ' , 'ZQ_ITEM' ) 
		
	oView:SetViewProperty('VIEW_CTD3' , 'ONLYVIEW' )
	
	//oView:SetViewProperty('VIEW_SZZ' , 'ONLYVIEW' )
	//oView:SetViewProperty('VIEW_SZZA' , 'ONLYVIEW' )
	//oView:SetViewProperty('VIEW_SZZC' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE5')
	oView:SetNoDeleteLine('VIEW_SE5')
	oView:SetNoInsertLine('VIEW_SE5')
	oView:SetViewProperty('VIEW_SE5' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE5B')
	oView:SetNoDeleteLine('VIEW_SE5B')
	oView:SetNoInsertLine('VIEW_SE5B')
	oView:SetViewProperty('VIEW_SE5B' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SD2')
	oView:SetNoDeleteLine('VIEW_SD2')
	oView:SetNoInsertLine('VIEW_SD2')
	oView:SetViewProperty('VIEW_SD2' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SD1')
	oView:SetNoDeleteLine('VIEW_SD1')
	oView:SetNoInsertLine('VIEW_SD1')
	oView:SetViewProperty('VIEW_SD1' , 'ONLYVIEW' )
	
	//oView:SetNoUpdateLine('VIEW_SE1')
	oView:SetNoDeleteLine('VIEW_SE1')
	oView:SetNoInsertLine('VIEW_SE1')
	oView:SetViewProperty('VIEW_SE1' , 'ONLYVIEW' )
	
	oView:SetNoUpdateLine('VIEW_SE1A')
	oView:SetNoDeleteLine('VIEW_SE1A')
	oView:SetNoInsertLine('VIEW_SE1A')
	oView:SetViewProperty('VIEW_SE1A' , 'ONLYVIEW' )
	
    
    //Habilitando título
    //oView:EnableTitleView('VIEW_SZZ','Resumo')
    //oView:EnableTitleView('VIEW_SZZA','Resumo')
    //oView:EnableTitleView('VIEW_SZZC','Resumo')
    //oView:EnableTitleView('VIEW_CTD2','Venda / Custo Total Planjejado / Revisado')
    //oView:EnableTitleView('VIEW_SZK','Faturamento Planejado')
    //oView:EnableTitleView('VIEW_SZW','Recebimento Planejado')
    oView:EnableTitleView('VIEW_SZQ','Faturamento Revisado')
    oView:EnableTitleView('VIEW_SE1','Rebimento Revisado')
    oView:EnableTitleView('VIEW_SE1A','Invoice')
    oView:EnableTitleView('VIEW_SD2','Faturamento Realizado')
    oView:EnableTitleView('VIEW_SE5','Recebimento Realizado')
    oView:EnableTitleView('VIEW_SE5B','Compensacao')
    oView:EnableTitleView('VIEW_SD1','NF Devolucao')
    	  
	// Criando botao
	//oView:AddUserButton( 'Copia Vend. p/ Planej.', 'CLIPS', {|oView| COMP021BUT()} )  
	//oView:Refresh()  
	  
    //Percorrendo a estrutura da CTD
    /*
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
     */
    /*
    //Percorrendo a estrutura da SZZ
    For nAtual := 1 To Len(aStruSZZ)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZZ[nAtual][01]) $ cConsSZZ
            oStFilho1:RemoveField(aStruSZZ[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SZZ
    For nAtual := 1 To Len(aStruSZZA)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZZA[nAtual][01]) $ cConsSZZA
            oStFilho1A:RemoveField(aStruSZZA[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SZZ
    For nAtual := 1 To Len(aStruSZZC)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZZC[nAtual][01]) $ cConsSZZC
            oStFilho1C:RemoveField(aStruSZZC[nAtual][01])
        EndIf
    Next
    /*
    //Percorrendo a estrutura da SZK
    For nAtual := 1 To Len(aStruSZK)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZK[nAtual][01]) $ cConsSZK
            oStFilho2:RemoveField(aStruSZK[nAtual][01])
        EndIf
    Next
    
        
    //Percorrendo a estrutura da SZW
    For nAtual := 1 To Len(aStruSZW)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZW[nAtual][01]) $ cConsSZW
            oStFilho3:RemoveField(aStruSZW[nAtual][01])
        EndIf
    Next
    */
     //Percorrendo a estrutura da SD2
    For nAtual := 1 To Len(aStruSD2)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSD2[nAtual][01]) $ cConsSD2
            oStFilho4:RemoveField(aStruSD2[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SD2
    For nAtual := 1 To Len(aStruSD1)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSD1[nAtual][01]) $ cConsSD1
            oStFilho8:RemoveField(aStruSD1[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SE1
    For nAtual := 1 To Len(aStruSE1)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE1[nAtual][01]) $ cConsSE1
            oStFilho5:RemoveField(aStruSE1[nAtual][01])
        EndIf
    Next
    
     //Percorrendo a estrutura da SE1
    For nAtual := 1 To Len(aStruSE1A)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE1A[nAtual][01]) $ cConsSE1A
            oStFilho5A:RemoveField(aStruSE1A[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE5
    For nAtual := 1 To Len(aStruSE5)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE5[nAtual][01]) $ cConsSE5
            oStFilho6:RemoveField(aStruSE5[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SE5
    For nAtual := 1 To Len(aStruSE5B)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSE5B[nAtual][01]) $ cConsSE5B
            oStFilho6B:RemoveField(aStruSE5B[nAtual][01])
        EndIf
    Next
    
    //Percorrendo a estrutura da SZQ
    For nAtual := 1 To Len(aStruSZQ)
        //Se o campo atual não estiver nos que forem considerados
        If ! Alltrim(aStruSZQ[nAtual][01]) $ cConsSZQ
            oStFilho7:RemoveField(aStruSZQ[nAtual][01])
        EndIf
    Next
	
Return oView
//-------------------------------------------------------------------

Static Function COMP021BUT( oModel )
	//Local nOperation 	:= oModel:GetOperation() 
	/*
	Local oStNeto   	:= FWFormStruct(1, 'SZD')
	Local oModelSZY   	:= oModel:GetModel( 'CTDMASTER' )
	Local oModelSZC   	:= oModel:GetModel( 'SZCDETAIL' )
	*/
	Local lRet 			:= .T.
	Local nLen			:= 0
	Local nI			:= 0
	Local nI2			:= 0
	//Local oModelSZZ   	:= oModel:GetModel( 'SZZDETAIL' )
	Local nITEMCTA		:= oModel:GetValue( 'CTDMASTER', 'CTD_ITEM' )
	Local cDescPla 	:= ""
	Local cDescRev 	:= ""
	Local cDescRea 	:= ""
	Local cDescSal 	:= ""
	Local cItemIC1	:= ""
	Local cItemIC2	:= ""
	Local cItemIC3	:= ""
	Local cItemIC4	:= ""
	
	
	nLen := 0
	
	//nLen 	:= oModelSZZ:Length(.T.) 
	//cItemIC1 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
	
	//if nLen = 1  
	
		//oModelSZZ:GoLine( 1 )
		
		//cItemIC1 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		//if Empty(cItemIC1) 
			//oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		//endif
	//endif 	
	

	/*
	if 	nLen < 2 	
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		
		oModelSZZ:GoLine( nLen )
		
		cItemIC2 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		if Empty(cItemIC2) 	
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
	endif	
	
	if 	nLen < 3 
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		oModelSZZ:GoLine( nLen )
		if  Empty(cItemIC3) 
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
		
	endif	
	

	if 	nLen < 4 
		oModelSZZ:AddLine()
		nLen 	:= oModelSZZ:Length(.T.) 
		oModelSZZ:GoLine( nLen )
		
		cItemIC4 := Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_ITEMIC' ))
		if Empty(cItemIC4)  
			oModelSZZ:SetValue('ZZ_ITEMIC', nITEMCTA )
		endif
	endif	
	
	
	oModelSZZ:GoLine( 1)
	cDescPla 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescPla <> 'PLANEJADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "PLANEJADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 2)
	cDescRev 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescRev <> 'REVISADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "REVISADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 3)
	cDescRea 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescRea <> 'REALIZADO'
		oModelSZZ:SetValue('ZZ_DESCRI', "REALIZADO" )
	ENDIF
	
	
	
	oModelSZZ:GoLine( 4)
	cDescSal 	:= Alltrim(oModel:GetValue( 'SZZDETAIL', 'ZZ_DESCRI' ))
	IF cDescSal <> 'SALDO'
		oModelSZZ:SetValue('ZZ_DESCRI', "SALDO" )
	ENDIF
		
	*/
		
Return lRet