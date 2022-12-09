#INCLUDE "rwmake.ch"
#include "topconn.ch"
#Include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATA001  º Autor ³ Ricardo Felipelli  º Data ³  31/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ DELECAO AUTOMATICA DE ROMANEIO                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA001

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}

Private cPerg   := Padr("FATA01",len(SX1->X1_GRUPO)," ")
cVldAlt := ".T."
cVldExc := ".T."

Private cString := "PA6"

dbSelectArea("PA6")
dbSetOrder(1)
dbSelectArea("PA7")
dbSetOrder(1)

_pergunt()

If !Pergunte(cPerg,.T.)
	Return
Endif

DBSELECTAREA("SB1")
DBSETORDER(1)
SB1->(DBSEEK("  "+MV_PAR01))

Private cCadastro	:= "Exclusao Manual de Romaneio Errado."

AADD(aSays,OemToAnsi( "Filial : "  + mv_par01 ) )
AADD(aSays,OemToAnsi( "Romaneio: " + mv_par02 ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpca <> 1
	Return NIL
EndIf
	
Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
	
Return Nil
	
	
	
Static Function RunProc(lEnd)
	
_userotina := left(cUserName,10)
	
if alltrim(left(cUserName,10)) <> 'ebernardo'

	MsgInfo("* * ** *** USUARIO SEM PERMICAO *** ** *")  
	
else
	cQuery    := " UPDATE " + RetSqlName('PA6') 
	cQuery    += " SET D_E_L_E_T_ = '*'"
	cQuery    += " WHERE "
	cQuery    += " PA6_FILORI = '" + MV_PAR01 + "'"
	cQuery    += " AND PA6_NUMROM = '" + MV_PAR02 + "'"
	
	TcSQLExec(cquery)
	
	
	cQuery    := " UPDATE " + RetSqlName('PA7') 
	cQuery    += " SET D_E_L_E_T_ = '*'"
	cQuery    += " WHERE "
	cQuery    += " PA7_NUMROM = '" + MV_PAR02 + "'"
	
	TcSQLExec(cquery)
	
	
	MsgInfo("Romaneio Excluido com Sucesso !!")
endif

return(nil)
	
	
	
	
*****
Static function _pergunt()
**************************

_Ordem := 1
_param := '1'

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Qual a Filial      ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 2
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SM0"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Qual o Romaneio    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 8
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "PA6"
MsUnLock()
dbCommit()

	
Return(nil)
