#include 'totvs.ch'
#include "Protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN001  บAutor  ณEugenio Arcanjo     บ Data ณ  07/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณrotina ajusta o vencimento dos tํtulos a pagar em aberto    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบajustes   ณ Leandro Silva: Atribuir na listagem o nome do fornecedor   บฑฑ
ฑฑบ08/10/2015ณ o campo Filial colocar na tela os totais selecionados e    บฑฑ
ฑฑบ          ณ executar a troca das datas vencrea para a data desejada    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFIN001()
Local aSalvAmb	 := {}
Private aSize := MsAdvSize(.f.)
Private cTitulo	 := "Tํtulos เ Pagar Vencidos"
Private _cArqQry
Private _cQuery
Private oChk     := Nil
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )
Private _aBmp	   := LoadBitmap( GetResources() , "BR_VERDE_OCEAN")
Private QaOrder		:= {}
PRIVATE qaCampos	:= {oNo,_aBmp,"E2_FILIAL","E2_VENCREA","E2_PREFIXO","E2_NUM","E2_TIPO","E2_VALOR","E2_SALDO","E2_FORNECE","A2_NOME"}
Private oFilialI
Private oFilialF
Private oVencI
Private oVencF
Private oVencN

Private _cFilialI := Space(7)
Private _cFilialF := Space(7)
Private _dVencI := date()
Private _dVencF := date()
Private _dVencN := date()
Private nSele	:= nSald := 0

Private _lMark    := .F.
Private lChk     := .F.
Private oPesq	 := Nil
Private oDlg	 := Nil
Private oLbx	 := Nil
Private bLine	 := ""
Private _nElem	 := 0
Private _cRetFil := ""
Private _lRet	 := .F.
Private _aTitulos := {{.f.,_aBmp,'',stod(''),'','','',0,0,'',''}}


DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] PIXEL
@ 020,010 Say "Fil. Inicial : "  Size 082,010 PIXEL OF oDlg
@ 020,060 MsGet oFilialI Var _cFilialI F3 "SM0"  Picture "@!" Size 082,010 COLOR CLR_BLACK PIXEL OF oDlg
@ 020,150 Say "Fil. Final : "  Size 082,010 PIXEL OF oDlg
@ 020,200 MsGet oFilialF Var _cFilialF F3 "SM0"  Picture "@!" Size 082,010 COLOR CLR_BLACK PIXEL OF oDlg
@ 040,010 Say "Venc. Inicial :"  Size 082,010 PIXEL OF oDlg
@ 040,060 MsGet oVencI Var _dVencI  Size 082,010 COLOR CLR_BLACK PIXEL OF oDlg
@ 040,150 Say "Venc. Final :"  Size 082,010 PIXEL OF oDlg
@ 040,200 MsGet oVencF Var _dVencF  Size 082,010 COLOR CLR_BLACK PIXEL OF oDlg
@ 040,290 Button "Confirma Parโmetros" Size 090,012 PIXEL OF oDlg Action(lChk:= .f., ConfPesq(_cFilialI,_cFilialF,_dVencI,_dVencf))
@ 060,010 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON CLICK(Marca(lChk))
@ 060,180 Say "Total Selecionado: "+cValToChar(nSele)+"            Saldo Total: "+Transform(nSald,"@E 9,999,999,999,999.99")  Size 282,010 PIXEL OF oDlg
@ 075,010 LISTBOX oLbx Fields HEADER " "," ", "Filial", "Dt.Vencimento", "Prefixo", "Tํtulo","Tipo", "Valor", "Saldo", "Fornecedor", "Nome"   SIZE (aSize[5]/2)-20 ,(aSize[6]/2)-140 OF oDlg PIXEL ON dblClick(_aTitulos[oLbx:nAt,1] := !_aTitulos[oLbx:nAt,1],;
iif(_aTitulos[oLbx:nAt,1],(nSele +=1,nSald +=_aTitulos[oLbx:nAt,8]),(nSele -=1,nSald -=_aTitulos[oLbx:nAt,8])),;
oDlg:Refresh(),oLbx:Refresh(),oDlg:Refresh(),oVencF:setfocus())
oLbx:SetArray( _aTitulos )
oLbx:bLine := {|| {Iif(_aTitulos[oLbx:nAt,1],oOk,oNo),;
_aTitulos[oLbx:nAt,2],;
_aTitulos[oLbx:nAt,3],;
_aTitulos[oLbx:nAt,4],;
_aTitulos[oLbx:nAt,5],;
_aTitulos[oLbx:nAt,6],;
_aTitulos[oLbx:nAt,7],;
Transform(_aTitulos[oLbx:nAt,8],"@E 9,999,999,999,999.99"),;
Transform(_aTitulos[oLbx:nAt,9],"@E 9,999,999,999,999.99"),;
_aTitulos[oLbx:nAt,10],;
_aTitulos[oLbx:nAt,11]}}
oLbx:bHeaderClick := {|x,y| qAC1111rd(y,1) }
@ (aSize[6]/2)-40,010 Say "Novo Venc :"  Size 082,010 PIXEL OF oDlg
@ (aSize[6]/2)-40,060 MsGet oVencN Var _dVencN  Size 082,010 COLOR CLR_BLACK PIXEL OF oDlg
//@ 200,010 Button "Executar" Size 037,012 PIXEL OF oDlg Action(iif(empty(_dVencN),alert("Preenche o Novo Vencimento!"),(Processa({|| AjustVenc(_dVencN)},"Aguarde","Executando a Rotina"),nSele:=nSald:=0,ConfPesq(_cFilialI,_cFilialF,_dVencI,_dVencf))))
@ (aSize[6]/2)-20,010 Button "Executar" Size 037,012 PIXEL OF oDlg Action((Processa({|| AjustVenc(_dVencN)},"Aguarde","Executando a Rotina"),nSele:=nSald:=0,ConfPesq(_cFilialI,_cFilialF,_dVencI,_dVencf)))
@ (aSize[6]/2)-20,050 Button "Finalizar" Size 037,012 PIXEL OF oDlg Action(oDlg:End())
ACTIVATE MSDIALOG oDlg CENTER

Return(_lRet)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AFIN001   | AUTOR | Eugenio Arcanjo  | DATA | 14/10/2015        |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Marca()  		                                        |//
//|           | Seleciona o registro do listbox                                 |//
//|           | 											                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function Marca(lMarca)
Local i := 0
nSele := 0
nSald := 0
if len(_aTitulos)>0  .and. !empty(_aTitulos[1][3])
	For i := 1 To Len(_aTitulos)
		_aTitulos[i][1] := lMarca
		if lMarca
			nSele +=1
			nSald +=_aTitulos[i][8]
		else
			nSele := 0
			nSald := 0
		endif
	Next i
	
	oLbx:Refresh()
	oDlg:Refresh()
	oVencF:setfocus()
endif
Return
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AFIN001   | AUTOR | Eugenio Arcanjo  | DATA | 14/10/2015        |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ConfPesq()  		                                    |//
//|           | Pesquisa tํtulos conforme parโmetros escolhidos pelo usuแrio      |//
//|           | 											                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ConfPesq(_cFilialI,_cFilialf,_dVencI,_dVencf)
oOk      := LoadBitmap( GetResources(), "LBOK" )
oNo      := LoadBitmap( GetResources(), "LBNO" )
_aTitulos := {}
_aBmp	   := LoadBitmap( GetResources() , "BR_VERDE_OCEAN")
_cArqQry:= GetNextAlias()
_cQuery := " SELECT distinct SE2.E2_VENCREA VENCTO, SE2.E2_PREFIXO PREFIXO, SE2.E2_NUM NUMERO,SE2.E2_TIPO TIPO,SE2.E2_VALOR VALOR, SE2.E2_FORNECE FORNEC, SA2.A2_NOME, SE2.E2_FILIAL,SE2.E2_SALDO,SE2.R_E_C_N_O_ AS REC  "
_cQuery += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2 "
_cQuery += " WHERE SE2.D_E_L_E_T_ = '' AND SE2.E2_BAIXA = ''"
_cQuery += "   AND SE2.E2_FILIAL BETWEEN '"+_cFilialI+"' AND '"+_cFilialF+"' "
_cQuery += "   AND SE2.E2_VENCREA BETWEEN '"+dtos(_dVencI)+"' AND '"+dtos(_dVencF)+"' "
_cQuery += "   AND SE2.E2_FORNECE = SA2.A2_COD "
_cQuery += "   AND SE2.E2_LOJA = SA2.A2_LOJA "
_cQuery += "   AND SE2.E2_SALDO > 0 " 
_cQuery += "   AND SE2.E2_TIPO <> 'PR' "
_cQuery += "   UNION "
_cQuery += " SELECT distinct SE2.E2_VENCREA, SE2.E2_PREFIXO, SE2.E2_NUM,SE2.E2_TIPO TIPO,SE2.E2_VALOR, SE2.E2_FORNECE, SA2.A2_NOME, SE2.E2_FILIAL,SE2.E2_SALDO,SE2.R_E_C_N_O_ AS REC  "
_cQuery += "   FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2, "+RETSQLNAME("SE5")+" SE5 "
_cQuery += "  WHERE SE2.D_E_L_E_T_ = '' "
_cQuery += "   AND SE2.E2_FILIAL BETWEEN '"+_cFilialI+"' AND '"+_cFilialF+"' "
_cQuery += "   AND SE2.E2_VENCREA BETWEEN '"+dtos(_dVencI)+"' AND '"+dtos(_dVencF)+"' "
_cQuery += "   AND SE2.E2_FORNECE = SA2.A2_COD "
_cQuery += "   AND SE2.E2_LOJA = SA2.A2_LOJA "
_cQuery += "   AND SE5.D_E_L_E_T_ = '' "
_cQuery += "   AND SE2.E2_SALDO > 0 "
_cQuery += "   AND SE5.E5_FILIAL = SE2.E2_FILIAL "
_cQuery += "   AND SE5.E5_PREFIXO = SE2.E2_PREFIXO "
_cQuery += "   AND SE5.E5_NUMERO  = SE2.E2_NUM "
_cQuery += "   AND SE5.E5_PARCELA  = SE2.E2_PARCELA "
_cQuery += "   AND SE5.E5_CLIFOR   = SE2.E2_FORNECE "
_cQuery += "   AND SE5.E5_LOJA  = SE2.E2_LOJA "
_cQuery += "   AND ((E5_TIPO = 'PA' "
_cQuery += "   AND trim(E5_NUMCHEQ) <>  '' "
_cQuery += "   AND  E5_TIPODOC = 'BA' "
_cQuery += "   AND  E5_RECPAG = 'P') "
_cQuery += "    OR (E5_TIPO = 'PA' "
_cQuery += "   AND  E5_TIPODOC = 'VL' "
_cQuery += "   AND  E5_RECPAG = 'P' ) "
_cQuery += "    OR (E5_TIPO = 'PA' "
_cQuery += "   AND  E5_TIPODOC = 'PA' "
_cQuery += "   AND  E5_RECPAG = 'P' "
_cQuery += "   AND  trim(E5_ARQCNAB) = 'CNAB' "
_cQuery += "    )) "
_cQuery += "   AND TRIM(E5_MOTBX) <> 'CMP'  "
_cQuery += " ORDER BY 8, 1 "
//_cQuery += " ORDER BY 8, 7 "
_cQuery := ChangeQuery(_cQuery)
iif(select(_cArqQry)>0,(_cArqQry)->(dbclosearea()),nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqQry,.F.,.T.)
//TCSetField(_cArqQry,"C2_DATPRF","D")

DbSelectArea(_cArqQry)
While !Eof()
	If !Empty(&(_cArqQry+"->VENCTO"))
		aAdd(_aTitulos,{_lMark,_aBmp,&(_cArqQry+"->E2_FILIAL"),StoD(&(_cArqQry+"->VENCTO")),&(_cArqQry+"->PREFIXO"),&(_cArqQry+"->NUMERO"),&(_cArqQry+"->TIPO"),&(_cArqQry+"->VALOR"),&(_cArqQry+"->E2_SALDO"),&(_cArqQry+"->FORNEC"),&(_cArqQry+"->A2_NOME"),(_cArqQry)->REC })
	Endif
	dbSkip()
End

If Empty(_aTitulos)
	aAdd(_aTitulos,{.F.,_aBmp," ",Ctod("  /  /  "),Space(3),Space(9),"",0,0,Space(6),Space(40)})
endif

oLbx:SetArray( _aTitulos )
oLbx:bLine := {|| {Iif(_aTitulos[oLbx:nAt,1],oOk,oNo),;
_aTitulos[oLbx:nAt,2],;
_aTitulos[oLbx:nAt,3],;
_aTitulos[oLbx:nAt,4],;
_aTitulos[oLbx:nAt,5],;
_aTitulos[oLbx:nAt,6],;
_aTitulos[oLbx:nAt,7],;
Transform(_aTitulos[oLbx:nAt,8],"@E 9,999,999,999,999.99"),;
Transform(_aTitulos[oLbx:nAt,9],"@E 9,999,999,999,999.99"),;
_aTitulos[oLbx:nAt,10],;
_aTitulos[oLbx:nAt,11]}}
oLbx:bHeaderClick := {|x,y| qAC1111rd(y,1) }
oDlg:Refresh()
oLbx:Refresh()

oDlg:Refresh()
Return
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AFIN001   | AUTOR | Eugenio Arcanjo  | DATA | 14/10/2015        |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - AjusVenc()  		                                    |//
//|           | ajusta o campo vencimento do(s) tํtulo(s) เ pagar               |//
//|           | 											                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AjustVenc(_dVencN)
Local _lSel  := .F.
//Inlcuido Ronaldo Bicudo - Totvs - 29/09/2016
Local _xUser := cUserName  
Local _xData := Dtoc(DATE())
Local _xHora := TIME()
//Fim da Inclusใo

if !Empty(_dVencN)
	ProcRegua(len(_aTitulos))
	For nFor := 1 to len(_aTitulos)
		incProc("atualizando")
		if _aTitulos[nFor][1]
			_lSel := .T.
		Endif
	Next
	If _lSel
		For nFor := 1 to len(_aTitulos)
			incProc("atualizando")
			if _aTitulos[nFor][1]
				SE2->(DBGOTO(_aTitulos[nFor][12]))
				RECLOCK("SE2",.F.)
				SE2->E2_VENCREA := _dVencN
				SE2->E2_XLOGVEN := Alltrim(_xUser)+" - "+_xData+" - "+_xHora //Incluido Campo para gravar o ultimo usuแrio que rodou a rotina!!!! - Ronaldo Bicudo - Totvs - 29/09/2016
				MSUNLOCK()
			Endif
		Next
		MsgAlert("Processo Finalizado com Sucesso","OK")
	Else
		MsgAlert("Processo Cancelado, nenhum registro selecionado","Aten็ใo")
	Endif
	
Else
	MsgAlert("Processo Cancelado, o campo Data estแ em branco","Aten็ใo")
	Return
Endif
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN001   บAutor  ณLeandro Silva       บ Data ณ  10/15/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QAC1111rd(nCol,nF)
Local nPos

nPos := aScan( QaOrder, {|x| x[1] == nCol } )
if nPos == 1
	QaOrder[nPos,2] := !QaOrder[nPos,2]
else
	if nPos > 0
		QaOrder := aDel(QaOrder,nPos)
		QaOrder := aSize(QaOrder,Len(QaOrder)-1)
	endif
	
	QaOrder := aSize(QaOrder,Len(QaOrder)+1)
	QaOrder := aIns(QaOrder,1)
	QaOrder[1] := {nCol, .T.}
endif

// Limita em 3 ordenacoes encadeadas para nao prejudicar performance
QaOrder := aSize(QaOrder,Min(Len(QaOrder),1))

QAC111Sort(nF)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQAC111SortบAutor  ณLeandro Silva       บ Data ณ  15/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณordena os dados da matriz do  browse                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ mp11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QAC111Sort(nF)
Local i
Local cOrder 		:= ""
Local aEqArr		:= {{'1'},{'2'},{'3'},{'4'},{'5'},{'6'},{'7'},{'8'},{'9'},{'10'}, {'11'}}// equivalencia de array

for i := 1 to Len(QaOrder)
	cOrder += "x["+aEqArr[QaOrder[i,1]][1]+"] "+" < "+"y["+aEqArr[QaOrder[i,1]][1]+"] "
	if i < len(QaOrder)
		cOrder += " .and. "
	endif
next i
//cOrder += Repl( ")", (len(QaOrder)*2)-1 )
_aTitulos := aSort( _aTitulos,,,&("{|x,y| "+cOrder+"}") )

QSetGrid(nF)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQSetGrid  บAutor  ณLeandro Silva       บ Data ณ  15/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta dinamicamente o bLine do listbox                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Mp8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QSetGrid(nF)
Local i
Local cLine

oLbx:SetArray(_aTitulos)
// Monta dinamicamente o bLine do listbox
cLine := "{|| { Iif(_aTitulos[oLbx:nAt,1],oOk,oNo),"

for i := 2 to len(QaCampos)
	cLine += "_aTitulos[oLbx:nAt,"+Alltrim(Str(i))+"], "
next i

cLine := Left(cLine, Len(cLine)-2)+" } }"

oLbx:bLine := &cLine
oLbx:Refresh()

Return
