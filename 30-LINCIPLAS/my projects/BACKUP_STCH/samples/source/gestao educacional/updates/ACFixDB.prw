#include "rwmake.ch"  
#include "protheus.ch"                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixWindow บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta janela para confirmacao da execucao dos diversos      บฑฑ
ฑฑบ          ณFix.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FixWindow( nBOPS, bRun, cPerg )
Local cMsg		:= ""
Local lPerg		:= .T.
Local aSays		:= {}
Local aButtons	:= {}
Local nOpc		:= 0

cPerg := if( cPerg # nil, cPerg, "" )

Private oMainWnd

if !OpenSm0()
	Return
endif

aAdd(aSays, "Este programa tem como objetivo ajustar a base de dados afetada pela nใo-conformidade" )
aAdd(aSays, "registrada no BOPS nบ "+Alltrim(Str(nBOPS))+".")
aAdd(aSays, " ")
aAdd(aSays, "O processamento da corre็ao pode levar alguns minutos.")

if !Empty(cPerg)
	lPerg := .F.
	aAdd(aButtons, { 5, .T., { || lPerg := Pergunte(cPerg,.T.) }})
endif
aAdd(aButtons, { 1, .T., { || nOpc := if( lPerg .or. Pergunte(cPerg,.T.), 1, 2 ), if( nOpc == 1, FechaBatch(), nil ) }})
aAdd(aButtons, { 2, .T., { || FechaBatch() }})

FormBatch("Ajuste de base de dados", aSays, aButtons)

if nOpc == 1
	Processa( {|| RunFix( nBOPS, bRun ) }, "Ajuste de base de dados" )
endif

Return

//
// RunFIX
//
Static Function RunFix( nBOPS, bRun )
Local aEmpOk	:= {}
Local cNomeArq	:= "FIX"+Alltrim(Str(nBOPS))
Local cExtArq	:= ".##R"
Local nRecSM0	:= 0

Private cLogFile

Set Dele On

// Faz o laco de repeticao para cada empresa do sistema
ProcRegua( SM0->( RecCount() ) )
SM0->( dbGotop() )

while SM0->( !eof() )
	IncProc( "Processando empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL )
	
	// Verifica se a empresa ja foi processada (em caso de tabelas compartilhadas)
	if SM0->( Deleted() ) .or. aScan( aEmpOk, SM0->M0_CODIGO ) > 0
		SM0->( dbSkip() )
		loop
	endif
	
	RPCSetType(3)
 	RPCSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
	lMsFinalAuto := .F.
	
	cLogFile	:= __RelDir + cNomeArq + cExtArq
	AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Iniciando processamento na empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL+"." )
	
	// Se a tabela JC7 for compartilhada, efetua somente uma vez por empresa
	// se estiver exclusiva, efetua o processo para cada filial
	SX2->( dbSetOrder(1) )
	if SX2->( dbSeek("JC7") .and. Upper(X2_MODO) == "C" )
		aAdd( aEmpOk, SM0->M0_CODIGO )
	endif
	
	// Executa a corre็ใo para a empresa/filial
	Eval( bRun )
	
	AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Fim do processamento na empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL+"." )
   
	nRecSM0 := SM0->( Recno() )
	RPCClearEnv()

	if Select("SM0") == 0
		OpenSm0()
		SM0->( dbGoTo(nRecSM0) )
	endif
	
	SM0->( dbSkip() )
end

AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Processamento concluํdo." )
AcaLog( cLogFile, "" )

MsgAlert( "Programa de corre็ao finalizado!"+Chr(13)+Chr(10)+"Consulte o arquivo '"+cLogFile+"' para maiores detalhes." )

Return

//
// OpenSM0
//
Static Function OpenSM0()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .T. )
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas!", { "Ok" }, 2 )
EndIf                                 

Return lOpen    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix90953  บAutor  ณMicrosiga           บ Data ณ 17/Jan/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados afetada pela gravacao incorrega da  บฑฑ
ฑฑบ          ณmedia final do aluno.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix90953()
FixWindow( 90953, {|| F90953Go() } )
Return

Static Function F90953Go()
Local cQuery	:= ""
Local cCodCur, cPerLet, cHabili, cTurma, cDiscip
Local i, nSeq	:= 0
Local aLote		:= {}
Local aAlunos	:= {}
Local aTables	:= {}
Local aRunning	:= {}

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Prepara todas as tabelas do GE para iniciarem no environment das threads
SX2->( dbSetOrder(1) )
SX2->( dbSeek( "J" ) )
while SX2->( !eof() .and. Left( X2_CHAVE, 1 ) == "J" )

	// Garante que todas as tabelas estarใo abertas para assegurar que o xFilial retornara o valor certo.
	dbSelectArea( SX2->X2_CHAVE )
	
	aAdd( aTables, SX2->X2_CHAVE )
	SX2->( dbSkip() )
end
aAdd( aTables, "SA1" )
aAdd( aTables, "SE1" )
aAdd( aTables, "SE5" )
aAdd( aTables, "SEA" )
aAdd( aTables, "SED" )

// Monta a query para identificar os alunos afetados
cQuery := "select distinct JC7_NUMRA, JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, '2' JC7_OUTRAT "
cQuery += " from "
cQuery += RetSQLName("JC7")+" JC7, "
cQuery += RetSQLName("JBS")+" JBS, "
cQuery += RetSQLName("JBQ")+" JBQ "
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ = ' ' "
cQuery += "   and JBS_FILIAL = '"+xFilial("JBS")+"' and JBS.D_E_L_E_T_ = ' ' "
cQuery += "   and JBQ_FILIAL = '"+xFilial("JBQ")+"' and JBQ.D_E_L_E_T_ = ' ' "
cQuery += "   and JC7_NUMRA  = JBS_NUMRA  "
cQuery += "   and JC7_CODCUR = JBS_CODCUR "
cQuery += "   and JC7_PERLET = JBS_PERLET "
cQuery += "   and JC7_HABILI = JBS_HABILI "
cQuery += "   and JC7_TURMA  = JBS_TURMA  "
cQuery += "   and JC7_DISCIP = JBS_CODDIS "
cQuery += "   and JBS_CODCUR = JBQ_CODCUR "
cQuery += "   and JBS_PERLET = JBQ_PERLET "
cQuery += "   and JBS_HABILI = JBQ_HABILI "
cQuery += "   and JBS_CODAVA = JBQ_CODAVA "
cQuery += "   and JBQ_TIPO   = '2' "					// Somente quem possui apontamento de exame
cQuery += "   and JBS_COMPAR = '1' "					// Somente quem compareceu ao exame
cQuery += "   and JC7_MEDANT = JC7_MEDFIM "				// com media anterior igual a media final.
cQuery += "   and JC7_OUTCUR = '      ' "

cQuery += " union "

cQuery += "select distinct JC7_NUMRA, JC7_OUTCUR JC7_CODCUR, JC7_OUTPER JC7_PERLET, JC7_OUTHAB JC7_HABILI, JC7_OUTTUR JC7_TURMA, JC7_DISCIP, '1' JC7_OUTRAT "
cQuery += " from "
cQuery += RetSQLName("JC7")+" JC7, "
cQuery += RetSQLName("JBS")+" JBS, "
cQuery += RetSQLName("JBQ")+" JBQ "
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ = ' ' "
cQuery += "   and JBS_FILIAL = '"+xFilial("JBS")+"' and JBS.D_E_L_E_T_ = ' ' "
cQuery += "   and JBQ_FILIAL = '"+xFilial("JBQ")+"' and JBQ.D_E_L_E_T_ = ' ' "
cQuery += "   and JC7_NUMRA  = JBS_NUMRA  "
cQuery += "   and JC7_OUTCUR = JBS_CODCUR "
cQuery += "   and JC7_OUTPER = JBS_PERLET "
cQuery += "   and JC7_OUTHAB = JBS_HABILI "
cQuery += "   and JC7_OUTTUR = JBS_TURMA  "
cQuery += "   and JC7_DISCIP = JBS_CODDIS "
cQuery += "   and JBS_CODCUR = JBQ_CODCUR "
cQuery += "   and JBS_PERLET = JBQ_PERLET "
cQuery += "   and JBS_HABILI = JBQ_HABILI "
cQuery += "   and JBS_CODAVA = JBQ_CODAVA "
cQuery += "   and JBQ_TIPO   = '2' "					// Somente quem possui apontamento de exame
cQuery += "   and JBS_COMPAR = '1' "					// Somente quem compareceu ao exame
cQuery += "   and JC7_MEDANT = JC7_MEDFIM "				// com media anterior igual a media final.
cQuery += " order by JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_NUMRA "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Disciplina      Aluno           Tipo" )

while FIX->( !eof() )
	cCodCur	:= FIX->JC7_CODCUR
	cPerLet  := FIX->JC7_PERLET
	cHabili	:= FIX->JC7_HABILI
	cTurma	:= FIX->JC7_TURMA
	cDiscip	:= FIX->JC7_DISCIP
	aAlunos	:= {}
	while FIX->( !eof() .and. JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP = cCodCur+cPerLet+cHabili+cTurma+cDiscip  )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+cCodCur+" "+cPerLet+" "+cHabili+" "+cTurma+" "+cDiscip+" "+FIX->JC7_NUMRA+" "+if( FIX->JC7_OUTRAT == "1", "Outra turma", "Regular" ) )
		aAdd( aAlunos, { FIX->JC7_NUMRA, FIX->JC7_OUTRAT } )
		FIX->( dbSkip() )
	end
	
	aAdd( aLote, { cCodCur, cPerLet, cHabili, cTurma, cDiscip, aAlunos } )
	
	// A cada 20 turmas, fecha o lote e inicia uma thread para processamento
	if Len( aLote ) == 20 .or. FIX->( eof() )
		// Inicia uma thread para calculo deste lote
		aAdd( aRunning, "FIX90953."+StrZero(++nSeq,3) )
		StartJob( "U_FX90953T", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aLote, aRunning[Len(aRunning)] } )
		
		aLote := {}
		
		// Sempre que houver o limite de threads em execu็ใo, monitora at้ alguma finalizar
		// ou quando forem as ultimas threads do processamento, tambem aguarda todas finalizarem
		while ( Len( aRunning ) == 10 ) .or. ( FIX->( eof() ) .and. Len( aRunning ) > 0 )
			for i := 1 to len( aRunning )
				if i <= len( aRunning )
					if File( aRunning[i] )
						FErase( aRunning[i] )
						aRunning := aDel( aRunning, i )
						aRunning := aSize( aRunning, Len( aRunning ) - 1 )
					endif
				endif
			next i
			// Aguarda 1 segundo antes de verificar novamente
			sleep( 1000 )
		end
	endif
end

// Executa o recalculo do ultimo lote parcial, caso ainda tenha algo a processar
if Len( aLote ) > 0
	// Inicia uma thread para calculo deste lote
	aAdd( aRunning, "FIX90953."+StrZero(++nSeq,3) )
	StartJob( "U_F90953T", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aLote, aRunning[Len(aRunning)] } )
	
	aLote := {}
	
	// Sempre que houver o limite de threads em execu็ใo, monitora at้ alguma finalizar
	// ou quando forem as ultimas threads do processamento, tambem aguarda todas finalizarem
	while Len( aRunning ) > 0
		for i := 1 to len( aRunning )
			if i <= len( aRunning )
				if File( aRunning[i] )
					FErase( aRunning[i] )
					aRunning := aDel( aRunning, i )
					aRunning := aSize( aRunning, Len( aRunning ) - 1 )
				endif
			endif
		next i
		// Aguarda 1 segundo antes de verificar novamente
		sleep( 1000 )
	end
endif

FIX->( dbCloseArea() )

Return

//
// Funcao de multi-processamento do FIX90953
//
User Function F90953T( aDados )
Local cCodEmp	:= aDados[1]
Local cCodFil	:= aDados[2]
Local aTables	:= aDados[3]
Local aLote		:= aDados[4]
Local cFile		:= aDados[5]
Local i
Local cCodCur
Local cPerLet
Local cHabili
Local cTurma
Local cDiscip
Local aAlunos

// Abre conexใo do ambiente
RPCSetType(3)
RPCSetEnv( cCodEmp, cCodFil,,,,, aTables )

// Garante que todas as tabelas estarao abertas para assegurar que o xFilial retornara o valor certo.
for i := 1 to len( aTables )
	dbSelectArea( aTables[i] )
next i

for i := 1 to len( aLote )
	cCodCur	:= aLote[i,1]
	cPerLet	:= aLote[i,2]
	cHabili	:= aLote[i,3]
	cTurma	:= aLote[i,4]
	cDiscip	:= aLote[i,5]
	aAlunos	:= aLote[i,6]

	AcaCalcMedia( cCodCur, cPerLet, cHabili, cTurma, cDiscip, aAlunos, "2", .T., 4, .F. )
next i

// Registra o fim do processamento para o robo monitorar
AcaLog( cFile, "Recแlculo do lote concluํdo!" )

// Finaliza conexใo
RPCClearEnv()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix91463  บAutor  ณAlberto Deviciente  บ Data ณ 31/Jan/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados afetada pela gravacao incorreta da  บฑฑ
ฑฑบ          ณGeracao de Pre-Matricula                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix91463()
FixWindow( 91463, {|| F91463Go() } )
Return    

Static Function F91463Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Garante que a JBE esteja aberta
dbSelectArea("JBE")

// Monta a query para identificar os alunos afetados (Alunos que estao ATIVOS em dois periodos letivos para o mesmo curso)
cQuery := "select JBE_NUMRA, JBE_CODCUR "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_ATIVO = '1' " //Somente Alunos que estao ativos
cQuery += " group by JBE_NUMRA, JBE_CODCUR "
cQuery += "having count(*) > 1 " //Somente alunos que estao ATIVOS em mais de um periodo Letivo para o mesmo curso

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Aluno          " )

while QRY1->( !eof() )
	JBE->( dbSetOrder(1) )
	JBE->( dbSeek( xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR ) )
 	while JBE->( !eof() ) .and. JBE->JBE_FILIAL+JBE->JBE_NUMRA+JBE->JBE_CODCUR == xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR 
		if !LastPer( JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET)
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )			
			RecLock( "JBE", .F. )
			JBE->JBE_ATIVO := '2' //Desativa o aluno do periodo letivo anterior     
			JBE->( MsUnlock() )
		endif
		JBE->( dbSkip() )
	enddo
	QRY1->( dbSkip() )
end
  
QRY1->( dbCloseArea() )

RestArea( aArea )

Return

//
// LastPer, usada pelo FIX91463
//
Static Function LastPer( cRA, cCodcur, cPerLet )
Local aArea := GetArea()
Local cQuery	:= ""
Local lRet //Retorna (.T.) se o aluno esta ATIVO em mais de um periodo letivo para o mesmo curso

cQuery := "select max(JBE_PERLET) PERLET "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_ATIVO  = '1' " //Somente Alunos que estao ativos
cQuery += "   and JBE_NUMRA  = '"+cRA+"' " 
cQuery += "   and JBE_CODCUR = '"+cCodCur+"' " 

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )

lRet := cPerLet == QRY2->PERLET 

QRY2->( dbCloseArea() )

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix93086  บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_ATIVO dos alunos afetados pelo BOPS 93086   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix93086()
FixWindow( 93086, {|| F93086Go() } )
Return

Static Function F93086Go()
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lMySQL	:= "MYSQL"$Upper(TCGetDB())
Local lMSSQL	:= "MSSQL"$Upper(TCGetDB())
Local lLog

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

dbSelectArea("JBE")

// Monta a query para identificar os alunos afetados (Alunos que estao ATIVOS em dois periodos letivos para o mesmo curso)
cQuery := "select JBE.R_E_C_N_O_ RECJBE, SE1.R_E_C_N_O_ RECSE1 "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE, "
cQuery += RetSQLName("SE1")+" SE1 "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' '"
cQuery += "   and E1_FILIAL  = '"+xFilial("SE1")+"' and SE1.D_E_L_E_T_ = ' '"
cQuery += "   and JBE_ATIVO  = '2'"
cQuery += "   and JBE_SITUAC = '1'"
cQuery += "   and E1_PREFIXO = 'MAT'"
cQuery += "   and E1_NUMRA   = JBE_NUMRA"
if lMySQL
	cQuery += "   and E1_NRDOC   = Concat( JBE_CODCUR, JBE_PERLET )"
elseif lMSSQL
	cQuery += "   and E1_NRDOC   = JBE_CODCUR+JBE_PERLET"
else
	cQuery += "   and E1_NRDOC   = JBE_CODCUR||JBE_PERLET"
endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Aluno          " )

while FIX->( !eof() )
	JBE->( dbGoTo( FIX->RECJBE ) )
	if JBE->( !Eof() )
		lLog := .F.
		
		JBE->( dbSetOrder(3) )
		if JBE->( dbSeek( xFilial("JBE")+"2"+JBE->JBE_NUMRA+JBE->JBE_CODCUR+StrZero(Val(JBE->JBE_PERLET)-1,2) ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )
			lLog := .T.
			
			JBE->(RecLock("JBE", .F.))
			JBE->JBE_ATIVO := "1"  // Ativo
			JBE->(MsUnLock())
		Endif
		
		SE1->( dbGoTo( FIX->RECSE1 ) )
		if SE1->( !eof() )
			if SE1->E1_SALDO == 0
				if !lLog
					AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )			
				endif
				FA070Aca()
			endif
		endif
	endif
	FIX->( dbSkip() )
end
  
FIX->( dbCloseArea() )

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixDup    บAutor  ณRafael Rodrigues    บ Data ณ 08/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige duplicidades na base de dados                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FixDupl()
FixWindow( 0, {|| FDuplRun() } )
Return

Static Function FDuplRun()
Local cQuery	:= ""
Local i, j		:= 0
Local aAlias	:= {}
Local cChave, cKey

aAdd( aAlias, {"JAS", 2} )	//Indice 02: JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS
aAdd( aAlias, {"JAY", 1} )	//Indice 01: JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS

for i := 1 to len( aAlias )
	
	cChave := Posicione("SX2", 1, aAlias[i,1], "X2_UNICO")
	
	RecLock("SX2",.F.)
	SX2->X2_UNICO := ""
	msUnlock()

	TCSQLExec("DROP INDEX "+RetSQLName(aAlias[i,1])+"."+RetSQLName(aAlias[i,1])+"_UNQ")
	
	cKey := AllTrim(ParseKey(aAlias[i,1], cChave))
	
	cQuery := "select "+cKey+", Count( distinct R_E_C_N_O_ ) as QTD "
	cQuery += "  from "+RetSQLName(aAlias[i,1])
	cQuery += " where "+aAlias[i,1]+"_FILIAL = '"+xFilial(aAlias[i,1])+"' and D_E_L_E_T_ = ' '"
	cQuery += " group by "+cKey
	cQuery += " having Count( distinct R_E_C_N_O_ ) > 1"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )
	
	if FIX->( !eof() )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Tabela "+aAlias[i,1]+" - Recnos eliminados:" )
	else
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Tabela "+aAlias[i,1]+" - Nenhuma duplicidade encontrada." )
	endif
	
	dbSelectArea( aAlias[i,1] )
	dbSetOrder( aAlias[i,2] )
	while FIX->( !eof() )
		for j := 1 to FIX->QTD - 1
			if dbSeek( &("FIX->("+cChave+")") )
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+StrZero( Recno(), 10 ) )
				RecLock( aAlias[i,1], .F. )
				dbDelete()
				msUnlock()
				dbSkip()
			endif
		next j
		FIX->( dbSkip() )
	end

	dbSelectArea( aAlias[i,1] )
	dbCloseArea()

	SX2->( dbSeek( aAlias[i,1] ) )
	RecLock("SX2",.F.)
	SX2->X2_UNICO := cChave
	msUnlock()
	
	X31UpdTable( aAlias[i,1] )
	
	FIX->( dbCloseArea() )
next i

Return

//
// ParseKey, usada pelo FixDupl
//
Static Function ParseKey(cAlias, cChave)
cChave := StrTran( cChave, "+", ", " )
cChave := StrTran( Upper(cChave), "DTOS(", "" )
cChave := StrTran( Upper(cChave), "STRZERO(", "" )
cChave := StrTran( Upper(cChave), "STR(", "" )
cChave := StrTran( Upper(cChave), ")", "" )

Return cChave         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix93048  บAutor  ณAlberto Deviciente  บ Data ณ 07/Mar/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados onde alunos estao matriculados      บฑฑ
ฑฑบ          ณ(JBE_SITUAC = 2), mas estao com status provisorio           บฑฑ
ฑฑบ          ณ(JA2_STATUS = 2)                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix93048()
FixWindow( 93048, {|| F93048Go() } )
Return    

Static Function F93048Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Garante que a JA2 esteja aberta
dbSelectArea("JA2")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a query para identificar os alunos afetados.                                                    ณ
//ณ Alunos que estao "matriculados" (JBE_SITUAC = 2), mas estao com status "provisorio" (JA2_STATUS = 2)  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cQuery := "select distinct JA2_NUMRA "
cQuery += " from "                 
cQuery += RetSQLName("JA2")+" JA2, "
cQuery += RetSQLName("JBE")+" JBE  "
cQuery += " where JA2_FILIAL = '"+xFilial("JA2")+"' and JA2.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JA2_STATUS = '2' " //Somente alunos que estejam com status "Provisorio" 
cQuery += "   and JA2_NUMRA  = JBE_NUMRA "
cQuery += "   and JBE_SITUAC = '2' " //Somente alunos que estejam com status "Matriculado"
 
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY93048", .F., .F. )    

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"RA do Aluno" )

while QRY93048->( !eof() )
	JA2->( dbSetOrder(1) ) //ORDEM: JA2_FILIAL+JA2_NUMRA
	JA2->( dbSeek( xFilial("JA2")+QRY93048->JA2_NUMRA ) )  
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+QRY93048->JA2_NUMRA )			
		RecLock( "JA2", .F. )
		JA2->JA2_STATUS := '1' //Efetiva o aluno que estava como provisorio     
		JA2->( MsUnlock() )
	QRY93048->( dbSkip() )
end
  
QRY93048->( dbCloseArea() )

RestArea( aArea )

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix92225  บAutor  ณAlberto Deviciente  บ Data ณ 31/Mar/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados excluido os registros da tabela JB5 บฑฑ
ฑฑบ          ณque estao relacionados com os cursos da tabela JAH excluidosบฑฑ
ฑฑบ          ณ(registros que estao "orfaos" na tabela JB5) - BOPS 92225   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix92225()
FixWindow( 92225, {|| F92225Go() } )
Return    

Static Function F92225Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

// Garante que a JB5 esteja aberta
dbSelectArea("JB5")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a query para identificar os resgistros afetados.                                                                          ณ
//ณ Registros que estao excluidos na tabela JAH (CURSO VIGENTE), mas nao estao excluidos na tabela JB5 (CURSO VIGENTE X FINANCEIRO) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cQuery := "SELECT DISTINCT JB5_CODCUR "
cQuery += "FROM "
cQuery += RetSQLName("JB5")+" JB5 "
cQuery += "WHERE JB5.D_E_L_E_T_ = ' ' "
cQuery += "AND JB5_CODCUR IN "
cQuery += "( SELECT JAH.JAH_CODIGO "
cQuery += "FROM " 
cQuery += RetSQLName("JAH")+" JAH "
cQuery += "WHERE JAH.D_E_L_E_T_ = '*')"
 
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY92225", .F., .F. )    

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Curso" )

while QRY92225->( !eof() )
	JB5->( dbSetOrder(1) ) //ORDEM: JB5_FILIAL+JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL
	JB5->( dbSeek( xFilial("JB5")+QRY92225->JB5_CODCUR ) )  
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+QRY92225->JB5_CODCUR )			
   	while JB5->JB5_FILIAL == xFilial( "JB5" ) .And.	JB5->JB5_CODCUR == QRY92225->JB5_CODCUR
		JB5->( RecLock("JB5",.F.) )
		JB5->( dbDelete() )
		JB5->( msUnlock() ) 
		JB5->( dbSkip() )
	end
	QRY92225->( dbSkip() )
end
  
QRY92225->( dbCloseArea() )

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106129   บAutor  ณEduardo de Souza    บ Data ณ 30/Ago/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a SE1 de alunos que tiveram transferencia de turma   บฑฑ
ฑฑบ          ณcujo campo esta diferente da chave                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106129()
FixWindow(106129, {|| F106129Go() } )
Return    

Static Function F106129Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lOracle	:= "ORACLE" $ TCGetDB()
Local cMV_1DUP	:= GetMV("MV_1DUP")
Local nParcela
Local aAlunos	:= {}
Local nInd		:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("SE1")
DbSelectArea("JBE")

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComo a aplica็ใo foi corrigida, o ano ้ fixo, 2006, paraณ
//ณacertar os alunos nestas condi็๕es (nใo poderแ          ณ
//ณocorrer mais situa็๕es desse tipo).                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery := "SELECT SE1.R_E_C_N_O_ REG_SE1, JBE.R_E_C_N_O_ REG_JBE, JAR_DATA1 "
cQuery += "FROM " + RetSQLName("JBE") + " JBE, " + RetSQLName("SE1") + " SE1, " + RetSQLName("JAR") + " JAR "
cQuery += "WHERE JBE.D_E_L_E_T_ = ' ' "
cQuery += "AND SE1.D_E_L_E_T_ = ' ' "
cQuery += "AND JAR.D_E_L_E_T_ = ' ' "
cQuery += "AND E1_FILIAL = '"  + xFilial("SE1") + "' "
cQuery += "AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += "AND JAR_FILIAL = '" + xFilial("JAR") + "' "
cQuery += "AND JAR_CODCUR = JBE_CODCUR "
cQuery += "AND JAR_PERLET = JBE_PERLET "
cQuery += "AND JAR_HABILI = JBE_HABILI "
cQuery += "AND JBE_NUMRA = E1_NUMRA "
cQuery += "AND JBE_ATIVO = '1' "
cQuery += "AND JBE_ANOLET = '2006' "
cQuery += "AND JBE_PERIOD = '02' "
cQuery += "AND JBE_SITUAC = '2' "
cQuery += "AND E1_PREFIXO = 'MES' "
cQuery += "AND E1_VENCTO BETWEEN JAR_DATA1 AND JAR_DATA2 "
If lOracle
	cQuery += "AND JBE_CODCUR + JBE_PERLET <> SUBSTR(E1_NRDOC,1,8) "
	cQuery += "AND SUBSTR(E1_NRDOC,9,1) = ' ' "
Else
	cQuery += "AND JBE_CODCUR + JBE_PERLET <> SUBSTRING(E1_NRDOC,8) "
	cQuery += "AND SUBSTRING(E1_NRDOC,9,1) = ' ' "
Endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYSE1", .F., .F. )
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAltera o NRDOC dos registros da SE1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
While _QRYSE1->(!Eof())
	SE1->( DbGoto(_QRYSE1->REG_SE1))	
	JBE->( DbGoto(_QRYSE1->REG_JBE))		
	if Empty( SE1->E1_VALLIQ )
		if val(SE1->E1_PARCELA) == 0
			if cMV_1DUP == "1"
				nParcela := ASC(SE1->E1_PARCELA)-55
			Else
				nParcela := ASC(SE1->E1_PARCELA)-64
			EndIf
		Else
			nParcela := val(SE1->E1_PARCELA)
		EndIf
		SE1->(RecLock("SE1",.F.))
		SE1->(dbDelete())
		SE1->(MsUnLock())
		AcaLog(cLogFile, "SE1 EXCLUIDA - RECNO " + Alltrim(Str(SE1->(RECNO()))))		

		If nParcela > 0 .and. nParcela <= Len( JBE->JBE_BOLETO )
			JBE->(RecLock("JBE",.F.))
			JBE->JBE_BOLETO := Substr(JBE->JBE_BOLETO,1,nParcela-1)+" "+Substr(JBE->JBE_BOLETO,nParcela+1)
			JBE->(MsUnLock())
		EndIf
	Else
		SE1->(RecLock("SE1",.F.))
		SE1->E1_NRDOC := JBE->(JBE_CODCUR + JBE_PERLET)
		SE1->(MsUnLock())
		AcaLog(cLogFile, "SE1_NRDOC ATUALIZADO - RECNO " + Alltrim(Str(SE1->(RECNO()))))		
	EndIf
	If aScan( aAlunos, { |x| x[1] + x[2] + x[3] + x[4] + x[5] == JBE->(JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA) }) == 0
		aAdd( aAlunos, { JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET , JBE->JBE_HABILI , JBE->JBE_TURMA, _QRYSE1->JAR_DATA1 } )
	Endif
	_QRYSE1->( dbSkip() )
End

_QRYSE1->( dbCloseArea() )

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a chamada para geracao de boletosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
For nInd := 1 To Len(aAlunos)
	dDataBase := StoD(aAlunos[nInd,6])
	AC680Bolet(,,aAlunos[nInd,1],aAlunos[nInd,1],aAlunos[nInd,2],aAlunos[nInd,2],,aAlunos[nInd,3],aAlunos[nInd,5],,,,,,,aAlunos[nInd,4])
Next nInd
RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106401   บAutor  ณEduardo de Souza    บ Data ณ 01/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria uma senha temporaria para alunos que nao a possuem. Desบฑฑ
ฑฑบ          ณsa forma, podem entrar no site, solicitar a mesma e altera- บฑฑ
ฑฑบ          ณla posteriormente                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106401()
FixWindow(106401, {|| F106401Go() } )
Return    

Static Function F106401Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("JA2")

cQuery := "SELECT DISTINCT JA2.R_E_C_N_O_ REG FROM " + RetSQLName("JA2") + " JA2, " + RetSQLName("JBE") + " JBE "
cQuery += "WHERE JA2_FILIAL = '" + xFilial("JA2") + "' AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += "AND JA2.D_E_L_E_T_ = ' ' AND JBE.D_E_L_E_T_ = ' ' AND JA2_NUMRA = JBE_NUMRA "
cQuery += "AND JBE_ATIVO IN ('1','2') AND JA2_WPSS = '      ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJA2", .F., .F. )

While _QRYJA2->(!Eof())
	JA2->(DBGOTO(_QRYJA2->REG))
	If RecLock("JA2",.F.)
		JA2->JA2_WPSS	:= StrZero(Int(Randomize(0, 10^TamSx3("JA2_WPSS")[1])),TamSx3("JA2_WPSS")[1])
		JA2->(MsUnlock())
		AcaLog(cLogFile, "JA2 SENHA ALTERADA : RECNO " + Alltrim(Str(JA2->(RECNO()))))
	Endif
	_QRYJA2->(dbSkip())
End

_QRYJA2->(dbCloseArea())

RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106873   บAutor  ณEduardo de Souza    บ Data ณ 05/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui registros indevidos da JBE/JC7 de alunos trancados   บฑฑ
ฑฑบ          ณque tiveram a promocao - pre-matricula                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106873()
FixWindow(106873, {|| F106873Go() } )
Return    

Static Function F106873Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cTexto	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("JBE")
DbSelectArea("JC7")
DbSelectArea("SE1")

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona alunos com requerimento de trancamento de matriculaณ
//ณque nao possuam requerimento de retorno posterior.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery := "SELECT JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, COUNT(*), JBH_DTPART "
cQuery += " FROM " + RetSQLName("JBE") + " JBE, " + RetSQLName("JBH") + " JBH "
cQuery += " WHERE JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBH.D_E_L_E_T_ = ' ' "
cQuery += " AND JBH_FILIAL = '" + xFilial("JBH") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBH_CODIDE = JBE_NUMRA "
cQuery += " AND JBH_TIPO = '000019' "
cQuery += " AND JBE_ANOLET >= '2006' "
cQuery += " AND JBH_STATUS = '1' "
cQuery += " AND JBE_NUMRA NOT IN ( "
cQuery += " SELECT JBH_CODIDE FROM " + RetSQLName("JBH")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND JBH_FILIAL = '" + xFilial("JBH") + "' "
cQuery += " AND JBH_CODIDE = JBE.JBE_NUMRA "
cQuery += " AND JBH_TIPO = '000029' AND JBH_STATUS = '1' "
cQuery += " AND JBH_DTPART >= JBH.JBH_DTPART) "
cQuery += " GROUP BY JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBH_DTPART  "
cQuery += " HAVING COUNT(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJBE", .F., .F. )

JBE->(dbSetOrder(1)) //JBE_FILIAL+JBE_ATIVO+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA
JC7->(dbSetOrder(1)) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA
SE1->( dbOrderNickName("SE116") )	// Ordem: RA + Vencimento + Prefixo

While _QRYJBE->(!Eof())
	cTexto := ""
	
	If JBE->(dbSeek(xFilial("JBE")+_QRYJBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)))
		While JBE->(!Eof()) .And. JBE->(JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI) == xFilial("JBE")+_QRYJBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)
			If JBE->JBE_ATIVO == "4"
				JBE->(dbSkip())
				loop
			Endif				
		    
			Begin Transaction
			cTexto := "******* ALUNO " + JBE->JBE_NUMRA + Chr(13)+Chr(10)
			
	        JC7->(dbSeek(xFilial("JC7")+ JBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)))
	        While JC7->(!Eof()) .And. JC7->(JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI) == xFilial("JC7") + JBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)
	        	If JC7->JC7_SITDIS == "004" .Or. (JC7->JC7_SITDIS <> "004" .And. !Empty(JC7->JC7_OUTCUR)) //Ignora trancados ou com outcur preenchida
	        		JC7->(dbSkip())
	        		loop
	        	Endif
	        	If RecLock("JC7", .F.)
	        		JC7->(dbDelete())
	        		JC7->(MsUnlock())
	        		cTexto += "JC7 EXCLUIDA " + Alltrim(Str(JC7->(RECNO()))) + Chr(13)+Chr(10)
	        	Endif
	        	JC7->(dbSkip())
	        End
	
			AcaVerJAR(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, 2)
			AcaVerJBO(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, JBE->JBE_TURMA, 2)
			ACM010Rec(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI, , , , )
			
			/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe achar titulos, caso estejam 'Em aberto', exclui; caso contrario,ณ
			//ณatualiza o E1_NRDOC.                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
			SE1->( dbSeek( xFilial("SE1") + JBE->JBE_NUMRA ) )
			While SE1->( !eof()) .and. SE1->(E1_FILIAL+E1_NUMRA) == xFilial("SE1")+JBE->JBE_NUMRA
				If Substr(SE1->E1_NRDOC,1,TamSX3("JBE_CODCUR")[1] + TamSX3("JBE_PERLET")[1]) == JBE->(JBE_CODCUR+JBE_PERLET)
					if Empty( SE1->E1_VALLIQ )
						SE1->(RecLock("SE1",.F.))
						SE1->(dbDelete())
						SE1->(MsUnLock())
		        		cTexto += "SE1 EXCLUIDA " + Alltrim(Str(SE1->(RECNO()))) + Chr(13)+Chr(10)						
					EndIf
				EndIf
				SE1->( dbSkip() )
			End
			If RecLock("JBE",.F.)
				JBE->(dbDelete())
				JBE->(MsUnlock())
	       		cTexto += "JBE EXCLUIDA " + Alltrim(Str(JBE->(RECNO()))) + Chr(13)+Chr(10)
			Endif				
			AcaLog(cLogFile, cTexto)
			End Transaction
			JBE->(dbSkip())
		End
	Endif
	_QRYJBE->(dbSkip())
End

_QRYJBE->(dbCloseArea())

RestArea( aArea )

DbSelectArea("JA2")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF105923   บAutor  ณViviane Miam        บ Data ณ 14/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInsere registros na JCO (disciplinas dispensadas no deferi- บฑฑ
ฑฑบ			 ณmento de transfer๊ncia de externos)						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F105923()
FixWindow(105923, {|| F105923Go() } )
Return

Static Function F105923Go()
Local aJBE		:= {}
Local cQuery	:= ""
Local dDtMat	:= dDataBase
Local cNumra
Local cSerie
Local cHabili
Local cTurma
Local lSeq		:= JC7->(FieldPos("JC7_SEQ")) > 0 .and. JBE->(FieldPos("JBE_SEQ")) > 0
Local lJCTJust	:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
Local lJCOJust	:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)
Local cSeq		:= ""
Local cMemoJCT	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

dbSelectArea("JA2")
dbSelectArea("JBE")
dbSelectArea("JBH")
dbSelectArea("JBL")
dbSelectArea("JC7")
dbSelectArea("JCO")
dbSelectArea("JCR")
dbSelectArea("JCS")
dbSelectArea("JCT")

cQuery := "select distinct"
cQuery += "       jct.r_e_c_n_o_ RECJCT,"
cQuery += "       jcs.r_e_c_n_o_ RECJCS,"
cQuery += "       jct_numreq,"
cQuery += "       ja2_numra,"
cQuery += "       jcs_curso,"
cQuery += "       jct_perlet,"
cQuery += "       jcs_habili,"
cQuery += "       jcs_serie"
cQuery += "  from " + RetSQLName("JBH") + " JBH, "
cQuery +=             RetSQLName("JCS") + " JCS, "
cQuery +=             RetSQLName("JCT") + " JCT, "
cQuery +=             RetSQLName("JCR") + " JCR, "
cQuery +=             RetSQLName("JA2") + " JA2 "
cQuery += " where jbh_filial = '" + xFilial("JBH") + "' and jbh.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_filial = '" + xFilial("JCS") + "' and jcs.d_e_l_e_t_ = ' '"
cQuery += "   and jct_filial = '" + xFilial("JCT") + "' and jct.d_e_l_e_t_ = ' '"
cQuery += "   and jcr_filial = '" + xFilial("JCR") + "' and jcr.d_e_l_e_t_ = ' '"
cQuery += "   and ja2_filial = '" + xFilial("JA2") + "' and ja2.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_numreq = jbh_num"
cQuery += "   and jcr_rg     = jbh_codide"
cQuery += "   and jct_numreq = jcs_numreq"
cQuery += "   and ja2_rg     = jcr_rg"
cQuery += "   and jbh_tipo   = '000024'"
cQuery += "   and jbh_status = '1'"
cQuery += "   and jct_perlet < jcs_serie"
cQuery += "   and not exists ( select jbe_perlet"
cQuery += "                      from " + RetSQLName("JBE") + " JBE, "
cQuery +=                                 RetSQLName("JBO") + " JBO "
cQuery += "                     where jbe_filial = jct_filial and jbe.d_e_l_e_t_ = ' '"
cQuery += "                       and jbo_filial = jbe_filial and jbo.d_e_l_e_t_ = ' '"
cQuery += "                       and jbe_numra  = ja2_numra"
cQuery += "                       and jbe_codcur = jcs_curso"
cQuery += "                       and jbe_perlet = jct_perlet"
cQuery += "                       and jbe_habili = jct_habili"
cQuery += "                       and jbe_codcur = jbo_codcur"
cQuery += "                       and jbe_perlet = jbo_perlet"
cQuery += "                       and jbe_habili = jbo_habili"
cQuery += "                       and jbe_turma  = jbo_turma )"
cQuery += " union "
cQuery += "select distinct"
cQuery += "       jct.r_e_c_n_o_ RECJCT,"
cQuery += "       jcs.r_e_c_n_o_ RECJCS,"
cQuery += "       jct_numreq,"
cQuery += "       ja2_numra,"
cQuery += "       jcs_curso,"
cQuery += "       jct_perlet,"
cQuery += "       jcs_habili,"
cQuery += "       jcs_serie"
cQuery += "  from " + RetSQLName("JBH") + " JBH, "
cQuery +=             RetSQLName("JCS") + " JCS, "
cQuery +=             RetSQLName("JCT") + " JCT, "
cQuery +=             RetSQLName("JA2") + " JA2 "
cQuery += " where jbh_filial = '" + xFilial("JBH") + "' and jbh.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_filial = '" + xFilial("JCS") + "' and jcs.d_e_l_e_t_ = ' '"
cQuery += "   and jct_filial = '" + xFilial("JCT") + "' and jct.d_e_l_e_t_ = ' '"
cQuery += "   and ja2_filial = '" + xFilial("JA2") + "' and ja2.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_numreq = jbh_num"
cQuery += "   and ja2_numra  = jbh_codide"
cQuery += "   and jct_numreq = jcs_numreq"
cQuery += "   and jbh_tipo   in ('000029', '000032', '000037')"
cQuery += "   and jbh_status = '1'"
cQuery += "   and jct_perlet < jcs_serie"
cQuery += "   and not exists ( select jbe_perlet"
cQuery += "                      from " + RetSQLName("JBE") + " JBE, "
cQuery +=                                 RetSQLName("JBO") + " JBO "
cQuery += "                     where jbe_filial = jct_filial and jbe.d_e_l_e_t_ = ' '"
cQuery += "                       and jbo_filial = jbe_filial and jbo.d_e_l_e_t_ = ' '"
cQuery += "                       and jbe_numra  = ja2_numra"
cQuery += "                       and jbe_codcur = jcs_curso"
cQuery += "                       and jbe_perlet = jct_perlet"
cQuery += "                       and jbe_habili = jct_habili"
cQuery += "                       and jbe_codcur = jbo_codcur"
cQuery += "                       and jbe_perlet = jbo_perlet"
cQuery += "                       and jbe_habili = jbo_habili"
cQuery += "                       and jbe_turma  = jbo_turma )"
cQuery += " order by jct_numreq, ja2_numra, jcs_curso, jct_perlet"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

JCS->( dbSetOrder(1) )
JCT->( dbSetOrder(1) )
JCO->( dbSetOrder(1) )
JBE->( dbSetOrder(1) )
JBL->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )

While QRY->(!Eof())

	JCT->( dbGoTo(QRY->RECJCT) )
	JCS->( dbGoTo(QRY->RECJCS) )
	
	if JBE->( !dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+JCS->JCS_SERIE ) )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Ignorando registro "+Alltrim(Str(QRY->RECJCT))+" da JCT pois nใo hแ JBE do perํodo letivo da transferencia como referencia." )
		QRY->( dbSkip() )
		Loop
	endif
	
	Begin Transaction

	if aScan( aJBE, QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET ) == 0
		aAdd( aJBE, QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET )
		
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Iniciando processamento do aluno "+QRY->JA2_NUMRA+", curso vigente "+JCS->JCS_CURSO+", periodo letivo "+JCT->JCT_PERLET+". Requerimento nบ "+JCT->JCT_NUMREQ )
		
		dDtMat	:= JBE->JBE_DTMATR
		cNumRA	:= QRY->JA2_NUMRA
		cSerie	:= JCT->JCT_PERLET
		cHabili := AcTrazHab(JCS->JCS_CURSO, cSerie, JCS->JCS_HABILI)
		cTurma	:= GetTurma(JCS->JCS_CURSO,cSerie,cHabili,JBE->JBE_TURMA)
		
		JAR->( dbSetOrder(1) )
		JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+cHabili ) )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o aluno no JBEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if JBE->( dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+cSerie+cHabili ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Turma incorreta '"+JBE->JBE_TURMA+"' ajustada para '"+cTurma+"'." )

			RecLock("JBE", .F.)
		else
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Gerado novo registro para o aluno na turma '"+cTurma+"'." )

			RecLock("JBE", .T.)
			JBE->JBE_FILIAL := xFilial("JBE")
			JBE->JBE_NUMRA  := cNumRA
			JBE->JBE_CODCUR := JCS->JCS_CURSO
			JBE->JBE_PERLET := cSerie
			JBE->JBE_HABILI := cHabili
			JBE->JBE_TIPO   := "1"  // Periodo Letivo Normal
			JBE->JBE_SITUAC := "2"  // 1=Pre-Matricula; 2=Matricula
			JBE->JBE_ATIVO  := "2"  // 1=Sim; 2=Nao
			JBE->JBE_TPTRAN := "002"	// Campo do script ref. ao Tipo de Transferencia
			JBE->JBE_KITMAT := "2"		// Pendente
			JBE->JBE_NUMREQ := JBH->JBH_NUM
			if lSeq
				JBE->JBE_SEQ    := ACSequence(cNumRA, JCS->JCS_CURSO, cSerie, cTurma, cHabili)
			endif
		endif
		
		JBE->JBE_TURMA  := cTurma
		JBE->JBE_DTMATR := dDtMat
		JBE->JBE_ANOLET := JAR->JAR_ANOLET
		JBE->JBE_PERIOD := JAR->JAR_PERIOD
		
		JBE->( MsUnLock() )
	else
		JBE->( dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET ) )
	endif

	if lSeq
		cSeq := ACSequence( cNumRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI, .F. )
	endif
	
	if JBL->( dbSeek(xFilial("JBL")+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP) )
		While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == xFilial("JBL")+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP )
			if JC7->( !dbSeek( xFilial("JC7")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JBL->( JBL_CODDIS+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL+JBL_DIASEM+JBL_HORA1 )+cSeq ) )
				RecLock("JC7", .T.)
				
				JC7->JC7_FILIAL := xFilial("JC7")
				JC7->JC7_NUMRA  := cNumRA
				JC7->JC7_CODCUR := JBE->JBE_CODCUR
				JC7->JC7_PERLET := JBE->JBE_PERLET
				JC7->JC7_HABILI := JBE->JBE_HABILI
				JC7->JC7_TURMA  := JBE->JBE_TURMA
				JC7->JC7_DISCIP := JCT->JCT_DISCIP
				JC7->JC7_SITDIS := JCT->JCT_SITUAC
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
				JC7->JC7_SITUAC := if(JCT->JCT_SITUAC $ "003/011", "8", If(JCT->JCT_SITUAC == "001","A","1"))   // 8 - Dispensado; 1 - Cursando; A - A cursar
				JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
				JC7->JC7_MEDCON := JCT->JCT_MEDCON
				JC7->JC7_CODINS := JCT->JCT_CODINS
				JC7->JC7_ANOINS := JCT->JCT_ANOINS
				if lSeq
					JC7->JC7_SEQ := cSeq
				endif
				JC7->( MsUnLock() )
			endif
			
			if JC7->JC7_SITUAC == "8"
				JCO->( dbSetOrder(1) )
				if JCO->( !dbSeek( xFilial("JCO")+JC7->( JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_DISCIP ) ) )
					RecLock("JCO", .T.)
					
					JCO->JCO_FILIAL := xFilial("JCO")
					JCO->JCO_NUMRA  := JC7->JC7_NUMRA
					JCO->JCO_CODCUR := JC7->JC7_CODCUR
					JCO->JCO_PERLET := JC7->JC7_PERLET
					JCO->JCO_HABILI := JC7->JC7_HABILI
					JCO->JCO_DISCIP := JC7->JC7_DISCIP
					JCO->JCO_MEDFIM := JC7->JC7_MEDFIM
					JCO->JCO_MEDCON := JC7->JC7_MEDCON
					JCO->JCO_CODINS := JC7->JC7_CODINS
					JCO->JCO_ANOINS := JC7->JC7_ANOINS
					
					if lJCOJust .and. lJCTJust
						cMemoJCT := JCT->( MSMM( JCT_MEMO1 ) )
						JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemoJCT,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
					endif
					
					JCO->( MsUnLock() )
				endif
			endif
			JBL->( dbSkip() )
		end
	elseif JCT->JCT_SITUAC $ "003/011"
		JCO->( dbSetOrder(1) )	// JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP
		if JCO->( !dbSeek( xFilial("JCO")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI )+JCT->JCT_DISCIP ) )
			RecLock("JCO", .T.)
			
			JCO->JCO_NUMRA  := cNumRA
			JCO->JCO_CODCUR := JBE->JBE_CODCUR
			JCO->JCO_PERLET := JBE->JBE_PERLET
			JCO->JCO_HABILI := JBE->JBE_HABILI
			JCO->JCO_DISCIP := JCT->JCT_DISCIP
			JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
			JCO->JCO_MEDCON := JCT->JCT_MEDCON
			JCO->JCO_CODINS := JCT->JCT_CODINS
			JCO->JCO_ANOINS := JCT->JCT_ANOINS
			
			if lJCOJust .and. lJCTJust
				cMemoJCT := JCT->( MSMM( JCT_MEMO1 ) )
				JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemoJCT,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
			endif
			JCO->( MsUnLock() )
		endif
	endif

	End Transaction

	QRY->( dbSkip() )
end

QRY->(dbCloseArea())
dbSelectArea("JA2")

Return

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106545   บAutor  ณ Rafael Rodrigues   บ Data ณ 05/Out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReorganiza os valores de JBE_SEQ e JC7_SEQ na base de dados บฑฑ
ฑฑบ			 ณque pode ter sido afetada pelos problemas na ACSequence     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106545()
FixWindow(106545, {|| F106545Go() } )
Return

Static Function F106545Go()
Local cQuery	:= ""
Local cAtivo	:= ""

if JBE->( FieldPos("JBE_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JBE_SEQ" )
	Return
elseif JC7->( FieldPos("JC7_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JC7_SEQ" )
	Return
endif

//
// 1a Parte - Reorganiza os SEQ para 001 de quem tem apenas 1 ocorrencia
//
cQuery := "select JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA"
cQuery += "  from "+RetSQLName("JBE")
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
cQuery += " group by JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA "
cQuery += "having count(*) = 1"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

JBE->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )

while QRY1->( !eof() )
	
	if JBE->( dbSeek( xFilial("JBE")+QRY1->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) ) )
		if JBE->JBE_SEQ <> "001"
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JBE->(Recno()),10)+" atualizado na JBE para o sequencial 001." )
			RecLock("JBE",.F.)
			JBE->JBE_SEQ := "001"
			JBE->( msUnlock() )
		endif
	
		cQuery := "select R_E_C_N_O_ REC"
		cQuery += "  from "+RetSQLName("JC7")
		cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
		cQuery += "   and JC7_NUMRA  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and JC7_CODCUR = '"+JBE->JBE_CODCUR+"'"
		cQuery += "   and JC7_PERLET = '"+JBE->JBE_PERLET+"'"
		cQuery += "   and JC7_HABILI = '"+JBE->JBE_HABILI+"'"
		cQuery += "   and JC7_TURMA  = '"+JBE->JBE_TURMA+"'"
		cQuery += "   and JC7_SEQ   <> '001'"
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	    
		while QRY2->( !eof() )
			JC7->( dbGoTo( QRY2->REC ) )

			cQuery := "select count(*) QUANT"
			cQuery += "  from "+RetSQLName("JC7")
			cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
			cQuery += "   and JC7_NUMRA  = '"+JC7->JC7_NUMRA+"'"
			cQuery += "   and JC7_CODCUR = '"+JC7->JC7_CODCUR+"'"
			cQuery += "   and JC7_PERLET = '"+JC7->JC7_PERLET+"'"
			cQuery += "   and JC7_HABILI = '"+JC7->JC7_HABILI+"'"
			cQuery += "   and JC7_TURMA  = '"+JC7->JC7_TURMA+"'"
			cQuery += "   and JC7_DISCIP = '"+JC7->JC7_DISCIP+"'"
			cQuery += "   and JC7_CODLOC = '"+JC7->JC7_CODLOC+"'"
			cQuery += "   and JC7_CODPRE = '"+JC7->JC7_CODPRE+"'"
			cQuery += "   and JC7_ANDAR  = '"+JC7->JC7_ANDAR+"'"
			cQuery += "   and JC7_CODSAL = '"+JC7->JC7_CODSAL+"'"
			cQuery += "   and JC7_DIASEM = '"+JC7->JC7_DIASEM+"'"
			cQuery += "   and JC7_HORA1  = '"+JC7->JC7_HORA1+"'"
			cQuery += "   and JC7_SEQ    = '001'"
	
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY3", .F., .F. )

			RecLock("JC7",.F.)
			if QRY3->( eof() .or. QRY3->QUANT == 0 )
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7 para o sequencial 001." )
				JC7->JC7_SEQ := "001"
			else
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7 para impedir duplicidade." )
				JC7->( dbDelete() )
			endif
			JC7->( msUnlock() )
			
			QRY3->( dbCloseArea() )
			dbSelectArea("JBE")

			QRY2->( dbSkip() )
		end
		QRY2->( dbCloseArea() )
		dbSelectArea("JBE")
	endif
	
	QRY1->( dbSkip() )
end
QRY1->( dbCloseArea() )
dbSelectArea("JBE")

//
// 2a Parte - Localiza JC7 com SEQ invalido (sem JBE correspondente) e busca o JBE_SEQ correto
//
cQuery := "select R_E_C_N_O_ REC"
cQuery += "  from "+RetSQLName("JC7")
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
cQuery += "   and not exists ( select JBE_SEQ"
cQuery += "                      from "+RetSQLName("JBE")
cQuery += "                     where JBE_FILIAL = JC7_FILIAL  and D_E_L_E_T_ = ' '"
cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
cQuery += "                       and JBE_PERLET = JC7_PERLET"
cQuery += "                       and JBE_HABILI = JC7_HABILI"
cQuery += "                       and JBE_TURMA  = JC7_TURMA"
cQuery += "                       and JBE_SEQ    = JC7_SEQ )"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

while QRY1->( !eof() )
	JC7->( dbGoTo( QRY1->REC ) )
	
	if JC7->JC7_SITUAC$"1234568A"
		cAtivo := "'1','2','5'"
	else
		cAtivo := "'3','4','6','7','8','9','A','B'"
	endif
	
	cQuery := "select JBE_SEQ"
	cQuery += "  from "+RetSQLName("JBE")
	cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
	cQuery += "   and JBE_NUMRA  = '"+JC7->JC7_NUMRA+"'"
	cQuery += "   and JBE_CODCUR = '"+JC7->JC7_CODCUR+"'"
	cQuery += "   and JBE_PERLET = '"+JC7->JC7_PERLET+"'"
	cQuery += "   and JBE_HABILI = '"+JC7->JC7_HABILI+"'"
	cQuery += "   and JBE_TURMA  = '"+JC7->JC7_TURMA+"'"
	cQuery += "   and JBE_ATIVO in ("+cAtivo+")"
	cQuery += "   and not exists ( select JC7_SEQ"
	cQuery += "                      from "+RetSQLName("JC7")
	cQuery += "                     where JC7_FILIAL = JBE_FILIAL and D_E_L_E_T_ = ' '"
	cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
	cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
	cQuery += "                       and JBE_PERLET = JC7_PERLET"
	cQuery += "                       and JBE_HABILI = JC7_HABILI"
	cQuery += "                       and JBE_TURMA  = JC7_TURMA"
	cQuery += "                       and JBE_SEQ    = JC7_SEQ"
	cQuery += "                       and JC7_DISCIP = '"+JC7->JC7_DISCIP+"'"
	cQuery += "                       and JC7_CODLOC = '"+JC7->JC7_CODLOC+"'"
	cQuery += "                       and JC7_CODPRE = '"+JC7->JC7_CODPRE+"'"
	cQuery += "                       and JC7_ANDAR  = '"+JC7->JC7_ANDAR+"'"
	cQuery += "                       and JC7_CODSAL = '"+JC7->JC7_CODSAL+"'"
	cQuery += "                       and JC7_DIASEM = '"+JC7->JC7_DIASEM+"'"
	cQuery += "                       and JC7_HORA1  = '"+JC7->JC7_HORA1+"' )"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	
	RecLock("JC7",.F.)
	if QRY2->( !eof() .and. !Empty(JBE_SEQ) )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7 para o sequencial "+QRY2->JBE_SEQ+"." )
		JC7->JC7_SEQ := QRY2->JBE_SEQ
	else
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7 para impedir duplicidade." )
		JC7->( dbDelete() )
	endif
	JC7->( msUnlock() )

	QRY2->( dbCloseArea() )
	dbSelectArea("JBE")
	
	QRY1->( dbSkip() )
end
QRY1->( dbCloseArea() )
dbSelectArea("JBE")
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix104992 บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_ATIVO dos alunos afetados pelo BOPS 93086   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx104992()
FixWindow( 104992, {|| F104992G() } )
Return

Static Function F104992G()
Local cQuery	:= ""
Local lMSSQL	:= "MSSQL"$Upper(TCGetDB())
Local lMySQL	:= "MYSQL"$Upper(TCGetDB())
Local cAlias1	:= GetNextAlias()
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local cCCusto1	:= ""
Local cCCusto2	:= ""

cQuery += "select jbe_numra, jbe_codcur, jbe_perlet, jbe_habili, jbe_turma, jbe_anolet, jbe_period, jbe_tipo, r_e_c_n_o_ rec"
cQuery += "  from "+RetSQLName("JBE")+" a"
cQuery += " where a.jbe_filial = '"+xFilial("JBE")+"' and a.d_e_l_e_t_ = ' '"
cQuery += "   and a.jbe_ativo  = '1'"
cQuery += "   and jbe_perlet = ( select max(jar_perlet)"
cQuery += "                        from "+RetSQLName("JAR")+" jar"
cQuery += "                       where jar_filial = a.jbe_filial and jar.d_e_l_e_t_ = ' '"
cQuery += "                         and jar_codcur = a.jbe_codcur )"
cQuery += "   and exists ( select jbe_numra"
cQuery += "                  from "+RetSQLName("JBE")+" b"
cQuery += "                 where b.jbe_filial = a.jbe_filial and b.d_e_l_e_t_ = ' '"
cQuery += "                   and b.jbe_numra  = a.jbe_numra"
cQuery += "                   and b.jbe_codcur = a.jbe_codcur"
cQuery += "                   and b.jbe_perlet < a.jbe_perlet )"
cQuery += "   and exists ( select jbe_numra"
cQuery += "                  from "+RetSQLName("JBE")+" c"
cQuery += "                 where c.jbe_filial = a.jbe_filial and c.d_e_l_e_t_ = ' '"
cQuery += "                   and c.jbe_numra  = a.jbe_numra"
cQuery += "                   and c.jbe_codcur <> a.jbe_codcur"
cQuery += "                   and c.jbe_perlet = a.jbe_perlet"
cQuery += "                   and c.jbe_ativo  = '1'"
if lMSSQL
	cQuery += "                   and c.jbe_anolet+c.jbe_period > a.jbe_anolet+a.jbe_period )"
elseif lMySQL
	cQuery += "                   and Concat(c.jbe_anolet, c.jbe_period) > Concat(a.jbe_anolet, a.jbe_period) )"
else
	cQuery += "                   and c.jbe_anolet||c.jbe_period > a.jbe_anolet||a.jbe_period )"
endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )

while (cAlias1)->( !eof() )
	cQuery := "select r_e_c_n_o_ rec"
	cQuery += "  from "+RetSQLName("JBE")
	cQuery += " where jbe_filial = '"+xFilial("JBE")+"' and d_e_l_e_t_ = ' '"
	cQuery += "   and jbe_ativo  = '1'"
	cQuery += "   and jbe_numra  = '"+(cAlias1)->JBE_NUMRA+"'"
	cQuery += "   and jbe_codcur <> '"+(cAlias1)->JBE_CODCUR+"'"
	if lMSSQL
		cQuery += "   and jbe_anolet+jbe_period > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	elseif lMySQL
		cQuery += "   and Concat(jbe_anolet,jbe_period) > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	else
		cQuery += "   and jbe_anolet||jbe_period > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	endif
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias2, .F., .F. )
	
	if (cAlias2)->( !eof() )
		JBE->( dbGoTo( (cAlias2)->REC ) )
	
		(cAlias2)->( dbCloseArea() )
		dbSelectArea("JA2")
		
		AcaLog( cLogFile, "[Registro JBE "+Alltrim(Str(JBE->(Recno())))+"]"+" : Aluno "+Alltrim((cAlias1)->JBE_NUMRA)+" ("+Alltrim(Posicione("JA2",1,xFilial("JA2")+(cAlias1)->JBE_NUMRA,"JA2_NOME"))+") " )
		AcaLog( cLogFile, "  - Ano/semestre   : "+JBE->( JBE_ANOLET+"/"+JBE_PERIOD ) )
		AcaLog( cLogFile, "  - Curso indevido : "+JBE->( JBE_CODCUR+"/"+JBE_PERLET+"/"+JBE_TURMA+" - "+Alltrim(Posicione("JAH",1,xFilial("JAH")+JBE_CODCUR,"JAH_DESC")) ) )
		AcaLog( cLogFile, "  - Curso correto  : "+(cAlias1)->( JBE_CODCUR+"/"+JBE_PERLET+"/"+JBE_TURMA+" - "+Alltrim(Posicione("JAH",1,xFilial("JAH")+JBE_CODCUR,"JAH_DESC")) ) )
		
		cQuery := "select r_e_c_n_o_ rec"
		cQuery += "  from "+RetSQLName("JC7")
		cQuery += " where jc7_filial = '"+xFilial("JC7")+"' and d_e_l_e_t_ = ' '"
		cQuery += "   and jc7_numra  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and jc7_codcur = '"+JBE->JBE_CODCUR+"'"
		cQuery += "   and jc7_perlet = '"+JBE->JBE_PERLET+"'"
		cQuery += "   and jc7_habili = '"+JBE->JBE_HABILI+"'"
		cQuery += "   and jc7_turma  = '"+JBE->JBE_TURMA+"'"
	
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias2, .F., .F. )
		
		AcaLog( cLogFile, "  - Disciplinas movidas:" )
		if (cAlias2)->( !eof() )
			while (cAlias2)->( !eof() )
				JC7->( dbGoTo( (cAlias2)->REC ) )
				if !Empty( JC7->JC7_OUTCUR )
					if JC7->JC7_SITDIS == "001"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Adapta็ใo (mantida)" )
					elseif JC7->JC7_SITDIS == "002"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Depend๊ncia (mantida)" )
					elseif JC7->JC7_SITDIS == "006"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Tutoria (mantida)" )
					elseif JC7->JC7_SITDIS == "010"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Regular (alterada para Depend๊ncia)" )
					else
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Outra situa็ใo (mantida)" )
					endif

					RecLock("JC7",.F.)
					JC7->JC7_CODCUR	:= (cAlias1)->JBE_CODCUR
					JC7->JC7_PERLET	:= (cAlias1)->JBE_PERLET
					JC7->JC7_HABILI	:= (cAlias1)->JBE_HABILI
					JC7->JC7_TURMA	:= (cAlias1)->JBE_TURMA
					if JC7->JC7_SITDIS == "010"
						JC7->JC7_SITDIS	:= "002"
					endif
					JC7->JC7_SEQ	:= "002"
					JC7->( msUnlock() )
				else
					AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Regular (mantida)" )
					
					RecLock("JC7",.F.)
					JC7->JC7_OUTCUR	:= JC7->JC7_CODCUR
					JC7->JC7_OUTPER	:= JC7->JC7_PERLET
					JC7->JC7_OUTHAB	:= JC7->JC7_HABILI
					JC7->JC7_OUTTUR	:= JC7->JC7_TURMA
					JC7->JC7_CODCUR	:= (cAlias1)->JBE_CODCUR
					JC7->JC7_PERLET	:= (cAlias1)->JBE_PERLET
					JC7->JC7_HABILI	:= (cAlias1)->JBE_HABILI
					JC7->JC7_TURMA	:= (cAlias1)->JBE_TURMA
					JC7->JC7_SEQ	:= "002"
					JC7->( msUnlock() )
				endif
				(cAlias2)->( dbSkip() )
			end
		else
			AcaLog( cLogFile, "    Nenhuma disciplina vinculada a esta matricula" )
		endif	
		
		cQuery := "select r_e_c_n_o_ rec"
		cQuery += "  from "+RetSQLName("SE1")
		cQuery += " where e1_filial = '"+xFilial("SE1")+"' and d_e_l_e_t_ = ' '"
		cQuery += "   and e1_numra  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and e1_nrdoc like '"+JBE->(JBE_CODCUR+JBE_PERLET)+"%'"
	
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias3, .F., .F. )

		AcaLog( cLogFile, "  - Tํtulos movidos:" )
		if (cAlias3)->( !eof() )
			while (cAlias3)->( !eof() )
				SE1->( dbGoTo( (cAlias3)->REC ) )
				AcaLog( cLogFile, "    [Registro SE1 "+Alltrim(Str(SE1->(Recno())))+"] : "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO )
				RecLock("SE1",.F.)
				SE1->E1_NRDOC	:= (cAlias1)->( JBE_CODCUR+JBE_PERLET )+Subs( SE1->E1_NRDOC, 9 )
				SE1->( msUnlock() )
				
				(cAlias3)->( dbSkip() )
			end
		else
			AcaLog( cLogFile, "    Nenhum tํtulo vinculado a esta matricula" )
		endif
		
		(cAlias3)->( dbCloseArea() )
		dbSelectArea("JA2")
		
		RecLock("JBE",.F.)
		JBE->JBE_CODCUR	:= (cAlias1)->JBE_CODCUR
		JBE->JBE_PERLET	:= (cAlias1)->JBE_PERLET
		JBE->JBE_TIPO	:= "2"
		JBE->JBE_SEQ	:= "002"
		JBE->( msUnlock() )
		
		// Desativa o periodo letivo anterior do curso correto
		JBE->( dbGoTo( (cAlias1)->REC ) )
		RecLock("JBE",.F.)
		JBE->JBE_ATIVO	:= "2"
		JBE->( msUnlock() )
		
		cCCusto1 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+(cAlias1)->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO, "JAF_CCUSTO")
		cCCusto2 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO, "JAF_CCUSTO")
		if cCCusto1 <> cCCusto2
			AcaLog( cLogFile, "" )
			AcaLog( cLogFile, "  * Aten็ใo! O centro de custo do curso anterior ("+cCCusto1+") ้ diferente do centro de custo do curso atual do aluno ("+cCCusto2+"). ษ necessแrio rever os lan็amentos contแbeis deste aluno." )
		endif
		
		AcaLog( cLogFile, "" )
	endif

	(cAlias2)->( dbCloseArea() )
	dbSelectArea("JA2")
	
	(cAlias1)->( dbSkip() )
end

(cAlias1)->( dbCloseArea() )
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix111440 บAutor  ณViviane Miam        บ Data ณ 20/out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpar o valor dos campos JAV_CHAMAD, JAV_PROCES, JAV_POSICAบฑฑ
ฑฑบ          ณpara realiza็ใo do processamento de chamada que estava      บฑฑ
ฑฑบ          ณincorreto.												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111440()
FixWindow( 111440, {|| F111440G() } )
Return

Static Function F111440G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()       
Local cAlias1	:= GetNextAlias()
Local aArea		:= GetArea()

cQuery += "select JAV_CODCAN, JAV_CODPRO, JAV_CODFAS, JAV_CODCUR"
cQuery += "  from "+RetSQLName("JAV")
cQuery += " where JAV_FILIAL = '"+xFilial("JAV")+"'
cQuery += "   and JAV_STATUS = '09'"
cQuery += "   and D_E_L_E_T_ = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

Begin Transaction
JAV->(dbSetOrder(1))

While (cAlias)->(!Eof())
	cTexto := ""
	cTexto := "******* ALUNO " + (cAlias)->JAV_CODCAN + Chr(13)+Chr(10)
	cTexto := "******* PROCESSO SELETIVO " + (cAlias)->JAV_CODPRO + Chr(13)+Chr(10)	
	cTexto := "******* FASE " + (cAlias)->JAV_CODFAS + Chr(13)+Chr(10)
	cTexto := "******* CURSO " + (cAlias)->JAV_CODCUR + Chr(13)+Chr(10)	
	
	If JAV->(dbSeek(xFilial("JAV")+(cAlias)->(JAV_CODCAN+JAV_CODPRO+JAV_CODFAS+JAV_CODCUR)))
		RecLock("JAV", .F.)
	
		JAV->JAV_CHAMAD := ''
		JAV->JAV_PROCES := ''
		JAV->JAV_POSICA := 0.0
		
		JAV->(MsUnlock())
	Endif
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())
      
cQuery := ""
//ATUALIZA A QUANTIDADE DE VAGASselect COUNT(JAV_CODCAN) PRE, JAV_CODPRO, JAV_CODCUR 
cQuery += " select COUNT(JAV_CODCAN) PRE, JAV_CODPRO, JAV_CODCUR "
cQuery += " from "+RetSQLName("JAV")+ " A "
cQuery += " where JAV_FILIAL = ' ' and D_E_L_E_T_ = ' ' "
cQuery += "   and JAV_STATUS = '01' "
cQuery += "   and JAV_CHAMAD <> ' ' "
cQuery += "   and JAV_CODCAN not in ( select JAV_CODCAN "
cQuery += "                             from "+RetSQLName("JAV")+ " B "
cQuery += "                            where B.R_E_C_N_O_ = A.R_E_C_N_O_ "
cQuery += "                              and EXISTS ( SELECT JA2_CODINS "
cQuery += "                                             FROM "+RetSQLName("JA2")
cQuery += "                                            WHERE JA2_CODINS = B.JAV_CODCAN "
cQuery += "                                              AND D_E_L_E_T_ = '*') "
cQuery += "                              and NOT EXISTS ( SELECT JA2_CODINS  "
cQuery += "                                                 FROM "+RetSQLName("JA2")
cQuery += "                                                WHERE JA2_CODINS = B.JAV_CODCAN "
cQuery += "                                                  AND D_E_L_E_T_ = ' ') ) "
cQuery += " GROUP BY JAV_CODPRO, JAV_CODCUR "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )
dbSelectArea("JA7")
dbSetOrder(1)

While (cAlias1)->(!Eof())
	If JA7->( dbSeek( xFilial("JA7") + (cAlias1)->JAV_CODPRO + (cAlias1)->JAV_CODCUR ) )
		RecLock( "JA7", .F. )
		JA7->JA7_VAGPRE := (cAlias1)->PRE
		JA7->JA7_VAGLIV := JA7->JA7_NUMVAG - JA7->JA7_VAGPRE
		JA7->( MsUnlock() )
	Endif               
	(cAlias1)->(dbSkip())	
End

End Transaction

DbSelectArea("JA7")
RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111845  บAutor  ณRafael Rodrigues    บ Data ณ 23/Out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_TIPO dos alunos afetados pelo BOPS 111845   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111845()
FixWindow( 111845, {|| F111845G() } )
Return

Static Function F111845G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += "select jbe_numra, jbe_codcur, jbe_perlet, jbe_habili, jbe_turma, jar_dpmax"
cQuery += "  from "+RetSQLName("JBE")+" jbe, "
cQuery +=           RetSQLName("JAR")+" jar "
cQuery += " where jbe_filial = '"+xFilial("JBE")+"' and jbe.d_e_l_e_t_ = ' '"
cQuery += "   and jar_filial = '"+xFilial("JAR")+"' and jar.d_e_l_e_t_ = ' '"
cQuery += "   and jbe_tipo   = '2'"
cQuery += "   and jbe_codcur = jar_codcur"
cQuery += "   and jbe_perlet = jar_perlet"
cQuery += "   and jbe_habili = jar_habili"
cQuery += "   and jbe_anolet = jar_anolet"
cQuery += "   and jbe_period = jar_period"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" alunos..." )
	
	(cAlias)->( ACBloqAlu( JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JAR_DPMAX, JBE_PERLET, JBE_HABILI ) )

	AcaLog( cLogFile, "  Aluno "+(cAlias)->JBE_NUMRA+" regulazirado." )
	(cAlias)->( dbSkip() )
end

(cAlias)->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx114547  บAutor  ณViviane Miam        บ Data ณ 01/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEstorno dos boletos de matrํcula gerados sem desconto, devi-บฑฑ
ฑฑบ          ณdo filtro incorreto no ACAA680.PRW                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx114547()
FixWindow( 114547, {|| F114547G() } )
Return

Static Function F114547G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += "select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
cQuery += "  from "+RetSQLName("SE1")+" E1 "
cQuery += " where E1_FILIAL = '"+xFilial("SE1")+"' and E1.D_E_L_E_T_ = ' '"
cQuery += "   and (E1_PREFIXO = 'MAT' or E1_PREFIXO = 'MES')"
cQuery += "   and E1_VENCTO = '20070117'"
cQuery += "   and E1_DESCON1 = '0.0'"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

Begin Transaction
SE1->(dbSetOrder(1))

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" titulos..." )
	
	If SE1->(dbSeek(xFilial("SE1")+(cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		SE1->(RecLock("SE1",.F.))
		SE1->(dbDelete())
		SE1->(MsUnLock())
	Endif

	AcaLog( cLogFile, "  Titulo "+(cAlias)->E1_PREFIXO + (cAlias)->E1_NUM + " Parcela: " + (cAlias)->E1_PARCELA + " Tipo: " + (cAlias)->E1_TIPO + " regulazirado." )
	(cAlias)->( dbSkip() )
end

End Transaction
(cAlias)->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx115512  บAutor  ณViviane Miam        บ Data ณ 11/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณO sistema estava deixando mais de um curso ativo.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx115512()
FixWindow( 115512, {|| F115512G() } )
Return

Static Function F115512G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += " SELECT DISTINCT JAF1.JAF_COD, JAF1.JAF_VERSAO "
cQuery += " FROM "+RetSQLName("JAF")+" JAF1 "
cQuery += " WHERE JAF1.JAF_ATIVO = '1' "
cQuery += " AND JAF1.D_E_L_E_T_ = '' "
cQuery += " AND JAF1.JAF_FILIAL = '"+xFilial("JAF")+"' "
cQuery += " AND JAF1.JAF_VERSAO NOT IN ( SELECT MAX(JAF2.JAF_VERSAO) "
cQuery += "			   FROM "+RetSQLName("JAF")+" JAF2 "
cQuery += "			WHERE JAF2.JAF_COD = JAF1.JAF_COD "
cQuery += "			AND JAF2.JAF_ATIVO = '1' "
cQuery += "			AND JAF2.D_E_L_E_T_ = '' "   
cQuery += " 		AND JAF2.JAF_FILIAL = '"+xFilial("JAF")+"' "
cQuery += "			GROUP BY JAF2.JAF_COD) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

Begin Transaction
JAF->(dbSetOrder(1))

while (cAlias)->( !eof() )
	
	If JAF->(dbSeek(xFilial("JAF")+(cAlias)->(JAF_COD+JAF_VERSAO)))
		JAF->(RecLock("JAF",.F.))
		JAF->JAF_ATIVO := '2' //Desativa os cursos com vers๕es anteriores
		JAF->(MsUnLock())
	Endif

	AcaLog( cLogFile, "   Curso: "+(cAlias)->JAF_COD + " Versao: " + (cAlias)->JAF_VERSAO + " regularizado." )
	(cAlias)->( dbSkip() )
end

End Transaction
(cAlias)->( dbCloseArea() )
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116173  บAutor  ณViviane Miam      บ Data ณ 11/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo na JCX e JCY para rodar lote novamente.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116173()
FixWindow( 116173, {|| F116173G() } )
Return

Static Function F116173G()
Local cQuery	:= ""
Local cQuery1	:= ""
Local cAlias	:= GetNextAlias()
Local cAlias1	:= GetNextAlias()
Local nCount	:= 0
                  
if SIX->( !dbSeek("JCY3") )
	RecLock("SIX",.T.)
	SIX->INDICE := "JCY3"
	SIX->ORDEM     := "3"
	SIX->CHAVE     := "JCY_FILIAL+JCY_MATPRF+JCY_LOTE+JCY_CODCUR+JCY_PERLET+JCY_HABILI+JCY_TURMA+JCY_CODDIS"
	SIX->DESCRICAO := ""
	SIX->DESCSPA   := ""
	SIX->DESCENG   := ""
	SIX->PROPRI    := "S"
	SIX->F3        := ""
	SIX->NICKNAME  := ""
	SIX->SHOWPESQ  := "S"	
	SIX->( msUnlock() )
endif
cQuery := " SELECT JCX.JCX_FILIAL, JCX.JCX_CODCUR, JCX.JCX_PERLET, JCX.JCX_HABILI, JCX.JCX_TURMA, JCX.JCX_CODDIS, "
cQuery += " JCX.JCX_CODAVA, JCX.JCX_NUMRA, JCX.JCX_MATPRF, JCX.JCX_LOTE "
cQuery += " FROM "+RetSQLName("JCX")+" JCX "
cQuery += " WHERE JCX.JCX_CODATI = 'SU' "
cQuery += " AND JCX.D_E_L_E_T_ = ' ' "
cQuery += " AND JCX.JCX_FILIAL = '"+xFilial("JCX")+"' "
cQuery += "	ORDER BY JCX.JCX_LOTE "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )
dbSelectArea("JCY")
JCY->(dbSetOrder(3))
dbSelectArea("JCX")
JCX->(dbSetOrder(1))
dbSelectArea("JBS")
JBS->(dbSetOrder(1))
Begin Transaction

while (cAlias)->( !eof() )                               
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" registros..." )
	if JCX->(dbSeek(xFilial("JCX")+(cAlias)->(JCX_MATPRF+JCX_LOTE+JCX_CODCUR+JCX_PERLET+JCX_HABILI+JCX_TURMA+JCX_CODDIS+JCX_CODAVA+JCX_NUMRA)))
		JCX->(RecLock("JCX",.F.))
		JCX->JCX_CONF := ' '
		JCX->JCX_DATCOF := CtoD("  /  /  ")
		JCX->JCX_CODATI := '  '
		JCX->(MsUnLock())
		
		cQuery1 := " SELECT JCY.JCY_FILIAL, JCY.JCY_CODCUR, JCY.JCY_PERLET, JCY.JCY_HABILI, JCY.JCY_TURMA, JCY.JCY_CODDIS, "
		cQuery1 += " JCY.JCY_MATPRF, JCY.JCY_LOTE "
		cQuery1 += " FROM "+RetSQLName("JCY")+" JCY "
		cQuery1 += " WHERE JCY.D_E_L_E_T_ = ' ' "
		cQuery1 += " AND JCY.JCY_FILIAL = '"+xFilial("JCY")+"' "
		cQuery1 += " AND JCY.JCY_MATPRF = '"+(cAlias)->(JCX_MATPRF)+"' "			
		cQuery1 += " AND JCY.JCY_LOTE = '"+(cAlias)->(JCX_LOTE)+"' "			
		cQuery1 += " AND JCY.JCY_CODCUR = '"+(cAlias)->(JCX_CODCUR)+"' "			
		cQuery1 += " AND JCY.JCY_PERLET = '"+(cAlias)->(JCX_PERLET)+"' "			
		cQuery1 += " AND JCY.JCY_TURMA = '"+(cAlias)->(JCX_TURMA)+"' "												
		cQuery1 += " AND JCY.JCY_HABILI = '"+(cAlias)->(JCX_HABILI)+"' "												
		cQuery1 += " AND JCY.JCY_CODDIS = '"+(cAlias)->(JCX_CODDIS)+"' "												
		cQuery1 := ChangeQuery( cQuery1 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )

		(cAlias1)->( dbEval( {|| nCount++ } ) )
		(cAlias1)->( dbGoTop() )
		if JCY->(dbSeek(xFilial("JCY")+(cAlias1)->(JCY_MATPRF+JCY_LOTE+JCY_CODCUR+JCY_PERLET+JCY_HABILI+JCY_TURMA+JCY_CODDIS)))
			JCY->(RecLock("JCY",.F.))
			JCY->JCY_CONF := '1'
			JCY->(MsUnLock())
		Endif
		(cAlias1)->( dbCloseArea() )
		AcaLog( cLogFile, "   Filial: "+xFilial("JCX")+"   Curso: "+(cAlias)->JCX_CODCUR + " Periodo: " + (cAlias)->JCX_PERLET+ " Habilitacao: " + (cAlias)->JCX_HABILI+ " Turma: " + (cAlias)->JCX_TURMA+" Disciplina: " + (cAlias)->JCX_CODDIS+" Avaliacao: " + (cAlias)->JCX_CODAVA+" RA: " + (cAlias)->JCX_NUMRA+" regularizado." )
	Endif
	(cAlias)->( dbSkip() )
end

(cAlias)->( dbCloseArea() )

dbSelectArea("JA2")

End Transaction
                          
SIX->( dbSetOrder(1) )
if SIX->( dbSeek("JCY3") )
	if Select("JCY") > 0
		JCY->( dbCloseArea() )
	endif
	if ChkFile("JCY",.T.)
		RecLock("SIX",.F.)
		SIX->( dbDelete() )		
		SIX->( msUnlock() )
		// FECHA A TABELA PARA MANIPULAR O INDICE
		if Select("JCY") > 0
			JCY->( dbCloseArea() )
		endif
		// APAGA O INDICE NO DATABASE
		TcSqlExec( "DROP INDEX "+RetSqlName("JCY")+"."+RetSQLName("JCY")+"3" )
	Endif
endif                  

dbSelectArea("JA2")
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116458  บAutor  ณEduardo de Souza    บ Data ณ 21/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza o recalculo da media, para disciplinas com avalicao บฑฑ
ฑฑบ          ณpor atividades com sub-turma                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116458()
FixWindow( 116458, {|| F116458G() } )
Return

Static Function F116458G()
Local cQuery	:= ""
Local aMedia	:= {}
Local aAlunos	:= {}
Local nCount	:= 0
Local i, j		:= 0
Local nTotal	:= 0
Local lSubTurma  := JBR->( FieldPos( "JBR_SUBTUR" ) ) > 0

/*ESTRUTURA ARRAY aMEDIA
[n, 1] = Curso Vigente
[n, 2] = Periodo Letivo
[n, 3] = Habilitacao
[n, 4] = Turma
[n, 5] = Disciplina
[n, 6] = aAlunos
[n, 7] = Tipo de Avaliacao
--------------------------------
ESTRUTURA ARRAY aALUNOS
[n, 1] = RA
[n, 2] = Cursa em Outra Turma? (1=Sim/2=Nao)*/

cQuery := "SELECT DISTINCT JC7_FILIAL, JC7_NUMRA, JBE_CODCUR, JC7_PERLET, JC7_HABILI, "
cQuery += " JC7_TURMA, JC7_OUTCUR,  JC7_OUTPER, JC7_OUTTUR, JC7_OUTHAB, JBL_SUBTUR, JC7_DISCIP, JBQ_TIPO, JC7_CODPRF, JBQ_CODAVA "

cQuery += " FROM " + RetSQLName("JBK") + " JBK, " + RetSQLName("JBL") + " JBL, " + RetSQLName("JAR") + " JAR, "
cQuery += RetSQLName("JC7") + " JC7, " + RetSQLName("JBQ") + " JBQ, " + RetSQLName("JBE") + " JBE "

cQuery += " WHERE JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JBK_FILIAL = JBE_FILIAL "
cQuery += " AND JBL_FILIAL = JBE_FILIAL "
cQuery += " AND JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JC7_FILIAL = JBE_FILIAL "
cQuery += " AND JBQ_FILIAL = JBE_FILIAL "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "

cQuery += " AND JBK_CODCUR = JAR_CODCUR "
cQuery += " AND JBK_PERLET = JAR_PERLET "
cQuery += " AND JBK_HABILI = JAR_HABILI "

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JC7_CODCUR = JBL_CODCUR "
cQuery += " AND JC7_PERLET = JBL_PERLET "
cQuery += " AND JC7_HABILI = JBL_HABILI "
cQuery += " AND JC7_TURMA  = JBL_TURMA "
cQuery += " AND JC7_SUBTUR = JBL_SUBTUR "
cQuery += " AND JC7_DISCIP = JBL_CODDIS "

cQuery += " AND JBQ_CODCUR = JAR_CODCUR "
cQuery += " AND JBQ_PERLET = JAR_PERLET "
cQuery += " AND JBQ_HABILI = JAR_HABILI "

cQuery += " AND JBE_NUMRA = JC7_NUMRA "
cQuery += " AND JBE_CODCUR = JC7_CODCUR "
cQuery += " AND JBE_PERLET = JC7_PERLET "
cQuery += " AND JBE_HABILI = JC7_HABILI "
cQuery += " AND JBE_TURMA  = JC7_TURMA "
cQuery += " AND JBE_ANOLET = JAR_ANOLET "
cQuery += " AND JBE_PERIOD = JAR_PERIOD "

cQuery += " AND JBL_SUBTUR <> '  ' " //SubTurma nao pode estar em branco
cQuery += " AND JBK_ATIVO = '1' " //Grade de aulas deve estar ativa.
cQuery += " AND JC7_SITDIS IN ('001', '002', '010') " //Adaptacao, Dependencia, Tutoria
//cQuery += " AND JBQ_ATIVID = '1' " //Apontamento da avaliacao deve ser por atividades
cQuery += " AND JAR_ANOLET = '2007' " //Somente ano 2006
cQuery += " AND JAR_PERIOD = '01' "  //Somente 2 periodo
cQuery += " AND JBE_ATIVO = '1' "	//Alunos ativos
cQuery += " AND JBE_SITUAC = '2' "	//Alunos matriculados

cQuery += " AND JAR.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBQ.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "      
                                             
cQuery += "UNION  "

cQuery += "SELECT DISTINCT JC7_FILIAL, JC7_NUMRA, JBE_CODCUR, JC7_PERLET, JC7_HABILI, "
cQuery += " JC7_TURMA, JC7_OUTCUR, JC7_OUTPER, JC7_OUTTUR, JC7_OUTHAB, JBL_SUBTUR, JC7_DISCIP, JBQ_TIPO, JC7_CODPRF, JBQ_CODAVA "

cQuery += " FROM " + RetSQLName("JBK") + " JBK, " + RetSQLName("JBL") + " JBL, " + RetSQLName("JAR") + " JAR, "
cQuery += RetSQLName("JC7") + " JC7, " + RetSQLName("JBQ") + " JBQ, " + RetSQLName("JBE") + " JBE "

cQuery += " WHERE JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JBK_FILIAL = JBE_FILIAL "
cQuery += " AND JBL_FILIAL = JBE_FILIAL "
cQuery += " AND JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JC7_FILIAL = JBE_FILIAL "
cQuery += " AND JBQ_FILIAL = JBE_FILIAL "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "

cQuery += " AND JBK_CODCUR = JAR_CODCUR "
cQuery += " AND JBK_PERLET = JAR_PERLET "
cQuery += " AND JBK_HABILI = JAR_HABILI "

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JC7_OUTCUR = JBL_CODCUR "
cQuery += " AND JC7_OUTPER = JBL_PERLET "
cQuery += " AND JC7_OUTHAB = JBL_HABILI "
cQuery += " AND JC7_OUTTUR  = JBL_TURMA "
cQuery += " AND JC7_SUBTUR = JBL_SUBTUR "
cQuery += " AND JC7_DISCIP = JBL_CODDIS "

cQuery += " AND JBQ_CODCUR = JAR_CODCUR "
cQuery += " AND JBQ_PERLET = JAR_PERLET "
cQuery += " AND JBQ_HABILI = JAR_HABILI "

cQuery += " AND JBE_NUMRA = JC7_NUMRA "
cQuery += " AND JBE_CODCUR = JC7_CODCUR "
cQuery += " AND JBE_PERLET = JC7_PERLET "
cQuery += " AND JBE_HABILI = JC7_HABILI "
cQuery += " AND JBE_TURMA  = JC7_TURMA "
cQuery += " AND JBE_ANOLET = JAR_ANOLET "
cQuery += " AND JBE_PERIOD = JAR_PERIOD "

cQuery += " AND JBL_SUBTUR <> '  ' " //SubTurma nao pode estar em branco
cQuery += " AND JBK_ATIVO = '1' " //Grade de aulas deve estar ativa.
cQuery += " AND JC7_SITDIS IN ('001', '002', '010') " //Adaptacao, Dependencia, Tutoria
//cQuery += " AND JBQ_ATIVID = '1' " //Apontamento da avaliacao deve ser por atividades
cQuery += " AND JAR_ANOLET = '2007' " //Somente ano 2006
cQuery += " AND JAR_PERIOD = '01' "  //Somente 2 periodo
cQuery += " AND JBE_ATIVO = '1' "	//Alunos ativos
cQuery += " AND JBE_SITUAC = '2' "	//Alunos matriculados

cQuery += " AND JAR.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBQ.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "

cQuery += " ORDER BY JBE_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_NUMRA"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYNOTA", .F., .F. )

QRYNOTA->( dbEval( {|| nCount++ } ) )
QRYNOTA->( dbGoTop() )

ProcRegua( nCount )

While QRYNOTA->(!Eof())
	IncProc( "Verificando registros "+ Alltrim(Str(nCount--)) )
	//Verifica se o curso+perlet+habili+turma+discip ja estao no array
	If aScan( aMedia, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == QRYNOTA->(JBE_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP)})  == 0
		//Mudou a chave; deve entao adicionar os alunos pertencentes a disciplina
		If Len(aMedia) > 0 //Primeira inclusao; ignora pois nao possui o array estruturado
			aMedia[Len(aMedia), 6] := aAlunos
		Endif
		aAdd(aMedia, { QRYNOTA->JBE_CODCUR, QRYNOTA->JC7_PERLET, QRYNOTA->JC7_HABILI, QRYNOTA->JC7_TURMA, QRYNOTA->JC7_DISCIP, ,  QRYNOTA->JBQ_TIPO, QRYNOTA->JC7_NUMRA, QRYNOTA->JC7_OUTCUR, QRYNOTA->JC7_OUTPER, QRYNOTA->JC7_OUTTUR, QRYNOTA->JC7_OUTHAB, QRYNOTA->JC7_CODPRF,QRYNOTA->JBQ_CODAVA,QRYNOTA->JBL_SUBTUR   })
		aAlunos := {}
	Endif
	//Adiciona o aluno (se cursa em outra turma, "1"; senao, "2")
	aAdd( aAlunos, {QRYNOTA->JC7_NUMRA, Iif(Empty(QRYNOTA->JC7_OUTCUR), "2", "1")} )
	QRYNOTA->(DbSkip())
End
//Para a ultima linha matricial adiciona o array alunos
If Len(aMedia) > 0 //Primeira inclusao; ignora pois nao possui o array estruturado
	aMedia[Len(aMedia), 6] := aAlunos
Endif
QRYNOTA->(DbCloseArea())

ProcRegua( Len(aMedia) )

If Len(aMedia) > 0
	AcaLog (cLogFile, "RELACAO DE CURSOS QUE REALIZARAO RECALCULO DE MEDIA ")
Else
	AcaLog(cLogFile, " ** PARA ESTA EMPRESA/FILIAL NAO HA REGISTROS PARA SEREM PROCESSADOS")
Endif	

For i := 1 To Len(aMedia)
	IncProc( "Realizando calculo da m้dia..." )
	AcaLog(cLogFile, "CODCUR: " + aMedia[i, 1] + " - PERLET: " + aMedia[i, 2] + " - HABILI: " + aMedia[i, 3] + " - TURMA: " + aMedia[i, 4] + " - DISCIP.: " + aMedia[i, 5])

    If !Empty(aMedia[i, 9])  
       	AcaLanJBS( aMedia[i, 9], aMedia[i, 10], aMedia[i, 11], aMedia[i, 5], aMedia[i, 14], aMedia[i, 13], aMedia[i, 8], aMedia[i, 9], aMedia[i, 3], If( lSubTurma,aMedia[i, 15], "" ) )
    
    	AcaCalcMedia(aMedia[i, 9], aMedia[i, 10], aMedia[i, 12], aMedia[i, 11], aMedia[i, 5], aMedia[i, 6], "")
    Else
    	AcaLanJBS( aMedia[i, 1], aMedia[i, 2], aMedia[i, 4], aMedia[i, 5], aMedia[i, 11], aMedia[i, 10], aMedia[i, 8], aMedia[i, 9], aMedia[i, 3], If( lSubTurma,aMedia[i, 15], "" ) )
       
    	AcaCalcMedia(aMedia[i, 1], aMedia[i, 2], aMedia[i, 3], aMedia[i, 4], aMedia[i, 5], aMedia[i, 6], "")
    EndIf
    
	AcaLog(cLogFile, "		ALUNOS NESTA DISCIPLINA: ")
	For j := 1 To Len(aMedia[i, 6])
		AcaLog(cLogFile, "		" + aMedia[i,6,j,1]) //RA
		nTotal++
	Next j
	
	AcaLog(cLogFile, "		TOTAIS DE ALUNOS NESTA DISCIPLINA: " + Alltrim(STR(Len(aMedia[i, 6]))))
	AcaLog(cLogFile, "")
Next i

If nTotal > 0
	AcaLog(cLogFile, "")
	AcaLog(cLogFile, "** TOTAL GERAL DE REGISTROS PROCESSADOS PARA A EMPRESA/FILIAL: " + Alltrim(STR(nTotal)))	
Endif		

AcaLog(cLogFile, "******************************************************************")
Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116398  บAutor  ณAlberto Deviciente  บ Data ณ 20/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo na JCV e JCW (Apont. Faltas) para rodar lote    บฑฑ
ฑฑบ          ณnovamente.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116398()
FixWindow( 116398, {|| F116398G() } )
Return

Static Function F116398G()
Local cQuery	:= ""
Local cQuery1	:= ""
Local cAlias	:= GetNextAlias()
Local cAlias1	:= GetNextAlias()
Local nCount	:= 0

cQuery := "SELECT distinct JCW.JCW_NUMRA NUMRA, JCW.JCW_LOTE LOTE, JCW.JCW_CODCUR CODCUR, JCW.JCW_PERLET PERLET, JCW.JCW_TURMA TURMA, JCW.JCW_HABILI HABILI, JCW.JCW_DISCIP DISCIP, JCW.JCW_DATA DT, JCW.R_E_C_N_O_ RECNOJCW "
cQuery += "  FROM "+RetSQLName("JCV")+"  JCV, "+RetSQLName("JCW")+"  JCW "
cQuery += " WHERE JCV.JCV_FILIAL = '"+xFilial("JCV")+"' "
cQuery += "   AND JCV.JCV_FILIAL = JCW.JCW_FILIAL "
cQuery += "   AND JCV.JCV_LOTE   = JCW.JCW_LOTE "
cQuery += "   AND JCV.JCV_LOTE   = '000000000001349' "
cQuery += "   AND JCV.JCV_CODCUR = JCW.JCW_CODCUR "
cQuery += "   AND JCV.JCV_PERLET = JCW.JCW_PERLET "
cQuery += "   AND JCV.JCV_TURMA  = JCW.JCW_TURMA "
cQuery += "   AND JCV.JCV_HABILI = JCW.JCW_HABILI "
cQuery += "   AND JCV.JCV_DISCIP = JCW.JCW_DISCIP "
cQuery += "   AND JCV.JCV_CODLOC = JCW.JCW_CODLOC "
cQuery += "   AND JCW.JCW_DATA = '20061231' "
cQuery += "   AND JCV.D_E_L_E_T_ = ' ' "
cQuery += "   AND JCW.D_E_L_E_T_ = ' ' "
cQuery += "	ORDER BY JCW.JCW_LOTE, JCW.JCW_CODCUR, JCW.JCW_PERLET, JCW.JCW_HABILI, JCW.JCW_TURMA "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )


cQuery1 := "SELECT distinct JCV.JCV_LOTE LOTE, JCV.JCV_CODCUR CODCUR, JCV.JCV_PERLET PERLET, JCV.JCV_TURMA TURMA, JCV.JCV_HABILI HABILI, JCV.JCV_DISCIP DISCIP, JCV.R_E_C_N_O_ RECNOJCV "
cQuery1 += "  FROM "+RetSQLName("JCV")+"  JCV, "+RetSQLName("JCW")+"  JCW "
cQuery1 += " WHERE JCV.JCV_FILIAL = '"+xFilial("JCV")+"' "
cQuery1 += "   AND JCV.JCV_FILIAL = JCW.JCW_FILIAL "
cQuery1 += "   AND JCV.JCV_LOTE   = JCW.JCW_LOTE "
cQuery1 += "   AND JCV.JCV_LOTE   = '000000000001349' "
cQuery1 += "   AND JCV.JCV_CODCUR = JCW.JCW_CODCUR "
cQuery1 += "   AND JCV.JCV_PERLET = JCW.JCW_PERLET "
cQuery1 += "   AND JCV.JCV_TURMA  = JCW.JCW_TURMA "
cQuery1 += "   AND JCV.JCV_HABILI = JCW.JCW_HABILI "
cQuery1 += "   AND JCV.JCV_DISCIP = JCW.JCW_DISCIP "
cQuery1 += "   AND JCV.JCV_CODLOC = JCW.JCW_CODLOC "
cQuery1 += "   AND JCW.JCW_DATA = '20061231' "
cQuery1 += "   AND JCV.D_E_L_E_T_ = ' ' "
cQuery1 += "   AND JCW.D_E_L_E_T_ = ' ' "
cQuery1 += "  ORDER BY JCV.JCV_LOTE, JCV.JCV_CODCUR, JCV.JCV_PERLET, JCV.JCV_HABILI, JCV.JCV_TURMA "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )


(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )
(cAlias1)->( dbGoTop() )

ProcRegua( nCount )

dbSelectArea("JAR")
dbSelectArea("JCW")
dbSelectArea("JCV")
dbSelectArea("JCH")

JAR->(dbSetOrder(1)) //JAR_FILIAL+JAR_CODCUR+JAR_PERLET+JAR_HABILI
JCH->(dbSetOrder(1)) //JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+DTOS(JCH_DATA)+JCH_DISCIP+JCH_CODAVA+JCH_HORA1


Begin Transaction

AcaLog( cLogFile, " ***  Atualizacao da tabela JCW: " )

while (cAlias)->( !eof() )                               
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" registros..." )
    
    if JAR->( dbSeek( xFilial("JAR")+(cAlias)->(CODCUR+PERLET+HABILI) ) )
		
		if JCH->( dbSeek( xFilial("JCH")+(cAlias)->(NUMRA+CODCUR+PERLET+HABILI+TURMA+DT+DISCIP) ) )		
			JCH->(RecLock("JCH",.F.))
			JCH->JCH_DATA := JAR->JAR_DATA2
			JCH->(MsUnLock())					
		Endif
			
		JCW->( dbGoTo( (cAlias)->RECNOJCW ) )
		JCW->(RecLock("JCW",.F.))
		JCW->JCW_DATA := JAR->JAR_DATA2
		JCW->JCW_OK   := " "
		JCW->(MsUnLock())
		
		AcaLog( cLogFile, "   Filial: "+xFilial("JCW")+"   Curso: "+(cAlias)->CODCUR + " Periodo: " + (cAlias)->PERLET+ " Habilitacao: " + (cAlias)->HABILI+ " Turma: " + (cAlias)->TURMA+" Disciplina: " + (cAlias)->DISCIP+" regularizado." )
   	endif
   	
	(cAlias)->( dbSkip() )
end

AcaLog( cLogFile, " ***  Atualizacao da tabela JCV: " )
while (cAlias1)->( !eof() )                               
		
	JCV->( dbGoTo( (cAlias1)->RECNOJCV ) )
	JCV->(RecLock("JCV",.F.))
	JCV->JCV_OK   := "1"
	JCV->(MsUnLock())
	
	AcaLog( cLogFile, "   Filial: "+xFilial("JCV")+"   Curso: "+(cAlias1)->CODCUR + " Periodo: " + (cAlias1)->PERLET+ " Habilitacao: " + (cAlias1)->HABILI+ " Turma: " + (cAlias1)->TURMA+" Disciplina: " + (cAlias1)->DISCIP+" regularizado." )

	(cAlias1)->( dbSkip() )
end

End Transaction
                          
(cAlias)->( dbCloseArea() )
(cAlias1)->( dbCloseArea() )

dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111111  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JD9 que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111111_()
FixWindow( 111111, {|| F111111G() } )
Return

Static Function F111111G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JD9
cQuery2 := " SELECT JD9_CODCUR, JD9_PERLET, JD9_HABILI, JD9_TURMA, JD9_CODDIS, JD9_CODAVA, JD9_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JD9")+" JD9 "
cQuery2 += " WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
cQuery2 += " AND JD9.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JD9.JD9_SUBTUR NOT IN (SELECT JBL.JBL_SUBTUR "
cQuery2 += "                             FROM "+RetSQLName("JBL")+" JBL "
cQuery2 += "                             WHERE JBL.JBL_FILIAL = JD9.JD9_FILIAL  "
cQuery2 += "                             AND JBL.JBL_CODCUR = JD9.JD9_CODCUR  "
cQuery2 += "                             AND JBL.JBL_PERLET = JD9.JD9_PERLET "
cQuery2 += "                             AND JBL.JBL_HABILI = JD9.JD9_HABILI "
cQuery2 += "                             AND JBL.JBL_TURMA = JD9.JD9_TURMA  "
cQuery2 += "                             AND JBL.JBL_CODDIS = JD9.JD9_CODDIS  "
cQuery2 += "                             AND JBL.D_E_L_E_T_ = ' ') "
cQuery2 += " ORDER BY JD9_CODCUR DESC, JD9_PERLET, JD9_HABILI, JD9_TURMA, JD9_CODDIS, JD9_CODAVA, JD9_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )

ProcRegua( nCount )
dbSelectArea("JD9")
JD9->(dbSetOrder(1))
Begin Transaction                                
while (cAlias2)->( !eof() )              

	
	cQuery3 := " SELECT DISTINCT JBL.JBL_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JBL")+"  JBL "
	cQuery3 += " WHERE JBL.JBL_FILIAL = '" + xFilial("JBL") + "' "
	cQuery3 += " AND JBL.D_E_L_E_T_ = ' '"
	cQuery3 += " AND JBL.JBL_CODCUR = '" + (cAlias2)->JD9_CODCUR + "' " 
	cQuery3 += " AND JBL.JBL_PERLET = '" + (cAlias2)->JD9_PERLET + "' " 
	cQuery3 += " AND JBL.JBL_HABILI = '" + (cAlias2)->JD9_HABILI + "' " 
	cQuery3 += " AND JBL.JBL_TURMA = '" + (cAlias2)->JD9_TURMA + "' " 
	cQuery3 += " AND JBL.JBL_CODDIS = '" + (cAlias2)->JD9_CODDIS + "' " 
	cQuery3 += " AND JBL.JBL_SUBTUR NOT IN (SELECT JD9.JD9_SUBTUR "
	cQuery3 += "                             FROM "+RetSQLName("JD9")+" JD9 "
	cQuery3 += "                             WHERE JD9.JD9_FILIAL = JBL.JBL_FILIAL "
	cQuery3 += "                             AND JD9.JD9_CODCUR = JBL.JBL_CODCUR " 
	cQuery3 += "                             AND JD9.JD9_PERLET = JBL.JBL_PERLET " 
	cQuery3 += "                             AND JD9.JD9_HABILI = JBL.JBL_HABILI " 
	cQuery3 += "                             AND JD9.JD9_TURMA = JBL.JBL_TURMA " 
	cQuery3 += "                             AND JD9.JD9_CODDIS = JBL.JBL_CODDIS  " 
	cQuery3 += "                             AND JD9.JD9_CODAVA = '" + (cAlias2)->JD9_CODAVA + "' " 
	cQuery3 += "                             AND JD9.D_E_L_E_T_ = ' ') "
	cQuery3 += " ORDER BY JBL_SUBTUR "	

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR)))
			JD9->(RecLock("JD9",.F.))
			JD9->( dbDelete() )
			JD9->(MsUnLock())
		endif
   	endif

   	while (cAlias3)->( !eof() ) 
		if !JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA)+(cAlias3)->JBL_SUBTUR))
			if JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR)))
				JD9->(RecLock("JD9",.F.))
				JD9->JD9_SUBTUR := (cAlias3)->JBL_SUBTUR
				JD9->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End
	(cAlias3)->( dbCloseArea() )	

	(cAlias2)->( dbSkip() )
end
(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111112  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JDA que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111112()
FixWindow( 111112, {|| F111112G() } )
Return

Static Function F111112G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JDA
cQuery2 := " SELECT JDA_CODCUR, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID, JDA_SUBTUR  "
cQuery2 += " FROM "+RetSQLName("JDA")+" JDA "
cQuery2 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += " AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JD9.JD9_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JD9")+" JD9 "
cQuery2 += "                           WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
cQuery2 += "                           AND JD9.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JD9.JD9_CODCUR = JDA.JDA_CODCUR "
cQuery2 += "                           AND JD9.JD9_PERLET = JDA.JDA_PERLET "
cQuery2 += "                           AND JD9.JD9_HABILI = JDA.JDA_HABILI  "
cQuery2 += "                           AND JD9.JD9_TURMA = JDA.JDA_TURMA "
cQuery2 += "                           AND JD9.JD9_CODDIS = JDA.JDA_CODDIS  "
cQuery2 += "                           AND JD9.JD9_CODAVA = JDA.JDA_CODAVA)"
cQuery2 += " ORDER BY JDA_CODCUR DESC, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID, JDA_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JDA")
JDA->(dbSetOrder(6))
while (cAlias2)->( !eof() )              

	             
	cQuery3 := " SELECT DISTINCT JD9.JD9_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JD9")+" JD9 "
	cQuery3 += " WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
	cQuery3 += " AND JD9.D_E_L_E_T_ = ' ' "
	cQuery3 += " AND JD9.JD9_CODCUR = '" + (cAlias2)->JDA_CODCUR + "' " 
	cQuery3 += " AND JD9.JD9_PERLET = '" + (cAlias2)->JDA_PERLET + "' " 
	cQuery3 += " AND JD9.JD9_HABILI = '" + (cAlias2)->JDA_HABILI + "' " 
	cQuery3 += " AND JD9.JD9_TURMA = '" + (cAlias2)->JDA_TURMA + "' " 
	cQuery3 += " AND JD9.JD9_CODDIS = '" + (cAlias2)->JDA_CODDIS + "' " 
	cQuery3 += " AND JD9.JD9_CODAVA = '" + (cAlias2)->JDA_CODAVA + "' " 
	cQuery3 += " AND JD9.JD9_SUBTUR NOT IN (SELECT JDA.JDA_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JDA")+" JDA "
	cQuery3 += "                        WHERE JDA.JDA_FILIAL = JD9.JD9_FILIAL "
	cQuery3 += "                        AND JDA.JDA_CODCUR = JD9.JD9_CODCUR "
	cQuery3 += "                        AND JDA.JDA_PERLET = JD9.JD9_PERLET "
	cQuery3 += "                        AND JDA.JDA_HABILI = JD9.JD9_HABILI "
	cQuery3 += "                        AND JDA.JDA_TURMA = JD9.JD9_TURMA "
	cQuery3 += "                        AND JDA.JDA_CODDIS = JD9.JD9_CODDIS "
	cQuery3 += "                        AND JDA.JDA_CODAVA = JD9.JD9_CODAVA "
	cQuery3 += "                        AND JDA.JDA_ATIVID = '" + (cAlias2)->JDA_ATIVID + "' " 
	cQuery3 += "                        AND JDA.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JD9.JD9_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_SUBTUR+JDA_ATIVID)))
			JDA->(RecLock("JDA",.F.))
			JDA->( dbDelete() )
			JDA->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA)+(cAlias3)->JD9_SUBTUR+(cAlias2)->JDA_ATIVID))
			if JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_SUBTUR+JDA_ATIVID)))
				JDA->(RecLock("JDA",.F.))
				JDA->JDA_SUBTUR := (cAlias3)->JD9_SUBTUR
				JDA->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	

	(cAlias2)->( dbSkip() )
end

(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111113  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JDB que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111113()
FixWindow( 111113, {|| F111113G() } )
Return

Static Function F111113G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//ATUALIZANDO JDB 
cQuery2 := " SELECT JDB_CODCUR, JDB_PERLET, JDB_HABILI, JDB_TURMA, JDB_CODDIS, JDB_CODAVA, JDB_ATIVID, JDB_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JDB")+" JDB "
cQuery2 += " WHERE JDB.JDB_FILIAL = '" + xFilial("JDB") + "' "
cQuery2 += " AND JDB.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDB.JDB_SUBTUR NOT IN (SELECT JDA.JDA_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JDA")+" JDA "
cQuery2 += "                           WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += "                           AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JDA.JDA_CODCUR = JDB.JDB_CODCUR "
cQuery2 += "                           AND JDA.JDA_PERLET = JDB.JDB_PERLET "
cQuery2 += "                           AND JDA.JDA_HABILI = JDB.JDB_HABILI "
cQuery2 += "                           AND JDA.JDA_TURMA = JDB.JDB_TURMA "
cQuery2 += "                           AND JDA.JDA_CODDIS = JDB.JDB_CODDIS "
cQuery2 += "                           AND JDA.JDA_CODAVA = JDB.JDB_CODAVA "
cQuery2 += "                           AND JDA.JDA_ATIVID = JDB.JDB_ATIVID) "
cQuery2 += " ORDER BY JDB_CODCUR DESC, JDB_PERLET, JDB_HABILI, JDB_TURMA, JDB_CODDIS, JDB_CODAVA, JDB_ATIVID, JDB_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JDB")
JDB->(dbSetOrder(1))
while (cAlias2)->( !eof() )              
	             
	cQuery3 := " SELECT DISTINCT JDA.JDA_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JDA")+" JDA "
	cQuery3 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
	cQuery3 += " AND JDA.D_E_L_E_T_ = ' ' "
	cQuery3 += " AND JDA.JDA_CODCUR = '" + (cAlias2)->JDB_CODCUR + "' " 
	cQuery3 += " AND JDA.JDA_PERLET = '" + (cAlias2)->JDB_PERLET + "' " 
	cQuery3 += " AND JDA.JDA_HABILI = '" + (cAlias2)->JDB_HABILI + "' " 
	cQuery3 += " AND JDA.JDA_TURMA = '" + (cAlias2)->JDB_TURMA + "' " 
	cQuery3 += " AND JDA.JDA_CODDIS = '" + (cAlias2)->JDB_CODDIS + "' " 
	cQuery3 += " AND JDA.JDA_CODAVA = '" + (cAlias2)->JDB_CODAVA + "' " 
	cQuery3 += " AND JDA.JDA_ATIVID = '" + (cAlias2)->JDB_ATIVID + "' " 
	cQuery3 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JDB.JDB_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JDB")+" JDB "
	cQuery3 += "                        WHERE JDB.JDB_FILIAL = JDA.JDA_FILIAL "
	cQuery3 += "                        AND JDB.JDB_CODCUR = JDA.JDA_CODCUR "
	cQuery3 += "                        AND JDB.JDB_PERLET = JDA.JDA_PERLET "
	cQuery3 += "                        AND JDB.JDB_HABILI = JDA.JDA_HABILI "
	cQuery3 += "                        AND JDB.JDB_TURMA = JDA.JDA_TURMA "
	cQuery3 += "                        AND JDB.JDB_CODDIS = JDA.JDA_CODDIS "
	cQuery3 += "                        AND JDB.JDB_CODAVA = JDA.JDA_CODAVA "
	cQuery3 += "                        AND JDB.JDB_ATIVID = JDA.JDA_ATIVID "
	cQuery3 += "                        AND JDB.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JDA.JDA_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR)))
			JDB->(RecLock("JDB",.F.))
			JDB->( dbDelete() )
			JDB->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID)+(cAlias3)->JDA_SUBTUR))		
			if JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR)))		
				JDB->(RecLock("JDB",.F.))
				JDB->JDB_SUBTUR := (cAlias3)->JDA_SUBTUR
				JDB->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	
	(cAlias2)->( dbSkip() )
end
(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111114  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JBR que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111114()
FixWindow( 111114, {|| F111114G() } )
Return

Static Function F111114G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JBR
cQuery2 := " SELECT DISTINCT JBR_CODCUR, JBR_PERLET, JBR_HABILI, JBR_TURMA, JBR_CODDIS, JBR_CODAVA, JBR_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JBR")+" JBR, "+RetSQLName("JDA")+" JDA "
cQuery2 += " WHERE JBR.JBR_FILIAL = '" + xFilial("JBR") + "' "
cQuery2 += " AND JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += " AND JBR.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JBR.JBR_CODCUR = JDA.JDA_CODCUR "
cQuery2 += " AND JBR.JBR_PERLET = JDA.JDA_PERLET "
cQuery2 += " AND JBR.JBR_HABILI = JDA.JDA_HABILI "
cQuery2 += " AND JBR.JBR_TURMA = JDA.JDA_TURMA " 
cQuery2 += " AND JBR.JBR_CODDIS = JDA.JDA_CODDIS " 
cQuery2 += " AND JBR.JBR_CODAVA = JDA.JDA_CODAVA " 
cQuery2 += " AND JBR.JBR_SUBTUR NOT IN (SELECT JDA2.JDA_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JDA")+" JDA2 "
cQuery2 += "                           WHERE JDA2.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += "                           AND JDA2.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JDA2.JDA_CODCUR = JBR.JBR_CODCUR "
cQuery2 += "                           AND JDA2.JDA_PERLET = JBR.JBR_PERLET "
cQuery2 += "                           AND JDA2.JDA_HABILI = JBR.JBR_HABILI " 
cQuery2 += "                           AND JDA2.JDA_TURMA = JBR.JBR_TURMA "
cQuery2 += "                           AND JDA2.JDA_CODDIS = JBR.JBR_CODDIS " 
cQuery2 += "                           AND JDA2.JDA_CODAVA = JBR.JBR_CODAVA) "
cQuery2 += " ORDER BY JBR_CODCUR DESC, JBR_PERLET, JBR_HABILI, JBR_TURMA, JBR_CODDIS, JBR_CODAVA, JBR_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JBR")
JBR->(dbSetOrder(1))
while (cAlias2)->( !eof() )              
	             
	cQuery3 := " SELECT DISTINCT JDA.JDA_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JDA")+" JDA "
	cQuery3 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
	cQuery3 += " AND JDA.D_E_L_E_T_ = ' ' "            
	cQuery3 += " AND JDA.JDA_CODCUR = '" + (cAlias2)->JBR_CODCUR + "' " 
	cQuery3 += " AND JDA.JDA_PERLET = '" + (cAlias2)->JBR_PERLET + "' " 
	cQuery3 += " AND JDA.JDA_HABILI = '" + (cAlias2)->JBR_HABILI + "' " 
	cQuery3 += " AND JDA.JDA_TURMA = '" + (cAlias2)->JBR_TURMA + "' " 
	cQuery3 += " AND JDA.JDA_CODDIS = '" + (cAlias2)->JBR_CODDIS + "' " 
	cQuery3 += " AND JDA.JDA_CODAVA = '" + (cAlias2)->JBR_CODAVA + "' " 
	cQuery3 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JBR.JBR_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JBR")+" JBR "
	cQuery3 += "                        WHERE JBR.JBR_FILIAL = JDA.JDA_FILIAL "
	cQuery3 += "                        AND JBR.JBR_CODCUR = JDA.JDA_CODCUR "
	cQuery3 += "                        AND JBR.JBR_PERLET = JDA.JDA_PERLET "
	cQuery3 += "                        AND JBR.JBR_HABILI = JDA.JDA_HABILI "
	cQuery3 += "                        AND JBR.JBR_TURMA = JDA.JDA_TURMA "
	cQuery3 += "                        AND JBR.JBR_CODDIS = JDA.JDA_CODDIS "
	cQuery3 += "                        AND JBR.JBR_CODAVA = JDA.JDA_CODAVA "
	cQuery3 += "                        AND JBR.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JDA.JDA_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if	JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR)))   
			JBR->(RecLock("JBR",.F.))
			JBR->( dbDelete() )
			JBR->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA)+(cAlias3)->JDA_SUBTUR))   
			if JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR)))   
				JBR->(RecLock("JBR",.F.))
				JBR->JBR_SUBTUR := (cAlias3)->JDA_SUBTUR
				JBR->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	
	(cAlias2)->( dbSkip() )
end

(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx102374  บAutor  ณViviane Miam        บ Data ณ 09/Jan/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo E1_VALLIQ,pois na baixa automแtica de bol-บฑฑ
ฑฑบ          ณsa pr๓pria, esse campo nใo estava sendo zerado              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx102374()
FixWindow( 102374, {|| F102374G() } )
Return

Static Function F102374G()
Local cQuery1	:= ""
Local cAlias1	:= GetNextAlias()

//atualizando SE1                                                                                               
cQuery1 := " SELECT E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO "
cQuery1 += " FROM "+RetSQLName("SE1")+" E1, "+RetSQLName("JC5")+" JC5, " +RetSQLName("JC4")+ " JC4 "
cQuery1 += " WHERE E1.E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery1 += " AND JC4.JC4_FILIAL = '" + xFilial("JBR") + "' "
cQuery1 += " AND JC5.JC5_FILIAL = '" + xFilial("JBR") + "' "
cQuery1 += " AND E1.E1_NUMRA = JC5.JC5_NUMRA "
cQuery1 += " AND JC5.JC5_TIPBOL = JC4.JC4_COD "
cQuery1 += " AND E1.E1_VALLIQ <> '0' "
cQuery1 += " AND E1.E1_STATUS = 'B' "
cQuery1 += " AND JC5.JC5_PERBOL = '100' "
cQuery1 += " AND JC4.JC4_TPCONV = '1' "
cQuery1 += " AND JC4.JC4_BAIXA = '1' "
cQuery1 += " AND E1.D_E_L_E_T_ = '' "
cQuery1 += " AND JC4.D_E_L_E_T_ = '' "
cQuery1 += " AND JC5.D_E_L_E_T_ = '' "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )

(cAlias1)->( dbGoTop() )                                      
Begin Transaction   
dbSelectArea("SE1")
SE1->(dbSetOrder(1))
while (cAlias1)->( !eof() )              
	if	SE1->(dbSeek(xFilial("SE1")+(cAlias1)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		SE1->(RecLock("SE1",.F.))
		SE1->E1_VALLIQ = 0.0
		SE1->(MsUnLock())
	endif
	(cAlias1)->( dbSkip() )
end                            
(cAlias1)->( dbCloseArea() )
End Transaction
dbSelectArea("SE1")

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx119913  บAutor  ณEduardo de Souza    บ Data ณ 23/Fev/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a alocacao do Aluno (JC7) com dados da JBL.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx119913()
FixWindow( 119913, {|| F119913A() } )
Return

Static Function F119913A()
Local cQuery 	:= ""
Local cAlias1	:= GetNextAlias()
Local lSubTur	:= JBE->(FieldPos("JBE_SUBTUR")) > 0 .And. JC7->(FieldPos("JC7_SUBTUR"))  > 0 .And. JBL->(FieldPos("JBL_SUBTUR")) > 0

//Vinculo com aluno de grade regular
cQuery := "SELECT DISTINCT JC7.R_E_C_N_O_ REC, JBL_MATPRF, JBL_MATPR2, JBL_MATPR3, JBL_MATPR4, "
cQuery += " JBL_MATPR5, JBL_MATPR6, JBL_MATPR7, JBL_MATPR8 "

cQuery += " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE, "
cQuery += RetSQLName("JBK") + " JBK, " + RetSQLName("JBL")+ " JBL "

cQuery += " WHERE "

cQuery += " JC7_FILIAL     = '" + xFilial("JC7") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBK_FILIAL = '" + xFilial("JBK") + "' "
cQuery += " AND JBL_FILIAL = '" + xFilial("JBL") + "' "

cQuery += " AND JC7_CODCUR = JBE_CODCUR "
cQuery += " AND JC7_PERLET = JBE_PERLET "
cQuery += " AND JC7_HABILI = JBE_HABILI "
cQuery += " AND JC7_TURMA  = JBE_TURMA "

If JBE->(FieldPos("JBE_SEQ")) > 0
	cQuery += " AND JC7_SEQ  = JBE_SEQ "
Endif

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBE_SUBTUR "
Endif

cQuery += " AND JBK_CODCUR = JBE_CODCUR "
cQuery += " AND JBK_PERLET = JBE_PERLET "
cQuery += " AND JBK_HABILI = JBE_HABILI "
cQuery += " AND JBK_TURMA  = JBE_TURMA "

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JBE_ANOLET = '2007' "
cQuery += " AND JBE_PERIOD = '01' "

cQuery += " AND ((JBE_ATIVO = '1' AND JBE_SITUAC = '2' ) OR  "
cQuery += " (JBE_ATIVO = '2' AND JBE_SITUAC = '1')) "

cQuery += " AND JBK_ATIVO  = '1' "

cQuery += " AND JC7_DISCIP = JBL_CODDIS "
cQuery += " AND JC7_DIASEM = JBL_DIASEM "
cQuery += " AND JC7_CODHOR = JBL_CODHOR "
cQuery += " AND JC7_HORA1  = JBL_HORA1 "
cQuery += " AND JC7_HORA2  = JBL_HORA2 "

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBL_SUBTUR "
Endif

cQuery += " AND (JC7_CODPRF <> JBL_MATPRF OR "
cQuery += " JC7_CODPR2 <> JBL_MATPR2 OR "
cQuery += " JC7_CODPR3 <> JBL_MATPR3 OR "
cQuery += " JC7_CODPR4 <> JBL_MATPR4 OR "
cQuery += " JC7_CODPR5 <> JBL_MATPR5 OR "
cQuery += " JC7_CODPR6 <> JBL_MATPR6 OR "
cQuery += " JC7_CODPR7 <> JBL_MATPR7 OR "
cQuery += " JC7_CODPR8 <> JBL_MATPR8) "

cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "

cQuery += " UNION "

//Vinculo com aluno cursando outra grade
cQuery += "SELECT DISTINCT JC7.R_E_C_N_O_ REC, JBL_MATPRF, JBL_MATPR2, JBL_MATPR3, JBL_MATPR4, "
cQuery += " JBL_MATPR5, JBL_MATPR6, JBL_MATPR7, JBL_MATPR8 "

cQuery += " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE, "
cQuery += RetSQLName("JBK") + " JBK, " + RetSQLName("JBL")+ " JBL "

cQuery += " WHERE "

cQuery += " JC7_FILIAL     = '" + xFilial("JC7") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBK_FILIAL = '" + xFilial("JBK") + "' "
cQuery += " AND JBL_FILIAL = '" + xFilial("JBL") + "' "

cQuery += " AND JC7_CODCUR = JBE_CODCUR "
cQuery += " AND JC7_PERLET = JBE_PERLET "
cQuery += " AND JC7_HABILI = JBE_HABILI "
cQuery += " AND JC7_TURMA  = JBE_TURMA "

If JBE->(FieldPos("JBE_SEQ")) > 0
	cQuery += " AND JC7_SEQ  = JBE_SEQ "
Endif

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBE_SUBTUR "
Endif

cQuery += " AND JBK_CODCUR = JC7_OUTCUR "
cQuery += " AND JBK_PERLET = JC7_OUTPER "
cQuery += " AND JBK_HABILI = JC7_OUTHAB "
cQuery += " AND JBK_TURMA  = JC7_OUTTUR"

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JBE_ANOLET = '2007' "
cQuery += " AND JBE_PERIOD = '01' "

cQuery += " AND ((JBE_ATIVO = '1' AND JBE_SITUAC = '2' ) OR  "
cQuery += " (JBE_ATIVO = '2' AND JBE_SITUAC = '1')) "

cQuery += " AND JBK_ATIVO  = '1' "

cQuery += " AND JC7_DISCIP = JBL_CODDIS "
cQuery += " AND JC7_DIASEM = JBL_DIASEM "
cQuery += " AND JC7_CODHOR = JBL_CODHOR "
cQuery += " AND JC7_HORA1  = JBL_HORA1 "
cQuery += " AND JC7_HORA2  = JBL_HORA2 "

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBL_SUBTUR "
Endif

cQuery += " AND (JC7_CODPRF <> JBL_MATPRF OR "
cQuery += " JC7_CODPR2 <> JBL_MATPR2 OR "
cQuery += " JC7_CODPR3 <> JBL_MATPR3 OR "
cQuery += " JC7_CODPR4 <> JBL_MATPR4 OR "
cQuery += " JC7_CODPR5 <> JBL_MATPR5 OR "
cQuery += " JC7_CODPR6 <> JBL_MATPR6 OR "
cQuery += " JC7_CODPR7 <> JBL_MATPR7 OR "
cQuery += " JC7_CODPR8 <> JBL_MATPR8) "

cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )
    
DbSelectArea("JC7")

While (cAlias1)->(!Eof())
	JC7->(DbGoto( (cAlias1)->REC ))
	If RecLock("JC7", .F.)
		JC7->JC7_CODPRF := (cAlias1)->JBL_MATPRF
		JC7->JC7_CODPR2 := (cAlias1)->JBL_MATPR2
		JC7->JC7_CODPR3 := (cAlias1)->JBL_MATPR3
		JC7->JC7_CODPR4 := (cAlias1)->JBL_MATPR4
		JC7->JC7_CODPR5 := (cAlias1)->JBL_MATPR5
		JC7->JC7_CODPR6 := (cAlias1)->JBL_MATPR6
		JC7->JC7_CODPR7 := (cAlias1)->JBL_MATPR7
		JC7->JC7_CODPR8 := (cAlias1)->JBL_MATPR8
		JC7->(MsUnlock())												
		AcaLog(cLogFile, "JC7 ALTERADA : " + AllTrim(Str(JC7->(RECNO()))))
	Else
		AcaLog(cLogFile, "** JC7 NAO PODE SER ALTERADA : " + AllTrim(Str(JC7->(RECNO()))))	
	Endif
   (cAlias1)->(DbSkip())
End

(cAlias1)->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx101821  บAutor  ณViviane Miam        บ Data ณ 02/Mar/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste nas tabelas JBL e JDA para preenchimento dos campos  บฑฑ
ฑฑบ          ณITEM e MATPRF, referente เ melhoria de apont. de faltas.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx101821()
FixWindow( 101821, {|| F101821G() } )
Return

Static Function F101821G()
Local cQuery1, cQuery2, cQuery3, cQuery4 := ""
Local cAlias1 := GetNextAlias()
Local cAlias2 := ""
Local cAlias3 := ""
Local cAlias4 := ""
Local lSubTurma := JD2->(FieldPos("JD2_SUBTUR")) > 0

//atualizando JCG       
cQuery1 := " SELECT JCG.JCG_CODCUR, JCG.JCG_PERLET, JCG.JCG_HABILI, JCG.JCG_TURMA, JCG.JCG_DATA, JCG.JCG_ITEM, "
cQuery1 += " JCG.JCG_DISCIP, JCG.JCG_CODAVA, JCG.JCG_MATPRF "
if lSubTurma
	cQuery1 += ", JCG.JCG_SUBTUR "
endif
cQuery1 += " FROM "+RetSQLName("JCG")+" JCG "
cQuery1 += " WHERE JCG.JCG_FILIAL = '" + xFilial("JCG") + "' "
cQuery1 += " AND ((JCG.JCG_ITEM = ''  "
cQuery1 += " AND JCG.JCG_TIPO = '1')  "
cQuery1 += " OR JCG.JCG_MATPRF = '') "
cQuery1 += " AND JCG.D_E_L_E_T_ = '' "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )
(cAlias1)->( dbGoTop() )

dbSelectArea("JCG")
JCG->(dbSetOrder(1))
JCH->(dbSetOrder(1))
JAH->(dbSetOrder( 1 ))
JAF->(dbSetOrder( 1 ))

while (cAlias1)->( !eof() )              
	nItem := ""
	nMatprf := ""
	JAH->(dbSeek( xFilial("JAH")+ (cAlias1)->JCG_CODCUR ))
	JAF->(dbSeek( xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO)))
    if JAF->JAF_TIPGRD == "2"           
		cQuery2 := " SELECT JD2.JD2_CODCUR, JD2.JD2_PERLET, JD2.JD2_HABILI,JD2.JD2_TURMA, JD2.JD2_CODDIS, "
		cQuery2 += " JD2.JD2_DATA, JD2.JD2_DIASEM, JD2.JD2_AULA, JD2.JD2_MATPRF  "
		if lSubTurma
			cQuery2 += ", JCG.JCG_SUBTUR "
		endif
		cQuery2 += " FROM "+RetSQLName("JD2")+" JD2 "
		cQuery2 += " WHERE JD2.JD2_FILIAL = '" + xFilial("JD2") + "' "
		cQuery2 += " AND JD2.JD2_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
		cQuery2 += " AND JD2.JD2_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
		cQuery2 += " AND JD2.JD2_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
		cQuery2 += " AND JD2.JD2_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
		cQuery2 += " AND JD2.JD2_CODDIS = '" + (cAlias1)->JCG_DISCIP + "' "
		cQuery2 += " AND JD2.JD2_DATA = '" + (cAlias1)->JCG_DATA + "' "
		cQuery2 += " AND JD2.JD2_DIASEM = '" + str(Dow(stod((cAlias1)->JCG_DATA)),1) + "' "
		if lSubTurma
			cQuery2 += " AND JD2.JD2_SUBTUR = '" + (cAlias1)->JCG_SUBTURMA + "' "
		endif
		cQuery2 += " AND JD2.D_E_L_E_T_ = '' "
		cQuery2 += " ORDER BY JD2.JD2_ITEM, JD2.JD2_AULA "		
		
		cQuery2 := ChangeQuery( cQuery2 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )
		(cAlias2)->( dbGoTop() )                                      
    	While (cAlias2)->( !eof() )              
    		if JCG->(dbSeek(xFilial("JCG")+(cAlias2)->(JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DATA+JD2_AULA+JD2_DISCIP)+(cAlias1)->(JCG_CODAVA+if(lSubturma, JCG_SUBTUR, ""))+(cAlias2)->(JD2_MATPRF)))
				(cAlias2)->(dbSkip())	
			else
				if JCG->(dbSeek(xFilial("JCG")+(cAlias1)->(JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+JCG_DATA+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+if(lSubturma, JCG_SUBTUR, "")+JCG_MATPRF)))			
					JCG->(RecLock("JCG",.F.)) 
					if (alltrim(JCG->JCG_ITEM) == "" ) .and. (JCG->JCG_TIPO == "1")
						IF (alltrim(JCG->JCG_MATPRF) <> "" .and. alltrim(JCG->JCG_MATPRF) == alltrim((cAlias2)->JD2_MATPRF)) .or. alltrim(JCG->JCG_MATPRF) == ""
							JCG->JCG_ITEM 	:= (cAlias2)->JD2_ITEM
							nItem := (cAlias2)->JBL_ITEM
						endif
					endif                 
					if (alltrim(JCG->JCG_MATPRF) == "") 
						if (alltrim(JCG->JCG_ITEM) <> "" .and. alltrim(JCG->JCG_ITEM) == alltrim((cAlias2)->JD2_ITEM)) .or. alltrim(JCG->JCG_ITEM) == ""
							JCG->JCG_MATPRF := (cAlias2)->JD2_MATPRF
							nMatprf := (cAlias2)->JD2_MATPRF						
						endif
					endif
					JCG->(MsUnLock())
				endif
			endif    
			(cAlias2)->(dbSkip())
		end            
		(cAlias2)->( dbCloseArea() )		
    else
		cQuery3 := " SELECT JBL.JBL_CODCUR, JBL.JBL_PERLET, JBL.JBL_HABILI,JBL.JBL_TURMA, JBL.JBL_CODDIS, "
		cQuery3 += " JBL.JBL_DIASEM, JBL.JBL_MATPRF, JBL.JBL_ITEM  "
		if lSubTurma
			cQuery3 += ", JBL.JBL_SUBTUR "
		endif
		cQuery3 += " FROM "+RetSQLName("JBL")+" JBL "
		cQuery3 += " WHERE JBL.JBL_FILIAL = '" + xFilial("JD2") + "' "
		cQuery3 += " AND JBL.JBL_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
		cQuery3 += " AND JBL.JBL_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
		cQuery3 += " AND JBL.JBL_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
		cQuery3 += " AND JBL.JBL_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
		cQuery3 += " AND JBL.JBL_CODDIS = '" + (cAlias1)->JCG_DISCIP + "' "
		cQuery3 += " AND JBL.JBL_DIASEM = '" + str(Dow(stod((cAlias1)->JCG_DATA)),1) + "' "
		if lSubTurma
			cQuery3 += " AND JBL.JBL_SUBTUR = '" + (cAlias1)->JCG_SUBTURMA + "' "
		endif
		cQuery3 += " AND JBL.D_E_L_E_T_ = '' "
		cQuery3 += " ORDER BY JBL.JBL_ITEM "		
		
		cQuery3 := ChangeQuery( cQuery3 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )
		(cAlias3)->( dbGoTop() )                                      		
    	While (cAlias3)->( !eof() )              
    		if JCG->(dbSeek(xFilial("JCG")+(cAlias3)->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA)+(cAlias1)->(JCG_DATA)+(cAlias3)->(JBL_ITEM+JBL_CODDIS)+(cAlias1)->(JCG_CODAVA)+if(lSubturma, (cAlias1)->JCG_SUBTUR, "")+(cAlias3)->JBL_MATPRF))
				(cAlias3)->(dbSkip())	
			else
				if JCG->(dbSeek(xFilial("JCG")+(cAlias1)->(JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+JCG_DATA+JCG_ITEM+JCG_DISCIP+JCG_CODAVA)+if(lSubturma, (cAlias1)->JCG_SUBTUR, "")+(cAlias1)->JCG_MATPRF))			
					JCG->(RecLock("JCG",.F.)) 
					if (alltrim(JCG->JCG_ITEM) == "" ) .and. (JCG->JCG_TIPO == "1")
						IF (alltrim(JCG->JCG_MATPRF) <> "" .and. alltrim(JCG->JCG_MATPRF) == alltrim((cAlias3)->JBL_MATPRF)) .or. alltrim(JCG->JCG_MATPRF) == ""
							JCG->JCG_ITEM 	:= (cAlias3)->JBL_ITEM
							nItem := (cAlias3)->JBL_ITEM
						endif
					endif                 
					if (alltrim(JCG->JCG_MATPRF) == "") 
						if (alltrim(JCG->JCG_ITEM) <> "" .and. alltrim(JCG->JCG_ITEM) == alltrim((cAlias3)->JBL_ITEM)) .or. alltrim(JCG->JCG_ITEM) == ""
							JCG->JCG_MATPRF := (cAlias3)->JBL_MATPRF
							nMatprf := (cAlias3)->JBL_MATPRF						
						endif
					endif
					JCG->(MsUnLock())
				endif
			endif    
			(cAlias3)->(dbSkip())
		end
		(cAlias3)->( dbCloseArea() )    
    endif
    
	//atualizando JCH
	cQuery4 := " SELECT JCH.JCH_CODCUR, JCH.JCH_PERLET, JCH.JCH_HABILI, JCH.JCH_TURMA, JCH.JCH_DATA, JCH.JCH_ITEM, "
	cQuery4 += " JCH.JCH_DISCIP, JCH.JCH_CODAVA, JCH.JCH_MATPRF, JCH.JCH_NUMRA "
	cQuery4 += " FROM "+RetSQLName("JCH")+" JCH "
	cQuery4 += " WHERE JCH.JCH_FILIAL = '" + xFilial("JCH") + "' "
	cQuery4 += " AND JCH.JCH_ITEM = '' "
	cQuery4 += " AND JCH.JCH_MATPRF = '' "
	cQuery4 += " AND JCH.JCH_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
	cQuery4 += " AND JCH.JCH_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
	cQuery4 += " AND JCH.JCH_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
	cQuery4 += " AND JCH.JCH_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
	cQuery4 += " AND JCH.JCH_DISCIP = '" + (cAlias1)->JCG_DISCIP + "' "
	cQuery4 += " AND JCH.JCH_CODAVA = '" + (cAlias1)->JCG_CODAVA + "' "	
	cQuery4 += " AND JCH.JCH_DATA = '" + (cAlias1)->JCG_DATA + "' "
	cQuery4 += " AND JCH.D_E_L_E_T_ = '' "
	
	cQuery4 := ChangeQuery( cQuery4 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery4), cAlias4, .F., .F. )
	While (cAlias4)->( !eof() )              
		if JCH->(dbSeek(xFilial("JCH")+(cAlias4)->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DATA)+nItem+(cAlias4)->(JCH_DISCIP+JCH_CODAVA)+nMatprf))
			(cAlias4)->(dbSkip())	
		else
			JCH->(dbSeek(xFilial("JCH")+(cAlias4)->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DATA+JCH_ITEM+JCH_DISCIP+JCH_CODAVA+JCH_MATPRF)))			
			JCH->(RecLock("JCH",.F.))  
			if alltrim(nItem) <> ""
				JCH->JCH_ITEM 	:= nItem
			endif
			if alltrim(nMatprf) <> ""
				JCH->JCH_MATPRF := nMatprf
			endif
			JCH->(MsUnLock())
		endif    
		(cAlias4)->(dbSkip())
	end
	(cAlias4)->( dbCloseArea() )
	(cAlias1)->( dbSkip() )
end                            
(cAlias1)->( dbCloseArea() )

dbSelectArea("JCG")
Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx120699  บAutor  ณCristina Santana Souza                             บ Data ณ 06/Mar/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste na tabela JBI para gravar a data e hora de saida (JBI_DTSAI e JBI_HRSAI) do         บฑฑ
ฑฑบ          ณsegundo passo do requerimento (Ordem 02), que no ambiente de producao do cliente			 บฑฑ
ฑฑบ          ณencontra-se deferido (JBI_STATUS = 1 - Deferido), mas sem a data e hora de saida gravados. บฑฑ
ฑฑบ          ณ																							 บฑฑ
ฑฑบ          ณA mesma data e hora serao gravadas na data e hora de entrada (JBI_DTENT e JBI_HRENT)       บฑฑ
ฑฑบ          ณdo item seguinte (Ordem 03) que esta com  a JBI_STATUS = 3 (Pendente).					 บฑฑ
ฑฑบ          ณ																						     บฑฑ
ฑฑบ          ณO tratamento sera efetuado apenas para Filial 04 - Campinas								 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                    								 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Fx120699()

FixWindow( 120699, {|| F120699G() } )
Return

Static Function F120699G()

Local cQuery := ""
Local cAlias := GetNextAlias()
Local dDataReq := dDataBase
Local dHoraReq := Time()

dbSelectArea("JBI")

//Soh atualiza para a filial 04 - Campinas
if xFilial("JBI") <> "04"
	Return
endif

cQuery := " SELECT JBI_NUM, JBI_ORDEM, JBI.R_E_C_N_O_ JBIREC FROM " +RetSQLName("JBI")+ " JBI "
cQuery += " WHERE JBI_FILIAL = '04' "
cQuery += " AND JBI_STATUS = '1'  "   //(1=Deferido;2=ndeferido;3=Pendente;4=Atrasado)
cQuery += " AND JBI_DTSAI  = ' '  "
cQuery += " AND JBI_ORDEM  = '02' "
cQuery += " AND JBI_NUM IN ( '000497', '000498', '000499', '000500', '000501', '000502', '000503', '000504', '000505', '000506', '000507') "
cQuery += " AND JBI.D_E_L_E_T_ = ' ' "

cQuery += " UNION "

cQuery += " SELECT JBI_NUM, JBI_ORDEM, JBI.R_E_C_N_O_ JBIREC FROM " +RetSQLName("JBI")+ " JBI "
cQuery += " WHERE JBI_FILIAL = '04' "
cQuery += " AND JBI_STATUS = '3' "   //(1=Deferido;2=ndeferido;3=Pendente;4=Atrasado)
cQuery += " AND JBI_DTENT  = ' '  "
cQuery += " AND JBI_ORDEM  = '03' "
cQuery += " AND JBI_NUM IN ( '000497', '000498', '000499', '000500', '000501', '000502', '000503', '000504', '000505', '000506', '000507') "
cQuery += " AND JBI.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY JBI_NUM, JBIREC  "  

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

Begin Transaction

dbSelectArea("JBI")

AcaLog(cLogFile, "Inํcio do processamento..." + Dtoc( date() )+" "+Time())
AcaLog(cLogFile, "Atualizando tabela JBI..." )

While (cAlias)->( !eof() )              
  
	JBI->( dbGoTo( (cAlias)->JBIREC ) )
	
	If (cAlias)->JBI_ORDEM = '02'
		RecLock("JBI", .F.)    
		JBI->JBI_DTSAI := dDataReq
		JBI->JBI_HRSAI := dHoraReq
		JBI->( MsUnLock() )
		AcaLog(cLogFile, "Atualizado protocolo: " + (cAlias)->JBI_NUM + " Ordem: " + (cAlias)->JBI_ORDEM )
	Else
		RecLock("JBI", .F.)
		JBI->JBI_DTENT := dDataReq
		JBI->JBI_HRENT := dHoraReq
		JBI->( MsUnLock() )
		AcaLog(cLogFile, "Atualizado protocolo: " + (cAlias)->JBI_NUM + " Ordem: " + (cAlias)->JBI_ORDEM )
	Endif
                  
	(cAlias)->( dbSkip() )

Enddo

AcaLog(cLogFile, "Final do processamento..." + Dtoc( date() )+" "+Time())
          
(cAlias)->(dbCloseArea())

End Transaction

dbSelectArea("JA2")
                   
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx120649  บAutor  ณCristiane Tuji      บ Data ณ 18/Abr/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReativa็ใo dos boletos deletados incorretamente pela rotina บฑฑ
ฑฑบ          ณACCanExBol() do ACAXFUN.PRW rotina de Requerimento Acaa410. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx120649()
FixWindow( 120649, {|| F120649G() } )
Return

Static Function F120649G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  ณ Monta a query para identificar os boletos afetados                       ณ
  ณBoletos que estao DELETADOS para os alunos que foram transferidos de cursoณ
  ณvia requerimento - Calouros (000015) ou Veteranos (000016) .              ณ
  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
                                                        
cQuery := "SELECT SE1.R_E_C_N_O_ RECSE1, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "
cQuery += " FROM "
cQuery +=RetSQLName("JBH")+" JBH, "
cQuery +=RetSQLName("SE1")+" SE1 "
cQuery += " WHERE JBH_FILIAL = '"+xFilial("JBH")+"' AND JBH_STATUS = '1' "
cQuery += " AND JBH_DTINIC>='20070101'"											 //Requerimentos criados a partir de 01/01/2007
cQuery += " AND JBH_TIPO BETWEEN '000015' AND '000016'"                          //Dentro dos c๓digos padrใo: 000015-Calouro ou 000016-Veteranos 
cQuery += " AND E1_FILIAL  = '"+xFilial("SE1")+"' AND SE1.D_E_L_E_T_ = '*'"      //Cujo Boleto foi deletado
cQuery += " AND E1_NUMRA   = JBH_CODIDE"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )
	
Begin Transaction    
Set (11, "OFF") 
SE1->(dbSetOrder(1))

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" titulos..." )
	
	SE1->(dbGoTo((cAlias)->RECSE1))
	SE1->(RecLock("SE1",.F.))
	SE1->(dbRecall())              //Tira a exclusใo dos tํtulos no Banco de Dados
	SE1->(MsUnLock())
	

	AcaLog( cLogFile, "  Titulo "+(cAlias)->E1_PREFIXO + (cAlias)->E1_NUM + " Parcela: " + (cAlias)->E1_PARCELA + " Tipo: " + (cAlias)->E1_TIPO + " regulazirado." )
	(cAlias)->( dbSkip() )
end
Set (11, "ON") 
End Transaction
(cAlias)->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx112462  บAutor  ณCristiane Tuji      บ Data ณ 02/Maio/2007บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo do JBE_ATIVO dos alunos que tiveram requerimentos บฑฑ
ฑฑบ          ณdeferidos de Trancamento de Matrํcula e ำbito e nใo tiveram บฑฑ
ฑฑบ          ณa Situa็ใo Alterada 										  บฑฑ	
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx112462()
FixWindow( 112462, {|| F112462G() } )
Return

Static Function F112462G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0
Local lOracle	:= "ORACLE" $ TCGetDB()

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  ณMonta a query para identificar os alunos afetados                         ณ
  ณAlunos que continuam com JBE_ATIVO=1 (Matriculado) e tiveram requerimentosณ
  ณdeferidos do tipo: Trancamento de Matrํcula (000019) ou ำbito (000011).   ณ
  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
                                                        
cQuery := "SELECT DISTINCT JBE.R_E_C_N_O_ RECJBE, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JBE_NUMRA, JBH_NOME, JBE_ATIVO, JBH_STATUS, JBH_TIPO  "
cQuery += " FROM "
cQuery +=RetSQLName("JBH")+" JBH, "
cQuery +=RetSQLName("JBE")+" JBE, "
cQuery +=RetSQLName("SYP")+" SYP "
cQuery += " WHERE JBH_FILIAL = '"+xFilial("JBH")+"' AND JBH_STATUS = '1' " 
cQuery += " AND JBE_ATIVO = '1'"
cQuery += " AND (JBH_TIPO  = '000011' OR JBH_TIPO = '000019' OR JBH_TIPO = '000020' OR JBH_TIPO = '000021')"    //Dentro dos c๓digos padrใo: 000011-ำbito ou 000019-Trancamento ou 000020-Cancelamento de Matrํcula ou 000022-Desist๊ncia de Curso
cQuery += " AND YP_SEQ = '001'"
cQuery += " AND JBE_NUMRA = JBH_CODIDE"
cQuery += " AND JBH_MEMO2 = YP_CHAVE"                
If lOracle
	cQuery += " AND JBE_CODCUR=SUBSTR(YP_TEXTO,1,6)" 
Else
	cQuery += " AND JBE_CODCUR=SUBSTRING(YP_TEXTO,1,6)"      
Endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )
	
Begin Transaction 

dbSelectArea("JBE")   

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" alunos..." )
	
	JBE->(dbGoTo((cAlias)->RECJBE))

	IF (cAlias)->JBH_TIPO == '000019'
		JBE->(RecLock("JBE",.F.))
		JBE->JBE_ATIVO := "4"              //Muda o JBE_ATIVO PARA 4-TRANCADO
		JBE->(MsUnLock())
	ELSEIF (cAlias)->JBH_TIPO == '000020'
		JBE->(RecLock("JBE",.F.))
		JBE->JBE_ATIVO := "6"              //Muda o JBE_ATIVO PARA 6-CANCELADO	
		JBE->(MsUnLock())
	ELSEIF (cAlias)->JBH_TIPO == '000021'
		JBE->(RecLock("JBE",.F.))
		JBE->JBE_ATIVO := "7"              //Muda o JBE_ATIVO PARA 7-DESISTสNCIA	
		JBE->(MsUnLock())
	ELSEIF (cAlias)->JBH_TIPO == '000011'
		JBE->(RecLock("JBE",.F.))
		JBE->JBE_ATIVO := "8"              //Muda o JBE_ATIVO PARA 8-ำBITO	
		JBE->(MsUnLock())
	ENDIF
	
	AcaLog( cLogFile, "  Aluno "+(cAlias)->JBE_NUMRA + " - " + (cAlias)->JBH_NOME + " Status regulazirado." )
	
	// Recalcula a quantidade de vagas do curso
	ACM010Rec( (cAlias)->JBE_CODCUR, (cAlias)->JBE_PERLET, (cAlias)->JBE_TURMA, (cAlias)->JBE_HABILI )

	(cAlias)->( dbSkip() )

End
End Transaction
(cAlias)->( dbCloseArea() )
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx124910  บAutor  ณMichelle Rolli      บ Data ณ 18/Abr/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste fix corrigira as disciplinas de Sub-Turma              บฑฑ
ฑฑบ          ณduplicadas e que nใo tem Sub-Turma na JBL                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx124910()
FixWindow( 124910, {|| F124910G() } )
Return

Static Function F124910G()
Local cQuery := ""
Local cSub	 := ""
Local cChave := ""
Local aJBL	 := {}
Local aJC7	 := {}
Local i		 := 0
Local j		 := 0
Local nPos	 := 0
Local nPesq	 := TamSX3("JC7_NUMRA")[1]+TamSX3("JC7_CODCUR")[1]+TamSX3("JC7_PERLET")[1]+TamSX3("JC7_HABILI")[1]+TamSX3("JC7_TURMA")[1]+1

JBL->(DbSetOrder(1)) //JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS
JC7->(DbSetOrder(1)) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP

cQuery+= "SELECT DISTINCT JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA,  JBL_CODDIS, JBL_SUBTUR
cQuery+= "FROM " + RetSQLName("JBL") + " JBL, " + RetSQLName("JAR") + " JAR "
cQuery+= "WHERE JAR_FILIAL = JBL_FILIAL "
cQuery+= "AND JAR_FILIAL = '"+xFilial("JAR")+"' "
cQuery+= "AND JAR_CODCUR = JBL_CODCUR "
cQuery+= "AND JAR_PERLET = JBL_PERLET "
cQuery+= "AND JAR_HABILI = JBL_HABILI "
cQuery+= "AND JAR_ANOLET = '2007' "
cQuery+= "AND JAR_PERIOD = '01' "
cQuery+= "AND JBL_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JAR.D_E_L_E_T_ = ' ' "
cQuery+= "AND JBL.D_E_L_E_T_ = ' ' "
cQuery+= "AND JBL_CODDIS IN "
cQuery+= "(SELECT JBL_CODDIS "
cQuery+= "FROM " + RetSQLName("JBL") + " JBL2 "
cQuery+= "WHERE JBL_FILIAL = JBL.JBL_FILIAL "
cQuery+= "AND JBL_FILIAL = '"+xFilial("JBL")+"' "
cQuery+= "AND JBL_CODCUR = JBL.JBL_CODCUR "
cQuery+= "AND JBL_PERLET = JBL.JBL_PERLET "
cQuery+= "AND JBL_HABILI = JBL.JBL_HABILI "
cQuery+= "AND JBL_TURMA  = JBL.JBL_TURMA "
cQuery+= "AND JBL_CODDIS = JBL.JBL_CODDIS "
cQuery+= "AND JBL_SUBTUR = '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JBL2.D_E_L_E_T_ = ' ') "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJBL", .F., .F. )

While _QRYJBL->(!Eof())
	cSub := ""
	aJBL := {}
	If JBL->(DbSeek(xFilial("JBL")+_QRYJBL->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)))
		While JBL->(!Eof()) .And. JBL->(JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS) == xFilial("JBL")+_QRYJBL->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
			If Empty(JBL->JBL_SUBTUR)
				
				cSub := Iif(Alltrim(_QRYJBL->JBL_SUBTUR	)=="SUB1", "SUB2","SUB1")
				
				RecLock("JBL", .F.)
				JBL->JBL_SUBTUR := _QRYJBL->JBL_SUBTUR
				JBL->(MsUnlock())

				AcaLog(cLogFile, "REGISTRO JBL ATUALIZADO: " + Alltrim(Str(JBL->(Recno()))))
				
				For i := 1 To JBL->(FCount())
					aAdd(aJBL, &(JBL->(Field(i))))
				Next i
				
				RecLock("JBL", .T.)	
				
				For i := 1 To JBL->(FCount())
					JBL->(FieldPut(i,aJBL[i]))
				Next i
				JBL->JBL_ITEM := F124910H(JBL->JBL_CODCUR, JBL->JBL_PERLET,JBL->JBL_HABILI, JBL->JBL_TURMA, JBL->JBL_DIASEM)
				JBL->JBL_SUBTUR := cSub
				JBL->(MsUnlock())    
				AcaLog(cLogFile, "REGISTRO JBL INCLUIDO: " + Alltrim(Str(JBL->(Recno()))))			
			Endif
			JBL->(DbSkip())
		End
	Endif
	
	JC7->(DbSetOrder(2)) //JC7_FILIAL+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP
	//Atualiza a JC7 de cursos regulares (a disciplina sera atualizada com a SUBTURMA)
	If JC7->(DbSeek(xFilial("JC7")+_QRYJBL->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)))
		While JC7->(!Eof()) .And. JC7->(JC7_FILIAL+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) == _QRYJBL->(xFilial("JBL")+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
			If Empty(JC7->JC7_SUBTUR)
				RecLock("JC7", .F.)
				JC7->JC7_SUBTUR := F124910Sub(JC7->JC7_NUMRA, JC7->JC7_CODCUR, JC7->JC7_PERLET, JC7->JC7_HABILI, JC7->JC7_TURMA, JC7->JC7_DISCIP)
				JC7->(MsUnlock())
				AcaLog(cLogFile, "REGISTRO JC7 ATUALIZADO: " + Alltrim(Str(JC7->(Recno()))))				
			Endif
			JC7->(DbSkip())
		End
	Endif

	JC7->(DbSetOrder(6)) //JC7_FILIAL+JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP
	//Atualiza a JC7 de outros cursos (a disciplina sera atualizada com a SUBTURMA)
	If JC7->(DbSeek(xFilial("JC7")+_QRYJBL->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)))
		While JC7->(!Eof()) .And. JC7->(JC7_FILIAL+JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) == _QRYJBL->(xFilial("JBL")+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
			If Empty(JC7->JC7_SUBTUR)
				RecLock("JC7", .F.)
				JC7->JC7_SUBTUR := F124910Sub(JC7->JC7_NUMRA, JC7->JC7_OUTCUR, JC7->JC7_OUTPER, JC7->JC7_OUTHAB, JC7->JC7_OUTTUR, JC7->JC7_DISCIP)
				JC7->(MsUnlock())
				AcaLog(cLogFile, "REGISTRO JC7 ATUALIZADO: " + Alltrim(Str(JC7->(Recno()))))				
			Endif
			JC7->(DbSkip())
		End
	Endif
	_QRYJBL->(DbSkip())
End
_QRYJBL->(DbCloseArea())

//EXCLUIR SUBTURMAS DIFERENTES PARA A MESMA DISCIPLINA
cQuery:= "SELECT DISTINCT JC7_NUMRA, JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA,  JC7_DISCIP, JC7_SUBTUR, 1 JC7_SIT
cQuery+= "FROM "+RetSQLName("JBE")+" JBE, "+RetSQLName("JC7")+" JC7 "
cQuery+= "WHERE JBE_FILIAL = JC7_FILIAL "
cQuery+= "AND JBE_FILIAL ='"+xFilial("JBE")+"' "
cQuery+= "AND JBE_CODCUR = JC7_CODCUR "
cQuery+= "AND JBE_PERLET = JC7_PERLET "
cQuery+= "AND JBE_HABILI = JC7_HABILI "
cQuery+= "AND JBE_TURMA  = JC7_TURMA "
cQuery+= "AND JBE_SUBTUR = JC7_SUBTUR "     
cQuery+= "AND JBE_NUMRA  = JC7_NUMRA "
cQuery+= "AND JBE_ANOLET = '2007' "
cQuery+= "AND JBE_PERIOD = '01' "
cQuery+= "AND JBE_ATIVO  = '1' "
cQuery+= "AND JBE_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JC7_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JBE.D_E_L_E_T_ = ' ' "
cQuery+= "AND JC7.D_E_L_E_T_ = ' ' "
cQuery+= "AND JC7_NUMRA IN "
cQuery+= "(SELECT JC7_NUMRA "
cQuery+= "FROM "+RetSQLName("JC7")+" JC72 "
cQuery+= "WHERE JC7_FILIAL = JC7.JC7_FILIAL "
cQuery+= "AND JC7_NUMRA  = JC7.JC7_NUMRA "
cQuery+= "AND JC7_CODCUR = JC7.JC7_CODCUR "
cQuery+= "AND JC7_PERLET = JC7.JC7_PERLET "
cQuery+= "AND JC7_HABILI = JC7.JC7_HABILI "
cQuery+= "AND JC7_TURMA  = JC7.JC7_TURMA "
cQuery+= "AND JC7_DISCIP = JC7.JC7_DISCIP "
cQuery+= "AND JC7_SUBTUR <> JC7.JC7_SUBTUR "
cQuery+= "AND JC7_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JC72.D_E_L_E_T_ = ' ') "
cQuery+= "UNION "
cQuery+= "SELECT DISTINCT JC7_NUMRA, JC7_OUTCUR JC7_CODCUR, JC7_OUTPER JC7_PERLET, JC7_OUTHAB JC7_HABILI, JC7_OUTTUR JC7_TURMA,  JC7_DISCIP, JC7_SUBTUR, 2 JC7_SIT "
cQuery+= "FROM "+RetSQLName("JBE")+" JBE, "+RetSQLName("JC7")+" JC7 "
cQuery+= "WHERE JBE_FILIAL = JC7_FILIAL "
cQuery+= "AND JBE_FILIAL ='"+xFilial("JBE")+"' "
cQuery+= "AND JBE_CODCUR = JC7_OUTCUR "
cQuery+= "AND JBE_PERLET = JC7_OUTPER "
cQuery+= "AND JBE_HABILI = JC7_OUTHAB "
cQuery+= "AND JBE_TURMA  = JC7_OUTTUR "
cQuery+= "AND JBE_SUBTUR = JC7_SUBTUR "   
cQuery+= "AND JBE_NUMRA  = JC7_NUMRA  "
cQuery+= "AND JBE_ANOLET = '2007' "
cQuery+= "AND JBE_PERIOD = '01' "
cQuery+= "AND JBE_ATIVO  = '1' "
cQuery+= "AND JBE_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JC7_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JBE.D_E_L_E_T_ = ' ' "
cQuery+= "AND JC7.D_E_L_E_T_ = ' ' "
cQuery+= "AND JC7_NUMRA IN "
cQuery+= "(SELECT JC7_NUMRA "
cQuery+= "FROM "+RetSQLName("JC7")+" JC72 "
cQuery+= "WHERE JC7_FILIAL = JC7.JC7_FILIAL "
cQuery+= "AND JC7_NUMRA  = JC7.JC7_NUMRA "
cQuery+= "AND JC7_CODCUR = JC7.JC7_OUTCUR "
cQuery+= "AND JC7_PERLET = JC7.JC7_OUTPER "
cQuery+= "AND JC7_HABILI = JC7.JC7_OUTHAB "
cQuery+= "AND JC7_TURMA  = JC7.JC7_OUTTUR "
cQuery+= "AND JC7_DISCIP = JC7.JC7_DISCIP "
cQuery+= "AND JC7_SUBTUR <> JC7.JC7_SUBTUR "
cQuery+= "AND JC7_SUBTUR <> '"+Space(TamSX3("JBL_SUBTUR")[1])+"' "
cQuery+= "AND JC72.D_E_L_E_T_ = ' ') "
cQuery+= "ORDER BY JC7_NUMRA, JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_SIT "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJC7", .F., .F. )

While _QRYJC7->(!Eof())
	nPos := aScan(aJC7, {|x| x[1] == _QRYJC7->(JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+Alltrim(JC7_DISCIP)+Str(JC7_SIT))})
	If nPos == 0
		aAdd(aJC7,{_QRYJC7->(JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+Alltrim(JC7_DISCIP)+Str(JC7_SIT)), {_QRYJC7->JC7_SUBTUR}})
	Else
		aAdd(aJC7[nPos], {_QRYJC7->JC7_SUBTUR})
	Endif
	_QRYJC7->(DbSkip())
End		
_QRYJC7->(DbCloseArea())

For i := 1 to Len(aJC7)
	If Right(aJC7[i,1],1)=="1"
		cSubTur := Posicione("JBE", 3, xFilial("JBE")+"1"+Substring(aJC7[i,1],1,Len(aJC7[i,1])-1), "JBE_SUBTUR")
	Else
		Posicione("JC7",8,xFilial("JC7")+"1"+Substring(aJC7[i,1],1,Len(aJC7[i,1])-1), "JC7_SUBTUR")
		cSubTur := Posicione("JBE", 3, xFilial("JBE")+"1"+JC7->(JC7_NUMRA+JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP), "JBE_SUBTUR")
	Endif
	For j := 2 to len(aJC7[i])
		If aJC7[i,j,1] <> cSubTur
			If Right(aJC7[i,1],1)=="1"
				JC7->(DbSetOrder(1)) //CodCur
			Else
				JC7->(DbSetOrder(8)) //OutCur
			Endif
			JC7->(DbSeek(xFilial("JC7")+Substring(aJC7[i,1],1,nPesq+TamSX3("JC7_DISCIP")[1]-1)))
			While JC7->(!Eof()) .And. JC7->(JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) == xFilial("JC7")+Substring(aJC7[i,1],1,nPesq+TamSX3("JC7_DISCIP")[1]-1)
				If !Empty(JC7->JC7_SUBTUR) .And. JC7->JC7_SUBTUR <> cSubTur
					RecLock("JC7",.F.)
					JC7->(DbDelete())
					JC7->(MsUnlock())
					AcaLog(cLogFile, "REGISTRO JC7 EXCLUIDO: " + Alltrim(Str(JC7->(Recno()))))
				Endif
				JC7->(DbSkip())
 			End
	 	Endif
	Next j
Next i

//F124910I() 
F124910j()
Return

Static Function F124910H(cCodCur, cPerlet, cHabili, cTurma, cDiaSem)
//Retorna o codigo do JBL_ITEM
Local cQuery   := ""
Local nItemJBL := 0
cQuery := "Select Max( JBL_ITEM ) JBL_ITEM "
cQuery += "  From "+RetSQLName("JBL")+" JBL "
cQuery += " Where JBL_FILIAL = '"+xFilial("JBL")+"' "
cQuery += "   and JBL_CODCUR = '"+cCodCur+"' "
cQuery += "   and JBL_PERLET = '"+cPerlet+"' "
cQuery += "   and JBL_HABILI = '"+cHabili+"' "
cQuery += "   and JBL_TURMA  = '"+cTurma+"' "
cQuery += "   and JBL_DIASEM = '"+cDiaSem+"'
cQuery += "   and D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "QRYJBL", .T., .T. )
if QRYJBL->( !eof() )
	nItemJBL := Val( QRYJBL->JBL_ITEM )+1
else
	nItemJBL := 1
endif
QRYJBL->(DbCloseArea())
Return StrZero( nItemJBL, 2 )

/*Static Function F124910I()
Local cQuery := ""

cQuery := "SELECT DISTINCT JBE.R_E_C_N_O_ RECJBL, JC7_SUBTUR "
cQuery += " FROM " + RetSqlName("JBE") + " JBE, " + RetSqlName("JC7") + " JC7 "
cQuery += " WHERE JBE_FILIAL = '"+xFilial("JBE")+"'"
cQuery += " AND JC7_NUMRA = JBE.JBE_NUMRA "
cQuery += " AND JC7_CODCUR = JBE.JBE_CODCUR "
cQuery += " AND JC7_PERLET = JBE.JBE_PERLET "
cQuery += " AND JC7_HABILI = JBE.JBE_HABILI "
cQuery += " AND JC7_TURMA = JBE.JBE_TURMA "
cQuery += " AND JC7_SUBTUR <> JBE.JBE_SUBTUR "
cQuery += " AND JC7_SUBTUR <> '"+Space(TamSX3("JC7_SUBTUR")[1])+"' "
cQuery += " AND JBE_ATIVO = '1' "
cQuery += " AND JBE_ANOLET = '2007' "
cQuery += " AND JBE_PERIOD = '01' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JC7_FILIAL = JBE.JBE_FILIAL "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "_QRYJBE", .T., .T. )

While _QRYJBE->(!Eof())
	JBE->(DBGoto(_QRYJBE->RECJBL))
	If RecLock("JBE",.F.)
		JBE->JBE_SUBTUR := _QRYJBE->JC7_SUBTUR
		JBE->(MsUnlock()) 	
		AcaLog(cLogFile, "REGISTRO JBE ATUALIZADO: " + Alltrim(Str(JBE->(Recno()))))
	Endif
	_QRYJBE->(DbSkip())
End

_QRYJBE->(DbCloseArea())

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx124910  บAutor  ณMichelle Rolli      บ Data ณ 18/Abr/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste fix exclui a disciplina                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function F124910J()
Local cQuery := ""
                             
//JBL
cQuery := "UPDATE " + RetSqlName("JBL")
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE JBL_FILIAL = '02'"  
cQuery += "   AND JBL_CODCUR = '000206' "
cQuery += "   AND JBL_PERLET = '05' "
cQuery += "   AND JBL_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")         

//JC7
cQuery := "UPDATE " + RetSqlName("JC7")
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE JC7_FILIAL = '02'"  
cQuery += "   AND JC7_CODCUR = '000206' "
cQuery += "   AND JC7_PERLET = '05' "
cQuery += "   AND JC7_DISCIP = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JC7 - OUTCUR
cQuery := "UPDATE " + RetSqlName("JC7")
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE JC7_FILIAL = '02'"  
cQuery += "   AND JC7_OUTCUR = '000206' "
cQuery += "   AND JC7_OUTTUR = '05' "
cQuery += "   AND JC7_OUTDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")                

//JBR
cQuery := "UPDATE " + RetSqlName("JBR")
cQuery += " SET D_E_L_E_T_ = '*' "         
cQuery += " WHERE JBR_FILIAL = '02'"  
cQuery += "   AND JBR_CODCUR = '000206' "
cQuery += "   AND JBR_PERLET = '05' "
cQuery += "   AND JBR_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JBS
cQuery := "UPDATE " + RetSqlName("JBS")
cQuery += " SET D_E_L_E_T_ = '*' "        
cQuery += " WHERE JBS_FILIAL = '02'"  
cQuery += "   AND JBS_CODCUR = '000206' "
cQuery += "   AND JBS_PERLET = '05' "
cQuery += "   AND JBS_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JD9
cQuery := "UPDATE " + RetSqlName("JD9")
cQuery += " SET D_E_L_E_T_ = '*' "         
cQuery += " WHERE JD9_FILIAL = '02'"  
cQuery += "   AND JD9_CODCUR = '000206' "
cQuery += "   AND JD9_PERLET = '05' "
cQuery += "   AND JD9_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JDA
cQuery := "UPDATE " + RetSqlName("JDA")
cQuery += " SET D_E_L_E_T_ = '*' " 
cQuery += " WHERE JDA_FILIAL = '02'"  
cQuery += "   AND JDA_CODCUR = '000206' "
cQuery += "   AND JDA_PERLET = '05' "
cQuery += "   AND JDA_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JDB
cQuery := "UPDATE " + RetSqlName("JDB")
cQuery += " SET D_E_L_E_T_ = '*' "  
cQuery += " WHERE JDB_FILIAL = '02'"  
cQuery += "   AND JDB_CODCUR = '000206' "
cQuery += "   AND JDB_PERLET = '05' "
cQuery += "   AND JDB_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JDC
cQuery := "UPDATE " + RetSqlName("JDC")
cQuery += " SET D_E_L_E_T_ = '*' "     
cQuery += " WHERE JDC_FILIAL = '02'"  
cQuery += "   AND JDC_CODCUR = '000206' "
cQuery += "   AND JDC_PERLET = '05' "
cQuery += "   AND JDC_CODDIS = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)  
TCSQLExec("COMMIT")

//JCG
cQuery := "UPDATE " + RetSqlName("JCG")
cQuery += " SET D_E_L_E_T_ = '*' "   
cQuery += " WHERE JCG_FILIAL = '02'"  
cQuery += "   AND JCG_CODCUR = '000206' "
cQuery += "   AND JCG_PERLET = '05' "
cQuery += "   AND JCG_DISCIP = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery) 
TCSQLExec("COMMIT")   

//JCH
cQuery := "UPDATE " + RetSqlName("JCH")
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE JCH_FILIAL = '02'"  
cQuery += "   AND JCH_CODCUR = '000206' "
cQuery += "   AND JCH_PERLET = '05' "
cQuery += "   AND JCG_DISCIP = 'GPRC2P - 4     '"
cQuery += "   AND D_E_L_E_T_ = ' ' "
TCSQLExec(cQuery)   
TCSQLExec("COMMIT")
                       
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF124910SubบAutor  ณMichelle Rolli      บ Data ณ 18/Abr/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a subturma do aluno                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function F124910Sub(cNumra, cCodCur, cPerlet, cHabili, cTurma, cDiscip)
Local cQuery	:= ""
Local cSubtur	:= ""
Local aArea		:= GetArea()

cQuery := "SELECT DISTINCT JC7_SUBTUR FROM "
cQuery += RetSqlName("JC7")
cQuery += " WHERE JC7_FILIAL = '"+xFilial("JC7")+"' "
cQuery += " AND JC7_NUMRA =  '"+cNumra +"' "
cQuery += " AND JC7_CODCUR = '"+cCodCur+"' "
cQuery += " AND JC7_PERLET = '"+cPerlet+"' "
cQuery += " AND JC7_HABILI = '"+cHabili+"' "
cQuery += " AND JC7_TURMA  = '"+cTurma +"' "
cQuery += " AND JC7_DISCIP = '"+cDiscip+"' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND JC7_SUBTUR <> '"+Space(TamSx3("JC7_SUBTUR")[1])+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "_QRYJC7", .T., .T. )
If _QRYJC7->(!Eof())
	cSubTur := _QRYJC7->JC7_SUBTUR
Endif
_QRYJC7->(DbCloseArea())
DbSelectArea("JC7")
RestArea(aArea)

Return cSubTur                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF123177   บAutor  ณMichelle Rolli      บ Data ณ 23/Mai/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche a JC7 com o mesmo Professor da JBL                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx123177()
FixWindow( 123177, {|| F123177A() } )
Return                         

Static Function F123177A()
Local cQuery	:= ""

cQuery:= "SELECT DISTINCT JC7.R_E_C_N_O_ JC7REC, 1 CUR   "
cQuery+= " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE " 
cQuery+= "WHERE JC7_FILIAL = '"+xFilial("JC7")+"' "
cQuery+= " AND JC7_FILIAL = JBE.JBE_FILIAL "
cQuery+= " AND JC7_NUMRA  = JBE.JBE_NUMRA    "
cQuery+= " AND JC7_CODCUR = JBE.JBE_CODCUR    "
cQuery+= " AND JC7_PERLET = JBE.JBE_PERLET "
cQuery+= " AND JC7_HABILI = JBE.JBE_HABILI "
cQuery+= " AND JC7_TURMA  = JBE.JBE_TURMA "
cQuery+= " AND JC7.JC7_OUTCUR = '     ' "
cQuery+= " AND JBE_PERIOD     = '01' "
cQuery+= " AND JBE.JBE_ANOLET = '2007'   " //Alunos de 2007
cQuery+= " AND JBE.D_E_L_E_T_ = ' '"
cQuery+= " AND JC7.D_E_L_E_T_ = ' '"
cQuery+= " AND NOT EXISTS (SELECT JBL_CODCUR
cQuery+= " FROM " + RetSQLName("JBL") + " JBL "  
cQuery+= " WHERE JBL_FILIAL = '"+xFilial("JBL")+"' "
cQuery+= " AND JBL_FILIAL = JC7.JC7_FILIAL"
cQuery+= " AND JC7.JC7_NUMRA  = JBE.JBE_NUMRA"
cQuery+= " AND JBL_CODCUR = JC7.JC7_CODCUR"
cQuery+= " AND JBL_PERLET = JC7.JC7_PERLET"
cQuery+= " AND JBL_HABILI = JC7.JC7_HABILI"
cQuery+= " AND JBL_TURMA  = JC7.JC7_TURMA"
cQuery+= " AND JBL_CODDIS = JC7.JC7_DISCIP"
cQuery+= " AND JBL_CODLOC = JC7.JC7_CODLOC"
cQuery+= " AND JBL_CODPRE = JC7.JC7_CODPRE"
cQuery+= " AND JBL_ANDAR  = JC7.JC7_ANDAR"
cQuery+= " AND JBL_CODSAL = JC7.JC7_CODSAL"
cQuery+= " AND JBL_CODHOR = JC7.JC7_CODHOR"
cQuery+= " AND JBL_HORA1  = JC7.JC7_HORA1"
cQuery+= " AND JBL_HORA2  = JC7.JC7_HORA2"
cQuery+= " AND JBL_DIASEM = JC7.JC7_DIASEM "
cQuery+= " AND JBL_MATPRF = JC7.JC7_CODPRF"
cQuery+= " AND JBL_MATPR2 = JC7.JC7_CODPR2"
cQuery+= " AND JBL_MATPR3 = JC7.JC7_CODPR3"
cQuery+= " AND JBL_MATPR4 = JC7.JC7_CODPR4"
cQuery+= " AND JBL_MATPR5 = JC7.JC7_CODPR5"
cQuery+= " AND JBL_MATPR6 = JC7.JC7_CODPR6"
cQuery+= " AND JBL_MATPR7 = JC7.JC7_CODPR7"
cQuery+= " AND JBL_MATPR8 = JC7.JC7_CODPR8"
cQuery+= " AND JBL.D_E_L_E_T_ = ' ')"
cQuery+= " UNION  "//Faz a uniao para trazer tambem alunos de outras grades
cQuery+= " SELECT JC7.R_E_C_N_O_ JC7REC   , 2 CUR  "
cQuery+= " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE " 
cQuery+= " WHERE JC7_FILIAL = '"+xFilial("JC7")+"' "
cQuery+= "     AND JC7_FILIAL = JBE.JBE_FILIAL "
cQuery+= "     AND JC7_NUMRA  = JBE.JBE_NUMRA "
cQuery+= "     AND JC7_CODCUR = JBE.JBE_CODCUR "
cQuery+= "     AND JC7_PERLET = JBE.JBE_PERLET "
cQuery+= "     AND JC7_HABILI = JBE.JBE_HABILI "
cQuery+= "     AND JC7_TURMA  = JBE.JBE_TURMA "
cQuery+= "     AND JBE.JBE_PERIOD = '01'" //Alunos Ativos (1=Sim)
cQuery+= "     AND JBE.JBE_ANOLET = '2007' "  //Alunos de 2007
cQuery+= "     AND JC7.JC7_OUTCUR <> '      '"
cQuery+= "     AND JBE.D_E_L_E_T_ = ' '"
cQuery+= "     AND JC7.D_E_L_E_T_ = ' '"
cQuery+= "     AND NOT EXISTS (SELECT JBL_CODCUR
cQuery+= "				FROM " + RetSQLName("JBL") + " JBL "          
cQuery+= " 				WHERE JBL_FILIAL = '"+xFilial("JBL")+"' "
cQuery+= "   			    AND JBL_FILIAL = JC7.JC7_FILIAL "
cQuery+= "   				AND JC7.JC7_NUMRA = JBE.JBE_NUMRA "
cQuery+= "  				AND JBL_CODCUR = JC7.JC7_OUTCUR   "
cQuery+= "  				AND JBL_PERLET = JC7.JC7_OUTPER "
cQuery+= " 					AND JBL_HABILI = JC7.JC7_OUTHAB "
cQuery+= "  				AND JBL_TURMA  = JC7.JC7_OUTTUR "
cQuery+= "  				AND JBL_CODDIS = JC7.JC7_DISCIP "
cQuery+= "  				AND JBL_FILIAL = JC7.JC7_FILIAL "
cQuery+= "  				AND JBL_CODLOC = JC7.JC7_CODLOC "
cQuery+= "  		    	AND JBL_CODPRE = JC7.JC7_CODPRE "
cQuery+= "  				AND JBL_ANDAR  = JC7.JC7_ANDAR   "
cQuery+= "  				AND JBL_CODSAL = JC7.JC7_CODSAL  "
cQuery+= "  				AND JBL_CODHOR = JC7.JC7_CODHOR "
cQuery+= "  				AND JBL_HORA1  = JC7.JC7_HORA1       "
cQuery+= "  				AND JBL_HORA2  = JC7.JC7_HORA2     "
cQuery+= "  				AND JBL_DIASEM = JC7.JC7_DIASEM    "
cQuery+= "              	AND JBL_MATPRF = JC7.JC7_CODPRF    "
cQuery+= "              	AND JBL_MATPR2 = JC7.JC7_CODPR2    "
cQuery+= "              	AND JBL_MATPR3 = JC7.JC7_CODPR3    "
cQuery+= "              	AND JBL_MATPR4 = JC7.JC7_CODPR4    "
cQuery+= "              	AND JBL_MATPR5 = JC7.JC7_CODPR5    "
cQuery+= "              	AND JBL_MATPR6 = JC7.JC7_CODPR6    "
cQuery+= "              	AND JBL_MATPR7 = JC7.JC7_CODPR7    "
cQuery+= "              	AND JBL_MATPR8 = JC7.JC7_CODPR8    "
cQuery+= "  				AND JBL.D_E_L_E_T_ = ' ')    "


 cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "_QRYJC7", .T., .T. )

While _QRYJC7->(!Eof()) 

JC7->(DBGoto(_QRYJC7->JC7REC))
JBL->( dbSetOrder(1) )	//JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS+JBL_MATPRF	
	If _QRYJC7->CUR == 1
	
		If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) ) ) 
	
		   	While JBL->( !Eof() ) .And. ;
				xFilial("JBL")+JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) == JBL->(JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
			   		If JC7->JC7_SUBTUR == JBL->JBL_SUBTUR	     
						If RecLock("JC7",.F.)
							 JC7->JC7_CODPRF := JBL->JBL_MATPRF
							 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
							 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
							 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
							 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
							 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
							 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
							 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
		                     JC7->(MsUnlock()) 	
						 EndIf
				   EndIf
			 	JBL->(DbSkip())
			 End
		Endif
	Else
		If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) ) ) 
		   
			While JBL->( !Eof() ) .And. ;
				xFilial("JBL")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) == JBL->(JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
			   		If JC7->JC7_SUBTUR == JBL->JBL_SUBTUR	     
						If RecLock("JC7",.F.)
							 JC7->JC7_CODPRF := JBL->JBL_MATPRF
							 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
							 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
							 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
							 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
							 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
							 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
							 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
			                 JC7->(MsUnlock()) 	
				      
					     EndIf
				   EndIf
			 	 JBL->(DbSkip())
			 End
		Endif
	EndIf                 
	     AcaLog(cLogFile, "REGISTRO JC7 ATUALIZADO: " + Alltrim(Str(JC7->(Recno()))))
	     
		_QRYJC7->(DbSkip())		                     
End

_QRYJC7->(DbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF127603   บAutor  ณ Alberto Deviciente บ Data ณ 22/Mai/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReorganiza os valores de JBE_SEQ e JC7_SEQ na base de dados บฑฑ
ฑฑบ			 ณque pode ter sido afetada pelos problemas na ACSequence     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F127603()
FixWindow(127603, {|| F127603Go() } )
Return

Static Function F127603Go()
Local cQuery	:= ""
Local cAtivo	:= ""
Local nJC7Del 	:= 0
Local cSeq		:= ""

if JBE->( FieldPos("JBE_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JBE_SEQ" )
	Return
elseif JC7->( FieldPos("JC7_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JC7_SEQ" )
	Return
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1a Parte - Tira a duplicidade da tabela JC7ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Inicio - 1a. Parte) - Eliminando duplicidade da tabela JC7 *****" )

while .T.

	cQuery := " SELECT MIN(R_E_C_N_O_) AS JC7REC "
	cQuery += " FROM "+RetSQLName("JC7")
	cQuery += " WHERE JC7_FILIAL = '"+xFilial("JC7")+"' AND D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY JC7_FILIAL, JC7_NUMRA, JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_CODLOC, JC7_CODPRE, JC7_ANDAR, JC7_CODSAL, JC7_DIASEM, JC7_HORA1 "
	cQuery += " HAVING COUNT(*) > 1 "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYJC7", .F., .F. )
	
	if QRYJC7->( EoF() )
		QRYJC7->( dbCloseArea() )
		dbSelectArea("JBE")
		Exit
	endif
	
	while QRYJC7->( !EoF() )
		JC7->( dbGoTo( QRYJC7->JC7REC ) )
		RecLock("JC7",.F.)
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7 para impedir duplicidade." )
		JC7->( dbDelete() )
		JC7->( msUnlock() )
		nJC7Del++
		QRYJC7->( dbSkip() )
	end
	
	QRYJC7->( dbCloseArea() )
	
	dbSelectArea("JBE")

End

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Fim - 1a. Parte) *****" )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2a Parte - Reorganiza os SEQ para 001 de quem tem apenas 1 ocorrenciaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Inicio - 2a. Parte) - Reorganiza os SEQ para 001 de quem tem apenas 1 ocorrencia *****" )

cQuery := "select JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA"
cQuery += "  from "+RetSQLName("JBE")
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
cQuery += " group by JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA "
cQuery += "having count(*) = 1"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

JBE->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )

while QRY1->( !eof() )
	
	if JBE->( dbSeek( xFilial("JBE")+QRY1->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) ) )
		if JBE->JBE_SEQ <> "001"
			RecLock("JBE",.F.)
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JBE->(Recno()),10)+" atualizado na JBE. De sequencial ("+JBE->JBE_SEQ+") para o sequencial 001." )
			JBE->JBE_SEQ := "001"
			JBE->( msUnlock() )
		endif
	
		cQuery := "select R_E_C_N_O_ REC"
		cQuery += "  from "+RetSQLName("JC7")
		cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
		cQuery += "   and JC7_NUMRA  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and JC7_CODCUR = '"+JBE->JBE_CODCUR+"'"
		cQuery += "   and JC7_PERLET = '"+JBE->JBE_PERLET+"'"
		cQuery += "   and JC7_HABILI = '"+JBE->JBE_HABILI+"'"
		cQuery += "   and JC7_TURMA  = '"+JBE->JBE_TURMA+"'"
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	    
		while QRY2->( !eof() )
			JC7->( dbGoTo( QRY2->REC ) )
			
			if JC7->JC7_SEQ <> "001"
				RecLock("JC7",.F.)
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7. De sequencial ("+JC7->JC7_SEQ+") para o sequencial 001." )
				JC7->JC7_SEQ := "001"
				JC7->( msUnlock() )
			endif
			
			QRY2->( dbSkip() )
		end
		QRY2->( dbCloseArea() )
		dbSelectArea("JBE")
	endif
	
	QRY1->( dbSkip() )
end
QRY1->( dbCloseArea() )
dbSelectArea("JBE")
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Fim - 2a. Parte) *****" )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3a Parte - Localiza os registros da JBE que possuem mais de uma ocorrencia na base e ainda estao com o JBE_SEQ em branco ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Inicio - 3a. Parte) - Localiza os registros da JBE que possuem mais de uma ocorrencia na base e ainda estao com o JBE_SEQ em branco *****" )

cQuery := "select R_E_C_N_O_ JBEREC"
cQuery += "  from "+RetSQLName("JBE")
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
cQuery += "   and JBE_SEQ = '   '"
cQuery += " order by JBEREC"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYJBE", .F., .F. )

if QRYJBE->( !eof() )
	while QRYJBE->( !eof() )
		JBE->( dbGoTo( QRYJBE->JBEREC ) )
			
		//Busca a proxima sequencia
		cSeq := ACSequence(JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI)
		
		RecLock("JBE",.F.)
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JBE->(Recno()),10)+" atualizado na JBE. De sequencial ("+JBE->JBE_SEQ+") para o sequencial "+cSeq+"." )
		JBE->JBE_SEQ := cSeq
		JBE->( msUnlock() )
		
		QRYJBE->( dbSkip() )
	end
else
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Nenhum registro encontrado." )
endif
QRYJBE->( dbCloseArea() )
dbSelectArea("JBE")
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Fim - 3a. Parte) *****" )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ4a Parte - Localiza JC7 com SEQ invalido (sem JBE correspondente) e busca o JBE_SEQ corretoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Inicio - 4a. Parte) - Localiza JC7 com SEQ invalido (sem JBE correspondente) e busca o JBE_SEQ correto *****" )

cQuery := "select R_E_C_N_O_ REC"
cQuery += "  from "+RetSQLName("JC7")
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
cQuery += "   and not exists ( select JBE_SEQ"
cQuery += "                      from "+RetSQLName("JBE")
cQuery += "                     where JBE_FILIAL = JC7_FILIAL  and D_E_L_E_T_ = ' '"
cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
cQuery += "                       and JBE_PERLET = JC7_PERLET"
cQuery += "                       and JBE_HABILI = JC7_HABILI"
cQuery += "                       and JBE_TURMA  = JC7_TURMA"
cQuery += "                       and JBE_SEQ    = JC7_SEQ )"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

while QRY1->( !eof() )
	JC7->( dbGoTo( QRY1->REC ) )
	
	if JC7->JC7_SITUAC$"1234568A"
		cAtivo := "'1','2','5'"
	else
		cAtivo := "'3','4','6','7','8','9','A','B'"
	endif
	
	cQuery := "select JBE_SEQ"
	cQuery += "  from "+RetSQLName("JBE")
	cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
	cQuery += "   and JBE_NUMRA  = '"+JC7->JC7_NUMRA+"'"
	cQuery += "   and JBE_CODCUR = '"+JC7->JC7_CODCUR+"'"
	cQuery += "   and JBE_PERLET = '"+JC7->JC7_PERLET+"'"
	cQuery += "   and JBE_HABILI = '"+JC7->JC7_HABILI+"'"
	cQuery += "   and JBE_TURMA  = '"+JC7->JC7_TURMA+"'"
	cQuery += "   and JBE_ATIVO in ("+cAtivo+")"
	cQuery += "   and not exists ( select JC7_SEQ"
	cQuery += "                      from "+RetSQLName("JC7")
	cQuery += "                     where JC7_FILIAL = JBE_FILIAL and D_E_L_E_T_ = ' '"
	cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
	cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
	cQuery += "                       and JBE_PERLET = JC7_PERLET"
	cQuery += "                       and JBE_HABILI = JC7_HABILI"
	cQuery += "                       and JBE_TURMA  = JC7_TURMA"
	cQuery += "                       and JBE_SEQ    = JC7_SEQ"
	cQuery += "                       and JC7_DISCIP = '"+JC7->JC7_DISCIP+"'"
	cQuery += "                       and JC7_CODLOC = '"+JC7->JC7_CODLOC+"'"
	cQuery += "                       and JC7_CODPRE = '"+JC7->JC7_CODPRE+"'"
	cQuery += "                       and JC7_ANDAR  = '"+JC7->JC7_ANDAR+"'"
	cQuery += "                       and JC7_CODSAL = '"+JC7->JC7_CODSAL+"'"
	cQuery += "                       and JC7_DIASEM = '"+JC7->JC7_DIASEM+"'"
	cQuery += "                       and JC7_HORA1  = '"+JC7->JC7_HORA1+"' )"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	
	RecLock("JC7",.F.)
	if QRY2->( !eof() )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7. De sequencial ("+JC7->JC7_SEQ+") para o sequencial "+QRY2->JBE_SEQ+"." )
		JC7->JC7_SEQ := QRY2->JBE_SEQ
	else
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7, pois nao possui registro correspondente na JBE." )
		JC7->( dbDelete() )
		nJC7Del++
	endif
	JC7->( msUnlock() )

	QRY2->( dbCloseArea() )
	dbSelectArea("JBE")
	
	QRY1->( dbSkip() )
end
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** (Fim - 4a. Parte) *****" )
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"************************************************************" )
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"***** Qtde. de registros excluidos da tabela JC7: "+Str(nJC7Del)+"." )

QRY1->( dbCloseArea() )
dbSelectArea("JBE")
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF127691   บAutor  ณ Alberto Deviciente บ Data ณ 14/Mai/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o campo filial das tabelas JCP e JCQ.              บฑฑ
ฑฑบ			 ณA nใo-conformidade ocorreu porque gravava a filial sempre emบฑฑ
ฑฑบ			 ณbranco, mesmo qdo. a tabela esta configurado como Exclusiva บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F127691()
FixWindow(127691, {|| F127691Go() } )
Return

Static Function F127691Go()
Local _cEmp 	:= ""
Local _cFil 	:= ""
Local cArquiv 	:= ""
Local cQuery 	:= ""
Local cQuery1 	:= ""

dbSelectArea("JCP")
dbSelectArea("JCQ")

_cEmp 	:= SubStr(RetSQLName("JCP"),4,2)
_cFil 	:= xFilial("JCP")
cArquiv := "web/arquivos/emp"+_cEmp+"fil"+_cFil+"/prof"

//Verifica se a Tabela estah configuada em Modo Exclusivo (E)
dbSelectArea("SX2")
SX2->( dbSetOrder(1) )
if SX2->( dbSeek("JCP") ) .and. SX2->X2_MODO <> "E"
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois a tabela JCP nใo estแ configurada em modo (E) exclusivo" )
	Return
endif

//Buscando os registros afetados na tabela JCP
cQuery 	:= " SELECT R_E_C_N_O_ REC "
cQuery 	+= "   FROM " + RetSQLName("JCP")
cQuery 	+= "  WHERE JCP_ARQUIV LIKE 'web/arquivos/emp"+_cEmp+"fil"+_cFil+"/prof%' "
cQuery 	+= "  AND JCP_FILIAL = '  ' "
cQuery 	+= "  AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )


//Buscando os registros afetados na tabela JCQ
cQuery1 := " SELECT JCQ.R_E_C_N_O_ REC "
cQuery1 += "   FROM " + RetSQLName("JCP") + " JCP, "+ RetSQLName("JCQ") + " JCQ "
cQuery1 += "  WHERE JCP_ARQUIV LIKE 'web/arquivos/emp"+_cEmp+"fil"+_cFil+"/prof%' "
cQuery1	+= "  AND JCP_FILIAL = '  ' "
cQuery1	+= "  AND JCP_FILIAL = JCQ_FILIAL "
cQuery1	+= "  AND JCP_CODARQ = JCQ_CODARQ "
cQuery1 += "  AND JCP.D_E_L_E_T_ = ' ' "
cQuery1 += "  AND JCQ.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), "QRY1", .F., .F. )

//Atualizando registros na tabela JCP...
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela JCP..." )
while QRY->( !Eof() )
	JCP->( dbGoTo( QRY->REC ) )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JCP->(Recno()),10)+" atualizado na JCP. De Filial ("+JCP->JCP_FILIAL+") para filial ("+_cFil+")." )
	RecLock("JCP", .F.)
	JCP->JCP_FILIAL := _cFil
	JCP->( msUnlock() )
	QRY->( dbSkip() )
end

//Atualizando registros na tabela JCQ...
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela JCQ..." )
while QRY1->( !Eof() )
	JCQ->( dbGoTo( QRY1->REC ) )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JCQ->(Recno()),10)+" atualizado na JCQ. De Filial ("+JCQ->JCQ_FILIAL+") para filial ("+_cFil+")." )
	RecLock("JCQ", .F.)
	JCQ->JCQ_FILIAL := _cFil
	JCQ->( msUnlock() )
	QRY1->( dbSkip() )
end

QRY->( dbCloseArea() )
QRY1->( dbCloseArea() )

dbSelectArea("JCP")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACFixPSL  บAutor  ณKaren Honda         บ Data ณ 19/9/07     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix para corre็ใo da alocacao dos candidadatos do processo  บฑฑ
ฑฑบ          |seletivo que pagaram boletos e estao sem aloca็ใo na sala.  บฑฑ
ฑฑบ          |Corre็ใo da base da FAJ                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNil                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Processo Seletivo                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/           
User Function ACFixPSL()                      
	FixWindow(133209, {|| FACFixPSL() } )
Return

Static Function FACFixPSL()
Local cQuery := ""                     
Local cProSel := '080001'                    
Local cCODLOC := '000022'
Local cCodPre := '000001'	
Local cAndar  := '000'
Local cCodSala := " '001','002','003','004' "  
Local lTemLugar := .T.
Local cSeekJA9 := ""

                       
// SELECIONA OS ALUNOS QUE PAGARAM O BOLETO E ESTAO SEM ALOCACAO NA SALA 
cQuery := " SELECT JA1.JA1_CODINS,JA1.JA1_CODSAL,JA1.JA1_TIPDEF,JA1.JA1_TIPREL,JA1.JA1_TPCAND "
cQuery += " FROM "
cQuery += RetSqlName("JA1") + " JA1 " 
cQuery += " WHERE JA1.JA1_FILIAL = '" + xFilial("JA1") + "' "
cQuery += " AND JA1_CODSAL = ' ' "
cQuery += " AND JA1_STATUS = '03' "
cQuery += " AND JA1_PROSEL = '" + cProSel + "' "
cQuery += " AND JA1.D_E_L_E_T_ = ' '  "
cQuery	:=	Changequery(cQuery)                   
dbusearea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TEMPJA1",.F.,.T.)
     
// Este Select ira classificar em ordem Ascendente o Predio/Andar/Sala para poder alocar
cQuery	:= " SELECT  "
cQuery	+= " 		JA9_CODIGO, JA9_DTNOR, " 
cQuery	+= " 		JA9_FASE, JA9_CODLOC, JA9_CODPRE, JA9_ANDAR, JA9_CODSAL, JA9_DSALA,JA9_LUGAR,JA9_LUGOCU, "
cQuery	+= " 		JA9_TIPREL, JA9_TIPDEF, JA9_TPCAND, " 
cQuery	+= " 	    JA9_LUGAR - JA9_LUGOCU  AS QtdeLugarLivre "	
cQuery	+= " FROM "
cQuery	+= 			RetSqlName("JA9") + " JA9 "
cQuery	+= "WHERE "
cQuery	+= 			"     JA9.D_E_L_E_T_ <> '*' "
cQuery	+= 			" AND JA9_FILIAL = '"+xFilial("JA9") +"' "   
cQuery	+= 			" AND JA9_CODIGO  = '"+cProSel+"' "   	
cQuery	+= 			" AND JA9_CODLOC  = '"+cCODLOC+"' "   
cQuery	+= 			" AND JA9_CODPRE  = '"+cCODPre+"' "
cQuery	+= 			" AND JA9_ANDAR	= '"+cAndar+"' "
cQuery	+= 			" AND JA9_CODSAL in ("+cCodSala+")"    	    
cQuery	+= 			" AND JA9_LUGAR - JA9_LUGOCU  > 0 "   	    
cQuery	+= "ORDER BY  JA9_ANDAR ASC,  JA9_LUGAR DESC " 
dbusearea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TEMPJA9",.F.,.T.)

JA1->(DBSetOrder(1)) ////JA1_FILIAL, JA1_CODINS, R_E_C_N_O_, D_E_L_E_T_ 
JA9->(DBSetOrder(3))//JA9_FILIAL, JA9_CODLOC, JA9_CODPRE, JA9_ANDAR, JA9_CODSAL, R_E_C_N_O_, D_E_L_E_T_    

While TEMPJA1->( !Eof() )
	If TEMPJA1->JA1_TIPDEF $ "1|2|3" .or. TEMPJA1->JA1_TIPREL $ '1' .or. TEMPJA1->JA1_TPCAND $ '2'
    	While TEMPJA9->( !Eof() )
    		//localiza sala reservada para candidato com restri็ใo

			IF (TEMPJA1->JA1_TIPDEF $ TEMPJA9->JA9_TIPDEF ) .and. (TEMPJA1->JA1_TIPREL $ TEMPJA9->JA9_TIPREL) .and. (TEMPJA1->JA1_TPCAND $ TEMPJA9->JA9_TPCAND )  	
				cSeekJA9 := xFilial("JA9") + TEMPJA9->JA9_CODLOC+ TEMPJA9->JA9_CODPRE+ TEMPJA9->JA9_ANDAR+ TEMPJA9->JA9_CODSAL
    			If JA9->(DBSeek( cSeekJA9 ))
    				If JA9->JA9_LUGAR - JA9->JA9_LUGOCU > 0
    					Reclock("JA9",.f.)
    					JA9->JA9_LUGOCU = JA9->JA9_LUGOCU + 1   // Incrementa 1 do lugar ocupado
						JA9->(MsUnLock())
						lTemLugar := .T.
    					Exit
    				Else	             
	    				lTemLugar := .F.  
    				EndIf               
    			Else	
	    			lTemLugar := .F.       
    			EndIf		
    		Else
    			lTemLugar := .F.       
    		EndIf	
    		
			TEMPJA9->(DBSkip())
    	EndDo    
    Else
	    lTemLugar := .f.	
    EndIf
    	
    If !lTemLugar                  
       	//aloca็ใo em sala geral

		TEMPJA9->(DBGotop())    

    	While TEMPJA9->( !Eof() )

			cSeekJA9 := xFilial("JA9") + TEMPJA9->JA9_CODLOC+ TEMPJA9->JA9_CODPRE+ TEMPJA9->JA9_ANDAR+ TEMPJA9->JA9_CODSAL
    		If JA9->(DBSeek( cSeekJA9 ))
    			If JA9->JA9_LUGAR - JA9->JA9_LUGOCU > 0
    				Reclock("JA9",.f.)
    				JA9->JA9_LUGOCU = JA9->JA9_LUGOCU + 1   // Incrementa 1 do lugar ocupado
					JA9->(MsUnLock())
					lTemLugar := .T.
    				Exit
    			Else
    				lTemLugar := .F.      
    				TEMPJA9->(DBSkip())
    			EndIf     
    		EndIf	

		EndDo
	EndIf		
 	//Localiza Candidado                    
    // Realoca o Candidato na Tabela JA1 (Candidado), baseado na ordem ( Predio, Andar , Sala )

    If JA1->(DBSeek(xFilial("JA1") + TEMPJA1->JA1_CODINS )) .and. lTemLugar 
		RecLock("JA1",.F.)  
		JA1->JA1_LOCAL  := JA9->JA9_CODLOC
		JA1->JA1_CODPRE := JA9->JA9_CODPRE 
		JA1->JA1_CODAND	:= JA9->JA9_ANDAR
		JA1->JA1_CODSAL := JA9->JA9_CODSAL 
		JA1->(MsUnLock())            
		AcaLog( cLogFile, dtoc(Date())+" "+Time()+" Alocado Candidato: " +TEMPJA1->JA1_CODINS+ " Predio: " +JA9->JA9_CODPRE+ " Andar: " + JA9->JA9_ANDAR + " Sala: " + JA9->JA9_CODSAL)	
	Else	
		AcaLog( cLogFile, dtoc(Date())+" "+Time()+ If(lTemLugar," Candidato " + TEMPJA1->JA1_CODINS + " nใo encontrado"," Nใo encontrado sala vaga") )		
	EndIf                 
    TEMPJA1->(DBSkip())
EndDo 


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACFixICE  บAutor  ณKaren Honda         บ Data ณ 27/9/07     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix para corre็ใo dos lotes de apontamemtos de faltas que   บฑฑ
ฑฑบ          |foram gerados errados,com o campo qtd zerada. O fix irแ     บฑฑ
ฑฑบ          |excluir as tabelas JCV e JCW                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNil                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Processo Seletivo                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/           
User Function ACFixICE()                      
	FixWindow(133831, {|| F133831() } )
Return

Static Function F133831()
Local cQuery := ""                     
            
cQuery := " SELECT JCW.JCW_FILIAL, JCW.JCW_LOTE, JCW.JCW_NUMRA, JCW.JCW_DATA, JCW.JCW_QTD "
cQuery += " FROM  " 
cQuery += RetSqlName("JCW") + " JCW, "
cQuery += RetSqlName("JCV") + " JCV "
cQuery += " WHERE JCW.JCW_FILIAL = '" + xFilial("JCW") + "' "
cQuery += " AND JCV.JCV_FILIAL = '" + xFilial("JCV") + "' "
cQuery += " AND JCV.JCV_LOTE = JCW.JCW_LOTE "
cQuery += " AND JCW.JCW_QTD = 0 " 
cQuery += " AND JCV.JCV_LOTE NOT IN (SELECT DISTINCT JCW_LOTE FROM "
cQuery += RetSqlName("JCW") + " JCW WHERE JCW_FILIAL = '" + xFilial("JCW")+"' AND JCW_QTD <> 0 AND D_E_L_E_T_ = ' ') "
cQuery += " AND JCW.D_E_L_E_T_ = ' ' "
cQuery += " AND JCV.D_E_L_E_T_ = ' ' " 
cQuery := changeQuery(cQuery)       
dbusearea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TEMPJCW",.F.,.T.)
//JCW_FILIAL, JCW_LOTE, JCW_NUMRA, JCW_DATA, JCW_ITEM, R_E_C_N_O_, D_E_L_E_T_
JCW->(DbSetOrder(1))   
//JCV_FILIAL, JCV_LOTE, JCV_OK, JCV_EMISS, R_E_C_N_O_, D_E_L_E_T_
JCV->(DBSerORder(1))
                                         
TEMPJCW->(DBGotop())
While TEMPJCW->( !Eof() ) 
           
	if JCW->(DBSeek(xFilial("JCW") + TEMPJCW->JCW_LOTE+ TEMPJCW->JCW_NUMRA +TEMPJCW->JCW_DATA )) 
		AcaLog( cLogFile, dtoc(Date())+" "+Time()+" Excluindo apontamento do Lote: " +TEMPJCW->JCW_LOTE+ " RA: " +TEMPJCW->JCW_NUMRA+ " Faltas: " + str(TEMPJCW->JCW_QTD) + " Data: " + TEMPJCW->JCW_DATA )		
		RecLock("JCW",.F.)
		JCW->( dbDelete() )
		JCW->( msUnlock() )
	endif   

	
	if JCV->(DBSeek(xFilial("JCV") + TEMPJCW->JCW_LOTE))
		AcaLog( cLogFile, dtoc(Date())+" "+Time()+" Excluindo Lote: " +TEMPJCW->JCW_LOTE )				
		RecLock("JCV",.F.)
		JCV->( dbDelete() )
		JCV->( msUnlock() )
	EndIf
	
	TEMPJCW->(DBSkip())
EndDo                  

Return .T.	
	                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF133885   บAutor  ณ Alberto Deviciente บ Data ณ 27/Set/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o campo JIG_CHAVE e JIF_CHAVE para servicos        บฑฑ
ฑฑบ			 ณespecificos da instituicao. Servics com codigo > 499        บฑฑ
ฑฑบ			 ณAntes esse campo CHAVE nao era gravado para servicos com    บฑฑ
ฑฑบ			 ณcodigo > que 499, entao nao era possivel associar o mesmo   บฑฑ
ฑฑบ			 ณservico para o aluno para o periodo letivo 02 qud o mesmo   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F133885()
FixWindow(133885, {|| F133885Go() } )
Return

Static Function F133885Go()
Local cQuery 	:= ""
Local cQuery1 	:= ""

dbSelectArea("JIF")
dbSelectArea("JIG")

//Buscando os registros que serao afetados na tabela JIF
cQuery := " SELECT JIF.R_E_C_N_O_ RECJIF, JIG_CODCUR, JIG_PERLET "
cQuery += "   FROM "+RetSQLName("JIG")+" JIG, "+RetSQLName("JIF")+ " JIF "
cQuery += "  WHERE JIF_FILIAL = '"+xFilial("JIF")+"' "
cQuery += "    AND JIG_FILIAL = '"+xFilial("JIG")+"' "
cQuery += "    AND JIG_CODPLA = JIF_CODPLA "
cQuery += "    AND JIG_CODSER = JIF_CODSER "
cQuery += "    AND JIG_ITEM   = JIF_ITEM "
cQuery += "    AND JIG_CHAVE = ' ' " //Pega somente registros que estao com o campo CHAVE em branco
cQuery += "    AND JIF_CHAVE = ' ' " 
cQuery += "    AND JIG_CODSER > '499' " //Apenas servicos especificos da instituicao
cQuery += "    AND JIF.D_E_L_E_T_ = ' ' "
cQuery += "    AND JIG.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYJIF", .F., .F. )


//Buscando os registros que serao afetados na tabela JIG
cQuery1 := " SELECT DISTINCT JIG.R_E_C_N_O_ RECJIG "
cQuery1 += "   FROM "+RetSQLName("JIG")+" JIG, "+RetSQLName("JIF")+ " JIF "
cQuery1 += "  WHERE JIF_FILIAL = '"+xFilial("JIF")+"' "
cQuery1 += "    AND JIG_FILIAL = '"+xFilial("JIG")+"' "
cQuery1 += "    AND JIG_CODPLA = JIF_CODPLA "
cQuery1 += "    AND JIG_CODSER = JIF_CODSER "
cQuery1 += "    AND JIG_ITEM   = JIF_ITEM "
cQuery1 += "    AND JIG_CHAVE = ' ' " //Pega somente registros que estao com o campo CHAVE em branco
cQuery1 += "    AND JIF_CHAVE = ' ' " 
cQuery1 += "    AND JIG_CODSER > '499' " //Apenas servicos especificos da instituicao
cQuery1 += "    AND JIF.D_E_L_E_T_ = ' ' "
cQuery1 += "    AND JIG.D_E_L_E_T_ = ' ' "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), "QRYJIG", .F., .F. )

//Atualizando registros na tabela JIF...
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela JIF..." )
while QRYJIF->( !Eof() )
	JIF->( dbGoTo( QRYJIF->RECJIF ) )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JIF->(Recno()),10)+" atualizado na tabela JIF. De chave ("+JIF->JIF_CHAVE+") para chave ("+QRYJIF->JIG_CODCUR+QRYJIF->JIG_PERLET+")." )
	RecLock("JIF", .F.)
	JIF->JIF_CHAVE := QRYJIF->JIG_CODCUR+QRYJIF->JIG_PERLET
	JIF->( msUnlock() )
	QRYJIF->( dbSkip() )
end

//Atualizando registros na tabela JIG...
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela JIG..." )
while QRYJIG->( !Eof() )
	JIG->( dbGoTo( QRYJIG->RECJIG ) )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JIG->(Recno()),10)+" atualizado na tabela JIG. De chave ("+JIG->JIG_CHAVE+") para chave ("+JIG->JIG_CODCUR+JIG->JIG_PERLET+")." )
	RecLock("JIG", .F.)
	JIG->JIG_CHAVE := JIG->JIG_CODCUR+JIG->JIG_PERLET
	JIG->( msUnlock() )
	QRYJIG->( dbSkip() )
end

QRYJIF->( dbCloseArea() )
QRYJIG->( dbCloseArea() )

dbSelectArea("JIG")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F134325  บAutor  ณ Alberto Deviciente บ Data ณ 08/Out/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o campo A1_FILIAL para os clientes que foram       บฑฑ
ฑฑบ			 ณcriados na JC1 (Responsaveis), pois o campo nao era aliment.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F134325()
FixWindow(134325, {|| F134325Go() } )
Return

Static Function F134325Go()
Local cQuery 	:= ""

dbSelectArea("JC1")
dbSelectArea("SA1")

//Verifica se o campo existe na base para esta empresa
if JC1->( FieldPos("JC1_CLIENT") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JC1_CLIENT" )
	Return
endif

//Verifica se a tabela SA1 estแ configurada como Modo (C) Compartilhada ou (E) Exclusivo
if Empty(xFilial("SA1") )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada, pois a tabela SA1 estแ configurada como Modo (C) Compartilhada" )
	Return	
endif


//Deleta SXE e SXF (Controle de Numeracao da tabela SA1)
dbUseArea(.T.,,"SXE","SXE",.F.)

SXE->( dbGoTop() )
While SXE->( !eof() )
	if SXE->XE_ALIAS == "SA1"
		RecLock( "SXE", .F. )
		SXE->( dbDelete() )
		SXE->( msUnlock() )
		Exit
	endif
	SXE->( dbSkip() )
end

dbUseArea(.T.,,"SXF","SXF",.F.)

SXF->( dbGoTop() )
While SXF->( !eof() )
	if SXF->XF_ALIAS == "SA1"
		RecLock( "SXF", .F. )
		SXF->( dbDelete() )
		SXF->( msUnlock() )
		Exit
	endif
	SXF->( dbSkip() )
end

dbSelectArea("JC1")
dbSelectArea("SA1")

//Buscando os registros que serao afetados na tabela SA1
cQuery := "SELECT SA1.R_E_C_N_O_ RECSA1 "
cQuery += "  FROM "+RetSQLName("JC1")+" JC1, "+RetSQLName("SA1")+" SA1 "
cQuery += " WHERE JC1_FILIAL = '"+xFilial("JC1")+"' "
cQuery += "   AND A1_FILIAL = '  ' " //Filtra somente os registros da SA1 que estใo com o campo A1_FILIAL em branco
cQuery += "   AND A1_CGC = JC1_CPF "
cQuery += "   AND A1_COD = JC1_CLIENT "
cQuery += "   AND RTrim(Ltrim(A1_NOME)) = RTrim(LTrim(JC1_NOME)) "
cQuery += "   AND JC1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SA1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYSA1", .F., .F. )

SA1->( dbSetOrder(1) ) //A1_FILIAL+A1_COD+A1_LOJA

//Atualizando registros na tabela SA1...
if QRYSA1->( !Eof() )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela SA1..." )
	while QRYSA1->( !Eof() )
		SA1->( dbGoTo( QRYSA1->RECSA1 ) )
		if !SA1->( dbSeek( xFilial("SA1")+SA1->A1_COD+A1_LOJA ) )
			SA1->( dbGoTo( QRYSA1->RECSA1 ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(SA1->(Recno()),10)+" atualizado na tabela SA1. De filial ("+SA1->A1_FILIAL+") para filial ("+xFilial("SA1")+")." )
			RecLock("SA1", .F.)
			SA1->A1_FILIAL := xFilial("SA1")
			SA1->( msUnlock() )
		endif
		QRYSA1->( dbSkip() )
	end
else
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Nenhum registro encontrado para atualizacao nesta empresa/filial." )
endif

SXE->( dbCloseArea() )
SXF->( dbCloseArea() )
QRYSA1->( dbCloseArea() )

dbSelectArea("JC1")

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F134858  บAutor  ณ Denis D. Almeida บ Data ณ 08/Out/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ       							  บฑฑ
ฑฑบ									  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F134858()
FixWindow(134858, {|| Fix501DB01() } )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix501DB01บAutor  ณDenis D. Almeida    บ Data ณ  11/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix de Banco de Dados que atualiza Status Situac da tabela  บฑฑ
ฑฑบ          ณJGM com o existente na tabela JC7. 						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fix501DB01()  

local lRet     := .t.
local cQuery   := ""  
local cQuery2  := ""
local cQuery3  := ""
//Cria tabela temporแria que armazenarแ os dados jแ gravados    
cQuery := " if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JGM_TEMP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) "
cQuery += " drop table [dbo].[JGM_TEMP] "
cQuery += " CREATE TABLE [JGM_TEMP] ( "
cQuery += " 	[JGM_FILIAL] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_FILIAL_DF] DEFAULT ('  '), "
cQuery += " 	[JGM_NUM]    [varchar] (6) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_NUM_DF] DEFAULT ('      '), "
cQuery += " 	[JGM_ITEM]   [varchar] (2) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_ITEM_DF] DEFAULT ('  '), "
cQuery += " 	[JGM_PERLET] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_PERLET_DF] DEFAULT ('  '), "
cQuery += " 	[JGM_DATA1]  [varchar] (8) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_DATA1_DF] DEFAULT ('        '), "
cQuery += " 	[JGM_DATA2]  [varchar] (8) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_DATA2_DF] DEFAULT ('        '), "
cQuery += " 	[JGM_ANOLET] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_ANOLET_DF] DEFAULT ('    '), "
cQuery += " 	[JGM_PERIOD] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_PERIOD_DF] DEFAULT ('  '), "
cQuery += " 	[JGM_HABILI] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_HABILI_DF] DEFAULT ('      '), "
cQuery += " 	[JGM_DHABIL] [varchar] (60) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_DHABIL_DF] DEFAULT ('                                                            '), "
cQuery += " 	[JGM_CODDIS] [varchar] (15) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_CODDIS_DF] DEFAULT ('               '), "
cQuery += " 	[JGM_SITDIS] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_SITDIS_DF] DEFAULT ('   '), "
cQuery += " 	[JGM_SITUAC] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_SITUAC_DF] DEFAULT (' '), "
cQuery += " 	[JGM_TOTFAL] [float] NOT NULL CONSTRAINT [JGM_TEMP_JGM_TOTFAL_DF] DEFAULT (0), "
cQuery += " 	[JGM_MEDFIM] [float] NOT NULL CONSTRAINT [JGM_TEMP_JGM_MEDFIM_DF] DEFAULT (0), "
cQuery += " 	[JGM_MEDCON] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_MEDCON_DF] DEFAULT ('    '), "
cQuery += " 	[JGM_CODINS] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_CODINS_DF] DEFAULT ('      '), "
cQuery += " 	[JGM_ANOINS] [varchar] (20) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_ANOINS_DF] DEFAULT ('                    '), "
cQuery += " 	[JGM_TIPCUR] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_JGM_TIPCUR_DF] DEFAULT ('   '), "
cQuery += " 	[D_E_L_E_T_] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL CONSTRAINT [JGM_TEMP_D_E_L_E_T__DF] DEFAULT (' '), "
cQuery += " 	[R_E_C_N_O_] [int] NOT NULL CONSTRAINT [JGM_TEMP_R_E_C_N_O__DF] DEFAULT (0), "
cQuery += " 	[R_E_C_D_E_L_] [float] NOT NULL CONSTRAINT [JGM_TEMP_R_E_C_D_E_L__DF] DEFAULT (0), "
cQuery += " 	CONSTRAINT [JGM_TEMP_PK] PRIMARY KEY  CLUSTERED  "
cQuery += " 	( "
cQuery += " 		[R_E_C_N_O_] "
cQuery += " 	) WITH  FILLFACTOR = 90  ON [PRIMARY]  "
cQuery += " ) ON [PRIMARY] "
TcSqlExec( cQuery )
TcSqlExec( "COMMIT" )

//Incio do Processamento de Igualdade De/Para entre tabelas JGM e JC7
cQuery2 := " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='2', "
cQuery2 += "        JGM_ANOINS='UPD' "	
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('1') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += " 	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ')	 "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('2') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='3', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "   FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('2') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ')	 "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('3') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='4', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('3') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('4') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='5', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('4') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('5') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='7', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('5') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('7') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='8', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('6') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('8') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='9', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('7') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('9') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='1', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('8') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('1') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='6', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('9') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('6') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
cQuery2 += "  "
cQuery2 += " UPDATE "+RETSQLNAME("JGM")+" "
cQuery2 += "    SET JGM_SITUAC='A', "
cQuery2 += "        JGM_ANOINS='UPD' "
cQuery2 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "    AND D_E_L_E_T_=' ' "
cQuery2 += "    AND JGM_SITUAC IN ('A') "
cQuery2 += "    AND R_E_C_N_O_ NOT IN  "
cQuery2 += "     	(SELECT R_E_C_N_O_ FROM JGM_TEMP WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' AND D_E_L_E_T_=' ') "
cQuery2 += " INSERT INTO  "
cQuery2 += " JGM_TEMP(JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_) "
cQuery2 += " SELECT 	JGM_FILIAL,JGM_NUM,JGM_ITEM,JGM_PERLET,JGM_DATA1,JGM_DATA2,JGM_ANOLET,JGM_PERIOD, "
cQuery2 += " 	JGM_HABILI,JGM_DHABIL,JGM_CODDIS,JGM_SITDIS,JGM_SITUAC,JGM_TOTFAL,JGM_MEDFIM, "
cQuery2 += " 	JGM_MEDCON,JGM_CODINS,JGM_ANOINS,JGM_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ "
cQuery2 += "    FROM "+RETSQLNAME("JGM")+" "
cQuery2 += "   WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery2 += "     AND D_E_L_E_T_=' ' "
cQuery2 += "     AND JGM_SITUAC IN ('A') "
cQuery2 += "     AND JGM_ANOINS IN ('UPD') "
TcSqlExec( cQuery2 )
TcSqlExec( "COMMIT" )

//Retomando o valor default do campo Anoins
cQuery3 := " UPDATE "+RETSQLNAME("JGM")+" "
cQuery3 += "    SET JGM_ANOINS=' ' "
cQuery3 += "  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery3 += "    AND D_E_L_E_T_=' ' "
cQuery3 += "    AND JGM_ANOINS IN  "
cQuery3 += "        ( SELECT JGM_ANOINS "
cQuery3 += " 	   FROM "+RETSQLNAME("JGM")+" "
cQuery3 += " 	  WHERE JGM_FILIAL='"+XFILIAL("JGM")+"' "
cQuery3 += " 	    AND D_E_L_E_T_=' ' "
cQuery3 += " 	    AND JGM_ANOINS IN ('UPD') ) "
TcSqlExec( cQuery3 )
TcSqlExec( "COMMIT" )

return lRet                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF00001TurnบAutor  ณDenis D. Almeida    บ Data ณ 13/12/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo de cabe็alho de Faltas pois durante as Transfer๊บฑฑ
ฑฑบ			 ณcias o Sistema deletava incorretamente o mesmo			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                    	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F00001Turn()
FixWindow(000000, {|| FixDBTurno() } )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixDBTurnoบAutor  ณDenis D. Almeida    บ Data ณ  13/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua atualiza็ใo de itens relacionados a problema de excluบฑฑ
ฑฑบ          ณsao de cabe็alho de Faltas durante a gera็ใo de Requerimentoบฑฑ
ฑฑบ          ณde Transfer๊ncia de Turno									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FixDBTurno()    

local cQuery  		:= ""
local cQuery2 		:= ""  
local cQuery3 		:= ""
local cQuery4 		:= ""
local cQuery5 		:= "" 
local cQuery6 		:= ""
local cAlias  		:= GetNextAlias()
local cAlias2 		:= GetNextAlias()
local cAlias3 		:= GetNextAlias()  
local aDiscip 		:= {}
local cHabilitacao  := ""
local dData2
local cMatprf2      := ""
local cAula         := ""
local lSeek

cQuery := " select "
cQuery += " 	 jch.jch_codcur, "
cQuery += " 	 jch.jch_perlet, "
cQuery += " 	 jch.jch_habili, "
cQuery += " 	 jch.jch_turma, "
cQuery += " 	 jch.jch_data, "
cQuery += " 	 jch.jch_discip, "	
cQuery += " 	 jch.jch_item "
cQuery += "     from "+retsqlname("jch")+" jch "	 
cQuery += "    where jch.jch_filial='"+xfilial("JCH")+"' "
cQuery += "      and jch.d_e_l_e_t_=' '  " 
cQuery += "      and ( jch.jch_codcur in  "
cQuery += " 		 ( select  "
cQuery += " 			  jcg.jcg_codcur "
cQuery += " 		     from "+retsqlname("jcg")+" jcg "
cQuery += " 		    where jcg.jcg_filial='"+xfilial("JCG")+"' "		 
cQuery += " 		      and jcg.d_e_l_e_t_='*' ) "
cQuery += "         	  and jch.jch_codcur in  "
cQuery += " 		  ( select  "
cQuery += " 			  jbe.jbe_codcur "
cQuery += " 		     from "+retsqlname("jbe")+" jbe "
cQuery += " 		    where jbe.jbe_filial='"+xfilial("JBE")+"' "
cQuery += " 		      and jbe.d_e_l_e_t_=' ' "
cQuery += "       		  and jbe.jbe_ativo = '3' ) ) "
cQuery += " group by  "
cQuery += " 	 jch.jch_codcur, "
cQuery += " 	 jch.jch_perlet, "
cQuery += " 	 jch.jch_habili, "
cQuery += " 	 jch.jch_turma, "
cQuery += " 	 jch.jch_data, "
cQuery += " 	 jch.jch_discip, "
cQuery += " 	 jch.jch_item "
cQuery += " order by jch.jch_codcur, "
cQuery += " 	 jch.jch_item "  
cQuery := ChangeQuery(cQuery)  
if select(cAlias) > 0
	(cAlias)->( dbCloseArea() )	
endif
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

jcg->( dbsetorder(1) )
(cAlias)->( dbgotop() )
while (cAlias)->( !eof() )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณProcura por item de apontamento que ap๓s Transfer๊ncia ณ
	//ณteve seu cabe็alho apagado impossibilitando a digita็ใoณ
	//ณde Faltas para outros Alunos.                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	cQuery2 := " UPDATE "+retsqlname("jcg")+" "
	cQuery2 += "    SET D_E_L_E_T_=' ', "
	cQuery2 += "    R_E_C_D_E_L_=0 "
	cQuery2 += "  WHERE JCG_FILIAL='"+xfilial("JCG")+"' "
	cQuery2 += "    AND D_E_L_E_T_='*' "
	cQuery2 += "    AND JCG_CODCUR='"+(cAlias)->jch_codcur+"' "
	cQuery2 += "    AND JCG_PERLET='"+(cAlias)->jch_perlet+"' "
	cQuery2 += "    AND JCG_HABILI='"+(cAlias)->jch_habili+"' "
	cQuery2 += "    AND JCG_TURMA ='"+(cAlias)->jch_turma+"' "
	cQuery2 += "    AND JCG_DATA  ='"+(cAlias)->jch_data+"' "
	cQuery2 += "    AND JCG_ITEM  ='"+(cAlias)->jch_item+"' "
	TcSqlExec( cQuery2 )
	TcSqlExec( "COMMIT" )
	(cAlias)->( dbskip() )
end

cQuery3 := " select  distinct "
cQuery3 += " 	 jch.jch_numra, "
cQuery3 += " 	 jch.jch_codcur, "
cQuery3 += " 	 jch.jch_perlet, "
cQuery3 += " 	 jch.jch_turma, "
cQuery3 += " 	 jch.jch_habili, "
cQuery3 += " 	 jch.jch_data, "
cQuery3 += "     jch.jch_discip, "
cQuery3 += " 	 jch.jch_hora1, "
cQuery3 += " 	 jch.jch_memo1, "
cQuery3 += " 	 jch.jch_tipo, "
cQuery3 += " 	 jch.jch_qtd, "
cQuery3 += " 	 jch.jch_codava, "
cQuery3 += " 	 jch.jch_matprf, "
cQuery3 += " 	 jch.jch_item, "
cQuery3 += " 	 jch.jch_abnqtd, "
cQuery3 += " 	 jch.jch_hisqtd, "
cQuery3 += " 	 jbetmp.jbe_codcur, "
cQuery3 += " 	 jbetmp.jbe_perlet, "
cQuery3 += " 	 jbetmp.jbe_habili, "
cQuery3 += " 	 jbetmp.jbe_turma, "
cQuery3 += " 	 jch.r_e_c_n_o_ recnojch "
cQuery3 += "from "+retsqlname("JCH")+" jch, "
cQuery3 += " 	(select distinct  "
cQuery3 += " 		jbe.jbe_numra, "
cQuery3 += " 		jbe.jbe_codcur, "
cQuery3 += " 		jbe.jbe_perlet, "
cQuery3 += " 		jbe.jbe_habili, "
cQuery3 += " 		jbe.jbe_turma, "
cQuery3 += " 		jbe.jbe_tipo, "
cQuery3 += " 		jbe.jbe_ativo, "
cQuery3 += " 		jbe.jbe_situac, "
cQuery3 += " 		jbe.jbe_dtmatr, "
cQuery3 += " 		jbe.jbe_anolet, "
cQuery3 += " 		jbe.jbe_period "
cQuery3 += " 	   from "+retsqlname("JBE")+" jbe "	
cQuery3 += " 	  where jbe.jbe_filial='"+xfilial("JBE")+"' "
cQuery3 += " 	    and jbe.d_e_l_e_t_=' ' "
cQuery3 += " 	    and jbe.jbe_numra in  "
cQuery3 += " 		( select  jbe.jbe_numra "
cQuery3 += " 		   from "+retsqlname("JBE")+" jbe "
cQuery3 += " 		  where jbe.jbe_filial='"+xfilial("JBE")+"' "
cQuery3 += " 		    and jbe.d_e_l_e_t_=' ' "
cQuery3 += " 		    and jbe.jbe_ativo='3' ) "
cQuery3 += " 	    and jbe.jbe_ativo='1' "
cQuery3 += " 	    and jbe.jbe_situac='2' ) jbetmp "
cQuery3 += "   where jch.jch_filial='"+xfilial("JCH")+"' "
cQuery3 += "     and jch.d_e_l_e_t_=' ' "
cQuery3 += "     and jch.jch_numra  = jbetmp.jbe_numra "
cQuery3 += "     and jch.jch_codcur != jbetmp.jbe_codcur "
cQuery3 += "     and jch.jch_perlet = jbetmp.jbe_perlet "
cQuery3 += "     and jch.jch_habili = jbetmp.jbe_habili "
cQuery3 += "     and jch.jch_turma  = jbetmp.jbe_turma " 
cQuery3 := ChangeQuery(cQuery3)  
if select(cAlias2) > 0
	(cAlias2)->( dbCloseArea() )	
endif
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery3),cAlias2, .F., .T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGerando informa็๕es relacionadas a Alunos onde o requerimento ณ
//ณde transferencia de turno nใo atualizava os dados corretamenteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
jch->( dbsetorder(1) )
jd2->( dbsetorder(5) )
(cAlias2)->( dbgotop() )
while (cAlias2)->( !eof() )	
	jd2->( dbseek( xfilial("JD2")+(cAlias2)->jbe_codcur+(cAlias2)->jbe_perlet+(cAlias2)->jbe_habili+(cAlias2)->jbe_turma+(cAlias2)->jch_discip ))
	while jd2->( !eof() .and. jd2_filial+jd2_codcur+jd2_perlet+jd2_habili+jd2_turma+jd2_coddis == xfilial("JD2")+(cAlias2)->jbe_codcur+(cAlias2)->jbe_perlet+(cAlias2)->jbe_habili+(cAlias2)->jbe_turma+(cAlias2)->jch_discip )
		if Ascan( aDiscip, {|x| x[1] == jd2->jd2_aula } ) == 0						           
			lSeek := jch->( dbseek( xfilial("JCH")+(cAlias2)->jch_numra+(cAlias2)->jbe_codcur+(cAlias2)->jbe_perlet+(cAlias2)->jbe_habili+(cAlias2)->jbe_turma+dtos(jd2->jd2_data)+jd2->jd2_aula+(cAlias2)->jch_discip ) )
			if lSeek
				reclock("jch", !lSeek )
				jch->jch_filial := xfilial("JCH")
				jch->jch_numra  := (cAlias2)->jch_numra
				jch->jch_codcur := (cAlias2)->jbe_codcur
				jch->jch_perlet := (cAlias2)->jbe_perlet
				jch->jch_turma  := (cAlias2)->jbe_turma
				jch->jch_habili := (cAlias2)->jbe_habili
				jch->jch_discip := (cAlias2)->jch_discip
				jch->jch_hora1  := (cAlias2)->jch_hora1
				jch->jch_tipo 	:= (cAlias2)->jch_tipo
				jch->jch_qtd 	:= (cAlias2)->jch_qtd
				jch->jch_codava := (cAlias2)->jch_codava
				jch->jch_abnqtd := (cAlias2)->jch_abnqtd
				jch->jch_hisqtd := (cAlias2)->jch_hisqtd
				jch->jch_item 	:= jd2->jd2_aula
				jch->jch_data   := jd2->jd2_data
				jch->jch_matprf := jd2->jd2_matprf
				Aadd( aDiscip, { jd2->jd2_aula } )
				jch->( MsUnlock() )
			endif
			exit
		endif
		jd2->( dbskip() )
	end
	(cAlias2)->( dbskip() )
end
aDiscip := {}
cQuery4 := " select distinct "
cQuery4 += " 		jch.jch_filial, "
cQuery4 += " 		jch.jch_codcur, "
cQuery4 += " 		jch.jch_perlet, "			 
cQuery4 += " 		jch.jch_habili, "
cQuery4 += " 		(select distinct jdk_desc from "+retsqlname("JDK")+" where jdk_filial='"+xfilial("JDK")+"' and d_e_l_e_t_=' ' and jdk_codigo=jch.jch_habili) dhabili,	"
cQuery4 += " 		jch.jch_turma, "
cQuery4 += " 		jch.jch_discip, "
cQuery4 += " 		jch.jch_tipo, "
cQuery4 += "  		jch.jch_codava, "
cQuery4 += " 		jch.jch_data, "
cQuery4 += " 		jch.jch_matprf, "				  				 	 			 
cQuery4 += " 		jch.jch_item, "
cQuery4 += " 		'      ' subtur, "
cQuery4 += " 		' ' d_e_l_e_t_ "
cQuery4 += "   from "+retsqlname("jch")+" jch "
cQuery4 += "  where jch.jch_filial='"+xfilial("JCH")+"' "
cQuery4 += "   and  jch.d_e_l_e_t_=' ' "
cQuery4 += "   and ( jch.jch_codcur+jch.jch_perlet+jch.jch_habili+jch.jch_turma+jch.jch_discip+jch.jch_data+jch.jch_item not in  "
cQuery4 += " 			( select distinct "
cQuery4 += " 					 jcg.jcg_codcur+jcg.jcg_perlet+jcg.jcg_habili+jcg.jcg_turma+jcg.jcg_discip+jcg.jcg_data+jcg.jcg_item "		
cQuery4 += " 				from "+retsqlname("JCG")+" jcg "
cQuery4 += " 			   where jcg.jcg_filial='"+xfilial("JCG")+"' "
cQuery4 += " 				 and jcg.d_e_l_e_t_=' ' ) ) "
cQuery4 := ChangeQuery(cQuery4)  
if select(cAlias3) > 0
	(cAlias3)->( dbCloseArea() )	
endif
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery4),cAlias3, .F., .T.)

jcg->( dbsetorder(1) )
jd2->( dbsetorder(5) )
(cAlias3)->( dbgotop() )
while (cAlias3)->( !eof() )	
	 cAula 	  := ""
	 dData2   := Ctod("  /  /  ")
	 cMatprf2 := ""
	 
 	 cQuery5 := " DELETE "
	 cQuery5 += "   FROM "+retsqlname("JCG")+" "
	 cQuery5 += "  WHERE JCG_FILIAL  ='"+xfilial("JCG")+"' "
	 cQuery5 += "    AND D_E_L_E_T_  =' ' "
	 cQuery5 += "    AND JCG_ITEM    ='"+(cAlias3)->jch_item+"' " 
	 cQuery5 += "    AND JCG_CODCUR  ='"+(cAlias3)->jch_codcur+"' "
	 cQuery5 += "    AND JCG_PERLET  ='"+(cAlias3)->jch_perlet+"' "
	 cQuery5 += "    AND JCG_HABILI  ='"+(cAlias3)->jch_habili+"' "
	 cQuery5 += "    AND JCG_TURMA   ='"+(cAlias3)->jch_turma+"' "
	 cQuery5 += "    AND JCG_DISCIP  ='"+(cAlias3)->jch_discip+"' "
	 cQuery5 += "    AND JCG_DATA    ='"+(cAlias3)->jch_data+"' "
	 cQuery5 += "    AND JCG_CODAVA  ='"+(cAlias3)->jch_codava+"' "
	 TcSqlExec( cQuery5 )
	 TcSqlExec( "COMMIT" )
	 
	 cQuery6 := " DELETE "
	 cQuery6 += "   FROM "+retsqlname("JCG")+" "
	 cQuery6 += "  WHERE JCG_FILIAL  ='"+xfilial("JCG")+"' "
	 cQuery6 += "    AND D_E_L_E_T_  =' ' "
	 cQuery6 += "    AND ( JCG_ITEM  =' ' OR JCG_MATPRF =' ' ) " 
	 TcSqlExec( cQuery6 )
	 TcSqlExec( "COMMIT" )                                                                     
	 
	 jd2->( dbseek( xfilial("JD2")+(cAlias3)->jch_codcur+(cAlias3)->jch_perlet+(cAlias3)->jch_habili+(cAlias3)->jch_turma+(cAlias3)->jch_discip ))
	 while jd2->( !eof() .and. jd2_filial+jd2_codcur+jd2_perlet+jd2_habili+jd2_turma+jd2_coddis == xfilial("JD2")+(cAlias3)->jch_codcur+(cAlias3)->jch_perlet+(cAlias3)->jch_habili+(cAlias3)->jch_turma+(cAlias3)->jch_discip ) 
	 	if Ascan( aDiscip, {|x| x[1] == jd2->jd2_aula } ) == 0
		 	cAula 	 := jd2->jd2_aula
		 	dData2   := jd2->jd2_data	    
		 	cMatprf2 := jd2->jd2_matprf
		 	Aadd( aDiscip, { jd2->jd2_aula } )  
		 	exit       
	 	endif
	 	jd2->( dbskip() )
	 end 
	 cHabilitacao := posicione("jar",1,xfilial("JAR")+(cAlias3)->jch_codcur+(cAlias3)->jch_perlet,"jar_habili")
	 //JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR+JCG_MATPRF	
	 if !jcg->( dbseek( xfilial("JCG")+(cAlias3)->jch_codcur+(cAlias3)->jch_perlet+cHabilitacao+(cAlias3)->jch_turma+Dtos(dData2)+cAula+(cAlias3)->jch_discip ) )
		 reclock("jcg", .t.)
		 jcg->jcg_filial := xfilial("JCG")
		 jcg->jcg_codcur := (cAlias3)->jch_codcur
		 jcg->jcg_perlet := (cAlias3)->jch_perlet
		 jcg->jcg_habili := cHabilitacao
		 jcg->jcg_dhabil := (cAlias3)->dhabili
		 jcg->jcg_turma  := (cAlias3)->jch_turma
		 jcg->jcg_discip := (cAlias3)->jch_discip
		 jcg->jcg_tipo   := posicione("jar",1,xfilial("JAR")+(cAlias3)->jch_codcur+(cAlias3)->jch_perlet+jcg->jcg_habili,"jar_apfalt")
		 jcg->jcg_codava := (cAlias3)->jch_codava 
		 jcg->jcg_item 	 := cAula
		 jcg->jcg_data   := dData2
		 jcg->jcg_matprf := cMatprf2
		 jcg->( MsUnlock() )
	 endif 
	(cAlias3)->( dbskip() )
end

if select(cAlias) > 0
	(cAlias)->( dbCloseArea() )	
endif
if select(cAlias2) > 0
	(cAlias2)->( dbCloseArea() )	
endif
if select(cAlias3) > 0
	(cAlias3)->( dbCloseArea() )	
endif

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF137295   บAutor  ณAlberto Deviciente  บ Data ณ 07/Dez/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche a JC7 com o mesmo Professor da JBL                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx137295()
FixWindow( 137295, {|| F137295() } )
Return                         

Static Function F137295()
Local cQuery	:= ""
Local lSubTurma

dbSelectArea("JC7")
dbSelectArea("JBL")

lSubTurma := JC7->(FieldPos("JC7_SUBTUR")) > 0 .and. JBL->(FieldPos("JBL_SUBTUR")) > 0

//Alunos de grade Normal
cQuery := " SELECT DISTINCT JC7.R_E_C_N_O_ RECJC7, 'N' GRADE "
cQuery += "   FROM "+RetSQLName("JC7")+" JC7, "+RetSQLName("JBL")+" JBL "
cQuery += "  WHERE JC7_FILIAL = '"+xFilial("JC7")+"' "
cQuery += "    AND JBL_FILIAL = '"+xFilial("JC7")+"' "
cQuery += "    AND JC7_OUTCUR = '      ' "
cQuery += "    AND JBL_CODCUR = JC7.JC7_CODCUR "
cQuery += "    AND JBL_PERLET = JC7.JC7_PERLET "
cQuery += "    AND JBL_HABILI = JC7.JC7_HABILI "
cQuery += "    AND JBL_TURMA  = JC7.JC7_TURMA "
cQuery += "    AND JBL_CODDIS = JC7.JC7_DISCIP "
cQuery += "    AND JBL_CODLOC = JC7.JC7_CODLOC "
cQuery += "    AND JBL_CODPRE = JC7.JC7_CODPRE "
cQuery += "    AND JBL_ANDAR  = JC7.JC7_ANDAR "
cQuery += "    AND JBL_CODSAL = JC7.JC7_CODSAL "
cQuery += "    AND JBL_CODHOR = JC7.JC7_CODHOR "
cQuery += "    AND JBL_HORA1  = JC7.JC7_HORA1 "
cQuery += "    AND JBL_HORA2  = JC7.JC7_HORA2 "
cQuery += "    AND JBL_DIASEM = JC7.JC7_DIASEM "
cQuery += "    AND (JBL_MATPRF <> JC7.JC7_CODPRF "
cQuery += "     OR  JBL_MATPR2 <> JC7.JC7_CODPR2 "
cQuery += "     OR  JBL_MATPR3 <> JC7.JC7_CODPR3 "
cQuery += "     OR  JBL_MATPR4 <> JC7.JC7_CODPR4 "
cQuery += "     OR  JBL_MATPR5 <> JC7.JC7_CODPR5 "
cQuery += "     OR  JBL_MATPR6 <> JC7.JC7_CODPR6 "
cQuery += "     OR  JBL_MATPR7 <> JC7.JC7_CODPR7 "
cQuery += "     OR  JBL_MATPR8 <> JC7.JC7_CODPR8 ) "
cQuery += "    AND JC7.D_E_L_E_T_ = ' ' "
cQuery += "    AND JBL.D_E_L_E_T_ = ' ' "
if lSubTurma //Se existir Sub-Turma na Base
	cQuery += "    AND JBL_SUBTUR  = JC7.JC7_SUBTUR "
endif
cQuery += "  UNION " //Alunos de Outras grades
cQuery += " SELECT DISTINCT JC7.R_E_C_N_O_ RECJC7, 'O' GRADE "
cQuery += "   FROM "+RetSQLName("JC7")+" JC7, "+RetSQLName("JBL")+" JBL "
cQuery += "   WHERE JC7_FILIAL = '"+xFilial("JC7")+"' "
cQuery += "     AND JBL_FILIAL = '"+xFilial("JC7")+"' "
cQuery += "     AND JC7_OUTCUR <> '      ' "
cQuery += "     AND JBL_CODCUR = JC7.JC7_OUTCUR "
cQuery += "     AND JBL_PERLET = JC7.JC7_OUTPER "
cQuery += "     AND JBL_HABILI = JC7.JC7_OUTHAB "
cQuery += "     AND JBL_TURMA  = JC7.JC7_OUTTUR "
cQuery += "     AND JBL_CODDIS = JC7.JC7_DISCIP "
cQuery += "     AND JBL_CODLOC = JC7.JC7_CODLOC "
cQuery += "     AND JBL_CODPRE = JC7.JC7_CODPRE "
cQuery += "     AND JBL_ANDAR  = JC7.JC7_ANDAR "
cQuery += "     AND JBL_CODSAL = JC7.JC7_CODSAL "
cQuery += "     AND JBL_CODHOR = JC7.JC7_CODHOR "
cQuery += "     AND JBL_HORA1  = JC7.JC7_HORA1 "
cQuery += "     AND JBL_HORA2  = JC7.JC7_HORA2 "
cQuery += "     AND JBL_DIASEM = JC7.JC7_DIASEM "
cQuery += "     AND (JBL_MATPRF <> JC7.JC7_CODPRF "
cQuery += "      OR  JBL_MATPR2 <> JC7.JC7_CODPR2 "
cQuery += "      OR  JBL_MATPR3 <> JC7.JC7_CODPR3 "
cQuery += "      OR  JBL_MATPR4 <> JC7.JC7_CODPR4 "
cQuery += "      OR  JBL_MATPR5 <> JC7.JC7_CODPR5 "
cQuery += "      OR  JBL_MATPR6 <> JC7.JC7_CODPR6 "
cQuery += "      OR  JBL_MATPR7 <> JC7.JC7_CODPR7 "
cQuery += "      OR  JBL_MATPR8 <> JC7.JC7_CODPR8 ) "
cQuery += "     AND JC7.D_E_L_E_T_ = ' ' "
cQuery += "     AND JBL.D_E_L_E_T_ = ' ' "
if lSubTurma //Se existir Sub-Turma na Base
	cQuery += "    AND JBL_SUBTUR  = JC7.JC7_SUBTUR "
endif

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "_QRYJC7", .T., .T. )

if lSubTurma //Se existir Sub-Turma na Base

	While _QRYJC7->( !Eof() )
	
		JC7->(DBGoto(_QRYJC7->RECJC7)) 
		JBL->( dbSetOrder(1) )	//JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS+JBL_MATPRF	
		
		If _QRYJC7->GRADE == "N" //Aluno de Grade Normal
		
			If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) ) ) 
			
			   	While JBL->( !Eof() ) .And. ;
					xFilial("JBL")+JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) == JBL->(JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
				   		If JC7->JC7_SUBTUR == JBL->JBL_SUBTUR	     
							If RecLock("JC7",.F.)
								 JC7->JC7_CODPRF := JBL->JBL_MATPRF
								 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
								 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
								 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
								 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
								 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
								 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
								 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
			                     JC7->(MsUnlock()) 	
							 EndIf
					   EndIf
				 	JBL->(DbSkip())
				 End
				 
			Endif
			
		Else  //Aluno de Outras Grades
			If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) ) ) 
			   
				While JBL->( !Eof() ) .And. ;
					xFilial("JBL")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) == JBL->(JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS)
				   		If JC7->JC7_SUBTUR == JBL->JBL_SUBTUR	     
							If RecLock("JC7",.F.)
								 JC7->JC7_CODPRF := JBL->JBL_MATPRF
								 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
								 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
								 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
								 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
								 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
								 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
								 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
				                 JC7->(MsUnlock()) 	
						     EndIf
					   EndIf
				 	 JBL->(DbSkip())
				 End
				
			Endif
		EndIf                 
		
		AcaLog(cLogFile, "REGISTRO JC7 ATUALIZADO: " + Alltrim(Str(JC7->(Recno()))))
		
		_QRYJC7->(DbSkip())		                     
	End

else

	While _QRYJC7->( !Eof() )
	
		JC7->(DBGoto(_QRYJC7->RECJC7)) 
		JBL->( dbSetOrder(1) )	//JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS+JBL_MATPRF	
		
		If _QRYJC7->GRADE == "N" //Aluno de Grade Normal
		
			If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP) ) ) 
				If RecLock("JC7",.F.)
					 JC7->JC7_CODPRF := JBL->JBL_MATPRF
					 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
					 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
					 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
					 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
					 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
					 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
					 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
	                 JC7->(MsUnlock()) 	
				 EndIf
			Endif
			
		Else  //Aluno de Outras Grades
			If JBL->( dbSeek(xFilial("JBL")+JC7->(JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP) ) ) 
			   
				If RecLock("JC7",.F.)
					 JC7->JC7_CODPRF := JBL->JBL_MATPRF
					 JC7->JC7_CODPR2 := JBL->JBL_MATPR2	
					 JC7->JC7_CODPR3 := JBL->JBL_MATPR3	
					 JC7->JC7_CODPR4 := JBL->JBL_MATPR4	
					 JC7->JC7_CODPR5 := JBL->JBL_MATPR5	
					 JC7->JC7_CODPR6 := JBL->JBL_MATPR6	
					 JC7->JC7_CODPR7 := JBL->JBL_MATPR7	
					 JC7->JC7_CODPR8 := JBL->JBL_MATPR8
	                 JC7->(MsUnlock()) 	
			    EndIf
			Endif
		EndIf                 
		
		AcaLog(cLogFile, "REGISTRO JC7 ATUALIZADO: " + Alltrim(Str(JC7->(Recno()))))
		
		_QRYJC7->(DbSkip())		                     
	End

endif

_QRYJC7->(DbCloseArea())

dbSelectArea("JC7")

Return                                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIBTA100 บAutor  ณ KARENt YOSHIE      บ Data ณ 31/JAN/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza a tabela SE5 e SE1 com os valores atualizados pelo 
ฑฑบ			 ณPE AC680GRV que era chamado depois de realizar a baixa,o queบฑฑ
ฑฑบ			 ณacabou gerando a movimenta็ใo SE5 com o valor padrใo        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados para o IBTA                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIBTA100()
FixWindow(0, {|| FIBTA100Go() } )
Return

Static Function FIBTA100Go()
Local cQuery 	:= ""                                                    
Local nContSE1  := 0
Local nContSE5D  := 0
Local nContSE5B  := 0

dbSelectArea("SE1")
dbSelectArea("SE5")
                 
cQuery := " SELECT E1_VALOR, E5_TIPODOC, E1_NUM, E1_CLIENTE, E1_PREFIXO, E1_PARCELA, E1_TIPO, E1_LOJA,E5_SEQ,E5_DATA " 
cQuery += " FROM " + RetSQLName("SE1") + " SE1, " + RetSQLName("SE5") + " SE5 "
cQuery += " WHERE "
cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND "
cQuery += " E1_FILIAL = E5_FILIAL "
cQuery += " AND E1_NUM = E5_NUMERO "
cQuery += " AND E1_CLIENTE = E5_CLIFOR "
cQuery += " AND E1_VALOR = E1_VLBOLSA  "
cQuery += " AND E1_VALOR <> E1_DESCONT "
cQuery += " AND E1_DESCONT <> 0        "
cQuery += " AND E1_NUM <> ' '          "
cQuery += " AND E1_HIST = 'BOLSA 100%               ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' '   "
cQuery += " AND SE5.D_E_L_E_T_ = ' '   "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYSE1", .F., .F. )

SE1->( dbSetOrder(1) ) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
SE5->( dbSetOrder(2) ) //E5_FILIAL, E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_, D_E_L_E_T_

//Atualizando registros na tabela SA1...
if QRYSE1->( !Eof() )
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela..." )		
	while QRYSE1->( !Eof() )

		//E5_FILIAL, E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_, D_E_L_E_T_
		If SE5->( DBseek(xFilial("SE5") + QRYSE1->E5_TIPODOC+ QRYSE1->E1_PREFIXO + QRYSE1->E1_NUM + QRYSE1->E1_PARCELA + QRYSE1->E1_TIPO + QRYSE1->E5_DATA+QRYSE1->E1_CLIENTE + QRYSE1->E1_LOJA +  QRYSE1->E5_SEQ ) ) 		
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela SE5: Filial " + xFilial("SE5") + "Num: " +QRYSE1->E1_NUM + " Cliente "+ QRYSE1->E1_CLIENTE + "Valor: " + str(QRYSE1->E1_VALOR) )		
			Reclock("SE5", .f.)
			If Alltrim(QRYSE1->E5_TIPODOC) == "DC"
				SE5->E5_VALOR = QRYSE1->E1_VALOR 
				SE5->E5_VLMOED2 = QRYSE1->E1_VALOR
				nContSE5D++
			ElseIf Alltrim(QRYSE1->E5_TIPODOC) == "BA"
				SE5->E5_VLDESCO = QRYSE1->E1_VALOR 			
				nContSE5B++
			EndIf
			SE5->( msUnlock() )
		endif
		//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		If SE1->( DBSeek( xFilial("SE1") +  QRYSE1->E1_PREFIXO + QRYSE1->E1_NUM + QRYSE1->E1_PARCELA + QRYSE1->E1_TIPO ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registros da tabela SE1: Filial " + xFilial("SE1") + "Num: " +QRYSE1->E1_NUM + " Cliente "+ QRYSE1->E1_CLIENTE + "Valor: " + str(QRYSE1->E1_VALOR) )		
			Reclock("SE1", .f.)
			SE1->E1_DESCONT = QRYSE1->E1_VALOR 
			SE1->( msUnlock() )			
			nContSE1++
		EndIf
		QRYSE1->( dbSkip() )
	end
else
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Nenhum registro encontrado para atualizacao nesta empresa/filial: " + xFilial("SE1") )
endif

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Filial: "+ xFilial("SE1") + "Total SE5 DC: " + str(nContSE5D) + "+. Total SE5 BA: " + Str(nContSE5B) + ". Total SE1: " + Str(nContSE1)  )
QRYSE1->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Fx137295 บAutor  ณ Alberto Deviciente บ Data ณ 13/Fev/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza as tabelas JBE e JC7 para todos os alunos que      บฑฑ
ฑฑบ			 ณpassaram por alguma transferencia de curso atraves de reque-บฑฑ
ฑฑบ			 ณrimento.                                                    บฑฑ
ฑฑบ			 ณQdo. se utilizava turmas diferentes em todos os periodos do บฑฑ
ฑฑบ			 ณcurso, no momento de gravacao dos registros nas tabelas JBE บฑฑ
ฑฑบ			 ณe JC7 para o curso que o alunos foi transferido,os registrosบฑฑ
ฑฑบ			 ณforam gravados incorretamente na tabela JBE e nao foram     บฑฑ
ฑฑบ			 ณgravados os registros dos periodos anteriores na tabela JC7.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx140645()
FixWindow(140645, {|| F140645() } )
Return

Static Function F140645()
Local cQuery	:= ""
Local cAlias  	:= GetNextAlias()
Local lSequenc  := .F.
Local lSubTurma := .F.
Local cSeq  	:= ""
Local lAtuDados	:= .F.
Local lAchouJCO := .F.
Local cSituacao := ""
Local cSitDis   := ""
Local aDiscip 	:= {}
Local nDiscip	:= 0
Local cChave   	:= ""

dbSelectArea("JBE")
dbSelectArea("JBH")
dbSelectArea("JBL")
dbSelectArea("JBO")
dbSelectArea("JC7")
dbSelectArea("JCS")

lSequenc 	:= JBE->( FieldPos("JBE_SEQ") ) > 0 .and. JC7->( FieldPos("JC7_SEQ") ) > 0
lSubTurma 	:= JC7->(FieldPos("JC7_SUBTUR")) > 0 .and. JBL->(FieldPos("JBL_SUBTUR")) > 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca todos os RA's envolvidos que passaram pela Analise de Grade Curricularณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT DISTINCT JBE_NUMRA NUMRA, JCS_NUMREQ NUMREQ, JCS_CURSO CURVIG, JCS_SERIE PERLET"
cQuery += "  FROM " +RetSQLName("JBE")+ " JBE, " +RetSQLName("JCS")+ " JCS"
cQuery += " WHERE JBE.JBE_FILIAL = '"+xFilial("JBE")+"'"
cQuery += "   AND JCS.JCS_FILIAL = '"+xFilial("JCS")+"'"
cQuery += "   AND JCS.JCS_NUMREQ = JBE.JBE_NUMREQ"
cQuery += "   AND JCS_CURSO <> '      '"
cQuery += "   AND JCS_SERIE > '01'" //Desconsidera as transferencias feitas para periodo letivo 01
cQuery += "   AND JBE.D_E_L_E_T_ = ' '"
cQuery += "   AND JCS.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY NUMRA, NUMREQ"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY140645", .F., .F. )

JBO->( dbSetOrder(1) ) //JBO_FILIAL+JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA
JBE->( dbSetOrder(1) ) //JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA

AcaLog( cLogFile, "" )

while QRY140645->( !EoF() )
	
	Begin Transaction
	
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Iniciando atualizacao de dados   - RA: ("+QRY140645->NUMRA+")" + " Curso Vigente: ("+QRY140645->CURVIG+")" )
	
	//Verifica se os registros da JBE do aluno em questao estao com turmas incorretas
	cQuery := " SELECT JBE.R_E_C_N_O_ AS RECJBE"
	cQuery += "   FROM " +RetSQLName("JBE")+ " JBE"
	cQuery += "  WHERE JBE_FILIAL = '"+xFilial("JBE")+"'"
	cQuery += "    AND JBE_NUMRA  = '"+QRY140645->NUMRA+"'"
	cQuery += "    AND JBE_CODCUR = '"+QRY140645->CURVIG+"'"
	cQuery += "    AND JBE_PERLET < '"+QRY140645->PERLET+"'"
	cQuery += "    AND JBE.D_E_L_E_T_ = ' '"
	cQuery += "    AND NOT EXISTS ( SELECT JBO_TURMA "
	cQuery += "                       FROM " +RetSQLName("JBO")+ " JBO"
	cQuery += "                      WHERE JBO_FILIAL = '"+xFilial("JBO")+"'"
	cQuery += "                        AND JBO_CODCUR = JBE.JBE_CODCUR"
	cQuery += "                        AND JBO_PERLET = JBE.JBE_PERLET"
	cQuery += "                        AND JBO_HABILI = JBE.JBE_HABILI"
	cQuery += "                        AND JBO_TURMA  = JBE.JBE_TURMA"
	cQuery += "                        AND JBO.D_E_L_E_T_ = ' ' )"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )
	
	lAtuDados := .F.
	
	
	while (cAlias)->( !EoF() )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEfetua a correcao dos dados inconsistentesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lAtuDados := .F.
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ1a. Parte - Corrige registros da tabela JBEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		JBE->( dbGoTo((cAlias)->RECJBE) )

		//Procura pela primeira turma existente na JBO
		if JBO->( dbSeek( xFilial("JBO")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"     Atualizando registro da tabela JBE de turma ("+JBE->JBE_TURMA+") para turma ("+JBO->JBO_TURMA+") - RECNO: "+ Str(JBE->(Recno()),10) )
			
			if lSequenc
				if !JBE->( dbSeek( xFilial("JBE")+JBE->JBE_NUMRA+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBO->JBO_TURMA ) )
					JBE->( dbGoTo((cAlias)->RECJBE) )
					
					RecLock("JBE", .F.)
					JBE->JBE_TURMA := JBO->JBO_TURMA
					JBE->( MsUnlock() )
				else
					//Busca a proxima sequencia
					cSeq := ACSequence(JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBO->JBO_TURMA, JBE->JBE_HABILI)
					JBE->( dbGoTo((cAlias)->RECJBE) )
	
					RecLock("JBE", .F.)
					JBE->JBE_TURMA 	:= JBO->JBO_TURMA
					JBE->JBE_SEQ 	:= cSeq
					JBE->( MsUnlock() )
				endif
			else
				RecLock("JBE", .F.)
				JBE->JBE_TURMA 	:= JBO->JBO_TURMA
				JBE->( MsUnlock() )
			endif
			
			lAtuDados := .T.
		endif
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ2a. Parte - Gera os registros que nao foram gerados na tabela JC7 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if lAtuDados
			
			JCT->( dbSetOrder(1) ) //JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_DISCIP
			if JCT->( dbSeek(xFilial("JCT")+QRY140645->NUMREQ+JBE->JBE_PERLET ) )
				While JCT->( ! EoF() .and. JCT->JCT_NUMREQ+JCT->JCT_PERLET == QRY140645->NUMREQ+JBE->JBE_PERLET )
					
					cSituacao := "1"
					cSitDis   := JCT->JCT_SITUAC
					
       				if JCT->JCT_SITUAC $ "003/011" //003=DISPENSADO; 011=DISPENSADO POR COMPETENCIA ADQUIRIDA
                   		cSituacao := "8"
                   	elseif JCT->JCT_SITUAC $ "001/002/006" //001=ADAPTACAO; 002=DEPENDENCIA; 006=TUTORIA
                   		cSituacao := "A"
                    elseif JCT->JCT_SITUAC == "010" //010=MATRICULADO
                      	cSituacao := "1"
                   	elseif 	JCT->JCT_SITUAC == "004" //004=TRANCADO
                   	    cSituacao := "7"                        	 	
                   	elseif 	JCT->JCT_SITUAC $ "009/008" //009=CANCELADO; 008=TRANSFERIDO
                   	    cSituacao := "9"
                   	endif
					
					aDiscip := {}
					
					JBL->( dbSetOrder( 1 ) ) // JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_TURMA+JBL_CODDIS
					if JBL->( dbSeek( xFilial("JBL") + JBE->JBE_CODCUR + JCT->JCT_PERLET + JCT->JCT_HABILI + JBE->JBE_TURMA + JCT->JCT_DISCIP ) )
					
						While JBL->( ! EoF() .And. JBL_FILIAL + JBL_CODCUR + JBL_PERLET + JBL_HABILI + JBL_TURMA + JBL_CODDIS == xFilial("JBL") + JBE->JBE_CODCUR + JCT->JCT_PERLET + JCT->JCT_HABILI + JBE->JBE_TURMA + JCT->JCT_DISCIP )
							
							if lSubTurma .and. !Empty(JBL->JBL_SUBTUR) .And. JBL->JBL_SUBTUR <> JBE->JBE_SUBTUR
								JBL->( dbSkip() )
								Loop
							endif
			    			
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Gera tabela JC7 matriculando o aluno na disciplina ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If JCT->( FieldPos("JCT_MATRIC") ) == 0 .or. JCT->JCT_MATRIC <> "2"
								
								cChave := JBE->JBE_NUMRA+JBL->( JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL+JBL_DIASEM+JBL_HORA1 )
								
								JC7->( dbSetOrder(1) )	//JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1
								
								if JC7->( !dbSeek( xFilial("JC7")+cChave ) )
								
									RecLock( "JC7", .T. )
									JC7->JC7_FILIAL := xFilial("JC7")
									JC7->JC7_NUMRA  := JBE->JBE_NUMRA
									JC7->JC7_CODCUR := JBL->JBL_CODCUR
									JC7->JC7_PERLET := JBL->JBL_PERLET
									JC7->JC7_HABILI := JBL->JBL_HABILI
									JC7->JC7_TURMA  := JBL->JBL_TURMA
									JC7->JC7_DISCIP := JBL->JBL_CODDIS
									JC7->JC7_SITUAC := cSituacao
									JC7->JC7_SITDIS := cSitDis
									JC7->JC7_NUMPRO := ""
									JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
									JC7->JC7_MEDCON := JCT->JCT_MEDCON
									JC7->JC7_DESMCO := JCT->JCT_DESMCO
									JC7->JC7_CODINS := JCT->JCT_CODINS
									JC7->JC7_ANOINS := JCT->JCT_ANOINS
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
									JC7->JC7_DIASEM := JBL->JBL_DIASEM
									JC7->JC7_CODHOR := JBL->JBL_CODHOR
									JC7->JC7_CODLOC := JBL->JBL_CODLOC
									JC7->JC7_CODPRE := JBL->JBL_CODPRE
									JC7->JC7_ANDAR  := JBL->JBL_ANDAR
									JC7->JC7_CODSAL := JBL->JBL_CODSAL
									if JC7->( FieldPos( "JC7_TIPCUR" ) ) > 0 .and. JCT->( FieldPos( "JCT_TIPCUR" ) ) > 0
										JC7->JC7_TIPCUR := JCT->JCT_TIPCUR
									endif
									if lSequenc
										JC7->JC7_SEQ := JBE->JBE_SEQ
									endif
									if lSubTurma
										JC7->JC7_SUBTUR := JBE->JBE_SUBTUR
									endif
									JC7->( MsUnlock() )
									
									AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"     Incluido registro da tabela JC7 - RECNO: "+ Str(JC7->(Recno()),10) )
								endif
							
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Gera disciplinas dispensadas do aluno       ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								JCO->( dbSetOrder(1) ) //JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_DISCIP
								lAchouJCO := JCO->( dbSeek( xFilial("JCO") + JBE->JBE_NUMRA + JBL->JBL_CODCUR + JBL->JBL_PERLET + JBL->JBL_HABILI + JBL->JBL_CODDIS ) )
								
								If (cSitDis == "003" .or. cSitDis == "011") .and. !lAchouJCO
									RecLock( "JCO", !lAchouJCO )
									JCO->JCO_FILIAL := xFilial("JCO")
									JCO->JCO_NUMRA  := JBE->JBE_NUMRA
									JCO->JCO_CODCUR := JBL->JBL_CODCUR
									JCO->JCO_PERLET := JBL->JBL_PERLET
									JCO->JCO_HABILI := JBL->JBL_HABILI
									JCO->JCO_DISCIP := JBL->JBL_CODDIS
									JCO->JCO_MEDFIM := JC7->JC7_MEDFIM
									JCO->JCO_MEDCON := JC7->JC7_MEDCON
									JCO->JCO_CODINS := JC7->JC7_CODINS
									JCO->JCO_ANOINS := JC7->JC7_ANOINS
									if JC7->( FieldPos( "JC7_TIPCUR" ) ) > 0 .and. JCO->( FieldPos( "JCO_TIPCUR" ) ) > 0
										JCO->JCO_TIPCUR := JC7->JC7_TIPCUR
									endif
									JCO->( MsUnLock() )
								ElseIf cSitDis == "010" .and. lAchouJCO
									RecLock( "JCO", !lAchouJCO )
									JCO->( dbDelete() )
									JCO->( MsUnLock() )
								EndIf
								
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Se nao achou, efetiva o aluno na disciplina ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								If Posicione("JAS",2,xFilial("JAS") + JC7->JC7_CODCUR + JC7->JC7_PERLET + JC7->JC7_HABILI + JC7->JC7_DISCIP,"JAS_ESCDIA") == "1"
									nDiscip := aScan( aDiscip, { |x| x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7] + x[8] == JC7->JC7_DISCIP + JC7->JC7_CODLOC + JC7->JC7_CODPRE + JC7->JC7_ANDAR + JC7->JC7_CODSAL + JC7->JC7_DIASEM + JC7->JC7_HORA1 + JC7->JC7_HORA2 })
								Else
									nDiscip := aScan( aDiscip, { |x| x[1] + x[2] + x[3] + x[4] + x[5] == JC7->JC7_DISCIP + JC7->JC7_CODLOC + JC7->JC7_CODPRE + JC7->JC7_ANDAR + JC7->JC7_CODSAL })
								EndIf
								
								If Empty( nDiscip )
									
									AAdd( aDiscip, { JC7->JC7_DISCIP, JC7->JC7_CODLOC, JC7->JC7_CODPRE, JC7->JC7_ANDAR, JC7->JC7_CODSAL, JC7->JC7_DIASEM, JC7->JC7_HORA1, JC7->JC7_HORA2 })
									
									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณ Matricula o aluno na disciplina. ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									JC7->( AcaVerJCE( JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_CODLOC, JC7_CODPRE, JC7_ANDAR, JC7_CODSAL, JC7_DIASEM, JC7_HORA1, JC7_HORA2, 6, ) )
									
								EndIf
								
							Endif
							
							JBL->( dbSkip() )
						End
					
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Gera disciplinas dispensadas do aluno       ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						JCO->( dbSetOrder(1) ) //JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_DISCIP
						lAchouJCO := JCO->( dbSeek( xFilial("JCO") + JBE->JBE_NUMRA + JBE->JBE_CODCUR + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
						
						If JCT->JCT_SITUAC == "003" .and. ! lAchouJCO
							RecLock( "JCO", !lAchouJCO )
							JCO->JCO_FILIAL := xFilial("JCO")
							JCO->JCO_NUMRA  := JBE->JBE_NUMRA
							JCO->JCO_CODCUR := JBE->JBE_CODCUR
							JCO->JCO_PERLET := JCT->JCT_PERLET
							JCO->JCO_HABILI := JCT->JCT_HABILI
							JCO->JCO_DISCIP := JCT->JCT_DISCIP
							JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
							JCO->JCO_MEDCON := JCT->JCT_MEDCON
							JCO->JCO_CODINS := JCT->JCT_CODINS
							JCO->JCO_ANOINS := JCT->JCT_ANOINS
							if JCO->( FieldPos( "JCO_TIPCUR" ) ) > 0 .and. JCT->( FieldPos( "JCT_TIPCUR" ) ) > 0
								JCO->JCO_TIPCUR := JCT->JCT_TIPCUR
							endif
							JCO->( MsUnLock() )
						ElseIf JCT->JCT_SITUAC == "010" .and. lAchouJCO
							RecLock( "JCO", !lAchouJCO )
							JCO->( dbDelete() )
							JCO->( MsUnLock() )
						EndIf
					
					endif
					
					JCT->( dbSkip() )
					
				End
				
			endif
		endif
		
		(cAlias)->( dbSkip() )
	
	end
	
	(cAlias)->( dbCloseArea() )

	dbSelectArea("JBE")
	
	if !lAtuDados
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"     *** Nenhum registro encontrado para atualizacao para este aluno." )
	endif
	
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Finalizando atualizacao de dados - RA: ("+QRY140645->NUMRA+")" + " Curso Vigente: ("+QRY140645->CURVIG+")" )
	AcaLog( cLogFile, "" )
	
	End Transaction
	
	QRY140645->( dbSkip() )
end

QRY140645->( dbCloseArea() )

dbSelectArea("JBE")

Return
                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix140367 บAutor  ณCesar A. Bianchi    บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a remo็ใo do conteudo 'U' do campo X3_PROPRI evita-บฑฑ
ฑฑบ          ณ ndo que o campo seja exibido Automaticamente nas Enchoices บฑฑ
ฑฑบ          ณ padroes do sistema. Uso exclusivo para cliente contido no  บฑฑ
ฑฑบ          ณ BOPS de nro 00000140367.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP-8.11                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
                                     
User Function Fix140367()
	FixWindow(140367, {|| F140367Go('JB5') } )
Return

Function F140367Go(cAlias)

dbSelectArea('SX3')
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))	
While SX3->X3_ARQUIVO == cAlias .and. SX3->(!Eof())
	if alltrim(SX3->X3_PROPRI) == 'U'
		RecLock('SX3',.F.)
		SX3->X3_PROPRI := ''
		SX3->(msUnlock())
	endif
	SX3->(dbSkip())
EndDo                    

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFxSenai002บAutor  ณDenis D. Almeida    บ Data ณ  22/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAcerto de Base de Dados do Senai JCG e JCH                  บฑฑ
ฑฑบ          ณRequerimentos de Transfer๊ncia                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FxSenai002()
FixWindow(0, {|| FxSenaiBeg() } )
Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFxSenaiBegบAutor  ณDenis D. Almeida    บ Data ณ  22/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento do Fix de Base de Dados JCH e JCG             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FxSenaiBeg() 

local cQuery  	:= ""
local cAlias  	:= GetNextAlias()
local cAlias2 	:= GetNextAlias()
local cAlias3   := GetNextAlias() 
local cAlias5   := GetNextAlias()
local cAlias4   := GetNextAlias() 
local cAlias6   := GetNextAlias() 
local cAlias7   := GetNextAlias()
local lExstMat	:= JCG->(FieldPos("JCG_MATPRF")) > 0 
local cString   := ""
local cHora1    := ""
local nQtd      := 0
local cNumraAnt := ""
local lMSSQL    := "MSSQL"$Upper(TCGetDB())							//Variaveis para tratamento de Banco de dados
local lMySQL    := "MYSQL"$Upper(TCGetDB())							//Variaveis para tratamento de Banco de dados
local cSqlConc  := ""
local cSqlConc2 := ""
local dDataGr   := ""
local cQuery2   := ""
local cQuery3  	:= "" 
local cSql      := ""
local cSql2     := ""
local cSqlUpd   := ""
local lSeek
local lSeek2
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica Requerimentos de Transfer๊ncias para posteriormenteณ
//ณefetuar a gera็ใo de JCG e JCH no curso de Destino conforme ณ
//ณdados existentes nas mesmas tabelas da Grade de Origem.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
if lMSSQL 
	cSqlConc  := " AND JCG_DATA+JCG_DISCIP+JCG_MATPRF  NOT IN  "
	cSqlConc  += " ( SELECT JD2.JD2_DATA+JD2.JD2_CODDIS+JD2.JD2_MATPRF "  	
	cSqlConc2 := " AND JCH_DATA+JCH_DISCIP+JCH_MATPRF  NOT IN  "
	cSqlConc2 += " ( SELECT JD2.JD2_DATA+JD2.JD2_CODDIS+JD2.JD2_MATPRF "
elseif lMySQL
	cSqlConc  := " AND concat(JCG_DATA,JCG_DISCIP,JCG_MATPRF)  NOT IN  "
	cSqlConc  += " ( SELECT concat(JD2.JD2_DATA,JD2.JD2_CODDIS,JD2.JD2_MATPRF) "  
	cSqlConc2 := " AND concat(JCH_DATA,JCH_DISCIP,JCH_MATPRF)  NOT IN  "
	cSqlConc2 += " ( SELECT concat(JD2.JD2_DATA,JD2.JD2_CODDIS,JD2.JD2_MATPRF) "
else
	cSqlConc  := " AND JCG_DATA||JCG_DISCIP||JCG_MATPRF  NOT IN  "
	cSqlConc  += " ( SELECT JD2.JD2_DATA||JD2.JD2_CODDIS||JD2.JD2_MATPRF "
	cSqlConc2 := " AND JCH_DATA||JCH_DISCIP||JCH_MATPRF  NOT IN  "
	cSqlConc2 += " ( SELECT JD2.JD2_DATA||JD2.JD2_CODDIS||JD2.JD2_MATPRF "
endif

cQuery := " SELECT "  
cQuery += " 	JBH.JBH_CODIDE   NUMRA, "
cQuery += " 	SUBSTRING(TBL.YP_TEXTO,1,6) CURORI, "
cQuery += " 	JBE2.JBE_PERLET  PERORI, "
cQuery += " 	JBE2.JBE_HABILI  HABORI, "
cQuery += " 	JBE2.JBE_TURMA   TURORI, "
cQuery += "     JBE.JBE_CODCUR   CURDES, "
cQuery += " 	JBE.JBE_PERLET   PERDES, "
cQuery += "     JBE.JBE_HABILI   HABDES, "
cQuery += " 	JBE.JBE_TURMA    TURDES, "
cQuery += "     MAX(JBH.JBH_NUM) NUMREQ  "	
cQuery += "    FROM "+retsqlname("JBH")+" JBH, JBF010 JBF, "
cQuery += " 	( SELECT  SYP.YP_CHAVE, "
cQuery += " 	          SYP.YP_TEXTO, "
cQuery += " 		      SYP.YP_SEQ "
cQuery += " 	     FROM "+retsqlname("SYP")+" SYP "
cQuery += " 	    WHERE SYP.YP_FILIAL='"+xFilial("SYP")+"' "
cQuery += " 	      AND SYP.D_E_L_E_T_=' ' ) TBL, "
cQuery += " 	"+retsqlname("JBE")+" JBE, "
cQuery += " 	"+retsqlname("JBE")+" JBE2 "
cQuery += "   WHERE JBH.JBH_CODIDE IN  "
cQuery += "      ( SELECT JBE.JBE_NUMRA  " 
cQuery += " 	 	 FROM "+retsqlname("JBE")+" JBE "
cQuery += " 		WHERE JBE.JBE_FILIAL='"+xFilial("JBE")+"' "
cQuery += " 	      AND JBE.D_E_L_E_T_=' ' "
cQuery += " 	      AND JBE.JBE_ATIVO IN ('3') ) "
cQuery += "     AND JBH.JBH_TIPO    = JBF.JBF_COD "
cQuery += "     AND JBF.JBF_DESC LIKE '%TRANSF%' "
cQuery += "     AND JBH.JBH_MEMO2   = TBL.YP_CHAVE "
cQuery += "     AND JBH.JBH_CODIDE  = JBE.JBE_NUMRA "
cQuery += "     AND (JBH.JBH_CODIDE = JBE2.JBE_NUMRA  "
cQuery += "     AND JBE2.JBE_ATIVO IN ('3')  "
cQuery += "     AND JBE2.JBE_CODCUR = SUBSTRING(TBL.YP_TEXTO,1,6) )	 "
cQuery += "     AND JBE.JBE_ATIVO  IN ('1') "
cQuery += "     AND TBL.YP_SEQ      = '001' "
cQuery += "     AND JBH.JBH_STATUS IN ('1') "
cQuery += "     AND JBH.JBH_FILIAL='"+xFilial("JBH")+"' "
cQuery += "     AND JBH.D_E_L_E_T_=' ' "
cQuery += "     AND JBF.JBF_FILIAL='"+xFilial("JBF")+"' "
cQuery += "     AND JBF.D_E_L_E_T_=' '    "
cQuery += "     AND JBE.JBE_FILIAL='"+xFilial("JBE")+"' "
cQuery += "     AND JBE.D_E_L_E_T_=' ' 	 "
cQuery += "     AND JBE2.JBE_FILIAL='"+xFilial("JBE")+"' "
cQuery += "     AND JBE2.D_E_L_E_T_=' ' "
cQuery += " GROUP BY "
cQuery += " 	JBH.JBH_CODIDE,TBL.YP_TEXTO,JBE.JBE_CODCUR,JBE.JBE_PERLET, "
cQuery += "     JBE.JBE_HABILI,JBE.JBE_TURMA,JBE2.JBE_CODCUR,JBE2.JBE_PERLET, "
cQuery += " 	JBE2.JBE_HABILI,JBE2.JBE_TURMA "
cQuery := ChangeQuery( cQuery )
if Select( cAlias ) > 0
	(cAlias)->( dbCloseArea() )
	dbSelectArea("JBE")
end
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )   

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Incio do Processamento" )
jch->( dbsetorder(1) )
(cAlias)->( dbgotop() )
while (cAlias)->( !eof() )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRegistros que devem existir no cabe็alho do curso de Destinoณ
	//ณ(JCG) e replica็ใo dos dados para os Alunos onde existem    ณ
	//ณincidencias da gera็ใo de Requerimentos.                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery2 := " SELECT "
	cQuery2 += " 	JCG.JCG_CODCUR,JCG.JCG_PERLET,JCG.JCG_HABILI, "
	cQuery2 += " 	JCG.JCG_TURMA,JCG.JCG_DISCIP,JCG.JCG_TIPO,JCG.JCG_CODAVA, "
	cQuery2 += " 	JCG.JCG_DATA,JCG.JCG_MATPRF,JCG.JCG_ITEM,JCG.JCG_SUBTUR, "
	cQuery2 += " 	TBL.JD2_MATPRF MATPRF, "
	cQuery2 += " 	TBL.JD2_AULA AULAJD2, "
	cQuery2 += " 	TBL.JD2_ITEM ITEMJD2,TBL.JD2_CODDIS "
	cQuery2 += "    FROM "+retsqlname("JCG")+" JCG, "
	cQuery2 += " 	(SELECT JD2.JD2_DATA, "
	cQuery2 += " 		JD2.JD2_MATPRF, "
	cQuery2 += " 		JD2.JD2_AULA, "
	cQuery2 += " 		JD2.JD2_ITEM,JD2.JD2_CODDIS "
	cQuery2 += " 	   FROM JD2010 JD2 "
	cQuery2 += " 	  WHERE JD2.JD2_FILIAL = '"+xFilial("JD2")+"' "
	cQuery2 += " 	    AND JD2.D_E_L_E_T_ = ' ' "
	cQuery2 += " 	    AND JD2.JD2_CODCUR = '"+(cAlias)->CURDES+"' "
	cQuery2 += " 	    AND JD2.JD2_PERLET = '"+(cAlias)->PERDES+"' "
	cQuery2 += " 	    AND JD2.JD2_HABILI = '"+(cAlias)->HABDES+"' "
	cQuery2 += " 	    AND JD2.JD2_TURMA  = '"+(cAlias)->TURDES+"' ) TBL "
	cQuery2 += "   WHERE JCG.JCG_FILIAL = '"+xFilial("JCG")+"' "
	cQuery2 += "     AND JCG.D_E_L_E_T_ = ' ' "
	cQuery2 += "     AND JCG.JCG_CODCUR = '"+(cAlias)->CURORI+"' "
	cQuery2 += "     AND JCG.JCG_PERLET = '"+(cAlias)->PERORI+"' "
	cQuery2 += "     AND JCG.JCG_HABILI = '"+(cAlias)->HABORI+"' "
	cQuery2 += "     AND JCG.JCG_TURMA  = '"+(cAlias)->TURORI+"' "
	if lMSSQL 
   		cQuery2 += "     AND JCG.JCG_DATA+JCG.JCG_DISCIP   = TBL.JD2_DATA+TBL.JD2_CODDIS "
	elseif lMySQL                                                                         
		cQuery2 += "     AND concat(JCG.JCG_DATA,JCG.JCG_DISCIP)   = concat(TBL.JD2_DATA,TBL.JD2_CODDIS) "
	else                                                                                  
		cQuery2 += "     AND JCG.JCG_DATA||JCG.JCG_DISCIP   = TBL.JD2_DATA||TBL.JD2_CODDIS "
	endif
	cQuery2 += "     AND JCG.JCG_DATA  NOT IN  "
	cQuery2 += " 	(SELECT "
	cQuery2 += " 		JCG.JCG_DATA "
	cQuery2 += " 	   FROM "+retsqlname("JCG")+" JCG, "
	cQuery2 += " 		( SELECT JCG.JCG_DATA "
	cQuery2 += " 		   FROM "+retsqlname("JCG")+" JCG "
	cQuery2 += " 		  WHERE JCG.JCG_FILIAL = '"+xFilial("JCG")+"' "
	cQuery2 += " 		    AND JCG.D_E_L_E_T_ = ' ' "
	cQuery2 += " 		    AND JCG.JCG_CODCUR = '"+(cAlias)->CURORI+"' "
	cQuery2 += " 		    AND JCG.JCG_PERLET = '"+(cAlias)->PERORI+"' "
	cQuery2 += " 		    AND JCG.JCG_HABILI = '"+(cAlias)->HABORI+"' "
	cQuery2 += " 		    AND JCG.JCG_TURMA  = '"+(cAlias)->TURORI+"' ) TBL "
	cQuery2 += " 	  WHERE JCG.JCG_FILIAL = '"+xFilial("JCG")+"' "
	cQuery2 += " 	    AND JCG.D_E_L_E_T_ = ' ' "
	cQuery2 += " 	    AND JCG.JCG_CODCUR = '"+(cAlias)->CURDES+"' "
	cQuery2 += " 	    AND JCG.JCG_PERLET = '"+(cAlias)->PERDES+"' "
	cQuery2 += " 	    AND JCG.JCG_HABILI = '"+(cAlias)->HABDES+"' "
	cQuery2 += " 	    AND JCG.JCG_TURMA  = '"+(cAlias)->TURDES+"' "
	cQuery2 += " 	    AND JCG.JCG_DATA   = TBL.JCG_DATA )	 "
	cQuery2 += " GROUP BY "
	cQuery2 += " 	JCG.JCG_CODCUR,JCG.JCG_PERLET,JCG.JCG_HABILI, "
	cQuery2 += " 	JCG.JCG_TURMA,JCG.JCG_DISCIP,JCG.JCG_TIPO,JCG.JCG_CODAVA, "
	cQuery2 += " 	JCG.JCG_DATA,JCG.JCG_MATPRF,JCG.JCG_ITEM,JCG.JCG_SUBTUR, "
	cQuery2 += " 	TBL.JD2_MATPRF,TBL.JD2_AULA, "
	cQuery2 += " 	TBL.JD2_ITEM,TBL.JD2_CODDIS "
	cQuery2 += " ORDER BY "
	cQuery2 += " 	JCG.JCG_ITEM "
	cQuery2 := ChangeQuery( cQuery2 )
	if Select( cAlias2 ) > 0
		(cAlias2)->( dbCloseArea() )
		dbSelectArea("JCG")
	end
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )
	
	(cAlias2)->( dbgotop() )
	while (cAlias2)->( !eof() )
		//Gera็ใo de cabe็alho de Apontamento de Faltas
		if (cAlias)->CURDES+(cAlias)->PERDES+(cAlias)->HABDES+(cAlias)->TURDES+(cAlias2)->JCG_DISCIP+(cAlias2)->JCG_DATA+(cAlias2)->ITEMJD2+(cAlias2)->MATPRF != cString
			dDataGr := Stod((cAlias2)->JCG_DATA)
			RecLock( "JCG", .T. )
			JCG->JCG_FILIAL := xFilial("JCG")
			JCG->JCG_CODCUR := (cAlias)->CURDES
			JCG->JCG_PERLET := (cAlias)->PERDES
			JCG->JCG_HABILI := (cAlias)->HABDES
			JCG->JCG_TURMA  := (cAlias)->TURDES
			JCG->JCG_DISCIP := (cAlias2)->JCG_DISCIP
			JCG->JCG_TIPO   := posicione("jar",1,xfilial("JAR")+jcg->jcg_codcur+jcg->jcg_perlet+jcg->jcg_habili,"jar_apfalt")
			JCG->JCG_CODAVA := (cAlias2)->JCG_CODAVA
			JCG->JCG_DATA   := dDataGr
			If lExstMat
				JCG->JCG_ITEM   := (cAlias2)->ITEMJD2
				JCG->JCG_MATPRF := (cAlias2)->MATPRF
			EndIf
			JCG->( MsUnlock() )
			cString := (cAlias)->CURDES+(cAlias)->PERDES+(cAlias)->HABDES+(cAlias)->TURDES+(cAlias2)->JCG_DISCIP+(cAlias2)->JCG_DATA+(cAlias2)->ITEMJD2+(cAlias2)->MATPRF
		endif
		
		cQuery3 := " SELECT DISTINCT JCH.JCH_HORA1,JCH.JCH_QTD "
		cQuery3 += "    FROM "+retsqlname("JCH")+" JCH "
		cQuery3 += "   WHERE JCH_FILIAL = '"+xFilial("JCH")+"' "
		cQuery3 += "     AND JCH.D_E_L_E_T_ = ' ' "
		cQuery3 += "     AND JCH_CODCUR = '"+(cAlias)->CURORI+"' "
		cQuery3 += "     AND JCH_PERLET = '"+(cAlias)->PERORI+"' "
		cQuery3 += "     AND JCH_HABILI = '"+(cAlias)->HABORI+"' "
		cQuery3 += "     AND JCH_TURMA  = '"+(cAlias)->TURORI+"' "
		cQuery3 += "     AND JCH_DATA   = '"+(cAlias2)->JCG_DATA+"' "
		cQuery3 += "     AND JCH_ITEM   = '"+(cAlias2)->JCG_ITEM+"' "
		cQuery3 += "     AND JCH_DISCIP = '"+(cAlias2)->JCG_DISCIP+"' "
		cQuery3 += "     AND JCH_CODAVA = '"+(cAlias2)->JCG_CODAVA+"' "
		cQuery3 += "     AND JCH_MATPRF = '"+(cAlias2)->JCG_MATPRF+"' "
		cQuery3 += "     AND JCH_NUMRA NOT IN ('"+alltrim((cAlias)->NUMRA)+"') " 
		cQuery3 := ChangeQuery( cQuery3 )
		if Select( cAlias3 ) > 0
			(cAlias3)->( dbCloseArea() )
			dbSelectArea("JCH")
		end
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )
		
		(cAlias3)->( dbgotop() )
		if (cAlias3)->( !eof() )
			cHora1 := jch->jch_hora1
			nQtd   := jch->jch_qtd
			(cAlias3)->( dbCloseArea() )
			dbSelectArea("JCH")
		endif				
		//Gera็ใo de registros jch para Alunos encontrados no Requerimentos 
		dDataGr := Stod((cAlias2)->JCG_DATA)
		RecLock( "JCH", .T. )
		JCH->JCH_FILIAL := xFilial("JCH")
		JCH->JCH_NUMRA 	:= (cAlias)->NUMRA
		JCH->JCH_CODCUR	:= (cAlias)->CURDES
		JCH->JCH_PERLET	:= (cAlias)->PERDES
		JCH->JCH_TURMA	:= (cAlias)->TURDES
		JCH->JCH_HABILI	:= (cAlias)->HABDES
		JCH->JCH_DATA	:= dDataGr
		JCH->JCH_DISCIP	:= (cAlias2)->JCG_DISCIP
		JCH->JCH_TIPO	:= posicione("jar",1,xfilial("JAR")+jcg->jcg_codcur+jcg->jcg_perlet+jcg->jcg_habili,"jar_apfalt")
		JCH->JCH_HORA1	:= cHora1
		JCH->JCH_QTD	:= nQtd
		JCH->JCH_CODAVA	:= (cAlias2)->JCG_CODAVA
		JCH->JCH_MATPRF	:= (cAlias2)->MATPRF
		JCH->JCH_ITEM	:= (cAlias2)->ITEMJD2
		JCH->JCH_ABNQTD	:= 0
		JCH->JCH_HISQTD	:= 0
		JCH->( MsUnlock() )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Atualizando registro para o Aluno / Disciplina / Data: " +(cAlias)->NUMRA+" / "+(cAlias2)->JCG_DISCIP+" / "+(cAlias2)->JCG_DATA  )
		(cAlias2)->( dbskip() )
	end
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExcluindo registros JCG e JCH que nใo contem vํnculo    ณ
	//ณcom a Grade de Aulas do curso de destino para os Alunos ณ
	//ณsetados pelo Requerimento de Transferencia.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if cNumraAnt != (cAlias)->NUMRA 
		cSql := " SELECT * "
		cSql += "   FROM "+retsqlname("JCG")+" JCG "
		cSql += "  WHERE JCG.JCG_FILIAL = '"+xFilial("JCG")+"' "
		cSql += "    AND JCG.D_E_L_E_T_ = ' ' "
		cSql += "    AND JCG.JCG_CODCUR = '"+(cAlias)->CURORI+"' "
		cSql += "    AND JCG.JCG_PERLET = '"+(cAlias)->PERORI+"' "
		cSql += "    AND JCG.JCG_HABILI = '"+(cAlias)->HABORI+"' "
		cSql += "    AND JCG.JCG_TURMA  = '"+(cAlias)->TURORI+"' "
		cSql := ChangeQuery( cSql )
		if Select( cAlias5 ) > 0
			(cAlias5)->( dbCloseArea() )
			dbSelectArea("JCH")
		end
		dbUseArea( .T., "TopConn", TCGenQry(,,cSql), cAlias5, .F., .F. )
		
		(cAlias5)->( dbgotop() )
		while (cAlias5)->( !eof() )				
			cSql2 := " SELECT count(*) totFal "
			cSql2 += "   FROM "+retsqlname("JCH")+" JCH "
			cSql2 += "  WHERE JCH_FILIAL='"+xFilial("JCH")+"' "
			cSql2 += "    AND D_E_L_E_T_=' ' "
			cSql2 += "    AND JCH_CODCUR='"+(cAlias)->CURDES+"'  "
			cSql2 += "    AND JCH_PERLET='"+(cAlias)->PERDES+"' "
			cSql2 += "    AND JCH_HABILI='"+(cAlias)->HABDES+"' "
			cSql2 += "    AND JCH_TURMA ='"+(cAlias)->TURDES+"' "
			cSql2 += "    AND JCH_NUMRA ='"+alltrim((cAlias)->NUMRA)+"' "
			cSql2 += "    AND JCH_DATA  ='"+(cAlias5)->JCG_DATA+"' "
			cSql2 += "    AND JCH_DISCIP='"+(cAlias5)->JCG_DISCIP+"' "
			cSql2 := ChangeQuery( cSql2 )
			if Select( cAlias4 ) > 0
				(cAlias4)->( dbCloseArea() )
				dbSelectArea("JCH")
			end
			dbUseArea( .T., "TopConn", TCGenQry(,,cSql2), cAlias4, .F., .F. )
			(cAlias4)->( dbgotop() )
			if (cAlias4)->( !eof() ) .and. (cAlias4)->totFal > 0
				//Atualiza registros que existem na JCH
				cSqlUpd := " UPDATE "+retsqlname("JCH")+" "
				cSqlUpd += "   SET  JCH_CODCUR='"+(cAlias)->CURORI+"',  "
				cSqlUpd += "        JCH_PERLET='"+(cAlias)->PERORI+"', "
				cSqlUpd += "        JCH_HABILI='"+(cAlias)->HABORI+"', "
				cSqlUpd += "        JCH_TURMA ='"+(cAlias)->TURORI+"', "
				cSqlUpd += "        JCH_CODAVA='"+(cAlias5)->JCG_CODAVA+"', "
				cSqlUpd += "        JCH_DATA  ='"+(cAlias5)->JCG_DATA+"', "
				cSqlUpd += "        JCH_ITEM  ='"+(cAlias5)->JCG_ITEM+"', "
				cSqlUpd += "        JCH_MATPRF='"+(cAlias5)->JCG_MATPRF+"' "
				cSqlUpd += "  WHERE JCH_FILIAL='"+xFilial("JCH")+"' "
				cSqlUpd += "    AND D_E_L_E_T_=' ' "
				cSqlUpd += "    AND JCH_CODCUR='"+(cAlias)->CURDES+"'  "
				cSqlUpd += "    AND JCH_PERLET='"+(cAlias)->PERDES+"' "
				cSqlUpd += "    AND JCH_HABILI='"+(cAlias)->HABDES+"' "
				cSqlUpd += "    AND JCH_TURMA ='"+(cAlias)->TURDES+"' "
				cSqlUpd += "    AND JCH_NUMRA ='"+alltrim((cAlias)->NUMRA)+"' "
				cSqlUpd += "    AND JCH_DATA  ='"+(cAlias5)->JCG_DATA+"' "
				cSqlUpd += "    AND JCH_DISCIP='"+(cAlias5)->JCG_DISCIP+"' "
				TcSqlExec( cSqlUpd )
		   		TcSqlExec( "commit" )
		   	else 		   	
				cSql2 := " SELECT * " 			
				cSql2 += "  FROM "+retsqlname("JD2")+" JD2 "
				cSql2 += " WHERE JD2.JD2_FILIAL = '"+xFilial("JD2")+"' "
				cSql2 += "   AND JD2.D_E_L_E_T_ = ' '  "
				cSql2 += "   AND JD2.JD2_CODCUR = '"+(cAlias)->CURORI+"' "
				cSql2 += "   AND JD2.JD2_PERLET = '"+(cAlias)->PERORI+"' "
				cSql2 += "   AND JD2.JD2_HABILI = '"+(cAlias)->HABORI+"' "
				cSql2 += "   AND JD2.JD2_TURMA  = '"+(cAlias)->TURORI+"' "
				cSql2 += "   AND JD2.JD2_CODDIS = '"+(cAlias5)->JCG_DISCIP+"' "
				cSql2 += "   AND JD2.JD2_DATA   = '"+(cAlias5)->JCG_DATA+"' "
                cSql2 := ChangeQuery( cSql2 )
				if Select( cAlias6 ) > 0
					(cAlias6)->( dbCloseArea() )
					dbSelectArea("JCH")
				end
				dbUseArea( .T., "TopConn", TCGenQry(,,cSql2), cAlias6, .F., .F. )
                
           		(cAlias6)->( dbgotop() )
				if (cAlias6)->( !eof() )					
					jch->( dbsetorder(4) )
					lSeek := jch->( dbseek( xFilial("JCH")+alltrim((cAlias)->NUMRA)+(cAlias)->CURORI+(cAlias)->PERORI+(cAlias)->HABORI+(cAlias)->TURORI+(cAlias6)->JD2_DATA+(cAlias6)->JD2_CODDIS+(cAlias6)->JD2_MATPRF ) )					
			   		Reclock("JCH", !lSeek)
			   		JCH->JCH_FILIAL := xFilial("JCH")
					JCH->JCH_NUMRA 	:= (cAlias)->NUMRA
					JCH->JCH_CODCUR	:= (cAlias)->CURORI
					JCH->JCH_PERLET	:= (cAlias)->PERORI
					JCH->JCH_TURMA	:= (cAlias)->TURORI
					JCH->JCH_HABILI	:= (cAlias)->HABORI
					JCH->JCH_DATA	:= STOD((cAlias6)->JD2_DATA)
					JCH->JCH_DISCIP	:= (cAlias6)->JD2_CODDIS
					JCH->JCH_TIPO	:= posicione("jar",1,xfilial("JAR")+(cAlias)->CURORI+(cAlias)->PERORI+(cAlias)->HABORI,"jar_apfalt")
					JCH->JCH_HORA1	:= (cAlias6)->JD2_HORA1
					JCH->JCH_QTD	:= 0
					JCH->JCH_CODAVA	:= (cAlias5)->JCG_CODAVA
					JCH->JCH_MATPRF	:= (cAlias6)->JD2_MATPRF
					JCH->JCH_ITEM	:= (cAlias6)->JD2_AULA
					JCH->JCH_ABNQTD	:= 0
					JCH->JCH_HISQTD	:= 0
			   		JCH->( MsUnlock() )			   		
		   			//Excluindo registros duplicados
					cSqlDel := " DELETE "
					cSqlDel += "   FROM "+retsqlname("JCH")+" "
					cSqlDel += "  WHERE JCH_FILIAL = '"+xFilial("JCH")+"' "
					cSqlDel += "    AND D_E_L_E_T_ = ' ' "
					cSqlDel += "    AND JCH_CODCUR = '"+(cAlias)->CURORI+"' "
					cSqlDel += "    AND JCH_PERLET = '"+(cAlias)->PERORI+"' "
					cSqlDel += "    AND JCH_HABILI = '"+(cAlias)->HABORI+"' "
					cSqlDel += "    AND JCH_TURMA  = '"+(cAlias)->TURORI+"' "
					cSqlDel += "    AND JCH_NUMRA IN ('"+(cAlias)->NUMRA+"') "
					cSqlDel += "    AND JCH_DATA  IN ('"+(cAlias6)->JD2_DATA+"') "
					if lMSSQL
						cSqlDel += "    AND JCH_DATA+JCH_DISCIP+JCH_MATPRF+JCH_ITEM NOT IN "
						cSqlDel += " 	( SELECT JD2.JD2_DATA+JD2.JD2_CODDIS+JD2.JD2_MATPRF+JD2.JD2_AULA "
					elseif lMySQL                                                                                  
						cSqlDel += "    AND concat(JCH_DATA,JCH_DISCIP,JCH_MATPRF,JCH_ITEM) NOT IN "
						cSqlDel += " 	( SELECT concat(JD2.JD2_DATA,JD2.JD2_CODDIS,JD2.JD2_MATPRF,JD2.JD2_AULA) "
					else                                                                                          
						cSqlDel += "    AND JCH_DATA||JCH_DISCIP||JCH_MATPRF||JCH_ITEM NOT IN "
						cSqlDel += " 	( SELECT JD2.JD2_DATA||JD2.JD2_CODDIS||JD2.JD2_MATPRF||JD2.JD2_AULA "
					endif
					cSqlDel += " 	   FROM "+retsqlname("JD2")+" JD2 "
					cSqlDel += " 	  WHERE JD2.JD2_FILIAL = '"+xFilial("JD2")+"' "
					cSqlDel += " 	    AND JD2.D_E_L_E_T_ = ' ' "
					cSqlDel += " 	    AND JD2.JD2_CODCUR = '"+(cAlias)->CURORI+"' "
					cSqlDel += " 	    AND JD2.JD2_PERLET = '"+(cAlias)->PERORI+"' "
					cSqlDel += " 	    AND JD2.JD2_HABILI = '"+(cAlias)->HABORI+"' "
					cSqlDel += " 	    AND JD2.JD2_TURMA  = '"+(cAlias)->TURORI+"' "
					cSqlDel += " 	    AND JD2.JD2_DATA  IN ('"+(cAlias6)->JD2_DATA+"') )	" 
					TcSqlExec( cSqlDel )
					TcSqlExec( "commit" )
					//Atualiza qtd de Faltas lancadas no curso Destino
					cSql := " SELECT JCH.JCH_DATA, "
					cSql += "        JCH.JCH_QTD, "
					cSql += "        JCH.JCH_HISQTD, "
					cSql += "        JCH.JCH_ABNQTD	  "	
					cSql += "   FROM "+retsqlname("JCH")+" JCH "
					cSql += "  WHERE JCH.JCH_FILIAL = '"+xFilial("JCH")+"' "
					cSql += "    AND JCH.D_E_L_E_T_ = ' ' "
					cSql += "    AND JCH.JCH_CODCUR = '"+(cAlias)->CURDES+"' "
					cSql += "    AND JCH.JCH_PERLET = '"+(cAlias)->PERDES+"' "
					cSql += "    AND JCH.JCH_HABILI = '"+(cAlias)->HABDES+"' "
					cSql += "    AND JCH.JCH_TURMA  = '"+(cAlias)->TURDES+"' "
					cSql += "    AND JCH.JCH_NUMRA IN ('"+alltrim((cAlias)->NUMRA)+"') "
					cSql += "    AND JCH.JCH_QTD > 0 "
					cSql += "    AND JCH.JCH_DATA   =  '"+(cAlias6)->JD2_DATA+"' "
				    cSql := ChangeQuery( cSql )
					if Select( cAlias7 ) > 0
						(cAlias7)->( dbCloseArea() )
						dbSelectArea("JCH")
					endif
					dbUseArea( .T., "TopConn", TCGenQry(,,cSql), cAlias7, .F., .F. )
				    (cAlias7)->( dbgotop() )
				    if (cAlias7)->( !eof() )
				    	jch->( dbsetorder(4) )
				    	lSeek2 := jch->( dbseek( xFilial("JCH")+alltrim((cAlias)->NUMRA)+(cAlias)->CURORI+(cAlias)->PERORI+(cAlias)->HABORI+(cAlias)->TURORI+(cAlias6)->JD2_DATA+(cAlias6)->JD2_CODDIS ) )
				    	if lSeek2
				    		Reclock("JCH", .f.)
					   		JCH->JCH_FILIAL := xFilial("JCH")
							JCH->JCH_DATA	:= STOD((cAlias7)->JCH_DATA)
							JCH->JCH_QTD	:= (cAlias7)->JCH_QTD
							JCH->JCH_ABNQTD	:= (cAlias7)->JCH_ABNQTD
							JCH->JCH_HISQTD	:= (cAlias7)->JCH_HISQTD
					   		JCH->( MsUnlock() )	
				    	endif	    		
				    endif	    
		   		endif
			endif						
			(cAlias5)->( dbskip() )
	    end	
	    //Excluindo registros que nใo existam na Origem / Destino mas foram gerados erroneamente Data/Disciplina
		cSqlDel := " DELETE "
		cSqlDel += "   FROM "+retsqlname("JCH")+" "
		cSqlDel += "  WHERE JCH_FILIAL = '"+xFilial("JCH")+"' "
		cSqlDel += "    AND D_E_L_E_T_ = ' ' "
		cSqlDel += "    AND JCH_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += "    AND JCH_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += "    AND JCH_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += "    AND JCH_TURMA  = '"+(cAlias)->TURDES+"' "
		cSqlDel += "    AND JCH_NUMRA IN ('"+alltrim((cAlias)->NUMRA)+"') "  
		if lMSSQL
			cSqlDel += "    AND JCH_DATA+JCH_DISCIP NOT IN "
			cSqlDel += "       ( SELECT JCH.JCH_DATA+JCH.JCH_DISCIP "
		elseif lMySQL                                                      
			cSqlDel += "    AND concat(JCH_DATA,JCH_DISCIP) NOT IN "
			cSqlDel += "       ( SELECT concat(JCH.JCH_DATA,JCH.JCH_DISCIP) "
		else                                                         
			cSqlDel += "    AND JCH_DATA||JCH_DISCIP NOT IN "
			cSqlDel += "       ( SELECT JCH.JCH_DATA||JCH.JCH_DISCIP "
		endif
		cSqlDel += " 	  FROM "+retsqlname("JCH")+" JCH "
		cSqlDel += " 	 WHERE JCH.JCH_FILIAL = '"+xFilial("JCH")+"' "
		cSqlDel += " 	   AND JCH.D_E_L_E_T_ = ' ' "
		cSqlDel += " 	   AND JCH.JCH_CODCUR = '"+(cAlias)->CURORI+"' "
		cSqlDel += " 	   AND JCH.JCH_PERLET = '"+(cAlias)->PERORI+"' "
		cSqlDel += " 	   AND JCH.JCH_HABILI = '"+(cAlias)->HABORI+"' "
		cSqlDel += " 	   AND JCH.JCH_TURMA  = '"+(cAlias)->TURORI+"' "
		cSqlDel += " 	   AND JCH.JCH_NUMRA IN ('"+alltrim((cAlias)->NUMRA)+"') ) "
	    TcSqlExec( cSqlDel )
		TcSqlExec( "commit" )
	        
		cSqlDel := " DELETE "
		cSqlDel += "    FROM "+retsqlname("JCG")+" "
		cSqlDel += "   WHERE JCG_FILIAL = '"+xFilial("JCG")+"' "
		cSqlDel += "     AND D_E_L_E_T_ = ' ' "
		cSqlDel += "     AND JCG_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += "     AND JCG_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += "     AND JCG_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += "     AND JCG_TURMA  = '"+(cAlias)->TURDES+"' "
		cSqlDel += cSqlConc
		cSqlDel += " 	   FROM "+retsqlname("JD2")+" JD2 "
		cSqlDel += " 	  WHERE JD2.JD2_FILIAL = '"+xFilial("JD2")+"' "
		cSqlDel += " 	    AND JD2.D_E_L_E_T_ = ' ' "
		cSqlDel += " 	    AND JD2.JD2_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += " 	    AND JD2.JD2_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += " 	    AND JD2.JD2_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += " 	    AND JD2.JD2_TURMA  = '"+(cAlias)->TURDES+"') "
		if lMSSQL
			cSqlDel += "     AND JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA NOT IN "
			cSqlDel += " 	(SELECT JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA "
		elseif lMySQL
		    cSqlDel += "     AND concat(JCG_CODCUR,JCG_PERLET,JCG_HABILI,JCG_TURMA) NOT IN "
			cSqlDel += " 	(SELECT concat(JCH_CODCUR,JCH_PERLET,JCH_HABILI,JCH_TURMA) "
		else                                                                        
			cSqlDel += "     AND JCG_CODCUR||JCG_PERLET||JCG_HABILI||JCG_TURMA NOT IN "
			cSqlDel += " 	(SELECT JCH_CODCUR||JCH_PERLET||JCH_HABILI||JCH_TURMA "
		endif
		cSqlDel += " 	   FROM "+retsqlname("JCH")+" JCH "
		cSqlDel += " 	  WHERE JCH_FILIAL = '"+xFilial("JCH")+"' "
		cSqlDel += " 	    AND JCH.D_E_L_E_T_ = ' ' "
		cSqlDel += " 	    AND JCH_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += " 	    AND JCH_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += " 	    AND JCH_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += " 	    AND JCH_TURMA  = '"+(cAlias)->TURDES+"'  "
		cSqlDel += " 	    AND JCH_NUMRA NOT IN ('"+alltrim((cAlias)->NUMRA)+"')) "
		TcSqlExec( cSqlDel )
		TcSqlExec( "commit" )
		
		cSqlDel := ""
		cSqlDel := " DELETE "
		cSqlDel += "    FROM "+retsqlname("JCH")+" "
		cSqlDel += "   WHERE JCH_FILIAL = '"+xFilial("JCH")+"' "
		cSqlDel += "     AND D_E_L_E_T_ = ' ' "
		cSqlDel += "     AND JCH_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += "     AND JCH_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += "     AND JCH_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += "     AND JCH_TURMA  = '"+(cAlias)->TURDES+"' "
		cSqlDel += cSqlConc2
		cSqlDel += " 	   FROM "+retsqlname("JD2")+" JD2 "
		cSqlDel += " 	  WHERE JD2.JD2_FILIAL = '"+xFilial("JD2")+"' "
		cSqlDel += " 	    AND JD2.D_E_L_E_T_ = ' ' "
		cSqlDel += " 	    AND JD2.JD2_CODCUR = '"+(cAlias)->CURDES+"' "
		cSqlDel += " 	    AND JD2.JD2_PERLET = '"+(cAlias)->PERDES+"' "
		cSqlDel += " 	    AND JD2.JD2_HABILI = '"+(cAlias)->HABDES+"' "
		cSqlDel += " 	    AND JD2.JD2_TURMA  = '"+(cAlias)->TURDES+"') "
		cSqlDel += " 	    AND JCH_NUMRA IN ('"+alltrim((cAlias)->NUMRA)+"') "
		TcSqlExec( cSqlDel )
		TcSqlExec( "commit" )
		cNumraAnt := (cAlias)->NUMRA
	endif
	(cAlias)->( dbskip() )
end
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Fim do Processamento" )
if Select( cAlias ) > 0
	(cAlias)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias2 ) > 0
	(cAlias2)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias3 ) > 0
	(cAlias3)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias4 ) > 0
	(cAlias4)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias5 ) > 0
	(cAlias5)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias6 ) > 0
	(cAlias6)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
if Select( cAlias7 ) > 0
	(cAlias7)->( dbCloseArea() )
	dbSelectArea("JCH")
endif
dbSelectArea("JCG")
dbSelectArea("JBE")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF141586   บAutor  ณOtacilio A. Junior  บ Data ณ 28/Fev/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIdentifica quais alunos estao formados com periodos letivos บฑฑ
ฑฑบ          ณincompletos. Re-ativa estes alunos (JBE), relaciona-os em   บฑฑ
ฑฑบ          ณdois logs e alerta o usuario para executar a ACAA500/ACAA501บฑฑ
ฑฑบ          ณpara cada aluno, preenchendo entao os perlets nao-cursados. บฑฑ 
ฑฑบ          ณApos isto, deve-se executar a fix 144133 p/ re-formar estes บฑฑ 
ฑฑบ          ณalunos.		                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados - MP811                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F141586()
	FixWindow( 141586, {|| F141586G() } )
Return    

Static Function F141586G()
Local aArea		:= GetArea()
Local cQuery	:= "" 
Local lMySQL	:= "MYSQL"$Upper(TCGetDB())
Local lMSSQL	:= "MSSQL"$Upper(TCGetDB())
Local cFileName1:= '\SPOOL\Fix141586_1.##R'
Local cFileName2:= '\SPOOL\Fix141586_2.##R'
Local cSalto    := chr(13)+chr(10)

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )   

// Garante que a JBE esteja aberta
dbSelectArea("JBE")
// Monta a query para identificar os alunos afetados (Alunos que estao ATIVOS em dois periodos letivos para o mesmo curso)
cQuery := "SELECT JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA "
cQuery += " FROM "
cQuery += RetSQLName("JBE")+" JBE "
cQuery += " WHERE JBE_FILIAL = '"+xFilial("JBE")+"' AND JBE.D_E_L_E_T_ = ' ' "
cQuery += "   AND JBE_ATIVO = '5' "		//Somente Alunos que estao Formados
cQuery += "   AND JBE_ANOLET = '2007' "	//Somente Alunos deste Ano Letivo
cQuery += "   AND JBE_PERIOD = '02' "	//Somente Alunos deste Periodo Letivo
cQuery += "   AND JBE.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Aluno          " )

while QRY1->( !eof() ) 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSomente efetua compatibiliza็ใo para Alunos que possuam     ณ
	//ณsemestres pendentes. (Alunos que t๊m pend๊ncias de semestresณ
	//ณเ cursar).                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	cQuery := " select  jar.jar_codcur,jar.jar_perlet,jar.jar_habili "
	cQuery += "    from "+retsqlname("jar")+" jar "
	cQuery += "   where jar.jar_filial='"+xfilial("JAR")+"' "
	cQuery += "     and jar.d_e_l_e_t_=' ' "
	cQuery += "     and jar.jar_codcur='"+QRY1->jbe_codcur+"' "
	if lMSSQL 
		cQuery += "     and jar.jar_codcur+jar.jar_perlet+jar.jar_habili not in  "
		cQuery += "    ( select jbe.jbe_codcur+jbe.jbe_perlet+jbe.jbe_habili "
	elseif lMySQL                              
		cQuery += "     and concat(jar.jar_codcur,jar.jar_perlet,jar.jar_habili) not in  "
		cQuery += "    ( select concat(jbe.jbe_codcur,jbe.jbe_perlet,jbe.jbe_habili) "
	else                                              
		cQuery += "     and jar.jar_codcur||jar.jar_perlet||jar.jar_habili not in  "
		cQuery += "    ( select jbe.jbe_codcur||jbe.jbe_perlet||jbe.jbe_habili "
	endif	                                          		
	cQuery += "        from "+retsqlname("JBE")+" jbe "
	cQuery += "       where jbe.jbe_filial='"+xfilial("JBE")+"' "
	cQuery += "         and jbe.d_e_l_e_t_=' ' "
	cQuery += "         and jbe.jbe_numra in ('"+QRY1->jbe_numra+"') ) " 
	cQuery := ChangeQuery( cQuery )
	if Select( "QRY2" ) > 0
		QRY2->( dbCloseArea() )
		dbSelectArea("JAR")
	endif
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	QRY2->( dbgotop() )
	                   
	if QRY2->( !eof() )
		JBE->( dbSetOrder(1) )
		If JBE->( dbSeek( xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR+QRY1->JBE_PERLET+QRY1->JBE_HABILI+QRY1->JBE_TURMA ) )
	 	//while JBE->( !eof() ) .and. JBE->JBE_FILIAL+JBE->JBE_NUMRA+JBE->JBE_CODCUR == xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR 
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )
			RecLock( "JBE", .F. )
			
			JBE->JBE_ATIVO := '1' //Ativa o aluno do periodo letivo
			AcaLog(cFileName1,'RA: '+alltrim(JBE->JBE_NUMRA)+' re-ativado no ๚ltimo periodo. Executar ACAA501 para este antes de proceder com Fix 144133'+cSalto)
			AcaLog(cFileName2,alltrim(JBE->JBE_NUMRA)+'|'+alltrim(JBE->JBE_CODCUR)+'|'+alltrim(JBE->JBE_PERLET)+'|'+alltrim(JBE->JBE_HABILI)+'|'+alltrim(JBE->JBE_TURMA)+'|'+cSalto)
			JBE->( MsUnlock() )
			//JBE->( dbSkip() )
		end
	endif
	QRY1->( dbSkip() )
end 
QRY1->( dbCloseArea() )
msgAlert('Ajuste finalizado. Favor executar a rotina de digita็ใo de hist๓rico livre para os alunos presentes no log: '+cFileName1+ ;
		'. Ap๓s isto, proceder com a fix U_F144133 para realizar a forma็ใo dos alunos novamente.')
RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix144133 บAutor  ณCesar A. Bianchi    บ Data ณ  30/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a acaa350 para re-formar os alunos que foram altera บฑฑ
ฑฑบ          ณdos pela fix U_F141586. Utiliza como base o log secundario  บฑฑ
ฑฑบ          ณgerado pela Fix 141586.                                     บฑฑ 
ฑฑบ          ณATENCAO: Certificar-se de que a rotina acaa500/acaa501 foi  บฑฑ 
ฑฑบ          ณexecutada para cada aluno a ser re-formado no sistema       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de Base de Dados - MP811                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function F144133()
	FixWindow( 144133, {|| F144133Go() } )
Return   

Static Function F144133Go()
Local cLogOri := '/SPOOL/Fix141586_2.##R'   //Arquivo de log de origem (gerado pela fix 141586)
Local cLogNew := '/SPOOL/Fix144133.##R'     //Arquivo de log das modificacoes realizadas por esta funcao. (144133)
Local aParms  := {}	   
Local nI      := 0
Local cLin	  := ''
Local cAux    := ''
Local cMens	  := ''

cMens := 'Aten็ใo: Esta rotina realizarแ a re-forma็ใo dos alunos implicados na inconsist๊ncia relatada no BOPS 141586. '
cMens += 'Certifique-se de que todos os alunos relatados na FIX141586 tiveram os peri๓dos letivos em aus๊ncia corrigidos atrav้s '
cMens += 'da rotina de "Digita็ใo de Hist๓rico Livre (ACAA501) ou "Dig. Historico" (ACAA500). Deseja prosseguir com a execu็ใo ?

if msgYesNo(cMens)	      
	if File(cLogOri)                            
		//Abre aquivo de log da fix 141586
		if ft_fuse(cLogOri) != -1   
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณInicia a execu็ใo da rotina ACAA350 (forma็ใo de alunos), para cada RA presente no arquivo de LOGณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			While !ft_feof()
				//grava linha do arquivo na variavel auxiliar cAux
				cLin := ft_freadln()  
				
			    //Separa o cLin dos pipes
			    For nI := 1 to len(cLin)
			    	if substr(cLin,nI,1) != "|"
			    		cAux += substr(cLin,nI,1)
			    	else
			    		aAdd(aParms,cAux)
			    		cAux := ''
			    	endif
			    Next nI
			    
			    //Executa a forma็ใo de alunos, com os parametros ja alimentados - Acaa350(NUMRA,CODCUR,PERLET,HABILI,TURMA,NIL,NIL) 
		 		Acaa350(aParms[1],aParms[2],aParms[3],aParms[4],aParms[5],NIL,NIL)      
		 		
		 		//Grava no log novo
		 		AcaLog(cLogNew,'Situa็ใo final do RA:' +aParms[1]+' alterada com sucesso')
		 		
		 		//Pula para proxima linha do arquivo de log e limpa as variaveis de auxilio
		 		ft_fskip()
		 		cAux   := ''
		 		aParms := {}
		 		cLin   := ''		
		 	endDo                                          
		   
		 	 //Fecha e exclui o arquivo ao final da rotina
		 	 msgInfo('Rotina de ajuste finalizada. Maiores informa็๕es consultar log de em: '+cLogNew)
		 	 ft_fuse()                                                                                
		 	 fErase(cLogOri)
		 	 	 	
		else
			msgStop('Arquivo de log '+ cLogOri +' gerado pela fix 141586 nใo pode pode ser aberto em modo exclusivo. Execu็ใo abortada.')
		    Return(.F.) 
		endif
	else
		msgStop('Arquivo de log gerado pela fix 141586 nใo encontrado. Execu็ใo abortada.')
	endif
endif	

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_F144133BบAutor  ณCesar A. Bianchi    บ Data ณ  06/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a re-ativa็ใo do aluno em caso FORMADO com discipliบฑฑ
ฑฑบ          ณ nas a cursar, ou com alguma evidencia de JBE ativa.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ajuste de Base de Dados - MP811                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
                                              
User Function F144133B()
	FixWindow( 144133, {|| F144133BGo() } )
Return   

User Function F144133BGo()
Local cQuery := ''
Local aAlunos := {}
Local cFileName1:= '\SPOOL\Fix144133_1.##R'
Local cFileName2:= '\SPOOL\Fix144133_2.##R'
Local nI := 0

//Seleciona alunos com disciplinas adpatcacao e a cursar dentro da JC7 e que estejam formados.
cQuery := " SELECT JC7.JC7_NUMRA NUMRA, JC7.JC7_CODCUR CODCUR, JC7.JC7_HABILI HABILI, JC7.JC7_TURMA TURMA FROM " + retsqlname('JC7') + ' JC7 '
cQuery += " WHERE JC7.JC7_FILIAL = '" + xFilial('JC7') + "'" 
cQuery += " AND JC7_NUMRA IN (SELECT JBE.JBE_NUMRA FROM " + retsqlname('JBE') + "'" 
cQuery += " WHERE JBE.JBE_FILIAL = '" +  xFilial('JC7') + "'"
cQuery += " AND JBE.JBE_ANOLET = '2007' "
cQuery += " AND JBE.JBE_PERIOD = '02' "
cQuery += " AND JBE.JBE_ATIVO = '5' "
cQuery += " AND JBE.D_E_L_E_T_ <> '*') "
cQuery += " AND JC7.JC7_SITDIS = '001' " 
cQuery += " AND JC7.JC7_SITUAC = 'A'  "
cQuery += " AND JC7.D_E_L_E_T_ <> '*' "
cQuery := ChangeQuery(cQuery)
iif(Select( "QRY" ) > 0, QRY->( dbCloseArea() ),Nil)
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
QRY->( dbgotop() )
While QRY->(!Eof())
    AADD(aAlunos,{alltrim(QRY->NUMRA),alltrim(QRY->CODCUR),'',alltrim(QRY->HABILI),alltrim(QRY->TURMA)})
	QRY->(dbSkip())
endDo

  
/*Seleciona alunos que possuem alguma evidencia na JBE como ativa e estao formados*/                                         
cQuery := " SELECT JBE.JBE_NUMRA NUMRA, JBE.JBE_CODCUR CODCUR, JBE.JBE_HABILI HABILI, JBE.JBE_TURMA TURMA FROM " + retsqlname('JBE')
cQuery := " WHERE JBE.JBE_FILIAL = '" + xFilial('JBE') + "'"
cQuery := " AND JBE_NUMRA IN (SELECT JBE2.JBE_NUMRA FROM " + retsqlname('JBE') + ' JBE2 '
cQuery := " JBE2.JBE_FILIAL = '" + xFilial('JBE') + "'"
cQuery := " AND JBE2.JBE_ANOLET = '2007' "
cQuery := " AND JBE2.JBE_PERIOD = '02' "
cQuery := " AND JBE2.JBE_ATIVO = '5' "
cQuery := " AND JBE2.D_E_L_E_T_ <> '*') "
cQuery := " AND JBE.JBE_ATIVO = '1'
cQuery := " AND JBE.D_E_L_E_T_ <> '*' "
cQuery := ChangeQuery(cQuery)
iif(Select( "QRY" ) > 0, QRY->( dbCloseArea() ),Nil)
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
QRY->( dbgotop() )
While QRY->(!Eof())
    AADD(aAlunos,{alltrim(QRY->NUMRA),alltrim(QRY->CODCUR),'',alltrim(QRY->HABILI),alltrim(QRY->TURMA)})
	QRY->(dbSkip())
endDo
    
//Coleta o ultimo perlet do aluno presente no vetor e o reativa no sistema (des-forma)
dbSelectArea('JBE')
JBE->(dbSetOrder(1))
For nI := 1 to len(aAlunos)
	cQuery := " SELECT MAX(JBE_PERLET) PERLET FROM "+ retsqlname('JBE') 
	cQuery += " WHERE JBE_FILIAL = '" + xFilial('JBE') + "'"
	cQuery += " AND JBE_NUMRA = '" + aAlunos[nI,1] + "'"
	cQuery += " AND JBE_CODCUR = '" + aAlunos[nI,2] + "'" 
	cQuery += " AND D_E_L_E_T_ <> '*' " 
	iif(Select( "QRY" ) > 0, QRY->( dbCloseArea() ),Nil)
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
	aAlunos[nI,3] := alltrim(QRY->PERLET)
	
	if JBE->(dbSeek(xFilial('JBE')+aAlunos[nI,1]+aAlunos[nI,2]+aAlunos[nI,3]+aAlunos[nI,4]+aAlunos[nI,5] ))
		RecLock('JBE',.F.)
		JBE->JBE_ATIVO := '1'
		JBE->(msUnlock())
		AcaLog(cFileName1,'RA: '+aAlunos[nI,1]+' re-ativado no ๚ltimo periodo. Executar ACAA501 para este antes de proceder com Fix 144133'+cSalto)
		AcaLog(cFileName2,aAlunos[nI,1]+'|'+aAlunos[nI,2]+'|'+aAlunos[nI,3]+'|'+aAlunos[nI,4]+'|'+aAlunos[nI,5]+'|'+cSalto)
	endif
Next nI

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF142672   บAutor  ณDenis D. Almeida    บ Data ณ  19/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix de Base de Dados para Ajuste de Item nas tabelas JCG e  บฑฑ
ฑฑบ          ณJCH relacionando com a tabela JD2.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F142672()
FixWindow( 142672, {|| F142672Flt() } )
return

Static Function F142672Flt()

local cQuery  := ""
local cAlias  := GetNextAlias()
local cUpdGe  := ""
local cUpdGe2 := ""

cQuery := " SELECT  JCG.*, "
cQuery += " 	JD2.JD2_CODCUR, "
cQuery += " 	JD2.JD2_PERLET, "
cQuery += " 	JD2.JD2_HABILI, "
cQuery += " 	JD2.JD2_TURMA, "
cQuery += " 	JD2.JD2_CODDIS,	 "
cQuery += " 	JD2.JD2_MATPRF, "
cQuery += " 	JD2.JD2_AULA "
cQuery += "    FROM "+retsqlname("jcg")+" JCG, "+retsqlname("jd2")+" JD2 "
cQuery += "   WHERE JCG.JCG_FILIAL = '"+xfilial("JCG")+"' "
cQuery += "     AND JCG.D_E_L_E_T_ = ' ' "
cQuery += "     AND JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += "     AND JD2.D_E_L_E_T_ = ' ' "
cQuery += "     AND JCG.JCG_CODCUR = JD2.JD2_CODCUR "
cQuery += "     AND JCG.JCG_PERLET = JD2.JD2_PERLET "
cQuery += "     AND JCG.JCG_HABILI = JD2.JD2_HABILI "
cQuery += "     AND JCG.JCG_TURMA  = JD2.JD2_TURMA "
cQuery += "     AND JCG.JCG_DISCIP = JD2.JD2_CODDIS "
cQuery += "     AND JCG.JCG_DATA   = JD2.JD2_DATA "
cQuery += "     AND JCG.JCG_MATPRF = JD2.JD2_MATPRF "	
cQuery += "     AND JCG.JCG_ITEM  <> JD2.JD2_AULA  "
cQuery += "     AND JCG.JCG_ITEM NOT IN "
cQuery += " 	( SELECT JD2.JD2_AULA "
cQuery += " 	    FROM "+retsqlname("JD2")+" JD2 "
cQuery += " 	   WHERE JD2.JD2_FILIAL='"+xfilial("JD2")+"' "
cQuery += " 	     AND JD2.D_E_L_E_T_=' ' "
cQuery += "          AND JD2.JD2_CODCUR=JCG.JCG_CODCUR "
cQuery += " 	     AND JD2.JD2_PERLET=JCG.JCG_PERLET "
cQuery += " 	     AND JD2.JD2_HABILI=JCG.JCG_HABILI "
cQuery += "          AND JD2.JD2_TURMA =JCG.JCG_TURMA "
cQuery += "          AND JD2.JD2_CODDIS=JCG.JCG_DISCIP "
cQuery += "          AND JD2.JD2_DATA  =JCG.JCG_DATA "
cQuery += "          AND JD2.JD2_MATPRF=JCG.JCG_MATPRF "
cQuery += "          AND JD2.JD2_AULA  =JCG.JCG_ITEM )  " 
cQuery := ChangeQuery( cQuery )
if Select( cAlias ) > 0
	(cAlias)->( dbCloseArea() )
	dbSelectArea("JCG")
endif
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbGoTop() )
while (cAlias)->( !eof() )
	//Atualiza็ใo das informa็๕es (JCG)
	cUpdGe := " UPDATE "+retsqlname("JCG")+" "
	cUpdGe += "    SET JCG_ITEM='"+(cAlias)->jd2_aula+"' "
	cUpdGe += "   WHERE JCG_FILIAL='"+xfilial("JCG")+"' "
	cUpdGe += "     AND D_E_L_E_T_=' ' "
	cUpdGe += "     AND R_E_C_N_O_='"+alltrim(str((cAlias)->r_e_c_n_o_))+"' "
	TcSqlExec(cUpdGe)
	TcSqlExec("commit") 
	//Atualizando informa็๕es relativas a apontamentos de Faltas por Aluno (JCH)
    cUpdGe2 := " UPDATE "+retsqlname("jch")+" "
    cUpdGe2 += "    SET JCH_ITEM='"+(cAlias)->jd2_aula+"' "
    cUpdGe2 += "  WHERE JCH_FILIAL='"+xfilial("JCH")+"' "
    cUpdGe2 += "    AND D_E_L_E_T_=' ' "
    cUpdGe2 += "    AND JCH_CODCUR='"+(cAlias)->jcg_codcur+"' "
    cUpdGe2 += "    AND JCH_PERLET='"+(cAlias)->jcg_perlet+"' "
    cUpdGe2 += "    AND JCH_HABILI='"+(cAlias)->jcg_habili+"' "
    cUpdGe2 += "    AND JCH_TURMA ='"+(cAlias)->jcg_turma+"' "
    cUpdGe2 += "    AND JCH_DISCIP='"+(cAlias)->jcg_discip+"' "
    cUpdGe2 += "    AND JCH_DATA  ='"+(cAlias)->jcg_data+"' "
    cUpdGe2 += "    AND JCH_MATPRF='"+(cAlias)->jcg_matprf+"' "
    TcSqlExec(cUpdGe2)
	TcSqlExec("commit") 
	(cAlias)->( dbskip() )
end
(cAlias)->( dbCloseArea() )

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ F143440    บ Autor ณOtacilio A. Junior  บ Data ณ01/04/2008 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณFaz a atualizacao da carga horaria do curso vigente,        บฑฑ
ฑฑบ          ณde acordo com as cargas informadas nos periodos letivos.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ GESTAO EDUCACIONAL                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F143440()
FixWindow( 143440, {|| F143440G() } )
Return    

Static Function F143440G()

Local lFirst       := .T. 
Local cCodCur      := ""
Local cAnoLet      := ""
Local cPerlet      := "" 
Local cJARHab      := ""
Local cJASHab      := ""
Local nTotalCrgPer := 0                 	// Soma total de horas da carga horaria no periodo letivo
Local nTotalCrgCur := 0                 	// Soma total de horas da carga horaria do curso
Local nCount	:= 0

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando cursos" )
cQuery := "select JAS_CODCUR"
cQuery += "  from "+RetSQLName("JAS")+" jas "
cQuery += " where jas_filial = '"+xFilial("JAS")+"' and jas.d_e_l_e_t_ = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TMP", .F., .F. )

TMP->( dbEval( {|| nCount++ } ) )
TMP->( dbCloseArea() )

ProcRegua( nCount )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza a carga do periodo letivo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("JAS")
dbSetOrder(1)
dbGoTop()
cCodCur:= JAS->JAS_CODCUR
cPerlet:= JAS->JAS_PERLET
cJASHab:= JAS->JAS_HABILI
	
While !JAS->(Eof()) 
        
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" registros..." )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEfetua a soma das cargas horarias de apenas um periodo letivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If JAS->JAS_CARGA > 0 .and. lFirst
	     nTotalCrgPer += JAS->JAS_CARGA			
	EndIf
	
	JAS->(DbSkip())
	If cCodcur+cPerlet <> JAS->(JAS_CODCUR+JAS_PERLET)
		
		JAR->(dbSetOrder(1))
	
		JAR->(MsSeek(xFilial("JAR")+cCodcur+cPerlet+cJASHab))
	
		RecLock("JAR",.F.)
		JAR->JAR_CARGA := nTotalCrgPer
		JAR->(MsUnlock())
		lFirst:= .T.
	Else
	    If Empty(cJASHab)
	    	lFirst := .T.
	    	Loop
	    Else 
	        lFirst := .F.
	    	JAS->(DbSkip())
	    EndIf
	EndIf						
	
	If cCodCur == JAS->JAS_CODCUR .AND. cPerlet <> JAS->JAS_PERLET
		cCodCur:= JAS->JAS_CODCUR
		cPerlet:= JAS->JAS_PERLET
		cJASHab:= JAS->JAS_HABILI
		nTotalCrgPer:= 0
       Loop
    ElseIf cCodCur+cPerlet <> JAS->JAS_CODCUR+JAS->JAS_PERLET
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza a carga horaria do curso vigente ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		JAR->(MsSeek(xFilial("JAR")+cCodCur))
		cAnolet := JAR->JAR_ANOLET
		cPerlet := JAR->JAR_PERLET
		cJARHab := JAR->JAR_HABILI
	
		While !JAR->(Eof()) .And. (JAR->JAR_FILIAL+JAR->JAR_CODCUR == xFilial("JAR")+cCodCur)
			
			If  !lFirst 
			    If cAnolet+cPerlet <> JAR->(JAR_ANOLET+JAR_PERLET)
			       	cAnolet:= JAR->JAR_ANOLET
					cPerlet:= JAR->JAR_PERLET
					cJARHab:= JAR->JAR_HABILI
			  		lFirst := .T.
			    Else
			    	If cJARHab == JAR->JAR_HABILI
				  		lFirst := .T.
	                EndIf
			    EndIf
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณEfetua a soma das cargas horarias de todos os periodos letivos ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If JAR->JAR_CARGA > 0 .and. lFirst
			    lFirst := .F.
				nTotalCrgCur += JAR->JAR_CARGA		
			EndIf
				
			JAR->(dbSkip())
		End                                                                     
		JAH->(dbSetOrder(1))
		IF JAH->(MsSeek(xFilial("JAH")+cCodCur))
			RecLock("JAH",.F.)
			JAH->JAH_CARGA := nTotalCrgCur
			JAH->(MsUnlock()) 
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+cCodcur )			
		EndIf
		       
		nTotalCrgPer:= 0
		nTotalCrgCur:= 0
		cCodCur     := JAS->JAS_CODCUR		
		cPerlet     := JAS->JAS_PERLET 
		cJASHab 	:= JAS->JAS_HABILI
		lFirst      := .T.
	EndIf
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza a carga horaria do curso vigente ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
JAR->(MsSeek(xFilial("JAR")+cCodCur))
cAnolet := JAR->JAR_ANOLET
cPerlet := JAR->JAR_PERLET
cJARHab := JAR->JAR_HABILI
	
While !JAR->(Eof()) .And. (JAR->JAR_FILIAL+JAR->JAR_CODCUR == xFilial("JAR")+cCodCur)
			
	If  !lFirst 
	    If cAnolet+cPerlet <> JAR->(JAR_ANOLET+JAR_PERLET)
	       	cAnolet:= JAR->JAR_ANOLET
			cPerlet:= JAR->JAR_PERLET
			cJARHab:= JAR->JAR_HABILI
	  		lFirst := .T.
	    Else
	    	If cJARHab == JAR->JAR_HABILI
				lFirst := .T.
			EndIf
		EndIf
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEfetua a soma das cargas horarias de todos os periodos letivos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If JAR->JAR_CARGA > 0 .and. lFirst
	    lFirst := .F.
		nTotalCrgCur += JAR->JAR_CARGA		
	EndIf
	JAR->(dbSkip())
End                                                                     
JAH->(dbSetOrder(1))
IF JAH->(MsSeek(xFilial("JAH")+cCodCur))
	RecLock("JAH",.F.)
	JAH->JAH_CARGA := nTotalCrgCur
	JAH->(MsUnlock()) 
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Curso Vigente: "+cCodcur )			
EndIf
Return     


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIX143282 บAutor  ณCesar A. Bianchi    บ Data ณ  07/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix para compatibilizacao da JGL_SITFIM, criada via acaa500 บฑฑ
ฑฑบ          ณe alterada via acaa501 - BOPS143282                         บฑฑ 
ฑฑบ          ณATENCAO: Esta fix nao deve ser executada p/ casos em que ja บฑฑ
ฑฑบ          ณexistam registros criados via acaa501 					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811 - Gestao Educacional                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User function Fix143282()
	FixWindow(00000143282, {|| F143282Go('JGL') } )
Return 

Function F143282Go
Local cQuery := ''

//Seleciona os registros a serem alterados	
cQuery := "SELECT JGL.JGL_FILIAL FILIAL, JGL.JGL_NUM NUM, JGL.JGL_SITFIM SITFIM " 
cQuery += " FROM " + retsqlname('JGL') + " JGL "
cQuery += " WHERE JGL.JGL_FILIAL = '" + xFilial('JGL') + "' "
cQuery += " AND JGL.JGL_SITFIM <> ''" 
cQuery += " AND JGL.D_E_L_E_T_ <> '*'"  
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), "QRYJGL", .T., .T. )       
        
//Inicia a alteracao da JGL_SITFIM                                           
dbSelectArea('JGL') 
JGL->(dbSetOrder(1))
While QRYJGL->(!Eof())                       
	If JGL->(dbSeek(QRYJGL->FILIAL+QRYJGL->NUM))
		RecLock('JGL',.F.)
		Do Case                           
			Case alltrim(QRYJGL->SITFIM) == '1'
	        	JGL->JGL_SITFIM := '4'
	        Case alltrim(QRYJGL->SITFIM) == '2'
			    JGL->JGL_SITFIM := '5'
		    Case alltrim(QRYJGL->SITFIM) == '3'
				JGL->JGL_SITFIM := '6'    
		    Case alltrim(QRYJGL->SITFIM) == '4'
				JGL->JGL_SITFIM := '7'    
		    Case alltrim(QRYJGL->SITFIM) == '5'
				JGL->JGL_SITFIM := '8'	    
		    Case alltrim(QRYJGL->SITFIM) == '6'
			    JGL->JGL_SITFIM := '9'
		    Case alltrim(QRYJGL->SITFIM) == '7'
				JGL->JGL_SITFIM := 'A'	    
		    Case alltrim(QRYJGL->SITFIM) == '8' 
				JGL->JGL_SITFIM := ''	    
		    Case alltrim(QRYJGL->SITFIM) == '9'
			    JGL->JGL_SITFIM := ''
 	   	EndCase
 	   	JGL->(msUnlock())
	endif
	QRYJGL->(dbSkip())
EndDo
QRYJGL->(dbCloseArea())
	
Return
                                                                              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF143926   บAutor  ณKAREN HONDA         บ Data ณ  09/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix de Base de Dados para Ajuste da JC7_SITUAC que foi alte-บฑฑ
ฑฑบ          ณrada para Cursando, sendo que seu status devia ser Trancado บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F143926()
FixWindow( 143926, {|| F143926Flt() } )
return

Static Function F143926Flt()

local cQuery  := ""
local cAlias  := GetNextAlias()
local cUpdGe  := ""
Local cSituac := ""

cQuery := " SELECT  JC7_FILIAL, "
cQuery += " 	JC7_NUMRA, "
cQuery += " 	JC7_CODCUR, "
cQuery += " 	JC7_PERLET, "
cQuery += " 	JC7_HABILI, "
cQuery += " 	JC7_DISCIP, "
cQuery += " 	JC7_SITDIS, "
cQuery += " 	JC7_SITUAC, "
cQuery += " 	R_E_C_N_O_  "
cQuery += " FROM " + RetSqlName("JC7")+" JC7 "
cQuery += " WHERE JC7_FILIAL = '" + xfilial("JC7")+"' "
cQuery += " AND JC7_SITDIS Not in ('001','002','010','006') "
cQuery += " AND JC7_SITUAC = '1' "
cQuery += " AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
if Select( cAlias ) > 0
	(cAlias)->( dbCloseArea() )
	dbSelectArea("JC7")
endif
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbGoTop() )
while (cAlias)->( !eof() )

	If (cAlias)->JC7_SITDIS $ "003/011"
		cSituac := "8"
	ElseIf (cAlias)->JC7_SITDIS $ "008/009"
		cSituac := "9"
	ElseIf (cAlias)->JC7_SITDIS $ "004"
		cSituac := "7"
	Else
		cSituac := (cAlias)->JC7_SITUAC
	EndIf	
	//Atualiza็ใo das informa็๕es (JC7)
	
	cUpdGe := " UPDATE "+ RetSqlName("JC7") + " "
	cUpdGe += "    SET JC7_SITUAC='" + cSituac + "' "
	cUpdGe += "   WHERE JC7_FILIAL='"+xfilial("JC7")+"' "
	cUpdGe += "     AND D_E_L_E_T_=' ' "
	cUpdGe += "     AND R_E_C_N_O_="+alltrim(str((cAlias)->R_E_C_N_O_))+" "
	TcSqlExec(cUpdGe)
	TcSqlExec("commit") 
	
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+ " FILIAL: "+(cAlias)->JC7_FILIAL + " RA: "+(cAlias)->JC7_NUMRA + " Curso: "+(cAlias)->JC7_CODCUR + " RECNO: "+alltrim(str((cAlias)->R_E_C_N_O_))+ " Discip: "+(cAlias)->JC7_DISCIP + " Situac: " + (cAlias)->JC7_SITDIS+"/"+ cSituac )				
	
	(cAlias)->( dbskip() )
end
(cAlias)->( dbCloseArea() )

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ F145595    บ Autor ณOtacilio A. Junior  บ Data ณ01/04/2008 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณFaz a atualizacao da carga horaria do curso vigente,        บฑฑ
ฑฑบ          ณde acordo com as cargas informadas nos periodos letivos.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ GESTAO EDUCACIONAL                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F145595()
FixWindow( 145595, {|| F145595G() } )
Return    

Static Function F145595G()
Local nCount := 0

SE1->(DbSetOrder(1))
AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando titulos" )
cQuery := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, SE5.R_E_C_N_O_ SE5_RECNO "
cQuery += "FROM "+RetSQLName("SE1")+" SE1,"+RetSQLName("SE5")+" SE5 "
cQuery += "WHERE E1_FILIAL = '"+SM0->M0_CODFIL+"'"
cQuery += "  AND SE1.D_E_L_E_T_ = ' '"
cQuery += "  AND SE5.E5_FILIAL = SE1.E1_FILIAL"
cQuery += "  AND SE5.d_e_l_e_t_ = ' '"
cQuery += "  AND E1_PREFIXO = 'REM'"
cQuery += "  AND SE1.e1_num = SE5.e5_numero"
cQuery += "  AND SE1.e1_parcela = SE5.e5_parcela"
cQuery += "  AND SE1.e1_cliente = SE5.e5_clifor"
cQuery += "  AND SE1.e1_loja = SE5.e5_loja"
cQuery += "  AND SE5.e5_prefixo = 'MAT'"


cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TMP", .F., .F. )

TMP->(dbEval({|| nCount++ }))

ProcRegua( nCount )
TMP->(DBGOTOP())

While TMP->(!EOF())
	SE5->(DbGoTo(TMP->SE5_RECNO))
	RecLock("SE5",.F.)
	SE5->E5_PREFIXO := TMP->E1_PREFIXO
	SE5->(MsUnLock())
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+SE5->(E5_FILIAL+" "+E5_PREFIXO+" "+E5_NUMERO+" "+E5_CLIFOR+" "+E5_LOJA)+" Recno:"+Str(TMP->SE5_RECNO,10))
	IncProc()
	TMP->(DbSkip())
End	
TMP->(DbCloseArea())
DbSelectArea("JA2")
AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Processamento concluํdo." )
Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF146423   บAutor  ณCesar A. Bianchi    บ Data ณ  30/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFix de ajuste da base de dados, para corre็ใo dos campos    บฑฑ
ฑฑบ          ณJC7_SITUAC e JC7_SITDIS, alimentados incorretamente, quando บฑฑ
ฑฑบ          ณna analise de grade curricular, as disciplinas pertencentes บฑฑ
ฑฑบ          ณa periodos letivos superiores sao gravadas como dispensadas บฑฑ
ฑฑบ          ณe na JC7 ficam como a cursar.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP811 - GESTAO EDUCACIONAL - AJUSTE DE BASE DE DADOS       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function F146423()
FixWindow( 146423, {|| F146423Go() } )
Return()
                                      
Static Function F146423Go()
Local cQuery := ''
Local aReq := {}
Local aFix := {} 
Local nI := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณColeta todos os requerimentos de "Aproveitmento de Estudos"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT JBH.JBH_NUM NUMREQ, JBH.JBH_CODIDE NUMRA FROM " +retsqlname('JBH') + " JBH "
cQuery += " WHERE JBH.JBH_FILIAL = '" + xFilial('JBH') + "' "  
cQuery += " AND JBH.JBH_TIPO = '000032' " //ATENCAO: Chumbado o valor 000032 pois eh o codigo do cliente para req. aproveit. estudo
cQuery += " AND JBH.JBH_STATUS = '1' "    //Somente requerimentos deferidos integralmente.
cQuery += " AND JBH.D_E_L_E_T_ <> '*' " 
cQuery := ChangeQuery( cQuery )                                 
iif(Select('QRY')>0,QRY->(dbCloseArea()),NIl)
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
QRY->(dbGoTop())

While QRY->(!Eof())
	aADD(aReq,{alltrim(QRY->NUMRA),alltrim(QRY->NUMREQ)})
	QRY->(dbSkip())
EndDo
QRY->(dbCloseArea())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o requerimento possui alguma disciplina com ณ
//ณsituacao 003 Dispensado, na analise de grade curricular ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI := 1 to len(aReq) 
	cQuery := "SELECT JCT.JCT_DISCIP CODDIS, JCT.JCT_PERLET PERLET FROM " + retsqlname('JCT') + " JCT "
	cQuery += " WHERE JCT.JCT_FILIAL = '" + xFilial('JCT') + "' "
	cQuery += " AND JCT.JCT_NUMREQ = '" + aReq[nI,2] + "' "
	cQuery += " AND JCT.JCT_SITUAC = '003' "   //Somente disciplinas dispensadas.
	cQuery += " AND JCT.D_E_L_E_T_ <> '*' " 
	cQuery := ChangeQuery(cQuery)
	iif(Select('QRYJCT')>0,QRYJCT->(dbCloseArea()),NIl)
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYJCT", .F., .F. )
	QRYJCT->(dbGoTop())
	
	//Armazena no vetor aFix, as disciplinas que o aluno foi dispensado na analise de grade cur.
	While QRYJCT->(!Eof())
	    if !Empty(alltrim(QRYJCT->CODDIS))
	     	aAdd(aFix,{aReq[nI,1],aReq[nI,2],alltrim(QRYJCT->CODDIS),alltrim(QRYJCT->PERLET)})
	    endif
		QRYJCT->(dbSkip())
	EndDo
	
	//Fecha area da JCT	
	iif(Select('QRYJCT')>0,QRYJCT->(dbCloseArea()),NIl)
Next nI  
  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca na JC7 as disciplinas que o aluno foi dispensado na    ณ
//ณanalise de grade cur e ajusta para dispensado caso nao estejaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea('JC7')
JC7->(dbSetOrder(1)) 
dbSelectArea('JCO')
JCO->(dbSetOrder(1))
For nI :=1 to len(aFix)
	cQuery := " SELECT DISTINCT JC7.JC7_NUMRA NUMRA, JC7.JC7_CODCUR CODCUR, JC7.JC7_PERLET PERLET, JC7.JC7_HABILI HABILI, "
	cQuery += " JC7.JC7_TURMA TURMA, JC7.JC7_DISCIP CODDIS, JC7.JC7_MEDFIM MEDFIM, JC7.JC7_MEDCON MEDCON FROM " + retsqlname('JC7') + " JC7 "
	cQuery += " WHERE JC7.JC7_FILIAL = '" + xFilial('JC7') + "' "
	cQuery += " AND JC7.JC7_NUMRA = '" + aFix[nI,1] + "' " 
	cQuery += " AND JC7.JC7_PERLET = '" + aFix[nI,4] + "' "
	cQuery += " AND JC7.JC7_DISCIP = '" +  aFix[nI,3] + "' "
	cQuery += " AND JC7.JC7_SITDIS = '010' " 
	cQuery += " AND JC7.JC7_SITUAC = '1' " 
	cQuery += " AND JC7.D_E_L_E_T_ <> '*' " 
	cQuery := ChangeQuery(cQuery)
	iif(Select('QRY')>0,QRY->(dbCloseArea()),NIl)
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
	
	                                     
	//Caso tenha encontrado algum registro referente a disciplina futura com dispensa
	if !Empty(alltrim(QRY->NUMRA))
		if JC7->(dbSeek(xFilial('JC7') +QRY->NUMRA+QRY->CODCUR+QRY->PERLET+QRY->HABILI+QRY->TURMA+QRY->CODDIS))
			AcaLog( cLogFile, 'O Registro JC7: '+xFilial('JC7')+' '+alltrim(QRY->NUMRA)+' '+alltrim(QRY->CODCUR)+' '+alltrim(QRY->PERLET)+' '+ ;
				alltrim(QRY->HABILI)+' '+alltrim(QRY->TURMA+QRY->CODDIS)+' foi alterado com sucesso.')
			RecLock('JC7',.F.)
			JC7->JC7_SITDIS := '003'
			JC7->JC7_SITUAC := '8'
			JC7->(msUnlock())
		endif   	
	endif                
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBusca na JCO a dispensa desta disciplina. Caso nao exista, grava-aณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    if JCO->(!dbSeek(xFilial('JCO')+QRY->NUMRA+QRY->CODCUR+QRY->PERLET+QRY->HABILI+QRY->CODDIS))
    	RecLock('JCO',.T.)     	
    	JCO->JCO_FILIAL := xFilial('JCO')
    	JCO->JCO_NUMRA := alltrim(QRY->NUMRA)
    	JCO->JCO_CODCUR := alltrim(QRY->CODCUR)
    	JCO->JCO_PERLET := alltrim(QRY->PERLET)
    	JCO->JCO_DISCIP := alltrim(QRY->CODDIS)
    	JCO->JCO_HABILI := alltrim(QRY->HABILI)
    	JCO->JCO_MEDFIM := QRY->MEDFIM
    	JCO->JCO_MEDCON := alltrim(QRY->MEDCON)
    	JCO->(msUnlock())
    	
    	AcaLog( cLogFile, 'O Registro JCO: '+xFilial('JC7')+' '+alltrim(QRY->NUMRA)+' '+alltrim(QRY->CODCUR)+' '+alltrim(QRY->PERLET)+' '+alltrim(QRY->HABILI)+' foi criado com sucesso.')
    endif
	
	//Fecha area temporaria
	iif(Select('QRY')>0,QRY->(dbCloseArea()),NIl)	 
	
Next nI


Return()

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ F147552    บ Autor ณOtacilio A. Junior  บ Data ณ17/06/2008 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณFaz a atualizacao do campo JD1_NUMRA atraves do numero da   บฑฑ
ฑฑบ          ณrequisi็ใo cadastrada.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ GESTAO EDUCACIONAL                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F147552()
FixWindow( 147552, {|| F147552G() } )
Return    

Static Function F147552G()
Local cQuery := ""      
DbSelectArea("JD1")

cQuery:= "SELECT DISTINCT JBH.jbh_num NUMREQ, JBH.jbh_codide NUMRA, JCT.jct_discip," 
cQuery+= "                JBH.jbh_tipo      , JBH.jbh_filial      , JD1.jd1_item  ,"
cQuery+= "                JD1.jd1_numra     , JD1.r_e_c_n_o_  JD1Recno "
cQuery+= "FROM "+RetSqlName("JCT")+" JCT, "+RetSqlName("JBH")+" JBH, "
cQuery+= RetSqlName("JD1")+" JD1 "
cQuery+= "WHERE JCT.jct_filial = '"+SM0->M0_CODFIL+"'"
cQuery+= "  and JBH.jbh_filial = JCT.jct_filial"
cQuery+= "  and JD1.jd1_filial = JCT.jct_filial"
cQuery+= "  AND JD1.jd1_numreq = JCT.jct_numreq"
cQuery+= "  and JBH.jbh_num    = JCT.jct_numreq"
cQuery+= "  AND JD1.jd1_discip = JCT.jct_discip"
cQuery+= "  AND JCT.jct_situac = '003'" //Somente disciplinas dispensadas
cQuery+= "  AND JBH.jbh_status = '1'"   //Somente requerimentos deferidos
cQuery+= "  AND JBH.d_e_l_e_t_ = ' '"
cQuery+= "  AND JCT.d_e_l_e_t_ = ' '"
cQuery+= "  AND JD1.d_e_l_e_t_ = ' '"
cQuery+= "ORDER BY JBH.jbh_filial, JBH.jbh_num"

iif(Select('QRYJCT')>0,QRYJCT->(dbCloseArea()),NIl)
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYJCT", .F., .F. )
QRYJCT->(dbGoTop())

While QRYJCT->(!Eof())
    JD1->(DbGoTo(QRYJCT->JD1Recno))
    RecLock("JD1",.F.)
    JD1->JD1_NUMRA := QRYJCT->NUMRA
    JD1->(MsUnLock())
   	AcaLog( cLogFile,	'O Registro JD1: '+xFilial('JD1')+' '+alltrim(JD1->JD1_NUMREQ)+;
   	                    ' '+alltrim(JD1->JD1_NUMRA)+' '+alltrim(JD1->JD1_CODCUR)+;
   	                    ' '+alltrim(JD1->JD1_PERLET)+' '+alltrim(JD1->JD1_HABILI)+' foi atualizado com sucesso.')
	QRYJCT->(dbSkip())
EndDo

//Fecha area da JCT	
iif(Select('QRYJCT')>0,QRYJCT->(dbCloseArea()),NIl)
DbSelectArea("JD1")

Return()
