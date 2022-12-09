//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_PFISICA À _cRNE, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cRNEct É > QUE 20, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cRNE
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cRNE
//SE SIM, EXECUTA ALERT90, SE NÃO, RETORNA _cRNE VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_A1_RNE, CONTRA A1_RNE 

User Function RFATG23()

local _cRNE       := Alltrim(M->A1_PFISICA)
Local _cCaract   := "!@#$%¨*()-_+/?<>|,."
//local _cPesq    := ""

If Len(_cRNE )>20
    Alert("O número digitado para o documento é inválido. Por favor, digite novamente no formato correto")
    _cRNE := ""
EndIf

For nI := 1 to Len(_cCaract) 
	
    _cPesq:= substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cRNE ) <> 0
        Alert("Este campo admite apenas caracateres numéricos. Por favor, digite novamente no formato correto")
        _cRNE:= ""
    EndIf
Next


Return(_cRNE)
