USER FUNCTION TESTE()

Local _cRetorno:= ""


IF SA1->A1_EST$"SP"
    _cRetorno := "SAO PAULO"
ELSE
    _cRetorno := "DEMAIS ESTADOS"
ENDIF


RETURN(_cRetorno)
