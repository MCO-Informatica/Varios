#Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSProcAge  � Autor � Marcelo Celi Marques � Data � 06/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Importacao de agentes a partir do webservice	  ��� 
���			 �consumido no GAR: WSIntegracaoGARERPImplService()			  ��� 
���			 �Preparado para ser disparado do Menu, e com isso as 		  ��� 
���			 �interfaces de tela ser�o utilizadas, bem como tela de 	  ���   
���			 �de confirmacao e visualizacao de processos (Progressao) e	  ���
���			 �via Job, e com isso as interfaces nao serao consideradas,	  ���
���			 �realizando o processamento automaticamente.				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �  CSPROCAGE(ExpL)											  ��� 
���			 �  														  ���  
���			 �  ExpL = Conteudo L�gico para determinar se a rotina sera   ���  
���			 �  ou nao executada em Schedulle. 							  ��� 
���			 �  														  ���  
���			 �  .T. = Sim, .F. = Nao									  ��� 
���			 �  Caso nao informado, rotina ira assumir como padrao de .F. ���  
���			 �  e os controles de tela serao acionados.					  ���   
���			 �  														  ��� 
���			 �  Importante: Caso a rotina for executada em schedulle �	  ���
���			 �  extremamente necessario informar .T. na chamada, do  	  ���
���			 �  contrario a chamada da rotina ficara parada na confirmacao��� 
���			 �  e como nao ha interferencia humana no schedulle, o 		  ���   
���			 �  processamento ficara travado.							  ���  
���			 �  														  ���  
���			 � Exemplo da Chamada em:									  ��� 
���			 �  														  ��� 
���			 � Schedulle:  u_CSPROCAGE(.T.)								  ��� 
���			 � 															  ��� 
���			 � Menu ou Interface Protheus: 	u_CSPROCAGE(.F.) ou  		  ��� 
���			 �  							u_CSPROCAGE()				  ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	aAdd(aSays,"Este programa permite a importa��o de agentes para o cadastro de")
	aAdd(aSays,"contatos do Microsiga extraidos pelo webservice do GAR e relacio-")
	aAdd(aSays,"na-los a tabela Contatos x Entidades.") 
	aAdd(aSays,"Esta importa��o pode demorar de acordo com o volume de dados")
	aAdd(aSays,"extraidos e o link de integra��o com o webservice.")
	aAdd(aSays,"") 
	aAdd(aSays,"Certifique-se da necessidade de execut�-lo.")
	
	aAdd(aButtons, {1,.T.,{|o| nOpcA:=1, o:oWnd:End() }})
	aAdd(aButtons, {2,.T.,{|o| nOpcA:=0, o:oWnd:End() }})

	FormBatch("Importa��o de Agentes",aSays,aButtons,,,425)

	If nOpcA>0	
		_oProcess := MsNewProcess():New({|lEnd| CSProcAge(lSchedulle)},"Aguarde...","Processando Importa��o de Agentes",.F.)
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSProcAge  � Autor � Marcelo Celi Marques � Data � 06/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Chamada da rotina de processamento da Importacao de Agentes.��� 
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �  CSPROCAGE(ExpL)											  ��� 
���			 �  														  ���  
���			 �  ExpL = Se chamada por schedulle ou interface Protheus.    ���  
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������Ŀ
//�Chama o WebService do sistema GAR�
//�����������������������������������
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AtualAgente� Autor � Marcelo Celi Marques � Data � 18/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o cadastro de agentes no Protheus.				  ��� 
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �  AtualAgente(ExpL1,ExpC1,ExpC2,ExpC3)					  ��� 
���			 �  														  ���    
���			 �  ExpL1 = Se ira alterar agentes ja cadastrados.		      ���   
���			 �  ExpC1 = Numero do CPF do Agente cadastrado no GAR.	      ���   
���			 �  ExpC2 = Email do Agente cadastrado no GAR.			      ���  
���			 �  ExpC3 = Nome do Agente cadastrado no GAR.	  		      ���  
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//->> alterar os contatos ja cadastrados. (Padrao, caso n�o exista, n�o alterar) 
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
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GetPostos  � Autor � Marcelo Celi Marques � Data � 19/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna array com os postos amarrados ao cod GAR sob param. ��� 
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �  GetPostos(ExpC1)										  ��� 
���			 �  														  ���    
���			 �  ExpC1 = ID do Gar.									      ���   
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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