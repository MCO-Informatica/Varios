#Include "RwMake.ch"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RGCTA05  ³ Autor ³ TOTVS                 ³ Data ³ 20/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do codigo inteligente para Contratos               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ DIEDRO 	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs.      ³ Gatilho        : CN9_                                      ³±±      
±±³          ³ Contra Dominio : CN9_                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RGCTA05()
*
Local aArea  := GetArea()
Local cArea  := M->CN9_XTIPO  
Local cGrupo :=STRZERO(YEAR(M->CN9_DTINIC),4)
Local cCodNew := Alltrim(cArea) + Alltrim(cGrupo) + "00001"
*
IF Inclui
   	If Empty(cArea)
		M->CN9_DTINIC   := SPACE(Len(M->CN9_DTINIC))
		cCodNew := SPACE(Len(M->CN9_NUMERO))
	Endif                                                             
	*                                                                        
	dbSelectArea("CN9")
	dbSetOrder(1)
	While .T.
		IF !MsSeek(xFilial("CN9")+cCodNew)
			Exit
		Endif
//		cCodNew := Subs(cCodNew,1,9)+SOMA1(Right(cCodNew,5)) Romay 24-07-2015
	cCodNew := Subs(cCodNew,1,len(cCodNew)-5)+SOMA1(Right(cCodNew,5)) //Romay 24-07-2015
	Enddo
	*
Else
	cCodNew := M->CN9_NUMERO
Endif
RestArea(aArea)
Return(cCodNew)