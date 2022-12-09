#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "MSMGADD.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCERTXML   บAutor  ณDavid (Opvs)        บ Data ณ  09/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para manipula็ao de Xml de Pedidos de Venda Site   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CertXml(cID,cNpSite)
Local cRootPath	:= ""
Local cArquivo	:= ""
Local cError	:= ""
Local cWarning	:= ""
Local oXml				
Local oXmlPed	
Local oFolder
Local oDlg
Local nPed		:= 0 
Local aButtons	:= {}
Local aCoord	:= FwGetDialogSize( oMainWnd )
Local cXmlPed	:= ""
Local nOpca		:= 2

cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath
cRootPath	:= cRootPath + "vendas_site\"

cArquivo	:= "Pedidos_" + cID + ".XML"
cArquivo	:= cRootPath + cArquivo

If !File(cArquivo) 

	MsgStop("Nใo Existe Arquivo XML para Registro Selecionado.")
	Return(.F.)

EndIf

oXml		:= XmlParserFile( cArquivo, "_", @cError, @cWarning )

If !Empty(cError)
	
	MsgStop("Foram Encontradas Inconsist๊ncia no Arquivo XML")
	
	Aviso("XML", cError , {"OK"},3) 
	
	Return(.F.)

EndIf

If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
	XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
EndIf

For nPed := 1 to Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO)

	If cNpSite == AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMERO:TEXT)
		oXmlPed := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed] 
		Exit	
	EndIf

Next

DEFINE MSDIALOG oDlg TITLE "Manuten็ใo Pedido Site" FROM aCoord[1],aCoord[2] TO aCoord[3], aCoord[4] PIXEL

EnchoiceBar(oDlg, {|| nOpca := 1, oDlg:End() }, {|| nOpca := 2,oDlg:End() },,aButtons)

// Cria Objeto de Layer
oLayer := FWLayer():New()
oLayer:Init(oDlg,.F.,.T.) 

//Monta as Janelas
oLayer:addLine("LINHA1", 100, .F.)

//FATURA
oLayer:AddCollumn("Jan1",100,.F.,"LINHA1")
oLayer:AddWindow("Jan1","oJan1","Dados do Pedido ",100,.T.,.F.,{ || },"LINHA1",{|| })
oJan1 := oLayer:GetWinPanel("Jan1","oJan1","LINHA1")  

oTreePed 		:= xTree():New(0,0,0,0,oJan1)
oTreePed:Align 	:= CONTROL_ALIGN_ALLCLIENT

oTreePed:AddTree("Pedido "+cNpSite, "FOLDER5","FOLDER6","ID_PRINCIPAL",,,{||})

	//Dados de Contato
	oTreePed:TreeSeek("Contato")
	oTreePed:AddTree("Contato","BMPVISUAL","BMPVISUAL","contato",,,)
		oTreePed:AddTreeItem("Cpf ou Cgc	: "+oXmlPed:_CONTATO:_CPF:TEXT,"CHECKED","1.1",,,	{|| oXmlPed:_CONTATO:_NOME:TEXT 	:= AltPrompt(@oTreePed,"1.1","CPF ou CGC	: ",oXmlPed:_CONTATO:_CPF:TEXT) 	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT 	:= oXmlPed:_CONTATO:_CPF:TEXT 	})
		oTreePed:AddTreeItem("Email			: "+oXmlPed:_CONTATO:_EMAIL:TEXT,"CHECKED","1.2",,,{|| oXmlPed:_CONTATO:_EMAIL:TEXT 	:= AltPrompt(@oTreePed,"1.2","EMAIL			: ",oXmlPed:_CONTATO:_EMAIL:TEXT)	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT 	:= oXmlPed:_CONTATO:_EMAIL:TEXT	})
		oTreePed:AddTreeItem("Fone			: "+oXmlPed:_CONTATO:_FONE:TEXT,"CHECKED","1.3",,,	{|| oXmlPed:_CONTATO:_FONE:TEXT 	:= AltPrompt(@oTreePed,"1.3","FONE			: ",oXmlPed:_CONTATO:_FONE:TEXT)  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT	:= oXmlPed:_CONTATO:_FONE:TEXT	})
		oTreePed:AddTreeItem("Nome			: "+oXmlPed:_CONTATO:_NOME:TEXT,"CHECKED","1.4",,,	{|| oXmlPed:_CONTATO:_NOME:TEXT		:= AltPrompt(@oTreePed,"1.4","NOME			: ",oXmlPed:_CONTATO:_NOME:TEXT)  	, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT 	:= oXmlPed:_CONTATO:_NOME:TEXT	})
	oTreePed:EndTree() 
	
	//Dados de Faturamento
	oTreePed:TreeSeek("Fatura")
	oTreePed:AddTree("Fatura","BMPVISUAL","BMPVISUAL","fatura",,,)
		oTreePed:AddTreeItem("Data			: "+oXmlPed:_DATA:TEXT,"UNCHECKED","2.1",,,)		
		
		//Valida informa็๕es de PF ou PJ
		If "PF" $ oXmlPed:_FATURA:_XSI_TYPE:TEXT
        	oTreePed:AddTreeItem("Nome			: "+oXmlPed:_FATURA:_NOME:TEXT,"UNCHECKED","2.2",,,)		
        	oTreePed:AddTreeItem("Cpf			: "+oXmlPed:_FATURA:_CPF:TEXT,"UNCHECKED","2.3",,,)
		Else
			oTreePed:AddTreeItem("Razใo Social	: "+oXmlPed:_FATURA:_RZSOCIAL:TEXT,"UNCHECKED","2.2",,,)
			oTreePed:AddTreeItem("Cnpj			: "+oXmlPed:_FATURA:_CNPJ:TEXT,"UNCHECKED","2.4",,,)
			oTreePed:AddTreeItem("Inscr. Est.	: "+oXmlPed:_FATURA:_INSCEST:TEXT ,"CHECKED","2.5",,,	{|| oXmlPed:_FATURA:_INSCEST:TEXT 	:= AltPrompt(@oTreePed,"2.5","Inscr. Est.	: ",oXmlPed:_FATURA:_INSCEST:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCEST:TEXT 	:= oXmlPed:_FATURA:_INSCEST:TEXT 	})
			oTreePed:AddTreeItem("Inscr. Mun.	: "+oXmlPed:_FATURA:_INSCMUN:TEXT,"CHECKED","2.6",,,	{|| oXmlPed:_FATURA:_INSCMUN:TEXT 	:= AltPrompt(@oTreePed,"2.6","Inscr. Mun.	: ",oXmlPed:_FATURA:_INSCMUN:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCMUN:TEXT	:= oXmlPed:_FATURA:_INSCMUN:TEXT 	})
			oTreePed:AddTreeItem("Suframa		: "+oXmlPed:_FATURA:_SUFRAMA:TEXT,"CHECKED","2.7",,,	{|| oXmlPed:_FATURA:_SUFRAMA:TEXT 	:= AltPrompt(@oTreePed,"2.7","Suframa		: ",oXmlPed:_FATURA:_SUFRAMA:TEXT), oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_SUFRAMA:TEXT 	:= oXmlPed:_FATURA:_SUFRAMA:TEXT 	})
		EndIf
		
		oTreePed:AddTreeItem("Email			: "+oXmlPed:_FATURA:_EMAIL:TEXT,"UNCHECKED","2.8",,,)
		oTreePed:AddTreeItem("Bairro		: "+oXmlPed:_FATURA:_ENDERECO:_BAIRRO:TEXT,"UNCHECKED","2.9",,,)
		oTreePed:AddTreeItem("Numero		: "+oXmlPed:_FATURA:_ENDERECO:_NUMERO:TEXT,"UNCHECKED","2.10",,,)                                                                                                              
		oTreePed:AddTreeItem("CEP			: "+oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT,"CHECKED","2.11",,,{|| oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT 	:= AltPrompt(@oTreePed,"2.11","CEP			: ",oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT) , oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 	:= oXmlPed:_FATURA:_ENDERECO:_CEP:TEXT	})  
		oTreePed:AddTreeItem("Cidade		: "+oXmlPed:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT,"UNCHECKED","2.12",,,)
		oTreePed:AddTreeItem("Estado		: "+oXmlPed:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT,"UNCHECKED","2.13",,,)
		oTreePed:AddTreeItem("Ccomplemento	: "+oXmlPed:_FATURA:_ENDERECO:_COMPL:TEXT,"UNCHECKED","2.14",,,)
		oTreePed:AddTreeItem("Logradouro	: "+oXmlPed:_FATURA:_ENDERECO:_DESC:TEXT,"UNCHECKED","2.15",,,)
		oTreePed:AddTreeItem("Fone			: "+oXmlPed:_FATURA:_ENDERECO:_FONE:TEXT,"UNCHECKED","2.16",,,)
		
	oTreePed:EndTree()
	
	//Dados de Pagamento
	oTreePed:TreeSeek("Pagamento")
	oTreePed:AddTree("Pagamento","BMPVISUAL","BMPVISUAL","pagamento",,,)
	
	//Forma de Pagamento
	If "cartao" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
		oTreePed:AddTreeItem("Cartใo	:"+oXmlPed:_PAGAMENTO:_NUMERO:TEXT,"UNCHECKED","3.1",,,)
		oTreePed:AddTreeItem("Titular	:"+oXmlPed:_PAGAMENTO:_NMTITULAR:TEXT,"UNCHECKED","3.2",,,)
		oTreePed:AddTreeItem("Validade	:"+CtoD(oXmlPed:_PAGAMENTO:_DTVALID:TEXT),"UNCHECKED","3.3",,,)
		oTreePed:AddTreeItem("Tipo  	:"+oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT,"UNCHECKED","3.4",,,)
	ElseIf "boleto" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
		oTreePed:AddTreeItem("Boleto	:"+oXmlPed:_PAGAMENTO:_LINHADIGITAVEL:TEXT,"UNCHECKED","3.1",,,)
	ElseIf "voucher" $ oXmlPed:_PAGAMENTO:_XSI_TYPE:TEXT
		oTreePed:AddTreeItem("Voucher	:"+oXmlPed:_PAGAMENTO:_NUMERO:TEXT,"UNCHECKED","3.1",,,)
		oTreePed:AddTreeItem("Qtd		:"+oXmlPed:_PAGAMENTO:_QTCONSUMIDA:TEXT,"UNCHECKED","3.2",,,)			
	EndIf
	
	oTreePed:EndTree()
		
oTreePed:EndTree()

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1

	If File(cArquivo) .and. _CopyFile(cArquivo,SubStr(cArquivo,1,Len(cArquivo)-4)+"_"+DtoS(Date())+"_"+StrTran(Time(),":","")+".XML")
	
		Ferase(cArquivo)
	
		SAVE oXml XMLFILE cArquivo

    Else

    	MsgStop("Inconsist๊ncias ao Salvar o arquivo XML")
		Return(.F.)	

    EndIf
EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltPrompt บAutor  ณDavid (Opvs)        บ Data ณ  09/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que Altera do dados no objeto tree                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltPrompt(oTree,cCargo,cSay,cGet)
Local cRet 		:= ""
Local cAux		:= cGet
Local nOpca		:= 2
Local oSay
Local oGet

DEFINE MSDIALOG oDlg TITLE "Altera็ใo de Dados" FROM 008.2,003.3 TO 016,055 OF GETWNDDEFAULT()

@ 00,1 Say oSay Prompt cSay Size 160,10 of oDlg Color CLR_HBLUE
@ 00,10 MsGet oGet var cGet Size 070,10 of oDlg 

TButton():New(38,20		,"Confirmar",,{|| nOpca:=1, oDlg:End() },040,012,,,,.T.)
TButton():New(38,140	,"Cancelar",,{|| nOpca:=2, oDlg:End() },040,012,,,,.T.)

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	
	oTree:ChangePrompt(cSay+cGet,cCargo) 
	
	cRet	:= cGet	
Else

	cRet 	:= cAux
		
EndIf

Return(cRet)