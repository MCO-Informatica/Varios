#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#Include "Print.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR02   ºAutor  ³Felipi Marques      º Data ³  12/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Danfe                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMR02()

Local aButtons		:= { } 
Local cCadastro     := "Portal da Nota Fiscal EletrônicaL" +" - " +"Geração de Relatorio"    
Local nOpca         := 0 
Private aLog        := {}
Private aTitle      := {}
Private cPerg       := "PCOMMIX1"
Private aRegs       := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os filtros da rotina                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegs,{cPerg,"01","Fornecedor Inicial"	,"","","mv_ch1","C",06,0,0,"G","",								    "MV_PAR01","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","SA2",			"","",		"","" })					
aAdd(aRegs,{cPerg,"02","Fornecedor Final"	,"","","mv_ch2","C",06,0,0,"G","",									"MV_PAR02","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","SA2",	   		"","",		"","" })					
aAdd(aRegs,{cPerg,"03","Loja Inicial"		,"","","mv_ch3","C",02,0,0,"G","",									"MV_PAR03","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",				"","",		"","" })					
aAdd(aRegs,{cPerg,"04","Loja Final" 		,"","","mv_ch4","C",02,0,0,"G","",									"MV_PAR04","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",				"","",		"","" })
aAdd(aRegs,{cPerg,"05","Data Inicial"		,"","","mv_ch5","D",08,0,0,"G","",									"MV_PAR05","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",				"","",		"","" })					
aAdd(aRegs,{cPerg,"06","Data Final"			,"","","mv_ch6","D",08,0,0,"G","",									"MV_PAR06","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",	   			"","",		"","" })
aAdd(aRegs,{cPerg,"07","NF Inicial"	        ,"","","mv_ch7","C",09,0,0,"G","",									"MV_PAR07","",				"","","",				"","",						"","","","","","","","","","","","","","","","","",""," ",			    "","",		"","" })					
aAdd(aRegs,{cPerg,"08","NF Final"   	    ,"","","mv_ch8","C",09,0,0,"G","",									"MV_PAR08","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",			    "","",		"","" })					
aAdd(aRegs,{cPerg,"09","Serie"   	        ,"","","mv_ch9","C",03,0,0,"G","",									"MV_PAR09","",				"","","",				"","",						"","","","","","","","","","","","","","","","","","","",		   	    "","",		"","" })					

ValidPerg(cPerg,aRegs)

//Chama tela de perguntas, caso cancele, não executar relatorio
If Pergunte(cPerg,.T.)
	Processa({ |lEnd| RecDanfe1(),OemToAnsi("Criando cabeçalho, aguarde...")}, OemToAnsi("Aguarde..."))
EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RecDanfe1()

Local lDir    := .T.
Local cPath   := ""
Local lProsiga:= .T.

Local cQuery := ""
Local cSqlAlias	:= GetNextAlias()

//Tela de apontamento de origem e destino
aRetTela := fOriDes()

//Fragmentando resultado da variavel
cPath       := aRetTela[1]
lProsiga    := aRetTela[2]

If lProsiga = .F.
	MsgInfo("Cancelado pelo usuário")
    Return()
Endif

cQuery := " SELECT SDS.R_E_C_N_O_ RECSDS            "
cQuery += " FROM   "+RetSqlName("SDS")+"  SDS       "
cQuery += " WHERE  DS_FILIAL = '"+xFilial("SDS")+"' "
cQuery += " AND    DS_FORNEC >= '" +mv_par01 +"'          AND  DS_FORNEC <= '" +mv_par02 +"'           " 
cQuery += " AND    DS_LOJA >= '" +mv_par03 +"'            AND  DS_LOJA <= '" +mv_par04 +"'             "  
cQuery += " AND    DS_EMISSA >= '"  +DToS(mv_par05) +"'   AND  DS_EMISSA <= '"  +DToS(mv_par06) +"'    "
cQuery += " AND    DS_DOC >= '" +mv_par07 +"'             AND  DS_DOC <= '" +mv_par08 +"'              "
cQuery += " AND    DS_SERIE >= '" +mv_par09 +"'           AND  DS_SERIE <= '" +mv_par09 +"'            "
cQuery += " AND SDS.D_E_L_E_T_ = ' '                                                                   "

//Cria Tabela temporaria
TcQuery cQuery New Alias &cSQLAlias

// limpar a fila de impressão de etiqueta
While (cSQLAlias)->(!EOF())
	
	dbSelectArea("SDS")
	SDS->(dbGoTo((cSQLAlias)->RECSDS))
	//Impressao do relatorio, salvando no local selecionado
	U_RCOMR03(cPath) 
	
	(cSQLAlias)->(!dbSkip())
EndDo
// Fecha tabela
(cSQLAlias)->(dbCloseArea())  

Return        



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fOriDes()

Local oDlg
Local lRet		:= .T.
Local nOpca		:= 0
Local bOk    	:= {||nOpca:=1,oDlg:End()}
Local bCancel	:= {||nOpca:=2,oDlg:End()}
Private cOrig	:= Space(300)

Define MsDialog oDlg From 000,000 TO 140,400 Title OemToAnsi("Busca de diretorio..." )  Pixel STYLE nOR( WS_VISIBLE, WS_POPUP )
oDlg:lMaximized := .T. //Maximizar a janela

@ 020,005 Say OemToAnsi("Arquivo origem:") Pixel
@ 033,005 Say OemToAnsi("Nome do usuário:") Pixel
@ 019,050 Get cOrig	Size 130,8 Picture "@!" Pixel When .F.
@ 032,050 Get cUserName	Size 130,8 Picture "@" Pixel When .F.
@ 019,185 Button oBtn1 Prompt OemToAnsi("...") Size 10,10 Pixel of oDlg Action fBscDir(.F.,@cOrig)

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered

If nOpca = 1
	// Se o arquivo nao for encontrado, sair da rotina.
	If !File(cOrig)
		MsgAlert("Arquivo de origem não informado ou não existe!")
		lRet := .F.
	Endif
Else
	lRet := .F.
EndIf

Return{cOrig,lRet}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fBscDir(lDir,cOrig,cAquivo)

Local cTipo 	:=	"'Arquivo *|*.*|Arquivo PDF|*.PDF'"
Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cRet		:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= ""

cGetFile := cGetFile(cTipo,cTitulo,0,cDirIni,.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY,.F.) 

// Separa os componentes
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

//Trata variavel de retorno
If !Empty(cFile) .And. !lDir
	cRet := cGetFile
EndIf

//Trata variavel de retorno
IF SUBSTR(cGetFile,LEN(cGetFile),1) == "\"
	cGetFile := SUBSTR(cGetFile,1,LEN(cGetFile)-1)
ENDIF

cOrig := cGetFile            			

Return()       

  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG   ºAutor  ³Felipi Marques      º Data ³  08/19/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica perguntas, incluindo-as caso nao existam.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VALIDPERG()

ssAlias  := SX1->(Alias())

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

For i := 1 to Len(aRegs)
	If SX1->(!dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+aRegs[i,2] ))
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)

Return