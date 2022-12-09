#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDossie de Comppras                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 P10 P12                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLNCOM01()
	Private itens
	Private oFont1 := TFont():New("Times New Roman",,018,,.F.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("Times New Roman",,018,,.T.,,,,,.F.,.F.)
	Private oGet1
	Private cGet1 := "      "
	Private oGet10
	Private cGet10 := "      "
	Private oGet11
	Private nGet11 := 0
	Private oGet12
	Private nGet12 := 0
	Private oGet13
	Private nGet13 := 0
	Private oGet14
	Private nGet14 := 0
	Private oGet15
	Private nGet15 := 0
	Private oGet16
	Private nGet16 := 0
	Private oGet17
	Private nGet17 := 0
	Private oGet18
	Private nGet18 := 0
	Private oGet19
	Private cGet19 := ""
	Private oGet20
	Private cGet20 := ""
	Private oGet21
	Private cGet21 := ""
	Private oGet2
	Private cGet2 := "          "
	Private oGet3
	Private cGet3 := "          "
	Private oGet31
	Private oGet32
	Private oGet33
	Private cGet3 := "          "
	Private oGet4
	Private cGet4 := "          "
	Private oGet5
	Private cGet5 := "          "
	Private oGet6
	Private cGet6 := "          "
	Private oGet7
	Private cGet7 := "          "
	Private oGet8
	Private cGet8 := "          "
	Private oGet9
	Private cGet9 := "          "
	Private oGroup1
	Private oGroup2
	Private oSay1
	Private oSay10
	Private oSay11
	Private oSay12
	Private oSay13
	Private oSay14
	Private oSay15
	Private oSay16
	Private oSay17
	Private oSay18
	Private oSay19
	Private oSay02
	Private oSay20
	Private oSay21
	Private oSay22
	Private oSay23
	Private oSay24
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oSay7
	Private oSay8
	Private oSay9
	Private oSButton1
	Private oScrollB11
	Private oScrollB12
	Private oScrollB13
	Private oFolder1
	Private aSize := MsAdvSize(.f.)
	Private aItens	:= {"001"}
	private	oScrollB2 := nil
	Private oDlg
	Private aDados := {}
	Private x	:= 1
	Private cMVpar17	:= 1
	PRIVATE aHeader  := {}			//Header do sistema
	PRIVATE aCols    := {}

	for x := 1 to 15
		SetPrvt("oScrollB1"+cvaltochar(x)+","+"oGroup1"+cvaltochar(x)+","+"oGet3"+cvaltochar(x)+","+"cGet3"+cvaltochar(x)+","+"cGet4"+cvaltochar(x)+","+"oGet4"+cvaltochar(x)+","+"oGet5"+cvaltochar(x)+","+"oGet6"+cvaltochar(x)+","+"oGet7"+cvaltochar(x)+","+"oGet8"+cvaltochar(x)+","+"oGet9"+cvaltochar(x)+","+"oGet10"+cvaltochar(x)+","+"oGet11"+cvaltochar(x)+","+"oGet12"+cvaltochar(x)+","+"oGet13"+cvaltochar(x)+","+"oGet14"+cvaltochar(x)+","+"oGet15"+cvaltochar(x)+","+"oGet16"+cvaltochar(x)+","+"oGet17"+cvaltochar(x)+","+"oGet18"+cvaltochar(x))
		SetPrvt("oGroup2"+cvaltochar(x)+","+"oGroup11"+cvaltochar(x)+","+"oFolder1"+cvaltochar(x))
		SetPrvt("cGet3"+cvaltochar(x)+","+"cGet4"+cvaltochar(x)+","+"cGet5"+cvaltochar(x)+","+"cGet6"+cvaltochar(x)+","+"cGet7"+cvaltochar(x)+","+"cGet8"+cvaltochar(x)+","+"cGet9"+cvaltochar(x)+","+"cGet10"+cvaltochar(x)+","+"nGet11"+cvaltochar(x)+","+"nGet12"+cvaltochar(x)+","+"nGet13"+cvaltochar(x)+","+"nGet14"+cvaltochar(x)+","+"nGet15"+cvaltochar(x)+","+"nGet16"+cvaltochar(x)+","+"nGet17"+cvaltochar(x)+","+"nGet18"+cvaltochar(x))
	next x
	x	:= 1
	DEFINE MSDIALOG oDlg TITLE "Planejamento de Libera็ใo de compras" FROM aSize[7],0 to aSize[6],aSize[5] COLORS 0, 16777215 PIXEL

	@ aSize[7]+5, aSize[2]+10 SAY oSay1 PROMPT "Nบ Solicita็ใo" SIZE 057, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ aSize[7]+5, aSize[2]+60 MSGET oGet2 VAR cGet2 SIZE 051, 011 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont1 F3 "SC1" PIXEL
	@ aSize[7]+5, aSize[2]+120 SAY oSay1 PROMPT "Solicita็ใo Gravada" SIZE 097, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ aSize[7]+5, aSize[2]+190 MSGET oGet3 VAR cGet3 SIZE 051, 011 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont1 F3 "SC1" PIXEL


	oSButton1:=tButton():New(aSize[7]+5,aSize[2]+250,'Salvar',oDlg,{|| alert('grava็ใo')},30,10,,,,.T.)
	oSButton1:=tButton():New(aSize[7]+5,aSize[2]+280,'Listar',oDlg,{|| MsAguarde( { || (IIF(EMPTY(cGet2) .and. EMPTY(cGet3),ALERT('Por Favor Informar a Solicita็ใo'),(limpvar()))) }, "Aguarde...", "Analisando regras de Produto/Compras", .F. )},30,10,,,,.T.)
	oSButton1:=tButton():New(aSize[7]+5,aSize[2]+310,'Sair',oDlg,{|| (list(cGet2),oDlg:end())},30,10,,,,.T.)

	ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณItensslc  บAutor  ณLeandro duarte      บ Data ณ  10/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcria os itens conforme esta na solicita็ใo                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ p11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function Itensslc(cNum)
	Local cQuery := " "
	Local cQuery1 := " "
	Local x := 0
	Local cString	:= ""
	Private vDados := {}
	cQuery := " SELECT * "
	cQuery += "   FROM "+retsqlname("SC1")+" A, "+retsqlname("SB1")+" B,  "+retsqlname("SB2")+" C "
	cQuery += "  WHERE A.C1_FILIAL = '"+xFilial("SC1")+"' "
	cQuery += "    AND A.D_E_L_E_T_ = ' ' "
	cQuery += "    AND B.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "
	cQuery += "    AND C.B2_FILIAL = '"+xFilial("SB2")+"' "
	cQuery += "    AND C.D_E_L_E_T_ = ' ' "
	cQuery += "    AND A.C1_PRODUTO = B.B1_COD "
	cQuery += "    AND A.C1_PRODUTO = C.B2_COD "
	cQuery += "    AND A.C1_NUM = '"+cNum+"' "
	cQuery += "    AND C.B2_LOCAL = '01' "

	oDlg:NBOTTOM := aSize[6]+20
	oDlg:refresh()
	@ aSize[7]+30, aSize[2] SCROLLBOX oScrollB2 HORIZONTAL VERTICAL SIZE aSize[4]-35, aSize[3]-5 OF oDlg BORDER
	itens := TFolder():New( 05, 001, aItens, , oScrollB2,,,, .T., , 641.5, 241.5 )
	cQuery := ChangeQuery( cQuery )
	IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
	while TRBTR->(!eof())
		nSalPedi:=0
		itens:additem(TRBTR->C1_ITEM,.t.)
		aadd(vDados,TRBTR->B1_COD)
		aadd(vDados,TRBTR->B1_DESC)
		aadd(vDados,TRBTR->C1_QUANT)
		IF SC1->( FieldPos("C1_MOTIVO") ) > 0
			aadd(vDados,TRBTR->C1_MOTIVO)
		else
			aadd(vDados,"")
		endif
		aadd(vDados,TRBTR->C1_OBS)
		aadd(vDados,TRBTR->C1_UM)
		aadd(vDados,dtoc(stod(TRBTR->C1_DATPRF)))
		aadd(vDados,TRBTR->C1_SOLICIT)
		aadd(vDados,TRBTR->B2_QATU)
		aadd(vDados,QtdVencidas( TRBTR->B1_COD,  TRBTR->B2_LOCAL ))
		aadd(vDados,QtdEmTerc(  TRBTR->B1_COD,  TRBTR->B2_LOCAL ))
		cQuery1	:= "SELECT SC7.C7_FORNECE, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_NUM, SC7.C7_RESIDUO, SC7.C7_CONAPRO "
		cQuery1 += "FROM "+RetSqlName("SC7")+" SC7 "
		cQuery1 += "WHERE SC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
		cQuery1 += "SC7.C7_PRODUTO='"+TRBTR->B1_COD+"' AND "
		cQuery1 += "SC7.C7_LOCAL='"+TRBTR->B2_LOCAL+"' AND "
		cQuery1 += "(SC7.C7_QUANT-SC7.C7_QUJE)>0 AND "
		cQuery1 += "SC7.C7_RESIDUO = ' ' AND "
		cQuery1 += "SC7.C7_CONAPRO = 'L' AND "
		cQuery1 += "SC7.D_E_L_E_T_=' ' "
		cQuery1 := ChangeQuery( cQuery1 )
		IIF(SELECT("TRBTE")>0,TRBTE->(DBCLOSEAREA()),NIL)
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery1), "TRBTE", .T., .T.)
		while TRBTE->(!eof())
			nSalPedi +=TRBTE->C7_QUANT-TRBTE->C7_QUJE
			TRBTE->(DbSkip())
		Enddo
		aadd(vDados,nSalPedi)
		aadd(vDados,TRBTR->B2_QEMP)
		aadd(vDados,QtdEmPedidos(  TRBTR->B1_COD,  TRBTR->B2_LOCAL ))
		aadd(vDados,QtdDeTerc(  TRBTR->B1_COD,  TRBTR->B2_LOCAL ))
		aadd(vDados,(TRBTR->B2_QATU-TRBTR->B2_QEMP-QtdEmPedidos(  TRBTR->B1_COD,  TRBTR->B2_LOCAL )))
		TRBTR->(dbskip())
		AADD(aDados,vDados)
		vDados := {}
	end
	itens:refresh()
	oDlg:refresh()
	for x:= 1 to len(aDados)
		&("cGet3"+cvaltochar(x))	:= aDados[X][1]
		&("cGet4"+cvaltochar(x))	:= aDados[X][2]
		&("cGet5"+cvaltochar(x))	:= aDados[X][3]
		IF SC1->( FieldPos("C1_MOTIVO") ) > 0
			&("cGet6"+cvaltochar(x))	:= aDados[X][4]
		endif
		&("cGet7"+cvaltochar(x))	:= aDados[X][5]
		&("cGet8"+cvaltochar(x))	:= aDados[X][6]
		&("cGet9"+cvaltochar(x))	:= aDados[X][7]
		&("cGet10"+cvaltochar(x))	:= aDados[X][8]
		&("nGet11"+cvaltochar(x))	:= aDados[X][9]
		&("nGet12"+cvaltochar(x))	:= aDados[X][10]
		&("nGet13"+cvaltochar(x))	:= aDados[X][11]
		&("nGet14"+cvaltochar(x))	:= aDados[X][12]
		&("nGet15"+cvaltochar(x))	:= aDados[X][13]
		&("nGet16"+cvaltochar(x))	:= aDados[X][14]
		&("nGet17"+cvaltochar(x))	:= aDados[X][15]
		&("nGet18"+cvaltochar(x))	:= aDados[X][16]
		//@ 002, 001 SCROLLBOX &("oScrollB1"+cvaltochar(x)) HORIZONTAL VERTICAL SIZE 256, aSize[3]-10 OF itens:aDialogs[x] BORDER
		&("oScrollB1"+cvaltochar(x)):= TScrollBox():New(itens:aDialogs[x],002,001,256, 651.5-10,.T.,.T.,.T.)
		@ 000, 001 GROUP &("oGroup1"+cvaltochar(x)) TO 062, 651.5-15 PROMPT "   Produto   " OF &("oScrollB1"+cvaltochar(x)) COLOR 0, 16777215 PIXEL
		@ 007, 006 SAY oSay02 PROMPT "Produto:" SIZE 035, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 007, 141 SAY oSay3 PROMPT "Descri็ใo:" SIZE 032, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 007, 471 SAY oSay4 PROMPT "Quantidade:" SIZE 039, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 024, 006 SAY oSay5 PROMPT "Motivo:" SIZE 025, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 024, 142 SAY oSay6 PROMPT "Obs:" SIZE 025, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 024, 358 SAY oSay7 PROMPT "Unidade:" SIZE 025, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 024, 434 SAY oSay8 PROMPT "Necessidade:" SIZE 037, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 043, 007 SAY oSay9 PROMPT "Solicitante:" SIZE 033, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 007, 038 MSGET &("oGet3"+cvaltochar(x)) VAR &("cGet3"+cvaltochar(x))  SIZE 078, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 007, 180 MSGET &("oGet4"+cvaltochar(x)) VAR &("cGet4"+cvaltochar(x)) SIZE 285, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 007, 513 MSGET &("oGet5"+cvaltochar(x)) VAR &("cGet5"+cvaltochar(x)) SIZE 055, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 024, 035 MSGET &("oGet6"+cvaltochar(x)) VAR &("cGet6"+cvaltochar(x)) SIZE 097, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 024, 162 MSGET &("oGet7"+cvaltochar(x))  VAR &("cGet7"+cvaltochar(x)) SIZE 188, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 024, 386 MSGET &("oGet8"+cvaltochar(x))  VAR &("cGet8"+cvaltochar(x)) SIZE 042, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 024, 476 MSGET &("oGet9"+cvaltochar(x))  VAR &("cGet9"+cvaltochar(x)) SIZE 093, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 043, 044 MSGET &("oGet10"+cvaltochar(x))  VAR &("cGet10"+cvaltochar(x)) SIZE 180, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 066, 001 GROUP oGroup2 TO 119, 651.5-15 PROMPT "     Estoque     " OF &("oScrollB1"+cvaltochar(x)) COLOR 0, 16777215 PIXEL
		@ 078, 010 SAY oSay10 PROMPT "Atual:" SIZE 075, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 078, 129 SAY oSay11 PROMPT "Vencido:" SIZE 075, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 078, 280 SAY oSay12 PROMPT "Em Terceiros:" SIZE 070, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 078, 422 SAY oSay13 PROMPT "Ped. Compras:" SIZE 074, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 096, 010 SAY oSay14 PROMPT "Qtd Alocada:" SIZE 073, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 096, 130 SAY oSay15 PROMPT "Reservado:" SIZE 073, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 096, 281 SAY oSay16 PROMPT "De Terceiros:" SIZE 073, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 096, 424 SAY oSay17 PROMPT "Disponivel:" SIZE 079, 007 OF &("oScrollB1"+cvaltochar(x)) FONT oFont2 COLORS 16711680, 16777215 PIXEL
		@ 080, 060 MSGET &("oGet11"+cvaltochar(x)) VAR &("nGet11"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 080, 178 MSGET &("oGet12"+cvaltochar(x)) VAR &("nGet12"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 080, 343 MSGET &("oGet13"+cvaltochar(x)) VAR &("nGet13"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 080, 477 MSGET &("oGet14"+cvaltochar(x)) VAR &("nGet14"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 097, 062 MSGET &("oGet15"+cvaltochar(x)) VAR &("nGet15"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 097, 179 MSGET &("oGet16"+cvaltochar(x)) VAR &("nGet16"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 097, 343 MSGET &("oGet17"+cvaltochar(x)) VAR &("nGet17"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 097, 478 MSGET &("oGet18"+cvaltochar(x)) VAR &("nGet18"+cvaltochar(x)) SIZE 060, 010 OF &("oScrollB1"+cvaltochar(x)) COLORS 0, 16777215 READONLY PIXEL
		@ 125, 006 FOLDER oFolder1 SIZE 651.5-25, 96 OF &("oScrollB1"+cvaltochar(x)) ITEMS "Informa็๕es","Consulta de Faturamento","Pedidos de Vendas","Pediddos de Compras","Reservas "," Em terceiros","De Terceiros" COLORS 0, 16777215 PIXEL
		@ 009, 009 SAY oSay18 PROMPT "Media de Vendas durante os 12 meses:" SIZE 146, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		@ 009, 320 SAY oSay19 PROMPT "Media de Compra durante os 12 meses: " SIZE 141, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		@ 030, 321 SAY oSay20 PROMPT "Quantidade da Ultima Compra:" SIZE 103, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		@ 030, 008 SAY oSay21 PROMPT "Quantidade da Ultima Venda:" SIZE 105, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		@ 050, 321 SAY oSay22 PROMPT "Data da Ultima Compra:" SIZE 103, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		@ 050, 008 SAY oSay23 PROMPT "Data da Ultima Venda:" SIZE 105, 017 OF oFolder1:aDialogs[1] FONT oFont2 COLORS 128, 16777215 PIXEL
		fWBrowse2(&("cGet3"+cvaltochar(x)))
		fWBrowse3(&("cGet3"+cvaltochar(x)),cvaltochar(x),&("oScrollB1"+cvaltochar(x)))
		fWBrowse4(&("cGet3"+cvaltochar(x)),cvaltochar(x),&("oScrollB1"+cvaltochar(x)))
		fWBrowse5(&("cGet3"+cvaltochar(x)),cvaltochar(x),&("oScrollB1"+cvaltochar(x)))
		fWBrowse6(&("cGet3"+cvaltochar(x)),cvaltochar(x),&("oScrollB1"+cvaltochar(x)))
		fWBrowse7(&("cGet3"+cvaltochar(x)),cvaltochar(x),&("oScrollB1"+cvaltochar(x)))
	next x
	itens:ShowPage(1)
	oDlg:refresh()
	oScrollB2:refresh()
	itens:refresh()
	x:= 0
	cString := "x:= IIF(itens:nOption=0,1,itens:nOption),"
	aeval(itens:ADIALOGS,{|z| X++,  cString+="itens:ADIALOGS["+cvaltochar(X)+"]:refresh(),oGet3"+cvaltochar(x)+":refresh(),oGet4"+cvaltochar(x)+":refresh(),oGet5"+cvaltochar(x)+":refresh(),oGet6"+cvaltochar(x)+":refresh(),oGet7"+cvaltochar(x)+":refresh(),oGet8"+cvaltochar(x)+":refresh(),oGet9"+cvaltochar(x)+":refresh(),oGet10"+cvaltochar(x)+":refresh(),oGet11"+cvaltochar(x)+":refresh(),oGet12"+cvaltochar(x)+":refresh(),oGet13"+cvaltochar(x)+":refresh(),oGet14"+cvaltochar(x)+":refresh(),oGet15"+cvaltochar(x)+":refresh(),oGet16"+cvaltochar(x)+":refresh(),oGet17"+cvaltochar(x)+":refresh(),oGet18"+cvaltochar(x)+":refresh()," })
	cString := substr(cString,1,len(cString)-1)+",itens:refresh(),oScrollB2:refresh()"
	cString := "{|| "+cString+" } "
	FOR NS := 1 TO LEN(itens:ADIALOGS)
		itens:ADIALOGS[NS]:BGOTFOCUS  := &(cString)
		//	itens:ADIALOGS[NS]:BWHEN  := &(cString)
	NEXT NS
	itens:bSetOption := &(cString)
	x:= 1

	oDlg:refresh()
	oScrollB2:refresh()
	itens:refresh()
	oGet31:Setfocus()
Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse2 บAutor  ณLEANDRO DUARTE      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta de Faturamento                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse2(cProd)
	Local cQuery2			//aCols do Sistema
	Local oGet						//GetDados Principal
	Local nMes		:= MONTH(ddatabase)
	Local nAno		:= year(ddatabase)
	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := buscdad2(cProd)

	AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	AAdd(aHeader,{"Janeiro "+iif(nMes>=1,cValtoChar(nAno),cValtoChar(nAno-1))   		, "nJan"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Fevereiro "+iif(nMes>=2,cValtoChar(nAno),cValtoChar(nAno-1)) 		, "nFev"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Mar็o "+iif(nMes>=3,cValtoChar(nAno),cValtoChar(nAno-1))     		, "nMar"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Abril "+iif(nMes>=4,cValtoChar(nAno),cValtoChar(nAno-1))     		, "nAbr"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Maio "+iif(nMes>=5,cValtoChar(nAno),cValtoChar(nAno-1))      		, "nMai"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Junho "+iif(nMes>=6,cValtoChar(nAno),cValtoChar(nAno-1))     		, "nJun"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Julho "+iif(nMes>=7,cValtoChar(nAno),cValtoChar(nAno-1))    		, "nJul"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Agosto "+iif(nMes>=8,cValtoChar(nAno),cValtoChar(nAno-1))    		, "nAgo"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Setembro "+iif(nMes>=9,cValtoChar(nAno),cValtoChar(nAno-1))  		, "nSet"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Outubro "+iif(nMes>=10,cValtoChar(nAno),cValtoChar(nAno-1))   		, "nOut"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Novembro "+iif(nMes>=11,cValtoChar(nAno),cValtoChar(nAno-1))  		, "nNov"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Dezembro "+iif(nMes>=12,cValtoChar(nAno),cValtoChar(nAno-1))  		, "nDez"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})

	//aCols := {{"",'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,.F.}}

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[2],@aHeader,@aCols)
	oGet:ForceRefresh()
	oFolder1:aDialogs[2]:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse3 บAutor  ณLEANDRO DUARTE      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPEDIDO DE VENDAS                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse3(cProd,cX, oTela)
	Local cQuery2
	Local oGet

	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := PedVEN(cProd, '01')

	AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	AAdd(aHeader,{"Entrega"   		, "dJan"    ,"" ,8,0,'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Taxa da Moeda"	, "nMoed"   ,PesqPict('SC6','C6_XTAXA') ,TamSX3("C6_XTAXA")[1],TamSX3("C6_XTAXA")[2],'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Moeda"	, "nMoed2"   ,PesqPict('SC6','C6_XMOEDA'),TamSX3("C6_XMOEDA")[1],TamSX3("C6_XMOEDA")[2],'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Quantidade Vendida"  , "nVend"    ,PesqPict('SC6','C6_QTDVEN'),TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Pre็o de Venda" , "nPrcv"    ,PesqPict('SC6','C6_PRCVEN'),TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Total" , "nTotal"    ,PesqPict('SC6','C6_VALOR'),TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nr.do Pedido"     	, "cPed"    ,"@!" ,6,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	//aCols := {{"",'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,.F.}}

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[3],@aHeader,@aCols)

	oGet:ForceRefresh()
	oFolder1:aDialogs[3]:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse4 บAutor  ณLEANDRO DUARTE      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPEDIDO DE COMPRAS                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse4(cProd,cX, oTela)
	Local cQuery2
	Local oGet

	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := C010PedCom(cProd, '01')

	AAdd(aHeader,{"Fornecedor"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	AAdd(aHeader,{"Entrega"   		, "dJan"    ,"" ,8,0,'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Chegada" 		, "dFev"    ,"" ,8,2,'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Quantidade"     	, "nMar"    ,"@E 9,999,999,999.99" ,13,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nr Pedido"     	, "nAbr"    ,"@!" ,6,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nr.Processo Importa็ใo"     	, "nMai"    ,"@!" ,6,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	//aCols := {{"",'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,.F.}}

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[4],@aHeader,@aCols)

	oGet:ForceRefresh()
	oFolder1:aDialogs[4]:Refresh()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse5 บAutor  ณlEANDRO dUARTE      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCONSULTA DE RESERVA                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse5(cProd,cX, oTela)
	Local cQuery2
	Local oGet

	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := RESERV(cProd, '01')

	AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	AAdd(aHeader,{"Entrega"   		, "dJan"    ,"" ,8,0,'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Taxa da Moeda"	, "nMoed"   ,PesqPict('SC6','C6_XTAXA') ,TamSX3("C6_XTAXA")[1],TamSX3("C6_XTAXA")[2],'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Moeda"	, "nMoed2"   ,PesqPict('SC6','C6_XMOEDA'),TamSX3("C6_XMOEDA")[1],TamSX3("C6_XMOEDA")[2],'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Quantidade Vendida"  , "nVend"    ,PesqPict('SC6','C6_QTDVEN'),TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Pre็o de Venda" , "nPrcv"    ,PesqPict('SC6','C6_PRCVEN'),TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Total" , "nTotal"    ,PesqPict('SC6','C6_VALOR'),TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nr.do Pedido"     	, "cPed"    ,"@!" ,6,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	//aCols := {{"",'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,.F.}}

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[5],@aHeader,@aCols)

	oGet:ForceRefresh()
	oFolder1:aDialogs[5]:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse6 บAutor  ณlEANDRO dUARTE      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCONSULTA EM TERCEIROS                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse6(cProd,cX, oTela)
	Local cQuery2
	Local oGet

	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := DEEM_TERC(cProd, '01','E')

	AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Saldo"   		, "nSaldo"    ,PesqPict('SB6','B6_SALDO') ,TamSX3("B6_SALDO")[1],TamSX3("B6_SALDO")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Documento"   	, "cDoc"    ,PesqPict('SB6','B6_DOC') ,TamSX3("B6_DOC")[1],TamSX3("B6_DOC")[2],'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[6],@aHeader,@aCols)

	oGet:ForceRefresh()
	oFolder1:aDialogs[6]:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWBrowse7 บAutor  ณlEANDRO DUARTE      บ Data ณ  02/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA DE APRESENTAวรO DE ACOLS DE TERCEIRO                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fWBrowse7(cProd,cX, oTela)
	Local cQuery2
	Local oGet

	aHeader  := {}			//Header do sistema
	aCols    := {}
	aCols := DEEM_TERC(cProd, '01','D')

	AAdd(aHeader,{"Cliente"   , "cNREDUZ" ,"" ,TamSX3("A1_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Saldo"   		, "nSaldo"    ,PesqPict('SB6','B6_SALDO') ,TamSX3("B6_SALDO")[1],TamSX3("B6_SALDO")[2],'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Documento"   	, "cDoc"    ,PesqPict('SB6','B6_DOC') ,TamSX3("B6_DOC")[1],TamSX3("B6_DOC")[2],'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	oGet := MsNewGetDados():New( 5, 5, 77, 651.5-30, 2, "AllwaysTrue",,,,1,Len(aCols),,,,oFolder1:aDialogs[7],@aHeader,@aCols)

	oGet:ForceRefresh()
	oFolder1:aDialogs[7]:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function list(cNum)
	Local cQuery := " SELECT * FROM "+retsqlname("SC1")+" A, "+retsqlname("SB1")+" B WHERE A.C1_FILIAL = '"+xFilial("SC1")+"' AND A.D_E_L_E_T_ = ' ' AND B.B1_FILIAL = '"+xFilial("SB1")+"' AND B.D_E_L_E_T_ = ' ' AND A.C1_PRODUTO = B.B1_COD AND A.C1_NUM = '"+cNum+"' "
	Local aRet		:= {}
	cQuery := ChangeQuery( cQuery )
	IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
	while TRBTR->(!eof())
		AADD(aRet,'1')
		TRBTR->(dbskip())
	end
RETURN(aRet)
USER FUNCTION APRESEN()

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdVencidas( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB8")
	SB8->( dbsetorder(1) )
	SB8->( dbseek( xFilial( "SB8" ) + cProduto ) )
	Do While .not. SB8->( Eof() ) .and. xFilial( "SB8" ) == SB8->B8_FILIAL .and. SB8->B8_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB8->B8_LOCAL != cLocal
				SB8->( dbSkip() )
				Loop
			Endif
		Endif

		if SB8->B8_DTVALID < dDataBase
			nRet := nRet + SB8->B8_SALDO
		endif

		SB8->( dbskip() )
	EndDo

	RestArea(aArea)
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdEmTerc( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB6")
	SB6->( dbsetorder(2) )
	SB6->( dbseek( xFilial( "SB6" ) + cProduto ) )
	Do While .not. SB6->( Eof() ) .and. xFilial( "SB6" ) == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB6->B6_LOCAL != cLocal
				SB6->( dbSkip() )
				Loop
			Endif
		Endif

		if SB6->B6_TIPO == "E" .and. SB6->B6_PODER3 == "R" .and. Empty( SB6->B6_ATEND ) .and. SB6->B6_TES != '641'
			nRet := nRet + SB6->B6_SALDO
		endif

		SB6->( dbskip() )

	EndDo

	RestArea(aArea)
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdDeTerc( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB6")
	SB6->( dbsetorder(2) )
	SB6->( dbseek( xFilial( "SB6" ) + cProduto ) )
	Do While .not. SB6->( Eof() ) .and. xFilial( "SB6" ) == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB6->B6_LOCAL != cLocal
				SB6->( dbSkip() )
				Loop
			Endif
		Endif

		if SB6->B6_TIPO == "D" .and. SB6->B6_PODER3 == "R" .and. Empty( SB6->B6_ATEND )
			nRet := nRet + SB6->B6_SALDO
		endif

		SB6->( dbskip() )
	EndDo

	RestArea(aArea)
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdEmPedidos( cProduto, cLocal )
	Local aArea		:= GetArea()
	Local nRet 		:= 0
	Local nQtd 		:= 0
	Local _nReg6   	:= SC6->( recno() )
	Local _nReg5   	:= SC5->( recno() )

	Default cLocal := ""

	dbSelectArea( "SC5" )
	SC5->( dbSetOrder(1) )

	dbSelectArea( "SC6" )
	SC6->( dbSetOrder(2) )
	SC6->( dbSeek( xFilial("SC6") + cProduto ) )
	DO While .not. SC6->( Eof() ) .And. SC6->C6_FILIAL == xFilial( "SC6" ) .And. SC6->C6_PRODUTO == cProduto

		If SC6->C6_BLQ == "R "
			SC6->( dbSkip() )
			Loop
		Endif

		If SC5->( dbSeek( xFilial( "SC5" ) + SC6->C6_NUM ) )
			If SC5->C5_X_CANC == "C" .or. SC5->C5_EMISSAO < Ctod("01/03/2010")
				SC6->( dbSkip() )
				Loop
			Endif
		Endif

		If !Empty( cLocal )
			If SC6->C6_LOCAL != cLocal
				SC6->( dbSkip() )
				Loop
			Endif
		Endif

		nQtd := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		if nQtd < 0
			nQtd := 0
		endif

		nRet := nRet + nQtd

		SC6->( dbSkip() )

	ENDDO

	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )
	RestArea(aArea)
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  10/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function buscdad2(cProd)
	Local aRet := {}
	local cQry := "SELECT DISTINCT "
	cQry += "  X.B1_FILIAL, X.B1_COD,	X.B1_DESC "
	cQry += "FROM "
	cQry += "  ( "

	cQry += "   SELECT "
	cQry += "     XFAT.B1_FILIAL, XFAT.B1_COD, XFAT.B1_DESC, XFAT.A1_NREDUZ, XFAT.D2_EMISSAO, SUM(XFAT.D2_TOTAL) D2_TOTAL "
	cQry += "   FROM "
	cQry += "     ( "
	cQry += "      SELECT
	cQry += "        SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_DESC, SA1.A1_NREDUZ, SUBSTR(D2_EMISSAO,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += "    SUM(SD2.D2_VALBRUT) AS D2_TOTAL "
	Else
		cQry += "    SUM(SD2.D2_QUANT) AS D2_TOTAL "
	Endif
	cQry += "  	   FROM " + RetSQLName("SD2")+ " SD2 "
	cQry += "	     INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQry += "    	   SF4.F4_FILIAL = '" + xFilial("SF4") + "' "
	cQry += "		   AND SD2.D2_TES = SF4.F4_CODIGO "
	cQry += "		   AND SF4.F4_DUPLIC = 'S' "
	cQry += "		   AND SF4.F4_ISS <> 'S' "
	cQry += "	       AND SF4.D_E_L_E_T_ = ' ' "
	cQry += "	     INNER JOIN " + RetSqlName("SB1") + " SB1 ON  "
	cQry += "		   SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQry += "		   AND SB1.B1_COD = SD2.D2_COD "
	cQry += "		   AND SB1.D_E_L_E_T_ = ' ' "
	cQry += "	     LEFT JOIN (SELECT DISTINCT A3_FILIAL, A3_CODUSR FROM "  + RetSqlName("SA3") + " SA3 WHERE SA3.D_E_L_E_T_ = ' ' ) ON "
	cQry += "		   A3_FILIAL = '  '  "
	cQry += "	   	 INNER JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQry += "		   SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
	cQry += "		   AND SF2.F2_DOC = SD2.D2_DOC "
	cQry += "		   AND SF2.F2_SERIE = SD2.D2_SERIE "
	cQry += "		   AND SF2.D_E_L_E_T_ = ' ' "
	cQry += "		 INNER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQry += "		   SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQry += "		   AND SA1.A1_COD = SD2.D2_CLIENTE "
	cQry += "		   AND SA1.A1_LOJA = SD2.D2_LOJA "
	cQry += "		   AND SA1.D_E_L_E_T_ = ' ' "
	cQry += "		 LEFT JOIN " + RetSqlName("SD1") + " SD1 ON "
	cQry += "		   SD1.D1_FILIAL = '" + xFilial("SD1") + "' "
	cQry += "		   AND SD1.D1_NFORI = SD2.D2_DOC "
	cQry += "		   AND SD1.D1_SERIORI = SD2.D2_SERIE "
	cQry += "          AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_TIPO = 'D' "
	cQry += "		   AND SD1.D_E_L_E_T_ = ' ' "
	cQry += "	   WHERE "
	cQry += "	     D2_FILIAL = '" + xFilial("SD2") + "' "
	cQry += "	     AND D2_COD = '"+cProd+"' "
	cQry += "		 AND SD2.D2_TIPO IN ('N','C','I','P') "
	cQry += "		 AND SD2.D_E_L_E_T_ = ' ' "
	cQry += "        AND SUBSTR(D2_EMISSAO,1,4) <= '"+SUBSTR(DTOS(DDATABASE),1,4)+"' "
	cQry += "      GROUP BY B1_FILIAL, B1_COD, B1_DESC, A1_NREDUZ,SUBSTR(D2_EMISSAO,5,2) "
	cQry += "      UNION ALL "
	cQry += "      SELECT "  +CRLF
	cQry += "        SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_DESC, SA1.A1_NREDUZ, SUBSTR(D1_DTDIGIT,5,2) AS D2_EMISSAO, "
	If cMVpar17 == 1
		cQry += "    SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS D2_TOTAL"  +CRLF
	Else
		cQry += "	 SUM(SD1.D1_QUANT * -1) AS D2_TOTAL "	 +CRLF
	Endif
	cQry += "      FROM "  +CRLF
	cQry += "     " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "  +CRLF
	cQry += "          SD2.D2_FILIAL = SD1.D1_FILIAL AND "  +CRLF
	cQry += "          SD1.D1_NFORI = SD2.D2_DOC AND "  +CRLF
	cQry += "          SD1.D1_SERIORI = SD2.D2_SERIE AND "  +CRLF
	cQry += "          SD1.D1_ITEMORI = SD2.D2_ITEM AND "  +CRLF
	cQry += "          SD2.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "        JOIN " + RetSqlName("SF2") + " SF2 ON "  +CRLF
	cQry += "          SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "  +CRLF
	cQry += "          SD1.D1_NFORI = SF2.F2_DOC AND "  +CRLF
	cQry += "          SD1.D1_SERIORI = SF2.F2_SERIE AND "  +CRLF
	cQry += "          SF2.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "   	  JOIN " + RetSqlName("SB1") + " SB1 ON "  +CRLF
	cQry += "   	    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "  +CRLF
	cQry += "    	    SD1.D1_COD = SB1.B1_COD AND "  +CRLF
	cQry += "    	    SB1.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "        JOIN " + RetSqlName("SA1") + " SA1 ON "  +CRLF
	cQry += "    	    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "  +CRLF
	cQry += "          SD1.D1_FORNECE = SA1.A1_COD AND "  +CRLF
	cQry += "          SD1.D1_LOJA = SA1.A1_LOJA AND "  +CRLF
	cQry += "          SA1.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "        JOIN " + RetSqlName("SF4") + " SF4 ON "  +CRLF
	cQry += "          SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "  +CRLF
	cQry += "          SF4.D_E_L_E_T_ = ' ' AND "  +CRLF
	cQry += "          SD1.D1_TES = SF4.F4_CODIGO "  +CRLF
	cQry += "        LEFT JOIN "+RetSQLName("SBM")+" SBM " +CRLF
	cQry += "          ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' "  +CRLF
	cQry += "          AND SB1.B1_GRUPO = SBM.BM_GRUPO "  +CRLF
	cQry += "          AND SBM.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "      WHERE "  +CRLF
	cQry += "         SUBSTR(SD1.D1_DTDIGIT,1,4) <= '"+SUBSTR(DTOS(DDATABASE),1,4)+"'  "   +CRLF
	cQry += "         AND SD1.D1_FILIAL = '" + xFilial("SD1") + "' "  +CRLF
	cQry += "         AND SD1.D_E_L_E_T_ = ' ' "  +CRLF
	cQry += "         AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "  +CRLF
	cQry += "         AND SD1.D1_TIPO = 'D'  "  +CRLF
	cQry += "         AND SD1.D1_COD = '"+cProd+"' "  +CRLF
	cQry += "      GROUP BY B1_FILIAL, B1_COD, B1_DESC,	A1_NREDUZ,SUBSTR(D1_DTDIGIT,5,2) "
	cQry += "   ) XFAT "
	cQry += "   WHERE D2_TOTAL > 0 "
	cQry += "   GROUP BY B1_FILIAL, B1_COD, B1_DESC, A1_NREDUZ, D2_EMISSAO	"
	cQry += " )X "
	cQry += "ORDER BY X.B1_FILIAL, X.B1_COD "

	cQry := ChangeQuery( cQry )
	IIF(SELECT("TRBTA")>0,TRBTA->(DBCLOSEAREA()),NIL)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), "TRBTA", .T., .T.)
	IF TRBTA->(!EOF())
		cQry := " SELECT XFAT.B1_COD,  "  +CRLF
		cQry += "        XFAT.A1_NREDUZ,  "  +CRLF
		cQry += "        XFAT.D2_EMISSAO,  "  +CRLF
		cQry += "        SUM(XFAT.D2_TOTAL) D2_TOTAL  "  +CRLF
		cQry += "   FROM (SELECT SB1.B1_COD,  "  +CRLF
		cQry += "                SA1.A1_NREDUZ,  "  +CRLF
		cQry += "                SUBSTR(D2_EMISSAO, 5, 2) AS D2_EMISSAO,  "  +CRLF
		cQry += "                SUM(SD2.D2_VALBRUT) AS D2_TOTAL  "  +CRLF
		cQry += "           FROM " + RetSqlName("SD2")+" SD2  "  +CRLF
		cQry += "          INNER JOIN " + RetSqlName("SF4")+" SF4  "  +CRLF
		cQry += "             ON SF4.F4_FILIAL = '" + xFilial("SF4") + "'  "  +CRLF
		cQry += "            AND SD2.D2_TES = SF4.F4_CODIGO  "  +CRLF
		cQry += "            AND SF4.F4_DUPLIC = 'S'  "  +CRLF
		cQry += "            AND SF4.F4_ISS <> 'S'  "  +CRLF
		cQry += "            AND SF4.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "          INNER JOIN " + RetSqlName("SB1")+" SB1  "  +CRLF
		cQry += "             ON SB1.B1_FILIAL = '" + xFilial("SB1") + "'  "  +CRLF
		cQry += "            AND SB1.B1_COD = SD2.D2_COD  "  +CRLF
		cQry += "            AND SB1.B1_GRUPO BETWEEN '    ' AND 'ZZZZ'  "  +CRLF
		cQry += "            AND SB1.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           LEFT JOIN (SELECT DISTINCT A3_FILIAL, A3_CODUSR  "  +CRLF
		cQry += "                       FROM " + RetSqlName("SA3")+" SA3  "  +CRLF
		cQry += "                      WHERE SA3.D_E_L_E_T_ = ' ')  "  +CRLF
		cQry += "             ON A3_FILIAL = '" + xFilial("SA3") + "'  "  +CRLF
		//cQry += "            AND A3_CODUSR = '000014'  "  +CRLF
		cQry += "          INNER JOIN " + RetSqlName("SF2")+" SF2  "  +CRLF
		cQry += "             ON SF2.F2_FILIAL = '" + xFilial("SF2") + "'  "  +CRLF
		cQry += "            AND SF2.F2_DOC = SD2.D2_DOC  "  +CRLF
		cQry += "            AND SF2.F2_SERIE = SD2.D2_SERIE  "  +CRLF
		//cQry += "            AND SF2.F2_VEND1 BETWEEN '      ' AND 'zzzzz '  "  +CRLF
		cQry += "            AND SF2.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "          INNER JOIN " + RetSqlName("SA1")+" SA1  "  +CRLF
		cQry += "             ON SA1.A1_FILIAL = '" + xFilial("SA1") + "'  "  +CRLF
		cQry += "            AND SA1.A1_COD = SD2.D2_CLIENTE  "  +CRLF
		cQry += "            AND SA1.A1_LOJA = SD2.D2_LOJA  "  +CRLF
		//cQry += "            AND SA1.A1_COD BETWEEN '      ' AND 'ZZZZZZ'  "  +CRLF
		//cQry += "            AND SA1.A1_LOJA BETWEEN '  ' AND 'ZZ'  "  +CRLF
		//cQry += "            AND SA1.A1_GRPVEN BETWEEN '000001' AND '999999'  "  +CRLF
		cQry += "            AND SA1.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           LEFT JOIN " + RetSqlName("SD1")+" SD1  "  +CRLF
		cQry += "             ON SD1.D1_FILIAL = '" + xFilial("SD1") + "'  "  +CRLF
		cQry += "            AND SD1.D1_NFORI = SD2.D2_DOC  "  +CRLF
		cQry += "            AND SD1.D1_SERIORI = SD2.D2_SERIE  "  +CRLF
		cQry += "            AND SD1.D1_ITEMORI = SD2.D2_ITEM  "  +CRLF
		cQry += "            AND SD1.D1_TIPO = 'D'  "  +CRLF
		cQry += "            AND SD1.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "          WHERE D2_FILIAL = '" + xFilial("SD2") + "'  "  +CRLF
		//cQry += "            AND D2_COD BETWEEN '               ' AND 'ZZZZZZZZZZZ    '  "  +CRLF
		cQry += "            AND SD2.D2_TIPO IN ('N', 'C', 'I', 'P')  "  +CRLF
		cQry += "            AND SD2.D_E_L_E_T_ = ' '  "  +CRLF
		//cQry += "            AND SB1.B1_SEGMENT = '000003'  "  +CRLF
		cQry += "            AND D2_COD = '"+cProd+"' "  +CRLF
		cQry += "            AND SUBSTR(D2_EMISSAO, 5, 2) <= '"+SUBSTR(DTOS(DDATABASE),1,6)+"'  "  +CRLF
		cQry += "          GROUP BY B1_COD, A1_NREDUZ, SUBSTR(D2_EMISSAO, 5, 2)  "  +CRLF
		cQry += "         UNION ALL  "  +CRLF
		cQry += "         SELECT SB1.B1_COD,  "  +CRLF
		cQry += "                SA1.A1_NREDUZ,  "  +CRLF
		cQry += "                SUBSTR(D1_DTDIGIT, 5, 2) AS D2_EMISSAO,  "  +CRLF
		cQry += "                SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS D2_TOTAL  "  +CRLF
		cQry += "           FROM " + RetSqlName("SD1")+" SD1  "  +CRLF
		cQry += "           JOIN " + RetSqlName("SD2")+" SD2  "  +CRLF
		cQry += "             ON SD2.D2_FILIAL = SD1.D1_FILIAL  "  +CRLF
		cQry += "            AND SD1.D1_NFORI = SD2.D2_DOC  "  +CRLF
		cQry += "            AND SD1.D1_SERIORI = SD2.D2_SERIE  "  +CRLF
		cQry += "            AND SD1.D1_ITEMORI = SD2.D2_ITEM  "  +CRLF
		cQry += "            AND SD2.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           JOIN " + RetSqlName("SF2")+" SF2  "  +CRLF
		cQry += "             ON SF2.F2_FILIAL = '" + xFilial("SF2") + "'  "  +CRLF
		cQry += "            AND SD1.D1_NFORI = SF2.F2_DOC  "  +CRLF
		cQry += "            AND SD1.D1_SERIORI = SF2.F2_SERIE  "  +CRLF
		cQry += "            AND SF2.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           JOIN " + RetSqlName("SB1")+" SB1  "  +CRLF
		cQry += "             ON SB1.B1_FILIAL = '" + xFilial("SB1") + "'  "  +CRLF
		cQry += "            AND SD1.D1_COD = SB1.B1_COD  "  +CRLF
		cQry += "            AND SB1.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           JOIN " + RetSqlName("SA1")+" SA1  "  +CRLF
		cQry += "             ON SA1.A1_FILIAL = '" + xFilial("SA1") + "'  "  +CRLF
		cQry += "            AND SD1.D1_FORNECE = SA1.A1_COD  "  +CRLF
		cQry += "            AND SD1.D1_LOJA = SA1.A1_LOJA  "  +CRLF
		cQry += "            AND SA1.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "           JOIN " + RetSqlName("SF4")+" SF4  "  +CRLF
		cQry += "             ON SF4.F4_FILIAL = '" + xFilial("SF4") + "'  "  +CRLF
		cQry += "            AND SF4.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "            AND SD1.D1_TES = SF4.F4_CODIGO  "  +CRLF
		cQry += "           LEFT JOIN " + RetSqlName("SBM")+" SBM  "  +CRLF
		cQry += "             ON SBM.BM_FILIAL = '" + xFilial("SBM") + "'  "  +CRLF
		cQry += "            AND SB1.B1_GRUPO = SBM.BM_GRUPO  "  +CRLF
		cQry += "            AND SBM.D_E_L_E_T_ = ' '  "  +CRLF
		cQry += "          WHERE SUBSTR(SD1.D1_DTDIGIT, 5, 2) <= '"+SUBSTR(DTOS(DDATABASE),1,6)+"' "  +CRLF
		//cQry += "            AND SD1.D1_FORNECE BETWEEN '      ' AND 'ZZZZZZ'  "  +CRLF
		//cQry += "            AND SD1.D1_LOJA BETWEEN '  ' AND 'ZZ'  "  +CRLF
		cQry += "            AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'  "  +CRLF
		cQry += "            AND SD1.D_E_L_E_T_ = ' '  "  +CRLF
		//cQry += "            AND SF2.F2_VEND1 BETWEEN '      ' AND 'zzzzz '  "  +CRLF
		//cQry += "            AND SB1.B1_GRUPO BETWEEN '    ' AND 'ZZZZ'  "  +CRLF
		cQry += "            AND SF4.F4_DUPLIC = 'S'  "  +CRLF
		cQry += "            AND SF4.F4_ISS <> 'S'  "  +CRLF
		cQry += "            AND SD1.D1_TIPO = 'D'  "  +CRLF
		//cQry += "            AND SA1.A1_GRPVEN BETWEEN '000001' AND '999999'  "  +CRLF
		//cQry += "            AND SD1.D1_COD BETWEEN '               ' AND 'ZZZZZZZZZZZ    '  "  +CRLF
		//cQry += "            AND SB1.B1_SEGMENT = '000003'  "  +CRLF
		cQry += "            AND D1_COD = '"+cProd+"'  "  +CRLF
		cQry += "          GROUP BY B1_COD, A1_NREDUZ, SUBSTR(D1_DTDIGIT, 5, 2)) XFAT  "  +CRLF
		cQry += "  GROUP BY B1_COD, A1_NREDUZ, D2_EMISSAO  "  +CRLF
		cQry += "  ORDER BY B1_COD, A1_NREDUZ, D2_EMISSAO  "  +CRLF


		cQry := ChangeQuery( cQry )
		IIF(SELECT("TRBTB")>0,TRBTB->(DBCLOSEAREA()),NIL)
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), "TRBTB", .T., .T.)

		While TRBTB->(!Eof())

			If TRBTB->D2_TOTAL > 0
				If (nPos := aScan(aRet,{|x| x[1] == TRBTB->A1_NREDUZ}  )) <= 0
					AAdd(aRet,{TRBTB->A1_NREDUZ,0,0,0,0,0,0,0,0,0,0,0,0,.F.})
					nPos := Len(aRet)
				EndIf

				aRet[nPos,VAL(TRBTB->D2_EMISSAO)+1] := TRBTB->D2_TOTAL


			Endif

			TRBTB->(dbSkip())
		End
		nqw := 0
		AAdd(aRet,{"TOTAL",0,0,0,0,0,0,0,0,0,0,0,0,.f.})
		For nFor5 := 2 to 13
			Aeval(aRet,{|z| nqw += z[nFor5] })
			aRet[len(aRet)][nFor5] := nqw
			nqw := 0
		next nfor5

	ELSE
		aadd(aRet,{"",0,0,0,0,0,0,0,0,0,0,0,0,.F.})
	ENDIF
return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function C010PedCom(cProduto, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local _d
	Local aArea := GetArea()
	Local aCols     := {}

	cArqQry := "QUERYSC7"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSC7.C7_FORNECE, QUERYSC7.C7_DATPRF, QUERYSC7.C7_QUANT, QUERYSC7.C7_QUJE, QUERYSC7.C7_NUM, QUERYSC7.C7_RESIDUO, QUERYSC7.C7_CONAPRO "
	cQuery += "FROM "+RetSqlName("SC7")+" QUERYSC7 "
	cQuery += "WHERE QUERYSC7.C7_FILIAL='"+xFilial("SC7")+"' AND "
	cQuery += "QUERYSC7.C7_PRODUTO='"+cProduto+"' AND "
	cQuery += "QUERYSC7.C7_LOCAL='"+cLocal+"' AND "
	cQuery += "QUERYSC7.C7_EMISSAO BETWEEN '"+DTOS(DDATABASE-380)+"' AND '"+DTOS(DDATABASE)+"'  AND "
	cQuery += "(QUERYSC7.C7_QUANT-QUERYSC7.C7_QUJE)>0 AND "
	cQuery += "QUERYSC7.C7_RESIDUO = ' ' AND "
	cQuery += "QUERYSC7.C7_CONAPRO = 'L' AND "
	cQuery += "QUERYSC7.D_E_L_E_T_=' ' "
	IIF(SELECT((cArqQry))>0,(cArqQry)->(DBCLOSEAREA()),NIL)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While (cArqQry)->(!eof())
		_aAux := {}
		SA2->( dbSeek( xFilial("SA2") + (cArqQry)->C7_FORNECE ) )
		_d := STOD( (cArqQry)->C7_DATPRF )

		aadd(_aAux, SA2->A2_NREDUZ )
		aadd(_aAux, _d )
		aadd(_aAux, ctod(" ") )   // Data de Chegada
		aadd(_aAux, (cArqQry)->C7_QUANT-(cArqQry)->C7_QUJE )
		aadd(_aAux, (cArqQry)->C7_NUM )
		aadd(_aAux, " " )   // Nr. Proc. Importa็ใo
		aadd(_aAux, .F. )   // Nr. Proc. Importa็ใo

		aadd(aCols,_aAux)

		(cArqQry)->(DbSkip())
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),ctod( " " ),ctod( " " ), 0.00,space(06),space(06),.F.})
	endif
return(acols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPedVen    บAutor  ณLeandro duarte      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLista os pedidos de vendas                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PedVen(cProduto, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local _d
	Local aArea := GetArea()
	Local aCols     := {}

	cArqQry := "QUERYSC6"
	lQuery  := .T.
	cQuery  := "SELECT * "
	cQuery += "FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5 "
	cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
	cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
	cQuery += "SC6.C6_PRODUTO='"+cProduto+"' AND "
	cQuery += "SC6.C6_LOCAL='"+cLocal+"' AND "
	cQuery += "SC6.C6_NUM = SC5.C5_NUM AND "
	cQuery += "SC6.C6_ENTREG BETWEEN '"+DTOS(DDATABASE-380)+"' AND '"+DTOS(DDATABASE)+"'  AND "
	cQuery += "SC6.D_E_L_E_T_=' ' AND "
	cQuery += "SC5.D_E_L_E_T_=' ' "
	IIF(SELECT((cArqQry))>0,(cArqQry)->(DBCLOSEAREA()),NIL)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While (cArqQry)->(!eof())
		_aAux := {}
		SA1->( dbSeek( xFilial("SA1") + (cArqQry)->C5_CLIENTE+(cArqQry)->C5_LOJACLI ) )

		aadd(_aAux, SA1->A1_NREDUZ )
		aadd(_aAux, STOD((cArqQry)->C6_ENTREG) )
		aadd(_aAux, (cArqQry)->C6_XTAXA   )
		aadd(_aAux, (cArqQry)->C6_XMOEDA   )   // Data de Chegada
		aadd(_aAux, (cArqQry)->C6_QTDVEN  )
		aadd(_aAux,  (cArqQry)->C6_PRCVEN )
		aadd(_aAux,  (cArqQry)->C6_VALOR )
		aadd(_aAux, (cArqQry)->C6_NUM     )   // Nr. Proc. Importa็ใo
		aadd(_aAux, .F. )   // Nr. Proc. Importa็ใo

		aadd(aCols,_aAux)

		(cArqQry)->(DbSkip())
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),ctod( " " ),0, 0.00,0.00,0.00,0.00,space(06),.F.})
	endif
return(acols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESERV    บAutor  ณLeandro duarte      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLista os pedidos em reserva                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RESERV(cProduto, cLocal)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local _d
	Local aArea := GetArea()
	Local aCols     := {}

	cArqQry := "QUERYSC6"
	lQuery  := .T.
	cQuery  := "SELECT * "
	cQuery += "FROM "+RetSqlName("SC6")+" QUERYSC6, " + RetSqlName("SC5") + " SC5 "
	cQuery += "WHERE QUERYSC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
	cQuery += "QUERYSC6.C6_FILIAL = SC5.C5_FILIAL AND "
	cQuery += "QUERYSC6.C6_NUM = SC5.C5_NUM AND "
	cQuery += "SC5.D_E_L_E_T_=' ' AND "
	cQuery += "QUERYSC6.C6_PRODUTO='"+cProduto+"' AND "
	cQuery += "QUERYSC6.C6_LOCAL='"+cLocal+"' AND "
	cQuery += "(QUERYSC6.C6_QTDVEN-QUERYSC6.C6_QTDENT)>0 AND "
	cQuery += "QUERYSC6.C6_BLQ <> 'R ' AND "
	cQuery += "SC5.C5_EMISSAO BETWEEN '"+DTOS(DDATABASE-380)+"' AND '"+DTOS(DDATABASE)+"'  AND "
	cQuery += "QUERYSC6.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY QUERYSC6.C6_ENTREG "


	IIF(SELECT((cArqQry))>0,(cArqQry)->(DBCLOSEAREA()),NIL)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While (cArqQry)->(!eof())
		_aAux := {}
		SA1->( dbSeek( xFilial("SA1") + (cArqQry)->C6_CLI+(cArqQry)->C6_LOJA ) )

		aadd(_aAux, SA1->A1_NREDUZ )
		aadd(_aAux, STOD((cArqQry)->C6_ENTREG) )
		aadd(_aAux, (cArqQry)->C6_XTAXA   )
		aadd(_aAux, (cArqQry)->C6_XMOEDA   )   // Data de Chegada
		aadd(_aAux, (cArqQry)->C6_QTDVEN  )
		aadd(_aAux,  (cArqQry)->C6_PRCVEN )
		aadd(_aAux,  (cArqQry)->C6_VALOR )
		aadd(_aAux, (cArqQry)->C6_NUM     )   // Nr. Proc. Importa็ใo
		aadd(_aAux, .F. )   // Nr. Proc. Importa็ใo

		aadd(aCols,_aAux)

		(cArqQry)->(DbSkip())
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),ctod( " " ),0, 0.00,0.00,0.00,0.00,space(06),.F.})
	endif
return(acols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESERV    บAutor  ณLeandro duarte      บ Data ณ  02/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLista os pedidos em reserva                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DEEM_TERC(cProduto, cLocal, cTipo)
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local _d
	Local aArea := GetArea()
	Local aCols     := {}

	cArqQry := "QUERYSB6"
	lQuery  := .T.
	cQuery  := "SELECT QUERYSB6.B6_CLIFOR, QUERYSB6.B6_LOJA, QUERYSB6.B6_SALDO, QUERYSB6.B6_TPCF,QUERYSB6.B6_DOC "
	cQuery  += "FROM "+RetSqlName("SB6")+" QUERYSB6 "
	cQuery  += "WHERE QUERYSB6.B6_FILIAL='"+xFilial("SB6")+"' AND "
	cQuery  += "QUERYSB6.B6_PRODUTO='"+cProduto+"' AND "
	cQuery  += "QUERYSB6.B6_LOCAL='"+cLocal+"' AND "
	cQuery  += "QUERYSB6.B6_TIPO = '"+cTipo+"' AND "
	cQuery  += "QUERYSB6.B6_DTDIGIT BETWEEN '"+DTOS(DDATABASE-380)+"' AND '"+DTOS(DDATABASE)+"'  AND "
	cQuery  += "QUERYSB6.B6_PODER3 = 'R' AND "
	cQuery  += "QUERYSB6.B6_ATEND = ' ' AND "
	cQuery  += "QUERYSB6.D_E_L_E_T_=' ' "


	IIF(SELECT((cArqQry))>0,(cArqQry)->(DBCLOSEAREA()),NIL)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)
	dbSelectArea(cArqQry)

	DbGotop()
	Do While (cArqQry)->(!eof())
		_aAux := {}
		if (cArqQry)->B6_TPCF == "C"
			SA1->( dbSeek( xFilial("SA1") + (cArqQry)->B6_CLIFOR + (cArqQry)->B6_LOJA ) )
			aadd(_aAux, SA1->A1_NREDUZ )
		else
			SA2->( dbSeek( xFilial("SA2") + (cArqQry)->B6_CLIFOR + (cArqQry)->B6_LOJA ) )
			aadd(_aAux, SA2->A2_NREDUZ )
		endif

		aadd(_aAux, (cArqQry)->B6_SALDO )
		aadd(_aAux, (cArqQry)->B6_DOC )
		aadd(_aAux, .F. )   // Nr. Proc. Importa็ใo

		aadd(aCols,_aAux)

		(cArqQry)->(DbSkip())
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro
	if len(acols) == 0
		aadd(aCols,{space(07),0.00,space(06),.F.})
	endif
return(acols)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPLNCOM01  บAutor  ณMicrosiga           บ Data ณ  02/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LIMPVAR()
	IF VALTYPE(oGet1)<> "U"
		FreeObj(oGet1)
		cGet1 := "      "
		FreeObj(oGet10)
		cGet10 := "      "
		FreeObj(oGet11)
		nGet11 := 0
		FreeObj(oGet12)
		nGet12 := 0
		FreeObj(oGet13)
		nGet13 := 0
		FreeObj(oGet14)
		nGet14 := 0
		FreeObj(oGet15)
		nGet15 := 0
		FreeObj(oGet16)
		nGet16 := 0
		FreeObj(oGet17)
		nGet17 := 0
		FreeObj(oGet18)
		nGet18 := 0
		FreeObj(oGet19)
		cGet19 := ""
		FreeObj(oGet20)
		cGet20 := ""
		FreeObj(oGet21)
		cGet21 := ""
		FreeObj(oGet31)
		FreeObj(oGet32)
		FreeObj(oGet33)
		cGet3 := "          "
		FreeObj(oGet4)
		cGet4 := "          "
		FreeObj(oGet5)
		cGet5 := "          "
		FreeObj(oGet6)
		cGet6 := "          "
		FreeObj(oGet7)
		cGet7 := "          "
		FreeObj(oGet8)
		cGet8 := "          "
		FreeObj(oGet9)
		cGet9 := "          "
		FreeObj(oGroup1)
		FreeObj(oGroup2)
		FreeObj(oSay1)
		FreeObj(oSay10)
		FreeObj(oSay11)
		FreeObj(oSay12)
		FreeObj(oSay13)
		FreeObj(oSay14)
		FreeObj(oSay15)
		FreeObj(oSay16)
		FreeObj(oSay17)
		FreeObj(oSay18)
		FreeObj(oSay19)
		FreeObj(oSay02)
		FreeObj(oSay20)
		FreeObj(oSay21)
		FreeObj(oSay22)
		FreeObj(oSay23)
		FreeObj(oSay24)
		FreeObj(oSay3)
		FreeObj(oSay4)
		FreeObj(oSay5)
		FreeObj(oSay6)
		FreeObj(oSay7)
		FreeObj(oSay8)
		FreeObj(oSay9)
		FreeObj(oSButton1)
		FreeObj(oScrollB11)
		FreeObj(oScrollB12)
		FreeObj(oScrollB13)
		FreeObj(oFolder1)
		aItens	:= {"001"}
		FreeObj(oScrollB2)
		aDados := {}
		x	:= 1
		cMVpar17	:= 1
		aHeader  := {}			//Header do sistema
		aCols    := {}
		for x := 1 to 15
			FreeObj(&("oScrollB1"+cvaltochar(x)))
			FreeObj(&("oGroup1"+cvaltochar(x)))
			FreeObj(&("oGet3"+cvaltochar(x)))
			FreeObj(&("cGet3"+cvaltochar(x)))
			FreeObj(&("cGet4"+cvaltochar(x)))
			FreeObj(&("oGet4"+cvaltochar(x)))
			FreeObj(&("oGet5"+cvaltochar(x)))
			FreeObj(&("oGet6"+cvaltochar(x)))
			FreeObj(&("oGet7"+cvaltochar(x)))
			FreeObj(&("oGet8"+cvaltochar(x)))
			FreeObj(&("oGet9"+cvaltochar(x)))
			FreeObj(&("oGet10"+cvaltochar(x)))
			FreeObj(&("oGet11"+cvaltochar(x)))
			FreeObj(&("oGet12"+cvaltochar(x)))
			FreeObj(&("oGet13"+cvaltochar(x)))
			FreeObj(&("oGet14"+cvaltochar(x)))
			FreeObj(&("oGet15"+cvaltochar(x)))
			FreeObj(&("oGet16"+cvaltochar(x)))
			FreeObj(&("oGet17"+cvaltochar(x)))
			FreeObj(&("oGet18"+cvaltochar(x)))
			FreeObj(&("oGroup2"+cvaltochar(x)))
			FreeObj(&("oGroup11"+cvaltochar(x)))
			FreeObj(&("oFolder1"+cvaltochar(x)))
			&("cGet3"+cvaltochar(x)) := ''
			&("cGet4"+cvaltochar(x)) := ''
			&("cGet5"+cvaltochar(x)) := ''
			&("cGet6"+cvaltochar(x)) := ''
			&("cGet7"+cvaltochar(x)) := ''
			&("cGet8"+cvaltochar(x)) := ''
			&("cGet9"+cvaltochar(x)) := ''
			&("cGet10"+cvaltochar(x)) := ''
			&("nGet11"+cvaltochar(x)) := 0
			&("nGet12"+cvaltochar(x)) := 0
			&("nGet13"+cvaltochar(x)) := 0
			&("nGet14"+cvaltochar(x)) := 0
			&("nGet15"+cvaltochar(x)) := 0
			&("nGet16"+cvaltochar(x)) := 0
			&("nGet17"+cvaltochar(x)) := 0
			&("nGet18"+cvaltochar(x)) := 0
		next x
		itens:= nil
		FreeObj(oScrollB2)
		aItens	:= {}
		oDlg:refresh()
	ENDIF
	cGet1 := "      "
	cGet10 := "      "
	nGet11 := 0
	nGet12 := 0
	nGet13 := 0
	nGet14 := 0
	nGet15 := 0
	nGet16 := 0
	nGet17 := 0
	nGet18 := 0
	cGet19 := ""
	cGet20 := ""
	cGet21 := ""
	cGet3 := "          "
	cGet4 := "          "
	cGet5 := "          "
	cGet6 := "          "
	cGet7 := "          "
	cGet8 := "          "
	cGet9 := "          "
	aItens	:= {}
	aDados := {}
	x	:= 1
	cMVpar17	:= 1
	aHeader  := {}			//Header do sistema
	aCols    := {}
	for x := 1 to 15
		&("cGet3"+cvaltochar(x)) := ''
		&("cGet4"+cvaltochar(x)) := ''
		&("cGet5"+cvaltochar(x)) := ''
		&("cGet6"+cvaltochar(x)) := ''
		&("cGet7"+cvaltochar(x)) := ''
		&("cGet8"+cvaltochar(x)) := ''
		&("cGet9"+cvaltochar(x)) := ''
		&("cGet10"+cvaltochar(x)) := ''
		&("nGet11"+cvaltochar(x)) := 0
		&("nGet12"+cvaltochar(x)) := 0
		&("nGet13"+cvaltochar(x)) := 0
		&("nGet14"+cvaltochar(x)) := 0
		&("nGet15"+cvaltochar(x)) := 0
		&("nGet16"+cvaltochar(x)) := 0
		&("nGet17"+cvaltochar(x)) := 0
		&("nGet18"+cvaltochar(x)) := 0
	next x

	Itensslc(cGet2)
Return()
