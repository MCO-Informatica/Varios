//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_DDDC1 ? _cDDDC1, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cDDDC1 ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cDDDC1
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cDDDC1
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cDDDC1 VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_DDDC1 CONTRA A1_DDDC1 


User Function RFATG32()

local _cDDDC1 := Alltrim(M->A1_DDDC1)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cDDDC1 )>100
    Alert("O texto digitado para o campo - DDD CELULAR 1 - ? inv?lido.Por favor, digite novamente no formato correto")
    _cDDDC1 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cDDDC1 ) <> 0
        Alert("O campo - DDD CELULAR 1 - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cDDDC1:= ""
    EndIf
Next


Return(_cDDDC1)
