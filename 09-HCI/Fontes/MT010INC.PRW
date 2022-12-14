#INCLUDE "PROTHEUS.CH"
#Include "TopConn.Ch"
#Include "RwMake.CH"

/*
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? MT010INC ? Autor ? Rogerio Leite         ? Data ? 12.06.07   ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Ponto de Entrada na Inclusao de Produtos                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ? MATA010                                                      ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? Generico                                                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???              ?xx/xx/xx?XXXXXX?                                          ???
???              ?        ?      ?                                          ???
????????????????????????????????????????????????????????????????????????????ٱ?
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
*/
User Function MT010INC(nOpcao,oProcess) 

	Local cCodPrd		:= SB1->B1_COD
	Local cDesPrd		:= SB1->B1_DESC   
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	Local _nSeq			:= Len(AllTrim(GetMV("ES_SEQCPRD",,"000000")))
	
	Private cEmpAtual	:= SM0->M0_CODIGO
	Private cFilAtual	:= SM0->M0_CODFIL
	
	default nOpcao := 0
	
	do case
		case nOpcao == 0
		   If SB1->B1_TIPO $ "PA"
		     U_RESTG001(SB1->B1_COD)
		   Endif
		   //trata a inclusao de produtos em todas as empresas
		   /*
		   dbSelectArea("SB1")
		   dbSetOrder(1)                         
		   // Guarda os Dados Gravados no SB1 da empresa atual
		   For x := 1 to fCount()
		    	cField := FieldName(x)
		    	If (nPos := SB1->(FieldPos(cField))) > 0
		    		&("M->" + FieldName(x)) := SB1->(FieldGet(nPos))
		    	Else
		    		&("M->" + FieldName(x)) := CriaVar(FieldName(x))
		    	Endif
		   Next
		   // 2 Passo - Muda empresa - filial para 0250
		   dbCloseAll()
		   if cEmpAtual="02"
		     cEmpAtual:="01"
		     oApp:cEmpAnt	:= "01"
		     oApp:cNumEmp	:= "0101"
		     cFilAnt			:= "01"
		     OpenSM0("0101")
		   else  
		     cEmpAtual:="02"
		     oApp:cEmpAnt	:= "02"
		     oApp:cNumEmp	:= "0250"
		     cFilAnt			:= "50"
		     OpenSM0("0250")
		   endif 
		   OpenSXs()
		   InitPublic()
		   dbSelectArea("SB1")
		   dbSetOrder(1)                         
		   // Verifica se o Produto j? est? cadastrado
		   IF ! SB1->( DbSeek( xFilial("SB1") + cCodPrd, .F. ))  
		    	Begin Transaction
		    	RecLock("SB1", .T., .F.)
		    	For x := 1 to fCount()
		    		If FieldName(x) $ "B1_COD|B1_FILIAL|B1_DESC|B1_TIPO|B1_CONTA"
		    			Loop
		    		EndIf
		    		cField := FieldName(x)	&("SB1->" + cField) := &("M->" + cField)
		    	Next
		    	SB1->B1_FILIAL := xFilial("SB1")
		    	SB1->B1_COD    := cCodPrd
		    	SB1->B1_DESC   := cDesPrd
		    	SB1->B1_TIPO   := IIF(cEmpAtual=="01","PA","MP")  // precisa definir 
		    	SB1->B1_CONTA  := IIF(cEmpAtual=="01","1.1.3.03            ","1.1.3.01            ")  // precisa definir 
		    	If !Empty(aCodGrd)
		    		SB1->B1_GRADE := "S"
		    	EndIf
				MsUnlock()
				End Transaction
				if cEmpAtual="02"
		     		cEmpAtual:="01"
		      		oApp:cEmpAnt	:= "01"
		      		oApp:cNumEmp	:= "0101"
		      		cFilAnt			:= "01"
		      		OpenSM0("0101")
		    	else  
		      		cEmpAtual:="02"
		      		oApp:cEmpAnt	:= "02"
		      		oApp:cNumEmp	:= "0250"
		     	    cFilAnt			:= "50"
		      		OpenSM0("0250")
		    	endif
		    	OpenSXs()
		    	InitPublic()
		   endif
		  */
		 //  U_APVInicio()
		case nOpcao == 1
		//	U_APVRetorno(oProcess)                       	
		case nOpcao == 2
		//	U_APVTimeOut(oProcess)       	
	endcase
	
	//Altera??o para atualizar a sequencia do c?digo do produto
	If cEmpAnt+cFilAnt $ _cMVEmpAnt		
		If SB1->(FieldPos("B1_XTPMAT")) != 0
			dbSelectArea("SX5")
			SX5->(dbSetORder(1))
			If SX5->(dbSeek(xFilial("SX5") + "SN" + SB1->B1_TIPO))
				If RecLock("SX5",.F.)
					#ifdef SPANISH
						SX5->X5_DESCSPA	:= SubStr(SB1->B1_COD,7,_nSeq)
					#else
						#ifdef ENGLISH
							SX5->X5_DESCENG	:= SubStr(SB1->B1_COD,7,_nSeq)
						#else
							SX5->X5_DESCRI	:= SubStr(SB1->B1_COD,7,_nSeq)
						#endif
					#endif
					SX5->(MsUnLock())
				EndIf
			Else
				If RecLock("SX5",.T.)
					SX5->X5_FILIAL	:= xFilial("SX5")
					SX5->X5_TABELA	:= "SN"
					SX5->X5_CHAVE	:= SB1->B1_TIPO
					SX5->X5_DESCRI	:= SubStr(SB1->B1_COD,7,_nSeq)
					SX5->X5_DESCSPA	:= SubStr(SB1->B1_COD,7,_nSeq)
					SX5->X5_DESCENG	:= SubStr(SB1->B1_COD,7,_nSeq)
					SX5->(msUnlock())
				EndIf			
			EndIf
		EndIf
	EndIf

Return






/*
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????Ŀ??
???Fun??o    ? RESTG001 ? Autor ? Rogerio Leite         ? Data ? 12.06.07   ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???Descri??o ? Cria os locais para cada inclusao de Produto                 ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???Sintaxe   ? RESTG001                                                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? Uso      ? Generico                                                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ???
???????????????????????????????????????????????????????????????????????????Ĵ??
??? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                     ???
???????????????????????????????????????????????????????????????????????????Ĵ??
???              ?xx/xx/xx?XXXXXX?                                          ???
???              ?        ?      ?                                          ???
????????????????????????????????????????????????????????????????????????????ٱ?
???????????????????????????????????????????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????
*/
User Function RESTG001(cProduto)
Local cLocHCI := GetMv("MV_XLOCPRD"),aLocais:={},I,aAreaLoc:=GetArea()
*
I:=1
While .T.
 If Len(AllTrim(Subs(cLocHCI,I,2))) > 0
    AADD(aLocais,Subs(cLocHCI,I,2))
 Else
    Exit
 Endif
 I+=3
End
*
For I:=1 To Len(aLocais)
   CriaSB2(cProduto,aLocais[I])
Next
*
RestArea(aAreaLoc)
*
Return



/*
// APVInicio - Esta fun??o ? respons?vel por iniciar a cria??o do processo e por
//		enviar a mensagem para o destinat?rio.
*/

User Function APVInicio(oProcess)
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodProcesso, cCodStatus, cHtmlModelo,cTitulo
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
ConOut('Processando Envio')
cCodProduto := SB1->B1_COD

// C?digo extra?do do cadastro de processos.
cCodProcesso := "ATUAPV"

// Arquivo html template utilizado para montagem da aprova??o
cHtmlModelo := "\Workflow\atuapv.htm"

// Assunto da mensagem
cAssunto := "Atualiza??o do pre?o de venda"

// Registre o nome do usu?rio corrente que est? criando o processo:
cUsuarioProtheus:= SubStr(cUsuario,7,15)

// Inicialize a classe TWFProcess e assinale a vari?vel objeto oProcess:
oProcess := TWFProcess():New(cCodProcesso, cAssunto) 

// Crie uma tarefa.
cTitulo:="Atualiza PV"
oProcess:NewTask(cTitulo, cHtmlModelo)  

// Crie um texto que identifique as etapas do processo que foi realizado
// para futuras consultas na janela de rastreabilidade.
cTexto := "Iniciando a solicita??o de " + cAssunto + " do produto: " + cCodProduto

// Informe o c?digo de status correspondente a essa etapa.
cCodStatus := "100100" // C?digo do cadastro de status de processo.

// Repasse as informa??es para o m?todo respons?vel pela rastreabilidade.
oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)  // Rastreabilidade

// Adicione informac?es a serem inclu?das na rastreabilidade.
cTexto := "Gerando solicita??o para envio..."
cCodStatus := "100200" 
oProcess:Track(cCodStatus, cTexto, cUsuarioProtheus)

// Assinale novos valores ?s macros existentes no html:
oProcess:oHtml:ValByName("B1_COD", cCodProduto)
oProcess:oHtml:ValByName("B1_DESC", SB1->B1_DESC)
oProcess:oHtml:ValByName("B1_PRV1", SB1->B1_PRV1)

// Repasse o texto do assunto criado para a propriedade espec?fica do processo.
oProcess:cSubject := cAssunto

// Informe o endere?o eletr?nico do destinat?rio.
oProcess:cTo := "robson.bueno@hci.ind.br"

// Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus.
oProcess:UserSiga := WFCodUser("ROBSON.BUENO") 

// Antes de assinalar o ID do processo no campo, ? verificado se realmente o
// campo existe na tabela SB1.
If SB1->(FieldPos("B1_WFID")) > 0
If RecLock("SB1",.f.)
	SB1->B1_WFID := oProcess:fProcessID
	MsUnLock()
EndIf
EndIf 

// Informe o nome da fun??o de retorno a ser executada quando a mensagem de
// respostas retornar ao Workflow:
oProcess:bReturn := "U_MT010INC(1)"

// Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout
// ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio
// do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere
// os valores das vari?veis: nDias, nHoras e nMinutos.
oProcess:bTimeOut := {"U_MT010INC(2)", nDias, nHoras, nMinutos}	

// Adicione as informac?es a serem inclu?das na rastreabilidade
cTexto := "Enviando solicita??o..."
cCodStatus := "100300"
oProcess:Track(cCodStatus, cTexto , cUsuarioProtheus)

// Ap?s ter repassado todas as informac?es necess?rias para o Workflow, 
// execute o m?todo Start() para gerar todo o processo e enviar a mensagem
// ao destinat?rio.
oProcess:Start()

// Adicione as informac?es a serem inclu?das na rastreabilidade
cTexto := "Aguarde retorno..."
cCodStatus := "100400"
oProcess:Track(cCodStatus, cTexto , cUsuarioProtheus)  // Rastreabilidade
Return

/*
// APVRetorno - Esta fun??o ? executada no retorno da mensagem enviada
//		    pelo destinat?rio. O Workflow recria o processo em que
//	 	    parou anteriormente na fun??o APVInicio e repassa a
//		    vari?vel objeto oProcess por par?metro.
*/
User Function APVRetorno(oProcess)
Local nPrecoVenda
Local cCodProduto, cCodStatus, cTexto
ConOut('Processando Retorno')
// Obtenha o c?digo do produto a partir do html
cCodProduto := oProcess:oHtml:RetByName("B1_COD")

// Obtenha o novo pre?o de venda informado pelo destinat?rio:
nPrecoVenda := Val(oProcess:oHtml:RetByName("B1_PRV1"))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

// Localize o produto cadastrado na tabela SB1
If SB1->(dbSeek(xFilial("SB1") + cCodProduto))
// Adicione as informac?es a serem inclu?das na rastreabilidade.
cTexto := "Atualizando o pre?o de venda..."
cCodStatus := "100500"

// Atrav?s do atributo :cRetFrom da classe twfprocess, ? poss?vel obter o endere?o
// eletr?nico de quem respondeu a mensagem. Obtenha-o para adicion?-lo ? rastreabilidade.
oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)

// Atualize o pre?o de venda:
If RecLock( "SB1", .f. )
	SB1->B1_PRV1 := nPrecoVenda
	MsUnLock()
EndIf
Else
// Adicione as informac?es a serem inclu?das na rastreabilidade.
cTexto := "N?o foi poss?vel encontrar o produto: " + cCodProduto
cCodStatus := "100900"
oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)
EndIf

// Adicione as informac?es a serem inclu?das na rastreabilidade.
cTexto := "Finalizando o processo..."
cCodStatus := "100800" // C?digo do cadastro de status de processo
oProcess:Track(cCodStatus, cTexto, oProcess:cRetFrom)  // Rastreabilidade
Return


/*
// APTimeOut - Esta fun??o ser? executada a partir do Scheduler no tempo
//		   estipulado pela propriedade :bTimeout da classe TWFProcess.
//		   Caso o processo tenha sido respondido em tempo h?bil, essa
//	  	   execu??o ser? descartada automaticamente.
*/
User Function APTimeOut(oProcess) 
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodStatus, cHtmlModelo
Local cCodProduto, cTexto, cTitulo
ConOut('Processando Timeout')
cHtmlModelo := "\Workflow\atuapv.htm"
cTitulo := "Atualiza??o do pre?o de venda"

// Adicione as informac?es a serem inclu?das na rastreabilidade.
cTexto := "Executando TIMEOUT..."
cCodStatus := "100600"
// A fun??o APTimeOut ? executada, automaticamente, pelo sistema.
// Devido n?o haver usu?rio associado ? execu??o, ser? omitido o par?metro
// correspondente.
oProcess:Track(cCodStatus, cTexto)  // Rastreabilidade


// Na execu??o da fun??o de timeout, n?o se caracteriza retorno de mensagem.
// Neste caso, deve usar o m?todo :ValByName() no lugar do m?todo :RetByName()
// para obter os valores contidos no html.
cCodProduto := oProcess:oHtml:ValByName("B1_COD")

// Finalize a tarefa anterior para n?o ficar pendente.
oProcess:Finish()

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

// Localize o produto na tabela SB1:
If SB1->(dbSeek(xFilial("SB1") + cCodProduto))

// Crie uma nova tarefa, aproveitando o conte?do do html preenchido anteriormente
// com o uso do terceiro par?metro com o valor l?gico igual a .T. (verdadeiro)
oProcess:NewTask(cTitulo, cHtmlModelo, .T.)

// Antes de assinalar o ID do processo no campo, verifique se realmente o campo
// existe na tabela SB1:
If SB1->(FieldPos("B1_WFID")) > 0
If RecLock("SB1",.f.)
SB1->B1_WFID := oProcess:fProcessID
MsUnLock()
EndIf
EndIf 

// Acrescente a palavra "(REENVIO)" no in?cio do assunto da mensagem para
// refor?ar que houve um timeout executado.
If (Left(oProcess:cSubject,9) != "(REENVIO)")
oProcess:cSubject := "(REENVIO)" + oProcess:cSubject
EndIf

oProcess:cTo := "robson.bueno@hci.ind.br" 

// Utilize a fun??o WFCodUser para obter o c?digo do usu?rio Protheus.
oProcess:UserSiga := WFCodUser("ROBSON.BUENO")

// Redefina a fun??o de retorno a ser executada.
oProcess:bReturn := "U_MT010INC(1)"

// Redefina a fun??o de timeout a ser executada.
oProcess:bTimeOut := {"U_MT010INC(2)", nDias, nHoras, nMinutos}

// Adicione as inform??es a serem inclu?das na rastreabilidade
cTexto := "Reenviando a solicita??o..."
cCodStatus := "100700"
oProcess:Track(cCodStatus, cTexto)

// Inicie o processo
oProcess:Start()
Else
// Adicione as informac?es a serem inclu?das na rastreabilidade.
cTexto := "N?o foi poss?vel encontrar o produto: " + cCodProduto
cCodStatus := "100900"  // C?digo do cadastro de status de processo
oProcess:Track(cCodStatus, cTexto)  // Rastreabilidade
EndIf

Return

/*User Function _fFTpPrd()

	Local _cFilter	:= ""
	Local _aArea	:= GetArea()
	Local _cTpPrd	:= AllTrim(GetMV("ES_FILTPPR",,"AI|BN|EM|GE|GG|"))
	
	_cFilter	+= "@#"
	_cFilter	+= "("            
//	_cFilter	+= "025->X5_FILIAL == '"+xFilial("SX5")+"'"
//	_cFilter	+= " .AND. "
	_cFilter	+= " 025->X5_TABELA == '02' "
//	_cFilter	+= " .AND. "
//	_cFilter	+= "!(025->X5_CHAVE $ '"
//	_cFilter 	+= _cTpPrd 
//	_cFilter	+= "') "
	_cFilter	+= ")@#"
	RestArea(_aArea)
	
Return _cFilter     

User Function _fFGrpPrd()

	Local _cFilter	:= ""
	Local _aArea	:= GetArea()
	Local _cGpPrd	:= AllTrim(GetMV("ES_FILGRPR",,"0001|0002|0003|0004|0005|0006|0007"))
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	
	If cEmpAnt+cFilAnt $ _cMVEmpAnt	
		_cFilter	+= "@#"
		_cFilter	+= "SBM->("            
		_cFilter	+= "SBM->BM_FILIAL == '"+xFilial("SBM")+"'"
		_cFilter	+= " .AND. "
		If SBM->(FieldPos("BM_XFILTRO")) != 0
			_cFilter	+= " SBM->BM_XFILTRO == 'S'
		Else
			_cFilter	+= "!(SBM->BM_GRUPO $ '"
			_cFilter 	+= _cGpPrd 
			_cFilter	+= "') "
		EndIf
		_cFilter	+= ")@#"
	EndIf
	RestArea(_aArea)
	
Return _cFilter  
*/
User Function _fVldGrP(_cGrupo)

	Local _aArea		:= GetArea()
	Local _cGpPrd		:= AllTrim(GetMV("ES_FILGRPR",,"0001|0002|0003|0004|0005|0006|0007"))
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	Local _lOk			:= .F.
	
	If cEmpAnt+cFilAnt $ _cMVEmpAnt	
		dbSelectArea("SBM")
		SBM->(dbSetOrder(1))
		If SBM->(dbSeek(xFilial("SBM")+PadR(AllTrim(_cGrupo),TAMSX3("BM_GRUPO")[1])))
			If SBM->(FieldPos("BM_XFILTRO")) != 0
				If SBM->BM_XFILTRO == 'S'
					_lOk	:= .T.
				EndIf
			Else
				If !(SBM->BM_GRUPO $ _cGpPrd)
					_lOk	:= .T.
				EndIf
			EndIF
		EndIf
	EndIf
	
	If !_lOk
		Aviso(OEMTOANSI("Aten??o"),OEMTOANSI("O Grupo informado est? bloqueado para utiliza??o, de acordo com a codifica??o de produtos. Favor verificar!"),{"Ok"},1)
	EndIf

Return(_lOk)
/*
User Function _fGCodPrd()

	Local _cCodPrd		:= ""
	Local _aArea		:= GetArea()
	Local _cCampo		:= ReadVar()
	Local _cSeq			:= Iif(INCLUI,Soma1(_fGetSeq()),SubStr(SB1->B1_COD,7,5))
	Local _cTipo		:= Iif(!Empty(SubStr(M->B1_COD,1,2)),SubStr(M->B1_COD,1,2),M->B1_TIPO)
	Local _cMVEmpAnt	:= AllTrim(GetMV("ES_ATVCPEF",,"0250"))
	Local _nOpcAviso	:= 0
	
	If cEmpAnt+cFilAnt $ _cMVEmpAnt	//.And. M->B1_DATREF >= CtoD("05/10/2015")
		If SB1->(FieldPos("B1_XTPMAT")) != 0
			If Upper(AllTrim(_cCampo)) == "M->B1_TIPO" 
				If UPPER(ALLTRIM(M->B1_TIPO)) == "MP"
					_nOpcAviso	:= Aviso(OEMTOANSI("Aten??o"),OEMTOANSI("Atribui??o do Material ?"),{"Carmar","Cliente"},1)
					If _nOpcAviso == 1
						_cTipo	:= "MP"
					Else
						_cTipo	:= "MT"
					EndIf
				Else
					_cTipo		:= M->B1_TIPO
				EndIf
			EndIf
			If M->B1_XTPMAT == 'P'
				_cCodPrd	:= _cTipo + Iif(M->B1_TIPO=='MP',M->B1_GRUPO,(M->B1_XUNDNEG + M->B1_XATMAT)) + _cSeq
			Else
				_cCodPrd	:= _cTipo + M->B1_GRUPO + _cSeq
			EndIf
		EndIf
	Else
		_cCodPrd		:= M->B1_COD
	EndIf
	
	RestArea(_aArea)
*/
Return(_cCodPrd)

Static Function _fGetSeq()

	Local _cSeq	:= GetMV("ES_SEQCPRD",,"000000")
	
	dbSelectArea("SX5")
	SX5->(dbSetORder(1))
	If SX5->(dbSeek(xFilial("SX5") + "SN" + M->B1_TIPO))
		#ifdef SPANISH
			_cSeq	:= ALLTRIM(SX5->X5_DESCSPA)
		#else
			#ifdef ENGLISH
				_cSeq	:= ALLTRIM(SX5->X5_DESCENG)
			#else
				_cSeq	:= ALLTRIM(SX5->X5_DESCRI)
			#endif
		#endif
	EndIf
	
Return(_cSeq)


//-------------------------------------------------------------------
/*/{Protheus.doc} _f002XB
Rotina para cria??o da consulta padr?o de Tipos.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
/*User Function _f02XB()

	Local alEstrut	:= {}
	Local alCampos	:= {}
	Local olChkB	:= Nil
	Local olBtn1	:= Nil
	Local olBtn2	:= Nil
	Local olBtn3	:= Nil
	Local clNomTmp	:= ""
	Local clMarca	:= "X"
	Local llChkB	:= .T.
	Local _nOpc		:= 0
	Local _cBusca	:= Space(TamSX3("X5_CHAVE")[1])
	Local _nIndice	:= 1
	Local _oIndice	:= Nil
	Local _aBusca	:= {"Codigo"}
	Private olMark	:= Nil
	
	aAdd(alCampos,{"CHAVE"	,,"Chave"		,"@!"})
	aAdd(alCampos,{"DESC"	,,"Descricao"	,"@!"})	

	aAdd(alEstrut,{"CHAVE"	,"C",TamSX3("X5_CHAVE")[1]	,TamSX3("X5_CHAVE")[2]})
	aAdd(alEstrut,{"DESC"	,"C",TamSX3("X5_DESCRI")[1]	,TamSX3("X5_DESCRI")[2]})	

	clNomTmp	:= CriaTrab(alEstrut,.T.)
	If Select("TMP02") > 0
		TMP02->(dbCloseArea())
	EndIf
	dbUseArea(.T.,,clNomTmp,"TMP02",.F.)
	
	INDEX ON CHAVE TAG IND1 TO "TMP02"
	INDEX ON DESC TAG IND2 TO "TMP02"

	FGrvTMP(1)

	TMP02->(dbSetOrder(1))
	TMP02->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE "Tipos de Materiais"
	
		olMark	:= MsSelect():New("TMP02","",,alCampos,,@clMarca,{35,04,200,250})
//		@ 005,004 RADIO _oIndice VAR _nIndice ITEMS "Codigo","Descricao" SIZE 70,10
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP(_nIndice),TMP02->(dbGoTop()),olMark:oBrowse:Refresh(),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,210 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqDSP(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,210 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP(_nIndice),_cBusca	:= Space(TamSX3("X5_CHAVE")[1]))				PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 			SIZE 40,12 ACTION (_nOpc:=1,olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
	
	If _nOpc == 1
		Return(TMP02->CHAVE)
	EndIF
	
Return("")
*/
//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqDSP
Fun??o para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqDSP(_nOpc,_cBusca)

    TMP02->(dbSetOrder(_nOpc))
    TMP02->(dbSeek(_cBusca))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP
Fun??o para grava??o dos dados da consulta padr?o de Despesas.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP(_nOpc)

	Local _cQuery	:= ""
	Local _aCodTipo	:= Separa(AllTrim(GetMV("ES_FILTPPR",,"AI|BN|EM|GE|GG|")),"|")
	Local _cCodTipo	:= ""
	Local _cAlias02	:= GetNextAlias()
	Local _nI		:= 0
	
	For _nI := 1 To Len(_aCodTipo)
		_cCodTipo += Iif(Len(_cCodTipo)>0,",","") + "'" +  Alltrim(_aCodTipo[_nI]) + "'"
	Next _nI

	If Select("TMP02") > 0
		TMP02->(dbGoTop())
		If TMP02->(!Eof())
			While TMP02->(!Eof())
				If RecLock("TMP02", .F., .T.)
					TMP02->( dbDelete() )
					TMP02->( MsUnLock() )
				EndIf
				TMP02->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	X5_CHAVE, X5_DESCRI "
	_cQuery	+= " FROM " + RetSqlName("SX5") 
	_cQuery	+= " WHERE X5_FILIAL = '" + xFilial("SX5") + "' "
	_cQuery += " AND X5_TABELA = '02' "
	_cQuery	+= " AND X5_CHAVE NOT IN (" + _cCodTipo + ") "
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY X5_CHAVE "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock("TMP02",.T.)
				TMP02->CHAVE	:= (_cAlias02)->X5_CHAVE
				TMP02->DESC	:= (_cAlias02)->X5_DESCRI
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    TMP02->(dbSetOrder(1))

Return(Nil)
