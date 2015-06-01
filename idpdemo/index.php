<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
<head>

	<!-- Basic Page Needs
  ================================================== -->
	<meta charset="utf-8">
	<title>Your Page Title Here :)</title>
	<meta name="description" content="">
	<meta name="author" content="">

	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<!-- CSS
  ================================================== -->
	<link rel="stylesheet" href="stylesheets/base.css">
	<link rel="stylesheet" href="stylesheets/skeleton.css">
	<link rel="stylesheet" href="stylesheets/layout.css">
	<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/smoothness/jquery-ui.min.css">
	

	<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!-- Favicons
	================================================== -->
	<link rel="shortcut icon" href="images/favicon.ico">
	<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
	<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
 
	
	<style>
		.draggable { background-color : grey; }
		
		#headerImage img {
			margin-bottom: 50px;
			max-width: 100%;
			height: auto;
		}
		.customtextarea {
			background-color: #EBEBFF;
			width : 680px;
			height : 250px;
		}
		
		.checkbox-grid li {
			display: block;
			float: left;
			width: 40%;
		}

	</style>
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
	<!-- *********************************************************************** -->
	<!--	
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/excanvas.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/excanvas.min.js"></script>
	-->
	<link rel="stylesheet" href="//cdn.jsdelivr.net/jqplot/1.0.8/jquery.jqplot.css">
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/jquery.jqplot.js"></script>
	<link rel="stylesheet" href="//cdn.jsdelivr.net/jqplot/1.0.8/jquery.jqplot.min.css">
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/jquery.jqplot.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.BezierCurveRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.BezierCurveRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.barRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.barRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.blockRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.blockRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.bubbleRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.bubbleRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasAxisLabelRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasAxisLabelRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasAxisTickRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasAxisTickRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasOverlay.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasOverlay.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasTextRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.canvasTextRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.categoryAxisRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.categoryAxisRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.ciParser.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.ciParser.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.cursor.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.cursor.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.dateAxisRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.dateAxisRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.donutRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.donutRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.dragable.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.dragable.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.enhancedLegendRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.enhancedLegendRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.funnelRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.funnelRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.highlighter.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.highlighter.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.json2.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.json2.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.logAxisRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.logAxisRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.mekkoAxisRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.mekkoAxisRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.mekkoRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.mekkoRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.meterGaugeRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.meterGaugeRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.ohlcRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.ohlcRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pieRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pieRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pointLabels.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pointLabels.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidAxisRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidAxisRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidGridRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidGridRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidRenderer.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.pyramidRenderer.min.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.trendline.js"></script>
	<script src="//cdn.jsdelivr.net/jqplot/1.0.8/plugins/jqplot.trendline.min.js"></script>
	<!-- *********************************************************************** -->
	<!-- MAIN JS CODE START -->
	<script src="clientjs/idp.js"></script>
	<!-- MAIN JS CODE END   -->
	
 
	<link href="http://hayageek.github.io/jQuery-Upload-File/uploadfile.min.css" rel="stylesheet"/>
	<!--<script src="http://hayageek.github.io/jQuery-Upload-File/jquery.uploadfile.min.js"></script>-->
	<script src="clientjs/customjqupload.js"></script>
 

<!--	
<script src="jqfileupload/js/vendor/jquery.ui.widget.js"></script>
<script src="jqfileupload/js/jquery.iframe-transport.js"></script>
<script src="jqfileupload/js/jquery.fileupload.js"></script>
-->
	
	<div div id="dialogDiv" title="Basic modal dialog"> 

	</div>

	<div div id="dialogDivX" title="Basic modal dialog"> 

	</div>
	
	
 

</head>
<body>

	<!--  http://share.snacktools.com/FAC679C7C6F/bdns4m33 -->

	<!-- Primary Page Layout
	================================================== -->

	<!-- Delete everything in this .container and get started on your own site! -->

	<div class="container">

		<div class="sixteen columns">
			<h1 class="remove-bottom" style="margin-top: 40px">Protein Disorder Predictor Prototype</h1>
			<h5>Version 1.0</h5>
			<hr />
		</div>
	

		
		<div class="sixteen columns">
			<form id="submitAjaxForm">
				<label for="proteinName">
					<span style="font-weight: bold;">Enter Protein Name</span>
					<input id="proteinName" type="text"/>
					<div id="errorDiv" style="color: red;"></div>
					<button type="button" id="searchUniprot">Search UniProt</button><div id="ajaxWheelLoader" style="font-weight: bold;">Searching UniProt.org please wait<img src="images/ajax-loader2.gif"/></div>
	
				</label>
				
				<table>
					<tbody>
						<tr>
							<td>
								<textarea class="customtextarea" maxlength="5000000" rows="10" cols="1">


								</textarea>
							</td>
				
							<td>
								<div id="customUniprotResultDiv" class="offset-by-two" style="width: 90%; height: 150px; overflow-y: scroll; position:absolute;">
									<!--
									<ul>
										<li class="ui-widget-content draggable">test 1</li>
										<li class="ui-widget-content draggable">test 1</li>
										<li class="ui-widget-content draggable">test 1</li>
										<li class="ui-widget-content draggable">test 1</li>
										<li class="ui-widget-content draggable">test 1</li>
										<li class="ui-widget-content draggable">test 1</li>
									</ul>
									-->
								</div>
							</td>
						</tr>
					</tbody>
				</table>	
 	
				
				<?php /*echo "================".( $_SERVER['DOCUMENT_ROOT'] ); */?>
			
				
				<label for="proteinName">
					<span style="font-weight: bold;">Or Upload FASTA file</span>
					    <div id="fileuploader">Upload</div>
						<!--<input id="fileupload" type="file" name="files[]" data-url="jqfileupload/server/php/" multiple/>-->
				</label>
					<br/>
				
				<fieldset>	
				<ul class="checkbox-grid">
				<label for="Email">
						<li>
						<span style="font-weight: bold;">Email Results To</span>
						<input type="text" id="Email" size="chars"/>
						</li>
						
						<li>
							<span style="font-weight: bold;">Output options</span>
								<select id="outputType">
									<option value="text">Text</option>
									<option value="graph">Graph</option>
									<option value="both">Both</option>
								</select>
							</label>
						</li>	
				</ul>
				</fieldset>	
				
 
				
		  <fieldset>			
			
			<ul class="checkbox-grid">
				<li>
					<label for="regularCheckbox">
					  <input type="checkbox" id="regularCheckbox" value="checkbox 1" />
					  <span>VSL2</span>
					</label>
				</li>
				<li>
					<label for="regularCheckbox">
					  <input type="checkbox" id="regularCheckbox" value="checkbox 1" />
					  <span>IUPRED</span>
					</label>
				</li>
				<li>
					<label for="regularCheckbox">
					  <input type="checkbox" id="regularCheckbox" value="checkbox 1" />
					  <span>Option 3</span>
					</label>
				</li>
				<li>
					<label for="regularCheckbox">
					  <input type="checkbox" id="regularCheckbox" value="checkbox 1" />
					  <span>Option 4</span>
					</label>
				</li>
			
			</ul>
		  </fieldset>
		  
		  

			<input type="submit" value="Submit Form"/>
		  
			</form>
		</div>
		<div id="chartdiv" class="sixteen columns" style="height:400px;width:950px; "></div>
 

	</div><!-- container -->


<!-- End Document
================================================== -->
</body>
</html>
