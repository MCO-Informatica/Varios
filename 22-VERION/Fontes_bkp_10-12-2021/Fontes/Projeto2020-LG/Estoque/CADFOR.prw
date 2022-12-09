#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADFOR    º Autor ³ RICARDO CAVALINI   º Data ³  06/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ AJUSTA A NUMERACAO DO CAD DE FORNECEDOR                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CADFOR()


_cAlias:=Alias()
_nOrder:=IndexOrd()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA2")
DbGotop()
DbSeek(xFilial("SA2")+"ESTADO00")
DbSkip(-1)
_cCodCli := STRZERO((VAL(SA2->A2_COD)+1),6)
_cCodClP := STRZERO((VAL(SA2->A2_COD)+2),6)


USE SXF Alias "SXF" New
DbSelectArea("SXF")
dbGoTop()
while !eof()
   If SXF->XF_ALIAS <> "SA2"
      DbSkip()
      Loop
   Endif                

   IF ALLTRIM(SXF->XF_FILIAL) <> "\DATA\SA2010"
      DbSkip()
      Loop
   Endif                

   RecLock("SXF",.f.)
    SXF->XF_NUMERO := _CCODCLI
   MsunLock("SXF") 
   DbSelectArea("SXF")
   DBSKIP()
End

USE SXE Alias "SXE" New
DbSelectArea("SXE")
dbGoTop()
while !eof()
   If SXE->XE_ALIAS <> "SA2"
      DbSkip()
      Loop
   Endif

   IF ALLTRIM(SXE->XE_FILIAL) <> "\DATA\SA2010"
      DbSkip()
      Loop
   Endif                

   RecLock("SXE",.f.)
    SXE->XE_NUMERO := _CCODCLP
   MsunLock("SXE") 

   DbSelectArea("SXE")
   DBSKIP()
End

MATA020()

Return
