#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M110STTS  ºAutor  ³Fernando Brito Muta º Data ³  21/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este programa tem como objetivo enviar e-mail da solicitacaoº±±
±±º          ³de compras ao superior do usuario solicitante               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Expand                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110GRV()

Local _cHtm			:= ""
Local nPreco		:= 0
Local nTotal		:= 0
Local _cObs			:= ""
Local _cCondPg		:= ""
Local _cCompr		:= "" 
Local _cAprov		:= ""
Local _cDescCC		:= ""
Local _cGrupo		:= ""
Local cNum			:= Space(6)
Local _cUser		:= RetCodUsr()
Local _aAprov		:= {}
Local _cEmail

DbSelectArea("SY1")
SY1->( DbSetOrder(3) )
If SY1->( Dbseek(xFilial("SY1")+_cUser) )
	
	DbSelectarea("SAL")
	SAL->( DbSetOrder(1) )
	If SAL->( DbSeek(xFilial("SAL")+SY1->Y1_GRAPROV) )
		
		_cGrupo := SY1->Y1_GRAPROV
		
		While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == SY1->Y1_GRAPROV
		                   
			If SAL->AL_NIVEL == "01"
				Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)})
			EndIf	
			SAL->( Dbskip() )		
			
		EndDo
			
	EndIf

EndIf	

For _nI := 1 To Len(_aAprov) 

	//Cria o processo
	oProcess := TWFProcess():New( "SOLCOM", "Solicitacao de Compras" )

	//Abre o HTML criado, repare que o mesmo se encontra abaixo do RootPath
	oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\SOLCOMP.HTM" ) 			
	oProcess:cSubject := "Aprovacao Solicitacao de Compra - Num.: "+AllTrim(SC1->C1_NUM)	

	//Chama rotina de aprovacao
	oProcess:bReturn := "U_COMP006()"

	//oProcess:bTimeOut := {{"U_EXTIMEOUT",0, 0, 5 }}
	oHTML := oProcess:oHTML
				
	//Preenche os dados do cabecalho 
	oHtml:ValByname( "EMPRESA", SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
	oHtml:ValByName( "EMISSAO", SC1->C1_EMISSAO )
	oHtml:ValByName( "FORNECEDOR", If(!Empty(SC1->C1_FORNECE),Alltrim(SC1->C1_FORNECE),"") ) 
	
	oHtml:ValByName( "LB_NOME", If( !Empty(SC1->C1_FORNECE),Alltrim(Posicione("SA2",1,xFilial("SA2")+SC1->C1_FORNECE,"A2_NOME")),""))

	cComprador	:= Posicione("SY1",3,xFilial("SY1")+_cUser,Alltrim("Y1_NOME"))
	oHtml:ValByName( "COMPRADOR", cComprador )
	
	oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])			   
		
	cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
	oHtml:ValByName( "APROVADOR", cAprovador )
	
	oHtml:ValByName( "NECESSIDADE", SC1->C1_DATPRF )
			
	DbSelectArea("SC1")
	SC1->( DbSetOrder(1) )
	SC1->( DbSeek(xFilial('SC1')+SC1->C1_NUM ) )
	oHtml:ValByName( "PEDIDO", SC1->C1_NUM )
	cNum := SC1->C1_NUM
	oProcess:fDesc := "Solicitacao de Compras No. "+ SC1->C1_NUM
		
	While SC1->( !Eof() ) .And. xFilial("SC1") == SC1->C1_FILIAL .And. SC1->C1_NUM == cNum
	
		Aadd( (oHtml:ValByName( "IT.ITEM" )),SC1->C1_ITEM )
		Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC1->C1_PRODUTO ))
	
		DbSelectArea('SB1')
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek(xFilial('SB1')+SC1->C1_PRODUTO) )
		Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC1->C1_DESCRI ))
		Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
		
		nPreco := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_UPRC")
		nTotIt := SC1->C1_QUANT * nPreco		
		nTotal := nTotal+nTotIt
		
		Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC1->C1_QUANT,'@E 999999999.99'   ) )
		Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( nPreco,'@E 999,999,999.99' ) )
		Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( nTotIt,'@E 999,999,999.99' ) )
			
		_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC1->C1_OBS)
		
		SC1->( DbSkip() )
		
	EndDo
	
	oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal,'@E 999,999,999.99' ) )
	oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0,'@E 999,999,999.99' ) )
	oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
		
	oHtml:ValByName( "LBOBSS", AllTrim(_cObs) ) 

	oProcess:ClientName( cUserName )
	cMailID := oProcess:Start()
	_cEmail := _aAprov[_nI,2]

Next _nI

If Len(_aAprov) > 0

	cAssunto	:= "Aprovacao Solicitacao de Compra"
	cHtmlLink	:= "\WORKFLOW\HTML\LINKPED.HTM" //se for utilizar o link
	oProcess:NewTask(cAssunto, cHtmlLink)  //Gera o processo para envio do link para o aprovador e os usuarios que serao copiados.
	oProcess:cSubject := cAssunto //se for utilizar o link
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Endereco eletronico do destinatario aprovador.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oProcess:cTo := _cEmail
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Link com o endereco para acesso a pagina.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oProcess:oHtml:ValByName("cPath"	,"\\TERRA\workflow\emp01\temp\" +cMailID+ ".htm")
	cPath := "\\192.168.0.194\workflow\emp01\temp\" +cMailID+ ".htm"
	//cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apos ter repassado todas as informacoes necessarias para o ³
	//³workflow, solicita a ser executado o método Start() para se³
	//³gerado todo processo e enviar a mensagem ao destinatário.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oProcess:Start()
	
	_cTo		:= Alltrim(_cEmail)
	_cSubject	:= " Aprovacao Solicitacao de Compra  "
	
	_cHtm += "	<TABLE border=0 width=800>  "
	_cHtm += "   <tr> "
	_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
	_cHtm += "   </tr> "
	_cHtm += "	</TABLE> "

	_cHtm += "	<BR> "

	_cHtm += " 	<TABLE border=0 width=800> "
	_cHtm += " 	   <tr> "
	_cHtm += "      <td width=600><font color=#000040 size=3 face=Verdana><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
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

DbSelectArea("SC1")
SC1->( DbSetOrder(1) )
SC1->( DbSeek(xFilial('SC1')+cNum ) )
While SC1->( !Eof() ) .And. xFilial("SC1") == SC1->C1_FILIAL .And. SC1->C1_NUM == cNum
	
	RecLock("SC1",.F.)
	SC1->C1_APROV	:= "B"
	SC1->C1_NOMAPRO := " "	
	SC1->( MsUnLock() )                
	
	SC1->( DbSkip() )
	
EndDo	

Return