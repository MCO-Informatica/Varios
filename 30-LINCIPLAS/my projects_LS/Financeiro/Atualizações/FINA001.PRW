#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINA001  º Autor ³ Ricardo Felipelli  º Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Manutencao do Tabela SE5			                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Alterado Por: Vanilson ³  Incluido controle para movimentações prove-   ±±
±± 						  ³	 nientes de titulos Paga/Receber			   ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FINA001

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPrefixo
Private	cNumero
Private cParcela
Private	cTipo
Private	cFornece
Private	cLoja
Private	cTipoDoc
Private cAcres	 
Private cDecres
Private cPerg   := Padr("SE5010",len(SX1->X1_GRUPO)," ")
//cVldAlt := "U_VldAltE5()" //".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
//cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aRotina := {}
Private cString := "SE5"
Private cCadastro := "Corrige - SE5"

dbSelectArea("SE5")
dbSetOrder(1)

If !__cUserId $ GetMv("MV_USRCRE5") + GetMv('LA_PODER')
	MsgStop("Usuário sem permissão para utilizar a rotina!" + chr(13) + " Configure o parâmetro: MV_USRCRE5" )
	Return(.F.)
else
	Pergunte(cPerg,.F.)
	SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
	//AxCadastro(cString,"Movimentacao Bancaria - FINA001",cVldExc,U_VLDALTE5())
	AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'AxVisual',0,2})
	AADD( aRotina, {"Incluir" ,'msgbox("Opção indisponível,"ATENÇÃO!!!","ALERT")',0,3})
	AADD( aRotina, {"Alterar" ,'U_VldAltE5',0,4})
	AADD( aRotina, {"Excluir" ,'U_VldAltE5',0,5})
	If __cUserId $ GetMv('LS_GFISCAL')
		AADD( aRotina, {"Desmarc Contab" ,'U_F100Des',0,5})
	EndIf
	MBrowse(,,,,"SE5")
	Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
	
endif

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle para movimentações provenientes de titulos Paga/Receber  ³                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function F100Des()
RecLock('SE5',.f.)
SE5->E5_LA := ''
MsUnLock()

Return

User Function VldAltE5(cAlias, nReg, nOpc)
Local lRet    	:=  ".T."

If alltrim(SE5->E5_LA) == 'S'
	MsgAlert("Lançamento já sofreu contabilização, não pode ser alterado." + _cEnter + "Entre em contato com Depto de Contabilidade.")
	Return(.F.)
EndIf

If SE5->E5_DATA < GetMv('MV_DATAFIN')
	MsgAlert("Data do lançamento não permite mais alterações.' + _cEnter + 'Parâmetro MV_DATAFIN = " + dtoc(GetMv('MV_DATAFIN')))
	Return(.F.)
EndIf

cPrefixo := SE5->E5_PREFIXO
cNumero  := SE5->E5_NUMERO
cCnab	 := SE5->E5_ARQCNAB
cParcela := SE5->E5_PARCELA
cTipo	 := SE5->E5_TIPO
cFornece :=	SE5->E5_FORNECEDOR
cLoja	 := SE5->E5_LOJA
cTipoDoc := SE5->E5_TIPODOC //Incluido Sidney - Supertech
cAcres	 := SE5->E5_VLACRES //Incluido Sidney - Supertech
cDecres	 := SE5->E5_VLDECRE //Incluido Sidney - Supertech
If nOpc == 4
	AxAltera(cAlias, nReg, nOpc)
Else
	AxDeleta(cAlias, nReg, nOpc)
EndIf

Return(lRet)

If SE5->E5_RECPAG == "P"
	
	DBSelectArea("SE2")
	DBSetOrder(1)
	If DBSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
		MsgInfo("Esta movimentação não pode ser Alterada/Excluída, pois possui um titulo no Contas a Pagar: " + char(13) + char(13) +"PREFIXO: " + cPrefixo + char(13) + "NUMERO: " + cNumero + char(13) + "PARCELA: " + cParcela)
	Else
		If nOpc == 4
			AxAltera(cAlias, nReg, nOpc)
		Else
			AxDeleta(cAlias, nReg, nOpc)
		EndIf
	Endif
Else
	DBSelectArea("SE1")
	DBSetOrder(1)
	If DBSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)  .AND. cCnab == ''
		MsgInfo("Esta movimentação não pode ser Alterada/Excluída, pois possui um titulo no Contas a Receber: " + char(13) + char(13) + "PREFIXO: " + cPrefixo + char(13) + "NUMERO: " + cNumero + char(13) + "PARCELA: " + cParcela)
	Else
		If nOpc == 4
			AxAltera(cAlias, nReg, nOpc)
		Else
			AxDeleta(cAlias, nReg, nOpc)
		EndIf
	EndIf
EndIf

Return lRet