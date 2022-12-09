#include "totvs.ch"
#include "apwebsrv.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

WSSERVICE REMUNERACAO DESCRIPTION "WebService responder informacoes com base no CPF" NAMESPACE "http://localhost:8080/remuneracao.apw"
  WSDATA cCpf AS String
  WSDATA cPeriodo AS String
  WSDATA _dados AS String
  WSMETHOD ListaPeriodos DESCRIPTION "Lista de Periodos do CPF"
  WSMETHOD ListaPedidos DESCRIPTION "Lista de Planilhas x CPF"
ENDWSSERVICE
 
WSMETHOD ListaPeriodos WSRECEIVE cCpf WSSEND _dados WSSERVICE REMUNERACAO

	Local _lJob 	:= (Select("SX6") == 0)
	Local cCpfFmt := ""
	
	If _lJob
		//Abre a conexão com a empresa
		RpcSetType(3)
		RpcSetEnv("01","02")
		ConOut("Inicia o ambiente")
	Endif
	
	//ConOut("CPF: "+cCpf)
	
	If Len(AllTrim(cCpf)) < 11
		cCpfFmt := PadL(AllTrim(cCpf),11,"0")
	Else
		cCpfFmt := cCpf
	Endif
	
	If Select("TMPPER") > 0
		DbSelectArea("TMPPER")
		TMPPER->(DbCloseArea())
	Endif

	//Obter os dados das planilhas do usuario
	Beginsql Alias "TMPPER"
	
		SELECT  ZZG_PERIOD
		FROM %Table:ZZF% ZZF
		JOIN %Table:ZZG% ZZG 
		ON ZZG_FILIAL = %xFilial:ZZG% AND ZZG_CODENT = ZZF_CODENT AND
		   ZZG_ATIVO = '1' AND ZZG.%NOTDEL%
		JOIN %Table:ZZ6% ZZ6 
	ON ZZ6_FILIAL = %xFilial:ZZ6% AND ZZ6_CODENT = ZZG_CODENT AND ZZ6_PERIOD = ZZG_PERIOD AND ZZ6_SALDO > 0 AND ZZ6.%NOTDEL%
		WHERE
		ZZF_FILIAL = %xFilial:ZZF% AND
		ZZF_CPF = %Exp:cCpfFmt% AND
		ZZF.%NOTDEL%
		GROUP BY ZZG_PERIOD
	
	Endsql
	
	
	::_dados := XML_VERSION + CRLF
	::_dados += '<listaPeriodo>' + CRLF
	//Se não tem dados notifica solicitante
	WHILE !TMPPER->(EOF())
		::_dados += ' <periodo>'+TMPPER->ZZG_PERIOD+'</periodo>' + CRLF //1=sucesso na operação; 0=erro
		TMPPER->(DbSkip())
	ENDDO
	::_dados += '</listaPeriodo>' + CRLF
	
// Retorna que a operação foi feita com sucesso para a camada do Protheus. 
Return .T.

WSMETHOD ListaPedidos WSRECEIVE cCpf,cPeriodo WSSEND _dados WSSERVICE REMUNERACAO

	Local cHref	 := RTrim(GetNewPar("MV_CRPAWSA","http://10.0.14.172:80/"))+cPeriodo+"/"
	Local cNumCpf	 := ::cCpf
	Local cValPer	 := ::cPeriodo
	Local _lJob 	:= (Select("SX6") == 0)
	
	If _lJob
		//Abre a conexão com a empresa
		RpcSetType(3)
		RpcSetEnv("01","02")
		ConOut("Inicia o ambiente")
	Endif
	
	If Len(AllTrim(cNumCpf)) < 11
		cNumCpf := PadL(AllTrim(cNumCpf),11,"0")
	Endif
   
	If Select("TMPRED") > 0
		DbSelectArea("TMPRED")
		TMPRED->(DbCloseArea())
	Endif
	
	//Obter os dados das planilhas do usuario
	Beginsql Alias "TMPRED"
	
		%noParser%
	
		SELECT  ZZG_FILHO PARCEIRO,
				 ZZG_PERIOD PERIODO,
				 ZZG_CODENT CODENT,
				 Z3_DESENT DESCRICAO,
				 DECODE(ZZG_TIPO,1,'CANAL',
		                        2,'AC',
		                        4,'POSTO',
		                        7,'CAMPANHA',
		                        8,'FEDERACAO',
		                        10,'CLUBE') TIPO,
		        ZZG_NOMARQ LINK,
		        ZZG_VERSAO VERSAO,
		        ZZG_TOTAL TOTAL
		FROM %Table:ZZF% ZZF
		JOIN %Table:ZZG% ZZG 
		ON ZZG_FILIAL = %xFilial:ZZG% AND ZZG_CODENT = ZZF_CODENT AND
		   ZZG_ATIVO = '1' AND ZZG_PERIOD = %Exp:cValPer% AND ZZG.%NOTDEL%
		JOIN %Table:SZ3% SZ3 
		ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODENT = ZZG_CODENT AND
		   Z3_TIPENT IN ('1','2','4','7','8','9','10') AND SZ3.%NOTDEL%
		JOIN %Table:ZZ6% ZZ6 
		ON ZZ6_FILIAL = %xFilial:ZZ6% AND ZZ6_CODENT = ZZG_CODENT AND ZZ6_PERIOD = ZZG_PERIOD AND ZZ6_SALDO > 0 AND ZZ6.%NOTDEL%
		WHERE
		ZZF_FILIAL = %xFilial:ZZF% AND
		ZZF_CPF = %Exp:cNumCpf% AND
		ZZF.%NOTDEL%
	
	Endsql
	
	
	::_dados := XML_VERSION + CRLF
	::_dados += '<listaPedidos>' + CRLF
	
	WHILE !TMPRED->(EOF())
		::_dados += '	<pedido>' + CRLF
		::_dados += '   	<periodo>'+RTrim(TMPRED->PERIODO)+'</periodo>' + CRLF //1=sucesso na operação; 0=erro
		::_dados += '   	<parceiro>'+RTrim(TMPRED->PARCEIRO)+'</parceiro>' + CRLF
		::_dados += '   	<entidade>'+RTrim(TMPRED->CODENT)+'</entidade>' + CRLF
		::_dados += '   	<descricao>'+RTrim(TMPRED->DESCRICAO)+'</descricao>' + CRLF
		::_dados += '   	<tipo>'+RTrim(TMPRED->TIPO)+'</tipo>' + CRLF
		::_dados += '   	<link>'+cHref+AllTrim(TMPRED->LINK)+'</link>' + CRLF
		::_dados += '   	<versao>'+AllTrim(Str(TMPRED->VERSAO))+'</versao>' + CRLF
		::_dados += '   	<total>'+AllTrim(Str(TMPRED->TOTAL))+'</total>' + CRLF
		::_dados += '	</pedido>' + CRLF
		TMPRED->(DbSkip())
	ENDDO
	::_dados += '</listaPedidos>' + CRLF
   
// Retorna que a operação foi feita com sucesso para a camada do Protheus. 
Return .T.