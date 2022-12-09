#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MA020ROT
LOCALIZAÇÃO   :  Function MATA020 - Função principal do programa de
inclusão, alteração e exclusão de fornecedores.
EM QUE PONTO :  No início da Função, antes da execução da Mbrowse dos
Fornecedores, utilizado para adicionar mais opções de menu (no aRotina).
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BUTMT020  ³Autor ³  Junior Carvalho   ³ Data ³ 18/09/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MA020ROT                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BUTMT020()

Local cUsuarios := GetMv("ES_MAILFOR")

if  !(__cUserID $ cUsuarios)
	Alert("Usuário sem premissão para Desbloqueio." )
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
		
		Alert("Fornecedor não está Bloqueado" )
		
	endif
endif

Return()
