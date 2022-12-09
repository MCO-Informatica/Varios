#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function AprovProp()

Local _astru   := {}
Local _afields := {}     
Local _carq    := ""   
Local lInverte := .F. 

Local cIndTMB := ""   
Local cChavecAlias
Local aInd:={}
local cQuery := ""
Local aIndex := {} 

Private cPar01  := SUBSTR(DTOS(dDataBase),5,2)


Private cGrupo	 := AllTrim(UsrRetGRP(RetCodUsr()))
Private cColab	 	:= AllTrim(UsrFullName(RetCodUsr()))
Private cUsuario 	:= AllTrim(RetCodUsr())
Private cCodGrupo 	:= AllTrim(UsrRetGRP(cUsuario))
//Private cGrupo 		:= AllTrim(GRPRetName(cCodGrupo))  // Grupo Que o usuario Pertence
 
Private cCadastro := "Aprovação Apontamento de Horas"

	aRotina   := { { "Marcar Todos"    	,"U_Marcacao"  	 , 0, 1},;
					{ "Desmarcar Todos" ,"U_Desmarcar"   , 0, 2},;
	              	{ "Inverter Todos"  ,"U_MarcarTd" 	 , 0, 3},;
	               	{ "Aprovar"    		,"U_DesmarTD" 	 , 0, 4}}

// Estrutura da tabela temporaria	               

	AADD(_astru,{"Z4_OK"    ,"C",1 ,0 } )
	AADD(_astru,{"Z4_FILIAL","C",2 ,0 } )
	AADD(_astru,{"Z4_IDAPTHR"   ,"C",15 ,0 } )
	AADD(_astru,{"Z4_ITEMCTA"  ,"C",13 ,0 } )
	AADD(_astru,{"Z4_COLAB"  ,"C",40,0 } )
	AADD(_astru,{"Z4_DAta"  ,"D",8,0 } )
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
	SET FILTER TO SZ4->Z4_STATUS == "1" .AND. SZ4->Z4_ITEMCTA = "PROPOSTA" .AND. SUBSTR(DTOS(SZ4->Z4_DATA),5,2) == cPar01  //SZ4->Z4_COLAB >= MV_PAR01 .AND. SZ4->Z4_COLAB <= MV_PAR02 .AND. SZ4->Z4_ITEMCTA >= MV_PAR03 .AND. SZ4->Z4_ITEMCTA <= MV_PAR04   SZ4->Z4_ITEMCTA <> "ADMINISTRACAO" .AND.

	
//MarkBrow(cAlias,<campo_marca>,<quem não pode>,<array_camposbrw>,<condição_inicial>,<marca_atual>,,,,,<função_na_marca>)
  MarkBrow( "SZ4","Z4_OK"      ,               , _afields       ,lInverte           ,GetMark(,"SZ4","Z4_OK") )

SZ4->( DbCloseArea() )        				// fecha a tabela temporária



Return( NIL )

//********************************************************************************************************************

// Função para marcar todos os registros do browse
User Function Marcacao()

Local oMark := GetMarkBrow()    
Local lInvert := ThisInv()
Local  cMark := ThisMark()

DbSelectArea("SZ4")
SZ4->( DbGotop() )

While !SZ4->( Eof() .AND. ! lInvert )	
	IF RecLock( 'SZ4', .F. )		
		SZ4->Z4_OK := cMark
		MsUnLock()	
	EndIf	
	
	SZ4->(dbSkip())
	
Enddo       

MarkBRefresh( )      		// atualiza o browse
oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************


// Função para desmarcar todos os registros do browse
User Function Desnarcar()

Local oMark   := GetMarkBrow()      
Local lInvert := ThisInv()
Local cMark   := ThisMark()

DbSelectArea("SZ4")
SZ4->( DbGotop())

While ! SZ4->(Eof())	

	If RecLock( 'SZ4', .F. )		
		SZ4->Z4_OK := Space(1)
		MsUnLock()	
	EndIf
	
	SZ4->(dbSkip())

EndDo

MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************

// Função para grava marca no campo se não estiver marcado ou limpar a marca se estiver marcado

Static Function ValMarca02()       

Local lInvert := ThisInv()
Local cMarca  := ThisMark()

if IsMark( 'Z4_OK' )	
	
	RecLock( 'SZ4', .F. )	

 		SZ4->Z4_OK = Space(2)	

	MsUnLock()

Else	

	RecLock( 'SZ4', .F. )	

		SZ4->Z4_OK = cMarca
  
	MsUnLock()
EndIf

Return( NIL ) 

//********************************************************************************************************************
// Função para gravar\limpar marca em todos os registros                                                              

User Function MarcarTd()  

Local oMark := GetMarkBrow() 
Local lInvert := ThisInv()
 
dbSelectArea('SZ4')

SZ4->(dbGotop())

 While ! SZ4->(Eof())

 	//
 	ValMarca()
 	
	 SZ4->( dbSkip() )
	 
 EndDo
 	
MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro
 
Return( NIL )    

//********************************************************************************************************************
// Função para Deletar o Lote

User Function DesmarTD()

Local cMarca  := ThisMark()
Local nX	  := 0
Local lInvert := ThisInv()            
Local aRecDel := {}
//local cGrupo := GRPRetName(UsrRetGRP()[1])
Local cColab	 	:= AllTrim(UsrFullName(RetCodUsr()))

dbSelectArea("SZ4")

SZ4->(dbGotop())

//if cGrupo == "Diretoria" .OR. cGrupo == "Gerente_Operacoes" .OR. cGrupo == "ADMINISTRACAO" .OR. cColab == "Admin" .OR. cColab == "Administrador"

	While ! SZ4->(Eof())
	
		IF SZ4->Z4_OK == cMarca .AND. ! lInvert 
			
			AADD(aRecDel, SZ4->( Z4_OK ) )
			
		ElseIf SZ4->Z4_OK != cMarca .AND. lInvert 
		
			AADD(aRecDel, SZ4->( Z4_OK ) )
			
		EndIf
	
		SZ4->(dbSkip())
		
	EndDo
	
	
	If MsgYesNo( "Deseja aprovar :" +  cValToChar(Len(aRecDel))+ " itens Selecionados? ", "ATENÇÃO !!! ")
	
		If Len(aRecDel) > 0
		
			SZ4->( DbGoTop() )
		
	     While ! SZ4->( EOF() )
	
				For nX := 1 to Len(aRecDel)
					
					If AllTrim( SZ4->( Z4_OK ) ) == aRecDel[ nX ]
						RecLock("SZ4", .F. )
					
							SZ4->Z4_STATUS := "2"
							
							//**********************
											
								_cData 	:= 	SUBSTR(DTOC(SZ4->Z4_DATA),4,7)
								_cCC 	:= 	SUBSTR(SZ4->Z4_XXCC,1,1)
								_cIC	:= 	alltrim(Z4_ITEMCTA)
								//***************************
									dbSelectArea("SZ5")
									SZ5->( dbSetOrder(4) )
									
									If alltrim(_cIC) == "PROPOSTA" 
									 	
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"PROPOSTA") )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
										
									Else
									
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"CONTRATO") )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
									
									Endif
									
									
									/*	
									If alltrim(_cIC) == "PROPOSTA" .AND. _cCC $ "1/4/5/6/7/8/9"
									 	
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"0") )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
										
									Elseif alltrim(_cIC) == "PROPOSTA" .AND. _cCC = "3" 
									
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+_cCC) )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
									
									Elseif alltrim(_cIC) == "PROPOSTA" .AND. _cCC = "4" 
									
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+_cCC) )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
										
									Elseif alltrim(_cIC) == "ENGENHARIA" .OR. alltrim(_cIC) == "QUALIDADE" .AND. _cCC == "2" 
									
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+_CC) )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
									
									ElseIf SUBSTR(_cIC,1,2) $ "AT/EQ/EN/GR/ST/PR" .AND. _cCC $ "1/2/3/4/5/6/7/8/9"
									 	
										If SZ5->( dbSeek( xFilial("SZ5")+_cDATA+"0") )
											nVLHR  		:= SZ5->Z5_VLRHR
										ENDIF
										
									Endif
									*/
								//***************************
								nQTDHRS	:= SZ4->Z4_QTDHRS 
								nResult := nQTDHRS * nVLHR
								
								SZ4->Z4_VLRHR := nVLHR
								SZ4->Z4_TOTVLR := nResult
								SZ4->Z4_OK		:= SPACE(1)
							
							//**********************
													
						MsUnLock()	
					EndIf
				Next nX
				
				SZ4->( DbSkip() )
		  EndDo
		  
		EndIf
	
	EndIf
	
	SET FILTER TO SZ4->Z4_STATUS = "1"  
	MarkBRefresh( )      		// atualiza o browse
	oMark:oBrowse:Gotop()		// força o posicionamento do browse no primeiro registro
//Else
	//MsgInfo( "Recurso não disponível." )
	//Return .F.
	
//EndIF

Return( NIL )

Static Function fAjustaSx1()

cAlias	:= Alias()
_nPerg 	:= 1

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cAprovSZ4)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cAprovSZ4)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cAprovSZ4,"01","Mes Inicial?		","","","mv_ch1","C",02,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cAprovSZ4,"02","Data Final?			","","","mv_ch2","C",02,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})



IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
Return


