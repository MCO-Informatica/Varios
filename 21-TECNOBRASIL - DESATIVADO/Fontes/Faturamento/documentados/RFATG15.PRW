//CONVERTE STRING CONTIDA EM MEM?RIA DO CAMPO A1_EMAIL2E MIN?SCULAS E ATRIBUI ? _cEmail;
//FUN??O ISEMAIL() VERIFICA SE A STRING EM MEM?RIA EST? NO FORMATO DE EMAIL, SE N?O, EXECUTA ALERT(), SE SIM
//RETORNA _cMail com a string no formato v?lido para o gatilho. A1_EMAIL2 ? DOM?NIO E CONTRA-DOM?NIO.
User Function RFATG15() 

local _cEmail:= Lower(M->A1_EMAIL2)

If !IsEmail(Alltrim(_cEmail))
	Alert("O Email digitado ? inv?lido. Por favor digite novamente no formato correto")             
	_cEmail:=  ""
EndIf

Return(_cEmail)
//If !IsEmail(Alltrim(_cEmail))
