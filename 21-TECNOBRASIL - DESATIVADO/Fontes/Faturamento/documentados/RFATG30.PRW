//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_TEL ? _cTELEFONE, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cTELEFONE ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cTELEFONE
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cTELEFONE
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cTELEFONE VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_TEL, CONTRA A1_TEL 




User Function RFATG30()

local _cTELEFONE := Alltrim(M->A1_TEL)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cTELEFONE )>100
    Alert("O texto digitado para o campo - TELEFONE - ? inv?lido.Por favor, digite novamente no formato correto")
    _cTELEFONE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cTELEFONE ) <> 0
        Alert("O campo - TELEFONE - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cTELEFONE:= ""
    EndIf
Next


Return(_cTELEFONE)
