//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_TEL À _cTELEFONE, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cTELEFONE É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cTELEFONE
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cTELEFONE
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cTELEFONE VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_TEL, CONTRA A1_TEL 




User Function RFATG30()

local _cTELEFONE := Alltrim(M->A1_TEL)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cTELEFONE )>100
    Alert("O texto digitado para o campo - TELEFONE - é inválido.Por favor, digite novamente no formato correto")
    _cTELEFONE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cTELEFONE ) <> 0
        Alert("O campo - TELEFONE - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cTELEFONE:= ""
    EndIf
Next


Return(_cTELEFONE)
