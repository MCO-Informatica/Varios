#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA050� Autor �Darcio R. Sporl     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � MVC para o Cadastro de usuarios, para controle dos direitos���
���          � de distribuicao de Voucher.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VNDA050()

Local oBrowse := FWMBrowse():New()

oBrowse:SetAlias("SZO")
oBrowse:SetDescription('Cad. Usuario Distri Voucher')  
oBrowse:AddLegend("ZO_ATIVO == 'S'","GREEN","Usu�rio Ativo")
oBrowse:AddLegend("ZO_ATIVO == 'N'","GRAY","Usu�rio Inativo")

oBrowse:Activate()

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef  � Autor �Darcio R. Sporl     � Data �  18/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para o cadastro de usuarios de distribuicao���
���          � de Voucher                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ModelDef()

Local oStruSZO := FWFormStruct(1,"SZO")
Local oModel

oModel:= MPFormModel():New('CadUser')
oModel:AddFields('SZOMASTER',/*owner*/,oStruSZO)
oModel:SetDescription('Cadastro de Usu�rios Distribui��o de Voucher')
oModel:GetModel('SZOMASTER'):SetDescription('Cadastro de Usu�rios Distribui��o de Voucher')
oModel:SetPrimaryKey( { "ZO_FILIAL", "ZO_CODUSER", "ZO_EQATEND" } )

Return oModel

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                    � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Interface para o Cadastro de tipo de Voucher               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ViewDef()
Local oModel	:= FWLoadModel('VNDA050')
Local oStruSZO	:= FWFormStruct(2,"SZO")
Local oView

oView:= FWFormView():New()

oView:SetModel(oModel)
oView:AddField( 'VIEW_SZO', oStruSZO, 'SZOMASTER' )
oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_SZO', 'TELA' )

Return oView

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   � Autor �                    � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Menu para o cadastro de tipo Voucher                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'	Action 'VIEWDEF.VNDA050' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'		Action 'VIEWDEF.VNDA050' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'		Action 'VIEWDEF.VNDA050' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'		Action 'VIEWDEF.VNDA050' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir'		Action 'VIEWDEF.VNDA050' OPERATION 8 ACCESS 0

Return aRotina