#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MA020ROT
LOCALIZA��O   :  Function MATA020 - Fun��o principal do programa de
inclus�o, altera��o e exclus�o de fornecedores.
EM QUE PONTO :  No in�cio da Fun��o, antes da execu��o da Mbrowse dos
Fornecedores, utilizado para adicionar mais op��es de menu (no aRotina).
@author  marcio.katsumata
@since   08/08/2019
@version 1.0

/*/
//-------------------------------------------------------------------
USER FUNCTION MA020ROT()
Local aRotUser as array

aRotUser := {}

AAdd( aRotUser, { 'Log Integ. SF'		, 'U_SFLOGSHW()', 0, 4 } )
AAdd( aRotUser, { 'Desbl.Fornecedor'	, 'U_BUTMT020()', 0, 4 } )
AAdd( aRotUser, { 'Log Auditoria'	    , 'U_LOGAUDSHW()', 0, 4 } )
Return (aRotUser)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BUTMT020  �Autor �  Junior Carvalho   � Data � 18/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada                                           ���
�������������������������������������������������������������������������͹��
���Uso       � MA020ROT                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BUTMT020()

Local cUsuarios := GetMv("ES_MAILFOR")

if  !(__cUserID $ cUsuarios)
	Alert("Usu�rio sem premiss�o para Desbloqueio." )
else
	
	cMsg := 'Desbloquear o Fornecedor: '+SA2->A2_COD+' '+SA2->A2_LOJA+ ' - '+SA2->A2_NOME
	
	If !empty(SA2->A2_DATBLO)
		if ApMsgNoYes(cMsg + " Continua?")
			RECLOCK("SA2", .F.)
			
			SA2->A2_DATBLO := CTOD(' ')
			
			mSUNLOCK()
			
			Alert("Fornecedor Desbloqueado" )
			
		Endif
	Else
		
		Alert("Fornecedor n�o est� Bloqueado" )
		
	endif
endif

Return()
