#INCLUDE "PROTHEUS.CH"

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    砇GOLDH01  ? Autor ? HEITOR XAROPE         ? Data ?12.04.2017潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o 砃umera os produtos                                          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       矱specifico GOLD HAIR                                        潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
User Function RGOLDH01()
/*
cCodTipo := AllTrim(M->B1_TIPO)
cCodRet  := ""

If SX5->(dbSeek(xFilial("SX5")+"W0"+cCodTipo))
	cCodRet := Soma1( AllTrim(SX5->X5_DESCRI) )
Else
	RecLock("SX5",.T.)
	SX5->X5_FILIAL	:= xFilial("SX5")
	SX5->X5_TABELA	:= "W0"
	SX5->X5_CHAVE	:= cCodTipo
	SX5->X5_DESCRI	:= "0000" 
	SX5->X5_DESCSPA	:= "0000" 
	SX5->X5_DESCENG	:= "0000"
	
	cCodRet := "0001"
EndIf	
	
While SB1->(dbSeek(xfilial("SB1")+cCodTipo+cCodRet))
	cCodRet := Soma1(cCodRet)
EndDo
                     
Return(cCodTipo+cCodRet)