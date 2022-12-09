//ATRIBUI O CONTEÚDO EM MEMÓRIA DE A1_NOME À _cNome , E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cNome É > 80 , SE SIM, EXECUTA ALERT() RETORNA "" PARA _cNome
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cNome
//SE SIM, EXECUTA ALERT, SE NÃO, RETORNA _cNome VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_NOME, CONTRA A1_NOME 

User Function RFATG24()

local _cNome       := Alltrim(M->A1_NOME)
Local _cCaract   := "!@#$%¨*()_+/?<>|-,.^´{}[]&"

If Len(_cNome )>80
    Alert("O texto digitado para o campo - NOME - é inválido.Por favor, digite novamente no formato correto")
    _cNome := ""
EndIf

For nI := 1 to Len(_cCaract) 
	
    _cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cNome ) <> 0
        Alert("O campo -NOME- admite apenas caracateres alfabéticos sem acento. Por favor, digite novamente no formato correto")
        _cNome:= ""
    EndIf
Next


Return(_cNome)
