#include 'protheus.ch'
#include 'parmtype.ch'

User Function FISTRFNFE

Aadd(aRotina,{"Complementos","U_VQCMPLNF"     ,0,2,0 ,NIL})
aadd(aRotina,{"Salvar Danf/XML","U_FSRDN411", 0 , 3, 0 , Nil})

Return


User Function VQCMPLNF()
	SD2->(dbSetOrder(3)) 
	SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	
	Mata926(SD2->D2_DOC,SD2->D2_SERIE,SF2->F2_ESPECIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"S",SD2->D2_TIPO,SD2->D2_CF,SD2->D2_ITEM)
Return


User Function FSRDN411()
    U_zGerDanfe(SF2->F2_DOC,SF2->F2_SERIE,"C:\danfes\")
Return
