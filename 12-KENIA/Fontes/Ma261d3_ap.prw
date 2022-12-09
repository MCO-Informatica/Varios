#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ma261d3()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NSALDO,_NACHOU,_AAREA,_CDIR,_CFILE,_CINDICE")
SetPrvt("_CREGSB1,_CINDSB1,_CREGSD3,_CINDSD3,_CREGSB8,_CINDSB8")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA261D3  ³ Autor ³ Sergio Oliveira       ³ Data ³23/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Etiqueta Codigo Barras na Inclusao de Transferencias  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_nSaldo   := 0
_nAchou   := 0
_aArea    := GetArea()
_cDir     := "\SYSTEM\ETIQUETA\"
_cFile    := "Z3.DBF"
_cIndice  := _cDir+"Z3"  
_aAreaSB1 := SB1->(GetArea())
_aAreaSD3 := SD3->(GetArea())
_aAreaSB8 := SB8->(GetArea())

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+ACOLS[PARAMIXB,1],.F.)

If SB1->B1_RASTRO != "L"

    RestArea(_aAreaSB1)
    RestArea(_aAreaSB8) 
    RestArea(_aAreaSD3)
	
	RestArea(_aArea)
	
	Return
EndIf

/*
DbSelectArea("SB8")
DbSetOrder(3)
DbSeek(xFilial("SB8")+aCols[PARAMIXB,1]+aCols[PARAMIXB,4]+aCols[PARAMIXB,12],.F.)

While !Eof() .and. SB8->B8_FILIAL  == xFilial("SB8")  .and.;
	SB8->B8_PRODUTO == ACOLS[PARAMIXB,1] .and.;
	SB8->B8_LOCAL   == ACOLS[PARAMIXB,4] .and.;
	SB8->B8_LOTECTL == aCols[PARAMIXB,12]
	
	_nSaldo := _nSaldo + SB8->B8_SALDO
	
	DbSkip()
End

If _nSaldo > 0
*/
	
	
	DbSelectArea("SD3")
	DbSetOrder(14)
	DbSeek(xFilial("SD3")+aCols[PARAMIXB,1]+aCols[PARAMIXB,4]+aCols[PARAMIXB,12]+"001"+"PR0",.f.)
	
	RecLock("SZ3",.T.)
	SZ3->Z3_LOTE    := "00"+aCols[PARAMIXB,12]
	SZ3->Z3_QUANTID := aCols[PARAMIXB,16]  //_nSaldo
	SZ3->Z3_DESCRI  := aCols[PARAMIXB,2]
	SZ3->Z3_COMP    := SB1->B1_X_COMP
	SZ3->Z3_ORDEM   := Subs(aCols[PARAMIXB,1],1,3)
	SZ3->Z3_ARTIGO  := Subs(aCols[PARAMIXB,1],1,3)+Subs(aCols[PARAMIXB,1],7)
	SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
	SZ3->Z3_COR     := Subs(aCols[PARAMIXB,1],4,3)
	SZ3->Z3_PARTIDA := Subs(SD3->D3_OP,1,6)
	SZ3->Z3_SAIDA   := "S"  //"R" // Quantidade de Saldo
	SZ3->Z3_COPIAS  := 1
	SZ3->Z3_DOC     := cDocumento
	SZ3->Z3_UM      := aCols[PARAMIXB,3]
	SZ3->Z3_LARGURA := SB1->B1_X_LARG
	SZ3->Z3_REVISOR := SD3->D3_REVISOR
	SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_COD"),"")
	SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL"),"")
	SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_CGC"),"")
	MsUnLock()
	
//Else

	//DbSelectArea("SD3")
	//DbSetOrder(14)
	//DbSeek(xFilial("SD3")+aCols[PARAMIXB,1]+aCols[PARAMIXB,4]+aCols[PARAMIXB,12]+"001"+"PR0",.f.)
	
	RecLock("SZ3",.T.)
	SZ3->Z3_LOTE    := if(!empty(aCols[PARAMIXB,20]),"00"+aCols[PARAMIXB,20],"00"+aCols[PARAMIXB,12])
	SZ3->Z3_QUANTID := aCols[PARAMIXB,16]
	SZ3->Z3_UM      := aCols[PARAMIXB,8]
	SZ3->Z3_LARGURA := SB1->B1_X_LARG
	SZ3->Z3_DESCRI  := aCols[PARAMIXB,7]
	SZ3->Z3_COMP    := SB1->B1_X_COMP
	SZ3->Z3_ORDEM   := Subs(aCols[PARAMIXB,6],1,3)
	SZ3->Z3_ARTIGO  := Subs(aCols[PARAMIXB,6],1,3)+Subs(aCols[PARAMIXB,6],7)
	SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
	SZ3->Z3_COR     := Subs(aCols[PARAMIXB,6],4,3)
	SZ3->Z3_PARTIDA := Subs(SD3->D3_OP,1,6)
	SZ3->Z3_SAIDA   := "E"  //"S" // Quantidade de Saida
	SZ3->Z3_COPIAS  := 1
	SZ3->Z3_DOC     := cDocumento
	SZ3->Z3_REVISOR := SD3->D3_REVISOR
	SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_COD"),"")
	SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL"),"")
	SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_CODCL")+Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_LOJCL"),"A1_CGC"),"")
	MsUnLock()
//EndIf
MsgBox("Gerando Etiquetas para o Codigo "+ACOLS[PARAMIXB,6])

DbSelectArea("SZB")
RecLock("SZB",.t.)
SZB->ZB_FILIAL  :=  xFilial("SZB")
SZB->ZB_DATA    :=  dDataBase
SZB->ZB_LOTECTL :=  aCols[PARAMIXB,12]
SZB->ZB_PRODUTO :=  aCols[PARAMIXB,1]
SZB->ZB_QUANT   :=  _nSaldo+aCols[PARAMIXB,16]
MsUnLock()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Restaurando a Integridade dos Arquivos                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
                
RestArea(_aAreaSB1)
RestArea(_aAreaSB8)
RestArea(_aAreaSD3)
RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
