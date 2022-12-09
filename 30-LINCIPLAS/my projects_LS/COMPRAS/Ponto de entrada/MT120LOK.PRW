#Include "Protheus.ch"
#Include "RWMAKE.ch"

/*
+==========================================================+
|Programa: MT120LOK |Autor: Antonio Carlos |Data: 27/08/10 |
+==========================================================+
|Descrição: PE utilizado para validar Cond.Pagto x Tes.    |
+==========================================================+
|Especifico: Laselva                                       |
+==========================================================+
*/

User Function _MT120LOK()

Local aArea		:= GetArea()                                 
Local _lRet 	:= .T.
Local nPosTes	:= aScan( aHeader,{|x| AllTrim(x[2])=="C7_TES"} )

DbSelectArea("SE4")
SE4->( DbSetOrder(1) )
SE4->( DbSeek(xFilial("SE4")+cCondicao) )

For _nI := 1 To Len(aCols)                        
	
	DbSelectArea("SF4")
	SF4->( DbSetOrder(1) )
	SF4->( DbSeek(xFilial("SF4")+aCols[n,nPosTes]) )
	
	If Alltrim(SE4->E4_COND) == "0" .And. SF4->F4_DUPLIC == "S" 
		
		_lRet := .F.
		
		Alert("Para a Cond.de Pagto: "+Alltrim(SE4->E4_DESCRI)+" o Tes nao pode gerar "+CHR(13)+;
		"Financeiro, favor corrigir os itens!")
		
		Exit
		
	ElseIf !Alltrim(SE4->E4_COND) == "0" .And. SF4->F4_DUPLIC == "N" 
		
		_lRet := .F.
		
		Alert("Para a Cond.de Pagto: "+Alltrim(SE4->E4_DESCRI)+" o Tes deve gerar "+CHR(13)+;
		"Financeiro, favor corrigir os itens!")
		
		Exit
		
	EndIf	
			
Next _nI

RestArea(aArea)
 
Return(_lRet)