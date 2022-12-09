#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSAG0006    �Autor  �Claudio Henrique Corr�a� Data �29/10/15���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro Postos de Atendimento                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSAG0006()
	
Private aRotina := MenuDef()
					
	oBrowse:= FWmBrowse():New()
	oBrowse:SetDescription( 'Postos de Atendimento' )
	oBrowse:SetAlias( 'PAZ' )	
	oBrowse:SetProfileID( '1' )
	oBrowse:Activate()                                    
	
Return

Static Function MenuDef() // Cria��o do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 				ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   			ACTION "VIEWDEF.CSAG0006"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"   				ACTION "VIEWDEF.CSAG0006"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"   				ACTION "VIEWDEF.CSAG0006"			OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruPAZ := FWFormStruct(1,'PAZ')
Local oStruPAV := FWFormStruct(1,'PAV')
Local oModel

oModel := MPFormModel():New('CSAGPAZ',,,)

oModel:AddFields('PAZMASTER',/*cOwner*/,oStruPAZ)
oModel:AddGrid('PAVDETAIL','PAZMASTER',oStruPAV)

oModel:SetRelation('PAVDETAIL',{ { 'PAV_FILIAL', 'xFilial("PAV")'},;
								 { 'PAV_AR', 'PAZ_COD' } }, PAV->( IndexKey( 1 )))

oModel:SetPrimaryKey({'PAZ_FILIAL','PAZ_COD'})

oModel:SetDescription('Postos de Atendimento')

oModel:GetModel( 'PAVDETAIL' ):SetOptional( .T. )

oModel:GetModel( 'PAVDETAIL' ):SetMaxLine( 1 )

oModel:GetModel('PAZMASTER'):SetDescription('Cabe�alho Postos de Atendimento')

oModel:GetModel('PAVDETAIL'):SetDescription('Detalhes Postos de Atendimento')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0006')
Local oStruPAZ:= FWFormStruct(2,'PAZ')
Local oStruPAV:= FWFormStruct(2,'PAV')
Local oViewDef:=FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PAZ',oStruPAZ,'PAZMASTER')
oViewDef:AddGrid('VIEW_PAV',oStruPAV,'PAVDETAIL')

oViewDef:CreateHorixontalBox('UP',50)

oViewDef:CreateHorixontalBox('DN',50)

oViewDef:SetOwnerView('VIEW_PAZ','UP')

oViewDef:SetOwnerView('VIEW_PAV','DN')

Return oViewDef