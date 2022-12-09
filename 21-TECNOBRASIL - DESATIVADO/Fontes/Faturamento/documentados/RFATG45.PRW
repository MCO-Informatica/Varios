//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_DDD À _cDDD, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cDDD É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cDDD
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cDDD
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cDDD VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_DDD CONTRA A1_DDD 


User Function RFATG45()

local _cDDD := Alltrim(M->A1_DDD)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cDDD )>100
    Alert("O texto digitado para o campo - DDD - é inválido.Por favor, digite novamente no formato correto")
    _cDDD := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cDDD ) <> 0
        Alert("O campo - DDD  - admite apenas caracateres numéricos. Por favor, digite novamente no formato correto")
       _cDDD:= ""
    EndIf
Next


Return(_cDDD)
