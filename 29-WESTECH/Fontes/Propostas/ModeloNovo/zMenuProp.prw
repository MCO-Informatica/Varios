#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include 'topconn.ch'
 
//Vari�veis Est�ticas
Static cTitulo := "Custos Proposta "
 
/*/ zMVCMdX
    @return Nil, Fun��o n�o tem retorno
    @example
    u_zMVCMdX()
    @obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/
 
User Function zMenuProp()
    Local aArea   := GetArea()
    Local oBrowse
   
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a descri��o da rotina
    oBrowse:SetAlias("SZ9")
   
     
    DbSetOrder(1)
    
    //u_zFJobAberto()
    
    //Setando a descri��o da rotina
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
/////////////////////////////////////////////////////////////////////
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    //ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    
    ADD OPTION aRot TITLE 'Custos '    				ACTION 'U_zGestProp' 	OPERATION 5  ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Legenda'    				ACTION 'U_zMVCPR2Leg'   OPERATION 6  ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Planejado'    			ACTION 'VIEWDEF.zMVCVPX' 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Receb./Faturamento'    ACTION 'VIEWDEF.zMVCMdX2' 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	

    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMdX' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot


user Function zMVCPR2Leg()
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