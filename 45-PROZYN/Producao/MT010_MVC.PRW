#include "protheus.ch"
#include "parmtype.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณMicrosiga           บ Data ณ  04/23/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function ITEM()
    Local aParam   := PARAMIXB
    Local oModel   := FwModelActive()
    Local oObj     := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid  := .F.
    Local xRet     := .T.   
	Local cLibUsr  := GetMV("MV_DBLPROD")
	Local cUsr     := RetCodUsr() 
	Local aArea := GetArea()

    
        
    // VERIFICA SE APARAM NรO ESTม NULO
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
         
        //  VERIFICA SE O PONTO EM QUESTรO ษ O FORMPOS
        If cIdPonto == "MODELCOMMITNTTS"
         
            // VERIFICA SE OMODEL NรO ESTม NULO
            If oModel <> NIL
                //SB1->B1_MSBLQL := IIf(M->B1_MSBLQL != SB1->B1_MSBLQL, M->B1_MSBLQL, 2)
					If cUSr $ cLibUsr
 
						   	RecLock('SB1', .F.) //Feito a inver็ใo do IF pois estava o contrแrio. Guilherme Coelho
					        SB1->B1_MSBLQL := IIf(M->B1_ATIVO =='S', M->B1_MSBLQL,"1")
						    SB1->(MsUnlock())
     					    RestArea(aArea)
					Else                                           
							RecLock('SB1', .F.)
//                          SB1->B1_MSBLQL := IIf(M->B1_MSBLQL != SB1->B1_MSBLQL, M->B1_MSBLQL,"2")
                            SB1->B1_MSBLQL := IIf(M->B1_ATIVO =='N', M->B1_MSBLQL,"2")
						    SB1->(MsUnlock())
     					    RestArea(aArea)
                    
                    Endif
			
            EndIf
             
        EndIf
     
    EndIf
Return xRet

