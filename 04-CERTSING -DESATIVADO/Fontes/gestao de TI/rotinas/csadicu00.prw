# Include "Protheus.ch"

#DEFINE X3_USADO_EMUSO 		"€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO 	"€€€€€€€€€€€€€€€"   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ CSADicU00 ³ Autor ³ Marcelo Celi Marques ³ Data ³05/12/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta Dicionario da U00.				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSADicU00()
Local aSM0 		:= AdmAbreSM0()                 
Local cOldEmp	:= ""
Local aButtons	:= {}
Local aSays		:= {}
Local nOpcA		:= 0

aAdd(aSays,"Rotina de update da tabela SM0.")
aAdd(aSays,"")
aAdd(aSays,"")
aAdd(aButtons, {1,.T.,{|o| nOpcA:=1, o:oWnd:End() }})
aAdd(aButtons, {2,.T.,{|o| nOpcA:=0, o:oWnd:End() }})
FormBatch("Importação de Agentes",aSays,aButtons,,,425)
If nOpcA>0	
	OpenSm0Excl()
	
	For nInc :=1 to Len(aSm0)
		RpcSetType(3)
		RpcSetEnv( aSm0[nInc][1],aSm0[nInc][2])
		
		RpcClearEnv()
		OpenSm0Excl()
	Next
	                 
	For nInc := 1 to Len(aSm0)
		RpcSetType(3)
		RpcSetEnv( aSm0[nInc][1],aSm0[nInc][2])
	    
		If cEmpAnt != cOldEmp
			cOldEmp	 := cEmpAnt
		EndIf	
	
		Processa({ |x| CSADicU00() },"Aguarde","Processando Compatibilizador na tabela U00")
	         
	    RpcClearEnv()
	    OpenSm0Excl()
	Next
	
	RpcSetEnv(aSm0[1][1], aSm0[1][2],,,,, {"AE1"})      
EndIf	
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ CSADicU00 ³ Autor ³ Marcelo Celi Marques ³ Data ³05/12/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta Dicionario da U00.				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Certisign		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CSADicU00()
Local aSX3 		:= {}
Local aSIX 		:= {}   
Local aEstrut	:= {}
Local i, j    
Local aArea		:= GetArea()     

SX2->(dbSetOrder(1))
If SX2->(dbSeek("U00"))

	//->> Criacao dos campos da tabela
	aEstrut:= 	{	"X3_ARQUIVO"		,"X3_ORDEM" ,"X3_CAMPO"  		,"X3_TIPO"  ,"X3_TAMANHO"				,"X3_DECIMAL"		,"X3_TITULO" 	,"X3_TITSPA","X3_TITENG","X3_DESCRIC"			,"X3_DESCSPA"	,"X3_DESCENG"	,"X3_PICTURE"			,"X3_VALID" 				,"X3_USADO"  		,"X3_RELACAO"		,"X3_F3"				,"X3_NIVEL" ,"X3_RESERV","X3_CHECK"	,"X3_TRIGGER"	,"X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT"	,"X3_OBRIGAT"	,"X3_VLDUSER"		,"X3_CBOX"   						,"X3_CBOXSPA"	,"X3_CBOXENG"	,"X3_PICTVAR"	,"X3_WHEN"  	  			,"X3_INIBRW"		  			,"X3_GRPSXG","X3_FOLDER"	,"X3_PYME"	}			
	aAdd( aSX3,	{ 	"U00"				,"82"		,"U00_MACADD"		,"C"		, 15						, 0					,"Mac Address"	,""			,""			,"Mac Address"			,""				,""				,"@R XX-XX-XX-XX-XX-XX"	,""							,X3_USADO_EMUSO		,""			 		,""						,1			,"þÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""					,""									,""				,""				,""				,""							,""					  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U00"				,"83"		,"U00_ENTPOS"		,"C"		, Tamsx3("Z3_CODENT")[1]	, 0					,"Ent.Posto"	,""			,""			,"Entidade Posto"		,""				,""				,"@!"					,""							,X3_USADO_EMUSO		,""			 		,"SZ3"					,1			,"þÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""					,""									,""				,""				,""				,"Empty(M->U00_ENTFIL)"		,""					  			,""			,""				,"S"		})
	aAdd( aSX3,	{ 	"U00"				,"84"		,"U00_ENTFIL"		,"C"		, Tamsx3("U00_FILIAL")[1]	, 0					,"Ent.Filial"	,""			,""			,"Entidade Filial"		,""				,""				,"@!"					,""							,X3_USADO_EMUSO		,""			 		,"SM0"					,1			,"þÀ"		,""			,""				,"S"		,"N"		,""			,""				,""				,""					,""									,""				,""				,""				,"Empty(M->U00_ENTPOS)"		,""					  			,""			,""				,"S"		})
			
	dbSelectArea("SX3")
	dbSetOrder(2)
	For i:= 1 To Len(aSX3)
		SX3->(dbSetOrder(2))
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
		Else                  
			RecLock("SX3",.F.)
		EndIf			
		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	Next i                      
	
	If SX3->(dbSeek("U00_DESHRD")) 
		RecLock("SX3")
		SX3->X3_TITULO := "Modelo"
		SX3->(MsUnlock())
	EndIf
	
	If SX3->(dbSeek("U00_MARCA")) 
		RecLock("SX3")
		SX3->X3_TITULO := "Fabricante"
		SX3->(MsUnlock())
	EndIf
	
	//->>Criacao dos indices da tabela
	aEstrut:= {"INDICE"			,"ORDEM","CHAVE"											,"DESCRICAO"			,"DESCSPA"					,"DESCENG"					,"PROPRI"	,"F3"	,"NICKNAME"	,"SHOWPESQ"}
	Aadd(aSIX,{"U00"			,"C"	,"U00_FILIAL+U00_NUMSER"							,"Filial+Num.Serie"		,"Filial+Num.Serie"			,"Filial+Num.Serie"			,"S"		,""		,""			,"S"})  
	Aadd(aSIX,{"U00"			,"D"	,"U00_FILIAL+U00_MACADD"							,"Filial+Host"			,"Filial+Host"				,"Filial+Num.Serie"			,"S"		,""		,""			,"S"})  
			
	dbSelectArea("SIX")
	dbSetOrder(1)
	For i:= 1 To Len(aSIX)
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
		Else                  
			RecLock("SIX",.F.)
		EndIf
		For j:=1 To Len(aSIX[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	Next i     
	                  	
	//->> Ajuste Fisico na Tabela, caso ja exista.
	__SetX31Mode(.F.)
	If Select("U00")>0
		dbSelecTArea("U00")
		dbCloseArea()
	EndIf
	X31UpdTable("U00")
	If __GetX31Error()
		If lUpdAuto    
			MsOpenDbf(.T.,"TOPCONN",cTabe+SM0->M0_CODIGO+"0","U00",.T.,.F.,.F.,.F.)
		EndIf
	EndIf	
	dbSelectArea("U00")
    
	SIX->(dbSetOrder(1))
	SIX->(dbSeek("U00"))
	Do While SIX->INDICE == "U00"
	    Reclock("SIX",.F.)
	    If Alltrim(SIX->CHAVE) $ "U00_FILIAL+U00_NUMSER|U00_FILIAL+U00_COMATV|U00_FILIAL+U00_MAILFU|U00_FILIAL+U00_MACADD"
    		SIX->SHOWPESQ := "S"
    	Else
    		SIX->SHOWPESQ := "N"
    	EndIf
    	SIX->(MsUnlock())
    	SIX->(dbSkip())
    EndDo
    
EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 07/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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





