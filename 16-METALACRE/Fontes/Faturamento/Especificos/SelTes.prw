#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelTes   บAutor ณLuiz Albertoบ Data ณ  Maio/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela Selecao TES MetalSeal ou MPM        บฑฑ
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
User Function SelTes(cEmp)
Local aArea := GetArea()
PRIVATE oRcp5
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private aTes := {}
Private oBotaoCnf
Private lConfirma := .f.
                                                    
cQuery := 	 " SELECT F4_CODIGO, F4_CF, F4_TEXTO, F4_ICM, F4_IPI, F4_DUPLIC, F4_ESTOQUE "
cQuery +=	 " FROM SF4" + cEmp + "0 SF4 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " SF4.D_E_L_E_T_ = '' "      
cQuery +=	 " AND SF4.F4_TIPO = 'S' AND F4_MSBLQL <> '1' "
cQuery +=	 " ORDER BY F4_CODIGO "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

If Empty(nReg)
	CHK1->(dbCloseArea())
	Return ''
Endif

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
While CHK1->(!Eof())
	IncProc("Aguarde Tes")
		
	AAdd(aTes,{oOk,;
					'2',;
					CHK1->F4_CODIGO,;
					CHK1->F4_CF,;
					CHK1->F4_TEXTO,;
					Iif(CHK1->F4_ICM=='S','Sim','Nao'),;
					Iif(CHK1->F4_IPI=='S','Sim','Nao'),;
					Iif(CHK1->F4_DUPLIC=='S','Sim','Nao'),;
					Iif(CHK1->F4_ESTOQUE=='S','Sim','Nao')})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aTes))
	RestArea(aArea)
	Return ''
Endif


DEFINE MSDIALOG oRcp5 TITLE "Sele็ใo TES " + Iif(cEmp=='02','Empresa MetalSeal','Empresa MPM') FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oSelTes Fields HEADER '','',"TES","CFOP","Descri็ใo",'Icm','Ipi','Financeiro','Estoque' SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oSelTes:SetArray(aTes)
    oSelTes:bLine := {|| {	Iif(aTes[oSelTes:nAt,2]=="1",oSinalOk,oSinalNo),;
    							Iif(aTes[oSelTes:nAt,2]=="1",oOk,oNo),;
        						aTes[oSelTes:nAt,3],;
      							aTes[oSelTes:nAt,4],;
      							aTes[oSelTes:nAt,5],;
      							aTes[oSelTes:nAt,6],;
      							aTes[oSelTes:nAt,7],;
      							aTes[oSelTes:nAt,8],;
					      		aTes[oSelTes:nAt,9]}}

	oSelTes:bLDblClick := {|| U_dbClickTes(oSelTes:nAt)}

	nOpc := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Confirma" 			ACTION (Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL

	If lConfirma
		oBotaoCnf:Enable()
	Else                  
		oBotaoCnf:Disable()
	Endif

	ACTIVATE MSDIALOG oRcp5 CENTERED 
	
	If nOpc == 1
		cRetorno := ''//cRetor1 //+ cRetor2 + "/" // GA_GROPC + "" + GA_OPC + "/"
		For nI := 1 To Len(aTes)
			If aTes[nI,2] == '1'
				cRetorno := aTes[nI,3]
				Exit
			Endif
		Next 
	Else
		cRetorno := ''
	Endif

RestArea(aArea)
Return cRetorno

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
User Function dbClickTes(nPos)
Local aArea := GetArea()

If aTes[nPos,2]=="1"
	aTes[nPos,2]:="2"
	oBotaoCnf:Disable()
Else

	aTes[nPos,2]:="1"
	oBotaoCnf:Enable()
	For nI := 1 To Len(aTes)
		If nI <> nPos
			aTes[nI,2] := '2'
		Endif
	Next
Endif 
oSelTes:Refresh()
oRcp5:Refresh()
Return .t.
	