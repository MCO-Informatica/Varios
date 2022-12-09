#INCLUDE "rwmake.ch"
#DEFINE PICT_VL  "@E 999,999,999.99"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIS005   บAutor  ณRen๊ Lopes			บ Data ณ  28/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio PCC	                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFIS005()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variaveisณ              
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู */


Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de mapa de imposto de INSS "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa de Imposto - PCC"
Local cPict          := ""
Local titulo       := "@Mapa de Imposto - PCC"
Local nLin         := 80

Local Cabec1       := "FORNECEDOR  NOME                                                           CNPJ                   NUMERO        BS.PCC      CD.RET       VL.PIS     VL.COF     VL.CSLL        VL.PCC    VCTO.TIT     VCTO.TX"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFIS005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIS005" // Coloque aqui o nome do arquivo usado para impressao em disco 
Private cPerg 	:= "RFIS005" 
Private cString := ""
 

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf     


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ฟ
//ณMonta a interface padrao com o usuario...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ู
*/

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento. RPTSTATUS monta janela com a regua de processamento.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNREPORT     บAutor  ณAP6 IDE         บ Data ณ  04/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem  
Local nValPis := 0
Local nValCof := 0
Local nValCsl := 0
Local cParcCof:= 0 
Local cParcPIS:= 0
Local cParCSLL:= 0
Local _aDados := {}
Local _aCabec := {}
Local cCodReten := 0  
Local dVencReal 
Local cPicture  := X3Picture("E2_NUMERO")

cAliasTrb := "TMP"

 BeginSql Alias cAliasTrb
  		
  	SELECT DISTINCT
		F1.F1_FORNECE COD_FOR,
		(SELECT A2.A2_NOME FROM SA2010 A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') NOME,
		(SELECT A2.A2_CGC FROM  SA2010 A2 WHERE A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = ' ') CNPJ,
		E2_NUM NUMERO, 
		E2_BASECSL BASEPCC,
		E2_PARCCOF,
		E2_PARCPIS,
		E2_PARCSLL,
		E2_COFINS VALCOF,
        E2_PIS VALPIS,
    	E2_CSLL VALCSL, 
    	E2.E2_PREFIXO PREFIXO,
		SUBSTR(E2.E2_VENCREA,7,2) ||'/'|| SUBSTR(E2.E2_VENCREA,5,2) ||'/'|| SUBSTR(E2.E2_VENCREA,1,4) VENC_REAL,
		E2.E2_PARCELA PARCELA,
		F1.F1_FILIAL FILIAL		
	FROM
		%Table:SE2% E2 LEFT OUTER JOIN %Table:SF1% F1 ON E2_NUM = F1_DOC AND 
		E2.E2_FORNECE = F1.F1_FORNECE AND E2.E2_LOJA = F1.F1_LOJA INNER JOIN 
		%Table:SD1% D1 ON D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = E2.E2_FORNECE AND D1.D1_LOJA = E2.E2_LOJA AND D1.D1_DOC= E2.E2_NUM 
	WHERE
		E2.E2_VENCREA >= %EXP:MV_PAR01% AND
		E2.E2_VENCREA <= %EXP:MV_PAR02% AND
		E2.E2_TIPO = 'NF' AND
		(E2.E2_VRETPIS <> 0 OR
		E2.E2_VRETCOF <> 0 OR
		E2.E2_VRETCSL <> 0 )AND
		D1.D_E_L_E_T_ = ' ' AND
		E2.D_E_L_E_T_ = ' ' AND
		F1.D_E_L_E_T_ = ' '
	ORDER BY NOME 
  	
 ENDSQL
  
DbSelectArea("TMP") 
TMP->(dbGoTop())

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSETREGUA -> Indica quantos registros serao processados para a reguaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

SetRegua(RecCount())   

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosicionamento do primeiro registro e loop principal. Pode-se criar  ณ
//ณa logica da seguinte maneira: Posiciona-se na filial corrente e pro  ณ
//ณcessa enquanto a filial do registro for a filial corrente. Por exem  ณ
//ณplo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:     ณ
//ณ                                                                     ณ
//ณdbSeek(xFilial())                                                    ณ
//ณWhile !EOF() .And. xFilial() == A1_FILIAL                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

While !TMP->(EOF())

	nValPis := TMP->VALPIS
	nValCof := TMP->VALCOF
	nValCsl := TMP->VALCSL
	cPrefix := TMP->PREFIXO
	//nSumPCC := nValCsl + nValCof + nValPis  
	cNumTit := TMP->NUMERO
	cParcCof:= TMP->E2_PARCCOF
	cParcPIS:= TMP->E2_PARCPIS
	cParCSLL:= TMP->E2_PARCSLL  //E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
	
	DbSelectArea("SE2")
	DbSetOrder(1) //E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE
	
	If nValPis > 0
		//DbSeek(xFilial("SE2")+Space(Len(SE2->E2_PREFIXO))+cNumTit+cParcPIS+"TX")
		If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParcPIS+"TX")
			nValPis := SE2->E2_VALOR
			dVencReal := SE2->E2_VENCREA 
			cCodReten := SE2->E2_CODRET
		Else
			nValPis   := 0
			dVencReal := CtoD("  /  /  ") 
			cCodReten := ""
		EndIf
	EndIf
	If nValCof > 0 
		If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParcCOF+"TX")
			nValCof := SE2->E2_VALOR
			dVencReal := SE2->E2_VENCREA 
			cCodReten := SE2->E2_CODRET
		Else
			nValCof   := 0
			dVencReal := CtoD("  /  /  ") 
			cCodReten := ""
		EndIf
	EndIf
	If nValCSL > 0 
		If DbSeek(xFilial("SE2")+cPrefix+cNumTit+cParCSLL+"TX")
	 		nValCSL := SE2->E2_VALOR 
	 		dVencReal := SE2->E2_VENCREA 
			cCodReten := SE2->E2_CODRET
		Else
			nValCSL   := 0
			dVencReal := CtoD("  /  /  ") 
			cCodReten := ""
		EndIf
	EndIf 
	
	nSumPCC := nValCsl + nValCof + nValPis
	
	aAdd(_aDados, 	{   TMP->COD_FOR,;
        				TMP->NOME,;
        				Transform(TMP->CNPJ, '@R 99.999.999/9999-99'),;
        				TMP->NUMERO,;
        			 	TMP->BASEPCC,; 
        			 	cCodReten,;
        				nValPis,;
        				nValCof,;
        				nValCSL,;
        				nSumPCC,;
        				TMP->Venc_Real,;                                                         	
        				dVencReal})      				 
   TMP->(dbSkip())    

EndDo
SE2->(dbCloseArea())
TMP->(dbCloseArea())

_aDados := aSort(_aDados,,,{|x,y| x[2] < y[2]}) 

nDados := Len(_aDados)
nCount := 1
Private aCols
Private nTotalNF := 0
Private nTotPCC  := 0

While nCount <= nDados


		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario... ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif            
   
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImpressao do cabecalho do relatorio. .ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
     If nLin > 55 // Salto de P๏ฟฝgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif
	
	 // Coloque aqui a logica da impressao do seu programa...
   	// Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
 		
 		
       //nLin := nLin + 1 // Avanca a linha de impressa
	    
        aCols := 1 
      	@nLin,02  PSAY _aDados[nCount][aCols]	
   		aCols++
   		@nLin,12  PSAY _aDados[nCount][aCols]	
		aCols++
		@nLin,75  PSAY _aDados[nCount][aCols] 		PICTURE "@R99.999.999/9999-99"
		aCols++
		@nLin,98  PSAY _aDados[nCount][aCols]  		PICTURE cPicture
		aCols++ 
		@nLin,107 PSAY _aDados[nCount][aCols]	 	PICTURE PICT_VL	
		aCols++ 
		@nLin,125 PSAY _aDados[nCount][aCols]  		  		
		aCols++  
		@nLin,129 PSAY _aDados[nCount][aCols]       PICTURE PICT_VL
		aCols++
		@nLin,141 PSAY _aDados[nCount][aCols]		PICTURE PICT_VL
		aCols++ 
		@nLin,152 PSAY _aDados[nCount][aCols]		PICTURE PICT_VL  
		aCols++
		@nLin,167 PSAY _aDados[nCount][aCols]		PICTURE PICT_VL
		aCols++
		@nLin,185 PSAY _aDados[nCount][aCols]
		aCols++ 
		@nLin,199 PSAY _aDados[nCount][aCols]
						
		
		nTotalNF  += _aDados[nCount][5] 
		nTotPCC += _aDados[nCount][10]
		//nTotalINS += _aDados[nCount][8]
		nLin++
		nCount++ 
		                  
Enddo     

@nLin,00 PSAY Replicate ("__",220)
nLin += 2
@nLin,82 PSAY "Total Base Calculo PCC: "
@nLin,107 PSAY nTotalNF PICTURE PICT_VL
@nLin,155 PSAY "Total Imposto: "
@nLin,167 PSAY nTotPCC Picture PICT_VL  
//@nLin,182 PSAY "Valor Total ISS: " 
//@nLin,195 PSAY nTotalINS PICTURE PICT_VL
//nLin += 2 
//@nLin,185 PSAY Replicate ("--",13)      

_aDados := aSort(_aDados,,,{|x,y| x[6] < y[6]})

nCount	  := 1 
nTotalPCC := 0 

nLin+= 3
@nLin,185 PSAY "|CD.RETENCAO|"
@nLin,200 PSAY "VL. TOTAL|"
nLin++
     
Private nCodRet:= _aDados[nCount][6]
  
While nCount <= Len(_aDados)
	
	If _aDados[nCount][6] <> nCodRet
		@nLin,185 PSAY "|"
		@nLin,188 PSAY nCodRet + "|"
		@nLin,196 PSAY nTotalPCC PICTURE PICT_VL
		@nLin,210 PSAY "|"
		nCodRet:= _aDados[nCount][6]
		nTotalPCC := 0
		nTotalPCC := 0
		nLin ++
	EndIf                           
	
	nTotalPCC += _aDados[nCount][10]
	nCount ++
	
Enddo

@nLin,185 PSAY "|"
@nLin,188 PSAY nCodRet + "|"
@nLin,196 PSAY nTotalPCC PICTURE PICT_VL
@nLin,210 PSAY "|"
nLin ++
@nLin,185 PSAY Replicate ("--",13)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆฟ
//ณ Abertura do Arquivo em EXCEL. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆู
*/

If mv_par03 == 1

	AAdd(_aCabec,"COD_FOR")
	AAdd(_aCabec,"NOME")
	AAdd(_aCabec,"CNPJ")
	AAdd(_aCabec,"NUMERO")
	AAdd(_aCabec,"BS.PCC")
	AAdd(_aCabec,"CD.RET")
	AAdd(_aCabec,"VL.PIS")
	AAdd(_aCabec,"VL.COF")
	AAdd(_aCabec,"VL.CSLL")
	AAdd(_aCabec,"VL.PCC")
	AAdd(_aCabec,"VCTO.TIT")
	AAdd(_aCabec,"VCTO.TX")
  
	Processa( {|| DlgToExcel({ {"ARRAY","Mapa de Impostos - @PCC", _aCabec,_aDados} }) }, "Exp. Mapa de Impostos","Aguarde, exportando para Excel...",.T.)
	
EndIf

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza a execucao do relatorio...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

SET DEVICE TO SCREEN

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe impressao em disco, chama o gerenciador de impressao...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusteSX1 บAutor  ณRene Lopes          บ Data ณ  17/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Dt. Venc Real De?         ","Dt. Venc Real De?         ","Dt. Venc Real De?         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Dt. Venc Real Ate?        ","Dt. Venc Real Ate?        ","Dt. Venc Real Ate?         ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Excel			 ","Excel              ","Excel             ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par03","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})


RestArea(aArea)