#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³A200BOK   º Autor ³ Microsiga           º Data ³   20/08/20 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDescricao ³ log de alteração da estrutura de produtos e envio por emailº±±
±±º          ³ para os responsaveis                                       º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Ponto de entrada após alteração da Estrutura               º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A200BOK

Local aRegs := PARAMIXB[1]
Local CR       	:= Chr(13)+Chr(10)
Local _cRemet  	:= ''
Local _cDest   	:= ''
Local _cAssunto	:= ''
Local _aAnexos	:= {}
Local _cPasta 	:= ''
Local cHtml    	:= ''
Local cRet    	:= ''

// Variaveis para envio do email.
_cRemet	  := Trim(GetMV("MV_RELACNT"))	
_cDest    := SuperGetMv('MV_EMLGPRO',, 'daniel@newbridge.srv.br')
//_cDest:= 'daniel@newbridge.srv.br'
_cAssunto := 'Log Estrutura de Produtos - Prozyn ' + DToC(dDataBase)

// Variaveis para filtro na queries
_dtAlter := DTOS(dDataBase)  // '20180730'   


For x := 1 to Len(aRegs)

    IF x = 1 .and. X <> Len(aRegs)
            cRet:="'"+alltrim(str(aRegs[x][1]))+"'"+","
        ELSEIF X > 1 .and. x < Len(aRegs) 
            cRet+="'"+alltrim(str(aRegs[x][1]))+"'"+","
        ELSEIF X = Len(aRegs)
            cRet+="'"+alltrim(str(aRegs[x][1]))+"'"
    Endif

Next

if cRet == "" // caso nao haja alteração sai da rotina. 
Return(.T.) // aceito as alteracoes.
Endif
 
// Query buscando os registros que foram manipulados na tabela. 
cQueryP	:=" select G1_COD, B1.B1_DESC AS DESCPROD, G1_COMP, BB.B1_DESC AS DESCCOMP, G1.R_E_C_N_O_, G1.R_E_C_D_E_L_, G1.D_E_L_E_T_ as DELET from SG1010 G1 " + CR
cQueryP	+=" INNER JOIN SB1010 B1 ON B1.B1_COD  = G1_COD " + CR
cQueryP	+=" INNER JOIN SB1010 BB ON BB.B1_COD  = G1_COMP " + CR
cQueryP	+=" WHERE " + CR
cQueryP	+=" BB.B1_TIPO <> 'MO' AND " + CR
cQueryP	+=" G1.R_E_C_N_O_ in ("+ cRet +") " + CR
cQueryP	+=" ORDER BY R_E_C_N_O_  " + CR 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ - CABECALHO Estrutura do produto             -³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml := '<!--mstheme-->'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><span style="font-family: trebuchet ms, arial, helvetica;"> <br /> <big> </big> <big> </big> <span style="font-family: Arial;"> <br /> </span> </span></span></p>'
cHtml += '<div style="margin-left: 40px; text-align: justify;"> Prezados(as).&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px; text-align: justify;"> A estrutura do produto abaixo foi modificada, segue lista das altera&ccedil;&otilde;es realizadas para an&aacute;lise.&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>LOG ALTERA&Ccedil;&Atilde;O DA ESTRUTURA DE PRODUTO.</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>Data da Altera&ccedil;&atilde;o da Estrutura: '+ DTOC(STOD(_dtAlter)) +'</strong></span></div>'
cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><!--mstheme--></span></p>'
cHtml += '<table style="text-align: left; height: 50px; margin-left: 40px; width: 920px;" border="1" cellspacing="0" cellpadding="1">'
cHtml += '<tbody>'
cHtml += '<tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CABECALHO DOS ITENS MODIFICADOS NA ESTRUTURA  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Prod Principal&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Descricao&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Prod Componente&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 250px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Descricao&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 70px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Status&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Cod Usuario&nbsp;</small><!--mstheme--></span></th>'
cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 150px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Nome Usuario&nbsp;</small><!--mstheme--></span></th>'
cHtml += '</tr>'


If Select("QRYP") > 0
       QRYP->( dbCloseArea() )
EndIf  

dbUseArea( .T., "TopConn", TCGenQry(,,cQueryP), "QRYP", .F., .F. )
 
If Select("QRYP") > 0
   	QRYP->( dbGoTop() )
	While QRYP->( !Eof() )

            if  QRYP->DELET == " "
                cStatus:= "Inclusao"
                else
                cStatus:= "Exclusao"
            endif
	
		cHtml += '<tr>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->G1_COD+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->DESCPROD+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->G1_COMP+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 288px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+QRYP->DESCCOMP+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 70px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+cStatus+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+__cUserid+'</small><!--mstheme--></span></td>'
		cHtml += ' <td style="text-align: left; font-family: Arial; width: 150px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+cusername+'</small><!--mstheme--></span></td>'
		cHtml += '</tr>'
	
	QRYP->( dbSkip() )
	Enddo
Endif		 
cHtml += '</tbody>'
cHtml += '</table>'
cHtml += '<p>&nbsp;</p>'

U_ENVMAIL(_cRemet, _cDest, _cAssunto, cHtml, _aAnexos, _cPasta)            
	
MsgAlert('E-Mail de Log de Estrutura Enviado com Sucesso.')			


Return(.T.) // aceito as alteracoes.
