#include "rwmake.ch"     
#Include 'Protheus.ch'                                             
#INCLUDE "MSOLE.CH"        
#INCLUDE "TOPCONN.CH"
                           
#define IT_ALIQICM	1
#define IT_VALICM	2
#define IT_BASEICM	3
#define IT_VALIPI	4
#define IT_BASEICM	5
#define IT_VALMERC	6
#define IT_DESCONTO	7
#define IT_PRCUNI	8
#define IT_VALSOL  	9
#define NF_DESCZF	10

// PROGRAMA SCHEDULE PARA IMPRESSAO DO ORCMENTO WORD
// NO SERVIDOR. ESTE PROGRAMA ESTA EM AMBIENTE PROPRIO (SLV4) - VERION_74
// E USUARIO PROPRIO (ADILSON - AR5555)
USER FUNCTION ORCCALLJ()
Local CQUERY
Local cCONT 
Local clog 

Private oDlg, oSay1, oLbx
Private oPanel1, oPanel2

DEFINE MSDIALOG oDlg TITLE "Processa" From 000,0 TO 100,300 OF oMainWnd PIXEL
oDlg:lMaximized := .T. 

@ 000, 000 MSPANEL oPanel1 SIZE 10, 50 OF oDlg 
oPanel1:align:= CONTROL_ALIGN_TOP

@ 05, 05 SAY oSay1 VAR "O botão Inicia começa o monitoriamento para imprimir word" OF oPanel1 PIXEL  
@ 15, 05 SAY oSay1 VAR "Processando ...." OF oPanel1 PIXEL                                                                       
@ 25, 40  BUTTON "Inicia" PIXEL SIZE 40,12 OF oPanel1 ACTION u_Imprim()
@ 25, 100 BUTTON "Fechar" PIXEL SIZE 40,12 OF oPanel1 ACTION oDlg:End()

@ 000, 000 MSPANEL oPanel2 SIZE 10, 90 OF oDlg 
oPanel2:align:= CONTROL_ALIGN_ALLCLIENT
	
ACTIVATE MSDIALOG oDlg CENTERED
Return                                                                        

// BOTAO DE INICIA...
user function imprim()

local clog := ''
cCont      := ''

While cCont # 'X'

	cCONT := INKEY(20)
                 
	CQUERY	:=	"SELECT * FROM "+RetSqlName("SZS")+" AS ZS "
	CQUERY	+=	"	WHERE ZS_IMP = 'F' "
			
	MEMOWRIT("RFAT02.SQL", CQUERY)
	TCQUERY CQUERY NEW ALIAS "JOB"
	Dbselectarea("JOB")         

	WHILE .NOT. EOF()
	
	    @ 15, 05 SAY oSay1 VAR "Processando ....     imprimindo " + JOB->ZS_ATEND OF oPanel1 PIXEL 
        
        // CHAMA A FUNCAO DE IMPRESSAO             
		U_ORCCALLS(alltrim(JOB->ZS_ATEND),@clog,alltrim(JOB->ZS_LOG),alltrim(str(JOB->R_E_C_N_O_)))

		cquery := "UPDATE "+RetSqlName("SZS")+" SET ZS_IMP = 'T', ZS_LOG = '"+ cLOG +"' " // alltrim(JOB->ZS_LOG) 
		cquery += " WHERE R_E_C_N_O_ = '" + alltrim(str(JOB->R_E_C_N_O_)) + "'"
		TCSQLEXEC(cQuery)
	
		Dbselectarea("JOB")         
    	dbskip()
	END
     
	job->(dbCloseArea())
END
return	


// FUNCAO PARA GRAVACAO DE CAMPOS ESPECIFICOS 
// DA IMPRESSAO NO SERVIDOR. TEM COMO OBJETIVO
// MARCAR O REGISTRO COMO IMPRESSO.    
// TABELA ESPECIFICA DO CLIENTE - SZS. 
user function ORCCALLN(cNum,cAer)
	Dbselectarea("SZS")
	Reclock("SZS",.t.)
	    replace SZS->ZS_IMP   with .F.
	    replace SZS->ZS_ATEND with cNUM
	    replace SZS->ZS_LOG	  with Alltrim(cAer)
	SZS->(msunlock())         
return(.T.)	
