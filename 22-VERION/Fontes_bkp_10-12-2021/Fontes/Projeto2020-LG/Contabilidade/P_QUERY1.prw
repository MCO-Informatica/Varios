#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH" 
#Include "PROTHEUS.CH"
/*/
_________________________________________________________________________
Processamento de Query
Rodrigo Kavabata e Leandro Duran
ADVTEC SoluçõesIntegradas
_________________________________________________________________________
/*/

User Function P_QUERY1()
Local Botao1
Local Botao2
Private cParam1 := date(10)
Private cParam2 := date(10)
Private cParam3 := SPACE(20)
Private Panel1
Private Exec    := .F.
Public odlg_PQUERY1                                                                

DEFINE MSDIALOG odlg_PQUERY1 TITLE "Limpeza CT2" FROM 000, 000  TO 200, 300 PIXEL

@ 001, 001 MSPANEL Panel1        SIZE 300, 200 OF odlg_PQUERY1 RAISED
@ 022, 005 SAY "Data de     :"   SIZE 030, 009 OF Panel1 PIXEL
@ 042, 005 SAY "Data até    :"   SIZE 030, 009 OF Panel1 PIXEL
@ 062, 005 SAY "Lote        :"   SIZE 030, 009 OF Panel1 PIXEL
@ 020, 055 MSGET cParam1    WHEN .T. PICTURE "@!" SIZE 048, 010 PIXEL OF Panel1
@ 042, 055 MSGET cParam2    WHEN .T. PICTURE "@!" SIZE 048, 010 PIXEL OF Panel1
@ 062, 055 MSGET cParam3    WHEN .T. PICTURE "@!" SIZE 048, 010 PIXEL OF Panel1

@ 087, 050 BMPBUTTON TYPE 1 ACTION RODA_Q1(cParam1,cParam2,cParam3)
@ 087, 080 BMPBUTTON TYPE 2 ACTION Close(odlg_PQUERY1)

ACTIVATE MSDIALOG odlg_PQUERY1 CENTERED

Return

//=============================================================================================
//  Função Roda Query1
//=============================================================================================

STATIC FUNCTION RODA_Q1(cParam1,cParam2,cParam3)

LOCAL cQuery   := ""

cQuery := "DELETE FROM "+RetSqlName("CT2")+" " // Esse RetSqlName serve para identificar a empresa automaticamente 010 ou 020
cQuery += " WHERE CT2_DATA between '"+dtos(cParam1)+"' "
cQuery += "                    and '"+dtos(cParam2)+"' "
cQuery += "   AND CT2_LOTE IN ("+(cParam3)+")"
TCSQLEXEC(cQuery)

//DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRA', .F., .T.)
//TRA->(DBCLOSEAREA())

Alert("Processo concluido!")

Close(odlg_PQUERY1)
odlg_PQUERY1:End()
RETURN()

