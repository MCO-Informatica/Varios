#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GE2  º Autor ³                     º Data ³  09/07/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PONTO DE ENTRADA apos a gravacao do titulo a pagar          º±±
±±º          ³ENTRADA PARA GRAVAR O CAMPO E2_MDCONTR                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Renova  - MODULO COMPRAS                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
//    If Existblock("MT100GE2")
//        ExecBlock("MT100GE2",.F.,.F.,{aColsSE2[nX],nOpcA,aHeadSE2})    
//    EndIf  
**********************
User Function MT100GE2()
**********************                   
Local aArea := GetArea()
Local aSD1  := SD1->(GetArea())
Local aDados:= {}
Local cLiber := GetNewPar("MV_XLIBRJ", "000001")//Parâmetro para indicar o Gestor para liberação do título (inserido pelo couto)
Local cNatli := alltrim(GetMV("MV_XBLQNAT"))

// PEGAR DO PEDIDO DE COMPRA                                                         
// O NUMERO DO CONTRATO E REVISAO
If Empty(SE2->E2_MDCONTR)

    DbSelectArea('SD1')
    SD1->(DbSetOrder(1))
    If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
        If !Empty(SD1->D1_PEDIDO)
            aDados := GetAdvFval("SC7",{"C7_CONTRA","C7_CONTREV"},xFilial('SC7')+SD1->D1_PEDIDO,1)  
        EndIF
    EndIf 
    
    If Len(aDados) > 0
      RecLock("SE2",.F.)
        SE2->E2_MDCONTR := aDados[1]
        SE2->E2_MDREVIS := aDados[2]
      SE2->(msunlock())
    EndIF   

EndIf     
/*/{Protheus.doc} 
description
@author andlcouto
@since 20/01/21              
Gravar titulo bloqueado ou liberado conforme regra definida na natureza
/*/
IF !Empty(SE2->E2_NATUREZ)
    RecLock("SE2",.F.)
        If SE2->E2_EMISSAO > CtoD("16/10/2019") 
            If !(Alltrim(SE2->E2_NATUREZ) $ cNatli)//Bloqueia o titulo conforma natureza contida no parametro //couto 20/01/21
                    SE2->E2_APROVA  := ""
                    SE2->E2_DATALIB := dDataBase
                    SE2->E2_STATLIB := "03"
                    SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
                    SE2->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
                    SE2->E2_XRJ     := "N"
            endif
        else
            SE2->E2_APROVA  := ""
            SE2->E2_DATALIB := CtoD("  /  /    ")
            SE2->E2_STATLIB := ""
            SE2->E2_USUALIB := ""
            SE2->E2_CODAPRO :=  SE2->E2_CODAPRO := cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
            SE2->E2_XRJ     := "S"
        endif
    SE2->(MsUnLock())   
Endif
//For nI := 1 To Len(aCols)
    
//   xContra := aCols[n][nPosContra]
   
//   if aCols[n][nPosContra] > 0     
      //DbSelectArea("SE2")  
      //DbSetOrder(1)
      //DbSeek(xFilial("SE2")+"GCT"+SZ7->SZ7_NUMTIT+"   "+"PA "+SZ7->Z7_FORNECE+SZ7->Z7_LOJA)

//    RecLock("SE2",.F.)
//    SE2->E2_MDCONTR = xContra
//    SE2->(msunlock())
//   endif
//Next      
        
RestArea( aSD1 )
RestArea(aArea)

Return()  
