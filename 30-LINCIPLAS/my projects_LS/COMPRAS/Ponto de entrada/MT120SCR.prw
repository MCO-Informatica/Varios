// *************************************************************************************** //
// Thiago Queiroz - 13/12/13 ------------------------------------------------------------  //
// PE utilizado para gravar o grupo de aprovação responsável pelo pedido de compras        //
// *************************************************************************************** //
User Function MT120SCR()

Local oNewDialog  	:= PARAMIXB //Rotina do usuario que manipula as propriedades do oDlg
Local nPosTes		:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_TES"} )
Local nPosAprov		:= aScan(aHeader,{|x| AllTrim(x[2])=="C7_APROV"})

//ALERT("TESTE")

If _lCopia
	
	For _nI := 1 To Len(aCols)
		
		
		_cAprov := ACOLS[_nI][nPosAprov] // PREENCHO O GRUPO DE APROVAÇÃO
		_cAprov := IIF(ACOLS[_nI][nPosTES]=='229',IIF(__cUserId$getmv("LS_CONSIG1"),'000069',_cAprov),_cAprov) // VERIFICO SE É CONSIGNAÇÃO GRUPO 1
		_cAprov := IIF(ACOLS[_nI][nPosTES]=='229',IIF(__cUserId$getmv("LS_CONSIG2"),'000070',_cAprov),_cAprov) // VERIFICO SE É CONSIGNAÇÃO GRUPO 2
		_cAprov := IIF(EMPTY(_cAprov),SY1->Y1_GRAPROV,_cAprov) // SE NÃO FOR CONSIGNAÇÃO E ESTIVER EM BRANCO, PEGA O APROVADOR DO COMPRADOR
		
		//FOR _NX:=1 TO LEN(ACOLS)
		GdFieldPut('C7_APROV' ,_cAprov,_nI)
		//NEXT
		
	NEXT
	
ENDIF

Return 
