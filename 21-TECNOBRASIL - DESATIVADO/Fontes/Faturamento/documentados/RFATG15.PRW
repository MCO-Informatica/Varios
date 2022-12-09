//CONVERTE STRING CONTIDA EM MEMÓRIA DO CAMPO A1_EMAIL2E MINÚSCULAS E ATRIBUI À _cEmail;
//FUNÇÃO ISEMAIL() VERIFICA SE A STRING EM MEMÓRIA ESTÁ NO FORMATO DE EMAIL, SE NÃO, EXECUTA ALERT(), SE SIM
//RETORNA _cMail com a string no formato válido para o gatilho. A1_EMAIL2 É DOMÍNIO E CONTRA-DOMÍNIO.
User Function RFATG15() 

local _cEmail:= Lower(M->A1_EMAIL2)

If !IsEmail(Alltrim(_cEmail))
	Alert("O Email digitado é inválido. Por favor digite novamente no formato correto")             
	_cEmail:=  ""
EndIf

Return(_cEmail)
//If !IsEmail(Alltrim(_cEmail))
