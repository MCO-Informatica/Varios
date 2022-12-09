#INCLUDE "PROTHEUS.CH

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050GRV  �Autor  �Microsiga           � Data �  03/27/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para altera��o da Natureza Financeira nos ���
���          � casos de adiantamento incluidos por gest�o de contratos    ���
�������������������������������������������������������������������������͹��
���Uso       � Renova Energia                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050GRV()

Local aAreaSE2	:= SE2->(GetArea())
Local cNatAdt	:= Space(10)

If SE2->E2_PREFIXO = GETNEWPAR("MV_CNPREAD","AGT") .And. SE2->E2_TIPO = GETNEWPAR("MV_CNADITC","PA ") .And. SE2->E2_ORIGEM="CNTA100"
	
	nOpca := 0
	
	DEFINE MSDIALOG oDlg TITLE "Adiantamento - Gest�o de Contratos" FROM 000,000 TO 090,350 PIXEL
	@ 010,015 Say "Natureza de Adiantamento:" OF oDlg PIXEL
	@ 010,080 MSGET cNatAdt Picture "@!" F3 "SED" Valid !EMPTY(cNatAdt).And.FinVldNat( .F.,cNatAdt, 2 ) OF oDlg Pixel
	DEFINE SBUTTON FROM 033,150 TYPE 1 ENABLE OF oDlg ACTION ( nOpca := 1, oDlg:End() )
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 1
		DbSelectArea("SE2")
		RecLock("SE2", .F.)
		SE2->E2_NATUREZ := cNatAdt
		SE2->(MsUnLock())
	Else
		U_FA050GRV()
	EndIf
	
EndIf

RestArea(aAreaSE2)

Return
