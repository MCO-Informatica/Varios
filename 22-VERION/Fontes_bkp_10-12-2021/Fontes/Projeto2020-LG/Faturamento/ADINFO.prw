#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#Include "Fileio.ch"
#Include "tbiconn.ch"

User Function ADINFO()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"  //-> MUDAR

wArea 		:= GetArea()                       

cServerOrig := "172.0.0.202" //"10.0.0.128"
cDtBaseOrig := "MSSQL"
cAliasTopOrig:= "P11" //"SDBHML"  // <- MUDAR
nAmbOrig := TCLINK( cDtBaseOrig+"/"+cAliasTopOrig,cServerOrig)
//nAmbOrig	:= advConnection()

IF nAmbOrig < 0
	conout("Erro de conexão no servidor ORIGEM: "+cServerOrig+"/"+cDtBaseOrig+"/"+cAliasTopOrig)  
	//MsgAlert("Erro de conexão no servidor ORIGEM: "+cServerOrig+"/"+cDtBaseOrig+"/"+cAliasTopOrig)   
	Return
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre base de dados em outro servidor.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cServerDest := "172.0.0.202" //"10.0.0.128"
cDtBaseDest := "MSSQL"
cAliasTopDest:= "P11" //"SDBHML"  // <- MUDAR
nAmbDest := TCLINK( cDtBaseDest+"/"+cAliasTopDest,cServerDest)
IF nAmbDest < 0
	conout("Erro de conexão no servidor DESTINO: "+cServerDest+"/"+cDtBaseDest+"/"+cAliasTopDest)
	//MsgAlert("Erro de conexão no servidor DESTINO: "+cServerDest+"/"+cDtBaseDest+"/"+cAliasTopDest) 
	Return
EndIF                       

//Seta Ambiente Origem
TCSetConn(nAmbOrig)      

conout("Fecha Alias tabela Origem")
IF Select("TMP01") > 0
	DbSelectArea("TMP01")
	DbCloseArea()
EndIF 

conout("Abre tabela(s) de origem: GRUPOTRIB")
//DbUseArea(.T.,"TOPCONN","TESINT","TMP01",.T.,.F.)

cQuery := " SELECT NCM, Grupo, ORIGEM FROM GRUPOTRIB ORDER BY NCM"
TCQUERY cQuery ALIAS "TMP01" NEW           

WCond:= "" //'B9_FILIAL = "'+XFILIAL("SB9")+'"
WIndex:="B1_POSIPI"
WNomArq := CriaTrab("",.F.)

DBSELECTAREA("SB1")
INDREGUA("SB1",WNOMARQ,WINDEX,,WCOND, "Selecionando Produtos...")

DbSelectArea("TMP01")
DbGoTop()
nRec := 0
While !Eof()

	TCSetConn(nAmbOrig)	                                    
	
	DbSelectArea("SB1")
	_cOrigem := ALLTRIM(STR(TMP01->ORIGEM))
	_cPosIpi := Substr(TMP01->NCM,1,4)+Substr(TMP01->NCM,6,2)+Substr(TMP01->NCM,9,2)
	If DbSeek(_cPosIPI)  
		LCONT := .T.
		While !Eof() .and. _cPosIPI == ALLTRIM(SB1->B1_POSIPI) //.AND. LCONT
			If (_cOrigem == "1" .and. SB1->B1_ORIGEM == "0") .or. (SB1->B1_ORIGEM <> "0" .AND. _cOrigem == "0")
				RecLock("SB1",.F.)
					SB1->B1_GRTRIB := ALLTRIM(TMP01->GRUPO)
				MsUnlock()			
//				LCONT := .F.
			Endif
			
			DbSelectArea("SB1")
			Dbskip()			
		Enddo
	Endif
	
	/*
	RECLOCK("SFM",.T.)
		SFM->FM_POSIPI := Substr(TMP01->FM_POSIPI,1,4)+Substr(TMP01->FM_POSIPI,6,2)+Substr(TMP01->FM_POSIPI,9,2)  //9999.99.99
		SFM->FM_TIPO   := ALLTRIM(TMP01->FM_TIPO)  //01
		SFM->FM_GRPROD := ALLTRIM(TMP01->FM_GRPROD)  //I00001    
		SFM->FM_EST    := ALLTRIM(TMP01->FM_EST)  //PI
		SFM->FM_GRTRIB := ALLTRIM(TMP01->FM_GRTRIB)  //504
		SFM->FM_TS     := ALLTRIM(TMP01->FM_TS)  //524	
	MSUNLOCK()
	*/
	//testes

	TCSetConn(nAmbOrig)									
	DbSelectArea("TMP01")
	DbSkip()
					 
Enddo

conout("Fecha Alias tabela Origem")
IF Select("TMP01") > 0
	DbSelectArea("TMP01")
	DbCloseArea()
EndIF
     
TCSetConn(nAmbOrig)     

//MSGINFO("OK")                     
RESET ENVIRONMENT
conout("*************** FIM DO PROCESSO ***************")

RETURN

