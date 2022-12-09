	#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE "Tbiconn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rela1       ºAutor  ³ Mateus Hengle      ºData  ³ 26/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescric.  ³Relat. que raz os produtos que estão divergentes na B2 e B8 º±±
±±º          ³TOTVS TRIAH    											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Rela1()                                                       
	
Local cDesc1       	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Divergencias entre saldo fisico e saldo por lote"
Local cPict        	:= ""
Local titulo       	:= "Divergencias de saldos físicos e saldos por lote"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""                                                                                                                                                            
Local imprime      	:= .T.
Local aOrd          := {}
Private nCont       := 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "P"
Private nomeprog    := "RELA1" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RELA1" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg       := "DIVER"
Private cString     := "SB2"
Private nQatu 		:=0
Private nTotal 		:=0
Private nDifer 		:=0
Private cProd  		:=""

Private a_Pos       := {}  

dbSelectArea("SB2")
dbSetOrder(1)                 

Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³         
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return    

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

dbSelectArea(cString)
dbSetOrder(1)

SetRegua(RecCount())   

cQry:= " SELECT B2_FILIAL, B2_QATU, B8_PRODUTO, B8_LOCAL, SUM(B8_SALDO) AS TOTAL"
cQry+= " FROM "+RETSQLNAME("SB8")+" SB8" 
cQry+= " INNER JOIN "+RETSQLNAME("SB2")+" SB2"
cQry+= " ON B2_FILIAL = B8_FILIAL AND B2_COD = B8_PRODUTO AND B2_LOCAL = B8_LOCAL AND B2_FILIAL = '" + xFilial("SB2") + "' "
cQry+= " WHERE B8_PRODUTO BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "' " 
cQry+= " AND B8_LOCAL BETWEEN '" +MV_PAR03+ "' AND '" +MV_PAR04+ "' " 
cQry+= " AND SB8.B8_FILIAL = '" + xFilial("SB8") + "'  "
cQry+= " AND SB8.D_E_L_E_T_=''  "
cQry+= " AND SB2.D_E_L_E_T_=''  "
cQry+= " GROUP BY B2_FILIAL, B2_QATU, B8_PRODUTO, B8_LOCAL" 
cQry+= " ORDER BY B8_PRODUTO, B8_LOCAL"  

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf 

TCQUERY cQry New Alias "TRB"  

a_Pos := { 0, 12, 23, 30, 40, 78 } 

While TRB->(!EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif    
	
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TRB->B8_PRODUTO))
	
	If !Rastro(SB1->B1_COD)
		TRB->(DbSkip());Loop
	Endif
				
	IF TRB->TOTAL <> TRB->B2_QATU   // So vai imprimir na tela aqueles que o saldo estiver divergente
		
		nQatu := TRB->B2_QATU
		nTotal:= TRB->TOTAL	
		
		@nLin,a_Pos[1]  PSAY "FILIAL : "
   		@nLin,a_Pos[4]  PSAY TRB->B2_FILIAL
   		nLin++  
		@nLin,a_Pos[1]  PSAY "PRODUTO : "
   		@nLin,a_Pos[4]  PSAY TRB->B8_PRODUTO
   		nLin++  
   		@nLin,a_Pos[1]  PSAY "ARMAZEM : "
   		@nLin,a_Pos[4]  PSAY TRB->B8_LOCAL
   		nLin++
   		@nLin,a_Pos[1]  PSAY "SALDO FISICO :"
   		@nLin,a_Pos[4]  PSAY cvaltochar(nQatu)
   		nLin++
   		@nLin,a_Pos[1]  PSAY "SALDO POR LOTE :"
   		@nLin,a_Pos[4]  PSAY cvaltochar(nTotal)
   		nLin++
   		@nLin,a_Pos[1]  PSAY "SALDO DIVERGENTE :"
   		nDifer := nQatu - nTotal
   		IF nDifer < 0
	   		nDifer := nTotal - nQatu
   		ENDIF
   		@nLin,a_Pos[4]  PSAY cvaltochar(nDifer)
		nLin++
   		@nLin,a_Pos[1]  PSAY Replicate("-", 80)
   		nLin++ 
   		   		
   		TRB->(DbSkip())
	ELSE
		TRB->(DbSkip())
	ENDIF
ENDDO


SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil  
