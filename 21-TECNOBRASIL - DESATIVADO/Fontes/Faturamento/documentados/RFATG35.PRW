//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_CEL1 À _cCEL1 , E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cCEL1  É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cCEL1 
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cCEL1 
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cCEL1  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_CEL1 CONTRA A1_CEL1 

User Function RFATG35()

local _cCEL1 := Alltrim(M->A1_CEL1)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cCEL1 )>100
    Alert("O texto digitado para o campo - NÚMERO CELULAR 1- é inválido.Por favor, digite novamente no formato correto")
    _cCEL1 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cCEL1 ) <> 0
        Alert("O campo - NÚMERO CELULAR 1 - admite apenas caracateres numéricos. Por favor, digite novamente no formato correto")
       _cCEL1:= ""
    EndIf
Next


Return(_cCEL1)
