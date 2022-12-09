/******
 *
 * ROTINA: ROTINA PARA VERIFICAR E ALERTAR INCONSISTÊNCIA ENTRE SXF, SXE E A TABELA EM QUESTÃO.
 * COMPL.: ESTA ROTINA DEPENDE DO ARQUIVO CSSXE001.html QUE ESTÁ CONFIGURADO NO PARÂMETRO: MV_SXEMAIL.
 * DATA..: 11/08/2016
 * USO...: CERTISIGN CERTIFICADORA DIGITAL S/A
 *
 */
#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.ch"

user function CSSXE001()

Local lRet := .F.

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02

ConOut( dtoc( Date() )+" "+Time()+" Iniciando a leitura das tabelas SXE e SXF...." )
	    
ConOut( dtoc( Date() )+" "+Time()+" Verificando incosistensias" )
    
If lRet := JOBSXESXF()
	    
	ConOut( dtoc( Date() )+" "+Time()+" Viraficação finalizada com inconsistensias" )
	        
Else
	
	ConOut( dtoc( Date() )+" "+Time()+" Viraficação finalizada com inconsistensias" )

End If

Reset Environment

return

Static Function JOBSXESXF()

Local aErro := {}
Local lRet	:= .F.
Local aSX3	:= {}
Local cCampo := ""
Local cResult := ""

If Select("SX3") > 0
	DbSelectArea("SX3")
	DbCloseArea("SX3")
End If 

dbUseArea(.T., "CTREECDX", "\SYSTEM\SX3010.DTC", "SX3", .T., .F.)
dbSelectArea("SX3")

While SX3->(!EOF())

	If "GETSX" $ SX3->X3_RELACAO

		aAdd(aSX3,{SX3->X3_ARQUIVO, SX3->X3_CAMPO, SX3->X3_RELACAO})
		
	End If
	
	SX3->(dbSkip())
	
End  

If Select("SXF") > 0
	DbSelectArea("SXF")
	DbCloseArea("SXF")
End If

If Select("SXE") > 0
	DbSelectArea("SXE")
	DbCloseArea("SXE")
End If  

dbUseArea(.T., "CTREECDX", "\SYSTEM\SXF.DTC", "SXF", .T., .F.)
dbUseArea(.T., "CTREECDX", "\SYSTEM\SXE.DTC", "SXE", .T., .F.)

While SXE->(!EOF())

	cCampo := ""

	cAliasSxE := SXE->XE_ALIAS

	SXF->(dbGoTop())

	While SXF->(!EOF())
	
		cCampo := ""
	
		cAliasSxF := SXF->XF_ALIAS
	
		If SXF->XF_FILIAL == SXE->XE_FILIAL
		
			If SXF->XF_ALIAS == SXE->XE_ALIAS
				
				If SXF->XF_NUMERO == SXE->XE_NUMERO
					
					aAdd(aErro,{ALLTRIM(SXE->XE_FILIAL) ,;
								ALLTRIM(SXE->XE_ALIAS) ,;
								ALLTRIM(SXE->XE_NUMERO),; 
								"Sequência igual SXE e SXF"})
									
				End If
					
			End If
				
		End If
		
		SXF->(dbSkip())
							
	End
	
	SXE->(dbSkip())
		
End

SXF->(dbGoTop())

While SXF->(!EOF())

	For nCont := 1 To Len(aSX3)
		
		If aSX3[nCont][1] == SXF->XF_ALIAS
				
			cCampo := aSX3[nCont][2]
				
			If !Empty(cCampo)
		
				cQryExist := " SELECT COUNT(*) AS QTD "
				cQryExist += " FROM ALL_TABLES "
				cQryExist += " WHERE TABLE_NAME = '" + RetSqlName(ALLTRIM(SXF->XF_ALIAS)) +"'"
			
				If Select("TMP") > 0
					DbSelectArea("TMP")
					DbCloseArea("TMP")
				End If
			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryExist),"TMP",.F.,.T.)
			
				If TMP->QTD > 0
		
					cQry := " SELECT " + cCampo + " AS CAMPO "
					cQry += " FROM " + RetSqlName(ALLTRIM(SXF->XF_ALIAS)) 
					cQry += " WHERE D_E_L_E_T_ = '' "
					cQry += " AND " + IIF(SUBSTR(ALLTRIM(SXF->XF_ALIAS), 1, 1) == "S", SUBSTR(ALLTRIM(SXF->XF_ALIAS), 2, 2),SUBSTR(ALLTRIM(SXF->XF_ALIAS), 1, 3))  + "_FILIAL = '" + SUBSTR(SXF->XF_FILIAL,1,2) + "' "
					cQry += " AND " + cCampo + " = '" + ALLTRIM(SXF->XF_NUMERO) + "'"
				
					cQry = changequery(cQry)
				
					If Select("_QRY") > 0
						DbSelectArea("_QRY")
						DbCloseArea("_QRY")
					End If
				
					dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"_QRY",.F.,.T.)
			
					cResult := _QRY->CAMPO
								
				End If
			
			End If
		
			If !Empty(cResult)
					
				aAdd(aErro,{ALLTRIM(SXF->XF_FILIAL) ,;
							ALLTRIM(SXF->XF_ALIAS) ,;
							ALLTRIM(SXF->XF_NUMERO),; 
							"Sequência SXF já existe na tabela "+SXF->XF_ALIAS})
					
			End If

		End If
			
	Next nCont
	
	SXF->(dbSkip())
	
End

SXE->(dbGoTop())

While SXE->(!EOF())

	For nCont := 1 To Len(aSX3)
		
		If aSX3[nCont][1] == SXE->XE_ALIAS
				
			cCampo := aSX3[nCont][2]
				
			If !Empty(cCampo)
		
				cQryExist := " SELECT COUNT(*) AS QTD "
				cQryExist += " FROM ALL_TABLES "
				cQryExist += " WHERE TABLE_NAME = '" + RetSqlName(ALLTRIM(SXE->XE_ALIAS)) +"'"
			
				If Select("TMP") > 0
					DbSelectArea("TMP")
					DbCloseArea("TMP")
				End If
			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryExist),"TMP",.F.,.T.)
			
				If TMP->QTD > 0
		
					cQry := " SELECT " + cCampo + " AS CAMPO "
					cQry += " FROM " + RetSqlName(ALLTRIM(SXE->XE_ALIAS)) 
					cQry += " WHERE D_E_L_E_T_ = '' "
					cQry += " AND " + IIF(SUBSTR(ALLTRIM(SXE->XE_ALIAS), 1, 1) == "S", SUBSTR(ALLTRIM(SXE->XE_ALIAS), 2, 2),SUBSTR(ALLTRIM(SXE->XE_ALIAS), 1, 3))  + "_FILIAL = '" + SUBSTR(SXE->XE_FILIAL,1,2) + "' "
					cQry += " AND " + cCampo + " = '" + ALLTRIM(SXE->XE_NUMERO) + "'"
			
					cQry = changequery(cQry)
				
					If Select("_QRY") > 0
						DbSelectArea("_QRY")
						DbCloseArea("_QRY")
					End If
				
					dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"_QRY",.F.,.T.)
		
					cResult := _QRY->CAMPO
								
				End If
		
				If !Empty(cResult)
					
					aAdd(aErro,{ALLTRIM(SXE->XE_FILIAL) ,;
								ALLTRIM(SXE->XE_ALIAS) ,;
								ALLTRIM(SXE->XE_NUMERO),; 
								"Sequência SXE já existe na tabela "+SXE->XE_ALIAS})
				
				End If	
				
			End If
			
		End If
			
	Next nCont
	
	SXE->(dbSkip())
	
End

If Len(aErro) > 0

	lRet := CSSEND(aErro)

End If

Return lRet

Static Function CSSEND(aErro)

Local lRet := .F.
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local lRet := .T.
Local cBody := ''

Private cDe      := GetMV("MV_EMCONTA")
Private cPara    := SuperGetMv("MV_SISCOR", .T., "sistemascorporativos@certisign.com.br")
Private cCc      := Space(200)
Private cAssunto := "Inconsistencias SXE SXF"
Private cAnexo   := ""
Private cServer  := GetMV("MV_RELSERV") 
Private cEmail   := GetMV("MV_EMCONTA") 
Private cPass    := GetMV("MV_RELPSW")  
Private lAuth    := GetMv("MV_RELAUTH")
Private cPatch	 := SuperGetMv("MV_SXEMAIL", .T., "\WORKFLOW\EVENTO\CSSXE001.html") 

aSort(aErro, , ,{ | x,y | x[2] < y[2] } )
                                                                                                                                             
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn

  GET MAIL ERROR cError
  
  MsgAlert("Falha na conexão "+cError)
  
  lRet := .F.
  
  Return lRet
  
Endif

If lAuth

  lAuth := MailAuth(cEmail,cPass)
  
  If !lAuth
  
  	ApMsgInfo("Autenticação FALHOU","Protheus")
  	lRet := .F.
  	Return lRet
  	
  Endif
  
Endif

oHtml := TWFHtml():New(cPatch) 

oHtml:ValByName("sxe.filial"         , {}) 
oHtml:ValByName("sxe.alias"    , {}) 
oHtml:ValByName("sxe.numero"      , {})
oHtml:ValByName("sxe.erro"      , {})

For n := 1 To Len(aErro)

	aadd(oHtml:ValByName("sxe.filial"     )      , aErro[n][1])  
	aadd(oHtml:ValByName("sxe.alias"     )      , aErro[n][2]) 
	aadd(oHtml:ValByName("sxe.numero"     )      , aErro[n][3])
	aadd(oHtml:ValByName("sxe.erro"     )      , aErro[n][4])
	
Next n

cBody := ohtml:HtmlCode() 

SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cBody ATTACHMENT RESULT lResulSend
  
If !lResulSend

  GET MAIL ERROR cError
  
  Conout(cError)
  
  lRet := .F.
 
Endif

DISCONNECT SMTP SERVER

Return lRet