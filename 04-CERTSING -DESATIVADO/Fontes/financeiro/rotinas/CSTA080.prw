#INCLUDE "totvs.ch"  

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSTA080   �Autor  �Renato Ruy          � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envio de mensagem para o HUB de vinculo                    ���
���          � Produto e dados complementares do produto                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSTA080(cProduto)

	Local cXml 			:= ""
	Local cSvcError   	:= ""  // Resumo do erro
	Local cSoapFCode  	:= ""  // Soap Fault Code
	Local cSoapFDescr 	:= ""  // Soap Fault Description 
	
	Default cProduto := ""
	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cProduto))
		//Monta cabecalho
		cXml := XML_VERSION + CRLF
		cXml += '<produtoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'+ CRLF
		cXml += '	<code>1</code>'+ CRLF
	    cXml += '	<msg>Obtida Lista com Sucesso</msg>'+ CRLF
	
		//Dados do Produto
		cXml += '	<descricao>' + AllTrim(SB1->B1_DESC) + '</descricao>' + CRLF
		cXml += '	<codProd>' + AllTrim(SB1->B1_COD) + '</codProd>' + CRLF
		cXml += '	<pesoKg>' + AllTrim(Transform(SB1->B1_PESBRU,"999999.99")) + '</pesoKg>' + CRLF
		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		If SB5->(DbSeek(xFilial("SB5")+cProduto))
			cXml += '	<comprimentoCm>' + AllTrim(Transform(SB5->B5_COMPR,"999999.99")) + '</comprimentoCm>' + CRLF
			cXml += '	<alturaCm>' + AllTrim(Transform(SB5->B5_ESPESS,"999999.99")) + '</alturaCm>' + CRLF
			cXml += '	<larguraCm>' + AllTrim(Transform(SB5->B5_LARG,"999999.99")) + '</larguraCm>' + CRLF
		EndIf
		cXml += '	<vlDeclarado>' + AllTrim(Transform(SB1->B1_PRV1,"999999.99")) + '</vlDeclarado>' + CRLF
		
		cXml += '</produtoType>'+ CRLF
			
		oWsObj := WSVVHubServiceService():New()
						
		lOk := oWsObj:sendMessage("ATUALIZA-PRODUTO",cXml)
								
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
		If !empty(cSoapFCode)
			//Caso a ocorr�ncia de erro esteja com o fault_code preenchido ,
			//a mesma teve rela��o com a chamada do servi�o . 
			cSoapFDescr := "A A��O N�O PODE SER CONCLUIDA E POR ESTE MOTIVO A ALTERA��O N�O SER� GRAVADA!" +chr(13)+chr(10)+cSoapFDescr 
			MsgStop(cSoapFDescr,cSoapFCode)
			Conout(cSoapFDescr + " " + cSoapFCode)
			Return(.F.)
		ElseIf !Empty(cSvcError)
			//Caso a ocorr�ncia n�o tenha o soap_code preenchido 
			//Ela est� relacionada a uma outra falha , 
			//provavelmente local ou interna.
			cSvcError := "A A��O N�O PODE SER CONCLUIDA E POR ESTE MOTIVO A ALTERA��O N�O SER� GRAVADA!" +chr(13)+chr(10)+cSvcError 
			MsgStop(cSvcError,'FALHA INTERNA DE EXECUCAO DO SERVI�O')
			Conout('FALHA INTERNA DE EXECUCAO DO SERVI�O ' + cSvcError)
			Return(.F.)
		Endif

	Endif

Return .T.