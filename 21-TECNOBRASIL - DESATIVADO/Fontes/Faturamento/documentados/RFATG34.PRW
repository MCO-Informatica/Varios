//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_DDDC2 À _cDDDC2, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cDDDC2 É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cDDDC2
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cDDDC2
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cDDDC2 VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_DDDC2 CONTRA A1_DDDC2 


User Function RFATG34()

local _cDDDC2:= Alltrim(M->A1_DDDC2)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cDDDC2)>100
    Alert("O texto digitado para o campo - DDD CELULAR 2 - é inválido.Por favor, digite novamente no formato correto")
    _cDDDC2:= ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cDDDC2) <> 0
        Alert("O campo - DDD CELULAR 2 - admite apenas caracateres numéricos. Por favor, digite novamente no formato correto")
       _cDDDC2:= ""
    EndIf
Next


Return(_cDDDC2)
