#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Fernando Macieira   º Data ³ 16/Mar/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para controlar TES de Saida, pelo B1_IPI. º±±
±±º          ³ No início das validações após a confirmação da inclusão ou º±±
±±º          ³ alteração, antes da gravação do Produto                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A010TOK()
Local lRet, cTS, nIPI, aArea

lRet  := .t.
nIpi  := M->B1_IPI
cTS   := GetMv("MV_XVTS")
aArea := GetArea()                                                                         


dbSelectArea("SF4")
SF4->(dbSetOrder(1))
If !SF4->(msSeek(xFilial("SF4")+cTS))
	lRet := .f.
	msgStop("TES de Saída, informado no parâmetro MV_XVTS, não existente no cadastro de TES.","Atenção")
Else
	Iif(nIpi=0,M->B1_TS:=cTS,)
EndIf
// TRATAMENTO DAS ALTERACOES NAS ESTRUTURAS 
// DEIXANDO OS PRODUTOS DESBLOQUEADO NO SG1
// SOMENTE NA ALTERACAO ....                                          
/*
If M->B1_MSBLQL == "2" .and. altera

	Dbselectarea("SG1") 
	DBSETORDER(2)
	DBGOTOP()
	IF DBSEEK("01" + M->B1_COD)
	WHILE !EOF() .AND. M->B1_COD == SG1->G1_COMP

	      // CADASTRO DE ESTRUTURA      

	      DBSELECTAREA("SG1")
	      RECLOCK("SG1",.F.)
	       SG1->G1_INI := CTOD("21/04/2007")
	       SG1->G1_FIM := CTOD("01/12/2049")
	      MSUNLOCK("SG1")    

	
		Dbselectarea("SG1")         
    	dbskip()       
    	LOOP
	END
    ENDIF
Endif
*/

RestArea(aArea)   
Return lRet