#Include "Rwmake.ch"                                                    
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+-----------------+-------+------------+
| Programa:  | VGENM01 | Autor: | Silvério Bastos | Data: | Março/2010 |
+------------+---------+--------+-----------------+-------+------------+
| Descrição: | Gera Pedidos de Vendas a partir do Saldo em Estoque     |
+------------+---------------------------------------------------------+              
| Uso:       | Verion Óleo Hidráulica Ltda.                            |
+------------+---------------------------------------------------------+
*/

User Function VGEM01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea:=GetArea()
Private oLeTxt                 
Private cString := "SB2"
Private cPerg   := "RVGEM00001"
PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1()
pergunte(cPerg,.t.)

/*
+-----------------------------------------------+
| Variáveis de Usuário Utilizadas em Parâmetros |
+----------+------------------------------------+
| mv_par01 | Produto Inicial             ?      |
| mv_par02 | Produto Final               ?      |
| mv_par03 | Grupo Inicial               ?      |
| mv_par04 | Grupo Final                 ?      |
+----------+------------------------------------+
*/

dbSelectArea("SB2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000,000 TO 160,550 DIALOG oLeTxt TITLE "Geracao Automatica dos Pedidos pelo Saldo do Estoque"
@ 002,001 Say " Este programa ira gerar pedidos automaticamente, conforme os parametros definidos pelo usuario."
@ 045,117 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 045,145 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  23/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  23/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nZ     := 0
Local cDoc   := ""
Local lOk    := .T.
PRIVATE lMsErroAuto := .F.

// +------------------------------------------------------------------------+
// | Monta uma Select na tabela SB2, para levantar os Itens a serem gerados |
// +------------------------------------------------------------------------+

DbSelectArea("SB2")

_cQrySB2	:= "SELECT B2_COD, B2_LOCAL, B2_QATU, B1_COD, B1_GRUPO, B1_UM  "
_cQrySB2	+= " FROM " + RetSqlName("SB2")+" AS B2 " 
_cQrySB2	+= " Inner Join " + retsqlname("SB1") + " AS B1 ON B1_COD = B2_COD AND B1.D_E_L_E_T_ <> '*' "
_cQrySB2	+= " WHERE B2_QATU > 0 AND B2.D_E_L_E_T_ <> '*' "
_cQrySB2	+= " AND B2_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQrySB2	+= " AND B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
  
If Select("SB2SQL") > 0
	SB2SQL->(DbCloseArea())
Endif   

TCQUERY _cQrySB2 NEW ALIAS "SB2SQL"

DbSelectArea("SB2SQL")

SB2SQL->(DbGoTop())

Do While SB2SQL->(!Eof())

		// +----------------------------------------------------------------------------+
		// | Monta uma select na tabela SC6, para verificação se o Pedido já foi gerada |
		// +----------------------------------------------------------------------------+

		DbSelectArea("SC6")
		DbGoTop()

		_cQrySC6	:= "Select C6_PRODUTO, C6_TES "
		_cQrySC6	+= " FROM " + RetSqlName("SC6") + " AS C6 " 
		_cQrySC6	+= "Inner Join " + RetSqlName("SB1") + " As B1 ON B1.B1_COD = C6.C6_PRODUTO And B1.D_E_L_E_T_ <> '*' "
		_cQrySC6	+= "Where C6.C6_TES = '631' And C6.D_E_L_E_T_ <> '*' "
		_cQrySC6	+= "And C6.C6_PRODUTO = '" + SB2SQL->B2_COD + "' "
  
		If Select("SC6Q") > 0
			SC6Q->(DbCloseArea())
		EndIf

		TcQuery _cQrySC6 New Alias "SC6Q"

		DbSelectArea("SC6Q")
		DbGoTop() 

		If SB2SQL->B2_COD == SC6Q->C6_PRODUTO
			nZ += 1
		EndIf

		SB2SQL->(dbSkip())
Enddo

SB2SQL->(DbGoTop())

ProcRegua(SB2SQL->(RecCount()))

Do While SB2SQL->(!Eof()) 

		IncProc("Gerando Pedido...")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos obtidos da query do SB2 e SB1. 						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
		ConOut("Inicio: " + Time())

		cDoc	:= GetSxeNum("SC5","C5_NUM")
		cCli 	:= "000443"
		cTes	:= "631"
		cCpg	:= "051"
		cLoj	:= "01"
		cDat	:= dDatabase             
		cVde	:= "000039"
		cTrp	:= "000487"
		cVkg	:= "N"
		nX		:= 0

		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4") + cTes,.f.)
	
		cCf := SF4->F4_CF

		// +----------------------------------------------------------------------------+
		// | Monta uma select na tabela SC6, para verificação se o Pedido já foi gerada |
		// +----------------------------------------------------------------------------+

		DbSelectArea("SC6")
		DbGoTop()

		_cQrySC6	:= "Select C6_PRODUTO, C6_TES "
		_cQrySC6	+= " FROM " + RetSqlName("SC6") + " AS C6 " 
		_cQrySC6	+= "Inner Join " + RetSqlName("SB1") + " As B1 ON B1.B1_COD = C6.C6_PRODUTO And B1.D_E_L_E_T_ <> '*' "
		_cQrySC6	+= "Where C6.C6_TES = '631' And C6.D_E_L_E_T_ <> '*' "
		_cQrySC6	+= "And C6.C6_PRODUTO = '" + SB2SQL->B2_COD + "' "
  
		If Select("SC6Q") > 0
			SC6Q->(DbCloseArea())
		EndIf

		TcQuery _cQrySC6 New Alias "SC6Q"

		DbSelectArea("SC6Q")
		DbGoTop() 

		If SB2SQL->B2_COD == SC6Q->C6_PRODUTO

			DbSelectArea("SB2SQL")
			RollBAckSx8()
			aCabec := {}
			aItens := {}
			aadd(aCabec,{"C5_NUM"    ,cDoc,Nil})
			aadd(aCabec,{"C5_TIPO"   ,"N" ,Nil})
			aadd(aCabec,{"C5_CLIENTE",cCli,Nil})
			aadd(aCabec,{"C5_LOJACLI",cLoj,Nil})
			aadd(aCabec,{"C5_CLIENT" ,cCli,Nil})
			aadd(aCabec,{"C5_LOJAENT",cLoj,Nil})
			aadd(aCabec,{"C5_TIPOCLI","R" ,Nil})
			aadd(aCabec,{"C5_CONDPAG",cCpg,Nil})
			aadd(aCabec,{"C5_EMISSAO",cDat,Nil})
			aadd(aCabec,{"C5_VEND1"  ,cVde,Nil})
			aadd(aCabec,{"C5_TRANSP" ,cTrp,Nil})
			aadd(aCabec,{"C5_VKGFAT" ,cVkg,Nil})

			For nX := 1 To nZ

				If nX <=11
					aLinha := {}
					aadd(aLinha,{"C6_ITEM"   ,StrZero(nX,2)      ,Nil})
					aadd(aLinha,{"C6_PRODUTO",SB2SQL->B2_COD     ,Nil})
					aadd(aLinha,{"C6_UM"     ,SB2SQL->B1_UM      ,Nil})
					aadd(aLinha,{"C6_QTDVEN" ,SB2SQL->B2_QATU    ,Nil})
					aadd(aLinha,{"C6_PRCVEN" ,1                  ,Nil})
					aadd(aLinha,{"C6_VALOR"  ,SB2SQL->B2_QATU * 1,Nil})
					aadd(aLinha,{"C6_QTDLIB" ,SB2SQL->B2_QATU    ,Nil})
					aadd(aLinha,{"C6_LOCAL"  ,SB2SQL->B2_LOCAL   ,Nil})
					aadd(aLinha,{"C6_CF"     ,cCf                ,Nil})
					aadd(aLinha,{"C6_TES"    ,cTes               ,Nil})
					aadd(aLinha,{"C6_CLI"    ,cCli               ,Nil})
					aadd(aLinha,{"C6_LOJA"   ,cLoj               ,Nil})
					aadd(aItens,aLinha)

					SB2SQL->(dbSkip())
				EndIf

		 		Next nX
        
        Else
     
        	SB2SQL->(dbSkip())
     
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Inclusao do Pedido                                           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		MATA410(aCabec,aItens,3)

		DbSelectArea("SB2SQL")
Enddo

/*
If !lMsErroAuto
	alert("Pedido Incluido com sucesso! "+cDoc)
Else
   alert("Erro na inclusao!")
EndIf
*/

ConOut("Fim  : "+Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechando o dialogo criado na funcao anterior.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Close(oLeTxt)

Alert(" Pedido Gerado com Sucesso !!! ")

Return                            

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  AjustaSX1   ³ Autor ³ Silverio Bastos 		³ Data ³ 23/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica as perguntas inclu¡ndo-as caso n„o existam            ³±±                                                            ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Verion                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aPergs:={},g,h
Local aArea:=GetArea()

Aadd(aPergs,{cPerg,"01","Produto Inicial   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
Aadd(aPergs,{cPerg,"02","Produto Final     ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1"})
Aadd(aPergs,{cPerg,"03","Grupo Inicial     ?","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
Aadd(aPergs,{cPerg,"04","Grupo Final       ?","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM"})

DbSelectArea("SX1")

For g:=1 to Len(aPergs)

	If !(dbSeek(ALLTRIM(cPerg)+aPergs[g][2]))

		RecLock("SX1",.T.)

		For h:=1 to len(aPergs[g])
			FieldPut(h,aPergs[g][h])
		Next

		MsUnlock()
	EndIf    

Next

RestArea(aArea)

Return(.T.)