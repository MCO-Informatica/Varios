#include 'PARMTYPE.CH'
#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSAGAGEN    ºAutor  ³Claudio Henrique Corrêaº Data ³24/05/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Agendamento por Tecnico e Data                  º±±
±±º          ³Rotina chamada atravez CSAG012                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSAGAGEN(oBrowse)

Local oExcel 	:= NIL
Local aHoras	:= {}
Local aLinha	:= {}
Local aCabec	:= {}
Local aAtend	:= {}
Local aPergs	:= {}
Local aRet		:= {}
Local aExcel	:= {}
Local lRet		:= .F.
Local dDatIni	:= CriaVar("PA0_DTAGEN")
Local dDatFim	:= CriaVar("PA0_DTAGEN")
Local cCodAr	:= CriaVar("PA0_AR")
Local nDiasDif 	:= 0
Local nCont		:= 0
Local aCmpTrb	:= {}
Local aDias 	:= {}

aAdd( aPergs ,{1,"Data Inicial : ",dDatIni,"","","","",50,.F.})
aAdd( aPergs ,{1,"Data Final : ",dDatFim,"","","","",50,.F.})   
aAdd( aPergs ,{1,"Posto Atend.: ",cCodAr,"","","SZ3","",0,.F.})

If ParamBox(aPergs ,"Consulta Agenda",@aRet)      
    
	lRet := .T.
	 
	dDatIni := aRet[1]
	dDatFim := aRet[2]
	cCodAr	:= aRet[3] 
	
Else         

	lRet := .F.
	
	Return(lRet)   
	
EndIf

//Monta coluna de horas disponiveis conforme dados informados nos calendarios padrões por AR

nDiasDif := DateDiffDay( dDatIni , dDatFim )

nDiasDif := nDiasDif + 1

For nCont := 1 To nDiasDif

	aHoras := U_CSAGHORA(dDatIni,cCodAr) //Função para montar os horarios com base no calendarios padrão, chamada pela função CSAG0010
	
	aAdd(aLinha,aHoras)
	
	If dDatFim >= dDatIni
	
		aAdd(aDias,{dDatIni})
		
		dDatIni++	
		
	End If

Next nCont 

// Monta os tecnicos disponiveis por AR
	
DbSelectArea("PAX")
DbSetOrder(2)
DbSeek(xFilial("PAX")+cCodAr)

If PAX->(Found())

	While PAX->(!EOF()) .AND. PAX->PAX_AR==cCodAr
	
		If !Empty(PAX->PAX_DTFIMD)
		
			If dDataBase < PAX->PAX_DTFIMD
			
				aAdd(aCabec, {PAX->PAX_MAT,PAX_NOME})
			
			End If
			
		Else
		
			aAdd(aCabec, {PAX->PAX_MAT,PAX_NOME})
		
		End If
			
		PAX->(dBSkip())
	
	End Do

End If

cPath := GetTempPath()
cName  := cPath + "Consulta_Agendas.xml"

oExcel := FWMSEXCEL():New()

cData := ""

For nCont := 1 To Len(aDias)

	cExcel := ""

	cData := dtoc(aDias[nCont][1])
	
	oExcel:AddworkSheet(cData)
	
	oExcel:AddTable (cData, "Agenda Tecnicos AR :" + cCodAr)
	
	oExcel:AddColumn(cData,"Agenda Tecnicos AR :" + cCodAr,"Horarios",1,1,.F.)
	
	For nTab := 1 To Len(aCabec)

		oExcel:AddColumn(cData,"Agenda Tecnicos AR :" + cCodAr,aCabec[nTab][2],1,1,.F.)
	
	Next nTab
	
	For nHor := 1 To len(aLinha[nCont])
	
		cExcel := aLinha[nCont][nHor][1]
		
		For nRow := 1 To Len(aCabec)
		
			cQryPA2 := " SELECT * "
			cQryPA2 += " FROM " + RetSqlName("PA2") + " PA2, " + RetSqlName("PA0") + " PA0"
			cQryPA2 += " WHERE PA2.D_E_L_E_T_ = '' "
			cQryPA2 += " AND PA0.D_E_L_E_T_ = '' "
			cQryPA2 += " AND PA2.PA2_NUMOS = PA0.PA0_OS "
			cQryPA2 += " AND PA2.PA2_DATA = " + dtos(ctod(cData))
			cQryPA2 += " AND PA0.PA0_HRAGEN = '" + aLinha[nCont][nHor][1] + "'"
			cQryPA2 += " AND PA2.PA2_CODTEC = '" + aCabec[nRow][1] + "'"
				
			cQryPA2 := changequery(cQryPA2)

			If Select("_PA2") > 0
				DbSelectArea("_PA2")
				DbCloseArea("_PA2")
			End If 

			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryPA2),"_PA2",.F.,.T.)
				
			dbSelectArea("_PA2")
			
			cReg := _PA2->PA2_CODAGE
			
			If !Empty(cReg)
						
				cExcel += "; OS: "+ _PA2->PA2_NUMOS + Chr(13) + Chr(10) +;
				"     CLIENTE: " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_CLLCNO")+ Chr(13) + Chr(10) +;
				"     END: "+ POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_END") + " " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_COMPLE") + Chr(13) + Chr(10) +;
				"     TEL: " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_DDD") + " " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_TEL")+ Chr(13) + Chr(10) +;
				"     E-MAIL: " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_EMAIL")+ Chr(13) + Chr(10) +;
				"     CONTATO: " + POSICIONE("PA0",1,xFilial("PA2")+_PA2->PA2_NUMOS,"PA0_CONAGE")
				
				dbSelectArea("PA1")
				dbSetOrder(1)
				dbSeek(xFilial("PA0")+_PA2->PA2_NUMOS)
				
				While PA1->(!EOF()) .AND.  ALLTRIM(PA1->PA1_OS) == ALLTRIM(_PA2->PA2_NUMOS)
				
						If PA1->PA1_FATURA <> "S" .or. PA1->PA1_FATURA <> "N"
					
							cExcel += "     PEDIDO: " + PA1->PA1_PEDIDO
					
						End If 

					PA1->(dbSkip())	
				
				End Do
							
			Else
						
				cExcel += ";- "
						
			End If
			
		Next nRow
		
		aExcel := STRTOKARR(cExcel,";")	
		
		oExcel:AddRow(cData,"Agenda Tecnicos AR :" + cCodAr,aExcel)
		
		aExcel := {}	
			
	Next nHor
	
Next nCont																						
																									
oExcel:Activate()
oExcel:GetXMLFile(cName)
Shellexecute("OPEN", cName, '', '' , 1)

oBrowse:Refresh()

Return(.T.)