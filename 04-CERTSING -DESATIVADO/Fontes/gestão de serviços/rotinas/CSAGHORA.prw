#include 'protheus.ch'
#include 'parmtype.ch'

User Function CSAGHORA(dDataAg, cCodAr)

Local aBotao	:= {}
Local nCont		:= 0
Local lPAV		:= .F.
Local aDiaSem	:= {"Segunda-Feira","Terça-Feira","Quarta-Feira","Quinta-Feira","Sexta-Feira","Sabado","Domingo"}
Local nPosIni	:= 0
Local aPAW		:= {}
Local lRet		:= .F.
Local nPrecisa	:= GETNEWPAR("MV_PRECISA", 1)
Local nDias		:= 0
Local cCalend	:= ""
Local nInicio	:= 1
Local nTamDia	:= 1440/(60/nPrecisa)
Local cMinutos	:= ""
Local nMarca	:= 0
Local nX		:= 0
Local aHora		:= {}
Local aDispo	:= {}
Local nExcecao	:= 0
Local nDias		:= 0
Local nIx		:= 0

DbSelectArea("PAV")
DbSetOrder(1)
DbSeek(xFilial("PAV")+cCodAr)

If PAV->(Found())

	dbSelectArea("PAY")
	dbSetOrder(1)
	dbSeek(xFilial("PAY")+cCodAr)
	
	If PAY->(Found())
	
		While PAY->(!EOF()) .AND. alltrim(PAY->PAY_AR)==ALLTRIM(cCodAr)
		
			If PAY->PAY_DATA == dDataAg
		
				nExcecao := PAY->PAY_QTDATE + nExcecao
				
			End If
			
			PAY->(dbSkip())
			
		End 
		
		cAtSimul := Str(Val(PAV->PAV_SIMULT) + nExcecao)
	
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

	//cCalend := Bin2Str(cAloc)
	cCalend := upper(cAloc)

	For nDias := 1 to 7
	
		nPos := 0
	
		nIx	:= 0
		
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

	dData := dDataAg
	
	nSemana := Dow(dDataAg)
	
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
	
	For nCont := 1 To Len(aHora)
	
		nDiaSemana := aHora[nCont][1]
		nPosIni := aHora[nCont][2]
		
		If nDiaSemana == nSemana
		
			cHoras := StrZero(Int(nPosIni/nPrecisa), 2)
			cMinutos := StrZero((60/nPrecisa) * (((nPosIni/nPrecisa) - Int(nPosIni / nPrecisa)) * 2) , 2)
			cHorasFim := cHoras + ":" + cMinutos
			
			aAdd(aBotao,{cHorasFim, dtoc(dData)})
				
		End If
	
	Next nCont
	
	If ISINCALLSTACK("U_CSAGAGEN")
	
		If !Empty(aBotao)
			
			nPos := 0
				
			For nCont := 1 To Len(aBotao) 
					
				cBotao := aBotao[nCont][1]
										
				aAdd(aDispo,{aBotao[nCont][1], aBotao[nCont][2]})
						
			Next nCont
				
		End If
		
	Else
	
		For nCont := 1 To Len(aBotao) 
				
			cBotao := aBotao[nCont][1]
			
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
			cQRYPAW += " AND PAW_HORINI <= '" + cBotao + "'"
			cQRYPAW += " AND PAW_HORFIM >= '" + cBotao + "'"
	
			cQRYPAW := changequery(cQRYPAW)
				
			dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQRYPAW),"_PAW", .F., .T.)
				
			IF _PAW->HORA < val(cAtSimul)	 
								
				aAdd(aDispo,{aBotao[nCont][1], aBotao[nCont][2]})
						      
			End If
					
		Next nCont
		
	End If
	
End If

RETURN (aDispo)