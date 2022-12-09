#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  CPCpoAdc    Autor � Romay Oliveira     � Data �  06/2015     ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na apuracao de pis/cofins para carregar	  ���
���				campo no titulo SE2										  ���
���																		  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Renova		                                      ���
�������������������������������������������������������������������������͹��
���Obs		 �Inova Solution											  ���
�������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������*/ 

User Function CPCpoAdc()

Local cAlias	:= PARAMIXB[1]   

// Luiz M Suguiura (29/09/2020) - Par�metro para indicar o Gestor para libera��o do t�tulo
Local _cLiber := GetNewPar( "MV_FINALAP", "000001")  


(cAlias)->E2_E_APUR	:= mv_par02  // data da apuracao
//(cAlias)->E2_E_APUR	:= mv_par23  // data da apuracao


// Luiz M. Suguiura - 29/09/2020
// Atualiza��o dos campos referentes a Recupera��o Judicial
// Se posterior a RJ (16/10/2019) grava o t�tulo Liberado
if MV_PAR02 > CtoD("16/10/2019")
	(cAlias)->E2_APROVA  := ""
    (cAlias)->E2_DATALIB := dDataBase   // Data da Libera��o = Data da Apura��o
    (cAlias)->E2_STATLIB := "03"
    (cAlias)->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
    (cAlias)->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse c�digo de liberador
    (cAlias)->E2_XRJ     := "N"
else
    (cAlias)->E2_APROVA  := ""
    (cAlias)->E2_DATALIB := CtoD("  /  /    ")
    (cAlias)->E2_STATLIB := ""
    (cAlias)->E2_USUALIB := ""
    (cAlias)->E2_CODAPRO := _cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para libera��o
    (cAlias)->E2_XRJ     := "S"
endif

Return .T.  
