import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:math_expressions/math_expressions.dart';


void main() {

  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {


  String equation = "";
  String expression = "";
  String result = "";
  double eqFontSize = 48.0;
  double resFontSize = 38.0;
  bool opAdded = false;
  bool dotAdded = false;
  bool factAdded = false;

  void buttonPressed(String buttonText){
    setState(() {
      if(buttonText == "AC"){
        equation = "";
        result = "";
        opAdded = false;
        dotAdded = false;
        factAdded = false;
      } else if(buttonText == "⌫"){
        if(equation.isNotEmpty) {
          equation = equation.substring(0, equation.length - 1);
          if(opAdded){
            opAdded = false;
          }
          if(factAdded){
            factAdded = false;
          }
        }
      } else if(buttonText == "="){
        if(equation.isNotEmpty){
          expression = equation;
          expression = expression.replaceAll("×", "*");
          expression = expression.replaceAll("÷", "/");
          try{
            Parser p = Parser();
            Expression exp = p.parse(expression);

            ContextModel cm = ContextModel();
            String res = "${exp.evaluate(EvaluationType.REAL, cm)}";
            if(res[res.length - 1] == "0" && res[res.length - 2] == "."){
              res = res.substring(0, res.length - 2);
            }
            result = res;

          } catch(e) {
            result = "Bad Expression";
          }
        }
      } else if(buttonText == "+"){
        if(!opAdded && equation.isNotEmpty){
          equation+="+";
          opAdded = true;
          dotAdded = false;
        }
      } else if(buttonText == "-"){
        if(!opAdded){
          equation+="-";
          opAdded = true;
          dotAdded = false;
        }
      } else if(buttonText == "×"){
        if(!opAdded && equation.isNotEmpty){
          equation+="×";
          opAdded = true;
          dotAdded = false;
        }
      } else if(buttonText == "÷"){
        if(!opAdded && equation.isNotEmpty){
          equation+="÷";
          opAdded = true;
          dotAdded = false;
        }
      } else if(buttonText == "%"){
        if(!opAdded && equation.isNotEmpty){
          equation+="%";
          opAdded = true;
          dotAdded = false;
        }
      } else if(buttonText == "!"){
        if(!opAdded && equation.isNotEmpty && !factAdded){
          equation+="!";
          dotAdded = false;
          factAdded = true;
        }
      } else if(buttonText == "x²"){
        if(!opAdded && equation.isNotEmpty){
          equation+="^(2)";
          dotAdded = false;
        }
      } else if(buttonText == "x³"){
        if(!opAdded && equation.isNotEmpty){
          equation+="^(3)";
          dotAdded = false;
        }
      } else if(buttonText == "xʸ"){
        if(!opAdded && equation.isNotEmpty){
          equation+="^";
          opAdded = true;
          dotAdded = false;
          factAdded = true;
        }
      } else if(buttonText == "√"){
        if(!opAdded && equation.isNotEmpty){
          equation+="^(1/2)";
          dotAdded = false;
        }
      } else if(buttonText == "³√"){
        if(!opAdded && equation.isNotEmpty){
          equation+="^(1/3)";
          dotAdded = false;
        }
      } else if(buttonText == "."){
        if(!dotAdded){
          equation+=".";
          dotAdded = true;
        }
      } else {
        // only for digits
        equation+=buttonText;
        opAdded = false;
        factAdded = false;
      }
    });
  }

  // custom button
  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor, Color textColor, Color bgColor){
    return Container(
      height: MediaQuery.of(context).size.height * buttonHeight,
      color: buttonColor,
      child: FlatButton(
        color: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.transparent
            )
        ),
        padding: const EdgeInsets.all(16.0),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.normal,
              color: textColor
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
            'Calculator',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
      ),

      body: Column(
        children: [

          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(equation, style: const TextStyle(fontSize: 48.0), maxLines: 1,),
              )
          ),

          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(result, style: const TextStyle(fontSize: 38.0), maxLines: 1,),
              )
          ),

          const Expanded(
              child: Divider(),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: buildButton("⌫", 0.08, Colors.transparent, Colors.white, HexColor("#181818")),
                  )
              ),

              Container(
                color: HexColor("#181818"),
                width: MediaQuery.of(context).size.width * 1.0,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("AC", 0.08, Colors.transparent, HexColor("#FFBF00"), Colors.transparent),
                        buildButton("³√", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                        buildButton("√", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                        buildButton("xʸ", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                      ]
                    ),

                    TableRow(
                        children: [
                          buildButton("x³", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("x²", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("%", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("÷", 0.08, Colors.transparent, HexColor("#FFBF00"), Colors.transparent),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("7", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("8", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("9", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("×", 0.08, Colors.transparent, HexColor("#FFBF00"), Colors.transparent),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("4",0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("5", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("6", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("-", 0.08, Colors.transparent, HexColor("#FFBF00"), Colors.transparent),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton("1", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("2", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("3", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("+", 0.08, Colors.transparent, HexColor("#FFBF00"), Colors.transparent),
                        ]
                    ),

                    TableRow(
                        children: [
                          buildButton(".", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("0", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("!", 0.08, Colors.transparent, Colors.white, Colors.transparent),
                          buildButton("=", 0.08, HexColor("#FFBF00"), Colors.white, Colors.transparent),
                        ]
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}


