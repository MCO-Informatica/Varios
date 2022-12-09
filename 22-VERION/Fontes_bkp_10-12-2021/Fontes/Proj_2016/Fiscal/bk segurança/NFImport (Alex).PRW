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
aAdd(aImp,{"COD_PRO","C",15,0})
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
aAdd(aImp,{"COD_NEW","C",15,0})
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
				
			RecLock("TRB", .f.)
			TRB->COD_NEW := cCodNew
			TRB->(msUnLock())
		EndIf
	EndIf
		
	TRB->(dbSkip())
EndDo
	
//Inclui Documento Entrada, Livro e Duplicata
TRB->(dbGoTop())
ProcRegua(TRB->(RecCount()))
	
nTtInvo := 0
cDoc := cMvDoc
_aItem1:={}
aItens :={}

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
		dbSelectArea("SF1")
		dbSetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		If dbSeek(xFilial("SF1")+cDoc+"1  "+cMvFor+cMvLj+"N")
			msgStop("Nota Fiscal " + cDoc + " jแ cadastrada... Checar, corrigir e iniciar novamente o processo!")
			TRB->(dbCloseArea())
			Return
		EndIf
		
		_aItem1 := {}
		GrvSD1(cDoc, nItem, nTotIt,@_aItem1)
		AADD(aItens,_aItem1)
			
		nItem++
		TRB->(dbSkip())
	EndDo            
    
    _aCab1 := {}
	GrvSF1(cDoc,@_aCab1)
		
	lMsErroAuto := .F.                 
	lMostra     := .T.
	MATA103(_aCab1,aItens,3,lMostra)   

	If lMsErroAuto
		Mostraerro()
		DisarmTransaction()
		break             
	EndIf
	
		
	cDoc := Soma1(cDoc,6)
	nItem := 1 //Incluํdo por Alex - Adinfo - 09/09/2014
    aItens:= {}

	
EndDo

If Select("TRB")>0
	TRB->(dbCloseArea())
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

Static Function GrvSF1(cDoc,_aCab1)

aAreaTRB := TRB->(GetArea())
lRet := .T.

TRB->(dbGoTop())

_cNumNotas += cDoc+"/"	
_cSerie := ""

If SM0->M0_CODIGO == "01"
	_cSerie   := "001"
Endif 
If SM0->M0_CODIGO == "02"
	_cSerie   := "1  "
Endif


_aCab1 :={ 	{"F1_FILIAL"	 	, xFilial("SF1"),NIL},;
			{"F1_TIPO"		 	, "N"			,NIL},;
		   	{"F1_FORMUL"	 	, "N"			,NIL},;
		   	{"F1_DOC"		 	, cDoc			,NIL},;
			{"F1_SERIE"		 	, _cSerie		,NIL},;
			{"F1_EMISSAO"	 	, dDataBase		,NIL},;
	    	{"F1_FORNECE"	 	, cMvFor      	,NIL},;		
	    	{"F1_LOJA"	     	, cMvLj        	,NIL},;		
	    	{"F1_ESPECIE"	 	, "SPED"   		,NIL}}


//			{"SF1->F1_EST"	 	, "EX"			,NIL},;
//			{"SF1->F1_DESPESA"	, nDesp			,NIL},;
//			{"SF1->F1_BASEICM"	, nBaseICM		,NIL},;
//			{"SF1->F1_VALICM"	, nValICM		,NIL},;
//			{"SF1->F1_BASEIPI"	, nBaseIPI		,NIL},;
//			{"SF1->F1_VALIPI"	, nValIPI		,NIL},;
//			{"SF1->F1_BASIMP5"	, nBaseCof		,NIL},;
// 			{"SF1->F1_VALIMP5"	, nValCof		,NIL},;
// 			{"SF1->F1_BASIMP6"	, nBasePis		,NIL},;
// 			{"SF1->F1_VALIMP6"	, nValPis		,NIL},;
// 			{"SF1->F1_CIF"	 	, nBasCIF		,NIL},;
// 			{"SF1->F1_II"	 	, nValII		,NIL},;
// 			{"SF1->F1_VALMERC"	, nBaseICM-(nValIPI+nDesp),NIL},;
//			{"SF1->F1_VALBRUT"	, nBaseICM		,NIL},;
//			{"SF1->F1_XMENS1"	, "DI " + TRB->DI + " DE " + DtoC(TRB->DT_DI) + chr(32) + TRB->INVOICE,NIL},;
//		    {"SF1->F1_XNDI"	 	, strtran(strtran(TRB->DI,"/",""),"-",""),NIL},; 
//		    {"SF1->F1_XDTDI"	, MV_PAR04		,NIL},;
//		    {"SF1->F1_XLOCDES"	, MV_PAR05		,NIL},;
//			{"SF1->F1_XUFDES"	, MV_PAR06		,NIL},;
//		    {"SF1->F1_XDTDES"	, MV_PAR07		,NIL},;
//			{"SF1->F1_XCODEXP"	, MV_PAR08		,NIL},;
//			{"SF1->F1_XEMAILD"	, MV_PAR10		,NIL},;
//			{"SF1->F1_TRANSP"	, MV_PAR14		,NIL},; //Transportadora
//			{"SF1->F1_VOLUME1"	, MV_PAR15		,NIL},; //Quantidade Volume
//			{"SF1->F1_ESPECI1"	, MV_PAR16		,NIL},; //Especie Volume
//			{"SF1->F1_PLIQUI"	, MV_PAR17		,NIL},; //Peso Liquido
//			{"SF1->F1_PBRUTO"	, MV_PAR18		,NIL},; //Peso Bruto

	
//	SF1->F1_HORA := TIME()     
//	SF1->F1_DTDIGIT := dDataBase
//	SF1->F1_MOEDA   := TRB->MOEDA
//	SF1->F1_STATUS  := "A"
//	SF1->F1_RECBMTO := dDataBase	

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

	AADD(_aItem1,{"D1_FILIAL"		,xFilial("SD1")		,NIL})
	AADD(_aItem1,{"SD1->D1_ITEM"	,StrZero(nItem,4)	,NIL})
	AADD(_aItem1,{"SD1->D1_COD"		,TRB->COD_NEW		,NIL})
	AADD(_aItem1,{"SD1->D1_DESCPRO" ,SB1->B1_DESC		,NIL})
	AADD(_aItem1,{"SD1->D1_UM"		,SB1->B1_UM			,NIL})
	AADD(_aItem1,{"SD1->D1_QUANT"	,TRB->QTD			,NIL})
	AADD(_aItem1,{"SD1->D1_VUNIT"	,TRB->UNIT +  round((TRB->VLR_II/TRB->QTD),4),NIL})
	AADD(_aItem1,{"SD1->D1_TOTAL"	,SD1->D1_VUNIT * TRB->QTD ,NIL})
	AADD(_aItem1,{"SD1->D1_VALIPI"	,TRB->VLR_IPI,NIL})
	AADD(_aItem1,{"SD1->D1_VALICM"	,TRB->VLR_ICM,NIL})
//-->	TRB->ALQ_COF = campo que tem a alํquoto do arquivo txt

//	Incluido por Alex Rodrigues - 11/08/2014
//	_nAliqPad := SuperGetMV("MV_TXCOFIN")
//Alterado por Alex Rodrigues - 05/05/2015
	_nAliqPad := 9.65

	IF TRB->ALQ_IPI > 0
		If TRB->ALQ_COF > _nAliqPad
			AADD(_aItem1,{"SD1->D1_TES"	,"254",NIL}) // com ipi, COM majora็ใo
		Else
			AADD(_aItem1,{"SD1->D1_TES"	,"261",NIL}) // com ipi, SEM majora็ใo
		Endif
	Else
		If TRB->ALQ_COF > _nAliqPad
			AADD(_aItem1,{"SD1->D1_TES"	,"259",NIL}) // sem ipi, COM majora็ใo ->  mudar 259
		Else
			AADD(_aItem1,{"SD1->D1_TES"	,"262",NIL}) // sem ipi, SEM majora็ใo
		Endif
	Endif
	
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+SD1->D1_TES)	
	
	AADD(_aItem1,{"SD1->D1_CF"		,"3102",NIL})
	AADD(_aItem1,{"SD1->D1_DESC"	,0,NIL})
	AADD(_aItem1,{"SD1->D1_IPI"		,TRB->ALQ_IPI,NIL})
	AADD(_aItem1,{"SD1->D1_PICM"	,TRB->ALQ_ICM,NIL})
	AADD(_aItem1,{"SD1->D1_PESO"	,0,NIL})
	AADD(_aItem1,{"SD1->D1_PEDIDO"	,"",NIL})
	AADD(_aItem1,{"SD1->D1_FORNECE"	,cMvFor,NIL})
	AADD(_aItem1,{"SD1->D1_LOJA"	,cMvLj,NIL})
	AADD(_aItem1,{"SD1->D1_ITEMPC"	,"",NIL})
	AADD(_aItem1,{"SD1->D1_DOC"		,cDoc,NIL})
	AADD(_aItem1,{"SD1->D1_EMISSAO"	,ddatabase,NIL})  // TRB->DT_DI
	AADD(_aItem1,{"SD1->D1_DTDIGIT"	,dDataBase,NIL})
	AADD(_aItem1,{"SD1->D1_LOCAL"	,SB1->B1_LOCPAD,NIL})
	AADD(_aItem1,{"SD1->D1_GRUPO"	,SB1->B1_GRUPO,NIL})
	If SM0->M0_CODIGO == "01"
	   AADD(_aItem1,{"SD1->D1_SERIE","001",NIL})
    Endif 
    If SM0->M0_CODIGO == "02"
	   AADD(_aItem1,{"SD1->D1_SERIE","1  ",NIL})
    Endif
	AADD(_aItem1,{"SD1->D1_TIPO"	,"N",NIL})
	AADD(_aItem1,{"SD1->D1_TP"		,SB1->B1_TIPO,NIL})
	AADD(_aItem1,{"SD1->D1_NUMSEQ"	,"",NIL})
	AADD(_aItem1,{"SD1->D1_ICMSRET"	,0,NIL})
	AADD(_aItem1,{"SD1->D1_BRICMS"	,0,NIL})
	AADD(_aItem1,{"SD1->D1_BASEICM"	,TRB->BAS_ICM,NIL})
	AADD(_aItem1,{"SD1->D1_VALDESC"	,0,NIL})
	IF TRB->ALQ_IPI > 0
		AADD(_aItem1,{"SD1->D1_BASEIPI"	,TRB->BAS_IPI,NIL})
	else                                 
		AADD(_aItem1,{"SD1->D1_BASEIPI"	,0 ,NIL}) //  TRB->BAS_IPI
	endif
	AADD(_aItem1,{"SD1->D1_FORMUL"	,"S"        ,NIL})
	AADD(_aItem1,{"SD1->D1_CIF"		,TRB->BAS_II,NIL})
	AADD(_aItem1,{"SD1->D1_II"		,(round((TRB->VLR_II/TRB->QTD),4))*TRB->QTD ,NIL})//TRB->VLR_II
	AADD(_aItem1,{"SD1->D1_CLASFIS"	,SB1->B1_ORIGEM+SF4->F4_SITTRIB  ,NIL}) //Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_SITTRIB") //"254"
//	AADD(_aItem1,{"SD1->D1_CUSTO"	,   := 0,NIL})
	AADD(_aItem1,{"SD1->D1_BASIMP5"	,TRB->BAS_COF,NIL})
	AADD(_aItem1,{"SD1->D1_BASIMP6"	,TRB->BAS_PIS,NIL})
	AADD(_aItem1,{"SD1->D1_VALIMP5"	,TRB->VLR_COF,NIL})
	AADD(_aItem1,{"SD1->D1_VALIMP6"	,TRB->VLR_PIS,NIL})
	AADD(_aItem1,{"SD1->D1_ALQIMP5"	,TRB->ALQ_COF,NIL})
	AADD(_aItem1,{"SD1->D1_ALQIMP6"	,TRB->ALQ_PIS,NIL})
	AADD(_aItem1,{"SD1->D1_RATEIO"	,"2",NIL})
	AADD(_aItem1,{"SD1->D1_DESPESA"	,TRB->DESP,NIL})
	AADD(_aItem1,{"SD1->D1_STSERV"	,"1",NIL})
	AADD(_aItem1,{"SD1->D1_ORIGEM"	,"NFEIMP",NIL})
	AADD(_aItem1,{"SD1->D1_DI"		,strtran(strtran(TRB->DI,"/",""),"-",""),NIL})
	AADD(_aItem1,{"SD1->D1_ADIC"	,Right(TRB->ADICAO,3)    ,NIL})
	AADD(_aItem1,{"SD1->D1_ALIQII"	,TRB->ALQ_II,NIL})
	AADD(_aItem1,{"SD1->D1_XOPER"	,"60",NIL})
	AADD(_aItem1,{"SD1->D1_XFABRIC"	,MV_PAR09 ,NIL})
	AADD(_aItem1,{"SD1->D1_DIIT"	,StrZero(TRB->NCONT,3),NIL})
	AADD(_aItem1,{"SD1->D1_CONTA"	,SB1->B1_CONTA ,NIL})//Incluํdo por Alex Rodrigues - 05/07/2018
	
	DbSelectArea("SA5")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA5")+cMvFor+cMvLj+TRB->COD_NEW)
		RecLock("SA5",.T.)          
			SA5->A5_FILIAL 	:= xFilial("SA5")
			SA5->A5_FORNECE := cMvFor
			SA5->A5_LOJA	:= cMvLj
			SA5->A5_NOMEFOR := Posicione("SA2",1,xFilial("SA2")+cMvFor+cMvLj,"A2_NOME")
			SA5->A5_PRODUTO	:= TRB->COD_NEW
			SA5->A5_NOMPROD	:= Posicione("SB1",1,xFilial("SB1")+TRB->COD_NEW,"B1_DESC")
			SA5->A5_SKIPLOT	:= 1
			SA5->A5_NOTA	:= 9
		MsUnLock()
	Endif
	
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
