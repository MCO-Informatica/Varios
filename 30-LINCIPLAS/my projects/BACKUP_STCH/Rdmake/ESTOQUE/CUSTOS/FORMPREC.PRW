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
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


aArea := GetArea()

DBSELECTAREA("SG1")
DBSETORDER(1)
DBSEEK(XFILIAL("SG1")+CCOD,.T.)


NRET:=0
VALPIS1:=0
VALCOFINS1:=0
VALICM1:=0
TOTALIQ:=0


DO WHILE! EOF() .AND. SG1->G1_COD==CCOD 
	
	
	NTIPO:=GETADVFVAL("SB1","B1_TIPO",XFILIAL("SB1")+SG1->G1_COMP,1,"")
    
	
   	IF NTIPO=="MP" 		
	
		NRET1:=GETADVFVAL("SB1","B1_UPRC",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		VALPIS:=GETADVFVAL("SB1","B1_PPIS",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		VALCOFINS:=GETADVFVAL("SB1","B1_PCOFINS",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		VALICM:=GETADVFVAL("SB1","B1_PICM",XFILIAL("SB1")+SG1->G1_COMP,1,"")*SG1->G1_QUANT
		TOTALIQ:=(NRET1*VALPIS)/100+(NRET1*VALCOFINS)/100+(NRET1*VALICM)/100
		
		
	END IF
	DbSkip ()
	NRET:=NRET+TOTALIQ
	
END DO
RestArea(aArea)

RETURN NRET