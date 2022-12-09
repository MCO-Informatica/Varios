#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/03/00
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+-----------------------------------------------------------------------------+
* Programa  * W1881502   º  Business Inteligence         * Data ³  26/09/2000 *
*-----------------------------------------------------------------------------*
* Objetivo  * Programa que envia e-mail para aprovação de um Pedido de Compra *
*           * a partir de um Ponto de Entrada chamado WFW120P.                *
*-----------------------------------------------------------------------------*
* Uso       * WorkFlow/AP5 - VideoLar                                         *
*-----------------------------------------------------------------------------+
| Starting  | Ponto de Entrada                                                |
+-----------------------------------------------------------------------------+
*/

USER function WFW120P( nOpcao, oProcess )

If ValType(nOpcao) = "A"
	nOpcao := nOpcao[1]
Endif

If nOpcao == NIL
	nOpcao := 0
End

cstatus := 0

If oProcess == NIL
	oProcess := TWFProcess():New( "PEDCOM", "Pedido de Compras" )
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPAR,NBARRA,N_ITEM,C_MAT,C_DEST,CGRAP")
SetPrvt("C_NUM,C_MOTIVO,N_TOTPC,CGRAPANT,N_TERMINA,N_DOHTML")
SetPrvt("CRAIZ,NRET,NHLDHTM,NHLDSCP,CIND,C_PCANT")
SetPrvt("N_QTDPC,N_FRTPC,A_ITENS,LCABEC,_AREGISTROS,NLIMITE")
SetPrvt("CAB_NUM,CAB_EMIS,CAB_FORN,CAB_COND,CAB_NOME,_NI")
SetPrvt("ARRAYCAB,ARRAYITENS,C_ITPED,NPRESUP,CAPROV,AINFO")
SetPrvt("CMAILAP,CNOMEAP,CORIGEM,CABEC,NHDLVLR,NCOUNT")
SetPrvt("NRESULT,CHTML,NHDLCONNECT")

lPrimeira := .F.
//Do Case
IF nOpcao == 0 //CASE
	SPCIniciar( oProcess,lPrimeira )
ELSEIF nOpcao == 1 //CASE
	SPCRetorno( oProcess,lPrimeira )
ELSEIF nOpcao == 2 //CASE
	SPCTimeOut( oProcess )
EndIF

oProcess:Free()
RETURN

/////////////////////////////////////////////////////////
STATIC FUNCTION SPCRetorno( oProcess )
Local cMvAtt := GetMv("MV_WFHTML")
Local lLast := .T.,_oProc,nTotal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Muda o parametro para enviar no corpo do e-mail³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","F")
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10002','Respondendo ao email',"BI")
ConOut('Pedido:'+oProcess:oHtml:RetByName('Pedido'))

if oProcess:oHtml:RetByName("Aprovacao") = "S"
	
	//Verifica usuarios e status
	//	  if lPrimeira := .f. //Retorno
	cstatus := 01
	//	  else
	//	     cstatus := cstatus + 1
	//	  endif
	
	ConOut("Aprovando o pedido")
	DBSelectar("SCR")                   // Posiciona a Liberacao
	DBSetorder(1)
	//	  if DBSeek(xFilial("SCR")+oProcess:oHtml:RetByName('Pedido')+STRZERO(CSTATUS,2))
	ConOut((xFilial("SCR")+"PC"+Alltrim(oProcess:oHtml:RetByName('Pedido'))+SPACE(14)+STRZERO(CSTATUS,2)))
	if DBSeek(xFilial("SCR")+"PC"+Alltrim(oProcess:oHtml:RetByName('Pedido'))+SPACE(14)+STRZERO(CSTATUS,2))
		lLast := .F.
		cAprovador := SCR->CR_USER
	endif
	
	//	  CONOUT("Aprovador" + CAPROVADOR)
	//	  SeekEml(cAprovador) //Funcao que busca e-mail
	
	If lLast
		//Finaliza processo - nao tem mais aprovador
		DBSelectar("SCR")                   // Posiciona a Liberacao
		DBSetorder(2)
		If DBSeek(xFilial("SCR")+"PC"+oProcess:oHtml:RetByName('Pedido'))
			RecLock("SCR",.f.)
			SCR->CR_DataLib := dDataBase
			SCR->CR_Obs     := ""
			SCR->CR_UserLib := Subs(cUsuario,7,15)
			SCR->CR_STATUS  := "03"
			MsUnLock()
		endif
		dbselectarea("SC7")
		DBSETORDER(1)
		DBSeek(xFilial("SC7")+oProcess:oHtml:RetByName('Pedido'))      // Posiciona o Pedido
		while !EOF() .and. SC7->C7_Num == oProcess:oHtml:RetByName('Pedido')
			RecLock("SC7",.f.)
			SC7->C7_ConaPro := "L"
			MsUnLock()
			DBSkip()
		enddo
		
		/**** Aviso o Fornecedor ****/
		dbSelectArea('SC7')
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+oProcess:oHtml:RetByName('Pedido'))
		
		_oProc := TWFProcess():New( "PEDFOR", "Pedido para o Fornecedor" )
		_oProc:NewTask( "Solicitacao de Pedido", "\WORKFLOW\HTML\WFW120P2.HTM" )
		_oProc:cSubject := "Pedido de Compra " + SC7->C7_NUM
		//		  _oProc:bReturn := "U_WFW120P( 1 )"
		oHTML := _oProc:oHTML
		
		/*** Preenche os dados do cabecalho ***/
		oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
		oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE )
		dbSelectArea('SA2')
		dbSetOrder(1)
		dbSeek(xFilial('SA2')+SC7->C7_FORNECE)
		oHtml:ValByName( "lb_nome", SA2->A2_NREDUZ )
		
		//Pego as condiicoes de Pagamento
		dbSelectArea('SE4')
		DBSETORDER(1)
		dbSeek(xFilial('SE4') + SC7->C7_COND)
		ccond := SE4->E4_DESCRI
		oHtml:ValByName( "lb_cond", CCOND )
		
		dbSelectArea('SC7')
		oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
		cNum := SC7->C7_NUM
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+cNum)
		nTotal := 0
		While !Eof() .and. C7_NUM = cNum
			nTotal := nTotal + C7_TOTAL
			AAdd( (oHtml:ValByName( "it.item" )),C7_ITEM )
			AAdd( (oHtml:ValByName( "it.codigo" )),C7_PRODUTO )
			dbSelectArea('SB1')
			dbSetOrder(1)
			dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
			dbSelectArea('SC7')
			AAdd( (oHtml:ValByName( "it.descricao" )),SB1->B1_DESC )
			AAdd( (oHtml:ValByName( "it.quant" )),TRANSFORM( C7_QUANT,'@E 999,999.99' ) )
			AAdd( (oHtml:ValByName( "it.preco" )),TRANSFORM( C7_PRECO,'@E 999,999.99' ) )
			AAdd( (oHtml:ValByName( "it.total" )),TRANSFORM( C7_TOTAL,'@E 999,999.99' ) )
			AAdd( (oHtml:ValByName( "it.unid" )),SB1->B1_UM )
			dbSkip()
		Enddo
		
		oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
		oHtml:ValByName( "lbFrete" ,TRANSFORM( 0,'@E 999,999.99' ) )
		oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
		
		dbSelectArea('SC7')
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+cNum)
		SA2->(dbSetOrder(1))
		ConOut(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
		SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
		_oProc:cTo := SA2->A2_EMAIL
		ConOut("Email:"+SA2->A2_EMAIL)
		_oProc:Start()
		RastreiaWF("00001"+'.'+_oProc:fTaskID,"000001",'1007',"Pedido de Compras "+cNum+" Aprovado. Enviado para o Fornecedor")
		_oProc:Finish()
	Else
		
		RecLock("SCR")
		SCR->CR_NIVEL := "02"
		MsUnlock()
		oProcess:NewTask( "Solicitacao", "\WORKFLOW\HTML\WFW120P1.HTM",.T. )
		oProcess:bReturn := "U_WFW120P( 1 )"
		//oProcess:cTo := "mauro@linciplas.com.br"
		oProcess:cTo := "thiago@stch.com.br"
		oProcess:Start()
		RastreiaWF("00001"+'.'+oProcess:fTaskID,"000001",'1006')
		//        oProcess:Finish()
	Endif
Else
	oProcess:cSubject := "Pedido Reprovado"
endif
PutMv("MV_WFHTML",cMvAtt)

Return


//////////////////////////////////////////////////////////
STATIC FUNCTION SPCIniciar( oProcess,lPrimeira )
Local cMvAtt := GetMv("MV_WFHTML")
Local aCond:={},nTotal := 0
Public nCotacao := 1

PutMv("MV_WFHTML","F")
lPrimeira := .T.
oProcess:NewTask( "Solicitação", "\WORKFLOW\HTML\WFW120P1.HTM" )
oProcess:cSubject := "Solicitacao Pedido de Compra"
oProcess:bReturn := "U_WFW120P( 1 )"
//	oProcess:bTimeOut := {{"U_WFW120P(2)", 0 ,0 ,2 }}
oHTML := oProcess:oHTML

/*** Preenche os dados do cabecalho ***/
oHtml:ValByName( "EMISSAO", SC7->C7_EMISSAO )
oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE )
dbSelectArea('SA2')
dbSetOrder(1)
dbSeek(xFilial('SA2')+SC7->C7_FORNECE)
oHtml:ValByName( "lb_nome", SA2->A2_NREDUZ )

//Procura nome do aprovador
dbSelectArea('SCR')
DBSETORDER(1)
dbSeek(xFilial('SCR') + SC7->C7_NUM)
cAprov   := SCR->CR_USER
//    CNivel   := SCR->CR_NIVEL
PswOrder(1)
IF PswSeek(cAprov,.t.)// .and. cAprov <> "000000"
	aInfo   := PswRet(1)
	cMailAp := alltrim(aInfo[1,14])
	cNomeAP := aInfo[1,2]
ENDIF

//Pego as condiicoes de Pagamento
dbSelectArea('SE4')
DBSETORDER(1)
dbSeek(xFilial('SE4') + SC7->C7_COND)
//While !Eof() .and. xFilial('SE4')==E4_FILIAL
//  aadd(aCond,"'"+E4_DESCRI+"'")
//  dbSkip()
//end
ccond := SE4->E4_DESCRI
oHtml:ValByName( "lb_cond", CCOND )

dbSelectArea('SC7')
oHtml:ValByName( "PEDIDO", SC7->C7_NUM )
cNum := SC7->C7_NUM
oProcess:fDesc := "Pedido de Compras No "+ cNum
nCotacao := 1

dbSetOrder(1)
dbSeek(xFilial('SC7')+cNum)
While !Eof() .and. C7_NUM = cNum
	nTotal := nTotal + C7_TOTAL
	AAdd( (oHtml:ValByName( "it.item" )),C7_ITEM )
	AAdd( (oHtml:ValByName( "it.codigo" )),C7_PRODUTO )
	dbSelectArea('SB1')
	dbSetOrder(1)
	dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
	dbSelectArea('SC7')
	AAdd( (oHtml:ValByName( "it.descricao" )),SB1->B1_DESC )
	AAdd( (oHtml:ValByName( "it.quant" )),TRANSFORM( C7_QUANT,'@E 999,999.99' ) )
	AAdd( (oHtml:ValByName( "it.preco" )),TRANSFORM( C7_PRECO,'@E 999,999.99' ) )
	AAdd( (oHtml:ValByName( "it.total" )),TRANSFORM( C7_TOTAL,'@E 999,999.99' ) )
	AAdd( (oHtml:ValByName( "it.unid" )),SB1->B1_UM )
	//AAdd( (oHtml:ValByName( "it.entrega" )),'0' )
	//AAdd( (oHtml:ValByName( "it.condPag" )),CCond )
	
	If Select("WFPC") > 0
		dbSelectArea("WFPC")
		dbCloseArea()
	Endif
	
	//Query busca Cotacoes do Produto
	cQuery := " SELECT TOP 3 C8_FORNECE, C8_LOJA, A2_NOME, C8_PRODUTO, B1_DESC, C8_QUANT "
	cQuery += " , C8_PRECO, C8_TOTAL, C8_COND, E4_DESCRI, C8_PRAZO "
	cQuery += " FROM SC8010 C8, SA2010 A2, SB1010 B1, SE4010 E4 "
	cQuery += " WHERE C8_EMISSAO	>= '20100101' "
	cQuery += " AND C8_FORNECE		= A2_COD "
	cQuery += " AND C8_LOJA			= A2_LOJA "
	cQuery += " AND C8_PRODUTO		= B1_COD "
	cQuery += " AND C8_COND			= E4_CODIGO "
	cQuery += " AND C8.D_E_L_E_T_	!= '*' "
	cQuery += " AND E4.D_E_L_E_T_	!= '*' "
	cQuery += " AND B1.D_E_L_E_T_	!= '*' "
	cQuery += " AND A2.D_E_L_E_T_	!= '*' "
	cQuery += " AND E4_FILIAL		= ' ' "
	cQuery += " AND C8_PRECO		!= 0 "
	cQuery += " AND C8_PRODUTO		= '" +SC7->C7_PRODUTO+ "' "
	cQuery += " ORDER BY C8_PRECO, C8_PRAZO, E4_DESCRI "
	
	MemoWrit("WFPC.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"WFPC", .F., .T.)
	
	////////////////////
	IF nCotacao == 1
		AAdd(oHtml:ValByName("li.cotacoes")		, "<td colspan=7 width=498 height=22><p align=Left><b><font color=#0000FF face=Arial>Cotações</font></p></b></td><tr>")
		AAdd(oHtml:ValByName("li.fornecedor")	, "<td align=left width=62  bgcolor=#DFEFFF height=18><font face=Arial>Fornecedor</font></td>")
		AAdd(oHtml:ValByName("li.nome")			, "<td align=left width=190 bgcolor=#DFEFFF height=18><font face=Arial>Nome</font></td>")
		AAdd(oHtml:ValByName("li.quantidade")	, "<td align=left width=86  bgcolor=#DFEFFF height=18><font face=Arial>Quantidade</font></td>")
		AAdd(oHtml:ValByName("li.vlrunit")		, "<td align=left width=73  bgcolor=#DFEFFF height=18><font face=Arial>Vlr.Unit</font></td>")
		AAdd(oHtml:ValByName("li.vlrtot")	   	, "<td align=left width=87  bgcolor=#DFEFFF height=18><font face=Arial>Vlr.Total</font></td>")
		AAdd(oHtml:ValByName("li.condpagto")   	, "<td align=left width=101 bgcolor=#DFEFFF height=18><font face=Arial>Cond.Pagto</font></td>")
		AAdd(oHtml:ValByName("li.prazoentrega")	, "<td align=left width=151 bgcolor=#DFEFFF height=18><font face=Arial>Prazo_Entrega</font></td>")
		nCotacao := 2
	ENDIF
	
	
	// COTACAO DE PRECOS
	DBSELECTAREA("WFPC")
	DBGOTOP()
	
	WHILE !EOF()
		AAdd(oHtml:ValByName("c8.fornece")		,WFPC->C8_FORNECE )
		AAdd(oHtml:ValByName("c8.fnome")		,WFPC->A2_NOME )
		AAdd(oHtml:ValByName("c8.quant")		,TRANSFORM(WFPC->C8_QUANT,'@E 999,999.99'))
		AAdd(oHtml:ValByName("c8.preco")		,TRANSFORM(WFPC->C8_PRECO,'@E 999,999.99'))
		AAdd(oHtml:ValByName("c8.total")		,TRANSFORM(WFPC->C8_TOTAL,'@E 999,999.99'))
		AAdd(oHtml:ValByName("c8.condpag")		,WFPC->E4_DESCRI )
		AAdd(oHtml:ValByName("c8.prent") 		,WFPC->C8_PRAZO )
		
		DBSELECTAREA("WFPC")
		dbSkip()
	Enddo
	
	
	RecLock('SC7')
	C7_WFID := oProcess:fProcessID
	C7_FILENT := C7_FILIAL
	MsUnlock()
	dbSkip()
Enddo

oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
oHtml:ValByName( "lbFrete" ,TRANSFORM( 0,'@E 999,999.99' ) )
oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
oProcess:ClientName( Subs(cUsuario,7,15) )
//oProcess:cTo := "mauro@linciplas.com.br"
oProcess:cTo := "thiago@stch.com.br"

//oProcess:UserSiga := "000004"
oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')

oProcess:Start()
RastreiaWF("00001"+'.'+oProcess:fTaskID,"000001",'1005')
wfSendMail()
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Processo do Pedido '+cNum+' iniciado!' )

PutMv("MV_WFHTML",cMvAtt)

Return

/////////////////////////////////////////////////////////////////////////////////QQ
STATIC FUNCTION SPCTimeOut( oProcess )
Local cMvAtt := GetMv("MV_WFHTML")

PutMv("MV_WFHTML","F")
ConOut("Funcao de TIMEOUT executada")
oProcess:NewTask('Time Out',"\workflow\HTML\timeout.htm")
oHtml:=oProcess:oHtml
oHtml:RetByName("Titulo","Usuario nao respondeu e-mail")
oHtml:RetByName("numPed",_cPedido)
oHtml:RetByName("cliente",_ccliente)
_cUser = Subs(cUsuario,7,15)
oHtml:RetByName("usuario",_cUser)
subj := "Pedido"+ _cPedido + " por " + _ccliente
oProcess:Start()
WFSendMail()

PutMv("MV_WFHTML",cMvAtt)

Return

////////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION TestProcess(oProc)
Local cMvAtt := GetMv("MV_WFHTML")

PutMv("MV_WFHTML","F")
//Prepare Environment Empresa '99' Filial '01'
//Proc:oHtml:valByName('botoes',"")

oHTML := oProc:oHTML
ConOut("abe")
//oProc:cTo := "mauro@linciplas.com.br"	//vendedor
oProc:cTo := "thiago@stch.com.br"	//vendedor
//oProcess:cBody := 'Processo do Pedido: '+oProc:oHTML:RetByName('Pedido')+' concluido!'

oProc:Start()
WFSendMail()
//RastreiaWF(oProc:fProcessID+'.'+oProc:fTaskID,oProc:fProcCode,'1003','Finalizando Processo',Subs(cUsuario,7,15))

PutMv("MV_WFHTML",cMvAtt)

Return .T.

//////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION SeekEml(cAprovador)
//Local cMvAtt := GetMv("MV_WFHTML")

//PutMv("MV_WFHTML","F")
PswOrder(1)
IF PswSeek(cAprovador,.t.)
	aInfo   := PswRet(1)
	cMailAp := alltrim(aInfo[1,14])
	conout ("Email do Aprovador" + cMailAp)
ENDIF
//PutMv("MV_WFHTML",cMvAtt)
RETURN
