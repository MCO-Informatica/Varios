#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALDOCLI  ºAutor  ³Microsiga           º Data ³  03/20/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³apresenta o sanldo do cliente                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SALDOCLI()
	Local oSay1
	Local oSay2
	Local oSButton1
	Static oDlg
	Private cGet1 := space(tamsx3("A1_COD")[1])
	Private cGet3 := 0
	Private oWBrowse1
	Private aWBrowse1 := {}
	Private oGet1
	Private oGet2
	Private cGet2 := space(tamsx3("A1_NREDUZ")[1])
	Private oGet3

	DEFINE MSDIALOG oDlg TITLE "Total a Receber" FROM 000, 000  TO 400, 500 COLORS 0, 16777215 PIXEL

	@ 013, 005 SAY oSay1 PROMPT "Codigo Cliente" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 011, 051 MSGET oGet1 VAR cGet1 SIZE 030, 010 OF oDlg COLORS 0, 16777215 F3 "SA1S" VALID(cGet2:=POSICIONE("SA1",1,XFILIAL("SA1")+cGet1,"A1_NOME"),.T.) PIXEL
	@ 011, 094 MSGET oGet2 VAR cGet2 SIZE 147, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	DEFINE SBUTTON oSButton1 FROM 187, 110 TYPE 01 OF oDlg ENABLE  ACTION (list(aWBrowse1))
	DEFINE SBUTTON oSButton1 FROM 187, 145 TYPE 02 OF oDlg ENABLE  ACTION (oDlg:end())
	fWBrowse1()
	@ 169, 011 SAY oSay2 PROMPT "TOTAL A RECEBER" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 166, 072 MSGET oGet3 VAR ALLTRIM(TRANSFORM(cGet3,"@E 999,999,999,999,999,999.99")) SIZE 094, 010 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALDOCLI  ºAutor  ³Microsiga           º Data ³  03/20/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fWBrowse1()


	// Insert items here
	Aadd(aWBrowse1,{'','','','0,00'})

	@ 031, 005 LISTBOX oWBrowse1 Fields HEADER "Codigo","Loja","Nome","Total" SIZE 236, 130 OF oDlg PIXEL ColSizes 50,50

	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	aWBrowse1[oWBrowse1:nAt,1],;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4];
	}}
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALDOCLI  ºAutor  ³Microsiga           º Data ³  03/20/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function list(aWBrowse1)
	Local cQuery := ""
	aWBrowse1:= {}
	cGet3 := 0
	cQuery += " SELECT A.E1_CLIENTE, A.E1_LOJA, B.A1_NREDUZ, SUM(A.E1_SALDO) AS TOTAL  "
	cQuery += "   from SE1010 A, SA1010 B  "
	cQuery += "  WHERE A.E1_FILIAL = '02'  "
	cQuery += "    AND A.D_E_L_E_T_ = ' '  "
	cQuery += "    AND B.A1_FILIAL = '  '  "
	cQuery += "    AND B.D_E_L_E_T_ = ' '  "
	cQuery += "    AND A.E1_CLIENTE = B.A1_COD  "
	cQuery += "    AND A.E1_LOJA = B.A1_LOJA   "
	cQuery += "    AND A.E1_CLIENTE = '"+cGet1+"'  "
	cQuery += "    AND A.E1_STATUS = 'A'  "
	cQuery += "  GROUP BY A.E1_CLIENTE, A.E1_LOJA, B.A1_NREDUZ  "
	cQuery := ChangeQuery(cQuery)
	iif(SELECT("TRB")>0,TRB->(DBCLOSEAREA()),NIL)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	WHILE TRB->(!EOF())
		AADD(aWBrowse1,{TRB->E1_CLIENTE, TRB->E1_LOJA, TRB->A1_NREDUZ, ALLTRIM(TRANSFORM(TRB->TOTAL,"@E 999,999,999,999,999,999.99"))})
		cGet3 += TRB->TOTAL
		TRB->(DBSKIP())
	END
	IF LEN(aWBrowse1)==0
		Aadd(aWBrowse1,{'','','','0,00'})
	ENDIF

	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	aWBrowse1[oWBrowse1:nAt,1],;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4];
	}}
	oGet3:REFRESH()
	oWBrowse1:REFRESH()
	oDlg:REFRESH()
Return()
