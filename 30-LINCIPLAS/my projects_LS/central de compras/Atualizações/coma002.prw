#INCLUDE "rwmake.ch"
#include "topconn.ch"   
#Include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMA003  º Autor ³ Ricardo Felipelli  º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para alterar o fornecedor de um determinado pedido  º±±
±±º          ³ de compras, enquanto o mesmo estiver aberto                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMA003()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca 	:= 0
Local aSays 	:= {}
Local aButtons  := {}

Private cPerg   := padr("COM003",len(SX1->X1_GRUPO),' ')
cVldAlt := ".T." 
cVldExc := ".T." 

Private cString := "SC7"

dbSelectArea("SC7")
dbSetOrder(1)
                         
_pergunt()

If !Pergunte(cPerg,.T.)
	Return
Endif             
                
                                                           
DBSELECTAREA("SC7")
DBSETORDER(1)
SC7->(DBSEEK(MV_PAR01+MV_PAR02))     
          
Private cCadastro	:= "Ajusta datas de Encalhe"

AADD(aSays,OemToAnsi( "Codigo : " + mv_par01 ) ) 
AADD(aSays,OemToAnsi( "Produto: " + SB1->B1_DESC ) )
AADD(aSays,OemToAnsi( "Data de Encalhe: " + dtoc(mv_par02) ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
EndIf

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return Nil



Static Function RunProc(lEnd)
         
	_filatu := ""
   	_virg   := 0
	dbselectarea("SX1")
	dbsetorder(01)
	SX1->(Dbseek(cPerg))
	while SX1->(!eof()) .and. SX1->X1_GRUPO == CPERG
	     if alltrim(SX1->X1_DEF01) == "ALTERA" .and. SX1->X1_PRESEL == 1
	     	_filatu += "'" + subst(SX1->X1_PERGUNT,1,2) + "'" 
	     	_virg:=1
	     endif                                            
	     SX1->(dbskip())
	     if SX1->X1_GRUPO == CPERG .and. _virg == 1
	     	_filatu += ","
	          _virg:=0
	     endif
	     
	enddo                                                   
	cQuery    := " UPDATE " + RetSqlName('SZ7')    
	cQuery    += " SET Z7_ENCALHE = '" + DTOS(MV_PAR02) + "'"
	cQuery    += "  WHERE "
	cQuery    += " Z7_COD = '" + MV_PAR01 + "'"       
	cQuery    += " AND Z7_FILIAL IN (" + _filatu + ")"
	
	TcSQLExec(cquery) 


	MsgInfo("Atualizacao Processada com Sucesso !!")

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
SX1->X1_PERGUNT := "Filial            ?"
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
SX1->X1_PERGUNT := "Pedido de Compras      ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 06
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)  
MsUnLock()
dbCommit()
_Ordem++                       
_param := Soma1(_param)

Return(nil)