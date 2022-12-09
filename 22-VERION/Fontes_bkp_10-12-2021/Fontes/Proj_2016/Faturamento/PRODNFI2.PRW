#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProdNFI   ºAutor  ³Microsiga           º Data ³  08/15/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera relatorio dos produtos contidos no arquivo            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProdNFI2()

Local aSays,aButtons,cTitulo,nOpc,cPerg
Private lOpenArq,cMvFor,cMvLj,cMvDoc

cArq     := ""
aSays    := {}
aButtons := {}
nOpc     := 0
lOpenArq := .f.
cPerg    := "PRDNFI2    "
cTitulo  := "Produtos inexistentes - Nota Fiscal Importação VERSAO EXCELL"

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Rotina que lë os produtos contidos no arquivo da")
aAdd(aSays,"Nota Fiscal de Importação. ")
aAdd(aSays,"Esta irá gerar um arquivo com os produtos não localizados no Protheus.")

aAdd(aButtons,{1,.t.,{|o|nOpc:=1, o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|nOpc:=2, o:oWnd:End()}})
aAdd(aButtons,{14,.t.,{|o| lOpenArq :=.t., OpenArq(), o:oWnd:Refresh()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1
	If msgBox("Confirma o processamento?","Confirma","YesNo")
		If lOpenArq
			Processa({||RunProdNFI()},"Processando...")
		Else
			msgStop("Selecione o arquivo a ser processado no botão ABRIR...")
			lOpenArq := .f.
		EndIf
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OpenArq   º Autor ³Microsiga           º Data ³  08/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre arquivo do Aduaneiro                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verion                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OpenArq()

Local cType

cType := "Arquivos texto|*.TXT|Todos os arquivos|*.*"

cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo enviado pelo Aduaneiro"),0,"SERVIDOR\",.t.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunProdNFIº Autor ³Microsiga           º Data ³  08/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunProdNFI()

Local cBuffer, aImp, nRecCount, cSql, cExists, cQuery, cCodPro, cCodNew, aCabNF, aItmNF, nCont, cDoc, cAdicao, nItem, lSF1, lAdic

Local nCposVld := 0
Local aCposVld := {{"B1_CODIMP" , ""          , ""       }, ;
{"B1_COD"    , "DI_COD"    , "COD_PRO"}, ;
{"B1_DESC"   , ""          , ""       }, ;
{"B1_POSIPI" , "DI_POSIPI" , "NCM    "}, ;
{"B1_PPIS"   , "DI_PPIS"   , "ALQ_PIS"}, ;
{"B1_PPISE"  , "DI_PPISE"  , "ALQ_PIS"}, ;
{"B1_PCOFINS", "DI_PCOFINS", "ALQ_COF"}, ;
{"B1_PCOFE"  , "DI_PCOFE"  , "ALQ_COF"}, ;
{"B1_IMPIMPO", "DI_IMPIMPO", "ALQ_II "}, ;
{"B1_PICM"   , "DI_PICM"   , "ALQ_ICM"}, ;
{"B1_IPI"    , "DI_IPI"    , "ALQ_IPI"}}

Private nHdl, cFile, cFileProd, lMSHelpAuto, lMsErroAuto, nDesp, nBaseICM, nValICM, nBaseIPI, nValIPI, nBasePis, nValPis, nBaseCof, nValCof, nValII, nTtInvo, nValTt

lSF1  := .t.
lAdic := .f.
bZeraTt := {||(nDesp := nBaseICM := nValICM := nBaseIPI := nValIPI := nBasePis := nValPis := nBaseCof := nValCof := nValII := nValTt := 0)}

aImp := {}
aAdd(aImp,{"OCORREN"   , "C",  6, 0})
aAdd(aImp,{"DI_QTD"    , "N", 11, 2})
aAdd(aImp,{"DI_VLR_TOT", "N", 14, 2})

SX3->(DbSetOrder(2))

For nCposVld := 1 To Len(aCposVld)
	SX3->(DbSeek(PadR(aCposVld[nCposVld][1], 10)))
	
	If !Empty(aCposVld[nCposVld][1])
		aAdd(aImp, {aCposVld[nCposVld][1], SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
	EndIf
	
	If !Empty(aCposVld[nCposVld][2])
		aAdd(aImp, {aCposVld[nCposVld][2], SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
	EndIf
Next

cFileProd := CriaTrab(,aImp,"TRBPROD")
IndRegua("TRBPROD",cFileProd,"DI_COD",,,"Ordenando registros...")

aImp := {}
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
	Aviso("Atenção!", "Arquivo inválido!",{"Ok"})
	TRB->(dbCloseArea())
	Return
EndIf

nHdl := ft_fUse(cArq)
If nHdl<>Nil .and. nHdl<=0
	Aviso("Atenção", "Não foi possível a abertura do arquivo "+AllTrim(cArq)+" !", {"Ok"})
	fClose(cArq)
	Return
EndIf

nCont := 1
ProcRegua(ft_fLastRec())
ft_fGoTop()
Do While !ft_fEOF()
	IncProc("Importando arquivo... " +cArq)
	
	cBuffer := ft_fReadLN()
	cBuffer := AllTrim(Upper(cBuffer))
	
	RecLock("TRB", .t.)
	TRB->NCM     := StrTran(Subs(cBuffer,01,10), ".", "")
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
	TRB->(msUnLock())
	
	// Retira o II
	RecLock("TRB", .f.)
	TRB->UNIT    := TRB->UNIT - (TRB->(VLR_II/QTD))
	TRB->VLR_TOT := TRB->(VLR_TOT-VLR_II)
	TRB->(msUnLock())
	
	ft_fSkip()
	nCont++
EndDo

fClose(cArq)

// Campo DE-PARA do Codigo de Produto Protheus x Codigo de Produto Despachante Aduaneiro
If SB1->(!FieldPos("B1_CODIMP")>0)
	msgStop("Campo B1_CODIMP não localizado... Contate o Administrador do Sistema!")
	TRB->(dbCloseArea())
	Return
EndIf

lGrv := .f.

// Consiste Cadastro de Produtos
dbSelectArea("TRB")
TRB->(dbGoTop())

/*
ProcRegua(TRB->(RecCount()))
Do While TRB->(!EOF())
cCodPro := AllTrim(TRB->COD_PRO)
IncProc("Consistindo produtos... " +cCodPro)

dbSelectArea("SB1")
dbSetOrder(1) // B1_FILIAL+B1_COD
If dbSeek(xFilial("SB1")+cCodPro)
lGrv := .f.
Else
If Select("WorkTt")>0
WorkTt->(dbCloseArea())
EndIf

cQuery := " SELECT COUNT(1) TTPROD"
cQuery += " FROM " +RetSqlName("SB1")
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " AND B1_COD LIKE '%"+cCodPro+"' "
cQuery += " AND D_E_L_E_T_=' ' "
tcQuery cQuery New Alias "WorkTt"

If WorkTt->TTPROD > 1
lGrv := .t.

ElseIf WorkTt->TTPROD == 0
cCodPro2 := Left(cCodPro,12)

If Select("WorkTt")>0
WorkTt->(dbCloseArea())
EndIf

cQuery := " SELECT COUNT(1) TTPROD"
cQuery += " FROM " +RetSqlName("SB1")
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += " AND B1_COD LIKE '%"+cCodPro2+"%' "
cQuery += " AND D_E_L_E_T_=' ' "
tcQuery cQuery New Alias "WorkTt"

If WorkTt->TTPROD == 1
lGrv := .f.
Else
lGrv := .t.
EndIf
EndIf                             

EndIf

If lGrv
RecLock("TRBPROD",.t.)
TRBPROD->COD_PRO := TRB->COD_PRO
TRBPROD->(msUnLock())
EndIf

lGrv := .f.
TRB->(dbSkip())
EndDo
*/

ProcRegua(TRB->(RecCount()))
_adados := {}   
_acabec := {}
_acabec := {"OCORREN","B1_DESC","DI_QTD","DI_VLR_TOT","B1_CODIMP","B1_COD","B1_DESC","B1_POSIPI","B1_PPIS","B1_PPISE","B1_PCOFINS","B1_PCOFE","B1_IMPIMPO","B1_PICM","B1_IPI"}

While TRB->(!EOF())
	cCodPro := PadR(TRB->COD_PRO, Len(SB1->B1_COD))
	
	IncProc("Consistindo produtos... " + AllTrim(cCodPro))
	
	cExists := "SELECT SB1EXT.B1_CODIMP FROM " + RetSqlName("SB1") + " SB1EXT " + ;
	"WHERE SB1EXT.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1EXT.D_E_L_E_T_ <> '*' AND " + ;
	"SB1EXT.B1_MSBLQL <> '1' AND SB1EXT.B1_CODIMP = '" + cCodPro + "'"
	
	cSql := "FROM " + RetSqlname("SB1") + " SB1 " + ;
	"WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_MSBLQL <> '1' AND " + ;
	"((NOT EXISTS (" + cExists + ") AND " + ;
	"(SB1.B1_COD = '"     + cCodPro          +  "' OR " + ;
	"SB1.B1_COD LIKE '%" + AllTrim(cCodPro) +  "' OR " + ;
	"SB1.B1_COD LIKE '%" + AllTrim(cCodPro) + "%')) OR " + ;
	"SB1.B1_CODIMP = '" + cCodPro + "')"
	
	cQuery := "SELECT COUNT(*) nQtdProd " + cSql
	
	TCQuery cQuery New Alias "SB1TMP"
	
	nRecCount := SB1TMP->nQtdProd
	
	SB1TMP->(dbCloseArea())
	
	DbSelectArea("TRBPROD")
	If     nRecCount == 0 // Produto não encontrado
		RecLock("TRBPROD", .T.)
		TRBPROD->OCORREN    := "Nenhum"
		TRBPROD->B1_DESC    := "Produto não encontrado"
		TRBPROD->DI_COD     := cCodPro
		TRBPROD->DI_QTD     := TRB->QTD
		TRBPROD->DI_VLR_TOT := TRB->VLR_TOT
		MsUnLock()
		
	Else //nRecCount == 1 ou // Produto com codigo exato encontrado
		//nRecCount >  2    // Varios produtos encontrados com o mesmo codigo
		cQuery := "SELECT "
		For nCposVld := 1 To Len(aCposVld)
			cQuery += IIf(nCposVld == 1, "", ", ") + AllTrim(aCposVld[nCposVld][1])
		Next
		cQuery += ", B1_DESC " + cSql
		TCQuery cQuery New Alias "SB1TMP"
		
		DbSelectArea("SB1TMP")
		While !Eof()
			DbSelectArea("TRBPROD")
			RecLock("TRBPROD", .T.)
			TRBPROD->OCORREN    := IIf(nRecCount == 1, "Ok", "Varios")
			TRBPROD->B1_DESC    := SB1TMP->B1_DESC
			TRBPROD->DI_QTD     := TRB->QTD
			TRBPROD->DI_VLR_TOT := TRB->VLR_TOT
			For nCposVld := 1 To Len(aCposVld)
				TRBPROD->&(aCposVld[nCposVld][1]) := SB1TMP->&(aCposVld[nCposVld][1])
				TRBPROD->&(aCposVld[nCposVld][2]) := TRB->&(aCposVld[nCposVld][3])
			Next
			MsUnLock()
			
			DbSelectAre("SB1TMP")
			DBSkip()
		End
		
		SB1TMP->(DbCloseArea())
	EndIf
    
    aAdd(_aDados,{ TRBPROD->OCORREN,TRBPROD->B1_DESC,TRBPROD->DI_QTD,TRBPROD->DI_VLR_TOT,TRBPROD->B1_CODIMP,TRBPROD->B1_COD,TRBPROD->B1_DESC,TRBPROD->B1_POSIPI,TRBPROD->B1_PPIS,TRBPROD->B1_PPISE,TRBPROD->B1_PCOFINS,TRBPROD->B1_PCOFE,TRBPROD->B1_IMPIMPO,TRBPROD->B1_PICM,TRBPROD->B1_IPI})

	DbSelectArea("TRB")
	TRB->(dbSkip())
End

cATMP := "\SYSTEM\" + subs(dtos(Date()),5,5) + "-" + subs(strtran(time(),":",""),1,4) + ".dbf" 

DbSelectArea("TRBPROD")         
copy to &cATMP VIA "DBFCDXADS"

msgInfo("Foi gerado um arquivo para ser aberto no Excel, localizado no diretório SYSTEM, chamado: " + cATMP)

// GERA A PLANILHA EXCELL
//arTitulo := "arquivo"
//DlgtoExcel({{"ARRAY",arTitulo,_aCABEC, _aDados}})    

TRB->(dbCloseArea())
TRBPROD->(dbCloseArea())

//oExcelApp := msExcel():New()
//oExcelApp:SetVisible(.t.)

If File(cFileProd + ".DBF")
	If ApOleClient("MsExcel")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFileProd + ".DBF") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		ApMsgStop( "Nao foi possivel Abrir Microsoft Excel.", "ATENÇÃO" )
	Endif
	
Endif

Return
