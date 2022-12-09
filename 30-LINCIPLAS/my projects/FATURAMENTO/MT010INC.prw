#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "vKey.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010INC  �Autor  �Rodrigo Okamoto     � Data �  12/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA UTILIZADO NA ALTERACAO DE CADASTRO DE     ���
���			 � PRODUTO ONDE IRA VERIFICAR A EXISTENCIA DA AMARRACAO DE 	  ���
���			 � PRODUTO X COMPLEMENTO CASO NECESS�RIO PARA A MP 563		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// realiza as altera��es na inclus�o do produto
User Function MT010INC()

u_GrvB5MP563()

Return

//realiza as altera��es na altera��o do produto
User Function MT010ALT()

u_GrvB5MP563()

Return


User Function GrvB5MP563


Local aArea 	:= Getarea()
Local cProd 	:= SB1->B1_COD
Local cPosipi	:= SB1->B1_POSIPI
Local cDescr	:= SB1->B1_DESC
Local cOrigem	:= SB1->B1_ORIGEM
Local aMP563	:= {}
Local aEXCMP563	:= {}

//Se n�o for produto nacional, n�o entra na regra da desonera��o da folha
If cOrigem <> "0"
	DbSelectArea("SB5")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SB5")+cProd)	
		RECLOCK("SB5",.F.)
		SB5->B5_CEME	:= cDescr
		SB5->B5_INSPAT	:= "2"
		SB5->B5_CODATIV	:= ""
		MSUNLOCK()
	EndIf
	SB5->(dbclosearea())
	RestArea(aArea)
	Return
EndIf


ExcMP563(@aEXCMP563)

//se o NCM estiver nesta lista, n�o dever� ser feito o complemento para o c�lculo do INSS Patronal
If nPos := aScan(aEXCMP563,{|x| UPPER(AllTrim(x[1])) == substr(cPosipi,1,len(AllTrim(x[1]))) }) > 0
	DbSelectArea("SB5")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SB5")+cProd)	
		RECLOCK("SB5",.F.)
		SB5->B5_CEME	:= cDescr
		SB5->B5_INSPAT	:= "2"
		SB5->B5_CODATIV	:= ""
		MSUNLOCK()
	EndIf
	SB5->(dbclosearea())
	RestArea(aArea)
	Return
EndIf

nPos := aScan(aEXCMP563,{|x| UPPER(AllTrim(x[1])) == AllTrim(cposipi) })
RelacMP563(@aMP563)

If nPos := aScan(aMP563,{|x| UPPER(AllTrim(x[1])) == substr(cPosipi,1,len(AllTrim(x[1]))) }) == 0
	DbSelectArea("SB5")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SB5")+cProd)	
		RECLOCK("SB5",.F.)
		SB5->B5_CEME	:= cDescr
		SB5->B5_INSPAT	:= "2"
		SB5->B5_CODATIV	:= ""
		MSUNLOCK()
	EndIf
	SB5->(dbclosearea())
	RestArea(aArea)
	Return
EndIf

DbSelectArea("SB5")
DbSetOrder(1)
If !DbSeek(XFILIAL("SB5")+cProd)	
	RECLOCK("SB5",.T.)
	SB5->B5_FILIAL	:= xFilial("SB5")
	SB5->B5_COD		:= cProd
	SB5->B5_CEME	:= cDescr
	SB5->B5_INSPAT	:= "1"
	SB5->B5_CODATIV	:= "2229399"
	MSUNLOCK()
Else
	RECLOCK("SB5",.F.)
	SB5->B5_CEME	:= cDescr
	SB5->B5_INSPAT	:= "1"
	SB5->B5_CODATIV	:= "2229399"
	MSUNLOCK()
EndIf

Return 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExcMP563  �Autor  �Microsiga           � Data �  13/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona os NCMs que n�o devem ser considerados na MP 563  ���
���          � na Array aEXCMP563                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExcMP563(aEXCMP563)

AADD(aEXCMP563,{"84521000"})
AADD(aEXCMP563,{"84091000"})
AADD(aEXCMP563,{"84221110"})
AADD(aEXCMP563,{"84231000"})
AADD(aEXCMP563,{"84512100"})
AADD(aEXCMP563,{"84529020"})
AADD(aEXCMP563,{"85115090"})
AADD(aEXCMP563,{"85121000"})
AADD(aEXCMP563,{"85461000"})
AADD(aEXCMP563,{"85472010"})
AADD(aEXCMP563,{"87029010"})
AADD(aEXCMP563,{"65061000"})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RelacMP563�Autor  �Microsiga           � Data �  13/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function RelacMP563(aMP563)


AADD(aMP563,{"54"})
AADD(aMP563,{"55"})
AADD(aMP563,{"56"})
AADD(aMP563,{"57"})
AADD(aMP563,{"58"})
AADD(aMP563,{"59"})
AADD(aMP563,{"60"})
AADD(aMP563,{"61"})
AADD(aMP563,{"62"})
AADD(aMP563,{"63"})
AADD(aMP563,{"64"})
AADD(aMP563,{"65"})
AADD(aMP563,{"89"})
AADD(aMP563,{"3915"})
AADD(aMP563,{"3916"})
AADD(aMP563,{"3917"})
AADD(aMP563,{"3918"})
AADD(aMP563,{"3919"})
AADD(aMP563,{"3920"})
AADD(aMP563,{"3921"})
AADD(aMP563,{"3922"})
AADD(aMP563,{"3923"})
AADD(aMP563,{"3924"})
AADD(aMP563,{"3925"})
AADD(aMP563,{"3926"})
AADD(aMP563,{"4015"})
AADD(aMP563,{"4104"})
AADD(aMP563,{"4105"})
AADD(aMP563,{"4106"})
AADD(aMP563,{"4107"})
AADD(aMP563,{"4114"})
AADD(aMP563,{"4203"})
AADD(aMP563,{"4303"})
AADD(aMP563,{"5007"})
AADD(aMP563,{"5105"})
AADD(aMP563,{"5106"})
AADD(aMP563,{"5107"})
AADD(aMP563,{"5108"})
AADD(aMP563,{"5109"})
AADD(aMP563,{"5111"})
AADD(aMP563,{"5112"})
AADD(aMP563,{"5204"})
AADD(aMP563,{"5205"})
AADD(aMP563,{"5206"})
AADD(aMP563,{"5207"})
AADD(aMP563,{"5208"})
AADD(aMP563,{"5209"})
AADD(aMP563,{"5210"})
AADD(aMP563,{"5211"})
AADD(aMP563,{"5212"})
AADD(aMP563,{"5306"})
AADD(aMP563,{"5307"})
AADD(aMP563,{"5308"})
AADD(aMP563,{"5309"})
AADD(aMP563,{"5310"})
AADD(aMP563,{"8402"})
AADD(aMP563,{"8403"})
AADD(aMP563,{"8404"})
AADD(aMP563,{"8405"})
AADD(aMP563,{"8406"})
AADD(aMP563,{"8407"})
AADD(aMP563,{"8408"})
AADD(aMP563,{"8409"})
AADD(aMP563,{"8410"})
AADD(aMP563,{"8411"})
AADD(aMP563,{"8412"})
AADD(aMP563,{"8413"})
AADD(aMP563,{"8416"})
AADD(aMP563,{"8417"})
AADD(aMP563,{"8419"})
AADD(aMP563,{"8420"})
AADD(aMP563,{"8422"})
AADD(aMP563,{"8423"})
AADD(aMP563,{"8424"})
AADD(aMP563,{"8425"})
AADD(aMP563,{"8426"})
AADD(aMP563,{"8427"})
AADD(aMP563,{"8428"})
AADD(aMP563,{"8429"})
AADD(aMP563,{"8430"})
AADD(aMP563,{"8431"})
AADD(aMP563,{"8432"})
AADD(aMP563,{"8433"})
AADD(aMP563,{"8434"})
AADD(aMP563,{"8435"})
AADD(aMP563,{"8436"})
AADD(aMP563,{"8437"})
AADD(aMP563,{"8438"})
AADD(aMP563,{"8439"})
AADD(aMP563,{"8440"})
AADD(aMP563,{"8441"})
AADD(aMP563,{"8442"})
AADD(aMP563,{"8444"})
AADD(aMP563,{"8445"})
AADD(aMP563,{"8446"})
AADD(aMP563,{"8447"})
AADD(aMP563,{"8448"})
AADD(aMP563,{"8449"})
AADD(aMP563,{"8451"})
AADD(aMP563,{"8452"})
AADD(aMP563,{"8453"})
AADD(aMP563,{"8454"})
AADD(aMP563,{"8455"})
AADD(aMP563,{"8456"})
AADD(aMP563,{"8457"})
AADD(aMP563,{"8458"})
AADD(aMP563,{"8459"})
AADD(aMP563,{"8460"})
AADD(aMP563,{"8461"})
AADD(aMP563,{"8462"})
AADD(aMP563,{"8463"})
AADD(aMP563,{"8464"})
AADD(aMP563,{"8465"})
AADD(aMP563,{"8466"})
AADD(aMP563,{"8474"})
AADD(aMP563,{"8475"})
AADD(aMP563,{"8476"})
AADD(aMP563,{"8477"})
AADD(aMP563,{"8479"})
AADD(aMP563,{"8480"})
AADD(aMP563,{"8483"})
AADD(aMP563,{"8484"})
AADD(aMP563,{"8486"})
AADD(aMP563,{"8487"})
AADD(aMP563,{"8501"})
AADD(aMP563,{"8502"})
AADD(aMP563,{"8511"})
AADD(aMP563,{"8512"})
AADD(aMP563,{"8513"})
AADD(aMP563,{"8541"})
AADD(aMP563,{"8546"})
AADD(aMP563,{"8547"})
AADD(aMP563,{"8702"})
AADD(aMP563,{"8707"})
AADD(aMP563,{"8802"})
AADD(aMP563,{"8803"})
AADD(aMP563,{"9402"})
AADD(aMP563,{"9403"})
AADD(aMP563,{"9606"})
AADD(aMP563,{"9607"})
AADD(aMP563,{"94015"})
AADD(aMP563,{"94016"})
AADD(aMP563,{"94017"})
AADD(aMP563,{"94042"})
AADD(aMP563,{"511300"})
AADD(aMP563,{"845020"})
AADD(aMP563,{"940130"})
AADD(aMP563,{"940140"})
AADD(aMP563,{"940190"})
AADD(aMP563,{"8483101"})
AADD(aMP563,{"9032892"})
AADD(aMP563,{"9032898"})
AADD(aMP563,{"30059090"})
AADD(aMP563,{"38151210"})
AADD(aMP563,{"38190000"})
AADD(aMP563,{"40091100"})
AADD(aMP563,{"40091210"})
AADD(aMP563,{"40091290"})
AADD(aMP563,{"40093100"})
AADD(aMP563,{"40093210"})
AADD(aMP563,{"40093290"})
AADD(aMP563,{"40094210"})
AADD(aMP563,{"40094290"})
AADD(aMP563,{"40103100"})
AADD(aMP563,{"40103200"})
AADD(aMP563,{"40103300"})
AADD(aMP563,{"40103400"})
AADD(aMP563,{"40103500"})
AADD(aMP563,{"40103600"})
AADD(aMP563,{"40103900"})
AADD(aMP563,{"40161010"})
AADD(aMP563,{"40169100"})
AADD(aMP563,{"40169300"})
AADD(aMP563,{"40169990"})
AADD(aMP563,{"42021100"})
AADD(aMP563,{"42021220"})
AADD(aMP563,{"42022100"})
AADD(aMP563,{"42022220"})
AADD(aMP563,{"42023100"})
AADD(aMP563,{"42023200"})
AADD(aMP563,{"42029100"})
AADD(aMP563,{"42029200"})
AADD(aMP563,{"42050000"})
AADD(aMP563,{"44219000"})
AADD(aMP563,{"45049000"})
AADD(aMP563,{"48185000"})
AADD(aMP563,{"50040000"})
AADD(aMP563,{"50050000"})
AADD(aMP563,{"50060000"})
AADD(aMP563,{"51040000"})
AADD(aMP563,{"51100000"})
AADD(aMP563,{"52030000"})
AADD(aMP563,{"53110000"})
AADD(aMP563,{"68079000"})
AADD(aMP563,{"68128000"})
AADD(aMP563,{"68129010"})
AADD(aMP563,{"68129100"})
AADD(aMP563,{"68129910"})
AADD(aMP563,{"68131010"})
AADD(aMP563,{"68131090"})
AADD(aMP563,{"68132000"})
AADD(aMP563,{"68138110"})
AADD(aMP563,{"68138190"})
AADD(aMP563,{"68138910"})
AADD(aMP563,{"68138990"})
AADD(aMP563,{"68139010"})
AADD(aMP563,{"68139090"})
AADD(aMP563,{"69091930"})
AADD(aMP563,{"70071100"})
AADD(aMP563,{"70072100"})
AADD(aMP563,{"70091000"})
AADD(aMP563,{"73030000"})
AADD(aMP563,{"73081000"})
AADD(aMP563,{"73082000"})
AADD(aMP563,{"73084000"})
AADD(aMP563,{"73090010"})
AADD(aMP563,{"73090090"})
AADD(aMP563,{"73101090"})
AADD(aMP563,{"73102910"})
AADD(aMP563,{"73102990"})
AADD(aMP563,{"73110000"})
AADD(aMP563,{"73151100"})
AADD(aMP563,{"73151210"})
AADD(aMP563,{"73151290"})
AADD(aMP563,{"73151900"})
AADD(aMP563,{"73152000"})
AADD(aMP563,{"73158100"})
AADD(aMP563,{"73158200"})
AADD(aMP563,{"73158900"})
AADD(aMP563,{"73159000"})
AADD(aMP563,{"73160000"})
AADD(aMP563,{"73201000"})
AADD(aMP563,{"73202010"})
AADD(aMP563,{"73202090"})
AADD(aMP563,{"73209000"})
AADD(aMP563,{"73269090"})
AADD(aMP563,{"74199990"})
AADD(aMP563,{"76129090"})
AADD(aMP563,{"82054000"})
AADD(aMP563,{"82073000"})
AADD(aMP563,{"83012000"})
AADD(aMP563,{"83023000"})
AADD(aMP563,{"83081000"})
AADD(aMP563,{"83082000"})
AADD(aMP563,{"83100000"})
AADD(aMP563,{"84011000"})
AADD(aMP563,{"84012000"})
AADD(aMP563,{"84014000"})
AADD(aMP563,{"84141000"})
AADD(aMP563,{"84142000"})
AADD(aMP563,{"84143011"})
AADD(aMP563,{"84143019"})
AADD(aMP563,{"84143091"})
AADD(aMP563,{"84143099"})
AADD(aMP563,{"84144010"})
AADD(aMP563,{"84144020"})
AADD(aMP563,{"84144090"})
AADD(aMP563,{"84145910"})
AADD(aMP563,{"84145990"})
AADD(aMP563,{"84148011"})
AADD(aMP563,{"84148012"})
AADD(aMP563,{"84148013"})
AADD(aMP563,{"84148019"})
AADD(aMP563,{"84148021"})
AADD(aMP563,{"84148022"})
AADD(aMP563,{"84148029"})
AADD(aMP563,{"84148031"})
AADD(aMP563,{"84148032"})
AADD(aMP563,{"84148033"})
AADD(aMP563,{"84148038"})
AADD(aMP563,{"84148039"})
AADD(aMP563,{"84148090"})
AADD(aMP563,{"84149010"})
AADD(aMP563,{"84149020"})
AADD(aMP563,{"84149031"})
AADD(aMP563,{"84149032"})
AADD(aMP563,{"84149033"})
AADD(aMP563,{"84149034"})
AADD(aMP563,{"84149039"})
AADD(aMP563,{"84151090"})
AADD(aMP563,{"84152010"})
AADD(aMP563,{"84152090"})
AADD(aMP563,{"84158110"})
AADD(aMP563,{"84158190"})
AADD(aMP563,{"84158210"})
AADD(aMP563,{"84158290"})
AADD(aMP563,{"84158300"})
AADD(aMP563,{"84159000"})
AADD(aMP563,{"84185010"})
AADD(aMP563,{"84185090"})
AADD(aMP563,{"84186100"})
AADD(aMP563,{"84186910"})
AADD(aMP563,{"84186920"})
AADD(aMP563,{"84186931"})
AADD(aMP563,{"84186932"})
AADD(aMP563,{"84186940"})
AADD(aMP563,{"84186991"})
AADD(aMP563,{"84186999"})
AADD(aMP563,{"84189900"})
AADD(aMP563,{"84211110"})
AADD(aMP563,{"84211190"})
AADD(aMP563,{"84211290"})
AADD(aMP563,{"84211910"})
AADD(aMP563,{"84211990"})
AADD(aMP563,{"84212100"})
AADD(aMP563,{"84212200"})
AADD(aMP563,{"84212300"})
AADD(aMP563,{"84212920"})
AADD(aMP563,{"84212930"})
AADD(aMP563,{"84212990"})
AADD(aMP563,{"84213100"})
AADD(aMP563,{"84213910"})
AADD(aMP563,{"84213920"})
AADD(aMP563,{"84213930"})
AADD(aMP563,{"84213990"})
AADD(aMP563,{"84219191"})
AADD(aMP563,{"84219199"})
AADD(aMP563,{"84219910"})
AADD(aMP563,{"84219920"})
AADD(aMP563,{"84219991"})
AADD(aMP563,{"84219999"})
AADD(aMP563,{"84431110"})
AADD(aMP563,{"84431190"})
AADD(aMP563,{"84431200"})
AADD(aMP563,{"84431310"})
AADD(aMP563,{"84431321"})
AADD(aMP563,{"84431329"})
AADD(aMP563,{"84431390"})
AADD(aMP563,{"84431400"})
AADD(aMP563,{"84431500"})
AADD(aMP563,{"84431600"})
AADD(aMP563,{"84431710"})
AADD(aMP563,{"84431790"})
AADD(aMP563,{"84431910"})
AADD(aMP563,{"84431990"})
AADD(aMP563,{"84433910"})
AADD(aMP563,{"84433921"})
AADD(aMP563,{"84433928"})
AADD(aMP563,{"84433929"})
AADD(aMP563,{"84433930"})
AADD(aMP563,{"84433990"})
AADD(aMP563,{"84439110"})
AADD(aMP563,{"84439191"})
AADD(aMP563,{"84439192"})
AADD(aMP563,{"84439199"})
AADD(aMP563,{"84671110"})
AADD(aMP563,{"84671190"})
AADD(aMP563,{"84671900"})
AADD(aMP563,{"84672991"})
AADD(aMP563,{"84672993"})
AADD(aMP563,{"84678100"})
AADD(aMP563,{"84678900"})
AADD(aMP563,{"84679100"})
AADD(aMP563,{"84679200"})
AADD(aMP563,{"84679900"})
AADD(aMP563,{"84681000"})
AADD(aMP563,{"84682000"})
AADD(aMP563,{"84688010"})
AADD(aMP563,{"84688090"})
AADD(aMP563,{"84689010"})
AADD(aMP563,{"84689020"})
AADD(aMP563,{"84689090"})
AADD(aMP563,{"84690010"})
AADD(aMP563,{"84709010"})
AADD(aMP563,{"84709090"})
AADD(aMP563,{"84718000"})
AADD(aMP563,{"84719019"})
AADD(aMP563,{"84719090"})
AADD(aMP563,{"84721000"})
AADD(aMP563,{"84723090"})
AADD(aMP563,{"84729010"})
AADD(aMP563,{"84729029"})
AADD(aMP563,{"84729030"})
AADD(aMP563,{"84729040"})
AADD(aMP563,{"84729091"})
AADD(aMP563,{"84729099"})
AADD(aMP563,{"84731010"})
AADD(aMP563,{"84781010"})
AADD(aMP563,{"84781090"})
AADD(aMP563,{"84789000"})
AADD(aMP563,{"84811000"})
AADD(aMP563,{"84812010"})
AADD(aMP563,{"84812011"})
AADD(aMP563,{"84812019"})
AADD(aMP563,{"84812090"})
AADD(aMP563,{"84813000"})
AADD(aMP563,{"84814000"})
AADD(aMP563,{"84818021"})
AADD(aMP563,{"84818029"})
AADD(aMP563,{"84818039"})
AADD(aMP563,{"84818092"})
AADD(aMP563,{"84818093"})
AADD(aMP563,{"84818094"})
AADD(aMP563,{"84818095"})
AADD(aMP563,{"84818096"})
AADD(aMP563,{"84818097"})
AADD(aMP563,{"84818099"})
AADD(aMP563,{"84819090"})
AADD(aMP563,{"84823000"})
AADD(aMP563,{"84825090"})
AADD(aMP563,{"84828000"})
AADD(aMP563,{"84829120"})
AADD(aMP563,{"84829130"})
AADD(aMP563,{"84829190"})
AADD(aMP563,{"84829911"})
AADD(aMP563,{"84829919"})
AADD(aMP563,{"85030010"})
AADD(aMP563,{"85030090"})
AADD(aMP563,{"85042100"})
AADD(aMP563,{"85042200"})
AADD(aMP563,{"85042300"})
AADD(aMP563,{"85043111"})
AADD(aMP563,{"85043119"})
AADD(aMP563,{"85043211"})
AADD(aMP563,{"85043219"})
AADD(aMP563,{"85043221"})
AADD(aMP563,{"85043300"})
AADD(aMP563,{"85043400"})
AADD(aMP563,{"85044022"})
AADD(aMP563,{"85044030"})
AADD(aMP563,{"85044050"})
AADD(aMP563,{"85044090"})
AADD(aMP563,{"85051910"})
AADD(aMP563,{"85052090"})
AADD(aMP563,{"85059010"})
AADD(aMP563,{"85059080"})
AADD(aMP563,{"85059090"})
AADD(aMP563,{"85071000"})
AADD(aMP563,{"85071010"})
AADD(aMP563,{"85071090"})
AADD(aMP563,{"85072010"})
AADD(aMP563,{"85072090"})
AADD(aMP563,{"85079010"})
AADD(aMP563,{"85079090"})
AADD(aMP563,{"85086000"})
AADD(aMP563,{"85087000"})
AADD(aMP563,{"85141010"})
AADD(aMP563,{"85141090"})
AADD(aMP563,{"85142011"})
AADD(aMP563,{"85142019"})
AADD(aMP563,{"85142020"})
AADD(aMP563,{"85143011"})
AADD(aMP563,{"85143019"})
AADD(aMP563,{"85143021"})
AADD(aMP563,{"85143029"})
AADD(aMP563,{"85143090"})
AADD(aMP563,{"85144000"})
AADD(aMP563,{"85149000"})
AADD(aMP563,{"85151100"})
AADD(aMP563,{"85151900"})
AADD(aMP563,{"85152100"})
AADD(aMP563,{"85152900"})
AADD(aMP563,{"85153110"})
AADD(aMP563,{"85153190"})
AADD(aMP563,{"85153900"})
AADD(aMP563,{"85158010"})
AADD(aMP563,{"85158090"})
AADD(aMP563,{"85159000"})
AADD(aMP563,{"85161000"})
AADD(aMP563,{"85167100"})
AADD(aMP563,{"85167920"})
AADD(aMP563,{"85167990"})
AADD(aMP563,{"85168010"})
AADD(aMP563,{"85169000"})
AADD(aMP563,{"85171891"})
AADD(aMP563,{"85171899"})
AADD(aMP563,{"85176130"})
AADD(aMP563,{"85176212"})
AADD(aMP563,{"85176221"})
AADD(aMP563,{"85176222"})
AADD(aMP563,{"85176223"})
AADD(aMP563,{"85176224"})
AADD(aMP563,{"85176229"})
AADD(aMP563,{"85176232"})
AADD(aMP563,{"85176239"})
AADD(aMP563,{"85176241"})
AADD(aMP563,{"85176248"})
AADD(aMP563,{"85176251"})
AADD(aMP563,{"85176254"})
AADD(aMP563,{"85176255"})
AADD(aMP563,{"85176259"})
AADD(aMP563,{"85176262"})
AADD(aMP563,{"85176272"})
AADD(aMP563,{"85176277"})
AADD(aMP563,{"85176278"})
AADD(aMP563,{"85176279"})
AADD(aMP563,{"85176294"})
AADD(aMP563,{"85176299"})
AADD(aMP563,{"85176900"})
AADD(aMP563,{"85177010"})
AADD(aMP563,{"85182100"})
AADD(aMP563,{"85182200"})
AADD(aMP563,{"85182990"})
AADD(aMP563,{"85269200"})
AADD(aMP563,{"85272110"})
AADD(aMP563,{"85272190"})
AADD(aMP563,{"85272900"})
AADD(aMP563,{"85272990"})
AADD(aMP563,{"85287111"})
AADD(aMP563,{"85299020"})
AADD(aMP563,{"85311090"})
AADD(aMP563,{"85321000"})
AADD(aMP563,{"85322990"})
AADD(aMP563,{"85352100"})
AADD(aMP563,{"85353017"})
AADD(aMP563,{"85353018"})
AADD(aMP563,{"85353027"})
AADD(aMP563,{"85353028"})
AADD(aMP563,{"85361000"})
AADD(aMP563,{"85362000"})
AADD(aMP563,{"85363000"})
AADD(aMP563,{"85364100"})
AADD(aMP563,{"85364900"})
AADD(aMP563,{"85365090"})
AADD(aMP563,{"85366100"})
AADD(aMP563,{"85366910"})
AADD(aMP563,{"85366990"})
AADD(aMP563,{"85369010"})
AADD(aMP563,{"85369040"})
AADD(aMP563,{"85369090"})
AADD(aMP563,{"85371020"})
AADD(aMP563,{"85371090"})
AADD(aMP563,{"85372090"})
AADD(aMP563,{"85381000"})
AADD(aMP563,{"85389090"})
AADD(aMP563,{"85392910"})
AADD(aMP563,{"85392990"})
AADD(aMP563,{"85408990"})
AADD(aMP563,{"85431000"})
AADD(aMP563,{"85432000"})
AADD(aMP563,{"85433000"})
AADD(aMP563,{"85437013"})
AADD(aMP563,{"85437039"})
AADD(aMP563,{"85437040"})
AADD(aMP563,{"85437099"})
AADD(aMP563,{"85439090"})
AADD(aMP563,{"85443000"})
AADD(aMP563,{"85444200"})
AADD(aMP563,{"85444900"})
AADD(aMP563,{"85489090"})
AADD(aMP563,{"86011000"})
AADD(aMP563,{"86071919"})
AADD(aMP563,{"87011000"})
AADD(aMP563,{"87012000"})
AADD(aMP563,{"87013000"})
AADD(aMP563,{"87019010"})
AADD(aMP563,{"87019090"})
AADD(aMP563,{"87032290"})
AADD(aMP563,{"87032390"})
AADD(aMP563,{"87041010"})
AADD(aMP563,{"87041090"})
AADD(aMP563,{"87051010"})
AADD(aMP563,{"87051090"})
AADD(aMP563,{"87052000"})
AADD(aMP563,{"87053000"})
AADD(aMP563,{"87054000"})
AADD(aMP563,{"87059010"})
AADD(aMP563,{"87059090"})
AADD(aMP563,{"87060020"})
AADD(aMP563,{"87071000"})
AADD(aMP563,{"87079010"})
AADD(aMP563,{"87079090"})
AADD(aMP563,{"87081000"})
AADD(aMP563,{"87082100"})
AADD(aMP563,{"87082911"})
AADD(aMP563,{"87082912"})
AADD(aMP563,{"87082913"})
AADD(aMP563,{"87082914"})
AADD(aMP563,{"87082919"})
AADD(aMP563,{"87082991"})
AADD(aMP563,{"87082992"})
AADD(aMP563,{"87082993"})
AADD(aMP563,{"87082994"})
AADD(aMP563,{"87082995"})
AADD(aMP563,{"87082996"})
AADD(aMP563,{"87082999"})
AADD(aMP563,{"87083011"})
AADD(aMP563,{"87083019"})
AADD(aMP563,{"87083090"})
AADD(aMP563,{"87083110"})
AADD(aMP563,{"87083190"})
AADD(aMP563,{"87083900"})
AADD(aMP563,{"87084011"})
AADD(aMP563,{"87084019"})
AADD(aMP563,{"87084080"})
AADD(aMP563,{"87084090"})
AADD(aMP563,{"87085011"})
AADD(aMP563,{"87085012"})
AADD(aMP563,{"87085019"})
AADD(aMP563,{"87085080"})
AADD(aMP563,{"87085090"})
AADD(aMP563,{"87085091"})
AADD(aMP563,{"87085099"})
AADD(aMP563,{"87086010"})
AADD(aMP563,{"87086090"})
AADD(aMP563,{"87087010"})
AADD(aMP563,{"87087090"})
AADD(aMP563,{"87088000"})
AADD(aMP563,{"87089100"})
AADD(aMP563,{"87089200"})
AADD(aMP563,{"87089300"})
AADD(aMP563,{"87089411"})
AADD(aMP563,{"87089412"})
AADD(aMP563,{"87089413"})
AADD(aMP563,{"87089481"})
AADD(aMP563,{"87089482"})
AADD(aMP563,{"87089483"})
AADD(aMP563,{"87089490"})
AADD(aMP563,{"87089491"})
AADD(aMP563,{"87089492"})
AADD(aMP563,{"87089493"})
AADD(aMP563,{"87089510"})
AADD(aMP563,{"87089521"})
AADD(aMP563,{"87089522"})
AADD(aMP563,{"87089529"})
AADD(aMP563,{"87089910"})
AADD(aMP563,{"87089990"})
AADD(aMP563,{"87091100"})
AADD(aMP563,{"87091900"})
AADD(aMP563,{"87099000"})
AADD(aMP563,{"87100000"})
AADD(aMP563,{"87141000"})
AADD(aMP563,{"87141900"})
AADD(aMP563,{"87149490"})
AADD(aMP563,{"87149990"})
AADD(aMP563,{"87162000"})
AADD(aMP563,{"87163100"})
AADD(aMP563,{"87163900"})
AADD(aMP563,{"88040000"})
AADD(aMP563,{"90058000"})
AADD(aMP563,{"90059090"})
AADD(aMP563,{"90061010"})
AADD(aMP563,{"90061090"})
AADD(aMP563,{"90072090"})
AADD(aMP563,{"90072091"})
AADD(aMP563,{"90072099"})
AADD(aMP563,{"90079200"})
AADD(aMP563,{"90085000"})
AADD(aMP563,{"90089000"})
AADD(aMP563,{"90101010"})
AADD(aMP563,{"90101020"})
AADD(aMP563,{"90101090"})
AADD(aMP563,{"90109010"})
AADD(aMP563,{"90111000"})
AADD(aMP563,{"90118010"})
AADD(aMP563,{"90118090"})
AADD(aMP563,{"90119090"})
AADD(aMP563,{"90131090"})
AADD(aMP563,{"90151000"})
AADD(aMP563,{"90152010"})
AADD(aMP563,{"90152090"})
AADD(aMP563,{"90153000"})
AADD(aMP563,{"90154000"})
AADD(aMP563,{"90158010"})
AADD(aMP563,{"90158090"})
AADD(aMP563,{"90159010"})
AADD(aMP563,{"90159090"})
AADD(aMP563,{"90160010"})
AADD(aMP563,{"90160090"})
AADD(aMP563,{"90171010"})
AADD(aMP563,{"90171090"})
AADD(aMP563,{"90173010"})
AADD(aMP563,{"90173020"})
AADD(aMP563,{"90173090"})
AADD(aMP563,{"90179010"})
AADD(aMP563,{"90179090"})
AADD(aMP563,{"90189091"})
AADD(aMP563,{"90191000"})
AADD(aMP563,{"90221910"})
AADD(aMP563,{"90221991"})
AADD(aMP563,{"90221999"})
AADD(aMP563,{"90222910"})
AADD(aMP563,{"90222990"})
AADD(aMP563,{"90241010"})
AADD(aMP563,{"90241020"})
AADD(aMP563,{"90241090"})
AADD(aMP563,{"90248011"})
AADD(aMP563,{"90248019"})
AADD(aMP563,{"90248021"})
AADD(aMP563,{"90248029"})
AADD(aMP563,{"90248090"})
AADD(aMP563,{"90249000"})
AADD(aMP563,{"90251190"})
AADD(aMP563,{"90251910"})
AADD(aMP563,{"90251990"})
AADD(aMP563,{"90258000"})
AADD(aMP563,{"90259010"})
AADD(aMP563,{"90259090"})
AADD(aMP563,{"90261019"})
AADD(aMP563,{"90261021"})
AADD(aMP563,{"90261029"})
AADD(aMP563,{"90262010"})
AADD(aMP563,{"90262090"})
AADD(aMP563,{"90268000"})
AADD(aMP563,{"90269010"})
AADD(aMP563,{"90269020"})
AADD(aMP563,{"90269090"})
AADD(aMP563,{"90271000"})
AADD(aMP563,{"90272011"})
AADD(aMP563,{"90272012"})
AADD(aMP563,{"90272019"})
AADD(aMP563,{"90272021"})
AADD(aMP563,{"90272029"})
AADD(aMP563,{"90273011"})
AADD(aMP563,{"90273019"})
AADD(aMP563,{"90273020"})
AADD(aMP563,{"90275010"})
AADD(aMP563,{"90275020"})
AADD(aMP563,{"90275030"})
AADD(aMP563,{"90275040"})
AADD(aMP563,{"90275050"})
AADD(aMP563,{"90275090"})
AADD(aMP563,{"90278011"})
AADD(aMP563,{"90278012"})
AADD(aMP563,{"90278013"})
AADD(aMP563,{"90278014"})
AADD(aMP563,{"90278020"})
AADD(aMP563,{"90278030"})
AADD(aMP563,{"90278091"})
AADD(aMP563,{"90278099"})
AADD(aMP563,{"90279010"})
AADD(aMP563,{"90279091"})
AADD(aMP563,{"90279093"})
AADD(aMP563,{"90279099"})
AADD(aMP563,{"90281011"})
AADD(aMP563,{"90281019"})
AADD(aMP563,{"90281090"})
AADD(aMP563,{"90282010"})
AADD(aMP563,{"90282020"})
AADD(aMP563,{"90283011"})
AADD(aMP563,{"90283019"})
AADD(aMP563,{"90283021"})
AADD(aMP563,{"90283029"})
AADD(aMP563,{"90283031"})
AADD(aMP563,{"90283039"})
AADD(aMP563,{"90283090"})
AADD(aMP563,{"90289010"})
AADD(aMP563,{"90289090"})
AADD(aMP563,{"90289090"})
AADD(aMP563,{"90291010"})
AADD(aMP563,{"90292010"})
AADD(aMP563,{"90299010"})
AADD(aMP563,{"90303321"})
AADD(aMP563,{"90303921"})
AADD(aMP563,{"90303990"})
AADD(aMP563,{"90304030"})
AADD(aMP563,{"90304090"})
AADD(aMP563,{"90308490"})
AADD(aMP563,{"90308990"})
AADD(aMP563,{"90309090"})
AADD(aMP563,{"90311000"})
AADD(aMP563,{"90312010"})
AADD(aMP563,{"90312090"})
AADD(aMP563,{"90314100"})
AADD(aMP563,{"90314910"})
AADD(aMP563,{"90314920"})
AADD(aMP563,{"90314990"})
AADD(aMP563,{"90318011"})
AADD(aMP563,{"90318012"})
AADD(aMP563,{"90318020"})
AADD(aMP563,{"90318030"})
AADD(aMP563,{"90318040"})
AADD(aMP563,{"90318050"})
AADD(aMP563,{"90318060"})
AADD(aMP563,{"90318091"})
AADD(aMP563,{"90318099"})
AADD(aMP563,{"90319010"})
AADD(aMP563,{"90319090"})
AADD(aMP563,{"90321010"})
AADD(aMP563,{"90321090"})
AADD(aMP563,{"90322000"})
AADD(aMP563,{"90328100"})
AADD(aMP563,{"90328911"})
AADD(aMP563,{"90329010"})
AADD(aMP563,{"90329099"})
AADD(aMP563,{"90330000"})
AADD(aMP563,{"91040000"})
AADD(aMP563,{"91070010"})
AADD(aMP563,{"91091000"})
AADD(aMP563,{"94012000"})
AADD(aMP563,{"94018000"})
AADD(aMP563,{"94049000"})
AADD(aMP563,{"94051093"})
AADD(aMP563,{"94051099"})
AADD(aMP563,{"94052000"})
AADD(aMP563,{"94059100"})
AADD(aMP563,{"94060010"})
AADD(aMP563,{"94060092"})
AADD(aMP563,{"95066200"})
AADD(aMP563,{"95069100"})
AADD(aMP563,{"96138000"})

Return 


