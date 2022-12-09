#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*

*/

User Function LOJP008()

Local aparam	:= {"01","01"}

Private _lJob	:= (aParam == Nil .Or. ValType(aParam) <> "A")  

If !_lJob
	If aParam == Nil .Or. ValType(aParam) <> "A"
		Conout("Parametros nao recebidos => Empresa e Filial")
		Return
	Else
		Conout("Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])
		AtuDados()
	EndIf 
EndIf	
	
Return

Static Function AtuDados()

Local aparam	:= {"01","01"}
Local _aFiliais	:= {}		
Local nHdlLock	:= 0   
Local cArqLock	:= "LOJP008.lck"
	
	//Efetua o Lock de gravacao da Rotina - Monousuario          
	
	//FErase(cArqLock)
	//nHdlLock := MsFCreate(cArqLock)
	//If nHdlLock < 0
		//Conout("Rotina "+FunName()+" ja em execu��o.")
		//Return(.T.)
	//EndIf     
		
	// Inicializa ambiente.                                  
	
	RpcSetType(3)
	//IF FindFunction('WFPREPENV')
		//WfPrepEnv( aParam[1], aParam[2])
	//Else
		Prepare Environment Empresa aParam[1] Filial aParam[2]
	//EndIF
	ChkFile("SM0")
	
	DbSelectArea("SM0")
	SM0->( DbGoTop() )
	While SM0->( !Eof() ) 
	
		If SM0->M0_CODIGO == "01" .And. SM0->M0_CODFIL $ "14/15"
			Aadd(_aFiliais,{SM0->M0_CODIGO,SM0->M0_CODFIL,1000})
		EndIf		
		SM0->( DbSkip() )
	
	EndDo
	
	//Reset Environment
	
	For _nI := 1 To Len(_aFiliais)
	
		//IF FindFunction('WFPREPENV')
			//WfPrepEnv( _aFiliais[_nI,1], _aFiliais[_nI,2])
		//Else
			//Prepare Environment Empresa _aFiliais[_nI,1] Filial _aFiliais[_nI,2]
		//EndIF
		
		//ChkFile("SM0")
		
		cFilAnt := _aFiliais[_nI,2]
		SM0->( Dbseek(_aFiliais[_nI,1]+_aFiliais[_nI,2]) )
		
		Conout("Filial "+xFilial("SL1"))
		LsGrvBatch(_aFiliais[_nI,1],_aFiliais[_nI,2],_aFiliais[_nI,3])		
		//U_LOJP009(_aFiliais[_nI,1],_aFiliais[_nI,2],_aFiliais[_nI,3])
		//Conout("Rotina "+FunName()+" Filial: "+xFilial("SL1"))
		
		//Reset Environment
		
	Next _nI	
	
	// Fecha filial corrente.
	
	Reset Environment
		
	// Cancela o Lock de gravacao da rotina                         
	
	//FClose(nHdlLock)
	//FErase(cArqLock)
	
Return(.T.)

Static Function LsGrvBatch( cEmp, cFilTrab , cIntervalo )
Local nHandle							// Indica se o arquivo foi criado
Local aFiles		:= {}				// Arquivos
Local nIntervalo 	:= 0				// Intervalo para o Loop
Local nTimes	 	:= 0				// Numero de loop antes de entrar no while		
Local lRetValue  	:= .T.            	// Retorno da fun��o 
Local aFiliais   	:= {}              	// Filiais
Local aBadRecno  	:= {}				// Recnos 
Local cFileName		:= ""				// Nome do arquivo 
Local nCount 		:= 1				// Contador
Local cTemp			:= ""				// Temporario
Local lTemReserva	:= .F.				// Verifica se existe algum item com reserva
Local lProcessou	:= .F.				// Verifica se processou as vendas na Retaguarda.
Local bOldError  						// Bloco de tratamento de erro
Local lLJ7051		:= FindFunction("U_LJ7051")	//Verifica se a funcao LJ7051 esta compilada 
Local lExProc 		:= .T.				// Controla o while do Killapp 
Local lMultFil 		:= .F.				// Verifica se e' passado mais de uma filial no parametro
Local lCriouAmb		:= .F.				// Verifica se o PREPARE ENVIRONMENT foi executado
Local nSleep		:= 0				// Utilizado para atribuicao na variavel nIntervalo 	
Local aAreaSL1		:= {}				// Guarda a Area do SL1
Local nRecSL1		:= 0				// Guarda o Recno do SL1

DEFAULT cIntervalo    	:= 30000		// Conteudo do terceiro parametro (Parm3 do mp8srv.ini)

//���������������������������������������������������������Ŀ
//�Tratamento caso o terceiro parametro seja passado ou nao.�
//�����������������������������������������������������������
If ValType(cIntervalo) <> "N"
	nSleep := Val(cIntervalo)
Else               
	nSleep := cIntervalo	
Endif

While nCount <= Len( cFilTrab )
	
	cTemp := ""
	While SubStr( cFilTrab, nCount, 1 ) <> "," .AND. nCount <= Len( cFilTrab )
		cTemp += SubStr( cFilTrab, nCount, 1 )
		nCount++
	End
	
	AADD( aFiliais, { cTemp } )
	nCount++
	
End

nCount := 1

//���������������������������������������������������Ŀ
//�Verifica o numero de filiais que esta sendo passado�
//�����������������������������������������������������
If Len(aFiliais) > 1
	lMultFil := .T. 
Endif

//���������������������������������������Ŀ
//�Variavel lExProc inicializada como True�
//�����������������������������������������
While !KillApp() .AND. lExProc
	cFileName := cEmp + aFiliais[ nCount ][1]
	If (!lMultFil .AND. lCriouAmb) .OR. ( nHandle := MSFCreate("LJGR"+cFileName+".WRK") ) >= 0
		If lMultFil .OR. !lCriouAmb
			ConOut("LJGrvBatch: "+"Empresa" + cEmp + "Filial" + aFiliais[ nCount ][1])  // "Empresa:" ### " Filial:"
			ConOut("            "+"Iniciando processo de gravacao batch...")  //"Iniciando processo de gravacao batch..."
		
			RPCSetType(3)  // Nao comer licensa
			PREPARE ENVIRONMENT EMPRESA cEmp FILIAL aFiliais[ nCount ][1] TABLES 	"MAL", "SLI", "SL1", "SL2",;
			 																		"SL4", "SA1", "SA2", "SA3",;
			 																		"SA6", "SAE", "SB1", "SB2",;
			 																		"SB3", "SC7", "SE1", "SE3",;
			 																		"SE4", "SE5", "SE8", "SED",;
			 																		"SEF", "SES", "SD1", "SD2",;
			 																		"SF1", "SF2", "SF3", "SF4",;
			 																		"SF7", "SFC", "SM2", "MAH"
			lCriouAmb := .T.
		Endif
		
		//�����������������������������������������������������������������������������Ŀ
		//�Todos os arquivos devem ser abertos antes de entrar no Begin Transaction.    �
		//�Caso exista customizacao, os arquivos devem ser abertos neste PE.            �
		//�OBS: O ADSSERVER nao permite uso da ChkFile() dentro de um Begin Transaction.�
		//�Em outros ambientes, este problema nao ocorre.                               �
		//�Retornar um array, por exemplo {"SZ1", "SZ2"}                                �
		//�������������������������������������������������������������������������������
		If ExistBlock("LJGRVOPEN")
			aFiles := ExecBlock("LJGRVOPEN", .F., .F.)
			RPCOpenTables(aFiles)
		EndIf
		
		SL1->(DbSetOrder(9))
		
		While SL1->(DbSeek(xFilial("SL1")+"RX"))
			If ( nPos := ASCAN( aBadRecno, SL1->( Recno() ) ) ) > 0
				While SL1->L1_FILIAL == xFilial("SL1") .AND. SL1->L1_SITUA == "RX" .AND. ;
					( ASCAN( aBadRecno, SL1->( Recno() ) ) > 0 )
					SL1->( DbSkip() )
				End
			EndIf
			
			//�����������������������������������������������������������������������������Ŀ
			//� Protejo situa��o de todos os orcamentos "RX" estarem em aBadRecno, neste    �
			//� caso n�o devo processar o proximo (que eh eof), mas sim abandonar o Loop    �
			//�������������������������������������������������������������������������������
			If SL1->L1_SITUA <> 'RX'
				Exit
			EndIf
			//������������������������������������������������Ŀ
			//�Verifica se os itens foram gravados corretamente�
			//��������������������������������������������������
			lTemReserva := .F.
			SL2->( DbSetOrder( 1 ) )
			If SL2->( DbSeek( xFilial( "SL2" ) + SL1->L1_NUM ) )
				//����������������������������������������������Ŀ
				//� Verifica se existe item com Reserva na venda �
				//������������������������������������������������
				While SL2->L2_FILIAL + SL2->L2_NUM == xFilial( "SL2" ) + SL1->L1_NUM
					If !Empty(SL2->L2_RESERVA) .AND. SL2->L2_ENTREGA <> "2"	//RETIRA
						lTemReserva := .T.
						exit
					Endif
					SL2->(DbSkip())					
                End
			Endif
			cEstacao  := SL1->L1_ESTACAO			
			aAreaSL1  := SL1->(GetArea())
			nRecSL1	  := SL1->(Recno())
			If lTemReserva
				Begin Transaction 
					bOldError := ErrorBlock( {|x| LjVerPedErro(x,lProcessou,aFiliais[nCount][1],nRecSL1) } ) // muda code-block de erro					
					Begin Sequence
						//��������������������������������������Ŀ
						//� Transforma o orcamento para pedido   �
						//����������������������������������������
						lProcessou := LJ7Pedido(	{} , 2, NIL, .F.,;
										  	   		{} , .T. )
							
						If !lProcessou
							UserException("LJGrvBatch: "+ "Filial "+ aFiliais[nCount][1] + ". "+"Problemas na gera��o do Pedido" )// "Filial " ### ". " "Problemas na gera��o do Pedido"
						EndIf	
					End Sequence
					ErrorBlock( bOldError )			

				End Transaction						
			Else
				lProcessou := LjGrvTudo(.F.)
			Endif
			
			RestArea(aAreaSL1)
			
			If lProcessou
				FRTProcSZ()
				//�����������������Ŀ
				//�Ponto de entrada.�
				//�������������������
	        	If lLJ7051
		            bOldError := ErrorBlock( {|x| LjVerifErro(x) } ) // muda code-block de erro
		            Begin Sequence
			            U_LJ7051()
		            Recover   
			            Conout("Nao conformidades na execucao do ponto de entrada LJ7051")//"Nao conformidades na execucao do ponto de entrada LJ7051"
		            End Sequence
		            //���������������������������������Ŀ
		            //� Restaura rotina de erro anterior�
		            //�����������������������������������
		            ErrorBlock( bOldError )
	            Endif
				If ( nTimes > 30 ) .OR. ( nIntervalo == nSleep )
					
					If File("LJGR"+cFileName+".FIM")
						
						ConOut("            "+"Solicitacao para finalizar gravacao batch atendida..."					) 	//"Solicitacao para finalizar gravacao batch atendida..."					

						//��������������������������������������Ŀ
						//�Somente apaga o arquivo quando existir�
						//����������������������������������������
						
						FErase("LJGR"+cFileName+".FIM")	
						lExProc := .F.
						Exit
					EndIf
					nTimes := 0
				EndIf
				//����������������������������������������������������Ŀ
				//�Somente apaga o arquivo de orcamentos quando existir�
				//�������������������������������������������������������
				LjxCDelArq( SL1->L1_NUM )
				
				nIntervalo := 0
				nTimes++
				
			Else
			
				LjGravaErr()
				ConOut("LJGrvBatch: "+ "Filial " + aFiliais[ nCount ][1] + ". "+"Ocorreu algum erro no processo de gravacao batch...") // "Filial " ### ". " "Ocorreu algum erro no processo de gravacao batch..."
				AADD(aBadRecno, SL1->(Recno()) )
			EndIf
			
			SL1->(DbSetOrder(9))
		End
			
		//����������������������������������������������������������������������������������������a�
		//�Checa se o arquivo existe fora so while do SL1 para apagar quando n�o existir RX no SL1 �
		//����������������������������������������������������������������������������������������a�
			
		If ( nTimes > 30 ) .OR. ( nIntervalo == nSleep )
			If File("LJGR"+cFileName+".FIM")
				ConOut("            "+"Solicitacao para finalizar gravacao batch atendida...") //"Solicitacao para finalizar gravacao batch atendida..."
				FErase("LJGR"+cFileName+".FIM")
				Exit
			EndIf
			nTimes := 0
		EndIf
		
		nIntervalo := 0
		nTimes++
		aBadRecno  := {}
		
		If lMultFil
			RESET ENVIRONMENT
		Endif	
		
		nIntervalo := nSleep

		If ( nIntervalo > 0 )
			Sleep(nIntervalo)           
		EndIf
		
		If lMultFil
			FClose(nHandle)
			FErase("LJGR"+cFileName+".WRK")
			
			ConOut("            "+"Empresa" + cEmp + "Filial" + aFiliais[ nCount ][1]+" - "+"Processo de gravacao batch finalizado...") //""Empresa:" ### " Filial: - Processo de gravacao batch finalizado..."
		Endif	
	Else
		ConOut(Repl("*",40)+Chr(10)+Chr(10))
		ConOut("LJGrvBatch: "+"Empresa" + cEmp + "Filial" + aFiliais[ nCount ][1])  // "Empresa:" ### " Filial:"
		ConOut("            "+"Processo de gravacao batch ja estava rodando")  //"Processo de gravacao batch ja estava rodando"
		
		lRetValue := .F.
		Exit
	EndIf
	If nCount < LEN( aFiliais )
		nCount := nCount + 1
	Else
		nCount := 1
	EndIf
End 

If !lMultFil .OR. !lExProc
	RESET ENVIRONMENT
Endif	

FClose(nHandle)
FErase("LJGR"+cFileName+".WRK")

Return ( lRetValue )