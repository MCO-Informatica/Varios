#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH" 

User Function FMarcCon() 

Local _astru   := {}
Local _afields := {} 
Local aCampos := {}       
Local _carq    := ""   
Local lInverte := .F. 
Local nI

Local cIndTMB := ""   
Local cChavecAlias

Private cCadastro := "Aprovação Apontamento de Horas"
Private cPar01  := SUBSTR(DTOS(dDataBase),5,2)

	aRotina   := { { "Marcar Todos"    ,"U_MarcCont"   , 0, 1},;
					{ "Desmarcar Todos" ,"U_DesmCont"   , 0, 2},;
	              	{ "Inverter Todos"  ,"U_MarTodosCont" , 0, 3},;
	               	{ "Contabilizar"    ,"U_Contabilizar" , 0, 4}}

// Estrutura da tabela temporaria	               

	AADD(_astru,{"Z4_LA"    ,"C",1 ,0 } )
	AADD(_astru,{"Z4_FILIAL","C",2 ,0 } )
	AADD(_astru,{"Z4_IDAPTHR"   ,"C",6 ,0 } )
	AADD(_astru,{"Z4_ITEMCTA"  ,"C",2 ,0 } )
	AADD(_astru,{"Z4_COLAB"  ,"C",40,0 } )
	AADD(_astru,{"Z4_DATA"  ,"D",8,0 } )
	AADD(_astru,{"Z4_STATUS"  ,"C",2,0 } )


	
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(_afields)
	  	 IF dbSeek(_afields[nI])
	  	 	aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),;
	   			 Trim(X3_PICTURE)})
		ENDIF
	Next
	
 
	If Select("SZ4") <> 0
		DBSelectArea("SZ4")
		DBCloseArea()
	EndIf 

	dbSelectArea("SZ4")
	dbSetOrder(1)
	SET FILTER TO SZ4->Z4_STATUS == "2" .AND. !SZ4->Z4_ITEMCTA $ ("ADMINISTRACAO/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/OPERACOES/ESTOQUE")  .AND. SUBSTR(DTOS(SZ4->Z4_DATA),5,2) == cPar01 
	//MarkBrow(cAlias,<campo_marca>,<quem não pode>,<array_camposbrw>,<condição_inicial>,<marca_atual>,,,,,<função_na_marca>)
  MarkBrow( "SZ4","Z4_LA"      ,               , _afields       ,lInverte           ,GetMark(,"SZ4","Z4_LA") )

SZ4->( DbCloseArea() )        				// fecha a tabela temporária



Return( NIL )

//********************************************************************************************************************

// Função para marcar todos os registros do browse
User Function MarcCont()

Local oMark := GetMarkBrow()    
Local lInvert := ThisInv()
Local  cMark := ThisMark()

DbSelectArea("SZ4")
SZ4->( DbGotop() )

While !SZ4->( Eof() .AND. ! lInvert )	
	IF RecLock( 'SZ4', .F. )		
		SZ4->Z4_LA := cMark
		MsUnLock()	
	EndIf	
	
	SZ4->(dbSkip())
	
Enddo       

MarkBRefresh( )      		// atualiza o browse
oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************


// Função para desmarcar todos os registros do browse
User Function DesmCont()

Local oMark   := GetMarkBrow()      
Local lInvert := ThisInv()
Local cMark   := ThisMark()

DbSelectArea("SZ4")
SZ4->( DbGotop())

While ! SZ4->(Eof())	

	If RecLock( 'SZ4', .F. )		
		SZ4->Z4_LA := Space(1)
		MsUnLock()	
	EndIf
	
	SZ4->(dbSkip())

EndDo

MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************

// Função para grava marca no campo se não estiver marcado ou limpar a marca se estiver marcado

Static Function ValMarcaCont()       

Local lInvert := ThisInv()
Local cMarca  := ThisMark()

if IsMark( 'Z4_LA' )	
	
	RecLock( 'SZ4', .F. )	

 		SZ4->Z4_LA = Space(2)	

	MsUnLock()

Else	

	RecLock( 'SZ4', .F. )	

		SZ4->Z4_LA = cMark
  
	MsUnLock()
EndIf

Return( NIL ) 

//********************************************************************************************************************
// Função para gravar\limpar marca em todos os registros                                                              
/*
User Function MarTodosCont()  

Local oMark := GetMarkBrow() 
Local lInvert := ThisInv()
 
dbSelectArea('SZ4')

SZ4->(dbGotop())

 While ! SZ4->(Eof())

 	//
 	ValMarcaCont()
 	
	 SZ4->( dbSkip() )
	 
 EndDo
 	
//MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro
 
Return( NIL )    
*/
//********************************************************************************************************************
// Função para Deletar o Lote

User Function Contabilizar()
Local cColab	 := AllTrim(UsrFullName(RetCodUsr()))
Local cMarca  := ThisMark()
Local nX	  := 0
Local lInvert := ThisInv()            
Local aRecDel := {}
Local nVLHR 	:= 0
Local _cData		:= ""
Local nResult	:= 0
//*******
Local cLote    := "100001"
Local cArquivo := ""
Local nTotal   := 0
Local nHdlPrv  := HeadProva(cLote,"CFGX019","",@cArquivo)
//*******
//Local cGrupo   := GRPRetName(UsrRetGRP()[1])
Local cUsuario := AllTrim(UsrFullName(RetCodUsr()))
Private cPar01  := SUBSTR(DTOS(dDataBase),5,2)


dbSelectArea('SZ4')

SZ4->(dbGotop())

//if cGrupo == "Diretoria" .OR. cGrupo == "Administracao" .OR. cColab == "Administrador" .OR. cColab== "Admin"

	While ! SZ4->(Eof())
	
		IF SZ4->Z4_LA == cMarca .AND. ! lInvert 
			
			AADD(aRecDel, SZ4->( Z4_LA ) )
			
		ElseIf SZ4->Z4_LA != cMarca .AND. lInvert 
		
			AADD(aRecDel, SZ4->( Z4_LA ) )
			
		EndIf
	
		SZ4->(dbSkip())
		
	EndDo
	
	
	If MsgYesNo( "Deseja Contabilizar :" +  cValToChar(Len(aRecDel))+ " itens Selecionados? ", "ATENÇÃO !!! ")
	
		If Len(aRecDel) > 0
		
			SZ4->( DbGoTop() )
		
	     While ! SZ4->( EOF() )
				
				//_cData := DTOC(SZ4->Z4_DATA)
				
							
				
				For nX := 1 to Len(aRecDel)
					
					If Z4_STATUS == "2" //AllTrim( SZ4->( Z4_LA ) ) == aRecDel[ nX ] .and. 
						RecLock("SZ4", .F. )
							
							//SZ4->Z4_STATUS := "3"
									
							While SZ4->(!EOF()) .AND. ! EMPTY(SZ4->Z4_LA) 
							          
							     If VerPadrao("XAP")
							          nTotal += DetProva(nHdlPrv,'XAP',"CFGX019",cLote)
							     EndIf
							     RecLock("SZ4", .F. ) 
							     SZ4->Z4_STATUS := "3"
							     SZ4->Z4_OK		:= SPACE(1)
							     SZ4->Z4_LA		:= SPACE(1)
							     SZ4->(dbSkip())
							Enddo   
							
							If nTotal > 0
							     RodaProva(nHdlPrv,nTotal)
							     lLancOk := cA100Incl(cArquivo,nHdlPrv,3,cLote,.T.,.F.)
							EndIf
							
						MsUnLock()	
					EndIf
				Next nX
				
				SZ4->( DbSkip() )
		  EndDo
		  
		  
		  
		EndIf
	
	EndIf
	
	SET FILTER TO SZ4->Z4_STATUS == "2" .AND. !SZ4->Z4_ITEMCTA $ ("ADMINISTRACAO/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX") .AND. SUBSTR(DTOS(SZ4->Z4_DATA),5,2) == cPar01 
	MarkBRefresh( )      		// atualiza o browse
	oMark:oBrowse:Gotop()		// força o posicionamento do browse no primeiro registro

//Else
//	MsgInfo( "Recurso não disponível." )
//	Return .F.
//EndIF

Return( NIL )


