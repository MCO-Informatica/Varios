#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelOpe   บAutor ณLuiz Albertoบ Data ณ  Maio/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Selecao Operadores de Equipes       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                      บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SelOpe(cCodOper)
Local aArea := GetArea()
Local cCampo := ReadVar()
PRIVATE oRcp5
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private aOpc := {}
Private oBotaoCnf
                                                    
cRetorno	:= ''

cQuery := 	 " SELECT ZF_OPERADO, ZF_NOME, R_E_C_N_O_ REG "
cQuery +=	 " FROM " + RetSqlName("SZF") + " SZF (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " ZF_FILIAL = '" + xFilial("SZF") + "' "
cQuery +=	 " AND SZF.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SZF.ZF_CODOPER = '" + cCodOper + "' "
cQuery +=	 " ORDER BY ZF_NOME "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

If Empty(nReg)
	CHK1->(dbCloseArea())
	Return {'',''}
Endif

CHK1->(dbGoTop())

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Operadores")
		
	SZF->(dbGoto(CHK1->REG))
				
	AAdd(aOpc,{oOk,;
					'2',;
					SZF->ZF_OPERADO,;
					SZF->ZF_NOME,;
					SZF->(Recno())})


	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aOpc))
	MsgAlert("Aten็ใo Nใo Existem Operadores para Esta Equipe !")
	RestArea(aArea)
	Return ''
Endif

SZ1->(dbSetOrder(1), dbSeek(xFilial("SZ1")+cCodOper))


DEFINE MSDIALOG oRcp5 TITLE "Sele็ใo Operadores  - Equipe: " + SZ1->Z1_CODOPER + ' ' + Capital(SZ1->Z1_DESCOPE) FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oOpcionais Fields HEADER '','',"Operador","Nome" SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oOpcionais:SetArray(aOpc)
    oOpcionais:bLine := {|| {	Iif(aOpc[oOpcionais:nAt,2]=="1",oSinalOk,oSinalNo),;
    							Iif(aOpc[oOpcionais:nAt,2]=="1",oOk,oNo),;
        						aOpc[oOpcionais:nAt,3],;
      							aOpc[oOpcionais:nAt,4]}}

	oOpcionais:bLDblClick := {||DblClick(oOpcionais:nAt)}

	nOpc := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Confirma" 			ACTION (Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL
	
	oBotaoCnf:Enable()

	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	If nOpc == 1
		cRetorno1 := ''//cRetor1 //+ cRetor2 + "/" // GA_GROPC + "" + GA_OPC + "/"
		cRetorno2 := ''//cRetor1 //+ cRetor2 + "/" // GA_GROPC + "" + GA_OPC + "/"
		For nI := 1 To Len(aOpc)
			If aOpc[nI,2] == '1'
				cRetorno1 += aOpc[nI,3] + '|'
				cRetorno2 += Capital(Left(aOpc[nI,4],10)) + '|'
				
				SZF->(dbGoTo(aOpc[nI,5]))
				
			Endif
		Next 
	Else
		cRetorno1 := ''
		cRetorno2 := ''
	Endif

RestArea(aArea)
Return {cRetorno1,cRetorno2}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ DblClickณ Autor ณ Luiz Alberto        ณ Data ณ 06/12/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao Responsavel pelo Double Click Tela Rotas ณฑฑ
ฑฑณ          |                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aOpc[nPos,2]=="1"
	aOpc[nPos,2]:="2"
Else
	aOpc[nPos,2]:="1"
Endif 
oOpcionais:Refresh()
oRcp5:Refresh()
Return .t.
	