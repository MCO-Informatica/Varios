#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"
#Include "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

#Define CRLF  CHR(13)+CHR(10)
#DEFINE MARCA	001                                                                                         
#DEFINE STATUS	002                                                                                         
#DEFINE EMISSA	003
#DEFINE TITULO 	004
#DEFINE CODFOR	005
#DEFINE NOMFOR	006
#DEFINE TOTAL	007
#DEFINE REGISTRO 008
#DEFINE HISTOR   009
#DEFINE VENCTO 010

#DEFINE AP_NIVEL 	001
#DEFINE AP_COMPRA 	002
#DEFINE AP_APROVA 	003
#DEFINE AP_SITUAC 	004
#DEFINE AP_AVALIA	005
#DEFINE AP_DATA 	006
#DEFINE AP_GRUPO 	007
#DEFINE AP_OBS	 	008


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NfeEnv   ºAutor ³Luiz Alberto         º Data ³  11/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio Por Lote de Notas Para o SEFAZ                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LibPFinan()

Local aArea := GetArea()
Local lRet	:= .t.
Local oBotaoCnf 
Local oBtnFecha
Local oBotaoMar 
Local oBotaoDes 
Local oBotaoSef 
Local oTTC
Local DADOS := TFont():New("Arial Narrow",,016,,.F.,,,,,.F.,.F.)
Local oTelLibPed
Local aArea := GetArea()
Private     oFoi	 := LoadBitmap(GetResources(),"BR_AZUL")
Private     oYes	 := LoadBitmap(GetResources(),"BR_VERDE")
Private     oImprime:= LoadBitmap(GetResources(),"BR_LARANJA")
Private     oNo  	 := LoadBitmap(GetResources(),"BR_VERMELHO")
Private     oMarca  := LoadBitmap(GetResources(),"LBTIK")
Private     oDesma	 := LoadBitmap(GetResources(),"LBNO")
Private cNivel := SCR->CR_NIVEL
Private nTamanho  := TamSX3("E2_NUM")[1]
Private oTitulos
Private aTitulos := {}
Private lEnd := .f.
Private nTotMer := 0.00
Private nTotFre := 0.00
Private nTotDsc := 0.00
Private nTotDsp := 0.00
Private nTotSeg := 0.00
Private nTotPed := 0.00
Private cForNom	:=	''
Private cForEnd	:=	''
Private dFor1Cp	:=	CtoD('')
Private dForUCp	:=	Ctod('')
Private cForEst	:=	''
Private cForTel	:=	''
Private cForCNP	:=	''
Private cObserv	:=	''
Private aTitulos	:=	{}      

If !SAK->(dbSetOrder(2), dbSeek(xFilial("SAK")+__cUserId))
	MsgStop("Atenção Usuário Não Possui Cadastro como Liberador de titulos a Pagar !")
//	Return .f.   
Endif

cIdUsuario := __cUserId

lOk:=.f.
	
DEFINE MSDIALOG oTelLibPed TITLE "Titulos Bloqueados - Aguardando Liberação" FROM 000, 000  TO 600, 1100 COLORS 0, 16777215 OF oMainWnd PIXEL
	
@ 210, 005 FOLDER oFolder SIZE 540, 070 OF oTelLibPed ITEMS 'Fornecedor' COLORS 0, 16777215 PIXEL

@ 010, 005 LISTBOX oTitulos Fields HEADER '','','Status','Emissao',"Titulo","Código","Fornecedor",'Vencimento Real','Valor Titulo','Historico' SIZE 540, 200 OF oTelLibPed PIXEL ColSizes 50,50	//?FONT Dados 
	
// Dados do Fornecedor

@ 002, 007 SAY oSay1 PROMPT "Nome" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 002, 100 MSGET oForNom VAR cForNom SIZE 150, 008 OF oFolder:aDialogs[1] PICTURE "@!" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 020, 007 SAY oSay1 PROMPT "Endereço" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 020, 100 MSGET oForEnd VAR cForEnd SIZE 200, 008 OF oFolder:aDialogs[1] PICTURE "@!" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 035, 007 SAY oSay1 PROMPT "1a Compra" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 035, 100 MSGET oFor1Cp VAR dFor1Cp SIZE 060, 008 OF oFolder:aDialogs[1] PICTURE "99/99/9999" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 035, 177 SAY oSay1 PROMPT "Ult. Compra" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 035, 250 MSGET oForUCp VAR dForUCp SIZE 060, 008 OF oFolder:aDialogs[1] PICTURE "99/99/9999" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 002, 357 SAY oSay1 PROMPT "Telefone" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 002, 450 MSGET oForTel VAR cForTel SIZE 050, 008 OF oFolder:aDialogs[1] PICTURE "@!" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 020, 357 SAY oSay1 PROMPT "Estado" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 020, 450 MSGET oForEst VAR cForEst SIZE 030, 008 OF oFolder:aDialogs[1] PICTURE "@!" WHEN .F. COLORS 0, 16777215 PIXEL 

@ 035, 357 SAY oSay1 PROMPT "CNPJ" SIZE 060, 010 OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 035, 450 MSGET oForCNP VAR cForCNP SIZE 80, 008 OF oFolder:aDialogs[1] PICTURE "@R 99.999.999/9999-99" WHEN .F. COLORS 0, 16777215 PIXEL 

Processa({|| fProcLibPed(cIdUsuario,@aTitulos,.T.)})
	
If Empty(Len(aTitulos)) .Or. Empty(aTitulos[1,TITULO])
	MsgStop("Atenção Nenhum Pedido Bloqueado !")
	RestArea(aArea)
	Return .f.
Endif
	

//oLbx:bKeyDown:={|nKey| if(nKey==VK_RETURN, {||Processa({||U_DblClick(oLbx:nAt)})},"") }
oTitulos:SetArray(aTitulos)
oTitulos:bChange := {|| U_ItePed(oTitulos:nAt,Len(aTitulos)) }
oTitulos:bLine := {|| {	Iif(aTitulos[oTitulos:nAt,MARCA]=='1',oYes,oNo),;
						Iif(aTitulos[oTitulos:nAt,MARCA]=='1',oMarca,oDesma),;
						aTitulos[oTitulos:nAt,STATUS],;
						DtoC(aTitulos[oTitulos:nAt,EMISSA]),;
						aTitulos[oTitulos:nAt,TITULO],;
						aTitulos[oTitulos:nAt,CODFOR],;
						aTitulos[oTitulos:nAt,NOMFOR],;
						aTitulos[oTitulos:nAt,VENCTO],;
						TransForm(aTitulos[oTitulos:nAt,TOTAL],'@E 9,999,999,999.99'),;
						aTitulos[oTitulos:nAt,HISTOR]}}

// Marca Notas
oTitulos:bLDblClick := {|| dblClick(oTitulos:nAt)}
oTitulos:LHSCROLL   := .F.

@ 285, 005 BUTTON oBotaoCnf PROMPT "&Liberar" 					ACTION Processa( {|| (U_LibTPed(aTitulos),Processa({|| fProcLibPed(cIdUsuario,@aTitulos,.T.)}),oTitulos:Refresh())},OemtoAnsi("Aguarde Efetuando Processamento dos Titulos Marcados")) SIZE 060, 010 OF oTelLibPed PIXEL
@ 285, 085 BUTTON oBotaoSef PROMPT "&Rejeitar"	 				ACTION Processa( {|| (U_RejTPed(aTitulos),Processa({|| fProcLibPed(cIdUsuario,@aTitulos,.T.)}),oTitulos:Refresh())},"Aguarde Efetuando Processamento dos Titulos Marcados") SIZE 060, 010 OF oTelLibPed PIXEL 
@ 285, 165 BUTTON oBotaoMar PROMPT "&M Todas" 					ACTION Processa( {|| U_MarcaTodas()},"Aguarde Marcando Titulos") SIZE 060, 010 OF oTelLibPed PIXEL
@ 285, 245 BUTTON oBotaoDes PROMPT "&D Todas" 					ACTION Processa( {|| U_DesMarcaTodas()},"Aguarde Desmarcando Titulos") SIZE 060, 010 OF oTelLibPed PIXEL 
@ 285, 405 BUTTON oBtnFecha PROMPT "&Sair"	 					ACTION(lOk:=.f.,oTelLibPed:End()) SIZE 60,10  OF oTelLibPed PIXEL

ACTIVATE MSDIALOG oTelLibPed CENTERED 

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibTPed ºAutor  ³ Luiz Alberto       º Data ³  20/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LibTPed(aTitulos)
Local aArea := GetArea()       
Local aPvlNfs := {}
Local aBloqueio := {} 
Local lOk := .f.

If !MsgYesNo("Confirma a Liberacao dos Titulos Marcados ? S/N")
	oTitulos:Refresh()
	RestArea(aArea)
	Return .t.                                                                
Endif
  
ProcRegua(Len(aTitulos))
For nI := 1 To Len(aTitulos)
	IncProc("Processando Liberação de Titulos...")
	If aTitulos[nI,MARCA]=='1' 
        lOk := .t.   
		PrcPedido(1,aTitulos[nI,REGISTRO],aTitulos[nI,TOTAL])
	Endif         
Next
If lOk
	MsgInfo("Titulos Liberados Com Sucesso !")
Else                                          
	MsgStop("Necessário Marcar Titulos para Liberação !")
Endif

oTitulos:Refresh()
RestArea(aArea)
Return .t.                                                                



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RejTPed ºAutor  ³ Luiz Alberto       º Data ³  20/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RejTPed(aTitulos)
Local aArea := GetArea()       
Local aPvlNfs := {}
Local aBloqueio := {} 
Local lOk := .f.
  
ProcRegua(Len(aTitulos))
For nI := 1 To Len(aTitulos)
	IncProc("Processando Rejeição de Titulos...")

	If aTitulos[nI,MARCA]=='1' 
		lOk := .t.

		PrcPedido(2,aTitulos[nI,REGISTRO],aTitulos[nI,TOTAL])
		
	Endif         
Next

If lOk
	MsgInfo("Titulos Rejeitados Com Sucesso !")
Else
	MsgStop("É Necessário Marcar os Titulos para Rejeição !")
Endif

oTitulos:Refresh()
RestArea(aArea)
Return .t.           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aTitulos[nPos,MARCA]=="1" 
	aTitulos[nPos,MARCA]:="2"
Else
	aTitulos[nPos,MARCA]:="1"
Endif

oTitulos:Refresh()
Return .t.
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MarcaTodas()
Local aArea := GetArea()

ProcRegua(Len(aTitulos))
For nPos := 1 To Len(aTitulos)
	IncProc("Processando Titulo " + aTitulos[nPos,TITULO]+"...")

	aTitulos[nPos,MARCA]:="1"
Next

oTitulos:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DesMarcaTodas()
Local aArea := GetArea()

ProcRegua(Len(aTitulos))
For nPos := 1 To Len(aTitulos)
	IncProc("Processando Titulo " + aTitulos[nPos,TITULO]+"...")
	If aTitulos[nPos,MARCA]$"1" 
		aTitulos[nPos,MARCA]:="2"
	Endif
Next

oTitulos:Refresh()
Return .t.
	
	                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ItePed(nPos,nQtd)
Local aArea := GetArea()

If Empty(nQtd)
	Return .F.
Endif

nReg := aTitulos[nPos,REGISTRO]

If !Empty(nReg)

	SCR->(dbGoTo(nReg))
	SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+SCR->CR_NUM))


	SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
	
	cForNom	:=	SA2->A2_NOME
	cForEnd	:=	AllTrim(SA2->A2_END)+' '+SA2->A2_MUN
	dFor1Cp	:=	SA2->A2_PRICOM
	dForUCp	:=	SA2->A2_ULTCOM
	cForTel	:=	AllTrim(SA2->A2_DDD)+' '+SA2->A2_TEL
	cForEst	:=	SA2->A2_EST
	cForCNP	:=	SA2->A2_CGC
	cObserv :=  ''
Endif
	
oForNom:Refresh()
oForEnd:Refresh()
oFor1Cp:Refresh()
oForUCp:Refresh()
oForEst:Refresh()
oForTel:Refresh()
oForCNP:Refresh()
RestArea(aArea)
Return .T.



Static Function PrcPedido(nTipo,nRegSCR,nTotLib)
Local aArea := GetArea()
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]

SCR->(dbGoTo(nRegSCR))	// Retorna a Posição Gravada da SCR

// Padroniza o tamanho da Variavel cNumTit com base no tamanho do campo CR_NUM Padrão

cNumSCR := PadR(SCR->CR_NUM,TamSX3("CR_NUM")[1])
cNumTit := PadR(SCR->CR_NUM,nTamanho)

//Local cNumTit   := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA

cNivel := SCR->CR_NIVEL
cTipo := 'Liberação'
If nTipo == 2
	cTipo := 'Rejeição'
	If !MsgYesNo("Confirma a " + cTipo + " dos Titulos Marcados ? S/N")
		Return .F.
	Endif

	// Se a Solicitação foi Rejeitada Não Permite novas Ações
	
	If SCR->CR_STATUS == '04'
		MsgStop("Atenção Solicitação com Rejeição Impossível Efetuar " + cTipo + " ! ")
		RestArea(aArea)
		Return .f.
	Endif                      

Endif

lContinua := .t.

// Se a Solicitação foi Liberada Não Permite novas Ações

If SCR->CR_STATUS $ '03*05'
	MsgStop("Atenção Solicitação Já Aprovada Impossível Efetuar " + cTipo + " ! ")
	RestArea(aArea)
	Return .f.
Endif                      

// Verifica se Existe nivel inferior necessitando de aprovação.
// em caso afirmativo não permite que o usuário com nivel superior efetue manutenção.

If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
	While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit
		If SCR->CR_STATUS <> "03" .And. SCR->CR_NIVEL < cNivel
			lContinua := .f.
			Exit
		Endif
		
		SCR->(dbSkip(1))
	Enddo
Endif

SCR->(dbGoTo(nRegSCR))

If !lContinua
	MsgStop("Atenção Existem Niveis Diferentes de Aprovadores Com Direitos de Aprovação ou Rejeição, Impossível Continuar !")
	RestArea(aArea)
	Return .f.
Endif                      

If nTipo==2	// Rejeita SC
/*	
	// Efetua abertura de janela para preenchimento de justificativa de rejeição pelo aprovador

	nOpc := 0
	cMotRej := CRIAVAR("C1_OBS")
	
	DEFINE FONT oFont NAME "Courier New" SIZE 7,14
	
	@ 3,0 TO 70,550 DIALOG oDlg1 TITLE OemToAnsi("INFORME MOTIVO DA REJEIÇÃO")
	@ 5,35 Get cMotRej PICTURE "@!" VALID NaoVazio() SIZE 200,008 OF oDlg1  PIXEL
	@ 20,240 BMPBUTTON TYPE 1  ACTION ( nOpc := 1 , oDlg1:End() )
	ACTIVATE DIALOG oDlg1 CENTER
	
	If nOpc<> 1
		MsgStop("Atenção Informe o Motivo da Rejeição !")
		RestArea(aArea)
		Return .f.
	Endif */
Endif                      

If nTipo==1	// Libera SC
	If SAK->(dbSetOrder(2), dbSeek(xFilial("SAK")+__cUserID))	// Verifica se o usuario atual possui cadastro de Comprador
		
		// Grava Mudança de Status para Liberado
	
		If Reclock("SCR",.F.)
			SCR->CR_STATUS  := "03"
			SCR->CR_DATALIB := Date()
			SCR->CR_USERLIB := __cUserId
			SCR->CR_TXMOEDA	:=	1
			SCR->CR_LIBAPRO := SAK->AK_COD     
			SCR->CR_VALLIB  := nTotLib
			SCR->CR_TIPOLIM := SAK->AK_TIPO
			SCR->(MsUnlock())
		Endif		

		//	Variavel de Controle se Existem 1 ou Mais Aprovadores na Fila

		lMaisAprov := .f.
	
	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
			While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit
				
				// Se Houver Mais Aprovadores com o Mesmo Nivel e Não Tiverem Liberado a SC Ainda
				// Então Automaticamente já Libera Todos
				
				If SCR->CR_STATUS <> "03" .And. SCR->CR_NIVEL == cNivel
					If RecLock("SCR",.f.)
						SCR->CR_STATUS  := "03"
						SCR->CR_DATALIB := Date()
						SCR->CR_USERLIB := __cUserId
						SCR->CR_TXMOEDA	:=	1
						SCR->CR_LIBAPRO := SAK->AK_COD     
						SCR->CR_VALLIB  := nTotLib
						SCR->CR_TIPOLIM := SAK->AK_TIPO
						SCR->(MsUnlock())
					Endif
					
				// Se Houver Mais Aprovadores com Niveis Diferentes e que o Status não esteja liberado
				// então muda todos os status para aguardando liberação outro nivel
				
				ElseIf !SCR->CR_STATUS $ "03" .And. SCR->CR_NIVEL <> cNivel
					lMaisAprov := .t.
				Endif
				SCR->(DbSkip(1))
			Enddo
	    Endif

		// Identificacao do Proximo Nivel de Aprovadores para Mudança de Status
	
		_cNivel := cNivel
		
	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
			While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit .And. SCR->(!Eof())
			
				If SCR->CR_NIVEL > _cNivel .And. !SCR->CR_STATUS $ "03" 
					_cNivel := SCR->CR_NIVEL
					Exit
				Endif
	
				SCR->(DbSkip(1))
			Enddo
	    Endif
	    
	    cNivel := _cNivel

	    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
			While SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit .And. SCR->(!Eof())
			
				If SCR->CR_NIVEL == cNivel .And. !SCR->CR_STATUS $ "03" 
					If RecLock("SCR",.f.)
						SCR->CR_STATUS  := "02"
						SCR->(MsUnlock())
					Endif
				Endif
	
				SCR->(DbSkip(1))
			Enddo
	    Endif

		// Se Não Houver Mais Aprovadores então Libera a SC

		If !lMaisAprov
			// Reformula o tamanho da variavel cNumTit Para o campo C1_NUM Padrão, para localizar a SC Corretamente

			If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+Left(cNumTit,nTamanho)))
				If RecLock("SE2",.f.)
					SE2->E2_XCONAP	:= 'L'
					If SE2->(FieldPos("E2_XNOMAPR")) > 0
						SE2->E2_XNOMAPR := UsrFullName(__cUserID) 
					Endif
					SE2->(MSUnlock())
				Endif
			Endif
		Endif
	Endif
Else
	// Bloqueia SC
	
	If Reclock("SCR",.F.)
		SCR->CR_STATUS  := "04"
		SCR->CR_DATALIB := Date()
		SCR->CR_USERLIB := __cUserId
		SCR->(MsUnlock())
	Endif
	
    // Localiza a fila de aprovações e rejeita todos
    
    If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+cNumTit))
		While SCR->(!Eof()) .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) = xFilial("SCR") + "PG" + cNumTit
				
			// Se Houver Mais Aprovadores com o Mesmo Nivel e Não Tiverem Liberado a SC Ainda
			// Então Automaticamente já Libera Todos
				
			If RecLock("SCR",.f.)
				SCR->CR_STATUS  := "04"
				SCR->CR_DATALIB := Date()
				SCR->CR_USERLIB := __cUserId
				SCR->(MsUnlock())
			Endif
			SCR->(DbSkip(1))
		Enddo
    Endif

	If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+Left(cNumTit,nTamanho)))
		If RecLock("SE2",.f.)
			SE2->E2_XCONAP	:= 'R'
			If SE2->(FieldPos("E2_XNOMAPR")) > 0
				SE2->E2_XNOMAPR := UsrFullName(__cUserID) 
			Endif
			SE2->(MSUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return .t.


Static Function fProcLibPed(cIdUsuario,aTitulos,lPrimeira)
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]
Default lPrimeira := .t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Aprovacao : CR_STATUS -->                ³
//³ 01 - Bloqueado p/ sistema (aguardando outros niveis) ³
//³ 02 - Aguardando Liberacao do usuario                 ³
//³ 03 - Pedido Liberado pelo usuario                    ³
//³ 04 - Pedido Bloqueado pelo usuario                   ³
//³ 05 - Pedido Liberado por outro usuario               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicaliza a funcao FilBrowse para filtrar a mBrowse          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SCR")
dbSetOrder(1)

_cFiltraSCR := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER=="'+cIdUsuario
_cFiltraSCR += '".And.(CR_STATUS=="02".OR.CR_STATUS=="04")'
_cFiltraSCR += '.And.CR_TIPO=="PG"'

aTitulos	:=	{}      

_cFiltraSCR := StrTran(_cFiltraSCR,'""','"')

dbSelectArea("SCR")
dbSetOrder(1)

SCR->( dbSetFilter( { || &_cFiltraSCR }, _cFiltraSCR ) )    

nReg := 0

ProcRegua(0)

SCR->(dbGoTop())
While SCR->(!Eof())
	IncProc("Aguarde Localizando Titulos Bloqueados...")
	
	
	cNumTit	:=	PadR(SCR->CR_NUM,nTamanho)
	nRegPed := SCR->(Recno())
	
	If !SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+cNumTit))
		SCR->(dbSkip(1));Loop
	Endif             
	
	SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA))

	nReg++
	
	AAdd(aTitulos,{'2',;     
					Iif(SCR->CR_STATUS=='04','Rejeitado','Bloqueado'),;
					SE2->E2_EMISSAO,;
					SE2->E2_PREFIXO + ' ' + SE2->E2_NUM + ' ' + SE2->E2_PARCELA,;
					SA2->A2_COD+'/'+SA2->A2_LOJA,;
					SA2->A2_NOME,;
					SE2->E2_VALOR,;
					nRegPed,;
					SE2->E2_HIST,;
					SE2->E2_VENCREA})
	
	SCR->(dbSkip(1))
Enddo     

If Empty(nReg)
	aTitulos := {{'2','',CtoD(''),'','','',0.00,0,'',CtoD('')}}
Endif

SCR->(DBClearFilter())
oTitulos:SetArray(aTitulos)
oTitulos:bChange := {|| U_ItePed(oTitulos:nAt,nReg) }

U_ItePed(oTitulos:nAt,Len(aTitulos))

oTitulos:SetArray(aTitulos)
oTitulos:bLine := {|| {	Iif(aTitulos[oTitulos:nAt,MARCA]=='1',oYes,oNo),;
						Iif(aTitulos[oTitulos:nAt,MARCA]=='1',oMarca,oDesma),;
						aTitulos[oTitulos:nAt,STATUS],;
						DtoC(aTitulos[oTitulos:nAt,EMISSA]),;
						aTitulos[oTitulos:nAt,TITULO],;
						aTitulos[oTitulos:nAt,CODFOR],;
						aTitulos[oTitulos:nAt,NOMFOR],;
						aTitulos[oTitulos:nAt,VENCTO],;
						TransForm(aTitulos[oTitulos:nAt,TOTAL],'@E 9,999,999,999.99'),;
						aTitulos[oTitulos:nAt,HISTOR]}}
oTitulos:nAt := 1
oTitulos:Refresh()						
Return .T.
