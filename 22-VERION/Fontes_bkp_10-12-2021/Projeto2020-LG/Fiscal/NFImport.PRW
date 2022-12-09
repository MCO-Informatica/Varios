#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFIMPORT  บAutor  ณMicrosiga           บ Data ณ  08/15/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nota Fiscal Importa็ใo                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function NFImport()

Local _aArea1  := GetArea()  // guarda a area
Local _dServer := Date()     // data do servidor 
Local _dSiga   := DDataBase  // data do sistema
Local _lEmis   := .T.        // Retorno esperado pelo sistema  (.t. ou .f.)
Public _cNumNotas := ""
Public lPriNF := .T.

If  _dSiga < _dServer 

	IF MSGYESNO("Data do Sistema Protheus menor que a Data Base. Deseja continuar ?")
		Rodai()
	Else
		Msgbox("A nota fiscal nใo serแ gerada. Ajuste a data do sistema !")
	ENDIF
eLSE
	Rodai()
Endif    

_cNumNotas := Substr(_cNumNotas,1,Len(_cNumNotas)-1)  //retira ๚ltima barra Ex.: 000340/ para 000340
If !Empty(_cNumNotas)
	MsgInfo("Notas fiscais a serem separadas: " +_cNumNotas )
Endif

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
cPerg    := "NFEIMP    "
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
Local cFile, cBuffer, aImp, cQuery, cCodPro, cCodNew, aCabNF, aItmNF, nCont, cDoc, cAdicao, nItem, lSF1, lAdic , nTotIt
Private nHdl, cFile, lMSHelpAuto, lMsErroAuto, nDesp, nBaseICM, nValICM, nBaseIPI, nValIPI, nBasePis, nValPis, nBaseCof, nValCof, nBasCIF, nValII, nTtInvo, nValTt

lSF1    := .t.
lAdic   := .f.
bZeraTt := {||(nDesp := nBaseICM := nValICM := nBaseIPI := nValIPI := nBasePis := nValPis := nBaseCof := nValCof := nBasCIF := nValII := nValTt := 0)}
aImp    := {}

aAdd(aImp,{"NCM    ","C",10,0})
aAdd(aImp,{"COD_PRO","C",22,0})
aAdd(aImp,{"QTD    ","N",11,2})
aAdd(aImp,{"UNIT   ","N",16,4})
aAdd(aImp,{"DESP   ","N",14,2})
aAdd(aImp,{"DI     ","C",12,0})
aAdd(aImp,{"DT_DI  ","D",08,0})
aAdd(aImp,{"INVOICE","C",12,0})
aAdd(aImp,{"ADICAO ","C",16,0})
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
aAdd(aImp,{"COD_NEW","C",22,0})
aAdd(aImp,{"NCONT  ","N",04,0})

cFile := e_CriaTrab(,aImp,"TRB")
IndRegua("TRB",cFile,"ADICAO",,,"Ordenando registros...")
	
If !File(cArq)
	Aviso("Aten็ใo!", "Arquivo invแlido!",{"Ok"})
	TRB->(dbCloseArea())
	Return
EndIf
	
nHdl := ft_fUse(cArq)
If nHdl<>Nil .and. nHdl<=0
	Aviso("Aten็ใo", "Nใo foi possํvel a abertura do arquivo "+AllTrim(cArq)+" !", {"Ok"})
	fClose(cArq)
	Return
EndIf
	
nCont := 1
_lErroArq := .F.
ProcRegua(ft_fLastRec())
ft_fGoTop()
Do While !ft_fEOF()
	IncProc("Importando arquivo... " +cArq)
		
	cBuffer := ft_fReadLN()
	cBuffer := AllTrim(Upper(cBuffer))
		
	RecLock("TRB", .t.)
	/*
	TRB->NCM     := Subs(cBuffer,01,04)+Subs(cBuffer,06,02)+Subs(cBuffer,09,02)
	TRB->COD_PRO := Subs(cBuffer,11,15)
	TRB->QTD     := Val(Subs(cBuffer,26,09)+"."+Subs(cBuffer,35,2))
	TRB->UNIT    := Val(Subs(cBuffer,37,12)+"."+Subs(cBuffer,49,4))
	TRB->DESP    := Val(Subs(cBuffer,53,12)+"."+Subs(cBuffer,65,2))
	TRB->DI      := Subs(cBuffer,67,12)
	TRB->DT_DI   := CtoD(Subs(cBuffer,79,02)+"/"+Subs(cBuffer,81,2)+"/"+Subs(cBuffer,83,4))
	TRB->INVOICE := Subs(cBuffer,87,12)
	TRB->ADICAO  := Subs(cBuffer,99,16)
	TRB->VLR_TOT := Val(Subs(cBuffer,115,12)+"."+Subs(cBuffer,127,2))
	TRB->ALQ_IPI := Val(Subs(cBuffer,129,4)+"."+Subs(cBuffer,133,2))
	TRB->VLR_IPI := Val(Subs(cBuffer,135,12)+"."+Subs(cBuffer,147,2))
	TRB->BAS_IPI := Val(Subs(cBuffer,149,12)+"."+Subs(cBuffer,161,2))
	TRB->ALQ_ICM := Val(Subs(cBuffer,163,4)+"."+Subs(cBuffer,167,2))
	TRB->VLR_ICM := Val(Subs(cBuffer,169,12)+"."+Subs(cBuffer,181,2))
	TRB->BAS_ICM := Val(Subs(cBuffer,183,12)+"."+Subs(cBuffer,195,2))
//	If TRB->VLR_ICM <> round((TRB->BAS_ICM*TRB->ALQ_ICM/100),2)       retirado pois hora arredonda e hora nใo arredonda o valor - alex - 08/04/2015
//		_lErroArq := .T.
//	Endif	
	TRB->ALQ_II  := Val(Subs(cBuffer,197,4)+"."+Subs(cBuffer,201,2))
	TRB->VLR_II  := Val(Subs(cBuffer,203,12)+"."+Subs(cBuffer,215,2))
	TRB->BAS_II  := Val(Subs(cBuffer,217,12)+"."+Subs(cBuffer,229,2))
	TRB->ALQ_PIS := Val(Subs(cBuffer,231,4)+"."+Subs(cBuffer,235,2))
	TRB->VLR_PIS := Val(Subs(cBuffer,237,12)+"."+Subs(cBuffer,249,2))
	TRB->BAS_PIS := Val(Subs(cBuffer,251,12)+"."+Subs(cBuffer,263,2))
	TRB->ALQ_COF := Val(Subs(cBuffer,265,4)+"."+Subs(cBuffer,269,2))
	TRB->VLR_COF := Val(Subs(cBuffer,271,12)+"."+Subs(cBuffer,283,2))
	TRB->BAS_COF := Val(Subs(cBuffer,285,12)+"."+Subs(cBuffer,297,2))
	TRB->MOEDA   := Val(Subs(cBuffer,299,2))
	TRB->CONDPGT := Val(Subs(cBuffer,301,3))
	TRB->TT_INVO := Val(Subs(cBuffer,304,15)+"."+Subs(cBuffer,319,2))
	TRB->NCONT   := nCont
	TRB->COD_NEW := Subs(cBuffer,11,15)
	*/

	TRB->NCM     := StrTran(Subs(cBuffer,01,10), ".", "")
	TRB->COD_PRO := Subs(cBuffer,11,22)
	TRB->QTD     := Val(Subs(cBuffer,33,09)+"."+Subs(cBuffer,42,2))
	TRB->UNIT    := Val(Subs(cBuffer,44,12)+"."+Subs(cBuffer,56,4))
	TRB->DESP    := Val(Subs(cBuffer,60,12)+"."+Subs(cBuffer,72,2))
	TRB->DI      := Subs(cBuffer,74,12)
	TRB->DT_DI   := CtoD(Subs(cBuffer,86,02)+"/"+Subs(cBuffer,88,2)+"/"+Subs(cBuffer,90,4))
	TRB->INVOICE := Subs(cBuffer,94,12)
	TRB->ADICAO  := Subs(cBuffer,106,16)
	TRB->VLR_TOT := Val(Subs(cBuffer,122,12)+"."+Subs(cBuffer,134,2))
	TRB->ALQ_IPI := Val(Subs(cBuffer,136,4)+"."+Subs(cBuffer,140,2))
	TRB->VLR_IPI := Val(Subs(cBuffer,142,12)+"."+Subs(cBuffer,154,2))
	TRB->BAS_IPI := Val(Subs(cBuffer,156,12)+"."+Subs(cBuffer,168,2))
	TRB->ALQ_ICM := Val(Subs(cBuffer,170,4)+"."+Subs(cBuffer,174,2))
	TRB->VLR_ICM := Val(Subs(cBuffer,176,12)+"."+Subs(cBuffer,188,2))
	TRB->BAS_ICM := Val(Subs(cBuffer,190,12)+"."+Subs(cBuffer,202,2))
	TRB->ALQ_II  := Val(Subs(cBuffer,204,4)+"."+Subs(cBuffer,208,2))
	TRB->VLR_II  := Val(Subs(cBuffer,210,12)+"."+Subs(cBuffer,222,2))
	TRB->BAS_II  := Val(Subs(cBuffer,224,12)+"."+Subs(cBuffer,236,2))
	TRB->ALQ_PIS := Val(Subs(cBuffer,238,4)+"."+Subs(cBuffer,242,2))
	TRB->VLR_PIS := Val(Subs(cBuffer,244,12)+"."+Subs(cBuffer,256,2))
	TRB->BAS_PIS := Val(Subs(cBuffer,258,12)+"."+Subs(cBuffer,270,2))
	TRB->ALQ_COF := Val(Subs(cBuffer,272,4)+"."+Subs(cBuffer,276,2))
	TRB->VLR_COF := Val(Subs(cBuffer,278,12)+"."+Subs(cBuffer,290,2))
	TRB->BAS_COF := Val(Subs(cBuffer,292,12)+"."+Subs(cBuffer,304,2))
	TRB->MOEDA   := Val(Subs(cBuffer,306,2))
	TRB->CONDPGT := Val(Subs(cBuffer,308,3))
	TRB->TT_INVO := Val(Subs(cBuffer,311,15)+"."+Subs(cBuffer,326,2))
	TRB->NCONT   := nCont
	TRB->COD_NEW := Subs(cBuffer,11,22)

	TRB->(msUnLock())
	
	//Retira o II
	//RecLock("TRB", .f.)	
	//   TRB->UNIT    := TRB->UNIT - (TRB->(VLR_II/QTD))
	//   TRB->VLR_TOT := TRB->(VLR_TOT-VLR_II)
	//TRB->(msUnLock())
		
	ft_fSkip()
	nCont++
EndDo
	
fClose(cArq)
nTotIt := nCont
If _lErroArq
	MsgStop("Arquivo com problema no cแlculo do Icms. Favor Analisar ...")
	TRB->(dbCloseArea())
	Return	
Endif
	
// Campo DE-PARA do Codigo de Produto Protheus x Codigo de Produto Despachante Aduaneiro
If SB1->(!FieldPos("B1_CODIMP")>0)
	msgStop("Campo B1_CODIMP nใo localizado... Contate o Administrador do Sistema!")
	TRB->(dbCloseArea())
	Return
EndIf

// Reserva as notas fiscais
//ReservNF() - Retirado por Alex - Adinfo - 11/09/2014

Begin Transaction
	
// Consiste Cadastro de Produtos
dbSelectArea("TRB")
TRB->(dbGoTop())

// Consiste Duplicata
If ChkSE2()
	TRB->(dbCloseArea())
	Return
EndIf

ProcRegua(TRB->(RecCount()))
Do While TRB->(!EOF())
	cCodPro := AllTrim(TRB->COD_PRO)
	IncProc("Consistindo produtos... " +cCodPro)
	
	dbSelectArea("SB1")
	dbSetOrder(1) // B1_FILIAL+B1_COD
	If dbSeek(xFilial("SB1")+cCodPro)
		cCodNew := SB1->B1_COD

		nTamanho  :=(TAMSX3("B1_COD")[1] - Len(cCodNew))
		cCodNew   := cCodNew + Space(nTamanho)

    	RecLock("TRB", .f.)
		TRB->COD_NEW := cCodNew
		TRB->(msUnLock())
	     
    Else
		If Select("WorkTt")>0
			WorkTt->(dbCloseArea())
		EndIf
			
		cQuery := " SELECT COUNT(1) TTPROD"
		cQuery += " FROM " +RetSqlName("SB1")
		cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
		cQuery += " AND B1_COD LIKE '%"+cCodPro+"' "
		cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
		tcQuery cQuery New Alias "WorkTt"
		
		If WorkTt->TTPROD > 1
			//msgInfo("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... O sistema tentarแ localizar pelo C๓digo do Produto fornecido pelo Despachante Aduaneiro!")
	
			If Select("WorkTt")>0
				WorkTt->(dbCloseArea())
			EndIf
				
			cQuery := " SELECT COUNT(1) TTPROD"
			cQuery += " FROM " +RetSqlName("SB1")
			cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
			cQuery += " AND B1_CODIMP = '"+cCodPro+"' "
			cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
			tcQuery cQuery New Alias "WorkTt"
	
			If WorkTt->TTPROD > 1
				msgStop("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
				TRB->(dbCloseArea())
				Return
			ElseIf WorkTt->TTPROD == 0
				cCodPro2 := Left(cCodPro,12)

				If Select("WorkTt")>0
					WorkTt->(dbCloseArea())
				EndIf
			
				cQuery := " SELECT COUNT(1) TTPROD"
				cQuery += " FROM " +RetSqlName("SB1")
				cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
				cQuery += " AND B1_COD LIKE '%"+cCodPro2+"%' "
				cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
				tcQuery cQuery New Alias "WorkTt"
				
				If WorkTt->TTPROD == 1
					If Select("Work")>0
						Work->(dbCloseArea())
					EndIf
				
					cQuery := " SELECT * "
					cQuery += " FROM " +RetSqlName("SB1")
					cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
					cQuery += " AND B1_COD LIKE '%"+cCodPro2+"%' "
					cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
					tcQuery cQuery New Alias "Work"
						
					cCodNew := Work->B1_COD

					nTamanho  :=(TAMSX3("B1_COD")[1] - Len(cCodNew))
					cCodNew   := cCodNew + Space(nTamanho)
						
					If msgYesNo("Foi encontrado o produto " +cCodNew+ " utilizando o c๓digo contido no arquivo: " +cCodPro+ " ... Realmente ้ este c๓digo?")
						RecLock("TRB", .f.)
						TRB->COD_NEW := cCodNew
						TRB->(msUnLock())
					Else 
						TRB->(dbCloseArea())
						Return		
					EndIf
				Else
					msgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
					TRB->(dbCloseArea())
					Return		
				EndIf
//				msgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
//				TRB->(dbCloseArea())
//				Return		
			Else
				If Select("Work")>0
					Work->(dbCloseArea())
				EndIf
				
				cQuery := " SELECT * "
				cQuery += " FROM " +RetSqlName("SB1")
				cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
				cQuery += " AND B1_CODIMP = '"+cCodPro+"' "
				cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
				tcQuery cQuery New Alias "Work"
					
				cCodNew := Work->B1_COD


				nTamanho  :=(TAMSX3("B1_COD")[1] - Len(cCodNew))
				cCodNew   := cCodNew + Space(nTamanho)
					
				RecLock("TRB", .f.)
				TRB->COD_NEW := cCodNew
				TRB->(msUnLock())
	        EndIf
	        
		ElseIf WorkTt->TTPROD == 0
			//msgInfo("Produto " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... O sistema tentarแ localizar pelo C๓digo do Produto fornecido pelo Despachante Aduaneiro!")
	
			If Select("WorkTt")>0
				WorkTt->(dbCloseArea())
			EndIf
				
			cQuery := " SELECT COUNT(1) TTPROD"
			cQuery += " FROM " +RetSqlName("SB1")
			cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
			cQuery += " AND B1_CODIMP = '"+cCodPro+"' "
			cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
			tcQuery cQuery New Alias "WorkTt"
	
			If WorkTt->TTPROD > 1
				msgStop("Foi encontrado mais de um produto IMPORTAวรO cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
				TRB->(dbCloseArea())
				Return
			ElseIf WorkTt->TTPROD == 0
				cCodPro2 := Left(cCodPro,12)

				If Select("WorkTt")>0
					WorkTt->(dbCloseArea())
				EndIf
			
				cQuery := " SELECT COUNT(1) TTPROD"
				cQuery += " FROM " +RetSqlName("SB1")
				cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
				cQuery += " AND B1_COD LIKE '%"+cCodPro2+"%' "
				cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
				tcQuery cQuery New Alias "WorkTt"
				
				If WorkTt->TTPROD == 1
					If Select("Work")>0
						Work->(dbCloseArea())
					EndIf
				
					cQuery := " SELECT * "
					cQuery += " FROM " +RetSqlName("SB1")
					cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
					cQuery += " AND B1_COD LIKE '%"+cCodPro2+"%' "
					cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
					tcQuery cQuery New Alias "Work"
						
					cCodNew := Work->B1_COD

					nTamanho  :=(TAMSX3("B2_COD")[1] - Len(cCodNew))
					cCodNew   := cCodNew + Space(nTamanho)
						
					If msgYesNo("Foi encontrado o produto " +cCodNew+ " utilizando o c๓digo contido no arquivo: " +cCodPro+ " ... Realmente ้ este c๓digo?")
						RecLock("TRB", .f.)
						TRB->COD_NEW := cCodNew
						TRB->(msUnLock())
					Else 
						TRB->(dbCloseArea())
						Return		
					EndIf
				Else
					msgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
					TRB->(dbCloseArea())
					Return		
				EndIf
//				msgStop("Produto IMPORTAวรO " + cCodPro + ", encontrado na Adi็ใo " + TRB->ADICAO + " ,nใo cadastrado no Protheus... Checar, corrigir e iniciar novamente o processo!")
//				TRB->(dbCloseArea())
//				Return		
			Else
				If Select("Work")>0
					Work->(dbCloseArea())
				EndIf
				
				cQuery := " SELECT * "
				cQuery += " FROM " +RetSqlName("SB1")
				cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
				cQuery += " AND B1_CODIMP = '"+cCodPro+"' "
				cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
				tcQuery cQuery New Alias "Work"
					
				cCodNew := Work->B1_COD
					
				nTamanho  :=(TAMSX3("B1_COD")[1] - Len(cCodNew))
				cCodNew   := cCodNew + Space(nTamanho)

				RecLock("TRB", .f.)
				TRB->COD_NEW := cCodNew
				TRB->(msUnLock())		
			EndIf			
		
		Else
			If Select("Work")>0
				Work->(dbCloseArea())
			EndIf
			
			cQuery := " SELECT * "
			cQuery += " FROM " +RetSqlName("SB1")
			cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
			cQuery += " AND B1_COD LIKE '%"+cCodPro+"' "
			cQuery += " AND D_E_L_E_T_=' ' AND B1_MSBLQL <> '1' "
			tcQuery cQuery New Alias "Work"
				
			cCodNew := Work->B1_COD

			nTamanho  :=(TAMSX3("B1_COD")[1] - Len(cCodNew))
			cCodNew   := cCodNew + Space(nTamanho)
				
			RecLock("TRB", .f.)
			TRB->COD_NEW := cCodNew
			TRB->(msUnLock())
		EndIf
	EndIf
		
	/* Os campos abaixo nใo devem ser alterado via programa
	dbSelectArea("SB1")
	dbSetOrder(1) // B1_FILIAL+B1_COD
	If dbSeek(xFilial("SB1")+cCodNew)
		RecLock("SB1",.f.)
		SB1->B1_POSIPI  := TRB->NCM
		SB1->B1_PPIS    := TRB->ALQ_PIS
		SB1->B1_PPISE   := TRB->ALQ_PIS
		SB1->B1_PCOFINS := TRB->ALQ_COF
		SB1->B1_PCOFE   := TRB->ALQ_COF
		SB1->B1_IMPIMPO := TRB->ALQ_II
		SB1->B1_PICM    := TRB->ALQ_ICM
		SB1->B1_IPI     := TRB->ALQ_IPI
		SB1->(msUnLock())
	EndIf
	*/
	TRB->(dbSkip())
EndDo
	
//Inclui Documento Entrada, Livro e Duplicata
TRB->(dbGoTop())
ProcRegua(TRB->(RecCount()))
	
nTtInvo := 0
cDoc := cMvDoc
Do While TRB->(!EOF())
	Eval(bZeraTt)
	nItem   := 1
	cAdicao := TRB->ADICAO
	Do While TRB->(!EOF()) .and. cAdicao == TRB->ADICAO
		IncProc("Processando NF Importa็ใo... " +TRB->ADICAO)
		
		//Somente grava registros que tenha o n๚mero da DI preenchido
		If Empty(TRB->DI)
			DbSelectArea("TRB")
			TRB->(dbSkip())
			loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1) //B1_FILIAL+B1_COD
		if .not. dbSeek(xFilial("SB1")+ALLTRIM(TRB->COD_NEW))
		    msgStop("O produto  -" + alltrim(TRB->COD_NEW) + "- nใo encontrado, corrigir e iniciar novamente o processo!")
			TRB->(dbCloseArea())
			Return 
		Endif                        
		
		If SM0->M0_CODIGO == "01"
		   ccSERIE   := "001"
	    Endif 
	    If SM0->M0_CODIGO == "02"
		   ccSERIE   := "1  "
	    Endif		
		
		dbSelectArea("SF1")
		dbSetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		If dbSeek(xFilial("SF1")+cDoc+ccSERIE+cMvFor+cMvLj+"N")
			msgStop("Nota Fiscal " + cDoc + " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
			TRB->(dbCloseArea())
			Return
		EndIf
		
		GrvSD1(@cDoc, @nItem, nTotIt)
		GRVSD7(@CDOC, @NITEM)
		GRVSB2(@CDOC, @NITEM)
		
		/* Retirado por Alex - Adinfo - 09/09/2014
		If nItem > 11
			If GrvSF1(@cDoc)
				TRB->(dbCloseArea())
				Return
			EndIf

			If GrvSF3(@cDoc)
				TRB->(dbCloseArea())
				Return
			EndIf

			cDoc  := Soma1(cDoc,6)
			lSF1  := .f.
			lAdic := .t.
			nItem := 0
		EndIf
		*/
		
		nItem++
		TRB->(dbSkip())
	EndDo
	
	If lSF1 
		If GrvSF1(@cDoc)
			TRB->(dbCloseArea())
			Return
		EndIf
		
		If GrvSF3(@cDoc)
			TRB->(dbCloseArea())
			Return
		EndIf
	EndIf
	
	If lAdic
		If GrvSF1(@cDoc)
			TRB->(dbCloseArea())
			Return
		EndIf
		
		If GrvSF3(@cDoc)
			TRB->(dbCloseArea())
			Return
		EndIf
	EndIf

	cDoc := Soma1(cDoc,6)
	nItem := 1 //Incluํdo por Alex - Adinfo - 09/09/2014
	
EndDo

If GrvSE2()
	TRB->(dbCloseArea())
	Return
EndIf
	
End Transaction
	
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
	
aAdd(aRegs,{cPerg,"01","Reserva da NF  ?","","","mv_ch1","C", 06,0,0,"G",          "","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Exportador     ?","","","mv_ch2","C", 06,0,0,"G",          "","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"03","Loja           ?","","","mv_ch3","C", 02,0,0,"G",          "","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data DI        ?","","","mv_ch4","D", 08,0,0,"G",          "","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Local Desemb.  ?","","","mv_ch5","C", 60,0,0,"G",          "","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Uf.Desembara็o ?","","","mv_ch6","C", 02,0,0,"G",          "","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Data Desemb.   ?","","","mv_ch7","D", 08,0,0,"G",          "","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Cod.Exportador ?","","","mv_ch8","C", 60,0,0,"G",          "","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Fabricante     ?","","","mv_ch9","C", 60,0,0,"G",          "","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Email Despach  ?","","","mv_cha","C", 60,0,0,"G",          "","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Taxa Moeda Imp.?","","","mv_chb","N", 11,4,0,"G",          "","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"12","Via Transporte ?","","","mv_chc","C", 01,0,0,"G",          "","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"13","Vlr.Maria Merc.?","","","mv_chd","N", 14,2,0,"G",          "","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})



For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
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

cMvDoc := mv_par01
cMvFor := mv_par02
cMvLj  := mv_par03

If Empty(cMvDoc) .or.;
	!Left(AllTrim(cMvDoc),1)$"0123456789"
	Aviso("Aten็ใo!", "Numera็ใo das NF incorretas... Checar!",{"Ok"})
	lReserv := .f.
	Return
EndIf

dbSelectArea("SA2")
dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
If !dbSeek(xFilial("SA2")+cMvFor+cMvLj)
	Aviso("Aten็ใo!", "Fornecedor nใo cadastrado... Checar!", {"Ok"})
	lReserv := .f.
	Return
EndIf

dbSelectArea("SF1")
dbSetOrder(1) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

If dbSeek(xFilial("SF1")+cMvDoc+"1  "+cMvFor+cMvLj)
	Aviso("Aten็ใo!", "Nota Fiscal " + cMvDoc + " jแ cadastrada... Checar!", {"Ok"})
	lReserv := .f.
	Return
EndIf

RestArea(aAreaAtu)

Return lReserv
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSF1    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvSF1(cDoc)

Local lRet, aAreaTRB, aAreaSF1

lRet := .f.
aAreaSF1 := SF1->(GetArea())
aAreaTRB := TRB->(GetArea())

TRB->(dbGoTop())

SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
If SF1->(dbSeek(xFilial("SF1")+cDoc+"1  "+cMvFor+cMvLj+"N"))
	msgStop("Nota Fiscal " +cDoc+ " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
	lRet := .t.
Else                
	_cNumNotas += cDoc+"/"	
	RecLock("SF1", .t.)
	SF1->F1_FILIAL  := xFilial("SF1")
	SF1->F1_DOC     := cDoc
	If SM0->M0_CODIGO == "01"
	   SF1->F1_SERIE   := "001"
    Endif 
    If SM0->M0_CODIGO == "02"
	   SF1->F1_SERIE   := "1  "
    Endif
	SF1->F1_FORNECE := cMvFor
	SF1->F1_LOJA    := cMvLj
	SF1->F1_EMISSAO := ddatabase //TRB->DT_DI
	SF1->F1_EST     := "EX"
	SF1->F1_DESPESA := nDesp
	SF1->F1_BASEICM := nBaseICM
	SF1->F1_VALICM  := nValICM
	SF1->F1_BASEIPI := nBaseIPI
	SF1->F1_VALIPI  := nValIPI
	SF1->F1_BASIMP5 := nBaseCof
	SF1->F1_VALIMP5 := nValCof
	SF1->F1_BASIMP6 := nBasePis
	SF1->F1_VALIMP6 := nValPis
	SF1->F1_CIF     := nBasCIF
	SF1->F1_II      := nValII
	SF1->F1_VALMERC := nBaseICM-(nValIPI+nDesp)
	SF1->F1_VALBRUT := nBaseICM
	SF1->F1_TIPO    := "N"
	SF1->F1_DTDIGIT := dDataBase
	SF1->F1_FORMUL  := "S"
	SF1->F1_ESPECIE := "SPED"
	SF1->F1_MOEDA   := TRB->MOEDA
	SF1->F1_STATUS  := "A"
	SF1->F1_RECBMTO := dDataBase
	SF1->F1_XMENS1  := "DI " + TRB->DI + " DE " + DtoC(TRB->DT_DI) + chr(32) + TRB->INVOICE
   
   // Campos inclusos para adequacao da NFE 2.0 - Incluido por Kelly Bondesan 09/04/2011
    SF1->F1_XNDI     := strtran(strtran(TRB->DI,"/",""),"-","") //LimpaVar(TRB->DI)
    SF1->F1_XDTDI    := MV_PAR04
    SF1->F1_XLOCDES  := MV_PAR05
	SF1->F1_XUFDES   := MV_PAR06
    SF1->F1_XDTDES   := MV_PAR07   
	SF1->F1_XCODEXP  := MV_PAR08
	SF1->F1_XEMAILD  := MV_PAR10
	
	SF1->F1_HORA := TIME()     
	
	//Incluํdos por Alex - 04/05/2015
	SF1->F1_TRANSP  := MV_PAR14 //Transportadora
	
	If lPriNF 
		SF1->F1_VOLUME1 := MV_PAR15 //Quantidade Volume
		SF1->F1_ESPECI1 := MV_PAR16 //Especie Volume
		SF1->F1_PLIQUI  := MV_PAR17 //Peso Liquido
		SF1->F1_PBRUTO  := MV_PAR18 //Peso Bruto
		lPriNF := .F.
	Endif
	
	SF1->(msUnLock())                                
	
	//Incluido por Alex - 13/08/2014
	//Grava as informa็๕es complementares de importa็ใo para suporte ao registro C120 do Sped Fiscal  
/*	RecLock("CD5",.T.)
		CD5_FILIAL := xFilial("CD5")
		CD5_DOC    := cDoc
		If SM0->M0_CODIGO == "01"
			CD5_SERIE  := "001"
		Elseif SM0->M0_CODIGO == "02"
			CD5_SERIE  := "1  "		
		Endif
		CD5_ESPEC  := "N"
		CD5_FORNEC := cMvFor
		CD5_LOJA   := cMvLj
		CD5_TPIMP  := "0"
		CD5_DOCIMP := strtran(strtran(TRB->DI,"/",""),"-","") //LimpaVar(TRB->DI)
		CD5_BSPIS  := nBasePis
		CD5_ALPIS  := 1.65
		CD5_VLPIS  := nValPis
		CD5_BSCOF  := nBaseCof
		CD5_ALCOF  := 8.60
		CD5_VLCOF  := nValCof
		CD5_ACDRAW := "0"
		CD5_DTDI   := MV_PAR04
		CD5_LOCDES := MV_PAR05
		CD5_UFDES  := MV_PAR06
		CD5_DTDES  := MV_PAR07
		CD5_CODEXP := MV_PAR08
		CD5_DSPAD  := nDesp
		CD5_VLRII  := nValII
		CD5_NDI    := strtran(strtran(TRB->DI,"/",""),"-","") //LimpaVar(TRB->DI)
		CD5_VTRANS := ALLTRIM(STR(MV_PAR12))
		CD5_VAFRMM := MV_PAR13
		CD5_INTERM := "1" //Importa็ใo por conta pr๓pria
  */	MsUnLock()		
EndIf
	
RestArea(aAreaSF1)
RestArea(aAreaTRB)
	
Return lRet
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSF3    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function GrvSF3(cDoc)

Local lRet, aAreaTRB, aAreaSF3 

lRet := .f.
aAreaSF3:= SF3->(GetArea())
aAreaTRB:= TRB->(GetArea())
	
TRB->(dbGoTop())
	
SF3->(dbSetOrder(1)) //F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
If SF3->(dbSeek(xFilial("SF3")+DtoS(dDataBase)+cDoc+"1  "+cMvFor+cMvLj+"3102"))
	msgStop("Livro Fiscal " +cDoc+ " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
	lRet := .t.
Else
	RecLock("SF3", .t.)
	SF3->F3_FILIAL  := xFilial("SF3")
	SF3->F3_REPROC  := "N" //Alterado de S para N por Alex Rodrigues - Adinfo - 11/09/2014
	SF3->F3_ENTRADA := dDataBase
	SF3->F3_NFISCAL := cDoc
	If SM0->M0_CODIGO == "01"
	   SF3->F3_SERIE   := "001"
    Endif 
    If SM0->M0_CODIGO == "02"
	   SF3->F3_SERIE   := "1  "
    Endif
	SF3->F3_CLIEFOR := cMvFor
	SF3->F3_LOJA    := cMvLj
	SF3->F3_CFO     := "3102"
	SF3->F3_ESTADO  := "EX"
	SF3->F3_EMISSAO := ddatabase //TRB->DT_DI
	SF3->F3_ALIQICM := TRB->ALQ_ICM
	SF3->F3_VALCONT := nValTt+nValICM+nValIPI+nValPis+nValCof+nDesp //+nValII
	SF3->F3_BASEICM := nBaseICM //+nValICM
	SF3->F3_VALICM  := nValICM
	SF3->F3_ISENICM := 0
	SF3->F3_BASEIPI := nBaseIPI
	SF3->F3_VALIPI  := nValIPI
	SF3->F3_ISENIPI := 0
	SF3->F3_OUTRIPI := SF3->(F3_VALCONT-(F3_BASEIPI+F3_VALIPI))
	SF3->F3_OBSERV  := "NT. FISCAL DE ENTRADA"
	SF3->F3_VALOBSE := 0
	SF3->F3_ICMSRET := 0
	SF3->F3_ICMSCOM := 0
	SF3->F3_IPIOBS  := Iif(SF3->(Round(F3_VALCONT,1)==Round(F3_BASEICM,1)),SF3->F3_VALIPI,0)
	SF3->F3_OUTRICM := Iif(SF3->F3_VALCONT > SF3->(F3_BASEICM+F3_VALIPI),Abs(SF3->F3_VALCONT-(SF3->(F3_BASEICM+F3_VALIPI))),0)
	SF3->F3_ICMAUTO := 0
	SF3->F3_BASERET := 0
	SF3->F3_FORMUL  := "S"
	SF3->F3_ESPECIE := "SPED"
	SF3->F3_DESPESA := nDesp
	SF3->F3_BASIMP1 := 0
	SF3->F3_BASIMP2 := 0
	SF3->F3_BASIMP3 := 0
	SF3->F3_BASIMP4 := 0
	SF3->F3_BASIMP5 := nBaseCof
	SF3->F3_BASIMP6 := nBasePis
	SF3->F3_ALQIMP1 := 0
	SF3->F3_ALQIMP2 := 0
	SF3->F3_ALQIMP3 := 0
	SF3->F3_ALQIMP4 := 0
	SF3->F3_ALQIMP5 := 0
	SF3->F3_ALQIMP6 := 0
	SF3->F3_VALIMP1 := 0
	SF3->F3_VALIMP2 := 0
	SF3->F3_VALIMP3 := 0
	SF3->F3_VALIMP4 := 0
	SF3->F3_VALIMP5 := nValCof
	SF3->F3_VALIMP6 := nValPis
	SF3->F3_RETIMP1 := 0
	SF3->F3_RETIMP2 := 0
	SF3->F3_RETIMP3 := 0
	SF3->F3_RETIMP4 := 0
	SF3->F3_RETIMP5 := 0
	SF3->F3_RETIMP6 := 0
	SF3->F3_DTLANC  := dDataBase
	SF3->F3_ICMSDIF := 0
	SF3->F3_TRFICM  := 0
	SF3->F3_OBSICM  := 0
	SF3->F3_OBSSOL  := 0
	SF3->F3_SOLTRIB := 0
	SF3->(msUnLock())
	
	Eval(bZeraTt)
EndIf
		
RestArea(aAreaSF3)
RestArea(aAreaTRB)
	
Return lRet
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSE2    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function GrvSE2()

Local lRet, cDI, aAreaTRB, aAreaSE2

lRet     := .f.
aAreaSE2 := SE2->(GetArea())
aAreaTRB := TRB->(GetArea())

TRB->(dbGoTop())
cDI := Subs(AllTrim(TRB->DI),4,6)

SE2->(dbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
If SE2->(dbSeek(xFilial("SE2")+"DI "+cDI+" "+"BOL"+cMvFor+cMvLj))
	msgStop("Duplicata " + cDI + " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
	lRet := .t.
Else
	RecLock("SE2", .t.)
	SE2->E2_FILIAL  := xFilial("SE2")
	SE2->E2_PREFIXO := "DI "
	SE2->E2_NUM     := 	cDI
	SE2->E2_PARCELA := " "
	SE2->E2_TIPO    := "BOL"
	SE2->E2_NATUREZ := "2002"
	SE2->E2_FORNECE := cMvFor
	SE2->E2_LOJA    := cMvLj
	SE2->E2_NOMFOR  := Posicione("SA2",1,xFilial("SA2")+cMvFor+cMvLj,"A2_NOME")
	SE2->E2_EMISSAO := ddatabase //TRB->DT_DI
	SE2->E2_VENCTO  := TRB->(DT_DI+CONDPGT)
	SE2->E2_VENCREA := DataValida(SE2->E2_VENCTO)
	SE2->E2_VALOR   := nTtInvo
	SE2->E2_ISS     := 0
	SE2->E2_IRRF    := 0
	SE2->E2_EMIS1   := dDataBase
	SE2->E2_HIST    := "DI "+TRB->DI+" "+DtoC(TRB->DT_DI)
	SE2->E2_SALDO   := SE2->E2_VALOR
	SE2->E2_DESCONT := 0
	SE2->E2_MULTA   := 0
	SE2->E2_JUROS   := 0
	SE2->E2_CORREC  := 0
	SE2->E2_VALLIQ  := 0
	SE2->E2_VENCORI := SE2->E2_VENCREA
	SE2->E2_VALJUR  := 0
	SE2->E2_PORCJUR := 0
	SE2->E2_MOEDA   := TRB->MOEDA
	SE2->E2_RATEIO  := "N"
	SE2->E2_VARURV  := 0
	SE2->E2_VLCRUZ  := SE2->E2_VALOR
	SE2->E2_ACRESC  := 0
	SE2->E2_OCORREN := "01"
	SE2->E2_ORIGEM  := ""
//	SE2->E2_ORIGEM  := "NFEIMP"
	SE2->E2_FLUXO   := "S"
	SE2->E2_DESDOBR := "N"
	SE2->E2_INSS    := 0
	SE2->E2_TXMOEDA := 0
	SE2->E2_SDACRES := 0                                	
	SE2->E2_DECRESC := 0
	SE2->E2_SDDECRE := 0
	SE2->E2_MULTNAT := "2"
	SE2->E2_PROJPMS := "2"
	SE2->E2_DIRF    := "2"
	SE2->E2_MODSPB  := "1"
	SE2->E2_RETENC  := 0
	SE2->E2_SEST    := 0
	SE2->E2_FILORIG := xFilial("SE2")
	SE2->E2_COFINS  := 0
	SE2->E2_PIS     := 0
	SE2->E2_CSLL    := 0
	SE2->E2_VRETPIS := 0
	SE2->E2_VRETCOF := 0
	SE2->E2_VRETISS := 0
	SE2->E2_VRETCSL := 0
	SE2->E2_VARIAC  := 0
	SE2->E2_BASEPIS := 0
	SE2->E2_BASECSL := 0
	SE2->E2_BASECOF := 0
	SE2->E2_XTRIBUT := 0
	SE2->E2_XOPER   := "60"
	SE2->(msUnLock())

//	msgInfo("Nota Fiscal de Importa็ใo concluํda com ๊xito!")  - retirado por Alex - Adinfo - 11/09/2014
	TRB->(dbCloseArea())
EndIf
	
RestArea(aAreaSE2)   
RestArea(aAreaTRB)   
	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSD1    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvSD1(cDoc, nItem, nTotIt)

If !Empty(TRB->DI)
	RecLock("SD1", .t.)
	SD1->D1_FILIAL  := xFilial("SD1")
	SD1->D1_ITEM    := StrZero(nItem,4)
	SD1->D1_COD     := TRB->COD_NEW
	SD1->D1_DESCPRO := SB1->B1_DESC
	SD1->D1_UM      := SB1->B1_UM
	SD1->D1_QUANT   := TRB->QTD
	SD1->D1_VUNIT   := TRB->UNIT +  round((TRB->VLR_II/TRB->QTD),4)// (Int((TRB->VLR_II/TRB->QTD)*10000)/10000)   //round((TRB->VLR_TOT + TRB->VLR_II) /TRB->QTD,4)//
	SD1->D1_TOTAL   := SD1->D1_VUNIT * TRB->QTD //TRB->VLR_TOT + TRB->VLR_II // (TRB->UNIT+(TRB->VLR_II/TRB->QTD)) * TRB->QTD //
	SD1->D1_VALIPI  := TRB->VLR_IPI
	//SD1->D1_VALICM  := (TRB->VLR_TOT /100) *TRB->ALQ_ICM
	SD1->D1_VALICM  := TRB->VLR_ICM
//-->	TRB->ALQ_COF = campo que tem a alํquoto do arquivo txt

//	Incluido por Alex Rodrigues - 11/08/2014
//	_nAliqPad := SuperGetMV("MV_TXCOFIN")
//Alterado por Alex Rodrigues - 05/05/2015
	_nAliqPad := 9.65

//	If SM0->M0_CODIGO == "01" //VERION
		IF TRB->ALQ_IPI > 0
			If TRB->ALQ_COF > _nAliqPad
				SD1->D1_TES     := "350" //"254" // com ipi, COM majora็ใo
			Else
				SD1->D1_TES     := "352" //"261" // com ipi, SEM majora็ใo
			Endif
		Else
			If TRB->ALQ_COF > _nAliqPad
				SD1->D1_TES     := "351" //"259" // sem ipi, COM majora็ใo ->  mudar 259
			Else
				SD1->D1_TES     := "353" //"262" // sem ipi, SEM majora็ใo
			Endif
		Endif
//	Else //AEM - Os Tes da AEM nใo tem majora็ใo
//		IF TRB->ALQ_IPI > 0
//			SD1->D1_TES     := "254" // com ipi
//		Else
//			SD1->D1_TES     := "259" // sem ipi
//		Endif	
//	Endif
	
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+SD1->D1_TES)	
	
	SD1->D1_CF      := "3102"
	SD1->D1_DESC    := 0
	SD1->D1_IPI     := TRB->ALQ_IPI
	SD1->D1_PICM    := TRB->ALQ_ICM
	SD1->D1_PESO    := 0
	SD1->D1_PEDIDO  := ""
	SD1->D1_FORNECE := cMvFor
	SD1->D1_LOJA    := cMvLj
	SD1->D1_ITEMPC  := ""
	SD1->D1_DOC     := cDoc
	SD1->D1_EMISSAO := ddatabase  // TRB->DT_DI
	SD1->D1_DTDIGIT := dDataBase
	SD1->D1_LOCAL   := "98"  //SB1->B1_LOCPAD
	SD1->D1_GRUPO   := SB1->B1_GRUPO
	If SM0->M0_CODIGO == "01"
	   SD1->D1_SERIE   := "001"
    Endif 
    If SM0->M0_CODIGO == "02"
	   SD1->D1_SERIE   := "1  "
    Endif
	SD1->D1_TIPO    := "N"
	SD1->D1_TP      := SB1->B1_TIPO
	SD1->D1_NUMSEQ  := ""
	SD1->D1_ICMSRET := 0
	SD1->D1_BRICMS  := 0
	SD1->D1_BASEICM := TRB->BAS_ICM
	SD1->D1_VALDESC := 0
	IF TRB->ALQ_IPI > 0
		SD1->D1_BASEIPI := TRB->BAS_IPI
	else
		SD1->D1_BASEIPI := 0 //  TRB->BAS_IPI
	endif
	SD1->D1_FORMUL  := "S"        
	SD1->D1_CIF     := TRB->BAS_II
	SD1->D1_II      := (round((TRB->VLR_II/TRB->QTD),4))*TRB->QTD //TRB->VLR_II
	SD1->D1_CLASFIS := SB1->B1_ORIGEM+SF4->F4_SITTRIB  //Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_SITTRIB") //"254"
	SD1->D1_CUSTO   := SD1->D1_VUNIT * TRB->QTD //TRB->UNIT +  round((TRB->VLR_II/TRB->QTD),4 //0
	SD1->D1_BASIMP5 := TRB->BAS_COF
	SD1->D1_BASIMP6 := TRB->BAS_PIS
	SD1->D1_VALIMP5 := TRB->VLR_COF
	SD1->D1_VALIMP6 := TRB->VLR_PIS
	SD1->D1_ALQIMP5 := TRB->ALQ_COF
	SD1->D1_ALQIMP6 := TRB->ALQ_PIS
	SD1->D1_RATEIO  := "2"
	SD1->D1_DESPESA := TRB->DESP
	SD1->D1_STSERV  := "1"
	SD1->D1_ORIGEM  := "NFEIMP"
	SD1->D1_DI      := strtran(strtran(TRB->DI,"/",""),"-","")
	SD1->D1_ADIC    := Right(TRB->ADICAO,3)    
	SD1->D1_ALIQII  := TRB->ALQ_II
	SD1->D1_XOPER   := "60"
	SD1->D1_XFABRIC := MV_PAR09 
	SD1->D1_DIIT    :=StrZero(TRB->NCONT,3)
	SD1->D1_CONTA   := SB1->B1_CONTA //Incluํdo por Alex Rodrigues - 05/07/2018
	SD1->(msUnLock())
	
	DbSelectArea("SA5")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)
		RecLock("SA5",.T.)          
			SA5->A5_FILIAL 	:= xFilial("SA5")
			SA5->A5_FORNECE := SD1->D1_FORNECE
			SA5->A5_LOJA	:= SD1->D1_LOJA
			SA5->A5_NOMEFOR := Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NOME")
			SA5->A5_PRODUTO	:= SD1->D1_COD
			SA5->A5_NOMPROD	:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")
			SA5->A5_SKIPLOT	:= 1
			SA5->A5_NOTA	:= 9
		MsUnLock()
	Endif
	
	//Grava as informa็๕es complementares de importa็ใo para suporte ao registro C120 do Sped Fiscal  
	RecLock("CD5",.T.)
		CD5_FILIAL := xFilial("CD5")
		CD5_DOC    := cDoc
		If SM0->M0_CODIGO == "01"
			CD5_SERIE  := "001"
		Elseif SM0->M0_CODIGO == "02"
			CD5_SERIE  := "1  "		
		Endif     
		CD5_ITEM   := StrZero(nItem,4)
		CD5_ESPEC  := "N"
		CD5_FORNEC := cMvFor
		CD5_LOJA   := cMvLj
		CD5_TPIMP  := "0"
		CD5_DOCIMP := strtran(strtran(TRB->DI,"/",""),"-","") //LimpaVar(TRB->DI)
		CD5_BSPIS  := TRB->BAS_PIS //nBasePis
		CD5_ALPIS  := TRB->ALQ_PIS //1.65
		CD5_VLPIS  := TRB->VLR_PIS //nValPis
		CD5_BSCOF  := TRB->BAS_COF //nBaseCof
		CD5_ALCOF  := TRB->ALQ_COF //8.60
		CD5_VLCOF  := TRB->VLR_COF //nValCof
		CD5_ACDRAW := "0"
		CD5_LOCAL  := "0"
		CD5_CODEXP := "000093"
		CD5_LOJEXP := "01" 
		CD5_CODFAB := "000093" 
		CD5_LOJFAB := "01" 
		CD5_NADIC  := StrZero(nItem,3)
		CD5_SQADIC := StrZero(nTotIt,3)
		CD5_SDOC   := "001"
		CD5_DTDI   := MV_PAR04
		CD5_LOCDES := MV_PAR05
		CD5_UFDES  := MV_PAR06
		CD5_DTDES  := MV_PAR07
		CD5_CODEXP := MV_PAR08
		CD5_DSPAD  := TRB->DESP //nDesp
		CD5_VLRII  := (round((TRB->VLR_II/TRB->QTD),4))*TRB->QTD
		CD5_NDI    := strtran(strtran(TRB->DI,"/",""),"-","") //LimpaVar(TRB->DI)
		CD5_VTRANS := ALLTRIM(STR(MV_PAR12))
		CD5_VAFRMM := MV_PAR13
		CD5_INTERM := "1" //Importa็ใo por conta pr๓pria
	MsUnLock()
	
	
	//Grava็ใo da SFT
	//Alex Rodrigues - Adinfo Consultoria
	//Data: 19/08/2014
	RecLock("SFT",.T.)
		SFT->FT_FILIAL  := xFilial("SFT")
		SFT->FT_ENTRADA := dDataBase
		SFT->FT_EMISSAO := dDataBase
		SFT->FT_NFISCAL := cDoc
		If SM0->M0_CODIGO == "01"
		   SFT->FT_SERIE   := "001"
	    Endif 
	    If SM0->M0_CODIGO == "02"
		   SFT->FT_SERIE   := "1  "
	    Endif
		SFT->FT_CLIEFOR := cMvFor
		SFT->FT_LOJA    := cMvLj
		SFT->FT_ESTADO  := "EX"
		SFT->FT_CFOP    := "3102"
		SFT->FT_ALIQICM := TRB->ALQ_ICM
		SFT->FT_VALCONT := (SD1->D1_VUNIT * TRB->QTD)+TRB->VLR_ICM+TRB->VLR_IPI+TRB->VLR_PIS+TRB->VLR_COF+TRB->DESP   //Vlr. dos Produtos + Icms + IPI + PIS + COFINS + DESPESAS
		SFT->FT_BASEICM := TRB->BAS_ICM
		SFT->FT_VALICM  := TRB->VLR_ICM
		SFT->FT_ISENICM := 0
		SFT->FT_OUTRICM := 0
		If TRB->ALQ_IPI > 0
			SFT->FT_BASEIPI := TRB->BAS_IPI
		Endif
		SFT->FT_ALIQIPI := TRB->ALQ_IPI
		SFT->FT_VALIPI  := TRB->VLR_IPI
		SFT->FT_ISENIPI := 0
		IF TRB->VLR_IPI == 0
			SFT->FT_OUTRIPI := (SD1->D1_VUNIT * TRB->QTD)+TRB->DESP+TRB->VLR_ICM   //total+despesa+icms
			SFT->FT_DESPIPI := "S"
		ENDIF
		SFT->FT_ESPECIE := "SPED"
		SFT->FT_PRODUTO := TRB->COD_NEW
		SFT->FT_TIPOMOV := "E"
		SFT->FT_ITEM    := StrZero(nItem,4)
		SFT->FT_FORMUL  := "S"
		SFT->FT_CLASFIS := SB1->B1_ORIGEM+SF4->F4_SITTRIB    //Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_SITTRIB")
		SFT->FT_CTIPI   := SF4->F4_CTIPI
		SFT->FT_DESPESA := TRB->DESP
		SFT->FT_POSIPI  := SB1->B1_POSIPI
		SFT->FT_IDENTF3 := "000001"
		SFT->FT_ESTOQUE := "S"
		SFT->FT_QUANT   := TRB->QTD
		SFT->FT_PRCUNIT := TRB->UNIT +  round((TRB->VLR_II/TRB->QTD),4)
		SFT->FT_TOTAL   := SD1->D1_VUNIT * TRB->QTD
		SFT->FT_BASEPIS := TRB->BAS_PIS
		SFT->FT_ALIQPIS := TRB->ALQ_PIS
		SFT->FT_VALPIS  := TRB->VLR_PIS
		SFT->FT_BASECOF := TRB->BAS_COF
		SFT->FT_ALIQCOF := TRB->ALQ_COF
		SFT->FT_VALCOF  := TRB->VLR_COF
		SFT->FT_RECISS  := "2"
		SFT->FT_CSTPIS  := SF4->F4_CSTPIS
		SFT->FT_CSTCOF  := SF4->F4_CSTCOF
		SFT->FT_CODBCC  := "01"
		SFT->FT_INDNTFR := "2"
		SFT->FT_AGREG   := "I"
		SFT->FT_MALQCOF := SF4->F4_MALQCOF
		SFT->FT_MVALCOF := TRB->BAS_COF*SF4->F4_MALQCOF/100
	MsUnlock()
	
	//Grava็ใo da CD2 com os impostos (ICMS,IPI, PIS e COFINS)
	//Alex Rodrigues - Adinfo Consultoria
	//Data: 29/08/2014                                        
	
	aImpostos := {"ICM","IPI","PS2","CF2"}
	For X:=1 to 4
		RecLock("CD2",.T.)
			CD2->CD2_FILIAL := xFilial("CD2")
			CD2->CD2_TPMOV  := "E"
			CD2->CD2_DOC    := cDoc
			If SM0->M0_CODIGO == "01"
			   CD2->CD2_SERIE   := "001"
		    Endif 
		    If SM0->M0_CODIGO == "02"
			   CD2->CD2_SERIE   := "1  "
		    Endif			
			CD2->CD2_CODFOR := cMvFor
			CD2->CD2_LOJFOR := cMvLj
			CD2->CD2_ITEM   := StrZero(nItem,4)
			CD2->CD2_CODPRO := TRB->COD_NEW
			CD2->CD2_IMP    := aImpostos[X]
			CD2->CD2_ORIGEM := "1"
			CD2->CD2_MODBC  := Iif(aImpostos[X]=="ICM","3","")
			CD2->CD2_QTRIB  := Iif(aImpostos[X]=="ICM",0,TRB->QTD)
			CD2->CD2_FORMU  := "S"				

			If aImpostos[X] == "ICM"
				CD2->CD2_CST    := SF4->F4_SITTRIB  //00
				CD2->CD2_PREDBC := SF4->F4_BASEICM				
				CD2->CD2_BC     := TRB->BAS_ICM
				CD2->CD2_ALIQ   := TRB->ALQ_ICM
				CD2->CD2_VLTRIB := TRB->VLR_ICM
			ElseIf aImpostos[X] == "IPI"
				CD2->CD2_CST    := SF4->F4_CTIPI    //00				
				CD2->CD2_BC     := TRB->BAS_IPI
				CD2->CD2_ALIQ   := TRB->ALQ_IPI
				CD2->CD2_VLTRIB := TRB->VLR_IPI
			ElseIf aImpostos[X] == "PS2"			
				CD2->CD2_CST    := SF4->F4_CSTPIS   //54		
				CD2->CD2_BC     := TRB->BAS_PIS
				CD2->CD2_ALIQ   := TRB->ALQ_PIS
				CD2->CD2_VLTRIB := TRB->VLR_PIS
			ElseIf aImpostos[X] == "CF2"
				CD2->CD2_CST    := SF4->F4_CSTCOF   //54
				CD2->CD2_BC     := TRB->BAS_COF
				CD2->CD2_ALIQ   := TRB->ALQ_COF
				CD2->CD2_VLTRIB := TRB->VLR_COF
			Endif

		MsUnlock()	
	Next	
	
	nDesp    += TRB->DESP
	nBaseICM += TRB->BAS_ICM
	nValICM  += TRB->VLR_ICM
	nBaseIPI += TRB->BAS_IPI
	nValIPI  += TRB->VLR_IPI
	nBasePIS += TRB->BAS_PIS
	nValPIS  += TRB->VLR_PIS
	nBaseCOF += TRB->BAS_COF
	nValCOF  += TRB->VLR_COF
	nBasCIF  += TRB->BAS_II
	nValII   += TRB->VLR_II
	nValTt   += TRB->VLR_TOT + TRB->VLR_II //(TRB->UNIT+(TRB->VLR_II/TRB->QTD)) * TRB->QTD //TRB->VLR_TOT
	
	nTtInvo += TRB->TT_INVO
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSD7    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
// INCLUSAO DE DADOS NO CONTROLE DE QUALIDADE - ALMOX 98
// CAVALINI - 24/09/2016
Static Function GrvSD7(cDoc, nItem)
                                   
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
	 SD7->D7_LOCDEST := "01" //"98"
	 SD7->D7_NUMERO  := "I"+_CNRLOT
	 SD7->D7_DATA    := dDataBase
	 SD7->D7_ORIGLAN := "CP"
	 SD7->D7_TIPOCQ  := "M"
	 SD7->D7_DOC     := CDOC

 	 If SM0->M0_CODIGO == "01"
	   SD7->D7_SERIE := "001"
     ElseIf SM0->M0_CODIGO == "02"
	   SD7->D7_SERIE := "1  "
     Endif
     SD7->D7_FORNECE := CMVFOR
     SD7->D7_LOJA    := CMVLJ
	MSUNLOCK("SD7")      
	                           
	
// ACERTA O NUMERO DO LOTE
dbSelectArea("SX6")
GetMV("MV_DOCTRAN")
RecLock("SX6",.F.)
SX6->X6_CONTEUD := Soma1(GetMV("MV_DOCTRAN"),5)
MSUnlock("SX6")

RETURN	                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvSB2    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
Static Function GrvSB2(cDoc, nItem)
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
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkSE2    บAutor  ณMicrosiga           บ Data ณ  08/29/07   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	
Static Function ChkSE2()

Local lRet, cDI, aAreaTRB

lRet := .f.
aAreaTRB := TRB->(GetArea())

TRB->(dbGoTop())
cDI := Subs(AllTrim(TRB->DI),4,6)

SE2->(dbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
If SE2->(dbSeek(xFilial("SE2")+"DI "+cDI+" "+"BOL"+cMvFor+cMvLj))
	msgStop("Duplicata " + cDI + " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
	lRet := .t.
EndIf
	
RestArea(aAreaTRB)   

Return lRet


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
Local nCont, cNFIni, cNFAux, cTxt, cAdicao, aAreaAtu, aReserv

cTxt     := ""
nCont    := 1
cNFIni   := cMvDoc
cNFAux   := cNFIni
aReserv  := {}
aAreaAtu := GetArea()

dbSelectArea("TRB")
TRB->(dbGoTop())

ProcRegua(TRB->(RecCount()))

aAdd(aReserv,cNFIni)
While TRB->(!EOF())
	cAdicao := TRB->ADICAO
	While cAdicao == TRB->ADICAO
		IncProc("Fazendo contagem das notas fiscais a serem reservadas... " +cAdicao)	
		If nCont > 11
			nCont   := 1
			cNFAux  := Soma1(cNFAux,6)
			aAdd(aReserv,cNFAux)
			cAdicao := TRB->ADICAO
		EndIf
		TRB->(dbSkip())
		nCont++
	End

	If TRB->(!EOF())
		nCont   := 1
		cNFAux  := Soma1(cNFAux,6)
		aAdd(aReserv,cNFAux)
	EndIf
End

For i:=1 to Len(aReserv)
	cTxt += aReserv[i] + " / "
Next i

msgInfo("Notas fiscais a serem separadas: " +cTxt )
msgInfo("Notas fiscais a serem separadas: " +cTxt )

RestArea(aAreaAtu)

Return
