#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Fun��o: CONVLD				Autor: Fl�vio Novaes		Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Descri��o: Fun��o para Convers�o da Representa��o Num�rica do C�digo de  |
//|            Barras - Linha Digit�vel (LD) em C�digo de Barras (CB).       |
//|                                                                          |
//|            Para utiliza��o dessa Fun��o, deve-se criar os seguintes      |
//|            gatilhos:                                                     |
//|            Campo: E2_XLINDIG, Conta Dom�nio: E2_CODBAR, Tipo: Prim�rio,  |
//|            Regra: M->E2_XLINDIG, Posiciona: N�o.                         |
//|            Campo: E2_CODBAR, Conta Dom�nio: E2_CODBAR, Tipo: Prim�rio,   |
//|            Regra: U_CONVLD, Posiciona: N�o.                              |
//|                                                                          |
//|            Utilize tamb�m a Valida��o do Usu�rio para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
USER FUNCTION ConvLD()
SETPRVT("_cStr")

_cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
	// Se o Campo est� em Branco n�o Converte nada.
	_cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
	// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
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