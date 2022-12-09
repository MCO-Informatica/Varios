#include "RWMAKE.CH" 
#Include "MSOLE.CH"
#Include "Protheus.CH"

#define CRLF	Chr(13)+Chr(10)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022A    ³ Autor ³ Gustavo Henrique     ³ Data ³ 03/04/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida os cursos de destino.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022A        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410 - Requerimento de Transferencia de Curso - Veteranos  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0022A(lWeb)

Local lRet		:= .F.
Local lUnid		:= iif(lWeb == nil,!Empty( M->JBH_SCP10 ),!Empty(httppost->PERG08))
Local cVersao	:= ""
Local aRet		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)

If !lWeb
	If NaoVazio()
	
		JAF->( dbSetOrder( 1 ) ) //JAF_FILIAL, JAF_COD, JAF_VERSAO, R_E_C_N_O_, D_E_L_E_T_

		If JAF->( dbSeek( xFilial( "JAF" ) + M->JBH_SCP12 + M->JBH_SCP14 ) )
		                                                              
			If Empty( M->JBH_SCP14 )
				M->JBH_SCP14 := ""
			EndIf	
	
			cVersao := Iif( Empty(M->JBH_SCP14), JAF->JAF_VERSAO, M->JBH_SCP14)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP12 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP12 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # M->JBH_SCP01 .and.;
					If( lUnid, JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If lRet
					M->JBH_SCP13 := JAF->JAF_DESC
					M->JBH_SCP14 := JAF->JAF_VERSAO
				Else
					MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )
				EndIf	
				                                                                                                
			Else
				MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )			
			EndIf	
		Else
			MsgInfo( "Curso padrão não cadastrado." )
		EndIf	
	    
	EndIf

else //lWeb             

    
       if httppost->PERG08 <> Httpsession->unidade
 		  aadd(aRet,{.F.,"Não é permitido transferências entre unidades."})
 		endif  

		JAF->( dbSetOrder( 1 ) )
		If JAF->( dbSeek( xFilial( "JAF" ) + httppost->PERG10 + httppost->PERG12 ) )
		
		                                                              
			If Empty( httppost->PERG12 )
				httppost->PERG12 := ""
			EndIf	
	
			cVersao := Iif( Empty(httppost->PERG12), JAF->JAF_VERSAO, httppost->PERG12)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + httppost->PERG10 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == httppost->PERG10 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # httppost->PERG01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == httppost->PERG08, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If !lRet
					aadd(aRet,{.F.,"O curso selecionado não esta disponível para Transferência."})
				EndIf	
				                                                                                                
			Else
				aadd(aRet,{.F.,"O curso selecionado não esta disponível para Transferência."})
			EndIf	
		Else
			aadd(aRet,{.F.,"Curso padrão não cadastrado."})
		EndIf	
EndIf		

Return( iif(!lWeb,lRet,aRet) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0022b  ºAutor  ³Gustavo Henrique    º Data ³  11/jul/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Regra para gravacao da Grade Curricular do Externo para     º±±
±±º          ³analise.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0022B()

Local aScript := ACScriptReq( JBH->JBH_NUM )

RecLock("JCS", .T.)
JCS->JCS_FILIAL	:= xFilial("JCS")
JCS->JCS_NUMREQ	:= JBH->JBH_NUM
JCS->JCS_CURPAD	:= aScript[12]
JCS->JCS_VERSAO	:= aScript[14]
msUnlock("JCS")

Return( .T. )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022d    ³ Autor ³ Gustavo Henrique     ³ Data ³ 25/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a unidade selecionada.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022d        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0022d(lWeb)

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
			httppost->PERG09 := Posicione( "JA3", 1, xFilial("JA3") + httppost->PERG08, "JA3_DESLOC" )
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
±±³Fun‡„o	 ³SEC0022e    ³ Autor ³ Gustavo Henrique     ³ Data ³ 25/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime o documento referente ao Conteudo Programatico e      ³±±
±±³          ³Historico Escolar.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022e        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - Se estah sendo chamada do requerimento de             ³±±
±±³          ³aproveitamento de estudos.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0022e( lAprov )
                        
Local lRet 		:= .T.
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local lImprime	:= .T.

lAprov := iif( lAprov == NIL, .F., lAprov )
            
if lAprov
	lImprime := (aRet[3] # "01")
endif

if lImprime
	U_SEC0002()		// Imprime Historico Escolar
endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0022f  ºAutor  ³Gustavo Henrique    º Data ³  18/out/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Filtro para consulta J13 do curso refeente ao campo curso doº±±
±±º          ³script do requerimento de de Transferencia Externos         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0022f()

Local lRet := .F.
              
If JAF->JAF_ATIVO == "1"
     
	JAH->( dbSetOrder( 4 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JAF->( JAF_COD + JAF_VERSAO ) ) )
	
	If JAH->JAH_STATUS == "1" .and. Iif( ! Empty( M->JBH_SCP10 ), JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
		lRet := (Posicione( "JBK", 3, xFilial( "JBK" ) + "1" + JAH->JAH_CODIGO, "JBK_ATIVO" ) == "1")
	EndIf
	                        
EndIf

Return( lRet )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022h    ³ Autor ³ Gustavo Henrique     ³ Data ³ 15/04/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se mudou de curso vigente, caso nao mudou apenas     ³±±
±±³          ³atualiza a situacao das disciplinas da grade do aluno.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022h        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Requerimento de Aproveitamento de Estudos	(000032)   			³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0022h()

Local lRet			:= .T.
Local aRet			:= ACScriptReq( JBH->JBH_NUM )
Local cRA			:= PadR( JBH->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
Local cCurso		:= aRet[ 01 ]
Local cTurma    	:= aRet[ 06 ]
Local lExisteJBE	:= .F.
Local cPerlet		:= ""
Local cHabili		:= ""
Local cPerAnt		:= ""
Local cHabAnt		:= ""
Local nA			:= 0
Local cTipo			:= ""
Local cKitMat		:= ""
Local lExistJI6 := TCCanOpen(RetSQLName("JI6")) // existe tabela de componentes

JA2->( dbSetOrder(1) )
JA2->( dbSeek(xFilial("JA2")+cRa) )

               
JCS->( dbSetOrder( 1 ) )
JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )

JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) + cRA + aRet[1] ) )

while JBE->( ! EoF() .and. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial("JBE") + cRA + aRet[1] )
	if JBE->JBE_ATIVO $ "125"	// 1=Sim;2=Nao;5=Formado
		cTipo   := JBE->JBE_TIPO
		cKitMat := JBE->JBE_KITMAT
		Exit
	endif
	JBE->( dbSkip() )
end

if Empty( cTipo ) .or. cTipo $ "25"
	cTipo := "1"
endif

if Empty( cKitMat )
	cKitMat := "2"
endif


lRet := ( cCurso == JCS->JCS_CURSO )
                 
if lRet

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o aluno no JBE para os periodos anteriores³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	JBE->( dbSetOrder(1) )

	For nA := 1 To Val(JCS->JCS_SERIE)
	
		cSerie := StrZero(nA,TamSX3("JBE_PERLET")[1])
	
		if JBE->( dbSeek( xFilial("JBE")+cRa+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) ) .and.	Val(JCS->JCS_SERIE) > nA
			GravaJC7(cRa,JCS->JCS_CURSO,cSerie,JCS->JCS_HABILI)
			If lExistJI6
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Altera situação no componente curricular do curso origem 
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ACA060AtJI6(JCS->JCS_CURSO , cSerie , JCS->JCS_HABILI,cRa )				
			EndIf
			loop
		elseif !JBE->( dbSeek( xFilial("JBE")+cRa+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) )
		          
		    // pegar turma anterior
			cTurma	:= if( nA == Val(JCS->JCS_SERIE), JCS->JCS_TURMA, GetTurma(JCS->JCS_CURSO,cSerie,JCS->JCS_HABILI,JCS->JCS_TURMA) )
			
		
			JAR->( dbSetOrder(1) )
			JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) )
		
			RecLock("JBE", .T.)
			JBE->JBE_FILIAL := xFilial("JBE")
			JBE->JBE_NUMRA  := cRA
			JBE->JBE_CODCUR := JCS->JCS_CURSO
			JBE->JBE_PERLET := cSerie
			JBE->JBE_HABILI := JCS->JCS_HABILI
			JBE->JBE_TURMA  := cTurma
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento para SubTurmas													       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0 .and. JCS->( FieldPos( "JCS_SUBTUR" ) ) > 0
				JBE->JBE_SUBTUR := JCS->JCS_SUBTUR
			Endif
			JBE->JBE_TIPO   := iif( cTipo # "1", cTipo, "1" )  // Periodo Letivo Normal
			If cSerie == JCS->JCS_SERIE
				JBE->JBE_SITUAC := if( Posicione("JB5",1,xFilial("JB5")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+"01", "JB5_MATPAG") == "1" .and. Posicione("JAH",1,xFilial("JAH")+JCS->JCS_CURSO,"JAH_VALOR") == "1", "1", "2" )	// 1=PreMatricula; 2=Matricula
				JBE->JBE_ATIVO  := if( JBE->JBE_SITUAC == "1", "2", "1" )   // 1=Sim; 2=Nao
				nRecJBE := JBE->( Recno() )
			Else
				JBE->JBE_SITUAC := "2"  // 1=Pre-Matricula; 2=Matricula
				JBE->JBE_ATIVO  := "2"  // 1=Sim; 2=Nao
			EndIf
			JBE->JBE_DTMATR := dDataBase
			JBE->JBE_ANOLET := JAR->JAR_ANOLET
			JBE->JBE_PERIOD := JAR->JAR_PERIOD
			JBE->JBE_TPTRAN := "006"        //??
			JBE->JBE_KITMAT := cKitMat      
			JBE->JBE_NUMREQ := if( nA == Val(JCS->JCS_SERIE), TamSX3("JCS_NUMREQ")[1],JCS->JCS_NUMREQ)
			if JBE->( FieldPos("JBE_SEQ") ) > 0
				JBE->JBE_SEQ	:= ACSequence( JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI )
			endif
			JBE->(MsUnLock())
		endif
		
		GravaJC7(cRa,JCS->JCS_CURSO,cSerie,JCS->JCS_HABILI)
		If lExistJI6
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera situação no componente curricular do curso origem 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ACA060AtJI6(JCS->JCS_CURSO , cSerie , JCS->JCS_HABILI,cRa )				
		EndIf
				
	Next nA
		
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua o Bloqueio ou Desbloqueio do Aluno³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cRA) .And. !Empty(cCurso) .And. !Empty(cTurma) .And. !Empty(cPerLet)
			
	lExisteJBE := .F.

	cPerAnt := StrZero(Val(cPerLet)-1,2)
	cHabAnt := AcTrazHab(cCurso, cPerAnt, cHabili)
	
	JBE->( dbSetOrder(1) )
	If JBE->( dbSeek( xFilial("JBE") + cRA + cCurso + cPerLet + cHabili + cTurma) )
		While JBE->( !eof() .and. JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA == xFilial("JBE")+cRA+cCurso+cPerLet+cHabili+cTurma )
			IF JBE->JBE_ATIVO $ "125" // 1=Ativo;2=Inativo;5=Formado
				lExisteJBE := .T.
				Exit
			EndIf
			JBE->(dbSkip())
		End
	EndIF
				
	If lExisteJBE
		JAR->(dbSetOrder(1))		// Ordem: Codigo do Curso Vigente + Periodo Letivo
		If JAR->( dbSeek(xFilial("JAR") + cCurso + cPerLet + cHabili ))
			AcBloqAlu(cRA,cCurso,cPerlet,cHabili,cTurma,JAR->JAR_DPMAX,cPerAnt,cHabAnt)
		EndIf
	Endif
	
EndIf



Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022I    ³ Autor ³ Luis Ricardo Cinalli ³ Data ³ 06/02/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida os cursos de destino para transferencia entre filiais. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022I        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410 - Requerimento de Transferencia de Filial             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0022I(lWeb)
Local lRet		:= .F.
Local lUnid		:= iif(lWeb == nil,!Empty( M->JBH_SCP13 ),!Empty(httppost->PERG08))
Local cVersao	:= JAF->JAF_VERSAO
Local aRet		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)

If !lWeb
	If NaoVazio()
	
		JAF->( dbSetOrder( 1 ) )   //-- JAF_FILIAL, JAF_COD, JAF_VERSAO, R_E_C_N_O_, D_E_L_E_T_
		If JAF->( dbSeek( M->JBH_SCP11 + M->JBH_SCP15 + cVersao ) )
		                                                              
			If Empty( M->JBH_SCP17 )  //-- Versão do Curso Padrao
				M->JBH_SCP17 := ""
			EndIf	
	
			cVersao := Iif( Empty( M->JBH_SCP17 ), JAF->JAF_VERSAO, M->JBH_SCP17 )
		          
			JAH->( dbSetOrder( 4 ) ) //-- JAH_FILIAL+JAH_CURSO+JAH_VERSAO
	
			If JAH->( dbSeek( M->JBH_SCP11 + M->JBH_SCP15 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP15 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and.	If( lUnid, JAH->JAH_UNIDAD == M->JBH_SCP13, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If lRet
					M->JBH_SCP16 := JAF->JAF_DESC
					M->JBH_SCP17 := JAF->JAF_VERSAO
				Else
					MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )
				EndIf	
				                                                                                                
			Else
				MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )			
			EndIf	
		Else
			MsgInfo( "Curso padrão não cadastrado." )
		EndIf	
	    
	EndIf

else //lWeb             
    
        //if httppost->PERG10 <> Httpsession->unidade
 		//  aadd(aRet,{.F.,"Não é permitido transferências entre unidades."})
 		//endif  

		JAF->( dbSetOrder( 1 ) )
		If JAF->( dbSeek( M->JBH_SCP11 + httppost->PERG15 + cVersao) )
		                                                              
			If Empty( httppost->PERG15 )
				httppost->PERG15 := ""
			EndIf	
	
			cVersao := Iif( Empty(httppost->PERG17), JAF->JAF_VERSAO, httppost->PERG17)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( M->JBH_SCP11 + httppost->PERG15 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == httppost->PERG15 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # httppost->PERG01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == httppost->PERG13, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If !lRet
					aadd(aRet,{.F.,"O curso selecionado não esta disponível para Transferência."})
				EndIf	
				                                                                                                
			Else
				aadd(aRet,{.F.,"O curso selecionado não esta disponível para Transferência."})
			EndIf	
		Else
			aadd(aRet,{.F.,"Curso padrão não cadastrado."})
		EndIf	
EndIf		

Return( iif(!lWeb,lRet,aRet) )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022j    ³ Autor ³ Luis Ricardo Cinalli ³ Data ³ 06/02/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a unidade da filial destino selecionada.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022j        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0022j( lWeb )
Local lRet		:= .T.
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cProcFil  := ""
Local cProcLoc  := ""

// Se a tabela de Unidades for compartilhada, nao sera realizado o filtro na Query
Local cFilJA3    := xFilial( 'JA3' )

lWeb		:= iif( lWeb == nil, .F., lWeb )
cProcFil	:= iif( lWeb, httppost->PERG11, M->JBH_SCP11 )
cProcLoc	:= iif( lWeb, httppost->PERG13, M->JBH_SCP13 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra somente as unidades da filial de destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DISTINCT "
cQuery += "JA3.JA3_CODLOC , JA3.JA3_DESLOC ,  "
cQuery += " ( SELECT DISTINCT COUNT( * ) "
cQuery += "   FROM " + RetSQLName("JA3") + " JA3 "
cQuery += "   WHERE "

If ! Empty( cFilJA3 )
	cQuery += "   JA3.JA3_FILIAL = '" + cProcFil + "' and "
EndIf

cQuery += "   JA3.JA3_CODLOC = '" + cProcLoc + "' and "
cQuery += "   JA3.JA3_TIPO = '1' and "
cQuery += "   JA3.D_E_L_E_T_ <> '*' ) AS QTDREG "
cQuery += "FROM "
cQuery += RetSQLName("JA3") + " JA3 "
cQuery += "WHERE "

If ! Empty( cFilJA3 )
	cQuery += "JA3.JA3_FILIAL = '" + cProcFil + "' and "
EndIf

cQuery += "JA3.JA3_CODLOC = '" + cProcLoc + "' and "
cQuery += "JA3.JA3_TIPO = '1' and "
cQuery += "JA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JA3_CODLOC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

lRet := ( TRB->QTDREG == 1 )

If !lWeb
	M->JBH_SCP14 := iif( lRet, TRB->JA3_DESLOC, "" )
else //lWeb
	httppost->PERG14 := iif( lRet, TRB->JA3_DESLOC, "" )
EndIf

TRB->( DbCloseArea() )
RestArea( aArea )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC22XB1   ºAutor  ³Luis Ricardo Cinalli º Data ³  07/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa SXB customizada para exibir o cadastro de Unidades   º±±
±±º          ³ da Filial de Destino                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC22XB1()
Local oDlg, oBtOk, oBtCancel, oOrder, oChave, oSelect
Local nOpc		 := 0
Local cOrder	 := "Codigo"
Local cChave	 := PadR( &( ReadVar() ), TamSX3( "JA3_CODLOC" )[1] )
Local aOrders	 := { "Codigo", "Descricao" }	
Local aCpoBrw	 := {}
Local cFilter	 := ""
Local cTitle	 := " Seleção de Unidade "
Local cCampo     := ""
Local cChavePesq := ""                      	
Local aCodLoc    := {}
Local nInd       := 0
Local cQuery     := ""  

// Se a tabela de Unidades for compartilhada, nao sera realizado o filtro na Query
Local cFilJA3    := xFilial( 'JA3' )

Public _RetCodLoc := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra somente as unidades da filial de destino ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DISTINCT "
cQuery += "JA3.JA3_CODLOC , JA3.JA3_DESLOC "
cQuery += "FROM "
cQuery += RetSQLName("JA3") + " JA3 "
cQuery += "WHERE "                                                               

If ! Empty( cFilJA3 )
	cQuery += "JA3.JA3_FILIAL = '"+ M->JBH_SCP11 +"' and "
EndIf

cQuery += "JA3.JA3_TIPO = '1' and "
cQuery += "JA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JA3_CODLOC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

SX3->( dbSetOrder(2) )

SX3->( dbSeek( "JA3_CODLOC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )

SX3->( dbSeek( "JA3_DESLOC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
                         
aStru     := TRB->( dbStruct() )
cFileWork := CriaTrab( aStru, .T. )
cIndWork  := Left( cFileWork, 7 ) + "A"

dbUseArea(.T.,,cFileWork,"TRB2",.F.)

IndRegua( "TRB2", cFileWork, "JA3_CODLOC",,, "Selecionando Registros..." )
IndRegua( "TRB2", cIndWork , "JA3_DESLOC",,, "Selecionando Registros..." )

dbClearIndex()
dbSetIndex(cFileWork + OrdBagExt() )
dbSetIndex(cIndWork  + OrdBagExt() )

While TRB->( !Eof() )
	RecLock("TRB2", .T.)
	TRB2->JA3_CODLOC := TRB->JA3_CODLOC
	TRB2->JA3_DESLOC := TRB->JA3_DESLOC
	MsUnLock()

	TRB->( dbSkip() )
EndDo

TRB2->(DbGoTop())

define msDialog oDlg title cTitle from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB2",,,aCpoBrw,,,{ 003, 003, 117, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

@ 125,004 say "Ordenar por:" size 40,08 of oDlg pixel	//"Ordenar por:"
@ 125,042 combobox oOrder var cOrder items aOrders size 125,08 of oDlg pixel valid ( TRB2->( dbSetOrder( oOrder:nAt ) ), oSelect:oBrowse:Refresh(), .T. )
@ 137,004 say "Localizar:" size 40,08 of oDlg pixel	//"Localizar:"
@ 137,042 get oChave var cChave size 125,08 of oDlg pixel valid ( TRB2->( dbSeek( RTrim( cChave ), .T. ) ), oSelect:oBrowse:Refresh(), .T. )
define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

if nOpc == 1
	_RetCodLoc := TRB2->JA3_CODLOC
endif
             
TRB->( DbCloseArea() )
TRB2->( DbCloseArea() )

fErase( cFileWork + GetDbExtension() )
fErase( cFileWork + OrdBagExt() )
fErase( cIndWork + OrdBagExt() )

Return nOpc == 1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC22XB2   ºAutor  ³Luis Ricardo Cinalli º Data ³  07/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa SXB customizada para exibir o cadastro de Cursos     º±±
±±º          ³ da Filial de Destino                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC22XB2()
Local oDlg, oBtOk, oBtCancel, oOrder, oChave, oSelect
Local nOpc		 := 0
Local cOrder	 := "Codigo"
Local cChave	 := PadR( &( ReadVar() ), TamSX3( "JAF_COD" )[1] )
Local aOrders	 := { "Codigo", "Descricao" }	
Local aCpoBrw	 := {}
Local cFilter	 := ""
Local cTitle	 := " Seleção de Unidade "
Local cCampo     := ""
Local cChavePesq := ""                      	
Local aCodLoc    := {}
Local nInd       := 0
Local cQuery     := ""

Public _RetCodCur := ""
Public _RetCodVer := ""             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra somente os cursos da filial de destino   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DISTINCT "
cQuery += "JAF.JAF_COD , JAF.JAF_DESC, JAF.JAF_VERSAO "
cQuery += "FROM "
cQuery += RetSQLName("JAF") + " JAF "
cQuery += "WHERE "
cQuery += "JAF.JAF_FILIAL = '"+ M->JBH_SCP11 +"' and "
cQuery += "JAF.JAF_ATIVO = '1' and "
cQuery += "JAF.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JAF_COD,JAF_VERSAO "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

SX3->( dbSetOrder(2) )
SX3->( dbSeek( "JAF_COD" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
SX3->( dbSeek( "JAF_DESC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
SX3->( dbSeek( "JAF_VERSAO" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
                         
aStru     := TRB->( dbStruct() )
cFileWork := CriaTrab( aStru, .T. )
cIndWork  := Left( cFileWork, 7 ) + "A"

dbUseArea(.T.,,cFileWork,"TRB2",.F.)

IndRegua( "TRB2", cFileWork, "JAF_COD",,, "Selecionando Registros..." )
IndRegua( "TRB2", cIndWork , "JAF_DESC",,, "Selecionando Registros..." )

dbClearIndex()
dbSetIndex(cFileWork + OrdBagExt() )
dbSetIndex(cIndWork  + OrdBagExt() )

While TRB->( !Eof() )
	RecLock("TRB2", .T.)
	TRB2->JAF_COD  := TRB->JAF_COD
	TRB2->JAF_DESC := TRB->JAF_DESC
	TRB2->JAF_VERSAO := TRB->JAF_VERSAO
	MsUnLock()

	TRB->( dbSkip() )
EndDo

TRB2->(DbGoTop())

define msDialog oDlg title cTitle from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB2",,,aCpoBrw,,,{ 003, 003, 117, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

@ 125,004 say "Ordenar por:" size 40,08 of oDlg pixel	//"Ordenar por:"
@ 125,042 combobox oOrder var cOrder items aOrders size 125,08 of oDlg pixel valid ( TRB2->( dbSetOrder( oOrder:nAt ) ), oSelect:oBrowse:Refresh(), .T. )
@ 137,004 say "Localizar:" size 40,08 of oDlg pixel	//"Localizar:"
@ 137,042 get oChave var cChave size 125,08 of oDlg pixel valid ( TRB2->( dbSeek( RTrim( cChave ), .T. ) ), oSelect:oBrowse:Refresh(), .T. )
define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

if nOpc == 1
	_RetCodCur := TRB2->JAF_COD
	_RetCodVer := TRB2->JAF_VERSAO
    // Posiciona no registro na JAF para pegar a versao
	JAF->(DBSetOrder(1))
	JAF->(DBSeek( M->JBH_SCP11 + _RetCodCur + _RetCodVer))
endif
             
TRB->( DbCloseArea() )
TRB2->( DbCloseArea() )

fErase( cFileWork + GetDbExtension() )
fErase( cFileWork + OrdBagExt() )
fErase( cIndWork + OrdBagExt() )

Return nOpc == 1

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022K    ³ Autor ³ Luis Ricardo Cinalli ³ Data ³ 06/02/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida a filial destino selecionada.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022K        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0022K( lWeb )

Local lRet		:= .T.
Local aArea		:= GetArea()
Local cProcFil  := ""
Local cEmpAntes	:= SM0->M0_CODIGO
Local cFilAntes	:= SM0->M0_CODFIL

lWeb	 := iif( lWeb == nil, .F., lWeb )
cProcFil := iif( lWeb, httppost->PERG11, M->JBH_SCP11 )
lRet 	 := SM0->( dbSeek( cEmpAntes + cProcFil ) )
                                                    
If !lWeb                                                                                      
	If xFilial() == M->JBH_SCP11
		lRet := .F.	
		MsgAlert(OemtoAnsi("Filial destino é a mesma que a origem."), "Aviso")
	Else
		M->JBH_SCP12 := iif( lRet, Alltrim(SM0->M0_NOME) + " / " + Alltrim(SM0->M0_FILIAL), "" )
	EndIf
else //lWeb
	httppost->PERG12 := iif( lRet, Alltrim(SM0->M0_NOME) + " / " + Alltrim(SM0->M0_FILIAL), "" )
EndIf

SM0->( dbSeek( cEmpAntes + cFilAntes ) )

RestArea( aArea )

Return( lRet )

                                                                                                               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetTurma  ºAutor  ³Rafael Rodrigues    º Data ³ 03/Out/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca uma turma valida para o aluno no periodo letivo e    º±±
±±º          ³ habilitacao definidos nos parametros.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SEC0016b                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetTurma(cCodCur, cPerLet, cHabili, cTurPref)

Local cRet		:= ""
Local aAreaJBO	:= JBO->( GetArea() )

JBO->( dbSetOrder(1) )
if JBO->( dbSeek( xFilial("JBO")+cCodCur+cPerLet+cHabili+cTurPref ) ) .or. JBO->( dbSeek( xFilial("JBO")+cCodCur+cPerLet+cHabili ) )
	cRet := JBO->JBO_TURMA
endif

JBO->( RestArea(aAreaJBO) )

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaJC7  ºAutor  ³Michelle Grecco     º Data ³ 10/Set/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza/Cria os registros referentes as disciplinas        º±±
±±º          ³conforme a analise da Grade de Aulas                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SEC0022H                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaJC7(cRa,cCurso,cSerie,cHabili)                                                                    

Local cMemo1		:= ""
Local lJCTJust		:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
Local lJCOJust		:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)
Local cSituacao		:= ""
Local cSitDis		:= ""
Local cDisEqv		:= ""
 
JCT->( dbSetOrder(1) )		// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP
JC7->( dbSetOrder( 1 ) )
JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM + cSerie + cHabili) )


While (!JCT->( eof() ) .and. JCT->JCT_NUMREQ == JCS->JCS_NUMREQ .and. JCT->JCT_HABILI == cHabili)
                                                             
   //Somente se for periodo letivo anterior e/ou atual, ou seja futuro e do tipo dispensado = 003
   if (JCT->JCT_PERLET == cSerie) .or. (JCT->JCT_SITUAC == '003')
		cSituacao := If( JCT->JCT_SITUAC $ "003|011", "8", iif( JCT->JCT_SITUAC == "001", "A", iif( JCT->JCT_SITUAC $ "002|006", "3", "1"  )  ) )
		cSitDis	  := iif( JCT->JCT_SITUAC $ "002|006", "010", JCT->JCT_SITUAC )
		nRecno := 0  
		cDisEqv := ""   
		cPerlet := JCT->JCT_PERLET
		cHabili := JCT->JCT_HABILI
			
		If JCT->JCT_SITUAC $ "010;002;006" .and. Val( JCT->JCT_PERLET ) < Val( JCS->JCS_SERIE )
			JC7->( dbSetOrder( 3 ) )
			IF JC7->( !dbSeek( xFilial( "JC7" ) + cRA + JCT->JCT_DISCIP ) )
				//localiza pela disciplina equivalente
				If ACEquiv( cRA, JCT->JCT_DISCIP, .T., .T., .T., .T.,@cDisEqv )
					JC7->( dbSeek( xFilial( "JC7" ) + cRA + cDisEqv ) )							
				EndIf	
			Else 
				cDisEqv := JCT->JCT_DISCIP
			EndIf
		
			Do While JC7->( ! EoF() .and. JC7_NUMRA + JC7_DISCIP == cRa + cDisEqv )
				If JC7->JC7_SITDIS $ "001;010;002;006" .and. JC7->JC7_SITUAC $ "345"
					nRecno := JCT->(Recno())
					cSituacao := JC7->JC7_SITUAC
					cSitDis	  := JC7->JC7_SITDIS	
				EndIf
				JC7->( dbSkip() )
			EndDo
		EndIF
		If nRecno > 0 
			JCT->( dbGoto(nRecno) )
			JCT->(RecLock("JCT",.F.))
			JCT->JCT_MEDFIM := JC7->JC7_MEDFIM
			JCT->JCT_MEDCON := JC7->JC7_MEDCON
			JCT->(MsUnlock())
		EndIF
			
		JC7->( dbSetOrder(1) )
		JCO->( dbSetOrder(1) )
		JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS
		JBL->( dbSeek(xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP) )
		While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP )
			
			if (JCT->JCT_PERLET == cSerie)
				if JC7->( !dbSeek( xFilial("JC7")+cRA+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP+JBL->( JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL+JBL_DIASEM+JBL_HORA1 ) ) )
					RecLock("JC7", .T.) 
				Else
					RecLock("JC7",.F.)
				Endif
		  
				JC7->JC7_FILIAL := xFilial("JC7")
				JC7->JC7_NUMRA  := cRa
				JC7->JC7_CODCUR := JBE->JBE_CODCUR
				JC7->JC7_PERLET := JBE->JBE_PERLET
				JC7->JC7_HABILI := JBE->JBE_HABILI
				JC7->JC7_TURMA  := JBE->JBE_TURMA
				JC7->JC7_DISCIP := JCT->JCT_DISCIP
				JC7->JC7_SITDIS := cSitDis
				JC7->JC7_DIASEM := JBL->JBL_DIASEM
				JC7->JC7_CODHOR := JBL->JBL_CODHOR
				JC7->JC7_HORA1  := JBL->JBL_HORA1
				JC7->JC7_HORA2  := JBL->JBL_HORA2
				JC7->JC7_CODPRF := JBL->JBL_MATPRF
				JC7->JC7_CODPR2 := JBL->JBL_MATPR2
				JC7->JC7_CODPR3 := JBL->JBL_MATPR3
				JC7->JC7_CODPR4 := JBL->JBL_MATPR4
				JC7->JC7_CODPR5 := JBL->JBL_MATPR5
				JC7->JC7_CODPR6 := JBL->JBL_MATPR6
				JC7->JC7_CODPR7 := JBL->JBL_MATPR7
				JC7->JC7_CODPR8 := JBL->JBL_MATPR8
				JC7->JC7_CODLOC := JBL->JBL_CODLOC
				JC7->JC7_CODPRE := JBL->JBL_CODPRE
				JC7->JC7_ANDAR  := JBL->JBL_ANDAR
				JC7->JC7_CODSAL := JBL->JBL_CODSAL
				JC7->JC7_SITUAC := cSituacao
				JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
				JC7->JC7_MEDCON := JCT->JCT_MEDCON
			   	JC7->JC7_DESMCO := JCT->JCT_DESMCO
			    JC7->JC7_CODINS := JCT->JCT_CODINS
				JC7->JC7_ANOINS := JCT->JCT_ANOINS
				if JC7->( FieldPos( "JC7_TIPCUR" ) ) > 0 .and. JCT->( FieldPos( "JCT_TIPCUR" ) ) > 0
					JC7->JC7_TIPCUR := JCT->JCT_TIPCUR
				endif
				if JC7->( FieldPos("JC7_SEQ") ) > 0
					JC7->JC7_SEQ	:= JBE->JBE_SEQ
				endif
				JC7->( MsUnLock() )
			endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera disciplinas dispensadas do aluno       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			JCO->( dbSetOrder(1) )		// JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP
			lAchouJCO := JCO->( dbSeek( xFilial( "JCO" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
			
			If JCT->JCT_SITUAC == "003" .and. ! lAchouJCO
				RecLock( "JCO", ! lAchouJCO )
				JCO->JCO_FILIAL := xFilial("JCO")
				JCO->JCO_NUMRA  := cRA
				JCO->JCO_CODCUR := cCurso
				JCO->JCO_PERLET := JCT->JCT_PERLET
				JCO->JCO_HABILI := JCT->JCT_HABILI
				JCO->JCO_DISCIP := JCT->JCT_DISCIP
				JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
				JCO->JCO_MEDCON := JCT->JCT_MEDCON
				JCO->JCO_CODINS := JCT->JCT_CODINS
				JCO->JCO_ANOINS := JCT->JCT_ANOINS
			
				if lJCTJust .and. lJCOJust
					cMemo1 := JCT->( MSMM( JCT->JCT_MEMO1 ) )
					JCO->( MSMM(if(lAchouJCO,JCO->JCO_MEMO1, ),TamSx3("JCO_JUSTIF")[1],,cMemo1,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
				endif	
			
				JCO->( MsUnLock() )
			ElseIf JCT->JCT_SITUAC == "010" .and. lAchouJCO
				
				RecLock( "JCO", ! lAchouJCO )
			
				JCO->( dbDelete() )
				JCO->( MsUnLock() )
			
			EndIf
			JBL->( dbSkip() )
		EndDo
	endif		
	JCT->( dbSkip() )
EndDo                

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SEC0022L    ³ Autor ³   Marcio Menon		 ³ Data ³ 25/09/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bloqueia a transferência de veterano, quando o status do     ³±±
±±³			 ³ aluno estiver como Pré-Matriculado.				            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SEC0022L        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                            
User Function SEC0022L( lWeb )

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
