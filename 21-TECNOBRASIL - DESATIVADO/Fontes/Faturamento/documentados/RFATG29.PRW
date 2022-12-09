//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_CONTATO À _cContato, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cContato  É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cContato
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cContato
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cContato VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_CONTATO, CONTRA A1_CONTATO 

User Function RFATG29()

local _cContato := Alltrim(M->A1_CONTATO)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cContato )>100
    Alert("O campo tem limite de 100 caracteres. Por favor digite novamente")
    _cContato := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cContato ) <> 0
        Alert("O campo - Contato - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cContato:= ""
    EndIf
Next


Return(_cContato)
