#Include "rwmake.ch"     
#Include "Protheus.Ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "topconn.ch"     
#Include 'Ap5Mail.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACYSA02     ºAutor  ³Fontanelli          º Data ³   14/01/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processo de Envio de Estoque para Clientes                   º±±
±±º          ³ 			                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATEC                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACYSA02()		

Local cMensagem		:= ""
Local asend         := {}
Local aItens        := {}               

cPerg := "ACYSA02"
cPerg := PADR(cPerg,10)
ValidPerg(cPerg)
if !Pergunte(cPerg,.T.)
	Return()                       
	
Endif

cQuery1 := " SELECT  * "
cQuery1 += "   FROM "+RetSqlName("SA1")+", "+RetSqlName("SA3")+" "
cQuery1 += "  WHERE A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery1 += "    AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "          
cQuery1 += "    AND A1_EMAIL <> ' ' " 
cQuery1 += "    AND "+RetSqlName("SA1")+".D_E_L_E_T_ = ' ' " 
cQuery1 += "    AND A3_FILIAL = '"+xFilial("SA3")+"' "
cQuery1 += "    AND A3_COD = A1_VEND "
cQuery1 += "    AND "+RetSqlName("SA1")+".D_E_L_E_T_ = ' ' "
cQuery1 += "    ORDER BY A1_COD "
TcQuery cQuery1 New Alias "TMP1"

TMP1->(dbGoTop())
While TMP1->(!Eof())

	cMensagem := ""
	asend     := {}
	aItens    := {}

	cTitle:= "ACYSA, Estoque Disponivel (SEMANAL)."+" Data: "+ DTOC(dDATABASE) + " Hora: " + substr(Time(),1,5)+"."

	aAdd(aSend,{lower(alltrim(TMP1->A1_EMAIL2)),cTitle}) 

	If Len(aSend) > 0  
			
		cMensagem += "<html>"
		cMensagem += "<body>"
			
		cMensagem += '<p align="Left"><b><font color="#008000" face="Arial" size="4">'
		cMensagem += 'A C Y S A - SERVIÇO DE ENVIO DE MENSAGENS'
		cMensagem += '</font></b></p>'
		                   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³P E D I D O    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

		cMensagem += '<table border="1" width="100%">'
		
		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Empresa" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += " A C Y S A "
		cMensagem += '</font></td>'
		cMensagem += '</tr>'
	
		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Emissão" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += DTOC(dDATABASE) 
		cMensagem += '</font></td>'
		cMensagem += '</tr>'
		
		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Hora"                                                   
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += substr(Time(),1,5)
		cMensagem += '</font></td>'
		cMensagem += '</tr>'
			
		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Cliente" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += TMP1->A1_COD+"/"+TMP1->A1_LOJA+" "+Upper(TMP1->A1_NOME)		
		cMensagem += '</font></td>'
		cMensagem += '</tr>'

		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Vendedor" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += TMP1->A3_COD+"/"+TMP1->A3_LOJA+" "+Upper(TMP1->A3_NOME)		
		cMensagem += '</font></td>'
		cMensagem += '</tr>'

		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "eMail Vendedor" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font color="#008000" face="Verdana" size="2">'
		cMensagem += LOWER(TMP1->A3_EMAIL)		
		cMensagem += '</font></td>'
		cMensagem += '</tr>'
		
		cMensagem += '<tr>'
		cMensagem += '<td width="25%"><b><font size="2"> <font color="#008000" face="Verdana">'
		cMensagem += "Enviado por" 
		cMensagem += '</font> </font></b></td>'
		cMensagem += '<td width="75%"><font face="Verdana" size="2">'
		cMensagem += Upper(cUsername) 
		cMensagem += '</font></td>'
		cMensagem += '</tr>'
		
		// ITEM HTML
		
		cMensagem += '</table>'                       
		cMensagem += '<table border="1" width="100%">'
		cMensagem += '<tr>'
		                          
		//Codigo
		cMensagem += '<td width="25%"><b><font color="#008000" face="Verdana" size="2">'
		cMensagem += "Produto" 
		cMensagem += '</font></b></td>'
		        
		//Descricao
		cMensagem += '<td width="50%"><b><font color="#008000" face="Verdana" size="2">'
		cMensagem += "Descrição" 
		cMensagem += '</font></b></td>'
		      
		//Quantidade
		cMensagem += '<td width="25%"><b><font color="#008000" face="Verdana" size="2">'
		cMensagem += "Quantidade" 
		cMensagem += '</font></b></td>'
		
		cMensagem +=   '</tr>'
		
		aItens := {}             
	
	    cQuery2 := " SELECT  B2_FILIAL, "
	    cQuery2 += " 		B2_COD, "
	    cQuery2 += " 		B1_DESC, " 
	    cQuery2 += " 		B2_QATU	"	 
	    cQuery2 += "   FROM "+RetSqlName("SB2")+", "+RetSqlName("SB1")+" "
	    cQuery2 += "  WHERE B2_FILIAL = '"+xFilial("SB2")+"' "
	    cQuery2 += "    AND B2_QATU > 0 AND B2_LOCAL = '01' "
	    cQuery2 += "    AND "+RetSqlName("SB2")+".D_E_L_E_T_ = ' ' "
	    cQuery2 += "    AND B1_FILIAL = '"+xFilial("SB1")+"' "
	    cQuery2 += "    AND B1_COD = B2_COD "
		cQuery2 += "    AND B1_GRUPO IN ('0004','0005','0006','0007','0008','0009','0010','0021','0022','0023','0024','0025','0026','0027','0028')          
	    cQuery2 += "    AND "+RetSqlName("SB1")+".D_E_L_E_T_ = ' ' "
	    cQuery2 += "    ORDER BY B1_DESC"
		TcQuery cQuery2 New Alias "TMP2"
	
		TMP2->(dbGoTop())
		While TMP2->(!Eof())
			aAdd(aItens,{ TMP2->B2_COD, TMP2->B1_DESC, Transform(TMP2->B2_QATU,"@E 999,999,999") })				
			TMP2->(dbSkip())
		EndDo               
		TMP2->(dbCloseArea())  
		
		For nCont := 1 To Len(aItens)
		
			cMensagem += '<tr>'
			            
			//Poduto
			cMensagem += '<td width="10%"><font face="Verdana" size="2">'
			cMensagem += Iif(!Empty(aItens[nCont][1]),aItens[nCont][1],' ') 
			cMensagem += '</font></td>'
	
			//Descricaoo
			cMensagem += '<td width="10%"><font face="Verdana" size="2">'
			cMensagem += Iif(!Empty(aItens[nCont][2]),aItens[nCont][2],' ') 
			cMensagem += '</font></td>'
	
			// Quantidade
			cMensagem += '<td width="10%"><font color="#008000" face="Verdana" size="2"> <div align="right">'
			cMensagem += Iif(!Empty(aItens[nCont][3]),aItens[nCont][3],' ') 
			cMensagem += '</div></font></td>'
	
			cMensagem +=   '</tr>'           
			
		Next nCont
	
		cMensagem += '</table>'                                                   
	
		cMensagem += '</body>'
	
		cMensagem += '</html>'     
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Envio de E-mail³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
		For nCont := 1 To Len(aSend)

			
			lResult := .f. 

			cAutentic := "envio@acysa.com.br"
			cServer   := "smtp.acysa.com.br:587"	    // GetMV( 'MV_RELSERV' ) 
			cUser     := "envio@acysa.com.br"	   		// GetMV( 'MV_RELACNT' )
			cPass     := "acysa2012"		 			// GetMV( 'MV_RELPSW'  )
			lAuth     := .T. 		  				    // GetMV( 'MV_RELAUTH' )
			
			CONNECT SMTP SERVER cServer ACCOUNT cUser PASSWORD cPass RESULT lResult TLS SSL
					                                     
			If lResult .And. lAuth
			    lResult := MailAuth( cAutentic, cPass )
			    If !lResult
			        lResult := QADGetMail() // funcao que abre uma janela perguntando o usuario e senha para fazer autenticacao
			    EndIf
			EndIf
			
			If !lResult
			    GET MAIL ERROR cError
			    MsgAlert( TMP1->A1_COD+'-'+TMP1->A1_NOME +', Erro de Autenticacao no Envio de e-mail antes do envio: '+ aSend[nCont][1] +" "+ cError )
			    Return
			EndIf                   
        
			LjMsgRun( "Enviando E-Mail para o Cliente, "+TMP1->A1_COD+'-'+TMP1->A1_NOME ,"A L E R T A",{ || SLEEP(40000)})
				
			SEND MAIL FROM cUser TO aSend[nCont][1] SUBJECT aSend[nCont][2] BODY cMensagem RESULT lResult

			/*
			SEND MAIL FROM cFrom ;
			TO      	cEmailTo;
			BCC     	cEmailBcc;
			SUBJECT 	cAssunto;
			BODY    	cMensagem;
			ATTACHMENT  cAttach  ;
			RESULT lResult
			*/
							
			If !lResult
			    GET MAIL ERROR cError
			    MsgAlert( TMP1->A1_COD+'-'+TMP1->A1_NOME + ', Erro de Autenticacao no Envio de e-mail depois do envio: '+ aSend[nCont][1] +" "+ cError )
			    Return
			EndIf

			DISCONNECT SMTP SERVER
			     
		Next nCont
		
	Endif

	TMP1->(dbSkip())
EndDo               
TMP1->(dbCloseArea())  

	
Return(.T.)
                 
                                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ValidP1   ³ Autor ³ FONTANELLI            ³ Data ³ 21.02.11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Parametros da rotina.                			      	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

dbSelectArea("SX1")
dbSetOrder(1)

aRegs:={}
aAdd(aRegs,{cPerg,"01","Cliente de ?"   ,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Cliente ate ?"  ,"","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

Return(.T.)


