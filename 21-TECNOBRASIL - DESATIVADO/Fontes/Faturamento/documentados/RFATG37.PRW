//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_ENDENT À _cENDENT, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cENDENT É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cENDENT
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cENDENT
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cENDENT VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_ENDENT CONTRA A1_ENDENT 

User Function RFATG37()

local _cENDENT := Alltrim(M->A1_ENDENT)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cENDENT )>100
    Alert("O texto digitado para o campo - ENDEREÇO DE ENTREGA - é inválido.Por favor, digite novamente no formato correto")
    _cENDENT := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cENDENT ) <> 0
        Alert("O campo - ENDEREÇO DE ENTREGA - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cENDENT:= ""
    EndIf
Next


Return(_cENDENT)
