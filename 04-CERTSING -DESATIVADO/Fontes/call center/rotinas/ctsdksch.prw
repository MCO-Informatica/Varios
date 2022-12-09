#INCLUDE "PROTHEUS.CH"

User Function CTSDKSCH(aParSch)

Local cJobEmp	:= ""
Local cJobFil	:= ""
Local _lJob 	:= (Select('SX6')==0)
Local cSql		:= ""
Local cUpd		:= ""
Local aArea		:= {}
//variaveis de controle
Local cCta		:= "" 
Local cType		:= ""  
Local cId		:= ""  
Local cFrom		:= ""  
Local cTo		:= ""  
Local cCc		:= ""  
Local cBcc		:= ""  
Local cSub		:= ""  
Local cAtt		:= ""  
Local cErrDes	:= ""  
Local cErrSta	:= ""
Local cBase		:= ""
Local nTotThread:= 0
Local nThread	:= 0

Default aParSch	:= {"01","02"} 

cJobEmp	:= aParSch[1]
cJobFil	:= aParSch[2]

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil) 
EndIf

cSql	:= ""
cSql	+= "	SELECT "
cSql	+= "		MAIL_CTA, "
cSql	+= "		MAIL_TYPE, "
cSql	+= "		MAIL_ID, "                                                       
cSql	+= "		MAIL_BASE, "                                                       
cSql	+= "		MAIL_FROM, "                                                     
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_TO,2000,1)),'') AS MAIL_TO, "                                                       
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_CC,2000,1)),'') AS MAIL_CC, "                                                       
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_BCC,2000,1)),'') AS MAIL_BCC, "                                                      
cSql	+= "		MAIL_SUBJ, "                                                                                             
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_ATTAC,2000,1)),'') AS MAIL_ATTAC, "
cSql	+= "		MAIL_ETYPE, "
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_EDESC,2000,1)),'') AS MAIL_EDESC,  "
cSql	+= "		NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(MAIL_ESTAC,2000,1)),'') AS MAIL_ESTAC "
cSql	+= "	FROM "
cSql	+= "	  MAILIN "
cSql	+= "	WHERE "
cSql	+= "	  MAIL_TYPE = 'R' AND "
cSql	+= "	  MAIL_INPRC = 'F' AND "
cSql	+= "	  MAIL_PROC = 'F' " //AND MAIL_FROM = 'Aline Moreira <amoreira@certisign.com.br>'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TRBMAIL",.F.,.T.)

cUpd := " UPDATE MAILIN SET MAIL_INPRC = 'T' " 
cUpd += "	WHERE "
cUpd += "	  MAIL_TYPE = 'R' AND "
cUpd += "	  MAIL_INPRC = 'F' AND "
cUpd += "	  MAIL_PROC = 'F' "
TcSqlExec(cUpd)

While !TRBMAIL->(EoF())
	//CONOUT("************** RODOU O TESTE **************")
	cCta 	:= Upper(Alltrim(TRBMAIL->MAIL_CTA))
	cType 	:= Alltrim(TRBMAIL->MAIL_TYPE)	
	cId 	:= Alltrim(TRBMAIL->MAIL_ID)		
	cFrom	:= Alltrim(TRBMAIL->MAIL_FROM)	
	cTo		:= Alltrim(TRBMAIL->MAIL_TO)		
	cCc		:= Alltrim(TRBMAIL->MAIL_CC)		
	cBcc	:= Alltrim(TRBMAIL->MAIL_BCC)	
	cSub	:= Alltrim(TRBMAIL->MAIL_SUBJ)	
	cAtt	:= Alltrim(TRBMAIL->MAIL_ATTAC)	
	cErrTp	:= Alltrim(TRBMAIL->MAIL_ETYPE)	
	cErrDes	:= Alltrim(TRBMAIL->MAIL_EDESC)	
	cErrSta	:= Alltrim(TRBMAIL->MAIL_ESTAC)	
	cBase	:= Alltrim(TRBMAIL->MAIL_BASE)
 
	aUsers 	:= Getuserinfoarray()
	nThread := 0
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CTSDK12" ,nThread++,nil )  })
	
	nSleep := Randomize(1,3)
	
	If nThread <= 10
                              
		nTotThread += nThread

		StartJob("U_CTSDK12",GetEnvServer(),.F.,cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, _lJob, cBase, cJobEmp, cJobFil )
		//U_CTSDK12( cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, _lJob, cBase, cJobEmp, cJobFil )
		cUpd := " UPDATE MAILIN SET MAIL_PROC = 'T' WHERE MAIL_TYPE = 'R' AND MAIL_ID = '"+cId+"' "
	
		TcSqlExec(cUpd)
		
		nSleep := Randomize(1,3)*1000
		
		Sleep(nSleep)		
		
		TRBMAIL->(DbSkip())
	EndIf
	
	If nTotThread > 100                           
 		DelClassIntf()
	    nTotThread := 0
	EndIf
EndDo	

TRBMAIL->(DbCloseArea())

Return