#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/* **************************************************************************
***Programa  *AFAT023   * Autor * Eneovaldo Roveri Jr.  * Data *25/11/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Envio de email quando da libera��o do pedido               ***
*****************************************************************************
***Parametros*                                                            ***
*****************************************************************************
***Retorno   *                                                            ***
*****************************************************************************
***Aplicacao *                                                            ***
*****************************************************************************
***Uso       *                                                            ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */

//Chamada da rotina pelo bot�o
User Function A440EMAIL()
Local aArea    := GetArea()
Local _nReg9   := SC9->( recno() )
Local _lRet    := .T.


	IF IsInCallStack("MATA311")
	
	RestArea(aArea)
	
	RETURN(.T.)
	
	Endif

	if _lRet
		if MsgYesNo( "Enviar email do pedido "+SC5->C5_NUM+"?" )
			if MsgYesNo( "Deseja abrir o Email?" )
			U_AFAT023( SC5->C5_NUM, .F. )
			else
				if .not. U_AFAT023( SC5->C5_NUM, .T. )
				MSGBOX( "O Sistema n�o conseguir enviar o email. Verifique as configura��es ou utilize o Servi�o de Email." )
				endif
			endif
		endif
	endif

SC9->( dbgoto( _nReg9 ) )
RestArea(aArea)
Return( _lRet )

//Efetivar o envio para o outlook
User Function AFAT023( cPedido, lAutomatico, lConf )
Local aArea    := GetArea()
Local lRet     := .T.
Local cFile    := GetTempPath() + StrZero( Val( cPedido ), 8, 0 ) + ".HTML"
Local cAnex    := GetTempPath() + "TERMO.DOC"
Local _nReg5   := SC5->( recno() )
Local _nReg6   := SC6->( recno() )
Local _nReg9   := SC9->( recno() )

Local cFilterSC5 := ""

Private lBlind := .f.

Default lConf := .F.

	IF IsInCallStack("MATA410")
	lConf := .T.
	Endif

	if lAutomatico == NIL
	lAutomatico := .F.
	endif

	If .not. (File (cAnex))
	//CpyT2S( "\TERMO.DOC", cAnex )
	Copy File TERMO.DOC to ( cAnex )
	Endif
//CpyT2S( _cOrig, _cDest )

	If .not. (File (GetTempPath()+"colorschememapping.xml"))
	Copy File colorschememapping.xml to (GetTempPath()+"colorschememapping.xml")
	endif
	If .not. (File (GetTempPath()+"filelist.xml"))
	Copy File filelist.xml to (GetTempPath()+"filelist.xml")
	endif
	If .not. (File (GetTempPath()+"themedata.thmx"))
	Copy File themedata.thmx to (GetTempPath()+"themedata.thmx")
	endif
	If .not. (File (GetTempPath()+"image001.jpg"))
	Copy File image001.jpg to (GetTempPath()+"image001.jpg")
	endif
	If .not. (File (GetTempPath()+"LOGO.jpg"))
	Copy File LOGO.jpg to (GetTempPath()+"LOGO.jpg")
	endif

cFilterSC5 := SC5->( dbFilter() )
	If !Empty( AllTrim( cFilterSC5 ) )
	SC5->( dbClearFilter() )
	Endif

SC5->( dbSetOrder( 1 ) )
lRet := SC5->( dbSeek( xFilial( "SC5" ) + cPedido ) )

	if lRet
	lRet := GerarHtml( cFile, cPedido, lConf )
	endif

	If lRet .and. lConf
	ShellExecute("open","iexplore.exe",cFile,"", 1 )
	Elseif lRet
	
	cMailVend :=""
		If !empty(SC5->C5_VEND1)
			if SA3->(DbSeek( xFilial("SA3") + SC5->C5_VEND1 ))
			cMailVend := ALLTRIM(SA3->A3_EMAIL)+";"+ALLTRIM(SA3->A3_XEMAIL)
			Endif
		Endif
	
		if lAutomatico //S� envia a mensagem
		
		//      U_FNMGetMail({SC5->C5_XMAILCO},"CONFIRMA��O DE PEDIDO","CONFIRMA��O DO PEDIDO NUMERO "+SC5->C5_NUM,{cFile,cAnex})
		
			if !empty(cMailVend)//!empty(SC5->C5_XMAILCO)
			lRet := U_MKENVMAI( ,,,, cMailVend+Chr(59), "Confirma��o de Pedido", "", cFile+";"+cAnex, .F. )
				if lRet
				U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Email","email enviado com sucesso")
				else
				U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Email","falha no envio do email")
				endif
			endif
		
		else //utiliza-se do outlook
		
		U_ABRENOTES( cMailVend, {cFile}, "", "Confirma��o%20de%20Pedido%20-%20"+SM0->M0_NOMECOM )
		//      U_ABRENOTES( cMailVend, {cFile,cAnex}, "", "Confirma��o%20de%20Pedido%20-%20"+SM0->M0_NOMECOM )
		U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Email","email enviado para o outlook")
		
		endif
	
	endif

	If !Empty( AllTrim( cFilterSC5 ) )
	SC5->( MsFilter( cFilterSC5 ) )
	Endif

SC5->( dbgoto( _nReg5 ) )
SC6->( dbgoto( _nReg6 ) )
SC9->( dbgoto( _nReg9 ) )
RestArea(aArea)
Return( lRet )

/*
Gerar arquivo HTML com a C�pia do Pedido
*/
Static Function GerarHtml( cFile, cPedido, lConf )
	Local nHandle := 0
	Local cNomVen := space( len( SA3->A3_NOME ) )
	Local cVenInt := space( len( SA3->A3_NOME ) )
	Local cTelInt := space( len( SA3->A3_TEL ) )
	Local cEmaInt := space( len( SA3->A3_EMAIL ) )
	Local cCfop   := ""
	Local cPedCli := ""
	Local cDesCfo := ""
	Local memoObs := ""
	Local cAliCF  := ""
	Local _cNome  := ""
	Local _cCgc   := ""
	Local _cTel   := ""
	Local _cEEnt  := ""
	Local _cCepe  := ""
	Local _cBaie  := ""
	Local _cCide  := ""
	Local _cEste  := ""
	Local aSX513  := {}

	Default lConf := .F.

	if SC5->C5_TIPO == "B" .or. SC5->C5_TIPO == "D"
		cAliCF := "SA2"
	else
		cAliCF := "SA1"
	endif

	cNomVen := NomeVend()

	memoObs := MemoSUA()

	SE4->( dbSeek( xFilial( "SE4" ) + SC5->C5_CONDPAG ) )
	SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_TRANSP ) )
	(cAliCF)->( dbSeek( xFilial( cAliCF ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
	if SC6->( dbSeek( xFilial( "SC6" ) + SC5->C5_NUM ) )
		cCfop := SC6->C6_CF
		cPedCli := SC6->C6_PEDCLI
	endif

	aSX513 := FWGetSX5("13",cCfop)

	if !Empty(aSX513)
		cDesCfo := aSX513[1][4]
	endif

	if cAliCF == "SA1"
		if SA3->( dbSeek( xFilial("SA3") + SA1->A1_VENDINT ) )
			cVenInt := SA3->A3_NOME
			cTelInt := "("+Alltrim(SA3->A3_DDDTEL)+")" + transf( alltrim( SA3->A3_TEL ), "@R !!!!-!!!!!!!!!!!!!!!" )
			cEmaInt := alltrim( SA3->A3_EMAIL )
		endif
		_cNome := SA1->A1_NOME
		_cCgc  := SA1->A1_CGC
		_cTel  := "("+SA1->A1_DDD+") "+SA1->A1_TEL
		If !Empty(SC5->C5_CENT) .and. SC5->C5_CENT + SC5->C5_LENT <> SC5->C5_CLIENTE + SC5->C5_LOJACLI
			(cAliCF)->(dbSetOrder(1))
			(cAliCF)->(dbSeek(xFilial("SA1") + SC5->C5_CENT + SC5->C5_LENT))
			_cEEnt := "( " + ALLTRIM( SA1->A1_NOME ) + ") " + SA1->A1_END
			_cCepe := SA1->A1_CEP
			_cBaie := SA1->A1_BAIRRO
			_cCide := SA1->A1_MUN
			_cEste := SA1->A1_EST
		Else
			_cEEnt := SA1->A1_ENDENT
			_cCepe := SA1->A1_CEPE
			_cBaie := SA1->A1_BAIRROE
			_cCide := SA1->A1_MUNE
			_cEste := SA1->A1_ESTE
		Endif
	else
		if SA3->( dbSeek( xFilial("SA2") + SC5->C5_VENDX2 ) )
			cVenInt := SA3->A3_NOME
			cTelInt := "("+Alltrim(SA3->A3_DDDTEL)+")" + transf( alltrim( SA3->A3_TEL ), "@R !!!!-!!!!!!!!!!!!!!!" )
			cEmaInt := alltrim( SA3->A3_EMAIL )
		endif
		_cNome := SA2->A2_NOME
		_cCgc  := SA2->A2_CGC
		_cTel  := "("+SA2->A2_DDD+") "+SA2->A2_TEL
		_cEEnt := alltrim( SA2->A2_END ) + " " + alltrim( SA2->A2_NR_END )
		_cCepe := SA2->A2_CEP
		_cBaie := SA2->A2_BAIRRO
		_cCide := SA2->A2_MUN
		_cEste := SA2->A2_EST
	endif

	If (File (cFile))
		FErase (cFile)
	Endif

	nHandle	:= MsFCreate(cFile)

	htHeadPed( nHandle )

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<body lang=PT-BR link=blue vlink=purple style='tab-interval:35.4pt'> " )  //Troquei apost.p/aspas pois o html usa apost.nesse momento
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '<div class=Section1> ' )
	Fwrite( nHandle, ' ' )

	htLogoMak( nHandle )

	Fwrite( nHandle, "<p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center'>"+;
		"<span style='font-size:14.0pt;font-family:" +;
		'"Arial","sans-serif"' + "'><i>Confirma��o de Pedido</i></span></p> " )

	Fwrite( nHandle, "<p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:center'>"+;
		"<span style='font-size:12.0pt;font-family:" +;
		'"Arial"' + "'>N�mero: </span><span style='font-size:18.0pt;font-family:" +;
		'"Arial"' + "'>" + SC5->C5_NUM + "<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>AV. " )
	Fwrite( nHandle, 'PRESIDENTE JUSCELINO, 570/578 � PIRAPORINHA � DIADEMA � SP � CEP: 09950-370<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>Fone: " )
	Fwrite( nHandle, "(11) 4360-6400<span style='mso-spacerun:yes'>� </span>- e-mail <a " )
	Fwrite( nHandle, 'href="mailto:IMCDBRASIL@IMCDBRASIL.COM.BR">IMCDBRASIL@IMCDBRASIL.COM.BR</a> � internet: <a ' )
	Fwrite( nHandle, 'href="http://www.imcdgroup.com">www.imcdgroup.com</a><o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Nr. Pedido Cliente: "+cPedCli+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Data: " + dtoc( dDataBase ) + "<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Cliente: " + _cNome )
	Fwrite( nHandle, "<span style='mso-spacerun:yes'>������� </span>CNPJ: " )
	Fwrite( nHandle, _cCgc+'<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Contato: " )
	Fwrite( nHandle, SC5->C5_XNOMCON+'<span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>������������������������������������� </span>Telefone: " )
	Fwrite( nHandle, _cTel+"<span style='mso-spacerun:yes'>���� </span>               <o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Representante: " + cNomVen )
	Fwrite( nHandle, "<span style='mso-spacerun:yes'>���������� </span><span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'>�������������</span>Vendedor Interno: "+cVenInt+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>CFOP: "+cCfop+" "+cDesCfo )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Transportadora: "+SA4->A4_NOME )
	Fwrite( nHandle, "<span style='mso-spacerun:yes'>������������ </span>Frete: "+iif(SC5->C5_TPFRETE="C","CIF","FOB")+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Prazo de Pagamento: "+SE4->E4_DESCRI+"<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Local de Entrega: " +_cEEnt+ "<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'> " )
	Fwrite( nHandle, '</span>  CEP: '+_cCepe+'<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Bairro: "+ _cBaie +"<span " )
	Fwrite( nHandle, "style='mso-spacerun:yes'>" )
	Fwrite( nHandle, '</span>Munic�pio: '+_cCide+' <span ' )
	Fwrite( nHandle, "style='mso-spacerun:yes'>" )
	Fwrite( nHandle, '</span>UF : ' + _cEste + '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
//Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
//Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
//Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:"+'"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
//Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

	htItens( nHandle, lConf )

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	if .not. Empty( SC5->C5_HIST )
		Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Obs: "+SC5->C5_HIST+"<o:p></o:p></span></p> " )
	endif
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	if .not. Empty( SC5->C5_HIST )
		Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>"+memoObs+"<o:p></o:p></span></p> " )
	else
		Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Obs: "+memoObs+"<o:p></o:p></span></p> " )
	endif
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

	htInforma( nHandle )

	Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
	Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'>"+cVenInt+"<o:p></o:p></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'>Tel.: "+cTelInt+"<o:p></o:p></p> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'>"+cEmaInt+"<o:p></o:p></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
	Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
	Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, '</div> ' )

	htTermo( nHandle )

	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</body> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</html> ' )

	If (nHandle>=0)
		FClose (nHandle)
	Endif


return( .T. )


/*
Head do HTML
*/
Static Function htHeadPed( nHandle )

	Fwrite( nHandle, '<html xmlns:v="urn:schemas-microsoft-com:vml" ' )
	Fwrite( nHandle, 'xmlns:o="urn:schemas-microsoft-com:office:office" ' )
	Fwrite( nHandle, 'xmlns:w="urn:schemas-microsoft-com:office:word" ' )
	Fwrite( nHandle, 'xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" ' )
	Fwrite( nHandle, 'xmlns="http://www.w3.org/TR/REC-html40"> ' )
	Fwrite( nHandle, '<head> ' )
	Fwrite( nHandle, '<meta http-equiv=Content-Type content="text/html; charset=windows-1252"> ' )
	Fwrite( nHandle, '<meta name=ProgId content=Word.Document> ' )
	Fwrite( nHandle, '<meta name=Generator content="Microsoft Word 12"> ' )
	Fwrite( nHandle, '<meta name=Originator content="Microsoft Word 12"> ' )
	Fwrite( nHandle, '<link rel=File-List href="Layout%20Pedido_arquivos/filelist.xml"> ' )
	Fwrite( nHandle, '<!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:DocumentProperties> ' )
	Fwrite( nHandle, '  <o:Author>Administrador</o:Author> ' )
	Fwrite( nHandle, '  <o:Template>Normal</o:Template> ' )
	Fwrite( nHandle, '  <o:LastAuthor>Administrador</o:LastAuthor> ' )
	Fwrite( nHandle, '  <o:Revision>2</o:Revision> ' )
	Fwrite( nHandle, '  <o:TotalTime>37</o:TotalTime> ' )
	Fwrite( nHandle, '  <o:Created>2009-11-26T12:37:00Z</o:Created> ' )
	Fwrite( nHandle, '  <o:LastSaved>2009-11-26T12:37:00Z</o:LastSaved> ' )
	Fwrite( nHandle, '  <o:Pages>1</o:Pages> ' )
	Fwrite( nHandle, '  <o:Words>340</o:Words> ' )
	Fwrite( nHandle, '  <o:Characters>1841</o:Characters> ' )
	Fwrite( nHandle, '  <o:Lines>15</o:Lines> ' )
	Fwrite( nHandle, '  <o:Paragraphs>4</o:Paragraphs> ' )
	Fwrite( nHandle, '  <o:CharactersWithSpaces>2177</o:CharactersWithSpaces> ' )
	Fwrite( nHandle, '  <o:Version>12.00</o:Version> ' )
	Fwrite( nHandle, ' </o:DocumentProperties> ' )
	Fwrite( nHandle, '</xml><![endif]--> ' )
	Fwrite( nHandle, '<link rel=themeData href="Layout%20Pedido_arquivos/themedata.thmx"> ' )
	Fwrite( nHandle, '<link rel=colorSchemeMapping ' )
	Fwrite( nHandle, 'href="Layout%20Pedido_arquivos/colorschememapping.xml"> ' )
	Fwrite( nHandle, '<!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <w:WordDocument> ' )
	Fwrite( nHandle, '  <w:SpellingState>Clean</w:SpellingState> ' )
	Fwrite( nHandle, '  <w:GrammarState>Clean</w:GrammarState> ' )
	Fwrite( nHandle, '  <w:TrackMoves>false</w:TrackMoves> ' )
	Fwrite( nHandle, '  <w:TrackFormatting/> ' )
	Fwrite( nHandle, '  <w:HyphenationZone>21</w:HyphenationZone> ' )
	Fwrite( nHandle, '  <w:PunctuationKerning/> ' )
	Fwrite( nHandle, '  <w:DrawingGridHorizontalSpacing>5,5 pt</w:DrawingGridHorizontalSpacing> ' )
	Fwrite( nHandle, '  <w:DisplayHorizontalDrawingGridEvery>2</w:DisplayHorizontalDrawingGridEvery> ' )
	Fwrite( nHandle, '  <w:ValidateAgainstSchemas/> ' )
	Fwrite( nHandle, '  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid> ' )
	Fwrite( nHandle, '  <w:IgnoreMixedContent>false</w:IgnoreMixedContent> ' )
	Fwrite( nHandle, '  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText> ' )
	Fwrite( nHandle, '  <w:DoNotPromoteQF/> ' )
	Fwrite( nHandle, '  <w:LidThemeOther>PT-BR</w:LidThemeOther> ' )
	Fwrite( nHandle, '  <w:LidThemeAsian>X-NONE</w:LidThemeAsian> ' )
	Fwrite( nHandle, '  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript> ' )
	Fwrite( nHandle, '  <w:Compatibility> ' )
	Fwrite( nHandle, '   <w:BreakWrappedTables/> ' )
	Fwrite( nHandle, '   <w:SnapToGridInCell/> ' )
	Fwrite( nHandle, '   <w:WrapTextWithPunct/> ' )
	Fwrite( nHandle, '   <w:UseAsianBreakRules/> ' )
	Fwrite( nHandle, '   <w:DontGrowAutofit/> ' )
	Fwrite( nHandle, '   <w:SplitPgBreakAndParaMark/> ' )
	Fwrite( nHandle, '   <w:DontVertAlignCellWithSp/> ' )
	Fwrite( nHandle, '   <w:DontBreakConstrainedForcedTables/> ' )
	Fwrite( nHandle, '   <w:DontVertAlignInTxbx/> ' )
	Fwrite( nHandle, '   <w:Word11KerningPairs/> ' )
	Fwrite( nHandle, '   <w:CachedColBalance/> ' )
	Fwrite( nHandle, '  </w:Compatibility> ' )
	Fwrite( nHandle, '  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel> ' )
	Fwrite( nHandle, '  <m:mathPr> ' )
	Fwrite( nHandle, '   <m:mathFont m:val="Cambria Math"/> ' )
	Fwrite( nHandle, '   <m:brkBin m:val="before"/> ' )
	Fwrite( nHandle, '   <m:brkBinSub m:val="&#45;-"/> ' )
	Fwrite( nHandle, '   <m:smallFrac m:val="off"/> ' )
	Fwrite( nHandle, '   <m:dispDef/> ' )
	Fwrite( nHandle, '   <m:lMargin m:val="0"/> ' )
	Fwrite( nHandle, '   <m:rMargin m:val="0"/> ' )
	Fwrite( nHandle, '   <m:defJc m:val="centerGroup"/> ' )
	Fwrite( nHandle, '   <m:wrapIndent m:val="1440"/> ' )
	Fwrite( nHandle, '   <m:intLim m:val="subSup"/> ' )
	Fwrite( nHandle, '   <m:naryLim m:val="undOvr"/> ' )
	Fwrite( nHandle, '  </m:mathPr></w:WordDocument> ' )
	Fwrite( nHandle, '</xml><![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true" ' )
	Fwrite( nHandle, '  DefSemiHidden="true" DefQFormat="false" DefPriority="99" ' )
	Fwrite( nHandle, '  LatentStyleCount="267"> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="0" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Normal"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="heading 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 7"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 8"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" Name="toc 9"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="10" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Title"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="11" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtitle"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="22" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Strong"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="20" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="59" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Table Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="1" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="No Spacing"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="34" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="29" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Quote"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="30" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 1"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 2"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 3"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 4"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 5"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="60" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Shading Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="61" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="62" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Light Grid Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="63" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="64" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="65" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="66" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium List 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="67" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="68" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="69" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="70" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Dark List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="71" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Shading Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="72" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful List Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="73" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" Name="Colorful Grid Accent 6"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="19" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="21" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="31" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="32" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="33" SemiHidden="false" ' )
	Fwrite( nHandle, '   UnhideWhenUsed="false" QFormat="true" Name="Book Title"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="37" Name="Bibliography"/> ' )
	Fwrite( nHandle, '  <w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"/> ' )
	Fwrite( nHandle, ' </w:LatentStyles> ' )
	Fwrite( nHandle, '</xml><![endif]--> ' )
	Fwrite( nHandle, '<style> ' )
	Fwrite( nHandle, '<!-- ' )
	Fwrite( nHandle, ' /* Font Definitions */ ' )
	Fwrite( nHandle, ' @font-face ' )
	Fwrite( nHandle, '	{font-family:"Cambria Math"; ' )
	Fwrite( nHandle, '	panose-1:2 4 5 3 5 4 6 3 2 4; ' )
	Fwrite( nHandle, '	mso-font-charset:0; ' )
	Fwrite( nHandle, '	mso-generic-font-family:roman; ' )
	Fwrite( nHandle, '	mso-font-pitch:variable; ' )
	Fwrite( nHandle, '	mso-font-signature:-1610611985 1107304683 0 0 159 0;} ' )
	Fwrite( nHandle, '@font-face ' )
	Fwrite( nHandle, '	{font-family:Calibri; ' )
	Fwrite( nHandle, '	panose-1:2 15 5 2 2 2 4 3 2 4; ' )
	Fwrite( nHandle, '	mso-font-charset:0; ' )
	Fwrite( nHandle, '	mso-generic-font-family:swiss; ' )
	Fwrite( nHandle, '	mso-font-pitch:variable; ' )
	Fwrite( nHandle, '	mso-font-signature:-1610611985 1073750139 0 0 159 0;} ' )
	Fwrite( nHandle, ' /* Style Definitions */ ' )
	Fwrite( nHandle, ' p.MsoNormal, li.MsoNormal, div.MsoNormal ' )
	Fwrite( nHandle, '	{mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-parent:""; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:0cm; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'a:link, span.MsoHyperlink ' )
	Fwrite( nHandle, '	{mso-style-priority:99; ' )
	Fwrite( nHandle, '	color:blue; ' )
	Fwrite( nHandle, '	mso-themecolor:hyperlink; ' )
	Fwrite( nHandle, '	text-decoration:underline; ' )
	Fwrite( nHandle, '	text-underline:single;} ' )
	Fwrite( nHandle, 'a:visited, span.MsoHyperlinkFollowed ' )
	Fwrite( nHandle, '	{mso-style-noshow:yes; ' )
	Fwrite( nHandle, '	mso-style-priority:99; ' )
	Fwrite( nHandle, '	color:purple; ' )
	Fwrite( nHandle, '	mso-themecolor:followedhyperlink; ' )
	Fwrite( nHandle, '	text-decoration:underline; ' )
	Fwrite( nHandle, '	text-underline:single;} ' )
	Fwrite( nHandle, 'p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpFirst, li.MsoListParagraphCxSpFirst, div.MsoListParagraphCxSpFirst ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:0cm; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	margin-bottom:.0001pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpMiddle, li.MsoListParagraphCxSpMiddle, div.MsoListParagraphCxSpMiddle ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:0cm; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	margin-bottom:.0001pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, 'p.MsoListParagraphCxSpLast, li.MsoListParagraphCxSpLast, div.MsoListParagraphCxSpLast ' )
	Fwrite( nHandle, '	{mso-style-priority:34; ' )
	Fwrite( nHandle, '	mso-style-unhide:no; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-top:0cm; ' )
	Fwrite( nHandle, '	margin-right:0cm; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	margin-left:36.0pt; ' )
	Fwrite( nHandle, '	mso-add-space:auto; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '.MsoChpDefault ' )
	Fwrite( nHandle, '	{mso-style-type:export-only; ' )
	Fwrite( nHandle, '	mso-default-props:yes; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-fareast-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-bidi-font-family:"Times New Roman"; ' )
	Fwrite( nHandle, '	mso-bidi-theme-font:minor-bidi; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '.MsoPapDefault ' )
	Fwrite( nHandle, '	{mso-style-type:export-only; ' )
	Fwrite( nHandle, '	margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	line-height:115%;} ' )
	Fwrite( nHandle, '@page Section1 ' )
	Fwrite( nHandle, '	{size:595.3pt 841.9pt; ' )
	Fwrite( nHandle, '	margin:36.0pt 36.0pt 36.0pt 36.0pt; ' )
	Fwrite( nHandle, '	mso-header-margin:35.4pt; ' )
	Fwrite( nHandle, '	mso-footer-margin:35.4pt; ' )
	Fwrite( nHandle, '	mso-paper-source:0;} ' )
	Fwrite( nHandle, 'div.Section1 ' )
	Fwrite( nHandle, '	{page:Section1;} ' )
	Fwrite( nHandle, ' /* List Definitions */ ' )
	Fwrite( nHandle, ' @list l0 ' )
	Fwrite( nHandle, '	{mso-list-id:1430926773; ' )
	Fwrite( nHandle, '	mso-list-type:hybrid; ' )
	Fwrite( nHandle, '	mso-list-template-ids:-204317186 68550673 68550681 68550683 68550671 68550681 68550683 68550671 68550681 68550683;} ' )
	Fwrite( nHandle, '@list l0:level1 ' )
	Fwrite( nHandle, '	{mso-level-text:"%1\)"; ' )
	Fwrite( nHandle, '	mso-level-tab-stop:none; ' )
	Fwrite( nHandle, '	mso-level-number-position:left; ' )
	Fwrite( nHandle, '	text-indent:-18.0pt;} ' )
	Fwrite( nHandle, '@list l1 ' )
	Fwrite( nHandle, '	{mso-list-id:1470628229; ' )
	Fwrite( nHandle, '	mso-list-type:hybrid; ' )
	Fwrite( nHandle, '	mso-list-template-ids:-579823852 68550673 68550681 68550683 68550671 68550681 68550683 68550671 68550681 68550683;} ' )
	Fwrite( nHandle, '@list l1:level1 ' )
	Fwrite( nHandle, '	{mso-level-text:"%1\)"; ' )
	Fwrite( nHandle, '	mso-level-tab-stop:none; ' )
	Fwrite( nHandle, '	mso-level-number-position:left; ' )
	Fwrite( nHandle, '	text-indent:-18.0pt;} ' )
	Fwrite( nHandle, 'ol ' )
	Fwrite( nHandle, '	{margin-bottom:0cm;} ' )
	Fwrite( nHandle, 'ul ' )
	Fwrite( nHandle, '	{margin-bottom:0cm;} ' )
	Fwrite( nHandle, '--> ' )
	Fwrite( nHandle, '</style> ' )
	Fwrite( nHandle, '<!--[if gte mso 10]> ' )
	Fwrite( nHandle, '<style> ' )
	Fwrite( nHandle, ' /* Style Definitions */ ' )
	Fwrite( nHandle, ' table.MsoNormalTable ' )
	Fwrite( nHandle, '	{mso-style-name:"Tabela normal"; ' )
	Fwrite( nHandle, '	mso-tstyle-rowband-size:0; ' )
	Fwrite( nHandle, '	mso-tstyle-colband-size:0; ' )
	Fwrite( nHandle, '	mso-style-noshow:yes; ' )
	Fwrite( nHandle, '	mso-style-priority:99; ' )
	Fwrite( nHandle, '	mso-style-qformat:yes; ' )
	Fwrite( nHandle, '	mso-style-parent:""; ' )
	Fwrite( nHandle, '	mso-padding-alt:0cm 5.4pt 0cm 5.4pt; ' )
	Fwrite( nHandle, '	mso-para-margin-top:0cm; ' )
	Fwrite( nHandle, '	mso-para-margin-right:0cm; ' )
	Fwrite( nHandle, '	mso-para-margin-bottom:10.0pt; ' )
	Fwrite( nHandle, '	mso-para-margin-left:0cm; ' )
	Fwrite( nHandle, '	line-height:115%; ' )
	Fwrite( nHandle, '	mso-pagination:widow-orphan; ' )
	Fwrite( nHandle, '	font-size:11.0pt; ' )
	Fwrite( nHandle, '	font-family:"Calibri","sans-serif"; ' )
	Fwrite( nHandle, '	mso-ascii-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-ascii-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-hansi-font-family:Calibri; ' )
	Fwrite( nHandle, '	mso-hansi-theme-font:minor-latin; ' )
	Fwrite( nHandle, '	mso-fareast-language:EN-US;} ' )
	Fwrite( nHandle, '</style> ' )
	Fwrite( nHandle, '<![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:shapedefaults v:ext="edit" spidmax="2050"/> ' )
	Fwrite( nHandle, '</xml><![endif]--><!--[if gte mso 9]><xml> ' )
	Fwrite( nHandle, ' <o:shapelayout v:ext="edit"> ' )
	Fwrite( nHandle, '  <o:idmap v:ext="edit" data="1"/> ' )
	Fwrite( nHandle, ' </o:shapelayout></xml><![endif]--> ' )
	Fwrite( nHandle, '</head> ' )

return( .T. )


/*
Logotipo da Makeni
*/
Static Function htLogoMak( nHandle )

	Local cLogo := GETMV("MV_ENDLOGO")  // junior carvalho

	Fwrite( nHandle, "<p class=MsoNormal><span style='mso-fareast-language:PT-BR;mso-no-proof:yes'><!--[if gte vml 1]><v:shapetype " )
	Fwrite( nHandle, ' id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t" ' )
	Fwrite( nHandle, ' path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f"> ' )
	Fwrite( nHandle, ' <v:stroke joinstyle="miter"/> ' )
	Fwrite( nHandle, ' <v:formulas> ' )
	Fwrite( nHandle, '  <v:f eqn="if lineDrawn pixelLineWidth 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @0 1 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum 0 0 @1"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @2 1 2"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @3 21600 pixelWidth"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @3 21600 pixelHeight"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @0 0 1"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @6 1 2"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @7 21600 pixelWidth"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @8 21600 0"/> ' )
	Fwrite( nHandle, '  <v:f eqn="prod @7 21600 pixelHeight"/> ' )
	Fwrite( nHandle, '  <v:f eqn="sum @10 21600 0"/> ' )
	Fwrite( nHandle, ' </v:formulas> ' )
	Fwrite( nHandle, ' <v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/> ' )
	Fwrite( nHandle, ' <o:lock v:ext="edit" aspectratio="t"/> ' )
	Fwrite( nHandle, '</v:shapetype><v:shape id="Imagem_x0020_0" o:spid="_x0000_i1025" type="#_x0000_t75" ' )
	Fwrite( nHandle, " alt=" + '"LOGO"' + "style='width:81.75pt;height:78pt;visibility:visible; " )
	Fwrite( nHandle, " mso-wrap-style:square'> " )
	Fwrite( nHandle, ' <v:imagedata src="'+cLogo+'" o:title="LOGO"/> ' )
	Fwrite( nHandle, '</v:shape><![endif]--><![if !vml]><img width=250 height=71 ' )
	Fwrite( nHandle, 'src="'+cLogo+'" alt=LOGO v:shapes="Imagem_x0020_0"><![endif]></span></p> ' )

Return( .T. )


/*
Itens do Pedido
*/
Static Function htItens( nHandle, lConf )
	Local _nIpi := 0
	Local _nQtd := 0
	Local _nPrc := 0

	Default lConf := .F.

	Fwrite( nHandle, '<div class=Section1> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=725 ' )
	Fwrite( nHandle, " style='width:584.05pt;border-collapse:collapse;border:none;mso-border-alt: " )
	Fwrite( nHandle, ' solid black .5pt;mso-border-themecolor:text1;mso-yfti-tbllook:1184;mso-padding-alt: ' )
	Fwrite( nHandle, " 0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, " <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'> " )
	Fwrite( nHandle, "  <td width=82 valign=top style='width:61.7pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>ITEM</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=227 valign=top style='width:210.5pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>PRODUTO</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>QUANTIDADE/UN</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>MOEDA</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>Pre�o Unit�rio NET</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=47 valign=top style='width:35.45pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'>IPI</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, "  <td width=94 valign=top style='width:70.85pt;border:solid black 1.0pt; " )
	Fwrite( nHandle, '  mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; ' )
	Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
	Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
	Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
	Fwrite( nHandle, "  normal'><span class=GramE>DT.</span>ENTREGA</p> " )
	Fwrite( nHandle, '  </td> ' )
	Fwrite( nHandle, ' </tr> ' )

	Do While .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial( "SC6" ) .and.;
			SC6->C6_NUM == SC5->C5_NUM
		_nIpi := 0
		_nQtd := 0
		SB1->( dbSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
		if SF4->( dbSeek( xFilial( "SF4" ) + SC6->C6_TES ) ) .and. SF4->F4_IPI == "S"
			_nIpi := SB1->B1_IPI
		endif

		SC9->( dbSeek( xFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM ) )
		DO WHILE .not. SC9->( Eof() ) .and. SC9->C9_FILIAL == xFilial( "SC9" ) .and.;
				SC9->C9_PEDIDO == SC6->C6_NUM .and. SC9->C9_ITEM == SC6->C6_ITEM
			if empty( SC9->C9_NFISCAL )
				_nQtd := SC9->C9_QTDLIB
			endif
			SC9->( dbSkip() )
		ENDDO

		If Empty( _nQtd ) .and. lConf
			_nQtd := SC6->C6_QTDVEN
		Endif

		Fwrite( nHandle, ' ' )
		Fwrite( nHandle, " <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'> " )
		Fwrite( nHandle, "  <td width=82 valign=top style='width:61.7pt;border:solid black 1.0pt; " )
		Fwrite( nHandle, '  mso-border-themecolor:text1;border-top:none;mso-border-top-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-top-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>" + SC6->C6_PRODUTO + "</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=227 valign=top style='width:210.5pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+SB1->B1_DESC+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=123 valign=top style='width:92.15pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nQtd,"@E 999,999,999.99" )+" "+SC6->C6_UM+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=66 valign=top style='width:49.6pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, "  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; " )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+verMoeda( SC6->C6_XMOEDA )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		if SC6->C6_XMOEDA == 1
			_nPrc := IIF(SC6->C6_XVLRINF > 0,SC6->C6_XVLRINF,SC6->C6_XPRUNIT)  //SC6->C6_PRCVEN
		else
			//---------------------------------------------
			//Alterado em 16/01/18 por Marcos Andrade
			//Substituir o campo C6_XPRCMOE por C6_XPRUNIT
			//---------------------------------------------
			//_nPrc := SC6->C6_XPRCMOE
			_nPrc := IIF(SC6->C6_XVLRINF > 0,SC6->C6_XVLRINF,SC6->C6_XPRUNIT)
		endif

		Fwrite( nHandle, "  <td width=85 valign=top style='width:63.8pt;border-top:none;border-left:none; " )
		Fwrite( nHandle, '  border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align:right;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nPrc,"@E 999,999,999.999" )+" "+SC6->C6_UM+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=47 valign=top style='width:35.45pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+Transf( _nIpi,"@E 99.99" )+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, "  <td width=94 valign=top style='width:70.85pt;border-top:none;border-left: " )
		Fwrite( nHandle, '  none;border-bottom:solid black 1.0pt;mso-border-bottom-themecolor:text1; ' )
		Fwrite( nHandle, '  border-right:solid black 1.0pt;mso-border-right-themecolor:text1;mso-border-top-alt: ' )
		Fwrite( nHandle, '  solid black .5pt;mso-border-top-themecolor:text1;mso-border-left-alt:solid black .5pt; ' )
		Fwrite( nHandle, '  mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: ' )
		Fwrite( nHandle, "  text1;padding:0cm 5.4pt 0cm 5.4pt'> " )
		Fwrite( nHandle, "  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: " )
		Fwrite( nHandle, "  normal'>"+dtoc(SC6->C6_ENTREG)+"</p> " )
		Fwrite( nHandle, '  </td> ' )

		Fwrite( nHandle, ' </tr> ' )


		SC6->( dbSkip() )

	EndDo

	Fwrite( nHandle, '</table> ' )
	Fwrite( nHandle, '<p class=MsoNormal><o:p>&nbsp;</o:p></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )

Return( .T. )


/*
Informa��es Gerais do final do Pedido
*/
Static Function htInforma( nHandle )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>Informa��es " )
	Fwrite( nHandle, 'Gerais:<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:"+ '"Arial","sans-serif"' + "'>Vide " )
	Fwrite( nHandle, 'Termo de Informa��es Comerciais abaixo.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>OBSERVA��ES:<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>1) O " )
	Fwrite( nHandle, 'efetivo embarque fica sujeito ainda, as limita��es das linhas de cr�dito e / ou ' )
	Fwrite( nHandle, 'impedimento de for�a maior;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>2) O " )
	Fwrite( nHandle, 'faturamento ocorrer� em Reais (R$), utilizando-se a taxa de d�lar de venda ' )
	Fwrite( nHandle, 'comercial (PTAX) publicada na Gazeta Mercantil, na data efetiva do faturamento;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>3) " )
	Fwrite( nHandle, 'Quando a negocia��o ocorrer em reais, desconsiderar a informa��o acima;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>4) " )
	Fwrite( nHandle, 'Esta proposta comercial � valida por 48 horas;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>5) " )
	Fwrite( nHandle, 'Entrega ser� realizada em at� 48 horas, ap�s a confirma��o do pedido pelo ' )
	Fwrite( nHandle, 'cliente;<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>6) " )
	Fwrite( nHandle, 'Pedidos com entregas programadas, superiores a 5 dias da data de confirma��o ' )
	Fwrite( nHandle, 'estar�o sujeitos a reajustes de pre�os de acordo com o fabricante ou novas ' )
	Fwrite( nHandle, 'condi��es de mercado.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>Sem " )
	Fwrite( nHandle, 'mais para o momento, nos colocamos a sua inteira disposi��o para maiores ' )
	Fwrite( nHandle, 'esclarecimentos.<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
	Fwrite( nHandle, "style='font-size:10.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'>Atenciosamente,<o:p></o:p></span></p> " )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '</div> ' )
Return( .T. )


Static Function htTermo( nHandle )

	Fwrite( nHandle, '<div class=Section1> ' )

	Fwrite( nHandle, "<h1 align=center style='text-align:center'><span style='font-size:14.0pt;font-family:" +;
		'"Arial","sans-serif"' + "'>TERMOS E CONDI��ES GERAIS DE VENDA - IMCD BRASIL COM�RCIO E IND�STRIA DE PRODUTOS QU�MICOS LTDA </span></h1> " )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;text-align: " )
	Fwrite( nHandle, "justify'><span style='font-family:" + '"Arial","sans-serif"' + "'> " )
	Fwrite( nHandle, ' Artigo 1	GERAL ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 1.1	Defini��es: ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Acordo: 	qualquer acordo e/ou ato legal entre a IMCD e o Comprador quanto � compra de mercadorias da IMCD pelo Comprador. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' IMCD:	IMCD Brasil Com�rcio e Ind�stria de Produtos Qu�micos Ltda., com sede na cidade de Diadema, estado de S�o Paulo, � Avenida Presidente Juscelino, no. 578, Piraporinha, CEP 09950-370. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' O Comprador:	qualquer pessoa f�sica ou jur�dica que deseje firmar um acordo, que firme um acordo ou que j� tenha firmado um Acordo com a IMCD, bem como qualquer pessoa f�sica ou jur�dica para a qual a IMCD forne�a ou j� tenha fornecido seus produtos.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Termos e Condi��es: 	estes termos e condi��es gerais de venda da IMCD. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 1.2	Exceto quando expressamente acordado de modo contr�rio por escrito, estes Termos e Condi��es se aplicar�o a todas as ofertas e cota��es oriundas da IMCD a todo e qualquer Acordo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 1.3	Desist�ncias, aditivos e modifica��es e qualquer ren�ncia quanto a estes Termos e Condi��es somente s�o v�lidos se forem expressamente acordados por escrito pela IMCD.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 1.4	A aplica��o de termos e condi��es gerais utilizados pelo Comprador e quaisquer outros termos e condi��es gerais est�o expressamente rejeitados. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 1.5	O texto do Acordo prevalecer� sobre estes Termos e Condi��es caso exista um conflito. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 2	OFERTAS E ACORDOS ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 2.1	Todas as ofertas, cota��es e propostas de pre�o da IMCD estar�o sempre sujeitas a contrato e podem, a menos que proibido por lei, ser alteradas ou revogadas pela IMCD a qualquer momento, independentemente de conterem um per�odo para aceita��o.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 2.2	Suplementos, promessas e mudan�as verbais ser�o vinculantes somente se tiverem sido feitos por pessoal IMCD autorizado. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 2.3	Amostras e modelos apresentados ou fornecidos servir�o somente como indica��es, sem que os produtos devam estar em conformidade com aquelas amostras e modelos. Varia��es secund�rias quanto a tamanho, peso, n�mero, cor e outras propriedades declaradas n�o ser�o consideradas defeito. A pr�tica comercial determinar� se as altera��es s�o secund�rias.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 2.4	A IMCD se reserva ao direito, antes de iniciar ou dar continuidade a suas atividades, e a qualquer tempo, de exigir uma garantia do Comprador para o cumprimento de qualquer uma de suas obriga��es sob qualquer Acordo. A garantia ser� fornecida do modo estipulado pela IMCD a seu exclusivo crit�rio. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 2.5	Se o Comprador n�o houver fornecido a garantia dentro do prazo de 14 dias ap�s a solicita��o estipulada pela IMCD, toda a quantia devida pelo Comprador � IMCD dever� ser quitada imediatamente, sem a obrigatoriedade de emiss�o de aviso de cobran�a. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 3	ENTREGAS ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.1	Salvo disposi��o em contr�rio acordada por escrito, a entrega de mercadoria ficar� � disposi��o do Comprador no local convencionado e no prazo estabelecido (transa��o do tipo �Ex Works�, de acordo com a vers�o mais recente dos Incoterms, publicados pela C�mara de Com�rcio Internacional). ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.2	A entrega ocorrer� em local definido de acordo com a vers�o mais recente dos Incoterms, os quais prevalecer�o no �mbito de um conflito entre estes Termos e Condi��es e os Incoterms aplic�veis. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.3	O risco vinculado � mercadoria comprada passar� ao Comprador quando de sua entrega, de acordo com os termos de entrega especificados no Artigo 3.1 ou quaisquer outros termos de entrega que forem acordados conforme o Artigo 3.1. Para entregas do tipo �Ex Works�, o prazo de entrega � aquele do momento em que a IMCD notifica o Comprador de que a mercadoria est� pronta para retirada. Para entregas de acordo com quaisquer outros termos de entrega, o prazo de entrega � aquele em que a mercadoria comprada chega ao local de entrega, mesmo que o Comprador n�o aceite a entrega.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.4	Salvo disposi��o em contr�rio acordada por escrito, o prazo de entrega especificado e concordado n�o ser� um prazo final. O simples fato de a IMCD exceder o prazo de entrega acordado n�o constituir� descumprimento de contrato, n�o resultar� em mora ou outra obriga��o ao Comprador e n�o dar� direito ao Comprador a rescindir o Acordo ou qualquer outra provid�ncia para descumprimento contratual. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.5	Se um prazo de entrega n�o houver sido claramente acordado, um prazo de entrega razo�vel ser� aplicado. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.6	A IMCD poder�, em todo e a qualquer momento, entregar em consigna��o, e sempre poder� emitir nota fiscal separadamente para tais atividades parciais. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.7	Se o Comprador n�o aceitar a entrega, ou em caso de entrega do tipo �Ex Works� a mercadoria n�o for retirada em at� sete dias depois da entrega ou do modo estipulado pela IMCD, o Comprador estar� em infra��o quanto ao Acordo, sem que uma notifica��o de infra��o seja necess�ria, e a IMCD poder� emitir nota fiscal e receber o pre�o acordado. A IMCD poder�, ent�o, sem preju�zo de seus outros direitos sob a lei, estes Termos e Condi��es ou o Acordo, armazenar a mercadoria sob responsabilidade e risco do Comprador. Todos os custos resultantes deste ocorrido, incluindo, mas n�o limitados a, impostos, arrecada��es, pr�mios de seguro, taxas, obriga��es e cobran�as ser�o de responsabilidade do Comprador.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 3.8	Se uma situa��o prevista no Artigo 3.7 surgir, e, apesar de dado um prazo razo�vel pela IMCD, o Comprador ainda assim n�o tenha retirado a mercadoria ou n�o consiga retir�-la em tempo e/ou adequadamente, a IMCD ficar�, sem preju�zo de seus outros direitos sob a lei, estes Termos e Condi��es e/ou o Acordo, livre de todas as suas obriga��es e poder� reter o pre�o de compra (caso tenha sido pago) como compensa��o por custos de armazenamento incorridos e contra qualquer perda de valor a que a mercadoria tenha sofrido desde sua entrega. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 4	PRE�OS ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 4.1	Salvo disposi��o em contr�rio acordada por escrito, todos os pre�os ficar�o isentos de impostos sobre vendas, os custos de transporte e/ou o envio de produtos, outros custos incorridos quanto � entrega, taxas governamentais e/ou impostos devidos. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 4.2	A IMCD poder�, em todo e a qualquer momento, por notifica��o por escrito ao Comprador, alterar seus pre�os, sob a condi��o de que os pre�os que j� houverem sido acordados possam ser alterados somente se os fatores determinantes de custo em que os pre�os s�o baseados forem alterados entre o firmamento do acordo e a entrega. Tais ajustes de pre�o n�o permitir�o que o Comprador rescinda o contrato. Tais fatores determinantes de custo incluem, sem se limitar a, pre�o de mat�ria-prima, custo de m�o de obra, custo com previd�ncia social, custos, impostos (incluindo impostos de vendas e outras taxas governamentais), impostos de importa��o e exporta��o e taxas de c�mbio. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 5	EMBALAGENS E EQUIPAMENTO DE TRANSPORTE ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 5.1	Salvo disposi��o em contr�rio, embalagens retorn�veis fornecidas pela IMCD permanecer�o de propriedade da IMCD e devem ser devolvidas � IMCD em perfeito estado ap�s seu uso. Se a embalagem retorn�vel n�o for devolvida em perfeito estado, a IMCD n�o mais ser� obrigada a recolher a embalagem retorn�vel, e a nota fiscal da embalagem original emitida para o frete ser� convertida em venda efetiva e cobrada do Comprador.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 5.2	O carregamento ou abastecimento do equipamento de transporte e/ou da embalagem disponibilizada pelo Comprador acontecer� sob responsabilidade e risco do Comprador. Entretanto, caso a IMCD seja respons�vel, as disposi��es do Artigo 8 destes Termos e Condi��es ser�o ent�o inteiramente aplic�veis. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 5.3	A IMCD se reserva ao direito de se recusar a carregar equipamento e/ou abastecer embalagem caso n�o sejam verificadas as condi��es m�nimas de seguran�a estabelecidas periodicamente pela IMCD. Neste caso, a IMCD n�o ser� respons�vel por nenhum custo (incluindo, mas sem limita��o a, os custos determinados pelo Artigo 3.7) decorrente de um poss�vel atraso. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 6	DEVOLU��ES E RECLAMA��ES ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.1.	Salvo disposi��o em contr�rio por lei, a IMCD n�o ficar� obrigada, sem consentimento por escrito de sua parte, a aceitar devolu��es do Comprador. Se produtos forem devolvidos sem aprova��o por escrito da IMCD, seu envio e armazenamento ap�s a devolu��o ser�o de risco e despesa do Comprador. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.2.	Salvo disposi��o em contr�rio por lei, o risco de produtos devolvidos continuar� de responsabilidade do Comprador at� que a IMCD aceite a devolu��o e os produtos devolvidos por escrito, aceita��o esta � qual a IMCD poder� atribuir condi��es.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.3.	O Comprador ser� respons�vel por verificar, ou fazer com que algu�m verifique, a conformidade dos produtos durante sua entrega. Reclama��es devem ser feitas por escrito dentro de 14 dias a contar da data de entrega, declarando-se as raz�es para a queixa e. Caso este procedimento n�o seja cumprido, o Comprador ser� considerado como tendo que ter aceitado a quantidade e a qualidade dos produtos e perder� qualquer reivindica��o contra a IMCD quanto aos defeitos nos produtos fornecidos, de acordo com o estipulado no Artigo 7 em rela��o �s garantias. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.4.	Reclama��es sobre produtos que j� tiverem sido tratados e/ou processados de qualquer forma ap�s a entrega n�o ser�o aceitas. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.5.	Registrar uma reclama��o n�o exime o Comprador de suas obriga��es de pagamento. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.6.	Salvo disposi��o em contr�rio por lei, se uma reclama��o for registrada em tempo e de acordo com estes Termos e Condi��es, e a IMCD for da opini�o de que a queixa � justific�vel, a IMCD ter� a liberdade de escolher entre entregar o que ficou faltando ou entregar novamente os produtos considerados imperfeitos sem cobran�a, ou assegurar um desconto em seu pre�o. Ao agir em um dos modos descritos, a IMCD ter� inteiramente dispensado sua obriga��o de garantia sob o Artigo 7. Os produtos substitu�dos se tornar�o propriedade da IMCD.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 6.7.	Em qualquer caso, mas sem se limitar ou derrogar as disposi��es do Artigo 6.3, o Comprador ter� uma reclama��o contra a IMCD sob este Artigo 6 quanto aos defeitos nos produtos fornecidos por um per�odo m�ximo de tr�s meses a contar da data de entrega.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 7		GARANTIA ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' A IMCD garante ao Comprador que os produtos vendidos ao Comprador estar�o, no momento de entrega, em conformidade com as especifica��es fornecidas pela IMCD ao Comprador quanto a tais produtos. A IMCD n�o faz nenhuma garantia expressa ou impl�cita quanto � adequa��o de mercado ou aptid�o para qualquer finalidade espec�fica dos produtos. Esta garantia n�o ser� v�lida caso o Comprador deixe de cumprir suas obriga��es de acordo com o Acordo e/ou estes Termos e Condi��es. Recorrer � garantia n�o exime o Comprador de suas obriga��es com o Acordo e/ou estes Termos e Condi��es. No obstante qualquer disposi��o em contr�rio contida nestes Termos e Condi��es, em caso de viola��o da garantia dada ao Comprador nos termos do Artigo 7, a �nica a��o cab�vel ao Comprador � um pedido de desempenho espec�fico pela IMCD de suas obriga��es sob esta garantia. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 8		RESPONSABILIDADES ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.1.	Salvo disposi��o em contr�rio por lei, a IMCD n�o ser� respons�vel por quaisquer danos sofridos pelo Comprador, independentemente de este dano ser resultante de falha da IMCD ao cumprir suas obriga��es sob os termos do Acordo e/ou estes Termos e Condi��es (incluindo a obriga��o de garantia do Artigo 7), ou de algum ato e/ou omiss�o por parte da pr�pria IMCD e/ou por terceiros agindo por instru��o da IMCD, a menos que o Comprador prove que o dano seja resultado de imprud�ncia intencional e proposital por, exclusivamente, algum diretor da IMCD.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.2.	Salvo disposi��o em contr�rio por lei, a IMCD n�o ser� respons�vel por (i) perda indireta, especial ou consequente de nenhum tipo, (ii) perda de receita ou de lucro, ou (iii) perda sofrida pelo Comprador ou por terceiro como consequ�ncia de a IMCD, ou uma pessoa respons�vel perante a lei, ter cometido uma viola��o n�o-material do Acordo.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.3.	A IMCD n�o ser� respons�vel por dano ou perda, de qualquer natureza e forma, que surja ou seja incorrida ap�s os produtos entregues pela IMCD tenham sido tratados e/ou processados. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.4.	A IMCD n�o garante a integridade nem a precis�o das informa��es recebidas pela IMCD de seu pr�prio fornecedor e n�o ser� respons�vel por nenhum dano � de qualquer natureza e em qualquer forma � incorrido como resultado da incompletude ou imprecis�o destas informa��es. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.5.	A responsabilidade da IMCD estar�, em qualquer evento, sempre limitada por evento, com uma s�rie de eventos conectados contabilizando um �nico evento, para a quantia que � paga sob a ap�lice de seguro de responsabilidade civil de neg�cios da IMCD no caso em quest�o. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.6.	O Comprador deve compensar a IMCD por, e a indeniz�-la contra, todas as reivindica��es de terceiros, por quaisquer motivos, em rela��o � compensa��o por quaisquer danos, custos, juros e/ou perdas que surjam em rela��o aos produtos entregues pela IMCD ao Comprador, a menos que, e na medida em que, o Comprador demonstre que a reclama��o perten�a exclusivamente � al�ada de responsabilidade da IMCD. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.7.	As disposi��es deste Artigo 8 se aplicar�o tamb�m a favor de todas as pessoas f�sicas e jur�dicas utilizadas pela IMCD para celebrar este Acordo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.8.	Quaisquer duas ou mais limita��es de responsabilidade estabelecidas nestes Termos e Condi��es ser�o capazes de serem aplicadas aos mesmos fatos, e �s mesmas garantias, indeniza��es, representa��es, viola��es ou causas de a��es e, do mesmo modo, as v�rias limita��es de responsabilidade estipuladas nestes Termos e Condi��es ser�o cumulativas. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 8.9.	Nenhuma reclama��o por dano relacionado a produtos poder� prestar falso testemunho contra a IMCD, assim como tamb�m n�o o far� nenhuma reclama��o a menos que (i) a IMCD tenha sido notificada sobre uma reivindica��o dentro de tr�s meses depois da data de entrega daqueles produtos e (ii) dentro de dois meses depois da data do recibo pela IMCD do aviso acima mencionado, a IMCD tenha sido servida por processos de tribunal iniciais adequados ou procedimentos de arbitragem tenham sido iniciados nos termos do Artigo 16. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 9		CONFORMIDADE COM AS LEIS ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 9.1	O comprador estar� em conformidade com todas as leis aplic�veis, incluindo, mas n�o limitado a, leis antissuborno e anticorrup��o, como a Lei Anticorrup��o brasileira, e leis relacionadas com o controle de exporta��es e regula��es alfandeg�rias, tais como (i) as regras para pa�ses com embargos, (ii) as restri��es sobre a venda de produtos para pa�ses com restri��es ou negados, e (iii) o regime para o controle de exporta��es, transfer�ncias, corretagem e tr�nsito de itens de dupla utiliza��o (dual-use items). O Comprador n�o utilizar�, vender�, transportar� nem transferir� os produtos comprados da IMCD, nem direta nem indiretamente, para ou atrav�s de nenhum pa�s, entidade ou indiv�duo conforme proibi��o sob regulamenta��es nacionais e internacionais.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 9.2	Sem preju�zo ao Artigo 9.1, o Comprador estar� em conformidade com todas as leis e regulamenta��es aplic�veis ao desempenhar suas obriga��es nos termos do Acordo de acordo com o C�digo de Conduta da IMCD. O Comprador confirma ter lido e concordado com o C�digo de Conduta da IMCD, o qual est� dispon�vel para consulta no seguinte website: www.imcdgroup.com.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 9.3	O Comprador providenciar� para que quaisquer terceiros a quem os produtos da IMCD se destinem, seja em sua forma original, intermedi�ria ou como o produto final, recaiam sob as mesmas obriga��es, conforme estipulado neste Artigo 9, que todos os terceiros ao longo da cadeia de fornecimento, bem como at� mesmo o usu�rio final, estejam sob a mesma e exata conformidade. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 9.4	O Comprador concorda em indenizar a IMCD, seus escrit�rios, colaboradores, agentes e representantes de e contra quaisquer danos, perdas, obriga��es, penalidades, custos e gastos, incluindo honor�rios advocat�cios, resultantes de reclama��es, processos, a��es, procedimentos legais, exig�ncias, julgamentos ou acordos que resultem da falta de ades�o do Comprador �s disposi��es deste Artigo 9. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 10	FOR�A MAIOR (DESCUMPRIMENTO N�O IMPUT�VEL) ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 10.1	Caso, por motivo de for�a maior, a IMCD fique impossibilitada de cumprir o Acordo, ou seu desempenho se torne mais dispendioso, a IMCD ter� o direito a, por notifica��o por escrito ao Comprador, suspender o Acordo na �ntegra ou parcialmente pela dura��o da situa��o de for�a maior, ou rescindir o Acordo na �ntegra ou parcialmente sem interven��o judicial e sem que a IMCD seja obrigada a pagar nenhuma compensa��o. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 10.2	O termo �for�a maior� ser� compreendido como qualquer circunst�ncia, tanto prevista quanto imprevista, que permanentemente ou temporariamente impe�a a IMCD de cumprir o Acordo ou que torne a atividade mais dispendiosa. Tais circunst�ncias compreender�o, mas n�o se limitar�o, a incapacidade de pagamento, por quaisquer motivos, greves, excesso de colaboradores doentes, interrup��es na produ��o, problemas de transporte, inc�ndios e outras interrup��es no neg�cio, proibi��es de importa��o, exporta��o e transporte, entregas atrasadas ou com problemas por fornecedores da IMCD, e outros eventos for a do controle da IMCD, tais como inunda��es, tempestades, desastres naturais e/ou nucleares, guerras e/ou amea�as de guerra, mas tamb�m mudan�as na legisla��o e/ou medidas governamentais. Al�m disso, a IMCD pode sempre se valer de for�a maior no caso de inadequa��o dos produtos e/ou pessoas utilizadas pela IMCD cumprir o Acordo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 10.3	Se a IMCD suspender o cumprimento do Acordo de acordo com as disposi��es deste Artigo 10, o Comprador deve, a pedido da IMCD, prorrogar quaisquer cartas de cr�dito previstas pelo Acordo e/ou a seguran�a exigida de acordo com o Artigo 2.4 destes Termos e Condi��es at� a nova data de entrega. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 11    PAGAMENTO ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.1.	Salvo disposi��o em contr�rio por escrito, os pagamentos devem ser realizados dentro de 14 dias da emiss�o da nota fiscal, sem nenhum desconto e/ou compensa��o na moeda especificada na nota fiscal. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.2.	Se o pagamento na �ntegra n�o for realizado dentro do prazo descrito, o Comprador estar� em viola��o do Acordo e, sujeito � taxa de juros legal m�xima prescrita e aplic�vel, ser� respons�vel por (i) uma multa de 2%, e (ii) juros di�rios � taxa de 1% ao m�s, sobre a quantia em aberto a partir da data de notifica��o at� a data de pagamento na �ntegra. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.3.	O Comprador pagar� a IMCD na �ntegra e a indenizar� ante quaisquer e todos os custos, taxas, gastos, perdas, danos e reclama��es (incluindo, mas n�o limitados a, emolumentos), incorridos como resultado do descumprimento por parte do Comprador das obriga��es nos termos deste Acordo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.4.	Sem preju�zo �s disposi��es do Artigo 6.3, as reclama��es acerca de cobran�a somente podem ser feitas dentro do prazo de pagamento. As reclama��es devem ser encaminhadas por escrito. A submiss�o de uma reclama��o n�o suspender� a obriga��o de pagamento do Comprador. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.5.	Quaisquer pagamentos recebidos pelo Comprador periodicamente ser�o usados na seguinte ordem e prioridade: (i) primeiramente, a fim de encerrar quaisquer reivindica��es de indeniza��o as quais a IMCD possa ter de acordo com o Artigo 11.3; (ii) em segundo lugar, amortizar juros que possam ter sido incorridos em favor da IMCD nos termos do Artigo 11.2; e (iii) em terceiro lugar, encerrar quaisquer quantias em aberto devidas � IMCD quanto aos pre�os do produto, a come�ar pela antiga quantia em aberto mais antiga e principal, independentemente de quaisquer instru��es em contr�rio oriundas do Comprador.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 11.6.	O Comprador ser� incapaz de compensar quaisquer d�vidas com a IMCD contra quaisquer reclama��es do Comprador contra a IMCD. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 12	SUSPENS�O E RESCIS�O ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 12.1	Sem preju�zo �s disposi��es do Artigo 10, e sem preju�zo a quaisquer outras medidas que possam estar dispon�veis � IMCD nos termos da da lei, estes Termos e Condi��es e/ou Acordo, a IMCD pode suspender o cumprimento de suas obriga��es sob os termos deste Acordo inteira ou parcialmente ou recindir o Acordo inteira ou parcialmente de modo extrajudicial por uma notifica��o por escrito, sem que fique obrigada a pagar compensa��o, caso (ou caso a IMCD razoavelmente suspeite que): ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	a) 	o Comprador tenha cometido uma viola��o material do Acordo, e neste aspecto, uma viola��o da obriga��o do Comprador em pagar por produtos pontualmente e na �ntegrathe ser� considerada uma viola��o material do Acordo; ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	b) 	uma ordem de penhora tenha sido deferida contra o Comprador; ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	c) 	o Comprador tenha se tornado incapaz de pagar suas d�vidas na medida em que estas vencem, tenha se tornado insolvente, ou tenha agido com o prop�sito de negocia��o, acordo com credores ou cess�o para o benef�cio de seus credores; ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	d) 	quaisquer a��es tenham sido iniciadas, tomadas ou institu�das contra o Comprador, para que uma ordem de liquida��o ou ordem de liquida��o provis�ria seja feita para tanto, para sua dissolu��o, reorganiza��o ou indica��o de algum administrador societ�rio, fiduci�rio, liquidante, deposit�rio judicial, inventariante, advogado ou profissional semelhante em rela��o ao Comprador ou ao ativo do Comprador; ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	e) 	o Comprador, se pessoa f�sica, tenha morrido; ou ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 	f) 	todo o neg�cio do Comprador, ou uma parte material dele, tenha sido vendido ou dissolvido, ou o Comprador tenha deixado de conduzir todo o neg�cio ou uma parte material dele. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 12.2	Se, de acordo com o Artigo 12.1, a suspenda o cumprimento do Acordo, o Comprador deve, a pedido da IMCD, prorrogar quaisquer cartas de cr�dito prescritas pelo Acordo e/ou seguran�a exigida de acordo com o Artigo 2.4 destes Termos e Condi��es at� a nova data de entrega. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 12.3	Se, de acordo com o Artigo 12.1, a IMCD rescinda o Acordo na �ntegra ou em parte, a IMCD pode reivindicar, como sua propriedade, quaisquer produtos entregues, mas ainda n�o pagos, na sua totalidade sem preju�zo a seus direitos de reclamar por danos. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 12.4	Se alguma das situa��es descritas no Artigo 12.1 surgir, todas as quantias devidas pelo Comprador � IMCD vencer�o e dever�o ser pagas na �ntegra e imediatamente, sem que uma notifica��o de d�bito seja exigida.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 12.5	O Comprador n�o pode suspender o cumprimento de suas obriga��es sob ou em rela��o ao Acordo ou estes Termos e Condi��es sob nenhuma hip�tese. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 13     	RESERVA DE PROPRIEDADE ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.1	Os produtos fornecidos pela IMCD ao Comprador permanecer�o propriedade da IMCD at� que o Comprador tenha pago todas as quantias, incluindo juros e gastos, que deve � IMCD sob ou em rela��o ao Acordo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.2	Antes que o pagamento tenha sido realizado na �ntegra de acordo com o Artigo 13.1, o Comprador n�o ter� o direito de caucionar inteira nem parcialmente os produtos a terceiros. O Comprador tamb�m n�o ter� direito de transferir a propriedade dos produtos, sen�o em conformidade com suas atividades normais ou o uso normal dos produtos. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.3	Antes que o pagamento tenha sido realizado na �ntegra de acordo com o Artigo 13.1, o Comprador manter� os produtos entregues sujeitos a reserve de propriedade com o cuidado devido e como identific�vel propriedade da IMCD e proteger� os produtos contra dano e roubo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.4	Se uma das situa��es descritas no Artigo 12.1 surgir, a IMCD ter� o direito de retirar ela mesma, ou de fazer com que algu�m retire, os produtos que forem sua propriedade, com despesas resultantes sob a responsabilidade do Comprador, do local em que se localizarem. O Comprador cooperar� plenamente, e autoriza a IMCD irrevogavelmente, por este instrumento, se tal situa��o surgir, a adentrar, ou permitir que algu�m adentre, as instala��es em uso pelo Comprador ou para ele. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.5	O Comprador n�o ter� autoriza��o para invocar um direito de reten��o quanto aos custos incorridos em rela��o � estocagem de acordo com o Artigo 13.3, ou para compensar aqueles custos contra o desempenho de suas atividades. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 13.6	Se o Comprador formar um novo produto (parcialmente) a partir de produtos a ele entregues pela IMCD, esta ter� copropriedade e direitos sobre o novo produto em propor��o ao valor do produto processado ou misturado em rela��o ao novo produto. Al�m disso, o Comprador reservar� (parte de) o produto para a IMCD, e esta continuar� sempre propriet�ria de modo igual � sua parcela de copropriedade at� que todas as obriga��es �s quais se refere o Artigo 13.1 tenham sido cumpridas. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 14     PROPRIEDADE INTELECTUAL ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 14.1	O Acordo e estes Termos e Condi��es n�o implicam nenhuma transfer�ncia nem o licenciamento de nenhum direito de propriedade intelectual ao Comprador. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 14.2	O Comprador garante a IMCD, em todo e a qualquer momento, e indeniza a IMCD para que o uso pela IMCD de dados, especifica��es e materiais fornecidos pelo Comprador n�o viole nenhuma regula��o contratual nem infrinja o direito de terceiros. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 15     	IMPROCED�NCIA E CONVERS�O ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Se alguma disposi��o do Acordo ou destes Termos e Condi��es for considerada ou se tornar ilegal, inv�lida, n�o vinculante ou inexequ�vel (em cada caso ou em sua totalidade ou parcialmente) sob quaisquer leis ou jurisdi��es: ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' a) 	aquela disposi��o, quanto � sua ilegalidade, invalidez, falta de efeito vinculante ou inexequibilidade, n�o far� parte do Acordo ou destes Termos e Condi��es, mas a legalidade, a validez, o efeito vinculante e a exequibilidade das restantes disposi��es do Acordo e destes Termos e Condi��es n�os ser�o afetadas; e ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' b) 	uma disposi��o se aplicar� entre a IMCD e o Comprador que seja legal, v�lida, vinculante e exequ�vel de modo t�o semelhante quanto poss�vel em termos de conte�do e prop�sito. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' Artigo 16     	FORO COMPETENTE, DIREITO APLIC�VEL ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 16.1	As leis brasileiras se aplicar�o exclusivamente a todos os Acordos e estes Termos e Condi��es, incluindo este Artigo 16, e a toda obriga��o n�o-contratual que surja de ou em rela��o ao Acordo ou estes Termos e Condi��es. A aplicabilidade da Conven��o das Na��es Unidas sobre Contratos para a Venda Internacional de Mercadorias (CISG, na sigla em ingl�s) fica explicitamente exclu�da. Sujeitos ao Artigo 16.2, todos os lit�gios que surjam em rela��o a este acordo, incluindo os lit�gios quanto � exist�ncia e validez daquele instrumento, ser�o resolvidos por jurisdi��o competente. Para os prop�sitos deste Artigo 16.1, as partes consentem, incondicional e irrevogavelmente, com a jurisdi��o da cidade de S�o Paulo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 16.2	Se a IMCD assim o eleger por aviso escrito, um lit�gio pode ser tratado por arbitragem de acordo com as regras da C�mara de Com�rcio Brasil-Canad� (Centro de Arbitragem e Media��o da C�mara de Com�rcio Brasil-Canad�) (CCBB) em vigor no momento do lit�gio. A este respeito, o seguinte se aplica: ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' a)	A sede, ou o local legal de arbitragem dever� ser o Brasil. Os processos da arbitragem devem ocorrer em S�o Paulo, Brasil. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' b)	O tribunal decidir� de acordo com as regras da lei. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' c)	O n�mero de �rbitros ser� um.  ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' d)	A IMCD e o Comprador devem entrar em acordo quanto ao �rbitro. Na medida em que forem incapazes de se decidir por um �rbitro em um per�odo de 14 dias da data de solicita��o tanto pela IMCD quanto pelo Comprador para tal acordo, a autoridade indicada ser� a CCBB de acordo com suas pr�prias regras. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' e)	A senten�a arbitral ser� definitiva e vinculante para a IMCD e o Comprador e nenhum deles ter� nenhum direito a recorrer de nenhuma senten�a, exceto por apelos de erro expl�cito ou de fraude. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, ' 16.3	Nada neste Artigo 16 impedir� nem a IMCD nem o Comprador de procurar tutela antecipada e/ou urgente de um tribunal de jurisdi��o competente. Para os prop�sitos deste Artigo 16.3, as partes consentem, incondicional e irrevogavelmente, com a jurisdi��o da cidade de S�o Paulo. ' )
	Fwrite( nHandle, '<o:p></o:p></span></p> ' )
	Fwrite( nHandle, '  ' )
	Fwrite( nHandle, ' ' )
	Fwrite( nHandle, '. <o:p></o:p></span></p> ' )
	Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><o:p>&nbsp;</o:p></p> " )
	Fwrite( nHandle, '</div> ' )

Return( .T. )


/*
Retorna o nome do vendedor.
*/
Static Function NomeVend()
	Local cNomVen := space( len( SA3->A3_NOME ) )

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND1 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VENDX2 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND3 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND4 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

	if empty( cNomVen )
		if SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND5 ) )
			cNomVen := SA3->A3_NOME
		endif
	endif

return( cNomVen )


/*
*/

Static Function MemoSUA()
	Local cRet := ""

	SUB->( dbsetorder( 4 ) )
	SUA->( dbsetorder( 1 ) )

	if SUB->( dbSeek( xFilial( "SUB" ) + SC5->C5_NUM ) )

		if SUA->( dbSeek( xFilial( "SUA" ) + SUB->UB_NUM ) )

			cRet := MSMM( SUA->UA_CODOBS, 80 )

		endif

	endif

return( cRet )

/*
*/

Static Function verMoeda( nMoeda )
	Local _cRet := "R$"

	if nMoeda == 1
		_cRet := "R$ "
	elseif nMoeda == 2
		_cRet := "US$"
	elseif nMoeda == 3
		_cRet := "UFI"
	elseif nMoeda == 4
		_cRet := "EUR"
	elseif nMoeda == 5
		_cRet := "YEN"
	elseif nMoeda >= 6
		_cRet := "   "
	endif

Return ( _cRet )


/*
Itens do Pedido
Static Function htItens( nHandle )
Local _nIpi := 0

Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'>Item<span style='mso-spacerun:yes'>�� " )
Fwrite( nHandle, "</span><span style='mso-spacerun:yes'>����������</span>Produto<span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>����������������������� </span><span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>�����</span>Quantidade / UN <span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>��</span><span style='mso-spacerun:yes'>�</span>Moeda<span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>���� </span>Pre�o/UN <span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>������������</span>IPI<span " )
Fwrite( nHandle, "style='mso-spacerun:yes'>������� </span>Dt.Entrega<o:p></o:p></span></p> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:"+ '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, '</div> ' )
Fwrite( nHandle, ' ' )

	Do While .not. SC6->( eof() ) .and. SC6->C6_FILIAL == xFilial( "SC6" ) .and.;
SC6->C6_NUM    == SC5->C5_NUM

_nIpi := 0
SB1->( dbSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
			if SF4->( dbSeek( xFilial( "SF4" ) + SC6->C6_TES ) ) .and.SF4->F4_IPI == "S"
_nIpi := SB1->B1_IPI
		endif

Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
Fwrite( nHandle, "style='font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt'><span " )
Fwrite( nHandle, "lang=EN-US style='font-family:" + '"Arial","sans-serif"' + ";mso-ansi-language:EN-US'>"+SC6->C6_PRODUTO )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>������� </span>"+SB1->B1_DESC )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>� </span>" )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>��</span>"+Transf( SC6->C6_QTDVEN,"@E 999,999,999.99" )+" "+SC6->C6_UM )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>���������� </span>"+verMoeda( SC6->C6_XMOEDA ) )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>�������� </span>"+Transf( SC6->C6_PRCVEN,"@E 999,999,999.999" )+" "+SC6->C6_UM )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>������� </span>"+Transf( _nIpi,"@E 99.99" ) )
Fwrite( nHandle, "<span style='mso-spacerun:yes'>������ </span>"+dtoc(SC6->C6_ENTREG)+"<o:p></o:p></span></p> " )
Fwrite( nHandle, ' ' )

SC6->( dbSkip() )

	EndDo
Fwrite( nHandle, "<div style='mso-element:para-border-div;border:none;border-bottom:solid windowtext 1.5pt; " )
Fwrite( nHandle, "padding:0cm 0cm 1.0pt 0cm'> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, "<p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;border:none; " )
Fwrite( nHandle, "mso-border-bottom-alt:solid windowtext 1.5pt;padding:0cm;mso-padding-alt:0cm 0cm 1.0pt 0cm'><span " )
Fwrite( nHandle, "style='font-size:8.0pt;line-height:115%;font-family:" + '"Arial","sans-serif"' + "'><o:p>&nbsp;</o:p></span></p> " )
Fwrite( nHandle, ' ' )
Fwrite( nHandle, '</div> ' )

Return( .T. )
*/
