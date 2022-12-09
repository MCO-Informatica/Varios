#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA040 � Autor � Darcio R. Sporl    � Data �  13/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � MVC para o Cadastro  de tipo de Voucher. A fun��o principal���
���          �  exibe a lista de tipos em um FWMBrowse                    ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VNDA040()
Local oBrowse := FWMBrowse():New()

oBrowse:SetAlias("SZH")
oBrowse:SetDescription('Cadastro de Tipo de Voucher')       

oBrowse:Activate()
                  

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para o cadastro de tipos de Voucher        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ModelDef()

Local oStruSZH := FWFormStruct(1,"SZH")    
Local oModel  

oModel:= MPFormModel():New('TipVoucher')
oModel:AddFields('SZHMASTER',/*owner*/,oStruSZH)
oModel:SetDescription('Cadastro de Tipo de Voucher')
oModel:GetModel('SZHMASTER'):SetDescription('Cadastro de Tipo de Voucher')      
oModel:SetPrimaryKey( { "ZH_FILIAL", "ZH_TIPO" } )

Return oModel


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                   � Data �  10/10/11   ���
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
Local oModel := FWLoadModel('VNDA040')
Local oStruSZH := FWFormStruct(2,"SZH")     
Local oView

oView:= FWFormView():New()
oView:SetModel(oModel)
oView:AddField( 'VIEW_SZH', oStruSZH, 'SZHMASTER' )      
oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_SZH', 'TELA' )
Return oView
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   � Autor �                   � Data �  10/10/11   ���
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

ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.VNDA040' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.VNDA040' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.VNDA040' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.VNDA040' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.VNDA040' OPERATION 8 ACCESS 0
ADD OPTION aRotina Title 'Copiar' Action 'VIEWDEF.VNDA040' OPERATION 9 ACCESS 0

Return aRotina 
