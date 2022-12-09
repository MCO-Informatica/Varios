#INCLUDE "rwmake.ch"
#Include "PROTHEUS.CH"
#Include "APWIZARD.CH"
#Include "MATA984.CH"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

#DEFINE INCLUIR 1
#DEFINE ALTERAR 2
#DEFINE CRLF CHR(13)+CHR(10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  12/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGUAC002


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Parametros SFA"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ³
//³ que apareceram disponiveis para o usuario. Segue o padrao:          ³
//³ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              . . .                                                  ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ³
//³ Onde: <DESCRICAO> - Descricao da opcao do menu                      ³
//³       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ³
//³                     duplas e pode ser uma das funcoes pre-definidas ³
//³                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ³
//³                     e AXDELETA) ou a chamada de um EXECBLOCK.       ³
//³                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-³
//³                     clarar uma variavel chamada CDELFUNC contendo   ³
//³                     uma expressao logica que define se o usuario po-³
//³                     dera ou nao excluir o registro, por exemplo:    ³
//³                     cDelFunc := 'ExecBlock("TESTE")'  ou            ³
//³                     cDelFunc := ".T."                               ³
//³                     Note que ao se utilizar chamada de EXECBLOCKs,  ³
//³                     as aspas simples devem estar SEMPRE por fora da ³
//³                     sintaxe.                                        ³
//³       <TIPO>      - Identifica o tipo de rotina que sera executada. ³
//³                     Por exemplo, 1 identifica que sera uma rotina de³
//³                     pesquisa, portando alteracoes nao podem ser efe-³
//³                     tuadas. 3 indica que a rotina e de inclusao, por³
//³                     tanto, a rotina sera chamada continuamente ao   ³
//³                     final do processamento, ate o pressionamento de ³
//³                     <ESC>. Geralmente ao se usar uma chamada de     ³
//³                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Carga","U_RGUACG02()",0,4} ,;
{"Alt em massa","U_GUAC002WF()",0,4} ,;
{"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZZ"

dbSelectArea("ZZZ")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGUAC002  ºAutor  ³Microsiga           º Data ³  04/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RGUACG02
cPerg := "RGUACG02"
ValidPerg()
If Pergunte(cPerg,.T.)
	cQry := "SELECT * "
	cQry += "FROM "+RetSqlName("ZZZ")+" ZZZ "
	cQry += "WHERE ZZZ.D_E_L_E_T_<>'*' AND ZZZ_001='"+MV_PAR01+"' AND ZZZ_FILIAL='"+xFilial("ZZZ")+"' "
	TcQuery cQry New Alias "QRY1"
	DbSelectArea("QRY1")
	DbGotop()
	If !QRY1->(Eof())
		If MV_PAR02 == 1 //Criar
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbGotop()
			While !SA3->(Eof())
				DbSelectArea("ZZZ")
				DbSetOrder(1)
				If !DbSeek(xFilial("ZZZ")+SA3->A3_COD)
					_aStru := QRY1->(DbStruct())
					Reclock("ZZZ",.T.)
					For _x := 1 to len(_aStru)
						_cCpo := Alltrim(_aStru[_x,1])
						If !_cCpo $ "D_E_L_E_T_/R_E_C_N_O_/R_E_C_D_E_L_"
							ZZZ->&(_cCpo)	:= QRY1->&(_cCpo)
						EndIf
					Next
					ZZZ->ZZZ_001	:= SA3->A3_COD
					ZZZ->ZZZ_002 	:= SA3->A3_NOME
					
					MsUnlock()
				EndIf
				SA3->(DbSkip())
			EndDo                                         
			MsgInfo("Criação efetuada com sucesso!!!")
		ElseIf MV_PAR02 == 2 //Replicar todos os campos
			DbSelectArea("SA3")
			DbSetOrder(1)
			DbGotop()
			While !SA3->(Eof())
				DbSelectArea("ZZZ")
				DbSetOrder(1)
				If DbSeek(xFilial("ZZZ")+SA3->A3_COD)
					_aStru := QRY1->(DbStruct())
					Reclock("ZZZ",.F.)
					For _x := 1 to len(_aStru)
						_cCpo := Alltrim(_aStru[_x,1])
						If !_cCpo $ "D_E_L_E_T_/R_E_C_N_O_/R_E_C_D_E_L_"
							ZZZ->&(_cCpo)	:= QRY1->&(_cCpo)
						EndIf
					Next
					ZZZ->ZZZ_001	:= SA3->A3_COD
					ZZZ->ZZZ_002 	:= SA3->A3_NOME
					
					MsUnlock()
				EndIf
				SA3->(DbSkip())
			EndDo
			MsgInfo("Replicação concluída com sucesso!!!")
		EndIf
	Else
		Alert("Nenhum vendedor base com este código foi localizado!!!")
	EndIf
	QRY1->(DbCloseArea())
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGUAC002  ºAutor  ³Microsiga           º Data ³  04/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GUAC002WF()

Local	cCmps		:=	""
Local	aPar 		:=	{}
Local	cMVA010FAC	:=	GetNewPar("MV_A010FAC","")
cCmps	:= ""
For _x := 3 to 300
	cCmps	+=	"ZZZ_"+StrZero(_x,3)+"/"
Next
//cCmps	+=	cMVA010FAC

aAdd(aPar,{"ZZZ","ZZZ_001+' - '+ZZZ_002", cCmps,""})

FMATA984(aPar[1,1],aPar[1,2],aPar[1,3],,aPar[1,4])

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA984  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Facilitador generico de atualizacao para cadastros.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias da tabela a ser processada.                 ³±±
±±³          ³cExpApFim -> Expressao a ser apresentado ao final da atuali-³±±
±±³          ³ zacao. Deve conter somente campos da tabela envolvida. Ex: ³±±
±±³          ³ 'B1_COD+" - "+B1_DESC'                                     ³±±
±±³          ³cCampos -> Campos permitidos para alteracao separados por   ³±±
±±³          ³ "/".                                                       ³±±
±±³          ³aTxtApre -> Texto de apresentacao inicial do assistente da  ³±±
±±³          ³ rotina. Deve ser no formato de array. Ex:                  ³±±
±±³          ³ aTxtApre	:=	{}                                            ³±±
±±³          ³ aAdd(aTxtApre, "1")                                        ³±±
±±³          ³ aAdd(aTxtApre, "2")                                        ³±±
±±³          ³ aAdd(aTxtApre, "3")                                        ³±±
±±³          ³ aAdd(aTxtApre, "4")                                        ³±±
±±³          ³cPosiciona -> Funcao de posicione que pode ser passada para ³±±
±±³          ³ apresentacao da mensagem de conclusao.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Expande  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de maximizacao do browse de selecao do agrupamento. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cMarca -> Retorno da funcao GETMARK().                      ³±±
±±³          ³aCpos -> Campos do arquivo de trabalho para montagem do     ³±±
±±³          ³ browse.                                                    ³±±
±±³          ³lInverte -> Flag de selecao de registros do browse          ³±±
±±³          ³aList2 -> Array com todos os campos de usuario da tabela en-³±±
±±³          ³ volvida.                                                   ³±±
±±³          ³oFont -> Objeto de FONT padrao da rotina.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Expande (cMarca,aCpos,lInverte,aList2,oFont)
Local	oDlg
Local	lRet		:=	.T.
Local	oMSSelect
Local	cProcura	:=	Space(50)

DEFINE MSDIALOG oDlg FROM 0, 0 TO 480, 640 TITLE OemToAnsi (STR0022) PIXEL 	//"Grupo"
@ 4,5 TO 236,316 LABEL STR0022 OF oDlg PIXEL	//"Grupo"
oMSSelect	:=	MsSelect():New ("TRB", "TRB_OK",,aCpos, @lInverte, @cMarca, {30, 12, 230, 310},,,oDlg)
oMSSelect:oBrowse:lHasMark 		:= 	.f.
oMSSelect:oBrowse:lCanAllMark	:=	.f.

TButton ():New (15, 12, OemToAnsi (STR0053), oDlg, {||oDlg:End()}, 30, 11,, oDlg, .F., .T., .F.,, .F.,,, .F.)	//"Fechar"

TSay ():New (15, 185, {||STR0050}, oDlg,,oFont,.F.,.F.,.F., .T.,,, 100, 10, .F., .F., .F., .F., .F.)	//"Pesquisar"
TGet ():New (14, 211, {|u| Iif(PCount()==0,cProcura,cProcura:=u)}, oDlg, 100, 9, "@!",{||Procura(2,oMSSelect,cProcura,aList2)},,,,,, .T.)

ACTIVATE MSDIALOG oDlg CENTERED

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MontTrb  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de criaca/exclusao do arquivo de trabalho utilizado  ³±±
±±³          ³ na montagem do browse de selecao do agrupamento.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nOpcao -> Opcao de chamada da funcao. 1=Cria/2=Exclui.      ³±±
±±³          ³aList2 -> Array com todos os campos de usuario da tabela en-³±±
±±³          ³ volvida.                                                   ³±±
±±³          ³aTrb -> Array com o arquivo de trabalho criado.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontTrb(nOpcao, aList2, aTrb)
Local	aStru	:=	{}
Local	cArq	:=	""
Local	nI		:=	0

Default	aTrb	:=	{}

If (nOpcao==1)
	aAdd(aStru,{"TRB_OK",	"C",	002,					0})
	aAdd(aStru,{"TRB_CMP1",	"C",	Len(SX3->X3_CAMPO),		0})
	aAdd(aStru,{"TRB_CMP2",	"C",	Len(SX3->X3_DESCRIC),	0})
	
	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T., __LocalDriver, cArq, "TRB")
	IndRegua("TRB", cArq, "TRB_CMP1")
	
	aTrb	:=	{"TRB",cArq}
	
	For nI := 1 To Len(aList2)
		RecLock("TRB", .T.)
			TRB->TRB_CMP1	:=	aList2[nI,1]
			TRB->TRB_CMP2	:=	aList2[nI,2]
		MsUnLock()
	Next nI
	dbGoTop()
Else
	DbSelectArea (aTrb[1])
		(aTrb[1])->(DbCloseArea ())
	Ferase (aTrb[2]+GetDBExtension ())
	Ferase (aTrb[2]+OrdBagExt ())
EndIf

Return aTrb
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Procura  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de pesquisa nos assistentes de selecao de campos da  ³±±
±±³          ³ rotina.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nOpcao -> Opcao de chamada da funcao. 1=Primeiro assistente/³±±
±±³          ³ 2=Segundo assistente.                                      ³±±
±±³          ³ volvida.                                                   ³±±
±±³          ³oObj -> Objeto de pesquisa criado.                          ³±±
±±³          ³cProcura -> Conteudo de pesquisa digitado.                  ³±±
±±³          ³aList -> Array com os itens a pesquisar.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Procura(nOpcao,oObj,cProcura,aList) 
Local	lRet		:=	.T.
Local	nPos		:=	0

//Pesquiso pelo nome do campo
nPos	:=	aScan(aList,{|aX| AllTrim(cProcura)==Left(aX[1],Len(AllTrim(cProcura)))})

If nOpcao==1
	oObj:nAT := Iif(nPos==0,1,nPos)
	oObj:Refresh()
Else
	dbSelectArea("TRB")
	TRB->(dbSeek(AllTrim(cProcura)))
	oObj:oBrowse:Refresh()
EndIf
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValPainel³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao das trocas de paineis do wizard.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oWizard -> Objeto wizard.                                   ³±±
±±³          ³oTWBrow -> Objeto o Browse de selecao do campo a ser alterado³±±
±±³          ³cAlias -> Alias da tabela de referencia.                    ³±±
±±³          ³cFil -> Filtro selecionado no assistente da rotina.         ³±±
±±³          ³oGetDad -> Objeto getdados do browse de atualizacao da rotina³±±
±±³          ³aResumo -> Textos do resumo final apresentado antes de      ³±±
±±³          ³ iniciar a atualizacao.                                     ³±±
±±³          ³cTitTabela -> Titulo da tabela em processamento.            ³±±
±±³          ³cDescFiltro -> Descricao por extenso do filtro selecionado. ³±±
±±³          ³cMarca -> Retorno do GETMARK()                              ³±±
±±³          ³cCdBlock -> Codeblock de verificacao do produto para altera-³±±
±±³          ³ cao.                                                       ³±±
±±³          ³cCampo -> Nome do campo que podera ser atualizado.          ³±±
±±³          ³oTree -> Objeto do TREE apresentado no resumo do processamento³±±
±±³          ³aIndKey -> Campos chave da tabela baseado no indice caso nao³±±
±±³          ³ seja selecionado nenhum campo no agrupamento para edicao.  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Atualiza  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de atualizacao da tabela envolvida.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oWizard -> Objeto wizard.                                   ³±±
±±³          ³aList -> Array com campos validos para atualizacao.         ³±±
±±³          ³aList2 -> Array com todos os campos da tabela em questao.   ³±±
±±³          ³nList -> Posicao do listbox de campos a serem atualizados.  ³±±
±±³          ³cAlias -> Alias da tabela de referencia.                    ³±±
±±³          ³cFil -> Filtro selecionado no assistente da rotina.         ³±±
±±³          ³oGetDad -> Objeto getdados do browse de atualizacao da rotina³±±
±±³          ³cTexto -> Texto contendo o os registros atualizados.        ³±±
±±³          ³cExpApFim -> Expressao utilizada para montar o texto ao final³±±
±±³          ³ do processo de atualizacao.                                ³±±
±±³          ³aIndKey -> Campos chave da tabela baseado no indice caso nao³±±
±±³          ³ seja selecionado nenhum campo no agrupamento para edicao.  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Atualiza(cCampo,oGetDad,cAlias,cFil,cTexto,cExpApFim,cPosiciona,cCdBlock,aIndKey)

Local 	aAreaSX3 	:= SX3->( GetArea() )
Local	nPos		:=	0
Local	lRet		:=	.F.
Local	aRotAut		:=	{}
Local	aArea		:=	{}
Local	cFrom 		:=	""
Local	cWhere		:=	""
Local	cOrder		:=	""
Local	cFilQry		:=	""
Local	cAliasAnt	:=	cAlias
Local	nI			:=	0
Local	aErro		:=	{}
Local   cValor		:= ""

aColsWiz	:=	oGetDad:aCols

DbSelectArea (cAlias)
(cAlias)->(DbSetOrder (1))
#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		cFrom	:=	"%"+RetSqlName(cAlias)+" "+cAlias+"%"
		cFilQry	:=	SubStr(cAlias,1,3)+"_FILIAL"
		cWhere	:=	"%"+cAlias+".D_E_L_E_T_=' ' AND "+cAlias+"."+cFilQry+"='"+xFilial(cAlias)+"'%"
		cOrder	:=	"%"+SqlOrder(IndexKey())+"%"
		cAlias	:=	GetNextAlias()
	    	
    	BeginSql Alias cAlias
		SELECT 
			COUNT(R_E_C_N_O_) CTD
		FROM 
			%Exp:cFrom%
		WHERE 
			%Exp:cWhere%
		EndSql
		ProcRegua(CTD)
		dbSelectArea(cAlias)
		dbCloseArea()
		
		BeginSql Alias cAlias
		SELECT *
		FROM 
			%Exp:cFrom%
		WHERE 
			%Exp:cWhere%
		ORDER BY 
			%Exp:cOrder%
		EndSql
	Else
#ENDIF

	dbSelectArea(cAlias)
	ProcRegua(LastRec())
	dbSeek(xFilial())

#IFDEF TOP
	Endif
#ENDIF

cFil := StrTran(UPPER(cFil),"DTOS")

While !Eof() .And. xFilial(cAliasAnt)==&(SubStr(cAliasAnt,1,3)+"_FILIAL")
	If !Empty(cFil) .And. !(cAlias)->(&(cFil))
		Skip()
		IncProc()
		Loop
	EndIf
	
	If Len(aColsWiz)<>0 .And. (nPos := &(cCdBlock))<>0 .And.;	
		aColsWiz[nPos,Len(aColsWiz[nPos])-1]<>aColsWiz[nPos,Len(aColsWiz[nPos])-2]

		aRotAut		:=	{}
		lRet		:=	.T.
		
		For nI := 1 To Len(aIndKey)
			aAdd(aRotAut,{aIndKey[nI], &(aIndKey[nI]), Nil})
		Next nI

		DbSelectArea("SX3")
		DbSetOrder(2)
		If dbSeek(cCampo) .And. SX3->X3_TIPO == "D"
			cValor := stod(aColsWiz[nPos,Len(aColsWiz[nPos])-1])
		Else 
			cValor := (aColsWiz[nPos,Len(aColsWiz[nPos])-1])
		Endif
		
		dbSelectArea(cAlias)
		
		aAdd(aRotAut,{cCampo, cValor, Nil})

		aArea	:=	GetArea()
		
/*		If "SB1"==cAliasAnt
			MATA010(aRotAut,4)
		ElseIf "SA2"==cAliasAnt
			MATA020(aRotAut,4)
		ElseIf "SA1"==cAliasAnt
			MATA030(aRotAut,4)
		ElseIf "SF4"==cAliasAnt
			MATA080(aRotAut,4)
		ElseIf "SFM"==cAliasAnt
			MATA089(aRotAut,4)
   		EndIf*/
   		DbSelectArea("ZZZ")
   		DbGoto((CALIAS)->R_E_C_N_O_)
   		Reclock("ZZZ",.F.)
   		ZZZ->&(aRotAut[2,1]) := aRotAut[2,2]
   		MsUnlock()
   		
		dbSelectArea(cAlias)
		If !Empty(cExpApFim)
			cTexto	+=	&(cExpApFim)
		EndIf
		
		If !Empty(cPosiciona)
			cTexto	+=	" - "+&cPosiciona
		EndIf
		cTexto	:=	AllTrim(cTexto)
		
		If lMsErroAuto
			cTexto	+=	STR0060+NomeAutoLog()+STR0043	//" --> Não atualizado, verificar observação deste registro no arquivo "###" criado no diretório STARTPATH do sistema, geralmente SYSTEM ou SIGAADV."
			cTexto	+=	CRLF
		Else
			cTexto	+= "Atualização efetuada com sucesso."
			cTexto	+=	CRLF
		EndIf

		RestArea(aArea)
	EndIf

	Skip()
	IncProc()
End

#IFDEF TOP
	dbSelectArea(cAlias)
	dbCloseArea()
#ENDIF 

RestArea(aAreaSX3)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BkPainel  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao validacao ao voltar o assistente da rotina. Utiliza- ³±±
±±³          ³ para zerar o variavel memo quando voltar no assistente.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oWizard -> Objeto wizard.                                   ³±±
±±³          ³oTree -> Objeto do TREE apresentado no resumo do processamento³±±
±±³          ³cMemo -> Variavel memo de help para cada selecao do tree.   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BkPainel(oWizard,oTree,cMemo)
Local	lRet	:=	.T.

If oWizard:NPANEL==6
	oTree:TreeSeek("L1"+StrZero (0, 2, 0))
	cMemo	:=	STR0056	//"Confira o resumo clicando em umas das opções à esquerda."
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcWiz   ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de processamento as informacoes do assistente para   ³±±
±±³          ³ montar o browse de atualizacao dos campos.                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oWizard -> Objeto wizard.                                   ³±±
±±³          ³oTWBrow -> Objeto o Browse de selecao do campo a ser alterado³±±
±±³          ³cAlias -> Alias da tabela de referencia.                    ³±±
±±³          ³cFil -> Filtro selecionado no assistente da rotina.         ³±±
±±³          ³oGetDad -> Objeto getdados do browse de atualizacao da rotina³±±
±±³          ³cMarca -> Retorno do GETMARK()                              ³±±
±±³          ³aIndKey -> Campos chave da tabela baseado no indice caso nao³±±
±±³          ³ seja selecionado nenhum campo no agrupamento para edicao.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcWiz(oWizard,oTWBrow,cAlias,cFil,oGetDad,cMarca,cCdBlock,cCampo,aIndKey)
Local	lRet		:=	.F.
Local	nI			:=	1
Local	lSelCmp		:=	.F.
Local	aAgrCmps	:=	{}
Local	cFrom 		:=	""
Local	cWhere		:=	""
Local	cOrder		:=	""
Local	cFilQry		:=	""
Local	cAliasAnt	:=	cAlias
 
aColsWiz	:=	{}
cCampo		:=	AllTrim(oTWBrow:AARRAY[oTWBrow:nAT,1])
cCdBlock	:=	"aScan(aColsWiz,{|aX| "
                                                           	
TRB->(dbGoTop())
While !TRB->(Eof())
	If TRB->TRB_OK==cMarca
		lSelCmp	:=	.T.
		aAdd (aAgrCmps,TRB->TRB_CMP1)
		cCdBlock	+=	"aX["+AllTrim(Str(nI++))+"]=="+AllTrim(TRB->TRB_CMP1)+".And."	
	EndIf
	TRB->(dbSkip())
End

If Len(aIndKey)==0
	aIndKey		:=	&("{'"+StrTran(AllTrim((cAlias)->(IndexKey())),"+","','")+"'}")
	aDel(aIndKey,1)
	aSize(aIndKey,Len(aIndKey)-1)
EndIf

If lSelCmp
	cCdBlock	+=	"aX["+AllTrim(Str(nI++))+"]=="+cCampo
Else
	For nI := 1 To Len(aIndKey)
		cCdBlock	+=	"aX["+AllTrim(Str(nI))+"]=="+AllTrim(aIndKey[nI])+".And."
	Next nI	
	cCdBlock	+=	"aX["+AllTrim(Str(nI++))+"]=="+cCampo
	aAgrCmps	:=	aClone(aIndKey)
EndIf
cCdBlock	+=	"})"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao que monta o ACOLS e AHEADER³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcGetD(aAgrCmps,cCampo)

DbSelectArea (cAlias)
(cAlias)->(DbSetOrder (1))

#IFDEF TOP
	If (TcSrvType ()<>"AS/400")
		cFrom	:=	"%"+RetSqlName(cAlias)+" "+cAlias+"%"
		cFilQry	:=	SubStr(cAlias,1,3)+"_FILIAL"
		cWhere	:=	"%"+cAlias+".D_E_L_E_T_=' ' AND "+cAlias+"."+cFilQry+"='"+xFilial(cAlias)+"'%"
		cOrder	:=	"%"+SqlOrder(IndexKey())+"%"
		cAlias	:=	GetNextAlias()
	    	
    	BeginSql Alias cAlias
		SELECT 
			COUNT(R_E_C_N_O_) AS CTD
		FROM 
			%Exp:cFrom%
		WHERE 
			%Exp:cWhere%
		EndSql
		ProcRegua(CTD)
		dbSelectArea(cAlias)
		dbCloseArea()
		
		BeginSql Alias cAlias
		SELECT *
		FROM 
			%Exp:cFrom%
		WHERE 
			%Exp:cWhere%
		ORDER BY 
			%Exp:cOrder%
		EndSql
	Else
#ENDIF

	dbSelectArea(cAlias)
	ProcRegua(LastRec())
	dbSeek(xFilial())

#IFDEF TOP
	Endif
#ENDIF	

cFil := StrTran(UPPER(cFil),"DTOS")

While !Eof() .And. xFilial(cAliasAnt)==&(SubStr(cAliasAnt,1,3)+"_FILIAL")
	
	If !Empty(cFil) .And. !(cAlias)->(&(cFil))
		Skip()
		IncProc()
		Loop
	EndIf
	
	If Len(aColsWiz)==0 .Or. (nPos := &(cCdBlock))==0
		aAdd(aColsWiz,{})
		For nI := 1 To Len(aAgrCmps)
			aAdd(aTail(aColsWiz),&(aAgrCmps[nI]))
		Next nI
		aAdd(aTail(aColsWiz),&(cCampo))
		aAdd(aTail(aColsWiz),&(cCampo))
		aAdd(aTail(aColsWiz),.F.)
	EndIf

	Skip()
	IncProc()
	lRet	:=	.T.
End

#IFDEF TOP
	dbSelectArea(cAlias)
	dbCloseArea()
#ENDIF

If lRet
	aSort(aColsWiz,,,{|x,y|x[1]<y[1]})
	oGetDad := MsNewGetDados():New(5,5,133,283,GD_UPDATE,"AllwaysTrue","AllwaysTrue",,{"TRB_CMPNV"},/*freeze*/,Len(aColsWiz),/*fieldok*/,/*superdel*/,/*delok*/,oWizard:oMPanel[oWizard:NPANEL+1],aHeadWiz,aColsWiz)
EndIf
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcGetD  ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de processamento as informacoes do assistente para   ³±±
±±³          ³ montar o browse de atualizacao dos campos.                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aAgrCmps -> Campos terao agrupamento no browse.             ³±±
±±³          ³cCampo -> Campo que deverah ser atualizado.                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcGetD(aAgrCmps,cCampo)
Local	lRet	:=	.T.
Local	nI		:=	0

aHeadWiz	:=	{}

For nI := 1 To Len(aAgrCmps)
	dbSelectArea("SX3")
	dbSetOrder(2)
	MsSeek(aAgrCmps[nI])
	AADD(aHeadWiz,{TRIM(x3titulo()),;
		"TRB_CMP"+StrZero(nI,3),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		".F.",;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		".T."})
Next nI

MsSeek(cCampo)
AADD(aHeadWiz,{TRIM(x3titulo()),;
	"TRB_CMP2",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	".F.",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	".T."})

AADD(aHeadWiz,{TRIM(x3titulo())+"(Novo)",;
	"TRB_CMPNV",;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	".T.",;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	".T."})

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontClick ³ Autor ³ Gustavo G. Rueda      ³ Data ³ 22/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de apresentacao do resumo ao se clicar em uma das    ³±±
±±³          ³ opcoes do tree.                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. ou  .F.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oTree -> Objeto do TREE apresentado no resumo do processamento³±±
±±³          ³cMemo -> Variavel memo de help para cada selecao do tree.   ³±±
±±³          ³aResumo -> Textos do resumo final apresentado antes de      ³±±
±±³          ³ iniciar a atualizacao.                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontClick(oTree, cMemo, aResumo)
Local	lRet	:=	.T.

If ("L1"$oTree:GetCargo())
	cMemo	:=	""
	cMemo	+=	aResumo[1]
ElseIf ("L201"$oTree:GetCargo())
	cMemo	:=	""
	cMemo	+=	aResumo[2]
ElseIf ("L202"$oTree:GetCargo())
	cMemo	:=	""
	cMemo	+=	aResumo[3]
ElseIf ("L203"$oTree:GetCargo())
	cMemo	:=	""
	cMemo	+=	aResumo[4]	
EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGUAC002  ºAutor  ³Microsiga           º Data ³  04/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

_sAlias := GetArea()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,10)
aRegs   := {}
//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Vendedor base      ?","","","mv_ch1","C",06,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","",""})
aAdd(aRegs,{cPerg,"02","Metodo de carga    ?","","","mv_ch2","N",01,0,0,"C","naovazio()","mv_par02","Criar","","","","","Replicar","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"02","Metodo de carga    ?","","","mv_ch2","C",09,0,0,"G","naovazio()","mv_par02","Criar","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Data               ?","","","mv_ch3","D",08,0,0,"G","naovazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Usage Code SE/PR/PS?","","","mv_ch4","C",02,0,0,"G","naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

RestArea(_sAlias)

Return
