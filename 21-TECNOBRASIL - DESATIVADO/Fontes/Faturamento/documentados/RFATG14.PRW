//CONVERTE STRING CONTIDA EM MEM?RIA DO CAMPO A1_EMAIL E MIN?SCULAS E ATRIBUI ? _cEmail;
//FUN??O ISEMAIL() VERIFICA SE A STRING EM MEM?RIA EST? NO FORMATO DE EMAIL, SE N?O, EXECUTA ALERT(), SE SIM
//RETORNA _cMail com a string no formato v?lido para o gatilho. A1_EMAIL ? DOM?NIO E CONTRA-DOM?NIO.

User Function RFATG14() 

local _cEmail:= Lower(M->A1_EMAIL)



If !IsEmail(Alltrim(_cEmail))
	Alert("O Email digitado ? inv?lido. Por favor digite novamente no formato correto !")           
	_cEmail:=  ""
EndIf

Return(_cEmail)

