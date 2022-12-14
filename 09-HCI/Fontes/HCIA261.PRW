#INCLUDE "PROTHEUS.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Fileio.ch"

# DEFINE BLOCO 400

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?AtuaOrc   ? Autor ? Rafael Marin       ? Data ?  29/01/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Atualiza o cadastro de itens de orcamento com base na      ???
???          ? leitura de um arquivo texto                                ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? MP8 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????

/*/
User Function AtuaTrf

//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????
Private ArqProds

//?????????????????????????????????????????????????????????????????????Ŀ
//? Montagem da tela de processamento.                                  ?
//???????????????????????????????????????????????????????????????????????

@ 50,1 TO 420,410 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 180,190
@ 10,018  Say " Este programa ira ler o conteudo de um arquivo texto, "
@ 18,018  Say " inserindo todos os itens de seu conte?do dentro do    "
@ 26,018  Say " da Compra ativa                                       "
@ 34,018  Say " Sequencia de campos:                                  "
@ 42,018  Say " Coluna (A) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (B) --> Descricao                             "
@ 58,018  Say " Coluna (C) --> Armazem Origem                         "
@ 66,018  Say " Coluna (D) --> Armazem Destino                        "
@ 74,018  Say " Coluna (E) --> Quantidade                             "
@ 82,018  Say " Coluna (F) --> xxxxxxxxx                              "
@ 90,018  Say " Coluna (G) --> xxxxxxxxx                              "
@ 98,018  Say " Coluna (H) --> xxxxxxxxx                              "
@ 106,018 Say " Coluna (I) --> xxxxxxxxx                              " 
@ 114,018 say " Coluna (J) --> xxxxxxxxx							  "
@ 130,50  Get ArqProds                       Size 100,10 when.F.
@ 130,145 BUTTON "..."                       SIZE 10,10 ACTION ArqProds := AbreArq()
@ 160,128 BMPBUTTON TYPE 01 ACTION U_OktrTxt()
@ 160,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ? OKLETXT  ? Autor ? mp8 IDE            ? Data ?  29/01/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao chamada pelo botao OK na tela inicial de processamen???
???          ? to. Executa a leitura do arquivo texto.                    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function OktrTxt

//?????????????????????????????????????????????????????????????????????Ŀ
//? Abertura do arquivo texto                                           ?
//???????????????????????????????????????????????????????????????????????

Private cArqTxt := ArqProds
Private nHdl    := fOpen(ArqProds,68)
Private nLog    := fCreate("c:\Import.log")
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

//?????????????????????????????????????????????????????????????????????Ŀ
//? Inicializa a regua de processamento                                 ?
//???????????????????????????????????????????????????????????????????????
Processa({|| U_Runtrcct() },"Processando...")
Return       

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ? RUNCONT  ? Autor ? AP5 IDE            ? Data ?  29/01/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ???
???          ? monta a janela com a regua de processamento.               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function Runtrcct
                           
Local aArea		:= GetArea()
Local nTamFile, cBuffer, nBtLidos, cCod
Local nIni, nFim, nPos, nSize
Local lPode:=.T.
Local aOrc := array(10)                    
Local cItem:="0001" 
Local nAcols 
Local nUnit
Local nQuant
Local nUsado
Local cTes 
Local aAuto := {} 
Local cDocumento
Private lMsErroAuto := .F.   


//?????????????????????????????????????????????????????????????????ͻ
//? Lay-Out do arquivo Texto lido  :                                ?
//?????????????????????????????????????????????????????????????????͹
//?Campo           ? Descri??o                                      ?
//?????????????????????????????????????????????????????????????????Ķ
//? CK_PRODUTO     ? Codigo do Produto                              ?nPos = 1
//? CK_NUMREF      ? Referencia do Produto no Cliente               ?nPos = 2
//? CK_QTDVEN      ? Quantidade do Produto                          ?nPos = 3
//? CK_ITEMCLI     ? Numero do Item no Cliente                      ?nPos = 4
//? CK_PROJETO     ? Referencia do Cliente                          ?nPos = 5
//? CK_OBS         ? Observacao                                     ?nPos = 6
//? CK_PRCVEN      ? Valor Unitario                                 ?nPos = 7
//?????????????????????????????????????????????????????????????????ͼ
/* 
@ 42,018  Say " Coluna (01) --> Codigo Prod Protheus                   "
@ 50,018  Say " Coluna (02) --> Quantidade                             "
@ 58,018  Say " Coluna (03) --> R$ Unitario                            "
@ 66,018  Say " Coluna (04) --> Prazo                                  "
@ 74,018  Say " Coluna (05) --> Tecnico                                "
@ 74,018  Say " Coluna (06) --> Obs Item                               "
@ 82,018  Say " Coluna (07) --> Referencia do Cliente                  "
@ 90,018  Say " Coluna (08) --> Pedido do Cliente                      "
@ 98,018  Say " Coluna (09) --> Item do Cliente                        " 
@ 106,018 say " Coluna (10) --> IPI									  "
*/

nBtLidos := 0
nTamFile := FSEEK(nHdl, 0, FS_END) //Troquei funcao de tamanho do arquivo
fSeek(nHdl,0,0) //resetando posicao do ponteiro                                          
ProcRegua(nTamFile) // Numero de registros a processar

               
While nBtLidos < (nTamFile -2)            //Caracteres de fim de arquivo                             
 	//Pega Linha a linha do arquivo  
    cBuffer  := Space(BLOCO) // Variavel para criacao da linha do registro para leitura
    fRead(nHdl,@cBuffer,BLOCO)
	
 	for nSize:=1 to len(cBuffer)
		//?????????????????????????????????????????????????????????????????????Ŀ
		//? Incrementa a regua                                                  ?
		//???????????????????????????????????????????????????????????????????????
		IncProc()
 	
 	  	if (Substr(cBuffer,nSize,1)=Chr(13))	    
   	      fSeek(nHdl, nBtLidos) 
   	      nSize	++
 	      exit                  	    
 	  	EndIf    
 	End             	 	 	
 	
 	fRead(nHdl,@cBuffer, nSize)  	  
	nBtLidos := nBtLidos + nSize
	
	//?????????????????????????????????????????????????????????????????????Ŀ
	//? Grava os campos obtendo os valores da linha lida do arquivo texto.  ?
	//???????????????????????????????????????????????????????????????????????
	//Valores Iniciais para busca dos campos
	      
	//Controles de quebra por ponto e virgula 
	nIni := 1 //Posicao inicial na linha
	nFim := 1 //Posicao Final na linha                          
	nPos := 1 //Campo do Vetor
	
	While .T.                      
      lPode:=.t.
      cCod:=""
      If (Substr(cBuffer, nFim, 1) != ';') .And. (Substr(cBuffer, nFim, 1) != Chr(13))  
        nFim ++
      else
        If (Substr(cBuffer, nIni, nFim-nIni)!=Chr(13)) .And. (Substr(cBuffer, nIni, nFim-nIni)!=";") //Se Campo cheio
        	aOrc[nPos] := Substr(cBuffer, nIni, nFim-nIni) //Alimenta
        else              
            aOrc[nPos] := ""      		                   //senao deixa em branco
        EndIf

		If (Substr(cBuffer, nFim, 1)==Chr(13)) //Fim da Linha sai do laco
		  exit                               
		Endif

		nPos ++		
		nFim ++
		nIni  := nFim		  
      Endif        
    End
    cCod:=""
    FOR xEsp:=1 to len(aOrc[1])
       IF SUBSTRING(aOrc[1],xEsp,1)=" " 
       else
        cCod:=cCod+SUBSTRING(aOrc[1],xEsp,1)
       endif   
    next
    if Len(cCod)>0 
      aOrc[1]:=cCod
    endif  
    dbSelectArea("SB1")
	dbSetOrder(1)
 	if dbSeek(xFilial()+aOrc[1])     
	Else              
			MsgAlert("Produto "+ aOrc[1] +" inexistente.... Incluindo!")	
			dbSelectArea("SBP")
			DBGOTOP()
			cCod:=A093MontaCod(aOrc[1],.T.)
			if len(trim(cCod))>0 
			  aOrc[1]:=cCod
			  A093VldCod(cCod,.T.)
			else
			  A093VldCod(aOrc[1],.T.)
			endif
			dbSelectArea("SB1")
			dbSetOrder(1)
            IF dbSeek(xFilial()+aOrc[1])
            else
              MsgAlert("Produto "+ aOrc[1] +" Impossivel de ser incluido!")	
              lpode:=.f.
            endif      
	EndIf	                     	
	If (lPode=.t.)
 	  cDocumento := GetSxENum("SD3","D3_DOC",1)
      lMsErroAuto := .F.
      aAuto := {}
      
      
      aAdd(aAuto,{cDocumento,ddatabase})
      aAdd(aAuto,{aOrc[1]+space(15-len(aOrc[1])),;                                               //1 Prod.Orig.
                  	POSICIONE("SB1",1,XFILIAL("SB1")+aOrc[1]+space(15-len(aOrc[1])),"B1_DESC"),; //2 Desc.Orig.
                  	POSICIONE("SB1",1,XFILIAL("SB1")+aOrc[1]+space(15-len(aOrc[1])),"B1_UM")  ,; //3 Unidade Medida                                                                        //3 UM Orig.
					aOrc[3],; 																	  //4 Armazem Or
					"",; 																		  //5 Endereco O
				    aOrc[1]+space(15-len(aOrc[1])),; 											  //6 Prod.Desti
					POSICIONE("SB1",1,XFILIAL("SB1")+aOrc[1]+space(15-len(aOrc[1])),"B1_DESC"),; //7 Desc.Desti
					POSICIONE("SB1",1,XFILIAL("SB1")+aOrc[1]+space(15-len(aOrc[1])),"B1_UM"),;   //8 UM Destino
					aOrc[4],;																	  //9 Armazem De
					"",; 																		  //10 Endereco D
					"",; 																		  //11 Numero Ser
					"",; 																		  //12 Lote
					"",; 																		  //13 Sub-Lote
					ddatabase,;																	  //14 Validade
					000.00,; 																	  //15 Potencia
			   		val(aOrc[5]),; 																  //16 Quantidade
					val(aOrc[5]),; 																  //17 Qt 2aUM
					"",; 																		  //18 Estornado
					"",; 																		  //19 Sequencia
					"",; 																		  //20 Lote Desti
					ddatabase,;																	  //21 Validade D
					"",;																		  //22 Item Grade
					"Criado p/Carga",;                                                            //23 observacao
					"",;                                                                          //24 lotefor 1
					""}) 																	      //25 lotefor 2

	  MSExecAuto({|x,y| mata261(x,y)},aAuto,3)													//inclus?o
	  If lMsErroAuto
	  	ConOut("Erro na inclusao!")
	  	MostraErro()
	  else
	    cItem := Soma1(cItem)
      endif
      // MsUnlock("TMP1")
    Else 
      MsgAlert("Tamanho do registro iniciado em "+ aOrc[1] +" inv?lido !")		  
    EndIf

End

//?????????????????????????????????????????????????????????????????????Ŀ
//? O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ?
//? cao anterior.                                                       ?
//???????????????????????????????????????????????????????????????????????

FClose(nLog)
fClose(nHdl)                
RestArea(aArea)
/*for x:=1 to nAcols-1
For nCntFor := 1 To nUsado-2
	    Do Case
			Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRODUTO" )
				A120PRODUTO(aCols[x,nCntFor])
	   		Case ( AllTrim(aHeader[nCntFor,2]) == "C7_QUANT" )
	   		    //A120QUANT(aCols[x,nCntFor])
		   	Case ( AllTrim(aHeader[nCntFor,2]) == "C7_PRECO" )
			    //A120PRECO(aCols[x,nCntFor]) 
            OtherWise
				aCols[x,nCntFor] := CriaVar(aHeader[nCntFor,2],.T.)
				// Template GEM
				// Retorna os valores para o campos criados pelo template
			EndCase
	  Next nCntFor   	 
next x
*/
Close(oLeTxt)               
Return


/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ? AbreArq  ? Autor ? AP5 IDE            ? Data ?  29/01/07   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Abre janela para selecao do arquivo a ser importado,       ???
???          ? retornando seu path                                        ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static function AbreArq()
cArqTxt:= cGetFile("*.csv|*.csv","Importacao de Or?amento",1,"C:\",.F.,GETF_LOCALHARD) //"Selecione um arquivo"
//("*.csv|*.csv","Importacao de Or?amento",0,"C:\",.F.,0)
If Empty(cArqTxt)
	Return .F.
EndIf
cArqTxt = ALLTRIM(cArqTxt)
return (cArqTxt)   