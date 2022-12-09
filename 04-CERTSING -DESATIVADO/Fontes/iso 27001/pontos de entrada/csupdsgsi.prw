# Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSUpdAtv1  � Autor � Marcelo Celi Marques � Data � 01/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualizacao dos SXs.				                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/          
User Function CSUpdSGSI()
Local aSM0 		:= AdmAbreSM0()                 
Local cOldEmp	:= ""
Local aButtons	:= {}
Local aSays		:= {}
Local nOpcA		:= 0

aAdd(aSays,"Rotina de Update do SGSI. Todos os parametros, tabelas e campos ")
aAdd(aSays,"serao criados automaticamente.")
aAdd(aSays,"Vide documenta��o do projeto. Realizar uma c�pia de seguran�a dos ")
aAdd(aSays,"dicion�rios e base de dados antes de seguir adiante.  Caso isso ja ")
aAdd(aSays,"tenha sido realizado, clicar no bot�o OK para continuar.")

aAdd(aButtons, {1,.T.,{|o| nOpcA:=1, o:oWnd:End() }})
aAdd(aButtons, {2,.T.,{|o| nOpcA:=0, o:oWnd:End() }})
FormBatch("Update",aSays,aButtons,,,425)

If nOpcA>0	
	//OpenSm0Excl()
	
	For nInc :=1 to Len(aSm0)
		RpcSetType(3)
		RpcSetEnv( aSm0[nInc][1],aSm0[nInc][2])
		
		RpcClearEnv()
		//OpenSm0Excl()
	Next
	                 
	For nInc := 1 to Len(aSm0)
		RpcSetType(3)
		RpcSetEnv( aSm0[nInc][1],aSm0[nInc][2])
	    
		If cEmpAnt != cOldEmp
			cOldEmp	 := cEmpAnt
		EndIf	
	    
		MsgRun("Processando update de programa SGSI...","Cadastro de Ativos"		,{|| u_CSUpdAtv1() }) 
		MsgRun("Processando update de programa SGSI...","Cadastro de Operadores"	,{|| u_CSUpdUSGS() })
     
	    RpcClearEnv()
	    //OpenSm0Excl()
	Next
	
	RpcSetEnv(aSm0[1][1], aSm0[1][2],,,,, {"AE1"})
	
	MsgAlert("Update do SGSI Concluido...")    
	  
EndIf	
	
Return           
                                  
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AdmAbreSM0� Autor � Marcelo Celi Marques  � Data � 12/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array com as informacoes das filias das empresas ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AdmAbreSM0()
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )
    
RpcSetEnv( "01", "01",,,,, { "AE1" } )

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
					IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
					"",;
					"",;
					"",;
					SM0->M0_NOME,;
					SM0->M0_FILIAL }

		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RpcClearEnv()

Return aRetSM0
