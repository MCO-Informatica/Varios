//***********IMPORTANTE : ESTE GATILHO NÃO ESTÁ MAIS SENDO USADO, UMA VEZ QUE O CLIENTE DESISTIU DESTE CAMPO, DEVIDO PREENCHIMNETO feito por MASHUP
//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_COMPLEM À _cComplem, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cComplemct É > QUE 20, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cComplem
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cComplem
//SE SIM, EXECUTA ALERT(), SE NÃO, RETORNA _cComplem VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_COMPLEM, A1_COMPLEM 

User Function RFATG26()

local _cComplem := Alltrim(M->A1_COMPLEM)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cComplem )>100
    Alert("O texto digitado para o campo - COMPLEMENTO DE ENDEREÇO  - é inválido.Por favor, digite novamente no formato correto")
    _cComplem := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cComplem ) <> 0
        Alert("O campo - COMPLEMENTO DE ENDEREÇO - admite apenas caracateres alfabéticos sem acento. Por favor, digite novamente no formato correto")
       _cComplem:= ""
    EndIf
Next


Return(_cComplem)
