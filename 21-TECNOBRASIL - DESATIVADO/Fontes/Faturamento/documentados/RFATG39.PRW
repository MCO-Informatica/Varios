//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_BAIRROE ? _cBAIRROE, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cBAIRROE ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cBAIRROE
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cBAIRROE
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cBAIRROE VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_BAIRROE CONTRA A1_BAIRROE 


User Function RFATG39()

local _cBAIRROE := Alltrim(M->A1_BAIRROE)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cBAIRROE )>100
    Alert("O texto digitado para o campo - BAIRRO DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
    _cBAIRROE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cBAIRROE ) <> 0
        Alert("O campo - BAIRRO DE ENTREGA  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cBAIRROE:= ""
    EndIf
Next


Return(_cBAIRROE)
