#include "rwmake.ch"

Static lSubTurma := JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017A    ³ Autor ³ Gustavo Henrique     ³ Data ³ 02/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra os cursos utilizando o turno escolhido no script do    ³±±
±±³          ³requerimento de Transferencia de Turno - Veteranos            ³±±
±±³          ³1) Traz os cursos da mesma unidade, curso de origem e periodo ³±±
±±³          ³letivo do curso matriculado, e  que estejam com grade de aulas³±±
±±³          ³ativa, e correspondem ao turno selecionado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0017A        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - .T. - Validacao pelo Script da solicitacao.           ³±±
±±³          ³        .F. - Chamado do filtro da consulta SXB J18.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sec0017A( lWeb,cCodCur,cPeriodo,cUnid,cJBKperlet)
         
Local lRet	:= .T.
Local cMsg	:= ""

lWeb     := IIf( lWeb     == Nil , .F., lWeb)
cCodCur  := IIf( cCodCur  == Nil , "", cCodCur)
cPeriodo := IIf( cPeriodo == Nil , "", cPeriodo)

If ! lWeb

	lRet := ( Posicione( "JBK", 1, xFilial( "JBK" ) + M->( JBH_SCP14 + JBH_SCP03 + JBH_SCP04 ), "JBK_ATIVO" ) == "1" )
		                                       
	cMsg := " Este curso não tem grade de aulas ativa no período letivo " + M->JBH_SCP03 + " habilitação " + M->JBH_SCP04 + "."
		
	If lRet
		      
		JAH->( dbSetOrder( 1 ) )
		JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP14 ) )
		         
		// Filtra somente os cursos que tem o mesmo curso, periodo letivo e unidade do curso 
		// vigente de origem escolhido no script. , verifica tambem se o periodo letivo escolhido estah ativo
		lRet := ( JAH->JAH_CURSO == M->JBH_SCP10 .and. JAH->JAH_UNIDAD == M->JBH_SCP11 )
		
		cMsg := " Curso padrão ou unidade diferem do curso padrão ou unidade do curso origem."
						
		If lRet
			
			// O turno escolhido tambem deve ser diferente do turno do curso de origem				
			lRet := ( ! Empty( JAH->JAH_TURNO ) .and. M->JBH_SCP12 == JAH->JAH_TURNO )
			
			cMsg := " Turno difere do turno escolhido."
			
			// O curso de origem nao pode ser o mesmo curso de destino e soh apresenta 
			// os cursos ativos.
			If lRet                                    
				
				lRet := ( M->JBH_SCP01 # M->JBH_SCP14 )
				
				cMsg := " Escolha um curso vigente diferente do curso origem. "
					
			EndIf
				
		EndIf
		
	EndIf
	
	If ! lRet
		
		// Este curso não pode ser selecionado.	
		MsgStop( "Este curso não pode ser selecionado." + cMsg )
		
	Else          
		
		M->JBH_SCP15 := Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP14,"JAH_DESC")		// "Descricao" do curso no script
		M->JBH_SCP16 := JBK->JBK_PERLET		// "Periodo Letivo" do curso no script
		M->JBH_SCP17 := JBK->JBK_HABILI		// "Habilitacao" do curso no script
		M->JBH_SCP18 := Posicione("JDK",1,xFilial("JDK")+JBK->JBK_HABILI,"JDK_DESC")
		M->JBH_SCP19 := JBK->JBK_TURMA		// "Turma" do curso no script
	 
	EndIf
		
Else

	// Busca o curso e unidade do curso vigente de origem
	JAH->( dbSetOrder( 1 ) )
	If JAH->( dbSeek( xFilial( "JAH" ) + cCodCur ) )	// Campo "Curso Origem" do script
		// Filtra somente os cursos que tem o mesmo curso, periodo letivo e unidade do curso 
		// vigente de origem escolhido no script. , verifica tambem se o periodo letivo escolhido estah ativo
		lRet := (	cCodCur == JAH->JAH_CURSO .and. cUnid == JAH->JAH_UNIDAD .and. cPeriodo == cJBKperlet )
	Else
	    lRet := .F.
	EndIf   	
			
EndIf

Return( lRet )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017B    ³ Autor ³ Gustavo Henrique     ³ Data ³ 04/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Validacao do turno digitado no script do requerimento de      ³±±
±±³          ³Transferencia de Turno - Veteranos.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0017B        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Sec0017B(lWeb)
   
Local lRet := .T.         
Local aRet := {}

lWeb := IIf( lWeb == Nil , .F., lWeb)

M->JBH_SCP13 := Tabela( "F5", M->JBH_SCP12, .T. )
lRet := ! Empty( M->JBH_SCP13 )

If lRet 
    
    If !lWeb
		M->JBH_SCP14 := Space( TamSX3("JAH_CODIGO")[1] )
		M->JBH_SCP15 := Space( TamSX3("JAH_DESC")[1] )
		M->JBH_SCP16 := Space( TamSX3("JBK_PERLET")[1] )    
		M->JBH_SCP17 := Space( TamSX3("JBK_HABILI")[1] )
		M->JBH_SCP18 := Space( TamSX3("JDK_DESC")[1] )
		M->JBH_SCP19 := Space( TamSX3("JBK_TURMA")[1] )
	Else
        aadd(aRet,{.F.,"Turno Inválido."})	
        Return aRet		
	EndIf
EndIf

Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017C    ³ Autor ³ Gustavo Henrique     ³ Data ³ 10/10/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Transfere o aluno de permuta para o turno do aluno solicitante³±±
±±³          ³caso o tipo seja 2=Permuta.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0017C        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0017C()

Local aRet  := ACScriptRet( M->JBH_NUM )
Local lRet	:= .T.

If aRet[ 20 ] == "2"		//	Permuta
	lRet := ACTransfere( 1, 3, 4, 6, 14, 16, 17, 19, .F., , 20 )
EndIf   

Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017D    ³ Autor ³ Gustavo Henrique     ³ Data ³ 10/10/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se o aluno informado no script pode fazer permuta com³±±
±±³          ³o aluno que solicitou o requerimento.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0017D        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0017d( lScript )
                         
Local lRet
Local cTurno
          
lScript := Iif( lScript == NIL, .F., lScript )
           
If lScript

	lRet := .F.

	If JA2->( ExistCpo( "JA2", M->JBH_SCP21 ) )
	
		JBE->( dbSetOrder( 3 ) )
		JBE->( dbSeek( xFilial( "JBE" ) + "1" + M->JBH_SCP21 + M->JBH_SCP14 ) )

		cTurno := Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_TURNO" )
		
		If JBE->( ! Found() )
			MsgStop( "O aluno informado não está matriculado no curso informado como destino." )
		ElseIf JBE->JBE_PERLET # M->JBH_SCP16
			MsgStop( "O aluno informado deve estar matriculado no mesmo periodo letivo do aluno solicitante." )
		ElseIf cTurno # M->JBH_SCP12
			MsgStop( "O aluno deve estar matriculado no turno de destino selecionado." )
		Else
			lRet := .T.	
		EndIf
		
	EndIf

Else
                        
	cTurno := Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_TURNO" )

	lRet := JBE->(	JBE_NUMRA # Left(M->JBH_CODIDE,TamSX3("JBE_NUMRA")[1]) .and.;	// Alunos diferentes do solicitante
					JBE_ATIVO == "1" .and.;											// Que estejam ativos 
					JBE_CODCUR == M->JBH_SCP14 .and.;								// Matriculados no curso de destino
					JBE_PERLET == M->JBH_SCP16 .and.;								// Periodo letivo do destino
					JBE_HABILI == M->JBH_SCP17 .and.;								// Habilitacao do destino
					JBE_TURMA == M->JBH_SCP19 .and.;								// Turma do destino
					cTurno == M->JBH_SCP12 )										// e no Turno de destino selecionados

EndIf
	
Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0017e º Autor ³ Gustavo Henrique   º Data ³  01/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Expressao de filtro tipo 07 para a consulta J2C.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de transferencia de turno.                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0017e()

Return( xFilial("JBO")+M->(JBH_SCP14+JBH_SCP16+JBH_SCP17) )      


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017f    ³ Autor ³ Fernando Amorim      ³ Data ³04/AGO/2007³±±
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
User Function SEC0017f( lWeb )

Local lRet 	  := .T.
Local aRet 	  := {}
Local cQuery  := ""
Local cTipGrd := ""

lWeb := IIf( lWeb == Nil , .F., lWeb)
If lSubTurma
	If lRet
	   	lRet := (JBK->JBK_CODCUR == M->JBH_SCP14 .and. JBK->JBK_PERLET == M->JBH_SCP16 .and. JBK->JBK_HABILI == M->JBH_SCP17 .and.;
	   			 JBK->JBK_ATIVO == "1" )
				
	   	If lRet		
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica qual o tipo de grade para poder realizar a consulta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			DbSelectArea("JAF")
			JAH->(DbSetOrder(1))
			JAH->(DbSeek(xFilial("JAH") + M->JBH_SCP14))
			cTipGrd := Iif(JAF->( FieldPos( "JAF_TIPGRD" ) ) > 0, Posicione("JAF",1,xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO), "JAF_TIPGRD"), "1")
			
			If cTipGrd == "1" //Grade Semanal
				cQuery := "SELECT DISTINCT JBL_SUBTUR FROM " + RetSQLName("JBL")
				cQuery += " WHERE JBL_FILIAL = '" + xFilial("JBL") + "' "
				cQuery += "   AND JBL_CODCUR = '" + M->JBH_SCP14 + "' "
				cQuery += "   AND JBL_PERLET = '" + M->JBH_SCP16 + "' "
				cQuery += "   AND JBL_HABILI = '" + M->JBH_SCP17 + "' "
				cQuery += "   AND JBL_TURMA  = '" + M->JBH_SCP19 + "' "
				cQuery += "   AND JBL_SUBTUR = '" + M->JBH_SCP22 + "' "
				cQuery += "   AND D_E_L_E_T_ = ' '"	
			Else //Diaria
				cQuery := "SELECT DISTINCT JD2_SUBTUR FROM " + RetSQLName("JD2")
				cQuery += " WHERE JD2_FILIAL = '" + xFilial("JD2") + "' "
				cQuery += "   AND JD2_CODCUR = '" + M->JBH_SCP14 + "' "
				cQuery += "   AND JD2_PERLET = '" + M->JBH_SCP16 + "' "
				cQuery += "   AND JD2_HABILI = '" + M->JBH_SCP17 + "' "
				cQuery += "   AND JD2_TURMA  = '" + M->JBH_SCP19 + "' "
				cQuery += "   AND JD2_SUBTUR = '" + M->JBH_SCP22 + "' "
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

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0017G	³ Autor ³   Tatiane Maestrello	³  Data ³ 10/01/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bloqueia a transferência de turno, quando o status do     	³±±
±±³			 ³ aluno estiver como Pré-Matriculado em outro período que não  ³±±
±±³ 		 ³	aquele da transferência.				            		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0017G        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0017G( lWeb )

Local lRet 		:= .T.
Local aRet 		:= {}
Local cAluno	:= Left(M->JBH_CODIDE, TamSX3("JBE_NUMRA")[1])

lWeb := Iif( lWeb == NIL, .F., lWeb )                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o aluno está pré-matriculado.					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
JBE->(dbSetOrder(3))
If JBE->(dbSeek(xFilial("JBE") + "2" + cAluno + M->JBH_SCP01 +;
	ACPerAtual(cAluno, M->JBH_SCP01))) .And. JBE->JBE_SITUAC == "1"
	If !lWeb                                               
		MsgAlert("Este aluno se encontra pré-matriculado em outro período." + Chr(13) + Chr(10) +;
				 "Para fazer a transferência, será necessário efetuar a baixa"  + Chr(13) + Chr(10) +;
				 "do título de matrÍcula deste aluno.", "Aviso")
		lRet := .F.
	Else 
        aadd(aRet,{.F.,"Este aluno se encontra pré-matriculado em outro período."})	
        Return aRet
	EndIf		
EndIf
		
Return lRet

