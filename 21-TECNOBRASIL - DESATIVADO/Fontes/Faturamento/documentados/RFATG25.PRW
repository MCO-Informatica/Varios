//ATRIBUI O CONTEÚDO EM MEMÓRIA DE M->A1_NREDUZ À _cNomeReduz, E ATRIBUI STRING DE CARACTERES ESPECIAIS À _cCaract
// VALIDA SE TAMAHO DA STRING CONTIDA EM _cNomeReduzct É > QUE 20, SE SIM, EXECUTA ALERT() RETORNA "" PARA _cNomeReduz
//LAÇO FOR PRA SELECIONAR CADA UM DOS CARACTERES ESPECIAIS CONTIDO EM _cCaract, EM SEGUIDA, IF VERIFICA SE O CARACTER ESPECIAL SELECIONADO ESTÁ CONTIDO EM _cNomeReduz
//SE SIM, EXECUTA ALERT90, SE NÃO, RETORNA _cNomeReduz VALIDADO, SEM CARACTER ESPECIAL CONTIDO EM _cCaract 
//DOMÍNIO A1_NREDUZ, A1_NREDUZ 


User Function RFATG25()

local _cNomeReduz := Alltrim(M->A1_NREDUZ)
Local _cCaract    := "!@#$%¨*()_+/?<>|-,.^´{}[]&"


If Len(_cNomeReduz )>100
    Alert("O texto digitado para o campo - NOME FANTASIA - é inválido.Por favor, digite novamente no formato correto")
    _cNomeReduz := ""
EndIf

For nI := 1 to Len(_cCaract) 
	_cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cNomeReduz ) <> 0
        Alert("O campo - NOME FANTASIA - admite apenas caracateres alfabéticos sem acento. Por favor, digite novamente no formato correto")
       _cNomeReduz:= ""
    EndIf
Next


Return(_cNomeReduz)
