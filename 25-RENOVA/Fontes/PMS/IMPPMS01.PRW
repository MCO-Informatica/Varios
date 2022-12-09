#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"                              
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPMS01  ºAutor  ³Adriano da Silva    º Data ³  02/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação das Tarefas do Sistema Clarity para o Modulo de º±±
±±º          ³ Gestão de Projetos (PMS) - Via Menu                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova Energia                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPPMS01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nHdl		:= 0
Private cPath		:= GetSrvProfString("RootPath","")
Private aLogErros 	:= {}
Private	cImpDir		:= GetMv("MV_XIMPPMS",.T.,"\development\entrada")		// Criar Diretorio Abaixo do RootPath
Private	cImpPrc		:= GetMv("MV_XPRCPMS",.T.,"\developmentprocessados\")	// Criar Diretorio Abaixo do RootPath
Private	cImpLog		:= GetMv("MV_XLOGPMS",.T.,"\development\logs\")			// Criar Diretorio Abaixo do RootPath
Private aRetFils	:= {}
Private aArquivos	:= {}
Private nContAF8  	:= 0	//Romay 22-07-15
Private nContAF9  	:= 0	//Romay 22-07-15
Private nContAFC  	:= 0	//Romay 22-07-15

If !oApp:lMdi
	Alert("Favor processar essa rotina no tema SIGAMDI!")
	Return
EndIf

DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())
While SM0->(!Eof())
	Aadd(aRetFils,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_CGC})
	SM0->(Dbskip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Função Padrão Para Verificar os Arquivos TXT do Diretorio           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aArchivos := Directory(cPath+cImpDir+"*.TXT","D",,.F.) 
aArchivos := Directory(cImpDir+"*.TXT","D",,.F.)
If Len(aArchivos)==0
	Alert("Arquivo não encontrado!")		
	Return
EndIf

U_IMPPMSGR(aArquivos,aRetFils)

//StartJob("U_IMPPMSGR",GetEnvServer(),.F.,aArquivos,aRetFils)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Importa  ºAutor  ³Microsiga           º Data ³  08/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPPMSGR(aArquivos,aRetFils)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCodEmp	:= ""
Local cCodFil	:= ""
Local aTables	:= {"AF8","AFC","AF9","AFN","AFR"}
Local nLinhas	:= 0
Local nLinhas	:= 0
Local cArqPrc 	:= ""
Local aArqPrc 	:= {}
Local cTexPrc	:= ""


For nX:=1 To Len(aArchivos)
	
	//IncProc("Analisando Arquivos de Importação...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abertura do arquivo texto      			                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	nHdl := FT_FUSE(cPath+cImpDir+aArchivos[nX][1])
	nHdl := FT_FUSE(cImpDir+aArchivos[nX][1])
	If nHdl <= 0
		Aadd(aLogErros,{"Linha:0 | Não foi possivel a abertura do arquivo texto "+AllTrim(aArchivos[nX][1])+" !"})
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Arquivo Texto Não tem Erros                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aLogErros) > 0
		GravaLog(aLogErros,aArchivos[nX][1])
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Inicio do Arquivo Texto	                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FGOTOP()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Quantidade de Linhas do Arquivo Texto	                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinhas := FT_FLastRec()
	If nLinhas == 0
		Aadd(aLogErros,{"Linha:0 | O arquivo "+AllTrim(aArchivos[nX][1])+" de importação está em branco!"})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Arquivo Texto Não tem Erros                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aLogErros) > 0
		GravaLog(aLogErros,aArchivos[nX][1])
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reposiciona no Inicio do Arquivo Texto Para Começo da Importação    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FGOTOP()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contador de Linhas do Arquivo Para Log de Erros					    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinArq  := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o Nome do Arquivo Processados								    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqPrc := SubStr(Rtrim(aArchivos[nX][1]),1,Len(AllTrim(aArchivos[nX][1]))-4)+"_"+DtoS(Date())+".txt"
	aArqPrc := {}
	cTexPrc	:= ""
	
	While !FT_FEOF()
		
		nLinArq := nLinArq + 1
		nPosCGC := 0
		cCodEmp	:= ""
		cCodFil	:= ""
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida se existe projeto e EDT Romay 22-07-15					    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	  	cCodProjeto := SubStr(FT_FReadLn(),17,10)             
		
		If nLinArq == 1
			
			If SubStr(FT_FReadLn(),16,1) <> "1"		//Se Nao for projeto
				Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O projeto "+cCodProjeto+" não existe no arquivo de importação!"})			
				GravaLog(aLogErros,aArchivos[nX][1])
				Return
			Else // Se for projeto 
				nLinIncl := nLinArq
			EndIf
			
			cCodProjAnt := SubStr(FT_FReadLn(),17,10)
			
		Else // qualquer linha fora a primeira
		
			If cCodProjAnt <> cCodProjeto // Se for outro codigo de projeto

				If SubStr(FT_FReadLn(),16,1) <> "1"		//Se Nao for projeto
					Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O projeto "+cCodProjeto+" não existe no arquivo de importação!"})
					GravaLog(aLogErros,aArchivos[nX][1])
					Return
				Else// Se for projeto
					nLinIncl := nLinArq
				EndIf
			    
				cCodProjAnt := SubStr(FT_FReadLn(),17,10)
	
			Else //Se for mesmo codigo de projeto
			
				If nLinArq == nLinIncl + 1	
				     
					If SubStr(FT_FReadLn(),16,1) <> "2"		//Se Nao for EDT
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| Não existe EDT no arquivo de importação para o projeto "+cCodProjeto+"!"})
						GravaLog(aLogErros,aArchivos[nX][1])
						Return
					EndIf					
				
				EndIf
			
				cCodProjAnt := SubStr(FT_FReadLn(),17,10)
				
			EndIf
			
		EndIf		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa no Cadastro de Empresas o CNPJ Informado no Arquivo	    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SubStr(FT_FReadLn(),1,1))
			nPosCGC := aScan(aRetFils,{|x| Alltrim(x[3]) == SubStr(FT_FReadLn(),1,14) })
			If nPosCGC == 0
				Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O CNPJ informado no arquivo não esta no cadastro de empresas do Protheus (Sigamat.emp)!"})
			Else
				cCodEmp := aRetFils[nPosCGC][1]	//Codigo da Empresa
				cCodFil := Alltrim(aRetFils[nPosCGC][2])	//Codigo da Filial - romay adicionado alltrim 22-07-2015
			EndIf
		EndIf
		
		If nPosCGC > 0
			
			RpcClearEnv()
			RPCSetType(3)
			RpcSetEnv( cCodEmp,cCodFil,,,,,,,,,)
			
			cTipOper := SubStr(FT_FReadLn(),15,1)
			cTabImp  := ""
			cCodProj := ""
			
			If SubStr(FT_FReadLn(),16,1) == "1"		//Projeto
				cTabImp := "AF8"
			ElseIf SubStr(FT_FReadLn(),16,1) == "2"	//EDT
				cTabImp := "AFC"
			ElseIf SubStr(FT_FReadLn(),16,1) == "3"	//Tarefa
				cTabImp := "AF9"
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Importação do Cadastro de Projetos (Tabela AF8)					    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cTabImp == "AF8"
				
				cCodProj := ""
				cNomProj := ""
				dDtIni	 := Ctod("")
				dDtFim	 := Ctod("")
				
				cCodProj := PadR(AllTrim(SubStr(FT_FReadLn(),17,10)),TamSX3("AF8_PROJET")[1])
				cNomProj := RTrim(SubStr(FT_FReadLn(),27,90))
				dDtIni	 := StoD(SubStr(FT_FReadLn(),117,8))
				dDtFim	 := StoD(SubStr(FT_FReadLn(),125,8))
				
				DbSelectArea("AF8")	// Cadastro de Projetos
				DbGoTop()
				DbSetOrder(1)		// AF8_FILIAL + AF8_PROJET
				If cTipOper == "1"	// Inclusão
					If !DbSeek(cCodFil+cCodProj)
						RecLock("AF8",.T.)
						//Campos Importados do Arquivo Texto
						AF8->AF8_FILIAL := cCodFil
						AF8->AF8_PROJET := cCodProj
						AF8->AF8_DESCRI	:= cNomProj
						AF8->AF8_START	:= dDtIni
						AF8->AF8_FINISH	:= dDtFim
						//Campos Default do Projeto
						AF8->AF8_DATA	:= Date()
						AF8->AF8_REVISA	:= "0001"
						AF8->AF8_TPPRJ	:= "0001"
						AF8->AF8_CALEND	:= "001"
						AF8->AF8_FASE	:= "01"
						AF8->AF8_PRJREV	:= "1"
						AF8->AF8_CTRUSR	:= "2"
						AF8->AF8_TPCUS	:= "1"
						AF8->AF8_MASCAR	:= "2222222222"
						AF8->AF8_RECALC	:= "2"
						AF8->AF8_NMAX	:= 999
						AF8->AF8_NMAXF3	:= 999
						AF8->AF8_TRUNCA	:= "1"
						AF8->AF8_AUTCUS	:= "1"
						AF8->AF8_ENCPRJ	:= "2"
						AF8->AF8_PRIREA	:= "1"
						AF8->AF8_CUSOP	:= "1"
						AF8->AF8_CUSOPE	:= "1"
						AF8->AF8_REAFIX	:= "1"
						//AF8->AF8_USAAJT	:= "2"
						//AF8->AF8_AJCUST	:= "0"
						AF8->AF8_PAR002	:= "3"
						AF8->AF8_PAR003	:= "2"
						AF8->AF8_PAR004	:= "2"
						AF8->AF8_PAR005	:= "1"
						AF8->AF8_PAR006	:= "2"
						MsUnLock() 
						
						nContAF8++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" já existe no cadastro de Projetos (Tabela AF8)!"})
					EndIf
				ElseIf cTipOper == "2" //Alteração
					If DbSeek(cCodFil+cCodProj)
						RecLock("AF8",.F.)
						AF8->AF8_PROJET := cCodProj
						AF8->AF8_DESCRI	:= cNomProj
						AF8->AF8_START	:= dDtIni
						AF8->AF8_FINISH	:= dDtFim
						MsUnLock()
						
						nContAF8++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não existe no cadastro de Projetos (Tabela AF8) para alteração!"})
					EndIf
				ElseIf cTipOper == "3"//Exclusão
					If VldDelImp("AF8",cCodFil,cCodProj)
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não pode ser excluido devido ao relacionamento com as tabelas AFR e AFN!"})
					Else
						If DbSeek(cCodFil+cCodProj)
							RecLock("AF8",.F.)
							DbDelete()
							MsUnLock()
							
							nContAF8++
						Else
							Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não existe no cadastro de Projetos (Tabela AF8) para exclusão!"})
						EndIf
					EndIf
				EndIf
				
				//***************************************
				//Alteração no fonte feito por Robson Mazzarotto para conteplar a EAP principal do Projeto
				
				DbSelectArea("AFC")	// Cadastro de Projetos
				DbGoTop()
				DbSetOrder(1)		// AFC_FILIAL + AFC_PROJET
				If cTipOper == "1"	// Inclusão
					If !DbSeek(cCodFil+cCodProj+"0001"+cCodProj)
						RecLock("AFC",.T.)
						//Campos Importados do Arquivo Texto
						AFC->AFC_FILIAL := cCodFil
						AFC->AFC_PROJET := cCodProj
						AFC->AFC_REVISA	:= "0001"
						AFC->AFC_EDT    := cCodProj
						AFC->AFC_NIVEL  := "001"
						AFC->AFC_DESCRI	:= cNomProj
						AFC->AFC_UM 	:= "UN"
						AFC->AFC_QUANT	:= 1.0000
						AFC->AFC_CALEND	:= "001"
						AFC->AFC_START	:= dDtIni
						AFC->AFC_FINISH	:= dDtFim
						MsUnLock()    
						
						nContAFC++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" já existe no cadastro de Projetos (Tabela AFC)!"})
					EndIf
				ElseIf cTipOper == "2" //Alteração
					If DbSeek(cCodFil+cCodProj)
						RecLock("AFC",.F.)
						AFC->AFC_PROJET := cCodProj
						AFC->AFC_DESCRI	:= cNomProj
						AFC->AFC_START	:= dDtIni
						AFC->AFC_FINISH	:= dDtFim
						MsUnLock()  
						
						nContAFC++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não existe no cadastro de Projetos (Tabela AFC) para alteração!"})
					EndIf
				ElseIf cTipOper == "3"//Exclusão
					If VldDelImp("AFC",cCodFil,cCodProj)
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não pode ser excluido devido ao relacionamento com as tabelas AFR e AFN!"})
					Else
						If DbSeek(cCodFil+cCodProj)
							RecLock("AFC",.F.)
							DbDelete()
							MsUnLock()
							
							nContAFC++
						Else
							Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do projeto "+cCodProj+" não existe no cadastro de Projetos (Tabela AFC) para exclusão!"})
						EndIf
					EndIf
				EndIf
				
				//***************************************
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Importação do Cadastro de Estrutura de Projetos (Tabela AFC)	    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf cTabImp == "AFC"
				
				cCodProj:= ""
				cCodEdt	:= ""
				cNomEdt	:= ""
				nQtdEdt	:= 0
				nDurHor	:= 0
				dDtIni	:= Ctod("")
				dDtFim	:= Ctod("")
				cHrIni 	:= ""
				cHrFim	:= ""
				cEdtPai	:= ""
				cCodNiv	:= ""
				
				cCodProj:= PadR(AllTrim(SubStr(FT_FReadLn(),17,10)),TamSX3("AFC_PROJET")[1])
				cCodEdt	:= PadR(AllTrim(SubStr(FT_FReadLn(),27,30)),TamSX3("AFC_EDT")[1])
				cNomEdt	:= RTrim(SubStr(FT_FReadLn(),57,90))
				nQtdEdt	:= Val(SubStr(FT_FReadLn(),147,14))
				nDurHor	:= Val(SubStr(FT_FReadLn(),161,14))
				dDtIni	:= StoD(SubStr(FT_FReadLn(),175,8))
				dDtFim	:= StoD(SubStr(FT_FReadLn(),183,8))
				cHrIni 	:= IIf(Len(RTrim(SubStr(FT_FReadLn(),197,5)))==4,Transform(RTrim(SubStr(FT_FReadLn(),197,5))+"0","99:99"),Transform(RTrim(SubStr(FT_FReadLn(),197,5)),"99:99")) //RTrim(SubStr(FT_FReadLn(),197,5))
				cHrFim	:= IIf(Len(RTrim(SubStr(FT_FReadLn(),202,5)))==4,Transform(RTrim(SubStr(FT_FReadLn(),202,5))+"0","99:99"),Transform(RTrim(SubStr(FT_FReadLn(),202,5)),"99:99")) //Rtrim(SubStr(FT_FReadLn(),202,5))
				cEdtPai	:= PadR(AllTrim(SubStr(FT_FReadLn(),207,30)),TamSX3("AFC_EDTPAI")[1])
				cCodNiv	:= Rtrim(SubStr(FT_FReadLn(),237,3))
				
				DbSelectArea("AFC")	// Estrutura do Projeto
				DbGoTop()
				DbSetOrder(1)		// AFC_FILIAL+AFC_PROJET+AFC_REVISA+AFC_EDT+AFC_ORDEM
				If cTipOper == "1"	// Inclusão
					If !DbSeek(cCodFil+cCodProj+"0001"+cCodEdt)
						RecLock("AFC",.T.)
						//Campos Importados do Arquivo Texto
						AFC->AFC_FILIAL := cCodFil
						AFC->AFC_PROJET := cCodProj
						AFC->AFC_EDT	:= cCodEdt
						AFC->AFC_DESCRI	:= cNomEdt
						AFC->AFC_UM     := "UN"
						AFC->AFC_QUANT	:= nQtdEdt
						AFC->AFC_HDURAC	:= nDurHor
						AFC->AFC_START	:= dDtIni
						AFC->AFC_FINISH	:= dDtFim
						AFC->AFC_HORAI	:= cHrIni
						AFC->AFC_HORAF	:= cHrFim
						AFC->AFC_EDTPAI	:= cEdtPai
						AFC->AFC_NIVEL	:= cCodNiv
						//Campos Default da Estrutura de Projeto(EDT)
						AFC->AFC_REVISA	:= "0001"
						AFC->AFC_CALEND	:= "001"
						AFC->AFC_RESTRI	:= "3"
						MsUnLock()
						
						nContAFC++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da EDT "+cCodEdt+" já existe no cadastro de Estrutura de Projetos (Tabela AFC)!"})
					EndIf
				ElseIf cTipOper == "2" //Alteração
					If DbSeek(cCodFil+cCodProj+"0001"+cCodEdt)
						RecLock("AFC",.F.)
						AFC->AFC_PROJET := cCodProj
						AFC->AFC_EDT	:= cCodEdt
						AFC->AFC_DESCRI	:= cNomEdt
						AFC->AFC_QUANT	:= nQtdEdt
						AFC->AFC_HDURAC	:= nDurHor
						AFC->AFC_START	:= dDtIni
						AFC->AFC_FINISH	:= dDtFim
						AFC->AFC_HORAI	:= cHrIni
						AFC->AFC_HORAF	:= cHrFim
						AFC->AFC_EDTPAI	:= cEdtPai
						AFC->AFC_NIVEL	:= cCodNiv
						MsUnLock()
						
						nContAFC++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da EDT "+cCodProj+" não existe no ccadastro de Estrutura de Projetos (Tabela AFC) para alteração!"})
					EndIf
				ElseIf cTipOper == "3"//Exclusão
					If VldDelImp("AFC",cCodFil,cCodProj)
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código do Projeto/EDT "+cCodProj+" não pode ser excluido devido ao relacionamento com as tabelas AFR e AFN!"})
					Else
						If DbSeek(cCodFil+cCodProj+"0001"+cCodEdt)
							RecLock("AFC",.F.)
							DbDelete()
							MsUnLock()
							
							nContAFC++
						Else
							Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da EDT "+cCodProj+" não existe no ccadastro de Estrutura de Projetos (Tabela AFC) para exclusão!"})
						EndIf
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Importação do Cadastro de Tarefas do Projeto (Tabela AF9)		    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf cTabImp == "AF9"
				
				cCodProj:= ""
				cCodTrf	:= ""
				cNomTrf	:= ""
				nQtdTrf	:= 0
				nDurHor	:= 0
				dDtIni	:= Ctod("")
				dDtFim	:= Ctod("")
				cHrIni 	:= ""
				cHrFim	:= ""
				cEdtPai	:= ""
				cCodNiv	:= ""
				
				cCodProj:= PadR(AllTrim(SubStr(FT_FReadLn(),17,10)),TamSX3("AF9_PROJET")[1])
				cCodTrf	:= PadR(AllTrim(SubStr(FT_FReadLn(),27,30)),TamSX3("AF9_TAREFA")[1])
				cNomTrf	:= RTrim(SubStr(FT_FReadLn(),57,90))
				nQtdTrf	:= Val(SubStr(FT_FReadLn(),147,14))
				nDurHor	:= Val(SubStr(FT_FReadLn(),161,14))
				dDtIni	:= StoD(SubStr(FT_FReadLn(),175,8))
				dDtFim	:= StoD(SubStr(FT_FReadLn(),183,8))
				cHrIni 	:= IIf(Len(RTrim(SubStr(FT_FReadLn(),197,5)))==4,Transform(RTrim(SubStr(FT_FReadLn(),197,5))+"0","99:99"),Transform(RTrim(SubStr(FT_FReadLn(),197,5)),"99:99")) //RTrim(SubStr(FT_FReadLn(),197,5))
				cHrFim	:= IIf(Len(RTrim(SubStr(FT_FReadLn(),202,5)))==4,Transform(RTrim(SubStr(FT_FReadLn(),202,5))+"0","99:99"),Transform(RTrim(SubStr(FT_FReadLn(),202,5)),"99:99")) //Rtrim(SubStr(FT_FReadLn(),202,5))
				cEdtPai	:= PadR(AllTrim(SubStr(FT_FReadLn(),207,30)),TamSX3("AF9_EDTPAI")[1])
				cCodNiv	:= Rtrim(SubStr(FT_FReadLn(),237,3))
				
				DbSelectArea("AF9")	// Tarefas do Projeto
				DbGoTop()
				DbSetOrder(1)		// AF9_FILIAL+AF9_PROJET+AF9_REVISA+AF9_TAREFA+AF9_ORDEM
				If cTipOper == "1"	// Inclusão
					If !DbSeek(cCodFil+cCodProj+"0001"+cCodTrf)
						RecLock("AF9",.T.)
						//Campos Importados do Arquivo Texto
						AF9->AF9_FILIAL := cCodFil
						AF9->AF9_PROJET := cCodProj
						AF9->AF9_TAREFA	:= cCodTrf
						AF9->AF9_DESCRI	:= cNomTrf
						AF9->AF9_QUANT	:= nQtdTrf
						AF9->AF9_CALEND	:= "001"
						AF9->AF9_HDURAC	:= nDurHor
						AF9->AF9_START	:= dDtIni
						AF9->AF9_FINISH	:= dDtFim
						AF9->AF9_HORAI	:= cHrIni
						AF9->AF9_HORAF	:= cHrFim
						AF9->AF9_EDTPAI	:= cEdtPai
						AF9->AF9_NIVEL	:= cCodNiv
						//Campos Default da Tarefa do Projeto
						AF9->AF9_REVISA	:= "0001"
						AF9->AF9_EMAIL	:= "02"
						AF9->AF9_PRIORI	:= 500
						AF9->AF9_RESTRI	:= "7"
						AF9->AF9_TPMEDI	:= "4"
						AF9->AF9_TPTRF	:= "1"
						AF9->AF9_AGCRTL	:= "2"
						AF9->AF9_TPHORA	:= "3"
						AF9->AF9_RASTRO	:= 1
						MsUnLock()
						
						nContAF9++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da Tarefa "+cCodTrf+" já existe no cadastro de Tarefas (Tabela AF9)!"})
					EndIf
				ElseIf cTipOper == "2" //Alteração
					If DbSeek(cCodFil+cCodProj+"0001"+cCodTrf)
						RecLock("AF9",.F.)
						AF9->AF9_PROJET := cCodProj
						AF9->AF9_TAREFA	:= cCodTrf
						AF9->AF9_DESCRI	:= cNomTrf
						AF9->AF9_QUANT	:= nQtdTrf
						AF9->AF9_HDURAC	:= nDurHor
						AF9->AF9_START	:= dDtIni
						AF9->AF9_FINISH	:= dDtFim
						AF9->AF9_HORAI	:= cHrIni
						AF9->AF9_HORAF	:= cHrFim
						AF9->AF9_EDTPAI	:= cEdtPai
						AF9->AF9_NIVEL	:= cCodNiv
						MsUnLock()
						
						nContAF9++
					Else
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da Tarefa "+cCodTrf+" não existe no cadastro de Tarefas (Tabela AF9) para alteração!"})
					EndIf
				ElseIf cTipOper == "3"//Exclusão
					If VldDelImp("AF9",cCodFil,cCodProj,)
						Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da Tarefa "+cCodTrf+" não pode ser excluido devido ao relacionamento com as tabelas AFR e AFN!"})
					Else
						If DbSeek(cCodFil+cCodProj+"0001"+cCodTrf)
							//RecLock("AFC",.F.) ROMAY 22-07-15
							RecLock("AF9",.F.)
							DbDelete()
							MsUnLock()
							
							nContAF9++
						Else
							Aadd(aLogErros,{"Linha: "+AllTrim(Str(nLinArq))+"| O código da Tarefa "+cCodTrf+" não existe no cadastro de Tarefas (Tabela AF9) para exclusão!"})
						EndIf
					EndIf
				EndIf
				
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciono no Array os Processados									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aArqPrc,{Rtrim(FT_FReadLn())})
			
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpa o Ambiente Liberando a Licença e Fechando as Conexões			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//RpcClearEnv()
		
		FT_FSKIP()
		
	Enddo
	
	FT_FUSE()	//Fecha o Arquivo Texto
	
	For nZ:=1 To Len(aArqPrc)
		cTexPrc += RTrim(aArqPrc[nZ][1])+Chr(13)+Chr(10) 
	Next
	
	If Len(aLogErros) > 0
		If File(cImpPrc+cArqPrc)
			FErase(cImpPrc+cArqPrc)
		EndIf
		GravaLog(aLogErros,aArchivos[nX][1])
	Else
		MemoWrite(cImpPrc+cArqPrc,cTexPrc)
		If File(cImpPrc+cArqPrc)
			If File(cImpDir+aArchivos[nX][1])
				FErase(cImpDir+aArchivos[nX][1])
			EndIf
		EndIf
		/*If CpyS2T(cImpDir+aArchivos[nX][1],"C:\")
			If CpyT2S("C:\"+aArchivos[nX][1],cImpPrc)
				FErase(cImpDir+aArchivos[nX][1])
				FErase("C:\"+aArchivos[nX][1])
			EndIf
		EndIf*/
	GravaLog(aLogErros,aArchivos[nX][1]) //Adicionado log mesmo quando não houver erros Romay 22-07-15
	EndIf
	
Next

//Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GravaLog ºAutor  ³Microsiga           º Data ³  02/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava as Informações de Log de Erros em um Arquivo Texto   º±±
±±º          ³ Conforme Especificado no Parametro MV_XLOGPMS              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMPPMS01()                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaLog(aLogErros,cNomArq)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nY		:= 0
Local cArqLog	:= DtoS(Date())+SubStr(Time(),1,2)+SubStr(Time(),4,2)+".log"
Local cEndLin	:= Chr(13)+Chr(10)
Local cLogErros	:= ""
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionado totalizadores de registros salvos por tabela  Romay 22-07-15     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aLogErros,{"Foram gravados / alterados / excluidos "+Str(nContAF8)+" registros na tabela AF8!"})			
Aadd(aLogErros,{"Foram gravados / alterados / excluidos "+Str(nContAF9)+" registros na tabela AF9!"})			
Aadd(aLogErros,{"Foram gravados / alterados / excluidos "+Str(nContAFC)+" registros na tabela AFC!"})			

cLogErros += "Nome do arquivo: "+cNomArq+cEndLin

For nY:=1 To Len(aLogErros)
	cLogErros += RTrim(aLogErros[nY][1])+cEndLin 
Next

MemoWrite(cImpLog+cArqLog,cLogErros)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldDelImp ºAutor  ³Adriano da Silva    º Data ³  05/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a Exclusão dos Cadastros Conforme Informação no     º±±
±±º          ³ Arquivo Texto                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMPPMS01()                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldDelImp(cPar01,cPar02,cPar03,cPar04)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery := ""
Local lRet	 := .F.

Default cPar01 := "" 
Default cPar02 := "" 
Default cPar03 := "" 
Default cPar04 := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query Para Verificar o Relacionamento com as Tabelas AFN e AFR      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT R_E_C_N_O_ AS RECAFR "
cQuery += " FROM " + RetSqlName("AFR") + " "
cQuery += " WHERE AFR_FILIAL = '" + cPar02 + "' "
cQuery += " AND AFR_PROJET = '" + cPar03 + "' "
cQuery += " AND AFR_REVISA = '001' "
If cPar01 == "AF9" // Tarefa
	cQuery += " AND AFR_TAREFA = '" + cPar04 + "' "
EndIf
cQuery += " AND D_E_L_E_T_ = ' ' "

If Select("TRBAFR") > 0
	DbSelectArea("TRBAFR")
	DbCloseArea()
EndIf

DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBAFR",.F.,.T.)

DbSelectArea("TRBAFR")
DbGoTop()
If !Eof()
	lRet := .T.	
EndIf

If Select("TRBAFR") > 0
	DbSelectArea("TRBAFR")
	DbCloseArea()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query Para Verificar o Relacionamento com as Tabelas AFN e AFR      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT R_E_C_N_O_ AS RECAFN "
cQuery += " FROM " + RetSqlName("AFN") + " "
cQuery += " WHERE AFN_FILIAL = '" + cPar02 + "' "
cQuery += " AND AFN_PROJET = '" + cPar03 + "' "
cQuery += " AND AFN_REVISA = '001' "
If cPar01 == "AF9" // Tarefa
	cQuery += " AND AFN_TAREFA = '" + cPar04 + "' "
EndIf
cQuery += " AND D_E_L_E_T_ = ' ' "

If Select("TRBAFN") > 0
	DbSelectArea("TRBAFN")
	DbCloseArea()
EndIf

DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBAFN",.F.,.T.)

DbSelectArea("TRBAFN")
DbGoTop()
If !Eof()
	lRet := .T.	
EndIf

If Select("TRBAFN") > 0
	DbSelectArea("TRBAFN")
	DbCloseArea()
EndIf

Return(lRet)