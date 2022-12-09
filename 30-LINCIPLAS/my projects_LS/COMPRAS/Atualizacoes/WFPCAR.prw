// ************************************************************************************ //
// Função utilizada para enviar o alerta de aprovação do pedido de compra               //
// Também é responsável por alterar os status do pedido e gravar os devidos saldos      //
// USER FUNCTION WFPCAR()                                                               //
// ************************************************************************************ //
User Function AWFPC()

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )
While SC7->( !Eof() ) .And. Substr(_cFilial,1,2) == SC7->C7_FILIAL .And. SC7->C7_NUM == _cNumPed
	RecLock("SC7",.F.)
	SC7->C7_CONAPRO := "L"
	SC7->( MsUnLock() )
	SC7->( DbSkip() )
EndDo

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )

If !Empty(SC7->C7_NUMSC)
	
	DbSelectArea("SC1")
	SC1->( DbsetOrder(1) )
	SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
	_cRespS := SC1->C1_USER
	
EndIf

// Valida variáveis possivelmente inexistentes
IF TYPE("_cRespS") == "U" //.OR. _cRespS == NIL
	_cRespS := ""
ENDIF

IF TYPE("_cTo") == "U" //.OR. _cRespS == NIL
	_cTo := ""
ENDIF

IF TYPE("_cObsA") == "U" //.OR. _cRespS == NIL
	_cObsA := ""
ENDIF

_cTo 		:= IIF(EMPTY(ALLTRIM(_cTo)),Alltrim(UsrRetMail(SC7->C7_USER))+";"+IIf(!Empty(_cRespS),Alltrim(UsrRetMail(_cRespS)),""),_cTo)
_cUser 		:= IIf(Empty(SC7->C7_NUMSC),RetCodUsr(), SC1->C1_USER)

_cSubject	:= "Pedido de Compra Aprovado - " +Substr(_cFilial,1,2)+"-"+SC7->C7_NUM

cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")
cSolicit	:= UsrRetName(SC7->C7_USER)
cEmissao	:= DtoC(SC7->C7_EMISSAO)
cMotivo 	:= Alltrim(_cObsA)

//-----------------------------------
oProcess:=TWFProcess():New("PEDCOM","WORKFLOW PARA APROVACAO DE PC")
oProcess:NewTask('Inicio',"\workflow\HTML\PEDCOMP_APROVADO.htm")

oHtml   := oProcess:oHtml

oHtml:valbyname("Num"				, SC7->C7_NUM)
oHtml:valbyname("Req"    			, cSolicit)
oHtml:valbyname("Emissao"  			, cEmissao)
oHtml:valbyname("Motivo"   			, cMotivo)
oHtml:valbyname("it.Item"   		, {})
oHtml:valbyname("it.Cod"  			, {})
oHtml:valbyname("it.Desc"   		, {})

/*
aadd(oHtml:ValByName("it.Item")		, "")
aadd(oHtml:ValByName("it.Cod")		, "")
aadd(oHtml:ValByName("it.Desc")		, "")
*/
dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+_cNumPed)
WHILE !EOF() .AND. SC7->C7_NUM == _cNumPed
	
	cMailSol	:= UsrRetMail(SC7->C7_USER)
	cMailSup	:= "" //UsrRetMail(SC7->C7_USRAPRO)
	
	aadd(oHtml:ValByName("it.Item")		, SC7->C7_ITEM)
	aadd(oHtml:ValByName("it.Cod")		, SC7->C7_PRODUTO)
	aadd(oHtml:ValByName("it.Desc")		, SC7->C7_DESCRI)
	
	dbSelectArea("SC7")
	dbSkip()
ENDDO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//envia o e-mail

cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
conout("Aprovação - "+_cTo)
oProcess:cTo	  := _cTo
//oProcess:cBCC     := 'thiago.queiroz@laselva.com.br' //cCopia    - Exclusão solicitado pelo Sr. Roberto - 15/09/2015

oProcess:cSubject := "Pedido de Compra N°: "+Substr(_cFilial,1,2)+"-"+_cNumPed+" - Aprovado"

//oProcess:cBody  := ""
oProcess:bReturn  := ""
oProcess:Start()

oProcess:Free()
oProcess:Finish()
oProcess:= Nil
//-----------------------------------

RETURN

// ************************************************************************************ //
// Função utilizada para enviar o alerta de reprovação do pedido de compra              //
// Também é responsável por alterar os status do pedido e gravar os devidos saldos      //
// ************************************************************************************ //
User Function RWFPC()

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek( Substr(_cFilial,1,2)+_cNumPed ) )

If !Empty(SC7->C7_NUMSC)
	
	DbSelectArea("SC1")
	SC1->( DbsetOrder(1) )
	SC1->( DbSeek( Substr(_cFilial,1,2)+SC7->C7_NUMSC ) )
	_cRespS := SC1->C1_USER
ELSE
	_cRespS := SC7->C7_USER
EndIf

_cTo := UsrRetMail(SC7->C7_USER)+IIf(!Empty(_cRespS),UsrRetMail(_cRespS),"")

//oProcess:Finish()

_cSubject	:= " Bloqueio de Pedido de Compra "

cAprov		:= Posicione("SAK",2,xFilial("SAK")+_cUser,"AK_NOME")
cFornece	:= Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")
cSolicit	:= UsrRetName(SC7->C7_USER)
cEmissao	:= DtoC(SC7->C7_EMISSAO)
cMotivo 	:= Alltrim(_cObsA)

//-----------------------------------
oProcess:=TWFProcess():New("PEDCOM","WORKFLOW PARA REPROVACAO DE PC")
oProcess:NewTask('Inicio',"\workflow\HTML\PEDCOMP_REPROVADO.htm")

oHtml   := oProcess:oHtml

oHtml:valbyname("Num"				, SC7->C7_NUM)
oHtml:valbyname("Req"    			, cSolicit)
oHtml:valbyname("Emissao"  			, cEmissao)
oHtml:valbyname("Motivo"   			, cMotivo)
oHtml:valbyname("it.Item"   		, {})
oHtml:valbyname("it.Cod"  			, {})
oHtml:valbyname("it.Desc"   		, {})
/*
aadd(oHtml:ValByName("it.Item")		, "")
aadd(oHtml:ValByName("it.Cod")		, "")
aadd(oHtml:ValByName("it.Desc")		, "")
*/
dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+_cNumPed)
WHILE !EOF() .AND. SC7->C7_NUM == _cNumPed
	
	cMailSol	:= UsrRetMail(SC7->C7_USER)
	cMailSup	:= "" //UsrRetMail(SC7->C7_USRAPRO)
	
	aadd(oHtml:ValByName("it.Item")		, SC7->C7_ITEM)
	aadd(oHtml:ValByName("it.Cod")		, SC7->C7_PRODUTO)
	aadd(oHtml:ValByName("it.Desc")		, SC7->C7_DESCRI)
	
	dbSelectArea("SC7")
	dbSkip()
ENDDO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//envia o e-mail

cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
conout("Reprovação - "+_cTo)
oProcess:cTo	  := _cTo
//oProcess:cBCC     := 'thiago.queiroz@laselva.com.br' //cCopia - Exclusão solicitado pelo Sr. Roberto - 15/09/2015

oProcess:cSubject := "Pedido de Compra N°: "+Substr(_cFilial,1,2)+"-"+_cNumPed+" - Reprovado"

//oProcess:cBody  := ""
oProcess:bReturn  := ""
oProcess:Start()

oProcess:Free()
oProcess:Finish()
oProcess:= Nil
//-----------------------------------

RETURN
