#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �  MFAT06  � Autor � Rene Lopes 	    � Data �  25/03/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorios Cadastro de Funcionarios     					���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertSign                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelFun

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Relatorio Cadastro Funcionarios"
Local cPict          	:= ""
Local titulo       	 	:= "Relatorio Cadastro Funcionarios"                  
Local nLin         		:= 80
Local Cabec1       		:= "Filial  Matricula  Cto_Custo  Nome  CPF  PIS  RG   UF_RG  CartProfis  SerieCart  UF_CartProf  Tit_Eleit  Zona_Sec  Telefone  Dt_Nasc  Dt_Admissao  Dt_Demissao  Ven_Exper_1  Vc_Exp_2Per  Bco_Ag_D_Sal  Cta_Dep_Sal  Sit_Folha Hrs_Mensais  Hrs_Semanais   Cod_Chapa  Turno_Trab  Cod_Funcao  Salario  Tp_Cont_Trab  End_E_Email  Cargo  LT  Nome_complet  DtEmiSCTP  Dt_Emis_RG  Orgao_expedR  Org_Emis_RG DESC_FUNCAO C_B_O_2002" 
Local Cabec2			:= ""   
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RFUNC" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RFUNC" 
Private cString 		:= ""
Private cPerg			:= "RFUNC"

//AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Fun�"o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/05/09   ���
�������������������������������������������������������������������������͹��
���Descri�"o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//dbSelectArea(cString)
//dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())  

Public cSituacao   := mv_par08							//  Situacao Funcionario

Public cSitQuery := " "
	
	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nReg        
    		cSitQuery :=   cSitQuery   
    		
_cQuery := " Select 																									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_FILIAL												As Filial,										"+Chr(13)+Chr(10)
_cQuery	+= " SRA.RA_MAT					                                As Matricula,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CC													As Cto_Custo,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_NOME												As Nome,										"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CIC													As CPF,											"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_PIS													As PIS,											"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_RG													As RG,											"+Chr(13)+Chr(10)
_cQuery	+= " SRA.RA_NUMCP												As CartProfis,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_SERCP												As SerieCart,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_UFCP												As UF_CartProf,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_TITULOE												As Tit_Eleit,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_ZONASEC 											As Zona_Sec,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_TELEFON 											As Telefone,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_NASC												As Dt_Nasc,										"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_ADMISSA												As Dt_Admissao,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_DEMISSA												As Dt_Demissao,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_VCTOEXP												As Ven_Exper_1,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_VCTEXP2												As Vc_Exp_2Per,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_BCDEPSA												As Bco_Ag_D_Sal,								"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CTDEPSA												As Cta_Dep_Sal,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_SITFOLH												As Sit_Folha,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_HRSMES												As Hrs_Mensais,								"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_HRSEMAN												As Hrs_Semanais,								"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CHAPA												As Cod_Chapa,									"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_TNOTRAB												As Turno_Trab,									"+Chr(13)+Chr(10)
_cQuery += " SRJ.RJ_FUNCAO												As Cod_Funcao,                                 "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_SALARIO												As Salario,		                                "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_TPCONTR												As Tp_Cont_Trab,                                "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_EMAIL												As End_E_Mail,                                 "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CARGO												As Cargo,		                                "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_DTCPEXP												As DtEmiSCTP, 	                                "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_DTRGEXP												As Dt_Emis_RG, 	                                "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CODLT												As LT,    			                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_NOMECMP												As Nome_complet,	                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_RGEXP												As Orgao_expedR,	                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_RGUF												As UF_RG,	    	                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_ORGEMRG												As Org_Emis_RG,    	                            "+Chr(13)+Chr(10)
_cQuery += " SRJ.RJ_DESC												As DESC_FUNCAO,    	                            "+Chr(13)+Chr(10)
_cQuery += " SRJ.RJ_CODCBO												As C_B_O_2002,    	                            "+Chr(13)+Chr(10)
_cQuery += " CTT.CTT_CUSTO												As Cod_Depto,		                            "+Chr(13)+Chr(10)
_cQuery += " CTT.CTT_DESC01												As Nome_Depto,   	                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_SEXO												As Sexo			 	                            "+Chr(13)+Chr(10)
_cQuery += " From                                                                                                       "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SRA") + " SRA,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("SRJ") + " SRJ,                                                                                   "+Chr(13)+Chr(10)
_cQuery += RetSQLName("CTT") + " CTT	                                                                                "+Chr(13)+Chr(10)
_cQuery += " Where                                                                                                      "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_ADMISSA 	>= 	'" + DtoS(mv_par01) + "' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_ADMISSA  	<= 	'" + DtoS(mv_par02) + "' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_MAT     	>= 	'" + Alltrim(mv_par03) + "' AND 													"+Chr(13)+Chr(10)
_cQuery += " SRA.RA_MAT  		<= 	'" + Alltrim(mv_par04)+ "' 	AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CODFUNC     =  	SRJ.RJ_FUNCAO				AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_CC			=	CTT.CTT_CUSTO	 			AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_FILIAL	 	>= 	'"+ Alltrim(mv_par05) + "'	AND 						                            "+Chr(13)+Chr(10) 	// SA1 -> COMPARTILHADO
_cQuery += " SRA.RA_FILIAL	 	<= 	'"+ Alltrim(mv_par06) + "'	AND 						                            "+Chr(13)+Chr(10)
_cQuery += " SRA.RA_SITFOLH	 	IN	("+ cSitQuery + ")			AND             	                                   "+Chr(13)+Chr(10)
_cQuery += " SRA.D_E_L_E_T_ 	=	' '							AND                                                     "+Chr(13)+Chr(10)
_cQuery += " SRJ.D_E_L_E_T_ 	= 	' '									                                                 "+Chr(13)+Chr(10)
_cQuery += " Order By SRA.RA_MAT, SRA.RA_NOME"


If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRC", .F., .T.)



_cDataBase 	:= dDataBase 
_cTime 		:= Time()
_aCabec 	:= {}
_aDados		:= {}


//AAdd(_aDados, {"Data de Emiss�o: ",_cDataBase,,"Horario:",_cTime})		
//AAdd(_aDados, {})
AAdd(_aDados, {"Filial","Matricula","Cto_Custo","Nome","CPF","PIS","RG","UF_RG","CartProfis","SerieCart","UF_CartProf","Dt. Emis. Cart","Tit_Eleit","Zona_Sec","Telefone", "Dt_Nasc", "Dt_Admissao","Dt_Demissao","Ven_Exper_1","Vc_Exp_2Per","Bco_Ag_D_Sal","Cta_Dep_Sal","Sit_Folha", "Hrs_Mensais","Hrs_Semanais","Cod_Chapa","Turno_Trab","Cod_Funcao","Salario","Tp_Cont_Trab","End_E_Email","Cargo","LT","Nome_complet","Dt_Emis_RG","Orgao_expedR","DESC_FUNCAO","C_B_O_2002","Cod_Depto","Nome_Depto","Sexo"})
AAdd(_aDados, {})

DbSelectArea("TRC") 
TRC->(dbGoTop())
While !TRC->(Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
         //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif  
 
   //"MES       CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND    NOME             VEND2     NF/ITEM    BPAG    AR            VALOR        EMISSAO "
   
   //"MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "

   // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
   //          10        20        30        40       50         60        70        80       90        100        110       120      130        140       150       160       170       180       190       200       210       220
/*
   @ nLin, 000 PSAY Alltrim(TRC->Filial)
   @ nLin, 011 PSAY TRC->Matricula
   @ nLin, 025 PSAY TRC->Cto_Custo
   @ nLin, 044 PSAY TRC->Nome
   @ nLin, 069 PSAY TRC->CPF            
   @ nLin, 087 PSAY TRC->PIS
   @ nLin, 098 PSAY TRC->RG 
   @ nLin, 098 PSAY TRC->UF_RG    
   @ nLin, 119 PSAY Alltrim(TRC->CartProfis)
   @ nLin, 119 PSAY TRC->SerieCart 
   @ nLin, 119 PSAY TRC->UF_CartProf
   @ nLin, 215 PSAY STOD(TRC->DtEmiSCTP)
   @ nLin, 125 PSAY Transform(TRC->Tit_Eleit, '@R 9999999999-99')
   @ nLin, 125 PSAY Alltrim(TRC->Zona_Sec)
   //@ nLin, 133 PSAY Posicione("SA3", 1, xFilial("SA3") + TRC->Cod_Vend1, "A3_NOME")
   @ nLin, 133 PSAY TRC->Telefone
   @ nLin, 151 PSAY STOD(TRC->Dt_Nasc)
   @ nLin, 161 PSAY STOD(TRC->Dt_Admissao)
   @ nLin, 169 PSAY STOD(TRC->Dt_Demissao)
   @ nLin, 180 PSAY STOD(TRC->Ven_Exper_1)
   @ nLin, 188 PSAY STOD(TRC->Vc_Exp_2Per)    
   @ nLin, 208 PSAY Alltrim(TRC->Bco_Ag_D_Sal)
   @ nLin, 215 PSAY Alltrim(TRC->Cta_Dep_Sal)
   @ nLin, 215 PSAY TRC->Sit_Folha
   @ nLin, 215 PSAY Alltrim(TRC->Hrs_Mensais)
   @ nLin, 215 PSAY Alltrim(TRC->Hrs_Semanais)
   @ nLin, 215 PSAY TRC->Cod_Chapa
   @ nLin, 215 PSAY Alltrim(TRC->Turno_Trab)
   @ nLin, 215 PSAY TRC->Cod_Funcao
   @ nLin, 215 PSAY Transform(TRC->Salario, '@E 999,999,999.99')
   @ nLin, 215 PSAY TRC->Tp_Cont_Trab
   @ nLin, 215 PSAY TRC->End_E_Mail
   @ nLin, 215 PSAY TRC->Cargo
   @ nLin, 215 PSAY STOD(TRC->DtEmiSCTP)
   @ nLin, 215 PSAY STOD(TRC->Dt_Emis_RG)
   @ nLin, 215 PSAY TRC->LT
   @ nLin, 215 PSAY TRC->Nome_complet
   @ nLin, 215 PSAY TRC->Orgao_expedR
   @ nLin, 215 PSAY TRC->Org_Emis_RG
   @ nLin, 215 PSAY TRC->DESC_FUNCAO
   @ nLin, 215 PSAY TRC->C_B_O_2002 
   @ nLin, 215 PSAY TRC->Cod_Depto
   @ nLin, 215 PSAY TRC->Nome_Depto
   @ nLin, 215 PSAY TRC->Sexo
//"Filial","Matricula","Cto_Custo","Nome","CPF","PIS","RG","UF_RG","CartProfis","SerieCart","UF_CartProf","Dt. Emis. Cart","Tit_Eleit","Zona_Sec","Telefone", "Dt_Nasc", "Dt_Admissao","Dt_Demissao","Ven_Exper_1","Vc_Exp_2Per","Bco_Ag_D_Sal","Cta_Dep_Sal","Sit_Folha", "Hrs_Mensais","Hrs_Semanais","Cod_Chapa","Turno_Trab","Cod_Funcao","Salario","Tp_Cont_Trab","End_E_Email","Cargo","LT","Nome_complet","DtEmiSCTP","Dt_Emis_RG","Orgao_expedR","Org_Emis_RG","DESC_FUNCAO","C_B_O_2002"
*/
AAdd(_aDados, 	{	TRC->FILIAL,;
					TRC->Matricula,;
					TRC->Cto_Custo,;
					TRC->Nome,;
					TRC->CPF,;
					TRC->PIS,;
					TRC->RG,;
					TRC->UF_RG,;
					TRC->CartProfis,;
					TRC->SerieCart,;
					TRC->UF_CartProf,;
					STOD(TRC->DtEmiSCTP),;
					Transform(TRC->Tit_Eleit, '@R 9999999999-99'),;
					TRC->Zona_Sec,;
					TRC->Telefone,;
					STOD(TRC->Dt_Nasc),;
					STOD(TRC->Dt_Admissao),;
					STOD(TRC->Dt_Demissao),;
					STOD(TRC->Ven_Exper_1),;
					STOD(TRC->Vc_Exp_2Per),;
					TRC->Bco_Ag_D_Sal,;
					TRC->Cta_Dep_Sal,;
					TRC->Sit_Folha,;
					TRC->Hrs_Mensais,;
					TRC->Hrs_Semanais,;
					TRC->Cod_Chapa,;
					TRC->Turno_Trab,;
					TRC->Cod_Funcao,;
					Transform(TRC->Salario,  '@E 999,999,999.99'),;
					TRC->Tp_Cont_Trab,;
					TRC->End_E_Mail,;
					TRC->Cargo,;
					TRC->LT,;
					TRC->Nome_complet,;
					STOD(TRC->Dt_Emis_RG),;
					TRC->Orgao_expedR,;
					TRC->DESC_FUNCAO,;
					TRC->C_B_O_2002,;
					TRC->Cod_Depto,;
					TRC->Nome_Depto,;
					TRC->Sexo})                 
	
   nLin++                                                              
       

   TRC->(dbSkip())  
EndDo

If mv_par07 == 1
	DlgToExcel({ {"ARRAY","Relat�rio de Funcionarios", _aCabec, _aDados} }) 
EndIf
                                                                     
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������-���
���Fun��o    � AjustaSX1    �Autor �  Rene Lopes    	  �    05.04.2010 ���
�������������������������������������������������������������������������-���
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*Static Function AjustaSX1()
Local aArea := GetArea()

PutSx1(cPerg,"01","Dt. Admiss�o De      ","Dt. Admiss�o De      ","Dt. Admiss�o De      ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Dt. Admiss�o Ate     ","Dt. Admiss�o At      ","Dt. Admiss�o Ate     ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Matricula De         ","Matricula De         ","Matricula De         ","mv_ch3","C",15,00,01,"G","","SRA","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Matricula inicial a ser considerada"})
PutSx1(cPerg,"04","Matricula Ate        ","Matricula Ate        ","Matricula Ate        ","mv_ch4","C",15,00,01,"G","","SRA","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Matricula final a ser considerada"})
PutSx1(cPerg,"05","Filial De        ","Filial De       ","Filial De        ","mv_ch5","C",02,00,01,"G","","SM0","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Filial Inicial a ser considerada"})
PutSx1(cPerg,"06","Filial Ate        ","Filial Ate       ","Filial Ate       ","mv_ch6","C",02,00,01,"G","","SM0","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Filial final a ser considerado"})
//PutSx1(cPerg,"07","Canal De           ","Canal De           ","Canal De           ","mv_ch7","C",06,00,01,"G","","SZ2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal inicial a ser considerado"})
//PutSx1(cPerg,"08","Canal Ate          ","Canal Ate          ","Canal Ate          ","mv_ch8","C",06,00,01,"G","","SZ2","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal final a ser considerado"})
//PutSx1(cPerg,"09","TES                ","TES                ","TES                ","mv_ch9","C",30,00,01,"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Exemplo: 501;502;503"}) 
PutSx1(cPerg,"07","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par10","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)   
Return            */