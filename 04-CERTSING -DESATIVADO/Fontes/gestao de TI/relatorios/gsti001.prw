#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RWMAKE.CH"      

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

User Function GSTI001()

//������������������������������������������������������������������������Ŀ
//�Define Variaveis                                                        �
//��������������������������������������������������������������������������
Local Titulo  := "Impress�o do Termo de Recebimento"
Local cDesc1  := "Este Programa ir� imprimir os Termos de Recebimento" 
Local cDesc2  := "das maquinas entregues considerando os parametros Informados." 
Local cDesc3  := "" //""  // Descricao 3
Local cString := "SRA"  // Alias utilizado na Filtragem
Local lDic    := .F. 	// Habilita/Desabilita Dicionario
Local lComp   := .T. 	// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. 	// Habilita/Desabilita o Filtro
Local wnrel   := "GSTI001"  	// Nome do Arquivo utilizado no Spool
Local nomeprog:= "GSTI001"  	// nome do programa

Private Tamanho := "M" // P/M/G
Private Limite  := 132 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private cPerg   := "GSTI01"  // Pergunta do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

Pergunte(cPerg,.F.) 

//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrinter                                                 �
//��������������������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)


If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

Processa({|lEnd| u_ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)

//---------------------------------------------------------------------------------------------------

User Function ImpDet()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

LOCAL oFont8  
LOCAL oFont11c
LOCAL oFont10 
LOCAL oFont10n
LOCAL oFont12 
LOCAL oFont12n
LOCAL oFont14 
LOCAL oFont14n
LOCAL oFont15 
LOCAL oFont15n
LOCAL oFont16n
LOCAL oFont20 
LOCAL oFont20c
LOCAL oFont21 
LOCAL oFont24 
LOCAL nI := 0
Local nLin := 0
Local nX   := 0   
Local cNF  := "" 
local cProd:= ""    
Local cMsg := ""
Local aBitmap_logo :=  "\system\lgrl01.bmp"
Local nIten := 0
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20c:= TFont():New("Courier New",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//������������������������������������������������������������������������Ŀ
//�Monta as tabelas para o relatorio                                       �
//��������������������������������������������������������������������������                

Montatab()


oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova p�gina    

nRow1 := 0

oPrint:SayBitmap(nRow1+0100,2000,aBitmap_logo,400,200)
oPrint:Say  (nRow1+0300,900,"TERMO DE RECEBIMENTO",oFont14n )
oPrint:Say  (nRow1+0500,300 ,"Eu, "+ALLTRIM(SRATMP->RA_NOME)+", "+ALLTRIM(SRATMP->NACIONAL)+", portador da Matricula "+SRATMP->RA_MAT+" ,CPF "+ALLTRIM(SRATMP->RA_CIC)+" ,",oFont12)
oPrint:Say  (nRow1+0570,200 ,"recebi na data abaixo um "+ALLTRIM(U00TMP->TIPO)+" marca "+ALLTRIM(U00TMP->U00_MARCA)+", modelo "+ALLTRIM(U00TMP->U00_DESHRD)+", s�rie "+ALLTRIM(U00TMP->U00_NUMSER)+", ativo numero "+ALLTRIM(U00TMP->U00_COMATV)+",  ",oFont12)
//oPrint:Say  (nRow1+0640,300 ,"
nRow1 := nRow1 - 70
oPrint:Say  (nRow1+0710,200 ,"de propriedade da empresa Certisign Certificadora Digital S/A, para uso exclusivamente em minhas " ,oFont12)
oPrint:Say  (nRow1+0780,200 ,"atividades profissionais. Declaro que � de minha inteira responsabilidade mant�-lo em condi��es ideais",oFont12)
oPrint:Say  (nRow1+0850,200 ,"de uso zelando por sua conserva��o e, tamb�m, avisar ao setor de T.I. sobre qualquer perda ou avaria",oFont12)
oPrint:Say  (nRow1+0920,200 ,"no mesmo.",oFont12)
//oPrint:Say  (nRow1+1000,300 ,"",oFont12)
nRow1 := nRow1 - 70
oPrint:Say  (nRow1+1070,200 ,"Ainda, comprometo-me em devolv�-lo no meu desligamento da empresa, ou a qualquer momento que",oFont12)
oPrint:Say  (nRow1+1140,200 ,"me for solicitado, nas mesmas condi��es entregue neste momento.",oFont12)
//oPrint:Say  (nRow1+1210,300 ,"",oFont12)
nRow1 := nRow1 - 70                                                  
oPrint:Say  (nRow1+1280,200 ,"N�o � permitida a instala��o de nenhum aplicativo sem pr�via autoriza��o da equipe de INFRAESTRUTURA. ",oFont12)
oPrint:Say  (nRow1+1350,200 ,"A instala��o de softwares n�o homologados pela empresa s�o pass�veis de auditoria e provid�ncias ",oFont12)
oPrint:Say  (nRow1+1420,200 ,"legais pela Certisign Certificadora Digital S/A. ",oFont12)

oPrint:Say  (nRow1+1550,200 ,"Acess�rios do "+ALLTRIM(U00TMP->TIPO)+" ",oFont12n)
oPrint:Say  (nRow1+1650,200 ,"Descri��o",oFont12n)
oPrint:Say  (nRow1+1650,700 ,"Numero de s�rie",oFont12n)
nIten := 1
While U05TMP->( !Eof() )
 
	oPrint:Say  (nRow1+1750,200 ,ALLTRIM(U05TMP->U05_DESCOM),oFont12)
	oPrint:Say  (nRow1+1750,700 ,ALLTRIM(U05TMP->U05_NUMSER),oFont12)
	U05TMP->( DbSkip() )
    nRow1 := nRow1 + 50
End

oPrint:Say  (nRow1+1900,200 ,"Programas",oFont12n)
                        
While U01TMP->( !Eof() )

	oPrint:Say  (nRow1+2000,200 ,"- "+ALLTRIM(U01TMP->U01_DESSFT)+" ",oFont12)
	U01TMP->( DbSkip() )
    nRow1 := nRow1 + 50
End

oPrint:Say  (nRow1+2530,200 ,"Entregue por: ",oFont12)

oPrint:Say  (nRow1+2730,300 ,"__________________________________                              Ciente em _____/_____/_______ ",oFont12)
oPrint:Say  (nRow1+2800,300 ,"          "+ALLTRIM(SRATMP->RA_NOME)+"	",oFont12)

oPrint:Say  (nRow1+2930,900 ,"w w w . c e r t i s i g n . c o m   b r",oFont10)

//SU5TMP->( DbCloseArea() )
//oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
//oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

//oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
//oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

//oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/t�tulo",oFont10)
//oPrint:Say  (nRow1+0450,0100,"com as caracter�sticas acima.",oFont10)
//oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
//oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
//oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
//oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

//oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
//oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
//oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) 
//oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )
//oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
//oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
//oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) 
//oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

//oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
//oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
//oPrint:Say  (nRow1+0245,1910,"(  )N�o existe n� indicado"                  	,oFont8)
//oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
//oPrint:Say  (nRow1+0325,1910,"(  )N�o procurado"                            ,oFont8)
//oPrint:Say  (nRow1+0365,1910,"(  )Endere�o insuficiente"                  	,oFont8)
//oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
//oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
//oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                 	,oFont8)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
//For nI := 100 to 2300 step 50
//	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
//Next nI

//oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
//oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
//oPrint:Line (nRow2+0710,710,nRow2+0630, 710)
//oPrint:Say  (nRow2+0644,100,"Banco Itau SA",oFont14 )		// [2]Nome do Banco
//oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
//oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)
//oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
//oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
//oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
//oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
//oPrint:Line (nRow2+0910,500,nRow2+1050,500)
//oPrint:Line (nRow2+0980,750,nRow2+1050,750)
//oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
//oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
//oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

//oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
//oPrint:Say  (nRow2+0725,400 ,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�.",oFont10)
//oPrint:Say  (nRow2+0765,400 ,"AP�S O VENCIMENTO, SOMENTE NO ITA�.",oFont10)

//oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
//cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
//nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

//oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
//oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

//oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Cedente",oFont8)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
//nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

//oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
//oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

//oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
//oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
//oPrint:Say  (nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
//oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
//oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

//oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
//oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao



//oPrint:Say  (nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
//cString := aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
//nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

//oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

//oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
//oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)

//oPrint:Say  (nRow2+0980,755 ,"Esp�cie"                                        ,oFont8)
//oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

//oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
//oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

//oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
//cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
//nCol := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

//oPrint:Say  (nRow2+1050,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (nRow2+1100,100 ,"       ",oFont10)
//oPrint:Say  (nRow2+1100,100 ,"Ap�s o vencimento cobrar mora di�ria de R$ "+AllTrim(Transform(((aDadosTit[5]*0.1)/30),"@E 99,999.99"))+".",oFont10)
//oPrint:Say  (nRow2+1150,100 ,"Protestar ap�s  5 dias corridos do vencimento.",oFont10)
//oPrint:Say  (nRow2+1200,100 ,"Cobran�a Escritural",oFont10)

                                                                                                          
//oPrint:Say  (nRow2+1350,100 ,"Msg.: " + AllTrim(Posicione("SC5",1,xFilial("SC5") + SE1->E1_PEDIDO, "C5_MENNOTA")) ,oFont8)
//oPrint:Say  (nRow2+1250,100 ,"Nota Fiscal Eletr�nica: " + SubStr(Posicione("SF2",1,xFilial("SF2") + cNf, "F2_NFELETR"),1,90) ,oFont8)

//oPrint:Say  (nRow2+1300,100 ,"",oFont10)
//oPrint:Say  (nRow2+1350,100 ,"",oFont10)

//oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
//oPrint:Say  (nRow2+1120,1810,"(-)Outras Dedu��es"                             ,oFont8)
//oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
//oPrint:Say  (nRow2+1260,1810,"(+)Outros Acr�scimos"                           ,oFont8)
//oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

//oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nLin	,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
//oPrint:Say  (nRow2+1470,400 ,aDatSacado[3]                                    ,oFont8)
//oPrint:Say  (nRow2+1520,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado


//if aDatSacado[8] = "J"
//	oPrint:Say  (nRow2+1570,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
//Else
//	oPrint:Say  (nRow2+1570,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
//EndIf 


//oPrint:Say  (nRow2+1570,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

//nLin += 215
//oPrint:Say  (nLin,100 ,"Sacador/Avalista: "                               ,oFont8)   
//oPrint:Say  (nRow2+1665,100 ,"Sacador/Avalista: "                               ,oFont8)   
//oPrint:Say  (nRow2+1665,1800,"Autentica��o Mec�nica",oFont8)

//oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
//oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
//oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
//oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
//oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )

//oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
//oPrint:Line (nRow2+1650,100 ,nRow2+1650,2300 )

//oPrint:Line (nLin,100 ,nRow2+1400,2300 )
//oPrint:Line (nLin,100 ,nLin,2300 )
//oPrint:Line (nLin + 250,100 ,nRow2+1650,2300 )
//oPrint:Line (nLin + 250,100 ,nLin + 250,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

//nRow3 := 0

//For nI := 100 to 2300 step 50
///	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
//Next nI

//oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
//oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
//oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

//oPrint:Say  (nRow3+1934,100,"Banco Itau SA",oFont14 )		// 	[2]Nome do Banco
//oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
//oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

//oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
//oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
//oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
//oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

//oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
//oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
//oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
//oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
//oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

//oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
//oPrint:Say  (nRow3+2015,400 ,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�.",oFont10)
//oPrint:Say  (nRow3+2055,400 ,"AP�S O VENCIMENTO, SOMENTE NO ITA�.",oFont10)


//oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
//cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
//nCol	 	 := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

//oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
//oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ    

//oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Cedente",oFont8)
//cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
//nCol 	 := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


//oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
//oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


//oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
//oPrint:Say  (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

//oPrint:Say  (nRow3+2200,1005,"Esp�cie Doc."                                   ,oFont8)
//oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

//oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
//oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

//oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
//oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

//Calcula o Digito Verificador


//oPrint:Say  (nRow3+2200,1810,"Nosso N�mero"                                   ,oFont8)
//cString  :=  aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
//nCol 	 := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

//oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

//oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
//oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)

//oPrint:Say  (nRow3+2270,755 ,"Esp�cie"                                        ,oFont8)
//oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

//oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
//oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

//oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
//cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
//nCol 	 := 1810+(374-(len(cString)*22))
//oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

//oPrint:Say  (nRow3+2350,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (nRow3+2400,100 ,"       ",oFont10)
//oPrint:Say  (nRow3+2400,100 ,"Ap�s o vencimento cobrar mora di�ria de R$ "+AllTrim(Transform(((aDadosTit[5]*0.1)/30),"@E 99,999.99"))+".",oFont10)
//oPrint:Say  (nRow3+2450,100 ,"Protestar ap�s  5 dias corridos do vencimento.",oFont10)
//oPrint:Say  (nRow3+2500,100 ,"Cobran�a Escritural",oFont10)
   
/*
DbSelectArea("SD2")
DbSetOrder(8)      
SD2->(DbGoTop())
If SD2->(DbSeek(xFilial("SD2") + SE1->E1_PEDIDO ) )
	nLin := nRow3+2600
	nX   := 1
	While !SD2->(Eof()) .AND. SE1->E1_PEDIDO == SD2->D2_PEDIDO
		oPrint:Say  (nLin ,100 ,StrZero(nX,3) + " " + Posicione("SB1",1,xFilial("SB1") + SD2->D2_COD, "B1_DESC"),oFont8)
		nLin += 050
		nX ++
		SD2->(DbSkip())
	End
EndIf*/
//nLin := nRow3+2600
//oPrint:Say  (nLin ,100 ,cProd,oFont8)   
//oPrint:Say  (nRow2+2650,100 ,"Msg. do Pedido: " + AllTrim(Posicione("SC5",1,xFilial("SC5") + SE1->E1_PEDIDO, "C5_MENNOTA")) ,oFont8)
//oPrint:Say  (nRow2+2550,100 ,"Nota Fiscal Eletr�nica: " + Posicione("SF2",1,xFilial("SF2") + cNf, "F2_NFELETR") ,oFont8)


//oPrint:Say  (nRow3+2600,100 ,"",oFont10)
//oPrint:Say  (nRow3+2650,100 ,"",oFont10)

//oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
//oPrint:Say  (nRow3+2410,1810,"(-)Outras Dedu��es"                             ,oFont8)
//oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
//oPrint:Say  (nRow3+2550,1810,"(+)Outros Acr�scimos"                           ,oFont8)
//oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

//oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nLin,100 ,"Sacado"                                         ,oFont8)
//oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
/*
if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf
*/
//oPrint:Say  (nRow3+2740,400 ,aDatSacado[3]                                    ,oFont8)
//oPrint:Say  (nRow3+2780,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado
//oPrint:Say  (nRow3+2780,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont8)

//nLin += 135
//oPrint:Say  (nRow3+2825,100 ,"Sacador/Avalista: "                                ,oFont8)
//oPrint:Say  (nLin,100 ,"Sacador/Avalista: "                                ,oFont8)
//oPrint:Say  (nRow3+2870,1500,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont8)

//oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
//oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
//oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
//oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
//oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )

//oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
//oPrint:Line (nRow3+2860,100,nRow3+2860,2300  )

//MSBAR("INT25",14.80,1,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.0140,0.79,NIL,NIL,NIL,.F.)0.029629,1.65
//MSBAR("INT25",15.2,1.7,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.022,1.40,NIL,NIL,NIL,.F.)
//MSBAR("INT25",13.20,1,aCB_RN_NN[2],oPrint,.F.,nil,nil,0.0140,0.79,NIL,NIL,NIL,.F.)
//MSBAR( "INT25",25  ,1.5 ,aCB_RN_NN[1],oPrint,.F.   ,     ,     ,      ,1.3    ,      ,      ,     ,.F.)
//MSBAR( "INT25",27  ,1.5 ,aCB_RN_NN[1],oPrint,.F.   ,     ,     ,      ,1.3    ,      ,      ,     ,.F.)

oPrint:EndPage() // Finaliza a p�gina
oPrint:Preview()     // Visualiza antes de imprimir

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Montatab� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Montatab()

Local cQuery  := ""
Local cQuery1 := ""
Local cQuery2 := ""
Local cQuery3 := ""

//������������������������������������������������������������������������Ŀ
//�Selecionando os dados do Funcionario                                    �
//��������������������������������������������������������������������������

cQuery :=" SELECT "+Chr(13)+Chr(10) 
cQuery +=" RA_NOME,"+Chr(13)+Chr(10) 
cQuery +=" (SELECT X5_DESCRI FROM SX5010 WHERE RA_FILIAL = X5_FILIAL AND X5_TABELA = '34' AND X5_CHAVE = RA_NACIONA) AS NACIONAL,"+Chr(13)+Chr(10) 
cQuery +=" RA_MAT,"+Chr(13)+Chr(10) 
cQuery +=" RA_CIC"+Chr(13)+Chr(10) 
cQuery +=" FROM SRA010"+Chr(13)+Chr(10) 
cQuery +=" WHERE "+Chr(13)+Chr(10) 
cQuery +=" RA_FILIAL = '"+Substr(mv_par01,1,2)+"'"+Chr(13)+Chr(10) 
cQuery +=" AND RA_MAT = '"+Substr(mv_par01,3,6)+"'"+Chr(13)+Chr(10) 
cQuery +=" AND RA_SITFOLH <> 'D'"
                                                                                                     
If Select("SRATMP") > 0
	SRATMP->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SRATMP", .F., .T.)

//������������������������������������������������������������������������Ŀ
//�Selecionando os dados do Computador                                     �
//��������������������������������������������������������������������������                                

cQuery1 :=" SELECT  "+Chr(13)+Chr(10)                             
cQuery1 +=" U00_FILIAL,"+Chr(13)+Chr(10) 
cQuery1 +=" U00_CODHRD,"+Chr(13)+Chr(10) 
cQuery1 +=" U00_CODFUN, "+Chr(13)+Chr(10) 
cQuery1 +=" (SELECT U06_DESTIP FROM U06010 WHERE U06_FILIAL = U00_FILIAL AND U06_CODTIP  = U00_TIPHRD)AS TIPO, "+Chr(13)+Chr(10) 
cQuery1 +=" U00_MARCA, "+Chr(13)+Chr(10) 
cQuery1 +=" U00_DESHRD, "+Chr(13)+Chr(10) 
cQuery1 +=" U00_NUMSER,  "+Chr(13)+Chr(10) 
cQuery1 +=" U00_COMATV  "+Chr(13)+Chr(10) 
cQuery1 +=" FROM U00010 "+Chr(13)+Chr(10) 
cQuery1 +=" WHERE "+Chr(13)+Chr(10) 
cQuery1 +=" U00_CODFUN = '"+mv_par01+"' "+Chr(13)+Chr(10) 
cQuery1 +=" AND D_E_L_E_T_ = ' ' "+Chr(13)+Chr(10) 

If Select("U00TMP") > 0
	U00TMP->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "U00TMP", .F., .T.)

//������������������������������������������������������������������������Ŀ
//�Selecionando os componentes do Computador                               �
//��������������������������������������������������������������������������                                


cQuery2 :=" SELECT  "+Chr(13)+Chr(10)
cQuery2 +=" U05_FILIAL, "+Chr(13)+Chr(10)  
cQuery2 +=" U05_CODHRD, "+Chr(13)+Chr(10) 
cQuery2 +=" U05_CODCOM, "+Chr(13)+Chr(10) 
cQuery2 +=" U05_DESCOM, "+Chr(13)+Chr(10) 
cQuery2 +=" U05_NUMSER  "+Chr(13)+Chr(10) 
cQuery2 +=" FROM U05010 "+Chr(13)+Chr(10) 
cQuery2 +=" WHERE "+Chr(13)+Chr(10) 
cQuery2 +=" U05_FILIAL = '"+U00TMP->U00_FILIAL+"' "+Chr(13)+Chr(10) 
cQuery2 +=" AND U05_CODHRD = '"+U00TMP->U00_CODHRD+"' "+Chr(13)+Chr(10) 
cQuery2 +=" AND D_E_L_E_T_ = ' ' "+Chr(13)+Chr(10) 
cQuery2 +=" ORDER BY U05_CODHRD,U05_CODCOM "+Chr(13)+Chr(10) 

If Select("U05TMP") > 0
	U05TMP->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2), "U05TMP", .F., .T.)                                                  

//������������������������������������������������������������������������Ŀ
//�Selecionando os softwares 				                               �
//��������������������������������������������������������������������������                                
                                            
cQuery3 :=" SELECT U01_DESSFT FROM U01010 " +Chr(13)+Chr(10)
cQuery3 +=" WHERE " +Chr(13)+Chr(10)
cQuery3 +=" U01_FILIAL = '"+U00TMP->U00_FILIAL+"' " +Chr(13)+Chr(10)
cQuery3 +=" AND U01_CODHRD = '"+U00TMP->U00_CODHRD+"' "+Chr(13)+Chr(10)
cQuery3 +=" AND D_E_L_E_T_ = ' ' "+Chr(13)+Chr(10)
cQuery3 +=" ORDER BY U01_CODHRD, U01_CODSFT "+Chr(13)+Chr(10)

If Select("U01TMP") > 0
	U01TMP->(DbCloseArea())            
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), "U01TMP", .F., .T.)                                                  
      
Return

