//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_TEL2 À _cTELEFONE2, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cTELEFONE2 É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cTELEFONE2
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cTELEFONE2
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cTELEFONE2 VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_TEL2, CONTRA A1_TEL2 

User Function RFATG31()

local _cTELEFONE2 := Alltrim(M->A1_TEL2)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cTELEFONE2 )>100
    Alert("O texto digitado para o campo - TELEFONE 2 - é inválido.Por favor, digite novamente no formato correto")
    _cTELEFONE2 := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cTELEFONE2 ) <> 0
        Alert("O campo - TELEFONE 2 - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cTELEFONE2:= ""
    EndIf
Next


Return(_cTELEFONE2)
