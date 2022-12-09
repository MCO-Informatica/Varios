#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRPA030  � Autor � Tatiana Pontes 	   � Data � 10/07/12  ���
�������������������������������������������������������������������������͹��
���Descricao � Fechamento Periodo de Calculo de Remuneracao			      ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CRPA030()

	Local 	cPerg		:= "CRP030"
	Local 	aSays		:= {}
	Local 	aButtons	:= {}                                                    

	Private	cRemPer		:= GetMv("MV_REMMES")
	
	Aadd( aSays, "FECHAMENTO DO PER�ODO DE CALCULO DE REMUNERA��O" )
	Aadd( aSays, "" )
	Aadd( aSays, "Todos os lan�amentos de remunera��o dentro do per�odo abaixo ser�o encerrados." )
	Aadd( aSays, "N�o ser� poss�vel inclus�es, altera��es ou exclus�es para per�odos fechados." )
	Aadd( aSays, "" )
	Aadd( aSays, "Per�odo que ser� fechado: " + Right(cRemPer,2) + "/" + Left(cRemPer,4) )
	                                                                         
	Aadd(aButtons, { 1,.T.,{|| Processa( {|| FPerRem() }, "Selecionando lan�amentos..."), FechaBatch() }} )
	Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( "FECHAMENTO DO PER�ODO DE REMUNERA��O", aSays, aButtons )

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FPerRem  � Autor � Tatiana Pontes 	   � Data � 10/07/12  ���
�������������������������������������������������������������������������͹��
���Descricao � Processa remuneracao gerando pagamento				      ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                    

Static Function FPerRem()
	
	Local cMens 		:= Right(cRemPer,2) + "/" + Left(cRemPer,4)
	Local cMesAtu		:= ""
	Local cAnoAtu		:= ""
	Local cCompetencia	:= "" 
	Local cLog			:= ""
	
	Private aMesValid	:= { "01","02","03","04","05","06","07","08","09","10","11","12" }
	
    /*
	��������������������������������������������������������������Ŀ
	�Retorna se o parametro Mes/Ano do Fechamento for invalido     �
	����������������������������������������������������������������*/
	
	IF Empty( cRemPer ) .or. aScan( aMesValid, Subst( cRemPer, 5 , 2 ) ) == 0 ;
						 .or. Len( AllTrim( cRemPer ) ) < 6 

	 	cLog := "Par�metro MV_REMMES com conte�do incorreto." + CRLF
		cLog += "Corrija o par�metro para realizar o fechamento." + cCompetencia
		MsgStop(cLog)
	
		Return

	/*
	��������������������������������������������������������������Ŀ
	� Confirma Fechamento Mensal                                   �
	����������������������������������������������������������������*/
	ElseIF !MsgNoYes("Confirma Fechamento " + cMens)
		Return
	EndIF
    
	/*
	��������������������������������������������������������������Ŀ
	� Define o proximo periodo                                     �
	����������������������������������������������������������������*/
	
	cMesAtu			:= Iif( Right( cRemPer, 2 ) = "12", "01", StrZero( Val( Right( cRemPer, 2 ) ) + 1, 2, 0 ) )
	cAnoAtu			:= Iif( cMesAtu = "01", StrZero( Val( Left( cRemPer, 4 ) ) + 1, 4, 0 ), Left( cRemPer, 4 ) )
	cCompetencia	:= cAnoAtu + cMesAtu

	/*
	��������������������������������������������������������������Ŀ
	� Atualiza MV_REMMES                                           �
	����������������������������������������������������������������*/

	PutMv( "MV_REMMES" , cCompetencia )
 
 	cLog := "Fechamento conclu�do com sucesso." + CRLF
	cLog += "Per�odo em aberto: " + Right(cCompetencia,2) + "/" + Left(cCompetencia,4)
	MsgInfo(cLog)

Return