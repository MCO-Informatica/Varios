#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "msgraphi.ch"

User Function CFMONIT()
Private aTitulos   := {'','Grupo','Descricao','Capacidade'}
Private cQueryCad := ''
Private oConf
Private oDlgConf

Private    oSinal1   := LoadBitmap(GetResources(),"BR_MARROM")
Private    oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private    oSinal3   := LoadBitmap(GetResources(),"BR_AMARELO")
Private    oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private    oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private    oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private    oSinal7   := LoadBitmap(GetResources(),"BR_BRANCO")
Private    oSinal8   := LoadBitmap(GetResources(),"BR_LARANJA")
Private    oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private dDataIni	:=	dDataBase
Private oRecs
Private cRecs := ''
Private oPeds
Private cPeds := ''
Private oCnf1,oCnf2,oCnf3,oCnf4,oCnf5
Private cCnf1:='',cCnf2:='',cCnf3:='',cCnf4:='',cCnf5:=''
Private aMonitor := {{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''}}


MontaQ(@aMonitor,1)

  	DEFINE MSDIALOG oDlgConf TITLE "Monitor Carga Fabrica - De " + DtoC(dDataIni) + " Ate " + DtoC(dDataIni+30) FROM 000, 000  TO 450, 1000 COLORS 0, 16777215 PIXEL

/*	@ 140,005 SAY "Top 5 Conferentes " + SubStr(DtoC(dDataIni),4) + ":"  SIZE 80,10
	@ 140,090 SAY oCnf1 VAR cCnf1 SIZE 200,15 OF oDlgCONF PIXEL
	@ 150,090 SAY oCnf2 VAR cCnf2 SIZE 200,15 OF oDlgCONF PIXEL
	@ 160,090 SAY oCnf3 VAR cCnf3 SIZE 200,15 OF oDlgCONF PIXEL
	@ 170,090 SAY oCnf4 VAR cCnf4 SIZE 200,15 OF oDlgCONF PIXEL
	@ 180,090 SAY oCnf5 VAR cCnf5 SIZE 200,15 OF oDlgCONF PIXEL

	@ 170,150 SAY "Total Pedidos Conferidos:"   SIZE 80,10
	@ 170,220 SAY oPeds VAR cPeds SIZE 40,15 OF oDlgCONF PIXEL
  */

	@ 190,005 SAY "Total Grupos Ativos:"   SIZE 80,10
	@ 190,090 SAY oRecs VAR cRecs SIZE 40,15 OF oDlgCONF PIXEL

	AAdd(aTitulos,DtoC(dDataIni))
	For nI := 1 To 30
		AAdd(aTitulos,DtoC(dDataIni+nI))
	Next

	oTimer := TTimer():New(8000, {|| Processa( {|| MontaQ(@aMonitor,2)   },"Atualizando..." ) }, oDlgConf )
	oTimer:Activate() 
	
	@ 010,003  LISTBOX oConf FIELDS HEADER "" SIZE 490,160  OF oDlgConf PIXEL
	oConf:aColumns  := aTitulos
	oConf:aHeaders  := oConf:aColumns
	
	oConf:SetArray(aMonitor)
	
	oConf:bLine:= {|| {Iif(aMonitor[oConf:nAt,35],oSinal2,oSinal9),;
							aMonitor[oConf:nAt,2],;
							aMonitor[oConf:nAt,3],;
							TransForm(aMonitor[oConf:nAt,4],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,5],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,6],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,7],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,8],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,9],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,10],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,11],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,12],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,13],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,14],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,15],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,16],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,17],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,18],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,19],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,20],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,21],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,22],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,23],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,24],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,25],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,26],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,27],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,28],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,29],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,30],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,31],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,32],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,33],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,34],'@E 999,999.9')}}
						
	
	oConf:nAt := 1
	oConf:refresh()
	oDlgConf:Refresh()

	@ 200, 250 BUTTON "Legenda"  		  			      SIZE 040,015 PIXEL OF oDlgConf ACTION legenda()	OF oDlgConf
	@ 200, 290 Button "Sair" 							  Size 040,015 PIXEL OF oDlgConf Action {||oDlgConf:End()} OF oDlgConf

  ACTIVATE MSDIALOG oDlgConf CENTERED
 
Return .t.



Static Function MontaQ(aMonitor,nVez)

cQueryCad := " SELECT BM_GRUPO, "
cQueryCad += " 		BM_DESC, "
cQueryCad += " 		BM_CAPDIA, "
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni) + "') DIA00, "
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+01) + "') DIA01, "
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+02) + "') DIA02,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+03) + "') DIA03,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+04) + "') DIA04,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+05) + "') DIA05,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+06) + "') DIA06,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+07) + "') DIA07,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+08) + "') DIA08,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+09) + "') DIA09,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+10) + "') DIA10,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+11) + "') DIA11,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+12) + "') DIA12,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+13) + "') DIA13,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+14) + "') DIA14,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+15) + "') DIA15,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+16) + "') DIA16,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+17) + "') DIA17,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+18) + "') DIA18,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+19) + "') DIA19,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+20) + "') DIA20,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+21) + "') DIA21,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+22) + "') DIA22,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+23) + "') DIA23,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+24) + "') DIA24,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+25) + "') DIA25,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+26) + "') DIA26,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+27) + "') DIA27,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+28) + "') DIA28,"
cQueryCad += " 		(SELECT ISNULL(SUM(ZH_SLDGRP),0) FROM " + RetSqlName("SZH") + " ZH (NOLOCK) WHERE ZH.D_E_L_E_T_ = '' AND ZH.ZH_GRUPO = BM.BM_GRUPO AND ZH_DATA = '" + DtoS(dDataIni+29) + "') DIA29 "
cQueryCad += " FROM " + RetSqlName("SBM") + " BM (NOLOCK) "
cQueryCad += " WHERE BM_CAPDIA > 0 "
cQueryCad += " AND BM.D_E_L_E_T_ = '' "
cQueryCad += " ORDER BY BM_GRUPO " 

TCQUERY cQueryCad NEW ALIAS "CONFSTA"

Count To nConf

nRecs := 0
aMonitor := {}

DbSelectArea("CONFSTA")
dbGoTop()

ProcRegua(nConf)
While CONFSTA->(!Eof())
	IncProc()

	lNegativo := .F.
	If CONFSTA->DIA00 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA01 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA02 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA03 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA04 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA05 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA06 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA07 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA08 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA09 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA10 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA11 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA12 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA13 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA14 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA15 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA16 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA17 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA18 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA19 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA20 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA21 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA22 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA23 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA24 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA25 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA26 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA27 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA28 < 0
		lNegativo := .t.
	Endif
	If CONFSTA->DIA29 < 0
		lNegativo := .t.
	Endif
		
	AAdd(aMonitor,{	'',;
					CONFSTA->BM_GRUPO,;
					CONFSTA->BM_DESC,;
					CONFSTA->BM_CAPDIA,;
					CONFSTA->DIA00,;
					CONFSTA->DIA01,;
					CONFSTA->DIA02,;
					CONFSTA->DIA03,;
					CONFSTA->DIA04,;
					CONFSTA->DIA05,;
					CONFSTA->DIA06,;
					CONFSTA->DIA07,;
					CONFSTA->DIA08,;
					CONFSTA->DIA09,;
					CONFSTA->DIA10,;
					CONFSTA->DIA11,;
					CONFSTA->DIA12,;
					CONFSTA->DIA13,;
					CONFSTA->DIA14,;
					CONFSTA->DIA15,;
					CONFSTA->DIA16,;
					CONFSTA->DIA17,;
					CONFSTA->DIA18,;
					CONFSTA->DIA19,;
					CONFSTA->DIA20,;
					CONFSTA->DIA21,;
					CONFSTA->DIA22,;
					CONFSTA->DIA23,;
					CONFSTA->DIA24,;
					CONFSTA->DIA25,;
					CONFSTA->DIA26,;
					CONFSTA->DIA27,;
					CONFSTA->DIA28,;
					CONFSTA->DIA29,;
					lNegativo})
					
	CONFSTA->(dbSkip(1))
Enddo
CONFSTA->(dbCloseArea())

If nVez <> 1
	cRecs := Str(nConf,3)
	
	oConf:SetArray(aMonitor)
	
	oConf:bLine:= {|| {Iif(aMonitor[oConf:nAt,35],oSinal2,oSinal9),;
							aMonitor[oConf:nAt,2],;
							aMonitor[oConf:nAt,3],;
							TransForm(aMonitor[oConf:nAt,4],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,5],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,6],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,7],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,8],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,9],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,10],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,11],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,12],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,13],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,14],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,15],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,16],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,17],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,18],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,19],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,20],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,21],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,22],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,23],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,24],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,25],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,26],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,27],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,28],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,29],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,30],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,31],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,32],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,33],'@E 999,999.9'),;
							TransForm(aMonitor[oConf:nAt,34],'@E 999,999.9')}}
						
	oRecs:Refresh()
	oConf:nAt := 1
	oConf:refresh()
	oDlgConf:Refresh()
Endif
Return aMonitor					

******************************************
Static Function Legenda()
aCorDesc := {{'BR_VERMELHO','Algum Saldo Negativo' },;
			 {'BR_VERDE'   ,'Todos os Saldos Positivos'}}

BrwLegenda( 'Legenda', 'Status', aCorDesc ) //"Legenda"###"Status"
Return



