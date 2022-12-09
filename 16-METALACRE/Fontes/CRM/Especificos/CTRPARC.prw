#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "TBICONN.CH"
#INCLUDE "rwmake.ch"  
#INCLUDE "Totvs.ch"
#Include "TOPCONN.CH" 
                                                                                                                              
#Define CRLF ( chr(13)+chr(10) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTRPARC  ºAutor  ³ Luiz Alberto      º Data ³  20/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Puxa Contrato de Parceria para o Call Center    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MetaLacre 				                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTRPARC()
Local aArea := GetArea()
Local lAchou:= .f.                            
Local cContrato	:= ''
Local cPerg	:= PadR('CTRPARC',10)

PutSx1(cPerg,"01","Cliente"		,"Cliente"		,"Cliente"		, "mv_ch1","C",06,0,0,"G","","SA1","","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Loja"			,"Loja"			,"Loja"			, "mv_ch2","C",02,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","","","","")

If !Pergunte(cPerg,.t.)
	Return .f.
Endif

// Efetua Limpeza do acols, se estiver alguma coisa preenchida então limpa e puxa os itens do contrato de parceria
	
If !SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+MV_PAR01+MV_PAR02))
	Alert("Cliente Não Localizado !!!")
	Return .f.
Endif

cCliente	:=	MV_PAR01
cLoja		:=	MV_PAR02

// Verifica se O Cliente Atual no Orçamento do Callcenter Possui Contrato de Parceria

If ADA->(dbSetOrder(2), dbSeek(xFilial("ADA")+cCliente+cLoja))
	While ADA->(!Eof()) .And. ADA->ADA_FILIAL == xFilial("ADA") .And. ADA->ADA_CODCLI == cCliente .And. ADA->ADA_LOJCLI == cLoja
		If !ADA->ADA_STATUS $ 'A*B*C'	// Status Aberto - Aprovado - Parcialmente Entregue
			ADA->(dbSkip(1));Loop
		Endif
		
		If (ADA->ADA_FILIAL == xFilial("ADA") .And. ADA->ADA_CODCLI == cCliente .And. ADA->ADA_LOJCLI == cLoja .And. ADA->ADA_STATUS $ 'A*B*C')
			cContrato	:= ADA->ADA_NUMCTR
			lAchou := .t.
			Exit
		Endif

		ADA->(dbSkip(1))
	Enddo
Endif
		
// Se Verdadeira então localizou contrato do cliente com status para atendimento

If lAchou
	If !MsgYesNo("Confirma a Geração de Atendimento de Contrato de Parceria ?") 
		RestArea(aArea)
		Return .f.     
	Endif
            
	lOk	:= .f.

	Begin Transaction
	
	DbSelectArea('SUA')
	If RecLock('SUA',.T.)
		SUA->UA_FILIAL 	:= xFilial('SUA')
		SUA->UA_NUM 	:= TkNumero('SUA','UA_NUM')
		SUA->UA_OPERADO := Posicione('SU7',4,xFilial('SU7')+__cUserID,'U7_COD')                                                
		SUA->UA_CLIENTE := SA1->A1_COD
		SUA->UA_LOJA 	:= SA1->A1_LOJA
		SUA->UA_XCLIENT	:= SA1->A1_COD
		SUA->UA_XLOJAEN	:= SA1->A1_LOJA
		SUA->UA_NOMECLI := SA1->A1_NOME
		SUA->UA_TMK 	:= '1'
		SUA->UA_OPER 	:= '2'
		SUA->UA_CLIPROS	:= '1'
		SUA->UA_DTLIM	:= dDataBase
		SUA->UA_ESPECI1	:= 'CAIXAS'
		SUA->UA_FECENT	:= dDataBase
		SUA->UA_VEND 	:= SA1->A1_VEND        
		SUA->UA_REGIAO	:= SA1->A1_REGIAO
		SUA->UA_MENNOTA	:= If(Empty(SA1->A1_SUFRAMA),"","COD. SUFRAMA: "+SA1->(ALLTRIM(A1_SUFRAMA)))                           
		SUA->UA_OBSCLI	:= ALLTRIM(SA1->A1_OBSERV)                                                                             
		SUA->UA_MENPAD	:= SA1->A1_MENSAGE                                                                                     
		SUA->UA_XMENNOT	:= iF(Empty(SA1->A1_SUFRAMA),"","COD. SUFRAMA: "+SA1->(ALLTRIM(A1_SUFRAMA)))                           
		SUA->UA_EMISSAO := dDatabase
		SUA->UA_CONDPG 	:= IIf(!Empty(SA1->A1_COND),SA1->A1_COND,SuperGetMv('MV_CONDPAD'))
		SUA->UA_STATUS 	:= 'SUP'
		SUA->UA_ENDCOB 	:= SA1->A1_ENDCOB
		SUA->UA_BAIRROC := SA1->A1_BAIRROC
		SUA->UA_CEPC 	:= SA1->A1_CEPC
		SUA->UA_MUNC 	:= SA1->A1_MUNC
		SUA->UA_ESTC 	:= SA1->A1_ESTC
		SUA->UA_ENDENT 	:= SA1->A1_ENDENT
		SUA->UA_BAIRROE := SA1->A1_BAIRROE
		SUA->UA_CEPE 	:= SA1->A1_CEPE
		SUA->UA_MUNE 	:= SA1->A1_MUNE
		SUA->UA_ESTE 	:= SA1->A1_ESTE
		SUA->UA_TRANSP 	:= SA1->A1_TRANSP
		SUA->UA_TPFRETE := SA1->A1_TPFRET
		SUA->UA_PROSPEC := .F.
		SUA->UA_NUMCTR  := ADA->ADA_NUMCTR
		SUA->UA_CTRMTL  := ADA->ADA_XCONTR

		cVend1 := SA3->A3_COD
		cVend2 := SA3->A3_SUPER
		cVend3 := SA3->A3_GEREN
		nComi1 := SA3->A3_COMIS
					
		If !Empty(cVend2)
			If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend2))
				nComi2 := SA3->A3_COMIS
			Endif
		Endif
		If !Empty(cVend3)
			If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+cVend3))
				nComi3 := SA3->A3_COMIS
			Endif
		Endif
									
		SUA->UA_VEND  := cVend1
		SUA->UA_COMIS := nComi1
		SUA->UA_VEND2 := cVend2
		SUA->UA_COMIS2:= nComi2
		SUA->UA_VEND3 := cVend3
		SUA->UA_COMIS3:= nComi3
		SUA->(MsUnlock())
	Endif
		
	// Gerando Indices
			
	If ADB->(dbSetOrder(1), dbSeek(xFilial("ADB")+cContrato))
		cItem	:= '01'

		While ADB->(!Eof()) .And. ADB->ADB_FILIAL == xFilial("ADB") .And. ADB->ADB_NUMCTR == ADA->ADA_NUMCTR
			SB1->(DbSeek(xFilial('SB1')+ADB->ADB_CODPRO))
			SF4->(DbSeek(xFilial('SB1')+ADB->ADB_TES))

			If (ADB->ADB_QUANT-(ADB->ADB_QTDEMP+ADB->ADB_QTDENT)) > 0
				If RecLock('SUB',.T.)
					SUB->UB_FILIAL 		:= xFilial("SUB")
					SUB->UB_ITEM 		:= ADB->ADB_ITEM
					SUB->UB_NUM 		:= SUA->UA_NUM
					SUB->UB_PRODUTO		:= ADB->ADB_CODPRO
					SUB->UB_QUANT 		:= (ADB->ADB_QUANT-(ADB->ADB_QTDEMP+ADB->ADB_QTDENT))
					SUB->UB_VRUNIT 		:= ADB->ADB_PRCVEN
					SUB->UB_VLRITEM		:= Round(ADB->ADB_PRCVEN * (ADB->ADB_QUANT-(ADB->ADB_QTDEMP+ADB->ADB_QTDENT)),2)
					SUB->UB_UM 			:= SB1->B1_UM
					SUB->UB_DTENTRE		:= ADB->ADB_DATA
					cTes := ADB->ADB_TES
					If !Empty(ADB->ADB_TESCOB) .And. Empty(ADB->ADB_PEDCOB)
						cTes := ADB->ADB_TESCOB
					Else
						cTes := ADB->ADB_TES
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o CFO                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+cTes))
					aDadosCFO := {}
				 	Aadd(aDadosCfo,{"OPERNF","S"})
				 	Aadd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
				 	Aadd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
				 	Aadd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
						
					cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
					SUB->UB_TES 		:= cTes
					SUB->UB_CF			:= cCfop
					SUB->UB_LOCAL 		:= ADB->ADB_LOCAL
					SUB->UB_PRCTAB 		:= ADB->ADB_PRCVEN
					SUB->UB_XLACRE		:= ADB->ADB_XLACRE
					SUB->UB_XEMBALA		:= ADB->ADB_XEMBAL
					SUB->UB_XVOLITE		:= ADB->ADB_XVOLIT     
					SUB->UB_XAPLICA		:= ADB->ADB_XAPLIC
					SUB->UB_OPC			:= ADB->ADB_OPC       
					SUB->UB_XSTAND		:= ADB->ADB_XSTAND 
					SUB->(MsUnlock())
				Endif
	        Endif
			
			ADB->(dbSkip(1))
		Enddo 
		
		lOk := .t.
		              
	Endif

	End Transaction
	
	If lOk
		MsgBox('Orçamento Criado com Sucesso ! No. ' + SUA->UA_NUM,'Contrato Parceria','INFO') //'Orcamento criado com Sucesso! No. '###'Geracao de Orcamentos'
	EndIf 	
Else
	Alert("Atenção Não Encontrado Contrato de Parceria para o Cliente Atual, Ou Contratos Já Atendidos Completamente !")
Endif

RestArea(aArea)
Return .t.