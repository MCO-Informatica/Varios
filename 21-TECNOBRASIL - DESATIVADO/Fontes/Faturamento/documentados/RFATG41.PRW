//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_COMPEC ? _cCOMPEC, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cCOMPEC ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cCOMPEC
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cCOMPEC
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cCOMPEC VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_COMPEC CONTRA A1_COMPEC 


User Function RFATG41()

local _cCOMPEC := Alltrim(M->A1_COMPEC)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cCOMPEC )>100
    Alert("O texto digitado para o campo - COMPLEMENTO DE ENDERE?O DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
    _cCOMPEC := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cCOMPEC ) <> 0
        Alert("O campo - COMPLEMENTO DE ENDERE?O DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cCOMPEC:= ""
    EndIf
Next


Return(_cCOMPEC)
