//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_DDD2 À _cDDD2 , E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cDDD2  É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cDDD2 
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cDDD2 
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cDDD2  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_DDD2 CONTRA A1_DDD2 

User Function RFATG44()

local _cDDD2 := Alltrim(M->A1_DDD2)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cDDD2 )>100
    Alert("O texto digitado para o campo - DDD2 - é inválido.Por favor, digite novamente no formato correto")
    _cDDD2 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cDDD2 ) <> 0
        Alert("O campo - DDD2  - admite apenas caracateres numéricos. Por favor, digite novamente no formato correto")
       _cDDD2:= ""
    EndIf
Next


Return(_cDDD2)
