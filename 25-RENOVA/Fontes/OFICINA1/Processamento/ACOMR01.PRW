#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'parmtype.ch'

#DEFINE UID	"TSSCONFIG"
#DEFINE ENTER chr(13)+chr(10)
	
/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁACOMR01      ╨Autor  ЁFelipi Marques       ╨ Data Ё  03/31/15   ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRotina que irА realizar as requisiГУes ao WebService da         ╨╠╠
╠╠╨          ЁSEFAZ responsАvel por capturar a chave da NFe.                  ╨╠╠
╠╠╨          Ё																  ╨╠╠
╠╠╨          Ё MODELO DE REQUISICAO do WebService WSNFeDistribuicaoDFe        ╨╠╠
╠╠╨          Ё <distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe"         ╨╠╠
╠╠╨          Ё 	<tpAmb>2</tpAmb>                                              ╨╠╠
╠╠╨          Ё 	<cUFAutor>31</cUFAutor>                                       ╨╠╠
╠╠╨          Ё 	<CNPJ>05229436000170</CNPJ>                                   ╨╠╠
╠╠╨          Ё 	<distNSU>                                                     ╨╠╠
╠╠╨          Ё 		<ultNSU>000000000000000</ultNSU>                          ╨╠╠
╠╠╨          Ё 	</distNSU>                                                    ╨╠╠
╠╠╨          Ё 	<consNSU> --TAG OPCIONAL                                      ╨╠╠
╠╠╨          Ё 		<NSU>000000000000000</NSU>                                ╨╠╠
╠╠╨          Ё 	</consNSU>	                                                  ╨╠╠
╠╠╨          Ё </distDFeInt>                                                  ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                        	  ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/

User Function ACOMR01( cTpAmb, cUfAutor, cCNPJ, nNumImp)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cChave
Local cUltNSU  := ""
Local oWS
Local cBeginReq
Local cEndReq
Local cRequest      := ''
Local cRotina       := "CHAVE"
Local cLastImp      :=  GetMv("ES_XMLNSU")
Local cStatEvento   := "0"
Local cSchema
Local cMotivo
Local cMsgErro
Local cStat   
Local lRet := .T.  
Local oDFe := Nil
Private cError   := ""
Private cWarning := ""
Private cIdEnt

				
//зддддддддддддддддддддддддддд0
//ЁBusca a edenditade via CNPJЁ
//юддддддддддддддддддддддддддд0
DbSelectArea("Z05")
Z05->(DbSetOrder(2))   
IF Z05->(dbSeek(xFilial("Z05")+Alltrim(cCNPJ) )) 
	cIdEnt := Z05-> Z05_CODIGO
Else
	cMsgErro :=  "| ACOMR01 | NЦo encontrado o cadastro da entidade" 
	Return( {.F.,cMsgErro})
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTipo ImplementaГЦo Ex: Prox, TSS, Programa Externo, etc...Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nNumImp == 1   

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁCarrega dados do xml para consulta                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oWs 						:= &(SuperGetMv("ES_WSCHV",.F.,"WSNFeDistribuicaoDFe():New()"))
	cBeginReq   				:= SuperGetMv("ES_BNFECHV"	,.F.,'<distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">')
	cEndReq						:= SuperGetMv("ES_ENFECHV"	,.F.,'</distDFeInt>')
	
	cRequest 					:= '<tpAmb>'	+cTpAmb		+'</tpAmb>'
	cRequest					+= '<cUFAutor>'	+cUfAutor	+'</cUFAutor>'
	cRequest					+= '<CNPJ>'		+cCNPJ		+'</CNPJ>'
	cRequest    				+= '<distNSU>'
	cRequest    				+= '<ultNSU>'	+cLastImp	+'</ultNSU>'
	cRequest    				+= '</distNSU>'

	oWS:oWSnfeDadosMsg 			:= cBeginReq+cRequest+cEndReq
     
	/*Faz a configuraГЦo do certificado utilizado pelo SSL*/
	U_ACOMR09(cIdEnt , @cError, oWs)
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁInicia WebService para consulta das chaves dos xml       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !( oWS:nfeDistDFeInteresse() )
		If !(Empty( GetWSCError(3)))
			Conout( SubStr( GetWSCError(3), At(":", GetWSCError(3) ) + 1 ) )
		Else
			cMsgErro :=   " | ACOMR01 | Problema na ExecuГЦo do Webservice!" +ENTER
			cMsgErro +=  GetWSCError(1) +ENTER
			lRet := .F.
		EndIf
	Else
//		VarInfo("oWS",oWS)
		If AllTrim(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT) == "138"
			// Adicionado controle de transaГЦo aqui - MH 18/12/2018
			Begin Transaction
				If ValType(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP) == "A"
					
					For nX := 1 To Len(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP)
						cSchema := oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:_SCHEMA:TEXT
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//ЁSIGNIFICA QUE TRATA-SE DE UM CANCELAMENTO/OUTRO PROCESSO SEM CHAVEЁ
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If !Empty(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT)
							cChave 		:= U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT, "chNfe", "nfeDistDFeInteresse", cSchema, .T.)
							cNSU   		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:_NSU:TEXT
							cUltNSU 	:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
							cMotivo		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_XMOTIVO:TEXT
							cStat		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT
							cRetWs		:= U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT, "XML", "nfeDistDFeInteresse", cSchema, .T.)
							dDhAutNfe	:= StoD(U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT, "dhRecbto", "nfeDistDFeInteresse", cSchema, .T.))
	
							oDFe	    := XmlParser( cRetWs, "_", @cError, @cWarning)
							
							If cSchema $ SuperGetMv("ES_SCHCHV",.F.,"resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
								cStatEvento := "0"
							EndIf
							//Download do XML da NF nЦo realizado.
							cStatDown	:= "1"
							
							ConOut("ACOMR01 136 -> SCHEMA: "+AllTrim(cSchema)+" NX: "+cValToChar(nx)+" cStatEvento: "+cStatEvento)
							
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁAlteraГЦo para salvar apenas SCHEMA referente a NF de EntradaЁ
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If AllTrim(cSchema) $ SuperGetMv("ES_IMPSCH", .F., "resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//ЁRotina que realiza a persistencia na tabela Z01.             Ё
								//Ёздддддддддддддддддддддддддддддддддддддддддддддддд&dддддддд&da©
								Conout("ACOMR01 147 -> cChave: "+cChave+" SCHEMA: "+cSchema+" NSU: "+cNsu+" cUltNsu "+cUltNsu)// +" xml: "+cRetWs)
								If !U_ACOME01( cChave, cRotina, cNSU, cUltNSU, cSchema, cStatEvento, cStatDown, cRetWs, dDhAutNfe,oDFe )
									//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//ЁOcorrencia de nЦo realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravaГЦo.Ё
									//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
									U_ACOME04( cChave, cRotina, cSchema, cNSU, cMotivo, cStat, cRetWs )
								EndIf
							EndIf
							
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддp©
							//ЁNumero do ultimo numero sequencial unico(NSU) importado pela rotina que realiza o download das chaveЁ
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддpы
							// Alterei para gravar fora do Loop - MH
	//						PutMv("ES_XMLNSU",cUltNSU)
							
							cChave 		:= ""
							cNSU   		:= ""
	//						cUltNSU 	:= ""
							cMotivo		:= ""
							cStat		:= ""
							dDhAutNfe	:= ""
							cStatEvento := "" //Ciencia da Operacao nЦo realizada.
							cStatDown	:= "" //Download do XML da NF nЦo realizado.
							cRetWs		:= ""
						Else
							cChave 		:= ""
							cNSU   		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT
							cUltNSU 	:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
							cStat		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT
							cStatEvento := "5" //Ciencia da Operacao nЦo realizada.
							cStatDown	:= "1" //Download do XML da NF nЦo realizado.
							cRetWs		:= ""
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁAlteraГЦo para salvar apenas SCHEMA referente a NF de EntradaЁ
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If AllTrim(cSchema) $ SuperGetMv("ES_IMPSCH", .F., "resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//ЁRotina que realiza a persistencia na tabela Z01.             Ё
								//Ёздддддддддддддддддддддддддддддддддддддддддддддддд&dддддддд&da©
								Conout("ACOMR01 183 -> cChave: "+cChave+" SCHEMA: "+cSchema+" NSU: "+cNsu+" cUltNsu "+cUltNsu)// +" xml: "+cRetWs)
								If !U_ACOME01( cChave, cRotina, cNSU, cUltNSU, cSchema, cStatEvento, cStatDown, cRetWs, dDhAutNfe )
									//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//ЁOcorrencia de nЦo realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravaГЦo.Ё
									//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
									U_ACOME04( cChave, cRotina, cSchema, cNSU, cMotivo, cStat, cRetWs )
								EndIf
							EndIf
						EndIf
					Next nX
					
				Else
					cSchema := oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:_SCHEMA:TEXT
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁSIGNIFICA QUE TRATA-SE DE UM CANCELAMENTO/OUTRO PROCESSO SEM CHAVEЁ
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If !Empty(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT)
						cChave 		:= U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT, "chNfe", "nfeDistDFeInteresse", cSchema, .T.)
						cNSU   		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:_NSU:TEXT
						cUltNSU 	:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
						cMotivo		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_XMOTIVO:TEXT
						cStat		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT
						cRetWs		:= U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT, "XML", "nfeDistDFeInteresse", cSchema, .T.)
						cStatus		:= "1" //Nao Importado
						dDhAutNfe	:= StoD(U_ACOMR02(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP:TEXT, "dhRecbto", "nfeDistDFeInteresse", cSchema, .T.))
						oDFe	    := XmlParser( cRetWs, "_", @cError, @cWarning)
						
						If Upper("procEventoNFe") $ Upper(cSchema)
							cStatEvento := "0"
						EndIf
						//Download do XML da NF nЦo realizado.
						cStatDown	:= "1"
						
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//ЁAlteraГЦo para salvar apenas SCHEMA referente a NF de EntradaЁ
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If AllTrim(cSchema) $ SuperGetMv("ES_IMPSCH", .F., "resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁRotina que realiza a persistencia na tabela Z01.             Ё
							//Ёздддддддддддддддддддддддддддддддддддддддддддддддд&dддддддд&da©
							Conout("ACOMR01 223 -> cChave: "+cChave+" SCHEMA: "+cSchema+" NSU: "+cNsu+" cUltNsu "+cUltNsu )//+" xml: "+cRetWs)
							If !U_ACOME01( cChave, cRotina, cNSU, cUltNSU, cSchema, cStatEvento, cStatDown, cRetWs, dDhAutNfe )
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//ЁOcorrencia de nЦo realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravaГЦo.Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								U_ACOME04( cChave, cRotina, cSchema, cNSU, cMotivo, cStat, cRetWs )
							EndIf
						EndIf
						
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддp©
						//ЁNumero do ultimo numero sequencial unico(NSU) importado pela rotina que realiza o download das chaveЁ
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддpы
						//PutMv("ES_XMLNSU",cUltNSU)
						
						cChave 		:= ""
						cNSU   		:= ""
	//					cUltNSU 	:= ""
						cMotivo		:= ""
						cStat		:= ""
						dDhAutNfe	:= ""
						cStatEvento := "" //Ciencia da Operacao nЦo realizada.
						cStatDown	:= "" //Download do XML da NF nЦo realizado.
						cRetWs		:= ""
					Else
						cChave 		:= ""
						cNSU   		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_LOTEDISTDFEINT:_DOCZIP[nX]:TEXT
						cUltNSU 	:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_ULTNSU:TEXT
						//cStatus		:= "1" //Nao Importado
						cStat		:= oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT
						cStatEvento := "1" //Ciencia da Operacao nЦo realizada.
						cStatDown	:= "1" //Download do XML da NF nЦo realizado.
						cRetWs		:= ""
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//ЁAlteraГЦo para salvar apenas SCHEMA referente a NF de EntradaЁ
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If AllTrim(cSchema) $ SuperGetMv("ES_IMPSCH", .F., "resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁRotina que realiza a persistencia na tabela Z01.             Ё
							//Ёздддддддддддддддддддддддддддддддддддддддддддддддд&dддддддд&da©
							Conout("ACOMR01 262 -> cChave: "+cChave+" SCHEMA: "+cSchema+" NSU: "+cNsu+" cUltNsu "+cUltNsu)// +" xml: "+cRetWs)
							If !U_ACOME01( cChave, cRotina, cNSU, cUltNSU, cSchema, cStatEvento, cStatDown, cRetWs, dDhAutNfe )
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//ЁOcorrencia de nЦo realizar a gravacao em virtude do chave ja existir e/ou erro na rotina de gravaГЦo.Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								U_ACOME04( cChave, cRotina, cSchema, cNSU, cMotivo, cStat, cRetWs )
							EndIf
						EndIf
					EndIf
				EndIf
				
				If .NOT. Empty(cUltNSU)
					PutMv("ES_XMLNSU",cUltNSU)
				Endif
				
			End Transaction
			
		ElseIf AllTrim(oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT) == "137"
			Sleep(3)
		Else
			cMsgErro :=  "NЦo existem notas a serem importadas." +ENTER
			cMsgErro += "STAT: "+oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_CSTAT:TEXT+" MOTIVO: "+ oWS:oWSnfeDistDFeInteresseResult:_NFEDISTDFEINTERESSERESULT:_RETDISTDFEINT:_XMOTIVO:TEXT
			lRet := .f.
			Conout(cMsgErro)
		EndIf
		
	EndIf
Else
EndIf

ConOut("Ultimo NSU: "+cUltNSU)
						
	
Return( {lRet, cMsgErro}  )
	
/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁChkCiencia    ╨Autor  ЁFelipi Marques  ╨ Data Ё  04/02/15   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁFuncao para verificar se no retorno da chave jА consta o    ╨╠╠
╠╠╨          Ёseu manifesto.                                              ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
	
Static Function ChkCiencia( oDocumento )
	
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cCodEvento 	:= SuperGetMv("ES_CODCIEN",.F.,"210210|")
Local cDescEvento   := SuperGetMv("ES_DESCIEN",.F.,"Ciencia da Operacao|")
Local cEvento		
Local aInfo			
Local cTeste		:= ''

If GzStrDecomp( oDocumento:TEXT, Len(oDocumento:TEXT), @cTeste )

Else
	Conout( "Erro GzStrDecomp" )
EndIf

aInfo := Separa(U_ACOMR02(oDocumento:TEXT,"TagsEvento"),"|")

//зддддддддддддддддддд©
//ЁCiencia da OperacaoЁ
//юддддддддддддддддддды
If Upper(aInfo[2]) $ Upper(cCodEvento)
	cEvento := "2"
Else
	//ЁRejeiГЦoЁ
	cEvento := "1"
EndIf             

Return cEvento 