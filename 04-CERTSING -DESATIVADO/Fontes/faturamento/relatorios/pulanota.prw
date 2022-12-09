#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#include "ap5mail.ch"
#define _EOL chr(13) + chr(10)
/*                               
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PulaNota �Autor  �Douglas Mello       � Data �  /21/11/2011���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PulaNota()
                                                        
Local cquery
Local _cDataBase:= dDataBase                          
Local xCorpo
Local xDest 	:= "dmello@certisign.com.br"
Local xAssunto  := "Pulo de Nota - Serie 2"
Local xAnexo 	:= ""
Local xCC		:= ""
Local xBCC		:= ""
Local xAcc		:= ""
Local _cCont	:= 0

cquery := "(SELECT F2_DOC,F2_SERIE					"+Chr(13)+Chr(10)
cquery += " FROM  SF2010								"+Chr(13)+Chr(10)
cquery += " WHERE F2_FILIAL = '02' AND					"+Chr(13)+Chr(10)
cquery += "             F2_SERIE = '2  ' AND			"+Chr(13)+Chr(10)
cquery += "             F2_EMISSAO = '"+DTOS(_cDataBase)+"' AND		"+Chr(13)+Chr(10)
cquery += "             D_E_L_E_T_ = ' ')				"+Chr(13)+Chr(10)
cquery += " UNION (SELECT  F1_DOC, F1_SERIE						"+Chr(13)+Chr(10)
cquery += " FROM  SF1010								"+Chr(13)+Chr(10)
cquery += " WHERE F1_FILIAL = '02' AND					"+Chr(13)+Chr(10)
cquery += "             F1_SERIE = '2  ' AND			"+Chr(13)+Chr(10)
cquery += "             F1_EMISSAO = '"+DTOS(_cDataBase)+"' AND		"+Chr(13)+Chr(10)
cquery += "             D_E_L_E_T_ = ' ') 				"+Chr(13)+Chr(10)
cquery += " ORDER BY F2_DOC								"+Chr(13)+Chr(10)
      
If Select("TRR") > 0
	TRR->(DbCloseArea())            
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRR", .F., .T.)
                  
_cCont := TRR->F2_DOC                                               
cNotas := "Notas"+Chr(13)+Chr(10)
While !TRR->(Eof())
	If _cCont == TRR->F2_DOC
		_cCont := val(_cCont) + 1
		_cCont := "00" + alltrim(str(_cCont))
		TRR->(dbSkip())
		
	Else
		_pref	:=	TRR->F2_SERIE
		_doc	:=	_cCont
		dbSelectArea("SF2")
		dbSetOrder(1)
		If !DbSeek(xFilial("SF2")+_doc+_pref)
			dbSelectArea("SF3")
			dbSetOrder(5)
	        
			If DbSeek(xFilial("SF3")+_pref+_doc)
				If ALLTRIM(SF3->F3_OBSERV) == "NF CANCELADA"
					cNotas += "Nota "+alltrim(_cCont)+" esta cancelada no fiscal."+Chr(13)+Chr(10)		
					_cCont := val(_cCont) + 1
					_cCont := "00" + alltrim(str(_cCont))
				Else
					cNotas += "Nota "+alltrim(_cCont)+" esta valida no fiscal."+Chr(13)+Chr(10)		
					_cCont := val(_cCont) + 1
					_cCont := "00" + alltrim(str(_cCont))
				EndIf
			Else
				cNotas += "Nota "+alltrim(_cCont)+" pulou."+Chr(13)+Chr(10)		
				_cCont := val(_cCont) + 1
				_cCont := "00" + alltrim(str(_cCont))
			EndIf					
		Else
			_cCont := val(_cCont) + 1
			_cCont := "00" + alltrim(str(_cCont))
		EndIf	
	EndIf
End      
                 
xCorpo := "As notas abaixo pularam a numera��o."+Chr(13)+Chr(10)
xCorpo += ""+Chr(13)+Chr(10)
xCorpo += ""+Chr(13)+Chr(10)
xCorpo += cNotas+Chr(13)+Chr(10)
                
If len(cNotas) > 7
           
	EnvEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

EndIf

Return

/*****************************************************************************************/
/** Rotina que envia email
/*****************************************************************************************/
Static Function EnvEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := "sistemascorporativos@certisign.com.br"//AllTrim(GetNewPar("MV_RELACNT"," ")) 
Local   cPassword := "1234mudar" //AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := "sistemascorporativos@certisign.com.br" //Alltrim(GetMv("MV_RELAUSR",,"")) //Usu�rio para Autentica��o no Servidor de Email
Local   cPassAut  := "1234mudar" //Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autentica��o no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conex�o
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica��o
Local   nI        := 1
Local   lRet      := .T. 

If Empty(xDest+xCC+xBCC)
//	ConOut("Nao Foram Econtrados endere�os para Enviar e-mail Mensagem: "+xAssunto)
	Return(lRet)
EndIf

_cMsg := "Conectando a " + cServer + _EOL +;
"Conta: " + cAccount + _EOL +;
"Senha: " + cPassword
//ConOut(_cMsg) 

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk

If ( lOk )

    // Realiza autenticacao caso o servidor seja autenticado.
	If lAutentica
		If !MailAuth(cUserAut,cPassAut)
//			ConOut("Falha na Autentica��o do Usu�rio")
			DISCONNECT SMTP SERVER RESULT lOk
			IF !lOk
				GET MAIL ERROR cErrorMsg
//				ConOut("Erro na Desconex�o: "+cErrorMsg)
			ENDIF
			Return .F.
		EndIf
	EndIf

	SEND MAIL FROM cAccount TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk

	If !lOk
		GET MAIL ERROR cErro
		cErro := "Erro durante o envio - destinat�rio: " + xDest + _EOL + _EOL + cErro
//		conout(cErro)
		lRet:= .F.
	Endif
	
	DISCONNECT SMTP SERVER RESULT lOk
	If !lOk
		GET MAIL ERROR cErro
//		conout(cErro)
	Endif
Else
	GET MAIL ERROR cErro
//	conout(cErro)
	lRet:= .F.
EndIf

Return(lRet)
