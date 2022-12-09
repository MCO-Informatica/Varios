#Include 'Protheus.ch'
#Include "totvs.CH"
#Include "TOPCONN.CH" 

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PONTO DE ENTRADA CHAMADA MSD2460, SE REFERE A GRAVAÇÃO DE ITEM DE NF, ELE JÁ VEM POSICIONADO. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function MSD2460()

Local aArea := GetArea()
Local aSD3:= {}
Local cLocal := "MP"
Local dEmissao := dDataBase
private lMsErroAuto :=.f.


IF SD2->D2_TES=="558"

     aSd3:={}
     aadd(aSd3,{"D3_TM","490",nil})
     aadd(aSd3,{"D3_FILIAL",xFilial("SD3"),nil})     
     aadd(aSd3,{"D3_COD",SD2->D2_COD,nil})     
     aadd(aSd3,{"D3_UM",SD2->D2_UM,nil})               
     aadd(aSd3,{"D3_LOCAL",cLocal,nil}) 
     aadd(aSd3,{"D3_LOTECTL",SD2->D2_LOTECTL,nil})     
     aadd(aSd3,{"D3_DTVALID",SD2->D2_DTVALID,nil})     
     aadd(aSd3,{"D3_DOC",SD2->D2_DOC,nil})     
     aadd(aSd3,{"D3_QUANT",SD2->D2_QUANT,nil})     
     //aadd(aSd3,{"D3_CUSTO1",SD2->D2_CUSTO1,nil})
     aadd(aSd3,{"D3_EMISSAO",dEmissao,nil})                 
     MSExecAuto({|x,y| mata240(x,y)},aSd3,3)
   
    
    If lMsErroAuto          
        alert ("Problema na Geração das Movimentações internas")
        mostraerro()
    endif
ENDIF

dbSelectArea("SD2")
RestArea(aArea)

Return
