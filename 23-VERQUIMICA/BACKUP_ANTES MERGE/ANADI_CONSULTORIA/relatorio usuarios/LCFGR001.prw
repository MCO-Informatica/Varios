#include 'protheus.ch'
#include 'parmtype.ch'

/*
+------------+------------+-------+------------------------------------------+------+---------------+
| Programa   | LFINR022   | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Março/2017	|
+------------+------------+-------+------------------------------------------+------+---------------+
| Descricao  | Relatório Em Excel de menus por usuário							 			    	|
+------------+--------------------------------------------------------------------------------------+
| Uso        | Luft											                               		    |
+------------+--------------------------------------------------------------------------------------+
*/

User Function LCFGR001()
Local cPerg 	:= PadR("LCFGR001", Len (SX1->X1_GRUPO))

Private _cDest
Private _aUsers	:= {}
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//          cPerg	Ordem	PergPort                   cPerSpa        cPerEng             cVar   Tipo nTam 1 2  3  4   cVar01    cDef01   cDefSpa1    cDefEng1    cCont01	      cVar02	   cDef02     cDefSpa2   cDefEng2    cCnt02  cVar03 cDef03   cDefSpa3  cDefEng3  cCnt03	cVar04    cDef04    cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	  cPyme cGrpSxg   	 aHelpPor aHelpEng	aHelpSpa  cHelp
U_AjuPerg(cPerg,"01","Usuario De" 				,'','',"mv_ch1","C",06							,0,	,"G",""	,"USR"		,"","","MV_PAR01",""		,"","","",""			,"","",""		,"","",""		,"","",""	,"","")
U_AjuPerg(cPerg,"02","Usuario Ate"				,'','',"mv_ch2","C",06							,0,	,"G",""	,"USR"		,"","","MV_PAR02",""		,"","","",""			,"","",""		,"","",""		,"","",""	,"","")
U_AjuPerg(cPerg,"03","Exibe "					,'','',"mv_ch3","N",01							,0,	,"C",""	,""			,"","","MV_PAR03","Ativos"	,"","","","Bloqueados"	,"","","Ambos"	,"","",""		,"","",""	,"","")
U_AjuPerg(cPerg,"04","Aglutina "				,'','',"mv_ch4","N",01							,0,	,"C",""	,""			,"","","MV_PAR04","Nenhum"	,"","","","Usuarios"	,"","",""		,"","",""		,"","",""	,"","")

If !Pergunte(cPerg,.T.)
	Return
EndIf

_cDest   	:= cGetFile("Arquivos xls|*.XLS","Selecione o Diretorio onde os arquivos serao salvo",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)

If Empty(_cDest)
	Return
EndIf
	
Processa({|| GetUsers()},"Carregando dados dos usuários")	

If Empty(_aUsers)
	Alert("Nenhum usuario encontrado")
	Return
EndIf

If MV_PAR04 = 1
	Processa({|| GeraPlan()},"Gerando arquivos Excel")	
Else
	Processa({|| GeraMnus()},"Gerando arquivo Excel")	
EndIf

Return

/*
+------------+------------+-------+------------------------------------------+------+---------------+
| Programa   | GetUsers   | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Março/2017	|
+------------+------------+-------+------------------------------------------+------+---------------+
| Descricao  | Função para carregar dados de usuários na variavel				 			    	|
+------------+--------------------------------------------------------------------------------------+
| Uso        | Luft											                               		    |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function GetUsers()
Local _aAux, nX

ProcRegua(0)

IncProc()
IncProc()//Adicionado segunda vez para carregar barra de progresso sem função de Loop
_aAux := AllUsers(.F.,.F.)

For nX := 1 To Len(_aAux)
	If _aAux[nX][1][1] >= MV_PAR01 .AND. _aAux[nX][1][1] <= MV_PAR02 .AND. ;
	 	( (MV_PAR03 = 1 .AND. !_aAux[nX][1][17]) .OR. ; //Ativos
	 	  (MV_PAR03 = 2 .AND. _aAux[nX][1][17]) .OR. ;	//Bloqueados
	 	  MV_PAR03 = 3 )								//Ambos
	 	
		AADD(_aUsers,{_aAux[nX][1][1],;
						_aAux[nX][1][2],;
						_aAux[nX][3]})
	EndIf
Next nX

Return

/*
+------------+------------+-------+------------------------------------------+------+---------------+
| Programa   | GeraPlan   | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Março/2017	|
+------------+------------+-------+------------------------------------------+------+---------------+
| Descricao  | Gera arquivo Excel dos usuarios selecionados						 			    	|
+------------+--------------------------------------------------------------------------------------+
| Uso        | Luft											                               		    |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function GeraPlan()
Local nX,nY,nW,nPosMod
Local _cUsr,cTabUsr,cWsMod,cDrive,cDir,cNome,cExt
Local _aMods	:= RetModName(.T.)
Local _aRet
Local _aXNU

Private oExcel 

ProcRegua(Len(_aUsers))

For nX := 1 To Len(_aUsers)
	_cUsr := _aUsers[nX][1] + ' - ' + _aUsers[nX][2]
	IncProc("Usuario:" + _cUsr)
	
	oExcel := FWMSEXCEL():New()

	For nY := 1 To Len(_aUsers[nX][3])
		_aRet := {}
		//Ignora modulos que o usuario não tem acesso
		If Substr(_aUsers[nX][3][nY],3,1) == 'X'
			Loop
		EndIf
		
		//Adiciona o nome do XNU na pasta
		SplitPath( Substr(_aUsers[nX][3][nY],4), @cDrive, @cDir, @cNome, @cExt )
		cTabUsr := _cUsr + " (" + cNome + cExt + ")"

		_nPosMod := Ascan(_aMods,{|x| x[1] = Val(Substr(_aUsers[nX][3][nY],1,2))} )
		If _nPosMod > 0
			cWsMod := Substr(_aUsers[nX][3][nY],1,2) + ' - ' + _aMods[_nPosMod][3]
		Else
			cWsMod := Substr(_aUsers[nX][3][nY],1,2)
		EndIf
		
		oExcel:AddworkSheet(cWsMod)
		oExcel:AddTable (cWsMod,cTabUsr)
		oExcel:AddColumn(cWsMod,cTabUsr,"Função"	,1,1)
		oExcel:AddColumn(cWsMod,cTabUsr,"Nivel"		,1,1)
		oExcel:AddColumn(cWsMod,cTabUsr,"Acessos"	,1,1)
		oExcel:AddColumn(cWsMod,cTabUsr,"Tipo"		,1,1)
		oExcel:AddColumn(cWsMod,cTabUsr,"Modulo"	,1,1)
		oExcel:AddColumn(cWsMod,cTabUsr,"Caminho"	,1,1)

		//Carrega o XNU em um array para analise
		_aXNU	:= XNULoad( Substr(_aUsers[nX][3][nY],4) )
		
		For nW := 1 To Len(_aXNU)
			GetMenu( _aXNU[nW][3], _aXNU[nW][1][1] , 1 , @_aRet )
		Next nW
		
		For nW := 1 To Len(_aRet)
			oExcel:AddRow(cWsMod,cTabUsr,{_aRet[nW][1],;
									 		_aRet[nW][2],;
									 		_aRet[nW][3],;
									 		_aRet[nW][4],;
									 		_aRet[nW][5],;
									 		_aRet[nW][6]})
		Next nW
	Next nY

	oExcel:Activate()
	oExcel:GetXMLFile(_cDest + "Menus_" + _aUsers[nX][1] + "_" + DTOS(Date()) + ".xls")

Next nX

Return

/*
+------------+------------+-------+------------------------------------------+------+---------------+
| Programa   | GetFuncs   | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Março/2017	|
+------------+------------+-------+------------------------------------------+------+---------------+
| Descricao  | Carrega as funções e demais dados do XML para gravação na Planilha 			    	|
+------------+--------------------------------------------------------------------------------------+
| Uso        | Luft											                               		    |
+------------+--------------------------------------------------------------------------------------+
| Parametros | _cXNU 	> Caminho do arquivo XNU que será analisado									|
| 			 | _cWsMod 	> Nome do WorkSheet atual do Excel											|
| 			 | _cTabUsr	> Nome da tabela atual do Excel												|
+------------+--------------------------------------------------------------------------------------+
*/

Static Function GetMenu( aLoad, _cPath , _nCont , aRet )
Local nX
Local _cTpFunc

_nCont := _nCont + 1

For nX:=1 To Len(aLoad)
	If ValType(aLoad[nX][3]) == "A" .AND. aLoad[nX][2] == "E"
		Getmenu( aLoad[nX][3], _cPath + " > " + aLoad[nX][1][1], _nCont, @aRet )
	Else
		If aLoad[nX][2] == "E"
			Do Case 
				Case aLoad[nX][7] = 1
					_cTpFunc := "Função Protheus"
				Case aLoad[nX][7] = 2
					_cTpFunc := "Relatorio SIGARPM"
				Case aLoad[nX][7] = 3
					_cTpFunc := "Função Usuário"
				Case aLoad[nX][7] = 4
					_cTpFunc := "Função Template"
				Case aLoad[nX][7] = 5
					_cTpFunc := "Relatório Crystal"
				Case aLoad[nX][7] = 6
					_cTpFunc := "Cons. Generica Relacional"
				Case aLoad[nX][7] = 7
					_cTpFunc := "Protheus Report"
				Case aLoad[nX][7] = 8
					_cTpFunc := "Relatório iReport"
				Case aLoad[nX][7] = 9
					_cTpFunc := "TOTVS Report"
				Otherwise
					_cTpFunc := aLoad[nX][7]
			EndCase 
			aAdd( aRet,{aLoad[nX][3],; 						//Nome Função
						_nCont,;	 						//Nível
						aLoad[nX][5],; 						//Acessos da função
						_cTpFunc,; 							//Tipo de Função
						aLoad[nX][6],;						//Modulo da funcao
						_cPath + " > " + aLoad[nX][1][1]}) 	//Caminho do fonte
		EndIf
	EndIf
Next

Return

/*
+------------+------------+-------+------------------------------------------+------+---------------+
| Programa   | GeraMnus   | Autor | Rubens Cruz - Anadi Consultoria 		 | Data | Agosto/2017	|
+------------+------------+-------+------------------------------------------+------+---------------+
| Descricao  | Gera arquivo Excel dos usuarios selecionados						 			    	|
+------------+--------------------------------------------------------------------------------------+
| Uso        | Luft											                               		    |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function GeraMnus()
Local nX,nY
Local _cUsr,cTabUsr,cDrive,cDir,cNome,cExt
Local _aRet, _aXNU
Local _aMods	:= RetModName(.T.)
Local cWsMod 	:= "Menu Usuarios"
Local cTabUsr 	:= "Menu Usuarios"

Private oExcel := FWMSEXCEL():New()

ProcRegua(Len(_aUsers))

oExcel:AddworkSheet(cWsMod)
oExcel:AddTable (cWsMod,cTabUsr)
oExcel:AddColumn(cWsMod,cTabUsr,"Cod User"	,1,1)
oExcel:AddColumn(cWsMod,cTabUsr,"Nm User"	,1,1)
oExcel:AddColumn(cWsMod,cTabUsr,"Menu"		,1,1)

For nX := 1 To Len(_aUsers)
	_cUsr := _aUsers[nX][1] + ' - ' + _aUsers[nX][2]
	IncProc("Usuario:" + _cUsr)
	
	For nY := 1 To Len(_aUsers[nX][3])
		_aRet := {}
		//Ignora modulos que o usuario não tem acesso
		If Substr(_aUsers[nX][3][nY],3,1) == 'X'
			Loop
		EndIf
		
		//Adiciona o nome do XNU na pasta
		SplitPath( Substr(_aUsers[nX][3][nY],4), @cDrive, @cDir, @cNome, @cExt )
//		cTabUsr := _cUsr + " (" + cNome + cExt + ")"

		oExcel:AddRow(cWsMod,cTabUsr,{_aUsers[nX][1],;
								 	  _aUsers[nX][2],;
								 	  Substr(_aUsers[nX][3][nY],4)})
	Next nY
Next nX

oExcel:Activate()
oExcel:GetXMLFile(_cDest + "Menus_" + DTOS(Date()) + ".xls")

Return
