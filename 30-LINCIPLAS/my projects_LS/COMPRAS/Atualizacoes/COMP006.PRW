#INCLUDE "PROTHEUS.CH" 

/*
+=========================================================+
|Programa: COMP006 |Autor: Antonio Carlos |Data: 24/03/10 |
+=========================================================+
|Descricao: Rotina responsavel pela Aprovação/Bloqueio do | 
|Solicitação de Compra via e-mail.                        |
+=========================================================+
|Uso: Especifico Laselva                                  |
+=========================================================+
*/

User Function COMP006(oProcess) 

Local _cNumPed	:= ""
Local _cRetorn	:= "" 
Local _cGrupo	:= ""
Local _cHtm		:= "" 
Local _cObs		:= ""
Local _cUser	:= Space(6) 
Local _cGrpApv	:= Space(6) 
Local _nValPed	:= 0
Local _nSaldo	:= 0
Local _nSaldoI	:= 0
Local _nVlrPed	:= 0 
Local _nContr	:= 0
Local nTotal	:= 0
Local _lAprov	:= .T.
Local _lAprova	:= .F.
Local _aAprov	:= {}

ConOut("COMP006 - CNUMEMP: "  )
ConOut("COMP006 - CNUMEMP: " + cNumEmp )
ConOut("COMP006 - SIGAMAT: " + SM0->M0_FILIAL )

_cFilial	:= oProcess:oHtml:RetByName("EMPRESA") 
_cNumPed	:= oProcess:oHtml:RetByName("PEDIDO") 
_cRetorn	:= oProcess:oHtml:RetByName("RBAPROVA")
_cUser		:= oProcess:oHtml:RetByName("RESPUSR")
_cComprad	:= oProcess:oHtml:RetByName("COMPRADOR")
_cGrpApv	:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cObs		:= Alltrim(oProcess:oHtml:RetByName("S2"))

/*
_cFilial	:= SM0->M0_FILIAL
_cNumPed	:= "575747"
_cRetorn	:= "S"
_cUser		:= RetCodUsr()
_cComprad	:= "000368"
_cGrpApv	:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_COD")
_cGrupo		:= Posicione("SC7",1,xFilial("SC7")+_cNumPed,"C7_APROV")
*/

//ConOut("COMP005 - PARAMETROS: " + _cFilial + " / " + _cNumPed + " / " + _cRetorn + " / " + _cUser + " / " + _cComprad + " / " + _cGrpApv + " / " + _cGrupo )

If Substr(_cRetorn,1,1) == "S"	 

	DbSelectArea("SC1")		
	SC1->( DbSetOrder(1) )
	SC1->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
	While SC1->( !Eof() ) .And. Substr(_cFilial,1,2) == SC1->C1_FILIAL .And. SC1->C1_NUM == _cNumPed
		
		RecLock("SC1",.F.)
		SC1->C1_APROV	:= "L"
		SC1->C1_NOMAPRO := UsrRetName(_cUser)
		SC1->( MsUnLock() )                
	
		SC1->( DbSkip() )
		
	EndDo
			
	DbSelectArea("SC1")		
	SC1->( DbSetOrder(1) )
	SC1->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )

	_cTo := "amendes@laselva.com.br;"+UsrRetMail(SC1->C1_USER)
	
	_cSubject	:= "Liberacao de Solicitacao de Compra "

	cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
	//cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

	// Empresa
	_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
	_cHtm+="   <tr>"
	_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>UNIDADE</b></font></TD>"
	_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Solicitacao de Compra</b></font></TD>"
	_cHtm+="   </tr>"
	_cHtm+="   <tr>"
	_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
	_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL+"</b></font></TD>"
	_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
	_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
	_cHtm+="   </tr>"
	_cHtm+="</TABLE>"                                      
	_cHtm+="<br>"

	//Aprovador
	_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
	_cHtm+="     <TR>"
	_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
	_cHtm+='               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
	_cHtm+="         </TD>"
	_cHtm+="     </TR>"
	_cHtm+="     <TR>"
	_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
	_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+Alltrim(UsrFullName(_cUser))+"</b></font>"
	_cHtm+="         </TD>"
	_cHtm+="     </TR>"
	_cHtm+=" </TABLE>"
	
	_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>OBSERVACÃO (Aprovação)</b></font></p>"

	_cHtm+="<TR>"
	_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
	_cHtm+="<font color=#000040 size=2 face=Verdana>"
	_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObs)+"</textarea></font></TD>"
	_cHtm+="</TR>"

	//U_EnvMail(_cTo,_cSubject, _cHtm,)
	
	cQuery := ""
	cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
	TcSQLExec(cQuery)
	
Else	

	DbSelectArea("SC1")		
	SC1->( DbSetOrder(1) )
	SC1->( DbSeek( xFilial("SC1")+_cNumPed ) )

	_cTo := UsrRetMail(SC1->C1_USER)
	_cSubject	:= "Bloqueio de Solicitacao de Compra "

	cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
	//cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

		// Empresa
	_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
	_cHtm+="   <tr>"
	_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>UNIDADE</b></font></TD>"
	_cHtm+="      <TD width=100 height=20 bgColor=#9999cc align=center>"
	_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>Solicitacao de Compra</b></font></TD>"
	_cHtm+="   </tr>"
	_cHtm+="   <tr>"
	_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
	_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL+"</b></font></TD>"
	_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
	_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+_cNumPed+"</b></font></TD>"
	_cHtm+="   </tr>"
	_cHtm+="</TABLE>"                                      
	_cHtm+="<br>"

	//Aprovador
	_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
	_cHtm+="     <TR>"
	_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
	_cHtm+='               <font color=#ffffff size=1 face=Verdana><b>Aprovador</b></font>"
	_cHtm+="         </TD>"
	_cHtm+="     </TR>"
	_cHtm+="     <TR>"
	_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
	_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+Alltrim(UsrFullName(_cUser))+"</b></font>"
	_cHtm+="         </TD>"
	_cHtm+="     </TR>"
	_cHtm+=" </TABLE>"
	
	_cHtm+="<p><font color=#9999cc size=2 face=Verdana><b>OBSERVACÃO (Aprovação)</b></font></p>"

	_cHtm+="<TR>"
	_cHtm+="<TD width=470 height=10 bgColor=#ffffff>"
	_cHtm+="<font color=#000040 size=2 face=Verdana>"
	_cHtm+="<textarea name=S1 rows=4 cols=50>"+Alltrim(_cObs)+"</textarea></font></TD>"
	_cHtm+="</TR>"

	//U_EnvMail(_cTo,_cSubject, _cHtm,)				
	cQuery := ""
	cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
	TcSQLExec(cQuery)
    
EndIf    

oProcess:Finish()

Return  