function testFileFolderCreation() {
	var inputPSB = app.activeDocument.name;
	var psbPath = app.activeDocument.path;
	var inputTiff = psbPath + "/" + inputPSB.split(".")[0] + ".tif";

	var outputPath = psbPath + "/" + "Output_Center";
	var outFullPath = File(outputPath + "/" +  inputPSB.split(".")[0] + "_center.psb");
	if (Folder(outputPath).exists == false) {
		new Folder(outputPath).create()
	};  
	
	alert("Output folder: " + outputPath);
	alert("Output file: " + outFullPath);
	alert("Input TIFF: " + inputTiff);
}


testFileFolderCreation();