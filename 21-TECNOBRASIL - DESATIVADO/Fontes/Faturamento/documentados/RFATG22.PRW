//M->A1_REGERAL ? DOM?NIO E CONTRA-DOM?NIO
// VERIFICA SE A STRING EM MEM?RIA DO CAMPO A1_REGERAL CONT?M QUANTIDADE DE D?GITOS <> DE 9, SE SIM, EXECUTA ALERT E RETORNA BRANCO
// FOR / IF VERIFICA SE A STRING CONT?M ALGUNS DOS CARACTERES ATRIBU?DOS ? _cCaract, SE SIM, EXECUTA ALERT E RETORNA BRANCO

User Function RFATG22()

local _cRG       := Alltrim(M->A1_REGERAL)
Local _cCaract   := "!@#$%?*()_+/?<>|,."

If Len(_cRG)<>9
    Alert("O RG informado ? inv?lido")
    _cRG := ""
EndIf

For nI := 1 to Len(_cCaract) 
	
    _cPesq :=substr(_cCaract,nI,1)
	
    If AT(_cPesq, _cRG ) <> 0
        Alert("Foi digitado algum caracter n?o permitido")
        _cRG := ""
    EndIf
Next


Return(_cRG)
