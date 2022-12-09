#INCLUDE "totvs.ch"

Static aRet2 := {}
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031   บ Autor ณ Renato Ruy	     บ Data ณ  16/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de encerramento do lan็amentos mensais.		      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC _cPedMed  := ''

User Function CRPA031


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cCadastro := "Fechamento Mensal"
Private aCores  := {{ '!Empty(ZZ6->ZZ6_PEDIDO) .AND. ZZ6->ZZ6_SALDO == 0' , 'ENABLE'  		},;    // Finalizado
					{ '(!Empty(ZZ6->ZZ6_PEDIDO) .OR. !Empty(ZZ6->ZZ6_PEDID2) .OR. !Empty(ZZ6->ZZ6_PEDID3)) .AND. ZZ6->ZZ6_SALDO >  0' , 'BR_AMARELO'},;    //Saldo Pendente
					{ 'Empty(ZZ6->ZZ6_PEDIDO) ' , 'DISABLE' 								}}    // Saldo Total em Aberto

Private aRotina := { {"Pesquisar"			,"AxPesqui"	 ,0,1} ,;
             			{"Visualizar"			,"AxVisual"	 ,0,2} ,;
             			{"Incluir"				,"AxInclui"	 ,0,3},;
             			{"Alterar"				,"AxAltera"	 ,0,4} ,;
             			{"Gerar Pedido"		,"U_CRPA031A"	 ,0,5},;
             			{"Estornar Ped."		,"U_CRPA031B"	 ,0,6},;
             			{"Calcular"			,"U_CRPA031C"	 ,0,7},;
             			{"Alt.Produto"		,"U_CRPA031D"	 ,0,8},;
             			{"Pedidos em Lote"	,"U_CRPA031E"	 ,0,9},;
             			{"Conhecimento" 		,"MsDocument"	 ,0,10},;
             			{"Rel.Resumo"			,"U_CRPA031G(0)",0,11},;
             			{"Rastrear"			,"U_CRPA031R()",0,12}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cRemPer	 := AllTrim(GetMV("MV_REMMES")) // PERIODO DE CALCULO EM ABERTO
Private cString  := "ZZ6"

dbSelectArea(cString)
dbSetOrder(1)


mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031A  บ Autor ณ Renato Ruy	     บ Data ณ  19/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gera็ใo de pedidos.						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CRPA031A

Processa( {|| CRPA31A() }, "Gerando Pedido...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031B  บ Autor ณ Renato Ruy	     บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para estornar de pedidos.						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CRPA031B

Processa( {|| CRPA31B() }, "Efetuando Estorno...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031C  บ Autor ณ Renato Ruy	     บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para do Fechamento.							      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CRPA031C

Local aRet 		:= {}
Local bValid  	:= {|| .T. }

Private aPar 	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Entidade De"	 	,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Entidade Ate"		,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"TODAS" ,{"TODAS","POSTO","AC/CANAL","REVENDEDOR"}, 100,'.T.',.T.})

ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , ,"CRPA031" , .T., .F. )
If Len(aRet) > 0
	Processa( {|| CRPA31C(aRet) }, "Gerando Calculo de Encerramento...")
Else
	Alert("Rotina Cancelada!")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031A  บ Autor ณ Renato Ruy	     บ Data ณ  19/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gera็ใo de pedidos.						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CRPA31A
Local aCabec 	:= {}
Local aLinha 	:= {}
Local aItens 	:= {}
Local aExcMed	:= {}
Local cNumSC7	:= ""
Local cNumCND	:= ""
Local cCompet	:= ""
Local nSaveSX8 	:= GetSX8Len()
Local nValPed	:= 0
Local _stru		:={}
Local aCpoBro 	:= {}
Local lContra	:= .T.
Local aCores	:= {}
Local lEntid	:= .T.
Local aPar		:= {}
Local aRet		:= {}
Local aPergs	:= {}
Local dDiasVen:= CtoD("  /  /  ")
Local bValid  	:= {|| .T. }
Local cPeriodo  := SubStr(DtoS(dDatabase),5,2)+SubStr(DtoS(dDatabase),1,4)
Local aRecnoSE2RA := {}
Local aAreaSA2  := {}

Private cFormapg	:= Space(24)
Private oDlg
Private nOpc		:= 1
Private nContMed	:= 0
Private lInverte := .F.
Private cMark    := GetMark()
Private oMark
Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

If !Empty(ZZ6->ZZ6_PEDIDO) .And. !Empty(ZZ6->ZZ6_PEDID2) .And. !Empty(ZZ6->ZZ6_PEDID3)
	MsgInfo("Jแ foi gerado pedido para o lan็amento, por favor efetue o estorno para gerar novamente.")
	Return()
Elseif ZZ6->ZZ6_SALDO == 0
	If !Empty(ZZ6->ZZ6_PEDIDO) .Or. !Empty(ZZ6->ZZ6_PEDID2) .Or. !Empty(ZZ6->ZZ6_PEDID3)
		MsgInfo("Jแ foi gerado pedido para o lan็amento, por favor efetue o estorno para gerar novamente.")
	Else
		MsgInfo("Nใo existe saldo para gera็ใo de pedido.")
	EndIf
	Return()
Endif

//Renato Ruy - 26/10/16
//Gera็ใo automแtica de Parceiro para revendedores.
SZ3->(DbSetOrder(1))
If !SZ3->(DbSeek(xFilial("SZ3")+ ZZ6->ZZ6_CODENT)) .And. Empty(ZZ6->ZZ6_CODAC)

	aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(6),"","","SA2","",50,.T.})

	If ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )

		If SZ3->(Reclock("SZ3",.T.))
			SZ3->Z3_FILIAL := xFilial("SZ3")
			SZ3->Z3_CODENT := ZZ6->ZZ6_CODENT
			SZ3->Z3_TIPENT := ZZ6->ZZ6_DESENT
			SZ3->Z3_TIPCOM := "7"
			SZ3->Z3_CODFOR := aRet[1]
			SZ3->Z3_LOJA   := "01"
			SZ3->(MsUnlock())
		Else
			//Se o usuแrio nใo seleciona o fornecedor, o sistema nใo cria o parceiro.
			lEntid := .F.
		Endif

	Endif
Endif


If lEntid

	//Renato Ruy - 05/07/2018
	//Novo processo para o usuแrio selecionar o fornecedor
	AC9->(DbSetOrder(2)) //AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT
	If AC9->(DbSeek(xFilial("AC9")+"SZ3"+xFilial("SZ3")+ZZ6->ZZ6_CODENT))
		aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(8),"","","SZ3FOR","",50,.T.})
		If ParamBox( aPar, ZZ6->ZZ6_DESENT, @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )
			SZ3->(Reclock("SZ3",.F.))
				SZ3->Z3_CODFOR := Substr(aRet[1],1,6)
				SZ3->Z3_LOJA   := Substr(aRet[1],7,2)
			SZ3->(MsUnlock())
		Else
			MsgInfo("Sera mantido o fornecedor atual: "+SZ3->Z3_CODFOR)
		Endif
	Endif
	// Fim do novo processo do fornecedor

	If Empty(SZ3->Z3_CODFOR)
		MsgInfo("Nใo foi possํvel gerar o pedido, verifique o vinculo entre a Entidade: "+ ZZ6->ZZ6_CODENT + " - " + AllTrim(ZZ6->ZZ6_DESENT)+" X Fornecedor.")
		Return()
	EndIf

	If Select("TMPPED") > 0
		TMPPED->(DbCloseArea())
	EndIf

	IncProc( "Seleciona o Fornecedor x Produto.")
	ProcessMessage()

	//Busco os dados do ultimo pedido.
	Beginsql Alias "TMPPED"
		SELECT D1_COD, D1_TES FROM %Table:SD1% SD1
		WHERE
		D1_FILIAL = %xFilial:SD1% AND
		D1_FORNECE = %Exp:SZ3->Z3_CODFOR% AND
		D1_LOJA = '01' AND
		SUBSTR(D1_COD,1,2) = 'CS' AND
		D1_EMISSAO = (SELECT MAX(D1_EMISSAO) FROM %Table:SD1% WHERE D1_FILIAL = %xFilial:SD1% AND D1_FORNECE = %Exp:SZ3->Z3_CODFOR% AND SUBSTR(D1_COD,1,2) = 'CS' AND D1_LOJA = '01' AND SD1.%NOTDEL%) AND
		SD1.%NOTDEL%
	Endsql

	nValPed := ZZ6->ZZ6_SALDO

	//Me posiciono no produto do ๚ltimo pedido
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1") + TMPPED->D1_COD ))
		SB1->(DbSeek(xFilial("SB1") + "CS001009" ))
	EndIf

	If Select("TMPMED") > 0
		TMPMED->(DbCloseArea())
	EndIf

	//Busco os dados do contrato.
	Beginsql Alias "TMPMED"
		SELECT Z3_CODENT CODCCR,CNC_NUMERO CONTRATO, MAX(CNC_REVISA) REVISAO, MAX(CN9_DESCRI) DESCRICAO FROM %Table:CNC%  CNC
		JOIN %Table:CN9% CN9 ON CN9_FILIAL = %xFilial:CN9% AND CN9_NUMERO = CNC_NUMERO AND CN9_SITUAC = '05' AND CN9.%NotDel%
		LEFT JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODFOR = CNC_CODIGO AND Z3_LOJA = CNC_LOJA AND Z3_TIPENT = '9' AND SZ3.%NotDel%
		WHERE
		CNC_FILIAL = %xFilial:CNC% AND
		CNC_CODIGO = %Exp:SZ3->Z3_CODFOR% AND
		CNC_LOJA = '01' AND
		CNC.%NotDel%
		GROUP BY CNC_NUMERO, Z3_CODENT
	Endsql

	//Cria um arquivo de Apoio para controle dos contratos
	AADD(_stru,{"OK"     	,"C"	,2		,0		})
	AADD(_stru,{"CODCCR"  	,"C"	,6		,0		})
	AADD(_stru,{"CONTRATO"  ,"C"	,15		,0		})
	AADD(_stru,{"REVISAO"  	,"C"	,3		,0		})
	AADD(_stru,{"DESCRICAO" 	,"C"	,120	,0		})

	cArq:=Criatrab(_stru,.T.)

	If Select("TTRB") > 0
		TTRB->(DbCloseArea())
	EndIf

	DBUSEAREA(.t.,,carq,"TTRB")

	TMPMED->(DbGotop())

	While  !TMPMED->(Eof())
		DbSelectArea("TTRB")
		RecLock("TTRB",.T.)
			TTRB->CODCCR   :=  TMPMED->CODCCR
			TTRB->CONTRATO :=  TMPMED->CONTRATO
			TTRB->REVISAO  :=  TMPMED->REVISAO
			TTRB->DESCRICAO:=  TMPMED->DESCRICAO
		MsunLock()
		TMPMED->(DbSkip())
	Enddo

	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aCpoBro	:= {{ "OK"			,, "Mark"           ,"@!"},;
				{ "CODCCR"		,, "CODCCR"       ,"@!"},;
				{ "CONTRATO"		,, "CONTRATO"       ,"@!"},;
				{ "REVISAO"		,, "REVISAO"        ,"@!"},;
				{ "DESCRICAO"		,, "DESCRICAO"      ,"@!"}}

	DbSelectArea("TTRB")
	DbGotop()

	If !TTRB->(EOF())
		//Cria uma Dialog
		DEFINE MSDIALOG oDlg TITLE "SELECIONE O CONTRATO" From 9,0 To 315,800 PIXEL

		aCores := {}
		aAdd(aCores,{"TTRB->REVISAO == ' '","BR_VERMELHO"})
		aAdd(aCores,{"TTRB->REVISAO != ' '","BR_VERDE"	 })

		//Cria a MsSelect
		oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{30,1,150,400},,,,,aCores)
		oMark:bMark := {| | Disp()}

		//Exibe a Dialog
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT	EnchoiceBar(oDlg,{|| oDlg:End()},{|| CRP31CAN()})
	EndIf

	If nOpc == 2
		Alert("Processo cancelado pelo usuario!")
		Return
	Endif

	//Fa็o Loop para somar caso exista mais de um tํtulo para gerar a compensa็ใo da NCC.
	While TTRB->(!EOF()) .And. lContra

		If !Empty(TTRB->OK)
			lContra := .F.
		Else
			TTRB->(DbSkip())
		EndIf

	EndDo

	//Yuri Volpe - 04/12/2018
	//OTRS 2018113010002075 - Falha no encerramento da medi็ใo. Melhoria criada baseada no erro.
	dbSelectArea("SA2")
	aAreaSA2 := SA2->(GetArea())
	SA2->(dbSetOrder(1))
	If !SA2->(dbSeek(xFilial("SA2")+SZ3->Z3_CODFOR+SZ3->Z3_LOJA))
		MsgInfo("Nใo serแ possํvel criar a Medi็ใo."+CHR(13)+CHR(10)+;
			"Fornecedor nใo localizado no sistema. Verifique o cadastro da Entidade."+CHR(13)+CHR(10)+;
			"Fornecedor/Loja: " + SZ3->Z3_CODFOR+"/"+SZ3->Z3_LOJA + CHR(13)+CHR(10)+;
			"Entidade: " + SZ3->Z3_CODENT)
		Return(.F.)
	EndIf
	RestArea(aAreaSA2)

	aAdd( aPergs ,{1,"Condi็ใo de Pagamento ","007"		 		,"@!"		 	,'.T.',"SE4"	,'.T.',40,.T.})
	aAdd( aPergs ,{1,"M๊s/Ano Ref. "		 ,cPeriodo	 		,"@R 99/9999"	,'.T.',""   	,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Centro de Custos "	 ,"80000000 "		,"@!"			,'.T.',"CTT"	,'.T.',40,.T.})
	aAdd( aPergs ,{1,"Conta contแbil or็ada" ,"420201014      "	,"@!"			,'.T.',"CT1"	,'.T.',60,.T.})
	aAdd( aPergs ,{1,"Forma de pagamento"	 ,cFormaPg			,"@!"			,'.T.',"C031PG"	,'.T.',120,.T.})
	aAdd( aPergs ,{1,"Nr.Docto. Fiscal"	 	 ,"               "	,"@!"			,'.T.',""   	,'.T.',40,.F.})
	aAdd( aPergs ,{1,"Vencimento"		 	 ,dDatabase			,"@D"			,'.T.',""   	,'.T.',40,.T.})

	aRet2 := {}

	//Renato Ruy - 22/08/2018
	//Validar a condi็ใo de Pagamento
	SE4->(DbSetOrder(1))

	If !ParamBox(aPergs ,"Parametros ",aRet2)
		Alert("A geracao do pedido foi cancelada!")
		Return
	Elseif !SE4->(DbSeek(xFilial("SE4")+aRet2[1]))
		Alert("A condicao de pagamento ้ invแlida!")
		Return
	EndIf

	//Campos da capa de despesa
	//	C7_XREFERE - M๊s/Ano Ref. - Variแvel
	//	C7_APBUDGE - Aprovado em budget?
	//	C7_XRECORR - Tipo de compra?
	//	C7_CCAPROV - Centro Custo Aprova็ใo
	//	C7_DESCCCA - Descric.C.Custo Aprova็ใo
	//	C7_CC      - Centro custo da despesa - Variแvel
	//	C7_DESCCC  - Descric. C. C. da despesa - Variแvel
	//	C7_ITEMCTA - Centro de resultado
	//	C7_DEITCTA - Descri็ใo C. Resultado
	//	C7_CLVL    - C๓digo do projeto
	//	C7_DESCLVL - Descri็ใo do projeto
	//	C7_CTAORC  - Conta contแbil or็ada - Variแvel
	//	C7_DESCCOR - Descricao conta or็ada
	//	C7_DDORC   - Descri็ใo da despesa no Or็amento
	//	C7_DESCRCP - Descri็ใo
	//	C7_XJUST   - Justificativa
	//	C7_XOBJ    - Objetivo
	//	C7_XADICON - Informa็ใo adicional
	//	C7_FORMPG  - Forma de pagamento  - Variแvel
	//	C7_XVENCTO - Vencimento
	//	C7_COND    - Cond.de Pagto. - Variแvel
	//	C7_DOCFIS  - Nr.Docto. Fiscal

	If nContMed == 0

		cNumSC7  := Criavar("C7_NUM",.T.)//Gera numero do pedido de compra
		While ( GetSX8Len() > nSaveSX8 )
			ConFirmSX8()
		EndDo

		IncProc( "Pedido Numero: "+cNumSC7)
		ProcessMessage()
		//Cabe็alho do pedido de compras
		aadd(aCabec,{"C7_NUM" 		,cNumSC7		})
		aadd(aCabec,{"C7_EMISSAO" 	,dDataBase		})
		aadd(aCabec,{"C7_FORNECE" 	,SZ3->Z3_CODFOR	})
		aadd(aCabec,{"C7_LOJA" 		,SZ3->Z3_LOJA	})
		aadd(aCabec,{"C7_COND" 		,aRet2[1]		})
		aadd(aCabec,{"C7_CONTATO" 	," "			})
		aadd(aCabec,{"C7_FILENT" 	,xFilial("SC7")	})

		aLinha := {}
		aadd(aLinha,{"C7_PRODUTO" 	,SB1->B1_COD									,Nil})
		aadd(aLinha,{"C7_QUANT" 	,1 												,Nil})
		aadd(aLinha,{"C7_PRECO" 	,nValPed 										,Nil})
		aadd(aLinha,{"C7_TOTAL" 	,nValPed 										,Nil})
		aadd(aLinha,{"C7_TES" 		,Iif(Empty(TMPPED->D1_TES),"101",TMPPED->D1_TES),Nil})
		aadd(aLinha,{"C7_LOCAL"		,"11" 											,Nil})
		aadd(aLinha,{"C7_APROV"		,Posicione('CTT',1, xFilial('CTT')+aRet2[3],'CTT_GARVAR'),Nil})
		aadd(aLinha,{"C7_CONTA"		,SB1->B1_CONTA									,Nil})

		//Campos da capa de despesa
		aadd(aLinha,{"C7_XREFERE",aRet2[2]									,Nil})
		aadd(aLinha,{"C7_APBUDGE","1"										,Nil})
		aadd(aLinha,{"C7_XRECORR","1"										,Nil})
		aadd(aLinha,{"C7_CC" 	 ,aRet2[3]									,Nil})
		aadd(aLinha,{"C7_CCAPROV",aRet2[3]									,Nil})
		aadd(aLinha,{"C7_ITEMCTA","000000000"								,Nil})
		aadd(aLinha,{"C7_CLVL   ","000000000"								,Nil})
		aadd(aLinha,{"C7_CTAORC ",aRet2[4]									,Nil})
		aadd(aLinha,{"C7_FORMPG ",aRet2[5]									,Nil})
		aadd(aLinha,{"C7_DOCFIS ",aRet2[6]									,Nil})
		aadd(aLinha,{"C7_XVENCTO",aRet2[7]									,Nil})

		//CC: 80000000
		aadd(aItens,aLinha)

		//Cria base de conhecimento.
		CRPA031H(cNumSC7)

		ZZ6->(RecLock("ZZ6",.F.))
			If Empty(ZZ6->ZZ6_PEDIDO)
				ZZ6->ZZ6_PEDIDO := cNumSC7
				ZZ6->ZZ6_TIPPED := "P"
				ZZ6->ZZ6_DATGER := dDataBase
			Elseif Empty(ZZ6->ZZ6_PEDID2)
				ZZ6->ZZ6_PEDID2 := cNumSC7
				ZZ6->ZZ6_TPPED2 := "P"
				ZZ6->ZZ6_DTGER2 := dDataBase
			Elseif Empty(ZZ6->ZZ6_PEDID3)
				ZZ6->ZZ6_PEDID3 := cNumSC7
				ZZ6->ZZ6_TPPED3 := "P"
				ZZ6->ZZ6_DTGER3 := dDataBase
			Endif
			ZZ6->ZZ6_SALDO	:= 0
		ZZ6->(MsUnlock())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//| Gera o Pedido de Compras 									 |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MATA120(1,aCabec,aItens,3)

	Else

		dbSelectArea("CN9")
		dbSetOrder(1)
		If !dbSeek(xFilial("CN9")+TTRB->CONTRATO+TTRB->REVISAO)
			ConOut("Cadastrar contrato: "+TTRB->CONTRATO+TTRB->REVISAO)
		EndIf

		CN1->(dbSetOrder(1))
		CN1->(dbseek(xFilial("CN1")+CN9->CN9_TPCTO))

		//Renato Ruy - 16/06/2016
		//Conforme solicitacao da Bruna Costa a competencia sera considerada como mes de emissao da Medicao.
		//cCompet := SubStr(ZZ6->ZZ6_PERIOD,5,2)+"/"+SubStr(ZZ6->ZZ6_PERIOD,1,4)
		cCompet := SubStr(DtoS(dDataBase),5,2)+"/"+SubStr(DtoS(dDataBase),1,4)

		aCabec := {}
		cNumCND := CriaVar("CND_NUMMED")
		aAdd(aCabec,{"CND_CONTRA"	,TTRB->CONTRATO								,NIL})
		aAdd(aCabec,{"CND_REVISA"	,TTRB->REVISAO								,NIL})
		aAdd(aCabec,{"CND_NUMERO"	,"000001"										,NIL})
		aAdd(aCabec,{"CND_PARCEL"	," "											,NIL})
		aAdd(aCabec,{"CND_COMPET"	,cCompet										,NIL})
		aAdd(aCabec,{"CND_NUMMED"	,cNumCND										,NIL})
		aAdd(aCabec,{"CND_FORNEC"	,SZ3->Z3_CODFOR								,NIL})
		aAdd(aCabec,{"CND_LJFORN"	,SZ3->Z3_LOJA									,NIL})
		aAdd(aCabec,{"CND_CONDPG"	,aRet2[1]										,NIL})
		aAdd(aCabec,{"CND_VLTOT"	,nValPed											,NIL})
		aAdd(aCabec,{"CND_APROV"	,Posicione('CTT',1, xFilial('CTT')+"80000000",'CTT_GARVAR'),NIL})
		aAdd(aCabec,{"CND_MOEDA"	,"1"												,NIL})

		aLinha := {}
		aadd(aLinha,{"CNE_ITEM" 	,"001"											,NIL})
		aadd(aLinha,{"CNE_PRODUT" 	,SB1->B1_COD								,NIL})
		aadd(aLinha,{"CNE_QUANT" 	,1 											,NIL})
		aadd(aLinha,{"CNE_VLUNIT" 	,nValPed 									,NIL})
		aadd(aLinha,{"CNE_VLTOT" 	,nValPed 									,NIL})
		aadd(aLinha,{"CNE_TE" 		,Iif(Empty(TMPPED->D1_TES),"101",TMPPED->D1_TES),NIL})
		aadd(aLinha,{"CNE_DTENT"	,dDatabase										,NIL})
		aadd(aLinha,{"CNE_CC" 		,"80000000"						   		,NIL})
		aadd(aLinha,{"CNE_CONTA"	,SB1->B1_CONTA								,NIL})
		//CC: 80000000
		aadd(aItens,aLinha)

		//Renato Ruy - 05/04/2018
		//Caso tenha problemas ou erro durante a geracao
		//Grava dados para vincular antes de finalizar
		ZZ6->(RecLock("ZZ6",.F.))
			If Empty(ZZ6->ZZ6_PEDIDO)
				ZZ6->ZZ6_PEDIDO := cNumCND
				ZZ6->ZZ6_TIPPED := "M"
				ZZ6->ZZ6_DATGER := dDataBase

			Elseif Empty(ZZ6->ZZ6_PEDID2)
				ZZ6->ZZ6_PEDID2 := cNumCND
				ZZ6->ZZ6_TPPED2 := "M"
				ZZ6->ZZ6_DTGER2 := dDataBase
			Elseif Empty(ZZ6->ZZ6_PEDID3)
				ZZ6->ZZ6_PEDID3 := cNumCND
				ZZ6->ZZ6_TPPED3 := "M"
				ZZ6->ZZ6_DTGER3 := dDataBase
			Endif
			ZZ6->ZZ6_SALDO	:= 0
		ZZ6->(MsUnlock())

		//Executa rotina automatica para gerar as medicoes
		MSExecAuto({|w, x, y, z| CNTA120(w, x, y, z)}, aCabec, aItens, 3, .F.)
		If (lMsErroAuto)
			MostraErro()
		EndIf


		CND->(DbSetOrder(4))
		If !CND->(DbSeek(xFilial("CND")+cNumCND))

			//Renato Ruy - 05/04/2018
			//Caso tenha problemas ou erro durante a geracao
			//Restaura saldo
			ZZ6->(RecLock("ZZ6",.F.))
				If cNumCND == ZZ6->ZZ6_PEDIDO
					ZZ6->ZZ6_PEDIDO := " "
					ZZ6->ZZ6_TIPPED := " "
					ZZ6->ZZ6_DATGER := CtoD("  /  /  ")
				Elseif cNumCND == ZZ6->ZZ6_PEDID2
					ZZ6->ZZ6_PEDID2 := " "
					ZZ6->ZZ6_TPPED2 := " "
					ZZ6->ZZ6_DTGER2 := CtoD("  /  /  ")
				Elseif cNumCND == ZZ6->ZZ6_PEDID3
					ZZ6->ZZ6_PEDID3 := " "
					ZZ6->ZZ6_TPPED3 := " "
					ZZ6->ZZ6_DTGER3 := CtoD("  /  /  ")
				Endif
				ZZ6->ZZ6_SALDO	:= nValPed
			ZZ6->(MsUnlock())

			MsgInfo("Nใo foi possํvel gerar a medi็ใo!")
			Return(.F.)
		Else
			//Cria base de conhecimento.
			cNumSC7 := GetSx8Num("SC7","C7_NUM")
			CRPA031H(cNumSC7)
			SC7->(RollBackSx8())

			//Alimenta o c๓digo do grupo aprovador.
			Reclock("CND",.F.)
				CND->CND_APROV := Posicione('CTT',1, xFilial('CTT')+"80000000",'CTT_GARVAR')
				CND->CND_ALCAPR:= "B"
			CND->(MsUnlock())

			// Encerra medi็ใo
			MSExecAuto({|x, y, z| CNTA120(x, y, z)}, aCabec, aItens, 6)
			If (lMsErroAuto)
				MostraErro()
			EndIf

			//Me posiciono para verificar se foi encerrada a medi็ใo.
			CND->(DbSetOrder(4))
			CND->(DbSeek(xFilial("CND")+cNumCND))

			//Se nใo encerrou, excluadi.
			If Empty(CND->CND_PEDIDO)
				//Exclui a medi็ใo caso tenha problema no encerramento.
				//CNTA120(aCabec,aItens,5,.F.) //Nao faz a exclusao pelo execauto

				//Renato Ruy - 19/01/2018
				//Exclui pedido de compra
				SC7->(DbSetOrder(1))
				If SC7->(DbSeek(xFilial("SC7")+cNumSC7))
					SC7->(RecLock("SC7",.F.))
						SC7->(DbDelete())
					SC7->(MsUnLock())

					SCR->(DbSetOrder(1))
					If SCR->(DbSeek(xFilial("SCR")+"PC"+cNumSC7))

						While SCR->CR_NUM == cNumSC7 .And. SCR->CR_TIPO == "PC"
							SCR->(RecLock("SCR",.F.))
								SCR->(DbDelete())
							SCR->(MsUnLock())
							SCR->(DbSkip())
						Enddo

					Endif

				Endif

				CND->(RecLock("CND",.F.))
					CND->(DbDelete())
				CND->(MsUnLock())

				CNE->(DbSetOrder(4))
				If CNE->(DbSeek(xFilial("CNE")+cNumCND))
					CNE->(RecLock("CNE",.F.))
						CNE->(DbDelete())
					CNE->(MsUnLock())
				Endif

				//Renato Ruy - 05/04/2018
				//Caso tenha problemas ou erro durante a geracao
				//Restaura saldo
				ZZ6->(RecLock("ZZ6",.F.))
					If cNumCND == ZZ6->ZZ6_PEDIDO
						ZZ6->ZZ6_PEDIDO := " "
						ZZ6->ZZ6_TIPPED := " "
						ZZ6->ZZ6_DATGER := CtoD("  /  /  ")
					Elseif cNumCND == ZZ6->ZZ6_PEDID2
						ZZ6->ZZ6_PEDID2 := " "
						ZZ6->ZZ6_TPPED2 := " "
						ZZ6->ZZ6_DTGER2 := CtoD("  /  /  ")
					Elseif cNumCND == ZZ6->ZZ6_PEDID3
						ZZ6->ZZ6_PEDID3 := " "
						ZZ6->ZZ6_TPPED3 := " "
						ZZ6->ZZ6_DTGER3 := CtoD("  /  /  ")
					Endif
					ZZ6->ZZ6_SALDO	:= nValPed
				ZZ6->(MsUnlock())

				lMsErroAuto := .T.
				MsgInfo("Nใo foi possํvel encerrar a medi็ใo, por favor execute novamente o processo!")

			EndIf

		EndIf
	EndIf

	//Renato Ruy - 28/07/2017
	//Caso ocorra algum erro no envio do e-mail ou na capa de despesas, o sistema valida pela
	//existencia do pedido de compras na base.
	SC7->(DbSetOrder(1))
	If !lMsErroAuto .Or. SC7->(DbSeek(xFilial("SC7")+cNumSC7))

		//Procura adiantamento e grava dados no Pedido de Compras
		ZZ7->(DbSetOrder(1))
		If ZZ7->(DbSeek(xFilial("ZZ7")+SZ3->Z3_CODENT+ZZ6->ZZ6_PERIOD+Space(TamSX3("ZZ7_PRETIT")[1])))
		    If ZZ7->ZZ7_SALDO > 0

		    	dDiasVen := dDataBase+Val(RTrim(Posicione("SE4",1,xFilial("SE4")+aRet2[1],"E4_COND")))

		    	//Envia notifica็ใo de adiantamento
		    	U_CRPA051(dDiasVen,aRet2,Space(TamSX3("ZZ7_PRETIT")[1]))

			EndIf
		EndIf

		IncProc( "Pedido Gerado com Sucesso.")
		ProcessMessage()
	Else
		//Renato Ruy - 05/04/2018
		//Caso tenha problemas ou erro durante a geracao
		//Restaura saldo
		ZZ6->(RecLock("ZZ6",.F.))
			If !Empty(ZZ6->ZZ6_PEDIDO)
				ZZ6->ZZ6_PEDIDO := " "
				ZZ6->ZZ6_TIPPED := " "
				ZZ6->ZZ6_DATGER := CtoD("  /  /  ")
			Elseif !Empty(ZZ6->ZZ6_PEDID2)
				ZZ6->ZZ6_PEDID2 := " "
				ZZ6->ZZ6_TPPED2 := " "
				ZZ6->ZZ6_DTGER2 := CtoD("  /  /  ")
			Elseif !Empty(ZZ6->ZZ6_PEDID3)
				ZZ6->ZZ6_PEDID3 := " "
				ZZ6->ZZ6_TPPED3 := " "
				ZZ6->ZZ6_DTGER3 := CtoD("  /  /  ")
			Endif
			ZZ6->ZZ6_SALDO	:= nValPed
		ZZ6->(MsUnlock())
	EndIf

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

Else

	MsgInfo("Nใo foi possํvel gerar o parceiro porque nใo foi selecionado o fornecedor, o sistema nใo emitira o pedido!")

EndIf
Return

Static Function CRPA31B

Local aCabec 	:= {}
Local aLinha 	:= {}
Local aItens 	:= {}
Local nOpc		:= 0
Local nI		:= 0
Local nSaldo	:= 0
Local cPedido	:= ""
Local cTipPed	:= ""
Local nCont		:= 3
Local oCheck1, oCheck2, oCheck3
Local lCheck1 := .F.
Local lCheck2 := .F.
Local lCheck3 := .F.
Local oDlg3

Private lMsErroAuto := .F.

If Empty(ZZ6->ZZ6_PEDIDO) .And. Empty(ZZ6->ZZ6_PEDID2) .And. Empty(ZZ6->ZZ6_PEDID3)
	MsgInfo("Nใo existe pedido para ser estornado.")
	Return()
Endif

//
DEFINE DIALOG oDlg3 TITLE "Selecione o Pedido que sera estornado." FROM 001,001 TO 200,300 PIXEL
If !Empty(ZZ6->ZZ6_PEDIDO)
	oCheck1 := TCheckBox():New(31,31,'Pedido 1: ' + ZZ6->ZZ6_PEDIDO,bSETGET(lCheck1),oDlg3,100,210,,,,,,,,.T.,,,)
EndIf
If !Empty(ZZ6->ZZ6_PEDID2)
	oCheck2 := TCheckBox():New(41,31,'Pedido 2: ' + ZZ6->ZZ6_PEDID2,bSETGET(lCheck2),oDlg3,100,210,,,,,,,,.T.,,,)
EndIf
If !Empty(ZZ6->ZZ6_PEDID3)
	oCheck3 := TCheckBox():New(51,31,'Pedido 3: ' + ZZ6->ZZ6_PEDID3,bSETGET(lCheck3),oDlg3,100,210,,,,,,,,.T.,,,)
EndIf

ACTIVATE DIALOG oDlg3 CENTERED ON INIT	EnchoiceBar(oDlg3,{|| nOpc := 1, oDlg3:End()},{|| nOpc := 2,oDlg3:End()})

If nOpc == 1

	For nI := 1 To nCont
		//Se nใo estแ marcado, desconsidera.
		If (!lCheck1 .And. nI == 1) .Or. (!lCheck2 .And. nI == 2) .Or. (!lCheck3 .And. nI == 3)
			Loop
		EndIf

		If (lCheck1 .And. nI == 1)
			cPedido	:= ZZ6->ZZ6_PEDIDO
			cTipPed	:= ZZ6->ZZ6_TIPPED
		ElseIf lCheck2 .And. nI == 2
			cPedido	:= ZZ6->ZZ6_PEDID2
			cTipPed	:= ZZ6->ZZ6_TPPED2
		ElseIf lCheck3 .And. nI == 3
			cPedido	:= ZZ6->ZZ6_PEDID3
			cTipPed	:= ZZ6->ZZ6_TPPED3
		EndIf

		//Reinicia variaveis
		aCabec 		:= {}
		aLinha 		:= {}
		aItens 		:= {}
		nSaldo 		:= 0
		lMsErroAuto := .F.

		SZ3->(DbSetOrder(1))
		If SZ3->(DbSeek(xFilial("SZ3")+ ZZ6->ZZ6_CODENT))

			If cTipPed == "P"
			    IncProc( "Estornando o Pedido: " + cPedido)
			    ProcessMessage()

			    SD1->(DbOrderNickName("PEDIDO")) //FILIAL + PEDIDO
				If SD1->(DbSeek(xFilial("SD1")+cPedido))
					MsgInfo("Nใo serแ possํvel estornar, o pedido esta vinculado a uma pre nota")
					Return
				Endif

			    SC7->(DbSetOrder(1))
			    SC7->(DbSeek(xFilial("SC7")+cPedido))

			    nSaldo := SC7->C7_TOTAL

				aadd(aCabec,{"C7_NUM" 		,cPedido		})
				aadd(aCabec,{"C7_EMISSAO" 	,ZZ6->ZZ6_DATGER})
				aadd(aCabec,{"C7_FORNECE" 	,SZ3->Z3_CODFOR	})
				aadd(aCabec,{"C7_LOJA" 		,SZ3->Z3_LOJA	})

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//| Exclui o Pedido de Compras 									 |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				MATA120(1,aCabec,aItens,5)
			Else
				CND->(DbSetOrder(4))
				CND->(DbSeek(xFilial("CND")+cPedido))

				SD1->(DbOrderNickName("PEDIDO")) //FILIAL + PEDIDO
				If SD1->(DbSeek(xFilial("SD1")+CND->CND_PEDIDO))
					MsgInfo("Nใo serแ possํvel estornar, o pedido esta vinculado a uma pre nota")
					Return
				Endif

				nSaldo := CND->CND_VLTOT

				aCabec := {}
				aAdd(aCabec,{"CND_CONTRA"	,CND->CND_CONTRA								,NIL})
				aAdd(aCabec,{"CND_REVISA"	,CND->CND_REVISA								,NIL})
				aAdd(aCabec,{"CND_NUMERO"	,CND->CND_NUMERO								,NIL})
				aAdd(aCabec,{"CND_PARCEL"	,CND->CND_PARCEL								,NIL})
				aAdd(aCabec,{"CND_COMPET"	,CND->CND_COMPET								,NIL})
				aAdd(aCabec,{"CND_NUMMED"	,cPedido										,NIL})
				aAdd(aCabec,{"CND_FORNEC"	,CND->CND_FORNEC								,NIL})
				aAdd(aCabec,{"CND_LJFORN"	,CND->CND_LJFORN								,NIL})
				aAdd(aCabec,{"CND_PEDIDO"	,CND->CND_PEDIDO								,NIL})

				//Caso nใo exista pedido, somente fa็o a exclusใo.
				If Empty(CND->CND_PEDIDO)
					MSExecAuto({|w, x, y, z| CNTA120(w, x, y, z)}, aCabec, aItens, 5, .F.)
					If (lMsErroAuto)
						MostraErro()
					EndIf
				//Quando existe pedido, fa็o estorno e fa็o a exclusใo
				Else
					MSExecAuto({|w, x, y, z| CNTA120(w, x, y, z)}, aCabec, aItens, 7, .F.)
					If (lMsErroAuto)
						MostraErro()
					EndIf
					//Verifico se foi executado corretamente
					//If !lMsErroAuto
					MSExecAuto({|w, x, y, z| CNTA120(w, x, y, z)}, aCabec, aItens, 5, .F.)
					If (lMsErroAuto)
						MostraErro()
					EndIf

					//Renato Ruy - 17/05/2018
					//Para alguns casos a rotina automatica retorna que deu certo
					//Porem nใo efetua o processo
					//Fiz o processo manual, para garantir
					SC7->(DbSetOrder(1))
					If SC7->(DbSeek(xFilial("SC7")+CND->CND_PEDIDO))

						SC7->(RecLock("SC7",.F.))
							SC7->(DbDelete())
						SC7->(MsUnLock())

						SCR->(DbSetOrder(1))
						If SCR->(DbSeek(xFilial("SCR")+"PC"+CND->CND_PEDIDO))

							While AllTrim(SCR->CR_NUM) == CND->CND_PEDIDO .And. SCR->CR_TIPO == "PC"
								SCR->(RecLock("SCR",.F.))
									SCR->(DbDelete())
								SCR->(MsUnLock())
								SCR->(DbSkip())
							Enddo

						Endif

					Endif
					CNE->(DbSetOrder(4))
					If CNE->(DbSeek(xFilial("CNE")+cPedido))
						CNE->(RecLock("CNE",.F.))
							CNE->(DbDelete())
						CNE->(MsUnLock())
					Endif

					CND->(DbSetOrder(4))
					If CND->(DbSeek(xFilial("CND")+cPedido))
						CND->(RecLock("CND",.F.))
							CND->(DbDelete())
						CND->(MsUnLock())
					Endif

				EndIf

			EndIf

			//If !lMsErroAuto

				IncProc( Iif( cTipPed == "P", "Pedido: ","Medicao: ") + cPedido + " estornado.")
				ProcessMessage()

				ZZ6->(RecLock("ZZ6",.F.))
				    //Apago conte๚do do campo pedido.
					If lCheck1 .And. nI == 1
						ZZ6->ZZ6_PEDIDO	:= " "
						ZZ6->ZZ6_TIPPED	:= " "
						ZZ6->ZZ6_DATGER := CtoD("  /  /  ")
					ElseIf lCheck2 .And. nI == 2
						ZZ6->ZZ6_PEDID2	:= " "
						ZZ6->ZZ6_TPPED2	:= " "
						ZZ6->ZZ6_DTGER2 := CtoD("  /  /  ")
					ElseIf lCheck3 .And. nI == 3
						ZZ6->ZZ6_PEDID3	:= " "
						ZZ6->ZZ6_TPPED3	:= " "
						ZZ6->ZZ6_DTGER3 := CtoD("  /  /  ")
					EndIf
					//Restauro saldo
					ZZ6->ZZ6_SALDO := ZZ6->ZZ6_SALDO + nSaldo

				ZZ6->(MsUnlock())
			//Else
			//	MostraErro()
			//EndIf

		EndIf
	Next
Else
	Alert("Estorno nใo realizado, a rotina foi cancelada!")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031C  บ Autor ณ Renato Ruy	     บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para do Fechamento.							      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CRPA31C(aRet)

Local nFeder   	:= 0
Local nFederSW 	:= 0
Local nFederHW 	:= 0
Local nAR	   	:= 0
Local nARSW    	:= 0
Local nARHW	 	:= 0
Local cCodPar  	:= ""
Local cWhere   	:= "%  %"
Local nValVis	:= 0
Local nDesconto	:= 0
Local nExtra	:= 0
Local cQryDesc	:= ""
Local cCodParcs	:= ""
Local cPfxAdto 	:= ''
Local cTitAdto 	:= ''
Local cParcAdto := ''
Local cTipoAdto := ''
Local cFornAdto	:= ''
Local cLojaAdto := ''
Local nPer1Adto	:= 0
Local nPer2Adto	:= 0
Local nPer3Adto	:= 0
Local nSomaAdto	:= 0

//Valquiria Oliveira - 10/05/2016
//Retirada a valida็ใo do programa, os usuแrios fazem calculo depois do periodo fechado.
//If aRet[1] < cRemPer
//	MsgInfo("O Periodo em aberto ้ " + cRemPer + ", nใo ้ possํvel calcular " + aRet[1] + ".")
//	Return()
//EndIf

If Empty(aRet[2])
	aRet[2] := "0"
Endif

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
Endif

IncProc( "Selecionando Dados dos Postos.")
ProcessMessage()

If AllTrim(aRet[4]) $ "TODAS/POSTO" //"TODAS","POSTO","AC","REVENDEDOR"

	If !Empty(aRet[2])
		cWhere := "% AND Z6_CODCCR Between '"+aRet[2]+"' AND '"+aRet[3]+"' %"
	Endif

	BeginSql Alias "QCRPR130"

		%noparser%

		SELECT PERIODO,
		       MAX(REDE) REDE,
		       CODENT,
		       DESENT,
		       CGC,
		       SUM(CONPED) CONPED,
		       SUM(VALHW) VALHW,
		       SUM(COMHW) COMHW,
		       SUM(VALSW) VALSW,
		       SUM(COMSW) COMSW,
		       SUM(VLRABT) VLRABT,
		       SUM(VALPRD) VALPRD,
		       SUM(VALCOM) VALCOM,
		       SUM(VALFED) VALFED,
	           SUM(VALFEDSW) VALFEDSW,
	           SUM(VALFEDHW) VALFEDHW
		FROM
		  (SELECT Z6_PERIODO PERIODO,
		          CASE WHEN MAX(Z3_CODENT) = '071609' OR MAX(Z3_CODENT) = '054295' THEN 'CACB' WHEN MAX(Z3_CODENT) = '073322' THEN 'SIN' ELSE MAX(Z6_CODAC) END REDE,
		          CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED,
		          Z6_PEDGAR PEDGAR,
		          Z6_PEDSITE PEDSITE,
		          Z6_PRODUTO PRODUTO,
		          Z3_CODENT CODENT,
				  Z3_DESENT DESENT,
		          Z3_CGC CGC,
		          TRIM(Z3_CODPAR) ||','|| TRIM(Z3_CODPAR2) CODPAR,
		          SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
		          SUM(CASE WHEN Z6_CATPROD = '1' AND Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) COMHW,
		          SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
		          SUM(CASE WHEN Z6_CATPROD = '2' AND Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) COMSW,
		          SUM(Z6_VLRABT) VLRABT,
		          SUM(Z6_VLRPROD) VALPRD,
		          SUM(CASE WHEN Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) VALCOM,
		          CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND
		                                                     						SZ32.Z3_RETPOS != 'N' AND
		                                                     						SZ32.D_E_L_E_T_ = ' '
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN MAX(
		                                                     (SELECT SUM(Z6_VALCOM)
		                                                      FROM %Table:SZ6% SZ62
		                                                      JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND
		                                                     						SZ32.Z3_RETPOS != 'N' AND
		                                                     						SZ32.D_E_L_E_T_ = ' '
		                                                      WHERE SZ62.D_E_L_E_T_ = ' '
		                                                        AND Z6_FILIAL = ' '
		                                                        AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                        AND Z6_PEDSITE = SZ6.Z6_PEDSITE
		                                                        AND Z6_PRODUTO = SZ6.Z6_PRODUTO
		                                                        AND Z6_PEDSITE > '0'
		                                                        AND Z6_TPENTID = '8'))
		          END VALFED,
		          CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND
		                                                     						SZ32.Z3_RETPOS != 'N' AND
		                                                     						SZ32.D_E_L_E_T_ = ' '
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
                                                           AND Z6_CATPROD = '2'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN 0
		          END VALFEDSW,
 	              CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND
		                                                     						SZ32.Z3_RETPOS != 'N' AND
		                                                     						SZ32.D_E_L_E_T_ = ' '
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
                                                           AND Z6_CATPROD = '1'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN MAX(
		                                                     (SELECT SUM(Z6_VALCOM)
		                                                      FROM %Table:SZ6% SZ62
		                                                      JOIN SZ3010 SZ32 ON SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND
		                                                     						SZ32.Z3_RETPOS != 'N' AND
		                                                     						SZ32.D_E_L_E_T_ = ' '
		                                                      WHERE SZ62.D_E_L_E_T_ = ' '
		                                                        AND Z6_FILIAL = ' '
		                                                        AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                        AND Z6_PEDSITE = SZ6.Z6_PEDSITE
		                                                        AND Z6_PRODUTO = SZ6.Z6_PRODUTO
		                                                        AND Z6_PEDSITE > '0'
                                                            AND Z6_CATPROD = '1'
		                                                        AND Z6_TPENTID = '8'))
		          END VALFEDHW
		   FROM %Table:SZ6% SZ6
		   JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = ' '
		   AND Z3_CODENT = Z6_CODCCR
		   AND (Z3_TIPCOM = '1' OR Z3_TIPCOM = ' ')
		   AND SZ3.D_E_L_E_T_ = ' '
		   WHERE Z6_FILIAL = ' '
		     AND Z6_PERIODO = %Exp:aRet[1]%
		     AND Z6_TPENTID = '4'
		     //AND Z6_CODAC != 'NAOREM'
		     AND SZ6.D_E_L_E_T_ = ' '
		     %Exp:cWhere%
		   GROUP BY Z6_PERIODO,
		            Z6_PEDGAR,
		            Z6_PEDSITE,
		            Z6_PRODUTO,
		            Z3_CODENT,
		            Z3_DESENT,
		            Z3_CGC,
		            TRIM(Z3_CODPAR)||','||TRIM(Z3_CODPAR2)
		   ORDER BY Z6_PERIODO,
		            Z3_CODENT,
		            Z3_DESENT,
		            Z3_CGC)
		GROUP BY PERIODO,
		         CODENT,
		         DESENT,
		         CGC
		ORDER BY PERIODO,
		         DESENT
	EndSql

	QCRPR130->(dbGoTop())

	While !QCRPR130->(EOF())

		IncProc( "Gerando Registros do CCR: " + QCRPR130->CODENT)
		ProcessMessage()

		nDescFed 	:= 0
		cQryDesc 	:= ""
		nDesconto 	:= 0
		cPfxAdto 	:= ""
		cTitAdto 	:= ""
		cParcAdto 	:= ""
		cTipoAdto 	:= ""
		cFornAdto	:= ""
		cLojaAdto 	:= ""
		nPer1Adto	:= 0
		nPer2Adto	:= 0
		nPer3Adto	:= 0
		nSomaAdto	:= 0

		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek( xFilial("SZ3") + QCRPR130->CODENT))

		If (!Empty(SZ3->Z3_CODPAR) .Or. !Empty(SZ3->Z3_CODPAR2)) .And. SZ3->Z3_ATIVO != 'N'

			cCodParcs := AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),","+AllTrim(SZ3->Z3_CODPAR2),"")

			cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM, "
			cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) CAMPHW, "
			cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) CAMPSW "
			cQuery2 += " 								 FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT IN "+FormatIn(AllTrim(cCodParcs),",")+" AND z6_tpentid in ('7','10') "

			If Select("TMP2") > 0
				TMP2->(DbCloseArea())
			EndIf
			PLSQuery( cQuery2, "TMP2" )
		EndIf

		cQuery := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+QCRPR130->CODENT+"' AND z6_tpentid = 'B' "

		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
		PLSQuery( cQuery, "TMP" )

		//Yuri Volpe - 22/02/2019
		//OTRS 2019021910001817 - Corre็ใo para inserir valores de Desconto ou Extra, conforme o caso
		/*cQryDesc := "SELECT SUM(Z6_VALCOM) DESCONTOS FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_TIPO = 'DESCON' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = '"+QCRPR130->CODENT+"' AND SZ6.D_E_L_E_T_ = ' '"

		If Select("TMPDESC") > 0
			TMPDESC->(dbCloseArea())
		EndIf
		PLSQuery( cQryDesc, "TMPDESC")

		nDesconto := 0
		If TMPDESC->DESCONTOS <> 0
			nDesconto := TMPDESC->DESCONTOS
		EndIf*/

		//Priscila Kuhn - 27/10/2015
	    //Aglutinador de federa็ใo.
		//054404	AR  CACB MA	=	054404	AR  CACB MA	+	054581	AR ACII
		//054807	AR FACISC	=	054807	AR FACISC	+	054730	AR ACIC
		//054595	AR FACMAT	=	054595	AR FACMAT	+	054461	AR ACITS	+	054578	AR ACIR + 076182 AR ACC

		//Alterad pelo Bruno Nunes 14/04/2021
		//AR FACISC nใo recebe mais pela federa็ใo. Retirado o c๓digo 054807 da condi็ใo
		If AllTrim(QCRPR130->CODENT) $ "054404\054595\054331\054419\054632\054307"

			cQuery := " SELECT SUM(Z6_VALCOM) VALFED2,"
			cQuery += " 	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) VALFEDHW,"
			cQuery += "		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) VALFEDSW"
			cQuery += " FROM SZ6010 SZ6 WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_TPENTID = '8' AND SZ6.D_E_L_E_T_ = ' '"
			cQuery += " AND Z6_CODCCR IN ("
			cQuery += "		SELECT Z3_CODENT"
			cQuery += "		FROM SZ3010"
			cQuery += "		WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ')"
			cQuery += "		AND Z3_TIPENT = '9'"
			cQuery += "		)"

	    	If Select("TMP3") > 0
				TMP3->(DbCloseArea())
			EndIf
			PLSQuery( cQuery, "TMP3" )

			//Yuri Volpe - 22/02/2019
			//OTRS 2019021910001817 - Corre็ใo para inserir valores de Desconto ou Extra, conforme o caso
			cQDescFed := "SELECT SUM(Z6_VALCOM) DESCFED FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND (Z6_TIPO = 'DESCON' OR Z6_TIPO = 'EXTRA') AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ') AND SZ6.D_E_L_E_T_ = ' '"

			If Select("TMPDESCFED") > 0
				TMPDESCFED->(dbCloseArea())
			EndIf
			PLSQuery( cQDescFed, "TMPDESCFED")

			nDescFed := 0
			If TMPDESCFED->DESCFED <> 0
				nDescFed := TMPDESCFED->DESCFED
			EndIf

	    	nFeder 	 := TMP3->VALFED2 + nDescFed + nExtra
	    	nFederSW := TMP3->VALFEDSW + nDescFed + nExtra
	    	nFederHW := TMP3->VALFEDHW

	    	TMPDESCFED->(dbCloseArea())

	    Elseif  QCRPR130->CODENT $ "054581/054730/054461/054578/075379"
	    	nFeder 	:= 0
	    	nFederSw:= 0
	    	nFederHw:= 0
	    Else

	    	//Yuri Volpe - 22/02/2019
			//OTRS 2019021910001817 - Corre็ใo para inserir valores de Desconto ou Extra, conforme o caso
			cQDescFed := "SELECT SUM(Z6_VALCOM) DESCFED FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND Z6_TIPO = 'DESCON' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ') AND SZ6.D_E_L_E_T_ = ' '"

			If Select("TMPDESCFED") > 0
				TMPDESCFED->(dbCloseArea())
			EndIf
			PLSQuery( cQDescFed, "TMPDESCFED")

			nDescFed := 0
			If TMPDESCFED->DESCFED <> 0
				nDescFed := TMPDESCFED->DESCFED
			EndIf

	    	nFeder   := QCRPR130->VALFED + nDesconto + nExtra + nDescFed
	    	nFederSW := QCRPR130->VALFEDSW + nDesconto + nExtra + nDescFed
	    	nFederHW := QCRPR130->VALFEDHW

	    	TMPDESCFED->(dbCloseArea())

	    Endif

	    //Renato Ruy - 11/09/2017
	    //Calculo da AR no mesmo CCR
	    Beginsql Alias "TMPAR"
	    	SELECT Z3_CODAR
			FROM %Table:SZ3% SZ3
			JOIN %Table:SZ4% SZ4
						ON Z4_FILIAL = ' '
						AND Z4_CODENT = Z3_CODAR
						AND SZ4.%NOTDEL%
			WHERE 	Z3_FILIAL = ' '
					AND Z3_CODCCR = %Exp:QCRPR130->CODENT%
					AND Z3_CODAR > ' '
					AND SZ3.%NOTDEL%
			GROUP BY Z3_CODAR
		Endsql

		//Deixa zerado para os demais CCRs
		nAR	   := 0
		nARSW  := 0
		nARHW  := 0

		If !Empty(TMPAR->Z3_CODAR)

			If Select("TMPADI") > 0
				DbSelectArea("TMPADI")
				TMPADI->(DbCloseArea())
			Endif

			//Busca os valores da AR
			Beginsql Alias "TMPADI"

				SELECT SUM(Z6_VALCOM) VALAR,
				       SUM(DECODE(Z6_CATPROD,1,0,Z6_VALCOM)) ARSW,
				       SUM(DECODE(Z6_CATPROD,2,0,Z6_VALCOM)) ARHW
				FROM SZ6010
				WHERE
				Z6_FILIAL = %xFilial:SZ6% AND
				Z6_PERIODO = %Exp:QCRPR130->PERIODO% AND
				Z6_TPENTID = '3' AND
				Z6_CODCCR = %Exp:QCRPR130->CODENT% AND
				D_E_L_E_T_ = ' '

			Endsql

			nAR	   := TMPADI->VALAR + nDesconto + nExtra
			nARSW  := TMPADI->ARSW + nDesconto + nExtra
			nARHW  := TMPADI->ARHW

		Endif
		TMPAR->(DbCloseArea())
		//Fim da alteracao AR

		dbSelectArea("PC2")
		PC2->(dbSetOrder(1))
		If PC2->(dbSeek(xFilial("PC2") + QCRPR130->PERIODO + QCRPR130->CODENT))
			cPfxAdto 	:= PC2->PC2_PREFIX
			cTitAdto 	:= PC2->PC2_NUM
			cParcAdto 	:= PC2->PC2_PARCEL
			cTipoAdto 	:= PC2->PC2_TIPO
			cFornAdto	:= PC2->PC2_FORNEC
			cLojaAdto 	:= PC2->PC2_LOJA
			nPer1Adto	:= PC2->PC2_PER1
			nPer2Adto	:= PC2->PC2_PER2
			nPer3Adto	:= PC2->PC2_PER3
			nSomaAdto	:= PC2->PC2_SOMA
		EndIf


		ZZ6->(DbSetOrder(1))
		If !ZZ6->(DbSeek(xFilial("ZZ6")+QCRPR130->PERIODO+QCRPR130->CODENT))
			If ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
				ZZ6->ZZ6_PERIOD := QCRPR130->PERIODO
				ZZ6->ZZ6_CODAC 	:= QCRPR130->REDE
				ZZ6->ZZ6_CODENT := QCRPR130->CODENT
				ZZ6->ZZ6_DESENT := QCRPR130->DESENT
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := QCRPR130->COMSW + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				ZZ6->ZZ6_COMHW  := QCRPR130->COMHW
				ZZ6->ZZ6_COMTOT := QCRPR130->VALCOM + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				ZZ6->ZZ6_FEDSW  := nFederSw
				ZZ6->ZZ6_FEDHW  := nFederHw
				ZZ6->ZZ6_VALFED := nFeder
				//Renato Ruy - 12/09/2017
				//Grava os novos campos com o valor de AR.
				ZZ6->ZZ6_VALAR	:= nAR
				ZZ6->ZZ6_ARSW	:= nARSW
				ZZ6->ZZ6_ARHW	:= nARHW
				ZZ6->ZZ6_CAMPSW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPSW + nDesconto,0)
				ZZ6->ZZ6_CAMPHW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPHW,0)
				ZZ6->ZZ6_VALCAM := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->Z6_VALCOM,0)
				ZZ6->ZZ6_VALVIS := TMP->Z6_VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS + ZZ6->ZZ6_VALAR
				ZZ6->ZZ6_PREFIX := cPfxAdto
				ZZ6->ZZ6_NUM 	:= cTitAdto
				ZZ6->ZZ6_PARCEL := cParcAdto
				ZZ6->ZZ6_TIPO 	:= cTipoAdto
				ZZ6->ZZ6_FORNEC := cFornAdto
				ZZ6->ZZ6_LOJA 	:= cLojaAdto
				ZZ6->ZZ6_PER1	:= nPer1Adto
				ZZ6->ZZ6_PER2	:= nPer2Adto
				ZZ6->ZZ6_PER3	:= nPer3Adto
				ZZ6->ZZ6_SOMA	:= nSomaAdto
				ZZ6->(MsUnlock())
			EndIf
		ElseIf Empty(ZZ6->ZZ6_PEDIDO)
			If ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_CODAC 	:= QCRPR130->REDE
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := QCRPR130->COMSW + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				ZZ6->ZZ6_COMHW  := QCRPR130->COMHW
				ZZ6->ZZ6_COMTOT := QCRPR130->VALCOM + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				ZZ6->ZZ6_FEDSW  := nFederSw
				ZZ6->ZZ6_FEDHW  := nFederHw
				ZZ6->ZZ6_VALFED := nFeder
				//Renato Ruy - 12/09/2017
				//Grava os novos campos com o valor de AR.
				ZZ6->ZZ6_VALAR	:= nAR
				ZZ6->ZZ6_ARSW	:= nARSW
				ZZ6->ZZ6_ARHW	:= nARHW
				ZZ6->ZZ6_CAMPSW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPSW + nDesconto,0)
				ZZ6->ZZ6_CAMPHW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPHW,0)
				ZZ6->ZZ6_VALCAM := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->Z6_VALCOM,0)
				ZZ6->ZZ6_VALVIS := TMP->Z6_VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS + ZZ6->ZZ6_VALAR
				ZZ6->(MsUnlock())
			EndIf
		EndIf

		//Cria Base de Conhecimento
		//U_CRPA031G()
		StartJob("U_CRPA031G",GetEnvServer(),.F.,ZZ6->(Recno()))

		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

	//Renato Ruy - 24/02/17
	//Gerar a remuneracao para o CCR mesmo quando tem somente campanha.
	If Select("QCRPR130") > 0
		DbSelectArea("QCRPR130")
		QCRPR130->(DbCloseArea())
	Endif

	BeginSql Alias "QCRPR130"

		SELECT 	Z3_CODENT,
				Z3_DESENT,
		  		Z3_CODPAR,
		  		Z3_CODPAR2
		FROM %Table:SZ3% SZ3
		LEFT JOIN %Table:ZZ6% ZZ6
		ON ZZ6_FILIAL      = %xFilial:ZZ6%
		AND ZZ6_PERIOD     = %Exp:aRet[1]%
		AND ZZ6_CODENT     = Z3_CODENT
		AND ZZ6.%Notdel%
		WHERE Z3_FILIAL    = %xFilial:SZ3%
		AND Z3_CODENT Between %Exp:aRet[2]% AND %Exp:aRet[3]%
		AND Z3_CODPAR      > ' '
		AND Z3_ATIVO != 'N'
		AND ZZ6_CODENT    IS NULL
		AND SZ3.%Notdel%

	Endsql

	While !QCRPR130->(EOF())

		cCodParcs := AllTrim(QCRPR130->Z3_CODPAR) + Iif(!Empty(QCRPR130->Z3_CODPAR2),","+AllTrim(QCRPR130->Z3_CODPAR2),"")

		cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM, "
		cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) CAMPHW, "
		cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) CAMPSW, "
		cQuery2 += " 		MAX(Z6_CODAC) CODAC "
		cQuery2 += " FROM " + RetSQLName("SZ6") + " SZ6 "
		cQuery2 += " WHERE "
		cQuery2 += " Z6_FILIAL = ' ' AND "
		cQuery2 += " Z6_PERIODO = '"+aRet[1]+"' AND "
		cQuery2 += " z6_tpentid = '7' AND"
		cQuery2 += " Z6_CODENT IN "+FormatIn(AllTrim(cCodParcs),",")+" AND "
		cQuery2 += " SZ6.D_E_L_E_T_ = ' '"


		If Select("TMP2") > 0
			TMP2->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP2" )

		ZZ6->(DbSetOrder(1))
		If !ZZ6->(DbSeek(xFilial("ZZ6")+aRet[1]+QCRPR130->Z3_CODENT)) .And. TMP2->Z6_VALCOM > 0
			If ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
				ZZ6->ZZ6_PERIOD := aRet[1]
				ZZ6->ZZ6_CODAC 	:= TMP2->CODAC
				ZZ6->ZZ6_CODENT := QCRPR130->Z3_CODENT
				ZZ6->ZZ6_DESENT := QCRPR130->Z3_DESENT
				ZZ6->ZZ6_CAMPSW := TMP2->CAMPSW
				ZZ6->ZZ6_CAMPHW := TMP2->CAMPHW
				ZZ6->ZZ6_VALCAM := TMP2->Z6_VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= TMP2->Z6_VALCOM
				ZZ6->(MsUnlock())
			EndIf
		ElseIf Empty(ZZ6->ZZ6_PEDIDO) .And. TMP2->Z6_VALCOM > 0
			If ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_CODAC 	:= TMP2->CODAC
				ZZ6->ZZ6_CAMPSW := TMP2->CAMPSW
				ZZ6->ZZ6_CAMPHW := TMP2->CAMPHW
				ZZ6->ZZ6_VALCAM := TMP2->Z6_VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= TMP2->Z6_VALCOM
				ZZ6->(MsUnlock())
			EndIf
		EndIf

		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

EndIf

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
EndIf

If AllTrim(aRet[4]) $ "TODAS/REVENDEDOR" //"TODAS","POSTO","AC","REVENDEDOR"

	IncProc( "Selecionando Dados dos Revendedores.")
	ProcessMessage()

		BeginSql Alias "QCRPR130"
			SELECT PERIODO,
			   CODVEND,
			   Max(NOMVEND) NOMVEND,
			   SUM(VALHW) VALHW,
		       SUM(COMHW) COMHW,
		       SUM(VALSW) VALSW,
		       SUM(COMSW) COMSW,
			   SUM(VALPRD) VALPRD,
			   SUM(VALCOM) VALCOM,
			   SUM(CONPED) CONPED FROM (
										SELECT  Z6_PERIODO PERIODO,
												Z6_PEDSITE PEDSITE,
												Z6_PEDGAR PEDGAR,
												Z6_PRODUTO PRODUTO,
										        CASE WHEN Z6_CODENT = '98' THEN '75    ' ELSE Z6_CODENT END CODVEND,
										        CASE WHEN Z6_CODENT = '98' THEN 'Marpe Servicos Contabeis'
										             WHEN Z6_CODENT = '3242' THEN 'NUVEMSIS PARTICIPACOES LTDA'
										        ELSE TRIM(Z6_DESENT) END NOMVEND,
										        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
										        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
										        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
										        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
										        SUM(Z6_VLRPROD) VALPRD,
										        SUM(Z6_VALCOM) VALCOM,
										        CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
										   FROM %Table:SZ6% SZ6
										      WHERE Z6_FILIAL = ' '
										     AND Z6_PERIODO = %Exp:aRet[1]%
										     AND Z6_CODENT Between %Exp:AllTrim(aRet[2])% AND %Exp:AllTrim(aRet[3])%
										     AND Z6_TPENTID = '10'
										     AND SZ6.D_E_L_E_T_ = ' '
										   GROUP BY Z6_PERIODO,
										   			Z6_PEDSITE,
													Z6_PEDGAR,
													Z6_PRODUTO,
										            Z6_CODENT,
										            Z6_DESENT
										   UNION
										   SELECT  Z6_PERIODO PERIODO,
													Z6_PEDSITE PEDSITE,
													Z6_PEDGAR PEDGAR,
													Z6_PRODUTO PRODUTO,
		                      						'46' CODVEND,
											    	'CONTROLE DE VENDAS BORTOLIN' NOMVEND,
											    	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
											        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
											    	SUM(Z6_VLRPROD) VALPRD,
											    	SUM(Z6_VALCOM) VALCOM,
											    	CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
									   		FROM %Table:SZ6% SZ6
									      	WHERE Z6_FILIAL = ' '
									     	AND Z6_PERIODO = %Exp:aRet[1]%
	                       					AND Z6_CODENT IN ('156','2274','46')
									     	AND Z6_TPENTID = '7'
									     	AND SZ6.D_E_L_E_T_ = ' '
											GROUP BY Z6_PERIODO,
											         Z6_PEDSITE,
													 Z6_PEDGAR,
													 Z6_PRODUTO
											UNION
										   SELECT  Z6_PERIODO PERIODO,
													Z6_PEDSITE PEDSITE,
													Z6_PEDGAR PEDGAR,
													Z6_PRODUTO PRODUTO,
		                      						'1158' CODVEND,
											    	'REDE ICP-SEGUROS - MARKETPLACE' NOMVEND,
											    	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
											        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
											    	SUM(Z6_VLRPROD) VALPRD,
											    	SUM(Z6_VALCOM) VALCOM,
											    	CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
									   		FROM %Table:SZ6% SZ6
									      	WHERE Z6_FILIAL = ' '
									     	AND Z6_PERIODO = %Exp:aRet[1]%
	                       					AND Z6_CODAC = 'ICP'
									     	AND Z6_TPENTID = '7'
									     	AND SZ6.D_E_L_E_T_ = ' '
											GROUP BY Z6_PERIODO,
											         Z6_PEDSITE,
													 Z6_PEDGAR,
													 Z6_PRODUTO
			   ) GROUP BY PERIODO, CODVEND
			     ORDER BY PERIODO, CODVEND

		EndSql

	QCRPR130->(dbGoTop())

	While !QCRPR130->(EOF())

		IncProc( "Gerando dados do Revendedor: " + QCRPR130->CODVEND)
		ProcessMessage()

		ZZ6->(DbSetOrder(1))
		If !ZZ6->(DbSeek(xFilial("ZZ6")+QCRPR130->PERIODO+QCRPR130->CODVEND))
			If ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
				ZZ6->ZZ6_PERIOD := QCRPR130->PERIODO
				ZZ6->ZZ6_CODAC 	:= " "
				ZZ6->ZZ6_CODENT := QCRPR130->CODVEND
				ZZ6->ZZ6_DESENT := QCRPR130->NOMVEND
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := 0
				ZZ6->ZZ6_COMHW  := 0
				ZZ6->ZZ6_COMTOT := 0
				ZZ6->ZZ6_CAMPSW := QCRPR130->COMSW
				ZZ6->ZZ6_CAMPHW := QCRPR130->COMHW
				ZZ6->ZZ6_VALCAM := QCRPR130->VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS
				ZZ6->(MsUnlock())
			EndIf
		ElseIf Empty(ZZ6->ZZ6_PEDIDO)
			If ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := 0
				ZZ6->ZZ6_COMHW  := 0
				ZZ6->ZZ6_COMTOT := 0
				ZZ6->ZZ6_CAMPSW := QCRPR130->COMSW
				ZZ6->ZZ6_CAMPHW := QCRPR130->COMHW
				ZZ6->ZZ6_VALCAM := QCRPR130->VALCOM
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS
				ZZ6->(MsUnlock())
			EndIf
		EndIf

		//Cria Base de Conhecimento
		U_CRPA031G()

		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

EndIf

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
EndIf

If AllTrim(aRet[4]) $ "TODAS/AC/CANAL" //"TODAS","POSTO","AC","REVENDEDOR"
	IncProc( "Selecionando Dados das ACs.")
	ProcessMessage()

	//Controle de valores para pedido de origem da campanha.
	//AC BR: Campanha BR e Campanha MarketPlace
	//AC Notarial: Campanha Notarial
	//AC SINCOR: Campanha Sincor
	//AC Sincor Rio: Campanha Sincor RIO
	//Via Internet: Campanha Sincor e Sincor RIO
	//PP Consultoria: Campanha BR, Notarial e MarketPlace

	/*
	CASE
		WHEN SZ6.Z6_CODENT = 'BR' THEN Z6_CODAC IN ('ICP','BR')
		WHEN SZ6.Z6_CODENT = 'NOT' THEN Z6_CODAC = 'NOT'
		WHEN SZ6.Z6_CODENT = 'SIN' THEN Z6_CODAC = 'SIN'
		WHEN SZ6.Z6_CODENT = 'SINRJ' THEN Z6_CODAC = 'SINRJ'
		WHEN SZ6.Z6_CODENT = 'CA0001' THEN Z6_CODAC IN ('SIN','SINRJ')
		WHEN SZ6.Z6_CODENT = 'CA0002' THEN Z6_CODAC IN ('ICP','BR','NOT')
	END */

		BeginSql Alias "QCRPR130"
			SELECT PERIODO,
			       Case When TIPENT = '5' Then '2' Else TIPENT End TIPENT,
			       REDE,
			       CODENT,
			       DESENT,
			       CGC,
			       SUM(CONPED) CONPED,
			       SUM(VALHW) VALHW,
			       SUM(COMHW) COMHW,
			       SUM(VALSW) VALSW,
			       SUM(COMSW) COMSW,
			       SUM(VLRABT) VLRABT,
			       SUM(VALPRD) VALPRD,
			       SUM(VALCOM) VALCOM,
             SUM(VALCAMPHW) VALCAMPHW,
             SUM(VALCAMPSW) VALCAMPSW,
			       SUM(VALCAMP) VALCAMP
			FROM
			  (SELECT Z6_PERIODO PERIODO,
			  		  CASE WHEN Z6_TPENTID IN ('2','5') THEN '2' ELSE '1' END TIPENT,
			          ' ' REDE,
			          CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED,
			          Z6_PEDGAR PEDGAR,
			          Z6_PEDSITE PEDSITE,
			          Z6_PRODUTO PRODUTO,
			          Z3_CODENT CODENT,
			          Z3_DESENT DESENT,
			          Z3_CGC CGC,
			          Z3_CODPAR CODPAR,
			          Z3_CODPAR2 CODPAR2,
			          SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							WHEN Z6_CATPROD = '2' THEN 0
                      ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) COMHW,
			          SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							WHEN Z6_CATPROD = '1' THEN 0
       						ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) COMSW,
			          SUM(Z6_VLRABT) VLRABT,
			          SUM(Z6_VLRPROD) VALPRD,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) VALCOM,
				      SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMPSW,
		              SUM(CASE
						  WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMPHW,
		              SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMP
			   FROM SZ6010 SZ6
			   LEFT JOIN SZ3010 SZ3 ON Z3_FILIAL = ' '
			   AND Z3_TIPENT = Z6_TPENTID
			   AND Z3_CODENT = Z6_CODENT
			   AND SZ3.D_E_L_E_T_ = ' '
			   WHERE Z6_FILIAL = ' '
			   	 AND Z3_TIPCOM != '2'
			     AND Z6_CODENT != 'NAOREM'
			     AND Z6_CODENT != 'TDARED'
			     AND Z6_CODENT != 'CRD'
			     AND Substr(Z6_CODENT,1,4) != 'FECO'
			     AND Z6_CODENT != 'CER'
			     AND Z6_PERIODO = %Exp:aRet[1]%
			     AND Z6_CODENT Between %Exp:aRet[2]% AND %Exp:aRet[3]%
			     AND Z6_TPENTID IN ('1','2','5')
			     AND SZ6.D_E_L_E_T_ = ' '
			   GROUP BY Z6_PERIODO,
			   			Z6_TPENTID,
			            Z6_CODAC,
			            Z6_PEDGAR,
			            Z6_PEDSITE,
			            Z6_PRODUTO,
			            Z3_CODENT,
			            Z3_DESENT,
			            Z3_CGC,
			            Z3_CODPAR,
			            Z3_CODPAR2
			   ORDER BY Z6_PERIODO,
						Z6_TPENTID,
			            Z3_CODENT,
			            Z3_DESENT,
			            Z3_CGC)
			GROUP BY PERIODO,
			         TIPENT,
			         REDE,
			         CODENT,
			         DESENT,
			         CGC
			ORDER BY PERIODO,
			         TIPENT,
			         CODENT,
			         DESENT
		EndSql

	QCRPR130->(dbGoTop())

	While !QCRPR130->(EOF())

		nValVis	 := 0

		If AllTrim(QCRPR130->CODENT) $ "SINRJ/SIN/NOT/BR"

			//AJUSTA CODIGO DE PARCEIROS PARA BUSCAR NA SZ6
			If Select("QCRPR132") > 0
				QCRPR132->(DbCloseArea())
			EndIf

			BeginSql Alias "QCRPR132"
			SELECT  Z3_CODPAR,Z3_CODPAR2
				FROM %Table:SZ3% SZ3
				WHERE
				Z3_FILIAL = ' ' AND
				Z3_TIPENT = '9' AND
				Z3_CODAC = %Exp:AllTrim(QCRPR130->CODENT)% AND
				Z3_ATIVO = 'N' AND
				SZ3.D_E_L_E_T_ = ' '
				GROUP BY Z3_CODPAR,Z3_CODPAR2
			EndSql

			//ZERA CONTEUDO DA VARIAVEL
			cCodPar := ""

			While !QCRPR132->(EOF())

				If !Empty(QCRPR132->Z3_CODPAR)
					cCodPar := Iif(!Empty(cCodPar),cCodPar+","+AllTrim(QCRPR132->Z3_CODPAR),AllTrim(QCRPR132->Z3_CODPAR)) +;
					 		   Iif(!Empty(QCRPR132->Z3_CODPAR2),","+AllTrim(QCRPR132->Z3_CODPAR2),"")
				EndIf

				QCRPR132->(DbSkip())
			EndDo

			//Formata Para query
			cCodPar := "% " + FormatIn(cCodPar,",") + " %"

		    //Busca valor das AR's descredenciadas.
			If Select("QCRPR131") > 0
				QCRPR131->(DbCloseArea())
			EndIf

			BeginSql Alias "QCRPR131"

				SELECT 	SUM(VALDESC)  VALDESC,
						SUM(VALDESCS)  VALDESCS,
						SUM(VALDESCH)  VALDESCH,
						MAX(CAMPANHASW) CAMPANHASW,
						MAX(CAMPANHAHW) CAMPANHAHW,
	              		MAX(CAMPANHA) CAMPANHA FROM (
										      SELECT  Z3_CODENT CODENT,
										              SUM(Z6_VALCOM) VALDESC,
										              SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) VALDESCS,
										              SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) VALDESCH,
										              MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7'  AND Z6_CATPROD = '2' AND Z6_CODENT IN %Exp:cCodPar% )) CAMPANHASW,
										              MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7'  AND Z6_CATPROD = '1' AND Z6_CODENT IN %Exp:cCodPar% )) CAMPANHAHW,
													  MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7' AND Z6_CODENT  IN %Exp:cCodPar% )) CAMPANHA
													FROM %Table:SZ3% SZ3
													JOIN %Table:SZ6% SZ6
													ON Z6_FILIAL = ' '
													AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
													AND Z6_TPENTID = '4'
													AND Z6_CODAC = %Exp:AllTrim(QCRPR130->CODENT)%
													AND Z3_CODENT = Z6_CODCCR
													AND SZ6.D_E_L_E_T_ = ' '
													WHERE
													Z3_FILIAL = ' ' AND
													Z3_TIPENT = '9' AND
													Z3_ATIVO = 'N' AND
													SZ3.D_E_L_E_T_ = ' '
										      GROUP BY Z3_CODENT)

			EndSql

			DbSelectArea("QCRPR131")
			QCRPR131->(DbGoTop())
		ElseIf AllTrim(QCRPR130->CODENT) $ "FEN"

			//Busca valores dos postos fenacon

			If Select("QCRPR131") > 0
				QCRPR131->(DbCloseArea())
			EndIf

			BeginSql Alias "QCRPR131"
				SELECT 	SUM(Z6_VALCOM) VALDESC,
						SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) VALDESCS,
 		                SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) VALDESCH
				FROM %Table:SZ6% SZ6
				WHERE Z6_FILIAL = ' '
				AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
				AND Z6_TPENTID = '4'
				AND Z6_CODCCR = '054615'
				AND SZ6.D_E_L_E_T_ = ' '
			EndSql

			DbSelectArea("QCRPR131")
			QCRPR131->(DbGoTop())

			//Renato Ruy - 20/03/2018
			//Buscar visita externa para remunerar na AC
			BeginSql Alias "TMPVIS"
				SELECT 	SUM(Z6_VALCOM) VALVIS
				FROM %Table:SZ6% SZ6
				WHERE Z6_FILIAL = ' '
				AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
				AND Z6_TPENTID = 'B'
				AND Z6_CODCCR = '054615'
				AND SZ6.D_E_L_E_T_ = ' '
			EndSql
			nValVis := TMPVIS->VALVIS
			TMPVIS->(DbCloseArea())
		EndIf

		IncProc( "Gerando Registros da Entidade: " + QCRPR130->CODENT)
		ProcessMessage()

		ZZ6->(DbSetOrder(1))
		If !ZZ6->(DbSeek(xFilial("ZZ6")+QCRPR130->PERIODO+QCRPR130->CODENT))
			If ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
				ZZ6->ZZ6_PERIOD := QCRPR130->PERIODO
				ZZ6->ZZ6_CODAC 	:= QCRPR130->REDE
				ZZ6->ZZ6_CODENT := QCRPR130->CODENT
				ZZ6->ZZ6_DESENT := QCRPR130->DESENT
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := QCRPR130->COMSW
				ZZ6->ZZ6_COMHW  := QCRPR130->COMHW
				ZZ6->ZZ6_COMTOT := QCRPR130->VALCOM
				ZZ6->ZZ6_CAMPSW := QCRPR130->VALCAMPSW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHASW,0)
				ZZ6->ZZ6_CAMPHW := QCRPR130->VALCAMPHW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHAHW,0)
				ZZ6->ZZ6_VALCAM := QCRPR130->VALCAMP + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHA,0)
				ZZ6->ZZ6_POSSW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCS,0)
				ZZ6->ZZ6_POSHW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCH,0)
				ZZ6->ZZ6_VALPOS := Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESC,0)
				ZZ6->ZZ6_VALVIS := nValVis
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS+ZZ6->ZZ6_VALPOS
				ZZ6->(MsUnlock())
			EndIf
		ElseIf Empty(ZZ6->ZZ6_PEDIDO)
			If ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->ZZ6_QTDPED := QCRPR130->CONPED
				ZZ6->ZZ6_VALSW  := QCRPR130->VALSW
				ZZ6->ZZ6_VALHW  := QCRPR130->VALHW
				ZZ6->ZZ6_VALFAT := QCRPR130->VALPRD
				ZZ6->ZZ6_COMSW  := QCRPR130->COMSW
				ZZ6->ZZ6_COMHW  := QCRPR130->COMHW
				ZZ6->ZZ6_COMTOT := QCRPR130->VALCOM
				ZZ6->ZZ6_CAMPSW := QCRPR130->VALCAMPSW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHASW,0)
				ZZ6->ZZ6_CAMPHW := QCRPR130->VALCAMPHW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHAHW,0)
				ZZ6->ZZ6_VALCAM := QCRPR130->VALCAMP + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHA,0)
				ZZ6->ZZ6_POSSW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCS,0)
				ZZ6->ZZ6_POSHW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCH,0)
				ZZ6->ZZ6_VALPOS := Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESC,0)
				ZZ6->ZZ6_DATCAL := dDataBase
				ZZ6->ZZ6_VALVIS := nValVis
				ZZ6->ZZ6_ORIGEM := "A" //Geracao Automatica
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_COMTOT + ZZ6->ZZ6_VALFED + ZZ6->ZZ6_VALCAM + ZZ6->ZZ6_VALVIS+ZZ6->ZZ6_VALPOS
				ZZ6->(MsUnlock())
			EndIf
		EndIf

		//Cria Base de Conhecimento
		U_CRPA031G()

		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
EndIf

Return

//Funcao executada ao Marcar/Desmarcar um registro.
Static Function Disp()

RecLock("TTRB",.F.)

	If Marked("OK")
		TTRB->OK := cMark
		nContMed := 1
	Else
		TTRB->OK := ""
		nContMed := 0
	Endif

TTRB->(MSUNLOCK())
oMark:oBrowse:Refresh()
Return()

//Fun็ใo para alterar o Produto.
//25/11/2015
User Function CRPA031D()

Local aRet 		:= {}
Local bValid  	:= {|| .T. }
Local aPedidos	:= {}
Local cCodPed	:= ""
Local cTipPed	:= ""

Private aPar 	:= {}

If Empty(ZZ6->ZZ6_PEDIDO) .And. Empty(ZZ6->ZZ6_PEDID2) .And. Empty(ZZ6->ZZ6_PEDID3)
	MsgInfo("Nใo existe pedido a ser alterado!")
	Return
Endif

Iif(!Empty(ZZ6->ZZ6_PEDIDO),AADD(aPedidos,"O="+ZZ6->ZZ6_PEDIDO),"")
Iif(!Empty(ZZ6->ZZ6_PEDID2),AADD(aPedidos,"2="+ZZ6->ZZ6_PEDID2),"")
Iif(!Empty(ZZ6->ZZ6_PEDID3),AADD(aPedidos,"3="+ZZ6->ZZ6_PEDID3),"")

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Produto " 	 ,Space(15),"","","SB1","",50,.T.})
aAdd( aPar,{ 2  ,"Pedido "	 	 ,SubStr(aPedidos[1],8,1) ,aPedidos , 100,'.T.',.T.})

ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , , "CRPA031D", .T., .F. )

If Len(aRet) > 0

	//Renato Ruy - 22/12/16
	//Possibilita ao usuแrio selecionar o pedido que sera alterado.
	cCodPed := ZZ6->&("ZZ6_PEDID"+aRet[2])
	cTipPed := ZZ6->&(Iif(aRet[2]=="O","ZZ6_TIPPED","ZZ6_TPPED"+aRet[2]))

	//Se Posiciona e Altera produto da medi็ใo e pedido.
	If cTipPed == "P"
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+cCodPed))

		//Renato Ruy - 22/11/2016
		//Alterar dados da pre nota.
		If Select("TMPPRE") > 0
			Dbselectarea("TMPPRE")
			TMPPRE->(DbCloseArea())
		EndIf

		Beginsql Alias "TMPPRE"

			%NoParser%

			SELECT R_E_C_N_O_ RECNOD1 FROM %Table:SD1%
			WHERE
			D1_FILIAL = %xFilial:SD1% AND
			D1_PEDIDO = %Exp:SC7->C7_NUM% AND
			D1_FORNECE = %Exp:SC7->C7_FORNECE% AND
			%Notdel%

		Endsql

		If !Empty(TMPPRE->RECNOD1)
			SD1->( DbGoTo( TMPPRE->RECNOD1 ) )
		Endif

		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aRet[1]))
			SC7->(RecLock("SC7",.F.))
				SC7->C7_PRODUTO := SB1->B1_COD
				SC7->C7_DESCRI	:= SB1->B1_DESC
			SC7->(MsUnlock())

			If !Empty(TMPPRE->RECNOD1)
				SD1->(RecLock("SD1",.F.))
					SD1->D1_COD		:= SB1->B1_COD
					SD1->D1_LOCAL	:= SB1->B1_LOCPAD
					SD1->D1_GRUPO	:= SB1->B1_GRUPO
				SD1->(MsUnlock())
			Endif
		Else
			MsgInfo("Produto nใo encontrado!")
		EndIf

	Elseif cTipPed == "M"

		CND->(DbSetOrder(4))
		CND->(DbSeek(xFilial("CND")+cCodPed))

		CNE->(DbSetOrder(4))
		CNE->(DbSeek(xFilial("CNE")+cCodPed))

		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+CND->CND_PEDIDO))

		//Renato Ruy - 22/11/2016
		//Alterar dados da pre nota.
		If Select("TMPPRE") > 0
			Dbselectarea("TMPPRE")
			TMPPRE->(DbCloseArea())
		EndIf

		Beginsql Alias "TMPPRE"

			%NoParser%

			SELECT R_E_C_N_O_ RECNOD1 FROM %Table:SD1%
			WHERE
			D1_FILIAL = %xFilial:SD1% AND
			D1_PEDIDO = %Exp:SC7->C7_NUM% AND
			D1_FORNECE = %Exp:SC7->C7_FORNECE% AND
			%Notdel%

		Endsql

		If !Empty(TMPPRE->RECNOD1)
			SD1->( DbGoTo( TMPPRE->RECNOD1 ) )
		Endif

		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aRet[1]))

			CNE->(RecLock("CNE",.F.))
				CNE->CNE_PRODUT := SB1->B1_COD
			CNE->(MsUnlock())

			SC7->(RecLock("SC7",.F.))
				SC7->C7_PRODUTO := SB1->B1_COD
				SC7->C7_DESCRI	:= SB1->B1_DESC
			SC7->(MsUnlock())

			If !Empty(TMPPRE->RECNOD1)
				SD1->(RecLock("SD1",.F.))
					SD1->D1_COD		:= SB1->B1_COD
					SD1->D1_LOCAL	:= SB1->B1_LOCPAD
					SD1->D1_GRUPO	:= SB1->B1_GRUPO
				SD1->(MsUnlock())
			Endif

		Else
			MsgInfo("Produto nใo encontrado!")
		EndIf

	Else
		Alert("Nใo existe pedido para ser alterado!")
	EndIf
Else
	Alert("Rotina Cancelada!")
EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA031E  บ Autor ณ Renato Ruy	     บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para do Fechamento.							      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Remunera็ใo de Parceiros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CRPA031E

Local aRet 		:= {}
Local bValid  	:= {|| .T. }

Private aPar 	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 ,Space(6),"","",""	   ,"",50,.F.})
aAdd( aPar,{ 1  ,"Grupo AC " 	 ,Space(4),"","",""	   ,"",50,.F.})
aAdd( aPar,{ 1  ,"Entidade " 	 ,Space(6),"","","SZ3","",50,.F.})

ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , ,"CRPA031E" , .T., .F. )
If Len(aRet) > 0
	Processa( {|| CRPA31E(aRet) }, "Gerando tela para selecionar Itens...")
Else
	Alert("Rotina Cancelada!")
EndIf

Return

//Rotina para selecionar e gerar pedido
Static Function CRPA31E(aRet)

Local aCpoBro 	:= {}
Local nOpc		:= 0
Local aCores 	:= {}
Local cWhere 	:= "%"
Local aPergs	:= {}
Local cPeriodo  := SubStr(DtoS(dDatabase),5,2)+SubStr(DtoS(dDatabase),1,4)

Private oDlg
Private cFormaPg  := Space(24)
Private _stru	 := {}
Private _stru2	 := {}
Private cArq	 := ""
Private cArq2	 := ""
Private cCond	 := "007"
Private lInverte := .F.
Private cMark    := GetMark()
Private oMark


aAdd( aPergs ,{1,"Condi็ใo de Pagamento ","007"		 		,"@!"		 	,'.T.',"SE4"	,'.T.',40,.T.})
aAdd( aPergs ,{1,"M๊s/Ano Ref. "		 ,cPeriodo	 		,"@R 99/9999"	,'.T.',""   	,'.T.',40,.T.})
aAdd( aPergs ,{1,"Centro de Custos "	 ,"80000000 "		,"@!"			,'.T.',"CTT"	,'.T.',40,.T.})
aAdd( aPergs ,{1,"Conta contแbil or็ada" ,"420201014      "	,"@!"			,'.T.',"CT1"	,'.T.',60,.T.})
aAdd( aPergs ,{1,"Forma de pagamento"	 ,cFormaPg			,"@!"			,'.T.',"C031PG"	,'.T.',120,.T.})
aAdd( aPergs ,{1,"Nr.Docto. Fiscal"	 	 ,"               "	,"@!"			,'.T.',""   	,'.T.',40,.F.})
aAdd( aPergs ,{1,"Vencimento"		 	 ,dDatabase			,"@D"			,'.T.',""   	,'.T.',40,.T.})

aRet2 := {}

//Renato Ruy - 22/08/2018
//Validar a condi็ใo de Pagamento
SE4->(DbSetOrder(1))

If !ParamBox(aPergs ,"Parametros ",aRet2)
	Alert("A geracao do pedido foi cancelada!")
	Return
Elseif !SE4->(DbSeek(xFilial("SE4")+aRet2[1]))
	Alert("A condicao de pagamento ้ invแlida!")
	Return
EndIf

//Busco os dados do ultimo pedido.
If Select("TMPLOT") > 0
	TMPLOT->(DbCloseArea())
EndIf

If !Empty(aRet[1])
	cWhere += " ZZ6_PERIOD = '"+aRet[1]+"' AND "
EndIf

If !Empty(aRet[2])
	cWhere += " SubStr(ZZ6_CODAC,1,4) = '"+aRet[2]+"' AND "
EndIf

If !Empty(aRet[3])
	cWhere += " ZZ6_CODENT = '"+aRet[3]+"' AND "
EndIf

cWhere 	+= "%"


Beginsql Alias "TMPLOT"
	SELECT ZZ6_CODENT CODIGO, ZZ6_DESENT DESCRICAO, ZZ6_SALDO VALOR, ZZ6_SALDO SALDO, R_E_C_N_O_ RECNOZZ6 FROM %Table:ZZ6%  ZZ6
	WHERE
	ZZ6_FILIAL = %xFilial:ZZ6% AND
	(ZZ6_SALDO > 0 OR ZZ6_PEDIDO = ' ') AND
	%Exp:cWhere%
	ZZ6.%NotDel%
	Order by ZZ6_DESENT
Endsql

//Cria um arquivo de Apoio para controle dos contratos
If Select("TTRB") > 0
	TTRB->(DbCloseArea())
EndIf

AADD(_stru,{"OK"     	,"C"	,2		,0		})
AADD(_stru,{"CODIGO"  	,"C"	,6		,0		})
AADD(_stru,{"DESCRICAO"	,"C"	,50		,0		})
AADD(_stru,{"VALOR"		,"N"	,15		,2		})
AADD(_stru,{"SALDO"		,"N"	,15		,2		})
AADD(_stru,{"RECNOZZ6"	,"N"	,15		,0		})

cArq:=Criatrab(_stru,.T.)

DBUSEAREA(.t.,,carq,"TTRB")

//Gravo os dados na tabela temporแria.
While !TMPLOT->(EOF())
	TTRB->(Reclock("TTRB",.T.))
		TTRB->CODIGO		:= TMPLOT->CODIGO
		TTRB->DESCRICAO 	:= TMPLOT->DESCRICAO
		TTRB->VALOR	  		:= TMPLOT->VALOR
		TTRB->SALDO	  		:= TMPLOT->SALDO
		TTRB->RECNOZZ6		:= TMPLOT->RECNOZZ6
	TTRB->(MsUnlock())

	TMPLOT->(DbSkip())
EndDo

//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
aCpoBro	:= {{ "OK"			,, "Mark"           ,"@!"},;
			{ "CODIGO" 		,, "CODIGO" 	    ,"@!"},;
			{ "DESCRICAO"	,, "DESCRICAO"      ,"@!"},;
			{ "VALOR"		,, "VALOR"		    ,"@E 999,999,999.99"},;
			{ "SALDO"		,, "SALDO"	      	,"@E 999,999,999.99"},;
			{ "RECNOZZ6"	,, "RECNO"	      	,"@E 999,999,999"}}

//Cria uma Dialog
DEFINE MSDIALOG oDlg TITLE "SELECIONE OS PEDIDOS" From 9,0 To 335,800 PIXEL

DbSelectArea("TTRB")
DbGotop()

aCores := {}
aAdd(aCores,{"TTRB->OK == ' '","BR_VERMELHO"})
aAdd(aCores,{"TTRB->OK != ' '","BR_VERDE"	 })

//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{30,1,120,400},,,,,aCores)
oMark:bMark := {|| MarkOk(TTRB->SALDO)}
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:lhasMark 	  := .T.
oMark:oBrowse:bAllMark	  := { || CRPA31In(cMark,"TTRB","OK")}

//Renato Ruy - 13/02/17
//Cria campo para informa a condicao de pagamento
//@ 136,005 Say " Condi็ใo de Pagamento: " of oDlg Pixel
//@ 133,070 MSGET cCond SIZE 30,11 OF oDlg F3 "SE4" PIXEL PICTURE "@!" Valid ExistCpo( "SE4", cCond )

If Select("TTRB") > 0
	//Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT	EnchoiceBar(oDlg,{|| nOpc := 1, oDlg:End()},{|| CRP31CAN()})
Else
	Alert("Nใo foi possivel encontrar informa็๕es!")
EndIf

If nOpc == 1
	Processa( {|| CRPA31E2(aRet) }, "Gerando Pedidos...")
Else
	Alert("Rotina cancelada!")
EndIf

Return

//Funcao executada ao Marcar/Desmarcar um registro.
Static Function MarkOk(nValor)

// Cria diแlogo
Local oDlg2
Local nValPed := nValor

RecLock("TTRB",.F.)

	If Marked("OK")
		oDlg2 := MSDialog():New(001,001,100,310,'VALOR DO PEDIDO',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		@ 35,031 SAY "Valor: " OF oDlg2 PIXEL
		@ 35,061 MSGET nValPed   SIZE 50,5 OF oDlg2 PIXEL PICTURE "@E 999999999999.99"

		// Ativa diแlogo centralizado
		ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT	EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| oDlg2:End()})

		If nValPed <= nValor
			TTRB->VALOR := nValPed
		Else
			MsgInfo("O valor nใo pode ser superior")
		EndIf
		TTRB->OK 	:= cMark
	Else
		TTRB->VALOR := nValor
		TTRB->OK := ""
	Endif

TTRB->(MSUNLOCK())
oMark:oBrowse:Refresh()
Return()

//Processa gera็ใo dos pedidos.
Static Function CRPA31E2(aRet)

Local aCabec 	:= {}
Local aLinha 	:= {}
Local aItens 	:= {}
//Renato Ruy - 22/09/2016
//Log da gera็ใo de Pedidos em Lote.
Local aCabPed	:= {}
Local aItemPed	:= {}
Local aPedidos	:= {}
Local dDiasVen	:= 0

Local cNumCND	:= ""
Local cNumSC7	:= ""
Local aPar		:= {}
Local aRet		:= {}
Local bValid  	:= {|| .T. }
Local nOpc		:= 0
Local lContra	:= .T.

Local cCompet	:= ""
Local nSaveSX8 	:= GetSX8Len()

Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

IncProc( "Incluindo Pedido!" )
ProcessMessage()

TTRB->(DbGoTop())

//Renato Ruy - 22/09/2016
//Log da gera็ใo de Pedidos em Lote.
//Cabe็alho dos pedidos
Aadd(aCabPed,"PERIODO")		// PERIODO DE CALCULO
Aadd(aCabPed,"PARCEIRO")		// CODIGO PARCEIRO
Aadd(aCabPed,"DESCRIวรO") 	// DESCRICAO PARCEIRO
Aadd(aCabPed,"MEDIวรO") 		// CODIGO MEDICAO
Aadd(aCabPed,"PEDIDO") 		// CODIGO PEDIDO
Aadd(aCabPed,"VALOR") 		// VALOR DO PEDIDO

While !TTRB->(EOF())

	lMsErroAuto := .F.
	aCabec 		:= {}
	aLinha 		:= {}
	aItens 		:= {}
	aItemPed		:= {}
	cNumSC7		:= ""

	If !Empty(TTRB->OK)

		ZZ6->( DbGoTo( TTRB->RECNOZZ6 ) )

		//Renato Ruy - 26/10/16
		//Gera็ใo automแtica de Parceiro para revendedores.
		SZ3->(DbSetOrder(1))
		If !SZ3->(DbSeek(xFilial("SZ3")+ ZZ6->ZZ6_CODENT)) .And. Empty(ZZ6->ZZ6_CODAC)

			Msginfo("Selecione o Fornecedor do Parceiro : " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT)

			aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(6),"","","SA2","",50,.F.})

			If ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )

				If SZ3->(Reclock("SZ3",.T.))
					SZ3->Z3_FILIAL := xFilial("SZ3")
					SZ3->Z3_CODENT := ZZ6->ZZ6_CODENT
					SZ3->Z3_TIPENT := ZZ6->ZZ6_DESENT
					SZ3->Z3_TIPCOM := "7"
					SZ3->Z3_CODFOR := aRet[1]
					SZ3->Z3_LOJA   := "01"
					SZ3->(MsUnlock())
				Else
					MsgInfo("Nใo foi possํvel gerar o pedido, verifique o vinculo entre a Entidade: "+ ZZ6->ZZ6_CODENT + " - " + AllTrim(ZZ6->ZZ6_DESENT)+" X Fornecedor.")
					TTRB->(DbSkip())
					Loop
				Endif

			Endif
		Elseif Empty(SZ3->Z3_CODFOR)
			Msginfo("Selecione o Fornecedor do Parceiro : " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT)

			aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(6),"","","SA2","",50,.F.})

			If ParamBox( aPar, 'Parโmetros', @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )

				If SZ3->(Reclock("SZ3",.F.))
					SZ3->Z3_CODFOR := aRet[1]
					SZ3->Z3_LOJA   := "01"
					SZ3->(MsUnlock())
				Else
					MsgInfo("Nใo foi possํvel gerar o pedido, o usuario nใo selecionou fornecedor para o parceiro: "+ ZZ6->ZZ6_CODENT + " - " + AllTrim(ZZ6->ZZ6_DESENT))
					TTRB->(DbSkip())
					Loop
				Endif
			Endif
		Endif

		//Renato Ruy - 05/07/2018
		//Novo processo para o usuแrio selecionar o fornecedor
		AC9->(DbSetOrder(2)) //AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT
		If AC9->(DbSeek(xFilial("AC9")+"SZ3"+xFilial("SZ3")+ZZ6->ZZ6_CODENT))
			aAdd( aPar,{ 1  ,"Fornecedor " 	 ,Space(8),"","","SZ3FOR","",50,.T.})
			If ParamBox( aPar, ZZ6->ZZ6_DESENT, @aRet, bValid, , , , , ,"CRPA031F" , .T., .F. )
				SZ3->(Reclock("SZ3",.F.))
					SZ3->Z3_CODFOR := SubStr(aRet[1],1,6)
					SZ3->Z3_LOJA   := SubStr(aRet[1],7,2)
				SZ3->(MsUnlock())
			Else
				MsgInfo("Sera mantido o fornecedor atual: "+SZ3->Z3_CODFOR)
			Endif
		Endif
		// Fim do novo processo do fornecedor

		If Select("TMPPED") > 0
			TMPPED->(DbCloseArea())
		EndIf

		IncProc( "Seleciona o Fornecedor x Produto.")
		ProcessMessage()

		//Busco os dados do ultimo pedido.
		Beginsql Alias "TMPPED"
			SELECT D1_COD, D1_TES FROM %Table:SD1% SD1
			WHERE
			D1_FILIAL = %xFilial:SD1% AND
			D1_FORNECE = %Exp:SZ3->Z3_CODFOR% AND
			D1_LOJA = '01' AND
			SUBSTR(D1_COD,1,2) = 'CS' AND
			D1_EMISSAO = (SELECT MAX(D1_EMISSAO) FROM %Table:SD1% WHERE D1_FILIAL = %xFilial:SD1% AND D1_FORNECE = %Exp:SZ3->Z3_CODFOR% AND SUBSTR(D1_COD,1,2) = 'CS' AND D1_LOJA = '01' AND %NOTDEL%) AND
			SD1.%NOTDEL%
		Endsql

		//Me posiciono no produto do ๚ltimo pedido
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1") + TMPPED->D1_COD ))
			SB1->(DbSeek(xFilial("SB1") + "CS001009" ))
		EndIf

		//Busco os dados do contrato.
		nContMed := 0

		If Select("TMPMED") > 0
			TMPMED->(DbCloseArea())
		EndIf

		//Busco os dados do contrato.
		Beginsql Alias "TMPMED"
			SELECT NVL(Z3_CODENT,' ') CODCCR,CNC_NUMERO CONTRATO, MAX(CNC_REVISA) REVISAO, MAX(CN9_DESCRI) DESCRICAO FROM %Table:CNC%  CNC
			JOIN %Table:CN9% CN9 ON CN9_FILIAL = %xFilial:CN9% AND CN9_NUMERO = CNC_NUMERO AND CN9_SITUAC = '05' AND CN9.%NotDel%
			LEFT JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODFOR = CNC_CODIGO AND Z3_LOJA = CNC_LOJA AND Z3_TIPENT = '9' AND SZ3.%NotDel%
			WHERE
			CNC_FILIAL = %xFilial:CNC% AND
			CNC_CODIGO = %Exp:SZ3->Z3_CODFOR% AND
			CNC_LOJA = '01' AND
			CNC.%NotDel%
			GROUP BY CNC_NUMERO, Z3_CODENT
		Endsql

		//Cria um arquivo de Apoio para controle dos contratos
		_stru2 := {}
		AADD(_stru2,{"OK"     	,"C"	,2		,0		})
		AADD(_stru2,{"CODCCR"  	,"C"	,6		,0		})
		AADD(_stru2,{"CONTRATO"  ,"C"	,15		,0		})
		AADD(_stru2,{"REVISAO"  	,"C"	,3		,0		})
		AADD(_stru2,{"DESCRICAO" 	,"C"	,120	,0		})

		cArq2:=Criatrab(_stru2,.T.)

		If Select("TTRB2") > 0
			TTRB2->(DbCloseArea())
		EndIf

		DBUSEAREA(.t.,,carq2,"TTRB2")

		TMPMED->(DbGotop())

		While  !TMPMED->(Eof())
			DbSelectArea("TTRB2")
			RecLock("TTRB2",.T.)
				TTRB2->CODCCR   :=  TMPMED->CODCCR
				TTRB2->CONTRATO :=  TMPMED->CONTRATO
				TTRB2->REVISAO  :=  TMPMED->REVISAO
				TTRB2->DESCRICAO:=  TMPMED->DESCRICAO
			MsunLock()
			TMPMED->(DbSkip())
		Enddo

		//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
		aCpoBro2	:= {{ "OK"			,, "Mark"           ,"@!"},;
					{ "CODCCR"		,, "CODCCR"       ,"@!"},;
					{ "CONTRATO"		,, "CONTRATO"       ,"@!"},;
					{ "REVISAO"		,, "REVISAO"        ,"@!"},;
					{ "DESCRICAO"		,, "DESCRICAO"      ,"@!"}}

		DbSelectArea("TTRB2")
		DbGotop()

		If !TTRB2->(EOF())
			//Cria uma Dialog
			DEFINE MSDIALOG oDlg TITLE "SELECIONE O CONTRATO" From 9,0 To 315,800 PIXEL

			aCores := {}
			aAdd(aCores,{"TTRB2->REVISAO == ' '","BR_VERMELHO"})
			aAdd(aCores,{"TTRB2->REVISAO != ' '","BR_VERDE"	 })

			//Cria a MsSelect
			oMark := MsSelect():New("TTRB2","OK","",aCpoBro2,@lInverte,@cMark,{30,1,150,400},,,,,aCores)
			oMark:bMark := {| | Disp()}

			//Exibe a Dialog
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT	EnchoiceBar(oDlg,{|| oDlg:End()},{|| CRP31CAN()})
		EndIf

		If nOpc == 2
			Alert("Processo cancelado pelo usuario!")
			Return
		Endif

		//Fa็o Loop para somar caso exista mais de um tํtulo para gerar a compensa็ใo da NCC.
		While TTRB2->(!EOF()) .And. lContra

			If !Empty(TTRB2->OK)
				lContra := .F.
			Else
				TTRB2->(DbSkip())
			EndIf

		EndDo


		If nContMed == 0 //TMPMED->(EOF())

			cNumSC7  := Criavar("C7_NUM",.T.)//Gera numero do pedido de compra
			While ( GetSX8Len() > nSaveSX8 )
				ConFirmSX8()
			EndDo

			IncProc( "Pedido Numero: "+cNumSC7)
			ProcessMessage()
			//Cabe็alho do pedido de compras
			aadd(aCabec,{"C7_NUM" 		,cNumSC7		})
			aadd(aCabec,{"C7_EMISSAO" 	,dDataBase		})
			aadd(aCabec,{"C7_FORNECE" 	,SZ3->Z3_CODFOR	})
			aadd(aCabec,{"C7_LOJA" 		,SZ3->Z3_LOJA	})
			aadd(aCabec,{"C7_COND" 		,aRet2[1]		})
			aadd(aCabec,{"C7_CONTATO" 	," "			})
			aadd(aCabec,{"C7_FILENT" 	,xFilial("SC7")	})

			aLinha := {}
			aadd(aLinha,{"C7_PRODUTO" 	,SB1->B1_COD									,Nil})
			aadd(aLinha,{"C7_QUANT" 	,1 												,Nil})
			aadd(aLinha,{"C7_PRECO" 	,TTRB->VALOR									,Nil})
			aadd(aLinha,{"C7_TOTAL" 	,TTRB->VALOR									,Nil})
			aadd(aLinha,{"C7_TES" 		,Iif(Empty(TMPPED->D1_TES),"101",TMPPED->D1_TES),Nil})
			aadd(aLinha,{"C7_LOCAL"		,"00" 											,Nil})
			aadd(aLinha,{"C7_APROV"		,Posicione('CTT',1, xFilial('CTT')+aRet2[3],'CTT_GARVAR'),Nil})
			aadd(aLinha,{"C7_CONTA"		,SB1->B1_CONTA									,Nil})

			//Campos da capa de despesa
			aadd(aLinha,{"C7_XREFERE",aRet2[2]									,Nil})
			aadd(aLinha,{"C7_APBUDGE","1"										,Nil})
			aadd(aLinha,{"C7_XRECORR","2"										,Nil})
			aadd(aLinha,{"C7_CC" 	 ,aRet2[3]									,Nil})
			aadd(aLinha,{"C7_CCAPROV",aRet2[3]									,Nil})
			aadd(aLinha,{"C7_ITEMCTA","000000000"								,Nil})
			aadd(aLinha,{"C7_CLVL   ","000000000"								,Nil})
			aadd(aLinha,{"C7_CTAORC ",aRet2[4]									,Nil})
			aadd(aLinha,{"C7_FORMPG ",aRet2[5]									,Nil})
			aadd(aLinha,{"C7_DOCFIS ",aRet2[6]									,Nil})
			aadd(aLinha,{"C7_XVENCTO",aRet2[7]									,Nil})
			//CC: 80000000
			aadd(aItens,aLinha)

			//Cria base de conhecimento.
			CRPA031H(cNumSC7)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//| Gera o Pedido de Compras 									 |
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			MATA120(1,aCabec,aItens,3)

			ZZ6->(RecLock("ZZ6",.F.))
				If Empty(ZZ6->ZZ6_PEDIDO)
					ZZ6->ZZ6_PEDIDO := cNumSC7
					ZZ6->ZZ6_TIPPED := "P"
					ZZ6->ZZ6_DATGER := dDataBase

				Elseif Empty(ZZ6->ZZ6_PEDID2)
					ZZ6->ZZ6_PEDID2 := cNumSC7
					ZZ6->ZZ6_TPPED2 := "P"
					ZZ6->ZZ6_DTGER2 := dDataBase
				Elseif Empty(ZZ6->ZZ6_PEDID3)
					ZZ6->ZZ6_PEDID3 := cNumSC7
					ZZ6->ZZ6_TPPED3 := "P"
					ZZ6->ZZ6_DTGER3 := dDataBase
				Endif
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_SALDO - TTRB->VALOR
			ZZ6->(MsUnlock())

			//Adiciona dados  do pedido atual adicionado.
			aItemPed := Array(Len(aCabPed))

			aItemPed[1] := ZZ6->ZZ6_PERIOD // Periodo
			aItemPed[2] := ZZ6->ZZ6_CODENT // Cod.Entida
			aItemPed[3] := ZZ6->ZZ6_DESENT	// Desc.Entidade
			aItemPed[4] := ""				// Medicao
			aItemPed[5] := cNumSC7 			// Ped.Compras
			aItemPed[6] := Transform(TTRB->VALOR,"@E 999,999,999.99")// Valor Pedido

		Else

			dbSelectArea("CN9")
			CN9->(dbSetOrder(1))
			If CN9->(!dbSeek(xFilial("CN9")+TTRB2->CONTRATO+TTRB2->REVISAO))
				MsgInfo("Nใo foi possํvel encontrar o contrato: "+TTRB2->CONTRATO+" Revisใo: "+TTRB2->REVISAO + ". O pedido nใo foi gerado.")
				Return
			EndIf

			If AllTrim(CN9->CN9_SITUAC) != "05"
				MsgInfo("O contrato: "+TTRB2->CONTRATO+" Revisใo: "+TTRB2->REVISAO + " nใo estแ vigente. O pedido nใo foi gerado.")
				Return
			EndIf

			/*If CN9->CN9_DTFIM <= dDataBase
				MsgInfo("O contrato: "+TTRB2->CONTRATO+" Revisใo: "+TTRB2->REVISAO + " estแ vencido. O pedido nใo foi gerado.")
				Return
			EndIf*/

			CN1->(dbSetOrder(1))
			CN1->(dbseek(xFilial("CN1")+CN9->CN9_TPCTO))

			/*If CN9_SALDO <= 0 //.And. !(CN9->CN9_TPCTO $ "")
				MsgInfo("O contrato: "+TTRB2->CONTRATO+" Revisใo: "+TTRB2->REVISAO + " estแ sem saldo. O pedido nใo foi gerado.")
				Return
			EndIf*/


			//Renato Ruy - 16/06/2016
			//Conforme solicitacao da Bruna Costa a competencia sera considerada como mes de emissao da Medicao.
			//cCompet := SubStr(ZZ6->ZZ6_PERIOD,5,2)+"/"+SubStr(ZZ6->ZZ6_PERIOD,1,4)
			cCompet := SubStr(DtoS(dDataBase),5,2)+"/"+SubStr(DtoS(dDataBase),1,4)

			aCabec := {}
			cNumCND	:= CriaVar("CND_NUMMED")
			aAdd(aCabec,{"CND_CONTRA"	,TTRB2->CONTRATO									,NIL})
			aAdd(aCabec,{"CND_REVISA"	,TTRB2->REVISAO									,NIL})
			aAdd(aCabec,{"CND_NUMERO"	,"000001"										,NIL})
			aAdd(aCabec,{"CND_PARCEL"	," "											,NIL})
			aAdd(aCabec,{"CND_COMPET"	,cCompet										,NIL})
			aAdd(aCabec,{"CND_NUMMED"	,cNumCND										,NIL})
			aAdd(aCabec,{"CND_FORNEC"	,SZ3->Z3_CODFOR									,NIL})
			aAdd(aCabec,{"CND_LJFORN"	,SZ3->Z3_LOJA									,NIL})
			aAdd(aCabec,{"CND_CONDPG"	,aRet2[1]										,NIL})
			aAdd(aCabec,{"CND_VLTOT"	,TTRB->VALOR									,NIL})
			aAdd(aCabec,{"CND_APROV"	,Posicione('CTT',1, xFilial('CTT')+"80000000",'CTT_GARVAR'),NIL})
			aAdd(aCabec,{"CND_MOEDA"	,"1"											,NIL})

			aLinha := {}
			aadd(aLinha,{"CNE_ITEM" 	,"001"											,NIL})
			aadd(aLinha,{"CNE_PRODUT" 	,SB1->B1_COD									,NIL})
			aadd(aLinha,{"CNE_QUANT" 	,1 												,NIL})
			aadd(aLinha,{"CNE_VLUNIT" 	,TTRB->VALOR									,NIL})
			aadd(aLinha,{"CNE_VLTOT" 	,TTRB->VALOR									,NIL})
			aadd(aLinha,{"CNE_TE" 		,Iif(Empty(TMPPED->D1_TES),"101",TMPPED->D1_TES),NIL})
			aadd(aLinha,{"CNE_DTENT"	,dDatabase										,NIL})
			aadd(aLinha,{"CNE_CC" 		,aRet2[3]						   				,NIL})
			aadd(aLinha,{"CNE_CONTA"	,SB1->B1_CONTA									,NIL})
			//CC: 80000000
			aadd(aItens,aLinha)

			ZZ6->(RecLock("ZZ6",.F.))
				If Empty(ZZ6->ZZ6_PEDIDO)
					ZZ6->ZZ6_PEDIDO := cNumCND
					ZZ6->ZZ6_TIPPED := "M"
					ZZ6->ZZ6_DATGER := dDataBase

				Elseif Empty(ZZ6->ZZ6_PEDID2)
					ZZ6->ZZ6_PEDID2 := cNumCND
					ZZ6->ZZ6_TPPED2 := "M"
					ZZ6->ZZ6_DTGER2 := dDataBase
				Elseif Empty(ZZ6->ZZ6_PEDID3)
					ZZ6->ZZ6_PEDID3 := cNumCND
					ZZ6->ZZ6_TPPED3 := "M"
					ZZ6->ZZ6_DTGER3 := dDataBase
				Endif
				ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_SALDO - TTRB->VALOR
			ZZ6->(MsUnlock())

			//Executa rotina automatica para gerar as medicoes
			MSExecAuto({|w, x, y, z| CNTA120(w, x, y, z)}, aCabec, aItens, 3, .F.)
			If (lMsErroAuto)
				MostraErro()
			EndIf

			CND->(DbSetOrder(4))
			If !CND->(DbSeek(xFilial("CND")+cNumCND))

				//Renato Ruy - 05/04/2018
				//Caso tenha problemas ou erro durante a geracao
				//Restaura saldo
				ZZ6->(RecLock("ZZ6",.F.))
					If cNumCND == ZZ6->ZZ6_PEDIDO
						ZZ6->ZZ6_PEDIDO := " "
						ZZ6->ZZ6_TIPPED := " "
						ZZ6->ZZ6_DATGER := CtoD("  /  /  ")
					Elseif cNumCND == ZZ6->ZZ6_PEDID2
						ZZ6->ZZ6_PEDID2 := " "
						ZZ6->ZZ6_TPPED2 := " "
						ZZ6->ZZ6_DTGER2 := CtoD("  /  /  ")
					Elseif cNumCND == ZZ6->ZZ6_PEDID3
						ZZ6->ZZ6_PEDID3 := " "
						ZZ6->ZZ6_TPPED3 := " "
						ZZ6->ZZ6_DTGER3 := CtoD("  /  /  ")
					Endif
					ZZ6->ZZ6_SALDO	:= ZZ6->ZZ6_SALDO
				ZZ6->(MsUnlock())

				MsgInfo("Nใo foi possํvel gerar a medi็ใo!")
				TTRB->(DbSkip())
				Loop
			Else

				//Cria base de conhecimento.
				cNumSC7 := GetSx8Num("SC7","C7_NUM")
				CRPA031H(cNumSC7)
				SC7->(RollBackSx8())

				//Encerra medi็ใo
				MSExecAuto({|x, y, z| CNTA120(x, y, z)}, aCabec, aItens, 6)
				If (lMsErroAuto)
					MostraErro()
				EndIf

				//Adiciona dados  do pedido atual adicionado.
				aItemPed := Array(Len(aCabPed))

				aItemPed[1] := ZZ6->ZZ6_PERIOD // Periodo
				aItemPed[2] := ZZ6->ZZ6_CODENT // Cod.Entida
				aItemPed[3] := ZZ6->ZZ6_DESENT	// Desc.Entidade
				aItemPed[4] := cNumCND			// Medicao
				aItemPed[5] := CND->CND_PEDIDO	// Ped.Compras
				aItemPed[6] := Transform(TTRB->VALOR,"@E 999,999,999.99")// Valor Pedido

				//Se nใo encerrou, exclui.
				If Empty(CND->CND_PEDIDO)

					//Renato Ruy - 19/01/2018
					//Exclui pedido de compra
					SC7->(DbSetOrder(1))
					If SC7->(DbSeek(xFilial("SC7")+cNumSC7))
						SC7->(RecLock("SC7",.F.))
							SC7->(DbDelete())
						SC7->(MsUnLock())

						SCR->(DbSetOrder(1))
						If SCR->(DbSeek(xFilial("SCR")+"PC"+cNumSC7))

							While SCR->CR_NUM == cNumSC7 .And. SCR->CR_TIPO == "PC"
								SCR->(RecLock("SCR",.F.))
									SCR->(DbDelete())
								SCR->(MsUnLock())
								SCR->(DbSkip())
							Enddo

						Endif

					Endif

					CND->(RecLock("CND",.F.))
						CND->(DbDelete())
					CND->(MsUnLock())

					CNE->(DbSetOrder(4))
					If CNE->(DbSeek(xFilial("CNE")+cNumCND))
						CNE->(RecLock("CNE",.F.))
							CNE->(DbDelete())
						CNE->(MsUnLock())
					Endif

				EndIf

			EndIf
		EndIf

		TTRB2->(DbCloseArea())
		Iif(File(cArq2 + GetDBExtension()),FErase(cArq2  + GetDBExtension()) ,Nil)
		//If !lMsErroAuto

			/*If TMPMED->(EOF())
				SC7->(DbSetOrder(1))
				If !SC7->(DbSeek(xFilial("SC7")+cNumSC7))
					MsgInfo("Nใo foi possํvel gerar o pedido, por favor execute novamente o processo!")
					Exit
					TTRB->(DbSkip())
				Endif
			EndIf*/

			//Procura adiantamento e grava dados no Pedido de Compras
			ZZ7->(DbSetOrder(1))
			If ZZ7->(DbSeek(xFilial("ZZ7")+SZ3->Z3_CODENT+ZZ6->ZZ6_PERIOD+Space(TamSX3("ZZ7_PRETIT")[1])))
			    If ZZ7->ZZ7_SALDO > 0

			    	dDiasVen := dDataBase+Val(RTrim(Posicione("SE4",1,xFilial("SE4")+aRet2[1],"E4_COND")))

			    	//Envia notifica็ใo de adiantamento
			    	U_CRPA051(dDiasVen,aRet2,Space(TamSX3("ZZ7_PRETIT")[1]))

					ZZ7->(RecLock("ZZ7",.F.))
						ZZ7->ZZ7_SALDO := ZZ7->ZZ7_SALDO - SE2->E2_VALLIQ
					ZZ7->(MsUnlock())
				EndIf
			EndIf

			/*ZZ6->(RecLock("ZZ6",.F.))
				If Empty(ZZ6->ZZ6_PEDIDO)
					ZZ6->ZZ6_PEDIDO := Iif(TMPMED->(EOF()),cNumSC7,cNumCND)
					ZZ6->ZZ6_TIPPED := Iif(TMPMED->(EOF()),"P","M")
					ZZ6->ZZ6_DATGER := dDataBase
				Elseif Empty(ZZ6->ZZ6_PEDID2)
					ZZ6->ZZ6_PEDID2 := Iif(TMPMED->(EOF()),cNumSC7,cNumCND)
					ZZ6->ZZ6_TPPED2 := Iif(TMPMED->(EOF()),"P","M")
					ZZ6->ZZ6_DTGER2 := dDataBase
				Elseif Empty(ZZ6->ZZ6_PEDID3)
					ZZ6->ZZ6_PEDID3 := Iif(TMPMED->(EOF()),cNumSC7,cNumCND)
					ZZ6->ZZ6_TPPED3 := Iif(TMPMED->(EOF()),"P","M")
					ZZ6->ZZ6_DTGER3 := dDataBase
				Endif
				ZZ6->ZZ6_SALDO := ZZ6->ZZ6_SALDO - TTRB->VALOR
			ZZ6->(MsUnlock())*/

			//Adiciona dados do Log se gerado corretamente.
			AADD(aPedidos,aItemPed)

			IncProc( "Pedido Gerado com Sucesso.")
			ProcessMessage()
		//Else
	   	//	MostraErro()
		//EndIf

	EndIf

	TTRB->(DbSkip())
EndDo

//Exporta arquivo com os dados do Log de Pedidos em Lote.
MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
							{||DlgToExcel({{"ARRAY",;
							"Log da Gera็ใo de Pedidos em Lote",;
							aCabPed,aPedidos}})})

//Arquivo nใo esta abrindo automaticamente, talvez a fun็ใo abaixo ajude.
//Ainda nใo foi testado.
//Tentando abrir o objeto
//nRet := ShellExecute("open", cNomeArqP, "", cDirP, 1)

//Se houver algum erro
//If nRet <= 32
//	MsgStop("Nใo foi possํvel abrir o arquivo " +cDirP+cNomeArqP+ "!", "Aten็ใo")
//EndIf

//Fecha a Area e elimina os arquivos de apoio criados em disco.
TTRB->(DbCloseArea())

Return

/*
----------------------------------------------------------------------------
| Rotina    | SvArqSdk     | Autor | Gustavo Prudente | Data | 20.05.2015  |
|--------------------------------------------------------------------------|
| Rotina    | CRPA031F     |Adequada| Renato Ruy   	  | Data | 11.02.2016  |
|--------------------------------------------------------------------------|
| Descricao | Grava os arquivos anexos no banco de conhecimento            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CRPA031H(cPedido)

Local aArea		:= GetArea()
Local cFile 	:= StrTran(AllTrim(NoAcento(AnsiToOem( ZZ6->ZZ6_PERIOD + " - " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT ))),"/","-")

_cPedMed := cPedido

IncProc( "Gerando o arquivo e adicionando a Base de Conhecimento.")
ProcessMessage()

DbSelectArea("ACB")
DbSetOrder(2)

// Nใo fa็o copia do arquivo, apenas aponto o arquivo ja existente.
// Inclui registro no banco de conhecimento e verifico se ja existe para nใo duplicar.
ACB->(DbSetOrder(2))
ACB->(DbSeek(xFilial("ACB") + cFile + ".pdf" ))

DbSelectArea("ACB")
RecLock("ACB",.T.)
ACB_FILIAL := xFilial("ACB")
ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
ACB_OBJETO	:= cFile + ".pdf"
ACB_DESCRI	:= cFile
MsUnLock()

ConfirmSx8()

// Inclui amarra็ใo entre registro do banco e entidade
DbSelectArea("AC9")
RecLock("AC9",.T.)
AC9_FILIAL	:= xFilial("AC9")
AC9_FILENT	:= xFilial("SC7")
AC9_ENTIDA	:= "SC7"
AC9_CODENT	:= xFilial("SC7")+cPedido+"0001"
AC9_CODOBJ	:= ACB->ACB_CODOBJ
MsUnLock()


RestArea( aArea )

Return .T.

//Renato Ruy - 01/08/16
//Marca/desmarca todos
Static Function CRPA31In(cMarca,cAlias,cCampo)

Local nReg := (cAlias)->(Recno())

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While !Eof()
	RecLock(cAlias,.F.)
	IF (cAlias)->&cCampo == cMarca
		(cAlias)->&cCampo := "  "
	Else
		(cAlias)->&cCampo := cMarca
	Endif
	(cAlias)->(MsUnlock())
	(cAlias)->(dbSkip())
Enddo

(cAlias)->(dbGoto(nReg))

oMark:oBrowse:Refresh(.T.)

Return

Static Function CRP31CAN()

nOpc := 2
If Type("oDlg") == "O"
	oDlg:End()
Endif

Return

/*
----------------------------------------------------------------------------
| Rotina    | CRPA031R     | Autor | Renato Ruy   	  | Data | 11.02.2016  |
|--------------------------------------------------------------------------|
| Descricao | Gera os dados levado em consideracao para o calculo          |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
User Function CRPA031R()

Local cFedera := ""
Local cCamp	  := ""
Local cPosto  := ""
Local cWhere  := ""
Local oDlg	  := ""

SZ3->(DbSetOrder(1))
SZ3->(DbSeek(xFilial("SZ3")+ZZ6->ZZ6_CODENT))

If SZ3->Z3_TIPENT $ "9"

	cCamp := ALLTRIM(SZ3->Z3_CODPAR) + IIf(!Empty(SZ3->Z3_CODPAR2),"," + AllTrim(SZ3->Z3_CODPAR2), "")

	//Busca os vinculos do posto
	If ZZ6->ZZ6_VALFED > 0

		If Select("TMPFED") > 0
			DbSelectArea("TMPFED")
			TMPFED->(DbCloseArea())
		EndIf

		If ZZ6->ZZ6_CODENT == "054404"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054404' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif ZZ6->ZZ6_CODENT == "054807"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054807' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif ZZ6->ZZ6_CODENT == "054595"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054595' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif ZZ6->ZZ6_CODENT == "054331"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054331' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif ZZ6->ZZ6_CODENT == "054419"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054419' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif ZZ6->ZZ6_CODENT == "054632"
			cWhere := "% Z6_CODCCR IN (SELECT Z3_CODENT FROM SZ3010 WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '054632' AND D_E_L_E_T_ = ' ') AND Z3_TIPENT = '9') AND %"
		Elseif  ZZ6->ZZ6_CODENT $ "054581/054730/054461/054578/075379"
			cWhere := "%  %"
		Else
			cWhere := "% Z6_CODCCR = '" + ZZ6->ZZ6_CODENT +"' AND %"
		Endif

		Beginsql Alias "TMPFED"
			SELECT Z6_CODENT FROM %Table:SZ6%
			WHERE
			Z6_FILIAL = %xFilial:SZ6% AND
			Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD% AND
			Z6_TPENTID = '8' AND
			%Exp:cWhere%
			%Notdel%
			GROUP BY Z6_CODENT
		Endsql

		While !TMPFED->(EOF())
			cFedera += Iif(!Empty(cFedera), ",", "" ) + TMPFED->Z6_CODENT
			TMPFED->(DbSkip())
		EndDo

	Endif

Elseif SZ3->Z3_TIPENT $ "2/5"

	If Select("TMPDES") > 0
		DbSelectArea("TMPDES")
		TMPDES->(DbCloseArea())
	EndIf

	If AllTrim(ZZ6->ZZ6_CODENT) $ "SINRJ/SIN/NOT/BR"
		BeginSql Alias "TMPDES"
			SELECT  Z3_CODENT
			FROM %Table:SZ3% SZ3
			JOIN %Table:SZ6% SZ6
			ON Z6_FILIAL = %xFilial:SZ6%
			AND Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD%
			AND Z6_TPENTID = '4'
			AND Z6_CODAC = %Exp:AllTrim(ZZ6->ZZ6_CODENT)%
			AND Z3_CODENT = Z6_CODCCR
			AND SZ6.%Notdel%
			WHERE
			Z3_FILIAL = %xFilial:SZ3% AND
			Z3_TIPENT = '9' AND
			Z3_ATIVO = 'N' AND
			SZ3.%Notdel%
			GROUP BY Z3_CODENT
		EndSql

		While !TMPDES->(EOF())
			cPosto += Iif(!Empty(cPosto), ",", "" ) + TMPDES->Z3_CODENT
			cCamp  += Iif(!Empty(cCamp),",","")+AllTrim(Posicione("SZ3",1,xFilial("SZ3")+ TMPDES->Z3_CODENT,"Z3_CODPAR")) +;
			 			Iif(!Empty(Posicione("SZ3",1,xFilial("SZ3")+ TMPDES->Z3_CODENT,"Z3_CODPAR2")),","+AllTrim(Posicione("SZ3",1,xFilial("SZ3")+ TMPDES->Z3_CODENT,"Z3_CODPAR2")),"")
			TMPDES->(DbSkip())
		EndDo
	Elseif AllTrim(ZZ6->ZZ6_CODENT) $ "FEN"
		cPosto := "054615"
	Endif

Elseif "1158" $ ZZ6->ZZ6_CODENT

	If Select("TMPICP") > 0
		DbSelectArea("TMPICP")
		TMPICP->(DbCloseArea())
	EndIf

	BeginSql Alias "TMPICP"
		SELECT  Z6_CODENT
		FROM %Table:SZ6% SZ6
		WHERE
		Z6_FILIAL = %xFilial:SZ6%
		AND Z6_PERIODO = %Exp:ZZ6->ZZ6_PERIOD%
		AND Z6_TPENTID = '7'
		AND Z6_CODAC = 'ICP'
		AND SZ6.%Notdel%
		GROUP BY Z6_CODENT
	Endsql

	While !TMPICP->(EOF())
		cCamp += Iif(!Empty(cCamp), ",", "" ) + AllTrim(TMPICP->Z6_CODENT)
		TMPICP->(DbSkip())
	EndDo
Elseif "46" $ ZZ6->ZZ6_CODENT
	cCamp := "156,2274,46"
Endif

//Gera tela com vinculos para o usuแrio.

//Cria uma Dialog
DEFINE MSDIALOG oDlg TITLE "RASTREAMENTO CALCULO PARCEIRO" From 9,0 To 250,550 PIXEL

@ 046,005 Say " PARCEIRO: " of oDlg Pixel
@ 043,055 MSGET (ZZ6->ZZ6_CODENT+" - "+ZZ6->ZZ6_DESENT) SIZE 220,11 OF oDlg PIXEL PICTURE "@!" WHEN .F.

@ 066,005 Say " CAMPANHA: " of oDlg Pixel
@ 063,055 MSGET cCamp SIZE 220,11 OF oDlg PIXEL PICTURE "@!" WHEN .T.

@ 086,005 Say " FEDERACAO: " of oDlg Pixel
@ 083,055 MSGET ALLTRIM(cFedera) SIZE 220,11 OF oDlg PIXEL PICTURE "@!" WHEN .T.

@ 106,005 Say " POSTO INATIVO: " of oDlg Pixel
@ 103,055 MSGET ALLTRIM(cPosto) SIZE 220,11 OF oDlg PIXEL PICTURE "@!" WHEN .T.

//Exibe a Dialog
ACTIVATE MSDIALOG oDlg CENTERED ON INIT	EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()})

Return

//--------------------------------------------------------------------------
// Rotina | C610FPagto  | Autor | Robson Gon็alves       | Data | 06/08/2015
//--------------------------------------------------------------------------
// Descr. | Rotina de consulta padrใo especํfica.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------
User Function C031PG2()
	Local cSQL := ''
	Local cTRB := ''
	Local nAchou := 0
	Local oPanelAll
	Local oPanelBot
	Local oDlg
	Local oLbx
	Local oConfirm
	Local oCancel
	Local nPos := 0
	Local lRet := .F.
	Local aFormapg := {}

	cSQL := "SELECT X5_DESCRI, X5_TABELA, X5_CHAVE "
	cSQL += "FROM   "+RetSqlName("SX5")+" SX5 "
	cSQL += "WHERE  X5_FILIAL = "+ValToSql(xFilial("SX5"))+" "
	cSQL += "       AND X5_TABELA = '24' "
	cSQL += "       AND SX5.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY X5_DESCRI "

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )

	While .NOT. (cTRB)->( EOF() )
		(cTRB)->( AAdd( aFormaPg, { X5_DESCRI, X5_TABELA, X5_CHAVE } ) )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )

	If Len( aFormaPg ) == 0
	   Help(' ',1,'REGNOIS')
	   Return( .F. )
	Endif


	nAchou := AScan( aFormaPg, {|fp| RTrim( fp[ 1 ] )==RTrim( cFormapg ) } )
	If nAchou == 0
		nAchou := 1
	Endif

	DEFINE MSDIALOG oDlg TITLE 'Selecione a Forma de Pagamento' FROM 0,0 TO 270,570 PIXEL
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 3,4 LISTBOX oLbx VAR nPos FIELDS HEADER 'Forma de pagamento' SIZE 355,80 OF oPanelAll PIXEL NOSCROLL
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aFormaPg )
	   oLbx:bLine:={||{ aFormaPg[ oLbx:nAt, 1 ] } }
	   oLbx:BlDblClick := {|| ( lRet:= .T., nPos := oLbx:nAt, oDlg:End() ) }

		If nAchou > 0
			oLbx:nAt := nAchou
		Endif

		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,202 BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION (lRet := .T., nPos := oLbx:nAt, oDlg:End())
		@ 1,245 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
	If lRet
 		cFormapg := aFormaPg[ nPos, 1 ]
 		SX5->( dbSetOrder( 1 ) )
 		SX5->( dbSeek( xFilial( 'SX5' ) + '24' + aFormaPg[ nPos, 3 ] ) )
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | CRPA035 | Autor | Renato Ruy                 | Data | 24/08/2016
//--------------------------------------------------------------------------
// Descr. | Chamado na fun็ใo CN120ITM, campos do GCT e gerar aprova็ใo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------
User Function CRPA035(ExpA2)
	Local nPed := 0

	Default ExpA2 := {}

	If Len(ExpA2) == 0
		RecLock("SC7",.F.)
			SC7->C7_COND := aRet2[1]
		SC7->(MsUnlock())
	Else
		For nPed := 1 To Len( ExpA2 )

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_APROV"}) == 0
				AAdd(ExpA2[nPed],{"C7_APROV",	Posicione('CTT',1, xFilial('CTT')+aRet2[3],'CTT_GARVAR')	, Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CCAPROV"}) == 0
				AAdd(ExpA2[nPed],{"C7_CCAPROV",aRet2[3], Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CC"}) == 0
				AAdd(ExpA2[nPed],{"C7_CC", aRet2[3] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XRECORR"}) == 0
				AAdd(ExpA2[nPed],{"C7_XRECORR", "2" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_APBUDGE"}) == 0
				AAdd(ExpA2[nPed],{"C7_APBUDGE", "1" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CTAORC"}) == 0
				AAdd(ExpA2[nPed],{"C7_CTAORC", aRet2[4] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_FORMPG"}) == 0
				AAdd(ExpA2[nPed],{"C7_FORMPG", aRet2[5] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_DOCFIS"}) == 0
				AAdd(ExpA2[nPed],{"C7_DOCFIS", aRet2[6] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XCONTRA"}) == 0
				AAdd(ExpA2[nPed],{"C7_XCONTRA", CND->CND_CONTRA , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_DESCRCP"}) == 0
				AAdd(ExpA2[nPed],{"C7_DESCRCP", "Remunera็ใo de Parceiros" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XJUST"}) == 0
				AAdd(ExpA2[nPed],{"C7_XJUST", "Remunera็ใo de Parceiros"  , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XOBJ"}) == 0
				AAdd(ExpA2[nPed],{"C7_XOBJ", "Remunera็ใo de Parceiros" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XADICON"}) == 0
				AAdd(ExpA2[nPed],{"C7_XADICON", "Remunera็ใo de Parceiros" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_COND"}) == 0
				AAdd(ExpA2[nPed],{"C7_COND", aRet2[1] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_XVENCTO"}) == 0
				AAdd(ExpA2[nPed],{"C7_XVENCTO", aRet2[7] , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_ITEMCTA"}) == 0
				AAdd(ExpA2[nPed],{"C7_ITEMCTA", "000000000" , Nil})
			EndIf

			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C7_CLVL"}) == 0
				AAdd(ExpA2[nPed],{"C7_CLVL", "000000000" , Nil})
			EndIf
		Next nPed
	Endif
Return( ExpA2 )
