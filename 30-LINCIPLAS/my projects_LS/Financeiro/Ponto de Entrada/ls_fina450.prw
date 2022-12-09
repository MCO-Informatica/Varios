#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa		fina450
// Autor		alexandre dalpiaz
// Data			06/05/2013
// Descricao	Filtro do Browse da rotina de compensação entre carteiras
// Uso			Laselva S/A
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_FINA450()
//////////////////////////

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local aPergs := {}
Local nRegSE2 := SE2->(Recno())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o n£mero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cLote
Private cMarca := GetMark()
Private lInverte
Private cTipos := ""
Private cCadastro := "Comp Pagar / Receber"
Private cModSpb := "1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Usado no Chile, indica se serao compensados titulos de credito ou de debito³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nDebCred	:=	1
Private aRotina := MenuDef()

nPosArotina := 0

Fa450MotBx("CEC","COMP CARTE","ASSS")

VALOR 		:= 0
VALOR2		:= 0
VALOR3		:= 0
VALOR4		:= 0
VALOR5		:= 0
VLRINSTR    := 0

SetKey (VK_F12,{|a,b| AcessaPerg("AFI450",.T.)})

U_LS_MATRIZ()
pergunte("AFI450",.F.)

Public _cFilBrow	:= "E2_MATRIZ == '" + cFilAnt + "'"
If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("SE2")
	nRegSE2 := Recno()
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
	MSGoto(nRegSE2)
Else
	
	DbSelectArea('SE2')
	Set Filter to &_cFilBrow
	mBrowse(6,1,22,75,"SE2",,,,,,Fa450Leg())
Endif

dbSelectArea("SE5")
dbSetOrder(1)	&& devolve ordem principal
Return
                                               
iif(!Formula('SB1'),Aviso('teste1','teste2',{'ok'}) <> 1,.t.)          

(!Vazio() .and. !M->B1_GRUPO $ GetMv('MV_GRPISEN')) .or. (Vazio() .and. M->B1_GRUPO $ GetMv('MV_GRPISEN'))                      
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F450OWN()
///////////////////////

Private lVerLibTit := .T.

cString := 'E1_FILIAL=="' + xFilial('SE1') + '".And.'
cString += 'DTOS(E1_VENCREA)>="' + DTOS(dVenIni450) + '".And.'
cString += 'DTOS(E1_VENCREA)<="' + DTOS(dVenFim450) + '".And.'

If !lTitFuturo
	cString += 'DTOS(E1_EMISSAO)<="' + DTOS(dDataBase) + '".And.'
Endif

If nDebCred == 1
	cString += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+'").And. '
ElseIf  nDebCred == 2
	cString += '(E1_TIPO$"'+MVRECANT+"/"+MV_CRNEG+'").And. '
Endif
// Se nao considera titulos transferidos, filtra (exibe) apenas os titulos que estao em carteira.
If mv_par03 == 2
	cString += 'E1_SITUACA$"0FG".And.'
Endif
cString += 'E1_MOEDA=' + Alltrim(Str(nMoeda,2)) + '.And.'
cString += 'E1_SALDO>0.And.'
cString += 'E1_CLIENTE ="' + cCli450 + '"'
If !Empty(cLjCli)
	cString += '.And.E1_LOJA ="' + cLjCli + '"'
Endif
cString += '.and. E1_MATRIZ = cFilAnt'
Return(cString)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F450OWN1()
////////////////////////
Private lVerLibTit := .t.

cString := 'E2_FILIAL=="' + xFilial('SE2')+ '".And.'
cString += 'DTOS(E2_VENCREA)>="' + DTOS(dVenIni450) + '".And.'
cString += 'DTOS(E2_VENCREA)<="' + DTOS(dVenFim450) + '".And.'

If !lTitFuturo
	cString += 'DTOS(E2_EMIS1)<="' + DTOS(dDataBase) + '".And.'
Endif

If nDebCred == 1 // Titulos Normais
	cString += '!(E2_TIPO$"'+MVPROVIS+"/"+MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM+'").And.'
ElseIf  nDebCred == 2
	cString += '(E2_TIPO$"'+MVPAGANT+"/"+MV_CPNEG+'").And.'
Endif
cString += 'E2_MOEDA=' + Alltrim(Str(nMoeda,2)) + '.And.'
cString += 'E2_SALDO>0.And.'

IF (ExistBlock("F450LIBT"))
	lVerLibTit :=ExecBlock("F450LIBT",.f.,.f.)
Endif

// controla Liberacao do titulo
If lVerLibTit
	If !Empty(GetMv("MV_APRPAG"))
		cString += '!(Empty(E2_DATALIB)) .And. '
	EndIf
	
	If !Empty(GetMv("MV_CTLIPAG") )
		nValmin:= GetMV("MV_VLMINPG")
		cString += "((DTOS(E2_DATALIB) <> '        ').Or. ((DTOS(E2_DATALIB) <> '        ').And.(E2_SALDO + E2_SDACRES - E2_SDDECRE)< " + str(nValmin)+ ")) .And. "
	EndIf
EndIf

cString += 'E2_FORNECE == "' + cFor450 + '"'
If !Empty(cLjFor)
	cString += '.And. E2_LOJA == "' + cLjFor + '"'
Endif
cString += '.and. E2_MATRIZ == cFilAnt'

Return(cString)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _FA450BUT()
////////////////////////
/*
If FunName() == 'LS_FINA450'
//aAdd( paramixb,	{ 'Filtro'     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})
EndIf
*/
Return(paramixb)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³27/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Local aRotina := {}
aAdd(aRotina, { "Pesquisar"	 , "AxPesqui"   , 0 , 1,,.F.})
aAdd(aRotina, { "Visualizar" , "AxVisual"   , 0 , 2})
aAdd(aRotina, { "Compensar"	 , "Fa450CMP"   , 0 , 3})
aAdd(aRotina, { "Cancelar"	 , "Fa450Can"   , 0 , 6})
aAdd(aRotina, { "Estornar"	 , "Fa450Can"   , 0 , 5})
//aAdd(aRotina, { "Filtro"     , 'U_LS_FILTRO("SE2",_cFilBrow)'	, 0 , 2})
aAdd(aRotina, { "Legenda"	 , "Fa450Leg"	, 0	, 7,,.F.})

Return(aRotina)                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FA450MotBXºAutor  ³Marcelo Celi Marquesº Data ³  29/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao criar automaticamente o motivo de baixa CEC na      º±±
±±º          ³ tabela Mot baixas                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA450                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa450MotBx(cMot,cNomMot, cConfMot)
Local aMotbx := ReadMotBx()
Local nHdlMot, I, cFile := "SIGAADV.MOT"

If ExistBlock("FILEMOT")
	cFile := ExecBlock("FILEMOT",.F.,.F.,{cFile})
Endif

If Ascan(aMotbx, {|x| Substr(x,1,3) == Upper(cMot)}) < 1
	nHdlMot := FOPEN(cFile,FO_READWRITE)
	If nHdlMot <0
		HELP(" ",1,"SIGAADV.MOT")
		Final("SIGAADV.MOT")
	Endif
	
	nTamArq:=FSEEK(nHdlMot,0,2)	// VerIfica tamanho do arquivo
	FSEEK(nHdlMot,0,0)			// Volta para inicio do arquivo
	
	For I:= 0 to  nTamArq step 19 // Processo para ir para o final do arquivo
		xBuffer:=Space(19)
		FREAD(nHdlMot,@xBuffer,19)
	Next
	
	fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))
	fClose(nHdlMot)
EndIf
Return
