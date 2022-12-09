#Include "Protheus.ch"
#INCLUDE "FWBROWSE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCDES01  �Autor  �  Junior Carvalho   � Data �  22/08/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para cadastro da Taxa da moeda IMCD  Mensal   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function IMCDES01()

Local cFiltro			:= ""
Local cUserAcesso 		:= GetMv("MV_XUSRCUS")
Private cCadastro  		:= "Taxa Mensal Dolar/Euro "
Private cAlias  		:= "SZM"
Private aRotina    		:= MenuDef()

If !__CUSERID $ cUserAcesso
	ALERT("Usu�rio sem acesso a Rotina")
	Return()
Endif

dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(1))
(cAlias)->(dbGotop())

dbSelectArea(cAlias)
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( cAlias )
oBrowse:SetDescription( cCadastro )
oBrowse:SetFilterDefault( cFiltro )
oBrowse:Activate()


Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �  Junior Carvalho   � Data �  22/08/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para cadastro da Taxa da moeda IMCD Global Mensal   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/


Static Function MenuDef()
Local aRotina := {}

aAdd( aRotina ,{"Pesquisar"		, "AxPesqui"		,0,1 })
aAdd( aRotina ,{"Visualizar"	, "AXVISUAL"		,0,2 })
aAdd( aRotina ,{"Incluir"		, "AXINCLUI"		,0,3 })
aAdd( aRotina ,{"Alterar"		, "AXALTERA"		,0,4 })

Return(aRotina)
