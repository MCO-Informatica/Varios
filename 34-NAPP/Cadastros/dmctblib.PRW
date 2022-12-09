#include "TOTVS.ch"

User Function DMCTBCTD(cCliFor,lExcluir)
	Local aArea:=GetArea()
	Local aAreaSA1:=SA1->(GetArea())
	Local aAreaSA2:=SA2->(GetArea())
	Local aDadosCTD:={}
	Local nOpcAuto:=3
	Local cItemCTB:={}
	Local cCodigo:=""
	Local aBKPMemos		//Variável utilizada para realizar o backup da variável aMemos e evitar não conformidade na execução do ExecAuto
	Local n := 0
	Local cFiliais := ""
	Local aEmp := FWAllUnitBusiness()


//O bloco abaixo foi criado para evitar não conformidade na execução do ExecAuto (Por exemplo: O cadastro de clientes declara a variável aMemos como private)
	If Type("aMemos") == "A"
		aBKPMemos	:= aMemos
		aMemos		:= Nil
	EndIf

	cCliFor:=If(cCliFor==Nil,If(Alias()=="SA1","C",If(Alias()=="SA2","F","?")),cCliFor)
	lExcluir:=If(lExcluir==Nil,.F.,lExcluir)

	If cCliFor$"CF"

		//For n := 1 to 8

			cFiliais := xFilial("CTD") //Alltrim("1"+Str(n))

			If cCliFor=="C"
				cCodigo:=cCliFor+Alltrim(SA1->A1_COD)+SA1->A1_LOJA
				If SA1->(FieldPos("A1_X_ITEMC"))>0
					If !Empty(SA1->A1_X_ITEMC)
						cCodigo:=SA1->A1_X_ITEMC
					Else
						cCodigo := "C"+SA1->A1_COD+SA1->A1_LOJA
					EndIf
				EndIf
				aAdd(aDadosCTD,{"CTD_FILIAL",cFiliais,Nil})
				aAdd(aDadosCTD,{"CTD_ITEM",cCodigo,Nil})
				aAdd(aDadosCTD,{"CTD_CLASSE",'2',Nil})  						// Classe=2=Analitico
				aAdd(aDadosCTD,{"CTD_NORMAL",'0',Nil})  						// Condição Normal=0=Nenhum
				aAdd(aDadosCTD,{"CTD_DESC01",SA1->A1_NOME,Nil})
				aAdd(aDadosCTD,{"CTD_ITSUP",cCliFor,Nil})
				//aAdd(aDadosCTD,{"CTD_BLOQ",SA1->A1_MSBLQL,Nil})
				aAdd(aDadosCTD,{"CTD_CLOBRG",'2',Nil})							// Classe Valor Obrigatórioa=Não
				aAdd(aDadosCTD,{"CTD_ACCLVL",'1',Nil})							// Aceita Classe Valor=Sim
			Else
				cCodigo:=cCliFor+Alltrim(SA2->A2_COD)+SA2->A2_LOJA
				If SA2->(FieldPos("A2_X_ITEMC"))>0
					If !Empty(SA2->A2_X_ITEMC)
						cCodigo:=SA2->A2_X_ITEMC
					Else
						cCodigo := "F"+SA2->A2_COD+SA2->A2_LOJA
					EndIf
				EndIf
				aAdd(aDadosCTD,{"CTD_FILIAL",cFiliais,Nil})
				aAdd(aDadosCTD,{"CTD_ITEM",cCodigo,Nil})
				aAdd(aDadosCTD,{"CTD_CLASSE",'2',Nil})  						// Classe=2=Analitico
				aAdd(aDadosCTD,{"CTD_NORMAL",'0',Nil})  						// Condição Normal=0=Nenhum
				aAdd(aDadosCTD,{"CTD_DESC01",SA2->A2_NOME,Nil})
				aAdd(aDadosCTD,{"CTD_ITSUP",cCliFor,Nil})
				aAdd(aDadosCTD,{"CTD_CLOBRG",'2',Nil})							// Classe Valor Obrigatórioa=Não
				aAdd(aDadosCTD,{"CTD_ACCLVL",'1',Nil})							// Aceita Classe Valor=Sim
			EndIf

			CTD->(dbSetOrder(1))
			cItemCTB:=aDadosCTD[aScan(aDadosCTD,{|X| X[1]=="CTD_ITEM"}),2]
			nOpcAuto:=If(CTD->(dbSeek(xFilial("CTD")+cItemCTB)),4,3)
			lMsErroAuto:=.F.

			If !lExcluir .and. nOpcAuto==3
				MSExecAuto( {|aDados,nOpc| CTBA040(aDados,nOpc)}, aDadosCTD, nOpcAuto )

				If lMsErroAuto
					Aviso("Item Contábil","O ITEM CONTÁBIL relacionado ao "+If(cCliFor=="C","CLIENTE","FORNECEDOR")+" não pode ser "+If(nOpcAuto==3,"criado!","alterado!"),{"OK"})
					MostraErro()
				Else
					If cCliFor=="C"
						If SA1->(FieldPos("A1_X_ITEMC"))>0
							RecLock("SA1",.F.)
							SA1->A1_X_ITEMC:=aDadosCTD[aScan(aDadosCTD,{|X|Alltrim(X[1])=="CTD_ITEM"}),2]
							SA1->(msUnlock())
						EndIf
					Else
						If SA2->(FieldPos("A2_X_ITEMC"))>0
							RecLock("SA2",.F.)
							SA2->A2_X_ITEMC:=aDadosCTD[aScan(aDadosCTD,{|X|Alltrim(X[1])=="CTD_ITEM"}),2]
							SA2->(msUnlock())
						EndIf
					EndIf
				EndIf
			EndIf

		//Next

	EndIf

//Retorna o conteúdo da variável aMemos
	If ValType(aBKPMemos) == "A"
		aMemos	:= aBKPMemos
	EndIf

	SA1->(RestArea(aAreaSA1))
	SA2->(RestArea(aAreaSA2))
	RestArea(aArea)
Return(Nil)
/*
___________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verificacao de Contas Contabeis para Lancamentos Padrao    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Parametro¦ Verifica se Existem Contas Contabeis nas campos            ¦¦¦
¦¦¦          ¦ cConta1, cConta2, cConta3, cConta4, cConta5                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Retorno  ¦ Conta de Retorno Preenchida                                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function VerCCtb(cConta1,cConta2,cConta3,cConta4,cConta5)
	Local cConta:=""

	cConta1:=If(cConta1=Nil,"",cConta1)
	cConta2:=If(cConta2=Nil,"",cConta2)
	cConta3:=If(cConta3=Nil,"",cConta3)
	cConta4:=If(cConta4=Nil,"",cConta4)
	cConta5:=If(cConta5=Nil,"",cConta5)
	If Empty(cConta1)
		If Empty(cConta2)
			If Empty(cConta3)
				If Empty(cConta4)
					If !Empty(cConta5)
						cConta:=cConta5
					EndIf
				Else
					cConta:=cConta4
				EndIf
			Else
				cConta:=cConta3
			EndIf
		Else
			cConta:=cConta2
		EndIf
	Else
		cConta:=cConta1
	EndIf

Return(cConta)

User Function VerCC(cCC1,cCC2,cCC3,cCC4,cCC5)
	Local cCCusto:=""
	cCC1:=If(cCC1=Nil,"",cCC1)
	cCC2:=If(cCC2=Nil,"",cCC2)
	cCC3:=If(cCC3=Nil,"",cCC3)
	cCC4:=If(cCC4=Nil,"",cCC4)
	cCC5:=If(cCC5=Nil,"",cCC5)
	If Empty(cCC1)
		If Empty(cCC2)
			If Empty(cCC3)
				If Empty(cCC4)
					If !Empty(cCC5)
						cCCusto:=cCC5
					EndIf
				Else
					cCCusto:=cCC4
				EndIf
			Else
				cCCusto:=cCC3
			EndIf
		Else
			cCCusto:=cCC2
		EndIf
	Else
		cCCusto:=cCC1
	EndIf

Return(cCCusto)

User Function VldCC(cCCtb,cCC1,cCC2,cCC3,cCC4,cCC5)
	Local cCCusto:=""
	Local aAreaCT1:=CT1->(GetArea())

	cCC1:=If(cCC1=Nil,"",cCC1)
	cCC2:=If(cCC2=Nil,"",cCC2)
	cCC3:=If(cCC3=Nil,"",cCC3)
	cCC4:=If(cCC4=Nil,"",cCC4)
	cCC5:=If(cCC5=Nil,"",cCC5)
	If Empty(cCC1)
		If Empty(cCC2)
			If Empty(cCC3)
				If Empty(cCC4)
					If !Empty(cCC5)
						cCCusto:=cCC5
					EndIf
				Else
					cCCusto:=cCC4
				EndIf
			Else
				cCCusto:=cCC3
			EndIf
		Else
			cCCusto:=cCC2
		EndIf
	Else
		cCCusto:=cCC1
	EndIf
	If !Empty(cCCtb)
		CT1->(dbSetOrder(1))
		If CT1->(dbSeek(xFilial("CT1")+cCCtb))
			If CT1->CT1_ACCUST=='2'
				cCCusto:=""
			EndIf
		EndIf
		CT1->(RestArea(aAreaCT1))
	EndIf

Return(cCCusto)

User Function VerCLVL(cCLVL1,cCLVL2,cCLVL3,cCLVL4,cCLVL5)
	Local cCLVL:=""
	cCLVL1:=If(cCLVL1=Nil,"",cCLVL1)
	cCLVL2:=If(cCLVL2=Nil,"",cCLVL2)
	cCLVL3:=If(cCLVL3=Nil,"",cCLVL3)
	cCLVL4:=If(cCLVL4=Nil,"",cCLVL4)
	cCLVL5:=If(cCLVL5=Nil,"",cCLVL5)
	If Empty(cCLVL1)
		If Empty(cCLVL2)
			If Empty(cCLVL3)
				If Empty(cCLVL4)
					If !Empty(cCLVL5)
						cCLVL:=cCLVL5
					EndIf
				Else
					cCLVL:=cCLVL4
				EndIf
			Else
				cCLVL:=cCLVL3
			EndIf
		Else
			cCLVL:=cCLVL2
		EndIf
	Else
		cCLVL:=cCLVL1
	EndIf
Return(cCLVL)


User Function fHistCtb(cTexto)

Return(Left(LTrim(cTexto),TamSX3("CT2_HIST")[1]))
