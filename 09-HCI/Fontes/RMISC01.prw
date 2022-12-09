#include "rwmake.ch"
#include "topconn.ch"

User Function RMISC01()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RMISC01   ºAutor  ³Osmil Squarcine     º Data ³  26/01/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para acertar os campos do sb1(cadastro produtos ) º±±
±±º          ³ com os campos do sbm (cadastro de grupos)                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - HCI                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ODLG,CINDDQT,CCLI,CCOD,CMSG")

oDlg    := ""
cString := " "
cRetorno:= .T.

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Ajuste do SB1 com SBM  "
@ 05,10 TO 86,222
@ 91,165 BMPBUTTON TYPE 1 ACTION Procp1()
@ 91,195 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 13,25 SAY "Este programa ajusta SB1 com SBM"

ACTIVATE DIALOG oDlg CENTERED

Return nil

Static function procp1()
processa({|| procp1a(),"Atualizando Arquivo"})
return nil

Static Function PROCP1a()

dbSelectArea("SB1")
dbgotop()

ProcRegua(LastRec())

While !Eof()
	IncProc('Atualizando Produtos')
	
	dbSelectArea("SBM")
	dbSetOrder(1)
	dbSeek(xFilial("SBM")+SB1->B1_COD)
	
	If Found()
		dbSelectArea("SB1")
		// Aqui comeca a atualizacao do cadastro de produtos
		RecLock("SB1",.F.)
		SB1->B1_PICM		:=  SBM->BM_NOMEDOCAMPO		// Aliquota de ICMS
		SB1->B1_POSIPI		:=  SBM->BM_NOMEDOCAMPO		// Ncm
		SB1->B1_IPI			:=  SBM->BM_NOMEDOCAMPO		// Aliquota de IPI
		MSUNLOCK()
	EndIf
	dbSelectArea("SB1")
	dbSkip()
EndDo

Return(.T.)
