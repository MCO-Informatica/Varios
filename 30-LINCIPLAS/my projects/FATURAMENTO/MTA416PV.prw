/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |MTA416PV  �Autor  �ALESSANDRA          � Data �  26/01/11   ���
�������������������������������������������������������������������������͹��
���Descricao � PONTO DE ENTRADA NA EFETIVACAO DO ORCAMENTO DE VENDAS      ���
�������������������������������������������������������������������������͹��
���Uso       � Usado p/ gravar campos customizados na rotina de orcamento ���
���          | da tabela SCJ para SC5                             		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

/*/

User Function MTA416PV()

Local aArea	  := getarea()
Local i	:= VAL(SCK->CK_ITEM)


IF (I==1)
	ICMSRet	:= U_GetValIMP()	
	
	M->C5_TPFRETE	:= SCJ->CJ_TPFRETE 		//Tipo de FRETE.
	M->C5_ICMSRET	:= ICMSRet              // Valor ICMS Retido
	M->C5_OBSPED	:= SCJ->CJ_OBS		//OBS DO ORCAMENTO
    M->C5_COMIS1	:= GETADVFVAL("SA3","A3_COMIS",XFILIAL("SA3")+SCJ->CJ_VEND1,1,"")  //COMISSAO DO VENDEDOR --INCLUSAO ROGERIO

ENDIF


For nX:= 1 To Len(_aCols)
	
	nPos := aScan(_aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ENTREG"})	
	_aCols[nX,nPos] := SCJ->CJ_DTENTRG      

Next
	
RestArea (aArea)


Return

User Function GetValIMP()

Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
Local nItem 	:= 0
Local aFisGet    := Nil
Local aFisGetSCJ := Nil
Local aItemPed  := {}
Local cValid      := ""
Local cReferencia := ""
Local nPosIni     := 0
Local nLen        := 0


PRIVATE cPedido	:= ""
cPedido	:= SCJ->CJ_NUM

//inicializa as variaveis utilizadas no programa fiscal
If aFisGet == Nil
	aFisGet	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCK")
	While !Eof().And.X3_ARQUIVO=="SCK"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGet,,,{|x,y| x[3]<y[3]})
EndIf

If aFisGetSCJ == Nil
	aFisGetSCJ	:= {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SCJ")
	While !Eof().And.X3_ARQUIVO=="SCJ"
		cValid := UPPER(X3_VALID+X3_VLDUSER)
		If 'MAFISGET("'$cValid
			nPosIni 	:= AT('MAFISGET("',cValid)+10
			nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
			cReferencia := Substr(cValid,nPosIni,nLen)
			aAdd(aFisGetSCJ,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		If 'MAFISREF("'$cValid
			nPosIni		:= AT('MAFISREF("',cValid) + 10
			cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
			aAdd(aFisGetSCJ,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
		EndIf
		dbSkip()
	EndDo
	aSort(aFisGetSCJ,,,{|x,y| x[3]<y[3]})
EndIf

MaFisSave() // utilizar para salvar a fun��o fiscal que j� estiver inicializada. Exemplo: dentro do pedido de vendas
MaFisEnd()  // encerra a fun��o fiscal j� inicializada

//inicializa nova fun��o fiscal

MaFisIni(Iif(Empty(M->CJ_CLIENT),M->CJ_CLIENTE,M->CJ_CLIENT),;// 1-Codigo Cliente/Fornecedor
M->CJ_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
"C",;				// 3-C:Cliente , F:Fornecedor
"N",;				// 4-Tipo da NF
SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")


//Fazer SelectArea no SCK e Rodar todos os itens
/*
DbSelectArea('SCK')
DbSeek(xFilial('SCK') + SCJ->CJ_num )
While ! eof() .and. CK_filial == xFilial('SCK') .and. CK_num == SCJ->CJ_num
	
	cNfOri     := Nil
	cSeriOri   := Nil
	nRecnoSD1  := Nil
	nDesconto  := 0
	
	//���������������������������������������������Ŀ
	//�Calcula o preco de lista                     �
	//�����������������������������������������������
	nValMerc  := SCK->CK_VALOR
	nPrcLista := SCK->CK_PRUNIT
	If ( nPrcLista == 0 )
		nPrcLista := NoRound(nValMerc/SCK->CK_QTDVEN,TamSX3("CK_PRCVEN")[2])
	EndIf
	nAcresFin := A410Arred(TMP1->CK_PRCVEN*SE4->E4_ACRSFIN/100,"D2_PRCVEN")
	nValMerc  += A410Arred(nAcresFin*TMP1->CK_QTDVEN,"D2_TOTAL")
	nDesconto := A410Arred(nPrcLista*TMP1->CK_QTDVEN,"D2_DESCON")-nValMerc
	nDesconto := IIf(nDesconto==0,TMP1->CK_VALDESC,nDesconto)
	nDesconto := Max(0,nDesconto)
	nPrcLista += nAcresFin
	If cPaisLoc=="BRA"
		nValMerc  += nDesconto
	EndIf
	
 */
 
 //INICIO-----------------------------------------------------------------------
//���������������������������������������������Ŀ
//�Agrega os itens para a funcao fiscal         �
//�����������������������������������������������
dbSelectArea("TMP1")
dbGotop()
While ( !Eof() )
	//������������������������������������������������������Ŀ
	//� Verifica se a linha foi deletada                     �
	//��������������������������������������������������������
	If ( !TMP1->CK_FLAG .And. !Empty(TMP1->CK_PRODUTO) )
		//���������������������������������������������Ŀ
		//�Posiciona Registros                          �
		//�����������������������������������������������			
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial("SB1")+TMP1->CK_PRODUTO))
			nQtdPeso := TMP1->CK_QTDVEN*SB1->B1_PESO
		EndIf
	    SB2->(dbSetOrder(1))
	    SB2->(MsSeek(xFilial("SB2")+TMP1->CK_PRODUTO+TMP1->CK_LOCAL))
	    SF4->(dbSetOrder(1))
	    SF4->(MsSeek(xFilial("SF4")+TMP1->CK_TES))
		//���������������������������������������������Ŀ
		//�Calcula o preco de lista                     �
		//�����������������������������������������������
		nValMerc  := TMP1->CK_VALOR
		nPrcLista := TMP1->CK_PRUNIT
		nQtdPeso  := 0
		nItem++
		If ( nPrcLista == 0 )
			nPrcLista := A410Arred(nValMerc/TMP1->CK_QTDVEN,"CK_PRCVEN")
		EndIf
		nAcresFin := A410Arred(TMP1->CK_PRCVEN*SE4->E4_ACRSFIN/100,"D2_PRCVEN")
		nValMerc  += A410Arred(nAcresFin*TMP1->CK_QTDVEN,"D2_TOTAL")
		nDesconto := A410Arred(nPrcLista*TMP1->CK_QTDVEN,"D2_DESCON")-nValMerc
		nDesconto := IIf(nDesconto==0,TMP1->CK_VALDESC,nDesconto)
		nDesconto := Max(0,nDesconto)
		nPrcLista += nAcresFin
		
		//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
		If cPaisLoc=="BRA"
  			nValMerc  += nDesconto
		Endif
 
 
 
 //FIM---------------------------------------------------------------------------
 
 	
	//ADICIONA OS ITENS NA FUN��O FISCAL
	MaFisAdd(TMP1->CK_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
	TMP1->CK_TES,;	   				// 2-Codigo do TES ( Opcional )
	TMP1->CK_QTDVEN,;  				// 3-Quantidade ( Obrigatorio )
	nPrcLista,;		  				// 4-Preco Unitario ( Obrigatorio )
	nDesconto,; 					// 5-Valor do Desconto ( Opcional )
	"",;	   						// 6-Numero da NF Original ( Devolucao/Benef )
	"",;							// 7-Serie da NF Original ( Devolucao/Benef )
	0,;								// 8-RecNo da NF Original no arq SD1/SD2
	0,;								// 9-Valor do Frete do Item ( Opcional )
	0,;								// 10-Valor da Despesa do item ( Opcional )
	0,;								// 11-Valor do Seguro do item ( Opcional )
	0,;								// 12-Valor do Frete Autonomo ( Opcional )
	nValMerc,;						// 13-Valor da Mercadoria ( Obrigatorio )
	0)								// 14-Valor da Embalagem ( Opiconal )
	
	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1")+TMP1->CK_PRODUTO))
		nQtdPeso := TMP1->CK_QTDVEN*SB1->B1_PESO
	Endif                               
	endif
	dbSelectArea("TMP1")
	dbSkip()
Enddo
// PARA PEGAR O IMPOSTO A SER CALCULADO NA NF, UTILIZAR A FUN��O MAFISRET CONFORME ABAIXO.
nBaseSol	:= MaFisRet(,"NF_BASESOL")
nValSol		:= MaFisRet(,"NF_VALSOL")
nValIPI		:= MaFisRet(,"NF_VALIPI")
nValICM		:= MaFisRet(,"NF_VALICM")
// ESTES S�O ALGUNS EXEMPLOS DE IMPOSTOS, PODENDO SER RETORNADOS TODOS OS TIPOS DE IMPOSTOS

//n�o se esquecer de finalizar a fun��o fiscal ao t�rmino
MaFisEnd()

MaFisRestore() // restaura a fun��o fiscal salva no inicio do programa



Return nValSol




