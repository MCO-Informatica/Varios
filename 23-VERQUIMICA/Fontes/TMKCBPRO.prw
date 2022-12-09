#include 'protheus.ch'
#include 'parmtype.ch'
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: TmkBarLa | Autor: Celso Ferrone Martins   | Data: 07/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE para adcionar um botao na tela do callcenter            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function TMKCBPRO(aBotao,aTitulo)


Public cZ16Clien := ""
Public cZ16Loja  := ""
Public cZ16Nome  := ""
Public cZ16Orig  := "TMKA271"

If Upper(Alltrim(FunName())) == "TMKA271"
	aAdd(aBotao,{"S4WB016N"  , {|| U_CfmPendencia()                        } ,"Verifica Pendencias"})	
	aAdd(aBotao,{"DBG06"     , {|| U_CfmTmkTZ(1)                           } ,"Consulta Produto"   })
	aAdd(aBotao,{"BMPuser"   , {|| U_CfmPesq(M->UA_CLIENTE,M->UA_LOJA)     } ,"Historico Clientes"   })
	aAdd(aBotao,{"CRITICA"   , {|| U_CfmHsZ16(M->UA_CLIENTE,M->UA_LOJA)    } ,"Anotacoes Cliente"  })
	aAdd(aBotao,{"autom_mdi" , {|| U_CfmTmkTZ(2)                           } ,"Estoque Produto"   })
	aAdd(aBotao,{"AGENDA" 	 , {|| U_VQMETCLI("CallCenter")                } ,"Consumo Cliente"   })
EndIf

Return(aBotao)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmTmkTv | Autor: Celso Ferrone Martins   | Data: 07/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Chamada da rotina do botao de consulta de produtos         |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CfmTmkTZ(nOpc)
    
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto
Local aAreaSb1 := SB1->(GetArea())
Local cCodSb1  := ""

Default nOpc := 1

If nOpc == 1
	U_VQCONPROD(aCols[n][nPosProd])
ElseIf nOpc == 2
	DbSelectArea("SB1") ; DbSetOrder(1)
	If SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosProd]))
		If SB1->B1_TIPO == "PA"
			cCodSb1 := SB1->B1_VQ_MP
		Else
			cCodSb1 := SB1->B1_COD
		EndIf
		U_CfmComFat(cCodSb1)
	EndIf
EndIf

SB1->(RestArea(aAreaSb1))

Return()