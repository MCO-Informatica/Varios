//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS             | Jira     | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 01/04/2020 | Bruno Nunes   | Implementado a leitura da tag IBGE para endereco de entrega e passar a funcao    | 1.00   |                  |          | 
//|            |               | vnda110, pelo array aDadEnt posicao 8.                                           |	       |                  |          | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 03/04/2020 | Bruno Nunes   | Implementado controle de gerar endereco de entrega quando o tipo de servico      | 1.01   |                  |          | 
//|            |               | é retirado na loja                                                               |	       |                  |          | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 03/04/2020 | Bruno Nunes   | Retirada a chamada U_VNDA740( cPedGar, cNpSite )                                 | 1.02   |                  |          | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 15/04/2020 | Bruno Nunes   | Feita a gravacao do CEP de entrega na PA7                                        | 1.03   |                  |          | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 15/05/2020 | Bruno Nunes   | - Tratar quando o produto for um kit mas no XML não esta preenchido o a          | 1.04   | 2020042710002840 | PROT-6   | 
//|            |               | TAG <CODCOMBO>                                                                   |	       |                  |          | 
//|            |               | - Controle de mensageria caso queria pegar informações da classe sem debugar     |	       |                  |          | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 18/06/2020 | Bruno Nunes   | - Tratamento para desconto no item do produto e falhas gerais.                   | 1.05   |                  | PROT-27  | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 26/06/2020 | Bruno Nunes   | - Tratamento para entrar Voucher corretamente.                                   | 1.06   |                  | PROT-    | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 21/07/2020 | Bruno Nunes   | Revisão do processo de  fluxo de voucher / negativo.                             | 1.07   |                  | PROT-89  | 
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 
//| 22/06/2020 | Bruno Nunes   | Implatação da classe de gravação mensagemHUB. Ajuste nas palavras acentuadas     | 1.08   |                  | PROT-459 | 
//|            |               | Métodos alterados: GETVLDGAR, GETVERGAR e GETEMIGAR                              |	       |                  |          |
//+------------+---------------+----------------------------------------------------------------------------------+--------+------------------+----------+ 

#INCLUDE "APWEBSRV.CH" 
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "XMLXFUN.CH" 
#INCLUDE "FILEIO.CH" 
#INCLUDE "Ap5Mail.ch" 
#INCLUDE "TbiConn.ch" 
 
#DEFINE XML_VERSION 		          '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>' 
#DEFINE cTAG_NOMESERVICO_RETIRAR_LOJA "Retirar na loja" 
#DEFINE cVERSAO                       "1.08" 

#Define cEVENTO_VALIDACAO 	"GETVLDGAR"
#Define cEVENTO_VERIFICACAO "GETVERGAR"
#Define cEVENTO_EMISSAO 	"GETEMIGAR"
/* 
ISHOPL_INDEFINIDO- forma de pagamento ainda não definida pelo cliente 
ISHOPL_TEF - débito em conta/transferência 
ISHOPL_BOLETO - boleto Itaú 
ISHOPL_ITAUCARD - cartão de crédito 
*/ 
Static __Shop := {"ISHOPL_INDEFINIDO","ISHOPL_TEF","ISHOPL_BOLETO","ISHOPL_ITAUCARD","BB_INDEFINIDO","BB_TEF","ONEBUY"} 
 
/*/{Protheus.doc} HardwareAvulsoProvider 
 
Webservice de integração do protheus com o portal de vendas certisign 
 
constructor 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSSERVICE HardwareAvulsoProvider DESCRIPTION "WebService para controle de compras via Portal" NAMESPACE "http://localhost:8080/wscomprasportal.apw" 
 
	WSDATA cxmlret	                As String 
	WSDATA idProduto 				As String 
	WSDATA idGrupo 					As String 
	WSDATA email 					As String 
	WSDATA senha 					As String 
	WSDATA cpf 						As String 
	WSDATA cnpj 					As String 
	WSDATA pagina 					As String 
	WSDATA quantidade 				As String 
	WSDATA numeroPedido				As String 
	WSDATA dtInicial 				As String 
	WSDATA dtFinal 					As String 
	WSDATA idPedido 				As String 
	WSDATA idPedSite				As String 
	WSDATA idNossoNum				As String 
	WSDATA iGeraRecibo				As boolean 
	WSDATA xml 						As String 
	WSDATA DtCred					As String 
	WSDATA cCategory				As String 
	WSDATA nValTitRec               AS float 
 
	WSMETHOD getProduto					DESCRIPTION "getProduto" 
	WSMETHOD validaContato				DESCRIPTION "validaContato" 
	WSMETHOD getContato					DESCRIPTION "getContato" 
	WSMETHOD validaPF					DESCRIPTION "validaPF" 
	WSMETHOD validaPJ					DESCRIPTION "validaPJ" 
	WSMETHOD getListaPostos				DESCRIPTION "getListaPostos" 
	WSMETHOD getpedidosAbertos			DESCRIPTION "getpedosAbertos" 
	WSMETHOD getTodosPedidos			DESCRIPTION "getTodosPedidos" 
	WSMETHOD getpedidoPorNumero			DESCRIPTION "getpedidoPorNumero" 
	WSMETHOD getpedidosPorData			DESCRIPTION "getpedidosPorData" 
	WSMETHOD getDetalhesPedido			DESCRIPTION "getDetalhesPedido" 
	WSMETHOD savePedidos				DESCRIPTION "savePedidos" 
	WSMETHOD getListaDetalhesVoucher	DESCRIPTION "getListaDetalhesVoucher" 
	WSMETHOD resetSenhas				DESCRIPTION "resetSenhas" 
	WSMETHOD saveOrUpdateContatos		DESCRIPTION "saveOr3Contatos" 
	WSMETHOD saveOrUpdatePosto		    DESCRIPTION "saveOrUpdatePosto" 
	WSMETHOD getlistaprodutos			DESCRIPTION "getVNDA280utos" 
	WSMETHOD getListaPedidosStatus		DESCRIPTION "getListaPedidosStatus" 
	WSMETHOD updateFormaPag				DESCRIPTION "updateFormaPag" 
	WSMETHOD updateConfirmarEntregas	DESCRIPTION "updateConfirmarEntregas" 
	WSMETHOD executaPedidos				DESCRIPTION "executaPedidos" 
	WSMETHOD faturaCnab					DESCRIPTION "faturaCnab" 
	WSMETHOD reciboCnab					DESCRIPTION "reciboCnab" 
	WSMETHOD faturaCC					DESCRIPTION "faturaCC" 
	WSMETHOD getvldGar					DESCRIPTION "getvldgar" 
	WSMETHOD getverGar					DESCRIPTION "getvergar" 
	WSMETHOD getemiGar					DESCRIPTION "getemigar" 
	WSMETHOD statusdelivery				DESCRIPTION "statusdelivery" 
	WSMETHOD sendMessage				DESCRIPTION "sendMessage" 
ENDWSSERVICE 
 
/*/{Protheus.doc} getProduto 
 
Metodo referente ao retorno de dados do produto 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
@see HardwareAvulsoProvider 
/*/ 
WSMETHOD getProduto WSRECEIVE idProduto,idGrupo WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryDA	:= "" 
	Local cTabPrc	:= GetMV("MV_XTABPRC",,"001") 
	Local nQtdDe	:= 0 
	Local nQtdAt	:= 0 
 
	U_GTPutRet('getProduto','A') 
 
	If Type("::idGrupo") == "U" 
		::idGrupo := cTabPrc 
	EndIf 
 
	//Pego as faixas da tabela de preco 
	cQryDA := " SELECT * " 
	cQryDA += " FROM " + RetSqlName("DA1") + " DA1 " 
	cQryDA += " LEFT JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = '" + xFilial("DA0") + "' AND DA0.D_E_L_E_T_ = ' ' AND DA0.DA0_CODTAB = DA1.DA1_CODTAB " 
	cQryDA += " WHERE DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " 
	cQryDA += "   AND DA1.DA1_CODPRO = '" + ::idProduto + "' " 
	cQryDA += "   AND DA1.DA1_CODTAB = '" + ::idGrupo + "' " 
	cQryDA += "   AND DA1.D_E_L_E_T_ = ' ' " 
	cQryDA += " ORDER BY DA1_CODTAB, DA1_ITEM" 
 
	cQryDA := ChangeQuery(cQryDA) 
 
	TCQUERY cQryDA NEW ALIAS "QRYDA" 
	DbSelectArea("QRYDA") 
 
	QRYDA->(DbGoTop()) 
	If QRYDA->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<produtoFullType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações do(s) produto(s) ok.</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
		//Posiciono no cadastro de Produto, para trazer o tipo, preco de venda e descricao 
		DbSelectArea("SB1") 
		DbSetOrder(1) 
		DbSeek(xFilial("SB1") + QRYDA->DA1_CODPRO) 
		::cxmlret += '    <descricao>' + AllTrim(QRYDA->DA1_XDSSIT) + '</descricao>' + CRLF 
		::cxmlret += '    <codProd>' + AllTrim(QRYDA->DA1_CODPRO) + '</codProd>' + CRLF 
		//::cxmlret += '    <vlUnid>' + AllTrim(Transform(SB1->B1_PRV1,"999999.99")) + '</vlUnid>' + CRLF 
		::cxmlret += '		<pesoKg>' + AllTrim(Transform(0,"999999.99")) + '</pesoKg>' + CRLF 
		::cxmlret += '		<comprimentoCm>' + AllTrim(Transform(0,"999999.99")) + '</comprimentoCm>' + CRLF 
		::cxmlret += '		<alturaCm>' + AllTrim(Transform(0,"999999.99")) + '</alturaCm>' + CRLF 
		::cxmlret += '		<larguraCm>' + AllTrim(Transform(0,"999999.99")) + '</larguraCm>' + CRLF 
		::cxmlret += '		<vlDeclarado>' + AllTrim(Transform(0,"999999.99")) + '</vlDeclarado>' + CRLF 
 
		While QRYDA->(!Eof()) 
			If QRYDA->DA1_QTDLOT = 999999.99 
				nQtdDe  := 1 
				nQtdAt	:= 999999 
			Else 
				nQtdDe++ 
				nQtdAt += IIF(QRYDA->DA1_QTDLOT > nQtdDe,QRYDA->DA1_QTDLOT,nQtdDe++  ) 
			EndIf 
			::cxmlret += '    <desconto>' + CRLF 
			::cxmlret += '			<minimo>' + AllTrim(Transform(nQtdDe,"999999999")) + '</minimo>' + CRLF 
			::cxmlret += '			<maximo>' + AllTrim(Transform(nQtdAt,"999999999")) + '</maximo>' + CRLF 
			::cxmlret += '			<valor>' + AllTrim(Transform(QRYDA->DA1_PRCVEN,"999999.99")) + '</valor>' + CRLF 
			::cxmlret += '			<codGrupo>' + AllTrim(QRYDA->DA1_CODTAB) + '</codGrupo>' + CRLF 
			::cxmlret += '    </desconto>' + CRLF 
			nQtdDe := nQtdAt 
			QRYDA->(DbSkip()) 
		End 
		::cxmlret += '</produtoFullType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<produtoFullType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</produtoFullType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYDA") 
	DbCloseArea() 
 
Return(lReturn)

/*/{Protheus.doc} validaContato 
 
Metodo referente a validação e retorno de informações de contatos 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD validaContato WSRECEIVE email,senha WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cCode		:= '1' 
 
	U_GTPutRet('validaContato','A') 
 
	DbSelectArea('SU5') 
	DbSetOrder(9) 
	If DbSeek(xFilial('SU5') + AllTrim(::email)) 
		If ::senha <> Encript(SU5->U5_XSENHA,1) 
			cCode := '2' 
		EndIf 
	Else 
		cCode := '2' 
	EndIf 
 
	If cCode == '2' 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<contatoFullType>' + CRLF 
		::cxmlret += '		<code>' + cCode + '</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>O contato não pode ser validado</msg>' + CRLF 
		::cxmlret += '		<exception>Contato ou senha inválidos</exception>' + CRLF 
		::cxmlret += '</contatoFullType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<contatoFullType>' + CRLF 
		::cxmlret += '		<code>' + cCode + '</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Processo de validação concluído com sucesso.</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '		<nome>' + AllTrim(SU5->U5_CONTAT) + '</nome>' + CRLF 
		::cxmlret += '		<cpf>' + AllTrim(SU5->U5_CPF) + '</cpf>' + CRLF 
		::cxmlret += '		<email>' + AllTrim(SU5->U5_EMAIL) + '</email>' + CRLF 
		::cxmlret += '		<senha>' + SU5->U5_XSENHA + '</senha>' + CRLF 
		::cxmlret += '		<fone>' + AllTrim(SU5->U5_DDD) + AllTrim(SU5->U5_FONE) + '</fone>' + CRLF 
		::cxmlret += '</contatoFullType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} getContato 
 
Metodo referente atualização do cadastro do contato 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getContato WSRECEIVE email WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local lErro		:= .F. 
	Local oError	:= ErrorBlock({|| lErro := .T.}) 
 
	U_GTPutRet('getContato','A') 
 
	Begin Sequence 
		DbSelectArea('SU5') 
		DbSetOrder(9) 
		If DbSeek(xFilial('SU5') + AllTrim(::email)) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<contatoFullType>' + CRLF 
			::cxmlret += '		<code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Solicitação concluída com secesso.</msg>' + CRLF 
			::cxmlret += '		<exception></exception>' + CRLF 
			::cxmlret += '		<nome>' + AllTrim(SU5->U5_CONTAT) + '</nome>' + CRLF 
			::cxmlret += '		<cpf>' + AllTrim(SU5->U5_CPF) + '</cpf>' + CRLF 
			::cxmlret += '		<email>' + AllTrim(SU5->U5_EMAIL) + '</email>' + CRLF 
			::cxmlret += '		<senha>' + SU5->U5_XSENHA + '</senha>' + CRLF 
			::cxmlret += '		<fone>' + AllTrim(SU5->U5_DDD) + AllTrim(SU5->U5_FONE) + '</fone>' + CRLF 
			::cxmlret += '</contatoFullType>' + CRLF 
		Else 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<contatoFullType>' + CRLF 
			::cxmlret += '		<code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
			::cxmlret += '		<exception></exception>' + CRLF 
			::cxmlret += '</contatoFullType>' + CRLF 
		EndIf 
	End Sequence 
 
	ErrorBlock(oError) 
 
	If lErro 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<contatoFullType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Erro na aplicação.</msg>' + CRLF 
		::cxmlret += '		<exception>Ocorreu um erro interno.</exception>' + CRLF 
		::cxmlret += '</contatoFullType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} validaPF 
 
Metodo referente a validação da existencia do cliente pessoa fisica no cadastro do protheus 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD validaPF WSRECEIVE cpf WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
 
	U_GTPutRet('validaPF','A') 
 
	If CGC(cpf)		//Valida se o cpf digitado e valido 
		DbSelectArea('SA1') 
		DbSetOrder(3)	//A1_FILIAL+A1_CGC 
		If DbSeek(xFilial('SA1') + U_CSFMTSA1(::cpf)) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<PFType> 
			::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>Solicitação concluída com sucesso.</msg>' + CRLF 
			::cxmlret += '    <exception></exception>' + CRLF 
			::cxmlret += '    <nome>' + AllTrim(SA1->A1_NOME) + '</nome>' + CRLF 
			::cxmlret += '    <cpf>' + AllTrim(SA1->A1_CGC) + '</cpf>' + CRLF 
			::cxmlret += '</PFType>' + CRLF 
		Else 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<PFType> 
			::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
			::cxmlret += '    <exception>CPF não encontrado</exception>' + CRLF 
			::cxmlret += '</PFType>' + CRLF 
		EndIf 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<PFType> 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>CPF digitado inválido</exception>' + CRLF 
		::cxmlret += '</PFType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} validaPJ 
 
Metodo referente a validação da existencia do cliente pessoa juridica no cadastro do protheus 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD validaPJ WSRECEIVE cnpj WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local aRet		:= {} 
 
	U_GTPutRet('validaPJ','A') 
 
	If CGC(cnpj)	//Valida se o cnpj digitado e valido 
		DbSelectArea('SA1') 
		DbSetOrder(3)	//A1_FILIAL+A1_CGC 
		If DbSeek(xFilial('SA1') + U_CSFMTSA1(::cnpj)) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<PJType>' + CRLF 
			::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>Solicitação concluída com sucesso.</msg>' + CRLF 
			::cxmlret += '    <exception></exception>' + CRLF 
			::cxmlret += '    <cnpj>' + AllTrim(SA1->A1_CGC) + '</cnpj>' + CRLF 
			::cxmlret += '    <rzSocial>' + AllTrim(SA1->A1_NOME) + '</rzSocial>' + CRLF 
			::cxmlret += '    <nmFant>' + AllTrim(SA1->A1_NREDUZ) + '</nmFant>' + CRLF 
			::cxmlret += '    <inscEst>' + AllTrim(SA1->A1_INSCR) + '</inscEst>' + CRLF 
			::cxmlret += '    <inscMun>' + AllTrim(SA1->A1_INSCRM) + '</inscMun>' + CRLF 
			::cxmlret += '    <suframa>' + AllTrim(SA1->A1_SUFRAMA) + '</suframa>' + CRLF 
			::cxmlret += '    <endereco>' + CRLF 
 
			aRet := U_VNDA380(SA1->A1_END) 
 
			::cxmlret += '        <desc>' + aRet[1] + '</desc>' + CRLF 
			::cxmlret += '        <bairro>' + AllTrim(SA1->A1_BAIRRO) + '</bairro>' + CRLF 
			::cxmlret += '        <numero>' + aRet[2] + '</numero>' + CRLF 
			::cxmlret += '        <compl>' + AllTrim(SA1->A1_COMPLEM) + '</compl>' + CRLF 
			::cxmlret += '        <cep>' + AllTrim(SA1->A1_CEP) + '</cep>' + CRLF 
			::cxmlret += '        <fone>' + AllTrim(SA1->A1_TEL) + '</fone>' + CRLF 
			::cxmlret += '        <cidade>' + CRLF 
			DbSelectArea('SX5') 
			DbSetOrder(1) 
			If DbSeek(xFilial('SX5') + '12' + SA1->A1_EST) 
				::cxmlret += '            <nome>' + AllTrim(SX5->X5_DESCRI) + '</nome>' + CRLF 
			Else 
				::cxmlret += '            <nome>' + '' + '</nome>' + CRLF 
			EndIf 
			::cxmlret += '            <uf>' + CRLF 
			::cxmlret += '                <sigla>' + AllTrim(SA1->A1_EST) + '</sigla>' + CRLF 
			::cxmlret += '            </uf>' + CRLF 
			::cxmlret += '        </cidade>' + CRLF 
			::cxmlret += '    </endereco>' + CRLF 
			::cxmlret += '</PJType>' + CRLF 
		Else 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<PJType>' + CRLF 
			::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
			::cxmlret += '    <exception>CNPJ não encontrado</exception>' + CRLF 
			::cxmlret += '</PJType>' + CRLF 
		EndIf 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<PJType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>CNPJ digitado inválido</exception>' + CRLF 
		::cxmlret += '</PJType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} getListaPostos 
 
Metodo referente a retorno de todos os postos de validação cadastrados no prottheus 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getListaPostos WSRECEIVE NULLPARAM WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQrySZ3	:= "" 
 
	U_GTPutRet('getListaPostos','A') 
 
	cQrySZ3 := "SELECT Z3_CODENT, Z3_CODGAR, Z3_DESENT, Z3_CGC, Z3_ESTADO, Z3_MUNICI, Z3_LOGRAD, Z3_NUMLOG, Z3_BAIRRO, Z3_COMPLE, Z3_CEP, Z3_DDD, Z3_TEL "
	cQrySZ3 += "FROM " + RetSqlName("SZ3") + " " 
	cQrySZ3 += "WHERE Z3_FILIAL = '" + xFilial("SZ3") + "' " 
	cQrySZ3 += "  AND Z3_LOGRAD <> '" + Space(TamSX3("Z3_LOGRAD")[1]) + "' " 
	cQrySZ3 += "  AND Z3_CODGAR <> '" + Space(TamSX3("Z3_CODGAR")[1]) + "' " 
	cQrySZ3 += "  AND Z3_MUNICI <> '" + Space(TamSX3("Z3_MUNICI")[1]) + "' " 
	cQrySZ3 += "  AND Z3_BAIRRO <> '" + Space(TamSX3("Z3_BAIRRO")[1]) + "' " 
	cQrySZ3 += "  AND Z3_CEP <> '" + Space(TamSX3("Z3_CEP")[1]) + "' " 
	cQrySZ3 += "  AND Z3_TEL <> '" + Space(TamSX3("Z3_TEL")[1]) + "' " 
	cQrySZ3 += "  AND Z3_TIPENT = '4' " 
	cQrySZ3 += "  AND Z3_ATIVO = 'S' " 
	cQrySZ3 += "  AND Z3_ENTREGA = 'S' " 
	cQrySZ3 += "  AND D_E_L_E_T_ = ' ' " 
	cQrySZ3 += "ORDER BY Z3_ESTADO, Z3_MUNICI, Z3_CODENT, Z3_DESENT " 
 
	cQrySZ3 := ChangeQuery(cQrySZ3) 
 
	TCQUERY cQrySZ3 NEW ALIAS "QRYSZ3" 
	DbSelectArea("QRYSZ3") 
 
	QRYSZ3->(DbGoTop()) 
	If QRYSZ3->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listPostoType>' + CRLF 
		::cxmlret += '		<code>1</code>' + CRLF 
		::cxmlret += '		<msg>Solicitação das informações do(s) posto(s) ok</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
 
		While QRYSZ3->(!Eof()) 
 
			::cxmlret += '		<posto>' + CRLF 
			::cxmlret += '			<nome>' + AllTrim(QRYSZ3->Z3_DESENT) + '</nome>' + CRLF 
			::cxmlret += '			<cnpj>' + AllTrim(QRYSZ3->Z3_CGC) + '</cnpj>' + CRLF 
			::cxmlret += '			<codGAR>' + AllTrim(QRYSZ3->Z3_CODGAR) + '</codGAR>' + CRLF 
			::cxmlret += '			<endereco>' + CRLF 
			::cxmlret += '				<desc>' + AllTrim(QRYSZ3->Z3_LOGRAD) + '</desc>' + CRLF 
			::cxmlret += '				<bairro>' + AllTrim(QRYSZ3->Z3_BAIRRO) + '</bairro>' + CRLF 
			::cxmlret += '				<numero>' + AllTrim(QRYSZ3->Z3_NUMLOG) + '</numero>' + CRLF 
			::cxmlret += '				<compl>' + AllTrim(QRYSZ3->Z3_COMPLE) + '</compl>' + CRLF 
			::cxmlret += '				<cep>' + AllTrim(QRYSZ3->Z3_CEP) + '</cep>' + CRLF 
			::cxmlret += '				<fone>' + AllTrim(QRYSZ3->Z3_DDD) + AllTrim(QRYSZ3->Z3_TEL) + '</fone>' + CRLF 
			::cxmlret += '				<cidade>' + CRLF 
			::cxmlret += '					<nome>' + AllTrim(QRYSZ3->Z3_MUNICI) + '</nome>' + CRLF 
			::cxmlret += '					<uf>' + CRLF 
			::cxmlret += '						<sigla>' + AllTrim(QRYSZ3->Z3_ESTADO) + '</sigla>' + CRLF 
			::cxmlret += '					</uf>' + CRLF 
			::cxmlret += '				</cidade>' + CRLF 
			::cxmlret += '			</endereco>' + CRLF 
			::cxmlret += '		</posto>' + CRLF 
			QRYSZ3->(DbSkip()) 
		End 
		::cxmlret += '</listPostoType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listPostoType>' + CRLF 
		::cxmlret += '		<code>2</code>' + CRLF 
		::cxmlret += '		<msg>Processo não pode ser concluído, devido não ter encontrado nenhum posto.</msg>' + CRLF 
		::cxmlret += '		<exception>Processo não pode ser concluído.</exception>' + CRLF 
		::cxmlret += '</listPostoType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYSZ3") 
	DbCloseArea() 
 
Return(lReturn)

/*/{Protheus.doc} getpedidosAbertos 
 
Metodo referente a retorno de lista de pedidos de vendas em aberto 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
/*/
WSMETHOD getpedidosAbertos WSRECEIVE email,pagina,quantidade WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryC5	:= "" 
	Local cQryC6	:= "" 
	Local nQtdIni	:= 0 
	Local nQtdFim	:= 0 
	Local cStatus	:= "" 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
 
	U_GTPutRet('getpedidosAbertos','A') 
 
	//Faco o calculo para saber qual o intervalo de pedidos por pagina 
	nQtdIni := ((Val(::pagina) * Val(::quantidade)) - Val(::quantidade)) + 1 
	nQtdFim := Val(::pagina) * Val(::quantidade) 
 
	//Posiciono no cadastro de contatos 
	DbSelectArea("SU5") 
	DbSetOrder(9) 
	DbSeek(xFilial("SU5") + AllTrim(::email)) 
 
	//Posiciono no cadastro de amarracoes de contatos e clientes 
	DbSelectArea("AC8") 
	DbSetOrder(1) 
	DbSeek(xFilial("AC8") + SU5->U5_CODCONT + "SA1") 
 
	//Posiciono no cadastro de cliente 
	DbSelectArea("SA1") 
	DbSetOrder(1) 
	DbSeek(xFilial("SA1") + AC8->AC8_CODENT) 
 
	//Pego o intervalo de pedidos em aberto de acordo com a pagina e numero de pedidos por pagina 
	cQryC5 := " SELECT * " 
	cQryC5 += " FROM " 
	cQryC5 += " 	( " 
	cQryC5 += "		SELECT " 
	cQryC5 += "			row_number() over (order by C5_NUM) ROWNUMBER, C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, C5_NOTA, C5_LIBEROK, C5_BLQ " 
	cQryC5 += "		FROM " + RetSqlName("SC5") + " " 
	cQryC5 += "		JOIN " + RetSqlName("AC8") + " AC8 ON AC8.AC8_FILENT = '" + xFilial("SC5") + "' AND AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8.AC8_CODCON = '" + SU5->U5_CODCONT + "' AND AC8.D_E_L_E_T_ = ' ' " 
	cQryC5 += "		WHERE D_E_L_E_T_ = ' ' " 
	cQryC5 += "	  	  AND C5_FILIAL = '" + xFilial("SC5") + "' " 
	cQryC5 += "	  	  AND (SC5.C5_CLIENTE + SC5.C5_LOJACLI) = AC8.AC8_CODENT" 
	cQryC5 += "	  	  AND C5_LIBEROK = '" + Space(TamSX3("C5_LIBEROK")[1]) + "' AND C5_NOTA = '" + Space(TamSX3("C5_NOTA")[1]) + "' " 
	cQryC5 += "	  	  AND C5_BLQ = '" + Space(TamSX3("C5_BLQ")[1]) + "' " 
	cQryC5 += "		) AS X " 
	cQryC5 += " WHERE " 
	cQryC5 += " ROWNUMBER BETWEEN " + AllTrim(Str(nQtdIni)) + " AND " + AllTrim(Str(nQtdFim)) 
 
	cQryC5 := ChangeQuery(cQryC5) 
 
	TCQUERY cQryC5 NEW ALIAS "QRYC5" 
	DbSelectArea("QRYC5") 
 
	QRYC5->(DbGoTop()) 
	If QRYC5->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações do(s) pedido(s) ok</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
 
		While QRYC5->(!Eof()) 
 
			::cxmlret += '    <pedido>' + CRLF 
			::cxmlret += '        <numero>' + QRYC5->C5_NUM + '</numero>' + CRLF 
 
			cData	:= StoD(QRYC5->C5_EMISSAO) 
			cAno	:= StrZero(Year(cData),4) 
			cMes	:= StrZero(Month(cData),2) 
			cDia	:= StrZero(Day(cData),2) 
			cData	:= cDia + "/" + cMes + "/" + cAno 
			::cxmlret += '        <data>' + cData + " 00:00:00" + '</data>' + CRLF 
 
			//Query para pegar o valor total do pedido 
			cQryC6 := " SELECT SUM(C6_VALOR) VALOR " 
			cQryC6 += " FROM " + RetSqlName("SC6") + " " 
			cQryC6 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
			cQryC6 += "   AND D_E_L_E_T_ = ' ' " 
			cQryC6 += "   AND C6_CLI = '" + QRYC5->C5_CLIENTE + "' " 
			cQryC6 += "   AND C6_LOJA = '" + QRYC5->C5_LOJACLI + "' " 
			cQryC6 += "   AND C6_NUM = '" + QRYC5->C5_NUM + "' " 
 
			cQryC6 := ChangeQuery(cQryC6) 
 
			TCQUERY cQryC6 NEW ALIAS "QRYC6" 
			DbSelectArea("QRYC6") 
 
			::cxmlret += '        <vlTotal>' + AllTrim(Transform(QRYC6->VALOR,"999999.99")) + '</vlTotal>' + CRLF 
 
			DbSelectArea("QRYC6") 
			DbCloseArea() 
 
			::cxmlret += '        <formPag>' + QRYC5->C5_CONDPAG + '</formPag>' + CRLF 
 
			If Empty(QRYC5->C5_LIBEROK) .And. Empty(QRYC5->C5_NOTA) .And. Empty(QRYC5->C5_BLQ)		//Pedido em Aberto 
				cStatus := "1"	//1 - Pedido em Aberto 
			ElseIf !Empty(QRYC5->C5_NOTA) .Or. QRYC5->C5_LIBEROK=='E' .And. Empty(QRYC5->C5_BLQ)	   	//Pedido Encerrado 
				cStatus := "2"	//2 - Pedido Encerrado 
			EndIf 
 
			::cxmlret += '        <status>' + cStatus + '</status>' + CRLF 
			::cxmlret += '    </pedido>' + CRLF 
			QRYC5->(DbSkip()) 
		End 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYC5") 
	DbCloseArea() 
Return(lReturn)

/*/{Protheus.doc} getTodosPedidos 
 
Metodo referente a retorno de lista de pedidos de vendas 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getTodosPedidos WSRECEIVE email,pagina,quantidade WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryC5	:= "" 
	Local cQryC6	:= "" 
	Local nQtdIni	:= 0 
	Local nQtdFim	:= 0 
	Local cStatus	:= "" 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
 
	U_GTPutRet('getTodosPedidos','A') 
 
	//Faco o calculo para saber qual o intervalo de pedidos por pagina 
	nQtdIni := ((Val(::pagina) * Val(::quantidade)) - Val(::quantidade)) + 1 
	nQtdFim := Val(::pagina) * Val(::quantidade) 
 
	//Posiciono no cadastro de contatos 
	DbSelectArea("SU5") 
	DbSetOrder(9) 
	DbSeek(xFilial("SU5") + AllTrim(::email)) 
 
	//Posiciono no cadastro de amarracoes de contatos e clientes 
	DbSelectArea("AC8") 
	DbSetOrder(1) 
	DbSeek(xFilial("AC8") + SU5->U5_CODCONT + "SA1") 
 
	//Posiciono no cadastro de cliente 
	DbSelectArea("SA1") 
	DbSetOrder(1) 
	DbSeek(xFilial("SA1") + AC8->AC8_CODENT) 
 
	//Pego o intervalo de todos os pedidos de acordo com a pagina e numero de pedidos por pagina 
	cQryC5 := " SELECT * " 
	cQryC5 += " FROM " 
	cQryC5 += " 	( " 
	cQryC5 += "		SELECT " 
	cQryC5 += "			row_number() over (order by C5_NUM) ROWNUMBER, C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, C5_NOTA, C5_LIBEROK, C5_BLQ " 
	cQryC5 += "		FROM " + RetSqlName("SC5") + " " 
	cQryC5 += "		JOIN " + RetSqlName("AC8") + " AC8 ON AC8.AC8_FILENT = '" + xFilial("SC5") + "' AND AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8.AC8_CODCON = '" + SU5->U5_CODCONT + "' AND AC8.D_E_L_E_T_ = ' ' " 
	cQryC5 += "		WHERE D_E_L_E_T_ = ' ' " 
	cQryC5 += "	  	  AND C5_FILIAL = '" + xFilial("SC5") + "' " 
	cQryC5 += "	  	  AND (SC5.C5_CLIENTE + SC5.C5_LOJACLI) = AC8.AC8_CODENT " 
	cQryC5 += "		) AS X " 
	cQryC5 += " WHERE " 
	cQryC5 += " ROWNUMBER BETWEEN " + AllTrim(Str(nQtdIni)) + " AND " + AllTrim(Str(nQtdFim)) 
 
	cQryC5 := ChangeQuery(cQryC5) 
 
	TCQUERY cQryC5 NEW ALIAS "QRYC5" 
	DbSelectArea("QRYC5") 
 
	QRYC5->(DbGoTop()) 
	If QRYC5->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações do(s) pedido(s) ok</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
 
		While QRYC5->(!Eof()) 
 
			::cxmlret += '    <pedido>' + CRLF 
			::cxmlret += '        <numero>' + QRYC5->C5_NUM + '</numero>' + CRLF 
			cData	:= StoD(QRYC5->C5_EMISSAO) 
			cAno	:= StrZero(Year(cData),4) 
			cMes	:= StrZero(Month(cData),2) 
			cDia	:= StrZero(Day(cData),2) 
			cData	:= cDia + "/" + cMes + "/" + cAno 
			::cxmlret += '        <data>' + cData + " 00:00:00" + '</data>' + CRLF 
 
			//Query para pegar o valor total do pedido 
			cQryC6 := " SELECT SUM(C6_VALOR) VALOR " 
			cQryC6 += " FROM " + RetSqlName("SC6") + " " 
			cQryC6 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
			cQryC6 += "   AND D_E_L_E_T_ = ' ' " 
			cQryC6 += "   AND C6_CLI = '" + QRYC5->C5_CLIENTE + "' " 
			cQryC6 += "   AND C6_LOJA = '" + QRYC5->C5_LOJACLI + "' " 
			cQryC6 += "   AND C6_NUM = '" + QRYC5->C5_NUM + "' " 
 
			cQryC6 := ChangeQuery(cQryC6) 
 
			TCQUERY cQryC6 NEW ALIAS "QRYC6" 
			DbSelectArea("QRYC6") 
 
			::cxmlret += '        <vlTotal>' + AllTrim(Transform(QRYC6->VALOR,"9999999.99")) + '</vlTotal>' + CRLF 
 
			DbSelectArea("QRYC6") 
			DbCloseArea() 
 
			::cxmlret += '        <formPag>' + QRYC5->C5_CONDPAG + '</formPag>' + CRLF 
 
			If Empty(QRYC5->C5_LIBEROK) .And. Empty(QRYC5->C5_NOTA) .And. Empty(QRYC5->C5_BLQ)		//Pedido em Aberto 
				cStatus := "1"	//1 - Pedido em Aberto 
			ElseIf !Empty(QRYC5->C5_NOTA) .Or. QRYC5->C5_LIBEROK=='E' .And. Empty(QRYC5->C5_BLQ)	   	//Pedido Encerrado 
				cStatus := "2"	//2 - Pedido Encerrado 
			EndIf 
 
			::cxmlret += '        <status>' + cStatus + '</status>' + CRLF 
			::cxmlret += '    </pedido>' + CRLF 
			QRYC5->(DbSkip()) 
		End 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYC5") 
	DbCloseArea() 
Return(lReturn)

/*/{Protheus.doc} getpedidoPorNumero 
 
Metodo referente a retorno pedido de vendas de acordo codigo informado 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getpedidoPorNumero WSRECEIVE email,numeroPedido WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryC5	:= "" 
	Local cQryC6	:= "" 
	Local cStatus	:= "" 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
 
	U_GTPutRet('getpedidoPorNumero','A') 
 
	cQryC5 := " SELECT * " 
	cQryC5 += " FROM " + RetSqlName("SC5") + " " 
	cQryC5 += " WHERE D_E_L_E_T_ = ' ' " 
	cQryC5 += "   AND C5_FILIAL = '" + xFilial("SC5") + "' " 
	cQryC5 += "   AND C5_XNPSITE = '" + ::numeroPedido + "' " 
 
	cQryC5 := ChangeQuery(cQryC5) 
 
	TCQUERY cQryC5 NEW ALIAS "QRYC5" 
	DbSelectArea("QRYC5") 
 
	QRYC5->(DbGoTop()) 
	If QRYC5->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações do(s) pedido(s) ok</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
		::cxmlret += '    <pedido>' + CRLF 
		::cxmlret += '        <numero>' + AllTrim(Str(QRYC5->C5_XNPSITE)) + '</numero>' + CRLF 
		cData	:= StoD(QRYC5->C5_EMISSAO) 
		cAno	:= StrZero(Year(cData),4) 
		cMes	:= StrZero(Month(cData),2) 
		cDia	:= StrZero(Day(cData),2) 
		cData	:= cDia + "/" + cMes + "/" + cAno 
		::cxmlret += '        <data>' + cData + " 00:00:00" + '</data>' + CRLF 
 
		//Query para pegar o valor total do pedido 
		cQryC6 := " SELECT SUM(C6_VALOR) VALOR " 
		cQryC6 += " FROM " + RetSqlName("SC6") + " " 
		cQryC6 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
		cQryC6 += "   AND D_E_L_E_T_ = ' ' " 
		cQryC6 += "   AND C6_CLI = '" + QRYC5->C5_CLIENTE + "' " 
		cQryC6 += "   AND C6_LOJA = '" + QRYC5->C5_LOJACLI + "' " 
		cQryC6 += "   AND C6_NUM = '" + QRYC5->C5_NUM + "' " 
 
		cQryC6 := ChangeQuery(cQryC6) 
 
		TCQUERY cQryC6 NEW ALIAS "QRYC6" 
		DbSelectArea("QRYC6") 
 
		::cxmlret += '        <vlTotal>' + AllTrim(Transform(QRYC6->VALOR,"9999999.99")) + '</vlTotal>' + CRLF 
 
		DbSelectArea("QRYC6") 
		DbCloseArea() 
 
		::cxmlret += '        <formPag>' + QRYC5->C5_CONDPAG + '</formPag>' + CRLF 
 
		If Empty(QRYC5->C5_LIBEROK) .And. Empty(QRYC5->C5_NOTA) .And. Empty(QRYC5->C5_BLQ)		//Pedido em Aberto 
			cStatus := "1"	//1 - Pedido em Aberto 
		ElseIf !Empty(QRYC5->C5_NOTA) .Or. QRYC5->C5_LIBEROK=='E' .And. Empty(QRYC5->C5_BLQ)	   	//Pedido Encerrado 
			cStatus := "2"	//2 - Pedido Encerrado 
		EndIf 
 
		::cxmlret += '        <status>' + cStatus + '</status>' + CRLF 
		::cxmlret += '    </pedido>' + CRLF 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYC5") 
	DbCloseArea() 
 
Return(lReturn)

/*/{Protheus.doc} getpedidosPorData 
 
Metodo referente a retorno de lista de pedidos de vendas por data 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getpedidosPorData WSRECEIVE email,pagina,quantidade,dtInicial,dtFinal WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryC5	:= "" 
	Local cQryC6	:= "" 
	Local nQtdIni	:= 0 
	Local nQtdFim	:= 0 
	Local cStatus	:= "" 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
	Local dDtIni	:= CtoD(SubStr(::dtInicial, 1, 10)) 
	Local dDtFim	:= CtoD(SubStr(::dtFinal, 1, 10)) 
 
	U_GTPutRet('getpedidosPorData','A') 
 
	//Faco o calculo para saber qual o intervalo de pedidos por pagina 
	nQtdIni := ((Val(::pagina) * Val(::quantidade)) - Val(::quantidade)) + 1 
	nQtdFim := Val(::pagina) * Val(::quantidade) 
 
	//Posiciono no cadastro de contatos 
	DbSelectArea("SU5") 
	DbSetOrder(9) 
	DbSeek(xFilial("SU5") + AllTrim(::email)) 
 
	//Posiciono no cadastro de amarracoes de contatos e clientes 
	DbSelectArea("AC8") 
	DbSetOrder(1) 
	DbSeek(xFilial("AC8") + SU5->U5_CODCONT + "SA1") 
 
	//Posiciono no cadastro de cliente 
	DbSelectArea("SA1") 
	DbSetOrder(1) 
	DbSeek(xFilial("SA1") + AC8->AC8_CODENT) 
 
	//Pego o intervalo de pedidos por data de acordo com a pagina e numero de pedidos por pagina 
	cQryC5 := " SELECT * " 
	cQryC5 += " FROM " 
	cQryC5 += " 	( " 
	cQryC5 += "		SELECT " 
	cQryC5 += "			row_number() over (order by C5_NUM) ROWNUMBER, C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG, C5_NOTA, C5_LIBEROK, C5_BLQ " 
	cQryC5 += "		FROM " + RetSqlName("SC5") + " " 
	cQryC5 += "		JOIN " + RetSqlName("AC8") + " AC8 ON AC8.AC8_FILENT = '" + xFilial("SC5") + "' AND AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8.AC8_CODCON = '" + SU5->U5_CODCONT + "' AND AC8.D_E_L_E_T_ = ' ' " 
	cQryC5 += "		WHERE D_E_L_E_T_ = ' ' " 
	cQryC5 += "	  	  AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5_EMISSAO BETWEEN " + DtoS(dDtIni) + " AND " + DtoS(dDtFim) + " " 
	cQryC5 += "	  	  AND (SC5.C5_CLIENTE + SC5.C5_LOJACLI) = AC8.AC8_CODENT " 
	cQryC5 += "		) AS X " 
	cQryC5 += " WHERE " 
	cQryC5 += " ROWNUMBER BETWEEN " + AllTrim(Str(nQtdIni)) + " AND " + AllTrim(Str(nQtdFim)) 
 
	cQryC5 := ChangeQuery(cQryC5) 
 
	TCQUERY cQryC5 NEW ALIAS "QRYC5" 
	DbSelectArea("QRYC5") 
 
	QRYC5->(DbGoTop()) 
	If QRYC5->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações dos pedidos ok</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
 
		While QRYC5->(!Eof()) 
 
			::cxmlret += '    <pedido>' + CRLF 
			::cxmlret += '        <numero>' + QRYC5->C5_NUM + '</numero>' + CRLF 
			cData	:= StoD(QRYC5->C5_EMISSAO) 
			cAno	:= StrZero(Year(cData),4) 
			cMes	:= StrZero(Month(cData),2) 
			cDia	:= StrZero(Day(cData),2) 
			cData	:= cDia + "/" + cMes + "/" + cAno 
			::cxmlret += '        <data>' + cData + " 00:00:00" + '</data>' + CRLF 
 
			//Query para pegar o valor total do pedido 
			cQryC6 := " SELECT SUM(C6_VALOR) VALOR " 
			cQryC6 += " FROM " + RetSqlName("SC6") + " " 
			cQryC6 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
			cQryC6 += "   AND D_E_L_E_T_ = ' ' " 
			cQryC6 += "   AND C6_CLI = '" + QRYC5->C5_CLIENTE + "' " 
			cQryC6 += "   AND C6_LOJA = '" + QRYC5->C5_LOJACLI + "' " 
			cQryC6 += "   AND C6_NUM = '" + QRYC5->C5_NUM + "' " 
 
			cQryC6 := ChangeQuery(cQryC6) 
 
			TCQUERY cQryC6 NEW ALIAS "QRYC6" 
			DbSelectArea("QRYC6") 
 
			::cxmlret += '        <vlTotal>' + AllTrim(Transform(QRYC6->VALOR,"9999999.99")) + '</vlTotal>' + CRLF 
 
			DbSelectArea("QRYC6") 
			DbCloseArea() 
 
			::cxmlret += '        <formPag>' + QRYC5->C5_CONDPAG + '</formPag>' + CRLF 
 
			If Empty(QRYC5->C5_LIBEROK) .And. Empty(QRYC5->C5_NOTA) .And. Empty(QRYC5->C5_BLQ)		//Pedido em Aberto 
				cStatus := "1"	//1 - Pedido em Aberto 
			ElseIf !Empty(QRYC5->C5_NOTA) .Or. QRYC5->C5_LIBEROK=='E' .And. Empty(QRYC5->C5_BLQ)	   	//Pedido Encerrado 
				cStatus := "2"	//2 - Pedido Encerrado 
			EndIf 
 
			::cxmlret += '        <status>' + cStatus + '</status>' + CRLF 
			::cxmlret += '    </pedido>' + CRLF 
			QRYC5->(DbSkip()) 
		End 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoSmallType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</pedidoSmallType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYC5") 
	DbCloseArea() 
 
Return(lReturn)

/*/{Protheus.doc} getDetalhesPedido 
 
Metodo referente a retorno dos detalhes de pedidos de vendas de acordo código informado 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getDetalhesPedido WSRECEIVE email,numeroPedido WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryC6	:= "" 
	Local cQryC5	:= "" 
 
	Local cQryU5	:= "" 
	Local cQryCli	:= "" 
	Local cQryPos	:= "" 
	Local cNumPed	:= "" 
	Local cCliente	:= "" 
	Local cLoja		:= "" 
	Local cPosCod	:= "" 
	Local cPosLoj	:= "" 
	Local cContato	:= "" 
	Local cTelCont	:= "" 
	Local cCondP	:= "" 
	Local cTabela	:= "" 
	Local dEmis		:= Ctod("//") 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
	Local cSChema	:= 'xmlns:ns3="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' 
	Local aRet		:= {} 
	Local aRetPos	:= {} 
 
	U_GTPutRet('getDetalhesPedido','A') 
 
	cQryC5 := " SELECT	C5_XNPSITE, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_CLIENT, C5_LOJAENT, C5_CONDPAG, C5_TABELA, C5_EMISSAO, C5_LIBEROK, C5_NOTA, C5_BLQ, " 
	cQryC5 += " 	  	C5_TIPMOV, C5_XNUMCAR, C5_XNOMTIT, C5_XCODSEG, C5_XVALIDA, C5_XNPARCE, C5_XTIPCAR, C5_XLINDIG, C5_XNUMVOU, C5_XQTDVOU " 
	cQryC5 += " FROM " + RetSqlName("SC5") + " " 
	cQryC5 += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' " 
	cQryC5 += "   AND D_E_L_E_T_ = ' ' " 
	cQryC5 += "   AND C5_XNPSITE = '" + ::numeroPedido + "' " 
 
	cQryC5 := ChangeQuery(cQryC5) 
 
	TCQUERY cQryC5 NEW ALIAS "QRYC5" 
	DbSelectArea("QRYC5") 
 
	QRYC5->(DbGoTop()) 
	If QRYC5->(!Eof()) 
 
		cNumPed		:= QRYC5->C5_XNPSITE 
		cCliente	:= QRYC5->C5_CLIENTE 
		cLoja		:= QRYC5->C5_LOJACLI 
		cPosCod		:= QRYC5->C5_CLIENT 
		cPosLoj		:= QRYC5->C5_LOJAENT 
		cCondP		:= QRYC5->C5_CONDPAG 
		cTabela		:= QRYC5->C5_TABELA 
		dEmis		:= QRYC5->C5_EMISSAO 
 
		cData	:= StoD(QRYC5->C5_EMISSAO) 
		cAno	:= StrZero(Year(cData),4) 
		cMes	:= StrZero(Month(cData),2) 
		cDia	:= StrZero(Day(cData),2) 
		cData	:= cDia + "/" + cMes + "/" + cAno 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoFullType>' + CRLF 
		::cxmlret += '		<code>1</code>' + CRLF 
		::cxmlret += '		<msg>Solicitação dos detalhes do pedidos ok.</msg>'+ CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '		<numero>' + AllTrim(cNumPed) + '</numero>' + CRLF 
		::cxmlret += '		<data>' + cData + " 00:00:00" + '</data>' + CRLF 
		::cxmlret += '		<linkNFProd>http://link_nota_fiscal_produto</linkNFProd>' + CRLF 
		::cxmlret += '		<linkNFServ>http://link_nota_fiscal_servico</linkNFServ>' + CRLF 
 
		cQryU5 := " SELECT * " 
		cQryU5 += " FROM " + RetSqlName("SU5") + " " 
		cQryU5 += " WHERE U5_FILIAL = '" + xFilial("SU5") + "' " 
		cQryU5 += "   AND D_E_L_E_T_ = ' ' " 
		cQryU5 += "   AND U5_EMAIL = '" + ::email + "' " 
 
		cQryU5 := ChangeQuery(cQryU5) 
 
		TCQUERY cQryU5 NEW ALIAS "QRYU5" 
		DbSelectArea("QRYU5") 
 
		QRYU5->(DbGoTop()) 
		If QRYU5->(!Eof()) 
			::cxmlret += '		<contato>' + CRLF 
			::cxmlret += '			<nome>' + AllTrim(QRYU5->U5_CONTAT) + '</nome>' + CRLF 
			::cxmlret += '			<cpf>' + AllTrim(QRYU5->U5_CPF) + '</cpf>' + CRLF 
			::cxmlret += '			<email>' + AllTrim(QRYU5->U5_EMAIL) + '</email>' + CRLF 
			::cxmlret += '			<senha>' + Encode64( encript(QRYU5->U5_XSENHA,1) ) + '</senha>' + CRLF 
			::cxmlret += '			<fone>' + AllTrim(QRYU5->U5_DDD) + AllTrim(QRYU5->U5_FONE) + '</fone>' + CRLF 
			::cxmlret += '		</contato>' + CRLF 
			cContato := AllTrim(QRYU5->U5_CONTAT) 
			cTelCont := AllTrim(QRYU5->U5_DDD) + AllTrim(QRYU5->U5_FONE) 
		EndIf 
 
		DbSelectArea("QRYU5") 
		DbCloseArea() 
 
		//Dados do cliente/faturamento 
		cQryCli := " SELECT * " 
		cQryCli += " FROM " + RetSqlName("SA1") + " " 
		cQryCli += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' " 
		cQryCli += "   AND D_E_L_E_T_ = ' ' " 
		cQryCli += "   AND A1_COD = '" + cCliente + "' " 
		cQryCli += "   AND A1_LOJA = '" + cLoja + "' " 
 
		cQryCli := ChangeQuery(cQryCli) 
 
		TCQUERY cQryCli NEW ALIAS "QRYCLI" 
		DbSelectArea("QRYCLI") 
 
		QRYCLI->(DbGoTop()) 
		If QRYCLI->(!Eof()) 
			If QRYCLI->A1_PESSOA == 'F' 
 
				aRet := U_VNDA380(QRYCLI->A1_END) 
 
				::cxmlret += '		<fatura xsi:type="ns3:faturaPFType" ' + cSChema + ' >' + CRLF 
				::cxmlret += '			<endereco>' + CRLF 
				::cxmlret += '				<desc>' + aRet[1] + '</desc>' + CRLF 
				::cxmlret += '				<bairro>' + AllTrim(QRYCLI->A1_BAIRRO) + '</bairro>' + CRLF 
				::cxmlret += '				<numero>' + aRet[2] + '</numero>' + CRLF 
				::cxmlret += '				<compl>' + AllTrim(QRYCLI->A1_COMPLEM) + '</compl>' + CRLF 
				::cxmlret += '				<cep>' + AllTrim(QRYCLI->A1_CEP) + '</cep>' + CRLF 
				::cxmlret += '				<fone>' + AllTrim(QRYCLI->A1_DDD) + AllTrim(QRYCLI->A1_TEL) + '</fone>' + CRLF 
				::cxmlret += '				<cidade>' + CRLF 
				::cxmlret += '					<nome>' + AllTrim(QRYCLI->A1_MUN) + '</nome>' + CRLF 
				::cxmlret += '					<uf>' + CRLF 
				::cxmlret += '						<sigla>' + AllTrim(QRYCLI->A1_EST) + '</sigla>' + CRLF 
				::cxmlret += '					</uf>' + CRLF 
				::cxmlret += '				</cidade>' + CRLF 
				::cxmlret += '			</endereco>' + CRLF 
				::cxmlret += '			<cpf>' + AllTrim(QRYCLI->A1_CGC) + '</cpf>' + CRLF 
				::cxmlret += '			<nome>' + AllTrim(QRYCLI->A1_NOME) + '</nome>' + CRLF 
				::cxmlret += '		</fatura>' + CRLF 
			Else 
 
				aRet := U_VNDA380(QRYCLI->A1_END) 
 
				::cxmlret += '		<fatura xsi:type="ns3:faturaPJType" ' + cSChema + ' >' + CRLF 
				::cxmlret += '			<endereco>' + CRLF 
				::cxmlret += '				<desc>' + aRet[1] + '</desc>' + CRLF 
				::cxmlret += '				<bairro>' + AllTrim(QRYCLI->A1_BAIRRO) + '</bairro>' + CRLF 
				::cxmlret += '				<numero>' + aRet[2] + '</numero>' + CRLF 
				::cxmlret += '				<compl>' + AllTrim(QRYCLI->A1_COMPLEM) + '</compl>' + CRLF 
				::cxmlret += '				<cep>' + AllTrim(QRYCLI->A1_CEP) + '</cep>' + CRLF 
				::cxmlret += '				<fone>' + AllTrim(QRYCLI->A1_DDD) + AllTrim(QRYCLI->A1_TEL) + '</fone>' + CRLF 
				::cxmlret += '				<cidade>' + CRLF 
				::cxmlret += '					<nome>' + AllTrim(QRYCLI->A1_MUN) + '</nome>' + CRLF 
				::cxmlret += '					<uf>' + CRLF 
				::cxmlret += '						<sigla>' + AllTrim(QRYCLI->A1_EST) + '</sigla>' + CRLF 
				::cxmlret += '					</uf>' + CRLF 
				::cxmlret += '				</cidade>' + CRLF 
				::cxmlret += '			</endereco>' + CRLF 
				::cxmlret += '			<cnpj>' + AllTrim(QRYCLI->A1_CGC) + '</cnpj>' + CRLF 
				::cxmlret += '			<rzSocial>' + AllTrim(QRYCLI->A1_NOME) + '</rzSocial>' + CRLF 
				::cxmlret += '			<inscEst>' + AllTrim(QRYCLI->A1_INSCR) + '</inscEst>' + CRLF 
				::cxmlret += '			<inscMun>' + AllTrim(QRYCLI->A1_INSCRM) + '</inscMun>' + CRLF 
				::cxmlret += '			<suframa>' + AllTrim(QRYCLI->A1_SUFRAMA) + '</suframa>' + CRLF 
				::cxmlret += '			<nmContato>' + cContato + '</nmContato>' + CRLF 
				::cxmlret += '			<foneContato>' + cTelCont + '</foneContato>' + CRLF 
				::cxmlret += '		</fatura>' + CRLF 
			EndIf 
		EndIf 
 
		DbSelectArea("QRYCLI") 
		DbCloseArea() 
 
		cData	:= QRYC5->C5_XVALIDA 
 
		If QRYC5->C5_TIPMOV == "1" 
			::cxmlret += '		<pagamento xsi:type="ns3:cartaoType" ' + cSChema + ' >' + CRLF 
			::cxmlret += '			<numero>' + AllTrim(QRYC5->C5_XNUMCAR) + '</numero>' + CRLF 
			::cxmlret += '			<nmTitular>' + AllTrim(QRYC5->C5_XNOMTIT) + '</nmTitular>' + CRLF 
			::cxmlret += '			<codSeg>' + AllTrim(QRYC5->C5_XCODSEG) + '</codSeg>' + CRLF 
			::cxmlret += '			<dtValid>' + cData + '	</dtValid>' + CRLF 
			::cxmlret += '			<parcelas>' + AllTrim(QRYC5->C5_XNPARCE) + '</parcelas>' + CRLF 
			::cxmlret += '			<tipo>' + QRYC5->C5_XTIPCAR + '</tipo>' + CRLF 
			::cxmlret += '		</pagamento>' + CRLF 
		ElseIf QRYC5->C5_TIPMOV == "2" 
			::cxmlret += '		<pagamento xsi:type="ns3:boletoType" ' + cSChema + ' >' + CRLF 
			::cxmlret += '			<linhaDigitavel>' + AllTrim(QRYC5->C5_XLINDIG) + '</linhaDigitavel>' + CRLF 
			::cxmlret += '		</pagamento>' + CRLF 
		Elseif QRYC5->C5_TIPMOV == "6" 
			::cxmlret += '		<pagamento xsi:type="ns3:voucherType" ' + cSChema + ' >' + CRLF 
			::cxmlret += '			<numero>' + QRYC5->C5_XNUMVOU + '</numero>' + CRLF 
			::cxmlret += '			<qtConsumida>' + QRYC5->C5_XQTDVOU + '</qtConsumida>' + CRLF 
			::cxmlret += '		</pagamento>' + CRLF 
		EndIf 
 
		cQryC6 := " SELECT C6_NUM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_DESCONT, C6_VALOR, B1_COD, B1_TIPO, B1_DESC" 
		cQryC6 += " FROM " + RetSqlName("SC6") + " SC6" 
		cQryC6 += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " 
		cQryC6 += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
		cQryC6 += "   AND SC6.D_E_L_E_T_ = ' ' " 
		cQryC6 += "   AND C6_NUM = '" + QRYC5->C5_NUM + "' " 
 
		cQryC6 := ChangeQuery(cQryC6) 
 
		TCQUERY cQryC6 NEW ALIAS "QRYC6" 
		DbSelectArea("QRYC6") 
 
		QRYC6->(DbGoTop()) 
		If QRYC6->(!Eof()) 
			While QRYC6->(!Eof()) 
				::cxmlret += '		<produto>' + CRLF 
				::cxmlret += '			<tipo>1</tipo>' + CRLF 
				::cxmlret += '			<codProd>' + AllTrim(QRYC6->B1_COD) + '</codProd>' + CRLF 
				::cxmlret += '			<codGrupo>' + cTabela + '</codGrupo>' + CRLF 
				::cxmlret += '			<descricao>' + AllTrim(QRYC6->B1_DESC) + '</descricao>' + CRLF 
				::cxmlret += '			<qtd>' + AllTrim(Transform(QRYC6->C6_QTDVEN, "999999999")) + '</qtd>' + CRLF 
				//::cxmlret += '			<vlUnid>' + AllTrim(Transform(QRYC6->C6_PRCVEN, "9999999.99")) + '</vlUnid>' + CRLF 
				::cxmlret += '			<vlDesconto>' + AllTrim(Transform(QRYC6->C6_DESCONT, "9999999.99")) + '</vlDesconto>' + CRLF 
				::cxmlret += '			<vlTotal>' + AllTrim(Transform(QRYC6->C6_VALOR, "9999999.99")) + '</vlTotal>' + CRLF 
				::cxmlret += '		</produto>' + CRLF 
				QRYC6->(DbSkip()) 
			End 
		EndIf 
 
		//Dados do Posto 
		cQryPos := " SELECT * " 
		cQryPos += " FROM " + RetSqlName("SA1") + " " 
		cQryPos += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' " 
		cQryPos += "   AND D_E_L_E_T_ = ' ' " 
		cQryPos += "   AND A1_COD = '" + cPosCod + "' " 
		cQryPos += "   AND A1_LOJA = '" + cPosLoj + "' " 
 
		cQryPos := ChangeQuery(cQryPos) 
 
		TCQUERY cQryPos NEW ALIAS "QRYPOS" 
		DbSelectArea("QRYPOS") 
 
		QRYPOS->(DbGoTop()) 
		If QRYPOS->(!Eof()) 
 
			aRetPos := U_VNDA380(QRYPOS->A1_END) 
 
			::cxmlret += '		<posto>' + CRLF 
			::cxmlret += '			<nome>' + AllTrim(QRYPOS->A1_NOME) + '</nome>' + CRLF 
			::cxmlret += '			<cnpj>' + AllTrim(QRYPOS->A1_CGC) + '</cnpj>' + CRLF 
			::cxmlret += '			<endereco>' + CRLF 
			::cxmlret += '				<desc>' + aRetPos[1] + '</desc>' + CRLF 
			::cxmlret += '				<bairro>' + AllTrim(QRYPOS->A1_BAIRRO) + '</bairro>' + CRLF 
			::cxmlret += '				<numero>' + aRetPos[2] + '</numero>' + CRLF 
			::cxmlret += '				<compl>' + AllTrim(QRYPOS->A1_COMPLEM) + '</compl>' + CRLF 
			::cxmlret += '				<cep>' + AllTrim(QRYPOS->A1_CEP) + '</cep>' + CRLF 
			::cxmlret += '				<fone>' + AllTrim(QRYPOS->A1_DDD) + AllTrim(QRYPOS->A1_TEL) + '</fone>' + CRLF 
			::cxmlret += '				<cidade>' + CRLF 
			::cxmlret += '					<nome>' + AllTrim(QRYPOS->A1_MUN) + '</nome>' + CRLF 
			::cxmlret += '					<uf>' + CRLF 
			::cxmlret += '						<sigla>' + AllTrim(QRYPOS->A1_EST) + '</sigla>' + CRLF 
			::cxmlret += '					</uf>' + CRLF 
			::cxmlret += '				</cidade>' + CRLF 
			::cxmlret += '			</endereco>' + CRLF 
			::cxmlret += '		</posto>' + CRLF 
		EndIf 
 
		DbSelectArea("QRYPOS") 
		DbCloseArea() 
 
		If Empty(QRYC5->C5_LIBEROK) .And. Empty(QRYC5->C5_NOTA) .And. Empty(QRYC5->C5_BLQ)		//Pedido em Aberto 
			::cxmlret += '		<statusFatura>1</statusFatura>' + CRLF	//1 - Pedido em Aberto 
		ElseIf !Empty(QRYC5->C5_NOTA) .Or. QRYC5->C5_LIBEROK=='E' .And. Empty(QRYC5->C5_BLQ)	   	//Pedido Encerrado 
			::cxmlret += '		<statusFatura>2</statusFatura>' + CRLF	//2 - Pedido Encerrado 
		EndIf 
 
		::cxmlret += '</pedidoFullType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<pedidoFullType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>não foi possível carregar os dados do pedido</exception>' + CRLF 
		::cxmlret += '</pedidoFullType>' + CRLF 
	EndIf 
 
	varinfo("::cxmlret", ::cxmlret) 
 
	DbSelectArea("QRYC5") 
	DbCloseArea() 
 
	DbSelectArea("QRYC6") 
	DbCloseArea() 
 
Return(lReturn)

/*/{Protheus.doc} savePedidos 
 
Metodo referente a geração de fila de pedidos a serem processados 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD savePedidos WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cGetID	:= "" 
	Local cTime		:= Time() 
	Local cDate		:= DtoC(Date()) 
	Local cGetError	:= "" 
 
	Private cContSite := "" 
 
	U_GTPutRet('savePedidos','A') 
 
	nTime := Seconds() 
 
	cTime := StrTran(Time(),":","") 
 
	cDate := StrTran(DTOC(Date()),"/","") 
 
	cGetID := cDate + cTime 
 
	If U_VNDA130(::xml,cGetID,@cGetError) 
 
		//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>' + cGetError + '</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	Else 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '    <code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>' + cGetError + '</msg>' + CRLF 
		::cxmlret += '    <exception>Nao foi possivel distribuir a requisicao. Tente novamente mais tarde.</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
 
		U_GTPutOUT(cGetID,"F","",{"CRIFILAALL",{.F.,"E00002","","Fila Geral não Distribuida"}}) 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} getListaDetalhesVoucher 
 
Metodo referente ao retorno informações de vouchers 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getListaDetalhesVoucher WSRECEIVE NULLPARAM WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cSQL		:= "" 
	Local cTRB		:= "" 
	Local cData		:= "" 
	Local cAno		:= "" 
	Local cDia		:= "" 
	Local cMes		:= "" 
	Local cFatura	:= "" 
	Local cStatus	:= "" 
	Local cTipFat	:= "" 
	Local nI		:= 0 
 
	U_GTPutRet('getListaDetalhesVoucher','A') 
 
	// Pego todos os voucher ativos e que nao foram enviados para o site 
	cSQL += "SELECT ZF_COD, " + CRLF 
	cSQL += "       ZF_CODFLU, " + CRLF 
	cSQL += "       ZF_PRODEST, " + CRLF 
	cSQL += "       ZF_PDESGAR, " + CRLF 
	cSQL += "       ZF_QTDVOUC, " + CRLF 
	cSQL += "       ZF_DTVALID, " + CRLF 
	cSQL += "       ZF_ATIVO, " + CRLF 
	cSQL += "       ZF_TIPOVOU, " + CRLF 
	cSQL += "       ZH_DESCRI, " + CRLF 
	cSQL += "       ZH_EMNTVEN, " + CRLF 
	cSQL += "       ZF_TPFATUR, " + CRLF 
	cSQL += "       ZF_GRPPROJ, " + CRLF 
	cSQL += "       ZF_DESMOT, " + CRLF 
	cSQL += "       ZF_OBS, " + CRLF 
	cSQL += "       ZF_CODREV, " + CRLF 
	cSQL += "       ZF_CPF, " + CRLF 
	cSQL += "       SZF.R_E_C_N_O_ RECSZF, " + CRLF 
	cSQL += "       SZF.D_E_L_E_T_ RECDEL " + CRLF 
	cSQL += "FROM " + RetSqlName('SZF') + " SZF " + CRLF 
	cSQL += "       INNER JOIN " + RetSqlName('SZH') + " SZH " + CRLF 
	cSQL += "               ON SZH.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                  AND ZH_FILIAL = '" + xFilial('SZH') + "' " + CRLF 
	cSQL += "                  AND ZH_TIPO = ZF_TIPOVOU " + CRLF 
	cSQL += "WHERE  SZF.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "       AND ZF_FILIAL = '" + xFilial('SZF') + "' " + CRLF 
	cSQL += "       AND ZF_ATIVO = 'S' " + CRLF 
	cSQL += "       AND ZF_FLAGSIT = ' ' " + CRLF 
	cSQL += "       AND ZF_SALDO > 0 " + CRLF 
	cSQL += "       AND ZF_PRODEST <> ' ' " + CRLF 
	cSQL += "       AND ZF_DTVALID >= '" + DtoS( Date() ) + "' " + CRLF 
	cSQL += "       AND ROWNUM <= 1000" + CRLF 
 
	cTRB := GetNextAlias() 
	cSQL := ChangeQuery( cSQL ) 
 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.) 
 
	(cTRB)->(DbGoTop()) 
	If (cTRB)->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listVoucherType>' + CRLF 
		::cxmlret += '	<code>1</code>' + CRLF 
		::cxmlret += '	<msg>Consulta concluída com sucesso.</msg>' + CRLF 
		::cxmlret += '	<exception></exception>' + CRLF 
		While (cTRB)->(!Eof()) 
 
			aAdd(aVouchers, (cTRB)->RECSZF) 
 
			cData	:= StoD( (cTRB)->ZF_DTVALID ) 
			cAno	:= StrZero(Year(cData),4) 
			cMes	:= StrZero(Month(cData),2) 
			cDia	:= StrZero(Day(cData),2) 
			cData	:= cDia + "/" + cMes + "/" + cAno 
 
			IF Empty( (cTRB)->ZH_EMNTVEN ) 
				cFatura := 'N' 
			Else 
				cFatura := AllTrim( (cTRB)->ZH_EMNTVEN ) 
			EndIF 
 
			If (cTRB)->ZF_TPFATUR == "P" 
				cTipFat := 'Postecipado' 
			ElseIf (cTRB)->ZF_TPFATUR == "A" 
				cTipFat := 'Antecipado' 
			Else 
				cTipFat := '' 
			EndIf 
 
			If (cTRB)->ZF_ATIVO == 'S' .AND. Empty((cTRB)->RECDEL) 
				cStatus := '1' 
			Else 
				cStatus := '2' 
			EndIf 
 
			::cxmlret += '	<voucher>' + CRLF 
			::cxmlret += '		<codigo>' + AllTrim((cTRB)->ZF_COD) + '</codigo>' + CRLF 
			::cxmlret += '		<fluxo>' + AllTrim((cTRB)->ZF_CODFLU) + '</fluxo>' + CRLF 
			::cxmlret += '		<tipovoucher>' + AllTrim((cTRB)->ZF_TIPOVOU) + '</tipovoucher>' + CRLF 
			::cxmlret += '		<descri>' + AllTrim( SZH->ZH_DESCRI ) + '</descri>' + CRLF 
			::cxmlret += '		<codProd>' + AllTrim((cTRB)->ZF_PRODEST) + '</codProd>' + CRLF 
			::cxmlret += '		<codProdGar>' + AllTrim((cTRB)->ZF_PDESGAR) + '</codProdGar>' + CRLF 
			::cxmlret += '		<qtd>' + AllTrim(Transform((cTRB)->ZF_QTDVOUC,"999999999")) + '</qtd>' + CRLF 
			::cxmlret += '		<dtValid>' + cData + '</dtValid>' + CRLF 
			::cxmlret += '		<motivo>' + AllTrim((cTRB)->ZF_DESMOT) + '</motivo>' + CRLF 
			::cxmlret += '		<obs>' + AllTrim((cTRB)->ZF_OBS) + '</obs>' + CRLF 
			::cxmlret += '		<status>' + cStatus + '</status>' + CRLF 
			::cxmlret += '		<fatura>' + cFatura + '</fatura>' + CRLF 
			::cxmlret += '		<tipfat>' + cTipFat + '</tipfat>' + CRLF 
			::cxmlret += '		<grupo>' + AllTrim((cTRB)->ZF_GRPPROJ) + '</grupo>' + CRLF 
			::cxmlret += '		<codrev>' + AllTrim((cTRB)->ZF_CODREV) + '</codrev>' + CRLF 
			::cxmlret += '		<cpf>' + AllTrim((cTRB)->ZF_CPF) + '</cpf>' + CRLF 
			::cxmlret += '	</voucher>' + CRLF 
 
			(cTRB)->(DbSkip()) 
		End 
		::cxmlret += '</listVoucherType>' + CRLF 
 
		DbSelectArea("SZF") 
		DbSetOrder(1) 
		For nI := 1 To Len(aVouchers) 
			DbGoTo(aVouchers[nI]) 
			RecLock("SZF", .F.) 
			Replace SZF->ZF_FLAGSIT With "X" 
			SZF->(MsUnLock()) 
		Next nI 
 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listVoucherType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Nenhum Voucher foi encontrado.</exception>' + CRLF 
		::cxmlret += '</listVoucherType>' + CRLF 
	EndIf 
 
	(cTRB)->( dbCloseArea() ) 
	FErase( cTRB + GetDBExtension() ) 
 
Return(lReturn)

/*/{Protheus.doc} resetSenhas 
 
Metodo referente ao reset de senha de contatos 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD resetSenhas WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local oXml		:= Nil 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cSenha	:= "" 
	Local cSenMail  := "" 
	Local cCorpo	:= "" 
	Local cSql		:= "" 
	Local cCto		:= "" 
	Local cDados    := "" 
	Local cSubject  := Alltrim(GetMv("VNDA120_RE",,"")) 
	Local nI		:= 0 
 
	U_GTPutRet('resetSenhas','A') 
 
	While File("\debug\debug.dbg") 
 
		msgCon("[RESETSENHAS] AGUARDANDO DEBUG "+ Time()) 
		Sleep(3000) 
		msgCon("[RESETSENHAS] FIM SLEEP "+ Time()) 
	Enddo 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	U_GTPutIN("","R","",.T.,{"RESETSENHAS","","Solicitação Reset de senha",::xml},"") 
 
	If ValType(oXml:_LISTCONTATOTYPE:_CONTATO) <> "A" 
		XmlNode2Arr( oXml:_LISTCONTATOTYPE:_CONTATO, "_CONTATO" ) 
	EndIf 
 
	If Len(oXml:_LISTCONTATOTYPE:_CONTATO) > 0 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listContatoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>As senhas foram renovadas com sucesso</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
 
		For nI := 1 To Len(oXml:_LISTCONTATOTYPE:_CONTATO) 
 
			cSql := " SELECT " 
			cSql += "   R_E_C_N_O_ NRECSU5 " 
			cSql += " FROM " 
			cSql += RetSqlName("SU5") 
			cSql += " WHERE " 
			cSql += "   U5_FILIAL = '"+xFilial("SU5")+"' AND " 
			cSql += "   UPPER(U5_EMAIL) = '"+Upper(Alltrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT))+"' AND " 
			cSql += "   D_E_L_E_T_ = ' ' " 
 
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYSU5",.F.,.T.) 
 
			cSenMail	:= AllTrim(Str(aleatorio(9999999999,10)))	//Faco uma senha randomica numerica 
			cSenha		:= SHA1(cSenMail) 
 
			If QRYSU5->NRECSU5 > 0 
 
				SU5->(DbGoTo(QRYSU5->NRECSU5)) 
 
				cCto	:= SU5->U5_CONTAT 
 
				RecLock('SU5', .F.) 
				SU5->U5_XSENHA := cSenha	//Grava a nova senha criptografada 
				MsUnLock() 
			Else 
				cCto := SubStr(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT,1,at("@",oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT)-1) 
 
				U_GTPutOUT("","R","",{"RESETSENHAS",{.F.,"E00005",""," email nao identificado "+AllTrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT)+" para reset de senha"+CRLF+::xml}},"") 
			EndIf 
			//Notifica Hub Sobre Reset de Senha 
			oWsObj := WSVVHubServiceService():New() 
 
			oWsObj:sendMessage("E-MAIL","Reset senha enviado para: "+Alltrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT)) 
 
			cDados := cCto +';'+ cSenMail 
			cCorpo := U_VNDA730( cDados, 'VNDA120Reset.htm'  ) 
			/* 
			cCorpo		:= "Prezado Sr.(a) " + cCto + ", " + CRLF 
			cCorpo		+= "Esta é uma mensagem automática, referente é renovação da senha do Portal de Vendas Certisign" + CRLF 
			cCorpo		+= "Sua nova senha é: " + cSenMail + CRLF 
			cCorpo		+= "Caso necessário, atualize a senha no seu cadastro no site." + CRLF 
			cCorpo		+= "Agradecemos sua atenção," + CRLF 
			cCorpo		+= "Equipe Certisign" + CRLF 
			*/ 
			// Envio e-mail para o contato com a nova senha 
			If U_VNDA290(cCorpo, AllTrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT), cSubject) 
				U_GTPutOUT("","R","",{"RESETSENHAS",{.T.,"M00001","","Mensagem enviada com sucesso"+CRLF+AllTrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT)+CRLF+cCorpo}},"") 
			Else 
				U_GTPutOUT("","R","",{"RESETSENHAS",{.F.,"E00005","","Mensagem não enviada"+CRLF+AllTrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT)+CRLF+cCorpo}},"") 
			EndIf 
 
			::cxmlret += '		<contato>' + CRLF 
			::cxmlret += '			<email>' + AllTrim(oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT) + '</email>' + CRLF 
			::cxmlret += '			<senha>' + cSenha + '</senha>' + CRLF 
			::cxmlret += '		</contato>' + CRLF 
 
			QRYSU5->(DbCloseArea()) 
 
		Next nI 
		::cxmlret += '</listContatoType>' + CRLF 
 
	Else 
 
		U_GTPutOUT("","R","",{"RESETSENHAS",{.F.,"E00005","","Xml de contatos enviado pelo site com Inconsistências."+CRLF+::xml}},"") 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listContatoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF 
		::cxmlret += '    <code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg></msg>' + CRLF 
		::cxmlret += '    <exception>Xml enviado não pode ser interpretado</exception>' + CRLF 
		::cxmlret += '</listContatoType>' + CRLF 
 
	EndIf 
Return(lReturn)

/*/{Protheus.doc} saveOrUpdateContatos 
 
Metodo referente a alteração de dados de contatos 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD saveOrUpdateContatos WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local oXml		:= Nil 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local aDados	:= {} 
	Local cNome		:= "" 
	Local cCpf		:= "" 
	Local cEmail	:= "" 
	Local cSenha	:= "" 
	Local cFone		:= "" 
	Local nI		:= 0 
 
	U_GTPutRet('saveOrUpdateContatos','A') 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	If ValType(oXml:_LISTCONTATOTYPE:_CONTATO) <> "A" 
		XmlNode2Arr( oXml:_LISTCONTATOTYPE:_CONTATO, "_CONTATO" ) 
	EndIf 
 
	For nI := 1 To Len(oXml:_LISTCONTATOTYPE:_CONTATO) 
		cNome	:= oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_NOME:TEXT 
		cCpf	:= oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_CPF:TEXT 
		cEmail	:= oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_EMAIL:TEXT 
		cSenha	:= oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_SENHA:TEXT 
		cFone	:= oXml:_LISTCONTATOTYPE:_CONTATO[nI]:_FONE:TEXT 
 
		aDados := {cNome, cCpf, cEmail, cSenha, cFone} 
 
		//Chama a funcao que faz a criacao do contato 
		//		Begin Transaction 
		aDados := U_VNDA120(cCpf, aDados) 
		//		End Transaction 
	Next nI 
 
	If Valtype(aDados)== "A" .and. Len(aDados) >= 2 
		If aDados[1] 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>' + aDados[2] + '</msg>' + CRLF 
			::cxmlret += '    <exception></exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
 
		Else 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '    <code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
			::cxmlret += '    <msg>' + aDados[2] + '</msg>' + CRLF 
			::cxmlret += '    <exception>não houve comunicação com o Protheus.</exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
 
		EndIf 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '    <code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Inconsistência ao criar contato </msg>' + CRLF 
		::cxmlret += '    <exception>não houve comunicação com o Protheus.</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 
Return(lReturn)

/*/{Protheus.doc} saveOrUpdatePosto 
 
Metodo referente a alteração de dados de postos 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD saveOrUpdatePosto WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local oXml		:= Nil 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local aDados	:= {} 
	Local cNumPed	:= "" 
	Local cPosto	:= "" 
	Local nI		:= 0 
 
	U_GTPutRet('saveOrUpdatePosto','A') 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	If ValType(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A" 
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" ) 
	EndIf 
 
	For nI := 1 To Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) 
		cNumPed	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_NUMERO:TEXT 
		cPosto	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_POSTO:_CODGAR:TEXT 
 
		aDados := {.F.,''} 
		// Grava dados do posto no pedido 
 
		DbSelectArea("SC5") 
		dbOrderNickNAme('PEDSITE') //C5_FILIAL + C5_XNPSITE 
 
		if DbSeek(xFilial("SC5") + cNumPed) 
			RecLock("SC5", .F.) 
			Replace SC5->C5_XPOSTO With cPosto 
			MsUnLock() 
 
			aDados[1]:= .T. 
			aDados[2]:= 'Pedido '+cNumPed+'atualizado com sucesso para o Posto: '+cPosto 
		Else 
			aDados[1]:= .F. 
			aDados[2]:= 'Pedido '+cNumPed+' não encontrado' 
		Endif 
	Next nI 
 
	If aDados[1] 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>' + aDados[2] + '</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '    <code>0</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>' + aDados[2] + '</msg>' + CRLF 
		::cxmlret += '    <exception>não houve comunicação com o Protheus.</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} getlistaprodutos 
 
Metodo referente ao retorno de informações de produtos 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getlistaprodutos WSRECEIVE NULLPARAM WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cQryDA	:= "" 
	Local nQtd		:= 0 
	Local cCodAnt	:= "" 
	Local cCodTbA	:= "" 
	Local cTabPrc	:= GetMV("MV_XTABPRC",,"001") 
 
	U_GTPutRet('getlistaprodutos','A') 
 
	//Pego as faixas da tabela de preco com codigos do produto, combo e GAR 
	cQryDA := " SELECT DA1_CODPRO, DA1_QTDLOT, DA1_PRCVEN, DA1_CODTAB, DA1_CODCOB, DA1_CODGAR, MAX(DA1.R_E_C_N_O_) RECDA1, SB1.B1_DESC, SB1.B1_PRV1 " 
	cQryDA += " FROM " + RetSqlName("DA1") + " DA1 " 
	cQryDA += " INNER JOIN " + RetSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = '" + xFilial("DA0") + "' AND DA0.D_E_L_E_T_ = ' ' AND DA0.DA0_CODTAB = DA1.DA1_CODTAB AND DA0.DA0_XFLGEN = ' ' " 
	cQryDA += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.D_E_L_E_T_ = ' ' " 
	cQryDA += " WHERE DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " 
	cQryDA += "   AND DA1.D_E_L_E_T_ = ' ' " 
	cQryDA += "   AND DA1.DA1_PRCVEN > 0 " 
	cQryDA += " GROUP BY DA1_CODPRO, DA1_QTDLOT, DA1_PRCVEN, DA1_CODTAB, DA1_CODCOB, DA1_CODGAR, SB1.B1_DESC, SB1.B1_PRV1 " 
	cQryDA += " ORDER BY DA1_CODPRO, DA1_CODTAB " 
 
	cQryDA := ChangeQuery(cQryDA) 
 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDA),"QRYDA",.F.,.T.) 
	DbSelectArea("QRYDA") 
 
	QRYDA->(DbGoTop()) 
	If QRYDA->(!Eof()) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listProdutoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF 
		::cxmlret += '    <code>1</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>Solicitação das informações do(s) produto(s) ok.</msg>' + CRLF 
		::cxmlret += '    <exception></exception>' + CRLF 
		cCodAnt := "" 
		cCodTbA := "" 
		While QRYDA->(!Eof()) 
			If !(QRYDA->DA1_CODTAB $ cTabPrc) 
				QRYDA->(DbSkip()) 
				Loop 
			EndIf 
			nQtd++ 
			If cCodAnt <> QRYDA->DA1_CODPRO 
				::cxmlret += '	<produto>' + CRLF 
				::cxmlret += '		<descricao>' + AllTrim(QRYDA->B1_DESC) + '</descricao>' + CRLF 
				::cxmlret += '		<codProd>' + AllTrim(QRYDA->DA1_CODPRO) + '</codProd>' + CRLF 
				//::cxmlret += '		<vlUnid>' + AllTrim(Transform(QRYDA->B1_PRV1,"999999.99")) + '</vlUnid>' + CRLF 
				//::cxmlret += '		<vlUnid>' + AllTrim(Transform(QRYDA->DA1_PRCVEN,"999999.99")) + '</vlUnid>' + CRLF 
			EndIf 
			::cxmlret += '		<faixa>' + CRLF 
			::cxmlret += '			<minimo>' + AllTrim(Transform(nQtd,"999999999")) + '</minimo>' + CRLF 
			::cxmlret += '			<maximo>' + AllTrim(Transform(QRYDA->DA1_QTDLOT,"999999999")) + '</maximo>' + CRLF 
			::cxmlret += '			<valor>' + AllTrim(Transform(QRYDA->DA1_PRCVEN,"999999.99")) + '</valor>' + CRLF 
			::cxmlret += '			<tabelaPreco>' + AllTrim(QRYDA->DA1_CODTAB) + '</tabelaPreco>' + CRLF 
			::cxmlret += '			<codFaixa>' + AllTrim(Str(QRYDA->RECDA1)) + '</codFaixa>' + CRLF 
			::cxmlret += '			<codProdGAR>' + AllTrim(QRYDA->DA1_CODGAR) + '</codProdGAR>' + CRLF 
			::cxmlret += '			<codCombo>' + AllTrim(QRYDA->DA1_CODCOB) + '</codCombo>' + CRLF 
			::cxmlret += '		</faixa>' + CRLF 
			nQtd 	:= QRYDA->DA1_QTDLOT 
			cCodAnt	:= QRYDA->DA1_CODPRO 
			cCodTbA	:= QRYDA->DA1_CODTAB 
			QRYDA->(DbSkip()) 
			If cCodTbA <> QRYDA->DA1_CODTAB 
				nQtd := 0 
			EndIf 
			If cCodAnt <> QRYDA->DA1_CODPRO .Or. QRYDA->(Eof()) 
				nQtd := 0 
				::cxmlret += '	</produto>' + CRLF 
			EndIf 
		End 
		::cxmlret += '</listProdutoType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<listProdutoType>' + CRLF 
		::cxmlret += '    <code>2</code>' + CRLF //1=sucesso na operação; 0=erro 
		::cxmlret += '    <msg>não foi encontrado nenhum dado para sua consulta.</msg>' + CRLF 
		::cxmlret += '    <exception>Solicitação não pode ser atendida</exception>' + CRLF 
		::cxmlret += '</listProdutoType>' + CRLF 
	EndIf 
 
	DbSelectArea("QRYDA") 
	DbCloseArea() 
 
	MEMOWRITE("\system\getlistaprodutos.xml", ::cxmlret) 
 
Return(lReturn)

/*/{Protheus.doc} getListaPedidosStatus 
 
Metodo referente ao retorno de lista de pedidos com status 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getListaPedidosStatus WSRECEIVE NULLPARAM WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
 
	U_GTPutRet('getListaPedidosStatus','A') 
 
	//metodo foi desativado para ser utilizado atreves de mensagem no hub 
	::cxmlret := XML_VERSION + CRLF 
	::cxmlret += '<listPedidoStatus xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF 
	::cxmlret += '	<code>2</code>' + CRLF 
	::cxmlret += '	<msg>não foi retornado nenhum dado para sua consulta.</msg>' + CRLF 
	::cxmlret += '	<exception></exception>' + CRLF 
	::cxmlret += '</listPedidoStatus>' + CRLF 
 
Return(lReturn) 
 
/*/{Protheus.doc} updateFormaPag 
 
Metodo referente a validação e alteração de forma de pagamento de pedido de vendas 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD updateFormaPag WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local lRet		:= .T. 
	Local cXNPSite	:= "" 
	Local cNumCart	:= "" 
	Local cNomTit	:= "" 
	Local cCodSeg	:= "" 
	Local cDtVali	:= "" 
	Local cParcela	:= "" 
	Local cTipCar	:= " " 
	Local cLinDig	:= "" 
	Local cNumVOu	:= "" 
	Local nQtdVou	:= 0 
	Local cQrySC5	:= "" 
	Local cQrySC6	:= "" 
	Local aProdutos	:= {} 
	Local aRVou		:= {.T., ""} 
	Local bVldPed	:= {|a,b| IIf(!Empty(a),a,b)} 
	Local cPedLog	:= "" 
	Local cPedGar	:= "" 
	Local cCombo	:= "" 
	Local cProGar	:= "" 
	Local cCondPag	:= GetNewPar("MV_XCPSITE", "0=000,1=001,2=2X ,3=3XA,4=4XA,5=5XA,6=6XA") 
	Local cNaturez	:= GetMv( 'MV_XNATVST', .F. ) //GetNewPar("MV_XNATVST", "1=FT010013,2=FT010014,3=FT010012") 
	Local cTipShop	:= " " 
	Local cProProt 	:= "" 
	Local nQtdPro	:= 0 
	Local nVlrPro	:= 0 
	Local cMenNot	:= "" 
	Local cMenNot1	:= "" 
	Local cMenNot2	:= "" 
	Local cAdm		:= "" 
	Local lMenNot	:= .F. 
	Local cOperNPF	:= GetNewPar("MV_XOPENPF", "61,62") 
	Local lRecPag	:= .F. 
	Local cId       := '' 
	Local nI        := 0 
 
	Private oXml		:= Nil 
 
	U_GTPutRet('updateFormaPag','A') 
 
	aCondPag		:= StrTokArr(cCondPag,",") 
	aNaturez		:= StrTokArr(cNaturez,",") 
	cTime := StrTran(Time(),":","") 
	cDate := StrTran(DTOC(Date()),"/","") 
	cGetID := cDate + cTime 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	If ValType(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A" 
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" ) 
	EndIf 
 
	For nI := 1 To Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) 
 
		cXNPSite	:= AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_NUMERO:TEXT)		//Numero do Pedido do Site 
		cID:=cGetID+cXNPSite 
		DbSelectArea("SC5") 
		//DbSetOrder(8) 
		SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada 
		If DbSeek(xFilial("SC5") + cXNPSite) 
			cPedGar		:= SC5->C5_CHVBPAG 
		Else 
			cPedGar		:= "" 
		EndIf 
 
		cPedLog		:= Eval(bVldPed,cPedGar,cXNPSite) 
 
		aProdutos	:= {} 
		aXmlCC      := {'','',''} 
		aRVou		:= {.T.,""} 
 
		cNumCart	:= "" 
		cNomTit		:= "" 
		cCodSeg		:= "" 
		cDtVali		:= "" 
		cParcela	:= "" 
		cTipCar		:= "" 
		cLinDig		:= "" 
		cNumVou		:= "" 
		cTipShop	:= "0" 
		cDocCar     :='' 
		cDocAut     :='' 
		cCodConf    :='' 
 
		nQtdVou		:= 0 
 
		If "cartao" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_XSI_TYPE:TEXT 
 
			cForPag		:= "2"  //cartão de Credito 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_NUMERO:TEXT") <> "U" 
				cNumCart	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_NUMERO:TEXT						//Numero do Cartao 
			Else 
				cNumCart	:= "Erro" 
			EndIf 
			cNomTit		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_NMTITULAR:TEXT					//Nome do Titular 
			cCodSeg		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_CODSEG:TEXT						//Codigo de Seguranca 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_DTVALID:TEXT") <> "U" 
				cDtVali		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_DTVALID:TEXT	//Data de Validade do Cartao 
			EndIf 
			cParcela	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_PARCELAS:TEXT					//Numero de Parcelas 
			cTipCar		:= Alltrim(Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_TIPO:TEXT))						//Tipo do Cartao de Credito 
 
			If cTipCar == "9" .or. cTipCar == "10" 
				cForPag := "3" //Debito 9=Visa ou 10=Master 
			EndIf 
 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_DOCUMENTO:TEXT") <> "U" 
				cDocCar := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_DOCUMENTO:TEXT 
			Endif 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_AUTORIZACAO:TEXT") <> "U" 
				cDocAut := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_AUTORIZACAO:TEXT 
			Endif 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_CONFIRMACAO:TEXT") <> "U" 
				cCodConf:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_CONFIRMACAO:TEXT 
			Endif 
 
			aXmlCC[1] := cDocCar 
			aXmlCC[2] := cCodConf 
			aXmlCC[3] := cDocAut 
 
		ElseIf "boleto" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_XSI_TYPE:TEXT 
			cForPag		:= "1" //Boleto 
			cLinDig		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_LINHADIGITAVEL:TEXT				//Linha Digitavel 
		ElseIf "voucher" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_XSI_TYPE:TEXT 
			cForPag		:= "6" //Voucher 
			cNumVou		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_NUMERO:TEXT						//Numero do Voucher 
			nQtdVou		:= Val(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_QTCONSUMIDA:TEXT)			//Quantidade Consumida 
		ElseIf "debito" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_XSI_TYPE:TEXT 
			cForPag		:= "7" //Shopline Itau 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_PAGAMENTO:_TIPO:TEXT") <> "U" 
				cTipShop    := Alltrim(Str(aScan(__Shop,{|x| x == oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_PAGAMENTO:_TIPO:TEXT }))) 
			EndiF 
 
			If cTipShop $ "4,5" 
				cForPag := "4" // Shopline BB 
			EndIf 
		EndIf 
 
		If ValType(aCondPag)=="A" .and. Len(aCondPag) > 0 
			cParcela := Alltrim(Str(Val(cParcela))) 
			nPosPg := ascan(aCondPag,{|x| SubStr(alltrim(x),1,At('=',x)-1) == cParcela }) 
			If nPosPg > 0 
				nPosAt := At("=",aCondPag[nPosPg]) 
				If nPosAt > 0 
					cCondPag := SubStr( aCondPag[nPosPg],nPosAt+1,Len(aCondPag[nPosPg]) ) 
				Else 
					cCondPag := Right(aCondPag[nPosPg],3) 
				EndIf 
			Else 
				cCondPag := "000" 
			EndIf 
		Else 
			cCondPag := "000" 
		EndIf 
 
		If ValType(aNaturez)=="A" .and. Len(aNaturez) > 0 
			nPosNt := ascan(aNaturez,{|x| SubStr(alltrim(x),1,2) == Alltrim(Strzero(Val(cTipCar),2)) }) 
			If nPosNt > 0 
				cNaturez := Right(alltrim(aNaturez[nPosNt]),8) 
			ElseIF Empty(cTipCar) 
				cNaturez := "FT010010" 
			Else	 
				cNaturez := "FT010017" 
			EndIf 
		Else 
			IF Empty(cTipCar) 
				cNaturez := "FT010010" 
			Else 
				cNaturez := "FT010017" 
			EndIF 
		EndIf 
 
		If cTipCar == "1" 
			cAdm := "VIS" 
		ElseIf cTipCar == "2" 
			cAdm := "RED" 
		ElseIf cTipCar == "3" 
			cAdm := "AME" 
		ElseIf cTipCar == "4" 
			cAdm := "AUR" 
		ElseIf cTipCar == "5" 
			cAdm := "DIS" 
		ElseIf cTipCar == "6" 
			cAdm := "JCB" 
		ElseIf cTipCar == "7" 
			cAdm := "DIN" 
		ElseIf cTipCar == "8" 
			cAdm := "ELO" 
		ElseIf cTipCar == "9" 
			cAdm := "DVIS" 
		ElseIf cTipCar == "10" 
			cAdm := "DMAS" 
		ElseIf cTipCar == "11" 
			cAdm := "VCH" 
		ElseIf cTipCar == "12" 
			cAdm := "SHOPLINE" 
		ElseIf cTipCar == "13" 
			cAdm := "DBB" 
		ElseIF cTipCar == "14" //OneBuy 
			cAdm :="ONEBUY" 
			cNaturez := "FT010016" 
		ElseIF cTipCar == "15" //Documento único de arregadação 
			cAdm :="DUA" 
		EndIf 
 
		//Pego o recno do pedido feito pelo site, para pegar as informacoes do pedido protheus 
		cQrySC5 := "SELECT R_E_C_N_O_ RECPED " 
		cQrySC5 += "FROM " + RetSqlName("SC5") + " " 
		cQrySC5	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' " 
		cQrySC5 += "  AND C5_XNPSITE = '" + cXNPSite + "' " 
		cQrySC5 += "  AND D_E_L_E_T_ = ' ' " 
 
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.) 
		DbSelectArea("QRYSC5") 
 
		If QRYSC5->(!Eof()) 
			DbSelectArea("SC5") 
 
			DbGoTo(QRYSC5->RECPED) 
 
			//Pego os itens do pedido 
			cQrySC6 := "SELECT R_E_C_N_O_ RECSC6 " 
			cQrySC6 += "FROM " + RetSqlName("SC6") + " " 
			cQrySC6 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
			cQrySC6 += "  AND C6_NUM = '" + SC5->C5_NUM + "' " 
			If !Empty(cOperNPF) 
				cQrySC6 += "  AND (C6_XOPER IN ('51','52','"+Alltrim(StrTran(cOperNPF,",","','"))+"') )  " 
			Else 
				cQrySC6 += "  AND C6_XOPER IN ('51','52') " 
			Endif 
			cQrySC6 += "  AND D_E_L_E_T_ = ' ' " 
 
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"QRYSC6",.F.,.T.) 
			DbSelectArea("QRYSC6") 
 
			QRYSC6->(DbGoTop()) 
			While QRYSC6->(!Eof()) 
				DbSelectArea("SC6") 
				DbGoTo(QRYSC6->RECSC6) 
 
				If !Empty(SC6->C6_XCDPRCO) .and. !lMenNot 
					cProGar  := Alltrim(SC6->C6_PROGAR) 
					cProProt := "" 
					nQtdPro	 := 1 
					nVlrPro	 := SC6->C6_PRCVEN 
					cMenNot1 := MakeMens(cProGar,cProProt,nQtdPro,SC5->C5_TOTPED,cAdm,SC5->C5_CHVBPAG,SC5->C5_XNPSITE) 
					cMenNot2 := cMenNot1 
					lMenNot  := .T. 
				ElseIf !lMenNot 
					cProGar  := "" 
					cProProt := Alltrim(SC6->C6_PRODUTO) 
					nQtdPro	 := SC6->C6_QTDVEN 
					nVlrPro	 := SC6->C6_PRCVEN 
					cMenNot1 := MakeMens(cProGar,cProProt,nQtdPro,nVlrPro,cAdm,SC5->C5_CHVBPAG,SC5->C5_XNPSITE) 
					cMenNot2 += cMenNot1 
				EndIf 
 
				QRYSC6->(DbSkip()) 
			End 
 
			cMenNot  := cMenNot2 
 
			//Atualizo as informacoes do pedido 
			RecLock("SC5", .F.) 
			IF Empty( SC5->C5_XTIDCC ) .And. Empty( SC5->C5_XCODAUT )  
				SC5->C5_CONDPAG := cCondPag // Condicao de Pagamento 
				SC5->C5_TIPMOV  := cForPag	// Forma de pagamento escolhida no site 
				SC5->C5_XNATURE := cNaturez // Natureza 
				SC5->C5_XNUMCAR := cNumCart	// Numero do cartao de credito 
				SC5->C5_XCARTAO := cNumCart // Numero do cartao de credito 
				SC5->C5_XNOMTIT := cNomTit	// Nome do titular do cartao de credito 
				SC5->C5_XCODSEG := cCodSeg	// Codigo de seguranca do cartao de credito 
				SC5->C5_XVALIDA := cDtVali	// Data de validade do cartao de credito 
				SC5->C5_XNPARCE := cParcela	// Numero de parcelas para dividir no cartao de credito 
				SC5->C5_XTIPCAR := IIF(cTipCar=='14','E',	cTipCar) // Bandeira do cartao de credito 1-Visa, 2-Master e 3-American Express E-OneBuy 
				SC5->C5_XDOCUME := cDocCar 
				SC5->C5_XCODAUT := cDocAut 
				SC5->C5_XTIDCC  := cCodConf				 
			EndIF 
 
			SC5->C5_XNPSITE := cXNPSite	// Numero do pedido gerado pelo site 
 
			IF .NOT. Empty( SC5->C5_XLINDIG ) 
				SC5->C5_XLINDIG := cLinDig	// Numero da linha digitavel do boleto 
			EndIF 
 
			IF .NOT. Empty( SC5->C5_XNUMVOU ) 
				SC5->C5_XNUMVOU := cNumvou	// Numero do voucher 
				SC5->C5_XQTDVOU := nQtdVou	// Quantidade consumida pelo voucher 
			EndIF 
 
			SC5->C5_XITAUSP := cTipShop	// Itau ShopLine 
			SC5->C5_MENNOTA := cMenNot  // Mensagem da Nota 
 
			IF .NOT. Empty( cDocAut ) 
				IF SC5->C5_XORIGPV == '8' .AND. .NOT. SC5->C5_XLIBFAT == 'S'//Pedidos de Cursos ainda não liberados pelo Fiscal 
					SC5->C5_XLIBFAT := "P" //Muda status para pendente de análise fiscal 
				End 
			EndIF 
 
			SC5->(MsUnLock()) 
			QRYSC6->(DbCloseArea()) 
 
			//Monta XML para notifica pagamento cartão 
			cTagTipo := '0' 
 
			If Val(cTipShop)> 0 .and. Val(cTipShop) <= Len( __Shop ) 
				cTagTipo := __Shop[val(cTipShop)] 
			Endif 
 
			cXml:='<notificaProcessamentoCartao>' 
			cxml+='  <pedido>' 
			cxml+='    <numero>'+cXNPSite+'</numero>' 
			cxml+='  </pedido>' 
			cxml+='  <confirmacao>' 
			cxml+='    <tipo>'+cTagTipo+'</tipo>' 
			cxml+='    <cartao>'+cNumCart+'</cartao>' 
			cxml+='    <documento>'+cDocCar+'</documento>' 
			cxml+='    <codigoConfirmacao>'+cCodConf+'</codigoConfirmacao>' 
			cxml+='    <autorizacao>'+cDocAut+'</autorizacao>' 
			cxml+='  </confirmacao>' 
			cxml+='</notificaProcessamentoCartao>' 
 
			U_GTPutIN(cID,"A",cPedLog,.T.,{"updateFormaPag",cPedLog,SC5->C5_NUM, cXml},cXNPSite,{cNumCart,cLinDig,cNumvou},aXmlCC) 
 
			//Se a forma de pagamento for igual voucher 
			If cForPag == "2" .AND. !EMPTY(cDocAut) 
				nTime := Seconds() 
				While .t. 
 
					If U_Send2Proc(cXNPSite,"U_Vnda262",cXml,'', '', '') 
 
						Exit 
					Else 
 
						nWait := Seconds()-nTime 
						If nWait < 0 
							nWait += 86400 
						Endif 
 
						If nWait > 10 
							// Passou de 2 minutos tentando ? Desiste ! 
							U_GTPutOUT(cID,"A",cPedLog,{"updateFormaPag","Inconsistência realizar distribuição para vnda262"},cXNPSite) 
							lRet:=.F. 
							EXIT 
						Endif 
 
						// Espera um pouco ( 5 segundos ) para tentar novamente 
 
						Sleep(5000) 
 
					EndIf 
 
				EndDo 
 
			ELSEIf cForPag == "6" 
				//Pego os itens do pedido 
				cQrySC6 := "SELECT R_E_C_N_O_ RECSC6 " 
				cQrySC6 += "FROM " + RetSqlName("SC6") + " " 
				cQrySC6 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
				cQrySC6 += "  AND C6_NUM = '" + SC5->C5_NUM + "' " 
				cQrySC6 += "  AND D_E_L_E_T_ = ' ' " 
 
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"QRYSC6",.F.,.T.) 
				DbSelectArea("QRYSC6") 
 
				cCombo 	:= "" 
				cProdGar:= "" 
 
				QRYSC6->(DbGoTop()) 
				nRecnoSC6:=QRYSC6->RECSC6 
 
				While QRYSC6->(!Eof()) 
					DbSelectArea("SC6") 
					DbGoTo(QRYSC6->RECSC6) 
					RecLock("SC6", .F.) 
					SC6->C6_XNUMVOU := cNumvou 
					SC6->C6_XQTDVOU := nQtdVou 
					SC6->(MsUnLock()) 
 
					cCombo 	:= Alltrim(SC6->C6_XCDPRCO) 
					cProdGar:= Alltrim(SC6->C6_PROGAR) 
 
					QRYSC6->(DbSkip()) 
				End 
 
				DbSelectArea("QRYSC6") 
				QRYSC6->(DbCloseArea()) 
 
				DbSelectArea("SC6") 
				DbGoTo(nRecnoSC6) 
 
				DbSelectArea("SZI") 
				SZI->(DbSetOrder(1)) 
 
				If !Empty(cCombo) .and. SZI->(DbSeek(xFilial("SZI") + cCombo)) 
					AADD(aProdutos, {	SC6->C6_ITEM,;		//[1]Item 
					SZI->ZI_PROKIT,;	//[2]Codigo Produto 
					SC6->C6_QTDVEN,;	//[3]Quantidade 
					SC6->C6_PRCVEN,;	//[4]Valor Unitario 
					SC6->C6_PRCVEN,;	//[5]Valor com desconto 
					SZI->ZI_PREVEN,;	//[6]Valor Total 
					cPedGar,;	        //[7]codigo do pedido gar 
					cCombo,;	        //[8]código do combo 
					SC6->C6_TES  ,;		//[10]TES 
					SC6->C6_XNUMVOU,;	//[11]Numero Voucher 
					SC6->C6_XQTDVOU})	//[12]Saldo Voucher 
 
				Else 
					AADD(aProdutos, {	SC6->C6_ITEM,;		//[1]Item 
					SC6->C6_PRODUTO,;	//[2]Codigo Produto 
					SC6->C6_QTDVEN,;	//[3]Quantidade 
					SC6->C6_PRCVEN,;	//[4]Valor Unitario 
					SC6->C6_PRCVEN,;	//[5]Valor com desconto 
					SC6->C6_VALOR,;		//[6]Valor Total 
					cPedGar,;	        //[7]codigo do pedido gar 
					cCombo,;	        //[8]código do combo 
					SC6->C6_TES  ,;		//[10]TES 
					SC6->C6_XNUMVOU,;	//[11]Numero Voucher 
					SC6->C6_XQTDVOU})	//[12]Saldo Voucher 
				EndIf 
 
				//Monto XML do pedido 
				oPedido  := montarXML( cID, @cError, @cWarning, @nPed ) 
				 
				//Carrego dados do Voucher 
				oVoucher := CSVoucherPV():New( cID, cXNPSite, cPedLog, oPedido:_LISTPEDIDOFULLTYPE:_PEDIDO[ nPed ], cPedGar, SC5->C5_NUM ) 
				 
				//Valido o Voucher 
				aRVou := U_VNDA430( @oVoucher ) 
 
				//Se o voucher foi validado, faco a movimentacao do mesmo 
				If oVoucher:voucherValido 
					//+----------------------------------------------------------------------------------+ 
					//| Renato Ruy - 08/06/2016                                                          | 
					//| Ajusta estrutura para gravar na SZG conforme descrição abaixo.                   | 
					//| Conforme Solicitação Giovanni, não grava no VNDA310 o código do Pedido Protheus. | 
					//+----------------------------------------------------------------------------------+ 
					U_VNDA310( oVoucher ) 
 
					lRecPag 	:= SC6->C6_XOPER $ cOperNPF 
					nTime 		:= Seconds() 
					aParamFun 	:= {SC5->C5_NUM,; 	//Número do pedido 
					Val(cXNPSite),; //Numero de controlo de JOB para log Gtin 
					nil,;     		//Fatura venda 
					nil,;    	 	//Nosso Número para atualização do título a receber 
					oVoucher:geraNFServico,;      //Fatura Serviço 
					oVoucher:geraNFProduto,;      //Fatura produto 
					nil,;           //Quantidade a faturar 
					oVoucher:operacaoVendaHardware,;      //operação de venda Hardware 
					oVoucher:operacaoEntregaHardware,;      //operação de entrega Hardware 
					oVoucher:operacaoVendaServico,;      //operação de venda de Serviço 
					cPedLog,;       //Pedido de Log 
					nil,;           //data do crédito Cnab 
					.T.,;           //Gera recibo de liberação 
					.F.,;           //Gera título para recibo  de liberação 
					nil,;			//Tipo do título de recibo de liberação 
					.F.}           //Fatura entrega de hardware 
					 
					While .t. 
 
						If U_Send2Proc(cID,"U_VNDA190",aParamFun) 
 
							U_GTPutIN(cID,"A",cPedLog,.T.,{"updateFormaPag",cPedLog,SC5->C5_NUM,"Send2Proc Vnda190"},cXNPSite) 
 
							Exit 
						Else 
 
							nWait := Seconds()-nTime 
							If nWait < 0 
								nWait += 86400 
							Endif 
 
							If nWait > 10 
								// Passou de 2 minutos tentando ? Desiste ! 
								U_GTPutOUT(cID,"A",cPedLog,{"updateFormaPag","Inconsistência realizar distribuição para VNDA190"},cXNPSite) 
								lRet:=.f. 
								EXIT 
							Endif 
 
							// Espera um pouco ( 5 segundos ) para tentar novamente 
 
							Sleep(5000) 
 
						EndIf 
 
					EndDo 
 
				EndIf 
 
			ElseIf cForPag == "1" .or. cForPag == "7"  //boleto 
 
				//Pego os itens do pedido 
				cQrySC6 := "SELECT R_E_C_N_O_ RECSC6 " 
				cQrySC6 += "FROM " + RetSqlName("SC6") + " " 
				cQrySC6 += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' " 
				cQrySC6 += "  AND C6_NUM = '" + SC5->C5_NUM + "' " 
				cQrySC6 += "  AND D_E_L_E_T_ = ' ' " 
 
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC6),"QRYSC6",.F.,.T.) 
				DbSelectArea("QRYSC6") 
 
				QRYSC6->(DbGoTop()) 
				While QRYSC6->(!Eof()) 
					DbSelectArea("SC6") 
					DbGoTo(QRYSC6->RECSC6) 
 
					//Zero as informacoes do voucher caso elas existam 
					If !Empty(SC6->C6_XNUMVOU) .AND. SC6->C6_XQTDVOU > 0 
						RecLock("SC6", .F.) 
						SC6->C6_XNUMVOU := "" 
						SC6->C6_XQTDVOU := 0 
						SC6->(MsUnLock()) 
					EndIf 
					QRYSC6->(DbSkip()) 
				End 
 
				//Altero o titulo provisorio, com o novo nosso numero 
				//U_ExcTit(SC5->C5_NUM, cPrefix, cXNPSite, cLinDig, .F.) //aqui 
 
				DbSelectArea("QRYSC6") 
				QRYSC6->(DbCloseArea()) 
			EndIf 
		Else 
			lRet := .F. 
		EndIf 
		DbSelectArea("QRYSC5") 
		QRYSC5->(DbCloseArea()) 
	Next nI 
 
	If lRet 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Pedidos alterados com sucesso.</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>2</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Pedidos não foram alterados.</msg>' + CRLF 
		::cxmlret += '		<exception>não houve retorno para sua pesquisa.</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 
 
Return(lReturn)

/*/{Protheus.doc} updateConfirmarEntregas 
 
Metodo referente a informação ao protheus da entrega do hardware pelo posto de validação 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD updateConfirmarEntregas WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cXNPSite	:= "" 
	Local cStatus	:= "" 
	Local nI		:= 0 
	Local cQrySC5	:= "" 
	Local cObs		:= "" 
	Local lFat		:= .F. 
	Local lProd		:= .F. 
	Local lServ		:= .F. 
	Local cCategHW  := GetNewPar("MV_GARHRD", "1") 
	Local cCatProd	:= "" 
	Local aRet		:= {,,,xml} //12.10.2020 - Incluído para gravar XML na GTRET 
	Private oXml 
 
	U_GTPutRet('updateConfirmarEntregas','A',aRet) //12.10.2020 - Incluído aRet para gravar XML na GTRET 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	If ValType(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A" 
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" ) 
	EndIf 
 
	For nI := 1 To Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) 
 
		cXNPSite	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_NUMERO:TEXT					//Numero do Pedido do Site 
		cStatus		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_STATUSCONFENTREGA:TEXT			//Status do Pedido 
 
		//Pego o recno do pedido feito pelo site, para pegar as informacoes do pedido protheus 
		cQrySC5 := "SELECT R_E_C_N_O_ RECPED " 
		cQrySC5 += "FROM " + RetSqlName("SC5") + " " 
		cQrySC5	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' " 
		cQrySC5 += "  AND C5_XNPSITE = '" + cXNPSite + "' " 
		cQrySC5 += "  AND D_E_L_E_T_ = ' ' " 
 
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.) 
		DbSelectArea("QRYSC5") 
 
		If QRYSC5->(!Eof()) 
			DbSelectArea("SC5") 
			DbGoTo(QRYSC5->RECPED) 
 
			If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nI)+"]:_POSTOENTREGAGAR:TEXT") <> "U" 
 
				cObs := "Cod. Posto de Entrega: "+Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_POSTOENTREGAGAR:TEXT)+CRLF+; 
				"Nome Posto de Entrega: "+Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_POSTOENTREGA:TEXT)+CRLF+; 
				"CPF Agente: "+Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_AGENTEENTREGA:TEXT)+CRLF+; 
				"Data Entrega: "+Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_DATAENTREGA:TEXT)+CRLF+; 
				"Hora Entrega: "+Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_HORAENTREGA:TEXT) 
			Else 
				cObs := "" 
			EndIf 
 
			//12.10.2020 - Incluído para gravar posto, se tiver falhado na primeira tentativa de gravacao 
			If Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_POSTOENTREGAGAR:TEXT) != AllTrim(SC5->C5_XPOSTO) 
				RecLock("SC5", .F.) 
					SC5->C5_XPOSTO += Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nI]:_POSTOENTREGAGAR:TEXT) 
				SC5->(MsUnlock())				 
			EndIf 
 
			If !Empty(cObs) 
				RecLock("SC5", .F.) 
					SC5->C5_XOBS += cObs		 //12.10.2020 - Alterado para incrementar Observação			 
				SC5->(MsUnlock()) 
			EndIf 
 
			cPedLog := iif(!Empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE) 
 
			dbSelectArea("SB1") 
			SB1->(dbSetOrder(1)) 
 
			SC6->(DbSetOrder(1)) 
			SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)) 
 
			//12.10.2020 - Laço para considerar todos itens da SC6 
			While SC6->(!EoF()) .And. SC6->C6_FILIAL + SC6->C6_NUM == SC5->C5_FILIAL + SC5->C5_NUM 
 
				cCatProd := ""	 
				If SB1->(dbSeek(xFilial("SB1") + SC6->C6_PRODUTO)) 
					cCatProd := SB1->B1_CATEGO 
				EndIf 
 
				If Empty(SC6->C6_NOTA) .And. Empty(SC6->C6_SERIE) .And. AllTrim(cCatProd) == AllTrim(cCategHW) 
 
					If AllTrim(SC6->C6_XOPER) $ "61/62" 
 
						cOperVen	:= nil 
						cOperEntH	:= nil 
						cOperVenS	:= nil 
 
						lFat 	:= .T. 
						lProd	:= .T. 
						lServ	:= .F. 
						lEnt	:= .F. 
					Else 
						cOperVen	:='52' 
						cOperEntH	:='53' 
						cOperVenS	:='51' 
 
						lFat 	:= .F. 
						lProd	:= .F. 
						lServ	:= .F. 
						lEnt	:= .T. 
					EndIf 
 
					nTime := Seconds() 
 
					aParamFun := {SC5->C5_NUM,; 	//1- Número do pedido 
					Val(cXNPSite),; 	//2- Numero de controlo de JOB para log Gtin 
					lFat,;				//3- Fatura venda 
					nil,;				//4- Nosso Número para atualização do título a receber 
					nil,;				//5- Fatura Serviço 
					nil,;				//6- Fatura produto 
					nil,;				//7- Quantidade a faturar 
					cOperVen,;			//8- operação de venda Hardware 
					cOperEntH,;			//9- operação de entrega Hardware 
					cOperVenS,;			//10- operação de venda de Serviço 
					cPedLog,;			//11- Pedido de Log 
					nil,;				//12- data do crédito Cnab 
					.F.,;				//13- Gera recibo de liberação 
					.F.,;				//14- Gera título para recibo  de liberação 
					nil,;				//15- Tipo do título de recibo de liberação 
					lEnt}				//16- Fatura entrega de hardware 
 
					While .t. 
						 
						U_GTPutIN(cPedLog,"E",cPedLog,.T.,{"updateConfirmarEntregas",cPedLog,SC5->C5_NUM,"Send2Proc Vnda190"},cXNPSite) 
 
						If U_Send2Proc("","U_VNDA190",aParamFun) 
 
							::cxmlret := XML_VERSION + CRLF 
							::cxmlret += '<confirmaType>' + CRLF 
							::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
							::cxmlret += '		<msg>Pedidos entregues com sucesso.</msg>' + CRLF 
							::cxmlret += '		<exception></exception>' + CRLF 
							::cxmlret += '</confirmaType>' + CRLF 
							Exit 
						Else 
 
							nWait := Seconds()-nTime 
							If nWait < 0 
								nWait += 86400 
							Endif 
 
							If nWait > 10 
								// Passou de 2 minutos tentando ? Desiste ! 
								U_GTPutOUT(cPedLog,"E",cPedLog,{"updateConfirmarEntregas",{.F.,"E00002",cPedLog,"Inconsistência realizar distribuição para vnda190"}},cXNPSite) 
								::cxmlret := XML_VERSION + CRLF 
								::cxmlret += '<confirmaType>' + CRLF 
								::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
								::cxmlret += '		<msg>Pedidos não entregues.</msg>' + CRLF 
								::cxmlret += '		<exception>não houve comunicação.</exception>' + CRLF 
								::cxmlret += '</confirmaType>' + CRLF 
								EXIT 
							Endif 
 
							// Espera um pouco ( 5 segundos ) para tentar novamente 
 
							Sleep(5000) 
 
						EndIf 
					End 
				EndIf 
				SC6->(dbSkip()) 
			EndDo 
 
		EndIf 
		DbSelectArea("QRYSC5") 
		QRYSC5->(DbCloseArea()) 
	Next nI 
 
Return(lReturn)

/*/{Protheus.doc} executaPedidos 
 
Metodo referente ao processamento de inclusão de pedidos de acordo fila criada 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD executaPedidos WSRECEIVE NULLPARAM WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	local lReturn := .F. 
	lReturn := u_ExecPedi() 
Return(lReturn) 

/*/{Protheus.doc} faturaCnab 
 
Metodo referente ao faturamento de pedidos de vendas através de processamento de arquivo cnab 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD faturaCnab WSRECEIVE idPedido,idPedSite,idNossoNum,DtCred,nValTitRec,idGrupo WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
 
	Local lReturn	:= .T. 
	Local lLog		:= .T. 
	Local cOperDeliv	:= GetNewPar("MV_XOPDELI", "01") 
	Local cOperVenS		:= GetNewPar("MV_XOPEVDS", "61") 
	Local cOperVenH		:= GetNewPar("MV_XOPEVDH", "62") 
	Local cOperEntH		:= GetNewPar("MV_XOPENTH", "53") 
	Local cOperVen		:= "" 
	Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62") 
	Local cBanco		:= ::idGrupo //--Grupo do banco 237/341/104 
 
	U_GTPutRet('faturaCnab','A') 
 
	nTime := Seconds() 
	While .t. 
		DbSelectArea("SC5") 
		SC5->(DbSetOrder(1)) 
		If SC5->(DbSeek(xFilial("SC5") + ::idPedido)) 
 
			If!Empty(SC5->C5_CHVBPAG) 
				cPedlog := SC5->C5_CHVBPAG 
			Else 
				cPedlog := ::idPedSite 
			EndIf 
 
			SC6->(DbSetOrder(1)) 
			SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)) 
		Else 
			aRet := {} 
			Aadd( aRet, .F.) 
			Aadd( aRet, "E00002" ) 
			Aadd( aRet, cPedLog ) 
			Aadd( aRet, "Pedido não encontrado" ) 
 
			U_GTPutOUT(::idPedSite,"N",::idPedSite,{"GERACAO CNAB",aRet},::idPedSite) 
			EXIT 
		EndIf 
 
		lFat		:= .F. 
		lServ		:= .F. 
		lProd		:= .F. 
		lRecPgto	:= .F. 
		lGerTitRecb	:= .F. 
		lEnt		:= .F. 
 
		If SC5->C5_TPCARGA <> "1" 
			cOperVen	:= cOperVenH 
			If ! SC6->C6_XOPER $ cOperNPF //Verifica se é nova operação 
 
				cOperVen :='52' 
				cOperEntH:='53' 
				cOperVenS:='51' 
 
				lFat		:= .T. 
				lServ		:= .T. 
				lProd		:= .T. 
				lEnt		:= .F. 
				lRecPgto	:= .T. 
				lGerTitRecb	:= .T. 
 
			Else 
 
				lFat		:= .F. 
				lServ		:= .F. 
				lProd		:= .F. 
				lEnt		:= .F. 
				lRecPgto	:= .T. 
				lGerTitRecb	:= .T. 
 
			Endif 
 
		Else 
			cOperVen	:= cOperDeliv 
			//		U_GTPutIN(cPedlog,"N",cPedlog,.T.,{"faturaCnab",cPedlog,::idPedido,"Procesamento de Delivery WS"},::idPedSite) 
			lFat		:= .T. //Entra no processo de faturamento para tratar Delivery 
			lServ		:= .F. 
			lProd		:= .T. //Entra no processo de fatura produto. Dentro do Vnda190 existe tratameto específico para Delivery 
			lEnt		:= .F. 
			lRecPgto	:= .T. 
			lGerTitRecb	:= .T. 
		EndIf 
 
		aParamFun := {::idPedido,;		    //1- Número do pedido 
		Val(::idPedSite),;  	//2- Numero de controlo de JOB para log Gtin 
		lFat,;					//3- Fatura venda 
		::idNossoNum,;		//4- Nosso Número para atualização do título a receber 
		lServ,;				//5- Fatura Serviço 
		lProd,;				//6- Fatura produto 
		nil,;					//7- Quantidade a faturar 
		cOperVen,;				//8- operação de venda Hardware 
		cOperEntH,;			//9- operação de entrega Hardware 
		cOperVenS,;         //10- operação de venda de Serviço 
		cPedLog,;				//11- Pedido de Log 
		StoD(::DtCred),;		//12- data do crédito Cnab 
		lRecPgto,;				//13- Gera recibo de liberação 
		lGerTitRecb,;			//14- Gera título para recibo  de liberação 
		"NCC",;				//15- Tipo do título de recibo de liberação 
		lEnt,;					//16- Fatura entrega de hardware 
		nValTitRec,;			//17- Valor título de recibo 
		cBanco}					//18- código do banco para movimentação 
 
		If U_Send2Proc("","U_VNDA190",aParamFun) 
			SZQ->(DbSelectArea("SZQ")) 
			SZQ->(DbSetOrder(2)) 
			lLog := SZQ->(DbSeek(xFilial("SZQ")+Alltrim(::idPedSite))) 
			If !lLog .AND. !Empty(cPedLog) .and. ::idPedSite <> cPedLog 
				lLog := SZQ->(DbSeek(xFilial("SZQ")+cPedLog)) 
			EndIf 
			//Registra que linha do Cnab esta em Processamento 
			If lLog 
				SZQ->(Reclock("SZQ")) 
				SZQ->ZQ_STATUS := "7" 
				SZQ->ZQ_DATA := ddatabase 
				SZQ->ZQ_HORA:=time() 
				SZQ->(MsUnlock()) 
			EndIf 
 
			U_GTPutIN(cPedlog,"N",cPedlog,.T.,{"faturaCnab",cPedlog,::idPedido,"Send2Proc VNDA190"},::idPedSite) 
			Exit 
		Else 
 
			nWait := Seconds()-nTime 
			If nWait < 0 
				nWait += 86400 
			Endif 
 
			If nWait > 120 
				// Passou de 2 minutos tentando ? Desiste ! 
				aRet := {} 
				Aadd( aRet, .F.) 
				Aadd( aRet, "E00002" ) 
				Aadd( aRet, cPedLog ) 
				Aadd( aRet, "Falha ao tentar Distribuir o faturamento." ) 
 
				U_GTPutOUT(cPedLog,"N",cPedLog,{"GERACAO CNAB",aRet},::idPedSite) 
				EXIT 
			Endif 
 
			// Espera um pouco ( 5 segundos ) para tentar novamente 
			Sleep(5000) 
 
		EndIf 
 
	EndDo 
 
Return(lReturn) 
 
/*/{Protheus.doc} reciboCnab 
 
Metodo referente ao geração de recibo de pagamento 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD reciboCnab WSRECEIVE idPedido,idPedSite,idNossoNum,DtCred,iGeraRecibo,nValTitRec,idGrupo WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local lLog		:= .T. 
	Local cOperDeliv	:= GetNewPar("MV_XOPDELI", "01") 
	Local cOperVenS		:= GetNewPar("MV_XOPEVDS", "61") 
	Local cOperVenH		:= GetNewPar("MV_XOPEVDH", "62") 
	Local cOperEntH		:= GetNewPar("MV_XOPENTH", "53") 
	Local cOperVen		:= "" 
	Local cOperNPF		:= GetNewPar("MV_XOPENPF", "61,62") 
	Local cBanco		:= ::idGrupo //--Grupo do banco 237/341/104 
 
	U_GTPutRet('reciboCnab','A') 
 
	nTime := Seconds() 
	While .t. 
		DbSelectArea("SC5") 
		SC5->(DbSetOrder(1)) 
		If SC5->(DbSeek(xFilial("SC5") + ::idPedido)) .and. !Empty(SC5->C5_CHVBPAG) 
			cPedlog := SC5->C5_CHVBPAG 
		Else 
			cPedlog := ::idPedSite 
		EndIf 
 
		SC6->(DbSetOrder(1)) 
		SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM)) 
 
		lFat		:= .F. 
		lServ		:= .F. 
		lProd		:= .F. 
		lRecPgto	:= .F. 
		lGerTitRecb	:= .F. 
		lEnt		:= .F. 
 
		If SC5->C5_TPCARGA <> "1" 
			cOperVen	:= cOperVenH 
			If ! SC6->C6_XOPER $ cOperNPF //Verifica se é nova operação 
 
				cOperVen :='52' 
				cOperEntH:='53' 
				cOperVenS:='51' 
 
				lFat		:= .T. 
				lServ		:= .T. 
				lProd		:= .T. 
				lEnt		:= .F. 
				lRecPgto	:= .T. 
				lGerTitRecb	:= .T. 
 
			Else 
 
				lFat		:= .F. 
				lServ		:= .F. 
				lProd		:= .F. 
				lEnt		:= .F. 
				lRecPgto	:= .T. 
				lGerTitRecb	:= .T. 
 
			Endif 
 
		Else 
			cOperVen	:= cOperDeliv 
			//	U_GTPutIN(cPedlog,"N",cPedlog,.T.,{"U_VNDA190",cPedlog,::idPedido,"Procesamento de Delivery WS"},::idPedSite) 
			lFat		:= .T. //Entra no processo de faturamento para tratar Delivery 
			lServ		:= .F. 
			lProd		:= .T. //Entra no processo de fatura produto. Dentro do Vnda190 existe tratameto específico para Delivery 
			lEnt		:= .F. 
			lRecPgto	:= .T. 
			lGerTitRecb	:= .T. 
		EndIf 
 
		aParamFun := {::idPedido,;			//1- Número do pedido 
		Val(::idPedSite),;	//2- Numero de controlo de JOB para log Gtin 
		lFat,;					//3- Fatura venda 
		::idNossoNum,;		//4- Nosso Número para atualização do título a receber 
		lServ,;  				//5- Fatura Serviço 
		lProd,;				//6- Fatura produto 
		nil,;  				//7- Quantidade a faturar 
		cOperVen,;				//8- operação de venda Hardware 
		cOperEntH,;			//9- operação de entrega Hardware 
		cOperVenS,;         //10- operação de venda de Serviço 
		cPedLog,;				//11- Pedido de Log 
		StoD(::DtCred),;		//12- data do crédito Cnab 
		lRecPgto,;				//13- Gera recibo de liberação 
		lGerTitRecb,;			//14- Gera título para recibo  de liberação 
		"NCC",;				//15- Tipo do título de recibo de liberação 
		lEnt,;					//16- Fatura entrega de hardware 
		nValTitRec,;			//17- Valor título de recibo 
		cBanco}				//18- código do banco para movimentação 
 
		If U_Send2Proc("","U_VNDA190",aParamFun) 
			SZQ->(DbSelectArea("SZQ")) 
			SZQ->(DbSetOrder(2)) 
			lLog := SZQ->(DbSeek(xFilial("SZQ")+Alltrim(::idPedSite))) 
			If !lLog .AND. !Empty(cPedLog) .and. ::idPedSite <> cPedLog 
				lLog := SZQ->(DbSeek(xFilial("SZQ")+cPedLog)) 
			EndIf 
			//Registra que linha do Cnab esta em Processamento 
			If lLog 
				SZQ->(Reclock("SZQ")) 
				SZQ->ZQ_STATUS := "7" 
				SZQ->ZQ_DATA := ddatabase 
				SZQ->ZQ_HORA:=time() 
				SZQ->(MsUnlock()) 
			EndIf 
			//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
			U_GTPutIN(cPedlog,"N",cPedlog,.T.,{"reciboCnab",cPedlog,::idPedido,"Send2Proc VNDA190"},::idPedSite) 
			Exit 
		Else 
			nWait := Seconds()-nTime 
			If nWait < 0 
				nWait += 86400 
			Endif 
			If nWait > 120 
				// Passou de 2 minutos tentando ? Desiste ! 
				aRet := {} 
				Aadd( aRet, .F.) 
				Aadd( aRet, "E00002" ) 
				Aadd( aRet, cPedLog ) 
				Aadd( aRet, "Falha ao tentar Distribuir o faturamento." ) 
				U_GTPutOUT(cPedLog,"N",cPedLog,{"geração CNAB",aRet},::idPedSite) 
				EXIT 
			Endif 
			// Espera um pouco ( 5 segundos ) para tentar novamente 
			Sleep(5000) 
		EndIf 
	EndDo 
Return(lReturn) 
 
/*/{Protheus.doc} faturaCC 
 
Metodo referente ao faturamento de pedidos de vendas com forma de pagamento cartão de crédito 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD faturaCC WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
 
	Local cResponse  := "" 
	Local lReturn	 := .T. 
	Private cError	 := "" 
	Private cWarning := "" 
 
	U_GTPutRet('faturaCC','A') 
 
	U_Vnda262('',::Xml,@cResponse, @cError, @cWarning) 
 
	::cxmlret:=cResponse 
 
Return(lReturn)

/*/{Protheus.doc} getvldgar 
 
Metodo referente a informação ao protheus da validação do pedido no sistema GAR 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getvldgar  WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local aInfoSZ5	:= {} 
	Local nI		:= 0 
	Local cDadXml	:= "" 
	Local cNumPed	:= "" 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cXml		:= "" 
	Local cEvento	:= "VALIDA" 
	local oHUB 		:= nil
	Private oXml 
 
	U_GTPutRet('getvldgar','A') 
 
	aadd(aInfoSZ5,{"Z5_PEDGAR" ,""}) 
	aadd(aInfoSZ5,{"Z5_DATPED" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_EMISSAO",StoD("")}) 
	aadd(aInfoSZ5,{"Z5_RENOVA" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_REVOGA" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_DATVAL" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HORVAL" ,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJ"   ,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJCER",""}) 
	aadd(aInfoSZ5,{"Z5_NOMREC" ,""}) 
	aadd(aInfoSZ5,{"Z5_DATPAG" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_VALOR"  ,0}) 
	aadd(aInfoSZ5,{"Z5_TIPMOV" ,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAR"  ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAR" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODPOS" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESPOS" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_NOMAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_CPFAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_CERTIF" ,""}) 
	aadd(aInfoSZ5,{"Z5_PRODUTO",""}) 
	aadd(aInfoSZ5,{"Z5_DESPRO" ,""}) 
	aadd(aInfoSZ5,{"Z5_GRUPO"  ,""}) 
	aadd(aInfoSZ5,{"Z5_DESGRU" ,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS" ,""}) 
	aadd(aInfoSZ5,{"Z5_GARANT" ,""}) 
	aadd(aInfoSZ5,{"Z5_TIPVOU" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODVOU" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAC" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAC" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODARP" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCARP",""}) 
	aadd(aInfoSZ5,{"Z5_REDE"   ,""}) 
	aadd(aInfoSZ5,{"Z5_CPFT"   ,""}) 
	aadd(aInfoSZ5,{"Z5_NTITULA",""}) 
	aadd(aInfoSZ5,{"Z5_CNPJV"  ,0}) 
	aadd(aInfoSZ5,{"Z5_TABELA" ,""}) 
	aadd(aInfoSZ5,{"Z5_VALORSW",0}) 
	aadd(aInfoSZ5,{"Z5_VALORHW",0}) 
 
	cXml := XML_VERSION 
	cXml += ::xml 
	cXml := REPLACE(cXml,'&', 'E') 
	oXml := XmlParser( cXml, "_", @cError, @cWarning ) 
 
	If Empty(cError) 
		cNumPed := AllTrim(oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_Z5PEDGAR:TEXT) 
 
		If Empty(cNumPed) 
 
			msgCon(VARINFO('',oXml)) 
			msgCon(cXml) 
			msgCon(cError) 
			msgCon(cWarning) 
 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
			::cxmlret += '		<exception>código de Pedido Gar não enviado</exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
			Return(.F.) 
		EndIf 
 
		For nI:=1 to Len(aInfoSZ5) 
			cDadXml := StrTran(aInfoSZ5[nI,1],"_","") 
 
			If Type("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") <> "U" 
				If Valtype(aInfoSZ5[nI,2]) == "C" 
					aInfoSZ5[nI,2] := &("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "N" 
					aInfoSZ5[nI,2] := Val(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT")) 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "D" 
					cCtd	:= StrTran(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT"),"-","") 
					aInfoSZ5[nI,2] :=  StoD(cCtd) 
				EndIf 
			EndIf 
		Next 
		nTime := Seconds() 
		While .t. 
 
			If U_Send2Proc(cNumPed,"U_GARA130J",cNumPed,aInfoSZ5,.T.,cEvento) 
				//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
 
				U_GTPutIN(cNumPed,"E",cNumPed,.T.,{"GETVLDGAR",cNumPed,::xml},"") 
 
				::cxmlret := XML_VERSION + CRLF 
				::cxmlret += '<confirmaType>' + CRLF 
				::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
				::cxmlret += '		<msg>Pedido Distribuido para Processamento</msg>' + CRLF 
				::cxmlret += '		<exception></exception>' + CRLF 
				::cxmlret += '</confirmaType>' + CRLF 
				Exit 
			Else 
				nWait := Seconds()-nTime 
				If nWait < 0 
					nWait += 86400 
				Endif 
 
				If nWait > 10 
					// Passou de 2 minutos tentando ? Desiste ! 
					U_GTPutOUT(cNumPed,"E",cNumPed,{"GETVLDGAR",{.F.,"E00002",cNumPed,"Inconsistência realizar distribuição"}},"") 
					::cxmlret := XML_VERSION + CRLF 
					::cxmlret += '<confirmaType>' + CRLF 
					::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
					::cxmlret += '		<msg>Pedidos não foram faturados.</msg>' + CRLF 
					::cxmlret += '		<exception>não houve comunicação.</exception>' + CRLF 
					::cxmlret += '</confirmaType>' + CRLF 
					EXIT 
				Endif 
 
				// Espera um pouco ( 5 segundos ) para tentar novamente 
				Sleep(5000) 
			EndIf 
		EndDo 
	Else 
 
		msgCon("oXML "+VARINFO('',oXml)) 
		msgCon("cXML "+cXml) 
		msgCon("cError "+cError) 
		msgCon("cWarning "+cWarning) 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
		::cxmlret += '		<exception>'+cError+'</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 

	//Grava PC3
	oHUB := MensagemHUB():New( ::xml )  
	oHUB:GravarXMLHUB( cEVENTO_VALIDACAO )   
Return(lReturn)

/*/{Protheus.doc} getvergar 
 
Metodo referente a informação ao protheus da verificação do pedido no sistema GAR 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getvergar  WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
 
	Local lReturn	:= .T. 
	Local aInfoSZ5	:= {} 
	Local nI		:= 0 
	Local cDadXml	:= "" 
	Local cNumPed	:= "" 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cXml		:= "" 
	Local cEvento	:= "VERIFI" 
	local oHUB 		:= nil
	Private oXml 
 
	U_GTPutRet('getvergar','A') 
 
	// Validacao 
	aadd(aInfoSZ5,{"Z5_PEDGAR" ,""}) 
	aadd(aInfoSZ5,{"Z5_DATPED" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_EMISSAO",StoD("")}) 
	aadd(aInfoSZ5,{"Z5_RENOVA" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_REVOGA" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_DATVAL" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HORVAL" ,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJ"   ,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJCER",""}) 
	aadd(aInfoSZ5,{"Z5_NOMREC" ,""}) 
	aadd(aInfoSZ5,{"Z5_DATPAG" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_VALOR"  ,0}) 
	aadd(aInfoSZ5,{"Z5_TIPMOV" ,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAR"  ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAR" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODPOS" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESPOS" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_NOMAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_CPFAGE" ,""}) 
	aadd(aInfoSZ5,{"Z5_CERTIF" ,""}) 
	aadd(aInfoSZ5,{"Z5_PRODUTO",""}) 
	aadd(aInfoSZ5,{"Z5_DESPRO" ,""}) 
	aadd(aInfoSZ5,{"Z5_GRUPO"  ,""}) 
	aadd(aInfoSZ5,{"Z5_DESGRU" ,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS" ,""}) 
	aadd(aInfoSZ5,{"Z5_GARANT" ,""}) 
	aadd(aInfoSZ5,{"Z5_TIPVOU" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODVOU" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODAC" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAC" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODARP" ,""}) 
	aadd(aInfoSZ5,{"Z5_DESCARP",""}) 
	aadd(aInfoSZ5,{"Z5_REDE" ,""}) 
	aadd(aInfoSZ5,{"Z5_CPFT" ,""}) 
	aadd(aInfoSZ5,{"Z5_NTITULA",""}) 
	aadd(aInfoSZ5,{"Z5_CNPJV" ,0}) 
	aadd(aInfoSZ5,{"Z5_TABELA",""}) 
	aadd(aInfoSZ5,{"Z5_VALORSW",0}) 
	aadd(aInfoSZ5,{"Z5_VALORHW",0}) 
 
	// Verificacao 
	aadd(aInfoSZ5,{"Z5_DATVER" ,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HORVER" ,""}) 
	aadd(aInfoSZ5,{"Z5_POSVER" ,""}) 
	aadd(aInfoSZ5,{"Z5_AGVER" ,""}) 
	aadd(aInfoSZ5,{"Z5_NOAGVER" ,""}) 
	aadd(aInfoSZ5,{"Z5_CODPAR",""}) 
	aadd(aInfoSZ5,{"Z5_NOMPAR",""}) 
	aadd(aInfoSZ5,{"Z5_CODVEND",""}) 
	aadd(aInfoSZ5,{"Z5_NOMVEND",""}) 
	aadd(aInfoSZ5,{"Z5_VENATV",""}) 
 
	cXml := XML_VERSION 
	cXml += ::xml 
	cXml := REPLACE(cXml,'&', 'E') 
	oXml := XmlParser( cXml, "_", @cError, @cWarning ) 
 
	If Empty(cError) 
 
		cNumPed := AllTrim(oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_Z5PEDGAR:TEXT) 
 
		If Empty(cNumPed) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
			::cxmlret += '		<exception>código de Pedido Gar não enviado</exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
			Return(.F.) 
		EndIf 
 
		For nI:=1 to Len(aInfoSZ5) 
			cDadXml := StrTran(aInfoSZ5[nI,1],"_","") 
 
			If Type("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") <> "U" 
				If Valtype(aInfoSZ5[nI,2]) == "C" 
					aInfoSZ5[nI,2] := &("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "N" 
					aInfoSZ5[nI,2] := Val(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT")) 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "D" 
					cCtd	:= StrTran(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT"),"-","") 
					aInfoSZ5[nI,2] :=  StoD(cCtd) 
				EndIf 
			EndIf 
		Next 
		nTime := Seconds() 
		While .t. 
 
			If U_Send2Proc(cNumPed,"U_GARA130J",cNumPed,aInfoSZ5,.T.,cEvento) 
				//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
 
				U_GTPutIN(cNumPed,"E",cNumPed,.T.,{"GETVERGAR",cNumPed,::xml},"") 
 
				::cxmlret := XML_VERSION + CRLF 
				::cxmlret += '<confirmaType>' + CRLF 
				::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
				::cxmlret += '		<msg>Pedido Distribuido para Processamento</msg>' + CRLF 
				::cxmlret += '		<exception></exception>' + CRLF 
				::cxmlret += '</confirmaType>' + CRLF 
				Exit 
			Else 
				nWait := Seconds()-nTime 
				If nWait < 0 
					nWait += 86400 
				Endif 
 
				If nWait > 10 
					// Passou de 2 minutos tentando ? Desiste ! 
					U_GTPutOUT(cNumPed,"E",cNumPed,{"GETVERGAR",{.F.,"E00002",cNumPed,"Inconsistência realizar distribuição"}},"") 
					::cxmlret := XML_VERSION + CRLF 
					::cxmlret += '<confirmaType>' + CRLF 
					::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
					::cxmlret += '		<msg>Pedidos não foram faturados.</msg>' + CRLF 
					::cxmlret += '		<exception>Falha de comunicação.</exception>' + CRLF 
					::cxmlret += '</confirmaType>' + CRLF 
					EXIT 
				Endif 
 
				// Espera um pouco ( 5 segundos ) para tentar novamente 
				Sleep(5000) 
			EndIf 
		EndDo 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
		::cxmlret += '		<exception>'+cError+'</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 
 
	//Grava PC3
	oHUB := MensagemHUB():New( ::xml )  
	oHUB:GravarXMLHUB( cEVENTO_VERIFICACAO )  
Return(lReturn)

/*/{Protheus.doc} getemigar 
 
Metodo referente a informação ao protheus da emissão do certificado do pedido no sistema GAR 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD getemigar  WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local aInfoSZ5	:= {} 
	Local nI		:= 0 
	Local cDadXml	:= "" 
	Local cNumPed	:= "" 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cXml		:= "" 
	Local cMetodo	:= "EMISSA" 
	local oHUB 		:= nil
	Private oXml 
 
	U_GTPutRet('getemigar','A') 
 
	//Validacao 
	aadd(aInfoSZ5,{"Z5_PEDGAR"	,""}) 
	aadd(aInfoSZ5,{"Z5_DATPED"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_EMISSAO"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_RENOVA"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_REVOGA"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_DATVAL"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HORVAL"	,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJ"  	,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJCER"	,""}) 
	aadd(aInfoSZ5,{"Z5_NOMREC"	,""}) 
	aadd(aInfoSZ5,{"Z5_DATPAG"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_VALOR" 	,0}) 
	aadd(aInfoSZ5,{"Z5_TIPMOV"	,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODAR" 	,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAR"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODPOS"	,""}) 
	aadd(aInfoSZ5,{"Z5_DESPOS"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODAGE"	,""}) 
	aadd(aInfoSZ5,{"Z5_NOMAGE"	,""}) 
	aadd(aInfoSZ5,{"Z5_CPFAGE"	,""}) 
	aadd(aInfoSZ5,{"Z5_CERTIF"	,""}) 
	aadd(aInfoSZ5,{"Z5_PRODUTO"	,""}) 
	aadd(aInfoSZ5,{"Z5_DESPRO"	,""}) 
	aadd(aInfoSZ5,{"Z5_GRUPO" 	,""}) 
	aadd(aInfoSZ5,{"Z5_DESGRU"	,""}) 
	aadd(aInfoSZ5,{"Z5_STATUS"	,""}) 
	aadd(aInfoSZ5,{"Z5_GARANT"	,""}) 
	aadd(aInfoSZ5,{"Z5_TIPVOU"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODVOU"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODAC"	,""}) 
	aadd(aInfoSZ5,{"Z5_DESCAC"	,""}) 
	aadd(aInfoSZ5,{"Z5_CODARP"	,""}) 
	aadd(aInfoSZ5,{"Z5_DESCARP"	,""}) 
	aadd(aInfoSZ5,{"Z5_REDE" 	,""}) 
	aadd(aInfoSZ5,{"Z5_CPFT" 	,""}) 
	aadd(aInfoSZ5,{"Z5_NTITULA"	,""}) 
	aadd(aInfoSZ5,{"Z5_CNPJV"	,0}) 
	aadd(aInfoSZ5,{"Z5_TABELA",""}) 
	aadd(aInfoSZ5,{"Z5_VALORSW",0}) 
	aadd(aInfoSZ5,{"Z5_VALORHW",0}) 
 
	// Verificacao 
	aadd(aInfoSZ5,{"Z5_DATVER"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HORVER"	,""}) 
	aadd(aInfoSZ5,{"Z5_POSVER"	,""}) 
	aadd(aInfoSZ5,{"Z5_AGVER"	,""}) 
	aadd(aInfoSZ5,{"Z5_NOAGVER"	,""}) 
 
	// Emissao 
	aadd(aInfoSZ5,{"Z5_DATEMIS"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_HOREMIS"	,""}) 
	aadd(aInfoSZ5,{"Z5_POSEMIS"	,""}) 
	aadd(aInfoSZ5,{"Z5_AGEMIS"	,""}) 
	aadd(aInfoSZ5,{"Z5_NOAGEMI"	,""}) 
	aadd(aInfoSZ5,{"Z5_ORIEMIS"	,""}) 
	aadd(aInfoSZ5,{"Z5_UFDOCTI"	,""}) 
	aadd(aInfoSZ5,{"Z5_VLDCERT"	,StoD("")}) 
	aadd(aInfoSZ5,{"Z5_TELTIT"	,""}) 
	aadd(aInfoSZ5,{"Z5_NOMCTO"	,""}) 
	aadd(aInfoSZ5,{"Z5_TELCTO"	,""}) 
	aadd(aInfoSZ5,{"Z5_MAICTO"	,""}) 
	aadd(aInfoSZ5,{"Z5_PEDGANT",""}) 
 
	cXml := XML_VERSION 
	cXml += ::xml 
	cXml := REPLACE(cXml,'&', 'E') 
	oXml := XmlParser( cXml, "_", @cError, @cWarning ) 
 
	If Empty(cError) 
		cNumPed := AllTrim(oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_Z5PEDGAR:TEXT) 
 
		If Empty(cNumPed) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
			::cxmlret += '		<exception>código de Pedido Gar não enviado</exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
			Return(.F.) 
		EndIf 
 
		For nI:=1 to Len(aInfoSZ5) 
			cDadXml := StrTran(aInfoSZ5[nI,1],"_","") 
 
			If cDadXml == "Z5VLDCERT" .And. Type("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_Z5DATEXP:TEXT") <> "U" 
				cCtd	:= StrTran(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_Z5DATEXP:TEXT"),"-","") 
				aInfoSZ5[nI,2] :=  StoD(cCtd) 
			ElseIf Type("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") <> "U" 
 
				If Valtype(aInfoSZ5[nI,2]) == "C" 
					aInfoSZ5[nI,2] := &("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT") 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "N" 
					aInfoSZ5[nI,2] := Val(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT")) 
				ElseIf Valtype(aInfoSZ5[nI,2]) == "D" 
					cCtd	:= StrTran(&("oXml:_PURCHASEORDER:_ADDITIONALINFORMATION:_CSMOVNOTAST:_"+cDadXml+":TEXT"),"-","") 
					aInfoSZ5[nI,2] :=  StoD(cCtd) 
				EndIf 
			EndIf 
		Next 
		nTime := Seconds() 
		While .t. 
 
			If U_Send2Proc(cNumPed,"U_GARA130J",cNumPed,aInfoSZ5,.T.,cMetodo) 
				//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
 
				U_GTPutIN(cNumPed,"E",cNumPed,.T.,{"GETEMIGAR",cNumPed,::xml},"") 
 
				::cxmlret := XML_VERSION + CRLF 
				::cxmlret += '<confirmaType>' + CRLF 
				::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
				::cxmlret += '		<msg>Pedido Distribuido para Processamento</msg>' + CRLF 
				::cxmlret += '		<exception></exception>' + CRLF 
				::cxmlret += '</confirmaType>' + CRLF 
				Exit 
			Else 
				nWait := Seconds()-nTime 
				If nWait < 0 
					nWait += 86400 
				Endif 
 
				If nWait > 10 
					// Passou de 2 minutos tentando ? Desiste ! 
					U_GTPutOUT(cNumPed,"E",cNumPed,{"GETEMIGAR",{.F.,"E00002",cNumPed,"Inconsistência realizar distribuição"}},"") 
					::cxmlret := XML_VERSION + CRLF 
					::cxmlret += '<confirmaType>' + CRLF 
					::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
					::cxmlret += '		<msg>Pedidos não foram faturados.</msg>' + CRLF 
					::cxmlret += '		<exception>Falha de comunicação.</exception>' + CRLF 
					::cxmlret += '</confirmaType>' + CRLF 
					EXIT 
				Endif 
 
				// Espera um pouco ( 5 segundos ) para tentar novamente 
				Sleep(5000) 
			EndIf 
		EndDo 
	Else 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Pedido não foi processado</msg>' + CRLF 
		::cxmlret += '		<exception>'+cError+'</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	EndIf 

	//Grava PC3
	oHUB := MensagemHUB():New( ::xml )
	oHUB:GravarXMLHUB( cEVENTO_EMISSAO )  
Return(lReturn)

/*/{Protheus.doc} statusdelivery 
 
Metodo referente a informação ao protheus do status da entrega do pedido referente a delivery 
 
@author Totvs SM - David 
@since 10/03/2014 
@version P11 
 
/*/ 
WSMETHOD statusdelivery WSRECEIVE xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local oXml 
	Local nI		:= 0 
	Local cPedSite	:= "" 
	Local cCodEnt	:= "" 
	Local cTipEnt	:= "" 
	Local cDesEnt	:= "" 
	Local cPedErr	:= "" 
 
	U_GTPutRet('statusdelivery','A') 
 
	oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
	If !empty(cError) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>Inconsistencia ao processar xml</msg>' + CRLF 
		::cxmlret += '		<exception>'+Alltrim(cError)+'</exception>' + CRLF 
		::cxmlret += '</confirmaType>' + CRLF 
	Else 
		If ValType(oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO) <> "A" 
			XmlNode2Arr( oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO, "_PEDIDO" ) 
		EndIf 
 
		DbSelectArea("SC5") 
		SC5->(dbOrderNickNAme('PEDSITE')) //C5_FILIAL + C5_XNPSITE 
 
		DbSelectArea("PAG") 
		PAG->(DbSetOrder(3)) 
 
		DbSelectArea("SX5") 
		SX5->(DbSetOrder(1)) 
 
		For nI := 1 To Len(oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO) 
			cPedSite	:= oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO[nI]:_NUMERO:TEXT 
			cTipEnt		:= Left(oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO[nI]:_STATUSDELIVERY:_CODIGO:TEXT,3) 
			cCodEnt		:= Right(oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO[nI]:_STATUSDELIVERY:_CODIGO:TEXT,2) 
			cDesEnt		:= oXml:_ATUALIZASTATUSDELIVERY:_PEDIDO[nI]:_STATUSDELIVERY:_DESCRICAO:TEXT 
 
			If !SX5->(DbSeek(xFilial("SX5")+"PG"+cTipEnt+cCodEnt)) 
				RecLock("SX5", .T.) 
				Replace SX5->X5_FILIAL 	With xFilial("SX5") 
				Replace SX5->X5_TABELA 	With "PG" 
				Replace SX5->X5_CHAVE 	With cTipEnt+cCodEnt 
				Replace SX5->X5_DESCRI 	With cDesEnt 
				Replace SX5->X5_DESCSPA	With cDesEnt 
				Replace SX5->X5_DESCENG	With cDesEnt 
				SX5->(MsUnLock()) 
			EndIf 
 
			If SC5->(DbSeek(xFilial("SC5")+cPedSite)) .and. PAG->(DbSeek(xFilial("PAG")+SC5->C5_NUM)) 
				If PAG->PAG_ENTREG <> cTipEnt+cCodEnt 
					RecLock("PAG", .F.) 
					Replace PAG->PAG_STATUS	With "3" 
					Replace PAG->PAG_ENTREG	With cTipEnt+cCodEnt 
					PAG->(MsUnLock()) 
				EndIf 
			Else 
				cPedErr += cPedSite+" / " 
			EndIf 
		Next nI 
 
		If !Empty(cPedErr) 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Problema ao atualizar códigos de rastreamento</msg>' + CRLF 
			::cxmlret += '		<exception>Pedidos não foram encontrados no Protheus: '+cPedErr+'</exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
		Else 
			::cxmlret := XML_VERSION + CRLF 
			::cxmlret += '<confirmaType>' + CRLF 
			::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
			::cxmlret += '		<msg>Lista processada com Sucesso</msg>' + CRLF 
			::cxmlret += '		<exception></exception>' + CRLF 
			::cxmlret += '</confirmaType>' + CRLF 
		Endif 
	EndIf 
 
Return(lReturn) 
 
/*/{Protheus.doc} sendMessage 
 
Metodo referente a recebimento de mensagens genricas pelo protheus via WS 
 
@author Totvs SM - David 
@since 19/05/2014 
@version P11 
 
/*/ 
WSMETHOD sendMessage WSRECEIVE cCategory,xml WSSEND cxmlret WSSERVICE HardwareAvulsoProvider 
	Local lReturn	:= .T. 
	Local cStatus	:= "1" 
	Local cMsgRet	:= "" 
	Local cUpd		:= "" 
	Local cError	:= "" 
	Local cWarning	:= "" 
	Local cPLP		:= "" 
	Local cCodRas	:= "" 
	Local lNotexit	:= .T. 
	Local nWait		:= 0 
	Local bVldPed	:= {|a,b| IIf(!Empty(a),a,b)} 
	Local cQryGtOut	:= "" 
	Local cPedOut	:= "" 
	Local lLogEr 	:= .T. 
	Local cCodADE 	:= "" 
	Local cPedOri 	:= "" 
	Local cID	  	:= "" 
	Local cOrigem 	:= "" 
	Local cPedLog 	:= "" 
	Local oObj 
	Local cOperVenS := GetNewPar("MV_XOPEVDS", "61") 
	Local cItemPed 	:= "" 
	Local cItemAnt 	:= "" 
	Local lAtuSC5  	:= .F. 
	Local nI 		:= 0 
	Local cSQL		:= '' 
	Local cTRB		:= '' 
	Local cNpSite	:= '' 
	Local cXIDPedo	:= '' 
 
	Private oXml := nil 
 
	U_GTPutRet('sendMessage','A') 
 
	If Empty(::cCategory) .or. Empty(::xml) 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg></msg>' + CRLF 
		::cxmlret += '		<exception>Sem parametros para processamento</exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
	ElseIf cCategory == "NOTIFICA-RETORNO-POSTAGEM" 
 
		If PAG->(FieldPos("PAG_CODPLP")) > 0 
			oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
			If !Empty(cError) .or. !Empty(cWarning) 
				cMsgRet:= "Erro ao Abrir xml enviado: Erro:"+Alltrim(cError)+" Warning:"+cWarning 
				cStatus:= "0" 
			Else 
				If ValType(oXml:_SIGEPRESPONSE:_ETIQUETAS:_ETIQUETA) <> "A" 
					XmlNode2Arr( oXml:_SIGEPRESPONSE:_ETIQUETAS:_ETIQUETA, "_ETIQUETA" ) 
				EndIf 
			EndIf 
 
			cPLP := oXml:_SIGEPRESPONSE:_PLP:TEXT 
 
			For nI:=1 to len(oXml:_SIGEPRESPONSE:_ETIQUETAS:_ETIQUETA) 
				cCodRas	:= oXml:_SIGEPRESPONSE:_ETIQUETAS:_ETIQUETA[nI]:TEXT 
				If !Empty(cCodRas) 
					cUpd 	:= "UPDATE "+RetSqlName("PAG")+" SET PAG_CODPLP = '"+cPLP+"' WHERE PAG_CODRAS = '"+cCodRas+"'" 
 
					If TcSqlExec(cUpd) == 0 
						cMsgRet := "atualização de PLP realizada com sucesso" 
						cStatus	:= "1" 
					Else 
						cMsgRet := TcSqlError() 
						cStatus	:= "0" 
						exit 
					EndiF 
				Else 
					cMsgRet := "Recebida com Sucesso mas PLP não atualizada" 
					cStatus := "0" 
				EndIf 
			Next nI 
		Else 
			cMsgRet := "Recebida com Sucesso mas PLP não atualizada" 
			cStatus := "0" 
		End 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
	ElseIf cCategory == "SOLICITA-VOUCHER" 
 
		lNotexit:= .T. 
		nTime := Seconds() 
 
		While lNotexit 
 
			If U_Send2Proc(::xml,"U_VNDA620","") 
 
				cMsgRet := "Mensagem recebida com sucesso" 
				cStatus	:= "1" 
				lNotexit:= .F. 
 
			Else 
				nWait := Seconds()-nTime 
				If nWait < 0 
					nWait += 86400 
				Endif 
 
				If nWait > 10 
					cMsgRet := "não foi possível Distribuir a mensagem" 
					cStatus	:= "0" 
					lNotexit:= .F. 
				EndIf 
			Endif 
 
		EndDo 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
	ElseIf cCategory == "ENVIA-PEDIDO-GAR" 
		oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
		If !Empty(cError) .or. !Empty(cWarning) 
			cMsgRet:= "Erro ao Abrir xml enviado: Erro:"+Alltrim(cError)+" Warning:"+cWarning 
			cStatus:= "0" 
		Else 
 
			If Valtype(oXml:_LISTPEDIDOGARTYPE:_PEDIDO) != "A" 
				XmlNode2Arr( oXml:_LISTPEDIDOGARTYPE:_PEDIDO , "_PEDIDO" ) 
			EndIf 
 
			cMsgRet:= "" 
			cStatus:= "1" 
			cPedOut:= "" 
 
			For nI:=1 to Len(oXml:_LISTPEDIDOGARTYPE:_PEDIDO) 
 
				IF Type("oXml:_LISTPEDIDOGARTYPE:_PEDIDO["+Str(nI)+"]:_NUMEROPEDIDOGAR:TEXT") == "U" 
					cMsgRet:= "não Foi identificado Pedido GAR" 
					cStatus:= "0" 
 
				ElseIf Type("oXml:_LISTPEDIDOGARTYPE:_PEDIDO["+Str(nI)+"]:_NUMERO:TEXT") == "U" 
 
					cMsgRet:= "não Foi identificado Pedido Site" 
					cStatus:= "0" 
 
				Else 
					cPedGar := oXml:_LISTPEDIDOGARTYPE:_PEDIDO[nI]:_NUMEROPEDIDOGAR:TEXT 
					cNpSite := oXml:_LISTPEDIDOGARTYPE:_PEDIDO[nI]:_NUMERO:TEXT 
					cPedLog := Eval(bVldPed,cPedGar,cNpSite) 
 
					If Type("oXml:_LISTPEDIDOGARTYPE:_PEDIDO["+Str(nI)+"]:_NUMEROPEDIDOITEM:TEXT") == "U"					 
						cItemPed := "" 
					Else 
						cItemPed := oXml:_LISTPEDIDOGARTYPE:_PEDIDO[nI]:_NUMEROPEDIDOITEM:TEXT 
					EndIf 
 
					cId		:= cPedLog 
					cCodADE :='' 
					IF ValType( XmlChildEx(oXml:_LISTPEDIDOGARTYPE:_PEDIDO[nI], "_PROTOCOLO") ) == 'O' 
						cCodADE := Alltrim( oXml:_LISTPEDIDOGARTYPE:_PEDIDO[nI]:_PROTOCOLO:TEXT ) 
					EndIF 
 
					cQryGtOut := " SELECT COUNT(*) QTDOUT " 
					cQryGtOut += " FROM GTOUT " 
					cQryGtOut += " WHERE GT_XNPSITE = '" + cNpSite + "' " 
					cQryGtOut += "   AND GT_TYPE = 'S' " 
					cQryGtOut += "   AND GT_CODMSG = 'E00023' " 
					cQryGtOut += "   AND D_E_L_E_T_ = ' ' " 
 
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGtOut),"QRYGT",.F.,.T.) 
					DbSelectArea("QRYGT") 
 
					If !QRYGT->(EoF()) .and. QRYGT->QTDOUT >= 4 
						lLogEr := .T. 
					Else 
						lLogEr := .F. 
					EndIF 
 
					QRYGT->(DbCloseArea()) 
 
					If !Empty(cPedGar) .and. !Empty(cNpSite) 
						U_GTPutIN(cID,"S",cPedLog,.T.,{"SENDMESSAGE",cPedLog,"ENVIA-PEDIDO-GAR", "Atualizacao de dados de pedido", ::xml},cNpSite) 
 
						SC5->(DbOrderNickName("PEDSITE")) 
						If PLSALIASEX("Z11") 
							Z11->(DbSetOrder(2)) 
						EndIf 
 
						SZG->(DbSetOrder(3)) 
 
						If SC5->(DbSeek(xFilial('SC5')+cNpSite)) 
 
							If Empty(cItemPed) 
								If Empty(SC5->C5_CHVBPAG) 
 
									SC5->(Reclock("SC5",.F.)) 
									SC5->C5_CHVBPAG := cPedGar 
									SC5->(MsUnlock()) 
 
									U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.T.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR", "Informado pedido GAR com Sucesso",::xml}},cNpSite) 
								Else 
									U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR", "Pedido GAR ja informado",::xml}},cNpSite) 
								EndIf 
							Else 
								SC6->(DbSetOrder(1)) 
								If SC6->(DbSeeK(xFilial("SC6")+SC5->C5_NUM)) 
									cItemAnt := SC6->C6_XIDPED 
									cXIDPedo := '' 
									lAtuSC5  := .T. 
 
									While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM 
										//Garante que não é legado 
										If !Empty(SC6->C6_XIDPED) .and. Alltrim(SC6->C6_XIDPED) <> Alltrim(cItemAnt)  
											lAtuSC5 := .F. 
										EndIf 
 
										//Para SKU sem composicao (ex. KT) ira atualizar todos os itens. 
										//Para SKU com composicao (ex. CER) ira atulizar um item e guarda o numero do ID do pai. 
										If Empty(SC6->C6_XIDPED) .or. Alltrim(SC6->C6_XIDPED) == Alltrim(cItemPed) 
											SC6->(RecLock("SC6",.F.)) 
											SC6->C6_PEDGAR	:= cPedGar 
											cXIDPedo		:= SC6->C6_XIDPEDO //Id do item pai 
											SC6->(MsUnlock()) 
										EndIf 
 
										SC6->(DbSkip()) 
									End 
 
									//Nesse caso é um SKU com composicao então atualiza os demais itens do SKU. 
									IF .NOT. Empty( cXIDPedo ) 
										SC6->( dbGotop() ) 
										SC6->( DbSetOrder(1) ) 
										IF SC6->(DbSeeK(xFilial("SC6")+SC5->C5_NUM)) 
											While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM 
												IF SC6->C6_XIDPEDO == cXIDPedo 
													SC6->(RecLock("SC6",.F.)) 
													SC6->C6_PEDGAR := cPedGar	 
													SC6->(MsUnlock()) 
												EndIF 
												SC6->( DbSkip() ) 
											End 
										EndIF 
									EndIF 
 
									//Legado 
									If lAtuSC5 
										SC5->(Reclock("SC5",.F.)) 
										SC5->C5_CHVBPAG := cPedGar 
										SC5->(MsUnlock()) 
									Endif 
 
									U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.T.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR", "Informado pedido GAR com Sucesso",::xml}},cNpSite) 
								EndIf 
							EndIf 
 
						ElseIf SZG->(DbSeek(xFilial("SZG")+cNpSite)) 
 
							If Empty(SZG->ZG_NUMPED) 
								SZG->(Reclock("SZG",.F.)) 
								SZG->ZG_NUMPED := cPedGar 
								SZG->(MsUnlock()) 
 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.T.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR", "Informado pedido GAR com Sucesso para o voucher "+SZG->ZG_NUMVOUC,::xml}},cNpSite) 
							Else 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR","Pedido GAR ja informado para o voucher "+SZG->ZG_NUMVOUC,::xml}},cNpSite) 
							EndIf 
 
						ElseIf PLSALIASEX("Z11") .and. Z11->(DbSeek(xFilial("Z11")+cNpSite)) 
							If Empty(Z11->Z11_PEDGAR) 
 
								Z11->(Reclock("Z11",.F.)) 
								Z11->Z11_PEDGAR := cPedGar 
								Z11->(MsUnlock()) 
 
								Z12->(DbSetOrder(2)) 
								Z12->(DbSeek(xFilial("Z12")+cNpSite)) 
 
								While !Z12->(EoF()) .and. Alltrim(Z12->(Z12_FILIAL+Z12_PEDSIT)) == Alltrim(xFilial("Z12")+cNpSite) 
									Z12->(Reclock("Z12",.F.)) 
									Z12->Z12_PEDGAR := cPedGar 
									Z12->(MsUnlock()) 
									Z12->(DbSkip()) 
								EndDo 
 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.T.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR","Informado pedido GAR com Sucesso",::xml}},cNpSite) 
							Else 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"M00001",cPedLog, "ENVIA-PEDIDO-GAR","Pedido GAR ja informado na DUA",::xml}},cNpSite) 
							EndIf 
						Else 
							If !lLogEr 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"E00023",cPedLog, "ENVIA-PEDIDO-GAR","Pedido GAR não encontrado",::xml}},cNpSite) 
							ELSE 
								U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"E00001",cPedLog, "ENVIA-PEDIDO-GAR","Pedido GAR não encontrado",::xml}},cNpSite) 
							EndIf 
 
							cMsgRet:= "Pedido GAR não encontrado" 
							cPedOut+= cNpSite+"," 
							cStatus:= "0" 
						EndIf 
 
						IF .NOT. Empty( cCodADE ) 
							ADE->( dbSetOrder(1) ) 
							IF ADE->( dbSeek(xFilial('ADE') + cCodADE) ) 
								msgCon( 'PEDIGO GAR ORIGEM 9(SAC), Gravando protocolo ' + cCodADE) 
								ADE->( Reclock("ADE",.F.) ) 
								ADE->ADE_PEDGAR := cPedGar 
								ADE->(MsUnlock()) 
							EndIF 
						EndIF						 
					Else 
						U_GTPutOUT(cID,"S",cPedLog,{"SENDMESSAGE",{.F.,"E00001",cPedLog, "ENVIA-PEDIDO-GAR","Pedido GAR não informado no xml", ::xml}},cNpSite) 
					EndIf 
				EndIf 
 
				If cStatus == "1" 
					cMsgRet:= "atualização recebida com Sucesso" 
 
					//-- RemoteID - E-mail de instrução pré-validação 
					//U_VNDA740( cPedGar, cNpSite ) 
				EndIf 
			Next 
		EndIf 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		If cStatus = "0" 
			::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+' Pedidos não encontrados:'+cPedOut+'</msg>' + CRLF 
		Else 
			::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+' </msg>' + CRLF 
		EndIf 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
	ElseIf cCategory == "SOLICITA-EMISSAO-NF" 
 
		oXml := XmlParser( ::xml, "_", @cError, @cWarning ) 
 
		cPedOri := oXml:_PEDIDO:_NUMEROPEDIDOORIGEM:TEXT 
		cOrigem := Iif(Empty(oXml:_PEDIDO:_ORIGEM:TEXT)," ","C") 
 
		SC5->( dbSetOrder(16) ) //Filial + Pedido Origem 
		IF SC5->( dbSeek( xFilial('SC5') + cOrigem + cPedOri ) ) 
			msgCon(cCategory + ' > Achou o pedido origem') 
			cPedLog := SC5->C5_XNPSITE 
			nTime 		:= Seconds() 
			aParamFun := {  SC5->C5_NUM,;				//1- Número do pedido 
			Val(SC5->C5_XNPSITE),;   	//2- Numero de controlo de JOB para log Gtin 
			.T.,;						//3- Fatura venda 
			nil,;						//4- Nosso Número para atualização do título a receber 
			.T.,;						//5- Fatura Serviço 
			.F.,;						//6- Fatura produto 
			nil,;						//7- Quantidade a faturar 
			nil,;						//8- operação de venda Hardware 
			nil,;						//9- operação de entrega Hardware 
			cOperVenS,;	  				//10- operação de venda de Serviço 
			cPedLog,;					//11- Pedido de Log 
			nil,;						//12- data do crédito Cnab 
			.F.,;						//13- Gera recibo de liberação 
			.F.,;						//14- Gera título para recibo  de liberação 
			nil,;						//15- Tipo do título de recibo de liberação 
			.F.}						//16- Fatura entrega de hardware 
 
			While .t. 
				IF U_Send2Proc("","U_VNDA190",aParamFun) 
					cMsgRet := "Pedido faturado com sucesso." 
					::cxmlret := XML_VERSION + CRLF 
					::cxmlret += '<confirmaType>' + CRLF 
					::cxmlret += '		<code>1</code>' + CRLF	// 1=sucesso na operação; 0=erro 
					::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
					::cxmlret += '		<exception></exception>' + CRLF 
					::cxmlret += '</confirmaType>' + CRLF 
					U_GTPutIN(cPedLog,"N",cPedLog,.T.,{"SENDMESSAGE",cPedLog,"SOLICITA-EMISSAO-NF","Send2Proc Vnda190" },cPedLog) 
					Exit 
				Else 
					nWait := Seconds()-nTime 
					If nWait < 0 
						nWait += 86400 
					Endif 
					cMsgRet := "Pedidos não foram faturados." 
					If nWait > 10 
						// Passou de 2 minutos tentando ? Desiste ! 
						U_GTPutOUT(cPedLog,"N",cPedLog,{"SENDMESSAGE",{.F.,"E00002",cPedLog,"Inconsistência realizar distribuição"}},cPedOri) 
						::cxmlret := XML_VERSION + CRLF 
						::cxmlret += '<confirmaType>' + CRLF 
						::cxmlret += '		<code>0</code>' + CRLF	// 1=sucesso na operação; 0=erro 
						::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
						::cxmlret += '		<exception>não houve comunicação.</exception>' + CRLF 
						::cxmlret += '</confirmaType>' + CRLF 
						EXIT 
					Endif 
					// Espera um pouco ( 5 segundos ) para tentar novamente 
					Sleep(5000) 
				EndIF 
			EndDo 
		Else 
			msgCon(cCategory + ' > não achou o pedido origem') 
		EndIF 
 
	Elseif cCategory == "CANCELA-PEDIDO" 
		//Gera objeto com o JSON 
		If FWJsonDeserialize(xml,@oObj) 
			/* 	Estutura do JSON Recebido 
			oObj:pedidoSite		 
			oObj:motivo 
			*/ 
 
			cPedLog:=oObj:pedidoSite 
 
			DbSelectArea("SC5") 
			dbOrderNickNAme('PEDSITE') //C5_FILIAL + C5_XNPSITE 
 
			If SC5->(DbSeek(xFilial("SC5")+cPedLog)) 
 
				SC5->(Reclock("SC5",.F.)) 
				SC5->C5_ARQVTEX := AllTrim(Str(oObj:motivo)) 
				SC5->C5_LIBEROK := "S" 
				SC5->C5_NOTA    := Replicate("X",Len(SC5->C5_NOTA)) 
				SC5->C5_SERIE   := Replicate("X",Len(SC5->C5_SERIE)) 
				SC5->(MsUnlock()) 
 
				SC6->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM 
				SC6->( MsSeek( xFilial("SC6") + SC5->C5_NUM ) ) 
 
				While .NOT. SC6->(EOF()) .AND.  SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC6->C5_NUM == SC5->C5_NUM 
					IF Empty(SC6->C6_NOTA) 
						//ELIMINAR RESÍDUO 
						SC6->( RecLock( 'SC6', .F. ) ) 
						SC6->C6_BLQ := 'R' 
						SC6->( MsUnLock() ) 
						SC6->(DbSkip()) 
					Endif 
				End 
 
				cStatus := "1" 
				cMsgRet := "Pedido Cancelado com sucesso" 
			Else 
				cStatus := "0" 
				cMsgRet := "não foi possível encontrar o pedido Site informado para o cancelamento" 
			Endif 
		Else  
			cStatus := "0" 
			cMsgRet := "não foi possivel efetuar a leitura do JSON" 
		Endif 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
 
	Elseif cCategory == "ATUALIZA-PEDIDO-SAGE" 
 
		//Gera objeto com o JSON 
		If FWJsonDeserialize(xml,@oObj) 
			/* 	Estutura do JSON Recebido 
			oObj:contract:idContrato			* Contrato Sage 
			oObj:contract:idPessoa			* Id Cliente Sage 
			oObj:contract:codPedidoCenize	* Pedido Site Protheus 
			*/ 
			DbSelectArea("SC5") 
			dbOrderNickNAme('PEDSITE') //C5_FILIAL + C5_XNPSITE 
			If SC5->(DbSeek(xFilial("SC5")+oObj:contract:codPedidoCenize)) 
				SC5->(Reclock("SC5",.F.)) 
				SC5->C5_CTRSAGE := AllTrim(Str(oObj:contract:idContrato)) 
				SC5->(MsUnlock()) 
 
				cStatus := "1" 
				cMsgRet := "Contrato Sage Gravado com sucesso" 
			Else 
				cStatus := "0" 
				cMsgRet := "não foi possível encontrar o pedido Site informado pela Sage" 
			Endif 
		Else  
			cStatus := "0" 
			cMsgRet := "não foi possivel efetuar a leitura do JSON" 
		Endif 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
 
	Elseif cCategory == "NOTIFICA-VALIDACAO-EXTERNA" 
 
		//Gera objeto com o JSON 
		If FWJsonDeserialize(xml,@oObj) 
			/* 	Estutura do JSON Recebido 
			oObj:pedido 
			*/ 
 
			cNpSite := oObj:pedido 
 
			lLogEr	:= .F. 
			cSQL := " SELECT COUNT(*) QTDOUT " 
			cSQL += " FROM GTOUT " 
			cSQL += " WHERE GT_XNPSITE = '" + cNpSite + "' " 
			cSQL += "   AND GT_TYPE = 'S' " 
			cSQL += "   AND GT_CODMSG = 'E00023' " 
			cSQL += "   AND D_E_L_E_T_ = ' ' " 
 
			cTRB := GetNextAlias() 
			cSQL := ChangeQuery( cSQL ) 
 
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.) 
 
			If .NOT. (cTRB)->( EOF() ) .and. (cTRB)->QTDOUT >= 4 
				lLogEr := .T. 
			Else 
				lLogEr := .F. 
			EndIF 
 
			(cTRB)->( dbCloseArea() ) 
			FErase( cTRB + GetDBExtension() ) 
 
			DbSelectArea("SC5") 
			dbOrderNickNAme('PEDSITE') //C5_FILIAL + C5_XNPSITE 
 
			U_GTPutIN(cNpSite,"S",cNpSite,.T.,{"SENDMESSAGE",cNpSite,"NOTIFICA-VALIDACAO-EXTERNA", "Atualizacao de dados de pedido", ::xml},cNpSite) 
 
			If SC5->(DbSeek(xFilial("SC5")+cNpSite)) 
 
				SC5->(Reclock("SC5",.F.)) 
				SC5->C5_XLIBFAT := 'P' 
				SC5->(MsUnlock()) 
 
				cStatus := "1" 
				cMsgRet := "Notificação GAD com sucesso para o pedido Site [" + cNpSite + "]" 
 
				U_GTPutOUT(cNpSite,"S",cNpSite,{"SENDMESSAGE",{.T.,"M00001",cNpSite, "NOTIFICA-VALIDACAO-EXTERNA", "Informado pedido Site com Sucesso",::xml}},cNpSite) 
			Else 
				If !lLogEr 
					U_GTPutOUT(cNpSite,"S",cNpSite,{"SENDMESSAGE",{.F.,"E00023",cNpSite, "NOTIFICA-VALIDACAO-EXTERNA","Pedido Site não encontrado",::xml}},cNpSite) 
				ELSE 
					U_GTPutOUT(cNpSite,"S",cNpSite,{"SENDMESSAGE",{.F.,"E00001",cNpSite, "NOTIFICA-VALIDACAO-EXTERNA","Pedido Site não encontrado",::xml}},cNpSite) 
				EndIf 
 
				cStatus := "0" 
				cMsgRet := "não foi possível encontrar o pedido Site [" + cNpSite + "] informado para o GAD" 
			Endif 
		Else  
			cStatus := "0" 
			cMsgRet := "não foi possivel efetuar a leitura do JSON" 
		Endif 
 
		::cxmlret := XML_VERSION + CRLF 
		::cxmlret += '<confirmaType>' + CRLF 
		::cxmlret += '		<code>'+cStatus+'</code>' + CRLF	// 1=sucesso na operação; 0=erro 
		::cxmlret += '		<msg>'+cCategory+' '+cMsgRet+'</msg>' + CRLF 
		::cxmlret += '		<exception></exception>' + CRLF 
		::cxmlret += '</confirmaType>' 
	EndIf 
 
Return(lReturn) 
 
/*/{Protheus.doc} MakeMens 
 
Função statica para montar mensagem de acordo código da formula 
 
@author Totvs SM - David 
@since 06/09/2012 
@version P11 
 
/*/ 
Static Function MakeMens(cProGar,cProProt,nQtdVen,nPrcVen,cCartao,cPedBpag,cXnpSite) 
 
	Local cMensagem := "" 
	Local cDescri	:= "" 
	Local nValor	:= nQtdVen * nPrcVen 
	Local cTipoProd := "" 
 
	Default cProGar	:= "" 
	Default cProProt:= "" 
	Default nQtdVen	:= 1 
	Default nPrcVen	:= 0 
	Default cCartao	:= "" 
	Default cPedBpag:= "" 
	Default cXnpSite:= "" 
 
	If !Empty(cProGar) 
		PA8->( DbSetOrder(1) ) 
		PA8->( DbSeek( xFilial("PA8")+cProGar ) ) 
 
		SB1->( DbSetOrder(1) ) 
		SB1->( DbSeek( xFilial("SB1")+PA8->PA8_CODMP8 ) ) 
	EndIf 
 
	If !empty(cProProt) 
		SB1->( DbSetOrder(1) ) 
		SB1->( DbSeek( xFilial("SB1")+cProProt ) ) 
	EndIf 
 
	cTipoProd	:= SB1->B1_TIPO 
	cDescri		:= SB1->B1_DESC 
 
	//Trata o Nome da Operadora de Cartao de Credito
	cCartao 	:= IIF( cCartao=='AME', "Amex",			cCartao) 
	cCartao 	:= IIF( cCartao=='RED', "Mastercard",	cCartao) 
	cCartao 	:= IIF( cCartao=='VIS', "Visa",			cCartao) 
 
	//Processo de Montagem de Mensagem, para SC5 com base no Produto
	cMensagem:= "" 
	If cTipoProd <> "MR" 
		cMensagem:= AllTrim(cDescri) + ";" 
		// 02/01/15 - retirado devio novo ponto de faturamento 
		//cMensagem+= Space(1) + "Qtde:" 
		//cMensagem+= Space(1) + AllTrim(Transform(nQtdVen, "@E 999,999,999.99")) + ";" 
		//cMensagem+= Space(1) + "Preço Unitário:" 
		//cMensagem+= Space(1) + AllTrim(Transform(nPrcVen, "@E 999,999,999.99")) + ";" 
		cMensagem+= Space(1) + "Valor do Pedido:" 
		cMensagem+= Space(1) + AllTrim(Transform(nValor,  "@E 9,999,999,999.99")) + ";" 
	Endif 
 
	// 02/01/15 - retirado devio novo ponto de faturamento 
	//cMensagem+= Space(1) + "NF Liquidada -" 
	If !Empty(cPedBpag) 
		cMensagem+= " Pedido GAR: " + cPedBpag 
	EndIf 
 
	If !Empty(cXnpSite) 
		cMensagem+= " Ordem de Fat.: " + cXnpSite 
	EndIf 
 
	If !Empty(cCartao) 
		cMensagem+= " Pgto Cartao: " + cCartao 
	Endif 
 
Return(cMensagem) 

/*/{Protheus.doc} RetSG1 
Retorna dados da SG1
@author Desconhecido
@since 03/04/2020 
@version P12 
/*/ 
Static Function RetSG1(cProdEstr,nQtdG1) 
	Local aRet := {} 
	Local nRecG1 := 0 
	Local nRecAnt:= 0 
	Local nI, nJ := 0 
	Local aRetG1 := {} 
 
	Default nQtdG1 := 1 
 
	SG1->(DbSetorder(1)) 
 
	If SG1->(DbSeek(xFilial("SG1")+cProdEstr)) 
 
		nRecG1 := SG1->(Recno()) 
 
		For nI:=1 to nQtdG1	 
 
			SG1->(DbGoTo(nRecG1)) 
			While !SG1->(EoF()) .and. Alltrim(SG1->G1_COD) == Alltrim(cProdEstr)  
 
				nRecAnt := SG1->(Recno()) 
 
				If SG1->(DbSeek(xFilial("SG1")+Alltrim(SG1->G1_COMP))) 
					aRetG1 := RetSG1(Alltrim(SG1->G1_COD),SG1->G1_QUANT) 
					For nJ:=1 to len(aRetG1) 
						aadd(aRet,aRetG1[nJ]) 
					Next nJ 
				Else 
					SG1->(DbGoTo(nRecAnt)) 
					aadd(aRet,Alltrim(SG1->G1_COMP)) 
				EndIf 
 
				SG1->(DbGoTo(nRecAnt)) 
 
				SG1->(DbSkip())		 
			End 
 
		Next nI 
	Else 
		aadd(aRet,Alltrim(cProdEstr)) 
	EndIf 
 
Return(aRet) 
 
/*/{Protheus.doc} HardwareAvulsoProvider 
Verifica se deve gerar dados de entrega no pedido de venda,
somente deve gerar se o tipo de servico nao for retirar na loja 
@author Bruno Nunes 
@since 03/04/2020 
@version P12 
/*/ 
static function vldServEnt( cNomServEnt ) 
	local  lGeraEntrega := .F. 
	default cNomServEnt  := "" 
	if !empty( cNomServEnt ) 
		if alltrim( cNomServEnt ) != cTAG_NOMESERVICO_RETIRAR_LOJA   
			lGeraEntrega := .T. 
		endif 
	else 
		msgCon( "A variavel 'cNomServEnt' esta vazia na funcao vldServEnt( cNomServEnt )" ) 
	endif 
return lGeraEntrega 
 
/*/{Protheus.doc} HardwareAvulsoProvider 
Monta msg no console.log de forma na ajuda da analise 
@author Bruno Nunes 
@since 03/04/2020 
@version 1.03 
/*/ 
static function msgCon( cTexto ) 
	default cTexto := "" 
	//cValToChar -Converte uma informação do tipo caractere, data, lógico ou numérico para string, sem adição de espaços na informação. 
	conout("-- server_hardwareavulso.prw - versao "+cVERSAO+": " + cValToChar( cTexto ) )  
return 
 
/*/{Protheus.doc} ExecPedi 
JOB para processar entrada de pedido de vendas, cliente e etc. 
@author Bruno Nunes 
@since 15/05/2020 
@version 1.04 
/*/
User Function ExecPedi( cParXNPSIT ) 
	Local lReturn	  := .T. 
	Local aDados	  := {} 
	Local nOpc		  := 3 
	Local cNpSite	  := "" 
	Local cTipo		  := "" 
	Local cCliente	  := "" 
	Local cLjCli	  := "" 
	Local cTpCli	  := "" 
	Local cForPag	  := "" 
	Local dEmissao	  := "" 
	Local cNome		  := "" 
	Local cNReduz	  := "" 
	Local cEnd		  := "" 
	Local cBairro	  := "" 
	Local cCompl	  := "" 
	Local cCep		  := "" 
	Local cFone		  := "" 
	Local cDDD		  := "" 
	Local cUfNome	  := "" 
	Local cUf		  := "" 
	Local cInEst	  := "" 
	Local cInMun	  := "" 
	Local cSufra	  := "" 
	Local cEmail	  := "" 
	Local cPessoa	  := "" 
	Local cIbge		  := "" 
	Local cLograd	  := "" 
	Local dEntreg	  := CtoD("  /  /  ") 
	Local cTES		  := "" 
	Local cError	  := "" 
	Local cWarning	  := "" 
	Local cCgc		  := "" 
	Local cTabela	  := "" 
	Local cTabela1	  := "" 
	Local aProdutos	  := {} 
	Local aProdPrin	  := {} 
	Local cPosNom	  := ""	//Nome do Posto 
	Local cPosEnd	  := ""	//Endereco Posto 
	Local cPosBai	  := ""	//Bairro Posto 
	Local cPosCom	  := ""	//Complemento Posto 
	Local cPosCep	  := ""	//Cep Posto 
	Local cPosFon	  := ""	//Fone Posto 
	Local cPosCid	  := ""	//Nome da cidade do Posto 
	Local cPosUf	  := ""	//UF do Posto 
	Local cPosLoj	  := ""	//Loja do Posto 
	Local cPosGAR	  := "" 
	Local lChkVou	  := .F. 
	Local cTipCar	  := "" 
	Local cNumCart	  := "" 
	Local cNomTit	  := "" 
	Local cCodSeg	  := "" 
	Local cDtVali	  := "" 
	Local cParcela	  := "" 
	Local cLinDig	  := "" 
	Local cNumvou	  := "" 
	Local nQtdVou	  := 0 
	Local aParam	  := {} 
	Local aRVou		  := {.T., ""} 
	Local cNomeC	  := "" 
	Local cCpfC		  := "" 
	Local cEmailC	  := "" 
	Local cSenhaC	  := "" 
	Local cFoneC	  := "" 
	Local cQrySC5	  := "" 
	Local cQryZ11	  := "" 
	Local cQryGT	  := "" 
	Local cUpdLis	  := "" 
	Local cUpdPed	  := "" 
	Local cID		  := "" 
	Local aRetCo	  := {} 
	Local aRetCl	  := {} 
	Local cOriVen	  := "" 
	Local cPedGar	  := "" 
	Local cEndEnt	  := "" 
	Local cBaiEnt	  := "" 
	Local cNumEnt	  := "" 
	Local cCepEnt	  := "" 
	Local cCidEnt	  := "" 
	Local cUfEnt	  := "" 
	Local aDadEnt	  := {} 
	Local oXmlPst	  := nil 
	Local oXmlEntg	  := nil 
	Local bOldBlock 
	Local cErrorMsg   := '' 
	Local nDias		  := 0 
	Local bVldPed	  := {|a,b| IIf(!Empty(a),a,b)} 
	Local nTotPed	  := 0 
	Local cPedAnt	  := "" 
	Local cXTotPed	  := "" 
	Local cServEnt	  := "" 
	Local cNomServEnt := "" 
	Local cTipShop	  := "" 
	Local cPedOrigem  := "" 
	Local cCodDUA	  := "" 
	Local cCGCDUA	  := "" 
	Local cMunDUA	  := "" 
	Local cObsDUA	  := "" 
	Local cEstDUA	  := "" 
	Local lPedExist	  := .F. 
	Local cCodRev	  := "" 
	Local cProtocolo  := "" 
	Local nTentativa  := 0 
	Local lCliente    := .F. 
	Local nProd       := 0 
	Local nVlrFret	  := 0 
	Local cEcommerce  := '' 
	Local cCupomDesc  := '' 
	Local nValBruto	  := 0 
	Local cValLiq	  := '' 
	Local nValDesc	  := 0 
	Local lContinue	  := .F. 
	local oVoucher    := nil
	Local cCodTransp  := "" 
 
	Private cContSite := "" 
	Private oXml	  := nil 
	Private nPed	  := 0 
	Private oCombo	  := nil 
 
	Default cParXNPSIT := "" 
 
	U_GTPutRet('executaPedidos','A') 
 
	cXTotPed	:= GetNewPar("MV_XTOTPED","300") 
	cTabela		:= GetMV("MV_XTABPRC",,"") 
	nDias		:= GetMV("MV_XDIAPRC",,3) 
 
	If Select("QRYGT") > 0 
		DbSelectArea("QRYGT") 
		QRYGT->(DbCloseArea()) 
	EndIf 
 
	//+--------------------------------------------------------------+ 
	//| Recupero as listas de pedidos que ainda nao foram executadas | 
	//| ou pedidos ainda não processados devido a falta de Thread de | 
	//| acordo numero de dias informado no  parâmetro MV_XDIAPRC     | 
	//+--------------------------------------------------------------+ 
	if empty( cParXNPSIT ) 
		cQryGT := "SELECT GT_ID, GT_PEDGAR " 
		cQryGT += "FROM " 
		cQryGT += "( " 
		cQryGT += "SELECT GT_ID, GT_PEDGAR " 
		cQryGT += "FROM GTIN " 
		cQryGT += "WHERE GT_TYPE = 'F' " 
		cQryGT += "AND GT_SEND = 'F' " 
		cQryGT += "AND GT_DATE > '" + DtoS( Date() - nDias ) + "' " 
		cQryGT += "AND GT_INPROC = 'F' " 
		cQryGT += "AND D_E_L_E_T_ = ' ' " 
		cQryGT += "UNION " 
		cQryGT += "SELECT " 
		cQryGT += "	GT_ID, GT_PEDGAR " 
		cQryGT += "FROM " 
		cQryGT += "	GTOUT A LEFT OUTER JOIN "+RetSqlName("SC5")+" B ON " 
		cQryGT += "	B.C5_FILIAL = '"+xFilial("SC5")+"' AND " 
		cQryGT += " B.C5_EMISSAO > '" + DtoS( Date()-nDias ) + "' AND " 
		cQryGT += " B.D_E_L_E_T_ = ' ' AND " 
		cQryGT += "	A.GT_XNPSITE = B.C5_XNPSITE " 
		cQryGT += "WHERE " 
		cQryGT += "	B.C5_NUM IS NULL AND " 
		cQryGT += "	A.GT_DATE > '" + DtoS( Date() - nDias ) + "' AND " 
		cQryGT += "	A.GT_TYPE = 'F' AND " 
		cQryGT += "	A.GT_PEDGAR > ' ' AND " 
		cQryGT += "	A.GT_XNPSITE > ' ' AND " 
		cQryGT += "	A.GT_SEND = 'F' AND " 
		cQryGT += "	A.GT_CODMSG = 'E00002' " 
		cQryGT += ") " 
		cQryGT += "WHERE " 
		cQryGT += " ROWNUM <= " + AllTrim( cXTotPed ) 
	else 
		cQryGT := "SELECT GT_ID, GT_PEDGAR " 
		cQryGT += "FROM GTIN " 
		cQryGT += "WHERE GT_TYPE = 'F' " 
		//cQryGT += "		AND GT_SEND = 'F' " 
		//cQryGT += "		AND GT_INPROC = 'F' " 
		cQryGT += "		AND D_E_L_E_T_ = ' ' "	 
		cQryGT += "		AND GT_XNPSITE IN ('"+ alltrim( cParXNPSIT )+ "')" 
	endif 
 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),"QRYGT",.F.,.T.) 
	DbSelectArea("QRYGT") 
 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT),"QRUPD",.F.,.T.) 
	DbSelectArea("QRUPD") 
 
	//Imprime informações de processamento no arquivo console.log 
	logProcess( cQryGT ) 
 
	While !QRUPD->(EoF()) 
		cSql := " UPDATE GTIN SET GT_INPROC = 'T' WHERE GT_TYPE = 'F' AND GT_ID = '"+AllTrim(QRUPD->GT_ID)+"' AND  GT_PEDGAR =  '"+AllTrim(QRUPD->GT_PEDGAR)+"' " 
		TcSqlExec(cSql) 
		cSql := " UPDATE GTOUT SET GT_SEND = 'T' WHERE GT_TYPE = 'F' AND GT_CODMSG = 'E00002' AND  GT_PEDGAR =  '"+AllTrim(QRUPD->GT_PEDGAR)+"' " 
		TcSqlExec(cSql) 
		QRUPD->(DbSkip()) 
	EndDo 
 
	QRUPD->(DbCloseArea()) 
 
	cPedAnt	:= "" 
	While QRYGT->(!Eof()) 
		//Limpar todas as variáveis 
		nPed		:= 0 
		nVlrFret	:= 0 
		nTotPed		:= 0 
 
		aProdutos	:= {} 
		aProdPrin	:= {} 
		aDados		:= {} 
		aDadEnt		:= {} 
		aRVou		:= {} 
		aProcVou	:= {} 
 
		cError		:= '' 
		cTipo		:= '' 
		cNpSite		:= '' 
		cOriVen		:= '' 
		cPedGar		:= '' 
		cPedLog		:= '' 
		cPedOrigem	:= '' 
		cCodRev		:= '' 
		cID			:= '' 
		cProtocolo	:= '' 
		cEcommerce	:= '' 
		cCupomDesc	:= '' 
		nValBruto	:= 0 
		cValLiq		:= '' 
		nValDesc	:= 0 
		cCodTransp  := ""
 
		lPedExist	:= .F. 
		lEntrega	:= .F. 
		lChkVou		:= .F. 
		lContinue	:= .F. 
		oCombo		:= NIL 
 
		cID			:= AllTrim(QRYGT->GT_ID) 
 
		//Montal XML do pedido de venda 
		oXml := montarXML( cID, @cError, @cWarning, @nPed) 
 
		If Empty(cError) 
			cTipo		:= "N" //Tipo de pedido N = Normal 
 
 
			If Valtype(nPed) == "N" .and. nPed > 0  //For nPed := 1 to Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) 
 
				aProdutos := {} 
				aProdPrin := {} 
 
				cNpSite 	:= AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMERO:TEXT) 
				cOriVen	    := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_ORIGEMVENDA:TEXT) 
 
				If	Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO) <> "A" 
					XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO, "_PRODUTO" ) 
				EndIf 
 
				If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_NUMEROPEDIDOGAR:TEXT") <> "U" 
					cPedGar		:= IIF(AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMEROPEDIDOGAR:TEXT)=='0',"",AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMEROPEDIDOGAR:TEXT) ) 
					cPedLog		:= Eval(bVldPed,cPedGar,cNpSite) 
					cPedOrigem	:= "" 
 
					If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_NUMEROPEDIDOORIGEM:TEXT") <> "U" 
						cPedOrigem  := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_NUMEROPEDIDOORIGEM:TEXT) 
						If EMPTY(cPedOrigem) .AND.!EMPTY(cPedLog) 
							cPedOrigem  :=cPedLog 
						EndIf 
					EndIf 
 
					cCodRev  := ""				 
					//-- Recupera o código de Revenda do XML 
					If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_CODREV:TEXT") <> "U" 
						cCodRev  := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CODREV:TEXT) 
					EndIf 
 
					//Verifica se Fila se Refere a Pedido GAR posicionado na Tabela Gtin 
					If AllTrim(QRYGT->GT_PEDGAR) == cPedLog .and. AllTrim(QRYGT->GT_PEDGAR) <> cPedAnt 
 
						cUpdPed := "UPDATE GTIN " 
						cUpdPed += "SET GT_SEND = 'T' " 
						cUpdPed += "WHERE GT_ID = '" + cID + "' " 
						cUpdPed += "  AND GT_TYPE = 'F' " 
						cUpdPed += "  AND GT_SEND = 'F' " 
						cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
						cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
						TCSqlExec(cUpdPed) 
 
						//Semaforo para controle de processamento de pedido 
						If LockByName(cNpSite,.F.,.F.) 
 
							//TRATAMENTO PARA ERRO FATAL NA THREAD 
							cErrorMsg := "" 
							bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
 
							BEGIN SEQUENCE 
								cProtocolo :="" 
								cOriVen	 := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_ORIGEMVENDA:TEXT)		// Origem da Venda 1 - Vendas Varejo e 2 - HardwareAvulso 
								IF ValType( XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed], "_PROTOCOLO") ) == 'O' 
									cProtocolo := Alltrim( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PROTOCOLO:TEXT ) 
								EndIF 
 
								If Select("QRYSC5") > 0 
									DbSelectArea("QRYSC5") 
									QRYSC5->(DbCloseArea()) 
								EndIf 
 
								cQrySC5 := "SELECT COUNT(*) NCONT " 
								cQrySC5 += "FROM " + RetSqlName("SC5") + " " 
								cQrySC5 += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' " 
								If !Empty(cPedGar) .and. cPedGar <> '0' 
									cQrySC5 += "  AND C5_CHVBPAG = '" + cPedGar + "' " 
								Else 
									cQrySC5 += "  AND C5_XNPSITE = '" + cNpSite + "' " 
								EndIf 
								cQrySC5 += "  AND D_E_L_E_T_ = ' '" 
 
								cQrySC5 := ChangeQuery(cQrySC5) 
 
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.) 
								DbSelectArea("QRYSC5") 
 
								lPedExist := QRYSC5->NCONT > 0 
 
								DbSelectArea("QRYSC5") 
								QRYSC5->(DbCloseArea()) 
 
								//Verifica se pedido existe na tabela Z11-DUA 
								If !lPedExist 
									If Select("QRYZ11") > 0 
										DbSelectArea("QRYZ11") 
										QRYZ11->(DbCloseArea()) 
									EndIf 
 
									cQryZ11 := "SELECT COUNT(*) NCONT " 
									cQryZ11 += "FROM " + RetSqlName("Z11") + " " 
									cQryZ11 += "WHERE Z11_FILIAL = '" + xFilial("Z11") + "' " 
									cQryZ11 += "  AND Z11_PEDSIT = '" + cNpSite + "' " 
									cQryZ11 += "  AND D_E_L_E_T_ = ' '" 
 
									cQryZ11 := ChangeQuery(cQryZ11) 
 
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ11),"QRYZ11",.F.,.T.) 
									DbSelectArea("QRYZ11") 
 
									lPedExist := QRYZ11->NCONT > 0 
 
									DbSelectArea("QRYZ11") 
									QRYZ11->(DbCloseArea()) 
								EndIf 
 
								If !lPedExist 
 
									cEmailC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT 
									cNomeC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT 
									cCpfC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT 
									cSenhaC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_SENHA:TEXT 
									cFoneC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT 
 
									aDados := {cNomeC, cCpfC, cEmailC, cSenhaC, cFoneC} 
 
									aRetCo := U_VNDA120(cCpfC, aDados,cNpSite,cID,nil,cPedLog) //#1 passado o numero do pedido 
 
									cInEst	:= "" 
									cInMun	:= "" 
									cSufra	:= "" 
 
									oXmlEntg	:= XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed],"_ENTREGA") 
 
									If ValType(oXmlEntg) <> 'U' 
										nVlrFret 	:= Val(oXmlEntg:_VALOR:TEXT) 
										cServEnt	:= PadL(AllTrim(Str(Val(oXmlEntg:_SERVICO:TEXT))),5,"0") 
										cNomServEnt	:= oXmlEntg:_NOMESERVICO:TEXT 
										cEndEnt		:= oXmlEntg:_ENDERECO:_DESC:TEXT 
										cBaiEnt		:= oXmlEntg:_ENDERECO:_BAIRRO:TEXT 
										cNumEnt		:= oXmlEntg:_ENDERECO:_NUMERO:TEXT 
										cComEnt		:= oXmlEntg:_ENDERECO:_COMPL:TEXT 
										cCepEnt		:= oXmlEntg:_ENDERECO:_CEP:TEXT 
										cCidEnt		:= oXmlEntg:_ENDERECO:_CIDADE:_NOME:TEXT 
										cUfEnt		:= oXmlEntg:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
										cIbge		:= oXmlEntg:_ENDERECO:_CODIGOIBGE:TEXT 
										lEntrega 	:= vldServEnt( cNomServEnt ) 
 
										aDadEnt := {cEndEnt, cBaiEnt, cNumEnt, cComEnt, cCepEnt, cCidEnt, cUfEnt, cIbge } 
 
										DbSelectArea("SA4") 
										SA4->(dbSetOrder(1)) // A1_FILIAL + A1_COD
										
										// Tenta encontrar o próximo SXE disponível para o cadastro da transportador
										cCodTransp := GetSXENum("SA4", "A4_COD")
										While SA4->(dbSeek(xFilial("SA4") + cCodTransp))
											ConfirmSX8()
											cCodTransp := GetSXENum("SA4", "A4_COD")
										EndDo

										// Grava a transportadora, a partir do código de serviço
										SA4->(dbOrderNickNAme('SA4_4') )  // A1_FILIAL + A1_XCODCOR
										If !SA4->(DbSeek(xFilial("SA4")+cServEnt)) 
											SA4->(Reclock("SA4",.T.)) 
												SA4->A4_COD		:= cCodTransp
												SA4->A4_NOME	:= cNomServEnt 
												SA4->A4_NREDUZ	:= cNomServEnt 
												SA4->A4_VIA		:= "MULTIMODAL" 
												SA4->A4_ESTFIS	:= "000001" 
												SA4->A4_ENDPAD	:= "PADRAO" 
												SA4->A4_LOCAL	:= "01" 
												SA4->A4_XCODCOR	:= cServEnt 
												SA4->A4_CODPAIS	:= "01058" 
												SA4->A4_COD_MUN	:= "50308" 
												SA4->A4_TPTRANS	:= "1" 
												ConfirmSX8()
											SA4->(MsUnlock()) 
										EndIf 
 
									Else 
										lEntrega := .F. 
										nVlrFret := 0 
										cServEnt := "" 
										aDadEnt  := {"", "", "", "", "", "", "", ""} 
									EndIf 
 
									If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_XSI_TYPE:TEXT") <> "U" 
										//Verifico se eh pessoa fisica ou juridica, pois a informacao eh passada de maneira diferente no XML 
										If "PF" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_XSI_TYPE:TEXT 
											cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CPF:TEXT 
											cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT 
											cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT 
											cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + "," + oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT 
											cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT 
											cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 
											cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT 
											cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8) 
											cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2) 
											cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 
											cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
											//Renato Ruy - 14/11/2017 
											//Adiciona o codigo do IBGE 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT") <> "U" 
												cIbge	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT 
											Endif 
											cLograd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT 
											cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT 
											cPessoa	:= "F" 
										Else 
											cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CNPJ:TEXT 
											cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT 
											cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT 
											cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + "," +oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT 
											cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT 
											cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 
											cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT 
											cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8) 
											cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2) 
											cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 
											cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
											//Renato Ruy - 14/11/2017 
											//Adiciona o codigo do IBGE 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT") <> "U" 
												cIbge	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT 
											Endif 
											cLograd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT 
											cInEst	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCEST:TEXT 
											cInMun	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCMUN:TEXT 
											cSufra	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_SUFRAMA:TEXT 
											cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT 
											cPessoa	:= "J" 
										EndIf 
 
										cInEst	:= iif(Empty(cInEst),"ISENTO",ALLTRIM(cInEst)) 
										cInMun	:= iif(Empty(cInMun),"ISENTO",ALLTRIM(cInMun)) 
 
										DbSelectArea("SA1") 
										DbSetOrder(3) //A1_FILIAL + A1_CGC 
										If !DbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc)) 
 
											//Renato Ruy - 07/07/2017 
											//Por causa do processamento em threads, dois clientes tentavam ser criados com o mesmo codigo 
											//Efetua 5 tentativas para reservar o codigo do cliente 
											nTentativa := 0 
											lCliente   := .F. 
											While !lCliente .And. nTentativa < 10 
												sleep(Randomize( 1000, 5000 )) 
												cCliente := GetSXENum('SA1','A1_COD') 
												lCliente := LockByName("CLIENTE-"+cCliente) 
												nTentativa++ 
											Enddo 
 
											cLjCli		:= "01" 
											cTpCli		:= "F"	//Consumidor final 
											nOpc 		:= 3 
 
											If lCliente 
 
												//Destrava antes de executar a execAuto e grava a sequencia 
												SA1->(ConfirmSX8()) 
												UnLockByName("CLIENTE-"+cCliente) 
 
												aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra,cNpSite,cID,aDadEnt,cPedLog,cIbge,cLograd) 
											Else 
												aRetCl := {.F.,"não foi possível reservar o numero para gerar o cadastro do cliente!"} 
											Endif 
 
										Else 
											cCliente	:= SA1->A1_COD 
											cLjCli		:= SA1->A1_LOJA 
											cTpCli		:= SA1->A1_TIPO 
 
											nOpc 		:= 4 
 
											aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra,cNpSite,cID,aDadEnt,cPedLog,cIbge,cLograd) 
 
										EndIf 
 
										If aRetCl[1] 
											//Cliente 
											cCliente	:= SA1->A1_COD 
											cLjCli		:= SA1->A1_LOJA 
											cTpCli		:= SA1->A1_TIPO 
 
											U_VNDA100("SA1", cCliente, cLjCli, cContSite) 
										EndIf 
 
									Else 
										aRetCl := {.T.} 
									EndIf 
 
									If aRetCl[1] 
 
										//Zero as variaveis das formas de pagamento, para pegar a proxima 
										cNumCart	:= "" 
										cNomTit		:= "" 
										cCodSeg		:= "" 
										cDtVali		:= "" 
										cParcela	:= "" 
										cTipCar		:= " " 
										cLinDig		:= "" 
										lChkVou		:= .F. 
										aRVou		:= {.T.,""} 
										cNumvou		:= "" 
										nQtdVou		:= 0 
										cTipShop	:= "0" 
										cCodDUA		:= "" 
										cCGCDUA		:= "" 
										cMunDUA		:= "" 
										cObsDUA		:= "" 
										cEstDUA		:= "ES" 
										cDocCar 	:= '' 
										cDocAut 	:= '' 
										cCodConf	:= '' 
										cOriVou 	:= '1' //Emissor Voucher ERP Protheus(1)  -- Usado para diferenciar emissor Voucher Sage(2) 
										cForPag		:= '' 
										//Forma de Pagamento 
										If "cartao" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT 
											cForPag		:= "2" 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_NUMERO:TEXT") <> "U" 
												cNumCart	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT 
											EndIf 
											cNomTit		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NMTITULAR:TEXT 
											cCodSeg		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CODSEG:TEXT 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_DTVALID:TEXT") <> "U" 
												cDtVali		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DTVALID:TEXT 
											EndIf 
 
											cParcela	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_PARCELAS:TEXT 
											cTipCar		:= Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_TIPO:TEXT) 
 
											If cTipCar == "9" .or. cTipCar == "10" 
												cForPag := "3" 
											EndIf 
 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_DOCUMENTO:TEXT") <> "U" 
												cDocCar := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DOCUMENTO:TEXT 
											Endif 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_AUTORIZACAO:TEXT") <> "U" 
												cDocAut := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_AUTORIZACAO:TEXT 
											Endif 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_CONFIRMACAO:TEXT") <> "U" 
												cCodConf:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CONFIRMACAO:TEXT 
											Endif 
 
										ElseIf "boleto" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT 
											cForPag		:= "1" 
											cLinDig		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_LINHADIGITAVEL:TEXT 
										ElseIf "voucher" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT 
											lChkVou		:= .T. 
											cForPag		:= "6" 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_NUMERO:TEXT") <> "U" 
												cNumvou		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT 
											EndIf 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_QTCONSUMIDA:TEXT") <> "U" 
												nQtdVou		:= Val(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_QTCONSUMIDA:TEXT) 
											EndIf 
											//Tratamento para Voucher SAGE 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_EMISSOR:TEXT") <> "U" 
												cOriVou := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_EMISSOR:TEXT 
												if cOriVou=='2' //Emissor Voucher SAGE 
													// não se faz necessário chegagem do voucher pois não foi gerado pelo ERP Protheus 
													lChkVou	:= .F. 
													// Gravo dados do contato nas variáveis de DUA/SAGE para atualização da Z11 
													cEmailC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT 
													cNomeC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT 
													cCpfC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT 
													cFoneC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT 
													cCGCDUA	:= cCpfC 
													cObsDUA	:= "Nome;"+cNomeC+";Email;"+cEmailC +";Fone;"+cFoneC 
												Endif 
											Endif 
										ElseIf "debito" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT 
											cForPag		:= "7" //Shopline 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_TIPO:TEXT") <> "U" 
												cTipShop    := Alltrim(Str(aScan(__Shop,{|x| x == oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_TIPO:TEXT }))) 
											EndIf 
 
											If cTipShop $ "4,5" 
												cForPag := "4" 
											EndIf 
										ElseIf "dua" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT 
											cForPag	:= "8" //DUA - Prodest 
											cCodDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERODUA:TEXT 
											cCGCDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CPFCNPJ:TEXT 
											cMunDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CODIGOMUNICIPIO:TEXT 
											cObsDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_INFORMACAOCOMPLEMENTAR:TEXT 
											cEstDUA	:= "ES" 
										EndIf 
 
										//Emissao do pedido 
										dEmissao	:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10)) 
 
										//Data de Entrega 
										dEntreg		:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10)) 
 
										//Tipo de Entrada/Saida 
										cTES        := GetMV("MV_XTESWEB",,"502") 
 
										//Produtos 
										If	Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO) <> "A" 
											XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO, "_PRODUTO" ) 
										EndIf 
 
										For nProd := 1 To Len(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO) 
 
											//Verifico se o produto é do tipo Combo, para pegar os itens do combo 
											If Empty(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODCOMBO:TEXT) 
												AADD(aProdutos, {	StrZero(nProd, TamSX3("C6_ITEM")[1]),;					//[1]Item 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPROD:TEXT,;		//[2]Codigo Produto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_QTD:TEXT,;			//[3]Quantidade 
												"",;		//[4]Valor Unitario 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLUNITARIO:TEXT,;	//[5]Valor com desconto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLTOTAL:TEXT,;		//[6]Valor Total 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPRODGAR:TEXT,;	//[7]Codigo Produto GAR 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODCOMBO:TEXT,;		//[8]Codigo Combo 
												dEntreg,;																	//[9]Data da Entrega 
												cTES,;																		//[10]TES 
												cNumvou,;																	//[11]Numero Voucher 
												nQtdVou,;																	//[12]Saldo Voucher 
												"",;																		//[13]Origem Venda 
												"",;																		//[14]Pedido de origem 
												"",;																		//[15] ID Prod no Pedido 
												""})																		//[16] ID de Origem caso combo com subestrutura 
 
												AADD(aProdPrin, {	StrZero(nProd, TamSX3("C6_ITEM")[1]),;					//[1]Item 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPROD:TEXT,;		//[2]Codigo Produto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_QTD:TEXT,;			//[3]Quantidade 
												"",;		//[4]Valor Unitario 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLUNITARIO:TEXT,;	//[5]Valor com desconto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLTOTAL:TEXT,;		//[6]Valor Total 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPRODGAR:TEXT,;	//[7]Codigo Produto GAR 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODCOMBO:TEXT,;		//[8]Codigo Combo 
												dEntreg,;																	//[9]Data da Entrega 
												cTES,;																		//[10]TES 
												cNumvou,;																	//[11]Numero Voucher 
												nQtdVou,;																	//[12]Saldo Voucher 
												"",;																		//[13]Origem Venda 
												"",;																		//[14]Pedido de origem 
												"",;																		//[15] ID Prod no Pedido 
												""})																		//[16] ID de Origem caso combo com subestrutura 
											Else 
												AADD(aProdPrin, {	StrZero(nProd, TamSX3("C6_ITEM")[1]),;					//[1]Item 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPROD:TEXT,;		//[2]Codigo Produto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_QTD:TEXT,;			//[3]Quantidade 
												"",;		//[4]Valor Unitario 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLUNITARIO:TEXT,;	//[5]Valor com desconto 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_VLTOTAL:TEXT,;		//[6]Valor Total 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODPRODGAR:TEXT,;	//[7]Codigo Produto GAR 
												oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_CODCOMBO:TEXT,;		//[8]Codigo Combo 
												dEntreg,;																	//[9]Data da Entrega 
												cTES,;																		//[10]TES 
												cNumvou,;																	//[11]Numero Voucher 
												nQtdVou,;																	//[12]Saldo Voucher 
												"",;																		//[13]Origem Venda 
												"",;																		//[14]Pedido de origem 
												"",;																		//[15] ID Prod no Pedido 
												""})																		//[16] ID de Origem caso combo com subestrutura 
 
												//Calculo de itens do combo 
												aProdutos := CalcDescCo( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd], ; 
												cNpSite, ; 
												nProd  , ; 
												dEntreg, ;  
												cTES   , ; 
												cNumvou, ; 
												nQtdVou ) 
 
												//Zero aProdPrin para não processar a validação está na CalcDescCo() 
												if len( aProdutos ) == 0 
													aAdd(aProdPrin, {} ) 
												endif 
 
											EndIf 
											cTabela1 := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd]:_TABELAPRECO:TEXT 
										Next nI 
 
										nTotPed := 0 
										If Len(aProdPrin) > 0 
											AEval( aProdPrin, { |x| nTotPed += IIF(ValType(x[3]) == "C",Val(x[3]),x[3]) * IIF(ValType(x[5]) == "C",Val(x[5]),x[5]) } ) 
										EndIf 
 
										If Empty(cTabela1) 
											cTabela1 := cTabela 
										EndIf 
 
										//Se a forma de pagamento for voucher, faco as devidas validacoes 
										If lChkVou  //Somente se Emissor do Voucher for ERP protheus (1) 
											//Carrego dados do Voucher 
											oVoucher :=	CSVoucherPV():New( cID, cNpSite, cPedLog, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[ nPed ], cPedGar ) 
											 
											//Valido o Voucher 
											aRVou := U_VNDA430( @oVoucher ) 
 
											//+----------------------------------------------------------------------------------+ 
											//| Caso o retorno da validacao do voucher seja verdadeira, faco a movimentacao      | 
											//+----------------------------------------------------------------------------------+ 
											If oVoucher:voucherValido 
												//+----------------------------------------------------------------------------------+ 
												//| Renato Ruy - 08/06/2016                                                          | 
												//| Ajusta estrutura para gravar na SZG conforme descrição abaixo.                   | 
												//| Conforme Solicitação Giovanni, não grava no VNDA310 o código do Pedido Protheus. | 
												//+----------------------------------------------------------------------------------+ 
												U_VNDA310( oVoucher ) 
												lContinue := .T. 
											Else 
												U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00017",cPedLog,"Foram Encontradas Inconsistências Processamento de Voucher:"+CRLF+oVoucher:mensagem}},cNpSite) 
 
												cUpdPed := "UPDATE GTIN " 
												cUpdPed += "SET GT_SEND = 'T' " 
												cUpdPed += "WHERE GT_ID = '" + cID + "' " 
												cUpdPed += "  AND GT_TYPE = 'F' " 
												cUpdPed += "  AND GT_SEND = 'F' " 
												cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
												cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
												TCSqlExec(cUpdPed) 
 
												lContinue := .F. 
											EndIf 
										Else 
											lContinue := .T. 
										EndIf 
 
										If lContinue 
											//				Local oXmlPst	:= nil 
											oXmlPst	:= XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed],"_POSTO") 
 
											//Dados do Posto 
											If (cOriVen == "2" .Or. cOriVen == "15") .AND. ValType(oXmlPst) <> 'U' 
												cPosNom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_NOME:TEXT							//Nome do Posto 
												cPosEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_DESC:TEXT				//Endereco Posto 
												cPosBai	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_BAIRRO:TEXT				//Bairro Posto 
												cPosCom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_COMPL:TEXT				//Complemento Posto 
												cPosCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CEP:TEXT				//Cep Posto 
												cPosFon	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_FONE:TEXT				//Fone Posto 
												cPosCid	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_NOME:TEXT		//Nome da cidade do Posto 
												cPosUf	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT	//UF do Posto 
												cPosCGC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CNPJ:TEXT							//CGC Posto 
												cPosGAR	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CODGAR:TEXT						//Codigo do GAR 
											Else 
												cPosNom	:= ""	//Nome do Posto 
												cPosEnd	:= ""	//Endereco Posto 
												cPosBai	:= ""	//Bairro Posto 
												cPosCom	:= ""	//Complemento Posto 
												cPosCep	:= ""	//Cep Posto 
												cPosFon	:= ""	//Fone Posto 
												cPosCid	:= ""	//Nome da cidade do Posto 
												cPosUf	:= ""	//UF do Posto 
												cPosCGC	:= ""	//CGC Posto 
												cPosGAR	:= ""	//Codigo do GAR 
											EndIf 
 
											//Quando é voucher não calcula desconto. 
											aParam := {	3,cTipo,cCliente,cLjCli,cTpCli,cForPag,dEmissao,cPosGAR,cPosLoj,cForPag,cNumCart,cNomTit,cCodSeg,; 
											cDtVali,cParcela,cTipCar,cNpSite,cLinDig,cNumvou,nQtdVou,cTabela1,cOriVen,cPedGar,aRVou,lEntrega,; 
											nVlrFret,cPedLog,nTotPed,cServEnt,cTipShop,cPedOrigem,cCodDUA,cCGCDUA,cMunDUA,cObsDUA,cEstDUA, cProtocolo,; 
											cDocCar,cDocAut,cCodConf,cOriVou,cCodRev} 
 
											lPed := Iif(lChkVou , oVoucher:geraPedidoProtheus, .T.) 
 
											If lPed 
												nTime 	 := Seconds() 
												lNotexit := .T. 
												While lNotexit 
													//If U_Send2Proc(cID,"U_VNDA260",aParam,aProdutos,lPed) 
													if U_VNDA260(cId,aParam,aProdutos)[1] 
														//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
 
														cUpdPed := "UPDATE GTIN " 
														cUpdPed += "SET GT_SEND = 'T' " 
														cUpdPed += "WHERE GT_ID = '" + cID + "' " 
														cUpdPed += "  AND GT_TYPE = 'F' " 
														cUpdPed += "  AND GT_SEND = 'F' " 
														cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
														cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
														TCSqlExec(cUpdPed) 
														U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Fila do pedido " + cPedLog + " distribuida com sucesso."}},cNpSite) 
 
														lNotexit := .F. 
													Else 
 
														nWait := Seconds()-nTime 
														If nWait < 0 
															nWait += 86400 
														Endif 
 
														If nWait > 10 
															// Passou de 2 minutos tentando ? Desiste ! 
 
															// Solta o lock do processo deste item 
															UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
 
															U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00002",cPedLog,"Fila do pedido " + cPedLog + " Nao pode ser Distribuida."}},cNpSite) 
 
															cSql := " UPDATE GTOUT SET GT_SEND = 'F' WHERE GT_TYPE = 'F' AND GT_CODMSG = 'E00002' AND  GT_PEDGAR =  '"+AllTrim(QRYGT->GT_PEDGAR)+"' " 
 
															TcSqlExec(cSql) 
 
															lNotexit := .F. 
 
															//Renato Ruy - 23/01/2018 
															//Retorna saldo do voucher quando tem problema ao enviar para processamento 
															If !Empty(cNumvou) 
 
																SZF->(DbSetOrder(2)) 
																If SZF->(DbSeek(xFilial("SZF")+cNumvou)) 
																	RecLock("SZF",.F.) 
																	SZF->ZF_SALDO := nQtdVou 
																	SZF->(MsUnlock()) 
																Endif 
 
																SZG->(DbSetOrder(1)) 
																If SZG->(DbSeek(xFilial("SZG")+cPedGar)) 
																	RecLock("SZG",.F.) 
																	SZG->(DbDelete()) 
																	SZG->(MsUnlock()) 
																Endif 
 															Endif 
 														Endif 
 
														// Espera um pouco ( 5 segundos ) para tentar novamente 
 														Sleep(5000) 
													EndIf 
												EndDo 
											Else //#1 Mesmo nao incluindo o pedido por conta do tipo de Voucher atualiza a tabela GTIN 
 
												U_GTPutIN(cID,"P",cPedLog,.T.,{"EXECUTAPEDIDOS",cPedLog,"Pedido Referente a Voucher que nao gera pedido.",aParam,aProdutos},cNpSite,{cNumCart,alltrim(cLinDig),cNumvou}) 
												/* 
												//26/09/2012 - Retirada de envio de Notificação ao gar devido Solicitação do Sr. GIovanni 
												//que solicitou a implantação do envio no HUB de Mensagens 
												If !Empty(cPedGar) 
												aVouch := {cCliente,cLjCli,cPedGar,cNpSite,nTotPed} 
												U_VNDA481(nil,nil,"Pedido Liberado mediante Voucher "+cNumvou,aVouch) 
 
												EndIf 
												*/ 
												cUpdPed := "UPDATE GTIN " 
												cUpdPed += "SET GT_SEND = 'T' " 
												cUpdPed += "WHERE GT_ID = '" + cID + "' " 
												cUpdPed += "  AND GT_TYPE = 'F' " 
												cUpdPed += "  AND GT_SEND = 'F' " 
												cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
												cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
												TCSqlExec(cUpdPed) 
 
												U_GTPutOUT(cID,"P",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Nao foi necessario incluir o Pedido"}},cNpSite) 
 
												U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Fila do pedido " + cPedLog + " nao Precisa ser executada devido Tipo de Pagamento Voucher."}},cNpSite) 
 
												// Solta o lock do processo deste item 
												UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
 
											Endif 
										EndIf 
									Else 
										U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00001",cPedLog,"Foram Encontradas Inconsistências Processamento do Cliente:"+CRLF+aRetCl[2]}},cNpSite) 
 
										cUpdPed := "UPDATE GTIN " 
										cUpdPed += "SET GT_SEND = 'T' " 
										cUpdPed += "WHERE GT_ID = '" + cID + "' " 
										cUpdPed += "  AND GT_TYPE = 'F' " 
										cUpdPed += "  AND GT_SEND = 'F' " 
										cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
										cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
										TCSqlExec(cUpdPed) 
 
										// Solta o lock do processo deste item 
										UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
									EndIf 
								Else 
									U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Pedido Ja existe no Sistema Protheus"}},cNpSite) 
 
									cUpdPed := "UPDATE GTIN " 
									cUpdPed += "SET GT_SEND = 'T' " 
									cUpdPed += "WHERE GT_ID = '" + cID + "' " 
									cUpdPed += "  AND GT_TYPE = 'F' " 
									cUpdPed += "  AND GT_SEND = 'F' " 
									cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
									cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
									TCSqlExec(cUpdPed) 
 
									// Solta o lock do processo deste item 
									UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
 
								EndIf 
 
							RECOVER 
							 
								ErrorBlock(bOldBlock) 
	 
								cErrorMsg := U_GetProcError() 
	 
								If !empty(cErrorMsg) 
									U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na geração do Pedido"+CRLF+cErrorMsg}},cNpSite) 
	 
									cUpdPed := "UPDATE GTIN " 
									cUpdPed += "SET GT_SEND = 'T' " 
									cUpdPed += "WHERE GT_ID = '" + cID + "' " 
									cUpdPed += "  AND GT_TYPE = 'F' " 
									cUpdPed += "  AND GT_SEND = 'F' " 
									cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
									cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
	 
									TCSqlExec(cUpdPed) 
								Endif 
 
							END SEQUENCE 
 
							If InTransact() 
								// Esqueceram transacao aberta ... Fecha fazendo commit ... 
								msgCon("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***") 
								EndTran() 
							Endif 
 						Else 
							U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na geração do Pedido"+CRLF+"LockByName em [" + AllTrim( cNpSite ) + "] - Altere GT_SEND e GT_INPROC se necessário."}},cNpSite) 
							U_GTPutPRO(cID) 
						Endif 
					Else 
 
						U_GTPutOUT(cID,"F",AllTrim(QRYGT->GT_PEDGAR),{"EXECUTAPEDIDOS",{.F.,"E00019",AllTrim(QRYGT->GT_PEDGAR),"Inconsistência na geração do Pedido"+CRLF+"Pedido do XML não é o posicionado na Tabela Gtin"}},AllTrim(QRYGT->GT_PEDGAR)) 
 
					EndIf 
				ELSE 
					//(TSM David - 10/01/19) Novo fluxo com informações por item 
					cPedLog := cNpSite 
 
					cCodRev  := ""				 
					//-- Recupera o código de Revenda do XML 
					If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_CODREV:TEXT") <> "U" 
						cCodRev  := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CODREV:TEXT) 
					EndIf 
 
					cProtocolo := '' 
					IF ValType( XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed], "_PROTOCOLO") ) == 'O' 
						cProtocolo := Alltrim( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PROTOCOLO:TEXT ) 
					EndIF 
 
					cEcommerce := '' 
					IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PEDIDOECOMMERCE:TEXT") <> "U" 
						cEcommerce := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PEDIDOECOMMERCE:TEXT) 
					EndIF 
 
					cCupomDesc := '' 
					IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_CUPOMDESCONTO:TEXT") <> "U" 
						cCupomDesc := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CUPOMDESCONTO:TEXT) 
					EndIF 
 
					nValBruto := 0 
					IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_VALORBRUTO:TEXT") <> "U" 
						nValBruto := Val( AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_VALORBRUTO:TEXT) ) 
					EndIF 
 
					cValLiq := '' 
					IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_VALORLIQUIDO:TEXT") <> "U" 
						cValLiq := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_VALORLIQUIDO:TEXT) 
					EndIF 
 
					nValDesc := 0 
					IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_VALORDESCONTO:TEXT") <> "U" 
						nValDesc := Val( AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_VALORDESCONTO:TEXT) ) 
					EndIF 
 
					cUpdPed := "UPDATE GTIN " 
					cUpdPed += "SET GT_SEND = 'T' " 
					cUpdPed += "WHERE GT_ID = '" + cID + "' " 
					cUpdPed += "  AND GT_TYPE = 'F' " 
					cUpdPed += "  AND GT_SEND = 'F' " 
					cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
					cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
					TCSqlExec(cUpdPed) 
 
					//Semaforo para controle de processamento de pedido 
					If LockByName(cNpSite,.F.,.F.) 
 
						//TRATAMENTO PARA ERRO FATAL NA THREAD 
						cErrorMsg := "" 
						bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
 
						BEGIN SEQUENCE 
 
							If Select("QRYSC5") > 0 
								DbSelectArea("QRYSC5") 
								QRYSC5->(DbCloseArea()) 
							EndIf 
 
							cQrySC5 := "SELECT COUNT(*) NCONT " 
							cQrySC5 += "FROM " + RetSqlName("SC5") + " " 
							cQrySC5 += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' " 
							cQrySC5 += "  AND C5_XNPSITE = '" + cNpSite + "' " 
							cQrySC5 += "  AND D_E_L_E_T_ = ' '" 
 
							cQrySC5 := ChangeQuery(cQrySC5) 
 
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.) 
							DbSelectArea("QRYSC5") 
 
							lPedExist := QRYSC5->NCONT > 0 
 
							DbSelectArea("QRYSC5") 
							QRYSC5->(DbCloseArea()) 
 
							//Verifica se pedido existe na tabela Z11-DUA 
							If !lPedExist 
								If Select("QRYZ11") > 0 
									DbSelectArea("QRYZ11") 
									QRYZ11->(DbCloseArea()) 
								EndIf 
 
								cQryZ11 := "SELECT COUNT(*) NCONT " 
								cQryZ11 += "FROM " + RetSqlName("Z11") + " " 
								cQryZ11 += "WHERE Z11_FILIAL = '" + xFilial("Z11") + "' " 
								cQryZ11 += "  AND Z11_PEDSIT = '" + cNpSite + "' " 
								cQryZ11 += "  AND D_E_L_E_T_ = ' '" 
 
								cQryZ11 := ChangeQuery(cQryZ11) 
 
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryZ11),"QRYZ11",.F.,.T.) 
								DbSelectArea("QRYZ11") 
 
								lPedExist := QRYZ11->NCONT > 0 
 
								DbSelectArea("QRYZ11") 
								QRYZ11->(DbCloseArea()) 
							EndIf 
 
							If !lPedExist 
 
								cEmailC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT 
								cNomeC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT 
								cCpfC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT 
								cSenhaC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_SENHA:TEXT 
								cFoneC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT 
 
								aDados := {cNomeC, cCpfC, cEmailC, cSenhaC, cFoneC} 
 
								aRetCo := U_VNDA120(cCpfC, aDados,cNpSite,cID,nil,cPedLog) //#1 passado o numero do pedido 
 
								cInEst	:= "" 
								cInMun	:= "" 
								cSufra	:= "" 
 
								oXmlEntg	:= XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed],"_ENTREGA") 
 
								If ValType(oXmlEntg) <> 'U' 
									nVlrFret 	:= Val(oXmlEntg:_VALOR:TEXT) 
									cServEnt	:= PadL(AllTrim(Str(Val(oXmlEntg:_SERVICO:TEXT))),5,"0") 
									cNomServEnt	:= oXmlEntg:_NOMESERVICO:TEXT 
									cEndEnt		:= oXmlEntg:_ENDERECO:_DESC:TEXT 
									cBaiEnt		:= oXmlEntg:_ENDERECO:_BAIRRO:TEXT 
									cNumEnt		:= oXmlEntg:_ENDERECO:_NUMERO:TEXT 
									cComEnt		:= oXmlEntg:_ENDERECO:_COMPL:TEXT 
									cCepEnt		:= oXmlEntg:_ENDERECO:_CEP:TEXT 
									cCidEnt		:= oXmlEntg:_ENDERECO:_CIDADE:_NOME:TEXT 
									cUfEnt		:= oXmlEntg:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
									cIbge		:= oXmlEntg:_ENDERECO:_CODIGOIBGE:TEXT 
									lEntrega 	:= vldServEnt( cNomServEnt ) 
 
									aDadEnt := {cEndEnt, cBaiEnt, cNumEnt, cComEnt, cCepEnt, cCidEnt, cUfEnt, cIbge } 
 
									DbSelectArea("SA4") 
									SA4->(dbSetOrder(1)) // A1_FILIAL + A1_COD
									
									// Tenta encontrar o próximo SXE disponível para o cadastro da transportador
									cCodTransp := GetSXENum("SA4", "A4_COD")
									While SA4->(dbSeek(xFilial("SA4") + cCodTransp))
										ConfirmSX8()
										cCodTransp := GetSXENum("SA4", "A4_COD")
									EndDo

									// Grava a transportadora, a partir do código de serviço
									SA4->(dbOrderNickNAme('SA4_4') )  // A1_FILIAL + A1_XCODCOR
									If !SA4->(DbSeek(xFilial("SA4")+cServEnt)) 
										SA4->(Reclock("SA4",.T.)) 
											SA4->A4_COD		:= cCodTransp
											SA4->A4_NOME	:= cNomServEnt 
											SA4->A4_NREDUZ	:= cNomServEnt 
											SA4->A4_VIA		:= "MULTIMODAL" 
											SA4->A4_ESTFIS	:= "000001" 
											SA4->A4_ENDPAD	:= "PADRAO" 
											SA4->A4_LOCAL	:= "01" 
											SA4->A4_XCODCOR	:= cServEnt 
											SA4->A4_CODPAIS	:= "01058" 
											SA4->A4_COD_MUN	:= "50308" 
											SA4->A4_TPTRANS	:= "1" 
											ConfirmSX8()
										SA4->(MsUnlock())
									EndIf 
 
								Else 
									lEntrega := .F. 
									nVlrFret := 0 
									cServEnt := "" 
									aDadEnt := {"", "", "", "", "", "", "", ""} 
								EndIf 
 
								If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_XSI_TYPE:TEXT") <> "U" 
									//Verifico se eh pessoa fisica ou juridica, pois a informacao eh passada de maneira diferente no XML 
									If "PF" $ oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_XSI_TYPE:TEXT 
										cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CPF:TEXT 
										cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT 
										cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_NOME:TEXT 
										cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + "," + oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT 
										cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT 
										cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 
										cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT 
										cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8) 
										cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2) 
										cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 
										cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
										//Renato Ruy - 14/11/2017 
										//Adiciona o codigo do IBGE 
										If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT") <> "U" 
											cIbge	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT 
										Endif 
										cLograd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT 
										cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT 
										cPessoa	:= "F" 
									Else 
										cCgc	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_CNPJ:TEXT 
										cNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT 
										cNReduz	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_RZSOCIAL:TEXT 
										cEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT + "," +oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_NUMERO:TEXT 
										cCompl	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_COMPL:TEXT 
										cCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CEP:TEXT 
										cBairro	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_BAIRRO:TEXT 
										cFone	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 3, 8) 
										cDDD	:= SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_FONE:TEXT, 1, 2) 
										cUfNome	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_NOME:TEXT 
										cUf		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT 
										//Renato Ruy - 14/11/2017 
										//Adiciona o codigo do IBGE 
										If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT") <> "U" 
											cIbge	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_CODIGOIBGE:TEXT 
										Endif 
										cLograd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_ENDERECO:_DESC:TEXT 
										cInEst	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCEST:TEXT 
										cInMun	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_INSCMUN:TEXT 
										cSufra	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_SUFRAMA:TEXT 
										cEmail	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_FATURA:_EMAIL:TEXT 
										cPessoa	:= "J" 
									EndIf 
 
									cInEst	:= iif(Empty(cInEst),"ISENTO",ALLTRIM(cInEst)) 
									cInMun	:= iif(Empty(cInMun),"ISENTO",ALLTRIM(cInMun)) 
 
									DbSelectArea("SA1") 
									DbSetOrder(3) //A1_FILIAL + A1_CGC 
									If !DbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc)) 
 
										//Renato Ruy - 07/07/2017 
										//Por causa do processamento em threads, dois clientes tentavam ser criados com o mesmo codigo 
										//Efetua 5 tentativas para reservar o codigo do cliente 
										nTentativa := 0 
										lCliente   := .F. 
										While !lCliente .And. nTentativa < 10 
											sleep(Randomize( 1000, 5000 )) 
											cCliente := GetSXENum('SA1','A1_COD') 
											lCliente := LockByName("CLIENTE-"+cCliente) 
											nTentativa++ 
										Enddo 
 
										cLjCli		:= "01" 
										cTpCli		:= "F"	//Consumidor final 
										nOpc 		:= 3 
 
										If lCliente 
 
											//Destrava antes de executar a execAuto e grava a sequencia 
											SA1->(ConfirmSX8()) 
											UnLockByName("CLIENTE-"+cCliente) 
 
											aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra,cNpSite,cID,aDadEnt,cPedLog,cIbge,cLograd) 
										Else 
											aRetCl := {.F.,"não foi possível reservar o numero para gerar o cadastro do cliente!"} 
										Endif 
 
									Else 
										cCliente	:= SA1->A1_COD 
										cLjCli		:= SA1->A1_LOJA 
										cTpCli		:= SA1->A1_TIPO 
 
										nOpc 		:= 4 
 
										aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cUfNome,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,cSufra,cNpSite,cID,aDadEnt,cPedLog,cIbge,cLograd) 
 
									EndIf 
 
									If aRetCl[1] 
										//Cliente 
										cCliente	:= SA1->A1_COD 
										cLjCli		:= SA1->A1_LOJA 
										cTpCli		:= SA1->A1_TIPO 
 
										U_VNDA100("SA1", cCliente, cLjCli, cContSite) 
									EndIf 
 
								Else 
									aRetCl := {.T.} 
								EndIf 
 
								If aRetCl[1] 
 
									//Zero as variaveis das formas de pagamento, para pegar a proxima 
									cNumCart	:= "" 
									cNomTit		:= "" 
									cCodSeg		:= "" 
									cDtVali		:= "" 
									cParcela	:= "" 
									cTipCar		:= " " 
									cLinDig		:= "" 
									lChkVou		:= .F. 
									aRVou		:= {.T.,""} 
									cNumvou		:= "" 
									nQtdVou		:= 0 
									cTipShop	:= "0" 
									cCodDUA		:= "" 
									cCGCDUA		:= "" 
									cMunDUA		:= "" 
									cObsDUA		:= "" 
									cEstDUA		:= "ES" 
									cDocCar 	:= '' 
									cDocAut 	:= '' 
									cCodConf	:= '' 
									cOriVou 	:= '1' //Emissor Voucher ERP Protheus(1)  -- Usado para diferenciar emissor Voucher Sage(2) 
									cForPag		:= '' 
 
									IF Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_XSI_TYPE:TEXT") <> "U" 
										//Forma de Pagamento 
										If "cartao" $ (oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT) 
											cForPag		:= "2" 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_NUMERO:TEXT") <> "U" 
												cNumCart	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT 
											EndIf 
											cNomTit		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NMTITULAR:TEXT 
											cCodSeg		:= ""//oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CODSEG:TEXT 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_DTVALID:TEXT") <> "U" 
												cDtVali		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DTVALID:TEXT 
											EndIf 
 
											cParcela	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_PARCELAS:TEXT 
											cTipCar		:= Alltrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_TIPO:TEXT) 
 
											If cTipCar == "9" .or. cTipCar == "10" 
												cForPag := "3" 
											EndIf 
 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_DOCUMENTO:TEXT") <> "U" 
												cDocCar := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_DOCUMENTO:TEXT 
											Endif 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_AUTORIZACAO:TEXT") <> "U" 
												cDocAut := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_AUTORIZACAO:TEXT 
											Endif 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_CONFIRMACAO:TEXT") <> "U" 
												cCodConf:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CONFIRMACAO:TEXT 
											Endif 
 
										ElseIf "boleto" $ (oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT) 
											cForPag		:= "1" 
											cLinDig		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_LINHADIGITAVEL:TEXT 
										ElseIf "voucher" $ (oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT) 
											lChkVou		:= .T. 
											cForPag		:= "6" 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_NUMERO:TEXT") <> "U" 
												cNumvou		:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERO:TEXT 
											EndIf 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_QTCONSUMIDA:TEXT") <> "U" 
												nQtdVou		:= Val(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_QTCONSUMIDA:TEXT) 
											EndIf 
											//Tratamento para Voucher SAGE 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_EMISSOR:TEXT") <> "U" 
												cOriVou := oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_EMISSOR:TEXT 
												if cOriVou=='2' //Emissor Voucher SAGE 
													// não se faz necessário chegagem do voucher pois não foi gerado pelo ERP Protheus 
													lChkVou	:= .F. 
													// Gravo dados do contato nas variáveis de DUA/SAGE para atualização da Z11 
													cEmailC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_EMAIL:TEXT 
													cNomeC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_NOME:TEXT 
													cCpfC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_CPF:TEXT 
													cFoneC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_CONTATO:_FONE:TEXT 
													cCGCDUA	:= cCpfC 
													cObsDUA	:= "Nome;"+cNomeC+";Email;"+cEmailC +";Fone;"+cFoneC 
												Endif 
											Endif 
										ElseIf "debito" $ (oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT) 
											cForPag		:= "7" //Shopline 
											If Type("oXml:_LISTPEDIDOFULLTYPE:_PEDIDO["+Str(nPed)+"]:_PAGAMENTO:_TIPO:TEXT") <> "U" 
												cTipShop    := Alltrim(Str(aScan(__Shop,{|x| x == oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_TIPO:TEXT }))) 
											EndIf 
 
											If cTipShop $ "4,5" 
												cForPag := "4" 
											EndIf 
										ElseIf "dua" $ (oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_XSI_TYPE:TEXT) 
											cForPag	:= "8" //DUA - Prodest 
											cCodDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_NUMERODUA:TEXT 
											cCGCDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CPFCNPJ:TEXT 
											cMunDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_CODIGOMUNICIPIO:TEXT 
											cObsDUA	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PAGAMENTO:_INFORMACAOCOMPLEMENTAR:TEXT 
											cEstDUA	:= "ES" 
										EndIf 
									EndIF 
 
									//Emissao do pedido 
									dEmissao	:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10)) 
 
									//Data de Entrega 
									dEntreg		:= CtoD(SubStr(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_DATA:TEXT,1,10)) 
 
									//Tipo de Entrada/Saida 
									cTES        := GetMV("MV_XTESWEB",,"502") 
 
									//Produtos 
									If	Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO) <> "A" 
										XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO, "_PRODUTO" ) 
									EndIf 
									nTotPed := 0 
 
									oCombo	:= Combo():XmlBProd(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO, dEntreg, cNumvou, nQtdVou, cOriVen, cPedLog, cEcommerce, cCupomDesc) 
									IF oCombo:lRetorno 
										aProdutos 	:= oCombo:aProduto 
										nTotPed		:= oCombo:nValor 
										cTabela1	:= oCombo:tabelaPreco 
 
										IF nValBruto == 0 
											nValBruto := nTotPed 
										EndIF 
 
										If Empty(cTabela1) 
											cTabela1 := cTabela 
										EndIf 
 
										//Se a forma de pagamento for voucher, faco as devidas validacoes 
										If lChkVou 
											//Carrego dados do Voucher 
											oVoucher := CSVoucherPV():New( cID, cNpSite, cPedLog, oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed], cPedGar ) 
											 
											//Valido o Voucher 
											aRVou    := U_VNDA430( @oVoucher ) 
 
											If oVoucher:voucherValido 
												U_VNDA310( oVoucher ) 
												lContinue := .T.												 
											Else 
												U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00017",cPedLog,"Foram Encontradas Inconsistências Processamento de Voucher:"+CRLF+oVoucher:mensagem}},cNpSite) 
 
												cUpdPed := "UPDATE GTIN " 
												cUpdPed += "SET GT_SEND = 'T' " 
												cUpdPed += "WHERE GT_ID = '" + cID + "' " 
												cUpdPed += "  AND GT_TYPE = 'F' " 
												cUpdPed += "  AND GT_SEND = 'F' " 
												cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
												cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
												TCSqlExec(cUpdPed) 
 
												lContinue := .F. 
											EndIf 
										Else 
											lContinue := .T. 
										EndIF 
 
										If lContinue 
											oXmlPst	:= XmlChildEx(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed],"_POSTO") 
 
											//Dados do Posto 
											If (cOriVen == "2" .Or. cOriVen == "15") .AND. ValType(oXmlPst) <> 'U' 
												cPosNom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_NOME:TEXT							//Nome do Posto 
												cPosEnd	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_DESC:TEXT				//Endereco Posto 
												cPosBai	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_BAIRRO:TEXT				//Bairro Posto 
												cPosCom	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_COMPL:TEXT				//Complemento Posto 
												cPosCep	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CEP:TEXT				//Cep Posto 
												cPosFon	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_FONE:TEXT				//Fone Posto 
												cPosCid	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_NOME:TEXT		//Nome da cidade do Posto 
												cPosUf	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_ENDERECO:_CIDADE:_UF:_SIGLA:TEXT	//UF do Posto 
												cPosCGC	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CNPJ:TEXT							//CGC Posto 
												cPosGAR	:= oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_POSTO:_CODGAR:TEXT						//Codigo do GAR 
											Else 
												cPosNom	:= ""	//Nome do Posto 
												cPosEnd	:= ""	//Endereco Posto 
												cPosBai	:= ""	//Bairro Posto 
												cPosCom	:= ""	//Complemento Posto 
												cPosCep	:= ""	//Cep Posto 
												cPosFon	:= ""	//Fone Posto 
												cPosCid	:= ""	//Nome da cidade do Posto 
												cPosUf	:= ""	//UF do Posto 
												cPosCGC	:= ""	//CGC Posto 
												cPosGAR	:= ""	//Codigo do GAR 
											EndIf 
 
											//Reordena o array de produtos para que o pedido seja criado agrupando os produtos por kits 
											If cOriVen == '14' 
												aProdutos := aSort(aProdutos,,, { |x, y| x[15]+x[16]+x[2] < y[15]+y[16]+y[2] }) 
												nItem := 0  
												aEval(aProdutos,{|x| nItem++, x[1] := StrZero(nItem, TamSX3("C6_ITEM")[1]) }) 
											Endif 
 
											aParam := {	3,;	//-- [01]  
											cTipo,;      	//-- [02]  
											cCliente,;   	//-- [03]  
											cLjCli,;     	//-- [04]  
											cTpCli,;     	//-- [05]  
											cForPag,;    	//-- [06]  
											dEmissao,;   	//-- [07]  
											cPosGAR,;    	//-- [08]  
											cPosLoj,;    	//-- [09]  
											cForPag,;    	//-- [10] 
											cNumCart,;   	//-- [11] 
											cNomTit,;    	//-- [12] 
											cCodSeg,;    	//-- [13] 
											cDtVali,;    	//-- [14] 
											cParcela,;   	//-- [15] 
											cTipCar,;    	//-- [16] 
											cNpSite,;    	//-- [17] 
											cLinDig,;    	//-- [18] 
											cNumvou,;    	//-- [19] 
											nQtdVou,;    	//-- [20] 
											cTabela1,;   	//-- [21] 
											cOriVen,;    	//-- [22] 
											cPedGar,;    	//-- [23] 
											aRVou,;      	//-- [24] 
											lEntrega,;   	//-- [25] 
											nVlrFret,;   	//-- [26] 
											cPedLog,;    	//-- [27] 
											nTotPed,;    	//-- [28] 
											cServEnt,;   	//-- [29] 
											cTipShop,;   	//-- [30] 
											cPedOrigem,; 	//-- [31] 
											cCodDUA,;    	//-- [32] 
											cCGCDUA,;    	//-- [33] 
											cMunDUA,;    	//-- [34] 
											cObsDUA,;    	//-- [35] 
											cEstDUA,;    	//-- [36] 
											cProtocolo,; 	//-- [37] 
											cDocCar,;    	//-- [38] 
											cDocAut,;    	//-- [39] 
											cCodConf,;   	//-- [40] 
											cOriVou,;    	//-- [41] 
											cCodRev,;    	//-- [42] 
											cEcommerce,; 	//-- [43] 
											cCupomDesc,; 	//-- [44] 
											nValBruto,;		//-- [45] 
											nValDesc}		//-- [46] 
 
											lPed := Iif(lChkVou , oVoucher:geraPedidoProtheus, .T.) 
 
											IF lPed 
												nTime 	 := Seconds() 
												lNotexit := .T. 
												While lNotexit 
													//If U_Send2Proc(cID,"U_VNDA260",aParam,aProdutos) 
													if U_VNDA260(cId,aParam,aProdutos)[1] 
														//Chama a funcao que faz a inclusao do pedido no sistema Protheus 
 
														cUpdPed := "UPDATE GTIN " 
														cUpdPed += "SET GT_SEND = 'T' " 
														cUpdPed += "WHERE GT_ID = '" + cID + "' " 
														cUpdPed += "  AND GT_TYPE = 'F' " 
														cUpdPed += "  AND GT_SEND = 'F' " 
														cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
														cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
														TCSqlExec(cUpdPed) 
														U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Fila do pedido " + cPedLog + " distribuida com sucesso."}},cNpSite) 
 
														lNotexit := .F. 
													Else 
 
														nWait := Seconds()-nTime 
														If nWait < 0 
															nWait += 86400 
														Endif 
 
														If nWait > 10 
															// Passou de 2 minutos tentando ? Desiste ! 
 
															// Solta o lock do processo deste item 
															UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
 
															U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00002",cPedLog,"Fila do pedido " + cPedLog + " Nao pode ser Distribuida."}},cNpSite) 
 
															cSql := " UPDATE GTOUT SET GT_SEND = 'F' WHERE GT_TYPE = 'F' AND GT_CODMSG = 'E00002' AND  GT_PEDGAR =  '"+AllTrim(QRYGT->GT_PEDGAR)+"' " 
 
															TcSqlExec(cSql) 
 
															lNotexit := .F. 
 
															//Renato Ruy - 23/01/2018 
															//Retorna saldo do voucher quando tem problema ao enviar para processamento 
															If !Empty(cNumvou) 
 
																SZF->(DbSetOrder(2)) 
																If SZF->(DbSeek(xFilial("SZF")+cNumvou)) 
																	RecLock("SZF",.F.) 
																	SZF->ZF_SALDO := nQtdVou 
																	SZF->(MsUnlock()) 
																Endif 
 
																SZG->(DbSetOrder(1)) 
																If SZG->(DbSeek(xFilial("SZG")+cPedGar)) 
																	RecLock("SZG",.F.) 
																	SZG->(DbDelete()) 
																	SZG->(MsUnlock()) 
																Endif												 
 															Endif													 
														Endif 
														Sleep(5000) 
													EndIf 
												EndDo 
											Else 
												//#1 Mesmo nao incluindo o pedido por conta do tipo de Voucher atualiza a tabela GTIN 
												U_GTPutIN(cID,"P",cPedLog,.T.,{"EXECUTAPEDIDOS",cPedLog,"Pedido Referente a Voucher que nao gera pedido.",aParam,aProdutos},cNpSite,{cNumCart,alltrim(cLinDig),cNumvou}) 
 
												cUpdPed := "UPDATE GTIN " 
												cUpdPed += "SET GT_SEND = 'T' " 
												cUpdPed += "WHERE GT_ID = '" + cID + "' " 
												cUpdPed += "  AND GT_TYPE = 'F' " 
												cUpdPed += "  AND GT_SEND = 'F' " 
												cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
												cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
												TCSqlExec(cUpdPed) 
 
												U_GTPutOUT(cID,"P",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Nao foi necessario incluir o Pedido"}},cNpSite) 
 
												U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Fila do pedido " + cPedLog + " nao Precisa ser executada devido Tipo de Pagamento Voucher."}},cNpSite) 
 
												// Solta o lock do processo deste item 
												UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite)										 
											EndIF									 
										EndIf 
									Else 
										cErrorMsg := oCombo:cMsgRetorno 
										U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na geração do Pedido"+CRLF+cErrorMsg}},cNpSite,cEcommerce) 
 
										cUpdPed := "UPDATE GTIN " 
										cUpdPed += "SET GT_SEND = 'T' " 
										cUpdPed += "WHERE GT_ID = '" + cID + "' " 
										cUpdPed += "  AND GT_TYPE = 'F' " 
										cUpdPed += "  AND GT_SEND = 'F' " 
										cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
										cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
										TCSqlExec(cUpdPed) 
 
										// Solta o lock do processo deste item 
										UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
									EndIF 
								Else 
									U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00001",cPedLog,"Foram Encontradas Inconsistências Processamento do Cliente:"+CRLF+aRetCl[2]}},cNpSite) 
 
									cUpdPed := "UPDATE GTIN " 
									cUpdPed += "SET GT_SEND = 'T' " 
									cUpdPed += "WHERE GT_ID = '" + cID + "' " 
									cUpdPed += "  AND GT_TYPE = 'F' " 
									cUpdPed += "  AND GT_SEND = 'F' " 
									cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
									cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
									TCSqlExec(cUpdPed) 
 
									// Solta o lock do processo deste item 
									UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
								EndIf 
							Else 
								U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.T.,"M00001",cPedLog,"Pedido Ja existe no Sistema Protheus"}},cNpSite) 
 
								cUpdPed := "UPDATE GTIN " 
								cUpdPed += "SET GT_SEND = 'T' " 
								cUpdPed += "WHERE GT_ID = '" + cID + "' " 
								cUpdPed += "  AND GT_TYPE = 'F' " 
								cUpdPed += "  AND GT_SEND = 'F' " 
								cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
								cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
								TCSqlExec(cUpdPed) 
 
								// Solta o lock do processo deste item 
								UnLockByName(cNpSite,.F.,.F.)//U_GarUnlock(cNpSite) 
 
							EndIf 
						RECOVER 
							ErrorBlock(bOldBlock) 
	 
							cErrorMsg := U_GetProcError() 
	 
							If !empty(cErrorMsg) 
								U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na geração do Pedido"+CRLF+cErrorMsg}},cNpSite) 
	 
								cUpdPed := "UPDATE GTIN " 
								cUpdPed += "SET GT_SEND = 'T' " 
								cUpdPed += "WHERE GT_ID = '" + cID + "' " 
								cUpdPed += "  AND GT_TYPE = 'F' " 
								cUpdPed += "  AND GT_SEND = 'F' " 
								cUpdPed += "  AND GT_XNPSITE = '" + cNpSite + "' " 
								cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
	 
								TCSqlExec(cUpdPed) 
							Endif						 
 
						END SEQUENCE 
 
						If InTransact() 
							// Esqueceram transacao aberta ... Fecha fazendo commit ... 
							msgCon("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***") 
							EndTran() 
						Endif 
 
					Else 
						U_GTPutOUT(cID,"F",cPedLog,{"EXECUTAPEDIDOS",{.F.,"E00019",cPedLog,"Inconsistência na geração do Pedido"+CRLF+"LockByName em [" + AllTrim( cNpSite ) + "] - Altere GT_SEND e GT_INPROC se necessário."}},cNpSite) 
						U_GTPutPRO(cID) 
					Endif					 
				EndIf 
			ELSE 
				U_GTPutOUT(cID,"F",AllTrim(QRYGT->GT_PEDGAR),{"EXECUTAPEDIDOS",{.F.,"E00019",AllTrim(QRYGT->GT_PEDGAR),"Inconsistência na geração do Pedido"+CRLF+"não foi possível abrir o XML"}},AllTrim(QRYGT->GT_PEDGAR)) 
			EndIf 
		Else 
			U_GTPutOUT(cID,"F","",{"EXECUTAPEDIDOS",{.F.,"E00001","","Inconsistência na ABertura do XML de Pedidos "+CRLF+cError}}) 
 
			cUpdLis := "UPDATE GTIN " 
			cUpdLis += "SET GT_SEND = 'T' " 
			cUpdLis += "WHERE GT_ID = '" + cID + "' " 
			cUpdLis += "  AND GT_TYPE = 'F' " 
			cUpdLis += "  AND GT_SEND = 'F' " 
			cUpdLis += "  AND D_E_L_E_T_ = ' ' " 
 
			TCSqlExec(cUpdLis) 
		EndIf 
 
		cUpdPed := "UPDATE GTIN " 
		cUpdPed += "SET GT_SEND = 'T' " 
		cUpdPed += "WHERE GT_ID = '" + cID + "' " 
		cUpdPed += "  AND GT_TYPE = 'F' " 
		cUpdPed += "  AND GT_SEND = 'F' " 
		cUpdPed += "  AND GT_XNPSITE = '" + AllTrim(QRYGT->GT_PEDGAR) + "' " 
		cUpdPed += "  AND D_E_L_E_T_ = ' ' " 
 
		TCSqlExec(cUpdPed) 
 
		cPedAnt := AllTrim(QRYGT->GT_PEDGAR) 
		QRYGT->(DbSkip()) 
		oXml	:=nil 
		oXmlPst	:=nil 
		DelClassIntf() 
	EnddO 
 
	DbSelectArea("QRYGT") 
	QRYGT->(DbCloseArea()) 
Return lReturn 

/*/{Protheus.doc} CalcDescCo 
Monta rotina para montar itens do pedidos vendas
@author Bruno Nunes 
@since 15/05/2020 
@version 1.04 
/*/
Static Function CalcDescCo( oXMLProd, cNpSite, nItem, dEntreg, cTES, cNumvou, nQtdVou ) 
	local cItem      := "" 
	local cCombo     := "" 
	local cCodProd   := "" 
	local cCodGAR	 := "" 
	local aProdCombo := {} 
	local nQtdProd   := 0 
	local nUnit      := 0.00 
	local nUnitLiq   := 0.00 
	local nTotal     := 0.00 
	local nTotalLiq  := 0.00 
	local nDesconto  := 0.00	 
	local nPercDesc  := 0.00 
 
	default cNpSite  := 0 
	default nItem    := 0  
	default dEntreg  := CtoD("//") 
	default cTES     := "" 
	default cNumvou  := "" 
	default nQtdVou  := 0 
 
	if oXMLProd == nil .or. cNpSite == 0 .or. nItem == 0 
		return {} 
	endif  
 
	cItem 	  := StrZero(nItem, TamSX3("C6_ITEM")[1]) 
	cCombo 	  := oXMLProd:_CODCOMBO:TEXT 
	cCodProd  := oXMLProd:_CODPROD:TEXT 
	nQtdProd  := oXMLProd:_QTD:TEXT 
	nUnit     := oXMLProd:_VLUNITARIO 
	nUnitLiq  := oXMLProd:_VLUNITARIOLIQ 
	nTotal    := oXMLProd:_VLTOTAL 
	nTotalLiq := oXMLProd:_VLTOTALLIQ 
	nDesconto := oXMLProd:_VALORDESCONTO 
	nPercDesc := oXMLProd:_PORCENTUALDESCONTO 
	cCodGAR   := oXMLProd:_CODPRODGAR 
 
	//Calculo de desconto 
	oDesconto := CSDescontoPedido():New( cNpSite   , ; //[01] Pedido Site 
	cCodProd   , ; //[02] Codigo do Produto 
	cCombo	   , ; //[03] Codigo Combo 
	cCodGAR    , ; //[04] Codigo GAR 
	nQtdProd   , ; //[05] Quantidade 
	nUnit      , ; //[06] Valor unitario 
	nUnitLiq   , ; //[07] Valor liquido 
	nTotal	   , ; //[08] Valor total 
	nTotalLiq  , ; //[09] Valor total liquido 
	nDesconto  , ; //[10] Valor desconto 
	nPercDesc  , ; //[11] [ opcional ] Percentual desconto 
	cItem      , ; //[12] [ opcional ] Item no pedido de venda 
	dEntrega   , ; //[13] [ opcional ] Data de entrega 
	cTES       , ; //[14] [ opcional ] TES 
	cVoucher   , ; //[15] [ opcional ] Numero voucher 
	nVoucherQt , ; //[16] [ opcional ] Saldo voulcher 
	""         , ; //[17] [ opcional ] Origem venda 
	""         , ; //[18] [ opcional ] Pedido Origem 
	""		   , ; //[19] [ opcional ] Id produto pedido 
	""		   , ; //[20] [ opcional ] Id produto pai 
	""	       , ; //[21] [ opcional ] Tabela preco 
	""	       , ; //[22] [ opcional ] Tipo voucher 
	""	       , ; //[23] [ opcional ] Pedido Ecommerce 
	""	       , ; //[24] [ opcional ] Cumpom desconto  
	.F.        , ; //[25] [ opcional ] Kit 
	{}           ; //[26] [ opcional ] Composicao 
	) 
 
	//Pego o calculo no formato de array 
	aProdCombo := aClone( oDesconto:ToArray() ) 
 
	//Se der erro monta out de erro 
	if len( aProdCombo ) == 0 
		U_GTPutOUT(cID, "P", cNpSite, {"EXECUTAPEDIDOS", ; 
		{ .F., "E00018", cNpSite, "Erro ao calcular valor dos itens do combo:"+CRLF; 
		+ varinfo("oXml", oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[nPed]:_PRODUTO[nProd] ); 
		}; 
		},cNpSite) 
	endif 
return aProdCombo 

/*/{Protheus.doc} logProcess 
Imprime informações de processamento no arquivo console.log
@author Bruno Nunes 
@since 15/05/2020 
@version 1.04 
/*/
static function logProcess( cQryGT ) 
	local i        := 0 
	local cIdProc  := "" 
	local cPedSite := "" 
	local nTotal   := 0 
	local cAlias := getNextAlias() 
 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGT), cAlias,.F.,.T.) 
 
	dbSelectArea(cAlias) 
	(cAlias)->(dbGoTop()) 
	Count To nTotal 
 
	if nTotal > 0 
		conout( "SERVER_HARDWARE_AVULSO - U_EXECPEDI() - Data: " + dtoc(Date()) + " - " + Time() + " | Apos query de leitura dos pedidos para processamento "   )	 
		conout( "+------+--------------------------+ " ) 
		conout( "| Proc | GT_ID                    | " ) 
		conout( "+------+--------------------------+ " ) 
 
		(cAlias)->( dbGoTop() ) 
		while (cAlias)->( !Eof() ) 
			i++ 
			cIdProc  := strZero( i, 4 ) 
			cPedSite := PadL( (cAlias)->GT_ID, 24, " " ) 
 
			conout( "| " + cIdProc +" | " + cPedSite + " | " ) 
			(cAlias)->( dbSkip() ) 
		end  
 
		conout( "+------+--------------------------+ " ) 
	endif 
return

/*/{Protheus.doc} montarXML 
Carrega XML de vendas recebido pelo hub
@author Bruno Nunes 
@since 15/05/2020 
@version 1.04 
/*/
static function montarXML( cID, cError, cWarning, nPed ) 
	Local cRootPath		:= "" 
	Local cArquivo		:= "" 
	 
	default cID      := "" 
	default cError   := "" 
	default cWarning := "" 
	default nPed     := 0  
 
	//Monta caminho do arquivo 
	cRootPath	:= "\" + CurDir()	//Pega o diretorio do RootPath 
	cRootPath	+= "vendas_site\" 
	If Len( cID ) <= 18 
		cArquivo	:= "Pedidos_" + Left(cID,12) + ".XML" 
	Else 
		cArquivo	:= "Pedidos_" + Left(cID,17) + ".XML" 
	EndIf 
	cArquivo	:= cRootPath + cArquivo 
 
	//Monta xml com base em arquivo fisico gravado no servidor 
	oXml := XmlParserFile( cArquivo, "_", @cError, @cWarning ) 
	 
	if empty( cError) 
		If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A" 
			XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" ) 
		EndIf 
 
		nPed := Val( Right( alltrim( cID ), 6 ) ) 
	endif 
	
return oXml
