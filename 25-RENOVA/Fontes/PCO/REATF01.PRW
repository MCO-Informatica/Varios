#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REATFA01  ºAutor  ³Microsiga           º Data ³  22/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³          º±±
±±º          ³              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function REATFA01()

Local cAlias := "SZ0"
Local aCores := {}

Private cCadastro := "Cadastro de Projetos Imobilizados em Curso"
Private aRotina := {}

AADD(aRotina,{"Pesquisar"  ,"PesqBrw"   ,0,1})
AADD(aRotina,{"Visualizar" ,"AxVisual"  ,0,2})
AADD(aRotina,{"Incluir"    ,"AxInclui"  ,0,3})
AADD(aRotina,{"Alterar"    ,"U_BAltera" ,0,4})
AADD(aRotina,{"Excluir"    ,"U_BDeleta" ,0,5})
AADD(aRotina,{"Legenda"    ,"U_BLegenda",0,6})
AADD(aRotina,{"Automatico" ,"U_Bauto",0,6})

AADD(aCores,{"Z0_STATUS=='1'" ,"BR_VERDE" })
AADD(aCores,{"Z0_STATUS=='2'" ,"BR_VERMELHO" })
AADD(aCores,{"Z0_STATUS=='3'" ,"BR_LARANJA" })
AADD(aCores,{"Z0_STATUS=='4'" ,"BR_AZUL" })

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,,,,,,aCores)

Return Nil

//+-----------------------------------------
//|Função: BAltera - Rotina de Alteração
//+-----------------------------------------
User Function BAltera(cAlias,nReg,nOpc)

Local nOpcao := 0

If SZ0->Z0_STATUS = '2'
	MsgInfo("O projeto esta encerrado não pode ser alterado!!!")
ElseIF SZ0->Z0_STATUS $ '3/4'
	MsgInfo("O projeto esta em andamento ou com bloqueio contábil não pode ser alterado!!!")
Else
	nOpcao := AxAltera(cAlias,nReg,nOpc)
	If nOpcao == 1
		MsgInfo("Alteração efetuada com sucesso!")
	Else
		MsgInfo("Alteração cancelada!")
	Endif
EndIf

Return Nil

//+-----------------------------------------
//|Função: BDeleta - Rotina de Exclusão
//+-----------------------------------------
User Function BDeleta(cAlias,nReg,nOpc)

Local nOpcao := 0

If SZ0->Z0_STATUS $ '2'
	MsgInfo("O projeto esta encerrado não pode ser excluido!!!")
ElseIF SZ0->Z0_STATUS $ '3/4'
	MsgInfo("O projeto esta em andamento ou com bloqueio contábil não pode ser excluido!!!")
Else
	nOpcao := AxDeleta(cAlias,nReg,nOpc)
	If nOpcao == 1
		MsgInfo("Exclusão cancelada!")
	Else
		MsgInfo("Exclusão efetuada com sucesso!")
	Endif
EndIf

Return Nil

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"   ,"Aberto" })
AADD(aLegenda,{"BR_Vermelho","Encerrado" })
AADD(aLegenda,{"BR_Laranja" ,"Andamento" })
AADD(aLegenda,{"BR_Azul"    ,"Bloq Contábil" })

BrwLegenda(cCadastro, "Legenda-Projeto Imobilizado", aLegenda)

Return Nil

//+-------------------------------------------
//|Função: Bauto - Gera Projeto pelo Item Contábil Automatico
//+-------------------------------------------

User Function Bauto()
                
Processa( { || _Bauto2() }, "Geração automática de Projeto Imobilizado" , 'Atualizando...', .F. )

Return nil

Static Function _Bauto2()

Local _cCodProj := ''
Local _nCount   := 0 
Local _cQuery   := ''
Local _cAlias   := GetNextAlias()

_cQuery := "SELECT CTD_FILIAL, CTD_ITEM, CTD_CLASSE, CTD_DESC01, CTD_BLOQ, CTD_XIMCUR FROM "+ RetsqlName("CTD")
_cQuery += " WHERE CTD_FILIAL = '"+xFilial("SZ0")+ "'"
_cQuery += " AND CTD_XIMCUR = 'S'"
_cQuery += " AND D_E_L_E_T_ <> '*'"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

DbSelectArea("SZ0")

//DbSelectArea(_cAlias)
(_cAlias)->(DbGoTop())

//Contador para regua......
Do While!(_cAlias)->(EOF())
	_nCount := _nCount + 1              
	(_cAlias)->(DbSkip())
EndDo
//Fim do Contador
ProcRegua(_nCount)// Numero de registros a processar  

(_cAlias)->(DbGoTop())

Do While !(_cAlias)->(EOF())
	
	IncProc("Processando... "+(_cAlias)->CTD_ITEM)
		
	SZ0->(DbSetOrder(6))
	SZ0->(DBGoTop())
	
	If !SZ0->(MsSeek((_cAlias)->CTD_FILIAL+(_cAlias)->CTD_ITEM))
		_cCodProj := 	GetSXENum("SZ0","Z0_CODIGO")
		ConfirmSX8()
		RecLock("SZ0",.T.)
		Z0_FILIAL  := xFilial("SZ0")
		Z0_CODIGO  := "PRJ"+SUBSTR(_cCodProj,4,7)
		Z0_NOME    := (_cAlias)->CTD_DESC01
		If (_cAlias)->CTD_BLOQ <> '1' 
			Z0_STATUS  := '1' //Aberto
		Else
			Z0_STATUS  := '4' //Bloq. Contábil			
		EndIf
		Z0_ITEM    := (_cAlias)->CTD_ITEM
		Z0_ITEMDES := (_cAlias)->CTD_DESC01
		MsUnlock()
	EndIf
	
	(_cAlias)->(DbSkip())

Enddo

(_cAlias)->(DbCloseArea())

Return nil