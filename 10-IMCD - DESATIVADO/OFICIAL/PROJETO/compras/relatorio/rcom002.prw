#include  "rwmake.ch"
#include "protheus.ch"
#INCLUDE "MSOLE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOM002   ºAutor  ³Giane               º Data ³  22/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao grafica do PEDIDO DE COMPRAS                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOM002(cNumPed,lFecha)

Local lRet := .f.
Local cDotRede  := "word\PedCompras_IMCD.dotm"     //criar a pasta WORD debaixo do \system
Local cIniFile := GetADV97()
Local cStartPath:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
Local cDotLocal := "C:\temp\"
Local cAnexLoc  := "c:\temp"
Local cArqDot   := "PedCompras_IMCD.dotm"
Local nItem := 0
Local nPag := 0
Local aLaco := {}
Local cProduto
Local _aArea := GetArea()
Local nIpi := 0
Local cSavePDF
Local cObs := ""
Local cObsIte := ""
Local nTotal := 0

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RCOM002" , __cUserID )

Private	 hWord

if lFecha == NIL
	OLE_CloseLink( hWord ) //Fecha  o link caso o usuario que tenha fechado o word.
	lFecha := .f.
Endif

//Conecta ao word
hWord	:= OLE_CreateLink()
if hWord == "-1"
	u_MsgHBox("Impossível estabelecer comunicação com o Microsoft Word.", "RCOM002")
	Return Nil
Endif

MontaDir(cDotLocal)
MontaDir(cAnexLoc)

if !( file(cDotLocal+cArqDot) )
	CpyS2T(cDotRede, cDotLocal)
endif

DbSelectArea("SC7")
DbSetorder(1)
if !DbSeek(xfilial("SC7")+cNumPed)
	u_MsgHBox("Orcamento " + cNumPed + " nao encontrado!", "RCOM002")
	OLE_CloseLink( hWord )
	return nil
endif

nItem := 0
nPag := 1
aItensPed := {}
aLaco := {}
_itens := 0

//  INICIO - JUNIOR CARVALHO - 29/09/2015
cTpFrete	:= iif(SC7->C7_TPFRETE == "C","CIF","FOB" )
nvlrFrete	:= 0
nvlrDesc	:= 0
nvlrDesp	:= 0

Do Case
	Case SC7->C7_MOEDA == 1'
		cSimMoeda	:= "R$ "
	Case SC7->C7_MOEDA == 2
		cSimMoeda	:= "U$D "
	Case SC7->C7_MOEDA == 4
		cSimMoeda	:= "EUR "
	Case SC7->C7_MOEDA == 5  //DOLAR CANADENSE
		cSimMoeda	:= "CAD "
	OtherWise
		cSimMoeda	:= " "
EndCase
//  FIM - JUNIOR CARVALHO - 29/09/2015


Do While SC7->(!EOF()) .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cNumPed
	
	nItem++
	If nItem > 5
		aadd( aLaco, {nPag, nItem-1})
		nPag++
		nItem := 1
	endif
	
	cDescr := Posicione("SB1",1,xfilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
	
	Aadd(aItensPed, {SC7->C7_ITEM, cDescr, SC7->C7_DATPRF, SC7->C7_QUANT, SC7->C7_UM, SC7->C7_PRECO , SC7->C7_VLDESC, SC7->C7_IPI, (SC7->C7_TOTAL - SC7->C7_VLDESC ), SC7->C7_OBS })
	
	nTotal += (SC7->C7_TOTAL + SC7->C7_VALIPI + C7_VALFRE - SC7->C7_VLDESC )
	
	nvlrFrete	+= SC7->C7_VALFRE
	nvlrDesc	+= SC7->C7_VLDESC
	nvlrDesp	+= SC7->C7_DESPESA
	
	_itens++
	SC7->(DbSkip())
Enddo

if nItem < 6
	aadd( aLaco, {nPag, nItem})
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando novo documento do Word na estacao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

OLE_NewFile( hWord, Alltrim( cDotLocal + cArqDot ) )

if lFecha
	OLE_SetProperty( hWord, oleWdVisible, .F. )
endif

OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(_itens++))

For nY := 1 to len(aLaco)
	
	For nX := 1 to  (NY * 5) //aLaco[nY,2]
		
		cItem    := "'cItem"      + Alltrim(str(nX)) + "'"
		cDescr   := "'cDescr"     + Alltrim(str(nX)) + "'"
		cQuant   := "'cQuant"     + Alltrim(str(nX)) + "'"
		cUnid    := "'cUnid"      + Alltrim(str(nX)) + "'"
		cVlrUnit := "'cUnit"      + Alltrim(str(nX)) + "'"
		cEntrega := "'cEntrega"   + Alltrim(str(nX)) + "'"
		cDescIT  := "'cDescIT"    + Alltrim(str(nX)) + "'"
		cIPI     := "'cIPI"       + Alltrim(str(nX)) + "'"
		cSubTot  := "'cSubTot"    + Alltrim(str(nX)) + "'"
		cObsIte  := "'cObsIte"    + Alltrim(str(nX)) + "'"
		
		
		If nX > len(aItensPed)
			OLE_SetDocumentVar(hWord, &cItem   , "")
			OLE_SetDocumentVar(hWord, &cDescr  , "")
			OLE_SetDocumentVar(hWord, &cQuant  , ""  )
			OLE_SetDocumentVar(hWord, &cUnid   , " " )
			OLE_SetDocumentVar(hWord, &cvlrUnit , ""  )
			OLE_SetDocumentVar(hWord, &cEntrega , ""  )
			OLE_SetDocumentVar(hWord, &cDescIT , "" )
			OLE_SetDocumentVar(hWord, &cIpi , "" )
			OLE_SetDocumentVar(hWord, &cSubTot , "")
			OLE_SetDocumentVar(hWord, &cObsIte , "")
			
		Else
			OLE_SetDocumentVar(hWord, &cItem   , aItensPed[nX,1])
			OLE_SetDocumentVar(hWord, &cDescr  , aItensPed[nX,2])
			OLE_SetDocumentVar(hWord, &cEntrega , aItensPed[nX,3] )
			OLE_SetDocumentVar(hWord, &cQuant  , transform(aItensPed[nX,4],"@E 999,999.9999")  )
			OLE_SetDocumentVar(hWord, &cUnid   , aItensPed[nX,5] )
			OLE_SetDocumentVar(hWord, &cvlrUnit , cSimMoeda+transform(aItensPed[nX,6],"@E 999,999.999999") )
			OLE_SetDocumentVar(hWord, &cDescIT , cSimMoeda+transform(aItensPed[nX,7],"@E 999,999.99") )
			OLE_SetDocumentVar(hWord, &cIPI , transform(aItensPed[nX,8],"@E 99.99") )
			OLE_SetDocumentVar(hWord, &cSubTot, cSimMoeda+transform(aItensPed[nX,9],"@E 99,999,999.99") )
			
			cObs := alltrim(aItensPed[nX,10])
			OLE_SetDocumentVar(hWord, &cObsIte, cObs )
		Endif
	Next nX
Next nY

OLE_ExecuteMacro(hWord,"tabitens")

DbSeek(xfilial("SC7")+cNumPed)
OLE_SetDocumentVar(hWord, 'cNum', cNumPed  )
OLE_SetDocumentVar(hWord, 'dEmissao', SC7->C7_EMISSAO )

cEmail := UsrRetMail( SC7->C7_USER ) //AllTrim(Posicione("SY1",3,xFilial("SY1") + SC7->C7_USER,"Y1_EMAIL" )  )
cEmail := iif(Empty(cEmail),"imcdbrasil@imcdbrasil.com.br",cEmail)

OLE_SetDocumentVar(hWord, 'cEmail', cEmail  )
OLE_SetDocumentVar(hWord, 'cComprador', Posicione("SY1",3,xFilial("SY1") + SC7->C7_USER,"Y1_NOME" )  )
//  INICIO - JUNIOR CARVALHO - 29/09/2015
OLE_SetDocumentVar(hWord, 'cRazaoSocial', AllTrim(SM0->M0_NOMECOM))
OLE_SetDocumentVar(hWord, 'cEmp_CNPJ', TRANSFORM(SM0->M0_CGC,"@r 99.999.999/9999-99"))
OLE_SetDocumentVar(hWord, 'cEmp_IE', AllTrim(SM0->M0_INSC))
OLE_SetDocumentVar(hWord, 'cEmp_End', AllTrim(SM0->M0_ENDCOB))
OLE_SetDocumentVar(hWord, 'cEmp_CEP', TRANSFORM(SM0->M0_CEPCOB,"@r 99999-999"))
OLE_SetDocumentVar(hWord, 'cEmp_Bairro', AllTrim(SM0->M0_BAIRCOB))
OLE_SetDocumentVar(hWord, 'cEmp_Mun', AllTrim(SM0->M0_CIDCOB))
OLE_SetDocumentVar(hWord, 'cEmp_UF', AllTrim(SM0->M0_ESTCOB))
OLE_SetDocumentVar(hWord, 'cEmp_Fone', "+"+AllTrim(SM0->M0_TEL))

IF Empty(cSimMoeda)
	OLE_SetDocumentVar(hWord, 'nDolar',"." )
Else
	OLE_SetDocumentVar(hWord, 'nDolar',"Taxa : "+cSimMoeda+Transform(SC7->C7_TXMOEDA ,"@E 999.99"))
Endif


OLE_SetDocumentVar(hWord, 'cTpFrete',cTpFrete)
OLE_SetDocumentVar(hWord, 'nVlrFrete',Transform(nvlrFrete,"@E 999,999.99"))
OLE_SetDocumentVar(hWord, 'nDespesas',Transform(nvlrDesp,"@E 999,999.99"))
OLE_SetDocumentVar(hWord, 'nDescontos',Transform(nvlrDesc,"@E 999,999.99"))
// FIM - JUNIOR CARVALHO - 29/09/2015

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xfilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
OLE_SetDocumentVar(hWord, 'cFornec', SA2->A2_NOME )
OLE_SetDocumentVar(hWord, 'cEndFor', SA2->A2_END )
OLE_SetDocumentVar(hWord, 'cBairroFor', SA2->A2_BAIRRO )
OLE_SetDocumentVar(hWord, 'cCepFor', SA2->A2_CEP  )
OLE_SetDocumentVar(hWord, 'cCidade', SA2->A2_MUN + ' - ' + SA2->A2_EST  )
OLE_SetDocumentVar(hWord, 'cIE', SA2->A2_INSCR )
cCnpj := space(14)
if !empty(SA2->A2_CGC)
	cCnpj := left(SA2->A2_CGC,2) + '.' + substr(SA2->A2_CGC,3,3) + '.' + Substr(SA2->A2_CGC,6,3) +;
	'/' + Substr(SA2->A2_CGC,9,4) + '-' + right(SA2->A2_CGC,2)
endif
OLE_SetDocumentVar(hWord, 'cCnpj', cCnpj )

OLE_SetDocumentVar(hWord, 'cFoneFor', SA2->A2_TEL )
OLE_SetDocumentVar(hWord, 'cFaxFor', SA2->A2_FAX )
cFrete := ""
If SC7->C7_TPFRETE == 'C
	cFrete := 'CIF'
elseif SC7->C7_TPFRETE == 'F'
	cFrete := 'FOB'
endif
OLE_SetDocumentVar(hWord, 'cFrete', cFrete )
OLE_SetDocumentVar(hWord, 'cContato', SC7->C7_CONTATO )
OLE_SetDocumentVar(hWord, 'cCond', Posicione("SE4",1,xfilial("SE4")+SC7->C7_COND,"E4_DESCRI") )

OLE_SetDocumentVar(hWord, 'cTotal', cSimMoeda+transform(nTotal,"@E 999,999,999.99") )

//OLE_SetDocumentVar(hWord, 'cTransport', Posicione("SA4",1,xfilial("SA4")+SUA->UA_TRANSP,"A4_NOME" ) )

OLE_UpdateFields(hWord)

cSaveFile := 'Pedido_de_Compra_' + SC7->C7_NUM + ".doc"

If File(cAnexLoc+"\"+ cSaveFile)
	FErase(cAnexLoc+"\"+ cSaveFile)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva o arquivo no disco rigido                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SaveAsFile(hWord, cAnexLoc+"\"+ cSaveFile )
Sleep(1000)// Espera 2 segundos pra dar tempo de imprimir.

OLE_SetProperty( hWord, oleWdVisible, !lFecha )

//transforma em pdf para depois enviar por email
cSavePDF := 'Pedido_de_Compra_' + cNumPed + ".pdf"
GravaFile("c:\temp\",cSavePDF)

if lFecha
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
endif

If File(cAnexLoc+"\"+ cSaveFile)
	FErase(cAnexLoc+"\"+ cSaveFile)
EndIf

RestArea(_aArea)
Return()


Static Function GravaFile(DIR_RAIZ,cSavePDF)

MakeDir(DIR_RAIZ)

If File(DIR_RAIZ+"\makPedCom.pdf")
	FErase(DIR_RAIZ+"\makPedCom.pdf")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva o arquivo em arquivo do disco rigido para envio do email        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//   Quem executa a gravacao do arquivo é a macro abaixo.
OLE_ExecuteMacro(hWord, "vartypepdf" )

Sleep(1000)

If File(DIR_RAIZ+"\makPedCom.pdf")
	__copyfile(DIR_RAIZ+"\makPedCom.pdf","c:\temp\"+cSavePDF)

	FErase( DIR_RAIZ+"\makPedCom.pdf" )

Else
	MsgStop("Arquivo nao encontrado -> " + DIR_RAIZ+"\makPedCom.pdf")
EndIf

Return
