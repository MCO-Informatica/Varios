//#INCLUDE "RHTOQUA.CH"
#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	  � RHTOQUAT   � Autor � Aldo Marini Junior � Data � 01/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o  � Criado este programa para compatibilizar as tabelas dos   ���
���			  � modulos de gestao de qualidade quando a migracao 6.09 para���
���			  � 7.10 quando estiver com o parametro MV_GQINT desligado.   ���
�������������������������������������������������������������������������Ĵ��
���Uso		  � QUALITY                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function XRHT()

Local cIntGPE	:= GetMv("MV_QGINT",.F.,"N")
Local cCodigo	:= ""
Local cDepto	:= ""
Local cCargo	:= ""
Local cFil1		:= ""
Local cFil2		:= ""
Local cFil3		:= ""
Local aEmpFil	:= {}
Local nCnt		:= 0
Local nFil		:= 0
Local cPriFil	:= QXPOSFIL(cEmpAnt)
Local cModoQAC	:= "E"
Local cModoQAD	:= "E"
Local cModoSRJ	:= "E"
Local cModoDep	:= "E"
Local cFilSRJ	:= xFilial("SRJ")
Local lAtualiza	:= .F.
Local aUsuarios	:= {}
Local aDeptos	:= {}
Local aCargos	:= {}
Local nTamCC	:= Iif(CtbInUse(),TamSx3("CTT_CUSTO")[1],TamSx3("I3_CUSTO")[1])
Local nTamCG	:= TamSx3("RJ_FUNCAO")[1]
Local nTamMAT	:= TamSx3("RA_MAT")[1]
Local nRegAtu	:= 0
Local cText		:= ""
Local aCamp		:= {}
Local lQN4Exist	:= .F.
Local lQDZExist	:= .F.
Local lQUMExist	:= .F.
Local cAlias	:= Iif(CtbInUse(),"CTT","SI3")
Local cFilDep	:= Iif(CtbInUse(),"CTT_FILIAL","I3_FILIAL")
Local lTMKPMS	:= If(GetMv("MV_QTMKPMS",.F.,1) == 1,.F.,.T.)//Integracao do QNC com TMK e PMS: 1-Sem integracao,2-TMKxQNC,3-QNCxPMS,4-TMKxQNCxPMS �
Local lTemCargo := .F.     
Local lGrvQAA   := .T.
Local nOrderSX3 := 0

// este recurso comentado eh usado apenas quando o ambiente nao esta levantado
// Dbselect("SX3")
// nOrderSX3 := IndexOrd()
// DbSetOrder(2)
// lTemCargo := dbseek("QAC_CARGO") .and. dbseek("QAC_DESCCG")  
// DbSetOrder(nOrderSX3)

// Acerta os espa�os do campo filial corretamente
cPriFil := ParamXFil( cPriFil )

DbSelectArea("QAC")
DbSetOrder(1)
lTemCargo := QAC->(FieldPos("QAC_CARGO")) > 0 .and. QAC->(FieldPos("QAC_DESCCG")) > 0

If cIntGPE == "N"
	Help( "", 1, "RHTOQUA1",,OemToAnsi("A integracao com os modulos de R.H. esta desativada."+chr(13)+"Nao sera possivel a atualizacao."),1)
	Return
Endif

//If GETMV("MV_QRHTOQA",.T.)
//	Help( "", 1, "RHTOQUA2",,OemToAnsi("A atualizacao das tabelas nao podera ser feita novamente."),1)
//	Return
//Endif

If !ApMsgNoYes("ANTES DA ATUALIZACAO DEVERA SER FEITO UM BACKUP DA BASE DE DADOS"+chr(13)+chr(13)+;	// "ANTES DA ATUALIZACAO DEVERA SER FEITO UM BACKUP DA BASE DE DADOS"
             "A atualizacao de tabelas que tenham os campos referente a usuarios,"+chr(13)+; //"A atualizacao dos tabelas que tenha os campos referente a usuarios,"
             "departamentos e cargos serao atualizadas conforme integracao dos"+chr(13)+; //"departamentos e cargos serao atualizadas conforme integracao dos"
             "modulos R.H. e Quality."+chr(13)+chr(13)+; //"modulos R.H. e Quality."
			 "Deseja iniciar a atualizacao das Tabelas ?","Atencao")	// "Deseja iniciar a atualizacao das Tabelas ?" ### "Atencao"
	Return
Endif


//�����������������������������������������������������������Ŀ
//�Modo de Abertura do Arquivo (C)ompartilhado - (E)xclusivo. �
//�������������������������������������������������������������
DbSelectArea("SX2")
DbSetOrder(1)
Set Filter to
If DbSeek("QN4")
	lQN4Exist := .T.
Endif
If DbSeek("QDZ")
	lQDZExist := .T.
Endif
If DbSeek("QUM")
	lQUMExist := .T.
Endif
If DbSeek("QAC")
	cModoQAC:= X2_MODO 
EndIf		
If DbSeek("QAD")
	cModoQAD:= X2_MODO
EndIf		
If DbSeek("SRJ")
	cModoSRJ := X2_MODO
Endif
If DbSeek(cAlias)  //verifico modo da SI3 ou CTT
	cModoDep := X2_MODO
Endif
If cModoQAC <> cModoSRJ .Or. cModoQAD <> cModoDep
	Help( "", 1, "RHTOQUA3",,OemToAnsi("Existe incompatibilidade de compartilhamento entre as tabelas QAC-SRJ ou QAD-SI3/CTT."),1)
	Return
Endif

//�����������������������������������������������������������Ŀ
//�Verifica o tamanho dos campos                              �
//�������������������������������������������������������������
aAdd(aCamp,{"QAA_CODFUN", TamSx3("QAA_CODFUN")[1],nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QAA_CC"    , TamSx3("QAA_CC")[1]    ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QAC_FUNCAO", TamSx3("QAC_FUNCAO")[1],nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
If lTemCargo
	aAdd(aCamp,{"QAC_CARGO",  TamSx3("QAC_CARGO")[1] ,nTamCG+FWSizeFilial()+Len(FWGrpCompany())}) // - tem o mesmo tamanho nTamCG - acrescentado campo QAC_CARGO NOVO - Analista Adilson Soeiro, 20/10/2009
Endif
aAdd(aCamp,{"QAD_CUSTO" , TamSx3("QAD_CUSTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})  
aAdd(aCamp,{"QD0_MAT"   , TamSx3("QD0_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD0_DEPTO" , TamSx3("QD0_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD1_MAT"   , TamSx3("QD1_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD1_DEPTO" , TamSx3("QD1_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD1_CARGO" , TamSx3("QD1_CARGO")[1] ,nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD1_DEPBX" , TamSx3("QD1_DEPBX")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD2_DEPTO" , TamSx3("QD2_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD4_MAT"   , TamSx3("QD4_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD4_DEPBX" , TamSx3("QD4_DEPBX")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD7_MAT"   , TamSx3("QD7_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD8_MAT"   , TamSx3("QD8_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD8_DEPTO" , TamSx3("QD8_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD8_CARGO" , TamSx3("QD8_CARGO")[1] ,nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD9_MAT"   , TamSx3("QD9_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QD9_DESMAT", TamSx3("QD9_DESMAT")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDA_MAT1"  , TamSx3("QDA_MAT1")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDA_MAT2"  , TamSx3("QDA_MAT2")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDA_MAT3"  , TamSx3("QDA_MAT3")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDD_DEPTOA", TamSx3("QDD_DEPTOA")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDD_CARGOA", TamSx3("QDD_CARGOA")[1],nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDE_MATSOL", TamSx3("QDE_MATSOL")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDE_MATDES", TamSx3("QDE_MATDES")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDF_MATANT", TamSx3("QDF_MATANT")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDF_MATNOV", TamSx3("QDF_MATNOV")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDF_MATOP" , TamSx3("QDF_MATOP")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDG_MAT"   , TamSx3("QDG_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDG_DEPTO" , TamSx3("QDG_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDH_MAT"   , TamSx3("QDH_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDH_DEPTOD", TamSx3("QDH_DEPTOD")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDH_DEPTOE", TamSx3("QDH_DEPTOE")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDJ_DEPTO" , TamSx3("QDJ_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDL_DEPTO" , TamSx3("QDL_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDM_DEPTO" , TamSx3("QDM_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDM_CARGO" , TamSx3("QDM_CARGO")[1] ,nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDN_DEPTO" , TamSx3("QDN_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDN_CARGO" , TamSx3("QDN_CARGO")[1] ,nTamCG+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDP_MAT"   , TamSx3("QDP_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDP_MATBX" , TamSx3("QDP_MATBX")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDP_DEPTO" , TamSx3("QDP_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDP_DEPBX" , TamSx3("QDP_DEPBX")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDR_MATRES", TamSx3("QDR_MATRES")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDR_MATDE" , TamSx3("QDR_MATDE")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QDR_MATPAR", TamSx3("QDR_MATPAR")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
If 	lQDZExist
	aAdd(aCamp,{"QDZ_MAT"   , TamSx3("QDZ_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
	aAdd(aCamp,{"QDZ_DEPTO" , TamSx3("QDZ_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
Endif

aAdd(aCamp,{"QF2_MAT"   , TamSx3("QF2_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QF2_MATQLD", TamSx3("QF2_MATQLD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QF3_MAT"   , TamSx3("QF3_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QEK_SOLIC" , TamSx3("QEK_SOLIC")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QER_ENSR"  , TamSx3("QER_ENSR")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QE5_RESPON", TamSx3("QE5_RESPON")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QEP_SOLIC" , TamSx3("QEP_SOLIC")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QP5_RESPON", TamSx3("QP5_RESPON")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QPR_ENSR"  , TamSx3("QPR_ENSR")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})

aAdd(aCamp,{"QM2_RESP"  , TamSx3("QM2_RESP")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM2_DEPTO" , TamSx3("QM2_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM6_RESP"  , TamSx3("QM6_RESP")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM1_RDISTR", TamSx3("QM1_RDISTR")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM1_DISTR" , TamSx3("QM1_DISTR")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM5_ENSR"  , TamSx3("QM5_ENSR")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QME_RESP"  , TamSx3("QME_RESP")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QML_RESCOL", TamSx3("QML_RESCOL")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QML_RESRET", TamSx3("QML_RESRET")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QML_DEPTO" , TamSx3("QML_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QMU_RESP"  , TamSx3("QMU_RESP")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QM9_DEPTO" , TamSx3("QM9_DEPTO")[1] ,nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
If lQN4Exist
	aAdd(aCamp,{"QN4_DEPRSA", TamSx3("QN4_DEPRSA")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
	aAdd(aCamp,{"QN4_DEPREN", TamSx3("QN4_DEPRSA")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
	aAdd(aCamp,{"QN4_RESSAI", TamSx3("QN4_RESSAI")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
	aAdd(aCamp,{"QN4_RESENT", TamSx3("QN4_RESENT")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
Endif

aAdd(aCamp,{"QKG_RESP"  , TamSx3("QKG_RESP")[1]  ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QKP_MAT"   , TamSx3("QKP_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})

aAdd(aCamp,{"QIF_MAT"   , TamSx3("QIF_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI2_ORIDEP", TamSx3("QI2_ORIDEP")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI2_DESDEP", TamSx3("QI2_DESDEP")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI2_MATRES", TamSx3("QI2_MATRES")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI2_MATDEP", TamSx3("QI2_MATDEP")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI2_MAT"   , TamSx3("QI2_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI3_MAT"   , TamSx3("QI3_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI4_MAT"   , TamSx3("QI4_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QI5_MAT"   , TamSx3("QI5_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})

//�����������������������������������������������������������Ŀ
//�Verifica o tamanho dos campos - SIGAQAD                    �
//�������������������������������������������������������������
aAdd(aCamp,{"QU1_CODAUD", TamSx3("QU1_CODAUD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUA_MAT"   , TamSx3("QUA_MAT")[1]   ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUB_AUDLID", TamSx3("QUB_AUDLID")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUC_CODAUD", TamSx3("QUC_CODAUD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUD_CODAUD", TamSx3("QUD_CODAUD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUH_CODAUD", TamSx3("QUH_CODAUD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUH_CCUSTO", TamSx3("QUH_CCUSTO")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
If lQUMExist
	aAdd(aCamp,{"QUM_CODAUD", TamSx3("QUM_CODAUD")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
	aAdd(aCamp,{"QUM_CCUSTO", TamSx3("QUM_CCUSTO")[1],nTamCC+FWSizeFilial()+Len(FWGrpCompany())})
Endif
aAdd(aCamp,{"QUN_MATRES"    , TamSx3("QUN_MATRES")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUN_MATDE"     , TamSx3("QUN_MATDE")[1] ,nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})
aAdd(aCamp,{"QUN_MATPAR"    , TamSx3("QUN_MATPAR")[1],nTamMAT+FWSizeFilial()+Len(FWGrpCompany())})

For nCnt:=1 to Len(aCamp)
	If aCamp[nCnt,2] <> aCamp[nCnt,3]
		If !Empty(cText)
			cText := cText + ", "
		Endif
		cText := cText + aCamp[nCnt,1]
	Endif
Next

If !Empty(cText)
	MsgAlert(OemToAnsi("Existe(m) campo(s) com tamanho incorreto,verifique!")+chr(13)+cText,"Atencao")
	Return
Endif

dbSelectArea("SX6")
If !dbSeek(xFilial("SX6")+"MV_QRHTOQA")
	RecLock("SX6",.T.)
	SX6->X6_VAR     := "MV_QRHTOQA"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Define se houve atualizacao das tabelas do quality"
	SX6->X6_DESC1   := "apos migracao de versao."
	SX6->X6_CONTEUD := "S"
	SX6->X6_CONTENG := "S"
	SX6->X6_CONTSPA := "S"
	MsUnlock()
EndIf
// Itens a serem feitos
// Verificar empresa/filial de/para ( tabela QAJ )
// Colocar o ultimo registro SRE no QAB
// Prever arquivos novos QMT

DbSelectArea("SM0")
If SM0->(DbSeek(cEmpAnt))
	While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
		Aadd(aEmpFil,SM0->M0_CODFIL)
		SM0->(DbSkip())
	EndDo
EndIf

DbSelectArea("SRA")
DbSetOrder(1)

DbSelectArea("SRJ")
DbSetOrder(1)

DbSelectArea(cAlias) //CTT ou SI3
DbSetOrder(1)

//Begin Transaction

DbSelectArea("QAA")
DbSetOrder(6)
DbGotop()
While !Eof()
	If QAA->QAA_TPUSR == "1" 
		cCodigo := Alltrim(cEmpAnt+QAA->QAA_FILIAL+QAA->QAA_MAT)
		If cModoQAD == "C"
			cDepto  := cEmpAnt+cPriFil+QAA->QAA_CC
		Else
			cDepto  := cEmpAnt+QAA->QAA_FILIAL+QAA->QAA_CC
		Endif
		If cModoQAC == "C"
			cCargo  := cEmpAnt+cPriFil+QAA->QAA_CODFUN
		Else
			cCargo  := cEmpAnt+QAA->QAA_FILIAL+QAA->QAA_CODFUN
		Endif

		If SRA->(dbSeek(QAA->QAA_FILIAL+QAA->QAA_MAT))
			nRegAtu := QAA->(RECNO())
			QAA->(DbSetOrder(1))
			If !QAA->(dbSeek(QAA->QAA_FILIAL+cCodigo))
				dbGoto(nRegAtu)
				aadd(aUsuarios,{cCodigo,QAA->QAA_FILIAL})
				
				RecLock("QAA",.F.)
				QAA->QAA_MAT    := cCodigo
				QAA->QAA_CC     := cDepto
				QAA->QAA_CODFUN := cCargo
				MsUnlock()
			Else
				dbGoto(nRegAtu)
			Endif
			QAA->(DbSetOrder(6))
		Else
			If SRA->(dbSeek(QAA->QAA_FILIAL+SubStr(QAA->QAA_MAT,5,6)))
				aadd(aUsuarios,{QAA->QAA_MAT,QAA->QAA_FILIAL})
			Else
				RecLock("QAA",.F.)
				QAA->QAA_TPUSR := "2" //Outros
				MsUnlock()
			Endif
		Endif
	Endif
	DbSkip()
EndDo
DbSetOrder(1)

DbSelectArea("SRA")
DbSetOrder(1)
DbGotop()
While !Eof()
	If !QAA->(dbSeek(SRA->RA_FILIAL+cEmpAnt+SRA->RA_FILIAL+SRA->RA_MAT))
		If ExistBlock("QDOGRQAA")     
			If ValType(lGrvQAA := ExecBlock("QDOGRQAA",.F.,.F.)) != "L"
				lGrvQAA := .T.
			EndIf   
			
			dbSelectArea("QAA")
		EndIf	
		If lGrvQAA
	        RecLock("QAA",.T.)
			QAA->QAA_FILIAL:= SRA->RA_FILIAL
			QAA->QAA_TPUSR := "1"
			QAA->QAA_MAT   := cEmpAnt+SRA->RA_FILIAL+SRA->RA_MAT
			QAA->QAA_NOME  := SRA->RA_NOME
			QAA->QAA_APELID:= SRA->RA_APELIDO
			QAA->QAA_INICIO:= SRA->RA_ADMISSA
			QAA->QAA_FIM   := SRA->RA_DEMISSA
			QAA->QAA_RECMAI:= If(SRA->RA_RECMAIL == "S","1","2")
			QAA->QAA_TPMAIL:= SRA->RA_TPMAIL
			QAA->QAA_EMAIL := SRA->RA_EMAIL
			QAA->QAA_LOGIN := SRA->RA_APELIDO
			QAA->QAA_STATUS:= If(SRA->RA_SITFOLH == "D","2","1")
			QAA->QAA_LOGIN := SRA->RA_APELIDO
			QAA->QAA_RECFNC:= SRA->RA_RECPFNC
			QAA->QAA_AUDIT := "2"
			QAA->QAA_DISTSN:= If(SRA->RA_DISTSN == "S","1","2")
			QAA->QAA_TPRCBT:= SRA->RA_TPRCBT
			QAA->QAA_TPWORD:= "1"
							
			If cModoQAD == "C"
				QAA->QAA_CC    := cEmpAnt+cPriFil+SRA->RA_CC
			Else
				QAA->QAA_CC    := cEmpAnt+SRA->RA_FILIAL+SRA->RA_CC
			Endif
			If cModoQAC == "C"
				QAA->QAA_CODFUN:= cEmpAnt+cPriFil+SRA->RA_CODFUNC
			Else
				QAA->QAA_CODFUN:= cEmpAnt+SRA->RA_FILIAL+SRA->RA_CODFUNC
			Endif
	
			MsUnLock()
			aadd(aUsuarios,{cEmpAnt+SRA->RA_FILIAL+SRA->RA_MAT,SRA->RA_FILIAL})
		EndIf				
		dbSelectArea("SRA")
	Endif
	DbSkip()
EndDo
DbSetOrder(1)

DbSelectArea("SQ3") // Tab Cargos para ser inserido a descri��o na integracao de dados - Analita Adilson Soeiro, 20/10/2009
DbSelectArea("QAC")
DbSetOrder(2)
DbGotop()
While !Eof()
	If cModoQAC == "C"
		cCodigo := Alltrim(cEmpAnt+cPriFil+QAC->QAC_FUNCAO)
	Else
		cCodigo := Alltrim(cEmpAnt+QAC->QAC_FILIAL+QAC->QAC_FUNCAO)
	Endif
	nRegAtu := QAC->(RECNO())
	If SRJ->(dbSeek(QAC->QAC_FILIAL+QAC->QAC_FUNCAO))
		QAC->(DbSetOrder(1))
		If !QAC->(dbSeek(QAC->QAC_FILIAL+cCodigo))

            SQ3->(dbSeek(SRJ->(RJ_FILIAL+RJ_CARGO)) ) // acrescentado a pesquisa do cargo, considerando como foi cadastrado no GPE - Analista Adilson Soeiro, 20/10/2009

			dbGoto(nRegAtu)
			aadd(aCargos,{cCodigo,QAC->QAC_FILIAL})
			RecLock("QAC",.F.)
			QAC->QAC_FUNCAO := cCodigo
   			If lTemCargo  
				QAC->QAC_CARGO  := Iif( empty(SRJ->RJ_CARGO), " ",SUBS(cCodigo,1,4)+SRJ->RJ_CARGO) // acrescentado o codigo do CARGO na integracao - Analista Adilson Soeiro, 20/10/2009 
    	        QAC->QAC_DESCCG := SQ3->Q3_DESCSUM // acrescentado a descricao do CARGO na integracao - Analista Adilson Soeiro, 20/10/2009
			Endif
			MsUnlock()
		Else
			dbGoto(nRegAtu)
		Endif
		QAC->(DbSetOrder(2))
	Else
		If SRJ->(dbSeek(QAC->QAC_FILIAL+SubStr(QAC->QAC_FUNCAO,5,5)))
			aadd(aCargos,{{QAC->QAC_FUNCAO,QAC->QAC_FILIAL}})
		Endif
	Endif
	dbGoto(nRegAtu)
	DbSkip()
EndDo

QAC->(DbSetOrder(1))
DbSelectArea("SRJ")
DbGotop()
While !Eof()
	If cModoQAC == "C"
		cCodigo := Alltrim(cEmpAnt+cPriFil+SRJ->RJ_FUNCAO)
	Else
		cCodigo := Alltrim(cEmpAnt+SRJ->RJ_FILIAL+SRJ->RJ_FUNCAO)
	Endif

	If !QAC->(dbSeek(SRJ->RJ_FILIAL+cCodigo))

        SQ3->(dbSeek(SRJ->(RJ_FILIAL+RJ_CARGO)) ) // acrescentado a pesquisa do cargo - Analista Adilson Soeiro, 20/10/2009

		RecLock("QAC",.T.)
		QAC->QAC_FILIAL := SRJ->RJ_FILIAL
		QAC->QAC_FUNCAO := cCodigo
		QAC->QAC_DESC   := SRJ->RJ_DESC
		If lTemCargo .AND. !Empty(SRJ->RJ_CARGO)
			QAC->QAC_CARGO  := SUBS(cCodigo,1,4) + SRJ->RJ_CARGO  // acrescentado o codigo do CARGO na integracao - Analista Adilson Soeiro, 20/10/2009 
			QAC->QAC_DESCCG := SQ3->Q3_DESCSUM  // acrescentado a descricao do CARGO na integracao - Analista Adilson Soeiro, 20/10/2009 
		Endif
		MsUnlock()
		aadd(aCargos,{{QAC->QAC_FUNCAO,QAC->QAC_FILIAL}})
	Endif
	DbSelectArea("SRJ")
	DbSkip()
EndDo

DbSelectArea("QAD")
DbSetOrder(2)
DbGotop()
While !Eof()
	If cModoQAD == "C"
		cCodigo := Alltrim(cEmpAnt+cPriFil+QAD->QAD_CUSTO)
	Else
		cCodigo := Alltrim(cEmpAnt+QAD->QAD_FILIAL+QAD->QAD_CUSTO)
	Endif
	nRegAtu := QAD->(RECNO())
	If (cAlias)->(dbSeek(QAD->QAD_FILIAL+SubStr(QAD->QAD_CUSTO,1,nTamCC)))
		QAD->(DbSetOrder(1))
		If !QAD->(dbSeek(QAD->QAD_FILIAL+cCodigo))
			dbGoto(nRegAtu)
			aadd(aDeptos,{cCodigo,QAD->QAD_FILIAL})
			RecLock("QAD",.F.)
			QAD->QAD_CUSTO := cCodigo
			If !Empty(QAD->QAD_MAT)
				QAD->QAD_MAT   := cEmpAnt+QAD->QAD_FILMAT+QAD->QAD_MAT
			Endif
			MsUnLock()
		Else
			dbGoto(nRegAtu)		
		Endif
		QAD->(DbSetOrder(2))
	Else
		If (cAlias)->(dbSeek(QAD->QAD_FILIAL+SubStr(QAD->QAD_CUSTO,5,nTamCC)))
			aadd(aDeptos,{QAD->QAD_CUSTO,QAD->QAD_FILIAL})		
		Endif
	Endif
	dbGoto(nRegAtu)
	DbSkip()
EndDo

QAD->(DbSetOrder(1))
DbSelectArea(cAlias)  //CTT ou SI3
DbGotop()
While !Eof()
	If cModoQAD == "C"
		If !CtbInUse()
			cCodigo := Alltrim(cEmpAnt+cPriFil+SI3->I3_CUSTO)
		Else
			cCodigo := Alltrim(cEmpAnt+cPriFil+CTT->CTT_CUSTO)
		EndIf
	Else
		If !CtbInUse()
			cCodigo := Alltrim(cEmpAnt+SI3->I3_FILIAL+SI3->I3_CUSTO)
		Else
			cCodigo := Alltrim(cEmpAnt+CTT->CTT_FILIAL+CTT->CTT_CUSTO)		
		EndIf
	Endif
	If !QAD->(dbSeek(&(cAlias+"->"+cFilDep)+cCodigo))
		RecLock("QAD",.T.)
		QAD->QAD_FILIAL:= &(cAlias+"->"+cFilDep)
		QAD->QAD_CUSTO := cCodigo
		QAD->QAD_DESC  := Iif(CtbInUse(),CTT->CTT_DESC01,SI3->I3_DESC)
		If !CtbInUse()
			QAD->QAD_STATUS:= If(SI3->I3_STATUS <> "I","1","2")
			If !Empty(SI3->I3_MAT) .And. !Empty(SI3->I3_FILMAT)
				QAD->QAD_FILMAT:= SI3->I3_FILMAT
				QAD->QAD_MAT   := cEmpAnt+SI3->I3_FILMAT+SI3->I3_MAT
			Endif
		Else
			QAD->QAD_STATUS := If(CTT->CTT_BLOQ <> "1","1","2")
		EndIf
		MsUnLock()

		aadd(aDeptos,{cCodigo,QAD->QAD_FILIAL})
	Endif
	DbSelectArea(cAlias)
	DbSkip()
EndDo

DbSelectArea("QD0")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD0->QD0_FILMAT+QD0->QD0_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD0->QD0_FILMAT+cEmpAnt+QD0->QD0_FILMAT+SubStr(QD0->QD0_MAT,1,6))}) > 0
		RecLock("QD0",.F.)
		QD0->QD0_MAT  := cEmpAnt+QD0->QD0_FILMAT+QD0->QD0_MAT
		If cModoQAD == "C"
			QD0->QD0_DEPTO:= cEmpAnt+cPriFil+QD0->QD0_DEPTO
		Else
			QD0->QD0_DEPTO:= cEmpAnt+QD0->QD0_FILMAT+QD0->QD0_DEPTO
		Endif
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QD1")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD1->QD1_FILMAT+QD1->QD1_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD1->QD1_FILMAT+cEmpAnt+QD1->QD1_FILMAT+SubStr(QD1->QD1_MAT,1,6))}) > 0

		RecLock("QD1",.F.)
		QD1->QD1_MAT  := cEmpAnt+QD1->QD1_FILMAT+QD1->QD1_MAT
		If cModoQAD == "C"
			QD1->QD1_DEPTO:= cEmpAnt+cPriFil+QD1->QD1_DEPTO
		Else	
			QD1->QD1_DEPTO:= cEmpAnt+QD1->QD1_FILMAT+QD1->QD1_DEPTO
		Endif
		If cModoQAD == "C"
			QD1->QD1_CARGO:= cEmpAnt+cPriFil+QD1->QD1_CARGO
		Else
			QD1->QD1_CARGO:= cEmpAnt+QD1->QD1_FILMAT+QD1->QD1_CARGO
		Endif			
		If !Empty(QD1->QD1_MATBX)
			QD1->QD1_MATBX:= cEmpAnt+QD1->QD1_FMATBX+QD1->QD1_MATBX
		EndIf
		If !Empty(QD1->QD1_DEPBX)
			If cModoQAD == "C"
				QD1->QD1_DEPBX:= cEmpAnt+cPriFil+QD1->QD1_DEPBX
			Else
				QD1->QD1_DEPBX:= cEmpAnt+QD1->QD1_FMATBX+QD1->QD1_DEPBX
			Endif
		EndIf
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QD2")
DbSetOrder(0)
DbGotop()
While !Eof()
	If cModoQAD == "C"
		cCodigo:= cEmpAnt+cPriFil+QD2->QD2_DEPTO
	Else
		cCodigo:= cEmpAnt+QD2->QD2_FILDEP+QD2->QD2_DEPTO
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QD2->QD2_FILDEP+QD2->QD2_DEPTO)}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QD2->QD2_FILDEP+SubStr(cCodigo,1,nTamCC+4))}) > 0
		If cCodigo <> QD2->QD2_DEPTO
			RecLock("QD2",.F.)
			QD2->QD2_DEPTO:= cCodigo
			MsUnlock()
		Endif
	Endif
	DbSkip()
EndDo

DbSelectArea("QD4")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD4->QD4_FILMAT+QD4->QD4_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD4->QD4_FILMAT+cEmpAnt+QD4->QD4_FILMAT+SubStr(QD4->QD4_MAT,1,6))}) > 0

		RecLock("QD4",.F.)
		QD4->QD4_MAT  := cEmpAnt+QD4->QD4_FILMAT+QD4->QD4_MAT
		If !Empty(QD4->QD4_MATBX)
			QD4->QD4_MATBX:= cEmpAnt+QD4->QD4_FMATBX+QD4->QD4_MATBX
		EndIf
		If !Empty(QD4->QD4_DEPBX)
			If cModoQAD == "C"
				QD4->QD4_DEPBX:= cEmpAnt+cPriFil+QD4->QD4_DEPBX
			Else
				QD4->QD4_DEPBX:= cEmpAnt+QD4->QD4_FMATBX+QD4->QD4_DEPBX
			Endif
	   	EndIf
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QD7")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD7->QD7_FILMAT+QD7->QD7_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD7->QD7_FILMAT+cEmpAnt+QD7->QD7_FILMAT+SubStr(QD7->QD7_MAT,1,6))}) > 0

		RecLock("QD7",.F.)
		QD7->QD7_MAT  := cEmpAnt+QD7->QD7_FILMAT+QD7->QD7_MAT
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QD8")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD8->QD8_FILMAT+QD8->QD8_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD8->QD8_FILMAT+cEmpAnt+QD8->QD8_FILMAT+SubStr(QD8->QD8_MAT,1,6))}) > 0

		cFil2:= cPriFil
		cFil1:= QD8->QD8_FILMAT
		If !Empty(QD8->QD8_FILDEP) .And. QD8->QD8_FILDEP <> cFil2
			cFil2:= QD8->QD8_FILDEP
		EndIf
		RecLock("QD8",.F.)
		QD8->QD8_MAT  := cEmpAnt+cFil1+QD8->QD8_MAT			
		If cModoQAD == "C"
			QD8->QD8_DEPTO:= cEmpAnt+cPriFil+QD8->QD8_DEPTO
		Else
			QD8->QD8_DEPTO:= cEmpAnt+cFil2+QD8->QD8_DEPTO
		Endif
		
		If cModoQAC == "C"
			QD8->QD8_CARGO:= cEmpAnt+cPriFil+QD8->QD8_CARGO
		Else
			QD8->QD8_CARGO:= cEmpAnt+cFil1+QD8->QD8_CARGO
		Endif
		
		MsUnlock()
	Endif
	
	DbSkip()
EndDo

DbSelectArea("QD9")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD9->QD9_FILMAT+QD9->QD9_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QD9->QD9_FILMAT+cEmpAnt+QD9->QD9_FILMAT+SubStr(QD9->QD9_MAT,1,6))}) > 0
	
		RecLock("QD9",.F.)
		QD9->QD9_MAT   := cEmpAnt+QD9->QD9_FILMAT+QD9->QD9_MAT
		QD9->QD9_DESMAT:= cEmpAnt+QD9->QD9_FILDES+QD9->QD9_DESMAT
		MsUnlock()

	Endif
	DbSkip()
EndDo

DbSelectArea("QDA")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDA->QDA_FILF1+QDA->QDA_MAT1)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDA->QDA_FILF1+cEmpAnt+QDA->QDA_FILF1+SubStr(QDA->QDA_MAT1,1,6))}) > 0
	
		RecLock("QDA",.F.)
		If !Empty(QDA->QDA_MAT1)
			QDA->QDA_MAT1:= cEmpAnt+QDA->QDA_FILF1+QDA->QDA_MAT1
		EndIf
		If !Empty(QDA->QDA_MAT2)
			QDA->QDA_MAT2:= cEmpAnt+QDA->QDA_FILF2+QDA->QDA_MAT2
		EndIf
		If !Empty(QDA->QDA_MAT3)
			QDA->QDA_MAT3:= cEmpAnt+QDA->QDA_FILF3+QDA->QDA_MAT3
		EndIf
		MsUnlock()

	Endif
	DbSkip()
EndDo

DbSelectArea("QDD")
DbSetOrder(0)
DbGotop()
While !Eof()
	cFil1:= cPriFil
	If !Empty(QDD->QDD_FILA) .And. QDD->QDD_FILA <> cFil1
		cFil1:= QDD->QDD_FILA
	EndIf
	If cModoQAD == "C"
		cDepto := cEmpAnt+cPriFil+QDD->QDD_DEPTOA
	Else
		cDepto := cEmpAnt+cFil1+QDD->QDD_DEPTOA
	Endif
	If cModoQAC == "C"
		cCargo := cEmpAnt+cPriFil+QDD->QDD_CARGOA
	Else
		cCargo := cEmpAnt+cFil1+QDD->QDD_CARGOA
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDD->QDD_FILA+QDD->QDD_DEPTOA)}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDD->QDD_FILA+SubStr(cDepto,1,nTamCC+4))}) > 0

		RecLock("QDD",.F.)
		QDD->QDD_DEPTOA:= cDepto
		QDD->QDD_CARGOA:= cCargo
		MsUnlock()
		
	Endif
	DbSkip()
EndDo

DbSelectArea("QDE")
DbSetOrder(0)
DbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDE->QDE_FILSOL+QDE->QDE_MATSOL)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDE->QDE_FILSOL+cEmpAnt+QDE->QDE_FILSOL+SubStr(QDE->QDE_MATSOL,1,6))}) > 0
	
		RecLock("QDE",.F.)
		QDE->QDE_MATSOL:= cEmpAnt+QDE->QDE_FILSOL+QDE->QDE_MATSOL
		QDE->QDE_MATDES:= cEmpAnt+QDE->QDE_FILDES+QDE->QDE_MATDES
		MsUnlock()

	Endif
	DbSkip()
EndDo

DbSelectArea("QDF")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDF->QDF_FILANT+QDF->QDF_MATANT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDF->QDF_FILANT+cEmpAnt+QDF->QDF_FILANT+SubStr(QDF->QDF_MATANT,1,6))}) > 0

		RecLock("QDF",.F.)
		QDF->QDF_MATANT:= cEmpAnt+QDF->QDF_FILANT+QDF->QDF_MATANT
		QDF->QDF_MATNOV:= cEmpAnt+QDF->QDF_FILNOV+QDF->QDF_MATNOV
		QDF->QDF_MATOP := cEmpAnt+QDF->QDF_FILOP+QDF->QDF_MATOP
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QDG")
DbSetOrder(0)
DbGotop()
While !Eof()

    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDG->QDG_FILMAT+QDG->QDG_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDG->QDG_FILMAT+cEmpAnt+QDG->QDG_FILMAT+SubStr(QDG->QDG_MAT,1,6))}) > 0
	
		RecLock("QDG",.F.)
		QDG->QDG_MAT  := cEmpAnt+QDG->QDG_FILMAT+QDG->QDG_MAT
		If cModoQAD == "C"
			QDG->QDG_DEPTO:= cEmpAnt+cPriFil+QDG->QDG_DEPTO
		Else
			QDG->QDG_DEPTO:= cEmpAnt+QDG->QDG_FILMAT+QDG->QDG_DEPTO
		Endif
		MsUnlock()
	Endif
	
	DbSkip()
EndDo
	
cFil2:= cPriFil
DbSelectArea("QDH")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDH->QDH_FILMAT+QDH->QDH_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDH->QDH_FILMAT+cEmpAnt+QDH->QDH_FILMAT+SubStr(QDH->QDH_MAT,1,6))}) > 0

		cFil1:= QDH->QDH_FILMAT
		If !Empty(QDH->QDH_FILDEP) .And. QDH->QDH_FILDEP <> cFil2
			cFil2:= QDH->QDH_FILDEP
		EndIf
		RecLock("QDH",.F.)
		QDH->QDH_MAT   := cEmpAnt+cFil1+QDH->QDH_MAT
		If cModoQAD == "C"
			QDH->QDH_DEPTOD:= cEmpAnt+cPriFil+QDH->QDH_DEPTOD
			QDH->QDH_DEPTOE:= cEmpAnt+cPriFil+QDH->QDH_DEPTOE
		Else
			QDH->QDH_DEPTOD:= cEmpAnt+cFil2+QDH->QDH_DEPTOD
			QDH->QDH_DEPTOE:= cEmpAnt+cFil1+QDH->QDH_DEPTOE
		Endif
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QDJ")
DbSetOrder(0)
DbGotop()
While !Eof()
	cFil1:= cPriFil
	If !Empty(QDJ->QDJ_FILMAT) .And. QDJ->QDJ_FILMAT <> cFil1
		cFil1:= QDJ->QDJ_FILMAT
	EndIf

	If cModoQAD == "C"
		cCodigo := cEmpAnt+cPriFil+QDJ->QDJ_DEPTO
	Else
		cCodigo := cEmpAnt+cFil1+QDJ->QDJ_DEPTO
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDJ->QDJ_FILMAT+QDJ->QDJ_DEPTO)}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDJ->QDJ_FILMAT+SubStr(cCodigo,1,nTamCC+4))}) > 0

		RecLock("QDJ",.F.)
		QDJ->QDJ_DEPTO:= cCodigo
		MsUnlock()
	Endif
	
	DbSkip()
EndDo

DbSelectArea("QDL")
DbSetOrder(0)
DbGotop()
While !Eof()
	cFil1:= cPriFil	
	If !Empty(QDL->QDL_FILMAT) .And. QDL->QDL_FILMAT <> cFil1
		cFil1:= QDL->QDL_FILMAT
	EndIf
	If cModoQAD == "C"
		cCodigo := cEmpAnt+cPriFil+QDL->QDL_DEPTO
	Else
		cCodigo:= cEmpAnt+cFil1+QDL->QDL_DEPTO
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDL->QDL_FILMAT+QDL->QDL_DEPTO)}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDL->QDL_FILMAT+SubStr(cCodigo,1,nTamCC+4))}) > 0

		RecLock("QDL",.F.)
		QDL->QDL_DEPTO:= cCodigo
		MsUnlock()
	Endif
	DbSkip()
EndDo

DbSelectArea("QDM")
DbSetOrder(0)
DbGotop()
While !Eof()
	cFil1:= cPriFil
	If !Empty(QDM->QDM_FILMAT) .And. QDM->QDM_FILMAT <> cFil1
		cFil1:= QDM->QDM_FILMAT
	EndIf
	If cModoQAD == "C"
		cDepto := cEmpAnt+cPriFil+QDM->QDM_DEPTO
	Else
		cDepto := cEmpAnt+cFil1+QDM->QDM_DEPTO
	Endif
	If cModoQAC == "C"
		cCargo := cEmpAnt+cPriFil+QDM->QDM_CARGO
	Else
		cCargo := cEmpAnt+cFil1+QDM->QDM_CARGO
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDM->QDM_FILMAT+QDM->QDM_DEPTO)}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(QDM->QDM_FILMAT+SubStr(cDepto,1,nTamCC+4))}) > 0

		RecLock("QDM",.F.)
		QDM->QDM_DEPTO:= cDepto
		QDM->QDM_CARGO:= cCargo
		MsUnlock()
	Endif
	
	DbSkip()
EndDo
	
DbSelectArea("QDN")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDN->QDN_FILMAT+QDN->QDN_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDN->QDN_FILMAT+cEmpAnt+QDN->QDN_FILMAT+SubStr(QDN->QDN_MAT,1,6))}) > 0

		RecLock("QDN",.F.)
		QDN->QDN_MAT  := cEmpAnt+QDN->QDN_FILMAT+QDN->QDN_MAT
		If cModoQAD == "C"
			QDN->QDN_DEPTO:= cEmpAnt+cPriFil+QDN->QDN_DEPTO
		Else
			QDN->QDN_DEPTO:= cEmpAnt+QDN->QDN_FILMAT+QDN->QDN_DEPTO
		Endif
		If cModoQAC == "C"
			QDN->QDN_CARGO:= cEmpAnt+cPriFil+QDN->QDN_CARGO
		Else
			QDN->QDN_CARGO:= cEmpAnt+QDN->QDN_FILMAT+QDN->QDN_CARGO
		Endif
	Endif
	MsUnlock()
	DbSkip()
EndDo
	
DbSelectArea("QDP")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDP->QDP_FILMAT+QDP->QDP_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDP->QDP_FILMAT+cEmpAnt+QDP->QDP_FILMAT+SubStr(QDP->QDP_MAT,1,6))}) > 0

		cFil1:= QDP->QDP_FILMAT
		cFil2:= QDP->QDP_FMATBX
		RecLock("QDP",.F.)
		QDP->QDP_MAT  := cEmpAnt+cFil1+QDP->QDP_MAT
		If cModoQAD == "C"
			QDP->QDP_DEPTO:= cEmpAnt+cPriFil+QDP->QDP_DEPTO
		Else
			QDP->QDP_DEPTO:= cEmpAnt+cFil1+QDP->QDP_DEPTO
		Endif	
		If !Empty(QDP->QDP_MATBX)
			QDP->QDP_MATBX:= cEmpAnt+cFil2+QDP->QDP_MATBX
		EndIf
		If !Empty(QDP->QDP_DEPBX)
			If cModoQAD == "C"
				QDP->QDP_DEPBX:= cEmpAnt+cPriFil+QDP->QDP_DEPBX
			Else
				QDP->QDP_DEPBX:= cEmpAnt+cFil2+QDP->QDP_DEPBX
			Endif
		EndIf
		MsUnlock()
	Endif
	DbSkip()
EndDo
	
DbSelectArea("QDR")
DbSetOrder(0)
DbGotop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDR->QDR_FILRES+QDR->QDR_MATRES)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDR->QDR_FILRES+cEmpAnt+QDR->QDR_FILRES+SubStr(QDR->QDR_MATRES,1,6))}) > 0

		RecLock("QDR",.F.)
		QDR->QDR_MATRES:= cEmpAnt+QDR->QDR_FILRES+QDR->QDR_MATRES
		QDR->QDR_MATDE := cEmpAnt+QDR->QDR_FILDE+QDR->QDR_MATDE
		QDR->QDR_MATPAR:= cEmpAnt+QDR->QDR_FILPAR+QDR->QDR_MATPAR
	
		If cModoQAD == "C"
			QDR->QDR_DEPRES:= cEmpAnt+cPriFil+QDR->QDR_DEPRES
			QDR->QDR_DEPDE := cEmpAnt+cPriFil+QDR->QDR_DEPDE
			QDR->QDR_DEPPAR:= cEmpAnt+cPriFil+QDR->QDR_DEPPAR
		Else
			QDR->QDR_DEPRES:= cEmpAnt+QDR->QDR_FILRES+QDR->QDR_DEPRES
			QDR->QDR_DEPDE := cEmpAnt+QDR->QDR_FILDE+QDR->QDR_DEPDE
			QDR->QDR_DEPPAR:= cEmpAnt+QDR->QDR_FILPAR+QDR->QDR_DEPPAR
		Endif
	
		MsUnlock()
	Endif
	
	DbSkip()
EndDo

If 	lQDZExist
	DbSelectArea("QDZ")
	DbSetOrder(0)
	DbGotop()
	While !Eof()
	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDZ->QDZ_FILMAT+QDZ->QDZ_MAT)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QDZ->QDZ_FILMAT+cEmpAnt+QDZ->QDZ_FILMAT+SubStr(QDZ->QDZ_MAT,1,6))}) > 0
	
			RecLock("QDZ",.F.)
			QDZ->QDZ_MAT:= cEmpAnt+QDZ->QDZ_FILMAT+QDZ->QDZ_MAT
		
			If cModoQAD == "C"
				QDZ->QDZ_DEPTO:= cEmpAnt+cPriFil+QDZ->QDZ_DEPTO
			Else
				QDZ->QDZ_DEPTO:= cEmpAnt+QDZ->QDZ_FILMAT+QDZ->QDZ_DEPTO
			Endif
		
			MsUnlock()
		Endif
		
		DbSkip()
	EndDo
Endif
	
//QIE - INSPECAO DE ENTRADAS
*****************************************************************************

dbSelectArea('QF2')
dbSetorder(1)

For nFil:= 1 to Len(aEmpFil)

	cFilBsc := If(!Empty(xFilial("QF2")),aEmpFil[nFil],xFilial("QF2"))
	QF2->(dbSeek(cFilBsc))
	While !Eof() .And. cFilBsc == QF2->QF2_FILIAL
		cCodigo := QF2->QF2_FILMAT
		If !Empty(cFilBsc) .And. Empty(cCodigo)
			cCodigo := cFilBsc
		Endif
		If Empty(cCodigo)
			For nCnt := 1 to Len(aEmpFil)
				If SRA->(dbSeek(aEmpFil[nCnt]+QF2->QF2_MAT))
					cCodigo := SRA->RA_FILIAL
					Exit
				Endif
			Next
		Endif

	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(cCodigo+QF2->QF2_MAT)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(cCodigo+cEmpAnt+cCodigo+SubStr(QF2->QF2_MAT,1,6))}) > 0
	
			RecLock('QF2',.F.)
			If Empty(QF2->QF2_FILMAT)
				QF2->QF2_FILMAT := cCodigo
			Endif
			QF2->QF2_MAT    := cEmpAnt+QF2->QF2_FILMAT+QF2->QF2_MAT
			QF2->QF2_MATQLD := cEmpAnt+QF2->QF2_FILQLD+QF2->QF2_MATQLD
			MsUnLock()
		Endif
		dbSkip()
	EndDo
	// Caso QF2 compartilhado executa apenas uma vez
	If Empty(xFilial("QF2"))
		Exit
	Endif

Next

dbSelectArea('QF3')
dbSetorder(1)

For nFil:= 1 to Len(aEmpFil)

	cFilBsc := If(!Empty(xFilial("QF3")),aEmpFil[nFil],xFilial("QF3"))
	QF3->(dbSeek(cFilBsc))
	While !Eof() .And. cFilBsc == QF3->QF3_FILIAL
		cCodigo := QF3->QF3_FILMAT
		If !Empty(cFilBsc) .And. Empty(cCodigo)
			cCodigo := cFilBsc
		Endif
		If Empty(cCodigo)
			For nCnt := 1 to Len(aEmpFil)
				If SRA->(dbSeek(aEmpFil[nCnt]+QF3->QF3_MAT))
					cCodigo := SRA->RA_FILIAL
					Exit
				Endif
			Next
		Endif

	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(cCodigo+QF3->QF3_MAT)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(cCodigo+cEmpAnt+cCodigo+SubStr(QF3->QF3_MAT,1,6))}) > 0
	
			RecLock('QF3',.F.)
			If Empty(QF3->QF3_FILMAT)
				QF3->QF3_FILMAT := cCodigo
			Endif
			QF3->QF3_MAT    := cEmpAnt+QF3->QF3_FILMAT+QF3->QF3_MAT
			MsUnLock()
		Endif
		dbSkip()
	EndDo

	// Caso QF3 compartilhado executa apenas uma vez
	If Empty(xFilial("QF3"))
		Exit
	Endif
Next

dbSelectArea('QEK')
dbSetorder(0)
dbGoTop()
While !Eof()
	If !Empty(QEK->QEK_SOLIC)
	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QEK->QEK_FILMAT+QEK->QEK_SOLIC)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QEK->QEK_FILMAT+cEmpAnt+QEK->QEK_FILMAT+SubStr(QEK->QEK_SOLIC,1,6))}) > 0
		
			RecLock('QEK',.F.)
			QEK->QEK_SOLIC  := cEmpAnt+QEK->QEK_FILMAT+AllTrim(QEK->QEK_SOLIC)
			MsUnLock()
		EndIf
	Endif
	dbSkip()
EndDo

dbSelectArea('QER')
dbSetorder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QER->QER_FILMAT+QER->QER_ENSR)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QER->QER_FILMAT+cEmpAnt+QER->QER_FILMAT+SubStr(QER->QER_ENSR,1,6))}) > 0
	
		RecLock('QER',.F.)
		QER->QER_ENSR   := cEmpAnt+QER->QER_FILMAT+AllTrim(QER->QER_ENSR)
		MsUnLock()
	EndIf
	dbSkip()
EndDo

dbSelectArea('QE5')
dbSetorder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QE5->QE5_FILRES+QE5->QE5_RESPON)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QE5->QE5_FILRES+cEmpAnt+QE5->QE5_FILRES+SubStr(QE5->QE5_RESPON,1,6))}) > 0
	
		RecLock('QE5',.F.)
		QE5->QE5_RESPON := cEmpAnt+QE5->QE5_FILRES+AllTrim(QE5->QE5_RESPON)
		MsUnLock()
	Endif
	dbSkip()
EndDo

dbSelectArea('QEP')
dbSetorder(0)
dbGoTop()
While !Eof()
	If !Empty(QEP->QEP_SOLIC)
	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QEP->QEP_FILMAT+QEP->QEP_SOLIC)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QEP->QEP_FILMAT+cEmpAnt+QEP->QEP_FILMAT+SubStr(QEP->QEP_SOLIC,1,6))}) > 0
	
			RecLock('QEP',.F.)
			QEP->QEP_SOLIC  := cEmpAnt+QEP->QEP_FILMAT+AllTrim(QEP->QEP_SOLIC)
			MsUnLock()
		Endif
	EndIf
	dbSkip()
EndDo


//QIP - INSPECAO DE PROCESSOS
*****************************************************************************

//������������������������������������������������������������������Ŀ
//� Atualiza o campo QP5_RESPON - Conforme nova estrutura utilizada  �
//� no arquivo QAA          										 �
//��������������������������������������������������������������������
dbSelectArea("QP5")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QP5->QP5_FILMAT+QP5->QP5_RESPON)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QP5->QP5_FILMAT+cEmpAnt+QP5->QP5_FILMAT+SubStr(QP5->QP5_RESPON,1,6))}) > 0
	
		RecLock('QP5',.F.)
		QP5->QP5_RESPON := cEmpAnt+QP5->QP5_FILMAT+AllTrim(QP5->QP5_RESPON)
		MsUnlock()
	EndIf
	QP5->(dbSkip())
EndDo

dbSelectArea("QPR")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QPR->QPR_FILMAT+QPR->QPR_ENSR)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QPR->QPR_FILMAT+cEmpAnt+QPR->QPR_FILMAT+SubStr(QPR->QPR_ENSR,1,6))}) > 0

		RecLock("QPR",.F.)
		QPR->QPR_ENSR := cEmpAnt+QPR->QPR_FILMAT+AllTrim(QPR->QPR_ENSR)
		MsUnlock()
	EndIf
	QPR->(dbSkip())
EndDo


//QMT - METROLOGIA
*****************************************************************************
//�������������������������������������Ŀ
//�Atualiza arquivo de Familias (QM1)	�
//���������������������������������������
dbSelectArea("QM1")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM1->QM1_FILRES+QM1->QM1_RDISTR)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM1->QM1_FILRES+cEmpAnt+QM1->QM1_FILRES+SubStr(QM1->QM1_RDISTR,1,6))}) > 0

		If cModoQAD == "C"
			cDepto  := cEmpAnt+cPriFil+Alltrim(QM1->QM1_DISTR)
		Else
			cDepto  := cEmpAnt+QM1->QM1_FILRES+Alltrim(QM1->QM1_DISTR)
		Endif
		
		RecLock("QM1",.F.)
		QM1->QM1_RDISTR := cEmpAnt+QM1->QM1_FILRES+Alltrim(QM1->QM1_RDISTR)
		QM1->QM1_DISTR:= cDepto
		MsUnLock()
	Endif
	dbSkip()
Enddo

dbSelectArea("QM2")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM2->QM2_FILRES+QM2->QM2_RESP)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM2->QM2_FILRES+cEmpAnt+QM2->QM2_FILRES+SubStr(QM2->QM2_RESP,1,6))}) > 0

		If cModoQAD == "C"
			cDepto  := cEmpAnt+cPriFil+Alltrim(QM2->QM2_DEPTO)
		Else
			cDepto  := cEmpAnt+QM2->QM2_FILRES+Alltrim(QM2->QM2_DEPTO)
		Endif
		
		RecLock("QM2",.F.)
		QM2->QM2_RESP := cEmpAnt+QM2->QM2_FILRES+Alltrim(QM2->QM2_RESP)
		QM2->QM2_DEPTO:= cDepto
		MsUnLock()
	Endif
	QM2->(dbSkip())
Enddo

//�������������������������������������Ŀ
//�Atualiza arquivo de Calibracao (QM6)	�
//���������������������������������������
dbSelectArea("QM6")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM6->QM6_FILRES+QM6->QM6_RESP)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM6->QM6_FILRES+cEmpAnt+QM6->QM6_FILRES+SubStr(QM6->QM6_RESP,1,6))}) > 0

		RecLock("QM6",.F.)
		QM6->QM6_RESP := cEmpAnt+QM6->QM6_FILRES+Alltrim(QM6->QM6_RESP)
		MsUnLock()
	Endif
	QM6->(dbSkip())
Enddo

//�������������������������������������Ŀ
//�Atualiza arquivo de R&R (QM5)		�
//���������������������������������������
dbSelectArea("QM5")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM5->QM5_FILRES+QM5->QM5_ENSR)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QM5->QM5_FILRES+cEmpAnt+QM5->QM5_FILRES+SubStr(QM5->QM5_ENSR,1,6))}) > 0

		RecLock("QM5",.F.)
		QM5->QM5_ENSR	:= cEmpAnt+QM5->QM5_FILRES+Alltrim(QM5->QM5_ENSR)
		MsUnLock()
	Endif
	QM5->(dbSkip())
Enddo

//�������������������������������������Ŀ
//�Atualiza arquivo de Manutencoes(QME)	�
//���������������������������������������
dbSelectArea("QME")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QME->QME_FILRES+QME->QME_RESP)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QME->QME_FILRES+cEmpAnt+QME->QME_FILRES+SubStr(QME->QME_RESP,1,6))}) > 0

		RecLock("QME",.F.)
		QME->QME_RESP	:= cEmpAnt+QME->QME_FILRES+Alltrim(QME->QME_RESP)
		MsUnLock()
	Endif
	QME->(dbSkip())
Enddo

//���������������������������������������Ŀ
//�Atualiza arquivo de Movimentacoes(QML) �
//�����������������������������������������

dbSelectArea("QML")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QML->QML_FILREL+QML->QML_RESCOL)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QML->QML_FILREL+cEmpAnt+QML->QML_FILREL+SubStr(QML->QML_RESCOL,1,6))}) > 0
	
		If cModoQAD == "C"
			cDepto  := cEmpAnt+cPriFil+Alltrim(QML->QML_DEPTO)
		Else
			cDepto  := cEmpAnt+QML->QML_FILRET+Alltrim(QML->QML_DEPTO)
		Endif
		
		RecLock("QML",.F.)
		QML->QML_RESCOL := cEmpAnt+QML->QML_FILREL+Alltrim(QML->QML_RESCOL)
		QML->QML_RESRET	:= cEmpAnt+QML->QML_FILRET+Alltrim(QML->QML_RESRET)
		QML->QML_DEPTO  := cDepto
		MsUnlock()
	Endif
	QML->(dbSkip())
Enddo

//�����������������������������������������Ŀ
//�Atualiza arquivo de Cadastro de MSA(QMU) �
//�������������������������������������������
dbSelectArea("QMU")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QMU->QMU_FILRES+QMU->QMU_RESP)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QMU->QMU_FILRES+cEmpAnt+QMU->QMU_FILRES+SubStr(QMU->QMU_RESP,1,6))}) > 0

		RecLock("QMU",.F.)
		QMU->QMU_RESP	:= cEmpAnt+QMU->QMU_FILRES+Alltrim(QMU->QMU_RESP)
		MsUnLock()
	Endif
	QMU->(dbSkip())
Enddo

dbSelectArea("QM9")
dbSetOrder(0)
dbGoTop()
While !Eof()

	If cModoQAD == "C"
		cDepto  := cEmpAnt+cPriFil+QM9->QM9_DEPTO
	Else
		If Empty(xFilial("QM9"))
			cDepto  := cEmpAnt+cPriFil+QM9->QM9_DEPTO
		Else
			cDepto  := cEmpAnt+QM9->QM9_FILIAL+QM9->QM9_DEPTO
		Endif
	Endif

    If aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(SubStr(QM9->QM9_DEPTO,3))}) == 0 .And. ;
		aScan(aDeptos,{|x| RTrim(x[2]+x[1]) == RTrim(SubStr(cDepto,1,nTamCC+4))}) > 0

		RecLock("QM9",.F.)
		QM9->QM9_DEPTO  := cDepto
		MsUnLock()
	Endif
	QM9->(dbSkip())
Enddo

//PPAP
*****************************************************************************

//�������������������������Ŀ
//� Cronograma QKG / QKP    �
//���������������������������
DbSelectArea("QKG")
DbSetOrder(0)
DbGoTop()
Do While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QKG->QKG_FILRES+QKG->QKG_RESP)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QKG->QKG_FILRES+cEmpAnt+QKG->QKG_FILRES+SubStr(QKG->QKG_RESP,1,6))}) > 0

		RecLock("QKG",.F.)
		QKG->QKG_RESP	:= cEmpAnt+QKG->QKG_FILRES+Alltrim(QKG->QKG_RESP)
		MsUnlock()
	Endif
	QKG->(DbSkip())
Enddo

DbSelectArea("QKP")
DbSetOrder(0)
DbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QKP->QKP_FILMAT+QKP->QKP_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QKP->QKP_FILMAT+cEmpAnt+QKP->QKP_FILMAT+SubStr(QKP->QKP_MAT,1,6))}) > 0

		RecLock("QKP",.F.)
		QKP->QKP_MAT	:= cEmpAnt+QKP->QKP_FILMAT+Alltrim(QKP->QKP_MAT)
		MsUnlock()
	Endif
	QKP->(DbSkip())
Enddo

//QNC - Controle de Nao-Conformidade
*****************************************************************************

dbSelectArea("QIF")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QIF->QIF_FILMAT+QIF->QIF_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QIF->QIF_FILMAT+cEmpAnt+QIF->QIF_FILMAT+SubStr(QIF->QIF_MAT,1,6))}) > 0

		RecLock("QIF",.T.)
		QIF->QIF_MAT :=  cEmpAnt+QIF->QIF_FILMAT+Alltrim(QIF->QIF_MAT)
		MsUnlock()
	Endif
	QIF->(DbSkip())
Enddo

dbSelectArea("QI2")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI2->QI2_FILRES+QI2->QI2_MATRES)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI2->QI2_FILRES+cEmpAnt+QI2->QI2_FILRES+SubStr(QI2->QI2_MATRES,1,6))}) > 0

		If cModoQAD == "C"
			cDepto  := cEmpAnt+cPriFil+Alltrim(QI2->QI2_MATDEP)
			cDeptoO := cEmpAnt+cPriFil+Alltrim(QI2->QI2_ORIDEP)
			cDeptoD := cEmpAnt+cPriFil+Alltrim(QI2->QI2_DESDEP)
		Else
			cDepto  := cEmpAnt+QI2->QI2_FILMAT+Alltrim(QI2->QI2_MATDEP)
			cDeptoO := cEmpAnt+QI2->QI2_FILORI+Alltrim(QI2->QI2_ORIDEP)
			cDeptoD := cEmpAnt+QI2->QI2_FILDEP+Alltrim(QI2->QI2_DESDEP)
		Endif
	
		RecLock("QI2",.F.)
		QI2->QI2_ORIDEP := cDeptoO
		QI2->QI2_DESDEP := cDeptoD
		QI2->QI2_MATRES := cEmpAnt+QI2->QI2_FILRES+Alltrim(QI2->QI2_MATRES)
		QI2->QI2_MATDEP := cDepto
		QI2->QI2_MAT    := cEmpAnt+QI2->QI2_FILMAT+Alltrim(QI2->QI2_MAT )
		MsUnLock()
	Endif
	dbSkip()
EndDo

//����������������������������������������������������������������Ŀ
//� Atualiza os campos criados para a integracao do GPE X Celerina �
//� Plano de Acao                                                  �
//������������������������������������������������������������������
dbSelectArea("QI3")
dbSetOrder(1)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI3->QI3_FILMAT+QI3->QI3_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI3->QI3_FILMAT+cEmpAnt+QI3->QI3_FILMAT+SubStr(QI3->QI3_MAT,1,6))}) > 0

		RecLock("QI3",.F.)
		QI3->QI3_MAT := cEmpAnt+QI3->QI3_FILMAT+Alltrim(QI3->QI3_MAT)
		MsUnLock()
	Endif
	dbSkip()
EndDo

//����������������������������������������������������������������Ŀ
//� Atualiza os campos criados para a integracao do GPE X Celerina �
//� Equipe - Plano de Acao                                         �
//������������������������������������������������������������������
dbSelectArea("QI4")
dbSetOrder(1)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI4->QI4_FILMAT+QI4->QI4_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI4->QI4_FILMAT+cEmpAnt+QI4->QI4_FILMAT+SubStr(QI4->QI4_MAT,1,6))}) > 0

		RecLock("QI4",.F.)
		QI4->QI4_MAT := cEmpAnt+QI4->QI4_FILMAT+Alltrim(QI4->QI4_MAT)
		MsUnLock()
	Endif
	dbSkip()
EndDo

dbSelectArea("QI5")
dbSetOrder(1)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI5->QI5_FILMAT+QI5->QI5_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QI5->QI5_FILMAT+cEmpAnt+QI5->QI5_FILMAT+SubStr(QI5->QI5_MAT,1,6))}) > 0

		RecLock("QI5",.F.)
		QI5->QI5_MAT := cEmpAnt+QI5->QI5_FILMAT+Alltrim(QI5->QI5_MAT)
		MsUnLock()
	Endif
	dbSkip()
EndDo

//QAD - Controle de Auditoria
*****************************************************************************

//����������������������������������������������Ŀ
//�Atualiza arquivo QU1 - AUDITORES              �
//������������������������������������������������
dbSelectArea("QU1")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QU1->QU1_FILIAL+QU1->QU1_CODAUD)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QU1->QU1_FILIAL+cEmpAnt+QU1->QU1_FILIAL+SubStr(QU1->QU1_CODAUD,1,6))}) > 0

		RecLock("QU1",.F.)
		QU1->QU1_CODAUD := cEmpAnt+QU1->QU1_FILIAL+Alltrim(QU1->QU1_CODAUD)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//����������������������������������������������Ŀ
//�Atualiza arquivo QUA - AGENDA AUDITORIAS      �
//������������������������������������������������
dbSelectArea("QUA")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUA->QUA_FILMAT+QUA->QUA_MAT)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUA->QUA_FILMAT+cEmpAnt+QUA->QUA_FILMAT+SubStr(QUA->QUA_MAT,1,6))}) > 0

		RecLock("QUA",.F.)
		QUA->QUA_MAT := cEmpAnt+QUA->QUA_FILMAT+Alltrim(QUA->QUA_MAT)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//����������������������������������������������Ŀ
//�Atualiza arquivo QUB - AUDITORIAS             �
//������������������������������������������������
dbSelectArea("QUB")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUB->QUB_FILMAT+QUB->QUB_AUDLID)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUB->QUB_FILMAT+cEmpAnt+QUB->QUB_FILMAT+SubStr(QUB->QUB_AUDLID,1,6))}) > 0

		RecLock("QUB",.F.)
		QUB->QUB_AUDLID := cEmpAnt+QUB->QUB_FILMAT+Alltrim(QUB->QUB_AUDLID)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//����������������������������������������������Ŀ
//�Atualiza arquivo QUC - AUDITORIAS E AUDITORES �
//������������������������������������������������
dbSelectArea("QUC")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUC->QUC_FILMAT+QUC->QUC_CODAUD)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUC->QUC_FILMAT+cEmpAnt+QUC->QUC_FILMAT+SubStr(QUC->QUC_CODAUD,1,6))}) > 0

		RecLock("QUC",.F.)
		QUC->QUC_CODAUD := cEmpAnt+QUC->QUC_FILMAT+Alltrim(QUC->QUC_CODAUD)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//����������������������������������������������Ŀ
//�Atualiza arquivo QUD - ITENS AUDITADOS        �
//������������������������������������������������
dbSelectArea("QUD")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUD->QUD_FILMAT+QUD->QUD_CODAUD)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUD->QUD_FILMAT+cEmpAnt+QUD->QUD_FILMAT+SubStr(QUD->QUD_CODAUD,1,6))}) > 0

		RecLock("QUD",.F.)
		QUD->QUD_CODAUD := cEmpAnt+QUD->QUD_FILMAT+Alltrim(QUD->QUD_CODAUD)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//�����������������������������������������Ŀ
//�Atualiza arquivo QUH - AREAS AUDITADAS   �
//�������������������������������������������
dbSelectArea("QUH")
dbSetOrder(0)
dbGoTop()
While !Eof()
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUH->QUH_FILMAT+QUH->QUH_CODAUD)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUH->QUH_FILMAT+cEmpAnt+QUH->QUH_FILMAT+SubStr(QUH->QUH_CODAUD,1,6))}) > 0

		RecLock("QUH",.F.)
		QUH->QUH_CODAUD := cEmpAnt+QUH->QUH_FILMAT+Alltrim(QUH->QUH_CODAUD)
		MsUnLock()
	Endif
	dbSkip()
Enddo

dbSelectArea("QUH")
dbSetOrder(1)
For nFil:= 1 to Len(aEmpFil)
	cFilBsc := If(!Empty(xFilial("QUH")),aEmpFil[nFil],xFilial("QUH"))
	QUH->(dbSeek(cFilBsc))
	While !Eof() .And. cFilBsc == QUH->QUH_FILIAL

		If cModoQAD == "C"
			cCodigo:= cEmpAnt+cPriFil+Alltrim(QUH->QUH_CCUSTO)
			cFil1 := cPriFil
		Else
			cCodigo:= cEmpAnt+aEmpFil[nFil]+Alltrim(QUH->QUH_CCUSTO)
			cFil1 := aEmpFil[nFil]
		Endif
		
	    If aScan(aDeptos,{|x|x[2]+x[1] == cFil1+QUH->QUH_CCUSTO}) == 0 .And. ;
			aScan(aDeptos,{|x|x[2]+x[1] == cFil1+SubStr(cCodigo,1,nTamCC+4)}) > 0
			If cCodigo <> QUH->QUH_CCUSTO
				RecLock("QUH",.F.)
				QUH->QUH_CCUSTO := cCodigo
				MsUnLock()
			Endif
		Endif
		dbSkip()
	EndDo

	// Caso QUH compartilhado executa apenas uma vez
	If Empty(xFilial("QUH"))
		Exit
	Endif
Next

//�����������������������������������������Ŀ
//�Atualiza arquivo QUM - AUDITADA X AGENDA �
//�������������������������������������������
If lQUMExist
	dbSelectArea("QUM")
	dbSetOrder(0)
	dbGoTop()
	While !Eof()
	    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUM->QUM_FILMAT+QUM->QUM_CODAUD)}) == 0 .And. ;
			aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUM->QUM_FILMAT+cEmpAnt+QUM->QUM_FILMAT+SubStr(QUM->QUM_CODAUD,1,6))}) > 0
	
			RecLock("QUM",.F.)
			QUM->QUM_CODAUD := cEmpAnt+QUM->QUM_FILMAT+Alltrim(QUM->QUM_CODAUD)
			MsUnLock()
		Endif
		dbSkip()
	Enddo

	dbSelectArea("QUM")
	dbSetOrder(1)
	For nFil:= 1 to Len(aEmpFil)
		cFilBsc := If(!Empty(xFilial("QUM")),aEmpFil[nFil],xFilial("QUM"))
		QUM->(dbSeek(cFilBsc))
		While !Eof() .And. cFilBsc == QUM->QUM_FILIAL
	
			If cModoQAD == "C"
				cCodigo:= cEmpAnt+cPriFil+Alltrim(QUM->QUM_CCUSTO)
				cFil1 := cPriFil
			Else
				cCodigo:= cEmpAnt+aEmpFil[nFil]+Alltrim(QUM->QUM_CCUSTO)
				cFil1 := aEmpFil[nFil]
			Endif
			
		    If aScan(aDeptos,{|x|x[2]+x[1] == cFil1+QUM->QUM_CCUSTO}) == 0 .And. ;
				aScan(aDeptos,{|x|x[2]+x[1] == cFil1+SubStr(cCodigo,1,nTamCC+4)}) > 0
				If cCodigo <> QUM->QUM_CCUSTO
					RecLock("QUM",.F.)
					QUM->QUM_CCUSTO := cCodigo
					MsUnLock()
				Endif
			Endif
			dbSkip()
		EndDo
	
		// Caso QUM compartilhado executa apenas uma vez
		If Empty(xFilial("QUM"))
			Exit
		Endif
	Next
Endif

//�����������������������������������������Ŀ
//�Atualiza arquivo QUN - LOG TRANSF. AUDIT.�
//�������������������������������������������
dbSelectArea("QUN")
dbSetOrder(0)
dbGoTop()
While !Eof()
	// Usuario Responsavel
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILRES+QUN->QUN_MATRES)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILRES+cEmpAnt+QUN->QUN_FILRES+SubStr(QUN->QUN_MATRES,1,6))}) > 0

		RecLock("QUN",.F.)
		QUN->QUN_MATRES := cEmpAnt+QUN->QUN_FILRES+Alltrim(QUN->QUN_MATRES)
		MsUnLock()
	Endif

	// Usuario De
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILDE+QUN->QUN_MATDE)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILDE+cEmpAnt+QUN->QUN_FILDE+SubStr(QUN->QUN_MATDE,1,6))}) > 0

		RecLock("QUN",.F.)
		QUN->QUN_MATDE := cEmpAnt+QUN->QUN_FILDE+Alltrim(QUN->QUN_MATDE)
		MsUnLock()
	Endif

	// Usuario Para
    If aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILPAR+QUN->QUN_MATPAR)}) == 0 .And. ;
		aScan(aUsuarios,{|x| RTrim(x[2]+x[1]) == RTrim(QUN->QUN_FILPAR+cEmpAnt+QUN->QUN_FILPAR+SubStr(QUN->QUN_MATPAR,1,6))}) > 0

		RecLock("QUN",.F.)
		QUN->QUN_MATPAR := cEmpAnt+QUN->QUN_FILPAR+Alltrim(QUN->QUN_MATPAR)
		MsUnLock()
	Endif
	dbSkip()
Enddo

//�����������������������Ŀ
//�Atualiza arquivo RDZ   �
//�������������������������
IF lTMKPMS
	dbSelectArea("RDZ")
	dbSetOrder(0)
	dbGoTop()
	While !Eof()	
		If RDZ->RDZ_ENTIDA == "QAA"
			RecLock("RDZ",.F.)
			RDZ->RDZ_CODENT := cEmpAnt+RDZ->RDZ_CODENT
			MsUnLock()
		Endif	
		dbSkip()
	Enddo
Endif	

//End Transaction

// Final("Finalizacao da atualizacao") trocado pelo comando abaixo ... 
MsgAlert("Finalizacao da atualizacao")
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	  � QXPOSFIL   � Autor � Eduardo de Souza   � Data � 21/06/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao  � Retorna a primeira filial da empresa logada               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	  � QXPOSFIL()                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso		  � QUALITY                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function QXPOSFIL(cEmpCod)
Local nPosSM0 := 0                

Local nFilAtu := 0

Default cEmpCod:= cEmpAnt

DbSelectArea("SM0")
DbSetOrder(1)
nPosSM0:= Recno()

If SM0->(DbSeek(cEmpCod))
	nFilAtu := SM0->M0_CODFIL
Endif
SM0->(DbGoto(nPosSM0))

Return nFilAtu

