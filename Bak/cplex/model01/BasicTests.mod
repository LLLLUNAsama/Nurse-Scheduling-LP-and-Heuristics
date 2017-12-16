/*********************************************
 * OPL 12.6.0.0 Model
 * Author: homero
 * Creation Date: 09/11/2017 at 14:53:13
 *********************************************/

 
 main {


function myTest(def, cplex, filename, goal, showsol) {

 var model = new IloOplModel(def,cplex);
 var data = new IloOplDataSource(filename);
 model.addDataSource(data);
 model.generate();
 //cplex.epgap=0.01;
 var solved = cplex.solve();
 
 if (solved && goal == "SUCCESS") {
 	writeln("SUCCESS/SUCCESS ---------------------- ok: "+filename + " time: "+cplex.getSolvedTime());
 	if (showsol == "y")
 		model.printSolution();
} else if (!solved && goal == "FAIL") {
 	writeln("FAIL/FAIL       ---------------------- ok: "+filename);
} else {
	writeln("FAIL/SUCCESS    ------------------- ERROR: "+filename);
} 	
 data.end();
 model.end();
  return true;
}


 var src = new IloOplModelSource("model01.mod");
 var def = new IloOplModelDefinition(src);
 var cplex = new IloCplex();
 
 
 myTest(def, cplex,"basicTest-minHours01.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-minHours02.dat","FAIL" );
 myTest(def, cplex,"basicTest-maxRest01.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-maxRest02.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-maxPresence01.dat","FAIL" );
 myTest(def, cplex,"basicTest-maxPresence02.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-maxHours01.dat","FAIL" );
 myTest(def, cplex,"basicTest-maxHours02.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-maxConsec01.dat","FAIL" );
 myTest(def, cplex,"basicTest-maxConsec02.dat","SUCCESS" );
 myTest(def, cplex,"basicTest-manual-solution01.dat","SUCCESS", "y" );
 myTest(def, cplex,"basicTest-manual-solution02.dat","FAIL"); 
 myTest(def, cplex,"basicTest-manual-solution03.dat","SUCCESS");

 
 
 def.end();
 cplex.end();
 src.end(); 
 
};