#include 'protheus.ch'
#include 'parmtype.ch'

user function CSAGCOHO()

static cHora := ''

Local bRet := .F.
Local aHeader := {}

Private aHoraDisp := {}

If Empty(M->PAW_HORA)

	Aviso( "Favor preencher o campo Hora", "Não existe dados a consultar", {"Ok"} )

	Return .F.
	
Endif	
 
bRet := FiltraPAW()

Return(bRet)

Static Function FiltraPAW()

Local oLstPAW := nil
Local nList := 0

Private oDlgPAW := nil
Private _bRet := .F.
Private aDadosPAW := {} 

aDadosPAW := CSAGHORA(M->PAW_DATA, M->PAW_AR)

//--Montagem da Tela

Define MsDialog oDlgPAW Title "Consulta Horas" From 0,0 To 280, 500 Of oMainWnd Pixel
@ 5,5 LISTBOX oLstPAW ;
VAR lVarMat ;
Fields HEADER "Horas Disp" ;
SIZE 245,110 On DblClick ( ConfPAW(oLstPAW:nAt, @aDadosPAW, @_bRet) ) ;
OF oDlgPAW PIXEL

	oLstPAW:SetArray(aDadosPAW[1])

	oLstPAW:nAt := nList

	oLstPAW:bLine := { || {aDadosPAW[oLstPAW:nAt]}}

	DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfPAW(oLstPAW:nAt, @aDadosPAW, @_bRet) ENABLE OF oDlgPAW 

	DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgPAW:End() ENABLE OF oDlgPAW 

Activate MSDialog oDlgPAW Centered

Return _bRet


Static Function ConfPAW(_nPos, aDadosPAW, _bRet)

Local aCols := {}
Local aCpoRet := {}
Local n := 1
Private cCodigo

cCodigo := aDadosPAW[_nPos,1]

cHora:= cCodigo

_bRet := .T.

aAdd(aCpoRet,{cCodigo})

oDlgPAW:End()

Return

Static Function CSAGHORA(dData, cCodAr)

LOCAL cCaption := "Horarios Disponiveis Agendamento"
LOCAL aBotao   := {}
LOCAL aButao   := {}
LOCAL oDlg     := NIL
LOCAL cAction  := ""
Local bAction  		:= {||}
Local bWhen	   := {||}
LOCAL nLin     := 0
LOCAL nCol     := 0
LOCAL i        := 0
LOCAL j        := 0
LOCAL y        := 0
LOCAL oMainWnd := NIL
LOCAL oBmp     := NIL
LOCAL aUsers   := {}
LOCAL aAr		:={}
LOCAL lPAV		:= .F.
Local aDiaSem := {"Segunda-Feira","Terça-Feira","Quarta-Feira","Quinta-Feira","Sexta-Feira","Sabado","Domingo"}
Local aTbutton := {}
Local nPosIni := 0
Local nPosFim := 0
Local aPAW := {}
Local bWhen 			:= NIL
Local lRet := .F.
Local nPrecisa := GETNEWPAR("MV_PRECISA", 1)
Local n	:= 0
Local t:= 0
DbSelectArea("PAV")
DbSetOrder(1)
DbSeek(xFilial("PAV")+cCodAr)

If PAV->(Found())

	dbSelectArea("PAY")
	dbSetOrder(1)
	dbSeek(xFilial("PAY")+cCodAr)
	
	If PAY->(Found())
	
		If PAY->PAY_DATA == dDataAg
	
			cExcecao := PAY->PAY_QTDATE
			
			cAtSimul := Str(Val(PAV->PAV_SIMULT)+nExcecao)
			
		Else
		
			cAtSimul := PAV->PAV_SIMULT
			
		End If
		
	Else
	
		cAtSimul := PAV->PAV_SIMULT
		
	End If
	
	DbSelectArea("SH7")
	DbSetOrder(1)
	DbSeek(xFilial("SH7")+PAV->PAV_ALOC)

	If SH7->(Found())
	
		lPAV := .T.
		
		cAloc := SH7->H7_ALOC
		
	End If
	
End If	

if lPAV

	aRet := CSAGARRAY()
	
	dData := dData
	
	nSemana := Dow(dData)
	
	DO CASE 
	
		CASE nSemana == 1
		
			nSemana := 7
			
		CASE nSemana == 2
		
			nSemana := 1
			
		CASE nSemana == 3
		
			nSemana := 2
			
		CASE nSemana == 4
		
			nSemana := 3
			
		CASE nSemana == 5
		
			nSemana := 4
			
		CASE nSemana == 6
		
			nSemana := 5
			
		CASE nSemana == 7
		
			nSemana := 6
			
	END CASE
	
	If Select("PAW") > 0
		DbSelectArea("PAW")
		DbCloseArea("PAW")
	End If
	
	DbSelectArea("PAW")
	DbSetOrder(3)
	DbSeek(xFilial("PAW")+cCodAr)

	If Found()
	

		WHILE !EOF() .AND. ALLTRIM(PAW->PAW_AR)==ALLTRIM(cCodAr)
		
			If PAW->PAW_STATUS == "P" .AND. PAW->PAW_DATA == dData

				aAdd(aPAW,{PAW->PAW_DATA,PAW->PAW_HORA,PAW->PAW_OS})
				
			End If
			
			PAW->(dbSkip())
		
		End Do
	
	End If
	
	For n := 1 To Len(aRet)
	
		nDiaSemana := aRet[n][1]
		nPosIni := aRet[n][2]
		
		If nDiaSemana == nSemana
		
			cHoras := StrZero(Int(nPosIni/nPrecisa), 2)
			cMinutos := StrZero((60/nPrecisa) * (((nPosIni/nPrecisa) - Int(nPosIni / nPrecisa)) * 2) , 2)
			cHorasFim := cHoras + ":" + cMinutos
			
			aAdd(aButao,{cHorasFim, dtoc(dData)})
				
		End If
	
	Next n
	
	If !Empty(aButao)
		
		nPos := 0
			
		For t := 1 To Len(aButao) 
				
			cBotao := aButao[t][1]
			
			If Select("_PAW") > 0
				DbSelectArea("_PAW")
				DbCloseArea("_PAW")
			End If
			
			cHrQry := aButao[t,1]
				
			cQRYPAW := " SELECT COUNT(PAW_HORA) as HORA "
			cQRYPAW += " FROM "+ RETSQLNAME("PAW")
			cQRYPAW += " WHERE D_E_L_E_T_ = '' "
			cQRYPAW += " AND PAW_FILIAL = '"+ xFILIAL("PAW") + "'"
			cQRYPAW += " AND PAW_AR = '"+ cCodAr + "'"
			cQRYPAW += " AND PAW_STATUS = 'P' "
			cQRYPAW += " AND PAW_DATA = '" + dtos(dData) + "'"
			cQRYPAW += " AND PAW_HORA = '" + cHrQry + "'"
	
			cQRYPAW := changequery(cQRYPAW)
	
			dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQRYPAW),"_PAW", .F., .T.)
			
			nNum := 0
				
			IF _PAW->HORA < val(cAtSimul)
			
				cHoraB 	:= aButao[t][1]
				cDiaB 	:= aButao[t][2]
					
				aAdd(aHoraDisp,{aButao[t][1], aButao[t][2]})
			      
			End If
					
		Next t
			
	End If
		
End If

RETURN (aHoraDisp)

Static Function CSAGARRAY()

Local nDias:=0
Local aRet:={}
Local cCalend:=""
Local nInicio	:= 1
Local nPrecisa 	:= GETNEWPAR("MV_PRECISA", 1)
Local nTamDia:=1440/(60/nPrecisa)
Local aPAW := {}
Local cMinutos
Local nMarca := 0
Local nX := 0
Local aHora := {}
Local nInter := 0
Local nStart := 1
Local cTime := ''
Local nMarca := 0
Local nIx	 := 0
//cCalend := Bin2Str(cAloc)
cCalend := upper(cAloc)

For nDias := 1 to 7

	nStart := 1
	
	nPos := 0
	
	nIx	:= 0
		
	AADD(aRet,Substr(cCalend,nInicio,nTamDia))
		
	cPeriodo := Substr(cCalend,nInicio,nTamDia)
	
	If !Empty(cPeriodo)
		
		For nIx := 1 to Len( cPeriodo )
			
			//IF substr( cPeriodo,nIx,1) == 'x'
			IF substr( cPeriodo,nIx,1) == 'X'
			
				nPos := nIx
			
				aAdd(aHora,{nDias, nPos-1})
			  		
			End If
	
		Next nIx
		
	End If
				
	nInicio+=nTamDia
		
Next nDias

RETURN (aHora)

User Function CSREPAW()

Return (cHora) 