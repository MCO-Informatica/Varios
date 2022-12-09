#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"  
#INCLUDE "TbiConn.ch"
#INCLUDE "rwmake.ch"    
#INCLUDE "TOTVS.ch"     
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch" 
#Include "Ap5Mail.ch"
#INCLUDE "RestFul.ch" 

//==================================================================================
// Programa.....: GENXFUN
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Biblioteca de funcoes
// Uso..........: Verquimica
//==================================================================================

//==================================================================================
// Programa.....: CriaSX1
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Gerador das perguntas dentro do SX1   
// Uso..........: Verquimica
//==================================================================================

User Function CriaSX1(cPerg,aRegs)

//=================================
// Variaveis da Rotina     
//=================================
Local i 	:= 0
Local j 	:= 0
Local aArea := GetArea()

dbSelectArea("SX1")
dbSetOrder(1)

For i:= 1 to Len(aRegs)
	if !dbSeek(PADR(cPerg,Len(X1_GRUPO))+aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to Len(aRegs[1])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

RestArea(aArea)

Return Nil    

//==================================================================================
// Programa.....: FinalArea
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Fecha Alias "QUERYS"
// Uso..........: Verquimica
//==================================================================================

User Function FinalArea(cTabFech) 

If Select(cTabFech) > 0
	(cTabFech)->(dbCloseArea())
EndIf

Return Nil	   

//==================================================================================
// Programa.....: SndEmail
// Autor........: Anderson Goncalves
// Data.........: 23/03/21
// Descricao....: Envio de email 
// Uso..........: Verquimica
//==================================================================================

User Function SndEmail(cServer,cNomeEmail,cContaMail,cSenhaMail,nPorta,cAssunto,cDestino,cTexto,aAnexoPdf,lConfirma,lCopia,lJob,cCopia)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                             
//³ Variaveis da Rotina                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oMail	   		:= Nil
Local oMessage 		:= Nil
Local nErro	   		:= 0 
Local nZ			:= 0   

Default cServer		:= GetMV("ES_SRVMAIL",,"mail.verquimica.com.br")    
Default cNomeEmail	:= GetMV("ES_NOMMAIL",,"Protheus Verquimica")
Default cContaMail	:= GetMV("ES_EMLMAIL",,"protheus@verquimica.com.br")
Default cSenhaMail	:= GetMV("ES_SNHMAIL",,"totvs!2021")
Default nPorta		:= 587
Default aAnexoPdf	:= {}
Default cAssunto	:= ""
Default cDestino	:= ""
Default cTexto		:= ""
Default lConfirma	:= .F.
Default lCopia 		:= .F.
Default lJob		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                             
//³ Montagem da classe para conexao                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMail := TMailManager():New()
//oMail:SetUseTLS( .T. )
oMail:Init( '', cServer , cContaMail, cSenhaMail, 0, nPorta ) 
oMail:SetSmtpTimeOut( 180 )

conout( 'Conectando do SMTP' )

nErro := oMail:SmtpConnect()

If nErro <> 0
	conout( "ERROR:" + oMail:GetErrorString( nErro ) ) 
	If !lJob
		Aviso("SMTP","Não foi possivel conecção ao servidor de SMTP"+Chr(13)+Chr(10)+;
				"ERROR:" + oMail:GetErrorString( nErro ),{"&Ok"},2,"Falha na coneção")
	EndIf
    oMail:SMTPDisconnect()
    Return(.F.)
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                             
//³ realizacao da autenticacao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nErro := oMail:SmtpAuth( cContaMail ,cSenhaMail )

If nErro <> 0
    conout( "ERROR:" + oMail:GetErrorString( nErro ) ) 
    If !lJob
		Aviso("SMTP","Não foi possivel autenticar a conta "+AllTrim(cContaMail)+" ao servidor de SMTP"+Chr(13)+Chr(10)+;
				"ERROR:" + oMail:GetErrorString( nErro ),{"&Ok"},2,"Falha na coneção")
	EndIf
    oMail:SMTPDisconnect()
    return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                             
//³ Monta classe para envio do email                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMessage := TMailMessage():New()
oMessage:Clear() 

oMessage:cFrom              := Capital(cNomeEmail)+" <"+cContaMail+">" 

If 'teste' $ Lower(GetEnvServer())
	cDestino += '; peterson@verquimica.com.br'
	lCopia := .F.
ENDIF

oMessage:cTo                   := cDestino
oMessage:cCc                    := ""  

//envia copia oculta
If lCopia                           
	oMessage:cBCC := cCopia		
EndIf  

oMessage:cSubject               := cAssunto
oMessage:cBody                  := cTexto 

//Confirmacao de Leitura
If lConfirma
	oMessage:SetConfirmRead( .T.)
EndIf   

//Anexo Boleto
If Len(aAnexoPdf) > 0
	For nZ := 1 To Len(aAnexoPdf)
		oMessage:AttachFile(aAnexoPdf[nZ])  
	Next nZ
EndIf

nErro := oMessage:Send( oMail )

If nErro <> 0
    conout( "ERROR:" + oMail:GetErrorString( nErro ) )
    If !lJob
		Aviso("SMTP","Não foi possivel enviar o email da conta "+AllTrim(cContaMail)+Chr(13)+Chr(10)+;
				"ERROR:" + oMail:GetErrorString( nErro ),{"&Ok"},2,"Falha de envio")
	EndIf
    oMail:SMTPDisconnect()
  	return .F.
else
	Conout("*********************************************************************")
	Conout("RWORKF01 - Data: "+TransForm(Date(),"@D")+" Hora: "+Time())
	Conout("Email enviado para: "+ cDestino)
	Conout("*********************************************************************")
EndIf

conout( 'Desconectando do SMTP' )
oMail:SMTPDisconnect()

Return(.T.)

//====================================================================================
//Programa.....: RetAceWeb
//Autor........: Anderson Goncalves
//Data.........: 22/10/2019
//Descricao....: Retura acentos do retorno UTF8
//Uso..........: VerQuimica
//====================================================================================

User Function RetAceWeb(cString) 

//====================================================================================
//Variaveis da Rotina
//====================================================================================
Local cRet	:= cString

cRet := Replace(cRet,"Á","A")
cRet := Replace(cRet,"á","a")
cRet := Replace(cRet,"Â","A")
cRet := Replace(cRet,"â","a")
cRet := Replace(cRet,"À","A")
cRet := Replace(cRet,"à","a")
cRet := Replace(cRet,"Å","A")
cRet := Replace(cRet,"å","a")
cRet := Replace(cRet,"Ã","A")
cRet := Replace(cRet,"ã","a")
cRet := Replace(cRet,"Ä","A")
cRet := Replace(cRet,"ä","a")
cRet := Replace(cRet,"É","E")
cRet := Replace(cRet,"é","e")
cRet := Replace(cRet,"Ê","E")
cRet := Replace(cRet,"ê","e")
cRet := Replace(cRet,"È","e")
cRet := Replace(cRet,"è","e")
cRet := Replace(cRet,"Ë","E")
cRet := Replace(cRet,"ë","e")
cRet := Replace(cRet,"Í","I")
cRet := Replace(cRet,"í","i")
cRet := Replace(cRet,"Î","I")
cRet := Replace(cRet,"î","i")
cRet := Replace(cRet,"Ì","I")
cRet := Replace(cRet,"ì","i")
cRet := Replace(cRet,"Ï","I")
cRet := Replace(cRet,"ï","i")
cRet := Replace(cRet,"Ó","O")
cRet := Replace(cRet,"ó","o")
cRet := Replace(cRet,"Ô","O")
cRet := Replace(cRet,"ô","o")
cRet := Replace(cRet,"Ò","O")
cRet := Replace(cRet,"ò","o")
cRet := Replace(cRet,"Ø","O")
cRet := Replace(cRet,"ø","o")
cRet := Replace(cRet,"Õ","O")
cRet := Replace(cRet,"õ","o")
cRet := Replace(cRet,"Ö","O")
cRet := Replace(cRet,"ö","o")
cRet := Replace(cRet,"Ú","U")
cRet := Replace(cRet,"ú","u")
cRet := Replace(cRet,"Û","U")
cRet := Replace(cRet,"û","u")
cRet := Replace(cRet,"Ù","U")
cRet := Replace(cRet,"ù","u")
cRet := Replace(cRet,"Ü","U")
cRet := Replace(cRet,"ü","u")
cRet := Replace(cRet,"Ç","C")
cRet := Replace(cRet,"ç","c")
cRet := Replace(cRet,"Ñ","N")
cRet := Replace(cRet,"ñ","n")

Return(cRet)

//===========================================================================
//Programa....: DADRECET
//Autor.......: Anderson Goncalves
//Data........: 30/03/21 
//Descricao...: Gatilha dados atraves do CNPJ (Substitui Marshap) Não 
//				funciona na receita (Recapcha)
//Uso.........: Verquimica
//===========================================================================

User Function DADRECET(cCnpj,cTabela,cCpo)

//====================================================
// Variaveis da Rotina
//====================================================
Local cUrl		:= "https://www.receitaws.com.br/v1/cnpj/" 
Local oObjRet	:= Nil  
Local cRet      := ""
Local cCep      := ""
Local aAreaCC2	:= CC2->(GetArea())
Local cLinha	:= ""
Local aLinha	:= {}

Default cCpo	:= ""

cRet := httpGet(cUrl+AllTrim(cCnpj))
If FWJsonDeserialize( cRet, @oObjRet ) 

	If oObjRet:STATUS <> "ERROR"
		
		If cTabela == "SA1"
    		M->A1_NOME  	:= Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME))))
  			M->A1_NREDUZ	:= Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:FANTASIA))))
			If Empty(M->A1_NREDUZ)
			  	M->A1_NREDUZ := CriaVar("A1_NREDUZ")
			EndIf
			If Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME)))) <> ","
				If !Empty(Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:LOGRADOURO))))) 
            		M->A1_END    := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:LOGRADOURO))))+", "+oObjRet:NUMERO
				Else
					M->A1_END    := Space(TamSX3("A1_END")[1])
				EndIf		
            	If !EMpty(Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:MUNICIPIO)))) )
					M->A1_MUN    := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:MUNICIPIO)))) 
				else
					M->A1_MUN    := Space(TamSX3("A1_MUN")[1]) 
				Endif	

            	cCep := Replace(oObjRet:CEP,".","")
            	cCep := Replace(cCep,"-","")
				If !Empty(cCep)
            		M->A1_CEP    := cCep
				else
					M->A1_CEP := Space(TamSX3("A1_CEP")[1])
				Endif

				If !Empty(Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:BAIRRO)))))
            		M->A1_BAIRRO := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:BAIRRO))))
				else
					M->A1_BAIRRO := Space(TamSX3("A1_BAIRRO")[1])	
				Endif

				If !Empty(AllTrim(oObjRet:UF) )
            		M->A1_EST    := AllTrim(oObjRet:UF) 
				else
					M->A1_EST	:= Space(TamSX3("A1_EST")[1])
				EndIf
				If !Empty(AllTrim(oObjRet:COMPLEMENTO))
					M->A1_COMPLEM := AllTrim(oObjRet:COMPLEMENTO)
				else
					M->A1_COMPLEM	:= Space(TamSX3("A1_COMPLEM:")[1])	
				EndIf

				dbSelectArea("CC2")
				CC2->(dbSetOrder(4)) //CC2_FILIAL, CC2_EST, CC2_MUN
				CC2->(dbSeek(xFilial("CC2")+M->A1_EST+M->A1_MUN))
				M->A1_COD_MUN 	:= CC2->CC2_CODMUN
				M->A1_DTNASC	:= ctod(AllTrim(oObjRet:ABERTURA)) 
				M->A1_PESSOA	:= If(Len(cCnpj)==14,"J","F")

				cRet := cCnpj

			EndIf

		ElseIf cTabela == "SA2" 

			cCamArq := GetTempPath()
			cNomArq := cCnpj+".txt"
			nHandle := fCreate(cCamArq+cNomArq) 

			cBuffer := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME))))+"|" //Nome
			cBuffer += Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:FANTASIA))))+"|" //Nome reduzido
		
    		If Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME)))) <> ","
				cBuffer += Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:LOGRADOURO))))+", "+oObjRet:NUMERO+"|" //Endereço
				cBuffer += Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:MUNICIPIO))))+"|" //Municipio
			
            	cCep := Replace(oObjRet:CEP,".","")
            	cCep := Replace(cCep,"-","")

				cBuffer += cCep+"|"
				cBuffer += Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:BAIRRO))))+"|"
				cBuffer += AllTrim(oObjRet:UF)+"|" 
				cBuffer += AllTrim(oObjRet:COMPLEMENTO)+"|"
			
				dbSelectArea("CC2")
				CC2->(dbSetOrder(4)) //CC2_FILIAL, CC2_EST, CC2_MUN
				CC2->(dbSeek(xFilial("CC2")+M->A2_EST+M->A2_MUN))
				cBuffer += CC2->CC2_CODMUN
				FWrite(nHandle, cBuffer)

				fClose(nHandle) 

				cRet := cCnpj

			EndIf

        ElseIf cTabela == "SA4" 

    		M->A4_NOME  	:= Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME))))
  			M->A4_NREDUZ	:= Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:FANTASIA))))
			If Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:NOME)))) <> ","
            	M->A4_END    := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:LOGRADOURO))))+", "+oObjRet:NUMERO
            	M->A4_MUN    := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:MUNICIPIO)))) 

            	cCep := Replace(oObjRet:CEP,".","")
            	cCep := Replace(cCep,"-","")
            	M->A4_CEP    := cCep
            	M->A4_BAIRRO := Upper(U_RetAceWeb(DecodeUtf8(AllTrim(oObjRet:BAIRRO))))
            	M->A4_EST    := AllTrim(oObjRet:UF) 
				M->A4_COMPLEM:= AllTrim(oObjRet:COMPLEMENTO)

				dbSelectArea("CC2")
				CC2->(dbSetOrder(4)) //CC2_FILIAL, CC2_EST, CC2_MUN
				CC2->(dbSeek(xFilial("CC2")+M->A4_EST+M->A4_MUN))
				M->A4_COD_MUN 	:= CC2->CC2_CODMUNa2_nome

				cRet := cCnpj

			Else
				// cCpo == 1 - Nome
				// cCpo == 2 - Nome Reduzido
				// cCpo == 3 - Endereço
				// cCpo == 4 - Municipio
				// cCpo == 5 - Cep
				// cCpo == 6 - Bairro
				// cCpo == 7 - Estado
				// cCpo == 8 - Complemento
				// cCpo == 9 - Cod Municipio Ibge
				FT_FUse(GetTempPath()+cCnpj+".txt")
				FT_FGotop() 
				cLinha  := FT_FREADLN()
				aLinha	:= Separa(cLinha,"|")
				If cCpo == "1"
					cRet := aLinha[1]
				ElseIf cCpo == "2"
					cRet := aLinha[2]
				ElseIf cCpo == "3"
					cRet := aLinha[3]
				ElseIf cCpo == "4"
					cRet := aLinha[4]
				ElseIf cCpo == "5"
					cRet := aLinha[5]
				ElseIf cCpo == "6"
					cRet := aLinha[6]
				ElseIf cCpo == "7"
					cRet := aLinha[7]
				ElseIf cCpo == "8"
					cret := aLinha[8]
				ElseIf cCpo == "9"
					cRet := aLinha[9]
				EndIf

				FT_FUSE()
				If cCpo == "9"
					fErase(GetTempPath()+cCnpj+".txt")
				EndIf

        	EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaCC2)

Return(cRet)

