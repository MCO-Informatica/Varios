//ATRIBUI O CONTE?DO EM MEM?RIA DE M->A1_NREDUZ ? _cNomeReduz, E ATRIBUI STRING DE CARACTERES ESPECIAIS ? _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cNomeReduzct ? > QUE 20, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cNomeReduz
//LA?O FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO EST? CONTIDO EM _cNomeReduz
//SE SIM, EXECUTA ALERT90, SE N?O, RETORNA _cNomeReduz VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOM?NIO A1_NREDUZ, A1_NREDUZ 


User Function RFATG25()

local _cNomeReduz := Alltrim(M->A1_NREDUZ)
Local _cCaract    := "!@#$%?*()_+/?<>|-,.^?{}[]&"


If Len(_cNomeReduz )>100
    Alert("O texto digitado para o campo - NOME FANTASIA - ? inv?lido.Por favor, digite novamente no formato correto")
    _cNomeReduz := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cNomeReduz ) <> 0
        Alert("O campo - NOME FANTASIA - admite apenas caracateres alfab?ticos sem acento. Por favor, digite novamente no formato correto")
       _cNomeReduz:= ""
    EndIf
Next


Return(_cNomeReduz)
