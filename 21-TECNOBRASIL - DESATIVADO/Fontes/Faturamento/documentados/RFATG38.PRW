//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_COMPENT ? _cCOMPENT, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cCOMPENT  ? > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cCOMPENT 
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cCOMPENT 
//SE SIM, EXECUTA ALERT(), SE N?O, RETORNA _cCOMPENT  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_COMPENT CONTRA A1_COMPENT 


User Function RFATG38()

local _cCOMPENT := Alltrim(M->A1_COMPENT)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cCOMPENT )>100
    Alert("O texto digitado para o campo - COMPLMENTO DO ENDERE?O DE ENTREGA - ? inv?lido.Por favor, digite novamente no formato correto")
    _cCOMPENT := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cCOMPENT ) <> 0
        Alert("O campo - COMPLMENTO DO ENDERE?O DE ENTREGA - admite apenas caracateres alfab?ticos. Por favor, digite novamente no formato correto")
       _cCOMPENT:= ""
    EndIf
Next


Return(_cCOMPENT)
