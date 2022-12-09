#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVNDA450บAutor  ณDarcio R. Sporl     บ Data ณ  11/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada para fazer a verificacao dos pedidos no siste-บฑฑ
ฑฑบ          ณma GAR. Funcao chamada por Gatilho no campo ZF_PEDIDO.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cCampo  - Campo que vai receber o conteudo do gatilho      บฑฑ
ฑฑบ          ณ cPedido - Numero do Pedido GAR                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs x Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VNDA450(cCampo, cPedido)

Local aArea		:= GetArea()
Local cACDesc	:= ""
Local cARDesc	:= "" 
Local cARId		:= ""
Local cDataVal	:= ""
Local cDataVer	:= ""
Local cMailTit	:= ""
Local cNAgeVal	:= ""
Local cNAgeVer	:= ""
Local cNomTit	:= ""
Local cPosVal	:= ""
Local cPosVer	:= ""
Local cProduto	:= ""
Local cProDes	:= ""
Local cStatus	:= ""
Local cStaDes	:= ""
Local cCpfAgVal	:= ""
Local cCpfAgVer	:= ""
Local cCpfTit	:= ""
Local cPeido	:= ""
Local cPosValId	:= ""
Local cPosVerId	:= ""
Local lVNDA620	:= IsInCallStack("U_VNDA620")  // Rotina de emissใo de Voucher para renova็ใo
Local oObj

If !lVNDA620
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama o WebService do sistema GARณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oWSObj := WSIntegracaoGARERPImplService():New()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama a Verificacao de Pedidosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oWSObj:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
							eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
							Val( cPedido ) )
	
	If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U"
		cACDesc		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC)
	Else
		cACDesc		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U"
		cARDesc		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC)
	Else
		cARDesc		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U"
		cARId		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARID)
	Else
		cARId		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U"
		cDataVal	:= CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10))
	Else
		cDataVal	:= CtoD("  /  /  ")
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U"
		cDataVer	:= CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10))
	Else
		cDataVer	:= CtoD("  /  /  ")
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) <> "U"
		cMailTit	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR)
	Else
		cMailTit	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U"
		cNAgeVal	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO)
	Else
		cNAgeVal	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U"
		cNAgeVer	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO)
	Else
		cNAgeVer	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U"
		cNomTit		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR)
	Else
		cNomTit		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U"
		cPosVal		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC)
	Else
		cPosVal		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC) <> "U"
		cPosVer		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC)
	Else
		cPosVer		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
		cProduto	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
	Else
		cProduto	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U"
		cProDes		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC)
	Else
		cProDes		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CSTATUS) <> "U"
		cStatus		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CSTATUS)
	Else
		cStatus		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:CSTATUSDESC) <> "U"
		cStaDes		:= AllTrim(oWSObj:OWSDADOSPEDIDO:CSTATUSDESC)
	Else
		cStaDes		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO) <> "U"
		cCpfAgVal	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO))
	Else
		cCpfAgVal	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO) <> "U"
		cCpfAgVer	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO))
	Else
		cCpfAgVer	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR) <> "U"
		cCpfTit		:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR))
	Else
		cCpfTit		:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U"
		cPosValId	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID))
	Else
		cPosValId	:= ""
	EndIf
	If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U"
		cPosVerId	:= AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID))
	Else
		cPosVerId	:= ""
	EndIf
	
	If "ZF_AC" $ cCampo
		Return(cACDesc)
	ElseIf "ZF_AR" $ cCampo
		Return(cARDesc)
	ElseIf "ZF_CDPRGAR" $ cCampo
		Return(cProduto)
	ElseIf "ZF_CGCCLI" $ cCampo
		If Len(cCpfTit) == 14
			cCpfTit := Transform(cCpfTit, "@R 99.999.999/9999-99")
		Else
			cCpfTit := Transform(cCpfTit, "@R 999.999.999-99")
		EndIf
		Return(cCpfTit)
	ElseIf "ZF_NOMCLI" $ cCampo
		Return(cNomTit)
	ElseIf "ZF_DTVLPGO" $ cCampo        
		Return(cDataVal)
	ElseIf "ZF_CODSTAT" $ cCampo
		Return(cStatus)
	ElseIf "ZF_STCERPD" $ cCampo
		Return(cStaDes)
	Elseif "" $ AllTrim(cCampo) //#1
		Return(cNomTit) 
	EndIf
Else
	Return("") 
Endif

RestArea(aArea)
Return(cPedido)
