User Function MT390DTV()
    Local aArea := GetArea()
    Local cHtml := ""
    Local _cRemet := ""
    Local _cDest := ""
    Local _cAssunto := ""

    // Variaveis para envio do email.
    _cRemet	  := Trim(GetMV("MV_RELACNT"))	
    _cDest    := SuperGetMv('MV_LOTEVCT',, 'bruno@newbridge.srv.br')
    // _cDest:= 'denis.varella@newbridge.srv.br'
    _cAssunto := 'ALERTA | Lote com prazo de validade alterada - Prozyn ' + DToC(Date())
    _aAnexos := {}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ - CABECALHO Estrutura do produto             -³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cHtml := '<!--mstheme-->'
    cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><span style="font-family: trebuchet ms, arial, helvetica;"> <br /> <big> </big> <big> </big> <span style="font-family: Arial;"> <br /> </span> </span></span></p>'
    cHtml += '<div style="margin-left: 40px; text-align: justify;"> Prezados(as).&nbsp;</div>'
    cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
    cHtml += '<div style="margin-left: 40px; text-align: justify;"> O lote abaixo teve sua data de validade alterada.&nbsp;</div>'
    cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
    cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>ALERTA DE ALTERAÇÃO NA DATA DE VENCIMENTO DE LOTE.</strong></span></div>'
    cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
    cHtml += '<div style="margin-left: 40px;"><span style="font-family: Arial;"><strong>Data da Altera&ccedil;&atilde;o: '+ DTOC(Date()) +'</strong></span></div>'
    cHtml += '<div style="margin-left: 40px;">&nbsp;</div>'
    cHtml += '<p><span style="font-family: trebuchet ms, arial, helvetica;"><!--mstheme--></span></p>'
    cHtml += '<table style="text-align: left; height: 50px; margin-left: 40px; width: 920px;" border="1" cellspacing="0" cellpadding="1">'
    cHtml += '<tbody>'
    cHtml += '<tr>'

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ CABECALHO DOS ITENS MODIFICADOS NA ESTRUTURA  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Produto&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 200px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Descrição&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Lote&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 120px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Data Fabricação&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 120px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Novo Vencimento&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Data de Alteração&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '<th style="background-color: #C0D9D9; color: #000000; font-family: Arial; text-align: center; white-space: nowrap; height: 10px; width: 150px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>&nbsp;Usuário&nbsp;</small><!--mstheme--></span></th>'
    cHtml += '</tr>'

    cHtml += '<tr>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+SB8->B8_PRODUTO+'</small><!--mstheme--></span></td>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 200px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+POSICIONE("SB1",1,xFilial("SB1")+SB8->B8_PRODUTO,"B1_DESC")+'</small><!--mstheme--></span></td>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+SB8->B8_LOTECTL+'</small><!--mstheme--></span></td>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 120px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+DtoC(SB8->B8_DATA)+'</small><!--mstheme--></span></td>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 120px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+DtoC(SB8->B8_DTVALID)+'</small><!--mstheme--></span></td>'
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+DtoC(Date())+'</small><!--mstheme--></span></td>'
    cUserID := RetCodUsr()
    cHtml += ' <td style="text-align: center; font-family: Arial; width: 100px;"><!--mstheme--><span style="font-family: trebuchet ms, arial, helvetica;"><small>'+UsrFullName(cUserID)+'</small><!--mstheme--></span></td>'
    cHtml += '</tr>'

    cHtml += '</tbody>'
    cHtml += '</table>'
    cHtml += '<p>&nbsp;</p>'


    U_ENVMAIL(_cRemet, _cDest, _cAssunto, cHtml, {}, "")   

    RestArea(aArea)
Return
