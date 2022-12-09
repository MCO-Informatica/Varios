#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+---------------+
| Programa:  | VFING01 | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+------------+---------+--------+---------------+-------+---------------+
| Descri��o: | Valida��o para o C�digo de Barras do SISPAG              |
+------------+----------------------------------------------------------+
| Uso:       | Verion �leo Hidr�ulica Ltda.                             |
+------------+----------------------------------------------------------+
*/

User Function VFING01(_cCodBar,_cTipoProc)

// +-------------------------+
// | Declara��o de Vari�veis |
// +-------------------------+

Local _cRetorno := ""
Local _nTam     := Len(Alltrim(_cCodBar))

// +----------------------------------------------------------------------+
// | Tratamento de Boletos com a Linha Digit�vel incompleta (sem o Valor) |
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
| Fun��o: | _fBanco | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no C�digo de Barras a Informa��o do Banco de Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fBanco(_cCodBar)

// +-------------------------+
// | Declara��o de Vari�veis |
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
| Fun��o: | _fMoeda | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no C�digo de Barras a Informa��o da Moeda de Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fMoeda(_cCodBar)

// +-------------------------+
// | Declara��o de Vari�veis |
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
| Fun��o: | _fDV | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+---------+------+--------+---------------+-------+---------------+
| Uso:    | Busca no C�digo  de Barras a Informa��o do  D�gito de |
|         | Controle.                                             |
+---------+-------------------------------------------------------+
*/

Static Function _fDV(_cCodBar)

// +-------------------------+
// | Declara��o de Vari�veis |
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
| Fun��o: | _fValor | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no C�digo de Barras a Informa��o do Valor do Pgto. |
+---------+----------------------------------------------------------+
*/

Static Function _fValor(_cCodBar)

// +-------------------------+
// | Declara��o de Vari�veis |
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
| Fun��o: | _fLivre | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+---------+---------+--------+---------------+-------+---------------+
| Uso:    | Busca no C�digo de Barras outras Informa��es do Pgto.    |
+---------+----------------------------------------------------------+
*/

Static Function _fLivre(_cCodBar)

// +-------------------------+
// | Declara��o de Vari�veis |
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
| Programa:  | _NAGECTA | Autor: | Fl�vio Sard�o | Data: | Setembro/2010 |
+------------+----------+--------+---------------+-------+---------------+
| Descri��o: | Retorna C�digo de Ag�ncia e N�mero de Contas p/SISPAG     |
+------------+-----------------------------------------------------------+
| Uso:       | Verion �leo Hidr�ulica Ltda.                              |
+------------+-----------------------------------------------------------+
*/

User Function _NAGECTA()

// +-------------------------+
// | Declara��o de Vari�veis |
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