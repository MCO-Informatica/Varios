#INCLUDE "protheus.ch"

USER FUNCTION CTGPR001()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Imprime etiquetas para CTPS.                                             |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Admissão.                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
| <Manutencao>: 16/03/2016 - Alexandre Alves - Passa a considerar o Tipo de Contrato de  |
|               Trabalho e se Menor Aprendiz, para impressao dos textos legais.          |
|               Ajuste de posicionamento do texto dentro da etiqueta.                    |
|               Manutencao referente as OTRSs.: 2015080310002468 e 2016021510002801      |
+----------------------------------------------------------------------------------------+
+----------------------------------------------------------------------------------------+
*/
Private cPerg   := "CTGPR1"
Private cTitulo := "Etiquetas CTPS"
				 //FWMsPrinter():New(cTitulo, /*nDevice*/, /*lAdjustToLegacy*/, /*cPathInServer*/, .T., /*lTReport*/, /*@oPrintSetup*/, /*cPrinter*/, /*lServer*/, /*lPDFAsPNG*/, /*lRaw*/, /*lViewPDF*/, /*nQtdCopy*/)
Private oPrn    := FWMsPrinter():New(cTitulo,,,,.T.,,,,,,,,)
Private aInfo   := {}

AjustSx1()

If !Pergunte(cPerg,.T.)
	Return
End If

Processa({|| Imprimir()},"Gerando etiquetas ... ")

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
DEFINE FONT oFont6 NAME "Courier New" BOLD
              
@ 015,017 SAY "Etiquetas para Carteira de Trabalho. "	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "Modelo PIMACO 3 Colunas."					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Modelo.:" 			           		      OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION (oPrn:Print()  ,oDlg:End())   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION (oPrn:Preview(),oDlg:End()) 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()                  	OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

Lista->(dbCloseArea())

RETURN


Static Function Imprimir()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Gera os dados necessarios para o relatorio.                              |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Admissão.                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
Local x         := 0
Local cSit      := ""
Local nAnt      := SM0->(recno())
Local nSeqEt    := 0
Local nLinha    := 0
Local lFirst    := .T.
Local lImpOpc   := .T.
Local cAntFil   := SM0->M0_CODFIL
Local cFilFun   := ""
Local nTamanho  := 0  
Local cTexto    := "" 
Local aTexto    := {}
Local cMAQtdMes := "" //-- Quantidade de meses para experiencia do jovem aprendiz.
Local cColEtiq 	:= GetNewPar("MV_XCTPSET",,"25,0845,1665,125,1110,2010") //-- Define a posicao inical das colunas das etiquetas
Local aColunas	:= {}

aColunas := StrTokArr(cColEtiq,",")
For z:=1 To Len(aColunas)
	aColunas[z] := Val(aColunas[z])
Next z

For x:=1 to Len(mv_par09)
	If !Empty(cSit)
		cSit+=','
	End If
	cSit+="'"+substr(mv_par09,x,1)+"'"
Next x
If Empty(cSit)
	cSit:="' '"
End If

dbSelectArea('SRA')
cAcessaSRA	:= &( " { || " + ChkRH( "GPEWORD" , "SRA" , "2" ) + " } " )

oPrn:SetParm("-RFS")

oPrn:Setup()
oPrn:SetPortrait()
oPrn:SetPaperSize(1) // carta

cQuery :="SELECT R_E_C_N_O_ AS SRAREC FROM "+RetSqlName('SRA')+" "
cQuery +="WHERE RA_FILIAL  BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"'       AND "
cQuery +="      RA_ADMISSA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "
cQuery +="      RA_MAT     BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"'       AND "
cQuery +="      RA_CC      BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"'       AND "
cQuery +="      RA_SITFOLH IN ("+cSit+")                AND D_E_L_E_T_ <> '*'        "
cQuery +=" ORDER BY RA_FILIAL,RA_MAT "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"LISTA",.F.,.T.)

dbSelectArea('LISTA')
count to nTot
ProcRegua(nTot)

LISTA->(dbGoTop())

//TFont():New(           cName      ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)

oFont09  := TFont():New("Courier New",,09,,.F.,,,,.T.,.F.)
oFont09N := TFont():New("Courier New",,09,,.T.,,,,.T.,.F.)
oFont10  := TFont():New("Courier New",,10,,.F.,,,,.F.,.F.)
oFont10N := TFont():New("Courier New",,10,,.T.,,,,.F.,.F.)
oFont10S := TFont():New("Courier New",08,10,,.T.,,,,.F.,.F.)
oFont11  := TFont():New("Courier New",,11,,.F.,,,,.T.,.F.)
oFont11N := TFont():New("Courier New",,11,,.T.,,,,.T.,.F.)
oFont12N := TFont():New("Courier New",,12,,.T.,,,,.T.,.F.)

nLinha := MV_PAR10 //-> Linha, do formulario, de incio da ipressao.
nSeqEt := If(MV_PAR11 = 1, 001, If(MV_PAR11 = 2, 0002, 0003)) //-> Posicao da etiqueta na linha do formulario.
nLin   := If(MV_PAR10 = 1, aColunas[4], If(MV_PAR10 = 2, aColunas[5], aColunas[6])) //-> Linha, dentro da etiqueta, de incio da ipressao.
nCol   := If(MV_PAR11 = 1, aColunas[1], If(MV_PAR11 = 2, aColunas[2], aColunas[3])) //-> Coluna, do formulario, de incio da ipressao.

Do While !Lista->(eof())                                     
	dbSelectArea("SRA")
	SRA->(dbGoTo(LISTA->SRAREC))                             	
	
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		LISTA->(dbSkip())
		Loop
	End IF	

	If SM0->M0_CODFIL <> SRA->RA_FILIAL
		SM0->(dbSetOrder(1))
		SM0->(dbSeek( cEmpAnt + SRA->RA_FILIAL ))
	End If
	
    If SRA->RA_FILIAL # cFilFun
      If !fInfo(@aInfo,SRA->RA_FILIAL)
         MsgStop("Falha na estrtura da Filial: "+SRA->(AllTrim(RA_FILIAL))+". Processo abortado!")
         Exit
      Endif
      cFilFun:=SRA->RA_FILIAL
    Endif

	For nEtiq:=1 to 2
		If lFirst
			oPrn:StartPage()
			lFirst:=.F.
		End If 			
		If nEtiq = 1
         oPrn:Say(nLin+000,nCol,aInfo[3],oFont11N)
			oPrn:Say(nLin+040,nCol,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont10)
			oPrn:Say(nLin+080,nCol,"END.: "+substr(aInfo[4],1,23),oFont10)
			oPrn:Say(nLin+120,nCol,"BAIRRO: "+substr(aInfo[13],1,15)+" - CEP "+TRANSFORM(aInfo[7],'@R 99999-999'),oFont10)
			oPrn:Say(nLin+160,nCol,"CIDADE: "+AllTrim(aInfo[5])+" - UF: "+aInfo[6],oFont10)
			oPrn:Say(nLin+200,nCol,"ESP. ESTABELECIMENTO: "+AllTrim(MV_PAR12),oFont10S)
			oPrn:Say(nLin+245,nCol,"NOME: "+ALLTRIM(SRA->RA_NOME),oFont11N)	

			SRJ->(dbSetOrder(1))
			SRJ->(dbSeek(xFilial('SRJ')+SRA->RA_CODFUNC))

			oPrn:Say(nLin+290,nCol,"CARGO: "+SRJ->RJ_DESC,oFont10N)
			oPrn:Say(nLin+330,nCol,"CBO: "+TRANSFORM(SRJ->RJ_CODCBO,'@R 9999-99'),oFont10)
			oPrn:Say(nLin+370,nCol,"REGISTRO: "+ALLTRIM(SRA->RA_MAT)+" FICHA: "+ALLTRIM(SRA->RA_FICHA),oFont10)
			oPrn:Say(nLin+410,nCol,"ADMISSÃO: "+Admissao(SRA->RA_ADMISSA),oFont10)

			cTexto:="REMUNERAÇÃO: R$"+ALLTRIM(TRANSFORM(SRA->RA_SALARIO,'@E 999,9999,999.99'))
			cTexto+=" ( "+Alltrim(Extenso( SRA->RA_SALARIO , .F. , 1 )+' ) POR MÊS.')
			aTexto:=SepTxt(cTexto,38,.f.)
			For x:=1 to Len(aTexto)
				oPrn:Say(nLin+410+(x*40),nCol,aTexto[x],oFont10)
			Next x

			oPrn:Say(nLin+650,nCol,"______________________________________",oFont11)
			oPrn:Say(nLin+700,nCol,aInfo[3],oFont11N)
			nSeqEt++
		Else
		
			lImpOpc := .T.
				
			If SRA->RA_TPCONTR = "2" //-> Contrato por Tempo Determinado.
				
				If SRA->RA_VIEMRAI = "55" //-> Menor Aprendiz.
					
					If xFilial() == "07"			//-> São Paulo: 15 meses 
						cMAQtdMes := "16"
					ElseIf xFilial() == "06"		//-> Rio de Janeiro: 11 meses.
						cMAQtdMes := "11"
					EndIf
					
					cTexto := " Conforme dispõe o art.428 CLT, considera-se prazo determinado o contrato"
					cTexto += " de aprendizagem por um período de " + cMAQtdMes + " meses a partir da data de sua"
					cTexto += " contratação com termino em " + AllTrim( DToC(SRA->RA_DTFIMCT) ) + "."
				Else
					lImpOpc := .F.
	
					//nLin+000
	
					cTexto := " Conforme dispõe o art. 443 da CLT, considera-se como de prazo determinado"
					cTexto += " o contrato de trabalho cuja vigência dependa de termo prefixado ou da execução"
					cTexto += " de serviços especificados ou ainda da realização de certo acontecimento suscetível" 
					cTexto += " de previsão aproximada. O contrato será de " + AllTrim( Str((SRA->(RA_DTFIMCT - RA_ADMISSA)+1) ) ) + " dias"
					cTexto += " a partir da data de sua contratação, podendo, nos termos da lei se for o caso, ser"
					cTexto += " prorrogado apenas uma vez, sem extrapolar o período de 2 anos."
				EndIf
	
			Else
					cTexto := "   O portador desta foi admitido em carater experimental pelo prazo de "+;
	                        If(Empty(SRA->RA_VCTOEXP),"45",AllTrim( Str((SRA->(RA_VCTOEXP - RA_ADMISSA)+1) ) ))+;
	                        " dias a partir de "+dtoc(SRA->RA_ADMISSA)+", podendo ser prorrogado conforme C.L.T. ou Convenção Coletiva de Trabalho."         
			EndIf
         
         
         If lImpOpc
            oPrn:Say(nLin+000,nCol,aInfo[3],oFont11N)
			   oPrn:Say(nLin+055,nCol,"OPÇÃO:"          ,oFont10N)
			   oPrn:Say(nLin+055,nCol+300,"RETRATAÇÃO:  ",oFont10N)
			   oPrn:Say(nLin+100,nCol,Dtoc(SRA->RA_OPCAO),oFont10)
			   oPrn:Say(nLin+100,nCol+300,"____/____/_____",oFont10)

			   SA6->(dbSetOrder(1))
			   SA6->(dbSeek(xFilial('SA6')+SRA->RA_BCDPFGT))

			   oPrn:Say(nLin+150,nCol,'BCO. DEPOSITÁRIO: '+SA6->A6_NOME,oFont10)
			   oPrn:Say(nLin+195,nCol,'AGÊNCIA: '+alltrim(SA6->A6_AGENCIA)+IIF(!EMPTY(SA6->A6_DVAGE),'-'+SA6->A6_DVAGE,'')+IIF(!Empty(SA6->A6_NOMEAGE),' ('+ALLTRIM(SA6->A6_NOMEAGE)+')',''),oFont10)
			   oPrn:Say(nLin+240,nCol,'PRAÇA: '+SA6->A6_MUN,oFont10)
			   oPrn:Say(nLin+305,nCol,"______________________________________",oFont11)
			   oPrn:Say(nLin+345,nCol,aInfo[3],oFont11N)
			   
			   
   			aTexto:=SepTxt(cTexto,38,.T.)
			   For x:=1 to Len(aTexto)
				    oPrn:Say(nLin+380+(x*40),nCol,aTexto[x],oFont11)
			   Next x

			   oPrn:Say(nLin+650,nCol,"______________________________________",oFont11)
			   oPrn:Say(nLin+700,nCol,aInfo[3],oFont11N)
			   nSeqEt++		   
         Else

            oPrn:Say(nLin+000,nCol,aInfo[3],oFont11N)
            
   			aTexto:=SepTxt(cTexto,38,.T.)
			   For x:=1 to Len(aTexto)
				    oPrn:Say(nLin+055+(x*40),nCol,aTexto[x],oFont11)
			   Next x

			   oPrn:Say(nLin+650,nCol,"______________________________________",oFont11)
			   oPrn:Say(nLin+700,nCol,aInfo[3],oFont11N)
			   nSeqEt++
         End

		EndIf

		If nSeqEt > 3
			nLin += 840//900
			nLinha++
			nSeqEt :=1
			nCol   := aColunas[1] //50
		Else
			nCol += 750
		End If
		If nLinha > 3
			oPrn:EndPage()
			nLinha :=001
			nSeqEt :=001
			nLin   :=185
			nCol   :=aColunas[1] //050
			oPrn:StartPage()
		End If
	Next nEtiq
	LISTA->(dbSkip())
	IncProc()                 	
End Do                        
oPrn:EndPage()
SM0->(dbGoTo(nAnt))

Return

Static Function Admissao(dData)
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Gera extenso de data.                                                    |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Admissão.                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
Return StrZero( Day( dData ) , 2 )+" de "+MesExtenso( dData )+" de "+StrZero( Year( dData ) , 4 )


Static Function SepTxt(cExt,nTam,lEsp)
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Trata o texto.                              |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Admissão.                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/
aRet:={}
Do While .T.
	If Len(cExt) <= nTam
		Aadd(aRet,cExt)
		Exit
	End If
	nPos := Rat(" ",Subs(cExt,1,nTam))
	If nPos >= nTam
		Aadd(aRet,Subs(cExt,1,nTam))
		cExt:=Substr(cExt,nTam+1)
	Else
		If Empty(aRet) .and. lEsp
			Aadd(aRet,Repl(' ',nTam-nPos)+Subs(cExt,1,nPos))
			cExt:=Subs(cExt,nPos+1)
		Else
			Aadd(aRet,Subs(cExt,1,nPos))
			cExt:=Subs(cExt,nPos+1)
		End If
	End If
End Do
Return aRet


Static Function AjustSx1()
/*
+----------------------------------------------------------------------------------------+
| <Descricao>.: Cria Grupo de Perguntas da Rotina.                                       |
| <Autor>.....: Alexandre Alves da Silva - OPVS.                                         |
| <Data>......: 06/04/2015.                                                              |
| <Parametros>: Não Há.                                                                  |
| <Retorno>...: NIL.                                                                     |
| <Processos>.: Gestão de Pessoal - Admissão.                                            |
| <Tipo>......: (Menu, Trigger, Validacao, Ponto de Entrada, Genericas, Especificas): E  |
| <Observacao>:                                                                          |
+----------------------------------------------------------------------------------------+
*/

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }
//PutSx1(cGrupo  ,cOrdem ,cPergunt      ,cPerSpa       ,cPerEng       ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3   ,cGrpSxg ,cPyme ,cVar01     ,cDef01 ,cDefSpa1 ,cDefEng1 ,cCnt01 ,cDef02 ,cDefSpa2 ,cDefEng2 ,cDef03 ,cDefSpa3 ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1("CTGPR1","01"   ,"De  Filial?" ,"De  Filial?" ,"De  Filial?" ,"mv_ch1" ,"C"   ,02       ,0        ,0       ,"G"  ,""     ,"XM0" ,""      ,""    ,"mv_par01" ,""     ,""       ,""       ,""     ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Filial inicial para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR101.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","02","Ate Filial?","Ate Filial?","Ate Filial?","mv_ch2","C",02,0,0,"G","","XM0","","","mv_par02","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Filial final para filtrar os registros" ) 
Aadd( aHelpPor, " a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR102.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","03","Periodo De ?","Periodo De ?","Periodo De ?","mv_ch3","D",8,0,0,"G","NaoVazio","","","","mv_par03","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Periodo Inicial para filtro da Admissao.")
PutSX1Help("P.CTGPR103.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","04","Periodo Ate ?","Periodo Ate ?","Periodo Ate ?","mv_ch4","D",8,0,0,"G","NaoVazio","","","","mv_par04","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Periodo Final para filtro da Admissao.")
PutSX1Help("P.CTGPR104.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","05","De Funcionario?","De Funcionario?","De Funcionario?","mv_ch5","C",06,0,0,"G","","SRA","","","mv_par05","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Funcionario inicial para filtrar os" ) 
Aadd( aHelpPor, " registros a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR105.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","06","Ate Funcionario?","Ate Funcionario?","Ate Funcionario?","mv_ch6","C",06,0,0,"G","","SRA","","","mv_par06","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Funcionario final para filtrar os" ) 
Aadd( aHelpPor, " registros a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR106.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","07","De  centro de custos?","De  centro de custos?","De  centro de custos?","mv_ch7","C",09,0,0,"G","","CTT","","","mv_par07","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Centro de custos inicial para filtrar os" ) 
Aadd( aHelpPor, " registros a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR107.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","08","Ate centro de custos?","Ate centro de custos?","Ate centro de custos?","mv_ch8","C",09,0,0,"G","","CTT","","","mv_par08","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Centro de custos final para filtrar os" ) 
Aadd( aHelpPor, " registros a serem impressos no relatorio." ) 
PutSX1Help("P.CTGPR108.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","09","Situações ?","Situações ?","Situações ?","mv_ch9","C",5,0,0,"G","fSituacao","","","","mv_par09","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Situacoes a filtrar.")
PutSX1Help("P.CTGPR109.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt       ,cPerSpa        ,cPerEng        ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3 ,cGrpSxg ,cPyme ,cVar01     ,cDef01    ,cDefSpa1  ,cDefEng1  ,cCnt01 ,cDef02    ,cDefSpa2  ,cDefEng2 ,cDef03     ,cDefSpa3   ,cDefEng3 ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1("CTGPR1","10"   ,"Lin Inicial ?","Lin Inicial ?","Lin Inicial ?","mv_cha" ,"N"   ,1        ,0        ,1       ,"C"  ,""     ,""  ,""      ,""    ,"mv_par10" ,"Linha 1" ,"Linea 1" ,"Line 1"  ,""     ,"Linha 2" ,"Linea 2" ,"Line 2" ,"Linha 3"  ,"Linea 3"  ,"Line 3" ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Linha inicial para impressao ")
Aadd( aHelpPor, "das etiquetas.")
PutSX1Help("P.CTGPR110.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

//PutSx1(cGrupo  ,cOrdem ,cPergunt        ,cPerSpa         ,cPerEng         ,cVar     ,cTipo ,nTamanho ,nDecimal ,nPresel ,cGSC ,cValid ,cF3 ,cGrpSxg ,cPyme ,cVar01     ,cDef01     ,cDefSpa1    ,cDefEng1   ,cCnt01 ,cDef02     ,cDefSpa2    ,cDefEng2   ,cDef03     ,cDefSpa3    ,cDefEng3   ,cDef04 ,cDefSpa4 ,cDefEng4 ,cDef05 ,cDefSpa5 ,cDefEng5           ,aHelpPor                ,aHelpEng           ,aHelpSpa           ,cHelp )                                               
  PutSX1("CTGPR1","11"   ,"Col Inicial ?" ,"Col Inicial ?" ,"Col Inicial ?" ,"mv_chb" ,"N"   ,1        ,0        ,1       ,"C"  ,""     ,""  ,""      ,""    ,"mv_par11" ,"Coluna 1" ,"Columna 1" ,"Column 1" ,""     ,"Coluna 2" ,"Columna 2" ,"Column 2" ,"Coluna 3" ,"Columna 3" ,"Column 2" ,""     ,""       ,""       ,""     ,""       ,"")

Aadd( aHelpPor, "Coluna Inicial. ")
PutSX1Help("P.CTGPR111.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

PutSX1("CTGPR1","12","Esp.Estabelecimento ?","Esp.Estabelecimento ?","Esp.Estabelecimento ?","mv_chc","C",20,0,0,"G","NaoVazio","","","","mv_par12","","","","","","","","","","","","","","","","")

Aadd( aHelpPor, "Esp.Estabelecimento.")
PutSX1Help("P.CTGPR112.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//

Return