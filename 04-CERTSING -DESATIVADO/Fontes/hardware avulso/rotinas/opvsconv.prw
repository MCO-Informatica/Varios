#include "protheus.ch"      
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  OPVSCONV     ³ Autor ³ Darcio R. Sporl  ³ Data ³27/08/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Executa atualizadores na base do cliente                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³  Nenhum                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  Opvs                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OPVSCONV()
Local cTitulo	:= OemToAnsi("Verifica e Atualiza os dicionarios")
Local cLbxAtu	:= ""
Local aLbxAtu	:= {}

Local oTik		:= LoadBitmap( GetResources(), "LBTIK" )
Local oNo		:= LoadBitmap( GetResources(), "LBNO" )   
 
Local oDlgAtu

//Vetor com as informações do atualizadores que serão disponibilizados para o cliente
//Coluna 1(lógico)   = Registro selecionado ou nao
//Coluna 2(caracter) = Data da Liberação do BOPS com o atualizador
//Coluna 3(caracter) = Nome da função atualizadora
//Coluna 4(caracter) = Nome das rotinas atualizadas
If Len(aLbxAtu) == 0
	aLbxAtu := {	{.F., "27/08/2011", "U_UPDOPVSHA()", "HARDWARE AVULSO"},;
					{.F., "27/08/2011", "U_UPDOPVSCH()", "CHAT"}}

EndIf

aSort(aLbxAtu,,, {|x, y| CTOD(x[2], "DDMMYY") < CTOD(y[2], "DDMMYY") })
 
nOpca := 0      
DEFINE MSDIALOG oDlgAtu TITLE cTitulo From 000, 000 to 400, 470 PIXEL of oDlgAtu
	@ 015, 005 SAY OemToAnsi("Rotinas de atualização dos Dicionários")                OF oDlgAtu PIXEL COLOR CLR_HBLUE
	@ 025, 005 SAY OemToAnsi("Selecione os atualizadores que deseja executar:")       OF oDlgAtu PIXEL COLOR CLR_RED
  
	@ 035, 004 LISTBOX oLbxAtu VAR cLbxAtu FIELDS HEADER " ", "Data Liberação", "Nome Atualizador", "Fontes Atualizados" COLSIZES 10, 40, 70, 800 SIZE 225, 160 OF oDlgAtu PIXEL ;
				ON DBLCLICK (aLbxAtu[oLbxAtu:nAt, 01] := !aLbxAtu[oLbxAtu:nAt, 01])
  
	oLbxAtu:SetArray(aLbxAtu)
	oLbxAtu:bLine := {|| {IIf(!aLbxAtu[oLbxAtu:nAt, 01], oNo, oTik), aLbxAtu[oLbxAtu:nAt, 02], aLbxAtu[oLbxAtu:nAt, 03], aLbxAtu[oLbxAtu:nAt, 04]}}

	tButton():New(11, 140, "Ok", oDlgAtu, {|| IIf(OpvsVlAtu(aLbxAtu), (nOpcA := 1, oDlgAtu:End()), nOpcA := 0) }, 32,,,,, .T.) //Ok
	tButton():New(11, 180, "Cancelar", oDlgAtu, {||oDlgAtu:End()}, 32,,,,, .T.)//Cancelar

ACTIVATE MSDIALOG oDlgAtu CENTERED 
 
If nOpca == 1 .And. MsgYesNo("Deseja efetuar a atualizacao do Dicionário? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionários e da Base de Dados antes da atualização para eventuais falhas de atualização !", "Atenção")
	Processa({|| OpvsAtu(aLbxAtu)}, "Executando atualizador(es)")
Endif 
 
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OpvsAtu   ºAutor  ³Darcio R. Sporl     º Data ³  27/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para executar os atualizadores                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OpvsAtu(aVetAtu) 
Local nCont := 0 

For nCont := 1 To Len(aVetAtu)
	If aVetAtu[nCont, 1]
		&(aVetAtu[nCont, 3])
	EndIf 
Next                     

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OpvsVlAtu ºAutor  ³Darcio R. Sporl     º Data ³  27/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para validar os atualizadores                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OpvsVlAtu(aLbxAtu)
Local lRet			:= .F.
Local nCont			:= 0 
Local cAtuNExist	:= ""
Local oTik			:= LoadBitmap( GetResources(), "LBTIK" )
Local oNo			:= LoadBitmap( GetResources(), "LBNO" )   
   
For nCont := 1 To Len(aLbxAtu)
	If aLbxAtu[nCont, 1]
		If !(lRet := FindFunction(aLbxAtu[nCont, 3]))
			cAtuNExist += aLbxAtu[nCont, 3] + Chr(13) + Chr(10)
			aLbxAtu[nCont, 1] := .F.
		EndIf
	EndIf 
Next 
                                                                                                             
If !(lRet := Empty(cAtuNExist))
	OpvsMsg(	"Rotina(s) atualizadora(s):" + Chr(13) + Chr(10) + ;
				cAtuNExist +  Chr(13) + Chr(10) + ;
				"não existe(m) no repositório." + CHR(10) + ;
				"Favor solicitar patch referente a esse(s) atualizador(es).", "Atenção", "Atualização de dicionários")
	oLbxAtu:SetArray(aLbxAtu)
	oLbxAtu:bLine := {|| {IIf(!aLbxAtu[oLbxAtu:nAt, 01], oNo, oTik), aLbxAtu[oLbxAtu:nAt, 02], aLbxAtu[oLbxAtu:nAt, 03], aLbxAtu[oLbxAtu:nAt, 04]}}
	oLbxAtu:Refresh()            
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ OpvsMsg    ³ Autor ³ Darcio R. Sporl       ³ Data ³27/08/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Exibe um Dialog com uma mensagem de erro para o usuario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nil                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Mensagem de erro que será exibida                      ³±±
±±³          ³ExpC2: Titulo da Janela                                       ³±±
±±³          ³ExpC3: Nome da rotina que gerou o erro                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                             
Static Function OpvsMsg(cMsgErro, cTitulo, cRotina)
Local oDlgMsg
Local oTexto
Local oBtnOk
Local cReadVar := IIF(Type("__ReadVar") <> "U".And. !Empty(__ReadVar), __ReadVar, "") //Guarda o conteudo do ReadVar porque o SetFocus limpa essa variavel

DEFINE MSDIALOG oDlgMsg FROM	62,100 TO 320,510 TITLE OemToAnsi(cTitulo) PIXEL

	@ 003, 004 TO 027, 200 LABEL "Help" OF oDlgMsg PIXEL //"Help"
	@ 030, 004 TO 110, 200 OF oDlgMsg PIXEL

	@ 010, 008 MSGET OemToAnsi(cRotina) WHEN .F. SIZE 188, 010 OF oDlgMsg PIXEL

	@ 036, 008 GET oTexto VAR OemToAnsi(cMsgErro) MEMO READONLY /*NO VSCROLL*/ SIZE 188, 070 OF oDlgMsg PIXEL

	oBtnOk := tButton():New(115, 170, "Ok", oDlgMsg, {|| oDlgMsg:End()},,,,,,.T.)
	oBtnOk:SetFocus()

ACTIVATE MSDIALOG oDlgMsg CENTERED

If !Empty(cReadVar)
	__ReadVar := cReadVar
EndIf 

Return(Nil)