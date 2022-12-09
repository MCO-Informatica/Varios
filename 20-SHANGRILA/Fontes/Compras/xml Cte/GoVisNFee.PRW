#include "Protheus.ch"
#include "Font.CH"
#include "colors.ch"
#INCLUDE "AvPrint.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "ap5mail.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GOVISNFEE ºAutor  ³Francisco C Godinho º Data ³  20/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza Status NFE - Via Xml                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User FuncTion GOVISNFEE()
Private oOk       := LoadBitmap( GetResources(), "CHECKED" )
Private oNo       := LoadBitmap( GetResources(), "UNCHECKED" )
Private oVerde    := LoadBitmap(GetResources(),"BR_VERDE")
Private oVermelho := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oAzul     := LoadBitmap(GetResources(),"BR_AZUL")
Private oDlg
Private oLbx
Private oList
Private oFnt1
Private oPrn
Private cLine     := ""
Private bMyLine
Private cCadastro  := "Verificacao Status NFE - Xml"
Private cAlias := "ZZS"
Private errStr  := ""
Private warnStr := ""
Private lChkSefaz := SuperGetMv("GO_CHKSEFA",.T.,.F.)

PRIVATE n	       := 1
PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
Static __nVez := 0


PRIVATE aRotina := MenuDef()

// 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geração pré-nota"
aCores := {	{"ZZS->ZZS_STATUS == '0'", "BR_AZUL"}       , {"ZZS->ZZS_STATUS == '1'" , "BR_LARANJA"}  ,;
				{"ZZS->ZZS_STATUS == '2'", "BR_PRETO"}  , {"ZZS->ZZS_STATUS == '3'" , "BR_VERMELHO"} ,;
				{"ZZS->ZZS_STATUS == '4'", "BR_MARROM"} , {"ZZS->ZZS_STATUS == '5'" , "BR_AMARELO"}  ,;
				{"ZZS->ZZS_STATUS == '6'", "BR_VERDE"}  , {"ZZS->ZZS_STATUS == '7'" , "BR_CINZA"}    ,;
				{"ZZS->ZZS_STATUS == '8'" ,"BR_PINK"}   , {"ZZS->ZZS_STATUS == '9'" , "BR_BRANCO"}}
/*
BrwLegenda(cCadastro, "Legenda", {	{"BR_AZUL"    , " 0 - Inclusao" } ,;
{"BR_LARANJA" , "1 - Pre-Validado"} ,;
{"BR_PRETO"   , "2 - Status Sefaz"} ,;
{"BR_VERMELHO", "3 - Estrutura Xml"} ,;
{"BR_MARROM"  , "4 - Depara"} ,;
{"BR_AMARELO" , "5 - Bloqueio Cadastro"} ,;
{"BR_VERDE"   , "6 - Gerado"} ,;
{"BR_CINZA"   , "7 - Problema na Geração pré-nota"},;
{"BR_BRANCO"  , "8 - NF Origem ja lançada "},;
{"BR_PINK"    , "9 - Xml CT-e de Compra"} } )
*/   
cFiltro := ""
aPergs := {}
cPerg := "GOVISNFEE1"

Aadd(aPergs,{"1=CT-e,2=NF-e","",""	,"mv_cha","N",1,0,0,"C","","MV_PAR01","CT-e","","","","","NF-e","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(cPerg, aPergs)
If ! Pergunte(cPerg,.T.)
	Return
EndIf	
           
If MV_PAR01 <> 3
	If MV_PAR01 == 1
		cCadastro := "CT-e"
		cFiltro := "ZZS_FILIAL = '"+xFilial("ZZS")+"' and ZZS_ESPECI = 'CTE' "
	Else
		cCadastro := "NF-e"
		cFiltro := "ZZS_FILIAL = '"+xFilial("ZZS")+"' and ZZS_ESPECI = 'SPED' "
	EndIf
EndIf
ZZS->(dbSetOrder(1))
mBrowse( 6, 1,22,75,"ZZS",,,,,,aCores,,,,,,,,cFiltro)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CPCTRVIS  ºAutor  ³Francisco C Godinho º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualiza Historio do XML                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion CPCTRVIS()
Local aListBox := {}
Local oDlgRet
Local oList
Local oRadio
Local oBold
Local oBmp
Local oBut1
Local oBut2

_cChave := ZZS->ZZS_CHAVE

DbSelectArea("ZZT")
DbSetOrder(2)
DbSeek(xFilial("ZZT") + _cChave )
While ! Eof() .And. ZZT->ZZT_FILIAL + ZZT->ZZT_CHAVE == xFilial("ZZS") + _cChave
	
	AAdd( aListBox, { ZZT->ZZT_DTHORA, ZZT->ZZT_OCORRE } )
	
	DbSkip()
EndDo
If Len(aListBox) > 0
	ASort( aListBox, , , { |x,y| y[1]+y[2] > x[1]+x[2] } )
	
	DEFINE MSDIALOG oDlgRet TITLE "Ocorrencias " FROM 09,0 TO 33.8,60 OF oMainWnd //
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgRet SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
	@ 03, 40 SAY "Chave: " + _cChave FONT oBold PIXEL
	
	@ 14, 30 TO 16 ,400 LABEL '' OF oDlgRet   PIXEL
	
	oListH := TWBrowse():New( 30, 38, 190, 126,,{ "Data", "Ocorrencia" },,oDlgRet,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	
	oListH:SetArray(aListBox)
	oListH:bLine := { || { aListBox[oListH:nAT,1], aListBox[oListH:nAT,2] } }
	
	//	DEFINE SBUTTON oBut1 FROM 168, 169 TYPE 1 ACTION ( nOpca := 1, oDlgRet:End() )  ENABLE of oDlgRet
	DEFINE SBUTTON oBut2 FROM 168, 202 TYPE 2 ACTION ( nOpca := 0, oDlgRet:End() )  ENABLE of oDlgRet
	
	
	ACTIVATE MSDIALOG oDlgRet CENTERED
	
Else
	Alert("Nenhuma ocorrencia foi encontrada...")
EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CPNfeLeg  ºAutor  ³Francisco C Godinho º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Legenda do Status                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CPNfeLeg()

BrwLegenda(cCadastro, "Legenda", {	{"BR_AZUL"    , " 0 - Inclusao" } ,;
{"BR_LARANJA" , "1 - Pre-Validado"} ,;
{"BR_PRETO"   , "2 - Status Sefaz"} ,;
{"BR_VERMELHO", "3 - Estrutura Xml"} ,;
{"BR_MARROM"  , "4 - Depara"} ,;
{"BR_AMARELO" , "5 - Bloqueio Cadastro"} ,;
{"BR_VERDE"   , "6 - Gerado"} ,;
{"BR_CINZA"   , "7 - Erro na Geração Nota"},;
{"BR_PINK"    , "8 - NF Origem ja lançada "},;
{"BR_BRANCO"  , "9 - Xml CT-e de Compra"} } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Francisco C Godinho º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Menu                                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
PRIVATE aRotina	:= {}

aRotina		:= {{ OemToAnsi("Pesquisar")    	 , "AxPesqui"           , 0 , 1},;
				{ OemToAnsi("Visualiza")         , "AxVisual"      	   , 0 , 2},;
				{ OemToAnsi("Consulta Resumida") , "U_VISCTE"      	   , 0 , 2},;
				{ OemToAnsi("Visualiza Danfe")   , "U_XOleContainer()"  , 0 , 2},;
				{ OemToAnsi("Pesq. SEFAZ")       , "U_VldXml()"    	   , 0 , 2},;
				{ OemToAnsi("Baixar E-Mail")     , "U_RECEMAIL()"  	   , 0 , 3},;
				{ OemToAnsi("Gera CTE")          , "U_USCHNCTE({"+cEmpAnt+","+cFilAnt+",.F.})"  	, 0 , 3},;
				{ OemToAnsi("Muda Status")       , "U_MudaSta()"  	, 0 , 4},;
				{ OemToAnsi("Historico")         , "U_CPCTRVIS(1)"  	, 0 , 2},;
				{ OemToAnsi("Importa Xml Manual"), "U_CPIMPXML()"  	, 0 , 3},;
				{"Legenda"                       , "U_CPNfeLeg()"   	, 0, 2}  }

//				{ OemToAnsi("Visualiza Danfe")  , "U_TSTDBIMG()"  , 0 , 2},;
// 				{ OemToAnsi("Libera Schedule") , "U_CPLIBSCH()"  	, 0 , 3},;				
Return( aRotina )

User FuncTion CPLIBSCH()
// 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geração pré-nota"
DbSelectArea("ZZS")

If ! ZZS->ZZS_STATUS $ "0,6"
	RecLock("ZZS",.F.)
		ZZS->ZZS_STATUS := "0"
	MsUnlock()
Else	
   Alert("Status do Xml nao permite liberacao...")
EndIf
Return


User FuncTion VldF1Xml()
Local lRet := .T.

If lRet
	
	If Alltrim(Upper(FunName()) ) == "CPVISNFEE"
		If Type("_cXml") <> "U"
			If !Empty(_cXml)
				DDEMISSAO := __xDtXml
				CNFISCAL := Substr(_cXml,26,9)
				//CSERIE   := Substr(cXml,25,1)
//				CSERIE   := Alltrim(Str(Val(Substr(_cXml,23,3)),3,0))
				CSERIE   := Alltrim(Str(Val(Substr(_cXml,23,3)),3,0))+Space(2)
				CSERIE   := Substr(CSERIE,1,3)
				CSERIE   := If(Val(CSERIE) <> 0, CSERIE,"   ")
				CESPECIE := "SPED"
				
				_cCnpj   := Substr(_cXml,7,14)
				
				DbSelectArea("SA2")
				DbSetOrder(3)
				If DbSeek(xFilial("SA2") + _cCnpj )
					If SA2->A2_MSBLQL <> "1"
						CA100FOR := SA2->A2_COD
						CLOJA    := SA2->A2_LOJA
						CUFORIG  := SA2->A2_EST
						C103TIPO := "N"
					Else
						Alert("Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+" Bloqueado...")
						Return(.F.)
					EndIf
				EndIf
				SA2->(DbSetOrder(1))
			EndIf
		EndIf
	EndIf
EndIf
Return(lRet)


Static Function ChkNFeChave(cXml)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local _lRet := .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIdEnt := GetIdEnt()

cChaveNFe := Alltrim(cXml)

oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT      := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += "Versão da mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf                
	cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //###"Homologação"
	cMensagem += "Cod.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += "Msg.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	cRetorno := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF	
	EndIf
	Aviso("Consulta NF",cMensagem,{"OK"},3)
	If ! Alltrim(cRetorno) $ '100|678'
///		If Alltrim(cRetorno) == '226'
//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno+" Nota fiscal esta inutilizada na base da dados do Sefaz.",{"Atenção"},3)
//		Else
//			Aviso("Consulta NF","Status Sefaz -> "+cRetorno,{"Atenção"},3)
//		EndIf
		_lRet := .F.
	EndIf

Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
	_lRet := .F.
EndIf
	
Return(_lRet)


Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://10.0.0.105:80"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Atenção"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)


User FuncTion VldXml()
Local lRet := .T.
Local nOpca:= 0
Private lChkSefaz := SuperGetMv("GO_CHKSEFA",.T.,.F.)
Private oDlgXml

cXml := Space(44)

aPedC := {}
nOpca := 0


DEFINE DIALOG oDlgXml Of GetWndDefault() FROM  12, 20 TO 16,75 TITLE "Passe o Leitor Codigo de Barras da DANFE"

@ .1,.5 MSGET cXml  VALID  !EmpTy(cXml)
DEFINE SBUTTON FROM 15,165 TYPE 1 ENABLE OF oDlgXml;
ACTION  oDlgXml:End()

ACTIVATE MSDIALOG oDlgXml CENTERED


DbSelectArea("ZZS")
DbSetOrder(1)
IF DbSeek(xFilial("ZZS") + cXml )
	
//	IF lChkSefaz
		lRet := ChkNFeChave(cXml)
		If lRet
			_cStatus := "1" // Pre-validado
		Else
			_cStatus := "2" // Problema Sefaz
		EndIf
		RecLock("ZZS",.F.)
		ZZS->ZZS_STATUS := _cStatus
		MsUnlock()
//	EndIf
Else
	msgalert("Xml Nâo ENCONTRADO!","Alerta")
	lRet := .F.
EndIf

Return(lRet)


User FuncTion CPIMPXML()   

MsAguarde({|| x_ImpXml()},"Importando XML ...")

Alert("Importacao finalizada...")

Return
// Copiado novo 


Static FuncTion x_ImpXml()

Private a_Xml := {}  
Private CDIRERRO  := ""
_cFilial := cFilAnt
nMesAte := Month(dDatabase) - 1
_lTudo :=  .T.  // MsgYesNo("Processa apenas o mes corrente ?","Confirma.")///#
//cPathXml := SuperGetMv("AG_PCTXML",,"\xml_cte\")
cPathXml    := cGetFile("Diretorio |*.*|Todos os Diretorios|*.*",OemToAnsi("Diretorio Arquivos XML ..."),,,.T.,GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )

cDirXml :=cPathXml
aXML := Directory(cDirXml+"*.XML")
For nX := 1 to Len(aXML)
	// IncProc("Processando Filial: "+_cFilial+" - Mes: "+cMes)
	lProcessou := .F.
	cXMLFile := cDirXml+aXML[nX][1]
	xGrvZZS(cXMLFile,_cFilial,cDirXml)
Next
If Len(a_Xml) > 0
	AIMSGENV(a_Xml)  
EndIf
Return()

/**************************************/
Static FuncTion xGrvZZS(cXMLFile,_cFil,cDirXml)
/**************************************/
Local lRetorno := .T.
Local nX       := 0
Local oRetorno
Local oXML
Local cError := ""
Local cWarning := ""
Local errStr := ""
Local warnStr := ""

//conout("Parametros  <cXMLFile>: "+cXMLFile)

aGlobalStack := {}

cXML := MEMOREAD( cXMLFile )

oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

cNewArq   :=  Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))
cChaveNfe := Substr(cNewArq,4,45)
cDirErro  := cDirXml+"invalidos\"
cDirOk    := cDirXml+"processados\"

MakeDir(cDirErro)
MakeDir(cDirOk)

//conout("Dir OK : "+cDirOk)
//conout("Dir Erro: "+cDirErro)
//conout("Arquivo: "+cXMLFile)

// Checa Integridade do xml ctrc e a existencia das tags a serem lidas
cTag1 := "<cteProc"
cTag2 := "<CTe"
cTag3 := "<infCte"
cTag5 := "<infNF"
nPosTag1 := At(cTag1,cXML)
nPosTag2 := At(cTag2,cXML)
nPosTag3 := At(cTag3,cXML)
nPosTag5 := At(cTag5,cXML)
lCteproc := .F.

// NFE
cNfeTag1 := "<nfeProc"
cNfeTag2 := "<NFe"
cNfeTag3 := "CNPJ"
cNfeTag4 := "<dEmi"
cNfeTag5 := "<protNFe"
nPosNfe1 := At(cNfeTag1,cXML)
nPosNfe2 := At(cNfeTag2,cXML)
nPosNfe3 := At(cNfeTag3,cXML)
nPosNfe4 := At(cNfeTag4,cXML)
nPosNfe5 := At(cNfeTag5,cXML)
l_Nfe := .F.
If nPosNfe1 > 0 .And. nPosNfe5 > 0 .And. nPosNfe2 > 0
	l_Nfe := .T.
EndIf

If  l_Nfe
	// NF-e
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Le as Tags necessarias para a tabela SZX  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//<dhEmi>2018-06-29T00:00:00-03:00</dhEmi>
	dEmissao   := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
	nDia    := Substr(dEmissao,9,2) // RAt("-",dEmissao)+1,2)
	nMes    := Substr(dEmissao,6,2) // At("-",dEmissao)+1,2)
	nAno    := Substr(dEmissao,1,4) // ,At("-",dEmissao)-1)
							
	dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
	If  '38908778000176' $ oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
		// Nfe de saida
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)
		Return .F.
	EndIf
	c_DestCNPJ   := oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	lNota := .F.
	_cNotaXml := "2"
							
	l_SM0 := .F.
							
	dbSelectArea("SM0")
	nRegSM0 := SM0->(Recno())
	dbSetOrder(1)
	SM0->(DbGoTop())
	While SM0->(!Eof())
		If c_DestCNPJ == SM0->M0_CGC // Se Destino do Frete for Golden frete s/ Compra
			l_SM0 := .T.
			_cEmp := SM0->M0_CODIGO
			_cFil := SM0->M0_CODFIL
			Exit
		// aAdd(aSM0,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_CGC})
		EndIf
		SM0->(dbSkip())
	Enddo
	SM0->(DbGoTo(nRegSM0))
	l_SM0 := .T.
	If  ! l_SM0
		aadd(a_Xml,cChaveNfe+ " - CNPJ Destinatario nao e a Shangrila" )
								
		__CopyFile(cXMLFile,cDirErro+cNewArq)
								
		Ferase(cXMLFile)
		Return .F.
	EndIf
							
	cCnpj       := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	cCnpj    := StrTran(cCnpj,'.','')
	cCnpj    := StrTran(cCnpj,'/','')
	cCnpj    := StrTran(cCnpj,'-','')
	cCliFor  := "S"
	cCodCF   := ""
	cLoj     := ""
	_CtipoNF := "N"
	cStatus  := "X"
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2") + cCnpj )
		cCliFor := "F"
		cCodCF  := SA2->A2_COD
		cLoj    := SA2->A2_LOJA
		_CtipoNF := "N"
		If SA2->A2_MSBLQL == "1"
			cStatus := "5"
		EndIf
		//	_cNotaXml := Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XXML")
		//	_cTes     := Posicione("SA2",1,xFilial("SA2")+cCodCF+cLoj,"A2_XTES")
		// Verifica se gera Nota fiscal
		If _cNotaXml == "1"  // 1=Sim 2-Nao
			lNota := .T.
		EndIf
	Else
		cStatus := "9"
	EndIf
	cChave  := oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	cChave  := StrTran(cChave,'-','')
	cChave  := StrTran(cChave,'.','')
	cChave  := StrTran(cChave,'/','')+Space(10)
	cChave  := Substr(cChave,1,45)
						
	CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
	cDoc     := Substr(cChave,26,9)
	conout("Chave NFE: "+cChave)
							
							// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota
	DbSelectArea("ZZS")
	DbSetOrder(1)
	IF ! DbSeek(xFilial("ZZS")+ cChave )
		Reclock("ZZS",.T.)
		ZZS->ZZS_FILIAL := xFilial("ZZS")
		ZZS->ZZS_CHAVE  := cChave
		ZZS->ZZS_CGC    := cCnpj
		ZZS->ZZS_EMISSA := dEmissao
	//	cDoc     := Substr(SZX->ZX_CHAVE,26,9)
	//	cDoc     := Right(cDoc,6)
		ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
		ZZS->ZZS_SERIE  := CSERIE
		ZZS->ZZS_XML     := cXML
		ZZS->ZZS_STATUS := "0"
		ZZS->ZZS_ESPECI := "SPED"
		ZZS->ZZS_CLIFOR  := cCodCF
		ZZS->ZZS_LOJA    := cLoj
		MsUnlock()
		//	_nPosIniICM	:=At("<pICMS",cXML)
		//	_nPosFimICM :=At("</pICMS",cXML)
		//	_nPosIniICM += 7
		//	nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
		l_GrvZZS := .T.
		DbSelectArea("ZZT")
		RecLock("ZZT",.T.)
			ZZT->ZZT_FILIAL := xFilial("ZZT")
			ZZT->ZZT_CHAVE  := cChave
			ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
			ZZT->ZZT_CLIFOR := cCodCF
			ZZT->ZZT_LOJA   := cLoj
			ZZT->ZZT_OCORRE := "Carga Inicial.  NF-e"
		MsUnlock()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Copia o arquivo para a pasta processados e apaga arquivo lido      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		__CopyFile(cXMLFile,cDirOk+cNewArq)
		Ferase(cXMLFile)
	EndIf
Else
	// CT-e
	If nPosTag1 > 0                       
		lCteproc := .T.
	EndIf
	l_Ok := .T.
	xx := "XX"           // Ponto de parada debug
	If (nPosTag1 = 0 .And. nPosTag3 = 0 ) .Or. nPosTag2 = 0  // .Or. nPosTag5 = 0 // .Or. nPosTag6 = 0
		l_Ok := .F.
		DbSelectArea("ZZT")
		RecLock("ZZT",.T.)
		ZZT->ZZT_FILIAL := xFilial("ZZT")
		ZZT->ZZT_CHAVE  := cChaveNfe
		ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
		ZZT->ZZT_CLIFOR := ""
		ZZT->ZZT_LOJA   := ""
		ZZT->ZZT_OCORRE := "Erro de estrutura. XML nao e < CTE > "
		MsUnlock()
		aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
		
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)
	EndIf
	
	If oXml == NIL .or. !Empty(errStr) .or. !Empty(warnStr)
		l_Ok := .F.
		DbSelectArea("ZZT")
		RecLock("ZZT",.T.)
		ZZT->ZZT_FILIAL := xFilial("ZZT")
		ZZT->ZZT_CHAVE  := cChaveNfe
		ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
		ZZT->ZZT_CLIFOR := ""
		ZZT->ZZT_LOJA   := ""
		ZZT->ZZT_OCORRE := "Não foi possivel ler XML. Erro: "+errStr
		MsUnlock()
		aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		
		Ferase(cXMLFile)
	EndIf
	If ! l_Ok
		Return .F.
	EndIf
	
	// CREATE oXML XMLFILE cXMLFile
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Le as Tags necessarias para a tabela SZX  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xx:= "1"
	If lCteproc
		cChave  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
		oDest   :=oXML:_CTEPROC:_CTE:_INFCTE:_DEST
		c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
		If Type("oDest:_CPF") <> "U"
			c_DestCNPJ := oDest:_CPF:TEXT
		Else
			c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
		EndIf
		dEmissao   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
		//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
		nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
		nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
		nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
		
	Else
		cChave  := oXml:_CTE:_INFCTE:_ID:TEXT
		cChave  := Substr(cChave,4,45)
		oDest   := oXML:_CTE:_INFCTE:_DEST
		If Type("oDest:_CPF") <> "U"
			c_DestCNPJ := oDest:_CPF:TEXT
		Else
			c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
		EndIf
		c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
		dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
		nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
		nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
		nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	EndIf
	cChave  := StrTran(cChave,'-','')
	cChave  := StrTran(cChave,'.','')
	cChave  := StrTran(cChave,'/','')+Space(10)
	cChave  := Substr(cChave,1,45)
	
	dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))
	
	If lCteproc
		cCnpj := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	Else
		cCnpj := oXml:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	EndIf
	// Tag do XML: toma3 -> toma
	//	Indicador do "papel" do tomador do serviço no CT-e.
	//	0-Remetente;
	//	1-Expedidor;
	//	2-Recebedor;
	//	3-Destinatário.
	l_toma3 := .F.
	/*
	If Type("oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA") <> "U"
		l_toma3 := .T.
		c_Toma := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
		If c_Toma == "0"	// Remetente
			c_Tomador := c_RemCNPJ
		ElseIf c_Toma == "1"// Expedidor
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ") <> "U"
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT
			Else
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CPF:TEXT
			EndIf
		ElseIf c_Toma == "2" // Recebedor
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT
			Else
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CPF:TEXT
			EndIf
		ElseIf c_Toma == "3"  // Destinatario
			If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
			Else
				c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT
			EndIf
		EndIf
	EndIf
	*/
	cCnpj    := StrTran(cCnpj,'.','')
	cCnpj    := StrTran(cCnpj,'/','')
	cCnpj    := StrTran(cCnpj,'-','')
	cCliFor  := "S"
	cCodCF   := ""
	cLoj     := ""
	a_Cnpj    := {}
	l_Agro    := .F.
	l_Entrada := .F.
	l_Saida   := .F.
	l_Tomador := .F.
	dbSelectArea("SM0")
	nRegSM0 := SM0->(Recno())
	dbSetOrder(1)
	SM0->(DbGoTop())
	While SM0->(!Eof())
		If c_RemCNPJ == SM0->M0_CGC
			l_Agro  := .T.
			aadd(a_Cnpj,{SM0->M0_CODFIL,"R"})
		EndIf
		If c_DestCNPJ == SM0->M0_CGC
			l_Agro  := .T.
			aadd(a_Cnpj,{SM0->M0_CODFIL,"D"})
		EndIf
	//	If c_Tomador ==  SM0->M0_CGC
	//		l_Tomador := .T.
	//	EndIf
		SM0->(dbSkip())
	Enddo
	SM0->(DbGoTo(nRegSM0))
	/*
	If ! l_Tomador .And. l_toma3
		aadd(a_Xml,cChaveNfe+ " - Tomador é a Agrozootec" )
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		Ferase(cXMLFile)
		Return .F.
	EndIf
	*/
	If Len(a_Cnpj) > 1
		for i = 1 to len(a_Cnpj)
			// Pega filial do remetente
			if a_Cnpj[i][2] == "R"
				_cFil := a_Cnpj[i][1]
			endif
		next
	EndIf
	
	If  ! l_Agro //  ! l_Entrada .And. !l_Saida
		aadd(a_Xml,cChaveNfe+ " - CNPJ Remetente/Destinatario nao e da Agrozootec" )
		
		__CopyFile(cXMLFile,cDirErro+cNewArq)
		
		Ferase(cXMLFile)
		Return .F.
	EndIf
	cStatus := "0"
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2") + cCnpj )
		cCliFor := "F"
		cCodCF  := SA2->A2_COD
		cLoj    := SA2->A2_LOJA
		If SA2->A2_MSBLQL == "1"
			cStatus := "5"
			aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " Bloqueado no Cadastro de Fornecedor." )
		EndIf
	Else
		aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " nao encontrado no Cadastro de Fornecedor." )
		cStatus := "5"
	EndIf
	CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
	cDoc     := Substr(cChave,26,9)
	// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota  8= Regra ZZQ/ZZP nao localizada
	DbSelectArea("ZZS")
	DbSetOrder(1)
	IF  DbSeek(_cFil + cChave )
		Reclock("ZZS",.F.)
		ZZS->ZZS_CGC     := cCnpj
		ZZS->ZZS_EMISSA  := dEmissao
		ZZS->ZZS_DOC     := StrZero(Val(cDoc),9)
		ZZS->ZZS_SERIE   := CSERIE
		ZZS->ZZS_CLIFOR  := cCodCF
		ZZS->ZZS_LOJA    := cLoj
		ZZS->ZZS_XML     := cXML
		ZZS->ZZS_STATUS  := cStatus
		ZZS->ZZS_ESPECI  := "CTE"
		MsUnlock()
	Else
		Reclock("ZZS",.T.)
		ZZS->ZZS_FILIAL := _cFil
		ZZS->ZZS_CHAVE  := cChave
		ZZS->ZZS_CGC    := cCnpj
		ZZS->ZZS_EMISSA := dEmissao
		ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
		ZZS->ZZS_SERIE  := CSERIE
		ZZS->ZZS_XML     := cXML
		ZZS->ZZS_STATUS := cStatus
		ZZS->ZZS_ESPECI := "CTE"
		MsUnlock()
		
		DbSelectArea("ZZT")
		RecLock("ZZT",.T.)
		ZZT->ZZT_FILIAL := _cFil
		ZZT->ZZT_CHAVE  := cChave
		ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
		ZZT->ZZT_CLIFOR := cCodCF
		ZZT->ZZT_LOJA   := cLoj
		ZZT->ZZT_OCORRE := "Carga Inicial. "
		MsUnlock()
		
	EndIf
	_nPosIniICM	:=At("<pICMS",cXML)
	_nPosFimICM :=At("</pICMS",cXML)
	_nPosIniICM += 7
	nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Copia o arquivo para a pasta processados e apaga arquivo lido      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	__CopyFile(cXMLFile,cDirOk+cNewArq)
	Ferase(cXMLFile)
	//conout("Retorno do Erase: "+Str(Ferror(),10))
EndIf
oXml := Nil
DelClassIntf()

Return






             
Static FuncTion wx_ImpXml()

Private a_Xml := {}  
Private CDIRERRO  := ""
_cFilial := cFilAnt
nMesAte := Month(dDatabase) - 1
_lTudo :=  .T.  // MsgYesNo("Processa apenas o mes corrente ?","Confirma.")///#
// cPathXml := SuperGetMv("AG_PCTXML",,"\xml_cte\")
// cPathXml	:= cGetFile("*.xml"              ,"XML File",1,"C:\",.T.,GETF_LOCALHARD,.F.,.T.)    
// cPathXml := cGetFile( '*.xml|*.XML FILE'  ,'XML File', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
cPathXml    := cGetFile("Diretorio |*.*|Todos os Diretorios|*.*",OemToAnsi("Diretorio Arquivos XML ..."),,,.T.,GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )

cDirXml :=cPathXml
aXML := Directory(cDirXml+"*.XML")
For nX := 1 to Len(aXML)
	// IncProc("Processando Filial: "+_cFilial+" - Mes: "+cMes)
	lProcessou := .F.
	cXMLFile := cDirXml+aXML[nX][1]
	xGrvZZS(cXMLFile,_cFilial,cDirXml)
Next
If Len(a_Xml) > 0
	AIMSGENV(a_Xml)  
EndIf
Return()

/**************************************/
Static FuncTion wxGrvZZS(cXMLFile,_cFil,cDirXml)
/**************************************/
Local lRetorno := .T.
Local nX       := 0
Local oRetorno
Local oXML
Local cError := ""
Local cWarning := ""
Local errStr := ""
Local warnStr := ""

//conout("Parametros  <cXMLFile>: "+cXMLFile)

aGlobalStack := {}

cXML := MEMOREAD( cXMLFile )

oXml := XmlParser ( cXML, "_", @errStr, @warnStr )

cNewArq   :=  Substr(cXMLFile,Rat("\",cXMLFile)+1,Len(Alltrim(cXMLFile)))
cChaveNfe := Substr(cNewArq,4,45)
cDirErro  := cDirXml+"invalidos\"
cDirOk    := cDirXml+"processados\"

MakeDir(cDirErro)
MakeDir(cDirOk)

//conout("Dir OK : "+cDirOk)
//conout("Dir Erro: "+cDirErro)
//conout("Arquivo: "+cXMLFile)

// Checa Integridade do xml ctrc e a existencia das tags a serem lidas
cTag1 := "<cteProc"
cTag2 := "<CTe"
cTag3 := "<infCte"
cTag5 := "<infNF"
nPosTag1 := At(cTag1,cXML)
nPosTag2 := At(cTag2,cXML)
nPosTag3 := At(cTag3,cXML)
nPosTag5 := At(cTag5,cXML)
lCteproc := .F.
If nPosTag1 > 0                       
	lCteproc := .T.
EndIf
l_Ok := .T.
xx := "XX"           // Ponto de parada debug
If (nPosTag1 = 0 .And. nPosTag3 = 0 ) .Or. nPosTag2 = 0  // .Or. nPosTag5 = 0 // .Or. nPosTag6 = 0
	l_Ok := .F.
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := xFilial("ZZT")
	ZZT->ZZT_CHAVE  := cChaveNfe
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := ""
	ZZT->ZZT_LOJA   := ""
	ZZT->ZZT_OCORRE := "Erro de estrutura. XML nao e < CTE > "
	MsUnlock()
	aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
	
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	Ferase(cXMLFile)
EndIf

If oXml == NIL .or. !Empty(errStr) .or. !Empty(warnStr)
	l_Ok := .F.
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := xFilial("ZZT")
	ZZT->ZZT_CHAVE  := cChaveNfe
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := ""
	ZZT->ZZT_LOJA   := ""
	ZZT->ZZT_OCORRE := "Não foi possivel ler XML. Erro: "+errStr
	MsUnlock()
	aadd(a_Xml,cChaveNfe+ " - " + ZZT->ZZT_OCORRE )
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	
	Ferase(cXMLFile)
EndIf
If ! l_Ok
	Return .F.
EndIf

// CREATE oXML XMLFILE cXMLFile

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le as Tags necessarias para a tabela SZX  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xx:= "1"
If lCteproc
	cChave  := oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	oDest   := oXML:_CTEPROC:_CTE:_INFCTE:_DEST
	c_RemCNPJ  := oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	If Type("oDest:_CPF") <> "U"
		c_DestCNPJ := oDest:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	dEmissao   := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	//	nMes    := Substr(dEmissao,RAt("-",dEmissao)+1,RAt("-",dEmissao) - At("-",dEmissao) -1)
	nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
	nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
	nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
	
Else
	cChave  := oXml:_CTE:_INFCTE:_ID:TEXT
	cChave  := Substr(cChave,4,45)
	oDest   := oXML:_CTE:_INFCTE:_DEST
	If Type("oDest:_CPF") <> "U"
		c_DestCNPJ := oDest:_CPF:TEXT
	Else
		c_DestCNPJ := oXML:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	EndIf
	c_RemCNPJ  := oXML:_CTE:_INFCTE:_REM:_CNPJ:TEXT
	dEmissao   := oXml:_CTE:_INFCTE:_IDE:_DHEMI:TEXT
	nMes    := Substr(dEmissao,At("-",dEmissao)+1,2)
	nDia    := Substr(dEmissao,RAt("-",dEmissao)+1,2)
	nAno    := Substr(dEmissao,1,At("-",dEmissao)-1)
EndIf
cChave  := StrTran(cChave,'-','')
cChave  := StrTran(cChave,'.','')
cChave  := StrTran(cChave,'/','')+Space(10)
cChave  := Substr(cChave,1,45)

dEmissao:= Ctod(StrZero(Val(nDia),2)+"/"+StrZero(Val(nMes),2)+"/"+StrZero(Val(nAno),4))

If lCteproc
	cCnpj := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
Else
	cCnpj := oXml:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
EndIf
// Tag do XML: toma3 -> toma
//	Indicador do "papel" do tomador do serviço no CT-e.
//	0-Remetente;
//	1-Expedidor;
//	2-Recebedor;
//	3-Destinatário.
l_toma3 := .F.
c_Tomador := ""

//If Type("oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA") <> "U"
//If Type("oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3") <> "U"
	l_toma3 := .T.
	c_Toma := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT
	If c_Toma == "0"	// Remetente
		c_Tomador := c_RemCNPJ
	ElseIf c_Toma == "1"// Expedidor
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ") <> "U"
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT
		Else
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CPF:TEXT
		EndIf
	ElseIf c_Toma == "2" // Recebedor
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT
		Else
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CPF:TEXT
		EndIf
	ElseIf c_Toma == "3"  // Destinatario
		If Type("oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ") <> "U"
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
		Else
			c_Tomador := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT
		EndIf
	EndIf
// EndIf

cCnpj    := StrTran(cCnpj,'.','')
cCnpj    := StrTran(cCnpj,'/','')
cCnpj    := StrTran(cCnpj,'-','')
cCliFor  := "S"
cCodCF   := ""
cLoj     := ""
a_Cnpj    := {}
l_Agro    := .F.
l_Entrada := .F.
l_Saida   := .F.   
l_Tomador := .F.
dbSelectArea("SM0")
nRegSM0 := SM0->(Recno())
dbSetOrder(1)
SM0->(DbGoTop())
While SM0->(!Eof())
	If c_RemCNPJ == SM0->M0_CGC
		l_Agro  := .T.
		aadd(a_Cnpj,{SM0->M0_CODFIL,"R"})
	EndIf
	If c_DestCNPJ == SM0->M0_CGC
		l_Agro  := .T.
		aadd(a_Cnpj,{SM0->M0_CODFIL,"D"})
	EndIf
	If l_toma3
		If c_Tomador ==  SM0->M0_CGC
			l_Tomador := .T.
		EndIf
	EndIf
	SM0->(dbSkip())
Enddo
SM0->(DbGoTo(nRegSM0))     
If ! l_Tomador .And. l_toma3
	aadd(a_Xml,cChaveNfe+ " - Tomador é a Shangrila" )
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	Ferase(cXMLFile)
	Return .F.
EndIf
If Len(a_Cnpj) > 1
	for i = 1 to len(a_Cnpj)
		// Pega filial do remetente
		if a_Cnpj[i][2] == "R"
			_cFil := a_Cnpj[i][1]
		endif
	next
EndIf

If  ! l_Agro //  ! l_Entrada .And. !l_Saida
	aadd(a_Xml,cChaveNfe+ " - CNPJ Remetente/Destinatario nao e da Agrozootec" )
	
	__CopyFile(cXMLFile,cDirErro+cNewArq)
	
	Ferase(cXMLFile)
	Return .F.
EndIf
cStatus := "0"
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2") + cCnpj )
	cCliFor := "F"
	cCodCF  := SA2->A2_COD
	cLoj    := SA2->A2_LOJA
	If SA2->A2_MSBLQL == "1"
		cStatus := "5"
		aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " Bloqueado no Cadastro de Fornecedor." )
	EndIf
Else
	aadd(a_Xml,cChaveNfe+ " - Transportadora CNPJ: " + cCnpj + " nao encontrado no Cadastro de Fornecedor." )
	cStatus := "5"
EndIf
CSERIE   := Alltrim(Str(Val(Substr(cChave,23,3)),3,0))
cDoc     := Substr(cChave,26,9)
// Status 0=Inclusao;1=Pre-Validado;2=Status Sefaz;3=Estrutura Xml;4=Depara;5=Bloqueio Cadastro;6=Gerado;7=Problema na Geracao pre-nota  8= Regra ZZQ/ZZP nao localizada
DbSelectArea("ZZS")
DbSetOrder(1)
IF  DbSeek(_cFil + cChave )
	Reclock("ZZS",.F.)
	ZZS->ZZS_CGC     := cCnpj
	ZZS->ZZS_EMISSA  := dEmissao
	ZZS->ZZS_DOC     := StrZero(Val(cDoc),9)
	ZZS->ZZS_SERIE   := CSERIE
	ZZS->ZZS_CLIFOR  := cCodCF
	ZZS->ZZS_LOJA    := cLoj
	ZZS->ZZS_XML     := cXML
	ZZS->ZZS_STATUS  := cStatus
	ZZS->ZZS_ESPECI  := "CTE"
	MsUnlock()
Else
	Reclock("ZZS",.T.)
	ZZS->ZZS_FILIAL := _cFil
	ZZS->ZZS_CHAVE  := cChave
	ZZS->ZZS_CGC    := cCnpj
	ZZS->ZZS_EMISSA := dEmissao
	ZZS->ZZS_DOC    := StrZero(Val(cDoc),9)
	ZZS->ZZS_SERIE  := CSERIE
	ZZS->ZZS_XML     := cXML
	ZZS->ZZS_STATUS := cStatus
	ZZS->ZZS_ESPECI := "CTE"
	ZZS->ZZS_CLIFOR  := cCodCF
	ZZS->ZZS_LOJA    := cLoj

	MsUnlock()
	
	DbSelectArea("ZZT")
	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := _cFil
	ZZT->ZZT_CHAVE  := cChave
	ZZT->ZZT_DTHORA := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2) +"/"+StrZero(Year(dDatabase),4)+ " "+Substr(Time(),1,5)
	ZZT->ZZT_CLIFOR := cCodCF
	ZZT->ZZT_LOJA   := cLoj
	ZZT->ZZT_OCORRE := "Carga Inicial. "
	MsUnlock()
	
EndIf
_nPosIniICM	:=At("<pICMS",cXML)
_nPosFimICM :=At("</pICMS",cXML)
_nPosIniICM += 7
nAliqICM := val(Substr(cXML, _nPosIniICM, _nPosFimICM - _nPosIniICM))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Copia o arquivo para a pasta processados e apaga arquivo lido      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
__CopyFile(cXMLFile,cDirOk+cNewArq)
Ferase(cXMLFile)
//conout("Retorno do Erase: "+Str(Ferror(),10))
oXml := Nil
DelClassIntf()

Return

//////////////////////////////////////////////////////////////////////////////////////
//Rotina que envia email para usuarios pre-determinados, sobre os desenhos enviados //
//////////////////////////////////////////////////////////////////////////////////////
Static Function AIMSGENV(a_Xml)  
Local cSubject		:= ""
Local cxDes			:= ""
Local cxNomDes		:= ""
Local cEmailXml		:= AllTrim(SuperGetMv("GO_MAILXML",,"chenrique@lampadasgolden.com.br")) // 
Local cMail			:= ""
Local cSMTP			:= ""
Local cOBS			:= 'e-Mail Enviado automaticamente através do Schedule de importacao XML - Protheus'
LOCAL xArea			:= GetArea() //Area atual utilizada
Local nRegistro		:= "" 
nRegistro:=Recno()

_cFrom   :=GetMv("MV_RELFROM")

// Autentica Servidor
_cServer :=GetMv("MV_RELSERV")
_cUser   :=GetMv("MV_RELACNT")
_cPass   :=GetMv("MV_RELAPSW")

mMensagem := "<BODY>"
mMensagem := mMensagem + "<DIV><FONT face=Arial size=2>Os seguintes xml nao foram importados pelo sistema e foram removidos para pasta: "+cDirErro+"<BR></FONT></DIV>"
mMensagem+= "<BR>"  //</STRONG>

For nP:= 1 To Len(a_Xml)
    _cXml 	 := a_Xml[nP]
    if !Empty(_cXml)    
		mMensagem:= mMensagem+"<BR><STRONG><DIV><FONT face=Arial size=2>"
		mMensagem+= "&nbsp;&nbsp;&nbsp;"
		mMensagem+= "Chave :&nbsp;"+ALLTRIM(_cXml)
		mMensagem+= "<BR>"  //</STRONG>
	Endif
Next  

//mMensagem := mMensagem + "</STRONG><BR>Enviado Para..    : <STRONG>"+UPPER(cPara)+"<BR></STRONG>&nbsp; "
mMensagem := mMensagem + "<BR><STRONG>OBS: </STRONG>"+cOBS+"<BR>&nbsp; </DIV>" 
mMensagem := mMensagem + "<DIV>&nbsp;</DIV></BODY>"

cSubject := "Aviso Xml removidos para a pasta:  " + cDirErro + "."

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cPass RESULT _lResult

// CONNECT SMTP SERVER cSMTP ACCOUNT cEmailPms PASSWORD "0721"

SEND MAIL FROM _cFrom to cEmailXml SUBJECT cSubject  BODY mMensagem

DISCONNECT SMTP SERVER
RestArea(xArea)
Return

User FuncTion MudaSta()
DbSelectArea("ZZS")  

If ZZS->ZZS_STATUS <> "0"
	Reclock("ZZS",.F.)
		ZZS->ZZS_STATUS  := '0'
	MsUnlock()      
Else
	Reclock("ZZS",.F.)
		ZZS->ZZS_STATUS  := '1'
	MsUnlock()      
EndIf
Return


Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
Return