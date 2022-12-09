#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MT440LIB  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³25/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Validar liberação de pedido automatico                      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT440LIB()
Local aArea := GetArea()
Local _nRet := 0
Local _aVal := {}
Local _cMot := ""
Local _i    := 0
Local _nReg := SC6->( recno() )

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT440LIB" , __cUserID )

_nRet := paramixb

_aVal := U_A440CKPD( SC6->C6_NUM, .F. )  //.F. para não exibir mensagens
/*
_aVal
Celulas
1,1 - Condição de pagamento
2,1 - Margem de Venda
3,1 - Licença de Cliente
4,1 - Licença de Transportadora
5,1 - Estoque
n,2 - .T. Liberado        - .F. Não Liberado
n,3 - .T. Trava liberação - .F. Permite o usuário forçar a Liberação
*/

SC6->( dbgoto( _nReg ) )

For _i := 1 to len( _aVal )
	if .not. _aVal[ _i, 2 ]
		_cMot += iif( empty( _cMot ), "",", " )+_aVal[_i,1]
		_nRet := 0
	endif
Next _i

if .not. empty( _cMot )
	
	if MV_PAR11 == 1  //1 - Reprovar 2 - Apenas não aprovar
		if SC5->( dbSeek( xFilial("SC5") + SC6->C6_NUM ) )
			if SC5->C5_X_REP != "R"
				U_A440REPR("SC5",SC5->(recno()),1,,.T.)
			endif
		endif
	endif
	
endif

RestArea(aArea)
Return( _nRet )
