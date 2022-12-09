#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch" 
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RLFSO   �Autor  � FERNANDO FERES     � Data �    23/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �       RELAT�RIO DE CLIENTES COMERCIAIS                     ���
���          �       FORMATO GRAFICO ( RETRATO )                          ���
�������������������������������������������������������������������������͹��
���Cliente       � Selten Engenharia                                      ���
�������������������������������������������������������������������������ͼ��
��  Observa��es                      	  |Data             Autor          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RNFCANC()

Local 	oPrn
Local 	aCA        	:= {OemToAnsi("Confirma"),OemToAnsi("Abandona")}
Local 	cCadastro  	:= OemToAnsi("Impressao Fatura")
Local 	aSays      	:= {}
Local 	aButtons   	:= {}
Local 	nOpca    	:= 0

Private aReturn  	:= {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 }
Private nLastKey 	:= 0
Private Modulo   	:= 11
Private Moeda    	:= "9"
Private cPerg   	:= PadR("RNFCANC", 10)
Private nValor 	  	:= 0 

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Prefixo                               �
//����������������������������������������������������������������
//local MV_PAR01
//local MV_PAR02
//date MV_PAR03
//date MV_PAR04
//date MV_PAR05
//date MV_PAR06
//local MV_PAR07

//ValidPerg()
            
pergunte("RNFCANC",.F.)

AAdd(aSays,OemToAnsi( "  Este programa ira imprimir o relat�rio de Notas Fiscais Canceladas"))

AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AAdd(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AAdd(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpca == 1
	Processa( { |lEnd| ImpBol(oPrn) })
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPBOL    �Autor  �Microsiga           � Data �  09/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
	
Static Function ImpBol(oPrn)

nPag  := 1

/*oPrn:= TMSPrinter():New()
oPrn:SetPortrait()
oPrn:SetPaperSize(9) // A4
oPrn:Setup()
oPrn:StartPage()
  */
  
  

//���������������������������������������Ŀ
//�Define que a impressao deve ser RETRATO�
//�����������������������������������������
lViewPDF := .t.
lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
cFilename := Criatrab(Nil,.F.)
oPrn := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup,,,,,,,lViewPDF)
//	oPrint:Setup()
oPrn:SetResolution(78)
oPrn:SetPortrait() // ou SetLandscape()
oPrn:SetPaperSize(DMPAPER_A4) 
oPrn:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrn:cPathPDF := "C:\TEMP\" // Caso seja utilizada impress�o em IMP_PDF 
cDiretorio := oPrn:cPathPDF
oPrn:StartPage()
          
//FONTES
oFont1:= TFont():New( "Courier New",,10,,.F.,,,,,.F. ) 
oFont2:= TFont():New( "Courier New",,10,,.T.,,,,,.F. ) // NEGRITO
oFont3:= TFont():New( "Courier New",,09,,.F.,,,,,.F. )
oFont4:= TFont():New( "Courier New",,21,,.T.,,,,,.F. ) // NEGRITO
oFont5:= TFont():New( "Courier New",,28,,.F.,,,,,.F. )
oFont6:= TFont():New( "Courier New",,16,,.T.,,,,,.F. ) // NEGRITO
oFont7:= TFont():New( "Courier New",,18,,.T.,,,,,.F. ) // NEGRITO

oFont8:= TFont():New( "Times New Roman",,10,,.T.,,,,.T.,.F. ) // NEGRITO
oFont9:= TFont():New( "Times New Roman",,16,,.T.,,,,.T.,.F. ) // NEGRITO
oFont10:= TFont():New( "Times New Roman",,11,,.F.,,,,,.F. )
                                                               	

//QUERY
       IF MV_PAR07 == 1 //CANCELADAS
      		
      		cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SF3")+" SF3 "+ " 
			cQuery += "WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "
			cQuery += "SF3.F3_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
			cQuery += "SF3.F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "  
			cQuery += "SF3.F3_DTCANC BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"' AND "
			cQuery += "SF3.F3_CODRSEF <>  '102' AND "
			cQuery += "SF3.D_E_L_E_T_ <> '*' "
			cQuery += "ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL " 
	     	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
       
      
       ENDIF      
      
       IF MV_PAR07 == 2 //INUTILIZADAS
       	
       	cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SF3")+" SF3 "+ " 
			cQuery += "WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "
			cQuery += "SF3.F3_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
			cQuery += "SF3.F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "  
			cQuery += "SF3.F3_DTCANC BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"' AND "
			cQuery += "SF3.F3_CODRSEF =  '102' AND "
			cQuery += "SF3.D_E_L_E_T_ <> '*' "
			cQuery += "ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL " 
	     	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
			
       ENDIF
       
       IF MV_PAR07 == 3 //TODAS
      		
      		cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SF3")+" SF3 "+ " 
			cQuery += "WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "
			cQuery += "SF3.F3_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
			cQuery += "SF3.F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "  
			cQuery += "SF3.F3_DTCANC BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"' AND "
			cQuery += "SF3.D_E_L_E_T_ <> '*' "
			cQuery += "ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL " 
	     	
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
       
      
       ENDIF   
             
       /*
       
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SF3")+" SF3 "+ " 
		cQuery += "WHERE SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "
		cQuery += "SF3.F3_SERIE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
		cQuery += "SF3.F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "  
		cQuery += "SF3.F3_DTCANC BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"' AND "
		cQuery += "SF3.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL " 
	*/
	   		
		dbSelectArea("TMP")
		TMP->(DbGotop())
		

		If TMP->(Eof())
		   MsgInfo("Nao existem registros com o filtro escolhido!")
		   set filter to
		   dbGotop()
		   TMP->(DbCloseArea())
		   Return
		EndIf

//ImpCabecP(oPrn)   

		cBitMap:= FisxLogo("1")//"LGRL01.BMP"
   		cBitIso:= ""
   		cBitSel:= "LOGO_TOPFIVE.BMP"
		oPrn:Box(020+0000,0040,165+0000,2370)
		oPrn:Box(020+0000,0345,165+0000,1990)

   		oPrn:Say(050,0400,"Metalacre Ind�stria e Com�rcio de Lacres",oFont7,100) 
		oPrn:Say(120,0400,"NOTAS FISCAIS CANCELADAS E INUTILIZADAS",oFont7,100) 
		oPrn:SayBitmap(030,050,cBitMap,250,120 ) //700,300
		oPrn:Say(040,2000,"Emiss�o .: "+ DtoC(Date()),oFont8,100) 
		oPrn:Say(080,2000,"Hora      .: "+ Time(),oFont8,100)
		oPrn:Say(120,2000,"P�gina   .: "+ "01" ,oFont8,100) 

	Impress(oPrn)

	If !Eof()
		oPrn:EndPage()
		oPrn:StartPage()
	Endif


Set Filter to

oPrn:EndPage()
oPrn:Preview()
MS_FLUSH()
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Impress   �Autor  �Microsiga           � Data �  09/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �     INICIO DA IMPRESS�ES                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
	
Static Function Impress(oPrn)
	
_nLin := 00
nPag  := 01

	//COLOCAR AS IMPRESSOES AQUI 
	
dbSelectArea("TMP")
TMP->(DbGotop())	
	
While TMP->(!Eof())     

	cNF      := TMP->F3_SERIE+TMP->F3_NFISCAL
	cValor   := transform(TMP->F3_VALCONT, "@E 999,999,999.99") 
	cNome    := ""
	cStatus  := "" 
	cCont    := ""
	cCFOP	 := TMP->F3_CFO
	cAviso   := TMP->F3_NFISCAL
	cClient  := ""//TMP->F3_CLIENT 
   	cEmiss   := Substr(TMP->F3_EMISSAO,7,2)+ "/" + Substr(TMP->F3_EMISSAO,5,2) + "/" + Substr(TMP->F3_EMISSAO,1,4)  
   	cCanc    := Substr(TMP->F3_DTCANC,7,2)+ "/" + Substr(TMP->F3_DTCANC,5,2) + "/" + Substr(TMP->F3_DTCANC,1,4)
   	
   	   If TMP->F3_CLIEFOR == TMP->F3_CLIENT
       	cClient  := TMP->F3_CLIENT
   	   
		   	   dbSelectArea("SA1")
		     	dbSetOrder(1)
			   If dbSeek(xFilial()+cClient)
			   		cNome    := SA1->A1_NOME	
		       Endif
       Endif
       
       If TMP->F3_CLIEFOR <>TMP->F3_CLIENT
       	cClient  := TMP->F3_CLIEFOR
   	   
		   	   dbSelectArea("SA2")
		     	dbSetOrder(1)
			   If dbSeek(xFilial()+cClient)
			   		cNome    := SA2->A2_NOME	
		       Endif
		       
		       	dbSelectArea("SA1")
			     	dbSetOrder(1)
				   If dbSeek(xFilial()+cClient)
				   		cNome    := SA1->A1_NOME	
			       Endif
       Endif
          	
   	If TMP->F3_CODRSEF == "102"
   	   cStatus := "NOTA INUTILIZADA" 
   	Else
   	   cStatus := "NOTA CANCELADA"
   	Endif  
    
	oPrn:Box(_nLin+0210,0040,_nLin+0260,500)                              //0040
	oPrn:Box(_nLin+0210,500,_nLin+0260,2370)//1700
	oPrn:Box(_nLin+0260,0040,_nLin+0310,500) 
	oPrn:Box(_nLin+0260,500,_nLin+0310,1150)
	oPrn:Box(_nLin+0260,1150,_nLin+0310,1700) 
	oPrn:Box(_nLin+0260,1700,_nLin+0310,2170)
	oPrn:Box(_nLin+0260,2170,_nLin+0310,2370)
	  
    oPrn:Say(_nLin+0235,0065,"N.F.: " + TMP->F3_NFISCAL       ,oFont8,100) //320
	oPrn:Say(_nLin+0235,0320,"S�RIE.: " + TMP->F3_SERIE      ,oFont8,100) //0065
   	oPrn:Say(_nLin+0235,520,"CLIENTE/FORNECEDOR.: " + Transform(cNome, "@!")             ,oFont8,100) 
	oPrn:Say(_nLin+0285,0065,"EMISS�O.: " + cEmiss          ,oFont8,100) 
	oPrn:Say(_nLin+0285,520,"CANCELAMENTO.: " + cCanc       ,oFont8,100) //cCanc
	oPrn:Say(_nLin+0285,1170,"VALOR.: R$ " + cValor       ,oFont8,100) //cCanc
	oPrn:Say(_nLin+0285,1720,"STATUS.: " + cStatus       ,oFont8,100) //cCanc
	oPrn:Say(_nLin+0285,2190,"CFOP.: " + cCFOP       ,oFont8,100) //cCanc
     
	TMP->(DbSkip())
	
	_nLin += 0150

	If _nLin > 2700
	
	   oPrn:Say(_nLin+0200,600,"* * * * CONTINUA NA PR�XIMA P�GINA * * * *"       ,oFont8,100) //cCanc 
	   _nLin := 0000 
	   nPag  := nPag+1
	   oPrn:EndPage()
	   oPrn:StartPage()
       
       cBitMap:= FisxLogo("1")//"LGRL01.BMP"
   		cBitIso:= ""
   		cBitSel:= "LOGO_TOPFIVE.BMP"
		oPrn:Box(020+0000,0040,165+0000,2370)
		oPrn:Box(020+0000,0345,165+0000,1990)


   		oPrn:Say(050,0400,"Metalacre Ind�stria e Com�rcio de Lacres",oFont7,100) 
		oPrn:Say(120,0400,"NOTAS FISCAIS CANCELADAS E INUTILIZADAS",oFont7,100) 
		oPrn:SayBitmap(030,050,cBitMap,250,120 ) //700,300
		oPrn:Say(040,2000,"Emiss�o .: "+ DtoC(Date()),oFont8,100) 
		oPrn:Say(080,2000,"Hora      .: "+ Time(),oFont8,100)
		oPrn:Say(120,2000,"P�gina   .: "+ "01" ,oFont8,100) 
	
    Endif 

EndDo    	 		    	 
	

TMP->(DbCloseArea())
SC5->(DbCloseArea())
SA1->(DbCloseArea())

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Impress   �Autor  �Microsiga           � Data �  09/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �           CABE�ALHO E LOGOTIPO                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function ImpCabecP(oPrn)

	cBitMap:= "LGRL01.BMP"
	cBitIso:= ""
	cBitSel:= "LOGO_TOPFIVE.BMP"
    oPrn:Say(040,0750,"ELETR�NICA SANTANA LTDA",oFont7,100) 
	oPrn:Say(120,0775,"ROMANEIO DE ENTREGAS",oFont7,100) 
	oPrn:SayBitmap(040,040,cBitMap,307,150 ) //700,300
	oPrn:Say(040,2000,"Emiss�o .: "+ DtoC(Date()),oFont8,100) 
	oPrn:Say(080,2000,"Hora      .: "+ Time(),oFont8,100)
	oPrn:Say(120,2000,"P�gina   .: "+"01" ,oFont8,100) 
	oPrn:Box(040+0000,0040,185+0000,2370)
	oPrn:Box(040+0000,0345,185+0000,1990)
	
	oPrn:Box(040+0200,0040,040+0275,1115) 
	oPrn:Say(045+0200,0065,"ROMANEIO.: " + TMP->ZRO_NUM	   ,oFont6,100) 
	oPrn:Say(045+0200,1120,"ENTREGADOR.: " + TMP->ZRO_ENTREG         ,oFont6,100)			
	oPrn:Box(040+0200,1115,040+0275,2370)
		
	
Return
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFINR02   �Autor  �Microsiga           � Data �  09/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria SX1                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg()

Private aRegs := {}

//Estrutura {Grupo	/Ordem	/Pergunta			/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid	/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
Aadd( aRegs,{ cPerg, "01","S�RIE DE.:                   ","               ","               ","mv_ch1","C", 3,0,0,"G",;
                      "                                                                     ",;
                      "mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "02","S�RIE AT�.:                  ","               ","               ","mv_ch2","C", 3,0,0,"G",;
                      "                                                                     ",;
                      "mv_par02       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "03","EMISS�O DE.:                 ","               ","               ","mv_ch3","D", 8,0,0,"G",;
                      "                                                                     ",;
                      "mv_par03       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "04","EMISS�O AT�.:                ","               ","               ","mv_ch4","D", 8,0,0,"G",;
                      "                                                                     ",;
                      "mv_par04       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "05","CANCELAMENTO DE.:            ","               ","               ","mv_ch5","D", 8,0,0,"G",;
                      "                                                                     ",;
                      "mv_par05       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "06","CANCELAMENTO AT�.:           ","               ","               ","mv_ch6","D", 8,0,0,"G",;
                      "                                                                     ",;
                      "mv_par06       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )
Aadd( aRegs,{ cPerg, "07","STATUS.:                     ","               ","               ","mv_ch7","N", 1,0,0,"G",;
                      "                                                                     ",;
                      "mv_par07       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ",;
                      "               ","               ","               ","               ","                                                            ","      ","   " } )

lValidPerg( aRegs )


Return