#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'    
#INCLUDE "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function RCmpPreco()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
nTamanho    := "M"
nLimite     := 80
cTitulo     := "Relatorio Comparativo Precos"
cDesc1      := "Este Programa Emitira o Relatorio Comparativo Precos"
cDesc2      := ""
cDesc3      := ""
cbCont      := 0
cbTxt       := ""
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "RCMPP"
cPerg       := "RCMPP"
lContinua   := .t.
li          := 60
wnrel       := "RCMPP"
cString     := "SUB"
nLastKey    := 0
m_Pag       := 1
tamanho          := "G"
lAbortPrint := .f.
aOrd := {}

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
If cEmpAnt <> '01'	// Apenas Metalacre
	Alert("Atencao este relatorio só podera ser emitido na empresa 01")
	Return .f.
Endif
	

ValidPerg()

Pergunte( cPerg, .f. )

wnrel := "RCMPP"
wnrel := SetPrint(cString,NomeProg,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Imprime)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()
Local cTabPadrao:=  GetMV("MV_TBQPAD")
Local nDscCEsp	:=  SuperGetMV("MV_MTLDSC", ,70)	// Desconto Cliente Especial - Exemplo METALSEAL
Local cDscCli	:=  GetNewPar("MV_MTLDCL",'00132001*01140401')	// Clientes Especiais - Exemplo METALSEAL

cabec1  := "Numero  Numero   Data      Tabela  Cliente                           Vendedor(a)   Produto     Descricao                          Opcional     Qtde         Unit     (%)Tamanho     Preço Tabela      Diferenca"
cabec2  := "Orcto.  Pedido   Emissao                                                              "
//          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//			99/99/9999 999999/99 LUIZ ALBERTO V ALVES  9999 ANGELIA JOLIE LINDA   99/99/9999  99/99/9999  Sim  Nao  Sim   99/99/9999 9999999999 
//																								      99.999,99  99.999,99
//                    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21

nTipo   := Iif(aReturn[4]==1,15,18)

//----> IMPRIME PELA EMISSAO
cTitulo := cTitulo

// Tratamento do Parametro de Status de Aula

cQuery := 	 " SELECT UA_NUM, UA_NUMSC5, UA_EMISSAO, UA_CLIENTE, UA_LOJA, UA_VEND, UA_TBMTL, UB_PRODUTO, UB_XLACRE, UB_QUANT, UB_VRUNIT, UB_VLRITEM, UB_OPC, UB_PEROPC, UB_PERCLES "
cQuery +=	 " FROM " + RetSqlName("SUA") + " SUA, " + RetSqlName("SUB") + " SUB "
cQuery +=	 " WHERE UA_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
cQuery +=	 " AND UA_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery +=	 " AND UA_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' "
cQuery +=	 " AND UA_LOJA BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR08 + "' "
cQuery +=	 " AND UB_PRODUTO BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
If MV_PAR11 == 1
	cQuery +=	 " AND UA_NUMSC5 = '' "	// Só Orçamento
ElseIf MV_PAR11 == 2
	cQuery +=	 " AND UA_NUMSC5 <> '' "	// Só Orçamento
Endif	
cQuery +=	 " AND UA_NUM = UB_NUM "
cQuery +=	 " AND UA_FILIAL = '" + xFilial("SUA") + "' "
cQuery +=	 " AND UB_FILIAL = '" + xFilial("SUB") + "' "
cQuery +=	 " AND UA_CANC <> 'S' "	
cQuery +=	 " AND UA_CLIPROS = '1' "
cQuery +=	 " AND SUA.D_E_L_E_T_ = '' "
cQuery +=	 " AND SUB.D_E_L_E_T_ = '' "
cQuery +=	 " ORDER BY UA_VEND, UA_EMISSAO, UA_NUM, UB_PRODUTO "
	
TCQUERY cQuery NEW ALIAS "KAD"
Count To nReg              

TcSetField('KAD',"UA_EMISSAO","D")

ProcRegua(nReg)
dbSelectArea("KAD")
DbGoTop()

aTotais := {0,0,0,0}

While KAD->(!Eof())
	IncProc("Processando as Vendas...")

	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua   :=  .f.
		Exit
	EndIf
	
	//-- Executa a validacao do filtro do usuario
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSkip()
		Loop
	EndIf
	
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+KAD->UA_CLIENTE+KAD->UA_LOJA))
	SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+KAD->UA_VEND))
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+KAD->UB_PRODUTO))

	// Consulta Estrutura de Produtos para ver se o produto atual tem opcionais
		
	nPerc := 0.00	// Percentual de Grupo de Opcionais Padrao
	
	aAreaSG1 := GetArea()
		
	cQuery := 	 " SELECT TOP 1 R_E_C_N_O_ REG "
	cQuery +=	 " FROM " + RetSqlName("SG1") + " SG1 (NOLOCK) "
	cQuery +=	 " WHERE  "
	cQuery +=	 " G1_FILIAL = '" + xFilial("SG1") + "' "
	cQuery +=	 " AND SG1.D_E_L_E_T_ = '' "      
	cQuery +=	 " AND SG1.G1_COD = '" + KAD->UB_PRODUTO + "' "
	cQuery += 	 " AND G1_OPC = '" + AllTrim(SubStr(KAD->UB_OPC,4,4)) + "' "  // VERIFICA SE TEM ALGUM COMPRIMENTO
	cQuery +=	 " ORDER BY G1_OPC "       //
				
	TCQUERY cQuery NEW ALIAS "CHK1"
		
	SG1->(dbGoTo(CHK1->REG))
		
	CHK1->(dbCloseArea())
	RestArea(aAreaSG1)       
		
	nPerc := SG1->G1_PERC
	_nQtdVen	:= KAD->UB_QUANT
	nPrcTab := 0.00

	cTabela := Iif(Empty(KAD->UA_TBMTL),cTabPadrao,KAD->UA_TBMTL)

    // Busca Valor do Produto com Base na Quantidade Tabela de Preços Quantidades
	
	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabela+KAD->UB_PRODUTO))
		If _nQtdVen <= 1000
			nPrcTab := SZ8->Z8_P00500
		ElseIf _nQtdVen >= 1001 .And. _nQtdVen <= 5000
			nPrcTab := SZ8->Z8_P03000
		ElseIf _nQtdVen >= 5001 .And. _nQtdVen <= 10000
			nPrcTab := SZ8->Z8_P05000
		ElseIf _nQtdVen >= 10001 .And. _nQtdVen <= 50000
			nPrcTab := SZ8->Z8_P20000
		ElseIf _nQtdVen >= 50001// .And. _nQtdVen <= 30000
			nPrcTab := SZ8->Z8_P20001
		Else
			nPrcTab := _nPrcVen
		Endif			

		nPerc := Iif(!Empty(KAD->UB_PEROPC),KAD->UB_PEROPC,nPerc)	// Se Possuir % Opcionais Gravado entao considera
		nDscCesp := Iif(!Empty(KAD->UB_PERCLES),KAD->UB_PERCLES,nDscCesp)	// se possuir Desconto Cliente Especial então considera

		If !Empty(nPerc)
			nPerc := ((nPerc/100)+1)
			nPrcTab := Round((nPrcTab * nPerc),2)
		Endif

		// Tratamento de Desconto para Clientes Especiais Exemplo: MetalSeal

		If SA1->A1_COD+SA1->A1_LOJA $ cDscCli
			nPrcTab := Round((nPrcTab * (nDscCesp/100)),2)
		Endif
	Endif

	If Li > 55
		Cabec(cTitulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf

	@ li, 000  PSAY KAD->UA_NUM
	@ li, 008  PSAY KAD->UA_NUMSC5
	@ li, 017  PSAY DtoC(KAD->UA_EMISSAO)
	@ li, 028  PSAY KAD->UA_TBMTL
	@ li, 035  PSAY SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+Left(SA1->A1_NOME,20)
	@ li, 068  PSAY Left(SA3->A3_NOME,10)
	@ li, 082  PSAY SB1->B1_COD
	@ li, 095  PSAY Left(SB1->B1_DESC,30)
	@ li, 130  PSAY KAD->UB_OPC
	@ li, 142  PSAY TransForm(KAD->UB_QUANT,"@E 999,999.999")
	@ li, 155  PSAY TransForm(KAD->UB_VRUNIT,"@E 99,999.999")
	@ li, 168  PSAY TransForm(nPerc,"@E 999.99")
	@ li, 185  PSAY TransForm(nPrcTab,"@E 99,999.999")
	@ li, 200  PSAY TransForm(Round(KAD->UB_VRUNIT-nPrcTab,2),"@E 99,999.999")

	li++
	
	DbSelectArea("KAD")
	KAD->(DbSkip())
EndDo

Roda(cbCont,cbTxt,nTamanho)

KAD->(dbCloseArea())

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf

Ms_Flush()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do Grupo de Perguntas                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
_aArea := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PadR(cPerg,10)

aRegs :={}
Aadd(aRegs,{cPerg,"01","Emissao de              ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Emissao Ate             ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Vendedor de             ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA3",""})
Aadd(aRegs,{cPerg,"04","Vendedor Ate            ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA3",""})
Aadd(aRegs,{cPerg,"05","Cliente de              ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"06","Loja de                 ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Cliente Ate             ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"08","Loja Ate                ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Produto de              ?","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"10","Produto Ate             ?","mv_chA","C",15,0,0,"G","","mv_par10","","","","","","","","","","","","","","","SB1",""})
Aadd(aRegs,{cPerg,"11","Status Orçamento        ?","mv_chB","N",01,0,3,"C","","mv_par11","Aberto","","","Pedido","","","Ambos","","","","","","","","",''})

For i := 1 To Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := aRegs[i,01]
		SX1->X1_ORDEM   := aRegs[i,02]
		SX1->X1_PERGUNT := aRegs[i,03]
		SX1->X1_VARIAVL := aRegs[i,04]
		SX1->X1_TIPO    := aRegs[i,05]
		SX1->X1_TAMANHO := aRegs[i,06]
		SX1->X1_DECIMAL := aRegs[i,07]
		SX1->X1_PRESEL  := aRegs[i,08]
		SX1->X1_GSC     := aRegs[i,09]
		SX1->X1_VALID   := aRegs[i,10]
		SX1->X1_VAR01   := aRegs[i,11]
		SX1->X1_DEF01   := aRegs[i,12]
		SX1->X1_CNT01   := aRegs[i,13]
		SX1->X1_VAR02   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,15]
		SX1->X1_CNT02   := aRegs[i,16]
		SX1->X1_VAR03   := aRegs[i,17]
		SX1->X1_DEF03   := aRegs[i,18]
		SX1->X1_CNT03   := aRegs[i,19]
		SX1->X1_VAR04   := aRegs[i,20]
		SX1->X1_DEF04   := aRegs[i,21]
		SX1->X1_CNT04   := aRegs[i,22]
		SX1->X1_VAR05   := aRegs[i,23]
		SX1->X1_DEF05   := aRegs[i,24]
		SX1->X1_CNT05   := aRegs[i,25]
		SX1->X1_F3      := aRegs[i,26]    
		SX1->X1_VALID	:= aRegs[i,27]
		MsUnlock()
		DbCommit()
	Endif
Next

RestArea(_aArea)

Return()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

