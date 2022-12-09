#INCLUDE "Protheus.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE LOG001					"FALHA UserAuthenticate"
#DEFINE LOG002					"FALHA StartFlow"
#DEFINE LOG003					"FALHA FinalizeFlow"
#DEFINE LOG004					"FALHA FlowDetails"
#DEFINE LOG005					"FALHA ConsultReceivedExternalAction"
#DEFINE LOG006					"ERRO PARSER"
#DEFINE LOG007					"FORMULARIO NAO RECEBIDO E/OU NAO PREENCHIDO"

/*
+-----------+----------------+-------+------------------------------------------------------------------------------------------+------+-----------+
| Rotina    | EnviaCertiFlow | Autor | David Moraes	                                                                            | Data | 09.09.2014|
+-----------+----------------+-------+------------------------------------------------------------------------------------------+------+-----------+
| Descricao | Efetua o post dos PDFs ao WebService do CERTIFLOW.	   		                                                                       |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------+
| Alteracao | 08.07.2015 - Alexandre Alves - Ajuste nos logs gerados pela rotina.                                                                  |
|           +--------------------------------------------------------------------------------------------------------------------------------------+
|           | 30.07.2015 - Alexandre Alves - Mantencao na query de leitura da tabela de funionarios (SRA), com implementacao da verificacao do     |
|           | campo Departamento (RA_DEPTO), ignorando colaboradores que nao possuam alocacao em um departamento. Essa solucao tem o objetivo de   |
|           | segregar equipes que ainda nao estejam utilizando a solucao de ponto integrada ao CERTIFLOW.                                         |
|           +--------------------------------------------------------------------------------------------------------------------------------------+
|           | 02.03.2016 - A rotina passa enviar os Espelhos de Ponto em separado via CERTIFLOW. Cada colaborador terá seu espelho gerado e enviado|
|           | individualmente pelo CERTIFLOW, possibilitando evitar o represamento dos envios sempre que houver um colaborador com cadastro irregu-|
|           | lar no CERTIFLOW.                                                                                                                    |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------+
|           | 27.05.2016 - Correcao da funcao fLogaErr(), responsavel pelo tratamento (LOG) de erros de processamento. A funcao apresentava erro de|
|           | "Type Missmatch" no momento de tratar o array aLoga. Em alguns retornos dos WebServices o array apresenta mais de uma dimensão.      |
|           | Para implementar a correção foi criada a funcao fChkMens(), que tem a missão de verificar o conteudo da mensagem de erro e com base  |
|           | nesse conteudo, julgar se a mensagem se trata de erro ou retorno positivo de processamento.                                          |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------+
|           | 14.01.2019 - Remoção da verificação da tabela PAN na query prinicpal da rotina, por desuso da rotina de monitoração do envio e       |
|           | assinatura dos espelhos via CERTIFLOW.                                                                                               ||
|           +--------------------------------------------------------------------------------------------------------------------------------------+
| Uso       | Certisign Certificadora Digital S/A                                                                                                  |
+-----------+--------------------------------------------------------------------------------------------------------------------------------------+

//Atualização somente para enviar ultimos espelhos de pontos para certiflow.
*/
User Function EnviaCer()
	Local bProcesso	  := { |oSelf| U_GerPDFCF(oSelf)}

	Private aMatric   := {}
	Private aCertFlow :={}
	Private cPonMes   := ""
	Private cPerg     := "CTFLOWPON"
	Private aFalhas   := {}
	Private aLoga     := {}
	Private lDocs     := .F. //-> Flega quando ao menos um Espelho de Ponto é gerado em PDF pela rotina GeraEspelhoPDF().
	Private cAliasTB  := GetNextAlias()
	Private aLogCer	  := {}

	tNewProcess():New( "EnviaCertiFlow", "Folhas de Ponto - CERTIFLOW", bProcesso, "    Esta rotina gera os Espelhos de Ponto em PDF e os envia aos colaboradores atraves do CERTIFLOW  ", cPerg, , .F., , , .F., .F. )
Return

/*
---------------------------------------------------------------------------
| Rotina    | GerPDFCF | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Gera PDF para ser enviado para o certiflow	   		      |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/     
User Function GerPDFCF( oSelf )
	Local cFilMatDe 	:= mv_par01 //-> Filial De?
	Local cFilMatAt 	:= mv_par02 //-> Filial Até?
	Local cCentCDe  	:= mv_par03 //-> Centro de Custo De?
	Local cCentCAt  	:= mv_par04 //-> Centro de Custo Ate?
	Local cMatSit   	:= mv_par05 //-> Situações?
	Local cCodMatDe 	:= mv_par06 //-> Matricula De?
	Local cCodMatAt 	:= mv_par07 //-> Matricula Até?
	Local dDatDe    	:= mv_par08 //-> Data De?
	Local dDatAt    	:= mv_par09 //-> Data Até?
	Local cQuery       	:= ""
	Local cMV_CERFLUXO 	:= 'MV_CERFLUX'
	Local aRetPortal    := {}
	Local nRecs        	:= 0

	Private aErroLog := {}
	Private cToken   := ""
	Private aFunProc := {}
	Private aCertFlw := {}
	Private AWS      := {}

	If .NOT. GetMv( cMV_CERFLUXO,.T.)
		CriarSX6( cMV_CERFLUXO,'C','Informe o código do fluxo do Certiflow', '410')
	Endif

	cMV_CERFLUXO := ALLTRIM(GetMv( cMV_CERFLUXO,.F.))

	cPonMes := DTOS(dDatDe)+"/"+DTOS(dDatAt)

	cMatSit := AjustaSit(cMatSit)

	cQuery := "SELECT RA_MAT, RA_FILIAL, RA_DEMISSA "+CRLF
	cQuery += "FROM "+RetSqlName("SRA")+" SRA"+CRLF
	cQuery += "WHERE RA_FILIAL BETWEEN '"+cFilMatDe+"'         AND '"+cFilMatAt+"'         AND "+CRLF
	cQuery += "      RA_CC     BETWEEN '"+cCentCDe+"'          AND '"+cCentCAt+"'          AND "+CRLF
	cQuery += "      RA_MAT    BETWEEN '"+cCodMatDe+"'         AND '"+cCodMatAt+"'         AND "+CRLF
	cQuery += "      RA_REGRA   <> '99'                        AND  "+CRLF //-> REGRA 99 NÃO BATE PONTO.
	cQuery += "      RA_DEPTO   <> ' '                         AND  "+CRLF //-> SOMENTE QUEM ESTA ALOCADO EM ALGUM DEPTO, CONTROLA PONTO PELO CERTIFLOW.
	cQuery += "      RA_DEMISSA =  ' '                         AND  "+CRLF
	cQuery += "      RA_SITFOLH IN ("+cMatSit+")               AND  "+CRLF
	cQuery += "      SRA.D_E_L_E_T_ <> '*'                          "+CRLF
	cQuery += "ORDER BY RA_FILIAL, RA_MAT "+CRLF

	If Select(cAliasTB) > 0 
		(cAliasTB)->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias (cAliasTB)//"TRB"	

	Count To nRecs

	//Arquivo de controle de espelhos enviados.
	if file( "C:\temp\certiflow.txt" )
		FERASE("C:\temp\certiflow.txt")
	endif

	//Cria arquivo batch para copiar arquivos para o Itatiba.
	CriarBatch()

	(cAliasTB)->(DbGoTop())
	If (cAliasTB)->(!EOF())

		oSelf:SetRegua1( nRecs )

		While (cAliasTB)->(!EOF())

			oSelf:IncRegua1( "Gerando Espelho de Ponto..> "+(cAliasTB)->("Filial.: "+RA_FILIAL+" / Matricula.: "+RA_MAT)+"...Aguarde." )
			If oSelf:lEnd 
				Break
			EndIf  

			U_GeraEspe(	.F., ; //lTerminal
						(cAliasTB)->(RA_FILIAL), ; //cFilTerminal
						(cAliasTB)->(RA_MAT)   , ; //cMatTerminal
						(Substr(cPonMes,1,8)+Substr(cPonMes,10,8)), ; //cPerAponta
						.F.	 	   , ; //lPortal
						@aRetPortal, ; //aRetPortal
						@aFalhas   , ; //aFalhas
						@aFunProc  , ; //aFunProc
						@aCertFlow , ; //aCertFlow
						@aWS 		 ; //aWS
						)
			EnvCerFlow( oSelf )
			(cAliasTB)->(DbSkip())
		EndDo

		If !lDocs
			aAdd(aLoga,{"ENVIACERTIFLOW - FALHA NA GERACAO DOS PDFS.VERIFIQUE!"})
			fLogaErr(aLoga,1) //-> Loga erro nas tabelas do portal.
		EndIf
	Else
		aAdd(aFalhas,{"ENVIACERTIFLOW - NAO FORAM ENCONTRADOS FUNCIONARIOS A PROCESSAR. REVEJA OS PARAMETROS DA ROTINA"})
	EndIf
	(cAliasTB)->(DbCloseArea())

	If Empty(aFalhas)
		aAdd(aFalhas,{"ESPFLOW.PRW - ESPELHOS DE PONTO ENVIADOS COM SUCESSO."})
	EndIf

	EspLog() //Gera LOG do processamento.

Return(.T.)


Static Function fLogaErr(aLoga,nProc)
	/*
	---------------------------------------------------------------------------
	| Rotina    | fLogaErr   | Autor | Alexandre AS.	 | Data | 28.09.2015  |
	|-------------------------------------------------------------------------|
	| Descricao | Grava status de erro nas tabelas do portal.  				  |
	|           | aLoga => Array com os erros encontrados no processamento.   |
	|           | nProc => 1 = Proveniente de aLoga.                          |
	|           | nProc => 2 = Proveniente de aErro.                          |
	|-------------------------------------------------------------------------|
	| Uso       | Certisign Certificadora Digital S/A                         |
	---------------------------------------------------------------------------
	*/
	Local nX         := 0  
	Local nPos       := 0
	Local cMsg       := ""
	Local cMensg     := ""
	Local lNewer     := .T.
	Local cFilFun    := ""
	Local cEmailF    := ""
	Local cMatricula := ""

	For nX := 1 To Len(aLoga)	

		cFilFun    := ""
		cMatricula := ""   		

		If nProc = 2 //Baseado no aErro. 
			If Len( Alltrim(aLoga[nX]) ) == 17
				nPos       := RAT("/", aLoga[nX])
				cMatricula := SubStr(aLoga[nX],nPos+1,Len(aLoga[nX]) - nPos)
				cFilFun    := SubStr(aLoga[nX],nPos-2, 2)

				cMensg     := fChkMens( SubStr(aLoga[nX],1, nPos-3) )
				nPos       := 0
			EndIf
		Else         //Baseado no aFlahas.

			cMensg := fChkMens( aLoga[nX][1] )
			cMensg := If( !Empty(cMensg), FwNoAccent(cMensg), cMensg )

			aAdd(aFalhas,{"ENVIACERTIFLOW - "+cMensg})
		EndIf

		If !Empty(cFilFun) .And. !Empty(cMatricula) .And. !Empty(cMensg)

			BEGIN TRANSACTION

				PAN->(DbSelectArea("PAN"))
				PAN->(DbSetOrder(1))

				lNewer := PAN->(!DbSeek(xFilial("PAN")+cFilFun+cMatricula+SubStr(cPonMes,1,17)))

				PAN->(RecLock("PAN",lNewer))
				PAN->PAN_FILIAL := xFilial("PAN")
				PAN->PAN_FILMAT := cFilFun
				PAN->PAN_MAT    := cMatricula
				PAN->PAN_NOME   := POSICIONE("SRA",1,cFilFun+cMatricula,"RA_NOME")		
				PAN->PAN_STATUS := "4"   //-> Não Enviado
				PAN->PAN_PONMES := SubStr(cPonMes,1,17)
				PAN->PAN_ENCERR := "0"   //-> Processo ENCERRADO. {0=Nao;1=Sim }
				PAN->(MsUnlock())     

				PAO->(DbSelectArea("PAO"))
				PAO->(DbSetOrder(1))

				lNewer := PAO->(!DbSeek(xFilial("PAO")+cFilFun+cMatricula+SubStr(cPonMes,1,17)))

				PAO->(RecLock("PAO",lNewer))
				PAO->PAO_FILIAL := xFilial("PAN")
				PAO->PAO_FILMAT := cFilFun
				PAO->PAO_MAT    := cMatricula
				PAO->PAO_STATUS := "4"  //-> Não Enviado  

				If nProc = 2 //Baseado no aErro. 					
					cEmailF := Alltrim(POSICIONE("SRA",1,cFilFun+cMatricula,"RA_EMAIL"))
					nPos    := RAT(";", aLoga[nX])
					nPos    := If( nPos = 0, 1, nPos)
					cMsg    := "E-mail: "+ If( Empty(cEmailF)," E-MAIL NAO CADASTRADO ",cEmailF ) + " " + SubStr(aLoga[nX],nPos+1,Len(aLoga[nX]))
				Else
					cMsg    := "E-mail: "+ If( Empty(cEmailF)," E-MAIL NAO CADASTRADO ",cEmailF ) + " " + aLoga[nX][1]
				EndIf
				cMsg := If( !Empty(cMsg), FwNoAccent(cMsg), cMsg )

				aLoga := {}

				aAdd(aFalhas,{"ENVIACERTIFLOW - "+cMsg})

				PAO->PAO_OBS    := cMsg

				PAO->PAO_DATA   := DATE()
				PAO->PAO_USER   := RetCodUsr()
				PAO->PAO_PONMES := SubStr(cPonMes,1,17)
				PAO->PAO_ENCERR := "0" //Processo ENCERRADO. {0=Nao;1=Sim }

				PAO->(MsUnlock())

			END TRANSACTION
		EndIf

	Next nX


Return()

/*
---------------------------------------------------------------------------
| Rotina    | AjustaSx1     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Adiciona novas perguntas utilizadas pela rotina 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
/*
Static Function AjustaSx1(cPerg)
	Local nTamFil := TamSX3( "RA_FILIAL" )[1] 

	PutSx1( cPerg, 	"01","Filial De?","Filial De?","Filial De?","mv_ch1","C",nTamFil,0,0,"G","","SM0","","",;
	"mv_par01","","","","","","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"02","Filial Até?","Filial Até?","Filial Até?","mv_ch2","C",nTamFil,0,0,"G","","SM0","","",;
	"mv_par02","","","","","","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"03","Centro de Custo De?","Centro de Custo De?","Centro de Custo Ate?","mv_ch3","C",20,0,0,"G","","CTT","","",;
	"mv_par03","","","","","","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"04","Centro de Custo De?","Centro de Custo Ate?","Centro de Custo Ate?","mv_ch4","C",20,0,0,"G","","CTT","","",;
	"mv_par04","","","","","","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, "05","Situações?","¿De emision?","From issue date","mv_ch5",;
	"C",05,0,1,"G","fSituacao",;
	"","003","","mv_par05","","","","","","","","","","","","","","","","",,,)

	PutSx1( cPerg, 	"06","Matricula De?","Matricula De?","Matricula De?","mv_ch6","C",6,0,0,"G","","SRA","","",;
	"mv_par06","","","",""," ","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"07","Matricula Até?","Matricula Até?","Matricula Até?","mv_ch7","C",6,0,0,"G","","SRA","","",;
	"mv_par07","","","",""," ","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"08","Data De?" ,"Data De?" ,"Data De?" ,"mv_ch8","D",08,0,0,"G","NaoVazio()","","","",;
	"mv_par08","","","","","","","",;
	"","","","","","","","","",,,)

	PutSx1( cPerg, 	"09","Data Até?","Data Até?","Data Até?","mv_ch9","D",08,0,0,"G","NaoVazio()","","","",;
	"mv_par09","","","","","","","",;
	"","","","","","","","","",,,)
Return
*/

/*
---------------------------------------------------------------------------
| Rotina    | AjustaSit     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Ajusta string da situação para a query    				  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function AjustaSit(cSituacao)
	Local cRet := ""
	Local cSit := cSituacao 
	local nX := 0

	For nX := 1 To Len(cSit)
		cRet += If( Subs(cSit,nX,1) <> "*", "'" + Subs(cSit,nX,1) + "',", "" )
	Next nX

	cRet := Subs( cRet, 1, Len(cRet) -1 )

Return cRet

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} ParserCe
Função que realiza o parser do XML, ou seja, o transforma em objeto a partir de seus
nós.

@param		Número do método que deu origem ao XML
@param		Objeto instanciado da classe Certiflow
@author		David Araujo de Moraes
@version   	P10
@since      23/01/2013
/*/
//-------------------------------------------------------------------------------------
User Function ParserCe(nOpcX,oSelf,cXML, cToken, aRet, cFunProc)

	Local lRet					:= .F.
	Local cErro			   		:= ""
	Local cWarning		   		:= ""
	Local oRetXML		   		:= Nil
	Local oChildXML		   		:= Nil                 
	Local oNodXML		   		:= Nil
//	Local nX					:= 0
//	Local lBlind				:= IsBlind()		//Controla se deve exibir modais de interação
//	Local aDetails				:= {}

	Default nOpcX				:= 0
	Default cXML				:= ''
	Default cToken              := ''
	Default aRet                := {}
	Default cFunProc            := ""

	oRetXML := XMLParser(cXML,"_", @cErro, @cWarning)		//Transforma o XML de retorno em objeto

	If !Empty(AllTrim(cErro)) .Or. ValType(oRetXML) != "O"

		aAdd(aFalhas,{"ENVIACERTIFLOW - "+LOG006+" "+;
		If(!Empty(cErro)          ,cErro,;
		If(ValType(oRetXML) != "O",cFunProc+" - Falhou na conversão dos dados do XML em Objeto"+cWarning,"."));
		})
		If nOpcX == 2
			aAdd(aRet, cFunProc )
		EndIf
	Else
		oChildXML := XmlGetchild(oRetXML,XmlChildCount(oRetXML))

		If Upper(AllTrim(oChildXML:REALNAME)) == "WSRESPONSE"		//Verifica se o nó existente contém a resposta do web service Certiflow
			If (oNodXML := XmlChildEx(oChildXML,"_ERROR")) != Nil		//Verifica se o retorno contém um erro
				aAdd(aFalhas,{"ENVIACERTIFLOW - "+LOG006+" - "+oNodXML:_CODE:TEXT +" "+ oNodXML:_MESSAGE:TEXT+" - Falha no retorno de resposta do CERTIFLOW. Execute novamente a rotina."/*+ oNodXML:_CODE:TEXT +" "+ oNodXML:_MESSAGE:TEXT*/})
			Else
				Do Case
					Case nOpcX == 1		//Autenticação
					If (oNodXML := XmlChildEx(oChildXML,"_TOKENAUTHENTICATE")) != Nil
						oSelf:CAUTHENTICATETOKEN := AllTrim(oNodXML:TEXT)
						cToken :=  AllTrim(oNodXML:TEXT)
						lRet := .T.
					EndIf
					Case nOpcX == 2		//Encerra Processo
					aRet := {}
					aRet := oChildXML:_XMLELEMENT
					lRet := .T.
				EndCase
			EndIf
		EndIf

	EndIf

	If oRetXML != Nil
		FreeObj(oRetXML)		//Elimina a instancia do objeto utilizado
	EndIf

	If oChildXML != Nil
		FreeObj(oChildXML)		//Elimina a instancia do objeto utilizado
	EndIf

	If oNodXML != Nil
		FreeObj(oNodXML)		//Elimina a instancia do objeto utilizado
	EndIf

Return lRet

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} GeraLog
Função que gera log toda vez que ocorre alguma falha/erro.

@param		Objeto instanciado da classe Certiflow
@author		Renan Guedes Alexandre
@version   	P10
@since      20/03/2013
/*/
//-------------------------------------------------------------------------------------
/*
Static Function GeraLog(oSelf,cMensagem)

//	Local aSelf					:= ClassDataArr(oSelf)
//	Local nX					:= 0
	Local cSvcError		   		:= GetWSCError()		//Resumo do erro
	Local cSoapFCode	   		:= GetWSCError(2)		//Soap Fault Code
	Local cSoapFDescr	   		:= GetWSCError(3)		//Soap Fault Description

	Default cMensagem			:= ""

	If !Empty(AllTrim(cSoapFDescr))
		AutoGrLog("Data: " + DtoC(Date()) + " - " + Time())
		AutoGrLog("Fluxo Certiflow: " + oSelf:CFLOWCODE)
		AutoGrLog(cSoapFCode)
		AutoGrLog(cSoapFDescr)
		AutoGrLog("")
	ElseIf !Empty(AllTrim(cSvcError))
		AutoGrLog("Data: " + DtoC(Date()) + " - " + Time())
		AutoGrLog("Fluxo Certiflow: " + oSelf:CFLOWCODE)
		AutoGrLog(cSvcError)
		AutoGrLog("")
	EndIf

	If !Empty(AllTrim(cMensagem))
		AutoGrLog("Data: " + DtoC(Date()) + " - " + Time())
		AutoGrLog("Fluxo Certiflow: " + oSelf:CFLOWCODE)
		AutoGrLog("Mensagem" + cMensagem)
		AutoGrLog("")
	EndIf

Return
*/

Static Function EspLog()
	/*-----------------------------------------------------------------------------------------------+
	| Rotina.: EspLog()   | Gera LOG de todo o processamento da rotina e as rotinas dependentes.     |
	| Autor.: Alexandre AS|                                                                          |
	| TOTVS Serra do Mar. |                                                                          |
	| Data.: 15/07/2015.  |                                                                          |
	+---------------------+--------------------------------------------------------------------------+
	*/
	Local aTitle := {}
	Local aLog   := {}
	Local nX     := 0

	aAdd(aTitle,"FUNCAO - DESCRICAO DA FALHA")

	For nX := 1 To Len(aFalhas)
		aAdd(aLog,aFalhas[nX])
	Next

	fMakeLog(aLog,aTitle,,,"ENVIACERTIFLOW","LOG DE PROCESAMENTO - FOLHA DE PONTO CERTIFLOW","G","L",,.F.)

Return



Static Function fChkMens(cTexto)
	/*----------------------------+------------------------------------------------------------------+
	| Rotina.: fChkMens(cTexto)   | Verifica conteudo da mesagem de retorno e classifica se eh erro. |
	| Autor.: Alexandre AS        |                                                                  |
	| TOTVS Serra do Mar.         |                                                                  |
	| Data.: 27/05/2016.          |                                                                  |
	+-----------------------------+------------------------------------------------------------------+
	*/
	Local nX       := 0
	Local nNum     := 0
	Local nLet     := 0
	Local cNumbers := "0*1*2*3*4*5*6*7*8*8"
	Local cLetters := "a*A*b*B*c*C*d*D*e*E*f*F*g*G*h*H*i*I*j*J*k*K*l*L*m*M*n*N*o*O*p*P*q*Q*r*R*s*S*t*T*u*U*v*V*x*X*y*Y*z*Z"

	For nX := 1 To Len(cTexto)
		nNum := If( Subs(cTexto,nX,1) $ cNumbers, (nNum+1), nNum)
		nLet := If( Subs(cTexto,nX,1) $ cLetters, (nLet+1), nLet)
	Next

	cTexto := If( (nNum > 0 .And. nLet = 0), "", cTexto)

Return(cTexto)

Static Function EnvCerFlow( oSelf )
	local nY := 0
	local nX := 0
	Local aErro        	:= {}
	Local cEspLoc      	:= GetSrvProfString( "RootPath" , "" ) + "\certiflow_protheus"
	Local cFunProc     	:= ""
	Local cMV_CERFLUXO 	:= 'MV_CERFLUX'

	If .NOT. GetMv( cMV_CERFLUXO,.T.)
		CriarSX6( cMV_CERFLUXO,'C','Informe o código do fluxo do Certiflow', '410')
	Endif

	cMV_CERFLUXO := ALLTRIM(GetMv( cMV_CERFLUXO,.F.))

	//-> Estancimanto e autencicação.
	oWsdl := WSFluxosExternos():New()

	xRet := oWsdl:UserAuthenticate()
	varinfo("xRet", xRet)
	varinfo("oWsdl", oWsdl)
	If !xRet .or. empty(xRet)
		aAdd(aLoga,{"ENVIACERTIFLOW - FALHA DE AUTENTICACAO PELO METODO oWsdl:UserAuthenticate().VERIFIQUE!"})
		fLogaErr(aLoga,1) //-> Loga erro nas tabelas do portal.

	ElseIf lDocs

		oWsdl:oWSparameters      := FluxosExternos_ArrayOfString():NEW()
		oWsdl:cflowCode          := cMV_CERFLUXO
		oWsdl:CAUTHENTICATETOKEN := cToken

		varinfo("cMV_CERFLUXO", cMV_CERFLUXO)
		varinfo("cToken", cToken)

		BEGIN TRANSACTION

			oSelf:SetRegua2( Len(aCertFlow) )

			For nX := 1 To Len(aCertFlow)

				oSelf:IncRegua2( "Enviando Espelho de Ponto..> "+AllTrim( Str(nX) )+" ...Aguarde." )
				If oSelf:lEnd 
					Break
				EndIf  

				aCertFlw := {}      
				aAdd( aCertFlw, aCertFlow[nX] )

				cFunProc := AllTrim( aFunProc[nX][01] + aFunProc[nX][02] )

				If !U_ParserCe(1,oWsdl,@oWsdl:CUSERAUTHENTICATERESULT, @cToken, cFunProc)  
					aAdd(aLoga,{"ENVIACERTIFLOW - Fil./Mat.: "+aFunProc[nX][01] +"/"+ aFunProc[nX][02]+" FALHA NA AUTENTICAÇÃO DO ACESSO AO CERTIFLOW.VERIFIQUE!"})
					fLogaErr(aLoga,1) //-> Loga erro nas tabelas do portal.
					nX := Len(aCertFlow)
				EndIf

				//string com o email do funcionário, nome do arquivo, matrícula
				//do funcionário, período e o código do controle
				oWsdl:oWSparameters:cString := aCertFlw

				xRet := oWsdl:StartFlowUploadingFile()

				U_ParserCe( 2, oWsdl, @oWsdl:CSTARTFLOWUPLOADINGFILERESULT, @cToken, @aErro, cFunProc)

				If !Empty(aErro)
					If ValType(aErro) == "O"
						aRet  := aErro
						aErro := {}
						aAdd(aErro, aRet:TEXT +" - "+  aFunProc[nX][01] +"/"+ aFunProc[nX][02])

					ElseIf ValType(aErro) == "A"
						aRet := {}
						For nY := 1 To Len(aErro)
							If ValType(aErro[nY]) == "O" .And. Empty(aRet)
								aAdd(aRet, aErro[nY]:TEXT +" - "+ aFunProc[nX][01] +"/"+ aFunProc[nX][02] )
							EndIf 
						Next nY
						aErro := aRet
					EndIf
				EndIf

				u_GerarArq( "EnviouCertiflow;" + aCertFlw[1], "C:\temp\certiflow.txt" )

				If !Empty(aErro)
					fLogaErr(aErro,2) //-> Loga erro nas tabelas do portal.
					aErro := {}
				EndIf

			Next nX
			FreeObj(oWsdl)
			//-> Apagando PDF gravado no PROTHEUS_DATA\CERTIFLOW_PROTHEUS\.
			For nX := 1 To Len(aFunProc)
				FErase( cEspLoc +"\"+ AllTrim(aFunProc[nX][01] + aFunProc[nX][02])+".pdf" )
			Next nX 

			aCertFlw  :={}
			aFunProc  :={}
			aCertFlow :={}

		END TRANSACTION
	EndIf
Return

static function CriarBatch()
	local cFile := "c:\temp\certiflow.bat"
	local cText := ""
	cText := "DEL \\itatiba\protheus_data\certiflow_protheus\%~n1%~x1"+CRLF
	cText += "COPY %1 \\itatiba\protheus_data\certiflow_protheus\%~n1%~x1"+CRLF
	if file( cFile )
		FERASE( cFile )
	endif
	MEMOWRITE( cFile, cText )
return
