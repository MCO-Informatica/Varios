#Include "Protheus.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矯SProcAge  ? Autor ? Marcelo Celi Marques ? Data ? 06/12/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 砇otina de Importacao de agentes a partir do webservice	  潮? 
北?			 砪onsumido no GAR: WSIntegracaoGARERPImplService()			  潮? 
北?			 砅reparado para ser disparado do Menu, e com isso as 		  潮? 
北?			 砳nterfaces de tela ser鉶 utilizadas, bem como tela de 	  潮?   
北?			 砫e confirmacao e visualizacao de processos (Progressao) e	  潮?
北?			 硋ia Job, e com isso as interfaces nao serao consideradas,	  潮?
北?			 硆ealizando o processamento automaticamente.				  潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北砈intaxe   ?  CSPROCAGE(ExpL)											  潮? 
北?			 ?  														  潮?  
北?			 ?  ExpL = Conteudo L骻ico para determinar se a rotina sera   潮?  
北?			 ?  ou nao executada em Schedulle. 							  潮? 
北?			 ?  														  潮?  
北?			 ?  .T. = Sim, .F. = Nao									  潮? 
北?			 ?  Caso nao informado, rotina ira assumir como padrao de .F. 潮?  
北?			 ?  e os controles de tela serao acionados.					  潮?   
北?			 ?  														  潮? 
北?			 ?  Importante: Caso a rotina for executada em schedulle ?	  潮?
北?			 ?  extremamente necessario informar .T. na chamada, do  	  潮?
北?			 ?  contrario a chamada da rotina ficara parada na confirmacao潮? 
北?			 ?  e como nao ha interferencia humana no schedulle, o 		  潮?   
北?			 ?  processamento ficara travado.							  潮?  
北?			 ?  														  潮?  
北?			 ? Exemplo da Chamada em:									  潮? 
北?			 ?  														  潮? 
北?			 ? Schedulle:  u_CSPROCAGE(.T.)								  潮? 
北?			 ? 															  潮? 
北?			 ? Menu ou Interface Protheus: 	u_CSPROCAGE(.F.) ou  		  潮? 
北?			 ?  							u_CSPROCAGE()				  潮? 
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Certisign                                                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/                                 
User Function CSProcAge(aParSch)
Local aButtons	:= {}
Local aSays		:= {}
Local nOpcA		:= 0
Local lSchedulle	

Public _oProcess := NIL

If aParSch == Nil 
	aParSch		:= Array(3)
	aParSch[1]	:= "01"
	aParSch[2]	:= "02"
	aParSch[3]	:= .T. 
EndIf 

lSchedulle := aParSch[3]

If !lSchedulle
	aAdd(aSays,"Este programa permite a importa玢o de agentes para o cadastro de")
	aAdd(aSays,"contatos do Microsiga extraidos pelo webservice do GAR e relacio-")
	aAdd(aSays,"na-los a tabela Contatos x Entidades.") 
	aAdd(aSays,"Esta importa玢o pode demorar de acordo com o volume de dados")
	aAdd(aSays,"extraidos e o link de integra玢o com o webservice.")
	aAdd(aSays,"") 
	aAdd(aSays,"Certifique-se da necessidade de execut?-lo.")
	
	aAdd(aButtons, {1,.T.,{|o| nOpcA:=1, o:oWnd:End() }})
	aAdd(aButtons, {2,.T.,{|o| nOpcA:=0, o:oWnd:End() }})

	FormBatch("Importa玢o de Agentes",aSays,aButtons,,,425)

	If nOpcA>0	
		_oProcess := MsNewProcess():New({|lEnd| CSProcAge(lSchedulle)},"Aguarde...","Processando Importa玢o de Agentes",.F.)
		_oProcess:Activate()
	EndIf	
Else
	// Prepara ambiente para acesso aos dicionarios e tabelas 
	RpcSetType( 3 )
	RpcSetEnv( aParSch[1], aParSch[2] )

	CSProcAge(lSchedulle)
EndIf

Return
      
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矯SProcAge  ? Autor ? Marcelo Celi Marques ? Data ? 06/12/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 矯hamada da rotina de processamento da Importacao de Agentes.潮? 
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北砈intaxe   ?  CSPROCAGE(ExpL)											  潮? 
北?			 ?  														  潮?  
北?			 ?  ExpL = Se chamada por schedulle ou interface Protheus.    潮?  
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Certisign                                                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function CSProcAge(lSchedulle)
Local oWSObj
Local nI			:= 0
Local nJ			:= 0
Local nK			:= 0
Local aPostos		:= {}
Local aAR			:= {}              		
Local aPosto		:= {}  
Local aAgente		:= {}   
Local lAltera		:= GetNewPar("CS_ALTAGEN",.F.) //->> Se o sistema ira alterar os dados dos agentes caso ja estejam cadastrados.
Local nLenSX8		:= GetSX8Len()				// Posicao atual na pilha de sequenciais de codigos
Local lXChkCpf		:= GetNewPar("MV_XCHKCFP", .T.)
Local cFilSZ3		:= xFilial("SZ3")
Local nTamCodCon	:= Tamsx3("AC8_CODCON")[1]
Local nTamEntida	:= Tamsx3("AC8_ENTIDA")[1]
Local nTamFilEnt	:= Tamsx3("AC8_FILENT")[1]
Local nTamCodEnt	:= Tamsx3("AC8_CODENT")[1]
Local nTamCodGar	:= TamSX3("Z3_CODGAR")[1]
Local nLenAR		:= 0                                                    
Local nLenID		:= 0
Local oObj

Private _nCount	:= 0
PRIVATE cPath     := GetSrvProfString("Startpath","")

Conout( "[CSPROCAGE][" + DtoC( Date() ) + " " + Time() + "]" + " Inicio ..." )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//矯hama o WebService do sistema GAR?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
oWSObj := WSIntegracaoGARERPImplService():New()
oWSObj:listaARs( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
								 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }) )
								
aAR := aClone(oWSObj:CAR)

If !lSchedulle
	_oProcess:SetRegua1(Len(aAr))
EndIf

nLenAR := Len( aAR )                                                        
nLenID := Len( aAR[1]:cID )

For nI := 1 To nLenAR
	If !lSchedulle
		_oProcess:IncRegua1( "Processando ARs ... " + AllTrim( Str( Int( ( ( nI * 100 ) / nLenAR ) ) ) ) + "%" )
	EndIf	

	oWSObj:postosParaIdAR( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
												 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
												 aAR[nI]:CID )
	aPosto := aClone(oWSObj:OWSPOSTO)
	If !lSchedulle
		_oProcess:SetRegua2(Len(aPosto))
	EndIf
	For nJ := 1 To Len(aPosto)		
		If !lSchedulle
			_oProcess:IncRegua2("Gravando Agentes ...")
		EndIf		
		oWSObj:agentesComEntregaHWParaIdPosto( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
																					 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
																					 aPosto[nJ]:nID )
		aAgente := aClone(oWSObj:OWSAGENTE) 
		For nK:=1 to Len(aAgente)
			If ValType(aPosto[nJ]:NID) <> "U"
				aPostos:=GetPostos(AllTrim(Str(aPosto[nJ]:NID)),cFilSZ3,nTamCodGar)
				//->> Atualiza os Agentes  
				If ValType(aAgente[nK]:cCPF) <> "U" .Or. ValType(aAgente[nK]:cEMAIL) <> "U"
					AtualAgente(	lAltera,aAgente[nK]:CCPF,aAgente[nK]:CEMAIL,aAgente[nK]:CNOME,aPostos,nLenSX8,;
								lXChkCpf,	nTamCodCon,nTamEntida,nTamFilEnt,nTamCodEnt)
				EndIf	
			EndIf		
		Next nK 
	Next nJ
Next nI
    
If !lSchedulle
	MsgAlert("Foram incluidos "+Alltrim(Str(_nCount))+" agentes novos na base.")
Else
	Conout( "[CSPROCAGE][" + DtoC( Date() ) + " " + Time() + "]" + " Foram incluidos " + Alltrim( Str( _nCount ) ) + " agentes novos na base." )
EndIf

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矨tualAgente? Autor ? Marcelo Celi Marques ? Data ? 18/12/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 矨tualiza o cadastro de agentes no Protheus.				  潮? 
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北砈intaxe   ?  AtualAgente(ExpL1,ExpC1,ExpC2,ExpC3)					  潮? 
北?			 ?  														  潮?    
北?			 ?  ExpL1 = Se ira alterar agentes ja cadastrados.		      潮?   
北?			 ?  ExpC1 = Numero do CPF do Agente cadastrado no GAR.	      潮?   
北?			 ?  ExpC2 = Email do Agente cadastrado no GAR.			      潮?  
北?			 ?  ExpC3 = Nome do Agente cadastrado no GAR.	  		      潮?  
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Certisign                                                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function AtualAgente(lAltera,cCpf,cEmail,cNome,aPostos,nLenSX8,lXChkCpf,;
						nTamCodCon,nTamEntida,nTamFilEnt,nTamCodEnt)

Local aSU5		:= {} 
Local nOpc	   		:= 3      
Local nX			:= 0

Local cFilAC8		:= xFilial("AC8")
Local cFilSZ3		:= xFilial("SZ3")
Local cFilSU5		:= xFilial("SU5")

Default lAltera		:= .f.
Default cCpf		:= ""
Default cEmail		:= ""
Default cNome		:= ""
Default aPostos		:= {}

Private lMsErroAuto := .F.

DbSelectArea( "SU5" )

if lXChkCpf 
	if len(alltrim(cCpf))<11
   		cCpf := strzero(val(cCpf),11)
	endif
endif

// Inicializa variaveis publicas como inclusao
INCLUI := .T.
ALTERA := .F.

//->> Tenta Localizar por CPF
SU5->(dbSetOrder(8))
If SU5->(dbSeek(cFilSU5+cCpf))   
	nOpc := 4                   
	INCLUI := .F.
	ALTERA := .T.
	aAdd(aSU5,{"U5_CODCONT"	,SU5->U5_CODCONT	,Nil  }) 
Else
	//->> Caso nao ache por CPF, tenta localizar por email
	SU5->(dbSetOrder(9))
	If SU5->(dbSeek(cFilSU5+Lower(cEmail)))   
		INCLUI := .F.
		ALTERA := .T.
		nOpc := 4                   
		aAdd(aSU5,{"U5_CODCONT"	,SU5->U5_CODCONT	,Nil  }) 
    EndIf
EndIf         

//->> Grava se for novo contato ou se parametro CS_ALTAGEN indicar se pode 
//->> alterar os contatos ja cadastrados. (Padrao, caso n鉶 exista, n鉶 alterar) 
If (lAltera .And. nOpc==4) .Or. nOpc==3

	aAdd(aSU5,{"U5_FILIAL"	,cFilSU5	,Nil  }) 
	aAdd(aSU5,{"U5_CPF"		,cCpf		,Nil  })
	aAdd(aSU5,{"U5_EMAIL"	,cEmail		,Nil  })
	aAdd(aSU5,{"U5_CONTAT"	,cNome		,Nil  })
	aAdd(aSU5,{"U5_ATIVO"	,"1"		,Nil  })
	aAdd(aSU5,{"U5_FUNCAO"	,"000012"	,Nil  })
	aAdd(aSU5,{"U5_DEPTO"	,"074"		,Nil  })
	aAdd(aSU5,{"U5_CATEGO"	,"4"		,Nil  })

	Begin Transaction

		// Realiza a atualizacao do contato
		If nOpc == 3
			RecLock( "SU5", .T. )
			SU5->U5_CODCONT := GetSXENum( "SU5", "U5_CODCONT" )
		Else
			RecLock( "SU5", .F. )
		EndIf              
		
		For nI := 1 To Len( aSU5 )
			SU5->( FieldPut( FieldPos( aSU5[ nI, 1 ] ), aSU5[ nI, 2 ] ) )
		Next nI
		
		SU5->( MsUnlock() )
		                                   
		// Confirma numero do novo contato, caso seja inclusao
	   	If INCLUI .And. __lSX8
    		ConfirmSx8()
			_nCount ++
    	EndIf

		// Integracao do contato com a tabela de entidades (SZ3)
		AC8->( dbSetOrder( 1 ) )

		For nX := 1 to Len(aPostos)			
			If !AC8->( dbSeek( cFilAC8 +	PadR(SU5->U5_CODCONT, nTamCodCon ) + ;
										PadR("SZ3", nTamEntida ) + ;
										PadR(cFilSZ3, nTamFilEnt ) + ;
										PadR(aPostos[nX], nTamCodEnt ) ) )  
				RecLock("AC8",.T.)
				AC8->AC8_FILIAL 	:= cFilAC8
				AC8->AC8_FILENT 	:= cFilSZ3
				AC8->AC8_ENTIDA	:= "SZ3"
				AC8->AC8_CODENT	:= aPostos[nX]
				AC8->AC8_CODCON	:= SU5->U5_CODCONT		
				AC8->(MsUnlock())     
			EndIf
		Next nX

	End Transaction

	DbCommit()
	
EndIf
	
Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    矴etPostos  ? Autor ? Marcelo Celi Marques ? Data ? 19/12/12 潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 砇etorna array com os postos amarrados ao cod GAR sob param. 潮? 
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北砈intaxe   ?  GetPostos(ExpC1)										  潮? 
北?			 ?  														  潮?    
北?			 ?  ExpC1 = ID do Gar.									      潮?   
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Certisign                                                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function GetPostos(cCodGar,cFilSZ3,nTamCodGar)
Local aPostos	:= {}
Local cArea	:= Alias()
                      
cCodGar  := PadR( cCodGar, nTamCodGar )
nSeconds := Seconds()

DbSelectArea( "SZ3" )

DbSetOrder(4)
DbSeek( cFilSZ3 + cCodGar )
Do While ! EoF() .And. Z3_FILIAL == cFilSZ3 .And. Z3_CODGAR == cCodGar
	If Z3_TIPENT == "4"
		AAdd( aPostos, Z3_CODENT ) 
	EndIf		
	dbSkip()
EndDo				                 

DbSelectArea( cArea )
Return aPostos