#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

User Function HCIDA018()

	Local _aCores		:= {}
	Local cUserAdmin	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148,000491")
	
	Private cCadastro	:= OEMTOANSI("Pré Cadastro de Projetos")
	Private _cFiltro	:= ""
	Private aRotina		:= {}
	
	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar"		,"AxPesqui"			,0,1})
	Aadd(aRotina,{"Visualizar"		,"u_fHCIDA18(4)"	,0,2})
	Aadd(aRotina,{"Incluir"			,"u_fHCIDA18(3)"	,0,3})
	Aadd(aRotina,{"Aprov.Cad."		,"u_fHCIDA18(2)"	,0,3})
	Aadd(aRotina,{"Viz.Projeto"		,"u_fHCIDA18(1)"	,0,2})
	Aadd(aRotina,{"Legenda"			,"U_fLegZ02"		,0,2})
	aAdd(aRotina,{ "Conhecimento" 	,"MsDocument"		,0,4})
	
	Aadd(_aCores,{'Empty(Z02_NROPRO) .And. Empty(Z02_APROV)','BR_AMARELO'		})	
	Aadd(_aCores,{'Z02_NROPRO == " " .And. Z02_APROV <> " "','BR_VERMELHO'		})
	Aadd(_aCores,{'Z02_NROPRO <> " " .And. Z02_APROV <> " "','BR_VERDE'			})
	
	If !(__cUserID $ cUserAdmin)			
		_cFiltro := "Z02_USER = '"+__cUserId+"'"
		MBrowse(6, 1,22,75,"Z02",,,,,,_aCores,,,,,,,,_cFiltro)						
	Else		
		MBrowse(6, 1,22,75,"Z02",,,,,,_aCores)		
	EndIf
	
Return()

User Function fLegZ02()

	BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE"  		, "Cadastro aprovado."				},;
									{"BR_VERMELHO"		, "Cadastro do projeto rejeitado"	},; 
									{"BR_AMARELO"		, "Cadastro pendente de aprovação"	}}) 
Return(.T.)


User Function fHCIDA18(_nOpc)
	
	Local _aArea	:= GetArea()
	Local _nOpcA	:= 0
	Local _aEncho	:= {}

	Do Case
		Case _nOpc == 1
			dbSelectArea("AD1")
			AD1->(dbSetOrder(1))
			If AD1->(dbSeek(xFilial("AD1") + Z02->Z02_NROPRO))
				AxVisual( 'AD1', AD1->( Recno() ), 2 )
			Else
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Projeto ainda não cadastrado no sistema. Favor verificar com o responsável!"),{"Ok"},2)
			EndIf
		Case _nOpc == 2
			If !Empty(Z02->Z02_NROPRO)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Projeto já cadastrado no sistema Nro. Projeto: " + Z02->Z02_NROPRO + "."),{"Ok"},2)
			Else
				dbSelectArea("AD1")
				AD1->(dbGoBottom())
				_nOpcA := 	AxInclui( "AD1"	, AD1->(Recno()), 3	,,"u__fDA18M"	,,"u_fTOkAD1()",,"u_fWFHstPT()",,,,.T.)
				MBrChgLoop(.F.)
				If _nOpcA == 1
					If RecLock("Z02",.F.)
						Z02->Z02_NROPRO	:= AD1->AD1_NROPOR
						Z02->Z02_DTINIC := AD1->AD1_DTINI
						Z02->Z02_DTFIM	:= AD1->AD1_DTFIM
						Z02->Z02_PROSP	:= AD1->AD1_PROSPE
						Z02->Z02_LOJPRO := AD1->AD1_LOJPRO
						Z02->Z02_CLIENT := AD1->AD1_CODCLI
						Z02->Z02_LOJAC	:= AD1->AD1_LOJCLI
						Z02->Z02_PROJET := AD1->AD1_XPROJE
						Z02->Z02_SUBPRO := AD1->AD1_XSUBPR
						Z02->Z02_SEG 	:= AD1->AD1_XSEG1
						Z02->Z02_SEGDES := AD1->AD1_XDSEG1
						Z02->Z02_OBRA 	:= AD1->AD1_XOBRA
						Z02->Z02_OBRAD 	:= AD1->AD1_XOBRAD
						Z02->Z02_ISENF 	:= AD1->AD1_XISENF
						Z02->Z02_ISENFD := AD1->AD1_XISEFD
						Z02->Z02_OBSCN 	:= AD1->AD1_XOBSCN
						Z02->Z02_DONO 	:= AD1->AD1_XDONO
						Z02->Z02_VLRPRJ := AD1->AD1_VERBA
						Z02->Z02_PRIOR 	:= AD1->AD1_PRIOR
						Z02->Z02_CODCON := AD1->AD1_XCONT
						Z02->Z02_NOMCON := AD1->AD1_XCONTD
						Z02->Z02_APROV	:= __cUserId
						Z02->(MsUnLock())
					EndIf			
				EndIf
			EndIf
			
		Case _nOpc == 3
			aadd(_aEncho,"Z02_PROJET")
			aadd(_aEncho,"Z02_SUBPRO")
			aadd(_aEncho,"Z02_CLIENT")
			aadd(_aEncho,"Z02_LOJAC")
			aadd(_aEncho,"Z02_PROSP")
			aadd(_aEncho,"Z02_LOJPRO")
			aadd(_aEncho,"Z02_VLRPRJ")
			aadd(_aEncho,"Z02_DONO")
			aadd(_aEncho,"Z02_STATUS")
			aadd(_aEncho,"Z02_DTINIC")
			aadd(_aEncho,"Z02_DTFIM")
			aadd(_aEncho,"Z02_SEG")
			aadd(_aEncho,"Z02_SEGDES")
			aadd(_aEncho,"Z02_OBRA")
			aadd(_aEncho,"Z02_OBRAD")
			aadd(_aEncho,"Z02_ISENF")
			aadd(_aEncho,"Z02_ISENFD")
			aadd(_aEncho,"Z02_OBSCN")
			aadd(_aEncho,"Z02_OBS")
			aadd(_aEncho,"Z02_PRIOR")
			aadd(_aEncho,"Z02_CODCON")
			aadd(_aEncho,"Z02_NOMCON")
			aadd(_aEncho,"Z02_NCONT")
			aadd(_aEncho,"Z02_TCONT")
			aadd(_aEncho,"Z02_CCONT")			
			aadd(_aEncho,"Z02_NCONT2")
			aadd(_aEncho,"Z02_TCONT2")
			aadd(_aEncho,"Z02_CCONT2")
			aadd(_aEncho,"Z02_NCONT3")
			aadd(_aEncho,"Z02_TCONT3")
			aadd(_aEncho,"Z02_CCONT3")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxInclui( "Z02", Z02->(Recno()), 3,_aEncho,,,,,,,,,.T.)
			MBrChgLoop(.F.)
			If _nOpcA == 1
				If RecLock("Z02",.F.)
					Z02->Z02_USER	:= __cUserID
					Z02->(MsUnLock())
				EndIf 
				_fEnvEAp()
			EndIf
			
		Case _nOpc == 4
		
			aadd(_aEncho,"Z02_PROJET")
			aadd(_aEncho,"Z02_SUBPRO")
			aadd(_aEncho,"Z02_CLIENT")
			aadd(_aEncho,"Z02_LOJAC")
			aadd(_aEncho,"Z02_PROSP")
			aadd(_aEncho,"Z02_LOJPRO")
			aadd(_aEncho,"Z02_VLRPRJ")
			aadd(_aEncho,"Z02_DONO")
			aadd(_aEncho,"Z02_STATUS")
			aadd(_aEncho,"Z02_DTINIC")
			aadd(_aEncho,"Z02_DTFIM")
			aadd(_aEncho,"Z02_SEG")
			aadd(_aEncho,"Z02_SEGDES")
			aadd(_aEncho,"Z02_OBRA")
			aadd(_aEncho,"Z02_OBRAD")
			aadd(_aEncho,"Z02_ISENF")
			aadd(_aEncho,"Z02_ISENFD")
			aadd(_aEncho,"Z02_OBSCN")
			aadd(_aEncho,"Z02_OBS")
			aadd(_aEncho,"Z02_PRIOR")			
			aadd(_aEncho,"Z02_CODCON")
			aadd(_aEncho,"Z02_NOMCON")
			aadd(_aEncho,"Z02_NCONT")
			aadd(_aEncho,"Z02_TCONT")
			aadd(_aEncho,"Z02_CCONT")			
			aadd(_aEncho,"Z02_NCONT2")
			aadd(_aEncho,"Z02_TCONT2")
			aadd(_aEncho,"Z02_CCONT2")
			aadd(_aEncho,"Z02_NCONT3")
			aadd(_aEncho,"Z02_TCONT3")
			aadd(_aEncho,"Z02_CCONT3")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxVISUAL( "Z02", Z02->(Recno()), 2,_aEncho,,,,,,,,,.T.)
		
		Case _nOpc == 4
		
			aadd(_aEncho,"Z02_PROJET")
			aadd(_aEncho,"Z02_SUBPRO")
			aadd(_aEncho,"Z02_CLIENT")
			aadd(_aEncho,"Z02_LOJAC")
			aadd(_aEncho,"Z02_PROSP")
			aadd(_aEncho,"Z02_LOJPRO")
			aadd(_aEncho,"Z02_VLRPRJ")
			aadd(_aEncho,"Z02_DONO")
			aadd(_aEncho,"Z02_STATUS")
			aadd(_aEncho,"Z02_DTINIC")
			aadd(_aEncho,"Z02_DTFIM")
			aadd(_aEncho,"Z02_SEG")
			aadd(_aEncho,"Z02_SEGDES")
			aadd(_aEncho,"Z02_OBRA")
			aadd(_aEncho,"Z02_OBRAD")
			aadd(_aEncho,"Z02_ISENF")
			aadd(_aEncho,"Z02_ISENFD")
			aadd(_aEncho,"Z02_OBSCN")
			aadd(_aEncho,"Z02_OBS")
			aadd(_aEncho,"Z02_PRIOR")			
			aadd(_aEncho,"Z02_CODCON")
			aadd(_aEncho,"Z02_NOMCON")
			aadd(_aEncho,"Z02_NCONT")
			aadd(_aEncho,"Z02_TCONT")
			aadd(_aEncho,"Z02_CCONT")			
			aadd(_aEncho,"Z02_NCONT2")
			aadd(_aEncho,"Z02_TCONT2")
			aadd(_aEncho,"Z02_CCONT2")
			aadd(_aEncho,"Z02_NCONT3")
			aadd(_aEncho,"Z02_TCONT3")
			aadd(_aEncho,"Z02_CCONT3")
			Aadd(_aEncho,"NOUSER")
			_nOpcA := AxAltera( "Z02", Z02->(Recno()), 4,_aEncho,,,,,,,,,.T.)

	EndCase
	
	RestArea(_aArea)

Return()

User Function fTOkAD1()

	Local _cObs	:= ""
 	
 	_cObs := "===========================================" +CRLF
	_cObs += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
	_cObs += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF
	_cObs += AllTrim(M->AD1_XOBSDI)+CRLF
	_cObs += "===========================================" +CRLF
	_cObs += AllTrim(AD1->AD1_XHISTO)
	M->AD1_XHISTO	:= _cObs
	
Return(.T.)

User Function fWFHstPT()

	Local _cMsg			:= ""
	Local _cAssunto		:= "Aviso de Projeto/Oportunidade - Nº " + AD1->AD1_NROPOR
	Local _cPara		:= ""
	Local _cCopy		:= "bzechetti@totalitsolutions.com.br"
	Local _nI			:= 0
	Local _aEmailHst	:= Separa(GetMV("ES_WFHSTPT",,"000076,000009,000254,000256,000515,000057,000148"),",")
		
	Begin Transaction 

		IF !EMPTY(M->AD1_XOBSDI)
		
			For _nI	:= 1 To Len(_aEmailHst)
			
				_cMsg	:= '<html>'+CRLF
				_cMsg	+= '	<head>'+CRLF
				_cMsg	+= '		<title>Projetos</title>'+CRLF
				_cMsg	+= '	</head> '+CRLF
				_cMsg	+= '	<body> '+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000000"><B><center>Projeto/Oportunidade - ' + Alltrim(AD1->AD1_NROPOR) + "/Rev." + AD1->AD1_REVISA  + '</center></B></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Prezado(a) ' + UsrFullName(_aEmailHst[_nI]) +',</p></FONT>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Foi realizado a atualização do histórico do Projeto/Oportunidade: </p></FONT>'+CRLF 
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Projeto: ' + AD1->AD1_XPROJE + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Sub Projeto: ' + AD1->AD1_XSUBPR + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Descrição do projeto: ' + AD1->AD1_XDESCP + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
//				_cMsg	+= '		<FONT COLOR = "#000000"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + AD1->AD1_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Dono: ' + AD1->AD1_XDONO + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Histórico: ' + ALLTRIM(AD1->AD1_XHISTO) + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Grato(a).</p></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '	</body>'+CRLF
				_cMsg	+= '</html>'+CRLF
				
				_cPara		:= AllTrim(UsrRetMail(_aEmailHst[_nI]))
				
				MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
				
				If RecLock("AD1",.f.)
					AD1->AD1_XOBSDI	:= ""
					AD1->(MsUnLock())
				EndIf
			Next _nI	
			
			If !Empty(AD1->AD1_VEND)
		
				_cMsg	:= '<html>'+CRLF
				_cMsg	+= '	<head>'+CRLF
				_cMsg	+= '		<title>Projetos</title>'+CRLF
				_cMsg	+= '	</head> '+CRLF
				_cMsg	+= '	<body> '+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<FONT SIZE = "5" COLOR = "#000000"><B><center>Projeto/Oportunidade - ' + Alltrim(AD1->AD1_NROPOR) + "/Rev." + AD1->AD1_REVISA  + '</center></B></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Prezado(a) ' + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + AD1->AD1_VEND,1)) +',</p></FONT>'+CRLF
				_cMsg	+= '		<p>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Foi realizado a atualização do histórico do Projeto/Oportunidade: </p></FONT>'+CRLF 
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Projeto: ' + AD1->AD1_XPROJE + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Sub Projeto: ' + AD1->AD1_XSUBPR + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Descrição do projeto: ' + AD1->AD1_XDESCP + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + AD1->AD1_CODCLI + AD1->AD1_LOJCLI,"A1_NOME") + '.</p></FONT>'+CRLF
//				_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + AD1->AD1_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Dono: ' + AD1->AD1_XDONO + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Histórico: ' + ALLTRIM(AD1->AD1_XHISTO) + '.</p></FONT>'+CRLF
				_cMsg	+= '		<FONT COLOR = "#000000"><p>Grato(a).</p></FONT>'+CRLF
				_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
				_cMsg	+= '	</body>'+CRLF
				_cMsg	+= '</html>'+CRLF
				
				_cPara		:= SA3->(GetAdvFVal("SA3","A3_EMAIL",xFilial("SA3") + AD1->AD1_VEND,1))
				
				MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
				
			EndIf
		EndIf

	End Transaction 

Return()


User Function _fDA18M()

	Local _cObs		:= ""
	
	_cObs := "===========================================" +CRLF
	_cObs += "[ PRÉ CADASTRO DE PROJETOS ]"+CRLF
	_cObs += "[ Usuario - " + UsrFullName(Z02->Z02_USER) + " ]" +CRLF
	_cObs += AllTrim(Z02->Z02_OBS)+CRLF
	_cObs += "===========================================" +CRLF

//	M->AD1_VEND		:= SU5->(GetAdvFVal("SU5","U5_VEND",xFilial("SU5") + Z02->Z02_CODCON,1))
	M->AD1_VEND		:= Z02->Z02_VEND
	M->AD1_DTINI	:= Z02->Z02_DTINIC
	M->AD1_DTFIM	:= Z02->Z02_DTFIM
	M->AD1_PROSPE	:= Z02->Z02_PROSP
	M->AD1_LOJPRO	:= Z02->Z02_LOJPRO
	M->AD1_CODCLI	:= Z02->Z02_CLIENT
	M->AD1_LOJCLI	:= Z02->Z02_LOJAC
	M->AD1_XPROJE	:= Z02->Z02_PROJET
	M->AD1_XSUBPR	:= Z02->Z02_SUBPRO
	M->AD1_XSEG1	:= Z02->Z02_SEG
	M->AD1_XDSEG1	:= Z02->Z02_SEGDES
	M->AD1_XOBRA	:= Z02->Z02_OBRA
	M->AD1_XOBRAD	:= Z02->Z02_OBRAD
	M->AD1_XISENF	:= Z02->Z02_ISENF
	M->AD1_XISEFD	:= Z02->Z02_ISENFD
	M->AD1_XOBSCN	:= Z02->Z02_OBSCN
	M->AD1_XDONO	:= Z02->Z02_DONO
	M->AD1_VERBA	:= Z02->Z02_VLRPRJ
	M->AD1_PRIOR	:= Z02->Z02_PRIOR
	M->AD1_XCONT	:= Z02->Z02_CODCON
	M->AD1_XCONTD	:= Z02->Z02_NOMCON
	M->AD1_XNCONT	:= Z02->Z02_NCONT
	M->AD1_XTCONT	:= Z02->Z02_TCONT
	M->AD1_XCCONT	:= Z02->Z02_CCONT
	M->AD1_XNCON2	:= Z02->Z02_NCONT2
	M->AD1_XTCON2	:= Z02->Z02_TCONT2
	M->AD1_XCCON2	:= Z02->Z02_CCONT2
	M->AD1_XNCON3	:= Z02->Z02_NCONT3
	M->AD1_XTCON3	:= Z02->Z02_TCONT3
	M->AD1_XCCON3	:= Z02->Z02_CCONT3
	M->AD1_XOBSDI	:= _cObs
	
Return(.t.)

Static Function _fEnvEAp()

	Local _aEmail	:= Separa(GetMv("ES_DTFMAIL",,"000335,000148"),",")
	Local _cAssunto	:= "Aprovação de Cadastro de Projeto/Oportunidade"
	Local _cMsg		:= ""
	Local cHostWF	:= GetMv("ES_HWFHOST",,"http://201.28.59.194:8088/WF")
	Local _nI		:= 0
	
	For _nI	:= 1 To Len(_aEmail)
	
		_oProcess	:= TWFProcess():New('000001','Aprovacao - Cad Projeto')
		_oProcess:NewTask( '000002',  "\Workflow\AProjeto.html" )
	
		_oProcess:cSubject	:= _cAssunto + " - " + ALLTRIM(SM0->M0_NOME) + " - "  + DtoC(Date())
		_oHTML   			:= _oProcess:oHTML
		
		_oHTML:ValByName( "CSOLICIT"  	,AllTrim(UsrRetName(__cUserId)) )
		_oHTML:ValByName( "CAPROV"  	,_aEmail[_nI] + " - " + AllTrim(UsrRetName(_aEmail[_nI])) )
		_oHTML:ValByName( "CNOTA"  		,AllTrim(Z02->Z02_OBS) )
		_oHTML:ValByName( "CPROJETO"  	,ALLTRIM(Z02->Z02_PROJET))
		_oHTML:ValByName( "CSUBPROJ"  	,ALLTRIM(Z02->Z02_SUBPRO))
		_oHTML:ValByName( "CSTATUS"  	,ALLTRIM(Z02->Z02_STATUS))
		_oHTML:ValByName( "CDONO"  		,ALLTRIM(Z02->Z02_DONO))
		_oHTML:ValByName( "CDTINI"  	,SUBSTR(DTOS(Z02->Z02_DTINIC),7,2) + "/" + SUBSTR(DTOS(Z02->Z02_DTINIC),5,2) + "/" + SUBSTR(DTOS(Z02->Z02_DTINIC),1,4) )
		_oHTML:ValByName( "CDTFIM"  	,SUBSTR(DTOS(Z02->Z02_DTFIM),7,2) + "/" + SUBSTR(DTOS(Z02->Z02_DTFIM),5,2) + "/" + SUBSTR(DTOS(Z02->Z02_DTFIM),1,4) )
		_oHTML:ValByName( "CVLRPROJ"  	,ALLTRIM(STR(Z02->Z02_VLRPRJ)) )
		_oHTML:ValByName( "COBRA"  		,Iif(Z02->Z02_OBRA=='S','Sim','Não') )
		_oHTML:ValByName( "COBRAD"  	,ALLTRIM(Z02->Z02_OBRAD) )
		_oHTML:ValByName( "CISENCF"  	,Iif(Z02->Z02_ISENF=='S','Sim','Não') )
		_oHTML:ValByName( "CDISENCF"  	,ALLTRIM(Z02->Z02_ISENFD) )
		_oHTML:ValByName( "CCONTNAC"  	,Iif(Z02->Z02_OBSCN=='S','Sim','Não') )
		_oHTML:ValByName( "CSEGMENTO"  	,Z02->Z02_SEG + " - " + POSICIONE("SX5",1,XFILIAL("SX5")+ "T3" + Z02->Z02_SEG,"X5DESCRI()") )
		
/*		_oProcess:cTo := "APVPROJETO"
//		cMailID := _oProcess:Start("\web\messenger\emp"+cEmpAnt+"\APVPROJETO\")
		
		_cMsg := "<html>"
		_cMsg += "<head>"
		_cMsg += "<title>Untitled Document</title>"
		_cMsg += "</head> "
		_cMsg += "<body> "
		_cMsg += "  <p>&nbsp;</p>"
		_cMsg += "  <p>Prezado(a) " + AllTrim(UsrRetName(_aEmail[_nI])) + ", </p>"
		_cMsg += "  <p>Favor acessar o <a href='"+Alltrim(cHostWF)+"/WEB/messenger/emp" + cEmpAnt + "/APVPROJETO/" + cMailID + ".htm'" +">link</a>" 
		_cMsg += "    para analise de solicitação do cadastro de Projetos. </p>"
		_cMsg += "	<p>Grato(a),"
		_cMsg += "</body>"
		_cMsg += "</html>"
*/
		_cPara	:= AllTrim(UsrRetMail(_aEmail[_nI]))+";bzechetti@totalitsolutions.com.br"
		
		_oProcess:cTo 		:= _cPara   
		_oProcess:cSubject	:= _cAssunto
		_oProcess:Start()
	
/*		If MailDSC(_cPara, _cAssunto, _cMsg, "")
			If RecLock("Z02",.F.)
				Z02->Z02_WFID	:= AllTrim(Iif(!Empty(Z02->Z02_WFID),AllTrim(Z02->Z02_WFID)+",","") + cMailID)
				Z02->(MsUnLock())
			EndIf
		EndIf */
		
	Next _nI
	
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