//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_DDDC1 À _cDDDC1, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cDDDC1 É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cDDDC1
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cDDDC1
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cDDDC1 VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_DDDC1 CONTRA A1_DDDC1 


User Function RFATG32()

local _cDDDC1 := Alltrim(M->A1_DDDC1)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cDDDC1 )>100
    Alert("O texto digitado para o campo - DDD CELULAR 1 - é inválido.Por favor, digite novamente no formato correto")
    _cDDDC1 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cDDDC1 ) <> 0
        Alert("O campo - DDD CELULAR 1 - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cDDDC1:= ""
    EndIf
Next


Return(_cDDDC1)
