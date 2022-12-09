#include  "rwmake.ch"
#include  "protheus.ch"
#INCLUDE "MSOLE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT040   บAutor  ณGiane               บ Data ณ  28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao grafica do ORCAMENTO LAYOUT DA MAKENI             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFAT040(cNumOrc,lFecha,cNomeF)

//Local lRet := .f.
Local cDotRede  := "word\OrcamentoMakeni.dotm"     //criar a pasta WORD debaixo do \system
Local cIniFile := GetADV97()
Local cStartPath:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
Local cDotLocal := "C:\temp\"
Local cAnexLoc  := "c:\temp\"
Local cArqDot   := "OrcamentoMakeni.dotm"
Local nItem := 0
Local nPag := 0
Local aLaco := {}
Local _aArea := GetArea()
Local nIpi := 0
Local cSavePDF
Local nVlrUnit := 0
Local nY := 0
Local nX := 0
default cNomeF := ""
Private	 hWord

if lFecha == NIL
	OLE_CloseLink( hWord ) //Fecha  o link caso o usuario que tenha fechado o word.
	lFecha := .f.
Endif

//Conecta ao word
hWord	:= OLE_CreateLink()
if hWord == "-1"
	u_MsgHBox("Impossํvel estabelecer comunica็ใo com o Microsoft Word.", "RFAT040")
	Return Nil
Endif

MontaDir(cDotLocal)
MontaDir(cAnexLoc)

If File(cDotLocal+"\"+ cArqDot)
	FErase(cDotLocal+"\"+ cArqDot)
EndIf

If !CpyS2T( cStartPath + cDotRede, cDotLocal, .T. )
	u_MsgHBox("Impossํvel copiar modelo word para o disco local! " +cStartPath + cDotRede , "RFAT040")
	OLE_CloseLink( hWord )
	return nil
endif

DbSelectArea("SCJ")
DbSetorder(1)
if !DbSeek(xfilial("SCJ")+cNumOrc)
	u_MsgHBox("Orcamento " + cNumOrc + " nao encontrado!", "RFAT040")
	OLE_CloseLink( hWord )
	return nil
endif

DbSelectArea("SCK")
DbSetOrder(1)

if !DbSeek(xfilial("SCK")+cNumOrc)
	u_MsgHBox("Itens do Orcamento " + cNumOrc + " nao encontrados!", "RFAT040")
	OLE_CloseLink( hWord )
	return nil
endif

nItem := 0
nPag := 1
aItensOrc := {}
aLaco := {}
_itens := 0

Do While SCK->(!EOF()) .and. SCK->CK_FILIAL == xFilial("SCK") .and. SCK->CK_NUM == SCJ->CJ_NUM
	
	nItem++
	If nItem > 5
		aadd( aLaco, {nPag, nItem-1})
		nPag++
		nItem := 1
	endif
	
	cDescr := Posicione("SB1",1,xfilial("SB1")+SCK->CK_PRODUTO,"B1_DESC")
	nIpi   := Posicione("SB1",1,xfilial("SB1")+SCK->CK_PRODUTO,"B1_IPI")
	
	Aadd(aItensOrc, {SCK->CK_ITEM, SCK->CK_PRODUTO, cDescr, SCK->CK_QTDVEN, SCK->CK_UM,SCK->CK_PRCVEN,SCK->CK_XPRUNIT,;
	SCK->CK_VALOR, SCK->CK_ENTREG, SCK->CK_XMOEDA, nIpi,SCK->CK_XVLRINF,SCK->CK_XPISCOF,SCK->CK_XICMEST , " " })
	
	//nTotQuant += SCK->CK_QUANT
	
	_itens++
	SCK->(DbSkip())
Enddo

if nItem < 6
	aadd( aLaco, {nPag, nItem})
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gerando novo documento do Word na estacao                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
OLE_NewFile( hWord, Alltrim( cDotLocal +"\"+ cArqDot ) )

if lFecha
	OLE_SetProperty( hWord, oleWdVisible, .F. )
endif

OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(_itens++))

For nY := 1 to len(aLaco)
	
	For nX := 1 to  (nY * 5) //aLaco[nY,2]
		
		cItem    := "'cItem"      + Alltrim(str(nX)) + "'"
		cProd    := "'cProd"      + Alltrim(str(nX)) + "'"
		cDescr   := "'cDescr"     + Alltrim(str(nX)) + "'"
		cQuant   := "'cQuant"     + Alltrim(str(nX)) + "'"
		cUnid    := "'cUnid"      + Alltrim(str(nX)) + "'"
		cVlrUnit := "'cUnit"      + Alltrim(str(nX)) + "'"
		//cUnitMoe := "'cUnDolar"   + Alltrim(str(nX)) + "'"
		cTotItem := "'cTotitem"   + Alltrim(str(nX)) + "'"
		cEntrega := "'cEntrega"   + Alltrim(str(nX)) + "'"
		cLicenca := "'cLicencas"  + Alltrim(str(nX)) + "'"
		cIPI     := "'cIPI"       + Alltrim(str(nX)) + "'"
		
		If nX > len(aItensOrc)
			OLE_SetDocumentVar(hWord, &cItem   , "")
			OLE_SetDocumentVar(hWord, &cProd   , "")
			OLE_SetDocumentVar(hWord, &cDescr  , "")
			OLE_SetDocumentVar(hWord, &cQuant  , ""  )
			OLE_SetDocumentVar(hWord, &cUnid   , " " )
			OLE_SetDocumentVar(hWord, &cvlrUnit , ""  )
			//OLE_SetDocumentVar(hWord, &cUnitMoe ,  "" )
			OLE_SetDocumentVar(hWord, &cTotItem ,  ""  )
			OLE_SetDocumentVar(hWord, &cEntrega , ""  )
			OLE_SetDocumentVar(hWord, &cLicenca , ""  )
			OLE_SetDocumentVar(hWord, &cIPI , "" )
			
		Else
			nVlrUnit := IIF(aItensOrc[nX,12] > 0,aItensOrc[nX,12],aItensOrc[nX,7])
			
			OLE_SetDocumentVar(hWord, &cItem   , aItensOrc[nX,1])
			OLE_SetDocumentVar(hWord, &cProd   , aItensOrc[nX,2])
			OLE_SetDocumentVar(hWord, &cDescr  , aItensOrc[nX,3])
			OLE_SetDocumentVar(hWord, &cQuant  , transform(aItensOrc[nX,4],"@E 999,999.9999")  )
			OLE_SetDocumentVar(hWord, &cUnid   , aItensOrc[nX,5] )
			If aItensOrc[nX,10] == 1
				OLE_SetDocumentVar(hWord, &cvlrUnit , transform(nVlrUnit,"@E 999,999.999999") + space(02) + "R$ "  )
			elseIf aItensOrc[nX,10] == 2
				OLE_SetDocumentVar(hWord, &cVlrUnit , transform(nVlrUnit,"@E 999,999.999999") + space(02) + "US$" )
			else
				OLE_SetDocumentVar(hWord, &cVlrUnit , transform(nVlrUnit,"@E 999,999.999999") + space(02) + "EUR" )
			Endif
			OLE_SetDocumentVar(hWord, &cTotItem ,"PISCOF "+ transform(aItensOrc[nX,13],"@E 99.99") +" - IMCS "+ transform(aItensOrc[nX,14],"@E 99.99")   )
			//OLE_SetDocumentVar(hWord, &cTotItem , transform(aItensOrc[nX,8],"@E 99,999,999.99")  )
			OLE_SetDocumentVar(hWord, &cEntrega , aItensOrc[nX,9] )
			OLE_SetDocumentVar(hWord, &cIPI , transform(aItensOrc[nX,11],"@E 99.99") )
			
			cPolFed := Posicione("SB1",1,xfilial("SB1")+aItensOrc[nX,2],"B1_POLFED")
			cPolCiv := Posicione("SB1",1,xfilial("SB1")+aItensOrc[nX,2],"B1_POLCIV")
			cDescLic := ""
			if cPolFed == 'S' .or. cPolCiv == 'S'
				cDescLic := 'Necessario o cliente ter a(s) licenca(s): '
				if cPolFed == 'S'
					cDescLic += 'Policia Federal'
					if cPolCiv == 'S'
						cDescLic += '/Policia Civil'
					endif
				else
					cDescLic += 'Policia Civil'
				endif
			endif
			
			cObsIte := alltrim(aItensOrc[nX,12])
			
			if empty(cDescLic)
				OLE_SetDocumentVar(hWord, &cLicenca , cObsIte )
			else
				OLE_SetDocumentVar(hWord, &cLicenca , cDescLic + chr(11) + cObsIte )
				//CHR(11) simula um enter no word.
			endif
			
			/*If !empty(cDescLic)
			OLE_SetDocumentVar(hWord, &cImpLic , "S" )
			endif
			*/
		endif
		
	Next nX
	
	//OLE_ExecuteMacro(hWord,"tabitens")
	
Next nY
OLE_ExecuteMacro(hWord,"tabitens")

OLE_SetDocumentVar(hWord, 'cNum', SCJ->CJ_NUM  )
OLE_SetDocumentVar(hWord, 'dEmissao', SCJ->CJ_EMISSAO )
OLE_SetDocumentVar(hWord, 'cCliente', SCJ->CJ_CLIENTE  )
OLE_SetDocumentVar(hWord, 'cLoja', SCJ->CJ_LOJA  )
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xfilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
OLE_SetDocumentVar(hWord, 'cRazao', SA1->A1_NOME )
OLE_SetDocumentVar(hWord, 'cEndCli', SA1->A1_END )
OLE_SetDocumentVar(hWord, 'cCep', SA1->A1_CEP + ' - ' + SA1->A1_BAIRRO )
OLE_SetDocumentVar(hWord, 'cCidade', SA1->A1_MUN )
OLE_SetDocumentVar(hWord, 'cUF', SA1->A1_EST )
OLE_SetDocumentVar(hWord, 'cIE', SA1->A1_INSCR )
if !empty(SA1->A1_CGC)
	cCnpj := left(SA1->A1_CGC,2) + '.' + substr(SA1->A1_CGC,3,3) + '.' + substr(SA1->A1_CGC,6,3) +;
	'/' + substr(SA1->A1_CGC,9,4) + '-' + right(SA1->A1_CGC,2)
else
	cCnpj := space(14)
endif
OLE_SetDocumentVar(hWord, 'cCnpj', cCnpj )
OLE_SetDocumentVar(hWord, 'cEndCob', SA1->A1_ENDCOB )
OLE_SetDocumentVar(hWord, 'cCepCob', SA1->A1_CEPC + ' - '+ SA1->A1_BAIRROC )
OLE_SetDocumentVar(hWord, 'cCidCob', SA1->A1_MUNC )
OLE_SetDocumentVar(hWord, 'cUFCob', SA1->A1_ESTC )

OLE_SetDocumentVar(hWord, 'cContato', Posicione("SU5",1,xFilial("SU5") + SCJ->CJ_XCODCON,"U5_CONTAT") )
OLE_SetDocumentVar(hWord, 'cCond', SCJ->CJ_CONDPAG+" - "+Posicione("SE4",1,xfilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI") )
OLE_SetDocumentVar(hWord, 'cVend', SCJ->CJ_XVEND+" - "+Posicione("SA3",1,xfilial("SA3")+SCJ->CJ_XVEND,"A3_NOME" ) )

//CLIENTE entrega
If DbSeek(xfilial("SA1")+SCJ->CJ_XCLIENT+SCJ->CJ_XLOJENT)
	OLE_SetDocumentVar(hWord, 'cCliEntr', SA1->A1_NOME )
	OLE_SetDocumentVar(hWord, 'cEndEntr', SA1->A1_END )
	OLE_SetDocumentVar(hWord, 'cCepEntr', SA1->A1_CEP + ' - ' + SA1->A1_BAIRRO )
	OLE_SetDocumentVar(hWord, 'cCidEntr', SA1->A1_MUN )
	OLE_SetDocumentVar(hWord, 'cUFEntr', SA1->A1_EST )
	OLE_SetDocumentVar(hWord, 'cIEEntr', SA1->A1_INSCR )
	cCnpj:= Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC"))
	OLE_SetDocumentVar(hWord, 'cCnpjEntr', SA1->A1_CGC )
Else
	OLE_SetDocumentVar(hWord, 'cCliEntr', " " )
	OLE_SetDocumentVar(hWord, 'cEndEntr', " " )
	OLE_SetDocumentVar(hWord, 'cCepEntr', " " )
	OLE_SetDocumentVar(hWord, 'cCidEntr', " " )
	OLE_SetDocumentVar(hWord, 'cUFEntr', " " )
	OLE_SetDocumentVar(hWord, 'cIEEntr', " " )
	OLE_SetDocumentVar(hWord, 'cCnpjEntr', " " )
Endif

aTPFrete := RetSx3Box( Posicione('SX3', 2, 'CJ_XTPFRET', 'X3CBox()' ),,, Len(SCJ->CJ_XTPFRET))
cFrete := Upper( AllTrim( aTPFrete[  Ascan( aTPFrete , { |x| x[2] == SCJ->CJ_XTPFRET } ), 3 ]))

OLE_SetDocumentVar(hWord, 'cFrete', cFrete )
OLE_SetDocumentVar(hWord, 'cOperador', " " )
OLE_SetDocumentVar(hWord, 'cTransport',POSICIONE("SA4",1,xFilial( "SA4" ) +SCJ->CJ_XTRANSP,"A4_NOME") )
OLE_SetDocumentVar(hWord, 'dValidade', DTOC(SCJ->CJ_VALIDA)  )

OLE_SetDocumentVar(hWord, 'cObsOrc', ALLTRIM(SCJ->CJ_XOBSFAT))
OLE_SetDocumentVar(hWord, 'cVendInt', ' ' )  //Posicione("SA3",1,xfilial("SA3")+SUA->UA_VENDINT,"A3_NOME" ) )
OLE_SetDocumentVar(hWord,Posicione("SA3",1,xfilial("SA3")+SCJ->CJ_XVEND,"A3_TEL" ) )
OLE_SetDocumentVar(hWord,Posicione("SA3",1,xfilial("SA3")+SCJ->CJ_XVEND,"A3_EMAIL") )
OLE_SetDocumentVar(hWord, 'cFoneVend', Posicione("SA3",1,xfilial("SA3")+SCJ->CJ_XVEND,"A3_TEL" ) )
OLE_SetDocumentVar(hWord, 'cEmailVend',Posicione("SA3",1,xfilial("SA3")+SCJ->CJ_XVEND,"A3_EMAIL") )

OLE_UpdateFields(hWord)

//If nY == len(aLaco)

cSaveFile := 'Orcamento' + SCJ->CJ_NUM + ".doc"

If File(cAnexLoc+"\"+ cSaveFile)
	FErase(cAnexLoc+"\"+ cSaveFile)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva o arquivo no disco rigido                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
OLE_SaveAsFile(hWord, cAnexLoc+"\"+ cSaveFile )
Sleep(1000)// Espera 2 segundos pra dar tempo de imprimir.

OLE_SetProperty( hWord, oleWdVisible, !lFecha )

//transforma em pdf para depois enviar por email
cSavePDF   := "Orc-" + cNumOrc+"-"+cNomeF+ ".pdf"
GravaFile("c:\temp\",cSavePDF)


if lFecha
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
endif

//Endif

// Next nY

RestArea(_aArea)
Return()


Static Function GravaFile(DIR_RAIZ,cSavePDF)

MakeDir(DIR_RAIZ)

If File(DIR_RAIZ+"\makeorc.pdf")
	FErase(DIR_RAIZ+"\makeorc.pdf")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva o arquivo em arquivo do disco rigido para envio do email        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//   Quem executa a gravacao do arquivo ้ a macro abaixo.
OLE_ExecuteMacro(hWord, "vartypepdf" )

Sleep(1000)

If File(DIR_RAIZ+"\makeorc.pdf")
	__copyfile(DIR_RAIZ+"\makeorc.pdf","c:\temp\"+cSavePDF)
	//CpyT2S("c:\temp\"+cSavePDF,DIR_RAIZ,.T.)
Else
	MsgStop("Arquivo nao encontrado -> " + DIR_RAIZ+"\makeorc.pdf")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TMKR3A   บ Autor ณ Giane - ADV Brasil บ Data ณ  28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para imprimir orcamento com layout especi บฑฑ
ฑฑบ          ณ fico da makeni                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico MAKENI / televendas/orcamento                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPORCMK(cNumOrc)

If MsgYesNo("Imprimir Orcamento "+cNumOrc+" ?")
	MsgRun("Imprimindo or็amento no word, aguarde...","",{|| U_RFAT040(cNumOrc) })
Endif
Return
