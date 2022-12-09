#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINR650  �Autor  �Anderson Zanni      � Data �  07/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa arquivo de Retorno Cnab e cria dois novos arquivos ���
���          �1 para t�tulos do SIga e outros para os demais              ���
���          �E chama o FINR650 padr�o ap�s o processamento               ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 - Espec�fico Certisign                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFINR650
Private cPerg		:= "FIN650" 

If Pergunte(cPerg,.T.)  
	//������������������������������������������������������������������������Ŀ
	//�Chama pr�-processamento do Arquivo TXT                                  �
	//��������������������������������������������������������������������������
   Processa({|lEnd| U_CFiltCnab(mv_par03,mv_par04,mv_par05,mv_par06, 1, mv_par01, mv_par02)})  // Chamada com regua

	//������������������������������������������������������������������������Ŀ
	//�Chama Relat�rio Padr�o Microsiga                                        �
	//��������������������������������������������������������������������������
   FINR650()
EndIf
                        
Return                


/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function CFiltCnab(_cBco, _cAge, _cCC, _cSub, _nTipo, _cArq, _cCfg)
Local lPosNum  :=.f.,lPosData:=.f.,lPosMot  :=.f.
Local lPosDesp :=.f.,lPosDesc:=.f.,lPosAbat :=.f.
Local lPosPrin :=.f.,lPosJuro:=.f.,lPosMult :=.f.
Local lPosOcor :=.f.,lPosTipo:=.f.,lPosOutrD:= .F.
Local lPosCC   :=.f.,lPosDtCC:=.f.,lPosNsNum:=.f.

//��������������������������������������������������������������Ŀ
//� Busca tamanho do detalhe na configura��o do banco            �
//����������������������������������������������������������������
dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+_cBco+_cAge+_cCC+_cSub)
   nTamDet:= Iif(Empty (SEE->EE_NRBYTES), 400, SEE->EE_NRBYTES)
	ntamDet+= 2  // Ajusta tamanho do detalhe para leitura do CR (fim de linha)
Else
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOBCOCAD")
	Return .F.
Endif

cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

dbSelectArea( "SX5" )
If !SX5->( dbSeek( cFilial + cTabela ) )
	Help(" ",1,"PAR150")
   Return .F.
Endif

IF _nTipo == 1
	//������������������������������Ŀ
	//� Abre arquivo de configura��o �
	//��������������������������������
	cArqConf:=_cCfg
	IF !FILE(cArqConf)
		Set Device To Screen
		Set Printer To
		Help(" ",1,"NOARQPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	End

	//����������������������������Ŀ
	//� L� arquivo de configura��o �
	//������������������������������
	nLidos :=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)

	While nLidos <= nTamArq

		//�������������������������������������������Ŀ
		//� Verifica o tipo de qual registro foi lido �
		//���������������������������������������������
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)

		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
	
		Exit
	EndDo

	//�������������������������������Ŀ
	//� fecha arquivo de configuracao �
	//���������������������������������
	Fclose(nHdlConf)
Endif


//���������������������������������Ŀ
//� Abre arquivo enviado pelo banco �
//�����������������������������������
cArqEnt:=_cArq
IF !FILE(cArqEnt)
	Set Device To Screen
	Set Printer To
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	//nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

_cArqTMP := CriaTrab(Nil, .F.)
aStru := {{'LINHA','C', nTamDet, 0}}
dbCreate(_cArqTMP,aStru)
dbUseArea(.T.,,_cArqTMP,'TMP_CNAB',.F.,.F.)
Append From &cArqEnt SDF

DbSelectArea('TMP_CNAB')
DbGoTop()

cArqSai := StrTran(cArqEnt, '.RET','.OUT')
nHdl1 := FCreate(cArqEnt)
nHdl2 := FCreate(cArqSai) 
FSeek(nHdl1,0,2)
FWrite(nHdl1, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)
FSeek(nHdl2,0,2)
FWrite(nHdl2, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)
DbSkip()

While !EoF()
	If _nTipo == 1
	   cNumTit :=Substr(TMP_CNAB->LINHA,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
	EndIf   

   DbSelectARea('SE1')
   DbSetOrder(1)
   _lDel := !DbSeek(xFilial()+Left(cNumTit,10))
      
   DbSelectArea('TMP_CNAB')
   If RecNo() == RecCount()
      FSeek(nHdl1,0,2)
		FWrite(nHdl1, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)
      FSeek(nHdl2,0,2)
		FWrite(nHdl2, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)		
		Exit
   Else
	   If _lDel
	      //DbDelete()
         FSeek(nHdl2,0,2)
	      FWrite(nHdl2, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)
	   Else
         FSeek(nHdl1,0,2)
	      FWrite(nHdl1, Left(TMP_CNAB->LINHA,nTamDet-2)+Chr(13)+Chr(10), nTamDet)
	   EndIf
	 EndIf  
   DbSkip()
EndDo
FClose(nHdl1)
FClose(nHdl2)

Return