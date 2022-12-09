#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+---------------+
| Programa:  | VFING01 | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+------------+---------+--------+---------------+-------+---------------+
| Descrição: | Validação para o Código de Barras do SISPAG              |
+------------+----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function VFING01(_cCodBar,_cTipoProc)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cRetorno := ""
Local _nTam     := Len(Alltrim(_cCodBar))

// +----------------------------------------------------------------------+
// | Tratamento de Boletos com a Linha Digitável incompleta (sem o Valor) |
// +----------------------------------------------------------------------+

If _nTam < 44
	_cCodBar := Alltrim(_cCodBar) + Replicate("0",47 - _nTam)
EndIf

Do Case
	Case _cTipoProc == 1			// Banco
		_cRetorno := _fBanco(_cCodBar)
	Case _cTipoProc == 2			// Moeda
		_cRetorno := _fMoeda(_cCodBar)
	Case _cTipoProc == 3			// DV
		_cRetorno := _fDV(_cCodBar)
	Case _cTipoProc == 4			// Fator + Valor
		_cRetorno := _fValor(_cCodBar)
	Case _cTipoProc == 5			// Livre
		_cRetorno := _fLivre(_cCodBar)
	OtherWise
EndCase

Return(_cRetorno)

/*
+---------+---------+--------+---------------+-------+---------------+
| Função: | _fBanco | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no Código de Barras a Informação do Banco de Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fBanco(_cCodBar)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cBanco := ""
Local _nTam   := Len(Alltrim(_cCodBar))

If _nTam == 44
	_cBanco := SUBS(_cCodBar,1,3)
ElseIf _nTam == 47
	_cBanco := SUBS(_cCodBar,1,3)
EndIf

Return(_cBanco)

/*
+---------+---------+--------+---------------+-------+---------------+
| Função: | _fMoeda | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no Código de Barras a Informação da Moeda de Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fMoeda(_cCodBar)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cMoeda := ""
Local _nTam   := Len(Alltrim(_cCodBar))

If _nTam == 44
	_cMoeda := SUBS(_cCodBar,4,1)
ElseIf _nTam == 47
	_cMoeda := SUBS(_cCodBar,4,1)
EndIf

Return(_cMoeda)

/*
+---------+------+--------+---------------+-------+---------------+
| Função: | _fDV | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+---------+------+--------+---------------+-------+---------------+
| Uso:    | Busca no Código  de Barras a Informação do  Dígito de |
|         | Controle.                                             |
+---------+-------------------------------------------------------+
*/

Static Function _fDV(_cCodBar)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cDV  := ""
Local _nTam := Len(Alltrim(_cCodBar))

If _nTam == 44
	_cDV := SUBS(_cCodBar,5,1)
ElseIf _nTam == 47
	_cDV := SUBS(_cCodBar,33,1)
EndIf

Return(_cDV)

/*
+---------+---------+--------+---------------+-------+---------------+
| Função: | _fValor | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no Código de Barras a Informação do Valor do Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fValor(_cCodBar)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cValor :=""
Local _nTam   := Len(Alltrim(_cCodBar))

If _nTam == 44
	_cValor := Strzero(Val(SUBS(_cCodBar,6,14)),14)
ElseIf _nTam == 47
	_cValor := SUBS(_cCodBar,34,14)
EndIf

Return(_cValor)

/*
+---------+---------+--------+---------------+-------+---------------+
| Função: | _fLivre | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no Código de Barras outras Informações do Pgto.    |
+---------+----------------------------------------------------------+
*/

Static Function _fLivre(_cCodBar)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cLivre :=""
Local _nTam := Len(Alltrim(_cCodBar))

If _nTam == 44
	_cLivre := SUBS(_cCodBar,20,25)
ElseIf _nTam == 47
	_cLivre := SUBS(_cCodBar,5,5) + SUBS(_cCodBar,11,10) + SUBS(_cCodBar,22,10)
EndIf

Return(_cLivre)

/*
+------------+----------+--------+---------------+-------+---------------+
| Programa:  | _NAGECTA | Autor: | Flávio Sardão | Data: | Setembro/2010 |
+------------+----------+--------+---------------+-------+---------------+
| Descrição: | Retorna Código de Agência e Número de Contas p/SISPAG     |
+------------+-----------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                              |
+------------+-----------------------------------------------------------+
*/

User Function _NAGECTA()

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _cAGCTA := ""
Local _cConta := Alltrim(SA2->A2_NUMCON)

If Alltrim(SA2->A2_BANCO) == "341"
	_cAGCTA := "0" + SUBST(SA2->A2_AGENCIA,1,4) + " 0000000" + SUBS(SA2->A2_NUMCON,1,5) + " " + Right(Alltrim(SA2->A2_NUMCON),1)
Else
	_cAGCTA := Strzero(Val(SA2->A2_AGENCIA),5) + " " + Strzero(Val(SUBS(_cConta,1,Len(_cConta) - 1)),12) + " " + Right(_cConta,1)
EndIf

Return (_cAGCTA )

/*
User Function _TCODD()

Local _cod := "34191124812351197025570994400003339300000580041 "
U_CFING001(_cod,"1")
Return

User Function _TCODL()
Local _cod := "34198393300000031161124720549423129002527000 "  
U_CFING001(ALLTRIM(_cod),"1") 
Return*/
