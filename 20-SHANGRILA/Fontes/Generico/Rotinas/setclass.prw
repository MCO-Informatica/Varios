#INCLUDE "rwmake.ch"

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//   Programa ...: SETB1CLASS()                       Modulo : SIGACFG      //
//                                                                          //
//   Autor ......: MARCOS MARTINS NETO                Data ..: 05/08/08     //
//                                                                          //
//   Objetivo ...: Acertos na base de dados relativos a NCM e Class         //
//                                                                          //
//   Uso ........: Especifico da Shangrila , Capela e Cor&Lar               //
//                                                                          //
//   Observacoes :                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

User Function SETCLASS()
Local _cAlias	:= Alias()
Local _cIndex	:= IndexOrd()
Local _nRecNo	:= RecNo()
Local _aArea	:= GetArea()

//Local aStruSE1  	:= SE1->(dbStruct())                
//Local cTrbSE1		:= CriaTrab("",.F.)
Local lQuery		:= .F.
Local NCMTAB := {}
Local cAlias := "NCM"
Local cQuery

aadd(NCMTAB,{'05059000','J '})
aadd(NCMTAB,{'25131000','AI'})
aadd(NCMTAB,{'39012029','AR'})
aadd(NCMTAB,{'39021020','AQ'})
aadd(NCMTAB,{'39042100','AT'})
aadd(NCMTAB,{'39151000','AL'})
aadd(NCMTAB,{'39152000','AK'})
aadd(NCMTAB,{'39153000','AO'})
aadd(NCMTAB,{'39159000','AJ'})
aadd(NCMTAB,{'39169010','AM'})
aadd(NCMTAB,{'39173229','AV'})
aadd(NCMTAB,{'39191000','AD'})
aadd(NCMTAB,{'39221000','H '})
aadd(NCMTAB,{'39232190','AC'})
aadd(NCMTAB,{'39233000','Q '})
aadd(NCMTAB,{'39239000','AU'})
aadd(NCMTAB,{'39241000','E '})
aadd(NCMTAB,{'39241090','B '})
aadd(NCMTAB,{'39249000','F '})
aadd(NCMTAB,{'39249090','C '})
aadd(NCMTAB,{'39259000','G '})
aadd(NCMTAB,{'39264000','AA'})
aadd(NCMTAB,{'39269090','W '})
aadd(NCMTAB,{'44170090','R '})
aadd(NCMTAB,{'46012000','X '})
aadd(NCMTAB,{'53050090','U '})
aadd(NCMTAB,{'56022100','AF'})
aadd(NCMTAB,{'56074900','Y '})
aadd(NCMTAB,{'63071000','AB'})
aadd(NCMTAB,{'67010000','AN'})
aadd(NCMTAB,{'68053090','AH'})
aadd(NCMTAB,{'69120000','O '})
aadd(NCMTAB,{'73170090','AS'})
aadd(NCMTAB,{'73231000','AG'})
aadd(NCMTAB,{'74181100','K '})
aadd(NCMTAB,{'76151900','N '})
aadd(NCMTAB,{'82011000','V '})
aadd(NCMTAB,{'82119100','M '})
aadd(NCMTAB,{'82159910','L '})
aadd(NCMTAB,{'90191000','S '})
aadd(NCMTAB,{'94017900','T '})
aadd(NCMTAB,{'94018000','D '})
aadd(NCMTAB,{'94032000','Z '})
aadd(NCMTAB,{'94037000','I '})
aadd(NCMTAB,{'95030029','AP'})
aadd(NCMTAB,{'96031000','AE'})
aadd(NCMTAB,{'96039000','A '})
aadd(NCMTAB,{'96170010','P '}) 

//Local nSeq			:= 0
//Local nTamLin
//Local nX

//Local _nCountA	:= 00
//Local _nCountB	:= 00
//Local _nCountC	:= 00

dbSelectArea("SB1")
dbSetOrder(1)

#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		lQuery := .T.
		cQuery := " select SB1.B1_COD,SB1.B1_POSIPI,SB1.B1_CLASFIS from " + RetSqlName("SB1") + " SB1 where (trim(SB1.B1_POSIPI)<>'') order by SB1.B1_POSIPI"
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)},"Aguarde... Filtrando C/ NCM...")
	EndIf
#ENDIF

dbSelectArea(cAlias)
dbGoTop()
nTotReg := RecCount()
ProcRegua(nTotReg)
nContReg := 0
PT := 0

While !(cAlias)->(Eof())
	nContReg += 1
	IncProc("Processando C/ NCM: "+StrZero(nContReg,6,0)+If(lQuery,"","/"+StrZero(nTotReg,6,0)) )
	SB1->( dbSeek(xFilial("SB1")+(cAlias)->(B1_COD)) )
	PT:=ASCAN(NCMTAB,{|aVal|aVal[1]==trim((cAlias)->B1_POSIPI)})
 	if pt<>0
 	   Letra := NCMTAB[PT,2]
// 	   Letra2 := SB1->B1_CLASFIS
//	   If Trim(Letra2)<>Trim(Letra)
 	      RecLock("SB1",.F.)
	      SB1->B1_CLASFIS = Letra
	      MsUnLock()
//	   Endif
	Endif
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
EndDo

If lQuery
	dbSelectArea(cAlias)
	dbCloseArea()
EndIf
Alert("Processo Finalizado." + chr(13)+chr(10) + "Classificação fiscal acertada. ")
Return

dbSelectArea(_cAlias)
dbSetOrder(_cIndex)
dbGoTo(_nRecNo)
RestArea(_aArea)
Return
