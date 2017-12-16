  /*********************************************
 * OPL 12.6.0.0 Model
 * Author: Adrian Rodriguez Bazaga, Pau Rodriguez Esmerats
 * Creation Date: 06/12/2017 at 14:53:13
 *********************************************/

 
 main {


function cleanString(mystring){
	
	var returnstring = "";
	var i = mystring.indexOf("\n");
	var aux2 = mystring;
	var j=0;
	while (i != -1 && j<100){
		var aux = aux2.substring(0,i);
		aux2 = aux2.substring(i+1);
		returnstring = returnstring + aux + "\\n";
		i = aux2.indexOf("\n");
		j = j +1;
	}

	return returnstring;
}

function myTest(def, cplex, filename, logname, tilim,  goal, objf,  showsol) {


 var ofile = new IloOplOutputFile(logname, true);
 ofile.write("{ \""+filename+"\" : ");
 ofile.write("{");
 //ofile.writeln("\"\" : \""++"\",");
 
 var model = new IloOplModel(def,cplex);
 
 var data = new IloOplDataSource(filename);
 model.addDataSource(data);
 model.generate();
 //cplex.epgap=0.01;
 // 
 // 3600.0 1h
 // 1800.0 30m
 // 900.0 15m
 // 300.0 5m
 //  60.0 1m
 cplex.TiLim=tilim;
 //model.setParam(IloCplex.Param.tune.DetTimeLimit,10.0);
 
 //try {

  var solved = cplex.solve();  
  ofile.writeln("\"expected_output\" : \""+goal+"\",");
  ofile.writeln("\"computed_output\" : \""+solved+"\",");
  ofile.writeln("\"desired_objfunc\" : \""+objf+"\",");
	
	if (solved){
	 	
	 	ofile.writeln("\"time\" : \""+cplex.getSolvedTime()+"\",");
	 	ofile.writeln("\"int_vars\" : \""+cplex.getNintVars()+"\",");
	 	//ofile.writeln("\"lower_bound\" : \""+cplex.getLb()+"\",");
	 	ofile.writeln("\"Gap\" : \""+cplex.getMIPRelativeGap()+"\",");
	 	ofile.writeln("\"ObjectiveFunction\" : \""+cplex.getObjValue()+"\",");
	 	ofile.writeln("\"isMIP?\" : \""+cplex.isMIP()+"\",");
	 	ofile.writeln("\"Data\" : \""+cleanString(model.printExternalData())+"\",");
	 	ofile.writeln("\"Solution\" : \""+cleanString(model.printSolution())+"\"");
 	} else {
		ofile.writeln("\"Data\" : \""+cleanString(model.printExternalData())+"\"");
	
 	}	 	

 	
	  
// } catch (IloException e){
//  	ofile.writeln("                --- Exception Occurred for : "+filename )
//	ofile.writeln(model.printExternalData());	
//	ofile.writeln(e.printStackTrace());
// }

 ofile.write("}},");

 ofile.close();
 data.end();
 model.end();
  return true;
}




var src = new IloOplModelSource("model01-hfree.mod");

var def = new IloOplModelDefinition(src);

var cplex = new IloCplex();





var logname = "log-i-search04-600-"+cplex.getCplexTime()+".txt"

var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("[");
ofile.close();

var tilim = 2100.0;


/*
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-4Cnt-20171210_23-33-58231.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-4Cnt-20171210_23-33-58173.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-3Cnt-20171210_23-33-58853.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-3Cnt-20171210_23-33-58250.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-2Cnt-20171210_23-33-58914.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-2Cnt-20171210_23-33-58138.dat", logname, tilim,  "SUCCESS", 1 );

//good ones
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-1Cnt-20171210_23-33-58768.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-1Cnt-20171210_23-33-58646.dat", logname, tilim,  "SUCCESS", 1 );


myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-0Cnt-20171210_23-33-58151.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-9mnH-0Cnt-20171210_23-33-5866.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-4Cnt-20171210_23-33-59919.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-4Cnt-20171210_23-33-59718.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-3Cnt-20171210_23-33-59703.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-3Cnt-20171210_23-33-59372.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-2Cnt-20171210_23-33-58769.dat", logname, tilim,  "SUCCESS", 1 );
*/

//myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-2Cnt-20171210_23-33-5923.dat", logname, tilim,  "SUCCESS", 1 );

//myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-1Cnt-20171210_23-33-58987.dat", logname, tilim,  "SUCCESS", 1 );

/*
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-1Cnt-20171210_23-33-58660.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-0Cnt-20171210_23-33-58429.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-4mnH-0Cnt-20171210_23-33-58121.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-4Cnt-20171210_23-33-58769.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-4Cnt-20171210_23-33-58568.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-3Cnt-20171210_23-33-58464.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-3Cnt-20171210_23-33-5862.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-2Cnt-20171210_23-33-57720.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-2Cnt-20171210_23-33-57502.dat", logname, tilim,  "SUCCESS", 1 );
*/

//myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-1Cnt-20171210_23-33-57503.dat", logname, tilim,  "SUCCESS", 1 );
/*
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-1Cnt-20171210_23-33-57217.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-0Cnt-20171210_23-33-57212.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"i-ng-60-64-40-24h-16mxP-5mxC-10mxH-1mnH-0Cnt-20171210_23-33-57106.dat", logname, tilim,  "SUCCESS", 1 );
*/
var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("{\"end\":\"end\"}]");
ofile.close();



var logname = "log-x-q-600-8-28"+cplex.getCplexTime()+".txt"
var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("[");
ofile.close();

var tilim = 600.0;

/*
myTest(def, cplex,"x_8_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_8_9.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_9_9.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_10_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_11_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_12_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_13_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_2.dat", logname, tilim,  "SUCCESS", 1 );



myTest(def, cplex,"x_14_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_14_8.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_15_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_15_8.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_16_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_16_1.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_16_2.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_16_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_16_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_16_5.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_16_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_16_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_16_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_17_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_18_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_19_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_20_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_21_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_6.dat", logname, tilim,  "SUCCESS", 1 );


myTest(def, cplex,"x_22_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_22_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_23_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_24_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_25_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_26_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_27_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_28_8.dat", logname, tilim,  "SUCCESS", 1 );

var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("{\"end\":\"end\"}]");
ofile.close();

*/




var logname = "log-x-q-600-29-99"+cplex.getCplexTime()+".txt"
var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("[");
ofile.close();

var tilim = 1800.0;


/*
myTest(def, cplex,"x_29_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_29_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_30_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_31_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_32_7.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_32_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_33_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_34_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_35_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_36_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_37_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_38_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_39_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_1.dat", logname, tilim,  "SUCCESS", 1 );

myTest(def, cplex,"x_40_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_40_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_41_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_42_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_43_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_44_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_45_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_3.dat", logname, tilim,  "SUCCESS", 1 );
*/

myTest(def, cplex,"x_46_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_46_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_47_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_48_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_49_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_50_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_51_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_52_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_53_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_54_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_55_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_56_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_57_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_58_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_59_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_60_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_61_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_62_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_63_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_64_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_65_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_66_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_67_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_68_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_69_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_70_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_71_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_72_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_73_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_74_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_75_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_76_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_77_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_78_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_79_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_80_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_81_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_82_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_83_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_84_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_85_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_86_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_87_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_88_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_89_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_90_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_91_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_92_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_93_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_94_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_95_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_96_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_97_8.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_0.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_1.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_2.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_3.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_4.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_5.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_6.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_7.dat", logname, tilim,  "SUCCESS", 1 );
myTest(def, cplex,"x_98_8.dat", logname, tilim,  "SUCCESS", 1 );


var ofile = new IloOplOutputFile(logname, true);
ofile.writeln("{\"end\":\"end\"}]");
ofile.close();







def.end();
cplex.end();
src.end(); 
 
};