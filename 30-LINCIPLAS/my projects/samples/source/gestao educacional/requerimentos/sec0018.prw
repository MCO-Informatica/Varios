#include "rwmake.ch"   

Static lSubTurma := JBE->( FieldPos( "JBE_SUBTUR")) > 0   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0018A    ³ Autor ³ Gustavo Henrique     ³ Data ³ 03/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra as unidades disponiveis para o requerimento de         ³±±
±±³          ³Transferencia de Unidade - Veteranos.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0018A        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - .T. - Validacao pelo Script da solicitacao.           ³±±
±±³          ³        .F. - Chamado do filtro da consulta SXB J25.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sec0018A( lScript , lWeb)
         
Local lRet := .T.
Local aRet := {}

lScript := If( lScript == NIL, .F., lScript )
lWeb    := IIf( lWEb == Nil , .F., lWEb )

If lScript

	lRet := ExistCpo( "JA3", M->JBH_SCP11 )    

	If lRet
		
		lRet := ( M->JBH_SCP11 # Posicione( "JAH", 1, xFilial("JAH") + M->JBH_SCP01, "JAH_UNIDAD" ) )
		
		If ! lRet
			If !lWEb
				MsgStop( "A unidade selecionada deve ser diferente da unidade do curso de origem." )
			Else
		        aadd(aRet,{.F.,"A unidade selecionada deve ser diferente da unidade do curso de origem."})			        
		        Return aRet		
		    EndIf    
		Else 
		    M->JBH_SCP10 := Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP01,"JAH_CURSO")                        
			M->JBH_SCP12 := Posicione( "JA3", 1, xFilial( "JA3" ) + M->JBH_SCP11, "JA3_DESLOC" )
			M->JBH_SCP13 := Space(TamSX3( "JAH_CODIGO" )[1])
			M->JBH_SCP14 := Space(TamSX3( "JAH_DESC" )[1])
			M->JBH_SCP15 := Space(TamSX3( "JBK_PERLET" )[1])
			M->JBH_SCP16 := Space(TamSX3( "JBK_HABILI" )[1])
			M->JBH_SCP17 := Space(TamSX3( "JDK_DESC" )[1])
		EndIf
		
	EndIf

Else
                                                        
	lRet := ( JA3->JA3_CODLOC # Posicione( "JAH", 1, xFilial("JAH") + JBE->JBE_CODCUR, "JAH_UNIDAD" ) )

EndIf
	
Return( lRet )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0018B    ³ Autor ³ Gustavo Henrique     ³ Data ³ 03/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Utilizado no requerimento de Transferencia de Unidade - Vet.  ³±±
±±³          ³Filtra os cursos de destino de acordo com a unidade escolhida ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0018B        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - .T. - Validacao pelo Script da solicitacao.           ³±±
±±³          ³        .F. - Chamado do filtro da consulta SXB J26.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sec0018B( lWeb, cWCurOri, cWPeriOri, cWUnidOri, cWCurDest )
         
Local lRet		:= .T.
Local cCursoOri	:= ""	// Curso principal do curso origem selecionado no script.
Local cCurso	:= ""	// Curso principal do curso de origem
Local cUnidade	:= ""	// Unidade do curso de origem
                             
lWeb := iif( lWeb == Nil, .F., lWeb)

if ! lWeb

	lRet := ExistCpo( "JBK", M->JBH_SCP13 + M->JBH_SCP03 + M->JBH_SCP04 )
		
	if lRet
		
		lRet := ( Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP13, "JAH_UNIDAD" ) == M->JBH_SCP11 )
			
		if lRet
			           
	        // Somente os cursos com o curso padrao do curso de origem
			lRet := ( Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP01, "JAH_CURSO" ) == Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP13, "JAH_CURSO" ) )
				
			if ! lRet          
				if Empty( M->JBH_SCP11 )       
				  	if !lWeb
						MsgStop( "Unidade não pode ser deixada em branco." )
			 		endif    
				else		
					if !lWEb
						MsgStop( "Este curso não pode ser selecionado." )
			 		endif    
				endif	
			else 
				M->JBH_SCP14 := Posicione("JAF",1,xFilial("JAF")+Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP11, "JAH_CURSO" )+JAH->JAH_VERSAO,"JAF_DESMEC")
				M->JBH_SCP15 := JBK->JBK_PERLET
				M->JBH_SCP16 := JBK->JBK_HABILI
				M->JBH_SCP17 := Posicione("JDK",1,xFilial("JDK") + JBK->JBK_HABILI,"JDK_DESC")
			endif		
			
		endif
	
	else     
	
        if ! lWeb
			MsgStop( "Curso de destino invalido." )
		endif

	endif
		
else

	// Seleciona apenas cursos ativos
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + cWCurOri ) )
	                                
	cCursoOri := JAH->JAH_CURSO
	
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + cWCurDest ) )
		
	cUnidade := JAH->JAH_UNIDAD
	cCurso	 := JAH->JAH_CURSO
	                                                                                                              
 	// Traz apenas os cursos da unidade selecionada, que tenham o mesmo curso pricipal 
 	// do curso origem selecionado.
	lRet := ( cUnidade <> cWUnidOri .and. cCursoOri == cCurso )
	
endIf

Return( lRet )   


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0018c    ³ Autor ³ Fernando Amorim      ³ Data ³05/AGO/2007³±±
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
User Function SEC0018c( lWeb )

Local lRet 	  := .T.
Local aRet 	  := {}
Local cQuery  := ""
Local cTipGrd := ""

lWeb := IIf( lWeb == Nil , .F., lWeb)
If lSubTurma
	If lRet
	   	lRet := (JBK->JBK_CODCUR == M->JBH_SCP13 .and. JBK->JBK_PERLET == M->JBH_SCP15 .and. JBK->JBK_HABILI == M->JBH_SCP16 .and.;
	   			 JBK->JBK_ATIVO == "1" )
				
	   	If lRet		
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica qual o tipo de grade para poder realizar a consulta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			DbSelectArea("JAF")
			JAH->(DbSetOrder(1))
			JAH->(DbSeek(xFilial("JAH") + M->JBH_SCP13))
			cTipGrd := Iif(JAF->( FieldPos( "JAF_TIPGRD" ) ) > 0, Posicione("JAF",1,xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO), "JAF_TIPGRD"), "1")
			
			If cTipGrd == "1" //Grade Semanal
				cQuery := "SELECT DISTINCT JBL_SUBTUR FROM " + RetSQLName("JBL")
				cQuery += " WHERE JBL_FILIAL = '" + xFilial("JBL") + "' "
				cQuery += "   AND JBL_CODCUR = '" + M->JBH_SCP13 + "' "
				cQuery += "   AND JBL_PERLET = '" + M->JBH_SCP15 + "' "
				cQuery += "   AND JBL_HABILI = '" + M->JBH_SCP16 + "' "
				cQuery += "   AND JBL_TURMA  = '" + M->JBH_SCP18 + "' "
				cQuery += "   AND JBL_SUBTUR = '" + M->JBH_SCP19 + "' "
				cQuery += "   AND D_E_L_E_T_ = ' '"	
			Else //Diaria
				cQuery := "SELECT DISTINCT JD2_SUBTUR FROM " + RetSQLName("JD2")
				cQuery += " WHERE JD2_FILIAL = '" + xFilial("JD2") + "' "
				cQuery += "   AND JD2_CODCUR = '" + M->JBH_SCP13 + "' "
				cQuery += "   AND JD2_PERLET = '" + M->JBH_SCP15 + "' "
				cQuery += "   AND JD2_HABILI = '" + M->JBH_SCP16 + "' "
				cQuery += "   AND JD2_TURMA  = '" + M->JBH_SCP18 + "' "
				cQuery += "   AND JD2_SUBTUR = '" + M->JBH_SCP19 + "' "
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
Endif	
Return( lRet )

 
