%{
	#include <vector>
	#include <string>
	#include <iostream>
	using namespace std;
	struct Node {
		string x;
		string y;
	};
%}
/* */
Integer (-+)?[0-9]+

%option main noyywrap
%%
	vector<Node> vec;
	int num = 0;
	
{Integer} {

	vec.push_back(Node{"Integer", yytext});
}

<<EOF>>		{
		for (int i = 0; i < vec.size(); i++) {
			printf("<%s, %s>\n", vec[i].x.c_str(), vec[i].y.c_str());
		}
		printf("Hello World\n");
		printf( "%d\n", num);
		yyterminate();
		}
