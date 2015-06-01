function convertArray(inputArray) {
	var outputArray = new Array();
	for(i=0;i<inputArray.length;i++) {
		outputArray.push ([ inputArray[i][0] , inputArray[i][2] ] );	
	}
	return outputArray;
}

		$(document).ready(function () {
			
			$("#fileuploader").uploadFile({
				url:"ajaxupload/upload.php",
				fileName:"myfile",
				onSuccess: function(files,data,xhr,pd) {
					//alert('test 4444');
					alert(files);
				}
			});
			
		/*$('#fileupload').fileupload({
			dataType: 'json',
			done: function (e, data) {
				$.each(data.result.files, function (index, file) {
					$('<p/>').text(file.name).appendTo(document.body);
				});
			}
		});*/
				
		    $(".draggable").draggable();
		    $(".customtextarea").droppable({
		        drop: function (event, ui) {
		            $(this)

		            var draggableId = "wwwwwwwwwwwwwwwwwwwW"; //ui.draggable.html(); //ui.draggable.attr("id");
		            alert('id = ' + draggableId);
		        }
		    });

		    $("#ajaxWheelLoader").hide();
		    $("#errorDiv").hide();
		    $("#chartdiv").hide();



		    $("#submitAjaxForm").on('submit', function () {
		        var textAreaContent = $(".customtextarea").val();
				//alert(textAreaContent);
				//return;
		        var ajaxUrl = "/idpdemo/phpservices/callpredictors.php";

		        var tmpData = null;
		        var tmpDataX = null;
				
				var dataVSL2;
				var dataIUPRED;

		        $.ajax({
					cache:false,
					timeout:100000000,
		            type: "POST",
		            dataType: "json",
		            async: false,
		            url: ajaxUrl,
		            data: {
		                fastas: textAreaContent,
		                operation: "vsl2"
		            }
		        }).done(function (data) {
				//alert('done');

					dataVSL2 = data;

		            var myTableHTML = "";
		            for (i = 0; i < data.length; i++) {
		                myTableHTML += "<br/>" + data[i].title + "<br/>";

		                myTableHTML += "<table>";

		                for (j = 0; j < data[i].data.length; j++) {
		                    myTableHTML += "<tr>";
		                    myTableHTML += "<td>" + data[i].data[j][0] + "</td>";
		                    myTableHTML += "<td>" + data[i].data[j][1] + "</td>";
		                    myTableHTML += "<td>" + data[i].data[j][2] + "</td>";
		                    myTableHTML += "</tr>";
		                }
		                myTableHTML += "</table>";

		            }




		            /*
					  $( "#dialogDiv" ).html( myTableHTML );
					  
					  $("#dialogDiv").dialog({
						modal: true,
						width: "90%",
						height : 400
					  });*/
		            $("html, body").animate({
		                scrollTop: $(window).height()
		            }, 1600);
		            return false;
		        });



		        $.ajax({
		            type: "POST",
		            dataType: "json",
		            async: false,
		            url: ajaxUrl,
		            data: {
		                fastas: textAreaContent,
		                operation: "iupred"
		            }
		        }).done(function (data) {
					dataIUPRED = data;

		            var myTableHTML = "";
		            for (i = 0; i < data.length; i++) {
		                myTableHTML += "<br/>" + data[i].title + "<br/>";
		                myTableHTML += "<table>";

		                for (j = 0; j < data[i].data.length; j++) {
		                    myTableHTML += "<tr>";
		                    myTableHTML += "<td>" + data[i].data[j][0] + "</td>";
		                    myTableHTML += "<td>" + data[i].data[j][1] + "</td>";
		                    myTableHTML += "<td>" + data[i].data[j][2] + "</td>";
		                    myTableHTML += "</tr>";

		                }
		                myTableHTML += "</table>";

		            }

		            /*
					  $( "#dialogDivX" ).html( myTableHTML );
					  
					  $("#dialogDivX").dialog({
						modal: true,
						width: "90%",
						height : 400
					  });*/
		            $("html, body").animate({
		                scrollTop: $(window).height()
		            }, 600);
		            return false;
		        });

		        ///////////////////////////////////////////////////////////////////////////////////////////					

		        $("#chartdiv").show();

				for(k = 0;k < dataVSL2.length; k++) {
					$("#chartdiv").append('<div id="chartdiv_'+k+'"></div><a href="#" class="resetchart">Reset Chart</a><br/>');
				}
				 
				for(l = 0; l < dataVSL2.length; l++) {
						var vsl2Clean = convertArray(dataVSL2[l].data);
						var iupredClean = convertArray(dataIUPRED[l].data);
						
						var dataJason = [
							vsl2Clean, iupredClean
						];
						
						var xAxisLength = vsl2Clean.length;
						var plot = new Array();
						plot[l] = $.jqplot('chartdiv_'+l, dataJason, {
							title: 'Disorder Chart',
							axes: {
								yaxis: {
									min: 0,
									max: 1
								}
							},
							axes: {
								xaxis: {
									min: 0,
									max: xAxisLength,
									tickInterval: 50,
									tickOptions: {
										formatString: '%d'
									}
								}

							},
							cursor: {
								show: true,
								zoom: true,
								showTooltip: true
							},
							series: [{
								color: '#5FAB78'
							}],
							legend: {
								show: true,
								location: 'ne'
							},

							animate: true,
							// Will animate plot on calls to plot.replot({resetAxes:true})
							animateReplot: true,

							highlighter: {
								show: true,
								showLabel: true,
								tooltipAxes: 'y',
								sizeAdjust: 7.5,
								tooltipLocation: 'ne'
							},

							seriesDefaults: {
								showMarker: false
							},
							axesDefaults: {
								showTicks: true,
								showTickMarks: false,

							},

						});


						$('.resetchart').click(function () {
							plot[l].resetZoom()
						});
						///////////////////////////////////////////////////////////////////////////////////////////

						
				}
				return false;
		    });

		    $("#searchUniprot").click(function () {
		        var uniprotSearchQuery = $("#proteinName").val();

		        if (uniprotSearchQuery == "" || uniprotSearchQuery == null) {
		            $("#errorDiv").html("Please Enter a search query");
		            $("#errorDiv").show();
		        } else {
		            $("#errorDiv").html("");
		            $("#errorDiv").hide();
		            $("#ajaxWheelLoader").show();
		        }


		        var ajaxUrl = "/idpdemo/phpservices/svc_uniprot.php?protein_name=" + uniprotSearchQuery;

		        $.get(ajaxUrl, function (data) {




		            $("#dialogDiv").html(data);
		            $("#customUniprotResultDiv").html(data);

		            $("#dialogDiv").dialog({
		                modal: true,
		                width: "90%",
		                height: 400
		            });

		            $("#ajaxWheelLoader").hide();

		        });


		    });

		    $(document).on("click", ".proteinIdClass", function () {
		        //alert('test');
		    });

		});

		function loadStuff(uniprotEntryID) {
		    var fastaText = $(".customtextarea").html();
		    fastaText += "\n";

		    var ajaxUrl = "/idpdemo/phpservices/svc_fasta_uniprot.php?protein_entry=" + uniprotEntryID;
		    $.get(ajaxUrl, function (data) {

		        var newDiv = $(document.createElement('div'));
		        newDiv.html("This Fasta for ID" + uniprotEntryID + " was loaded to the text area: <br/></br>" + data);
		        newDiv.dialog();

		        fastaText += data;
		        $(".customtextarea").html(fastaText);
		    });



		}