#include "rwmake.ch" 
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT100GE2 ¦Autor ¦Rodrigo Demetrios Correa¦ Data ¦ 23/12/04 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada executado apos a gravacao do SE2 na NF    ¦¦¦
¦¦¦          ¦ Utilizado para a Gravacao do usuario no E2 pelo Estoque    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function MT100GE2()
Local cArquivo
Local nHdlPrv
_aArea := GetArea()
DbSelectArea("SE2")

//
// Apresenta o Numero da AP e Pede a digitação da Observação da AP
//
_cNumAP := SE2->E2_PREFIXO + " " + SE2->E2_NUM
_cHist  := Space(25)  
_cNatureza := SE2->E2_NATUREZ

dbselectarea("SED")
dbsetorder(1)
dbseek(xFilial()+_cNatureza)
_cHist  := Space(25)  
_cGrupo := SED->ED_GRUPO
_cDescGrupo := SED->ED_DESCGRU
_cDescNat   := SED->ED_DESCRIC

DbSelectArea("SE2")

//_cObs   := Space(100)        
@ 135,20 To 665,495 Dialog dlg_rec Title OemToAnsi("Historico do Titulo")
@ 06,10 Say OemToAnsi("Titulo")	    						Size 48,10
@ 06,46 Get _cNumAP     							   	  	Size 64,10  When .F.
@ 17,10 Say OemToAnsi("Historico")	         	    		Size 48,10
@ 17,46 Get _cHist            								Size 120,10  
@ 28,10 Say OemToAnsi("Natureza")	         	    		Size 48,10
@ 28,46 Get _cNatureza       								Size 64,10  When .F.
@ 39,10 Say OemToAnsi("Descr. Natureza")     	    		Size 48,10
@ 39,46 Get _cDescNat        								Size 120,10 When .F. 
@ 50,10 Say OemToAnsi("Grupo")  	         	    		Size 48,10
@ 50,46 Get _cGrupo             							Size 64,10  When .F.
@ 61,10 Say OemToAnsi("Descr. Grupo")        	    		Size 48,10
@ 61,46 Get _cDescGrupo        								Size 120,10 When .F. 
@ 81,170 BmpButton Type 1 Action GravaSE2()
Activate Dialog dlg_rec Centered


/*/
_____________________________________________________________________________
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ GravaSE2 ¦ Autor ¦ Denilson Correa       ¦ Data ¦ 23/12/04 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦      ¦¦¦
¦¦¦          ¦     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function GravaSE2()
	RecLock("SE2",.F.)
    SE2->E2_HIST      := _cHist
    SE2->E2_GRUPO     := _cGrupo
    SE2->E2_DESCGRU   := _cDescGrupo
    MsUnLock()
	Close(dlg_rec)
Return



/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ _Cancela ¦ Autor ¦ Denilson Correa       ¦ Data ¦ 23/12/04 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦      ¦¦¦
¦¦¦          ¦     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function _Cancela()
	RestArea(_aArea)
	Close(dlg_rec)
Return

