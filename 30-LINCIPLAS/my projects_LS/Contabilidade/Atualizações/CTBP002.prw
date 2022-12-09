#INCLUDE "PROTHEUS.CH"   
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
+=========================================================+
|Programa: CTBP002| Autor: Antonio Carlos |Data: 19/02/10 |
+=========================================================+
|Descricao: Rotina responsavel pela "Deleção" da tabela   |
|CT2 e "Atualização" da Flag de contabilização da tabela  |
|SL5 - Resumo de Vendas.                                  |
+=========================================================+
|Uso: Laselva                                             |
+=========================================================+
*/

User Function CTBP002()

Local aArea		:= GetArea()

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oData
Private oDlg

Private lInvFil		:= .F.
Private lInvGrp		:= .F.
Private aFilial		:= {}
Private cStrFilia	:= ""
Private cStrFil		:= ""

Private _dDatad		:= CTOD("  /  /  ")
Private _dDataa		:= CTOD("  /  /  ")
Private cFiltrUsr	:= ""
Private cCadastro	:= "Atualiza Flag - Contabilizacao PDV "

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 430,400 OF oMainWnd PIXEL

@ 10,30 SAY "Data de: " OF oDlg PIXEL
@ 20,30 MSGET oDatad VAR _dDatad SIZE 50,10 OF oDlg PIXEL

@ 10,110 SAY "Data ate: " OF oDlg PIXEL
@ 20,110 MSGET oDataa VAR _dDataa SIZE 50,10 OF oDlg PIXEL

//Group Box de Filiais
@ 50,10  TO 190,197 LABEL "Filiais" OF oDlg PIXEL

//Grid de Filiais
DbSelectArea("SM0")
SM0->( DbGoTop() )
While SM0->( !Eof() )
	Aadd( aFilial, {.F.,M0_CODFIL,SM0->M0_FILIAL} )
	SM0->( DbSkip() )
EndDo

@ 70,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3]}}

DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION(LjMsgRun("Aguarde..., Atualizando registros...",, {|| AtuDados() }) )  ENABLE OF oDlg
DEFINE SBUTTON FROM 200,110 TYPE 2 ACTION(oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
	
RestArea(aArea)

Return

Static Function LSVTroca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

Static Function AtuDados()

Local aArea	:= GetArea()
Local _nReg	:= 0

If Empty(_dDatad) .Or. Empty(_dDataa)
	MsgStop("Informe a data para alteracao!")
	Return(.F.)
EndIf

nPos := aScan(aFilial,{|x| x[1] == .T. }) 

If nPos == 0
	MsgStop("Selecione uma filial!")
	Return(.F.)
EndIf

AEval(aFilial, {|x| If(x[1]==.T.,cStrFilia+="'"+SubStr(x[2],1,TamSX3("B1_FILIAL")[1])+"'"+",",Nil)})
cStrFil := Substr(cStrFilia,1,Len(cstrFilia)-1)      

cUpdSL5	:= " UPDATE " + RetSQLName("SL5")
cUpdSL5	+= " SET L5_LA = '' "
cUpdSL5 += " WHERE "		
cUpdSL5	+= " L5_FILIAL IN ("+cStrFil+") AND "
cUpdSL5	+= " L5_DATA BETWEEN '"+DTOS(_dDatad)+"' AND '"+DTOS(_dDataa)+"' AND "
cUpdSL5	+= " D_E_L_E_T_ = '' "
	
TcSQLExec(cUpdSL5)  

cUpdCT2	:= " DELETE " + RetSQLName("CT2")
cUpdCT2 += " WHERE "		
cUpdCT2	+= " CT2_FILIAL IN ("+cStrFil+") AND "
cUpdCT2	+= " CT2_DATA BETWEEN '"+DTOS(_dDatad)+"' AND '"+DTOS(_dDataa)+"' AND "
cUpdCT2	+= " CT2_LOTE = '008820' AND CT2_LP = '777'  AND "
cUpdCT2	+= " D_E_L_E_T_ = '' "
	
TcSQLExec(cUpdCT2)  

MsgInfo("Processamento efetuado com sucesso!")

cStrFilia	:= ""
cStrFil		:= ""

Return