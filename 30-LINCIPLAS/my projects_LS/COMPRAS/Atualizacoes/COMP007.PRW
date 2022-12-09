#Include "Protheus.ch"    

/*
+==============================================================+
|Programa: COMP007 |Autor: Antonio Carlos |Data: 15/04/10      |
|+=============================================================+
|Descricao: Rotina executada atraves da HQCOM01 (Compras Auto- |
|matica e tem por objetivo criar o processo e enviar e-mail no |
|Processo de Aprovacao de Pedido de Compras.                   |
+==============================================================+
|Uso: Laselva                                                  |
+==============================================================+
*/  

User Function COMP007(aMatriz,cUser)

Local _aArea		:= GetArea()
Local nTotGe		:= 0
Local nQtdT			:= 0
Local nQtdIt		:= 0
Local nTotal		:= 0
Local _cCondPg		:= ""
Local _cCompr		:= "" 
Local _cAprov		:= ""
Local _cGrupo		:= ""
Local _cEmail
Local _dPrEntr
Local _cHtm 		:= ""
Local _cUser		
Local _aAprov		:= {}

_cUser := cUser

DbSelectArea("SY1")
SY1->( DbSetOrder(3) )
If SY1->( Dbseek(xFilial("SY1")+_cUser) )
	
	DbSelectarea("SAL")
	SAL->( DbSetOrder(1) )
	If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
		
		_cGrupo := SY1->Y1_GRAPROV
		
		While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		                   
			If SAL->AL_NIVEL == "01"   
				if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM ) 
			   		Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)})
			 	Endif
			EndIf	
			SAL->( Dbskip() )		
			
		EndDo
			
	EndIf

EndIf	

For _n := 1 To Len(_aAprov) 

	//Cria o processo
	oProcess := TWFProcess():New( "PEDREP", "Pedido de Compras - Reposicao" )

	//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
	oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\PEDCOMP1.HTM" ) 			
	oProcess:cSubject := "Aprovacao Pedido de Compra - Reposicao "	

	//Chama rotina de aprovacao
	oProcess:bReturn := "U_COMP008()"

	//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
	oHTML := oProcess:oHTML
				
	//Preenche os dados do cabecalho 
	oHtml:ValByname( "CODIGO", aMatriz[1,4] )
	oHtml:ValByName( "FORNECEDOR", aMatriz[1,5] )
	oHtml:ValByName( "EMISSAO", dDataBase )
	oHtml:ValByName( "RESPUSR", _aAprov[1,1] )
	oHtml:ValByName( "APROVADOR", UsrRetName(_aAprov[1,1]) )
	oHtml:ValByName( "CODCOMP", _cUser )
	oHtml:ValByName( "COMPRADOR", UsrRetname(_cUser) )
	
	For _nI := 1 To Len(aMatriz)
	
		DbSelectArea("SC7")
		SC7->( DbSetOrder(1) )
		SC7->( DbSeek( aMatriz[_nI,1]+aMatriz[_nI,3] ) )
		cNum := SC7->C7_NUM
		_dPrEntr := SC7->C7_DATPRF
		//oProcess:fDesc := "Pedido de Compras No. "+ SC7->C7_NUM
				
		DbSelectArea("SE4")
		SE4->( DbSetOrder(1) )
		If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
			_cCondPg := Alltrim(SE4->E4_DESCRI) 
		EndIf
		
		nTotal := 0
		nQtdIt := 0
		
		While SC7->( !Eof() ) .And. SC7->C7_FILIAL == aMatriz[_nI,1] .And. SC7->C7_NUM == aMatriz[_nI,3]
		
			nTotal	+= SC7->C7_TOTAL
			nQtdIt	+= SC7->C7_QUANT		
			
        	SC7->( Dbskip() )
        	
        EndDo	
			
		Aadd( (oHtml:ValByName( "IT.FILIAL" )),aMatriz[_nI,1]+" - "+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + aMatriz[_nI,1])	)
		Aadd( (oHtml:ValByName( "IT.PEDIDO" )),aMatriz[_nI,3]	)
		Aadd( (oHtml:ValByName( "IT.CONDPAGTO" )),_cCondPg		)
		Aadd( (oHtml:ValByName( "IT.PRZENTREGA" )),_dPrEntr		)		
		Aadd( (oHtml:ValByName( "IT.QTDITENS" )),TRANSFORM( nQtdIt,'@E 999,999,999.99' ) )
		Aadd( (oHtml:ValByName( "IT.VALOR" )),TRANSFORM( nTotal,'@E 999,999,999.99' ) )
		
		nTotGe	+= nTotal
		nQtdT	+= nQtdIt
		
	Next _nI
	
	oHtml:ValByName( "LBTOTAL"	,TRANSFORM( nTotGe,'@E 999,999,999.99') )
	oHtml:ValByName( "QTD" 		,TRANSFORM( nQtdT,'@E 999,999,999.99' ) )
	
	_cEmail := _aAprov[_n,2]
					
Next _n
			
If Len(_aAprov) > 0

oProcess:ClientName( cUserName )
cMailID := oProcess:Start()

//cAssunto	:= "Aprovacao Pedido de Compra"
//cHtmlLink	:= "\WORKFLOW\HTML\LINKPED.HTM" //se for utilizar o link
//oProcess:NewTask(cAssunto, cHtmlLink)  //Gera o processo para envio do link para o aprovador e os usuarios que serao copiados.
//oProcess:cSubject := cAssunto //se for utilizar o link
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Endereco eletronico do destinatario aprovador.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oProcess:cTo := _cEmail
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Link com o endereco para acesso a pagina.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oProcess:oHtml:ValByName("cPath"	,"\\TERRA\workflow\emp01\temp\" +cMailID+ ".htm")
//cPath := "\\192.168.0.194\workflow\emp01\temp\" +cMailID+ ".htm"
cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apos ter repassado todas as informacoes necessarias para o ³
//³workflow, solicita a ser executado o método Start() para se³
//³gerado todo processo e enviar a mensagem ao destinatário.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oProcess:Start()

_cTo		:= Alltrim(_cEmail)
_cSubject	:= " Aprovacao Pedido de Compra - Reposicao "
	
_cHtm += "	<TABLE border=0 width=800>  "
_cHtm += "   <tr> "
//_cHtm += "   <td width=180 ><img src=\\192.168.0.194\workflow\header_logo.jpg></img></td> "
_cHtm += "   <td width=180 ><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
_cHtm += "   </tr> "
_cHtm += "	</TABLE> "

_cHtm += "	<BR> "

_cHtm += " 	<TABLE border=0 width=800> "
_cHtm += " 	   <tr> "
_cHtm += "      <td width=600><font color=#000040 size=3 face=Verdana><hr><b>Aprovação de Pedido de Compra - Reposicao</b></hr></font></td> "
_cHtm += "	   </tr> "
_cHtm += "	</TABLE> "

_cHtm += " 	<BR> "

_cHtm += "	<b>Favor acessar o link abaixo:</b> "

_cHtm += "	<BR> "
_cHtm += " 	<BR> "

_cHtm += "	<a href="+cPath+">PEDIDO</a> "

//U_EnvMail(_cTo,_cSubject, _cHtm,)	
cQuery := ""
cQuery := " EXEC msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'html' "
TcSQLExec(cQuery)

EndIf

RestArea(_aArea)

Return