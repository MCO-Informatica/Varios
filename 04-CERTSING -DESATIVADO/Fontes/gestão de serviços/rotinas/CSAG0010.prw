#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ESTILOS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSAG0010   บAutor Claudio H. Corr๊a    บ Data ณ  08/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAgendamento Externo                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ3
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CERTISIGN                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSAG0010(cOs , aModel, cRegiao, cAr)

Local lFim := .F.
Local aParamBox := {}
Local bAction  		:= {||}
Local bWhen	   		:= {||}
Local aRet			:= {}
Local aOk			:= {}

Static dDataAbr
Static cCodAr		:= ""
Static cRegDes		:= ""
Static lRet			:= .F.
Static nProdut		:= 0
Static lPag			:= .T.
Static cHora		:= ""
 
Private dBaseAge 	:= dDataBase
Private cOrdem 		:= cOs
Private dDataAber	:= dDataBase
Private cCoord    	:= "005,003,003,020,030,025,016,176,310"
Private aObjects	:= {}
Private aX			:= {}
Private cHoraInici	:= ""
Private cHoraFinal	:= ""

While .NOT. lFim

	cRegDes		:= cRegiao
	
	cCodAr		:= cAr
 
	Processa( {|| lRet := U_CSAGCOMP(@lFim) }, "Aguarde...", "Carregando defini็ใo de agendas...",.T.)
	
End

aOk := {lRet, cHora}

Return(aOk)

User Function CSAGCOMP(lFim)

Local nHeight		:= oMainWnd:nClientHeight * .90
Local nWidth		:= oMainWnd:nClientWidth * .78
Local nDiaHei		:= oMainWnd:nClientHeight * .93
Local nDiaWid		:= oMainWnd:nClientWidth * .97

Local nDiaIni		:= Dow(Stod(SubStr(Dtos(dBaseAge),1,6)+"01"))
Local dDataIni		:= dBaseAge-Day(dBaseAge)-nDiaIni+2
Local dDataFin		:= dDataIni-1

Local nEHei			:= 3		// Espaco Horizontal entre as celulas
Local nEWid			:= 4		// Espaco Vertical entres as celulas
Local nRow			:= 020		// Linha onde comeca a tabela
Local nCol			:= 005		// Coluna onde comeca a tabela
//							Total da tela       Margens laerais		Entre celulas       Qtd Celulas
Local nHei			:= (	(nHeight/2)			-(nRow+5)			-(nEHei*5)	)		/ 6
Local nWid			:= (	(nWidth/2)			-(nCol+10)			-(nEWid*5)	)		/ 7

Local aMeses		:= {}
Local lNoMes		:= .T.
Local nDiaProxMes	:= 0
Local nI			:= 0
Local aHoraDisp 	:= {}
Local w				:= 0

Private oFont1			:= TFont():New('Courier new',,-12,.T., .T.)
Private oFont2			:= TFont():New('Courier new',,-12,.T., .F.)
Private oFont			:= NIL
Private oFWLayer		:= NIL
Private oPanelRht		:= NIL
Private oPanelLft		:= NIL
Private oDlg			:= NIL
Private oFonte			:= NIL

DEFINE FONT oFonte NAME "Courier New" SIZE 0,22 BOLD

lFim := .T.		// Controla o loop da tela para troca de meses da agenda

lRet := .F.

Aadd( aMeses, { "Janeiro", 31 } )
Aadd( aMeses, { "Fevereiro", 28+IIF(Year(dBaseAge)%4==0,1,0) } )
Aadd( aMeses, { "Mar็o", 31 } )
Aadd( aMeses, { "Abril", 30 } )
Aadd( aMeses, { "Maio", 31 } )
Aadd( aMeses, { "Junho", 30 } )
Aadd( aMeses, { "Julho", 31 } )
Aadd( aMeses, { "Agosto", 31 } )
Aadd( aMeses, { "Setembro", 30 } )
Aadd( aMeses, { "Outubro", 31 } )
Aadd( aMeses, { "Novembro", 30 } )
Aadd( aMeses, { "Dezembro", 31 } )

DEFINE DIALOG oDlg TITLE "Agendamento Externas" FROM 000,000 TO nDiaHei,nDiaWid PIXEL

oFWLayer := FWLayer():New()
oFWLayer:Init( oDlg, .F., .T. )

oFWLayer:AddLine( 'PAINEL', 100, .F. ) 
oFWLayer:AddCollumn( 'LEFT', 80, .T., 'PAINEL' )
oFWLayer:AddCollumn( 'RIGHT', 20, .T., 'PAINEL')

oPanelRht := oFWLayer:GetColPanel( 'RIGHT', 'PAINEL' )
oPanelLft := oFWLayer:GetColPanel( 'LEFT', 'PAINEL' )

TButton():New( 005, 005, "<<", oPanelLft, { || (CSAGMES("<<"),lFim:=.F.,oDlg:End()) }, 20, 10, , oFonte,.F., .T., .F., , .F., , , .F. )
TButton():New( 005, 035, ">>", oPanelLft, { || (CSAGMES(">>"),lFim:=.F.,oDlg:End()) }, 20, 10, , oFonte,.F., .T., .F., , .F., , , .F. )
@ 005, 065 SAY Upper(aMeses[Month(dBaseAge)][1]) + " DE " + StrZero(Year(dBaseAge),4) OF oPanelLft PIXEL FONT oFonte COLOR CLR_HRED

@ 005, 170 SAY "AR: " OF oPanelLft PIXEL FONT oFont2
@ 005, 180 SAY cCodAr + " - " OF oPanelLft PIXEL FONT oFont2 
@ 005, 215 SAY POSICIONE("SZ3", 1, xFilial("SZ3")+cCodAr, "Z3_DESENT") OF oPanelLft PIXEL FONT oFont2

TButton():New( 005, (nWidth/2)-050, "Fechar", oPanelLft, { ||(lRet := .F., oDlg:End()) }, 40, 10, , ,.F., .T., .F., , .F., , , .F. )

// #translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )
For nI := 1 To 42
	Aadd( aObjects, { CtoD("//"), {"",""}, {"",""}, {""} } )
	
	dDataFin++
	aObjects[nI][1] := dDataFin
	If dDataFin >= StoD( StrZero(Year(dBaseAge),4) + StrZero(Month(dBaseAge),2) + "01" ) .AND. dDataFin <= StoD( StrZero(Year(dBaseAge),4) + StrZero(Month(dBaseAge),2) + StrZero(aMeses[Month(dBaseAge)][2],2) )
		lNoMes := .T.
	Else
		lNoMes := .F.
	Endif

	aObjects[nI][2][1] := StrZero(Day(dDataFin),2)+", " + SubStr(aMeses[Month(dDataFin)][1],1,3)+", " + StrZero(Year(dDataFin),4)
	IIF(lNoMes,IIF(aObjects[nI][1] >= (dDataBase + 2),oFont := oFont1,oFont := oFont2),".F.")
	aObjects[nI][4][1] := cCodAr
	aObjects[nI][2][2] := TButton():New( nRow, nCol, aObjects[nI][2][1], oPanelLft,, nWid+2, 08, ,oFont ,.F., .T., .F., , .F., , , .F. )
	aObjects[nI][2][2]:bWhen	:= &("{ || " + IIF(lNoMes,IIF(aObjects[nI][1] >= (dDataBase + 2),".T.",".F."),".F.") + " }")
	aObjects[nI][2][2]:bAction	:= &('{||IIF(lRet := CSAGMONTA(aObjects[' + Str(nI) + '][1], aObjects[' + Str(nI) + '][4][1]), oDlg:End(), lRet := .F.)}')
		
	@ nRow+8,nCol TO nRow+nHei+1,nCol+nWid+2 PIXEL OF oPanelLft
	
	While !Empty(cCoord)
	   aAdd(aX,Val(SubStr(cCoord,1,3)))
	   cCoord := SubStr(cCoord,5)
	End
	
	aHoraDisp := {}
	
	dDataAg := CriaVar("PA0_DTAGEN")
	
	dDataAg := aObjects[nI][1]
	
	aHoraDisp := U_CSAGHORA(dDataAg, cCodAr)
	
	cHoraBo := ""
	nContador := 0
	
	For w := 1 to Len (aHoraDisp)

		If nContador > 2
			
			cHoraBo += aHoraDisp[w][1]+", "+CRLF
			
			nContador := 0
		
		Else
		
			cHoraBo += aHoraDisp[w][1]+", "
			
			nContador++
			
		End If

	Next w
	
	aObjects[nI][3][1] := cHoraBo
	aObjects[nI][3][2] := TPanel():New( nRow+9, nCol+1, aObjects[nI][3][1], oPanelLft,,.F.,,IIF(lNoMes.AND.Str(Dow(aObjects[nI][1]),1)$"1",CLR_HRED,CLR_BLACK),IIF(lNoMes,IIF(Str(Dow(aObjects[nI][1]),1)$"1,7",RGB(200,200,255),RGB(240,240,255)),RGB(200,200,200)),nWid,(nRow+nHei+1)-(nRow+8)-2,.T.,.T.)
	
	If (nI%7)==0
		nRow += nHei + nEHei
		nCol := 005
	Else
		nCol += nWid + nEWid
	Endif

Next nI     

ACTIVATE DIALOG oDlg 

Return(lRet)

Static Function CSAGMES(cTipo)

Do Case
	Case cTipo == ">>"
		If Month(dBaseAge) < 12
			dBaseAge := StoD( SubStr(DtoS(dBaseAge),1,4) + StrZero(Val(SubStr(DtoS(dBaseAge),5,2))+1,2) + "15" )
		Else
			dBaseAge := StoD( StrZero(Val(SubStr(DtoS(dBaseAge),1,4))+1,4) + "01" + "15" )
		Endif
	Case cTipo == "<<"
		If Month(dBaseAge) > 1
			dBaseAge := StoD( SubStr(DtoS(dBaseAge),1,4) + StrZero(Val(SubStr(DtoS(dBaseAge),5,2))-1,2) + "15" )
		Else
			dBaseAge := StoD( StrZero(Val(SubStr(DtoS(dBaseAge),1,4))-1,4) + "12" + "15" )
		Endif
Endcase

Return(.T.)

/*
Static Function CSAGSIMULT(cCodAr, dData)

Local nQtdSim := 0

dbSelectArea("PAY")
dbSetOrder(1)
dbSeek(xFilial("PAY")+cCodAr)

If Found()

	While !EOF() .and. PAY->PAY_DATA == dData
	
		nQtdSim++
	
  		PAY->(dbSkip())
	End Do
	
	

End If

Return nQtdSim
*/
Static Function CSAGMONTA(dData, cCodAr)

Local cSimult 		:=	""
Local nDias			:=	0
Local nInicio		:=	1
Local nPrecisa		:=	GETNEWPAR("MV_PRECISA",2)
Local nTamDia		:=	1440/(60/nPrecisa)
Local aHora			:=	{}
Local aInte			:=	{}
Local nSemana		:=	0
Local nDiaSemana	:=	0
Local cMinutos		:=	""
Local cHorasFim		:=	""
Local nPosIni		:=	0
Local aBotao		:=	{}
Local oWindow		:=	NIL
Local oBotao		:= 	NIL
Local oScroll		:=	NIL
Local aBotaoFim		:= {}
Local cQRYPAW		:= ""	
Local cBotao		:= ""
Local oTFolder		:= NIL
Local aTFolder		:= {}
Local nCont			:= 0
dDataAbr := dData

aBotao := U_CSAGHORA(dData,cCodAr)

nLin := 5

If oTFolder <> NIL

	oTFolder:Destroy()
	
End If

aTFolder := { 'Horarios Disponiveis' }
oTFolder := TFolder():New( 005,005,aTFolder,,oPanelRht,,,,.T.,,120,255 )

For nCont := 1 To Len(aBotao)

	oBotao := TButton():New( nLin, 005, "Agenda Disponivel: "+aBotao[nCont][1], oTFolder:aDialogs[1],, 110, 15, , ,.F., .T., .F., , .F., , , .F. )
	oBotao:bAction	:= &('{|| IIF(lRet := U_CSAG0019(aBotao['+ Str(nCont) +'][1],dData,cCodAr,cOrdem),IIF(CSAGSALVA(),oDlg:End(),.F.),.F.)}')
	
	nLin := nLin + 17

Next nCont

Return lRet

User Function CSAG0019(cHoraAgenda,dData,cCodAr,cOrdem)

Local aHoras 	:= {}
Local aHoraDia	:= {}
Local nPos		:= 0
Local cAtSimul	:= ""
Local cAloc		:= ""
Local cPeriodo	:= ""
Local cCalend	:= ""
Local nDias		:= 0
Local nIx		:= 0
Local cDia		:= ""
Local nInicio	:= 1
Local nPrecisa	:= GETNEWPAR("MV_PRECISA", 1)
Local nTamDia	:= 1440/(60/nPrecisa)
Local nSemana	:= 0
Local nDiaSemana:= 0
Local nPosIni	:= 0
Local cHoras	:= ""
Local cMinutos	:= ""
Local cHorasFim	:= ""
Local cDesloc	:= ""
Local cHoraAge	:= ""
Local nPosHora	:= 0
Local cHoraDisp	:= ""
Local nHoraDisp	:= 0
Local nMinDisp	:= 0
Local aHoraDisp	:= {}
Local cHora1	:= ""
Local cHora2	:= ""
Local cHora3	:= ""
Local cHora4	:= ""
Local nHora1	:= 0
Local nHora2	:= 0
Local nHora3	:= 0
Local nHora4	:= 0
Local nMin1		:= 0
Local nMin2		:= 0
Local nMin3		:= 0
Local nMin4		:= 0
Local nTotal	:= 0
Local cString 	:= ""
Local aPeriodo	:= {}
Local nValIni	:= 0
Local nValFim	:= 0
Local nExcecao	:= 0
Local nIx		:= 0
Local nCont		:= 0
lPag := .T.
nProdut := 0

cHora := cHoraAgenda

//Monta horarios de Intervalos com base no calendarios padrใo
DbSelectArea("PAV")
DbSetOrder(1)
DbSeek(xFilial("PAV")+cCodAr)

If PAV->(Found())

	dbSelectArea("PAY")
	dbSetOrder(1)
	dbSeek(xFilial("PAY")+cCodAr)
	
	If PAY->(Found())
	
		While PAY->(!EOF()) .AND. ALLTRIM(PAY->PAY_AR)==ALLTRIM(cCodAr)
		
			If PAY->PAY_DATA == dData
		
				nExcecao := PAY->PAY_QTDATE + nExcecao
				
			End If
			
			PAY->(dbSkip())
			
		End 
		
		cAtSimul := Str(Val(PAV->PAV_SIMULT) + nExcecao)
	
	Else
		
		cAtSimul := PAV->PAV_SIMULT
	
	End If
	
	cDia := PAV->PAV_ALOC
	
	DbSelectArea("SH7")
	DbSetOrder(1)
	DbSeek(xFilial("SH7")+cDia)

	If SH7->(Found())
	
		lPAV := .T.
		
		cAloc := SH7->H7_ALOC
		
		//cCalend := Bin2Str(cAloc)
		cCalend := UPPER(cAloc)

		For nDias := 1 to 7
	
			nPos := 0
	
			nIx	:= 0
		
			cPeriodo := Substr(cCalend,nInicio,nTamDia)
	
			If !Empty(cPeriodo)
		
				For nIx := 1 to Len( cPeriodo )
					
					//IF substr( cPeriodo,nIx,1) == 'x'
					IF UPPER(substr( cPeriodo,nIx,1)) == 'X'
			
						nPos := nIx
			
						aAdd(aHoras,{nDias, nPos-1})
						
						Exit
						
					End If
					
				Next nIx
					
				For nIx := nIx To Len( cPeriodo )
					
					IF substr( cPeriodo,nIx,1) == " "
						
						nPos := nIx
			
						aAdd(aHoras,{nDias, nPos-1})
						
						Exit
					
					End If
					
				Next nIx			
							
				For nIx := nIx To Len( cPeriodo )
							
					//IF substr( cPeriodo,nIx,1) == 'x'
					IF UPPER(substr(cPeriodo,nIx,1)) == 'X'
			
						nPos := nIx
			
						aAdd(aHoras,{nDias, nPos-1})
						
						Exit	
						
					End If
					
				Next nIx				
									
				For nIx := nIx To Len( cPeriodo )
					
					IF substr( cPeriodo,nIx,1) == " "
						
						nPos := nIx
			
						aAdd(aHoras,{nDias, nPos-1})
						
						Exit
						
					End If
					
				Next nIx
			
			End If
				
			nInicio+=nTamDia
		
		Next nDias
		
	End If
	
End If

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

cHoraAge += dtoc(dData)

aHorarios := {}

For nCont := 1 To Len(aHoras)
	
	nDiaSemana := aHoras[nCont][1]
		
	If nDiaSemana == nSemana
	
		nDiaSemana := aHoras[nCont][1]
		nPosIni := aHoras[nCont][2]
		
		
		cHoras := StrZero(Int(nPosIni/nPrecisa), 2)
		cMinutos := StrZero((60/nPrecisa) * (((nPosIni/nPrecisa) - Int(nPosIni / nPrecisa)) * 2) , 2)
		cHorasFim := cHoras + ":" + cMinutos
			
		cHoraAge += "," + cHorasFim	
				
	End If
	
Next nCont

aHorarios := STRTOKARR(cHoraAge,",")
		
//Horarios de Intervalos	
aAdd(aHoraDia,aHorarios)

//Monta horarios de deslocamento com base na tabela de deslocamento
DbSelectArea("PA4")
DbSetOrder(1)
DbSeek(xFilial("PA4")+cRegDes)

If PA4->(Found())

	cDesloc := PA4->PA4_DESLOC
	
	nHorasDes := Val(substr( cDesloc,1,2))*60
	nMinutosDes := Val(substr( cDesloc,4,2))
	nHorasFim := ((nHorasDes + nMinutosDes)/2)/60//Horas de deslocamento em minutos do calendario do dia e AR
	
	cHorasFim := ConvHor(nHorasFim, ":")	

Else

	lRet := .F.
	
	MsgAlert("Nใo ha regi๕es cadastradas para este Posto de Atendimento.")
	
	Return(lRet)
	
End If

aHoraDisp := U_CSAGHORA(dData, cCodAr) //Chama a fun็ใo para trazer todos os horarios disponiveis por Ar e data

//Procura por intervalos de marca็ใo disponivel

For nCont := 1 To Len(aHoraDisp)
	
	nPosHora := aScan(aHoraDisp[nCont], cHora)
	
	If nPosHora > 0
		
		cHoraDisp := aHoraDisp[nCont][nPosHora]
		
	End If
	
Next nCont

If cHoraDisp == ""

	lRet := .F.
			
	MsgAlert("O horario escolhido nใo esta disponivel")
			
	Return(lRet)
	
End If

cHora1 := aHoraDia[1][2]
cHora2 := aHoraDia[1][3]
cHora3 := aHoraDia[1][4]
cHora4 := aHoraDia[1][5]
	
nHora1 := Val(SubStr(cHora1,1,2))
nMin1 := Val(SubStr(cHora1,4,2))
nHora2 := Val(SubStr(cHora2,1,2))
nMin2 := Val(SubStr(cHora2,4,2))
nHora3 := Val(SubStr(cHora3,1,2))
nMin3 := Val(SubStr(cHora3,4,2))
nHora4 := Val(SubStr(cHora4,1,2))
nMin4 := Val(SubStr(cHora4,4,2))

//Valida se o Horario esta contido no periodo util do dia
If Val(Subs(SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),1,2) +":"+ SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),4,2),1, 2)) >= nHora1 .Or.; 
	Val(Subs(SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),1,2)+":"+SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),4,2),4, 2)) >= nMin1
	
	If Val(Subs(SubStr(Str(SomaHoras(cHoraDisp, cHorasFim),5,2),1,2) +":"+ SubStr(Str(SomaHoras(cHoraDisp, cHorasFim),5,2),4,2),1, 2)) <= nHora4 .Or.; 
		Val(Subs(SubStr(Str(SomaHoras(cHoraDisp, cHorasFim),5,2),1,2)+":"+SubStr(Str(SomaHoras(cHoraDisp, cHorasFim),5,2),4,2),4, 2)) <= nMin4
		
		nHoraDisp := (Val(SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),1,2))*60) + Val(SubStr(Str(SubHoras(cHoraDisp, cHorasFim),5,2),4,2))
		
		nHoraPer1 := ((nHora1*60)+nMin1) - 60 //DETERMINA O TEMPO INICIAL DO PERIODO COM A TOLERANCIA DE INICIO
		
		nHoraPer2 := (nHora2*60)+nMin2
		
		nHoraPer3 := (nHora3*60)+nMin3
		
		nHoraPer4 := (nhora4*60)+nMin4
		
		For nCont := nHoraPer1 To nHoraPer2
		
			If nCont == nHoraDisp
			
				lRet := .T.
				
				Exit
			
			End If
		
		Next nCont
		
		For nCont := nHoraPer3 To nHoraPer4
		
			If nCont == nHoraDisp
				
				lRet := .T.
				
				Exit
			
			End If
		
		Next nCont
		
		//Verifica a quantidade de produtos e multiplica pelo tempo de execu็ใo padrใo de um atendimento (60/nPrecisa)
		For nCont := 1 To Len(aModel)
		
			If aModel[nCont][1][1][12] $ "N|C"	
			
				lPag := .F.
				
			End If

			If aModel[nCont][1][1][12] == "F"
			
				// Somente multiplica a quantidade de produtos que iniciam com CC ( Certificados )
				If "CC" $ aModel[nCont][1][1][4] .Or. "KT" $ aModel[nCont][1][1][4] .Or. "VS" $ aModel[nCont][1][1][4] .Or. "MR" $ aModel[nCont][1][1][4]
	
					nProdut++
					
				End If
		
			End If

		Next nCont

		If nProdut > 0
		
			If nProdut >= 10
			
				lRet := .T.
				
				cHoraInici := ConvHor((nHoraPer1/60), ":")
				cHoraFinal := ConvHor((nHoraPer4/60), ":")
				
				Return(lRet)
				
			Else
		
				//Transforma tudo em numero e soma o valor de deslocamento e o tempo de execu็ใo de cada produto
				nTotal := ((Val(SubStr(cHoraDisp,1,2))*60) + Val(SubStr(cHoraDisp,4,2))) + (nProdut * (60/nPrecisa)) + (nHorasFim * 60)
				
				//Verifica se o Horario final de atendimento cai no intervalo de almo็o e ou excede o horario final do dia
				For nCont := nHoraPer1 To nHoraPer3
			
					If nCont == nTotal
					
						lRet := .T.
							
						Exit 
				
					End If
			
				Next nCont
				
				For nCont := nHoraPer2 To nHoraPer3
			
					If nCont == nTotal
					
						If lRet := MSGYESNO( "O horario selecionado ira ultrapassar o horario de intervalo, deseja proceguir?", "Agendamento" )
						
							nResto := nTotal - nHoraPer2
							
							nTotal := nResto + nHoraPer3
							
							Exit 
						
						End If
				
					End If
			
				Next nCont
				
				For nCont := nHoraPer3 To nHoraPer4
			
					If nCont == nTotal
					
						lRet := .T.
							
						Exit 
				
					End If
			
				Next nCont
				
				If nTotal > nHoraPer4
					
					lRet := .F.
		
					MsgAlert("Nใo ้ possivel o agendamento pois o horario escolhido + o deslocamento ้ maior que horario de fechamento do Posto de Atendimento")
				
				End If
				
				cHoraInici := ConvHor((nHoraDisp/60), ":")
				cHoraFinal := ConvHor((nTotal/60), ":")
				
			End If

		End If 
		
	End If

Else

	lRet := .F.
	
	MsgAlert("Nใo ้ possivel o agendamento pois o horario escolhido + o deslocamento sใo menores que horario de fechamento do Posto de Atendimento")
     
    Return lRet

End If

If lRet == .T.

	cHoraInter := ""

	For nCont := nHoraDisp To nTotal
	
		cHoraInter := ConvHor((nCont/60), ":")
	
		If Select("_PAW") > 0
			DbSelectArea("_PAW")
			DbCloseArea("_PAW")
		End If
				
		cQRYPAW := " SELECT COUNT(PAW_HORINI) as HORA "
		cQRYPAW += " FROM "+ RETSQLNAME("PAW")
		cQRYPAW += " WHERE D_E_L_E_T_ = '' "
		cQRYPAW += " AND PAW_FILIAL = '"+ xFILIAL("PAW") + "'"
		cQRYPAW += " AND PAW_AR = '"+ cCodAr + "'"
		cQRYPAW += " AND (PAW_STATUS = 'P' "
		cQRYPAW += " OR PAW_STATUS = 'C' "
		cQRYPAW += " OR PAW_STATUS = 'L') "
		cQRYPAW += " AND PAW_DATA = '" + dtos(dData) + "'"
		cQRYPAW += " AND PAW_HORINI <= '" + cHoraInter + "'"
		cQRYPAW += " AND PAW_HORFIM >= '" + cHoraInter + "'"
		
		cQRYPAW := changequery(cQRYPAW)
					
		dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQRYPAW),"_PAW", .F., .T.)
		
		nValIni := _PAW->HORA
	
		If nValIni >= Val(cAtSimul)
		
			MsgAlert("Nใo ้ possivel realizar o agendamento para o horario selecionado, pois o horario necessario para o atendimento excede a disponibilidade tecnica para este dia." )
		
			lRet := .F.
			
			Exit		
	
		End If
	
	Next nCont
		
End If	

Return lRet

Static Function ConvHor(nValor, cSepar)
 
Local cHora := ""
Local cMinutos := ""
Default cSepar := ":"
Default nValor := -1
     
//Se for valores negativos, retorna a hora atual
If nValor < 0

	cHora := SubStr(Time(), 1, 5)
    cHora := StrTran(cHora, ':', cSepar)
         
//Senใo, transforma o valor num้rico
Else

	cHora := Alltrim(Transform(nValor, "@E 99.99"))
         
    //Se o tamanho da hora for menor que 5, adiciona zeros a esquerda
    If Len(cHora) < 5
    
    	cHora := Replicate('0', 5-Len(cHora)) + cHora
        
    EndIf
         
    //Fazendo tratamento para minutos
    cMinutos := SubStr(cHora, At(',', cHora)+1, 2)
    cMinutos := StrZero((Val(cMinutos)*60)/100, 2)
         
    //Atualiza a hora com os novos minutos
    cHora := SubStr(cHora, 1, At(',', cHora))+cMinutos
         
        //Atualizando o separador
    cHora := StrTran(cHora, ',', cSepar)
    
EndIf

Return cHora

Static Function CSAGSALVA()

dbSelectArea("PA1") // Posiciona no registro da PA1 para verificar o tipo de Faturamento para esta OS
dbSetOrder(1)
dbSeek(xFilial("PA1")+cOrdem)

BEGIN TRANSACTION                         
			
	RecLock("PAW",.T.)
	PAW->PAW_FILIAL:= xFilial("PAW")
	PAW->PAW_COD := GetSxeNum("PAW", "PAW_COD")
	PAW->PAW_AR := cCodAr
	PAW->PAW_DATA := dDataAbr
	PAW->PAW_HORINI := cHoraInici
	PAW->PAW_HORFIM := cHoraFinal
	PAW->PAW_OS		:= cOrdem
	If PA1->PA1_FATURA == "P" // Valida o tipo de faturamento, pois apesar de lPag estar True ele nใo fica aguardando pagamento por se tratar de uma OS Postecipada ( Pagamento Posterior )
	
		PAW->PAW_STATUS	:= "L"
		
	Else 
	
		PAW->PAW_STATUS	:= IIF(lPag == .T., "P", "L")
		
	End If
	
	MsUnlock()
				
END TRANSACTION	
					  	
ConfirmSX8()
			
lRet := .T.

Return lRet