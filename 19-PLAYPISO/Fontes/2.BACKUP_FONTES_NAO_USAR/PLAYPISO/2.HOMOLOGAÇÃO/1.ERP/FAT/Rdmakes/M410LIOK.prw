#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto de  ³M410LIOK  ³Autor  ³Cosme da Silva Nunes   ³Data  ³03/05/2007³±±
±±³Entrada   ³          ³       ³                       ³      |          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³MATA410                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao de linha do pedido venda                          ³±±
±±³          ³Obriga a digitacao do codigo do projeto quando o TES indicar³±±
±±³          ³movimentacao do tipo receita / despesa.                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³Validacao de linha no pedido de venda                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Objeto Dialogo (dlg) da tela de pedido                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Variavel logica, validando (.T.) ou nao (.F.) a linha       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observac. ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualizacoes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mauro Nagata|07/04/2011|Obrigatorio prenchimento do campo C6_XMNTOBR   ³±±
±±³            |          |qdo.C6_CCUSTO = 3000                           ³±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	   	Aviso("Atencao","Para Tipo de Saída que movimenta receita / despesa em projeto, é obrigatória a digitacao de um Código de Projeto / EDT. Verifique!",{"Ok"},3,"TES c/ o campo 'Mov. Projet.' igual a '1=Receita' ou '2=Despesa'")
		lRetorno := .F.		
	EndIf
//Else
   //	Aviso("Atencao","Caso essa movimentacao tenha vinculo com Projeto, solicite o acompanhamento do responsável para revisar o TES (Tipo de Saída / Entrada) que foi selecionado.",{"Ok"},3,"TES c/ o campo 'Mov. Projet.' igual a '3=Não Movimenta'")	
EndIf                                                             
*/
//Incluido o bloco [Mauro Nagata, Actual Trend, 07/04/2011]
If AllTrim(aCols[n,nPosObra]) == "3000"
   If Empty(aCols[n,nPosMnt])
      MsgBox("Campo Manutenção de Obra não foi preenchido e é obrigatório quando informada o Código da Obra = 3000","Obra 3000","ALERT")
      lRetorno := .F.   
   Else
      lRetorno := CTT->(DbSeek(xFilial("CTT")+AllTrim(aCols[n,nPosMnt])))
      If !lRetorno
         MsgBox("Obra informada no Campo Manutenção de Obra Não Existe","Obra 3000","ALERT")
      EndIf   
   EndIf
EndIf      
//fim bloco [Mauro Nagata, Actual Trend, 07/04/2011]

RestArea(aAreaAtu)

Return(lRetorno)                                                        
