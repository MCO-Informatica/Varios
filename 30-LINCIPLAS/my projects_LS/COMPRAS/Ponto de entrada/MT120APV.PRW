#Include "Protheus.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+==============================================================+
|Programa: MT120APV |Autor: Antonio Carlos |Data: 08/02/10     |
|+=============================================================+
|Descricao: PE executado na gravação do Pedido de Compra para  |
|envio de e-mail no caso de Pedido de Compra bloqueado.        |
+==============================================================+
|Uso: Laselva                                                  |
+==============================================================+

Alteração
+================================================================+
|Solicitante: Luis Fernando |Autor:Antonio Carlos |Data: 09/09/10|
+================================================================+
|Motivo: Mudança nas regra de aprovação de Pedido de Compra.     |
+================================================================+
*/

User Function MT120APV()

Local _aArea		:= GetArea()
Local _cObs			:= ""
Local _cCondPg		:= ""
Local _cCompr		:= ""
Local _cAprov		:= ""
Local _cDescCC		:= ""
Local _cGrupo		:= SC7->C7_APROV
Local _cHtm			:= ""
Local _cResp		:= ""
Local nTotal		:= 0
Local _cEmail
Public _cUser
Public _aAprov		:= {}

SC7->(DbSeek(xFilial('SC7') + ca120num,.f.))
_cGrupo		:= SC7->C7_APROV
//If empty(_cGrupo)
// SE O PEDIDO FOR DE LIBERAÇÃO AUTOMATICA, COM GRUPOS DE APROVAÇÃO DIFERENTES DE 000069 E/OU 000070, NÃO ENVIA EMAIL DE WORKFLOW
// PARA TODO O RESTO ENVIA NORMALMENTE
IF SC7->C7_CONAPRO != 'L' .AND. !(SC7->C7_APROV$'000069/000070')
	If !Alltrim(Posicione('SE4',1,xFilial('SE4') + SC7->C7_COND,'E4_COND')) == "0" // .and. !(SC7->C7_TES $ GetMv('LS_TESLBPC') )
		
		If !Substr(SA2->A2_CGC,1,8) $ GetMv("MV_CNPJLSV")
			
			_cUser := IIf(Empty(SC7->C7_NUMSC),RetCodUsr(), SC1->C1_USER)
			
			DbSelectArea("SY1")
			SY1->( DbSetOrder(3) )
			If SY1->( Dbseek(xFilial("SY1")+_cUser) )
				
				_cGrupo := IIF(EMPTY(_cGrupo),SY1->Y1_GRAPROV,_cGrupo) //SY1->Y1_GRAPROV
				
				DbSelectarea("SAL")
				SAL->( DbSetOrder(1) )
				If SAL->( DbSeek(xFilial("SAL")+_cGrupo) )
					
					While SAL->( !Eof() ) .And. xFilial("SAL") == SAL->AL_FILIAL .And. SAL->AL_COD == _cGrupo //SY1->Y1_GRAPROV
						
						If SAL->AL_NIVEL == "01"
							
							if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )
								
								Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)} )
								
							Endif
							
						EndIf
						SAL->( Dbskip() )
						
					EndDo
					
				EndIf
				
			EndIf
			
			If !FunName(0) $ "HQCOM01/U_HQCOM01"
				
				For _nI := 1 To Len(_aAprov)
					
					// A cada aprovador reposiciono no 1o item do pedido. Estava gerando erro porque a funcao abaixo faz Do While no SC7 - Richard 02/06/14
					SC7->( DbSetOrder(1) )
					SC7->(DbSeek(xFilial('SC7') + ca120num,.f.))
					
					U_WFPC()
					
				Next _nI
				
				/*
				If Len(_aAprov) > 0
				
				cPath := "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm"
				
				_cTo		:= "thiago.queiroz@laselva.com.br" //Alltrim(_cEmail)
				_cSubject	:= 'Aprovacao Pedido de Compra '
				
				_cHtm += "	<TABLE border=0 width=800>  "
				_cHtm += "   <tr> "
				_cHtm += "   <td width=180><img src=http:\\192.168.0.194:7914\header_logo.jpg></img></td> "
				_cHtm += "   </tr> "
				_cHtm += "	</TABLE> "
				
				_cHtm += "	<BR> "
				
				_cHtm += " 	<TABLE border=0 width= 800> "
				_cHtm += " 	   <tr> "
				_cHtm += "      <td width= 600 ><font color= #000040  size= 3 face= Verdana ><hr><b>Aprovação de Pedido de Compra</b></hr></font></td> "
				_cHtm += "	   </tr> "
				_cHtm += "	</TABLE> "
				
				_cHtm += " 	<BR> "
				
				_cHtm += "	<b>Favor acessar o link abaixo:</b> "
				
				_cHtm += "	<BR> "
				_cHtm += " 	<BR> "
				
				_cHtm += "	<a href="+cPath+">PEDIDO</a> "
				
				cQuery := ""
				cQuery := " EXEC MARTE.msdb.dbo.sp_send_dbmail @profile_name='totvs', @recipients='" +_cTo + "', @subject = '" +_cSubject + "', @body = '" +_cHtm + "', @body_format = 'HTML' "
				
				nExec	:= TcSQLExec(cQuery)
				
				EndIf
				*/
			EndIf
			
		EndIf
		
	EndIf
EndIf

DbSelectArea('SC7')

RestArea(_aArea)

Return(_cGrupo)

// *************************************************************************** //
// Função responsável por enviar o Workflow para aprovação do PEDIDO de Compra //
// *************************************************************************** //
User Function WFPC()

oProcess 	:= TWFProcess():New( "PEDCOM", "Pedido de Compras" )

oProcess:NewTask( "AprovacaoPV", "\WORKFLOW\HTML\PEDCOMP.HTM" )

oHTML 		:= oProcess:oHTML

DbSelectArea("SE4")
SE4->( DbSetOrder(1) )
If SE4->( DbSeek(xFilial("SE4")+SC7->C7_COND) )
	_cCondPg := Alltrim(SE4->E4_DESCRI)
EndIf

IF TYPE("_cFilial") != "U"
	oHtml:ValByname( "EMPRESA"	, Substr(_cFilial,1,2)+"-"+GetAdvFval("SM0",Alltrim("M0_FILIAL"),Substr(cNumEmp,1,2) + Substr(_cFilial,1,2)	) )
ELSE
	oHtml:ValByname( "EMPRESA"	, SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL) )
ENDIF
oHtml:ValByName( "EMISSAO"		, SC7->C7_EMISSAO )
oHtml:ValByName( "FORNECEDOR"	, Alltrim(SC7->C7_FORNECE))

DbSelectArea("SA2")
SA2->( DbSetOrder(1) )
SA2->( DbSeek(xFilial("SA2")+SC7->C7_FORNECE) )
oHtml:ValByName( "LB_NOME", Alltrim(SA2->A2_NOME) )
oHtml:ValByName( "LB_COND", _cCondPg )

cComprador	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,Alltrim("Y1_NOME"))
oHtml:ValByName( "COMPRADOR", cComprador )

oHtml:ValByName( "RESPUSR", _aAprov[_nI,1])

cAprovador	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_NOME"))
cCodAprov	:= Posicione("SAK",2,xFilial("SAK")+_aAprov[_nI,1],Alltrim("AK_USER"))
cMailSup	:= Posicione("SY1",3,xFilial("SY1")+cCodAprov     ,Alltrim("Y1_EMAIL"))

// Se o campo email está em branco no cadastro do aprovador, busca a informação no cadastro do usuário
IF Empty(alltrim(cMailSup))
	cMailSup	:= UsrRetmail(cCodAprov)
ENDIF

oHtml:ValByName( "APROVADOR", cAprovador )

IF TYPE("_cFilial") != "U"
	_cFilial := Substr(_cFilial,1,2)
ELSE
	_cFilial := xFilial("SC7")
ENDIF

DbSelectArea("SC1")
SC1->( DbsetOrder(1) )
If SC1->( DbSeek( _cFilial+SC7->C7_NUMSC ) )
	_cResp := UsrFullName(SC1->C1_USER)
ELSE
	_cResp := UsrFullName(SC7->C7_USER)
EndIf

oHtml:ValByName( "SOLICITANTE", Alltrim(_cResp) )
oHtml:ValByName( "PRZENTREGA", SC7->C7_DATPRF )

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek(xFilial('SC7')+SC7->C7_NUM ) )
oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
cNum 			:= SC7->C7_NUM
oProcess:fDesc 	:= "Pedido de Compras No. "+ SC7->C7_NUM
nTotal			:= 0
_cObs			:= ""

While SC7->( !Eof() ) .And. C7_NUM == cNum
	
	nTotal := nTotal + C7_TOTAL
	Aadd( (oHtml:ValByName( "IT.ITEM" )),SC7->C7_ITEM )
	Aadd( (oHtml:ValByName( "IT.CODIGO" )),Alltrim(SC7->C7_PRODUTO ))
	
	DbSelectArea('SB1')
	SB1->( DbSetOrder(1) )
	SB1->( DbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )
	Aadd( (oHtml:ValByName( "IT.PRODUTO" )),Alltrim(SC7->C7_DESCRI ))
	Aadd( (oHtml:ValByName( "IT.UNID" )),SB1->B1_UM )
	Aadd( (oHtml:ValByName( "IT.QUANT" )),TRANSFORM( SC7->C7_QUANT,'@E 999999999.99'   ) )
	Aadd( (oHtml:ValByName( "IT.PRECO" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
	Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
	
	_cObs += IIf(Empty(_cObs),"","  ")+AllTrim(SC7->C7_OBS)
	SC7->( DbSkip() )
	
EndDo

oHtml:ValByName( "LBVALOR" ,TRANSFORM( nTotal	,'@E 999,999,999.99' ) )
oHtml:ValByName( "LBFRETE" ,TRANSFORM( 0		,'@E 999,999,999.99' ) )
oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal	,'@E 999,999,999.99' ) )

IF TYPE("_cObsA") != "U"
	oHtml:ValByName( "LBOBSP", AllTrim(_cObs)+" "+Alltrim(_cObsA) )
ELSE
	oHtml:ValByName( "LBOBSP", AllTrim(_cObs) )
ENDIF

oProcess:ClientName( cUserName )
cMailID 			:= oProcess:Start()
_cEmail 			:= _aAprov[_nI,2]

oProcess:cTo		:= "PEDCOM"
oProcess:cSubject 	:= "Aprovacao Pedido de Compra - Num.: " +_cFilial+"-"+cNum //+AllTrim(SC7->C7_NUM)
oProcess:bReturn 	:= "U_COMP005()"

cMailID				:= oProcess:Start()

oProcess:Free()

//oHTML := oProcess:oHTML

oProcess:NewTask("LINK", "\WORKFLOW\HTML\LINKPED.HTM")

//oProcess:oHtml:ValByName("cPath", "http://200.198.75.212/emp01/temp/" +cMailID+ ".htm")
oProcess:oHtml:ValByName("cPath", "http://200.198.75.216:7914/messenger/emp" + "01"+ "/PEDCOM/" + cMailId + ".htm")
//oProcess:oHtml:ValByName("B_LINK", "http://186.215.160.178:8092/messenger/emp" + "01"/*cEmpAnt*/ + "/PEDCOMPRA/" + cMailId + ".htm")

oProcess:ClientName( Subs(cUsuario,7,15) )
oProcess:cTo 		:= IIF(EMPTY(alltrim(_cEmail)),cMailSup,_cEmail)
//oProcess:cBCC     	:= "thiago.queiroz@laselva.com.br"  //excluido por solicitação do sr. Roberto 15/09/2015
oProcess:cSubject  	:= "Aprovação de Pedido de Compra - " +_cFilial+"-"+cNum

oProcess:Start()

//RastreiaWF( ID do Processo                        , Codigo do Processo, Codigo do Status, Descricao Especifica                   , Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000001"           ,"10001"           ,"ENVIO DE WORKFLOW PARA APROVACAO DE PC",cUsername)
oProcess:Free()
oProcess			:= Nil

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Gatilho para preenchimento dos campos de grupo de aprovação de pedidos de compras
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function COMG007()
///////////////////////

For _nI := 1 to len(aCols)
	GdFieldPut('C7_APROV',M->C7_APROV,_nI)
Next

Return(M->C7_APROV)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Validação de alçadas para envio de e-mail processos de WorkFlow - Callsystem 19/03/2014
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _CValAlc( _cUsuApr, _cLim )
///////////////////////

Local _aArea := GetArea()
Local _lRet  := .t.

// Inicializa valor fiscal ?do pedido
MaFisIniPC(SC7->C7_NUM)
_nTotPed := MaFisRet(,'NF_TOTAL') // - Ilidio em 23/04/15

// Verificando alçada  //AK_FILIAL+AK_COD
DbSelectArea("SAK")
SAK->( DbSetOrder(1) )

If SAK->( Dbseek( xFilial("SAK") + _cUsuApr ) )
	
	// Se o grupo considerar limites mínimos
	if Upper(alltrim(_cLim)) == 'S'
		
		_lRet := ( _nTotPed >= SAK->AK_LIMMIN ) .and. ( _nTotPed <= SAK->AK_LIMMAX )
		
	Endif
	
Else
	
	_lRet  := .f.
	
Endif

// Finalizando valor fiscal do pedido
MaFisEnd()

RestArea( _aArea )

Return _lRet
// --> Final Callsystem 19/03/2014


