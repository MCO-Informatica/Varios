#include "rwmake.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FixWindow ºAutor  ³Rafael Rodrigues    º Data ³ 09/Fev/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta janela para confirmacao da execucao dos diversos      º±±
±±º          ³Fix.                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Ajuste de base de dados                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

aAdd(aSays, "Este programa tem como objetivo ajustar a base de dados afetada pela não-conformidade" )
aAdd(aSays, "registrada no BOPS nº "+Alltrim(Str(nBOPS))+".")
aAdd(aSays, " ")
aAdd(aSays, "O processamento da correção pode levar alguns minutos.")

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
//Run Fix
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
	
	// Executa a correção para a empresa/filial
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

AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Processamento concluído." )
AcaLog( cLogFile, "" )

MsgAlert( "Programa de correçao finalizado!"+Chr(13)+Chr(10)+"Consulte o arquivo '"+cLogFile+"' para maiores detalhes." )

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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIX144126 ºAutor  ³Cesar A. Bianchi    º Data ³  07/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP811 - Gestao Educacional                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User function Fix144126()
	FixWindow(00000144126, {|| F144126Go('JMR') } )
Return 

Static Function F144126Go

//Ajusta os codigos da JMR
dbSelectArea('JMR')
JMR->(dbSetOrder(1))

if JMR->(FieldPos('JMR_PUBLIC')) <= 0
	MsgStop('O ambiente selecionado para execução da fix nao possui a UPDGAC05 aplicada.')
	Return(.F.)
endif

dbSelectArea('JM3')
JM3->(dbSetOrder(1))
While JMR->(!Eof())
    if JM3->(dbSeek(xFilial('JM3')+JMR->JMR_LIVRO))
    	RecLock('JMR',.F.)
    	JMR->JMR_PUBLIC := alltrim(JM3->JM3_PUBLIC)
    	JMR->(msUnlock())
    endif
	JMR->(dbSkip())
EndDo   

//Ajusta os codigos da JMS
dbSelectArea('JMS')
JMS->(dbSetOrder(1))
dbSelectArea('JM5')
JM5->(dbSetOrder(1))
While JMS->(!Eof())
    if JM5->(dbSeek(xFilial('JM5')+JMS->JMS_DOCUM))
    	RecLock('JMS',.F.)
    	JMS->JMS_PUBLIC := alltrim(JM5->JM5_PUBLIC)
    	JMS->(msUnlock())
    endif
	JMS->(dbSkip())
EndDo   
	
Return

