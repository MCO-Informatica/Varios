#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Ivan Morelatto Tore º Data ³  31/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na rotina de Expedicao MATA512 para       º±±
±±º          ³ preencher os volumes e especies                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA512                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()

Local oDlg,oGrp1,oSay2,oGet3,oSay4,oGet5,oSay6,oGet7,oSay8,oGet9,oSay10,oGet11,oSay12
Local oGet13,oSay14,oGet15,oSay16,oGet17,oSay18,oGet19,oSay20,oGet21,oSBtn22,oSBtn23

Private cVol1 := Space(6)
Private cVol2 := Space(6)
Private cVol3 := Space(6)
Private cVol4 := Space(6)
Private cEsp1 := SF2->F2_ESPECI1
Private cEsp2 := SF2->F2_ESPECI2
Private cEsp3 := SF2->F2_ESPECI3
Private cEsp4 := SF2->F2_ESPECI4

Private nPLIQUI := SF2->F2_PLIQUI
Private nPBRUTO := SF2->F2_PBRUTO

BscPeso(@nPLIQUI,@nPBRUTO)

cVol1 := AllTrim( Str( SF2->F2_VOLUME1 ) ) + Space( 6 - Len( AllTrim( Str( SF2->F2_VOLUME1 ) ) ) )
cVol2 := AllTrim( Str( SF2->F2_VOLUME2 ) ) + Space( 6 - Len( AllTrim( Str( SF2->F2_VOLUME2 ) ) ) )
cVol3 := AllTrim( Str( SF2->F2_VOLUME3 ) ) + Space( 6 - Len( AllTrim( Str( SF2->F2_VOLUME3 ) ) ) )
cVol4 := AllTrim( Str( SF2->F2_VOLUME4 ) ) + Space( 6 - Len( AllTrim( Str( SF2->F2_VOLUME4 ) ) ) )


oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Informações de Volume e Especie"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 465
oDlg:nHeight := 250
oDlg:lShowHint := .F.
oDlg:lCentered := .F.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Informe o(s) Volume(s) e Especie(s) da NF: " + AllTrim( SF2->F2_SERIE ) + " / " + AllTrim( SF2->F2_DOC )
oGrp1:nLeft := 12
oGrp1:nTop := 6
oGrp1:nWidth := 435
oGrp1:nHeight := 180
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Volume 1:"
oSay2:nLeft := 20
oSay2:nTop := 34
oSay2:nWidth := 65
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oGet3 := TGET():Create(oDlg)
oGet3:cName := "oGet3"
oGet3:nLeft := 86
oGet3:nTop := 33
oGet3:nWidth := 121
oGet3:nHeight := 21
oGet3:lShowHint := .F.
oGet3:lReadOnly := .F.
oGet3:Align := 0
oGet3:cVariable := "cVol1"
oGet3:bSetGet := {|u| If(PCount()>0,cVol1:=u,cVol1) }
oGet3:lVisibleControl := .T.
oGet3:lPassword := .F.
oGet3:lHasButton := .F.
oGet3:Picture := "@R999999"
oGet3:bValid := { || VldVol( "1" ) }

oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := "Especie 1:"
oSay4:nLeft := 236
oSay4:nTop := 34
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oGet5 := TGET():Create(oDlg)
oGet5:cName := "oGet5"
oGet5:nLeft := 302
oGet5:nTop := 32
oGet5:nWidth := 121
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "cEsp1"
oGet5:bSetGet := {|u| If(PCount()>0,cEsp1:=u,cEsp1) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:lHasButton := .F.
oGet5:Picture := "@!"

oSay6 := TSAY():Create(oDlg)
oSay6:cName := "oSay6"
oSay6:cCaption := "Volume 2:"
oSay6:nLeft := 21
oSay6:nTop := 63
oSay6:nWidth := 65
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .F.

oGet7 := TGET():Create(oDlg)
oGet7:cName := "oGet7"
oGet7:nLeft := 87
oGet7:nTop := 62
oGet7:nWidth := 121
oGet7:nHeight := 21
oGet7:lShowHint := .F.
oGet7:lReadOnly := .F.
oGet7:Align := 0
oGet7:cVariable := "cVol2"
oGet7:bSetGet := {|u| If(PCount()>0,cVol2:=u,cVol2) }
oGet7:lVisibleControl := .T.
oGet7:lPassword := .F.
oGet7:lHasButton := .F.
oGet7:Picture := "@R999999"
oGet7:bValid := { || VldVol( "2" ) }

oSay8 := TSAY():Create(oDlg)
oSay8:cName := "oSay8"
oSay8:cCaption := "Especie 2:"
oSay8:nLeft := 237
oSay8:nTop := 63
oSay8:nWidth := 65
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oGet9 := TGET():Create(oDlg)
oGet9:cName := "oGet9"
oGet9:nLeft := 303
oGet9:nTop := 61
oGet9:nWidth := 121
oGet9:nHeight := 21
oGet9:lShowHint := .F.
oGet9:lReadOnly := .F.
oGet9:Align := 0
oGet9:cVariable := "cEsp2"
oGet9:bSetGet := {|u| If(PCount()>0,cEsp2:=u,cEsp2) }
oGet9:lVisibleControl := .T.
oGet9:lPassword := .F.
oGet9:lHasButton := .F.
oGet9:Picture := "@!"

oSay10 := TSAY():Create(oDlg)
oSay10:cName := "oSay10"
oSay10:cCaption := "Volume 3:"
oSay10:nLeft := 22
oSay10:nTop := 93
oSay10:nWidth := 65
oSay10:nHeight := 17
oSay10:lShowHint := .F.
oSay10:lReadOnly := .F.
oSay10:Align := 0
oSay10:lVisibleControl := .T.
oSay10:lWordWrap := .F.
oSay10:lTransparent := .F.

oGet11 := TGET():Create(oDlg)
oGet11:cName := "oGet11"
oGet11:nLeft := 87
oGet11:nTop := 92
oGet11:nWidth := 121
oGet11:nHeight := 21
oGet11:lShowHint := .F.
oGet11:lReadOnly := .F.
oGet11:Align := 0
oGet11:cVariable := "cVol3"
oGet11:bSetGet := {|u| If(PCount()>0,cVol3:=u,cVol3) }
oGet11:lVisibleControl := .T.
oGet11:lPassword := .F.
oGet11:lHasButton := .F.
oGet11:Picture := "@R999999"
oGet11:bValid := { || VldVol( "3" ) }

oSay12 := TSAY():Create(oDlg)
oSay12:cName := "oSay12"
oSay12:cCaption := "Especie 3:"
oSay12:nLeft := 238
oSay12:nTop := 92
oSay12:nWidth := 65
oSay12:nHeight := 17
oSay12:lShowHint := .F.
oSay12:lReadOnly := .F.
oSay12:Align := 0
oSay12:lVisibleControl := .T.
oSay12:lWordWrap := .F.
oSay12:lTransparent := .F.

oGet13 := TGET():Create(oDlg)
oGet13:cName := "oGet13"
oGet13:nLeft := 304
oGet13:nTop := 91
oGet13:nWidth := 121
oGet13:nHeight := 21
oGet13:lShowHint := .F.
oGet13:lReadOnly := .F.
oGet13:Align := 0
oGet13:cVariable := "cEsp3"
oGet13:bSetGet := {|u| If(PCount()>0,cEsp3:=u,cEsp3) }
oGet13:lVisibleControl := .T.
oGet13:lPassword := .F.
oGet13:lHasButton := .F.
oGet13:Picture := "@!"

oSay14 := TSAY():Create(oDlg)
oSay14:cName := "oSay14"
oSay14:cCaption := "Volume 4:"
oSay14:nLeft := 22
oSay14:nTop := 123
oSay14:nWidth := 65
oSay14:nHeight := 17
oSay14:lShowHint := .F.
oSay14:lReadOnly := .F.
oSay14:Align := 0
oSay14:lVisibleControl := .T.
oSay14:lWordWrap := .F.
oSay14:lTransparent := .F.

oGet15 := TGET():Create(oDlg)
oGet15:cName := "oGet15"
oGet15:nLeft := 87
oGet15:nTop := 122
oGet15:nWidth := 121
oGet15:nHeight := 21
oGet15:lShowHint := .F.
oGet15:lReadOnly := .F.
oGet15:Align := 0
oGet15:cVariable := "cVol4"
oGet15:bSetGet := {|u| If(PCount()>0,cVol4:=u,cVol4) }
oGet15:lVisibleControl := .T.
oGet15:lPassword := .F.
oGet15:lHasButton := .F.
oGet15:Picture := "@R999999"
oGet15:bValid := { || VldVol( "4" ) }

oSay16 := TSAY():Create(oDlg)
oSay16:cName := "oSay16"
oSay16:cCaption := "Especie 4:"
oSay16:nLeft := 238
oSay16:nTop := 122
oSay16:nWidth := 65
oSay16:nHeight := 17
oSay16:lShowHint := .F.
oSay16:lReadOnly := .F.
oSay16:Align := 0
oSay16:lVisibleControl := .T.
oSay16:lWordWrap := .F.
oSay16:lTransparent := .F.

oGet17 := TGET():Create(oDlg)
oGet17:cName := "oGet17"
oGet17:nLeft := 304
oGet17:nTop := 121
oGet17:nWidth := 121
oGet17:nHeight := 21
oGet17:lShowHint := .F.
oGet17:lReadOnly := .F.
oGet17:Align := 0
oGet17:cVariable := "cEsp4"
oGet17:bSetGet := {|u| If(PCount()>0,cEsp4:=u,cEsp4) }
oGet17:lVisibleControl := .T.
oGet17:lPassword := .F.
oGet17:lHasButton := .F.
oGet17:Picture := "@!"

oSay18 := TSAY():Create(oDlg)
oSay18:cName := "oSay18"
oSay18:cCaption := "Peso Liquido"
oSay18:nLeft := 22
oSay18:nTop := 152
oSay18:nWidth := 65
oSay18:nHeight := 17
oSay18:lShowHint := .F.
oSay18:lReadOnly := .F.
oSay18:Align := 0
oSay18:lVisibleControl := .T.
oSay18:lWordWrap := .F.
oSay18:lTransparent := .F.

oGet19 := TGET():Create(oDlg)
oGet19:cName := "oGet19"
oGet19:nLeft := 87
oGet19:nTop := 152
oGet19:nWidth := 121
oGet19:nHeight := 21
oGet19:lShowHint := .F.
oGet19:lReadOnly := .F.
oGet19:Align := 0
oGet19:cVariable := "nPLIQUI"
oGet19:bSetGet := {|u| If(PCount()>0,nPLIQUI:=u,nPLIQUI) }
oGet19:lVisibleControl := .T.
oGet19:lPassword := .F.
oGet19:lHasButton := .F.
oGet19:Picture := PesqPict("SF2","F2_PLIQUI",17)
//oGet19:bValid := { || VldVol( "3" ) }

oSay20 := TSAY():Create(oDlg)
oSay20:cName := "oSay20"
oSay20:cCaption := "Peso Bruto"
oSay20:nLeft := 238
oSay20:nTop := 152
oSay20:nWidth := 65
oSay20:nHeight := 17
oSay20:lShowHint := .F.
oSay20:lReadOnly := .F.
oSay20:Align := 0
oSay20:lVisibleControl := .T.
oSay20:lWordWrap := .F.
oSay20:lTransparent := .F.

oGet21 := TGET():Create(oDlg)
oGet21:cName := "oGet21"
oGet21:nLeft := 304
oGet21:nTop := 152
oGet21:nWidth := 121
oGet21:nHeight := 21
oGet21:lShowHint := .F.
oGet21:lReadOnly := .F.
oGet21:Align := 0
oGet21:cVariable := "nPBRUTO"
oGet21:bSetGet := {|u| If(PCount()>0,nPBRUTO:=u,nPBRUTO) }
oGet21:lVisibleControl := .T.
oGet21:lPassword := .F.
oGet21:lHasButton := .F.
oGet21:Picture := PesqPict("SF2","F2_PBRUTO",17)
//oGet21:bValid := { || VldVol( "3" ) }

oSBtn22 := SBUTTON():Create(oDlg)
oSBtn22:cName := "oSBtn22"
oSBtn22:cCaption := "OK"
oSBtn22:nLeft := 316
oSBtn22:nTop := 192
oSBtn22:nWidth := 52
oSBtn22:nHeight := 22
oSBtn22:lShowHint := .F.
oSBtn22:lReadOnly := .F.
oSBtn22:Align := 0
oSBtn22:lVisibleControl := .T.
oSBtn22:nType := 1
oSBtn22:bAction := {|| ProcAlt(), oDlg:End() }

oSBtn23 := SBUTTON():Create(oDlg)
oSBtn23:cName := "oSBtn23"
oSBtn23:cCaption := "Cancel"
oSBtn23:nLeft := 378
oSBtn23:nTop := 192
oSBtn23:nWidth := 52
oSBtn23:nHeight := 22
oSBtn23:lShowHint := .F.
oSBtn23:lReadOnly := .F.
oSBtn23:Align := 0
oSBtn23:lVisibleControl := .T.
oSBtn23:nType := 2
oSBtn23:bAction := {|| oDlg:End() }

oDlg:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M512AGRV  ºAutor  ³Microsiga           º Data ³  03/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa Gravacao                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcAlt

RecLock( "SF2", .F. )

SF2->F2_VOLUME1 := Val( cVol1 )
SF2->F2_VOLUME2 := Val( cVol2 )
SF2->F2_VOLUME3 := Val( cVol3 )
SF2->F2_VOLUME4 := Val( cVol4 )

SF2->F2_ESPECI1 := cEsp1
SF2->F2_ESPECI2 := cEsp2
SF2->F2_ESPECI3 := cEsp3
SF2->F2_ESPECI4 := cEsp4

SF2->F2_PLIQUI := nPLIQUI
SF2->F2_PBRUTO := nPBRUTO

SF2->( MsUnLock() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M512AGRV  ºAutor  ³Microsiga           º Data ³  03/31/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldVol( cCpo )

Local lRet 		:= .T.
Local cDig 		:= AllTrim( &( "cVol" + cCpo ) )
Local nCntFor	:= 0

For nCntFor := 1 To Len( cDig )
	If !( SubStr( cDig, nCntFor, 1 ) $ "0123456789" )
		MsgStop( "Informe apenas numeros nos campos de volume" )
		lRet := .F.
		Exit
	Endif
Next nCntFor

Return lRet



Static Function BscPeso(nPesoL,nPesoB)

Default nPesoL := 0
Default nPesoB := 0

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE)
While SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(XFilial("SB1") + SD2->D2_COD)
	
	nPesoL += (SD2->D2_QUANT * iif(SB1->B1_PESO>0,SB1->B1_PESO,1) )
	nPesoB += (SD2->D2_QUANT * iif(SB1->B1_PESBRU>0,SB1->B1_PESBRU,1)  )
	
	dbSelectArea("SD2")
	dbSkip()
Enddo

Return()   
