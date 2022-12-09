#INCLUDE "MATR710.CH"
#INCLUDE "FIVEWIN.CH"

#define DESLOC_ETQ  57
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR710  � Autor � Paulo Boschetti       � Data � 13.05.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Etiquetas para os volumes                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR710(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NFEtiq()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL titulo := OemToAnsi(STR0001)	//"Etiquetas para embalagens"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa   ira emitir as etiquetas"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"para as embalagens a serem despachadas."
LOCAL cDesc3 := ""
LOCAL wnrel
LOCAL tamanho:= "G"
LOCAL cString:= "SF2"
LOCAL aOrd      := { OemToAnsi(STR0004) }		//" Etiqueta - 36 X 81mm  4 colunas "
LOCAL aImp      := 0

PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Etiqueta"###"Producao"
PRIVATE nomeprog:="MATR710"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR710"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("MTR710",.T.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Qual Serie De Nota Fiscal             �
//� mv_par02        	// Nota Fiscal de                        �
//� mv_par03        	// Nota Fiscal ate                       �
//� mv_par04        	// Emite por   Pedido   Nota Fiscal      �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="MATR710"             //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,tamanho)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,"")

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C710ImpA(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C710IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR550			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C710ImpA(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL titulo := OemToAnsi(STR0001)	//"Etiquetas para embalagens"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa   ira emitir as etiquetas"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"para as embalagens a serem despachadas."
LOCAL cDesc3 := ""
LOCAL nTipo, nOrdem
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:= "P"
LOCAL limite := 80
LOCAL lContinua := .T.
LOCAL nVolume := 0
LOCAL nVolumex:= 0
LOCAL aEtiq[8,4]
LOCAL nEtiqueta := 1
LOCAL G := 1
LOCAL I := 1
LOCAL J := 1
LOCAL aOrd      := { OemToAnsi(STR0004) }	//" Etiqueta - 36 X 81mm  4 colunas "
LOCAL aImp      := 0
LOCAL nEstaOk   := 0
LOCAL nContCol  := 1
LOCAL cPedi     := ""
Local cX
Local cIndex
Local lRet      := .F.
Local cCadastro := OemToAnsi(STR0007)	//"Etiquetas de Volume"

Local nQtdImp	  := 0
//��������������������������������������������������������������Ŀ
//� Definicao do cabecalho e tipo de impressao do relatorio      �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 0
col      := 0
m_pag    := 1

titulo := STR0008	//"ETIQUETAS PARA EMBALAGENS"
cabec1 := ""
cabec2 := ""

nTipo  := 18

nOrdem := aReturn[8]

//��������������������������������������������������������������Ŀ
//� Analisa o parametro mv_par04                                 �
//����������������������������������������������������������������

dbSelectArea("SD2")
If mv_par04 == 1
	cIndex := CriaTrab(nil,.f.)
	IndRegua("SD2",cIndex,"D2_FILIAL+D2_DOC+D2_SERIE+D2_ITEM",,,OemToAnsi(STR0019))		//"Selecionando Registros..."
Else
	dbSetOrder(3)
EndIf

//��������������������������������������������������������������Ŀ
//� Acesso nota fiscal informada pelo usuario                    �
//����������������������������������������������������������������
dbSelectArea("SF2")
dbSeek(xFilial()+mv_par02+mv_par01,.T.)

SetRegua(RecCount())		// Total de Elementos da regua

//�������������������������������������������������������������������Ŀ
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������


MSCBPRINTER("S500-8","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
MSCBBEGIN(1,3)

While !eof() .and. lContinua .And. xFilial()==F2_FILIAL .And. F2_DOC <= mv_par03
	
	IncRegua()
	
	If F2_SERIE != mv_par01
		dbskip()
		Loop
	EndIf

	If IsRemito(1,"SF2->F2_TIPODOC")
		dbSkip()
		Loop
	Endif
			
	IF lEnd
		@PROW()+1,001 Psay STR0009	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		EXIT
	Endif
	
	dbSelectArea("SD2")
	If mv_par04 == 2
		dbSetOrder(3)
	EndIf
	dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
	
    If SD2->D2_TIPO $"DB"
	    dbSelectArea("SA2")
    	dbSetOrder(1)
    	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
    Else
	    dbSelectArea("SA1")
    	dbSetOrder(1)
    	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	Endif
	
	dbSelectArea("SA4")
	dbSetOrder(1)                                         
	dbSeek(xFilial()+SF2->F2_TRANSP)
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se mesmo mudando a Nota fiscal o pedido e' o mesmo  �
	//� imprime apenas uma vez a etiqueta de volume                  �
	//����������������������������������������������������������������
	If mv_par04 == 1
		If cPedi == SD2->D2_PEDIDO
			dbSelectArea("SF2")
			dbSkip()
			Loop
		Endif
	EndIf
	
	cPedi := SD2->D2_PEDIDO
	
	For G:=1 to 4
		cX := "SF2->F2_VOLUME"+str(G,1)
		nVolume := nVolumex := &cx
		While nVolume != 0
			If nOrdem == 1
				If aImp == 0
					//While !lRet
					//	lRet := (MsgYesNo(OemToAnsi(STR0010),OemToAnsi(STR0011)))			//"O Alinhamento da Impressora esta correto ?"###"Aten��o"
					//End
				EndIf
				_n_Lin := _pRow()
				_n_Col := _pCol()
				@ _n_Lin,_n_Col Psay chr( getMV( "MV_COMP" ) )
				setPrc( _n_Lin,_n_Col )
				cX := "SF2->F2_ESPECI"+str(G,1)
				Do Case
					Case nEtiqueta == 1
						If nVolume != 0
        					aEtiq[3,nEtiqueta] := /*IIF(SD2->D2_TIPO $"DB",STR0020,STR0012)+PadR(SD2->D2_CLIENTE,20)*/+STR0013+SD2->D2_PEDIDO				//"Cliente: "###"Pedido: "
		
                            If SD2->D2_TIPO $"DB"
     					    	aEtiq[2,nEtiqueta] := SA2->A2_NOME
	     						//aEtiq[3,nEtiqueta] := Subs(SA2->A2_END,1,49)
		    					aEtiq[4,nEtiqueta] := STR0014+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" "+SA2->A2_EST		//"Cep: "
		                    Else
     					    	aEtiq[2,nEtiqueta] := SA1->A1_NOME
	     						//aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))
		    					aEtiq[4,nEtiqueta] := /*STR0014+Trans(SA1->A1_CEP,"@R 99999-999")+" "+*/AllTrim(SA1->A1_MUN)+" "+SA1->A1_EST		//"Cep: "
                            Endif
		                    
							aEtiq[5,nEtiqueta] := "Transp: "	+ SA4->A4_NOME	//"Transportadora: "
							//aEtiq[6,nEtiqueta] := SA4->A4_NOME
							aEtiq[6,nEtiqueta] := STR0016+AllTrim(STR((nVolumex-nVolume)+1))+"/"+AllTrim(STR(nVolumex))/*+" "+STR0017+&cX		*/	//"Volume: "###"    Especie: "
							aEtiq[1,nEtiqueta] := "NF.: "+SF2->F2_DOC/*+"/"+mv_par01*/		//"Nota Fiscal/Serie: "
							nVolume--
							nEtiqueta++
						EndIf
					Case nEtiqueta == 2
						If nVolume != 0
        					aEtiq[3,nEtiqueta] := /*IIF(SD2->D2_TIPO $"DB",STR0020,STR0012)+PadR(SD2->D2_CLIENTE,20)*/+STR0013+SD2->D2_PEDIDO				//"Cliente: "###"Pedido: "
		
                            If SD2->D2_TIPO $"DB"
     					    	aEtiq[2,nEtiqueta] := SA2->A2_NOME
	     						//aEtiq[3,nEtiqueta] := Subs(SA2->A2_END,1,49)
		    					aEtiq[4,nEtiqueta] := STR0014+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" "+SA2->A2_EST		//"Cep: "
		                    Else
     					    	aEtiq[2,nEtiqueta] := SA1->A1_NOME
	     						//aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))
		    					aEtiq[4,nEtiqueta] := /*STR0014+Trans(SA1->A1_CEP,"@R 99999-999")+" "+*/AllTrim(SA1->A1_MUN)+" "+SA1->A1_EST		//"Cep: "
                            Endif
		                    
							aEtiq[5,nEtiqueta] := "Transp: "	+ SA4->A4_NOME	//"Transportadora: "
							//aEtiq[6,nEtiqueta] := SA4->A4_NOME
							aEtiq[6,nEtiqueta] := STR0016+AllTrim(STR((nVolumex-nVolume)+1))+"/"+AllTrim(STR(nVolumex))/*+" "+STR0017+&cX		*/	//"Volume: "###"    Especie: "
							aEtiq[1,nEtiqueta] := "NF.: "+SF2->F2_DOC/*+"/"+mv_par01*/		//"Nota Fiscal/Serie: "
							nVolume--
							nEtiqueta++
						EndIf
					Case nEtiqueta == 3
						If nVolume != 0
        					aEtiq[3,nEtiqueta] := /*IIF(SD2->D2_TIPO $"DB",STR0020,STR0012)+PadR(SD2->D2_CLIENTE,20)*/+STR0013+SD2->D2_PEDIDO				//"Cliente: "###"Pedido: "
		
                            If SD2->D2_TIPO $"DB"
     					    	aEtiq[2,nEtiqueta] := SA2->A2_NOME
	     						//aEtiq[3,nEtiqueta] := Subs(SA2->A2_END,1,49)
		    					aEtiq[4,nEtiqueta] := STR0014+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" "+SA2->A2_EST		//"Cep: "
		                    Else
     					    	aEtiq[2,nEtiqueta] := SA1->A1_NOME
	     						//aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))
		    					aEtiq[4,nEtiqueta] := /*STR0014+Trans(SA1->A1_CEP,"@R 99999-999")+" "+*/AllTrim(SA1->A1_MUN)+" "+SA1->A1_EST		//"Cep: "
                            Endif
		                    
							aEtiq[5,nEtiqueta] := "Transp: "	+ SA4->A4_NOME	//"Transportadora: "
							//aEtiq[6,nEtiqueta] := SA4->A4_NOME
							aEtiq[6,nEtiqueta] := STR0016+AllTrim(STR((nVolumex-nVolume)+1))+"/"+AllTrim(STR(nVolumex))/*+" "+STR0017+&cX		*/	//"Volume: "###"    Especie: "
							aEtiq[1,nEtiqueta] := "NF.: "+SF2->F2_DOC/*+"/"+mv_par01*/		//"Nota Fiscal/Serie: "
							nVolume--
							nEtiqueta++
						EndIf
					Case nEtiqueta == 4
						If nVolume != 0
        					aEtiq[3,nEtiqueta] := /*IIF(SD2->D2_TIPO $"DB",STR0020,STR0012)+PadR(SD2->D2_CLIENTE,20)*/+STR0013+SD2->D2_PEDIDO				//"Cliente: "###"Pedido: "
		
                            If SD2->D2_TIPO $"DB"
     					    	aEtiq[2,nEtiqueta] := SA2->A2_NOME
	     						//aEtiq[3,nEtiqueta] := Subs(SA2->A2_END,1,49)
		    					aEtiq[4,nEtiqueta] := STR0014+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" "+SA2->A2_EST		//"Cep: "
		                    Else
     					    	aEtiq[2,nEtiqueta] := SA1->A1_NOME
	     						//aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))
		    					aEtiq[4,nEtiqueta] := /*STR0014+Trans(SA1->A1_CEP,"@R 99999-999")+" "+*/AllTrim(SA1->A1_MUN)+" "+SA1->A1_EST		//"Cep: "
                            Endif
		                    
							aEtiq[5,nEtiqueta] := "Transp: "	+ SA4->A4_NOME	//"Transportadora: "
							//aEtiq[6,nEtiqueta] := SA4->A4_NOME
							aEtiq[6,nEtiqueta] := STR0016+AllTrim(STR((nVolumex-nVolume)+1))+"/"+AllTrim(STR(nVolumex))/*+" "+STR0017+&cX		*/	//"Volume: "###"    Especie: "
							aEtiq[1,nEtiqueta] := "NF.: "+SF2->F2_DOC/*+"/"+mv_par01*/		//"Nota Fiscal/Serie: "
							
							nVolume--
							nEtiqueta := 1
							
							
							Li := 95
							COL := 06
							
							/*For I:= 1 TO 8
								For J:=1 TO 4
									//@Li , COL  Psay aEtiq[I,J]
									//COL += DESLOC_ETQ
								Next j
							Next I
							*/
							
							For i := 1 to 4
								if i == 1
									Col := 06
									Li := 85
								endIf
								if i == 2
									Col := 75
									Li := 85
								endIf
								if i == 3
									Col := 06
									Li := 30
								endIf
								if i == 4
									Col := 75
									Li := 30
								endIf
								For j := 1 to 6
									If j == 1 // NF imprime Maior
										MSCBSAY(Li,COL,aEtiq[j,i],"R","0","102,102")
										Li -= 05
									Else
										MSCBSAY(Li,COL,aEtiq[j,i],"R","0","27,27")
										Li -= 05
									EndIf
								Next
							
							Next
							MSCBEND() //Fim da Imagem da Etiqueta
							MSCBCLOSEPRINTER()
							MSCBPRINTER("S500-8","LPT1",,,.f.,)
							MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
							MSCBBEGIN(1,3)
							For I:= 1 TO 6
								For J:=1 TO 4
									aEtiq[I,J] := ""
								NEXT J
							NEXT I
							/*Li++
							If Li>80
								Li :=1
								m_pag++
							EndIf*/
						EndIf
				EndCase
			EndIf
		End
		dbSelectArea("SD2")
		dbSkip()
	Next G
	
	dbSelectArea("SF2")
	dbSkip()
End

If nOrdem == 1
	/*For I:= 1 TO 8
		For J:=1 TO 4
			If !EMPTY(aEtiq[I,J])
				//@Li , COL  Psay aEtiq[I,J]
				//COL += DESLOC_ETQ
				MSCBSAY(Li,COL,aEtiq[I,J],"R","0","28,28")
				COL += DESLOC_ETQ
			EndIf
		NEXT J
		Li++
		COL := 0
	Next I*/
	For i := 1 to 4
		if i == 1
			Col := 06
			Li := 85
		endIf
		if i == 2
			Col := 75
			Li := 85
		endIf
		if i == 3
			Col := 06
			Li := 30
		endIf
		if i == 4
			Col := 75
			Li := 30
		endIf
		For j := 1 to 6
			If j == 1 // NF imprime maior
				MSCBSAY(Li,COL,aEtiq[j,i],"R","0","102,102")
				Li -= 05
			Else
				MSCBSAY(Li,COL,aEtiq[j,i],"R","0","27,27")
				Li -= 05
			EndIf
		Next
	
	Next
	MSCBEND() //Fim da Imagem da Etiqueta
EndIf
//@ Li+1,0 Psay ""
Setprc(0,0)



MSCBCLOSEPRINTER()


dbSelectArea("SD2")
RetIndex("SD2")
dbSetOrder(1)

dbSelectArea("SF2")

If mv_par04==1
	RetIndex("SD2")
	#IFNDEF TOP
		cIndex+=OrdBagExt()
		Ferase(cIndex)
	#ENDIF
Endif

dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.
