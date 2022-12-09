#include "Protheus.Ch"  
#INCLUDE "TOTVS.CH"
#include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XSEQPROD  ºAutor  ³Romay Oliveira      º Data ³  12/01/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Sequenciador do codigo do produto b1_xmodelo + sequencial  º±±
±±º          ³ 							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XSEQPROD()
Local cQuery	:= ''
Local cNextNum 	:= M->B1_COD   
Local cNumQry 	:= M->B1_XMODELO

       
If !Empty(M->B1_XMODELO) //.AND. INCLUI //só se for inclusão

		If Select("Qry2") > 0//Verifica se ja existe alias criado
			Qry2->( dbCloseArea() )
		EndIf
		         
		//Com sub-query, pois buga o tipo qd utiliza MAX direto.
		cQuery := "	SELECT  "
		cQuery += "		B1_COD "
		cQuery += "	FROM "
		cQuery += RetSqlName("SB1") + " SB1 "
		cQuery += "	WHERE "
		cQuery += "		B1_COD 		=  "
		cQuery += "	( "
		cQuery += "	SELECT  "
		cQuery += "		MAX(B1_COD) "
		cQuery += "	FROM "
		cQuery += RetSqlName("SB1") + " SB1 "
		cQuery += "	WHERE "
		cQuery += "		B1_FILIAL 		= '" + xFilial('SB1') + "' "
	   //	cQuery += " 	AND A1_XMODELO 	<> '' "
		cQuery += " 	AND SB1.D_E_L_E_T_ <> '*' "
		cQuery += "		AND B1_COD LIKE '"+ AllTrim(cNumQry) +"%'    " 
		cQuery += "	) "
		                        
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry2",.T.,.T.) 
		
		If Qry2->( !EOF() )
			                			
		   	cNextNum := Soma1( AllTrim(Qry2->B1_COD) )
				
		Else
		
		   	cNextNum := cNumQry + "0001"
		
		EndIf

	Endif


Return (cNextNum) 