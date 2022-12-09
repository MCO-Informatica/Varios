#INCLUDE "PROTHEUS.CH"
#include "fileio.ch"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" ?>'
/*/{Protheus.doc} VNDA610

Funcao criada transmitir ao hub notificação de emissão de certificados referente a assinaturas   

@author Totvs SM - David
@since 17/06/2014
@version P11

/*/
User Function VNDA610(aParSch)
	Local cCategory := "EMISSAO-CERTIFICADO"	
	Local cDocument1:= ""
	Local cDocument2:= ""
	Local cDocument3:= ""
	Local cJobEmp	:= ""
	Local cJobFil	:= ""
	Local _lJob 	:= (Select('SX6')==0)
	Local cError	:= ""
	Local cWarning	:= ""
	Local cSvcError := ""
	Local cSoapFCode:= ""
	Local cSoapFDescr:= ""
	Local lOk		:= .T.
	Local oWsObj
	Local oWsRes
	Local cAnoMes	:= ""
	Local aRecUPD	:= {}
	Local nI		:= 0
	Local cUpd		:= ''
	Local cDtIni	:= ''
	Local cQuant	:= "" //Apontar a quantidade que sera enviada a cada consulta.
	Local cPessoa	:= ""	

	Private cMun	:= ''	
	Private cUF		:= ''	

	default aParSch	:= {"01","02"}
	
	cJobEmp	:= aParSch[1]
	cJobFil	:= aParSch[2]
	
 	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf
	
	cDtIni:= DtoS(dDatabase-30)//GetMV("MV_XDIA610",,"20140801")
	cQuant:= "% rownum <= " + GetNewPar('MV_XQTDEMI',"500") + " %"
	
	cAlias := GetNextALias()
	
	BeginSql Alias cAlias
		SELECT
		  SZ5.Z5_TIPO,
		  SZ5.Z5_PEDIDO,
		  SZ5.Z5_PEDGAR,
		  SZ5.Z5_PEDGANT,
		  SZ5.Z5_PRODGAR,
		  SZ5.Z5_DESPRO,
		  SZ5.Z5_DESCAC,
		  SZ5.Z5_DESCAR,
		  SZ5.Z5_NTITULA,
		  SZ5.Z5_RSVALID,
		  SZ5.Z5_CNPJV,
		  SZ5.Z5_CNPJ,
		  SZ5.Z5_CPFT,
		  SZ5.Z5_EMAIL,
		  SZ5.Z5_CODPOS,
		  SZ5.Z5_CPFAGE,
		  SZ5.R_E_C_N_O_ RECZ5
		FROM
		  %Table:SZ5%  SZ5 INNER JOIN %Table:SC5% SC5 ON
		  	SC5.C5_FILIAL = %xFilial:SC5% AND
		  	SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG AND
		  	SC5.%NotDel%
		WHERE 
		  //Renato Ruy - 18/10/2016
		  //Retirado o filtro, serao enviados todos os pedidos emitidos.
		  //SZ5.Z5_TIPO IN ('EMISSA','RENOVA') AND
		  SZ5.Z5_FILIAL = %xFilial:SZ5% AND
		  SZ5.Z5_DATEMIS >= %Exp:cDtIni%	AND
		  Z5_PRODGAR > ' ' AND
		  SZ5.Z5_FLAGPAS = ' ' AND //voltar para os dados que não foram marcadas e quantidade de 50
		  SZ5.%NotDel% AND
		  %Exp:cQuant%
		  
	EndSql
	
	If !(cAlias)->(EoF())
	    
		//Renato Ruy - 11/11/16
		//Envia um pedido por lote.
		//cDocument1 := XML_VERSION + CRLF
		//cDocument1 += '<EmissaoCertificado>'+CRLF
		
		//cDocument2 := ""		
		
		SA1->(DbSetOrder(1))
		SC5->(DbOrderNickName("NUMPEDGAR"))
		AC8->(DbSetOrder(2)) //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON                                                                                                          
		SU5->(DbSetOrder(1))
		
		While !(cAlias)->(EoF())
		
			//Renato Ruy - 11/11/16
			//Envia um pedido por lote.
			cDocument1 := XML_VERSION + CRLF
			cDocument1 += '<EmissaoCertificado>'+CRLF
			
			cDocument2 := ""	
			aRecUPD	:= {}
			cNome 	:= "" 
	  		cTel	:= ""
	  		cCpf	:= "" 
	  		cEmail	:= ""
	  		
	  		If 	SC5->(DbSeek(xFilial("SC5")+(cAlias)->Z5_PEDGAR)) .and.;
	  			AC8->(DbSeek(xFilial("AC8")+"SA1"+xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))) .and.;
	  			SU5->(DbSeek(xFilial("SU5")+AC8->AC8_CODCON)) .and.;
	  			!Empty(SU5->U5_CONTAT) .and.;
	  			!Empty(SU5->U5_DDD+SU5->U5_FONE) .and.;
	  			!Empty(SU5->U5_CPF) .and.;
	  			!Empty(SU5->U5_EMAIL)	  		
	  			
	  			cNome 	:= Alltrim(SU5->U5_CONTAT) 
	  			cTel	:= Alltrim(SU5->U5_DDD)+Alltrim(SU5->U5_FONE)
	  			cCpf	:= Alltrim(SU5->U5_CPF)
	  			//cEmail	:= Alltrim(SU5->U5_EMAIL)
	  			
	  		ElseIf 	SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))) .and.;
	  				(!Empty(SA1->A1_CONTATO) .or. !Empty(SA1->A1_NOME)) .and.;
	  				!Empty(SA1->A1_DDD+SA1->A1_TEL) .and.;
	  				!Empty(SA1->A1_CGC) .and.;
	  				!Empty(SA1->A1_EMAIL)
	  					  		
	  			cNome 	:= IIF(Empty(SA1->A1_CONTATO),Alltrim(SA1->A1_NOME),Alltrim(SA1->A1_CONTATO)) 
	  			cTel	:= Alltrim(SA1->A1_DDD)+Alltrim(SA1->A1_TEL)
	  			cCpf	:= Alltrim(SA1->A1_CGC)
	  			//cEmail	:= Alltrim(SA1->A1_EMAIL)
	  			
	  		Else 
	  		
	  			(cAlias)->(DbSkip())
	  			Loop
	  			
	  		Endif
	  		
	  		cEmail := AllTrim((cAlias)->Z5_EMAIL)
	  		
	  		AADD(aRecUPD,(cAlias)->RECZ5)
			
			cDocument2 += '	<Pedido>'+CRLF
	  		cDocument2 += '		<numeroGAR>'+Alltrim((cAlias)->Z5_PEDGAR)+'</numeroGAR>'+CRLF 
	  		cDocument2 += '		<emissao>'+CRLF
	   		cDocument2 += '			<ac>'+Alltrim((cAlias)->Z5_DESCAC)+'</ac>'+CRLF 
	   		cDocument2 += '			<ar>'+Alltrim((cAlias)->Z5_DESCAR)+'</ar>'+CRLF
	  		cDocument2 += '		</emissao>'+CRLF
	  		cDocument2 += '		<produto>'+CRLF
	  		cDocument2 += '			<codigo>'+Alltrim((cAlias)->Z5_PRODGAR)+'</codigo>'+CRLF 
	  		cDocument2 += '			<descricao>'+Alltrim((cAlias)->Z5_DESPRO)+'</descricao>'+CRLF
	  		//If Alltrim((cAlias)->Z5_TIPO) == 'RENOVA'
	  		If !Empty((cAlias)->Z5_PEDGANT)
	  			cDocument2 += '			<renovacao>S</renovacao>'+CRLF
	  		Else
	  			cDocument2 += '			<renovacao>N</renovacao>'+CRLF
	  		EndIf 
	  		cDocument2 += '		</produto>'+CRLF	  		
	  	
	  		cDocument2 += '		<contato>'+CRLF
	  		//cDocument2 += '			<nome>'+cNome+'</nome>'+CRLF 
	  		cDocument2 += '			<nome>'+Alltrim((cAlias)->Z5_NTITULA)+'</nome>'+CRLF 
	  		cDocument2 += '			<email>'+cEmail+'</email>'+CRLF
	  		cDocument2 += '			<telefone>'+cTel+'</telefone>'+CRLF   
	  		//cDocument2 += '			<cpf>'+cCpf+'</cpf>'+CRLF
	  		cDocument2 += '			<cpf>'+Padl(Alltrim((cAlias)->Z5_CPFT),11,"0")+'</cpf>'+CRLF
	  		cDocument2 += '		</contato>'+CRLF
	  		
	  		cDocument2 += '		<titular>'+CRLF
	  		
	  		If Empty(Alltrim((cAlias)->Z5_RSVALID))
	  			cDocument2 += '			<nome>'+Alltrim((cAlias)->Z5_NTITULA)+'</nome>'+CRLF
	  		Else
	  			cDocument2 += '			<nome>'+Alltrim((cAlias)->Z5_RSVALID)+'</nome>'+CRLF
	  		EndIf
	  		 
	  		If Empty(Alltrim((cAlias)->Z5_RSVALID))
	  			cDocument2 += '			<cpf>'+Padl(Alltrim((cAlias)->Z5_CPFT),11,"0")+'</cpf>'+CRLF
	  		Else
	  			cDocument2 += '			<cnpj>'+PadL(Alltrim(STR(Iif(Empty((cAlias)->Z5_CNPJV),Val((cAlias)->Z5_CNPJ),(cAlias)->Z5_CNPJV))),14,"0")+'</cnpj>'+CRLF
	  			//cDocument2 += '			<cpf>'+PadL(Alltrim(STR((cAlias)->Z5_CNPJV)),14,"0")+'</cpf>'+CRLF //Não funcionou no primeiro teste usando a tag cnpj
	  		EndIf 
	  		cDocument2 += '		</titular>'+CRLF
	  		//Renato Ruy - 04/08/2016
	  		//Enviar dados do posto na mensagem
	  		
	  		//Chama funcao para buscar dados do posto.
	  		VNDA610Q(Alltrim((cAlias)->Z5_CODPOS))
	  		
	  		//Renato Ruy - 17/11/2016
	  		//Gerar Log para enviar para equipe de produtos
	  		cPessoa := Iif(Empty((cAlias)->Z5_RSVALID),"PF","PJ")
	  		VNDA610L((cAlias)->Z5_PEDGAR,Alltrim((cAlias)->Z5_DESCAC),cPessoa)
	  		
	  		//Alimenta os dados.
	  		cDocument2 += '		<posto>'+CRLF
	   		cDocument2 += '			<agente>'+Padl(Alltrim((cAlias)->Z5_CPFAGE),11,"0")+'</agente>'+CRLF 
	   		cDocument2 += '			<codigo>'+Alltrim((cAlias)->Z5_CODPOS)+'</codigo>'+CRLF 
	   		cDocument2 += '			<cidade>'+ AllTrim(Strtran(Strtran(Strtran(Strtran(Upper(cMun),"Ã","A"),"É","E"),"Á","A"),"Ó","O")) +'</cidade>'+CRLF
	   		cDocument2 += '			<uf>'    +cUf						   +'</uf>'+CRLF
	  		cDocument2 += '		</posto>'+CRLF
	  		
	  		cDocument2 += '	</Pedido>'+CRLF
	  		
	  		cDocument3 := '</EmissaoCertificado>'
	  	
		  	If !Empty(cDocument2)
			  	oWsObj := WSVVHubServiceService():New()
			
				lOk := oWsObj:sendMessage(cCategory,cDocument1+cDocument2+cDocument3)
					
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2)  // Soap Fault Code
				cSoapFDescr := GetWSCError(3)  // Soap Fault Description
					
				If !empty(cSoapFCode)
					//Caso a ocorrência de erro esteja com o fault_code preenchido ,
					//a mesma teve relação com a chamada do serviço . 
					Conout('[VNDA610]'+cSoapFDescr + ' ' + cSoapFCode)
					cMsgRet	:= cSoapFDescr + ' ' + cSoapFCode
					lOk 	:= .F.
				ElseIf !Empty(cSvcError)
					//Caso a ocorrência não tenha o soap_code preenchido 
					//Ela está relacionada a uma outra falha , 
					//provavelmente local ou interna.
					Conout('[VNDA610] FALHA INTERNA DE EXECUCAO DO SERVIÇO'+cSvcError)
					lOk := .F.
					cMsgRet	:= cSvcError
				Endif
					
				If lOk
					oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
					
					If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1" .AND. Empty(cError)
						lOk := .T.
						
						For nI := 1 to Len(aRecUPD)
							cUpd := "UPDATE "+RetSqlName("SZ5")+" SET Z5_FLAGPAS = 'X' WHERE R_E_C_N_O_ = "+Alltrim(Str(aRecUPD[nI]))
							
							TcSqlExec(cUpd)
						Next
											
					ElseIf !Empty(cError)
						conout("[VNDA610] Erro no parser do xml enviado pelo HUB "+cError)
						lOk := .F.	
						cMsgRet	:= cError
					Else
						conout("[VNDA610] Erro no retorno do HUB "+oWsRes:_CONFIRMATYPE:_MSG:TEXT)
						lOk := .F.
						cMsgRet	:= oWsRes:_CONFIRMATYPE:_MSG:TEXT
					EndIf
					
					FreeObj(oWsRes)
					FreeObj(oWsObj)
					DelClassIntf()
				EndIf	
			Endif
	  		
	  		(cAlias)->(DbSkip())
	  	
	  	EndDo
	  	
	  	
	Endif
	
	(cAlias)->(DbCloseArea())
			
Return

//Renato Ruy - 04/08/2016
//Retorna dados do posto
Static Function VNDA610Q(cPosto)

Local cCodPO := " "
Local oObj

Default cPosto := "0"

//Posiciona na tabela de postos
SZ3->( DbSetOrder(4) )
If SZ3->( DbSeek( xFilial("SZ3") + cPosto ) )
	//Posiciona no posto fisico
	PA7->(DbSetOrder(1))
	If PA7->(DbSeek(xFilial("PA7")+AllTrim(PADL(SZ3->Z3_CEP,8,"0")))) .And. !Empty(SZ3->Z3_CEP)
	     cMun := PA7->PA7_MUNIC
	     cUf  := PA7->PA7_ESTADO
	Else
		//Não tem CEP preenchido, busca no webservice
		BEGIN SEQUENCE
		oWSObj := WSIntegracaoGARERPImplService():New()
		IF oWSObj:detalhesPosto( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
								 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
								 Val( cPosto ) )
			If ValType(oWSObj:oWSposto[1]:NCEP) <> "U"
				SZ3->(RecLock("SZ3",.F.))
					SZ3->Z3_CEP		:= AllTrim(StrZero(oWSObj:oWSposto[1]:NCEP,8))	//CEP
				SZ3->(MsUnlock())
			Endif
		Endif
		DelClassIntF()
		End Sequence
		
		//Renato Ruy - 29/09/2016 - Estava gerando erro quando posto não tem CEP
		//Chama de forma recursiva
		//If Empty(SZ3->Z3_CEP)
		//	VNDA610Q(SZ3->Z3_CODGAR)
		//Endif
	EndIf

//Caso nao encontre, cria posto e recebe informação
Else
	StaticCall(CRPA020,CRPA020Q,cPosto)
	VNDA610Q(SZ3->Z3_CODGAR)
Endif

Return

//Renato Ruy - 17/11/2016
//Enviar Log para usuário com os dados gerados.
Static Function VNDA610L(cPedgar, cDesAc, cPessoa)

Local cArqLog := "\pedidosfaturados\log_portal-"+DtoS(dDatabase)+".csv"
Local cEOL    := "CHR(13)+CHR(10)"

//Cria caractere para quebra de linha.
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

// Abre o arquivo
nHandle := fopen(cArqLog , FO_READWRITE + FO_SHARED )

//Caso não encontre o arquivo o sistema cria
If nHandle == -1
	nHandle := fCreate(cArqLog)
	FWrite(nHandle, "Pedido;Rede do Pedido;Tipo Certificado"+cEOL)
//Quando encontra se posiciona na última linha para gravar.
Else
	FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
Endif

FWrite(nHandle, cPedgar + ";" + cDesAc + ";" + cPessoa +cEOL) // Insere texto no arquivo
fclose(nHandle)           // Fecha arquivo

Return