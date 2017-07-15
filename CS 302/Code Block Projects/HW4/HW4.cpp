#include <iostream>
#include <fstream>
#include <string>

using namespace std;

struct NodeType //setup linked list
{
	int Value;
	bool inSer;
	NodeType *Right;
	NodeType *Left;
};


class BinSer //setup class for Binary Tree
{
	public:
		BinSer();
		void Insert (int , NodeType* ); // Inserts a number in the tree
		bool Find (int , NodeType* ); // finds a number in a tree
		void Delete (int , NodeType* ); // deletes (lazy deletion) a number from a tree
		void Inorder (NodeType*, ofstream&); // Displays the tree in Inorder
		void Preorder (NodeType*, ofstream&); // Displays the tree in Preorder

	private:
		NodeType *Move, *newNode, *prev; // for use within the functions
};


int main()
{
	ifstream inFile; //input file variable
	ofstream outFile; //output file variable
	string file; // container for name of the file

	BinSer Func;

	char command; // variable for desired command
	int number; // variable for the number
	NodeType *initial; // the starting point of the tree

	cout << "Enter a file name:" << endl; // prompts for file
	cin >> file;

    inFile.open(file.c_str()); //converts file name into a string
	outFile.open("HW4.txt"); // opens output file

	inFile >> command; //gets first command
	while(inFile)
	{
		if(command == 'I') // command is to Initialize
		{
		    initial = new NodeType; //creates a new node and places it on tree
			initial->Value = NULL;
			initial->inSer = false;
			initial->Left = NULL;
			initial->Right = NULL;
		}

		else if(command == 'N') // command is to Insert
		{
			inFile >> number; //gets the number
			Func.Insert(number,initial); //places a number into the tree
		}

		else if(command == 'F') //command is to Find
		{
			inFile >> number; // gets the number to find
			bool Found=Func.Find(number,initial); // searches the tree for the number
			if(Found == true) //if the number is found
            {
                outFile<< number <<" Is in the tree" <<endl; 
            }
            if(Found == false) //if the number is not found
            {
                outFile <<number << " Is not in the tree" << endl;
            }
		}

		else if(command == 'D') //command is to Delete
		{
			inFile >> number;
			Func.Delete(number,initial); //lazy deletes the number
		}

		else if(command == 'L') // command is to display Inorder
		{
		    if(initial->Value !=NULL) // if there is a tree
            {
                outFile << "Inorder: ";
                Func.Inorder(initial, outFile);
            }
			else // if there is no tree
            {
                outFile << "Tree not Found";
			}
			outFile << endl;
		}

		else if(command == 'P') // command is to display in Preorder
		{
		    if(initial->Value != NULL)//if the tree is there
            {
                outFile << "Preorder: ";
                Func.Preorder(initial, outFile);
            }
            else//if there is no tree
            {
                outFile <<"Tree Not Found";
            }

			outFile << endl;
		}
		else
        {
            inFile >> number; //if there is an invalid command, and it has a number, it gets the number
            outFile << "Invalid Command" << endl;
        }

		inFile >> command; //gets next command
	}

	outFile.close(); //closes file
	inFile.close();

return 0;
}

BinSer::BinSer()//sets up the nodes
{
    Move = new NodeType;
    newNode = new NodeType;
    prev = new NodeType;
}

void BinSer::Insert (int item, NodeType *initial) //inserts a number into the tree
{

	if(initial->Value == NULL) //if there is no tree, then the first number becomes the root
	{
		initial->Value = item;
		initial->inSer = true;
		return;
	}
	Move = initial; 

	while(Move != NULL and Move->Value != item) //loops until it hits a null or finds an existing number
	{
		if(item < Move->Value) // move left into the tree if the item is less than the current value in the tree
		{
			prev = Move;
			Move=Move->Left;
		}
		else if(item > Move->Value) // moves right into the tree if the item is less than the current value in the tree
		{
			prev = Move;
			Move = Move->Right;
		}
		else 
		{
			return;
		}
	}
	newNode = new NodeType; //prepares space to connect to the tree
	newNode->Value = item;
	newNode->inSer = true;
	newNode->Left = NULL;
	newNode->Right = NULL;
	if(prev->Value == item) //checks if the value is already in the tree
    {
        return;
    }
	else if(item < prev->Value) //place Left if less than value in the tree
	{
		prev->Left=newNode;
	}
	else if(item > prev->Value) //place Right if greater than value in the tree
	{
		prev->Right=newNode;
	}

}

bool BinSer::Find(int item, NodeType *initial) //checks if the value is in the tree
{
	Move = initial;

	while(Move!=NULL and Move->Value!=item) // loops until it hits a null or the value
	{
	    int x = Move->Value;
		if(Move->Value < item) //navigates right if the item is greater than current position in tree
		{
			prev = Move;
			Move = Move->Right;
		}
		else if(Move->Value > item) //navigates left if the item is greater than current position in tree
		{
			prev = Move;
			Move = Move->Left;
		}
	}

	if (Move==NULL) //returns false if the number isn't there
	{
		return false;
	}

	else if (Move->Value=item) //returns true if the value is in the tree and isnt deleted
	{
	    if(Move->inSer==true)
        {
            return true;
        }

	}
	else //if it was deleted, it returns false
	{
		return false;
	}

}

void BinSer::Delete(int item, NodeType *initial) // Deletes nodes in the tree
{
	Move = initial;
	while(Move!=NULL and Move->Value!=item) //loops until it hits a null or finds the item
	{
		if(Move->Value < item) //navigates right if greater than current pos
		{
			prev = Move;
			Move = Move->Right;
		}
		else if(Move->Value > item) //navigates left if less than current pos
		{
			prev = Move;
			Move = Move->Left;
		}
	}

	if(Move==NULL) //if number isn't there
	{
		return;
	}
	if(Move->Value == item and Move->inSer == true)//marks value as deleted if found
	{
		Move->inSer=false;
	}
}

void BinSer::Inorder(NodeType *initial, ofstream& outFile) //prints the tree Inorder
{


	if(initial!=NULL) //checks if the current pos hits a null
	{
        Inorder(initial->Left, outFile); //navigate left

        if(initial->inSer==true) //print current number if it exists
        {
            outFile << initial->Value << " ";
        }

        Inorder(initial->Right, outFile); // navigate right
	}



}

void BinSer::Preorder(NodeType *initial, ofstream& outFile) //prints the tree in Preorder
{



	if(initial!=NULL) //checks if the current pos is a null
	{
	    if(initial->inSer == true)//prints current number if it exists 
        {
            outFile << initial->Value<< " ";
        }

        Preorder(initial->Left, outFile); //navigates left
        Preorder(initial->Right, outFile); //navigates right
	}

}
