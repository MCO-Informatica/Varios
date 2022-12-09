#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaFila  �Autor  �Darcio R. Sporl     � Data �  05/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para criar e controlar a fila de pedidos inclui���
���          �do pelo site.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
		//���������������������������������������������������������������������������������Ŀ
		//�Cria na tabela GTIN o registro da fila, para todos os pedidos gerados pelo site. �
		//�����������������������������������������������������������������������������������
		U_GTPutIN(cID,"F",cNpSite,.F.,{"U_CriaFila",cNpSite,aPedidos[nPed]})
	
	Next nPed
	
	lRet := File(cArquivo)
	
	If lRet
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.T.,"M00001","","Realizada Criacao de Fila com Sucesso"}})
	Else
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00001","","Fila Geral Criada, mas, Arquivo n�o foi criado."+CRLF+" C�difo de ERRO para Cria��o de Arquivo em Disco :"+Str(fError(),4)}})
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
	U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00001","","Inconsist�ncia ao Criar Fila Geral "+CRLF+cErrorMsg}})
Endif

RestArea(aArea)
Return