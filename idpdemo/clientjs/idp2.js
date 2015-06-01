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
			
			
			
		    $("#ajaxWheelLoader").hide();
		    $("#errorDiv").hide();
		    $("#chartdiv").hide();



		    $("#submitAjaxForm").on('submit', function () {
		        var textAreaContent = $(".customtextarea").val();

		        var ajaxUrl = "/idpdemo/phpservices/callpredictors2.php";

		        var tmpData = null;
		        var tmpDataX = null;
				
				var dataVSL2;
				var dataIUPRED;

				var myContents = textAreaContent.split("\n\n");
				var contentLength = myContents.length;
				
				alert(contentLength);
				
				$("#chartdiv").show();
				
				for(l=0;l<contentLength;l++) {
												//alert(myContents[l].trim());
												var dataVSL2Tmp;
												var dataIUPREDTmp;
												
												
												var tmpValue = myContents[l].trim();
												if(tmpValue != '') {
																	//alert('here2');
																	$.ajax({
																		cache:true,
																		timeout:100000000,
																		type: "POST",
																		dataType: "json",
																		async: false,
																		url: ajaxUrl,
																		data: {
																			fastas: tmpValue,
																			operation: "vsl2"
																		}
																	}).done(function (data) {
																		dataVSL2Tmp = data;
																		return false;
																		//alert(dataVSL2Tmp.data);
																	});
																	
																	 


																	//alert('here3');																	
																	$.ajax({
																		cache:true,
																		timeout:100000000,
																		type: "POST",
																		dataType: "json",
																		async: false,
																		url: ajaxUrl,
																		data: {
																			fastas: tmpValue,
																			operation: "iupred"
																		}
																	}).done(function (data2) {
																	   	dataIUPREDTmp = data2;
																		return false;
																		//alert(dataIUPREDTmp.data);
																	});												
																	
																	
																	
																	
																	//alert('here4');
																	//alert(dataVSL2Tmp.data);
																	//alert(dataIUPREDTmp.data);
																	
																	
																	var vsl2Clean = convertArray(dataVSL2Tmp.data);
																	var iupredClean = convertArray(dataIUPREDTmp.data);
																
																	
																	var dataJason = [
																		vsl2Clean, iupredClean
																	];
																	
																	//alert('here5');
																	var xAxisLength = vsl2Clean.length;
																	var plot = new Array();
																	
																	alert('here6');
																	
																	$("#chartdiv").append('<div id="chartdiv_'+l+'"></div><a href="#" class="resetchart">Reset Chart</a><br/>');

																	
																	try {
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
																	} catch(err) {
																	     alert(err);
																	}

																	alert('here7');
																	$('.resetchart').click(function () {
																		plot[l].resetZoom()
																	});

																	
																	
																				
												}
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