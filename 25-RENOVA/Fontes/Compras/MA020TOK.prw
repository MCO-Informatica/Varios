/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
ºPrograma  ³MA020TOK    ºAutor  ³Rafael Alencarº       Data ³ 04/06/2013º±±++
ÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ºDesc.     ³Validação CNPJ                                               ±±++
ÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
±±ºUso       ³Renova                                                    º±±++
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±++++
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ÍÍÍÍÍÍ*/

#Include 'Protheus.ch'
	
User Function MA020TOK()

Local _cRet := .T.
Local aArea := GetArea()
/*	Trecho substitutido, pois qdo for EX o sistema ira carregar automatico
os principais campos de Fornecedor Extrangeiro:
cEst			:="EX"
cBairro  		:="Estrangeiro"
cCep	 		:="00000000"
cMun	 		:="99999" 
IF M->A2_EST $ "EX" .AND. EMPTY(M->A2_MUN)
_cRet := .T.

ENDIF
*/
IF M->A2_TIPO $ "J,F" .AND. EMPTY(M->A2_CGC)
	Help(,, "Help", "MA020TDOK", "O campo CNPJ\CPF. deve ser prenchido", 1, 0)
	//MsgAlert("O Campo CNPJ deve ser preenchido pois o tipo do Fornecedor é físíco ou jurídico")
	_cRet := .F.
EndIf
If M->A2_XIFBCO = "S" .AND. EMPTY(M->A2_BANCO)
	Help(,, "Help", "MA020TDOK", "O campo Banco. deve ser prenchido", 1, 0)	
	_cRet := .F.
Endif

RestArea( aArea )
Return (_cRet)
