#Include "TOPCONN.CH" 
#Include "RWMAKE.CH"   
#Include "MSOLE.CH"    
#Include "ACADEF.CH"
#Include "Protheus.CH"

#define CRLF	Chr(13) + Chr(10)

/*/                                                                                  0
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ASSREQ   º Autor ³                    º Data ³  08/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Tela para informacao das assinaturas utilizadas em alguns  º±±
±±º          ³ documentos de requerimentos.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACAA410                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ASSREQ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPRO := Space(6)
cSEC := Space(6)
cVar := Space(290)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  Alltrim(JBH->JBH_TIPO) == '000002' .or. Alltrim(JBH->JBH_TIPO) == '000023'
	@ 64,262 To 341,567 Dialog assinaturas Title "ASSINATURAS"
	@ 10,18 Say "PRO-REITORIA" Size 46,8
	@ 25,15 Say "SECRETARIA" Size 46,8 
	@ 40,15 Say "OBSERVAÇÕES" Size 46,8
	@ 10,63 Get cPRO F3 "JBJ" Size 76,8
	@ 25,63 Get cSEC F3 "JBJ" Size 76,8
	@ 55,15 Get cVar MEMO Size 126,62
	@ 124,111 BmpButton Type 1 Action close(assinaturas)
	Activate Dialog assinaturas	
	Return({cPro, cSec, cVar})
ELSE
	@ 80,262 To 241,567 Dialog assinaturas Title "ASSINATURAS"
	@ 10,18 Say "PRO-REITORIA" Size 46,8
	@ 25,15 Say "SECRETARIA" Size 46,8
	@ 10,63 Get cPRO F3 "JBJ" Size 76,8
	@ 25,63 Get cSEC F3 "JBJ" Size 76,8
	@ 64,111 BmpButton Type 1 Action close(assinaturas)
	Activate Dialog assinaturas
	Return({cPro, cSec})
ENDIF


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AcMsgFun    ³ Autor ³ Gustavo Henrique     ³ Data ³ 16/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna vetor com o assunto do e-mail e mensagem a ser enviada³±±
±±³          ³para o funcionario.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³AcMsgFun        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPC1 - Status atual: Pendente/Atrasado/Aguardando Vaga       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³EXPC1 - Assunto do e-mail     								³±±
±±³       	 ³EXPC2 - Corpo da mensagem do e-mail  							³±±
±±³       	 ³EXPC3 - Campo memo com as observacoes para o funcionario   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACMsgFun

Local cStatus := ParamIxb[1]
Local cTipSol := ParamIxb[2]
Local cObs    := ParamIxb[3]
Local cCRLF   := Chr( 13 ) + Chr( 10 )
Local aRet    := Array( 2 )

aRet[1] := "Requerimento: " + RTrim( JBF->JBF_DESC ) + iif( cTipSol == "4", " RG: ", " RA: " ) + Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
aRet[2] := "Prezado Funcionário" + cCRLF + cCRLF
aRet[2] += "Por favor verificar requerimento número " + JBH->JBH_NUM						

If JBI->( JBI_STATUS # "1" .and. JBI_STATUS # "2" )
	aRet[2] += cCRLF + "O status atual e : " + cStatus
EndIf

if ! Empty( cObs )
	aRet[2] += cCRLF + cCRLF + cObs
endif	

aRet[2] += cCRLF + cCRLF 
aRet[2] += "Secretaria de Registros Acadêmicos" + cCRLF
aRet[2] += Capital( AllTrim( SM0->M0_NOMECOM ) )

Return( aRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AcMsgSol    ³ Autor ³ Gustavo Henrique     ³ Data ³ 16/07/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna vetor com o assunto do e-mail e mensagem a ser enviada³±±
±±³          ³para o solicitante.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³AcMsgSol        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPC1 - Nome do solicitante: Aluno/Funcionario/Candidato/Nome	³±±
±±³       	 ³do solicitante externo.              							³±±
±±³       	 ³EXPC2 - Status atual: 1=Deferido;2=Indeferido;3,4,5=Em analise³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³EXPC1 - Assunto do e-mail     								³±±
±±³       	 ³EXPC2 - Corpo da mensagem do e-mail  							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACMsgSol

Local aRet    := Array( 2 )
Local cSolic  := ParamIxb[1]		// Nome do solicitante: Funcionario/Aluno/Candidato/Externo
Local cStatus := ParamIxb[2]		// 1=Deferido/2=Indeferido/3,4,5=Em analise
Local cTipSol := ParamIxb[3]		// Tipo de solicitante: 1=Funcionario;2=Aluno;3=Candidato;4=Externo
Local cObs    := ParamIxb[4]		// Campo memo com as observacoes para o departamento ou para o aluno.
Local cCRLF   := Chr( 13 ) + Chr( 10 )

aRet[1] := "Requerimento: " + RTrim( JBF->JBF_DESC ) + iif( cTipSol == "4", " RG: ", " RA: " ) + Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

// está sendo analisado/foi indeferido/foi deferido
aRet[2] := "Prezado " + cSolic + cCRLF + cCRLF
aRet[2] += "Seu requerimento número " + RTrim( JBH->JBH_NUM ) + " - " + RTrim( JBF->JBF_DESC )

If cStatus == "1"
	aRet[2] += " foi deferido."
ElseIf cStatus == "2"
	aRet[2] += " foi indeferido."
ElseIf cStatus $ "3/4/5"
	aRet[2] += " está sendo analisado."
EndIf	
     
if ! Empty( cObs ) .And. cStatus == "2"
	aRet[2] += cCRLF + cCRLF + cObs
endif	

aRet[2] += cCRLF + cCRLF 
aRet[2] += "Secretaria de Registros Acadêmicos" + cCRLF
aRet[2] += Capital( AllTrim( SM0->M0_NOMECOM ) )

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ACScpAtrib³Autor  ³Gustavo Henrique    ³ Data ³  23/jul/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preenche um campo do script com um determinado conteudo     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpCO1: Ordem do campo no script do requerimento.           ³±±
±±³          ³ExpC02: Conteudo para preencher o campo do script.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao Educacional - Requerimentos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACScpAtrib( cOrdem, cConteudo )

uRet := Eval( &( "{ || M->JBH_SCP" + cOrdem + " := " + cConteudo + " }" ) )

Return( uRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ACIntTrans³Autor  ³Gustavo Henrique    ³ Data ³  01/ago/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Atualiza intencao de transferencia por curso e disciplina.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpCO1: Curso da intencao.                                  ³±±
±±³          ³ExpC02: Periodo Letivo da intencao.                         ³±±
±±³          ³ExpL03: Soma uma intencao de transferencia.                 ³±±
±±³          ³ExpL04: Busca o curso e o periodo da analise da grade       ³±±
±±³          ³ExpC03: Habilitacao.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao Educacional - Requerimentos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACIntTrans( nCurso, nPerLet, lSoma, lGrade, nHabili )
                         
Local cTurma  := ""		// Turma das disciplinas com intensao de matricula
Local cCurso  := ""		// Codigo do curso
Local cPerLet := ""		// Codigo do periodo letivo
Local cHabili := ""     // Codigo da habilitacao
Local aRet    := {}

lGrade := Iif( lGrade == NIL, .F., lGrade )
                                                                                                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soh executa se:                                                     ³
//³ 1) For um requerimento de transferencia de curso                    ³
//³ 2) Se for para somar, sempre executa, caso seja para subtrair soh   ³
//³    executa se o requerimento estiver deferido ou indeferido e o     ³
//³    campo JBH_DTINIC estiver preenchido.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If JBF->JBF_TRANSF == "1" .and. If( lSoma, .T., JBH->JBH_STATUS $ "12" .and. ! Empty( JBH->JBH_DTINIC ) ) 

	Begin Transaction
	
		If lGrade
		             
			JCS->( dbSetOrder( 1 ) )
			JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )
		     
			cCurso  := JCS->JCS_CURSO
			cPerLet := JCS->JCS_SERIE
			cHabili := JCS->JCS_HABILI
		
		Else
                    
			aRet    := ACScriptReq( JBH->JBH_NUM )

			cCurso	:= aRet[nCurso]
			cPerLet := aRet[nPerLet]
			cHabili := aRet[nHabili]
			
		EndIf	

		JAR->( dbSetOrder( 1 ) )
		if !Empty( cCurso ) .and. !Empty( cPerLet ) .and. JAR->( dbSeek( xFilial( "JAR" ) + cCurso + cPerLet + cHabili) )
			
			RecLock( "JAR", .F. )
			
			If lSoma
				JAR->JAR_TRANSF += 1
			Else
				JAR->JAR_TRANSF -= 1
			EndIf
			
			MsUnlock()
			
			// Acumula a intensao de transferencia sempre na primeira turma encontrada
			// do curso e periodo letivo
			JCE->( dbSetOrder( 1 ) )
			JCE->( dbSeek( xFilial( "JCE" ) + cCurso + cPerLet + cHabili) )
			
			cTurma := If( lGrade, JCS->JCS_TURMA, JCE->JCE_TURMA )
			
			Do While JCE->( ! EoF() .and. JCE_FILIAL + JCE_CODCUR + JCE_PERLET + JCE_HABILI + JCE_TURMA == xFilial( "JCE" ) + cCurso + cPerLet + cHabili + cTurma )
				
				RecLock( "JCE", .F. )
				
				If lSoma
					JCE->JCE_TRANSF += 1
				Else
					JCE->JCE_TRANSF -= 1
				EndIf
				
				MsUnlock()
				
				JCE->( dbSkip() )
				
			EndDo
			
		Endif
				
	End Transaction

EndIf
	
Return( .T. )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACAnalise   ³ Autor ³ Gustavo Henrique     ³ Data ³ 30/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime o documento referente a Analise Curricular.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ACAnalise       					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACAnalise(lDcFins)
             
Default lDcFins := .F.
             
Processa( { || U_ACProcAC(lDcFins) } )

Return( .T. )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACProcAC    ³ Autor ³ Gustavo Henrique     ³ Data ³ 30/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o processamento de impressao referente a Analise      ³±±
±±³          ³Curricular.  													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ACProcAC()  						    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACProcAC(lDcFins)

Local cCodIde	:= ""
Local cTitIde	:= ""
Local aDiscip	:= {}
Local cArqDot	:= "SEC0022.DOT"
Local cPathDot	:= Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD
Local cPathEst	:= Alltrim(GetMv("MV_DIREST")) // Path do arquivo a ser armazenado na estacao de trabalho
Local cSemestre := ""
Local cHabili  := ""
Local cLinha	:= ""
Local cTurno	:= ""
Local nCntFor	:= 0
Local nNumDisp	:= 0
Local hWord		:= 0
Local cNotaDisc := " "
Local nCargaTot := 0
Local nPriElem  := 0
Local cDcFins   := ""

Default lDcFins := .F.  
               
ProcRegua( 5 )      

IncProc()                    
                                                  
if JBH->JBH_TIPSOL == "4"
	cCodIde	:= Left(JBH_CODIDE,TamSX3("JCR_RG")[1])
	cNome	:= JBH->JBH_NOME
	cTitIde := "RG"
else
	cCodIde	:= Left(JBH_CODIDE,TamSX3("JA2_NUMRA")[1])
	cNome	:= SubStr(Posicione( "JA2", 1, xFilial("JA2")+cCodIde, "JA2_NOME" ),1,40)
	cTitIde := "RA"
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando link de comunicacao com o word                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seu Documento Criado no Word                                          ³
//³ A extensao do documento tem que ser .DOT                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MontaDir(cPathEst)

If ! File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0022.DOT nao encontrado no Servidor")

Elseif hWord == "-1"
	MsgBox("Impossível estabelecer comunicação com o Microsoft Word.")

Else   
             
	// Posiciona o Header da Analise da Grade Curricular
	JCS->( dbSetOrder( 1 ) )
	JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )

	// Caso encontre arquivo ja gerado na estacao
	//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
	If File( cPathEst + cArqDot )
		Ferase( cPathEst + cArqDot )
	EndIf
	
	CpyS2T(cPathDot,cPathEst,.T.) // Copia do Server para o Remote, eh necessario

	//para que o wordview e o proprio word possam preparar o arquivo para impressao e
	// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
	// estacao , por exemplo C:\WORDTMP
	cTurno := Tabela( "F5", Posicione( "JAH", 1, xFilial("JAH")+JCS->JCS_CURSO, "JAH_TURNO" ), .F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_NewFile( hWord, cPathEst + cArqDot)
	
	OLE_SetProperty( hWord, oleWdVisible, .F. )
	OLE_SetProperty( hWord, oleWdPrintBack, .F. )

	If lDcFins
		cDcFins := "Transferência de Filial"
	Else
		cDcFins := "Transferência de Curso"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis para o cabecalho   	                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetDocumentVar( hWord, "cReq"	, JBH->JBH_NUM	)
	OLE_SetDocumentVar( hWord, "cData"	, DtoC(dDataBase))
	OLE_SetDocumentVar( hWord, "cNome"	, cNome   )
	OLE_SetDocumentVar( hWord, "cTitIde", cTitIde )
	OLE_SetDocumentVar( hWord, "cRA"	, cCodIde )
	OLE_SetDocumentVar( hWord, "cCurso"	, Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JCS->JCS_CURSO,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC"))
	OLE_SetDocumentVar( hWord, "cHabili", Posicione( "JDK", 1, xFilial("JDK")+JCS->JCS_HABILI, "JDK_DESC" ))
	OLE_SetDocumentVar( hWord, "cAno"	, Posicione( "JAR", 1, xFilial("JAR")+JCS->(JCS_CURSO+JCS_SERIE+JCS_HABILI), "JAR_ANOLET" ))
	OLE_SetDocumentVar( hWord, "cTurno"	, cTurno )
	OLE_SetDocumentVar( hWord, "cFins"	, cDcFins )
		     
	IncProc()
		                              
	cSemestre	:= ""

	JD1->( dbSetOrder( 1 ) )
	JAE->( dbSetOrder( 1 ) )
		
	JCT->( dbSetOrder( 1 ) )   
	JCT->( dbSeek( xFilial("JCT") + JCS->JCS_NUMREQ ) )
		
	Do While JCT->( ! EoF() .and. JCT_FILIAL = xFilial("JCT") .and. JCT_NUMREQ == JCS->JCS_NUMREQ )
		                               
		If ! Empty( JCT->JCT_DISCIP )
		     
			If JCT->JCT_PERLET # cSemestre .Or. JCT->JCT_HABILI # cHabili
				If ! Empty( cSemestre )
					AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
				EndIf
				cSemestre := JCT->JCT_PERLET
				cHabili   := JCT->JCT_HABILI
				AAdd( aDiscip, { JCT->JCT_PERLET,;
					Posicione( "JAR", 1, xFilial("JAR") + JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI,"JAR_DPERLE"),;
					" ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
				AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )	
			EndIf
			                        
			JAE->( dbSeek( xFilial("JAE") + JCT->JCT_DISCIP ) )
	
			If	JCT->JCT_SITUAC == "003" .and.;		// Dispensado
				JD1->( dbSeek( xFilial("JD1") + JCS->JCS_NUMREQ + JCS->JCS_CURSO + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
                               
				nNumDisp := 0
				nCargaTot := 0
				
				While JD1->( ! EoF() .and. xFilial( "JD1" ) == JD1_FILIAL .and. JD1_NUMREQ == JCS->JCS_NUMREQ .And. JD1_CODCUR == JCS->JCS_CURSO .And. JD1_PERLET == JCT->JCT_PERLET .And. JD1_HABILI == JCT->JCT_HABILI .and. JD1_DISCIP == JCT->JCT_DISCIP )
				    
				    nNumDisp ++

					If Empty(JD1->JD1_NOTA)
						cNotaDisc := AllTrim(JD1->JD1_CONCEI)
					Else
						cNotaDisc := Transform(JD1->JD1_NOTA, PesqPict("JD1","JD1_NOTA"))
					EndIf

					nCargaTot += JD1->JD1_CARGA

					If nNumDisp == 1
						AAdd( aDiscip, { JCT->JCT_PERLET, JAE->JAE_DESC, JAE->JAE_CARGA, JD1->JD1_DISEXT, JD1->JD1_CARGA, " ", cNotaDisc, " ", JCT->JCT_HABILI } )

						nPriElem := Len(aDiscip)
					Else	
						AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", JD1->JD1_DISEXT, JD1->JD1_CARGA, " ", cNotaDisc, " ", JCT->JCT_HABILI } )
					EndIf
											
					JD1->( dbSkip() )
					
				EndDo
	
				aDiscip[nPriElem][6] := nCargaTot
				aDiscip[nPriElem][8] := Iif(Empty(JCT->JCT_MEDFIM), JCT->JCT_MEDCON, Transform(JCT->JCT_MEDFIM, PesqPict("JCT","JCT_MEDFIM")))
			Else
	
				AAdd( aDiscip, { JCT->JCT_PERLET, JAE->JAE_DESC, JAE->JAE_CARGA, " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
	
			EndIf
		
		EndIf
			
		JCT->( dbSkip() )

	EndDo
             
	IncProc()

	nCntFor		:= 1
	cSemestre	:= aDiscip[1,1]
	cHabili     := aDiscip[1,9]
	cLinha		:= AllTrim(Str(nCntFor))
		            
	Do While nCntFor <= Len( aDiscip )

		Do While nCntFor <= Len( aDiscip ) .and. aDiscip[nCntFor,1] == cSemestre .And. aDiscip[nCntFor][9] == cHabili
	            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerando variaveis do documento                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cLinha	:= AllTrim(Str(nCntFor))
			
 			OLE_SetDocumentVar( hWord, "cDiscip1" + cLinha + "1", aDiscip[nCntFor,2] )
			OLE_SetDocumentVar( hWord, "nCH1" + cLinha + "2", aDiscip[nCntFor,3] )
 			OLE_SetDocumentVar( hWord, "cDiscip2" + cLinha + "3", aDiscip[nCntFor,4] )
			OLE_SetDocumentVar( hWord, "nCH2" + cLinha + "4", aDiscip[nCntFor,5] )
			OLE_SetDocumentVar( hWord, "nCHTot2" + cLinha + "5", aDiscip[nCntFor,6] )
			OLE_SetDocumentVar( hWord, "nNotaDis" + cLinha + "6", aDiscip[nCntFor,7] )
			OLE_SetDocumentVar( hWord, "nMedia" + cLinha + "7", aDiscip[nCntFor,8] )

			nCntFor += 1

		Enddo
		
		If nCntFor <= Len( aDiscip )
			cSemestre := aDiscip[nCntFor,1]
			cHabili   := aDiscip[nCntFor,9]
		EndIf
							
	Enddo                                                   

	IncProc()

	If nCntFor > 0
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nr. de linhas da Tabela a ser utilizada na matriz do Word             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(hWord,'Adv_SEMESTRE',cLinha)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa macro do Word                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_ExecuteMacro(hWord,"SEMESTRE") 
		
	EndIf
             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizando variaveis do documento                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_UpdateFields( hWord )
                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Maximizo o Documento Word e Ativo o Visible do Word                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_ExecuteMacro( hWord, "Proteger" )

	IncProc()

	OLE_SetProperty( hWord, oleWdVisible, .T. )
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )

EndIf

OLE_CloseLink( hWord, .F. )

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACMsgAGrade ³ Autor ³ Gustavo Henrique     ³ Data ³ 30/09/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Envia e-mail para o aluno informando sobre a disponibilidade  ³±±
±±³          ³do documento de analise curricular na secretaria.				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ACMsgAGrade     					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACMsgAGrade()
                        
Local cEmail	:= ""
Local cAssunto	:= ""
Local cMsg		:= ""         
Local cTipo		:= JBH->JBH_TIPSOL
Local cCodIde	:= ""
Local cNome		:= ""

JBF->( dbSetOrder( 1 ) )
JBF->( dbSeek( xFilial( "JBF" ) + JBH->( JBH_TIPO + JBH_VERSAO ) ) )
                     
If cTipo == "2"

	cCodIde := Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

	JA2->( dbSetOrder( 1 ) )
	JA2->( dbSeek( xFilial( "JA2" ) + cCodIde ) )
                        
	cEmail := JA2->JA2_EMAIL
	cNome  := Alltrim( JA2->JA2_NOME )
	
ElseIf cTipo == "4"

	cCodIde := Left( JBH->JBH_CODIDE, TamSX3("JCR_RG")[1] )

	JCR->( dbSetOrder( 1 ) )
	JCR->( dbSeek( xFilial( "JCR" ) + cCodIde ) )
                        
	cEmail := JCR->JCR_EMAIL
	cNome  := Alltrim( JCR->JCR_NOME )

EndIf	

If ! Empty( cEmail )
                                                    
	cAssunto	:= "Requerimento: " + RTrim( JBF->JBF_DESC ) + If( cTipo == "2", " RA: ", " RG: " ) + cCodIde
                                      
	cMsg		:= "Prezado " + cNome
	cMsg		+= CRLF + CRLF
	cMsg		+= "O documento referente a Análise Curricular já está disponível na secretaria." + CRLF
	cMsg		+= "Para que o processo continue, compareça na secretaria do seu campus para verificar o documento."
	cMsg		+= CRLF + CRLF
	cMsg		+= "Atenciosamente," + CRLF + CRLF
	cMsg		+= "Secretaria de Registros Acadêmicos" + CRLF
	cMsg		+= Capital( AllTrim( SM0->M0_NOMECOM ) )
                                                    
	cMsg		:= CONVCHR_HTM( cMsg )

	ACSendMail( ,,,, cEmail + ";", cAssunto, cMsg )

Else
     
	MsgInfo(	"O e-mail do " + Iif( cTipo == "2", " aluno ", " externo " ) +;
				"não foi informado. Ele não será avisado para comparecer a secretaria e verificar sua Análise Curricular." )

EndIf

Return( .T. )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACCodDep    ³ Autor ³ Gustavo Henrique     ³ Data ³ 30/10/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna o codigo do departamento referente a secretaria,      ³±±
±±³          ³tesouraria, coordenacao, pro-reitoria utilizados nos          ³±±
±±³          ³requerimentos.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ACCodDep        					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPL1 - Identifica se eh departamento referente a coordenacao	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACCodDep( cTipo, lCoord, nUnidade, nCurPad, nFilDes,nCurVig )

Local cRet		:= ""           
Local cRA		:= ""
Local cUnidade	:= ""
Local aRet		:= {}
Local cCodCur	:= ""
Local lScript	:= .F.
Local cQuery 	:= ""
Local lWeb      := IsBlind()                                  
Local cFilDes	:= xFilial("JBE")

If !lWeb
	lScript	:= !Empty( cScript )
EndIf

lCoord		:= Iif( lCoord == NIL, .F., lCoord )
cTipo		:= Iif( cTipo == NIL, "", cTipo )
nUnidade	:= Iif( nUnidade == NIL, 0, nUnidade )
nCurPad		:= Iif( nCurPad == NIL, 0, nCurPad )
nFilDes		:= Iif( nFilDes == NIL, 0, nFilDes )
nCurVig		:= Iif( nCurVig == NIL, 0, nCurVig )

If lScript
	aRet    := ACSepara( cScript )
	cCodCur := ""
	cFildes := Iif(!Empty(nFilDes), aRet[nFilDes], xFilial("JBE")) 
	If lCoord
		cCodCur := aRet[1]
	ElseIf nCurVig > 0 .and. Type("M->JBH_SCP" + strzero(nCurVig,2)) <> "U"
		cCodCur := &( "M->JBH_SCP" + strzero(nCurVig,2) )	
	EndIf
EndIf
If nUnidade == 0
                            
    if ! lWeb
  		cRA	:= Left( M->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
    else
  		cRA	:= HttpSession->ra
    endif
                                 
	JBE->( dbSetOrder( 3 ) )
	if JBE->( !dbSeek( cFildes + "1" + cRA + cCodCur ) ) .and. JBE->( !dbSeek( cFildes + "5" + cRA + cCodCur ) )
		JBE->( dbSetOrder( 1 ) )
		JBE->( dbSeek( cFildes + cRA + cCodCur ) )
		
		while JBE->( !eof() ) .and. JBE->JBE_FILIAL+JBE->JBE_NUMRA+JBE->JBE_CODCUR == cFildes +cRA+cCodCur
			JBE->( dbSkip() )
		end
		
		JBE->( dbSkip(-1) )
	endif

	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( cFildes + JBE->JBE_CODCUR ) )
	cUnidade := JAH->JAH_UNIDAD
Else
	if lScript
		cUnidade := aRet[ nUnidade ]
	endif	
EndIf

If ! Empty( cUnidade )
	If lCoord	// Coordenacao
		cQuery := "Select distinct JBJ_COD "
		cQuery += "  from " + RetSQLName("JBJ") + " JBJ, " + RetSQLName("JAJ") + " JAJ, " + RetSQLName("JAH") + " JAH "
		cQuery += " where JBJ_FILIAL = '" + cFildes + "' "
		cQuery += "   and JAJ_FILIAL = '" + cFildes + "' "
		cQuery += "   and JAH_FILIAL = '" + cFildes + "' "
		If nCurPad > 0
			cQuery += "   and JAH_CURSO  = '" + aRet[nCurPad]   + "' "
		Else
			cQuery += "   and JAH_CODIGO = '" + JBE->JBE_CODCUR + "' "
		Endif
		cQuery += "   and JAH_UNIDAD = '" + cUnidade + "' "
		cQuery += "   and JAH_STATUS = '1'
		cQuery += "   and  JAJ_DATA1 <= '" + Dtos(dDataBase) + "' "
		cQuery += "   and ( JAJ_DATA2  >= '" + Dtos(dDataBase) + "' or JAJ_DATA2 = '        ' ) "
		cQuery += "   and JAJ_TIPO   = '1' "
		cQuery += "   and JBJ_TIPO   = '003' "
		cQuery += "   and JAH_CODIGO = JAJ_CODCUR "
		cQuery += "   and JBJ_MATRES = JAJ_CODCOO "
		cQuery += "   and JBJ_UNIDAD = JAH_UNIDAD "
		cQuery += "   and JBJ.D_E_L_E_T_ <> '*' "
		cQuery += "   and JAJ.D_E_L_E_T_ <> '*' "
		cQuery += "   and JAH.D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

		While QRY->( !Eof() )
			If !Empty( QRY->JBJ_COD )
				cRet := QRY->JBJ_COD
				Exit
			Endif
			QRY->( dbSkip() )
		End
		QRY->( dbCloseArea() )
		dbSelectArea("JBH")
	Else
	    JBJ->( dbSetOrder( 4 ) )
	    If JBJ->( dbSeek( cFildes + cTipo + cUnidade ) )
		    cRet := JBJ->JBJ_COD
		EndIf
	EndIf
Else
    JBJ->( dbSetOrder( 4 ) )
    If JBJ->( dbSeek( cFildes + cTipo  ) )
	    cRet := JBJ->JBJ_COD
	EndIf
EndIf

Return cRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACRetAssReq ³ Autor ³ Gustavo Henrique     ³ Data ³ 01/11/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna a Assinatura, o Nome e o RG do responsavel pelo       ³±±
±±³          ³departamento.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ACRetAssReq     					    						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPC1 - Identifica se eh departamento referente a coordenacao	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ACAA410	        										    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACRetAss( cDep )

Local aRet := {}

cDep := Iif( cDep == NIL, "", cDep )

If ! Empty( cDep )

	JBJ->( dbSetOrder( 1 ) )
	JBJ->( dbSeek( xFilial( "JBJ" ) + cDep ) )
	
	SRA->( dbSetOrder( 1 ) )
	SRA->( dbSeek( xFilial( "SRA" ) + JBJ->JBJ_MATRES ) )
	
	AAdd( aRet, RTrim( SRA->RA_NOME ) )
	AAdd( aRet, RTrim( JBJ->JBJ_CARGO ) )
	AAdd( aRet, RTrim( JBJ->JBJ_RG ) )

Else

	AAdd( aRet, " " )
	AAdd( aRet, " " )
	AAdd( aRet, " " )

EndIf

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACLibVaga º Autor ³ Gustavo Henrique   º Data ³  24/03/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Libera vaga do aluno no curso, periodo letivo e turma e    º±±
±±º          ³ exclui os seus titulos em aberto.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUtilizacao³ Requerimentos de Trancamento, Desistencia, Cancelamento    º±±
±±º          ³ e Guia de Transferencia.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Numero do RA do aluno                              º±±
±±º          ³ EXPC2 - Codigo do curso                                    º±±
±±º          ³ EXPC3 - Periodo Letivo do curso                            º±±
±±º          ³ EXPC4 - Turma                                              º±±
±±º          ³ EXPC5 - Vetor com os prefixos validos no sistema           º±±
±±º          ³ EXPC6 - Situacao da disciplina                             º±±
±±º          ³ EXPC7 - Situacao do aluno na disciplina                    º±±
±±º          ³ EXPC8 - Situacao do aluno no curso                         º±±
±±º          ³ EXPC9 - Habilitacao                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao Educacional                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACLibVaga( cNumRA, cCurso, cPerLet, cTurma, aPrefixo, cSitDis, cJC7Situ, cJBESitu,cHabili )
local cDiscip	:= ""
Local lSkip     := .F.
Local cAnoPer	:= ""
Local nRecord	:= 0
Local lExistJI6	:= TCCanOpen(RetSqlName("JI6"))
Local lExistJJ2 := TCCanOpen(RetSqlName("JJ2")) 
Local cCliente	:= ""
Local cLoja		:= 	""
Local cDtBloq 	:= GetNewPar("MV_GACDTBL","31/12/49")
Local lGACAtivo := GetNewPar("MV_GACATIV", .F.)
Local lAtivoCur := .F.  

begin transaction

aPrefixo	:= ACPrefixo()

JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial("JBE") + cNumRA + cCurso + cPerLet + cHabili + cTurma ) )
while JBE->( !eof() .and. JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA == xFilial("JBE") + cNumRA + cCurso + cPerLet + cHabili + cTurma )
	if JBE->JBE_ATIVO == "2" .and. JBE->JBE_SITUAC == "1"	// Pre-matricula
		nRecord := JBE->( Recno() )
		exit
	elseif JBE->JBE_ATIVO == "1"
		nRecord := JBE->( Recno() )
		exit
	endif
	JBE->( dbSkip() )
end

if nRecord > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre todas as disciplinas do aluno no curso e modifica a situacao para trancado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaVerJBO( JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, JBE->JBE_TURMA, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
	AcaVerJAR( JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
	
	JBM->( dbSetOrder( 2 ) )
	
	if JBM->( dbSeek( xFilial("JBM") + PadR( cNumRA, TamSX3( "JBM_CODIDE" )[1] ) + "2" + JBE->( JBE_CODCUR + JBE_PERLET + JBE_HABILI ) ) )
		RecLock("JBM",.F.)
		JBM->( dbDelete() )
		JBM->( msUnlock() )
	endif
	
	cAnoPer := Posicione("JAR",1,xFilial("JAR")+JBE->(JBE_CODCUR+JBE_PERLET+JBE_HABILI),"JAR_ANOLET") + JAR->JAR_PERIOD
	
	JC7->( dbSetOrder(1) )
	JC7->( dbSeek( xFilial("JC7")+JBE->JBE_NUMRA+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA ) )
	while JC7->( !eof() .and. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA == xFilial("JC7")+JBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) )
		
		// desfaz a alocação da vaga do aluno na disciplina, quando for o caso.
		If Posicione("JAE",1,xFilial("JAE") + JC7->JC7_DISCIP,"JAE_CONVAG") == "1" .and. !JC7->JC7_SITUAC$"789A" .and. ( JBE->( JBE_ATIVO == "1" .or. JBE_ATIVO+JBE_SITUAC == "21" ) )
			AcaVerJCE( JC7->JC7_CODCUR, JC7->JC7_PERLET, JC7->JC7_HABILI, JC7->JC7_TURMA, JC7->JC7_DISCIP, JC7->JC7_CODLOC, JC7->JC7_CODPRE, JC7->JC7_ANDAR, JC7->JC7_CODSAL, JC7->JC7_DIASEM, JC7->JC7_HORA1, JC7->JC7_HORA2, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
		EndIf
		
		cDiscip := JC7->JC7_DISCIP
		
		// percorre a mesma disciplina alterando a situacao no JC7
		lSkip := .F.
		If !Empty(JC7->JC7_OUTCUR)
			lSkip := Posicione("JAR",1,xFilial("JAR")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB),"JAR_ANOLET") + JAR->JAR_PERIOD <> cAnoPer
		Endif
		
		while JC7->( ! eof() .And. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP == xFilial("JC7")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA+cDiscip ) )
			If !lSkip .and. !JC7->JC7_SITUAC$"789A"
				RecLock("JC7", .F.)
				JC7->JC7_SITDIS := cSitDis
				JC7->JC7_SITUAC := cJC7Situ
				JC7->( msUnlock() )
			EndIf
			JC7->( dbSkip() )
		end
	end
	
	If lExistJI6
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancela situação no componente curricular do curso origem que não serao cursados dos proximos periodos
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ACCancComp(JBE->JBE_NUMRA, JBE->JBE_CODCUR, cJC7Situ)                     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Altera situação no componente curricular 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ACA060AtJI6(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI,JBE->JBE_NUMRA)				
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existem títulos em aberto para o aluno, caso exista exclui os títulos em aberto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ACVerBol( cNumRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, "", "",, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Modifica a situacao do aluno no curso para trancado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	JBE->( dbGoto( nRecord ) )	// Garante o reposicionamento da tabela JBE.
	
	RecLock("JBE", .F.)
	JBE->JBE_ATIVO	:= cJBESitu
	JBE->JBE_DTSITU	:= dDatabase
	JBE->( msUnlock() )
	
	If JBE->JBE_ATIVO <> "1"
		If lExistJJ2
			JJ2->( dbSetOrder( 1 ) )
			If JJ2->( dbSeek( xFilial( "JJ2" ) + JBE->JBE_NUMRA + JBE->JBE_CODCUR ) )
				While xFilial( "JJ2" )+ JBE->JBE_NUMRA + JBE->JBE_CODCUR  == AllTrim(JJ2->JJ2_FILIAL + JJ2->JJ2_NUMRA + JJ2->JJ2_CURSO ) .and. !JJ2->(Eof())
					RecLock( "JJ2", .F. )	
					JJ2->JJ2_STATUS  := "2"	
			   		JJ2->( MsUnlock() )
					JJ2->(dbSkip())
				End
			Endif
	   	Endif
    Endif
Endif

If lGACAtivo
                                                                                 
                                           
Dbselectarea("JBE")

JBE->(dbsetorder(3))

If !JBE->(dbseek(xFilial("JBE")+ "8"+ cNumRa))
	lAtivoCur	:=  Iif(JBE->(dbseek(xFilial("JBE")+ "5"+ cNumRa)), .T., JBE->(dbseek(xFilial("JBE")+ "1"+ cNumRa)))
EndIf

 If !lAtivoCur
	Dbselectarea("JA2")
	JA2->( dbSetOrder( 1 ) )
	JA2->( dbSeek( xFilial("JA2") + cNumRA))
	cCliente := JA2->JA2_CLIENT
	cLoja	 := JA2->JA2_LOJA
	JA2->(DbClosearea())  
	
	Dbselectarea("JMO")
	JMO->( dbSetOrder( 1 ) )
	If JMO->(dbSeek(xFilial("JMO")+cCliente+cLoja))
		RecLock("JMO", .F.)
		JMO->JMO_STATUS := '2'
		JMO->JMO_DTBLOQ := CTOD(cDtBloq)
		JMO->(MsUnlock())
	EndIf
 
 EndIf	
endif

end transaction

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACValPrz ºAutor  ³ Gustavo Henrique   º Data ³  25/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o requerimento de trancamento, cancelamento ou   º±±
±±º          ³ desistencia esta sendo solicitado entre antes dos 30 dias  º±±
±±º          ³ do ultimo mes do periodo letivo. Retorna .F. se estiver    º±±
±±º          ³ dentro do periodo.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Codigo do curso                                    º±±
±±º          ³ EXPC2 - Periodo letivo                                     º±±
±±º          ³ EXPC3 - Habilitacao                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACValPrz( cCurso, cPerLet, cHabili )
                               
local dUltPer	
local nDias   := 0

JAR->( dbSetOrder( 1 ) )
JAR->( dbSeek( xFilial( "JAR" ) + cCurso + cPerLet + cHabili ) )
                         
dUltPer := LastDay( JAR->JAR_DATA2 )	// Ultimo dia do mes do periodo letivo
nDias	:= dUltPer - dDataBase			// Numero de dias antes de terminar o mes do periodo letivo

Return( ! ( nDias > 0 .and. nDias <= 30 ) )
              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACMatPaga º Autor ³ Gustavo Henrique   º Data ³  25/03/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se existem titulos de matricula em aberto para o  º±±
±±º          ³ aluno. Se existir retorna .F.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Codigo do curso                                    º±±
±±º          ³ EXPC2 - Periodo letivo                                     º±±
±±º          ³ EXPC3 - Numero do RA do aluno                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACMatPaga( cCurso, cPerLet, cNumRA )
                                                
local aPrefixo	:= ACPrefixo()
Local cNrDoc	:= ""
local lRet		:= .T.

cNrDoc := cCurso + cPerLet + Space( TamSX3("E1_NRDOC" )[1] - Len( cCurso + cPerLet ) )

JA2->( dbSetOrder( 1 ) )
JA2->( dbSeek( xFilial( "JA2" ) + cNumRA ) )

SE1->( dbSetOrder(9) ) 	// NumDoc + Prefixo + Cliente + Loja
SE1->( dbSeek( xFilial( "SE1" ) + cNrDoc + aPrefixo[__MAT] + JA2->( JA2_CLIENT + JA2_LOJA ) ) )

do while SE1->(	! EoF() .and. E1_FILIAL + E1_NRDOC + E1_PREFIXO + E1_CLIENTE + E1_LOJA == ;
				xFilial( "SE1" ) + cNrDoc + aPrefixo[__MAT] + JA2->( JA2_CLIENT + JA2_LOJA ) )

	if SE1->( Empty( E1_BAIXA ) .and. E1_SALDO > 0 )
		lRet := .F.
		exit
	endif
	
	SE1->( dbSkip() )	
	
enddo	

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACTitPago º Autor ³ Alberto Deviciente º Data ³ 10/Jan/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se existem titulos em aberto para o aluno.        º±±
±±º          ³  Se existir retorna .F.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Codigo do Curso Vigente                            º±±
±±º          ³ EXPC2 - Periodo letivo                                     º±±
±±º          ³ EXPC3 - Numero do RA do aluno                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao Educacional                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACTitPago(cCodCur,cPerLet,lVenc)
Local cNrDoc	:= ""
Local lRet		:= .T.
Local aAreaAnt  := GetArea()
Local cRA	:= ""

cRA  := PadR( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1]) //-- Ra do aluno na Filial de Origem

cNrDoc := cCodCur + cPerLet + Space( TamSX3("E1_NRDOC" )[1] - Len( cCodCur + cPerLet ) )

SE1->( dbSetOrder(18) ) //E1_FILIAL+E1_NUMRA+DTOS(E1_VENCTO)+E1_PREFIXO
if SE1->( dbSeek( xFilial("SE1") + cRA ) )
	while SE1->( !EoF() .and. E1_FILIAL + E1_NUMRA == xFilial("SE1") + cRA )
		
		if SE1->( E1_NRDOC == cNrDoc .and. Empty( E1_BAIXA ) .and. E1_SALDO > 0 ) .and. if(lVenc,SE1->E1_VENCREA < dDataBase , .T.)
			MsgStop("Não é possível prosseguir com o requerimento, pois existem títulos em aberto para este aluno.")
			lRet := .F.
			exit
		endif
		
		SE1->( dbSkip() )	
	end
endif

RestArea(aAreaAnt)

Return( lRet )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACAGradeOk º Autor ³ Gustavo Henrique   º Data ³  05/08/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o periodo letivo da analise da grade foi       º±±
±±º          ³ preenchido.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimentos de Transferencia de Curso/Externos e Retorno º±±
±±º          ³ de Aluno.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACAGradeOk()

Local lRet := .T.
Local cSeek := Iif(JBH->(FieldPos("JBH_NUMDES")) > 0 .AND. !Empty(JBH->JBH_NUMDES), JBH->JBH_NUMDES, xFilial("JCS")+JBH->JBH_NUM)

// Posiciona na analise da grade curricular da solicitacao
JCS->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCS->( dbSeek(cSeek) )

// Deve preencher o periodo letivo na analise da grade para poder matricular o aluno 
If Empty( JCS->JCS_SERIE )
	MsgInfo( "O Periodo Letivo não foi informado na Analise da Grade Curricular." )
	lRet := .F.
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACAFilRA  º Autor ³ Gustavo Henrique   º Data ³  16/03/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao de filtro tipo 07 da consulta J19 e J34 utilizada   º±±
±±º          ³ em algumas solicitacoes de requerimentos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao Educacional - Filtro tipo 07 da consulta J19/J34    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACAFilRA(cRA)

local lWeb   := IsBlind()

if lWeb
	cRet := xFilial("JBE")+cRA
else	
	cRet   := xFilial("JBE")+Alltrim(cRA)    	
endif    

M->JBH_SCP10 := Space(TamSX3( "JAH_UNIDAD" )[1])


Return( cRet )  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACLocReq  ºAutora ³Solange Zanardi     º Data ³  06/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se já existe um tipo de requerimento em aberto paraº±±
±±º          ³um mesmo solicitante. Para evitar uma possivel duplicidade  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACLocReq(cCodIde,cTipSol,cTipReq)

Local lRet	:= .T.	//Retorno da funcao
Local cReq	:= ""	//Número de requerimentos para o solicitante

cCodIde := If(cCodIde==NIL,"",PadR(cCodIde,TamSX3("JBH_CODIDE")[1]))
cTipSol := If(cTipSol==NIL,"",PadR(cTipSol,TamSX3("JBH_TIPSOL")[1]))
cTipReq := If(cTipReq==NIL,"",PadR(cTipReq,TamSX3("JBH_TIPO")[1]))

If !Empty(cCodIde) .And. !Empty(cTipSol) .And. !Empty(cTipReq)

	JBH->( DbSetOrder(5) ) //JBH_FILIAL+JBH_CODIDE+JBH_TIPSOL
	If JBH->( DbSeek(xFilial("JBH")+cCodIde+cTipSol) )

		While !JBH->( Eof() ) .And. xFilial("JBH")+cCodIde+cTipSol == JBH->JBH_FILIAL+JBH->JBH_CODIDE+JBH->JBH_TIPSOL

			If JBH->JBH_TIPO == cTipReq .And. JBH->JBH_STATUS $ "3;4;5;7" //3=Pendente;4=Atrasado;5=Aguardando Vaga;7=Pagamento Pendente
				cReq += JBH->JBH_NUM + " "
			EndIf

			JBH->(DbSkip())
		End

	EndIf
	
	If !Empty(cReq)
		lRet := MsgYesNo("Já existe(m) o(s) seguinte(s) requerimento(s) em aberto para o solicitante ( "+cReq+"). Deseja prosseguir com a operação?")
	EndIf
	
EndIf
	
Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACInicTrf ³ Autor ³ Carlos Roberto        ³ Data ³ 06/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava dados na filial destino para analise de grade        ³±±
±±³          ³ 											                  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPN1 - Numero referente ao Curso Origem                   º±±
±±º          ³ EXPN2 - Numero referente ao Per. Letivo Origem             º±±
±±º          ³ EXPN3 - Numero referente a Habilitacao Origem              º±±
±±º          ³ EXPN4 - Numero referente a Turma Origem                    º±±
±±º          ³ EXPN5 - Numero referente a Sub-Turma Origem                º±±
±±º          ³ EXPN6 - Numero referente a Filial Destino                  º±±
±±º          ³ EXPN7 - Numero referente ao Curso Padrao Destino           º±±
±±º          ³ EXPN8 - Numero referente a Versao do Cur. Padrao Destino   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Gestao Educacional - Sigage                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACInicTrf( nCurori, nPerori, nHabori, nTurori, nSubTori, nFildes, nCurso, nVersao )
Local i, j		:= 0
Local cChave	:= ""
Local cNumJBH	:= ""
Local cCurori	:= ""
Local cPerori	:= ""
Local cHabori	:= ""
Local cTurori	:= ""
Local cSubTori	:= ""
Local cFildes	:= ""
Local cCurso	:= ""
Local cVersao   := ""
Local cRAPer	:= ""
Local lSubTurma	:= .F.
Local cStatus	:= JBH->JBH_STATUS
Local cScript	:= ""
Local cFilOFI	:= cFilAnt 
Local aAreaAnt  := GetArea()
Local aAreaAux  := aAreaAnt  //-- Tratamento para nao perdermos as areas
Local aAreaJBH	:= JBH->( GetArea() )
Local aAreaJBF	:= JBF->( GetArea() )
Local aAreaJBI	:= JBI->( GetArea() )
Local nPosMemo2	:= 0  
Local cCadAlu   := ""
Local cRAAnt    := ""

Private aHead := {}

//-- Se existe ou nao subturma 
lSubTurma := nSubTOri <> nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava dados da JBH (REQUERIMENTO) na filial destino         			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(nFildes)
	
	cRAAnt  := JBH->JBH_CODIDE //-- Ra do aluno na Filial de Origem
	
	aRet    := ACScriptReq( JBH->JBH_NUM )
	cCurori := aRet[ nCurori ]
	cPerori := aRet[ nPerori ]
	cHabori := aRet[ nHabori ]
	cTurori := aRet[ nTurori ]
    
	if lSubTurma
		cSubTori := aRet[ nSubTori ]
	endif	

	cFildes	:= aRet[nFildes]
	cCurso	:= aRet[nCurso]
	cVersao	:= aRet[nVersao]
	cNumJBH	:= JBH->JBH_NUM   
	
	//-- Incluir Aluno e Cliente (caso necessário) na Filial Destino
	cCadAlu := U_AcGravaSA1(cFilDes)
	
	cRAPer	:= cCadAlu //-- Ra do aluno na Filial Destino

	// Posiciona no curso padrao da filial de destino
	dbSelectArea( "JAF" )				// Cadastro de curso padrao
	dbSetOrder( 1 )						// JAF_FILIAL+JAF_COD+JAF_VERSAO
	JAF->( dbSeek( cFildes + cCurso + cVersao) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava numero do requerimento de destino no origem                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( JBH->JBH_NUMDES )
		cFilAnt	:= cFildes
		cNumDes := GetSx8Num( "JBH", "JBH_NUM" )
		ConfirmSx8()
		cFilAnt	:= cFilOFI
		RecLock("JBH",.F.)
		JBH->JBH_NUMDES := cFildes + cNumDes
		MsUnlock()
	endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava copia do requerimento da filial destino                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_PegaSx3("JBH")
	aDad := {}
	aAdd(aDad, Array(Len(aHead)))
	for i:= 1 to Len(aHead)
		aDad[Len(aDad),i] := &(aHead[i])
	next i      

	JBH->(dbSetOrder(7)) // JBH_FILIAL+JBH_NUMANT
	If ! JBH->( dbSeek( cFildes + xFilial( "JBH" ) + cNumJBH ) )
		for j:= 1 to Len(aDad) 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pegar o Script antes de alterar cFilAnt para a Filial Destino pois gerava erro de  ³
			//³ Lock Required apos a execucao da Funcao MSMM( ... ) e o Script da Filial Destino   ³
			//³ somente podera ser gravado apos a gravacao de todos os demais campos.			   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			nPosMemo2	:= aScan( aHead, "JBH_MEMO2" )
			cScript 	:= iif( nPosMemo2 > 0, MSMM( aDad[ j, nPosMemo2 ] ), "" )
			cFilAnt		:= cFildes
			dbSelectArea( "JBH" )
			RecLock( "JBH", .T. )
			for i:= 1 to Len(aHead)
 				if Trim(aHead[i]) == "JBH_FILIAL"
					JBH->JBH_FILIAL := cFildes
				elseif Trim(aHead[i]) == "JBH_NUM"
					JBH->JBH_NUM := cNumDes
				elseif Trim(aHead[i]) == "JBH_NUMDES"
					JBH->JBH_NUMDES := ""
				elseif Trim(aHead[i]) == "JBH_NUMANT"
					JBH->JBH_NUMANT := cFilOFI + cNumJBH	//xFilial("JBH") + cNumJBH
				elseif Trim(aHead[i]) == "JBH_CODIDE"
					JBH->JBH_CODIDE := cCadAlu     //-- Ra na filial de Destino (Pode ou nao ser diferente da de origem)
				elseif Trim(aHead[i]) <> "JBH_MEMO2"                                        
					JBH->(&(Trim(aHead[i]))) := aDad[j,i]
				endif
			Next i	
			aAreaAux := JBH->( GetArea() )
			MSMM(,TamSX3("JBH_MEMO2")[1],,cScript,1,,,"JBH","JBH_MEMO2") // Script
			JBH->( RestArea( aAreaAux ) )
			MsUnlock()
			cFilAnt	:= cFilOFI
		Next j

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava dados na JBI (ITENS DA SOLICITACAO DE REQ.  )                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		JBG->( dbSetOrder( 1 ) )
		JBG->( dbSeek( cFildes + JBH->JBH_TIPO + JBH->JBH_VERSAO ) )
		j := 0
		While JBG->(!EoF()) .and. (JBG->(JBG_FILIAL+JBG_COD+JBG_VERSAO) == cFildes+JBH->(JBH_TIPO+JBH_VERSAO))
			j++
			cFilAnt	:= cFildes
			cScript	:= MSMM( "JBI_OBSERV", "" )
			cFilAnt	:= cFilOFI

			dbSelectArea("JBI")
			dbSetOrder( 1 )		// JBI_FILIAL+JBI_NUM+JBI_ORDEM
			RecLock("JBI",.T.)
			JBI->JBI_FILIAL	:= cFildes
			JBI->JBI_NUM	:= cNumDes
			JBI->JBI_ORDEM	:= JBG->JBG_ORDEM
			JBI->JBI_CODDEP	:= ACRetDep()
			If J == 1
				JBI->JBI_DTENT	:= dDatabase
				JBI->JBI_HRENT	:= SUBSTR(Time(),1,5)
			EndIf
			JBI->JBI_STATUS	:= "3"

			aAreaAux := JBI->( GetArea() )
			cFilAnt	:= cFildes
			MSMM(,TamSx3("JBI_OBSERV")[1],,cScript,1,,,"JBI","JBI_MEMO1")
			cFilAnt	:= cFilOFI
			JBI->( RestArea( aAreaAux ) )

			JBI->( MsUnLock() )
			JBG->( DbSkip() )
        EndDo
	else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualizar o requerimento da filial de destino 					³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("JBH",.F.)
		JBH->JBH_STATUS := cStatus
		MsUnlock()
		Return
	endif
						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava dados na JCR (Externos)                                           ³
	//³ Primeiro, verifica Cadastro de Alunos do Destino                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("JA2")
	dbSetOrder(1)										// JA2_FILIAL+JA2_NUMRA
	if JA2->( dbSeek( xFilial("JA2") + PadR( cRAAnt, TamSX3("JA2_NUMRA")[1]) ) ) 
		dbSelectArea( "JCR" )
		dbSetOrder( 2 )									// JCR_FILIAL+JCR_CPF
		if ! JCR->( dbSeek( xFilial( "JCR" ) + JA2->JA2_CPF ) ) 
			RecLock( "JCR", .T. )
			JCR->JCR_FILIAL := cFildes     //--xFilial( "JCR" )
			JCR->JCR_CPF    := JA2->JA2_CPF
			JCR->JCR_RG     := JA2->JA2_RG
			JCR->JCR_NOME   := JA2->JA2_NOME
			JCR->JCR_CEP    := JA2->JA2_CEP
			JCR->JCR_END	:= JA2->JA2_END
			JCR->JCR_NUMEND := JA2->JA2_NUMEND
			JCR->JCR_COMPLE := JA2->JA2_COMPLE
			JCR->JCR_BAIRRO := JA2->JA2_BAIRRO
			JCR->JCR_CIDADE := JA2->JA2_CIDADE
			JCR->JCR_EST    := JA2->JA2_EST
			JCR->JCR_FRESID := JA2->JA2_FRESID
			JCR->JCR_FCELUL := JA2->JA2_FCELUL
			JCR->JCR_FCONTA := JA2->JA2_FCONTA
			JCR->JCR_NOMCON := JA2->JA2_NOMCON
			JCR->JCR_EMAIL  := JA2->JA2_EMAIL
			JCR->JCR_DTNASC := JA2->JA2_DTNASC
			JCR->JCR_NATURA := JA2->JA2_NATURA
			JCR->JCR_NACION := JA2->JA2_NACION
			JCR->JCR_ECIVIL := JA2->JA2_ECIVIL
			JCR->JCR_PAI    := JA2->JA2_PAI
			JCR->JCR_MAE	:= JA2->JA2_MAE
			JCR->JCR_SEXO	:= JA2->JA2_SEXO
			JCR->JCR_DATA   := JA2->JA2_DATA
			JCR->JCR_TIPCPF := JA2->JA2_TIPCPF
			JCR->JCR_DTRG   := JA2->JA2_DTRG
			JCR->JCR_ESTRG	:= JA2->JA2_ESTRG	
			JCR->JCR_TITULO := JA2->JA2_TITULO
			JCR->JCR_CIDTIT := JA2->JA2_CIDTIT
			JCR->JCR_ESTTIT := JA2->JA2_ESTTIT
			JCR->JCR_ZONA   := JA2->JA2_ZONA
			JCR->JCR_CMILIT := JA2->JA2_CMILIT
			JCR->JCR_ENDCOB := JA2->JA2_ENDCOB
			JCR->JCR_NUMCOB := JA2->JA2_NUMCOB
			JCR->JCR_BAICOB := JA2->JA2_BAICOB
			JCR->JCR_COMCOB := JA2->JA2_COMCOB
			JCR->JCR_ESTCOB := JA2->JA2_ESTCOB
			JCR->JCR_CIDCOB := JA2->JA2_CIDCOB
			JCR->JCR_CEPCOB := JA2->JA2_CEPCOB
			JCR->JCR_PROCES := JA2->JA2_PROCES
			JCR->JCR_INSTIT := JA2->JA2_INSTIT
			JCR->JCR_DATAPR := JA2->JA2_DATAPR
			JCR->JCR_CLASSF := JA2->JA2_CLASSF
			JCR->JCR_PONTUA := JA2->JA2_PONTUA
			JCR->JCR_FORING := JA2->JA2_FORING
			JCR->JCR_DATADI := JA2->JA2_DATADI
			JCR->JCR_MEMO1  := JA2->JA2_MEMO1
			JCR->JCR_MEMO2  := JA2->JA2_MEMO2
			JCR->JCR_PROFIS := JA2->JA2_PROFIS
			JCR->JCR_CEPPRF := JA2->JA2_CEPPRF
			JCR->JCR_ENDPRF := JA2->JA2_ENDPRF
			JCR->JCR_BAIPRF := JA2->JA2_BAIPRF
			JCR->JCR_NUMPRF := JA2->JA2_NUMPRF
			JCR->JCR_COMPRF := JA2->JA2_COMPRF
			JCR->JCR_CIDPRF := JA2->JA2_CIDPRF
			JCR->JCR_ESTPRF := JA2->JA2_ESTPRF
			JCR->JCR_FCOML  := JA2->JA2_FCOML
			JCR->JCR_RAMAL  := JA2->JA2_RAMAL
			JCR->JCR_ENTIDA := JA2->JA2_ENTIDA
			JCR->JCR_CONCLU := JA2->JA2_CONCLU
			JCR->JCR_TEMPOJ := JA2->JA2_TEMPOJ
			JCR->JCR_TIPENS := JA2->JA2_TIPENS
	//		JCR->JCR_OBSERV := JA2->JA2_PAI
	//		JCR->JCR_INDICA := JA2->JA2_INDICA
	//		JCR->JCR_TIPIND := JA2->JA2_TIPIND
	//		JCR->JCR_PERIND := JA2->JA2_PERIND
	//		JCR->JCR_VERBOL := JA2->JA2_VERBOL
			MsUnlock()
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava dados na JCS(Cabecalho da Analise de Grade)   				    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("JCS")
	dbSetOrder(1) // JCS_FILIAL+JCS_NUMREQ
	if ! JCS->( dbSeek( cFildes + cNumDes ) )		//JBH->JBH_NUM) )
		RecLock( "JCS", .T. )
		JCS->JCS_FILIAL := cFildes
		JCS->JCS_NUMREQ := cNumDes					//JBH->JBH_NUM
		JCS->JCS_CURPAD := JAF->JAF_COD
		JCS->JCS_VERSAO := JAF->JAF_VERSAO
		MsUnlock()
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava dados na JD1 (Disciplinas Externas)   				            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*dbSelectArea("JC7")
	dbSetOrder(1) // JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1
	cChave := xFilial("JC7") +  PadR( cRaAnt, TamSX3("JC7_NUMRA")[1]) + cCurori + cPerori + cHabori + cTurori
	if JC7->( dbSeek(cChave) ) 
		While JC7->( !EOF() ) .and. JC7->( JC7_FILIAL + JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA ) == cChave 
			if JC7->JC7_SITUAC $ '28'     //-- 2=Aprovado;8=Dispensado
				//if !JD1->( dbSeek(cFildes+JCS->JCS_NUMREQ+JC7->JC7_CODCUR+JC7->JC7_PERLET+JC7->JC7_HABILI+JC7->JC7_DISCIP) )
				if !JD1->( dbSeek(cFildes+cNumDes+JC7->JC7_CODCUR+JC7->JC7_PERLET+JC7->JC7_HABILI+JC7->JC7_DISCIP) )
					RecLock("JD1",.T.)
					JD1->JD1_FILIAL := cFildes
					JD1->JD1_NUMREQ := cNumDes
					JD1->JD1_DISCIP := JC7->JC7_DISCIP
					JD1->JD1_CODCUR := JC7->JC7_CODCUR
					JD1->JD1_DISEXT := Posicione("JAE",1,xFilial("JAE") + JC7->(JC7_DISCIP+JC7_SITDIS),"JAE_DESC")
					JD1->JD1_PERLET := JC7->JC7_PERLET
					JD1->JD1_CARGA  := Posicione("JAS",1,xFilial("JAS") + JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_DISCIP), "JAS_CARGA" )
					JD1->JD1_HABILI := JC7->JC7_HABILI
					JD1->JD1_NOTA   := JC7->JC7_MEDFIM
					JD1->JD1_CONCEI := JC7->JC7_MEDCON
					JD1->JD1_CODINS := JC7->JC7_CODINS      //-- Cod. Instituicao (Tab. Compartilhada) 
					MsUnlock()
				endif	
			endif	
			JC7->( dbSkip() )
	    enddo
	endif   */

endif            

JBI->( RestArea(aAreaJBI) )
JBF->( RestArea(aAreaJBF) )
JBH->( RestArea(aAreaJBH) )
RestArea(aAreaAnt)
	
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACGravaSA1 ³ Autor ³ Luis Ricardo Cinalli  ³ Data ³ 25/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava dados da SA1 e JA2 na Filial Destino com base na JCR  ³±±
±±³          ³ da Filial Origem.								           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 															   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Gestao Educacional - Sigage                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACGravaSA1(cfilDes)
Local lRet		:= .F. 
Local nCont		:= 0
Local cNumCPF   := ""    
Local cNumCli   := ""
Local cNumRA    := ""
Local aJA2Ant   := {}

cNumRA := PadR(JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1])
                
//-- Localizar o aluno na filial de origem para pegar CPF
//-- Fabiana Leal Pereira - 01/08/2006
dbSelectArea("JA2")
JA2->( dbSetOrder( 1 ) ) //-- JA2_FILIAL+JA2_NUMRA      (Filial+requerimento em questao)

IF JA2->( dbSeek( xFilial("JA2") + cNumRA ))
    	
    //-- Estou no JA2 da Filial de origem    	      
	aAdd( aJA2Ant, JA2->JA2_CPF) //-- Posicao 01
	aAdd( aJA2Ant, JA2->JA2_RG)  //-- Posicao 02
	aAdd( aJA2Ant, JA2->JA2_NOME)    //-- Posicao 03
	aAdd( aJA2Ant, JA2->JA2_CEP)    //-- Posicao 04
	aAdd( aJA2Ant, JA2->JA2_END)    //-- Posicao 05
	aAdd( aJA2Ant, JA2->JA2_NUMEND)    //-- Posicao 06
	aAdd( aJA2Ant, JA2->JA2_COMPLE)    //-- Posicao 07
	aAdd( aJA2Ant, JA2->JA2_BAIRRO)    //-- Posicao 08
	aAdd( aJA2Ant, JA2->JA2_CIDADE)    //-- Posicao 09
	aAdd( aJA2Ant, JA2->JA2_EST)    //-- Posicao 10
	aAdd( aJA2Ant, JA2->JA2_FRESID)    //-- Posicao 11
	aAdd( aJA2Ant, JA2->JA2_FCELUL)    //-- Posicao 12
	aAdd( aJA2Ant, JA2->JA2_FCONTA)    //-- Posicao 13
	aAdd( aJA2Ant, JA2->JA2_NOMCON)    //-- Posicao 14
	aAdd( aJA2Ant, JA2->JA2_EMAIL)    //-- Posicao 15
	aAdd( aJA2Ant, JA2->JA2_DTNASC)    //-- Posicao 16
	aAdd( aJA2Ant, JA2->JA2_NATURA)    //-- Posicao 17
	aAdd( aJA2Ant, JA2->JA2_NACION)    //-- Posicao 18
	aAdd( aJA2Ant, JA2->JA2_ECIVIL)    //-- Posicao 19
	aAdd( aJA2Ant, JA2->JA2_PAI)    //-- Posicao 20
	aAdd( aJA2Ant, JA2->JA2_MAE)    //-- Posicao 21
	aAdd( aJA2Ant, JA2->JA2_SEXO)    //-- Posicao 22
	aAdd( aJA2Ant, JA2->JA2_DATA)    //-- Posicao 23
	aAdd( aJA2Ant, JA2->JA2_TIPCPF)    //-- Posicao 24
	aAdd( aJA2Ant, JA2->JA2_DTRG)    //-- Posicao 25
	aAdd( aJA2Ant, JA2->JA2_ESTRG)    //-- Posicao 26
	aAdd( aJA2Ant, JA2->JA2_TITULO)    //-- Posicao 27
	aAdd( aJA2Ant, JA2->JA2_CIDTIT)    //-- Posicao 28
	aAdd( aJA2Ant, JA2->JA2_ESTTIT)    //-- Posicao 29
	aAdd( aJA2Ant, JA2->JA2_ZONA)    //-- Posicao 30
	aAdd( aJA2Ant, JA2->JA2_CMILIT)    //-- Posicao 31
	aAdd( aJA2Ant, JA2->JA2_ENDCOB)    //-- Posicao 32
	aAdd( aJA2Ant, JA2->JA2_NUMCOB)    //-- Posicao 33
	aAdd( aJA2Ant, JA2->JA2_BAICOB)    //-- Posicao 34
	aAdd( aJA2Ant, JA2->JA2_COMCOB)    //-- Posicao 35
	aAdd( aJA2Ant, JA2->JA2_ESTCOB)    //-- Posicao 36
	aAdd( aJA2Ant, JA2->JA2_CIDCOB)    //-- Posicao 37
	aAdd( aJA2Ant, JA2->JA2_CEPCOB)    //-- Posicao 38
	aAdd( aJA2Ant, JA2->JA2_PROCES)    //-- Posicao 39
	aAdd( aJA2Ant, JA2->JA2_INSTIT)    //-- Posicao 40
	aAdd( aJA2Ant, JA2->JA2_DATAPR)    //-- Posicao 41
	aAdd( aJA2Ant, JA2->JA2_CLASSF)    //-- Posicao 42
	aAdd( aJA2Ant, JA2->JA2_PONTUA)    //-- Posicao 43
	aAdd( aJA2Ant, JA2->JA2_FORING)    //-- Posicao 44
	aAdd( aJA2Ant, JA2->JA2_DATADI)    //-- Posicao 45
	aAdd( aJA2Ant, JA2->JA2_MEMO1)    //-- Posicao 46
	aAdd( aJA2Ant, JA2->JA2_MEMO2)    //-- Posicao 47
	aAdd( aJA2Ant, JA2->JA2_PROFIS)    //-- Posicao 48
	aAdd( aJA2Ant, JA2->JA2_CEPPRF)    //-- Posicao 49
	aAdd( aJA2Ant, JA2->JA2_ENDPRF)    //-- Posicao 50
	aAdd( aJA2Ant, JA2->JA2_BAIPRF)    //-- Posicao 51
	aAdd( aJA2Ant, JA2->JA2_NUMPRF)    //-- Posicao 52
	aAdd( aJA2Ant, JA2->JA2_COMPRF)    //-- Posicao 53
	aAdd( aJA2Ant, JA2->JA2_CIDPRF)    //-- Posicao 54
	aAdd( aJA2Ant, JA2->JA2_ESTPRF)    //-- Posicao 55
	aAdd( aJA2Ant, JA2->JA2_FCOML)    //-- Posicao 56
	aAdd( aJA2Ant, JA2->JA2_RAMAL)    //-- Posicao 57
	aAdd( aJA2Ant, JA2->JA2_ENTIDA)    //-- Posicao 58
	aAdd( aJA2Ant, JA2->JA2_CONCLU)    //-- Posicao 59
	aAdd( aJA2Ant, JA2->JA2_TEMPOJ)    //-- Posicao 60
	aAdd( aJA2Ant, JA2->JA2_TIPENS)    //-- Posicao 61		
	aAdd( aJA2Ant, JA2->JA2_STATUS)    //-- Posicao 62
	
	cCodCli := JA2->JA2_CLIENT
  	
    Begin Transaction
	// Caso nao encontre o solicitante como cliente, cria na base.
	SA1->( dbSetOrder( 3 ) ) //-- A1_FILIAL+A1_CGC
	If ! SA1->( dbSeek( xFilial( "SA1" ) + aJA2Ant[1] ) )
                           
		If cNumCli == ""
			cCodCli := GetSXENum( "SA1", "A1_COD" )
		EndIf        
		
		SA1->( dbSetOrder( 1 ) )   //-- A1_FILIAL+A1_COD+A1_LOJA
		while SA1->( dbSeek( xFilial( "SA1" ) + cCodCli ) )
			SA1->( ConfirmSX8() )
			cCodCli	:= GetSXENum( "SA1", "A1_COD" )
		endDo
		
		RecLock( "SA1", .T. )
		SA1->A1_FILIAL	:= xFilial( "SA1" )
		SA1->A1_COD		:= cCodCli
		SA1->A1_LOJA	:= "01"
		SA1->A1_NOME	:= aJA2Ant[3]
		SA1->A1_NREDUZ	:= aJA2Ant[3]
		SA1->A1_PESSOA	:= "F"
		SA1->A1_TIPO	:= "F"
		SA1->A1_END		:= aJA2Ant[5]
		SA1->A1_MUN		:= aJA2Ant[9]
		SA1->A1_EST		:= aJA2Ant[10]
		SA1->A1_BAIRRO	:= aJA2Ant[8]
		SA1->A1_CEP		:= aJA2Ant[4]
		SA1->A1_TEL		:= aJA2Ant[11]
		SA1->A1_ENDCOB	:= aJA2Ant[32]
		SA1->A1_CGC		:= aJA2Ant[1]
		SA1->A1_EMAIL	:= aJA2Ant[15]
		SA1->A1_RG		:= aJA2Ant[2]
		SA1->A1_DTNASC	:= aJA2Ant[16]
		SA1->A1_BAIRROC	:= aJA2Ant[34]
		SA1->A1_CEPC	:= aJA2Ant[38]
		SA1->A1_MUNC	:= aJA2Ant[37]
		SA1->A1_ESTC	:= aJA2Ant[36]
		SA1->A1_NATUREZ	:= &(GetMv("MV_ACNATMT"))
		SA1->( MsUnlock() )
		SA1->( ConfirmSX8() )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verificar qual RA de aluno sera gravado na filial destino.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Ponto de Entrada para tratar novo numero de RA na Filial de Destino.
	//Eh passado como parametro o RA da filial de Origem. Deve ser retornado o RA que sera gravado na filial de Destino em formato Caractere
	If ExistBlock("ACNewRa")
		cNumRA := ExecBlock("ACNewRa", .F., .F., {cNumRA, cfilDes} )
	Else
		cNumRA	:= GetSxeNum("JA2", "JA2_NUMRA", cfilDes)
		JA2->( ConfirmSX8() )
		JA2->( dbSetOrder( 1 ) )   //-- JA2_FILIAL+JA2_NUMRA
		while JA2->( dbSeek( cFildes + cNumRA ) )
			cNumRA	:= GetSXENum( "JA2", "JA2_NUMRA", cfilDes )
			JA2->( ConfirmSX8() )
		end
	EndIf
	
	//Verifica se jah existe o RA na Filial de Destino.
	//Caso existir Nao faz nova inclusao, utiliza o mesmo registro jah existente na JA2
	dbSelectArea("JA2")
	JA2->( dbSetOrder( 1 ) ) // JA2_FILIAL+JA2_NUMRA
	if ! JA2->( dbSeek( cFildes + cNumRA ) )
		RecLock( "JA2", .T. )
		JA2->JA2_FILIAL	:= cFildes
		JA2->JA2_NUMRA	:= cNumRA
		JA2->JA2_CPF	:= aJA2Ant[1]
		JA2->JA2_RG		:= aJA2Ant[2]
		JA2->JA2_NOME	:= aJA2Ant[3]
		JA2->JA2_CEP	:= aJA2Ant[4]
		JA2->JA2_END	:= aJA2Ant[5]
		JA2->JA2_NUMEND	:= aJA2Ant[6]
		JA2->JA2_COMPLE	:= aJA2Ant[7]
		JA2->JA2_BAIRRO	:= aJA2Ant[8]
		JA2->JA2_CIDADE	:= aJA2Ant[9]
		JA2->JA2_EST	:= aJA2Ant[10]
		JA2->JA2_FRESID	:= aJA2Ant[11]
		JA2->JA2_FCELUL	:= aJA2Ant[12]
		JA2->JA2_FCONTA	:= aJA2Ant[13]
		JA2->JA2_NOMCON	:= aJA2Ant[14]
		JA2->JA2_EMAIL	:= aJA2Ant[15]
		JA2->JA2_DTNASC	:= aJA2Ant[16]
		JA2->JA2_NATURA	:= aJA2Ant[17]
		JA2->JA2_NACION	:= aJA2Ant[18]
		JA2->JA2_ECIVIL	:= aJA2Ant[19]
		JA2->JA2_PAI	:= aJA2Ant[20]
		JA2->JA2_MAE	:= aJA2Ant[21]
		JA2->JA2_SEXO	:= aJA2Ant[22]
		JA2->JA2_DATA	:= aJA2Ant[23]
		JA2->JA2_TIPCPF	:= aJA2Ant[24]
		JA2->JA2_DTRG	:= aJA2Ant[25]
		JA2->JA2_ESTRG	:= aJA2Ant[26]
		JA2->JA2_TITULO	:= aJA2Ant[27]
		JA2->JA2_CIDTIT	:= aJA2Ant[28]
		JA2->JA2_ESTTIT	:= aJA2Ant[29]
		JA2->JA2_ZONA	:= aJA2Ant[30]
		JA2->JA2_CMILIT	:= aJA2Ant[31]
		JA2->JA2_ENDCOB	:= aJA2Ant[32]
		JA2->JA2_NUMCOB	:= aJA2Ant[33]
		JA2->JA2_BAICOB	:= aJA2Ant[34]
		JA2->JA2_COMCOB	:= aJA2Ant[35]
		JA2->JA2_ESTCOB	:= aJA2Ant[36]
		JA2->JA2_CIDCOB	:= aJA2Ant[37]
		JA2->JA2_CEPCOB	:= aJA2Ant[38]
		JA2->JA2_PROCES	:= aJA2Ant[39]
		JA2->JA2_INSTIT	:= aJA2Ant[40]
		JA2->JA2_DATAPR := aJA2Ant[41]
		JA2->JA2_CLASSF	:= aJA2Ant[42]
		JA2->JA2_PONTUA	:= aJA2Ant[43]
		JA2->JA2_FORING	:= aJA2Ant[44]
		JA2->JA2_DATADI	:= aJA2Ant[45]
		JA2->JA2_MEMO1	:= aJA2Ant[46]
		JA2->JA2_MEMO2	:= aJA2Ant[47]
		JA2->JA2_PROFIS	:= aJA2Ant[48]
		JA2->JA2_CEPPRF	:= aJA2Ant[49]
		JA2->JA2_ENDPRF	:= aJA2Ant[50]
		JA2->JA2_BAIPRF	:= aJA2Ant[51]
		JA2->JA2_NUMPRF := aJA2Ant[52]
		JA2->JA2_COMPRF	:= aJA2Ant[53]
		JA2->JA2_CIDPRF := aJA2Ant[54]
		JA2->JA2_ESTPRF	:= aJA2Ant[55]
		JA2->JA2_FCOML	:= aJA2Ant[56]
		JA2->JA2_RAMAL	:= aJA2Ant[57]
		JA2->JA2_ENTIDA	:= aJA2Ant[58]
		JA2->JA2_CONCLU	:= aJA2Ant[59]
		JA2->JA2_TEMPOJ	:= aJA2Ant[60]
		JA2->JA2_TIPENS	:= aJA2Ant[61]
//		JA2->JA2_STATUS	:= aJA2Ant[62]
		JA2->JA2_CLIENT	:= SA1->A1_COD
		JA2->JA2_LOJA	:= SA1->A1_LOJA 
		JA2->JA2_RAANT  := xFilial("JA2") + PadR(JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1]) //-- Filial Anterior e RA Anterior
		MsUnlock()
	Else
		cNumRA := PadR(JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1])
	endif
	End Transaction
Else	
	MsgAviso("Aluno não encontrado no cadastro. Não foi possível incluir Aluno na filial destino.")
EndIf
          
Return cNumRA  

/*    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACFimOrig  ³ Autor ³ Luis Ricardo Cinalli  ³ Data ³ 26/05/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Finaliza o Requerimento da Filial de Origem conforme a 	   ³±±
±±³          ³ finalizacao da Filial Destino.					           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 															   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Gestao Educacional - Sigage                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACFimOrig( nCurOri, nPerOri, nHabOri, nTurOri, nTpTrans )
Local aArea		:= JBH->( GetArea() )
Local lRet		:= .F.
Local nCont		:= 0
Local cStatus	:= " "
Local aRet		:= ACScriptReq( JBH->JBH_NUM )	// BUSCA SCRIPT DA FILIAL ATIVA
Local cCurOri	:= " "
Local cPerOri	:= " "
Local cHabOri	:= " "
Local cTurOri	:= " "

For nCont := 1 To Len( aCols )
	If Empty( aCols[ nCont, GDFieldPos( "JBI_DTSAI" ) ] )
		cStatus := aCols[ nCont, GDFieldPos( "JBI_STATUS" ) ]
		Exit
	EndIf
Next nCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Status conforme Requerimento Deferido ou Indeferido            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cStatus $ "12"					// Deferido e Indeferido
	JBH->( dbSetOrder( 1 ) )		// JBH_FILIAL+JBH_NUM
	If JBH->( dbSeek( JBH->JBH_NUMANT ) )

		cCurOri	:= aRet[ nCurOri ]
		cPerOri := aRet[ nPerOri ]
		cHabOri := aRet[ nHabOri ]
		cTurOri := aRet[ nTurOri ]

		Begin Transaction
			RecLock( "JBH", .F. )
			//JBH->JBH_DTSTDO	:= dDatabase
			//JBH->JBH_HRSTDO	:= SUBSTR(Time(),1,5)
			JBH->JBH_STATUS	:= cStatus
			JBH->( MsUnLock() )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Status na JBI (ITENS DA SOLICITACAO DE REQ.  )                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			JBI->( dbSetOrder( 1 ) )
			JBI->( dbSeek( JBH->JBH_FILIAL + JBH->JBH_NUM ) )
			While JBI->( ! EoF() ) .and. ( JBI->( JBI_FILIAL + JBI_NUM ) == JBH->( JBH_FILIAL + JBH_NUM ) )
				If Empty(JBI->JBI_DTSAI)   //-- Se ainda não tiver hora de saida
					RecLock( "JBI", .F. )
					//JBI->JBI_DTENT	:= dDatabase
					//JBI->JBI_HRENT	:= SUBSTR(Time(),1,5)
					JBI->JBI_DTSAI	:= dDatabase
					JBI->JBI_HRSAI	:= SUBSTR(Time(),1,5)
					JBI->JBI_STATUS	:= cStatus
					JBI->( MsUnLock() )      
				EndIf                  
				JBI->( DbSkip() )
    	    EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza a situacao do curso em que o aluno estah matriculado (curso de origem) para transferido ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			JBE->( dbSetOrder( 1 ) )	// JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA
			JBE->( dbSeek( JBH->JBH_FILIAL + PadR( JBH->JBH_CODIDE, TamSX3("JBE_NUMRA")[1]) + cCurOri ))

			While JBE->(!Eof()) .and. (JBH->JBH_FILIAL+PadR(JBH->JBH_CODIDE,TamSX3("JBE_NUMRA")[1])+cCurOri == JBE->(JBE_FILIAL+JBE_NUMRA+JBE_CODCUR))
				If JBE->JBE_ATIVO $ "125" //-- 1=Sim;2=Nao;5=Formado
					If ExistBlock( "ACAtAlu1" )
						U_ACAtAlu1( "JBE" )
					EndIf

					RecLock( "JBE", .F. )
					JBE->JBE_DTSITU := dDatabase
					JBE->JBE_NUMREQ := JBH->JBH_NUM
					JBE->JBE_ATIVO  := "3"						//	Transferido
					JBE->JBE_DTSITU := dDatabase
					If ! Empty( nTpTrans )
						JBE->JBE_TPTRAN := aRet[ nTpTrans ]		// Tipo de Transferencia
					EndIf
					JBE->( MsUnlock() )

					If ExistBlock( "ACAtAlu2")
						U_ACAtAlu2( "JBE" )
					EndIf
					
					//-- Desativar o aluno na filial de origem     
					//-- Somente o JBE tera o status alterado pois é ele que é lido nas estatisticas
				    /*	dbSelectArea("JA2")
					dbSetOrder( 1 )							// JA2_FILIAL+JA2_NUMRA
					if JA2->( dbSeek( JBH->JBH_FILIAL + JBH->JBH_CODIDE ) ) 
						RecLock( "JA2", .F. )
						JA2->JA2_STATUS	:= "3"
						MsUnlock()
					endif					*/
				EndIf
				JBE->( dbSkip() )
			Enddo
        End Transaction
		lRet := .t.
	Else
		MsgInfo( "Não foi possível finalizar o Requerimento da Filial de Origem." )
	EndIf
EndIf
          
JBH->( RestArea( aArea ) )

Return lRet


/*    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACAtuSta1  ³ Autor ³Fabiana Leal Pereira   ³ Data ³ 08/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Replica para o requerimento da filial de origem a atualiza-  ³±±
±±³          ³cao do primeiro departamento da filial de destino.           ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ 															   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Gestao Educacional - Sigage                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACAtuSta1()
Local aArea		:= JBH->( GetArea() ) 
Local aAreaJBI	:= JBI->( GetArea() )
Local lRet		:= .T.
Local cStatus	:= " "
Local lAlter    := .F.
Local nCont     := 0

For nCont := 1 To Len( aCols )
	If Empty( aCols[ nCont, GDFieldPos( "JBI_DTSAI" ) ] )
		cStatus := aCols[ nCont, GDFieldPos( "JBI_STATUS" ) ]
		Exit
	EndIf
Next nCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Status conforme Requerimento Deferido ou Indeferido            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cStatus $ "12"					// Deferido e Indeferido
	JBH->( dbSetOrder( 1 ) )		// JBH_FILIAL+JBH_NUM
	If JBH->( dbSeek( JBH->JBH_NUMANT ) )

		Begin Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Status na JBI (ITENS DA SOLICITACAO DE REQ.  )                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			JBI->( dbSetOrder( 1 ) )
			JBI->( dbSeek( JBH->JBH_FILIAL + JBH->JBH_NUM ) )
			While JBI->( ! EoF() ) .and. ( JBI->( JBI_FILIAL + JBI_NUM ) == JBH->( JBH_FILIAL + JBH_NUM ) ) .And. !lAlter
				If Empty(JBI->JBI_DTSAI)
					RecLock( "JBI", .F. )
					//JBI->JBI_DTENT	:= dDatabase
					//JBI->JBI_HRENT	:= SUBSTR(Time(),1,5)
					JBI->JBI_DTSAI	:= dDatabase
					JBI->JBI_HRSAI	:= SUBSTR(Time(),1,5)
					JBI->JBI_STATUS	:= cStatus
					JBI->( MsUnLock() )
					JBI->( DbSkip() )  
					lAlter := .T.  //-- Alterar somente o primeiro
				Else
					JBI->( DbSkip() )
				EndIf
    	    EndDo
    	    //-- Dar entrada no próximo departamento do requerimento
    	    If JBI->( ! EoF() ) .and. ( JBI->( JBI_FILIAL + JBI_NUM ) == JBH->( JBH_FILIAL + JBH_NUM ) )
    	    	RecLock( "JBI", .F. )
				JBI->JBI_DTENT	:= dDatabase
				JBI->JBI_HRENT	:= SUBSTR(Time(),1,5)	
				JBI->( MsUnLock() )
			EndIf                  
    	    
	    End Transaction	        
    EndIf
EndIf

JBI->( RestArea( aArea ) )	    
JBH->( RestArea( aAreaJBI ) )
    	    
Return lRet

/*    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACRegCon   ³ Autor ³Fabiana Leal Pereira   ³ Data ³ 09/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Se deferir requerimento passar para a filial de origem as    ³±±
±±³          ³alteracoes                                                   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Transferencia de Filial                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Gestao Educacional - Sigage                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACRegCon()
Local aAreaJBH	:= JBH->( GetArea() )
Local aAreaJBI	:= JBI->( GetArea() )
Local lRet		:= .T.
Local cStatus	:= " "
Local lAlter    := .F.
Local nCont     := 0

For nCont := 1 To Len( aCols )
	If Empty( aCols[ nCont, GDFieldPos( "JBI_DTSAI" ) ] )
		cStatus := aCols[ nCont, GDFieldPos( "JBI_STATUS" ) ]
		Exit
	EndIf
Next nCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Status conforme Requerimento Indeferido                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cStatus $ "2"					// Indeferido -- Replicar para o req. origem
	JBH->( dbSetOrder( 1 ) )		// JBH_FILIAL+JBH_NUM
	If JBH->( dbSeek( JBH->JBH_NUMANT ) )

		Begin Transaction
		
			RecLock( "JBH", .F. )
			//JBH->JBH_DTSTDO	:= dDatabase
			//JBH->JBH_HRSTDO	:= SUBSTR(Time(),1,5)
			JBH->JBH_STATUS	:= cStatus
			JBH->( MsUnLock() )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Status na JBI (ITENS DA SOLICITACAO DE REQ.  )                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			JBI->( dbSetOrder( 1 ) )
			JBI->( dbSeek( JBH->JBH_FILIAL + JBH->JBH_NUM ) )
			While JBI->( ! EoF() ) .and. ( JBI->( JBI_FILIAL + JBI_NUM ) == JBH->( JBH_FILIAL + JBH_NUM ) ) .And. !lAlter
				RecLock( "JBI", .F. )
				If !Empty(JBI->JBI_DTENT) .AND. Empty(JBI->JBI_DTSAI)
					JBI->JBI_DTSAI	:= dDatabase
					JBI->JBI_HRSAI	:= SUBSTR(Time(),1,5)
					JBI->JBI_STATUS	:= cStatus
					JBI->( MsUnLock() )
					lAlter := .T.  //-- Alterar somente o primeiro
				EndIF 
				JBI->( dbSkip() )
    	    EndDo
    	        	    
	    End Transaction	        
    EndIf
EndIf
             
JBI->( RestArea( aAreaJBI ) )	      
JBH->( RestArea( aAreaJBH ) )
    	    
Return lRet
