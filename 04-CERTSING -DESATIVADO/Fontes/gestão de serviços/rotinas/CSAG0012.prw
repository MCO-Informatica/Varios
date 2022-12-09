#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function CSAG0012(oBrowseP)

Local aSize     := {}
Local aObjects  := {} 
Local aObjects2 := {}
Local aInfo     := {}
Local aParambox := {}
Local aRet		:= {}

Local oDlg
Local oBar
Local oBrowse
Local oCalendB3b3
Local oFont
Local oMenu 

Local aGet 		:= {{ 0 , 0 },{ 0 , 0 },{0 ,0 }}
Local aButtons := {}
Local aAgenda  := {}
Local oPanel
Local oColuna
Local oColuna1
Local oColuna2
Local nForeCor := 0
Local nBackCor := 0
Local nCol     := 0 
Local nLin     := 0
Local lOk	   := .F. 

Private cCodAr	:= "" 

If Empty(cCodAr)

	aAdd(aParamBox,{1,"Selecione AR: ",Space(6),"@!",".T.","SZ3",".T.",40,.T.})
		 
	If ParamBox(aParamBox,"Parametros",@aRet)
	   
	   cCodAr := aRet[1]
	   
	Else
	
		Return(.F.)
		
	End If
		
Endif

oFont:=TFont():New("Courier New",10,0)  

aSize    := MsAdvSize( .F. ) 

aObjects := {}           

AAdd( aObjects, { 100, 100, .t., .t., .t. } )
AAdd( aObjects, { 140,  66, .F., .T. } )

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj1 := MsObjSize( aInfo, aObjects,  , .T. ) 

aObjects := {} 
AAdd( aObjects, { 140,  66, .T., .F. } ) 
AAdd( aObjects, { 100, 100, .T., .T. } )

aSize2 := aClone( aPosObj1[2] )

aInfo    := { aSize2[ 2 ], aSize2[ 1 ], aSize2[ 4 ], aSize2[ 3 ], 3, 3, 0, 0 } 
aPosObj2 := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE "Painel Agendamentos" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

nLin := aPosObj2[2,1]
nCol := aPosObj2[2,2]

@ nLin,nCol TO aPosObj2[2,3],aPosObj2[2,4] PIXEL

@ nLin +  8,nCol + 09 SAY "Horas Alocadas no Mes" SIZE 075,008 OF oDlg PIXEL //"Horas Alocadas no Mes"
@ nLin + 18,nCol + 09 SAY "Qtd de Agendas Mês" SIZE 075,008 OF oDlg PIXEL //"Dias  Alocados no Mes" //"Numero de alocacoes / Mes"
@ nLin + 28,nCol + 09 SAY "Qtd Dias com Agendamentos / Mês"  SIZE 090,008 OF oDlg PIXEL  //"Datas alocadas / Mes"

@ nLin +  8,nCol + 100 MSGET aGet[1][1] VAR aGet[1][2] SIZE 035,008 OF oDlg PIXEL WHEN .F.
@ nLin + 18,nCol + 100 MSGET aGet[2][1] VAR aGet[2][2] SIZE 035,008 OF oDlg PIXEL WHEN .F. PICTURE "999999"
@ nLin + 28,nCol + 100 MSGET aGet[3][1] VAR aGet[3][2] SIZE 035,008 OF oDlg PIXEL WHEN .F. PICTURE "999999"

@ nLin + 58,nCol + 09 BITMAP Resource "BR_AMARELO" SIZE 012,012 OF oDlg NOBORDER PIXEL 
@ nLin + 68,nCol + 09 BITMAP Resource "BR_LARANJA" SIZE 012,012 OF oDlg NOBORDER PIXEL 
@ nLin + 78,nCol + 09 BITMAP Resource "ENABLE" SIZE 012,012 OF oDlg NOBORDER PIXEL

@ nLin + 58,nCol + 20 SAY "Aguardando Pagamento" SIZE 075,008 OF oDlg PIXEL
@ nLin + 68,nCol + 20 SAY "Aguardando Tecnico" SIZE 075,008 OF oDlg PIXEL 
@ nLin + 78,nCol + 20 SAY "Liberado Execução"  SIZE 075,008 OF oDlg PIXEL 

oBrowse := TSBrowse():New(aPosObj1[1,1] + 11,aPosObj1[1,2],aPosObj1[1,3],aPosObj1[1,4]-11,oDlg,,35,oFont,5 )

oBrowse:SetArray(aAgenda)

TButton():New( aPosObj2[2,3]-36, nCol+5, "Exceções",oDlg,{ || U_CSAG0017( @oBrowse, @oCalend )}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+5   TYPE 11 	ACTION CSAGALTERA( @oBrowse, @oCalend ) ENABLE OF oDlg 

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+40  TYPE 15 	ACTION Eval(oCalend:bLDblClick) ENABLE OF oDlg ONSTOP OemToAnsi( "Ordem de Servico" )

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+75  TYPE 4 	ACTION ( CSAGTECNICO(@oBrowse, @oCalend) ) ENABLE OF oDlg ONSTOP OemToAnsi( "Tecnicos" )

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+107 TYPE 2 	ACTION oDlg:End() ENABLE OF oDlg  

@ aPosObj1[1,1],aPosObj1[1,2] MSPANEL oPanel  PROMPT "Data Agendamento" SIZE aPosObj1[1,3],11 OF oDlg CENTERED LOWERED

nForeCor := CLR_BLACK
nBackCor := CLR_HGRAY

oColuna:= TcColumn():New(OemToAnsi("Status"),,,{|| nForeCor },{|| nBackCor })
oColuna:lNoLite := .F.
oColuna:nWidth := 22
oColuna:lBitmap := .T.
oBrowse:AddColumn(oColuna)
oBrowse:lJustific := .F.

oColuna1 := TcColumn():New(OemToAnsi("Ordem"),,,{|| nForeCor },{|| nBackCor })
oColuna1:lNoLite := .T.
oColuna1:nWidth := 25
oBrowse:AddColumn(oColuna1)
oBrowse:lJustific := .F.

oColuna2 := TcColumn():New(OemToAnsi("Data"),,,{|| CLR_BLUE },{|| CLR_WHITE})	
oColuna2:lNoLite := .T.
oColuna2:nWidth := 60
oBrowse:AddColumn(oColuna2)
oBrowse:lJustific := .F.

oColuna3 := TcColumn():New(OemToAnsi("Tecnicos"),,,{|| CLR_BLUE },{|| CLR_WHITE})
oColuna3:lNoLite := .T.
oColuna3:nWidth := 110
oBrowse:AddColumn(oColuna3)

oColuna4 := TcColumn():New(OemToAnsi("Informações"),,,{|| CLR_BLUE },{|| CLR_WHITE})
oColuna4:lNoLite := .T.
oColuna4:nWidth := 300
oBrowse:AddColumn(oColuna4)

oCalend:=MsCalend():New( aPosObj2[1,1],aPosObj2[1,2],oDlg)
oCalend:bChange := {|| CSAGMudaDia(@oBrowse,@oCalend,@oPanel) }

oCalend:bChangeMes := {|| CSAGMudaMes(@oCalend,aGet, @oBrowse) }

oCalend:bLDblClick := {||CSAGVIS( RECNO(),@oBrowse, @oCalend ) ,;
					CSAGMudaMes(@oCalend,@aGet, @oBrowse),CSAGMudaDia(@oBrowse,@oCalend,@oPanel),;
					oDlg:Refresh() }             
										
oBrowse:bLdblClick := oCalend:bLDblClick
										
ACTIVATE DIALOG oDlg ON INIT (CSAGMudaMes(@oCalend,@aGet, @oBrowse),CSAGMudaDia(@oBrowse,@oCalend,@oPanel))

oBrowseP:Refresh()                             
	
Return

Static Function CSAGMudaDia(oBrowse,oCalend,oPanel)

Local aAgenda 	:= {}
Local aHorario	:= {}
Local aDia    	:= {} 
Local dData   	:= oCalend:dDiaAtu
Local aPaw		:= {}
Local aInfo1  	:= {}
Local aInfo2  	:= {}
Local cString1	:= ""
Local cString2	:= ""
Local cString3	:= ""
Local cString4	:= ""
Local cString5	:= ""
Local cString 	:= ""
Local nAux    	:= 0  
Local nLoop   	:= 0 
Local nScan   	:= 0 
Local nDia    	:= 0 
Local aCargo  	:= {}
Local oP        := LoadBitmap(GetResources(),'BR_AMARELO')
Local oC        := LoadBitmap(GetResources(),'ENABLE')
Local oL        := LoadBitmap(GetResources(),'BR_LARANJA')
Local oLegenda	:= NIL                           

nDia := Day( dData )

If Select("_PAW") > 0
	DbSelectArea("_PAW")
	DbCloseArea("_PAW")
End If

cQryPAW := " SELECT * "
cQryPAW += " FROM "+ RetSqlName("PAW")
cQryPAW += " WHERE D_E_L_E_T_ = '' "
cQryPAW += " AND PAW_FILIAL = '" + xFilial("PAW") + "'"
cQryPAW += " AND PAW_AR = '" + cCodAr + "'"
cQryPAW += " AND PAW_DATA = '" + dTos(dData) + "'" 
cQryPAW += " AND PAW_STATUS <> 'F' "           

cQryPAW := ChangeQuery( cQryPAW )
	
dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQryPAW),"_PAW", .F., .T.)

aPaw := {}

While _PAW->(!EOF())
	
	aAdd(aPaw,      { 	_PAW->PAW_STATUS 	,;
						 	"Data: " + dtoc(stod(_PAW->PAW_DATA))	,;
							_PAW->PAW_OS			,;
							"Hora de Inicio: "+ _PAW->PAW_HORINI + " Hora Final: "+ _PAW->PAW_HORFIM		,;
							"Cliente: " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_CLLCNO") ,;
							"Endereço: " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_END") + " " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_COMPLE") ,;
							"Telefone: " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_DDD") + " - " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_TEL"),;
							"Contato Agenda: " + POSICIONE("PA0",1,xFilial("PAW")+_PAW->PAW_OS,"PA0_CONAGE")} )
							
	aAdd( aCargo, _PAW->PAW_OS )
		
	_PAW->(dBSkip())
	
End
	
For nCont := 1 To Len(aPaw)

	cString4 := ""
	
	If aPaw[nCont][1] == "P"
		
		oLegenda := oP
			
	ElseIf aPaw[nCont][1] == "C"
		
		oLegenda := oC
			
	ElseIf aPaw[nCont][1] == "L"
		
		oLegenda := oL
			
	End If
	
	cString2		:= aPaw[nCont][3] 
	cString3		:= aPaw[nCont][2] + CRLF + aPaw[nCont][4]
		
	dbSelectArea("PA2")
	dbSetOrder(2)
	dbSeek(xFilial("PA2")+aPaw[nCont][3])
		
	While PA2->(!EOF()) .AND. ALLTRIM(PA2->PA2_NUMOS) == ALLTRIM(aPaw[nCont][3])
		
		cString4		+= PA2->PA2_CODTEC + " - " + PA2->PA2_NOMTEC + CRLF
			
		PA2->(dBSkip())
			
	End

	cString5		:= aPaw[nCont][5] + CRLF + aPaw[nCont][6] + CRLF + aPaw[nCont][7] + CRLF + aPaw[nCont][8]
		
	AAdd(aAgenda, { oLegenda , cString2 , cString3 , cString4 , cString5 })	
	
Next nCont
	
If Len(aPaw) == 0
	
	cString  := ""
	cString2 := ""
	cString3 := dtoc(dData)
	cStrind4 := ""
	cString5 := "Não a dados de agendamento para o dia selecionado."
	
	AAdd(aAgenda, { cString , cString2 , cString3 , cString4 , cString5 })	
	
End If

oBrowse:Cargo := AClone( aCargo ) 	
oBrowse:SetArray(aAgenda)
oBrowse:Refresh()
oCalend:Refresh()

oPanel:SetText(DiaExtenso(oCalend:dDiaAtu)+" - "+Dtoc(oCalend:dDiaAtu))

Return(.T.)

Static Function CSAGVIS( recno, oBrowse, oCalend )

LOCAL aNumOs := AClone( oBrowse:Cargo )    
LOCAL nAt    := oBrowse:nAt
LOCAL cNumOS := aNumOs[nAt]
Local aButtons := {}
Local oDlg	:= NIL

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0

dbSelectArea("PA0")
dbSetOrder(1)
dbSeek(xFilial("PA0")+cNumOS)
RegToMemory( "PA0", .F., .F. )

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:cNumOS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

Do While !Eof("TRB")
	AADD(aCols,Array(Len(aHeader)+1))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	DbSkip()
End Do

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

Aadd( aButtons, {"IMPRIME OS", {|| U_CSAG0009()}, "Imprime OS...", "Imprime OS" , {|| .T.}} )

EnChoice( "PA0", ,2, , , , , aPosObj[1],,3,,,)

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2    ,         ,        ,"",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,@aButtons)

oBrowse:Refresh()
oCalend:Refresh()

Return(.T.)

Static Function CSAGMudaMes(oCalend,aGet,oBrowse)

Local bWhile     := { || .T. } 
                                 
Local cQuery     := ""
Local cAliasPAW  := ""           
Local cIndTrab   := ""
Local cHoraIni   := ""
Local cHrCalcIni := ""
Local cHrCalcFim := ""

Local dData		  := Ctod("")
Local dRestri    := Ctod("") 
Local dDataIni   := FirstDay(oCalend:dDiaAtu)
Local dDataFim   := LastDay(oCalend:dDiaAtu)
Local dCalcIni   := Ctod("")
Local dCalcFim   := Ctod("")

Local nRecnoPAW  := 0 
Local nDiasAloc  := 0
Local nHoraAloc  := 0 
Local nDias      := 0
Local nHoras     := 0
Local nLoop      := 0 
Local nDiaIni    := 0 
Local nDiaFim    := 0 
Local nindex     := 0            
Local nScan      := 0 

oCalend:Hide()               

oCalend:DelAllRestri()    

aDiasAloc := {}

dData := dDataIni
While ( (dData)<=dDataFim )
	
	dData    ++
	dRestri  := dData
    dData		:= DataValida(dData,.T.)
    
    While ( Dow(dRestri)==1 .Or. Dow(dRestri)==7 )
	
		dRestri++
		                             
    EndDo
	
	If ( dData != dRestri )
	
		oCalend:addRestri(Day(dRestri),CLR_HRED,CLR_WHITE)
		
	EndIf
	
	dData := dRestri
	
EndDo
                   
dData := CToD( "" ) 

#IFDEF TOP 
             
	cAliasPAW := "AT500CHGMES" 
	
	cQuery := ""
	
	cQuery += "SELECT PAW.*,R_E_C_N_O_ PAWRECNO FROM " + RetSqlName( "PAW" ) + " PAW "
	cQuery += "WHERE "
	cQuery += "PAW_FILIAL='" + xFilial( "PAW" ) + "' AND "
	cQuery += "( ( PAW_DATA >='" + DToS( dDataIni ) + "' AND "
	cQuery += "PAW_DATA<='" + DToS( dDataFim ) + "' ) ) AND PAW_STATUS <> 'F' "
	cQuery += " AND PAW_AR = '" + cCodAr + "' "
	cQuery += "AND D_E_L_E_T_=' '"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasPAW, .F., .T. ) 
	
	TcSetField( cAliasPAW, "PAW_DATA", "D", 8, 0 ) 
	
	bWhile := { || !( cAliasPAW )->( Eof() ) } 	

#ELSE 

	cAliasPAW := "PAW"
	                   
	dbSelectArea("PAW")
	dbSetOrder(1)

	cQuery := ""
	cQuery += "PAW_FILIAL=='" + xFilial( "PAW" ) + "'.AND."
	cQuery += "AND ((DTOS(PAW_DATA)>='" + DToS( dDataIni ) + "'.AND."
	cQuery += "DTOS(PAW_DATA)<='" + DToS( dDataFim ) + "')) AND PAW_STATUS <> 'F'"
	cQuery += " AND PAW_AR = '" + cCodAr + "' " 
	                
	cIndTrab := CriaTrab( , .F. ) 	                
	                 
	IndRegua('PAW', cIndTrab,PAW->( IndexKey() ),,cQuery )   
	
	nIndex := RetIndex("PAW")

	PAW->( dbSetIndex(cIndTrab+OrdBagExt()) ) 

	PAW->( dbSetOrder(nIndex+1) ) 
	PAW->( dbGotop() ) 
	
	bWhile := { || !PAW->( Eof() ) } 

#ENDIF 

While Eval( bWhile ) 

	#IFDEF TOP
		nRecnoPAW := ( cAliasPAW )->PAWRECNO		 	 
	#ELSE
		nRecnoPAW := PAW->( Recno() ) 
	#ENDIF		
							
	If ( ( dDataIni <= ( cAliasPAW )->PAW_DATA  .And.;
			 dDataFim >= ( cAliasPAW )->PAW_DATA ))    
	   		
		If Left( DToS( ( cAliasPAW )->PAW_DATA ), 6 ) == Left( DToS( dDataIni ), 6 )
			nDiaIni    := Day( ( cAliasPAW )->PAW_DATA )
			cHrCalcIni := ( cAliasPAW )->PAW_HORINI       
			dCalcIni   := ( cAliasPAW )->PAW_DATA
		Else
			nDiaIni    := Day( dDataIni )             
			cHrCalcIni := "00:00"                
			dCalcIni   := dDataIni 
		EndIf          

		If Left( DToS( ( cAliasPAW )->PAW_DATA ), 6 ) == Left( DToS( dDataFim ), 6 )
			nDiaFim    := Day( ( cAliasPAW )->PAW_DATA )
			cHrCalcFim := ( cAliasPAW )->PAW_HORFIM
			dCalcFim   := ( cAliasPAW )->PAW_DATA
		Else
			nDiaFim    := Day( dDataFim )            
			cHrCalcFim := "23:59"                 
			dCalcFim   := dDataFim
		EndIf          
		
		For nLoop := nDiaIni To nDiaFim
		
			oCalend:addRestri( nLoop,CLR_BLUE,CLR_BLUE)   
			
			If nLoop == Day( ( cAliasPAW )->PAW_DATA )
				cHoraIni := ( cAliasPAW )->PAW_HORINI
			Else
				cHoraIni := "....."
			EndIf				
			
			If Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nLoop } ) ) 
				AAdd( aDiasAloc, { nLoop,{ { nRecnoPAW, cHoraIni } } } ) 
			Else	
				If Empty( AScan( aDiasAloc[ nScan, 2 ], { |x| x[1] == nRecnoPAW } ) )
					AAdd( aDiasAloc[ nScan, 2 ], { nRecnoPAW, cHoraIni } ) 
				EndIf 					
			EndIf 				
				
  		Next nLoop 
		
		nDiasAloc++
		
		nHoraAloc += SubtHoras( dCalcIni, cHrCalcIni, dCalcFim, cHrCalcFim ) 
		
	EndIf 	
	
	If ( cAliasPAW )->PAW_DATA < dDataIni .And. ( cAliasPAW )->PAW_DATA > dDataFim 
	
		For nLoop := Day( dDataIni ) To Day( dDataFim ) 
			oCalend:addRestri( nLoop,CLR_BLUE,CLR_BLUE)         
			
			cHoraIni := "....." 
			
			If Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nLoop } ) ) 
				AAdd( aDiasAloc, { nLoop, { { nRecnoPAW, cHoraIni } } } ) 
			Else	
				If Empty( AScan( aDiasAloc[ nScan, 2 ], { |x| x[1] == ( cAliasPAW )->( Recno() ) } ) )
					AAdd( aDiasAloc[ nScan, 2 ], { nRecnoPAW, cHoraIni } ) 
				EndIf 					
			EndIf 				
			
  		Next nLoop                       
  		
		nHoraAloc += SubtHoras( dDataIni, "00:00", dDataFim, "23:59" )   		
  		
	EndIf 	
	
	( cAliasPAW )->( dbSkip() ) 
	
EndDo                               

#IFDEF TOP
	dbSelectArea( cAliasPAW ) 
	dbCloseArea()
	dbSelectArea( "PAW" )  
#ELSE
	RetIndex( "PAW" )
	Ferase(cIndTrab+OrdBagExt())
#ENDIF 	

oCalend:Show()

nDias  := Int(nHoraAloc/24)
nHoras := nHoraAloc-(nDias*24)

aGet[2][2] := nDiasAloc
aGet[1][2] := Str(nDias,4)+"D "+IntToHora(nHoras)
aGet[3][2] := Len( aDiasAloc ) 
                    
aGet[3][1]:Refresh()
aGet[2][1]:Refresh()
aGet[1][1]:Refresh()

oBrowse:Refresh()
oCalend:Refresh()

Return(.T.)

Static Function CSAGTECNICO( oBrowse, oCalend )

Local aHeader	:= {}
Local nUsado	:= 0
Local aNumOs 	:= AClone( oBrowse:Cargo )  
Local cNumOS  
Local nAt    	:= oBrowse:nAt
Local aCols		:= {}
Local aBotoes 	:= {}
Local cAltera 	:= ""
Local nI
Local oDlg
Local oGetDados
Local cLinOk 	:= "AllwaysTrue"
Local cTudoOk 	:= "AllwaysTrue"
Local lMemoria 	:= .T.
Local cFieldOk 	:= "AllwaysTrue"
Local cSuperDel := ""
Local cDelOk 	:= "AllwaysFalse"
Local lRet		:= .F.

If len(aNumOs) == 0

	MsgAlert("Por favor, selecione uma OS valida para incluir um técnico")

	lRet := .F.
	
	Return lRet
	
End If

cNumOs  := aNumOs[ nAt ]

dbSelectArea("PAW")
dbSetOrder(4)
dbSeek(xFilial("PAW")+cNumOs)

If PAW->(Found())

	If PAW->PAW_STATUS == "L"

		PA0->( dbSetOrder( 1 ) ) 
		
		PA0->( dbSeek( xFilial( "PA0" ) + cNumOs ) ) 
		
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("PA2")
							
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA2") )
							
			If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
				
				If SX3->X3_CAMPO <> "PA2_NUMOS"
				
					If SX3->X3_CAMPO <> "PA2_DATA"
					
						If SX3->X3_CAMPO <> "PA2_HORINI" 
						
							If SX3->X3_CAMPO <> "PA2_HORFIM" 
							
								If SX3->X3_CAMPO <> "PA2_HORTOT"
								
									nUsado++
									
									Aadd(aHeader,{ TRIM(X3Titulo()),;
											   SX3->X3_CAMPO,;
											   SX3->X3_PICTURE,;
											   SX3->X3_TAMANHO,;
											   SX3->X3_DECIMAL,;
											   SX3->X3_VALID,;
											   SX3->X3_USADO,;
											   SX3->X3_TIPO,;
											   SX3->X3_F3,;
											   SX3->X3_CONTEXT } )
											  
								End If
								
							End If
							
						End If
					
					End If
					
				End If
									
			End If
								
			dbSkip()
								
		End Do
						
		Aadd(aCols,Array(nUsado+1))
						
		For nI	:= 1 To nUsado
								
			aCols[1][nI] := CriaVar(aHeader[nI][2])
				
		Next nI
			
		aCols[1][nUsado+1] := .F.
					
		DEFINE MSDIALOG oDlg TITLE "Agendamento X Tecnicos" FROM 00,00 TO 200,600 PIXEL
							 
		oGetDados := MsNewGetDados():New(30,05,80,290,3,cLinOk,,,,0,10,cFieldOk,cSuperDel,cDelOk, oDlg, aHeader, aCols )
			
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||IIF(lRet := LinOk(@oGetDados, @oBrowse), IIF(CSAGGRAVA(oGetDados, @oBrowse, @oCalend), oDlg:End(),.F.),.F.)},;
		 														  {||oDlg:End()},,aBotoes)
		
	Else
	
		MsgAlert("Não é possivel agendar um tecnico, pois este agendamento não encontra-se confirmado")
		
	End If
	
End If
	
oBrowse:Refresh()
oCalend:Refresh()

Return lRet

Static Function LinOk(oGetDados, oBrowse)

Local lRet := .F.
Local nValIni := 0
Local aNumOs 	:= AClone( oBrowse:Cargo )  
Local cNumOS  
Local nAt    	:= oBrowse:nAt
Local nHoraIni  := 0
Local nHoraFim	:= 0
Local dData
Local cHoraInter:= ""
Local cTecnico	:= ""
Local cCodPaw	:= ""

cNumOs  := aNumOs[ nAt ]

If !Empty(oGetDados:Acols[1][1])

	dbSelectArea("PAW")
	dbSetOrder(4)
	dbSeek(xFilial("PAW")+cNumOs)
	
	If PAW->(Found())
	
		nHoraIni := ((Val(SubStr(PAW->PAW_HORINI,1,2))*60) + Val(SubStr(PAW->PAW_HORINI,4,2)))
		nHoraFim := ((Val(SubStr(PAW->PAW_HORFIM,1,2))*60) + Val(SubStr(PAW->PAW_HORFIM,4,2)))
		dData	 := PAW->PAW_DATA
		cCodPaw	 := PAW->PAW_COD
		
	End If
	
	For n := 1 To Len(oGetDados:aCols)
	
		For nCont := nHoraIni To nHoraFim
		
			cTecnico := oGetDados:aCols[n][1]
			
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
		
	Next n
	
Else

	MsgAlert("Por favor, preencher com um codigo de tecnico valido!")
	
	lRet := .F.

End If

Return(lRet)

Static Function CSAGGRAVA(oGetDados, oBrowse, oCalend)

Local aNumOs 	:= AClone( oBrowse:Cargo )  
Local cNumOS  
Local nAt    	:= oBrowse:nAt
Local dData
Local cHoraIni	:= ""
Local cHoraFim	:= ""
Local cCodAge	:= ""
Local cEmail	:= ""

cNumOs  := aNumOs[ nAt ]

If !Empty(oGetDados:aCols) 

	dbSelectArea("PA0")
	dbSetOrder(1)
	dbSeek(xFilial("PAW")+cNumOs)
	
	If PA0->(Found())
	
		cEmail := PA0->PA0_EMAIL
		
		cAssuntoEm := 'Validação Presencial CertiSign - Confirmação de Agente de Registro'
	
		cCase := "TECNICO"
	
		BEGIN TRANSACTION                         
					
			RecLock("PA0",.F.)
			PA0->PA0_STATUS := "3"
			MsUnlock()
						
		END TRANSACTION
		
	End If
	
	dbSelectArea("PAW")
	dbSetOrder(4)
	dbSeek(xFilial("PAW")+cNumOs)
	
	If PAW->(Found())
	
		cHoraIni := PAW->PAW_HORINI
		cHoraFim := PAW->PAW_HORFIM
		dData	 := PAW->PAW_DATA
		cCodAge	 := PAW->PAW_COD
		
		BEGIN TRANSACTION                         
					
			RecLock("PAW",.F.)
			PAW->PAW_STATUS := "C"
			MsUnlock()
						
		END TRANSACTION
		
	End If
	
	For nCont := 1 To Len(oGetDados:aCols)
	
		dbSelectArea("PA2")
		dbSetOrder(2)
		dbSeek(xFilial("PA2")+cNumOs)
	
		BEGIN TRANSACTION                         
					
			RecLock("PA2",.T.)
			PA2->PA2_FILIAL				:= xFilial("PA2")
			PA2->PA2_CODAGE				:= cCodAge
			PA2->PA2_CODTEC 			:= oGetDados:aCols[nCont][1]
			PA2->PA2_NOMTEC 			:= oGetDados:aCols[nCont][2]
			PA2->PA2_NUMOS				:= cNumOs
			PA2->PA2_DATA				:= dData
			PA2->PA2_HORINI 			:= cHoraIni
			PA2->PA2_HORFIM 			:= cHoraFim
			PA2->PA2_HORTOT				:= SubStr(Str(SubHoras(cHoraFim, cHoraIni),5,2),1,2) +":"+ SubStr(Str(SubHoras(cHoraFim, cHoraIni),5,2),4,2)
			PA2->PA2_OBSERV				:= oGetDados:aCols[nCont][3]
			MsUnlock()
						
		END TRANSACTION	
							  	
		ConfirmSX8()
		
	Next nCont
	
	
	If !U_CSFSEmail(cNumOs, , cEmail, cAssuntoEm, cCase)
		
		Alert("Não foi possivel enviar o e-mail de confirmação do agendamento tecnico, favor entrar em contato com Sistemas Corporativos!")
			
		Return .T.
		
	End If
	
	Aviso( "Agendamento X Tecnico", "Tecnico associado com sucesso.", {"Ok"} )
	
Else

	MsgAlert("É necessario informar ao menos um tecnico para finalizar a inclusão.")
	
	Return .F.
	
End If
 	
oBrowse:Refresh()
oCalend:Refresh()

Return .T.

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

Static Function CSAGALTERA( oBrowse, oCalend )

Local aNumOs 	:= AClone( oBrowse:Cargo )  
Local cNumOS  
Local nAt    	:= oBrowse:nAt
Local lOk		:= .F.

cNumOs  := aNumOs[ nAt ]

dbSelectArea("PAW")
dbSetOrder(4)
dbSeek(xFilial("PAW")+cNumOs)

If PAW->PAW_STATUS <> "F"

	lOk := PAW->(FWExecView('Agendamento Tecnico','CSAG0020', MODEL_OPERATION_UPDATE,, { || .T. } ) == 0 ) 

End If

oBrowse:Refresh()
oCalend:Refresh()
	
Return lOk