//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_CEL1 ? _cCEL1 , E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cCEL1  ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cCEL1 
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cCEL1 
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cCEL1  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_CEL1 CONTRA A1_CEL1 

User Function RFATG35()

local _cCEL1 := Alltrim(M->A1_CEL1)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cCEL1 )>100
    Alert("O texto digitado para o campo - N?MERO CELULAR 1- ? inv?lido.Por favor, digite novamente no formato correto")
    _cCEL1 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cCEL1 ) <> 0
        Alert("O campo - N?MERO CELULAR 1 - admite apenas caracateres num?ricos. Por favor, digite novamente no formato correto")
       _cCEL1:= ""
    EndIf
Next


Return(_cCEL1)
