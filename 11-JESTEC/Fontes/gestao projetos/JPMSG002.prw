#Include "Protheus.ch"
#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JPMSG002  ºAutor  ³Felipe Valença      º Data ³  14-11-12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para calculo do custo do recurso no apontamento    º±±
±±º          ³ do projeto.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function JPMSG002

    Local _aArea := GetArea()
    Local nCusto := 0
    Local cRecurs := ""
    Local nPosREC := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_RECURS"})
    Local nPosHrI := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_HORAI"})
    Local nPosHrF := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_HORAF"})
    Local nPosTPH := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_XTPHOR"})
    Local nPosALM := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_XALMOC"})
    Local nPosQTD := aScan(aHeader,{|x| Alltrim(x[2]) == "AFU_HQUANT"})

    If M->AFU_HORAF <> Nil

        dbSelectArea("SRA")
        dbSetOrder(1)
        dbSeek(Substr(Alltrim(aCols[n][nPosREC]),4,Len(Alltrim(aCols[n][nPosREC]))),.F.)

// Filial 01	
        If Substr(aCols[n][nPosREC],5,1) = '1'

            If aCols[n][nPosTPH] == "1"
                nCusto := (((SRA->RA_SALARIO/220)*1.8)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "2"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*2.00)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "3"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*2.20)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "4"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*1.60)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Else
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*1.80)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Endif
//Filial 02    
        Elseif Substr(aCols[n][nPosREC],5,1) = '2'

            If aCols[n][nPosTPH] == "1"
                nCusto := (((SRA->RA_SALARIO/220)*1.8)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "2"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*2.20)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "3"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*2.30)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Elseif aCols[n][nPosTPH] == "4"
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*1.70)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Else
                nCusto := ((((SRA->RA_SALARIO/220)*1.8)*1.90)* aCols[n][nPosQTD] - Val(Transform(aCols[n][nPosALM],"99.99")))
            Endif

        Endif
    Endif

Return nCusto