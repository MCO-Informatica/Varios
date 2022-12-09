#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ManutCont()


	Local oBrowse

	oBrowse:= FWmBrowse():New()
	oBrowse:SetDescription( "ManutenÁ„o de Container" )
	oBrowse:SetAlias( 'SF1' )
	oBrowse:SetOnlyFields( { 'F1_DOC', 'F1_SERIE', 'F1_FORNECE', 'F1_LOJA', 'F1_NOME','F1_EMISSAO', 'F1_XTOTM2' , 'F1_CONTAI'} )
	oBrowse:AddLegend( "F1_XSTATUS  == '1'", "GREEN"   	, "Em Desmontagem"    )
	oBrowse:AddLegend( "F1_XSTATUS  == '3'", "BLACK"   	, "Ja Desmontado"    )
	oBrowse:SetFilterDefault( "F1_XSTATUS <> ''" )
   oBrowse:SetFixedBrowse(.T.)
	oBrowse:ForceQuitButton()
   oBrowse:SetAmbiente(.T.) //Habilita a utiliza√ß√£o da funcionalidade Ambiente no Browse

   //Adiciona botoes na janela
   oBrowse:AddButton("Desmontagem"		, { || U_DESMONTA()},,,, .F., 2 )
   //oBrowse:AddButton("Detalhes"			, { || Alert(CriaVar('D3_LOTECTL'))},,,, .F., 2 )
   oBrowse:AddButton("Legenda"			, { || MANUTLEG()  },,,, .F., 2 )


	oBrowse:Activate()

  	oBrowse:Setfocus() //Seta o foco na grade



Return(.t.)



//Fun√ß√£o para criar a tela de legenda
Static Function MANUTLEG()

    Local oLegenda  :=  FWLegend():New()

    oLegenda:Add( '', 'BR_VERDE'   , "Em Desmontagem" )
    oLegenda:Add( '', 'BR_PRETO'   , "J· Desmontado"  )
    
    oLegenda:Activate()
    oLegenda:View()
    oLegenda:DeActivate()

Return Nil



	
	
	