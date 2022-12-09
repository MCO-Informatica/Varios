#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FilEmb ºAutor  ³Luiz Alberto Data ³  13/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Responsavel pelo Filtro do Campo C6_XEMBALA         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FilEmb() 
Local nCodPro := Iif(Type("aHeader")=="A",aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ADB_CODPRO" }),0)
// Apaga um SetKey
If FunName() $ 'MATA410*FATA400' .And. Empty(nCodPro)
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n,ASCAN(aHeader,{|aVal|Alltrim(aVal[2])=="C6_PRODUTO"})])
ElseIF FunName() == 'MATA416'
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n,ASCAN(aHeadC6,{|aVal|Alltrim(aVal[2])=="C6_PRODUTO"})])
ElseIf FunName() == 'MATA650'
   Return AllTrim(Z06->Z06_PROD) == Alltrim(M->C2_PRODUTO)                                               
ElseIF FunName() == 'FATA400' .And. !Empty(nCodPro)
   	Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n, nCodPro])   
Endif                              

Return .f.                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CopyAcols ºAutor  ³Luiz Alberto Data ³  23/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia a Linha do aCols Acima							       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CopyAcols()
Local aArea := GetArea()
If n>0
     aTemp := aClone(aCols)
     aAdd(aCols, aTemp[n]) 
     
     If !FunName()$"TABPREC2"
     	aCols[Len(aCols),1] := StrZero(Len(aCols),2)            
     Endif
 	 // Caso seja Executado no Orçamento de Vendas, Limpa Campos Especificos

     For nI := 1 To Len(aHeader)
     	If AllTrim(aHeader[nI,2])$'UB_XINIC,UB_XFIM,UB_XSTAND,UB_XEMBALA,UB_XVOLITE,UB_PEDCLI,UB_XAPLICA,UB_XPBITEM,UB_XPLITEM,UB_LOTECTL,UB_NUMOP'
     		aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
     	ElseIf AllTrim(aHeader[nI,2])=='UB_ITEMOP'
     		aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
     	ElseIf AllTrim(aHeader[nI,2])=='UB_ITEMCLI'
     		aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2])
     	Endif
     Next
     
Endif
RestArea(aArea)
Return .t.




                             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChecEmbº Autor³ Luiz Alberto º Data ³ 23/07/12              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Campo C6_XEMBALA  								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ METALACRE                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ChecEmb()
Local aArea := GetArea()

Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_XEMBALA" } )

IF FUNNAME() == 'FATA400'
/*
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_CODPROD" } )
	nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_XEMBAL" } )
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+aCols[n,nPosEMBA]+aCols[n,nPosProd])) //aCols[n,nPosEmba]+aCols[n,nPosProd])
		Alert("Atencao Esta Embalagem Não Foi Encontrada para o Produto -> " + aCols[n,nPosProd])
		Return .f.
	Endif*/
ELSE	
	
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+M->C6_XEMBALA+aCols[n,nPosProd])) //aCols[n,nPosEmba]+aCols[n,nPosProd])
		Alert("Atencao Esta Embalagem Não Foi Encontrada para o Produto -> " + aCols[n,nPosProd])
		Return .f.
	Endif
ENDIF
RestArea(aArea)
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DesabEmb Autor³ Luiz Alberto º Data ³ 24/07/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Campo C6_XEMBALA   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ METALACRE                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
  Desabilita Edicao do Campo C6_XEMBALA para itens que possuirem OP
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DesabEmb()

Local aArea := GetArea()
Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_XEMBALA" } )
Local nPosOP   := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_NUMOP" } )
Local nPosItOP := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_ITEMOP" } )

If !Empty(aCols[n,nPosOP]) .And. !Empty(aCols[n,nPosItOP])
	Alert("Atencao Não é Possível Editar o Campo Embalagem com OP Gerada - Estorne a OP para Efetuar Alteração !")
	RestArea(aArea)
	Return .f.
Endif

RestArea(aArea)
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ChanEmb  ºAutor  ³Bruno Abrigo        ³      |  03/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao Responsavel pelo Filtro do Campo C6_XEMBALA          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ChanEmb()
Local aArea    := GetArea()
Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_XEMBALA" } )
Local lRet                                                             

IF FUNNAME() == 'FATA400'
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_CODPROD" } )
	nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_XEMBAL" } )
ENDIF

If Empty(aCols[n,nPosEmba])
	lRet:=.T.
Else
	lRet:= ExistCpo("Z06",""+Alltrim(aCols[n,nPosEmba])+Alltrim(aCols[n,nPosProd]),1)
Endif              		
//DbselectArea("Z06");Z06->(DbSetOrder(1));Z06->(DbSeek(xFilial("Z06")+Alltrim(aCols[n,nPosProd]+Alltrim(aCols[n,nPosEmba]))))
RestArea(aArea)
Return(lRet)


