//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_A1_END À _cEndereco, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cEndereco É > 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cEndereco
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cEndereco
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cEndereco VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_END, CONTRA A1_END 


User Function RFATG27()

local _cEndereco := Alltrim(M->A1_END)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cEndereco )>100
    Alert("O texto digitado para o campo - ENDEREÇO - é inválido.Por favor, digite novamente no formato correto")
    _cEndereco := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cEndereco ) <> 0
        Alert("O campo - ENDEREÇO - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cEndereco:= ""
    EndIf
Next


Return(_cEndereco)
