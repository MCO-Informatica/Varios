#Include "rwmake.ch"
#INCLUDE "IMPIRPF.CH"
#define  CRLF chr(13)+chr(10)
/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���RdMake    � IMPIRPF  � Autor � R.H. - Recursos Humano    � Data � 26.01.98 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao da DIRF em Formulario Continuo                       ���
�����������������������������������������������������������������������������Ĵ��
���Sintaxe e � DIRFPF                                                         ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � RdMake                                                         ���
�����������������������������������������������������������������������������Ĵ��
���Programar � Data   � BOPS     �  Motivo da Alteracao                       ���
�����������������������������������������������������������������������������Ĵ��
���Cristina  �03/06/98�xxxxxx    � Conversao para outros idiomas              ���
���Aldo      �15/01/98�          � Alteracao do Lay-Out para 1998.            ���
���Mauro     �21/01/00�          � Alteracao do Lay-Out para 1999.            ���
���Marina    �30/08/00�          � Retirada parte DOS.                        ���
���Natie     �05/02/02�          � Inclusao Impressao grafica                 ���
���Emerson   �08/02/02�          � Inversao dos valores de "Indenizacao de    ���
���          �        �          � Rescisao" e "Outros" na impressao grafica. ���
���Andreia   �07/03/03�062850    � Acerto na impressao do quadro 6 para que as���
���          �        �          � informacoes nao saiam fora do quador( Impr.���
���          �        �          � Grafica).                                  ���
���          �        �          � Verificacao do numero de linhas a serem    ���
���          �        �          � impressas para fazer a quebra de pagina.   ���
��|          �08/04/04�----------� Acerto no Driver para Impressao            ���
���Andreia   �28/01/05�          � Ajuste para imprimir valores referentes a  ���
���          �        �          � exigibilidade suspensa e deposito judicial.���
���Andreia   �11/02/05�          � Ajuste para imprimir valores de informacoes���
���          �        �          � complementares, mesmo sem valor.           ���
���Andreia   �16/01/06�091090    �Atualizacao para DIRF 2006. Passa a arma-   ���
���          �        �          �zenar o historico das declaracoes. Criado   ���
���          �        �          �o campo R4_ANO, e criada a tabela RCS para  ���
���          �        �          �armazenar as informacoes complementares.    ���
���Andreia   �07/02/07�118680    �Alteracao do texto de aprovacao pela IN/SRF.���
���Andreia   �11/01/08�136901    �Atualizacao para dirf 2008.                 ���
���Renata    �21/01/09�08254/2008�Ajuste msg qdo existe Exigibilidade         ���
���		     �        �01374/2009�suspensa.                                   ���
���Renata    �02/03/09�05130/2009�Ajuste na paginacao dos valores da contrib.,���
���          �        �          �pensao, etc ..  ara nao incluir a exigib.   ���
���          �        �          �suspensa.		      					      ���
�����������������������������������������������������������������������������Ĵ��
���Programador � Data   � FNC     �  Motivo da Alteracao					  ���
�����������������������������������������������������������������������������Ĵ��
���Luis Ricardo�17/01/11�018489/10�Tratamento dos campos relacionados as	  ���
���Cinalli     �        �         �informacoes complementares para DIRF/2011. |��
���Luis Ricardo�21/01/11�001528/11�Ajustes para separacao dos informes no RH  ���
���Cinalli     �        �    e    �Online qdo o funcionario possui contrato   |��
���            �        �018489/10�de residente no exterior.				  |��
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������/*/
User Function Impirpf()        // incluido pelo assistente de conversao do AP5 IDE em 05/07/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
                                                             
SetPrvt("CDESEMP,CDESEND,CDESCID,CUF,CTPINSC,CTELEF")
SetPrvt("CDESCEP,CCOMPLEMENTO,CCOMPL1,")

cDesEmp 	:= aInfo[3]
cDesEnd 	:= aInfo[4]
cDesCid 	:= aInfo[5]
cUf	  		:= aInfo[6]
cTpInsc 	:= Str(aInfo[15],1)
cTelef  	:= aInfo[10]
cDesCep 	:= ainfo[7]                  

cDescOred	:= If(empty(cDescOred),space(50),Left(cDescOred+space(50),50))

If nTipRel== 1
	fIrpfPre()
ElseIf nTipRel== 2
	fIrpfGraf()    
Else
	cHtml := fIrpfHtml( lPulaHtml )
Endif		

Return If(nTipRel == 3, cHtml, Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIrpfPre  �Autor  �Microsiga           � Data �  02/05/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao Comprovante de rendimentos e retencao do Imp.Renda���
���          �Fonte - Formulario Pre Impresso                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fIrpfPre()
Local nx		:= 1
Local nQuebraLin:= 0

CL := "-"
cB := "|"

SET DEVICE TO PRINT
@ 00,00 PSAY AvalImp( Colunas ) 
@ 01,00 PSAY " " + Replicate(cL,78) + " "
@ 02,00 PSAY STR0001	//"|         MINISTERIO DA FAZENDA         |   COMPROVANTE DE RENDIMENTOS PAGOS   |"
@ 03,00 PSAY STR0002	//"|                                       |          E DE RETENCAO DE            |"
@ 04,00 PSAY STR0003	//"|     SECRETARIA DA RECEITA FEDERAL     |      IMPOSTO DE RENDA NA FONTE       |"
@ 05,00 PSAY STR0004+mv_par08+")"+SPACE(9)+cB //"|                                       |      (ANO CALENDARIO - "
@ 06,00 PSAY " " + Replicate(cl,78) + " "

@ 08,00 PSAY STR0005 	//"  1. - Fonte Pagadora Pessoa Juridica ou Pessoa Fisica"
@ 09,00 PSAY " " + Replicate(cl,78) + " "
@ 10,00 PSAY STR0006 // "| Nome Empresarial/Nome                          | CNPJ/CPF                    |"
@ 11,00 PSAY "| "+PADR(cDesEmp,47)+"| "+PADR(cCgc,28)+cB
@ 12,00 PSAY " " + Replicate(cL,78) + " "

If !empty(cFil_Mat)
	@ 14,00 PSay STR0011+PADL((cFil_Mat),29)							//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
Else
	If SRL->(FieldPos("RL_CC"))== 0
		@ 14,00 PSAY STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT),29)	//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
	Else
		@ 14,00 PSAY STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT+"-"+SRL->RL_CC),29)	//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
	EndIf
EndIf	
@ 15,00 PSAY " " + Replicate(cL,78) + " "
@ 16,00 PSAY STR0012 + " "+ SRL->RL_CPFCGC + "   " + STR0013 + " "+PADR(SRL->RL_BENEFIC,40) + cB	//"| CPF:" ### "NOME COMPLETO:"
@ 17,00 PSAY cB + Replicate(cL,78) + cB
@ 18,00 PSAY STR0014 +" "+PADR(SRL->RL_CODRET + "-" + cDescRet,53) + cB // "| NATUREZA DO RENDIMENTO:"
@ 19,00 PSAY " " + Replicate(cL,78) + " "

@ 21,00 PSAY STR0015	//"  3. - Rendimentos Tributaveis, Deducoes e Imposto Retido na Fonte       R$    "
@ 22,00 PSAY " " + Replicate(cL,78) + " "
@ 23,00 PSAY STR0016 + cB + Space(5) + Transform(Round(nTotRend,2)     ,"@E 99,999,999.99") + Space(1) + cB	//"| 01. Total dos Rendimentos (Inclusive Ferias)             "
@ 24,00 PSAY STR0017 + cB + Space(5) + Transform(Round(aTotLetra[02],2),"@E 99,999,999.99") + Space(1) + cB	//"| 02. Contribuicao Previdenciaria Oficial                  "
@ 25,00 PSAY STR0018 + cB + Space(5) + Transform(Round(aTotLetra[03],2),"@E 99,999,999.99") + Space(1) + cB	//"| 03. Contribuicao a Previdencia Privada                   "
@ 26,00 PSAY STR0019 + cB + Space(5) + Transform(Round(aTotLetra[04],2),"@E 99,999,999.99") + Space(1) + cB	//"| 04. Pensao Alimenticia (Informar Benefic. no Campo 06)   "
@ 27,00 PSAY STR0021 + cB + Space(5) + Transform(Round(nTotRetido,2)   ,"@E 99,999,999.99") + Space(1) + cB	//"| 06. Imposto de Renda Retido 							  "
@ 28,00 PSAY " " + Replicate(cL,78) + " "

@ 30,00 PSAY STR0022	//"  4. - Rendimentos Isentos e Nao Tributaveis                             R$    "
@ 31,00 PSAY " " + Replicate(cL,78) + " "
@ 32,00 PSAY STR0024 + cB + Space(5) + Transform(Round(aTotLetra[08],2),"@E 99,999,999.99") + Space(1) + cB	//"| 01. Parte dos Proventos Aposentadoria,Reforma ou Pensao  "
@ 33,00 PSAY STR0025	+ cB + Space(5) + Transform(Round(aTotLetra[09],2),"@E 99,999,999.99") + Space(1) + cB	//"| 02. Diarias e Ajudas de Custo                            "
@ 34,00 PSAY STR0026 + cB + Space(5) + Transform(Round(aTotLetra[10],2),"@E 99,999,999.99") + Space(1) + cB	//"| 03. Pensao, Prov.de Aposent.ou Reforma por Molestia Grave"
@ 35,00 PSAY STR0027 + cB + Space(5) + Transform(Round(aTotLetra[11],2),"@E 99,999,999.99") + Space(1) + cB	//"| 04. Lucro e Dividendo a partir de 1996 pago por PJ       "
@ 36,00 PSAY STR0028 + cB + Space(5) + Transform(Round(aTotLetra[12],2),"@E 99,999,999.99") + Space(1) + cB	//"| 05. Val.Pagos Tit./Soc.Micro-Emp. exceto Pro-Labore      "
@ 37,00 PSAY STR0023 + cB + Space(5) + Transform(Round(aTotLetra[07],2),"@E 99,999,999.99") + Space(1) + cB	//"| 06. Indenizacao por Rescisao Inc.a Tit.PDV e Acid.Trab.  "
@ 38,00 PSAY STR0029 + "("+Subs(cDescOred,1,44)+ ")" + cB + Space(5) + Transform(Round(aTotLetra[13],2),"@E 99,999,999.99") + Space(1) + cB	//"| 07. Outros                                               "
@ 39,00 PSAY " " + Replicate(cL,78) + " "

@ 41,00 PSAY STR0030	//"  5. - Rendimentos Sujeitos a Tributacao Exclusiva (Rend.Liquido)        R$    "
@ 42,00 PSAY " " + Replicate(cL,78) + " "
@ 43,00 PSAY STR0031 + cB + Space(5) + Transform(Round(nLiq13o,2),"@E 99,999,999.99") + Space(1) + cB	//"| 01. Decimo Terceiro Salario                              "
@ 44,00 PSAY STR0032 + cB + Space(5) + Transform(Round(aTotLetra[17],2),"@E 99,999,999.99") + Space(1) + cB	//"| 02. Outros                                               "
@ 45,00 PSAY " " + Replicate(cL,78) + " "

nLin := 47

If (nLinhas + 7 +nLin )>=63
	@ 01,00 PSAY " " + Replicate(cL,78) + " "
	@ 02,00 PSAY STR0001	//"|         MINISTERIO DA FAZENDA         |   COMPROVANTE DE RENDIMENTOS PAGOS   |"
	@ 03,00 PSAY STR0002	//"|                                       |          E DE RETENCAO DE            |"
	@ 04,00 PSAY STR0003	//"|     SECRETARIA DA RECEITA FEDERAL     |      IMPOSTO DE RENDA NA FONTE       |"
	@ 05,00 PSAY STR0004+mv_par08+")"+SPACE(9)+cB //"|                                       |      (ANO CALENDARIO - "
	@ 06,00 PSAY " " + Replicate(cl,78) + " "
	nLin := 08
EndIf

@ nLin,00 PSAY STR0033	//"  6. - Informacoes Complementares                                        R$     "
nLin ++
@ nLin,00 PSAY " " + Replicate(cL,78) + " "
nLin ++

If len(aComplem) > 0
	If Ascan(aComplem,{|x| Subs(x[3],18,1) == "W" .or. Subs(x[3],18,1) == "2"} ) > 0                          
		@ nLin,00 PSAY "| "+ SUBSTR(STR0064,1,62) + " |"
		nLin++
		@ nLin,00 PSAY "| "+ SUBSTR(STR0064,64,43) + SUBSTR(STR0065,1,21) + " |"
		nLin++
		@ nLin,00 PSAY "| "+ SUBSTR(STR0065,23,61) + "-" + " |"
   		nLin++
		@ nLin,00 PSAY "| "+ SUBSTR(STR0065,84,24) +  SUBSTR(STR0066,1,40) + space(5) + " |"
   		nLin++
	EndIf
EndIf	

aSort( aComplem,,,{ |x,y| x[4] < y[4] } )

/* com quebra de linha forcada
For nx := 1 to len(aComplem)
    If Len( aComplem[nx,1] ) > 80
    	nQuebraLin := If( At( " - Ass.", aComplem[nx,1] ) > 0, At( " - Ass.", aComplem[nx,1] ), 90 )
		@ nLin,00 PSAY "| "+ strzero(nx,02)+". "+ Substr( aComplem[nx,1], 1, nQuebraLin ) + cB + TRANSFORM(acomplem[nX,2],"@E 99,999,999.99") +" |"
		nLin++
		@ nLin,00 PSAY "| "+ "      "+ Substr( aComplem[nx,1], nQuebraLin + 1, Len( aComplem[nx,1] ) ) + cB + Space( 13 ) +" |"
	Else
		@ nLin,00 PSAY "| "+ strzero(nx,02)+". "+ aComplem[nx,1] + cB +TRANSFORM(acomplem[nX,2],"@E 99,999,999.99") +" |"
    EndIf
	nLin++
Next*/

For nx := 1 to len(aComplem)
	@ nLin,00 PSAY "| "+ strzero(nx,02)+". "+ aComplem[nx,1] + cB +TRANSFORM(acomplem[nX,2],"@E 99,999,999.99") +" |"
	nLin++	                                      
Next

@ nLin,00 PSAY " " + Replicate(cL,78) + " "
nLin +=2
@ nLin,00 PSAY STR0034	//"  7. - Responsavel Pelas Informacoes"
nLin++
@ nLin,00 PSAY " " + Replicate(cL,78) + " "
nLin++
@ nLin,00 PSAY cB+" " + PADR(cResponsa+space(5)+DtoC(dDataBase),77) + cB
nLin++
@ nLin,00 PSAY " " + Replicate(cL,78) + " "
nLin++
@ nLin,00 PSAY " " + STR0035	// "Aprovado pela IN/SRF No. 120/2000, com altera��es da IN/SRF n} 288/2003"
SET DEVICE TO SCREEN


/*

LAY-OUT MODELO
 ------------------------------------------------------------------------------ 
|         MINISTERIO DA FAZENDA         |   COMPROVANTE DE RENDIMENTOS PAGOS   |
|                                       |          E DE RETENCAO DE            |
|     SECRETARIA DA RECEITA FEDERAL     |      IMPOSTO DE RENDA NA FONTE       |
|                                       |      (ANO CALENDARIO - 9999)         |
 ------------------------------------------------------------------------------ 
  1. - Fonte Pagadora Pessoa Juridica ou Pessoa Fisica    
 ------------------------------------------------------------------------------ 
| Nome Empresarial/Nome                            CNPJ/CPF                    |
| XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX         99999999999999              |
 ------------------------------------------------------------------------------ 

  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS                    01-000000
 ------------------------------------------------------------------------------ 
| CPF: 99999999999   NOME COMPLETO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   |
|                                                                              |
| NATUREZA DO RENDIMENTO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   |
 ------------------------------------------------------------------------------ 

  3. - Rendimentos Tributaveis, Deducoes e Imposto Retido na Fonte       R$    
 ------------------------------------------------------------------------------ 
| 01. Total dos Rendimentos (Inclusive Ferias)             |              0,00 |
| 02. Contribuicao Previdenciaria Oficial                  |              0,00 |
| 03. Contribuicao a Previdencia Privada                   |              0,00 |
| 04. Pensao Alimenticia (Informar Benefic. no Campo 06)   |              0,00 |
| 05. Imposto Retido na Fonte                              |              0,00 |
 ------------------------------------------------------------------------------ 

  4. - Rendimentos Isentos e Nao Tributaveis                             R$    
      123456789012345678901234567890   12345678901234
 12345678901234567890123456789012345678901234567890123456789012345678901234567890
 ------------------------------------------------------------------------------ 
| 01. Salario Familia                                      |              0,00 |
| 02. Parte dos Proventos Aposentadoria,Reforma ou Pensao  |              0,00 |
| 03. Diarias e Ajudas de Custo                            |              0,00 |
| 04. Prov. de Pensao, Aposent. ou Reforma por Inval.Perm  |              0,00 |
| 05. Lucro e Dividendo de 1996 pago por PJ                |              0,00 |
| 06. Val.Pagos Tit./Soc.Micro-Emp. exceto Pro-Labore      |              0,00 |
| 07. Outros (especificar)                                 |              0,00 |
 ------------------------------------------------------------------------------ 

  5. - Rendimentos Sujeitos a Tributacao Exclusiva (Rend.Liquido)        R$    
 ----------------------------------------------------------+------------------- 
| 01. Decimo Terceiro Salario                              |              0,00 |
| 02. Outros                                               |              0,00 |
 ----------------------------------------------------------+------------------- 

  6. - Informacoes Complementares                                        R$     
 ------------------------------------------------------------------------------ 
|ASSISTENCIA MEDICA                                                            |
|                                                                              |
|                                                                              |
|                                                                              |
|                                                                              |
 ------------------------------------------------------------------------------ 

  7. - Responsavel Pelas Informacoes
 ------------------------------------------------------------------------------ 

| NOME                                 DATA                   ASSINATURA       |
| XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     99/99/99                                  |
 ------------------------------------------------------------------------------ 
 Aprovado pela IN/SRF No. 120/2000, com altera��es da IN/SRF n} 288/2003
*/

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 04/02/00

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIrpfGraf �Autor  �Microsiga           � Data �  02/05/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao Comprovante de rendimentos e retencao do Imp.Renda���
���          �Fonte - Formulario Grafico                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  fIrpfGraf()

Local cFileFaz	 := ""
Local cStartPath := GetSrvProfString("Startpath","")
Local N 		 := 0     
Local lExigi	 := .F.
Local nQuebraLin := 0

oPrint:StartPage() 			// Inicia uma nova pagina

/*��������������������������������������������������������������Ŀ
  �Cabecalho                                                     �
  ����������������������������������������������������������������*/

cFileFaz 	:= cStartPath+ "RECEITA" + ".BMP" 		// Empresa+Filial

nLin := 030
nLinI:= 030
//���������Ŀ
//�Cabecalho�
//�����������
nLin +=20 
oPrint:Box( nLinI,0030,nLin+190,2350)  				// box Cabecalho 
oPrint:Line(nLinI,1450,nLin+190,1450)				// Linha Div.Cabecalho
If File(cFileFaz)
	oPrint:SayBitmap(nLinI+10,050, cFileFaz,235,195) // Tem que estar abaixo do RootPath
Endif
nLin +=20
oPrint:say(nLin,500 ,STR0036,oFont13n)				//	ministerio da fazenda 
oPrint:Say(nLin,1500,STR0038,oFont10)				//Comprovante de rendimento
nLin +=50
oPrint:say(nLin+10,500 ,STR0037,oFont13)			//secretaria de receita
oPrint:Say(nLin,1500,STR0039,oFont10)              //Retencao de rendimentos
nLin +=50
oPrint:Say(nLin,1560,STR0040,oFont10) 				//ano calendario
oPrint:Say(nLin,1950,mv_par08,oFont10n)    		  	//ano  base
oPrint:Say(nLin,2035,")",ofont10)
 
//�������������������
//�1. Fonte pagadora�
//�������������������
nLin +=100
oPrint:Say(nLin,040,STR0005,oFont12n) 			 	//"  1. - Fonte Pagadora Pessoa Juridica ou Pessoa Fisica"
nLin +=60
nLinI:=nLin -10
oPrint:Box(nLinI ,0030,nLin + 120,2350)				//box
oPrint:Line(nLinI,1800,nLin + 120,1800)

oPrint:Say(nLIn,040,STR0041,ofont08) 				//Nome  empresarial
oPrint:Say(nLin,1950,STR0042,oFont08)				//CPF/CNPJ
nLin+=50 
oPrint:Say(nLin,050,PADR(cDesEmp,100),oFont10)
oPrint:Say(nLin,1960,PADR(cCgc,100),oFont10)

//�������������������������Ŀ
//�2. Pessoa fisica/benefic.�
//���������������������������
nLin+=100
If !empty(cFil_Mat)
	oPrint:Say(nLin,040, STR0011+PADL((cFil_Mat),29), oFont12n) 							//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
Else
	If SRL->(FieldPos("RL_CC"))== 0
		oPrint:Say(nLin,040, STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT),29), oFont12n) 							//"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
	Else
		oPrint:Say(nLin,040, STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT+"-"+SRL->RL_CC),29), oFont12n)			     //"  2. - PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS "
	EndIf
EndIf
nLin +=60  
nLinI:=nLin - 10

oPrint:Box(nLinI,030,nLin+220,2350)						//box

oPrint:Say(nLin,040,STR0043,oFont08)								//cpf
oPrint:Say(nLin,440,STR0013,oFont08)        						//Nome  completo
nLin +=50
oPrint:Say(nLin,050,SRL->RL_CPFCGC ,oFont10)
oPrint:Say(nLin,450,PADR(SRL->RL_BENEFIC,140),oFont10)
nLin +=50
oPrint:Line(nLin,030,nLin,2350)									//Linha horizontal
oPrint:Line(nLinI,430,nLin,430)									//Linha vertical 
nLin +=20
oPrint:Say(nLin,040,STR0044,oFont08)								//Natureza do rendimento
nLin +=30
oPrint:Say(nLin,050,PADR(SRL->RL_CODRET + "-" + cDescRet,153),oFont10)

//��������������������������������������������
//�3. Rendimentos tributaveis/deducoes e irpf�
//��������������������������������������������
nLin +=100
oPrint:say(nLin,0040,left(STR0015,50),oFont12n)										//"  3. - Rendimentos Tributaveis, Deducoes e Imposto Retido na Fonte"
oPrint:Say(nLIn,1950,STR0050,oFont10n)

nLin +=60
nLinI:=nLin -10
oPrint:Box(nLinI ,0030,nLin + 400,2350)													//box
oPrint:Line(nLinI,1900,nLin + 400,1900)

nLin +=10
oPrint:Say(nLin,0040,STR0045,oFont10)											//1.Total de rendimentos(+ferias)
oPrint:Say(nLin,2000,Transform(Round(nTotRend,2),"@E 99,999,999.99"),oFont12) 	//"| 01. Total dos Rendimentos (Inclusive Ferias)"
nLin+=50
oPrint:Line(nLin,030,nLin,2350)

nLin+=30
oPrint:say(nLin,0040,STR0046,oFont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[02],2),"@E 99,999,999.99"), oFont12)	//"| 02. Contribuicao Previdenciaria Oficial "

nLin +=50
oPrint:Line(nLin,030, nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0047,oFont10)
oPrint:say(nLin,2000,Transform(Round(aTotLetra[03],2),"@E 99,999,999.99"),oFont12)		//"| 03. Contribuicao a Previdencia Privada"
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0048,ofont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[04],2),"@E 99,999,999.99"),oFont12)		//"| 04. Pensao Alimenticia (Informar Benefic. no Campo 06)   "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin+=30
oPrint:Say(nLin,0040,STR0049,oFont10)
oPrint:Say(nLin,2000,Transform(Round(nTotRetido,2),"@E 99,999,999.99"),oFont12)		//"| 05. Imposto Retido na Fonte"

//������������������������������������������
//�4. Rendimentos Isentos e nao tributaveis�
//������������������������������������������
nLin += 100
oPrint:Say(nLin,0040,left(STR0022,50),oFont12n)	   									//"  4. - Rendimentos Isentos e Nao Tributaveis"
oPrint:Say(nLIn,1950,STR0050,oFont10n)

nLin +=60
nLinI:=nLin -10
oPrint:Box(nLinI ,0030,nLin + 560,2350)
oPrint:Line(nLinI,1900,nLin + 560,1900)

nLin +=10
oPrint:Say(nLin,0040,STR0052,oFont10)
oPrint:Say(nLin,2000,Transform(Round((aTotLetra[08]+aTotLetra[43]),2),"@E 99,999,999.99"),oFont12)		//"| 01. Parte dos Proventos Aposentadoria,Reforma ou Pensao  "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0053,oFont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[09],2),"@E 99,999,999.99"),oFont12)		//"| 02. Diarias e Ajudas de Custo  "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0054,ofont10)
oPrint:Say(nLin,2000,Transform(Round((aTotLetra[10]+aTotLetra[42]),2),"@E 99,999,999.99"),oFont12)		//"| 03. Pensao, Prov.de Aposent.ou Reforma por Molestia Grave"
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0055,oFont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[11],2),"@E 99,999,999.99"),oFont12)		//"| 04. Lucro e Dividendo a partir de 1996 pago por PJ       "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0056,oFont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[12],2),"@E 99,999,999.99"),oFont12)		//"| 05. Val.Pagos Tit./Soc.Micro-Emp. exceto Pro-Labore      "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0051,oFont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[07],2),"@E 99,999,999.99"),oFont12)		//"| 06. Indenizacao por Rescisao Inc.a Tit.PDV e Acid.Trab.  "
nLin +=50
oPrint:Line(nLin,030,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0057+"("+Subs(cDescOred,1,45)+")",oFont10)
oPrint:Say(nLin,2000,Transform(Round((aTotLetra[13]+aTotLetra[41]),2),"@E 99,999,999.99"),oFont12)		//"| 07. Outros                                               "
//������������������������������������������������Ŀ
//�5.  Rendimentos sujeitos a tributacao exclusiva �
//��������������������������������������������������
nLin +=100
oPrint:Say(nLin,0040,left(STR0030,50),oFont12n)								  					//"  5. - Rendimentos Sujeitos a Tributacao Exclusiva (Rend.Liquido)        R$    "
oPrint:Say(nLIn,1950,STR0050,oFont10n)

nLin +=60 
nLinI:=nLin-10

oPrint:Box(nLinI ,0030,nLin+160,2350)
oPrint:Line(nLinI,1900,nLin+160,1900)

nLin +=10
oPrint:Say(nLIn,0040,STR0058,oFont10)
oPrint:Say(nLin,2000,Transform(Round(nLiq13o,2),"@E 99,999,999.99") ,oFont12)			//"| 01. Decimo Terceiro Salario "
nLin +=50
oPrint:Line(nLin,040,nLin,2350)

nLin +=30
oPrint:Say(nLin,0040,STR0059,ofont10)
oPrint:Say(nLin,2000,Transform(Round(aTotLetra[17],2),"@E 99,999,999.99"),oFont12)		//"| 02. Outros "

//�������������������������������
//�6. Informacoes complementares�
//�������������������������������

If len( aComplem ) > 0       
	If Ascan(aComplem,{|x| Subs(x[3],18,1) == "W" .or. Subs(x[3],18,1) == "2"} ) > 0                          
		lExigi := .T.
	EndIf
	aEval(aComplem,{|| nLinhas += 110 })
	
	If ( nLinhas + nLin + 280 ) > 3080
		oPrint:EndPage() 			// Finaliza a pagina
		//-- CABECALHO 
		oPrint:StartPage() 			// Inicia uma nova pagina
		nLin := 030
		nLinI:= 030
		nLin +=20 
		oPrint:Box( nLinI,0030,nLin+190,2350)  				// box Cabecalho 
		oPrint:Line(nLinI,1450,nLin+190,1450)				// Linha Div.Cabecalho
		If File(cFileFaz)
			oPrint:SayBitmap(nLinI+10,050, cFileFaz,235,195) // Tem que estar abaixo do RootPath
		Endif
		nLin +=20
		oPrint:say(nLin,500 ,STR0036,oFont13n)				//	ministerio da fazenda 
		oPrint:Say(nLin,1500,STR0038,oFont10)				//Comprovante de rendimento
		nLin +=50
		oPrint:say(nLin+10,500 ,STR0037,oFont13)			//secretaria de receita
		oPrint:Say(nLin,1500,STR0039,oFont10)             	//Retencao de rendimentos
		nLin +=50
		oPrint:Say(nLin,1560,STR0040,oFont10) 				//ano calendario
		oPrint:Say(nLin,1950,mv_par08,oFont10n)    			//ano  base
		oPrint:Say(nLin,2035,")",ofont10)
	EndIF
EndIF

nLin += 100

oPrint:Say(nLin,0040,left(STR0033,50),oFont12n)	//"  6. - Informacoes Complementares                                        R$     "

nLin   += 60
nLinI  := nLin - 10
nLin   += 10

If Empty( aComplem )
	nLin+=230
	oPrint:box(nLinI,0030,nLin ,2350) 
	oPrint:line(nLinI,1900,nLin ,1900)
Else 
	aSort( aComplem,,,{ |x,y| x[4] < y[4] } )

	nLinhas += nLin + 40

	// Ajusta nLinhas dependendo da quantidade de quebra de linha por complemento
	For n := 1 to len( aComplem )
    	nQuebraLin := At( " - Ass.", aComplem[n][1] )
    	If nQuebraLin == 0
	    	nQuebraLin := At( " - TITULAR - ", aComplem[n][1] )
    	EndIf

	    If nQuebraLin > 0
			nLinhas += 20
		EndIf
	Next n

	oPrint:box(nLinI,0030,nLinhas,2350)
	oPrint:line(nLinI,1900,nLinhas,1900)

	If lExigi
	    oPrint:say(nLin,0040,STR0064,oFont10)
   	    nLin +=45
	    oPrint:say(nLin,0040,STR0065,oFont10)
   	    nLin +=45
	    oPrint:say(nLin,0040,STR0066,oFont10)
		nLin +=45
	EndIf

	For n:= 1 to len(aComplem)
		// Quebra da informacao em duas linhas caso a descricao seja maior que 100 caracteres
    	nQuebraLin := At( " - Ass.", aComplem[n][1] )
    	If nQuebraLin == 0
	    	nQuebraLin := At( " - TITULAR - ", aComplem[n][1] )
    	EndIf

	    If nQuebraLin > 0
		    oPrint:say(nLin,0040,strzero(n,02)+". "+ Substr( aComplem[n,1], 1, nQuebraLin ), oFont10 )
			nLin +=40
		    oPrint:say(nLin,0100, Substr( aComplem[n,1], nQuebraLin + 1, Len( aComplem[n][1] ) ), oFont10 )
		 Else
		    oPrint:say(nLin,0040,strzero(n,02)+". "+ aComplem[n,1], oFont10 )
		 EndIf

	    oPrint:Say(nLin,2000,TRANSFORM(acomplem[n,2],"@E 99,999,999.99"),oFont10)
	    nLin +=45
		oPrint:line(nLinI,1900,nLin,1900)
		nLin +=25
	Next n 
Endif

//��������������������������������Ŀ
//�7. Responsavel pelas informacoes�
//����������������������������������
nLin 	:= If( Empty( aComplem ), nLin + 40, nLinhas + 40 )

oPrint:Say(nLin,0040,STR0034,ofont12n)			//"  7. - Responsavel Pelas Informacoes"
nLin	+=50 
oPrint:Box(nLin,0030,nLin + 100,2350)
oPrint:Line(nLin,1300,nLin+ 100,1300)
oPrint:Line(nLin,1540,nLin+ 100,1540)

nLin +=20
oPrint:say(nLin,0040,left(STR0041,4),oFont08)
oPrint:Say(nLin,1340,STR0060,oFont08)
oPrint:Say(nLin,1550,STR0061,oFont08)

nLin += 30
oPrint:say(nLin,0050,cResponsa,ofont10)
oPrint:say(nLin,1340,DtoC(dDataBase),oFont10)

nLin+=50
oPrint:say(nLin,0040,STR0035,oFont08)		// "Aprovado pela IN/SRF No. 120/2000, com altera��es da IN/SRF n} 288/2003"

oPrint:EndPage() 		// Finaliza a pagina

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIrpfHtml �Autor  �Tatiane V. Matias   � Data �  23/01/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao Comprovante de rendimentos e retencao do Imp.Renda���
���          �Fonte - HTML                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  fIrpfHtml()
Local n			:= 0
Local nTam		:= 0
Local nTamMais	:= 0
Local lExigi	:= .F.

// Var para controle de salto de pagina qdo ha mais de um html/informe para mesmo funcionario
Local lPulaHtml := If( Type( "lPulaHtml" ) # "U", lPulaHtml, .F. )

//Logo e Titulo
cFileFaz 	:= TcfRetDirImg() + "/receita.gif" //RECEITA.BMP

cHtml :=	'<html>' 

If cFrame = "2"               
	cHtml +='<STYLE TYPE="text/css"> '
	cHtml +='	.folha { '
	cHtml +='   		 page-break-after: always; '
	cHtml +='			} '
	cHtml +='</STYLE> '	
Endif

cHtml +=	 '<head>' 
cHtml +=	' <title>' + STR0063 + '</title>' 
cHtml +=	'  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' 
cHtml +=	'  <link rel="stylesheet" href="css/rhonline.css" type="text/css">' 

If cFrame = "1"               
	cHtml +=	'<script language="JavaScript">' + CRLF
	cHtml +=		'<!--' + CRLF
	cHtml +=			'function Imprimir()' + CRLF
	cHtml +=			'{' + CRLF
	cHtml +=				'var val_body1	= parent.mainFrame.document.body.innerHTML;' + CRLF
	cHtml +=				'var val_body2	= parent.bottomFrame.document.body.innerHTML;' + CRLF
	cHtml +=				'parent.mainFrame.document.body.innerHTML = val_body2;' + CRLF
	cHtml +=				'parent.mainFrame.print();' + CRLF
	cHtml +=				'parent.mainFrame.document.body.innerHTML = val_body1;' + CRLF
	cHtml +=			'}' + CRLF
	cHtml +=		' -->' + CRLF
	cHtml +=	'</script>' + CRLF
EndIf                       

cHtml +=	'</head>' 
cHtml +=	'<body bgcolor="#FFFFFF" text="#000000">' 
If cFrame = "1"               
	cHtml +=	'  <Table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">' 
Else
	cHtml +=	'  <Table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">' 
EndIf

If cFrame = "2" .and. lPulaHtml //	//Quebra de pagina no frame escondido qdo ha mais de um html/informe para mesmo funcionario
	cHtml +='<div class="folha"> '
   	CabecHtml(@cHtml)
	cHtml +='</div> '
Else
	CabecHtml(@cHtml)
Endif	

cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'			<b><span class="menu_titulo">' + STR0005 + '</span></b>' 
cHtml +=	'	</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="0">' 
cHtml +=	'			<tr><td width="70%">' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0041 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + PADR(cDesEmp,100) + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'			</td>' 
cHtml +=	'			<td width="30%">' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0042 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + PADR(cCgc,100) + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'			</td></tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD colspan="2">' 

If SRL->(FieldPos("RL_CC"))== 0
	cHtml +=	'			<b><span class="menu_titulo">' + STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT),29) + '</span></b>' 
Else
	cHtml +=	'			<b><span class="menu_titulo">' + STR0011+PADL((SRL->RL_FILIAL+"-"+SRL->RL_MAT+"-"+SRL->RL_CC),29) + '</span></b>' 
EndIf

cHtml +=	'	</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="0">' 
cHtml +=	'			<tr>' 
cHtml +=	'				<td width="20%">' 
cHtml +=	'				<table width="100%" border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0043 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + SRL->RL_CPFCGC + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'				</td>' 
cHtml +=	'				<td>' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0013 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + PADR(SRL->RL_BENEFIC,140) + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'				</td>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<td colspan="2">' 
cHtml +=	'				<table width="100%"  border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0044 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + PADR(SRL->RL_CODRET + "-" + cDescRet,153) + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'				</td>' 
cHtml +=	'			</tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD width="80%">' 
cHtml +=	'			<b><span class="menu_titulo">' + left(STR0015,50) + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'		<TD align="center">' 
cHtml +=	'			<b><span class="menu_titulo">' + STR0050 + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="2">' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0045 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(nTotRend,2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0046 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[02],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0047 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[03],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0048 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[04],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0049 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(nTotRetido,2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD width="80%">' 
cHtml +=	'			<b><span class="menu_titulo">' + left(STR0022,50) + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'		<TD align="center">' 
cHtml +=	'			<b><span class="menu_titulo">' + STR0050 + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="2">' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0052 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[08],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0053 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[09],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0054 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[10],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0055 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[11],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0056 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[12],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0051 + ' </span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[07],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0057+'('+Subs(cDescOred,1,45)+')' + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[13],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD width="80%">' 
cHtml +=	'			<b><span class="menu_titulo">' + left(STR0030,50) + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'		<TD align="center">' 
cHtml +=	'			<b><span class="menu_titulo">' + STR0050 + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="2">' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0058 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(nLiq13o,2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'			<tr>' 
cHtml +=	'				<TD width="80%"><span class="etiquetas_3">' + STR0059 + '</span></TD>' 
cHtml +=	'				<TD align="right"><span class="dados">' + Transform(Round(aTotLetra[17],2),"@E 99,999,999.99") + '</span></TD>' 
cHtml +=	'			</tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 

If Ascan(aComplem,{|x| Subs(x[3],18,1) == "W" .or. Subs(x[3],18,1) == "2"} ) > 0                          
	lExigi := .T.
EndIf	

nTam := len( aComplem )

//Quebra de pagina no frame escondido
If cFrame = "2"
                    
	nTamMais := 0
	// Determina a quantidade de linhas a mais para quebra de pagina dependendo das informacoes complementares a serem impressas
	For n := 1 to nTam
	   	If At( " - Ass.", aComplem[n][1] ) > 0 .or.  At( " - TITULAR - ", aComplem[n][1] ) > 0
			nTamMais++
		EndIf
	Next n

	If ( nTam + nTamMais ) > 14
		For n := 1 to 22
			cHtml +=	'	<TR><TD colspan="2">&nbsp;</TD></TR>' 
		Next n 
		CabecHtml(@cHtml)
	EndIf
EndIf

cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'			<b><span class="menu_titulo">' + left(STR0033,50) + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="0">' 
cHtml +=	'			<tr>' 
cHtml +=	'				<td>' 
cHtml +=	'					<table width="100%" border="0" cellspacing="3" >' 
                
If nTam = 0
		cHtml +=	'						<tr>' 
		cHtml +=	'                    <td width="80%"><span class="dados">&nbsp;</span></td>' 
		cHtml +=	'							<Td align="right"><span class="dados">&nbsp;</span></td>' 
		cHtml +=	'                  </tr>' 
Else
	If lExigi
			cHtml +=	'                    <td width="80%"><span class="dados">' + STR0064 + STR0065 + STR0066 + '</span></td>' 
			cHtml +=	'                  </tr>' 

	Endif
	For n:= 1 to nTam
		cHtml +=	'						<tr>' 
		cHtml +=	'                    <td width="80%"><span class="dados">' + STRZERO(n,02) + ". "+  aComplem[n,1] + '</span></td>' 
		cHtml +=	'							<Td align="right"><span class="dados">' + TRANSFORM(aComplem[n,2],"@E 99,999,999.99") + '</span></td>' 
		cHtml +=	'                  </tr>' 
	Next n 

EndIf
cHtml +=	'              </table>' 
                
cHtml +=	'				</td>' 
cHtml +=	'			</tr>' 
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2" height="10"></TD></TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'			<b><span class="menu_titulo">' + STR0034 + '</span></b>' 
cHtml +=	'		</TD>' 
cHtml +=	'	</TR>' 
cHtml +=	'	<TR><TD colspan="2">' 
cHtml +=	'		<table width="100%"  border="1" cellspacing="0" cellpadding="0">' 
cHtml +=	'			<tr><td width="65%">' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + left(STR0041,4) + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + cResponsa + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'			</td>' 
cHtml +=	'			<td width="15%">' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0060 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="dados">&nbsp;&nbsp;&nbsp;' + dDataInf + '</span></TD>'
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'			</td>' 
cHtml +=	'			<td width="20%">' 
cHtml +=	'				<table border="0" cellspacing="0" cellpadding="0">' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span class="etiquetas_2">' + STR0061 + '</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'					<TR>' 
cHtml +=	'						<TD><span>&nbsp;&nbsp;&nbsp;</span></TD>' 
cHtml +=	'					</TR>' 
cHtml +=	'				</table>' 
cHtml +=	'			</td></tr>'
cHtml +=	'		</table>' 
cHtml +=	'	</TD></TR>' 
cHtml +=	'	<TR><TD colspan="2"><span class="etiquetas_2">' + STR0035 + '</span></TD></TR>' 
cHtml +=	' </Table>'   

If cFrame = "1"
	cHtml += ' ***botaoframe***'
	cHtml += '<p &nbsp;</p>'
EndIf

cHtml +=	'</body>' 
cHtml +=	'</html>' 

Return cHtml

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CabecHtml �Autor  �Tatiane V. Matias   � Data �  23/01/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do cabecalho do Informe de Rendimento - HTML      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CabecHtml(cHtml)

	cHtml +=	'	<TR>' 
	cHtml +=	'		<TD  colspan="2">' 
	cHtml +=	'			<table width="100%"  border="1" cellspacing="0" cellpadding="0">' 
	cHtml +=	'			  <tr>' 
	cHtml +=	'				<td>' 
	cHtml +=	'					<table width="100%"  border="0" cellspacing="0" cellpadding="0">' 
	cHtml +=	'					  <tr align="center">' 
	cHtml +=	'						<td width="10%" rowspan="2" height="10%"><img src="' + cFileFaz + '" width="70" height="70" align=left></td>' 
	cHtml +=	'						<td><b><span class="titulo_opcao">' + STR0036 + '</span></b></td>' 
	cHtml +=	'					  </tr>' 
	cHtml +=	'					  <tr align="center">' 
	cHtml +=	'						<td><span class="texto_2">' + STR0037 + '</span></td>' 
	cHtml +=	'					  </tr>' 
	cHtml +=	'					</table>' 
	cHtml +=	'				</td>' 
	cHtml +=	'				<td>' 
	cHtml +=	'					<table width="100%"  border="0" cellspacing="0" cellpadding="0">' 
	cHtml +=	'					  <tr align="center">' 
	cHtml +=	'						<td><span class="menu_titulo_2">' + STR0038 + '</span></td>' 
	cHtml +=	'					  </tr>' 
	cHtml +=	'					  <tr align="center">' 
	cHtml +=	'						<td><span class="menu_titulo_2">' + STR0039 + '</span></td>' 
	cHtml +=	'					  </tr>' 
	cHtml +=	'					  <tr align="center">' 
	cHtml +=	'						<td><b><span class="menu_titulo_2">' + STR0040 + '  ' + cAno + ')</span></b></td>' 
	cHtml +=	'					  </tr>' 
	cHtml +=	'				  </table>' 
	cHtml +=	'				</td>' 
	cHtml +=	'			 </tr>' 
	cHtml +=	'			</table>' 
	cHtml +=	'		<TD>' 
	cHtml +=	'	</TR>' 

Return Nil

// Funcao para apresentar o botao da impressora no html
User Function BotImpIRPF()
Return( '<p align="right"><a href="javascript:Imprimir();"><img src="imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' )

// Funcao para trocar o indicador **botaoframe*** pelo tracejado separador dos INFORMES
User Function TracoDuplo()
Local cTracoDupl := ""

cTracoDupl += '	<p &nbsp;</p>'
cTracoDupl += '	<p &nbsp;</p>'
cTracoDupl += ' <table frame="above" width="100%"> '
cTracoDupl += ' 	<tr> '
cTracoDupl += ' 		<td width = "0%" style = "border-style: dotted" ></td> '
cTracoDupl += '			<p &nbsp;</p>'
cTracoDupl += ' 	</tr> '
cTracoDupl += ' </table> '

Return( cTracoDupl )
