#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "XMLXFUN.CH" 
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "PRTOPDEF.CH"

Static lInitSped := .F.

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ HFXML06D ≥ Autor ≥ Eneovaldo Roveri Jr   ≥ Data ≥03/10/2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Rotina de Download de XMLs do Sefaz                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function HFXML06D
Local aArea := GetArea()
Local nOpc  := 0
Local nChv  := 0
Local cArq


cArq := CriaTMP()

If cArq == NIL .or. empty( cArq )
   U_MyAviso("Erro","N„o foi possÌvel criar o Arquivo Tempor·rio."+CRLF+;
	"Verifique suas permissıes e tente novamente.",{"OK"},1)
	RestArea(aArea)
	Return(NIL)
Endif

If Select("TMP") > 0
	TMP->( dbCloseArea() )
EndIf
dbUseArea(.T.,, cArq,"TMP", .F., .F.) //exclusivo
IndRegua("TMP",cArq+"A","CHAVE" )

nOpc := U_MyAviso("OpÁ„o","1-Informar CNPJ ou "+CRLF+"2-Informar Chave"+CRLF+"3-Nenhuma Chave",{"1-CNPJ","2-Chave","3-Nenhum"},3)

if nOpc == 1
	if HFXML06Cnp()
		nChv++
	endif
ElseIf nOpc == 2

	do while HFXML06Chv(@nChv)
		if nChv == 10
			Exit
		endif
	enddo
EndIf

if nChv > 0 .or. nOpc == 3
	HFXML06Brw()
endif

TMP->( dbCloseArea() )
fErase( cArq+GetDBExtension() )

RestArea(aArea)
Return(NIL)


Static Function CriaTMP()
Local aStru := {}
Local cARQ

aadd( aStru, { "OK"      ,"C",02,0 } )
aadd( aStru, { "ST"      ,"C",01,0 } )
aadd( aStru, { "CHAVE"   ,"C",44,0 } )
aadd( aStru, { "AMB"     ,"C",01,0 } )
aadd( aStru, { "MSG"     ,"C",30,0 } )
aadd( aStru, { "ERRO"    ,"M",10,0 } )
aadd( aStru, { "DEST"    ,"C",14,0 } )
//dados do xml para consulta
aadd( aStru, { "CNPJ_EMI","C",14,0 } )
aadd( aStru, { "DEMI"    ,"C",10,0 } )
aadd( aStru, { "VNF"     ,"C",15,0 } )
aadd( aStru, { "XNOME"   ,"C",60,0 } )
aadd( aStru, { "IE"      ,"C",14,0 } )
aadd( aStru, { "DIGVAL"  ,"C",28,0 } )
aadd( aStru, { "DHRECBTO","C",10,0 } )
aadd( aStru, { "CSITNFE" ,"C",01,0 } )
aadd( aStru, { "CSITCONF","C",01,0 } )
aadd( aStru, { "NSU"     ,"C",15,0 } )
aadd( aStru, { "Correcao","M",10,0 } )
aadd( aStru, { "IDENT"   ,"C",14,0 } )
aadd( aStru, { "XML"     ,"M",10,0 } )
aadd( aStru, { "XMLCANC" ,"M",10,0 } )


cArq := CriaTrab( aStru, .T. )

Return( cArq )


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06Brw≥ Autor ≥ Eneovaldo Roveri Jr   ≥ Data ≥03/10/2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ MarkBrowse das Chaves para Download                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06Brw()
Local aButtons	:= {}
Local aGetArea	:= GetArea()
Local aInfo		:= {}
Local aPosObj	:= {}
Local aObjects	:= {}
Local aSize		:= MsAdvSize()  			// Define e utilizaÁ„o de janela padr„o Microsiga
Local cGetLOk  	:= "AllwaysTrue"	   		// Funcao executada para validar o contexto da linha atual do aCols
Local cGetTOk  	:= "AllwaysTrue"    		// Funcao executada para validar o contexto geral da MsNewGetDados
Local oFolder	:= Nil
Local oDlg01	:= Nil
Local oMarkBw	:= Nil
Local lInverte	:= .F.
Local lOk		:= .F.
Local cChvAtu	:= " "
Local cChvAnt	:= " "
Local oFont		:= Nil
Local aCpos     := {}
Local aCores    := {}

Private cMarcaOK := GetMark()

aCpos := {}
aadd( aCpos, {"OK"   ,,"" } )
//aadd( aCpos, {"ST"   ,,"ST","@!" } )
aadd( aCpos, {"CHAVE",,"CHAVE","@!" } )
aadd( aCpos, {"MSG"  ,,"MENSAGEM","@!" } )
aadd( aCpos, {"ERRO" ,,"RESP SEFAZ","@!" } )
aadd( aCpos, {"CSITCONF",,"MANIFESTO","@!" } )
aadd( aCpos, {"CNPJ_EMI",,"EMITENTE","@!" } )
aadd( aCpos, {"DEMI"    ,,"DT EMISSAO","@!" } )
aadd( aCpos, {"VNF"     ,,"VALOR","@!" } )
aadd( aCpos, {"XNOME"   ,,"EMITENTE","@!" } )
aadd( aCpos, {"IE"      ,,"IE EMIT","@!" } )
aadd( aCpos, {"DIGVAL"  ,,"DIGEST VAL","@!" } )
aadd( aCpos, {"DHRECBTO",,"DT AUTORIZ","@!" } )
aadd( aCpos, {"CSITNFE" ,,"SIT NFE","@!" } )
aadd( aCpos, {"NSU"     ,,"NSU","@!" } )
aadd( aCpos, {"Correcao",,"CARTA DE CORRECAO","@!" } )
aadd( aCpos, {"XML"     ,,"XML","@!" } )
aadd( aCpos, {"XMLCANC" ,,"XML Cancel","@!" } )

aCores := {}
aAdd(aCores,{"TMP->ST == '1'","BR_VERDE"	})
aAdd(aCores,{"TMP->ST == ' '","BR_AMARELO"	})
aAdd(aCores,{"TMP->ST == '0'","BR_VERMELHO" })
aAdd(aCores,{"TMP->ST == '2'","BR_AZUL" })


dbSelectArea("TMP")
//COUNT TO nQtdReg
TMP->( dbGotop() )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Apresenta botao se nao for visualizacao ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aAdd(aButtons,{'CHECKED' ,{ || HFXML06Inv(cMarcaOK,@oMarkBw) }, "Inverter MarcaÁ„o", "Inverter"})
aAdd(aButtons,{'DESTINOS',{ || HFXML06Inv(cMarcaOK,@oMarkBw,.T.) }, "Marcar todos os tÌtulos", "Marc Todos"})
aAdd(aButtons,{          ,{ || HFXML06Chv() }, "Digitar Chaves", "Dig Chaves"})
aAdd(aButtons,{          ,{ || HFXML06Cnp() }, "Digitar CNPJ", "Digitar CNPJ"})
aAdd(aButtons,{          ,{ || HFXML06man() }, "ManifestaÁ„o Destinat·rio", "ManifestaÁ„o Destinat·rio"})
aAdd(aButtons,{          ,{ || HFXML06NSU() }, "Editar NSU / MDAMB para Download por CNPJ", "Editar NSU / MDAMB"})
aAdd(aButtons,{          ,{ || HFXML06Leg() }, "Legenda", "Legenda"})
aAdd(aButtons,{          ,{ || HFXML06Vis() }, "Visualizar Registro", "Visualizar"})

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define as posicoes da GetDados e Paineis ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//aAdd( aObjects, { 100, 060, .T., .T. } )      //GetDados
//aAdd( aObjects, { 100, 040, .T., .T. } )      //Folder
//aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
//aPosObj := MsObjSize( aInfo, aObjects,.T. )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Definicao da tela ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ    //aSize[7],0 TO aSize[6],aSize[5]
DEFINE MSDIALOG oDlg01 TITLE "Download XML Sefaz" FROM 000,000 TO 430,800 OF oMainWnd PIXEL 

oDlg01:lMaximized := .F.

//@ -15,270 Button "ZOCA" Size 010,011 PIXEL OF oMainWnd ACTION (cJobs:=U_GetJob(cJobs)) 
//@ -15,-15 BUTTON oBtn PROMPT "ZOCA" SIZE 10,50 PIXEL OF oDlg01

//DEFINE FONT oFont NAME "Arial" SIZE 10,12 BOLD

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Criacao do objeto Folder ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//oFolder	:= TFolder():New(10,2,{"Chaves"},{},oDlg01,,,,.T.,.F.,aPosObj[1][4],aPosObj[2][3],)  //-aPosObj[2][1]

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Cria o objeto Mark para a selecao dos podrutos ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oMarkBw:=MsSelect():New("TMP","OK","",aCpos,@lInverte,@cMarcaOK,{17,10,150,400},,,,,aCores) //oFolder:aDialogs[1]

oMarkBw:oBrowse:Refresh()
oMarkBw:oBrowse:lhasMark    := .T.
oMarkBw:oBrowse:lCanAllmark := .T.
oMarkBw:oBrowse:Align       := CONTROL_ALIGN_ALLCLIENT	//Usado no modelo FLAT


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Permite selecao se n„o for visualizacao ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oMarkBw:oBrowse:bAllMark    := { || HFXML06Inv(cMarcaOK,@oMarkBw) }
oMarkBw:oBrowse:bChange     := { || HFXML06Chg(@oMarkBw) }
oMarkBw:BMark               := { || HFXML06Dis(@oMarkBw,cMarcaOK) }

ACTIVATE MSDIALOG oDlg01 CENTERED  ON INIT EnchoiceBar(oDlg01,;
{|| processa({|| HFXML06Dow(@oMarkBw)}, "Baixar...","Baixando XML ...") },;
{|| iif( msgYesNo("Sair Download XML ?","Pegunta"),oDlg01:End(),lOk := .F. )},,aButtons)



Return( .T. )




/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06Inv≥ Autor ≥ Eneo                  ≥ Data ≥23/11/2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Locacao   ≥ Parceiros        ≥Contato ≥ adilson.gomes@advbrasil.com.br ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Esta rotina ira marcar ou desmarcar as chaves.             ≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06Inv(cMarcaOK,oMarkBw,lMarkAll)
Local aGetArea	:= GetArea()
Local lMarcSim	:= .F.

If lMarkAll
	lMarcSim := Aviso( "Marcar/Desmarcar todos", "Deseja marcar ou desmarcar todos os tÌtulos?", { "Marcar", "Desmarcar" } ) == 1
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ While para marcar ou desmarcar os produtos ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
TMP->( dbGotop() )
Do while TMP->( !EOF() )

	If lMarkAll
		RecLock("TMP", .F.)
		TMP->OK	:= if(TMP->ST == "1", "  ", If(lMarcSim, cMarcaOK, "  ") )
		TMP->( MsUnLock() )
	Else
		If  TMP->OK == cMarcaOK
			RecLock("TMP", .F.)
			TMP->OK	:= "  "
			TMP->( MsUnLock() )
		Else
			RecLock("TMP", .F.)
			TMP->OK	:= if(TMP->ST == "1", "  ", cMarcaOK )
			TMP->( MsUnLock() )
		EndIf
	EndIf

	TMP->( dbSkip() )
EndDo

oMarkBw:oBrowse:Refresh(.T.)
RestArea( aGetArea )
Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06Dis≥ Autor ≥ Eneovaldo Roveri Jr   ≥ Data ≥19/01/2010≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Locacao   ≥ Parceiros        ≥Contato ≥                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Rotina para execucao do filtro na tabela temporaria        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06Dis(oMarkBw, cMarcaOK)
Local aGetArea := GetArea()

oMarkBw:oBrowse:Refresh(.T.)

RestArea( aGetArea )
Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06Chg≥ Autor ≥                       ≥ Data ≥25/09/2008≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Rotina para execucao do filtro na tabela temporaria        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06Chg(oMarkBw)
Local cRetFun		:= " "

oMarkBw:oBrowse:Refresh(.T.)

Return cRetFun

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥HFXML06Dow≥ Autor ≥Eneovaldo Roveri Junior≥ Data ≥ 03/10/13 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Download das Chaves                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ HFXML06Dow()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HFXML06Dow(oMarkBw)
Local nReg   := TMP->( recno() )
Local nRet   := 0
Local xRet   := -1
Local lTem   := .F.
Local nChv   := 0
Local nEve   := 0
Local cAmb   := ""
Local cChave := ""
Local aChave := {}
Local cCnpj  := SM0->M0_CGC  //"61135471000100"
Local cIdEnt := U_GetIdEnt()
Local cDir   := AllTrim(SuperGetMv("MV_X_PATHX"))

Private pReg := 0
Private nDow := 0  //Coisa de Louco
Private nErr := 0  //Coisa de Louco
Private nMan := 0  //Coisa de Louco

ProcRegua(TMP->( RecCount() ))
TMP->( dbgotop() )
Do While .not. TMP->( Eof() )
	IncProc("Processando "+TMP->CHAVE)
	if .not. empty( TMP->OK ) // == cMarcaOK
		If pReg == 0
			pReg := TMP->( Recno() )
		EndIf
		cCnpj  := TMP->DEST
		cIdEnt := iif( .Not. Empty(TMP->IDENT), AllTrim(TMP->IDENT), cIdEnt )
		lTem   := .T.
		cChave += TMP->CHAVE+";"
		aadd( aChave, TMP->CHAVE )
		nChv++
		if cAmb <> "1"
			cAmb := TMP->AMB
		endif
		RecLock( "TMP", .F. )
		TMP->OK := "Pr"
		TMP->( MsUnLock() )
	endif
	TMP->( dbskip() )
	If nChv >= 10 .Or. ( nChv >= 1 .and. TMP->( Eof() ) )
		nRet := HFXML06Bai(cCnpj,cChave,cAmb,cIdEnt)
		//nRet := HFXML06BTss(cCnpj,aChave,cAmb,cIdEnt)
		if xRet <> 1
			if nRet == 1
				xRet := nRet
			Else
				if xRet <> 0
					xRet := nRet
				endif
			Endif
		Endif
		nChv := 0
		pReg := 0
		cChave := ""
	EndIf
Enddo

if .Not. lTem
	U_MyAviso("Msg","Nenhuma chave selecionada para download !!!!",{"OK"},3)
	TMP->( dbgoto( nReg ) )
	return( nRet )
endif

if xRet == 1  //Tem Chaves para Manifestar
	oMarkBw:oBrowse:Refresh(.T.)
	if U_MyAviso("Pergunta","Existem Chaves sem ManifestaÁ„o. Deseja Manifesta-las e tentar o Download Novamente?",{"SIM","NAO"},2) == 1
		Do While .Not. HFXML06Man( .T., @nEve )
		EndDo
		oMarkBw:oBrowse:Refresh(.T.)
		nMan := 0
		//nDow := 0
		//nErr := 0

		ProcRegua(TMP->( RecCount() ))
		TMP->( dbgotop() )
		Do While .not. TMP->( Eof() )
			IncProc("Processando "+TMP->CHAVE)
			if .not. empty( TMP->OK ) // == cMarcaOK
				If pReg == 0
					pReg := TMP->( Recno() )
				EndIf
				cCnpj  := TMP->DEST
				cIdEnt := iif( .Not. Empty(TMP->IDENT), AllTrim(TMP->IDENT), cIdEnt )
				lTem   := .T.
				cChave += TMP->CHAVE+";"
				nChv++
				if cAmb <> "1"
					cAmb := TMP->AMB
				endif
				RecLock( "TMP", .F. )
				TMP->OK := "Pr"
				TMP->( MsUnLock() )
			endif
			TMP->( dbskip() )
			If nChv >= 10 .Or. ( nChv >= 1 .and. TMP->( Eof() ) )
				nRet := HFXML06Bai(cCnpj,cChave,cAmb,cIdEnt)
				if xRet <> 1
					if nRet == 1
						xRet := nRet
					Else
						if xRet <> 0
							xRet := nRet
						endif
					Endif
				Endif
				nChv := 0
				pReg := 0
				cChave := ""
			EndIf
		Enddo
	endif
	nErr += nMan
endif
If nDow == 0
	U_MyAviso("Msg","OperaÁ„o com erros, verifique as Mensagens.",{"OK"},3)
Elseif nErr == 0
	U_MyAviso("Msg","OperaÁ„o concluida com exito, verifique as Mensagens e os arquivos baixados na pasta "+cDir+".",{"OK"},3)
Else
	U_MyAviso("Msg","OperaÁ„o concluida com alguns erros, verifique as Mensagens e os arquivos baixados na pasta "+cDir+".",{"OK"},3)
endif

TMP->( dbgoto( nReg ) )
Return( NIL )

//Retorna 0 - OK
//Retorna 1 - Tem alguma manifestaÁıes para fazer
//Retorna 2 - SÛ Erro
Static Function HFXML06Bai(cCnpj,cChave,cAmb,cIdEnt)
Local nReg   := TMP->( recno() )
Local nRet   := 0
Local nChv   := 0
Local cURL   := ""
Local cDir   := AllTrim(SuperGetMv("MV_X_PATHX"))
Local cXml   := ""
Local cNfe   := ""
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWs,oWsrNfe,oWsdNfe,cErro,cWarning

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""	
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1) 
EndIf

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLDOWLOAD():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "AN"
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave

if oWSdNfe:HFBAIXAXML()
	cXml := oWSdNfe:cHFBAIXAXMLRESULT
	nAt1:= At('<RETDOWNLOADNFE ',Upper(cXml))
	nAt2:= At('</RETDOWNLOADNFE>',Upper(cXml))+ 17
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETDOWNLOADNFE>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 17
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta"
			cInfo  := cErro + " " + cWarning
			lTodos := .T.
			nRet   := 2
			//U_MyAviso("SPED",cInfo,{"OK"},3)
		elseIf oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT <> "139"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETDOWNLOADNFE:_XMOTIVO:TEXT
			lTodos := .T.
			nRet   := 2
			//U_MyAviso("SPED",cInfo,{"OK"},3)
		Else
			oDet := oWSrNfe:_RETDOWNLOADNFE:_RETNFE
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_CSTAT:TEXT <> "140"
					cMsg  := oDet[nI]:_CSTAT:TEXT
					cInfo := oDet[nI]:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cChave := cDir + alltrim( oDet[nI]:_CHNFE:TEXT ) + "-procNfe.xml"
					oXml := oDet[nI]:_PROCNFE:_NFEPROC

					SAVE oXml XMLSTRING cXML
					nAt1:= At('<NFE ',Upper(cXml))
					nAt2:= At('</NFE>',Upper(cXml))+ 6
					//Corpo da Nfe
					If nAt1 <=0
						nAt1:= At('<NFE>',Upper(cXml))
					EndIf 	
					If nAt1 > 0 .And. nAt2 > 6
						cNfe := Substr(cXml,nAt1,nAt2-nAt1)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo := "XML "+oDet[nI]:_CHNFE:TEXT+" sem TAG <NFE>"
					EndIf	
					nAt3:= At('<PROTNFE ',Upper(cXml))
					nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
					//Protocolo	
					If nAt3 > 0 .And. nAt4 > 10
						cProt := Substr(cXml,nAt3,nAt4-nAt3)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo += "XML "+oDet[nI]:_CHNFE:TEXT+" sem Protocolo, falta TAG <PROTNFE>"
					EndIf
					
					if empty( cMsg )
						//cXml:= '<?xml version="1.0"?>'
						cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
						cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
						cXml+= cNfe
						cXml+= cProt
						cXml+= '</nfeProc>'
						cXml := NoAcento(cXml)
						cXml := EncodeUTF8(cXml)
						oXml := XmlParser( cXml, "_", @cErro, @cWarning )
						
						if oXML == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
							cStt  := "0"
							cMsg  := "Erro Parser do XML"
							cInfo := cErro + " " + cWarning
						Else
							SAVE oXML XMLFILE cChave
							nHandle := FT_FUse( cChave )
							if nHandle == -1
								cStt  := "0"
								cMsg  := "Erro GravaÁ„o"
								cInfo := "Erro de GravaÁ„o XML no DiretÛrio "+cChave
							else
								cStt  := "1"
								cMsg  := "Download Efetuado"
								cInfo := "Download Efetuado do XML "+cChave
							endif
							FT_FUSE()
						EndIf
					Endif

				Endif
				if cStt == "1"
					nDow++
				else
					if alltrim(cMsg) == "633" //Falta de ManifestaÁ„o
						nMan++
					Else
						nErr++
					EndIf
				endif
				If TMP->(dbSeek( oDet[nI]:_CHNFE:TEXT ) )
					if alltrim(cMsg) == "633" //Falta de ManifestaÁ„o
						nRet := 1
					endif
					if cStt <> "1" .and. nRet <> 1
						nRet := 2
					endif
					RecLock( "TMP", .F. )
					if alltrim(cMsg) != "633" //Deixa marcado
						TMP->OK    := "  "
					endif
					TMP->ST    := cStt
					TMP->MSG   := cMsg
					TMP->ERRO  := cInfo
					TMP->( MsUnLock() )
				endif
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETDOWNLOADNFE>"
		//U_MyAviso("SPED",cInfo,{"OK"},3)
		lTodos := .T.
		nRet   := 2
	EndIf	
else
	//Erro TSS ou WS n„o instalado.
	nRet  := 2
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	//U_MyAviso("SPED",cInfo,{"OK"},3)
	lTodos := .T.
endif

if lTodos
	TMP->( dbgotop() )
	nChv := 0
	TMP->( DbGoto( pReg ) )
	Do While .not. TMP->( Eof() ) .And. nChv <= 10
		if TMP->OK == "Pr" // == cMarcaOK
			RecLock( "TMP", .F. )
			TMP->OK    := "  "
			TMP->ST    := "0"
			TMP->MSG   := cMsg
			TMP->ERRO  := cInfo
			TMP->( MsUnLock() )
			nChv++
			nErr++
		endif
		TMP->( dbskip() )
	Enddo
endif

TMP->( dbgoto( nReg ) ) //Volta ao Registro para dar continuidade
return( nRet )



/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥HFXML06Chv≥ Autor ≥Eneovaldo Roveri Junior≥ Data ≥ 03/10/13 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Download das Chaves                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ HFXML06Chv()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HFXML06Chv(nChv)
Local oDlgKey, oBtnOut, oBtnCon
Local cIdEnt    := ""
Local cChaveXml := iif(nChv==NIL .or. nChv>0, space( len(TMP->CHAVE) ), Substr(AllTrim(ZBZ->(FieldGet(FieldPos("ZBZ_CHAVE"))))+space(len(TMP->CHAVE)),1,len(TMP->CHAVE)) )
Local cModelo   := "55"
Local cProtocolo:= ""
Local cMensagem := ""
Local lRet      := .T.
Local cPref     := "NF-e"                             
Local cTAG      := "NFE"
Local cAmb      := "1"
Local cCodRet   := ""
Local lValidado := .F.
Local cURL      := ""
Local xCnpj     := ""
Local xIdEnt    := ""
Default nChv    := 0

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf
/*
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
	DbSelectArea("ZBZ")
	DbGoTo(256)
*/
	
DEFINE MSDIALOG oDlgKey TITLE "Consulta "+cPref FROM 0,0 TO 150,305 PIXEL OF GetWndDefault()

@ 12,008 SAY "PrÛxima Chave de acesso do xml de "+cPref PIXEL OF oDlgKey
@ 20,008 MSGET cChaveXml SIZE 140,10 PIXEL OF oDlgKey

@ 46,035 BUTTON oBtnCon PROMPT "&Incluir" SIZE 38,11 PIXEL ACTION (lRet:=.T.,oDlgKey:End())
@ 46,077 BUTTON oBtnOut PROMPT "&Sair" SIZE 38,11 PIXEL ACTION (lRet:=.F.,oDlgKey:End())

ACTIVATE DIALOG oDlgKey CENTERED

If lRet
	if len( AllTrim( cChaveXml ) ) == len(TMP->CHAVE)
		MsgRun("Aguarde. Consultando Chave Sefaz...","Consultando Chave Sefaz",{|| lValidado := U_XConsXml(cURL,cChaveXml,cModelo,cProtocolo,@cMensagem,@cCodRet,.F.,@xCnpj,@xIdEnt) } )
	else
		cMensagem := "Chave deve conter 44 Characteres"
		cCodRet   := ""
	endif
EndIf

if cCodRet == "100"
	if .not. TMP->( dbSeek( cChaveXml ) )
		if "HomologaÁ„o" $ cMensagem
			cAmb := "2"
		endif
		RecLock( "TMP", .T. )
		TMP->ST    := " "
		TMP->CHAVE := cChaveXml
		TMP->AMB   := cAmb
		TMP->DEST  := iif( empty(xCnpj), SM0->M0_CGC, xCnpj ) //SM0->M0_CGC
		TMP->IDENT := xIdEnt
		TMP->( MsUnLock() )
		nChv++
		//U_MyAviso("Msg","Chave incluida com sucesso ",{"OK"},1)
	else
		U_MyAviso("AtenÁ„o","Chave J· IncluÌda",{"Continua"},1)
	endif
else
	if lRet
   		U_MyAviso("Erro",cMensagem+CRLF+;
			"Cod. Retorno "+cCodRet,{"Continua"},3)
	endif
endif

return( lRet )




/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥HFXML06Cnp≥ Autor ≥Eneovaldo Roveri Junior≥ Data ≥ 23/05/14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ CNPJ para consulta                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ HFXML06Cnp()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HFXML06Cnp()
Local oDlgKey, oBtnOut, oBtnCon
Local lRet      := .T.
Local lValidado := .T.
Local cCnpj     := SM0->M0_CGC
Local cKeyF3    := SetKEY( VK_F3 ,  Nil )
Local nOpc      := 0 //aquiiiii

DEFINE MSDIALOG oDlgKey TITLE "Consulta CNPJ" FROM 0,0 TO 150,305 PIXEL OF GetWndDefault()
SetKey( VK_F3, { || U_HFXML6SM(@cCnpj) } )

@ 12,008 SAY "CNPJ para Consultar Chaves [F3]-Pesquisa" PIXEL OF oDlgKey
@ 20,008 MSGET cCnpj Picture "@R 99.999.999/9999-99" SIZE 140,10 PIXEL OF oDlgKey

@ 46,035 BUTTON oBtnCon PROMPT "&Ok" SIZE 38,11 PIXEL ACTION if(ChkCnpj(cCnpj), (lRet:=.T.,oDlgKey:End()), lRet:=.F. )
@ 46,077 BUTTON oBtnOut PROMPT "&Sair" SIZE 38,11 PIXEL ACTION (lRet:=.F.,oDlgKey:End())

ACTIVATE DIALOG oDlgKey CENTERED

If lRet
    nOpc := U_MyAviso("OpÁ„o","1-Todos a partir do ultimo NSU "+CRLF+"2-SÛ N√O importados a partir do ultimo NSU",{"1-Todos","2-N„o Importados"},3)
    if nOpc == 1 .or. nOpc == 2
		MsgRun("Aguarde. Consultando Cnpj Sefaz...","Consultando Cnpj Sefaz",{|| lValidado := U_HFXML6CD(cCnpj, .T., , nOpc) } )
		lRet := lValidado
	Endif
EndIf

if .Not. lValidado
  		U_MyAviso("Erro","CNPJ n„o possui Chaves para Consultar"+CRLF+;
			"",{"Continua"},1)
endif

SetKEY( VK_F3 ,  cKeyF3 )

return( lRet )




/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥HFXML06Man≥ Autor ≥Eneovaldo Roveri Junior≥ Data ≥ 31/10/13 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ ManifestaÁ„o do Destinatario                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ HFXML06Man()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HFXML06Man( lBai, nEve )
Local nReg   := TMP->( recno() )
Local lRet   := .F.
Local cChave := ""
Local cEvent := ""
Local cEve   := "210200"
Local cJust  := Space(255)  //AQUIII
Local cxJst  := ""          //AQUIIII
Local nLote  := 1
Local nChv   := 0
Local cCnpj  := SM0->M0_CGC  //"61135471000100"
Local cURL   := ""
Local cXml   := ""
Local cNfe   := ""
Local cAmb   := ""
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local lTemPr := .F.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWS,oWsrNfe,oWsdNfe,cErro,cWarning

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

if lBai == NIL
	lBai := .F.
endif
if nEve == NIL
	nEve := 0
endif

If lBai
	if nEve <> 1 .and. nEve <> 2
		nEve := U_MyAviso("Pergunta","Deseja Manifestar como? "+CRLF+"1-Conf.OP->Confirmacao da Operacao ou "+CRLF+"2-Cien.Op->Ciencia da Operacao",{"1-Conf.OP","2-Cien.Op"},3)
	endif
	if nEve <> 1 .and. nEve <> 2
		nEve := 0
	endif
Else
	nEve := Manifesto("ManifestaÁ„o do Destinat·rio","ManifestaÁ„o do Destinat·rio",{"ConfirmaÁ„o da operaÁ„o","CiÍncia da operaÁ„o","Desconhecimento da operaÁ„o","OperaÁ„o n„o Realizada"},3)
EndIf

if nEve == 1
	cEve := "210200"
elseif nEve == 2
	cEve := "210210"
elseif nEve == 3
	cEve := "210220"
elseif nEve == 4
	cEve  := "210240"
else
	Return( lRet )
endif

TMP->( dbgotop() )
Do While .not. TMP->( Eof() ) .and. nChv < 10
	if .not. empty( TMP->OK ) .And. TMP->OK <> "Pt" // == cMarcaOK
		cCnpj  := TMP->DEST
		cIdEnt := iif( .Not. Empty(TMP->IDENT), AllTrim(TMP->IDENT), cIdEnt )
		cChave += TMP->CHAVE+";"
		cEvent += cEve+";"
		cJust  := space(255)
		if cEve == "210240" //AQUIIII
			cJust := U_TelaJust( TMP->CHAVE, cJust )  //GETESB2
			if cJust == "-1"
				exit
			endif
		endif
		cxJst += AllTrim(cJust)+";"

		nChv++
		if cAmb <> "1"
			cAmb := TMP->AMB
		endif
		RecLock( "TMP", .F. )
		TMP->OK := "Pt"
		TMP->( MsUnLock() )
	endif
	TMP->( dbskip() )
Enddo

if cJust == "-1" //AQUIIII
	if .not. lBai
		U_MyAviso("Msg","OperaÁ„o cancelada por falta de justificativa!!!!",{"OK"},3)
	endif
	TMP->( dbgoto( nReg ) )
	Return( lRet )
endif


if nChv <= 0
	if .not. lBai
		U_MyAviso("Msg","Nenhuma chave selecionada para Manifestar !!!!",{"OK"},3)
	endif
	TMP->( dbgoto( nReg ) )
	return( .T. )
endif


oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""	
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1) 
EndIf

// Tratamento da numeracao do lote
nLote := ( GetNewPar("XM_LOTEMAN",0) + 1 )
If !PutMv("XM_LOTEMAN",nLote)
	SX6->(RecLock("SX6",.T.))
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "XM_LOTEMAN"
	SX6->X6_TIPO    := "N"
	SX6->X6_DESCRIC := "Lote do Evento de Manifestacao"
	SX6->(MsUnLock())
	PutMv("XM_LOTEMAN",nLote)
EndIf

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLMANIFESTO():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
oWsdNfe:cCLOTE        := strzero(nLote,15,0)
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "91"
oWSdNfe:cCHORAVERAO   := cHrVerao
oWSdNfe:cCHORARIO     := cHorario
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave
oWSdNfe:cCEVSTR       := cEvent
oWSdNfe:cCXJUST       := cxJst  //AQUIIII

if oWSdNfe:HFMANISFESTO()
	cXml := oWSdNfe:cHFMANISFESTORESULT
	nAt1:= At('<RETENVEVENTO ',Upper(cXml))
	nAt2:= At('</RETENVEVENTO>',Upper(cXml))+ 15
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETENVEVENTO>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 15
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta da ManifestaÁ„o"
			cInfo  := cErro + " " + cWarning
			lTodos := .T.
			if .not. lBai
				U_MyAviso("SPED",cInfo,{"OK"},3)
			endif
		elseIf oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT <> "128"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETENVEVENTO:_XMOTIVO:TEXT
			lTodos := .T.
			if .not. lBai
				U_MyAviso("SPED",cInfo,{"OK"},3)
			endif
		Else
			oDet := oWSrNfe:_RETENVEVENTO:_RETEVENTO
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_INFEVENTO:_CSTAT:TEXT <> "135"
					cMsg  := oDet[nI]:_INFEVENTO:_CSTAT:TEXT
					cInfo := oDet[nI]:_INFEVENTO:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cStt  := "2"
					cMsg  := "ManifestaÁ„o Efetuada"
					cInfo := "ManifestaÁ„o Efetuada do XML "+cChave
					lRet  := .T.  //se manifestou ao menos um vai .T. para refazer download
				Endif
				If TMP->(dbSeek( oDet[nI]:_INFEVENTO:_CHNFE:TEXT ) )
					RecLock( "TMP", .F. )
					if cStt <> "2" .or. .not. lBai
						TMP->OK    := "  "
					endif
					TMP->ST    := cStt
					TMP->MSG   := cMsg
					TMP->ERRO  := cInfo
					TMP->( MsUnLock() )
				endif
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz na ManifestaÁ„o."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETENVEVENTO>"
		if .not. lBai
			U_MyAviso("SPED",cInfo,{"OK"},3)
		endif
		lTodos := .T.
	EndIf	
else
	//Erro TSS ou WS n„o instalado.
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	if .not. lBai
		U_MyAviso("SPED",cInfo,{"OK"},3)
	endif
	lTodos := .T.
endif

if lTodos
	TMP->( dbgotop() )
	Do While .not. TMP->( Eof() )
		if TMP->OK == "Pt" // == cMarcaOK
			RecLock( "TMP", .F. )
			TMP->OK    := "  "
			TMP->ST    := "0"
			TMP->MSG   := cMsg
			TMP->ERRO  := cInfo
			TMP->( MsUnLock() )
		endif
		if TMP->OK == "Pr" // == cMarcaOK
			lTemPr := .T.
		endif
		TMP->( dbskip() )
	Enddo
else
	if .not. lBai
		U_MyAviso("Msg","OperaÁ„o concluida, verifique as Mensagens.",{"OK"},3)
	Else
		TMP->( dbgotop() )
		Do While .not. TMP->( Eof() )
			if TMP->OK == "Pr" // == cMarcaOK
				lTemPr := .T.
			endif
			TMP->( dbskip() )
		Enddo
	endif
endif

if lBai
	if lTemPr  //essa È a locucura, po tive que mudar tudo esta merda
		lRet := .F.
	else
		lRet := .T.
	endif
endif


TMP->( dbgoto( nReg ) )
return( lRet )

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥NoAcento  ∫ Autor ≥ Roberto Souza      ∫ Data ≥  07/10/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Retira caracteres especiais.                               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Importa Xml                                                ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "·ÈÌÛ˙"+"¡…Õ”⁄"
Local cCircu := "‚ÍÓÙ˚"+"¬ Œ‘€"
Local cTrema := "‰ÎÔˆ¸"+"ƒÀœ÷‹"
Local cCrase := "‡ËÏÚ˘"+"¿»Ã“Ÿ" 
Local cTio   := "„ı"
Local cCecid := "Á«"
Local lChar  := .F.

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123// .and. (cChar<> 10 .And. cChar<> 13)
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return cString

Return(cString)



/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥HFXML06Leg≥ Autor ≥Eneovaldo Roveri Junior≥ Data ≥ 17/02/14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Legenda do Download e ManifestaÁ„o                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ HFXML06Leg()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HFXML06Leg()
Local aLegenda := {}

AADD(aLegenda,{"BR_AMARELO" ,"Aguardando interaÁ„o para download/manif." })
AADD(aLegenda,{"BR_VERMELHO","Download e/ou manifestaÁ„o com erros." })
AADD(aLegenda,{"BR_AZUL"    ,"Manif. processada aguardando interaÁ„o p/download." })
AADD(aLegenda,{"BR_VERDE" 	,"Download Concluido com sucesso." })

BrwLegenda("Download de XML", "Legenda", aLegenda)
Return Nil




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MyAviso   ∫Autor  ≥ Eneo               ∫ Data ≥             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Interface/Dialog de Aviso.                                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Geral                                                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function Manifesto(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
Local ny        := 0
Local nx        := 0
Local aSize  := {  {134,304,35,155,35,113,51},;  // Tamanho 1
				{134,450,35,155,35,185,51},; // Tamanho 2
				{227,450,35,210,65,185,99} } // Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet 
Local nPass := 0
Private oDlgAviso
Private nOpcAviso := 0

DEFAULT lEdit := .F.
If lEdit
	nSize := 3
EndIf

lMsHelpAuto := .F.

cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)
cMensagem := "1-ConfirmaÁ„o da operaÁ„o: OperaÁ„o conclusiva, o emissor n„o poder· cancelar o XML"+CRLF
cMensagem += "2-CiÍncia da operaÁ„o: Dever· Confirmar operaÁ„o posteriormente, o emissor n„o poder· cancelar o XML"+CRLF
cMensagem += "3-Desconhecimento da operaÁ„o"+CRLF
cMensagem += "4-OperaÁ„o n„o Realizada"+CRLF
//"ConfirmaÁ„o da operaÁ„o","CiÍncia da operaÁ„o","Desconhecimento da operaÁ„o","OperaÁ„o n„o Realizada"

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Quando for rotina automatica, envia o aviso ao Log.          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Type('lMsHelpAuto') == 'U'
	lMsHelpAuto := .F.
EndIf

If !lMsHelpAuto
	If nSize == Nil
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o numero de botoes Max. 5 e o tamanho da Msg.       ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If  Len(aBotoes) > 3
			nSize := 3
		Else
			Do Case
				Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
					nSize := 2
				Case Len(cMensagem) >= 250
					nSize := 3
				OtherWise
					nSize := 1
			EndCase
		EndIf
	EndIf
	If nSize <= 3
		nLinha := nSize
	Else
		nLinha := 3
	EndIf
	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption OF oDlgAviso PIXEL
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgAviso SIZE aSize[nSize][3],aSize[nSize][4] NOBORDER WHEN .F. PIXEL ADJUST 
	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
	If cBitmap <> Nil
		@ 2, 37 BITMAP RESNAME cBitmap oF oDlgAviso SIZE 18,18 NOBORDER WHEN .F. PIXEL
		@ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	Else
		@ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	EndIf
	If nSize < 3
		@ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
	Else
		If !lEdit
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
		Else
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] MEMO
		EndIf
	EndIf
	If Len(aBotoes) > 1 .Or. nTimer <> Nil
		TButton():New(1000,1000," ",oDlgAviso,{||Nil},82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	EndIf
	ny := 38
	l1 := .T.
	For nx:=1 to Len(aBotoes)
		cAction:="{||nOpcAviso:="+Str(nx)+",oDlgAviso:End()}"
		bAction:=&(cAction)
		cMsgButton:= OemToAnsi(AllTrim(aBotoes[nx]))
		cMsgButton:= IF(  "&" $ Alltrim(cMsgButton), cMsgButton ,  "&"+cMsgButton )
		if l1
			TButton():New(aSize[nLinha][7]-15,ny,cMsgButton, oDlgAviso,bAction,82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		Else
			TButton():New(aSize[nLinha][7]   ,ny,cMsgButton, oDlgAviso,bAction,82,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		Endif
		ny += 85
		if ny > 150
			ny := 38
			l1 := .F.
		endif
	Next nx
	If nTimer <> Nil
		oTimer := TTimer():New(nTimer,{|| nOpcAviso := nOpcPadrao,IIf(nPass==0,nPass++,oDlgAviso:End()) },oDlgAviso)
		oTimer:Activate()
		bAction:= {|| oTimer:DeActivate() }
		TButton():New(aSize[nLinha][7],ny,"Timer off", oDlgAviso,bAction,52,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Endif
	ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
	If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
		cMensagem += " " + aBotoes[nRotAutDefault]
		nOpcAviso := nRotAutDefault
	Endif
	ConOut(Repl("*",40))
	ConOut(cCaption)
	ConOut(cMensagem)
	ConOut(Repl("*",40))
	AutoGrLog(cCaption)
	AutoGrLog(cMensagem)
EndIf

Return (nOpcAviso)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MyAviso   ∫Autor  ≥ Eneo               ∫ Data ≥             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Interface/Dialog de Aviso.                                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Geral                                                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function TelaJust( cChv ,cJust ) //GETESB2
Local cRet := Substr( AllTrim(cJust) + Space(255) , 1, 255 )
Local oDlg, oJus, oChv
Local nOpc := 1

DEFINE MSDIALOG oDlg TITLE "Justificativa OperaÁ„o N„o Realizada" FROM 0,0 TO 185,680 OF oDlg PIXEL

@ 006,006 Say "Chave: " PIXEL OF oDlg
@ 016,006 GET oChv VAR cChv PICTURE "@!" SIZE 150,08 PIXEL OF oDlg WHEN .F. 

@ 030,006 Say "Justificativa: " PIXEL OF oDlg
@ 040,006 GET oJus VAR cRet MULTILINE SIZE 290,30 PIXEL OF oDlg Valid( cccc(@cRet) )
 
@ 080,195 BUTTON "Cancelar" SIZE 35,12 PIXEL OF oDlg Action(nOpc:= 0,oDlg:End())
@ 080,235 BUTTON "Salvar" SIZE 35,12 PIXEL OF  oDlg Action(nOpc:= 1,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

if nOpc == 0 .or. empty(cRet)
	cRet := "-1"
endif

Return( cRet )

Static Function cccc(cRet)
Local lRet := .T.
if len( alltrim( cRet ) ) > 255
	U_MyAviso("Aviso","Limite de Caracteres 255",{"OK"},3)
	cRet := Substr(cRet,1,255)
endif
Return( lRet )




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MyAviso   ∫Autor  ≥ Eneo               ∫ Data ≥             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ F3 para escolher cnpj.                                     ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Geral                                                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function HFXML6SM(cCnpj)
Local lRet      := .F.
Local aArea     := GetArea()
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize( .F. )
Local aStru     := {}
Local cArq, _cIndice, _dIndex := ""

PRIVATE aHeader := {}

aStru := Temporario("SM0")
cArq  := CriaTrab(aStru, .T.)
DBUseArea(.T., __LocalDriver, cArq, "MAT", .T., .F.)

DbSelectArea("MAT")
_cIndice := CriaTrab(nil,.F.)
_dIndex := "M0_CODIGO+M0_CODFIL"
IndRegua("MAT",_cIndice,_dIndex,,)

DbSelectArea("SM0")
nReg := SM0->( recno() )
SM0->( dbGoTop() )
Do While .Not. SM0->( Eof() )
		DbSelectArea("MAT")
   		RecLock( "MAT", .T. )
		FOR nI := 1 TO MAT->( FCount() )
			nPos := SM0->( FieldPos( MAT->( FieldName( nI ) ) ) )
			If nPos > 0
				MAT->( FieldPut( nI, SM0->(FieldGet(nPos)) ) )
			EndIf
		NEXT nI
		MAT->( dbUnLock() )
		DbSelectArea("SM0")
		SM0->( dbSkip() )
EndDo

SM0->( dbGoto(nReg) )
DbSelectArea("MAT") 
dbGoTop()

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Calcula as coordenadas da interface                                 ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		aSize[1] /= 1.5
		aSize[2] /= 1.5
		aSize[3] /= 1.5
		aSize[4] /= 1.3
		aSize[5] /= 1.5
		aSize[6] /= 1.3
		aSize[7] /= 1.5

		AAdd( aObjects, { 100, 020,.T.,.F.,.T.} )
		AAdd( aObjects, { 100, 060,.T.,.T.} )
		AAdd( aObjects, { 100, 020,.T.,.F.} )
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj := MsObjSize( aInfo, aObjects,.T.)

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Interface com o usuario                                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Empresas") FROM aSize[7],000 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	  	oGetDb := MsGetDB():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"Allwaystrue","allwaystrue","",.F., , ,.F., ,"MAT")

		DEFINE SBUTTON FROM aPosObj[3,1]+000,aPosObj[3,4]-030 TYPE 1 ACTION (nOpcA := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM aPosObj[3,1]+012,aPosObj[3,4]-030 TYPE 2 ACTION (nOpcA := 0,oDlg:End()) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpcA == 1
			lRet := .T.
			cCnpj := SM0->M0_CGC
		EndIf

DbSelectArea("MAT")
dbclosearea()

Ferase(cArq+GetDBExtension())
Ferase(cArq+OrdBagExt())

RestArea( aArea )
Return( lRet )



//Gera Estrutura para arquivo Tempor·rio a Partir do SigaMat
Static Function Temporario(cAlias)
Local aStr  := {}
Local aStru := {}
Local cTit  := ""
Local nI := 0

DbSelectArea(cAlias)
aStr := dbStruct()

For ni := 1 to Len(aStr)
	If AllTrim( aStr[ni][1] ) $ "M0_CODIGO,M0_CODFIL,M0_FILIAL,M0_NOME,M0_CGC"
		aaDd(aStru,aStr[ni])
	EndIF
Next

aHeader := {}
For ni := 1 to Len(aStru)
		cTit := iif(alltrim(aStru[ni][1])=="M0_CODIGO", "Empresa",;
		        iif(alltrim(aStru[ni][1])=="M0_CODFIL", "Cod.Fil.",;
		        iif(alltrim(aStru[ni][1])=="M0_CGC"   , "CNPJ",;
		        iif(alltrim(aStru[ni][1])=="M0_FILIAL", "Filial",;
		        iif(alltrim(aStru[ni][1])=="M0_NOME"  , "Nome",;
		            aStru[ni][1] )))))
 		aAdd(aHeader,{ cTit, ;
                     aStru[ni][1]   , ;
                     iif(alltrim(aStru[ni][1])=="M0_CGC", "@R 99.999.999-9999-99", "@!"), ;
                     aStru[ni][3] , ;
                     aStru[ni][4] , ;
                        , ;
                        , ;
                        , ;
                        , ;
                              } )
Next ni

Return( aStru )


//Checar se CNPJ esta no sigamat com licenÁa
Static Function ChkCnpj(cCnpj)
Local lRet  := .F.
Local aArea := GetArea()
Local nRecFil

DbSelectArea("SM0")
nRecFil := Recno()
DbGotop()
While !Eof()
	If Alltrim(SM0->M0_CGC) == Alltrim(cCnpj)
		If U_HFXML00X("HF000001","101",SM0->M0_CGC,,.F.)
			lRet  := .T.
			Exit
		EndIF
	EndIf

	DbSkip()

EndDO

If .Not. lRet
	Alert( "CNPJ n„o encontrado ou sem LicenÁa!!!" )
EndIf

SM0->( dbGoto(nRecFil) )
RestArea(aArea)
Return( lRet )



/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ HFXML6CD ∫Autor  ≥ Eneo               ∫ Data ≥             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Consultar CNPJ do Destinat·rio via WS.                     ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Geral                                                      ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function HFXML6CD(cCnpj, lMostra, cLogProc, nImp)
Local lRet   := .F.
Local cURL   := ""
Local cAmb   := "1"
Local cXml   := ""
Local cIdEnt := U_GetIdEnt()
Local cUF    := VerUfMat( cCnpj )
Local cVerLay:= "1.01"
Local cNSU   := AllTrim(GetNewPar("XM_NSU","00000000000"))
Local cIndCon:= "1"
Local cErro,cWarning
Local cSitConf  := ""
Local cChaveXml := Space(44)
Local cCancNSU  := ""
Local nVzNaoSinc:= 0
Local nOrd := 0

Default cLogProc := ""
Default nImp     := 2

Private cTagNfe, cTagCan, cTagCce, oWs, oWsrNfe, oWsdNfe, aDocs, nX

cInfo := ""
cMsg  := ""

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

dbSelectArea( "TMP" )
Zap
oWSdNfe :=WSMANIFESTACAODESTINATARIO():New()
oWSdNfe:cUserToken   := "TOTVS"
oWSdNfe:cIDENT	     := cIdEnt
oWSdNfe:cAMBIENTE	 := "1"
oWSdNfe:cINDNFE		 := "0"
oWSdNfe:cINDEMI      := "0"
oWSdNfe:_URL         := AllTrim(cURL)+"MANIFESTACAODESTINATARIO.apw"

Do While cIndCon == "1"
	If oWSdNfe:SINCRONIZARDOCUMENTOS()
		cIndCon := oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:cIndCont
		cAmb    := oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:cAMBIENTE
		If Type ("oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO") <> "U"
			nVzNaoSinc := 0
			If Type("oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO")=="A"
				aDocs := oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO
			Else
				aDocs := {oWSdNfe:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO}
			EndIf

			For nX := 1 To Len(aDocs)
				If Type(aDocs[nX]:CCHAVE) <> "U" .and. Type(aDocs[nX]:CSITCONF) <> "U"
				    cSitConf  := aDocs[nX]:CSITCONF
				    cChaveXml := aDocs[nX]:CCHAVE
				    cCancNSU  := aDocs[nX]:CCANCNSU
					if nImp == 2
						DbSelectArea( "ZBZ" )  //AQUIIIIIIII
						nOrd := ZBZ->( IndexOrd() )
						ZBZ->( DbSetORder( 3 ) )
						If ZBZ->( dbSeek( cChaveXml ) )
							ZBZ->( DbSetORder( nOrd ) )
							DbSelectArea( "TMP" )
							LOOP
						EndIf
						ZBZ->( DbSetORder( nOrd ) )
						DbSelectArea( "TMP" )
					Endif
					If .Not. TMP->(dbSeek( cChaveXml ) )
						lRet := .T.
						RecLock( "TMP", .T. )
						TMP->ST    := " "
						TMP->CHAVE := cChaveXml
						TMP->AMB   := cAmb
						TMP->DEST  := cCnpj
					Else
						RecLock( "TMP", .F. )
					Endif
					TMP->CSITCONF := cSitConf

   					oWSdNfe:cAMBIENTE	 := cAmb
					oWSdNfe:cCHAVE		 := cChaveXml

				    If oWSdNfe:RETORNARDOCUMENTO()
				    	if Type ("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO") <> "U"
				    		
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cCNPJ") <> "U"
								TMP->CNPJ_EMI := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cCNPJ
							Endif
							if Empty(TMP->CNPJ_EMI) .And. Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cCPF") <> "U"
								TMP->CNPJ_EMI := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cCPF
							endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cDATAEMISSAO") <> "U"
								TMP->DEMI     := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cDATAEMISSAO
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:nVALORTOTAL") <> "U"
								TMP->VNF      := AllTrim(Str(oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:nVALORTOTAL))
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cNOME") <> "U"
								TMP->XNOME    := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cNOME
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cIE") <> "U"
								TMP->IE       := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSEMITENTE:cIE
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cXMLSEFAZ") <> "U"
								TMP->DIGVAL   := VerDigVal( oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cXMLSEFAZ )
							EndIf
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cDATAAUTORIZACAO") <> "U"
								TMP->DHRECBTO := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cDATAAUTORIZACAO
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cSITUACAO") <> "U"
								TMP->CSITNFE  := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cSITUACAO
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cNSU") <> "U"
								TMP->NSU      := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:cNSU
							Endif
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSCCE:cCORRECAO") <> "U"
								TMP->Correcao := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSCCE:cCORRECAO
							EndIf
							If Type("oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSCANCELAMENTO:cCANCXMLRET") <> "U"
								TMP->XMLCANC  := oWSdNfe:OWSRETORNARDOCUMENTORESULT:OWSDOCUMENTO:OWSCANCELAMENTO:cCANCXMLRET
							Endif
						Endif
					EndIf

//Aqui era para fazer a baixa, mas ele necessita de manifestaÁ„o igual o nosso ent„o por enquanto deixa do 
//nosso jeito
//					oWSdNfe:oWSDOCUMENTOS:oWSDOCUMENTO := MANIFESTACAODESTINATARIO_ARRAYOFBAIXARDOCUMENTO():New() 
//					aadd(oWSdNfe:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
//					oWSdNfe:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[1]:CCHAVE := cChaveXml
//					if oWSdNfe:BAIXARXMLDOCUMENTOS()
//						If Type("oWSdNfe:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
//							If Type("oWSdNfe:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
//								oDet := oWSdNfe:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
//							Else
//								oDet := {oWSdNfe:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
//							Endif
//							cXml := oDet[1]:CNFEZIP
//							If !Empty(cXml) .AND. !'<NFe' $ cXml
//								cXml := Decode64(cNfeZip)
//							EndIf
//							TMP->XML := cXml
//						EndIf
//					endif

					TMP->( MsUnLock() )
					If TMP->(RecCount()) > 0 .and. Val(TMP->NSU) > Val(cNSU)
						cNSU := AllTrim( TMP->NSU )
						If !PutMv("XM_NSU", cNSU ) 
							RecLock("SX6",.T.)
							SX6->X6_FIL     := xFilial("SX6")
							SX6->X6_VAR     := "XM_NSU"
							SX6->X6_TIPO    := "C"
							SX6->X6_DESCRIC := "NSU" 
							MsUnLock()
							PutMv("XM_NSU", cNSU ) 
						endIf
						SX6->(dbcommit())
					EndIf
				EndIf	
			Next                   
        Else
			nVzNaoSinc++
			if nVzNaoSinc >= 3
				cIndCon := "0"
				cInfo   := "Metodo SINCRONIZARDOCUMENTOS() n„o retornou documentos em OWSSINCDOCUMENTOINFO."
				If lMostra
					U_MyAviso("SPED",cInfo,{"OK"},3)
				Endif
			endif
		EndIf
	Else
		nVzNaoSinc++
		if nVzNaoSinc >= 3
			cIndCon := "0"
			cInfo   := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			If lMostra
				U_MyAviso("SPED",cInfo,{"OK"},3)
			Endif
		endif
	EndIf

	if .Not. Empty( cInfo )
		cLogProc += cInfo + CRLF
	endif
	if cIndCon == "1"
		Sleep(2000) //Tempo para prÛxima execuÁ„o do mÈtodo SINCRONIZARDOCUMENTOS()
	endif
EndDo

oWSdNfe := Nil
DelClassIntf()

Return( lRet )


Static Function VerDigVal( cXml )
Local cErro:= "", cWarning:= ""
Local cRet := ""
Private oWSrNfe

cXml := NoAcento(cXml)
cXml := EncodeUTF8(cXml)
			
oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
If oWSrNfe <> NIL .And. Empty(cErro)
	if Type( "oWSrNfe:_RESNFE:_DIGVAL:TEXT" ) <> "U"
		cRet := oWSrNfe:_RESNFE:_DIGVAL:TEXT
	Endif
Endif

Return cRet



Static Function VerAmbiente(cAmb,cEntidade)
Local aArea  := GetArea()
Local cRet   := ""

if Select( "SPED000" ) > 0
	cRet := SpedGetMV("MV_AMBIENT",cEntidade)
Else
	InitSped()
	InitNfeSped()
	cRet := SpedGetMV("MV_AMBIENT",cEntidade)
	FinishNfeSped()
	FinishSped(.T.,.F.)
EndIf

If empty(cRet) .or. (cRet <> "1" .and. cRet <> "2")
	cRet := cAmb
EndIf

RestArea(aArea)
Return( cRet )


Static Function VerUfMat( cCnpj )
Local cRet := "91"
Local aArea := GetArea()
Local nRecFil
Local aUf := {}

aadd(aUf, {"AN","91"} )
aadd(aUf, {"RO","11"} )
aadd(aUf, {"AC","12"} )
aadd(aUf, {"AM","13"} )
aadd(aUf, {"RR","14"} )
aadd(aUf, {"PA","15"} )
aadd(aUf, {"AP","16"} )
aadd(aUf, {"TO","17"} )
aadd(aUf, {"MA","21"} )
aadd(aUf, {"PI","22"} )
aadd(aUf, {"CE","23"} )
aadd(aUf, {"RN","24"} )
aadd(aUf, {"PB","25"} )
aadd(aUf, {"PE","26"} )
aadd(aUf, {"AL","27"} )
aadd(aUf, {"SE","28"} )
aadd(aUf, {"BA","29"} )
aadd(aUf, {"MG","31"} )
aadd(aUf, {"ES","32"} )
aadd(aUf, {"RJ","33"} )
aadd(aUf, {"SP","35"} )
aadd(aUf, {"PR","41"} )
aadd(aUf, {"SC","42"} )
aadd(aUf, {"RS","43"} )
aadd(aUf, {"MS","50"} )
aadd(aUf, {"MT","51"} )
aadd(aUf, {"GO","52"} )
aadd(aUf, {"DF","53"} )

DbSelectArea("SM0")
nRecFil := Recno()
DbGotop()
While !Eof()
	If Alltrim(SM0->M0_CGC) == Alltrim(cCnpj)
		If U_HFXML00X("HF000001","101",SM0->M0_CGC,,.F.)
			nPos := aScan( aUf,{ |x| x[1]==SM0->M0_ESTENT } )
			if nPos > 0
				cRet := aUf[nPos][2]
				Exit
			Endif
		Else
			nPos := aScan( aUf,{ |x| x[1]==SM0->M0_ESTENT } )
			if nPos > 0
				cRet := aUf[nPos][2]
			Endif
		EndIF
	EndIf

	DbSkip()

EndDO

SM0->( dbGoto(nRecFil) )
RestArea(aArea)
Return( cRet )



/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06Vis≥ Autor ≥ Eneo                  ≥ Data ≥28/05/2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Visualizar Registro, quando for consulta por CNPJ mostrar· ≥±±
±±≥          ≥ os dados adicionais                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06Vis()
Local oDlg
Private oFont01:= TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private oFont02:= TFont():New("Lucida Console",07,14,,.T.,,,,.T.,.F.)
Private oFont03:= TFont():New("Arial",05,10,,.F.,,,,.f.,.F.) 

Private aPages := {"Gerais","NF-e","Carta CorreÁ„o"}
Private nPageGer := aScan(aPages,{|x| x == "Gerais"})
Private nPageNfe := aScan(aPages,{|x| x == "NF-e"})
Private nPageCCe := aScan(aPages,{|x| x == "Carta CorreÁ„o"})

DEFINE MSDIALOG oDlg TITLE "VisualizaÁ„o Registro" FROM 000,000 TO 430,800 PIXEL STYLE DS_MODALFRAME STATUS

oPage := TFolder():New(002,002,aPages,{},oDlg,,,,.T.,.F.,350,210,)
    
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageGer]

	@ 010,010 Say "Chave: " PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oObj VAR TMP->CHAVE SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageGer]                   

	@ 040,010 Say "CNPJ Destinat·rio: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 048,010 Get oObj VAR TMP->DEST SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageGer] 

	@ 070,010 Say "Mensagem Retorno WS: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 078,010 Get oObj VAR TMP->MSG SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageGer] 

	@ 100,010 Say "Mensagem Erro WS: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 108,010 Get oObj VAR TMP->ERRO MULTILINE SIZE 300,50 When .F. PIXEL OF oPage:aDialogs[nPageGer] 

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageNfe]

	@ 010,010 Say "ManifestaÁ„o do Destinat·rio: " PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oObj VAR TMP->CSITCONF SIZE 10,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe]                   
	@ 018,030 Say "0=S/Manif.     1=Conf.Oper." PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont03
	@ 022,030 Say "2=Desconhecida 3=Oper.N„o Real. 4=CiÍncia" PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont03

	@ 010,170 Say "CNPJ Emitente: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 018,170 Get oObj VAR TMP->CNPJ_EMI SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 040,010 Say "Data Emiss„o: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 048,010 Get oObj VAR TMP->DEMI SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 040,170 Say "Emitente: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 048,170 Get oObj VAR TMP->XNOME SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 070,010 Say "Valor da NFe: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 078,010 Get oObj VAR TMP->VNF SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 070,170 Say "IE Emitente: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 078,170 Get oObj VAR TMP->IE SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 100,010 Say "ValidaÁ„o: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 108,010 Get oObj VAR TMP->DIGVAL SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 100,170 Say "AutorizaÁ„o: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 108,170 Get oObj VAR TMP->DHRECBTO SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 130,010 Say "NSU: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 138,010 Get oObj VAR TMP->NSU SIZE 150,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 

	@ 130,170 Say "SituaÁ„o NFe: "  PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont01
	@ 138,170 Get oObj VAR TMP->CSITNFE SIZE 10,08 When .F. PIXEL OF oPage:aDialogs[nPageNfe] 
	@ 140,190 Say "1=Uso autorizado 2=Uso denegado 3=NF-e cancelada" PIXEL OF oPage:aDialogs[nPageNfe] COLOR CLR_BLUE FONT oFont03

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageCce]
	@ 010,010 Say "Carta de CorreÁ„o: "  PIXEL OF oPage:aDialogs[nPageCce] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oObj VAR TMP->Correcao MULTILINE SIZE 310,140 When .F. PIXEL OF oPage:aDialogs[nPageCce] 

	@ 012,355 Button "Sair" Size 040,015 PIXEL OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (nOpca := 0,.T.)

Return(NIL)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ HFXML6JB ≥ Autor ≥ Eneo                  ≥ Data ≥30/05/2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Job autom·tico para Consultar e Baixar XML do SEFAZ.       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function HFXML6JB(lAuto,lEnd,oProcess,cLogProc,nCount,lMostra)
Local aArea   := GetArea()
Local nRegMat := SM0->( Recno() )
Local cEmpres := SM0->M0_CODIGO
Local cCnpj   := ""
Local cArq    := ""

Default cLogProc := ""
Default lAuto    := .F.
Default oProcess := Nil
Default lEnd     := .F.
Default nCount   := 0
Default lMostra  := .F.

cLogProc := "### Download XML no Sefaz Iniciada ###"+CRLF
cLogProc += dToC(date()) +"-"+ Substr(Time(),1,2) + "-" + Substr(Time(),4,2)+CRLF

cArq := CriaTMP()

If cArq == NIL .OR. Empty( cArq )
	cLogProc += "Erro ao criar arquivo Tempor·rio"+CRLF
	cLogProc += "### Download XML no Sefaz Finalizada ###"+CRLF
	RestArea(aArea)
	Return(NIL)
Endif

If Select("TMP") > 0
	TMP->( dbCloseArea() )
EndIf
dbUseArea(.T.,, cArq,"TMP", .F., .F.) //exclusivo
IndRegua("TMP",cArq+"A","CHAVE" )

SM0->( dbGoTop() )
Do While .Not. SM0->( Eof() )
	if cEmpres != SM0->M0_CODIGO
		SM0->( dbSkip() )
		Loop
	endif
	cCnpj := SM0->M0_CGC
	If U_HFXML00X("HF000001","101",cCnpj,,.F.)
		cLogProc += "Iniciado CNPJ "+cCnpj+CRLF
		dbSelectarea( "TMP" )
		ZAP
		If U_HFXML6CD(cCnpj, lMostra, @cLogProc)
			Do While .Not. JobManif(@cLogProc)
			EndDo
			Do While .Not. JobBaixa(@cLogProc)
			EndDo
		Else
			cLogProc += "SEFAZ n„o disponibilizou XML"+CRLF
		EndIf
		cLogProc += "Finalizado CNPJ "+cCnpj+CRLF
	Else
		cLogProc += "Sem LicenÁa CNPJ "+cCnpj+CRLF
	Endif
	dbSelectarea( "SM0" )
	SM0->( dbSkip() )
EndDo

cLogProc += "### Download XML no Sefaz Finalizada ###"+CRLF
SM0->( dbgoto( nRegMat ) )
TMP->( dbCloseArea() )
fErase( cArq+GetDBExtension() )
RestArea( aArea )
Return NIL



Static Function JobManif(cLogProc)
Local lRet   := .F.
Local cChave := ""
Local cEvent := ""
Local cEve   := "210210"
Local cxJst  := ""
Local nLote  := 1
Local nChv   := 0
Local cCnpj  := SM0->M0_CGC  //"61135471000100"
Local cURL   := ""
Local cXml   := ""
Local cNfe   := ""
Local cAmb   := ""
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local lTemPr := .F.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWS,oWsrNfe,oWsdNfe,cErro,cWarning

cURL    := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

cEve := "210210"

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""	
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1) 
EndIf

TMP->( dbgotop() )
Do While .not. TMP->( Eof() ) .and. nChv < 20
	if TMP->CSITCONF == "0" //.And. VerData( TMP->DHRECBTO ) < (dDataBase - 1)
		cCnpj  := TMP->DEST
		cChave += TMP->CHAVE+";"
		cEvent += cEve+";"
		cxJst  += " ;"
		cLogProc += "Verificando ManifestaÁ„o " + TMP->CHAVE + CRLF

		nChv++
		if cAmb <> "1"
			cAmb := TMP->AMB
		endif
		RecLock( "TMP", .F. )
		TMP->CSITCONF := "1"
		TMP->( MsUnLock() )
	endif
	TMP->( dbskip() )
Enddo

if nChv <= 0
	return( .T. )
ElseIf nChv < 20
	lRet := .T.
endif

// Tratamento da numeracao do lote
nLote := ( GetNewPar("XM_LOTEMAN",0) + 1 )
If !PutMv("XM_LOTEMAN",nLote)
	SX6->(RecLock("SX6",.T.))
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "XM_LOTEMAN"
	SX6->X6_TIPO    := "N"
	SX6->X6_DESCRIC := "Lote do Evento de Manifestacao"
	SX6->(MsUnLock())
	PutMv("XM_LOTEMAN",nLote)
EndIf

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLMANIFESTO():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
oWsdNfe:cCLOTE        := strzero(nLote,15,0)
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "91"
oWSdNfe:cCHORAVERAO   := cHrVerao
oWSdNfe:cCHORARIO     := cHorario
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave
oWSdNfe:cCEVSTR       := cEvent
oWSdNfe:cCXJUST       := cxJst  //AQUIIII

if oWSdNfe:HFMANISFESTO()
	cXml := oWSdNfe:cHFMANISFESTORESULT
	nAt1:= At('<RETENVEVENTO ',Upper(cXml))
	nAt2:= At('</RETENVEVENTO>',Upper(cXml))+ 15
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETENVEVENTO>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 15
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta da ManifestaÁ„o"
			cInfo  := cErro + " " + cWarning
			cLogProc += cMsg + CRLF
			lTodos := .T.
		elseIf oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT <> "128"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETENVEVENTO:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETENVEVENTO:_XMOTIVO:TEXT
			lTodos := .T.
			cLogProc += cMsg + CRLF
		Else
			oDet := oWSrNfe:_RETENVEVENTO:_RETEVENTO
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_INFEVENTO:_CSTAT:TEXT <> "135"
					cMsg  := oDet[nI]:_INFEVENTO:_CSTAT:TEXT
					cInfo := cChave + " " +oDet[nI]:_INFEVENTO:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cStt  := "2"
					cMsg  := "ManifestaÁ„o Efetuada"
					cInfo := cChave + " " +"ManifestaÁ„o Efetuada do XML "
				Endif
				cLogProc += cInfo + CRLF
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz na ManifestaÁ„o."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETENVEVENTO>"
		cLogProc += cInfo + CRLF
	EndIf	
else
	//Erro TSS ou WS n„o instalado.
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	cLogProc += cInfo + CRLF
endif

Return( lRet )


Static Function JobBaixa(cLogProc)
Local lRet   := .F.
Local nChv   := 0
Local cURL   := ""
Local cDir   := AllTrim(SuperGetMv("MV_X_PATHX"))
Local cXml   := ""
Local cChave := ""
Local cAmb   := ""
Local cNfe   := ""
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local nHandle:= 0
Local lOk    := .T.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWs,oWsrNfe,oWsdNfe,cErro,cWarning

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""	
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1) 
EndIf

TMP->( dbgotop() )
Do While .not. TMP->( Eof() ) .and. nChv < 10
	if TMP->OK <> "Pr"
		cCnpj  := TMP->DEST
		cChave += TMP->CHAVE+";"
		cLogProc += "Verificando Disponibilidade Baixa " + TMP->CHAVE + CRLF

		nChv++
		if cAmb <> "1"
			cAmb := TMP->AMB
		endif
		RecLock( "TMP", .F. )
		TMP->OK := "Pr"
		TMP->( MsUnLock() )
	endif
	TMP->( dbskip() )
Enddo

if nChv <= 0
	return( .T. )
ElseIf nChv < 10
	lRet := .T.
endif


If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSHFXMLDOWLOAD():New()
oWSdNfe:Init()
oWSdNfe:cCIDENT       := cIdEnt
//oWSdNfe:_URL          := cURL
oWSdNfe:cCCURL        := cURL
oWSdNfe:cCAMBIENTE    := cAmb
oWSdNfe:cCVERSAODADOS := cVerLayEven
oWSdNfe:cCCUF         := "AN"
oWSdNfe:cCCNPJ        := cCnpj
oWSdNfe:cCCHSTR       := cChave

if oWSdNfe:HFBAIXAXML()
	cXml := oWSdNfe:cHFBAIXAXMLRESULT
	nAt1:= At('<RETDOWNLOADNFE ',Upper(cXml))
	nAt2:= At('</RETDOWNLOADNFE>',Upper(cXml))+ 17
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETDOWNLOADNFE>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 17
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta"
			cInfo  := cErro + " " + cWarning
			cLogProc += cMsg + CRLF
		elseIf oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT <> "139"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETDOWNLOADNFE:_XMOTIVO:TEXT
			cLogProc += cInfo + CRLF
		Else
			oDet := oWSrNfe:_RETDOWNLOADNFE:_RETNFE
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_CSTAT:TEXT <> "140"
					cMsg  := oDet[nI]:_CSTAT:TEXT
					cInfo := oDet[nI]:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cChave := cDir + alltrim( oDet[nI]:_CHNFE:TEXT ) + "-procNfe.xml"
					oXml := oDet[nI]:_PROCNFE:_NFEPROC

					SAVE oXml XMLSTRING cXML
					nAt1:= At('<NFE ',Upper(cXml))
					nAt2:= At('</NFE>',Upper(cXml))+ 6
					//Corpo da Nfe
					If nAt1 <=0
						nAt1:= At('<NFE>',Upper(cXml))
					EndIf 	
					If nAt1 > 0 .And. nAt2 > 6
						cNfe := Substr(cXml,nAt1,nAt2-nAt1)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo := "XML "+oDet[nI]:_CHNFE:TEXT+" sem TAG <NFE>"
					EndIf	
					nAt3:= At('<PROTNFE ',Upper(cXml))
					nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
					//Protocolo	
					If nAt3 > 0 .And. nAt4 > 10
						cProt := Substr(cXml,nAt3,nAt4-nAt3)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo += "XML "+oDet[nI]:_CHNFE:TEXT+" sem Protocolo, falta TAG <PROTNFE>"
					EndIf
					
					if empty( cMsg )
						//cXml:= '<?xml version="1.0"?>'
						cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
						cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
						cXml+= cNfe
						cXml+= cProt
						cXml+= '</nfeProc>'
						cXml := NoAcento(cXml)
						cXml := EncodeUTF8(cXml)
						oXml := XmlParser( cXml, "_", @cErro, @cWarning )
						
						if oXML == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
							cStt  := "0"
							cMsg  := "Erro Parser do XML"
							cInfo := cErro + " " + cWarning
						Else
							SAVE oXML XMLFILE cChave
							nHandle := FT_FUse( cChave )
							if nHandle == -1
								cStt  := "0"
								cMsg  := "Erro GravaÁ„o"
								cInfo := "Erro de GravaÁ„o XML no DiretÛrio "+cChave
							else
								cStt  := "1"
								cMsg  := "Download Efetuado"
								cInfo := "Download Efetuado do XML "+cChave
							endif
							FT_FUSE()
						EndIf
					Endif

				Endif
				cLogProc += cInfo + CRLF
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETDOWNLOADNFE>"
		cLogProc += cInfo + CRLF
	EndIf	
else
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	cLogProc += cInfo + CRLF
endif

Return( lRet )


Static Function VerData( cDatRec )
Local dDat := ctod( "" )
Local cDat := ""

cDat := Substr( cDatRec,9,2 ) + "/" + Substr( cDatRec,6,2 ) + "/" + Substr( cDatRec,1,4 )

dDat := ctod( cDat )

Return(dDat)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥HFXML06NSU≥ Autor ≥ Eneo                  ≥ Data ≥30/05/2015≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Tela para Editar Par‚metro NSU para rotina consultaDest.   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Analista Resp.≥  Data  ≥ Bops ≥ Manutencao Efetuada                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥              ≥        ≥      ≥                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function HFXML06NSU()
Local lRet 			:= .T.
Local cNsu          := Space(11)
Local cAmb          := " "
Local cIdEnt 		:= U_GetIdEnt()
Local nOpc 			:= 1
Local oWs,cURL,oDlg,oNsu,oAmb

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWs:= WSHFXMLCFG():New()
oWs:Init()
oWs:cCIDENT := cIdEnt
oWs:cCCURL  := cURL
if oWs:HFGETNSU()
	cNsu := oWs:cHFGETNSURESULT
	if Len( cNsu ) < 11
		cNsu := Substr(cNsu+Space(11),1,11)
	endif
else
	cNsu := Space(11)
endif
if oWs:HFGETMDAMB()
	cAmb := oWs:cHFGETMDAMBRESULT
	if Len( cAmb ) < 1
		cAmb := " "
	endif
else
	cAmb := " "
endif
DEFINE MSDIALOG oDlg TITLE "Par‚metro MV_MDNSU / MDAMB" FROM 0,0 TO 155,450 OF oDlg PIXEL

@ 003,006 Say "Digitar n˙mero do NSU inicial para executar o WS NFeConsultaDest, para Consultar" PIXEL OF oDlg
@ 009,006 Say "os XML emitidos contra o CNPJ e posterior Download do XML. Deixando 0 ou Branco," PIXEL OF oDlg
@ 015,006 Say "ou o NSU for anterior a 15 dias, o WS ir· consultar XML dos ˙ltimos 15 dias." 	 PIXEL OF oDlg
@ 021,006 Say "TambÈm o Ambiente para o WS NFeConsultaDest 1 - ProduÁ„o 2 - HologogaÁ„o "	 	 PIXEL OF oDlg

@ 027,006 Say "NSU: " PIXEL OF oDlg
@ 037,006 GET oNsu VAR cNsu Picture "@!" SIZE 100,10 PIXEL OF oDlg
@ 050,006 Say "Ambiente: " PIXEL OF oDlg
@ 060,006 GET oAmb VAR cAmb Picture "@!" SIZE 10,10	 PIXEL OF oDlg
 
@ 060,140 BUTTON "Cancelar" SIZE 35,12 PIXEL OF oDlg Action(nOpc:= 0,oDlg:End())
@ 060,180 BUTTON "Salvar" SIZE 35,12 PIXEL OF  oDlg Action(nOpc:= 1,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

if nOpc == 1
	oWs:cCIDENT := cIdEnt
	oWs:cCCURL  := cURL
	oWs:cCNSU   := cNsu

	if oWs:HFSETNSU()
		cNsu := oWs:cHFSETNSURESULT
		if cNsu == "NAO GRAVOU"
			Alert( "N„o Foi PossÌvel Gravar o Par‚metro MV_MDNSU...." )
			lRet := .F.
		Endif
	Else
		Alert( IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)) )
	endif

	oWs:cCIDENT := cIdEnt
	oWs:cCCURL  := cURL
	oWs:cCMDAMB := cAmb

	if oWs:HFSETMDAMB()
		cAmb := oWs:cHFSETMDAMBRESULT
		if cAmb == "NAO GRAVOU"
			Alert( "N„o Foi PossÌvel Gravar o Par‚metro MDAMB...." )
			lRet := .F.
		Endif
	Else
		Alert( IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)) )
	endif

endif

Return( lRet )


/*
FIM
###########################################################################################################
Abaixo - Rotinas feitas para Testes
*/


//Retorna 0 - OK
//Retorna 1 - Tem alguma manifestaÁıes para fazer
//Retorna 2 - SÛ Erro
/*
Static Function HFXML06BTss(cCnpj,aChave,cAmb,cIdEnt)
Local nReg   := TMP->( recno() )
Local nRet   := 0
Local nChv   := 0
Local cURL   := ""
Local cDir   := AllTrim(SuperGetMv("MV_X_PATHX"))
Local cXml   := ""
Local cNfe   := ""
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local aRetorno    := {}
Local oWs,oWsrNfe,oWsdNfe,cErro,cWarning

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf


If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WSNFeEBRA():New()
oWSdNfe:cUSERTOKEN        := "TOTVS"
oWSdNfe:cID_ENT           := cIdEnt
oWSdNfe:oWSNFEID          := NFEEBRA_NFESID():New()
oWSdNfe:oWSNFEID:oWSID    := NFEEBRA_ARRAYOFSTRING():New()
oWSdNfe:oWSRETORNANOTARESULT := NFEEBRA_NFE():New()
For nI := 1 To Len( aChave )
	aadd(aRetorno,{"","",aChave[nI],"","","",CToD("")})
	aadd(oWSdNfe:oWSNFEID:oWSID:cSTRING,aChave[nI])
	//Atail(oWSdNfe:oWSNFEID:oWSID):cSTRING := aChave[nI]
Next nI
oWSdNfe:_URL := AllTrim(cURL)+"/NFeEBRA.apw"


if oWSdNfe:RETORNANOTA()
	cXml := oWSdNfe:oWSRETORNANOTARESULT
	nAt1:= At('<RETDOWNLOADNFE ',Upper(cXml))
	nAt2:= At('</RETDOWNLOADNFE>',Upper(cXml))+ 17
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETDOWNLOADNFE>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 17
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta"
			cInfo  := cErro + " " + cWarning
			lTodos := .T.
			nRet   := 2
			//U_MyAviso("SPED",cInfo,{"OK"},3)
		elseIf oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT <> "139"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETDOWNLOADNFE:_XMOTIVO:TEXT
			lTodos := .T.
			nRet   := 2
			//U_MyAviso("SPED",cInfo,{"OK"},3)
		Else
			oDet := oWSrNfe:_RETDOWNLOADNFE:_RETNFE
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_CSTAT:TEXT <> "140"
					cMsg  := oDet[nI]:_CSTAT:TEXT
					cInfo := oDet[nI]:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cChave := cDir + alltrim( oDet[nI]:_CHNFE:TEXT ) + "-procNfe.xml"
					oXml := oDet[nI]:_PROCNFE:_NFEPROC

					SAVE oXml XMLSTRING cXML
					nAt1:= At('<NFE ',Upper(cXml))
					nAt2:= At('</NFE>',Upper(cXml))+ 6
					//Corpo da Nfe
					If nAt1 <=0
						nAt1:= At('<NFE>',Upper(cXml))
					EndIf 	
					If nAt1 > 0 .And. nAt2 > 6
						cNfe := Substr(cXml,nAt1,nAt2-nAt1)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo := "XML "+oDet[nI]:_CHNFE:TEXT+" sem TAG <NFE>"
					EndIf	
					nAt3:= At('<PROTNFE ',Upper(cXml))
					nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
					//Protocolo	
					If nAt3 > 0 .And. nAt4 > 10
						cProt := Substr(cXml,nAt3,nAt4-nAt3)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo += "XML "+oDet[nI]:_CHNFE:TEXT+" sem Protocolo, falta TAG <PROTNFE>"
					EndIf
					
					if empty( cMsg )
						//cXml:= '<?xml version="1.0"?>'
						cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
						cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
						cXml+= cNfe
						cXml+= cProt
						cXml+= '</nfeProc>'
						cXml := NoAcento(cXml)
						cXml := EncodeUTF8(cXml)
						oXml := XmlParser( cXml, "_", @cErro, @cWarning )
						
						if oXML == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
							cStt  := "0"
							cMsg  := "Erro Parser do XML"
							cInfo := cErro + " " + cWarning
						Else
							SAVE oXML XMLFILE cChave
							nHandle := FT_FUse( cChave )
							if nHandle == -1
								cStt  := "0"
								cMsg  := "Erro GravaÁ„o"
								cInfo := "Erro de GravaÁ„o XML no DiretÛrio "+cChave
							else
								cStt  := "1"
								cMsg  := "Download Efetuado"
								cInfo := "Download Efetuado do XML "+cChave
							endif
							FT_FUSE()
						EndIf
					Endif

				Endif
				if cStt == "1"
					nDow++
				else
					if alltrim(cMsg) == "633" //Falta de ManifestaÁ„o
						nMan++
					Else
						nErr++
					EndIf
				endif
				If TMP->(dbSeek( oDet[nI]:_CHNFE:TEXT ) )
					if alltrim(cMsg) == "633" //Falta de ManifestaÁ„o
						nRet := 1
					endif
					if cStt <> "1" .and. nRet <> 1
						nRet := 2
					endif
					RecLock( "TMP", .F. )
					if alltrim(cMsg) != "633" //Deixa marcado
						TMP->OK    := "  "
					endif
					TMP->ST    := cStt
					TMP->MSG   := cMsg
					TMP->ERRO  := cInfo
					TMP->( MsUnLock() )
				endif
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETDOWNLOADNFE>"
		//U_MyAviso("SPED",cInfo,{"OK"},3)
		lTodos := .T.
		nRet   := 2
	EndIf	
else
	//Erro TSS ou WS n„o instalado.
	nRet  := 2
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	//U_MyAviso("SPED",cInfo,{"OK"},3)
	lTodos := .T.
endif

if lTodos
	TMP->( dbgotop() )
	nChv := 0
	TMP->( DbGoto( pReg ) )
	Do While .not. TMP->( Eof() ) .And. nChv <= 10
		if TMP->OK == "Pr" // == cMarcaOK
			RecLock( "TMP", .F. )
			TMP->OK    := "  "
			TMP->ST    := "0"
			TMP->MSG   := cMsg
			TMP->ERRO  := cInfo
			TMP->( MsUnLock() )
			nChv++
			nErr++
		endif
		TMP->( dbskip() )
	Enddo
endif

TMP->( dbgoto( nReg ) ) //Volta ao Registro para dar continuidade
return( nRet )



Static Function HFXML06Ba2()
Local nReg   := TMP->( recno() )
Local nRet   := 0
Local nErr   := 0
Local nDow   := 0
Local cChave := ""
Local nChv   := 0
Local cCnpj  := SM0->M0_CGC  //"61135471000100"
Local cURL   := ""
Local cDir   := AllTrim(SuperGetMv("MV_X_PATHX"))
Local cXml   := ""
Local cNfe   := ""
Local cAmb   := ""
Local cIdEnt := U_GetIdEnt()
Local cInfo  := ""
Local cMsg   := ""
Local cStt   := ""
Local lTodos := .F.
Local nHandle:= 0
Local lOk    := .T.
Local cVerLayEven := "1.00"
Local cHrVerao    := "2"
Local cHorario    := "2"
Local oWs,oWsrNfe,oWsdNfe,cErro,cWarning

cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

oWS:=WsSpedCfgNfe():New()
oWS:cUSERTOKEN 	  	:= "TOTVS"
oWS:cID_ENT    		:= cIdEnt
oWS:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWS:cVERCCELAYOUT	:= ""
oWS:cVERCCELAYEVEN	:= ""
oWS:cVERCCEEVEN		:= ""	
oWS:cVERCCE			:= ""
oWS:cHORAVERAOCCE	:= ""
oWS:cHORARIOCCE		:= ""
oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
lOk:=oWS:CfgCCe()

If lOk
	cVerLayEven	:= oWs:oWsCfgCCeResult:cVerCCeLayEven
	cHrVerao 	:= Left(oWS:oWsCfgCCeResult:cHoraVeraoCCe,1)
	cHorario 	:= Left(oWS:oWsCfgCCeResult:cHorarioCCe,1) 
EndIf

TMP->( dbgotop() )
cCnpj  := TMP->DEST
Do While .not. TMP->( Eof() ) .and. nChv < 10
	if .not. empty( TMP->OK ) // == cMarcaOK
		cChave += TMP->CHAVE+";"
		nChv++
		if cAmb <> "1"
			cAmb := TMP->AMB
		endif
		RecLock( "TMP", .F. )
		TMP->OK := "Pr"
		TMP->( MsUnLock() )
	endif
	TMP->( dbskip() )
Enddo

if nChv <= 0
	U_MyAviso("Msg","Nenhuma chave selecionada para download !!!!",{"OK"},3)
	TMP->( dbgoto( nReg ) )
	return( nRet )
endif

If Right( AllTrim(cURL), 1 ) != "/"
	cURL := AllTrim(cURL)+"/"
EndIf

oWSdNfe:= WsNFeEBra():New()
oWSdNfe:cUserToken   := "TOTVS"
oWSdNfe:cID_ENT      := cIdEnt
oWSdNfe:_URL         := AllTrim(cURL)+"/NFeEBRA.apw"
oWs := NFEEBRA_ARRAYOFSTRING():New()
TMP->( dbgotop() )
cCnpj  := TMP->DEST
Do While .not. TMP->( Eof() )
	aadd( oWs:cstring, TMP->CHAVE )
	TMP->(dbskip())
EndDo
oWSdNfe:OWSNFEID := oWs
oWs := NFEEBRA_ARRAYOFNFES():New()
TMP->( dbgotop() )
cCnpj  := TMP->DEST
Do While .not. TMP->( Eof() )
	aadd( oWs:OWSNFES, NFEEBRA_NFES():New() )
	oWs:OWSNFES[1]:CID  := ""
	oWs:OWSNFES[1]:CXML := ""
	TMP->(dbskip())
EndDo
oWSdNfe:OWSRETORNANOTARESULT:OWSNOTAS := oWs

if oWSdNfe:RETORNANOTA()
	cXml := oWSdNfe:cHFBAIXAXMLRESULT
	nAt1:= At('<RETDOWNLOADNFE ',Upper(cXml))
	nAt2:= At('</RETDOWNLOADNFE>',Upper(cXml))+ 17
	//Corpo do XML
	If nAt1 <=0
		nAt1:= At('<RETDOWNLOADNFE>',Upper(cXml))
	EndIf 	
	If nAt1 > 0 .And. nAt2 > 17
		cNfe := Substr(cXml,nAt1,nAt2-nAt1)

		cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXml+= cNfe
		cXml := NoAcento(cXml)
		cXml := EncodeUTF8(cXml)
		cErro:= ""
		cWarning:= ""
		oWSrNfe := XmlParser( cXml, "_", @cErro, @cWarning )
		If oWSrNfe == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
			cMsg   := "Erro Parser do XML de Resposta"
			cInfo  := cErro + " " + cWarning
			lTodos := .T.
			nRet   := 2
			U_MyAviso("SPED",cInfo,{"OK"},3)
		elseIf oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT <> "139"
			cMsg   := "Retorno do Sefaz "+oWSrNfe:_RETDOWNLOADNFE:_CSTAT:TEXT
			cInfo  := oWSrNfe:_RETDOWNLOADNFE:_XMOTIVO:TEXT
			lTodos := .T.
			nRet   := 2
			U_MyAviso("SPED",cInfo,{"OK"},3)
		Else
			nErr := 0
			nDow := 0
			oDet := oWSrNfe:_RETDOWNLOADNFE:_RETNFE
			oDet := iif( valtype(oDet)=="O", {oDet}, oDet )
			For nI := 1 to len( oDet )
				cStt  := ""
				cMsg  := ""
				cInfo := ""
				if oDet[nI]:_CSTAT:TEXT <> "140"
					cMsg  := oDet[nI]:_CSTAT:TEXT
					cInfo := oDet[nI]:_XMOTIVO:TEXT
					cStt  := "0"
				else
					cChave := cDir + alltrim( oDet[nI]:_CHNFE:TEXT ) + "-procNfe.xml"
					oXml := oDet[nI]:_PROCNFE:_NFEPROC

					SAVE oXml XMLSTRING cXML
					nAt1:= At('<NFE ',Upper(cXml))
					nAt2:= At('</NFE>',Upper(cXml))+ 6
					//Corpo da Nfe
					If nAt1 <=0
						nAt1:= At('<NFE>',Upper(cXml))
					EndIf 	
					If nAt1 > 0 .And. nAt2 > 6
						cNfe := Substr(cXml,nAt1,nAt2-nAt1)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo := "XML "+oDet[nI]:_CHNFE:TEXT+" sem TAG <NFE>"
					EndIf	
					nAt3:= At('<PROTNFE ',Upper(cXml))
					nAt4:= At('</PROTNFE>',Upper(cXml))+ 10
					//Protocolo	
					If nAt3 > 0 .And. nAt4 > 10
						cProt := Substr(cXml,nAt3,nAt4-nAt3)
					Else
						cStt  := "0"
						cMsg  := "Xml Retorno Inv·lido"
						cInfo += "XML "+oDet[nI]:_CHNFE:TEXT+" sem Protocolo, falta TAG <PROTNFE>"
					EndIf
					
					if empty( cMsg )
						//cXml:= '<?xml version="1.0"?>'
						cXml:= '<?xml version="1.0" encoding="UTF-8"?>'
						cXml+= '<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
						cXml+= cNfe
						cXml+= cProt
						cXml+= '</nfeProc>'
						cXml := NoAcento(cXml)
						cXml := EncodeUTF8(cXml)
						oXml := XmlParser( cXml, "_", @cErro, @cWarning )
						
						if oXML == NIL .Or. !Empty(cErro) .Or. !Empty(cWarning)
							cStt  := "0"
							cMsg  := "Erro Parser do XML"
							cInfo := cErro + " " + cWarning
						Else
							SAVE oXML XMLFILE cChave
							nHandle := FT_FUse( cChave )
							if nHandle == -1
								cStt  := "0"
								cMsg  := "Erro GravaÁ„o"
								cInfo := "Erro de GravaÁ„o XML no DiretÛrio "+cChave
							else
								cStt  := "1"
								cMsg  := "Download Efetuado"
								cInfo := "Download Efetuado do XML "+cChave
							endif
							FT_FUSE()
						EndIf
					Endif

				Endif
				if cStt == "1"
					nDow++
				else
					nErr++
				endif
				If TMP->(dbSeek( oDet[nI]:_CHNFE:TEXT ) )
					if alltrim(cMsg) == "633" //Falta de ManifestaÁ„o
						nRet := 1
					endif
					if cStt <> "1" .and. nRet <> 1
						nRet := 2
					endif
					RecLock( "TMP", .F. )
					if alltrim(cMsg) != "633" //Deixa marcado
						TMP->OK    := "  "
					endif
					TMP->ST    := cStt
					TMP->MSG   := cMsg
					TMP->ERRO  := cInfo
					TMP->( MsUnLock() )
				endif
			Next nI
		Endif
	Else
		cMsg  := "Erro de retorno do Sefaz."
		cInfo := "Erro de retorno do Sefaz. XML de retorno n„o contÈm a TAG <RETDOWNLOADNFE>"
		U_MyAviso("SPED",cInfo,{"OK"},3)
		lTodos := .T.
		nRet   := 2
	EndIf	
else
	//Erro TSS ou WS n„o instalado.
	nRet  := 2
	cInfo := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
	cMsg  := "Erro TSS ou WS"
	U_MyAviso("SPED",cInfo,{"OK"},3)
	lTodos := .T.
endif

if lTodos
	TMP->( dbgotop() )
	Do While .not. TMP->( Eof() )
		if TMP->OK == "Pr" // == cMarcaOK
			RecLock( "TMP", .F. )
			TMP->OK    := "  "
			TMP->ST    := "0"
			TMP->MSG   := cMsg
			TMP->ERRO  := cInfo
			TMP->( MsUnLock() )
		endif
		TMP->( dbskip() )
	Enddo
else
	if nRet <> 1
		If nDow == 0
			U_MyAviso("Msg","OperaÁ„o com erros, verifique as Mensagens.",{"OK"},3)
		Elseif nErr == 0
			U_MyAviso("Msg","OperaÁ„o concluida com exito, verifique as Mensagens e os arquivos baixados na pasta "+cDir+".",{"OK"},3)
		Else
			U_MyAviso("Msg","OperaÁ„o concluida com alguns erros, verifique as Mensagens e os arquivos baixados na pasta "+cDir+".",{"OK"},3)
		Endif
	endif
endif

TMP->( dbgoto( nReg ) )
return( nRet )
*/


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXML06D()
        U_HFXML06SM()
        U_HFXML06JB()
        U_HFXML06CD()
        U_TELAJUST()
	EndIF
Return(lRecursa)
