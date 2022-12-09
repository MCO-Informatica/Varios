#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMK273PTC ºAutor  ³Opvs (David)        º Data ³  19/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para replicação dos dados do Prospect para o Cliente   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMK273PTC()
Local __aArea 		:= GetArea()
Local __aUSStru	:= SUS->(DbStruct())
Local __nI				:= 0 
Local __cCpoSA1 := ""
Local __cCpoSus := ""

DbSelectArea("SA1")
SA1->(DbSetOrder(1))

If SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE))
	RecLock("SA1",.F.)
	For  __nI:= 1 to Len(__aUSStru)
		__cCpoSA1 := StrTran(__aUSStru[__nI,1],"US_","A1_")
		__cCpoSus := __aUSStru[__nI,1] 	
		
		If 	SA1->(FieldPos(__cCpoSA1)) > 0 .and.;
			!__cCpoSA1 $ "A1_FILIAL,A1_COD"
					
			&("SA1->"+__cCpoSA1) := &("SUS->"+__cCpoSUS)
			
		EndIf
	Next
	SA1->A1_COD_MUN := Posicione("PA7",1,xFilial("PA7")+SUS->US_CEP,"PA7_CODMUN")
	SA1->A1_STATVEN := "1"
	SA1->A1_CONTA	:= "110301001" 
	SA1->A1_RECISS	:= "2"
	SA1->A1_ALIQIR	:= IIF(SA1->A1_PESSOA = "F", 0 , 1.5 )
	SA1->A1_RECISS	:= "2"
	SA1->A1_INCISS	:= "S"
	SA1->A1_RECCOFI	:= IIF(SA1->A1_PESSOA = "F", "N" , "S" )
	SA1->A1_RECCSLL	:= IIF(SA1->A1_PESSOA = "F", "N" , "S" )
	SA1->A1_RECPIS	:= IIF(SA1->A1_PESSOA = "F", "N" , "S" )
	SA1->A1_RECIRRF	:= IIF(SA1->A1_PESSOA = "F", "1" , "2" )
	SA1->A1_ABATIMP	:= "1"
	SA1->A1_INSCR	:= IIF(UPPER(SUBSTRING(SA1->A1_INSCR,1,1)) = "I", "ISENTO" , SA1->A1_INSCR )
	SA1->(MsUnlock())
EndIf
RestArea(__aArea)

Return
