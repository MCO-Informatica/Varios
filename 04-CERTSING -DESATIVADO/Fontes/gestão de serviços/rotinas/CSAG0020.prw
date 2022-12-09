#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function CSAG0020(oBrowse)
	
Local aCoors := FWGetDialogSize( oMainWnd )
Local oPanel := NIL 
Local oFWLayer := NIL
Local oDlg := NIL

Private oBrowse := NIL
Private aRotina := MenuDef()
   
/*
 aSize[1] = 1 -> Linha inicial área trabalho.
 aSize[2] = 2 -> Coluna inicial área trabalho.
 aSize[3] = 3 -> Linha final área trabalho.
 aSize[4] = 4 -> Coluna final área trabalho.
 aSize[5] = 5 -> Coluna final dialog (janela).
 aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).
 */
Private aSize		:= MsAdvSize(.f.)
Private lFoiAlterado:= .F.

Private oFont1 := TFont():New( "Arial",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
Private oFont2 := TFont():New( "Arial",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
Private oFont3 := TFont():New( "Arial",0,-11,,.T.,0,,400,.F.,.F.,,,,,, )

DEFINE MSDIALOG oDlg Title "Agendamento Tecnico"  From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd COLOR CLR_BLACK,CLR_WHITE Pixel

oFWLayer := FWLayer():New()
oFWLayer:Init( oDlg, .F., .T. )

oFWLayer:AddLine( 'UP', 90, .F. ) 
oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )

oPanel := oFWLayer:GetColPanel( 'ALL', 'UP' )

oBrowse:= FWmBrowse():New()
oBrowse:SetOwner( oPanel )
oBrowse:DisableDetails()
oBrowse:SetDescription( 'Agendamento Tecnico' )
oBrowse:SetAlias( 'PAW' )
oBrowse:SetProfileID( '1' )
oBrowse:SetExecuteDef( 7 )
oBrowse:ForceQuitButton()

oBrowse:Activate()

Activate MsDialog oDlg 

oWindow := GetWndDefault()
AEval(oWindow:aControls, {|e| Iif(ValType(e) == "O", e:Refresh(), NIL) } )                   
	
Return

Static Function MenuDef() // Criação do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 		ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   	ACTION "VIEWDEF.CSAG0020"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"			ACTION "VIEWDEF.CSAG0020"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"			ACTION "VIEWDEF.CSAG0020"			OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluir"			ACTION "VIEWDEF.CSAG0020"			OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Copiar"			ACTION "VIEWDEF.CSAG0020"			OPERATION 6 ACCESS 0

Return aRotina

Static Function ModelDef()

Local oStruPAW := FWFormStruct(1,'PAW')
Local oStruPA2 := FWFormStruct(1,'PA2')
Local oModel

oModel := MPFormModel():New('CSAGPAW',,,{ |oModel| CSAGVALID( oModel ) })

oModel:AddFields('PAWMASTER',/*cOwner*/,oStruPAW)
oModel:AddGrid('PA2DETAIL','PAWMASTER',oStruPA2)

oModel:SetPrimaryKey({'PAW_FILIAL','PAW_COD'})

oModel:SetRelation('PA2DETAIL',{ { 'PA2_FILIAL', 'xFilial("PA2")'},;
								 { 'PA2_CODAGE', 'PAW_COD' } }, PA2->( IndexKey( 1 )))								 

oModel:SetDescription('Agendamento Tecnico')

oModel:GetModel( 'PA2DETAIL' ):SetOptional( .T. )

oModel:GetModel( 'PA2DETAIL' ):SetMaxLine( 10 )

oModel:GetModel('PAWMASTER'):SetDescription('Cabeçalho Agendamento Tecnico')

oModel:GetModel('PA2DETAIL'):SetDescription('Detalhes Agendamento Tecnico')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0020')
Local oStruPAW:= FWFormStruct(2,'PAW')
Local oStruPA2:= FWFormStruct(2,'PA2')
Local oViewDef:= FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PAW',oStruPAW,'PAWMASTER')

oViewDef:AddGrid('VIEW_PA2',oStruPA2,'PA2DETAIL')

oViewDef:CreateHorixontalBox('UP',50)

oViewDef:CreateHorixontalBox('DN',50)

oViewDef:SetOwnerView('VIEW_PAW','UP')

oViewDef:SetOwnerView('VIEW_PA2','DN')

Return oViewDef

Static Function CSAGVALID(oModel)

Local aModelo	:= {}
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
Local nPrecisa	:= GETNEWPAR("MV_PRECISA", 2)
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
Local cHora := ""
Local dData := CRIAVAR("PAW_DATA")
Local cCodAr := ""
Local cOrdem := ""
Local cRegDes := ""
Local nExcecao := 0
Local aModel := {}
local lRet		:= .F.
Local nCont		:= 0
Local n			:= 0

aModelo := oModel

cHora 	:= aModelo:AALLSUBMODELS[1]:ADATAMODEL[1][5][2]
dData 	:= aModelo:AALLSUBMODELS[1]:ADATAMODEL[1][4][2]
cCodAr 	:= aModelo:AALLSUBMODELS[1]:ADATAMODEL[1][3][2]
cOrdem	:= aModelo:AALLSUBMODELS[1]:ADATAMODEL[1][7][2]

If dData >= dDataBase .Or. (dData >= dDataBase .And. cHora >= Time())

	//Monta horarios de Intervalos com base no calendarios padrão
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
			cCalend := upper(cAloc)
		
			For nDias := 1 to 7
			
				nPos := 0
			
				nIx	:= 0
			
				cPeriodo := Substr(cCalend,nInicio,nTamDia)
			
				If !Empty(cPeriodo)
			
					For nIx := 1 to Len( cPeriodo )
						
						IF substr( cPeriodo,nIx,1) == 'X'
						//IF substr( cPeriodo,nIx,1) == 'x'
					
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
						IF substr( cPeriodo,nIx,1) == 'X'
					
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
		
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+cOrdem)
		
	cRegDes := PA0->PA0_REGIAO
	cEmail := PA0->PA0_EMAIL
		
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
			
		MsgAlert("Não ha regiões cadastradas para este Posto de Atendimento.")
		
		Return(lRet)
			
	End If
		
	aHoraDisp := U_CSAGHORA(dData, cCodAr) //Chama a função para trazer todos os horarios disponiveis por Ar e data
		
	//Procura por intervalos de marcação disponivel
		
	For nCont := 1 To Len(aHoraDisp)
			
		nPosHora := aScan(aHoraDisp[nCont], cHora)
			
		If nPosHora > 0
				
			cHoraDisp := aHoraDisp[nCont][nPosHora]
				
		End If
			
	Next nCont
		
	If cHoraDisp == ""
		
		lRet := .F.
					
		MsgAlert("O horario escolhido não esta disponivel")
					
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
			
			nHoraPer1 := ((nHora1*60)+nMin1) - 60
				
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
				
			dbSelectArea("PA1")
			dbSetOrder(1)
			dbSeek(xFilial("PA1")+cOrdem)
				
			While PA1->(!EOF()) .And. PA1->PA1_OS == cOrdem
				
				aAdd(aModel, {PA1->PA1_ITEM, PA1->PA1_FATURA,ALLTRIM(PA1->PA1_PRODUT)})
					
				dbSkip()
				
			End
			
			nProdut := 0 
				
			//Verifica a quantidade de produtos e multiplica pelo tempo de execução padrão de um atendimento (60/nPrecisa)
			For nCont := 1 To Len(aModel)
				
				If aModel[nCont][2] == "N"
					
					lPag := .F.
					
				End If
		
				If aModel[nCont][2] == "F"
			
					// Somente multiplica a quantidade de produtos que iniciam com CC ( Certificados )
					If "CC" $ aModel[nCont][3] .Or. "KT" $ aModel[nCont][3] .Or. "VS" $ aModel[nCont][3] .Or. "MR" $ aModel[nCont][3]
			
						nProdut++
						
					End If
			
				End If
		
			Next nCont
		
			If nProdut > 0
			
				nOperation := oModel:GetOperation()
				
				If nProdut >= 10 .and. nOperation <> 4
					
					lRet := .F.
						
					MsgAlert("Não é possivel realizar a alteração do horario, pois se trata de um atendimento de diaria")
						
				Else
				
					//Transforma tudo em numero e soma o valor de deslocamento
					nTotal := ((Val(SubStr(cHoraDisp,1,2))*60) + Val(SubStr(cHoraDisp,4,2))) + (nProdut * (60/nPrecisa)) + (nHorasFim * 60)
					
					//Verifica se o Horario final de atendimento cai no intervalo de almoço e ou excede o horario final do dia
					For nCont := nHoraPer1 To nHoraPer3
					
						If nCont == nTotal
							
							lRet := .T.
									
							Exit 
						
						End If
					
					Next nCont
						
					For nCont := nHoraPer2 To nHoraPer3
					
						If nCont == nTotal
							
							lRet := .T.
								
							nResto := nTotal - nHoraPer2
								
							nTotal := nResto + nHoraPer3
							
							Exit 
						
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
				
						MsgAlert("Não é possivel o agendamento pois o horario escolhido + o deslocamento é maior que horario de fechamento do Posto de Atendimento")
						
					End If
						
					cHoraInici := ConvHor((nHoraDisp/60), ":")
					cHoraFinal := ConvHor((nTotal/60), ":")
						
				End If
		
			End If 
				
		End If
		
	Else
		
		lRet := .F.
			
		MsgAlert("Não é possivel o agendamento pois o horario escolhido + o deslocamento são menores que horario de fechamento do Posto de Atendimento")
		     
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
				
				MsgAlert("Não é possivel realizar o agendamento para o horario selecionado, pois o horario necessario para o atendimento excede a disponibilidade tecnica para este dia." )
				
				lRet := .F.
					
				Exit		
			
			End If
			
		Next nCont
			
		If lRet == .T.
			
			dbSelectArea("PAW")
			dbSetOrder(4)
			dbSeek(xFilial("PAW")+cOrdem)
			
			If Len(aModelo:AALLSUBMODELS[2]:ACOLS) > 0
				For n := 1 To Len(aModelo:AALLSUBMODELS[2]:ACOLS)
				
					cTecnico := aModelo:AALLSUBMODELS[2]:ACOLS[n][2]
				
					lRet := LinOk(cTecnico, nHoraDisp, nTotal, dData, PAW->PAW_COD)
					
					If lRet <> .T.
					
						Exit
						
						Return lRet
						
					End If
			
				Next n
			Endif
			
			if lRet == .T.
			
				FWFormCommit( oModel )
			
				dbSelectArea("PA2")
				dbSetOrder(1)
				dbSeek(xFilial("PA2")+PAW->PAW_COD)
					
				If PA2->(Found()) .And. Len(aModelo:AALLSUBMODELS[2]:ACOLS) > 0
					
					While PA2->(!EOF()).AND. ALLTRIM(PA2->PA2_CODAGE)==ALLTRIM(PAW->PAW_COD)
					
						For n := 1 To Len(aModelo:AALLSUBMODELS[2]:ACOLS)
					
							cTecnico := aModelo:AALLSUBMODELS[2]:ACOLS[n][2]

							If PA2->PA2_CODTEC == cTecnico
					
								BEGIN TRANSACTION                         
							
									RecLock("PA2",.F.)
									PA2->PA2_NUMOS				:= cOrdem
									PA2->PA2_DATA				:= dData
									PA2->PA2_HORINI 			:= cHoraInici
									PA2->PA2_HORFIM 			:= cHoraFinal
									PA2->PA2_HORTOT				:= SubStr(Str(SubHoras(cHoraFinal, cHoraInici),5,2),1,2) +":"+ SubStr(Str(SubHoras(cHoraFinal, cHoraInici),5,2),4,2)
									PA2->PA2_OBSERV				:= aModelo:AALLSUBMODELS[2]:ACOLS[n][9]
									MsUnlock()
			
								END TRANSACTION
								
							End If
							
						Next n
							
						PA2->(dbSkip())
							
					End
						
				End If
									
				dbSelectArea("PAW")
				dbSetOrder(4)
				dbSeek(xFilial("PAW")+cOrdem)
				
				BEGIN TRANSACTION                         
			
					RecLock("PAW",.F.)
					PAW->PAW_DATA	:= dData
					PAW->PAW_HORINI := cHoraInici
					PAW->PAW_HORFIM := cHoraFinal
					MsUnlock()
				
				END TRANSACTION
				
				dbSelectArea("PA0")
				dbSetOrder(1)
				dbSeek(xFilial("PA0")+cOrdem)
				
				BEGIN TRANSACTION                         
			
					RecLock("PA0",.F.)
					PA0->PA0_DTAGEN	:= dData
					PA0->PA0_HRAGEN := cHora
					MsUnlock()
				
				END TRANSACTION	
			
			End If
			
		End If

						
	End If
	
	cAssuntoEm := 'Validação Presencial CertiSign - Confirmação de Agente de Registro'

	cCase := "TECNICO"
	
	If !U_CSFSEmail(cOrdem, , cEmail, cAssuntoEm, cCase)
	
		MsgAlert("Não foi possivel enviar o e-mail de confirmação do agendamento tecnico, favor entrar em contato com Sistemas Corporativos!")
		
	End If
	
Else

	lRet := .F.
	
	MsgAlert("Não é possivel realizar alterações com data e hora inferior a data e hora atual")
	
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
         
//Senão, transforma o valor numérico
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

Static Function LinOk(cTecnico, nHoraIni, nHoraFim, dData, cCodPAW)

Local lRet 			:= .F.
Local nValIni 		:= 0
Local cHoraInter	:= ""
Local nCont			:= 0
For nCont := nHoraIni To nHoraFim
	
	cHoraInter := ConvHor((nCont/60), ":")
	
	If Select("_PA2") > 0
		DbSelectArea("_PA2")
		DbCloseArea("_PA2")
	End If
						
	cQRYPA2 := " SELECT COUNT(PA2_CODTEC) as TECNICO "
	cQRYPA2 += " FROM "+ RETSQLNAME("PA2")
	cQRYPA2 += " WHERE D_E_L_E_T_ = '' "
	cQRYPA2 += " AND PA2_FILIAL = '"+ xFILIAL("PAW") + "'"
	cQRYPA2 += " AND PA2_CODTEC = '" + cTecnico + "'"
	cQRYPA2 += " AND PA2_DATA = '" + dtos(dData) + "'"
	cQRYPA2 += " AND PA2_HORINI <= '" + cHoraInter + "'"
	cQRYPA2 += " AND PA2_HORFIM >= '" + cHoraInter + "'"
	cQRYPA2 += " AND PA2_CODAGE <> '" + cCodPAW + "'"
				
	cQRYPA2 := changequery(cQRYPA2)
					
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQRYPA2),"_PA2", .F., .T.)
			
	nValIni := _PA2->TECNICO
		
	If nValIni >= 1
			
		MsgAlert("Não é possivel realizar o agendamento para o horario selecionado, pois já existe atendimento para este tecnico " +Posicione("PAX",1,xFilial("PAX")+cTecnico,"PAX_NOME") + " no mesmo dia e horario." )
			
		lRet := .F.
				
		Exit		
		
	Else
		
		lRet := .T.
			
	End If
	
Next nCont
	
Return(lRet)

User Function CSAGPAW()

Local aParam := PARAMIXB
Local xRet := .T.
Local oObj := ''
Local cIdPonto := ''
Local cIdModel := ''
Local lIsGrid := .F.
Local nLinha := 0
Local nQtdLinhas := 0
Local cMsg := ''

If aParam <> NIL
	
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]

	If cIdPonto == 'FORMLINEPRE'

		If aParam[5] == 'CANSETVALUE'
		
			If oObj:OFORMMODEL:AALLSUBMODELS[1]:ADATAMODEL[1][8][2] == 'C'
			
				xRet := .T.
				
			Else
			
				MsgAlert("Não é possivel adionar ou alterar o campo tecnico desta OS, pois a mesma não se encontra liberada.")
				
				xRet := .F.
				
			End If

		EndIf

	EndIf

EndIf
		
Return xRet