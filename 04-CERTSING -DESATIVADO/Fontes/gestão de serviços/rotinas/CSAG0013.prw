#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "TBICONN.CH"

User Function CSAG0013()

Local oDlg

Private cTecnico := CriaVar("PAW_TECNIC")
Private cOS := PAW->PAW_OS
Private cHora := PAW->PAW_HORA
Private dData := PAW->PAW_DATA
Private cAr := PAW->PAW_AR
Private cCodigo := PAW->PAW_COD
Private nCont := 0

IF PAW->PAW_STATUS == "L" .OR. PAW->PAW_STATUS == "C"

	If Select("PA0") > 0
		DbSelectArea("PA0")
		DbCloseArea("PA0")
	End If
	
	dbSelectArea("PA0")
	dbSetOrder(1)
	dBSeek(PAW->PAW_FILIAL+PAW->PAW_OS)
	
	DEFINE MSDIALOG oDlg TITLE "Agendamento X Tecnico" FROM 0,0 TO 145,800 OF oDlg PIXEL
	@ 06,06 TO 40,397 LABEL "Agendamento" OF oDlg PIXEL
		
	@ 15, 15 SAY "Numero de OS" SIZE 45,8 PIXEL OF oDlg
	@ 25, 15 SAY cOs SIZE 80,10 PIXEL OF oDlg
		
	@ 15,60 SAY "Cliente" SIZE 45,8 PIXEL OF oDlg
	@ 25,60 SAY PA0->PA0_CLLCNO SIZE 130,10 PIXEL OF oDlg
		
	@ 15,200 SAY "Data" SIZE 35,8 PIXEL OF oDlg
	@ 25,200 SAY dData  SIZE 76,10 PIXEL OF oDlg
		
	@ 15,250 SAY "Hora" SIZE 45,8 PIXEL OF oDlg
	@ 25,250 SAY cHora SIZE 76,10 PIXEL OF oDlg
		
	@ 15,300 SAY "Tecnico" SIZE 45,8 PIXEL OF oDlg 
		
	If Empty(PAW->PAW_TECNIC)  
			
		@ 25,300 MSGET cTecnico F3 'PAX' SIZE 80,10 PIXEL OF oDlg PICTURE "@! 999999"
		
		lPAX := .F.
		
	Else
			
		cTecnico := PAW->PAW_TECNIC +" - "+ POSICIONE("PAX",1, xFilial("PAW")+PAW->PAW_TECNIC, "PAX_NOME")
			
		@ 25,300 SAY cTecnico SIZE 80,10 PIXEL OF oDlg 

		lPAX := .T.
		
	End If	
		
	If lPAX == .T.
		
		@ 50,280 BUTTON "&Remarcar" 	SIZE 36,12 PIXEL ACTION U_CSAG0015(cOs)
			
	End If
		
	@ 50,320 BUTTON "&Ok"       	SIZE 36,12 PIXEL ACTION IIF(lRet := CSAGVALID(),IIF(lRet := CSAGGRAVA(),oDlg:End(),.F.),.F.)
	@ 50,360 BUTTON "&Cancelar" 	SIZE 36,12 PIXEL ACTION oDlg:End()
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( oDlg:SetFocus() )
	
Else

	MsgAlert("Este agendamento não se encontra mais pendente o que impede o agendamento.")
	
End If

Return

Static Function CSAGVALID()

Local lRet := .T.
Local nCont := 0

If Select("PAW") > 0
	DbSelectArea("PAW")
	DbCloseArea("PAW")
End If

dBSelectArea("PAW")
dbSetOrder(1)
dbSeek(xFilial("PAW")+cTecnico)

If Found() 

	WHILE !EOF() .AND. ALLTRIM(PAW->PAW_COD)==ALLTRIM(cTecnico)
	
		IF PAW->PAW_DATA == dData .and. PAW->PAW_HORA == cHora 
		
			If PAW->PAW_STATUS == "C" .or. PAW->PAW_STATUS == "F"
		
				nCont++
				
			End If
			
		END IF
		
		PAW->(dBSkip())
		
	END DO
	
End If

IF nCont > 0

	lRet := .F.

	MsgAlert("Já exite agendamento para este tecnico na mesma data e horario")
	
END IF			

Return (lRet)

Static Function CSAGGRAVA()

Local cFileName := ""
Local cAssuntoEm := "Agendamento do Tecnicos(as)"
Local cCase := "TECNICO"
Local nCountaPAW := 0
Local nCountaStat := 0
Local nPosicao := 0

If Select("PAW") > 0
	DbSelectArea("PAW")
	DbCloseArea("PAW")
End If

dbSelectArea("PAW")
dbSetOrder(1)
dbSeek(xFilial("PAW")+cCodigo)

BEGIN TRANSACTION 
	RecLock("PAW",.F.)
	PAW->PAW_TECNIC	:= cTecnico
	PAW->PAW_STATUS := "C"
	MsUnlock()
END TRANSACTION
	
If Select("PAW") > 0
	DbSelectArea("PAW")
	DbCloseArea("PAW")
End If 

dBSelectArea("PAW")
dBSetOrder(4)
MsSeek(xFilial("PAW")+cOs)

While !EOF() .AND.PAW->PAW_OS == cOs

		nPosicao++
	
		If PAW->PAW_STATUS == "C"
			
			nCountaPAW++
		
		End If
		
	PAW->(dbSkip())

END

If nPosicao == nCountaPAW

	If Select("PA0") > 0
		DbSelectArea("PA0")
		DbCloseArea("PA0")
	End If
		
	dbSelectArea("PA0")
	dbSetOrder(1)
	dBSeek(xFilial("PAW")+cOs)
					
	BEGIN TRANSACTION                         
		RecLock("PA0",.F.)
		PA0->PA0_STATUS		:= "3"
		MsUnlock()
	END TRANSACTION
	
	U_CSFSEmail(PAW->PAW_OS, cFileName, PA0->PA0_EMAIL, cAssuntoEm, cCase)
	
End If
						
Aviso( "Agenda X Tecnico", "Tecnico agendado com sucesso", {"Ok"} )

Return(.T.)