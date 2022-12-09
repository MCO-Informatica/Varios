#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Função: CONVLD				Autor: Flávio Novaes		Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB).       |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar os seguintes      |
//|            gatilhos:                                                     |
//|            Campo: E2_XLINDIG, Conta Domínio: E2_CODBAR, Tipo: Primário,  |
//|            Regra: M->E2_XLINDIG, Posiciona: Não.                         |
//|            Campo: E2_CODBAR, Conta Domínio: E2_CODBAR, Tipo: Primário,   |
//|            Regra: U_CONVLD, Posiciona: Não.                              |
//|                                                                          |
//|            Utilize também a Validação do Usuário para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLD()
SETPRVT("_cStr")

_cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
	// Se o Campo está em Branco não Converte nada.
	_cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	_cStr := IF(LEN(_cStr)<44,_cStr+REPL("0",47-LEN(_cStr)),_cStr)
ENDIF

DO CASE
CASE LEN(_cStr) == 47
	_cStr := SUBSTR(_cStr,1,4)+SUBSTR(_cStr,33,15)+SUBSTR(_cStr,5,5)+SUBSTR(_cStr,11,10)+SUBSTR(_cStr,22,10)
CASE LEN(_cStr) == 48
   _cStr := SUBSTR(_cStr,1,11)+SUBSTR(_cStr,13,11)+SUBSTR(_cStr,25,11)+SUBSTR(_cStr,37,11)
OTHERWISE
	_cStr := _cStr+SPACE(48-LEN(_cStr))
ENDCASE

RETURN(_cStr)