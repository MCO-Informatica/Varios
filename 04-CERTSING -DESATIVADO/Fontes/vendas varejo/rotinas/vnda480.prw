#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef  � Autor �                    � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para Consulta de Movimento de Voucher      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������     
/*/
User Function VNDA480(cNumPed, cNumVou, nQtdVou, cItem, aRVou)
Local oBrowse := FWMBrowse():New()  

oBrowse:SetAlias("SZF")
oBrowse:SetDescription('Movto Voucher')       

oBrowse:Activate()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Interface para consulta de movimento Voucher               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ViewDef()

Local oModel := FWLoadModel('VNDA480')   
Local oStruCab := FWFormStruct(2,"SZF")     
Local oStruItem := FWFormStruct(2,"SZG")  
Local oView 

oStruCab:RemoveField("ZF_QTDFLUX")  

oView:= FWFormView():New()                           
oView:SetModel(oModel)
oView:SetCloseOnOk({|| .T. })                               

oView:AddField( 'SZFMASTER', oStruCab  )        
oView:AddGrid('SZGDETAIL', oStruItem  )
   
oView:CreateHorizontalBox( 'FORMFIELD', 50 )
oView:SetOwnerView( 'SZFMASTER', 'FORMFIELD' )

oView:CreateHorizontalBox( 'GRID', 50 )
oView:SetOwnerView( 'SZGDETAIL', 'GRID' )

oView:SetCursor(oModel)


Return oView


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para Consulta de Movimento de Voucher      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ModelDef()

Local oStruCab := FWFormStruct(1,"SZF")    
Local oStruItem := FWFormStruct(1,"SZG")    

Local oModel  

oStruCab:RemoveField("ZF_QTDFLUX") 
oModel:= MPFormModel():New('MOVVOU')

oModel:AddFields('SZFMASTER',/*owner*/,oStruCab)    
oModel:AddGrid('SZGDETAIL','SZFMASTER',oStruItem) 
oModel:GetModel("SZGDETAIL"):SetUseOldGrid()
oModel:SetPrimaryKey( { "ZG_FILIAL", "ZG_CODFLU", "ZG_NUMVOUC" } )

oModel:SetRelation( 'SZGDETAIL', { { 'ZG_FILIAL', 'xFilial( "SZG" )' },{ 'ZG_CODFLU', 'ZF_CODFLU' }, { 'ZG_NUMVOUC', 'ZF_COD' } },SZG->( IndexKey() ) )

Return oModel
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   � Autor �                    � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Menu para consulta de movimento Voucher                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
Static Function MenuDef()  

Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.VNDA480' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.VNDA480' OPERATION 8 ACCESS 0

Return aRotina                