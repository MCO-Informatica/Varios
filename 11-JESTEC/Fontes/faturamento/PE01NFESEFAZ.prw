#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ PE01NFESEFAZ ºAutor³ SERGIO JUNIOR    º Data ³11/06/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. NA ROTINA NFESEFAZ PARA TRATAR OS DADOS ANTES DA      º±±
±±º          ³ MONTAGEM DO XML.                                           º±±
±±º          ³ PARAMETROS RECEBIDOS NO PARAMIXB:                          º±±
±±º          ³ {aProd, cMensCli, cMensFis, aDest, aNota, aInfoItem,       º±±
±±º          ³ aDupl, aTransp, aEntrega, aRetirada, aVeiculo, aReboque}   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CLIENTE - JESTEC                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            
User Function PE01NFESEFAZ()
    Local aMatriz   	:= PARAMIXB
    Local cMensCli  	:= aMatriz[2]


// Observacao Nota Fiscal
    If !(SC5->C5_XMENNOT $ cMensCli)
        If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
            cMensCli += " "
        EndIf
        cMensCli += SC5->C5_XMENNOT
    EndIf

// ATUALIZA A MENSAGEM FISCAL DA NOTA
    aMatriz[2] += cMensCli

Return aMatriz