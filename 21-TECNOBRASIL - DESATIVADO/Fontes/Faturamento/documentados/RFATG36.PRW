//ATRIBUI O CONTE?DO EM MEM?RIA DE M->_cCEL2  ? _cCEL2 , E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cCEL2  ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cCEL2 
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cCEL2 
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cCEL2  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO _cCEL2  CONTRA _cCEL2  

User Function RFATG36()

local _cCEL2 := Alltrim(M->_cCEL2 )
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cCEL2 )>100
    Alert("O texto digitado para o campo - DDD CELULAR 2- ? inv?lido.Por favor, digite novamente no formato correto")
    _cCEL2 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cCEL2 ) <> 0
        Alert("O campo - DDD CELULAR 2 - admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
       _cCEL2:= ""
    EndIf
Next


Return(_cCEL2)
