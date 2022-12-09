#Include "Rwmake.ch"

/*
+------------+----------+--------+----------------------+-------+---------------+
| Programa:  | VAEMG02  | Autor: | Jorge Henrique Alves | Data: |   Abril/2010  |
+------------+----------+--------+----------------------+-------+---------------+
| Descrição: | Zera alguns campos do pedido na copia ou quando o cliente é      |
|            | alterado, no momento da inclusão									
+------------+------------------------------------------------------------------+
| Uso:       | Verion Oleo Hidraulica					                        |
+------------+------------------------------------------------------------------+

*/

User Function VAEMG02()
Local nPPrc := nPTot := nPDsc := 0

M->C5_VRLIB   := ""

nPPrc   := ASCAN(aHeader,{|x|x[2] = "C6_PRCVEN"})
nPTot   := ASCAN(aHeader,{|x|x[2] = "C6_VALOR"})
nPDsc   := ASCAN(aHeader,{|x|x[2] = "C6_VRDESC"})

//Zera alguns campos na cópia de pedidos
For nCont := 1 To Len(aCols)

	aCols[nCont][nPPrc] 	:= 0
	aCols[nCont][nPTot] 	:= 0
	aCols[nCont][nPDsc] 	:= 0

Next

Return .t. 