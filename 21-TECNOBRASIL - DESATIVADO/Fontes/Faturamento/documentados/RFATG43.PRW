//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_MUNE À _cMUNE , E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cMUNE  É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cMUNE 
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cMUNE 
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cMUNE  VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_MUNE CONTRA A1_MUNE 


User Function RFATG43()

local _cMUNE := Alltrim(M->A1_MUNE)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cMUNE )>100
    Alert("O texto digitado para o campo - MUNICÍPIO DE COBRANÇA - é inválido.Por favor, digite novamente no formato correto")
    _cMUNE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cMUNE ) <> 0
        Alert("O campo - MUNICÍPIO DE COBRANÇA  - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cMUNE:= ""
    EndIf
Next


Return(_cMUNE)
