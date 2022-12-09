#include "rwmake.ch"

Static lSubTurma := JBE->( FieldPos( "JBE_SUBTUR")) > 0 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021A    ³ Autor ³ Gustavo Henrique     ³ Data ³ 05/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra os cursos de destino para trazer so os que forem da    ³±±
±±³          ³mesma area do curso de origem.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0021A        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	³±±
±±³          ³campo do script.                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0021A( lScript, lWeb, cNumRa, cCodCur, cPerlet, cTurma, cCodCurDes, cPerDes )

Local cRA			:= ""			// RA do aluno 
Local cCursoDes		:= ""			// Curso de destino
Local cCurso1		:= ""			// Curso principal do curso de origem
Local cCurso2		:= ""			// Curso principal do curso de destino
Local lRet			:= .T.      
Local cVersao		:= ""			// versao do curso padrao de destino    

lWeb        := If( lWeb == NIL, .F., .T. )
lScript		:= If( lScript == NIL, .F., .T. )
cCodCur    := Iif(cCodCur    == Nil, M->JBH_SCP01, cCodCur)
cCodCurDes := Iif(cCodCurDes == Nil, M->JBH_SCP12, cCodCurDes)

If !lWeb                                         

	cRA			:= Left( M->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
	cCursoDes	:= JBK->JBK_CODCUR
	
	If lScript
		lRet := ExistCpo( "JBK", M->JBH_SCP12 + M->JBH_SCP03 )
		If lRet
			cCursoDes := M->JBH_SCP12
			JBK->( dbSetOrder( 1 ) )
			lRet := JBK->( dbSeek( xFilial( "JBK" ) + M->JBH_SCP12 + M->JBH_SCP03 ) )
			If ! lRet
				MsgStop( "Não existe grade de aluas definida para o 1o. período deste curso." )
			EndIf
		EndIf
	EndIf

	If lRet
	
		// Soh permite selecionar os cursos que o aluno nao estah ativo
		JBE->( dbSetOrder( 3 ) )
	
		lRet := ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + cRA + cCursoDes ) )
	
		If lScript .and. ! lRet
			MsgStop( "O Aluno já está matriculado neste curso." )
		EndIf
	
		If lRet
		
			// Verifica se o curso selecionado estah com grade ativa e o perido letivo eh o mesmo
			// do curso de origem.
			lRet := ( JBK->JBK_ATIVO == "1" .and. JBK->JBK_PERLET == M->JBH_SCP03 )
			   
			If lScript .and. ! lRet
				MsgStop( "O curso deve ter grade de aulas ativa no 1o. periodo letivo." )
			EndIf	
			
			If lRet
			            
				// Se a unidade foi preenchida, apresenta apenas os cursos da unidade
				JAH->( dbSetOrder( 1 ) )
				JAH->( dbSeek( xFilial( "JAH" ) + JBK->JBK_CODCUR ) )

				lRet := If( ! Empty( M->JBH_SCP10 ), ( M->JBH_SCP10 == JAH->JAH_UNIDAD ), .T. )
				
				If lRet
			                      
					// Guarda o curso do curso vigente de destino e posiciona no curso vigente de destino
					cCurso2 := JAH->JAH_CURSO  
					cVersao := JAH->JAH_VERSAO  				
        			JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP01 ) )

				
					If lScript                                               
						If ! lRet
							MsgStop( "O aluno está matriculado no mesmo curso selecionado." )
						Else
							M->JBH_SCP13 := Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP12,"JAH_DESC")
							M->JBH_SCP14 := JBK->JBK_PERLET
							M->JBH_SCP15 := JBK->JBK_HABILI
							M->JBH_SCP16 := Posicione("JDK",1,xFilial("JDK")+JBK->JBK_HABILI,"JDK_DESC")
						EndIf	
					EndIf

				EndIf
		
			EndIf
			
		EndIf
		
	EndIf	

Else 

	// Soh permite selecionar os cursos que o aluno nao estah ativo
	JBE->( dbSetOrder( 3 ) )		
	If ! (JBE->( dbSeek( xFilial( "JBE" ) + "1" + cNumRa + cCodCurDes)))
		// Verifica se o curso selecionado estah com grade ativa e o perido letivo eh o mesmo
		// do curso de origem.      
		JBK->( dbSetOrder( 1 ) )
		JBK->( dbSeek( xFilial( "JBK" ) + cCodCurDes + cPerDes ))
		If ! JBK->( Eof() )
		    If ( JBK->JBK_ATIVO == "1" .and. JBK->JBK_PERLET == cPerlet )
			    // O curso de destino selecionado deve ter o curso principal diferente do curso de origem
				cCurso1 := Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCur, "JAH_CURSO" )
				cCurso2 := Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCurDes, "JAH_CURSO" )
				                          
			Else 
			    lRet := .F.	
		    EndIf
		Else    
			lRet := .F.
		EndIf	
	Else
    	lRet := .F.
	EndIf

EndIf

Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021B    ³ Autor ³ Gustavo Henrique     ³ Data ³ 08/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra os periodos letivos para selecao utilizando a opcao    ³±±
±±³          ³manutencao no requerimento de Transferencia de Curso - Calouro³±±
±±³          ³e Transferencia de Curso - Veteranos.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0021B        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	³±±
±±³          ³campo do script.                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0021B( lScript, lWeb )

Local aRet      := {}
Local lRet		:= .T.
Local cPerLet	:= ""
Local cCurso	:= ""
Local cHabili  := ""

lScript := If( lScript == NIL, .F., lScript )
lWeb    := IIf( lWeb == Nil , .F. , lWeb)
cCurso	:= JAR->JAR_CODCUR
cPerLet	:= JAR->JAR_PERLET
cHabili  := JAR->JAR_HABILI

If lScript
	lRet	:= ExistCpo( "JAR", M->JBH_SCP12 + M->JBH_SCP14 + M->JBH_SCP15 )
	cCurso	:= M->JBH_SCP12
	cPerLet	:= M->JBH_SCP14
	cHabili := M->JBH_SCP15
EndIf

If lRet
                                        
	JBK->( dbSetOrder( 1 ) )
	JBK->( dbSeek( xFilial( "JBK" ) + M->JBH_SCP12 + cPerLet + cHabili) )

	lRet := ( cCurso == JBK->JBK_CODCUR .and. JBK->JBK_ATIVO == "1" )

	If lScript .and. ! lRet
		If !lWeb
			MsgStop( "Nao existe grade de aulas ativa para este periodo letivo." )
		Else 
    	    aadd(aRet,{.F.,"Nao existe grade de aulas ativa para este periodo letivo."})	
	        Return aRet			
		EndIf
	EndIf

EndIf	

Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021C    ³ Autor ³ Gustavo Henrique     ³ Data ³ 24/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a unidade selecionada.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0021C        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0021c(lWeb)

Local lRet	:= .T.
Local aArea	:= GetArea()

lWeb	:= iif(lWeb == nil,.F.,lWeb)

dbSelectArea( "JA3" )                 


If !lWeb
If ! Empty( M->JBH_SCP10 )

	lRet := ExistCpo( "JA3", M->JBH_SCP10 )
	    
	If lRet
		M->JBH_SCP11 := Posicione( "JA3", 1, xFilial("JA3") + M->JBH_SCP10, "JA3_DESLOC" )
	EndIf

Else                  

	M->JBH_SCP11 := ""
	
EndIf

else //lWeb
	If ! Empty( httppost->PERG08 )
	
		lRet := ExistCpo( "JA3", httppost->PERG08 )
		    
		If lRet
			M->JBH_SCP09 := Posicione( "JA3", 1, xFilial("JA3") + httppost->PERG08, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		httppost->PERG09 := ""
		
	EndIf

EndIf


		
RestArea( aArea )

Return( lRet )
              
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021d    ³ Autor ³ Gustavo Henrique     ³ Data ³ 24/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida se o aluno esta matriculado nao eh calouro, ou seja,   ³±±
±±³          ³estah matriculado no segundo periodo letivo em diante.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0021d        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0021d(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

If Val(M->JBH_SCP03) > 1 	// Jah cursou o primeiro periodo letivo do curso
    If !lWeb                                               
		MsgInfo( "Este aluno não está matriculado no primeiro semestre." + Chr(13) + Chr(10) +;
				 "Utilize a Transferência de Curso para Veteranos." )
		lRet := .F.
	Else 
        aadd(aRet,{.F.,"Este aluno não está matriculado no primeiro semestre e não pode ser transferido."})	
        Return aRet
	EndIf	
EndIf

If lSubTurma .and. Type("M->JBH_SCP20") <> "U"
	lRet := ExecBlock( "SEC0021f", .F., .F., { lWeb } )
Endif
 
Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021E    ³ Autor ³ Marcos Cesar         ³ Data ³ 28/06/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Fazer a verificacao da Habilitacao informada no Script.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0021E             					    						       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	 ³±±
±±³          ³campo do script.                                            	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0021e(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa o Cadastro de Habilitacao.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
JDK->(dbSetOrder(1))
JDK->(dbSeek(xFilial("JDK") + M->JBH_SCP15))

If JDK->(!Found())
	If !lWeb
		MsgInfo("Essa Habilitação não está cadastrada.")
		lRet := .F.
	Else
		Aadd(aRet, { .F., "Essa Habilitação não está cadastrada." })

		Return aRet
	EndIf
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa o Arquivo Curso Vigente x Período Letivo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	JAR->(dbSetOrder(1))
	JAR->(dbSeek(xFilial("JAR") + M->JBH_SCP12 + M->JBH_SCP14 + M->JBH_SCP15))

	If JAR->(!Found())
		If !lWeb
			MsgInfo("Essa Habilitação não existe no Curso/Período Letivo informado.")
			lRet := .F.
		Else
			Aadd(aRet, { .F., "Essa Habilitação não existe no Curso/Período Letivo informado." })

			Return aRet
		EndIf
	EndIf
EndIf
                                                 
Return( lRet )   


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0021f    ³ Autor ³ Fernando Amorim      ³ Data ³05/AGO/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica as subturmas do curso                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0020e        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - .T. - Validacao pelo Script da solicitacao.           ³±±
±±³          ³        .F. - Chamado do filtro da consulta SXB J27.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0021f( lWeb )

Local lRet 	  := .T.
Local aRet 	  := {}
Local cQuery  := ""
Local cTipGrd := ""

lWeb := IIf( lWeb == Nil , .F., lWeb)

If lRet
   	lRet := (JBK->JBK_CODCUR == M->JBH_SCP12 .and. JBK->JBK_PERLET == M->JBH_SCP14 .and. JBK->JBK_HABILI == M->JBH_SCP15 .and.;
   			 JBK->JBK_ATIVO == "1" )
			
   	If lRet		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica qual o tipo de grade para poder realizar a consulta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		DbSelectArea("JAF")
		JAH->(DbSetOrder(1))
		JAH->(DbSeek(xFilial("JAH") + M->JBH_SCP12))
		cTipGrd := Iif(JAF->( FieldPos( "JAF_TIPGRD" ) ) > 0, Posicione("JAF",1,xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO), "JAF_TIPGRD"), "1")
		
		If cTipGrd == "1" //Grade Semanal
			cQuery := "SELECT DISTINCT JBL_SUBTUR FROM " + RetSQLName("JBL")
			cQuery += " WHERE JBL_FILIAL = '" + xFilial("JBL") + "' "
			cQuery += "   AND JBL_CODCUR = '" + M->JBH_SCP12 + "' "
			cQuery += "   AND JBL_PERLET = '" + M->JBH_SCP14 + "' "
			cQuery += "   AND JBL_HABILI = '" + M->JBH_SCP15 + "' "
			cQuery += "   AND JBL_TURMA  = '" + M->JBH_SCP20 + "' "
			cQuery += "   AND JBL_SUBTUR = '" + M->JBH_SCP21 + "' "
			cQuery += "   AND D_E_L_E_T_ = ' '"	
		Else //Diaria
			cQuery := "SELECT DISTINCT JD2_SUBTUR FROM " + RetSQLName("JD2")
			cQuery += " WHERE JD2_FILIAL = '" + xFilial("JD2") + "' "
			cQuery += "   AND JD2_CODCUR = '" + M->JBH_SCP12 + "' "
			cQuery += "   AND JD2_PERLET = '" + M->JBH_SCP14 + "' "
			cQuery += "   AND JD2_HABILI = '" + M->JBH_SCP15 + "' "
			cQuery += "   AND JD2_TURMA  = '" + M->JBH_SCP20 + "' "
			cQuery += "   AND JD2_SUBTUR = '" + M->JBH_SCP21 + "' "
			cQuery += "   AND D_E_L_E_T_ = ' '"	
		Endif		
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYSUBTUR", .F., .F. )
		
		If _QRYSUBTUR->(Eof())
			lRet := .F.
			If !lWeb
				MsgStop( "A sub-turma informada não existe" )
			Else
				aadd(aRet,{.F.,"A sub-turma informada não existe."})
		        Return aRet
			Endif
		Endif
		_QRYSUBTUR->(DbCloseArea())
		DbSelectArea("JA2")
	EndIf
EndIf

Return( lRet )
