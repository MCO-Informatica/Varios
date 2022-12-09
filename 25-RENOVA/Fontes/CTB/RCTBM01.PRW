#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "jpeg.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RCTBM01   ³Autor  ³Cosme da Silva Nunes   ³Data  ³27/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa para gerar balancete mensal para envio a ANEEL     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³- Exportação de Balancete Mensal Padronizado em formato TXT ³±±
±±³          ³- Integração com o sistema BMP-Balancete Mensal Padronizado ³±±
±±³          ³  Módulo de Críticas para validação                         ³±±
±±³          ³- Envio a ANEEL                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCTBM01()

Private cPerg      := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas no SX1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := PADR( "CTBM01" , LEN( SX1->X1_GRUPO ) )
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

Processa( { || U_RCTBM01A( .T. ) } , "Aguarde..." , , .T. )//Inicializa a regua de processamento

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ValidPerg ³Autor  ³Cosme da Silva Nunes   ³Data  ³27/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Cria Pergunta no SX1                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³nomeprog                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs := {}

//Estrutura	{Grupo	/Ordem	/Pergunta				/Pergunta Espanhol		/Pergunta Ingles		/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid									   			   		/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01							/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
//Aadd(aRegs,{cPerg	,"01"	,"Mes"					,"Mes"					,"Mes"					,"mv_ch1"	,"C"	, 2			,0			,0		,"G"	,"Pertence('01/02/03/04/05/06/07/08/09/10/11/12')"			,"mv_par01"	,""			,""			,""			,"Str(Month(dDataBase))"		,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""		,""		}	)
//Aadd(aRegs,{cPerg	,"02"	,"Ano"					,"Ano"					,"Ano"					,"mv_ch2"	,"C"	, 4			,0			,0		,"G"	,""									   	  					,"mv_par02"	,""			,""			,""			,"Str(Year(dDataBase))"			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""		,""		}	)

//Aadd(aRegs,{cPerg	,"01"	,"Periodo De ?"			,"Periodo De ?"			,"Periodo De ?"			,"mv_ch1"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par01"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
//Aadd(aRegs,{cPerg	,"02"	,"Periodo Ate ?"  		,"Periodo Ate ?"		,"Periodo Ate ?"		,"mv_ch2"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)

//Aadd(aRegs,{cPerg	,"01"	,"Cód.Empresa ?"  		,"Cód.Empresa ?"		,"Cód.Empresa ?"		,"mv_ch1"	,"C"	, 3			,0			,0		,"G"	,"NAOVAZIO"                                         		,"mv_par01"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
//Aadd(aRegs,{cPerg	,"02"	,"Data Fecham. ?" 		,"Data Fecham. ?"		,"Data Fecham. ?"		,"mv_ch2"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)

Aadd(aRegs,{cPerg	,"01"	,"Padrão do DUTO ?"		,"Padrão do DUTO ?"		,"Padrão do DUTO ?"		,"mv_ch1"	,"C"	, 3			,0			,0		,"G"	,"NAOVAZIO"                                            		,"mv_par01"	,""			,""			,""			,"APL"                 			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"02"	,"Aplicação	 ?" 		,"Aplicação ?"			,"Aplicação ?"			,"mv_ch2"	,"C"	, 3			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,"BMP"							,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"03"	,"Ident. do Agente ?" 	,"Ident. do Agente ?"	,"Ident. do Agente ?"	,"mv_ch3"	,"C"	, 4			,0			,0		,"G"	,"NAOVAZIO"                                         		,"mv_par03"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"04"	,"Sigla do Agente ?" 	,"Sigla do Agente ?"	,"Sigla do Agente ?"	,"mv_ch4"	,"C"	,60			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par04"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"05"	,"Data Fecham. ?" 		,"Data Fecham. ?"		,"Data Fecham. ?"		,"mv_ch5"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par05"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"06"	,"Versão Arquivo ?"  	,"Versão Arquivo ?"		,"Versão Arquivo ?"		,"mv_ch6"	,"C"	, 1			,0			,0		,"G"	,"Pertence('ABCDEFGHIJKLMNOPQRSTUVWXYZ')"					,"mv_par06"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"07"	,"Cód.Empresa ?"  		,"Cód.Empresa ?"		,"Cód.Empresa ?"		,"mv_ch7"	,"C"	, 3			,0			,0		,"G"	,"NAOVAZIO"                                         		,"mv_par07"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)

lValidPerg( aRegs )

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³RCTBM01A  ³Autor  ³Cosme da Silva Nunes   ³Data  ³27/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCTBM01A()

Private aStructure 	:= {}
Private cArqTRB    	:= ""
Private cMes    	:= ""
Private cAno    	:= ""
Private _aStru		:= {}
Private _cArqTRB  	:= ""

Private _cDirExp  	:= ""
Private cArquivo   	:= ""
Private _cArqExp  	:= ""

Private cDirDestino := ""
Private cMemo1 		:= ""
Private lCopiou 	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao de arquivo temporario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aStructure,{"CODEMP"	,"C",003,0})//
Aadd(aStructure,{"MES"		,"C",002,0})//
Aadd(aStructure,{"ANO"		,"C",004,0})//
Aadd(aStructure,{"CONTA"	,"C",009,0})//
Aadd(aStructure,{"DEBITO"	,"N",018,2})//
Aadd(aStructure,{"CREDITO"	,"N",018,2})//
Aadd(aStructure,{"SALDO"	,"N",018,2})//
cArqTRB := CriaTrab(aStructure,.T.)
dbUseArea(.T.,__LocalDriver,cArqTRB,"TRB",.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CT1")
dbSetOrder(1)//
dbSeek( xFilial("CT1") + CT1->CT1_CONTA )
While !Eof()

	IncProc("Processando...")

	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		TRB->CODEMP  := MV_Par07
		TRB->MES	 := cMes := StrZero( Month( MV_Par05 ), 2 )
		TRB->ANO	 := cAno := StrZero( Year( MV_Par05 ), 4 )
		TRB->CONTA	 := CT1->CT1_CONTA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ C T B   X   F U N
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ Saldo do Plano de Contas
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ SaldoCT7(cConta,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP,cFilEsp,cArqCt7)
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ ExpC1 = Conta Contabil
		//³ ExpD1 = Data
		//³ ExpC2 = Moeda
		//³ ExpC3 = Tipo de Saldo
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ SaldoCT7("100000000",dDataBase,"01","1")
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ Retorno:                                                                        ³
		//³ [1] Saldo Atual (com sinal)                                                     ³
		//³ [2] Debito na Data                                                              ³
		//³ [3] Credito na Data                                                             ³
		//³ [4] Saldo Atual Devedor                                                         ³
		//³ [5] Saldo Atual Credor                                                          ³
		//³ [6] Saldo Anterior (com sinal)                                                  ³
		//³ [7] Saldo Anterior Devedor                                                      ³
		//³ [8] Saldo Anterior Credor                                                       ³
		//³ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		//³ msginfo(SaldoCT7("100000000",dDataBase,"01","1")[3])                            
		//³ msginfo( RetMasCTB("100000000",".") ) 
		//³ msginfo( MascaraCTB("100000000",RetMasCTB("001",".")) ) 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		TRB->DEBITO	 := SaldoCT7(CT1->CT1_CONTA,MV_Par05,"01","1")[2]
		TRB->CREDITO := SaldoCT7(CT1->CT1_CONTA,MV_Par05,"01","1")[3]
		TRB->SALDO	 := SaldoCT7(CT1->CT1_CONTA,MV_Par05,"01","1")[1]
	MsUnlock()
	dbSelectArea("CT1")
	dbSkip()
EndDo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao de arquivo temporario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(_aStru,{"LINHA"     ,"C",78,0})
_cArqTRB  := CriaTrab(_aStru,.T.)
dbUseArea(.T.,__LocalDriver,_cArqTRB,"LIN",.F.,.F.)

dbSelectArea("TRB")
dbGotop()
While !Eof()

	cLinha 	:= 	TRB->CODEMP
	cLinha 	+=	TRB->MES
	cLinha 	+=	TRB->ANO
	cLinha 	+=	TRB->CONTA
	cLinha 	+=	StrZero(TRB->DEBITO,20)
	cLinha 	+=	StrZero(TRB->CREDITO,20)

	cTRBSALDO := StrZero(TRB->SALDO,20)
	If cTRBSALDO $ "-" //Valor Negativo
		cLinha 	+=	cTRBSALDO
	ElseIf cTRBSALDO == "00000000000000000000" //Valor Zero
		cLinha 	+=	cTRBSALDO
	ElseIf cTRBSALDO $ "123456789" //Valor Positivo
		cLinha 	+=	"+" + StrZero(TRB->SALDO,19)
	EndIf

	dbSelectArea("LIN")
    dbAppend()
    LIN->LINHA := cLinha

	dbSelectArea("TRB")
	dbSkip()

EndDo                 
dbSelectArea("TRB")
dbCloseArea()

//Exporta arquivo de trabalho para txt
dbSelectArea("LIN")
_cDirExp  := "\bmp\" //GETMV("MV_DIREXP")  // "\EXPORT\"
cArquivo  := MV_Par01 + MV_Par02 + MV_Par03 + "_" + AllTrim(MV_Par04) +"_" + cAno+cMes + MV_Par06 + ".txt"
_cArqExp  := _cDirExp + cArquivo
Copy to &_cArqExp SDF
dbCloseArea()

//Transferencia de Arquivos
cDirDestino := cGetFile(OemtoAnsi("Transferência do Arquivo BMP"),OemToAnsi("Selecione o Diretório Destino"),0,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
lCopiou 	:=  CpyS2T( _cArqExp , cDirDestino , .T. )
cMemo1 		:= "ARQUIVO " + cArquivo + IIF(lCopiou,"  TRANSFERIDO PARA " + cDirDestino , "  ERRO TRANSF... ")+Chr(13)+Chr(10)
MsgInfo(cMemo1)

Return()