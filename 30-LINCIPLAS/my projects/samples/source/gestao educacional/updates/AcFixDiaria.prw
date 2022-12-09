#INCLUDE "ACADEF.CH"
#Include "Protheus.ch"
#include "rwmake.ch"  

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FixWindow ∫Autor  ≥Rafael Rodrigues    ∫ Data ≥ 09/Fev/2006 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Monta janela para confirmacao da execucao dos diversos      ∫±±
±±∫          ≥Fix.                                                        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Ajuste de base de dados                                     ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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

aAdd(aSays, "Este programa tem como objetivo ajustar a base de dados afetada pela n„o-conformidade" )
aAdd(aSays, "registrada no BOPS n∫ "+Alltrim(Str(nBOPS))+".")
aAdd(aSays, " ")
aAdd(aSays, "O processamento da correÁao pode levar alguns minutos.")

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
	
	// Executa a correÁ„o para a empresa/filial
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
AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Processamento concluÌdo." )
AcaLog( cLogFile, "" )

MsgAlert( "Programa de correÁao finalizado!"+Chr(13)+Chr(10)+"Consulte o arquivo '"+cLogFile+"' para maiores detalhes." )

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
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AFixGrProc∫Autor  ≥Denis D. Almeida    ∫ Data ≥  16/01/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Efetua compatibilizaÁ„o de tabelas jc7 jd2 e jbl integridadeπ±±
±±∫          ≥referencial - sp_AcertItemJD2                               ∫±±
±±∫          ≥CriaÁ„o de Procedures                               		  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Gestao Educacional                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function AFixGrProc()

local cQuery := ""
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Dropando as Procedures se as mesmas j· existirem na Base≥
//≥de Dados.                                               ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " if exists (select name from sysobjects where name = N'sp_AcertItemJD2' and type = 'P') "
cQuery += " drop procedure sp_AcertItemJD2 "
TcSqlExec( cQuery )

cQuery := " if exists (select name from sysobjects where name = N'sp_cBKPjc7DEL' and type = 'P')
cQuery += " drop procedure sp_cBKPjc7DEL "
TcSqlExec( cQuery )

cQuery := " if exists (select name from sysobjects where name = N'sp_cCompatibJD2JBL' and type = 'P')
cQuery += " drop procedure sp_cCompatibJD2JBL "
TcSqlExec( cQuery )

cQuery := " if exists (select name from sysobjects where name = N'sp_cCreateBKPJBLJD2' and type = 'P')
cQuery += " drop procedure sp_cCreateBKPJBLJD2 "
TcSqlExec( cQuery )

cQuery := " if exists (select name from sysobjects where name = N'sp_cExluiJBL' and type = 'P')
cQuery += " drop procedure sp_cExluiJBL "
TcSqlExec( cQuery )

cQuery := " if exists (select name from sysobjects where name = N'sp_cInsDadosJC7' and type = 'P')
cQuery += " drop procedure sp_cInsDadosJC7 "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_AcertItemJD2≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create procedure sp_AcertItemJD2 "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + " begin transaction "
cQuery += Chr(10) + " declare crAtuJD2 cursor "
cQuery += Chr(10) + "   local "
cQuery += Chr(10) + "       for " 
cQuery += Chr(10) + " 	SELECT   DISTINCT "
cQuery += Chr(10) + " 		 	 JD2_FILIAL,JD2_CODCUR,JD2_PERLET,JD2_TURMA,JD2_HABILI "
cQuery += Chr(10) + " 	    FROM "+retsqlname("JD2")+" JD2 "
cQuery += Chr(10) + " 	   WHERE JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += Chr(10) + " 	     AND JD2.D_E_L_E_T_ = ' ' "     	     
cQuery += Chr(10) + " 	     AND JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_ITEM+JD2.JD2_CODLOC+JD2.JD2_CODPRE+ "
cQuery += Chr(10) + " 		 JD2.JD2_ANDAR+JD2.JD2_CODSAL+JD2.JD2_MATPRF " 
cQuery += Chr(10) + " 		NOT IN " 
cQuery += Chr(10) + " 		 ( SELECT DISTINCT "
cQuery += Chr(10) + " 			  JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL.JBL_CODLOC+JBL.JBL_CODPRE+ "
cQuery += Chr(10) + " 		 	  JBL.JBL_ANDAR+JBL.JBL_CODSAL+JBL.JBL_MATPRF "
cQuery += Chr(10) + " 		     FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + " 	   	    WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + " 	     	  AND JBL.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " 	ORDER BY "
cQuery += Chr(10) + " 		JD2.JD2_CODCUR, "
cQuery += Chr(10) + " 		JD2.JD2_PERLET "
cQuery += Chr(10) + " "  	
cQuery += Chr(10) + " 	declare @xFilial  char(2) "
cQuery += Chr(10) + " 	declare @cCodCur  char(6) "
cQuery += Chr(10) + " 	declare @cPerlet  char(2) "
cQuery += Chr(10) + " 	declare @cHabili  char(6) "
cQuery += Chr(10) + " 	declare @cTurma   char(3) "		
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	Open crAtuJD2 "
cQuery += Chr(10) + " 	fetch next from crAtuJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cHabili "
cQuery += Chr(10) + " "
cQuery += Chr(10) + "    	while @@fetch_status = 0 "  	   	   	  		
cQuery += Chr(10) + " 	    begin "	
cQuery += Chr(10) + " " 		
cQuery += Chr(10) + " 		declare crEfetJD2 cursor "
cQuery += Chr(10) + " 		  local "
cQuery += Chr(10) + " 		      for "   	
cQuery += Chr(10) + " 			SELECT DISTINCT "
cQuery += Chr(10) + " 			       JD2_FILIAL,JD2_CODCUR,JD2_PERLET,JD2_TURMA,JD2_ITEM,JD2_CODHOR,JD2_HORA1,JD2_HORA2, "
cQuery += Chr(10) + " 		 	       JD2_CODDIS,JD2_MATPRF,JD2_MATPR2,JD2_MATPR3,JD2_MATPR4,JD2_MATPR5,JD2_MATPR6,JD2_MATPR7, "
cQuery += Chr(10) + " 			       JD2_MATPR8,JD2_DIASEM,JD2_CODLOC,JD2_CODPRE,JD2_ANDAR,JD2_CODSAL,JD2_REMUNE, "
cQuery += Chr(10) + " 			       JD2_HABILI,JD2.D_E_L_E_T_,JD2.R_E_C_N_O_,JD2.R_E_C_D_E_L_,JD2_SUBTUR "
cQuery += Chr(10) + " 			  FROM "+retsqlname("JD2")+" JD2 "
cQuery += Chr(10) + " 			 WHERE JD2.JD2_FILIAL = @xFilial "
cQuery += Chr(10) + " 			   AND JD2.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 			   AND JD2.JD2_CODCUR = @cCodCur "
cQuery += Chr(10) + " 			   AND JD2.JD2_PERLET = @cPerlet "
cQuery += Chr(10) + " 			   AND JD2.JD2_HABILI = @cHabili "
cQuery += Chr(10) + " 			   AND JD2.JD2_TURMA  = @cTurma "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 			declare @xFilial1  char(2) "
cQuery += Chr(10) + " 			declare @cCodCur1  char(6) "
cQuery += Chr(10) + " 			declare @cPerlet1  char(2) "
cQuery += Chr(10) + " 			declare @cHabili1  char(6) "
cQuery += Chr(10) + " 			declare @cTurma1   char(3) "
cQuery += Chr(10) + " 			declare @cCodDis   char(15) "
cQuery += Chr(10) + " 			declare @cCodHor   char(15) "	
cQuery += Chr(10) + " 			declare @cCodLoc   char(6) "
cQuery += Chr(10) + " 			declare @cCodPre   char(6) "
cQuery += Chr(10) + " 			declare @cAndar    char(6) "	
cQuery += Chr(10) + " 			declare @cSala     char(6) "
cQuery += Chr(10) + " 			declare @cData1    char(8) "
cQuery += Chr(10) + " 			declare @cData2    char(8) "
cQuery += Chr(10) + " 			declare @cRemune   char(1) "
cQuery += Chr(10) + " 			declare @cDelete   char(1) "
cQuery += Chr(10) + " 			declare @cSubTur   char(6) "
cQuery += Chr(10) + " 			declare @nRecDel   int "
cQuery += Chr(10) + " 			declare @cMatprf   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr2   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr3   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr4   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr5   char(6) "	
cQuery += Chr(10) + " 			declare @cMatpr6   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr7   char(6) "
cQuery += Chr(10) + " 			declare @cMatpr8   char(6) "
cQuery += Chr(10) + " 			declare @cDiasem   char(1) "
cQuery += Chr(10) + " 			declare @cHora1    char(8) "
cQuery += Chr(10) + " 			declare @cHora2    char(8) "
cQuery += Chr(10) + " 			declare @cItem     char(3) "
cQuery += Chr(10) + " 			declare @nRecno    int "
cQuery += Chr(10) + " 			declare @ncont     int "	
cQuery += Chr(10) + " 			declare @cCursoVg  char(6) "
cQuery += Chr(10) + " 			declare @nTotJblM  int "
cQuery += Chr(10) + " 			declare @nRecnoM   int "
cQuery += Chr(10) + " 			declare @cItemNew  char(3) "
cQuery += Chr(10) + " " 			
cQuery += Chr(10) + " 			Open crEfetJD2 "
cQuery += Chr(10) + " 			fetch next from crEfetJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 			 @cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 			 @cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala, "  
cQuery += Chr(10) + " 			 @cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + " " 	
cQuery += Chr(10) + " 			set @ncont 	= 1 "
cQuery += Chr(10) + " 			set @cCursoVg	= '      ' "
cQuery += Chr(10) + " 		   	while @@fetch_status = 0 "  	  
cQuery += Chr(10) + " " 		 	
cQuery += Chr(10) + " 		   	  begin "  	    
cQuery += Chr(10) + " 			    if ( @cCursoVg != @cCodCur ) "		
cQuery += Chr(10) + " 			      begin "  
cQuery += Chr(10) + " 			        set @ncont = 1 "	
cQuery += Chr(10) + " 			        set @cCursoVg = @cCodCur "			   
cQuery += Chr(10) + " 			      end "
cQuery += Chr(10) + " 			      set @cItemNew = Replicate('0',(3 - Len(Cast(@ncont as Varchar(3)))))+Cast(@ncont as Varchar(3)) "				      
cQuery += Chr(10) + " "  	
cQuery += Chr(10) + " 			    UPDATE 	"+retsqlname("JD2")+" "
cQuery += Chr(10) + " 				   SET  JD2_ITEM   	   = @cItemNew "
cQuery += Chr(10) + " 				 WHERE 	JD2_FILIAL     = @xFilial "
cQuery += Chr(10) + " 			       AND 	D_E_L_E_T_ = ' ' "			           
cQuery += Chr(10) + " 			       AND 	R_E_C_N_O_ = @nRecno "	
cQuery += Chr(10) + " "	
cQuery += Chr(10) + " 				   set @ncont  = @ncont+1 "	
cQuery += Chr(10) + " " 
cQuery += Chr(10) + " 			      fetch next from crEfetJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 				@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 				@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala, "
cQuery += Chr(10) + " 				@cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + " 			  end "	  
cQuery += Chr(10) + " 		Close crEfetJD2 "
cQuery += Chr(10) + " 	       Deallocate crEfetJD2 "	
cQuery += Chr(10) + " " 	       
cQuery += Chr(10) + " 	    fetch next from crAtuJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cHabili "
cQuery += Chr(10) + " 	    end "
cQuery += Chr(10) + " " 		   		   
cQuery += Chr(10) + "  Close crAtuJD2 "
cQuery += Chr(10) + " Deallocate crAtuJD2 "
cQuery += Chr(10) + " " 
cQuery += Chr(10) + " if @@error <> 0 "
cQuery += Chr(10) + "   rollback	 "
cQuery += Chr(10) + " else  "
cQuery += Chr(10) + "   commit "
TcSqlExec( cQuery )  
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_cBKPjc7DEL≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create  procedure sp_cBKPjc7DEL "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + " BEGIN TRANSACTION "
cQuery += Chr(10) + " INSERT INTO JC7BKP "
cQuery += Chr(10) + " 	(JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_TURMA,JC7_HABILI,JC7_DISCIP, "
cQuery += Chr(10) + " 	 JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_AMG,JC7_SITDIS,JC7_SITUAC, "
cQuery += Chr(10) + " 	 JC7_DIASEM,JC7_CODHOR,JC7_HORA1,JC7_HORA2,JC7_CODPRF,JC7_CODPR2,JC7_CODPR3,JC7_CODPR4, "
cQuery += Chr(10) + " 	 JC7_CODPR5,JC7_CODPR6,JC7_CODPR7,JC7_CODPR8,JC7_NUMPRO,JC7_OUTCUR,JC7_OUTPER, "
cQuery += Chr(10) + " 	 JC7_OUTTUR,JC7_OUTHAB,JC7_MEDFIM,JC7_DISDP,JC7_SITDP,JC7_BOLETO,JC7_DPBAIX, "
cQuery += Chr(10) + " 	 JC7_CURDP,JC7_PERDP,JC7_TURDP,JC7_CURORI,JC7_HABDP,JC7_PERORI,JC7_TURORI, "
cQuery += Chr(10) + " 	 JC7_DISORI,JC7_SITORI,JC7_HABORI,JC7_MEDCON,JC7_CODINS,JC7_ANOINS,JC7_MEDANT, "
cQuery += Chr(10) + " 	 JC7_DESMCO,JC7_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JC7_SUBTUR) "
cQuery += Chr(10) + " SELECT 	 "
cQuery += Chr(10) + " 	JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_TURMA,JC7_HABILI,JC7_DISCIP, "
cQuery += Chr(10) + " 	JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_AMG,JC7_SITDIS,JC7_SITUAC, "
cQuery += Chr(10) + " 	JC7_DIASEM,JC7_CODHOR,JC7_HORA1,JC7_HORA2,JC7_CODPRF,JC7_CODPR2,JC7_CODPR3,JC7_CODPR4, "
cQuery += Chr(10) + " 	JC7_CODPR5,JC7_CODPR6,JC7_CODPR7,JC7_CODPR8,JC7_NUMPRO,JC7_OUTCUR,JC7_OUTPER, "
cQuery += Chr(10) + " 	JC7_OUTTUR,JC7_OUTHAB,JC7_MEDFIM,JC7_DISDP,JC7_SITDP,JC7_BOLETO,JC7_DPBAIX, "
cQuery += Chr(10) + " 	JC7_CURDP,JC7_PERDP,JC7_TURDP,JC7_CURORI,JC7_HABDP,JC7_PERORI,JC7_TURORI, "
cQuery += Chr(10) + " 	JC7_DISORI,JC7_SITORI,JC7_HABORI,JC7_MEDCON,JC7_CODINS,JC7_ANOINS,JC7_MEDANT, "
cQuery += Chr(10) + " 	JC7_DESMCO,JC7_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JC7_SUBTUR "
cQuery += Chr(10) + "   FROM  "+retsqlname("JC7")+" JC7 "
cQuery += Chr(10) + "  WHERE  JC7.JC7_FILIAL = '"+xfilial("JC7")+"' "
cQuery += Chr(10) + "    AND  JC7.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + "    AND  JC7.JC7_OUTCUR = ' ' "
cQuery += Chr(10) + "    AND  JC7.JC7_MEDFIM = 0 "
cQuery += Chr(10) + "    AND  JC7.JC7_SITDIS = '010' "
cQuery += Chr(10) + "    AND  JC7.JC7_SITUAC = '1' "		
cQuery += Chr(10) + "    AND  JC7.JC7_DISCIP + JC7.JC7_CODLOC + JC7.JC7_CODPRE + JC7.JC7_DIASEM + "
cQuery += Chr(10) + "         JC7.JC7_ANDAR + JC7.JC7_CODSAL + JC7.JC7_CODPRF + JC7.JC7_HORA1 NOT IN "
cQuery += Chr(10) + "        	(SELECT DISTINCT  "
cQuery += Chr(10) + " 	   			 JBL.JBL_CODDIS + JBL.JBL_CODLOC + JBL.JBL_CODPRE + "
cQuery += Chr(10) + "                JBL.JBL_DIASEM + JBL.JBL_ANDAR + JBL.JBL_CODSAL + "
cQuery += Chr(10) + "                JBL.JBL_MATPRF + JBL.JBL_HORA1 "
cQuery += Chr(10) + "           FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + "          WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + "            AND JBL.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + "    AND 	JC7.JC7_NUMRA+JC7.JC7_CODCUR+JC7.JC7_PERLET+JC7.JC7_HABILI+JC7.JC7_TURMA+JC7.JC7_DISCIP NOT IN  "
cQuery += Chr(10) + " 		( SELECT DISTINCT  "
cQuery += Chr(10) + " 		         JCH.JCH_NUMRA+JCH.JCH_CODCUR+JCH.JCH_PERLET+JCH.JCH_HABILI+JCH.JCH_TURMA+JCH.JCH_DISCIP "
cQuery += Chr(10) + " 		    FROM "+retsqlname("JCH")+" JCH  "
cQuery += Chr(10) + " 		   WHERE JCH.JCH_FILIAL='"+xfilial("JCH")+"'  "
cQuery += Chr(10) + " 		     AND JCH.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + "    AND 	JC7.JC7_NUMRA+JC7.JC7_CODCUR+JC7.JC7_PERLET+JC7.JC7_HABILI+JC7.JC7_TURMA+JC7.JC7_DISCIP NOT IN  "
cQuery += Chr(10) + " 	( SELECT DISTINCT  "
cQuery += Chr(10) + " 	         JBS.JBS_NUMRA+JBS.JBS_CODCUR+JBS.JBS_PERLET+JBS.JBS_HABILI+JBS.JBS_TURMA+JBS.JBS_CODDIS "
cQuery += Chr(10) + " 	    FROM "+retsqlname("JBS")+" JBS  "
cQuery += Chr(10) + " 	   WHERE JBS.JBS_FILIAL='"+xfilial("JBS")+"'  "
cQuery += Chr(10) + " 	     AND JBS.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + "   GROUP BY "
cQuery += Chr(10) + " 	JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_TURMA,JC7_HABILI,JC7_DISCIP, "
cQuery += Chr(10) + " 	JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_AMG,JC7_SITDIS,JC7_SITUAC, "
cQuery += Chr(10) + " 	JC7_DIASEM,JC7_CODHOR,JC7_HORA1,JC7_HORA2,JC7_CODPRF,JC7_CODPR2,JC7_CODPR3,JC7_CODPR4, "
cQuery += Chr(10) + " 	JC7_CODPR5,JC7_CODPR6,JC7_CODPR7,JC7_CODPR8,JC7_NUMPRO,JC7_OUTCUR,JC7_OUTPER, "
cQuery += Chr(10) + " 	JC7_OUTTUR,JC7_OUTHAB,JC7_MEDFIM,JC7_DISDP,JC7_SITDP,JC7_BOLETO,JC7_DPBAIX, "
cQuery += Chr(10) + " 	JC7_CURDP,JC7_PERDP,JC7_TURDP,JC7_CURORI,JC7_HABDP,JC7_PERORI,JC7_TURORI, "
cQuery += Chr(10) + " 	JC7_DISORI,JC7_SITORI,JC7_HABORI,JC7_MEDCON,JC7_CODINS,JC7_ANOINS,JC7_MEDANT, "
cQuery += Chr(10) + " 	JC7_DESMCO,JC7_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JC7_SUBTUR "
cQuery += Chr(10) + " declare crAtJC7 cursor "
cQuery += Chr(10) + "    local "
cQuery += Chr(10) + "       for "
cQuery += Chr(10) + " 	SELECT  "	
cQuery += Chr(10) + " 			JC7.JC7_NUMRA,  "
cQuery += Chr(10) + " 			JC7.JC7_CODCUR, "
cQuery += Chr(10) + " 	        JC7.JC7_PERLET, "
cQuery += Chr(10) + " 	        JC7.JC7_HABILI, "
cQuery += Chr(10) + " 	        JC7.JC7_TURMA, "
cQuery += Chr(10) + " 	        JC7.JC7_DISCIP, "
cQuery += Chr(10) + " 	        JC7.JC7_CODPRF, "
cQuery += Chr(10) + " 	        JC7.JC7_DIASEM, "
cQuery += Chr(10) + " 	        JC7.JC7_HORA1, "
cQuery += Chr(10) + " 	        JC7.JC7_HORA2, "
cQuery += Chr(10) + " 	        JC7.R_E_C_N_O_, "
cQuery += Chr(10) + " 	        cast(JC7.JC7_CODLOC as varchar(6)) JC7_CODLOC, "
cQuery += Chr(10) + " 	        cast(JC7.JC7_CODPRE as varchar(6)) JC7_CODPRE, "
cQuery += Chr(10) + " 	        cast(JC7.JC7_ANDAR  as varchar(6)) JC7_ANDAR, "
cQuery += Chr(10) + " 	        cast(JC7.JC7_CODSAL as varchar(6)) JC7_CODSAL "
cQuery += Chr(10) + " 	  FROM 	"+retsqlname("JC7")+" JC7 "
cQuery += Chr(10) + " 	 WHERE 	JC7.JC7_FILIAL = '"+xfilial("JC7")+"' "
cQuery += Chr(10) + " 	   AND 	JC7.D_E_L_E_T_ = ' '    "
cQuery += Chr(10) + " 	   AND 	JC7.JC7_OUTCUR = ' ' "
cQuery += Chr(10) + " 	   AND  JC7.JC7_SITDIS = '010' "
cQuery += Chr(10) + " 	   AND  JC7.JC7_SITUAC = '1' "
cQuery += Chr(10) + " 	   AND 	JC7.JC7_DISCIP + JC7.JC7_CODLOC + JC7.JC7_CODPRE + JC7.JC7_DIASEM + "
cQuery += Chr(10) + " 	       	JC7.JC7_ANDAR + JC7.JC7_CODSAL + JC7.JC7_CODPRF + JC7.JC7_HORA1 NOT IN "
cQuery += Chr(10) + " 	       	(SELECT DISTINCT  "
cQuery += Chr(10) + " 					JBL.JBL_CODDIS + JBL.JBL_CODLOC + JBL.JBL_CODPRE + "
cQuery += Chr(10) + " 	                JBL.JBL_DIASEM + JBL.JBL_ANDAR + JBL.JBL_CODSAL + "
cQuery += Chr(10) + " 	                JBL.JBL_MATPRF + JBL.JBL_HORA1 "
cQuery += Chr(10) + " 	          FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + " 	         WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + " 	           AND JBL.D_E_L_E_T_ = ' ' ) "               
cQuery += Chr(10) + "      AND 	JC7.JC7_NUMRA+JC7.JC7_CODCUR+JC7.JC7_PERLET+JC7.JC7_HABILI+JC7.JC7_TURMA+JC7.JC7_DISCIP NOT IN  "
cQuery += Chr(10) + " 		( SELECT DISTINCT  "
cQuery += Chr(10) + " 		         JCH.JCH_NUMRA+JCH.JCH_CODCUR+JCH.JCH_PERLET+JCH.JCH_HABILI+JCH.JCH_TURMA+JCH.JCH_DISCIP "
cQuery += Chr(10) + " 		    FROM "+retsqlname("JCH")+" JCH  "
cQuery += Chr(10) + " 		   WHERE JCH.JCH_FILIAL='"+xfilial("JCH")+"'  "
cQuery += Chr(10) + " 		     AND JCH.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + "      AND 	JC7.JC7_NUMRA+JC7.JC7_CODCUR+JC7.JC7_PERLET+JC7.JC7_HABILI+JC7.JC7_TURMA+JC7.JC7_DISCIP NOT IN  "
cQuery += Chr(10) + " 		( SELECT DISTINCT  "
cQuery += Chr(10) + " 	         	JBS.JBS_NUMRA+JBS.JBS_CODCUR+JBS.JBS_PERLET+JBS.JBS_HABILI+JBS.JBS_TURMA+JBS.JBS_CODDIS "
cQuery += Chr(10) + " 	    	FROM "+retsqlname("JBS")+" JBS  "
cQuery += Chr(10) + " 	   	   WHERE JBS.JBS_FILIAL='"+xfilial("JBS")+"'  "
cQuery += Chr(10) + " 	         AND JBS.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " 	  GROUP BY "
cQuery += Chr(10) + " 			JC7.JC7_NUMRA,  "
cQuery += Chr(10) + " 		 	JC7.JC7_CODCUR, "
cQuery += Chr(10) + " 	        JC7.JC7_PERLET, "
cQuery += Chr(10) + " 	        JC7.JC7_HABILI, "
cQuery += Chr(10) + " 	        JC7.JC7_TURMA, "
cQuery += Chr(10) + " 	        JC7.JC7_DISCIP, "
cQuery += Chr(10) + " 	        JC7.JC7_CODPRF, "
cQuery += Chr(10) + " 	        JC7.JC7_DIASEM, "
cQuery += Chr(10) + " 	        JC7.JC7_HORA1, "
cQuery += Chr(10) + " 	        JC7.JC7_HORA2, "
cQuery += Chr(10) + " 	        JC7.R_E_C_N_O_, "
cQuery += Chr(10) + " 	        JC7.JC7_CODLOC, "
cQuery += Chr(10) + " 	        JC7.JC7_CODPRE, "
cQuery += Chr(10) + " 	        JC7.JC7_ANDAR, "
cQuery += Chr(10) + " 	        JC7.JC7_CODSAL "
cQuery += Chr(10) + " "
cQuery += Chr(10) + "	declare @cNumra   char(15) "
cQuery += Chr(10) + "	declare @cCodCur  char(6) "
cQuery += Chr(10) + "	declare @cPerlet  char(2) "
cQuery += Chr(10) + "	declare @cHabili  char(6) "
cQuery += Chr(10) + "	declare @cTurma   char(3) "
cQuery += Chr(10) + "	declare @cCodDis  char(15) "
cQuery += Chr(10) + "	declare @cCodLoc  char(6) "
cQuery += Chr(10) + "	declare @cCodPre  char(6) "
cQuery += Chr(10) + "	declare @cAndar   char(6) "
cQuery += Chr(10) + "	declare @cSala    char(6) "
cQuery += Chr(10) + "	declare @cMatprf  char(6) "	
cQuery += Chr(10) + "	declare @cDiasem  char(1) "
cQuery += Chr(10) + "	declare @cHora1   char(8) "
cQuery += Chr(10) + "	declare @cHora2   char(8) "
cQuery += Chr(10) + "	declare @nRecno   int "
cQuery += Chr(10) + "	declare @ncont    int "		
cQuery += Chr(10) + " "
cQuery += Chr(10) + "	Open crAtJC7 "
cQuery += Chr(10) + "	fetch next from crAtJC7 into @cNumra,@cCodCur,@cPerlet,@cHabili,@cTurma,@cCodDis,@cMatprf,@cDiasem,@cHora1, "
cQuery += Chr(10) + "		@cHora2,@nRecno,@cCodLoc,@cCodPre,@cAndar,@cSala "
cQuery += Chr(10) + "	set @ncont = 1 "
cQuery += Chr(10) + "	while @@fetch_status = 0 "
cQuery += Chr(10) + "	   begin "
cQuery += Chr(10) + " "
cQuery += Chr(10) + "		DELETE FROM "+retsqlname("JC7")+" WHERE R_E_C_N_O_ = @nRecno "
cQuery += Chr(10) + "		set @ncont = @ncont+1  "
cQuery += Chr(10) + " "
cQuery += Chr(10) + "		fetch next from crAtJC7 into @cNumra,@cCodCur,@cPerlet,@cHabili,@cTurma,@cCodDis,@cMatprf,@cDiasem,@cHora1, "
cQuery += Chr(10) + "			@cHora2,@nRecno,@cCodLoc,@cCodPre,@cAndar,@cSala "
cQuery += Chr(10) + "	   end	"
cQuery += Chr(10) + "Close crAtJC7 "
cQuery += Chr(10) + "Deallocate crAtJC7 "
cQuery += Chr(10) + " "
cQuery += Chr(10) + "IF @@ERROR <> 0 "
cQuery += Chr(10) + "   ROLLBACK	 "
cQuery += Chr(10) + "ELSE  "
cQuery += Chr(10) + "   COMMIT "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_cCompatibJD2JBL≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create  procedure sp_cCompatibJD2JBL "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + " BEGIN TRANSACTION  "
cQuery += Chr(10) + " ALTER TABLE "+retsqlname("JBL")+" ALTER COLUMN JBL_ITEM VARCHAR(3) NOT NULL  "
cQuery += Chr(10) + " ALTER TABLE "+retsqlname("JD2")+" ALTER COLUMN JD2_ITEM VARCHAR(3) NOT NULL "
cQuery += Chr(10) + " UPDATE  "+retsqlname("JD2")+" "
cQuery += Chr(10) + "     SET JD2_ITEM=Replicate('0',(3 - Len(Cast(JD2_ITEM as Varchar(3)))))+Cast(JD2_ITEM as Varchar(3)) "
cQuery += Chr(10) + "   WHERE JD2_FILIAL='"+xfilial("JD2")+"' "
cQuery += Chr(10) + "     AND D_E_L_E_T_=' ' "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " declare crInsJD2 cursor "
cQuery += Chr(10) + "   local "
cQuery += Chr(10) + "       for " 
cQuery += Chr(10) + " 	SELECT   DISTINCT "
cQuery += Chr(10) + " 		 JD2_FILIAL,JD2_CODCUR,JD2_PERLET,JD2_TURMA,JD2_ITEM,JD2_CODHOR,JD2_HORA1,JD2_HORA2, "
cQuery += Chr(10) + " 		 JD2_CODDIS,JD2_MATPRF,JD2_MATPR2,JD2_MATPR3,JD2_MATPR4,JD2_MATPR5,JD2_MATPR6,JD2_MATPR7, "
cQuery += Chr(10) + " 		 JD2_MATPR8,JD2_DIASEM,JD2_CODLOC,JD2_CODPRE,JD2_ANDAR,JD2_CODSAL,JAR.JAR_DATA1,JAR.JAR_DATA2, "
cQuery += Chr(10) + " 		 JD2_REMUNE,JD2_HABILI,JD2.D_E_L_E_T_,JD2.R_E_C_N_O_,JD2.R_E_C_D_E_L_,JD2_SUBTUR "
cQuery += Chr(10) + " 	    FROM "+retsqlname("JD2")+" JD2, "+retsqlname("JAR")+" JAR "
cQuery += Chr(10) + " 	   WHERE JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += Chr(10) + " 	     AND JD2.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 	     AND JAR.JAR_FILIAL = '"+xfilial("JAR")+"' "
cQuery += Chr(10) + " 	     AND JAR.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 	     AND JD2.JD2_CODCUR = JAR.JAR_CODCUR "
cQuery += Chr(10) + " 	     AND JD2.JD2_PERLET = JAR.JAR_PERLET "
cQuery += Chr(10) + " 	     AND JD2.JD2_HABILI = JAR.JAR_HABILI "
cQuery += Chr(10) + " 	     AND JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_ITEM+JD2.JD2_CODLOC+JD2.JD2_CODPRE+ "
cQuery += Chr(10) + " 		 JD2.JD2_ANDAR+JD2.JD2_CODSAL+JD2.JD2_MATPRF  "
cQuery += Chr(10) + " 		NOT IN  "
cQuery += Chr(10) + " 		 ( SELECT DISTINCT "
cQuery += Chr(10) + " 			  JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL.JBL_CODLOC+JBL.JBL_CODPRE+ "
cQuery += Chr(10) + " 		 	  JBL.JBL_ANDAR+JBL.JBL_CODSAL+JBL.JBL_MATPRF  "
cQuery += Chr(10) + " 		     FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + " 	   	    WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + " 	     	  AND JBL.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " 	ORDER BY "
cQuery += Chr(10) + " 		JD2.JD2_CODCUR, "
cQuery += Chr(10) + " 		JD2.JD2_PERLET, "
cQuery += Chr(10) + " 		JD2.JD2_ITEM "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	declare @xFilial  char(2) "
cQuery += Chr(10) + " 	declare @cCodCur  char(6) "
cQuery += Chr(10) + " 	declare @cPerlet  char(2) "
cQuery += Chr(10) + " 	declare @cHabili  char(6) "
cQuery += Chr(10) + " 	declare @cTurma   char(3) "
cQuery += Chr(10) + " 	declare @cCodDis  char(15) "
cQuery += Chr(10) + " 	declare @cCodHor  char(15) "
cQuery += Chr(10) + " 	declare @cCodLoc  char(6) "
cQuery += Chr(10) + " 	declare @cCodPre  char(6) "
cQuery += Chr(10) + " 	declare @cAndar   char(6) "	
cQuery += Chr(10) + " 	declare @cSala    char(6) "
cQuery += Chr(10) + " 	declare @cData1   char(8) "
cQuery += Chr(10) + " 	declare @cData2   char(8) "
cQuery += Chr(10) + " 	declare @cRemune  char(1) "
cQuery += Chr(10) + " 	declare @cDelete  char(1) "
cQuery += Chr(10) + " 	declare @cSubTur  char(6) "
cQuery += Chr(10) + " 	declare @nRecDel  int "
cQuery += Chr(10) + " 	declare @cMatprf  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr2  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr3  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr4  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr5  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr6  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr7  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr8  char(6) "
cQuery += Chr(10) + " 	declare @cDiasem  char(1) "
cQuery += Chr(10) + " 	declare @cHora1   char(8) "
cQuery += Chr(10) + " 	declare @cHora2   char(8) "
cQuery += Chr(10) + " 	declare @cItem    char(3) "
cQuery += Chr(10) + " 	declare @nRecno   int "
cQuery += Chr(10) + " 	declare @ncont    int "
cQuery += Chr(10) + " 	declare @cCursoVg char(6) "
cQuery += Chr(10) + " 	declare @nTotJblM int "
cQuery += Chr(10) + " 	declare @nRecnoM  int  "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	Open crInsJD2 "
cQuery += Chr(10) + " 	fetch next from crInsJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 		@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 		@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala  ,@cData1 ,@cData2 , "
cQuery += Chr(10) + " 		@cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	set @ncont 	= 1 "
cQuery += Chr(10) + " 	set @cCursoVg	= '      ' "
cQuery += Chr(10) + "    	while @@fetch_status = 0 "  
cQuery += Chr(10) + "  "
cQuery += Chr(10) + "    	  begin "  	    
cQuery += Chr(10) + " 	    if ( @cCursoVg != @cCodCur ) "
cQuery += Chr(10) + " 	      begin "
cQuery += Chr(10) + " 	        set @ncont = 1 "
cQuery += Chr(10) + " 	        set @cCursoVg = @cCodCur "
cQuery += Chr(10) + " 	      end "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	SELECT  @nTotJblM = COUNT(*) "
cQuery += Chr(10) + " 	   FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + "           WHERE JBL.JBL_FILIAL=@xFilial "
cQuery += Chr(10) + "             AND JBL.D_E_L_E_T_=' ' "
cQuery += Chr(10) + "             AND JBL.JBL_CODCUR=@cCodCur "
cQuery += Chr(10) + "             AND JBL.JBL_PERLET=@cPerlet "
cQuery += Chr(10) + "             AND JBL.JBL_HABILI=@cHabili "
cQuery += Chr(10) + "             AND JBL.JBL_TURMA =@cTurma "
cQuery += Chr(10) + "             AND JBL.JBL_DIASEM=@cDiasem "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + "             AND JBL.JBL_ITEM  =@cItem "
cQuery += Chr(10) + " " 	    	 
cQuery += Chr(10) + " 	if @nTotJblM = 0 "
cQuery += Chr(10) + " 	    begin "
cQuery += Chr(10) + " 		SELECT @nRecnoM = MAX(R_E_C_N_O_)+1 FROM JBL010 "
cQuery += Chr(10) + " 		INSERT INTO "+retsqlname("JBL")+" "
cQuery += Chr(10) + " 		    (JBL_FILIAL,JBL_CODCUR,JBL_PERLET,JBL_TURMA,JBL_ITEM,JBL_CODHOR,JBL_HORA1,JBL_HORA2, "
cQuery += Chr(10) + " 		     JBL_CODDIS,JBL_MATPRF,JBL_MATPR2,JBL_MATPR3,JBL_MATPR4,JBL_MATPR5,JBL_MATPR6,JBL_MATPR7, "
cQuery += Chr(10) + " 		     JBL_MATPR8,JBL_DIASEM,JBL_CODLOC,JBL_CODPRE,JBL_ANDAR,JBL_CODSAL,JBL_DATA1,JBL_DATA2, "
cQuery += Chr(10) + " 		     JBL_REMUNE,JBL_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JBL_SUBTUR) "
cQuery += Chr(10) + " 		VALUES "
cQuery += Chr(10) + " 		    (@xFilial,@cCodCur,@cPerlet,@cTurma,@cItem, "
cQuery += Chr(10) + " 		     @cCodHor,@cHora1,@cHora2,@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4, "
cQuery += Chr(10) + " 		     @cMatpr5,@cMatpr6,@cMatpr7,@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar , "
cQuery += Chr(10) + " 	         @cSala  ,@cData1 ,@cData2 ,@cRemune,@cHabili,' ',@nRecnoM ,0, "
cQuery += Chr(10) + " 	         @cSubTur) "
cQuery += Chr(10) + " 	    end		 "
cQuery += Chr(10) + " 	else "
cQuery += Chr(10) + " 	    begin	 "
cQuery += Chr(10) + " 		UPDATE 	"+retsqlname("JBL")+" "
cQuery += Chr(10) + " 		   SET  JBL_CODHOR = @cCodHor, "
cQuery += Chr(10) + " 				JBL_HORA1  = @cHora1, "
cQuery += Chr(10) + " 				JBL_HORA2  = @cHora2, "
cQuery += Chr(10) + " 		    	JBL_CODDIS = @cCodDis, "
cQuery += Chr(10) + " 				JBL_MATPRF = @cMatprf, "
cQuery += Chr(10) + " 				JBL_MATPR2 = @cMatpr2, "
cQuery += Chr(10) + " 				JBL_MATPR3 = @cMatpr3, "
cQuery += Chr(10) + " 				JBL_MATPR4 = @cMatpr4, "
cQuery += Chr(10) + " 				JBL_MATPR5 = @cMatpr5, "
cQuery += Chr(10) + " 				JBL_MATPR6 = @cMatpr6, "
cQuery += Chr(10) + " 				JBL_MATPR7 = @cMatpr7, "
cQuery += Chr(10) + " 		    	JBL_MATPR8 = @cMatpr8, "
cQuery += Chr(10) + " 		    	JBL_DIASEM = @cDiasem, "
cQuery += Chr(10) + " 				JBL_CODLOC = @cCodLoc, "
cQuery += Chr(10) + " 				JBL_CODPRE = @cCodPre, "
cQuery += Chr(10) + " 				JBL_ANDAR  = @cAndar, "
cQuery += Chr(10) + " 				JBL_CODSAL = @cSala, "
cQuery += Chr(10) + " 				JBL_DATA1  = @cData1, "
cQuery += Chr(10) + " 				JBL_DATA2  = @cData2, "
cQuery += Chr(10) + " 		       	JBL_REMUNE = @cRemune,  "	
cQuery += Chr(10) + " 		       	JBL_SUBTUR = @cSubTur,	 "	
cQuery += Chr(10) + " 			JBL_ITEM   = @cItem "
cQuery += Chr(10) + " 		 WHERE 	JBL_FILIAL = @xFilial "
cQuery += Chr(10) + " 	       AND 	D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 	       AND 	JBL_CODCUR = @cCodCur "
cQuery += Chr(10) + " 	       AND 	JBL_PERLET = @cPerlet "
cQuery += Chr(10) + " 	       AND 	JBL_HABILI = @cHabili "
cQuery += Chr(10) + " 	       AND 	JBL_TURMA  = @cTurma "
cQuery += Chr(10) + " 	       AND 	JBL_DIASEM = @cDiasem "
cQuery += Chr(10) + " 	       AND 	JBL_ITEM   = @cItem	 "	       	 		
cQuery += Chr(10) + " 	    end	"
cQuery += Chr(10) + " 	    set @ncont  = @ncont+1 "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	    fetch next from crInsJD2 into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 		@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 		@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala  ,@cData1 ,@cData2 , "
cQuery += Chr(10) + " 		@cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + " 	end	"
cQuery += Chr(10) + "  Close crInsJD2 "
cQuery += Chr(10) + " Deallocate crInsJD2 "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " IF @@ERROR <> 0 "
cQuery += Chr(10) + "    ROLLBACK "
cQuery += Chr(10) + " ELSE "
cQuery += Chr(10) + "    COMMIT "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_cCreateBKPJBLJD2≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create procedure sp_cCreateBKPJBLJD2 "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JBLBKP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) "
cQuery += Chr(10) + " drop table [dbo].[JBLBKP] "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " BEGIN TRANSACTION "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " CREATE TABLE [dbo].[JBLBKP] ( "
cQuery += Chr(10) + " 	[JBL_FILIAL] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODCUR] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_PERLET] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_TURMA]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_ITEM]   [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODHOR] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_HORA1]  [varchar] (5) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_HORA2]  [varchar] (5) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODDIS] [varchar] (15)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPRF] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR2] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR3] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR4] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR5] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR6] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR7] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_MATPR8] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_DIASEM] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODLOC] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODPRE] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_ANDAR]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_CODSAL] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_DATA1]  [varchar] (8) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_DATA2]  [varchar] (8) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_REMUNE] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JBL_HABILI] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[D_E_L_E_T_] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[R_E_C_N_O_] [int]     NOT NULL , "
cQuery += Chr(10) + " 	[R_E_C_D_E_L_] [float] NOT NULL , "
cQuery += Chr(10) + " 	[JBL_SUBTUR] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL, "
cQuery += Chr(10) + "     [TIPO_OPER]  [varchar] (4) COLLATE Latin1_General_BIN NOT NULL,   "
cQuery += Chr(10) + " 	[JBL_DATA]  [varchar] (8) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " ) ON [PRIMARY] "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JC7BKP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) "
cQuery += Chr(10) + " drop table [dbo].[JC7BKP] "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " CREATE TABLE [dbo].[JC7BKP] ( "
cQuery += Chr(10) + " 	[JC7_FILIAL] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_NUMRA] [varchar] (15) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODCUR] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_PERLET] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_TURMA]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_HABILI] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DISCIP] [varchar] (15)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODLOC] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPRE] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_ANDAR]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODSAL] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_AMG]    [float]   NOT NULL , "
cQuery += Chr(10) + " 	[JC7_SITDIS] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_SITUAC] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DIASEM] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODHOR] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_HORA1]  [varchar] (5) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_HORA2]  [varchar] (5) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPRF] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR2] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR3] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR4] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR5] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR6] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR7] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODPR8] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_NUMPRO] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_OUTCUR] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_OUTPER] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_OUTTUR] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_OUTHAB] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_MEDFIM] [float]   NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DISDP]  [varchar] (15)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_SITDP]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_BOLETO] [varchar] (12)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DPBAIX] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CURDP]  [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_PERDP]  [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_TURDP]  [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CURORI] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_HABDP]  [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_PERORI] [varchar] (2) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_TURORI] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DISORI] [varchar] (15)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_SITORI] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_HABORI] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_MEDCON] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_CODINS] [varchar] (6) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_ANOINS] [varchar] (20)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_MEDANT] [float]   NOT NULL , "
cQuery += Chr(10) + " 	[JC7_DESMCO] [varchar] (30)COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[JC7_TIPCUR] [varchar] (3) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[D_E_L_E_T_] [varchar] (1) COLLATE Latin1_General_BIN NOT NULL , "
cQuery += Chr(10) + " 	[R_E_C_N_O_] [int]     NOT NULL , "
cQuery += Chr(10) + " 	[R_E_C_D_E_L_] [float] NOT NULL , "
cQuery += Chr(10) + " 	[JC7_SUBTUR] [varchar] (4) COLLATE Latin1_General_BIN NOT NULL  "
cQuery += Chr(10) + " ) ON [PRIMARY] "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " INSERT INTO JBLBKP "
cQuery += Chr(10) + " 	(JBL_FILIAL,JBL_CODCUR,JBL_PERLET,JBL_TURMA,JBL_ITEM,JBL_CODHOR,JBL_HORA1,JBL_HORA2, "
cQuery += Chr(10) + " 	 JBL_CODDIS,JBL_MATPRF,JBL_MATPR2,JBL_MATPR3,JBL_MATPR4,JBL_MATPR5,JBL_MATPR6,JBL_MATPR7, "
cQuery += Chr(10) + " 	 JBL_MATPR8,JBL_DIASEM,JBL_CODLOC,JBL_CODPRE,JBL_ANDAR,JBL_CODSAL,JBL_DATA1,JBL_DATA2, "
cQuery += Chr(10) + " 	 JBL_REMUNE,JBL_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JBL_SUBTUR,TIPO_OPER,JBL_DATA) "
cQuery += Chr(10) + " SELECT   DISTINCT "
cQuery += Chr(10) + " 	 JBL_FILIAL,JBL_CODCUR,JBL_PERLET,JBL_TURMA,JBL_ITEM,JBL_CODHOR,JBL_HORA1,JBL_HORA2, "
cQuery += Chr(10) + " 	 JBL_CODDIS,JBL_MATPRF,JBL_MATPR2,JBL_MATPR3,JBL_MATPR4,JBL_MATPR5,JBL_MATPR6,JBL_MATPR7, "
cQuery += Chr(10) + " 	 JBL_MATPR8,JBL_DIASEM,JBL_CODLOC,JBL_CODPRE,JBL_ANDAR,JBL_CODSAL,JBL_DATA1,JBL_DATA2, "
cQuery += Chr(10) + " 	 JBL_REMUNE,JBL_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JBL_SUBTUR,'JBL',' ' "
cQuery += Chr(10) + "     FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + "    WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + "      AND JBL.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + "      AND JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL.JBL_CODLOC+JBL.JBL_CODPRE+ "
cQuery += Chr(10) + " 	 JBL.JBL_ANDAR+JBL.JBL_CODSAL+JBL.JBL_MATPRF NOT IN  "
cQuery += Chr(10) + " 	 ( SELECT DISTINCT "
cQuery += Chr(10) + " 		  JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_ITEM+JD2.JD2_CODLOC+JD2.JD2_CODPRE+ "
cQuery += Chr(10) + " 	 	  JD2.JD2_ANDAR+JD2.JD2_CODSAL+JD2.JD2_MATPRF  "
cQuery += Chr(10) + " 	     FROM "+retsqlname("JD2")+" JD2 "
cQuery += Chr(10) + "    	WHERE JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += Chr(10) + "      	  AND JD2.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " ORDER BY "
cQuery += Chr(10) + " 	JBL.JBL_CODCUR, "
cQuery += Chr(10) + " 	JBL.JBL_PERLET, "
cQuery += Chr(10) + " 	JBL.JBL_ITEM "
cQuery += Chr(10) + "   "
cQuery += Chr(10) + " INSERT INTO JBLBKP "
cQuery += Chr(10) + " 	(JBL_FILIAL,JBL_CODCUR,JBL_PERLET,JBL_TURMA,JBL_ITEM,JBL_CODHOR,JBL_HORA1,JBL_HORA2, "
cQuery += Chr(10) + " 	 JBL_CODDIS,JBL_MATPRF,JBL_MATPR2,JBL_MATPR3,JBL_MATPR4,JBL_MATPR5,JBL_MATPR6,JBL_MATPR7, "
cQuery += Chr(10) + " 	 JBL_MATPR8,JBL_DIASEM,JBL_CODLOC,JBL_CODPRE,JBL_ANDAR,JBL_CODSAL,JBL_DATA1,JBL_DATA2, "
cQuery += Chr(10) + " 	 JBL_REMUNE,JBL_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JBL_SUBTUR,TIPO_OPER,JBL_DATA) "
cQuery += Chr(10) + " SELECT   DISTINCT "
cQuery += Chr(10) + " 	 JD2_FILIAL,JD2_CODCUR,JD2_PERLET,JD2_TURMA,JD2_ITEM,JD2_CODHOR,JD2_HORA1,JD2_HORA2, "
cQuery += Chr(10) + " 	 JD2_CODDIS,JD2_MATPRF,JD2_MATPR2,JD2_MATPR3,JD2_MATPR4,JD2_MATPR5,JD2_MATPR6,JD2_MATPR7, "
cQuery += Chr(10) + " 	 JD2_MATPR8,JD2_DIASEM,JD2_CODLOC,JD2_CODPRE,JD2_ANDAR,JD2_CODSAL,' ',' ', "
cQuery += Chr(10) + " 	 JD2_REMUNE,JD2_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JD2_SUBTUR,'JD2',JD2_DATA "
cQuery += Chr(10) + "     FROM "+retsqlname("JD2")+" JD2 "
cQuery += Chr(10) + "    WHERE JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += Chr(10) + "      AND JD2.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + "      AND JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_ITEM+JD2.JD2_CODLOC+JD2.JD2_CODPRE+ "
cQuery += Chr(10) + " 	 JD2.JD2_ANDAR+JD2.JD2_CODSAL+JD2.JD2_MATPRF NOT IN  "
cQuery += Chr(10) + " 	 ( SELECT DISTINCT "
cQuery += Chr(10) + " 		  JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL.JBL_CODLOC+JBL.JBL_CODPRE+ "
cQuery += Chr(10) + " 	 	  JBL.JBL_ANDAR+JBL.JBL_CODSAL+JBL.JBL_MATPRF  "
cQuery += Chr(10) + " 	     FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + "    	WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + "      	  AND JBL.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " ORDER BY "
cQuery += Chr(10) + " 	JD2.JD2_CODCUR, "
cQuery += Chr(10) + " 	JD2.JD2_PERLET, "
cQuery += Chr(10) + " 	JD2.JD2_ITEM "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " IF @@ERROR <> 0 "
cQuery += Chr(10) + "    ROLLBACK "
cQuery += Chr(10) + " ELSE "
cQuery += Chr(10) + "    COMMIT "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_cExluiJBL≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create  procedure sp_cExluiJBL "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " BEGIN TRANSACTION  "
cQuery += Chr(10) + " declare crDelJBL cursor "
cQuery += Chr(10) + "   local "
cQuery += Chr(10) + "       for " 
cQuery += Chr(10) + " 	SELECT   DISTINCT "
cQuery += Chr(10) + " 		 JBL_FILIAL,JBL_CODCUR,JBL_PERLET,JBL_TURMA,JBL_ITEM,JBL_CODHOR,JBL_HORA1,JBL_HORA2, "
cQuery += Chr(10) + " 		 JBL_CODDIS,JBL_MATPRF,JBL_MATPR2,JBL_MATPR3,JBL_MATPR4,JBL_MATPR5,JBL_MATPR6,JBL_MATPR7, "
cQuery += Chr(10) + " 		 JBL_MATPR8,JBL_DIASEM,JBL_CODLOC,JBL_CODPRE,JBL_ANDAR,JBL_CODSAL,JBL_DATA1,JBL_DATA2, "
cQuery += Chr(10) + " 		 JBL_REMUNE,JBL_HABILI,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JBL_SUBTUR "
cQuery += Chr(10) + " 	    FROM "+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + " 	   WHERE JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + " 	     AND JBL.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 	     AND JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL.JBL_CODLOC+JBL.JBL_CODPRE+ "
cQuery += Chr(10) + " 		 JBL.JBL_ANDAR+JBL.JBL_CODSAL+JBL.JBL_MATPRF NOT IN  "
cQuery += Chr(10) + " 		 ( SELECT DISTINCT "
cQuery += Chr(10) + " 			  JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DIASEM+JD2_ITEM+JD2.JD2_CODLOC+JD2.JD2_CODPRE+ "
cQuery += Chr(10) + " 		 	  JD2.JD2_ANDAR+JD2.JD2_CODSAL+JD2.JD2_MATPRF  "
cQuery += Chr(10) + " 		     FROM "+retsqlname("JD2")+" JD2 "
cQuery += Chr(10) + " 	   	    WHERE JD2.JD2_FILIAL = '"+xfilial("JD2")+"' "
cQuery += Chr(10) + " 	     	  AND JD2.D_E_L_E_T_ = ' ' ) "
cQuery += Chr(10) + " 	ORDER BY "
cQuery += Chr(10) + " 		JBL.JBL_CODCUR, "
cQuery += Chr(10) + " 		JBL.JBL_PERLET, "
cQuery += Chr(10) + " 		JBL.JBL_ITEM "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	declare @xFilial  char(2) "
cQuery += Chr(10) + " 	declare @cCodCur  char(6) "
cQuery += Chr(10) + " 	declare @cPerlet  char(2) "
cQuery += Chr(10) + " 	declare @cHabili  char(6) "
cQuery += Chr(10) + " 	declare @cTurma   char(3) "
cQuery += Chr(10) + " 	declare @cCodDis  char(15) "
cQuery += Chr(10) + " 	declare @cCodHor  char(15) "
cQuery += Chr(10) + " 	declare @cCodLoc  char(6) "
cQuery += Chr(10) + " 	declare @cCodPre  char(6) "
cQuery += Chr(10) + " 	declare @cAndar   char(6) "
cQuery += Chr(10) + " 	declare @cSala    char(6) "
cQuery += Chr(10) + " 	declare @cData1   char(8) "
cQuery += Chr(10) + " 	declare @cData2   char(8) "
cQuery += Chr(10) + " 	declare @cRemune  char(1) "
cQuery += Chr(10) + " 	declare @cDelete  char(1) "
cQuery += Chr(10) + " 	declare @cSubTur  char(6) "
cQuery += Chr(10) + " 	declare @nRecDel  int "
cQuery += Chr(10) + " 	declare @cMatprf  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr2  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr3  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr4  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr5  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr6  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr7  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr8  char(6) "
cQuery += Chr(10) + " 	declare @cDiasem  char(1) "
cQuery += Chr(10) + " 	declare @cHora1   char(8) "
cQuery += Chr(10) + " 	declare @cHora2   char(8) "
cQuery += Chr(10) + " 	declare @cItem    char(2) "
cQuery += Chr(10) + " 	declare @nRecno   int "
cQuery += Chr(10) + " 	declare @ncont    int	 "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	Open crDelJBL "
cQuery += Chr(10) + " 	fetch next from crDelJBL into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 		@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 		@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala  ,@cData1 ,@cData2 , "
cQuery += Chr(10) + " 		@cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	set @ncont = 1	 "
cQuery += Chr(10) + "    	while @@fetch_status = 0   "
cQuery += Chr(10) + "    	  begin	 "
cQuery += Chr(10) + " 	    	DELETE FROM "+retsqlname("JBL")+" WHERE R_E_C_N_O_ = @nRecno	   "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	    fetch next from crDelJBL into @xFilial,@cCodCur,@cPerlet,@cTurma,@cItem,@cCodHor,@cHora1,@cHora2, "
cQuery += Chr(10) + " 		@cCodDis,@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7, "
cQuery += Chr(10) + " 		@cMatpr8,@cDiasem,@cCodLoc,@cCodPre,@cAndar ,@cSala  ,@cData1 ,@cData2 , "
cQuery += Chr(10) + " 		@cRemune,@cHabili,@cDelete,@nRecno ,@nRecDel,@cSubTur "
cQuery += Chr(10) + "       end "
cQuery += Chr(10) + "  Close crDelJBL "
cQuery += Chr(10) + " Deallocate crDelJBL "    
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " IF @@ERROR <> 0 "
cQuery += Chr(10) + "    ROLLBACK "
cQuery += Chr(10) + " ELSE "
cQuery += Chr(10) + "    COMMIT "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Procedure sp_cInsDadosJC7≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := " create  procedure sp_cInsDadosJC7() "
cQuery += Chr(10) + " as "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " BEGIN TRANSACTION "
cQuery += Chr(10) + " declare crInsJC7 cursor "
cQuery += Chr(10) + "    local "
cQuery += Chr(10) + "       for "
cQuery += Chr(10) + " 	SELECT 	distinct "
cQuery += Chr(10) + " 		JBL.JBL_FILIAL, "
cQuery += Chr(10) + " 		JBL.JBL_CODCUR, "
cQuery += Chr(10) + " 	    JBL.JBL_PERLET, "
cQuery += Chr(10) + " 	    JBL.JBL_HABILI, "
cQuery += Chr(10) + " 	    JBL.JBL_TURMA, "
cQuery += Chr(10) + " 	    JBL.JBL_CODDIS, "
cQuery += Chr(10) + " 	    JBL.JBL_MATPRF, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR2, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR3, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR4, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR5, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR6, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR7, "
cQuery += Chr(10) + " 		JBL.JBL_MATPR8, "
cQuery += Chr(10) + " 	    JBL.JBL_DIASEM, " 
cQuery += Chr(10) + " 		JBL.JBL_CODHOR, "
cQuery += Chr(10) + " 	    JBL.JBL_HORA1, "
cQuery += Chr(10) + " 	    JBL.JBL_HORA2, "
cQuery += Chr(10) + " 	    JBL.JBL_CODLOC, "
cQuery += Chr(10) + " 	    JBL.JBL_CODPRE, "
cQuery += Chr(10) + " 	    JBL.JBL_ANDAR, "
cQuery += Chr(10) + " 	    JBL.JBL_CODSAL, "
cQuery += Chr(10) + " 		JBL.JBL_SUBTUR "
cQuery += Chr(10) + " 	  FROM 	"+retsqlname("JBL")+" JBL "
cQuery += Chr(10) + " 	 WHERE 	JBL.JBL_FILIAL = '"+xfilial("JBL")+"' "
cQuery += Chr(10) + " 	   AND 	JBL.D_E_L_E_T_ = ' '    "	      		   
cQuery += Chr(10) + " 	   AND 	JBL.JBL_CODDIS + JBL.JBL_CODLOC + JBL.JBL_CODPRE + JBL.JBL_DIASEM + "
cQuery += Chr(10) + " 	       	JBL.JBL_ANDAR + JBL.JBL_CODSAL + JBL.JBL_MATPRF + JBL.JBL_HORA1 NOT IN "
cQuery += Chr(10) + " 	       	(SELECT DISTINCT "
cQuery += Chr(10) + " 					JC7.JC7_DISCIP + JC7.JC7_CODLOC + JC7.JC7_CODPRE + "
cQuery += Chr(10) + " 	                JC7.JC7_DIASEM + JC7.JC7_ANDAR + JC7.JC7_CODSAL + "
cQuery += Chr(10) + " 	                JC7.JC7_CODPRF + JC7.JC7_HORA1 "
cQuery += Chr(10) + " 	          FROM "+retsqlname("JC7")+" JC7 "
cQuery += Chr(10) + " 	         WHERE JC7.JC7_FILIAL = '"+xfilial("JC7")+"' "
cQuery += Chr(10) + " 	           AND JC7.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 		   	   AND JC7.JC7_OUTCUR = ' ' "
cQuery += Chr(10) + " 	   	       AND JC7.JC7_SITDIS = '010' "
cQuery += Chr(10) + " 	   	       AND JC7.JC7_SITUAC = '1'  "
cQuery += Chr(10) + " 		       AND JC7.JC7_MEDFIM = 0 ) "
cQuery += Chr(10) + " 	ORDER BY "
cQuery += Chr(10) + " 		JBL.JBL_CODCUR, "
cQuery += Chr(10) + " 		JBL.JBL_PERLET, "
cQuery += Chr(10) + " 		JBL.JBL_HABILI, "
cQuery += Chr(10) + " 		JBL.JBL_TURMA, "
cQuery += Chr(10) + " 		JBL.JBL_CODDIS, "
cQuery += Chr(10) + " 		JBL.JBL_MATPRF "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 	declare @xFilial  char(2) "
cQuery += Chr(10) + " 	declare @cCodCur  char(6) "
cQuery += Chr(10) + " 	declare @cPerlet  char(2) "
cQuery += Chr(10) + " 	declare @cHabili  char(6) "
cQuery += Chr(10) + " 	declare @cTurma   char(3) "
cQuery += Chr(10) + " 	declare @cCodDis  char(15) "
cQuery += Chr(10) + " 	declare @cCodLoc  char(6) "
cQuery += Chr(10) + " 	declare @cCodPre  char(6) "
cQuery += Chr(10) + " 	declare @cAndar   char(6) "
cQuery += Chr(10) + " 	declare @cSala    char(6) "
cQuery += Chr(10) + " 	declare @cMatprf  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr2  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr3  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr4  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr5  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr6  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr7  char(6) "
cQuery += Chr(10) + " 	declare @cMatpr8  char(6) "
cQuery += Chr(10) + " 	declare @cDiasem  char(1) "
cQuery += Chr(10) + " 	declare @cHora1   char(8) "
cQuery += Chr(10) + " 	declare @cHora2   char(8) "
cQuery += Chr(10) + " 	declare @cSubTur  char(6) "
cQuery += Chr(10) + " 	declare @ncont    int "
cQuery += Chr(10) + " 	declare @cVigente char(6) "
cQuery += Chr(10) + " 	declare @cCodHor  char(6) "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 	Open crInsJC7 "
cQuery += Chr(10) + " 	fetch next from crInsJC7 into @xFilial,@cCodCur,@cPerlet,@cHabili,@cTurma,@cCodDis, "
cQuery += Chr(10) + " 		@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7,@cMatpr8, "
cQuery += Chr(10) + " 		@cDiasem,@cCodHor,@cHora1,@cHora2,@cCodLoc,@cCodPre,@cAndar,@cSala, "
cQuery += Chr(10) + " 		@cSubTur "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + "   set @cVigente   = '      ' "
cQuery += Chr(10) + " 	set @ncont 	= 1 "
cQuery += Chr(10) + " 	while @@fetch_status = 0 "
cQuery += Chr(10) + " 	   begin "
cQuery += Chr(10) + " 		declare crConsJBE cursor "
cQuery += Chr(10) + "    		    local "
cQuery += Chr(10) + "       			for "
cQuery += Chr(10) + " 			  SELECT DISTINCT "
cQuery += Chr(10) + " 				 JBE.JBE_NUMRA, "
cQuery += Chr(10) + " 				 JBE.JBE_CODCUR, "
cQuery += Chr(10) + " 				 JBE.JBE_PERLET, "
cQuery += Chr(10) + " 				 JBE.JBE_HABILI, "
cQuery += Chr(10) + " 				 JBE.JBE_TURMA "
cQuery += Chr(10) + " 			    FROM "+retsqlname("JBE")+" JBE "
cQuery += Chr(10) + " 			   WHERE JBE.JBE_FILIAL = @xFilial "
cQuery += Chr(10) + " 			     AND JBE.D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 			     AND JBE.JBE_CODCUR = @cCodCur "
cQuery += Chr(10) + " 			     AND JBE.JBE_PERLET = @cPerlet "
cQuery += Chr(10) + " 			     AND JBE.JBE_HABILI = @cHabili "
cQuery += Chr(10) + " 			     AND JBE.JBE_TURMA  = @cTurma "
cQuery += Chr(10) + " 			     AND JBE.JBE_ATIVO  in ('1') "
cQuery += Chr(10) + " 			     AND JBE.JBE_SITUAC in ('2') "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 			  declare @cnRajbe  char(15) "
cQuery += Chr(10) + " 			  declare @cCurjbe  char(6) "
cQuery += Chr(10) + " 			  declare @cPerjbe  char(3) "
cQuery += Chr(10) + " 			  declare @cHabjbe  char(6) "
cQuery += Chr(10) + " 			  declare @cTurjbe  char(3)	"	
cQuery += Chr(10) + " 			  declare @cSeq     char(3) "
cQuery += Chr(10) + " 			  declare @nTotjc7  int "
cQuery += Chr(10) + " 			  declare @nRecnoMx int	 "	
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 			  Open crConsJBE "
cQuery += Chr(10) + " 			  fetch next from crConsJBE into @cnRajbe,@cCurjbe,@cPerjbe,@cHabjbe,@cTurjbe "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 			  while @@fetch_status = 0 "
cQuery += Chr(10) + " 		            begin "					  				    
cQuery += Chr(10) + " 				if @cVigente <> @cCurjbe+@cPerjbe+@cHabjbe+@cTurjbe "
cQuery += Chr(10) + " 				  begin "
cQuery += Chr(10) + " 					SELECT "
cQuery += Chr(10) + " 						  @nTotjc7 = COUNT(*)  "
cQuery += Chr(10) + " 					 FROM "+retsqlname("JC7")+" JC7  "
cQuery += Chr(10) + " 					WHERE JC7.JC7_FILIAL='"+xfilial("JC7")+"'  "
cQuery += Chr(10) + " 					  AND JC7.D_E_L_E_T_=' '  "
cQuery += Chr(10) + " 					  AND JC7_FILIAL = @xFilial "
cQuery += Chr(10) + " 					  AND JC7_NUMRA  = @cnRajbe "
cQuery += Chr(10) + " 					  AND JC7_CODCUR = @cCurjbe "
cQuery += Chr(10) + " 					  AND JC7_PERLET = @cPerjbe "
cQuery += Chr(10) + " 					  AND JC7_HABILI = @cHabjbe "
cQuery += Chr(10) + " 					  AND JC7_TURMA  = @cTurjbe "
cQuery += Chr(10) + " 					  AND JC7_DISCIP = @cCodDis "
cQuery += Chr(10) + " 					  AND JC7_CODLOC = @cCodLoc "
cQuery += Chr(10) + " 					  AND JC7_CODPRE = @cCodPre "
cQuery += Chr(10) + " 					  AND JC7_ANDAR  = @cAndar "
cQuery += Chr(10) + " 					  AND JC7_CODSAL = @cSala "
cQuery += Chr(10) + " 					  AND JC7_DIASEM = @cDiasem "
cQuery += Chr(10) + " 					  AND JC7_HORA1  = @cHora1 "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 					  if @nTotjc7 = 0  "
cQuery += Chr(10) + " 					    begin  "
cQuery += Chr(10) + " 						SELECT @nRecnoMx = MAX(R_E_C_N_O_)+1 FROM "+retsqlname("JC7")+" "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 						INSERT INTO "+retsqlname("JC7")+" "
cQuery += Chr(10) + " 							(JC7_FILIAL,JC7_NUMRA,JC7_CODCUR,JC7_PERLET,JC7_TURMA,JC7_HABILI,JC7_DISCIP, "
cQuery += Chr(10) + " 							 JC7_CODLOC,JC7_CODPRE,JC7_ANDAR,JC7_CODSAL,JC7_AMG,JC7_SITDIS,JC7_SITUAC, "
cQuery += Chr(10) + " 							 JC7_DIASEM,JC7_CODHOR,JC7_HORA1,JC7_HORA2,JC7_CODPRF,JC7_CODPR2,JC7_CODPR3,JC7_CODPR4, "
cQuery += Chr(10) + " 							 JC7_CODPR5,JC7_CODPR6,JC7_CODPR7,JC7_CODPR8,JC7_NUMPRO,JC7_OUTCUR,JC7_OUTPER, "
cQuery += Chr(10) + " 							 JC7_OUTTUR,JC7_OUTHAB,JC7_MEDFIM,JC7_DISDP,JC7_SITDP,JC7_BOLETO,JC7_DPBAIX, "
cQuery += Chr(10) + " 							 JC7_CURDP,JC7_PERDP,JC7_TURDP,JC7_CURORI,JC7_HABDP,JC7_PERORI,JC7_TURORI, "
cQuery += Chr(10) + " 							 JC7_DISORI,JC7_SITORI,JC7_HABORI,JC7_MEDCON,JC7_CODINS,JC7_ANOINS,JC7_MEDANT, "
cQuery += Chr(10) + " 							 JC7_DESMCO,JC7_TIPCUR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,JC7_SUBTUR) "
cQuery += Chr(10) + " 						      VALUES "
cQuery += Chr(10) + " 							(@xFilial,@cnRajbe,@cCodCur,@cPerlet,@cTurma,@cHabili,@cCodDis, "
cQuery += Chr(10) + " 							 @cCodLoc,@cCodPre,@cAndar,@cSala,0,'010','1', "
cQuery += Chr(10) + " 							 @cDiasem,@cCodHor,@cHora1,@cHora2,@cMatprf,@cMatpr2, "
cQuery += Chr(10) + " 							 @cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7,@cMatpr8,' ', "
cQuery += Chr(10) + " 							 ' ',' ',' ',' ',0,' ',' ',' ',' ', "
cQuery += Chr(10) + " 							 ' ',' ',' ',' ',' ',' ',' ', "
cQuery += Chr(10) + " 							 ' ',' ',' ',' ',' ',' ',0, "
cQuery += Chr(10) + " 							 ' ',' ',' ',@nRecnoMx,0,@cSubTur) "
cQuery += Chr(10) + " 					     end "
cQuery += Chr(10) + " 					  else "
cQuery += Chr(10) + " 					     begin "
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 						UPDATE 	"+retsqlname("JC7")+"  "
cQuery += Chr(10) + " 						   SET 	JC7_CODLOC = @cCodLoc, "
cQuery += Chr(10) + " 							JC7_CODPRE = @cCodPre, "
cQuery += Chr(10) + " 							JC7_ANDAR  = @cAndar, "
cQuery += Chr(10) + " 							JC7_CODSAL = @cSala, "
cQuery += Chr(10) + " 							JC7_DIASEM = @cDiasem, "
cQuery += Chr(10) + " 							JC7_CODHOR = @cCodHor, "
cQuery += Chr(10) + " 							JC7_HORA1  = @cHora1, "
cQuery += Chr(10) + " 							JC7_HORA2  = @cHora2, "
cQuery += Chr(10) + " 							JC7_CODPRF = @cMatprf, "
cQuery += Chr(10) + " 							JC7_CODPR2 = @cMatpr2, "
cQuery += Chr(10) + " 							JC7_CODPR3 = @cMatpr3, "
cQuery += Chr(10) + " 							JC7_CODPR4 = @cMatpr4, "
cQuery += Chr(10) + " 							JC7_CODPR5 = @cMatpr5, "
cQuery += Chr(10) + " 							JC7_CODPR6 = @cMatpr6, "
cQuery += Chr(10) + " 							JC7_CODPR7 = @cMatpr7, "
cQuery += Chr(10) + " 							JC7_CODPR8 = @cMatpr8 "
cQuery += Chr(10) + " 						  WHERE JC7_FILIAL = @xFilial "
cQuery += Chr(10) + " 	                        AND D_E_L_E_T_ = ' ' "
cQuery += Chr(10) + " 	                        AND JC7_NUMRA  = @cnRajbe "
cQuery += Chr(10) + " 	                        AND JC7_CODCUR = @cCodCur "
cQuery += Chr(10) + " 	                        AND JC7_PERLET = @cPerlet "
cQuery += Chr(10) + " 	                        AND JC7_HABILI = @cHabili "
cQuery += Chr(10) + " 	                        AND JC7_TURMA  = @cTurma "
cQuery += Chr(10) + " 	                        AND JC7_DISCIP = @cCodDis "
cQuery += Chr(10) + " 						    AND JC7_CODLOC = @cCodLoc "
cQuery += Chr(10) + " 						    AND JC7_CODPRE = @cCodPre "
cQuery += Chr(10) + " 						    AND JC7_ANDAR  = @cAndar "
cQuery += Chr(10) + " 	                        AND JC7_CODSAL = @cSala "
cQuery += Chr(10) + " 	                        AND JC7_DIASEM = @cDiasem "
cQuery += Chr(10) + " 	                        AND JC7_HORA1  = @cHora1 "
cQuery += Chr(10) + " 					     end "
cQuery += Chr(10) + " 					set @cVigente = @cCodCur+@cPerlet+@cHabili+@cTurma "
cQuery += Chr(10) + " 				     end "
cQuery += Chr(10) + " 				fetch next from crConsJBE into @cnRajbe,@cCurjbe,@cPerjbe,@cHabjbe,@cTurjbe "
cQuery += Chr(10) + " 			    end	 "
cQuery += Chr(10) + " 		 Close crConsJBE "
cQuery += Chr(10) + " 		Deallocate crConsJBE " 
cQuery += Chr(10) + " "
cQuery += Chr(10) + " 		set @ncont = @ncont+1 "                 		 	 
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " 		fetch next from crInsJC7 into @xFilial,@cCodCur,@cPerlet,@cHabili,@cTurma,@cCodDis, "
cQuery += Chr(10) + " 			@cMatprf,@cMatpr2,@cMatpr3,@cMatpr4,@cMatpr5,@cMatpr6,@cMatpr7,@cMatpr8, "
cQuery += Chr(10) + " 			@cDiasem,@cCodHor,@cHora1,@cHora2,@cCodLoc,@cCodPre,@cAndar,@cSala, "
cQuery += Chr(10) + " 			@cSubTur "
cQuery += Chr(10) + " 	   end "
cQuery += Chr(10) + " Close crInsJC7 "
cQuery += Chr(10) + " Deallocate crInsJC7 "
cQuery += Chr(10) + "  "
cQuery += Chr(10) + " IF @@ERROR <> 0 "
cQuery += Chr(10) + "   ROLLBACK "
cQuery += Chr(10) + " ELSE "
cQuery += Chr(10) + "   COMMIT "
TcSqlExec( cQuery )
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ExecuÁ„o de Procedures no Banco de Dados≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
U_AFixExePro()

return  


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AFixExePro∫Autor  ≥Denis D. Almeida    ∫ Data ≥  16/01/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Efetua ExecuÁ„o das Procedures apÛs criaÁ„o das mesmas      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Gestao Educacional                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function AFixExePro() 

local cQuery := ""
/*	     |
/ Procedure: |	sp_cCreateBKPJBLJD2
/ Autor:     | 	Denis Dias de Almeida
/ Data:      |  15/01/2008
/ Objetivo:  |  Inclus„o para backup de registros relacionados a tabela JBL e JD2 que encontram-se incoerentes                                                                                            
/            |  deixando os registros JBL e JD2 salvos para posterior comparaÁ„o antes de rodar o Fix de Base 
/            |  de Dados 
*/ 
cQuery := "exec sp_cCreateBKPJBLJD2"
TcSqlExec( cQuery )
conout(TcSqlError())
/*
/ CompatibilizaÁ„o de itens na tabela jd2 para posteriormente criar corretamente 
/ o relacionamento e dados da tabela jbl gerando assim efetivamente uma chave
/ unica
*/
cQuery := "exec sp_AcertItemJD2"
TcSqlExec( cQuery ) 
conout(TcSqlError())
/*	     |
/ Procedure: |	sp_cExluiJBL
/ Autor:     | 	Denis Dias de Almeida
/ Data:      |  15/01/2008
/ Objetivo:  |  DeleÁ„o de resgistros que existam na JBL mas n„o existam na JD2
/            |  
*/
cQuery := "exec sp_cExluiJBL"
TcSqlExec( cQuery ) 
conout(TcSqlError())   
/*	     |
/ Procedure: |	sp_cCompatibJD2JBL
/ Autor:     | 	Denis Dias de Almeida
/ Data:      |  15/01/2008
/ Objetivo:  |  Insere dados conforme jd2 na jbl compatibilizando e mantendo a integridade referencial
/            |  entre as tabelas
*/
cQuery := "exec sp_cCompatibJD2JBL"
TcSqlExec( cQuery ) 
conout(TcSqlError())
/*	     |
/ Procedure: |	sp_cBKPjc7DEL
/ Autor:     | 	Denis Dias de Almeida
/ Data:      |  15/01/2008
/ Objetivo:  |  Backup e DeleÁ„o de resgistros que existam na JC7 porÈm n„o estejam na JBL
/            |  apÛs compatibilizaÁ„o
*/
cQuery := "exec sp_cBKPjc7DEL"
TcSqlExec( cQuery ) 
conout(TcSqlError())
/*	     |
/ Procedure: |	sp_cInsDadosJC7
/ Autor:     | 	Denis Dias de Almeida
/ Data:      |  15/01/2008
/ Objetivo:  |  AtualizaÁ„o de dados referentes a tabela JC7 
/            |  (Inclus„o de itens que existem na jbl e n„o na jc7)
*/
cQuery := "exec sp_cInsDadosJC7"
TcSqlExec( cQuery ) 
conout(TcSqlError())
                               
//Deleta registros incompatÌveis com novo esquema de tamanho do campo jbl_item
cQuery := "delete from "+retsqlname("JBL")+" WHERE len(JBL_ITEM) = 2 "
TcSqlExec( cQuery ) 
TcSqlExec( "commit" ) 
conout(TcSqlError()) 

SX3->( dbSetOrder(2) )
if SX3->(dbSeek("JBL_ITEM  ")) .AND. SX3->X3_TAMANHO  !=  3
    Reclock( "SX3", .F.)
    SX3->X3_TAMANHO   := 3
    SX3->( MsUnlock() )
endif                       
if SX3->(dbSeek("JD2_ITEM  ")) .AND. SX3->X3_TAMANHO  !=  3
    Reclock( "SX3", .F.)
    SX3->X3_TAMANHO   := 3
    SX3->( MsUnlock() )
endif 

return .t.

 
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FixGrDiari∫Autor  ≥Denis D. Almeida    ∫ Data ≥  17/01/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Efetua o processamento da Procedure                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Gestao Educacional                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function FixGrDiari()
FixWindow( 11111, {|| U_AFixGrProc() } )
Return     