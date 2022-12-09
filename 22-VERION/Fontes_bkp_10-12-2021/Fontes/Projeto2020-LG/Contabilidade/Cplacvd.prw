#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function Cplacvd

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+
Local _aArea := GetArea()

cquery := ""
cquery += " SELECT CT1_CONTA "
cquery += " FROM CT1020 CT1 "
cquery += " WHERE SUBSTRING(CT1_CONTA,1,6) = '112001' AND CT1.D_E_L_E_T_ = '' AND CT1_CLASSE <> '1'"

TCQUERY CQUERY NEW ALIAS "MOW"

Dbselectarea("MOW")
dbgotop()
While !eof()

    DBSELECTAREA("CVD")
	RecLock("CVD",.t.)
     CVD->CVD_FILIAL  := ''
     CVD->CVD_CONTA   := MOW->CT1_CONTA
     CVD->CVD_ENTREF  := "10"
     CVD->CVD_CODPLA  := "2016"
     CVD->CVD_CTAREF  := "1.01.02.02.01"                  
     CVD->CVD_TPUTIL  := "A"
     CVD->CVD_CLASSE  := "2"
     CVD->CVD_NATCTA  := "01"
     CVD->CVD_CTASUP  := "1.01.02.02"
	MsUnLock("CVD")


	DbSelectArea("MOW")
	Dbskip()
	LOOP

End
                
ALERT ("TERMINO DE PROCESSAMENTO !!!")

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+
MOW->(DBCLOSEAREA())

Return(.t.)