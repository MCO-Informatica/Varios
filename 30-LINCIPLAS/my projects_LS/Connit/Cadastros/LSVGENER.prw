#INCLUDE "PROTHEUS.CH"

/*
+===================+======================+=========================+
|Programa: LSVGENER |Autor: Antonio Carlos |Data: 26/08/08           |                                
+===================+======================+=========================|
|Descricao: Neste arquivo constam algumas rotinas que são utilizadas |
|em gatilhos (SX7).             								     | 
+====================================================================+
|Uso: Laselva                                                        |
+====================================================================+                                       
*/

User Function LSVDIV01(cProd)

cRef 	:= Str(Val(SB1->B1_EDICAO)+1)
cRef1 	:= StrZero(Val(cRef),4)

If Len(Alltrim(SB1->B1_COD)) <= 9
	cProduto := Alltrim(Substr(SB1->B1_COD,1,5))+cRef1
Else 
	cProduto := Alltrim(Substr(SB1->B1_COD,1,7))+cRef1	
EndIf	

Return(cProduto)


////////////////////////////////////////////////////////////////////////////////////////////////////
// ********************************************************************************************** //
////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSVDIV02(cEdicao)

cRefa := Str(Val(SB1->B1_EDICAO)+1)
cRefb := StrZero(Val(cRefa),4)

Return(cRefb)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função utilizada para preencher o campo B1_TS com a TES padrão de saída dependendo do grupo do produto //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSVDIV03()

Private cTes := Space(3)

If M->B1_GRUPO $ GetMv("MV_GRPLIVR")
	cTes := GetMv("MV_TESLIVR")
EndIf

If M->B1_GRUPO $ GetMv("MV_GRPREVI")
	cTes := GetMv("MV_TESREVI")
EndIf

Return(cTes)

////////////////////////////////////////////////////////////////////////////////////////////////////
// Preenche o campo B1_POSIPI (NCM) do Produto, utilizado em gatilhos *************************** //
////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSVDIV04()

Private cPosIpi := Space(3)

If M->B1_GRUPO $ GetMv("MV_GRPLIVR")
	cPosIpi := "49011000"
ElseIf M->B1_GRUPO $ GetMv("MV_GRPREVI")
	cPosIpi := "49021000"
EndIf

Return(cPosIpi)