#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVNDA130  บAutor  ณDarcio R. Sporl     บ Data ณ  05/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte criado para criar e controlar a fila de pedidos incluiบฑฑ
ฑฑบ          ณdo pelo site.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs x Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VNDA130(cXml, cID, cGetError)

Local aArea		:= GetArea()
Local cRootPath	:= ""


Local cError	:= ""
Local cWarning	:= ""
Local cArquivo	:= ""
Local cPedGar	:= ""
Local bVldPed	:= {|a,b| IIf(!Empty(a),a,b)}

Local cCGCCon   := ''
Local cCGCFat   := ''
Local cOrigVen  := ''
Local cNpEcomm	:= ''
Local aCheckOut := Array( 3 )

Local nPed 		:= 0
Private aPedidos	:= {}
Private oXml		:= Nil

cGetError := "Lista de Pedidos recebida com sucesso."
cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
cRootPath	:= cRootPath  + GetNewPar("MV_HDAGRXM", "\vendas_site\")

If !ExistDir(cRootPath)
	If MakeDir(cRootPath) <> 0		// Retorna zero (0), se o diret๓rio for criado com sucesso
		cGetError := "A pasta para grava็ใo do arquivo XML nใo existe e nใo foi possํvel criar automaticamente --> " + cRootPath
		Return(.F.)
	Endif
Endif

oXml := XmlParser( cXml, "_", @cError, @cWarning )

If Empty(cError)
	
	cID 		:=  Left(cID,12)+UPPER(SubStr(Md5(cXml),1,5))
	cArquivo	:= cRootPath + "Pedidos_" + AllTrim(cID) + ".XML"
	
	While File(cArquivo,1)
		cID 	:=  Left(cID,12)+SubStr(UPPER(Md5(cXml+StrZero(Seconds(),5))),1,5)
		cArquivo:= cRootPath + "Pedidos_" + AllTrim(cID) + ".XML" 
	EndDo
	
	MemoWrite(cArquivo,cXml)
	
	U_GTPutIN(cID,"F",cID,.T.,{"Recebida Fila com Sucesso"})

	If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
	EndIf
	
	aPedidos 	:= aClone(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO)
	cNpSite 	:= ""
	cPedGar		:= ""
	cPedLog		:= ""
	cNpEcomm	:= ""

	For nPed := 1 To Len(aPedidos)
		If !Empty(cNpSite) .and.  cNpSite == aPedidos[nPed]:_NUMERO:TEXT
			lCont := .F.
		Else
			lCont := .T.
		EndIf
		
		If lCont
			cNpSite := aPedidos[nPed]:_NUMERO:TEXT
			cPedGar	:= "" 
			If Type( "aPedidos["+Str(nPed)+"]:_NUMEROPEDIDOGAR:TEXT" ) <> "U"
				cPedGar	:=iif(alltrim(aPedidos[nPed]:_NUMEROPEDIDOGAR:TEXT)=='0',"",alltrim(aPedidos[nPed]:_NUMEROPEDIDOGAR:TEXT))
			EndIf
			cPedLog	:= Eval(bVldPed,cPedGar,cNpSite)
			
			//Solicita็ใo OTRS[2018062710000744] - Projeto RightNow
			//CPF do Contato
			cCGCCon := aPedidos[nPed]:_CONTATO:_CPF:TEXT

			//CPF-CNPJ da Fatura
			IF Type( "aPedidos["+Str(nPed)+"]:_FATURA:_XSI_TYPE:TEXT" ) <> "U"
				IF "PF" $ aPedidos[nPed]:_FATURA:_XSI_TYPE:TEXT
					cCGCFat := aPedidos[nPed]:_FATURA:_CPF:TEXT
				Else
					cCGCFat := aPedidos[nPed]:_FATURA:_CNPJ:TEXT
				EndIF
			EndIF
			//Origem de venda
			cOrigVen := ""
			If Type( "aPedidos["+Str(nPed)+"]:_ORIGEMVENDA:TEXT" ) <> "U"
				cOrigVen := aPedidos[nPed]:_ORIGEMVENDA:TEXT
			EndIf
			aCheckOut[ 1 ]  := cCGCCon
			aCheckOut[ 2 ]  := cCGCFat
			aCheckOut[ 3 ]  := cOrigVen
			
			cNpEcomm := ''
			IF Type( "aPedidos["+Str(nPed)+"]:_PEDIDOECOMMERCE:TEXT" ) <> "U"
				cNpEcomm := aPedidos[nPed]:_PEDIDOECOMMERCE:TEXT
			EndIF
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCria na tabela GTIN o registro da fila, para todos os pedidos gerados pelo site. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			U_GTPutIN(cID+StrZero(nPed,6),"F",cPedLog,.F.,{"U_VNDA130",cPedLog,aPedidos[nPed]},cNpSite,,,aCheckOut,cNpEcomm)
		EndIf
		cCGCCon  := ''
		cCGCFat  := ''
		cOrigVen := ''
	Next nPed
	
	If !File(cArquivo)
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00006","","Fila Geral Criada, mas, Arquivo nใo foi criado."+CRLF+" C๓difo de ERRO para Cria็ใo de Arquivo em Disco :"+Str(fError(),4)}})
		cGetError := "Erro de permissใo para grava็ใo do arquivo XML no RootPath do Servidor --> " + cArquivo
		Return(.F.)
	Else
		U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.T.,"M00001","","Realizada Criacao de Fila com Sucesso"}})
	Endif
Else
	U_GTPutOUT(cID,"F","",{"CRIFILAALL",{.F.,"E00007","","Encontrados Erros no Processamento da Fila Geral: "+cError }})
EndIf

RestArea(aArea)

Return(.T.)