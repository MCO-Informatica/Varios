var idSelecao; //ultima linha clicada
var imgStatus;
var isValid1E;
var isValid1S;
var isValid2E;
var isValid2S;
var isValid3E;
var isValid3S;
var isValid4E;
var isValid4S;
var lChamaEdicao = false;
var linMarcArray;
var lReaponta;
var marcacao;
var marcacaoDia;
var numeroMar = 0;
var table = []; //objeto da tabela de marcacao

/*função que inicia ao carregar pagina*/
$(document).ready(function () {
	paramMarc();

	if (LoadColaborador()) {
		document.getElementById("btnAcao").innerHTML = 'Enviar apontamento';
		$("#panel_aprovar_reprovar").css("display", "none");

		loadMask();
		loadNeg();
		loadPos();

		$('#datatabledetalhenegativomarcacao').DataTable({
			language: {
				info: "",
				search: "Pesquisar",
				"zeroRecords": "Nenhum registro encontrado",
				"info": "Exibindo página de _PAGE_ a _PAGES_",
				"infoEmpty": "Nenhum registro encontrado"
			},
			processing: false,
			responsive: true,
			searching: false,
			serverSide: false,
			bPaginate: false,
			displayStart: 0,
			pageLenght: 40,
			order: [0, 'asc'],
			columnDefs: [{
				targets: [0, 1, 2, 3, 4, 5, 6],
				orderable: false
			}]
		});

		$('#datatabledetalhepositivomarcacao').DataTable({
			language: {
				info: "",
				search: "Pesquisar",
				"zeroRecords": "Nenhum registro encontrado",
				"info": "Exibindo página de _PAGE_ a _PAGES_",
				"infoEmpty": "Nenhum registro encontrado"
			},
			processing: false,
			responsive: true,
			searching: false,
			serverSide: false,
			bPaginate: false,
			displayStart: 0,
			pageLenght: 40,
			order: [0, 'asc'],
			columnDefs: [{
				targets: [0, 1, 2, 3, 4, 5, 6],
				orderable: false
			}]
		});

		/*Carrega marcacoes*/
		loadMarcacao();

		$("select[name='selStatus']").on('change', function () {
			table.draw();
			desabilitaRadio();
		});

		$('#loading').on('hidden.bs.modal', function (e) {
			document.getElementById("bodyPage").style.paddingRight = "0px";
		})

		$("#1E").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "1E")) {
				
				$('#div1E').removeClass('has-success');
				$('#div1E').addClass('has-error');
				
				$('#group-1E').removeClass('has-success');
				$('#group-1E').addClass('has-error');

				$('#up-1E').removeClass('btn-default');
				$('#up-1E').removeClass('btn-success');
				$('#up-1E').addClass('btn-danger');

				$('#down-1E').removeClass('btn-default');
				$('#down-1E').removeClass('btn-success');
				$('#down-1E').addClass('btn-danger');
				
				$(this).focus();
				isValid1E = false;
			} else {
				$('#div1E').removeClass('has-error');
				$('#div1E').addClass('has-success');
				
				$('#group-1E').removeClass('has-error');
				$('#group-1E').addClass('has-success');

				
				$('#up-1E').removeClass('btn-default');
				$('#up-1E').removeClass('btn-danger');
				$('#up-1E').addClass('btn-success');
				
				$('#down-1E').removeClass('btn-default');
				$('#down-1E').removeClass('btn-danger');
				$('#down-1E').addClass('btn-success');
				
				isValid1E = true;
			}
		});

		$("#1S").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "1S")) {
				$('#div1S').removeClass('has-success');
				$('#div1S').addClass('has-error');
				
				$('#group-1S').removeClass('has-success');
				$('#group-1S').addClass('has-error');

				$('#up-1S').removeClass('btn-default');
				$('#up-1S').removeClass('btn-success');
				$('#up-1S').addClass('btn-danger');

				$('#down-1S').removeClass('btn-default');
				$('#down-1S').removeClass('btn-success');
				$('#down-1S').addClass('btn-danger');				
				
				$(this).focus();
				isValid1S = false;
			} else {
				$('#div1S').removeClass('has-error');
				$('#div1S').addClass('has-success');
				
				$('#group-1S').removeClass('has-error');
				$('#group-1S').addClass('has-success');
				
				$('#up-1S').removeClass('btn-default');
				$('#up-1S').removeClass('btn-danger');
				$('#up-1S').addClass('btn-success');
				
				$('#down-1S').removeClass('btn-default');
				$('#down-1S').removeClass('btn-danger');
				$('#down-1S').addClass('btn-success');				
				
				isValid1S = true;
			}
		});

		$("#2E").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "2E")) {
				$('#div2E').removeClass('has-success');
				$('#div2E').addClass('has-error');
				
				$('#group-2E').removeClass('has-success');
				$('#group-2E').addClass('has-error');

				$('#up-2E').removeClass('btn-default');
				$('#up-2E').removeClass('btn-success');
				$('#up-2E').addClass('btn-danger');

				$('#down-2E').removeClass('btn-default');
				$('#down-2E').removeClass('btn-success');
				$('#down-2E').addClass('btn-danger');					
				
				$(this).focus();
				isValid2E = false;
			} else {
				$('#div2E').removeClass('has-error');
				$('#div2E').addClass('has-success');
				
				$('#group-2E').removeClass('has-error');
				$('#group-2E').addClass('has-success');
				
				$('#up-2E').removeClass('btn-default');
				$('#up-2E').removeClass('btn-danger');
				$('#up-2E').addClass('btn-success');
				
				$('#down-2E').removeClass('btn-default');
				$('#down-2E').removeClass('btn-danger');
				$('#down-2E').addClass('btn-success');					
				
				isValid2E = true;
			}
		});

		$("#2S").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "2S")) {
				$('#div2S').removeClass('has-success');
				$('#div2S').addClass('has-error');
				
				$('#group-2S').removeClass('has-success');
				$('#group-2S').addClass('has-error');

				$('#up-2S').removeClass('btn-default');
				$('#up-2S').removeClass('btn-success');
				$('#up-2S').addClass('btn-danger');

				$('#down-2S').removeClass('btn-default');
				$('#down-2S').removeClass('btn-success');
				$('#down-2S').addClass('btn-danger');	
				
				$(this).focus();
				isValid2S = false;
			} else {
				$('#div2S').removeClass('has-error');
				$('#div2S').addClass('has-success');
				
				$('#group-2S').removeClass('has-error');
				$('#group-2S').addClass('has-success');
				
				$('#up-2S').removeClass('btn-default');
				$('#up-2S').removeClass('btn-danger');
				$('#up-2S').addClass('btn-success');
				
				$('#down-2S').removeClass('btn-default');
				$('#down-2S').removeClass('btn-danger');
				$('#down-2S').addClass('btn-success');		
				
				isValid2S = true;
			}
		});

		$("#3E").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "3E")) {
				$('#div3E').removeClass('has-success');
				$('#div3E').addClass('has-error');
				
				$('#group-3E').removeClass('has-success');
				$('#group-3E').addClass('has-error');

				$('#up-3E').removeClass('btn-default');
				$('#up-3E').removeClass('btn-success');
				$('#up-3E').addClass('btn-danger');

				$('#down-3E').removeClass('btn-default');
				$('#down-3E').removeClass('btn-success');
				$('#down-3E').addClass('btn-danger');					
				
				$(this).focus();
				isValid3E = false;
			} else {
				$('#div3E').removeClass('has-error');
				$('#div3E').addClass('has-success');
				
				$('#group-3E').removeClass('has-error');
				$('#group-3E').addClass('has-success');
				
				$('#up-3E').removeClass('btn-default');
				$('#up-3E').removeClass('btn-danger');
				$('#up-3E').addClass('btn-success');
				
				$('#down-3E').removeClass('btn-default');
				$('#down-3E').removeClass('btn-danger');
				$('#down-3E').addClass('btn-success');					
				
				isValid3E = true;
			}
		});

		$("#3S").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "3S")) {
				$('#div3S').removeClass('has-success');
				$('#div3S').addClass('has-error');
				
				$('#group-3S').removeClass('has-success');
				$('#group-3S').addClass('has-error');

				$('#up-3S').removeClass('btn-default');
				$('#up-3S').removeClass('btn-success');
				$('#up-3S').addClass('btn-danger');

				$('#down-3S').removeClass('btn-default');
				$('#down-3S').removeClass('btn-success');
				$('#down-3S').addClass('btn-danger');					
				
				$(this).focus();
				isValid3S = false;
			} else {
				$('#div3S').removeClass('has-error');
				$('#div3S').addClass('has-success');
				
				$('#group-3S').removeClass('has-error');
				$('#group-3S').addClass('has-success');
				
				$('#up-3S').removeClass('btn-default');
				$('#up-3S').removeClass('btn-danger');
				$('#up-3S').addClass('btn-success');
				
				$('#down-3S').removeClass('btn-default');
				$('#down-3S').removeClass('btn-danger');
				$('#down-3S').addClass('btn-success');					
				
				isValid3S = true;
			}
		});

		$("#4E").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "4E")) {
				$('#div4E').removeClass('has-success');
				$('#div4E').addClass('has-error');
				
				$('#group-4E').removeClass('has-success');
				$('#group-4E').addClass('has-error');

				$('#up-4E').removeClass('btn-default');
				$('#up-4E').removeClass('btn-success');
				$('#up-4E').addClass('btn-danger');

				$('#down-4E').removeClass('btn-default');
				$('#down-4E').removeClass('btn-success');
				$('#down-4E').addClass('btn-danger');					
				
				$(this).focus();
				isValid4E = false;
			} else {
				$('#div4E').removeClass('has-error');
				$('#div4E').addClass('has-success');
				
				$('#group-4E').removeClass('has-error');
				$('#group-4E').addClass('has-success');
				
				$('#up-4E').removeClass('btn-default');
				$('#up-4E').removeClass('btn-danger');
				$('#up-4E').addClass('btn-success');
				
				$('#down-4E').removeClass('btn-default');
				$('#down-4E').removeClass('btn-danger');
				$('#down-4E').addClass('btn-success');					
				
				isValid4E = true;
			}
		});

		$("#4S").focusout(function () {
			var value = $(this).val();
			if (isEmpty(value)) {
				return;
			}
			if (!checkTime(value, "4S")) {
				$('#div4S').removeClass('has-success');
				$('#div4S').addClass('has-error');
				
				$('#group-4S').removeClass('has-success');
				$('#group-4S').addClass('has-error');

				$('#up-4S').removeClass('btn-default');
				$('#up-4S').removeClass('btn-success');
				$('#up-4S').addClass('btn-danger');

				$('#down-4S').removeClass('btn-default');
				$('#down-4S').removeClass('btn-success');
				$('#down-4S').addClass('btn-danger');					
				
				$(this).focus();
				isValid4S = false;
			} else {
				$('#div4S').removeClass('has-error');
				$('#div4S').addClass('has-success');
				
				$('#group-4S').removeClass('has-error');
				$('#group-4S').addClass('has-success');
				
				$('#up-4S').removeClass('btn-default');
				$('#up-4S').removeClass('btn-danger');
				$('#up-4S').addClass('btn-success');
				
				$('#down-4S').removeClass('btn-default');
				$('#down-4S').removeClass('btn-danger');
				$('#down-4S').addClass('btn-success');					
				
				isValid4S = true;
			}
		});

		var text_max = 100;
		$('#horaNegativoJustificativa').keyup(function () {
			var text_length = $('#horaNegativoJustificativa').val().length;
			var text_remaining = text_max - text_length;
			$('#countNegativa').html(text_remaining);
		});

		$('#horaPositivaJustificativa').keyup(function () {
			var text_length = $('#horaPositivaJustificativa').val().length;
			var text_remaining = text_max - text_length;
			$('#countPositivo').html(text_remaining);
		});

		montarTitPer();

		$('#search-inp').on('keyup', function () {
			table.search($(this).val()).draw();
		});
		validGrupoAprov();
	}
});

/*Filtro da tabela de marcacao*/
$.fn.dataTable.ext.search.push(
	function (settings, data, dataIndex) {
		if (settings.sTableId == "datatable-marcacao") {
			var selecao = parseInt($('#selStatus').val(), 10);
			if (selecao == "99") {
				return true;
			}

			if (data.length > 1) {
				var status = marcacao[dataIndex].status;

				if (selecao == status) {
					return true;
				}
			}

			return false;
		} else {
			return true;
		}
	}
);

/*Volta para pagina anterior*/
$("#link-voltar").click(function () {
	window.top.location = cPaginaInicial + "/ponto_eletronico/lista_periodo.htm";
});

/*Tela modal de aprovacao*/
function perguntaAprovacao() {
	$("#modalConfirmar").modal('show');
}

/*Remove acentos de caracteres*/
function removerAcentos(newStringComAcento) {
	var string = newStringComAcento;
	var mapaAcentosHex = {
		a: /[\xE0-\xE6]/g,
		A: /[\xC0-\xC6]/g,
		e: /[\xE8-\xEB]/g,
		E: /[\xC8-\xCB]/g,
		i: /[\xEC-\xEF]/g,
		I: /[\xCC-\xCF]/g,
		o: /[\xF2-\xF6]/g,
		O: /[\xD2-\xD6]/g,
		u: /[\xF9-\xFC]/g,
		U: /[\xD9-\xDC]/g,
		c: /\xE7/g,
		C: /\xC7/g,
		n: /\xF1/g,
		N: /\xD1/g
	};

	for (var letra in mapaAcentosHex) {
		var expressaoRegular = mapaAcentosHex[letra];
		string = string.replace(expressaoRegular, letra);
	}
	string = string.replace(/(\r\n|\n|\r)/gm, "");

	return string;
}

/*Carrega marcacoes do colaborador*/
function loadMarcacao(aprovador) {
	$("#loading").modal('show');

	loadTabelaMarcacao();
	$.ajax({
		url: "U_Ajax012.APW",
		async: true,
		data: {
			"idkey": idkey,
			"cperiodo": cperiodo
		},
		success: function (json) {
			json = json.replace(trataerror1, '');
			if (!isEmpty(json)) {
				var jsonMarcacao = $.parseJSON(json);

				marcacao = jsonMarcacao.marcacao;
				loadTabelaMarcacao();
			}
			$("#loading").modal('hide');
		},
		error: function (jqXHR, textStatus, errorThrown) {
			deslogar('Erro de conexão com servidor. Você será deslogado.');
		}
	});
}

/*Carrega tabela com marcações/apontamentos do funcionário*/
function loadTabelaMarcacao() {
	var linha = 0;

	//Carrega tabela de marcações
	//var acoesRelacionadas = MontarAjustarMarcacao('ajustarMarcacao(0);', 'Editar Marcação');
	$('#datatable-marcacao').DataTable().destroy();
	table = $('#datatable-marcacao').DataTable({
		data: marcacao,
		processing: false,
		responsive: true,
		searching: true,
		serverSide: false,
		bPaginate: false,
		pageLenght: 40,
		autoWidth: false,
		deferRender: true,
		ordering: false,
		paging: false,
		info: false,
		sDom: '<"top">t<"bottom"ilp<"clear">>',
		order: [
			[1, "asc"]
		],
		language: {
			info: "",
			search: "Pesquisar",
			"zeroRecords": "Nenhum registro encontrado",
			"zeroRecords": "Nenhum registro encontrado",
			"info": "Exibindo página de _PAGE_ a _PAGES_",
			"infoEmpty": "Nenhum registro encontrado"
		},
		columnDefs: [
			{
				targets: [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
                createdCell: function (td, cellData, rowData, row, col) {
                    $(td).css('padding', '2px')
                }
            },			
			{
				targets: 0,
				render: function (data, type, row) {
					return '';
				}
			}, 
			{
				targets: 1,
				data: null,
				orderable: false,
				width: "3%",
				render: function (data, type, row) {
					var textoAux = "";					
					var startDate = parseInt( $("#admissao").text().substring(6, 9)+$("#admissao").text().substring(3, 5)+$("#admissao").text().substring(0, 2) );
					var endDate = parseInt( row.data.substring(6, 9)+row.data.substring(3, 5)+row.data.substring(0, 2) );
					if( startDate <= endDate ) {
						textoAux += "<div class='btn-group' >";
						textoAux += "<button id='botaoAR' class='btn-default btn dropdown-toggle' type='button' data-toggle='dropdown'>";
						textoAux += "   <span class='glyphicon glyphicon-triangle-bottom' ></span>";
						textoAux += "</button>";
						textoAux += "<ul id='submenAR' class='dropdown-menu ' role='menu' >";
						textoAux += "<li><a tabindex='-1' href='#void' onclick='ajustarMarcacao(0);'>Editar Marcação</a></li>";
						textoAux += "</ul>";
						textoAux += "</div>";
					}			
					return textoAux;				
				}
			}, 
			{
				aTargets: [2,10,14],
				width: "3%",
				render: function (data, type, row) {
					imgStatus = '';
					if (data == 0) {
						imgStatus = "<img src='imagens-rh/br_cinza_ocean.png' border='0' data-toggle='tooltip' title='Sem altera&ccedil;&atilde;o' class='center'>";
					} else if (data == 1) {
						imgStatus = "<img src='imagens-rh/br_azul_ocean.png' border='0' data-toggle='tooltip' title='Em manuten&ccedil;&atilde;o' class='center'>";
					} else if (data == 2) {
						imgStatus = "<img src='imagens-rh/br_amarelo_ocean.png' border='0' data-toggle='tooltip' title='Aguardando Aprova&ccedil;&atilde;o' class='center'>";
					} else if (data == 3) {
						imgStatus = "<img src='imagens-rh/br_verde_ocean.png' border='0' data-toggle='tooltip' title='Aprovado' class='center'>";
					} else if (data == 4) {
						imgStatus = "<img src='imagens-rh/br_vermelho_ocean.png' border='0' data-toggle='tooltip' title='Reprovado' class='center'>";
					} else if (data == 5) {
						imgStatus = "<img src='imagens-rh/br_pink_ocean.png' border='0' data-toggle='tooltip' title='Alterado pelo Sistema' class='center'>";
					} else if (data == 6) {
						imgStatus = "<img src='imagens-rh/br_preto_ocean.png' border='0' data-toggle='tooltip' title='N&atilde;o justificado' class='center'>";
					} else if (data == 7) {
						imgStatus = "<img src='imagens-rh/br_laranja_ocean.png' border='0' data-toggle='tooltip' title='N&atilde;o justificado' class='center'>";
					} else if (data == 8) {
						imgStatus = "<img src='imagens-rh/br_branco_ocean.png' border='0' data-toggle='tooltip' title='N&atilde;o justificado' class='center'>";
					}
					return imgStatus;
				}
			}, 
			{
				aTargets: [48],
				width: "3%",
				render: function (data, type, row) {
					imgStatus = '';
					if (!isEmpty(data)) {
						imgStatus = "<span  class='glyphicon glyphicon-exclamation-sign' style='color:orange; padding:0px;' data-toggle='popover' title='Informativo' data-content='" + data + "' data-placement='left'></span>";
					}
					return imgStatus;
				}
			}, 
			{
			aTargets: [4],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T1E"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [5],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T1S"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [6],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T2E"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [7],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T2S"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [8],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T3E"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [10],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T3S"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [60],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T4E"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [61],
			render: function (data, type, row, meta) {
				var var_obj;
				if (row["T4S"].trim() == "N") {
					var_obj = '<span class="negativo"  data-toggle="popover" data-container="body"  title="Marca&ccedil;&atilde;o manual" data-placement="right" data-content="Inclu&iacute;do manualmente" >' + data + '</span>'
				} else {
					var_obj = data;
				}
				return var_obj;
			}
		}, 
			{
			aTargets: [11],
			render: function (data, type, row, meta) {
				imgStatus = data + "<a href='#' data-row='" + meta.row + "' class='button-neg' ><img src='imagens-rh/information2.png' border='0' data-toggle='tooltip' title='Detalhes do apontamento' style='width:17px;margin-left:6px;margin-top:-3px'></a>";
				return imgStatus;
			}
		}, 
			{
			aTargets: [15],
			render: function (data, type, row, meta) {
				imgStatus = data + "<a href='#' data-row='" + meta.row + "' class='button-pos'><img src='imagens-rh/information2.png' border='0' data-toggle='tooltip' title='Detalhes do apontamento' style='width:17px;margin-left:6px;margin-top:-3px'></a>";
				return imgStatus;
			}
		}, 
			{
			aTargets: [13],
			render: function (data, type, row, meta) {
				var ret;
				var texto = (data);
				var textoMenor = texto.substring(0, 20);
				ret = '<span data-toggle="popover" data-container="body"  title="Justificativa das horas negativas" data-placement="left" data-content="' + texto + '">' + textoMenor + '</span>';
				return ret;
			}
		}, 
			{
				aTargets: [17],
				width: "12%",
				render: function (data, type, row, meta) {
					var ret;
					var texto = (data);
					var textoMenor = texto.substring(0, 20);
					ret = '<span data-toggle="popover" data-container="body"  title="Justificativa das horas positivas" data-placement="left" data-content="' + texto + '">' + textoMenor + '</span>';
					return ret;
				}
			}, 
			{
				targets: [0, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62],
				visible: false
			}, 
			{
                targets: '_all',
				orderable: false
			}, 
			{
				targets: [0],
				width: "0.2%"
			}, 
			{
				targets: [3],
				width: "10%"
			}, 
			{
				targets: [4],
				className: "normalleft"
			}, 
			{
				targets: [10],
				className: "negativoleft"
			}, 
			{
				targets: [9, 10, 11, 12],
				className: "negativo"
			}, 
			{
				targets: [13],
				className: "negativoright"
			}, 
			{
				targets: [14, 15, 16, 17],
				className: "positivo"
			},
			{
				aTargets: [12],
				width: "8%",
				render: function (data, type, row, meta) {
					var ret;
					var texto = (data);
					var textoMenor = texto.substring(0, 15);
					ret = '<span data-toggle="popover" data-container="body"  title="Evento das horas negativas" data-placement="left" data-content="' + texto + '">' + textoMenor + '</span>';
					return ret;
				}
			},
			{
				aTargets: [16],
				width: "8%",
				render: function (data, type, row, meta) {
					var ret;
					var texto = (data);
					var textoMenor = texto.substring(0, 15);
					ret = '<span data-toggle="popover" data-container="body"  title="Evento das horas positivas" data-placement="left" data-content="' + texto + '">' + textoMenor + '</span>';
					return ret;
				}
			}				
		],
		columns: [{}, //0
			{}, //1
			{
				name: "status",
				data: "status"
			}, //2
			{
				name: "dataext",
				data: "dataext"
			}, //3
			{
				name: "1E",
				data: "1E"
			}, //4
			{
				name: "1S",
				data: "1S"
			}, //5
			{
				name: "2E",
				data: "2E"
			}, //6
			{
				name: "2S",
				data: "2S"
			}, //7
			{
				name: "3E",
				data: "3E"
			}, //8 
			{
				name: "3S",
				data: "3S"
			}, //9 
			{
				name: "statusAtraso",
				data: "statusAtraso"
			}, //10
			{
				name: "horaNegValor",
				data: "horaNegValor"
			}, //11
			{
				name: "DESCEVENEG",
				data: "DESCEVENEG"
			}, //12
			{
				name: "horaNegJustificativa",
				data: "horaNegJustificativa"
			}, //13
			{
				name: "statusHE",
				data: "statusHE"
			}, //14
			{
				name: "horaPosValor",
				data: "horaPosValor"
			}, //15
			{
				name: "DESCEVEPOS",
				data: "DESCEVEPOS"
			}, //16
			{
				name: "horaPosJustificativa",
				data: "horaPosJustificativa"
			}, //17
			{
				name: "versao",
				data: "versao"
			}, //18
			{
				name: "calend1EHr",
				data: "calend1EHr"
			}, //19
			{
				name: "calend1ETp",
				data: "calend1ETp"
			}, //20
			{
				name: "calend1SHr",
				data: "calend1SHr"
			}, //21
			{
				name: "calend1STp",
				data: "calend1STp"
			}, //22
			{
				name: "calend2EHr",
				data: "calend2EHr"
			}, //23
			{
				name: "calend2ETp",
				data: "calend2ETp"
			}, //24
			{
				name: "calend2SHr",
				data: "calend2SHr"
			}, //25
			{
				name: "calend2STp",
				data: "calend2STp"
			}, //26
			{
				name: "calend3EHr",
				data: "calend3EHr"
			}, //27
			{
				name: "calend3ETp",
				data: "calend3ETp"
			}, //28
			{
				name: "calend3SHr",
				data: "calend3SHr"
			}, //29
			{
				name: "calend3STp",
				data: "calend3STp"
			}, //30 
			{
				name: "calend4EHr",
				data: "calend4EHr"
			}, //31
			{
				name: "calend4ETp",
				data: "calend4ETp"
			}, //32 
			{
				name: "calend4SHr",
				data: "calend4SHr"
			}, //33
			{
				name: "calend4STp",
				data: "calend4STp"
			}, //34
			{
				name: "ordem",
				data: "ordem"
			}, //35
			{
				name: "aponta",
				data: "aponta"
			}, //36
			{
				name: "peraponta",
				data: "peraponta"
			}, //37
			{
				name: "turno",
				data: "turno"
			}, //38
			{
				name: "justificativaMarcacao",
				data: "justificativaMarcacao"
			}, //39
			{
				name: "M1E",
				data: "M1E"
			}, //40
			{
				name: "M1S",
				data: "M1S"
			}, //41
			{
				name: "M2E",
				data: "M2E"
			}, //42
			{
				name: "M2S",
				data: "M2S"
			}, //43
			{
				name: "M3E",
				data: "M3E"
			}, //44
			{
				name: "M3S",
				data: "M3S"
			}, //45
			{
				name: "M4E",
				data: "M4E"
			}, //46
			{
				name: "M4S",
				data: "M4S"
			}, //47
			{
				name: "AFASTAMENTO",
				data: "AFASTAMENTO"
			}, //48
			{
				name: "T1E",
				data: "T1E"
			}, //49
			{
				name: "T1S",
				data: "T1S"
			}, //50
			{
				name: "T2E",
				data: "T2E"
			}, //51
			{
				name: "T2S",
				data: "T2S"
			}, //52
			{
				name: "T3E",
				data: "T3E"
			}, //53
			{
				name: "T3S",
				data: "T3S"
			}, //54
			{
				name: "T4E",
				data: "T4E"
			}, //55
			{
				name: "T4S",
				data: "T4S"
			}, //56
			{
				name: "id",
				data: "id"
			}, //57
			{
				name: "horaNegEvento",
				data: "horaNegEvento"
			}, //58
			{
				name: "horaPosEvento",
				data: "horaPosEvento"
			}, //59
			{
				name: "4E",
				data: "4E"
			}, //60
			{
				name: "4S",
				data: "4S"
			}, //61
			{
				name: "data",
				data: "data"
			}, //62
		],
		"fnDrawCallback": function () {
			var options = {
				trigger: 'hover focus'
			}
			var p = $('[data-toggle="popover"]').popover(options);
			p.on("show.bs.popover", function (e) {
				p.data("bs.popover").tip().css({
					"max-width": "350px"
				});
			});
		},
		"createdRow": function( row, data, dataIndex){
			if( data["calend1EHr"] != "0" ){
				//if (  data["1E"] == ""){
					//$(row).css("background-color", "#fff8eb");	
				//} else {
					$(row).css("background-color", "#fff");	
				//}
				
			} else {
				$(row).css("background-color", "#f5f5f5");
				$(row).css("border-bottom", "1px solid #CCCCCC;");
			}
        }
	});

	//Captura id da linha clicada
	$('#datatable-marcacao tbody').on('click', 'tr', function () {
		var data = table.row(this).data();
		if (data != undefined) {
			idSelecao = data['id'];
		}
	});

	$('.button-neg').click(function (event) {
		event.preventDefault();
		callmodaleventNeg($(this).attr('data-row'));
	});

	$('.button-pos').click(function (event) {
		event.preventDefault();
		callmodaleventPos($(this).attr('data-row'));
	});
}

//função para chamada da tela de alteraçãod e marcação / apontamento
function ajustarMarcacao(nLinhaAjusta) {
	$("#panelAguardandoAjusteMarcacao").css("display", "none");
	$("#panelApontamentoJustificativa").css("display", "block");
	$('#div1E').removeClass('has-success');
	$('#div1E').removeClass('has-error');
	$('#div1S').removeClass('has-success');
	$('#div1S').removeClass('has-error');
	$('#div2E').removeClass('has-success');
	$('#div2E').removeClass('has-error');
	$('#div2S').removeClass('has-success');
	$('#div2S').removeClass('has-error');
	$('#div3E').removeClass('has-success');
	$('#div3E').removeClass('has-error');
	$('#div3S').removeClass('has-success');
	$('#div3S').removeClass('has-error');
	$('#div4E').removeClass('has-success');
	$('#div4E').removeClass('has-error');
	$('#div4S').removeClass('has-success');
	$('#div4S').removeClass('has-error');
	
	$('#group-1E').removeClass('has-success');
	$('#group-1E').removeClass('has-error');	
	$('#group-1S').removeClass('has-success');
	$('#group-1S').removeClass('has-error');	
	$('#group-2E').removeClass('has-success');
	$('#group-2E').removeClass('has-error');
	$('#group-2S').removeClass('has-success');
	$('#group-2S').removeClass('has-error');
	$('#group-3E').removeClass('has-success');
	$('#group-3E').removeClass('has-error');
	$('#group-3S').removeClass('has-success');
	$('#group-3S').removeClass('has-error');	
	$('#group-4E').removeClass('has-success');
	$('#group-4E').removeClass('has-error');
	$('#group-4S').removeClass('has-success');
	$('#group-4S').removeClass('has-error');

	$('#up-1E').removeClass('btn-success');
	$('#up-1E').removeClass('btn-error');	
	$('#up-1S').removeClass('btn-success');
	$('#up-1S').removeClass('btn-error');	
	$('#up-2E').removeClass('btn-success');
	$('#up-2E').removeClass('btn-error');
	$('#up-2S').removeClass('btn-success');
	$('#up-2S').removeClass('btn-error');
	$('#up-3E').removeClass('btn-success');
	$('#up-3E').removeClass('btn-error');
	$('#up-3S').removeClass('btn-success');
	$('#up-3S').removeClass('btn-error');	
	$('#up-4E').removeClass('btn-success');
	$('#up-4E').removeClass('btn-error');
	$('#up-4S').removeClass('btn-success');
	$('#up-4S').removeClass('btn-error');
	
	$('#down-1E').removeClass('btn-success');
	$('#down-1E').removeClass('btn-error');	
	$('#down-1S').removeClass('btn-success');
	$('#down-1S').removeClass('btn-error');	
	$('#down-2E').removeClass('btn-success');
	$('#down-2E').removeClass('btn-error');
	$('#down-2S').removeClass('btn-success');
	$('#down-2S').removeClass('btn-error');
	$('#down-3E').removeClass('btn-success');
	$('#down-3E').removeClass('btn-error');
	$('#down-3S').removeClass('btn-success');
	$('#down-3S').removeClass('btn-error');	
	$('#down-4E').removeClass('btn-success');
	$('#down-4E').removeClass('btn-error');
	$('#down-4S').removeClass('btn-success');
	$('#down-4S').removeClass('btn-error');
	
	$('#up-1E').addClass('btn-default');
	$('#up-1S').addClass('btn-default');
	$('#up-2E').addClass('btn-default');
	$('#up-2S').addClass('btn-default');
	$('#up-3E').addClass('btn-default');
	$('#up-3S').addClass('btn-default');
	$('#up-4E').addClass('btn-default');
	$('#up-4S').addClass('btn-default');
	
	$('#down-1E').addClass('btn-default');
	$('#down-1S').addClass('btn-default');
	$('#down-2E').addClass('btn-default');
	$('#down-2S').addClass('btn-default');
	$('#down-3E').addClass('btn-default');
	$('#down-3S').addClass('btn-default');
	$('#down-4E').addClass('btn-default');
	$('#down-4S').addClass('btn-default');
	
	//Busca por linha clicada
	if (nLinhaAjusta == 0) {
		linMarcArray = objectFindByKey(marcacao, 'id', idSelecao);
		marcacaoDia = marcacao[linMarcArray];
	} else {
		linMarcArray = nLinhaAjusta;
		marcacaoDia = marcacao[linMarcArray];
	}
	blockMarc(marcacaoDia);

	//titulo
	document.getElementById("tituloMarcDia").innerHTML = 'Marcações do dia '    + marcacaoDia['data'];
	document.getElementById("tituloAponDia").innerHTML = 'Apontamentos do dia ' + marcacaoDia['dataext'];
	if (!isEmpty(marcacaoDia["AFASTAMENTO"])) {
		document.getElementById("myModalLabel").innerHTML = '<span style="color:red">Editar Marcação: Afastamento/Atestado - ' + marcacaoDia["AFASTAMENTO"] + '</span>';
	} else {
		document.getElementById("myModalLabel").innerHTML = 'Editar Marcação';
	}

	//marcações
	document.getElementById("1E").value = marcacaoDia['1E'];
	document.getElementById("1S").value = marcacaoDia['1S'];
	document.getElementById("2E").value = marcacaoDia['2E'];
	document.getElementById("2S").value = marcacaoDia['2S'];
	document.getElementById("3E").value = marcacaoDia['3E'];
	document.getElementById("3S").value = marcacaoDia['3S'];
	document.getElementById("4E").value = marcacaoDia['4E'];
	document.getElementById("4S").value = marcacaoDia['4S'];

	//apontamentos negativos
	document.getElementById("hrNegVal").innerHTML = marcacaoDia['horaNegValor'];
	document.getElementById("eventoNegativo").value = marcacaoDia['horaNegEvento'];
	document.getElementById("eventoNegativoDesc").value = marcacaoDia['DESCEVENEG'];
	document.getElementById("horaNegativoJustificativa").value = marcacaoDia['horaNegJustificativa'];

	//apontamentos positivos
	document.getElementById("hrPosVal").innerHTML = marcacaoDia['horaPosValor'];
	document.getElementById("eventoPositivo").value = marcacaoDia['horaPosEvento'];
	document.getElementById("eventoPositivoDesc").value = marcacaoDia['DESCEVEPOS'];
	document.getElementById("horaPositivaJustificativa").value = marcacaoDia['horaPosJustificativa'];

	//chama tela de atelração de apontamento e marcação
	$('#countNegativa').html(100 - $('#horaNegativoJustificativa').val().length);
	$('#countPositivo').html(100 - $('#horaPositivaJustificativa').val().length);

	//telaDecisaoEdicao();
	$("#buttonReverter").prop("disabled", true);
	janelaEscolhaEdicao( 2 );

	$("#myModal").modal();
}

$("#buttonGravarAlt").click( function( event){
	event.preventDefault();
	SavePB7();
});

/*Chama rotina para gravação das marcaçãoes/apontamento*/
function SavePB7() {
	var nMarc;
	if (!checkAllMarc()) {
		$('#avisoMsg').val('Marc&ccedil;&atilde;o Inv&aacute;lida');
		$('#modalAviso').modal('show');
		return;
	}

	$("#myModal").modal('hide');
	$("#loading").modal('show');
	document.getElementById("loadingspan").innerHTML = "Gravando marcação/apontamento";

	marcacao[linMarcArray]["1E"] = document.getElementById("1E").value;
	marcacao[linMarcArray]["1S"] = document.getElementById("1S").value;
	marcacao[linMarcArray]["2E"] = document.getElementById("2E").value;
	marcacao[linMarcArray]["2S"] = document.getElementById("2S").value;
	marcacao[linMarcArray]["3E"] = document.getElementById("3E").value;
	marcacao[linMarcArray]["3S"] = document.getElementById("3S").value;
	marcacao[linMarcArray]["4E"] = document.getElementById("4E").value;
	marcacao[linMarcArray]["4S"] = document.getElementById("4S").value;
	marcacao[linMarcArray]["horaNegEvento"] = document.getElementById("eventoNegativo").value;
	marcacao[linMarcArray]["horaNegJustificativa"] = document.getElementById("horaNegativoJustificativa").value;
	marcacao[linMarcArray]["horaPosEvento"] = document.getElementById("eventoPositivo").value;
	marcacao[linMarcArray]["horaPosJustificativa"] = document.getElementById("horaPositivaJustificativa").value;

	var saveMarc = marcacao[linMarcArray];

	$.ajax({
		url: "U_Ajax013.APW",
		async: true,
		data: {
			"cdata": saveMarc["data"],
			"c1E": saveMarc["1E"],
			"c1S": saveMarc["1S"],
			"c2E": saveMarc["2E"],
			"c2S": saveMarc["2S"],
			"c3E": saveMarc["3E"],
			"c3S": saveMarc["3S"],
			"c4E": saveMarc["4E"],
			"c4S": saveMarc["4S"],
			"horaNegValor": saveMarc["horaNegValor"].replace(':', '.'),
			"horaNegEvento": removerAcentos(saveMarc["horaNegEvento"]),
			"horaNegJustificativa": removerAcentos(saveMarc["horaNegJustificativa"]),
			"horaPosValor": saveMarc["horaPosValor"].replace(':', '.'),
			"horaPosEvento": removerAcentos(saveMarc["horaPosEvento"]),
			"horaPosJustificativa": removerAcentos(saveMarc["horaPosJustificativa"]),
			"calend1EHr": saveMarc["calend1EHr"],
			"calend1ETp": saveMarc["calend1ETp"],
			"calend1SHr": saveMarc["calend1SHr"],
			"calend1STp": saveMarc["calend1STp"],
			"calend2EHr": saveMarc["calend2EHr"],
			"calend2ETp": saveMarc["calend2ETp"],
			"calend2SHr": saveMarc["calend2SHr"],
			"calend2STp": saveMarc["calend2STp"],
			"calend3EHr": saveMarc["calend3EHr"],
			"calend3ETp": saveMarc["calend3ETp"],
			"calend3SHr": saveMarc["calend3SHr"],
			"calend3STp": saveMarc["calend3STp"],
			"calend4EHr": saveMarc["calend4EHr"],
			"calend4ETp": saveMarc["calend4ETp"],
			"calend4SHr": saveMarc["calend4SHr"],
			"calend4STp": saveMarc["calend4STp"],
			"ordem": saveMarc["ordem"],
			"aponta": saveMarc["aponta"],
			"peraponta": saveMarc["peraponta"],
			"turno": saveMarc["turno"],
			"justificativaMarcacao": saveMarc["justificativaMarcacao"].replace("/", ""),
			"M1E": saveMarc["M1E"], //31
			"M1S": saveMarc["M1S"], //32
			"M2E": saveMarc["M2E"], //33
			"M2S": saveMarc["M2S"], //34
			"M3E": saveMarc["M3E"], //35
			"M3S": saveMarc["M3S"], //36
			"M4E": saveMarc["M4E"], //37
			"M4S": saveMarc["M4S"], //38				
			"status": saveMarc["status"], //39		
			"flagaponta": lReaponta, //39		
			"statusAtraso": saveMarc["statusAtraso"], //39		
			"statusHE": saveMarc["statusHE"] //39						
		},
		success: function (json) {
			json = json.replace(trataerror1, '');
			var jsonMarcacao = $.parseJSON(json);
			marcacao = jsonMarcacao.marcacao;
			loadTabelaMarcacao();
			$("#loading").modal('hide');
			if (lChamaEdicao) {
				$("#myModal").modal('show');
				ajustarMarcacao(linMarcArray);
			} //chama novamente tela de edição
		},
		error: function (jqXHR, textStatus, errorThrown) {
			deslogar('Erro de conexão com servidor. Você será deslogado.');
		}
	});

}

/*Tela de edicao da decisao tomada entre editar marcacao ou apontamento*/
function telaDecisaoEdicao() {
	if (!isEmpty(marcacaoDia["AFASTAMENTO"])) {
		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "none");
		$("#panelApontamentoJustificativa").css("display", "block");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		lChamaEdicao = false;
	} else if (numeroMar == 0 && (parseFloat(marcacaoDia['horaPosValor'].replace(":", ".")) > 0)) {
		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "none");
		$("#panelApontamentoJustificativa").css("display", "block");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		lChamaEdicao = false;
	} else if (numeroMar == 0 && (parseFloat(marcacaoDia['horaNegValor'].replace(":", ".")) > 0)) {
		if (isEmpty(document.getElementById("eventoNegativoDesc").value)) {
			$("#panelEscolhaEdicao").css("display", "block");
			$("#panelAguardandoAjusteMarcacao").css("display", "none");
			$("#panelApontamentoJustificativa").css("display", "none");
			$("#panelEditarMarcacao").css("display", "none");
			$("#botoesGravacao").css("display", "none");
			$("#botoesReverter").css("display", "none");
			$("#botoesEscolha").css("display", "block");
			
			document.getElementById("1E").removeAttribute("readOnly");
			document.getElementById("1S").removeAttribute("readOnly");
			document.getElementById("2E").removeAttribute("readOnly");
			document.getElementById("2S").removeAttribute("readOnly");
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			
			lChamaEdicao = true;
		} else {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").readOnly = true;
			document.getElementById("3E").readOnly = true;
			document.getElementById("3S").readOnly = true;
			document.getElementById("4E").readOnly = true;
			document.getElementById("4S").readOnly = true;
			$("#panelEscolhaEdicao").css("display", "none");
			$("#panelAguardandoAjusteMarcacao").css("display", "none");
			$("#panelApontamentoJustificativa").css("display", "block");
			$("#panelEditarMarcacao").css("display", "block");
			$("#botoesGravacao").css("display", "block");
			$("#botoesReverter").css("display", "block");
			$("#botoesEscolha").css("display", "none");
			lChamaEdicao = false;
		}
	} else if (numeroMar == 0 && (document.getElementById("eventoNegativo").value == 0)) {
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "block");
		$("#panelApontamentoJustificativa").css("display", "none");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");

		document.getElementById("1E").removeAttribute("readOnly");
		document.getElementById("1S").removeAttribute("readOnly");
		document.getElementById("2E").removeAttribute("readOnly");
		document.getElementById("2S").removeAttribute("readOnly");
		document.getElementById("3E").removeAttribute("readOnly");
		document.getElementById("3S").removeAttribute("readOnly");
		document.getElementById("4E").removeAttribute("readOnly");
		document.getElementById("4S").removeAttribute("readOnly");
		
		lChamaEdicao = true;
	} else if (numeroMar % 2 == 0) {
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "none");
		$("#panelApontamentoJustificativa").css("display", "block");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		lChamaEdicao = false;
	} else if (numeroMar % 2 != 0) {
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "block");
		$("#panelApontamentoJustificativa").css("display", "none");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		
		document.getElementById("1E").removeAttribute("readOnly");
		document.getElementById("1S").removeAttribute("readOnly");
		document.getElementById("2E").removeAttribute("readOnly");
		document.getElementById("2S").removeAttribute("readOnly");
		document.getElementById("3E").removeAttribute("readOnly");
		document.getElementById("3S").removeAttribute("readOnly");
		document.getElementById("4E").removeAttribute("readOnly");
		document.getElementById("4S").removeAttribute("readOnly");
		
		lChamaEdicao = true;
	}
}

function janelaEscolhaEdicao(nEscolha) {
	if (nEscolha == 1) {
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "block");
		$("#panelApontamentoJustificativa").css("display", "none");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		document.getElementById("buttonGravarAlt").removeAttribute("disabled");
		
		document.getElementById("1E").removeAttribute("readOnly");
		document.getElementById("1S").removeAttribute("readOnly");
		document.getElementById("2E").removeAttribute("readOnly");
		document.getElementById("2S").removeAttribute("readOnly");
		document.getElementById("3E").removeAttribute("readOnly");
		document.getElementById("3S").removeAttribute("readOnly");
		document.getElementById("4E").removeAttribute("readOnly");
		document.getElementById("4S").removeAttribute("readOnly");		
		
		lChamaEdicao = true;
	} else if (nEscolha == 2) {
		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;
		$("#panelEscolhaEdicao").css("display", "none");
		$("#panelAguardandoAjusteMarcacao").css("display", "none");
		$("#panelApontamentoJustificativa").css("display", "block");
		$("#panelEditarMarcacao").css("display", "block");
		$("#botoesGravacao").css("display", "block");
		$("#botoesReverter").css("display", "block");
		$("#botoesEscolha").css("display", "none");
		lChamaEdicao = false;
	}
}

/*funcao para montar menudrop da tabela*/
function MontarAjustarMarcacao(acao, texto1) {
	var textoAux = "";

	textoAux += "<div class='btn-group'>";
	textoAux += "<button id='botaoAR' class='btn-default btn dropdown-toggle' type='button' data-toggle='dropdown'>";
	textoAux += "   <span class='glyphicon glyphicon-triangle-bottom'></span>";
	textoAux += "</button>";
	textoAux += "<ul id='submenAR' class='dropdown-menu ' role='menu' >";
	textoAux += "<li><a tabindex='-1' href='#void' onclick='" + acao + "'>" + texto1 + "</a></li>";
	textoAux += "</ul>";
	textoAux += "</div>";

	return textoAux;
}

/*Envia apontamento justificados para aprovação de alçadas*/
function enviarApontamento() {
	var cstatus;
	var lOk = true;
	var apontamentos = [];
	var lContinua =true;
	$("#modalConfirmar").modal('hide');
	$("#loading").modal('show');
	$("#panelWarning").css("display", "none");

	document.getElementById("loadingspan").innerHTML = "Enviando Apontamento";

	table.rows().every(function (rowIdx, tableLoop, rowLoop) {
		var data = this.data();
		var statusAtraso = '';
		var statusHE = '';

		numeroMar = 0;
		//marcações
		if (!isEmpty(marcacao[rowIdx]['1E'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['1S'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['2E'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['2S'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['3E'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['3S'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['4E'])) {
			numeroMar++;
		}
		if (!isEmpty(marcacao[rowIdx]['4S'])) {
			numeroMar++;
		}
	
		/*ímpar impar
		if (numeroMar & 1) {
			alert("O dia " + marcacao[rowIdx]["data"] + " possui marcação ímpar, por favor corrija antes de enviar a aprovação.");
			lContinua = false;

		}*/

		if ( lContinua ){
			if (marcacao[rowIdx]["status"] == '0' || 
				marcacao[rowIdx]["status"] == '1' || 
				marcacao[rowIdx]["status"] == '5' || 
				marcacao[rowIdx]["status"] == "") {
				if (!isEmpty(marcacao[rowIdx]["DESCEVENEG"])) {
					if (  marcacao[rowIdx]["status"] == "5"  ){
						statusAtraso = '5';
					} else {
						statusAtraso = '2';            
					}
				} else {
					statusAtraso = '6';
				}

				if (!isEmpty(marcacao[rowIdx]["DESCEVEPOS"])) {
					if (  marcacao[rowIdx]["status"] == "5"  ){
						statusHE = '5';
					} else {
						statusHE = '2';            
					}
				} else {
					statusHE = '6';
				}

				if (statusAtraso == '6' && statusHE == '6') {
					cstatus = '6';
				} else {
					if (  marcacao[rowIdx]["status"] == "5"  ){
						cstatus = '5';
					} else {
						cstatus = '2';            
					}
				}
				var apontamento = {

					cperaponta: cperiodo,
					cstatus: cstatus,
					cdia: marcacao[rowIdx]["data"],
					statusAtraso: statusAtraso,
					statusHE: statusHE,
					criaAprovacao: "S"
				}


				apontamentos.push(apontamento);

			} else {
				lOk = false;
			}

		}
	});

	if ( lContinua ){
		//#TODO
		if (!isEmpty(cstatus)) {
			$.ajax({
				url: "U_Ajax016.APW",
				async: true,
				data: {
					"apontamentos": JSON.stringify(apontamentos)
				},
				success: function (json) {
					json = json.replace(trataerror1, '');
					var teste = json;
				},
				error: function (jqXHR, textStatus, errorThrown) {
					deslogar('Erro de conexão com servidor. Você será deslogado.');
				}
			});
		}
	}
	if (lOk) {
		$("#panelWarning").css("display", "none");
		$("#panelSuccess").css("display", "block");
	} else {
		$("#panelWarning").css("display", "block");
		$("#panelSuccess").css("display", "none");
	}
	loadMarcacao();
}

/*Controle de bloqueio de campos da tela de editar marcações*/
function blockMarc(marcacaoDia) {
	numeroMar = 0;
	var numeroCal = 0;

	$("#mudaHora1E").css("display", "none");
	$("#mudaHora1").css("display", "none");
	$("#mudaHora3").css("display", "none");
	$("#mudaHora5").css("display", "none");
	$("#mudaHora7").css("display", "none");

	document.getElementById("buttonReverter").removeAttribute("disabled");
	document.getElementById("buttonGravarAlt").removeAttribute("disabled");

	document.getElementById("eventoNegativoDesc").readOnly = true;
	document.getElementById("eventoPositivoDesc").readOnly = true;

	if ((marcacaoDia['status'] != '0' && marcacaoDia['status'] != '1' && marcacaoDia['status'] != '5' && marcacaoDia['status'] != "")) {
		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;
		blockEveNeg = true;
		//apontamentos negativos
		document.getElementById("hrNegVal").readOnly = true;
		document.getElementById("eventoNegativo").readOnly = true;
		//document.getElementById("eventoNegativoDesc").readOnly = true; 
		document.getElementById("horaNegativoJustificativa").readOnly = true;
		blockEvePos = true;
		//apontamentos positivos
		document.getElementById("hrPosVal").readOnly = true;
		document.getElementById("eventoPositivo").readOnly = true;
		//document.getElementById("eventoPositivoDesc").readOnly = true; 
		document.getElementById("horaPositivaJustificativa").readOnly = true;
		$("#buttonReverter").prop("disabled", true);
		$("#buttonGravarAlt").prop("disabled", true);
		return null;
	} else if (marcacaoDia['status'] == '5') {
		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;

		if (!isEmpty(marcacaoDia["AFASTAMENTO"])) {
			$("#buttonReverter").prop("disabled", true);
		}
	}


	//marcações
	if (!isEmpty(marcacaoDia['1E'])) {
		numeroMar++;
		document.getElementById("1E").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['1S'])) {
		numeroMar++;
		document.getElementById("1S").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['2E'])) {
		numeroMar++;
		document.getElementById("2E").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['2S'])) {
		numeroMar++;
		document.getElementById("2S").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['3E'])) {
		numeroMar++;
		document.getElementById("3E").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['3S'])) {
		numeroMar++;
		document.getElementById("3S").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['4E'])) {
		numeroMar++;
		document.getElementById("4E").readOnly = true;
	}
	if (!isEmpty(marcacaoDia['4S'])) {
		numeroMar++;
		document.getElementById("4S").readOnly = true;
	}

	//calendario
	if (!isEmpty(marcacaoDia['calend1ETp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend1STp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend2ETp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend2STp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend3ETp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend3STp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend4ETp'])) {
		numeroCal++;
	}
	if (!isEmpty(marcacaoDia['calend4STp'])) {
		numeroCal++;
	}

		//libera para apontamento caso a quantidade seja maior que zero - horas negativas
		if (parseFloat(marcacaoDia['horaNegValor'].replace(":", ".")) == 0) {
			blockEveNeg = true;
			//apontamentos negativos
			document.getElementById("hrNegVal").readOnly = true;
			document.getElementById("eventoNegativo").readOnly = true;
			//document.getElementById("eventoNegativoDesc").readOnly = true; 
			document.getElementById("horaNegativoJustificativa").readOnly = true;
		} else {
			blockEveNeg = false;
			//apontamentos negativos
			document.getElementById("hrNegVal").removeAttribute("readOnly");
			document.getElementById("eventoNegativo").removeAttribute("readOnly");
			//document.getElementById("eventoNegativoDesc").removeAttribute("readOnly");
			document.getElementById("horaNegativoJustificativa").removeAttribute("readOnly");
		}

		//libera para apontamento caso a quantidade seja maior que zero - horas positivas
		if (parseFloat(marcacaoDia['horaPosValor'].replace(":", ".")) == 0) {
			blockEvePos = true;
			//apontamentos positivos
			document.getElementById("hrPosVal").readOnly = true;
			document.getElementById("eventoPositivo").readOnly = true;
			//document.getElementById("eventoPositivoDesc").readOnly = true; 
			document.getElementById("horaPositivaJustificativa").readOnly = true;
		} else {
			blockEvePos = false;
			//apontamentos positivos
			document.getElementById("hrPosVal").removeAttribute("readOnly");
			document.getElementById("eventoPositivo").removeAttribute("readOnly");
			//document.getElementById("eventoPositivoDesc").removeAttribute("readOnly");
			document.getElementById("horaPositivaJustificativa").removeAttribute("readOnly");
		}	
	
	//bloqueio a marcaco e libero o apontamento
	//Bloqueia os campos caso possua a quantidade de marcacao par
	/*
	if (numeroMar % 2 == 0 && numeroMar != 0) {
		$("#panelAguardandoAjusteMarcacao").css("display", "none");
		$("#panelApontamentoJustificativa").css("display", "block")

		document.getElementById("1E").readOnly = true;
		document.getElementById("1S").readOnly = true;
		document.getElementById("2E").readOnly = true;
		document.getElementById("2S").readOnly = true;
		document.getElementById("3E").readOnly = true;
		document.getElementById("3S").readOnly = true;
		document.getElementById("4E").readOnly = true;
		document.getElementById("4S").readOnly = true;
		
		$('#up-1E'  ).attr('disabled', 'true');
		$('#up-1S'  ).attr('disabled', 'true');
		$('#up-2E'  ).attr('disabled', 'true');
		$('#up-2S'  ).attr('disabled', 'true');
		$('#up-3E'  ).attr('disabled', 'true');
		$('#up-3S'  ).attr('disabled', 'true');
		$('#up-4E'  ).attr('disabled', 'true');
		$('#up-4S'  ).attr('disabled', 'true');

		$('#down-1E').attr('disabled', 'true');
		$('#down-1S').attr('disabled', 'true');
		$('#down-2E').attr('disabled', 'true');
		$('#down-2S').attr('disabled', 'true');
		$('#down-3E').attr('disabled', 'true');
		$('#down-3S').attr('disabled', 'true');
		$('#down-4E').attr('disabled', 'true');
		$('#down-4S').attr('disabled', 'true');		

		lReaponta = 'N';
		
		//libera para apontamento caso a quantidade seja maior que zero - horas negativas
		
		if (parseFloat(marcacaoDia['horaNegValor'].replace(":", ".")) == 0) {
			blockEveNeg = true;
			//apontamentos negativos
			document.getElementById("hrNegVal").readOnly = true;
			document.getElementById("eventoNegativo").readOnly = true;
			//document.getElementById("eventoNegativoDesc").readOnly = true; 
			document.getElementById("horaNegativoJustificativa").readOnly = true;
		} else {
			blockEveNeg = false;
			//apontamentos negativos
			document.getElementById("hrNegVal").removeAttribute("readOnly");
			document.getElementById("eventoNegativo").removeAttribute("readOnly");
			//document.getElementById("eventoNegativoDesc").removeAttribute("readOnly");
			document.getElementById("horaNegativoJustificativa").removeAttribute("readOnly");
		}

		//libera para apontamento caso a quantidade seja maior que zero - horas positivas
		if (parseFloat(marcacaoDia['horaPosValor'].replace(":", ".")) == 0) {
			blockEvePos = true;
			//apontamentos positivos
			document.getElementById("hrPosVal").readOnly = true;
			document.getElementById("eventoPositivo").readOnly = true;
			//document.getElementById("eventoPositivoDesc").readOnly = true; 
			document.getElementById("horaPositivaJustificativa").readOnly = true;
		} else {
			blockEvePos = false;
			//apontamentos positivos
			document.getElementById("hrPosVal").removeAttribute("readOnly");
			document.getElementById("eventoPositivo").removeAttribute("readOnly");
			//document.getElementById("eventoPositivoDesc").removeAttribute("readOnly");
			document.getElementById("horaPositivaJustificativa").removeAttribute("readOnly");
		}		

		//libera para apontamento caso a quantidade seja maior que zero - horas negativas
		if (parseFloat(marcacaoDia['horaNegValor'].replace(":", ".")) == 0) {
			blockEveNeg = true;
			//apontamentos negativos
			document.getElementById("hrNegVal").readOnly = true;
			document.getElementById("eventoNegativo").readOnly = true;
			//document.getElementById("eventoNegativoDesc").readOnly = true; 
			document.getElementById("horaNegativoJustificativa").readOnly = true;
		} else {
			blockEveNeg = false;
			//apontamentos negativos
			document.getElementById("hrNegVal").removeAttribute("readOnly");
			document.getElementById("eventoNegativo").removeAttribute("readOnly");
			//document.getElementById("eventoNegativoDesc").removeAttribute("readOnly");
			document.getElementById("horaNegativoJustificativa").removeAttribute("readOnly");
		}

		//libera para apontamento caso a quantidade seja maior que zero - horas positivas
		if (parseFloat(marcacaoDia['horaPosValor'].replace(":", ".")) == 0) {
			blockEvePos = true;
			//apontamentos positivos
			document.getElementById("hrPosVal").readOnly = true;
			document.getElementById("eventoPositivo").readOnly = true;
			//document.getElementById("eventoPositivoDesc").readOnly = true; 
			document.getElementById("horaPositivaJustificativa").readOnly = true;
		} else {
			blockEvePos = false;
			//apontamentos positivos
			document.getElementById("hrPosVal").removeAttribute("readOnly");
			document.getElementById("eventoPositivo").removeAttribute("readOnly");
			//document.getElementById("eventoPositivoDesc").removeAttribute("readOnly");
			document.getElementById("horaPositivaJustificativa").removeAttribute("readOnly");
		}
	} else {
	*/
		$("#panelAguardandoAjusteMarcacao").css("display", "block");
		$("#panelApontamentoJustificativa").css("display", "none");

		//blockEveNeg = true;
		//blockEvePos = true;
		lReaponta = 'S'

		//numero de marcacoes igual a zero
		if (numeroMar == 0) {
			document.getElementById("1E").removeAttribute("readOnly");
			document.getElementById("1S").removeAttribute("readOnly");
			document.getElementById("2E").removeAttribute("readOnly");
			document.getElementById("2S").removeAttribute("readOnly");
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			
			$('#up-1E'  ).removeAttr('readOnly');
			$('#up-1S'  ).removeAttr('readOnly');
			$('#up-2E'  ).removeAttr('readOnly');
			$('#up-2S'  ).removeAttr('readOnly');
			$('#up-3E'  ).removeAttr('readOnly');
			$('#up-3S'  ).removeAttr('readOnly');
			$('#up-4E'  ).removeAttr('readOnly');
			$('#up-4S'  ).removeAttr('readOnly');
			
			$('#down-1E').removeAttr('readOnly');
			$('#down-1S').removeAttr('readOnly');
			$('#down-2E').removeAttr('readOnly');
			$('#down-2S').removeAttr('readOnly');
			$('#down-3E').removeAttr('readOnly');
			$('#down-3S').removeAttr('readOnly');
			$('#down-4E').removeAttr('readOnly');
			$('#down-4S').removeAttr('readOnly');

			//libera para apontamento caso a quantidade seja maior que zero - horas negativas
			if (parseFloat(marcacaoDia['horaNegValor'].replace(":", ".")) == 0) {
				blockEveNeg = true;
				//apontamentos negativos
				document.getElementById("hrNegVal").readOnly = true;
				document.getElementById("eventoNegativo").readOnly = true;
				//document.getElementById("eventoNegativoDesc").readOnly = true; 
				document.getElementById("horaNegativoJustificativa").readOnly = true;
			} else {
				blockEveNeg = false;
				//apontamentos negativos
				document.getElementById("hrNegVal").removeAttribute("readOnly");
				document.getElementById("eventoNegativo").removeAttribute("readOnly");
				//document.getElementById("eventoNegativoDesc").removeAttribute("readOnly");
				document.getElementById("horaNegativoJustificativa").removeAttribute("readOnly");
			}

			//libera para apontamento caso a quantidade seja maior que zero - horas positivas
			if (parseFloat(marcacaoDia['horaPosValor'].replace(":", ".")) == 0) {
				blockEvePos = true;
				//apontamentos positivos
				document.getElementById("hrPosVal").readOnly = true;
				document.getElementById("eventoPositivo").readOnly = true;
				//document.getElementById("eventoPositivoDesc").readOnly = true; 
				document.getElementById("horaPositivaJustificativa").readOnly = true;
			} else {
				blockEvePos = false;
				//apontamentos positivos
				document.getElementById("hrPosVal").removeAttribute("readOnly");
				document.getElementById("eventoPositivo").removeAttribute("readOnly");
				//document.getElementById("eventoPositivoDesc").removeAttribute("readOnly");
				document.getElementById("horaPositivaJustificativa").removeAttribute("readOnly");
			}

		}

		if (numeroMar == 1) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").removeAttribute("readOnly");
			document.getElementById("2E").removeAttribute("readOnly");
			document.getElementById("2S").removeAttribute("readOnly");
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora1").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');	
			
			
			marcTroca = "1S";


		}
		
		if (numeroMar == 2) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").removeAttribute("readOnly");
			document.getElementById("2S").removeAttribute("readOnly");
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora1").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');	
			
			
			marcTroca = "2E";

		}		

		if (numeroMar == 3) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").removeAttribute("readOnly");
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora3").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');	
			
			marcTroca = "2S";

		}

		if (numeroMar == 4) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").readOnly = true;
			document.getElementById("3E").removeAttribute("readOnly");
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora3").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');	
			
			marcTroca = "3E";


		}

		if (numeroMar == 5) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").readOnly = true;
			document.getElementById("3E").readOnly = true;
			document.getElementById("3S").removeAttribute("readOnly");
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora5").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');			
			
			marcTroca = "3S";


		}

		if (numeroMar == 6) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").readOnly = true;
			document.getElementById("3E").readOnly = true;
			document.getElementById("3S").readOnly = true;
			document.getElementById("4E").removeAttribute("readOnly");
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora5").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');			
			
			marcTroca = "4E";


		}
		
		if (numeroMar == 7) {
			document.getElementById("1E").readOnly = true;
			document.getElementById("1S").readOnly = true;
			document.getElementById("2E").readOnly = true;
			document.getElementById("2S").readOnly = true;
			document.getElementById("3E").readOnly = true;
			document.getElementById("3S").readOnly = true;
			document.getElementById("4E").readOnly = true;
			document.getElementById("4S").removeAttribute("readOnly");
			//$("#mudaHora1E").css("display", "block");
			//$("#mudaHora7").css("display", "block");
			
			$('#up-1E'  ).attr('disabled', 'true');
			$('#up-1S'  ).removeAttr('disabled');
			$('#up-2E'  ).removeAttr('disabled');
			$('#up-2S'  ).removeAttr('disabled');
			$('#up-3E'  ).removeAttr('disabled');
			$('#up-3S'  ).removeAttr('disabled');
			$('#up-4E'  ).removeAttr('disabled');
			$('#up-4S'  ).removeAttr('disabled');
			
			$('#down-1E').removeAttr('disabled');
			$('#down-1S').removeAttr('disabled');
			$('#down-2E').removeAttr('disabled');
			$('#down-2S').removeAttr('disabled');
			$('#down-3E').removeAttr('disabled');
			$('#down-3S').attr('disabled', 'true');
			$('#down-4E').removeAttr('disabled');
			$('#down-4S').removeAttr('disabled');				
			marcTroca = "4S";


		}
	//}


}

/*Valida hora digitada*/
function checkTime(str, id) {
	if (str.length == 0) return true;
	if (str.length < 4) return false;
	var x = str.indexOf(":");
	if (x < 0) {
		str = str.substr(0, 2) + ":" + str.substr(2, 2);
		document.getElementById(id).value = str;
		document.getElementById(id).focus();
		return true;
	}
	if (
		(str.substr(0, 2) >= 0) &&
		(str.substr(0, 2) <= 24) &&
		(str.substr(3, 2) >= 0) &&
		(str.substr(3, 2) <= 59) &&
		(str.substr(0, 2) < 24 || (str.substr(0, 2) == 24 && str.substr(3, 2) == 0))
	)
		return true;
	return false;
}

/*Verifica se todas as horas digitadas são válidas*/
function checkAllMarc() {
	if (checkTime($("#1E").val(), "1E")) {
		isValid1E = true;
	} else {
		isValid1E = false;
	}
	if (checkTime($("#1S").val(), "1S")) {
		isValid1S = true;
	} else {
		isValid1S = false;
	}
	if (checkTime($("#2E").val(), "2E")) {
		isValid2E = true;
	} else {
		isValid2E = false;
	}
	if (checkTime($("#2S").val(), "2S")) {
		isValid2S = true;
	} else {
		isValid2S = false;
	}
	if (checkTime($("#3E").val(), "3E")) {
		isValid3E = true;
	} else {
		isValid3E = false;
	}
	if (checkTime($("#3S").val(), "3S")) {
		isValid3S = true;
	} else {
		isValid3S = false;
	}
	if (checkTime($("#4E").val(), "4E")) {
		isValid4E = true;
	} else {
		isValid4E = false;
	}
	if (checkTime($("#4S").val(), "4S")) {
		isValid4S = true;
	} else {
		isValid4S = false;
	}

	return (isValid1E && isValid1E && isValid1S && isValid2E && isValid2S && isValid3E && isValid3S && isValid4E && isValid4S);
}

/*Volta a marcação do funcionário para marcaçao original do relógio*/
function MarcacaoInicial() {
	$("#myModal").modal('hide');
	$("#loading").modal('show');
	document.getElementById("loadingspan").innerHTML = "Revertendo Marcação";

	$.ajax({
		url: "U_Ajax020.APW",
		async: true,
		data: {
			"cdata": marcacao[linMarcArray]["data"],
			"cponmes": cperiodo,
			"cordem": marcacao[linMarcArray]["ordem"]
		},
		success: function (json) {
			json = json.replace(trataerror1, '');
			var jsonMarcacao = $.parseJSON(json);
			marcacao = jsonMarcacao.marcacao;
			loadTabelaMarcacao();
			$("#loading").modal('hide');
		},
		error: function (jqXHR, textStatus, errorThrown) {
			deslogar('Erro de conexão com servidor. Você será deslogado.');
		}
	});
}

/*Movimenta as horas entre a primeira entrada e a ultima saida, 
para caso esteja faltando uma marcação o sistema possa inverter a ordem delas*/
function trocahoras() {
	var c1E = document.getElementById("1E").value;
	var cTroca = document.getElementById(marcTroca).value;

	if (!checkTime(c1E, "1E")) {
		$('#div1E').removeClass('has-success');
		$('#div1E').addClass('has-error');
		return;
	} else {
		$('#div1E').removeClass('has-error');
		$('#div1E').addClass('has-success');

	}

	if (!checkTime(cTroca, marcTroca)) {
		$('#' + cTroca).removeClass('has-success');
		$('#' + cTroca).addClass('has-error');
		return;
	} else {
		$('#' + cTroca).removeClass('has-error');
		$('#' + cTroca).addClass('has-success');
	}

	if (marcTroca == "1S") {
		document.getElementById("1E").value = cTroca;
		document.getElementById(marcTroca).value = c1E;
	} else if (marcTroca == "2S") {

		document.getElementById("2S").value = document.getElementById("2E").value;
		document.getElementById("2E").value = document.getElementById("1S").value;
		document.getElementById("1S").value = document.getElementById("1E").value;
		document.getElementById("1E").value = cTroca;
	} else if (marcTroca == "3S") {
		document.getElementById("3S").value = document.getElementById("3E").value;
		document.getElementById("3E").value = document.getElementById("2S").value;
		document.getElementById("2S").value = document.getElementById("2E").value;
		document.getElementById("2E").value = document.getElementById("1S").value;
		document.getElementById("1S").value = document.getElementById("1E").value;
		document.getElementById("1E").value = cTroca;
	} else if (marcTroca == "4S") {
		document.getElementById("4S").value = document.getElementById("4E").value;
		document.getElementById("4E").value = document.getElementById("3S").value;
		document.getElementById("3S").value = document.getElementById("3E").value;
		document.getElementById("3E").value = document.getElementById("2S").value;
		document.getElementById("2S").value = document.getElementById("2E").value;
		document.getElementById("2E").value = document.getElementById("1S").value;
		document.getElementById("1S").value = document.getElementById("1E").value;
		document.getElementById("1E").value = cTroca;
	}

	if (document.getElementById("1E").readOnly) {
		document.getElementById("1E").removeAttribute("readOnly");
		document.getElementById(marcTroca).readOnly = true;
	} else {
		document.getElementById("1E").readOnly = true;
		document.getElementById(marcTroca).removeAttribute("readOnly");
	}

}

/*Monta título da aba Período*/
function montarTitPer() {
	var de = cperiodo.substring(6, 8) + "/" + cperiodo.substring(4, 6) + "/" + cperiodo.substring(0, 4);
	var ate = cperiodo.substring(14, 16) + "/" + cperiodo.substring(12, 14) + "/" + cperiodo.substring(8, 12);
	document.getElementById("titperapon").innerHTML = "Período aberto de " + de + " à " + ate;
}

/*desabilita botões para edição*/
function desabilitaBotao() {
	if (nivelColab == '1') {
		$('#todasAprovacoesAprovar').prop("disabled", true);
		$('#todasAprovacoesReprovar').prop("disabled", true);
		$('#somenteHEAprovar').prop("disabled", true);
		$('#somenteHEReprovar').prop("disabled", true);
	} else if (nivelColab == '2') {
		$('#todasAprovacoesAprovar').prop("disabled", true);
		$('#todasAprovacoesReprovar').prop("disabled", true);
		$('#somenteAtrasosAprovar').prop("disabled", true);
		$('#somenteAtrasosReprovar').prop("disabled", true);
	}
}

/*validacao do grupo de aprovação*/
function validGrupoAprov() {

	$.ajax({
		url: "U_Ajax034.APW",
		async: false,
		data: {
			"cponmes": cperiodo,
		},
		success: function (result) {
			result = result.replace(trataerror1, '');
			if (!isEmpty(result)) {
				result = result.replace(trataerror1, '');
				var obj = $.parseJSON(result);
				var possuiGrupoAprovador = obj.grupoAprovador[0].possuiGrupoAprovador;
				if (possuiGrupoAprovador == '0') {
					document.getElementById("avisoMsgGRUPO").innerHTML = '<br /> <br />Funcion&aacute;rio sem Grupo de Aprova&ccedil;&atilde;o. <br /> <br /> <strong> Entre em contato com o RH. </strong> <br /> <br />';

					$('#modalAvisoGRUPO').modal({
						keyboard: false
					});
					$('#modalAvisoGRUPO').modal('show');
				}
			} else {
				deslogar('Grupo de aprovacao vazio');
			}
		},
		error: function (jqXHR, textStatus, errorThrown) {
			deslogar('Erro de conexão com servidor. Você será deslogado.');
		}
	});
}

/*recebe parametros do Protheus*/
function paramMarc(periodo) {
	loadParametros();
	$.ajax({
		url: "U_Ajax091.APW",
		async: false,
		//data: {"periodo" : periodo },
		success: function (result) {
			result = result.replace(trataerror1, '');
			if (!isEmpty(result)) {
				var aparam = result.split(';');
				idkey = aparam[0];
				if (aparam.length > 1) {
					cperiodo = aparam[3];
				}
			} else {
				deslogar('Erro de conexão com servidor. Você será deslogado.');
			}
		},
		error: function (jqXHR, textStatus, errorThrown) {
			deslogar('Erro de conexão com servidor. Você será deslogado.');
		}
	});
}

/*Carrega mascara do campos de marcações*/
function loadMask() {
	$('#1E').mask('00:00');
	$('#1S').mask('00:00');
	$('#2E').mask('00:00');
	$('#2S').mask('00:00');
	$('#3S').mask('00:00');
	$('#3E').mask('00:00');
	$('#4S').mask('00:00');
	$('#4E').mask('00:00');
};

$('#down-1E').click( troca1E1S );
$('#up-1S'  ).click( troca1E1S );

$('#down-1S').click( troca1S2E );
$('#up-2E'  ).click( troca1S2E );

$('#down-2E').click( troca2E2S );
$('#up-2S'  ).click( troca2E2S );

$('#down-2S').click( troca2S3E );
$('#up-3E'  ).click( troca2S3E );

$('#down-3E').click( troca3E3S );
$('#up-3S'  ).click( troca3E3S );

function troca1E1S(){
	var hora1 = $("#1E").val();
	var hora2 = $("#1S").val();
	
	$("#1E").val(hora2);
	$("#1S").val(hora1);

	var lBlock1 = $("#1E").prop('readOnly');
	var lBlock2 = $("#1S").prop('readOnly');	
	
	if ( lBlock1 ) {
		$("#1S").attr('readOnly', 'true');
	} else {
		$("#1S").removeAttr('readOnly');
	}

	
	if ( lBlock2 ) {
		$("#1E").attr('readOnly', 'true');
	} else {
		$("#1E").removeAttr('readOnly');
	}

}

function troca1S2E(){
	var hora1 = $("#1S").val();
	var hora2 = $("#2E").val();

	$("#1S").val(hora2);
	$("#2E").val(hora1);
	
	var lBlock1 = $("#1S").prop('readOnly');
	var lBlock2 = $("#2E").prop('readOnly');
	
	if ( lBlock1 ) {
		$("#2E").attr('readOnly', 'true');
	} else {
		$("#2E").removeAttr('readOnly');
	}

	
	if ( lBlock2 ) {
		$("#1S").attr('readOnly', 'true');
	} else {
		$("#1S").removeAttr('readOnly');
	}	
}

function troca2E2S(){
	var hora1 = $("#2E").val();
	var hora2 = $("#2S").val();
	
	$("#2E").val(hora2);
	$("#2S").val(hora1);	
	
	var lBlock1 = $("#2E").prop('readOnly');
	var lBlock2 = $("#2S").prop('readOnly');
	
	if ( lBlock1 ) {
		$("#2S").attr('readOnly', 'true');
	} else {
		$("#2S").removeAttr('readOnly');
	}

	
	if ( lBlock2 ) {
		$("#2E").attr('readOnly', 'true');
	} else {
		$("#2E").removeAttr('readOnly');
	}	
}

function troca2S3E(){
	var hora1 = $("#2S").val();
	var hora2 = $("#3E").val();
	
	$("#2S").val(hora2);
	$("#3E").val(hora1);
	
	var lBlock1 = $("#2S").prop('readOnly');
	var lBlock2 = $("#3E").prop('readOnly');
	
	if ( lBlock1 ) {
		$("#3E").attr('readOnly', 'true');
	} else {
		$("#3E").removeAttr('readOnly');
	}

	
	if ( lBlock2 ) {
		$("#2S").attr('readOnly', 'true');
	} else {
		$("#2S").removeAttr('readOnly');
	}	
}

function troca3E3S(){
	var hora1 = $("#3E").val();
	var hora2 = $("#3S").val();
	
	$("#3E").val(hora2);
	$("#3S").val(hora1);

	var lBlock1 = $("#3E").prop('readOnly');
	var lBlock2 = $("#3S").prop('readOnly');
	
	if ( lBlock1 ) {
		$("#3S").attr('readOnly', 'true');
	} else {
		$("#3S").removeAttr('readOnly');
	}

	
	if ( lBlock2 ) {
		$("#3E").attr('readOnly', 'true');
	} else {
		$("#3E").removeAttr('readOnly');
	}	
}



