//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_MUNE ? _cMUNE , E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cMUNE  ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cMUNE 
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cMUNE 
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cMUNE  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_MUNE CONTRA A1_MUNE 


User Function RFATG43()

local _cMUNE := Alltrim(M->A1_MUNE)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cMUNE )>100
    Alert("O texto digitado para o campo - MUNIC?PIO DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
    _cMUNE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cMUNE ) <> 0
        Alert("O campo - MUNIC?PIO DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cMUNE:= ""
    EndIf
Next


Return(_cMUNE)
