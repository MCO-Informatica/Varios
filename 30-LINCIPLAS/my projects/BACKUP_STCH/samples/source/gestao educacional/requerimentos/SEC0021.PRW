#include "rwmake.ch"

Static lSubTurma := JBE->( FieldPos( "JBE_SUBTUR")) > 0 

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021A    ? Autor ? Gustavo Henrique     ? Data ? 05/07/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 矲iltra os cursos de destino para trazer so os que forem da    潮?
北?          砿esma area do curso de origem.                                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0021A        					    						潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros矱XPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	潮?
北?          砪ampo do script.                                            	潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
				MsgStop( "N鉶 existe grade de aluas definida para o 1o. per韔do deste curso." )
			EndIf
		EndIf
	EndIf

	If lRet
	
		// Soh permite selecionar os cursos que o aluno nao estah ativo
		JBE->( dbSetOrder( 3 ) )
	
		lRet := ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + cRA + cCursoDes ) )
	
		If lScript .and. ! lRet
			MsgStop( "O Aluno j? est? matriculado neste curso." )
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
							MsgStop( "O aluno est? matriculado no mesmo curso selecionado." )
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021B    ? Autor ? Gustavo Henrique     ? Data ? 08/07/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 矲iltra os periodos letivos para selecao utilizando a opcao    潮?
北?          砿anutencao no requerimento de Transferencia de Curso - Calouro潮?
北?          砮 Transferencia de Curso - Veteranos.                         潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0021B        					    						潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros矱XPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	潮?
北?          砪ampo do script.                                            	潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021C    ? Autor ? Gustavo Henrique     ? Data ? 24/09/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 砎alida a unidade selecionada.                                 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0021C        					    						潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021d    ? Autor ? Gustavo Henrique     ? Data ? 24/09/02  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 砎alida se o aluno esta matriculado nao eh calouro, ou seja,   潮?
北?          砮stah matriculado no segundo periodo letivo em diante.        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0021d        					    						潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/                                                                            
User Function SEC0021d(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

If Val(M->JBH_SCP03) > 1 	// Jah cursou o primeiro periodo letivo do curso
    If !lWeb                                               
		MsgInfo( "Este aluno n鉶 est? matriculado no primeiro semestre." + Chr(13) + Chr(10) +;
				 "Utilize a Transfer阯cia de Curso para Veteranos." )
		lRet := .F.
	Else 
        aadd(aRet,{.F.,"Este aluno n鉶 est? matriculado no primeiro semestre e n鉶 pode ser transferido."})	
        Return aRet
	EndIf	
EndIf

If lSubTurma .and. Type("M->JBH_SCP20") <> "U"
	lRet := ExecBlock( "SEC0021f", .F., .F., { lWeb } )
Endif
 
Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021E    ? Autor ? Marcos Cesar         ? Data ? 28/06/03  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 矲azer a verificacao da Habilitacao informada no Script.       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0021E             					    						       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros矱XPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	 潮?
北?          砪ampo do script.                                            	 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										                潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
User Function SEC0021e(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//砅esquisa o Cadastro de Habilitacao.               ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
JDK->(dbSetOrder(1))
JDK->(dbSeek(xFilial("JDK") + M->JBH_SCP15))

If JDK->(!Found())
	If !lWeb
		MsgInfo("Essa Habilita玢o n鉶 est? cadastrada.")
		lRet := .F.
	Else
		Aadd(aRet, { .F., "Essa Habilita玢o n鉶 est? cadastrada." })

		Return aRet
	EndIf
EndIf

If lRet
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砅esquisa o Arquivo Curso Vigente x Per韔do Letivo.?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	JAR->(dbSetOrder(1))
	JAR->(dbSeek(xFilial("JAR") + M->JBH_SCP12 + M->JBH_SCP14 + M->JBH_SCP15))

	If JAR->(!Found())
		If !lWeb
			MsgInfo("Essa Habilita玢o n鉶 existe no Curso/Per韔do Letivo informado.")
			lRet := .F.
		Else
			Aadd(aRet, { .F., "Essa Habilita玢o n鉶 existe no Curso/Per韔do Letivo informado." })

			Return aRet
		EndIf
	EndIf
EndIf
                                                 
Return( lRet )   


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘?
北矲un噭o	 砈EC0021f    ? Autor ? Fernando Amorim      ? Data ?05/AGO/2007潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢?
北矰escri噭o 砎erifica as subturmas do curso                                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe	 砈EC0020e        					    						潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros矱XPL1 - .T. - Validacao pelo Script da solicitacao.           潮?
北?          ?        .F. - Chamado do filtro da consulta SXB J27.          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so		 矨CAA410	        										    潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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
		/*谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//砎erifica qual o tipo de grade para poder realizar a consulta?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁*/
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
				MsgStop( "A sub-turma informada n鉶 existe" )
			Else
				aadd(aRet,{.F.,"A sub-turma informada n鉶 existe."})
		        Return aRet
			Endif
		Endif
		_QRYSUBTUR->(DbCloseArea())
		DbSelectArea("JA2")
	EndIf
EndIf

Return( lRet )
