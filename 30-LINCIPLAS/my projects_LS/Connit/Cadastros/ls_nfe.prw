/*

<infNFe versao="T01.00"><ide><cUF>35</cUF><cNF>00559875</cNF><natOp>DEVOL.COMP.S/I C/E</natOp><indPag>2</indPag><serie>8</serie><nNF>2345</nNF><dEmi>2011-01-27</dEmi><dSaiEnt>2011-01-27</dSaiEnt><hSaiEnt>08:43:00</hSaiEnt><tpNF>1</tpNF><NFRef><RefNF><cUF>35</cUF><AAMM>1012</AAMM><CNPJ>04025742000122</CNPJ><mod>01</mod><serie>1</serie><nNF>8963</nNF><cNF>005666313</cNF></RefNF></NFRef><tpNFe>1</tpNFe></ide><emit><CNPJ>53928891000107</CNPJ><Nome>LASELVA COM. LIVROS E ART. DE CONV. LTDA</Nome><Fant>LASELVA</Fant><enderEmit><Lgr>RUA GOMES DE CARVALHO</Lgr><nro>1467</nro><Bairro>VILA OLIMPIA</Bairro><cMun>3550308</cMun><Mun>SAO PAULO</Mun><UF>SP</UF><CEP>04547005</CEP><cPais>1058</cPais><Pais>BRASIL</Pais><fone>21862544</fone></enderEmit><IE>111177014111</IE><CRT>3</CRT></emit><dest><CNPJ>04025742000122</CNPJ><Nome>JOAO CARLOS GOMES BRASIL EPP</Nome><enderDest><Lgr>RUA JOSE DE SOUZA COSTA</Lgr><nro>107</nro><Bairro>PQ. SAO LAGUNA</Bairro><cMun>3552809</cMun><Mun>TABOAO DA SERRA</Mun><UF>SP</UF><CEP>06795010</CEP><cPais>1058</cPais><Pais>BRASIL</Pais><fone>1146122852</fone></enderDest><IE>278164138111</IE><EMAIL>vivane@jclivros.com.br; joaocarlos@jclivros.com.br</EMAIL></dest><det nItem="1"><prod><cProd>1021054</cProd><ean>9788575209332</ean><Prod>POLLY POCKET - MALETA</Prod><NCM>49011000</NCM><CFOP>5202</CFOP><uCom>UN</uCom><qCom>10.0000</qCom><vUnCom>6.4500</vUnCom><vProd>64.50</vProd><eantrib>9788575209332</eantrib><uTrib>UN</uTrib><qTrib>10.0000</qTrib><vUnTrib>6.4500</vUnTrib><indTot>1</indTot></prod><imposto><codigo>ICMS</codigo><cpl><orig>0</orig></cpl><Tributo><CST>40</CST><modBC>3</modBC><vBC>0</vBC><aliquota>0</aliquota><valor>0</valor><qtrib>0</qtrib><vltrib>0</vltrib></Tributo></imposto><imposto><codigo>ICMSST</codigo><cpl><pmvast>0</pmvast></cpl><Tributo><CST>40</CST><modBC>0</modBC><pRedBC>0</pRedBC><vBC>0</vBC><aliquota>0</aliquota><valor>0</valor><qtrib>0</qtrib><vltrib>0</vltrib></Tributo></imposto><imposto><codigo>IPI</codigo><Tributo><cpl><cEnq>999</cEnq></cpl><CST></CST><modBC>3</modBC><pRedBC>0</pRedBC><vBC>0</vBC><aliquota>0</aliquota><vlTrib>0</vlTrib><qTrib>0</qTrib><valor>0</valor></Tributo></imposto><imposto><codigo>PIS</codigo><Tributo><CST>08</CST><modBC></modBC><pRedBC></pRedBC><vBC>0</vBC><aliquota>0</aliquota><vlTrib>0</vlTrib><qTrib>0</qTrib><valor>0</valor></Tributo></imposto><imposto><codigo>COFINS</codigo><Tributo><CST>08</CST><modBC></modBC><pRedBC></pRedBC><vBC>0</vBC><aliquota>0</aliquota><vlTrib>0</vlTrib><qTrib>0</qTrib><valor>0</valor></Tributo></imposto><infadprod></infadprod></det><total><vBC>0</vBC><vICMS>0</vICMS><vBCST>0</vBCST><vICMSST>0</vICMSST><despesa>0</despesa><vNF>64.50</vNF></total><transp><modFrete>1</modFrete></transp><infAdic><Cpl>[ContrTSS=2011-02-17#13:58:20#varaujo]Dev. referente ao pedido 602826 NF 8963 Emissao Original NF-e: 1   000008963 30-12-2010, </Cpl></infAdic><compra><nEmp></nEmp><Pedido></Pedido><Contrato></Contrato></compra></infNFe>'

*/

User Function LS_NFE()

If !Pergunte(FunName())
	Return()
EndIf

If !file('v:\protheus_data\nfe\nfe_' + alltrim(mv_par01) + '.xml')
	ALERT('ARQUIVO NÃO ENCONTRADO')
    return()
 EndIf
 
_cXML := memoread('v:\protheus_data\nfe\nfe_' + alltrim(mv_par01) + '.xml')
_cTXT := ''

_nPos := at('<cNF>',_cXML)
_cNf := substr(_cXML,_nPos+5)
_nPos := at('</cNF>',_cNf)
_cNf := left(_cNF,_nPos-1)
  
Processa({|| RunProc()})

Return()

Static Function RunProc()

ProcRegua(len(_cXML))

Do while len(_cXML) > 0
	IncProc()	
	_nPosic := at('><',_cXML)
	If _nPosic > 0
		If substr(_cXML,_nPosic+1,2) <> '</'
			_cTXT += left(_cXML,_nPosic) + _cEnter
		EndIf
		_cXML := substr(_cXML,_nPosic+1)
	Else
		_cTXT += _cXML
		_cXML := ''
	EndIf                     
	
EndDo

memowrit('v:\protheus_data\nfe\nf_' + _cNf + '.txt',_cTXT)

Return()
