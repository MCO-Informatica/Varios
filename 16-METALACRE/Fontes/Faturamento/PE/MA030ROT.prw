#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030ROT � Autor � Luiz Alberto     � Data � 29/07/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Substitui Chamada de Tela de Contatos no Browse do Cliente
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/   
User Function MA030ROT                         
Local aRetorno := {}

nAchou := Ascan(aRotina,{|x| x[1]=='Contatos'})
If !Empty(nAchou)
	aRotina[nAchou][2] := 'U_FContato'
Else
	aadd(aRetorno,{"Contatos *",'U_FContato',0,4})
Endif                                             

aadd(aRetorno,{"Contagem *",'U_FContage',0,4})

Return(aRetorno)                          


User Function MA030BUT()

Local aButtons := {} // Botoes a adicionar

aadd(aButtons,{'BUDGETY',{|| U_FContato()},'Contatos ***','Contatos ***'})

Return (aButtons )

User Function FContage()
Local aArea := GetArea()
Local oObjBrw := GetObjBrow()

If Empty(oObjBrw:OFWFILTER:AFILTER)
	MsgStop("Aten��o a Contagem s� Ser� Executada se a Tela Possuir Algum tipo de Filtro !")
	RestArea(aArea)
	Return .t.
Endif

Processa( {|| ContaRegs(oObjBrw,Alias())   },"Aguarde Contado Registros ..." )

RestArea(aArea)
Return .t.

Static Function ContaRegs(oObjBrowse,cAlias)
Local aArea    := getArea()
Local bFiltro  := nil
Local lFat     := .F.
Local cFiltro  := oObjBrowse:oFWFilter:GetExprADVPL()
Local cFiltOld := &(cAlias)->( dbFilter() )
Local lRet     := .T.
Local aRetorno := {}
Local cParams  := ""


//Restaura filtros anteriores
If !Empty( cFiltro )
	bFiltro  := &('{||' + cFiltro + '}')
	&(cAlias)->(dbSetFilter(bFiltro, cFiltro))
	lFat := !(&(cAlias)->(Eof()))
Else
	&(cAlias)->(dbClearFilter())
EndIf
nContagem := 0
If lFat	// Existe Filtro
	&(cAlias)->(dbGoTop())	
	Count To nContagem
	&(cAlias)->(dbGoTop())	
Endif

cFiltros := 'Express�o: ' + cFiltro + CRLF + CRLF
For nFiltro := 1 To Len(oObjBrowse:OFWFILTER:AFILTER)
	If oObjBrowse:OFWFILTER:AFILTER[nFiltro,6]
		cFiltros += 'Filtro (' + Str(nFiltro,2) + ') ' + oObjBrowse:OFWFILTER:AFILTER[nFiltro][1] + CRLF
	Endif
Next

Aviso("Filtros","Contagem Executado com os Filtros: "+CRLF+CRLF+cFiltros+CRLF+"Contagem do Filtro Atual: " + Str(nContagem,6) + " Registro(s) Contado(s)...",{"Ok"},3)

RestArea(aArea)
Return .t.