#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MT440LIB  � Autor � Eneovaldo Roveri Juni � Data �25/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao �Validar libera��o de pedido automatico                      ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT440LIB()
Local aArea := GetArea()
Local _nRet := 0
Local _aVal := {}
Local _cMot := ""
Local _i    := 0
Local _nReg := SC6->( recno() )

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT440LIB" , __cUserID )

_nRet := paramixb

_aVal := U_A440CKPD( SC6->C6_NUM, .F. )  //.F. para n�o exibir mensagens
/*
_aVal
Celulas
1,1 - Condi��o de pagamento
2,1 - Margem de Venda
3,1 - Licen�a de Cliente
4,1 - Licen�a de Transportadora
5,1 - Estoque
n,2 - .T. Liberado        - .F. N�o Liberado
n,3 - .T. Trava libera��o - .F. Permite o usu�rio for�ar a Libera��o
*/

SC6->( dbgoto( _nReg ) )

For _i := 1 to len( _aVal )
	if .not. _aVal[ _i, 2 ]
		_cMot += iif( empty( _cMot ), "",", " )+_aVal[_i,1]
		_nRet := 0
	endif
Next _i

if .not. empty( _cMot )
	
	if MV_PAR11 == 1  //1 - Reprovar 2 - Apenas n�o aprovar
		if SC5->( dbSeek( xFilial("SC5") + SC6->C6_NUM ) )
			if SC5->C5_X_REP != "R"
				U_A440REPR("SC5",SC5->(recno()),1,,.T.)
			endif
		endif
	endif
	
endif

RestArea(aArea)
Return( _nRet )
