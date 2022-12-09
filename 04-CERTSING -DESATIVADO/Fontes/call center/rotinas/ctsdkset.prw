#INCLUDE 'PROTHEUS.CH'

User Function ctsdkset()
Local aStru :=  {}

If !tccanopen('MAILIN')
	
	// Cria a tabela caso nao exista
	aStru :=  {}
	aadd(aStru,{"MAIL_CTA"	,"C",60,0})
	aadd(aStru,{"MAIL_TYPE"	,"C",1,0})
	aadd(aStru,{"MAIL_DATE","D",8,0})
	aadd(aStru,{"MAIL_TIME","C",8,0})
	aadd(aStru,{"MAIL_ID"	,"C",60,0})
	aadd(aStru,{"MAIL_FROM"	,"C",100,0})
	aadd(aStru,{"MAIL_TO"	,"M",10,0})
    aadd(aStru,{"MAIL_CC"	,"M",10,0})
	aadd(aStru,{"MAIL_BCC"	,"M",10,0})
	aadd(aStru,{"MAIL_SUBJ"	,"C",100,0})
	aadd(aStru,{"MAIL_ATTAC","M",10,0})
	aadd(aStru,{"MAIL_ETYPE","C",10,0})
	aadd(aStru,{"MAIL_EDESC","M",10,0})
	aadd(aStru,{"MAIL_ESTAC","M",10,0})
	aadd(aStru,{"MAIL_PROC","L",1,0})
	aadd(aStru,{"MAIL_INPRC","L",1,0})
	aadd(aStru,{"MAIL_SDK","C",6,0})
	aadd(aStru,{"MAIL_BASE","C",100,0})

	conout("Criando tabela de entrada MAILIN")
	DbCreate('MAILIN',aStru,"TOPCONN")
	
Endif

If !TcCanOpen('MAILIN','MAILIN01' )
	
	USE MAILIN ALIAS MAILIN EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falha ao abrir MAILIN em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON MAIL_CTA + MAIL_TYPE + MAIL_ID  TO ("MAILIN01")
	
	USE
	
Endif

If !TcCanOpen('MAILIN','MAILIN02' )
	
	USE MAILIN ALIAS MAILIN EXCLUSIVE NEW VIA "TOPCONN"
	
	IF NetErr()
		UserException("Falha ao abrir MAILIN em modo exclusivo para criacao do indice." )
	Endif
	
	// Cria o indice para busca de dados
	INDEX ON MAIL_TYPE + MAIL_ID + DtoS(MAIL_DATE)   TO ("MAILIN02")
	
	USE
	
Endif


Return                    

User Function ctsdkput(cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, lProc, lInProc ,cCodSDK, cBase)

Default cCta	:= "" 
Default cType	:= ""  
Default cId		:= ""  
Default cFrom	:= ""  
Default cTo		:= ""  
Default cCc		:= ""  
Default cBcc	:= ""  
Default cSub	:= ""  
Default cAtt	:= ""  
Default cErrDes	:= ""  
Default cErrSta	:= ""  
Default lProc	:= .F.
Default lInProc	:= .F.
Default cCodSDK	:= ""
Default	cBase	:= ""

If select("MAILIN") <= 0
	USE MAILIN ALIAS MAILIN SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException("Falha ao abrir MAILIN - SHARED" )
	Endif
	DbSetIndex("MAILIN01")
	DbSetOrder(1)
Endif

DbSelectArea("MAILIN")

DbAppend(.F.)    	
MAILIN->MAIL_CTA 	:= Upper(cCta)
MAILIN->MAIL_TYPE	:= cType
MAILIN->MAIL_DATE	:= Date()
MAILIN->MAIL_TIME	:= Time()
MAILIN->MAIL_ID		:= cId
MAILIN->MAIL_FROM	:= cFrom
MAILIN->MAIL_TO		:= cTo
MAILIN->MAIL_CC		:= cCc
MAILIN->MAIL_BCC	:= cBcc 
MAILIN->MAIL_SUBJ	:= cSub
MAILIN->MAIL_ATTAC	:= cAtt
MAILIN->MAIL_ETYPE	:= cErrTp
MAILIN->MAIL_EDESC	:= cErrDes
MAILIN->MAIL_ESTAC	:= cErrSta
MAILIN->MAIL_PROC	:= lProc
MAILIN->MAIL_INPRC	:= lInProc
MAILIN->MAIL_SDK	:= cCodSDK
MAILIN->MAIL_BASE	:= cBase

DBCommit()
Dbrunlock()

Return