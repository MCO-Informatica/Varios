//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_ENDENT ? _cENDENT, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cENDENT ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cENDENT
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cENDENT
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cENDENT VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_ENDENT CONTRA A1_ENDENT 

User Function RFATG37()

local _cENDENT := Alltrim(M->A1_ENDENT)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cENDENT )>100
    Alert("O texto digitado para o campo - ENDERE?O DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
    _cENDENT := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cENDENT ) <> 0
        Alert("O campo - ENDERE?O DE ENTREGA - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cENDENT:= ""
    EndIf
Next


Return(_cENDENT)
