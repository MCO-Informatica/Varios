#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWADAPTEREAI.CH'
#DEFINE OK  		1
#DEFINE VISUALIZAR	2
#DEFINE BLOQUEAR	3
#DEFINE ENTER		Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ABCTBM09()  ºAutor  ³Microsiga          º Data ³  24/10/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Objetivo do fonte é de efetuar o bloqueio conforme data     º±±
±±º          ³data informada nos parametros: MV_DATAFIN, MV_DATAFIS e     º±±
±±º          ³MV_ULMES.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ABCTBM09()

	Local oDlg    := Nil

	DEFINE MSDIALOG oDlg FROM  96,   9 TO 342,592 TITLE "Bloqueia Origem de Dados Contábeis" PIXEL

	@ 13, 6 TO 84, 287 LABEL "" OF oDlg  PIXEL
	@ 24, 15 SAY "O objetivo deste programa é de efetuar os bloqueios de lançamentos de integrações contábeis," SIZE 268, 8 OF oDlg PIXEL
	@ 33, 15 SAY "referente aos Modulos de Faturamento, Compras, Financeiro e Fiscal." SIZE 268, 8 OF oDlg PIXEL
	@ 42, 15 SAY "Conteúdo dos Parametros:" SIZE 268, 8 OF oDlg PIXEL
	@ 51, 15 SAY "Finaceiro - MV_DATAFIN = "+Dtoc(SUPERGETMV("MV_DATAFIN",.f.,StoD("19800131"))) SIZE 268, 8 OF oDlg PIXEL
	@ 60, 15 SAY "Materiais - MV_DBLQMOV  = "+Dtoc(SUPERGETMV("MV_DBLQMOV",.f.,StoD("19800131")))   SIZE 268, 8 OF oDlg PIXEL
	@ 69, 15 SAY "Fiscal    - MV_DATAFIS = "+Dtoc(SUPERGETMV("MV_DATAFIS",.f.,StoD("19800131"))) SIZE 268, 8 OF oDlg PIXEL

	DEFINE SBUTTON FROM 107, 224 TYPE 1 ACTION (oDlg:End(),ABCTBM09A()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 107, 251 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ABCTBM09  ºAutor  ³Microsiga           º Data ³  24/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ABCTBM09A()
	Local oBrowse      := NIL
	Local aAreaAtu     := GetArea()
	Private aRotina    := {}
	Private cCadastro  := "Bloqueio Origem de Dados Contabeis"

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZS")
	oBrowse:SetDescription (cCadastro)
	oBrowse:SetWalkThru(.F.)

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'Axpesqui'   OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'AxVisual'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Bloquear'   ACTION 'U_BLOQMOD'  OPERATION 3 ACCESS 0

	oBrowse:Activate()

	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BLOQMOD  ºAutor  ³Microsiga           º Data ³  24/10/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BLOQMOD()

	Local   oDlg     := Nil
	Private dDatFin  := Ctod(Space(8))
	Private dDatEst  := Ctod(Space(8))
	Private dDatFis  := Ctod(Space(8))
	Private _cEmpFil := Space(9)
	Private _cFilant := Space(7)

//+----------------------------------------------------------------------------
//| Definição da janela e seus conteúdos
//+----------------------------------------------------------------------------
	DEFINE MSDIALOG oDlg TITLE "Bloqueia Origem de Dados Contábeis" FROM 0,0 TO 280,552 OF oDlg PIXEL

	@ 015, 15 SAY "Bloq. Financeiro" SIZE 45,8 PIXEL OF oDlg
	@ 015, 75 MSGET dDatFin PICTURE "99/99/9999" SIZE 80,10 PIXEL OF oDlg

	@ 045, 15 SAY "Bloq. Materias"  SIZE 45,8 PIXEL OF oDlg
	@ 045, 75 MSGET dDatEst PICTURE "99/99/9999" SIZE 80,10 PIXEL OF oDlg

	@ 085, 15 SAY "Bloq. Fiscal"   SIZE 35,8 PIXEL OF oDlg
	@ 085, 75 MSGET dDatFis PICTURE "99/99/9999" SIZE 80,10 PIXEL OF oDlg

	@ 125, 15 SAY "Empresas"   SIZE 35,8 PIXEL OF oDlg
	@ 125, 75 MSGET _cEmpFil F3 "EMP" PICTURE "@!" SIZE 80,10 PIXEL OF oDlg

	@ 130,15 SAY "Preencha o campo Empresa com 1 '*' caso queira selecionar todas as empresas."

//+----------------------------------------------------------------------------
//| Botoes da MSDialog
//+----------------------------------------------------------------------------
	@ 093,235 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION (GRAVDAD(), oDlg:End())
	@ 113,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTER

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVDAD   ºAutor  ³Microsiga           º Data ³  10/08/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a gravaçao e validação dos dados                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GRAVDAD()

	Local cArqSX    := Space(180)
	Local nTamCod   := Len(cEmpant)
	Local nTamFil   := Len(cFilAnt)
	Local nTamNome  := Len(SM0->M0_NOME)
	Local aEmpr     := {}
	Local _lFilExiste := .F.
	Local	_aArea			:= GetArea()
	Private oObj
	Private _aStru      := {}, aCampos := {}
	

	If Len(Alltrim(_cEmpFil)) == nTamCod+nTamFil //9
		_cFilAnt := SubStr(_cEmpFil,nTamCod+1,nTamFil)
	ElseIf Len(Alltrim(_cEmpFil)) == nTamFil
		_cFilAnt := Alltrim(_cEmpFil)
	Else
		Alert("O código da empresa informado esta incorreto")
		RestArea(_aArea)
		Return
	EndIf

	If AllTrim(_cFilAnt) = "*"

	
		SM0->( DbGoTop() )

		While !SM0->( Eof() )
	   	//_cFilAnt := SM0->M0_CODFIL
			cFilAnt := SubSTR(SM0->M0_CODFIL,1,7)
		
			If dDatFin <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DATAFIN',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatFin)
					MsUnlock()
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIN'
					ZZS->ZZS_DESC   :='Data limite p/ realizacao de operacoes financeiras'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				Else
					CRIAPAR1() //Criação do Parametro Financeiro
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIN'
					ZZS->ZZS_DESC   :='Data limite p/ realizacao de operacoes financeiras'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				EndIf
			EndIf
		
			If dDatEst <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DBLQMOV',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatEst)
					MsUnlock()
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DBLQMOV'
					ZZS->ZZS_DESC   :='Data para bloqueio de movimentos de estoque.'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				Else
					CRIAPAR2() //Criação do Parametro Materiais (Compras, Faturamento e Estoque)
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DBLQMOV'
					ZZS->ZZS_DESC   :='Data para bloqueio de movimentos de estoque.'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				EndIf
			EndIf
		
			If dDatFis <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DATAFIS',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatFis)
					MsUnlock()
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIS'
					ZZS->ZZS_DESC   :='Ultima data de encerramento de operacoes fiscais  '
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				Else
					CRIAPAR3() //Criação do Parametro Fiscal
				
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIS'
					ZZS->ZZS_DESC   :='Ultima data de encerramento de operacoes fiscais  '
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
				
				EndIf
			EndIf
		
			SM0->( DbSkip() )
		
		EndDo
	Else

		SM0->( DbGoTop() )

		While !SM0->( Eof() )
			If ALLTRIM(SM0->M0_CODFIL) == Alltrim(_cFilAnt)
				_lFilExiste := .T.
		
			EndIf
	
			SM0->( DbSkip() )
		
		EndDo
	
	

		If _lFilExiste
			If dDatFin <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DATAFIN',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatFin)
					MsUnlock()
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIN'
					ZZS->ZZS_DESC   :='Data limite p/ realizacao de operacoes financeiras'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				Else
					CRIAPAR1() //Criação do Parametro Financeiro
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIN'
					ZZS->ZZS_DESC   :='Data limite p/ realizacao de operacoes financeiras'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				EndIf
			EndIf
	
			If dDatEst <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DBLQMOV',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatEst)
					MsUnlock()
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DBLQMOV'
					ZZS->ZZS_DESC   :='Data para bloqueio de movimentos de estoque.'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				Else
					CRIAPAR2() //Criação do Parametro Materiais (Compras, Faturamento e Estoque)
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DBLQMOV'
					ZZS->ZZS_DESC   :='Data para bloqueio de movimentos de estoque.'
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				EndIf
			EndIf
	
			If dDatFis <> Ctod(Space(8))
				DbSelectArea("SX6")
				DbSetOrder(1)
				If MsSeek(_cFilAnt+'MV_DATAFIS',.T.)
					RecLock('SX6', .F.)
					SX6->X6_CONTEUD := Dtos(dDatFis)
					MsUnlock()
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIS'
					ZZS->ZZS_DESC   :='Ultima data de encerramento de operacoes fiscais  '
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				Else
					CRIAPAR3() //Criação do Parametro Fiscal
			
					DbSelectArea("ZZS")
					Reclock('ZZS',.T.)
					ZZS->ZZS_FILIAL := _cFilAnt
					ZZS->ZZS_PAR    :='MV_DATAFIS'
					ZZS->ZZS_DESC   :='Ultima data de encerramento de operacoes fiscais  '
					ZZS->ZZS_DATA   := DATE()
					ZZS->ZZS_TIME   := TIME()
					ZZS->ZZS_USER   := __cuserid
					ZZS->ZZS_USERNA := cUserName
					MsUnlock()
			
				EndIf
			EndIf
	
		Else
			Alert("O código da empresa informado esta incorreto")
			RestArea(_aArea)
			Return
		EndIf


	EndIf


//Mensagem de Gravação
	If dDatFin <> Ctod(Space(8)) .or. dDatEst <> Ctod(Space(8)) .or. dDatFis <> Ctod(Space(8))
		_cDesc := 'Efetuado alteração no(s) seguinte(s) parametro(s):'+IIF(dDatFin <> Ctod(Space(8))," MV_DATAFIN = "+Dtoc(dDatFin),'')+;
			IIF(dDatEst <> Ctod(Space(8)),", MV_DBLQMOV = "+Dtoc(dDatEst),'')+ IIF(dDatFis <> Ctod(Space(8)),", MV_DATAFIS = "+Dtoc(dDatFis),'')
	
		AVISO("Travamento das Origens Contabeis",_cDesc,{"OK"},2)
	EndIf

RestArea(_aArea)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRIAPAR   ºAutor  ³Microsiga           º Data ³  10/08/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria parametros com filiais se não existir                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRIAPAR1()

	DbSelectArea("SX6")

	RecLock('SX6', .T.)
	SX6->X6_FIL     := _cFilAnt
	SX6->X6_VAR     := 'MV_DATAFIN'
	SX6->X6_TIPO    := 'D'
	SX6->X6_DESCRIC := 'Data limite p/ realizacao de operacoes financeiras'
	SX6->X6_DSCSPA  := 'Fecha limite para la ejecucion de las operaciones '
	SX6->X6_DSCENG  := 'Limit date for making the financial transactions. '
	SX6->X6_DSCSPA  := 'financieras'
	SX6->X6_CONTEUD := Dtos(dDatFin)
	SX6->X6_CONTSPA := '19800101'
	SX6->X6_CONTENG := '19800101'
	SX6->X6_PROPRI   := 'U'
	SX6->X6_PYME    := 'S'
	SX6->X6_DEFPOR  := Dtos(dDatFin)
	SX6->X6_DEFSPA  := '19800101'
	SX6->X6_DEFENG  := '19800101'
	MsUnlock()

Return nil

Static Function CRIAPAR2()

	DbSelectArea("SX6")

	RecLock('SX6', .T.)
	SX6->X6_FIL     := _cFilAnt
	SX6->X6_VAR     := 'MV_DBLQMOV'
	SX6->X6_TIPO    := 'D'
	SX6->X6_DESCRIC := 'Data para bloqueio de movimentos de estoque.      '
	SX6->X6_DSCSPA  := 'Fecha del ultimo cierre de stock.                 '
	SX6->X6_DSCENG  := 'Inventory last closing date.                      '
	SX6->X6_CONTEUD := Dtos(dDatEst)
	SX6->X6_CONTSPA := '19800101'
	SX6->X6_CONTENG := '19800101'
	SX6->X6_PROPRI  := 'U'
	SX6->X6_PYME    := 'S'
	SX6->X6_DEFPOR  := Dtos(dDatEst)
	SX6->X6_DEFSPA  := '19800101'
	SX6->X6_DEFENG  := '19800101'
	MsUnlock()

Return nil

Static Function CRIAPAR3()

	DbSelectArea("SX6")

	RecLock('SX6', .T.)
	SX6->X6_FIL     := _cFilAnt
	SX6->X6_VAR     := 'MV_DATAFIS'
	SX6->X6_TIPO    := 'D'
	SX6->X6_DESCRIC := 'Ultima data de encerramento de operacoes fiscais  '
	SX6->X6_DSCSPA  := 'Ultima Fecha de Cierre de las Operaciones Fiscales'
	SX6->X6_DSCENG  := 'Last fiscal operation closing date.               '
	SX6->X6_DSCSPA  := 'financieras'
	SX6->X6_CONTEUD := Dtos(dDatFis)
	SX6->X6_CONTSPA := '19800101'
	SX6->X6_CONTENG := '19800101'
	SX6->X6_PROPRI  := 'U'
	SX6->X6_PYME    := 'S'
	SX6->X6_DEFPOR  := Dtos(dDatFis)
	SX6->X6_DEFSPA  := '19800101'
	SX6->X6_DEFENG  := '19800101'
	MsUnlock()

Return nil


