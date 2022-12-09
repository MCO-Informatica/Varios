//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_BAIRROC À _cBAIRROC, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cBAIRROC É > QUE 100, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cBAIRROC
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA
// IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cBAIRROC
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cBAIRROC VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_BAIRROC CONTRA A1_BAIRROC 


User Function RFATG42()

local _cBAIRROC := Alltrim(M->A1_BAIRROC)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cBAIRROC )>100
    Alert("O texto digitado para o campo - BAIRRO DE COBRANÇA - é inválido.Por favor, digite novamente no formato correto")
    _cBAIRROC := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cBAIRROC ) <> 0
        Alert("O campo - BAIRRO DE COBRANÇA  - admite apenas caracateres alfabéticos. Por favor, digite novamente no formato correto")
       _cBAIRROC:= ""
    EndIf
Next


Return(_cBAIRROC)
