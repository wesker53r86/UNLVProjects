#include <iostream>
#include <fstream>

using namespace std;

struct node  //Node template
{
	int value;
	node *link;
};





int main()
{
	ifstream infile; //variables used for filestreams
	ofstream outfile;

	char filename[50]; //place for characters of input file
	int n,j,k,s,y; // placeholder variables
	int val;
	node *outneigh[100]; //outneighbor array
	bool visited[100]; //array used to keep track of visited variables
	node *first, *newNode = new node, *last = new node, *curr = new node , *dumnode = new node; // node placeholders


	cout << "Enter a file name" << endl; //prompts the user for the file
	cin >> filename; //gets input 
	cout << endl;

	infile.open(filename); //opens the input file
	infile >> n; //gets the amount of nodes

	infile >> j; //gets the node
	infile >> k; //gets the neighbor nodes

	for(int i=0;i<n;i++)
    {
        outneigh[i] = NULL; //sets all the addresses in the array for the nodes to NULL
	}



	while(infile) //loop that places all the neighbor nodes in their appropriate position in the array as a linked list.
	{

		curr = outneigh[j]; //sets the curr node to the first part of the jth linked list (j can be from 0 through n-1)


		if(outneigh[j]!=NULL) //checks if the first part of the linked list is NULL
		{
		    while (curr->link!=NULL) //if not NULL, loops to the part where the next member of the linked list is a NULL 
                {
                    curr = curr->link; // moves to the next node in the linked list
                }
		}


        newNode= new node; // provides address for newNode
		newNode->value = k; // sets the value for newNode 
		newNode->link = NULL; //sets the link to null
		if(outneigh[j]==NULL) //condition if the first node is NULL
        {
            outneigh[j]=newNode; //insert the node directly into the array
        }
        else
        {
            curr->link=newNode; // sets the link from the curr to the newNode
        }


		infile >> j; //gets new values
		infile >> k;

	}

	outfile.open("HW3.txt"); //opens the output file

	s=0;

	while (s<n) //prints out the outNeigh array
    {
        outfile << s << ": ";
        curr = outneigh[s];
        while (curr!=NULL)
        {

            outfile << curr->value << " ";
            curr = curr->link;

        }
        outfile << endl;
        s++;
    }


	dumnode = new node; //dummy node
	dumnode->value = NULL;
	dumnode->link = dumnode;
    first=dumnode;



	s=0;//sets 0 as the first node to visit
	visited[s] = true;

    curr = outneigh[s];
    j=0; //queue possition
    k=0; //visits

	while(k<=j) //as long as visits is less than the number of items queued, loop
	{
		while(curr!=NULL) //as long as curr is not null loop
		{
			y=curr->value;
			if(visited[y] != true) // as long as the y value is not visited, adds it to the queue
			{
			    newNode=new node;
				newNode->value = y;
				newNode->link = dumnode;
				first->link = newNode;
				visited[y] = true;
				j++;
				first = newNode;

			}
			curr=curr->link; //gets the next part of the linked list
		}
		outfile << s << " "; //prints the dequed value
		last=dumnode->link;
		s=last->value;
		dumnode->link = last->link;
		delete last;
		curr = outneigh[s];
		k++;
	}







    outfile.close();





	return 0;
}
