#INCLUDE "PROTHEUS.CH"
//#INCLUDE "INKEY.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE "TECA500.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �TECA500   � Autor � Eduardo Riera         � Data � 20.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao da Agenda dos Tecnicos                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSFS0003()
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
PRIVATE aRotina := { { "Pesquisar"	,"AxPesqui"  , 0 , 1},;	//"Pesquisar"
                     { "Visualizar"	,"AxVisual"  , 0 , 2},;	//"Visualizar"
                     { "Agenda"		,'ExecBlock("CSF03AGE",.T.,.T.)' , 0 , 4},;	//"Agenda"
                     { "Gantt"		,'ExecBlock("CSF03Par",.T.,.T.)', 0 , 4}}//"Gantt"                     
//                     ,;	
//					 { "Schedule"	,"At500Aloc" , 0 , 4}}	//"Schedule"


//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := OemtoAnsi("Agenda dos T�cnicos")	//"Agenda dos T�cnicos"
//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
If ( AMIIn(28) )
	mBrowse( 6, 1,22,75,"AA1")
EndIf
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AT500AGE  � Autor �Eduardo Riera          � Data � 20.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Agenda dos Tecnicos                                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 : Alias                                              ���
���          � ExpN1 : Numero do Registro                                 ���
���          � ExpN2 : Opcao Selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSF03AGE(cAlias,nReg,nOpcx)         

Local aSize     := {}
Local aObjects  := {} 
Local aObjects2 := {}
Local aInfo     := {} 
Local aDiasAloc := {} 

Local oDlg
Local oBar
Local oBrowse
Local oColuna1
Local oColuna2
Local oCalend
Local oFont
Local oMenu 

Local aGet 		:= {{ 0 , 0 },{ 0 , 0 },{0 ,0 }}
Local aButtons := {}
Local aAgenda  := {}
Local oPanel
Local nForeCor := 0
Local nBackCor := 0
Local nCol     := 0 
Local nLin     := 0 
Local oColuna

PRIVATE aRotina := { { "Pesquisar"	,"AxPesqui"  , 0 , 1},;	//"Pesquisar"
                     { "Visualizar"	,"AxVisual"  , 0 , 2},;	//"Visualizar"
                     { "Agenda"		,'ExecBlock("CSF03AGE",.T.,.T.)' , 0 , 4},;	//"Agenda"
                     { "Gantt"		,'ExecBlock("CSF03Par",.T.,.T.)', 0 , 4}}//"Gantt" 

PRIVATE cCadastro := OemtoAnsi("Agenda dos T�cnicos")	//"Agenda dos T�cnicos"

oFont:=TFont():New("Courier New",10,0)  

//���������������������������������������������������������������������Ŀ
//� Divide a tela lateralmente e resolve as dimensoes de cada parte     �
//�����������������������������������������������������������������������

aSize    := MsAdvSize( .F. ) 

aObjects := {}           

AAdd( aObjects, { 100, 100, .t., .t., .t. } )
AAdd( aObjects, { 140,  66, .F., .T. } )

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj1 := MsObjSize( aInfo, aObjects,  , .T. ) 

//���������������������������������������������������������������������Ŀ
//� Resolve as dimensoes dos objetos da parte direita da tela           �
//�����������������������������������������������������������������������
aObjects := {} 
AAdd( aObjects, { 140,  66, .T., .F. } ) 
AAdd( aObjects, { 100, 100, .T., .T. } )

aSize2 := aClone( aPosObj1[2] )

aInfo    := { aSize2[ 2 ], aSize2[ 1 ], aSize2[ 4 ], aSize2[ 3 ], 3, 3, 0, 0 } 
aPosObj2 := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE "Agenda do Tecnico: " + Capital( AA1->AA1_NOMTEC ) FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL //"Agenda do Tecnico: "

nLin := aPosObj2[2,1]
nCol := aPosObj2[2,2]

@ nLin,nCol TO aPosObj2[2,3],aPosObj2[2,4] PIXEL

@ nLin +  8,nCol + 09 SAY "Horas Alocadas no Mes" SIZE 075,008 OF oDlg PIXEL //"Horas Alocadas no Mes"
@ nLin + 18,nCol + 09 SAY "Dias  Alocados no Mes" SIZE 075,008 OF oDlg PIXEL //"Dias  Alocados no Mes" //"Numero de alocacoes / Mes"
@ nLin + 28,nCol + 09 SAY "Datas alocadas / Mes"  SIZE 075,008 OF oDlg PIXEL  //"Datas alocadas / Mes"

@ nLin +  8,nCol + 84 MSGET aGet[1][1] VAR aGet[1][2] SIZE 050,008 OF oDlg PIXEL WHEN .F.
@ nLin + 18,nCol + 84 MSGET aGet[2][1] VAR aGet[2][2] SIZE 050,008 OF oDlg PIXEL WHEN .F. PICTURE "999999"
@ nLin + 28,nCol + 84 MSGET aGet[3][1] VAR aGet[3][2] SIZE 050,008 OF oDlg PIXEL WHEN .F. PICTURE "999999"

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+5   TYPE 11 	ACTION Eval(oCalend:bLDblClick) ENABLE OF oDlg 

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+40  TYPE 15 	ACTION ( CSF03VIS( @oBrowse ) ) ENABLE OF oDlg ONSTOP OemToAnsi( "Ordem de Servico" ) // "Ordem de Servico"

DEFINE SBUTTON FROM aPosObj2[2,3]-18,nCol+107 TYPE 1 	ACTION oDlg:End() ENABLE OF oDlg  

@ aPosObj1[1,1],aPosObj1[1,2] MSPANEL oPanel  PROMPT "" SIZE aPosObj1[1,3],11 OF oDlg CENTERED LOWERED
oBrowse := TSBrowse():New(aPosObj1[1,1] + 11,aPosObj1[1,2],aPosObj1[1,3],aPosObj1[1,4]-11,oDlg,,35,oFont,5 )

oBrowse:SetArray(aAgenda)

nForeCor := CLR_BLACK
nBackCor := CLR_HGRAY


oColuna:= TcColumn():New(OemToAnsi(""),,,{|| nForeCor },{|| nBackCor })
oColuna:lNoLite := .F.
oColuna:nWidth := 16
oBrowse:AddColumn(oColuna)
oBrowse:lJustific := .F.

oColuna1 := TcColumn():New(OemToAnsi(""),,,{|| nForeCor },{|| nBackCor })
oColuna1:lNoLite := .T.
oColuna1:nWidth := 60
oBrowse:AddColumn(oColuna1)
oBrowse:lJustific := .F.

oColuna2 := TcColumn():New(OemToAnsi("Informa��es"),,,{|| CLR_BLUE },{|| CLR_WHITE})	//"Informa��es"
oColuna2:lNoLite := .T.
oColuna2:nWidth := 120
oBrowse:AddColumn(oColuna2)

oCalend:=MsCalend():New( aPosObj2[1,1],aPosObj2[1,2],oDlg)
oCalend:bChange := {|| CSF05CHD(@oBrowse,@oCalend,@oPanel,aDiasAloc) }

oCalend:bChangeMes := {|| CSF03CHM(@oCalend,aGet,@aDiasAloc) }

oCalend:bLDblClick := {|| CSF03ALT(oCalend:dDiaAtu,@aDiasAloc),;
					CSF03CHM(@oCalend,@aGet,@aDiasAloc),CSF05CHD(@oBrowse,@oCalend,@oPanel,aDiasAloc),;
					oDlg:Refresh() }             
										
oBrowse:bLdblClick := oCalend:bLDblClick

MENU oMenu POPUP                                                  
	MENUITEM "Alocacao"  		   	Action Eval( oCalend:bLdblClick )       //"Alocacao"
	MENUITEM "Ordem de Servico"    	Action CSF03VIS( @oBrowse )            //"Ordem de Servico"
	MENUITEM "Posiciona no inicio" 	Action CSD03GOT(oCalend,aDiasAloc,1)   //"Posiciona no inicio"
	MENUITEM "Posiciona no final"  	Action CSD03GOT(oCalend,aDiasAloc,2)   //"Posiciona no final"
	MENUITEM "Hoje"				   	Action ( oCalend:dDiaAtu := dDataBase, Eval( oCalend:bChange ) ) // "Hoje"
ENDMENU

oCalend:bRClicked  := { |oObject,nx,ny| oMenu:Activate( nX, nY, oObject ) }
										
ACTIVATE DIALOG oDlg ON INIT (CSF03CHM(@oCalend,@aGet,@aDiasAloc),CSF05CHD(@oBrowse,@oCalend,@oPanel,aDiasAloc))

Return(.T.)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500Alter� Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro da Agenda dos Tecnicos                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpD1 : Data de Inicio da Alocacao.                        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CSF03ALT(dDataIni,aDiasAloc)

Local lGravou		:= .F.
Local nCntFor		:= 0
Local nUsado		:= 0
Local nOpcA			:= 0
Local nLoop       	:= 0  
Local nScan       	:= 0 
Local oDlg,oGetD
Local aTravas		:= {}
Local aDia        	:= {} 
Local lTravas		:= .T.
Local nOpcx         := 2 

PRIVATE aCols		:= {}
PRIVATE aHeader		:= {}
PRIVATE aRegistros	:= {}
Private dData 		:= dDataIni //Utilizado no inicializador padrao.

//������������������������������������������������������������������������Ŀ
//� Verifica, baseado no tipo de tecnico e disponibilidade, se permite     � 
//� a alteracao                                                            �
//��������������������������������������������������������������������������
nOpcx := If( AA1->AA1_TIPO $ "13" .And. AA1->AA1_ALOCA == "1", 3, 2 ) 

If nOpcx == 2 
	Help( " ", 1, "AT500VISU" ) // 	Nao e permitida a alteracao deste tecnico 
EndIf 

//������������������������������������������������������������������������Ŀ
//�Montagem do aHeader                                                     �
//��������������������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("PA2")
While ( !Eof() .And. SX3->X3_ARQUIVO=="PA2" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
			!AllTrim(SX3->X3_CAMPO)$"PA2_CODTEC" .And.;
			!AllTrim(SX3->X3_CAMPO)$"PA2_NOMTEC")
		nUsado++
		aadd(aHeader,{ AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_ARQUIVO,;
							SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
Enddo
//������������������������������������������������������������������������Ŀ
//�Montagem do aCols                                                       �
//��������������������������������������������������������������������������

nDia := Day( dDataIni )

If !Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nDia } ) )   

	aDia := aDiasAloc[ nScan, 2 ]

	//������������������������������������������������������������������������Ŀ
	//� Ordena as alocacoes do dia por horario de chegada                      �
	//��������������������������������������������������������������������������
	ASort( aDia, , , { |x,y| y[2] > x[2] } ) 
	
	For nLoop := 1 to Len( aDia ) 
	
		PA2->( MsGoto( aDia[ nLoop, 1 ] ) )  
		
		If ( SoftLock("PA2" ) )
			aadd(aRegistros,RecNo())
			aadd(aTravas,{ Alias() , RecNo() })
			aadd(aCols,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				If ( aHeader[nCntFor][10] != "V" )
					aCols[Len(aCols)][nCntFor] := PA2->(FieldGet(FieldPos(aHeader[nCntFor][2])))
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
				EndIf
			Next
			aCols[Len(aCols)][nUsado+1] := .F.
		Else
			lTravas := .F.
		EndIf
	Next nLoop
	   
EndIf 

If ( Len(aCols) == 0 )
	aadd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Next nCntFor
	aCols[1][nUsado+1] := .F.
EndIf
If ( lTravas )
	DEFINE MSDIALOG oDlg TITLE "Agenda do Tecnico: " FROM 9,0 TO 28,80 OF oMainWnd
	@ 015,010 SAY   RetTitle("AA1_CODTEC") 	SIZE 040,009 	OF oDlg PIXEL
	@ 015,050 MSGET AA1->AA1_NOMTEC				SIZE 136,009 	OF oDlg PIXEL WHEN .F.
	oGetd:=MsGetDados():New(030,005,138,314,nOpcx,'ExecBlock("CSF03LIO",.T.,.T.)','ExecBlock("CSF03TUO",.T.,.T.)',"",.T.)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})
	If ( nOpcA == 1 )
		Begin Transaction
			lGravou := CSF03GRV()
			If ( lGravou )
				EvalTrigger()
				While ( __lSx8 )
					ConfirmSx8()
				EndDo
			EndIf
		End Transaction
	EndIf
EndIf
While ( __lSx8 )
	RollBackSx8()
EndDo
For nCntFor := 1 To Len(aTravas)
	dbSelectArea(aTravas[nCntFor][1])
	dbGoto(aTravas[nCntFor][2])
	MsUnLock()
Next nCntFor
Return(lGravou)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AT500Grava� Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a Gravacao da Agenda do Tecnico                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 : Indica se efetuou a Gravacao                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CSF03GRV()

Local nCntFor := 0
Local nCntFor2:= 0
Local nUsado  := Len(aHeader)
Local lGravou := .F.
Local dDataIni:= Ctod("")
Local dDataFim:= Ctod("")
Local cHoraIni:= ""
Local cHoraFim:= ""                            
Local cCrLf   := Chr(13) + Chr(10) 
Local cCorpo  := "" 
Local nPosDIni:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_DTINI"})
Local nPosDFim:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_DTFIM"})
Local nPosHIni:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_HRINI"})
Local nPosHFim:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_HRFIM"}) 
Local lAT500Alt:= ExistBlock("AT500ALT")
Local lAT500Grv:= ExistBlock("AT500GRV")
Local lAT500Del:= ExistBlock("AT500DEL")


For nCntFor := 1 To Len(aCols)
	dDataIni := aCols[nCntFor][nPosDIni]
	dDataFim := aCols[nCntFor][nPosDFim]
	cHoraIni := aCols[nCntFor][nPosHIni]
	cHoraFim := aCols[nCntFor][nPosHFim]
	dbSelectArea("PA2")
	dbSetOrder(1)
	If ( nCntFor > Len(aRegistros) )
		If ( !aCols[nCntFor][nUsado+1] )
			RecLock("PA2",.T.) 
		EndIf
	Else
		dbGoto(aRegistros[nCntFor])
		RecLock("PA2")
	EndIf
	
	// "Cliente: ", "Endereco: ", "Municipio: ", "UF: ", "Telefone: " 

	cCorpo  := RetTitle( "A1_COD" )+ ":" + SA1->A1_COD+" - " + SA1->A1_NOME + cCrLf +;
		RetTitle( "A1_END" )+":"+SA1->A1_END + cCrLf + RetTitle( "A1_MUN" )+":"+SA1->A1_MUN + ;
		cCrLf + RetTitle( "A1_EST" )+":" + SA1->A1_EST + cCrLf + RetTitle( "A1_TEL" )+":" + SA1->A1_TEL 
	
	If ( !aCols[nCntFor][nUsado+1] .And. !Empty(cHoraIni) )
	
		PA0->( dbSetOrder( 1 ) ) 		
		PA0->( MsSeek( xFilial( "PA0" ) + GDFieldGet( "PA2_NUMOS", nCntFor ) ) ) 
		
		SA1->( dbSetOrder( 1 ) ) 
		SA1->( MsSeek( xFilial( "SA1" ) + PA0->PA0_CLILOC + PA0->PA0_LOJLOC ) ) 		
			
		//������������������������������������������������������������������������Ŀ
		//� Envia o e-Mail caso um campo importante tenha sido alterado            �
		//��������������������������������������������������������������������������
		If PA2->PA2_DTINI <> dDataIni .Or. PA2->PA2_HRINI <> cHoraIni .Or. ;
				PA2->PA2_DTFIM <> dDataFim .Or. PA2->PA2_HRFIM <> cHoraFim .Or. ;
				PA2->PA2_NUMOS <> GDFieldGet( "PA2_NUMOS" ) 		      
				
			If lAT500Alt
				ExecBlock( "AT500ALT", .F., .F.) 
			EndIf
			
			MEnviaMail( "009", { 1, AA1->AA1_CODTEC + " - " + AllTrim( AA1->AA1_NOMTEC ),;
				GDFieldGet( "PA2_NUMOS", nCntFor ), SA1->A1_COD, DToC(dDataIni),;
				cHoraIni, DToC( dDataFim ), cHoraFim, cCorpo }, , , AllTrim( AA1->AA1_EMAIL ) ) 
				
		EndIf                
	
		For nCntFor2 := 1 To nUsado
			PA2->(FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2]))
		Next nCntFor2
		PA2->PA2_FILIAL 	:= xFilial("PA2")
		PA2->PA2_CODTEC 	:= AA1->AA1_CODTEC
		lGravou := .T.          
		
		If lAT500Grv
			ExecBlock( "AT500GRV", .F., .F.) 
		EndIf
	Else
		If ( nCntFor <= Len(aRegistros) )
			If lAT500Del
				ExecBlock( "AT500DEL", .F., .F.) 
			EndIf
			MEnviaMail( "009", { 2, AA1->AA1_CODTEC + " - " + AA1->AA1_NOMTEC,;
				PA2->PA2_NUMOS, SA1->A1_COD, DToC(dDataIni),;
				cHoraIni, DToC( dDataFim ), cHoraFim, cCorpo }, , , AllTrim( AA1->AA1_EMAIL ) ) 
			dbDelete()
		EndIf
	EndIf
Next nCntFor
Return(lGravou)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500LinOk� Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tratamento da Linha Ok da GetDados                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1: Indica se a Linha e valida                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSF03LIO()

Local lRetorno := .T.
Local nPosDtIni:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_DTINI"})
Local nPosDtFim:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_DTFIM"})
Local nPosHrIni:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_HRINI"})
Local nPosHrFim:= aScan(aHeader,{|x| AllTrim(x[2])=="PA2_HRFIM"})
Local nUsado   := Len(aHeader)
Local nCntFor  := 0

If ( !aCols[n][nUsado+1] )
	If ( 	!Empty(aCols[n][nPosDtIni]) .And.;
			!Empty(aCols[n][nPosDtFim]) .And.;
			!Empty(aCols[n][nPosHrIni]) .And.;
			!Empty(aCols[n][nPosHrFim]) )
		If ( Empty(AtTotHora(aCols[n][nPosDtIni],aCols[n][nPosHrIni],aCols[n][nPosDtFim],aCols[n][nPosHrFim])) )
			Help(" ",1,"AT500DATA3")
			lRetorno := .F.
		EndIf
	Else
		Help(" ",1,"AT500DATA3")
		lRetorno := .F.
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Verifica se o horario nao esta alocado na Base                          �
	//��������������������������������������������������������������������������
	dbSelectArea("PA2")
	dbSetOrder(2)
	dbSeek(xFilial("PA2")+AA1->AA1_CODTEC+DTOS(aCols[n][nPosDtFim])+aCols[n][nPosHrFim],.T.)
	If ( 	PA2->PA2_CODTEC == AA1->AA1_CODTEC .And. ;
			(	aCols[n][nPosDtFim] <= PA2->PA2_DTFIM .And.;
				aCols[n][nPosHrFim] <= PA2->PA2_HRFIM .And.;
				aCols[n][nPosDtFim] >= PA2->PA2_DTINI .And.;
				aCols[n][nPosHrFim] >= PA2->PA2_HRINI ) .Or.;
			(	aCols[n][nPosDtIni] <= PA2->PA2_DTFIM .And.;
				aCols[n][nPosHrIni] <= PA2->PA2_HRFIM .And.;
				aCols[n][nPosDtIni] >= PA2->PA2_DTINI .And.;
				aCols[n][nPosHrIni] >= PA2->PA2_HRINI ))
	    If ( aScan(aRegistros,PA2->(RecNo()))==0 )
			Help(" ",1,"AT500LIN01")
			lRetorno := .F.
        EndIf
	EndIf
	//������������������������������������������������������������������������Ŀ
	//�Verifica se o horario nao esta alocado no Acols                         �
	//��������������������������������������������������������������������������
	For nCntFor := 1 To Len(aCols)
		If ( !aCols[nCntFor][nUsado+1] )
			If (( aCols[n][nPosDtFim] <= aCols[nCntFor][nPosDtFim] .And.;
					aCols[n][nPosHrFim] <= aCols[nCntFor][nPosHrFim] .And.;
					aCols[n][nPosDtFim] >= aCols[nCntFor][nPosDtIni] .And.;
					aCols[n][nPosHrFim] >= aCols[nCntFor][nPosHrIni] ) .Or.;
				 (	aCols[n][nPosDtIni] <= aCols[nCntFor][nPosDtFim] .And.;
					aCols[n][nPosHrIni] <= aCols[nCntFor][nPosHrFim] .And.;
					aCols[n][nPosDtIni] >= aCols[nCntFor][nPosDtIni] .And.;
					aCols[n][nPosHrIni] >= aCols[nCntFor][nPosHrIni]))
            If ( nCntFor != n )
					Help(" ",1,"AT500LIN02")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	Next nCntFor
EndIf
Return(lRetorno)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500TudOk� Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tratamento da TudoOk   da GetDados                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1: Indica se TudoOk e valida                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSF03TUO()

Local lRetorno := .T.

Return(lRetorno)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500Data � Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a Data Inicial e Final do Agendamento               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpL1 : Indica se a data e Valida                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSF03Data()

Local cReadVar := AllTrim( ReadVar() ) 

Local lRetorno := .T.

Local dDtIni := GDFieldGet( "PA2_DTINI" )
Local dDtFim := GDFieldGet( "PA2_DTFIM" )
Local cHrIni := GDFieldGet( "PA2_HRINI" )
Local cHrFim := GDFieldGet( "PA2_HRFIM" )

Do Case 
	Case "PA2_DTINI" $ cReadVar
	dDtIni := M->PA2_DTINI                               
Case "PA2_DTFIM" $ cReadVar
	dDtFim := M->PA2_DTFIM
Case "PA2_HRINI" $ cReadVar
	cHrIni := M->PA2_HRINI
Case "PA2_HRFIM" $ cReadVar 
	cHrFim := M->PA2_HRFIM
EndCase

lRetorno := AtVldDiaHr( dDtIni, dDtFim, cHrIni, cHrFim )                            

If !lRetorno 
	Do Case
		Case ( "PA2_DTINI"$cReadVar )
			Help(" ",1,"AT500DATA1")
		Case ( "PA2_DTFIM"$cReadVar )
			Help(" ",1,"AT500DATA2")
	EndCase  
EndIf 	
	
Return(lRetorno)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500ChgDi� Autor � Eduardo Riera         � Data � 27.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o browse quando o dia eh alterado.                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: Objeto do Browse                                    ���
���          � ExpO2: Objeto do Calendario                                ���
���          � ExpO3: Objeto                                              ���
���          � ExpA1: Array de dias alocados                              ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���15/12/1999� Sergio Silv.  �Alteracao para visualizacao da OS.          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CSF05CHD(oBrowse,oCalend,oPanel,aDiasAloc)

Local aAgenda := {}
Local aHorario:= {}
Local aDia    := {} 
Local dData   := oCalend:dDiaAtu
Local aInfo1  := {}
Local aInfo2  := {}
Local cString1:= ""
Local cString2:= ""
Local cString := ""
Local nAux    := 0  
Local nLoop   := 0 
Local nScan   := 0 
Local nDia    := 0 
Local aCargo  := {}                              

// Ordena por Horario 

nDia := Day( dData )               

If !Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nDia } ) )   

	aDia := aDiasAloc[ nScan, 2 ]

	//������������������������������������������������������������������������Ŀ
	//� Ordena as alocacoes do dia por horario de chegada                      �
	//��������������������������������������������������������������������������
	ASort( aDia, , , { |x,y| y[2] > x[2] } ) 
	
	For nLoop := 1 to Len( aDia ) 
	
		PA2->( dbGoto( aDia[ nLoop, 1 ] ) )  
	
		//������������������������������������������������������������������������Ŀ
		//�Posiciona Registros                                                     �
		//��������������������������������������������������������������������������
		dbSelectArea("PA0")
		dbSetOrder(1)
		dbSeek(xFilial("PA0")+PA2->PA2_NUMOS)
	
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+PA0->PA0_CLILOC+PA0->PA0_LOJLOC)
	
		//������������������������������������������������������������������������Ŀ
		//�Recupera as informacoes a serem apresentadas na agenda                  �
		//��������������������������������������������������������������������������
		aInfo1 := {}
		aInfo2 := {}
		cString1 := &(GetMV("MV_AGEINF1"))
		If ( Empty(cString1) )
			aadd(aInfo1,RetTitle("PA0_OS"))
			aadd(aInfo1,RetTitle("PA0_CLILOC"))
			aadd(aInfo1,RetTitle("PA0_CLLCNO"))
			aadd(aInfo1,RetTitle("PA0_TEL"))
			aadd(aInfo1,RetTitle("PA0_END"))
			aadd(aInfo1,RetTitle("PA0_CIDADE"))
			aadd(aInfo1,RetTitle("PA0_ESTADO"))
//	  		aadd(aInfo1,RetTitle("AB6_ATEND"))
//			aadd(aInfo1,RetTitle("PA2_OBSERV"))
	   Else
		//������������������������������������������������������������������������Ŀ
		//�Monta a agenda baseada no parametro os dados devem ser separados por ","�
		//��������������������������������������������������������������������������
			While Len(cString1)!=0
				nAux := If(At(",",cString1)==0,Len(cString1),At(",",cString1))
				aadd(aInfo1,SubStr(cString1,1,nAux-1))
				cString1 := SubStr(cString1,nAux+1)
			EndDo
	   EndIf
		cString2 := &(GetMV("MV_AGEINF2"))
		
		If ( Empty(cString2) )
			aadd(aInfo2,PA0->PA0_OS)
			aadd(aInfo2,PA0->PA0_CLILOC+"/"+PA0->PA0_LOJLOC)
			aadd(aInfo2,PA0->PA0_CLLCNO)
			aadd(aInfo2,PA0->PA0_TEL)
			aadd(aInfo2,PA0->PA0_END)
			aadd(aInfo2,PA0->PA0_CIDADE)
			aadd(aInfo2,PA0->PA0_ESTADO)
//			aadd(aInfo2,AB6->AB6_ATEND)
//			aadd(aInfo2,PA2->PA2_OBSERV) 
		    
			aadd( aCargo, PA0->PA0_OS ) 
				
	   Else
			While Len(cString2)!=0
				nAux := If(At(",",cString2)==0,Len(cString2),At(",",cString2))
				aadd(aInfo2,SubStr(cString2,1,nAux-1))
				cString2 := SubStr(cString2,nAux+1)
			EndDo
		EndIf
		cString  := If( PA2->PA2_DTINI == dData, PA2->PA2_HRINI, "..." ) + " / "
		cString1 := ""
		cString2	:= ""
		aEval(aInfo1,{|x| cString1 += AllTrim(x)+CRLF})
		aEval(aInfo2,{|x| cString2 += AllTrim(x)+CRLF})
		
		// Esperando correcao da tecnologia...
		// aEval(aInfo1,{|x| cString  += "-" + CRLF})//,,Min(Len(aInfo1),Len(aInfo2)))
		// cString  := SubStr(cString,1,Len(cString)-2)           
		
		cString  += If(PA2->PA2_DTFIM == dData, PA2->PA2_HRFIM, "..." )
		
		cString1 := SubStr(cString1,1,Len(cString1)-2)
		cString2 := SubStr(cString2,1,Len(cString2)-2)
		
		AAdd(aAgenda, { cString , cString1 , cString2 })
	
	Next nLoop 

EndIf 

oBrowse:Cargo := AClone( aCargo )   
oBrowse:SetArray(aAgenda)
oBrowse:Refresh()

oPanel:SetText(DiaExtenso(oCalend:dDiaAtu)+" - "+Dtoc(oCalend:dDiaAtu))
oBrowse:nLinhas   := Max(Min(Len(aInfo1),Len(aInfo2))-1,1)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500ChgMe� Autor � Eduardo Riera         � Data � 28.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o array com os dias alocados.                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � At500ChgMes( ExpO1, ExpA1, @ExpA2 )                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1: Objeto do Calendario                                ���
���          � ExpA1: Array com os Gets                                   ���
���          � ExpA2: Array com os dias alocados no mes:                  ���
���          �         1 - Dia alocado                                    ���
���          �         2 - Recno do ABB                                   ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CSF03CHM(oCalend,aGet,aDiasAloc)

Local bWhile     := { || .T. } 
                                 
Local cQuery     := ""
Local cAliasPA2  := ""           
Local cIndTrab   := ""
Local cHoraIni   := ""
Local cHrCalcIni := ""
Local cHrCalcFim := ""

Local dData		  := Ctod("")
Local dRestri    := Ctod("") 
Local dDataIni   := FirstDay(oCalend:dDiaAtu)
Local dDataFim   := LastDay(oCalend:dDiaAtu)
Local dCalcIni   := Ctod("")
Local dCalcFim   := Ctod("")

Local nRecnoPA2  := 0 
Local nDiasAloc  := 0
Local nHoraAloc  := 0 
Local nDias      := 0
Local nHoras     := 0
Local nLoop      := 0 
Local nDiaIni    := 0 
Local nDiaFim    := 0 
Local nindex     := 0            
Local nScan      := 0 

oCalend:Hide()               

oCalend:DelAllRestri()    

aDiasAloc := {}

//�������������������������������������������������Ŀ
//� Analiza os dias alocados para troca de cor      �
//���������������������������������������������������
dData := dDataIni
While ( (dData)<=dDataFim )
	dData    ++
	dRestri  := dData
   dData		:= DataValida(dData,.T.)
   While ( Dow(dRestri)==1 .Or. Dow(dRestri)==7 )
		dRestri++                             
	EndDo
	If ( dData != dRestri )
		oCalend:addRestri(Day(dRestri),CLR_HRED,CLR_WHITE)
	EndIf
	dData := dRestri
EndDo
                   
dData := CToD( "" ) 

#IFDEF TOP 
             
	cAliasPA2 := "AT500CHGMES" 
	
	cQuery := ""
	
	cQuery += "SELECT PA2.*,R_E_C_N_O_ PA2RECNO FROM " + RetSqlName( "PA2" ) + " PA2 "
	cQuery += "WHERE "
	cQuery += "PA2_FILIAL='" + xFilial( "PA2" ) + "' AND "
	cQuery += "PA2_CODTEC='" + AA1->AA1_CODTEC  + "' AND "
	cQuery += "( ( PA2_DTINI>='" + DToS( dDataIni ) + "' AND "
	cQuery += "PA2_DTINI<='" + DToS( dDataFim ) + "' ) OR ( "
	cQuery += "PA2_DTFIM>='" + DToS( dDataIni ) + "' AND " 
	cQuery += "PA2_DTFIM<='" + DToS( dDataFim ) + "' ) OR ( "	
	cQuery += "PA2_DTINI<'"  + DToS( dDataIni ) + "' AND " 
	cQuery += "PA2_DTFIM>'"  + DToS( dDataFim ) + "' ) ) AND "
	cQuery += "D_E_L_E_T_=' '"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasPA2, .F., .T. ) 
	
	TcSetField( cAliasPA2, "PA2_DTINI", "D", 8, 0 ) 
	TcSetField( cAliasPA2, "PA2_DTFIM", "D", 8, 0 ) 
	
	bWhile := { || !( cAliasPA2 )->( Eof() ) } 	

#ELSE 

	cAliasPA2 := "PA2"
	                   
	dbSelectArea("PA2")
	dbSetOrder(1)

	cQuery := ""
	cQuery += "PA2_FILIAL=='" + xFilial( "PA2" ) + "'.AND."
	cQuery += "PA2_CODTEC=='" + AA1->AA1_CODTEC  + "'.AND."
	cQuery += "((DTOS(PA2_DTINI)>='" + DToS( dDataIni ) + "'.AND."
	cQuery += "DTOS(PA2_DTINI)<='" + DToS( dDataFim ) + "').OR.("
	cQuery += "DTOS(PA2_DTFIM)>='" + DToS( dDataIni ) + "'.AND." 
	cQuery += "DTOS(PA2_DTFIM)<='" + DToS( dDataFim ) + "').OR.("	
	cQuery += "DTOS(PA2_DTINI)<'"  + DToS( dDataIni ) + "'.AND." 
	cQuery += "DTOS(PA2_DTFIM)>'"  + DToS( dDataFim ) + "'))" 
	                
	cIndTrab := CriaTrab( , .F. ) 	                
	                 
	IndRegua('PA2', cIndTrab,PA2->( IndexKey() ),,cQuery )   
	
	nIndex := RetIndex("PA2")

	PA2->( dbSetIndex(cIndTrab+OrdBagExt()) ) 

	PA2->( dbSetOrder(nIndex+1) ) 
	PA2->( dbGotop() ) 
	
	bWhile := { || !PA2->( Eof() ) } 

#ENDIF 

While Eval( bWhile ) 

	#IFDEF TOP
		nRecnoPA2 := ( cAliasPA2 )->PA2RECNO		 	 
	#ELSE
		nRecnoPA2 := PA2->( Recno() ) 
	#ENDIF		
							
	If ( ( dDataIni <= ( cAliasPA2 )->PA2_DTINI  .And.;
			 dDataFim >= ( cAliasPA2 )->PA2_DTINI ) .Or.;
		 	( ( cAliasPA2 )->PA2_DTFIM >= dDataIni .And. ; 
		 	 ( cAliasPA2 )->PA2_DTFIM <= dDataFim ) )    
	   		
  		//�������������������������������������������������������������������������Ŀ
		//� Verifica se o inicio do agendamento ocorreu neste mes                   �
		//���������������������������������������������������������������������������
		If Left( DToS( ( cAliasPA2 )->PA2_DTINI ), 6 ) == Left( DToS( dDataIni ), 6 )
			nDiaIni    := Day( ( cAliasPA2 )->PA2_DTINI )
			cHrCalcIni := ( cAliasPA2 )->PA2_HRINI       
			dCalcIni   := ( cAliasPA2 )->PA2_DTINI
		Else
			nDiaIni    := Day( dDataIni )             
			cHrCalcIni := "00:00"                
			dCalcIni   := dDataIni 
		EndIf          

  		//�������������������������������������������������������������������������Ŀ
		//� Verifica se o final do agendamento ocorreu neste mes                    �
		//���������������������������������������������������������������������������
		If Left( DToS( ( cAliasPA2 )->PA2_DTFIM ), 6 ) == Left( DToS( dDataFim ), 6 )
			nDiaFim    := Day( ( cAliasPA2 )->PA2_DTFIM )
			cHrCalcFim := ( cAliasPA2 )->PA2_HRFIM 
			dCalcFim   := ( cAliasPA2 )->PA2_DTFIM
		Else
			nDiaFim    := Day( dDataFim )            
			cHrCalcFim := "23:59"                 
			dCalcFim   := dDataFim
		EndIf          
		
  		//��������������������������������������������������Ŀ
		//� Coloca restricoes em todos os dias do intervalo  �
		//����������������������������������������������������
		For nLoop := nDiaIni To nDiaFim
		
			oCalend:addRestri( nLoop,CLR_BLUE,CLR_BLUE)   
            
	  		//�����������������������������������������������������Ŀ
			//� Coloca no array os recnos que originaram a alocacao �
			//�������������������������������������������������������
			
			If nLoop == Day( ( cAliasPA2 )->PA2_DTINI )
				cHoraIni := ( cAliasPA2 )->PA2_HRINI
			Else
				cHoraIni := "....."
			EndIf				
			
			If Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nLoop } ) ) 
				AAdd( aDiasAloc, { nLoop,{ { nRecnoPA2, cHoraIni } } } ) 
			Else	
				If Empty( AScan( aDiasAloc[ nScan, 2 ], { |x| x[1] == nRecnoPA2 } ) )
					AAdd( aDiasAloc[ nScan, 2 ], { nRecnoPA2, cHoraIni } ) 
				EndIf 					
			EndIf 				
				
  		Next nLoop 
		
		nDiasAloc++
		
		nHoraAloc += SubtHoras( dCalcIni, cHrCalcIni, dCalcFim, cHrCalcFim ) 
		
	EndIf 	
	
	//��������������������������������������������������������������������������Ŀ
	//� Se tanto o inicio quanto o final estao fora deste mes, Marca todo o mes  �
	//����������������������������������������������������������������������������
	If ( cAliasPA2 )->PA2_DTINI < dDataIni .And. ( cAliasPA2 )->PA2_DTFIM > dDataFim 
	
		For nLoop := Day( dDataIni ) To Day( dDataFim ) 
			oCalend:addRestri( nLoop,CLR_BLUE,CLR_BLUE)         
			
			cHoraIni := "....." 
			
	  		//�����������������������������������������������������Ŀ
			//� Coloca no array os recnos que originaram a alocacao �
			//�������������������������������������������������������
			If Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nLoop } ) ) 
				AAdd( aDiasAloc, { nLoop, { { nRecnoPA2, cHoraIni } } } ) 
			Else	
				If Empty( AScan( aDiasAloc[ nScan, 2 ], { |x| x[1] == ( cAliasPA2 )->( Recno() ) } ) )
					AAdd( aDiasAloc[ nScan, 2 ], { nRecnoPA2, cHoraIni } ) 
				EndIf 					
			EndIf 				
			
  		Next nLoop                       
  		
		nHoraAloc += SubtHoras( dDataIni, "00:00", dDataFim, "23:59" )   		
  		
	EndIf 	
	
	( cAliasPA2 )->( dbSkip() ) 
	
EndDo                               

//�������������������������������������������������Ŀ
//� Exclui a area de trabalho da query              �
//���������������������������������������������������
#IFDEF TOP
	dbSelectArea( cAliasPA2 ) 
	dbCloseArea()
	dbSelectArea( "PA2" )  
#ELSE
	RetIndex( "PA2" )
	Ferase(cIndTrab+OrdBagExt())
#ENDIF 	

oCalend:Show()

nDias  := Int(nHoraAloc/24)
nHoras := nHoraAloc-(nDias*24)

aGet[2][2] := nDiasAloc
aGet[1][2] := Str(nDias,4)+"D "+IntToHora(nHoras)
aGet[3][2] := Len( aDiasAloc ) 
                    
aGet[3][1]:Refresh()
aGet[2][1]:Refresh()
aGet[1][1]:Refresh()

//�������������������������������������������������Ŀ
//� Analisa as restricoes ao calendario             �
//���������������������������������������������������
oCalend:Refresh()

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500Aloc � Autor � Eduardo Riera         � Data � 15.01.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Schedule automatico dos Tecnicos.                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Function At500Aloc()

Local aArea := GetArea()

//������������������������������������������������������������������������Ŀ
//� Parametros                                                             �
//�                                                                        �
//� MV_PAR01: Cliente de ?                                                 �
//� MV_PAR02: Cliente Ate?                                                 �
//� MV_PAR03: Os      de ?                                                 �
//� MV_PAR04: Os      Ate?                                                 �
//� MV_PAR05: Emissao de ?                                                 �
//� MV_PAR06: Emissao Ate?                                                 �
//� MV_PAR07: Regiao  de ?                                                 �
//� MV_PAR08: Regiao  Ate?                                                 �
//��������������������������������������������������������������������������

If ( Pergunte("ATA500",.T.) )
	Processa({|| At500Proc()})
EndIf

RestArea( aArea ) 

Return
*/
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500Proc � Autor � Eduardo Riera         � Data �18.01.98  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Processamento da Alocacao semi-automatica.                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static ;
Function At500Proc()

Local cQuery	:= ""
Local cArqInd  := CriaTrab(,.F.)
Local nIndex	:= 0
//������������������������������������������������������������������������Ŀ
//� Parametros                                                             �
//�                                                                        �
//� MV_PAR01: Cliente de ?                                                 �
//� MV_PAR02: Cliente Ate?                                                 �
//� MV_PAR03: Os      de ?                                                 �
//� MV_PAR04: Os      Ate?                                                 �
//� MV_PAR05: Emissao de ?                                                 �
//� MV_PAR06: Emissao Ate?                                                 �
//� MV_PAR07: Regiao  de ?                                                 �
//� MV_PAR08: Regiao  Ate?                                                 �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Monta a Query                                                           �
//��������������������������������������������������������������������������
cQuery := "AB6_FILIAL=='"+xFilial("AB6")+"'.And."
cQuery += "AB6_CODCLI>='"+MV_PAR01+"'.And."
cQuery += "AB6_CODCLI<='"+MV_PAR02+"'.And."
cQuery += "AB6_NUMOS>='"+MV_PAR03+"'.And."
cQuery += "AB6_NUMOS<='"+MV_PAR04+"'.And."
cQuery += "Dtos(AB6_EMISSA)>='"+Dtos(MV_PAR05)+"'.And."
cQuery += "Dtos(AB6_EMISSA)<='"+Dtos(MV_PAR06)+"'.And."
cQuery += "AB6_REGIAO>='"+MV_PAR07+"'.And."
cQuery += "AB6_REGIAO<='"+MV_PAR08+"'.And."
cQuery += "AB6_STATUS=='A'"

dbSelectArea("AB6")
ProcRegua(LastRec())
IndRegua("AB6",cArqInd,"AB6_FILIAL+AB6_REGIAO+AB6_NUMOS",,cQuery)
nIndex := RetIndex("AB6")
#IFNDEF TOP
	dbSetIndex(cArqInd+OrdBagExt())
#ENDIF
dbSelectArea("AB6")
dbSetOrder(nIndex+1)
dbGotop()
While ( !Eof() )

	AtAlocTec(AB6->AB6_NUMOS)

	dbSelectArea("AB6")
	dbSetOrder(nIndex+1)

	dbSkip()
	IncProc()
EndDo
//������������������������������������������������������������������������Ŀ
//�Restaura a Tabela AB6                                                   �
//��������������������������������������������������������������������������
dbSelectArea("AB6")
RetIndex("AB6")
dbClearFilter()
Ferase(cArqInd+OrdBagExt())

Return(Nil)
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500ViOs � Autor � Sergio Silveira       � Data �14/12/1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Visualizacao da ordem de servico corrente                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � At500ViOs( ExpO1 )                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 -> Objeto Browse                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CSF03VIS( oBrowse )

LOCAL aNumOs := AClone( oBrowse:Cargo )  
LOCAL cNumOS  
LOCAL nAt    := oBrowse:nAt

//�������������������������������������������������Ŀ
//� Se o array nao estiver vazio existe agendamento �
//���������������������������������������������������
  
If !Empty( aNumOs )
	
    cNumOs  := aNumOs[ nAt ] 
    
	PA0->( dbSetOrder( 1 ) ) 

	If PA0->( dbSeek( xFilial( "PA0" ) + cNumOs ) ) 
		U_CSF01VIS( "PA0", PA0->( RecNo() ), 2 ) 	                                     
	EndIf 
	
EndIf	

Return( .T. ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �At500Goto � Autor � Sergio Silveira       � Data �07/11/2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Localiza o inicio / final da alocacao                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � At500Goto( ExpO1, ExpA1, ExpN1 )                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 -> Objeto Calendario                                 ���
���          � ExpA1 -> Array contendo as alocacoes                       ���
���          � ExpN1 -> Tipo - 1 - Inicio                                 ���
���          �                 2 - Final                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSD03GOT(oCalend,aDiasAloc,nTipo)

LOCAL aDia := {}
LOCAL nDia := Day( oCalend:dDiaAtu )

If !Empty( nScan := AScan( aDiasAloc, { |x| x[1] == nDia } ) )   

	aDia := aDiasAloc[ nScan, 2 ]

	//������������������������������������������������������������������������Ŀ
	//� Ordena as alocacoes do dia por horario de chegada                      �
	//��������������������������������������������������������������������������
	ASort( aDia, , , { |x,y| y[2] > x[2] } ) 
	
	PA2->( dbGoto( If( nTipo == 1, aDia[ 1, 1 ], aDia[ Len( aDia ), 1 ] ) ) )  
	
	oCalend:dDiaAtu := If( nTipo == 1, PA2->PA2_DTINI, PA2->PA2_DTFIM ) 

	Eval( oCalend:bChange ) 	
	
EndIf 	

Return( .t. ) 

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �At500Gnt  � Autor � Henry Fila            � Data �11.08.2003 ���
��������������������������������������������������������������������������Ĵ��
���          �Exibe grafico de gantt das alocacoes dos tecnicos            ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1 : Array com os parametros de filtro                    ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1 - .T.                                                  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como gerar o grafico de gantt das alocacoes  ���
���          �dos tecnicos de acordo com o parametro                       ���
��������������������������������������������������������������������������Ĵ��
���Uso       � FieldService                                                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function CSF03Gnt(aParam)

Local aTecnicos := {}
Local aGant     := {}
Local aGantIt   := {}
Local aCores    := {CLR_HBLUE, CLR_HRED,CLR_BROWN, CLR_BLACK, CLR_GREEN, CLR_GRAY}
Local aConfig   := {}
Local aAuxCfg   := {}

Local nTop      := oMainWnd:nTop+23
Local nLeft     := oMainWnd:nLeft+5
Local nBottom   := oMainWnd:nBottom-60
Local nRight    := oMainWnd:nRight-10
Local nCor      := 0

Local oFont
Local oDlgCar
Local oBmp
Local oBtn
Local oBtnSair
Local oBtn1
Local oBtn2                  
Local cDesc:= ""
Local lRet := .T.
Local nTsk
Local dIni := ddatabase
Local nY   := 0
Local nX   := 0

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

aConfig := {2,.T.,.T.,.T.,.T.,.T.,.T.,.T.}

aTecnicos  :=U_CSF03Tec(aParam)

aGant := {}
For nX := 1 to Len(aTecnicos)

	nCor := If(nX > 6,1,nX)

	Aadd(aGant,{{aTecnicos[nX][1]+"-"+aTecnicos[nX][2],""},,CLR_GRAY,oBold})
	
	aGantIt := {}
	For nY := 1 to Len(aTecnicos[nX][3])
		Aadd(aGantIt,{aTecnicos[nX][3][nY][2],aTecnicos[nX][3][nY][3],aTecnicos[nX][3][nY][4],aTecnicos[nX][3][nY][5],,aCores[nCor],,1,})
	Next nY
	
	aGant[nX][2] := aClone(aGantIt)
	
Next nX

While lRet

	DEFINE FONT oFont NAME "Arial" SIZE 0, -10
	DEFINE MSDIALOG oDlgCar TITLE OemtoAnsi("Programacao de Entrega das Cargas") OF oMainWnd PIXEL FROM nTop,nLeft TO nBottom,nRight STYLE nOR(WS_VISIBLE,WS_POPUP) //"Programacao de Entrega das Cargas"
		@ 00,00 BITMAP oBmp RESNAME "FAIXASUPERIOR" SIZE 1200,50 NOBORDER PIXEL

		oBmp:Align:= CONTROL_ALIGN_TOP                
		
		@ 39,01 BUTTON 	OemtoAnsi("Opcoes") SIZE 35,12 ACTION If(At500Cfg("Teste",@oDlgCar,aConfig,@dIni,aGant),(oDlgCar:End(),lRet := .T.),Nil) OF oDlgCar PIXEL //"Opcoes"
		@ 39,38 BUTTON 	OemtoAnsi("Sair") SIZE 35,12 ACTION (lRet := .F.,oDlgCar:End()) OF oDlgCar PIXEL  //"Sair"				

		@ 38,(nRight/2)-58 MSGET dIni VALID If(!Empty(dIni),(oDlgCar:End(),lRet := .T.),Nil )  SIZE 40,9 OF oDlgCar PIXEL CENTERED
		@ 78,nRight - 140 BTNBMP oBtn1 RESOURCE "PREV" SIZE 20,20 ACTION (PmsPrvGnt(cVersao,@oDlgCar,aConfig,@dIni,aGant,@nTsk),oDlgCar:End(),lRet := .T.) MESSAGE "Retroceder Calendario..."
		@ 78,nRight - 37 BTNBMP oBtn2 RESOURCE "NEXT" SIZE 20,20 ACTION (PmsNxtGnt(cVersao,@oDlgCar,aConfig,@dIni,aGant,@nTsk),oDlgCar:End(),lRet := .T.) MESSAGE "Avancar Calendario..."
 	
		aAuxCfg := {aConfig[1],aConfig[3],aConfig[4],aConfig[5],aConfig[6],aConfig[7]}		
		oPanel  := PmsGantt(aGant,aAuxCfg,@dIni,,oDlgCar,{50,1,((nBottom-nTop))-45,((nRight-nLeft)/2)-10},{{OemtoAnsi(" "),30}},@nTsk) 
		aConfig[1] := aAuxCfg[1]
		
	ACTIVATE MSDIALOG oDlgCar

EndDo  

Return lRet

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �At500Cfg  � Autor � Henry Fila            � Data �11.08.2003 ���
��������������������������������������������������������������������������Ĵ��
���          �Exibe configurador do gantt                                  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1 : Versao do Gantt                                      ���
���          �ExpO2 : Objeto da janela                                     ���
���          �ExPA2 : Array com os parametros da configuracao              ���
���          �ExpD4 : Data inicial                                         ���
���          �ExpA5 : Array com os dados do gantt                          ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1 - .T.                                                  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como gerar o grafico de gantt das alocacoes  ���
���          �dos tecnicos de acordo com o parametro                       ���
��������������������������������������������������������������������������Ĵ��
���Uso       � FieldService                                                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function CSF03Cfg(cVersao,oDlg,aConfig,dIni,aGantt)
Local lRet		:= .F.  
Local aConfigBk := aClone(aConfig)

lRet := ParamBox({	{3,OemtoAnsi("Diario"),aConfig[1],{OemtoAnsi("Semanal"),OemtoAnsi("Mensal"),OemtoAnsi("Mensal (Zoom 30%)"),OemtoAnsi("Bimestral"),OemtoAnsi("TESTE"),OemtoAnsi("Configuracoes do Gantt")},60,,.F.}},; //###"Diario"###"Semanal"###"Mensal"###"Mensal (Zoom 30%)"###"Bimestral"
				OemtoAnsi("Mostrar Recursos"),aConfig,,,.F.,120,3) //"Configuracoes do Gantt" //"Mostrar Recursos"

aConfigBk[1] := aConfig[1]
aConfig := aClone(aConfigBk)


Return lRet

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �At500Param� Autor � Henry Fila            � Data �12.04.2002 ���
��������������������������������������������������������������������������Ĵ��
���          �Parametros do Gantt                                          ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1 - .T.                                                  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo ober os parametros do gantt    ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Field Service                                               ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function CSF03PAR()

Local aParam := {}

If Pergunte("TEC500",.T.)   

	Aadd(aParam, {"TECN_FROM", mv_par01 })
	Aadd(aParam, {"TECN_TO"  , mv_par02 })
	Aadd(aParam, {"DATA_FROM", mv_par03 })			
	Aadd(aParam, {"DATA_TO"  , mv_par04 })						
		     
//	At500Gnt(aParam)
	U_CSF03Gnt(aParam)
Endif

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �AtSchedTec� Autor � Henry Fila            � Data �22.08.2003 ���
��������������������������������������������������������������������������Ĵ��
���          �Traz os horarios ddas alocacoes                              ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpN1 := AtSchedTec(ExpA1)                                   ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1 - Array mnemonico os dados a serem considerados        ���
���          �        {TECN_FROM,Codigo do Tecnico Inicial}                ���
���          �        {TECN_TO  ,Codigo do Tecnico Final  }                ���
���          �        {DATA_FROM,Data Inicial}                             ���
���          �        {DATA_TO  ,Data Final  }                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1 - .T.                                                  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo retornar os horarios das aloca ���
���          �coes dos tecnicos de acordo com parametros                   ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Field Service                                               ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function CSF03Tec( aParam )

Local aTecnico   := {}
Local aItens     := {}
Local cQuery     := ""
Local cIndPA2    := ""
Local cKeyPA2    := ""
Local cTecFrom   := Space(Len(AA1->AA1_CODTEC))
Local cTecTo     := Replicate( "Z", Len( AA1->AA1_CODTEC ) )
Local cTecnico   := ""
Local dDataFrom  := Ctod("01/01/80")
Local dDataTo    := Ctod("31/12/20")

Local cAliasPA2 := "PA2"
Local cAliasAA1 := "AA1"

Local lQuery  := .F.

Local nIndPA2 := 0        
Local nLoop   := 0

DEFAULT aParam := {}

For nLoop := 1 To Len( aParam ) 
       
	cTipo    := aParam[ nLoop, 1 ]

	Do Case                 
	Case cTipo == "TECN_FROM"  
		cTecFrom    := aParam[ nLoop, 2 ] 	
	Case cTipo == "TECN_TO"  
		cTecTo      := aParam[ nLoop, 2 ] 	
	Case cTipo == "DATA_FROM"  
		dDataFrom     := aParam[ nLoop, 2 ] 
	Case cTipo == "DATA_TO"  
		dDataTo    := aParam[ nLoop, 2 ] 
	EndCase 		
			
Next nLoop 	


dbSelectArea("PA2")
#IFDEF TOP         

	lQuery := .T.
	
	cAliasPA2 := "QRYPA2"
	cAliasAA1 := "QRYPA2"

	cQuery := "SELECT PA2.*, AA1_NOMTEC FROM "
	cQuery += RetSqlName("PA2") + " PA2, "
	cQuery += RetSqlName("AA1") + " AA1 "
	cQuery += " WHERE "

	cQuery += "PA2_FILIAL ='"+xFilial("PA2")+"' AND "
	cQuery += "PA2_CODTEC >= '"+cTecFrom+"' AND "
	cQuery += "PA2_CODTEC <= '"+cTecTo+"' AND "		
	cQuery += "PA2_DTINI  >= '"+Dtos(dDataFrom)+"' AND "
	cQuery += "PA2_DTFIM  <= '"+Dtos(dDataTo)+"' AND "	
	cQuery += "PA2.D_E_L_E_T_ = ' ' AND " 
	
	cQuery += "AA1_FILIAL ='"+xFilial("AA1")+"' AND "
	cQuery += "AA1_CODTEC = PA2_CODTEC AND " 
	cQuery += "AA1.D_E_L_E_T_ = ' ' "
	
	cQuery += "ORDER BY AA1_CODTEC"

	cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPA2,.T.,.T.)

	TcSetField( cAliasPA2, "PA2_DTINI", "D", 8, 0 ) 
	TcSetField( cAliasPA2, "PA2_DTFIM", "D", 8, 0 ) 
   

#ELSE

	dbSelectArea("PA2")
	dbSetOrder(1)
	cIndPA2 := CriaTrab(NIL,.F.)
	cKeyPA2 := IndexKey()

	cCond := 'PA2_FILIAL == "'+xFilial("PA2")+'" .And.'
	cCond += 'PA2_CODTEC >= "'+cTecFrom+'" .And. PA2_CODTEC <= "'+cTecTo+'" .And. '
	cCond += 'Dtos(PA2_DTINI) >= "'+Dtos(dDataFrom)+'" .And. Dtos(PA2_DTFIM) <= "'+Dtos(dDataTo)+'" '	

	IndRegua("PA2",cIndPA2,cKeyPA2,,cCond,"Selecionando Registros ...") 
	nIndPA2 := RetIndex("PA2")+1

	#IFNDEF TOP
		dbSetIndex(cIndPA2+OrdBagExT())
	#ENDIF  	

	dbSetOrder(nIndPA2)           
	dbGotop()
	
#ENDIF

While (cAliasPA2)->(!Eof())   

	cTecnico := (cAliasPA2)->PA2_CODTEC

	If !lQuery 
		AA1->(dbSetOrder(1))
		AA1->(MsSeek(xFilial("AA1")+PA2->PA2_CODTEC))
	Endif

	Aadd(aTecnico,{	(cAliasPA2)->PA2_CODTEC, Capital( (cAliasAA1)->AA1_NOMTEC ),}	)

	aItens := {}

	While (cAliasPA2)->(!Eof()) .And. (cAliasPA2)->PA2_CODTEC == cTecnico

		Aadd(aItens,{(cAliasPA2)->PA2_NUMOS,;
					(cAliasPA2)->PA2_DTINI,;
					(cAliasPA2)->PA2_HRINI,;
					(cAliasPA2)->PA2_DTFIM,;
					(cAliasPA2)->PA2_HRFIM})

		(cAliasPA2)->(dbSkip())               
	
	EndDo

	aTecnico[Len(aTecnico)][3] := aClone(aItens)

Enddo

aTecnico := aSort(aTecnico,,,{|x,y| x[1] < y[1] })

If lQuery
	dbSelectARea(cAliasPA2)
	dbCloseArea()
Endif

Return(aTecnico)

