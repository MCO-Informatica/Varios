#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM110STTS  บAutor  ณFernando Brito Muta บ Data ณ  21/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste programa tem como objetivo enviar e-mail da solicitacaoบฑฑ
ฑฑบ          ณde compras ao superior do usuario solicitante               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Expand                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT110BLO()

Local _aArea	:= GetArea()
Local _nOpc		:= ParamIxb[1]
Local _cHtm		:= ""

_cHtm+=" <td width=600><font color=#000040 size=3 face=Verdana><hr><b>"+IIF(_nOpc == 1,"Aprovacao de ","Bloqueio de ")+"Solicita็ใo de Compra </b></hr></font></td> "

// Empresa
_cHtm+="<TABLE cellSpacing=0 cellPadding=1 border=1 bordercolor=#ffffff width=405>"
_cHtm+="   <tr>'
_cHtm+="      <TD width=120 height=20 bgColor=#9999cc align=center>"
_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>EMPRESA</b></font></TD>"
_cHtm+='      <TD width=100 height=20 bgColor=#9999cc align=center>"
_cHtm+="         <font color=#ffffff size=2 face=Verdana><b>S.C.</b></font></TD>"
_cHtm+="   </tr>"
_cHtm+="   <tr>"
_cHtm+="      <TD width=120 height=30 bgColor=#E0EEEE align=center>"
_cHtm+="         <font size=1 face=Verdana color=#000040><b>"+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL+"</b></font></TD>"
_cHtm+="      <TD width=100 height=30 bgColor=#E0EEEE align=center>"
_cHtm+="         <font size=4 face=Verdana color=#000040><b>"+SC1->C1_NUM+"</b></font></TD>"
_cHtm+="   </tr>"
_cHtm+="</TABLE>"
_cHtm+="<br>"

//Solicitante                                                           
_cHtm+=" <TABLE width=405 height=50 cellSpacing=1 cellPadding=1 border=1 bordercolor=#ff0033>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 60px; HEIGHT: 20px bgColor=#ff0033 align=center>"
_cHtm+="               <font color=#ffffff size=1 face=Verdana><b>"+IIF(_nOpc == 1,"Aprovado por: ","Bloqueado por: ")+"</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+="     <TR>"
_cHtm+="         <TD style=WIDTH: 950px bgColor=#ffffff align=LEFT>"
_cHtm+="               <font size=2 face=Verdana color=#000040><b>"+UsrFullName(RetCodUsr())+"</b></font>"
_cHtm+="         </TD>"
_cHtm+="     </TR>"
_cHtm+=" </TABLE>"

_cSubject := IIF(_nOpc == 1,"Aprovacao de ","Bloqueio de ")+ " Solicitacao de Compras"

_cTo := IIF(_nOpc == 1,"amendes@laselva.com.br;"+Alltrim(UsrRetMail(SC1->C1_USER)),Alltrim(UsrRetMail(SC1->C1_USER)))

//U_EnvMail(_cTo,_cSubject, _cHtm,)
cQuery := ""
cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
TcSQLExec(cQuery)

RestArea(_aArea)
	
Return