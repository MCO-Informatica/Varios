#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0040a  ºAutor  ³Denis D. Almeida    º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para gravacao da Grade Curricular do Aluno para       º±±
±±º          ³analise. Requerimento de Retorno de Aluno - Reprovacao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ 										                      º±±
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
User Function SEC0040a()

local cNumRA	:= PadR( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local cCursoPdr := ""  
local cVersao   := ""   
local lSeek      
local lRet      := .t.
//Análise de Grade Curricular Inicial conforme inclusão automatica do sistema
if len(aScript) > 0
	cCursoPdr := aScript[12]
	if !empty(cCursoPdr)
		//Após validar a existencia do Curso Padrão paga a versao ativa do mesmo		
		cVersao := aScript[14]
		//Criando a Análise de Grade para o Aluno
		jcs->( dbsetorder(1) )
		lSeek := JCS->( dbseek( xfilial("JCS")+jbh->jbh_num ) )
		if !lSeek
			reclock("jcs", .t.)
			jcs->jcs_filial	:= xFilial("JCS")
			jcs->jcs_numreq	:= jbh->jbh_num
			jcs->jcs_curpad	:= cCursoPdr
			jcs->jcs_versao	:= cVersao
			jcs->( msunlock() )
		endif
		//Lista Disciplinas para posterior inclusão de sistuacao inicial na tabela jct conforme parametros da jc7 anterior caso exista
		jay->( dbsetorder(1) )
		jay->( dbseek( xfilial("JAY")+CCursoPdr+cVersao ) )
		while jay->( !eof() .and. jay_filial+jay_curso+jay_versao == xfilial("JAY")+cCursoPdr+cVersao )
			//Grava situação das Disciplinas na tabela de Analise de Grade
			reclock("JCT", .t.)
			jct->jct_filial	:= xFilial("JCT")
			jct->jct_numreq	:= JBH->JBH_NUM
			jct->jct_perlet	:= JAY->JAY_PERLET
			jct->jct_habili := JAY->JAY_HABILI
			jct->jct_discip	:= JAY->JAY_CODDIS
			if jc7->( dbseek( xfilial("JC7") + cNumRA + jay->jay_coddis ) ) .and. jc7->jc7_situac $ "82"
				jct->jct_situac	:= "003"
			else
				jct->jct_situac	:= "010"
			endif
			jct->( msUnlock() )
			jay->( dbskip() )
		end
	endif
else
	lRet := .f.
	MsgAlert("Não foi possível a geração da Análise de Grade Curricular!")
endif   

return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0040b  ºAutor  ³Denis D. Almeida    º Data ³  20/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua o processamento da geração de Grade para o Aluno     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0040b() 

local lVaga   	:= .f.
local cNumRA  	:= PadR( jbh->jbh_codide, tamsx3("ja2_numra")[1] )
local aScript 	:= ACScriptReq( jbh->jbh_num )   
local cSerieInd := "" //Serie indicada na Análise de Grade Curricular
local lRet      := .t.
local lSubtjbe  := jbe->( fieldpos( "jbe_subtur" ) ) > 0 
local lSubtjcs  := jcs->( fieldpos( "jcs_subtur" ) ) > 0  
local lSeqjbe   := jbe->( fieldpos("jbe_seq") ) > 0
local cKey      := ""
local cTurma    := ""
local nA        := 0
local cSituacao := ""    
local cSitDis   := ""
local nRecno
local cDisEqv   := ""
local cMemo1    := ""  
local lJCTJust	:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
local lJCOJust	:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)
local cQuery	:= ""
local cArqTrb   := CriaTrab(,.F.) 

ProcRegua( 5 )      
IncProc() 

if len(aScript) > 0
	cKey := aScript[1]+aScript[3]+aScript[4]    
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a quantidade de bloqueios para a Disciplina.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if posicione("JAR",1,xfilial("JAR")+cKey,"JAR_DEPREP") <> "1"
	lRet := U_Sec0040h()	
endif

if lRet
	jcs->( dbsetorder(1) )
	jcs->( dbseek(xfilial("JCS")+jbh->jbh_num) )
	
	jar->( dbsetorder(1) )
	jar->( dbseek(xfilial("JAR")+jcs->jcs_curso+jcs->jcs_serie+jcs->jcs_habili) )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe vaga disponível no curso desejado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if !AcaVerJAR(jcs->jcs_curso, jcs->jcs_serie, jcs->jcs_habili, 4)
		MsgStop("Não existe vaga disponível neste curso.")
		return .f.
	endif
	
	jbo->( dbsetorder(1) )
	jbo->( dbseek(xfilial("JBO")+jcs->jcs_curso+jcs->jcs_serie+jcs->jcs_habili ) )
	while jbo->( !eof() ) .and. jbo->jbo_filial+jbo->jbo_codcur+jbo->jbo_perlet+jbo->jbo_habili== xfilial("JBO")+jcs->jcs_curso+jcs->jcs_serie+jcs->jcs_habili
		if AcaVerJBO(jar->jar_codcur, jar->jar_perlet, jar->jar_habili, jbo->jbo_turma, 4)
			lVaga := .t.
			exit
		endif
		jbo->( dbSkip() )
	end
	if !lVaga
		MsgStop("Não existe vaga disponível em nenhuma turma deste curso.")
		Return .f.
	endif
	
	Begin Transaction
	//Efetua reserva de vagas para o Aluno em questão
	ACFazReserva(jcs->jcs_curso,jcs->jcs_serie,jcs->jcs_habili,jcs->jcs_turma,"",.f.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a transferência é realmente de Curso ou não exe³
	//³cutando tratamentos específicos nestes casos.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSerieInd := jcs->jcs_serie
	if jcs->jcs_curso == aScript[1] //Mesmo Curso Vigente
		jbe->( dbsetorder(3) )
		if jbe->( dbseek( xfilial("JBE")+"1"+cNumRA+aScript[1] ) )
			cPerletAt := jbe->jbe_perlet //Semestre Ativo do Aluno
		endif
		if jbe->jbe_situac == "1" //pré-matricula
			MsgAlert("Situação de Pré-Matrícula não aceita para prosseguir com o deferimento do requerimento.")
			return .f.
		endif
		jbe->( dbsetorder(1) )
		for nA := 1 to val(cSerieInd)			
			cSerie := StrZero(nA,tamsx3("jbe_perlet")[1])  			
			if cSerie <= cSerieInd 
				cHabiliAt := posicione("JAR",1,xfilial("JAR")+aScript[1]+cSerie,"JAR_HABILI")
				if jbe->( dbseek( xfilial("JBE")+cNumRA+aScript[1]+cSerie+aScript[4] ) ) .and. jbe->jbe_perlet == cPerletAt //Pegando o semestre Ativo para o Aluno
					if cSerieInd > jbe->jbe_perlet 	// Somente nos casos onde na Anaálise de Grade o Semestre indicado for superior					
						reclock("jbe", .f.)        	// ao Semestre Ativo do Aluno
						jbe->jbe_ativo := "2" 		// Não Ativo
						jbe->( msunlock() ) 
					endif
				elseif !jbe->( dbseek( xfilial("JBE")+cNumRA+aScript[1]+cSerie+aScript[4] ) )										
					cTurma  := if( nA == Val(cSerieInd),jbo->jbo_turma,GetTurma(jcs->jcs_curso,cSerie,jcs->jcs_habili,jbo->jbo_turma) )
					jar->( dbsetorder(1) )
					jar->( dbseek( xfilial("JAR")+aScript[1]+cSerie+aScript[4] ) )
					//Efetuando gravação de jbe para o Aluno sendo que a mesma ainda não exista conforme Análise de Grade
					reclock("jbe", .t.)
					jbe->jbe_filial := xFilial("JBE")
					jbe->jbe_numra  := cNumRA
					jbe->jbe_codcur := jcs->jcs_curso
					jbe->jbe_perlet := cSerie
					jbe->jbe_habili := jcs->jcs_habili
					jbe->jbe_turma  := cTurma
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tratamento para SubTurmas													       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if lSubtjbe .and. lSubtjcs
						jbe->jbe_subtur := jcs->jcs_subtur
					endif
					jbe->jbe_tipo   := "1" //Periodo Letivo Normal
					if cSerie == cSerieInd
						jbe->jbe_situac := if(posicione("JB5",1,xfilial("JB5")+aScript[1]+cSerie+aScript[4]+"01", "JB5_MATPAG") == "1" .and. posicione("JAH",1,xfilial("JAH")+jcs->jcs_curso,"JAH_VALOR") == "1","1","2")	// 1=prematricula; 2=matricula
						jbe->jbe_ativo  := if(jbe->jbe_situac=="1","2","1")   // 1=Sim; 2=Nao
					else
						jbe->jbe_situac := "2"  // 1=pre-matricula; 2=matricula
						jbe->jbe_ativo  := "2"  // 1=sim;2=nao
					endif
					jbe->jbe_dtmatr := dDataBase
					jbe->jbe_anolet := jar->jar_anolet
					jbe->jbe_period := jar->jar_period
					jbe->jbe_tptran := "006"
					jbe->jbe_kitmat := "2"
					if lSeqjbe
						jbe->jbe_seq := ACSequence(jbe->jbe_numra,jbe->jbe_codcur,jbe->jbe_perlet,jbe->jbe_turma,jbe->jbe_habili)
					endif
					jbe->( msunlock() )
				endif
			endif 
			//Efetua a gravação da jc7 conforme parametros indicados na tabela jcs e jct
			jct->( dbsetorder(1) )
			jct->( dbseek( xfilial("JCT")+jbh->jbh_num+cSerie+aScript[4] ) )
			While jct->( !eof() .and. jct_filial+jct_numreq+jct_perlet+jct_habili == xfilial("JCT")+jbh->jbh_num+cSerie+aScript[4] )				
				cSituacao := if( jct->jct_situac == "003", "8", iif( jct->jct_situac == "001","A","1" ) )
				cSitDis	  := jct->jct_situac
				nRecno := 0  
				cDisEqv := ""				
				if jct->jct_situac $ "010;002;006" .and. Val( jct->jct_perlet ) < Val( jcs->jcs_serie )
					jc7->( dbsetorder(3) )
					if jc7->( !dbseek( xfilial( "JC7" )+cNumRA+jct->jct_discip ) )
						//localiza pela disciplina equivalente
						if ACEquiv( cNumRA, jct->jct_discip, .T., .T., .T., .T.,@cDisEqv )
							jc7->( dbseek( xfilial("JC7")+cNumRA+cDisEqv ) )
						endif	
					Else 
						cDisEqv := jct->jct_discip
					EndIf
																				
					While jc7->( ! eof() .and. jc7_numra+jc7_discip == cNumRA+cDisEqv )
						If jc7->jc7_sitdis $ "001;010;002;006" .and. jc7->jc7_situac $ "345"
							nRecno 	  := jct->( recno() )
							cSituacao := jc7->jc7_situac
							cSitDis	  := jc7->jc7_sitdis	
						EndIf
						jc7->( dbskip() )
					End
				EndIF				
				If nRecno > 0
					jct->( dbgoto(nrecno) )
					reclock("jct", .f.)
					jct->jct_medfim := jc7->jc7_medfim
					jct->jct_medcon := jc7->jc7_medcon
					jct->( msunlock() )
				EndIF
				//Gravando Grade de Aulas para o Aluno
				jc7->( dbsetorder(1) )
				jco->( dbsetorder(1) )
				jbl->( dbsetorder(1) )
				jbl->( dbSeek( xFilial("JBL")+jcs->jcs_curso+jct->jct_perlet+jct->jct_habili+jbe->jbe_turma+jct->jct_discip ) )				
				While jbl->( !eof() .and. jbl_filial+jbl_codcur+jbl_perlet+jbl_habili+jbl_turma+jbl_coddis == xfilial("JBL")+jcs->jcs_curso+jct->jct_perlet+jct->jct_habili+jbe->jbe_turma+jct->jct_discip )
					if jc7->( !dbseek( xfilial("JC7")+cNumRA+jbe->( jbe_codcur+jbe_perlet+jbe_habili+jbe_turma )+jct->jct_discip+jbl->( jbl_codloc+jbl_codpre+jbl_andar+jbl_codsal+jbl_diasem+jbl_hora1 ) ) )
						reclock("JC7", .t.)
					else
						reclock("JC7", .f.)
					endif					
					jc7->jc7_filial := xfilial("JC7")
					jc7->jc7_numra  := cNumRA
					jc7->jc7_codcur := jbe->jbe_codcur
					jc7->jc7_perlet := jbe->jbe_perlet
					jc7->jc7_habili := jbe->jbe_habili
					jc7->jc7_turma  := jbe->jbe_turma
					jc7->jc7_discip := jct->jct_discip
					jc7->jc7_sitdis := cSitDis
					jc7->jc7_diasem := jbl->jbl_diasem
					jc7->jc7_codhor := jbl->jbl_codhor
					jc7->jc7_hora1  := jbl->jbl_hora1
					jc7->jc7_hora2  := jbl->jbl_hora2
					jc7->jc7_codprf := jbl->jbl_matprf
					jc7->jc7_codpr2 := jbl->jbl_matpr2
					jc7->jc7_codpr3 := jbl->jbl_matpr3
					jc7->jc7_codpr4 := jbl->jbl_matpr4
					jc7->jc7_codpr5 := jbl->jbl_matpr5
					jc7->jc7_codpr6 := jbl->jbl_matpr6
					jc7->jc7_codpr7 := jbl->jbl_matpr7
					jc7->jc7_codpr8 := jbl->jbl_matpr8
					jc7->jc7_codloc := jbl->jbl_codloc
					jc7->jc7_codpre := jbl->jbl_codpre
					jc7->jc7_andar  := jbl->jbl_andar
					jc7->jc7_codsal := jbl->jbl_codsal
					jc7->jc7_situac := cSituacao
					jc7->jc7_medfim := jct->jct_medfim
					jc7->jc7_medcon := jct->jct_medcon
					jc7->jc7_codins := jct->jct_codins
					jc7->jc7_anoins := jct->jct_anoins
					if jc7->( fieldpos( "jc7_tipcur" ) ) > 0 .and. jct->( fieldpos( "jct_tipcur" ) ) > 0
						jc7->jc7_tipcur := jct->jct_tipcur
					endif
					if jc7->( fieldpos("jc7_seq") ) > 0
						jc7->jc7_seq	:= jbe->jbe_seq
					endif
					jc7->( msunlock() )
		            //Efetuando a gravação de Dispensas para o Aluno
					if jc7->jc7_situac == "8" .and. jco->( !dbseek( xfilial("JCO")+jc7->(jc7_numra+jc7_codcur+jc7_perlet+jc7_habili+jc7_discip) ) )
						Reclock("JCO", .t.)
						jco->jco_filial := xfilial("JCO")
						jco->jco_numra  := jc7->jc7_numra
						jco->jco_codcur := jc7->jc7_codcur
						jco->jco_perlet := jc7->jc7_perlet
						jco->jco_habili := jc7->jc7_habili
						jco->jco_discip := jc7->jc7_discip
						jco->jco_medfim := jc7->jc7_medfim
						jco->jco_medcon := jc7->jc7_medcon
						jco->jco_codins := jc7->jc7_codins
						jco->jco_anoins := jc7->jc7_anoins
						if jco->( fieldpos( "jco_tipcur" ) ) > 0 .and. jc7->( fieldpos( "jc7_tipcur" ) ) > 0
							jco->jco_tipcur := jc7->jc7_tipcur
						endif                                                                      
		
						if lJCOJust .and. lJCTJust 
							cMemo1 := jct->( msmm( jct_memo1 ) )				                                                            
							jco->( msmm(,tamsx3("jco_justif")[1],,cMemo1,1,,,"jco","jco_memo1") )		// justificativa de dispensa					
						endif
						JCO->( MsUnlock() )
						TcSQLExec("commit")
					endif
					jbl->( dbskip() )
				end
				jct->( dbskip() )
			end
		next nA
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ So atualiza documentos se houve mudança de curso vigente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if aScript[1] <> jbe->jbe_codcur
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os documentos do novo curso, aproveitando os ja entregues no curso de origem.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AcGeraDoc(jbe->jbe_numra,jbe->jbe_codcur,aScript[1])			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui os documentos do curso antigo.                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			jc6->( dbsetorder(2) )  // curso vigente + ra + documento
			jc6->( dbseek(xfilial("JC6")+aScript[1]+jbe->jbe_numra) )
			
			While jc6->( !eof() .and. jc6_filial+jc6_codcur+jc6_numra == xFilial("JC6")+aScript[1]+jbe->jbe_numra )
				reclock("jc6", .f.)
				jc6->( dbdelete() )
				jc6->( msunlock() )				
				jc6->( dbskip() )
			End
		endif
		ja2->( dbsetorder(1) )
		ja2->( dbseek( xfilial("JA2")+cNumRA ) )		
		//Gerando títulos para o Aluno no novo Curso		
		AC680Bolet(ja2->ja2_prosel,"010",ja2->ja2_numra,ja2->ja2_numra,jcs->jcs_curso,jcs->jcs_curso,1,jcs->jcs_serie,jbo->jbo_turma,,,,,,,jcs->jcs_habili)		
	else		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³No caso do Curso vigente informado ser diferente do Curso ³
		//³Vigente anterior do Aluno.                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { || ACTransfere(12,14,,,1,3,4,6,,,,,,,0,.t.) },"Processando Transferência..." )
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera aproveitamentos na JCO para periodos futuros, que ainda nao estarao na JC7 do aluno.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "select jct_discip, "
	cQuery += "       jct_situac, "
	cQuery += "       jct_medfim, "
	cQuery += "       jct_medcon, "
	cQuery += "       jct_codins, "
	cQuery += "       jct_anoins, "                 	
	if jct->( fieldpos("jct_tipcur") ) > 0
		cQuery += "   jct_tipcur, "
	endif       
	if lJCOJust .and. lJCTJust
		cQuery += "   jct_memo1, "
	endif	
	cQuery += "       jct_habili, "
	cQuery += "       jct_perlet "
	cQuery += "  from "
	cQuery +=         retsqlname("JCT")+" jct "
	cQuery += " where jct_filial = '"+xfilial("JCT")+"' "
	cQuery += "   and jct_numreq = '"+jcs->jcs_numreq+"' "
	cQuery += "   and jct_situac in ('003','011') "
	cQuery += "   and jct_discip not in  "
	cQuery += " ( select jco_discip "
	cQuery += "        from "
	cQuery +=          retsqlname("JCO")+" jco "
	cQuery += "    where jco_filial = '"+xfilial("JCO")+"' "
	cQuery += "      and jco_numra  = '"+cNumRA+"' "
	cQuery += "      and jco_codcur = '"+jcs->jcs_curso+"' "
	cQuery += "      and jco_perlet = '"+jcs->jcs_serie+"' "
	cQuery += "      and jco_habili = '"+jcs->jcs_habili+"' "
	cQuery += "      and jco_discip = jct_discip "
	cQuery += "      and d_e_l_e_t_ <> '*' ) "
	cQuery += "   and d_e_l_e_t_ <> '*' "	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .F., .F. )
	
	jco->( dbsetorder(1) )
	while (cArqTrb)->( !eof() )
		if jco->( !dbseek( xfilial("JCO")+cNumRA+jcs->jcs_curso+(cArqTrb)->( jct_perlet+jct_habili+jct_discip ) ) )
			if (cArqTrb)->jct_perlet > jcs->jcs_serie 
				reclock("jco", .t.)
				jco->jco_filial := xfilial("JCO")
				jco->jco_numra  := cNumRA
				jco->jco_codcur := jcs->jcs_curso
				jco->jco_perlet := (cArqTrb)->jct_perlet
				jco->jco_discip := (cArqTrb)->jct_discip
				jco->jco_habili := (cArqTrb)->jct_habili
				jco->jco_medfim := (cArqTrb)->jct_medfim
				jco->jco_medcon := (cArqTrb)->jct_medcon
				jco->jco_codins := (cArqTrb)->jct_codins
				jco->jco_anoins := (cArqTrb)->jct_anoins
				if jco->( fieldpos( "jco_tipcur" ) ) > 0 .and. jct->( fieldpos( "jct_tipcur" ) ) > 0
					jco->jco_tipcur := (carqtrb)->jct_tipcur
				endif
				if lJCOJust .and. lJCTJust                                                                                          
					cMemo1 := (cArqTrb)->( msmm( jct_memo1 ) )
					JCO->( MSMM(,tamsx3("jco_justif")[1],,cMemo1,1,,,"jco","jco_memo1") )		// Justificativa de dispensa			
				endif
				jco->( msunlock() )
			endif
		endif
		(cArqTrb)->( dbSkip() )
	end	
	End Transaction
else            
	MsgAlert("O Aluno não encontra-se com situação de bloqueio,ou seu Curso Vigente no Semestre estipulado não encontra-se como REPROVAÇÃO (DP / Reprova)")
	lRet := .f.
endif

return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Sec0040h  ºAutor  ³Denis D. Almeida    º Data ³  19/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica número de Disciplinas pendentes para o Aluno       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Sec0040h()                                                  
Local lReprova := .F.
local cNumRA  := PadR( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] ) 
local aAtivos := {}
local i       := 0 
local aDisBloq:= {}   
local lSoDP   := .f.
//Pegando todos os Cursos Ativos para o aluno
jbe->( dbsetorder(3) )
if jbe->( dbseek( xfilial("JBE")+"1"+cNumRA ) )
	while jbe->( !eof() .and. jbe_filial+jbe_ativo+jbe_numra == xfilial("JBE")+"1"+cNumRA )
		aAdd( aAtivos, { jbe->jbe_numra,jbe->jbe_codcur,jbe->jbe_perlet,jbe->jbe_habili,jbe->jbe_turma  } )
		jbe->( dbskip() ) 
	end	
endif
//Verificando para os Cursos Ativos a pendencia de Disciplinas com Status Bloqueado para posterior aceitação de 
//Requerimento de Retorno de Aluno
jar->( dbsetorder(1) ) 
jbe->( dbsetorder(1) )
for i := 1 to len(aAtivos)
	if jbe->( dbseek( xfilial("JBE")+aAtivos[i,1]+aAtivos[i,2] ) )
		while jbe->( !eof() .and. jbe_filial+jbe_numra+jbe_codcur == xfilial("JBE")+aAtivos[i,1]+aAtivos[i,2] )
			if jar->( dbseek( xfilial("JAR")+jbe->jbe_codcur+jbe->jbe_perlet+jbe->jbe_habili ) )
				nMaxDP := jar->jar_dpmax
				lReprova := iif(Alltrim(JAR->JAR_DEPREP) == '2', .T., .F. )
				AcBloq( jbe->jbe_numra, jbe->jbe_codcur, jbe->jbe_perlet, jbe->jbe_habili, jar->jar_dpmax, @aDisBloq,,.t. )
				if Len(aDisBloq) > nMAXDP .or. lReprova
					lSoDP := .T.
					exit			
				endif		
			endif
			jbe->( dbskip() ) 
		end
	endif 
next i

return lSoDP
