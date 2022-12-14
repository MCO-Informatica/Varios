#INCLUDE "Protheus.ch"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? FilEmbXX ?Autor  ?Luiz Alberto Data   ?  13/06/12          ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Funcao Responsavel pelo Filtro do Campo C6_XEMBALA          ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Metalacre                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function FilEmbXX() 

local codpro := GDFIELDPOS("ADB_CODPRO")

If FunName() == 'MATA410'
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n,ASCAN(aHeader,{|aVal|Alltrim(aVal[2])=="UB_PRODUTO"})])
ElseIF FunName() == 'MATA416'
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n,ASCAN(aHeadC6,{|aVal|Alltrim(aVal[2])=="UB_PRODUTO"})])
 ElseIF FunName() == 'TMKA271'
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n,ASCAN(aHeader,{|aVal|Alltrim(aVal[2])=="UB_PRODUTO"})])
ElseIf FunName() == 'MATA650'
   Return AllTrim(Z06->Z06_PROD) == Alltrim(M->C2_PRODUTO)                                               
ElseIF FunName() == 'FATA400'
   Return AllTrim(Z06->Z06_PROD)==AllTrim(aCols[n, codpro])   
Endif                              

Return .f.
                             


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?ChecEmb? Autor? Luiz Alberto ? Data ? 23/07/12              ???
?????????????????????????????????????????????????????????????????????????͹??            
???Descricao ? Valida Campo C6_XEMBALA                                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? METALACRE                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function ChecEmbX()

Local aArea := GetArea()

Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_XEMBALA" } )

IF FUNNAME() == 'FATA400'
/*
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_CODPROD" } )
	nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "ADB_XEMBAL" } )
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+aCols[n,nPosEMBA]+aCols[n,nPosProd])) //aCols[n,nPosEmba]+aCols[n,nPosProd])
		Alert("Atencao Esta Embalagem N?o Foi Encontrada para o Produto -> " + aCols[n,nPosProd])
		Return .f.
	Endif*/
ELSE	
	
	If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+M->UB_XEMBALA+aCols[n,nPosProd])) //aCols[n,nPosEmba]+aCols[n,nPosProd])
		Alert("Atencao Esta Embalagem N?o Foi Encontrada para o Produto -> " + aCols[n,nPosProd])
		Return .f.
	Endif
ENDIF
RestArea(aArea)
Return .t.


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?DesabEmb Autor? Luiz Alberto ? Data ? 24/07/12              ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Valida Campo C6_XEMBALA                                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? METALACRE                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
  Desabilita Edicao do Campo C6_XEMBALA para itens que possuirem OP
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function DesabX()

Local aArea := GetArea()
Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_XEMBALA" } )
Local nPosOP   := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_NUMOP" } )
Local nPosItOP := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_ITEMOP" } )

If !Empty(aCols[n,nPosOP]) .And. !Empty(aCols[n,nPosItOP])
	Alert("Atencao N?o ? Poss?vel Editar o Campo Embalagem com OP Gerada - Estorne a OP para Efetuar Altera??o !")
	RestArea(aArea)
	Return .f.
Endif

RestArea(aArea)
Return .t.


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? ChanEmb  ?Autor  ?Bruno Abrigo        ?      |  03/08/12   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Funcao Responsavel pelo Filtro do Campo C6_XEMBALA          ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Metalacre                                                  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function ChanEmbX()
Local aArea    := GetArea()
Local nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" } )
Local nPosEmba := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_XEMBALA" } )
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


