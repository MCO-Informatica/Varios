#Include "Totvs.ch"

//Renato Ruy - 13/06/2016
//Inclusão manual de agenda

User Function CSFA111(oGride1,oGride3)

//Variaveis 
Local aTIPO	  := {"1=Voz","2=Fax","3=Cross Posting","4=Mala Direta","5=Pendencia","6=Website"}//1=Voz;2=Fax;3=Cross Posting;4=Mala Direta;5=Pendencia;6=Website
Local aOriEnt := {"SA1=CLIENTES","SZT1=COMMON NAME","SUS=PROSPECTS","ACH=SUSPECTS","SZX=ICP-BRASIL","PAB=LISTAS DE CONTATOS"}
Local aSU6 	  := {"U6_CODIGO","U6_CONTATO","U6_NCONTAT","U6_CODENT","U6_DENTIDA","U6_CODENT","U6_DESCENT"}
Local aPriori := {"1=Baixa","2=Alta"}
Local nUsado  := 0
Local cConsulta:= ""
Local lAltOper := .F.

//Campos para fazer a manutencao.
Private cLISTA  := Space(6)
Private cDESC   := Space(120)
Private dDATA   := dDataBase
Private cHORA1  := Time()
Private cOPERAD := Space(6)
Private cDesOPER:= Space(100)
Private cTIPO   := Space(1) 
Private cContato:= Space(6)
Private cDesCont:= Space(100)
Private cPosto  := Space(2)
Private cCodEnt := Space(6)
Private cEntida := Space(100)
Private cPriori := "1"

Private cCadastro	:= "Agenda Certisign - Manutenção Manual"	
Private cOriEnt 	:= "SA1"
Private aCols 		:= {}
Private aHeader 	:= {}
Private cAlias1 	:= "SU4"
Private cAlias2 	:= "SU6"
Private oData	 	:= "SU6"
Private oData2	 	:= "SU5"
// Cria dialogo
Private oDlg := MSDialog():New(001,001,270,550,cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//RegToMemory(cAlias1,.F.)
//RegToMemory(cAlias2,.F.)

//Adiciona o proximo numero e confirma.
cLISTA  := GetSXENum("SU4","U4_LISTA")
ConfirmSX8()

//Me posiciono no operador atual.
SU7->( dbSetOrder( 4 ) )
If SU7->( dbSeek( xFilial( 'SU7' ) + __cUserID ) )
	cOPERAD    := SU7->U7_COD
	cDesOPER   := RTrim( SU7->U7_NOME )
	cPosto     := SU7->U7_POSTO
	
	If SU7->U7_TIPO == "2"
		lAltOper := .T.
	EndIf
EndIf

//Campos para exibir no cabeçalho da MsDialog.
//"U4_LISTA","U4_DESC","U4_DATA","U4_HORA1","U4_OPERAD","U4_TIPO"

@ 006,005 Say " Código: " of oDlg Pixel
@ 003,040 MSGET cLISTA SIZE 30,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 006,090 Say " Nome da Lista: " of oDlg Pixel
@ 003,130 MSGET cDESC SIZE 140,11 OF oDlg PIXEL PICTURE "@!" WHEN .T.

@ 022,005 Say " Data: " of oDlg Pixel
@ 020,040 MSGET dDATA SIZE 30,11 PICTURE "99/99/99" OF oDlg PIXEL PICTURE "@!" WHEN .T.

@ 022,090 Say " Hora: " of oDlg Pixel
@ 020,130 MSGET cHORA1 SIZE 10,11 PICTURE "99:99:99" OF oDlg PIXEL PICTURE "@!" WHEN .T.

@ 022,170 Say " Tipo Contato: " of oDlg Pixel
@ 020,210 ComboBox cTIPO Items aTIPO Size 050,011 PIXEL OF oDlg

@ 040,005 Say " Operador: " of oDlg Pixel
@ 038,040 MSGET cOPERAD SIZE 30,11 OF oDlg PIXEL PICTURE "@!" F3 "SU7MAN" Valid U_CSFA111C("SU7") WHEN lAltOper

@ 040,090 Say " Nome Operador: " of oDlg Pixel
@ 038,130 MSGET cDesOPER SIZE 140,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 060,005 Say " Cod.Ent: " of oDlg Pixel
@ 058,040 MSGET oData VAR cCodEnt SIZE 30,11 PIXEL PICTURE "@!" F3 cOriEnt Valid U_VLENT111() WHEN .T. OF oDlg

@ 060,090 Say " Desc.Ent: " of oDlg Pixel
@ 058,130 MSGET cEntida SIZE 140,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 080,005 Say " Contato: " of oDlg Pixel
@ 078,040 MSGET cContato SIZE 30,11 OF oDlg PIXEL PICTURE "@!" F3 "AC8SU5" Valid U_CSFA111C("SU5") WHEN .T.

@ 080,090 Say " Nome Contato: " of oDlg Pixel
@ 078,130 MSGET oData2 VAR cDesCont SIZE 140,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 100,005 Say " Prioridade: " of oDlg Pixel
@ 098,040 ComboBox cPriori Items aPriori Size 033,012 PIXEL OF oDlg

@ 100,090 Say " Tabela Origem: " of oDlg Pixel
@ 098,130 ComboBox cOriEnt Items aOriEnt Size 050,012 Valid U_CSFA111C("ATU") PIXEL OF oDlg 

// Ativa diálogo centralizado
//oDlg:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('iniciando…')} )
@ 113,100 BUTTON "Confirmar"  SIZE 40,20 PIXEL OF oDlg ACTION CSFA111G(oGride1,oGride3)
@ 113,150 BUTTON "Fechar"  	  SIZE 40,20 PIXEL OF oDlg ACTION (oDlg:End())

oDlg:Activate(,,,.T.,,, )
        
Return

//Alimenta a descrição do Contato
User Function CSFA111C(cTipo)

Local lRet 	:= .T.
Local aPergs:= {}
Local aRet 	:= {}
Local cCod	:= ""
Local cEnt	:= ""

If cTipo == "SU5"
	
	SU5->(DbSetOrder(1))
	lRet 	 := SU5->(DbSeek(xFilial("SU5")+cContato))
	cDesCont := SU5->U5_CONTAT
	If Empty(cContato)
	
		If MsgYesNo("O campo entidade está em branco, deseja vincular um novo contato?","Agenda Certisign")

			aAdd( aPergs ,{1,"Codigo do Contato : ",Space(6),"@!",'.T.',"SU5",'.T.',80,.F.})
			If ParamBox(aPergs ,"Parametros ",aRet)
				
				cEnt := SubStr(cOriEnt,1,3) //Tabela de origem para vincular entidade.
				cCod := PadR(cCodEnt+Iif(cEnt$"ACB|SA1|SUS","01",""),25," ") //monta código da entidade.
				
				AC8->(DbSetOrder(2)) 
				      //indice - Filial         + Tabela origem + Filial da tabela + codigo entidade + codigo contato
				If !AC8->(DbSeek(xFilial("AC8")+cEnt           +xFilial(cEnt)     +cCod             +aRet[1]))
					AC8->(RecLock("AC8",.T.))
						AC8->AC8_ENTIDA := cEnt
						AC8->AC8_CODENT := cCodEnt+Iif(cEnt $ "ACB|SA1|SUS","01","")
						AC8->AC8_CODCON := aRet[1]		
					AC8->(MsUnlock())
				Else
					MsgInfo("Ja existe vinculo entre a entidade e contato!")
				EndIf
				
				cContato := aRet[1]
				cDesCont := SU5->U5_CONTAT
				
			EndIf

		EndIf
	
	Elseif !lRet
		MsgInfo("O Código de contato não existe no cadastro!","Agenda Certisign")
	EndIf
Elseif cTipo == "SU7"
	cDesOPER := SU7->U7_NOME
	cPosto   := SU7->U7_POSTO
	SU7->(DbSetOrder(1))
	lRet 	 :=  SU7->(DbSeek(xFilial("SU7")+cOPERAD))
	If !lRet
		MsgInfo("O código do operador não existe no cadastro!","Agenda Certisign") 
	EndIf
Elseif cTipo == "ATU"
	If ValType(oData:CF3) <> "U"
		oData:CF3 := cOriEnt
	EndIf
EndIf

Return lRet 

//Grava dados na agenda
Static Function CSFA111G(oGride1,oGride3)

Local cU6_CODIGO := ""

If Empty(cDESC) .Or. Empty(dDATA) .Or. Empty(dDATA) .Or. Empty(cHORA1) .Or. Empty(cContato) .Or. Empty(cCodEnt) .Or. Empty(cPriori)
	MsgInfo("Por favor preencha os campos!","Agenda Certisign") 
	Return .F.
EndIf

oDlg:End()

//---------------------------------	
// Iniciar a gravação do cabeçalho.
//---------------------------------	
SU4->( RecLock( "SU4", .T. ) )
	SU4->U4_FILIAL  := xFilial("SU4")
	SU4->U4_TIPO    := "1" //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
	SU4->U4_STATUS  := "1" //1=Ativa;2=Encerrada;3=Em Andamento
	SU4->U4_LISTA   := cLISTA
	SU4->U4_DESC    := cDESC
	SU4->U4_DATA    := dData //Data da inclusão da agenda do consultor.
	SU4->U4_HORA1   := cHora1
	SU4->U4_FORMA   := "6" //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
	SU4->U4_TELE    := "1" //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
	SU4->U4_OPERAD  := cOPERAD
	SU4->U4_TIPOTEL := "4" //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
	SU4->U4_NIVEL   := "1" //1=Sim;2=Nao.
	SU4->U4_XGRUPO  := cCodEnt
	SU4->U4_XPRIOR  := cPriori
SU4->( MsUnLock() )

cU6_CODIGO := GetSXENum("SU6","U6_CODIGO")
ConfirmSX8()

SU6->( RecLock( "SU6", .T. ) )
	SU6->U6_FILIAL  := xFilial("SU6")
	SU6->U6_LISTA   := cLISTA
	SU6->U6_CODIGO  := cU6_CODIGO
	SU6->U6_CONTATO := cContato
	SU6->U6_ENTIDA  := SubStr(cOriEnt,1,3)
	SU6->U6_CODENT  := cCodEnt+Iif(cOriEnt$"ACB|SA1|SUS","01","") //SU7->U7_POSTO
	SU6->U6_ORIGEM  := "2" //1=Lista;2=Manual;3=Atendimento.
	SU6->U6_DATA    := dData //cData - Data da inclusão da agenda do consultor.
	SU6->U6_HRINI   := "06:00"
	SU6->U6_HRFIM   := "23:59"
	SU6->U6_STATUS  := "1" //1=Nao Enviado;2=Em uso;3=Enviado.
	SU6->U6_DTBASE  := MsDate()
SU6->( MsUnLock() )

//Atualiza agenda do operador
StaticCall(CSFA110,A110LoadAg)

//Abre para atendimento.
If dData <= dDatabase
			 //Rotina ,Static  ,par1,par2  ,par3  ) 
	StaticCall(CSFA110,A110Regist,1,oGride1,cLISTA)
Else
	StaticCall(CSFA110,A110Regist,3,oGride3,cLISTA)
EndIf

//Atualiza agenda do operador
StaticCall(CSFA110,A110LoadAg)

Return

User Function VLENT111()

Local aPergs := {}
Local aRet	 := {}

//seta o indice para consulta entre Contato x Entidade para buscar se existe contato vinculado a entidade.
AC8->(DbSetOrder(2))
if !AC8->(DbSeek(xFilial("AC8")+SubStr(cOriEnt,1,3)+xFilial(cOriEnt)+cCodEnt))
	If MsgYesNo("A Entidade não tem contato vinculado, deseja efetuar este vinculo?","Agenda Certisign")

		aAdd( aPergs ,{1,"Codigo do Contato : ",Space(6),"@!",'.T.',"SU5",'.T.',80,.F.})
		If ParamBox(aPergs ,"Parametros ",aRet)  
			AC8->(RecLock("AC8",.T.))
				AC8->AC8_ENTIDA := SubStr(cOriEnt,1,3)
				AC8->AC8_CODENT := cCodEnt+"01"
				AC8->AC8_CODCON := aRet[1]		
			AC8->(MsUnlock())
		EndIf
	EndIf
endif

if cOriEnt == "SUS"
	cEntida := SUS->US_NOME
Elseif cOriEnt == "AC8"
	cEntida := SA1->A1_NOME
Elseif cOriEnt == "ACH"
	cEntida := ACH->ACH_RAZAO
Elseif cOriEnt == "SZX"
	cEntida := SZX->ZX_DSRAZAO
Elseif cOriEnt == "SZT1"
	cEntida := SZT->ZT_EMPRESA
Elseif cOriEnt == "ACH"
	cEntida := ACH->ACH_RAZAO
Elseif cOriEnt == "PAB"
	cEntida := PAB->PAB_EMPRES
Elseif cOriEnt == "SA1"
	cEntida := SA1->A1_NOME
EndIf

Return