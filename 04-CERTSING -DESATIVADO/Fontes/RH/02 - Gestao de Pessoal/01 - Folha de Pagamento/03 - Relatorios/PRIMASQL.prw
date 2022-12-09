#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   CRLF CHR(13)+CHR(10)
Static __aComboSX3	:= {}
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PRIMASQL � Autor �     PrimaInfo      � Data �  13/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Geracao de relatorio em excel a partir de uma query        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Clientes Protheus Microsiga                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PRIMASQL()

Local oReport
Local cFile := ""

// Declaracao de Variaveis
Private cPerg    := Padr("PRIMASQL",Len(SX1->X1_GRUPO))
Private cString  := "SRA"
Private oGeraTxt
Private cQuery	

fPriPerg()

pergunte(cPerg,.T.)

FwMsgRun(,{|oSay| Print(@oSay)},"Processando","Gerando arquivo...")

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �print     �Autor  �Microsiga           � Data �  03/16/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Print()

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct	:= {}
Local _aRow		:= {}
Local _aAlias		:= {GetNextAlias()}
Local aWSheet		:= {{Alltrim(mv_par01)}}				//05

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())           

	For xz := 1 to Len(_aStruct)
		If fTipSx3(_aStruct[xz][1])
			TCSetField(_aAlias[nI],_aStruct[xz][1],"D",8,0)
		Endif
	Next xz
	
	aEval(_aStruct,{|x| oExcel:AddColumn(aWSheet[nI][1],aWSheet[nI][1],If(Empty(cTitulo:=Posicione("SX3",2,x[1],"X3_TITULO")),x[1],cTitulo),2,1)})
	//oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col1",2,1)
	(_aAlias[nI])->(DbGoTop())
	While (_aAlias[nI])->(!Eof())
		_aRow := Array(Len(_aStruct))
		nX := 0
		aEval(_aStruct,{|x| nX++,_aRow[nX] := (_aAlias[nI])->&(x[1])})
		oExcel:AddRow(aWSheet[nI][1],aWSheet[nI][1],_aRow)
		(_aAlias[nI])->(DbSkip())
	EndDo
	
Next

oExcel:Activate()

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio.",1,7),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
cFile := cFolder+".XML"

oExcel:GetXMLFile(cFile)

MsgInfo("Arquivo gerado com sucesso, sera aberto apos o fechamento dessa mensagem." + CRLF + cFile)

If ApOleClient("MsExcel")
	oExcelApp:=MsExcel():New()
	oExcelApp:WorkBooks:Open(cFile)
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo("Excel nao instaldo!"+chr(13)+chr(10)+"Relatorio gerado com sucesso, arquivo gerado no diretorio abaixo: "+chr(13)+cFile)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPRMI002  �Autor  �Microsiga           � Data �  02/15/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetTable(_cAlias,nTipo)
cQuery  := MemoRead(Alltrim(mv_par01))
cQuery 	:= MudaTab(cQuery)


//������������������������������������������������������������������������Ŀ
//� Verifica o parametro 1 estra branco                                    �
//��������������������������������������������������������������������������
If Empty(mv_par01)
	Alert("Arquivo de configuracao esta em branco. Verifique!")
	Return
Endif


//������������������������������������������������������������������������Ŀ
//� Verifica o nivel do usuario e verifica os campos com valore de salario �
//��������������������������������������������������������������������������
If !fNivSal()
	Alert("Query contem campos com valores salariais")
	Return
Endif

//������������������������������������������������������������������������Ŀ
//� Substitui variaveis data de e Ate                                      �
//��������������������������������������������������������������������������
cQuery 	:= StrTran(cQuery,"MV_PAR02",dtos(MV_PAR02))
cQuery 	:= StrTran(cQuery,"MV_PAR03",dtos(MV_PAR03))

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fPriPerg  �Autor  �Microsiga           � Data �  05/13/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fPriPerg()

Local aRegs := {}
Local a_Area := getArea()

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Arquivo     ?","Arquivo    ?","Arquivo    ?"         ,"mv_ch1","C",60,0,0,"G" ,"U_f_Arqpsql()","mv_par01","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"02","Data de     ?","Data de    ?","Data de    ?"         ,"mv_ch2","D",08,0,0,"G" ,"             ","mv_par02","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"03","Data Ate    ?","Data Ate   ?","Data Ate   ?"         ,"mv_ch3","D",08,0,0,"G" ,"             ","mv_par03","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","",""})

dbSelectArea("SX1")

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
	
Next

RestArea(a_Area)


Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FTIPSX3  � Autor �    PrimaInfo       � Data �  17/03/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Retorna o tipo e tamanho do campo no SX3                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/
Static Function fTipSx3(c_Campo)

Local a_Area 	:= GetArea()
Local a_AreaX3 	:= {}
Local l_cmpData	:= .F.

dbSelectArea("SX3")
a_AreaX3 := GetArea()
dbSetOrder(2)
If dbSeek(c_Campo)
	If SX3->X3_TIPO = "D"
		l_cmpData	:= .t.
	Endif
Endif

RestArea(a_AreaX3)
RestArea(a_Area)

Return(l_cmpData)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fArqpSQL � Autor �                    � Data �  17/03/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Abertura arquivos extensao *.sql ou *.txt                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/
User Function f_Arqpsql()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "Query PrimaInfo(*.PRI)  |*.PRI | "
Local cNewPathArq	:= cGetFile( cTipo , "Selecione o arquivo *.PRI" )									

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( "PRI" ) )	
		Aviso( "Arquivo Selecionado" , cNewPathArq , { "OK" } )								
    Else
    	MsgAlert( "Arquivo Invalido " )															
    	Return
    EndIF
Else
    Aviso("Cancelada a Selecao!" ,{ "Voce cancelou  a selecao do arquivo." } )													
    Return
EndIF
//�����������������������������������������������������������������������Ŀ
//�Limpa o parametro para a Carga do Novo Arquivo                         �
//�������������������������������������������������������������������������
dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "01" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par01 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )
Return( .T. )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MudaTab  � Autor �      Prima Info       � Data � 13.10.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Transforma as tabelas em RetSqlname                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
Static Function MudaTab(_cTexto)    

Local lTexto 		:= .t. 
Local nPosTxt 		:= 0
Local cTextoNew 	:= _cTexto
Local cTxtMemo 		:= _cTexto
Local nPipeI
Local nPipeF
 
While lTexto                                      
	cTxtMemo  := cTextoNew
	//Procura o pipe no texto
	nPipeI := At("|",cTxtMemo)
	//Se encontrar o Pipe abrindo, procura o outro fechando
	If nPipeI > 0
		nPipeF := At("|",Subs(cTxtMemo,nPipeI + 1,10)) 
		//Separa a tabela e executa o RetSQLName
		If nPipeF > 0
			cTextoNew := Substr(cTxtMemo,1,nPipeI-1)
			cTextoNew += RetSqlName( Subs(AllTrim(Substr(cTxtMemo,nPipeI+1,nPipeF) ),1,3) )
			cTextoNew += Substr(cTxtMemo,nPipeI+nPipeF+1)
		Endif
	Else
		lTexto := .F.
	Endif	
	Loop		
Enddo	

Return(cTxtMemo)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fNivSal  � Autor �      Prima Info       � Data � 13.10.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nao geraca query com salario para quem nao tem acesso      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
Static Function fNivSal()    

Local _nivsal := 5
Local _nPos	  := 0
Local l_Ret	  := .T.

//NIVEL CAMPO SALARIO NO SX3
dbSelectArea("SX3")
_aArea_ := GetArea()
dbSetOrder(2)
If dbSeek("RA_SALARIO")
	_nivsal := SX3->X3_NIVEL
Endif	
RestArea(_aArea_)

//�����������������������������������������������������������������������Ŀ
//�Compara o nivel do usuario com o nivel do campo                        �
//�������������������������������������������������������������������������
If cNivel < _nivsal
	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo salario na query se o usuario tem nivel menor         �
	//�������������������������������������������������������������������������
	_nPos := At("RA_SALARIO",cQuery)                	
	If _nPos > 0
		l_Ret := .F.
	Endif
	
	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo RA_ANTEAUM na query se o usuario tem nivel menor      �
	//�������������������������������������������������������������������������
	If l_Ret
		_nPos := At("RA_ANTEAUM",cQuery)                	
		If _nPos > 0
			l_Ret := .F.
		Endif
	Endif	

	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo rc_valor na query se o usuario tem nivel menor        �
	//�������������������������������������������������������������������������
	If l_Ret
		_nPos := At("RC_VALOR",cQuery)                	
		If _nPos > 0
			l_Ret := .F.
		Endif
	Endif	

	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo rd_valor na query se o usuario tem nivel menor        �
	//�������������������������������������������������������������������������
	If l_Ret
		_nPos := At("RD_VALOR",cQuery)                	
		If _nPos > 0
			l_Ret := .F.
		Endif
	Endif	

	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo r3_valor na query se o usuario tem nivel menor        �
	//�������������������������������������������������������������������������
	If l_Ret
		_nPos := At("R3_VALOR",cQuery)                	
		If _nPos > 0
			l_Ret := .F.
		Endif
	Endif	
	
	//�����������������������������������������������������������������������Ŀ
	//� Procura o campo R3_ANTEAUM na query se o usuario tem nivel menor      �
	//�������������������������������������������������������������������������
	If l_Ret
		_nPos := At("R3_ANTEAUM",cQuery)                	
		If _nPos > 0
			l_Ret := .F.
		Endif
	Endif	
Endif

Return(l_Ret)