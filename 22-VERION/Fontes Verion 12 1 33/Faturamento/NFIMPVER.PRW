#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  NFImpVer  บAutor  ณ Logos Technology บ Data ณ  08/15/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nota Fiscal Importa็ใo                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NFImpVer()
Local _aArea1  := GetArea()  // guarda a area
Local _dServer := MsDate()   // data do servidor
Local _dSiga   := DDataBase  // data do sistema
Local _lEmis   := .T.        // Retorno esperado pelo sistema  (.T. ou .F.)

If  _dSiga < _dServer
	
	IF MsgYesNo("Data do Sistema Protheus menor que a Data Base. Deseja continuar ?")
		Rodai()
	Else
		MsgBox("A nota fiscal nใo serแ gerada. Ajuste a data do sistema !")
	EndIf
Else
	Rodai()
EndIf

RestArea(_aArea1)
Return(_lEmis)

// inicio do processo de imnportacao de texto....
Static function Rodai()
Local aSays,aButtons,cTitulo,nOpc,cPerg
Private lReserv,lOpenArq,cMvFor,cMvLj,cMvDoc
cArq     := ""
aSays    := {}
aButtons := {}
nOpc     := 0
lReserv  := .f.
lOpenArq := .f.
cPerg    := "NFEIMP"
cTitulo  := "Nota Fiscal Importa็ใo"

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Rotina que efetua o processo da Nota Fiscal de Importa็ใo")
aAdd(aSays,"Aten็ใo: Nใo esque็a de reservar os n๚meros das notas fiscais a serem utilizadas,")
aAdd(aSays,"no botใo PARยMETRO.")

aAdd(aButtons,{1,.t.,{|o|nOpc:=1, o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|nOpc:=2, o:oWnd:End()}})
aAdd(aButtons,{5,.t.,{|o|nOpc:=5, lReserv:=.t., ValidPerg(cPerg), Pergunte(cPerg,.t.), ChkPerg(), o:oWnd:Refresh()}})
aAdd(aButtons,{14,.t.,{|o| lOpenArq :=.t., OpenArq(), o:oWnd:Refresh()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1
	If msgBox("Confirma a execu็ใo do processo da Nota Fiscal de Importa็ใo?","Confirma","YesNo")
		If lOpenArq
			If lReserv
				Processa({||ImpArq()},"Processando Nota Fiscal de Importa็ใo...")
			Else
				msgStop("Nใo foram informados os n๚meros/fornecedores das notas fiscais a serem reservadas... Clique no botใo PARAMETROS para isto!")
				lReserv := .f.
			EndIf
		Else
			msgStop("Selecione o arquivo a ser processado no botใo ABRIR...")
			lOpenArq := .f.
		EndIf
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOpenArq   บ Autor ณMicrosiga           บ Data ณ  08/20/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre arquivo do Aduaneiro                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OpenArq()
Local cType
cType := "Arquivos texto|*.TXT|Todos os arquivos|*.*"
cArq  := cGetFile(cType, OemToAnsi("Selecione o arquivo enviado pelo Aduaneiro"),0,"SERVIDOR\",.t.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpArq    บ Autor ณMicrosiga           บ Data ณ  08/20/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa os processos da nota fiscal de importacao          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpArq()
Local cFile, cBuffer, _cQuery, cCodPro, cCodNew, aCabNF, aItmNF, aItmPre , nCont, cDoc, _cAdicao, nItem, lSF1, lAdic, _nX
Local _aAreaSB1:= SB1->( GetArea() )
Local _aAreaSF1:= SF1->( GetArea() )
Local _aAreaSD1:= SD1->( GetArea() )
Local _aAreaSE2:= SE2->( GetArea() )
Local _aAreaSA2:= SA2->( GetArea() )
Local _aReserv := {}
Local aImp 	   := {}
Private nHdl, cFile, nDesp, nBaseICM, nValICM, nBaseIPI, nValIPI, nBasePis, nValPis, nBaseCof, nValCof, nBasCIF, nValII, nTtInvo, nValTt
Private _aProcNF  := {}
Private lMSHelpAuto:=.T.,lMsErroAuto:=.F.

lSF1    := .T.
lAdic   := .F.
bZeraTt := {||(nDesp := nBaseICM := nValICM := nBaseIPI := nValIPI := nBasePis := nValPis := nBaseCof := nValCof := nBasCIF := nValII := nValTt := 0)}

aAdd(aImp,{"ADICAO ","C",16,0})
aAdd(aImp,{"NCM    ","C",10,0})
aAdd(aImp,{"COD_PRO","C",15,0})
aAdd(aImp,{"QTD    ","N",11,2})
aAdd(aImp,{"UNIT   ","N",16,4})
aAdd(aImp,{"DESP   ","N",14,2})
aAdd(aImp,{"DI     ","C",12,0})
aAdd(aImp,{"DT_DI  ","D",08,0})
aAdd(aImp,{"INVOICE","C",12,0})
aAdd(aImp,{"VLR_TOT","N",14,2})
aAdd(aImp,{"ALQ_IPI","N",06,2})
aAdd(aImp,{"VLR_IPI","N",14,2})
aAdd(aImp,{"BAS_IPI","N",14,2})
aAdd(aImp,{"ALQ_ICM","N",06,2})
aAdd(aImp,{"VLR_ICM","N",14,2})
aAdd(aImp,{"BAS_ICM","N",14,2})
aAdd(aImp,{"ALQ_II ","N",06,2})
aAdd(aImp,{"VLR_II ","N",14,2})
aAdd(aImp,{"BAS_II ","N",14,2})
aAdd(aImp,{"ALQ_PIS","N",06,2})
aAdd(aImp,{"VLR_PIS","N",14,2})
aAdd(aImp,{"BAS_PIS","N",14,2})
aAdd(aImp,{"ALQ_COF","N",06,2})
aAdd(aImp,{"VLR_COF","N",14,2})
aAdd(aImp,{"BAS_COF","N",14,2})
aAdd(aImp,{"MOEDA  ","N",02,0})
aAdd(aImp,{"CONDPGT","N",03,0})
aAdd(aImp,{"TT_INVO","N",17,2})
aAdd(aImp,{"COD_NEW","C",15,0})
aAdd(aImp,{"NCONT  ","N",04,0})

cFile := e_CriaTrab(,aImp,"TRB")
IndRegua("TRB",cFile,"ADICAO",,,"Ordenando registros...")

If !File(cArq)
	Aviso("Aten็ใo!", "Arquivo invแlido!",{"Ok"})
	TRB->(dbCloseArea())
	Return
EndIf

nHdl := FT_FUse(cArq)
If nHdl<>Nil .and. nHdl<=0
	Aviso("Aten็ใo", "Nใo foi possํvel a abertura do arquivo "+AllTrim(cArq)+" !", {"Ok"})
	fClose(cArq)
	Return
EndIf

nCont := 1
ProcRegua(FT_FLastRec())
FT_FGoTop()
Do While !FT_FEOF()
	IncProc("Importando arquivo... " +cArq)
	
	cBuffer := FT_FReadLN()
	cBuffer := AllTrim(Upper(cBuffer))
	
	RecLock("TRB", .T.)
	TRB->NCM     := Alltrim(StrTran(SubStr(cBuffer,01,10),".",""))//SubStr(cBuffer,01,04)+SubStr(cBuffer,06,02)+SubStr(cBuffer,09,02)
	TRB->COD_PRO := Alltrim(SubStr(cBuffer,11,15))
	TRB->QTD     := Val(SubStr(cBuffer,26,11))/100//Val(SubStr(cBuffer,26,09)+"."+SubStr(cBuffer,35,2))
	TRB->UNIT    := Val(SubStr(cBuffer,37,16))/10000//Val(SubStr(cBuffer,37,12)+"."+SubStr(cBuffer,49,4))
	TRB->DESP    := Val(SubStr(cBuffer,53,14))/100//Val(SubStr(cBuffer,53,12)+"."+SubStr(cBuffer,65,2))
	TRB->DI      := Alltrim(SubStr(cBuffer,67,12))
	TRB->DT_DI   := CtoD(SubStr(cBuffer,79,02)+"/"+SubStr(cBuffer,81,02)+"/"+SubStr(cBuffer,83,04))
	TRB->INVOICE := Alltrim(SubStr(cBuffer,87,12))
	TRB->ADICAO  := Alltrim(SubStr(cBuffer,99,16))
	TRB->VLR_TOT := Val(SubStr(cBuffer,115,14))/100//Val(SubStr(cBuffer,115,12)+"."+SubStr(cBuffer,127,2))
	TRB->ALQ_IPI := Val(SubStr(cBuffer,129,06))/100//Val(SubStr(cBuffer,129,4)+"."+SubStr(cBuffer,133,2))
	TRB->VLR_IPI := Val(SubStr(cBuffer,135,14))/100//Val(SubStr(cBuffer,135,12)+"."+SubStr(cBuffer,147,02))
	TRB->BAS_IPI := Val(SubStr(cBuffer,149,14))/100//Val(SubStr(cBuffer,149,12)+"."+SubStr(cBuffer,161,02))
	TRB->ALQ_ICM := Val(SubStr(cBuffer,163,06))/100//Val(SubStr(cBuffer,163,04)+"."+SubStr(cBuffer,167,02))
	TRB->VLR_ICM := Val(SubStr(cBuffer,169,14))/100//Val(SubStr(cBuffer,169,12)+"."+SubStr(cBuffer,181,02))
	TRB->BAS_ICM := Val(SubStr(cBuffer,183,14))/100//Val(SubStr(cBuffer,183,12)+"."+SubStr(cBuffer,195,02))
	TRB->ALQ_II  := Val(SubStr(cBuffer,197,06))/100//Val(SubStr(cBuffer,197,04)+"."+SubStr(cBuffer,201,02))
	TRB->VLR_II  := Val(SubStr(cBuffer,203,14))/100//Val(SubStr(cBuffer,203,12)+"."+SubStr(cBuffer,215,02))
	TRB->BAS_II  := Val(SubStr(cBuffer,217,14))/100//Val(SubStr(cBuffer,217,12)+"."+SubStr(cBuffer,229,02))
	TRB->ALQ_PIS := Val(SubStr(cBuffer,231,06))/100//Val(SubStr(cBuffer,231,04)+"."+SubStr(cBuffer,235,02))
	TRB->VLR_PIS := Val(SubStr(cBuffer,237,14))/100//Val(SubStr(cBuffer,237,12)+"."+SubStr(cBuffer,249,02))
	TRB->BAS_PIS := Val(SubStr(cBuffer,251,14))/100//Val(SubStr(cBuffer,251,12)+"."+SubStr(cBuffer,263,02))
	TRB->ALQ_COF := Val(SubStr(cBuffer,265,06))/100//Val(SubStr(cBuffer,265,04)+"."+SubStr(cBuffer,269,02))
	TRB->VLR_COF := Val(SubStr(cBuffer,271,14))/100//Val(SubStr(cBuffer,271,12)+"."+SubStr(cBuffer,283,02))
	TRB->BAS_COF := Val(SubStr(cBuffer,285,14))/100//Val(SubStr(cBuffer,285,12)+"."+SubStr(cBuffer,297,02))
	TRB->MOEDA   := Val(SubStr(cBuffer,299,02))
	TRB->CONDPGT := Val(SubStr(cBuffer,301,03))
	TRB->TT_INVO := Val(SubStr(cBuffer,304,17))/100//Val(SubStr(cBuffer,304,15)+"."+SubStr(cBuffer,319,02))
	TRB->NCONT   := nCont
	TRB->COD_NEW := Alltrim(SubStr(cBuffer,11,15))
	TRB->(msUnLock())
	
	FT_FSkip()
	nCont++
EndDo

fClose(cArq)

// Campo DE-PARA do Codigo de Produto Protheus x Codigo de Produto Despachante Aduaneiro
If SB1->(!FieldPos("B1_CODIMP")>0)
	MsgStop("Campo B1_CODIMP nใo localizado... Contate o Administrador do Sistema!")
	TRB->(dbCloseArea())
	Return
EndIf

// Consiste Cadastro de Produtos
dbSelectArea("TRB")
TRB->(dbGoTop())

ProcRegua(TRB->(RecCount()))
Do While TRB->( !Eof() )
	cCodPro := AllTrim(TRB->COD_PRO)
	IncProc("Consistindo produtos... " +cCodPro)
	
	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) ) // B1_FILIAL+B1_COD
	If SB1->( DbSeek(xFilial("SB1")+cCodPro) )
		cCodNew := cCodPro
	Else
		If Select("WorkTt")>0
			WorkTt->(dbCloseArea())
		EndIf
		
		_cQuery := "SELECT COUNT(1) TTPROD"
		_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
		_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
		_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro+"' "
		_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
		
		_cQuery := ChangeQuery(_cQuery)
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "WorkTt", .T., .T.)
		
		If WorkTt->TTPROD > 1
			//MsgInfo("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... O sistema tentarแ localizar pelo C๓digo do Produto fornecido pelo Despachante Aduaneiro!")
			
			If Select("WorkTt")>0
				WorkTt->(dbCloseArea())
			EndIf
			
			_cQuery := "SELECT COUNT(1) TTPROD"
			_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
			_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
			_cQuery += " AND SB1.B1_CODIMP = '"+cCodPro+"' "
			_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
			
			_cQuery := ChangeQuery(_cQuery)
			
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "WorkTt", .T., .T.)
			
			If WorkTt->TTPROD > 1
				MsgStop("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
				TRB->(dbCloseArea())
				Return
			ElseIf WorkTt->TTPROD == 0
				cCodPro2 := Left(cCodPro,12)
				
				If Select("WorkTt")>0
					WorkTt->(dbCloseArea())
				EndIf
				
				_cQuery := "SELECT COUNT(1) TTPROD"
				_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
				_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
				_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro2+"' " //% no final
				_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
				
				_cQuery := ChangeQuery(_cQuery)
				
				DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "WorkTt", .T., .T.)
				
				If WorkTt->TTPROD == 1
					If Select("Work")>0
						Work->(dbCloseArea())
					EndIf
					
					_cQuery := "SELECT * "
					_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
					_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
					_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro2+"' " //% no final
					_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
					
					_cQuery := ChangeQuery(_cQuery)
					
					DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "Work", .T., .T.)
					
					cCodNew := Work->B1_COD
					
					If MsgYesNo("Foi encontrado o produto " +cCodNew+ " utilizando o c๓digo contido no arquivo: " +cCodPro+ " ... Realmente ้ este c๓digo?")
						RecLock("TRB", .F.)
						TRB->COD_NEW := cCodNew
						TRB->(msUnLock())
					Else
						TRB->(dbCloseArea())
						Return
					EndIf
				Else
					MsgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
					TRB->(dbCloseArea())
					Return
				EndIf
				
			Else
				If Select("Work")>0
					Work->(dbCloseArea())
				EndIf
				
				_cQuery := "SELECT * "
				_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
				_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
				_cQuery += " AND SB1.B1_CODIMP = '"+cCodPro+"' "
				_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
				
				_cQuery := ChangeQuery(_cQuery)
				
				DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "Work", .T., .T.)
				
				cCodNew := Work->B1_COD
				
				RecLock("TRB", .F.)
				TRB->COD_NEW := cCodNew
				TRB->(msUnLock())
			EndIf
			
		ElseIf WorkTt->TTPROD == 0
			//MsgInfo("Produto " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... O sistema tentarแ localizar pelo C๓digo do Produto fornecido pelo Despachante Aduaneiro!")
			
			If Select("WorkTt")>0
				WorkTt->(dbCloseArea())
			EndIf
			
			_cQuery := "SELECT COUNT(1) TTPROD"
			_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
			_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
			_cQuery += " AND SB1.B1_CODIMP = '"+cCodPro+"' "
			_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
			
			_cQuery := ChangeQuery(_cQuery)
			
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "WorkTt", .T., .T.)
			
			If WorkTt->TTPROD > 1
				MsgStop("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
				TRB->(dbCloseArea())
				Return
			ElseIf WorkTt->TTPROD == 0
				cCodPro2 := Left(cCodPro,12)
				
				If Select("WorkTt")>0
					WorkTt->(dbCloseArea())
				EndIf
				
				_cQuery := "SELECT COUNT(1) TTPROD"
				_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
				_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
				_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro2+"' " //% no final
				_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
				
				_cQuery := ChangeQuery(_cQuery)
				
				DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "WorkTt", .T., .T.)
				
				If WorkTt->TTPROD == 1
					If Select("Work")>0
						Work->(dbCloseArea())
					EndIf
					
					_cQuery := "SELECT * "
					_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
					_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
					_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro2+"' " //% no final
					_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
					
					_cQuery := ChangeQuery(_cQuery)
					
					DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "Work", .T., .T.)
					
					cCodNew := Work->B1_COD
					
					If MsgYesNo("Foi encontrado o produto " +cCodNew+ " utilizando o c๓digo contido no arquivo: " +cCodPro+ " ... Realmente ้ este c๓digo?")
						RecLock("TRB", .F.)
						TRB->COD_NEW := cCodNew
						TRB->(msUnLock())
					Else
						TRB->(dbCloseArea())
						Return
					EndIf
				Else
					MsgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
					TRB->(dbCloseArea())
					Return
				EndIf
			Else
				If Select("Work")>0
					Work->(dbCloseArea())
				EndIf
				
				_cQuery := "SELECT * "
				_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
				_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
				_cQuery += " AND SB1.B1_CODIMP = '"+cCodPro+"' "
				_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
				
				_cQuery := ChangeQuery(_cQuery)
				
				DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "Work", .T., .T.)
				
				cCodNew := Work->B1_COD
				
				RecLock("TRB", .F.)
				TRB->COD_NEW := cCodNew
				TRB->(msUnLock())
			EndIf
			
		Else
			If Select("Work")>0
				Work->(dbCloseArea())
			EndIf
			
			_cQuery := "SELECT * "
			_cQuery += " FROM " +RetSqlName("SB1")+ " SB1"
			_cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
			_cQuery += " AND SB1.B1_COD LIKE '%"+cCodPro+"' "
			_cQuery += " AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MSBLQL <> '1' "
			
			_cQuery := ChangeQuery(_cQuery)
			
			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "Work", .T., .T.)
			
			cCodNew := Work->B1_COD
			
			RecLock("TRB", .F.)
			TRB->COD_NEW := cCodNew
			TRB->(msUnLock())
		EndIf
	EndIf
	
	TRB->( DbSkip() )
EndDo
_aReserv:= ReservNF()

//Inclui Documento Entrada
_nCont    	:= 1
_cNFIni   	:= cMvDoc
_cNFAux   	:= _cNFIni
_cAdicao 	:= ""

If Len(_aReserv) > 0
	ProcRegua( TRB->( RecCount() ) )
	
	If Alltrim(cEmpAnt) == "01"
		cSerieNF:="002"
	ElseIf Alltrim(cEmpAnt) == "02"
		cSerieNF:=		"1  "
	Endif
	
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	
	DbSelectArea("TRB")
	TRB->(dbGoTop())
	
	SA2->(DbSeek(xFilial("SA2")+MV_PAR02+MV_PAR03))
	cNomeFab := SA2->A2_NOME
	
	
	
	Do While TRB->(!EOF())
		
		If _nCont == 1
			IncProc("Preparando Informa็๕es da Adi็ใo / NF :" + _cAdicao +_cNFAux )
			aCabNF :={ 	{"F1_TIPO"		,"N"			,NIL},;
			{"F1_FORMUL"	,"S"			,NIL},;
			{"F1_DOC"		,_cNFAux		,Nil},;
			{"F1_SERIE"		,cSerieNF		,Nil},;
			{"F1_EMISSAO"	,dDataBase		,Nil},;
			{"F1_FORNECE"	,MV_PAR02       ,NIL},;
			{"F1_LOJA"   	,MV_PAR03       ,NIL},;
			{"F1_ESPECIE"	,"SPED"    		,NIL},;
			{"F1_FILIAL"	,"01"       	,NIL},;
			{"CTIPO"		,"N"        	,NIL},;
			{"F1_COND"		,"001"      	,NIL} ,;
			{"F1_MOEDA"		, TRB->MOEDA   	,NIL} ,;
			{"F1_TXMOEDA"	, MV_PAR11	   	,NIL} ,;
			{"F1_EST"		,"EX"			,Nil} ,;
			{"F1_XMENS1" 	, "DI " + TRB->DI + " DE " + DtoC(TRB->DT_DI) + chr(32) + TRB->INVOICE			 ,Nil} ,;
			{"F1_XNDI"  	, TRB->DI		,Nil},;
			{"F1_XDTDI"  	, MV_PAR04		,Nil},;
			{"F1_XLOCDES"  	, MV_PAR05		,Nil},;
			{"F1_XUFDES"  	, MV_PAR06		,Nil},;
			{"F1_XDTDES"  	, MV_PAR07		,Nil},;
			{"F1_XCODEXP"  	, MV_PAR08		,Nil},;
			{"F1_XEMAILD"  	, MV_PAR10		,Nil},;
			{"F1_II"    	, 0     		,Nil},;
			{"F1_DESPESA"	, 0          	,NIL},;
			{"E2_NATUREZ"	,"2002"      	,NIL}}
			_cAdicao := TRB->ADICAO
			aLinhaNF 	:= {}
			aLinhaPre   := {}
		Endif
		
		If _cAdicao == TRB->ADICAO
			
			IncProc("Preparando Itens NF - Adicao... "+_cAdicao)
			SB1->(dbSeek(xFilial("SB1")+TRB->COD_NEW))
			
			aItmNF := {	{"D1_FILIAL" , xFilial("SD1")	, Nil},;
			{"D1_ITEM"   , StrZero(_nCont,4) , Nil},;
			{"D1_COD"    , TRB->COD_NEW     , Nil},;
			{"D1_QUANT"  , TRB->QTD         , Nil},;
			{"D1_VUNIT"  , TRB->UNIT        , Nil},;
			{"D1_TOTAL"  , TRB->(QTD*UNIT)  , Nil},;
			{"D1_OPER"   , "01"             , Nil},;
			{"D1_TES"    , "254"            , Nil},;
			{"D1_CF"     , "3102"           , Nil},;
			{"D1_FORNECE", MV_PAR02         , Nil},;
			{"D1_LOJA"   , MV_PAR03         , Nil},;
			{"D1_UM"     , SB1->B1_UM       , Nil},;
			{"D1_LOCAL"  , SB1->B1_LOCPAD   , Nil},;
			{"D1_DOC"    , _cNFAux          , Nil},;
			{"D1_EMISSAO", dDataBase		, Nil},;
			{"D1_TIPO"   , "N"	            , Nil},;
			{"D1_SERIE"  , cSerieNF         , Nil},;
			{"D1_VALIPI" , TRB->VLR_IPI     , Nil},;
			{"D1_VALICM" , TRB->VLR_ICM     , Nil},;
			{"D1_IPI"    , TRB->ALQ_IPI     , Nil},;
			{"D1_PICM"   , TRB->ALQ_ICM     , Nil},;
			{"D1_DTDIGIT", dDataBase		, Nil},;
			{"D1_GRUPO"  , SB1->B1_GRUPO    , Nil},;
			{"D1_CLASFIS", SB1->B1_ORIGEM+Posicione("SF4",1,xFilial("SF4")+"254","F4_SITTRIB")        , Nil},;
			{"D1_XOPER"  , "60"             , Nil},;
			{"D1_DI"	 , TRB->DI			, Nil},;
			{"D1_ADIC"	 , Right(TRB->ADICAO,3)	, Nil},;
			{"D1_DIIT"	 , StrZero(_nCont,3)	, Nil},;
			{"D1_ALIQII" , TRB->ALQ_II		, Nil},;
			{"D1_II"	 , ROUND(NOROUND(TRB->VLR_II,2),2), Nil},;
			{"D1_XFABRIC", MV_PAR09	       	, Nil},;
			{"D1_DESPESA", TRB->DESP        , Nil},;
			{"D1_CONTA"  , "421001000001"     , Nil}}

			
			aItmPre := {	{"D1_FILIAL" , xFilial("SD1")	, Nil},;
			{"D1_ITEM"   , StrZero(_nCont,4) , Nil},;
			{"D1_COD"    , TRB->COD_NEW     , Nil},;
			{"D1_QUANT"  , TRB->QTD         , Nil},;
			{"D1_VUNIT"  , TRB->UNIT        , Nil},;
			{"D1_TOTAL"  , TRB->(QTD*UNIT)  , Nil},;
			{"D1_UM"     , SB1->B1_UM       , Nil},;
			{"D1_LOCAL"  , SB1->B1_LOCPAD   , Nil},;
			{"D1_TIPO"   , "N"	            , Nil},;
			{"D1_DTDIGIT", dDataBase		, Nil},;
			{"D1_GRUPO"  , SB1->B1_GRUPO    , Nil},;
			{"D1_XOPER"  , "60"             , Nil},;
			{"D1_DI"	 , TRB->DI			, Nil},;
			{"D1_ADIC"	 , Right(TRB->ADICAO,3)	, Nil},;
			{"D1_DIIT"	 , StrZero(_nCont,3)	, Nil},;
			{"D1_ALIQII" , TRB->ALQ_II		, Nil},;
			{"D1_II"	 , ROUND(NOROUND(TRB->VLR_II,2),2), Nil},;
			{"D1_XFABRIC", MV_PAR09	       	, Nil},;
			{"D1_DESPESA", TRB->DESP        , Nil},;
			{"D1_CONTA"  , "421001000001"     , Nil}}
			
			aAdd(aLinhaNF,aItmNF)
			aCabNF[23][2] += ROUND(NOROUND(aItmNF[30][2],2),2)//Valor II
			aCabNF[24][2] += ROUND(NOROUND(aItmNF[32][2],2),2)//Valor Despesa
			aAdd(aLinhaPre,aItmPre)
			
//================   cavalini  == GERACAO DO CONTROLE DA QUALIDADE
			_CNRLOT := ""
			CPARAM  := "MV_DOCTRAN"

			// ACHA O NUMERO DO LOTE
			_CNRLOT := GETMV("MV_DOCTRAN")

			DBSELECTAREA("SD7")
			RECLOCK("SD7",.T.)
			 SD7->D7_FILIAL  := XFILIAL("SD7")
			 SD7->D7_SEQ     := "001"
			 SD7->D7_PRODUTO := TRB->COD_NEW
			 SD7->D7_TIPO    := 0
			 SD7->D7_QTDE    := TRB->QTD
			 SD7->D7_SALDO   := TRB->QTD
			 SD7->D7_USUARIO := SUBSTR(CUSUARIO,7,15)
			 SD7->D7_NUMSEQ  := ProxNum()
			 SD7->D7_LOCAL   := "98"
			 SD7->D7_LOCDEST := "98"
			 SD7->D7_NUMERO  := "I"+_CNRLOT
			 SD7->D7_DATA    := dDataBase
			 SD7->D7_ORIGLAN := "CP"
			 SD7->D7_TIPOCQ  := "M"
			 SD7->D7_DOC     := CDOC
		     SD7->D7_FORNECE := mv_par02
		     SD7->D7_LOJA    := mv_par03
	
 			 If SM0->M0_CODIGO == "01"
			   SD7->D7_SERIE := "002"
		     ElseIf SM0->M0_CODIGO == "02"
			   SD7->D7_SERIE := "1  "
		     Endif
			MSUNLOCK("SD7")      
	                           
			// ACERTA O NUMERO DO LOTE
			dbSelectArea("SX6")
			GetMV("MV_DOCTRAN")
			RecLock("SX6",.F.)
			 SX6->X6_CONTEUD := Soma1(GetMV("MV_DOCTRAN"),5)
			MSUnlock("SX6")                      
			
			
			    // TRATAMENTO DO SALDO EM ESTOQUE - SB2 - LOCAL 98
    // RICARDO CAVALINI
    DBSELECTAREA("SB2")
    DBSETORDER(1)
    IF !DBSEEK(XFILIAL("SB2")+TRB->COD_NEW+"98")
       DBSELECTAREA("SB2")
       RECLOCK("SB2",.T.)
        SB2->B2_FILIAL := XFILIAL("SB2")
        SB2->B2_COD    := TRB->COD_NEW
        SB2->B2_LOCAL  := "98"
        SB2->B2_QATU   := TRB->QTD
        SB2->B2_VATU1  := TRB->QTD
        SB2->B2_CM1    := 1
       MSUNLOCK("SB2")
    ELSE
       DBSELECTAREA("SB2")
       RECLOCK("SB2",.F.)
        SB2->B2_QATU   := SB2->B2_QATU  + TRB->QTD
        SB2->B2_VATU1  := SB2->B2_VATU1 + TRB->QTD
        SB2->B2_CM1    := 1
       MSUNLOCK("SB2")
    ENDIF

    // TRATAMENTO DO SALDO EM ESTOQUE - SB2 - LOCAL 01
    // RICARDO CAVALINI
    DBSELECTAREA("SB2")
    DBSETORDER(1)
    IF !DBSEEK(XFILIAL("SB2")+TRB->COD_NEW+"01")
       DBSELECTAREA("SB2")
       RECLOCK("SB2",.T.)
        SB2->B2_FILIAL := XFILIAL("SB2")
        SB2->B2_COD    := TRB->COD_NEW
        SB2->B2_LOCAL  := "01"
        SB2->B2_QATU   := 0
        SB2->B2_VATU1  := 0
        SB2->B2_CM1    := 0
       MSUNLOCK("SB2")
    ENDIF

			
			
			

			DbSelectArea("TRB")

		Endif

		TRB->(dbSkip())            
		
		If _cAdicao <> TRB->ADICAO .OR. _nCont == 11
			_cNFAux  := Soma1(_cNFAux,6)
			_nCont   := 1
			aAdd( _aProcNF,{aCabNF,aLinhaNF,aLinhaPre} )
		Else
			_cAdicao := TRB->ADICAO
			_nCont++
		Endif
		
	EndDo
Endif

TRB->( DbCloseArea() )
Ferase(cFile+".DBF")
Ferase(cFile+OrdBagExt())

_cTxt  := ""
_cTxt1 := ""

DbSelectArea("SA2")
SA2->( DbSetOrder(1) )

DbSelectArea("SF1")
SF1->( DbSetOrder(1))
SF1->( DbGoTop())
_aAreaSF1:= SF1->( GetArea() )


RestArea(_aAreaSF1)
DbSelectArea("SD1")
SD1->( DbSetOrder(1) )

DbSelectArea("SF4")
SF4->( DbSetOrder(1) )

For _nX:= 1 to Len(_aProcNF)
	//F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
	If !SF1->( DbSeek( xFilial("SF1")+_aProcNF[_nX][1][3][2] + _aProcNF[_nX][1][4][2]+SA2->(A2_COD+A2_LOJA)+_aProcNF[_nX][1][1][2] ) )
		lMsErroAuto := .F.
		
		RestArea(_aAreaSF1)
		LjMsgRun( "Gravando informa็๕es da NF Importa็ใo n๚mero: "+_aProcNF[_nX][1][3][2],, { || MsExecAuto({|x,y,z| MATA103(x,y,z)},_aProcNF[_nX][1],_aProcNF[_nX][2],3) } )
		//LjMsgRun("Gravando informa็๕es da Pr้ Nota (Classsificada) Importa็ใo n๚mero: "+_aProcNF[_nX][1][3][2],, { || MATA140(_aProcNF[_nX][1],_aProcNF[_nX][2],3) } )
		If lMsErroAuto
			MostraErro()
			lMsErroAuto := .F.
			LjMsgRun("Gravando informa็๕es da Pr้ Nota n๚mero: "+_aProcNF[_nX][1][3][2],, { || MATA140(_aProcNF[_nX][1],_aProcNF[_nX][3],3) } )
			If lMsErroAuto
				MostraErro()
			Else
				If _nX <> Len(_aProcNF)
					_cTxt1 += _aProcNF[_nX][1][3][2] + " / "
				Else
					_cTxt1 += _aProcNF[_nX][1][3][2]
				Endif
			Endif
			lMsErroAuto := .F.
		Else
			If _nX <> Len(_aProcNF)
				_cTxt += _aProcNF[_nX][1][3][2] + " / "
			Else
				_cTxt += _aProcNF[_nX][1][3][2]
			Endif
		Endif
	Else
		MsgStop("Nota Fiscal N๚mero: "+_aProcNF[_nX][1][3][2] + "/" +_aProcNF[_nX][1][4][2] +" / "+Alltrim(cNomeFab)+" jแ gravada anteriormente","ATENCAO")
	Endif
Next _nX

If !Empty(_cTxt)
	MsgInfo("Geradas NF Importa็ใo n๚mero: " +_cTxt )
Endif
If !Empty(_cTxt1)
	MsgInfo("Geradas Pr้-Notas Importa็ใo n๚mero: " +_cTxt1 )
Endif

RestArea( _aAreaSB1 )
RestArea( _aAreaSF1 )
RestArea( _aAreaSD1 )
RestArea( _aAreaSE2 )
RestArea( _aAreaSA2 )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  08/20/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCheca/Corrige SX1                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณVerion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Reserva da NF  ?","","","mv_ch1","C", 06,0,0,"G",          "","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Exportador     ?","","","mv_ch2","C", 06,0,0,"G",          "","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"03","Loja           ?","","","mv_ch3","C", 02,0,0,"G",          "","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data DI        ?","","","mv_ch4","D", 08,0,0,"G",          "","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Local Desemb.  ?","","","mv_ch5","C", 60,0,0,"G",          "","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Uf.Desembara็o ?","","","mv_ch6","C", 02,0,0,"G",          "","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Data Desemb.   ?","","","mv_ch7","D", 08,0,0,"G",          "","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Cod.Exportador ?","","","mv_ch8","C", 60,0,0,"G",          "","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Fabricante     ?","","","mv_ch9","C", 60,0,0,"G",          "","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Email Despach  ?","","","mv_cha","C", 60,0,0,"G",          "","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Taxa Moeda Imp.?","","","mv_chb","N", 11,4,0,"G",          "","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(PADR(cPerg,10)+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_sAlias)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CHKPERG  บAutor  ณMicrosiga           บ Data ณ  08/20/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Checa a reserva de numeracao das notas fiscais             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ VERION                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkPerg()
Local aAreaAtu := GetArea()

MV_PAR01 := NxtSx5Nota("002", .T., GetNewPar("MV_TPNRNFS", "1"))
cMvDoc := MV_PAR01
cMvFor := MV_PAR02
cMvLj  := MV_PAR03
nMvTX  := MV_PAR11

If nMvTX <=0 .OR. nMvTX >= 100
	Aviso("Aten็ใo!", "Taxa da Moeda nใo informada ou inconsistente... Checar!",{"Ok"})
	lReserv := .f.
	Return
Endif

If Empty(cMvDoc) .or.;
	!Left(AllTrim(cMvDoc),1)$"0123456789"
	Aviso("Aten็ใo!", "Numera็ใo das NF incorretas... Checar!",{"Ok"})
	lReserv := .f.
	Return
EndIf

DbSelectArea("SA2")
DbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
If !DbSeek(xFilial("SA2")+cMvFor+cMvLj)
	Aviso("Aten็ใo!", "Fornecedor nใo cadastrado... Checar!", {"Ok"})
	lReserv := .f.
	Return
EndIf

DbSelectArea("SF1")
DbSetOrder(1) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

If DbSeek(xFilial("SF1")+cMvDoc+"1  "+cMvFor+cMvLj)
	Aviso("Aten็ใo!", "Nota Fiscal " + cMvDoc + " jแ cadastrada... Checar!", {"Ok"})
	lReserv := .f.
	Return
EndIf

RestArea(aAreaAtu)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReservNF  บAutor  ณMicrosiga           บ Data ณ  09/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReservNF()
Local nCont    	:= 1
Local cNFIni   	:= cMvDoc
Local cNFAux   	:= cNFIni
Local cTxt 		:= ""
Local cAdicao 	:= ""
Local aAreaAtu 	:= GetArea()
Local aReserv  	:= {}
Local _nI

DbSelectArea("TRB")
TRB->(dbGoTop())

ProcRegua(TRB->(RecCount()))

aAdd(aReserv,{cNFIni,TRB->ADICAO})

Do While TRB->(!EOF())
	cAdicao := TRB->ADICAO
	Do While cAdicao == TRB->ADICAO
		IncProc("Preparando reserva das NFs... " +cAdicao)
		If nCont > 11
			nCont   := 1
			cNFAux  := Soma1(cNFAux,6)
			aAdd(aReserv,{cNFAux,TRB->ADICAO})
			cAdicao := TRB->ADICAO
		EndIf
		TRB->(dbSkip())
		nCont++
	EndDo
	
	If TRB->(!EOF())
		nCont   := 1
		cNFAux  := Soma1(cNFAux,6)
		aAdd(aReserv,{cNFAux,TRB->ADICAO})
	EndIf
EndDo

For _nI:=1 To Len(aReserv)
	If _nI <> Len(aReserv)
		cTxt += aReserv[_nI][1] + " / "
	Else
		cTxt += aReserv[_nI][1]
	Endif
Next _nI

MsgInfo("Notas fiscais a serem separadas: " +cTxt )

RestArea(aAreaAtu)

Return aReserv

