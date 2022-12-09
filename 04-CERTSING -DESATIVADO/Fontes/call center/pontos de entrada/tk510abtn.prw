#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK510ABTN ºAutor  ³Opvs  (David)       º Data ³  03/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para Inclusão de Botoes adiconais na Tela  º±±
±±º          ³de ServiceDesk                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TK510ABTN()
Local aBotoes	:= paramixb[1]
Local aIdxEval	:= paramixb[2]
Local nPosHist	:= Ascan(aBotoes,{|x| Alltrim(x[6]) = "(CTRL+H)"})

If nPosHist > 0
	//05/12/12 - Realizada tratamento para retirada do botão padrão de 
	//consulta de histórico (David)
	aDel(aBotoes,nPosHist)
	aSize(aBotoes,Len(aBotoes)-1)
EndIf 
                                                
// Adiciona opcao para acompanhamento dos atendimentos
AAdd( aBotoes, { "PESQUISA", { || u_CSSDKACM() }, "Acompanhamento de chamados", "Acompanhamento", nil, "" } )

//05/12/12 - Caso rotina seja acessada via smartclient html 
//todos os atalhos da tela são retirados para que não haja conflito
//de telas no registro de textos de chamados
If GetRemoteType() == 5
	aEval(aBotoes,{|x|  x[5] := nil, x[6] := ""  })
EndIf

Return(aBotoes)