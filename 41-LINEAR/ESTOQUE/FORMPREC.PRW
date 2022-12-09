USER FUNCTION FPREC(CCOD)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FORMPREC  ºAutor  Rogerio - Supertech  º Data ³  03/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Formaçao de preco com valor dos impostos                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

aArea	:= GetArea()

DBSELECTAREA("SG1")
DBSETORDER(1)
DBSEEK(XFILIAL("SG1")+CCOD,.T.)

NRET		:=0
VALPIS1		:=0
VALCOFINS1	:=0
VALICM1		:=0
TOTALIQ		:=0
ACOMP	 	:={}

DO WHILE! EOF() .AND. SG1->G1_COD == CCOD
	
	IF SG1->G1_COMP <> CCOD

		AADD(ACOMP,SG1->G1_COMP)
		NRET1		:=GETADVFVAL("SB1","B1_UPRC",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		VALPIS		:=GETADVFVAL("SB1","B1_PPIS",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NRET1 /100//SG1->G1_QUANT
		VALCOFINS	:=GETADVFVAL("SB1","B1_PCOFINS",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NRET1/100 //SG1->G1_QUANT
		VALICM		:=GETADVFVAL("SB1","B1_PICM",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NRET1/100 //SG1->G1_QUANT
 		TOTALIQ1	:=VALPIS+VALCOFINS+VALICM  // (NRET1*VALPIS)/100+(NRET1*VALCOFINS)/100+(NRET1*VALICM)/100

	
	ENDIF
	
	DbSkip ()
	
	NRET		:= NRET + TOTALIQ1
	TOTALIQ		:=0  
	VALPIS		:=0
	VALCOFINS	:=0
	VALICM		:=0

END DO

FOR I := 1 TO LEN(ACOMP)

DBSELECTAREA("SG1")
DBSETORDER(1)
DBSEEK(XFILIAL("SG1")+ACOMP[I],.T.)

DO WHILE! EOF("SG1") .AND. SG1->G1_COD == ACOMP[I]
	
	IF SG1->G1_COMP <> ACOMP[I]

		NTOT		:=GETADVFVAL("SB1","B1_UPRC",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		VALPIS		:=GETADVFVAL("SB1","B1_PPIS",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NTOT /100//SG1->G1_QUANT
		VALCOFINS	:=GETADVFVAL("SB1","B1_PCOFINS",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NTOT/100 //SG1->G1_QUANT
		VALICM		:=GETADVFVAL("SB1","B1_PICM",XFILIAL("SB1")+SG1->G1_COMP,1,"")* NTOT /100//SG1->G1_QUANT
 		TOTALIQ		:=VALPIS+VALCOFINS+VALICM  // (NRET1*VALPIS)/100+(NRET1*VALCOFINS)/100+(NRET1*VALICM)/100
	
	ENDIF

	DbSkip ()
	
	NTOT		:= NTOT + TOTALIQ
	TOTALIQ		:=0  
	VALPIS		:=0
	VALCOFINS	:=0
	VALICM		:=0
	
END DO

NEXT	

NRET2	:= NTOT+NRET

RestArea(aArea)

RETURN NRET2