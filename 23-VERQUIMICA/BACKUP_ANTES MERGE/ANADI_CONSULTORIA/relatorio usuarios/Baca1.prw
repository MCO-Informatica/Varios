#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO9     º Autor ³ AP6 IDE            º Data ³  07/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function Baca1
NewDlg1()
            
user Function Baca1x
                   
dbSelectArea("SZ9")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

While !SB1->(EOF())  

	If !Empty(SB1->B1_CODBAR) .and. Empty(Posicione("SZ9", 1, xFilial("SZ9")+SB1->B1_CODBAR, "Z9_COD"));
		.and. Empty(Posicione("SZ9", 2, xFilial("SZ9")+SB1->B1_COD, "Z9_COD")) 
			RecLock("SZ9",.t.)
		  	SZ9->Z9_FILIAL := xFilial("SZ9")
	   	SZ9->Z9_COD		:= SB1->B1_COD
	   	SZ9->Z9_CODBAR := SB1->B1_CODBAR
			MsUnlock()
	EndIf
  
	If !empty(SB1->B1_CODBAR2) .and. Empty(Posicione("SZ9", 1, xFilial("SZ9")+SB1->B1_CODBAR2, "Z9_COD"))
		      msgstop(SB1->B1_COD+"PAS")
	Endif	

	If !empty(SB1->B1_CODBAR3) .and. Empty(Posicione("SZ9", 1, xFilial("SZ9")+SB1->B1_CODBAR3, "Z9_COD"))
		      msgstop(SB1->B1_COD+"PAC")
	Endif	
	SB1->(dBSkip())
EndDo
Return

Static Function conv(cLin)  
Local x, y, z          
      y := Len(cLin)
      z := 0
      For x:= 1 to Len(cLin)
      	if Subs(clin,y,1) > "9"
      		Z += if(x==1,(ASC(Subs(clin,y,1)) - 64) + 10,((ASC(Subs(clin,y,1)) - 64)*35)+90)
      	Else   
      		
      		Z += Val(Subs(clin,y,1)) * if(x==1, 1, 10**(x-1))
      	EndIf
      y--		
      Next  
      cLin := StrZero(z,4,0)       
Return cLin      

/*
user Function AJPREC


static function Baca10(odlg)
local cArq, _aTrab

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	DbSelectArea("SF2")
EndIf

_aTrab :=  {{"B1_COD","C",15,0},;
				{"B1_PRV1","N",12,2},;
				{"B1_DTREFP1","D",08,0},;
				{"B1_DATA","D",08,0};
				}

_cArqTRB1 := CriaTrab(_aTrab,.t.)
DbUseArea(.t.,,_cArqTRB1,"TRB1",.t.,.f.)

msgalert("Os preços originais serão gravados no arquivo "+_cArqTRB1)

dbselectarea("SB1")
dbsetorder(1)
dbgotop()


while !SB1->(Eof())
	if	SB1->B1_GRUPO <= "01" .or.;
		SB1->B1_GRUPO >= "99"
		dbskip()
		loop
   endif
   if SB1->B1_PRV1 > 0
   	Reclock("TRB1", .t.)
  		TRB1->B1_COD 		:= SB1->B1_COD
		TRB1->B1_PRV1 		:= SB1->B1_PRV1
		TRB1->B1_DTREFP1	:= SB1->B1_DTREFP1
		TRB1->B1_DATA		:=	dDataBase
		TRB1->(MsUnLock())  
		Reclock("SB1", .f.) 
		msg:cCaption := SB1->B1_COD + "PR "+Transform(SB1->B1_PRV1,"@E 999,999.99")+;
							"em "+Transform(SB1->B1_DTREFP1,"@D")+CHR(10)+CHR(13)+;
							"PR reajustado "+Transform(SB1->B1_PRV1*nTaxa,"@E 999,999.99")
		SB1->B1_PRV1 		:= nTaxa*SB1->B1_PRV1
		SB1->B1_DTREFP1	:=	dDataBase
		SB1->(MsUnLock())  
		odlg:Refresh(.t.)
		Processmessages()      
		
	endif	
	SB1->(dbskip())
enddo
msg:cCaption := "Processo concluído..."
odlg:Refresh(.t.)
Processmessages()
//cArq := "SB1"+Dtos(dDataBase)+time()
//copy file &_cArqTRB1 to &cArq
//msgalert("Os preços originais serão gravados no arquivo "+cArq)    
return

static Function IoDlg()

Local oDlg,oSay1,oGet2,oSBtn3,oSBtn4
private msg
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Aplica Reajuste de Preço"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 259
oDlg:nHeight := 165
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oSay1 := TSAY():Create(oDlg)
oSay1:cName := "oSay1"
oSay1:cCaption := "Informe a taxa a ser aplicada aos preços de lista"
oSay1:nLeft := 36
oSay1:nTop := 10
oSay1:nWidth := 195
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGet2 := TGET():Create(oDlg)
oGet2:cName := "oGet2"
//oGet2:cCaption := "88888,888"
oGet2:cToolTip := "Taxa"
oGet2:nLeft := 67
oGet2:nTop := 33
oGet2:nWidth := 121
oGet2:nHeight := 21
oGet2:lShowHint := .F.
oGet2:lReadOnly := .F.
oGet2:Align := 0
oGet2:cVariable := "nTaxa"
oGet2:bSetGet := {|u| If(PCount()>0,nTaxa:=u,nTaxa) }
oGet2:lVisibleControl := .T.
oGet2:lPassword := .F.
oGet2:Picture := "@E 999.99"
oGet2:lHasButton := .F.

oSBtn3 := SBUTTON():Create(oDlg)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 190
oSBtn3:nTop := 106
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 1
oSBtn3:bAction := {|| baca10(odlg)}

oSBtn4 := SBUTTON():Create(oDlg)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "oSBtn4"
oSBtn4:nLeft := 133
oSBtn4:nTop := 105
oSBtn4:nWidth := 52
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 2
oSBtn4:bAction := {|| close(odlg) }

msg := TSAY():Create(oDlg)
msg:cName := "msg"
msg:cCaption := "...."
msg:nLeft := 38
msg:nTop := 63
msg:nWidth := 181
msg:nHeight := 17
msg:lShowHint := .F.
msg:lReadOnly := .F.
msg:Align := 0
msg:lVisibleControl := .T.
msg:lWordWrap := .F.
msg:lTransparent := .F.
msg:cVariable := "cMSG"
msg:bSetGet := {|u| If(PCount()>0,cMSG:=u,cMSG) }
oDlg:Activate()

Return
*/

Static Function NewDlg1()
Local cFunction := Space(30)
Local oBaca1,oSay1,oSBtn3,oSBtn4,oGet5
oBaca1 := MSDIALOG():Create()
oBaca1:cName := "oBaca1"
oBaca1:cCaption := "Desenvolvimento"
oBaca1:nLeft := 0
oBaca1:nTop := 0
oBaca1:nWidth := 252
oBaca1:nHeight := 133
oBaca1:lShowHint := .F.
oBaca1:lCentered := .T.

oSay1 := TSAY():Create(oBaca1)
oSay1:cName := "oSay1"
oSay1:cCaption := "Escolha o programa a ser executado"
oSay1:nLeft := 25
oSay1:nTop := 11
oSay1:nWidth := 180
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oSBtn3 := SBUTTON():Create(oBaca1)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "OK"
oSBtn3:nLeft := 108
oSBtn3:nTop := 68
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 1
oSBtn3:bAction := {|| BACA11(cFunction) }

oSBtn4 := SBUTTON():Create(oBaca1)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "Cancela"
oSBtn4:nLeft := 166
oSBtn4:nTop := 68
oSBtn4:nWidth := 52
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 2
oSBtn4:bAction := {|| Close(obaca1) }

oGet5 := TGET():Create(oBaca1)
oGet5:cName := "oGet5"
oGet5:cCaption := "oGet5"
oGet5:nLeft := 18
oGet5:nTop := 42
oGet5:nWidth := 202
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "cFunction"
oGet5:bSetGet := {|u| If(PCount()>0,cFunction:=u,cFunction) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:Picture := "@!S40"
oGet5:lHasButton := .F.

oBaca1:Activate()

Return

Static Function BACA11(cFunction)  
//	&cFunction  
  //	Return
if !Empty(cFunction)
	if ExistBlock(cFunction)
		ExecBlock( cFunction, .F., .F.)  
	Else
		&(cFunction+"()")
	endif	
endif	

User function Baca12   
Local PL := 0
if !msgYesNo("Devo atualizar os preços para amostra (PL* 0,182)?","Atualiza preço para Amostra")
	return
endif

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea('SB5')
dbSetOrder(1)   

dbGotop()
while !EOF()
	PL :=	Posicione("SB1",1,xFilial("SB1")+SB5->B5_COD,"B1_PRV1") * 0.182  
	if !empty(PL)
		RecLock("SB5" ,.f.)
		SB5->B5_PRV4 := PL
		msUnlock()
	endif
	dbSkip()
enddo

user function baca11
Local x := 1
dbselectarea("SUS")

dbGotop()

While !EOF()
    Reclock("SUS",.f.)
    SUS->US_CGC := "000000"+STRZERO(x++,8)
    msunlock()
	dbSkip()
enddo


/*
user function Baca2
Local ITEM := "0000"

dbselectarea("DA1")
dbSetOrder(1)
dbselectarea("AIB")
dbSetOrder(2)
dbGoTop()

While !AIB->(EOF())
	if !DA1->(dbSeek(xFilial("DA1")+"001"+AIB->AIB_CODPRO))
		RecLock("DA1", .t.)
		DA1->DA1_CODPRO	:= AIB->AIB_CODPRO
		DA1->DA1_PRCVEN	:= Round(AIB->AIB_PRCCOM * 7.37, 2)
		DA1->DA1_ITEM	   := ITEM := SOMA1(ITEM)   
		DA1->DA1_QTDLOT	:= 999999.99
		DA1->DA1_INDLOT	:= "000000000999999.99  "
		DA1->DA1_MOEDA		:= 3
		DA1->DA1_ATIVO		:= '1'
		DA1->DA1_CODTAB   := "001"
		DA1->DA1_TPOPER   := '4'
		MSUnLock()         
	EndIf	
	AIB->(dbSkip())
EndDo
*/        

User Function Baca3
DbselectArea("CT2") 

Filtro := "@CT2_FILIAL='01' And CT2_DATA >= '20150101' And "
Filtro += "(CT2_ORIGEM Like '%610/03%' OR CT2_ORIGEM Like '%610/051%' OR CT2_ORIGEM Like '%610/052%' OR CT2_ORIGEM Like '%610/053%' OR CT2_ORIGEM Like '%610/054%' OR CT2_ORIGEM Like '%610/07%')"
//Filtro += "CT2_ORIGEM IN ('%610/03%','%610/051%','%610/052%','%610/053%','%610/054%','%610/07%')"
Filtro += " And D_E_L_E_T_ <> '*' "

Set Filter To &Filtro

dbGotop()
While !EOF()
    While !Reclock("CT2",.f.)
	EndDo
	CT2->CT2_FILIAL := 'YZ'
	MsUnlock()
	dbSkip()
EndDo
                     
User Function Baca4
Local Filtro, x

DbselectArea("SF2")                
Filtro := "F2_FILIAL='"+xFilial("SF2")+"' .And. DTOS(F2_EMISSAO) >= '20150101' .And.  !Deleted()"

Set Filter To &Filtro

dbGotop()
While !EOF() 
	Posicione("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_CF")
    If Substring(SD2->D2_CF,2,3) $ '911/910'//.or. SD2->D2_TES $ "511/512/545/627/633"
	 	If !Empty(SF2->F2_DTLANC)
	 		While !Reclock("SF2",.f.)
   			EndDo
		  	SF2->F2_DTLANC := ctod(" / / ")
		 	MsUnlock()
		EndIF 	                   
		
	EndIF
	dbSkip() 
	
EndDo

user Function Criaindice(cAlias)
	
dbselectarea("SX2")
dbsetorder(1)
dbSeek(cAlias)
SX2->(dbSkip())                                                   

While !SX2->(EOF())
    dbSelectarea(SX2->X2_CHAVE)  
    If ChkFile(SX2->X2_CHAVE)
    	//dbsetorder(1)
    	dbCloseArea()
    EndIF	
	SX2->(dbSkip())
EndDo

Static Function NewDlg2()   
Local cTabela := Space(20)

Local oDlg,oGet2,oSBtn4,oSBtn6
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Abrir Tabela"
oDlg:nLeft := 487
oDlg:nTop := 310
oDlg:nWidth := 362
oDlg:nHeight := 139
oDlg:lShowHint := .F.
oDlg:lCentered := .F.

oGet2 := TGET():Create(oDlg)
oGet2:cName := "oGet2"
oGet2:cCaption := "oGet2"
oGet2:nLeft := 103
oGet2:nTop := 14
oGet2:nWidth := 141
oGet2:nHeight := 21
oGet2:lShowHint := .F.
oGet2:lReadOnly := .F.
oGet2:Align := 0
oGet2:cVariable := "cTabela"
oGet2:bSetGet := {|u| If(PCount()>0,cTabela:=u,cTabela) }
oGet2:lVisibleControl := .T.
oGet2:lPassword := .F.
oGet2:lHasButton := .F.

oSBtn4 := SBUTTON():Create(oDlg)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "&OK"
oSBtn4:nLeft := 190
oSBtn4:nTop := 50
oSBtn4:nWidth := 52
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 1
oSBtn4:bAction := {|| AbrirTab(cTabela) }

oSBtn6 := SBUTTON():Create(oDlg)
oSBtn6:cName := "oSBtn6"
oSBtn6:cCaption := "oSBtn6"
oSBtn6:nLeft := 98
oSBtn6:nTop := 49
oSBtn6:nWidth := 52
oSBtn6:nHeight := 22
oSBtn6:lShowHint := .F.
oSBtn6:lReadOnly := .F.
oSBtn6:Align := 0
oSBtn6:lVisibleControl := .T.
oSBtn6:nType := 2
oSBtn6:bAction := {|| Close(oDLG) }

oDlg:Activate()

Return
Static Function AbrirTab(cTabela)

dbSelectArea(AllTrim(cTabela))
if Select(AllTrim(cTabela)) >0
	msgInfo("Tabela "+AllTrim(cTabela)+" aberta")    
Endif	
                                
User Function AbrirTabela()  
NewDlg2()