//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_BAIRRO ? _cBairro, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cBairro   > 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cBairro
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cBairro
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cBairro VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_BAIRRO, CONTRA A1_BAIRRO 




User Function RFATG28()

local _cBairro := Alltrim(M->A1_BAIRRO)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cBairro )>100
    Alert("O campo tem limite de 100 caracteres. Por favor digite novamente")
    _cBairro := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cBairro ) <> 0
        Alert("O campo - BAIRRO - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cBairro:= ""
    EndIf
Next


Return(_cBairro)
