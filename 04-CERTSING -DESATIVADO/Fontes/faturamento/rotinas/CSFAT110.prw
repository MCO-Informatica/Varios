#include 'protheus.ch'
#include 'parmtype.ch'

//+-------------------------------------------------------------------+
//| Rotina | CSFAT110 | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Interface visual para controle dos códigos de rastreio  
//|        | que não foram enviados para o Checkout
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
user function CSFAT110()

	Local cArqTrb, cIndice1, cIndice2, cIndice3
	Local i
	Private oMBrowse
	Private aRotina		:= MenuDef()
	Private cCadastro 	:= "Manutenção de Código de Rastreio"
	Private aCampos	:= {}, aSeek := {}, aDados := {}, aValores := {}, aFieFilter := {}
	Private lJob	:= .F.
	
	//Array contendo os campos da tabela temporária
	AAdd(aCampos,{"TR_XNPSITE" 	, "C" , TamSX3("C5_XNPSITE")[1] , TamSX3("C5_XNPSITE")[2]})
	AAdd(aCampos,{"TR_NUM" 		, "C" , TamSX3("C5_NUM")[1] 	, TamSX3("C5_NUM")[2]})
	AAdd(aCampos,{"TR_XCODRAS" 	, "C" , TamSX3("C5_XCODRAS")[1] , TamSX3("C5_XCODRAS")[2]})
	AAdd(aCampos,{"TR_XRASTRE"	, "C" , TamSX3("C5_XRASTRE")[1] , TamSX3("C5_XRASTRE")[2]})
	AAdd(aCampos,{"TR_RECNO"	, "N" , 18 , 0})	
	
	//Antes de criar a tabela, verificar se a mesma já foi aberta
	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif
	
	//Criar tabela temporária
	cArqTrb   := CriaTrab(aCampos,.T.)
	
	//Definir indices da tabela
	cIndice1 := Alltrim(CriaTrab(,.F.))
	cIndice2 := cIndice1
	cIndice3 := cIndice1

	cIndice1 := Left(cIndice1,5)+Right(cIndice1,2)+"A"
	cIndice2 := Left(cIndice2,5)+Right(cIndice2,2)+"B"
	cIndice3 := Left(cIndice3,5)+Right(cIndice3,2)+"C"

	If File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	EndIf

	If File(cIndice2+OrdBagExt())
		FErase(cIndice2+OrdBagExt())
	EndIf

	If File(cIndice3+OrdBagExt())
		FErase(cIndice3+OrdBagExt())
	EndIf
	
	//Criar e abrir a tabela
	dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)
	
	/*Criar indice*/
	IndRegua("TRB", cIndice1, "TR_NUM"		,,, "Indice Número Pedido")
	IndRegua("TRB", cIndice2, "TR_XNPSITE"	,,, "Indice Pedido Site")
	IndRegua("TRB", cIndice3, "TR_XCODRAS"	,,, "Indice Código Rastreio")
	dbClearIndex()
	dbSetIndex(cIndice1+OrdBagExt())
	dbSetIndex(cIndice2+OrdBagExt())
	dbSetIndex(cIndice3+OrdBagExt())
	
	/*abre a SC5 para popular tabela*/
	MsAguarde({|| consultaSC5()}, "Carregando dados", "Aguarde o carregamento dos dados.",.F.)
	
	/*popular a tabela*/
	MsAguarde({|| atualizaTRB()}, "Atualizando tabela", "Aguarde enquanto a tabela é atualizada",.F.)
	
	dbSelectArea("TRB")
	TRB->(DbGoTop())

	//Campos que irão compor o combo de pesquisa na tela principal
	Aadd(aSeek,{"Pedido"   		, {{"","C",TamSX3("C5_NUM")[1]		,TamSX3("C5_NUM")[2]		, "TR_NUM"  	,"@!"}}, 1, .T. } )
	Aadd(aSeek,{"Pedido Site"	, {{"","C",TamSX3("C5_XNPSITE")[1]	,TamSX3("C5_XNPSITE")[2]	, "TR_XNPSITE"	,"@!"}}, 2, .T. } )
	Aadd(aSeek,{"Cód. Rastreio" , {{"","C",TamSX3("C5_XCODRAS")[1]	,TamSX3("C5_XCODRAS")[2]	, "TR_XCODRAS"	,"@!"}}, 3, .T. } )
	
	//Campos que irão compor a tela de filtro
	Aadd(aFieFilter,{"TR_NUM"		, "Pedido"   	, "C", TamSX3("C5_NUM")[1]	  , TamSX3("C5_NUM")[2]		,"@!"})
	Aadd(aFieFilter,{"TR_XNPSITE"	, "Pedido Site"	, "C", TamSX3("C5_XNPSITE")[1], TamSX3("C5_XNPSITE")[2]	,"@!"})
	Aadd(aFieFilter,{"TR_XCODRAS"	, "Cod Rastreio", "C", TamSX3("C5_XCODRAS")[1], TamSX3("C5_XCODRAS")[2]	,"@!"})
	
	oMBrowse := FWmBrowse():New()
	oMBrowse:SetAlias( "TRB" )
	oMBrowse:SetDescription( cCadastro )
	oMBrowse:SetSeek(.T.,aSeek)
	oMBrowse:SetTemporary(.T.)
	oMBrowse:SetLocate()
	oMBrowse:SetUseFilter(.T.)
	oMBrowse:SetDBFFilter(.T.)
	oMBrowse:SetFilterDefault( "Empty(TR_XRASTRE)" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
	oMBrowse:SetFieldFilter(aFieFilter)
	oMBrowse:DisableDetails()
	
	//Legenda da grade, é obrigatório carregar antes de montar as colunas
	oMBrowse:AddLegend("!Empty(TR_XCODRAS) .And. !Empty(TR_XRASTRE)", "ENABLE", "Código de Rastreio Integrado")
	oMBrowse:AddLegend("!Empty(TR_XCODRAS) .And. Empty(TR_XRASTRE)", "DISABLE", "Código de Rastreio Não Integrado")	
		
	//Detalhes das colunas que serão exibidas
	oMBrowse:SetColumns(MontaColunas("TR_NUM"		,"Pedido"			,01,"@!",0,TamSX3("C5_NUM")[1]		,TamSX3("C5_NUM")[2]))
	oMBrowse:SetColumns(MontaColunas("TR_XNPSITE"	,"Pedido Site"		,02,"@!",1,TamSX3("C5_XNPSITE")[1]	,TamSX3("C5_XNPSITE")[2]))
	oMBrowse:SetColumns(MontaColunas("TR_XCODRAS"	,"Cod. Rastreio"	,03,"@!",1,TamSX3("C5_XCODRAS")[1]	,TamSX3("C5_XCODRAS")[2]))
	oMBrowse:Activate()
	
	If !Empty(cArqTrb)
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		cArqTrb := ""
		TRB->(DbCloseArea())
		delTabTmp('TRB')
    	dbClearAll()
	Endif
    	
Return

//+-------------------------------------------------------------------+
//| Rotina | consultaSC5 | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Query na SC5 apenas para permitir a apresentação do   
//|        | MsAguarde na tela do usuário.
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function consultaSC5()

	If Select("TMPSC5") > 0
		TMPSC5->(dbCloseArea())
	EndIf
	
	BeginSql Alias "TMPSC5"
		SELECT C5_NUM, C5_XNPSITE, C5_XCODRAS, C5_XRASTRE, R_E_C_N_O_ 
		FROM SC5010
		WHERE C5_FILIAL = ' '
		AND   C5_XCODRAS != ' '
		AND   C5_XNPSITE != ' '
		AND   D_E_L_E_T_ = ' '
		ORDER BY C5_NUM
	EndSql
	
Return

//+-------------------------------------------------------------------+
//| Rotina | atualizaTRB | Autor | null		| Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Função auxiliar para atualização dos dados a serem   
//|        | exibidos no MBrowse
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function atualizaTRB()

	While TMPSC5->(!EoF())
		If RecLock("TRB",.T.)
			TRB->TR_XNPSITE	:= TMPSC5->C5_XNPSITE
			TRB->TR_NUM		:= TMPSC5->C5_NUM
			TRB->TR_XCODRAS	:= TMPSC5->C5_XCODRAS
			TRB->TR_XRASTRE	:= TMPSC5->C5_XRASTRE
			TRB->TR_RECNO	:= TMPSC5->R_E_C_N_O_
			TRB->(MsUnLock())
		Endif
		TMPSC5->(dbSkip())
	EndDo
	
	TMPSC5->(dbCloseArea())
	
Return

//+-------------------------------------------------------------------+
//| Rotina | MontaColunas | Autor | null		| Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Função auxiliar para montagem das colunas que serão   
//|        | utilizadas na exibição do mBrowse
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function MontaColunas(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData 	:= {||}
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0
	
	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf
	
	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}

//+-------------------------------------------------------------------+
//| Rotina | MenuDef | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Função auxiliar para criação do menu no mBrowse  
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function MenuDef()
	Local aArea		:= GetArea()
	Local aRotina 	:= {}
	Local aRotina1 := {}
	
	AADD(aRotina, {"Integrar Rastreio"	, "U_CSFT110R"		, 0, 3, 0, Nil })
	AADD(aRotina, {"Lote Pedido Site"	, "U_CSFT110L"		, 0, 3, 0, Nil })
	AADD(aRotina, {"Legenda"			, "U_CFT110LEG"		, 0,11, 0, Nil })
	
Return( aRotina )

//+-------------------------------------------------------------------+
//| Rotina | CSFT110R | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Rotina intermediária que chama a função CSFT100Run  
//|        | para permitir mensagem de aguarde e atualização da tabela
//|        | temporária.	
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFT110R()
	
	Local lRet := .F.
	
	MsAguarde({|| lRet := CSFT100Run({TRB->TR_RECNO})}, "Integração Checkout", "Enviando Código de Rastreio para Checkout",.F.)
	
	If lRet
		RecLock("TRB",.F.)
			TRB->TR_XRASTRE := "S"
		TRB->(MsUnlock())
		
		/*abre a SC5 para popular tabela*/
		//MsAguarde({|| consultaSC5()}, "Carregando dados", "Aguarde o carregamento dos dados.",.F.)
		
		/*popular a tabela*/
		//MsAguarde({|| atualizaTRB()}, "Atualizando tabela", "Aguarde enquanto a tabela é atualizada",.F.)
		
		oMBrowse:Refresh()
		
	EndIf

Return

//+-------------------------------------------------------------------+
//| Rotina | CSFT110L | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para processar múltiplos pedidos site na integra-  
//|        | ção com o Checkout.
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSFT110L()

	Local aPergs 	:= {}
	Local aRet 		:= {}
	Local aPedidos 	:= {}
		
	Private lForca 	:= .F.
	Private lJob	:= .F.
	
	aAdd( aPergs ,{11,"Pedido Site"		,""			,'.T.','.T.',.F.})	
	
	If !ParamBox(aPergs ,"Parametros ",aRet)
		Alert("O processamento foi cancelado!")
		Return
	EndIf
	
	aRet[1] := Iif(Substr(aRet[1] ,len(aRet[1] ),1)==",",Substr(aRet[1] ,1,len(aRet[1])-1),aRet[1])
	
	//Cria um array para não estourar a quantidade de pedidos
	aPedidos := StrToArray(aRet[1],chr(13)+chr(10))
	
	//Chama processamento da rotina
	Processa({|| CSFT100Run(aPedidos)},"Processando Pedidos","Aguarde",.F.)
	
return

//+-------------------------------------------------------------------+
//| Rotina | CSFR100Run | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Integra o código de rastreio ao Checkout em sincronismo  
//|        | com a impressão da etiqueta
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function CSFT100Run(aPedidos)

	Local cJson 		:= ""
	Local cSvcError 	:= ""
	Local cSoapFCode	:= ""
	Local cSoapFDescr	:= ""
	Local cMSG			:= ""
	Local lOk			:= .F.
	Local lErro			:= .T.
	Local oWsObj		:= Nil
	Local oWsRes		:= Nil
	Local aLog			:= {}
	Local Ni			:= 0
	Local cError		:= ""
	Local cWarning		:= ""

	dbSelectArea("PAG")
	PAG->(dbSetOrder(3)) //PAG_FILIAL + PAG_CODPED + PAG_ENTREG
	
	dbSelectArea("SC5")

	For Ni := 1 To Len(aPedidos)
		
		lOk 		:= .F.
		cMsg		:= ""
		lErro 		:= .T.
		cJson 		:= ""
		cError		:= ""
		oWsObj 		:= Nil
		oWsRes		:= Nil
		cWarning	:= ""
		cSvcError	:= ""
		cSoapFCode	:= ""
		cSoapFDescr	:= ""
		
		SC5->(dbGoTo(aPedidos[Ni]))
		
		If PAG->(dbSeek(xFilial("PAG") + SC5->C5_NUM))
		
			Conout("[CSFT100Run] Pedido: " + SC5->C5_NUM + "/Ped Site: " + SC5->C5_XNPSITE)
			
			//Instancia objeto para envio de mensagem para o Checkout 
			oWsObj := WSVVHubServiceService():New()
					
			//Monta mensagem Json para envio
			cJson := '{"pedido":'+ Alltrim( SC5->C5_XNPSITE ) + ',"rastreamento":"' + SC5->C5_XCODRAS + '"}'
			
			Conout("[CSFT110JOB] JSON: " + cJson)
			
			//Invoca método para envio de mensageria
			lOk := oWsObj:sendMessage( "NOTIFICA-ENTREGA-PEDIDO", cJson )
	
			//Trata retornos
			cSvcError   := GetWSCError()  //-- Resumo do erro
			cSoapFCode  := GetWSCError(2) //-- Soap Fault Code
			cSoapFDescr := GetWSCError(3) //-- Soap Fault Description
	
			//Em caso de erro, carrega informações do erro
			If !Empty( cSvcError ) .Or. !Empty( cSoapFCode )
				lOk 	:= .F.
				cMSG	:= cSvcError + ' ' + cSoapFCode + ' ' + cSoapFDescr
			EndIf
					
			//Se o processamento foi bem sucedido
			If lOk
			
				//Transforma o XML de retorno em Objeto
				oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
				
				//Verifica se a resposta contém o retorno de sucesso esperado
				If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
					If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
						
						RecLock("SC5",.F.)
							SC5->C5_XRASTRE := "S"
						SC5->(MsUnlock())
					
						cMSG := "NOTIFICA-ENTREGA-PEDIDO com código de rastreamento enviada ao Hub com sucesso"
						U_GTPutOUT( SC5->C5_XNPSITE,;
									"Q",;
									SC5->C5_XNPSITE,;
									{ "VNDA560", { .T., "M00001", SC5->C5_XNPSITE, cMSG } },;
									SC5->C5_XNPSITE )
						lErro := .F.
					EndIf
				EndIf
						
			EndIf
	
			//Se o processamento foi terminado com erro na integração do WebService
			IF lErro					
				cMSG := "Inconsistência: " + cMSG 
				U_GTPutOUT( SC5->C5_XNPSITE,"Q",SC5->C5_XNPSITE,{ "VNDA560", { .F., "E00024", SC5->C5_XNPSITE, cMSG } },SC5->C5_XNPSITE )
			EndIF
			
		Else
			cMSG := "Pedido não posssui código de rastreio na PAG."
		EndIf
		
		Conout("[CSFT110JOB] " + SC5->C5_XNPSITE + ": " + cMSG)
		aAdd(aLog, SC5->C5_XNPSITE, cMSG)
		
		FreeObj(oWsRes)
		FreeObj(oWsObj)
		
	Next
	
	gravaLog(aLog)
	
Return !lErro

//+-------------------------------------------------------------------+
//| Rotina | CSFT110JOB | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Job que filtra pedidos com código de rastreio que  
//|        | não tenham sido integrados com o Checkout
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+	
User Function CSFT110JOB(aParam)

	Local cJobEmp	:= Iif( aParam == NIL, "01" , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, "02" , aParam[ 2 ] )
	Local dDataMin	:= CTOD("//")	
	Local aPedidos	:= {}
	Local cSerie	:= ""
	Local nDtMin	:= 0

	Private lJob	:= ( Select( "SX6" ) == 0 )
	
	//Se não for Job, chama a rotina com interface visual
	//Senão, prepara o ambiente para execução
	If !lJob
		Conout("[CSFT110JOB] Rotina não está rodando em Job. Chamando interface visual.")
		U_CSFAT110()
		Return
	Else
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
		Conout("[CSFT110JOB] Ambiente carregado.")
	EndIf

	//Range de data a partir de n dias do parâmetro
	//MV_XDTRAST. Valor padrão 30 dias.
	nDtMin	 := GetNewPar("MV_XDTRAST",0)
	dDataMin := dDataBase - nDtMin
	
	//Para filial 02, usa série 2 (São Paulo)
	//Para filial 01, usa série 3 (Rio de Janeiro)
	If cJobFil == "02"
		cSerie := Padr("2",TamSX3("C6_SERIE")[1])
	ElseIf cJobFil == "01"
		cSerie := Padr("3",TamSX3("C6_SERIE")[1])
	Else
		Conout("[CSFT110JOB] Parâmetro de filial incorreto.")
		Return
	EndIf
	
	If Select("TMPRASTREIO") > 0
		TMPRASTREIO->(dbCloseArea())
	EndIf

	//Busca Pedido de Venda com código de rastreio não integrado ao Checkout.
	BeginSql Alias "TMPRASTREIO"
		SELECT R_E_C_N_O_ FROM %Table:SC5% 
		WHERE	C5_FILIAL = %xFilial:SC5%
			AND C5_EMISSAO >= %Exp:DTOS(dDataMin)%
			AND C5_XCODRAS != ' '
			AND C5_XRASTRE = ' '
			AND C5_XNPSITE != ' '
			AND SC5010.D_E_L_E_T_ = ' ' 
	EndSql
	
	Conout("[CSFT110JOB] " + getLastQuery()[2])
	
	//Captura os pedidos para um array
	While TMPRASTREIO->(!EoF())
		aAdd(aPedidos, TMPRASTREIO->R_E_C_N_O_)
		Conout("[CSFT110JOB] Pedido RECNO: " + cValToChar(TMPRASTREIO->R_E_C_N_O_))
		TMPRASTREIO->(dbSkip())
	EndDo
	
	If Len(aPedidos) > 0
		
		Conout("[CSFT110JOB] Chamando rotina para disparo das mensagerias.")
	
		//Rotina estática de processamento
		CSFT100Run(aPedidos)
	Else
		gravaLog({"Sem registros para processamento."})
		Conout("[CSFT110JOB] Não há registros para processamento. Encerrando rotina.")
	EndIf

Return

//+-------------------------------------------------------------------+
//| Rotina | gravaLog | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Rotina auxiliar para gravação de LOG em arquivo e envio  
//|        | por e-mail (JOB) ou apresentação no Notepad do usuário
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function gravaLog(aLog)

	Local nHdl 		:= 0
	Local cFileLog	:= "CSFT110_" + StrTran(DtoS(Date()),"/","") + StrTran(Time(),":","") + ".log"
	Local cPath		:= ""
	Local Ni		:= 0
	Local cTempPath := Iif(!lJob,GetTempPath(),"")
	
	Conout("[CSFAT110] Tentando gravar arquivo: " + cPath + cFileLog)
	
	nHdl := fCreate(cPath + cFileLog)
	
	If nHdl == -1
		Conout("[CSFAT110] Não foi possível gravar o arquivo de log.")
		Return
	EndIf
	
	For Ni := 1 To Len(aLog)
		fWrite(nHdl, aLog[Ni])
	Next
	
	fClose(nHdl)
	
	Conout("[CSFAT110] Arquivo de log gravado.")
	
	If !lJob
		CpyS2T(cPath + cFileLog, cTempPath)
		ShellExecute("Open","%WINDIR%\notepad.exe", cTempPath + cFileLog, "C:\",1)
	Else
		Conout("[CSFAT110] Disparando e-mail.")
		FSSendMail( "sistemascorporativos@certisign.com.br", "Log de Processamento - Código de Rastreio", "Anexo pedidos processados no dia " + DTOC(dDataBase), GetSrvProfString('Startpath','') + cFileLog )
	EndIf
	
	FErase(cFileLog)
	
Return

//+-------------------------------------------------------------------+
//| Rotina | CFT110LEG | Autor | null			  | Data | 27.07.2020 
//+-------------------------------------------------------------------+
//| Descr. | Função auxiliar para montagem e exibição da Legenda  
//|        | do MBrowse
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CFT110LEG()

	Local aCores := {}

	aAdd(aCores, {"!Empty(TR_XCODRAS) .And. !Empty(TR_XRASTRE)", "ENABLE", "Código de Rastreio Integrado"})
	aAdd(aCores, {"!Empty(TR_XCODRAS) .And. Empty(TR_XRASTRE)", "DISABLE", "Código de Rastreio Não Integrado"})
	
	BrwLegenda('Código de Rastreio','Legenda',aCores)

Return

/*Função antiga*/
/*Static Function CSFT100Run(aPedidos)

	Local Ni 		:= 0
	Local aAreaSC6	:= {}
	Local aAreaSC5	:= {}
	Local aAreaSF2	:= {}
	Local aAreaSD2	:= {}
	Local aLog		:= {}
	Local cMsgLog	:= ""

	dbSelectArea("SC6")
	dbSelectArea("SC5")
	dbSelectArea("SF2")
	dbSelectArea("SD2")

	SC5->(dbOrderNickname("PEDSITE"))
	SC6->(dbSetOrder(1))
	SF2->(dbSetOrder(1))
	SD2->(dbSetOrder(3))
	
	For Ni := 1 To Len(aPedidos)

		aAreaSC6 := {}
		aAreaSC5 := {}
		aAreaSF2 := {} 
		aAreaSD2 := {}
		cMsgLog	 := ""		
	
		//Localiza o pedido de venda a partir do Pedido Site
		If SC5->(dbSeek(xFilial("SC5") + aPedidos[Ni]))
		
			//Localiza os itens pedido de venda a partir do cabeçalho SC5
			If SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
			
				//Enquanto for o mesmo pedido
				While SC6->(!EoF()) .And. SC6->C6_FILIAL + SC6->C6_NUM == SC5->C5_FILIAL + SC5->C5_NUM
					
					//Para operação DELIVERY (01), com Nota Fiscal emitida e série 2 (SP) ou 3 (RJ)
					If SC6->C6_XOPER == "01" .And. !Empty(SC6->C6_NOTA) .And. AllTrim(SC6->C6_SERIE) $ "2\3" 
					
						//String Log Auxiliar
						cMsgLog := "Pedido " + aPedidos[Ni] + ";" 
					
						//Posiciona na NF
						If SF2->(dbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE))
						
							//Caso o espelho já foi gerado, pergunta se deve forçar nova geração
							If !Empty(SC6->C6_XNFHRD) 
								If lJob .Or. MsgYesNo("A NF já foi impressa para o pedido. Deseja reimprimir e reintegrar?")
								
									cMsgLog += "Link NF antigo: " + SC6->C6_XNFHRD + ";"
								 
									//Limpa o campo de link do espelho da NF
									RecLock("SC6",.F.)
										SC6->C6_XNFHRD := ""
									SC6->(MsUnlock())
									
									RecLock("SC5",.F.)
										SC5->C5_XFLAGHW := ""
									SC5->(MsUnlock())
								Else
									Exit
								EndIf
							EndIf
							
							//Posiciona no item da NF
							SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE))
					
							//Armazena a área pois no GARR010 altera posicionamentos e indices
							aAreaSC6 := SC6->(GetArea())
							aAreaSC5 := SC5->(GetArea())
							aAreaSF2 := SF2->(GetArea())
							aAreaSD2 := SD2->(GetArea())
														
							//Realiza a impressão da NF e aguarda o retorno 
							//aRetGR010 := StartJob("U_GARR010",getEnvServer(),.T.,{.T.})
							aRetGR010 := U_GARR010({.T.})
							
							//Se o retorno não for True, recupera a mensagem de erro
							If aRetGR010[1]
								cMsgLog += "NF impressa;"
							Else
								cMsgLog += "Falha na impressão: " + aRetGR010[4]
								aAdd(aLog, cMsgLog)
								Alert("Saindo")
								Exit
							EndIf
							
							//Recupera as áreas após o processamento do GARR010
							RestArea(aAreaSC6)
							RestArea(aAreaSC5)
							RestArea(aAreaSF2)
							RestArea(aAreaSD2)
							
							Alert("Chama VNDA330")
							
							//Chama a rotina de integração da mensageria, informando a data a ser considerada
						  	StartJob("U_VNDA330",getEnvServer(),.T.,{cEmpAnt,cFilAnt}, aPedidos[Ni], DTOS(SC5->C5_EMISSAO))
						  	
						  	cMsgLog += "Mensageria entregue para o Checkout"
						  	
						  	aAdd(aLog, cMsgLog)
						
						ElseIf xFilial("SF2") != cFilAnt
							If !lJob
								MsgStop("Nota Fiscal gerada em outra filial para o pedido " + aPedidos[Ni])
							EndIf
							Exit
						Else
							If !lJob
								MsgStop("Nota Fiscal para o pedido " + aPedidos[Ni] + " não encontrada.")
							EndIf
							Exit
						EndIf
					EndIf
					
					SC6->(dbSkip())
				EndDo
			Else
				If !lJob
					MsgStop("Pedido " + aPedidos[Ni] + "não encontrado.")
				EndIf
				Loop
			EndIf
		Else
			If !lJob
				MsgStop("Pedido " + aPedidos[Ni] + "não encontrado.")
			EndIf
			Loop
		EndIf

	Next
	
	gravaLog(aLog)

Return*/