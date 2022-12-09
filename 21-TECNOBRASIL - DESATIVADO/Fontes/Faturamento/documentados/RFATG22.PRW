//M->A1_REGERAL É DOMÍNIO E CONTRA-DOMÍNIO
// VERIFICA SE A STRING EM MEMÓRIA DO CAMPO A1_REGERAL CONTÉM QUANTIDADE DE DÍGITOS <> DE 9, SE SIM, EXECUTA ALERT E RETORNA BRANCO
// FOR / IF VERIFICA SE A STRING CONTÉM ALGUNS DOS CARACTERES ATRIBUÍDOS À _cCaract, SE SIM, EXECUTA ALERT E RETORNA BRANCO

User Function RFATG22()

local _cRG       := Alltrim(M->A1_REGERAL)
Local _cCaract   := "!@#$%¨*()_+/?<>|,."

If Len(_cRG)<>9
    Alert("O RG informado é inválido")
    _cRG := ""
EndIf

For nI := 1 to Len(_cCaract) 
	
    _cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cRG ) <> 0
        Alert("Foi digitado algum caracter não permitido")
        _cRG := ""
    EndIf
Next


Return(_cRG)
