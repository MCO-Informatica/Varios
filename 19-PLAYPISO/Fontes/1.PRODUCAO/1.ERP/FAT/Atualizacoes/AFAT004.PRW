/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AFAT004  ºAutor  ³Mauro Nagata        º Data ³  19/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³inclue o endereco de entrega da obra nos dados adicionais   º±±
±±º          ³no pedido de vendas                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AFAT004

Local cRet  := ""
Local aArea := GetArea()
Local cObra := M->C5_CCUSTO
           
If Len(AllTrim(cObra)) > 5
   DbSelectArea("CTT")
   If DbSeek(xFilial("CTT")+cObra)
   	   // [Thiago Miguel, Actualtrend - 20180131 - alterado a linha abaixo]
      //cRet := "MATERIAIS QUE SEGUEM PARA CONSTRUCAO CIVIL COM LOCAL PARA ENTREGA NA OBRA:"+Chr(13)+Chr(10)+;
      cRet := "MATERIAIS DE NOSSA PROPRIEDADE DE CONSTRUCAO CIVIL QUE SEGUEM PARA ENTREGA NA OBRA.:"+Chr(13)+Chr(10)+;
      		Upper(RTrim(cObra))+"- PEDIDO: "+M->C5_NUM+" - "+;
      		Upper(RTrim(CTT->CTT_XEND))+" - "+Upper(RTrim(CTT->CTT_XBAIRR))+" - "+Upper(RTrim(CTT->CTT_XMUN))+"-"+Upper(CTT->CTT_XUF)+;
      		" - (NOME DA OBRA: "+Upper(RTrim(CTT->CTT_DESC01))+")"+If(!Empty(Upper(CTT->CTT_XREF))," - REFERENCIA:"+Upper(RTrim(CTT->CTT_XREF)),"")+;
      		" .NAO INCIDENCIA DE ICMS,CONFORME ARTIGO 2º DO ANEXO XI, DO RICMS/2000."
   EndIf
EndIf

RestArea(aArea)
Return cRet