# Include "Protheus.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矯SUpdAtv1  � Autor � Marcelo Celi Marques � Data � 01/10/12 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨tualizacao dos SXs.				                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Certisign                                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/          
User Function CSUpdSGSI()
Local aSM0 		:= AdmAbreSM0()                 
Local cOldEmp	:= ""
Local aButtons	:= {}
Local aSays		:= {}
Local nOpcA		:= 0

aAdd(aSays,"Rotina de Update do SGSI. Todos os parametros, tabelas e campos ")
aAdd(aSays,"serao criados automaticamente.")
aAdd(aSays,"Vide documenta玢o do projeto. Realizar uma c髉ia de seguran鏰 dos ")
aAdd(aSays,"dicion醨ios e base de dados antes de seguir adiante.  Caso isso ja ")
aAdd(aSays,"tenha sido realizado, clicar no bot鉶 OK para continuar.")

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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矨dmAbreSM0� Autor � Marcelo Celi Marques  � Data � 12/12/12 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 砇etorna um array com as informacoes das filias das empresas 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
