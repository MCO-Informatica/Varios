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

// Luiz M Suguiura (24/10/2019) - Par�metro para indicar o Gestor para libera��o do t�tulo
Local cLiber := GetNewPar("MV_XLIBRJ", "000001") 
//Luiz M Suguiura (24/10/2019) - Linhas comentadas pois est� em desuso (Solicitado por Wellington)
//Local cNatAdt	:= Space(10)
//If SE2->E2_PREFIXO = GETNEWPAR("MV_CNPREAD","AGT") .And. SE2->E2_TIPO = GETNEWPAR("MV_CNADITC","PA ") .And. SE2->E2_ORIGEM="CNTA100"
//	
//	nOpca := 0
//	
//	DEFINE MSDIALOG oDlg TITLE "Adiantamento - Gest�o de Contratos" FROM 000,000 TO 090,350 PIXEL
//	@ 010,015 Say "Natureza de Adiantamento:" OF oDlg PIXEL
//	@ 010,080 MSGET cNatAdt Picture "@!" F3 "SED" Valid !EMPTY(cNatAdt).And.FinVldNat( .F.,cNatAdt, 2 ) OF oDlg Pixel
//	DEFINE SBUTTON FROM 033,150 TYPE 1 ENABLE OF oDlg ACTION ( nOpca := 1, oDlg:End() )
//	ACTIVATE MSDIALOG oDlg CENTERED
//	
//	If nOpca == 1
//		DbSelectArea("SE2")
//		RecLock("SE2", .F.)
//		SE2->E2_NATUREZ := cNatAdt
//		SE2->(MsUnLock())
//	Else
//		U_FA050GRV()
//	EndIf
//	
//EndIf

// Luiz M. Suguiura - 24/10/2019
// Atualiza��o dos campos referentes a Recupera��o Judicial
// Se posterior a RJ (16/10/2019) grava o t�tulo Liberado
DbSelectArea("SE2")

RecLock("SE2", .F.)
if  SE2->E2_EMISSAO > CtoD("16/10/2019") 
		If !( Alltrim(SE2->E2_NATUREZ) $ GetMV("MV_XBLQNAT"))//Bloqueia o titulo conforma natureza contida no parametro //couto 20/01/21
			SE2->E2_APROVA  := ""
			SE2->E2_DATALIB := dDataBase
			SE2->E2_STATLIB := "03"
			SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
			SE2->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse c�digo de liberador
			SE2->E2_XRJ     := "N"
	    endif
else
	SE2->E2_APROVA  := ""
	SE2->E2_DATALIB := CtoD("  /  /    ")
	SE2->E2_STATLIB := ""
	SE2->E2_USUALIB := ""
	SE2->E2_CODAPRO := 	SE2->E2_CODAPRO := cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para libera��o
	SE2->E2_XRJ     := "S"
endif
SE2->(MsUnLock())   

   
RestArea(aAreaSE2)

Return
