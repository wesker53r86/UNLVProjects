#include <iostream>
#include <fstream>
#include <string>
#include <ctime>
#include <string.h>
#include <cstdlib>
#include <stdio.h>

using namespace std;


struct TreapType // Treap Node Structure
{
	string name;
	int priority;
	TreapType *parent;
	TreapType *left;
	TreapType *right;
};


void DeleteTreap(TreapType*&, string); //deletes a node
void RightRotate(TreapType*&,TreapType*&); //swaps with parent, and assigns node to the right
void LeftRotate(TreapType*&,TreapType*&); //swaps with parent, and assigns node to the left
void LoadTreap(TreapType*&); //Loads the file and gives the starting point of unsorted tree
void LeftorRight(TreapType*&, TreapType*&);//decides left or right placement
void SortTreap(TreapType*&,TreapType*&);//recursively sorts the Treap
bool InTreap(TreapType*, string);//Checks to see if the following is in the treap
void OutputTreap(TreapType*&, ofstream&); // Outputs the nodes
void TreapCount(TreapType*&, int&, int&); // gives values of height and number of nodes



int main()
{
	ofstream outfile; //output file
	ifstream infile; // input file

	TreapType* Initial; // Initialize the treap
	string file;
	char Choice;
	Initial = new TreapType; // input the initial data
	Initial->priority = 101; // set to 101 to mark as initial node
	Initial->parent = NULL;
	Initial->left = NULL;
	Initial->right = NULL;

	int NodeCount,Height; //initialize the NodeCount and height of treap

	cout<< "Input Command I for Insert, D for Delete, X for exit" << endl; // prompt
	cin>>Choice;

	while(Choice!='X') //terminating condition
    {

        outfile.open("HW6.txt"); // open output file
        if(Choice == 'I') // Insert Choice
        {
            LoadTreap(Initial); //prompts for input file and then loads the names
            OutputTreap(Initial,outfile); // Outputs the names
            NodeCount = 0;//initialize the NodeCount and height of treap
            Height = 0;
            TreapCount(Initial, NodeCount,  Height);//calculates height and nodecount
            outfile << "The NodeCount = " << NodeCount << " and the height is " << Height << endl; // output
        }
        else if(Choice== 'D') // Delete Choice
        {
            cout << "Enter file" << endl; // prompt for file
            cin >>file; 
            infile.open(file.c_str());//opens the file
            infile >> file; //receives first name
            while(infile) //loops until no names left
            {
                DeleteTreap(Initial,file); //Delete corresponding name
                infile >> file; //gets new name
            }
            infile.close(); // close input file
            OutputTreap(Initial,outfile); //Output the contents of Treap
            NodeCount = 0; //initialize the NodeCount and height of treap
            Height = 0;
            TreapCount(Initial,NodeCount,Height); //calculates height and nodecount
            outfile << "The NodeCount = " << NodeCount << " and the height is " << Height << endl; //output
        }
        cout << "Enter a Command "<< endl; //prompts user for next Choice command
        cin>>Choice;

    }




	return 0;
}


void LoadTreap(TreapType*& Starting) // Loads all the names into the Treap and Sorts them as they're being added
{
	ifstream infile; // input file
	string filename; //file name
	string Ident,file; //used for names
	bool Confir; //used to check if name exists in the treap already
	TreapType* Nodie; //placeholder Nodes for navigation

	cout<< "Please enter a file name" << endl; //prompt for file name
	cin >> file;

	infile.open(file.c_str()); // open file

	srand((unsigned) time(0)); //generates seed for randomized priority

	infile >> Ident; //get first name
	if(Starting->priority == 101) //checks for the initial node and turns first name into initial node
	{
		Starting = new TreapType;
		Starting->name=Ident;
		Starting->priority = rand()%100+1;
		Starting->left = NULL;
		Starting->right = NULL;
		Starting->parent = NULL;
		infile >>Ident;
	}




	while (infile) //loops until no names left in file
	{
		Nodie = new TreapType; //create new node
		Nodie->name=Ident;
		Nodie->priority = rand()%100+1;
		Nodie->left = NULL;
		Nodie->right = NULL;
		Nodie->parent = NULL;

        Confir = InTreap(Starting,Nodie->name); //checks to see if the name is in the treap already
        if(Confir == false) //only executes if name is not in the treap
        {
            LeftorRight(Starting,Nodie); //places name in treap without considering priority
            SortTreap(Starting,Nodie); // Sorts the Node by heap order
        }
		infile>>Ident; //get next name
	}
	infile.close(); //close input file


}



void DeleteTreap(TreapType*& Starting, string Item) // Deletes a name from the treap
{
	TreapType* Nodie,*Replacement,*Parent; //placeholder nodes for navigation
	bool exists; //used to check if name exists in treap
	string N; //used for comparison and navigation of nodes
	string P,R; //same as above


	exists = InTreap(Starting, Item); //checks if the name is in the treap

	if (exists == false) //if name is not in treap, return
	{
		return;
	}
	else //if name is in the treap, commence deletion
	{

		Nodie = Starting; //initial node is set as starting point
		N = Nodie->name; //gets the string of Nodie
		while(N.compare(Item)!=0) //loops and compares until the name is found
        {
            if(Item.compare(N) > 0) //navigates to the right 
            {
                Nodie = Nodie->right;
            }
            if(Item.compare(N) < 0) //navigates to the left
            {
                Nodie = Nodie->left;
            }
            N = Nodie->name; //update string
        }

		if(Nodie->right == NULL and Nodie->left == NULL) //holds true if the target node has no children
		{
		    Replacement = Nodie->parent; // navigate to parent of target node
		    if(Replacement->right == Nodie) //checks if the target node is on the right leaf
            {
                Replacement->right = NULL; //set to NULL
            }
            else //checks if the target node is on the left leaf
            {
                Replacement->left = NULL; //set to NULL
            }
			delete Nodie; //delete node
		}
		else if(Nodie->right ==NULL or Nodie->left == NULL) //true if either left or right is a NULL
		{
			if(Nodie->right == NULL) //true if only right is NULL
			{
				Replacement == Nodie->left; //gets left leaf of target node
				if(Nodie==Starting) //checks to see if the target node is the initial node
				{
					Starting = Replacement;
					delete Nodie;
					Replacement->parent = NULL;
				}
				else 
				{
					Parent = Nodie->parent; //get parent node

					P=Parent->name; //set string of parent node
					R=Replacement->name; //set string of replacement node
					if(P.compare(R)>0) //true if Parent is bigger than replacement
					{
						Parent->left = Replacement; //set left leaf of Parent to replacement
						delete Nodie; //delete the target node
						Replacement->parent = Parent; //sets the parent of replacement to Parent
					}
					else if(P.compare(R)<0) //true if Parent is smaller than replacement
					{
						Parent->right = Replacement;//set right leaf of Parent to replacement
						delete Nodie;//delete the target node
						Replacement->parent = Parent;//sets the parent of replacement to Parent
					}
				}
			}
			else if(Nodie->left == NULL)//true if only left is NULL
			{
				Replacement = Nodie->right;//gets right leaf of target node
				if(Nodie==Starting)//checks to see if the target node is the initial node
				{
					Starting = Replacement;
					Replacement->parent = NULL;
					delete Nodie;
				}
				else
				{

					Parent = Nodie->parent;//get parent node
					P=Parent->name;//set string of parent node
					R=Replacement->name;//set string of replacement node
					if(P.compare(R)>0)//true if Parent is bigger than replacement
					{
						Parent->left = Replacement;//set left leaf of Parent to replacement
						delete Nodie;//delete the target node
						Replacement->parent = Parent;//sets the parent of replacement to Parent
					}
					else if(P.compare(R)<0)//true if Parent is smaller than replacement
					{
						Parent->right = Replacement;//set right leaf of Parent to replacement
						delete Nodie;//delete the target node
						Replacement->parent = Parent;//sets the parent of replacement to Parent
					}
				}
			}
		}
		else //true if neither left or right of target node are NULL
		{
			while(Nodie->left !=NULL or Nodie->right!= NULL) //loops until left and right nodes are NULL
            {
                if(Nodie->left->priority > Nodie->right->priority ) //true if left has bigger priority
                {
                    RightRotate(Nodie,Nodie->left); //Rotate right
                }
                else if(Nodie->left->priority < Nodie->right->priority) //true if right has bigger priority
                {
                    LeftRotate(Nodie,Nodie->right); //Rotate left
                }
            }

			Nodie->parent = Replacement; // gets parent of target
			if(Replacement->right == Nodie) //set to NULL if target is on right
            {
                Replacement->right == NULL;
            }
            else //set to NULL if target is on left
            {
                Replacement->left == NULL;
            }

		}

	}

}
void RightRotate(TreapType*& Right,TreapType*& Left) //Right Rotation for heap sorting
{
	TreapType* LeftNode,*MiddleNode,*RightNode,*Parent; //placeholders

	if(Left->right!=NULL) //if no right leaf on the Left node exists
	{
		MiddleNode = Left->right;
		MiddleNode->parent = Right;
		Right->left = MiddleNode;
	}
    if(Right->parent!=NULL) // only true if the Right node has a parent
    {
        Parent = Right->parent;



        if(Parent->right == Right)
        {
            Parent->right = Left;
        }
        else if(Parent->left == Right)
        {
            Parent->left = Left;
        }
    }
    Left->parent = Right->parent; //set Left's parent to Right's
	Right->parent = Left; // set Right's parent as Left
	if(Left->right == NULL) //only true if MiddleNode does not exist
    {
        Right->left = NULL;
    }
	Left->right = Right; //sets the Left's right leaf to Right

}
void LeftRotate(TreapType*& Left,TreapType*& Right) //Left Rotation
{
	TreapType* LeftNode,*MiddleNode,*RightNode,*Parent; //placeholders
	if(Right->left!=NULL) //only true if there exists a left leaf on the Right node
	{
		MiddleNode = Right->left;
		MiddleNode->parent = Left;
		Left->right = MiddleNode;
	}

    if(Left->parent!=NULL) //only true if there is a parent on the Left node
    {
        Parent = Left->parent;



        if(Parent->right == Left and Parent!= NULL) 
        {
            Parent->right = Right;
        }
        else if(Parent->left == Left and Parent!= NULL)
        {
            Parent->left = Right;
        }

    }
    Right->parent = Left->parent;//set Right's parent to Left
    Left->parent = Right;//set Left's parent to the Right node
    if(Right->left == NULL) //only true if a middle node does not exist
    {
        Left->right = NULL;
    }
    Right->left = Left; // sets the Right's left leaf to Left node

}
void LeftorRight(TreapType*& Starting, TreapType*& Insert) //navigates and adjusts which place a node should be placed in a tree
{
	TreapType* nav; //placeholder for navigation
	nav = Starting; //set nav to the starting node
	string I,N; //placeholders used for comparison 
	I = Insert->name; // gets the string of Inserted node
	while(nav->right != NULL or nav->left !=NULL) //loops until it reaches a node with no children or one child
	{
	    N = nav->name; //gets string of navigation node

		if(I.compare(N)> 0) //go right if the value is larger than the current node
		{
			if(nav->right==NULL) //if there is no node to the right, insert the node to the right
			{
				nav->right = Insert;
				Insert->parent = nav;
				return;
			}
			else //else, keep going right
			{
				nav = nav->right;
			}

		}
		if(I.compare(N) < 0) //go left if the value is smaller than the current node
		{
			if(nav->left==NULL) //if there is no node to the left, insert the node to the left
			{
				nav->left = Insert;
				Insert->parent = nav;
				return;
			}
			else //else keep going left
			{
				nav = nav->left;
			}
		}
	}
        N = nav->name; //condition holds if no way to move left or right in tree
        if(Insert==Starting) //sets the node as initial if it's the only thing inserted
        {
            return;
        }
        if(I.compare(N) > 0 and nav->right == NULL) //if the value is bigger than current node, and no way to go right, add it to the right
		{
			if(nav->right==NULL)
			{
				nav->right = Insert;
				Insert->parent = nav;
				return;
			}
			

		}
		else if(Insert->name < nav->name and nav->left == NULL) //if the value is smaller than the current node, and not way to go left, add it to the left
		{
			if(nav->left==NULL)
			{
				nav->left = Insert;
				Insert->parent = nav;
				return;
			}
			
		}

}
void SortTreap(TreapType*& Starting,TreapType*& Focus) //Sorts the treap into heap order, given a node to sort
{
	TreapType* Parent; //placeholder


    if(Focus->parent == NULL) //true if the node is the initial node
    {
        Starting = Focus;
        return;
    }
    Parent = Focus->parent; //gets Focus' parent
    string P = Parent->name; //gets string of the parent
	string F = Focus->name;//gets the string of the Focus node



	if(P.compare(F) < 0 and Parent->priority < Focus->priority) // Rotate left if parent is smaller than the Focus node and has lower priority
	{
		LeftRotate(Parent,Focus); 
		SortTreap(Starting,Focus); //continues recursively until condition is no longer true
	}

	else if(P.compare(F) > 0 and Parent->priority < Focus->priority)// Rotate right if parent is bigger than the Focus node and has lower priority
	{
		RightRotate(Parent,Focus);
		SortTreap(Starting,Focus);//continues recursively until condition is no longer true
	}

	if(Focus->parent == NULL) //sets the Focus' parent to NULL if it becomes the initial node
    {
        Starting = Focus;
    }
}
bool InTreap(TreapType* Starting, string Findit) //checks to see if the item is in the treap
{
	TreapType* nav;
	string N;
	nav = Starting;
	while(nav->right!=NULL or nav->left!=NULL) //continues if there are 2 children or 1 child 
	{
	    N = nav->name;
		if(N.compare(Findit) < 0 and nav->right !=NULL) // navigates to right if the item is bigger
		{
			nav = nav->right;
		}
		else if(N.compare(Findit) > 0 and nav->left !=NULL) //navigates to the left if the item is smaller
		{
			nav = nav->left;
		}
		N=nav->name; //updates string
		if(N.compare(Findit)==0) //returns true if the item exists
        {
            return true;
        }
        else if(N.compare(Findit) < 0 and nav->right==NULL) //return false if the value is bigger but a NULL node to the right
        {
            return false;
        }
        else if(N.compare(Findit) > 0 and nav->left == NULL)//return false if the value is smaller but a NULL node to the left
        {
            return false;
        }

	}
	N=nav->name; //holds true if both children in nav node are NULL
	if(N.compare(Findit)==0) //only true if the current node is the item
    {
        return true;
    }
    else //false if otherwise
    {
        return false;
    }
}
void OutputTreap(TreapType*& Starting, ofstream& outfile) //Outputs all the names in InOrder format
{
	if(Starting->right !=NULL)
	{
		OutputTreap(Starting->right,outfile);//recursively outputs items from the right
	}
	outfile << Starting->name << endl; //output
	if(Starting->left != NULL)
	{
		OutputTreap(Starting->left,outfile); //recursively outputs items from the left
	}
}
void TreapCount(TreapType*& Starting, int& NodeCount, int& Height) //gets height and nodecount
{
		int Z = Height; //get the heights
		int Y = Height;
		if(Starting->left !=NULL) //true if you can still navigate to the left
		{
		    Z++; //increment height
			TreapCount(Starting->left,NodeCount,Z); //recursively navigates to the left
		}

		NodeCount++; //increase node count

		if(Starting->right!=NULL) //true if you can still navigate to the right
		{
		    Y++; //increment height
			TreapCount(Starting->right,NodeCount,Y);
		}
		if(Z > Height) //replaces the current height value with the largest one
		{
			Height = Z;
		}
		else if(Y > Height) //same as above
		{
			Height = Y;
		}
}
