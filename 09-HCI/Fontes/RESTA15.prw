#include "rwmake.ch"
#include "topconn.ch"

User Function RESTA15()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA01   ºAutor  ³Osmil Leite         º Data ³  16/08/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para converter os saldos iniciais de produtos     º±±
±±º          ³ da General Brands                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - General Brands                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ODLG,CINDDQT,CCLI,CCOD,CPROD,CLOCAL")

oDlg    := ""

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Conversao de Saldos Iniciais"
@ 05,10 TO 86,222
@ 91,165 BMPBUTTON TYPE 1 ACTION Procp1()
@ 91,195 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 13,25 SAY "Converte os Saldos Iniciais e Atualiza Produtos"

ACTIVATE DIALOG oDlg CENTERED

Return nil

Static function procp1()
processa({|| procp1a(),"Atualizando Arquivo"})
return nil

Static Function PROCP1a()

dbSelectArea("SB2")
dbgotop()

ProcRegua(LastRec())


dbSelectArea("SB2")
dbgotop()


While !Eof()
	
	IncProc('Atualizando Saldos da General Brands')
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava Sb9 - Saldos Iniciais                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SB9")
		
			RecLock("SB9",.t.)
			
			SB9->B9_FILIAL		:= xFilial("SB9")
			SB9->B9_COD			:= SB2->B2_COD
			SB9->B9_LOCAL		:= SB2->B2_LOCAL
			SB9->B9_QINI		:= SB2->B2_QATU
			SB9->B9_VINI1		:= SB2->B2_QATU*SB2->B2_CM1
			SB9->B9_DATA		:=DATE()
			SB9->B9_MCUSTD		:= "1"
			
			MSUNLOCK()
	
	dbSelectArea("SB2")
	dbSkip()
	
EndDo

dbSelectArea("SB2")
dbCloseArea()
Return(.T.)
