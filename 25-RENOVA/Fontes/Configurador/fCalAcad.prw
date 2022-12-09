/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fCalAcad  �Autor � Jose Carlos Gouveia   � Data �27.08.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calculo do Desconto da Academia                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Data     �              Alteracao                                     ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function fCalAcad()

//Inicia Variaveis
nDesc	:= 0
nEmp	:= 0
nPos	:= 0
nPerc	:= 0
aTab	:= {}

//Processamento
//Verifica se Funcionnario Optou por Academia
If Empty(SRA->RA_ACADEM)
	Return()
Endif

//Carrega Tabela U002 - Academia
fCarrTab(@aTab,"U002")

//Buscar Codigo Academia
If ( nPos := aScan( aTab, {|X| X[5] == SRA->RA_ACADEM } ) ) = 0
	Return()
Endif

//Calculo Aporte Empresa
If Salario <= aTab[nPos,8]
	nEmp	:= Round(aTab[nPos,7] * aTab[nPos,9]/100,2)
	nPerc	:= 100 - aTab[nPos,9]
ElseIf Salario <= aTab[nPos,10]
	nEmp	:= Round(aTab[nPos,7] * aTab[nPos,11]/100,2)
	nPerc	:= 100 - aTab[nPos,11]
Else
	nEmp	:= Round(aTab[nPos,7] * aTab[nPos,13]/100,2)
	nPerc	:= 100 - aTab[nPos,13]	
Endif

//Calculo Parte Funcionarios
nDesc := aTab[nPos,7] - nEmp

//Gera��o de Verbas
//Parte Funcionario
If nDesc > 0
	fGeraVerba("562",nDesc ,nPerc,,,,,,,,.T.,)
Endif

//Parte Empresa
If nEmp > 0
	fGeraVerba("793",nEmp ,,,,,,,,,.T.,)
Endif

Return('')

//Fim da Rotina
