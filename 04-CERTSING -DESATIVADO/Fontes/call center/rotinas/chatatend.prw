#INCLUDE "PROTHEUS.CH"

//grava as informações do chat
USER FUNCTION CHATATEND(_cgrupf,_coperad,_ctexto,_cchamf,_oper,_cchamg,lTela)
Local aCabec		:= {}  					// Cabecalho da rotina automatica
Local aLinha		:= {}					// Linhas da rotina automatica
Local aAreaSX3		:= SX3->(GetArea())			// Salva a Area do SX3
Local aAreaADE		:= ADE->(GetArea())			// Salva a Area do ADE
Local aAreaADF		:= ADF->(GetArea())			// Salva a Area do ADF
Local aAreaSUQ		:= SUQ->(GetArea())			// Salva a Area do SUQ
//Variaveis para gravação do chamado
Local cFilial		:= xFilial("ADE")
LOCAL cCodGrupo 	:= _cgrupf 										// Codigo do Grupo
LOCAL cCodCtto		:= SuperGetMv("SDK_CODCTTO",,"007323")    		// Codigo do contato
LOCAL cEntidade		:= "SA1"                                 		// Cadastro de Clientes
LOCAL cCodEntid		:= SuperGetMv("SDK_CODENTI",,"00000101") 		//Codigo da Entidade e codigo da Loja
LOCAL cDDD 			:= ""
LOCAL cTel 			:= ""
LOCAL cDATA 		:= dDATABASE
Local chora 		:= TIME()
LOCAL cCodTecn 		:= SuperGetMv("SDK_CODTECN",,"")         		//Codigo do Tecnico
LOCAL cCritic 		:= SuperGetMv("SDK_CRITIC",,"5")          		//Criticidade de assunto
LOCAL cTipoComun	:= SuperGetMv("SDK_TIPO",,"000003") 			//Tipo
LOCAL cTipoAtend	:= SuperGetMv("SDK_ATEND",,"1")        			//Tipo de Atendimento (1=Receptivo;2=Ativo)
LOCAL cOperador 	:= _coperad   									//Codigo do Operador
LOCAL cNmOperad 	:= SuperGetMv("SDK_NMOPERA",,"Administrador") 	// Tipo de Operador
LOCAL cIncidCham	:= ""      										//Incide Chamado
LOCAL cAssunto 		:= SuperGetMv("SDK_ASSUNT",,"000006") 			// T1(SX5) SuperGetMv("SDK_ASSUNTO",,"AG0011")   //Codigo do Assunto
LOCAL cDescAssunt	:= SuperGetMv("SDK_DESASSU",,"SOLICITACAO") 	//Descricao do Assunto
LOCAL cCodSUO 		:= ("SDK_CODSUO",,"") 							//Campanhas
LOCAL cCodSB1		:= SuperGetMv("SDK_SB1",,"060") 				// <SB1> - CERTISIGN SuperGetMv("SDK_SB1",,"SW300213")     //Cadastro de Produto SW300213
LOCAL cIncidente 	:= "Abertura de Chamado pelo CHAT - DATA :"+Dtoc(Ddatabase) // Incidente
LOcal cMemo 		:= _ctexto 										//Observacao da Mensagem
Local cCodSUQ 		:= SuperGetMv("SDK_CODSUQ",,"")     			// Codigo da Acao
Local cCodSU9 		:= SuperGetMv("SDK_CODSU9",,"000001") 			// 000001(SU9) - certisig SuperGetMv("SDK_CODSU9",,"000557")     // Codigo da /oncia
Local _erroia 		:=.F.
Local _champroc		:=""
Local _aLin			:= {}
Local _nX			:= 0
Local oObj			:= nil
Local _cconteudo	:= ""
Local _codigof		:= ""
//variaveis usadas pela rotina de execauto
Private lMsErroAuto := .F.
Private aHeader		:= {}
Private aCols		:= {}
Public n
Public nFolder		:= 2 // variavel inicializada para consulta do cliente
Public __cli 		:= ""
Private aRecList   	:= {}	// vetor de recursos adicionais utilizada na funcao QAlocPMS no fonte QNCXFUN
Private lTmk503Auto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta cabeçalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If _oper=4
   _codigof:=_cchamf
   ADF->(DbSetOrder(1))

   If ADF->(DbSeek(Xfilial("ADF")+_codigof))
      If Reclock("ADF",.F.)
         _cconteudo:= _ctexto //ADF->ADF_CODOBS
         MSMM(ADF_CODOBS,TamSX3("ADF_OBS")[1],,_cconteudo,1,,,"ADF","ADF_CODOBS")
         ADF->(MsUnlock())
         _champroc:=_codigof
         
         //Renato Ruy - 20/10/2016
         //Cria banco de conhecimento de conhecimento
         
         //Armazena conteudo da conversa no array
         _aLin := StrToArray(_ctexto,'"')
         
         //Analisa linha a linha se tem link.
         For _nX := 1 To Len(_aLin)
         	If "/WebChat/download" $ _aLin[_nX]
         		U_GrvAtend(GetMv("MV_XCHATFI"),StrTran(_aLin[_nX],"/WebChat/download?file=",""),_codigof)	
         	EndIf
         Next
      Else
         _erroia :=.T.
      EndIf
   Else
      _erroia :=.T.
   EndIf
Else
   M->ADE_CODCON  	:= ""
   M->ADE_NMCONT  	:= ""
   M->ADE_ENTIDAD 	:= ""
   M->ADE_NMENT 	:= ""
   M->ADE_DESCIN 	:= ""
   M->ADE_CHAVE 	:= ""
   M->ADE_DESCCH 	:= ""
   M->ADE_DDDRET	:= ""
   M->ADE_TELRET	:= ""
   __ReadVar		:= "M->ADE_CODCON"
   ALTERA			:= .F.
   If lTela
   		u_PesqCont()
		cCodCtto	:= M->ADE_CODCON
		cEntidade   := M->ADE_ENTIDAD
		cCodEntid	:= M->ADE_CHAVE
		cDDD		:= M->ADE_DDDRET
		cTel		:= M->ADE_TELRET
   EndIf
EndIf

DbSelectArea("ADE")
If _oper=3
   aAdd(aCabec,	{"ADE_FILIAL" 	,cFilial										,Nil})
   aAdd(aCabec,	{"ADE_INCIDE" 	,cIncidente                                     ,Nil})
   aAdd(aCabec,	{"ADE_STATUS" 	,"1"											,Nil})
   aAdd(aCabec,	{"ADE_OPERAD" 	,_coperad    									,Nil})
   aAdd(aCabec,	{"ADE_CODCON" 	,cCodCtto  										,Nil})
   aAdd(aCabec,	{"ADE_ENTIDA" 	,cEntidade										,Nil})
   aAdd(aCabec,	{"ADE_HORA" 	,TIME()				    						,Nil})
   aAdd(aCabec,	{"ADE_DDDRET" 	,cDDD								     		,Nil})
   aAdd(aCabec,	{"ADE_DATA" 	,cDATA  										,Nil})
   aAdd(aCabec,	{"ADE_TELRET" 	,cTel								    		,Nil})
   aAdd(aCabec,	{"ADE_TECNIC" 	,cCodTecn										,Nil})
   aAdd(aCabec,	{"ADE_NMOPER" 	,cNmOperad			    						,Nil})
   aAdd(aCabec,	{"ADE_SEVCOD" 	,cCritic     									,Nil})
   aAdd(aCabec,	{"ADE_TIPO" 	,cTipoComun  									,Nil})
   aAdd(aCabec,	{"ADE_OPERAC" 	,cTipoAtend										,Nil})
   aAdd(aCabec,	{"ADE_PLVCHV" 	,cIncidCham										,Nil})
   aAdd(aCabec,	{"ADE_CODCAM" 	,cCodSUO										,Nil})
   aAdd(aCabec,	{"ADE_CODSB1" 	,cCodSB1										,Nil})
   aAdd(aCabec,	{"ADE_CHAVE" 	,cCodEntid										,Nil})
   aAdd(aCabec,	{"ADE_GRUPO" 	,cCodGrupo										,Nil})
   aAdd(aCabec,	{"ADE_ASSUNT" 	,cAssunto										,Nil})
   aAdd(aCabec,	{"ADE_DESCAS" 	,cDescAssunt									,Nil})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Monta os itens do chamado com a   	|
//|primeira linha do chamado original   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄcÄÄÄÙ
   	aAdd(alinha,	{"ADF_FILIAL" 	,cFilial										,Nil})
   	aAdd(aLinha,	{"ADF_ITEM" 	,"001"											,Nil})
	aAdd(aLinha,	{"ADF_CODSU9" 	,cCodSU9			        					,Nil})
   	aAdd(aLinha,	{"ADF_CODSUQ" 	,cCodSUQ				        				,Nil})
   	aAdd(aLinha,	{"ADF_OBS" 		,cMemo											,Nil})
   	aAdd(aLinha,	{"ADF_DATA" 	,dDataBase										,Nil})
   	aAdd(aLinha,	{"ADF_HORA" 	,TIME()											,Nil})
   	aAdd(aLinha,	{"ADF_HORAF" 	,TIME()											,Nil})

   Fillgetdados(3,"ADF",nil,nil,nil,nil,nil,nil,nil,nil,nil,.T.)

	oObj := TeleServiceUserDialog():New()

	oObj:lAuto := .T.
	lTmk503Auto:= .T.

	oObj:openBrowse(aCabec,{aLinha},3,@_champroc)
	oObj:Service:Free()
	TMKFree( oObj )

   If lMsErroAuto// Exibe erro na execucao do programa
	  Mostraerro()
	  _erroia :=.T.
   Else

      If Alltrim(ADE->ADE_GRUPO) <> cCodGrupo
      	Reclock("ADE",.F.)
      		ADE->ADE_GRUPO := cCodGrupo
      	ADE->(Msunlock())
      EndIf

      ADF->(DbSetOrder(1))
      If ADF->(DbSeek(Xfilial("ADF")+_champroc))

	      If ADF->ADF_CODSU0 <> cCodGrupo
	      	Reclock("ADF",.F.)
	         ADF->ADF_CODSU0 := cCodGrupo
	      	ADF->(MsUnlock())
		  EndIf

		  If ADF->ADF_CODSU7 <> _coperad
	      	Reclock("ADF",.F.)
	         ADF->ADF_CODSU7 := _coperad
	      	ADF->(MsUnlock())
		  EndIf

	  EndIf

	  oObj :=  nil

   EndIf
EndIf

_cchamg:=_champroc

RestArea(aAreaSX3)
RestArea(aAreaADE)
RestArea(aAreaADF)
RestArea(aAreaSUQ)

DelClassIntf()

Return

// Renato Ruy - 20/10/16
// Programa para baixar os arquivos via http.
User Function GrvAtend(cUrl,cFile,_codigof)

Local cHtml := ''
Local cCaminho := ''
Local cPath    := MsDocPath()+"\" //Rootpath da base de conhecimento.

Default cUrl := ''
Default cFile:= '' 

// Inclui registro no banco de conhecimento e verifico se ja existe para não duplicar.
ACB->(DbSetOrder(2))
If !ACB->(DbSeek(xFilial("ACB") + _codigof + " - " + cFile ))

	//Faz o download do arquivo 
	cHtml := HttpGet( StrTran(cUrl,'"')+cFile )
	
	//Cria caminho de gravacao
	cCaminho := cPath + _codigof + " - " + cFile
	
	//Gera arquivo da base de conhecimento.
	MemoWrite( cCaminho, cHtml ) 


	DbSelectArea("ACB")
	RecLock("ACB",.T.)
	ACB_FILIAL := xFilial("ACB")
	ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
	ACB_OBJETO	:= _codigof + " - " + cFile
	ACB_DESCRI	:= _codigof + " - " + cFile
	MsUnLock()         
	
	ConfirmSx8()
	                   
	// Inclui amarração entre registro do banco e entidade
	DbSelectArea("AC9")
	RecLock("AC9",.T.)
	AC9_FILIAL	:= " "
	AC9_FILENT	:= "02"
	AC9_ENTIDA	:= "ADE"
	AC9_CODENT	:= "02" + _codigof
	AC9_CODOBJ	:= ACB->ACB_CODOBJ
	MsUnLock()         
EndIf
 
Return( cCaminho )