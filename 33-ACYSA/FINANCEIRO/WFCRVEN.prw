#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WFCRVEN  บ Autor ณ Amedeo D. P. Filho บ Data ณ  08/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPrograma que gera workflow dos titulos Vencidos             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico SDMO                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ WFCRVEN() Quando Acionado por Schedule     ณ
ณ Caso for Executar Rotina  por usuario		 ณ
ณ Usar --> U_WFTITTVEN()       				 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

User Function WFCRVEN()
	Local aEmpresas	:= {}
	Private oOk := LoadBitmap( GetResources(), "LBOK")
	Private oNo := LoadBitmap( GetResources(), "LBNO")
	Private oWBrowse1
	Private aWBrowse1 := {}
	
	//DbUseArea( .T.,,"SIGAMAT.EMP", "SM0", .T., .F. )
	//DbSetIndex( "SIGAMAT.IND" )

	//Array com as Empresas
	//DbSelectArea( "SM0" )
	//DbSetOrder( 1 )
	//DbGoTop()
	//While !SM0->( EOF() )
	  //	If aScan( aEmpresas, {|x| x[2] == SM0->M0_CODIGO} ) == 0
			Aadd(  aEmpresas, { .F., SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	//	EndIf
	//	dbSkip()
	//Enddo

//	For nX := 1 To Len(aEmpresas)
		U_WFTITTVEN( .f., aEmpresas[nX][02], aEmpresas[nX][03] )
  //	Next nX

Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCTION WFTITTVEN                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function WFTITTVEN(lSched, cEmpresa, cFilEmp)

	Local cHTML		:= ""
	Local cMail		:= ""
	Local cMailTST	:= "richard.branco@fabritech.com.br"
	Local cWhere	:= ""
	Local nDias1 	:= 0
	Local nDias2	:= 0
	Local nDias3	:= 0
	Local nDiaAux	:= 0
	Local oButton1
	Local oButton2
	Private oWBrowse1
	Private aWBrowse1 := {}
	Private oOk := LoadBitmap( GetResources(), "LBOK")
	Private oNo := LoadBitmap( GetResources(), "LBNO")
	Private lTeste	:= .F.                                          
	Static oDlg
	
	Private cSE1	:= ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Abertura do ambiente                                         |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lSched
		PREPARE ENVIRONMENT EMPRESA ( cEmpresa ) FILIAL ( cFilEmp ) MODULO "FIN"
	EndIf

	nDias1 	 := SuperGetMV("SD_WFRDIA1", Nil, 02	)
	nDias2	 := SuperGetMV("SD_WFRDIA2", Nil, 04	)
	nDias3	 := SuperGetMV("SD_WFRDIA3", Nil, 06	)
	//lTeste	 := SuperGetMV("SD_WFTESTE", Nil, .T.	)
	//cMailTST := SuperGetMV("SD_WFMLTST", Nil, "richard.branco@fabritech.com.br")
	
	//For nX := 1 To 3
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Faz a Selecao dos Titulos Com as Datas de Vencimento.        |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//If nX == 1
			nDiaAux	:= nDias1
		//ElseIf nX == 2
		//	nDiaAux	:= nDias2
		//Else
	    //	nDiaAux	:= nDias3
		//EndIf

		MontaQuery( nDiaAux )
		
		If !(cSE1)->(Eof())
			While !(cSE1)->(Eof())
	
				cHTML	:= ""
				
				DbSelectArea("SE1")
				SE1->(DbGoto((cSE1)->RECE1))
			

				If lTeste
					cMail := cMailTST
				Else
					cMail := SA1->A1_EMAIL
				EndIf
				                               
				AAdd(aWBrowse1,{.F.,SE1->E1_CLIENTE,SE1->E1_NOMCLI,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_VALOR,(cSE1)->RECE1})
				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Atualiza Data de Envvio    ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SE1->(DbGoto((cSE1)->RECE1))
				/*
				SE1->(RecLock("SE1",.F.))
					If empty(SE1->E1_XWFDIA1)
						SE1->E1_XWFDIA1	:= Date()
					ElseIf empty(SE1->E1_XWFDIA2)
						SE1->E1_XWFDIA2	:= Date()
					Else
						SE1->E1_XWFDIA3	:= Date()
					EndIf
				SE1->(MsUnlock())
				/*/
				
				(cSE1)->(DbSkip())
	
			Enddo
		
		EndIf
	
		(cSE1)->(dbCloseArea())
	
 

  DEFINE MSDIALOG oDlg TITLE "TITULOS EM ATRASO" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

    fWBrowse1()
    @ 228, 347 BUTTON oButton1 PROMPT "Sair" SIZE 037, 012 OF oDlg ACTION odlg:End() PIXEL
    @ 229, 294 BUTTON oButton2 PROMPT "Enviar Email" SIZE 037, 012 OF oDlg ACTION envmail() PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

   //Next nX
    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//| Finaliza Ambiente                                            |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lSched
		RESET ENVIRONMENT
	Else
		MsgInfo("Processo Finalizado com Sucesso")
	EndIf

Return Nil                                     


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function EnvMail()          

Local cHTML		:= ""

odlg:End()
                                
For i:=1 To Len(aWBrowse1)

	If aWBrowse1[i][1]

		DbSelectArea("SE1")
		SE1->(DbGoto(aWBrowse1[i][7]))
	
		DbSelectarea("SA1")
		SA1->(DbSetorder(1))
		SA1->(DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA))
                
		DbSelectarea("SA3")
		SA3->(DbSetorder(1))
		IF DbSeek(xFilial("SA3") + SE1->E1_VEND1)
			cEmlVnd := SA3->A3_EMAIL
		Else           
			cEmlVnd := ''
		EndIf                                       
		
		If lTeste
			cMail := cMailTST
		Else
			cMail := SA1->A1_EMAIL
		EndIf
		                               
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gera o Arquivo HTML        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cHTML	:= ""

		GERAHTML(  @cHTML )
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Envia o Email do HTML      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SENDMAIL(cHTML, cMail,cEmlVnd )
			
	EndIf
Next i
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQueryบ Autor ณ Amedeo D. P. Filho บ Data ณ  08/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera Query Para selecao dos Titulos Vencidos.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico SDMO                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MontaQuery(nDias)
    dVenct1	:= Date() - 2
    dVenct2	:= Date() - 7
	
	cWhere	:= "% E1.E1_VENCREA <= '"+DtoS(dVenct1)+"' AND E1.E1_VENCREA >= '"+DtoS(dVenct2)+"' %"
	
	cSE1 := GetNextAlias()

	BeginSQL Alias cSE1
		SELECT	R_E_C_N_O_ AS RECE1
		FROM	%Table:SE1% E1
		WHERE	%NotDel%
		AND		E1.E1_FILIAL = %Exp:xFilial("SE1")%
		AND		E1.E1_TIPO IN ('NF','DP')
		AND		E1.E1_SALDO > 0
		AND		%Exp:cWhere%
	EndSQL
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAHTML  บ Autor ณ Amedeo D. P. Filho บ Data ณ  08/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera HTML do WorkFlow                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico SDMO                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GERAHTML(cHTML)
//	cHTML += "      <td width='766' height='93'><div align='center'><img src='LGRL" + cEmpAnt + ".BMP' width='238' height='94' /></div></td>
	
	cHTML := ""
	cHTML += '<style type="text/css"><!--.style3 {	font-size: 16px;	font-weight: bold;}'
	cHTML += '.style4 {font-size: 16px}.style5 {font-size: 36px}--></style><table width="925" border="0">'
	cHTML += ' <tr><td width="269"><p align="left"><img src="LGRL' + cEmpAnt + '.BMP" width="238" height="94" />'
	cHTML += ' </span></td>'
    cHTML += '<td width="270"><span class="style4">Avenida Projecta, 140<br>'
	cHTML += 'Cidade Jd. Satelite,- Guarulhos, SP<br>'
	cHTML += 'CEP: 07222-130</span></td>'
	cHTML += '    <td width="286"><span class="style4">Tel: 11-2482-4900<br>'
	cHTML += 'Fax: 11-2482-4900<br>'
	cHTML += 'Email: acysa@acysa.com.br</span></td>'
	cHTML += '  </tr>'
	cHTML += '</table>'
	cHTML += '<p><strong>____________________________________________________________________________________________________________________</strong></p>'
	cHTML += '<strong>P<span class="style3">rezado senhor(a),<br><br>&nbsp;</br>'
	cHTML += 'Nosso controle de pagamentos acusa, em sua conta, presta&ccedil;&atilde;o vencida h&aacute; '+ALLTRIM(STR(date()-SE1->E1_VENCREA))+' dias, referente ao titulo n '+SE1->E1_NUM+', motivo pelo qual pedimos a V. S.a sua </span></strong><span class="style3">imediata regulariza&ccedil;&atilde;o.<br><br>&nbsp;</br>'
	cHTML += 'Tendo em vista que a emiss&atilde;o deste aviso &eacute; autom&aacute;tico, caso a V. S.a j&aacute; tenha efe-tuado ou pagamento solicitamos desconsidera-lo.<br><br>&nbsp;</br>'
	cHTML += 'Atenciosamente<br>&nbsp;</br>Departameto Financeiro'
   
Return Nil

/*
\ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SENDMAIL บ Autor ณ Amedeo D.P. Filho  บ Data ณ  08/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio do E-Mail da carta de Cobranca.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico SDMO                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SENDMAIL(cCorpo, cMail, cCopia)
	Local cPassword	:= GetMV("MV_RELPSW")
	Local cServer	:= GetMV("MV_RELSERV") 
	Local cAccount	:= GetMV("MV_RELACNT")
	Local cFrom		:= GetMV("MV_RELACNT")
	Local lAuth    	:= GetNewPar("MV_RELAUTH",.F.)
	Local cRootPath	:= GetSrvProfString("StartPath","",GetAdv97())
	Local cCC		:= cCopia
	Local cTo		:= cMail
	Local cSubject	:= "WorkFlow Cobran็a - ACYSA"
	Local cError    := ""
	
	Local lRetAuth	:= .F.
	Local lContinua	:= .T.
	Local lConnect	:= .T.
	Local lEnviado	:= .F.

	xImagem	:= cRootPath + "lgrl" + cEmpAnt + ".bmp"

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
 
	If !lConnect
		ConOut("Aviso", "Nใo foi possํvel autenticar o Usuแrio e Senha para envio do E-Mail.")
		lContinua := .F.
	EndIf

	If GetNewPar("MV_RELAUTH",.F.)
		lRetAuth := MailAuth(cAccount,cPassword)
	Else
	  	lRetAuth := .T.
	EndIf
 
	If !lRetAuth 
  		ConOut("Nao foi possivel autenticar o usuario e senha para envio de e-mail!")
  		lContinua := .F.
 	EndIf

	If lContinua
		SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cSubject Body cCorpo ATTACHMENT xImagem RESULT lEnviado
	EndIf
	
	If !lEnviado
		ConOut("Erro ao enviar e-mail")
	Else
		ConOut("Carta de Cobran็a enviada Com Sucesso")
	EndIf
 
	DISCONNECT SMTP SERVER
 
RETURN

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 


    @ 003, 002 LISTBOX oWBrowse1 Fields HEADER "","Cliente","Nome","Emissao","Vencimento","Valor" SIZE 395, 213 OF oDlg PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      Transform(aWBrowse1[oWBrowse1:nAt,6],"@E 9,999,999.99");
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}

Return