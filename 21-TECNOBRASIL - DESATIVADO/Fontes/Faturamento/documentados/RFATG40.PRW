//ATRIBUI O CONTE?DO EM MEM?RIA DE M->1_ENDCOB ? _cENDCOB, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cENDCOB ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cENDCOB
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cENDCOB
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cENDCOB VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO 1_ENDCOB CONTRA 1_ENDCOB 

User Function RFATG40()

local _cENDCOB := Alltrim(M->A1_ENDCOB)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cENDCOB )>100
    Alert("O texto digitado para o campo - ENDERE?O DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
    _cENDCOB := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cENDCOB ) <> 0
        Alert("O campo - ENDERE?O DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cENDCOB:= ""
    EndIf
Next


Return(_cENDCOB)
