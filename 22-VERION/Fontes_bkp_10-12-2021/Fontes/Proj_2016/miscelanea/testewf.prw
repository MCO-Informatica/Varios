User Function testewf()

Local oHTML
//Crio o objeto oProcess, que recebe a inicializa??o da classe TWFProcess. Repare que o primeiro Par?metro ? o c?digo do processo que cadastramos acima e o segundo uma descri??o qualquer.
oProcess := TWFProcess():New( "PRECOS", "Atualizacao de Precos" )

//Crio uma task. Um Processo pode ter v?rias Tasks(tarefas). Para cada Task informo um nome para ela e o HTML envolvido. Repare que o path do HTML ? sempre abaixo do RootPath do Microsiga Protheus?.
oProcess:NewTask( "PRECOS01", "\WORKFLOW\wflink.HTMl" )

//Informo o t?tulo do e-mail.
oProcess:cSubject := "Atualizacao de Precos"       
oProcess:cBody := "Testando..."

//Informo qual fun??o o Workflow executar? ao ler a resposta do usu?rio.
//oProcess:bReturn := "U_CURSO01R()"

//Informo o tempo de espera m?ximo para a resposta do usu?rio e a fun??o a ser executada caso este tempo seja ultrapassado.
//oProcess:bTimeOut := {{"U_CURSO01T()",0, 0, 5 }}

//Simplesmente passo o valor da propriedade oProcess:oHTML  para uma vari?vel local para facilitar
oHTML := oProcess:oHTML

//Come?o a preencher os valores do HTML. Inicialmente preencho o objeto DATA(no Html %DATA%) com a data base do sistema.
//oHTML:ValByName('DATA',dDataBase)

//Preencho os itens da tabela : C?digo, Descri??o do Produto e pre?o.
//dbSelectArea("SB1")
//aadd((oHtml:valByName('TB.CODIGO')),B1_COD)
//aadd((oHtml:valByName('TB.DESCRICAO')),B1_DESC)  
//aadd((oHtml:valByName('TB.PRECO')),TRANSFORM( B1_PRV1,'@E 99,999.99' ))    

//Informo para qual endere?o(s) vai o e-mail
oProcess:cTo := "Cavalini"

//Informo o c?digo do usu?rio no Microsiga Protheus? que receber? o e-mail. Isto ? ?til para usar a consulta de Processos por usu?rio.
//oProcess:UserSiga := "000000"            

//Coloco aqui um ponto de Rastreabilidade. Os dois primeiros par?metros s?o sempre os abaixo passados e o terceiro indica o c?digo do Status acima cadastrado.
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001')  

//Aqui fa?o a grava??o do ID do Processo (que ? gerado pelo Workflow e ?nico para cada processo) em um campo criado pelo usu?rio nesta tabela. Isto servir? para rastrear qual processo est? ligado a determinado produto. ? este c?digo que dever? ser informado na caixa de ID da tela de rastreabilidade.
//RecLock('SB1')
//SB1->B1_WFID := oProcess:fProcessID
//MsUnlock()

//Inicio o Processo, enviando o e-mail.
oProcess:Start()

Return .T.