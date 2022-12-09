#INCLUDE "rwmake.ch"
#include "TopConn.ch"
#include "Protheus.ch"       
#Include "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RPCPR01  ³ Autor ³ GENILSON MOREIRA LUCAS  ³ Data ³ 05/11/2010 ³±±
±±³          ³          ³       ³ MVG CONSULTORIA         ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordem de produção personalizada.					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Shangri-la							                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPR01()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir as OPs "
Local cDesc2         := "para serem produzidas"
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "O R D E M   D E   P R O D U Ç Ã O"
Local nLin         	 := 80
Local imprime      	 := .T.
Local aOrd 			 := {"Ordem de Produção"}     

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RPCPR01"
Private nTipo        := 18
Private aReturn      := {OemToAnsi("Zebrado"),1,OemToAnsi("Administracao"),1,2,1,"",1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RPCPR01"
Private cString 	 := "SC2"
Private cPerg   	 := PADR("PCPR01",LEN(SX1->X1_GRUPO))
Private nOrdem


Private Cabec1       	 := ""
Private Cabec2       	 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local Opr             
Local oTFont   		:= TFont():New('Courier new',,-12,.T.)

BuscaOP()	//----> BUSCA A(s) OP(s) CONF PARAMETRO   


dbSelectArea("OP")
dbGoTop()
While !Eof()
	
	If lAbortPrint
		@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	titulo := "ORDEM  DE  PRODUÇÃO  -  Nº: " + OP->C2_NUM + OP->C2_ITEM + OP->C2_SEQUEN
	
	If nLin > 1
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif          
	

	@ nLin, 000	PSAY "PRODUTO:"
	@ nLin, Pcol()+001	PSAY ALLTRIM(OP->C2_PRODUTO)
	@ nLin, 023	PSAY "DESCRIÇÃO:"
	@ nLin, Pcol()+001	PSAY Subs(POSICIONE("SB1",1,XFILIAL("SBA1")+OP->C2_PRODUTO,"B1_DESC"   ),1,40)

	nLin++
	@ nLin, 000	PSAY "EMISSÃO:"
	@ nLin, Pcol()+001	PSAY OP->C2_EMISSAO
	@ nLin, 023	PSAY "PREVISÃO INI:"
	@ nLin, Pcol()+001	PSAY OP->C2_DATPRI
	@ nLin, 060	PSAY "ENTREGA:"
	@ nLin, Pcol()+001	PSAY OP->C2_DATPRF
	
	// IMPRIME OBS DA OP
	if ALLTRIM(OP->C2_OBS) <> ""
		nLin++
		@ nLin, 000	PSAY "OBSERVAÇÃO: " + OP->C2_OBS
	Endif           
	
	nLin++
	@ nLin, 000			PSAY "SALDO:"
	@ nLin, Pcol()+001	PSAY OP->C2_QUANT - OP->C2_QUJE 		Picture "@E 999999"
	@ nLin, 023			PSAY "QTD ORIG:"
	@ nLin, Pcol()+001	PSAY OP->C2_QUANT						Picture "@E 999999"
	@ nLin, Pcol()+006	PSAY "UM: " + POSICIONE("SB1",1,XFILIAL("SBA1")+OP->C2_PRODUTO,"B1_UM"   )
	@ nLin, 060	PSAY "ROTEIRO:"
	@ nLin, Pcol()+001	PSAY OP->C2_ROTEIRO
	
	nLin += 2
	
	// LISTA EMPENHOS DA OP
	@ nLin, 000		PSAY "PRODUTO    DESCRIÇÃO                            EMPENHO  UM  AM      EMP 2UM  2UM"
	nLin++
	@ nLin, 000		PSAY Replicate("-",80)
	nLin++
	
	//BUSCA EMPENHOS
	dbSelectArea("SD4")
	dbSetOrder(2)
	MsSeek(xFilial("SD4") + OP->C2_NUM + OP->C2_ITEM + OP->C2_SEQUEN)
	IF Eof()
		@ nLin, 000 		PSAY "OP SEM EMPRENHOS"
		nLin++
	Else
		While !Eof() .and. SD4->D4_OP = OP->C2_NUM + OP->C2_ITEM + OP->C2_SEQUEN
			
			@ nLin, 000 		PSAY  Alltrim(SD4->D4_COD)
			@ nLin, 011			PSAY  Subs(POSICIONE("SB1",1,XFILIAL("SB1")+SD4->D4_COD,"B1_DESC"   ),1,30)
			@ nLin, Pcol()+002  PSAY  SD4->D4_QUANT			Picture "@E 999999.99999"
			@ nLin, Pcol()+002  PSAY  POSICIONE("SB1",1,XFILIAL("SB1")+SD4->D4_COD,"B1_UM"   )
			@ nLin, Pcol()+002  PSAY  SD4->D4_LOCAL
			
			// PARA O CALCULO DA SEGUNDA UNID DE MEDIDA
			_TConv	:= POSICIONE("SB1",1,XFILIAL("SB1")+SD4->D4_COD,"B1_TIPCONV"   )  // DIVISOR OU MULTIPLICADOR
			_FConv	:= POSICIONE("SB1",1,XFILIAL("SB1")+SD4->D4_COD,"B1_CONV"   )     // FATOR
			_Vseg	:= 0                                                              // IRÁ GRAVAR O RESULTADO
			If _TConv == "D"
				_Vseg := SD4->D4_QUANT / _FConv
			Else
				_Vseg := SD4->D4_QUANT * _FConv
			EndIf 
			
			If _Vseg <> 0			
				@ nLin, Pcol()+002  PSAY  _Vseg			Picture "@E 99999.99999"
				@ nLin, Pcol()+002  PSAY  POSICIONE("SB1",1,XFILIAL("SB1")+SD4->D4_COD,"B1_SEGUM"   )
			EndIf
			
			nLin++
			dbSelectArea("SD4")
			dbSkip()
		EndDo
	EndIf
	
	//BUSCA OPERAÇÕES
	dbSelectArea("SG2")
	dbSetOrder(1)
	MsSeek(xFilial("SG2")+OP->C2_PRODUTO+OP->C2_ROTEIRO)
	IF Eof()                               
		nLin++                                              
		If alltrim(OP->C2_ROTEIRO) = ""
			@ nLin, 000 		PSAY "NÃO FOI ESCOLHIDO ROTEIRO PARA ESSA OP" 
		Else
			@ nLin, 000 		PSAY "PRODUTO NÃO TEM OPERAÇÕES" 
		EndIf
	Else
		
		nLin+= 2
		@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
		nLin++
		@ nLin, 000		PSAY "|"
		@ nLin, 027	PSAY "O  P  E  R  A  Ç  Õ  E  S"
		@ nLin, 79		PSAY "|"
		nLin++
		@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
		
		While !Eof() .and. SG2->G2_PRODUTO = OP->C2_PRODUTO .AND. SG2->G2_CODIGO = OP->C2_ROTEIRO
			
			If nLin > 70
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif
			
			nLin++
			@ nLin, 000 		PSAY  "| " + SG2->G2_OPERAC + " - "
			@ nLin, Pcol()+000  PSAY  substr(SG2->G2_DESCRI,1,18)
			@ nLin, 027			PSAY  " RECURSO: " + SG2->G2_RECURSO + " - "
			@ nLin, Pcol()+000  PSAY  Subs(POSICIONE("SH1",1,XFILIAL("SH1")+SG2->G2_RECURSO,"H1_DESCRI"   ),1,30)
			@ nLin, 79 			PSAY  "|"
			
			nLin++            
			@ nLin, 000			PSAY  "| FERRAM: " + alltrim(SG2->G2_FERRAM)  
			@ nLin, 027  		PSAY  " META/H: "
			@ nLin, Pcol()+000  PSAY  SG2->G2_LOTEPAD / SG2->G2_TEMPAD			Picture "@E 99999"
			@ nLin, 043			PSAY  " CICLO: "
			@ nLin, Pcol()+000  PSAY  3600 / (SG2->G2_LOTEPAD / SG2->G2_TEMPAD)	Picture "@E 99999"
			@ nLin, Pcol()+000  PSAY  "s"
			@ nLin, 060			PSAY  " PREVISÃO: "
			@ nLin, Pcol()+000  PSAY  ( SG2->G2_TEMPAD / SG2->G2_LOTEPAD) * (OP->C2_QUANT - OP->C2_QUJE)  Picture "@E 999.99"
			@ nLin, Pcol()+000  PSAY  "h"
			@ nLin, 79 		PSAY  "|"
			
			nLin++
			@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
			
			If MV_par05 > 0
				nLin++
				@ nLin, 000		PSAY "| TURNO |     DATA    | QTD PROD |  SALDO  | COD PERDA | QTD PERDA | UM | OBS "
				@ nLin, 79		PSAY "|"
				
				nLin++
				@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
			EndIF
			
			For i := 1 TO MV_PAR05
				nLin++
				@ nLin, 000		PSAY "|       | ___/___/___ |          |         |           |           |    |"
				@ nLin, 79		PSAY "|"
				
				nLin++
				@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
			NEXT
			
			@ nLin, 000		PSAY "|" + Replicate("-",78) + "|"
			dbSelectArea("SG2")
			dbSkip()
		EndDo
	EndIf
	
	If nLin > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	dbSelectArea("OP")
	dbSkip()
EndDo

dbSelectArea("OP")
dbCloseArea("OP")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function BuscaOP()
NUM1  	:= LEFT(MV_PAR01,6)
SEQ1	:= RIGHT(MV_PAR01,3)

NUM2  	:= LEFT(MV_PAR02,6)
SEQ2	:= RIGHT(MV_PAR02,3)

_cQuery := " Select "
_cQuery += " C2_EMISSAO, C2_DATPRF, C2_DATPRI, C2_PRODUTO, C2_NUM, "
_cQuery += " C2_ITEM, C2_SEQUEN, C2_QUANT, C2_QUJE, C2_OBS, C2_ROTEIRO "
_cQuery += " FROM SC2010 "
_cQuery += " WHERE "
_cQuery += " (C2_NUM BETWEEN '"+NUM1+"' AND '"+NUM2+"') AND "
_cQuery += " (C2_SEQUEN BETWEEN '"+SEQ1+"' AND '"+SEQ2+"') AND "
_cQuery += " (C2_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"') AND "
_cQuery += " D_E_L_E_T_ = '' "

_cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"OP",.T.,.T.)

TcSetField("OP","C2_EMISSAO"    	,"D",TamSX3("C2_EMISSAO"  )[1],TamSX3("C2_EMISSAO"  )[2])
TcSetField("OP","C2_DATPRF"    		,"D",TamSX3("C2_DATPRF"  )[1],TamSX3("C2_DATPRF"  )[2])
TcSetField("OP","C2_DATPRI"    		,"D",TamSX3("C2_DATPRI"  )[1],TamSX3("C2_DATPRI"  )[2])

RETURN()