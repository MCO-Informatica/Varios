#include "rwmake.ch"

User Function MT110TOK()
 _lret := .t.
 If Empty(cCodCompr)
	Aviso("Atencao !","Codigo do Comprador esta vazio",{"ok"}, 2 )
    _lRet := .f.
    
 Endif            

Return(_lRet)