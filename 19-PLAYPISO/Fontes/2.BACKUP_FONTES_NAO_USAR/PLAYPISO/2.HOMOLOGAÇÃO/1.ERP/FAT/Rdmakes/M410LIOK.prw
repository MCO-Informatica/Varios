#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  �M410LIOK  �Autor  �Cosme da Silva Nunes   �Data  �03/05/2007���
���Entrada   �          �       �                       �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �MATA410                                                     ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Validacao de linha do pedido venda                          ���
���          �Obriga a digitacao do codigo do projeto quando o TES indicar���
���          �movimentacao do tipo receita / despesa.                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao�Validacao de linha no pedido de venda                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Objeto Dialogo (dlg) da tela de pedido                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Variavel logica, validando (.T.) ou nao (.F.) a linha       ���
�������������������������������������������������������������������������Ĵ��
���Observac. �                                                            ���
�������������������������������������������������������������������������Ĵ��
���           Atualizacoes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���Mauro Nagata|07/04/2011|Obrigatorio prenchimento do campo C6_XMNTOBR   ���
���            |          |qdo.C6_CCUSTO = 3000                           ���
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M410LIOK()

Local aAreaAtu   := GetArea()
Local nPosProjPMS := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PROJPMS"})
//incluida as duas linhas [Mauro Nagata, Actual Trend, 07/04/2011]
Local nPosObra    := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_CCUSTO"})
Local nPosMnt     := Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_XMNTOBR"})

Local lRetorno    := .T.
/*                                                                          
If SF4->F4_MOVPRJ == "1" .Or. SF4->F4_MOVPRJ == "2"                  
	If Empty(aCols[n,nPosProjPMS]) .And. aCols[n,Len(aheader)+1] == .F.
	   	Aviso("Atencao","Para Tipo de Sa�da que movimenta receita / despesa em projeto, � obrigat�ria a digitacao de um C�digo de Projeto / EDT. Verifique!",{"Ok"},3,"TES c/ o campo 'Mov. Projet.' igual a '1=Receita' ou '2=Despesa'")
		lRetorno := .F.		
	EndIf
//Else
   //	Aviso("Atencao","Caso essa movimentacao tenha vinculo com Projeto, solicite o acompanhamento do respons�vel para revisar o TES (Tipo de Sa�da / Entrada) que foi selecionado.",{"Ok"},3,"TES c/ o campo 'Mov. Projet.' igual a '3=N�o Movimenta'")	
EndIf                                                             
*/
//Incluido o bloco [Mauro Nagata, Actual Trend, 07/04/2011]
If AllTrim(aCols[n,nPosObra]) == "3000"
   If Empty(aCols[n,nPosMnt])
      MsgBox("Campo Manuten��o de Obra n�o foi preenchido e � obrigat�rio quando informada o C�digo da Obra = 3000","Obra 3000","ALERT")
      lRetorno := .F.   
   Else
      lRetorno := CTT->(DbSeek(xFilial("CTT")+AllTrim(aCols[n,nPosMnt])))
      If !lRetorno
         MsgBox("Obra informada no Campo Manuten��o de Obra N�o Existe","Obra 3000","ALERT")
      EndIf   
   EndIf
EndIf      
//fim bloco [Mauro Nagata, Actual Trend, 07/04/2011]

RestArea(aAreaAtu)

Return(lRetorno)                                                        
