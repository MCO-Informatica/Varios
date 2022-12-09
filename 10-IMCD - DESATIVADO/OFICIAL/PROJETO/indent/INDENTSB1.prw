#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
//
USER Function INDENTSB1()
Local oBrowse
Private cTitulo := 'CADASTRO SB1'
//Função "MBROWSE" e coloque o "SET DELETED OFF" no inicio do programa. 
oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SB1")
oBrowse:SetDescription( cTitulo )

oBrowse:SetFilterDefault( "B1_FILIAL == '99' " )

oBrowse:Activate()


Return
