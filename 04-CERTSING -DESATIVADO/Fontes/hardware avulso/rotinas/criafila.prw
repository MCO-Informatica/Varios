#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaFila  บAutor  ณDarcio R. Sporl     บ Data ณ  05/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte criado para criar e controlar a fila de pedidos incluiบฑฑ
ฑฑบ          ณdo pelo site.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs x Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CriaFila(cXml, cID)
Local aArea		:= GetArea()
Local cRootPath	:= ""
Local nHandle	:= 0
Local oXml		:= Nil
Local aPedidos	:= {}
Local nPed		:= 0
Local cError	:= ""
Local cWarning	:= ""
Local cArquivo	:= ""

//TRATAMENTO PARA ERRO FATAL NA THREAD
cErrorMsg := ""
bOldBlock := ErrorBlock({|e| U_ProcError(e) })

BEGIN SEQUENCE

	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
	cRootPath	:= cRootPath + "vendas_site\"
	cArquivo	:= cRootPath + "Pedidos_" + AllTrim(cID) + ".XML"
	
	nHandle := FCreate(cArquivo)
	
	If nHandle >= 0
		FWrite(nHandle, cXml)
	EndIf
	
	FClose(nHandle)
	
	oXml := XmlParser( cXml, "_", @cError, @cWarning )
	
	If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
	EndIf
	
	aPedidos := aClone(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO)
	
	For nPed := 1 To Len(aPedidos)
		cNpSite := aPedidos[nPed]:_NUMERO:TEXT
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria na tabela GTIN o registro da fila, para todos os pedidos gerados pelo site. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_GTPutIN(cID,"F",cNpSite,.F.,{"U_CriaFila",cNpSite,aPedidos[nPed]})
	
	Next nPed
	
	lRet := File(cArquivo)
	
	If lRet
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.T.,"M00001","","Realizada Criacao de Fila com Sucesso"}})
	Else
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00001","","Fila Geral Criada, mas, Arquivo nใo foi criado."+CRLF+" C๓difo de ERRO para Cria็ใo de Arquivo em Disco :"+Str(fError(),4)}})
	EndIF
END SEQUENCE
			
If InTransact()
// Esqueceram transacao aberta ... Fecha fazendo commit ...
	Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***")
	EndTran()
Endif

ErrorBlock(bOldBlock)

cErrorMsg := U_GetProcError()

If !empty(cErrorMsg)
	U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00001","","Inconsist๊ncia ao Criar Fila Geral "+CRLF+cErrorMsg}})
Endif

RestArea(aArea)
Return