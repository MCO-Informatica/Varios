#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK510ABTN �Autor  �Opvs  (David)       � Data �  03/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para Inclus�o de Botoes adiconais na Tela  ���
���          �de ServiceDesk                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TK510ABTN()
Local aBotoes	:= paramixb[1]
Local aIdxEval	:= paramixb[2]
Local nPosHist	:= Ascan(aBotoes,{|x| Alltrim(x[6]) = "(CTRL+H)"})

If nPosHist > 0
	//05/12/12 - Realizada tratamento para retirada do bot�o padr�o de 
	//consulta de hist�rico (David)
	aDel(aBotoes,nPosHist)
	aSize(aBotoes,Len(aBotoes)-1)
EndIf 
                                                
// Adiciona opcao para acompanhamento dos atendimentos
AAdd( aBotoes, { "PESQUISA", { || u_CSSDKACM() }, "Acompanhamento de chamados", "Acompanhamento", nil, "" } )

//05/12/12 - Caso rotina seja acessada via smartclient html 
//todos os atalhos da tela s�o retirados para que n�o haja conflito
//de telas no registro de textos de chamados
If GetRemoteType() == 5
	aEval(aBotoes,{|x|  x[5] := nil, x[6] := ""  })
EndIf

Return(aBotoes)