//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Variáveis Estáticas
Static cTitulo := "Gestao de Contratos "
 
/*/ zMVCMdX
    @return Nil, Função não tem retorno
    @example
    u_zMVCMdX()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function zGCBROW2()
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
   
    oBrowse:SetFilterDefault( "CTD_ITEM<>'ADMINISTRACAO' .AND. CTD_ITEM<>'PROPOSTA' .AND. CTD_ITEM<>'QUALIDADE' .AND. CTD_ITEM<>'ATIVO' .AND. CTD_ITEM<>'ENGENHARIA' .AND. CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD_ITEM<>'XXXXXX' .AND. CTD_ITEM<>'OPERACOES' .AND. SUBSTR(CTD_ITEM,9,2) >= '15' "  ) 
    DbSetOrder(1)
    
    //u_zFJobAberto()
    
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    oBrowse:AddFilter("Contratos Fechados....",xCond)
    oBrowse:AddFilter("Contratos Abertos.....",xCond2,,.T.)
    oBrowse:AddFilter("Todos Contratos.......",xCond3)
    
    //Legendas
    oBrowse:AddLegend( "CTD->CTD_DTEXSF < Date()", "GRAY", "Fechado" )
    oBrowse:AddLegend( "CTD->CTD_DTEXSF >= Date()", "GREEN",   "Aberto" )
  
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
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'zMVC02Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
	
    ADD OPTION aRot TITLE 'Custos'    				ACTION 'U_zGestCTR' OPERATION 3  ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Planejado'    			ACTION 'VIEWDEF.zMVCVPX' 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Receb./Faturamento'    	ACTION 'VIEWDEF.zMVCMdX2' 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	

    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

