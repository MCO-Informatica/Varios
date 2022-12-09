#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSAG0007    บAutor  ณClaudio Henrique Corr๊aบ Data ณ29/10/15บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de Tecnicos                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico CertiSign                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CSAG0007()
	
Private aRotina := MenuDef()
					
	oBrowse:= FWmBrowse():New()
	oBrowse:SetDescription( 'Tecnicos Atendimento' )
	oBrowse:SetAlias( 'PAX' )	
	oBrowse:SetProfileID( '1' )
	oBrowse:Activate()                                    
	
Return

Static Function MenuDef() // Cria็ใo do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 	ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.CSAG0007"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"		ACTION "VIEWDEF.CSAG0007"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"		ACTION "VIEWDEF.CSAG0007"			OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"		ACTION "VIEWDEF.CSAG0007"			OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Imprimir"		ACTION "VIEWDEF.CSAG0007"	  		OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE "Copiar"		ACTION "VIEWDEF.CSAG0007"			OPERATION 7 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruPAX := FWFormStruct(1,'PAX')
Local oModel

oModel := MPFormModel():New('CSAGMVC',,,)

oModel:AddFields('PAXMASTER',/*cOwner*/,oStruPAX)

oModel:SetPrimaryKey({'PAX_FILIAL','PAX_COD'})

oModel:SetDescription('Tecnicos Atendimento')

oModel:GetModel('PAXMASTER'):SetDescription('Tecnicos Atendimento')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0007')
Local oStruPAX:= FWFormStruct(2,'PAX')
Local oViewDef:=FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PAX',oStruPAX,'PAXMASTER')

oViewDef:CreateHorixontalBox('PAX',100)

oViewDef:SetOwnerView('VIEW_PAX','PAX')

Return oViewDef