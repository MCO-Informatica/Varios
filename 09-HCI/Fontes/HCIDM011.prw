#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"

User Function HCIDM011(_cEmpFil)

	Local _cFil
	Local _cEmp
	
	Private aFiles	    := { 'SA1','SA2','SA3','SA4','SB1','SB2','SB6','SB8','SBJ','SBZ','SC5','SC6',;
	'SC9','SD1','SD2','SD5','SE1','SE2','SE4','SF1','SF2','SF3','SF4',;
	'CT1','CT2', 'CT5', 'CTT','CTK','CTJ','CTI','SM0','SM4' }
	
	RpcSetType(3)
	
	If Valtype(_cEmpFil) != "A"
		_cFil := cFilAnt
		_cEmp := cEmpAnt
	Else
		_cFil := _cEmpFil[1,2]
		_cEmp := _cEmpFil[1,1]
	EndIf
	
	Conout("<<============ Formato dos Parametros passados ==============>>")
	Conout("Filial   "+Valtype(_cFil))
	Conout("Filial   "+_cFil)
	Conout("<<============ Formato dos Parametros passados ==============>>")
	Conout("Empresa   "+_cEmp)
	
	RpcSetEnv(_cEmp,_cFil,,,,, aFiles ) 
	
	Conout("Chamando funcao - HCIDM011")
	//***************************************************************
	Conout("Chamando funcao para agendamento- HCIDM011")
	U_HMA11PAg()
	Conout("Chamando funcao para reunião - HCIDM011")
	U_HMA11PRn()
	Conout("Chamando funcao para tarefas- HCIDM011")
	U_HMA11PTr()
	//***************************************************************
	ConOut("Retorno da Funcao - HCIDM011")
	
	RpcClearEnv() //Limpa o ambiente, liberando a licença e fechando as conexões                               
	
Return()

User Function HMA11PAg()

	Local _cQuery 	:= ""
	Local _cAliasAg := GetNextAlias()
	Local _aEmailC	:= Separa(GetMv("ES_WFCM011",,"000148"),",")
	Local _cEmailC	:= ""
	Local _cPara	:= ""
	Local _cMsg		:= ""
	Local _cAssunto	:= ""
	Local _cHrIni	:= ""
	Local _cHrFim	:= ""
	Local _cVend	:= ""
	Local _nI		:= 0
	
	For _nI	:= 1 To Len(_aEmailC)
		_cEmailC	+= Iif(!Empty(_cEmailC),";","") + AllTrim(UsrRetMail(_aEmailC[_nI]))
	Next _nI	
	
	_cEmailC	+= ";bzechetti@totalitsolutions.com.br"
	
	//Envio da Agenda
	_cQuery	:= "SELECT 	AD7_TOPICO, AD7_DATA, AD7_HORA1, AD7_HORA2, "
	_cQuery += " 		AD7_NROPOR, AD7_CODCLI, AD7_LOJA, AD7_VEND, AD7_ALERTA, AD7_TPALER, "
	_cQuery += " 		AD7_PROSPE, AD7_LOJPRO, AD7_LOCAL, AD7.R_E_C_N_O_ as CRECNO, "
	_cQuery += " 		A1_NOME, A1_CEP, A1_END, A1_BAIRRO, A1_EST, A1_MUN "
	_cQuery += " FROM " + RetSqlName("AD7") + " AD7 "
	
	_cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "' "		
	_cQuery += " AND A1_COD = AD7_CODCLI "
	_cQuery += " AND A1_LOJA = AD7_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	
	_cQuery += " WHERE AD7_FILIAL = '" + xFilial("AD7") + "' "		
	_cQuery += " AND AD7_AGEREU = 'A' "
	_cQuery += " AND AD7_DATA = '" + DtoS(dDataBase) + "' "
	_cQuery += " AND AD7_XENVEM = 'F' "
	_cQuery += " AND AD7.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasAg)
	
	TCSetField (_cAliasAg, "AD7_DATA"	, "D", TAMSX3("AD7_DATA")[1]	, TAMSX3("AD7_DATA")[2] )
	
	If (_cAliasAg)->(!EOF())
		dbSelectArea("AD7")
		dbSetOrder(1)
		While (_cAliasAg)->(!EOF())
			
			AD7->(dbGoTo((_cAliasAg)->CRECNO))
			
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + (_cAliasAg)->AD7_VEND,1))
			_cAssunto   := "Agendamento - " + Alltrim((_cAliasAg)->AD7_TOPICO)
			_cHrIni		:= Time()
			_cHrFim		:= (_cAliasAg)->AD7_HORA1 + ":00"
			_cAlerta	:= Iif((_cAliasAg)->AD7_TPALER=='1',"00:"+ALLTRIM(STR((_cAliasAg)->AD7_ALERTA))+":00",Iif((_cAliasAg)->AD7_TPALER=='2',ALLTRIM(STR((_cAliasAg)->AD7_ALERTA))+":00:00",ALLTRIM(STR((_cAliasAg)->AD7_ALERTA*24))+":00:00"))
			_cVend		:= AllTrim(SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + (_cAliasAg)->AD7_VEND,1)))
			
			If ElapTime(_cHrIni,_cHrFim) == _cAlerta
				
				_cMsg	:= '<html>'+CRLF
				_cMsg	+= '	<head>'+CRLF
				_cMsg	+= '		<title>Agendamento</title>'+CRLF
				_cMsg	+= '	</head> '+CRLF
				_cMsg	+= '	<body> '+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<FONT SIZE = "5" COLOR = "#CD2626"><B><center>Agenda - ' + Alltrim((_cAliasAg)->AD7_TOPICO) + '</center></B></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Prezado(a) ' + _cVend +',</p></FONT>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Foi realizado o seguinte agendamento:</p></FONT>'+CRLF
				_cMsg	+= '		<table border="0">'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Dia:</td> <td>' + SubStr(DtoS((_cAliasAg)->AD7_DATA),7,2) + '/' + SubStr(DtoS((_cAliasAg)->AD7_DATA),5,2) + '/' + SubStr(DtoS((_cAliasAg)->AD7_DATA),1,4) + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Hora Início:</td> <td>' +	(_cAliasAg)->AD7_HORA1 + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Hora Fim:</td> <td>' +		(_cAliasAg)->AD7_HORA2 + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Cliente:</td> <td> [' +		(_cAliasAg)->AD7_CODCLI + '/' + (_cAliasAg)->AD7_LOJA  + "] - " + AllTrim((_cAliasAg)->A1_NOME) + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Endereço:</td> <td>' +		AllTrim((_cAliasAg)->A1_END) + ', ' + AllTrim((_cAliasAg)->A1_BAIRRO) + ', ' + (_cAliasAg)->A1_CEP + ', ' + AllTrim((_cAliasAg)->A1_MUN) + ', ' + (_cAliasAg)->A1_EST  + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Local:</td> <td>' +			AllTrim((_cAliasAg)->AD7_LOCAL) + '</td></tr>  </FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#CD2626"><tr><td>Objetivo:</td> <td>' +		Alltrim(MsMM(AD7->AD7_CODMEM)) + '</td></tr> </FONT>'+CRLF
				_cMsg	+= '		</table>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '	</body>'+CRLF
				_cMsg	+= '</html>'+CRLF
				
				If MailDSC(_cPara, _cAssunto, _cMsg, _cEmailC)
					If RecLock("AD7",.F.)
						AD7->AD7_XENVEM	:= .T.
						AD7->(MsUnLock())
					EndIf
					Conout("Mensagem de agenda enviada para - " + _cPara)
				EndIf
			EndIf
			(_cAliasAg)->(dbSkip())
		EndDo		
	EndIf
	(_cAliasAg)->(dbCloseArea())

Return()

User Function HMA11PRn()

	Local _cQuery 	:= ""
	Local _cAliasRn	:= GetNextAlias()
	Local _aEmailC	:= Separa(GetMv("ES_WFCM011",,"000148"),",")
	Local _cEmailC	:= ""
	Local _cPara	:= ""
	Local _cMsg		:= ""
	Local _cAssunto	:= ""
	Local _cHrIni	:= ""
	Local _cHrFim	:= ""
	Local _cVend	:= ""
	Local _nI		:= 0
	
	For _nI	:= 1 To Len(_aEmailC)
		_cEmailC	+= Iif(!Empty(_cEmailC),";","") + AllTrim(UsrRetMail(_aEmailC[_nI]))
	Next _nI	
	
	_cEmailC	+= ";bzechetti@totalitsolutions.com.br"
	
	//Envio da Agenda
	_cQuery	:= "SELECT 	AD7_TOPICO, AD7_DATA, AD7_HORA1, AD7_HORA2, "
	_cQuery += " 		AD7_NROPOR, AD7_CODCLI, AD7_LOJA, AD7_VEND, "
	_cQuery += " 		AD7_PROSPE, AD7_LOJPRO, AD7_LOCAL, AD7.R_E_C_N_O_ as CRECNO, "
	_cQuery += " 		A1_NOME, A1_CEP, A1_END, A1_BAIRRO, A1_EST, A1_MUN "
	_cQuery += " FROM " + RetSqlName("AD7") + " AD7 "
	
	_cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "' "		
	_cQuery += " AND A1_COD = AD7_CODCLI "
	_cQuery += " AND A1_LOJA = AD7_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	
	_cQuery += " WHERE AD7_FILIAL = '" + xFilial("AD7") + "' "		
	_cQuery += " AND AD7_AGEREU = 'R' "
	_cQuery += " AND AD7_DATA = '" + DtoS(dDataBase) + "' "
	_cQuery += " AND AD7_XENVEM = 'F' "
	_cQuery += " AND AD7.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasRn)
	
	TCSetField (_cAliasRn, "AD7_DATA"	, "D", TAMSX3("AD7_DATA")[1]	, TAMSX3("AD7_DATA")[2] )
	
	If (_cAliasRn)->(!EOF())
		dbSelectArea("AD7")
		dbSetOrder(1)
		While (_cAliasRn)->(!EOF())
			
			AD7->(dbGoTo((_cAliasRn)->CRECNO))
			
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + (_cAliasAg)->AD7_VEND,1))
			_cAssunto   := "Agendamento - " + Alltrim((_cAliasAg)->AD7_TOPICO)
			_cHrIni		:= Time()
			_cHrFim		:= (_cAliasAg)->AD7_HORA1 + ":00"
			_cAlerta	:= Iif((_cAliasAg)->AD7_TPALER=='1',"00:"+ALLTRIM(STR((_cAliasAg)->AD7_ALERTA))+":00",Iif((_cAliasAg)->AD7_TPALER=='2',ALLTRIM(STR((_cAliasAg)->AD7_ALERTA))+":00:00",ALLTRIM(STR((_cAliasAg)->AD7_ALERTA*24))+":00:00"))
			_cVend		:= AllTRim(SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + (_cAliasAg)->AD7_VEND,1)))
			
			If ElapTime(_cHrIni,_cHrFim) == _cAlerta
				
				_cMsg	:= '<html>'+CRLF
				_cMsg	+= '	<head>'+CRLF
				_cMsg	+= '		<title>Agendamento</title>'+CRLF
				_cMsg	+= '	</head> '+CRLF
				_cMsg	+= '	<body> '+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<FONT SIZE = "5" COLOR = "#473C8B"><B><center>Reunião - ' + Alltrim((_cAliasRn)->AD7_TOPICO) + '</center></B></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '			<FONT COLOR = "#473C8B"><p>Prezado(a) ' + _cVend +',</p></FONT>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><p>Foi realizado o seguinte agendamento de reunião:</p></FONT>'+CRLF
				_cMsg	+= '		<table border="0">'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Dia:</td> <td>' + SubStr(DtoS((_cAliasRn)->AD7_DATA),7,2) + '/' + SubStr(DtoS((_cAliasRn)->AD7_DATA),5,2) + '/' + SubStr(DtoS((_cAliasRn)->AD7_DATA),1,4) + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Hora Início:</td> <td>' +	(_cAliasRn)->AD7_HORA1 + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Hora Fim:</td> <td>' +		(_cAliasRn)->AD7_HORA2 + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Cliente:</td> <td> [' +		(_cAliasRn)->AD7_CODCLI + '/' + (_cAliasRn)->AD7_LOJA  + "] - " + AllTrim((_cAliasRn)->A1_NOME) + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Endereço:</td> <td>' +		AllTrim((_cAliasRn)->A1_END) + ', ' + AllTrim((_cAliasRn)->A1_BAIRRO) + ', ' + (_cAliasRn)->A1_CEP + ', ' + AllTrim((_cAliasRn)->A1_MUN) + ', ' + (_cAliasRn)->A1_EST  + '</td></tr></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Local:</td> <td>' +			AllTrim((_cAliasRn)->AD7_LOCAL) + '</td></tr>  </FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#473C8B"><tr><td>Objetivo:</td> <td>' +		Alltrim(MsMM(AD7->AD7_CODMEM)) + '</td></tr> </FONT>'+CRLF
				_cMsg	+= '		</table>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '	</body>'+CRLF
				_cMsg	+= '</html>'+CRLF
				
				If MailDSC(_cPara, _cAssunto, _cMsg, _cEmailC)
					If RecLock("AD7",.F.)
						AD7->AD7_XENVEM	:= .T.
						AD7->(MsUnLock())
					EndIf
					Conout("Mensagem de agenda enviada para - " + _cPara)
				EndIf
			EndIf
			(_cAliasRn)->(dbSkip())
		EndDo		
	EndIf
	(_cAliasRn)->(dbCloseArea())

Return()

User Function HMA11PTr()

	Local _cQuery 	:= ""
	Local _cAliasTr	:= GetNextAlias()
	Local _aEmailC	:= Separa(GetMv("ES_WFCM011",,"000148"),",")
	Local _cEmailC	:= ""
	Local _cPara	:= ""
	Local _cMsg		:= ""
	Local _cAssunto	:= ""
	Local _cVend	:= ""
	Local _nI		:= 0
	
	For _nI	:= 1 To Len(_aEmailC)
		_cEmailC	+= Iif(!Empty(_cEmailC),";","") + AllTrim(UsrRetMail(_aEmailC[_nI]))
	Next _nI	
	
	_cEmailC	+= ";bzechetti@totalitsolutions.com.br"
	
	//Envio da Agenda
	_cQuery	:= "SELECT 	AD8_TAREFA, AD8_TOPICO, AD8_DTINI, AD8_DTFIM, AD8_STATUS, AD8_PRIOR, AD8_HORA1, AD8_HORA2,  "
	_cQuery += " 		AD8_CODCLI, AD8_LOJCLI, AD8_NROPOR, AD8_PROSPE, AD8_LOJPRO, AD8_HRREMI,  "
	_cQuery += " 		AD8_DTREMI, AD8.R_E_C_N_O_ AS CRECNO, AD8_CODUSR,  "
	_cQuery += " 		A1_NOME, A1_CEP, A1_END, A1_BAIRRO, A1_EST, A1_MUN "
	_cQuery += " FROM " + RetSqlName("AD8") + " AD8 "
	
	_cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "' "		
	_cQuery += " AND A1_COD = AD8_CODCLI "
	_cQuery += " AND A1_LOJA = AD8_LOJCLI "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	
	_cQuery += " WHERE AD8_FILIAL = '" + xFilial("AD8") + "' "		
	_cQuery += " AND (AD8_DTINI = '" + DtoS(dDataBase) + "' OR AD8_DTINI = '" + DtoS(dDataBase) + "' OR AD8_DTREMI = '" + DtoS(dDataBase) + "') "
	_cQuery += " AND AD8_XENVEM = 'F' "
	_cQuery += " AND AD8.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasTr)
	
	TCSetField (_cAliasTr, "AD8_DTINI"	, "D", TAMSX3("AD8_DTINI")[1]	, TAMSX3("AD8_DTINI")[2] )
	TCSetField (_cAliasTr, "AD8_DTFIM"	, "D", TAMSX3("AD8_DTFIM")[1]	, TAMSX3("AD8_DTFIM")[2] )
	
	If (_cAliasTr)->(!EOF())
		dbSelectArea("AD8")
		dbSetOrder(1)
		While (_cAliasTr)->(!EOF())
			
			AD8->(dbGoTo((_cAliasTr)->CRECNO))
			
			_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + (_cAliasTr)->AD8_CODUSR,7))
			_cVend		:= ALLTRIM(SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + (_cAliasTr)->AD8_CODUSR,7)))
			
			_cAssunto   := "Agendamento de Tarefa - " + Alltrim((_cAliasTr)->AD8_TOPICO)
			_cMsg		:= '<html>'+CRLF
			_cMsg		+= '	<head>'+CRLF
			_cMsg		+= '		<title>Tarefa</title>'+CRLF
			_cMsg		+= '	</head> '+CRLF
			_cMsg		+= '	<body> '+CRLF
			_cMsg		+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg		+= '		<FONT SIZE = "5" COLOR = "#8B2252"><B><center>Tarefa - ' + Alltrim((_cAliasTr)->AD8_TOPICO) + '</center></B></FONT>'+CRLF
			_cMsg		+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg		+= '		<p>'+CRLF
			_cMsg		+= '			<FONT COLOR = "#8B2252"><p>Prezado(a) ' + _cVend +',</p></FONT>'+CRLF
			_cMsg		+= '		<p>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><p>Segue descritivo da tarefa agendada:</p></FONT>'+CRLF
			_cMsg		+= '		<table border="0">'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Hora Início:</td> <td>' +	(_cAliasTr)->AD8_HORA1 + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Hora Fim:</td> <td>' +		(_cAliasTr)->AD8_HORA2 + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Data Início:</td> <td>' +	SubStr(DtoS((_cAliasTr)->AD8_DTINI),7,2) + '/' + SubStr(DtoS((_cAliasTr)->AD8_DTINI),5,2) + '/' + SubStr(DtoS((_cAliasTr)->AD8_DTINI),1,4) + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Data Fim:</td> <td>' +		SubStr(DtoS((_cAliasTr)->AD8_DTFIM),7,2) + '/' + SubStr(DtoS((_cAliasTr)->AD8_DTFIM),5,2) + '/' + SubStr(DtoS((_cAliasTr)->AD8_DTFIM),1,4) + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Cliente:</td> <td> [' +		(_cAliasTr)->AD8_CODCLI + '/' + (_cAliasTr)->AD8_LOJCLI + "] - " + AllTrim((_cAliasTr)->A1_NOME) + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Endereço:</td> <td>' +		AllTrim((_cAliasTr)->A1_END) + ', ' + AllTrim((_cAliasTr)->A1_BAIRRO) + ', ' + (_cAliasTr)->A1_CEP + ', ' + AllTrim((_cAliasTr)->A1_MUN) + ', ' + (_cAliasTr)->A1_EST  + '</td></tr></FONT>'+CRLF
			_cMsg		+= '		<FONT COLOR = "#8B2252"><tr><td>Objetivo:</td> <td>' +		Alltrim(MsMM(AD8->AD8_CODMEM)) + '</td></tr> </FONT>'+CRLF
			_cMsg		+= '		</table>'+CRLF
			_cMsg		+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg		+= '	</body>'+CRLF
			_cMsg		+= '</html>'+CRLF
			
			If MailDSC(_cPara, _cAssunto, _cMsg, _cEmailC)
				If RecLock("AD8",.F.)
					AD8->AD8_XENVEM	:= .T.
					AD8->(MsUnLock())
				EndIf
				Conout("Mensagem de agenda enviada para - " + _cPara)
			EndIf
			(_cAliasTr)->(dbSkip())
		EndDo		
	EndIf
	(_cAliasTr)->(dbCloseArea())

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet