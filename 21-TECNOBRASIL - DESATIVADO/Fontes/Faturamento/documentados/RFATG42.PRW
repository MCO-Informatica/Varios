//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_BAIRROC ? _cBAIRROC, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cBAIRROC ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cBAIRROC
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cBAIRROC
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cBAIRROC VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_BAIRROC CONTRA A1_BAIRROC 


User Function RFATG42()

local _cBAIRROC := Alltrim(M->A1_BAIRROC)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cBAIRROC )>100
    Alert("O texto digitado para o campo - BAIRRO DE COBRAN?A - ? inv?lido.Por favor, digite novamente no formato correto")
    _cBAIRROC := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cBAIRROC ) <> 0
        Alert("O campo - BAIRRO DE COBRAN?A  - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cBAIRROC:= ""
    EndIf
Next


Return(_cBAIRROC)
