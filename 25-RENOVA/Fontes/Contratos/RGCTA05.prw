#Include "RwMake.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲uncao    ? RGCTA05  ? Autor ? TOTVS                 ? Data ? 20/10/08 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escricao ? Geracao do codigo inteligente para Contratos               潮?
北?          ?                                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? DIEDRO 	                                                  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砄bs.      ? Gatilho        : CN9_                                      潮?      
北?          ? Contra Dominio : CN9_                                      潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
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