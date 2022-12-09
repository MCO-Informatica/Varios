#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sd3250i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREAANT,_CDIR,_CFILE,_CINDICE,_NITEM,_AAREASB1")
SetPrvt("_AAREASZ1,_AAREASZ8,_AAREASB8,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SD3250I  ³ Autor ³ Sergio Oliveira       ³ Data ³02/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Etiqueta de Codigo de Barras no Apontamento Producao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jefferson     ³17/04/04³Geracao do Pedido de Venda Automatico para 3§s ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aAreaANT := GetArea()
_nItem    := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


DbSelectArea("SB1")
_aAreaSB1   :=  GetArea()
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

//----> VERIFICA SE PRODUTO E RASTREADO OU QUANTIDADE IGUAL A ZERO OU ORDEM DE PRODUCAO E TECELAGEM
If SB1->B1_RASTRO != "L" .Or. SD3->D3_QUANT == 0 .Or. SC2->C2_TIPO $ "50/60"
 
    //----> RESTAURA AREA SB1
    RestArea(_aAreaSB1)

    //----> RESTAURA AREA ANTERIOR
    RestArea(_aAreaANT)

    Return     
EndIf

DbSelectArea("SZ1")
_aAreaSZ1   :=  GetArea()
DbSetOrder(1)
DbSeek(xFilial("SZ1")+Iif(Subs(SD3->D3_COD,1,3) $ "109/110", Subs(SD3->D3_COD,4,3), Subs(SD3->D3_COD,1,3)),.F.)

/*
DbSelectArea("SZ8")
_aAreaSZ8   :=  GetArea()
DbSetOrder(1)
DbSeek(xFilial("SZ8")+Iif(Subs(SD3->D3_COD,1,3) $ "109/110", Subs(SD3->D3_COD,4,3), Subs(SD3->D3_COD,1,3)),.F.)
*/

DbSelectArea("SZ3")
RecLock("SZ3",.T.)
SZ3->Z3_LOTE    := "00"+SD3->D3_LOTECTL      
SZ3->Z3_QUANTID := SD3->D3_QUANT
SZ3->Z3_UM      := SD3->D3_UM
SZ3->Z3_LARGURA := SB1->B1_X_LARG
SZ3->Z3_DESCRI  := SB1->B1_DESC
SZ3->Z3_COMP    := SB1->B1_X_COMP   
SZ3->Z3_ORDEM   := Subs(SD3->D3_COD,1,3)
SZ3->Z3_ARTIGO  := Subs(SD3->D3_COD,1,3)+Subs(SD3->D3_COD,7)
SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
SZ3->Z3_COR     := Subs(SD3->D3_COD,4,3)
SZ3->Z3_PARTIDA := Subs(SD3->D3_OP,1,6)
SZ3->Z3_SAIDA   := "E" // Quantidade de Entrada
SZ3->Z3_COPIAS  := 1                                 
SZ3->Z3_DOC     := Subs(SD3->D3_OP,1,6)
SZ3->Z3_REVISOR := SD3->D3_REVISOR         
SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_COD"),"")
SZ3->Z3_NOME	:= IIF(SB1->B1_TIPO$"TT",Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL"),"")
SZ3->Z3_CNPJ	:= IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_CGC"),"")

MsUnLock()


//----> GRAVA NOTA DE TERCEIROS NO LOTE
dbSelectArea("SB8")
_aAreaSB8   :=  GetArea()
dbSetOrder(3)
If dbSeek(xFilial("SB8")+SD3->(D3_COD+D3_LOCAL+D3_LOTECTL),.f.)
    While SB8->(B8_PRODUTO+B8_LOCAL+B8_LOTECTL) == SD3->(D3_COD+D3_LOCAL+D3_LOTECTL)
        dbSelectArea("SB8")
        RecLock("SB8",.f.)
        SB8->B8_NF_TERC     :=  SC2->C2_NF_TERC
        MsUnLock()
        dbSkip()
    EndDo
EndIf


//----> GRAVA O CUSTO DA OP NA TABELA DE PRECO DE TERCEIROS
cOp			:=	SD3->D3_OP
dData		:=	SD3->D3_EMISSAO
nTotCusto 	:= 	0
nQtdeProd	:= 	0
nQtd2Prod	:= 	0
cProdSD3	:=	SD3->D3_COD
cServSD3	:=	Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_TIPO")

dbSelectArea("SD3")
_aAreaSD3	:=	GetArea()
dbSetOrder(13)
If dbSeek(xFilial("SD3")+cOp,.f.)

	While !Eof() .AND. SD3->D3_FILIAL+SD3->D3_OP == xFilial("SD3")+cOp
		
        dbSelectArea("SB1")
        dbSetOrder(1)
        dbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

        If SB1->B1_TIPO $ "KC TC"
            dbSelectArea("SD3")
            dbSkip()
            Loop
        EndIf

		If SD3->D3_ESTORNO == "S"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SD3")
    
        nTotCusto   := nTotCusto + IIf( SubStr(D3_CF,1,2) == "RE",  (SD3->D3_QUANT * SB1->B1_CUSTD), 0 )
        nTotCusto   := nTotCusto + IIf( SubStr(D3_CF,1,2) == "DE", -(SD3->D3_QUANT * SB1->B1_CUSTD), 0 )
		
        nQtdeProd   := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "PR", D3_QUANT , 0 )
        nQtdeProd   := nQtdeProd + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QUANT , 0 )

        nQtd2Prod   := nQtd2Prod + IIf( SubStr(D3_CF,1,2) == "PR", D3_QTSEGUM , 0 )
        nQtd2Prod   := nQtd2Prod + IIf( SubStr(D3_CF,1,2) == "ER", -D3_QTSEGUM , 0 )

		dbSelectArea("SD3")
		dbSkip()
	 		    
	EndDo

	If nTotCusto > 0
		dbSelectArea("SZC")
		_aAreaSZC	:=	GetArea()
		dbSetOrder(2)
		If dbSeek(xFilial("SZC")+cProdSD3+cServSD3,.f.)
			RecLock("SZC",.f.)
			SZC->ZC_CUSTO	:=	Iif(SZC->ZC_TIPCOB$"M",nTotCusto / nQtdeProd, nTotCusto/ nQtd2Prod)
			SZC->ZC_OP		:=	Subs(cOp,1,6)
			SZC->ZC_DATAOP	:=	dData
			MsUnLock()
		EndIf
		//----> RESTAURA AREA SZC 
		RestArea(_aAreaSZC)
    EndIf
EndIf


//----> RESTAURA AREA SB1
RestArea(_aAreaSB1)

//----> RESTAURA AREA SB8
RestArea(_aAreaSB8)

//----> RESTAURA AREA SZ1
RestArea(_aAreaSZ1)

//----> RESTAURA AREA SD3
RestArea(_aAreaSD3)

//----> RESTAURA AREA ANTERIOR
RestArea(_aAreaANT)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

