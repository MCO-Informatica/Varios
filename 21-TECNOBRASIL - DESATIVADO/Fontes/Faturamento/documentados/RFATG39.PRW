//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_BAIRROE À _cBAIRROE, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cBAIRROE É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cBAIRROE
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cBAIRROE
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cBAIRROE VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_BAIRROE CONTRA A1_BAIRROE 


User Function RFATG39()

local _cBAIRROE := Alltrim(M->A1_BAIRROE)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cBAIRROE )>100
    Alert("O texto digitado para o campo - BAIRRO DE ENTREGA - é inválido.Por favor, digite novamente no formato correto")
    _cBAIRROE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cBAIRROE ) <> 0
        Alert("O campo - BAIRRO DE ENTREGA  - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cBAIRROE:= ""
    EndIf
Next


Return(_cBAIRROE)
