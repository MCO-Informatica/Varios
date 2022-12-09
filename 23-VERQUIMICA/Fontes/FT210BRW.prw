#include "rwmake.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT210BRW  �Autor  �Felipe Pieroni      � Data �  08/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro na tela de Liberacao de Regra para mostrar somente  ���
���          � somente para os usuarios autorizados                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT210BRW(lFilDnv)  // Nao esta funcionando
Local _cUsuario	 := Upper(Alltrim(__cUserID))
Local _cFiltro 	 := ""
Local _cQuemLib1 := ""
Local _cQuemLib2 := ""
Local aIndSC5    := {}
Local lPerg := Pergunte("VQLIBPEDVE")

Default lFilDnv := .F.

	//���������������������������������������������������������������������Ŀ
	//� Criando parametro do programa										�
	//�����������������������������������������������������������������������
		DbSelectArea("SX6")
		DbSetorder(1)
		DbgoTop()
		If !Dbseek(xFilial("SC5")+"MV_VQPVL1")
			Reclock("SX6",.T.)
			SX6->X6_FIL:=xFilial("SC5")
			SX6->X6_VAR:="MV_VQPVL1"
			SX6->X6_TIPO:="C"
			SX6->X6_DESCRIC :="Usuarios que Irao liberar Regra Nivel 1"
			SX6->X6_CONTEUD :="000000/"
			MsUnlock()
		Endif
		
		_cQuemLib1 := Alltrim(Upper(GETMV("MV_VQPVL1")))
		
		If _cUsuario $ _cQuemLib1 
			_cFiltro 	:= " SC5->C5_BLQ == '1' "
			If lPerg
			_cFiltro += " .And. (DTOS(SC5->C5_ENTREG) >= '"+DTOS(MV_PAR01)+"' .And. DTOS(SC5->C5_ENTREG) <= '"+DTOS(MV_PAR02)+"')"
			EndIf
		Else
			_cFiltro += " SC5->C5_BLQ == '2'"
		EndIf
				
		DbSelectArea("SC5")	
		DbSetOrder(10)	
		SET FILTER TO
		SET FILTER TO &_cFiltro

		SetKey(VK_F12, { || U_VQFFT210() } )

Return()