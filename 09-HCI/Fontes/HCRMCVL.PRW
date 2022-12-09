#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M030ALT  ºAutor  ³ ROBSON BUENO       º Data ³  15/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PROGRAMA PARA REMONTAGEM DA TABELA DE CLASSE DE VALOR      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiscal                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HCRMCVL()
	Processa({|| OkProc()},"Atualiza Classe Valor","Atualizando dados, aguarde...")
RETURN

STATIC FUNCTION OKPROC()

Local aAreaAtu	:= GetArea()
lOk := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CERIFICACAO E CARGA DE CLASSE DE CALOR COM BASE EM CLIENTES               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
DbSelectArea("SA1")
dbSetOrder(1)
ProcRegua(RecCount())
While ( !Eof())
  DbSelectArea("CTH")
  dbSetOrder(1)
  If MsSeek(xfilial("CTH")+ "C" + SA1->A1_COD)     
          RECLOCK("CTH",.F.)
  else
          Reclock("CTH",.T.)
  ENDIF  	    
  CTH->CTH_FILIAL :=xfilial("CTH") 
  CTH->CTH_CLVL   := "C" + SA1->A1_COD
  CTH->CTH_CLASSE := "2"
  CTH->CTH_NORMAL := "2"
  CTH->CTH_DESC01 := SA1->A1_NOME    
  CTH->CTH_BLOQ  := "2"  
  CTH->CTH_DTEXIS := CTOD("01/01/80")
  CTH->CTH_CLVLLP := "C" + SA1->A1_COD
  MSUnlock()
  DbSelectArea("SA1")
  IncProc("ACERTANDO REG:"+ "C"+SA1->A1_COD + " Cliente " +SA1->A1_NOME)
  DBSKIP()
ENDDO
DbSelectArea("SA2")
dbSetOrder(1)
ProcRegua(RecCount())
While ( !Eof())
  DbSelectArea("CTH")
  dbSetOrder(1)
  If MsSeek(xfilial("CTH")+ "F" + SA2->A2_COD)     
          RECLOCK("CTH",.F.)
  else
          Reclock("CTH",.T.)
  ENDIF  	    
  CTH->CTH_FILIAL :=xfilial("CTH") 
  CTH->CTH_CLVL   := "F" + SA2->A2_COD
  CTH->CTH_CLASSE := "2"
  CTH->CTH_NORMAL := "1"
  CTH->CTH_DESC01 := SA2->A2_NOME    
  CTH->CTH_BLOQ  := "2"  
  CTH->CTH_DTEXIS := CTOD("01/01/80")
  CTH->CTH_CLVLLP := "F" + SA2->A2_COD
  MSUnlock()
  DbSelectArea("SA2")
  IncProc("ACERTANDO REG:"+ "F"+SA2->A2_COD + " Forn: " +SA2->A2_NOME)
  DBSKIP()
ENDDO
  
Return lOk
